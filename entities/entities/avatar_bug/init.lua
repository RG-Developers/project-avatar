include("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    if not util.QuickTrace(self:GetPos(), Vector(0,0,-100)).HitWorld then self:SetColor(Color(255,0,0,255)) end
    self:SetMaterial("models/wireframe")
    self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
    local leak = ents.Create("hammer_leak_bug")
    leak:SetParent(self)
    self:SetNWEntity("leak",leak)
    leak:Spawn()
    self:EmitSound("/project_avatar/bugs/bugspawn_"..math.random(1,3)..".wav")
    self:EmitSound("/project_avatar/bugs/bugambient.wav",100,100,1,CHAN_AUTO,SND_NOFLAGS)
    self:SetNWBool("hasQTE", true)
    self:SetNWBool("fixing", false)
    --local createtime = CurTime()
    self.fixtime = CurTime() + 120
end

function ENT:OnRemove()
    self:StopSound("/project_avatar/bugs/bugambient.wav")
    self:EmitSound("/project_avatar/bugs/bugfix_"..math.random(1,2)..".wav")
    if IsValid(self:GetNWEntity("leak",nil)) then self:GetNWEntity("leak",nil):Remove() end
end

function ENT:Use(ply)
    self:EmitSound("/project_avatar/bugs/playerpickupbug_"..math.random(1,3)..".wav")
    self:Remove()
end

function ENT:Think()
    if self:GetNWBool("fixing") then
        if CurTime() > self.fixtime-60 then
            self:Remove()
        end
    else
        if CurTime() > self.fixtime then
            self:Remove()
        end
    end
end