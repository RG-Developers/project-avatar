hud = {}

function hud.draw(ply, hp, maxhp, name, class, subclass, fade,
				  hud_materials, hud_variables, hud_coroutines, hud_sounds)
	
	local x = hud_variables.HUDPosition["XPos"]
	local y = hud_variables.HUDPosition["YPos"]
	local fixid = hud_variables.FixerData["FEID"]
	local fixrank = hud_variables.FixerData["Rank"]
	if hud.consectrace == nil then hud.consectrace = {""} end
	draw.RoundedBox( 0, x+103, y-50+74+33, ((hp * 300/1.57) / 100), 74/2, Color(66, 66, 66, 255) )
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hud_materials.fixer.base)
	surface.DrawTexturedRect(x, y-50, 460/1.5, 230/1.5)
	draw.WordBox( 8, x+64, y-50+74+80, ""..hp.."%", "bfont", Color(0, 0, 0, 0), Color(66, 66, 66, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	draw.DrawText( name, "bfont", x+85+(310/2)/2-10-50, y-50+12, Color( 255, 255, 255, 255 ) )
	draw.DrawText( fixid, "bfont", x+85+(310/2)/2-10-50, y-50+12+20, Color( 255, 255, 255, 255 ) )
	draw.DrawText( fixrank, "bfont", x+85+(310/2)/2-10-50, y-50+12+40, Color( 255, 255, 255, 255 ) )
	draw.DrawText("Consciousness trace: ", "bfont", 10, 10, Color( 255, 255, 255, 255 ) )
	local y = 10
	if #hud.consectrace[1] > 17 then
		for i=7, 1, -1 do
			hud.consectrace[i+1] = hud.consectrace[i]
		end
		hud.consectrace[1] = ""
	else
		if hp > 0 then hud.consectrace[1] = hud.consectrace[1] .. string.char(math.random(33, 126)) end
	end
	for k, str in pairs(hud.consectrace) do
		y = y + 20
		draw.DrawText(str, "bfont", 10, y, Color( 255, 255, 255, 255 ) )
	end
	if hp < 100 then
		fade = (100-hp) / 50
		draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255,0,0,100-hp/100*200))
		for i=0, 25-hp/4, 1 do
			draw.RoundedBox(0, math.random(0, ScrW()), math.random(0, ScrH()), 10, 10, Color(0,0,0,255))
		end
	else
		fade = 0
	end
end

return hud