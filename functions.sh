#-------------headers-------------
headermain() {
	if [ "$1" != "" ]; then
		TARGET=$1
		target="$(echo $TARGET | tr '[A-Z]' '[a-z]')"
		LOGFILE=~/.local/logs/${target}built.txt
		echo
		echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tBUILDING $1\t\t$(tput sgr 0)"
		echo
		echo "logfile at $LOGFILE"
		echo
	else
		error headermain function
	fi
}

header() {
	echo
	echo -e "$(tput setab 4)$(tput bold)$(tput setaf 3)\tbuilding for $1\t$(tput sgr 0)"
	echo
}

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
autogen() {
	./autogen.sh > /dev/null 2>&1
}

stripp() {
	if [ "$ARCH" != "" ]; then
		strip $1 -o $1_$ARCH || error $ARCH strip
	else
		strip $1 -o $1 || error $1 strip
	fi
}

#-------------Error handling-------------
error () {
	if [ "$?" != "0" ]; then
		if [ "$2" != "" ]; then
			i2=" $2"
		fi
		if [ "$3" != "" ]; then
			i3=" $3"
		fi
		echo
		echo -e "$(tput setab 1)$(tput bold)$(tput setaf 7)\t\t***Error***\t\t\t$(tput sgr 0)"
		echo -e "$(tput setab 1)$(tput bold)$(tput setaf 7)\t${1:-"Unknown Error"}${i2}${i3} failed!\t\t$(tput sgr 0)" 1>&2
		echo -e "$(tput setab 1)$(tput bold)$(tput setaf 7)\t\t***Error***\t\t\t$(tput sgr 0)"
		echo
		#send the logfile to mail address ERRORMAIL from the mail address BUILDBOT - define them somewhere
		if [ "$TARGET" != "" ] && [ "$BUILDBOT" != "" ] && [ "$ERRORMAIL" != "" ] && [ -f "$LOGFILE" ]; then
			printf "Subject: "$TARGET" build failure" | sendmail -F "Buildbot "$BUILDBOT $ERRORMAIL < $LOGFILE
		fi
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
	tee $LOGFILE
	#2> >(tee $LOGFILE >&2)
}

echoall() {
	echo ARCH=$ARCH
	echo SDK=$SDK
	echo OPT=$OPT
	echo MACOSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET
	echo PATH=$PATH
	echo CC=$CC
	echo CXX=$CXX
	echo CPPFLAGS=$CPPFLAGS
	echo CFLAGS=$CFLAGS
	echo CXXFLAGS=$CXXFLAGS
	echo LDFLAGS=$LDFLAGS
	echo PKG_CONFIG_PATH=$PKG_CONFIG_PATH
	echo PKG_CONFIG=$PKG_CONFIG
	echo LD=$LD
	echo AR=$AR
	echo RANLIB=$RANLIB
}
#error () {
#  DIE=1
#  error_exit "$1 $2 $3 failed."
#}
