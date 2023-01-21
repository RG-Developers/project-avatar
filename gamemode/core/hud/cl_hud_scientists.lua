hud = {}

function hud.draw(ply, hp, maxhp, name, class, subclass, fade,
				  hud_materials, hud_variables, hud_coroutines, hud_sounds)
	
	local x = hud_variables.HUDPosition["XPos"]
	local y = hud_variables.HUDPosition["YPos"]

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hud_materials.scientist.base)
	surface.DrawTexturedRect(x, 20, 222/2, 90/2)
	lvl, let = GetScientistDoctype(ply)
	if lvl == 2 then
		surface.SetMaterial(hud_materials.scientist.doc_2000)
		surface.DrawTexturedRect(x, 20, 222/2, 90/2)
	elseif lvl == 3 then
		surface.SetMaterial(hud_materials.scientist.doc_3000)
		surface.DrawTexturedRect(x, 20, 222/2, 90/2)
	else
		surface.SetMaterial(hud_materials.scientist.doc_1000)
		surface.DrawTexturedRect(x, 20, 222/2, 90/2)
	end
	if let == "o" then
		surface.SetMaterial(hud_materials.scientist.omega)
		surface.DrawTexturedRect(x, 20, 222/2, 90/2)
	else
		surface.SetMaterial(hud_materials.scientist.sigma)
		surface.DrawTexturedRect(x, 20, 222/2, 90/2)
	end
	draw.RoundedBox( 0, x+182/2, y+95, (((GetScientistMistakes(ply) - 0) * 268/2) / 10), 77 / 2, Color(0, 175, 255, 255) )
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hud_materials.scientist.mst_base)
	surface.DrawTexturedRect(x, y+90, 460/2, 97/2)
end

return hud