PANEL = {}

local garry = Material("project_avatar/hud/ts/garry.png")
local kratos = Material("project_avatar/hud/ts/kratos.png")
local newguy = Material("project_avatar/hud/ts/newguy.png")
local circle = Material("project_avatar/hud/ts/circle.png")

local basew, baseh = 500, 900
local scale = 1

function PANEL:Init()
	self.BlurStart = SysTime()
	-- {"None", "Garry", "Circle", "Newguy", "Kratos"}
	self:SetSize(ScrW(), ScrH())

	self.Main = vgui.Create("DFrame", self)
	self.Main:SetSize(ScrW(), ScrH())
	self.Main:ShowCloseButton(false)
    self.Main:SetDraggable( false ) 
	self.Main:Center()

	self.garry = vgui.Create("DButton", self.Main)
	self.garry:SetText("")
	self.garry:SetSize(basew * scale, baseh * scale)
	self.garry:SetPos(-basew * scale, 0)
	self.garry.DoClick = function()
		net.Start("PA_ClassSelect")
			net.WriteUInt(1, 3)
		net.SendToServer()
	end
	self.garry.Paint = function(s, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(garry)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	self.kratos = vgui.Create("DButton", self.Main)
	self.kratos:SetText("")
	self.kratos:SetSize(basew * scale, baseh * scale)
	self.kratos:SetPos(-basew * scale, 0)
	self.kratos.DoClick = function()
		net.Start("PA_ClassSelect")
			net.WriteUInt(4, 3)
		net.SendToServer()
	end
	self.kratos.Paint = function(s, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(kratos)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	self.circle = vgui.Create("DButton", self.Main)
	self.circle:SetText("")
	self.circle:SetSize(basew * scale, baseh * scale)
	self.circle:SetPos(-basew * scale, 0)
	self.circle.DoClick = function()
		net.Start("PA_ClassSelect") 
			net.WriteUInt(2, 3)
		net.SendToServer()

	end
	self.circle.Paint = function(s, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(circle)
		surface.DrawTexturedRect(0, 0, w, h)
	end

	self.newguy = vgui.Create("DButton", self.Main)
	self.newguy:SetText("")
	self.newguy:SetSize(basew * scale, baseh * scale)
	self.newguy:SetPos(-basew * scale, 0)
	self.newguy.DoClick = function()
		net.Start("PA_ClassSelect") 
			net.WriteUInt(3, 3)
		net.SendToServer()
	end
	self.newguy.Paint = function(s, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(newguy)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	
	self.newguy:MoveTo(ScrW()/4*0, 0, 1/4, 1/8*0, 0.3)
	self.garry:MoveTo(ScrW()/4*1, 0, 1/4, 1/8*1, 0.3)
	self.circle:MoveTo(ScrW()/4*2, 0, 1/4, 1/8*2, 0.3)
	self.kratos:MoveTo(ScrW()/4*3, 0, 1/4, 1/8*3, 0.3)

	self:MakePopup()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(50, 50, 55, 250)
	surface.DrawRect(0, 0, w, h)
end


return vgui.RegisterTable(PANEL, "EditablePanel")
