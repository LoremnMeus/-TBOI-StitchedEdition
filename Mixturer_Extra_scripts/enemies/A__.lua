local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local Damage_holder = require("Mixturer_Extra_scripts.others.Damage_holder")
local sound_tracker = require("Mixturer_Extra_scripts.auxiliary.sound_tracker")
local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")
local Base_holder = require("Mixturer_Extra_scripts.others.Base_holder")

local item = {
	ToCall = {},
    own_key = "EAN_XXXX_",
    entity = enums.Enemies.Cursed_Dip,
}

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NPC_INIT, params = 217,
Function = function(_,ent)
    if ent.Variant == item.entity then
        local s = ent:GetSprite()
        local d = ent:GetData()
        local anim = s:GetAnimation()
        s:Play("Idle",true)
        ent.PositionOffset = Vector(0,-3)
    end
end,
})

return item