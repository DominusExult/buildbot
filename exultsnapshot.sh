#!/bin/zsh
# shellcheck shell=bash
#functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
. "$SCRIPT_DIR/functions.sh"
. "$SCRIPT_DIR/snapshots/exult.sh"

headermain EXULT

# Validate required paths exist
if [ ! -d "$HOME/code/snapshots/exult" ]; then
	error "Source directory $HOME/code/snapshots/exult does not exist"
fi

export SOURCE_PATH=$HOME/code/snapshots/exult
export bundle_name=Exult_libs.app
export program=exult
export program2=mapedit/exult_studio
export main_binaries=($program $program2)
export tools_binaries=(./tools/cmanip \
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
				./tools/smooth/smooth)
tools_package=(./toolspack/cmanip \
				./toolspack/expack \
				./toolspack/ipack \
				./toolspack/mklink \
				./toolspack/rip \
				./toolspack/shp2pcx \
				./toolspack/splitshp \
				./toolspack/textpack \
				./toolspack/u7voice2syx \
				./toolspack/wuc \
				./toolspack/ucc \
				./toolspack/head2data \
				./toolspack/ucxt \
				./toolspack/mockup \
				./toolspack/smooth \
				./toolspack/libsmooth_randomize.so \
				./toolspack/libsmooth_smooth.so \
				./toolspack/libsmooth_stream.so)
aseprite_binary=./tools/aseprite_plugin/exult_shp

export BUILDDIR="$HOME/code/build/exult"
rm -rf "$BUILDDIR"
mkdir -p "$BUILDDIR"
cd "$BUILDDIR" || exit
if [ "$BUILDBOT" = "1" ]; then
	/usr/bin/git -C "$SOURCE_PATH" stash  2> >(teelog >&2) || error Git stash
	/usr/bin/git -C "$SOURCE_PATH" pull --rebase=true  2> >(teelog >&2) || error Git pull
fi

#configure options for all arches
export CONF_OPT="-q \
			--enable-exult-studio \
			--enable-tools \
			--enable-compiler \
			--enable-aseprite-plugin \
			--disable-alsa \
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
	step "Lipo ..."
	#make fat exult/studio binaries
	lipo_build x86_64 arm64 -f "${main_binaries[@]}"
	#make fat aseprite plugin
	lipo_build x86_64 arm64 -f "${aseprite_binary[@]}"
	#make fat tools
	lipo_build x86_64 arm64 -f "${tools_package[@]}"

	#replace BundleVersion with date
	BUILD_DATE="$(date +"%Y-%m-%d-%H%M")"
	/usr/bin/sed -i '' "s|1.11.0git<|1.11.0 ${BUILD_DATE}<|" ./info.plist  || error sed exult info
	/usr/bin/sed -i '' "s|1.11.0git<|1.11.0 ${BUILD_DATE}<|"  ./macosx/exult_studio_info.plist || error sed exult studio info

	# rename the libs bundle to the actual bundle - need to use a lib bundle, since otherwise "make clean" between arches would wipe the bundle
	mv Exult_libs.app Exult.app || error "Failed to rename bundle"
	
	#bundle
	#let's skip it because the image requires make bundle anyway
	#make -s bundle || error bundle
	#make -s studiobundle || error studiobundle

	#package
	step "Packaging ..."
	REVISION=" $(/usr/bin/git -C "$SOURCE_PATH" log -1 --pretty=format:%h)"
	export REVISION
	make -s osxdmg &> /dev/null || error disk image
	make -s studiodmg &> /dev/null || error studio disk image
	make -s aseprite_package &> /dev/null || error aseprite_package
	tools_package &> /dev/null || error tools_package

	# Only run notarization, filing, and upload if BUILDBOT=1
	if [ "$BUILDBOT" = "1" ]; then
		#Notarize it
		#first Exult then Studio. Arg is the disk image file name
		step "Notarizing ..."
		notar Exult-snapshot.dmg &> /dev/null || error notarize Exult
		notar ExultStudio-snapshot.dmg &> /dev/null || error notarize ExultStudio
		notar exult_tools_macOS.zip &> /dev/null || error notarize tools
		notar exult_shp_macos.aseprite-extension &> /dev/null || error notarize aseprite

		#file it
		step "Filing ..."
		cp -p Exult-snapshot.dmg "$HOME/Snapshots/exult/$(date +%y-%m-%d-%H%M) Exult$REVISION.dmg"
		cp -p ExultStudio-snapshot.dmg "$HOME/Snapshots/exult/$(date +%y-%m-%d-%H%M) ExultStudio$REVISION.dmg"
		cp -p exult_tools_macOS.zip "$HOME/Snapshots/exult/$(date +%y-%m-%d-%H%M) exult_tools$REVISION.zip"
		cp -p exult_shp_macos.aseprite-extension "$HOME/Snapshots/exult/$(date +%y-%m-%d-%H%M) exult_shp$REVISION.aseprite-extension"

		mv Exult-snapshot.dmg "$HOME/Snapshots/exult/"
		mv ExultStudio-snapshot.dmg "$HOME/Snapshots/exult/"
		mv exult_tools_macOS.zip "$HOME/Snapshots/exult/"
		mv exult_shp_macos.aseprite-extension "$HOME/Snapshots/exult/"

		#upload
		step "Uploading ..."
		sf_upload
	fi
} 2>&1 | teelog -a ; pipestatus || return

#clean
if [ "$BUILDBOT" = "1" ]; then
	step "Cleaning up ..."
	make distclean  > /dev/null
fi
success