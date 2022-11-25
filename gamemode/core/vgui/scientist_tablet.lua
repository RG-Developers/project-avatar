local tablet_texture = "project_avatar/hud/sc/tablet.png"
local tablet_wallpaper = "project_avatar/hud/sc/tablet_wp.png"

local Tablet = {}
 -- RT STUFF REGION
local rt_mat = CreateMaterial("scientist_cam", "UnlitGeneric", {
    ["$basetexture"] = ""
})

local AVATAR = Material("project_avatar/hud/sc/avatar.png")
local TESTER = Material("project_avatar/hud/sc/tester.png")
local FIXER = Material("project_avatar/hud/sc/fixer.png")
local BUG = Material("project_avatar/hud/sc/bug.png")
local QTE = Material("project_avatar/hud/sc/qte.png")

local keysmats = {
    AVATAR,
    TESTER,
    FIXER
}
local keys = {
    KEY_A,
    KEY_B,
    KEY_U
}

local rt_pos = Vector(0, 0, 0)
local rt_ang = Vector(90, 0, 0)
local tbl = {}
local rendercam = true
local terminal = {}
local actions = {}
local next
local pressed = 0

function PlayerByName(name) for i, ply in pairs(player:GetAll()) do if ply:Name() == name then return ply end end return nil end 
classes = {"None", "Garry", "Circle", "Newguy", "Kratos"}
--[[
local scaledw  = ScrW() * 400*2.5/1280
local scaledh  = ScrH() * 250*2.5/720

local scaledwp = ScrW() * 400*2.5/1280
local scaledhp = ScrH() * 250*2.5/720
]]

local scaledw = ScrW()
local scaledh = ScrH()

local scaledwp = ScrW()*0.8
local scaledhp = ScrH()*0.8
local rt_offset = Vector(0,0,0)

local wx = (scaledw-scaledwp)/2
local wy = (scaledh-scaledhp)/2

local tabletlib = include("tablet_lib.lua")

local desktop, close, rtview

local interface = {}

local function contains (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function interface.Show()
    if IsValid(desktop) then return end
    desktop = tabletlib.createDesktop("project_avatar/hud/sc/tablet_wp.png", "project_avatar/hud/sc/tablet.png", ScrW(), ScrH())
    desktop:SetZPos(0)
    local _,_, dw, dh = desktop:GetWorkWH()
    rth = dh/2*1.25-20
    rtw = dw-20
    rtview = tabletlib.createDesktopPanel(desktop, rth, rtw, 0, 0)
    rtview:SetZPos(1)
    rt_offset = Vector(0,0,0)
    function rtview:Paint(w, h)
    --[[
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(rt_mat)
        surface.DrawTexturedRect(0, 0, w, h)
        ]]
        if rendercam then
            rt_pos = util.TraceLine( {
                start = Vector(0,0,0),
                endpos = Vector(0,0,10000) * 10000,
                filter = function( ent ) return true end
            } ).HitPos / 2
            local x, y = self:GetPos()
            render.RenderView( {
                origin = rt_pos + rt_offset,
                angles = rt_ang,
                x = x, y = y,
                w = w, h = h,
                aspect = w / h,
                fov = 90
            } )
            cam.Start3D()
                for _, ent in pairs(ents.GetAll()) do
                    --print(ent:GetClass())
                    render.SetColorMaterial()
                    local col
                    if ent:GetClass() == "pa_avatar" then render.SetMaterial( AVATAR )
                    elseif ent:GetClass() == "player" then 
                        if ent:Team() == TEAM_TEST_SUBJECTS then render.SetMaterial( TESTER ) else render.SetMaterial( FIXER ) end
                    elseif ent:GetClass() == "avatar_bug" then col = render.SetMaterial( BUG )
                    else continue end
                    render.DrawSprite( ent:GetPos()+Vector(0,0,100), 120*2, 120*2, Color(255,255,255) )
                    if ent:GetClass() == "avatar_bug" and not ent:GetNWBool("fixing")then
                        render.SetMaterial( QTE )
                        render.DrawSprite( ent:GetPos()+Vector(600,0,1000), 400*4, 120*4, Color(255,255,255) )
                        if ent:GetNWBool("hasQTE") then
                            local qte = {1,2,1,2,1,2}
                            for i, key in pairs(qte) do
                                if i > pressed then
                                    render.SetMaterial( keysmats[key] )
                                    render.DrawSprite( ent:GetPos()+Vector(700,-850 + 240*i,1000), 120*2, 120*2, Color(255,255,255) )
                                else
                                    render.SetMaterial( FIXER )
                                    render.DrawSprite( ent:GetPos()+Vector(700,-850 + 240*i,1000), 120*2, 120*2, Color(255,255,255) )
                                end
                            end
                            if input.IsKeyDown(keys[qte[next or 1]]) then
                                next = (next or 1) + 1
                                pressed = pressed + 1
                                if next >= 7 then
                                    next = nil
                                    pressed = 0
                                    net.Start("fixBug")
                                    net.WriteEntity(ent)
                                    net.SendToServer()
                                end
                            end
                        end
                    end
                end
            cam.End3D()
        end
    end

    terminalpanel = tabletlib.createDesktopPanel(desktop, dh-rth-30, dw/2-10, dw-(dw/2+10), dh-(dh-rth)+10)
    terminalpanel:MakePopup()
    terminalpanel:SetZPos(1)
    function terminalpanel:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(0,0,0,255))
    end
    terminalpanel.entry = vgui.Create( "DTextEntry", desktop )
    --terminalpanel.entry:Dock( BOTTOM )
    --terminalpanel.entry:DockMargin( 0, 5, 0, 0 )
    terminalpanel.entry:SetZPos(2)
    terminalpanel.entry:SetPos(dw-(dw/2+10), dh-(dh-rth)+10)
    terminalpanel.entry:SetSize(dw/2-10, 12)
    terminalpanel.entry:MakePopup()
    terminalpanel.entry:SetPlaceholderText( "Awaiting for input..." )
    terminalpanel.entry.OnEnter = function( self )
        executeCommand(self:GetValue())
    end
    terminalpanel.entry.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(55,55,55))
        draw.DrawText(self:GetValue() or self:GetPlaceholderText(), "Default")
    end

    close = tabletlib.createDesktopIcon(desktop, 64, 0, rth + 10)
    function close:DoClick()
        desktop:Close()
    end
    close:SetText("exit")

    lockdown = tabletlib.createDesktopIcon(desktop, 64, 74*2+110, rth + 10)
    function lockdown:DoClick()
        tabletlib.createLockdown(desktop)
    end
    lockdown:SetText("lockdown")

    togglecam = tabletlib.createDesktopIcon(desktop, 64, 74, rth + 10)
    function togglecam:DoClick()
        rendercam = not rendercam
    end
    togglecam:SetText("toggle rt")

    local sliderpanel = tabletlib.createDesktopPanel(desktop, 100, 100, 74*2, rth+10)
    sliderpanel:MakePopup()
    local Slider = vgui.Create( "DSlider", sliderpanel )
    Slider:SetPos( 0, 0 )
    Slider:SetSize( 100, 100 )
    function Slider:Paint()
        if not Slider:IsEditing() then 
            Slider:SetSlideX(0.5)
            Slider:SetSlideY(0.5)
        end
        rt_offset.x = rt_offset.x + (0.5-Slider:GetSlideY())*50
        rt_offset.y = rt_offset.y + (0.5-Slider:GetSlideX())*50
    end
    Slider:SetLockX(nil)
    Slider:SetLockY(nil)
end
function interface.Hide()
    if not IsValid(desktop) then return end
    desktop:Close()
end
function interface.IsShowed()
    return IsValid(desktop)
end
return interface