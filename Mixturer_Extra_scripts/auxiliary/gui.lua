local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")
local ui = require("Mixturer_Extra_scripts.auxiliary.ui")
local funct = {
	f = nil
}		--在这里放置有关于图形的函数。

if funct.f == nil then 
	funct.f = Font()
	local _, err = pcall(require, "")
	local basePathStart
	local modPathEnd
	local modPathStart
	if os then			--用于检测luadebug模式
		_, modPathStart = string.find(err, "no file '", 1)
		modPathEnd, _ = string.find(err, "mods", modPathStart)
	else
		_, basePathStart = string.find(err, "no file '", 1)
		_, modPathStart = string.find(err, "no file '", basePathStart)
		modPathEnd, _ = string.find(err, "mods", modPathStart)
	end
	local path = string.sub(err, modPathStart + 1, modPathEnd - 1)
	--print(path)
	path = string.gsub(path, "\\", "/")
	path = string.gsub(path, "//", "/")
	path = string.gsub(path, ":/", ":\\")
	---
	funct.f:Load(path .. "mods/Mixturer/resources/font/eid9/eid9_9px.fnt")
	if not funct.f:IsLoaded() then
		funct.f:Load(path .. "mods/Mixturer/resources/font/eid9/eid9_9px.fnt")
	end
	if not funct.f:IsLoaded() then
		funct.f:Load("../mods/Mixturer/resources/font/eid9/eid9_9px.fnt")
	end
	if not funct.f:IsLoaded() then
		funct.f:Load("../mods/Mixturer/resources/font/eid9/eid9_9px.fnt")
	end
	if not funct.f:IsLoaded() then
		funct.f:Load("font/eid9/eid9_9px.fnt")
	end
	if not funct.f:IsLoaded() then
		funct.f:Load("font/mplus_10r.fnt")
	end
end

function funct.draw_ch(pos,targ,sx,sy,Kcol,has_count_world)
	if sx == nil or sy == nil then 
		sx = 2
		sy = 2
	end
	if Kcol == nil then
		Kcol = KColor(1,1,1,1)
	end
	if targ == nil then
		print("wrong string!")
	end
	if has_count_world then
		funct.f:DrawStringScaledUTF8(targ,pos.X,pos.Y,sx,sy,Kcol,0,false)
	else
		funct.f:DrawStringScaledUTF8(targ,Isaac.WorldToScreen(pos).X,Isaac.WorldToScreen(pos).Y,sx,sy,Kcol,0,false)
	end
end

function funct.draw_ch_with_time_to_move_out(startpos,dir,targ,sx,sy,R,G,B,A,take_screen_counter,render_on_shader,special,ignore_stop)
	if take_screen_counter == nil then take_screen_counter = true end
	if ignore_stop == nil then ignore_stop = false end
	sx = sx or 1
	sy = sy or 1
	if targ == nil then
		print("wrong string!")
		return
	end
	if R == nil then R = 1 end
	if G == nil then G = 1 end
	if B == nil then B = 1 end
	if A == nil then A = 1 end
	dir = dir or Vector(-5,0)
	startpos = startpos or (ui.GetScreenTopRight() + Vector(0,math.random(math.floor(ui.GetScreenCenter().Y * 0.6))))
	local out_pos = ui.GetScreenBottomRight()
	local tbl = {font = funct.f,R = R,G = G,B = B,A = A,targ = targ,pos = startpos,dir = dir,sx = sx,sy = sy,take_screen_counter = take_screen_counter,ignore_stop = ignore_stop,}
	local adder = function(params)
		local Kcol = params.Kcol
		Kcol = KColor(params.R,params.G,params.B,params.A)
		local r_pos = params.pos
		if params.take_screen_counter ~= true then r_pos = Isaac.WorldToScreen(r_pos) end 
		params.font:DrawStringScaledUTF8(params.targ,r_pos.X,r_pos.Y,params.sx,params.sy,Kcol,0,false)
		if Game():IsPaused() ~= true or params.ignore_stop then
			params.pos = params.pos + params.dir
		end
		if special then
			special(tbl)
		end
		if r_pos.X < -120 or r_pos.Y < -120 or r_pos.X > out_pos.X + 120 or r_pos.Y > out_pos.Y + 120 then
			return false
		else
			return true
		end
	end
	local inser = function(param,funct,funct2)
		local ret = funct(param)
		if ret then
			delay_buffer.addeffe(function(params)
				funct2(param,funct,funct2)
			end,tbl,1,true,render_on_shader)
		end
	end
	inser(tbl,adder,inser)
end

function funct.draw_ch_with_time_to_dispair(startpos,delatapos,targ,delay,sx,sy,R,G,B,take_screen_counter,render_on_shader,special)
	if take_screen_counter == nil then take_screen_counter = false end
	if sx == nil or sy == nil then 
		sx = 1
		sy = 1
	end
	if targ == nil then
		print("wrong string!")
		return
	end
	if R == nil then
		R = 1
	end
	if G == nil then
		G = 1
	end
	if B == nil then
		B = 1
	end
	if delatapos == nil then
		delatapos = Vector(0,-50)
	end
	if delay == nil then
		delay = 25
	end
	if delay == 0 then
		delay = 1
	end
	local strlen = delatapos/delay
	for i = 1,delay do
		local tbl = {font = funct.f,R = R,G = G,B = B,targ = targ,pos = startpos + strlen * i,sx = sx,sy = sy,delay = delay,i = i,take_screen_counter = take_screen_counter}
		delay_buffer.addeffe(function(params)
			local Kcol = params.Kcol
			Kcol = KColor(params.R,params.G,params.B,(params.delay - params.i + 1)/params.delay)
			if params.take_screen_counter == true then
				params.font:DrawStringScaledUTF8(params.targ,params.pos.X,params.pos.Y,params.sx,params.sy,Kcol,0,false)
			else
				params.font:DrawStringScaledUTF8(params.targ,Isaac.WorldToScreen(params.pos).X,Isaac.WorldToScreen(params.pos).Y,params.sx,params.sy,Kcol,0,false)
			end
		end,tbl,i,true,render_on_shader)
		if special then
			special(tbl)
		end
	end
end

function funct.draw_ch_dis_pos(startpos,delatapos,targ,t_by_delay,delay,sx,sy,R,G,B)
	funct.draw_ch_with_time_to_dispair(startpos + Vector(-(#targ)/2,0),delatapos,targ,t_by_delay * (#targ) + delay,sx,sy,R,G,B)
end

function funct.draw_chs(pos1,pos2,targ,sx,sy,Kcol,cnt)
	local leng = auxi.GetLen(targ)
	if cnt <= 0 then cnt = 5 end
	for i = 0,leng/cnt do 
		funct.f:DrawStringScaledUTF8(string.sub(targ,i*cnt + 1,math.min(leng,(i + 1) * cnt)),Isaac.WorldToScreen(pos1 + (pos2 - pos1)/leng * cnt * i).X,Isaac.WorldToScreen(pos1 + (pos2 - pos1)/leng * cnt * i).Y,sx,sy,Kcol,0,false)
	end
end

function funct.draw_line(pos1,pos2,targ,cnt)
	local rpos1 = Isaac.WorldToScreen(pos1)
	local rpos2 = Isaac.WorldToScreen(pos2)
	if cnt == nil then
		if targ == "-" then
			cnt = (rpos2 - rpos1):Length() / 8
		end
		if targ == "|" then
			cnt = (rpos2 - rpos1):Length() / 30
		end
	end
	for i = 0,cnt do
		funct.f:DrawStringScaledUTF8(targ,Isaac.WorldToScreen(pos1 + (pos2 - pos1)/cnt * i).X,Isaac.WorldToScreen(pos1 + (pos2 - pos1)/cnt * i).Y,2,2,KColor(1,1,1,1),0,false)
	end
end

function funct.real_draw_line(pos1,pos2,targ,cnt,sx,sy,Kcol)
	if Kcol == nil then Kcol = KColor(1,1,1,1) end
	if sx == nil or sy == nil then
		if targ == "-" then
			sx = 1
			sy = 1
		elseif targ == "|" then
			sx = 1
			sy = 0.2
		else
			sx = 2
			sy = 2
		end
	end
	local rpos1 = Isaac.WorldToScreen(pos1)
	local rpos2 = Isaac.WorldToScreen(pos2)
	if targ == "-" then 
		rpos1 = rpos1 + (rpos2 - rpos1):Normalized() * 2
		rpos2 = rpos2 + (rpos1 - rpos2):Normalized() * 2
	elseif targ == "|" then
		rpos1 = rpos1 + (rpos2 - rpos1):Normalized() * 2
		rpos2 = rpos2 + (rpos1 - rpos2):Normalized() * 2
	end
	if cnt == nil then
		if targ == "-" then
			cnt = (rpos2 - rpos1):Length() / 4
		end
		if targ == "|" then
			cnt = (rpos2 - rpos1):Length() / 4
		end
	end
	if targ == "-" then
		for i = 0,cnt do
			funct.f:DrawStringScaledUTF8(targ,(rpos1 + (rpos2 - rpos1)/cnt * i).X,(rpos1 + (rpos2 - rpos1)/cnt * i).Y,sx,sy,Kcol,0,false)
		end
	elseif targ == "|" then
		for i = 0,cnt do
			funct.f:DrawStringScaledUTF8(targ,(rpos1 + (rpos2 - rpos1)/cnt * i).X,(rpos1 + (rpos2 - rpos1)/cnt * i).Y + 8,sx,sy,Kcol,0,false)
		end
	else
		for i = 0,cnt do
			funct.f:DrawStringScaledUTF8(targ,(rpos1 + (rpos2 - rpos1)/cnt * i).X,(rpos1 + (rpos2 - rpos1)/cnt * i).Y,sx,sy,Kcol,0,false)
		end
	end
end

function funct.draw_formax(pos1,pos2,lin,col)		--绘制一个普通的表格
	if lin <= 0 or col <= 0 then return end
	local dpos = pos2 - pos1
	local w = Vector(dpos.X,0)
	local h = Vector(0,dpos.Y)
	for i = 0,lin do
		funct.real_draw_line(pos1 + h/lin * i,pos2 - h/lin * (lin - i),"-")
	end
	for i = 0,col  do
		funct.real_draw_line(pos1 + w/col * i,pos2 - w/col * (col - i),"|")
	end
end

function funct.render_sprite(sp,pos,v1,v2)
	sp:Render(Isaac.WorldToScreen(pos),v1,v2)
end

function funct.GetScreenSize()
    local room = Game():GetRoom()
    local pos = Isaac.WorldToScreen(Vector(0,0)) - room:GetRenderScrollOffset() - Game().ScreenShakeOffset
    
    local rx = pos.X + 60 * 26 / 40
    local ry = pos.Y + 140 * (26 / 40)
    
    return Vector(rx*2 + 13*26, ry*2 + 7*26)
end

function funct.general_speak(delatapos,targ,t_by_delay,delay,sx,sy,R,G,B)
	local startpos = ui.GetScreenBottomLeft() + Vector(20,-50)
	funct.draw_ch_with_time_to_dispair((startpos),delatapos,targ,t_by_delay * (#targ) + delay,sx,sy,R,G,B,true)
end

return funct