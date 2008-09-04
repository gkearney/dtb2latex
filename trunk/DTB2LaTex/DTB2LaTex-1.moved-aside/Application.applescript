-- DTB2LaTex.applescript
-- DTB2LaTex

--  Created by Greg Kearney on 9/4/08.
--  Copyright 2008 __MyCompanyName__. All rights reserved.

on idle
	(* Add any idle time processing here. *)
end idle

on open names
	(* Add your script to process the names here. *)
	set theListSize to the count of names
	
	repeat with x from 1 to theListSize
		beep
	end repeat
	
	-- Remove the following line if you want the application to stay open.
	quit
end open


