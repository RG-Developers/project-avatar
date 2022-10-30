include("shared.lua")

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

function ENT:Draw()

	self:DrawModel()

end

function ENT:Initialize()

	--self:SetModel( MemoryLeakModels[ math.random( #MemoryLeakModels) ] )
	
	self.Scale = 1
	self.Type = 0

end

function ENT:Think()
	
	if(self.Scale < 2)then
		if(math.random(100)>99)then
			self:SetModel( MemoryLeakModels[ math.random( #MemoryLeakModels) ] )
			self:SetAngles( AngleRand() )
			local scale = math.Rand(self.Scale*1.3,self.Scale*1.3+1)
			--self:ManipulateBoneScale( 0, Vector( scale, scale, scale ) )
			self:SetModelScale( scale )
		end
	else
		if(math.random(100)>99)then
			if(!IsValid(self.Mat))then
				self.Mat = CreateMaterial( self:EntIndex().."corrupttex", "VertexLitGeneric", {
				  ["$basetexture"] = MemoryLeakTextures[ math.random( #MemoryLeakTextures) ],
				  ["$model"] = 1,
				  ["$translucent"] = 1,
				  ["$vertexalpha"] = 1,
				  ["$vertexcolor"] = 1
				} )
			end
			self:SetModel( "models/hunter/blocks/cube4x4x4.mdl" )
			self:SetMaterial("!"..self:EntIndex().."corrupttex")
			self:SetAngles( AngleRand() )
			local scale = math.Rand(2,2.4)
			--self:ManipulateBoneScale( 0, Vector( scale, scale, scale ) )
			self:SetModelScale( self.Scale*(scale/2) )
		end
	end

end
