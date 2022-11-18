--SCRAPPED.

local effects = {}

local black = Material("vgui/black")
local mat_r = CreateMaterial("screffect_r", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[1 0 0]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
local mat_g = CreateMaterial("screffect_g", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[0 1 0]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
local mat_b = CreateMaterial("screffect_b", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[0 0 1]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
local mat_w = CreateMaterial("screffect_w", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[1 1 1]",
	["$additive"] = 1,
	["$ignorez"] = 1
})


local f = 0
fade = 0

hook.Add("RenderScreenspaceEffects", "effects", function()
	render.UpdateScreenEffectTexture()

	f = fade
	local w, h = ScrW(), ScrH()

	if f > 0 then
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

concommand.Add("pa_fade_test", function(_,_,args)
	fade = tonumber(args[1])
	print("fading: ", fade)
end)

function effects.setEffect(effect, strength)
	if effect == "glitch" then
		fade = strength
	else
		fade = 0
	end
end
return effects