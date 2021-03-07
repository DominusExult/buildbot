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

notar() {
	NOTARIZE_APP_LOG=$(mktemp -t notarize-app)
	NOTARIZE_INFO_LOG=$(mktemp -t notarize-info)
	
	# see https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution/customizing_the_notarization_workflow
	if xcrun altool --notarize-app --primary-bundle-id "info.exult.dmg" -u $AC_USERNAME -p "@keychain:AC_PASSWORD" --file Exult-snapshot.dmg > "$NOTARIZE_APP_LOG" 2>&1; then
		cat "$NOTARIZE_APP_LOG"
		RequestUUID=$(awk -F ' = ' '/RequestUUID/ {print $2}' "$NOTARIZE_APP_LOG")

		# check status periodically
		while sleep 60 && date; do
			# check notarization status
			if xcrun altool --notarization-info "$RequestUUID" --username "$AC_USERNAME" --password "@keychain:AC_PASSWORD" > "$NOTARIZE_INFO_LOG" 2>&1; then
				cat "$NOTARIZE_INFO_LOG"

				# once notarization is complete, run stapler
				if ! grep -q "Status: in progress" "$NOTARIZE_INFO_LOG"; then
					xcrun stapler staple Exult-snapshot.dmg
				fi
			else
				cat "$NOTARIZE_INFO_LOG" 1>&2
			fi
		done
	else
		cat "$NOTARIZE_APP_LOG" 1>&2
	fi
	if xcrun altool --notarize-app --primary-bundle-id "info.exult.studio.dmg" -u $AC_USERNAME -p "@keychain:AC_PASSWORD" --file ExultStudio-snapshot.dmg > "$NOTARIZE_APP_LOG" 2>&1; then
		cat "$NOTARIZE_APP_LOG"
		RequestUUID=$(awk -F ' = ' '/RequestUUID/ {print $2}' "$NOTARIZE_APP_LOG")

		# check status periodically
		while sleep 60 && date; do
			# check notarization status
			if xcrun altool --notarization-info "$RequestUUID" --username "$AC_USERNAME" --password "@keychain:AC_PASSWORD" > "$NOTARIZE_INFO_LOG" 2>&1; then
				cat "$NOTARIZE_INFO_LOG"

				# once notarization is complete, run stapler
				if ! grep -q "Status: in progress" "$NOTARIZE_INFO_LOG"; then
					xcrun stapler staple ExultStudio-snapshot.dmg
				fi
			else
				cat "$NOTARIZE_INFO_LOG" 1>&2
			fi
		done
	else
		cat "$NOTARIZE_APP_LOG" 1>&2
	fi
}

sf_upload() {
	scp -p -i ~/.ssh/id_r sa ~/Snapshots/exult/Exult-snapshot.dmg ~/Snapshots/exult/ExultStudio-snapshot.dmg $SF_USERNAME,exult@web.sourceforge.net:htdocs/snapshots || error Upload
}