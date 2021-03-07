#!/bin/zsh
#functions
. ./functions.sh
. ./snapshots/exult.sh

headermain EXULT Release
bundle_name=Exult_libs.app
program=exult

cd ~/code/exult

#configure options for all arches
CONF_OPT="-q --enable-exult-studio-support --enable-mt32emu --enable-fluidsynth --disable-alsa --disable-timidity-midi --disable-tools"
export EXPACK=/opt/x86_64/bin/expack
export HEAD2DATA=/opt/x86_64/bin/head2data

#i386
build_i386

#arm64
build_arm64

#x86_64
build_x86_64

#deploy
deploy
{
	#make fat exult binary
	lipo_build

	# rename the libs bundle to the actual bundle - need to use a lib bundle, since otherwise "make clean" between arches would wipe the bundle
	mv Exult_libs.app Exult.app

	#bundle
	make -s bundle || error bundle
	make -s studiobundle || error studiobundle

	#image, upload
	export REVISION=" V1.x"
	make -s osxdmg || error disk image
	make -s studiodmg || error studio disk image
	
	# notarize it
	notar

	mv exult-1.x.dmg ~/Snapshots/exult/
} 2>&1 | teelog -a ; pipestatus || return

#clean
make distclean  > /dev/null

success
