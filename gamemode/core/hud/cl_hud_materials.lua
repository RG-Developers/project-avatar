hud_mats = {}

hud_mats.glitcheffect = {}
hud_mats.glitcheffect.black = Material("vgui/black")
hud_mats.glitcheffect.mat_r = CreateMaterial("screffect_r", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[1 0 0]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
hud_mats.glitcheffect.mat_g = CreateMaterial("screffect_g", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[0 1 0]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
hud_mats.glitcheffect.mat_b = CreateMaterial("screffect_b", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[0 0 1]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
hud_mats.glitcheffect.mat_w = CreateMaterial("screffect_w", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[1 1 1]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
hud_mats.glitcheffect.mat_blur = CreateMaterial("screffect_blur", "UnlitGeneric", {
	["$basetexture"] = "vgui/black",
	["$color2"] = "[1 1 1]",
	["$additive"] = 1,
	["$ignorez"] = 1
})
hud_mats.scientist = {}
hud_mats.scientist.base      = Material("project_avatar/hud/sc/doc/doc_base.png")
hud_mats.scientist.doc_1000  = Material("project_avatar/hud/sc/doc/doc_1000.png")
hud_mats.scientist.doc_2000  = Material("project_avatar/hud/sc/doc/doc_2000.png")
hud_mats.scientist.doc_3000  = Material("project_avatar/hud/sc/doc/doc_3000.png")
hud_mats.scientist.sigma     = Material("project_avatar/hud/sc/doc/doc_sigma.png")
hud_mats.scientist.omega     = Material("project_avatar/hud/sc/doc/doc_omega.png")
hud_mats.scientist.mst_base  = Material("project_avatar/hud/sc/mst_base.png")
hud_mats.scientist.task	     = Material("project_avatar/hud/sc/task_pending.png")

hud_mats.testsubj = {}
hud_mats.testsubj.base  = Material("project_avatar/hud/ts/base_bg.png")
hud_mats.testsubj.bar   = Material("project_avatar/hud/ts/bar.png")
hud_mats.testsubj.cam   = Material("project_avatar/hud/ts/action/camera.png")
hud_mats.testsubj.crb   = Material("project_avatar/hud/ts/action/crossbow.png")
hud_mats.testsubj.crw   = Material("project_avatar/hud/ts/action/crowbar.png")
hud_mats.testsubj.tlg   = Material("project_avatar/hud/ts/action/toolgun.png")

hud_mats.fixer = {}
hud_mats.fixer.base = Material("project_avatar/hud/fx/base.png")

return hud_mats