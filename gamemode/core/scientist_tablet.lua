local laststate, show = 0, false
local TabletW
local RegTablet = include "vgui/scientist_tablet.lua"

hook.Add( "Think", "OnQ", function()
    if LocalPlayer():Team() == TEAM_SCIENTISTS then
        --show/hide stuff
        scientists_not_on_map = GetConVar("scientists_not_on_map"):GetBool()
        if laststate == false and input.IsKeyDown( KEY_Q ) then
            show = not show
        end
        laststate = input.IsKeyDown( KEY_Q )
        if show == true then
            if IsValid(TabletW) then return end
            TabletW = vgui.CreateFromTable( RegTablet )
        else
            if not IsValid(TabletW) then return end
            TabletW:Remove()
            TabletW = nil
        end
    end
end)

net.Receive("openTablet", function()
    show = true
end)