local show = false

local garry = Material("project_avatar/hud/ts/garry.png")
local kratos = Material("project_avatar/hud/ts/kratos.png")
local newguy = Material("project_avatar/hud/ts/newguy.png")
local circle = Material("project_avatar/hud/ts/circle.png")

local score_base = Material("project_avatar/hud/ts/score_base.png")
local score_bar = Material("project_avatar/hud/ts/score_bar.png")

local mats = {garry, circle, newguy, kratos}
local names = {"Garry", "Circle", "Newguy", "Kratos"}
local summaries = {"The Great Hacker", "Breaking Bad", "Just a new guy", "death and destruction"}
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

hook.Add( "HUDPaint", "OnTab", function()
    if LocalPlayer():Team() == TEAM_TESTSUBJECTS then
        show = input.IsKeyDown( KEY_TAB )
        if pcall(function() LocalPlayer() end) then
            playerclass = GetSubClass(LocalPlayer())
        else
            playerclass = 1
        end

        handlecoros()

        if mats[playerclass] == nil then return end
        
        score = GetGlobalInt("TestersScore") or 1

        surface.SetDrawColor(0, 0, 0, alpha)
        surface.DrawRect(0, 0, ScrW(), ScrH())

        surface.SetDrawColor(255,255,255,255)

        surface.SetMaterial(mats[playerclass])
        surface.DrawTexturedRect(plyx, (ScrH()-900)*0.5, 500, 900)

        surface.SetMaterial(score_bar)
        surface.DrawTexturedRectUV(scrx-400, (ScrH()-900)*0.5, 400/3, 2200/3 * (score / 1000), 0, 0, 1, 1 * (score / 1000))
        surface.SetMaterial(score_base)
        surface.DrawTexturedRect(scrx-400, (ScrH()-900)*0.5, 400/3, 2200/3)

        classname = names[playerclass]
        classsumm = summaries[playerclass]
        surface.SetFont("headfont")
        draw.DrawText(classname, "headfont", (ScrW()*0.5)-(select(1, surface.GetTextSize( classname )) / 2), ScrH()*0.4, Color( 255, 255, 255, alpha ) )
        surface.SetFont("smallheadfont")
        draw.DrawText(classsumm, "smallheadfont", (ScrW()*0.5)-(select(1, surface.GetTextSize( classsumm )) / 2), (ScrH()*0.4)+(select(2, surface.GetTextSize( classname )) * 2), Color( 255, 255, 255, alpha ) )

        if show == true then
            print("show")
            print(alpha)
            print(plyx)
        else
            --Hide()
        end
    end
end)

hook.Add( "ScoreboardHide", "Scoreboard_Close", function()
    coro = coroutine.create(function(stime, etime)
        while plyx < ScrW() do
            plyx = ScrW()-(500-(500*math.TimeFraction(stime, etime, CurTime())))
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
        while plyx > ScrW()-500 do
            plyx = ScrW()-(500*math.TimeFraction(stime, etime, CurTime()))
            scrx = 400*math.TimeFraction(stime, etime, CurTime())
            alpha = 200*math.TimeFraction(stime, etime, CurTime())
            coroutine.yield()
        end
    end)
    coroutine.resume(coro, CurTime(), CurTime()+0.5)
    coroutines[#coroutines+1] = coro
end )