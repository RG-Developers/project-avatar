AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Bug"
ENT.Category = "Project Avatar"
ENT.Spawnable = true


if CLIENT then
  function ENT:Draw()
    if LocalPlayer():Team() == TEAM_TESTSUBJECTS then 
      self:DrawModel() 
    end
    if LocalPlayer():Team() == TEAM_FIXERS then 
      self:DrawModel() 
    end
  end
end

function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube1x1x1.mdl")
    self:SetMoveType(MOVETYPE_NONE)
    if not util.QuickTrace(self:GetPos(), Vector(0,0,-100)).HitWorld then self:SetColor(Color(255,0,0,255)) end
    self:SetMaterial("models/wireframe")
    if SERVER then
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        local leak = ents.Create("hammer_leak_bug")
        leak:SetParent(self)
        self:SetNWEntity("leak",leak)
        leak:Spawn()
    end
    self:SetNWBool("hasQTE", true)
    self:SetNWBool("QTEdone", false)
    for i=1,7,1 do
        self:SetNWInt("qte"..i, math.random(1, 17))
    end
    self.fixtime = CurTime() + 120
    self.basescore = math.random(30, 50)
    self:EmitSound("/project_avatar/bugs/bugspawn_"..math.random(1,3)..".wav")
    self:EmitSound("/project_avatar/bugs/bugambient.wav",100,100,1,CHAN_AUTO,SND_NOFLAGS)
end
function ENT:OnRemove()
    self:StopSound("/project_avatar/bugs/bugambient.wav")
    self:EmitSound("/project_avatar/bugs/bugfix_"..math.random(1,2)..".wav")
    if SERVER then
        if IsValid(self:GetNWEntity("leak",nil)) then self:GetNWEntity("leak",nil):Remove() end
        SetGlobalInt("TestersScore", GetGlobalInt("TestersScore") + math.floor(self.score))
    end
end
function ENT:Use(ply)
    self:EmitSound("/project_avatar/bugs/playerpickupbug_"..math.random(1,3)..".wav")
    if SERVER then self:Remove() end
end
function ENT:OnTakeDamage(ply)
    self:EmitSound("/project_avatar/bugs/playerpickupbug_"..math.random(1,3)..".wav")
    if SERVER then self:Remove() end
end
if SERVER then
    function ENT:Think()
        if self:GetNWBool("QTEdone") then
            if CurTime() > self.fixtime-60 then
                self:Remove()
            end
        else
            if CurTime() > self.fixtime then
                self:Remove()
            end
        end
        self.score = self.basescore * ((self.fixtime-CurTime()) / 120)
    end
end