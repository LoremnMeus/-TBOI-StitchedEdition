local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
local Attribute_holder = require("Mixturer_Extra_scripts.others.Attribute_holder")
local entities = require("Mixturer_Extra_scripts.bosses.Mixture_data")
local danger = require("Mixturer_Extra_scripts.bosses.Danger_Data")
local collector = require("Mixturer_Extra_scripts.others.Parent_Collect_holder")

local item = {
	myToCall = {},
	ToCall = {},
	post_ToCall = {},
	entity_type = 463,
	entity = enums.Enemies.Stitched,
	prefix1 = "gfx/output/",
	prefix2 = "resources.gfx.output.",
	targets = {
		["Left"] = {
		},
		["Right"] = {
		},
	},
	name_tgs = {},
	own_key = "MSE_Boss_Mixturer_",
	swap2rate = {		--这里的参数比想象中奇怪
		{frame = 0,val = 0.8,},
		{frame = 30,val = 0,},
	},
	swap_move_info = {
		{frame = 0,val = 1,},
		{frame = 15,val = 0,},
	},
	defaultval =  {
		{
			XPosition = 0,
			YPosition = -999,
			XScale = 100,
			YScale = 100,
			Rotation = 0,
			Visible = false,
			CombinationID = 1,
			frame = 0,
			Interpolated = true,
		},
	},
	eventlist = {
		"Explosion",
		"Shoot",
		"Jump",
		"Land",
		"BloodStart",
		"BloodStop",
		"Heartbeat",
		"Lift",
		"Stop",
		"Slide",
		"Spawn",
		"Shoot2",
		"DeathSound",
		"DropSound",
		"Disappear",
		"Prize",
		"Shuffle",
		"CoinInsert",
	},
	Bossanimlist = {},
	s2w = {
		[1] = {
			{frame = 0,val = 0.1,},
			{frame = 30,val = 1,},
			{frame = 60,val = 1.4,},
		},
		[2] = {
			{frame = 30,val = 0.5,},
			{frame = 50,val = 1,},
			{frame = 100,val = 1.2,},
			{frame = 200,val = 1.3,},
			{frame = 300,val = 1.4,},
		},
	},
	remove_flags_tg = {
		FLAG_SHRINK = 1<<24,
		FLAG_ICE = 1<<50,
		--FLAG_CHARM = 1<<8,
	},
	remove_flags = {
		FLAG_FREEZE = 1<<5,					-- freezing effect
		--FLAG_CHARM = 1<<8,
		FLAG_SHRINK = 1<<24,
		FLAG_ICE = 1<<50,
	},
	append_flags = {
		FLAG_NO_STATUS_EFFECTS = 1,					-- freezing effect
		--FLAG_SHRINK = 1<<24,
		--FLAG_ICE = 1<<50,
		--FLAG_POISON = 1<<6,					-- poison effect
		--FLAG_SLOW = 1<<7,						-- slowing (velocity)
		--FLAG_CHARM = 1<<8,						-- Charmed
		--FLAG_CONFUSION = 1<<9,					-- Confused
		--FLAG_MIDAS_FREEZE = 1<<10,				-- Midas frozen
		--FLAG_FEAR = 1<<11,						-- Fleeing in Fear (like Mom's Pad)
		--FLAG_BURN = 1<<12,						-- Caused by Fire Mind tears, works like poison except with Red color effect.
	},
	banish_champion = {
		[12] = 13,
	},
	grid_collision_val_map = {
		[0] = 10,
		[1] = 8,
		[2] = 8,
		[3] = 8,
		[4] = -4,
		[5] = 0,
		[6] = 4,
		[7] = -8,
	},
	velocity_punishment = {
		{frame = 0,val = 0,},
		{frame = 30,val = 0,},
		{frame = 60,val = -0.25,},
		{frame = 90,val = -1,},
		{frame = 150,val = -1.5,},
		{frame = 300,val = -3,},
		{frame = 600,val = -5,},
	},
	velocity_punishment2 = {
		{frame = 0,val = 0,},
		{frame = 30,val = 0,},
		{frame = 60,val = -0.25,},
		{frame = 90,val = -1,},
		{frame = 150,val = -2,},
		{frame = 300,val = -5,},
		{frame = 600,val = -10,},
	},
	friend_flag = EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_CHARM,
	damage_flag = EntityFlag.FLAG_CHARM | EntityFlag.FLAG_BAITED,
	-- | EntityFlag.FLAG_PERSISTENT
}
function item.has_friend_flag(flag,flag2)
	if flag2 == nil then flag2 = item.friend_flag end
	if flag & flag2 == flag2 then return true end
	return false
end
--l local mix = require("Mixturer_Extra_scripts.bosses.Boss_Mixturer") local q = Isaac.Spawn(mix.entity_type,mix.entity,0,Vector(360,280),Vector(0,0),nil):ToNPC() local d = q:GetData() d[mix.own_key.."effect"] = {} d[mix.own_key.."effect"]["Right"] = {infoid = mix.find_entity(274,1).id,} d[mix.own_key.."effect"]["Left"] = {infoid = 3,} 
function item.stop_time(v,name)
	name = name or item.own_key
	local s = v:GetSprite()
	for u,v in pairs(item.eventlist) do if s:IsEventTriggered(v) ~= false then s:Update() end end
	local d = v:GetData()
	if d[name.."_freeze_succ"] == nil then d[name.."_freeze_succ"] = Attribute_holder.try_hold_attribute(v,"EntityFlag_FLAG_FREEZE",true,{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_FREEZE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_FREEZE) else ent:AddEntityFlags(EntityFlag.FLAG_FREEZE) end end,}) end
	if d[name.."_no_sprite_update_succ"] == nil then d[name.."_no_sprite_update_succ"] = Attribute_holder.try_hold_attribute(v,"EntityFlag_FLAG_NO_SPRITE_UPDATE",true,{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) else ent:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end end,}) end
end

function item.time_free(v,name)
	name = name or item.own_key
	local d = v:GetData()
	if d[name.."_freeze_succ"] then
		Attribute_holder.try_rewind_attribute(v,"EntityFlag_FLAG_FREEZE",d[name.."_freeze_succ"],{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_FREEZE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_FREEZE) else ent:AddEntityFlags(EntityFlag.FLAG_FREEZE) end end,})
		d[name.."_freeze_succ"] = nil
	end
	if d[name.."_no_sprite_update_succ"] then
		Attribute_holder.try_rewind_attribute(v,"EntityFlag_FLAG_NO_SPRITE_UPDATE",d[name.."_no_sprite_update_succ"],{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) else ent:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end end,})
		d[name.."_no_sprite_update_succ"] = nil
	end
end

function item.find_entity(base, search_type, search_variant, search_subtype)
	if base == nil then base = item.targets["Left"] end
	if type(base) == "string" and item.targets[base] then base = item.targets[base] end
	if type(base) == "number" then search_subtype = search_variant search_variant = search_type search_type = base base = item.targets["Left"] end
    search_variant = search_variant or 0
    search_subtype = search_subtype or 0
    for idx, entity in pairs(base) do
		if auxi.check_if_any(entity.on_search,entity,search_type,search_variant,search_subtype) or (entity.type == search_type and entity.variant == search_variant and entity.subtype == search_subtype) then
			return entity
		end
	end
    return {None = true,}
end

function item.get_id_level(params)
	params = params or {}
	local level = Game():GetLevel()
	if level:IsAscent() then return 5.5 end
	local ls = params.ls or auxi.get_level_info_mix()
	local st = params.st or level:GetStageType()
	if st > 3 then ls = ls + 0.5 end
	return ls
end

function item.strength2weigh(v,level,val)
	if val < 30 then
		return 4 * auxi.check_lerp(val + level * 3,item.s2w[1]).val
	else
		local rval = val + level * 10
		if level == 6 then rval = rval + 50 end
		return 10 * auxi.check_lerp(rval,item.s2w[2]).val
	end
	return 10
end

table.insert(item.myToCall,#item.myToCall + 1,{CallBack = enums.Callbacks.PRE_NEW_ROOM, params = nil,
Function = function(_)
	save.ControlData = save.ControlData or {}
    local control = save.ControlData
	control.mixsameinroom = control.mixsameinroom or {chance = 0,count = 1,}
	save.elses[item.own_key.."RoomTarget"] = {}
	for i = 1,control.mixsameinroom.count do
		save.elses[item.own_key.."RoomTarget"][i] = item.search_in("Left",{skip = true,}).id
	end
end,
})

table.insert(item.myToCall,#item.myToCall + 1,{CallBack = enums.Callbacks.PRE_NEW_LEVEL, params = nil,
Function = function(_)
	save.ControlData = save.ControlData or {}
    local control = save.ControlData
	control.mixsameinlevel = control.mixsameinlevel or {chance = 0,count = 1,}
	save.elses[item.own_key.."LevelTarget"] = {}
	for i = 1,control.mixsameinlevel.count do
		save.elses[item.own_key.."LevelTarget"][i] = item.search_in("Left",{skip = true,}).id
	end
	Game():GetItemPool():RemoveCollectible(530)
end,
})

--{lev = lev,forcetag = forcetag,}
function item.check_succ(v,params)
	v = v or {}
	params = params or {}
	local succ = true 
	for _ = 1,1 do
		if v.NotSpawn then succ = false break end
		--NoMulti参数意味着强制防止任何复数敌人拼在一起
		if v.id == params.v.id and v.NotSelf then succ = false break end
		if (v.is_multi) and (params.v.NoisMulti or params.NoisMulti) then succ = false break end
		if (v.is_multi or v.can_multi) and (params.v.NoMulti or params.NoMulti) then succ = false break end
		if v.is_multi and (params.v.is_multi or (params.v.can_multi)) then succ = false break end
		if v.can_multi and (params.v.is_multi or params.v.can_multi) then succ = false break end
		if auxi.check_if_any(params.special,v) then succ = false break end
	end
	return succ
end

function item.search_in(base,params)
	if type(base) == "string" and item.targets[base] then base = item.targets[base] end
	params = params or {}
	params.v = params.v or {}
	--print(tostring(params.v.type).." "..tostring(params.v.is_multi))
	-- Get control data
    local control = save.ControlData or {}

	local forcetag = nil
    if control.mixforceboss and control.mixforceboss > 0 and math.random() < control.mixforceboss then
        forcetag = "boss"
    elseif control.mixforcenoboss and control.mixforcenoboss > 0 and math.random() < control.mixforcenoboss then
        forcetag = "noboss"
	end
	if params.forcetag then forcetag = params.forcetag end
	control.mixforcetag = control.mixforcetag or {boss = 0.5,}
	for tag,val in pairs(control.mixforcetag) do
		local succc = false
		if params.v[tag] then succc = true end
		if tag == "boss" and params.v.uid == 1 then succc = true end
		if tag == "noboss" and params.v.uid == 2 then succc = true end
		if succc and math.random() < val then forcetag = tag break end
	end
	--print(forcetag)
	local lev = params.level or params.v.level or 1
	local blev = item.get_id_level()
	if params.force_level or (control.mixfollowlevel and control.mixfollowlevel > 0 and math.random() < control.mixfollowlevel) or (lev < blev and not params.force_nolevel) then
        lev = blev
    end
	
	for tag, offset in pairs(control.mixtaglevel or {boss = 2,sin = -1,}) do
		local succc = false
		if params.v[tag] then succc = true end
		if tag == "boss" and params.v.uid == 1 then succc = true end
		if tag == "noboss" and params.v.uid == 2 then succc = true end
		if succc then lev = lev + offset end
	end

	local hardLevel = control.mixhardlevel or 0
    local baseLevel = control.mixbaselevel or -999

	if not params.skip then
		-- Handle mixforce first (highest priority)
		if control.mixforce and #control.mixforce > 0 and math.random() < (control.mixforcechance or 1) then
			local tbl = {}
			for u,v in pairs(control.mixforce) do
				local succ = item.check_succ(item.targets["Left"][v.id],params)
				if succ then table.insert(tbl,v) end
			end
			if #tbl > 0 then
				return base[auxi.random_in_weighed_table(tbl,params.rng).id or 1]
			end
		end
	
		control.mixsameinroom = control.mixsameinroom or {chance = 0,count = 1,}
		if control.mixsameinroom.chance > 0 and math.random() < control.mixsameinroom.chance and #(save.elses[item.own_key.."RoomTarget"]) > 0 then
			local tbl = {}
			for u,v in pairs(save.elses[item.own_key.."RoomTarget"]) do
				local succ = item.check_succ(item.targets["Left"][v],params)
				if succ then table.insert(tbl,{id = v,}) end
			end
			if #tbl > 0 then
				return base[auxi.random_in_weighed_table(tbl,params.rng).id or 1]
			end
		end
		control.mixsameinlevel = control.mixsameinlevel or {chance = 0,count = 1,}
		if control.mixsameinlevel.chance > 0 and math.random() < control.mixsameinlevel.chance and #(save.elses[item.own_key.."LevelTarget"]) > 0 then
			local tbl = {}
			for u,v in pairs(save.elses[item.own_key.."LevelTarget"]) do
				local succ = item.check_succ(item.targets["Left"][v],params)
				if succ then table.insert(tbl,{id = v,}) end
			end
			if #tbl > 0 then
				return base[auxi.random_in_weighed_table(tbl,params.rng).id or 1]
			end
		end
	end


	local tbl = {}
	for u,v in pairs(base) do
		local succ = item.check_succ(v,params)
		local lv0 = (v.level or 1)
		-- Apply mixtaglevel adjustments
		for tag, offset in pairs(control.mixtaglevel or {boss = 2,sin = -1,}) do
			local succc = false
			if v[tag] then succc = true end
			if tag == "boss" and v.uid == 1 then succc = true end
			if tag == "noboss" and v.uid == 2 then succc = true end
			if succc then lv0 = lv0 + offset end
		end
		-- Check level constraints
		if lv0 > math.max(1,(lev + hardLevel)) or lv0 < math.min(5,(lev + baseLevel)) then
			succ = false
		end
		if succ and forcetag then
			local isBoss = v.uid == 1
			if forcetag == "boss" then
				if isBoss then else succ = false end
			elseif forcetag == "noboss" then
				if isBoss then succ = false else end
			elseif v[forcetag] then else succ = false end
		end
		if succ then 
			local wei = item.strength2weigh(v,lv0,v.strength or 50)
			table.insert(tbl,{id = u,weigh = wei,}) 
		end
	end
	if #tbl == 0 then print("No Choice!") end
	return base[(auxi.random_in_weighed_table(tbl,params.rng) or {}).id or 8]
end

function item.fast_search(basestr, search_type, search_variant, search_subtype,only_fast)
	local tname = tostring(search_type).."."..tostring(search_variant or 0).."."..tostring(search_subtype or 0)
	if basestr == nil then basestr = "Left" end
	if item.name_tgs[tname] and item.name_tgs[tname][basestr] then
		return item.name_tgs[tname][basestr]
	end
	if only_fast then return nil end
	local ret = item.find_entity(basestr, search_type, search_variant, search_subtype)
	if not ret.None and item.name_tgs[tname] then item.name_tgs[tname][basestr] = ret end
	return ret
end

function item.process_entity(entity,uid)
	local tname = tostring(entity.type).."."..tostring(entity.variant).."."..tostring(entity.subtype)
	item.name_tgs[tname] = item.name_tgs[tname] or {}
	if not entity.NoLeft then
		local tg = {}
		for u,v in pairs(entity) do tg[u] = v end
		tg.uid = uid
		tg.id = #item.targets.Left + 1
		tg.anm2 = item.prefix1 .. (entity.anm2_name or entity.name) .. "_left.anm2"
		tg.anm2_data = require(item.prefix2 .. entity.name:gsub("%.", "_"))
		table.insert(item.targets.Left,tg)
		item.name_tgs[tname]["Left"] = tg
	end
	if not entity.NoRight then
		local tg = {}
		for u,v in pairs(entity) do tg[u] = v end
		tg.uid = uid
		tg.id = #item.targets.Right + 1
		tg.anm2 = item.prefix1 .. (entity.anm2_name or entity.name) .. "_right.anm2"
		tg.anm2_data = require(item.prefix2 .. entity.name:gsub("%.", "_"))
		table.insert(item.targets.Right,tg)
		item.name_tgs[tname]["Right"] = tg
	end
end

for u,v in pairs(entities) do
	if type(v) == "table" then 
		for _, entity in pairs(v) do
			if not entity.Neglect then item.process_entity(entity,u) end
			if u == 1 then 
				item.Bossanimlist[entity.name] = #item.targets.Right
			end
		end
	end
end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_ENTITY_TAKE_DMG, params = nil,
Function = function(_,ent,amt,flag,source,cooldown)
	local d = ent:GetData()
    if d[item.own_key.."linkee"] and not ((cooldown == 666) or (amt == 1000 and flag == 0 and cooldown == 30)) then 
        return false
    end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_BOMB_COLLISION, params = nil,
Function = function(_,ent,col,low)
	local d = col:GetData()
    if d[item.own_key.."linkee"] then 
        return true
    end
	if ent.SpawnerEntity then
		local se = ent.SpawnerEntity local sed = se:GetData()
		local d = ent:GetData()
		if sed[item.own_key.."linkee"] and auxi.check_for_the_same(sed[item.own_key.."linkee"].linker,col) == true then return true end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_PROJECTILE_COLLISION, params = nil,
Function = function(_,ent,col,low)
	local d = col:GetData()
    if d[item.own_key.."linkee"] then 
        return true
    end
	if ent.SpawnerEntity then
		local se = ent.SpawnerEntity local sed = se:GetData()
		local d = ent:GetData()
		if sed[item.own_key.."linkee"] and auxi.check_for_the_same(sed[item.own_key.."linkee"].linker,col) == true then return true end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_TEAR_COLLISION, params = nil,
Function = function(_,ent,col,low)
	local d = col:GetData()
    if d[item.own_key.."linkee"] then 
        return true
    end
	if ent.Variant == 45 then
        if col.Variant == item.entity and col.Type == 463 then
            return true
        end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_FAMILIAR_COLLISION, params = nil,
Function = function(_,ent,col,low)
	local d = col:GetData()
    if d[item.own_key.."linkee"] then 
        return false
    end
	if ent.Variant == 206 and ent.SubType == 638 then
        if col.Variant == item.entity and col.Type == 463 then
            return false
        end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_NPC_COLLISION, params = nil,
Function = function(_,ent,col,low)
	local d = ent:GetData()
    if d[item.own_key.."linkee"] then 
		local info = item.targets["Left"][d[item.own_key.."linkee"].infoid or 0]
		info = item.protect_delirium(ent,"Left",info)
		if info then 
			local ret = auxi.check_if_any(info.special_collision,ent,col,low) 
			if ret ~= nil then return ret.ret end
		end
        return true
    end
	local d = col:GetData()
    if d[item.own_key.."linkee"] then 
        return true
    end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NPC_INIT, params = nil,
Function = function(_,ent)
	--if ent.Type == 62 then print(ent.Variant.." "..ent.SubType) end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_NPC_UPDATE, params = nil,
Function = function(_,ent)
	local d = ent:GetData()
	if d[item.own_key.."linkee"] then
		if auxi.check_all_exists(d[item.own_key.."linkee"].linker) and d[item.own_key.."linkee"].linker.Type == 963 then		--似乎，仍然存在概率被冰冻
			d[item.own_key.."linkee"].linker:Remove()
			d[item.own_key.."linkee"].linker = nil
		end
		if auxi.check_all_exists(ent) then 
			local info = item.targets[d[item.own_key.."linkee"].tg or "Left"][d[item.own_key.."linkee"].infoid]
			info = item.protect_delirium(ent,d[item.own_key.."linkee"].tg or "Left",info)
			if auxi.check_all_exists(d[item.own_key.."linkee"].linker) ~= true then
				local linker_exists = false
				if d[item.own_key.."linkee"].linker and d[item.own_key.."linkee"].linker:Exists() then linker_exists = true end
				if d[item.own_key.."GridCollision"] then Attribute_holder.try_rewind_attribute(ent,"GridCollisionClass",d[item.own_key.."GridCollision"]) d[item.own_key.."GridCollision"] = nil end
				if info then 
					for uu,vv in pairs(item.remove_flags_tg) do
						item.base_set_flag(ent,uu,vv,false,d)
					end
					for uu,vv in pairs(item.append_flags) do
						item.base_set_flag(ent,uu,vv,false,d)
					end
					if info.NoKill then
						local real_anm2 = "gfx/" .. info.name .. ".anm2"
						local vs = ent:GetSprite()
						local anim = vs:GetAnimation() local fr = vs:GetFrame() local finished = vs:IsFinished(anim)
						local overlayanim = vs:GetOverlayAnimation() local overlayfr = vs:GetOverlayFrame()
						vs:Load(real_anm2,true) 
						vs:Play(anim,true) vs:SetFrame(fr) if finished then vs:Update() end 
						if overlayanim ~= "" and not info.NoOverlayonKill then vs:PlayOverlay(overlayanim,true) vs:SetOverlayFrame(overlayanim,overlayfr) end
						ent.Visible = true
						ent.Size = d[item.own_key.."linkee"].size or ent.Size
						ent:ClearEntityFlags(item.friend_flag | EntityFlag.FLAG_PERSISTENT)
					else
						if d[item.own_key.."Must_Kill"] == nil then
							d[item.own_key.."Must_Kill"] = true
							--local v1 = item.invisible_flag
							--item.invisible_flag = true
							item.spawnerflag = ent
							ent.HitPoints = 0
							ent:Kill() 
							ent:Update()		--在update中kill后，需要立即update一次，以免漏掉亡语
							--print("Finish Kill")
							--item.invisible_flag = v1
							item.spawnerflag = nil
							d[item.own_key.."Must_Kill"] = nil
						end
					end
					if (d[item.own_key.."rlinkee"] or d[item.own_key.."linkee"] or {}).non_danger ~= true then
						if d[item.own_key.."rlinkee"] then
						--	auxi.PrintTable(d[item.own_key.."rlinkee"])
						end
						--print("Linkee")
						if d[item.own_key.."linkee"] then
						--	auxi.PrintTable(d[item.own_key.."linkee"])
						end
						--print("Kill Non Main "..ent.Type.." "..ent.Variant.." "..ent.SubType)
						auxi.check_if_any(info.on_death,ent,info)
					end
					local release = info.should_release
					if not linker_exists then release = true end
					if ent:Exists() and release and not info.NoKill then
						local real_anm2 = "gfx/" .. info.name .. ".anm2"
						local vs = ent:GetSprite()
						local anim = vs:GetAnimation() local fr = vs:GetFrame() local finished = vs:IsFinished(anim)
						local overlayanim = vs:GetOverlayAnimation() local overlayfr = vs:GetOverlayFrame()
						vs:Load(real_anm2,true) 
						vs:Play(anim,true) vs:SetFrame(fr) if finished then vs:Update() end 
						if overlayanim ~= "" and not info.NoOverlayonKill then vs:PlayOverlay(overlayanim,true) vs:SetOverlayFrame(overlayanim,overlayfr) end
						ent.Visible = true
						ent.Size = (d[item.own_key.."rlinkee"] or d[item.own_key.."linkee"] or {}).size or ent.Size
					end
					if ent:Exists() and d[item.own_key.."linkee"] then 
						d[item.own_key.."rlinkee"] = d[item.own_key.."rlinkee"] or d[item.own_key.."linkee"] 
						d[item.own_key.."linkee"] = nil 
					end
					return 
				else
				end
			end
			if info then auxi.check_if_any(info.special_on_own_update,ent,info) end
		else
			if auxi.check_all_exists(d[item.own_key.."linkee"].linker) ~= true then 
				d[item.own_key.."rlinkee"] = d[item.own_key.."rlinkee"] or d[item.own_key.."linkee"] 
				d[item.own_key.."linkee"] = nil 
			end
		end
	elseif ent:ToNPC() then
		if d[item.own_key.."check_linked"] == nil then 
			d[item.own_key.."check_linked"] = {}
			d[item.own_key.."check_linked"].info = item.fast_search("Left",ent.Type,ent.Variant,ent.SubType,true)
		end
		local info = d[item.own_key.."check_linked"].info
		if info and not d[item.own_key.."check_linked"].Lock then
			d[item.own_key.."check_linked"].Lock = true
			auxi.check_if_any(info.special_All,ent,info)
			d[item.own_key.."check_linked"].Lock = nil
		end
	end
end,
})

if false and REPENTOGON then

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_NPC_RENDER, params = item.entity_type,
Function = function(_,ent)
	if ent.Variant == item.entity then
		local d = ent:GetData()
		item.deal_with_mixture(ent)
	end
end,
})

else

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NPC_RENDER, params = item.entity_type,
Function = function(_,ent)
    if ent.Variant == item.entity then
		local d = ent:GetData()
		item.deal_with_mixture(ent)
	end
end,
})

end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_ENTITY_TAKE_DMG, params = item.entity_type,
Function = function(_,ent,amt,flag,source,cooldown)
    if ent.Variant == item.entity then
		local d = ent:GetData()
		for u,v in pairs(item.targets) do
			if d[item.own_key.."effect"] and d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
				local this = d[item.own_key.."effect"][u]
				local info = item.targets[u][this.infoid or 0]
				info = item.protect_delirium(this.ent,u,info)
				if info then 
					local ret = auxi.check_if_any(info.special_damage,ent,amt,flag,source,cooldown,this.ent)
					if ret ~= nil then return ret end

					local tu = (d[item.own_key.."effect"]["baseinfo"] or {}).tg
					if tu == nil or u == tu or (item.targets[tu][d[item.own_key.."effect"][tu].infoid or 0].special_damage_over == nil) then
						local ret = auxi.check_if_any(info.special_damage_over,ent,amt,flag,source,cooldown,this.ent)
						if ret ~= nil then return ret end
					end
				end
			end
		end
		if source and source.Entity then 
			local e = source.Entity
			local d = e:GetData()
			if d[item.own_key.."linkee"] and auxi.check_for_the_same(d[item.own_key.."linkee"].linker,ent) then 
				return false
			end
			local se = e.SpawnerEntity
			if se then
				local sd = se:GetData()
				if sd[item.own_key.."linkee"] and auxi.check_for_the_same(sd[item.own_key.."linkee"].linker,ent) then 
					return false
				end
			end
		end
    end
end,
})

table.insert(item.post_ToCall,#item.post_ToCall + 1,{CallBack = ModCallbacks.MC_ENTITY_TAKE_DMG, params = item.entity_type,
Function = function(_,ent,amt,flag,source,cooldown)
    if ent.Variant == item.entity then
		local d = ent:GetData()
		for u,v in pairs(item.targets) do
			if d[item.own_key.."effect"] and d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
				local this = d[item.own_key.."effect"][u]
				local info = item.targets[u][this.infoid or 0]
				info = item.protect_delirium(this.ent,u,info)
				if info then
					auxi.check_if_any(info.on_damage,ent,amt,flag,source,cooldown,this.ent)
				end
			end
		end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_LASER_RENDER, params = nil,
Function = function(_,ent,offset)
	if ent.SpawnerEntity then
		local se = ent.SpawnerEntity local sed = se:GetData()
		local d = ent:GetData()
		if sed[item.own_key.."linkee"] and sed[item.own_key.."linkee"].Offset then 
			d[item.own_key.."record"] = d[item.own_key.."record"] or {}
			d[item.own_key.."record"].PositionOffset = d[item.own_key.."record"].PositionOffset or auxi.Vector2Table(ent.PositionOffset)
			d[item.own_key.."record"].ParentOffset = d[item.own_key.."record"].ParentOffset or auxi.Vector2Table(ent.ParentOffset)
			--print(auxi.ProtectVector(sed[item.own_key.."linkee"].Offset))
			ent.ParentOffset = auxi.ProtectVector(d[item.own_key.."record"].PositionOffset) * auxi.ProtectVector(sed[item.own_key.."linkee"].Scale).Y + auxi.ProtectVector(sed[item.own_key.."linkee"].Offset) - auxi.ProtectVector(d[item.own_key.."record"].PositionOffset) + auxi.ProtectVector(d[item.own_key.."record"].ParentOffset)		--修复了旋转的情况
			local info = item.targets[sed[item.own_key.."linkee"].tg][sed[item.own_key.."linkee"].infoid]
			info = item.protect_delirium(se,sed[item.own_key.."linkee"].tg,info)
			if info and info.Catch_Laser and sed[item.own_key.."linkee"].linker then 
				ent.Position = sed[item.own_key.."linkee"].linker.Position 
				ent.Parent = sed[item.own_key.."linkee"].linker
			end
		end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_NPC_COLLISION, params = item.entity_type,
Function = function(_,ent,col,low)
    if ent.Variant == item.entity then
		local cd = col:GetData()
		if (col.Type == item.entity_type and col.Variant == item.entity) then
			local succ = true
			if auxi.xor(item.has_friend_flag(ent:GetEntityFlags()),item.has_friend_flag(col:GetEntityFlags())) then succ = false end
			if succ and ((ent:GetEntityFlags() & item.damage_flag ~= 0) or (col:GetEntityFlags() & item.damage_flag ~= 0)) then succ = false end
			if succ then return true end
		end
		if col.Type == 3 and col.Variant == 206 and col.SubType == 638 then return true end
		if cd[item.own_key.."linkee"] then return true end
		local d = ent:GetData()
		for u,v in pairs(item.targets) do
			local info = v[(d[item.own_key.."effect"][u] or {}).infoid or 0]
			if info and d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then 
				info = item.protect_delirium(d[item.own_key.."effect"][u].ent,u,info)
				local ret = auxi.check_if_any(info.special_collision,d[item.own_key.."effect"][u].ent,col,low,ent) 
				if ret ~= nil then return true end
			end
		end
		if col.SpawnerEntity then
			local cd = col.SpawnerEntity:GetData()
			if cd[item.own_key.."linkee"] and auxi.check_for_the_same(cd[item.own_key.."linkee"].linker,ent) then return true end
		end
    end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_NPC_INIT, params = item.entity_type,
Function = function(_,ent)
	if ent.Variant == item.entity then
		local s = ent:GetSprite()
		local d = ent:GetData()
	end
end,
})

function item.base_set_flag(ent,uu,vv,val,d)
	d = d or ent:GetData()
	if val then
		if d[item.own_key.."EntityFlag"..uu] == nil then
			d[item.own_key.."EntityFlag"..uu] = Attribute_holder.try_hold_attribute(ent,"EntityFlag_"..uu,true,{toget = function(ent) return ent:HasEntityFlags(vv) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(vv) else ent:AddEntityFlags(vv) end end,})
		end
	else 
		if d[item.own_key.."EntityFlag"..uu] then 
			Attribute_holder.try_rewind_attribute(ent,"EntityFlag_"..uu,d[item.own_key.."EntityFlag"..uu],{toget = function(ent) return ent:HasEntityFlags(vv) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(vv) else ent:AddEntityFlags(vv) end end,})
			d[item.own_key.."EntityFlag"..uu] = nil 
		end 
	end
end

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_UPDATE, params = nil,Function = function(_)
	local tgs = auxi.getothers(nil,463,item.entity)
	for u,v in pairs(tgs) do
		local d = v:GetData()
		if d[item.own_key.."effect"] then
			for uu,vv in pairs(item.remove_flags) do
				local succ = v:HasEntityFlags(vv)
				if succ then v:ClearEntityFlags(vv) end
			end
			if not item.has_friend_flag(v:GetEntityFlags()) then
				if v:HasEntityFlags(1<<8) then
					d[item.own_key.."Charm"] = (d[item.own_key.."Charm"] or 0) + 1
				end
				if (d[item.own_key.."Charm"] or 0) > 60 then
					d[item.own_key.."Charmed"] = d[item.own_key.."Charm"]
					d[item.own_key.."Charm"] = nil
				end
				if d[item.own_key.."Charmed"] then
					d[item.own_key.."Charmed"] = (d[item.own_key.."Charmed"] or 0) - 0.2
					v:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
					if d[item.own_key.."Charmed"] < 0 then 
						d[item.own_key.."Charmed"] = nil
						if v.SubType ~= 1 then
							v:ClearEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
						end
					end
				end
			end
			for uu,vv in pairs(item.append_flags) do
				local succ = v:HasEntityFlags(vv)
				for u,v in pairs(item.targets) do
					local ve = d[item.own_key.."effect"][u]
					if ve and ve.ent then
						item.base_set_flag(ve.ent,uu,vv,succ,ve.ent:GetData())
					end
				end 
			end
		end
	end
end,
})

function item.elect_grid_collision(val1,val2)
	local v1 = item.grid_collision_val_map[val1] or 0
	local v2 = item.grid_collision_val_map[val2] or 0
	if v1 < v2 then return val2
	else return val1 end
end

function item.select_valid(val1,val2,type,pv1,pv2)
	if pv1 == nil then return val2 end
	if pv2 == nil then return val1 end
	if pv1 < -900 then return val2 end
	if pv2 < -900 then return val1 end
	if type == "min" then return math.min(val1,val2)
	else return math.max(val1,val2) end
end

function item.softmax(entities)
    local expSum = 0
    for _, entity in ipairs(entities) do
        entity.expWeight = math.exp(entity.weight)
        expSum = expSum + entity.expWeight
    end
    for _, entity in ipairs(entities) do
        entity.weight = entity.expWeight / expSum
    end
	return entities
end

function item.calculateTotalOffset(entities,u)
	u = u or "offset"
    local totalOffset = 0
    for _, entity in ipairs(entities) do
        totalOffset = totalOffset + (entity.weight * entity[u])
    end
    return totalOffset
end

function item.protect_delirium(ent,tg,info)
	if info and info.Recheck then 
		local ret = auxi.check_if_any(info.Recheck,ent,info)
		if ret then return auxi.check_if_any(info.DealwithRecheck,item.targets[tg][ret],ret) or item.targets[tg][ret] end
	end
	return info
end

function item.deal_with_mixture(ent)
	local s = ent:GetSprite()
	local d = ent:GetData()
	if d[item.own_key.."effect"] == nil or d[item.own_key.."effect"]["baseinfo"] == nil then return end
	local baseinfo = d[item.own_key.."effect"]["baseinfo"]
	
	for u,v in pairs(item.targets) do
		if d[item.own_key.."effect"] and d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
			local vv = d[item.own_key.."effect"][u]
			if vv.ent:GetSprite():GetAnimation() == "" then return end		--有些敌人会有这个动画
			local info = v[vv.infoid]
			info = item.protect_delirium(vv.ent,u,info)
			if info.check_all_type and (vv.ent.Type ~= info.type or vv.ent.Variant ~= info.variant or vv.ent.SubType ~= info.subtype) then
				auxi.check_if_any(info.special_on_uncheck,vv.ent)
				--print(vv.ent.Type.." "..vv.ent.Variant.." "..vv.ent.SubType)
				local succ = item.fast_search(u,vv.ent.Type,vv.ent.Variant,vv.ent.SubType).id
				if succ then vv.infoid = succ vv.should_reload = true else return end
			end
		else return end
	end

	local tg = d[item.own_key.."effect"][baseinfo.tg]
	if (tg == nil) or (auxi.check_all_exists(ent) ~= true) then
		--print("Unknown")
		return 
	end
	local tginfo = item.targets[baseinfo.tg][tg.infoid]
	tginfo = item.protect_delirium(tg.ent,baseinfo.tg,tginfo)
	local tgs = tg.ent:GetSprite() local tgd = tg.ent:GetData()
	if PRINT_DATA then print(tg.ent.Type.." "..tg.ent.Variant.." "..tgs:GetAnimation().." "..tg.ent.State) end
	local edval = -999 + 60
	local dedval = -999 + 60
	local cedval = -999 + 60
	local stval = -999
	local lowest_y_tg = nil
	local lowest_deltay_tg = nil
	local now_edval = nil
	local now_stval = nil

	local total_swap_val = {}
	local visibility = nil
	local total_color_table = {}
	for u,v in pairs(item.targets) do
		local vv = d[item.own_key.."effect"][u] local vd = vv.ent:GetData() local vs = vv.ent:GetSprite()
		local info = v[vv.infoid]
		info = item.protect_delirium(vv.ent,u,info)
		if info.set_scale and vd[item.own_key.."linkee"].RecordScale then 
			vs.Scale = auxi.ProtectVector(vd[item.own_key.."linkee"].RecordScale)
		end
		local should_reload = false
		if vv.should_reload then should_reload = true vv.should_reload = nil end
		if info.set_anm2 then should_reload = true end
		if info.reload and vd[item.own_key.."reload"] ~= vv.infoid then should_reload = true end
		if auxi.check_if_any(info.check_reload,vv.ent) then should_reload = true end
		if should_reload then
			local anim = vs:GetAnimation() local fr = vs:GetFrame() local finished = vs:IsFinished(anim)
			if info.anm2 and not info.DontLoad then
				--print(info.anm2) 
				local filename = info.anm2
				if d[item.own_key.."effect"][u].forceSide then
					filename = filename:gsub('left.anm2',d[item.own_key.."effect"][u].forceSide..".anm2"):gsub('right.anm2',d[item.own_key.."effect"][u].forceSide..".anm2")
				end
				vs:Load(filename,true)
				if info.load_anm2 then 
					auxi.check_if_any(info.on_reload,vv.ent)
					local ret = auxi.check_if_any(info.set_anm2,info) or auxi.check_if_any(info.get_anm2,vv.ent,info)
					for u_,v_ in pairs(ret) do
						local name = auxi.check_if_any(info.load_anm2,v_,vv.ent,item.prefix1,info)
						if name then vs:ReplaceSpritesheet(v_,name) end
					end
					vs:LoadGraphics()
				end
				vs:Play(anim,true) vs:SetFrame(fr) if finished then vs:Update() end 
			end
			vd[item.own_key.."reload"] = vv.infoid
		end
		if info.set_visible then
			local succ = auxi.check_if_any(info.set_visible,vv.ent)
			if visibility == nil then visibility = succ
			elseif succ == false then visibility = false end
		end
		if info.set_color then total_color_table[u] = auxi.color2table(vs.Color) end
		if info.set_ent_color then total_color_table[u] = auxi.color2table(v.Color) end
		if info.special_color then total_color_table[u] = auxi.check_if_any(info.special_color,vv.ent,total_color_table[u] or Color(1,1,1,1)) or total_color_table[u] end
	end

	local tganiminfo__ = tginfo.anm2_data.Animations[tgs:GetAnimation()]
	local layer_ids = auxi.check_if_any(tginfo.real_tg_layer,tgs,false,tginfo) or tganiminfo__.Layersheet or {tginfo.tg_layer,}
	local tglerpedinfo = nil
	local tganminfo = nil
	local g_ed_tg = nil
	for _,layer_id in pairs(layer_ids) do
		if PRINT_ANIM then auxi.PrintTable(tganiminfo__.LayerAnimations) end
		local tganiminfo = tganiminfo__.LayerAnimations[layer_id]
		if #tganiminfo == 0 then tganiminfo = item.defaultval end		--比较特殊的一点是，当overlaysprite获取好后，如果当前anim不存在，且overlaysprite存在，就要放弃获得的默认值。
		local i_tglerpedinfo = auxi.check_lerp(tgs:GetFrame(),tganiminfo,{banlist = {["CombinationID"] = true,["Interpolated"] = true,["Visible"] = true,},shouldlerp = function(v1,v2) if v1.Interpolated == true then return true else return false end end,})
		if tginfo.on_anim then i_tglerpedinfo = auxi.check_if_any(tginfo.on_anim,i_tglerpedinfo,tg.ent,tginfo) or i_tglerpedinfo end
		local tgcid = i_tglerpedinfo.CombinationID
		local i_tganminfo = tginfo.anm2_data.AttributeCombinations[tginfo.anm2_data.Layers[layer_id]][tgcid]

		local tgoffsetinfo = tginfo.anm2_data.AttributeDetail[tginfo.anm2_data.Layers[layer_id]][tgcid]
		if tginfo.CoverDetail and tginfo.CoverDetail[tginfo.anm2_data.Layers[layer_id]] then tgoffsetinfo = tginfo.CoverDetail[tginfo.anm2_data.Layers[layer_id]][tgcid] or tgoffsetinfo end
		if i_tglerpedinfo.Visible ~= false then 
			local sedval = (tgoffsetinfo['ed'] - i_tganminfo['YPivot']) * i_tglerpedinfo['YScale']/100 + i_tglerpedinfo.YPosition
			local sstval = (tgoffsetinfo['st'] - i_tganminfo['YPivot']) * i_tglerpedinfo['YScale']/100 + i_tglerpedinfo.YPosition
			edval = item.select_valid(edval,sedval,"max",now_edval,tgoffsetinfo['ed'])
			if edval == sedval then 
				dedval = (tgoffsetinfo['ed'] - i_tganminfo['YPivot']) * i_tglerpedinfo['YScale']/100 
				cedval = (i_tganminfo['YPivot']) * i_tglerpedinfo['YScale']/100 
				lowest_y_tg = i_tglerpedinfo.YPosition
				--lowest_deltay_tg = i_tglerpedinfo.YPosition + (tgoffsetinfo['ed'] - i_tganminfo['Height']) * i_tglerpedinfo['YScale']/100
			end
			stval = item.select_valid(stval,sstval,"min",now_stval,tgoffsetinfo['st'])
			now_edval = item.select_valid(now_edval,tgoffsetinfo['ed'],"max",now_edval,tgoffsetinfo['ed'])
			now_stval = item.select_valid(now_stval,tgoffsetinfo['st'],"min",now_stval,tgoffsetinfo['st'])
		end

		local succ = false
		if g_ed_tg == nil then succ = true
		elseif g_ed_tg < -900 and tgoffsetinfo['ed'] > -900 then succ = true end
		if succ then
			--auxi.PrintTable(i_tglerpedinfo)
			if i_tglerpedinfo.Visible ~= false then g_ed_tg = tgoffsetinfo['ed'] end
			tglerpedinfo = tglerpedinfo or i_tglerpedinfo
			tganminfo = tganminfo or i_tganminfo
		end
	end

	if auxi.check_if_any(tginfo.no_overlay,tg.ent) ~= true and tgs:GetOverlayAnimation() ~= "" then		--存在overlay
		local dpos = 0
		if tginfo.Overlay_Add_With then 
			local daniminfo = auxi.check_if_any(tginfo.Overlay_Adder,tgs,tganiminfo__) or tganiminfo__.LayerAnimations[tginfo.Overlay_Add_With]
			if daniminfo and #daniminfo > 0 then
				local nanimlerpedinfo = auxi.check_lerp(s:GetFrame(),daniminfo,{banlist = {["Visible"] = true,["Interpolated"] = true,},shouldlerp = function(v1,v2) if v1.Interpolated == true then return true else return false end end,})
				dpos = dpos + nanimlerpedinfo.YPosition
			end
		end

		if PRINT_DATA then print("Overlayanim " .. tgs:GetOverlayAnimation()) end
		
		local tganiminfo_overlay__ = tginfo.anm2_data.Animations[tgs:GetOverlayAnimation()]
		local layer_ids = auxi.check_if_any(tginfo.real_tg_layer,tgs,true,tginfo) or tganiminfo_overlay__.Layersheet or {tginfo.tg_layer,}
		for _,layer_id in pairs(layer_ids) do
			local tg_overlay_sheetid = tginfo.anm2_data.Layers[layer_id]
			local tganiminfo_overlay = tganiminfo_overlay__.LayerAnimations[layer_id]
			if #tganiminfo_overlay == 0 then --print("NO Aniamtion Data!")
			else 
				local tglerpedinfo_overlay = auxi.check_lerp(tgs:GetOverlayFrame(),tganiminfo_overlay,{banlist = {["CombinationID"] = true,["Interpolated"] = true,["Visible"] = true,},shouldlerp = function(v1,v2) if v1.Interpolated == true then return true else return false end end,})
				if tginfo.on_overlayanim then tglerpedinfo_overlay = auxi.check_if_any(tginfo.on_overlayanim,tglerpedinfo_overlay,tg.ent,tginfo) or tglerpedinfo_overlay end
				local tgcid_overlay = tglerpedinfo_overlay.CombinationID
				local tganminfo_overlay = tginfo.anm2_data.AttributeCombinations[tg_overlay_sheetid][tgcid_overlay]
				local tgoffsetinfo_overlay = tginfo.anm2_data.AttributeDetail[tg_overlay_sheetid][tgcid_overlay]
				if tginfo.CoverDetail and tginfo.CoverDetail[tginfo.anm2_data.Layers[layer_id]] then tgoffsetinfo_overlay = tginfo.CoverDetail[tginfo.anm2_data.Layers[layer_id]][tgcid] or tgoffsetinfo_overlay end
				if tglerpedinfo_overlay.Visible ~= false then 
					--nanimlerpedinfo.YPosition +
					local sedval = (tgoffsetinfo_overlay['ed'] - tganminfo_overlay['YPivot']) * tglerpedinfo_overlay['YScale']/100 + tglerpedinfo_overlay.YPosition + dpos
					local sstval = (tgoffsetinfo_overlay['st'] - tganminfo_overlay['YPivot']) * tglerpedinfo_overlay['YScale']/100 + tglerpedinfo_overlay.YPosition + dpos
					edval = item.select_valid(edval,sedval,"max",now_edval,tgoffsetinfo_overlay['ed'])
					if edval == sedval then 
						dedval = (tgoffsetinfo_overlay['ed'] - tganminfo_overlay['YPivot']) * tglerpedinfo_overlay['YScale']/100 
						cedval = (tganminfo_overlay['YPivot']) * tglerpedinfo_overlay['YScale']/100 
						lowest_y_tg = tglerpedinfo_overlay.YPosition
						--lowest_deltay_tg = tglerpedinfo_overlay.YPosition + (tgoffsetinfo_overlay['ed'] - tganminfo_overlay['Height']) * tglerpedinfo_overlay['YScale']/100
					end
					stval = item.select_valid(stval,sstval,"min",now_stval,tgoffsetinfo_overlay['st'])
					now_edval = item.select_valid(now_edval,tgoffsetinfo_overlay['ed'],"max",now_edval,tgoffsetinfo_overlay['ed'])
					now_stval = item.select_valid(now_stval,tgoffsetinfo_overlay['st'],"min",now_stval,tgoffsetinfo_overlay['st'])
				end
			end
		end
	end

	--if item.PRINT_DATA then print(edval.." "..stval) end
	d[item.own_key.."effect"][baseinfo.tg].recordlist = {scale = auxi.Vector2Table(tgs.Scale),offset = auxi.Vector2Table(tgs.Offset),flipX = auxi.Bool2str(tgs.FlipX),flipY = auxi.Bool2str(tgs.FlipY),color = auxi.color2table(tgs.Color),rotation = tgs.Rotation,}

	local val_real = 0		--分割参数。如果有敌人缺失贴图，对方也不会出现。
	local val_real_tg = nil
	if dedval < -900 then val_real = -2000 val_real_tg = baseinfo.tg end
	tgs.Scale = Vector(tgs.Scale.X,d[item.own_key.."scaleoffset"] or tgs.Scale.Y)
	local yscaleoffset = 1
	local xscaleoffset = 1
	--local tgoffset = (tgoffsetinfo['ed'] - tganminfo['YPivot']) * tglerpedinfo['YScale']/100 * tgs.Scale.Y
	local cdelta = nil
	local offset_collect = 0 local offset_collecter = 0
	for u,v in pairs(item.targets) do
		if d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
			if u == baseinfo.tg then
			else 
				local this = d[item.own_key.."effect"][u]
				local thiss = this.ent:GetSprite() local thisd = this.ent:GetData()
				d[item.own_key.."effect"][u].recordlist = {scale = auxi.Vector2Table(thiss.Scale),offset = auxi.Vector2Table(thiss.Offset),flipX = auxi.Bool2str(thiss.FlipX),flipY = auxi.Bool2str(thiss.FlipY),color = auxi.color2table(thiss.Color),rotation = thiss.Rotation,}
				local thisinfo = item.targets[u][this.infoid]
				thisinfo = item.protect_delirium(this.ent,u,thisinfo)
				if PRINT_DATA then print(this.ent.Type.." "..this.ent.Variant.." "..thiss:GetAnimation().." "..this.ent.State) end
				local edval_ = -999 + 60
				local dedval_ = -999 + 60
				local cedval_ = -999 + 60
				local stval_ = -999
				local now_edval_ = nil
				local now_stval_ = nil			
				local g_thislerpedinfo = nil
				local lowest_y = nil
				local lowest_deltay = nil
				local g_thisanminfo = nil
				local g_ed_tg = nil

				local thisaniminfo__ = thisinfo.anm2_data.Animations[thiss:GetAnimation()]
				if not thisaniminfo__ then return end
				local layer_ids = auxi.check_if_any(thisinfo.real_tg_layer,thiss,false,thisinfo) or thisaniminfo__.Layersheet or {thisinfo.tg_layer,}
				for _,layer_id in pairs(layer_ids) do
					if PRINT_ANIM then auxi.PrintTable(thisaniminfo__.LayerAnimations) end
					local thisaniminfo = thisaniminfo__.LayerAnimations[layer_id]
					if #thisaniminfo == 0 then thisaniminfo = item.defaultval end
					local thislerpedinfo = auxi.check_lerp(thiss:GetFrame(),thisaniminfo,{banlist = {["CombinationID"] = true,["Interpolated"] = true,["Visible"] = true,},shouldlerp = function(v1,v2) if v1.Interpolated == true then return true else return false end end,})
					if thisinfo.on_anim then thislerpedinfo = auxi.check_if_any(thisinfo.on_anim,thislerpedinfo,this.ent,thisinfo) or thislerpedinfo end
					local thiscid = thislerpedinfo.CombinationID
					local thisanminfo = thisinfo.anm2_data.AttributeCombinations[thisinfo.anm2_data.Layers[layer_id]][thiscid]
					local thisoffsetinfo = thisinfo.anm2_data.AttributeDetail[thisinfo.anm2_data.Layers[layer_id]][thiscid]

					if thisinfo.CoverDetail and thisinfo.CoverDetail[thisinfo.anm2_data.Layers[layer_id]] then thisoffsetinfo = thisinfo.CoverDetail[thisinfo.anm2_data.Layers[layer_id]][thiscid] or thisoffsetinfo end
					if thislerpedinfo.Visible ~= false then 
						local sedval_ = (thisoffsetinfo['ed'] - thisanminfo['YPivot']) * thislerpedinfo['YScale']/100 + thislerpedinfo.YPosition
						local sstval_ = (thisoffsetinfo['st'] - thisanminfo['YPivot']) * thislerpedinfo['YScale']/100 + thislerpedinfo.YPosition
						edval_ = item.select_valid(edval_,sedval_,"max",now_edval_,thisoffsetinfo['ed'])
						if edval_ == sedval_ then 
							dedval_ = (thisoffsetinfo['ed'] - thisanminfo['YPivot']) * thislerpedinfo['YScale']/100 
							lowest_y = thislerpedinfo.YPosition
							--lowest_deltay = thislerpedinfo.YPosition + (thisoffsetinfo['ed'] - thisanminfo['Height']) * thislerpedinfo['YScale']/100 
							cedval_ = thisanminfo['YPivot'] * thislerpedinfo['YScale']/100 
						end
						stval_ = item.select_valid(stval_,sstval_,"min",now_stval_,thisoffsetinfo['st'])
						now_edval_ = item.select_valid(now_edval_,thisoffsetinfo['ed'],"max",now_edval_,thisoffsetinfo['ed'])
						now_stval_ = item.select_valid(now_stval_,thisoffsetinfo['st'],"min",now_stval_,thisoffsetinfo['st'])
					end

					local succ = false
					if g_ed_tg == nil then succ = true
					elseif g_ed_tg < -900 and thisoffsetinfo['ed'] > -900 then succ = true end
					if succ then
						if thislerpedinfo.Visible ~= false then 
							g_ed_tg = thisoffsetinfo['ed']
						end
						g_thislerpedinfo = thislerpedinfo
						g_thisanminfo = thisanminfo
					end
				end
				
				if auxi.check_if_any(thisinfo.no_overlay,this.ent) ~= true and thiss:GetOverlayAnimation() ~= "" then
					if PRINT_DATA then print("Overlayanim " .. thiss:GetOverlayAnimation()) end
					
					local thisaniminfo_overlay__ = thisinfo.anm2_data.Animations[thiss:GetOverlayAnimation()]
					local layer_ids = auxi.check_if_any(thisinfo.real_tg_layer,thiss,true,thisinfo) or thisaniminfo_overlay__.Layersheet or {thisinfo.tg_layer,}
					for _,layer_id in pairs(layer_ids) do

						local dpos = 0
						if thisinfo.Overlay_Add_With then 
							local daniminfo = auxi.check_if_any(thisinfo.Overlay_Adder,thiss,thisaniminfo__) or thisaniminfo__.LayerAnimations[thisinfo.Overlay_Add_With]
							if daniminfo and #daniminfo > 0 then
								local nanimlerpedinfo = auxi.check_lerp(s:GetFrame(),daniminfo,{banlist = {["Visible"] = true,["Interpolated"] = true,},shouldlerp = function(v1,v2) if v1.Interpolated == true then return true else return false end end,})
								dpos = dpos + nanimlerpedinfo.YPosition
							end
						end

						local this_overlay_sheetid = thisinfo.anm2_data.Layers[layer_id]
						local thisaniminfo_overlay = thisaniminfo_overlay__.LayerAnimations[layer_id]
						if #thisaniminfo_overlay == 0 then --print("NO Aniamtion Data!")
						else
							local thislerpedinfo_overlay = auxi.check_lerp(thiss:GetOverlayFrame(),thisaniminfo_overlay,{banlist = {["CombinationID"] = true,["Interpolated"] = true,["Visible"] = true,},shouldlerp = function(v1,v2) if v1.Interpolated == true then return true else return false end end,})
							if thisinfo.on_overlayanim then thislerpedinfo_overlay = auxi.check_if_any(thisinfo.on_overlayanim,thislerpedinfo_overlay,this.ent,thisinfo) or thislerpedinfo_overlay end
							local thiscid_overlay = thislerpedinfo_overlay.CombinationID
							local thisanminfo_overlay = thisinfo.anm2_data.AttributeCombinations[this_overlay_sheetid][thiscid_overlay]
							local thisoffsetinfo_overlay = thisinfo.anm2_data.AttributeDetail[this_overlay_sheetid][thiscid_overlay]
							--nanimlerpedinfo.YPosition +
							
							if thisinfo.CoverDetail and thisinfo.CoverDetail[thisinfo.anm2_data.Layers[layer_id]] then thisoffsetinfo_overlay = thisinfo.CoverDetail[thisinfo.anm2_data.Layers[layer_id]][thiscid] or thisoffsetinfo_overlay end
							if thislerpedinfo_overlay.Visible ~= false then 
								local sedval = (thisoffsetinfo_overlay['ed'] - thisanminfo_overlay['YPivot']) * thislerpedinfo_overlay['YScale']/100 + thislerpedinfo_overlay.YPosition + dpos
								local sstval = (thisoffsetinfo_overlay['st'] - thisanminfo_overlay['YPivot']) * thislerpedinfo_overlay['YScale']/100 + thislerpedinfo_overlay.YPosition + dpos
								edval_ = item.select_valid(edval_,sedval,"max",now_edval_,thisoffsetinfo_overlay['ed'])
								if edval_ == sedval then 
									dedval_ = (thisoffsetinfo_overlay['ed'] - thisanminfo_overlay['YPivot']) * thislerpedinfo_overlay['YScale']/100 
									cedval_ = (thisanminfo_overlay['YPivot']) * thislerpedinfo_overlay['YScale']/100 
									lowest_y = thislerpedinfo_overlay.YPosition
									--lowest_deltay = thislerpedinfo_overlay.YPosition + (thisoffsetinfo_overlay['ed'] - thisanminfo_overlay['Height']) * thislerpedinfo_overlay['YScale']/100 
								end
								stval_ = item.select_valid(stval_,sstval,"min",now_stval_,thisoffsetinfo_overlay['st'])
								now_edval_ = item.select_valid(now_edval_,thisoffsetinfo_overlay['ed'],"max",now_edval_,thisoffsetinfo_overlay['ed'])
								now_stval_ = item.select_valid(now_stval_,thisoffsetinfo_overlay['st'],"min",now_stval_,thisoffsetinfo_overlay['st'])
							end
						end
					end
				end

				--print(edval_.." "..stval_)

				if (now_edval_ or -999) < -900 then 
					val_real = -2000 --val_real_tg = u 
				end

				local delta = math.abs((edval - stval) / (edval_ - stval_) * tgs.Scale.Y)
				local ddelta = math.sqrt(delta)
				local delta_x = math.abs(tglerpedinfo.XScale/g_thislerpedinfo.XScale)
				local ddelta_x = math.sqrt(delta_x)
				thiss.Scale = Vector(thiss.Scale.X * ddelta * ddelta_x,ddelta)		--thiss.Scale = Vector(thiss.Scale.X,delta)		--/ math.sqrt(g_thislerpedinfo.XScale/100)		-- * math.sqrt(ddelta)
				yscaleoffset = yscaleoffset / ddelta--/ math.sqrt(ddelta) --/ math.sqrt(g_thislerpedinfo.XScale/100)			--换成这样就没法做三切割，必须是十字切割
				xscaleoffset = xscaleoffset /ddelta_x / ddelta--/ math.sqrt(ddelta)
				--现在放缩系数是1/2-1/2
				--为了看起来正常，X方向也会施加同样的放缩
				--X方向的放缩应该也是通过计算放缩系数来进行
				--if d[item.own_key.."Updated"] then print("Start:") end
				--if d[item.own_key.."Updated"] then print(dedval_) end
				--if d[item.own_key.."Updated"] then print(delta_x) end
				--if d[item.own_key.."Updated"] then print(delta) end

				local thisoffset = dedval_ * thiss.Scale.Y
				
				if auxi.check_if_any(thisinfo.protect_flip,this.ent) then 		--如何扩展成2个以上的敌人呢？
					tgs.FlipX = thiss.FlipX
				else 
					thiss.FlipX = tgs.FlipX
				end
				if auxi.check_if_any(thisinfo.protect_flipY,this.ent) then 		--如何扩展成2个以上的敌人呢？
					tgs.FlipY = thiss.FlipY
				else 
					thiss.FlipY = tgs.FlipY
				end
				
				local delta_y = (lowest_y or g_thislerpedinfo.YPosition) + dedval_
				local base_offset = 0
				local scaled_offset = (lowest_y or g_thislerpedinfo.YPosition) * tgs.Scale.Y
				if auxi.check_if_any(thisinfo.is_offset,this.ent) then 
					base_offset = base_offset - delta_y
					offset_collect = offset_collect - base_offset
					offset_collecter = offset_collecter + 1
				end
				table.insert(total_swap_val,{weight = (auxi.check_if_any(thisinfo.swap_weight,this.ent,thisinfo) or 1), offset = thisoffset + scaled_offset + base_offset,})

				thisd[item.own_key.."TMPrecord"] = {XPosition = g_thisanminfo['Width']/2 - g_thisanminfo['XPivot'] + g_thislerpedinfo.XPosition,YPosition = lowest_y or g_thislerpedinfo.YPosition,Rotation = g_thislerpedinfo['Rotation'],offset = thisoffset,pivot = cedval_ * thiss.Scale.Y,delta_y = delta_y * (tgs.Scale.Y),}
				--print(thisoffset + scaled_offset + base_offset)
			end
		end
	end
	tgs.Scale = Vector(xscaleoffset * tgs.Scale.X,yscaleoffset * (d[item.own_key.."scaleoffset"] or tgs.Scale.Y))
	local tgoffset = (dedval) * tgs.Scale.Y
	local tgpivot = (cedval) * tgs.Scale.Y
	local swap_counter = (d[item.own_key.."swap_counter"] or 0)
	swap_counter = auxi.check_if_any(tginfo.swap_rate,swap_counter) or swap_counter
	local swaprate = auxi.check_lerp(swap_counter,item.swap2rate).val
	local base_offset = 0
	local scaled_offset = (lowest_y_tg or tglerpedinfo.YPosition) * tgs.Scale.Y 
	local delta_y = (lowest_y_tg or tglerpedinfo.YPosition) + dedval
	if auxi.check_if_any(tginfo.is_offset,tg.ent) then 
		base_offset = base_offset - delta_y
		offset_collect = offset_collect - base_offset
		offset_collecter = offset_collecter + 1
	end
	tgd[item.own_key.."TMPrecord"] = {delta_y = delta_y * (tgs.Scale.Y),}
	table.insert(total_swap_val,{weight = (auxi.check_if_any(tginfo.swap_weight,tg.ent,tginfo) or 2), offset = tgoffset + scaled_offset + base_offset,})
	--print(tgoffset + scaled_offset + base_offset)
	
	total_swap_val = item.softmax(total_swap_val)
	local total_offset = item.calculateTotalOffset(total_swap_val) - tgoffset - scaled_offset - base_offset * (tgs.Scale.Y - 1)
	--print("Total:"..tostring(total_offset))
	if offset_collecter > 0 then
		total_offset = total_offset + offset_collect/offset_collecter + base_offset * (tgs.Scale.Y - 1) --item.calculateTotalOffset(total_swap_val,'addoffset')
	end
	--print("Final Total:"..tostring(total_offset))
	if d[item.own_key.."swap_counter"] == 0 and d[item.own_key.."Updated"] then
		tgd[item.own_key.."swap_val"] = tgd[item.own_key.."swap_val"] or (total_offset)
		d[item.own_key.."swap_val"] = tgd[item.own_key.."swap_val"]
	--	print("Swaped")
	--	print(d[item.own_key.."swap_val"])
	end
	--if d[item.own_key.."Updated"] then print(total_offset) end
	local real_val = val_real + ((d[item.own_key.."swap_val"] or 0) - total_offset) * swaprate + total_offset
	if tginfo.set_offset and real_val > -1000 then real_val = auxi.check_if_any(tginfo.set_offset,real_val,tg.ent) or real_val end
	local b_offset = Vector(0,real_val)
	tgs.Offset = b_offset		-- + tgoffset_new - tgoffset
	if visibility ~= false and real_val > -1000 then tgd[item.own_key.."swap_val"] = total_offset end
	--print(tgs.Offset)
	for u,v in pairs(item.targets) do
		if d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
			local this = d[item.own_key.."effect"][u]
			local info = v[this.infoid]
			info = item.protect_delirium(this.ent,u,info)
			local thiss = this.ent:GetSprite() local thisd = this.ent:GetData()
			if d[item.own_key.."Updated"] and visibility ~= false and real_val > -1000 then 		--改成窗口的写法
				thisd[item.own_key.."record_scaleX_list"] = thisd[item.own_key.."record_scaleX_list"] or {}
				table.insert(thisd[item.own_key.."record_scaleX_list"],1,thiss.Scale.X)
				if #(thisd[item.own_key.."record_scaleX_list"]) > (info.window_size or 2) then table.remove(thisd[item.own_key.."record_scaleX_list"],#(thisd[item.own_key.."record_scaleX_list"])) end
				local total = 0
				for u,v in pairs(thisd[item.own_key.."record_scaleX_list"]) do total = total + v end
				thisd[item.own_key.."record_scaleX"] = total/(#thisd[item.own_key.."record_scaleX_list"])
				--print(thisd[item.own_key.."record_scaleX"])
				--print(thiss.Scale.X)
				--thisd[item.own_key.."record_scaleX"] = 0.5 * thiss.Scale.X + 0.5 * (thisd[item.own_key.."record_scaleX"] or thiss.Scale.X)
				thiss.Scale = Vector(thisd[item.own_key.."record_scaleX"] or thiss.Scale.X,thiss.Scale.Y)
			else
				if d[item.own_key.."Updated"] then thisd[item.own_key.."record_scaleX_list"] = {} end
				thiss.Scale = Vector(thisd[item.own_key.."record_scaleX"] or thiss.Scale.X,thiss.Scale.Y)
			end
			if d[item.own_key.."effect"][u].forceSide and d[item.own_key.."effect"][u].forceSide ~= u then
				thiss.FlipX = not thiss.FlipX
			end
			if u == baseinfo.tg then
				auxi.check_if_any(info.special_render,this.ent,ent,true,d[item.own_key.."Updated"])
			else 
				local iinfo = thisd[item.own_key.."TMPrecord"]
				local v1_1 = Vector(0,(lowest_y_tg or tglerpedinfo.YPosition) * tgs.Scale.Y)
				local v1_2 = Vector(0,tgoffset)
				local v2_1 = Vector(0,thiss.Scale.Y * iinfo.YPosition)
				local v2_2 = Vector(0,iinfo.offset)
				--local v3 = Vector(0,iinfo.pivot)
				--local v1 = Vector(0,(lowest_y_tg or tglerpedinfo.YPosition) * tgs.Scale.Y - thiss.Scale.Y * iinfo.YPosition)
				--B.YPosition * B.ScaleY - A.YPosition * A.ScaleY
				--local v2 = Vector(0,tgoffset - iinfo.offset)	
				if visibility ~= false and real_val > -1000 then thisd[item.own_key.."swap_val"] = total_offset + v1_1.Y + v1_2.Y - v2_1.Y - v2_2.Y end
				--tgoffset - iinfo.offset 

				local r1 = tglerpedinfo.Rotation 
				local r2 = iinfo.Rotation
				local delta_rotate = r1 - r2
				--if info.skip_rotate then tg.Rotation = 0 end
				if info.follow_rotate or (tginfo.skip_rotate) then
					tgs.Rotation = thiss.Rotation - delta_rotate
				else		--需要随时间变化转到对方位置
					thiss.Rotation = tgs.Rotation + delta_rotate
				end
				tgs.Offset = auxi.get_by_rotate(b_offset,tgs.Rotation)				
				thiss.Offset = auxi.get_by_rotate(b_offset + v1_1 + auxi.get_by_rotate(v1_2,r1) - auxi.get_by_rotate(v2_1,r1 - r2) - auxi.get_by_rotate(v2_2,r1),thiss.Rotation - delta_rotate)
				--实际上，应该是tg_Ypos + r1(Ed - pv) - r_1-2(YPos) - r1(Ed - pv)
				auxi.check_if_any(info.special_render,this.ent,ent,false,d[item.own_key.."Updated"])
			end
		end
	end

	local should_stop_time = false
	if val_real < -1000 and val_real_tg then
		local vv = d[item.own_key.."effect"][val_real_tg] local info = item.targets[val_real_tg][vv.infoid] 
		info = item.protect_delirium(vv.ent,val_real_tg,info)
		local order = item.get_order(info.order,vv.ent,val_real_tg,info,true)
		if order >= 2 and order <= 5 then
			should_stop_time = true
		end
	end
	if should_stop_time then
		for u,v in pairs(item.targets) do
			local vv = d[item.own_key.."effect"][u] local info = v[vv.infoid]
			info = item.protect_delirium(vv.ent,u,info)
			local order = item.get_order(info.order,vv.ent,u,info,true)
			if u ~= val_real_tg and (info.KeepUpdate ~= true) then item.stop_time(vv.ent,item.own_key.."Jump")
			else item.time_free(vv.ent,item.own_key.."Jump") end
		end
	else 
		for u,v in pairs(item.targets) do
			local vv = d[item.own_key.."effect"][u] local info = v[vv.infoid]
			info = item.protect_delirium(vv.ent,u,info)
			item.time_free(vv.ent,item.own_key.."Jump") 
		end
	end

	--if visibility == false and tginfo.HideAll then
	--else ent:RenderShadowLayer(Vector(0,0)) end

	local c = Color(1,1,1,1) if not auxi.equalcolor(ent:GetSprite().Color,Color(1,1,1,1)) then c = ent:GetSprite().Color end
	local offset = (d[item.own_key.."recordposoffset"] or Vector(0,0)) - (d[item.own_key.."posoffset"] or Vector(0,0))
	local render_order = {"Left","Right"}
	for u,v in pairs(item.targets) do
		if d[item.own_key.."effect"] and d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
			local vv = d[item.own_key.."effect"][u] local vd = vv.ent:GetData() local vs = vv.ent:GetSprite()
			if auxi.check_exists(vd[item.own_key.."Minecart"]) then 
				if u == "Right" then render_order = {"Right","Left"} end
				offset = offset + Vector(0,-5) break 
			end
		end
	end
	for _,u in pairs(render_order) do
		local v = item.targets[u]
		if d[item.own_key.."effect"] and d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
			local vv = d[item.own_key.."effect"][u] local vd = vv.ent:GetData() local vs = vv.ent:GetSprite()
			local info = v[vv.infoid]
			info = item.protect_delirium(vv.ent,u,info)
			vs.Color = auxi.MulColor2(vs.Color,c)
			for u_,v_ in pairs(total_color_table) do 
				if u_ ~= u then vs.Color = auxi.MulColor2(vs.Color,v_) end
			end
			vv.ent.Visible = true
			vv.recordlist.PositionOffset = auxi.Vector2Table(vv.ent.PositionOffset)
			vv.ent.PositionOffset = tg.ent.PositionOffset-- + tg.ent.Position - vv.ent.Position
			local room = Game():GetRoom()
			local delta = Isaac.WorldToScreen(ent.Position + ent.PositionOffset) - Isaac.WorldToScreen(vv.ent.Position) + room:GetRenderScrollOffset() + Game().ScreenShakeOffset		--还缺水下版本
			local render_offset = Isaac.WorldToScreen(ent.Position + ent.PositionOffset) + offset --+ room:GetRenderScrollOffset() + Game().ScreenShakeOffset
			if auxi.is_under_water() then
				render_offset = render_offset + auxi.GetWaterRenderOffset() - room:GetRenderScrollOffset()
				delta = delta + auxi.GetWaterRenderOffset() - room:GetRenderScrollOffset()
			end
			if visibility ~= false then
				auxi.check_if_any(info.pre_render,vv.ent,offset + delta,render_offset,info)
			end
		end
	end

	for _,u in pairs(render_order) do
		local v = item.targets[u]
		if d[item.own_key.."effect"] and d[item.own_key.."effect"][u] and auxi.check_all_exists(d[item.own_key.."effect"][u].ent) then
			local vv = d[item.own_key.."effect"][u] local vd = vv.ent:GetData() local vs = vv.ent:GetSprite()
			local info = v[vv.infoid]
			info = item.protect_delirium(vv.ent,u,info)
			local room = Game():GetRoom()
			local delta = Isaac.WorldToScreen(ent.Position + ent.PositionOffset) - Isaac.WorldToScreen(vv.ent.Position + vv.ent.PositionOffset) + room:GetRenderScrollOffset() + Game().ScreenShakeOffset
			local render_offset = Isaac.WorldToScreen(ent.Position + ent.PositionOffset) + offset --+ room:GetRenderScrollOffset() + Game().ScreenShakeOffset
			if auxi.is_under_water() then
				render_offset = render_offset + auxi.GetWaterRenderOffset() - room:GetRenderScrollOffset()
				delta = delta + auxi.GetWaterRenderOffset() - room:GetRenderScrollOffset()--Vector(0,.Y) 
				delta = delta - vs.Offset
				vs.Offset = Vector(0,0)
				--+ Vector(0,(TEST_VAL1 or 0) * vs.Offset.Y + (TEST_VAL2 or 0) * b_offset.Y + (TEST_VAL3 or 0) * (vd[item.own_key.."TMPrecord"] or {}).delta_y)		--
				--print(vs.Offset)
				--print(b_offset)
				--vs.Offset = vs.Offset + Vector(0,(TEST_VAL1 or -2) * vs.Offset.Y + (TEST_VAL2 or 1) * b_offset.Y)
				--print(vs.Offset)
			end
			local doffset = Vector(0,0)
			if vd[item.own_key.."Minecart"] then doffset = doffset + Vector(0,5) end
			render_offset = render_offset + doffset
			delta = delta + doffset
			if visibility == false then
				local visible = auxi.check_if_any(info.set_visible,vv.ent)
				if visible ~= false and u ~= baseinfo.tg then item.stop_time(vv.ent)
				else item.time_free(vv.ent) item.time_free(vv.ent,item.own_key.."Jump") end
				auxi.check_if_any(info.special_on_invisible,vv.ent,render_offset,info,offset + delta)
			else
				if visibility == true then item.time_free(vv.ent) end
				if info.Replace_with_sprite then
					d[item.own_key.."replace_sprite"] = d[item.own_key.."replace_sprite"] or Sprite()
					local s2 = auxi.copy_sprite(vs,d[item.own_key.."replace_sprite"])
					if info.special_on_replace_with then auxi.check_if_any(info.special_on_replace_with,s2,info,render_offset,vv.ent)
					else s2:Render(render_offset) end
				else vv.ent:Render(offset + delta) end
			end
			vv.ent.Visible = false
			vd[item.own_key.."linkee"] = vd[item.own_key.."linkee"] or {linker = ent,infoid = vv.infoid,tg = u,}
			vd[item.own_key.."linkee"].Offset = auxi.Vector2Table(vs.Offset)
			vd[item.own_key.."linkee"].Scale = auxi.Vector2Table(vs.Scale)
			vv.ent.PositionOffset = auxi.ProtectVector(vv.recordlist.PositionOffset or vv.ent.PositionOffset)
			vs.Scale = auxi.ProtectVector(vv.recordlist.scale or vs.Scale)
			vs.Offset = auxi.ProtectVector(vv.recordlist.offset or vs.Offset)
			vs.FlipX = auxi.str2Bool(vv.recordlist.flipX or vs.FlipX)
			vs.FlipY = auxi.str2Bool(vv.recordlist.flipY or vs.FlipY)
			vs.Color = auxi.table2color(vv.recordlist.color or vs.Color)
			vs.Rotation = vv.recordlist.rotation
			if info.set_scale then 
				vd[item.own_key.."linkee"].RecordScale = auxi.Vector2Table(vs.Scale)
				vs.Scale = Vector(0,0)
			end
			if info.set_anm2 and info.dont_set_anm2 ~= true then
				local anim = vs:GetAnimation() local fr = vs:GetFrame() local finished = vs:IsFinished(anim)
				for u_,v_ in pairs(info.set_anm2) do
					--print(v_)
					vs:ReplaceSpritesheet(v_,"gfx/SE_shadow.png")
				end
				vs:LoadGraphics()
				vs:Play(anim,true) vs:SetFrame(fr) 
				if finished then vs:Update() end
			end
		end
	end

	d[item.own_key.."Updated"] = nil
end

function item.get_order(order,ent,disid,info,real)
	local baseinfo = auxi.check_if_any(order,ent,info) or -1
	if type(baseinfo) == "table" then
		if baseinfo.check then baseinfo = item.target[disid][item.find_entity(table.unpack(baseinfo.check)).id] or baseinfo end
	end
	local veltime = ent:GetData()[item.own_key.."Velocity_Punish"] or 0
	local veltime2 = ent:GetData()[item.own_key.."Velocity_Punish2"] or 0
	local vel_adder = auxi.check_lerp(veltime,item.velocity_punishment).val + auxi.check_lerp(veltime2,item.velocity_punishment2).val
	if auxi.check_exists(ent:GetData()[item.own_key.."Minecart"]) then vel_adder = vel_adder + 666 end
	if real then vel_adder = 0 end
	return baseinfo + vel_adder
end

function item.protect_champion(ent)
	if ent:IsChampion() then
		local cidx = ent:GetChampionColorIdx()
		if item.banish_champion[cidx] then
			cidx = item.banish_champion[cidx]
			item.invisible_flag = true
			ent:Morph(ent.Type,ent.Variant,ent.SubType,cidx)
			item.invisible_flag = nil
		end
	end
end

function item.generate_mixture(ent,params)		--params.tg：ent作为左/右出现
	params = params or {}
	if ent.Type == item.entity_type then return end
	ent = ent:ToNPC() if ent == nil then return end
	local i_dir = params.tg or "Left"
	local r_dir = "Left" if r_dir == i_dir then r_dir = "Right" end
	local iinfo = item.fast_search(i_dir,ent.Type,ent.Variant,ent.SubType)
	local succ = iinfo.id
	if succ and not auxi.check_if_any(iinfo.DontSpawn,ent,iinfo) then
		item.protect_champion(ent)
		local subtype = 0
		if ent:IsBoss() then subtype = 1 end
		--print("Try Mix")
		local q = Isaac.Spawn(item.entity_type,item.entity,subtype,ent.Position,Vector(0,0),nil):ToNPC() 
		local d = q:GetData() 
		d[item.own_key.."effect"] = {no_conduct = params.no_conduct,spawn_once = params.spawn_once,no_conduct_all = params.no_conduct_all,nomainspawn = params.nomainspawn,max_mul = params.max_mul,mul = params.mul,} 
		d[item.own_key.."effect"][i_dir] = {infoid = succ,ent = ent,spawned = true,} 
		if params.another_one then 
			local succ2 = item.fast_search(r_dir,params.another_one.Type,params.another_one.Variant,params.another_one.SubType).id
			if succ2 then params.another_infoid = succ2 else params.another_one = nil end
		end
		if params.make_another and params.another_infoid == nil then
			local succ2 = item.search_in(r_dir,{v = iinfo,NoMulti = params.NoMulti,skip = params.skip,})	--check_uid = true,
			if succ2 then params.another_infoid = succ2.id end
		end
		if params.another_infoid then
			for u,v in pairs(item.targets) do
				if u ~= i_dir then
					d[item.own_key.."effect"][u] = {infoid = params.another_infoid,} 
					if params.another_one then 
						d[item.own_key.."effect"][u].ent = params.another_one 
						d[item.own_key.."effect"][u].ent:GetData()[item.own_key.."linkee"] = {linker = q,infoid = params.another_infoid,tg = u,}
					end
				end
			end
		end
		ent:GetData()[item.own_key.."linkee"] = {linker = q,infoid = succ,tg = i_dir,non_danger = true,main = true,}
		return q
	end
end

--l local danger = require("Mixturer_Extra_scripts.bosses.Danger_Data") local mix = require("Mixturer_Extra_scripts.bosses.Boss_Mixturer") local base_info = {Type = 67,Variant = 0,SubType = 0,} local danger_data = danger.check_data(base_info) q = danger.spawn_it_now(Game():GetPlayer(0),danger_data,nil,nil,{Loadfrominfo = base_info,})[1] local info = mix.targets["Left"][mix.find_entity(20,0,0).id] local qs = q:GetSprite() local anim = qs:GetAnimation() if info.anm2 then qs:Load(info.anm2,true) qs:Play(anim,true) end

--l local mix = require("Mixturer_Extra_scripts.bosses.Boss_Mixturer") local q = Isaac.Spawn(mix.entity_type,mix.entity,0,Vector(160,280),Vector(0,0),nil):ToNPC() local d = q:GetData() d[mix.own_key.."effect"] = {spawn_once = true,max_mul = 7,} d[mix.own_key.."effect"]["Right"] = {infoid = mix.find_entity(240,0,0).id,} d[mix.own_key.."effect"]["Left"] = {infoid = mix.find_entity(18).id,} 
--l local tgs = Isaac.GetRoomEntities() for u,v in pairs(tgs) do if v.Type == 27 then print(v.Type.." "..v.Variant.." "..v.SubType) v = v:ToNPC() print(v.State) print(v:GetSprite():GetAnimation()) print(v.I1.." "..v.I2) print(v.V1) print(v.V2) print(v:GetSprite():GetFrame()) print(v.TargetPosition) print(v.InitSeed) end end
table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_NPC_UPDATE, params = item.entity_type,
Function = function(_,ent)
	if ent.Variant == item.entity then
		local s = ent:GetSprite()
		local d = ent:GetData()
		if d[item.own_key.."effect"] == nil then print("Found Missing") if ent.FrameCount > 10 then ent:Remove() end return end
		d[item.own_key.."effect"] = d[item.own_key.."effect"] or {spawn_once = true,}
		ent:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
		local only_count = false
		for u,v in pairs(item.targets) do
			if d[item.own_key.."effect"][u] == nil then
				local NoMulti = nil local forcetag = nil
				if item.has_friend_flag(ent:GetEntityFlags()) then NoMulti = true forcetag = "noboss" end
				local info = item.search_in(v,{NoMulti = NoMulti,forcetag = forcetag,})	--auxi.random_in_table(v)
				d[item.own_key.."effect"][u] = {infoid = info.id,}
			end
			local info = v[d[item.own_key.."effect"][u].infoid]
			d[item.own_key.."effect"][u].spawners = d[item.own_key.."effect"][u].spawners or {}
			d[item.own_key.."effect"][u].Data = d[item.own_key.."effect"][u].Data or {}		--只是给精神错乱用的
			if info.only_count then only_count = true end
		end
		if ent:IsDead() then
			for u_,v_ in pairs(item.targets) do
				local this = d[item.own_key.."effect"][u_]
				if auxi.check_all_exists(this.ent) then
					item.time_free(this.ent,item.own_key.."Jump")
					item.time_free(this.ent)
				end
			end
		end
		for u,v in pairs(item.targets) do
			local info = v[d[item.own_key.."effect"][u].infoid]
			for _ =1,1 do if auxi.check_all_exists(d[item.own_key.."effect"][u].ent) ~= true then
				if (d[item.own_key.."effect"][u].spawned and d[item.own_key.."effect"].spawn_once) and (only_count == false or info.only_count) then
					if info.protect_self and auxi.check_exists(d[item.own_key.."effect"][u].ent) then 
						--print("Protected")
						d[item.own_key.."effect"][u].protected = (d[item.own_key.."effect"][u].protected or 0) + 1
						if d[item.own_key.."effect"][u].protected <= (info.protect_time or 1) then
							break 
						end
					end
					for u_,v_ in pairs(item.targets) do
						local this = d[item.own_key.."effect"][u_]
						if auxi.check_all_exists(this.ent) then
							item.time_free(this.ent,item.own_key.."Jump")
							item.time_free(this.ent)
						end
					end
					--if info.only_count then print("Removed") end
					ent.Variant = 0 ent:Remove() return
				end
				--print("Try Generate "..ent.InitSeed)
				item.invisible_flag = true
				if d[item.own_key.."effect"][u].ent then 
					--print("Try Remove")
					d[item.own_key.."effect"][u].ent:Remove() 
				end
				local tp = info.type local vr = info.variant or 0 local st = info.subtype or 0
				local base_info = {Type = tp,Variant = vr,SubType = st,}
				local danger_data = danger.check_data(base_info)
				local q = nil
				--print("Try Spawn "..tp.." "..vr.." "..st)
				if danger_data then 
					local mul = d[item.own_key.."effect"].mul 
					local max_mul = d[item.own_key.."effect"].max_mul
					if not item.has_friend_flag(ent:GetEntityFlags()) and (not d[item.own_key.."effect"].no_conduct) and (not d[item.own_key.."effect"].nomainspawn) and info.need_multi then 
						local succ = true
						for u_,v_ in pairs(item.targets) do
							if u_ ~= u then
								local this = d[item.own_key.."effect"][u_]
								local thisinfo = v_[this.infoid]
								if thisinfo.is_multi or thisinfo.can_multi or (thisinfo.need_multi and this.need_multi == true) then succ = false break end
							end
						end
						if succ then
							d[item.own_key.."effect"][u].need_multi = true
							mul = auxi.choose2(info.need_multi)
						end
					end
					qs = danger.spawn_it_now(ent,danger_data,nil,nil,{Loadfrominfo = base_info,mul = mul,max_mul = max_mul,real_mul = mul,})
					local qsid = #qs
					for i = #qs,1,-1 do
						if qs[i].Type == tp and qs[i].Variant == vr and qs[i].SubType == st then qsid = i break end
					end
					q = qs[qsid]
					if info.Recheck_on_init then	--用于处理特殊情况下，无法复数生成的实体
						if q.Type ~= tp or q.Variant ~= vr or q.SubType ~= st then
							local iinfo = item.fast_search(u,q.Type,q.Variant,q.SubType)
							if iinfo then 
								d[item.own_key.."effect"][u].infoid = iinfo.id
								info = iinfo 
							end
						end
					end
					for u_,v_ in pairs(qs) do table.insert(d[item.own_key.."effect"][u].spawners,v_) end
					local tinfo = nil
					for uu,vv in pairs(item.targets) do 
						if u ~= uu then 
							local tgcid = d[item.own_key.."effect"][uu].infoid 
							tinfo = item.targets[uu][tgcid]
							if tinfo.is_multi or tinfo.can_multi then tinfo = nil end
							break
						end 
					end
					if tinfo then
						if not d[item.own_key.."effect"].no_conduct then
							for u_,v_ in pairs(qs) do
								if u_ ~= qsid then
									local tgcid = tinfo.id
									local succ = true
									if tinfo.NotSpawn then tgcid = nil end
									if succ then
										item.generate_mixture(v_,{another_infoid = tgcid,make_another = true,no_conduct = true,spawn_once = d[item.own_key.."effect"].spawn_once,tg = auxi.choose('Left','Right'),max_mul = 3,NoMulti = true,skip = true,})
										--mul = d[item.own_key.."effect"].mul,
									end
								end
							end
						end
					end
				else q = Isaac.Spawn(tp,vr,st,ent.Position,Vector(0,0),ent):ToNPC() table.insert(d[item.own_key.."effect"][u].spawners,q) end
				if q.SubType ~= st then q.SubType = st end
				if info.InitPosoffset then q.Position = ent.Position + info.InitPosoffset end
				if info.InitTarget then q.TargetPosition = ent.Position end
				q:GetData()[item.own_key.."linkee"] = {linker = ent,infoid = info.id,tg = u,}
				d[item.own_key.."effect"][u].ent = q
				if info.no_appear_flag then q:ClearEntityFlags(EntityFlag.FLAG_APPEAR) end
				item.invisible_flag = false
				d[item.own_key.."effect"][u].spawned = true
			end end
			local this = d[item.own_key.."effect"][u] local thisd = this.ent:GetData()
			thisd[item.own_key.."linkee"] = thisd[item.own_key.."linkee"] or {linker = ent,infoid = this.infoid,tg = u,}
			if info.ProtectMyData then 
				thisd = d[item.own_key.."effect"][u].Data 
				d[item.own_key.."effect"][u].Deli = true
				d[item.own_key.."effect"].Deli = true
			end
			if thisd[item.own_key.."animshift"] == nil then
				local q = this.ent
				thisd[item.own_key.."animshift"] = true
				local qs = q:GetSprite() local anim = qs:GetAnimation()
				if info.anm2 and not info.DontLoad then 
					local filename = info.anm2
					if d[item.own_key.."effect"][u].forceSide then
						filename = filename:gsub('left.anm2',d[item.own_key.."effect"][u].forceSide..".anm2"):gsub('right.anm2',d[item.own_key.."effect"][u].forceSide..".anm2")
					end
					qs:Load(filename,true) qs:Play(anim,true) 
				end
			end
			if info.release_self then 
				d[item.own_key.."effect"][u].ent:GetData()[item.own_key.."linkee"] = nil
				d[item.own_key.."effect"][u].ent = nil 
				d[item.own_key.."effect"][u].spawners = {}
				for u_,v_ in pairs(item.targets) do
					for uu,vv in pairs(d[item.own_key.."effect"][u_].spawners) do
						vv:Remove()
					end
				end
				ent.Variant = 0
				ent:Remove()
				return
			end
			if info.larry then d[item.own_key.."larry"] = true end
			if (info.uid == 1 or info.NoKill) then
				ent.SubType = 1
				ent:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)		-- | EntityFlag.FLAG_NO_REWARD
			end
			--d[item.own_key.."effect"][u].ent.Visible = false
		end
		d[item.own_key.."effect"]["baseinfo"] = d[item.own_key.."effect"]["baseinfo"] or {tg = "Left",}
		
		local has_friend_flag = item.has_friend_flag(ent:GetEntityFlags())
		for u,v in pairs(item.targets) do
			local ve = d[item.own_key.."effect"][u]
			local au = "Left" if u == au then au = "Right" end
			local anotherid = d[item.own_key.."effect"][au].infoid
			if anotherid then 
				if d[item.own_key.."effect"].nomainspawn and not (ve.ent:GetData()[item.own_key.."linkee"] or {}).main then
				else
					ve.ent:GetData()[item.own_key.."linkee"].anotherid = anotherid 
				end
			end
			if ve.ent:IsChampion() then
				item.protect_champion(ve.ent)
				local cidx = ve.ent:GetChampionColorIdx()
				if not ent:IsChampion() then 
					--print("Champion "..tostring(cidx))
					ent:MakeChampion(ent.InitSeed,cidx) 
				end
			end
			if ve.ent:HasEntityFlags(EntityFlag.FLAG_AMBUSH) then 
				ent:AddEntityFlags(EntityFlag.FLAG_AMBUSH)
			end
			if not has_friend_flag and item.has_friend_flag(ve.ent:GetEntityFlags()) then
				if (ent.SubType == 1 and ve.ent:IsBoss()) or ent.SubType == 0 then has_friend_flag = true
				else ve.ent:ClearEntityFlags(item.friend_flag) end
			end
		end
		if has_friend_flag then
			--print("Found Friend Flag")
			ent:AddEntityFlags(item.friend_flag | EntityFlag.FLAG_PERSISTENT)
			for u,v in pairs(item.targets) do
				local ve = d[item.own_key.."effect"][u]
				--local info = v[ve.infoid]
				ve.ent:AddEntityFlags(item.friend_flag | EntityFlag.FLAG_PERSISTENT)
				--[[
				if ve.ent:ToNPC().CanShutDoors then
					
				else
					ve.ent:ClearEntityFlags(item.friend_flag | EntityFlag.FLAG_PERSISTENT)
				end
				]]
			end
		end
		if not d[item.own_key.."effect"].init then
			--print("Init Hitpoints")
			d[item.own_key.."effect"].init = {}
			d[item.own_key.."effect"].Hitpoints = 0
			local totalval = 0
			local totalval2 = 0
			for u,v in pairs(item.targets) do
				local ve = d[item.own_key.."effect"][u]
				local info = v[d[item.own_key.."effect"][u].infoid]
				info = item.protect_delirium(ve.ent,u,info)
				local basehitpoints = ve.ent.MaxHitPoints
				if info.HitPoints then basehitpoints = auxi.check_if_any(info.HitPoints,basehitpoints,ve.ent) or basehitpoints end
				local mult = 1
				local vals = (save.ControlData or {}).mixhprate or {}
				if (ve.ent:GetData()[item.own_key.."linkee"] or {}).main then mult = vals.main or 4
				else mult = vals.nomain or 1 end
				d[item.own_key.."effect"].Hitpoints = d[item.own_key.."effect"].Hitpoints + basehitpoints * mult
				if mult <= 0.01 then totalval2 = totalval2 + basehitpoints end
				totalval = totalval + mult
			end
			if totalval <= 0.01 then 
				d[item.own_key.."effect"].Hitpoints = totalval2
				totalval = 1 
			end
			local lev = math.max(0,item.get_id_level() * 0.1 - 0.3) + 1
			d[item.own_key.."effect"].TotalVal = totalval
			ent.MaxHitPoints = d[item.own_key.."effect"].Hitpoints / totalval * lev
			ent.HitPoints = d[item.own_key.."effect"].Hitpoints / totalval * lev
		end
		if not d[item.own_key.."effect"].init_size then
			d[item.own_key.."effect"].init_size = {}
			d[item.own_key.."effect"].size = d[item.own_key.."effect"].size or 999
			for u,v in pairs(item.targets) do
				local ve = d[item.own_key.."effect"][u]
				d[item.own_key.."effect"].size = math.min(d[item.own_key.."effect"].size,ve.ent.Size)
				local vd = ve.ent:GetData()
				if vd[item.own_key.."linkee"] then
					vd[item.own_key.."linkee"].size = vd[item.own_key.."linkee"].size or ve.ent.Size
				end
			end
		end
		ent.Size = d[item.own_key.."effect"].size
		local shade_size = (ent.Size + 2)/100
		for u,v in pairs(item.targets) do
			local this = d[item.own_key.."effect"][u]
			local thisinfo = item.targets[u][this.infoid]
			thisinfo = item.protect_delirium(this.ent,u,thisinfo)
			if thisinfo.no_shade then shade_size = 0 end
			if REPENTOGON and ent.Size == this.ent.Size then shade_size = math.min(shade_size,this.ent:GetShadowSize()) end
			if thisinfo.init and this.init == nil then 
				auxi.check_if_any(thisinfo.init,this.ent,ent,thisinfo)
				this.init = true
			end
			if d[item.own_key.."larry"] then this.ent:GetData()[item.own_key.."larry"] = true end
			local vd = this.ent:GetData()
			if this.ent.Velocity:Length() < 0.5 then vd[item.own_key.."Velocity_Punish"] = (vd[item.own_key.."Velocity_Punish"] or 0) + 1 else vd[item.own_key.."Velocity_Punish"] = nil end
			if this.ent.GridCollisionClass >= 4 then 
				local room = Game():GetRoom() local gidx = room:GetGridIndex(this.ent.Position)
				if vd[item.own_key.."gridpos"] == gidx then
					vd[item.own_key.."Velocity_Punish2"] = (vd[item.own_key.."Velocity_Punish2"] or 0) + 1
				else 
					vd[item.own_key.."Velocity_Punish2"] = (vd[item.own_key.."Velocity_Punish2"] or 0) - 5 
					if vd[item.own_key.."Velocity_Punish2"] <= 0 then vd[item.own_key.."Velocity_Punish2"] = nil end
				end
				if vd[item.own_key.."Velocity_Punish2"] == nil then
					vd[item.own_key.."gridpos"] = gidx
				end
			else
				vd[item.own_key.."Velocity_Punish2"] = nil
			end
		end

		local baseinfo = d[item.own_key.."effect"]["baseinfo"]
		local tg = d[item.own_key.."effect"][baseinfo.tg]
		local tgname = baseinfo.tg
		local tginfo = item.targets[baseinfo.tg][tg.infoid]
		tginfo = item.protect_delirium(tg.ent,baseinfo.tg,tginfo)
		local largest_order = item.get_order(tginfo.order,tg.ent,baseinfo.tg,tginfo)
		d[item.own_key.."Updated"] = true
		d[item.own_key.."swap_counter"] = (d[item.own_key.."swap_counter"] or 0) + 1
		local should_protect = false
		for u,v in pairs(item.targets) do
			local this = d[item.own_key.."effect"][u]
			local thisd = this.ent:GetData()
			local thisinfo = item.targets[u][this.infoid]
			thisinfo = item.protect_delirium(this.ent,u,thisinfo)
			thisd[item.own_key.."state_swap_counter"] = (thisd[item.own_key.."state_swap_counter"] or 0) + 1
			thisd[item.own_key.."rnd"] = thisd[item.own_key.."rnd"] or (auxi.random_1() * (auxi.check_if_any(thisinfo.rnds,this.ent) or 1) + (auxi.check_if_any(thisinfo.rnds_add,this.ent) or 0))
			if (thisd[item.own_key.."state"] or this.ent.State) ~= this.ent.State then 
				thisd[item.own_key.."state_updated"] = true 
				if thisd[item.own_key.."state_swap_counter"] > 20 then 
					thisd[item.own_key.."rnd"] = auxi.random_1() * (auxi.check_if_any(thisinfo.rnds,this.ent) or 1) + (auxi.check_if_any(thisinfo.rnds_add,this.ent) or 0) 
					thisd[item.own_key.."state_swap_counter"] = 0
				end
			end
			if ent.FrameCount % 60 == 0 and (thisd[item.own_key.."state_updated"] ~= true or thisd[item.own_key.."state_swap_counter"] > 120) then 
				thisd[item.own_key.."rnd"] = auxi.random_1() * (auxi.check_if_any(thisinfo.rnds,this.ent) or 1) + (auxi.check_if_any(thisinfo.rnds_add,this.ent) or 0)
			end
			thisd[item.own_key.."state"] = this.ent.State
		end
		local order_rnd = largest_order * 5 + tg.ent:GetData()[item.own_key.."rnd"]
		if -1 <= largest_order and largest_order <= 0 then 
			order_rnd = largest_order * 0.5 + tg.ent:GetData()[item.own_key.."rnd"]
		end
		for u,v in pairs(item.targets) do
			local this = d[item.own_key.."effect"][u]
			local thisd = this.ent:GetData()
			local thisinfo = item.targets[u][this.infoid]
			thisinfo = item.protect_delirium(this.ent,u,thisinfo)
			local thisorder = item.get_order(thisinfo.order,this.ent,u,thisinfo)
			local this_order_rnd = thisorder * 5 + this.ent:GetData()[item.own_key.."rnd"]
			if -1 <= thisorder and thisorder <= 0 then 
				this_order_rnd = thisorder * 0.5 + this.ent:GetData()[item.own_key.."rnd"]
			end
			--需要设置，不同level的order对应的覆盖情况
			local succ = false
			if this_order_rnd > order_rnd then succ = true
			--elseif this_order_rnd == largest_order then
			--	if (thisd[item.own_key.."rnd"] or 0) > (tg.ent:GetData()[item.own_key.."rnd"] or 0) then succ = true end
			end
			if succ then
				auxi.check_if_any(thisinfo.on_swap,this.ent,thisinfo,true)
				auxi.check_if_any(tginfo.on_swap,tg.ent,tginfo,false)
				tg = this tgname = u tginfo = thisinfo
				largest_order = thisorder
				order_rnd = this_order_rnd
				d[item.own_key.."swap_counter"] = 0
			end

			if thisinfo.protect_self then should_protect = true end		--需要优化
			if thisinfo.AutoRegen and ent.FrameCount % 10 == 2 then ent.HitPoints = math.min(ent.MaxHitPoints,ent.HitPoints + 1) end
		end
		--local try_kill = nil
		--[[
		if ent:HasEntityFlags(EntityFlag.FLAG_KILLSWITCH) then 
			ent:ClearEntityFlags(EntityFlag.FLAG_KILLSWITCH)
			ent.HitPoints = -1 ent:TakeDamage(1,0,EntityRef(ent),666)
			--try_kill = true
		end
		--]]
		local should_protect_health = false
		for u,v in pairs(item.targets) do
			local this = d[item.own_key.."effect"][u]
			local info = v[this.infoid]
			info = item.protect_delirium(this.ent,u,info)
			--this.ent:ClearEntityFlags(EntityFlag.FLAG_KILLSWITCH)
			if info.protect_self then should_protect_health = true end
			if should_protect then
				if info.protect_self then 
					this.ent.HitPoints = this.ent.MaxHitPoints * ent.HitPoints/ent.MaxHitPoints
					if ent:HasMortalDamage() then 
						--print("Try Kill")
						this.ent.HitPoints = -1 this.ent:TakeDamage(1,0,EntityRef(ent),666)
						--if not this.ent:HasMortalDamage() then this.ent:Kill() end
						if item.has_friend_flag(this.ent:GetEntityFlags()) then ent:Kill() end
						if info.on_kill then auxi.check_if_any(info.on_kill,this.ent) end
					end
				else this.ent.HitPoints = this.ent.MaxHitPoints * ent.HitPoints/ent.MaxHitPoints + 1 end
			else
				this.ent.HitPoints = this.ent.MaxHitPoints * ent.HitPoints/ent.MaxHitPoints
				--if try_kill then this.ent:TakeDamage(1,0,EntityRef(ent),666) end
			end
		end
		-- and not item.has_friend_flag(ent:GetEntityFlags())
		if should_protect_health then
			if ent:HasMortalDamage() then 
				ent.HitPoints = ent.HitPoints + 99999 
				d[item.own_key.."effect"].init = nil
			end
		end
		if d[item.own_key.."swap_counter"] == 0 then
			for u,v in pairs(item.targets) do
				local this = d[item.own_key.."effect"][u]
				local thisd = this.ent:GetData()
				if thisd[item.own_key.."GridCollision"] then Attribute_holder.try_rewind_attribute(this.ent,"GridCollisionClass",thisd[item.own_key.."GridCollision"]) thisd[item.own_key.."GridCollision"] = nil end
			end
		end
		d[item.own_key.."effect"]["baseinfo"].tg = tgname
		--print(tg.ent.PositionOffset * 0.1)
		d[item.own_key.."recordposoffset"] = (d[item.own_key.."recordposoffset"] or tg.ent.PositionOffset) * 0.9 + tg.ent.PositionOffset * 0.1		--这里不对
		--非RGON情况下，不能做num *const vec
		d[item.own_key.."posoffset"] = tg.ent.PositionOffset
		
		local baseinfo = d[item.own_key.."effect"]["baseinfo"]
		local tg = d[item.own_key.."effect"][baseinfo.tg]
		--item.deal_with_mixture(ent)
		local tgs = tg.ent:GetSprite() local scale_offset = tgs.Scale.Y
		local i_flag = 0 --EntityFlag.FLAG_NO_REWARD | EntityFlag.FLAG_NO_STATUS_EFFECTS | EntityFlag.FLAG_NO_TARGET --EntityFlag.FLAG_NO_PLAYER_CONTROL | EntityFlag.FLAG_DONT_OVERWRITE | EntityFlag.FLAG_NO_TARGET | EntityFlag.FLAG_NO_QUERY

		ent:AddEntityFlags(i_flag)
		local base_grid_collision = tg.ent.GridCollisionClass
		local add_vel = Vector(0,0)
		for u,v in pairs(item.targets) do
			if u ~= baseinfo.tg then
				local this = d[item.own_key.."effect"][u]
				local info = v[this.infoid]
				info = item.protect_delirium(this.ent,u,info)
				local thiss = this.ent:GetSprite() local thisd = this.ent:GetData()
				scale_offset = scale_offset * thiss.Scale.Y
				local thisd = this.ent:GetData()
				if info.follow_gridcollision then
					if auxi.check_if_any(info.follow_gridcollision,this.ent,tg.ent) then thisd[item.own_key.."GridCollision"] = thisd[item.own_key.."GridCollision"] or Attribute_holder.try_hold_attribute(this.ent,"GridCollisionClass",function(ent) return tg.ent.GridCollisionClass end) 
					elseif thisd[item.own_key.."GridCollision"] then Attribute_holder.try_rewind_attribute(this.ent,"GridCollisionClass",thisd[item.own_key.."GridCollision"]) thisd[item.own_key.."GridCollision"] = nil end 
				end
				auxi.check_if_any(info.special,this.ent,ent,false,info)
				this.ent:AddEntityFlags(i_flag)
				add_vel = add_vel + (auxi.check_if_any(info.AddVelocity,this.ent) or Vector(0,0))
				base_grid_collision = item.elect_grid_collision(base_grid_collision,this.ent.GridCollisionClass)
			else
				local this = d[item.own_key.."effect"][u]
				local thisd = this.ent:GetData()
				local info = v[this.infoid]
				info = item.protect_delirium(this.ent,u,info)
				auxi.check_if_any(info.special,this.ent,ent,true,info)
				this.ent:AddEntityFlags(i_flag)
				--this.ent:ClearEntityFlags(i_flag)
				--if thisd[item.own_key.."GridCollision"] then Attribute_holder.try_rewind_attribute(this.ent,"GridCollisionClass",thisd[item.own_key.."GridCollision"]) thisd[item.own_key.."GridCollision"] = nil end
			end
		end
		local real_pos = tg.ent.Position
		if tginfo.naturally_move_back then
			local cnt = d[item.own_key.."swap_counter"]
			if tginfo.Reset_counter then cnt = math.min(cnt,tg.ent:GetData()[item.own_key.."state_swap_counter"]) end
			if type(tginfo.naturally_move_back) == "number" then cnt = cnt * tginfo.naturally_move_back end
			--print(cnt)
			local mov_rate = auxi.check_lerp(cnt,item.swap_move_info).val
			local o_center_pos = Vector(0,0) local ocnt = 0
			for u,v in pairs(item.targets) do
				if u ~= baseinfo.tg then
					o_center_pos = o_center_pos + d[item.own_key.."effect"][u].ent.Position
					ocnt = ocnt + 1
				end
			end
			--print(o_center_pos)
			--print(tg.ent.Position)
			if ocnt > 0 then o_center_pos = o_center_pos/ocnt else o_center_pos = tg.ent.Position end
			tg.ent.Position = mov_rate * o_center_pos + (1 - mov_rate) * tg.ent.Position
		end
		tg.ent.Position = tg.ent.Position + add_vel
		local delta_pos = auxi.check_if_any(tginfo.delta_pos,tg.ent) or Vector(0,0)
		d[item.own_key.."scaleoffset"] = scale_offset
		local tgcoll = auxi.check_if_any(tginfo.check_collisionclass,tg.ent,tg.ent.EntityCollisionClass) or tg.ent.EntityCollisionClass
		--base_grid_collision = auxi.check_if_any(tginfo.check_grid_collisionclass,tg.ent,tg.ent.GridCollisionClass) or base_grid_collision
		ent.EntityCollisionClass = tgcoll
		ent.CollisionDamage = auxi.check_if_any(tginfo.CollisionDamage,tg.ent) or tg.ent.CollisionDamage
		--ent.Mass = tg.ent.Mass
		ent.GridCollisionClass = base_grid_collision--tg.ent.GridCollisionClass
		ent.Position = tg.ent.Position + delta_pos
		ent.PositionOffset = tg.ent.PositionOffset
		if auxi.check_if_any(tginfo.prevent_velocity,tg.ent,tginfo) then
			ent.Velocity = Vector(0,0)
		else
			ent.Velocity = tg.ent.Velocity
		end

		if tginfo.HideAll and auxi.check_if_any(tginfo.set_visible,tg.ent) == false then shade_size = 0 end
		if REPENTOGON then 
			ent:SetShadowSize(shade_size)
		else 
			local s = ent:GetSprite() local anim = s:GetAnimation()
			if anim ~= "Shadow" then s:Play("Shadow",true) end
			--ent.SpriteScale = Vector(shade_size,shade_size) * (TEST_VAL or 1)
			ent:GetData()[item.own_key.."scaleeffect"] = Vector(shade_size,shade_size) * 8
			d[item.own_key.."Scale"] = d[item.own_key.."Scale"] or Attribute_holder.try_hold_attribute(ent,"SpriteScale",function(ent) return (ent:GetData()[item.own_key.."scaleeffect"] or Vector(1,1)) or ent.SpriteScale end,{protect = true,})
		end		--奇怪的bug导致贴图不正确

		for u,v in pairs(item.targets) do
			--d[item.own_key.."effect"][u].ent.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
			local this = d[item.own_key.."effect"][u]
			local info = v[this.infoid]
			info = item.protect_delirium(this.ent,u,info)
			if u == baseinfo.tg then
				d[item.own_key.."effect"][u].ent.Size = ent.Size
			else 
				d[item.own_key.."effect"][u].ent.Size = 0
				if info.protect_pos then 
					if type(info.protect_pos) == "function" then auxi.check_if_any(info.protect_pos,this.ent,thisinfo)
					else local room = Game():GetRoom() this.ent.Position = room:GetClampedPosition(tg.ent.Position,0) end
				else this.ent.Position = tg.ent.Position end

				if auxi.check_if_any(info.KeepTarget,this.ent) then this.ent.TargetPosition = tg.ent.Position end
				--this.ent.PositionOffset = tg.ent.PositionOffset + tg.ent.Position - this.ent.Position
				if auxi.check_if_any(info.HelpVelocity,this.ent) then this.ent.Velocity = ent.Velocity end
			end
			if auxi.check_if_any(info.KeepTarget_Special,this.ent) then this.ent.TargetPosition = ent.Position end
		end
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_NPC_UPDATE, params = 965,
Function = function(_,ent)
	if ent.ChildNPC then
		local cd = ent.ChildNPC:GetData()
		cd[item.own_key.."Minecart"] = ent
	end
end,
})

table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_PRE_GAME_EXIT, params = nil,
Function = function(_)
	for u,v in pairs(Isaac.GetRoomEntities()) do
        if v:GetData()[item.own_key.."linkee"] and item.has_friend_flag(v:GetEntityFlags()) then
			print("Clear "..v.Type)
            v:ClearEntityFlags(item.friend_flag | EntityFlag.FLAG_PERSISTENT)
            v:Remove()
        end
    end
end,
})


if HPBars then
	local ID = item.entity_type.."."..item.entity
	HPBars.BossIgnoreList[ID] = function(ent)
		return true
	end
end

return item