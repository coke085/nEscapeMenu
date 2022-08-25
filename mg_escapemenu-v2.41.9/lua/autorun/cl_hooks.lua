--[[
	Clean Escape Menu
	Created by Chessnut (http://steamcommunity.com/profiles/76561198061646935)
--]]

hook.Add("PreRender", "cleanEscape", function()
	if (!IsValid(cleanEscape.menu) and gui.IsGameUIVisible()) then
		vgui.Create("cleanEscape")

		if (gui.IsConsoleVisible()) then
			RunConsoleCommand("showconsole")
		end
	end
end)

hook.Add("RenderScreenspaceEffects", "ceScreenEffects", function()
	if (IsValid(cleanEscape.menu)) then
		cleanEscape.menu:RenderScreenspaceEffects()
	end
end)