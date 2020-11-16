#!/bin/zsh
#functions
. ./functions.sh

headermain DOSBOX SDL2


cd ~/Code/snapshots/dosboxSDL2
/usr/bin/svn  revert . -R > /dev/null 2> >(teelog >&2) || error SVN revert
/usr/bin/svn update --depth=infinity 2> >(teelog >&2) || error SVN update
patch -p0 -i ~/code/sh/dosbox-patches/SDL2new.diff > /dev/null 2> >(teelog >&2) || error SDL2 patch

#configure options for all arches
CONF_OPT='-q --with-sdl=sdl2'

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
	patch -p0 -i ~/code/sh/dosbox-patches/intel64SDL2.diff > /dev/null ||  error intel64SDL2 patch
	makes
	/usr/bin/strip ./src/dosbox -o ./src/dosbox ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

#deploy
deploy
{
	# make fat build
	#lipo -create -arch x86_64 ./src/dosbox_x86_64 -arch i386 ./src/dosbox_i386 -arch ppc ./src/dosbox_ppc -output ./src/DOSBox  ||  error lipo

	# bundle
	cp ./src/DOSBox ./src/dosboxsdl2.app/contents/MacOS/DOSBox ||  error bundle

	# codesign to satisfy OS X 10.8 Gatekeeper
	codesign --deep --force --sign "Developer ID Application" ./src/dosboxsdl2.app ||  error codesign


	# make disk image
	mkdir DOSBox-Snapshot
	cp -r  ./src/dosboxsdl2.app ./DOSBox-Snapshot
	cp ./AUTHORS ./DOSBox-Snapshot/Authors
	cp ./COPYING ./DOSBox-Snapshot/License
	cp ./NEWS ./DOSBox-Snapshot/News
	cp ./README ./DOSBox-Snapshot/ReadMe
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/Authors
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/License
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/News
	SetFile -t ttro -c ttxt ./DOSBox-Snapshot/ReadMe
	REVISION=" r$(/usr/bin/svnversion)"
	hdiutil create -ov -format UDZO -imagekey zlib-level=9 -fs HFS+ -srcfolder DOSBox-snapshot -volname "DOSBox SDL2 SVN snapshot$REVISION" Dosbox-SDL2.dmg || error disk image

	# copy app to applications and file the snapshots
	cp -R ./src/DOSBoxSDL2.app /Applications/
	cp -p Dosbox-SDL2.dmg ~/Snapshots/dosbox/"`date +%y-%m-%d-%H%M` DOSBoxSDL2$REVISION.dmg"
	mv Dosbox-SDL2.dmg ~/Snapshots/dosbox/

	# "upload"
	cp -p ~/Snapshots/dosbox/Dosbox-SDL2.dmg ~/dropbox/public/dosbox/
} 2>&1 | teelog -a ; pipestatus || return


# cleanup
make -s distclean > /dev/null
rm -r DOSBox-Snapshot

success