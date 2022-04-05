build_i386() {
	header i386
	ARCH=i386
	SDK=10.11
	DEPLOYMENT=10.9
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
	CONF_ARGS=" --enable-exult-studio"
	#only codesign on the native arch
	if [ $(uname -m) = $ARCH ]; then
		CONF_ARGS="$CONF_ARGS --with-macosx-code-signature"
	fi
	#building Exult Studio for x86_64
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
	SDK=12.3
	DEPLOYMENT=11.0
	flags
	gcc
	CONF_ARGS=" --enable-exult-studio"
	#only codesign on the native arch
	if [ $(uname -m) = $ARCH ]; then
		CONF_ARGS="$CONF_ARGS --with-macosx-code-signature"
	fi
	#building Exult Studio for arm64
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

sf_upload() {
	scp -p -i ~/.ssh/id_rsa ~/Snapshots/exult/Exult-snapshot.dmg ~/Snapshots/exult/ExultStudio-snapshot.dmg $SF_USERNAME,exult@web.sourceforge.net:htdocs/snapshots || error Upload
}