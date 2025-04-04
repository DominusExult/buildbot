build_x86_64() {
	header x86_64
	ARCH=x86_64
	SDK=14.5
	DEPLOYMENT=10.12
	flags
	gcc
	#only codesign on the native arch
	if [ $SYSARCH = $ARCH ]; then
		CONF_ARGS=" --with-macosx-code-signature"
	fi
	export PREFIX=/opt/gtk3
	export PATH=$PREFIX/bin/:$PATH
	export CPPFLAGS='-I'$PREFIX'/include '$CPPFLAGS
	export CFLAGS='-I'$PREFIX'/include '$CFLAGS
	export CXXFLAGS='-I'$PREFIX'/include '$CXXFLAGS
	export LDFLAGS='-L'$PREFIX'/lib '$LDFLAGS
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
	autore
	build 2>&1 | teelog ; pipestatus || return
	stripp_all "${main_binaries[@]}"
	stripp_all "${tools_binaries[@]}"
	dylibbundle
	codesign_lib
}

build_arm64() {
	header arm64
	ARCH=arm64
	SDK=14.5
	DEPLOYMENT=11.1
	flags
	gcc
	#only codesign on the native arch
	if [ $SYSARCH = $ARCH ]; then
		CONF_ARGS=" --with-macosx-code-signature"
	fi
	export PREFIX=/opt/gtk3
	export PATH=$PREFIX/bin/:$PATH
	export CPPFLAGS='-I'$PREFIX'/include '$CPPFLAGS
	export CFLAGS='-I'$PREFIX'/include '$CFLAGS
	export CXXFLAGS='-I'$PREFIX'/include '$CXXFLAGS
	export LDFLAGS='-L'$PREFIX'/lib '$LDFLAGS
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
	autore
	build 2>&1 | teelog ; pipestatus || return
	stripp_all "${main_binaries[@]}"
	stripp_all "${tools_binaries[@]}"
	dylibbundle
	codesign_lib
}

sf_upload() {
	scp -p -i $HOME/.ssh/id_ed25519 \
		$HOME/Snapshots/exult/Exult-snapshot.dmg \
		$HOME/Snapshots/exult/ExultStudio-snapshot.dmg \
		$HOME/Snapshots/exult/exult_tools_macOS.zip \
		$HOME/Snapshots/exult/exult_shp_macos.aseprite-extension \
		$SF_USERNAME,exult@web.sourceforge.net:htdocs/snapshots || error Upload
}