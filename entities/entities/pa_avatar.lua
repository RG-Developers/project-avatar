AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
		render.SetColorMaterial()
		render.DrawBeam(self:GetPos() + Vector(0,0,68), util.QuickTrace(
			self:GetPos() + Vector(0,0,68), 
			self:GetAngles():Forward()*100000-Vector(0,0,50), 
			self).HitPos, 3, 0, 1, Color( 255, 0, 0 ))
	end
end

function ENT:GetPlayerColor()
	return Vector( 1, 0, 0 )
end

function ENT:Initialize()
	if SERVER then
	    self:SetFOV(90)
	end
	self:SetModel( "models/player/combine_super_soldier.mdl" )
	self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
	self.laserStrength  = 2
end

----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end


----------------------------------------------------
-- ENT:HaveEnemy()
-- Returns true if we have an enemy
----------------------------------------------------
function ENT:HaveEnemy()
	-- If our current enemy is valid
	if ( self:GetEnemy() and IsValid(self:GetEnemy()) ) then
		-- If the enemy is too far
		if ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			return self:FindEnemy()
		-- If the enemy is dead( we have to check if its a player before we use Alive() )
		elseif ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then
			return self:FindEnemy()		-- Return false if the search finds nothing
		end	
		-- The enemy is neither too far nor too dead so we can return true
		return true
	else
		-- The enemy isn't valid so lets look for a new one
		return self:FindEnemy()
	end
end

----------------------------------------------------
-- ENT:FindEnemy()
-- Returns true and sets our enemy if we find one
----------------------------------------------------
function ENT:FindEnemy()
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = ents.FindInSphere( self:GetPos(), self.SearchRadius )
	-- Here we loop through every entity the above search finds and see if it's the one we want
	for k,v in ipairs( _ents ) do
		if ( v:IsPlayer() and self:IsAbleToSee(v) and (v:Team() == TEAM_TESTSUBJECTS or v:Team() == TEAM_TESTSUBJECTS_BOOSTED)
		and v:Alive() ) then
			-- We found one so lets set it as our enemy and return true
			self:SetEnemy(v)
			return true
		end
	end	
	-- We found nothing so we will set our enemy as nil (nothing) and return false
	self:SetEnemy(nil)
	return false
end

----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	-- This function is called when the entity is first spawned, it acts as a giant loop that will run as long as the NPC exists
	local movto
	local tpto
	while ( true ) do
		self:SetHealth(1)
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if ( self:HaveEnemy() ) then
			-- Now that we have a enemy, the code in this block will run
			self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
			self.loco:SetDesiredSpeed( 450 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
			self.loco:SetAcceleration(900)			-- We are going to run at the enemy quickly, so we want to accelerate really fast
			self:ChaseEnemy() 						-- The new function like MoveToPos that will be looked at soon.
			self.loco:SetAcceleration(400)			-- Set this back to its default since we are done chasing the enemy
			self:StartActivity( ACT_IDLE )			--We are done so go back to idle
			-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
			-- unless you put stuff after the if statement. Then that will be run before it loops
		else
			-- Since we can't find an enemy, lets wander
			-- Its the same code used in Garry's test bot
			self.loco:SetDesiredSpeed( 200 )		-- Walk speed
			if math.random(0, 10) < 9 then
				movto = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400
				self.loco:FaceTowards( movto )
				self:MoveToPos( movto ) -- Walk to a random place within about 400 units (yielding)
			else
				tpto = Vector(self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400)
				if util.QuickTrace(tpto, Vector(0,0,-1000), self).HitWorld then
					self:SetPos(tpto)
					self:SetAngles(Angle(0, math.random(0,359), 0))
				end
			end
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
		coroutine.wait(2)
		
	end

end

----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
--  except it will constantly follow the
--  position of the enemy until there no longer
--  is an enemy.
----------------------------------------------------
function ENT:ChaseEnemy( options )
	local options = options or {draw = true}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 100 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemy's position
	local moved = false
	if ( not path:IsValid() ) then return "failed" end
	while ( path:IsValid() and self:HaveEnemy() ) do
		if ( path:GetAge() > 0.1 ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute(self, self:GetEnemy():GetPos()) -- Compute the path towards the enemy's position again
		end
		path:Update( self )								-- This function moves the bot along the path
		--movto = path:GetPositionOnPath(dist)
		--if self:MoveToPos(movto) == "failed" then
		moved = false
		for _, e in pairs(ents.FindInSphere(self:GetPos(), 300)) do
			if e == self:GetEnemy() then 
				moved = true 
			end
		end
		if not moved and math.random(0, 100) > 85 then
			self:SetPos(self:GetEnemy():GetPos() + (-(self:GetEnemy():GetForward()) * 200) )
			self.loco:FaceTowards(self:GetEnemy():GetPos())
			coroutine.wait(2)
		end
		self:TryAttacking()
		
		if ( options.draw ) then path:Draw() end
		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"
end

function ENT:TryAttacking()
	local trace = util.QuickTrace(
				self:GetPos() + Vector(0,0,30), 
				self:GetAngles():Forward()*100000, 
				self)
	if IsValid(trace.Entity) and trace.Entity:IsValid() then
		trace.Entity:TakeDamage(self.laserStrength)
	end
end

list.Set( "NPC", "pa_avatar", {
	Name = "Avatar",
	Class = "pa_avatar",
	Category = "Nextbot"
})