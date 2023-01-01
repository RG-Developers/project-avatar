if SERVER then
	CreateConVar("pa_friendlyfire","1",FCVAR_ARCHIVE)

	hook.Add( "PlayerShouldTakeDamage", "pa.AntiTeamkill", function( ply, attacker ) -- добавил секта(я), спиздил с вики гмода
		if attacker:IsPlayer() and ply:Team() == attacker:Team() and GetConVar("pa_friendlyfire"):GetString()=="1" then
			return false -- that will block damage if attacker and ply is on the same team.
		end
	end )

	team_select_allowed = GetConVar("team_select_window"):GetBool()
	util.AddNetworkString("PA_TeamSelect")
	util.AddNetworkString("PA_ClassSelect")
	if team_select_allowed then 
		local cooldown = {}

		net.Receive("PA_TeamSelect", function(_, ply)
			cooldown[ply:SteamID()] = cooldown[ply:SteamID()] or 0

			if cooldown[ply:SteamID()] > math.floor(CurTime()) then
				net.Start("PA_TeamSelect")
					net.WriteUInt(0, 2)
					net.WriteUInt(math.max(0, math.floor(cooldown[ply:SteamID()]-CurTime())), 10)
				net.Send(ply)

				return
			elseif GAMEMODE:IsGameRunning() and ply:Team() ~= TEAM_UNASSIGNED then
				net.Start("PA_TeamSelect")
					net.WriteUInt(1, 2)
				net.Send(ply)

				return
			end

			local team = net.ReadUInt(2)
			if not team then return end

			if team+1 == ply:Team() then
				net.Start("PA_TeamSelect")
					net.WriteUInt(2, 2)
				net.Send(ply)

				return
			end

			if team == 0 then
				ply:SetTeam(TEAM_AWAITING)
			elseif team == 1 then
				ply:SetTeam(TEAM_SCIENTISTS)
			elseif team == 2 then
				ply:SetTeam(TEAM_TESTSUBJECTS)
				net.Start("PA_ClassSelect")
				net.Send(ply)
			end
			ply:KillSilent()
			ply:Spawn()

			cooldown[ply:SteamID()] = math.floor(CurTime() + 3) -- to-do: convar for team cooldown
		end)
		net.Receive("PA_ClassSelect", function(_, ply)
			local class = net.ReadUInt(3)
			SetClass(ply, TEAM_TESTSUBJECTS, class)
			ply:KillSilent()
			ply:Spawn()
			net.Start("PA_ClassSelect")
				net.WriteUInt(1,1)
			net.Send(ply)

			cooldown[ply:SteamID()] = math.floor(CurTime() + 3) -- to-do: convar for team cooldown
		end)
	end
end

if CLIENT then
	team_select_allowed = GetConVar("team_select_window"):GetBool()
	if team_select_allowed then
		local TeamPanel = include "vgui/cl_team_select.lua"
		local ClassPanel = include "vgui/cl_class_select.lua"

		function GM:ShowTeam()
			if IsValid(self.TeamSelectMenu) then return end

			TeamSelectMenu = vgui.CreateFromTable(TeamPanel)
		end

		function GM:HideTeam()
			if IsValid(self.TeamSelectMenu) then
				TeamSelectMenu:Remove()
				TeamSelectMenu = nil
			end
		end

		function ShowClass() --я убрал GM:
			if IsValid(ClassSelectMenu) then return end

			ClassSelectMenu = vgui.CreateFromTable(ClassPanel)
		end

		function HideClass()
			if IsValid(ClassSelectMenu) then -- запускай сервер заного, вродь пофиксил
				ClassSelectMenu:Remove()
				ClassSelectMenu = nil
			end
		end

		local tag, white, red = Color(175, 175, 175), Color(255, 255, 255), Color(255, 70, 70)
		net.Receive("PA_ClassSelect", function()
			if net.ReadUInt(1) == 1 then
				HideClass()
			else
				ShowClass()
			end
		end)

		net.Receive("PA_TeamSelect", function()
			local error = net.ReadUInt(2)

			if error == 0 then
				local remain = net.ReadUInt(10)
				local time_letter = ""
				local remain_time = tonumber(tostring(remain):match(".$"))

				if remain_time > 0 and remain_time < 2 then
					time_letter = "а"
					remain_ending = "ась"
				elseif remain_time > 1 then
					time_letter = "ы"
					remain_ending = "ось"
				end


				chat.AddText(tag, "[", white, "Project", red, " Avatar", tag, "] ", white, "Подождите немного, прежде чем сменить команду (остал" .. remain_ending .. " " .. remain .. " секунд" .. time_letter .. ")")
			elseif error == 1 then
				chat.AddText(tag, "[", white, "Project", red, " Avatar", tag, "] ", white, "Игра уже запущена! Вы сможете присоединиться после окончания!")
			elseif error == 2 then
				chat.AddText(tag, "[", white, "Project", red, " Avatar", tag, "] ", white, "Вы уже состоите в этой команде")
			end
		end)
	end
end