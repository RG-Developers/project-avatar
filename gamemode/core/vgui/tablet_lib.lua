local tabletlib = {}
local lockdown = false

function tabletlib.createWindow(x, y, w, h, title, draggable, color, text)
	local window = vgui.Create("DFrame")
	window:SetDraggable(draggable or true)
	window:SetSize(w or 160, h or 90)
	--window:SetSizeable(false)
	window:SetPos(x, y)
	window:SetTitle(title or "Window")
	window:ShowCloseButton(false)
	window.color = color or Color(55, 55, 55, 255)
	function window:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, self.color)
		draw.RoundedBox(0, 0, 0, w, 22, Color(0, 0, 0, 255))
	end

	window.close = vgui.Create("DButton", window)
	window.close:SetPos(w-22, 0)
	window.close:SetText("X")
	function window.close:DoClick()
		window:Close()
	end
	function window.close:Paint()
		draw.RoundedBox(0, 0, 0, w, h, Color(255,0,0,255))
		draw.DrawText("X", "DermaDefault", 7, 4)
	end
	window.text = vgui.Create("DLabel", window)
	window.text:SetSize(w, h)
	--window.text:SetPos(0,0)
	window.text:SetText(text)
	window.text:SetContentAlignment( 5 )
	window.text:SetColor(Color(255,255,255,255))
	window.text:Center()
	window:MakePopup()
	return window
end

function tabletlib.createAlertWindow(x, y, w, h, title, draggable, text, oktext)
	local window = vgui.Create("DFrame")
	window:SetDraggable(draggable or true)
	window:SetSize(w or 160, h or 90)
	--window:SetSizeable(false)
	window:SetPos(x, y)
	window:SetTitle(title or "Window")
	window:ShowCloseButton(false)
	window.color = color or Color(55, 55, 55, 255)
	function window:Paint(w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(100 + (45/2) * (math.sin(RealTime())+1),0,0,255))
		draw.RoundedBox(0, 0, 0, w, 22, Color(0, 0, 0, 255))
		surface.SetDrawColor(255, 0, 0)
		for i=-70,w+70,1 do
			if i % 50 < 25 then 
				surface.DrawLine(i+(RealTime()*50%50), 53, i+20+(RealTime()*50%50), 33) 
				surface.DrawLine(i+(RealTime()*50%50), h-11, i+20+(RealTime()*50%50), h-33) 
			end
		end
	end

	window.close = vgui.Create("DButton", window)
	window.close:SetPos(w/2-(w/3*2)/2, h-99)
	window.close:SetSize((w/3*2), 44)
	window.close:SetText(string.Explode("\\", oktext)[1])
	window.close:SetTextColor(Color(255,0,0,255))
	function window.close:DoClick()
		window:Close()
	end
	function window.close:Paint()
		draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,255))
	end
	window.close.text = vgui.Create("DLabel", window)
	window.close.text:SetSize((w/3*2),11)
	window.close.text:SetText(string.Explode("\\", oktext)[2])
	window.close.text:SetPos(w/2-(w/3*2)/2, h-55)
	window.close.text:SetColor(Color(255,255,255,255))

	window.text = vgui.Create("DLabel", window)
	window.text:SetSize(w, h-53*2)
	window.text:SetText(text)
	window.text:SetContentAlignment( 5 )
	window.text:SetColor(Color(255,255,255,255))
	window.text:Center()
	window:MakePopup()
	return window
end

function tabletlib.createDesktop(wallpaperpath, tabletpath, w, h)
	local tablet_texture = Material("project_avatar/hud/sc/tablet.png")
	local tablet_wallpaper = Material("project_avatar/hud/sc/tablet_wp.png")
	local Main = vgui.Create( "DFrame")
    Main:SetPos( 0, 0 )
    Main:SetSize( w, h )
    Main:SetTitle( "" )
    Main:ShowCloseButton(false)
    Main:SetDraggable(false) 
    --Main:MakePopup()
    if lockdown then
	    Main.Paint = function(s, w, h)
	    	local scaledwp = w*0.8
			local scaledhp = h*0.8
			local wx = (w-scaledwp)/2
			local wy = (h-scaledhp)/2
	        surface.SetDrawColor(255, 255, 255, 255)
	        surface.SetMaterial(tablet_texture)
	        surface.DrawTexturedRect(0, 0, w, h)
	        surface.SetDrawColor(200 + 55/2*(math.sin(RealTime()*15)+1), 0, 0, 255)
	        surface.SetMaterial(tablet_wallpaper)
	        surface.DrawTexturedRect(wx, wy, scaledwp, scaledhp)
	    end
	else
		Main.Paint = function(s, w, h)
	    	local scaledwp = w*0.8
			local scaledhp = h*0.8
			local wx = (w-scaledwp)/2
			local wy = (h-scaledhp)/2
	        surface.SetDrawColor(255, 255, 255, 255)
	        surface.SetMaterial(tablet_texture)
	        surface.DrawTexturedRect(0, 0, w, h)
	        surface.SetMaterial(tablet_wallpaper)
	        surface.DrawTexturedRect(wx, wy, scaledwp, scaledhp)
	    end
	end
    function Main:GetWorkWH()
    	local _, _, w, h = Main:GetBounds()
    	local scaledwp = w*0.8
		local scaledhp = h*0.8
		local wx = (w-scaledwp)/2
		local wy = (h-scaledhp)/2
		return wx, wy, scaledwp, scaledhp
    end

    if lockdown then
    	createLockdownDesktop(Main)
    end

    return Main
end

function tabletlib.createDesktopIcon(desktop, size, x, y)
	local icon = vgui.Create("DButton", desktop)
	local sx, sy, w, h = desktop:GetWorkWH()
	icon:SetSize(size, size)
	icon:SetPos(sx+10+x, sy+10+y)
	icon:SetText("")
	icon:MakePopup()
	return icon
end

function tabletlib.createDesktopPanel(desktop, pw, ph, x, y)
	local panel = vgui.Create("DPanel", desktop)
	local sx, sy, w, h = desktop:GetWorkWH()
	panel:SetSize(ph, pw)
	panel:SetPos(sx+10+x, sy+10+y)
	return panel
end

function tabletlib.createLockdown(desktop)
	local lpanel = vgui.Create("DPanel", desktop)
	local rpanel = vgui.Create("DPanel", desktop)

	local wx, wy, dw, dh = desktop:GetWorkWH()

	rpanel:SetSize(dw/2-40, 40)
	rpanel:SetPos(dw, dh/2-20)
	rpanel:MakePopup()
	lpanel:SetSize(dw/2-40, 40)
	lpanel:SetPos(-(dw/2-40), dh/2-20)
	lpanel:MakePopup()

	function lpanel:Paint(w, h)
		surface.SetDrawColor(255, 0, 0)
		for i=-70,w+70,1 do
			if i % 50 < 25 then 
				surface.DrawLine(i+(RealTime()*50%50), 40, i+20+(RealTime()*50%50), 20)
				surface.DrawLine(i+(RealTime()*50%50), 0, i+20+(RealTime()*50%50), 20)
			end
		end
	end
	function rpanel:Paint(w, h)
		surface.SetDrawColor(255, 0, 0)
		for i=-70,w+70,1 do
			if i % 50 < 25 then 
				surface.DrawLine(i-(RealTime()*50%50), 20, i+20-(RealTime()*50%50), 40)
				surface.DrawLine(i-(RealTime()*50%50), 20, i+20-(RealTime()*50%50), 0)
			end
		end
	end

	local text = vgui.Create("DLabel", desktop)
	text:SetSize(80,40)
	text:SetPos(wx+dw/2-40, -40)
	text:SetText("LOCKDOWN\nACTIVATED")
	text:SetColor(Color(255,255,255,255))
	text:MakePopup()

	lpanel:MoveTo(wx, dh/2-20, 1, 0, 1, function() 
		lpanel:MoveTo(wx, wy+20, 1, 1, 1, function() 
			createLockdownDesktop(desktop)
			rpanel:Remove()
			text:Remove()
			lpanel:Remove()
		end)
		rpanel:MoveTo(wx+dw-(dw/2-40), wy+20, 1, 1, 1, nil)
		text:MoveTo(wx+dw/2-40, wy+20, 1, 1, 1)
	end)
	rpanel:MoveTo(wx+dw-(dw/2-40), dh/2-20, 1, 0, 1, nil)
	text:MoveTo(wx+dw/2-40, dh/2-20, 1, 0, 1)
end
function createLockdownDesktop(Main)
	lockdown = true
	local wx, wy, dw, dh = Main:GetWorkWH()
    Main.lpanel = vgui.Create("DPanel", Main)
	Main.rpanel = vgui.Create("DPanel", Main)
    Main.rpanel:SetSize(dw/2-40, 40)
	Main.rpanel:SetPos(wx+dw-(dw/2-40), wy+20)
	--Main.rpanel:MakePopup()
	Main.lpanel:SetSize(dw/2-40, 40)
	Main.lpanel:SetPos(wx, wy+20)
	--Main.lpanel:MakePopup()

	function Main.lpanel:Paint(w, h)
		surface.SetDrawColor(255, 0, 0)
		for i=-70,w+70,1 do
			if i % 50 < 25 then 
				surface.DrawLine(i+(RealTime()*50%50), 40, i+20+(RealTime()*50%50), 20)
				surface.DrawLine(i+(RealTime()*50%50), 0, i+20+(RealTime()*50%50), 20)
			end
		end
	end
	function Main.rpanel:Paint(w, h)
		surface.SetDrawColor(255, 0, 0)
		for i=-70,w+70,1 do
			if i % 50 < 25 then 
				surface.DrawLine(i-(RealTime()*50%50), 20, i+20-(RealTime()*50%50), 40)
				surface.DrawLine(i-(RealTime()*50%50), 20, i+20-(RealTime()*50%50), 0)
			end
		end
	end

	Main.ldtext = vgui.Create("DLabel", Main)
	Main.ldtext:SetSize(80,40)
	Main.ldtext:SetPos(wx+dw/2-40, wy+20)
	Main.ldtext:SetText("LOCKDOWN\nACTIVATED")
	Main.ldtext:SetColor(Color(255,255,255,255))

	Main.sstext = vgui.Create("DLabel", Main)
	Main.sstext:SetSize(dw,40)
	Main.sstext:SetPos(wx, wy+60)
	Main.sstext:SetText("")
	function Main.sstext:Paint()
		Main.sstext:SetText("Until server shutdown " .. math.floor(GetGlobalInt("servershut") - CurTime()) .. "seconds")
	end
	Main.sstext:SetColor(Color(255,255,255,255))
	--Main.ldtext:MakePopup()

	Main.ldtext:SetZPos(10)
	Main.sstext:SetZPos(10)
	Main.rpanel:SetZPos(10)
	Main.lpanel:SetZPos(10)
end
--[[
--createWindow(100,100,160*3,90*3,"Example Window",true)
local a = createAlertWindow(100,100,160*3,90*3,"Example Alert Window",true,
	"WARNING! Authorise this action:\nActivate Project Avatar v2 build 58","AUTHORISE ACTION\\as Scientist#9999. Not you? Relogin")

local desktop = createDesktop("project_avatar/hud/sc/tablet_wp.png", "project_avatar/hud/sc/tablet.png", ScrW(), ScrH())
createDesktopIcon(desktop, 32, 0, 0)
]]

return tabletlib