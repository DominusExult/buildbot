#!/bin/zsh 
#functions
. ./functions.sh

headermain EXULT

cd ~/code/snapshots/exult
/usr/bin/git pull --rebase=true 2> >(teelog >&2) || error Git pull

#configure options for all arches
CONF_OPT="-q --enable-exult-studio-support --enable-mt32emu --enable-fluidsynth --disable-alsa --disable-timidity-midi --disable-tools"
export EXPACK=/opt/x86_64/bin/expack

#i386
header i386
ARCH=i386
SDK=10.11
DEPLOYMENT=10.7
flags
gcc
autogen
build 2>&1 | teelog -a ; pipestatus || return

#arm64
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

#x86_64
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
export CPPFLAGS=$CPPFLAGS' -I'$PREFIX'/include'
export CFLAGS=$CFLAGS' -I'$PREFIX'/include'
export CXXFLAGS=$CXXFLAGS' -I'$PREFIX'/include'
export LDFLAGS=$LDFLAGS' -L'$PREFIX'/lib'
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig"
autogen
build 2>&1 | teelog ; pipestatus || return

#deploy
deploy
{
	# dylibbundler on all arches and codesign the dylibs
	# 	first create the bundle resources folder to put the libs in
	mkdir -p Exult.app/Contents/Resources
	# 	arm64
	dylibbundler -od -b -x exult.arm64 -d exult.app/Contents/Resources/lib_arm64/ -p @executable_path/../Resources/lib_arm64/ -i /usr/lib/ > /dev/null
	codesign --options runtime -f -s "Developer ID Application" exult.app/contents/resources/lib_arm64/*.dylib
	# 	i386
	dylibbundler -od -b -x exult.i386 -d exult.app/Contents/Resources/lib_i386 -p @executable_path/../Resources/lib_i386 -i /usr/lib > /dev/null
	codesign --options runtime -f -s "Developer ID Application" exult.app/contents/resources/lib_i386/*.dylib
	# 	x86_64
	dylibbundler -od -b -x exult.x86_64 -d exult.app/Contents/Resources/lib_x86_64 -p @executable_path/../Resources/lib_x86_64 -i /usr/lib > /dev/null
	codesign --options runtime -f -s "Developer ID Application" exult.app/contents/resources/lib_x86_64/*.dylib
	
	#make fat exult binary
	lipo -create -arch arm64 exult.arm64 -arch x86_64 exult.x86_64 -arch i386 exult.i386 -output exult || error lipo

	#replace BundleVersion with date
	sed -i '' "s|1.7.0git<|1.7.0 $(date +"%Y-%m-%d-%H%M")<|" info.plist
	sed -i '' "s|1.7.0git<|1.7.0 $(date +"%Y-%m-%d-%H%M")<|" ./macosx/exult_studio_info.plist
	#bundle
	make -s bundle || error bundle
	make -s studiobundle || error studiobundle


	#image
	export REVISION=" $(/usr/bin/git log -1 --pretty=format:%h)"
	make -s osxdmg || error disk image
	make -s studiodmg || error studio disk image
	
	#Notarize it
	# see https://developer.apple.com/documentation/xcode/notarizing_macos_software_before_distribution/customizing_the_notarization_workflow
	xcrun altool --notarize-app --primary-bundle-id "info.exult.dmg" -u "AC_USERNAME" -p "@keychain:AC_PASSWORD" --file Exult-snapshot.dmg || error notarization
	xcrun altool --notarize-app --primary-bundle-id "info.exult.studio.dmg" -u "AC_USERNAME" -p "@keychain:AC_PASSWORD" --file ExultStudio-snapshot.dmg || error studio notarization

	#file it
	cp -p Exult-snapshot.dmg ~/Snapshots/exult/"`date +%y-%m-%d-%H%M` Exult$REVISION.dmg"
	cp -p ExultStudio-snapshot.dmg ~/Snapshots/exult/"`date +%y-%m-%d-%H%M` ExultStudio$REVISION.dmg"

	mv Exult-snapshot.dmg ~/Snapshots/exult/
	mv ExultStudio-snapshot.dmg ~/Snapshots/exult/
	cp -R Exult.app /Applications/
	cp -R Exult_Studio.app /Applications/

	#upload
	scp -p -i ~/.ssh/id_dsa ~/Snapshots/exult/Exult-snapshot.dmg $USER,exult@web.sourceforge.net:htdocs/snapshots/Exult-snapshot.dmg || error Upload
	scp -p -i ~/.ssh/id_dsa ~/Snapshots/exult/ExultStudio-snapshot.dmg $USER,exult@web.sourceforge.net:htdocs/snapshots/ExultStudio-snapshot.dmg || error Studio Upload
} 2>&1 | teelog -a ; pipestatus || return

#clean
make distclean  > /dev/null

success
