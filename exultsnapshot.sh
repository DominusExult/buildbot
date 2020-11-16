#!/bin/zsh --emulate sh
#functions
. ./functions.sh

headermain EXULT

cd ~/code/snapshots/exult
/usr/bin/git pull --rebase=true 2> >(teelog >&2) || error Git pull

#configure options for all arches
CONF_OPT="-q --enable-mt32emu --enable-static-libraries --disable-oggtest --disable-vorbistest --disable-alsa --disable-fluidsynth --disable-timidity-midi --disable-tools"

#place the native build on the bottom to ensure data is built
#i386
header i386
ARCH=i386
SDK=10.11
DEPLOYMENT=10.7
flags
gcc
CONF_ARGS="--disable-data --with-macosx-static-lib-path=/opt/$ARCH/lib"
autogen
build 2>&1 | teelog -a ; pipestatus || return

#arm64
header arm64
ARCH=arm64
SDK=11.0
DEPLOYMENT=11.0
flags
gcc
CONF_ARGS="--with-macosx-static-lib-path=/opt/$ARCH/lib"
#only build data on the native arch
if [ $(uname -m) != $ARCH ]; then
	CONF_ARGS="$CONF_ARGS --disable-data"
else
	CONF_ARGS="$CONF_ARGS --with-macosx-code-signature"
fi
autogen
build 2>&1 | teelog ; pipestatus || return

#x86_64
header x86_64
ARCH=x86_64
SDK=10.14
DEPLOYMENT=10.10
flags
gcc
CONF_ARGS="--with-macosx-static-lib-path=/opt/$ARCH/lib"
#only build data on the native arch
if [ $(uname -m) != $ARCH ]; then
	CONF_ARGS="$CONF_ARGS --disable-data"
else
	CONF_ARGS="$CONF_ARGS --with-macosx-code-signature"
fi
autogen
build 2>&1 | teelog ; pipestatus || return

#deploy
deploy
{
	#make fat exult binary
	lipo -create -arch arm64 exult_arm64 -arch x86_64 exult_x86_64 -arch i386 exult_i386 -output exult || error lipo

	#bundle
	make -s bundle || error bundle

	#image
	export REVISION=" $(/usr/bin/git log -1 --pretty=format:%h)"
	make -s osxdmg || error disk image

	#Notarize it
	xcrun altool --notarize-app --primary-bundle-id "info.exult.dmg" --username "APPLE ID" --password "PASSWORD" --file Exult-snapshot.dmg || error notarization

	#file it
	cp -p Exult-snapshot.dmg ~/Snapshots/exult/"`date +%y-%m-%d-%H%M` Exult$REVISION.dmg"
	mv Exult-snapshot.dmg ~/Snapshots/exult/
	cp -R Exult.app /Applications/

	#upload
	#scp -p -i ~/.ssh/id_dsa ~/Snapshots/exult/Exult-snapshot.dmg $USER,exult@web.sourceforge.net:htdocs/snapshots/Exult-snapshot.dmg || error Upload
} 2>&1 | teelog -a ; pipestatus || return

#clean
make distclean  > /dev/null

success
