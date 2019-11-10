#!/usr/bin/env bash
#functions
. ./functions.sh

headermain XU4

cd ~/code/snapshots/xu4
/usr/bin/svn update --depth=infinity || error SVN update
cd src

#x86_64
ARCH=x86_64
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
export CFLAGS=
export LDFLAGS=
export CXXFLAGS=$CFLAGS
export CPPFLAGS=$CXXFLAGS
export ACLOCAL_FLAGS=
export PKG_CONFIG_PATH=
export SPECIFIC_ARCH=
export SYSROOT='/opt/SDKs/MacOSX10.10.sdk -mmacosx-version-min=10.7'
make -f makefile.osx clean && make -f makefile.osx clean-local > /dev/null
make -j9 -s -f makefile.osx || error $ARCH make
strip u4 -o u4_$ARCH || error $ARCH strip

#i386
ARCH=i386
export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
export CC=/usr/bin/gcc
export CXX=/usr/bin/g++
export CFLAGS= "-w"
export CXXFLAGS=$CFLAGS
export CPPFLAGS=$CXXFLAGS
export LDFLAGS=
export PKG_CONFIG_PATH=
export SPECIFIC_ARCH='-arch i386'
export SYSROOT='/opt/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.5'
make -f makefile.osx clean > /dev/null
make -j9 -s -f makefile.osx || error $ARCH make
strip u4 -o u4_$ARCH || error $ARCH strip

#ppc
ARCH=ppc
export PATH=/opt/xcode3/usr/bin:/opt/xcode3/usr/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
export CC=/opt/xcode3/usr/bin/gcc-4.2
export CXX=/opt/xcode3/usr/bin/g++-4.2
export CFLAGS= "-w"
export CXXFLAGS=$CFLAGS
export CPPFLAGS=$CXXFLAGS
export LDFLAGS=
export PKG_CONFIG_PATH=
export SPECIFIC_ARCH='-arch ppc'
export SYSROOT='/opt/SDKs/MacOSX10.5.sdk -mmacosx-version-min=10.4'
make -f makefile.osx clean > /dev/null
make -j9 -s -f makefile.osx || error $ARCH make
strip u4 -o u4_$ARCH || error $ARCH strip

#make fat binary
lipo -create -arch x86_64 u4_x86_64 -arch i386 u4_i386 -arch ppc u4_ppc -output u4 || error lipo

#bundle
make -f makefile.osx bundle || error bundle

#codesign to satisfy OS X 10.8 Gatekeeper
codesign --force --sign "Developer ID Application" xu4.app/contents/macos/u4 || error codesign

#little hack to prevent the next step from restoring the unsigned binary in the bundle
cp xu4.app/contents/macos/u4 u4

#image
export REVISION=" r$(/usr/bin/svnversion)"
make -f makefile.osx osxdmg || error disk image

# copy the disk image to the snapshots storage path with date and time stamp
# to be able to easily trace back regressions
cp -p xu4-MacOSX.dmg ~/Snapshots/xu4/"`date +%y-%m-%d-%H%M` xu4$REVISION.dmg"

# move the disk image to the snapshots storage - this will be overwritten each 
# time you make a snapshot
mv xu4-MacOSX.dmg ~/Snapshots/xu4/
rm -r /applications/xu4.app
cp -R xu4.app /Applications/


# if you have uploaded your public key to SF you can automatically upload the 
# snapshot to the download page
#scp -p -i ~/.ssh/id_dsa ~/Snapshots/xu4/xu4-MacOSX.dmg $USER,xu4@web.sourceforge.net:web/download/xu4-MacOSX.dmg || error Upload

#leaving everything clean
make -f makefile.osx clean > /dev/null && make -f makefile.osx clean-local > /dev/null

success