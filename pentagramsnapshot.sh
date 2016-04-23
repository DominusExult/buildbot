#!/usr/bin/env bash
#functions
. ./functions.sh

headermain PENTAGRAM

cd ~/code/snapshots/pentagram
/usr/bin/svn update --depth=infinity || error SVN update

#configure options for all arches
CONF_OPT='-q --enable-builtin-data=no --disable-debug --disable-alsa --disable-fluidsynth --enable-all-hq-scalers --enable-gc-scalers --enable-all-bilinear'

#x86_64
header x86_64
ARCH=x86_64
SDK=10.11
DEPLOYMENT=10.7
flags
gcc
./bootstrap > /dev/null
CONF_ARGS="--with-macosx-static-lib-path=/opt/$ARCH/lib"
build 2>&1 | teelog ; pipestatus || return

#i386
header i386
ARCH=i386
SDK=10.11
DEPLOYMENT=10.5
flags
gcc arch
./bootstrap > /dev/null
CONF_ARGS="--with-macosx-static-lib-path=/opt/$ARCH/lib"
build 2>&1 | teelog ; pipestatus || return

#ppc
header PPC
ARCH=ppc
SDK=10.5
DEPLOYMENT=10.4
flags
gcc oldgcc
./bootstrap > /dev/null
CONF_ARGS="--with-macosx-static-lib-path=/opt/$ARCH/lib  --with-macosx-code-signature"
build 2>&1 | teelog ; pipestatus || return

#deploy
deploy
{
	#make fat binary
	lipo -create -arch x86_64 pentagram_x86_64 -arch i386 pentagram_i386 -arch ppc pentagram_ppc -output pentagram || error lipo
	#bundle
	make -s bundle || error bundle

	#image, upload, clean
	export REVISION=" r$(/usr/bin/svnversion)"
	make -s image || error disk image

	cp -p Pentagram.dmg ~/Snapshots/pentagram/"`date +%y-%m-%d-%H%M` Pentagram$REVISION.dmg"
	mv Pentagram.dmg ~/Snapshots/pentagram/
	cp -R Pentagram.app /Applications/
	scp -p -i ~/.ssh/id_dsa ~/Snapshots/pentagram/Pentagram.dmg dominus,pentagram@web.sourceforge.net:htdocs/snapshots/Pentagram.dmg || error Upload
} 2>&1 | teelog -a ; pipestatus || return

#clean
make clean-local > /dev/null
make clean > /dev/null
make distclean > /dev/null
