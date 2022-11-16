local tablet_texture = "project_avatar/hud/sc/tablet.png"
local tablet_wallpaper = "project_avatar/hud/sc/tablet_wp.png"

local Tablet = {}
 -- RT STUFF REGION
local rt_scale = 2
local rt_tex = GetRenderTarget("scientist_cam", 256 * rt_scale, 256 * rt_scale)
local rt_mat = CreateMaterial("scientist_cam", "UnlitGeneric", {
    ["$basetexture"] = ""
})
local rt_pos = Vector(0, 0, 0)
local rt_ang = Vector(90, 0, 0)
local tbl = {
    origin = rt_pos, angles = rt_ang,
    w = 512 * rt_scale, h = 512 * rt_scale,
    x = 0, y = 0
}
function GM:InitPostEntity()
    rt_pos = util.QuickTrace(Vector(0,0,0), Vector(0,0,10000)).HitPos / 2
    tbl = {
        origin = rt_pos, angles = rt_ang,
        w = 512 * rt_scale, h = 512 * rt_scale,
        x = 0, y = 0
    }
end
hook.Add("RenderScene", "example", function(origin, angle, fov)
    render.SetRenderTarget(rt_tex)
        tbl = {
            origin = rt_pos, angles = rt_ang,
            w = 512, h = 512,
            x = 0, y = 0
        }
        render.RenderView(tbl)
    render.SetRenderTarget()
    rt_mat:SetTexture("$basetexture", rt_tex)
end)

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

local wx = (scaledw-scaledwp)/2
local wy = (scaledh-scaledhp)/2

local tabletlib = include("tablet_lib.lua")

local desktop, close, rtview

hook.Add("Think", "RTUpdate", function() 
end)

local interface = {}
function interface.Show()
    if IsValid(desktop) then return end
    desktop = tabletlib.createDesktop("project_avatar/hud/sc/tablet_wp.png", "project_avatar/hud/sc/tablet.png", ScrW(), ScrH())
    close = tabletlib.createDesktopIcon(desktop, 32, 0, 0)
    function close:DoClick()
        desktop:Close()
    end
    close:SetText("exit")
    local _,_, dw, dh = desktop:GetWorkWH()
    rtview = tabletlib.createDesktopPanel(desktop, dw/2-10, dh-20, 10, 10)
    function rtview:Paint(w, h) 
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(rt_mat)
        surface.DrawTexturedRect(0, 0, w, h)
    end
end
function interface.Hide()
    if not IsValid(desktop) then return end
    desktop:Close()
end
return interface