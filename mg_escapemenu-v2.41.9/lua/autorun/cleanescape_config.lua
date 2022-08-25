--[[

	Clean Escape Menu

	Created by Chessnut (http://steamcommunity.com/profiles/76561198061646935)

--]]



cleanEscape = cleanEscape or {}



--[[ Determines the buttons for the escape menu.



	Each line should look like this:

	["name here"] = action,



	Types of actions:

		"Close" - Closes the menu.

		"Server: <ip>" - Connects to the specified IP.



	All other actions will run as console commands.

	You can specify a list to have separate page. (use {})



	You can see some useful examples below. Just remove the -- from the front of each line below.

--]]

cleanEscape.buttons = {

	{name = "Return", action = "return"},

	{name = "Website", action = "https://discord.gg/PC4dtdwamQ"},

	{name = "Donate", action = "https://www.paypal.com/paypalme/thegamingcommunity?country.x=GB&locale.x=en_GB"},

	{name = "Other", action = {

		{name = "Store", action = "https://www.paypal.com/paypalme/thegamingcommunity?country.x=GB&locale.x=en_GB5"},

		{name = "Documentation", action = "https://discord.gg/PC4dtdwamQ"},
      
      	{name = "Projects", action = "https://github.com/coke085?tab=repositories"},
      
      	{name = "Nonay", action = "https://discord.com/oauth2/authorize?client_id=756147870520049745&scope=bot&permissions=8"}

	}},

	{name = "Options", action = "game:openoptionsdialog"},

	{name = "Disconnect", action = "disconnect"},

}



-- Determines the main color of the menu

cleanEscape.color = Color(82, 179, 217)



-- The font used for menu text.

cleanEscape.font = "Century Gothic"



-- The title of the game menu.

-- This looks best when using caps.

cleanEscape.name = "Method Gaming"



-- Font creation stuff here, don't touch.

do

	surface.CreateFont("ceTitleFont", {

		font = cleanEscape.font,

		size = 54,

		weight = 800

	})



	surface.CreateFont("ceButtonFont", {

		font = cleanEscape.font,

		size = 36,

		weight = 500

	})

end