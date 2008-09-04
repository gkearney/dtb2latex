-- DTB2LaTex.applescript
-- DTB2LaTex

--  Created by Greg Kearney on 9/4/08.
--  Copyright 2008 __MyCompanyName__. All rights reserved.


global theXML
global theTex



on openFile()
	
	tell open panel
		set title to "Choose file to convert to LaTeX"
		set prompt to "Chose a file"
		set treat packages as directories to false
		set can choose directories to false
		set can choose files to true
		set allows multiple selection to false
	end tell
	set theTypeList to {"xml", "txt"} as list
	set theResult to display open panel for file types theTypeList
	
	if theResult is 1 then
		set theXML to path names of open panel as string
	else
		set theXML to null
	end if
	
	
end openFile

on saveFile()
	set thePrompt to "Save Tex File"
	set theTitle to "Save Tex file as…"
	tell save panel
		set title to theTitle
		set prompt to thePrompt
		set required file type to "tex"
		set treat packages as directories to false
	end tell
	
	set theResult to display save panel
	if theResult is 1 then
		set theTex to path name of save panel as string
		--set contents of text field "fileout" of tab view item "documents" of tab view "tabview" of window "main" to path name of save panel
	else
		set theTex to null
		--set contents of text field "fileout" of tab view item "documents" of tab view "tabview" of window "main" to ""
		
	end if
end saveFile

on update menu item theObject
	(*Add your script here.*)
end update menu item

on choose menu item theObject
	set appPath to path to me
	set dtbxsl to POSIX path of appPath & "Contents/Resources/dtbook2latex.xsl"
	set saxon9 to POSIX path of appPath & "Contents/Resources/saxon9.jar"
	
	
	if the name of theObject is "mopen" then
		openFile()
		saveFile()
		log theXML
		log theTex
		if theXML is not null and theTex is not null then
			set thecmd to "/usr/bin/java -jar " & saxon9 & " -xsl:" & dtbxsl & " -s:" & theXML & " -o:" & theTex & " documentclass=memoir fontsize=17 fontfamily=cmss"
			log thecmd
			set the visible of window "workingwin" to true
			-- set the visible of progress indicator "workingprogress" window "workingwin" to true
			tell progress indicator "progress" of window "workingwin" to start
			do shell script thecmd
			tell progress indicator "progress" of window "workingwin" to stop
			set the visible of window "workingwin" to false
			set finderTex to (POSIX file theTex)
			tell application "Finder"
				activate
				open finderTex
			end tell
		end if
	end if
end choose menu item
