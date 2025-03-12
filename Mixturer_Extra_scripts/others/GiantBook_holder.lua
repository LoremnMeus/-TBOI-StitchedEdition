local g = require("Mixturer_Extra_scripts.core.globals")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local Attribute_holder = require("Mixturer_Extra_scripts.others.Attribute_holder")
local sound_tracker = require("Mixturer_Extra_scripts.auxiliary.sound_tracker")

local item = {
	ToCall = {},
	post_ToCall = {},
	start = false,
	own_key = "GiantBook_holder_",
	Queue = {},
}

local BookSpr = Sprite()
BookSpr:Load("gfx/ui/achievement display api/achievements.anm2")
BookSpr.PlaybackSpeed = 0.5

local function pre_load_info()
	local info = item.Queue[1]
	if info.Loader and info.Anim then BookSpr:Load(info.Loader) BookSpr:Play(info.Anim,true)
	else BookSpr:Load("gfx/ui/achievement display api/achievements.anm2") end
	local speed = info.PlaybackSpeed or 0.5
	BookSpr.PlaybackSpeed = speed
	auxi.check_if_any(info.Init,BookSpr,info)
end

table.insert(item.post_ToCall,#item.post_ToCall + 1,{CallBack = ModCallbacks.MC_POST_RENDER, params = nil,
Function = function(_)
	if item.Queue[1] then
		local info = item.Queue[1]
		if not Game():IsPaused() then
			if (ModConfigMenu and ModConfigMenu.IsVisible) then ModConfigMenu.CloseConfigMenu()	end
			if (DeadSeaScrollsMenu and DeadSeaScrollsMenu.OpenedMenu) then DeadSeaScrollsMenu:CloseMenu(true, true)	end
		end
		if item.start ~= true then
			auxi.time_stop(item.own_key)
			for playerNum = 1, Game():GetNumPlayers() do
				local player = Game():GetPlayer(playerNum - 1)
				local d = player:GetData()
				if d[item.own_key.."ctrl_succ"] then Attribute_holder.try_rewind_attribute(player,"ControlsEnabled",d[item.own_key.."ctrl_succ"]) end
				if d[item.own_key.."vel_succ"] then Attribute_holder.try_rewind_attribute(player,"Velocity",d[item.own_key.."vel_succ"]) end
				d[item.own_key.."ctrl_succ"] = Attribute_holder.try_hold_attribute(player,"ControlsEnabled",false)
				d[item.own_key.."vel_succ"] = Attribute_holder.try_hold_attribute(player,"Velocity",Vector(0,0))
			end
			pre_load_info()
			item.start = true
		end
		local succ = BookSpr:IsFinished(BookSpr:GetAnimation())
		if info.work then succ = auxi.check_if_any(info.work,BookSpr,info) end
		if succ then
			table.remove(item.Queue, 1)
			if (not item.Queue[1]) then
				item.start = nil
				auxi.time_free(item.own_key)
				for playerNum = 1, Game():GetNumPlayers() do
					local player = Game():GetPlayer(playerNum - 1)
					local d = player:GetData()
					if d[item.own_key.."ctrl_succ"] then Attribute_holder.try_rewind_attribute(player,"ControlsEnabled",d[item.own_key.."ctrl_succ"]) end d[item.own_key.."ctrl_succ"] = nil
					if d[item.own_key.."vel_succ"] then Attribute_holder.try_rewind_attribute(player,"Velocity",d[item.own_key.."vel_succ"]) end d[item.own_key.."vel_succ"] = nil
				end
			else pre_load_info() end
		else
			BookSpr:Render(auxi.GetScreenCenter(),Vector(0,0),Vector(0,0))
			BookSpr:Update()
		end
	end
end,
})

function item.PlayGiantBook(params)
	table.insert(item.Queue,#item.Queue + 1,params)
end

function item.Is_Finished_playing()
	return item.start ~= true
end

--l local GiantBook_holder = require("Qing_Extra_scripts.others.GiantBook_holder") GiantBook_holder.PlayGiantBook({Loader = "gfx/ui/giantbook/giantbook.anm2",Anim = "Shake",Init = function(s,info) s:ReplaceSpritesheet(0,"gfx/ui/giantbook/giantbook_rebirth_006_d100.png") s:LoadGraphics() end})

return item