--init
AddCSLuaFile("sh_shared.lua")
AddCSLuaFile("cl_init.lua")
--vgui
AddCSLuaFile("core/cl_tab.lua")
AddCSLuaFile("core/cl_hud.lua")
AddCSLuaFile("core/vgui/cl_tablet_lib.lua")
AddCSLuaFile("core/vgui/cl_team_select.lua")
AddCSLuaFile("core/vgui/cl_class_select.lua")
AddCSLuaFile("core/vgui/cl_scientist_tablet.lua")
AddCSLuaFile("core/cl_scientist_tablet.lua")
--shared files
AddCSLuaFile("core/sh_classprocessor.lua")
AddCSLuaFile("core/sh_team_select.lua")

include("sh_shared.lua")
coroutines = {}
debuggm = false
local matLight = Material( "sprites/light_ignorez" )

filter = RecipientFilter()
filter:AddAllPlayers()

function MakeLight( r, g, b, brght, size, parent )

		local lamp = ents.Create( "pa_light" )
		if ( not IsValid( lamp ) ) then return end

		lamp:SetColor( Color( r, g, b, 255 ) )
		lamp:SetBrightness( brght )
		lamp:SetLightSize( size )
		lamp:SetParent(parent)
		lamp:SetLightWorld(true)
		lamp:Spawn()

		lamp.lightr = r
		lamp.lightg = g
		lamp.lightb = b
		lamp.Brightness = brght
		lamp.Size = size
		lamp.on = true

		return lamp

	end

function GM:PlayerDeathSound( ply )
	return true
end

team_select_allowed = GetConVar("team_select_window"):GetBool()
if not team_select_allowed then 
	function GM:PlayerInitialSpawn(ply)
		if player:GetCount() % 2 == 0 then
			ply:SetTeam(TEAM_SCIENTISTS)
		else
			ply:SetTeam(TEAM_TESTSUBJECTS)
		end
		ply:KillSilent()
		ply:Spawn()
		if ply:Team() == TEAM_SCIENTISTS then 

		end
	end
end
function GM:PlayerSpawn(ply)
	ply:Freeze(false)
	if ply:Team() == TEAM_SCIENTISTS and GetConVar("scientists_not_on_map"):GetBool() then 
		ply:SetPos(Vector(0,0,90000))
		ply:Freeze(true)
		return
	end

	if debuggm then 
		ply:Give("weapon_pistol")
		ply:GiveAmmo(9999, "Pistol", true)
	end
	if ply:Team() == TEAM_SCIENTISTS then
		player_manager.SetPlayerClass(ply, "player_scientist")
		ply:AllowFlashlight(true)
	elseif ply:Team() == TEAM_TESTSUBJECTS then
		player_manager.SetPlayerClass(ply, "player_testsubject")
		ply:AllowFlashlight(true)
	elseif ply:Team() == TEAM_TESTSUBJECTS_BOOSTED then
		player_manager.SetPlayerClass(ply, "player_testsubject_boosted")
		ply:AllowFlashlight(true)
	elseif ply:Team() == TEAM_FIXERS then
		player_manager.SetPlayerClass(ply, "player_fixer")
		ply:AllowFlashlight(true)
	else
		player_manager.SetPlayerClass(ply, "player_default")
		ply:AllowFlashlight(false)
	end
	ply_model = ""
	ply:SetPlayerColor(Vector(255/255, 255/255, 255/255))
	ply:SetSkin(0)
	if ply:Team() == TEAM_SCIENTISTS then
		ply_model = "models/arachnit/wolfenstein2/nazis/nazi_scientist_player.mdl"
	elseif ply:Team() == TEAM_TESTSUBJECTS then
		if GetSubClass(ply) == 1 then
			ply_model = "models/player/skeleton.mdl"
			ply:Give("arccw_apex_wingman")
			ply:SetSkin(1)
		elseif GetSubClass(ply) == 2 then
			ply_model = "models/player/p2_chell.mdl"
			ply:Give("arccw_apex_melee_baton")
		elseif GetSubClass(ply) == 3 then
			ply_model = "models/player/kleiner.mdl"
			ply:Give("arccw_apex_melee_wrench")
		elseif GetSubClass(ply) == 4 then
			ply_model = "models/player/combine_soldier.mdl"
			ply:Give("arccw_apex_longbow")
			ply:SetSkin(1)
		else
			ply_model = "models/player/combine_super_soldier.mdl"
		end
	elseif ply:Team() == TEAM_TESTSUBJECTS_BOOSTED then
		ply_model = "models/player/p2_chell.mdl"
	elseif ply:Team() == TEAM_FIXERS then
		ply_model = "models/arachnit/wolfenstein2/nazis/fixer_custom_anim.mdl"
		ply:SetPlayerColor(Vector(255/255, 210/255, 21/255))
		ply:Give("weapon_smg1")
		ply:Give("weapon_ar2")
		ply:GiveAmmo(9999, "SMG1", true)
		ply:GiveAmmo(9999, "AR2", true)
	elseif ply:Team() == TEAM_AWAITING then
		ply_model = "models/player/combine_super_soldier.mdl"
	end
	if ply_model ~= "" then
		util.PrecacheModel(ply_model)
		ply:SetModel(ply_model)
		ply:SetupHands()
	end
end
--[[
function GM:PlayerDeath(ply, _, _)
	if ply:Team() == TEAM_FIXERS then
		ply:GetRagdollEntity():Remove()
	end
end
]]--

function GM:PlayerDeath(ply, _, _)
	if ply:Team() == TEAM_FIXERS then
		local plyang = ply:GetAngles()
		local plyvel = ply:GetVelocity()
		local plypos = ply:GetPos()
		local oldragdoll = ply:GetRagdollEntity()
		local brainmelt = ents.Create("prop_ragdoll")
		brainmelt:SetModel("models/hammerdude_ragdoll.mdl")
		brainmelt:SetPos(plypos)
		brainmelt:SetAngles(plyang)
		brainmelt:Spawn()

		for i=0, brainmelt:GetPhysicsObjectCount()-1,1 do
			local physbone = brainmelt:GetPhysicsObjectNum(i)
			if physbone == nil or not physbone:IsValid() then continue end
			physbone:SetVelocity(plyvel)
		end
		ply:GetRagdollEntity():Remove()
		MakeLight(0, 255, 0, 255, 500, brainmelt)
		--ply:SetObserverMode(OBS_MODE_IN_EYE)
		--ply:Spectate(OBS_MODE_IN_EYE)
		ply:SetTeam(TEAM_AWAITING)
		local coro = coroutine.create(function(model, freeze) 
			while CurTime() < freeze do coroutine.yield() end
			local mainbone = model:TranslateBoneToPhysBone( 10 )
			for i=0, model:GetBoneCount(),1 do
				constraint.Weld(model, model, mainbone, model:TranslateBoneToPhysBone( i ), 0, false, false)
			end
			coroutines[ply:EntIndex()+2000] = nil
			coroutines[ply:EntIndex()] = nil
		end)
		coroutine.resume(coro, brainmelt, CurTime() + 0.5)
		coroutines[ply:EntIndex()+1000] = coro
	elseif ply:Team() == TEAM_TESTSUBJECTS or ply:Team() == TEAM_TESTSUBJECTS_BOOSTED then
		ply:SetNWString("deathtimerid",tostring(math.random(100,999)))
    	ply:SetNWBool("respawn_allowed",false)
    	timer.Create("deathtimer_"..ply:GetNWString("deathtimerid",0),60,1,function() -- создаём таймер
    	    ply:SetNWBool("respawn_allowed",true) -- при окончании таймера разрешаем игроку возродиться
    	end)
    else
    	ply:SetNWBool("respawn_allowed",true)
	end
end

function GM:PlayerDeathThink(ply)
	if ply:Team() == TEAM_TESTSUBJECTS or ply:Team() == TEAM_TESTSUBJECTS_BOOSTED then
	    if timer.Exists("deathtimer_"..ply:GetNWString("deathtimerid",0)) then 
	        ply:SetNWInt("deathtimelost", 
	            timer.TimeLeft("deathtimer_"..ply:GetNWString("deathtimerid",0))
	        ) -- сетаем в NW время до возрождения
	    end
	    if ply:GetNWBool("respawn_allowed", false) then 
	        ply:Spawn()
	    end -- если нам можно возрождаться, возвращаем nil чтобы игрок мог возродиться(я хз почему так работает)
	    return false
	else
		ply:Spawn()
	end
end

hook.Add("PlayerShouldTakeDamage", "AntiTeamkill", function( ply, attacker )
	if attacker:IsPlayer() and ply:Team() == attacker:Team() then
		return false
	end
	return true
end)

hook.Add("SetupPlayerVisibility", "AddRTCamera", function(pPlayer, pViewEntity)
    AddOriginToPVS(pPlayer:GetPos())
    --AddOriginToPVS(pViewEntity:GetPos())
end)

hook.Add("Think", "CountTeams", function()
	local testsubj_count = 0
	local scien_count = 0
	for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_TESTSUBJECTS then
            testsubj_count = testsubj_count + 1
        end
        if v:Team() == TEAM_SCIENTISTS then
            scien_count = scien_count + 1
        end
    end
    SetGlobalInt("TestersCount", testsubj_count)
    SetGlobalInt("ScientistsCount", scien_count)
end)

function GM:SetGameRun(isrunning)
	SetGlobalBool("GameRunning", isrunning or false)
end
function SetClass(ply, class, subclass)
	ply:SetTeam(class or 1)
	SetGlobalInt(ply:Name() .. "_subclass", subclass or 0)
end

function SetScientistTask(ply, task)
	SetGlobalString(ply:Name() .. "_task", task)
	net.Start("NewTask") 
	net.Send(ply)
end
function OnTaskRuined(ply, _)
	SetScientistTask(ply, "none")
	net.Start("TaskRuined")
	net.Send(ply)
	SetScientistMistakes(ply, GetScientstMistakes(ply)+1)

end
function SetScientistDoctype(ply, lvl, let)
	SetGlobalInt(ply:Name() .. "_scindoclvl", lvl or 0)
	SetGlobalString(ply:Name() .. "_scindoclet", let or "s")
end
function SetScientistMistakes(ply, mist)
	SetGlobalInt(ply:Name() .. "_scinmst", mist or 0)
end
function SetAvatarState(state)
	SetGlobalBool("AvatarState", state or false)
end
util.AddNetworkString("Disconnect")
net.Receive("Disconnect", function(_, ply)
	ply:SetHealth(100)
	ply:TakeDamage(100)
end)

util.AddNetworkString("givePoints")
net.Receive("givePoints", function()
	if net.ReadInt(1) == 1 then
		SetGlobalInt("TestersScore", GetGlobalInt("TestersScore") + net.ReadInt(8))
	else
		SetGlobalInt("ScientistsScore", GetGlobalInt("ScientistsScore") + net.ReadInt(8))
	end
end)

util.AddNetworkString("TaskComplete")
net.Receive("TaskComplete", function()
	SetGlobalInt("ScientistsScore", GetGlobalInt("ScientistsScore") + 5)
end)


function PlayerByName(name) for i, ply in pairs(player:GetAll()) do if ply:Name() == name then return ply end end return nil end 

util.AddNetworkString("PreRound")
util.AddNetworkString("StartVote")
util.AddNetworkString("ExitPEENV")
util.AddNetworkString("openTablet")
util.AddNetworkString("BugAppeared")
util.AddNetworkString("abilityReady")
util.AddNetworkString("abilityUse")
util.AddNetworkString("TaskRuined")
util.AddNetworkString("showBugs")
util.AddNetworkString("updateBugs")
util.AddNetworkString("NewTask")
net.Receive("StartVote", function(_, ply)
	SetGlobalInt("StartVotes", GetGlobalInt("StartVotes") + 1)
	net.Start("StartVote")
		net.WriteInt(GetGlobalInt("StartVotes"), 8)
		net.WriteString(ply:Name())
		net.WriteInt(ply:UserID(), 16)
	net.Broadcast()
	if GetGlobalInt("StartVotes") == GetGlobalInt("ScientistsCount") then
		net.Start("ExitPEEnv")
		net.Broadcast()
	end
end)
util.AddNetworkString("SetClass")
net.Receive("SetClass", function(_, ply)
	local tester = net.ReadString()
	if not IsValid(tester) then return 0 end
	local class = net.ReadInt(3)
	tester = PlayerByName(tester)
	SetClass(tester, TEAM_TESTSUBJECTS, class)
	net.Start("SetClass")
		net.WriteInt(class, 3)
		net.WriteString(tester:Name())
	net.SendOmit(ply)
end)
util.AddNetworkString("SetTeam")
net.Receive("SetTeam", function(_, ply)
	local team = net.ReadInt(4)
	local retback = net.ReadBool()
	if retback then
		local coro = coroutine.create(function(ply, etime) 
			local oldteam = ply:Team()
			while CurTime() < etime do coroutine.yield() end
			ply:SetTeam(oldteam)
		end)
		coroutine.resume(coro, ply, CurTime() + 60*5)
		coroutines[ply:EntIndex()+2000] = coro
	end
	ply:KillSilent()
	SetClass(ply, team, 0)
	ply:Spawn()
end)
--[[
net.Receive("WepSelect", function(_, ply) 
	local m = net.ReadBool()
	local e = net.ReadEntity()
	local s = net.ReadString()
	net.Start("WepSelect")
		net.WriteBool(b)
		net.WriteEntity(e)
		net.WriteString(s)
	net.SendOmit(ply)
end)
]]
SetGlobalInt("servershut", -1)
util.AddNetworkString("RoundEnd")
hook.Add("Think", "ServerThink", function() 
	if (GetGlobalInt("TestersScore") > 999 or GetGlobalInt("ScientistsScore") > 999) and (GetGlobalInt("servershut") == -1) then
		SetGlobalInt("servershut", math.Round(CurTime() + 60*2 + 17))
		net.Start("RoundEnd")
		net.Broadcast()
		Entity(1):EmitSound("/project_avatar/music/server_closing.mp3", 75, 100, 0.5)
	end
	for k, coro in pairs(coroutines) do
		if coro == nil then continue end
		coroutine.resume(coro)
		if coroutine.status(coro) == "dead" then coroutines[k] = nil end
	end
	if not (GetGlobalInt("servershut") == -1 or GetGlobalInt("servershut") == -2) and (GetGlobalInt("servershut") - CurTime() < 1) then
		SetGlobalInt("servershut", -2)
		for _, ply in pairs(player:GetAll()) do
			ply:SetTeam(TEAM_AWAITING)
			ply:Freeze(true)
			ply:PrintMessage(HUD_PRINTTALK, "Server was shut down.")
			if GetGlobalInt("TestersScore") > 999 then
				ply:PrintMessage(HUD_PRINTTALK, "Testers won")
			else
				ply:PrintMessage(HUD_PRINTTALK, "Scientists won")
			end
		end
	end
	if not (GetGlobalInt("servershut") == -1 or GetGlobalInt("servershut") == -2) and (GetGlobalInt("servershut") - CurTime() < 12) then 
		Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut5sec.wav")
	end
	if not (GetGlobalInt("servershut") == -1 or GetGlobalInt("servershut") == -2) and (GetGlobalInt("servershut") - CurTime() > 60*2 + 16 ) then
		if not coroutines[0] == nil then return end
		local coro = coroutine.create(function()

			if GetGlobalInt("TestersScore") > 999 then
				local stime = CurTime()
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut1-testers.wav")
				while (CurTime() - stime) < 14 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut2-testers.wav")
				while (CurTime() - stime) < 14+9 do coroutine.yield() end
			else
				local stime = CurTime()
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut1-scientists.wav")
				while (CurTime() - stime) < 11 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut2-scientists.wav")
				while (CurTime() - stime) < 11+8 do coroutine.yield() end
			end

			while (GetGlobalInt("servershut") - CurTime() > (60*2 + 16) - 52 + 10) do coroutine.yield() end
			Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut5min.wav")
			while true do coroutine.yield() end
		end)
		coroutine.resume(coro)
		coroutines[0] = coro
	end
end)

hook.Add("EntityTakeDamage", "FixerSuitNotLocked", function(ply, dmg) 
	if ply:IsPlayer() and ply:Team() == TEAM_FIXERS and dmg:IsBulletDamage() and not (dmg:GetDamageType() == DMG_GENERIC) and math.random(0,100) > 75 then --FULL WORK
	--if ply:IsPlayer() and ply:Team() == TEAM_FIXERS then         --ONLY FOR TESTS COMMENT IN RELEASE
		if coroutines[ply:EntIndex()] then return end
		if IsValid(coroutines[ply:EntIndex()]) then return end
		if coroutines[ply:EntIndex()] ~= nil then return end
		local coro = coroutine.create(function(ply, deathtime)
			stime = CurTime()
			shealth = ply:Health()
			local meltsound = CreateSound(ply, "/project_avatar/damage/fixer_death-" .. math.random(1,3) .. ".wav")
			meltsound:SetSoundLevel(0)
			meltsound:Play()
			while ply:Health() > 0 do
				ply:SetHealth(100 - (100 - shealth) - (math.TimeFraction(stime, deathtime, CurTime()) * shealth))
				coroutine.yield()
			end
			ply:Kill()
			--print(CurTime() - stime)
		end)
		coroutine.resume(coro, ply, CurTime() + 3)
		coroutines[ply:EntIndex()] = coro
	end
end)

hook.Add( "PlayerNoClip", "noclip", function( ply )
    if ply:Team() == TEAM_AWAITING then
        return true
    end
end)

concommand.Add("setteam", function(_, _, args) 
	player:GetAll()[tonumber(args[1])]:SetTeam(tonumber(args[2]) or 0)
end)

print("Serverside running!")