
AddCSLuaFile()
DEFINE_BASECLASS "player_default"

local PLAYER = {}

PLAYER.DisplayName 			= "Fixer"
PLAYER.DuckSpeed 			= 0.05
PLAYER.UnDuckSpeed 			= 0.05
PLAYER.SlowWalkSpeed		= 50
PLAYER.WalkSpeed 			= 150
PLAYER.RunSpeed				= 500

function PLAYER:SetupDataTables()
	BaseClass.SetupDataTables(self)
end

function PLAYER:Loadout()
	self.Player:RemoveAllAmmo()
end

function PLAYER:SetModel()
	BaseClass.SetModel(self)
end


local JUMPING

function PLAYER:StartMove(mv)
	if bit.band(mv:GetButtons(), IN_JUMP) ~= 0 and bit.band(mv:GetOldButtons(), IN_JUMP) == 0 and self.Player:OnGround() then
		JUMPING = true 
	end 
end

function PLAYER:FinishMove(mv)
	if JUMPING then
		local forward = mv:GetAngles()
		forward.p = 0
		forward = forward:Forward()

		local speedBoostPerc = not self.Player:Crouching() and 0.5 or 0.1

		local speedAddition = math.abs(mv:GetForwardSpeed() * speedBoostPerc)
		local maxSpeed = mv:GetMaxSpeed() * (1 + speedBoostPerc)
		local newSpeed = speedAddition + mv:GetVelocity():Length2D()

		if newSpeed > maxSpeed then
			speedAddition = speedAddition - (newSpeed - maxSpeed)
		end

		if mv:GetVelocity():Dot(forward) < 0 then
			speedAddition = -speedAddition
		end

		mv:SetVelocity(forward * speedAddition + mv:GetVelocity())
	end

	JUMPING = nil
end

player_manager.RegisterClass("player_fixer", PLAYER, "player_default")