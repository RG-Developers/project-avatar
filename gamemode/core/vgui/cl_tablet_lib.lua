local tabletlib = {}
local lockdown = false
local task = {
	["name"] = "", -- Update, fix, scan,   shutd, etc
	["type"] = "", -- avatar, bug, tester, alert, etc
	["iscoop"] = false -- is coop?
}

net.Receive("pa.tasksget",function()
	task = net.ReadTable()
	if IsValid(desktop) then
		local wx, wy, ww, wh = desktop:GetWorkWH()
		if task["type"] ~= "alert" then
			tabletlib.createWindow(wx, wy, 160, 90, "New task", true, Color(55, 55, 55), "new task appeared.")
		else
			tabletlib.createAlertWindow(wx, wy, 160, 90, "New task", true, "new alert task appeared.", "ok\\as myself")
		end
	end
end)

local AVATAR = Material("project_avatar/hud/sc/tablet/avatar.png")
local TESTER = Material("project_avatar/hud/sc/tablet/tester.png")
local FIXER = Material("project_avatar/hud/sc/tablet/fixer.png")
local BUG = Material("project_avatar/hud/sc/tablet/bug.png")
local QTE = Material("project_avatar/hud/sc/tablet/qte.png")
local keysmats = {
    Material("project_avatar/hud/sc/letters/a.png"),
    Material("project_avatar/hud/sc/letters/b.png"),
    Material("project_avatar/hud/sc/letters/c.png"),
    Material("project_avatar/hud/sc/letters/d.png"),
    Material("project_avatar/hud/sc/letters/e.png"),
    Material("project_avatar/hud/sc/letters/f.png"),
    Material("project_avatar/hud/sc/letters/g.png"),
    Material("project_avatar/hud/sc/letters/h.png"),

    Material("project_avatar/hud/sc/letters/q.png"),
    Material("project_avatar/hud/sc/letters/r.png"),
    Material("project_avatar/hud/sc/letters/s.png"),
    Material("project_avatar/hud/sc/letters/t.png"),

    Material("project_avatar/hud/sc/letters/v.png"),
    Material("project_avatar/hud/sc/letters/w.png"),
    Material("project_avatar/hud/sc/letters/x.png"),
    Material("project_avatar/hud/sc/letters/y.png"),
    Material("project_avatar/hud/sc/letters/z.png")
}
local keys = {
    KEY_A,
    KEY_B,
    KEY_C,
    KEY_D,
    KEY_E,
    KEY_F,
    KEY_G,
    KEY_H,

    KEY_Q,
    KEY_R,
    KEY_S,
    KEY_T,

    KEY_V,
    KEY_W,
    KEY_X,
    KEY_Y,
    KEY_Z
}
local rt_mat = CreateMaterial("scientist_cam", "UnlitGeneric", {
    ["$basetexture"] = ""
})

local splashes = {
	"Use 'help' command to get list of commands",
	"Welcome back!"
}

local rt_pos = Vector(0, 0, 0)
local rt_ang = Vector(90, 0, 0)
local tbl = {}
local rendercam = true
local term = {"FractalOS v1.0", 
            splashes[math.random(1, #splashes)],
            "Server is ready to start. Use 'vtstart' command",
            "",
            "Restricted Server Project v1. Connected to 'fractalcorp.gov' with ssh2"}
local actions = {}
local next
local pressed = 0

local scaledw = ScrW()
local scaledh = ScrH()

local scaledwp = ScrW()*0.8
local scaledhp = ScrH()*0.8
local rt_offset = Vector(0,0,0)

local wx = (scaledw-scaledwp)/2
local wy = (scaledh-scaledhp)/2

local function contains (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function PlayerByName(name) for i, ply in pairs(player:GetAll()) do if ply:Name() == name then return ply end end return nil end 
classes = {"None", "Garry", "Circle", "Newguy", "Kratos"}

function tabletlib.createWindow(x, y, w, h, title, draggable, color, text)
	local window = vgui.Create("DFrame", desktop)

	window:SetDraggable(draggable or true)
	window:SetSize(w or 160, h or 90)
	--window:SetSizeable(false)
	window:SetPos(x, y)
	window:SetTitle(title or "Window")
	window:ShowCloseButton(false)
	window.color = color or Color(55, 55, 55, 255)
	window.Paint = function(self, w, h)
		local wx, wy, ww, wh = desktop:GetWorkWH()
		local sx, sy = self:GetPos()
		self:SetPos(math.Clamp(sx, wx, wx+ww-w), math.Clamp(sy, wy, wy+wh-h))

		draw.RoundedBox(0, 0, 0, w, h, self.color)
		draw.RoundedBox(0, 0, 0, w, 22, Color(0, 0, 0, 255))
	end

	window.close = vgui.Create("DButton", window)
	window.close:SetPos(w-22, 0)
	window.close:SetText("X")
	window.close.DoClick = function()
		window:Close()
	end
	window.close.Paint = function()
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
	local window = vgui.Create("DFrame", desktop)
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
	local tablet_texture = Material(tabletpath)
	local tablet_wallpaper = Material(wallpaperpath)
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

function tabletlib.createDesktopPanel(type, desktop, pw, ph, x, y)
	local panel = vgui.Create(type, desktop)
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
	desktop = tabletlib.createDesktop("project_avatar/hud/sc/tablet/tablet_wp.png", "project_avatar/hud/sc/tablet/tablet.png", ScrW(), ScrH())
    desktop:SetZPos(0)
	tabletlib.Main = desktop
	--    х у  шр  вс
    local _,_, dw, dh = desktop:GetWorkWH()
    rth = dh/2*1.25-20
    rtw = dw-20
    rtview = tabletlib.createDesktopPanel("DPanel", desktop, rth, rtw, 0, 0)
    rtview:SetZPos(1)
    rt_offset = Vector(0,0,0)
    rt_rot = Angle(90, 0, 0)
    rt_pos_z = 0
    function rtview:Paint(w, h)
        if not rendercam then 
        	draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0))
        	draw.DrawText("No signal from RTCAM_0", "Default")
        	return
        end
        rt_pos = Vector(rt_offset.x, 
        				rt_offset.y, 
        				rt_offset.z)
        local x, y = self:GetPos()
        render.RenderView( {
            origin = rt_pos,
            angles = rt_rot,
            x = x, y = y,
            w = w, h = h,
            aspect = w / h,
            fov = 90
        } )

        cam.Start3D()
            for _, ent in pairs(ents.GetAll()) do
                --print(ent:GetClass())
                if ent:GetClass() == "pa_avatar" then render.SetMaterial( AVATAR )
                elseif ent:GetClass() == "player" then 
                    if ent:Team() == TEAM_TESTSUBJECTS or ent:Team() == TEAM_TESTSUBJECTS_BOOSTED then render.SetMaterial( TESTER ) else render.SetMaterial( FIXER ) end
                elseif ent:GetClass() == "pa_bug" then col = render.SetMaterial( BUG )
                elseif ent:GetClass() == "npc_combine_s" then render.SetMaterial( FIXER ) 
                else continue end
                local ep = ent:GetPos()+ent:OBBCenter()
                render.DrawSprite( ep, 120, 120, Color(255,255,255) )
                if ent:GetClass() == "player" and (ent:Team() == TEAM_TESTSUBJECTS or 
                	ent:Team() == TEAM_TESTSUBJECTS_BOOSTED or ent:Team() == TEAM_FIXERS) then
                	render.SetColorMaterial()
                	render.DrawBeam(ep, rt_pos-Vector(0,0,100), 5, 0, 1, Color(255,255,255))
                end
                if ent:GetClass() == "pa_bug" and not ent:GetNWBool("QTEdone") and ent:GetNWBool("hasQTE") then
                    render.SetMaterial( QTE )
                    local qtev = ent:GetPos()+ent:OBBCenter()+Vector(600,0,1000)
                    --render.DrawSprite( qtev, 400*4, 120*4, Color(255,255,255) )
                    local qte = {ent:GetNWInt("qte1"),
                    			ent:GetNWInt("qte2"),
                    			ent:GetNWInt("qte3"),
                    			ent:GetNWInt("qte4"),
                    			ent:GetNWInt("qte5"),
                    			ent:GetNWInt("qte6")}
                    for i, key in pairs(qte) do
                        if 7-i > pressed then
                            render.SetMaterial( keysmats[key] )
                            render.DrawSprite( ent:GetPos()+Vector(0,-(120*3) + 120*i,100), 120, 120, Color(255,255,255) )
                        else
                            render.SetMaterial( FIXER )
                            render.DrawSprite( ent:GetPos()+Vector(0,-(120*3) + 120*i,100), 120, 120, Color(255,255,255) )
                        end
                    end
                    if input.IsKeyDown(keys[qte[7-(next or 1)]]) then
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
        cam.End3D()
        local rt_pos_t = "X" .. math.floor(rt_pos.x) .. " Y" .. math.floor(rt_pos.y) .. " Z" .. math.floor(rt_pos.z)
        local rt_rot_t = "P" .. math.floor(rt_rot.p) .. " Y" .. math.floor(rt_rot.y)
        draw.DrawText("From RTCAM_0...\n\nPos: " .. rt_pos_t .. "\nAngle:" .. rt_rot_t , "Default")
    end

    terminalpanel = tabletlib.createDesktopPanel("DPanel", desktop, dh-rth-30, dw/2-10, 
    																dw-(dw/2+10), dh-(dh-rth)+10)
    terminalpanel:SetZPos(1)
    function terminalpanel:Paint(w, h)
        draw.RoundedBox(5, 0, 0, w, h, Color(0,0,0,255))
        for lineNum = 1,  math.Clamp(#term, 0, 50) do
            draw.DrawText(term[#term-lineNum+1], "Default", 0, h-15-(12*lineNum), Color(240, 240, 240))
        end
    end
    terminalpanel.entry = tabletlib.createDesktopPanel("DTextEntry", desktop, 15, dw/2-10, dw-(dw/2+10), 
    																			  dh-(dh-rth)+10+dh-rth-45)
    --terminalpanel.entry:DockMargin( 0, 5, 0, 0 )
    terminalpanel.entry:SetZPos(2)
    --terminalpanel.entry:Dock( BOTTOM )
    terminalpanel.entry:MakePopup()
    terminalpanel.entry.OnEnter = function( self )
        tabletlib.executeCommand(self:GetValue())
        self:SetText("")
    end
    terminalpanel.entry.Paint = function(self, w, h)
		if not self:HasFocus() then
			draw.RoundedBox(5, 0, 0, w, h, Color(155,155,155))
		end
        draw.DrawText("[global@fractalos ~]$ " .. self:GetValue(), "Default")
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

    local sliderpanel = tabletlib.createDesktopPanel("DPanel", desktop, 100, 230, 74*2, rth+10)
    sliderpanel:MakePopup()
    function sliderpanel:Paint() end
    local SliderM = vgui.Create( "DSlider", sliderpanel )
    SliderM:SetPos( 0, 0 )
    SliderM:SetSize( 10, 100 )
    function SliderM:Paint(w, h)
    	draw.RoundedBox(10, 0, 0, w, h, Color(0,255 * (SliderM:IsEditing() and 1 or 0),0))
        if not SliderM:IsEditing() then
            SliderM:SetSlideY(0.5)
        end
        rt_offset.x = rt_offset.x + rt_rot:Forward().x*(0.5-SliderM:GetSlideY())*50
        rt_offset.y = rt_offset.y + rt_rot:Forward().y*(0.5-SliderM:GetSlideY())*50
        rt_offset.z = rt_offset.z + rt_rot:Forward().z*(0.5-SliderM:GetSlideY())*50
    end
    SliderM:SetLockX(0.5)
    SliderM:SetLockY(nil)

    local SliderPY = vgui.Create( "DSlider", sliderpanel )
    SliderPY:SetPos( 20, 0 )
    SliderPY:SetSize( 100, 100 )
    function SliderPY:Paint(w, h)
    	draw.RoundedBox(10, 0, 0, w, h, Color(0,255 * (SliderPY:IsEditing() and 1 or 0),0))
    	if not SliderPY:IsEditing() then
            SliderPY:SetSlideY(0.5)
            SliderPY:SetSlideX(0.5)
        end
        rt_rot.p = math.Clamp(rt_rot.p - (0.5-SliderPY:GetSlideY())*5, -90, 90)
        rt_rot.y = (rt_rot.y + (0.5-SliderPY:GetSlideX())*5) % 360
    end
    SliderPY:SetLockX(nil)
    SliderPY:SetLockY(nil)

end
function tabletlib.hide()
	tabletlib.Main:Close()
	tabletlib.Main = nil
end
function tabletlib.shown()
	return IsValid(tabletlib.Main)
end

function tprint(string)
	term[#term+1] = string
end

function toverride(nterm)
	term = nterm
end

commands = {}

function tabletlib.registercmd(name, args, callable, desc)
	argsm = {}
	if args[1] == "*" then
		commands[name] = {{-2}, callable, desc}
		return
	end
	for k, v in pairs(args) do
		if v == "..." then
			argsm[#argsm+1] = -1
			commands[name] = {argsm, callable, desc}
			return
		end
		argsm[#argsm+1] = k
	end
	commands[name] = {argsm, callable, desc}
end

function table.tostring(tbl)
    local result = ""
    local tbl = tbl or {}
    print(tbl)
    for k, v in pairs(tbl) do
        -- Check the value type
        if type(v) == "table" then
            result = result..table.tostring(v)
        elseif type(v) == "boolean" then
            result = result..tostring(v)
        else
            result = result..v
        end
        result = result.." "
    end
    -- Remove leading commas from the result
    if result ~= "" then
        result = result:sub(1, result:len()-1)
    end
    return result
end

function tabletlib.executeCommand(inp)
	tprint("[global@fractalos ~]$ " .. inp)
	if inp:find("^#") then return end

	cmd = string.split(inp)[1]
	args = inp:sub(#cmd+2)

	if commands[cmd] then
		if commands[cmd][1][1] == -1 then
			commands[cmd][2](args)
			return
		end
		if commands[cmd][1][1] == -2 then
			commands[cmd][2](args)
			return
		end
		if #string.split(args) > #commands[cmd][1] and commands[cmd][1][#commands[cmd][1]] ~= -1 then
			tprint("fsh: " .. cmd .. ": Too many arguments")
			return
		end
		if #string.split(args) < #commands[cmd][1] then
			tprint("fsh: " .. cmd .. ": Too few arguments")
			return
		end
		if commands[cmd][1][#commands[cmd][1]] == -1 then
			topassargs = {
				unpack(string.split(args), 1, #commands[cmd][1]-1), 
				table.tostring(
					{unpack(string.split(args), #commands[cmd][1]-1, #args)}
				)
			}
		else
			topassargs = string.split(args)
		end
		commands[cmd][2](topassargs)
		return
	end
	tprint("fsh: Unknown command \"" .. cmd .. "\"")
end
tabletlib.registercmd("help", {"*"}, function()
	tprint("Fractal OS Terminal help")
	for k,v in pairs(commands) do
		tprint(k .. " - " .. v[3])
	end
end, "Fractal OS Terminal help")

--[[
"help - Display this text"
"clear - Clear terminal output"
"echo <text...> - Echo inputted text back"
"ping - Ping all players on server"
"tasknf - Print info about received task"
"camtp <x> <y> <z> - Teleport camera to coordinates"
"stc <plyid> <clsid> - [PREnv] Set test subject subclass (Garry, Kratos, Circle, Newguy)"
"vtstart - [PREnv] Vote for server start"
]]

net.Receive("RoundEnd", function(_, ply)
	if tabletlib.shown() then
		tabletlib.createLockdown()
	else
		lockdown = true
	end
end)

return tabletlib