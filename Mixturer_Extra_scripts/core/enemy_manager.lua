local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")

local modReference
local item = {
	items = {},
	params = {},
}

function item.Init(mod)
	modReference = mod
	
	table.insert(item.items,#item.items + 1,require("Mixturer_Extra_scripts.bosses.Boss_All"))
	table.insert(item.items,#item.items + 1,require("Mixturer_Extra_scripts.bosses.Boss_Mixturer"))
	table.insert(item.items,#item.items + 1,require("Mixturer_Extra_scripts.bosses.Danger_Data"))
	item.MakeItems()
end

function item.MakeItems()	--没有传入参数。
	for i = 1,#item.items do
		if item.items[i].Init then
			item.items[i].Init(modReference)
		end
	end
end

return item
