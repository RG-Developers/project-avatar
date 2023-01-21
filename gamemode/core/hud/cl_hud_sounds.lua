hud_sounds = {}

hud_sounds.crsound = nil
hud_sounds.falsound = nil
hud_sounds.filter = {
    channel = CHAN_STATIC
}

-- Check if sound creation is successful
local success, err = pcall(function()
    hud_sounds.crsound = CreateSound(LocalPlayer(), "/project_avatar/damage/statuscritical.wav", hud_sounds.filter)
    hud_sounds.falsound = CreateSound(LocalPlayer(), "/project_avatar/music/fixers_onserver.mp3", hud_sounds.filter)
end)

-- If failed to create sound, try again on InitPostEntity
if not success then
    hook.Add("InitPostEntity", "postinit", function()
        hud_sounds.crsound = CreateSound(LocalPlayer(), "/project_avatar/damage/statuscritical.wav", hud_sounds.filter)
        hud_sounds.falsound = CreateSound(LocalPlayer(), "/project_avatar/music/fixers_onserver.mp3", hud_sounds.filter)
    end)
end

return hud_sounds