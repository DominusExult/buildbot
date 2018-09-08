#!/usr/bin/env bash
#functions
. ./functions.sh

headermain EXULT

cd ~/code/snapshots/exult
/usr/bin/git pull --rebase=true 2> >(teelog >&2) || error Git pull

#configure options for all arches
CONF_OPT="-q --enable-opengl --enable-mt32emu --enable-static-libraries --disable-oggtest --disable-vorbistest --disable-alsa --disable-fluidsynth --disable-timidity-midi --disable-tools"

#x86_64
header x86_64
ARCH=x86_64
SDK=10.11
DEPLOYMENT=10.7
flags
gcc
CONF_ARGS="--with-macosx-static-lib-path=/opt/$ARCH/lib --x-includes=/usr/X11/include --x-libraries=/usr/X11/lib"
autogen
build 2>&1 | teelog ; pipestatus || return
make distclean > /dev/null

#ppc
header PPC
ARCH=ppc
SDK=10.5
DEPLOYMENT=10.4
flags
gcc oldgcc
CONF_ARGS="--disable-data --with-macosx-static-lib-path=/opt/$ARCH/lib"
autogen
build 2>&1 | teelog -a ; pipestatus || return
make distclean  > /dev/null

#i386
header i386
ARCH=i386
SDK=10.11
DEPLOYMENT=10.6
flags
gcc arch
CONF_ARGS="--with-macosx-code-signature --with-macosx-static-lib-path=/opt/$ARCH/lib"
autogen
build 2>&1 | teelog -a ; pipestatus || return

#deploy
deploy
{
	#make fat exult binary
	lipo -create -arch x86_64 exult_x86_64 -arch i386 exult_i386 -arch ppc exult_ppc -output exult || error lipo

	#bundle
	make -s bundle || error bundle

	#image, upload
	export REVISION=" $(/usr/bin/git log -1 --pretty=format:%h)"
	make -s osxdmg || error disk image

	cp -p Exult-snapshot.dmg ~/Snapshots/exult/"`date +%y-%m-%d-%H%M` Exult$REVISION.dmg"
	mv Exult-snapshot.dmg ~/Snapshots/exult/
	cp -R Exult.app /Applications/
	#scp -p -i ~/.ssh/id_dsa ~/Snapshots/exult/Exult-snapshot.dmg $USER,exult@web.sourceforge.net:htdocs/snapshots/Exult-snapshot.dmg || error Upload
} 2>&1 | teelog -a ; pipestatus || return

#clean
make distclean  > /dev/null

success
