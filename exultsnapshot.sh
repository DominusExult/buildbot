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

export SOURCE_PATH="$HOME/code/snapshots/exult"
export bundle_name="Exult_libs.app"
export program="exult"
export program2="mapedit/exult_studio"
export main_binaries=("$program" "$program2")
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
aseprite_binary="./tools/aseprite_plugin/exult_shp"

export BUILDDIR="$HOME/code/build/exult"
rm -rf "$BUILDDIR"
mkdir -p "$BUILDDIR"
cd "$BUILDDIR" || exit
if [ "$BUILDBOT" = "1" ]; then
	/usr/bin/git -C "$SOURCE_PATH" stash  2> >(teelog -a >&2) || error "Git stash failed"
	/usr/bin/git -C "$SOURCE_PATH" pull --rebase=true  2> >(teelog -a >&2) || error "Git pull failed"
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
build_x86_64 2>&1 | teelog ; pipestatus || return 1

#arm64
build_arm64 2>&1 | teelog -a ; pipestatus || return 1

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
	[ -f "./info.plist" ] && /usr/bin/sed -i '' "s|1.11.0git<|1.11.0 ${BUILD_DATE}<|" ./info.plist || error "sed exult info: info.plist not found"
	[ -f "./macosx/exult_studio_info.plist" ] && /usr/bin/sed -i '' "s|1.11.0git<|1.11.0 ${BUILD_DATE}<|" ./macosx/exult_studio_info.plist || error "sed exult studio info: exult_studio_info.plist not found"

	# rename the libs bundle to the actual bundle - need to use a lib bundle, since otherwise "make clean" between arches would wipe the bundle
	if [ -d "Exult_libs.app" ]; then
		mv Exult_libs.app Exult.app || error "Failed to rename bundle from Exult_libs.app to Exult.app"
	else
		error "Exult_libs.app bundle not found - build may have failed"
	fi
	
	#bundle
	#let's skip it because the image requires make bundle anyway
	#make -s bundle || error bundle
	#make -s studiobundle || error studiobundle

	#package
	step "Packaging ..."
	REVISION=" $(/usr/bin/git -C "$SOURCE_PATH" log -1 --pretty=format:%h)"
	export REVISION

	# Test codesigning capability before packaging
	if [ "$BUILDBOT" = "1" ]; then
		if ! security find-identity -v -p codesigning | grep -q "Developer ID Application"; then
			error "Developer ID Application certificate not found in keychain"
		fi
	fi
	
	make -s osxdmg &> /dev/null || error "Failed to create disk image"
	make -s studiodmg &> /dev/null || error "Failed to create studio disk image"
	make -s aseprite_package &> /dev/null || error "Failed to create aseprite package"
	tools_package &> /dev/null || error "Failed to create tools package"

	# Only run notarization, filing, and upload if BUILDBOT=1
	if [ "$BUILDBOT" = "1" ]; then
		#Notarize it
		#first Exult then Studio. Arg is the disk image file name
		step "Notarizing ..."
		
		# Validate files exist before notarization
		[ -f "Exult-snapshot.dmg" ] || error "Exult-snapshot.dmg not found for notarization"
		[ -f "ExultStudio-snapshot.dmg" ] || error "ExultStudio-snapshot.dmg not found for notarization"
		[ -f "exult_tools_macOS.zip" ] || error "exult_tools_macOS.zip not found for notarization"
		[ -f "exult_shp_macos.aseprite-extension" ] || error "exult_shp_macos.aseprite-extension not found for notarization"
		
		notar Exult-snapshot.dmg &> /dev/null || error "Failed to notarize Exult"
		notar ExultStudio-snapshot.dmg &> /dev/null || error "Failed to notarize ExultStudio"
		notar exult_tools_macOS.zip &> /dev/null || error "Failed to notarize tools"
		notar exult_shp_macos.aseprite-extension &> /dev/null || error "Failed to notarize aseprite plugin"

		#file it
		step "Filing ..."
		# Ensure snapshot directory exists
		mkdir -p "$HOME/Snapshots/exult" || error "Failed to create snapshots directory"
		
		# Copy timestamped versions and move to final locations
		TIMESTAMP="$(date +%y-%m-%d-%H%M)"
		cp -p Exult-snapshot.dmg "$HOME/Snapshots/exult/${TIMESTAMP} Exult$REVISION.dmg" || error "Failed to copy Exult dmg"
		cp -p ExultStudio-snapshot.dmg "$HOME/Snapshots/exult/${TIMESTAMP} ExultStudio$REVISION.dmg" || error "Failed to copy ExultStudio dmg"
		cp -p exult_tools_macOS.zip "$HOME/Snapshots/exult/${TIMESTAMP} exult_tools$REVISION.zip" || error "Failed to copy tools zip"
		cp -p exult_shp_macos.aseprite-extension "$HOME/Snapshots/exult/${TIMESTAMP} exult_shp$REVISION.aseprite-extension" || error "Failed to copy aseprite extension"

		mv Exult-snapshot.dmg "$HOME/Snapshots/exult/" || error "Failed to move Exult snapshot"
		mv ExultStudio-snapshot.dmg "$HOME/Snapshots/exult/" || error "Failed to move ExultStudio snapshot"
		mv exult_tools_macOS.zip "$HOME/Snapshots/exult/" || error "Failed to move tools zip"
		mv exult_shp_macos.aseprite-extension "$HOME/Snapshots/exult/" || error "Failed to move aseprite extension"

		#upload
		step "Uploading ..."
		sf_upload

		# Clean up
		step "Cleaning up ..."
		make distclean  > /dev/null
	fi
} 2>&1 | teelog -a ; pipestatus || return
success  2>&1 | teelog -a ; pipestatus || return