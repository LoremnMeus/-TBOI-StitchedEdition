local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")

local modReference
local manager = {
	items = {},
	t_order = {"pre_","","post_",},
}
local callback_manager = require("Mixturer_Extra_scripts.core.callback_manager")

function manager.Init(mod)
	modReference = mod
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.core.others_manager"))
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.core.callback_manager"))
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.core.grid_manager"))
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.core.enemy_manager"))
	manager.Make(mod)
end

function manager.Make(mod)
	for k = 1,#manager.items do
		manager.items[k].Init(mod)
	end
	for uk = 1,3 do
		for k = 1,#manager.items do
			for i = 1,#(manager.items[k].items) do
				if manager.items[k].items[i][manager.t_order[uk].."ToCall"] then
					for j = 1,#(manager.items[k].items[i][manager.t_order[uk].."ToCall"]) do
						if manager.items[k].items[i][manager.t_order[uk].."ToCall"][j] ~= nil and manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].Function ~= nil and manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].CallBack ~= nil then
							if manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].params == nil then
								modReference:AddCallback(manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].CallBack,manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].Function)
							else
								modReference:AddCallback(manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].CallBack,manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].Function,manager.items[k].items[i][manager.t_order[uk].."ToCall"][j].params)
							end
						end
					end
				end
			end
		end
		for k = 1,#manager.items do
			for i = 1,#(manager.items[k].items) do
				if manager.items[k].items[i][manager.t_order[uk].."myToCall"] then
					for j = 1,#(manager.items[k].items[i][manager.t_order[uk].."myToCall"]) do
						if manager.items[k].items[i][manager.t_order[uk].."myToCall"][j] ~= nil and manager.items[k].items[i][manager.t_order[uk].."myToCall"][j].Function ~= nil and manager.items[k].items[i][manager.t_order[uk].."myToCall"][j].CallBack ~= nil then
							local cb = manager.items[k].items[i][manager.t_order[uk].."myToCall"][j].CallBack
							if callback_manager[manager.t_order[uk].."callbacks"][cb] == nil then callback_manager[manager.t_order[uk].."callbacks"][cb] = {} end
							if manager.items[k].items[i][manager.t_order[uk].."myToCall"][j].params == nil then
								table.insert(callback_manager[manager.t_order[uk].."callbacks"][cb],{Function = manager.items[k].items[i][manager.t_order[uk].."myToCall"][j].Function})
							else
								table.insert(callback_manager[manager.t_order[uk].."callbacks"][cb],{Function = manager.items[k].items[i][manager.t_order[uk].."myToCall"][j].Function,params = manager.items[k].items[i][manager.t_order[uk].."myToCall"][j].params})
							end
						end
					end
				end
			end
		end
	end
end

function manager.Post_Make()	--没有传入参数。
	
end

return manager
