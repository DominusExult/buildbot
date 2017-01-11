(* 
	This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it is useable with newer OS X versions!
	In Mail.app set a Rule 
	"if any of the following conditions are met:
	Any recipient contains exult-cvs-logs@lists.sourceforge.net
	Any recipient contains pentagram-cvs@lists.sourceforge.net
	Any recipient contains nuvie-svn@lists.sourceforge.net
	Any recipient contains xu4-commits@lists.sourceforge.net
	Any recipient contains dosbox-cvs-log@lists.sourceforge.net
	Run AppleScript snapshots" 
	The script will further check the subject for stuff 
	to make sure that it is new code and not other things 
	(e.g. Exult may have commits for the webspace repository)
*)
using terms from application "Mail"
	on perform mail action with messages theMessages for rule Snapshots
		tell application "Mail"
			repeat with eachMessage in theMessages
				set theSubject to the subject of eachMessage
				set theBody to the content of eachMessage
				set xu4 to "xU4"
				set exult to "Exult"
				set pent to "Pentagram"
				set dos to "DOSBox"
				set nuvie to "Nuvie"
				if theSubject begins with "[" & xu4 and theSubject contains "trunk/u4" and theSubject does not contain "trunk/u4/src/iOS" then
					set subj to xu4
				else if theSubject begins with "[" & exult and theSubject contains "[exult/exult]" then
					set subj to exult
				else if theSubject begins with "[" & pent and theSubject contains pent & "/trunk" then
					set subj to pent
				else if theSubject begins with "[Dosbox" then
					set subj to dos
				else if theSubject begins with "[" & nuvie and theSubject contains "[nuvie/nuvie]" then
					set subj to nuvie
				end if
			end repeat
		end tell
		# setting path to the folder of the lockfiles
		set fullpath to ((path to home folder) as string) & ".local"
		set lockfile1 to (fullpath & ":" & subj & "build1.lockfile")
		set lockfile2 to (fullpath & ":" & subj & "build2.lockfile")
		# For showing the icon in the Dialog, the icon path is set to the Apps' app folder in /Applications
		set icon_path to ((path to applications folder) as string) & subj & ".app:Contents:Resources:" & subj & ".icns"
		
		(*
			Now we check for the two lockfiles and if necessary create them.
			On first run of the script we create the first one (which eventually 
			will be deleted by the shell script we use to build the snapshot).
			When the shell script is not yet done running but a new commit is being 
			detected by Mail.app this AppleScript is run again but will create a 
			second lockfile and will wait for (loop until) the first buildjob to 
			finish and delete the first lockfile. 
			In that case it will delete the second lockfile and recreate the first 
			one again.
			IF there is another commit being detected while this script loops and 
			waits for the first lockfile to be deleted, the new AppleScript process will quit.
		*)
		try
			lockfile1 as alias
			try
				lockfile2 as alias
				return
			on error
				do shell script ("touch " & POSIX path of file lockfile2)
				tell application "System Events"
					repeat while (file lockfile1 exists) = true
					end repeat
				end tell
				do shell script ("rm " & POSIX path of file lockfile2)
				do shell script ("touch " & POSIX path of file lockfile1)
			end try
		on error
			do shell script ("touch " & POSIX path of file lockfile1)
			try
				lockfile2 as alias
				do shell script ("rm " & POSIX path of file lockfile2)
			end try
		end try
		
		activate
		(* 
			Now the script asks you whether you want to build a new 
			Snapshot of either of those Projects.
			Then it will open a new Terminal and execute the applicable 
			project snapshot script in ~/code/sh (where I store my scripts)
		*)
		set snapshotdialog to display dialog "New revision!!!


Build " & subj & " snapshot?
" buttons {"No", "OK"} giving up after 110 with icon alias icon_path with title subj
		if button returned of snapshotdialog = "OK" or gave up of snapshotdialog is true then
			tell application "Terminal"
				activate
				tell application "System Events" to tell process "Terminal" to keystroke "t" using {command down}
				repeat while contents of selected tab of window 1 starts with linefeed
				delay 0.01
			end repeat
				do script "cd ~/code/sh; . " & subj & "snapshot.sh" in selected tab of the front window
			end tell
			# if the build is canceled delete the first lockfile
		else if button returned of snapshotdialog = "No" then
			do shell script ("rm " & POSIX path of file lockfile1)
			return
		end if
	end perform mail action with messages
end using terms from