build_ppc() {
	header PPC
	ARCH=ppc
	SDK=10.5
	DEPLOYMENT=10.4
	flags
	gcc oldgcc
	autogen
	CONF_ARGS="--prefix=/opt/$ARCH"
	build 2>&1 | teelog ; pipestatus || return
}

build_i386() {
	header i386
	ARCH=i386
	SDK=10.6
	DEPLOYMENT=10.6
	flags
	gcc oldgcc
	autogen
	CONF_ARGS="--prefix=/opt/$ARCH"
	build 2>&1 | teelog ; pipestatus || return
	dylibbundle
	codesign_lib
}

build_x86_64() {
	header x86_64
	ARCH=x86_64
	SDK=10.14
	DEPLOYMENT=10.10
	flags
	gcc
	autogen
	CONF_ARGS="--prefix=/opt/$ARCH"
	build 2>&1 | teelog ; pipestatus || return
	dylibbundle
	codesign_lib
}

build_arm64() {
	header arm64
	ARCH=arm64
	SDK=11.1
	DEPLOYMENT=11.0
	flags
	gcc
	#patch -p0 -i ~/code/sh/dosbox-patches/dosbox_wx.patch > /dev/null ||  error wx patch patch
	autogen
	CONF_ARGS="--prefix=/opt/$ARCH"
	build 2>&1 | teelog ; pipestatus || return
	dylibbundle
	codesign_lib
}

bundle() {
	mkdir -p $bundle_name/Contents/MacOS
	mkdir -p $bundle_name/Contents/Resources
	mkdir -p $bundle_name/Contents/Documents
	cp ./src/dosbox $bundle_name/Contents/MacOS/
	echo "APPL????" > $bundle_name/Contents/PkgInfo
	cp ~/code/sh/dosbox-patches/Info.plist $bundle_name/Contents/
	cp ./src/platform/macosx/dosbox.icns $bundle_name/Contents/Resources/
	cp AUTHORS $bundle_name/Contents/Documents
	cp COPYING $bundle_name/Contents/Documents
	cp NEWS $bundle_name/Contents/Documents
	cp README $bundle_name/Contents/Documents
	cp THANKS $bundle_name/Contents/Documents
}

diskimage() {
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
		codesign --options runtime --deep --force --sign "Developer ID Application" ./$dmg_name/$bundle_name --entitlements ~/code/sh/dosbox-patches/entitlements.plist ||  error codesign
		hdiutil create -ov -format UDZO -imagekey zlib-level=9 -fs HFS+ \
						-srcfolder $dmg_name \
						-volname "DOSBox SVN snapshot$REVISION" \
						$dmg_name.dmg || error disk image
}

diskimage_compat() {
	# x86_64
	cp /opt/x86_64/lib/libSDL-1.2.0compat.dylib ./$dmg_name/$bundle_name/Contents/Resources/lib_x86_64/libSDL-1.2.0.dylib
	codesign --options runtime -f -s "Developer ID Application" ./$dmg_name/$bundle_name/Contents/Resources/lib_x86_64/libSDL-1.2.0.dylib
	cp /opt/x86_64/lib/libSDL2-2.0.0.dylib ./$dmg_name/$bundle_name/Contents/Resources/lib_x86_64/
	codesign --options runtime -f -s "Developer ID Application" ./$dmg_name/$bundle_name/Contents/Resources/lib_x86_64/libSDL2-2.0.0.dylib
	# i386
	cp /opt/i386/lib/libSDL-1.2.0compat.dylib ./$dmg_name/$bundle_name/Contents/Resources/lib_i386/libSDL-1.2.0.dylib
	codesign --options runtime -f -s "Developer ID Application" ./$dmg_name/$bundle_name/Contents/Resources/lib_i386/libSDL-1.2.0.dylib
	cp /opt/i386/lib/libSDL2-2.0.0.dylib ./$dmg_name/$bundle_name/Contents/Resources/lib_i386/
	codesign --options runtime -f -s "Developer ID Application" ./$dmg_name/$bundle_name/Contents/Resources/lib_i386/libSDL2-2.0.0.dylib
	# rename and make dmg
	mv ./$dmg_name/$bundle_name ./$dmg_name/DOSBoxSDL2compat.app
	hdiutil create -ov -format UDZO -imagekey zlib-level=9 -fs HFS+ \
					-srcfolder $dmg_name \
					-volname "DOSBox SVN SDL2compat snapshot$REVISION" \
					DOSBox-SDL2compat.dmg || error disk image
}
