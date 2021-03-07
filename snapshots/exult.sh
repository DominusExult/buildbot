build_i386() {
	header i386
	ARCH=i386
	SDK=10.11
	DEPLOYMENT=10.7
	flags
	gcc
	autogen
	build 2>&1 | teelog -a ; pipestatus || return
	dylibbundle
	codesign_lib
}

build_x86_64() {
	header x86_64
	ARCH=x86_64
	SDK=10.15
	DEPLOYMENT=10.10
	flags
	gcc
	CONF_ARGS=" --enable-exult-studio --enable-exult-studio-support"
	#only codesign on the native arch
	if [ $(uname -m) = $ARCH ]; then
		CONF_ARGS="$CONF_ARGS --with-macosx-code-signature"
	fi
	#building Exult Studio for 64bit as well
	export PREFIX=/opt/gtk3
	export PATH=$PREFIX/bin/:$PATH
	export CPPFLAGS='-I'$PREFIX'/include '$CPPFLAGS
	export CFLAGS='-I'$PREFIX'/include '$CFLAGS
	export CXXFLAGS='-I'$PREFIX'/include '$CXXFLAGS
	export LDFLAGS='-L'$PREFIX'/lib '$LDFLAGS
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
	autogen
	build 2>&1 | teelog ; pipestatus || return
	dylibbundle
	codesign_lib
}

build_arm64() {
	header arm64
	ARCH=arm64
	SDK=11.0
	DEPLOYMENT=11.0
	flags
	gcc
	#only codesign on the native arch
	if [ $(uname -m) = $ARCH ]; then
		CONF_ARGS="$CONF_ARGS --with-macosx-code-signature"
	fi
	autogen
	build 2>&1 | teelog ; pipestatus || return
	dylibbundle
	codesign_lib
}

lipo_build() {
	lipo -create -arch arm64 $program.arm64 -arch x86_64 $program.x86_64 -arch i386 $program.i386 -output $program  ||  error lipo
}

notar() {
	# see https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution/customizing_the_notarization_workflow
	xcrun altool --notarize-app --primary-bundle-id "info.exult.dmg" -u $AC_USERNAME -p "@keychain:AC_PASSWORD" --file Exult-snapshot.dmg || error notarization
	xcrun altool --notarize-app --primary-bundle-id "info.exult.studio.dmg" -u $AC_USERNAME -p "@keychain:AC_PASSWORD" --file ExultStudio-snapshot.dmg || error studio notarization
}

sf_upload() {
	scp -p -i ~/.ssh/id_rsa ~/Snapshots/exult/Exult-snapshot.dmg ~/Snapshots/exult/ExultStudio-snapshot.dmg $SF_USERNAME,exult@web.sourceforge.net:htdocs/snapshots || error Upload
}