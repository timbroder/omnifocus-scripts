(*
	# DESCRIPTION #
	
	Inspired by OmniFocus 1 behavior, this script opens the selected task's (or tasks')
	project(s) in a new window so you can jump from a context view into the project view
	without losing place.
	
	# LICENSE #
	
	Copyright © 2015 Dan Byler (contact: dbyler@gmail.com)
	Licensed under MIT License (http://www.opensource.org/licenses/mit-license.php)
	(TL;DR: no warranty, do whatever you want with it.)
	
	# CHANGE HISTORY #
	
	1.0 (2015-04-28)
	-	Initial release

	# INSTALLATION #

	1. Copy script to OmniFocus script folder (OmniFocus -> Help -> Open Scripts Folder)
	2. (Optional) Update to use the icon in this repo
	3. Add script to the OmniFocus toolbar using View -> Customize Toolbar...
		
*)


on main()
	tell application "OmniFocus"
		set myFocus to {}
		-- get selection
		tell content of front document window of front document
			set validSelectedItemsList to value of (selected trees where class of its value is not item and class of its value is not folder)
			set totalItems to count of validSelectedItemsList
			if totalItems is 0 then
				my notifyWithoutGrowl("No valid task(s) selected")
				return
			end if
			repeat with validSelectedItem in validSelectedItemsList
				validSelectedItem
				if (containing project of validSelectedItem) is not missing value then
					set end of myFocus to (containing project of validSelectedItem)
				else if (assigned container of validSelectedItem) is not missing value then
					set end of myFocus to (assigned container of validSelectedItem)
				end if
			end repeat
		end tell
		
		-- no valid projects to focus on
		if length of myFocus is 0 then
			my notifyWithoutGrowl("No projects to focus")
			return
		end if
		
		-- make new window
		tell default document
			make new document window with properties {perspective name:"Projects"}
			delay 1
			tell application "System Events"
				keystroke "s" using command down & option down
				keystroke "i" using command down & option down
			end tell
		end tell
		
		-- set focus
		tell front document window of front document
			set focus to myFocus
		end tell
	end tell
end main

on notifyWithoutGrowl(alertText)
	tell application "OmniFocus" to display dialog alertText with icon 1 buttons {"OK"} default button "OK"
end notifyWithoutGrowl

main()
