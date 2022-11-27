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

function tabletlib.show()
	desktop = tabletlib.createDesktop("project_avatar/hud/sc/tablet_wp.png", "project_avatar/hud/sc/tablet.png", ScrW(), ScrH())
    desktop:SetZPos(0)
    tabletlib.Main = desktop
    local _,_, dw, dh = desktop:GetWorkWH()
    rth = dh/2*1.25-20
    rtw = dw-20
    rtview = tabletlib.createDesktopPanel(desktop, rth, rtw, 0, 0)
    rtview:SetZPos(1)
    rt_offset = Vector(0,0,0)
    function rtview:Paint(w, h)
    --[[
        surface.SetDrawColor(255, 255, 255)
        surface.SetMaterial(rt_mat)
        surface.DrawTexturedRect(0, 0, w, h)
        ]]
        if rendercam then
            rt_pos = util.TraceLine( {
                start = Vector(0,0,0),
                endpos = Vector(0,0,10000) * 10000,
                filter = function( ent ) return true end
            } ).HitPos / 2
            local x, y = self:GetPos()
            render.RenderView( {
                origin = rt_pos + rt_offset,
                angles = rt_ang,
                x = x, y = y,
                w = w, h = h,
                aspect = w / h,
                fov = 90
            } )
            cam.Start3D()
                for _, ent in pairs(ents.GetAll()) do
                    --print(ent:GetClass())
                    render.SetColorMaterial()
                    local col
                    if ent:GetClass() == "pa_avatar" then render.SetMaterial( AVATAR )
                    elseif ent:GetClass() == "player" then 
                        if ent:Team() == TEAM_TEST_SUBJECTS then render.SetMaterial( TESTER ) else render.SetMaterial( FIXER ) end
                    elseif ent:GetClass() == "avatar_bug" then col = render.SetMaterial( BUG )
                    else continue end
                    render.DrawSprite( ent:GetPos()+Vector(0,0,100), 120*2, 120*2, Color(255,255,255) )
                    if ent:GetClass() == "avatar_bug" and not ent:GetNWBool("fixing")then
                        render.SetMaterial( QTE )
                        render.DrawSprite( ent:GetPos()+Vector(600,0,1000), 400*4, 120*4, Color(255,255,255) )
                        if ent:GetNWBool("hasQTE") then
                            local qte = {1,2,1,2,1,2}
                            for i, key in pairs(qte) do
                                if i > pressed then
                                    render.SetMaterial( keysmats[key] )
                                    render.DrawSprite( ent:GetPos()+Vector(700,-850 + 240*i,1000), 120*2, 120*2, Color(255,255,255) )
                                else
                                    render.SetMaterial( FIXER )
                                    render.DrawSprite( ent:GetPos()+Vector(700,-850 + 240*i,1000), 120*2, 120*2, Color(255,255,255) )
                                end
                            end
                            if input.IsKeyDown(keys[qte[next or 1]]) then
                                next = (next or 1) + 1
                                pressed = pressed + 1
                                if next >= 7 then
                                    next = nil
                                    pressed = 0
                                    net.Start("fixBug")
                                    net.WriteEntity(ent)
                                    net.SendToServer()
                                end
                            end
                        end
                    end
                end
            cam.End3D()
        end
    end

    terminalpanel = tabletlib.createDesktopPanel(desktop, dh-rth-30, dw/2-10, dw-(dw/2+10), dh-(dh-rth)+10)
    terminalpanel:MakePopup()
    terminalpanel:SetZPos(1)
    function terminalpanel:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(0,0,0,255))
    end
    terminalpanel.entry = vgui.Create( "DTextEntry", desktop )
    --terminalpanel.entry:Dock( BOTTOM )
    --terminalpanel.entry:DockMargin( 0, 5, 0, 0 )
    terminalpanel.entry:SetZPos(2)
    terminalpanel.entry:SetPos(dw-(dw/2+10), dh-(dh-rth)+10)
    terminalpanel.entry:SetSize(dw/2-10, 12)
    terminalpanel.entry:MakePopup()
    terminalpanel.entry:SetPlaceholderText( "Awaiting for input..." )
    terminalpanel.entry.OnEnter = function( self )
        executeCommand(self:GetValue())
    end
    terminalpanel.entry.Paint = function(self, w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(55,55,55))
        draw.DrawText(self:GetValue() or self:GetPlaceholderText(), "Default")
    end

    close = tabletlib.createDesktopIcon(desktop, 64, 0, rth + 10)
    function close:DoClick()
        desktop:Close()
    end
    close:SetText("exit")

    togglecam = tabletlib.createDesktopIcon(desktop, 64, 74, rth + 10)
    function togglecam:DoClick()
        rendercam = not rendercam
    end
    togglecam:SetText("toggle rt")

    local sliderpanel = tabletlib.createDesktopPanel(desktop, 100, 100, 74*2, rth+10)
    sliderpanel:MakePopup()
    local Slider = vgui.Create( "DSlider", sliderpanel )
    Slider:SetPos( 0, 0 )
    Slider:SetSize( 100, 100 )
    function Slider:Paint()
        if not Slider:IsEditing() then 
            Slider:SetSlideX(0.5)
            Slider:SetSlideY(0.5)
        end
        rt_offset.x = rt_offset.x + (0.5-Slider:GetSlideY())*50
        rt_offset.y = rt_offset.y + (0.5-Slider:GetSlideX())*50
    end
    Slider:SetLockX(nil)
    Slider:SetLockY(nil)
end
function tabletlib.hide()
	tabletlib.Main:Close()
	tabletlib.Main = nil
end
function tabletlib.shown()
	return IsValid(tabletlib.Main)
end
--[[
--createWindow(100,100,160*3,90*3,"Example Window",true)
local a = createAlertWindow(100,100,160*3,90*3,"Example Alert Window",true,
	"WARNING! Authorise this action:\nActivate Project Avatar v2 build 58","AUTHORISE ACTION\\as Scientist#9999. Not you? Relogin")

local desktop = createDesktop("project_avatar/hud/sc/tablet_wp.png", "project_avatar/hud/sc/tablet.png", ScrW(), ScrH())
createDesktopIcon(desktop, 32, 0, 0)
]]

net.Receive("RoundEnd", function(_, ply)
	if tabletlib.shown() then
		tabletlib.createLockdown()
	else
		lockdown = true
	end
end)

return tabletlib