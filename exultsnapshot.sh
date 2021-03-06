#!/bin/zsh 
#functions
. ./functions.sh
. ./snapshots/exult.sh

headermain EXULT
bundle_name=Exult_libs.app
program=exult

cd ~/code/snapshots/exult
/usr/bin/git pull --rebase=true 2> >(teelog >&2) || error Git pull

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
	lipo_build x86_64 arm64 i386

	#replace BundleVersion with date
	sed -i '' "s|1.7.0git<|1.7.0 $(date +"%Y-%m-%d-%H%M")<|" info.plist
	sed -i '' "s|1.7.0git<|1.7.0 $(date +"%Y-%m-%d-%H%M")<|" ./macosx/exult_studio_info.plist

	# rename the libs bundle to the actual bundle - need to use a lib bundle, since otherwise "make clean" between arches would wipe the bundle
	mv Exult_libs.app Exult.app
	
	#bundle
	make -s bundle || error bundle
	make -s studiobundle || error studiobundle

	#image
	export REVISION=" $(/usr/bin/git log -1 --pretty=format:%h)"
	make -s osxdmg || error disk image
	make -s studiodmg || error studio disk image
	
	#Notarize it
	#first Exult then Studio. Args are bundle ID and disk image file name
	notar info.exult.dmg Exult-snapshot.dmg
	notar info.exult.studio.dmg ExultStudio-snapshot.dmg

	#file it
	cp -p Exult-snapshot.dmg ~/Snapshots/exult/"`date +%y-%m-%d-%H%M` Exult$REVISION.dmg"
	cp -p ExultStudio-snapshot.dmg ~/Snapshots/exult/"`date +%y-%m-%d-%H%M` ExultStudio$REVISION.dmg"

	mv Exult-snapshot.dmg ~/Snapshots/exult/
	mv ExultStudio-snapshot.dmg ~/Snapshots/exult/
	cp -R Exult.app /Applications/
	cp -R Exult_Studio.app /Applications/

	#upload
	sf_upload
} 2>&1 | teelog -a ; pipestatus || return

#clean
make distclean  > /dev/null

success
