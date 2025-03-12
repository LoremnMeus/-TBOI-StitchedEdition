local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")

local item = {
	ToCall = {},
	myToCall = {},
	pre_myToCall = {},
	own_key = "h_c_",
}

--效果为记录所有需要被永久记录的事物。
--分为四类，下层后解除记录、小退后解除记录、结束游戏后解除记录、永久记录（不建议使用）
table.insert(item.pre_myToCall,#item.pre_myToCall + 1,{CallBack = enums.Callbacks.PRE_GAME_STARTED, params = nil,
Function = function(_,continue)
	if continue then
	else
		save.elses.Consistance_holder = {}
	end
	save.elses.Consistance_holder = save.elses.Consistance_holder or {}
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_GAME_END, params = nil,
Function = function(_,shouldsave)
	if not shouldsave then
		save.elses.Consistance_holder = {}
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_ENTITY_REMOVE, params = nil,
Function = function(_,ent)
	if not item[item.own_key.."filter"] then
		local succ = item.try_check_entity(ent,nil,true)
		if succ then
			local desc = Game():GetLevel():GetCurrentRoomDesc()
			local gridx = desc.GridIndex
			if Game():GetRoom():GetFrameCount() ~= 0 or auxi.would_be_removed_entity(ent) then
				delay_buffer.addeffe(function(params)		--解除小退的情况
					succ = item.try_check_entity(ent,nil,true)
					while succ do 
						save.elses.Consistance_holder[succ.name] = nil
						succ = item.try_check_entity(ent,nil,true)
					end
				end,{},1)
			end
		end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NEW_ROOM, params = nil,
Function = function(_)
	item[item.own_key.."filter"] = nil
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_USE_ITEM, params = CollectibleType.COLLECTIBLE_GLOWING_HOUR_GLASS,
Function = function(_, colid, rng, player, flags, slot, data)
	item[item.own_key.."filter"] = true
end,
})

--l local save = require("Qing_Extra_scripts.core.savedata") local auxi = require("Qing_Extra_scripts.auxiliary.functions") auxi.PrintTable(save.elses.collectible_counter)
--l local n_entity = Isaac.GetRoomEntities() for u,v in pairs(n_entity) do if v.Type == 5 then v:GetData().hhh = 1 end end
--l local n_entity = Isaac.GetRoomEntities() for u,v in pairs(n_entity) do if v.Type == 5 then print(v:GetData().hhh) end end
table.insert(item.pre_myToCall,#item.pre_myToCall + 1,{CallBack = enums.Callbacks.PRE_NEW_ROOM, params = nil,
Function = function(_)
	for u,v in pairs(save.elses.Consistance_holder) do
		local should_delete = true
		for uu,vv in pairs(v) do
			if vv.one_room then save.elses.Consistance_holder[u][uu] = nil
			else should_delete = false end
		end
		if should_delete then save.elses.Consistance_holder[u] = nil end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_GAME_EXIT, params = nil,
Function = function(_,shouldSave)		--离开游戏
	for u,v in pairs(save.elses.Consistance_holder) do
		local should_delete = true
		for uu,vv in pairs(v) do
			if vv.one_room then save.elses.Consistance_holder[u][uu] = nil
			else should_delete = false end
		end
		if should_delete then save.elses.Consistance_holder[u] = nil end
	end
end,
})

table.insert(item.pre_myToCall,#item.pre_myToCall + 1,{CallBack = enums.Callbacks.PRE_NEW_LEVEL, params = nil,
Function = function(_)
	for u,v in pairs(save.elses.Consistance_holder) do
		local should_delete = true
		for uu,vv in pairs(v) do
			if vv.keep_level == nil then save.elses.Consistance_holder[u][uu] = nil
			else should_delete = false end
		end
		if should_delete then save.elses.Consistance_holder[u] = nil end
	end
end,
})

local function make_name(ent,params,checkname)
	params = params or {}
	local ret = ""
	if params.ignore_type ~= true then 
		ret = ret..tostring(ent.Type).."_T_" 
		if params.ignore_variant ~= true then 
			ret = ret..tostring(ent.Variant).."_V_" 
			if params.ignore_subtype ~= true then 
				ret = ret..tostring(params.record_subtype or ent.SubType or ent.Subtype).."_S_" 
			end
		end
	end
	ret = ret..tostring(ent.InitSeed).."_I_"
	return ret
end

function item.get_name(ent,params,checkname)
	local tbl = {}
	params = params or {}
	table.insert(tbl,make_name(ent,params,checkname))
	if not params.params_name_only then
		table.insert(tbl,make_name(ent,{ignore_subtype = true,},checkname))
		table.insert(tbl,make_name(ent,{ignore_variant = true,},checkname))
		table.insert(tbl,make_name(ent,{ignore_type = true,},checkname))
	end
	return tbl
end

function item.try_hold_over_entity(ent,checkname)
	local d = ent:GetData()
	d._Data = ent:GetData()._Data or {}
	d._Data[checkname] = d._Data[checkname] or {}
end

function item.try_hold_entity(ent,checkname,params,params2)			--可以传入：keep_level、ignore_type、ignore_subtype、ignore_variant等
	checkname = checkname or "Check"
	params = params or {}
	params2 = params2 or {}
	if ent == nil then print("Wrong entity to hold!") return end
	local d = ent:GetData()
	item.try_hold_over_entity(ent,checkname)
	local tg = item.try_check_entity(ent,checkname,true)
	if tg then
		tg = tg.desc
		tg.data = auxi.deepCopy(d._Data[checkname])
		for u,v in pairs(params) do
			tg[u] = v
		end
	else
		save.elses.Consistance_holder = save.elses.Consistance_holder or {}
		local name = make_name(ent,params,checkname)
		if params.printname then print(name) end
		save.elses.Consistance_holder[name] = save.elses.Consistance_holder[name] or {}
		save.elses.Consistance_holder[name][checkname] = {data = auxi.deepCopy(d._Data[checkname]),keep_level = params.keep_level,}
		return name
	end
end

function item.try_check_entity(ent,checkname,testing,params)
	params = params or {}
	local d = ent:GetData()
	if not testing and d._Data and checkname and d._Data[checkname] then return true end
	d._Data = d._Data or {}
	local names = params.names or item.get_name(ent,params,checkname)
	if params.printname then auxi.PrintTable(names) end
	if save.elses.Consistance_holder == nil then return end
	for u,v in pairs(names) do
		local ret = save.elses.Consistance_holder[v]
		if ret and checkname then ret = ret[checkname] end
		if ret then
			if testing then
				return {desc = ret,name = v}
			else
				if checkname then d._Data[checkname] = auxi.deepCopy(ret.data)
				else 
					for uu,vv in pairs(ret) do d._Data[uu] = auxi.deepCopy(vv.data)	end
				end
				return true
			end
		end
	end
	return nil
end

function item.check_table()
	local counter = 0
	if save.elses.Consistance_holder then
		for u,v in pairs(save.elses.Consistance_holder) do
			for uu,vv in pairs(v) do
				counter = counter + 1
			end
		end
	end
	print(counter)
	--auxi.PrintTable(save.elses.Consistance_holder)
end


table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_EXECUTE_CMD, params = nil,
Function = function(_,str,params)
	if string.lower(str) == "meus" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, str)
		end
		if args[1] == "check" then
			item.check_table()
		end
	end
end,
})

function item.try_remove_entity(ent,checkname,params)
	params = params or {}
	local succ = false
	if save.elses.Consistance_holder then
		local d = ent:GetData()
		d._Data = d._Data or {}
		if checkname then d._Data[checkname] = nil else d._Data = {} end
		local names = params.names or item.get_name(ent,params,checkname)
		if params.printname then auxi.PrintTable(names) end
		for u,v in pairs(names) do
			if save.elses.Consistance_holder[v] then
				if checkname then 
					if save.elses.Consistance_holder[v][checkname] then
						save.elses.Consistance_holder[v][checkname] = nil
						succ = true
					end
					local should_delete = true
					for uu,vv in pairs(save.elses.Consistance_holder[v]) do should_delete = false end
					if should_delete then save.elses.Consistance_holder[v] = nil end
				else
					save.elses.Consistance_holder[v] = nil
				end
			end
		end
	end
	return succ
end

return item