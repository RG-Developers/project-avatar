
if SERVER then
	filter = RecipientFilter()
	filter:AddAllPlayers()
elseif CLIENT then

	coroutines = {}

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
	local mat = CreateMaterial("screffect_blur", "UnlitGeneric", {
		["$basetexture"] = "vgui/black",
		["$color2"] = "[1 1 1]",
		["$additive"] = 1,
		["$ignorez"] = 1
	})

	fade = 0

	local function handlecoros()
		local i = 1
		while i <= #coroutines do
			_, fade = coroutine.resume(coroutines[i])
			if coroutine.status(coroutines[i]) == "dead" then
				table.remove(coroutines, i)
				fade = 0
			else
				i = i + 1
			end
		end
	end


	if pcall(function () crsound = CreateSound(game.GetWorld(), "/project_avatar/damage/statuscritical.wav", filter) end) then
		crsound = CreateSound(game.GetWorld(), "/project_avatar/damage/statuscritical.wav", filter)
	else
		hook.Add('InitPostEntity', 'postinit', function()
			crsound = CreateSound(game.GetWorld(), "/project_avatar/damage/statuscritical.wav", filter)
		end)
	end

	local function HUDHide ( avatarhud )
		for k, v in pairs{ 'CHudHealth', 'CHudBattery', 'CHudDamageIndicator' } do
			if avatarhud == v then return false end
		end
	end
	hook.Add('HUDShouldDraw', 'HUDHide', HUDHide)
	consectrace = {""}

	--xy hud position
	local x = 20
	local y = ScrH() - 150
	local off = 0
	--fixer id and rank
	local fixid = math.random(1000, 9999)
	local fixrank = "Senior leutenant"
	--precaching materials : scientist hud materials
	local scn_doc_base  = Material("project_avatar/hud/sc/doc_base.png")
	local scn_doc_1000  = Material("project_avatar/hud/sc/doc_1000.png")
	local scn_doc_2000  = Material("project_avatar/hud/sc/doc_2000.png")
	local scn_doc_3000  = Material("project_avatar/hud/sc/doc_3000.png")
	local scn_doc_sigma = Material("project_avatar/hud/sc/doc_sigma.png")
	local scn_doc_omega = Material("project_avatar/hud/sc/doc_omega.png")
	local scn_mst_base  = Material("project_avatar/hud/sc/mst_base.png")
	local scn_task	    = Material("project_avatar/hud/sc/task_pending.png")
	local scn_scor_bar	= Material("project_avatar/hud/sc/score_bar.png")
	local scn_scor_base	= Material("project_avatar/hud/sc/score_base.png")
	--precaching materials : tester hud materials
	local tst_base  = Material("project_avatar/hud/ts/base_bg.png")
	local tst_bar   = Material("project_avatar/hud/ts/bar.png")
	local tst_cam   = Material("project_avatar/hud/ts/camera.png")
	local tst_crb   = Material("project_avatar/hud/ts/crossbow.png")
	local tst_crw   = Material("project_avatar/hud/ts/crowbar.png")
	local tst_tlg   = Material("project_avatar/hud/ts/toolgun.png")
	--precaching materials : avatar hud materials
	local ava_base       = Material("project_avatar/hud/av/base.png")
	local ava_eye        = Material("project_avatar/hud/av/eye.png")
	local ava_eye_shot   = Material("project_avatar/hud/av/eye_glow.png")
	--precaching materials : fixer hud materials
	local fix_base       = Material("project_avatar/hud/fx/base.png")
	--register font
	surface.CreateFont( "bfont", {
		font = "Bebas Neue Cyrillic",
		extended = false,
		size = 26,
		weight = 500})
	--and some vars
	subclasses = {"<INTERNAL>", "Garry", "Circle", "Newguy", "Kratos"}
	local bendtime = 0
	local bugs = {}

	surface.SetFont('bfont')

	local function hud()
	-- vars
		local ply = LocalPlayer()
		local hp = ply:Health() or 0
		local maxhp = ply:GetMaxHealth() or 0
		local name = ply:Nick()
		local class = ply:Team()
		local subclass = GetSubClass(ply)
		if not oldhp then
			oldhp = hp
		end
		if not oldoldhp then
			oldoldhp = hp
		end
		-- constructing hud
		if class == TEAM_SCIENTISTS then -- scientists	
			score = GetGlobalInt("ScientistsScore") or 1
			--doctype
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(scn_doc_base)
			surface.DrawTexturedRect(x, 20, 222/2, 90/2)
			lvl, let = GetScientistDoctype(ply)
			if lvl == 2 then
				surface.SetMaterial(scn_doc_2000)
				surface.DrawTexturedRect(x, 20, 222/2, 90/2)
			elseif lvl == 3 then
				surface.SetMaterial(scn_doc_3000)
				surface.DrawTexturedRect(x, 20, 222/2, 90/2)
			else
				surface.SetMaterial(scn_doc_1000)
				surface.DrawTexturedRect(x, 20, 222/2, 90/2)
			end
			if let == "o" then
				surface.SetMaterial(scn_doc_omega)
				surface.DrawTexturedRect(x, 20, 222/2, 90/2)
			else
				surface.SetMaterial(scn_doc_sigma)
				surface.DrawTexturedRect(x, 20, 222/2, 90/2)
			end
			--mistakes
			draw.RoundedBox( 0, x+182/2, y+95, (((GetScientistMistakes(ply) - 0) * 268/2) / 10), 77 / 2, Color(0, 175, 255, 255) )
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(scn_mst_base)
			surface.DrawTexturedRect(x, y+90, 460/2, 97/2)
			--score
			surface.SetDrawColor( color_white )
			surface.SetMaterial( scn_scor_bar )
			surface.DrawTexturedRectUV( 10, ScrH() - 229 - 100, 40, 229 * (score / 1000), 0, 0, 1, 1 * (score / 1000) )
		elseif class == TEAM_FIXERS then
			--integrity bar
			draw.RoundedBox( 0, x+103, y-50+74+33, ((hp * 300/1.57) / 100), 74/2, Color(66, 66, 66, 255) )
			--base
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(fix_base)
			surface.DrawTexturedRect(x, y-50, 460/1.5, 230/1.5)
			draw.WordBox( 8, x+64, y-50+74+80, ""..hp.."%", "bfont", Color(0, 0, 0, 0), Color(66, 66, 66, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			--text
			draw.DrawText( name, "bfont", x+85+(310/2)/2-10-50, y-50+12, Color( 255, 255, 255, 255 ) )
			draw.DrawText( fixid, "bfont", x+85+(310/2)/2-10-50, y-50+12+20, Color( 255, 255, 255, 255 ) )
			draw.DrawText( fixrank, "bfont", x+85+(310/2)/2-10-50, y-50+12+40, Color( 255, 255, 255, 255 ) )
			draw.DrawText("Consciousness trace: ", "bfont", 10, 10, Color( 255, 255, 255, 255 ) )
			local y = 10
			if #consectrace[1] > 17 then
				for i=7, 1, -1 do
					consectrace[i+1] = consectrace[i]
				end
				consectrace[1] = ""
			else
				if hp > 0 then consectrace[1] = consectrace[1] .. string.char(math.random(33, 126))
				else consectrace[1] = "CONSCIOUSNESS DEAD" end
			end
			for k, str in pairs(consectrace) do
				y = y + 20
				draw.DrawText(str, "bfont", 10, y, Color( 255, 255, 255, 255 ) )
			end
			--screen bugs
			if hp < 100 then
				fade = (100-hp) / 50
				draw.RoundedBox(0, 0, 0, ScrW(), ScrH(), Color(255,0,0,100-hp/100*200))
				--for i=0, 25-hp/4, 1 do
				--	draw.RoundedBox(0, math.random(0, ScrW()), math.random(0, ScrH()), 160, 90, Color(0,0,0,255))
				--end
			else
				fade = 0
			end
		elseif class == TEAM_TESTSUBJECTS or class == TEAM_TESTSUBJECTS_BOOSTED then -- testsubjects
			--ping bar
			draw.RoundedBox( 0, x+64, y+74, ((((105-hp-math.floor((CurTime())%5)) - 0) * 300/2) / 100), 71/2, Color(235/2, 89/2, 0, 255) )
			draw.RoundedBox( 0, x+64, y+74, ((((105-hp-math.floor((CurTime()*25)%5)) - 0) * 300/2) / 100), 71/2, Color(235, 89, 0, 255) )
			draw.WordBox( 8, x+64+(310/2)/2, y+74+37, ""..105-hp, "bfont", Color(0, 0, 0, 0), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
			--base
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(tst_base)
			surface.DrawTexturedRect(x, y, 460/2, 230/2)
			--text
			draw.DrawText( name, "bfont", x+55+(310/2)/2-10-50, y+8, Color( 255, 255, 255, 255 ) )
			draw.DrawText( subclasses[subclass+1], "bfont", x+55+(310/2)/2-50, y+26+8, Color( 255, 255, 255, 255 ) )
			handlecoros()
			--if 60 < hp then return end
			if hp == oldhp then return end
			if hp > oldhp then
				oldhp = hp
				coroutines = {}
				fade = 0
				crsound:Stop()
				return
			end
			errors = math.floor((oldhp - hp) / 5)
			oldhp = hp
			if errors < 1 then return end
			if hp < 1 then
				deathcoro = coroutine.create(function(starttime) 
					local lineoffset = 0
					local linescount = 100
					local passed = 0
					local header = "Disconnected"
					local info = "Timed out"
					while hp < 1 do
						for i = 0 - lineoffset, ScrH(), ScrH()/linescount do
							surface.DrawLine(0, i, ScrW(), i)
						end
						lineoffset = lineoffset + 1
						lineoffset = lineoffset % (ScrH() / linescount)
						passed = CurTime() - starttime

						largest = math.max(select(1, surface.GetTextSize( header )), select(1, surface.GetTextSize( info )))+20

						if passed > 2 then
							draw.RoundedBox( 0, ScrW()/2-largest/2, ScrH()/2-71/2, largest, 71, Color(0, 0, 0, 255 ))
							draw.DrawText(header, "bfont", (ScrW()/2) - select(1, surface.GetTextSize( header )) / 2 , ScrH()/2-71/2, Color( 255, 255, 255, 255 ) )
							draw.DrawText(info, "bfont", (ScrW()/2) - select(1, surface.GetTextSize( info )) / 2, ScrH()/2-71/2+20, Color( 255, 255, 255, 255 ) )
						end

						coroutine.yield(1)
					end
					coroutine.yield()
				end)
				coroutines[#coroutines+1] = deathcoro
				coroutine.resume(deathcoro, CurTime())
			elseif hp > 5 then
				--consec-to-player failures
				for i=0, errors-1, 1 do
					header = "!!ConsecToPlayer Failure!!"
					alist = {'move', 'visual', 'sound'}
					affects = alist[math.random(1, #alist)]
					if affects == 'move' then
						info = "MOTORICAL SYSTEM FAILURE"
					elseif affects == 'visual' then
						info = "VISUAL CONTROLLER FAILURE"
					elseif affects == 'sound' then
						info = "AUDIO PARSER FAILURE"
					end
					errorn = "#" .. string.format("%x", math.random(0, 65535))
					endtime = CurTime() + 5
					coro = coroutine.create(function(header, info, affects, errorn, endtime, starttime)
						local errx = math.random(0, ScrW()-(ScrW()*0.25))
						local erry = math.random(0, ScrH()-(ScrH()*0.15))
						while CurTime() < endtime do
							local dx = errx+math.random(-5, 5)
							local dy = erry+math.random(-5, 5)
							if affects == 'move' then
								RunConsoleCommand("-forward")
								RunConsoleCommand("-moveright")
								RunConsoleCommand("-moveleft")
								RunConsoleCommand("-back")
							elseif affects == 'visual' then
								--bugs effect
							elseif affects == 'sound' then
								RunConsoleCommand("stopsound")
							end
							draw.RoundedBox( 0, dx, dy, 
								ScrW()*0.25, ScrH()*0.15, 
								Color(255, 0, 0, 127 * (((CurTime() % 0.2) > 0.10) and 1 or 0)) 
							)
							draw.DrawText(header, "bfont", dx, dy, Color( 255, 255, 255, 255 ) )
							draw.DrawText(info, "bfont", dx, dy+30, Color( 255, 255, 255, 255 ) )
							draw.DrawText("Error num " .. errorn, "bfont", dx, dy+60, Color( 255, 255, 255, 255 ) )
							coroutine.yield((((endtime - CurTime()) / (endtime - starttime)) / 2))
						end
						if affects == 'visual' then
							--bugs effect
						elseif affects == 'sound' then
							RunConsoleCommand("stopsound")
						end
						coroutine.yield(0)
					end)
					coroutines[#coroutines+1] = coro
					coroutine.resume(coro, header, info, affects, errorn, endtime, CurTime())
				end
			else
				critcoro = coroutine.create(function(endtime)
					local errx = math.random(0, ScrW()-(ScrW()*0.25))
					local erry = math.random(0, ScrH()-(ScrH()*0.15))
					crsound:Stop()
					crsound:SetSoundLevel( -50 )
					crsound:Play()
					local seconds
					local left
					local t
					local statcrit
					local distime
					while CurTime() < endtime do
						t = (1 - (endtime-CurTime()) / 30) * 5
						local dx = errx+math.random(-t, t)
						local dy = erry+math.random(-t, t)

						left = math.ceil(endtime - CurTime())
						if left < 10 then
							seconds = "0"..left
						else
							seconds = left
						end
						statcrit = "!!STATE CRITICAL!!"
						distime = "DISCONNECT IN T-"..seconds.." SECONDS"

						largest = math.max(select(1, surface.GetTextSize( statcrit )), select(1, surface.GetTextSize( distime )))

						draw.RoundedBox( 0, dx-(largest*1.2)/2, dy-10, 
							largest*1.2, 80, 
							Color(255, 0, 0, 127 * (((CurTime() % 0.2) > 0.10) and 1 or 0)) 
						)
						if left < 20 then

						end
						if left < 10 then

						end
						if left < 5 then

						end

						draw.DrawText(statcrit, "bfont", dx-select(1, surface.GetTextSize( statcrit )) / 2, dy, Color( 255, 255, 255, 255 ) )
						draw.DrawText(distime, "bfont", dx-select(1, surface.GetTextSize( distime )) / 2, dy+30, Color( 255, 255, 255, 255 ) )
						coroutine.yield((1 - (endtime-CurTime()) / 30))
					end
					net.Start("Disconnect") 
					net.SendToServer()
					coroutine.yield(1)
				end)
				coroutines[#coroutines+1] = critcoro
				coroutine.resume(critcoro, CurTime()+28)
			end
		elseif class == TEAM_AVATAR then -- avatar
			--base
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(ava_base)
			surface.DrawTexturedRect(x, y, 555/2, 238/2)
		end
		off = off + 0.5
		off = off % 5
	end
	hook.Add( "HUDPaint", "DrawHUD", hud )
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
	net.Receive("updateBugs", function()
		bugs = net.ReadTable()
	end)
	hook.Add( "HUDPaint", "drawbugs", function()
		if LocalPlayer():Team() == 3 then
			if bendtime > CurTime() then
					for id, bug in pairs( bugs ) do
						if bug['bug'] ~= nil then
							cam.Start2D()
								local pos = bug["bug"]:GetPos():ToScreen()
								draw.RoundedBox(6, pos.x-30, pos.y-30, 60, 60, Color(0,127,255,127))
								draw.SimpleText("Сбой симуляции. BrushEntityFailure","bfont",pos.x,pos.y,Color(255,255,255,255),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
							cam.End2D()
						end
					end
			else
				bendtime = 0
			end
		end
	end )
else
	print("how")
end
