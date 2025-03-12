local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")

local modReference
local manager = {
	items = {},
	functs = {},
}

function manager.Init(mod)
	modReference = mod
	manager.items[1] = require("Mixturer_Extra_scripts.grids.grid_doors")
	--manager.items[2] = require("Mixturer_Extra_scripts.grids.grid_trapdoor")
	manager.MakeItems()
end

function manager.MakeItems()	--没有传入参数。
	for i = 1,#manager.items do
		--[[
		if manager.items[i].ToCall then
			for j = 1,#(manager.items[i].ToCall) do
				if manager.items[i].ToCall[j] ~= nil and manager.items[i].ToCall[j].Function ~= nil and manager.items[i].ToCall[j].CallBack ~= nil then
					if manager.items[i].ToCall[j].params == nil then
						modReference:AddCallback(manager.items[i].ToCall[j].CallBack,manager.items[i].ToCall[j].Function)
					else
						modReference:AddCallback(manager.items[i].ToCall[j].CallBack,manager.items[i].ToCall[j].Function,manager.items[i].ToCall[j].params)
					end
				end
			end
		end
		--]]
		if manager.items[i].Tofun then		--对外接口。
			for j = 1,#manager.items[i].Tofun do
				if manager.items[i].Tofun[j].name then
					manager.functs[manager.items[i].Tofun[j].name] = manager.items[i].Tofun[j].Function
				end
			end
		end
	end
end

return manager
