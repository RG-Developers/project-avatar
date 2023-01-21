if CLIENT then
	local hud_coroutines = include("hud/cl_hud_coroutines.lua")
	local hud_materials = include("hud/cl_hud_materials.lua")
	local hud_sounds = include("hud/cl_hud_sounds.lua")
	local hud_variables = include("hud/cl_hud_vars.lua")

	local hud_fixers = include("hud/cl_hud_fixers.lua")
	local hud_scientists = include("hud/cl_hud_scientists.lua")
	local hud_testsubjects = include("hud/cl_hud_testsubjects.lua")

	local fontsize = 26 * hud_variables.HUDPosition["FontScale"]
	local fade = 0
	local coroutines = hud_coroutines.coroutines
	local mat_r = hud_materials.glitcheffect.mat_r
	local mat_g = hud_materials.glitcheffect.mat_g
	local mat_b = hud_materials.glitcheffect.mat_b
	local mat_w = hud_materials.glitcheffect.mat_w
	local mat = hud_materials.glitcheffect.mat_blur

	local handlecoros = hud_coroutines.run_coroutines

	local falsound = hud_sounds.falsound
	local crsound = hud_sounds.crsound

	hook.Add('HUDShouldDraw', 'HUDHide', function( hud )
		for k, v in pairs(hud_variables.HUDShouldHideElements) do
			if hud == v then 
				return false 
			end
		end
	end)

	surface.CreateFont( "bfont", {
		font = "Bebas Neue Cyrillic",
		extended = false,
		size = fontsize,
		weight = 500})
	surface.SetFont('bfont')

	local subclasses = {"<INTERNAL>", "Garry", "Circle", "Newguy", "Kratos"}
	local bendtime, bugs, assault, oassault, falsound_end = 0, {}, false, false, -1
	local consectrace, off = {""}, 0

	hook.Add( "HUDPaint", "DrawHUD", function()
		local ply = LocalPlayer()
		local hp = ply:Health() or 0
		local maxhp = ply:GetMaxHealth() or 0
		local name = ply:Nick()
		local class = ply:Team()
		local subclass = GetSubClass(ply)
		-- constructing hud
		if class == TEAM_AWAITING then
			fade = 0
		elseif class == TEAM_SCIENTISTS then
			hud_scientists.draw(ply, hp, maxhp, name, class, subclass, fade,
								hud_materials, hud_variables, hud_coroutines, hud_sounds)
		elseif class == TEAM_FIXERS then
			hud_fixers.draw(ply, hp, maxhp, name, class, subclass, fade,
								hud_materials, hud_variables, hud_coroutines, hud_sounds)
		elseif class == TEAM_TESTSUBJECTS or class == TEAM_TESTSUBJECTS_BOOSTED then -- testsubjects
			hud_testsubjects.draw(ply, hp, maxhp, name, class, subclass, fade,
								hud_materials, hud_variables, hud_coroutines, hud_sounds)
		end
	end)
	f2 = 0
	hook.Add("RenderScreenspaceEffects", "effects", function()
		f = fade or 0
		local w, h = ScrW(), ScrH()

		if f > 0 then
			render.UpdateScreenEffectTexture()
			local scr_t = render.GetScreenEffectTexture()
			mat_r:SetTexture("$basetexture", scr_t)
			mat_g:SetTexture("$basetexture", scr_t)
			mat_b:SetTexture("$basetexture", scr_t)
			mat_w:SetTexture("$basetexture", scr_t)
			render.SetMaterial(black)
			render.DrawScreenQuad()
			local r_n = 10 * f
			local g_n = 10 * f * 5
			local b_n = 2 * f * 5
			local r_r = math.random(-1, 1) * f * 10
			local g_r = math.random(-1, 1) * f * 5
			local b_r = math.random(-1, 1) * f * 15
			render.SetMaterial(mat_r)
			render.DrawScreenQuadEx(-r_n/2, -r_n/2, w + r_n, h + r_n + r_r)
			render.SetMaterial(mat_g)
			render.DrawScreenQuadEx(-g_n/2, -g_n/2, w + g_n, h + g_n + g_r)
			render.SetMaterial(mat_b)
			render.DrawScreenQuadEx(-b_n/2, -b_n/2, w + b_n, h + b_n + b_r)
			DrawBloom(0, f^4, 1, 1, 1, 1, 1, 1, 1)
		end
	end)
	net.Receive("showBugs", function()
		bendtime = CurTime() + 60
	end)
	hook.Add( "HUDPaint", "drawbugs", function()
		if LocalPlayer():Team() == 3 then
			if bendtime > CurTime() then
					for id, bug in pairs( ents.FindByClass("avatar_bug") ) do
						cam.Start2D()
							local pos = bug:GetPos():ToScreen()
							draw.RoundedBox(6, pos.x-30, pos.y-30, 60, 60, Color(0,127,255,127))
							local text = "Сбой симуляции. BrushEntityFailure"
							local i = math.random(0, #text/2)*2-2
							text = text:substring(0, i) .. "/" .. text:substring(i+4, #text)
							draw.SimpleText(text,"bfont",pos.x,pos.y,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
						cam.End2D()
					end
			else
				bendtime = 0
			end
		end
	end )
else
	print("how the")
end
