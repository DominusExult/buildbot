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
flags() {
	if  [ "$ARCH" = "" ]; then
		ARCH=x86_64
		SDK=10.11
		DEPLOYMENT=10.11
	fi

	export PKG_CONFIG_PATH=/opt/$ARCH/lib/pkgconfig
	export PKG_CONFIG=/opt/$ARCH/bin/pkg-config

	if [ "$ARCH" = "i386" ]; then
		OPTARCH='-arch i386 -m32 -msse -msse2 -O2 '
	elif [ "$ARCH" = "ppc" ]; then
		OPTARCH='-arch ppc -m32 -O2 '
		export PKG_CONFIG=/opt/x86_64/bin/pkg-config
	elif  [ "$ARCH" = "x86_64" ]; then
		OPTARCH='-m64 -msse -msse2 -O2 '
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
		export AR="/opt/xcode3/usr/bin/ar"
		export RANLIB="/opt/xcode3/usr/bin/ranlib"
		if [ "$1" = "legacy" ]; then
			export PATH=/opt/$ARCH/bin/:/opt/xcode3/usr/bin:/opt/xcode3/usr/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
			export CC='/opt/xcode3/usr/bin/llvm-gcc-4.2 -arch '$ARCH
			export CXX='/opt/xcode3/usr/bin/llvm-g++-4.2 -arch '$ARCH
			export LD="/opt/xcode3/usr/bin/ld"
			export RANLIB="/opt/xcode3/usr/bin/ranlib.old"
		elif [ "$1" = "oldgcc" ]; then
			export PATH=/opt/$ARCH/bin/:/opt/xcode3/usr/bin:/opt/xcode3/usr/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
			export CC='/opt/xcode3/usr/bin/gcc-4.2 -arch '$ARCH
			export CXX='/opt/xcode3/usr/bin/g++-4.2 -arch '$ARCH
			export LD="/opt/xcode3/usr/bin/ld"
			export RANLIB="/opt/xcode3/usr/bin/ranlib.old"
		elif [ "$1" = "arch" ]; then
			export CC='/usr/bin/clang -arch '$ARCH
			export CXX='/usr/bin/clang++ -arch '$ARCH
		else
			export CC='/usr/bin/clang'
			export CXX='/usr/bin/clang++'
		fi
	else
		error gcc function
	fi
}

#-------------command shortcuts-------------
alias autogen='./autogen.sh > /dev/null 2>&1'

alias makes='make clean  > /dev/null ; make -j9 -s > /dev/null || error $HEADER make'

config() {
	if [ "$CONF_OPT" != "" ]; then
		c1=$CONF_OPT
	fi
	if [ "$CONF_ARGS" != "" ]; then
		c2=$CONF_ARGS
	fi
		
	if [ "$ARCH" = "ppc" ]; then
		./configure --host=powerpc-apple-darwin $CONF_OPT $CONF_ARGS || error $ARCH configure
	else [ "$?" != "0" ]
		./configure $CONF_OPT $CONF_ARGS || error $ARCH configure
	fi
}

stripp() {
	if [ "$ARCH" != "" ]; then
		strip $1 -o $1_$ARCH || error $HEADER strip
	else
		strip $1 -o $1 || error $1 strip
	fi
}

build() {
	config
	makes
	stripp $target
}

#-------------Error handling-------------
mailerror() {
	#send the logfile to mail address ERRORMAIL - define somewhere
	if [ "$TARGET" != "" ] && [ "$ERRORMAIL" != "" ] && [ -f "$LOGFILE" ]; then
		(echo "Subject: "$TARGET" build failure"; cat $LOGFILE | uuencode $LOGFILE) | sendmail -F "Buildbot" -t $ERRORMAIL
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
		mailerror
		exit 1
	fi
}

pipestatus() {
	local S=("${PIPESTATUS[@]}")
	if test -n "$*"
	then test "$*" = "${S[*]}"
	else ! [[ "${S[@]}" =~ [^0\ ] ]]
	fi
}

teelog() {
	tee $1 $LOGFILE
}

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
}
