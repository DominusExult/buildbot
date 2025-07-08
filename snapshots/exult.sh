# shellcheck shell=bash
gtk3() {
	export PREFIX="/opt/gtk3"
	export PATH="$PREFIX/bin/:$PATH"
	export CPPFLAGS="-I$PREFIX/include $CPPFLAGS"
	export CFLAGS="-I$PREFIX/include $CFLAGS"
	export CXXFLAGS="-I$PREFIX/include $CXXFLAGS"
	export LDFLAGS="-L$PREFIX/lib $LDFLAGS"
	export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
}

tools_build() {
	mkdir -p ./toolspack/data || error "Failed to create toolspack/data directory"
	stripp_all "${tools_binaries[@]}" -p ./toolspack/
	cp ./tools/smooth/libsmooth_randomize.so ./toolspack/libsmooth_randomize.so."$ARCH"
	cp ./tools/smooth/libsmooth_smooth.so ./toolspack/libsmooth_smooth.so."$ARCH"
	cp ./tools/smooth/libsmooth_stream.so ./toolspack/libsmooth_stream.so."$ARCH"
	dylibbundler -b -ns -od -of -cd \
	  -x ./toolspack/ipack."$ARCH" \
	  -x ./toolspack/ucxt."$ARCH" \
	  -x ./toolspack/mockup."$ARCH" \
	  -x ./toolspack/smooth."$ARCH" \
	  -x ./toolspack/libsmooth_randomize.so."$ARCH" \
	  -x ./toolspack/libsmooth_smooth.so."$ARCH" \
	  -x ./toolspack/libsmooth_stream.so."$ARCH" \
	  -d ./toolspack/lib_"$ARCH" \
	  -p @executable_path/lib_"$ARCH"/
	codesign_lib ./toolspack/lib_"$ARCH"
}

common_build() {
	flags
	gcc
	#only codesign on the native arch and on the buildbot
	if [ "$BUILDBOT" = "1" ]; then
		if [ "$SYSARCH" = "$ARCH" ]; then
			export CONF_ARGS=" --with-macosx-code-signature"
		fi
	fi
	gtk3
	autore
	build 2>&1 | teelog -a ; pipestatus || return 1
	stripp_all "$program"
	rm -f "$program2"."$ARCH"
	# do not strip exult_studio - it will no longer work correctly
	cp "$program2" "$program2"."$ARCH" || error "$program2" cpstrip
	stripp_all "${aseprite_binary[@]}"
	dylibbundle &> /dev/null
	codesign_lib "$resources""$ARCH" &> /dev/null
	tools_build &> /dev/null
}

build_x86_64() {
	header x86_64
	export ARCH=x86_64
	export SDK=14.5
	export DEPLOYMENT=10.15
	common_build
}

build_arm64() {
	header arm64
	export ARCH=arm64
	export SDK=14.5
	export DEPLOYMENT=11.1
	common_build
}

sf_upload() {
	scp -p -i "$HOME"/.ssh/id_ed25519 \
		"$HOME"/Snapshots/exult/Exult-snapshot.dmg \
		"$HOME"/Snapshots/exult/ExultStudio-snapshot.dmg \
		"$HOME"/Snapshots/exult/exult_tools_macOS.zip \
		"$HOME"/Snapshots/exult/exult_shp_macos.aseprite-extension \
		"$SF_USERNAME",exult@web.sourceforge.net:htdocs/snapshots || error Upload
}

tools_package() {
	cp "$SOURCE_PATH"/tools/*.txt ./toolspack
	cp "$SOURCE_PATH"/tools/README ./toolspack
	cp "$SOURCE_PATH"/tools/mockup/*.txt ./toolspack
	cp "$SOURCE_PATH"/tools/mockup/map.png ./toolspack
	cp "$SOURCE_PATH"/tools/mockup/README ./toolspack/mockup.txt
	cp "$SOURCE_PATH"/tools/mockup/LICENCE ./toolspack/LICENCE.txt
	cp "$SOURCE_PATH"/tools/smooth/README ./toolspack/smooth.txt
	cp "$SOURCE_PATH"/tools/smooth/smooth.conf ./toolspack
	cp "$SOURCE_PATH"/tools/smooth/*.bmp ./toolspack
	cp "$SOURCE_PATH"/docs/ucc.txt ./toolspack
	cp "$SOURCE_PATH"/tools/ucxt/data/*.data ./toolspack/data
	cp "$SOURCE_PATH"/data/bginclude.uc ./toolspack/data
	cp ./tools/ucxt/data/*.data ./toolspack/data
	rm -f ./toolspack/*.x86_64 ./toolspack/*.arm64
	codesign \
	  --options runtime \
	  --timestamp \
	  --strip-disallowed-xattrs \
	  -f -s "Developer ID Application" \
	  ./toolspack/ipack \
	  ./toolspack/expack \
	  ./toolspack/cmanip \
	  ./toolspack/expack \
	  ./toolspack/ipack \
	  ./toolspack/mklink \
	  ./toolspack/rip \
	  ./toolspack/shp2pcx \
	  ./toolspack/splitshp \
	  ./toolspack/textpack \
	  ./toolspack/u7voice2syx \
	  ./toolspack/wuc \
	  ./toolspack/ucc \
	  ./toolspack/head2data \
	  ./toolspack/ucxt \
	  ./toolspack/mockup \
	  ./toolspack/smooth \
	  ./toolspack/*.so
	(cd ./toolspack && zip -r ../exult_tools_macOS.zip .)
}