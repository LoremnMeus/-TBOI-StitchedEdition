local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local callback_manager = require("Mixturer_Extra_scripts.core.callback_manager")
local input_holder = require("Mixturer_Extra_scripts.others.Input_holder")
local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")

local item = {
	pre_ToCall = {},
	ToCall = {},
	post_ToCall = {},
	pre_myToCall = {},
	myToCall = {},
}

table.insert(item.pre_myToCall,#item.pre_myToCall + 1,{CallBack = enums.Callbacks.PRE_NEW_ROOM, params = nil,
Function = function(_)
	local level = Game():GetLevel()
	local stg = level:GetStage()
	local rooms = level:GetRooms()
	local desc = level:GetCurrentRoomDesc()
	local succ = true
	for i = 1, rooms.Size do 
		local targ = rooms:Get(i - 1) 
		local cnt = 0
		if GetPtrHash(targ) == GetPtrHash(desc) then cnt = 1 end
		if targ.VisitedCount ~= cnt then succ = false break end 
	end
	if not item.should_not_trigger and not item.has_triggered and succ then
		callback_manager.work("PRE_PRE_NEW_LEVEL",function(funct,params) funct(nil,item.now_level) end)
		item.has_triggered = true
	end
	item.now_level = stg
end,
})

table.insert(item.post_ToCall,#item.post_ToCall + 1,{CallBack = ModCallbacks.MC_USE_ITEM, params = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
Function = function(_, coll, rng, player, flags, slot, data)
	item.should_not_trigger = true
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NEW_LEVEL, params = nil,
Function = function(_)
	if item.has_triggered == nil then
		callback_manager.work("PRE_NEW_LEVEL",function(funct,params) funct(nil,item.now_level) end)		--检查失败，可能会引发bug。
	end
	item.has_triggered = nil
end,
})

table.insert(item.myToCall,#item.myToCall + 1,{CallBack = enums.Callbacks.PRE_GAME_STARTED, params = nil,
Function = function(_,continue)
	if continue then
		item.now_level = nil
		item.should_not_trigger = true
	else
		item.now_level = -1
		item.has_triggered = nil
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_GAME_EXIT, params = nil,		--加个奇怪的锁，希望不出问题
Function = function(_,shouldsave)
	item.renewer = nil
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_PLAYER_INIT, params = nil,
Function = function(_,player)
	local TotPlayers = #Isaac.FindByType(EntityType.ENTITY_PLAYER)
	if TotPlayers == 0 and item.renewer ~= true then
		local continue = true
		if Game():GetFrameCount() == 0 then continue = false end
		callback_manager.work("PRE_PRE_GAME_STARTED",function(funct,params) funct(nil,continue) end)
		callback_manager.work("PRE_GAME_STARTED",function(funct,params) funct(nil,continue) end)
		callback_manager.work("POST_PRE_GAME_STARTED",function(funct,params) funct(nil,continue) end)
		item.renewer = true
	end
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_NEW_ROOM, params = nil,
Function = function(_,ent)
	if item.has_triggered2 == nil then
		callback_manager.work("PRE_NEW_ROOM",function(funct,params) funct(nil) end)
	end
	if item.has_triggered2 then item.has_triggered2 = nil end
	
	local level = Game():GetLevel()
	local stg = level:GetStage()
	local rooms = level:GetRooms()
	local desc = level:GetCurrentRoomDesc()
	local succ = true
	for i = 1, rooms.Size do 
		local targ = rooms:Get(i - 1) 
		local cnt = 0
		if GetPtrHash(targ) == GetPtrHash(desc) then cnt = 1 end
		if targ.VisitedCount ~= cnt then succ = false break end 
	end
	if not item.should_not_trigger and item.has_triggered and succ then
		callback_manager.work("PRE_NEW_LEVEL",function(funct,params) funct(nil,item.now_level) end)
		item.has_triggered = true
	end
	item.should_not_trigger = nil
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, params = nil,
Function = function(_,tp,vr,st)
	if item.has_triggered2 == nil then
		item.has_triggered2 = true
		callback_manager.work("PRE_NEW_ROOM",function(funct,params) funct(nil) end)
	end
end,
})

table.insert(item.myToCall,#item.myToCall + 1,{CallBack = enums.Callbacks.POST_EVERY_ENTITY_INIT, params = nil,
Function = function(_,ent)
	if Game():GetRoom():GetFrameCount() == -1 then
		if item.has_triggered2 == nil then
			item.has_triggered2 = true
			callback_manager.work("PRE_NEW_ROOM",function(funct,params) funct(nil) end)
		end
	end
end,
})

return item