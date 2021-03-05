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
	makes
	strip ./src/dosbox -o ./src/dosbox.i386 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

make -s clean > /dev/null

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
	strip ./src/dosbox -o ./src/dosbox.ppc
} 2>&1 | teelog -a ; pipestatus || return

make -s clean > /dev/null

# arm64
header arm64
ARCH=arm64
SDK=11.1
DEPLOYMENT=11.0
flags
gcc
patch -p0 -i ~/code/sh/dosbox-patches/dosbox_wx.patch > /dev/null ||  error wx patch patch
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	makes
	strip ./src/dosbox -o ./src/dosbox.arm64 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

make -s clean > /dev/null

# x86_64
header x86_64
ARCH=x86_64
SDK=10.15
DEPLOYMENT=10.10
flags
gcc
autogen
CONF_ARGS="--prefix=/opt/$ARCH"
{
	config
	makes
	strip ./src/dosbox -o ./src/dosbox.x86_64 ||  error $ARCH strip
} 2>&1 | teelog ; pipestatus || return

# deploy
deploy
{
	bundle_name=DOSBoxSVN.app
	# dylibbundler on all arches and codesign the dylibs
	# 	first create the bundle resources folder to put the libs in
	mkdir -p $bundle_name/Contents/Resources
	# 	arm64
	dylibbundler -od -b -x ./src/dosbox.arm64 -d $bundle_name/Contents/Resources/lib_arm64/ -p @executable_path/../Resources/lib_arm64/ -i /usr/lib/ > /dev/null
	codesign --options runtime -f -s "Developer ID Application" $bundle_name/contents/resources/lib_arm64/*.dylib
	# 	x86_64
	dylibbundler -od -b -x ./src/dosbox.x86_64 -d $bundle_name/Contents/Resources/lib_x86_64 -p @executable_path/../Resources/lib_x86_64 -i /usr/lib > /dev/null
	codesign --options runtime -f -s "Developer ID Application" $bundle_name/contents/resources/lib_x86_64/*.dylib
	# 	i386
	dylibbundler -od -b -x ./src/dosbox.i386 -d $bundle_name/Contents/Resources/lib_i386 -p @executable_path/../Resources/lib_i386 -i /usr/lib > /dev/null
	codesign --options runtime -f -s "Developer ID Application" $bundle_name/contents/resources/lib_i386/*.dylib
	# 	ppc
	# 	won't work as notarization will not let binaries compiled agains SDK < 10.9 through - So you need to keep the ppc build static

	# make fat build
	lipo -create -arch arm64 ./src/dosbox.arm64 -arch x86_64 ./src/dosbox.x86_64 -arch i386 ./src/dosbox.i386 -arch ppc ./src/dosbox.ppc -output ./src/dosbox  ||  error lipo

	# bundle
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
		mv -f $bundle_name ./$dmg_name/
		# codesign to satisfy OS X 10.8+ Gatekeeper
		codesign --options runtime --deep --force --sign "Developer ID Application" ./$dmg_name/$bundle_name --entitlements ./$dmg_name/$bundle_name/contents/entitlements.plist ||  error codesign
		hdiutil create -ov -format UDZO -imagekey zlib-level=9 -fs HFS+ \
						-srcfolder $dmg_name \
						-volname "DOSBox SVN snapshot$REVISION" \
						$dmg_name.dmg || error disk image
	
	# Notarize it
	# see https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution/customizing_the_notarization_workflow
	xcrun altool --notarize-app --primary-bundle-id "com.dosbox.dmg" -u "AC_USERNAME" -p "@keychain:AC_PASSWORD" --file $dmg_name.dmg  ||  error notarize
		
	# copy app to applications and file the snapshots
	cp -R ./$dmg_name/$bundle_name /Applications/
	cp -p $dmg_name.dmg ~/Snapshots/dosbox/"`date +%y-%m-%d-%H%M` DOSBox$REVISION.dmg"
	mv -f $dmg_name.dmg ~/Snapshots/dosbox/

	# "upload"
	cp -p ~/Snapshots/dosbox/Dosbox-Snapshot.dmg ~/dropbox/public/dosbox/
} 2>&1 | teelog -a ; pipestatus || return

# cleanup
make -s distclean > /dev/null
rm -r DOSBox-snapshot
success
# SDL2 builds are broken atm
#cd ~/code/sh;  .  dosboxsdl2snapshot.sh