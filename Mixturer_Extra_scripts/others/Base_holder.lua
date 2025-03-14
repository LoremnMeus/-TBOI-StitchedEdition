local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local grid_trapdoor = require("Mixturer_Extra_scripts.grids.grid_trapdoor")
local mix = require("Mixturer_Extra_scripts.bosses.Boss_Mixturer")
--l local base = require("Mixturer_Extra_scripts.others.Base_holder") base.Stop = true
local item = {
	ToCall = {},
	myToCall = {},
	own_key = "Stitched_Base_holder_",
	validTags = {
		boss = {default = 2,default2 = 0.3,},
		noboss = {default = 0},
		sin = {default = -1},
		larry = {default = 0},
		stone = {default = 0},
		alt = {default = 0},
	},
	DefaultValue = {
		mixsamespawner = 1,
		mixspawner = 0.2,
		mixspawneronkill = 0.2,
	},
	CommandLists = {
		["default"] = {
			"mixchance",
			"mixfollowlevel",
			"mixhardlevel",
			"mixbaselevel",
			"mixtaglevel clear",
			"mixspawner clear",
			"mixspawneronkill clear",
			"mixsamespawner clear",
			"mixforce",
			"mixforcechance",
			"mixsameinroom",
			"mixforceboss",
			"mixforcenoboss",
			"mixforcetag clear",
			"mixhprate clear",
		},
		["baby"] = {
			"mixsetmode default",
			"mixhardlevel -1",
			"mixforcetag noboss 1",
			"mixchance 0.5",
			"mixspawner 0",
			"mixspawneronkill 0",
			"mixhprate main 1",
			"mixhprate nomain 0",
		},
		["chaos"] = {
			"mixsetmode default",
			"mixhardlevel 10",
			"mixforcetag boss 0.8",
			"mixforcetag noboss 1",
			"mixhprate main 1",
			"mixhprate nomain 0",
		},
		["envy"] = {
			"mixsetmode default",
			"mixforce 51 51.10 51.20 51.1 51.11 51.21",
			"mixspawneronkill 51-1 51.10-1 51.20-1 51.1-1 51.11-1 51.21-1",
			--"mixsamespawner 51-1 51.10-1 51.20-1 51.1-1 51.11-1 51.21-1",
			"mixhprate main 1",
			"mixhprate nomain 0",
		},
	},
}

function item.get_all_tags()
	local ret = ""
	for u,v in pairs(item.validTags) do
		if ret == "" then ret = u
		else ret = ret .. ", ".. u end
	end
	return ret
end

--在这里处理敌人的生成/替换工作
function item.init(_,ent)
	if mix.invisible_flag ~= true and item.Stop ~= true then	-- and Game():GetRoom():GetFrameCount() <= 0
		if ent.Type ~= 463 then
			local room = Game():GetRoom()
			if ent.Type == 853 and room:GetFrameCount() > 0 then return end
			--else
			local info = mix.fast_search("Left",ent.Type,ent.Variant,ent.SubType)
			local succ = true local another_id = nil local infoid = nil local nomainspawn = false local still_spawn = nil
			if ent.SpawnerEntity or mix.spawnerflag then	--需要限制不能无限继续生成下去
				local se = mix.spawnerflag or ent.SpawnerEntity 
				local seinfo = mix.fast_search("Left",se.Type,se.Variant,se.SubType)
				local force_spawn = nil
				local sed = se:GetData()
				--print(se.Type.." "..se.Variant)
				if sed[mix.own_key.."rlinkee"] then 
					--is_death_trigger = true
					another_id = sed[mix.own_key.."rlinkee"].anotherid
					infoid = sed[mix.own_key.."rlinkee"].infoid
				elseif sed[mix.own_key.."linkee"] then 
					another_id = sed[mix.own_key.."linkee"].anotherid
					infoid = sed[mix.own_key.."linkee"].infoid
				end
				local tbl = {}
				for u,v in pairs(item.DefaultValue) do
					save.ControlData[u] = save.ControlData[u] or {global = v,}
					tbl[u] = save.ControlData[u].global or v
				end

				if auxi.check_if_any(info.Force_Spawn_Info,ent,se) then force_spawn = true end

				local ininfo = mix.targets["Left"][infoid] or {}
				local iinfo = mix.targets["Left"][another_id] or {}
				if seinfo.only_split then 
					tbl.mixspawneronkill = auxi.check_if_any(seinfo.only_split,se,seinfo,iinfo) 
				end
				if seinfo.Nature_Spawner then 
					tbl.mixspawner = auxi.check_if_any(seinfo.Nature_Spawner,se) 
					still_spawn = true
				end
				if another_id and infoid then
					--local entry = tostring(iinfo.type).."."..tostring(iinfo.variant).."."..tostring(iinfo.subtype)
					local entry = tostring(ininfo.type).."."..tostring(ininfo.variant).."."..tostring(ininfo.subtype)
					for u,v in pairs(item.DefaultValue) do
						if save.ControlData[u][entry] then
							tbl[u] = save.ControlData[u][entry]
						end
					end
					if iinfo.NotSpawn then another_id = nil end
				end
				
				if not another_id and not still_spawn then succ = false end
				if iinfo.clear_another then another_id = nil end
				if seinfo.Nature_Spawner then another_id = nil end
				if auxi.random_1() > tbl.mixsamespawner then another_id = nil end
				--print("Deathtrigger:"..tostring(is_death_trigger))
				nomainspawn = true
				if force_spawn then succ = true nomainspawn = nil
				elseif se:IsDead() then
					if (auxi.random_1() > tbl.mixspawneronkill) then succ = false end
				else 
					if auxi.random_1() > tbl.mixspawner then succ = false end
				end
				if auxi.check_if_any(info.Force_Not_Spawn_Info,ent,se) then succ = false end
			end
			--if succ then print("succ1 "..ent.Type) end
			if succ and info.NoKill and room:GetFrameCount() <= 0 and room:IsClear() then succ = false end
			if succ then
				local tgs = auxi.getothers(nil,463,enums.Enemies.Stitched)
				for u_,v_ in pairs(tgs) do
					local vd = v_:GetData()
					for u,v in pairs(mix.targets) do
						if vd[mix.own_key.."effect"] and vd[mix.own_key.."effect"][u] and vd[mix.own_key.."effect"][u].Deli and auxi.check_all_exists(vd[mix.own_key.."effect"][u].ent) then 
							if vd[mix.own_key.."effect"][u].ent:GetSprite():GetFilename() == ent:GetSprite():GetFilename() then
								succ = nil
								break
							end
						end
					end
				end
			end
			--if succ then print("succ2 "..ent.Type) end
			save.ControlData.mixchance = save.ControlData.mixchance or {global = 1,}
			local mixchance = save.ControlData.mixchance.global or 1
			if auxi.random_1() > mixchance then succ = false end
			if succ then
				--print("Try Spawn "..ent.Type.." "..ent.Variant.." "..ent.SubType)
				mix.generate_mixture(ent,{tg = auxi.choose("Left","Right"),spawn_once = true,make_another = true,another_infoid = another_id,nomainspawn = nomainspawn,})		--no_conduct = true,
			end
			--end
		else
		end
	end
end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NPC_INIT, params = nil,
Function = item.init,
})

function item.check_lr(str)
	if str == "l" or str == "left" then return "Left" end
	if str == "r" or str == "right" then return "Right" end
	return nil
end

function item.parse_entity_spec(spec)
    local parts = {}
    for part in string.gmatch(spec, "([^.]+)") do
        table.insert(parts, tonumber(part) or 0)
    end
	local ret = {
        type = parts[1] or 0,
        variant = parts[2] or 0,
        subtype = parts[3] or 0
    }
	return tostring(ret.type).."."..tostring(ret.variant).."."..tostring(ret.subtype)
end

function item.parse_entity_command(params, default_chance)
    local args = {}
    for str in string.gmatch(params, "([^ ]+)") do
        table.insert(args, str)
    end
    
    if #args == 0 then return nil end
    
    -- Handle clear command
    if args[1] == "clear" then
        return {clear = true}
    end
    
    -- Handle global chance setting
    if #args == 1 then
        local chance = tonumber(args[1] or default_chance)
        if chance then
            return {
                global = true,
                chance = math.min(math.max(chance, 0), 1)
            }
        end
    end
    
    -- Handle entity-specific settings
    local settings = {}
    for _, arg in ipairs(args) do
        local entity_part, chance_part = arg:match("^([^%-]+)%-?(.*)$")
        
		if entity_part and chance_part then
			local entity_spec = item.parse_entity_spec(entity_part)
			local chance = tonumber(chance_part) or default_chance
        
			settings[entity_spec] = chance
		end
    end
    
    return settings
end

function item.execute_command(_,cmd,params,NoPrint)
	if string.lower(cmd) == "mix" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		if args[1] then
			if args[1] == "stop" then
				item.Stop = true
				print("Stop Now")
			end
			if args[1] == "continue" then
				item.Stop = nil
				print("Continue Now")
			end
		end
	end

	if string.lower(cmd) == "mixchance" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		local chance = tonumber(args[1] or 1)
		local clampedChance = math.min(math.max(chance, 0), 1)  -- Clamp between 0 and 1
		
		-- Save setting
		save.ControlData.mixchance = {global = clampedChance,}
		
		-- Output feedback with range and default info
		if chance == clampedChance then
			print("Stitching chance set to: " .. clampedChance .. " (Valid range: 0-1, Default: 1)")
		else
			print("Input value out of range! Adjusted to: " .. clampedChance .. " (Valid range: 0-1, Default: 1)")
		end
	end

	-- mixfollowlevel implementation
	if string.lower(cmd) == "mixfollowlevel" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		local chance = tonumber(args[1] or 0)
		local clampedChance = math.min(math.max(chance, 0), 1)  -- Clamp between 0 and 1
		
		save.ControlData.mixfollowlevel = clampedChance
		
		if chance == clampedChance then
			print("Follow level chance set to: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
		else
			print("Input value out of range! Adjusted to: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
		end
	end

	-- mixhardlevel implementation
	if string.lower(cmd) == "mixhardlevel" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		local level = tonumber(args[1] or 0)
		local clampedLevel = math.max(level, -10)  -- Minimum value is -10
		
		save.ControlData.mixhardlevel = clampedLevel
		
		-- Check and adjust baselevel if necessary
		if save.ControlData.mixbaselevel and save.ControlData.mixbaselevel > clampedLevel then
			save.ControlData.mixbaselevel = clampedLevel
			print("Base level adjusted to match hard level: " .. clampedLevel)
		end
		
		-- Check and adjust hardlevel if necessary
		if save.ControlData.mixbaselevel and clampedLevel < save.ControlData.mixbaselevel then
			save.ControlData.mixbaselevel = clampedLevel
			print("Base level adjusted to match hard level: " .. clampedLevel)
		end

		if level == clampedLevel then
			print("Hard level set to: " .. clampedLevel .. " (Minimum value: -10, Default: 0)")
		else
			print("Input value out of range! Adjusted to: " .. clampedLevel .. " (Minimum value: -10, Default: 0)")
		end
	end

	-- mixbaselevel implementation
	if string.lower(cmd) == "mixbaselevel" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		local level = tonumber(args[1] or -999)
		local clampedLevel = math.max(level, -999)  -- Minimum value is -999
		
		save.ControlData.mixbaselevel = clampedLevel
		
		-- Check and adjust hardlevel if necessary
		if save.ControlData.mixhardlevel and clampedLevel > save.ControlData.mixhardlevel then
			save.ControlData.mixhardlevel = clampedLevel
			print("Hard level adjusted to match base level: " .. clampedLevel)
		end
		
		if level == clampedLevel then
			print("Base level set to: " .. clampedLevel .. " (Minimum value: -999, Default: -999)")
		else
			print("Input value out of range! Adjusted to: " .. clampedLevel .. " (Minimum value: -999, Default: -999)")
		end
	end

	-- mixtaglevel implementation
	if string.lower(cmd) == "mixtaglevel" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		if #args >= 1 then
			local tag = string.lower(args[1])
			local level = tonumber(args[2] or 0)
			
			if item.validTags[tag] then
				save.ControlData.mixtaglevel = save.ControlData.mixtaglevel or {boss = 2,sin = -1,}
				save.ControlData.mixtaglevel[tag] = level
				print("Tag level for '" .. tag .. "' set to: " .. level .. " (Default: " .. item.validTags[tag].default .. ")")
			elseif tag == "clear" then
				save.ControlData.mixtaglevel = nil
				print("Tag level cleared!")
			else
				print("Invalid tag! Available tags: "..item.get_all_tags())
			end
		else
			print("Usage: mixtaglevel tag XX (e.g., mixtaglevel boss 2)")
		end
	end

	-- mixspawner implementation
	if string.lower(cmd) == "mixspawner" and params ~= nil then
		local settings = item.parse_entity_command(string.lower(params), 0.2)
		
		if settings then
			if settings.clear then
				save.ControlData.mixspawner = {}
				print("All spawner settings cleared")
			elseif settings.global then
				save.ControlData.mixspawner = save.ControlData.mixspawner or {}
				save.ControlData.mixspawner.global = settings.chance
				print("Global spawner chance set to: " .. settings.chance)
			else
				save.ControlData.mixspawner = save.ControlData.mixspawner or {}
				local tot = 0
				for u,v in pairs(settings) do
					save.ControlData.mixspawner[u] = v tot = tot + 1
				end
				print("Spawner settings updated with " .. tot .. " entries")
			end
		else
			print("Usage:")
			print("  mixspawner clear - Clear all settings")
			print("  mixspawner YY - Set global chance (0-1)")
			print("  mixspawner XX.XX.XX-YY [XX.XX.XX-YY ...] - Set entity-specific chances")
		end
	end

	-- mixspawneronkill implementation
	if string.lower(cmd) == "mixspawneronkill" and params ~= nil then
		local settings = item.parse_entity_command(string.lower(params), 0.2)
		
		if settings then
			if settings.clear then
				save.ControlData.mixspawneronkill = {}
				print("All spawner on kill settings cleared")
			elseif settings.global then
				save.ControlData.mixspawneronkill = save.ControlData.mixspawneronkill or {}
				save.ControlData.mixspawneronkill.global = settings.chance
				print("Global spawner on kill chance set to: " .. settings.chance)
			else
				save.ControlData.mixspawneronkill = save.ControlData.mixspawneronkill or {}
				local tot = 0
				for u,v in pairs(settings) do
					save.ControlData.mixspawneronkill[u] = v tot = tot + 1
				end
				print("Spawner on kill settings updated with " .. tot .. " entries")
			end
		else
			print("Usage:")
			print("  mixspawneronkill clear - Clear all settings")
			print("  mixspawneronkill YY - Set global chance (0-1)")
			print("  mixspawneronkill XX.XX.XX-YY [XX.XX.XX-YY ...] - Set entity-specific chances")
		end
	end

	-- mixsamespawner implementation
	if string.lower(cmd) == "mixsamespawner" and params ~= nil then
		local settings = item.parse_entity_command(string.lower(params), 1)
		
		if settings then
			if settings.clear then
				save.ControlData.mixsamespawner = {}
				print("All same spawner settings cleared")
			elseif settings.global then
				save.ControlData.mixsamespawner = save.ControlData.mixsamespawner or {}
				save.ControlData.mixsamespawner.global = settings.chance
				print("Global same spawner chance set to: " .. settings.chance)
			else
				save.ControlData.mixsamespawner = save.ControlData.mixsamespawner or {}
				local tot = 0
				for u,v in pairs(settings) do
					save.ControlData.mixsamespawner[u] = v tot = tot + 1
				end
				print("Same spawner settings updated with " .. tot .. " entries")
			end
		else
			print("Usage:")
			print("  mixsamespawner clear - Clear all settings")
			print("  mixsamespawner YY - Set global chance (0-1)")
			print("  mixsamespawner XX.XX.XX-YY [XX.XX.XX-YY ...] - Set entity-specific chances")
		end
	end

	-- mixforce implementation
	if string.lower(cmd) == "mixforce" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		if #args == 0 then
			save.ControlData.mixforce = nil
			print("Force stitching targets cleared")
		else
			local forceTable = {}
			for _, arg in ipairs(args) do
				local parts = {}
				for part in string.gmatch(arg, "([^%-]+)") do
					table.insert(parts, part)
				end
				
				local entityParts = {}
				for part in string.gmatch(parts[1], "([^.]+)") do
					table.insert(entityParts, tonumber(part) or 0)
				end
				
				local weight = tonumber(parts[2] or 1)
				if weight and weight > 0 then
					local infoid = mix.fast_search("Left",entityParts[1] or 0,entityParts[2] or 0,entityParts[3] or 0).id or mix.fast_search("Left",entityParts[1] or 0,entityParts[2] or 0,0).id
					if infoid then table.insert(forceTable, {id = infoid,weigh = math.ceil(weight)}) end
				end
			end
			
			if #forceTable > 0 then
				save.ControlData.mixforce = forceTable
				print("Force stitching targets set with " .. #forceTable .. " entries")
			else
				save.ControlData.mixforce = nil
				print("No valid force stitching targets found, cleared")
			end
		end
	end

	-- mixforcechance implementation
	if string.lower(cmd) == "mixforcechance" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		local chance = tonumber(args[1] or 1)
		local clampedChance = math.min(math.max(chance, 0), 1)
		
		save.ControlData.mixforcechance = clampedChance
		
		if chance == clampedChance then
			print("Force stitching chance set to: " .. clampedChance .. " (Valid range: 0-1, Default: 1)")
		else
			print("Input value out of range! Adjusted to: " .. clampedChance .. " (Valid range: 0-1, Default: 1)")
		end
	end

	-- mixsameinroom implementation
	if string.lower(cmd) == "mixsameinroom" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		-- Parse chance (YY) and count (XX)
		local chance = tonumber(args[1] or 0)
		local count = tonumber(args[2] or 1)
		
		-- Clamp values
		local clampedChance = math.min(math.max(chance, 0), 1)
		local clampedCount = math.min(20,math.max(count, 1))  -- Minimum 1 target
		
		-- Save settings
		save.ControlData.mixsameinroom = {
			chance = clampedChance,
			count = clampedCount
		}
		
		-- Output feedback
		if chance == clampedChance and count == clampedCount then
			print("Same in room settings updated:")
			print("  Chance: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
			print("  Target count: " .. clampedCount .. " (Minimum: 1, Maximum: 20, Default: 1)")
		else
			print("Same in room settings adjusted:")
			if chance ~= clampedChance then
				print("  Chance adjusted to: " .. clampedChance .. " (Valid range: 0-1)")
			end
			if count ~= clampedCount then
				print("  Target count adjusted to: " .. clampedCount .. " (Minimum: 1, Maximum: 20)")
			end
		end
	end

	-- mixsameinlevel implementation
	if string.lower(cmd) == "mixsameinlevel" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		-- Parse chance (YY) and count (XX)
		local chance = tonumber(args[1] or 0)
		local count = tonumber(args[2] or 1)
		
		-- Clamp values
		local clampedChance = math.min(math.max(chance, 0), 1)
		local clampedCount = math.min(20,math.max(count, 1))  -- Minimum 1 target
		
		-- Save settings
		save.ControlData.mixsameinlevel = {
			chance = clampedChance,
			count = clampedCount
		}
		
		-- Output feedback
		if chance == clampedChance and count == clampedCount then
			print("Same in level settings updated:")
			print("  Chance: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
			print("  Target count: " .. clampedCount .. " (Minimum: 1, Maximum: 20, Default: 1)")
		else
			print("Same in level settings adjusted:")
			if chance ~= clampedChance then
				print("  Chance adjusted to: " .. clampedChance .. " (Valid range: 0-1)")
			end
			if count ~= clampedCount then
				print("  Target count adjusted to: " .. clampedCount .. " (Minimum: 1, Maximum: 20)")
			end
		end
	end

	-- mixforceboss implementation
	if string.lower(cmd) == "mixforceboss" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		local chance = tonumber(args[1] or 0)
		local clampedChance = math.min(math.max(chance, 0), 1)
		
		save.ControlData.mixforceboss = clampedChance
		
		if chance == clampedChance then
			print("Force boss chance set to: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
		else
			print("Input value out of range! Adjusted to: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
		end
	end

	-- mixforcenoboss implementation
	if string.lower(cmd) == "mixforcenoboss" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		local chance = tonumber(args[1] or 0)
		local clampedChance = math.min(math.max(chance, 0), 1)
		
		save.ControlData.mixforcenoboss = clampedChance
		
		if chance == clampedChance then
			print("Force non-boss chance set to: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
		else
			print("Input value out of range! Adjusted to: " .. clampedChance .. " (Valid range: 0-1, Default: 0)")
		end
	end

	-- mixforcetag implementation
	if string.lower(cmd) == "mixforcetag" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		if #args >= 1 then
			local tag = string.lower(args[1])
			local chance = tonumber(args[2] or (item.validTags[tag] or {}).default2 or 0)
			local clampedChance = math.min(math.max(chance, 0), 1)
			
			if item.validTags[tag] then
				save.ControlData.mixforcetag = save.ControlData.mixforcetag or {boss = 0.3,}
				save.ControlData.mixforcetag[tag] = clampedChance
				if chance == clampedChance then
					print("Force tag for '" .. tag .. "' chance set to: " .. clampedChance .. " (Valid range: 0-1, Default: "..tostring(item.validTags[tag].default2 or 0)..")")
				else
					print("Input value out of range! Adjusted to: " .. clampedChance .. " (Valid range: 0-1, Default: "..tostring(item.validTags[tag].default2 or 0)..")")
				end
			elseif tag == "clear" then
				save.ControlData.mixforcetag = nil
				print("Tags cleared!")
			else
				print("Invalid tag! Available tags: "..item.get_all_tags())
			end
		else
			print("Usage: mixforcetag tag YY (e.g., mixforcetag boss 0.5)")
		end
	end

	if string.lower(cmd) == "mixspawn" or string.lower(cmd) == "mixspawnwith" and params ~= nil then
		local spawnwith = (string.lower(cmd) == "mixspawnwith")
		local args = {}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		if args[1] then
			-- 解析左半身参数
			local leftParts = {}
			for part in string.gmatch(args[1], "([^.]+)") do
				table.insert(leftParts, tonumber(part) or 0)
			end
			local leftType = leftParts[1] or 0
			local leftVariant = leftParts[2] or 0
			local leftSubtype = leftParts[3] or 0
			
			-- 解析右半身参数
			local rightParts = {}
			if args[2] then
				for part in string.gmatch(args[2], "([^.]+)") do
					table.insert(rightParts, tonumber(part) or 0)
				end
			end
			local rightType = rightParts[1] or 0
			local rightVariant = rightParts[2] or 0
			local rightSubtype = rightParts[3] or 0
			
			-- 解析方向参数
			local leftSide = item.check_lr(args[3] or "")
			local rightSide = item.check_lr(args[4] or "")
			
			-- 生成缝合体
			local room = Game():GetRoom()
			local pos = room:FindFreeTilePosition(room:GetCenterPos(),40)
			local q = Isaac.Spawn(mix.entity_type, mix.entity, 0, pos, Vector(0,0), nil):ToNPC()
			local d = q:GetData()
			
			-- 设置缝合效果
			d[mix.own_key.."effect"] = {
				spawn_once = true,
				max_mul = 5,
			}
			
			local linfo = mix.find_entity(leftType, leftVariant, leftSubtype)
			if not linfo.id then linfo = mix.find_entity(leftType, leftVariant, 0) end
			local rinfo = mix.find_entity(rightType, rightVariant, rightSubtype)
			if not rinfo.id then rinfo = mix.find_entity(rightType, rightVariant, 0) end

			if linfo.id then
				d[mix.own_key.."effect"]["Left"] = {
					infoid = linfo.id,
					forceSide = leftSide,
				}
			elseif rinfo.id and spawnwith then
				local real_linfo = mix.search_in("Left",{v = rinfo,})
				d[mix.own_key.."effect"]["Left"] = {
					infoid = real_linfo.id,
					forceSide = leftSide,
				}
			end
			
			if rinfo.id then
				d[mix.own_key.."effect"]["Right"] = {
					infoid = rinfo.id,
					forceSide = rightSide,
				}
			elseif linfo.id and spawnwith then
				local real_rinfo = mix.search_in("Right",{v = linfo,})
				d[mix.own_key.."effect"]["Right"] = {
					infoid = real_rinfo.id,
					forceSide = rightSide,
				}
			end
		else
			print("No Target!")
		end
	end

	-- mixhprate implementation
	if string.lower(cmd) == "mixhprate" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		if #args >= 2 then
			local target = args[1]  -- "main" or "nomain"
			local weight = tonumber(args[2] or 1) or 1
			
			-- Validate input
			if (target == "main" or target == "nomain") and weight and weight >= 0 then
				-- Initialize if not exists
				save.ControlData.mixhprate = save.ControlData.mixhprate or {
					main = 4,  -- Default main weight
					nomain = 1  -- Default nomain weight
				}
				
				-- Update weight
				if target == "main" then
					save.ControlData.mixhprate.main = weight
				else
					save.ControlData.mixhprate.nomain = weight
				end
				
				-- Calculate total weight
				local total = save.ControlData.mixhprate.main + save.ControlData.mixhprate.nomain
				
				-- Output feedback
				print("HP rate settings updated:")
				print("  Main weight: " .. save.ControlData.mixhprate.main)
				print("  Non-main weight: " .. save.ControlData.mixhprate.nomain)
				print("  Current formula: (main * " .. save.ControlData.mixhprate.main .. 
					" + nomain * " .. save.ControlData.mixhprate.nomain .. ") / " .. total)
			else
				print("Invalid parameters! Usage: mixhprate main/nomain WW")
				print("  WW must be a non-negative number")
			end
		elseif #args == 1 and args[1] == "clear" then
			save.ControlData.mixhprate = nil
			print("HP rate settings updated:")
			print("  Main weight: 4")
			print("  Non-main weight: 1")
		else
			print("Usage: mixhprate main/nomain WW")
			print("  Example: mixhprate main 9")
			print("  Current defaults: main=4, nomain=1")
		end
	end

	if string.lower(cmd) == "mixclearmode" and params ~= nil then
		save.ControlData.RecordList = nil
		print("Custom mode cleared.")
	end

	if string.lower(cmd) == "mixrecordmode" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end

		local tg = args[1] or ""
		if tg == "" then
			print("Error: Please specify a mode name")
			return
		end
		-- Initialize RecordList if not exists
		save.ControlData.RecordList = save.ControlData.RecordList or {}
		-- Create deep copy of current settings
		local currentSettings = auxi.deepCopy(save.ControlData)
		-- Remove RecordList from the copy to avoid circular reference
		currentSettings.RecordList = nil
		-- Save to RecordList
		save.ControlData.RecordList[tg] = currentSettings
		print("Successfully saved current settings as mode: "..tg)
	end

	if string.lower(cmd) == "mixsetmode" and params ~= nil then
		local args={}
		for str in string.gmatch(params, "([^ ]+)") do
			table.insert(args, string.lower(str))
		end
		
		local tg = args[1] or ""
		if tg == "" then
			print("Error: Please specify a mode name")
			return
		end

		if item.CommandLists[tg] then
			for u,v in pairs(item.CommandLists[tg]) do
				Isaac.ExecuteCommand(v)
			end
			if tg == "default" then
				print("Set back to default")
			else
				print("Now loaded default mode: "..tg)
			end
		elseif save.ControlData.RecordList and save.ControlData.RecordList[tg] then
			-- Backup current RecordList
			local currentRecordList = save.ControlData.RecordList
			-- Apply saved settings
			save.ControlData = auxi.deepCopy(save.ControlData.RecordList[tg])
			-- Restore RecordList
			save.ControlData.RecordList = currentRecordList
			print("Successfully loaded custom mode: "..tg)
		else
			print("Error: Mode '"..tg.."' not found")
		end
	end

	if string.lower(cmd) == "mixexecutepack" and params ~= nil then
		-- Extract commands enclosed in []
		local commands = {}
		for command in string.gmatch(params, "%[(.-)%]") do
			table.insert(commands, command)
		end
		
		if #commands == 0 then
			print("Error: No commands found. Usage: mixexecutepack [CMD1 XXXX] [CMD2 XXXX] ...")
			return
		end
		
		-- Execute each command
		for i, command in ipairs(commands) do
			-- Split command and parameters
			local cmd, params = command:match("^(%S+)%s*(.*)$")
			
			if cmd then
				print("Executing command " .. i .. ": " .. command)
				item.execute_command(_, cmd, params)
			else
				print("Error: Invalid command format at position " .. i)
			end
		end
		
		print("Finished executing " .. #commands .. " commands")
	end
end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_EXECUTE_CMD, params = nil,
Function = item.execute_command,
})	

return item