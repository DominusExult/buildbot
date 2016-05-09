(*
	this script assumes that you have different DOSBox config files in
	~/Documents/dosbox.
	It will list all *.conf files and will open them with a text editor.
	you should make sure that you have assigned *.conf files to your 
	favourite text editor.
	if you cancel this, the script will look for any DOSBox preference file in 
	~/Library/Preferences (0.74 or SVN or other) - this may take a moment.
*)
set confpath to (path to documents folder from user domain as text) & "dosbox:"
set confpathPosix to POSIX path of confpath
set prefpath to (path to preferences folder from user domain as text)
set prefpathPosix to POSIX path of prefpath
set the_list to ""
set nl to ASCII character 10
tell application "Finder"
	set file_list to name of every file of folder confpath whose name ends with ".conf"
	repeat with entry in file_list
		set the_list to the_list & nl & entry
	end repeat
end tell
set optionen to (choose from list file_list with prompt "DOSBox configs")
if optionen is not false then
	do shell script "open " & confpathPosix & optionen as string
else if optionen is false then
	-- faster but limited to one entry
	-- do shell script "open '" & prefpathPosix & "DOSBox 0.74 Preferences'"
	-- end if
	set the_list to ""
	tell application "Finder"
		set newfile_list to name of every file of folder prefpath whose name begins with "Dosbox"
		repeat with entry in newfile_list
			set the_list to the_list & nl & entry
		end repeat
	end tell
	set newoptionen to (choose from list newfile_list with prompt "DOSBox Preferences")
	if newoptionen is not false then
		do shell script "open '" & prefpathPosix & newoptionen & "'"
	end if
end if