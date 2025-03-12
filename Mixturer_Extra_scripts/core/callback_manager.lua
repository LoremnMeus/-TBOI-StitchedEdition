local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")

local modReference
local manager = {
	items = {},
	callbacks = {},
	pre_callbacks = {},
	post_callbacks = {},
	t_order = {"pre_","","post_",},
}

function manager.Init(mod)		--可以添加callback的都塞在这里。
	modReference = mod
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.callbacks.collectible_holder"))
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.callbacks.teleport_holder"))
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.callbacks.next_level_holder"))
	table.insert(manager.items,#manager.items + 1,require("Mixturer_Extra_scripts.callbacks.every_entity_holder"))
end

function manager.work(name,funct,checkout)
	for uk = 1,3 do
		if manager[manager.t_order[uk].."callbacks"][name] then
			for u,v in pairs(manager[manager.t_order[uk].."callbacks"][name]) do
				if v.Function then
					local res = funct(v.Function,v.params)
					if checkout ~= nil and res ~= nil and res == checkout then
						return checkout
					end
				end
			end
		end
	end
end

return manager
