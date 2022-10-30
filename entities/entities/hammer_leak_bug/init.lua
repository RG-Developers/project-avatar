MemoryLeakModels = {
	"models/editor/air_node.mdl",
	"models/editor/air_node_hint.mdl",
	"models/editor/camera.mdl",
	"models/editor/climb_node.mdl",
	"models/editor/cone_helper.mdl",
	"models/editor/ground_node.mdl",
	"models/editor/ground_node_hint.mdl",
	"models/editor/node_hint.mdl",
	"models/editor/overlay_helper.mdl",
	"models/editor/playerstart.mdl",
	"models/editor/scriptedsequence.mdl",
	"models/editor/spot.mdl",
	"models/editor/spot_cone.mdl"
}

MemoryLeakTextures = {
	"dev/dev_measurecrate01",
	"dev/dev_measuregeneric01",
	"tools/toolsnodraw",
	"tools/toolstrigger",
	"tools/toolsskybox"
}

function ents.FindClassInSphere( origin, radius, class, ignore, scale )
	local tEntities = ents.FindInSphere( origin, radius )
	local Return = {}
	local tFind = {}
	local iFind = 0
	local TotalScale = 0
	for i = 1, #tEntities do
		if ( (tEntities[ i ]:GetClass() == class) and (tEntities[ i ] != ignore) ) then
			if ( tEntities[ i ].Scale <= scale ) then
				iFind = iFind + 1
				tFind[ iFind ] = tEntities[ i ]
				TotalScale = TotalScale + tEntities[ i ].Scale
			end
		end
	end
	Return.Ents = tFind
	Return.Scale = TotalScale
	return Return
end

function ents.ToClose( origin, class )
	local tEntities = ents.FindByClass( class )
	local tFind = {}
	local iFind = 0
	
	for i = 1, #tEntities do
		if ( tEntities[ i ]:GetClass() == class ) then
			local ent = tEntities[ i ]
			if(ent:GetPos():DistToSqr(origin)<((ent.Scale*40)*(ent.Scale*40)))then
				return true
			end
			iFind = iFind + 1
			tFind[ iFind ] = tEntities[ i ]
		end
	end
	
	return false
end

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
function ENT:Initialize()

	self:SetModel( MemoryLeakModels[ math.random( #MemoryLeakModels) ] )
	self:SetAngles( AngleRand() )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	if(!self.Dir)then
		self.Dir = Vector(0,0,1)
	end
	self.Scale = 1
	self.Age = 0
	self.Tries = 0
	self.Type = 0
	self.Host = self.Host or "none"
	
	self:AddFlags(FL_OBJECT)
	
	if(self.Host == "none")then
		
	end
	
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
	
end
function ENT:Think()
	--print(self.Host)
	if((!IsValid(self.Host)) and (self.Host != "none"))then
		self:Remove()
	end
	self.Age = self.Age + 1
		if(self.Tries<25)then
			if(math.random(100)>10)then
				local st = self:GetPos()+self.Dir*30+Vector(math.random(-10,10),math.random(-10,10),math.random(-10,10))
				local tr = util.TraceLine( {
					start = st,
					endpos = st+AngleRand():Forward()*100*self.Scale,
					filter = function( ent ) return ( !string.find(ent:GetClass():lower(),"hammer") ) end
				} )
				
				self.Tries = self.Tries + 1
				
				if( (tr.Hit) and (!tr.HitSky) and (util.IsInWorld(st)) )then
					Finds = ents.ToClose( tr.HitPos, "hammer_leak_bug" )
					if(!Finds)then
						if not tr.Entity:IsPlayer() then
							Spread = ents.Create( "hammer_leak_bug" )
							Spread:SetModel( MemoryLeakModels[ math.random( #MemoryLeakModels) ] )
							Spread:SetPos( tr.HitPos )
							Spread.Dir = tr.HitNormal
							if(self.Host == "none")then
								Spread.Host = self
							else
								Spread.Host = self.Host
							end
							if(!tr.Entity:IsWorld())then
								Spread:SetParent( tr.Entity )
							end
							Spread:Spawn()
							self.Tries = 0
						end
					end
				end
			end
			self:SetColor(Color(255,255,255))
		end
		if(math.random(100)>30)then
			--if(self.Scale<4)then
				local FindsRes = ents.FindClassInSphere( self:GetPos(), self.Scale*130, "hammer_leak_bug", self, self.Scale )
				local Finds = FindsRes.Ents
				local TotalScale = FindsRes.Scale
				if(#Finds>10)then
					for i = 1, #Finds do
						if(Finds[i]!=self.Host)then
							Finds[i]:Remove()
						end
					end
					self.Tries = 0
					self.Scale = self.Scale+TotalScale/100
					self.Age = 0
					--for i, ent in pairs( Finds ) do
					--	local scale = ent.Scale
					--	self.Scale = self.Scale + scale
					--	ent:Remove()
					--end
					--[[
					if(self.Scale>3)then
						self.Type = 1
						net.Start( "updatetype" )
						net.WriteEntity( self )
						net.WriteFloat( self.Type )
						net.Send(player.GetAll())
					end
					]]--
				end
				--[[
				net.Start( "updatescale" )
				net.WriteEntity( self )
				net.WriteFloat( self.Scale )
				net.Send(player.GetAll())
				]]
			--end
		end
		
		if(self.Scale>=2)then
			self:SetParent()
		end
end