#!/bin/zsh
# shellcheck shell=bash
#-------------system arch-------------
SYSARCH="$(uname -m)"
#-------------headers-------------
headermain() {
	if [ "$1" != "" ]; then
		TARGET="$1"
		#lowercase of $TARGET
		target="$(echo "$TARGET" | tr '[:upper:]' '[:lower:]')"
		#logfile
		LOGFILE="$HOME/.local/logs/${target}built.txt"
		
		# Ensure log directory exists
		mkdir -p "$HOME/.local/logs" || error "Failed to create log directory"
		
		#finally the header
		echo
		echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tBUILDING $TARGET\t\t$(tput sgr 0)"
		echo
		date +%y-%m-%d-%H:%M
		echo "logfile at $LOGFILE"
		echo
	else
		error "headermain function requires argument"
	fi
}

header() {
	if [ "$1" != "" ]; then
		HEADER="$1"
		echo
		echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tbuilding for $HEADER\t$(tput sgr 0)"
		echo
	else
		error "header function requires argument"
	fi
}

step() {
	if [ "$1" != "" ]; then
		STEPS="$1"
		echo
		echo -e "$(tput setab 2)$(tput bold)$(tput setaf 4)\t$STEPS\t$(tput sgr 0)"
		echo
	else
		error "step function requires argument"
	fi
}

alias deploy='echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tdeployment\t$(tput sgr 0)"'

#-------------compiler & flags-------------
# I have simple prefixes for each OS X arch (x86_64, arm64) in /opt/.
# Even though one could use one universal prefix with all libs "lipo'ed"
# it's easier to maintain different prefixes as they can have different 
# problems when updating the libs.
# For 64bit intel and arm64 Apple, I'm just using clang that comes with current Xcode.
# My SDK collection (10.4-15.5) is stored in /opt/SDKs

flags() {
	# Set default architecture if not specified
	if [ -z "$ARCH" ]; then
		if [ "$SYSARCH" = "arm64" ]; then
			ARCH="arm64"
			SDK="14.5"
			DEPLOYMENT="11.1"
		elif [ "$SYSARCH" = "x86_64" ]; then
			ARCH="x86_64"
			SDK="14.5"
			DEPLOYMENT="10.15"
		else
			error "Unsupported system architecture: $SYSARCH"
		fi
	fi

	export PKG_CONFIG_PATH="/opt/$ARCH/lib/pkgconfig"

	# Set architecture-specific optimization flags
	if [ "$ARCH" = "x86_64" ]; then
		OPTARCH='-m64 -O2 '
	elif [ "$ARCH" = "arm64" ]; then
		OPTARCH='-O2 '
	else
		error "Unsupported target architecture: $ARCH"
	fi
	
	OPT=" -w -headerpad_max_install_names $OPTARCH"
	SDK=" -isysroot /opt/SDKs/MacOSX$SDK.sdk -mmacosx-version-min=$DEPLOYMENT "
	export MACOSX_DEPLOYMENT_TARGET="$DEPLOYMENT"
	export CPPFLAGS="-I/opt/$ARCH/include$SDK"
	export CFLAGS="-I/opt/$ARCH/include$SDK $OPT"
	export CXXFLAGS="-I/opt/$ARCH/include $SDK $OPT"
	export LDFLAGS="-L/opt/$ARCH/lib $SDK $OPT"
	export LIBTOOLFLAGS="--silent"
}

gcc() {
	if [ -z "$ARCH" ]; then
		error "ARCH variable not set - call flags() first"
	fi
	
	export PATH="/opt/$ARCH/bin/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
	export LD="/usr/bin/ld"
	export RANLIB="$HOME/code/sh/tools/ranlib"
	export AR="$HOME/code/sh/tools/ar"
	export CC="/usr/bin/clang -arch $ARCH"
	export CXX="/usr/bin/clang++ -arch $ARCH"
}

#-------------dylibbundle and codesign for the libs-------------
dylibbundle() {
	# Validate required variables
	[ -n "$ARCH" ] || error "ARCH not set for dylibbundle"
	[ -n "$SYSARCH" ] || error "SYSARCH not set for dylibbundle"
	[ -n "$bundle_name" ] || error "bundle_name not set for dylibbundle"
	[ -n "$program" ] || error "program not set for dylibbundle"
	
	# Fix path so dylibbundler is in it and uses the build system install_name_tool
	if [ "$SYSARCH" != "$ARCH" ]; then
		PATH="/opt/$SYSARCH/bin/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/gtk3/bin"
		export PATH
	fi
	
	resources="$bundle_name/Contents/Resources/lib_"
	
	# Validate that the program binary exists
	[ -f "$program.$ARCH" ] || error "Program binary not found: $program.$ARCH"
	
	dylibbundler -b -ns -od -of -cd \
				-x "$program.$ARCH" \
				-d "$resources$ARCH/" \
				-p "@executable_path/../Resources/lib_$ARCH/" \
				-i /usr/lib/ \
				-s "/opt/$ARCH/lib" \
				&> /dev/null || error "dylibbundler failed for $program.$ARCH"
}
codesign_lib() {
	codesign \
			--options runtime \
			-f -s "Developer ID Application" \
			"$1"/*.dylib \
			&> /dev/null
}

#-------------Notarization-------------
notar() {
	BUNDLE_PKG="$1"
	xcrun notarytool submit --wait --keychain-profile 'notarize' "$BUNDLE_PKG"
	# Only run stapler staple for .dmg or .pkg files
	if [[ "$BUNDLE_PKG" == *.dmg || "$BUNDLE_PKG" == *.pkg ]]; then
		xcrun stapler staple "$BUNDLE_PKG"
	fi
}

#-------------command shortcuts-------------
alias autogen='./autogen.sh > /dev/null 2>&1'
alias autore='autoreconf -i "$SOURCE_PATH"'

makes() {
	# Clean previous build
	make clean > /dev/null
	
	# Get CPU count more reliably
	local ncpu
	if command -v nproc >/dev/null 2>&1; then
		ncpu=$(nproc)
	else
		ncpu=$(sysctl -n hw.ncpu)
	fi
	
	# Validate AR tool exists
	[ -f "$HOME/code/sh/tools/ar" ] || error "AR tool not found: $HOME/code/sh/tools/ar"
	
	# Run make with parallel jobs
	make -j"$ncpu" -s AR="$HOME/code/sh/tools/ar" > /dev/null || error "$HEADER make failed"
}

alias lockfile='rm -f $HOME/.local/"$TARGET"build1.lockfile'

config() {
	# Set default source path if not specified
	if [ -z "$SOURCE_PATH" ]; then
		SOURCE_PATH="."
	fi
	
	# Validate that configure script exists
	[ -f "$SOURCE_PATH/configure" ] || error "configure script not found in $SOURCE_PATH"

	#if [ "$CONF_OPT" != "" ]; then
	#	c1=$CONF_OPT
	#fi
	#if [ "$CONF_ARGS" != "" ]; then
	#	c2=$CONF_ARGS
	#fi

	# Configure based on architecture and cross-compilation needs
	if [[ "$ARCH" = "arm64" ]] && [[ "$SYSARCH" != "arm64" ]]; then
		# shellcheck disable=SC2086
		"$SOURCE_PATH"/configure --host=arm-apple-darwin ${=CONF_OPT} ${=CONF_ARGS} || error "$ARCH" configure

	elif [[ "$ARCH" = "x86_64" ]] && [[ "$SYSARCH" != "x86_64" ]]; then
		# shellcheck disable=SC2086
		"$SOURCE_PATH"/configure --host=x86_64-apple-darwin ${=CONF_OPT} ${=CONF_ARGS} || error "$ARCH" configure

	else
		# shellcheck disable=SC2086
		"$SOURCE_PATH"/configure ${=CONF_OPT} ${=CONF_ARGS} || error "$ARCH" configure
	fi
}

# stripp file -p optional new path to strip to
# with -p the just the filename is extracted in case there's a path prefix
stripp() {
	local input_file=$1
	local output_path=""
	local output_file=""

	# Check if there's a path prefix specified with -p
	if [ "$2" = "-p" ] && [ -n "$3" ]; then
		output_path="$3"
		# Get just the filename without the directory path
		local basename
		basename=$(basename "$input_file")

		if [ "$ARCH" != "" ]; then
			output_file="${output_path}${basename}.$ARCH"
		else
			output_file="${output_path}${basename}"
		fi
	else
		# Use original behavior
		if [ "$ARCH" != "" ]; then
			output_file="$input_file.$ARCH"
		else
			output_file="$input_file"
		fi
	fi

	# Run strip command
	strip "$input_file" -o "$output_file" || error "$input_file" stripp
}

# stripp_all ${#binaries[@]} (set with binaries=(file 1 file 2 ...))
# -p optional new path to strip to
# with -p the just the filename is extracted in case there's a path prefix
stripp_all() {
	local binaries=()
	local path_prefix=""
	local path_prefix_flag=0

	# Process arguments to separate binaries and path prefix
	for arg; do
		if [ "$path_prefix_flag" -eq 1 ]; then
			path_prefix="$arg"
			path_prefix_flag=0
			continue
		fi

		if [ "$arg" = "-p" ]; then
			path_prefix_flag=1
			continue
		else
			binaries+=("$arg")
		fi
	done

	if [ ${#binaries[@]} -eq 0 ]; then
		error "No binaries provided" stripp_all
		return 1
	fi

	# Process each binary with the optional path prefix
	for binary in "${binaries[@]}"; do
		if [ -n "$path_prefix" ]; then
			stripp "$binary" -p "$path_prefix"
		else
			stripp "$binary"
		fi
	done
}

build() {
	config
	makes
	#stripp $program
}


lipo_build() {
	local file_array=()
	local process_files=0
	local archs=()

	# Validate arguments
	if [ $# -eq 0 ]; then
		error "No arguments provided to lipo_build"
	fi

	# First pass: collect architectures and files
	for arg; do
		if [[ $process_files -eq 1 ]]; then
			# Add to file array
			file_array+=("$arg")
			continue
		fi

		if [[ "$arg" == "-f" ]]; then
			# Next arguments will be files to process
			process_files=1
			continue
		elif [[ "$arg" != "-f" ]]; then
			# Collect architectures
			archs+=("$arg")
		fi
	done

	# Validate we have both architectures and files
	if [[ ${#archs[@]} -eq 0 ]]; then
		error "No architectures specified for lipo_build"
	fi
	
	if [[ ${#file_array[@]} -eq 0 ]]; then
		error "No files specified for lipo_build (use -f flag)"
	fi

	# Process each file
	for file in "${file_array[@]}"; do
		local lipos=""
		local found_files=0
		
		# Build architecture arguments for this file
		for arch in "${archs[@]}"; do
			local arch_file="$file.$arch"
			if [[ -f "$arch_file" ]]; then
				lipos="$lipos -arch $arch $arch_file"
				found_files=$((found_files + 1))
			else
				echo "WARNING: Architecture file does not exist: $arch_file"
			fi
		done
		
		# Run lipo command if we have at least one input file
		if [[ $found_files -gt 0 ]]; then
			# shellcheck disable=SC2086
			lipo -create ${=lipos} -output "$file" || error "lipo failed for $file"
		else
			error "No valid architecture inputs found for $file"
		fi
	done
}

#-------------Error handling-------------
#trap CTRL-C and exit, this way it is removing the lockfile when I ctrl-c a script started by Mail.app
trap ctrl_c SIGINT
ctrl_c() {
	exit
}

finish() {
	rm -f "$NOTARIZE_APP_LOG" "$NOTARIZE_INFO_LOG" "$HOME"/.local/"$TARGET"build1.lockfile
}
trap finish EXIT

mailresult() {
	#send the logfile to mail address ERRORMAIL - define somewhere
	if [ "$TARGET" != "" ] && [ "$ERRORMAIL" != "" ] && [ -f "$LOGFILE" ]; then

		# To configure mail/sendmail/postfix, follow the guide at 
		# http://www.developerfiles.com/how-to-send-emails-from-localhost-mac-os-x-el-capitan/
		# For OS X 10.11 you will need to change smtp_sasl_mechanism_filter=plain to =login
		
		# if the name of the result mail sender should be the the same as the logged in $USER, 
		# use "mail", if you need to use a different sender name use "sendmail"
		
		mail -Es "$TARGET"" build $1" "$ERRORMAIL" < "$LOGFILE"
		#(echo "Subject: iMac - "$TARGET" build "$1""; cat $LOGFILE | uuencode $LOGFILE) | sendmail -F "Buildbot" -t $ERRORMAIL
	fi
}

error () {
	if [ "$?" != "0" ]; then
		if [ "$2" != "" ]; then
			local i2=" $2"
		fi
		if [ "$3" != "" ]; then
			local i3=" $3"
		fi
		echo
		echo -e "$(tput setab 1)$(tput bold)$(tput setaf 7)\t\t***Error***\t\t\t$(tput sgr 0)"
		echo -e "$(tput setab 1)$(tput bold)$(tput setaf 7)\t${1:-"Unknown Error"}${i2}${i3} failed!\t\t$(tput sgr 0)" 1>&2
		echo -e "$(tput setab 1)$(tput bold)$(tput setaf 7)\t\t***Error***\t\t\t$(tput sgr 0)"
		echo
		lockfile
		if [ "$BUILDBOT" = "1" ]; then
			mailresult failure
		fi
		exit 1
	fi
}

success () {
	lockfile
	if [ "$BUILDBOT" = "1" ]; then
		mailresult succeeded
	fi
	echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tBUILD COMPLETE\t\t$(tput sgr 0)"
}

pipestatus() {
	local S=("${PIPESTATUS[@]}")
	if test -n "$*"
	then test "$*" = "${S[*]}"
	else ! [[ "${S[*]}" =~ [^0\ ] ]]
	fi
}

teelog() {
	# Ensure LOGFILE is set
	if [ -z "$LOGFILE" ]; then
		# If no LOGFILE is set, just pass through to stdout/stderr
		cat
		return
	fi
	
	if [ "$1" = "-a" ]; then
		# Append mode: teelog -a (append to LOGFILE)
		tee -a "$LOGFILE"
	elif [ -n "$1" ]; then
		# File specified: teelog filename (write to specified file)
		tee "$1"
	else
		# No arguments: just log to LOGFILE (overwrite)
		tee "$LOGFILE"
	fi
}

#-------------debug-------------
echoall() {
	echo "ARCH=""$ARCH"
	echo "SDK=""$SDK"
	echo "OPT=""$OPT"
	echo "MACOSX_DEPLOYMENT_TARGET=""$MACOSX_DEPLOYMENT_TARGET"
	echo "PATH=""$PATH"
	echo "CC=""$CC"
	echo "CXX=""$CXX"
	echo "CPPFLAGS=""$CPPFLAGS"
	echo "CFLAGS=""$CFLAGS"
	echo "CXXFLAGS=""$CXXFLAGS"
	echo "LDFLAGS=""$LDFLAGS"
	echo "PKG_CONFIG_PATH=""$PKG_CONFIG_PATH"
	echo "PKG_CONFIG=""$PKG_CONFIG"
	echo "LD=""$LD"
	echo "AR=""$AR"
	echo "RANLIB=""$RANLIB"
	echo "CONF_OPT=""$CONF_OPT" 
	echo "CONF_ARGS=""$CONF_ARGS"
	echo "LIPO ARGS=""$lipos"
}
