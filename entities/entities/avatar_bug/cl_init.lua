include("shared.lua")

function ENT:Draw()
	if LocalPlayer():Team() == TEAM_TESTSUBJECTS then 
		self:DrawModel() 
	end
	if LocalPlayer():Team() == TEAM_FIXERS then 
		self:DrawModel() 
	end
end