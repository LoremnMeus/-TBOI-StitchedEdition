local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")

local item = {
	ToCall = {},
	actionsData = {},
	actionsData_r = {},
}

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_UPDATE, params = nil,
Function = function(_)
    for playerNum = 1, Game():GetNumPlayers() do
        local player = Game():GetPlayer(playerNum - 1)
        local key = tostring(player.ControllerIndex)
        item.actionsData[key] = item.actionsData[key] or {}
    end

    for index, controllerData in pairs(item.actionsData) do
        local allNil = true
        for action = ButtonAction.ACTION_LEFT, ButtonAction.ACTION_MENUTAB do
            controllerData[action] = controllerData[action] or {}
            local actionData = controllerData[action]
            if (Input.IsActionPressed(action, tonumber(index))) then		--理论上，只有一个input，对吧？
                actionData.ActionHoldTime = (actionData.ActionHoldTime or 0) + 1
                allNil = false
            else
                actionData.ActionHoldTime = nil
            end
        end
		local check_mov = false
		for action = ButtonAction.ACTION_LEFT,ButtonAction.ACTION_DOWN do
			if Input.IsActionPressed(action, tonumber(index)) then
				check_mov = true
			end
		end
		controllerData[50] = controllerData[50] or {}
		local actionData = controllerData[50]
		if check_mov then
			actionData.ActionHoldTime = (actionData.ActionHoldTime or 0) + 1
		else
            actionData.ActionHoldTime = nil
		end
		local check_dir = false
		for action = ButtonAction.ACTION_SHOOTLEFT,ButtonAction.ACTION_SHOOTDOWN do
			if Input.IsActionPressed(action, tonumber(index)) then
				check_dir = true
			end
		end
		controllerData[51] = controllerData[51] or {}
		local actionData = controllerData[51]
		if check_dir then
			actionData.ActionHoldTime = (actionData.ActionHoldTime or 0) + 1
		else
            actionData.ActionHoldTime = nil
		end
        if (allNil) then
            item.actionsData[index] = nil
        end
    end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_RENDER, params = nil,
Function = function(_)
    for playerNum = 1, Game():GetNumPlayers() do
        local player = Game():GetPlayer(playerNum - 1)
        local key = tostring(player.ControllerIndex)
        item.actionsData_r[key] = item.actionsData_r[key] or {}
    end
	if Game():IsPaused() == false then				--只在并非暂停的条件下工作
		for index, controllerData in pairs(item.actionsData_r) do
			local allNil = true
			for action = ButtonAction.ACTION_LEFT, ButtonAction.ACTION_MENUTAB do
				controllerData[action] = controllerData[action] or {}
				local actionData = controllerData[action]
				if (Input.IsActionPressed(action, tonumber(index))) then		--理论上，只有一个input，对吧？
					actionData.ActionHoldTime = (actionData.ActionHoldTime or 0) + 1
					allNil = false
				else
					actionData.ActionHoldTime = nil
				end
			end
			local check_mov = false
			for action = ButtonAction.ACTION_LEFT,ButtonAction.ACTION_DOWN do
				if Input.IsActionPressed(action, tonumber(index)) then
					check_mov = true
				end
			end
			controllerData[50] = controllerData[50] or {}
			local actionData = controllerData[50]
			if check_mov then
				actionData.ActionHoldTime = (actionData.ActionHoldTime or 0) + 1
			else
				actionData.ActionHoldTime = nil
			end
			local check_dir = false
			for action = ButtonAction.ACTION_SHOOTLEFT,ButtonAction.ACTION_SHOOTDOWN do
				if Input.IsActionPressed(action, tonumber(index)) then
					check_dir = true
				end
			end
			controllerData[51] = controllerData[51] or {}
			local actionData = controllerData[51]
			if check_dir then
				actionData.ActionHoldTime = (actionData.ActionHoldTime or 0) + 1
			else
				actionData.ActionHoldTime = nil
			end
			if (allNil) then
				item.actionsData_r[index] = nil
			end
		end
	end
end,
})

return item