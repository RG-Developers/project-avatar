starttime = CurTime() + 1
bugcreatetime = starttime + 1
bugparsers = {}
bugs = {}
bugcount = 0

function removeBug(bug)
	CreateSound(bug, "/project_avatar/bugs/bugfix_"..math.random(1,2)..".wav"):Play()
	bug:Remove()
	bugs[bug]['leak']:Remove()
	bugcount = bugcount - 1
	bugparsers[bug] = nil
end

hook.Add("Think", "Bug_Processor_Tick", function()
	for _, parser in pairs(bugparsers) do
		coroutine.resume(parser)
	end
	if CurTime() > starttime then
		if CurTime() > bugcreatetime then
			bugcreatetime = CurTime() + 1
			if bugcount < GetGlobalInt("TestersCount") then
				if math.random(0, 100) > 0 then
					isspec = math.random(0,5) > 4
					local zpvalid, zmvalid, isinworld = false, false, false
					while (zpvalid and zmvalid and isinworld) == false do
						rx = math.random(minx, maxx)
						ry = math.random(miny, maxy)
						rz = math.random(minz, maxz)
						pos = Vector(rx,ry,rz)
						if isspec then
							zpvalid = util.QuickTrace(pos, Vector(0,0,10000000)).HitWorld
							zmvalid = util.QuickTrace(pos, Vector(0,0,-1000)).HitWorld
						else
							zpvalid = util.QuickTrace(pos, Vector(0,0,100000)).HitWorld
							zmvalid = util.QuickTrace(pos, Vector(0,0,-100)).HitWorld
						end
						isinworld = util.IsInWorld(pos)
						if (zpvalid and zmvalid and isinworld) then
							local bug = ents.Create("prop_physics")
							local leak = ents.Create("hammer_leak_bug")
							bug:SetPos( pos )
							leak:SetPos( pos )
							bug:SetModel("models/hunter/blocks/cube1x1x1.mdl")
							bug:Spawn()
							leak:Spawn()
							bug:SetMoveType(MOVETYPE_NONE)
							if isspec then
								bug:SetColor(Color(255,0,0,255))
							end
							bug:SetMaterial("tools/toolstrigger")
							--SetGlobalInt("BugCount", GetGlobalInt("BugCount") + 1)
							--print("bugs: " .. GetGlobalInt("BugCount"))
							--print(isspec)
							--print(pos)
							player:GetAll()[1]:SetPos(pos)
							bugs[bug] = {}
							bugs[bug]['bug'] = bug
							bugs[bug]['score'] = 2 + 2 * (isspec and 1 or 0)
							bugs[bug]['leak'] = leak
							bugparsers[bug] = coroutine.create( function(entity, time) 
								snd = CreateSound(entity, "/project_avatar/bugs/bugambient.wav")
								while CurTime() < time do
									bugs[entity]['score'] = bugs[entity]['score'] + 0.05
									snd:Play()
									coroutine.yield()
								end
								removeBug(entity)
								CreateSound(bug, "/project_avatar/bugs/bugtimeout.wav"):Play()
							end )
							function bug:OnTakeDamage( dmginfo )
								SetGlobalInt("TestersScore", GetGlobalInt("TestersScore") + math.floor(bugs[entity]['score']))
								SetGlobalInt("ScientistsScore", GetGlobalInt("ScientistsScore") -  math.floor(bugs[entity]['score']))
								CreateSound(entity, "/project_avatar/bugs/playerpickupbug_"..math.random(1,3)..".wav"):Play()
								removeBug(entity)
								print(GetGlobalInt("TestersScore"))
							end
							coroutine.resume(bugparsers[bug], bug, CurTime() + math.random(20, 120))
							CreateSound(bug, "/project_avatar/bugs/bugspawn_"..math.random(1,3)..".wav"):Play()
							bugcount = bugcount + 1
						end
					end
				end
			end
		end
	else
		maxzt = util.QuickTrace(Vector(0,0,0), Vector(0,0,1000000)).HitPos[3]
		minzt = util.QuickTrace(Vector(0,0,0), Vector(0,0,-1000000)).HitPos[3]
		rayz = (maxzt-minzt) / 2
		maxz = util.QuickTrace(Vector(0,0,rayz), Vector(0,0,1000000)).HitPos[3]
		minz = util.QuickTrace(Vector(0,0,rayz), Vector(0,0,-1000000)).HitPos[3]
		rayz = (maxz-minz) / 2
		maxx = util.QuickTrace(Vector(0,0,rayz), Vector(1000000,0,0)).HitPos[1]
		minx = util.QuickTrace(Vector(0,0,rayz), Vector(-1000000,0,0)).HitPos[1]
		maxy = util.QuickTrace(Vector(0,0,rayz), Vector(0,1000000,0)).HitPos[2]
		miny = util.QuickTrace(Vector(0,0,rayz), Vector(0,-1000000,0)).HitPos[2]
	end
end)

hook.Add("PlayerUse", 'CollectBug', function(player, entity) 
	if bugs[entity] then
		SetGlobalInt("TestersScore", GetGlobalInt("TestersScore") + math.floor(bugs[entity]['score']))
		SetGlobalInt("ScientistsScore", GetGlobalInt("ScientistsScore") -  math.floor(bugs[entity]['score']))
		CreateSound(entity, "/project_avatar/bugs/playerpickupbug_"..math.random(1,3)..".wav"):Play()
		removeBug(entity)
		print(GetGlobalInt("TestersScore"))
		return true
	end
end)