hud = {}

hud.oldhp = nil
hud.oldoldhp = nil


function hud.draw(ply, hp, maxhp, name, class, subclass, fade,
				  hud_materials, hud_variables, hud_coroutines, hud_sounds)
	assault = GetGlobalInt("FixersCount") > 0 or false
	--local tst_cam = hud_materials.testsubj.cam
	--local tst_crb = hud_materials.testsubj.crb
	--local tst_crw = hud_materials.testsubj.crw
	--local tst_tlg = hud_materials.testsubj.tlg

	local x = hud_variables.HUDPosition["XPos"]
	local y = hud_variables.HUDPosition["YPos"]
	local subclasses = {"<INTERNAL>", "Garry", "Circle", "Newguy", "Kratos"}
	local coroutines = hud_coroutines.coroutines
	local crsound = hud_sounds.crsound
	local falsound = hud_sounds.falsound
	local oassault = hud.oassault
	local fontsize = 26 * hud_variables.HUDPosition["FontScale"]

	if not hud.oldhp then hud.oldhp = hp end
	if not hud.oldoldhp then hud.oldoldhp = hp end
	if hud.oassault == nil then hud.oassault = assault end


	draw.RoundedBox( 0, x+64, y+74, ((((105-hp-math.floor((CurTime())%5)) - 0) * 300/2) / 100), 71/2, Color(235/2, 89/2, 0, 255) )
	draw.RoundedBox( 0, x+64, y+74, ((((105-hp-math.floor((CurTime()*25)%5)) - 0) * 300/2) / 100), 71/2, Color(235, 89, 0, 255) )
	draw.WordBox( 8, x+64+(310/2)/2, y+74+37, ""..105-hp, "bfont", Color(0, 0, 0, 0), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
	--base
	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(hud_materials.testsubj.base)
	surface.DrawTexturedRect(x, y, 460/2, 230/2)
	--text
	draw.DrawText( name, "bfont", x+55+(310/2)/2-10-50, y+8, Color( 255, 255, 255, 255 ) )
	draw.DrawText( subclasses[subclass+1], "bfont", x+55+(310/2)/2-50, y+26+8, Color( 255, 255, 255, 255 ) )
	hud_coroutines.run_coroutines()
	-- assault bar
	if not oassault == assault then
		oassault = assault
		if not assault then
			falsound:Stop()
		end
	end
	if assault then
		if not falsound:IsPlaying() or falsound_end < RealTime() then
			falsound:Stop()
			falsound:Play()
			falsound_end = RealTime() + 45
		end
		local offset = 50
		local ah = 20
		local aw = 200
		local text = "FIXERS ASSAULT IN PROGRESS"
		local text = text .. "   ///   "
		local text = text .. text
		draw.RoundedBox(0, offset, offset, aw, ah, Color(255, 100, 0, 55+50*(math.sin(RealTime()*10))+1))
		draw.RoundedBox(0, offset, offset, 2, 10, Color(255, 100, 0)) draw.RoundedBox(0, offset, offset, 10, 2, Color(255, 100, 0))
		draw.RoundedBox(0, offset+aw-2, offset, 2, 10, Color(255, 100, 0)) draw.RoundedBox(0, offset+aw-10, offset, 10, 2, Color(255, 100, 0))
		draw.RoundedBox(0, offset, offset+ah-10, 2, 10, Color(255, 100, 0)) draw.RoundedBox(0, offset, offset+ah-2, 10, 2, Color(255, 100, 0))
		draw.RoundedBox(0, offset+aw-2, offset+ah-10, 2, 10, Color(255, 100, 0)) draw.RoundedBox(0, offset+aw-10, offset+ah-2, 10, 2, Color(255, 100, 0))
		render.SetStencilWriteMask( 0xFF ) render.SetStencilTestMask( 0xFF )
		render.SetStencilReferenceValue( 0 ) render.SetStencilCompareFunction( STENCIL_ALWAYS )
		render.SetStencilPassOperation( STENCIL_KEEP ) render.SetStencilFailOperation( STENCIL_KEEP )
		render.SetStencilZFailOperation( STENCIL_KEEP ) render.ClearStencil()
		render.SetStencilEnable( true ) render.SetStencilReferenceValue( 1 ) 
		render.SetStencilCompareFunction( STENCIL_EQUAL ) render.ClearStencilBufferRectangle( offset, offset, aw+offset, ah+offset, 1 )
		--draw.RoundedBox(0, offset, offset, aw+ah, ah+ah, Color(255,255,255, 255))
		draw.DrawText(text, "bfont", RealTime()*150%(select(1, surface.GetTextSize(text))), offset+ah/2-fontsize/2, Color(255,155,0,255))
		draw.DrawText(text, "bfont", -(select(1, surface.GetTextSize(text)))+RealTime()*150%(select(1, surface.GetTextSize(text))), offset+ah/2-fontsize/2, Color(255,155,0,255))
		render.SetStencilEnable( false )
	end

	--if 60 < hp then return end
	if hp == hud.oldhp then return end
	if hp > hud.oldhp then
		hud.oldhp = hp
		coroutines = {}
		fade = 0
		if crsound:IsPlaying() then
			crsound:Stop()
			RunConsoleCommand("-forward")
			RunConsoleCommand("-moveright")
			RunConsoleCommand("-moveleft")
			RunConsoleCommand("-back")
		end
		return
	end

	errors = math.floor((hud.oldhp - hp) / 5)
	hud.oldhp = hp
	if hp < 1 then
		deathcoro = coroutine.create(function(starttime) 
			local lineoffset = 0
			local linescount = 100
			local passed = 0
			local header = "Disconnected"
			local info = "Timed out"
			local hp = 0
			while hp < 1 do
				hp = LocalPlayer():Health()
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
					draw.SimpleText(math.floor(LocalPlayer():GetNWInt("deathtimelost",0)), "bfont", ((ScrW()/2) - select(1, surface.GetTextSize( info )) / 2)+35, ScrH()/2-71/2+55, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
				end

				coroutine.yield(1)
			end
			coroutine.yield()
		end)
		coroutines[#coroutines+1] = deathcoro
		coroutine.resume(deathcoro, CurTime())
		return
	end
	if errors < 1 then return end
	if hp > 5 then
		--consec-to-player failures
		for i=0, errors-1, 1 do
			header = "!!ConsecToPlayer Failure!!"
			alist = {'move', 'visual', 'sound'}
			affects = alist[math.random(1, #alist)]
			if affects == 'move' then
				info = "MOTORICAL SYSTEM FAILURE"
			elseif affects == 'visual' then
				info = "VIDEO ENCODER FAILURE"
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
						local mrand = math.random(0, 3)
						RunConsoleCommand("-forward")
						RunConsoleCommand("-moveright")
						RunConsoleCommand("-moveleft")
						RunConsoleCommand("-back")
						if mrand == 0 then
							RunConsoleCommand("+forward")
						elseif mrand == 1 then
							RunConsoleCommand("+moveright")
						elseif mrand == 2 then
							RunConsoleCommand("+moveleft")
						else
							RunConsoleCommand("+back")
						end
					elseif affects == 'visual' then
						draw.RoundedBox(0, math.random(0, ScrW()-50), math.random(0, ScrH()-50), 50, 50, Color(0,0,0))
						draw.RoundedBox(0, math.random(0, ScrW()-50), math.random(0, ScrH()-50), 50, 50, Color(0,0,0))
						draw.RoundedBox(0, math.random(0, ScrW()-50), math.random(0, ScrH()-50), 50, 50, Color(0,0,0))
						draw.RoundedBox(0, math.random(0, ScrW()-50), math.random(0, ScrH()-50), 50, 50, Color(0,0,0))
						draw.RoundedBox(0, math.random(0, ScrW()-50), math.random(0, ScrH()-50), 50, 50, Color(0,0,0))
					elseif affects == 'sound' then
						surface.PlaySound("/project_avatar/damage/soundprocfail.wav")
					end
					draw.RoundedBox( 0, dx, dy, 
						ScrW()*0.25, ScrH()*0.15, 
						Color(255, 0, 0, 127 * (((CurTime() % 0.2) > 0.10) and 1 or 0)) 
					)
					draw.SimpleText(header, "bfont", dx+(ScrW()*0.25/2), dy+(ScrH()*0.15/2)-30, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					draw.SimpleText(info, "bfont", dx+(ScrW()*0.25/2), dy+(ScrH()*0.15/2), Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					draw.SimpleText("Error num " .. errorn, "bfont", dx+(ScrW()*0.25/2), dy+(ScrH()*0.15/2)+30, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
					coroutine.yield((((endtime - CurTime()) / (endtime - starttime)) / 2))
				end
				coroutine.yield(0)
				if affects == 'move' then
					RunConsoleCommand("-forward")
					RunConsoleCommand("-moveright")
					RunConsoleCommand("-moveleft")
					RunConsoleCommand("-back")
				end
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
				statcrit = "!! STATE CRITICAL !!"
				distime = "DISCONNECT IN T-"..seconds.." SECONDS"

				largest = math.max(select(1, surface.GetTextSize( statcrit )), select(1, surface.GetTextSize( distime )))

				draw.RoundedBox( 0, dx-(largest*1.2)/2, dy-10, 
					largest*1.2, 80, 
					Color(255, 0, 0, 127 * (((CurTime() % 0.2) > 0.10) and 1 or 0)) 
				)
				if left < 20 then
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
				end
				if left < 10 then
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
					draw.RoundedBox(0, math.random(0, ScrW()-10), math.random(0, ScrH()-10), 10, 10, Color(0,0,0))
				end
				if left < 5 then
					local mrand = math.random(0, 3)
					RunConsoleCommand("-forward")
					RunConsoleCommand("-moveright")
					RunConsoleCommand("-moveleft")
					RunConsoleCommand("-back")
					if mrand == 0 then
						RunConsoleCommand("+forward")
					elseif mrand == 1 then
						RunConsoleCommand("+moveright")
					elseif mrand == 2 then
						RunConsoleCommand("+moveleft")
					else
						RunConsoleCommand("+back")
					end
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
end
return hud