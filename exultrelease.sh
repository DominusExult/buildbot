#!/bin/zsh
emulate -LR bash
#functions
. ./functions.sh

headermain EXULT Release

cd ~/code/exult
#/usr/bin/git pull --rebase=true 2> >(teelog >&2) || error Git pull

#configure options for all arches
CONF_OPT="-q --enable-mt32emu --enable-static-libraries --disable-oggtest --disable-vorbistest --disable-alsa --disable-fluidsynth --disable-timidity-midi --disable-tools"

#x86_64
header x86_64
ARCH=x86_64
SDK=10.14
DEPLOYMENT=10.9
flags
gcc
CONF_ARGS="--with-macosx-static-lib-path=/opt/$ARCH/lib"
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
CONF_ARGS="--with-macosx-code-signature --with-macosx-static-lib-path=/opt/$ARCH/lib --with-sdl=sdl12"
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

	mv exult-1.6.dmg ~/Snapshots/exult/
} 2>&1 | teelog -a ; pipestatus || return

#clean
make distclean  > /dev/null

success
