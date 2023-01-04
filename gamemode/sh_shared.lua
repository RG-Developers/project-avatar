GM.Name = "Project Avatar"
GM.Author = "RG Studios & just good coders and mappers"
GM.Email = "N/A"
GM.Website = "N/A"
GM.TeamBased = true

include("player_class/player_scientist.lua")
include("player_class/player_testsubject.lua")
include("player_class/player_testsubject_boosted.lua")
include("player_class/player_fixer.lua")
include("core/sh_classprocessor.lua")
include("core/sh_team_select.lua")

player_manager.AddValidModel( "FIXER_anim Playermodels", "models/arachnit/wolfenstein2/nazis/fixer_custom_anim.mdl" );
player_manager.AddValidModel( "Server scientist", "models/arachnit/wolfenstein2/nazis/nazi_scientist_player.mdl" );
player_manager.AddValidHands( "Server scientist", "models/arachnit/wolfenstein2/nazis/nazi_scientist_c_arms.mdl", 0, "00000000" )
player_manager.AddValidModel( "FIXER Playermodels", "models/arachnit/wolfenstein2/nazis/nazi_elite_atom_soldier_player.mdl" );
player_manager.AddValidHands( "FIXER Playermodels", "models/arachnit/wolfenstein2/nazis/nazi_elite_atom_soldier_c_arms.mdl", 0, "00000000" )

if CLIENT then
	local function Viewmodel( vm, ply, weapon )
		if LocalPlayer():GetModel() == "models/arachnit/wolfenstein2/nazis/nazi_scientist_player.mdl" then
			Jacket = LocalPlayer():GetBodygroup(5)
			local Hands = LocalPlayer():GetHands()
			if ( weapon.UseHands || not weapon:IsScripted() ) then
				if ( IsValid( Hands ) ) then
					Hands:DrawModel()
					Hands:SetBodygroup(0,Jacket)
				end
			end
		end
	end
	hook.Add( "PostDrawViewModel", "arachnit_wtnc_nazi_scientist_viewmodel", Viewmodel )
end

function GM:CreateTeams()
	TEAM_AWAITING = 1

	team.SetUp(1, "Awaiting", Color(200, 200, 200))
	team.SetClass(TEAM_AWAITING, {"player_default"})

	TEAM_SCIENTISTS = 2

	team.SetUp(2, "Scientists", Color(150, 170, 255))
	team.SetClass(TEAM_SCIENTISTS, {"player_scientist"})

	TEAM_TESTSUBJECTS = 3

	team.SetUp(3, "Test Subjects", Color(255, 170, 150))
	team.SetClass(TEAM_TESTSUBJECTS, {"player_testsubject"})

	TEAM_AVATAR = 4

	team.SetUp(4, "Project Avatar", Color(255, 170, 150))
	team.SetClass(TEAM_AVATAR, {"player_avatar"})

	TEAM_TESTSUBJECTS_BOOStED = 5

	team.SetUp(5, "Test Subjects", Color(255, 170, 150))
	team.SetClass(TEAM_TESTSUBJECTS, {"player_testsubject"})

	TEAM_FIXERS = 6

	team.SetUp(6, "FIXERS", Color(255, 170, 150))
	team.SetClass(TEAM_FIXERS, {"player_testsubject"})
end

function GM:IsGameRunning()
	return GetGlobalBool("GameRunning")
end

function GetSubClass(ply)
	return GetGlobalInt(ply:Name() .. "_subclass") or 0
end

function GetScientistDoctype(ply)
	return GetGlobalInt(ply:Name() .. "_scindoclvl") or 0, GetGlobalString(ply:Name() .. "_scindoclet") or "s"
end

function GetScientistMistakes(ply)
	return GetGlobalInt(ply:Name() .. "_scinmst") or 0
end

function GetAvatarState(state)
	return GetGlobalBool("AvatarState")
end
function GetScientistTask(ply)
	return SetGlobalString(ply:Name().."_task") or "none"
end

function string.split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

print("Shared data running!")