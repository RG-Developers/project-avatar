PANEL = {}

local bg = Material("project_avatar/team/bg.png")
local button1 = Material("project_avatar/team/scientists_team.png")
local button2 = Material("project_avatar/team/subjects_team.png")
local hovers
local hovert
local hoversstarttime
local hovertstarttime

hook.Add('InitPostEntity', 'soundsload', function()
	hovers = CreateSound(game.GetWorld(), "/project_avatar/ui/hover_scientists.wav")
	hovert = CreateSound(game.GetWorld(), "/project_avatar/ui/hover_test_subjects.wav")
	hovers:SetSoundLevel( -10 )
	hovert:SetSoundLevel( -10 )
	hoversstarttime = 0
	hovertstarttime = 0
end)

function PANEL:Init()
	self.BlurStart = SysTime()

	self:SetSize(ScrW(), ScrH())

	self.Main = vgui.Create("EditablePanel", self)
	self.Main:SetSize(ScrW() * .5, ScrH() * .6)
	self.Main.Paint = function(s, w, h)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(bg)
		surface.DrawTexturedRect(0, 0, w, h)
	end
	self.Main:Center()

	self.Team1 = vgui.Create("DButton", self.Main)
	self.Team1:SetText("")
	self.Team1:SetSize(self.Main:GetTall()/1.6, self.Main:GetTall()/1.6)
	self.Team1:SetPos(0, self.Main:GetTall()/1.7 - self.Team1:GetTall()/2)
	self.Team1.DoClick = function()
		if LocalPlayer():Team() == TEAM_SCIENTISTS then
			surface.PlaySound(("project_avatar/ui/click_no%d.wav"):format(math.random(1, 3)))
		else
			net.Start("PA_TeamSelect")
				net.WriteUInt(1, 2)
			net.SendToServer()
			surface.PlaySound(("project_avatar/ui/click%d.wav"):format(math.random(1, 4)))
			hovers:Stop()
			hovert:Stop()
			self:Remove()
		end
	end
	self.Team1.Paint = function(s, w, h)
		if not s.Factor then s.Factor = 0.9 end
		s.Factor = math.Clamp(s.Factor, 0.9, 1)

		if s:IsHovered() then
			if s.Factor < 1 then
				s.Factor = s.Factor + FrameTime()*2
			end
			if RealTime() > hoversstarttime + SoundDuration("/project_avatar/ui/hover_scientists.wav") then
				hovers:Stop()
				hovers:ChangeVolume(1)
				hovers:Play()
				hoversstarttime = RealTime()
			end
		else
			if s.Factor > 0.9 then
				s.Factor = s.Factor - FrameTime()*2
			end
			hovers:Stop()
			hoversstarttime = 0
		end

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(button1)
		surface.DrawTexturedRect(0, h * .5 - h * s.Factor * .5, w * s.Factor, h * s.Factor)
	end

	self.Team2 = vgui.Create("DButton", self.Main)
	self.Team2:SetText("")
	self.Team2:SetSize(self.Main:GetTall()/1.5, self.Main:GetTall()/1.5)
	self.Team2:SetPos(self.Main:GetWide()-self.Team2:GetWide(), self.Main:GetTall()/1.7 - self.Team2:GetTall()/2)
	self.Team2.DoClick = function()
		if LocalPlayer():Team() == TEAM_TESTSUBJECTS then
			surface.PlaySound(("project_avatar/ui/click_no%d.wav"):format(math.random(1, 3)))
		else
			net.Start("PA_TeamSelect")
				net.WriteUInt(2, 2)
			net.SendToServer()
			surface.PlaySound(("project_avatar/ui/click%d.wav"):format(math.random(1, 4)))
			hovers:Stop()
			hovert:Stop()
			self:Remove()
		end
	end
	self.Team2.Paint = function(s, w, h)
		if not s.Factor then s.Factor = 0.9 end
		s.Factor = math.Clamp(s.Factor, 0.9, 1)

		if s:IsHovered() then
			if s.Factor < 1 then
				s.Factor = s.Factor + FrameTime()*2
			end
			if RealTime() > hovertstarttime + SoundDuration("/project_avatar/ui/hover_scientists.wav") then
				hovert:Stop()
				hovert:ChangeVolume(1)
				hovert:Play()
				hovertstarttime = RealTime()
			end
		else
			if s.Factor > 0.9 then
				s.Factor = s.Factor - FrameTime()*2
			end
			hovert:Stop()
			hovertstarttime = 0
		end

		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(button2)
		surface.DrawTexturedRect(w - w * s.Factor, h * .5 - h * s.Factor * .5, w * s.Factor, h * s.Factor)
	end

	self:MakePopup()
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(
		(math.sin(CurTime())+1)*15,
		(math.sin(CurTime())+1)*15,
		(math.sin(CurTime())+1)*15,
		200
		)
	surface.DrawRect(0, 0, w, h)
end


return vgui.RegisterTable(PANEL, "EditablePanel")