#-------------headers-------------
headermain() {
	if [ "$1" != "" ]; then
		TARGET=$1
		#lowercase of $TARGET
		target="$(echo $TARGET | tr '[A-Z]' '[a-z]')"
		#logfile
		LOGFILE=~/.local/logs/${target}built.txt
		#finally the header
		echo
		echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tBUILDING $TARGET\t\t$(tput sgr 0)"
		echo
		echo `date +%y-%m-%d-%H:%M`
		echo "logfile at $LOGFILE"
		echo
	else
		error headermain function
	fi
}

header() {
	if [ "$1" != "" ]; then
		HEADER=$1
		echo
		echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tbuilding for $HEADER\t$(tput sgr 0)"
		echo
	else
		error header function
	fi
	
}

alias deploy='echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tdeployment\t$(tput sgr 0)"'

#-------------compiler & flags-------------
# I have simple prefixes for each OS X arch (ppc, i386, x86_64, arm64) in /opt/.
# Even though one could use one universal prefix with all libs "lipo'ed"
# it's easier to maintain different prefixes as they can have different 
# problems when updating the libs.
# For building ppc, I'm using the old Xcode 3.x stored in /opt/xcode3.
# For 32/64bit intel, I'm just using clang that comes with current Xcode.
# My SDK collection (10.4-11.1) is stored in /opt/SDKs

flags() {
	SYSARCH=$(uname -m)
	if  [ "$ARCH" = "" ] && [ "$SYSARCH" = "arm64" ]; then
		ARCH=arm64
		SDK=11.0
		DEPLOYMENT=11.0
	elif [ "$ARCH" = "" ] && [ "$SYSARCH" = "x86_64" ]; then
		ARCH=x86_64
		SDK=10.15
		DEPLOYMENT=10.10
	fi

	export PKG_CONFIG_PATH=/opt/$ARCH/lib/pkgconfig
	export PKG_CONFIG=/opt/$SYSARCH/bin/pkg-config

	if [ "$ARCH" = "i386" ]; then
		OPTARCH='-arch i386 -m32 -msse -msse2 -O2 '
	elif [ "$ARCH" = "ppc" ]; then
		OPTARCH='-arch ppc -m32 -O2 '
		export PKG_CONFIG=/opt/x86_64/bin/pkg-config
	elif  [ "$ARCH" = "x86_64" ]; then
		OPTARCH='-m64 -msse -msse2 -O2 '
	elif  [ "$ARCH" = "arm64" ]; then
		OPTARCH='-O2 '
	fi
	OPT=' -w -force_cpusubtype_ALL '$OPTARCH
	SDK=' -isysroot /opt/SDKs/MacOSX'$SDK'.sdk -mmacosx-version-min='$DEPLOYMENT' '
	export MACOSX_DEPLOYMENT_TARGET=$DEPLOYMENT
	export CPPFLAGS='-I/opt/'$ARCH'/include'$SDK
	export CFLAGS='-I/opt/'$ARCH'/include'$SDK' '$OPT
	export CXXFLAGS='-I/opt/'$ARCH'/include '$SDK' '$OPT
	export LDFLAGS='-L/opt/'$ARCH'/lib'$SDK' '$OPT
	export LIBTOOLFLAGS=--silent
}

gcc() {
	if [ "$ARCH" != "" ]; then
		export PATH=/opt/$ARCH/bin/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
		export LD="/usr/bin/ld"
		export RANLIB="~/code/sh/tools/ranlib"
		export AR="~/code/sh/tools/ar"
		if [ "$1" = "legacy" ]; then
			export PATH=/opt/$ARCH/bin/:/opt/xcode3/usr/bin:/opt/xcode3/usr/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
			export CC='/opt/xcode3/usr/bin/llvm-gcc-4.2 -arch '$ARCH
			export CXX='/opt/xcode3/usr/bin/llvm-g++-4.2 -arch '$ARCH
			export LD="/opt/xcode3/usr/bin/ld"
			export RANLIB="/opt/xcode3/usr/bin/ranlib.old"
			export AR="/opt/xcode3/usr/bin/ar"
		elif [ "$1" = "oldgcc" ]; then
			export PATH=/opt/$ARCH/bin/:/opt/xcode3/usr/bin:/opt/xcode3/usr/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
			export CC='/opt/xcode3/usr/bin/gcc-4.2 -arch '$ARCH
			export CXX='/opt/xcode3/usr/bin/g++-4.2 -arch '$ARCH
			export LD="/opt/xcode3/usr/bin/ld"
			export RANLIB="/opt/xcode3/usr/bin/ranlib.old"
			export AR="/opt/xcode3/usr/bin/ar"
		else
			export CC='/usr/bin/clang -arch '$ARCH
			export CXX='/usr/bin/clang++ -arch '$ARCH
		fi
	else
		error gcc function
	fi
}

#-------------dylibbundle and codesign for the libs-------------
dylibbundle() {
	#fix path so dylibbundler is in it and uses the correct install_name_tool
	if [ "$ARCH" != "x86_64" ]; then
		export PATH=/opt/x86_64/bin/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
	fi
	resources=$bundle_name/Contents/Resources/lib_
	dylibbundler -od -b -x $program.$ARCH -d $resources$ARCH/ -p @executable_path/../Resources/lib_$ARCH/ -i /usr/lib/ > /dev/null
}
codesign_lib() {
	codesign --options runtime -f -s "Developer ID Application" $resources$ARCH/*.dylib
}

#-------------command shortcuts-------------
alias autogen='./autogen.sh > /dev/null 2>&1'

alias makes="make clean  > /dev/null ; make -j$(sysctl hw.ncpu | awk '{print $2 +1}') -s AR="~/code/sh/tools/ar" > /dev/null || error $HEADER make"

alias lockfile='rm -f ~/.local/"$TARGET"build1.lockfile'

config() {
	if [ "$CONF_OPT" != "" ]; then
		c1=$CONF_OPT
	fi
	if [ "$CONF_ARGS" != "" ]; then
		c2=$CONF_ARGS
	fi
		
	if [ "$ARCH" = "ppc" ]; then
		./configure --host=powerpc-apple-darwin ${=CONF_OPT} ${=CONF_ARGS} || error $ARCH configure

	elif [ "$ARCH" = "i386" ]; then
		./configure --host=i386-apple-darwin ${=CONF_OPT} ${=CONF_ARGS} || error $ARCH configure

	elif [[ "$ARCH" = "arm64" ]] && [[ "$SYSARCH" != "arm64" ]]; then
		./configure --host=arm-apple-darwin ${=CONF_OPT} ${=CONF_ARGS} || error $ARCH configure

	elif [[ "$ARCH" = "x86_64" ]] && [[ "$SYSARCH" != "x86_64" ]]; then
		./configure --host=x86_64-apple-darwin ${=CONF_OPT} ${=CONF_ARGS} || error $ARCH configure

	else [ "$?" != "0" ]
		./configure ${=CONF_OPT} ${=CONF_ARGS} || error $ARCH configure
	fi
}

stripp() {
	if [ "$ARCH" != "" ]; then
		strip $program -o $program.$ARCH || error $HEADER strip
	else
		strip $program -o $program || error $program strip
	fi
}

build() {
	config
	makes
	stripp
}

lipo_build() {
	arg1=$1; 
	for arg; do 
		lipos="-arch $arg $program.$arg "$lipos; 
	done
	lipo -create ${=lipos} -output $program  ||  error lipo
}

#-------------Error handling-------------
#trap CTRL-C and do something but it's not working yet when in teelog function
#trap ctrl_c SIGINT
#ctrl_c() {
#	echo "** Trapped CTRL-C"
#}

mailresult() {
	#send the logfile to mail address ERRORMAIL - define somewhere
	if [ "$TARGET" != "" ] && [ "$ERRORMAIL" != "" ] && [ -f "$LOGFILE" ]; then

		# To configure mail/sendmail/postfix, follow the guide at 
		# http://www.developerfiles.com/how-to-send-emails-from-localhost-mac-os-x-el-capitan/
		# For OS X 10.11 you will need to change smtp_sasl_mechanism_filter=plain to =login
		
		# if the name of the result mail sender should be the the same as the logged in $USER, 
		# use "mail", if you need to use a different sender name use "sendmail"
		
		mail -Es $TARGET" build "$1"" $ERRORMAIL < $LOGFILE
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
		mailresult failure
		exit 1
	fi
}

success () {
	echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tBUILD COMPLETE\t\t$(tput sgr 0)"
	lockfile
	mailresult succeded
}

pipestatus() {
	local S=("${pipestatus[@]}")
	if test -n "$*"
	then test "$*" = "${S[*]}"
	else ! [[ "${S[@]}" =~ [^0\ ] ]]
	fi
}

teelog() {
	tee $1 $LOGFILE
}

#-------------debug-------------
echoall() {
	echo "ARCH="$ARCH
	echo "SDK="$SDK
	echo "OPT="$OPT
	echo "MACOSX_DEPLOYMENT_TARGET="$MACOSX_DEPLOYMENT_TARGET
	echo "PATH="$PATH
	echo "CC="$CC
	echo "CXX="$CXX
	echo "CPPFLAGS="$CPPFLAGS
	echo "CFLAGS="$CFLAGS
	echo "CXXFLAGS="$CXXFLAGS
	echo "LDFLAGS="$LDFLAGS
	echo "PKG_CONFIG_PATH="$PKG_CONFIG_PATH
	echo "PKG_CONFIG="$PKG_CONFIG
	echo "LD="$LD
	echo "AR="$AR
	echo "RANLIB="$RANLIB
	echo "CONF_OPT="$CONF_OPT 
	echo "CONF_ARGS="$CONF_ARGS
	echo "LIPO ARGS="$lipos
}
