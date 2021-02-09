(* This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it is useable with newer OS X versions!
	In Mail.app set a Rule 
	"if all of the following conditions are met:
	Any recipient contains xu4-commits@lists.sourceforge.net
	Subject contains trunk/u4
	Subject does NOT contain trunk/u4/src/iOS
	Subject begins with [Xu4
	Run AppleScript xu4SnapshotsMAIL" 
*)
set subj to "XU4"
# For showing the icon in the Dialog, the icon path is set to the xu4.app's app folder in /Applications
set icon_path to (path to applications folder as string) & subj & ".app:Contents:Resources:" & subj & ".icns"
tell application "Mail"
	activate
	(* Now the script asks you whether you want to build a new 
	Snapshot of xu4.
	Then it will open a new Terminal and execute xu4snapshot.sh 
	in ~/code/sh (where I store my scripts)
	*)
	set snapshotdialog to display dialog "New revision!!!

Build " & subj & " snapshot?
" buttons {"Cancel", "OK"} giving up after 110 with icon alias icon_path with title subj
	if button returned of snapshotdialog = "OK" or gave up of snapshotdialog is true then
		tell application "Terminal"
			activate
			tell application "System Events" to tell process "Terminal" to keystroke "t" using {command down}
			delay 1
			do script "cd ~/code/sh; ./" & subj & "snapshot.sh" in selected tab of the front window
		end tell
	end if
end tell