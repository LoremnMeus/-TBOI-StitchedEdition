local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local sound_tracker = require("Mixturer_Extra_scripts.auxiliary.sound_tracker")
local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")
local Attribute_holder = require("Mixturer_Extra_scripts.others.Attribute_holder")

local item = {
	ToCall = {},
	myToCall = {},
	post_ToCall = {},
	own_key = "EAN_grid_trapdoor_",
}
--现在也支持天堂传送门了
--[[
function item.spawn_trapdoor(pos,params)
	local q = auxi.fire_nil(pos or Game():GetRoom():GetCenterPos(),Vector(0,0),{cooldown = 999999,})
	local d2 = q:GetData() local s2 = q:GetSprite() q.DepthOffset = -1000 q.SortingLayer = 0
	d2[item.own_key.."effect"] = {pos = pos,params = params,}
	q:GetData()[Nil_holder.own_key.."work"] = function(ent)
		local d = ent:GetData()
		if d[item.own_key.."effect"] then
			ent.Position = d[item.own_key.."effect"].pos or ent.Position
			if auxi.check_all_exists(d[item.own_key.."effect"].catcher) then else
				local room = Game():GetRoom()
				local gidx = room:GetGridIndex(ent.Position)
				for playerNum = 1, Game():GetNumPlayers() do
					local player = Game():GetPlayer(playerNum - 1)
					if room:GetGridIndex(player.Position) == gidx and player:IsExtraAnimationFinished() then	
						d[item.own_key.."effect"].catcher = player
						player:GetData()[item.own_key.."effect"] = {linker = ent,}
					end
				end
			end
		else ent:Remove() return true end
	end
	return q
end
--]]

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_PLAYER_UPDATE, params = nil,
Function = function(_,player)
	local d = player:GetData() local s = player:GetSprite()
	for i = 1,1 do if d[item.own_key.."effect"] then
		for playerNum = 1, Game():GetNumPlayers() do
			local t_player = Game():GetPlayer(playerNum - 1)
			if t_player:GetData()[item.own_key.."effect"] == nil then 
				t_player:GetData()[item.own_key.."effect"] = {} 
				for u,v in pairs(d[item.own_key.."effect"]) do 
					t_player:GetData()[item.own_key.."effect"][u] = v
				end
				break 
			end
		end
		if auxi.check_all_exists(d[item.own_key.."effect"].linker) then
			if player:IsExtraAnimationFinished() then player:PlayExtraAnimation(d[item.own_key.."effect"].anim or "Trapdoor") end
			if auxi.check_if_any(d[item.own_key.."effect"].check_trip or function(player,s) return s:IsEventTriggered("Poof") end,player,s) then
				auxi.check_if_any((d[item.own_key.."effect"].linker:GetData()[item.own_key.."effect"] or {}).params,player)
				item.finish_trapdoor(player)
				d[item.own_key.."effect"] = nil 
				break
			end
			player.Position = player.Position * 0.5 + d[item.own_key.."effect"].linker.Position * 0.5
			player.Velocity = Vector(0,0)
			player:AddControlsCooldown(math.max(0,3 - player.ControlsCooldown))
			player:SetMinDamageCooldown(math.max(0,3 - player:GetDamageCooldown()))
			d[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"] = d[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"] or Attribute_holder.try_hold_attribute(player,"ENTITY_FLAG_NO_DAMAGE_BLINK",true,{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) else ent:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) end end,})
			d[item.own_key.."EntityCollision"] = d[item.own_key.."EntityCollision"] or Attribute_holder.try_hold_attribute(player,"EntityCollisionClass",EntityCollisionClass.ENTCOLL_NONE)
		else 
			item.finish_trapdoor(player)
			d[item.own_key.."effect"] = nil 
		end
	end end
end,
})

function item.finish_trapdoor(player)
	local d = player:GetData()
	if d[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"] then Attribute_holder.try_rewind_attribute(player,"ENTITY_FLAG_NO_DAMAGE_BLINK",d[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"],{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) else ent:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) end end,}) d[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"] = nil end
	if d[item.own_key.."EntityCollision"] then Attribute_holder.try_rewind_attribute(player,"EntityCollisionClass",d[item.own_key.."EntityCollision"]) d[item.own_key.."EntityCollision"] = nil end
	auxi.check_if_any((d[item.own_key.."effect"] or {}).on_finish,player)
	
	d[item.own_key.."effect"] = nil
	for playerNum = 1, Game():GetNumPlayers() do
		local t_player = Game():GetPlayer(playerNum - 1)
		local td = t_player:GetData()
		if td[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"] then Attribute_holder.try_rewind_attribute(t_player,"ENTITY_FLAG_NO_DAMAGE_BLINK",td[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"],{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) else ent:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK) end end,}) td[item.own_key.."ENTITY_FLAG_NO_DAMAGE_BLINK"] = nil end
		if td[item.own_key.."EntityCollision"] then Attribute_holder.try_rewind_attribute(t_player,"EntityCollisionClass",td[item.own_key.."EntityCollision"]) td[item.own_key.."EntityCollision"] = nil end
		td[item.own_key.."effect"] = nil
	end
end

return item