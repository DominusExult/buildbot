#!/usr/bin/env bash
#functions
. ./functions.sh

header NUVIE

cd ~/code/snapshots/nuvie
/usr/bin/git pull --rebase=true 2> >(teelog >&2) || error GIT pull

#get revision for labeling the dmg later
export REVISION=" $(/usr/bin/git log -1 --pretty=format:%h)"
# fixing wrong version and revision number in nuvie.cpp
#or not for now
#sed -i .bak "s/Nuvie: ver 0.4 rev 1577/Nuvie: ver 0.5svn $REVISION/" nuvie.cpp

#configure options for all arches
CONF_OPT='-q --disable-tools'

#x86_64
header x86_64
ARCH=x86_64
SDK=10.11
DEPLOYMENT=10.7
flags
gcc
autogen
{
	./configure $CONF_OPT --with-macosx-static-lib-path=/opt/$ARCH/lib || error $ARCH configure
	make clean > /dev/null
	make -j9 -s  > /dev/null || error $ARCH make
	stripp $target
} 2>&1 | teelog ; pipestatus || return
make distclean > /dev/null

#ppc
header PPC
ARCH=ppc
SDK=10.5
DEPLOYMENT=10.4
flags
gcc oldgcc
autogen
{
	./configure $CONF_OPT --with-macosx-static-lib-path=/opt/$ARCH/lib --host=powerpc-apple-darwin || error $ARCH configure
	make clean > /dev/null
	make -j9 -s > /dev/null || error $ARCH make
	stripp $target
} 2>&1 | teelog ; pipestatus || return
make distclean > /dev/null

#i386
header i386
ARCH=i386
SDK=10.11
DEPLOYMENT=10.5
flags
gcc arch
autogen
{
	./configure $CONF_OPT --with-macosx-static-lib-path=/opt/$ARCH/lib --with-macosx-code-signature || error $ARCH configure
	make clean > /dev/null
	make -j9 -s > /dev/null || error $ARCH make
	stripp $target
} 2>&1 | teelog ; pipestatus || return

{
	#make fat universal binary
	lipo -create -arch x86_64 nuvie_x86_64 -arch i386 nuvie_i386 -arch ppc nuvie_ppc -output nuvie || error lipo

	#bundle
	make -s bundle || error bundle

	#image, upload
	make -s osxdmg || error disk image

	cp -p Nuvie-snapshot.dmg ~/Snapshots/nuvie/"`date +%y-%m-%d-%H%M` Nuvie$REVISION.dmg"
	mv Nuvie-snapshot.dmg ~/Snapshots/nuvie/
	cp -R Nuvie.app /Applications/
	scp -p -i ~/.ssh/id_dsa ~/Snapshots/nuvie/Nuvie-snapshot.dmg $USER,nuvie@web.sourceforge.net:htdocs/snapshots/Nuvie.dmg || error Upload
	#copying back the original nuvie.cpp which we had used sed on at the beginning of the script
	#cp nuvie.cpp.bak nuvie.cpp
} 2>&1 | teelog ; pipestatus || return

#clean
make distclean > /dev/null
