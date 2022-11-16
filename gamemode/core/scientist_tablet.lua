local laststate, show = 0, false
local Tablet = include "vgui/scientist_tablet.lua"

hook.Add( "Think", "OnQ", function()
    if LocalPlayer():Team() == TEAM_SCIENTISTS then
        --show/hide stuff
        scientists_not_on_map = GetConVar("scientists_not_on_map"):GetBool()
        if scientists_not_on_map then 
            show = true 
            return 
        end
        if laststate == false and input.IsKeyDown( KEY_Q ) then
            show = not show
        end
        laststate = input.IsKeyDown( KEY_Q )
        if show == true then
            Tablet:Show()
        else
            Tablet:Hide()
        end
    else
        show = false
        Tablet:Hide()
    end
end)

net.Receive("openTablet", function()
    show = true
end)