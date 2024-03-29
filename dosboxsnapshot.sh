#!/bin/zsh
# functions
. ./functions.sh
. ./snapshots/dosbox.sh

headermain DOSBOX
bundle_name=DOSBoxSVN.app
program=./src/dosbox

cd $HOME/Code/snapshots/dosbox

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

# x86_64
build_x86_64

# arm64
build_arm64

# deploy
deploy
{

	# make fat build
	lipo_build x86_64 arm64

	# bundle
	bundle

	# make disk image
	diskimage

	# Notarize it
	notar DOSBox-snapshot.dmg

	# copy app to applications and file the snapshots
	cp -R ./$dmg_name/$bundle_name /Applications/
	cp -p $dmg_name.dmg $HOME/Snapshots/dosbox/"$(date +%y-%m-%d-%H%M) DOSBox$REVISION.dmg"
	mv -f $dmg_name.dmg $HOME/Snapshots/dosbox/

	# "upload"
	cp -p $HOME/Snapshots/dosbox/Dosbox-Snapshot.dmg $HOME/dropbox/public/dosbox/

} 2>&1 | teelog -a ; pipestatus || return

# cleanup
make -s distclean > /dev/null
rm -r DOSBox-snapshot
success
