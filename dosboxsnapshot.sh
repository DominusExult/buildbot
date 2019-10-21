#!/usr/bin/env bash
#functions
. ./functions.sh

headermain DOSBOX


cd ~/Code/snapshots/dosbox
/usr/bin/svn update --depth=infinity 2> >(teelog >&2) || error SVN update

#configure options for all arches
CONF_OPT='-q --disable-sdltest --disable-alsatest --enable-core-inline'

#x86_64
header x86_64
ARCH=x86_64
SDK=10.11
DEPLOYMENT=10.10
flags
gcc
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	patch -p0 -i ~/code/sh/dosbox-patches/intel64.diff ||  error intel64 patch
	makes
	/usr/bin/strip ./src/dosbox -o ./src/dosbox_x86_64 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

make -s distclean > /dev/null

#i386
header i386
ARCH=i386
SDK=10.6
DEPLOYMENT=10.5
flags
gcc oldgcc
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	patch -p0 -i ~/code/sh/dosbox-patches/intel.diff ||  error intel patch
	makes
	/usr/bin/strip ./src/dosbox -o ./src/dosbox_i386 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

make -s distclean > /dev/null

#ppc
header PPC
ARCH=ppc
SDK=10.5
DEPLOYMENT=10.4
flags
gcc oldgcc
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	patch -p0 -i ~/code/sh/dosbox-patches/ppc.diff ||  error ppc patch
	makes
	strip ./src/dosbox -o ./src/dosbox_ppc
} 2>&1 | teelog -a ; pipestatus || return

#deploy
deploy
{
	# make fat build
	lipo -create -arch x86_64 ./src/dosbox_x86_64 -arch i386 ./src/dosbox_i386 -arch ppc ./src/dosbox_ppc -output ./src/DOSBox  ||  error lipo

	# bundle
	cp ./src/DOSBox ./src/dosboxsvn.app/contents/MacOS/DOSBox ||  error bundle

	# codesign to satisfy OS X 10.8 Gatekeeper
	codesign --deep --force --sign "Developer ID Application" ./src/dosboxsvn.app ||  error codesign


	# make disk image
	mkdir DOSBox-Snapshot
	CpMac -r  ./src/dosboxsvn.app ./DOSBox-Snapshot
	cp ./AUTHORS ./DOSBox-Snapshot/Authors
	cp ./COPYING ./DOSBox-Snapshot/License
	cp ./NEWS ./DOSBox-Snapshot/News
	cp ./README ./DOSBox-Snapshot/ReadMe
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/Authors
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/License
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/News
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/ReadMe
	REVISION=" r$(/usr/bin/svnversion)"
	hdiutil create -ov -format UDZO -imagekey zlib-level=9 -fs HFS+ -srcfolder DOSBox-snapshot -volname "DOSBox SVN snapshot$REVISION" Dosbox-Snapshot.dmg || error disk image

	# copy app to applications and file the snapshots
	cp -R ./src/DOSBoxSVN.app /Applications/
	cp -p Dosbox-Snapshot.dmg ~/Snapshots/dosbox/"`date +%y-%m-%d-%H%M` DOSBox$REVISION.dmg"
	mv Dosbox-Snapshot.dmg ~/Snapshots/dosbox/

	# "upload"
	cp -p ~/Snapshots/dosbox/Dosbox-Snapshot.dmg ~/dropbox/public/dosbox/
} 2>&1 | teelog -a ; pipestatus || return


# cleanup
make -s distclean > /dev/null
rm -r DOSBox-Snapshot
success
cd ~/code/sh;  .  dosboxsdl2snapshot.sh