hook.Add("PlayerDeath","pa.death",function(ply,swep,attacker)
    ply:SetNWString("deathtimerid",tostring(math.random(100,100000)))
    ply:SetNWBool("deathallowed",false)
    timer.Create("deathtimer_"..ply:GetNWString("deathtimerid",0),60,1,function() -- создаём таймер длиной 1 минуты
        ply:SetNWBool("deathallowed",true) -- при окончании таймера разрешаем игроку возраждаться
    end)
end)

hook.Add("PlayerDeathThink","pa.deaththink",function(ply)
    if timer.Exists("deathtimer_"..ply:GetNWString("deathtimerid",0)) then 
        ply:SetNWInt("deathtimelost",timer.TimeLeft("deathtimer_"..ply:GetNWString("deathtimerid",0))) -- сетаем в NW время до возраждения
    end
    local res = ply:GetNWBool("deathallowed",false)
    if res==true then res=nil end -- если "разрешение возрождатся" == true то мы меняем на nil чтобы игрок мог возрадится(я хз почему так работает)
    return res
end)