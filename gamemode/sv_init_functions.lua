function SetClass(ply, class, subclass)
	ply:SetTeam(class or 1)
	SetGlobalInt(ply:Name() .. "_subclass", subclass or 0)
end

function SetScientistTask(ply, task)
	net.Start("pa.tasksget")
	net.WriteTable(task) 
	net.Send(ply)
	SetGlobalString(ply:Name().."_task", task["name"])
end

function OnTaskRuined(ply, _)
	SetScientistTask(ply, "none")
	net.Start("TaskRuined")
	net.Send(ply)
	SetScientistMistakes(ply, GetScientstMistakes(ply)+1)
end

function SetScientistDoctype(ply, lvl, let)
	SetGlobalInt(ply:Name() .. "_scindoclvl", lvl or 0)
	SetGlobalString(ply:Name() .. "_scindoclet", let or "s")
end

function SetScientistMistakes(ply, mist)
	SetGlobalInt(ply:Name() .. "_scinmst", mist or 0)
end

function SetAvatarState(state)
	SetGlobalBool("AvatarState", state or false)
end

function PlayerByName(name) 
	for i, ply in pairs(player:GetAll()) do 
		if ply:Name() == name then return ply end 
	end 
	return nil 
end 

