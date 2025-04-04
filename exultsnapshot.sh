#!/bin/zsh 
#functions
. ./functions.sh
. ./snapshots/exult.sh

headermain EXULT
SOURCE_PATH=$HOME/code/snapshots/exult
bundle_name=Exult_libs.app
program=exult
program2=mapedit/exult_studio
main_binaries=($program $program2)
tools_binaries=(./tools/cmanip \
				./tools/expack \
				./tools/ipack \
				./tools/mklink \
				./tools/rip \
				./tools/shp2pcx \
				./tools/splitshp \
				./tools/textpack \
				./tools/u7voice2syx \
				./tools/wuc \
				./tools/compiler/ucc \
				./tools/ucxt/head2data \
				./tools/ucxt/src/ucxt \
				./tools/mockup/mockup \
				./tools/smooth/smooth \
				./tools/aseprite_plugin/exult_shp)

rm -R $HOME/code/build/exult
mkdir -p $HOME/code/build/exult
cd $HOME/code/build/exult
/usr/bin/git -C "$SOURCE_PATH" pull --rebase=true  2> >(teelog >&2) || error Git pull

#configure options for all arches
CONF_OPT="-q \
			--enable-exult-studio-support \
			--enable-exult-studio \
			--enable-mt32emu \
			--enable-fluidsynth \
			--enable-tools \
			--enable-compiler \
			--enable-aseprite-plugin \
			--disable-alsa --disable-all-hq-scalers --disable-nxbr \
			--disable-timidity-midi"

export EXPACK=/opt/exult/expack
export HEAD2DATA=/opt/exult/head2data

#x86_64
build_x86_64

#arm64
build_arm64

#deploy
deploy
{
	#make fat exult/studio binaries
	lipo_build x86_64 arm64 -f "${main_binaries[@]}"
	#make fat tools
	lipo_build x86_64 arm64 -f "${main_binaries[@]}"

	#replace BundleVersion with date
	echo "Current PATH = "$PWD
	sed -i '' "s|1.11.0git<|1.11.0 $(date +"%Y-%m-%d-%H%M")<|" ./info.plist
	sed -i '' "s|1.11.0git<|1.11.0 $(date +"%Y-%m-%d-%H%M")<|" ./macosx/exult_studio_info.plist

	# rename the libs bundle to the actual bundle - need to use a lib bundle, since otherwise "make clean" between arches would wipe the bundle
	mv Exult_libs.app Exult.app
	
	#bundle
	#let's skip it because the image requires make bundle anyway
	#make -s bundle || error bundle
	#make -s studiobundle || error studiobundle

	#image
	REVISION=" $(/usr/bin/git -C $SOURCE_PATH log -1 --pretty=format:%h)"
	export REVISION
	make -s osxdmg || error disk image
	make -s studiodmg > /dev/null 2>&1 || error studio disk image
	make -s tools_package || error tools_package
	make -s aseprite_package || error aseprite_package
	
	#Notarize it
	#first Exult then Studio. Arg is the disk image file name
	notar Exult-snapshot.dmg || error notarize Exult
	notar ExultStudio-snapshot.dmg || error notarize ExultStudio
	notar exult_tools_macOS.zip || error notarize tools
	notar exult_shp_macos.aseprite-extension || error notarize aseprite

	#file it
	cp -p Exult-snapshot.dmg $HOME/Snapshots/exult/"$(date +%y-%m-%d-%H%M) Exult$REVISION.dmg"
	cp -p ExultStudio-snapshot.dmg $HOME/Snapshots/exult/"$(date +%y-%m-%d-%H%M) ExultStudio$REVISION.dmg"
	cp -p exult_tools_macOS.zip $HOME/Snapshots/exult/"$(date +%y-%m-%d-%H%M) exult_tools$REVISION.zip"
	cp -p exult_shp_macos.aseprite-extension $HOME/Snapshots/exult/"$(date +%y-%m-%d-%H%M) exult_shp$REVISION.aseprite-extension"

	mv Exult-snapshot.dmg $HOME/Snapshots/exult/
	mv ExultStudio-snapshot.dmg $HOME/Snapshots/exult/
	mv exult_tools_macOS.zip $HOME/Snapshots/exult/
	mv exult_shp_macos.aseprite-extension $HOME/Snapshots/exult/
	cp -R Exult.app /Applications/
	cp -R Exult_Studio.app /Applications/

	#upload
	sf_upload
} 2>&1 | teelog -a ; pipestatus || return

#clean
make distclean  > /dev/null

success