(*
	This script assumes that all shell scripts to compile stuff
	are in ~/code/sh.
	It will simple list all script files with the file ending *.sh 
	and will run them on doubleclick.
*)
set scriptpath to (path to home folder from user domain as text) & "code:sh:"
set the_list to ""
set nl to ASCII character 10
tell application "Finder"
	set file_list to name of every file of folder scriptpath whose name ends with ".sh"
	repeat with entry in file_list
		set the_list to the_list & nl & entry
	end repeat
end tell
set options to (choose from list file_list with prompt "Run this script")
if options is not false then
	activate application "Terminal"
	tell application "Terminal" to delay 0.25
	tell application "System Events" to tell process "Terminal" to keystroke "t" using {command down}
	tell application "Terminal"
		repeat with win in windows
			try
				if get frontmost of win is true then
					do script "cd ~/code/sh;  ./" & first item of options in (selected tab of win)
				end if
			end try
		end repeat
	end tell
end if