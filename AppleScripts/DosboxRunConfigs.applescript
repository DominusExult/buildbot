(*
	this script assumes that you have different DOSBox config files in
	~/Documents/dosbox.
	It will list all *.conf files and on doubleclick will start DOSBox 
	with this config on top of the normal config/Preference file.
	you should make sure that you have assigned *.conf files to your 
	favourite text editor.
	if you cancel this, DOSBox will start normally.
	It will log everything to /tmp/dosbox.log.
*)
set dosbox to "/Applications/DOSBox.app/Contents/MacOS/dosbox"
set confpath to (path to documents folder from user domain as text) & "dosbox:"
set confpathPosix to POSIX path of confpath
set the_list to ""
set nl to ASCII character 10
tell application "Finder"
	set file_list to name of every file of folder confpath whose name ends with ".conf"
	repeat with entry in file_list
		set the_list to the_list & nl & entry
	end repeat
end tell
--set options to (choose from list file_list with prompt "DOSBox spielt heute")
set options to (((choose from list file_list with prompt "DOSBox plays today") as string) & "'" & "&> /tmp/dosbox.log &")
if options is not false then
	do shell script dosbox & " -userconf -conf '" & confpathPosix & options
else if options is false then
	do shell script dosbox & "&> /tmp/dosbox.log &"
end if