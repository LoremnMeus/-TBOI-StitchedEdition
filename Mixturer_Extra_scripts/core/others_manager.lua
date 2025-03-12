local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")

local modReference
local Others_manager = {
	items = {},
	params = {},
}

function Others_manager.Init(mod)
	modReference = mod
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.auxiliary.delay_buffer"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.core.savedata"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Input_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Console_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Dropping_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Attribute_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Charging_Bar_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Costume_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Consistance_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Base_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Room_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Screen_Filter"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Achievement_Display_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.GiantBook_holder"))
	table.insert(Others_manager.items,#Others_manager.items + 1,require("Mixturer_Extra_scripts.others.Parent_Collect_holder"))
	Others_manager.MakeItems()
end

function Others_manager.MakeItems()	--没有传入参数。
	for i = 1,#Others_manager.items do
		if Others_manager.items[i].Init then
			Others_manager.items[i].Init(modReference)
		end
	end
end

return Others_manager
