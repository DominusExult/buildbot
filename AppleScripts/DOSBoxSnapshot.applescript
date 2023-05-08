(* This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it is useable with newer OS X versions!
	In Mail.app set a Rule 
	"if all of the following conditions are met:
	Any recipient contains dosbox-cvs-log@lists.sourceforge.net
	Subject begins with [Dosbox
	Run AppleScript DOSBoxSnapshotsMAIL" 
*)
set subj to "DOSBox"
# For showing the icon in the Dialog, the icon path is set to DOSBox' source folder
# this patch HAS to exist or the script will fail
set icon_path to ((path to home folder) as string) & "code:snapshots:" & subj & ":src:" & subj & ".ico"
tell application "Terminal"
	activate
	(* Now the script asks you whether you want to build a new 
	Snapshot.
	Then it will open a new Terminal and execute exultsnapshot.sh 
	in ~/code/sh (where I store my scripts)
	*)
	set snapshotdialog to display dialog "New revision!!!

Build " & subj & " snapshot?
" buttons {"Cancel", "OK"} giving up after 110 with icon alias icon_path with title subj
	if button returned of snapshotdialog = "OK" or gave up of snapshotdialog is true then
		tell application "System Events" to tell process "Terminal" to keystroke "t" using {command down}
		delay 1
		do script "cd ~/code/sh; ./" & subj & "snapshot.sh" in selected tab of the front window
	end if
end tell