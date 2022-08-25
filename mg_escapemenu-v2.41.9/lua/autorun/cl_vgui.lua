--[[
	Clean Escape Menu
	Created by Chessnut (http://steamcommunity.com/profiles/76561220886465360)
--]]

local amount = 5
local blur = Material("pp/blurscreen")

local function drawBlur(panel)	
	surface.SetMaterial(blur)
	surface.SetDrawColor(255, 255, 255)

	local x, y = panel:LocalToScreen(0, 0)
	
	for i = 0, 1, 0.1 do
		-- Do things to the blur material to make it blurry.
		blur:SetFloat("$blur", i * amount)
		blur:Recompute()

		-- Draw the blur material over the screen.
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, ScrW(), ScrH())
	end
end

local PANEL = {}
	function PANEL:Init()
		cleanEscape.menu = self

		self:SetSize(ScrW(), ScrH())
		self:MakePopup()
		self:SetAlpha(0)
		self:AlphaTo(255, 0.25)

		self.panel = self:Add("DPanel")
		self.panel:SetSize(480, ScrH())
		self.panel:CenterHorizontal()
		self.panel.Paint = function(this, w, h)
			drawBlur(this)

			surface.SetDrawColor(0, 0, 0, 75)
			surface.DrawRect(0, 0, w, h)
		end

		self.title = self.panel:Add("DLabel")
		self.title:Dock(TOP)
		self.title:SetTall(54)
		self.title:DockMargin(0, ScrH() * 0.33, 0, 0)
		self.title:SetText(cleanEscape.name)
		self.title:SetContentAlignment(5)
		self.title:SetTextColor(color_white)
		self.title:SetExpensiveShadow(1, color_black)
		self.title:SetFont("ceTitleFont")
		self.title.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0, 150)
			surface.DrawRect(0, 0, w, h)
		end

		self.scroll = self.panel:Add("DScrollPanel")
		self.scroll:Dock(FILL)
		self.scroll.VBar:SetWide(3)
		self.scroll:DockMargin(0, 0, 0, 0)

		local bar = self.scroll.VBar
		bar.Paint = function(this, w, h)
		end
		bar.btnUp.Paint = function(this, w, h)
		end
		bar.btnDown.Paint = function(this, w, h)
		end
		bar.btnGrip.Paint = function(this, w, h)
			surface.SetDrawColor(255, 255, 255, 50)
			surface.DrawRect(0, 0, w, h)
		end

		self:showButtons()
	end

	function PANEL:showButtons(buttons)
		if (self.buttons) then
			self.lastButtons = self.buttons
		end

		self.scroll:Clear()

		local color = cleanEscape.color
		local r, g, b = color.r, color.g, color.b

		for k, v in ipairs(buttons or cleanEscape.buttons) do
			local button = self.scroll:Add("DButton")
			button:Dock(TOP)
			button:SetTall(54)
			button:SetContentAlignment(5)
			button:SetTextColor(color_white)
			button:SetText(v.name)
			button:SetFont("ceButtonFont")
			button:SetExpensiveShadow(1, color_black)
			button.Paint = function(this, w, h)
				if (this.Depressed or this.m_bSelected) then
					surface.SetDrawColor(r * 3, g * 3, b * 3, 100)
				elseif (this.Hovered) then
					surface.SetDrawColor(r, g, b, 50)
				else
					surface.SetDrawColor(255, 255, 255, 0)
				end

				surface.DrawRect(0, 0, w, h)
			end
			button.OnCursorEntered = function(this)
				LocalPlayer():EmitSound("buttons/button15.wav", 50, 200)
			end
			button.DoClick = function(this)
				LocalPlayer():EmitSound("buttons/button15.wav", 60, 240)

				if (v.action) then
					if (type(v.action) == "string") then
						if (v.action:sub(1, 4) == "http") then
							gui.OpenURL(v.action)
						elseif (v.action == "return") then
							gui.HideGameUI()
						elseif (v.action:sub(1, 5) == "game:") then
							RunConsoleCommand("gamemenucommand", v.action:sub(6))
						else
							LocalPlayer():ConCommand(v.action)
						end
					elseif (type(v.action) == "table") then
						local buttons2 = {
							{name = "Return", action = function() self:showButtons(self.lastButtons) end}
						}

						for k, v in ipairs(v.action) do
							buttons2[#buttons2 + 1] = v
						end

						self:showButtons(buttons2)
					elseif (type(v.action) == "function") then
						v.action()
					end
				end
			end
		end

		self.buttons = buttons or cleanEscape.buttons
	end

	local viewData = {
		x = 0,
		y = 0,
		drawhud = true,
		drawviewmodel = true,
		dopostprocess = true
	}

	function PANEL:Paint(w, h)
		viewData.w = ScrW()
		viewData.h = ScrH()

		render.RenderView(viewData)
	end

	local colorData = {}
	colorData["$pp_colour_addr"] = 0
	colorData["$pp_colour_addg"] = 0
	colorData["$pp_colour_addb"] = 0
	colorData["$pp_colour_brightness"] = -0.05
	colorData["$pp_colour_contrast"] = 1
	colorData["$pp_colour_colour"] = 0
	colorData["$pp_colour_mulr"] = 0
	colorData["$pp_colour_mulg"] = 0
	colorData["$pp_colour_mulb"] = 0

	function PANEL:RenderScreenspaceEffects()
		local x, y = self.panel:LocalToScreen(0, 0)
		local w, h = 480, ScrH()

		render.SetStencilEnable(true)
			render.SetStencilWriteMask(255)
			render.SetStencilTestMask(255)

			render.ClearStencilBufferRectangle(0, 0, ScrW(), ScrH(), 0)
			render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
			render.SetStencilReferenceValue(1)
			render.ClearStencilBufferRectangle(x, y, x + w, h, 1)

			local value = self:GetAlpha() / 255

			colorData["$pp_colour_colour"] = 1 - value
			colorData["$pp_colour_brightness"] = -0.05 * value

			DrawColorModify(colorData)
		render.SetStencilEnable(false)
	end

	function PANEL:Think()
		if (!gui.IsGameUIVisible()) then
			self:Remove()
		end
	end
vgui.Register("cleanEscape", PANEL, "EditablePanel")