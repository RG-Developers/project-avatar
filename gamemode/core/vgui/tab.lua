local Tab = {}

local garry = Material("project_avatar/hud/ts/garry.png")
local kratos = Material("project_avatar/hud/ts/kratos.png")
local newguy = Material("project_avatar/hud/ts/newguy.png")
local circle = Material("project_avatar/hud/ts/circle.png")

local ply = LocalPlayer()
local mats = {garry, circle, newguy, cratos}
local playerclass = 0
function Tab:Init()
    self:SetSize( ScrW(), ScrH() )
    self:Center()

    playerclass = GetSubClass(ply)
    drawmat = mats[playerclass]


    self.Main = vgui.Create("DPanel" , self)
    self.Main:SetPos( 0, 0 )
    self.Main:SetSize( ScrW(), ScrH() )
    self.Main:MakePopup()
    self:SetAlpha(0)
    local alpha = 255 / 3

    self.Main.Paint = function()
        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())
    end

    self.player = vgui.Create("DPanel", self)
    self.player:SetPos(ScrW(), (ScrH()-900)/2)
    self.player:SetSize(500, 900)
    self.player.Paint = function(s, w, h)
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(drawmat)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    self.player:MakePopup()

    self.player:MoveTo(ScrW()-500, (ScrH()-900)/2, 1, 0.3)
    self.Main:AlphaTo(255/3, 0.5, 0)

    self:MakePopup()
end
function Tab:Paint( w, h )
end

function Tab:Hide()
    self.player:MoveTo(ScrW(), (ScrH()-900)/2, 1, 0.3)
    self:AlphaTo(0, 0.5, 0)
end

function Tab:Show()
    self.player:MoveTo(ScrW()-500, (ScrH()-900)/2, 1, 0.3)
    self:AlphaTo(255/3, 0.5, 0)
end

return vgui.RegisterTable( Tab, "DPanel" )