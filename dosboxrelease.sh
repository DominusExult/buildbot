#!/bin/zsh
emulate -LR bash
DIE=0
function error_exit
{
	echo -e "\033[1;31m **Error** line #${1:-"Unknown Error"}\033[0m" 1>&2
	exit 1
}
echo -e "\033[1;31m **CHECK PLIST\033[0m" 1>&2
cd ~/Code/dosbox-0.74-3
#/usr/bin/svn update --depth=infinity
#configure options for all arches
CONF_OPT='-q --disable-sdltest --disable-alsatest --enable-core-inline'
 
#x86_64
OPT=' -O2 -msse -msse2 -force_cpusubtype_ALL '
SDK=' -w -isysroot /opt/SDKs/MacOSX10.14.sdk -mmacosx-version-min=10.10 '
export MACOSX_DEPLOYMENT_TARGET=10.10
export PATH=/opt/x86_64/bin/:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
export CC="/usr/bin/clang"
export CXX="/usr/bin/clang++"
export CPPFLAGS='-I/opt/x86_64/include '$SDK
export CFLAGS='-I/opt/x86_64/include '$SDK' '$OPT
export CXXFLAGS='-I/opt/x86_64/include '$SDK' '$OPT
export LDFLAGS='-L/opt/x86_64/lib '$SDK' '$OPT
export PKG_CONFIG_PATH=
./autogen.sh
./configure $CONF_OPT --prefix=/opt/x86_64 || { 
DIE=1
error_exit "$(( $LINENO -2 )) : x86_64 configure failed."
}
make -s clean
patch -p0 -i ~/code/sh/dosbox-patches/intel64-old.diff || { 
DIE=1
error_exit "$(( $LINENO -2 )) : x86_64 patch failed."
}
make -j9 -s
strip ./src/dosbox -o ./src/dosbox_x86_64
make -s distclean

#i386
OPT=' -arch i386 -m32 -O2 -msse -msse2 -force_cpusubtype_ALL '
SDK=' -w -isysroot /opt/SDKs/MacOSX10.6.sdk -mmacosx-version-min=10.6 '
export MACOSX_DEPLOYMENT_TARGET=10.6
export PATH=/opt/i386/bin/:/usr/bin:/bin:/usr/sbin:/usr/local/bin
export CC="/opt/xcode3/usr/bin/gcc-4.2 -arch i386"
export CXX="/opt/xcode3/usr/bin/g++-4.2 -arch i386"
export CPPFLAGS='-I/opt/i386/include '$SDK
export CFLAGS='-I/opt/i386/include '$SDK' '$OPT
export CXXFLAGS='-I/opt/i386/include '$SDK' '$OPT
export LDFLAGS='-L/opt/i386/lib '$SDK' '$OPT
export PKG_CONFIG_PATH=
./autogen.sh
./configure $CONF_OPT  --prefix=/opt/i386 --build=i386-apple-darwin || { 
DIE=1
error_exit "$(( $LINENO -2 )) : i386 configure failed."
}
make -s clean
patch -p0 -i ~/code/sh/dosbox-patches/intel-old.diff || { 
DIE=1
error_exit "$(( $LINENO -2 )) : i386 patch failed."
}
make -j9 -s || {
  DIE=1
  error_exit "$(( $LINENO -2 )) : i386 make failed."
}
strip ./src/dosbox -o ./src/dosbox_i386
make -s distclean

#ppc
OPT=' -arch ppc -O2 ' 
SDK=' -w -isysroot /opt/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.4 '
export MACOSX_DEPLOYMENT_TARGET=10.4
export PATH=/opt/ppc/bin/:/opt/xcode3/usr/bin:/opt/xcode3/usr/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
export CC="/opt/xcode3/usr/bin/gcc-4.2 -arch ppc"
export CXX="/opt/xcode3/usr/bin/g++-4.2 -arch ppc"
export GCOV="/opt/xcode3/usr/bin/gcov-4.2 -arch ppc"
export CPPFLAGS='-I/opt/ppc/include '$SDK
export CFLAGS='-I/opt/ppc/include '$SDK' '$OPT
export CXXFLAGS='-I/opt/ppc/include '$SDK' '$OPT
export LDFLAGS='-L/opt/ppc/lib '$SDK' '$OPT
export PKG_CONFIG_PATH=
./autogen.sh
./configure $CONF_OPT  --prefix=/opt/ppc --host=powerpc-apple-darwin || { 
DIE=1
error_exit "$(( $LINENO -2 )) : PPC configure failed."
}
make -s clean
patch -p0 -i ~/code/sh/dosbox-patches/ppc-old.diff || { 
DIE=1
error_exit "$(( $LINENO -2 )) : ppc patch failed."
}
make -j9 -s || {
  DIE=1
  error_exit "$(( $LINENO -2 )) : PPC make failed."
}
strip ./src/dosbox -o ./src/dosbox_ppc

# make fat build
lipo -create -arch x86_64 ./src/dosbox_x86_64 -arch i386 ./src/dosbox_i386 -arch ppc ./src/dosbox_ppc -output ./src/DOSBox  || { 
DIE=1
error_exit "$(( $LINENO -2 )) : lipo failed."
}

# bundle
cp ./src/DOSBox ./src/dosbox.app/contents/MacOS/DOSBox || { 
DIE=1
error_exit "$(( $LINENO -2 )) : Bundle failed."
}

# codesign to satisfy OS X 10.8 Gatekeeper
codesign --options runtime --deep --force --sign "Developer ID Application" ./src/dosbox.app --entitlements ./src/dosbox.app/contents/entitlements.plist || { 
DIE=1
error_exit "$(( $LINENO -2 )) : codesign failed."
}


#make disk image
mkdir DOSBox-0.74-3
cp -r  ./src/dosbox.app ./DOSBox-0.74-3
cp ./AUTHORS ./DOSBox-0.74-3/Authors
cp ./COPYING ./DOSBox-0.74-3/License
cp ./NEWS ./DOSBox-0.74-3/News
cp ./README ./DOSBox-0.74-3/ReadMe
cp ./Changelog ./DOSBox-0.74-3/ChangeLog
cp ./Thanks ./DOSBox-0.74-3/Thanks
SetFile -t ttro -c ttxt ./DOSBox-0.74-3/Authors
SetFile -t ttro -c ttxt ./DOSBox-0.74-3/License
SetFile -t ttro -c ttxt ./DOSBox-0.74-3/News
SetFile -t ttro -c ttxt ./DOSBox-0.74-3/ReadMe
SetFile -t ttro -c ttxt ./DOSBox-0.74-3/ChangeLog
SetFile -t ttro -c ttxt ./DOSBox-0.74-3/Thanks
hdiutil create -ov -format UDZO -imagekey zlib-level=9 -fs HFS+ -srcfolder DOSBox-0.74-3 -volname "DOSBox 0.74-3-3" DOSBox-0.74-3-3.dmg || { 
DIE=1
error_exit "$(( $LINENO -2 )) : disk image failed."
}

#Notarize it
xcrun altool --notarize-app --primary-bundle-id "com.dosbox.dmg" --username "APPLE ID" --password "PASSWORD" --file DOSBox-0.74-3-3.dmg

# file the build
cp -p DOSBox-0.74-3-3.dmg ~/Snapshots/dosbox/`date +%y-%m-%d-%H%M`DOSBox-0.74-3-3.dmg
#mv DOSBox-0.74-3.dmg ~/Snapshots/dosbox/


# cleanup
make -s distclean
rm -r DOSBox-0.74-3

if test "$DIE" -eq 1; then
  exit 1
fi
