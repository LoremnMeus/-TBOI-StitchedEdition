local g = require("Mixturer_Extra_scripts.core.globals")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local Attribute_holder = require("Mixturer_Extra_scripts.others.Attribute_holder")
local sound_tracker = require("Mixturer_Extra_scripts.auxiliary.sound_tracker")
local GiantBook_holder = require("Mixturer_Extra_scripts.others.GiantBook_holder")

local item = {
	ToCall = {},
	post_ToCall = {},
}

function item.PlayAchievement(gfxroot,dur)
	if type(gfxroot) == "string" then gfxroot = {gfxroot = gfxroot,} end
	for u,v in pairs(gfxroot) do
		GiantBook_holder.PlayGiantBook({GfxRoot = v,Duration = dur or 90,
		work = function(s,info)
			if info.Appear ~= true then
				s:Play("Appear",true)
				info.Appear = true
				if info.GfxRoot then
					s:ReplaceSpritesheet(3,info.GfxRoot)
					s:LoadGraphics()
				end
			end
			if s:IsFinished("Appear") then
				if not info.SoundPlayed then
					sound_tracker.PlayStackedSound(SoundEffect.SOUND_BOOK_PAGE_TURN_12, 1, 1, false, 0,2)
					info.SoundPlayed = true
				end
				if info.Duration <= 0 then s:Play("Dissapear", true)
				else info.Duration = info.Duration - 1 end
			end
			if s:IsFinished("Dissapear") then return true end
		end,})
	end
end

--l local item = require("Mixturer_Extra_scripts.others.Achievement_Display_holder") item.PlayAchievement("gfx/ui/achievement/holier.png")

function item.Is_Finished_playing()
	return GiantBook_holder.Is_Finished_playing()
end

return item