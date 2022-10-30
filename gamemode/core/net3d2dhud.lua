if SERVER then
	util.AddNetworkString("WepSelect")
	util.AddNetworkString("Console")
elseif CLIENT then
	local coroutines = {}
	net.Receive("WepSelect", function() 
		local mode = net.ReadBool()
		if mode then
			local ent = net.ReadEntity()
			coroutines[ent:EntIndex()] = coroutine.create(function(ply, weapon) 
				while true do
					cam.Start2D()
						local pos = bug["bug"]:GetPos():ToScreen()
						draw.SimpleText(weapon, "bfont", pos.x, pox.y)
					cam.End2D()
					coroutine.yield()
				end
			end)
			coroutine.resume(coroutines[ent:EntIndex()], ent, net.ReadString())
		else
			coroutines[ent:EntIndex()] = nil
		end
	end)


	hook.Add("Think", "3D2Dhud", function() 
		for k, coro in pairs(coroutines) do
			if coro == nil then continue end
			coroutine.resume(coro)
			if coroutine.status(coro) == "dead" then coroutines[k] = nil end
		end
	end)
end