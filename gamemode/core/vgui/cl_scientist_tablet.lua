local tablet_texture = "project_avatar/hud/sc/tablet.png"
local tablet_wallpaper = "project_avatar/hud/sc/tablet_wp.png"

local Tablet = {}

--[[
local scaledw  = ScrW() * 400*2.5/1280
local scaledh  = ScrH() * 250*2.5/720

local scaledwp = ScrW() * 400*2.5/1280
local scaledhp = ScrH() * 250*2.5/720
]]

local tabletlib = include("cl_tablet_lib.lua")

local interface = {}

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