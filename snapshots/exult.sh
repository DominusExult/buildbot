build_x86_64() {
	header x86_64
	ARCH=x86_64
	SDK=13.3
	DEPLOYMENT=10.11
	flags
	gcc
	#only codesign on the native arch
	if [ $(uname -m) = $ARCH ]; then
		CONF_ARGS=" --with-macosx-code-signature"
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
	cp $program2 $program2.$ARCH || error $program2 cpstrip
	dylibbundle
	codesign_lib
}

build_arm64() {
	header arm64
	ARCH=arm64
	SDK=13.3
	DEPLOYMENT=11.1
	flags
	gcc
	#only codesign on the native arch
	if [ $(uname -m) = $ARCH ]; then
		CONF_ARGS=" --with-macosx-code-signature"
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
	cp $program2 $program2.$ARCH || error $program2 cpstrip
	dylibbundle
	codesign_lib
}

sf_upload() {
	scp -p -i ~/.ssh/id_ed25519 ~/Snapshots/exult/Exult-snapshot.dmg ~/Snapshots/exult/ExultStudio-snapshot.dmg $SF_USERNAME,exult@web.sourceforge.net:htdocs/snapshots || error Upload
}