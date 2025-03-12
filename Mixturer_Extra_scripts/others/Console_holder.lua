local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")

local item = {
	ToCall = {},
	pre_ToCall = {},
	target = {
		},
	c_s = Sprite(),
	c_s_ct_mode = 1,		--1代表自动控制
	c_s_render = true,
}

--理论中存在的问题：在不同的存档间不断调用这些函数，就会导致部分显示bug的发生。请不要用不能控制的东西来挑战程序的鲁棒性，谢谢。

function item.try_open_fullscreen_control()
	if save.elses.Fullscreen ~= nil and save.elses.Fullscreen == true then
		save.elses.Fullscreen = nil
	elseif Options.Fullscreen == false then
		save.elses.Fullscreen = Options.Fullscreen
	end
	Options.Fullscreen = true
end

function item.try_close_fullscreen_control()
	if save.elses.Fullscreen ~= nil and save.elses.Fullscreen == false then
		save.elses.Fullscreen = nil
	elseif Options.Fullscreen == true then
		save.elses.Fullscreen = Options.Fullscreen
	end
	Options.Fullscreen = false
end

function item.try_open_foundHUD_control()
	if save.elses.FoundHUD ~= nil and save.elses.FoundHUD == true then
		save.elses.FoundHUD = nil
	elseif Options.FoundHUD == false then
		save.elses.FoundHUD = Options.FoundHUD
	end
	Options.FoundHUD = true
end

function item.try_close_foundHUD_control()
	if save.elses.FoundHUD ~= nil and save.elses.FoundHUD == false then
		save.elses.FoundHUD = nil
	elseif Options.FoundHUD == true then
		save.elses.FoundHUD = Options.FoundHUD
	end
	Options.FoundHUD = false
end

function item.try_open_mouse_control()
	if save.elses.MouseControl ~= nil and save.elses.MouseControl == true then
		save.elses.MouseControl = nil
	elseif Options.MouseControl == false then
		save.elses.MouseControl = Options.MouseControl
	end
	Options.MouseControl = true
end

function item.try_close_mouse_control()
	if save.elses.MouseControl ~= nil and save.elses.MouseControl == false then
		save.elses.MouseControl = nil
	elseif Options.MouseControl == true then
		save.elses.MouseControl = Options.MouseControl
	end
	Options.MouseControl = false
end

function item.try_open_console()
	if save.elses.DebugConsoleEnabled ~= nil and save.elses.DebugConsoleEnabled == true then
		save.elses.DebugConsoleEnabled = nil
	elseif Options.DebugConsoleEnabled == false then
		save.elses.DebugConsoleEnabled = Options.DebugConsoleEnabled
	end
	Options.DebugConsoleEnabled = true
end

function item.try_close_console()
	if save.elses.DebugConsoleEnabled ~= nil and save.elses.DebugConsoleEnabled == false then
		save.elses.DebugConsoleEnabled = nil
	elseif Options.DebugConsoleEnabled == true then
		save.elses.DebugConsoleEnabled = Options.DebugConsoleEnabled
	end
	Options.DebugConsoleEnabled = false
end

item.c_s:Load("gfx/ui/special ui/cursor.anm2")
item.c_s:Play("Idle",true)

table.insert(item.pre_ToCall,#item.pre_ToCall + 1,{CallBack = ModCallbacks.MC_GET_SHADER_PARAMS, params = nil,
Function = function(_,name)
	if name == "Mixturer_HelpfulShader" then
		if save.elses.MouseControl ~= nil and save.elses.MouseControl == false and Options.MouseControl == true then		--需要绘制鼠标
			if item.c_s_ct_mode == 1 then
				if Input.IsMouseBtnPressed(0) then
					item.c_s:Play("Clicked",true)
				else
					item.c_s:Play("Idle",true)
				end
			end
			if item.c_s_render == true then
				item.c_s:Render(Isaac.WorldToScreen(Input.GetMousePosition(true)),Vector(0,0),Vector(0,0))
			end
		end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_GAME_EXIT, params = nil,		--不可控的原因主要在这里。需要保存这些内容以保证不会出错。
Function = function(_,shouldsave)
	if shouldsave then
		if save.elses.DebugConsoleEnabled ~= nil then
			Options.DebugConsoleEnabled = save.elses.DebugConsoleEnabled
		end
		if save.elses.MouseControl ~= nil then
			Options.MouseControl = save.elses.MouseControl
		end
		if save.elses.FoundHUD ~= nil then
			Options.FoundHUD = save.elses.FoundHUD
		end
		if save.elses.Fullscreen ~= nil then
			Options.Fullscreen = save.elses.Fullscreen
		end
	else
		if save.elses.DebugConsoleEnabled ~= nil then
			Options.DebugConsoleEnabled = save.elses.DebugConsoleEnabled
			save.elses.DebugConsoleEnabled = nil
		end
		if save.elses.MouseControl ~= nil then
			Options.MouseControl = save.elses.MouseControl
			save.elses.MouseControl = nil
		end
		if save.elses.FoundHUD ~= nil then
			Options.FoundHUD = save.elses.FoundHUD
			save.elses.FoundHUD = nil
		end
		if save.elses.Fullscreen ~= nil then
			Options.Fullscreen = save.elses.Fullscreen
			save.elses.Fullscreen = nil
		end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_GAME_STARTED, params = nil,
Function = function(_,continue)
	if continue then
		if save.elses.DebugConsoleEnabled ~= nil then
			if Options.DebugConsoleEnabled == not(save.elses.DebugConsoleEnabled) then
				save.elses.DebugConsoleEnabled = nil
			else
				Options.DebugConsoleEnabled = not(save.elses.DebugConsoleEnabled)
			end
		end
		if save.elses.MouseControl ~= nil then
			if Options.MouseControl == not(save.elses.MouseControl) then
				save.elses.MouseControl = nil
			else
				Options.MouseControl = not(save.elses.MouseControl)
			end
		end
		if save.elses.FoundHUD ~= nil then
			if Options.FoundHUD == not(save.elses.FoundHUD) then
				save.elses.FoundHUD = nil
			else
				Options.FoundHUD = not(save.elses.FoundHUD)
			end
		end
		if save.elses.Fullscreen ~= nil then
			if Options.Fullscreen == not(save.elses.Fullscreen) then
				save.elses.Fullscreen = nil
			else
				Options.Fullscreen = not(save.elses.Fullscreen)
			end
		end
	else
		if save.elses.DebugConsoleEnabled ~= nil then
			--Options.DebugConsoleEnabled = save.elses.DebugConsoleEnabled
			save.elses.DebugConsoleEnabled = nil
		end
		if save.elses.MouseControl ~= nil then
			--Options.MouseControl = save.elses.MouseControl
			save.elses.MouseControl = nil
		end
		if save.elses.FoundHUD ~= nil then
			--Options.FoundHUD = save.elses.FoundHUD
			save.elses.FoundHUD = nil
		end
		if save.elses.Fullscreen ~= nil then
			--Options.Fullscreen = save.elses.Fullscreen
			save.elses.Fullscreen = nil
		end
	end
end,
})

function item.console_speak(tbl)
	local word = nil
	if type(tbl) == "table" then
		word = tbl.word
		if tbl.Special then word = tbl.Special() end
	else
		word = tbl
	end
	item.try_open_console()
	local p_DebugConsoleEnabled = Options.DebugConsoleEnabled
	local p_FadedConsoleDisplay = Options.FadedConsoleDisplay
	Options.FadedConsoleDisplay = true
	if word ~= nil then
		print(word)
	end
	Options.FadedConsoleDisplay = p_FadedConsoleDisplay
	Options.DebugConsoleEnabled = p_DebugConsoleEnabled
end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_EXECUTE_CMD, params = nil,
Function = function(_,str,params)
	if string.lower(str) == "Mixturer" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, str)
		end
		if args[1] then
		end
	end
end,
})

return item