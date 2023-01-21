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

tabletlib.registercmd("ping", {"*"}, function()
    local classes = {"<INTERNAL>", "Garry", "Circle", "Newguy", "Kratos"}
    for k, v in pairs(player.GetAll()) do
        classname = classes[GetSubClass(v)]
        if v:Team() == TEAM_TESTSUBJECTS then
            tprint(v:Name() .. classname .. ":")
            tprint("  " .. "Ping: " .. 105-v:Health() .. "ns")
        end
        if v:Team() == TEAM_TESTSUBJECTS_BOOSTED then
            tprint(v:Name() .. classname .. "[NEWGUY BOOST]:")
            tprint("  " .. "Ping: " .. 105-v:Health() .. "ns")
        end
        if v:Team() == TEAM_FIXERS then
            tprint(v:Name() .. " <INTERNAL> [FIXER]:")
            tprint("  " .. "Ping: " .. 105-v:Health() .. "ns")
        end
    end
end, "Ping all players on server")

tabletlib.registercmd("camtp", {"x", "y", "z"}, function(xyz)
    PrintTable(xyz)
    local x, y, z = tonumber(xyz[1]), tonumber(xyz[2]), tonumber(xyz[3])
    rt_offset = Vector(x, y, z)
end, "Teleport RTCAM_0 to position")

tabletlib.registercmd("echo", {"..."}, function(text)
    tprint(text)
end, "Echo inputed text back")

tabletlib.registercmd("clear", {"*"}, function()
    toverride({})
end, "Clear screen")

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