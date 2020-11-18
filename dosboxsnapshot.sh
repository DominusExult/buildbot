#!/bin/zsh
# functions
. ./functions.sh

headermain DOSBOX


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

# x86_64
header x86_64
ARCH=x86_64
SDK=10.14
DEPLOYMENT=10.10
flags
gcc
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	patch -p0 -i ~/code/sh/dosbox-patches/intel64.diff > /dev/null ||  error intel64 patch
	makes
	strip ./src/dosbox -o ./src/dosbox_x86_64 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

make -s distclean > /dev/null

# i386
header i386
ARCH=i386
SDK=10.6
DEPLOYMENT=10.6
flags
gcc oldgcc
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	patch -p0 -i ~/code/sh/dosbox-patches/intel.diff > /dev/null ||  error intel patch
	makes
	strip ./src/dosbox -o ./src/dosbox_i386 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

make -s distclean > /dev/null

# ppc
header PPC
ARCH=ppc
SDK=10.5
DEPLOYMENT=10.4
flags
gcc oldgcc
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	patch -p0 -i ~/code/sh/dosbox-patches/ppc.diff > /dev/null ||  error ppc patch
	makes
	strip ./src/dosbox -o ./src/dosbox_ppc
} 2>&1 | teelog -a ; pipestatus || return

make -s distclean > /dev/null

# arm64
header arm64
ARCH=arm64
SDK=11.0
DEPLOYMENT=11.0
flags
gcc
patch -p0 -i ~/code/sh/dosbox-patches/dosbox_wx.patch > /dev/null ||  error wx patch patch
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	patch -p0 -i ~/code/sh/dosbox-patches/arm64.diff > /dev/null ||  error arm64 patch
	makes
	strip ./src/dosbox -o ./src/dosbox_arm64 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

# deploy
deploy
{
	# make fat build
	lipo -create -arch arm64 ./src/dosbox_arm64 -arch x86_64 ./src/dosbox_x86_64 -arch i386 ./src/dosbox_i386 -arch ppc ./src/dosbox_ppc -output ./src/DOSBox  ||  error lipo

	# bundle
	bundle_name=DOSBoxSVN.app
		mkdir -p $bundle_name/Contents/MacOS
		mkdir -p $bundle_name/Contents/Resources
		mkdir -p $bundle_name/Contents/Documents
		cp ./src/dosbox $bundle_name/Contents/MacOS/
		echo "APPL????" > $bundle_name/Contents/PkgInfo
		cp ~/code/sh/dosbox-patches/Info.plist $bundle_name/Contents/
		cp ~/code/sh/dosbox-patches/entitlements.plist $bundle_name/Contents/
		cp ~/code/sh/dosbox-patches/dosbox.icns $bundle_name/Contents/Resources/
		cp AUTHORS $bundle_name/Contents/Documents
		cp COPYING $bundle_name/Contents/Documents
		cp NEWS $bundle_name/Contents/Documents
		cp README $bundle_name/Contents/Documents
		cp THANKS $bundle_name/Contents/Documents

	# codesign to satisfy OS X 10.8+ Gatekeeper, Remove old Codesign to make Notarization happy
	codesign --options runtime --deep --force --sign "Developer ID Application" $bundle_name --entitlements $bundle_name/contents/entitlements.plist ||  error codesign

	# make disk image
	dmg_name=DOSBox-snapshot
		mkdir -p $dmg_name
		cp AUTHORS ./$dmg_name/Authors
		cp COPYING ./$dmg_name/License
		cp NEWS ./$dmg_name/News
		cp README ./$dmg_name/ReadMe
		cp THANKS ./$dmg_name/Thanks
		SetFile -t ttro -c ttxt ./$dmg_name/Authors
		SetFile -t ttro -c ttxt ./$dmg_name/License
		SetFile -t ttro -c ttxt ./$dmg_name/News
		SetFile -t ttro -c ttxt ./$dmg_name/ReadMe
		SetFile -t ttro -c ttxt ./$dmg_name/Thanks
		cp -R $bundle_name ./$dmg_name/
		hdiutil create -ov -format UDZO -imagekey zlib-level=9 -fs HFS+ \
						-srcfolder $dmg_name \
						-volname "DOSBox SVN snapshot$REVISION" \
						$dmg_name.dmg || error disk image

	# copy app to applications and file the snapshots
	cp -R ./src/DOSBoxSVN.app /Applications/
	cp -p Dosbox-Snapshot.dmg ~/Snapshots/dosbox/"`date +%y-%m-%d-%H%M` DOSBox$REVISION.dmg"
	
	# Notarize it
	xcrun altool --notarize-app --primary-bundle-id "com.dosbox.dmg" --username "APPLE ID" --password "PASSWORD" --file Dosbox-Snapshot.dmg  ||  error notarize
	mv Dosbox-Snapshot.dmg ~/Snapshots/dosbox/

	# "upload"
	cp -p ~/Snapshots/dosbox/Dosbox-Snapshot.dmg ~/dropbox/public/dosbox/
} 2>&1 | teelog -a ; pipestatus || return


# cleanup
make -s distclean > /dev/null
rm -r $dmg_name
success
# SDL2 builds are broken atm
#cd ~/code/sh;  .  dosboxsdl2snapshot.sh