local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")

local item = {
	ToCall = {},
	id_counter = 10000,
	pos_ = {
		Vector(-6,-38),
		Vector(-12,-28),
		Vector(-16,-18),
	},
	else_pos_ext = Vector(-12,-3),
}

function item.try_get_charge_bar_pos(player,id,acco_t_p)		--返回相对位置。
	if player == nil then return -1 end
	if id == nil then return -1 end
	local d = player:GetData()
	if d.charge_bar_holder_i_list == nil then d.charge_bar_holder_i_list = {} end
	if d.charge_bar_holder_i_list[id] == nil then item.allocate_charge_bar_pos(player,id) end
	for i = 1,#d.charge_bar_holder_list do
		if d.charge_bar_holder_list[i].id == id then
			local li = math.floor((i-1)/(#item.pos_))
			local ri = (i - 1) % (#item.pos_) + 1
			local ret = item.pos_[ri] + item.else_pos_ext * li
			if acco_t_p then
				ret.X = ret.X * player.SpriteScale.X
				ret.Y = ret.Y * player.SpriteScale.Y
			end
			return ret
		end
	end
	return -1
end

function item.get_charge_bar_pos(player,id)		--返回相对位置。
	if player == nil then return -1 end
	if id == nil then return -1 end
	local d = player:GetData()
	if d.charge_bar_holder_i_list == nil then d.charge_bar_holder_i_list = {} end
	if d.charge_bar_holder_i_list[id] == nil then return -1 end
	if d.charge_bar_holder_list == nil then d.charge_bar_holder_list = {} end
	for i = 1,#d.charge_bar_holder_list do
		if d.charge_bar_holder_list[i].id == id then
			if item.pos_[i] then
				return item.pos_[i]
			else
				return item.else_pos_ + item.else_pos_ext * i
			end
		end
	end
end

function item.remove_charge_bar(player,id)
	if player == nil then return -1 end
	if id == nil then return -1 end
	local d = player:GetData()
	if d.charge_bar_holder_i_list == nil then d.charge_bar_holder_i_list = {} end
	if d.charge_bar_holder_i_list[id] == nil then return -1 end
	if d.charge_bar_holder_list == nil then d.charge_bar_holder_list = {} end
	for i = 1,#d.charge_bar_holder_list do
		if d.charge_bar_holder_list[i].id == id then
			d.charge_bar_holder_i_list[id] = nil
			table.remove(d.charge_bar_holder_list,i)
			break
		end
	end
	return 1
end

function item.allocate_charge_bar_pos(player,id)
	if player == nil then return -1 end
	if id == nil then return -1 end
	local d = player:GetData()
	if d.charge_bar_holder_list == nil then d.charge_bar_holder_list = {} end
	if d.charge_bar_holder_i_list == nil then d.charge_bar_holder_i_list = {} end
	if d.charge_bar_holder_i_list[id] == nil then 
		local tab = {id = id,}
		table.insert(d.charge_bar_holder_list,#d.charge_bar_holder_list+1,tab)
		d.charge_bar_holder_i_list[id] = tab
	end
end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_PLAYER_UPDATE, params = nil,
Function = function(_,player)
	local d = player
	if d.charge_bar_holder_i_list then
		--print(#d.charge_bar_holder_i_list)
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_PLAYER_INIT, params = nil,
Function = function(_,player)
	local d = player
	if d.charge_bar_holder_i_list then
		--print(#d.charge_bar_holder_i_list)
	end
end,
})

return item