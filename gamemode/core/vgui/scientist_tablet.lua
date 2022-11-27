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
net.Receive("RoundEnd", function(_, ply)
    
end)

function interface.Show()
    if tabletlib.shown() then return end
    tabletlib.show()
end
function interface.Hide()
    if not tabletlib.shown() then return end
    tabletlib.hide()
end
function interface.IsShowed()
    return tabletlib.shown()
end
return interface