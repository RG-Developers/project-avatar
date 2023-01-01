include("sh_shared.lua")
include("core/cl_hud.lua")
include("core/cl_scientist_tablet.lua")
include("core/cl_tab.lua")

function GM:NetworkEntityCreated( ent )
	if (ent:GetSpawnEffect() and ent:GetCreationTime() > ( CurTime() - 1.0 ) ) then
		local ed = EffectData()
			ed:SetOrigin( ent:GetPos() )
			ed:SetEntity( ent )
		util.Effect( "propspawn", ed, true, true )
	end

end

print("Clientside running!")