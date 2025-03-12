local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")
local funct = {
}

function funct.GetScreenSize() --based off of code from kilburn
	local game = Game()
	local room = game:GetRoom()
	local pos = room:WorldToScreenPosition(Vector(0,0)) - room:GetRenderScrollOffset() - game.ScreenShakeOffset
	local rx = pos.X + 60 * 26 / 40
	local ry = pos.Y + 140 * (26 / 40)
	return Vector(rx*2 + 13*26, ry*2 + 7*26)
end

function funct.GetScreenCenter()
	return funct.GetScreenSize() / 2
end

function funct.GetScreenBottomRight(offset)			--之前的参数似乎有点老了
	offset = offset or 0
	local pos = funct.GetScreenSize()
	local hudOffset = Vector(-offset * 1.6, -offset * 0.6)
	pos = pos + hudOffset
	return pos
end

function funct.GetScreenBottomLeft(offset)
	offset = offset or 0
	local pos = Vector(0, funct.GetScreenBottomRight(0).Y)
	local hudOffset = Vector(offset * 2.2, -offset * 1.6)
	pos = pos + hudOffset
	return pos
end

function funct.GetScreenTopRight(offset)
	offset = offset or 0
	local pos = Vector(funct.GetScreenBottomRight(0).X, 0)
	local hudOffset = Vector(-offset * 2.2, offset * 1.2)
	pos = pos + hudOffset
	return pos
end

function funct.GetScreenTopLeft(offset)
	offset = offset or 0
	local pos = Vector(0,0)
	local hudOffset = Vector(offset * 2, offset * 1.2)
	pos = pos + hudOffset
	return pos
end


function funct.GetHudOffsetLevel()
	local raw = Options.HUDOffset
	raw = raw * 10
	if raw%1 < 0.5 then return math.floor(raw)
	else return math.ceil(raw) end
end

function funct.UIHeartPos(x, player, isOffset)
	if not player then player = 1 end
	if not x then x = 0 end
	local hud = funct.GetHudOffsetLevel()
	local shunt = Vector.Zero
	if player == 1 then
		local topleft = Vector(40,4) + Vector(2,1.2)*hud
		local rows = math.floor(x/6)
		if isOffset then shunt = Vector(6,0) end
		return topleft + Vector(12*(x%6),10*rows) + shunt
	end
	if player == 2 then
		--local topright = Vector(363,218) - Vector(1.6,0.6)*hud
		local topright = Vector(Isaac.GetScreenWidth(),Isaac.GetScreenHeight()) - Vector(40,35) - Vector(1.6,0.6)*hud
		local rows = math.floor(x/6)
		if isOffset then shunt = Vector(-6,0) end
		return topright + Vector(-12*(x%6),10*rows) + shunt
	end
end

function funct.UIBombPos(isOffset,doubleplayer)
	local shunt = Vector.Zero
	local hud = funct.GetHudOffsetLevel()
	local topleft = Vector(2,1.2)*hud
	if isOffset then shunt = Vector(-6,0) end
	if doubleplayer then shunt = shunt + Vector(0,14) end
	return topleft + Vector(14,52) + shunt
end

function funct.UIChargeBarPos(slot,isOffset)
	if slot == nil then slot = 0 end
	local shunt = Vector.Zero
	local hud = funct.GetHudOffsetLevel()
	if slot == 0 then
		local topleft = Vector(2,1.2) * hud
		if isOffset then shunt = Vector(-6,0) end
		return topleft + Vector(38,17) + shunt
	elseif slot == 2 then
		local bottomright = funct.GetScreenBottomRight(hud)
		if isOffset then shunt = Vector(6,0) end
		return bottomright + Vector(-2,-13) + shunt
	elseif slot == 1 then
		local bottomright = funct.GetScreenBottomRight(hud)
		if isOffset then shunt = Vector(6,0) end
		return bottomright + Vector(-36,-22) + shunt
	else
		return Vector(1000,1000)
	end
end

function funct.UIActivePos(slot,isOffset,is_schoolbag)
	if slot == nil then slot = 0 end
	local shunt = Vector(0,0)
	local hud = funct.GetHudOffsetLevel()
	if slot == 0 then
		local topleft = Vector(2,1.2)*hud
		if isOffset then shunt = shunt + Vector(-6,0) end
		if is_schoolbag then shunt = shunt + Vector(-16,-8) end
		return topleft + Vector(20,16) + shunt
	elseif slot == 2 then
		local bottomright = funct.GetScreenBottomRight(hud)
		if isOffset then shunt = shunt + Vector(6,0) end
		if is_schoolbag then shunt = shunt + Vector(16,-8) end
		return bottomright + Vector(-20,-14) + shunt
	elseif slot == 1 then
		local bottomright = funct.GetScreenBottomRight(hud)
		if isOffset then shunt = shunt + Vector(6,0) end
		if is_schoolbag then shunt = shunt + Vector(16,-8) end
		return bottomright + Vector(-20,-23) + shunt
	else
		return Vector(1000,1000)
	end
end

function funct.myScreenToWorld(pos)
	local room = Game():GetRoom()
	local pos_z = Vector(0,0)
	local r_pos_z = Isaac.WorldToScreen(pos_z) - room:GetRenderScrollOffset() - Game().ScreenShakeOffset
	local pos_d = Vector(10,10)
	local r_pos_d = Isaac.WorldToScreen(pos_d) - r_pos_z - room:GetRenderScrollOffset() - Game().ScreenShakeOffset
	r_pos_d = r_pos_d / 10
	local ret = (pos - r_pos_z)
	if r_pos_d.X ~= 0 then ret.X = ret.X / r_pos_d.X end
	if r_pos_d.Y ~= 0 then ret.Y = ret.Y / r_pos_d.Y end
	return ret
end

function funct.UIPoopPos(isOffset,doubleplayer)
	local shunt = Vector.Zero
	local hud = funct.GetHudOffsetLevel()
	local topleft = Vector(2,1.2)*hud
	if isOffset then shunt = Vector(-6,0) end
	if doubleplayer then shunt = shunt + Vector(0,14) end
	return topleft + Vector(4,40) + shunt
end
--l local hud = 0;local raw = Options.HUDOffset;raw = raw * 10;if raw%1 < 0.5 then hud = math.floor(raw);else hud = math.ceil(raw) end;print(Vector(40,4) + Vector(2,1.2)*hud); print(Game():GetRoom():WorldToScreenPosition(Input.GetMousePosition(true)))

return funct