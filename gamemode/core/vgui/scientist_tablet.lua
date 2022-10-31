local scn_tbl = Material("project_avatar/hud/sc/tablet.png")

local Tablet = {}

local waitcoro
local reportready = false

local log = {"FRACTALOS v1.0", 
            "TYPE 'HELP' FOR LIST OF COMMANDS",
            "",
            "",
            "SERVER IS READY TO START. TYPE 'START' TO VOTE FOR START",
            "",
            "Restricted Server Project v1. Connected to 'fractalcorp.gov' with ssh2"}
local terminal_runningapp = "nil"

local rt_scale = 2
local rt_tex = GetRenderTarget("scientist_cam", 256 * rt_scale, 256 * rt_scale)
local rt_mat = CreateMaterial("scientist_cam", "UnlitGeneric", {
    ["$basetexture"] = ""
})

local rt_pos = Vector(0, 0, 0)
local rt_ang = Vector(90, 0, 0) -- угол рт камеры
local tbl = {
    origin = rt_pos, angles = rt_ang,
    w = 512 * rt_scale, h = 512 * rt_scale,
    x = 0, y = 0
} -- кэшированная таблица для уменьшение потребления ресурсов
function GM:InitPostEntity()
    rt_pos = util.QuickTrace(Vector(0,0,0), Vector(0,0,10000)).HitPos / 2 -- позиция рт камеры
    tbl = {
        origin = rt_pos, angles = rt_ang,
        w = 512 * rt_scale, h = 512 * rt_scale,
        x = 0, y = 0
    }
end

function PlayerByName(name) for i, ply in pairs(player:GetAll()) do if ply:Name() == name then return ply end end return nil end 
classes = {"None", "Garry", "Circle", "Newguy", "Kratos"}
local function coutprint(text)
    table.insert(log, text)
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
peenv = true

function Tablet:Init()
    self:SetSize( ScrW(), ScrH() )
    self:Center()

    self.Main = vgui.Create( "DFrame" , self)
    self.Main:SetPos( 0, 0 )
    self.Main:SetSize( ScrW(), ScrH() )
    self.Main:SetTitle( "" )
    self.Main:ShowCloseButton(false)
    self.Main:SetDraggable( false ) 
    self.Main:MakePopup()
    self:ShowCloseButton(false)
    self:SetDraggable( false ) 
    self.Main.Paint = function()
        surface.SetDrawColor(255, 255, 255, 255)
        surface.SetMaterial(scn_tbl)
        surface.DrawTexturedRect(10, 10, ScrW() - 20, ScrH() - 20)
        surface.SetDrawColor(0, 0, 0, 255)
        surface.DrawRect(80, 80, ScrW()-160, ScrH()-160)
        for lineNum = 1,  math.Clamp(#log, 0, 50) do
            draw.DrawText(log[#log-lineNum+1], "Default", 80, ScrH()-80-(12*lineNum), Color( 240, 240, 240, math.random(230,255)))
        end
        if waitcoro then
            if coroutine.status(waitcoro) ~= "dead" then
                coroutine.resume(waitcoro)
            end
        end
    end

    self.RTScreen = vgui.Create("EditablePanel", self) -- рт экран
    self.RTScreen:SetSize(256, 256)
    self.RTScreen:Center()
    self.RTScreen.Paint = function()
        if terminal_runningapp=="rtcam" then
            surface.SetDrawColor(255, 255, 255)
            surface.SetMaterial(rt_mat)
            surface.DrawTexturedRect(0, 0, 256, 256)
        end
    end

    self.Entry = vgui.Create( "DTextEntry", self ) 
    self.Entry:SetPos( 80, ScrH()-80 )
    self.Entry:SetSize( ScrW()-160, 80 )
    self.Entry:SetText( "" )
    self.Entry:SetDrawBorder(true)
    self.Entry:RequestFocus() 
    self.Entry:SetHistoryEnabled(true)
    self.Entry.OnLoseFocus = function(PanelVar)
        self.Entry:RequestFocus() 
    end
    self.Entry.OnChange = function()
        --surface.PlaySound("bin/char" .. math.random(1,5) .. ".wav")
    end
    self.Entry.Paint = function()
        draw.DrawText( LocalPlayer():Name() .. "@fractal ~:" .. self.Entry:GetValue(), "Default", 0, 0, Color( 240, 240, 240, math.random(230,255)))
    end 
    self.Entry.OnEnter = function()
        task = GetScientistTask(LocalPlayer())
        --surface.PlaySound("bin/enter" .. math.random(1,3) .. ".wav")
        entry = string.Explode(" ", self.Entry:GetValue())
        local command = string.upper(entry[1])
        local args = {entry[2] or "", entry[3] or "", entry[4] or ""}
        coutprint(">" .. entry[1] .. " " .. args[1] .. " " .. args[2] .. " " .. args[3] )
        if command == "HELP" then
            coutprint("FRACTALOS HELP")
            coutprint("ECHO [TEXT] - DISPLAY TYPED TEXT")
            coutprint("PING - PING ALL PLAYERS ON SERVER AND GET INFORMATION ABOUT THEM")
            coutprint("CLS - CLEAR OUTPUT")
            coutprint("HELP - THIS TEXT")
            coutprint("ASFIXER - CONNECT TO SERVER AS FIXER")
            if peenv then
                coutprint("SCL [NAME] [CLASSID] - SET TESTER CLASS.")
                coutprint("START - VOTE FOR SERVER START")
            end
            if task and task ~= "none" then
                coutprint("TASK - SHOW INFO ABOUT CURRENT TASK")
                if task == "simpletask" then 
                    coutprint("COMPLETE - COMPLETE SIMPLE TASK")
                end
                if task == "getinftask" then 
                    coutprint("MAKEREPORT - MAKE REPORT ABOUT SERVER READY TO SEND TO FRACTAL SERVERS")
                    coutprint("SENDREPORT - SEND REPORT TO FRACTAL SERVERS")
                end
                if task == "fixbug" then 
                    coutprint("AUTOFIX - RUN AUTOMATIC BUG FIXER")
                end
            end
        elseif command == "ECHO" then
            coutprint(table.concat(entry," "))
        elseif command == "PING" then
            local testsubj_count = 0
            for k, v in pairs(player.GetAll()) do
                if v:Team() == TEAM_TESTSUBJECTS then
                    coutprint(v:Name() .. ":")
                    coutprint("  " .. "HP: " .. v:Health() .. "/" .. v:GetMaxHealth())
                    coutprint("  " .. "PING: " .. v:Ping())
                    testsubj_count = testsubj_count + 1
                end
            end
            coutprint("TOTAL PLAYERS ON SERVER: " .. testsubj_count)
        elseif command == "CLS" then
            log = {}
        elseif command == "CAM" then
            if terminal_runningapp == "rtcam" then
                terminal_runningapp = "nil"
                return
            end
            terminal_runningapp = "rtcam"
        elseif command == "ASFIXER" then
            if peend then return end
            if asfixer == false then
                coutprint("Are you really sure that you want to connect to server as fixer? Type this command again if you sure. Time on server limit: 5 minutes")
                asfixer = true
            else
                net.Start("SetTeam")
                    net.WriteInt(6, 4)
                    net.WriteBool(true)
                net.SendToServer()
                asfixer = false
            end
        elseif command == "TASK" then
            coutprint(task)
        elseif task == "simpletask" then
            if command == "COMPLETE" then
                coutprint("Simple task completed")
                net.Start("TaskComplete")
                net.SendToServer()
                task = ""
            end
        elseif task == "bugfixtask" then
            if command == "AUTOFIX" then
                coutprint("Autofix fixed ScriptedEntity error. Task completed")
                net.Start("TaskComplete")
                net.SendToServer()
                task = ""
            end
        elseif task == "getinftask" then
            if command == "MAKEREPORT" then
                coutprint("Report ready to send")
                reportready = true
            end
            if command == "SENDREPORT" then
                coutprint("Report sent. Task completed")
                net.Start("TaskComplete")
                net.SendToServer()
                task = ""
                reportready = false
            end
        elseif peenv then
            if command == "SCL" then
                local tester = PlayerByName(args[1])
                if not IsValid(tester) then coutprint("Invalid player") return end
                if not tester:Team() ~= TEAM_TESTSUBJECTS then coutprint("Invalid player") return end
                net.Start("SetClass")
                    net.WriteInt(args[2], 3)
                    net.WriteString(tester:Name())
                net.SendToServer()
                coutprint("Set class of player "..args[1].." to "..classes[args[2]+1])
            elseif command == "START" then
                net.Start("StartVote")
                net.SendToServer()
                coutprint("Voted for server start")
            end
        else
            coutprint("File or command '" .. command .. "' is not found.")
        end
        self.Entry:SetText( "" )
    end
    self:MakePopup()
end
function Tablet:Paint( w, h )

    surface.SetDrawColor(255, 255, 255)
    surface.SetMaterial(rt_mat)
    surface.DrawTexturedRect(ScrW(), ScrH(), ScrW()-160, ScrH()-160)
end

net.Receive("StartVote", function()
    local votes = net.ReadInt(8)
    local voted = net.ReadString()
    local id = net.ReadInt(16)
    coutprint("Scientist #"..id.."("..voted..") voted for server start.")
end)
net.Receive("NewTask", function()
    print(LocalPlayer())
    task = GetScientistTask(LocalPlayer())
    local servers = {"fractal.gov", "restricted.server:22", "fractalhub.gov"}
    coutprint("New task received from " .. servers[math.random(1, #servers)] .. ". Task name: " .. task)
end)
net.Receive("SetClass", function()
    local plclass = net.ReadInt(3)
    local ply = net.ReadString()
    coutprint("Set class of player "..ply.." to "..classes[args[2]+1])
end)
net.Receive("ExitPEEnv", function()
    coutprint("Server is now loading...")
    peenv = false
    waitcoro = coroutine.create(function() 
        coroutine.wait(3)
        coutprint("Loading resources...")
        coroutine.wait(2)
        coutprint("Running server...")
        coroutine.wait(5)
        coutprint("Connecting players:")
        coroutine.wait(1)
        coutprint("  Analysing DNA")
        coroutine.wait(0.1)
        coutprint("  Giving S.K.I.N.")
        coroutine.wait(0.2)
        coutprint("Starting lua...")
        coroutine.wait(1)
        coutprint("ConsecToPlayer v3 adapter running")
        coroutine.wait(0.05)
        coutprint("Lua started.")
        coroutine.wait(1)
        coutprint("Ready to play!")
        coroutine.wait(1)
        coutprint("Server online")
        --14.35 сек на запуск сервера
    end)
end)




return vgui.RegisterTable( Tablet, "DFrame" )