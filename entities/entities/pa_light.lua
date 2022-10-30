
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Light"
ENT.Editable = true

--
-- Set up our data table
--
function ENT:SetupDataTables()

	self:NetworkVar( "Float", 1, "LightSize", { KeyName = "sz", Edit = { type = "Float", order = 3, min = 0, max = 1024, title = "#tool.light.size" } } )
	self:NetworkVar( "Float", 2, "Brightness" , { KeyName = "br", Edit = { type = "Int", order = 4, min = 0, max = 6, title = "#tool.light.brightness" } } )
	self:NetworkVar( "Bool", 2, "LightWorld" , { KeyName = "world", Edit = { type = "Boolean", order = 5, title = "#tool.light.noworld", category = "#entedit.advanced" } } )
	self:NetworkVar( "Bool", 3, "LightModels" , { KeyName = "models", Edit = { type = "Boolean", order = 6, title = "#tool.light.nomodels", category = "#entedit.advanced" } } )

end

function ENT:Initialize()

	if ( CLIENT ) then

		self.PixVis = util.GetPixelVisibleHandle()

	end

	if ( SERVER ) then --lights are rolling around even though the model isn't round!!

	end

end

function ENT:OnTakeDamage( dmginfo )
	-- React to physics damage
	self:TakePhysicsDamage( dmginfo )
end

function ENT:Draw() end

function ENT:Think()

	self.BaseClass.Think( self )

	if ( CLIENT ) then

		local dlight = DynamicLight( self:EntIndex() )
		if not self:GetParent():IsValid() then return end
		if ( dlight ) then

			local c = self:GetColor()

			local size = self:GetLightSize()
			local brght = self:GetBrightness()
			-- Clamp for multiplayer
			if ( !game.SinglePlayer() ) then
				size = math.Clamp( size, 0, 1024 )
				brght = math.Clamp( brght, 0, 6 )
			end

			dlight.Pos = self:GetParent():GetPos()
			dlight.r = c.r
			dlight.g = c.g
			dlight.b = c.b
			dlight.Brightness = brght
			dlight.Decay = size * 5
			dlight.Size = size
			dlight.DieTime = CurTime() + 1

		end

	end

end

--[[
local matLight = Material( "sprites/light_ignorez" )
function ENT:DrawEffects()
	local LightPos = self:GetParent():GetPos()

	local Visibile = util.PixelVisible( LightPos, 4, self.PixVis )
	if ( !Visibile || Visibile < 0.1 ) then return end

	local c = self:GetColor()
	local Alpha = 255 * Visibile
	local up = self:GetAngles():Up()

	render.SetMaterial( matLight )
	render.DrawSprite( LightPos - up * 2, 8, 8, Color( 255, 255, 255, Alpha ) )
	render.DrawSprite( LightPos - up * 4, 8, 8, Color( 255, 255, 255, Alpha ) )
	render.DrawSprite( LightPos - up * 6, 8, 8, Color( 255, 255, 255, Alpha ) )
	render.DrawSprite( LightPos - up * 5, 64, 64, Color( c.r, c.g, c.b, 64 ) )

end

-- We have to do this to ensure DrawTranslucent is called for Opaque only models to draw our effects
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:DrawTranslucent( flags )
	BaseClass.DrawTranslucent( self, flags )
	self:DrawEffects()
end
]]