#!/bin/zsh
# functions
. ./functions.sh
. ./snapshots/dosbox.sh

headermain DOSBOX
bundle_name=DOSBoxSVN.app
program=./src/dosbox

cd ~/Code/snapshots/dosbox

# svn is no longer included in macOS 10.15+ so you need to provide your own and make an alias for that in your environment
# revert svn as we have probably applied the dynrec patch for ARM
svn revert . -R > /dev/null 2> >(teelog >&2) || error SVN revert
# remove the unversioned cache.h file for smooth patch application later
rm -f src/cpu/cache.h
# update svn
svn update --depth=infinity 2> >(teelog >&2) || error SVN update
# svnversion also needs an alias now - we grab the version *now* before we modify via the ARM patch
REVISION=" r$(svnversion)"

# configure options for all arches
CONF_OPT='-q --disable-sdltest --disable-alsatest'

# i386
#build_i386

# ppc
#build_ppc

# arm64
# disabled for now as the dynrec core crashes
#build_arm64

# x86_64
build_x86_64

# deploy
deploy
{

	# make fat build
	lipo_build x86_64

	# bundle
	bundle

	# make disk image
	diskimage
	
	# Notarize it
	notar DOSBox-snapshot.dmg
		
	# copy app to applications and file the snapshots
	cp -R ./$dmg_name/$bundle_name /Applications/
	cp -p $dmg_name.dmg ~/Snapshots/dosbox/"`date +%y-%m-%d-%H%M` DOSBox$REVISION.dmg"
	mv -f $dmg_name.dmg ~/Snapshots/dosbox/
	
	# create SDL12compat disk image
	#diskimage_compat
	
	# Notarize it
	#notar com.dosbox.dmg DOSBox-SDL2compat.dmg
	
	# copy app to applications and file the snapshots
	#cp -R ./$dmg_name/DOSBoxSDL2compat.app /Applications/
	#cp -p DOSBox-SDL2compat.dmg ~/Snapshots/dosbox/"`date +%y-%m-%d-%H%M` DOSBoxSDL2compat$REVISION.dmg"
	#mv -f DOSBox-SDL2compat.dmg ~/Snapshots/dosbox/
	
	# "upload"
	cp -p ~/Snapshots/dosbox/Dosbox-Snapshot.dmg ~/dropbox/public/dosbox/
	#cp -p ~/Snapshots/dosbox/DOSBox-SDL2compat.dmg ~/dropbox/public/dosbox/
} 2>&1 | teelog -a ; pipestatus || return

# cleanup
make -s distclean > /dev/null
rm -r DOSBox-snapshot
success
# SDL2 builds are broken atm
#cd ~/code/sh;  .  dosboxsdl2snapshot.sh