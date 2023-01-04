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
		ply:AllowFlashlight(false)
	elseif ply:Team() == TEAM_TESTSUBJECTS then
		player_manager.SetPlayerClass(ply, "player_testsubject")
		ply:AllowFlashlight(true)
	elseif ply:Team() == TEAM_TESTSUBJECTS_BOOSTED then
		player_manager.SetPlayerClass(ply, "player_testsubject_boosted")
		ply:AllowFlashlight(true)
	elseif ply:Team() == TEAM_FIXERS then
		player_manager.SetPlayerClass(ply, "player_fixer")
		ply:AllowFlashlight(true)
		ply:EmitSound("/project_avatar/fixers_voicelines/spawn_"..math.random(1,4)..".wav")
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

function GM:OnNPCKilled(Victim, _, _)
	if Victim:GetClass() == "npc_combine_s" then
		local plyang = Victim:GetAngles()
		local plyvel = Victim:GetVelocity()
		local plypos = Victim:GetPos()
		local oldragdoll = Victim
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
		Victim:Remove()
		MakeLight(0, 255, 0, 255, 500, brainmelt)
		local coro = coroutine.create(function(model, freeze) 
			while CurTime() < freeze do coroutine.yield() end
			local mainbone = model:TranslateBoneToPhysBone( 10 )
			for i=0, model:GetBoneCount(),1 do
				constraint.Weld(model, model, mainbone, model:TranslateBoneToPhysBone( i ), 0, false, false)
			end
			coroutines[Victim:EntIndex()+2000] = nil
			coroutines[Victim:EntIndex()] = nil
		end)
		coroutine.resume(coro, brainmelt, CurTime() + 0.5)
		coroutines[Victim:EntIndex()+1000] = coro
	end
end

function GM:PlayerDeathSound( ply )
	return true
end

function GM:PlayerDeath(ply, _, atk)
	if ply:Team() == TEAM_FIXERS then
		ply:GetRagdollEntity():Remove() 
		local plyang = ply:GetAngles()
		local plyvel = ply:GetVelocity()
		local plypos = ply:GetPos()
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
		MakeLight(0, 255, 0, 255, 500, brainmelt)
		ply:SetTeam(TEAM_AWAITING)
		ply:GetRagdollEntity():Remove() 
		--ply:SetObserverMode(OBS_MODE_IN_EYE)
		--ply:Spectate(OBS_MODE_IN_EYE)
		local coro = coroutine.create(function(model, freeze) 
			while CurTime() < freeze do coroutine.yield() end
			local mainbone = model:TranslateBoneToPhysBone( 10 )
			for i=0, model:GetBoneCount(),1 do
				constraint.Weld(model, model, mainbone, model:TranslateBoneToPhysBone( i ), 0, false, false)
			end
			coroutines[ply:EntIndex()+2000] = nil
			coroutines[ply:EntIndex()] = nil
		end)
		coroutine.resume(coro, brainmelt, CurTime() + 1.5)
		coroutines[ply:EntIndex()+1000] = coro
	elseif ply:Team() == TEAM_TESTSUBJECTS or ply:Team() == TEAM_TESTSUBJECTS_BOOSTED then
		if atk:IsPlayer() and atk:Team() == TEAM_FIXERS then
			atk:EmitSound("/project_avatar/fixers_voicelines/testerkilled_"..math.random(1,6)..".wav")
			atk:SetNWBool("spottester", false)
		end 
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
	        )
	    end
	    if ply:GetNWBool("respawn_allowed", false) then 
	        ply:Spawn()
	    end
	    return false
	elseif ply:Team() == TEAM_FIXERS then
		return false
	else
		--ply:Spawn()
	end
end

hook.Add("PlayerShouldTakeDamage", "AntiTeamkill", function( ply, attacker )
	if ply:Team() == TEAM_SCIENTISTS then return false end
	if GetConVar("pa_friendlyfire"):GetString() == "0" then return true end
	if attacker:IsPlayer() and ply:Team() == attacker:Team() and attacket ~= ply then
		return false
	end
	return true
end)

hook.Add("EntityTakeDamage", "FixerSuitNotLocked", function(ply, dmg) 
	if ply:GetNWInt("ffdmg") == nil then ply:SetNWInt("ffdmg", RealTime()) end
	if ply:IsPlayer() and ply:Team() == TEAM_FIXERS and dmg:GetAttacker():IsPlayer() and dmg:GetAttacker():Team() == TEAM_FIXERS and ply:GetNWInt("ffdmg") < RealTime() then
		ply:EmitSound("/project_avatar/fixers_voicelines/friendlyfire_"..math.random(1,5)..".wav")
		ply:SetNWInt("ffdmg", RealTime()+2)
	elseif ply:IsPlayer() and ply:Team() == TEAM_FIXERS and ply:GetNWInt("dmg") < RealTime() and ply:GetNWInt("ffdmg") < RealTime() then
		ply:EmitSound("/project_avatar/fixers_voicelines/genericdamage_"..math.random(1,5)..".wav")
		ply:SetNWInt("ffdmg", RealTime()+2)
	end
	if ply:IsPlayer() and ply:Team() == TEAM_FIXERS and dmg:IsBulletDamage() and not (dmg:GetDamageType() == DMG_GENERIC) and ply:Health() < 50 then --FULL WORK
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

--SVThink hooks

hook.Add("Think", "CountTeams", function()
	local testsubj_count = 0
	local scien_count = 0
	local fixer_count = 0
	for k, v in pairs(player.GetAll()) do
        if v:Team() == TEAM_TESTSUBJECTS then
            testsubj_count = testsubj_count + 1
        end
        if v:Team() == TEAM_SCIENTISTS then
            scien_count = scien_count + 1
        end
        if v:Team() == TEAM_FIXERS then
            fixer_count = fixer_count + 1
        end
    end
    for k, v in pairs(ents.FindByClass("npc_combine_s")) do
    	fixer_count = fixer_count + 1
    end
    SetGlobalInt("TestersCount", testsubj_count)
    SetGlobalInt("ScientistsCount", scien_count)
    SetGlobalInt("FixersCount", fixer_count)
end)

hook.Add("Think", "FixersVOXtesterspot", function()
	for k, v in pairs(player.GetAll()) do
		if v:Team() ~= TEAM_FIXERS or v:GetNWBool("spottester") then continue end
		local trent = v:GetEyeTrace().Entity
		if trent:IsPlayer() and ( trent:Team() == TEAM_TESTSUBJECTS or trent:Team() == TEAM_TESTSUBJECTS_BOOSTED ) then
			v:EmitSound("/project_avatar/fixers_voicelines/testerspot_"..math.random(1, 9)..".wav")
			v:SetNWBool("spottester", true)
		end
	end
end)

hook.Add("Think", "AvatarActivate", function()
	if GetGlobalInt("TestersScore") > 500 and not GetAvatarState() then
        local avatar = ents.Create("pa_avatar")
        avatar:SetPos(Vector(0,0,0))
        avatar:Spawn()
        SetAvatarState(true)
    end
end)