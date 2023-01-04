PANEL = {}

local garry = Material("project_avatar/hud/ts/illustrations/garry.png")
local kratos = Material("project_avatar/hud/ts/illustrations/kratos.png")
local newguy = Material("project_avatar/hud/ts/illustrations/newguy.png")
local circle = Material("project_avatar/hud/ts/illustrations/circle.png")

local basew, baseh = 500, 900
local scale = (ScrH() / ScrW())
local desc = "..."

local hover
local hoverstarttime = 0

hook.Add('InitPostEntity', 'soundsload2', function()
	hover = CreateSound(game.GetWorld(), "/project_avatar/ui/hover_test_subjects.wav")
end)


function PANEL:Init()
	surface.CreateFont( "csfont", {
        font = "Bebas Neue Cyrillic",
        extended = false,
        size = 50,
        weight = 500})
	self.BlurStart = SysTime()
	-- {"None", "Garry", "Circle", "Newguy", "Kratos"}
	self:SetSize(ScrW(), ScrH())

	self.Main = vgui.Create("DFrame", self)
	self.Main:ShowCloseButton(false)
    self.Main:SetDraggable( false )
	self.Main:SetSize(ScrW(), ScrH()) 
	self.Main:Center()
	self.Main.Paint = nil

	self.garry = vgui.Create("DButton", self.Main)
	self.garry:SetText("")
	self.garry:SetSize(basew * scale, baseh * scale)
	self.garry:SetPos(-basew * scale, (ScrH()-(baseh*scale)))
	self.garry.DoClick = function()
		surface.PlaySound(("project_avatar/ui/click%d.wav"):format(math.random(1, 4)))
		hover:Stop()
		net.Start("PA_ClassSelect")
			net.WriteUInt(1, 3)
		net.SendToServer()
	end
	self.garry.Paint = function(s, w, h)
		if not s.Factor then s.Factor = 0.6 end
		surface.SetDrawColor(255 * s.Factor, 255 * s.Factor, 255 * s.Factor, 255)
		s.Factor = math.Clamp(s.Factor, 0.6, 1)
		surface.SetMaterial(garry)
		surface.DrawTexturedRect(0, 0, w, h)
		if s:IsHovered() then
			if s.Factor < 1 then
				s.Factor = s.Factor + FrameTime()*2
			end
			desc = "The great hacker"
			if RealTime() > hoverstarttime + SoundDuration("/project_avatar/ui/hover_test_subjects.wav") and hover:IsPlaying() then
				hover:Stop()
				hover:Play()
				hoverstarttime = RealTime()
			else
				hover:Play()
			end
		elseif desc == "The great hacker" then
			desc = "..."
			hover:Stop()
			hoverstarttime = 0
		else
			if s.Factor > 0.6 then
				s.Factor = s.Factor - FrameTime()*2
			end
		end
	end

	self.kratos = vgui.Create("DButton", self.Main)
	self.kratos:SetText("")
	self.kratos:SetSize(basew * scale, baseh * scale)
	self.kratos:SetPos(-basew * scale, (ScrH()-(baseh*scale)))
	self.kratos.DoClick = function()
		surface.PlaySound(("project_avatar/ui/click%d.wav"):format(math.random(1, 4)))
		hover:Stop()
		net.Start("PA_ClassSelect")
			net.WriteUInt(4, 3)
		net.SendToServer()
	end
	self.kratos.Paint = function(s, w, h)
		if not s.Factor then s.Factor = 0.6 end
		surface.SetDrawColor(255 * s.Factor, 255 * s.Factor, 255 * s.Factor, 255)
		s.Factor = math.Clamp(s.Factor, 0.6, 1)
		surface.SetMaterial(kratos)
		surface.DrawTexturedRect(0, 0, w, h)
		if s:IsHovered() then
			if s.Factor < 1 then
				s.Factor = s.Factor + FrameTime()*2
			end
			desc = "death and destruction"
			if RealTime() > hoverstarttime + SoundDuration("/project_avatar/ui/hover_test_subjects.wav") and hover:IsPlaying() then
				hover:Stop()
				hover:Play()
				hoverstarttime = RealTime()
			else
				hover:Play()
			end
		elseif desc == "death and destruction" then
			desc = "..."
			hover:Stop()
			hoverstarttime = 0
		else
			if s.Factor > 0.6 then
				s.Factor = s.Factor - FrameTime()*2
			end
		end
	end

	self.circle = vgui.Create("DButton", self.Main)
	self.circle:SetText("")
	self.circle:SetSize(basew * scale, baseh * scale)
	self.circle:SetPos(-basew * scale, (ScrH()-(baseh*scale)))
	self.circle.DoClick = function()
		surface.PlaySound(("project_avatar/ui/click%d.wav"):format(math.random(1, 4)))
		hover:Stop()
		net.Start("PA_ClassSelect") 
			net.WriteUInt(2, 3)
		net.SendToServer()
	end
	self.circle.Paint = function(s, w, h)
		if not s.Factor then s.Factor = 0.6 end
		surface.SetDrawColor(255 * s.Factor, 255 * s.Factor, 255 * s.Factor, 255)
		s.Factor = math.Clamp(s.Factor, 0.6, 1)
		surface.SetMaterial(circle)
		surface.DrawTexturedRect(0, 0, w, h)
		if s:IsHovered() then
			if s.Factor < 1 then
				s.Factor = s.Factor + FrameTime()*2
			end
			desc = "The PosterMaker"
			if RealTime() > hoverstarttime + SoundDuration("/project_avatar/ui/hover_test_subjects.wav") and hover:IsPlaying() then
				hover:Stop()
				hover:Play()
				hoverstarttime = RealTime()
			else
				hover:Play()
			end
		elseif desc == "The PosterMaker" then
			desc = "..."
			hover:Stop()
			hoverstarttime = 0
		else
			if s.Factor > 0.6 then
				s.Factor = s.Factor - FrameTime()*2
			end
		end
	end

	self.newguy = vgui.Create("DButton", self.Main)
	self.newguy:SetText("")
	self.newguy:SetSize(basew * scale, baseh * scale)
	self.newguy:SetPos(-basew * scale, (ScrH()-(baseh*scale)))
	self.newguy.DoClick = function()
		surface.PlaySound(("project_avatar/ui/click%d.wav"):format(math.random(1, 4)))
		hover:Stop()
		net.Start("PA_ClassSelect") 
			net.WriteUInt(3, 3)
		net.SendToServer()
	end
	self.newguy.Paint = function(s, w, h)
		if not s.Factor then s.Factor = 0.6 end
		surface.SetDrawColor(255 * s.Factor, 255 * s.Factor, 255 * s.Factor, 255)
		s.Factor = math.Clamp(s.Factor, 0.6, 1)
		surface.SetMaterial(newguy)
		surface.DrawTexturedRect(0, 0, w, h)
		if s:IsHovered() then
			if s.Factor < 1 then
				s.Factor = s.Factor + FrameTime()*2
			end
			desc = "Just a new guy"
			if RealTime() > hoverstarttime + SoundDuration("/project_avatar/ui/hover_test_subjects.wav") and hover:IsPlaying() then
				hover:Stop()
				hover:Play()
				hoverstarttime = RealTime()
			else
				hover:Play()
			end
		elseif desc == "Just a new guy" then
			desc = "..."
			hover:Stop()
			hoverstarttime = 0
		else
			if s.Factor > 0.6 then
				s.Factor = s.Factor - FrameTime()*2
			end
		end
	end
	
	self.newguy:MoveTo(ScrW()/4*0, (ScrH()-(baseh*scale)), 1/4, 1/8*0, 0.3)
	self.garry:MoveTo(ScrW()/4*1, (ScrH()-(baseh*scale)), 1/4, 1/8*1, 0.3)
	self.circle:MoveTo(ScrW()/4*2, (ScrH()-(baseh*scale)), 1/4, 1/8*2, 0.3)
	self.kratos:MoveTo(ScrW()/4*3, (ScrH()-(baseh*scale)), 1/4, 1/8*3, 0.3)

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
	draw.DrawText(desc, "csfont", ScrW()/2, 60, Color(255,255,255,255), TEXT_ALIGN_CENTER)
end


return vgui.RegisterTable(PANEL, "EditablePanel")
