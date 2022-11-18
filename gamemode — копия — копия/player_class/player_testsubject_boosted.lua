
AddCSLuaFile()
DEFINE_BASECLASS "player_default"

local PLAYER = {}

PLAYER.DisplayName 			= "Test Subject"
PLAYER.DuckSpeed 			= 0.1*1.3
PLAYER.UnDuckSpeed 			= 0.1*1.3
PLAYER.SlowWalkSpeed		= 100*1.3
PLAYER.WalkSpeed 			= 200*1.3
PLAYER.RunSpeed				= 400*1.3

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

player_manager.RegisterClass("player_testsubject_boosted", PLAYER, "player_default")