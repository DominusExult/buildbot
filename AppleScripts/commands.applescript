(* 
	This script needs to be in ~/Library/Application Scripts/com.apple.mail/ that it 
	is useable with newer OS X versions!
	In Mail.app set a Rule that triggers when a new mail is received by a certain 
	email address 
	*and* when it contains triggerword 1 in the subject 
	*and* triggerword2 in the subject.
	This script does either delete the lockfiles (see snapshot.applescript),
	or trigger the snpshot build scripts.
	For example the mail subject:
	"triggerword1 triggerword2 lockfile" will delete all the projects' lockfiles
	"triggerword1 triggerword2 exult lockfile" will delete the Exult lockfiles
	"triggerword1 triggerword2 compile exult" will start the snpashot script for Exult
*)
using terms from application "Mail"
	on perform mail action with messages theMessages for rule Snapshots
		set fullpath to ((path to home folder) as string) & ".local:"
		tell application "Mail"
			repeat with eachMessage in theMessages
				set theSubject to the subject of eachMessage
				set theBody to the content of eachMessage
				set projects to {"exult", "pentagram", "nuvie", "dosbox", "xu4"}
				set subj to "0"
				repeat with i from 1 to the count of projects
					if theSubject contains item i of projects then
						set subj to item i of projects as string
					end if
				end repeat
				activate
				if theSubject contains "lockfile" then
					if subj contains "0" then
						do shell script ("rm -f " & POSIX path of fullpath & "*.lockfile")
					else
						do shell script ("rm -f " & POSIX path of fullpath & subj & "build*.lockfile")
					end if
				else if theSubject contains "compile" then
					if subj contains "0" then
						return
					else
						tell application "Terminal"
							activate
							activate
							tell application "System Events" to tell process "Terminal" to keystroke "t" using {command down}
							delay 1
							do script "cd ~/code/sh; . " & subj & "snapshot.sh" in selected tab of the front window
						end tell
					end if
				end if
			end repeat
		end tell
	end perform mail action with messages
end using terms from