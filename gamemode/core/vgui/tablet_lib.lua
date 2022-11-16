local tabletlib = {}

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
    Main:MakePopup()
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
    function Main:GetWorkWH()
    	local _, _, w, h = Main:GetBounds()
    	local scaledwp = w*0.8
		local scaledhp = h*0.8
		local wx = (w-scaledwp)/2
		local wy = (h-scaledhp)/2
		return wx, wy, scaledwp, scaledhp
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
	panel:MakePopup()
	return panel
end
--[[
--createWindow(100,100,160*3,90*3,"Example Window",true)
local a = createAlertWindow(100,100,160*3,90*3,"Example Alert Window",true,
	"WARNING! Authorise this action:\nActivate Project Avatar v2 build 58","AUTHORISE ACTION\\as Scientist#9999. Not you? Relogin")

local desktop = createDesktop("project_avatar/hud/sc/tablet_wp.png", "project_avatar/hud/sc/tablet.png", ScrW(), ScrH())
createDesktopIcon(desktop, 32, 0, 0)
]]

return tabletlib