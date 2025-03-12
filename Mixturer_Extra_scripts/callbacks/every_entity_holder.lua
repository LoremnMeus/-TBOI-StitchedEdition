local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local callback_manager = require("Mixturer_Extra_scripts.core.callback_manager")
local input_holder = require("Mixturer_Extra_scripts.others.Input_holder")

local item = {
	pre_ToCall = {},
	ToCall = {},
	myToCall = {},
	own_key = "Every_Entity_holder_",
	record_list = {},
}

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_NPC_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_NPC_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_FAMILIAR_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_FAMILIAR_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_PLAYER_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_PLAYER_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_TEAR_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_TEAR_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_PROJECTILE_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_PROJECTILE_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_LASER_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_LASER_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_KNIFE_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_KNIFE_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_EFFECT_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_EFFECT_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_BOMB_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_BOMB_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_PICKUP_INIT, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
	
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_PICKUP_UPDATE, params = nil,
Function = function(_,ent)
	callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == ent.Type then funct(nil,ent) end end)
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_USE_CARD, params = nil,
Function = function(_)
	local n_slots = Isaac.FindByType(6, -1, -1, false, false)
	for u,v in pairs(n_slots) do if v.FrameCount == 0 then item.init_slot(v) end end
end,
})

function item.kill_slot(ent,killer)
	if ent:GetData()[item.own_key.."Killed"] ~= true and ent:Exists() then
		callback_manager.work("POST_SLOT_KILL",function(funct,params) if params == nil or params == ent.Variant then funct(nil,ent,killer) end end)
		ent:GetData()[item.own_key.."Killed"] = true
	end
end

function item.init_slot(v)
	callback_manager.work("POST_SLOT_INIT",function(funct,params) if params == nil or params == v.Variant then funct(nil,v) end end)
	callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == v.Type then funct(nil,v) end end)
	v:GetData()[item.own_key.."Check"] = true
end

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_POST_NEW_ROOM, params = nil,
Function = function(_)
	local n_slots = Isaac.FindByType(6, -1, -1, false, false)
	for u,v in pairs(n_slots) do
		callback_manager.work("POST_SLOT_INIT",function(funct,params) if params == nil or params == v.Variant then funct(nil,v) end end)
		callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == v.Type then funct(nil,v) end end)
		v:GetData()[item.own_key.."Check"] = true
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_UPDATE, params = nil,
Function = function(_)
	--[[
	for i = #(item.record_list),1,-1 do
		local v = item.record_list[i]
		if auxi.check_all_exists(v) ~= true then table.remove(item.record_list,i) 
		else
		end
	end
	--]]
	
	local n_slots = Isaac.FindByType(6, -1, -1, false, false)
	local explosions = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION)
	local mamaMega = Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.MAMA_MEGA_EXPLOSION)
	for u,v in pairs(n_slots) do
		if v.FrameCount == 1 and v:GetData()[item.own_key.."Check"] ~= true then		 --因效果而生成的在第0帧无法被检测到，所以必须慢一帧
			callback_manager.work("POST_SLOT_INIT",function(funct,params) if params == nil or params == v.Variant then funct(nil,v) end end)
			callback_manager.work("POST_EVERY_ENTITY_INIT",function(funct,params) if params == nil or params == v.Type then funct(nil,v) end end)
		end
		callback_manager.work("POST_SLOT_UPDTAE",function(funct,params) if params == nil or params == v.Variant then funct(nil,v) end end)
		callback_manager.work("POST_EVERY_ENTITY_UPDTAE",function(funct,params) if params == nil or params == v.Type then funct(nil,v) end end)
		local leg = v.Position - v.TargetPosition
		if leg:Length() > 0.0001 and v:GetData()[item.own_key.."Killed"] ~= true then 
			local tg_player = nil
			for playerNum = 1, Game():GetNumPlayers() do
				local player = Game():GetPlayer(playerNum - 1)
				if (tg_player == nil or (player.Position - v.Position):Length() < (tg_player.Position - v.Position):Length()) and (player.Position - v.Position):Length() <= (player.Size + v.Size) then tg_player = player end
			end
			if tg_player then
				if tg_player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MEGA_MUSH) then item.kill_slot(v,player)
				else callback_manager.work("POST_SLOT_COLLISION",function(funct,params) if params == nil or params == v.Variant then funct(nil,v,tg_player,nil) end end) end
			end
			if #mamaMega > 0 then item.kill_slot(v,mamaMega[1]) end
			if leg:Length() > 50 then item.kill_slot(v,v) end
		end
	end
	
	for _, splosion in pairs(explosions) do
		local frame = splosion:GetSprite():GetFrame()
		if frame < 3 then
			local size = splosion.SpriteScale.X
			local nearby = Isaac.FindInRadius(splosion.Position, 75 * size)
			for u, v in pairs(nearby) do
				if v.Type == EntityType.ENTITY_SLOT then
					item.kill_slot(v,splosion)
				end
			end
		end
	end
	local room = Game():GetRoom()
	local width = room:GetGridWidth()
	local height = room:GetGridHeight()
	for i = 0,width do
		for j = 0,height do
			local idx = i + j * width
			local gent = room:GetGridEntity(idx)
			if gent then
				callback_manager.work("POST_GRID_UPDTAE",function(funct,params) if params == nil or params == gent:GetType() then funct(nil,idx,gent) end end)
			end
		end
	end
end,
})

return item