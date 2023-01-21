hud_coroutines = {}

hud_coroutines.coroutines = {}
function hud_coroutines.run_coroutines()
	local i = 1
	while i <= #hud_coroutines.coroutines do
		_, fade = coroutine.resume(hud_coroutines.coroutines[i])
		if coroutine.status(hud_coroutines.coroutines[i]) == "dead" then
			table.remove(hud_coroutines.coroutines, i)
			fade = 0
		else
			i = i + 1
		end
	end
end

return hud_coroutines