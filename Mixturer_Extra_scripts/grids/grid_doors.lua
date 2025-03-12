local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")

local item = {
	ToCall = {},
	Tofun = {},
	doors = {},
	special_reminder = nil,
}

local function check_all_pos_and_door(door)
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		if (door.Position - player.Position):Length() <= 5 + player.Size then
			return true
		end
	end
	return false
end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NEW_ROOM, params = nil,
Function = function(_)
	local level = Game():GetLevel()
	local room = Game():GetRoom()
	local desc = level:GetCurrentRoomDesc()
	if item.special_reminder then
		if (item.special_reminder.Type == nil or desc.Data.Type == item.special_reminder.Type) and (item.special_reminder.Variant == nil or desc.Data.Variant == item.special_reminder.Variant) then
			local ret = item.special_reminder.Funct()
			if ret then
				--Screen_Filter.add_filter(ret)
			end
		end
	end
	item.special_reminder = nil
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_UPDATE, params = nil,
Function = function(_)
	local desc = Game():GetLevel():GetCurrentRoomDesc()
	for i = #item.doors,1,-1 do
		if item.doors[i].safe_grid_index ~= Game():GetLevel():GetCurrentRoomDesc().SafeGridIndex or item.doors[i].safe_grid_type ~= desc.Data.Type or item.doors[i].safe_grid_variant ~= desc.Data.Variant then
			table.remove(item.doors,i)
		else
			local door = item.doors[i].door
			local should_trans = check_all_pos_and_door(door)
			if should_trans then
				if item.doors[i].special_reminder then
					item.special_reminder = {Type = item.doors[i].Type,Variant = item.doors[i].Variant,Funct = item.doors[i].special_reminder}
				end
				if item.doors[i].targ then
					if item.doors[i].slot then Game():GetLevel().LeaveDoor = item.doors[i].slot end
					if type(item.doors[i].targ) == "string" then
						Isaac.ExecuteCommand("goto ".. item.doors[i].targ)
					elseif type(item.doors[i].targ) == "function" then
						item.doors[i].targ()
					end
				end
			end
			if item.doors[i].should_update == true then
				item.doors[i].door:GetSprite():Update()
			end
		end
	end
end,
})

table.insert(item.Tofun,#item.Tofun + 1,{name = "try_spawn_grid_door",
Function = function(room,slot,indx,check_and_leave,should_update,loadname,playname,color,dir,tp,vr,special_reminder)
	loadname = loadname or "gfx/grid/door_mausoleum.anm2"
	local level = Game():GetLevel()
	local desc = Game():GetLevel():GetCurrentRoomDesc()
	if should_update == nil then should_update = false end
	if room == nil then return end
	local ind_pos = indx or -1
	if slot and slot >= 0 then ind_pos = room:GetGridIndex(room:GetDoorSlotPosition(slot)) end
	local door = room:GetGridEntity(ind_pos)
	if door == nil then return end
	for u,v in pairs(item.doors) do
		if v.idx == ind_pos and v.safe_grid_type == desc.Data.Type and v.safe_grid_variant == desc.Data.Variant then
			if door:GetSprite():GetFilename() == loadname and door.CollisionClass == GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER then
				return door
			end
		end
	end
	local s = door:GetSprite()
	s:Load(loadname, false)
	s.Color = color or Color(1,1,1,1)
	s:LoadGraphics()
	s:Play(playname or "Opened",true)
	if slot or dir then
		if slot == DoorSlot.LEFT0 or slot == DoorSlot.LEFT1 or (dir and dir == 0) then
			s.Rotation = 270
			s.Offset = Vector(12, 0)
		elseif slot == DoorSlot.UP0 or slot == DoorSlot.UP1 or (dir and dir == 1) then
			s.Rotation = 0
			s.Offset = Vector(0, 12)
		elseif slot == DoorSlot.DOWN0 or slot == DoorSlot.DOWN1 or (dir and dir == 3) then
			s.Rotation = 180
			s.Offset = Vector(0, -12)
		elseif slot == DoorSlot.RIGHT0 or slot == DoorSlot.RIGHT1 or (dir and dir == 2) then
			s.Rotation = 90
			s.Offset = Vector(-12, 0)
		end
	end
	if loadname == "gfx/grid/Door_08_HoleInWall.anm2" then s.Offset = Vector(0,0) end
	door.CollisionClass = GridCollisionClass.COLLISION_WALL_EXCEPT_PLAYER
	table.insert(item.doors,{door = door,targ = check_and_leave,idx = ind_pos,slot = slot or 0,safe_grid_index = level:GetCurrentRoomDesc().SafeGridIndex,safe_grid_variant = level:GetCurrentRoomDesc().Data.Variant,safe_grid_type = level:GetCurrentRoomDesc().Data.Type,should_update = should_update,
		Type = tp,Variant = vr,special_reminder = special_reminder,
	})
	return door
end,
})

return item