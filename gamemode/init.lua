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
include("sv_init_functions.lua")
include('sv_init_hooks.lua')
include("sv_init_net.lua")
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

function GM:SetGameRun(isrunning)
	SetGlobalBool("GameRunning", isrunning or false)
end

SetGlobalInt("servershut", -1)
hook.Add("Think", "ServerThink", function() 
	if (GetGlobalInt("TestersScore") > 999 or GetGlobalInt("ScientistsScore") > 999) and (GetGlobalInt("servershut") == -1) then
		SetGlobalInt("servershut", math.Round(RealTime() + 60*2 + 17))
		net.Start("RoundEnd")
		net.Broadcast()
		Entity(1):EmitSound("/project_avatar/music/server_closing.mp3", 75, 100, 0.5)
	end
	for k, coro in pairs(coroutines) do
		if coro == nil then continue end
		coroutine.resume(coro)
		if coroutine.status(coro) == "dead" then coroutines[k] = nil end
	end
	if not (GetGlobalInt("servershut") == -1 or GetGlobalInt("servershut") == -2) and (GetGlobalInt("servershut") - RealTime() < 1) then
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
	if not (GetGlobalInt("servershut") == -1 or GetGlobalInt("servershut") == -2) and (GetGlobalInt("servershut") - RealTime() > 60*2 + 16 ) then
		if not coroutines[0] == nil then return end
		local coro = coroutine.create(function()
			local stime = RealTime()
			if GetGlobalInt("TestersScore") > 999 then
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut_t_1.wav")
				print(1)
				while (RealTime() - stime) < 9+5 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/failed.wav")
				print(2)
				while (RealTime() - stime) < 9+5+1 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut_t_2.wav")
				print(3)
				while (RealTime() - stime) < 9+5+1+5 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/failed.wav")
				print(4)
			else
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut_s_1.wav")
				while (RealTime() - stime) < 9+5 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/failed.wav")
				while (RealTime() - stime) < 9+5+1 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut_s_2.wav")
				while (RealTime() - stime) < 9+5+1+5 do coroutine.yield() end
				Entity(1):EmitSound("project_avatar/avatar_voicelines/failed.wav")
			end
			while (RealTime() - stime) < 52-6 do 
				print(RealTime() - stime) 
				coroutine.yield() 
			end
			Entity(1):EmitSound("project_avatar/avatar_voicelines/servershut_b_3.wav")
			print(5)
			while true do coroutine.yield() end
		end)
		coroutine.resume(coro)
		coroutines[0] = coro
	end
end)

concommand.Add("setteam", function(_, _, args) 
	local pos = player:GetAll()[tonumber(args[1])]:GetPos()
	local ang = player:GetAll()[tonumber(args[1])]:GetAngles()
	player:GetAll()[tonumber(args[1])]:SetTeam(tonumber(args[2]) or 0)
	player:GetAll()[tonumber(args[1])]:Spawn()
	player:GetAll()[tonumber(args[1])]:SetPos(pos)
	player:GetAll()[tonumber(args[1])]:SetAngles(ang)
end)

concommand.Add("spawnfixer", function(_, _, args) 
	local pos = player:GetAll()[tonumber(args[1])]:GetEyeTrace().HitPos
	local fixer = ents.Create("npc_combine_s")
	fixer:SetModel("models/arachnit/wolfenstein2/nazis/nazi_elite_atom_soldier_combine.mdl")
	function fixer:GetPlayerColor()
		return Vector(255/255, 210/255, 21/255)
	end
	fixer:SetColor(Color(255, 210, 21))
	fixer:Give("weapon_ar2")
	fixer:SetPos(pos)
	fixer:Spawn()
end)


------------------------------------
------------TASKS-PART--------------
------------------------------------

local tasks = {
	{
		["name"] = "Fix bug",
		["type"] = "bug",
		["iscoop"] = false
	},
	{
		["name"] = "Fix bug",
		["type"] = "bug",
		["iscoop"] = false
	},
	{
		["name"] = "Fix bug",
		["type"] = "bug",
		["iscoop"] = false
	},
	{
		["name"] = "Fix bug",
		["type"] = "bug",
		["iscoop"] = false
	},
	{
		["name"] = "Fix bug",
		["type"] = "bug",
		["iscoop"] = false
	},
	{
		["name"] = "Fix bug",
		["type"] = "bug",
		["iscoop"] = false
	}
}

local task = {
	["name"] = "", -- Update, fix, scan,   shutd, etc
	["type"] = "", -- avatar, bug, tester, alert, etc
	["iscoop"] = false -- is coop?
}

util.AddNetworkString("pa.tasksget")

timer.Create("tasker", 15, 0, function() 
	if GetGlobalInt("ScientistsCount") < 1 then return end
	local ply = player:GetAll()[math.random(1, player:GetCount())]
	local tries = 0
	while (ply:Team() ~= TEAM_SCIENTISTS or 
		GetScientistTask(ply) ~= "none" or GetScientistTask(ply) ~= "") and
		tries < 10 do
		ply = table.Random(player.GetAll())
		tries = tries + 1
	end
	if tries > 9 then return end
	if GetScientistTask(ply) == "none" then
		SetScientistTask(ply, table.Random(tasks))
	end
	if GetScientistTask(ply) == "" then
		SetScientistTask(ply, table.Random(tasks))
	end
end)

print("Serverside running!")