if CLIENT and false then
    ready = false
    hook.Add( "Think", "AbilThink", function()
        if LocalPlayer():Team() == 3 or 5 then
            subclass = GetSubClass(LocalPlayer())
            isdown = input.IsKeyDown( KEY_Q )
            if (isdown == true) and (ready == true) then
                net.Start("abilityUse")
                net.SendToServer()
                ready = false
            end
        end
    end)

    net.Receive("abilityReady", function()
        ready = true
    end)
end
if SERVER then

    util.AddNetworkString("fixBug")
    net.Receive("fixBug", function(_, ply)
        removeBug(net.ReadEntity())
    end)

    --[[
    hook.Add( "Think", "newguy_boost", function()
        for _,plyt in pairs(player:GetAll()) do
            if plyt:Team() == 3 or plyt:Team() == 5 then -- ну ок, ток почини потом
                plyt:SetTeam(TEAM_TESTSUBJECTS)
                subclass = GetSubClass(plyt)
                if subclass == 3 then
                    local plys = ents.FindInSphere(plyt:GetPos(),600)
                    for _,v in pairs(plys) do
                        if v:IsPlayer() then
                            v:SetTeam(5)
                        end
                    end
                end
            end
        end
    end)
    ]]--
    starttime = CurTime() + 1
    taskcreatetime = starttime + 1
    bugcount = 0

    tasks = {
    "simpletask", -- type 'complete' to complete task (>complete)                            +5
    "getinftask", -- get info about server and report it to fractal(>makereport >sendreport) +10
    "fixbugtask"  -- fix not visible bug(>autofix).                                          +10
    }

    function getBugs()
        return bugs 
    end

    function indexOf(array, value)
        for i, v in ipairs(array) do
            if v == value then
                return i
            end
        end
        return nil
    end

    function collectBug(entity)
        if bugs[entity] then
            SetGlobalInt("TestersScore", GetGlobalInt("TestersScore") + math.floor(bugs[entity]['score']))
            SetGlobalInt("ScientistsScore", GetGlobalInt("ScientistsScore") -  math.floor(bugs[entity]['score']))
            entity:Remove()
            if GetGlobalInt("TestersScore") > 999 then
                local bug = ents.Create("avatar_bug")
                bug:SetPos(Vector(0,0,0))
                bug:Spawn()
            end
            return true
        end
    end

    function showBugs()
        net.Start("updateBugs")
            net.WriteTable(getBugs())
        net.Broadcast()
        net.Start("showBugs")
        net.Broadcast()
    end

    function removeBug(bug)
        bug:Remove()
    end

    hook.Add("Think", "Scientist_Tasker", function() 
        if CurTime() > starttime then
            if CurTime() > taskcreatetime then 
                taskcreatetime = taskcreatetime + 1
                if math.random(0, 100) > 95 then
                    if GetGlobalInt("ScientistsCount") < 1 then return end
                    ply = player:GetAll()[math.random(1, player:GetCount())]
                    while ply:Team() ~= TEAM_SCIENTISTS do
                        ply = player:GetAll()[math.random(1, player:GetCount())]
                    end
                    if GetScientistTask(ply) == "none" then
                        SetScientistTask(ply, tasks[math.random(1, #tasks)])
                    end
                    if GetScientistTask(ply) == "" then
                        SetScientistTask(ply, tasks[math.random(1, #tasks)])
                    end
                end
            end
        end
    end)
    timer.Create("createbug",10,0,function()
        if CurTime() > starttime then
            if bugcount < GetGlobalInt("TestersCount") then
                if math.random(0, 100) > 0 then
                    isspec = math.random(0,5) > 4
                    local zpvalid, zmvalid, isinworld = false, false, false
                    while (zpvalid and zmvalid and isinworld) == false do
                        rx = math.random(minx, maxx)
                        ry = math.random(miny, maxy)
                        rz = math.random(minz, maxz)
                        pos = Vector(rx,ry,rz)
                        if isspec then
                            zpvalid = util.QuickTrace(pos, Vector(0,0,10000000)).HitWorld
                            zmvalid = util.QuickTrace(pos, Vector(0,0,-1000)).HitWorld
                        else
                            zpvalid = util.QuickTrace(pos, Vector(0,0,100000)).HitWorld
                            zmvalid = util.QuickTrace(pos, Vector(0,0,-100)).HitWorld
                        end
                        isinworld = util.IsInWorld(pos)
                        if (zpvalid and zmvalid and isinworld) then
                            bugcount = bugcount + 1
                        end
                    end
                end
            end
        else
            maxzt = util.QuickTrace(Vector(0,0,0), Vector(0,0,1000000)).HitPos[3]
            minzt = util.QuickTrace(Vector(0,0,0), Vector(0,0,-1000000)).HitPos[3]
            rayz = (maxzt-minzt) / 2
            maxz = util.QuickTrace(Vector(0,0,rayz), Vector(0,0,1000000)).HitPos[3]
            minz = util.QuickTrace(Vector(0,0,rayz), Vector(0,0,-1000000)).HitPos[3]
            rayz = (maxz-minz) / 2
            maxx = util.QuickTrace(Vector(0,0,rayz), Vector(1000000,0,0)).HitPos[1]
            minx = util.QuickTrace(Vector(0,0,rayz), Vector(-1000000,0,0)).HitPos[1]
            maxy = util.QuickTrace(Vector(0,0,rayz), Vector(0,1000000,0)).HitPos[2]
            miny = util.QuickTrace(Vector(0,0,rayz), Vector(0,-1000000,0)).HitPos[2]
        end
    end)
    --[[
    net.Receive("abilityUse", function(_,ply)
        plysubclass = GetSubClass(ply)
        plyclass = ply:Team()
        print("gotcha")
        if plyclass ~= 3 then
            ply:Kick("Invalid ability packet: abilityUse with team #" .. ply:Team())
            return
        end
        --{"None", "Garry", "Circle", "Newguy", "Kratos"}
        -- желательно всё это переписать в оружие по возможности
        if plysubclass == 1 then -- гарри
            rpl = ply
            players = player:GetAll()
            while rpl:Team() ~= 1 do
                rpl = players[math.random(1, #players+1)]
            end
            OnTaskRuined(rpl)
        elseif plysubclass == 2 then -- циркуль
            net.Start("updateBugs")
                net.WriteTable(bugs)
            net.Broadcast()
            net.Start("showBugs")
            net.Broadcast()
        elseif plysubclass == 3 then
            --код заменён оружием, более не нужен.
        elseif plysubclass == 4 then -- кратос, не трогать
            collectBug(ply:GetEyeTrace().Entity)
            ply:ViewPunch(Angle(1,1,1))
        end
    end)
]]-- гг, унесено в оружие

    net.Receive("TaskCompleted", function(_, ply)
        if GetScientistTask(ply) == "fixbugtask" then 
            removeBug(bugs[math.random(1, #bugs)])
        end
        SetGlobalInt("ScientistsScore", GetGlobalInt("ScientistsScore") + 10)
    end)
    timer.Create("AbilReady", 5, 0, function() 
        for _, ply in pairs(player:GetAll()) do
            if GetGlobalBool(ply:Name() .. "_abilReady") then continue end
            SetGlobalBool(ply:Name() .. "_abilReady", true)
            ply:PrintMessage(HUD_PRINTTALK, "Ability ready!")
        end
    end)
end
