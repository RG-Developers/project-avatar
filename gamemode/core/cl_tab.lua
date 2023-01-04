local show = false

local garry = Material("project_avatar/hud/ts/illustrations/garry.png")
local kratos = Material("project_avatar/hud/ts/illustrations/kratos.png")
local newguy = Material("project_avatar/hud/ts/illustrations/newguy.png")
local circle = Material("project_avatar/hud/ts/illustrations/circle.png")

local score_base_ts = Material("project_avatar/hud/ts/tab/score_base.png")
local score_bar_ts = Material("project_avatar/hud/ts/tab/score_bar.png")
local score_base_sc = Material("project_avatar/hud/sc/tab/score_base.png")
local score_bar_sc = Material("project_avatar/hud/sc/tab/score_bar.png")

local mats = {garry, circle, newguy, kratos}
local names = {"Garry", "Circle", "Newguy", "Kratos"}
local summaries = {"The Great Hacker", "The PosterMaker", "Just a new guy", "death and destruction"}
local playerclass = 0

surface.CreateFont( "headfont", {
        font = "Bebas Neue Cyrillic",
        extended = false,
        size = 100,
        weight = 500})

surface.CreateFont( "smallheadfont", {
        font = "Bebas Neue Cyrillic",
        extended = false,
        size = 50,
        weight = 500})

surface.CreateFont( "descfont", {
        font = "Bebas Neue Cyrillic",
        extended = false,
        size = 25,
        weight = 500})

local plyx = ScrW()
local alpha = 0
local scrx = 0

local coroutines = {}
local score = 0

local function handlecoros()
    local i = 1
    while i <= #coroutines do
        _, fade = coroutine.resume(coroutines[i])
        if coroutine.status(coroutines[i]) == "dead" then
            table.remove(coroutines, i)
        else
            i = i + 1
        end
    end
end

local scale = (ScrH() / ScrW())

hook.Add( "HUDPaint", "OnTab", function()
    if LocalPlayer():Team() == TEAM_TESTSUBJECTS or LocalPlayer():Team() == TEAM_TESTSUBJECTS_BOOSTED then
        show = input.IsKeyDown( KEY_TAB )
        if pcall(function() LocalPlayer() end) then
            playerclass = GetSubClass(LocalPlayer())
        else
            playerclass = 0
        end

        handlecoros()

        if mats[playerclass] == nil then return end
        
        score = GetGlobalInt("TestersScore") or 1

        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())

        surface.SetDrawColor(255,255,255,255)

        surface.SetMaterial(mats[playerclass])
        surface.DrawTexturedRect(plyx, (ScrH()-900*scale)*0.5, 500*scale, 900*scale)

        surface.SetMaterial(score_bar_ts)
        surface.DrawTexturedRectUV(scrx-400, (ScrH()-1100*scale)*0.5, 200*scale, 1100*scale * (score / 1000), 0, 0, 1, 1 * (score / 1000))
        surface.SetMaterial(score_base_ts)
        surface.DrawTexturedRect(scrx-400, (ScrH()-1100*scale)*0.5, 200*scale, 1100*scale)

        classname = names[playerclass]
        classsumm = summaries[playerclass]
        surface.SetFont("headfont")
        draw.DrawText(classname, "headfont", (ScrW()*0.5)-(select(1, surface.GetTextSize( classname )) / 2), ScrH()*0.4, Color( 255, 255, 255, alpha ) )
        surface.SetFont("smallheadfont")
        draw.DrawText(classsumm, "smallheadfont", (ScrW()*0.5)-(select(1, surface.GetTextSize( classsumm )) / 2), (ScrH()*0.4)+(select(2, surface.GetTextSize( classname )) * 2), Color( 255, 255, 255, alpha ) )
    end

    if LocalPlayer():Team() == TEAM_SCIENTISTS then

        handlecoros()
        
        score = GetGlobalInt("ScientistsScore") or 1
        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())

        surface.SetDrawColor(255,255,255,255)

        surface.SetMaterial(score_bar_sc)
        surface.DrawTexturedRectUV(scrx-400, (ScrH()-1100*scale)*0.5, 200*scale, 1100*scale * (score / 1000), 0, 0, 1, 1 * (score / 1000))
        surface.SetMaterial(score_base_sc)
        surface.DrawTexturedRect(scrx-400, (ScrH()-1100*scale)*0.5, 200*scale, 1100*scale)

        classname = "Scientists"
        classsumm = "With you a new hope"
        surface.SetFont("headfont")
        draw.DrawText(classname, "headfont", (ScrW()*0.5)-(select(1, surface.GetTextSize( classname )) / 2), ScrH()*0.4, Color( 255, 255, 255, alpha ) )
        surface.SetFont("smallheadfont")
        draw.DrawText(classsumm, "smallheadfont", (ScrW()*0.5)-(select(1, surface.GetTextSize( classsumm )) / 2), (ScrH()*0.4)+(select(2, surface.GetTextSize( classname )) * 2), Color( 255, 255, 255, alpha ) )
    end
end)

hook.Add( "ScoreboardHide", "Scoreboard_Close", function()
    coro = coroutine.create(function(stime, etime)
        while plyx < ScrW() do
            plyx = ScrW()-(500*scale-((500*scale)*math.TimeFraction(stime, etime, CurTime())))
            scrx = 400-(400*math.TimeFraction(stime, etime, CurTime()))
            alpha = 200-(200*math.TimeFraction(stime, etime, CurTime()))
            coroutine.yield()
        end
    end)
    coroutine.resume(coro, CurTime(), CurTime()+0.5)
    coroutines[#coroutines+1] = coro
end )

hook.Add( "ScoreboardShow", "Scoreboard_Open", function()
    coro = coroutine.create(function(stime, etime)
        while plyx > ScrW()-500*scale do
            plyx = ScrW()-((500*scale)*math.TimeFraction(stime, etime, CurTime()))
            scrx = 400*math.TimeFraction(stime, etime, CurTime())
            alpha = 200*math.TimeFraction(stime, etime, CurTime())
            coroutine.yield()
        end
    end)
    coroutine.resume(coro, CurTime(), CurTime()+0.5)
    coroutines[#coroutines+1] = coro
end )