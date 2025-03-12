local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")
local enums = require("Mixturer_Extra_scripts.core.enums")
local Attribute_holder = require("Mixturer_Extra_scripts.others.Attribute_holder")
local addeffe = delay_buffer.addeffe
local funct = {}
local auxi = funct		--

function funct.MakeBitSet(i)
	if i >= 64 then
		return BitSet128(0,1<<(i-64))
	else
		return BitSet128(1<<(i),0)
	end
end 

function funct.check_empty_table(tbl)
	if type(tbl) ~= "table" then return false end
	if (#tbl == 0) then return true end	
	return false
end

function funct.rng_for_sake(rng)
	if rng then
		if rng:GetSeed() == 0 then
			rng:SetSeed(-1,0)
		end
		return rng
	else
		return nil
	end
end

function funct.seed_rng(seed)
	if seed == 0 then seed = -1 end
	local rng = RNG()
	rng:SetSeed(seed,0)
	return rng
end

function funct.bitset_flag(x,i)	--获取x第i位是否含有1。
	if i >= 64 then
		return (x & BitSet128(0,1<<(i-64)) == BitSet128(0,1<<(i-64)))
	else
		return (x & BitSet128(1<<(i),0) == BitSet128(1<<(i),0))
	end
end

function funct.Count_Flags(x)
	local ret = 0
	for i = 0, math.floor(math.log(x)/math.log(2)) +1 do
		if x%2==1 then
			ret = ret + 1
		end
		x = (x-x%2)/2
	end
	return ret
end

function funct.Get_Flags(x,fl)	--从第0位开始计算flag
	if (math.floor(x/(1<<fl)) %2 == 1) then
		return true
	end
	return false
end

function funct.Get_rotate(t)		--接收一个vector，获取旋转90度的vector
	return Vector(-t.Y,t.X)
end

function funct.plu_s(v1,v2)
	return v1.X*v2.X+v1.Y*v2.Y
end

function funct.mul_t(v1,v2)
	return Vector(v1.X*v2.X,v1.Y*v2.Y)
end

function funct.MakeVector(x)
	return Vector(math.cos(math.rad(x)),math.sin(math.rad(x)))
end

function funct.AddColor(col_1,col_2,x,y,isKColor)
	if isKColor then
		return KColor(col_1.R * x + col_2.R * y,col_1.G * x+ col_2.G * y,col_1.B * x+ col_2.B * y,col_1.A * x+ col_2.A * y,col_1.RO * x+ col_2.RO * y,col_1.GO * x+ col_2.GO * y,col_1.BO * x+ col_2.BO * y)
	else
		return Color(col_1.R * x + col_2.R * y,col_1.G * x+ col_2.G * y,col_1.B * x+ col_2.B * y,col_1.A * x+ col_2.A * y,col_1.RO * x+ col_2.RO * y,col_1.GO * x+ col_2.GO * y,col_1.BO * x+ col_2.BO * y)
	end
end

function funct.MulColor(col_1,col_2)
	return Color(col_1.R * col_2.R,col_1.G * col_2.G,col_1.B * col_2.B,col_1.A *col_2.A ,col_1.RO *col_2.RO ,col_1.GO *col_2.GO ,col_1.BO *col_2.BO )
end
function funct.MulColor2(col_1,col_2)		--修正后的版本，让上限值向上而不是向下。
	return Color(col_1.R * col_2.R,col_1.G * col_2.G,col_1.B * col_2.B,col_1.A *col_2.A ,1 - (1 - col_1.RO) * (1 - col_2.RO),1 - (1 - col_1.BO) * (1 - col_2.BO),1 - (1 - col_1.GO) * (1 - col_2.GO))
end

function funct.TearsUp(firedelay, val)
    local currentTears = 30 / (firedelay + 1)
    local newTears = currentTears + val
    return math.max((30 / newTears) - 1, -0.99)
end

local real_dir_list = {		--细节：同时按的时候有一个方向做主。
	[4] = Vector(-1.00001,0),
	[5] = Vector(1,0),
	[6] = Vector(0,-1.00001),
	[7] = Vector(0,1),
}

function funct.ggrealdir(player)
	player = player or Game():GetPlayer(0)
	local ret = Vector(0,0)
	local ctrlid = player.ControllerIndex
	for u,v in pairs({4,5,6,7}) do
		if Input.GetActionValue(v,ctrlid) > 0.7 or Input.IsActionTriggered(v,ctrlid) or Input.IsActionPressed(v,ctrlid) then ret = ret + real_dir_list[v] end
	end
	if Game():GetRoom():IsMirrorWorld() == true then ret = Vector(-ret.X,ret.Y) end
	return ret:Normalized()
end

function funct.getdir(player,real)
	player = player or Game():GetPlayer(0)
	if real ~= nil then return funct.ggrealdir(player) end
	local ret = player:GetShootingInput()
	if ret:Length() > 0.05 then
		ret = ret / ret:Length()
	end
	return ret
end

function funct.getmov(player)
	if player == nil then
		print("Wrong player in function::getmov()")
		return Vector(0,0)
	end
	local ret = player:GetMovementInput()
	if ret:Length() > 0.05 then
		ret = ret / ret:Length()
	end
	return ret
end

function funct.g_dir_can_work(player)
	return player:AreControlsEnabled() and player:GetData().should_not_attack ~= true and player:IsExtraAnimationFinished() and player.Visible ~= false
end

function funct.ggdir(player,ignore_marked,allow_mouse,ignore_mouse_press,center,params)
	params = params or {}
	if params.ignore_canwork == nil and funct.g_dir_can_work(player) == false then return Vector(0,0) end
	if ignore_marked == false then
		if player:HasCollectible(394) or player:HasCollectible(572) then		--别忘了准星！
			local n_entity = Isaac.GetRoomEntities()
			for i = 1, #n_entity do
				if n_entity[i] and n_entity[i].Type == 1000 and (n_entity[i].Variant == 153 or n_entity[i].Variant == 30) then
					local dir = (n_entity[i].Position - player.Position):Normalized()
					return dir
				end
			end
		end
	end
	local dir = funct.getdir(player,params.real)
	center = center or player.Position
	if dir:Length() < 0.05 then
		if allow_mouse and allow_mouse == true then
			if (player.ControllerIndex == 0) then
				if (Input.IsMouseBtnPressed(0) or ignore_mouse_press) then
					local leg_pos = (Input.GetMousePosition(true) - center)
					if leg_pos:Length() > 10 then
						dir = leg_pos:Normalized()
					elseif ignore_mouse_press then
						if leg_pos:Length() > 1 then
							dir = leg_pos/10
						end
					end
				end
			end
		end
	end
	return dir
end

function funct.ggmov_dir_is_zero(player,SPQinghelper,allow_mouse,upon_click,center)		--传入player与一个辅助参数。
	if SPQinghelper == nil then SPQinghelper = false end
	if player:AreControlsEnabled() == false and SPQinghelper == true then
		return false
	end
	if (player:IsExtraAnimationFinished() == false or player.Visible == false) and SPQinghelper == true then
		return false
	end
	local dir = funct.ggdir(player,false,allow_mouse,upon_click,center)
	local mov = funct.getmov(player)
	return (dir:Length() < 0.05 and mov:Length() < 0.05)
end

function funct.getpickups(ents,ignore_items)
	local pickups = {}
    for _, ent in ipairs(ents) do
        if ent.Type == 5 and (ignore_items == false or ent.Variant ~= 100) then
            pickups[#pickups + 1] = ent
        end
    end
	return pickups
end

function funct.has_enemies(ents,checker)
	checker = checker or true
	ents = ents or Isaac.GetRoomEntities()
	local enemies = {}
    for _, ent in ipairs(ents) do
        if funct.isenemies(ent) and funct.check_if_any(checker,ent) then return true end
    end
	return false
end

function funct.getallenemies(ents,checker)
	checker = checker or true
	ents = ents or Isaac.GetRoomEntities()
	local ret = {}
    for _, v in ipairs(ents) do
        if v:ToNPC() and v:IsEnemy() and funct.check_if_any(checker,ent) then
            table.insert(ret,v)
        end
    end
	return ret
end

function funct.getenemies(ents,checker)
	checker = checker or true
	ents = ents or Isaac.GetRoomEntities()
	local enemies = {}
    for _, ent in ipairs(ents) do
        if funct.isenemies(ent) and funct.check_if_any(checker,ent) then
            enemies[#enemies + 1] = ent
        end
    end
	return enemies
end

function funct.isenemies(ent)
	if ent:IsVulnerableEnemy() and ent:IsActiveEnemy() and not ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
		return true
	end
	return false
end

function funct.getothers(ents,x,y,z,check_funct)
	ents = ents or Isaac.GetRoomEntities()
	local targs = {}
    for _, ent in ipairs(ents) do
        if x == nil or ent.Type == x then
			if y == nil or ent.Variant == y then
				if z == nil or ent.SubType == z then
					if check_funct == nil or check_funct(ent) == true then
						targs[#targs + 1] = ent
					end
				end
			end
        end
    end
	return targs
end

function funct.getmultishot(cnt1,cnt2,id,cnt3)		--cnt1:总数量；cnt2：巫师帽数量；cnt3：宝宝套
	local cnt = math.ceil(cnt1/cnt2)		--此为每一弹道发射的眼泪数。不计入宝宝套给予的额外2发。
	if cnt3 == 1 and cnt2 < 3 then
		cnt = math.ceil((cnt1-2)/cnt2)
	end
	if cnt2 > 2 then
		cnt3 = 0
	end
	local dir = 180 / (cnt2+1)
	local inv1 = 30			--非常奇怪，存在巫师帽的时候，那个间隔随着cnt增大而减小，并不是特别好测量，因此我也就意思一下了（，不存在的时候，大概是10到5度角左右。
	local inv2 = 5 + cnt
	local inv3 = 5
	if cnt3 == 1 then			--存在宝宝套
		if cnt2 == 1 then		--单弹道+宝宝套
			if id == 1 then			--冷知识：宝宝套两个方向的弹道实际上不对称！不过我才懒得做适配……
				return 45
			elseif id == cnt1 then
				return 135
			else
				return 90 - (cnt-1)/2 * inv3 + (id-2) * inv3			--考虑以5度为间隔，关于90度镜像阵列。
			end
		else		--巫师帽宝宝套，双弹道多发。
			if id - 1 > cnt then
				return 45 - (cnt-1)/2 * inv2 + (id - cnt - 1) * inv2
			else
				return 135 - (cnt-1)/2 *inv2 + (id - 1) * inv2
			end
		end
	else
		local grp = math.floor((id-1)/cnt)	--id号攻击属于的弹道数（0到cnt2-1）
		if cnt2 ~= 1 then
			return (grp + 1) * dir - (cnt-1)/2 * inv1 + (id-1 - grp * cnt) * inv1
		else
			return (grp + 1) * dir - (cnt-1)/2 * inv2 + (id-1 - grp * cnt) * inv2
		end
	end
end

function funct.trychangegrid(x)
	if x == nil or x.CollisionClass == nil then
		return
	end
	x.CollisionClass = EntityGridCollisionClass.GRIDCOLL_NONE
end

function funct.getdisenemies(enemies,pos,rang)
	local ret = nil
	local ran = rang
	if ran == nil then
		ran = 1000
	end
	for _,ent in ipairs(enemies) do
		if ent ~= nil and (ent.Position - pos):Length()< ran then
			ran = (ent.Position - pos):Length()
			ret = ent
		end
	end
	return ret
end

function funct.getrandenemies(enemies)
	if #enemies == 0 then
		return nil
	else
		return enemies[math.random(#enemies)]
	end
end

function funct.getmultishots(player,allowrand)
	local cnt1 = 1
	if player:HasCollectible(153) or player:HasCollectible(2) or player:GetPlayerType() == 14 or player:GetPlayerType() == 33 or player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN) then	--四眼、三眼、店长、里店长的特效：眼泪固定加1发，二者不叠加。有趣的是，对于眼泪而言，三、四眼和多个20/20叠加不完全一致，但科技的激光、妈刀等等却并非如此，说明程序员偷懒了（
		cnt1 = cnt1 + 1
	end
	local list = {	--硫磺火不再叠加，肺特殊处理，水球不叠加
		68,			--科技
		52,			--博士
		114,		--妈刀
		168,		--史诗
		395,		--科X
		579,		--英灵剑
	}
	for i = 1,#list do
		cnt1 = cnt1 + math.max(0,player:GetCollectibleNum(list[i]) - 1)
	end
	local inner_eye_effe = player:GetCollectibleNum(2)
	local mutant_effe = player:GetCollectibleNum(153)
	local perfect_eye_effe = player:GetCollectibleNum(245)
	if player:GetEffects():HasNullEffect(NullItemID.ID_REVERSE_HANGED_MAN) then inner_eye_effe = inner_eye_effe + 1 end
	if inner_eye_effe > 0 or mutant_effe > 0 then perfect_eye_effe = perfect_eye_effe - 1 end
	cnt1 = cnt1 + math.max(0,mutant_effe * 2) + math.max(0,inner_eye_effe) + math.max(0,perfect_eye_effe) + math.max(0,player:GetCollectibleNum(358))	--二、三、四眼与巫师帽
	if player:HasPlayerForm(PlayerForm.PLAYERFORM_BABY) and math.max(0,player:GetCollectibleNum(358)) < 2 then		--宝宝套：直接加2发
		cnt1 = cnt1 + 2
	end
	if allowrand == true then
		if player:HasPlayerForm(PlayerForm.PLAYERFORM_BOOK_WORM) and math.max(0,player:GetCollectibleNum(358)) < 2 then		--书套：随机加1发
			if math.random(4) > 3 then
				cnt1 = cnt1 + 1
			end
		end
	end
	return cnt1
end

function funct.check_rand(luck,maxum,zeroum,threshold)		--幸运；上限（0-100）；下限；幸运阈值
	local rand = math.random(10000)/10000
	if rand * 100 < math.exp(math.min(luck/5,threshold/5))/math.exp(threshold/5) * (maxum - zeroum) + zeroum then
		return true
	else
		return false
	end
end

function funct.check(ent)
	return ent ~= nil and ent:Exists() and (not ent:IsDead())
end

function funct.issolid(grident)
	local list = {
		2,3,4,5,6,11,12,13,14,21,22,24,25,26,27
	}
	for i = 1,#list do
		if grident:GetType() == list[i] then
			return grident.CollisionClass ~= 0
		end
	end
	return false
end

function funct.copy(tbl)
    local ret = {}
    for key, val in pairs(tbl) do
        ret[key] = val
    end
    return ret
end

function funct.reversed_deepCopy(tb,copy)
    if tb == nil then
        return nil
    end
    local copy = copy or {}
    for k, v in pairs(tb) do
        if type(v) == 'table' then
            copy[k] = funct.reversed_deepCopy(v,copy[k])
        else
            copy[k] = v
        end
    end
    setmetatable(copy, funct.reversed_deepCopy(getmetatable(tb,copy)))
    return copy
end

function funct.deepCopy(tb)
    if tb == nil then
        return nil
    end
    local copy = {}
    for k, v in pairs(tb) do
        if type(v) == 'table' then
            copy[k] = funct.deepCopy(v)
        else
            copy[k] = v
        end
    end
    setmetatable(copy, funct.deepCopy(getmetatable(tb)))
    return copy
end

function funct.realdeepCopy(tb)			--我觉得以撒的存储系统有问题。所有的key值都被映射掉了，还得自己重写。
    if tb == nil then
        return nil
    end
    local copy = {}
    for k, v in pairs(tb) do
        if type(v) == 'table' then
			if v.___rid == nil then 
				v.___rid = k
			end
            copy[v.___rid] = funct.realdeepCopy(v)
        else
            copy[k] = v
        end
    end
    setmetatable(copy, funct.realdeepCopy(getmetatable(tb)))
    return copy
end

function funct.realrealdeepCopy(tb)	
	if type(tb) ~= 'table' then return tb end
    local copy = {}
    for k, v in pairs(tb) do
		if type(k) == 'number' or type(v) == 'table' then
		else copy[k] = v end
    end
    for k, v in pairs(tb) do
		if type(k) == 'number' or type(v) == 'table' then
			table.insert(copy,#copy + 1,{_r = k,_v = funct.realrealdeepCopy(v),})
		end
    end
    setmetatable(copy, funct.realrealdeepCopy(getmetatable(tb)))
    return copy
end

function funct.irealrealdeepCopy(tb)
	if type(tb) ~= 'table' then return tb end
    local copy = {}
    for k, v in pairs(tb) do
		if type(v) == 'table' then
			local val = v._r or k
			copy[val] = funct.irealrealdeepCopy(v._v or v)
		else
			copy[k] = v
		end
    end
    setmetatable(copy, funct.irealrealdeepCopy(getmetatable(tb)))
    return copy
end

function funct.PrintTableL( tbl , level, filteDefault)
	if tbl == nil then print(tbl) return end
	if tbl["PRINT_TABLE_LOCK"] then return end
	tbl["PRINT_TABLE_LOCK"] = true
	local msg = ""
	filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
	level = level or 1
	local indent_str = ""
	for i = 1, level do
		indent_str = indent_str.."  "
	end

	print(indent_str .. "{")
	for k,v in pairs(tbl) do
		if k ~ "PRINT_TABLE_LOCK" then
			if filteDefault then
				if k ~= "_class_type" and k ~= "DeleteMe" and type(v) ~= "boolean" then
					local item_str = string.format("%s%s %s= %s", indent_str .. " ",tostring(k), type(k), tostring(v))
					print(item_str)
					if type(v) == "table" then
						funct.PrintTableL(v, level + 1)
					end
				elseif type(v) == "boolean" then
					local item_str = indent_str.." "..tostring(k).." = "
					if v == true then
						item_str = item_str.."True"
					else
						item_str = item_str.."False"
					end
					print(item_str)
				end
			else
				local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
				print(item_str)
				if type(v) == "table" then
					funct.PrintTableL(v, level + 1)
				end
			end
		end
	end
	print(indent_str .. "}")
	
	tbl["PRINT_TABLE_LOCK"] = nil
end

function funct.PrintTable( tbl , level, filteDefault)
	if tbl == nil then print(tbl) return end
	local msg = ""
	filteDefault = filteDefault or true --默认过滤关键字（DeleteMe, _class_type）
	level = level or 1
	local indent_str = ""
	for i = 1, level do
		indent_str = indent_str.."  "
	end

	print(indent_str .. "{")
	for k,v in pairs(tbl) do
		if filteDefault then
			if k ~= "_class_type" and k ~= "DeleteMe" and type(v) ~= "boolean" then
				local item_str = string.format("%s%s %s= %s", indent_str .. " ",tostring(k), type(k), tostring(v))
				print(item_str)
				if type(v) == "table" then
					funct.PrintTable(v, level + 1)
				end
			elseif type(v) == "boolean" then
				local item_str = indent_str.." "..tostring(k).." = "
				if v == true then
					item_str = item_str.."True"
				else
					item_str = item_str.."False"
				end
				print(item_str)
			end
		else
			local item_str = string.format("%s%s = %s", indent_str .. " ",tostring(k), tostring(v))
			print(item_str)
			if type(v) == "table" then
				funct.PrintTable(v, level + 1)
			end
		end
	end
	print(indent_str .. "}")
end

function funct.get_random_pickup()
	local rand = math.random(1000)
	if rand < 400 then
		if rand < 300 then 
			return Vector(20,1)
		elseif rand < 350 then
			return Vector(20,4)
		elseif rand < 370 then
			return Vector(20,2)
		elseif rand < 380 then
			return Vector(20,3)
		elseif rand < 385 then
			return Vector(20,5)
		else 
			return Vector(20,7)
		end
	elseif rand < 600 then
		return Vector(10,0)
	elseif rand < 700 then
		return Vector(30,0)
	elseif rand < 800 then
		if rand < 780 then 
			return Vector(40,1)
		elseif rand < 790 then
			return Vector(40,2)
		elseif rand < 797 then
			return Vector(40,4)
		else 
			return Vector(40,7)
		end
	elseif rand < 830 then
		return Vector(90,0)
	elseif rand < 900 then
		return Vector(80,0)
	elseif rand < 970 then
		return Vector(300,0)
	else
		return Vector(42,0)
	end
end

function funct.getsmallenemies(eny)
	local enemies = {}
    for _, ent in ipairs(eny) do
        if ent:IsBoss() == false  then
            enemies[#enemies + 1] = ent
        end
    end
	return enemies
end

local glazed_players = {
	"Isaac",
	"Maggy",
	"Cain",
	"Judas",
	"BlueBaby",
	"Eve",
	"Samson",
	"Azazel",
	"Lazarus",
	"Eden",
	"Lost",
	--"Lazarus2",	--11
	--"BlackJudas",--12
	"Lilith",
	"Keeper",
	"Apollyon",
	"Forgotten",
	--"The Soul",--17
	"Bethany",
	"Esau",
	"Jacob",
}

function funct.getplayer_glazed(player)
	local raw_pt = player:GetPlayerType()
	if raw_pt >= 0 then
		if raw_pt > 20 and raw_pt < 41 then
			if raw_pt == 38 then raw_pt = 29 end
			if raw_pt == 39 then raw_pt = 37 end
			if raw_pt == 40 then raw_pt = 35 end
			return glazed_players[raw_pt - 20]
		end
		if raw_pt < 21 then
			if raw_pt == 11 then raw_pt = 8 end
			if raw_pt == 12 then raw_pt = 3 end
			if raw_pt == 17 then raw_pt = 15 end
			if raw_pt > 17 then raw_pt = raw_pt - 1 end
			if raw_pt > 12 then raw_pt = raw_pt - 2 end
			return glazed_players[raw_pt + 1]
		end
		return player:GetName()
	else
		return ""
	end
end

function funct.get_player_name(player)
	local raw_pt = player:GetPlayerType()
	if raw_pt >= 0 then
		if raw_pt > 20 and raw_pt < 41 then
			if raw_pt == 38 then raw_pt = 29 end
			if raw_pt == 39 then raw_pt = 37 end
			if raw_pt == 40 then return nil end
			return glazed_players[raw_pt - 20]
		end
		if raw_pt < 21 then
			if raw_pt == 11 then raw_pt = 8 end
			if raw_pt == 12 then raw_pt = 3 end
			if raw_pt == 17 then return nil end
			if raw_pt > 17 then raw_pt = raw_pt - 1 end
			if raw_pt > 12 then raw_pt = raw_pt - 2 end
			return glazed_players[raw_pt + 1]
		end
		return player:GetName()
	else
		return ""
	end
end

function funct.get_players_name()
	local tbl = {}
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		local name = funct.get_player_name(player)
		if name ~= nil then
			table.insert(tbl,#tbl + 1,name)
		end
	end
	if #tbl > 2 then
		local ret = ""
		for i = 1,#tbl - 2 do
			ret = ret .. tbl[i] .. ","
		end
		return ret..tbl[#tbl - 1].." and "..tbl[#tbl]
	else
		if #tbl == 2 then
			return tbl[1].." and "..tbl[2]
		elseif #tbl == 1 then
			return tbl[1]
		end
	end
end

function funct.get_players_counter()
	local tbl = {}
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		local name = funct.get_player_name(player)
		if name ~= nil then
			table.insert(tbl,#tbl + 1,name)
		end
	end
	return #tbl
end

local player_mxdelay_mul = {
	[PlayerType.PLAYER_EVE_B] = 2/3,
}

local weapon_mxdelay_mul = {
	[WeaponType.WEAPON_TEARS] = function (player)
		local ret = 1
		if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_IPECAC) then ret = ret * 1/3 end
		return ret
	 end,
	[WeaponType.WEAPON_BRIMSTONE] = 1/3,
	[WeaponType.WEAPON_LASER] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_IPECAC) or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_IPECAC) then ret = ret * 1/3 end
		return 1
	 end,
	[WeaponType.WEAPON_KNIFE] = 1,
	[WeaponType.WEAPON_BOMBS] = 0.4,
	[WeaponType.WEAPON_ROCKETS] = 1,
	[WeaponType.WEAPON_MONSTROS_LUNGS] = 10/43,
	[WeaponType.WEAPON_LUDOVICO_TECHNIQUE] = 1,
	[WeaponType.WEAPON_TECH_X] = 1,
	[WeaponType.WEAPON_BONE] = 0.5,
	[WeaponType.WEAPON_SPIRIT_SWORD] = 1,
	[WeaponType.WEAPON_FETUS] = 1,
	[WeaponType.WEAPON_UMBILICAL_WHIP] = 1,
 }
 
local item_mxdelay_mul = {
	[CollectibleType.COLLECTIBLE_TECHNOLOGY_2] = 2/3,
	[CollectibleType.COLLECTIBLE_EVES_MASCARA] = 2/3,
	[CollectibleType.COLLECTIBLE_MUTANT_SPIDER] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_20_20) then return 1 end
		return 0.42
	 end,
	[CollectibleType.COLLECTIBLE_INNER_EYE] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_20_20) then return 1 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then return 1 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_POLYPHEMUS) then return 1 end
		return 0.51
	 end,
	[CollectibleType.COLLECTIBLE_POLYPHEMUS] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_20_20) then return 1 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then return 1 end
		return 0.42
	 end,
	[CollectibleType.COLLECTIBLE_SOY_MILK] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_ALMOND_MILK) then return 1 end
		return 5.5
	 end,
	[CollectibleType.COLLECTIBLE_ALMOND_MILK] = 4,
	[CollectibleType.COLLECTIBLE_EYE_DROPS] = 1.2,
}

local null_item_mxdelay_mul = {
	[NullItemID.ID_REVERSE_CHARIOT] = 4,
	[NullItemID.ID_REVERSE_HANGED_MAN] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE) then return 1 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_20_20) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_20_20) then return 1 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER) then return 1 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_POLYPHEMUS) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_POLYPHEMUS) then return 1 end
		return 0.51
	 end,
}

function funct.get_mxdelay_multiplier(player)
	local total_multiplier = player_mxdelay_mul[player:GetPlayerType()] or 1
	if type(total_multiplier) == "function" then total_multiplier = total_multiplier(player) end
	local weap = 1
	for i = 1,16 do if player:HasWeaponType(i) == true then	weap = i end end
	local multiplier1 = item_mxdelay_mul[weap] or 1
	if type(multiplier1) == "function" then multiplier1 = multiplier1(player) end
	total_multiplier = total_multiplier * multiplier1
	local effects = player:GetEffects()
	for collectible, multiplier in pairs(item_mxdelay_mul) do
		if player:HasCollectible(collectible) or effects:HasCollectibleEffect(collectible) then
			if type(multiplier) == "function" then multiplier = multiplier(player) end
			total_multiplier = total_multiplier * multiplier
		end
	end
	for collectible, multiplier in pairs(null_item_mxdelay_mul) do
		if effects:HasNullEffect(collectible) then
			if type(multiplier) == "function" then multiplier = multiplier(player) end
			total_multiplier = total_multiplier * multiplier
		end
	end
	--血泪需要最后计算
	if player:HasCollectible(CollectibleType.COLLECTIBLE_HAEMOLACRIA) or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_HAEMOLACRIA) then
		if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_BRIMSTONE) then
			total_multiplier = 1/(total_multiplier + 2)
		else
			total_multiplier = 1/(total_multiplier * 2/3 + 2)
		end
	end
	return total_multiplier
end

local player_dmg_mul = {
	[PlayerType.PLAYER_ISAAC] = 1,
	[PlayerType.PLAYER_MAGDALENA] = 1,
	[PlayerType.PLAYER_CAIN] = 1,
	[PlayerType.PLAYER_JUDAS] = 1,
	[PlayerType.PLAYER_XXX] = 1.05,
	[PlayerType.PLAYER_EVE] = function (player)
	if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_WHORE_OF_BABYLON) then return 1 end
	return 0.75
	end,
	[PlayerType.PLAYER_SAMSON] = 1,
	[PlayerType.PLAYER_AZAZEL] = 1.5,
	[PlayerType.PLAYER_LAZARUS] = 1,
	[PlayerType.PLAYER_THELOST] = 1,
	[PlayerType.PLAYER_LAZARUS2] = 1.4,
	[PlayerType.PLAYER_BLACKJUDAS] = 2,
	[PlayerType.PLAYER_LILITH] = 1,
	[PlayerType.PLAYER_KEEPER] = 1.2,
	[PlayerType.PLAYER_APOLLYON] = 1,
	[PlayerType.PLAYER_THEFORGOTTEN] = 1.5,
	[PlayerType.PLAYER_THESOUL] = 1,
	[PlayerType.PLAYER_BETHANY] = 1,
	[PlayerType.PLAYER_JACOB] = 1,
	[PlayerType.PLAYER_ESAU] = 1,
	-- Tainted characters
	[PlayerType.PLAYER_ISAAC_B] = 1,
	[PlayerType.PLAYER_MAGDALENA_B] = 0.75,
	[PlayerType.PLAYER_CAIN_B] = 1,
	[PlayerType.PLAYER_JUDAS_B] = 1,
	[PlayerType.PLAYER_XXX_B] = 1,
	[PlayerType.PLAYER_EVE_B] = 1.2,
	[PlayerType.PLAYER_SAMSON_B] = 1,
	[PlayerType.PLAYER_AZAZEL_B] = 1.5,
	[PlayerType.PLAYER_LAZARUS_B] = 1,
	[PlayerType.PLAYER_EDEN_B] = 1,
	[PlayerType.PLAYER_THELOST_B] = 1.3,
	[PlayerType.PLAYER_LILITH_B] = 1,
	[PlayerType.PLAYER_KEEPER_B] = 1,
	[PlayerType.PLAYER_APOLLYON_B] = 1,
	[PlayerType.PLAYER_THEFORGOTTEN_B] = 1.5,
	[PlayerType.PLAYER_BETHANY_B] = 0.75,
	[PlayerType.PLAYER_JACOB_B] = 1,
	[PlayerType.PLAYER_LAZARUS2_B] = 1.5,
 }

local item_dmg_mul = {
	[CollectibleType.COLLECTIBLE_MAXS_HEAD] = 1.5,
	[CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MAXS_HEAD) then return 1 end
		return 1.5
	end,
	[CollectibleType.COLLECTIBLE_BLOOD_MARTYR] = function (player)
		if not player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL) then return 1 end
		if player:HasCollectible(CollectibleType.COLLECTIBLE_MAXS_HEAD) or player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM) then return 1 end
		return 1.5
	end,
	[CollectibleType.COLLECTIBLE_POLYPHEMUS] = 2,
	[CollectibleType.COLLECTIBLE_SACRED_HEART] = 2.3,
	[CollectibleType.COLLECTIBLE_EVES_MASCARA] = 2,
	[CollectibleType.COLLECTIBLE_ODD_MUSHROOM_RATE] = 0.9,
	[CollectibleType.COLLECTIBLE_20_20] = 0.75,
	[CollectibleType.COLLECTIBLE_EVES_MASCARA] = 2,
	[CollectibleType.COLLECTIBLE_SOY_MILK] = function (player)
		if player:HasCollectible(CollectibleType.COLLECTIBLE_ALMOND_MILK) then return 1 end
		return 0.2
	end,
	[CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT] = function (player)
		if player:GetEffects():HasCollectibleEffect(CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT) then return 2 end
		return 1
	end,
	[CollectibleType.COLLECTIBLE_ALMOND_MILK] = 0.33,
	[CollectibleType.COLLECTIBLE_IMMACULATE_HEART] = 1.2,
}
--需要计算魅魔的攻击倍率

function funct.get_damage_multiplier(player)
	local total_multiplier = player_dmg_mul[player:GetPlayerType()] or 1
	if type(total_multiplier) == "function" then total_multiplier = total_multiplier(player) end
	
	local effects = player:GetEffects()

	for collectible, multiplier in pairs(item_dmg_mul) do
		if player:HasCollectible(collectible) or effects:HasCollectibleEffect(collectible) then
			if type(multiplier) == "function" then multiplier = multiplier(player) end
			total_multiplier = total_multiplier * multiplier
		end
	end

	return total_multiplier
end

local soul_player = {
  [PlayerType.PLAYER_ISAAC] = false,
  [PlayerType.PLAYER_MAGDALENA] = false,
  [PlayerType.PLAYER_CAIN] = false,
  [PlayerType.PLAYER_JUDAS] = false,
  [PlayerType.PLAYER_XXX] = true,
  [PlayerType.PLAYER_EVE] = false,
  [PlayerType.PLAYER_SAMSON] = false,
  [PlayerType.PLAYER_AZAZEL] = false,
  [PlayerType.PLAYER_LAZARUS] = false,
  [PlayerType.PLAYER_THELOST] = true,
  [PlayerType.PLAYER_LAZARUS2] = false,
  [PlayerType.PLAYER_BLACKJUDAS] = true,
  [PlayerType.PLAYER_LILITH] = false,
  [PlayerType.PLAYER_KEEPER] = false,
  [PlayerType.PLAYER_APOLLYON] = false,
  [PlayerType.PLAYER_THEFORGOTTEN] = false,
  [PlayerType.PLAYER_THESOUL] = true,
  [PlayerType.PLAYER_BETHANY] = false,
  [PlayerType.PLAYER_JACOB] = false,
  [PlayerType.PLAYER_ESAU] = false,

  -- Tainted characters
  [PlayerType.PLAYER_ISAAC_B] = false,
  [PlayerType.PLAYER_MAGDALENA_B] = false,
  [PlayerType.PLAYER_CAIN_B] = false,
  [PlayerType.PLAYER_JUDAS_B] = false,
  [PlayerType.PLAYER_XXX_B] = true,
  [PlayerType.PLAYER_EVE_B] = false,
  [PlayerType.PLAYER_SAMSON_B] = false,
  [PlayerType.PLAYER_AZAZEL_B] = false,
  [PlayerType.PLAYER_LAZARUS_B] = false,
  [PlayerType.PLAYER_EDEN_B] = false,
  [PlayerType.PLAYER_THELOST_B] = true,
  [PlayerType.PLAYER_LILITH_B] = false,
  [PlayerType.PLAYER_KEEPER_B] = false,
  [PlayerType.PLAYER_APOLLYON_B] = false,
  [PlayerType.PLAYER_THEFORGOTTEN_B] = true,
  [PlayerType.PLAYER_BETHANY_B] = true,
  [PlayerType.PLAYER_JACOB_B] = false,
  [PlayerType.PLAYER_LAZARUS2_B] = false,
 }

function funct.is_soul_player(player)
	local tp = player:GetPlayerType()
	if soul_player[tp] ~= nil then
		return soul_player[tp]
	else
		return false
	end
end

function funct.move_in_sq(pos,col,raw)
	local i = pos//col
	local j = pos - i*col
	local ret = {}
	if i > 0 then
		table.insert(ret,#ret+1,{id = (i-1)*col+j,dir = 3,})
	end
	if j > 0 then
		table.insert(ret,#ret+1,{id = i*col+j-1,dir = 2,})
	end
	if i < col - 1 then
		table.insert(ret,#ret+1,{id = (i+1)*col+j,dir = 1,})
	end
	if j < raw - 1 then
		table.insert(ret,#ret+1,{id = i*col+j+1,dir = 0,})
	end
	return ret
end

function funct.move_in_rou(pos,col,raw)
	local i = pos//col
	local j = pos - i*col
	local ret = {}
	if i > 0 then
		table.insert(ret,#ret+1,(i-1)*col+j)
		if j > 0 then
			table.insert(ret,#ret+1,(i-1)*col+j-1)
		end
		if j < raw - 1 then
			table.insert(ret,#ret+1,(i-1)*col+j+1)
		end
	end
	if j > 0 then
		table.insert(ret,#ret+1,i*col+j-1)
	end
	if j < raw - 1 then
		table.insert(ret,#ret+1,i*col+j+1)
	end
	if i < col - 1 then
		table.insert(ret,#ret+1,(i+1)*col+j)
		if j > 0 then
			table.insert(ret,#ret+1,(i+1)*col+j-1)
		end
		if j < raw - 1 then
			table.insert(ret,#ret+1,(i+1)*col+j+1)
		end
	end
	return ret
end

function funct.GetfamiliarDir(ent, dir, allow_king)
	if (allow_king == nil) then
        allow_king = true
    end 

    local player = ent.Player
    if (allow_king) then
        if (player:HasCollectible(CollectibleType.COLLECTIBLE_KING_BABY) or player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_KING_BABY) > 0) then
            local n_entity = Isaac.GetRoomEntities()
			local n_enemy = funct.getenemies(n_entity)
            if (#n_enemy > 0) then
                local dr = (n_enemy[1].Position - ent.Position):Normalized()
				local dis = (n_enemy[1].Position - ent.Position):Length()
				for i = 2,#n_enemy do
					if (n_enemy[i].Position - ent.Position):Length() < dis then
						dis = (n_enemy[i].Position - ent.Position):Length()
						dr = (n_enemy[i].Position - ent.Position):Normalized()
					end
				end
				ent:GetData().should_attack = true
                return dr
            end
			ent:GetData().should_attack = false
        end
    end
    if (dir ~= Direction.NO_DIRECTION) then
		if (dir == Direction.LEFT) then
			return Vector(-1,0)
		elseif (dir == Direction.UP) then
			return Vector(0,-1)
		elseif (dir == Direction.RIGHT) then
			return Vector(1,0)
		elseif (dir == Direction.DOWN) then
			return Vector(0,1)
		end
    end
    return Vector(0,0)
	
end

local dir_name = {
	[Direction.NO_DIRECTION] = "Down",
	[Direction.LEFT] = "Side",
	[Direction.UP] = "Up",
	[Direction.RIGHT] = "Side",
	[Direction.DOWN] = "Down"
}

function funct.GetDirName(dir)
	return dir_name[dir]
end

function funct.GetDirectionByAngle(angle)
    angle = angle % 360
    local dir = Direction.NO_DIRECTION
    if (math.abs(angle - 0) < 45 or math.abs(angle - 360) < 45) then
        dir = Direction.RIGHT
    elseif (math.abs(angle - 270) < 45) then
        dir = Direction.UP
    elseif (math.abs(angle - 180) < 45) then
        dir = Direction.LEFT
    elseif (math.abs(angle - 90) < 45) then
        dir = Direction.DOWN
    end
    return dir
end

local RoomType_to_IconIDs = {
	nil,
    "Shop",
    nil,
    "TreasureRoom",
    "Boss",
    "Miniboss",
    "SecretRoom",
    "SuperSecretRoom",
    "Arcade",
    "CurseRoom",
    "AmbushRoom",
    "Library",
    "SacrificeRoom",
    nil,
    "AngelRoom",
    nil,
    "BossAmbushRoom",
    "IsaacsRoom",
    "BarrenRoom",
    "ChestRoom",
    "DiceRoom",
    nil, -- black market
    nil,-- "GreedExit",
	"Planetarium",
	nil, -- Teleporter
	nil, -- Teleporter_Exit
	nil, -- doesnt exist
	nil, -- doesnt exist
	"UltraSecretRoom"
}

function funct.GetNameByRoomType(name)
	return RoomType_to_IconIDs[name]
end

function funct.IsAmbushBoss()		--其实忽略了紫色勋章饰品。不过应该没太大问题。
	local ls = Game():GetLevel():GetStage()
	if ls == LevelStage.STAGE1_2 then
		return true
	elseif ls == LevelStage.STAGE2_2 then
		return true
	elseif ls == LevelStage.STAGE3_2 then
		return true
	elseif ls == LevelStage.STAGE4_2 then
		return true
	else
		return false
	end
end

function funct.is_movable_enemy(ent,not_allow_boss)			--不可移动30、60、53、221、231、300、305、306、809、307、856、861、298		--特殊39.22、35.0、35.2、816、213、219、228、285、287		--水生311、825	--钻地244、58、59、56、255、276、829、881	--爬墙240	--会跳34、38、86、54、869、29、85、94、215、250	--值得实验882	--85号蜘蛛禁了
	if (ent.Type == 30) or (ent.Type == 85) or (ent.Type == 60) or (ent.Type == 39 and ent.Variant == 22) or (ent.Type == 35 and (ent.Variant == 0 or ent.Variant == 2)) or (ent.Type == 53) or (ent.Type == 231) or (ent.Type == 306) or (ent.Type == 298) or (ent.Type == 244) or (ent.Type == 816) or (ent.Type == 58) or (ent.Type == 59) or (ent.Type == 56) or (ent.Type == 213) or (ent.Type == 219) or (ent.Type == 240) or (ent.Type == 221) or (ent.Type == 228) or (ent.Type == 255) or (ent.Type == 276) or (ent.Type == 285) or (ent.Type == 287) or (ent.Type == 300) or (ent.Type == 805) or (ent.Type == 309) or (ent.Type == 307) or (ent.Type == 311) or (ent.Type == 825) or (ent.Type == 856) or (ent.Type == 861) or (ent.Type == 829) or (ent.Type == 881) or (ent.Type == 996) then
		return false
	end
	if not_allow_boss and not_allow_boss == true then		--不可移动36、45、78、84、101、262、266、263、270、274、275、273、906、911、914 --特殊407、412、403、411、406、903、912、951		--爬墙900 	--钻地62、269、401	 --会跳20、43、68、65、69、100、74-76、102、264、265、267、268、404、406
		if (ent.Type == 45) or (ent.Type == 62) or (ent.Type == 407) or (ent.Type == 406) or (ent.Type == 411) or (ent.Type == 403) or (ent.Type == 900) or (ent.Type == 412) or (ent.Type == 903) or (ent.Type == 906) or (ent.Type == 911) or (ent.Type == 912) or (ent.Type == 914) or (ent.Type == 951) or (ent.Type == 950) or (ent.Type == 78) or (ent.Type == 84) or (ent.Type == 101) or (ent.Type == 262) or (ent.Type == 269) or (ent.Type == 401) or (ent.Type == 273) or (ent.Type == 275) or (ent.Type == 274) or (ent.Type == 270) or (ent.Type == 263) or (ent.Type == 266) then
			return false
		end
	end
	return true
end

local ignoreFlags = DamageFlag.DAMAGE_DEVIL | DamageFlag.DAMAGE_IV_BAG | DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_CURSED_DOOR | DamageFlag.DAMAGE_NO_PENALTIES

function funct.is_damage_from_enemy(ent, amt, flag, source, cooldown)
	if amt > 0 and ((source and source.Type ~= EntityType.ENTITY_SLOT and source.Type ~= EntityType.ENTITY_PLAYER) or not source) and (flag & ignoreFlags) == 0	then
		return true
	else
		return false
	end
end

local FullRedHeartPlayers = {
    [PlayerType.PLAYER_KEEPER] = true,
    [PlayerType.PLAYER_BETHANY] = true,
    [PlayerType.PLAYER_KEEPER_B] = true,
}

local FullBoneHeartPlayers = {
    [PlayerType.PLAYER_THEFORGOTTEN] = true
}

local FullSoulHeartPlayers = {
    [PlayerType.PLAYER_BETHANY_B] = true,
    [PlayerType.PLAYER_BLACKJUDAS] = true,		--其实黑犹大应该算黑心
    [PlayerType.PLAYER_BLUEBABY] = true,
    [PlayerType.PLAYER_BLUEBABY_B] = true,
    [PlayerType.PLAYER_THEFORGOTTEN_B] = true,
}

function funct.is_player_only_bone_hearts(player)
	return FullBoneHeartPlayers[player:GetPlayerType()] ~= nil
end

function funct.is_player_only_red_hearts(player)
	return FullRedHeartPlayers[player:GetPlayerType()] ~= nil
end

function funct.is_player_only_soul_hearts(player)
	if FullSoulHeartPlayers[player:GetPlayerType()] ~= nil then
		return true 
	end
	return false
end

function funct.add_soul_heart(player,num)
	if (player:HasCollectible(CollectibleType.COLLECTIBLE_ALABASTER_BOX, true)) then		--草，这种可能性都考虑到了
        local alabasterCharges = {}
        for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET do   
            if (player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_ALABASTER_BOX) then
                alabasterCharges[slot] = player:GetActiveCharge (slot) + player:GetBatteryCharge (slot)
                if (num > 0) then
                    player:SetActiveCharge(12, slot)
                else
                    player:SetActiveCharge(0, slot)
                end
            end
        end
        player:AddSoulHearts(num)
        for slot = ActiveSlot.SLOT_PRIMARY, ActiveSlot.SLOT_POCKET do   
            if (player:GetActiveItem(slot) == CollectibleType.COLLECTIBLE_ALABASTER_BOX) then
                player:SetActiveCharge(alabasterCharges[slot], slot)
            end
        end
    else
        player:AddSoulHearts(num)
    end
end

local LostPlayers = {
    [PlayerType.PLAYER_THESOUL] = true,
    [PlayerType.PLAYER_THELOST] = true,
    [PlayerType.PLAYER_THELOST_B] = true,
    [PlayerType.PLAYER_THESOUL_B] = true,
}

function funct.get_death_animation_to_play(player)
	local tp = player:GetPlayerType()
	if LostPlayers[tp] ~= nil then
		return "LostDeath"
	end
    if (player:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE)) then
        return "LostDeath";
    end
	return "Death"
end

function funct.have_player(pt)
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		if player:GetPlayerType() == pt then
			return true
		end
	end
	return false
end

local DifficultPlayers = {
    [PlayerType.PLAYER_KEEPER] = true,
    [PlayerType.PLAYER_KEEPER_B] = true,
    [PlayerType.PLAYER_THELOST] = true,
    [PlayerType.PLAYER_THELOST_B] = true,
}

function funct.is_player_difficult(player)
	return DifficultPlayers[player:GetPlayerType()] ~= nil
end

function funct.to_find_spawner(ent)
	local ret = ent
	if ent:GetData() and ent:GetData().to_find_spawner_marked == nil then
		ent:GetData().to_find_spawner_marked = true				--防止无限loop
		if ent:GetData().to_find_spawner_minder then
			ret = ent:GetData().to_find_spawner_minder
		else
			if ent.SpawnerEntity then
				ret = funct.to_find_spawner(ent.SpawnerEntity)
			end
		end
		ent:GetData().to_find_spawner_minder = ret
		ent:GetData().to_find_spawner_marked = nil
	end
	return ret
end

function funct.is_poop_player(player)
	return player:GetPlayerType() == 25
end

function funct.has_poop_player()
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		if funct.is_poop_player(player) then
			return true
		end
	end
	return false
end

function funct.has_difficult_player()
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		if funct.is_player_difficult(player) then
			return true
		end
	end
	return false
end

function funct.randomTable(_table, rng) 
	if rng then rng = funct.rng_for_sake(rng) end
	if type(_table)~= "table" then
        return {}
    end
	local tab = {}
    for i = 1,#_table do
		local id
		if rng then 
			id = (rng:RandomInt(#_table) + 1)
		else 
			id = math.random(#_table) 
		end
		tab[i] = _table[id]
		table.remove(_table,id)
	end
	return tab
end

function funct.is_double_player()		--似乎只有双子才会导致特殊的ui。
	local check_1 = false
	local check_2 = false
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		local pt = player:GetPlayerType()
		if pt == PlayerType.PLAYER_JACOB then
			check_1 = true
		elseif pt == PlayerType.PLAYER_ESAU then
			check_2 = true
		end
	end
	return (check_1 and check_2)
end

 local roomTemplate = {
	"AwardSeed",
	"ChallengeDone",
	"Clear",
	"ClearCount",
	"Data",
	"DecorationSeed",
	"DeliriumDistance",
	"DisplayFlags",
	--"GridIndex",
	"HasWater",
	"ListIndex",
	"NoReward",
	"OverrideData",
	"PitsCount",
	"PoopCount",
	"PressurePlatesTriggered",
	"SacrificeDone",
	"ShopItemDiscountIdx",
	"ShopItemIdx",
	"SpawnSeed",
	"SurpriseMiniboss",
}
 
function funct.MakeFakeRoom(id1,id2)
    local level = Game():GetLevel()
	id1 = id1 or level:GetCurrentRoomIndex()
    id2 = id2 or 84 -- level:GetCurrentRoomIndex()
	print(id1.." " ..id2)
    local roomdesc = level:GetRoomByIdx(id1, 0)
    local target = level:GetRoomByIdx(id2, 0)
	
	if roomdesc and target then
		for i, v in pairs(roomTemplate) do
			target[v] = roomdesc[v]
		end
	end
end

function funct.get_multi_word(wd,mul)
	local ret = ""
	mul = mul or math.random(10)
	for i = 1,mul do
		ret = ret .. wd
	end
	return ret
end

function funct.get_string_display_length(str)
	local ret = 0
	local i = 1
	while(i <= #str) do
		local c = string.sub(str,i,i)
		local b = string.byte(c)
		if b > 128 then
			c = string.sub(str,i,i+2)
			i = i + 3
			ret = ret + 4.5
		else
			i = i + 1
			ret = ret + 1.8
		end
	end
	return ret
end

function funct.get_linked(ent)
	local ret = {}
	local npos = ent
	while(npos.ParentNPC and npos.ParentNPC:GetData().is_checked_by_linked == nil) do
		npos = npos.ParentNPC
		npos:GetData().is_checked_by_linked = true
		table.insert(ret,npos)
	end
	while(npos.ChildNPC and npos.ParentNPC:GetData().is_checked_by_linked == nil) do
		npos = npos.ChildNPC
		npos:GetData().is_checked_by_linked = true
		table.insert(ret,npos)
	end
	for u,v in pairs(ret) do
		v:GetData().is_checked_by_linked = nil
	end
	ent:GetData().is_checked_by_linked = nil
	return ret
end

function funct.get_random_item_that_player_has(player,rng,ignore_quest)
	ignore_quest = ignore_quest or false
	if rng then rng = funct.rng_for_sake(rng) end
	local pool = {}
	local wei = 0
	local itemConfig = Isaac.GetItemConfig()
	local sz = itemConfig:GetCollectibles().Size
	if player then
		for id = 1,sz do
			local collectible = itemConfig:GetCollectible(id)
			if (collectible and player:HasCollectible(id)) and (ignore_quest or collectible.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST) then
				if player:GetCollectibleNum(id,true) > 0 then
					table.insert(pool,{id = id,weigh = player:GetCollectibleNum(id,true)})
					wei = wei + player:GetCollectibleNum(id,true)
				end
			end
		end
	else
		for playerNum = 1, Game():GetNumPlayers() do
			local player = Game():GetPlayer(playerNum - 1)
			for id = 1,sz do
				local collectible = itemConfig:GetCollectible(id)
				if (collectible and player:HasCollectible(id)) and (ignore_quest or collectible.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST) then
					if player:GetCollectibleNum(id,true) > 0 then
						table.insert(pool,{id = id,weigh = player:GetCollectibleNum(id,true)})
						wei = wei + player:GetCollectibleNum(id,true)
					end
				end
			end
		end
	end
	local target = -1
	if #pool > 0 then
		wei = rng:RandomInt(wei) + 1
		for i = 1,#pool do
			wei = wei - pool[i].weigh
			if wei <= 0 then
				target = pool[i].id
				break
			end
		end
	end
	return target
end

function funct.spawn_item_dust(player,pos,colid,color1,color2,ignore_question_mark)
	ignore_question_mark = ignore_question_mark or false
	player = player or Game():GetPlayer(0)
	pos = pos or player.Position
	colid = colid or 33
	color1 = color1 or Color(1,1,1,1)
	color2 = color2 or Color(0.2,0.2,0.2,0.3,-0.8,-0.8,-0.8)
	local coll = Isaac.GetItemConfig():GetCollectible(colid)
	if coll then
		local q = Isaac.Spawn(1000,EffectVariant.CRACK_THE_SKY,0,pos,Vector(0,0),player)
		local q2 = Isaac.Spawn(1000,11,0,pos,Vector(0,0),player)
		local s = q:GetSprite()
		s.Color = color1
		local s2 = q2:GetSprite()
		s2:Load("gfx/dropping_collectible.anm2",true)
		s2:Play("Idle",true)
		if Game():GetLevel():GetCurses() & LevelCurse.CURSE_OF_BLIND == LevelCurse.CURSE_OF_BLIND and not ignore_question_mark then
			s2:ReplaceSpritesheet(0,"gfx/items/collectibles/questionmark.png")
		else
			s2:ReplaceSpritesheet(0,coll.GfxFileName)
		end
		s2:LoadGraphics()
		q2:AddEntityFlags(EntityFlag.FLAG_RENDER_FLOOR)
		s2.Color = color2
		return q
	end
end

local is_pickup_list = {
	[10] = true,
	[20] = true,
	[30] = true,
	[40] = function(ent) if ent.SubType ~= 3 and ent.SubType ~= 4 then return true else return false end end,
	[42] = true,
	[50] = true,
	[51] = true,
	[52] = true,
	[53] = true,
	[54] = true,
	[55] = true,
	[56] = true,
	[57] = true,
	[60] = true,
	[69] = true,
	[70] = true,
	[90] = true,
	[300] = true,
	[350] = true,
	[360] = true,
}

function funct.is_pickup(ent)
	local info = is_pickup_list[ent.Variant]
	if type(info) == "function" then return info(ent) end
	return info or false
end

local fly_list = {
	[13] = true,
	[14] = true,
	[18] = true,
	[25] = true,
	[61] = true,
	[80] = true,
	[214] = true,
	[249] = true,
	[222] = true,
	[256] = true,
	[281] = true,
	[296] = true,
	[808] = true,
	[819] = true,
	[838] = true,
	[868] = true,
	[951] = function(ent) if ent.Variant == 11 or ent.Variant == 21 then return true else return false end end,
}

function funct.is_fly(ent)
	local info = fly_list[ent.Type]
	if type(info) == "function" then return info(ent) end
	return info or false
end

local spider_list = {
	[29] = true,
	[246] = true,
	[303] = true,
	[85] = true,
	[94] = true,
	[814] = true,
	[818] = true,
	[884] = true,
	[206] = true,
	[207] = true,
	[215] = true,
	[240] = true,
	[241] = true,
	[242] = true,
	[304] = true,
	[250] = true,
	[869] = true,
}

function funct.is_spider(ent)
	local info = spider_list[ent.Type]
	if type(info) == "function" then return info(ent) end
	return info or false
end

function funct.check_for_the_same(v1,v2)
	local ret = false
	if v1 and v2 then
		local d1 = v1:GetData()
		local d2 = v2:GetData()
		if d1 and d2 then
			d1.check_for_the_same = true
			if d2.check_for_the_same then ret = true end
			d1.check_for_the_same = nil
		end
	end
	return ret
end

function funct.random_in_table(tbl,rng)
	if type(tbl) ~= "table" then return tbl end
	if #tbl == 0 then return nil end
	if rng then
		local rnd = rng:RandomInt(#tbl) + 1
		return tbl[rnd]
	else
		local rnd = math.random(#tbl)
		return tbl[rnd]
	end
end

function funct.random_in_weighed_table(tbl,rng)
	local total_weigh = 0
	for u,v in pairs(tbl) do
		if u ~= "___rid" then
			if type(v) == "table" then total_weigh = total_weigh + (funct.check_if_any(v.weigh,v) or 1)
			else total_weigh = total_weigh + 1 end
		end
	end
	total_weigh = math.floor(total_weigh)
	if rng then total_weigh = rng:RandomInt(total_weigh) + 1
	else total_weigh = math.random(total_weigh) end
	for u,v in pairs(tbl) do
		if u ~= "___rid" then
			local dec = 1
			if type(v) == "table" then dec = funct.check_if_any(v.weigh,v) or dec end
			total_weigh = total_weigh - dec
			if total_weigh <= 0 then return v end
		end
	end
	return nil
end

function funct.choose(...)
	local options = {...}
	return options[math.random(#options)]
end

local choose = funct.choose
local function choose2(options)
	return options[math.random(#options)]
end
funct.choose2 = choose2

function funct.Random(n)
	return math.random(n + 1) - 1
end


local level_map_mix = {
	[1] = 1,
	[2] = 1,
	[3] = 2,
	[4] = 2,
	[5] = 3,
	[6] = 3,
	[7] = 4,
	[8] = 4,
	[9] = 6,
	[10] = 5,
	[11] = 5,
	[12] = 6,
	[13] = 6,
}

local greed_level_map_mix = {
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 6,
}

function funct.get_level_info_mix()
	if Game():IsGreedMode() then
		return greed_level_map_mix[Game():GetLevel():GetStage()] or 1
	else
		return level_map_mix[Game():GetLevel():GetStage()] or 1
	end
	return 1
end

local level_stage_map = {
	[1] = 1,
	[2] = 1,
	[3] = 2,
	[4] = 2,
	[5] = 3,
	[6] = 3,
	[7] = 4,
	[8] = 4,
	[9] = 5,
	[10] = 6,
	[11] = 7,
	[12] = 8,
	[13] = 9,
}

local greed_level_stage_map = {
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 6,
	[6] = 10,
	[7] = 10,
}

function funct.get_level_door_info()
	if Game():IsGreedMode() then
		return greed_level_stage_map[Game():GetLevel():GetStage()]
	else
		--if Game():GetLevel():IsAscent() then return 9 end
		return level_stage_map[Game():GetLevel():GetStage()]
	end
end

local otherroom_info = {
	[RoomShape.ROOMSHAPE_IH] = function()
		local stg = funct.get_level_door_info()
		local tbl = {"1077","5026","5145"}
		if stg >= 2 then 
			table.insert(tbl,"3267") 
			table.insert(tbl,"4023") 
			table.insert(tbl,"5053") 
		end
		if stg >= 3 then 
			table.insert(tbl,"2036") 
			table.insert(tbl,"4036") 
		end
		return choose2(tbl)
	end,
	[RoomShape.ROOMSHAPE_IV] = function()
		local stg = funct.get_level_door_info()
		local tbl = {"1078","3379","4011",}
		if stg >= 2 then 
			table.insert(tbl,"2065") 
			table.insert(tbl,"3268") 
			table.insert(tbl,"5035") 
			table.insert(tbl,"5105") 
		end
		if stg >= 3 then 
			table.insert(tbl,"2035") 
			table.insert(tbl,"4043") 
			table.insert(tbl,"5043") 
		end
		return choose2(tbl)
	end,
	[RoomShape.ROOMSHAPE_2x2] = function() 
		local stg = funct.get_level_door_info() 
		local tbl = {}
		if stg >= 4 then table.insert(tbl,{name = {stg = 9,stgtp = 0,cmd = "goto x.boss.0",},weigh = 2,}) end 
		if stg >= 5 then table.insert(tbl,{name = "3414",weigh = 2,}) end 
		if #tbl > 0 then return funct.random_in_weighed_table(tbl).name end
	end,
	[RoomShape.ROOMSHAPE_1x2] = function()
		--if true then return {stg = 8,stgtp = 4,makedoor = true,} end
		local stg = funct.get_level_door_info()
		local tbl = {}
		if stg <= 3 then table.insert(tbl,{name = choose(tostring(3700 + choose(2,3,4,5,6,7,10,11,12,13,14,16,17,18,19,20,21,22,23))),weigh = 19,}) 
		else table.insert(tbl,{name = choose(tostring(3700 + choose(2,3,4,5,6,7,10,11,12,13,14,16,17,18,19,20,21,22,23))),weigh = 5,}) end
		if stg >= 2 then 
			if stg <= 4 then table.insert(tbl,{name = choose(tostring(3700 + choose(55,56,57,58,59,72,73,74,75,76,77,78))),weigh = 24,})  
			else table.insert(tbl,{name = choose(tostring(3700 + choose(55,56,57,58,59,72,73,74,75,76,77,78))),weigh = 10,}) end
			table.insert(tbl,{name = choose(tostring(5200 + choose(0,1,2,3))),weigh = 8,})  
			table.insert(tbl,{name = choose(tostring(5310 + choose(0,1,2))),weigh = 8,})  
			table.insert(tbl,{name = choose(tostring(5227)),weigh = 2,}) 
			table.insert(tbl,{name = choose(tostring(5210 + choose(0,1,2,3,4))),weigh = 10,})  
		end
		if stg >= 3 then 
			table.insert(tbl,{name = choose(tostring(3800 + choose(1,2,4,6,7,9,10,11,12,13,14,15,16,17,18,19))),weigh = 16,})  
		end
		if stg >= 4 then 
			table.insert(tbl,{name = "5113",weigh = 4,}) 
		end
		if stg >= 5 then
			--table.insert(tbl,{name = {stg = 13,stgtp = 1,cmd = "goto x.itemdungeon.666",should_reset = true,makedoor = true,},weigh = 100,}) 
			--table.insert(tbl,{name = {stg = 13,stgtp = 1,cmd = "goto x.default.4",should_reset = true,makedoor = true,},weigh = 100,}) 
			--table.insert(tbl,{name = {stg = 8,stgtp = 4,should_reset = true,makedoor = true,},weigh = 5,}) 
			--table.insert(tbl,{name = {name = "5000",should_reset = true,makedoor = true,},weigh = 10,}) 
		end
		return funct.random_in_weighed_table(tbl).name
	end,
	[RoomShape.ROOMSHAPE_2x1] = function()
		local stg = funct.get_level_door_info()
		local tbl = {}
		table.insert(tbl,{name = choose(tostring(3700 + choose(0,1,8,9,15))),weigh = 5,})  
		if stg >= 2 then 
			if stg <= 4 then table.insert(tbl,{name = choose(tostring(3700 + choose(51,52,53,54,60,61,62,63,64,65,66,67,68,69,70,71))),weigh = 24,}) 
			else table.insert(tbl,{name = choose(tostring(3700 + choose(51,52,53,54,60,61,62,63,64,65,66,67,68,69,70,71))),weigh = 10,})  end
			table.insert(tbl,{name = choose(tostring(5200 + choose(4,5,6,7))),weigh = 6,})  
			table.insert(tbl,{name = choose(tostring(5313)),weigh = 2,}) 
		end
		if stg >= 3 then 
			table.insert(tbl,{name = choose(tostring(3800 + choose(0,5))),weigh = 3,})  
		end
		if stg >= 4 then 
			table.insert(tbl,{name = choose(tostring(5110 + choose(0,1))),weigh = 4,})  
		end
		return funct.random_in_weighed_table(tbl).name
	end,
}

local bossroom_info = {
	[1] = function(ent)	 -- Monstro
		return funct.random_in_weighed_table({
			{name = "101" .. funct.Random(8),weigh = 9,},
			{name = "112" .. choose(2,3),weigh = 1,},
			{name = "103" .. choose(7,8,9),weigh = 3,},
			{name = "1045",weigh = 1,},
		}).name
	end,
	[2] = function(ent)  -- Larry Jr.
		return funct.random_in_weighed_table({
			{name = "102" .. funct.Random(8),weigh = 9,},
			{name = "112" .. choose(4,5),weigh = 1,},
			{name = "104" .. choose(6,7,8,9),weigh = 4,},
		}).name
	end,
	[3] = function(ent)	 -- Ragman
		return choose("1019", "1029", "1035", "1036","1128","1129")
	end,
	[4] = function(ent)  -- Chub
		return funct.random_in_weighed_table({
			{name = "103" .. funct.Random(4),weigh = 5,},
			{name = "112" .. choose(6,7),weigh = 1,},
			{name = "105" .. choose(5,6,7),weigh = 3,},
		}).name
	end,
	[5] = function(ent)  -- Gurdy
		return funct.random_in_weighed_table({
			{name = "104" .. funct.Random(4),weigh = 5,},
			{name = "113" .. choose(0,1),weigh = 1,},
			{name = "105" .. choose(5,6),weigh = 2,},
		}).name
	end,
	[6] = function(ent)  -- Monstro II
		return funct.random_in_weighed_table({
			{name = "105" .. funct.Random(4),weigh = 5,},
			{name = "106" .. choose(7,8,9),weigh = 3,},
			{name = "1076",weigh = 1,},
		}).name
	end,
	[7] = function(ent)  -- Mom		--!!
		return funct.random_in_weighed_table({
			{name = {name = "106" .. funct.Random(4),makedoor = true,},weigh = 5,},
		}).name
	end,
	[8] = function(ent)  -- Scolex
		return funct.random_in_weighed_table({
			{name = "107" .. funct.Random(5),weigh = 6,},
		}).name
	end,
	[9] = function(ent)  -- Haunt 2			--!!
		return funct.random_in_weighed_table({
			{name = "1079",weigh = 1,},
			{name = "108" .. choose(5,6,7),weigh = 3,},
		}).name
	end,
	[10] = function(ent)  -- Mom's Heart		--!!
		return funct.random_in_weighed_table({
			{name = "108" .. funct.Random(4),weigh = 5,},
		}).name
	end,
	[11] = function(ent)  -- Little Horn		--!!
		return funct.random_in_weighed_table({
			{name = "108" .. choose(8,9),weigh = 2,},
			{name = "105" .. choose(5,6),weigh = 2,},
		}).name
	end,
	[12] = function(ent)  -- It Lives		--!!
		return funct.random_in_weighed_table({
			{name = "109" .. funct.Random(4),weigh = 5,},
		}).name
	end,
	[13] = function(ent)  -- Dingle 2/Brownie
		return funct.random_in_weighed_table({
			{name = "109" .. choose(7,8,9),weigh = 3,},
			{name = "1105",weigh = 1,},
			{name = "1116",weigh = 1,},
		}).name
	end,
	[14] = function(ent)  -- C.H.A.D.
		return funct.random_in_weighed_table({
			{name = "110" .. funct.Random(4),weigh = 5,},
		}).name
	end,
	-- Gish
	[15] = function(ent)  -- Stain
		return funct.random_in_weighed_table({
			{name = "110" .. choose(6,7,8,9),weigh = 4,},
			{name = "1115",weigh = 1,},
		}).name
	end,
	[16] = function(ent)  -- Dangle
		return funct.random_in_weighed_table({
			{name = "111" .. choose(7,8,9),weigh = 3,},
			{name = "112" .. choose(0,1),weigh = 2,},
		}).name
	end,
	[17] = function(ent)  -- Duke of Flies		--!!
		return funct.random_in_weighed_table({
			{name = "201" .. funct.Random(8),weigh = 9,},
		}).name
	end,
	[18] = function(ent)  -- Peep
		return funct.random_in_weighed_table({
			{name = "202" .. funct.Random(5),weigh = 6,},
		}).name
	end,
	-- loki
	-- Blastocyst
	-- Gemini
	[19] = function(ent)  -- Fistula		--!!
		return funct.random_in_weighed_table({
			{name = "206" .. funct.Random(4),weigh = 5,},
		}).name
	end,
	-- Steven
	[20] = function(ent)  -- Hollow		--!!
		return funct.random_in_weighed_table({
			{name = "326" .. funct.Random(6),weigh = 7,},
		}).name
	end,
	-- Carrion Queen
	-- Gurdy Jr.
	-- The Husk
	-- The Bloat
	-- Lokii
	-- The Blighted Ovum
	[21] = function(ent)  -- Teratoma		--!!
		return funct.random_in_weighed_table({
			{name = "333" .. funct.Random(3),weigh = 4,},
		}).name
	end,
	-- Widow
	-- Mask of Infamy
	-- The Wrethced
	-- Pin
	-- Isaac --!!
	-- Frail
	-- Big Horn
	-- Rag Mega
	-- Sisters Vis
	[22] = function(ent)  -- Matriarch
		return funct.random_in_weighed_table({
			{name = "515" .. choose(2,3,4,5),weigh = 4,},
		}).name
	end,
	-- Blue baby
	-- Daddy Long Legs
	-- Triachnid
	[23] = function(ent)  -- Fallen		--!!
		return funct.random_in_weighed_table({
			{name = "350" .. choose(0,1,2),weigh = 3,},
		}).name
	end,
	-- Satan
	[24] = function(ent)  -- Famine		--!!
		return funct.random_in_weighed_table({
			{name = "401" .. choose(0,2,3,4),weigh = 4,},
		}).name
	end,
	[25] = function(ent)  -- Pestilence		--!!
		return funct.random_in_weighed_table({
			{name = "402" .. choose(0,1,2),weigh = 3,},
		}).name
	end,
	[26] = function(ent)  -- War		--!!
		return funct.random_in_weighed_table({
			{name = "402" .. choose(0,4,5),weigh = 3,},
		}).name
	end,
	[27] = function(ent)  -- Conquest		--!!
		return funct.random_in_weighed_table({
			{name = "403" .. choose(1,2,3),weigh = 3,},
		}).name
	end,
	[28] = function(ent)  -- Death		--!!
		return funct.random_in_weighed_table({
			{name = "404" .. choose(0,1,2),weigh = 3,},
		}).name
	end,
	[29] = function(ent)  -- Headless Horseman		--!!
		return funct.random_in_weighed_table({
			{name = "405" .. choose(0,1,2),weigh = 3,},
		}).name
	end,
	-- Haunt
	-- Dingle
	-- Mega Maw
	[30] = function(ent)  -- The Gate
		return funct.random_in_weighed_table({
			{name = "504" .. choose(0,1,2,4,5),weigh = 5,},
		}).name
	end,
	[31] = function(ent)  -- Mega Fatty
		return funct.random_in_weighed_table({
			{name = "505" .. choose(0,1,2,4),weigh = 4,},
		}).name
	end,
	-- The Cage
	-- Mama Gurdy
	-- Dark One
	-- The Adversary
	-- The Lamb
	[32] = function(ent)  -- Gurglings
		return funct.random_in_weighed_table({
			{name = "514" .. choose(0,1,2,3,4),weigh = 5,},
		}).name
	end,
	[33] = function(ent)  -- Polycephalus
		return funct.random_in_weighed_table({
			{name = "510" .. choose(0,1,2,3,4,6),weigh = 5,},
		}).name
	end,
	-- Turdlings
	
	-- Baby Plum
	-- Beelzeblub
	-- Wormwood
	-- Clog
	[34] = function(ent)  -- Hornfell
		return funct.random_in_weighed_table({
			{name = "522" .. choose(0,1,2,3,4,5,6,8,9),weigh = 9,},
		}).name
	end,
	[35] = function(ent)  -- Rainmaker
		return funct.random_in_weighed_table({
			{name = "523" .. choose(0,1,2,3,4),weigh = 5,},
		}).name
	end,
	-- The Pile
	-- Reap Creep
	-- Singe
	-- Bumbino
	-- Min Min
	-- Heretic
	-- The Visage
	-- Turdlet
	-- Colostomia
	-- Rotgut
	-- Chimera
	-- Scourge
	-- Siren
	-- Horny Boys
	-- The Possessor
	[36] = function(ent)  -- Mom 2	--!!
		return {name = "6030",makedoor = true,}
	end,
	[37] = function(ent)  -- Mom's Heart 2	--!!
		return {name = "6040",setopen = true,}
	end,
}

function funct.DecideBoss(stg,typ)
	local level = Game():GetLevel()
	
	stg = stg or funct.get_level_door_info()
	typ = typ or level:GetStageType()
	
	if stg <= 1 then
		if typ == 0 or typ == 1 then
			return choose2({
				funct.check_if_any(bossroom_info[1]),	 -- Monstro
				funct.check_if_any(bossroom_info[2]),	 -- Larry Jr.
				"205" .. funct.Random(3), -- Gemini
				"502" .. funct.Random(5), -- Dingle
				funct.check_if_any(bossroom_info[32]), -- Gurglings
				"516" .. funct.Random(5), -- Baby Plum
				funct.check_if_any(bossroom_info[16]), -- Dangle
				"51"  .. (46 + funct.Random(5)), -- Turdlings
				funct.check_if_any(bossroom_info[11]), -- Little Horn
				funct.check_if_any(bossroom_info[17]), -- Duke of Flies
				"207" .. funct.Random(3), -- Steven
				funct.check_if_any(bossroom_info[24]), -- Famine
				funct.check_if_any(bossroom_info[29]), -- Headless Horseman
			})
		elseif typ == 1 then
			return choose2({
				"332" .. funct.Random(3), -- The Blighted Ovum
				"334" .. funct.Random(5), -- Widow
				"337" .. funct.Random(8), -- Pin
				"501" .. funct.Random(4), -- Haunt
				"516" .. funct.Random(5), -- Baby Plum
				funct.check_if_any(bossroom_info[11]), -- Little Horn
				funct.check_if_any(bossroom_info[17]), -- Duke of Flies
				funct.check_if_any(bossroom_info[3]), -- Ragman
				funct.check_if_any(bossroom_info[24]), -- Famine
				funct.check_if_any(bossroom_info[29]), -- Headless Horseman
			})
		elseif typ == 4 then
			return choose2({
				"518" .. funct.Random(4), -- Wormwood
				"517" .. funct.Random(5), -- Beelzeblub
				
				funct.check_if_any(bossroom_info[35]), -- Rainmaker
				"528" .. funct.Random(3), -- Min Min
			})
		elseif typ == 5 then
			return choose2({
				"518" .. funct.Random(4), -- Wormwood
				"517" .. funct.Random(5), -- Beelzeblub
				
				"519" .. funct.Random(4), -- Clog
				"532" .. funct.Random(2), -- Turdlet
				"5330", -- Colostomia
			})
		else 
			return choose2({
				funct.check_if_any(bossroom_info[24]), -- Famine
				funct.check_if_any(bossroom_info[1]),	 -- Monstro
				funct.check_if_any(bossroom_info[2]),	 -- Larry Jr.
				funct.check_if_any(bossroom_info[11]), -- Little Horn
				"205" .. funct.Random(3), -- Gemini
				"502" .. funct.Random(5), -- Dingle
				funct.check_if_any(bossroom_info[32]), -- Gurglings
				funct.check_if_any(bossroom_info[17]), -- Duke of Flies
				"516" .. funct.Random(5), -- Baby Plum
				funct.check_if_any(bossroom_info[16]), -- Dangle
				"51"  .. (46 + funct.Random(5)), -- Turdlings
				"207" .. funct.Random(3), -- Steven
				"332" .. funct.Random(3), -- The Blighted Ovum
				"334" .. funct.Random(5), -- Widow
				"337" .. funct.Random(8), -- Pin
				"501" .. funct.Random(4), -- Haunt
				funct.check_if_any(bossroom_info[3]), -- Ragman
				
				"518" .. funct.Random(4), -- Wormwood
				"517" .. funct.Random(5), -- Beelzeblub
				
				funct.check_if_any(bossroom_info[35]), -- Rainmaker
				"528" .. funct.Random(3), -- Min Min
				"519" .. funct.Random(4), -- Clog
				"532" .. funct.Random(2), -- Turdlet
				"5330", -- Colostomia
				funct.check_if_any(bossroom_info[29]), -- Headless Horseman
			})
		end
	elseif stg == 2 then
		if typ == 0 then	
			return choose2({
				funct.check_if_any(bossroom_info[18]), -- Peep
				"339" .. (4 + funct.Random(3)), -- Big Horn,
				"527" .. funct.Random(4), -- Bumbino
				choose("3398", "3399", "3404", "3405"), -- Rag Mega
				"328" .. funct.Random(3), -- Gurdy Jr.
				funct.check_if_any(bossroom_info[4]), -- Chub
				funct.check_if_any(bossroom_info[5]), -- Gurdy
				"503" .. funct.Random(4), -- Mega Maw
				funct.check_if_any(bossroom_info[31]), -- Mega Fatty
				funct.check_if_any(bossroom_info[14]), -- C.H.A.D.
				funct.check_if_any(bossroom_info[15]), -- Stain
				funct.check_if_any(bossroom_info[9]), -- Haunt 2
				funct.check_if_any(bossroom_info[19]), -- Fistula
				funct.check_if_any(bossroom_info[25]), -- Pestilence
			})
		elseif typ == 1 then
			return choose2({
				funct.check_if_any(bossroom_info[18]), -- Peep
				"339" .. (4 + funct.Random(3)), -- Big Horn,
				"527" .. funct.Random(4), -- Bumbino
				choose("3398", "3399", "3404", "3405"), -- Rag Mega				
				"328" .. funct.Random(3), -- Gurdy Jr.
				"237" .. funct.Random(3), -- Carrion Queen
				"329" .. funct.Random(5), -- The Husk
				"336" .. funct.Random(3), -- The Wrethced
				funct.check_if_any(bossroom_info[33]), -- Polycephalus
				"508" .. funct.Random(4), -- Dark One
				"338" .. (4 + funct.Random(5)), -- Frail
				choose("1079", "1085", "1086", "1087"), -- Forsaken
				funct.check_if_any(bossroom_info[9]), -- Haunt 2
				funct.check_if_any(bossroom_info[20]), -- Hollow
				funct.check_if_any(bossroom_info[25]), -- Pestilence
				funct.check_if_any(bossroom_info[23]), -- Fallen
			})
		elseif typ == 2 then
			return choose2({
				funct.check_if_any(bossroom_info[18]), -- Peep
				"339" .. (4 + funct.Random(3)), -- Big Horn,
				"527" .. funct.Random(4), -- Bumbino
				choose("3398", "3399", "3404", "3405"), -- Rag Mega
				
				funct.check_if_any(bossroom_info[4]), -- Chub
				funct.check_if_any(bossroom_info[5]), -- Gurdy
				"503" .. funct.Random(4), -- Mega Maw
				funct.check_if_any(bossroom_info[31]), -- Mega Fatty
				funct.check_if_any(bossroom_info[14]), -- C.H.A.D.
				funct.check_if_any(bossroom_info[15]), -- Stain
				"338" .. (4 + funct.Random(5)), -- Frail
				choose("1079", "1085", "1086", "1087"), -- Forsaken
				funct.check_if_any(bossroom_info[9]), -- Haunt 2
				funct.check_if_any(bossroom_info[19]), -- Fistula
				funct.check_if_any(bossroom_info[23]), -- Fallen
			})
		elseif typ == 4 then
			return choose2({
				"525" .. funct.Random(6), -- Reap Creep
				funct.check_if_any(bossroom_info[34]), -- Hornfell
				"524" .. funct.Random(4), -- The Pile
				"508" .. funct.Random(4), -- Dark One
				choose("1079", "1085", "1086", "1087"), -- Forsaken
				"527" .. funct.Random(4), -- Bumbino
			})
		elseif typ == 5 then
			return choose2({
				"524" .. funct.Random(4), -- The Pile
				"526" .. funct.Random(4), -- Singe
				"602" .. funct.Random(2), -- The Possessor
				choose("1079", "1085", "1086", "1087"), -- Forsaken
				funct.check_if_any(bossroom_info[34]), -- Hornfell
			})
		else 
			return choose2({
				"237" .. funct.Random(3), -- Carrion Queen
				"329" .. funct.Random(5), -- The Husk
				"336" .. funct.Random(3), -- The Wrethced
				funct.check_if_any(bossroom_info[33]), -- Polycephalus
				funct.check_if_any(bossroom_info[18]), -- Peep
				"339" .. (4 + funct.Random(3)), -- Big Horn,
				"328" .. funct.Random(3), -- Gurdy Jr.
				"527" .. funct.Random(4), -- Bumbino
				choose("3398", "3399", "3404", "3405"), -- Rag Mega
				funct.check_if_any(bossroom_info[4]), -- Chub
				funct.check_if_any(bossroom_info[5]), -- Gurdy
				"503" .. funct.Random(4), -- Mega Maw
				funct.check_if_any(bossroom_info[31]), -- Mega Fatty
				funct.check_if_any(bossroom_info[14]), -- C.H.A.D.
				funct.check_if_any(bossroom_info[15]), -- Stain
				"338" .. (4 + funct.Random(5)), -- Frail
				"525" .. funct.Random(6), -- Reap Creep
				"508" .. funct.Random(4), -- Dark One
				funct.check_if_any(bossroom_info[9]), -- Haunt 2
				funct.check_if_any(bossroom_info[19]), -- Fistula
				funct.check_if_any(bossroom_info[20]), -- Hollow
				funct.check_if_any(bossroom_info[25]), -- Pestilence
				
				"524" .. funct.Random(4), -- The Pile
				"526" .. funct.Random(4), -- Singe
				"602" .. funct.Random(2), -- The Possessor
				choose("1079", "1085", "1086", "1087"), -- Forsaken
				funct.check_if_any(bossroom_info[34]), -- Hornfell
				funct.check_if_any(bossroom_info[23]), -- Fallen
			})
		end
	elseif stg == 3 then
		if typ == 0 or typ == 2 then	
			return choose2({
				"203" .. funct.Random(3), -- Loki
				"340" .. (6 + funct.Random(3)), -- Sisters Vis
				funct.check_if_any(bossroom_info[13]), -- Brownie
				funct.check_if_any(bossroom_info[6]), -- Monstro II
				"111" .. funct.Random(4), -- Gish
				"506" .. funct.Random(4), -- The Cage
				funct.check_if_any(bossroom_info[30]), -- The Gate
				"525" .. funct.Random(6), -- Reap Creep
				funct.check_if_any(bossroom_info[7]),	-- Mom
				funct.check_if_any(bossroom_info[21]), -- Teratoma
				funct.check_if_any(bossroom_info[23]), -- Fallen
				funct.check_if_any(bossroom_info[26]), -- War
			})
		elseif typ == 1 then
			return choose2({
				"203" .. funct.Random(3), -- Loki
				"340" .. (6 + funct.Random(3)), -- Sisters Vis
				funct.check_if_any(bossroom_info[13]), -- Brownie
				
				"330" .. funct.Random(3), -- The Bloat
				"335" .. funct.Random(3), -- Mask of Infamy
				"509" .. funct.Random(4), -- The Adversary
				"524" .. funct.Random(4), -- The Pile
				funct.check_if_any(bossroom_info[7]),	-- Mom
				funct.check_if_any(bossroom_info[21]), -- Teratoma
				funct.check_if_any(bossroom_info[23]), -- Fallen
				funct.check_if_any(bossroom_info[26]), -- War
			})
		elseif typ == 4 then
			return choose2({
				"537" .. funct.Random(2), -- Siren
				"529" .. funct.Random(3), -- Heretic
				"509" .. funct.Random(4), -- The Adversary
				"330" .. funct.Random(3), -- The Bloat
				funct.check_if_any(bossroom_info[36]),	-- Mom 2
				funct.check_if_any(bossroom_info[37]),	-- Mom's Heart 2
			})
		elseif typ == 5 then
			return choose2({
				"530" .. funct.Random(1), -- The Visage
				"601" .. funct.Random(2), -- Horny Boys
				"330" .. funct.Random(3), -- The Bloat
				funct.check_if_any(bossroom_info[23]), -- Fallen
				funct.check_if_any(bossroom_info[36]),	-- Mom 2
				funct.check_if_any(bossroom_info[37]),	-- Mom's Heart 2
			})
		else 
			return choose2({
				funct.check_if_any(bossroom_info[6]), -- Monstro II
				funct.check_if_any(bossroom_info[21]), -- Teratoma
				"111" .. funct.Random(4), -- Gish
				"506" .. funct.Random(4), -- The Cage
				"525" .. funct.Random(6), -- Reap Creep
				"203" .. funct.Random(3), -- Loki
				"340" .. (6 + funct.Random(3)), -- Sisters Vis
				funct.check_if_any(bossroom_info[13]), -- Brownie
				funct.check_if_any(bossroom_info[26]), -- War
				"335" .. funct.Random(3), -- Mask of Infamy
				"524" .. funct.Random(4), -- The Pile
				funct.check_if_any(bossroom_info[7]),	-- Mom
				
				"537" .. funct.Random(2), -- Siren
				"529" .. funct.Random(3), -- Heretic
				"509" .. funct.Random(4), -- The Adversary
				"330" .. funct.Random(3), -- The Bloat
				funct.check_if_any(bossroom_info[23]), -- Fallen
				
				"530" .. funct.Random(1), -- The Visage
				"601" .. funct.Random(2), -- Horny Boys
				funct.check_if_any(bossroom_info[30]), -- The Gate
				funct.check_if_any(bossroom_info[36]),	-- Mom 2
				funct.check_if_any(bossroom_info[37]),	-- Mom's Heart 2
			})
		end
	elseif stg == 4 then
		if typ <= 2 then
			return choose2({
				"331" .. funct.Random(3), -- Lokii
				funct.check_if_any(bossroom_info[8]), -- Scolex
				"204" .. funct.Random(3), -- Blastocyst
				"507" .. funct.Random(2), -- Mama Gurdy
				"330" .. funct.Random(3), -- The Bloat
				"340" .. funct.Random(3), -- Daddy Long Legs
				"341" .. funct.Random(3), -- Triachnid
				funct.check_if_any(bossroom_info[22]), -- Matriarch
				funct.check_if_any(bossroom_info[10]),	-- Mom's Heart
				funct.check_if_any(bossroom_info[11]),	-- It Lives
				funct.check_if_any(bossroom_info[37]),	-- Mom's Heart 2
				funct.check_if_any(bossroom_info[21]), 	-- Teratoma
				funct.check_if_any(bossroom_info[27]), -- Conquest
				funct.check_if_any(bossroom_info[28]), -- Death
			})
		elseif typ == 4 then
			return choose2({
				"536" .. funct.Random(2), -- Scourge
				"535" .. funct.Random(2), -- Chimera
				"5340", -- Rotgut
				"330" .. funct.Random(3), -- The Bloat
				funct.check_if_any(bossroom_info[22]), -- Matriarch
				funct.check_if_any(bossroom_info[10]),	-- Mom's Heart
				funct.check_if_any(bossroom_info[11]),	-- It Lives
			})
		else
			return choose2({
				"331" .. funct.Random(3), -- Lokii
				funct.check_if_any(bossroom_info[8]), -- Scolex
				funct.check_if_any(bossroom_info[21]), -- Teratoma
				"204" .. funct.Random(3), -- Blastocyst
				"507" .. funct.Random(2), -- Mama Gurdy
				"330" .. funct.Random(3), -- The Bloat
				"340" .. funct.Random(3), -- Daddy Long Legs
				"341" .. funct.Random(3), -- Triachnid
				funct.check_if_any(bossroom_info[27]), -- Conquest
				funct.check_if_any(bossroom_info[28]), -- Death
				
				"536" .. funct.Random(2), -- Scourge
				"535" .. funct.Random(2), -- Chimera
				"5340", -- Rotgut
				funct.check_if_any(bossroom_info[22]), -- Matriarch
				funct.check_if_any(bossroom_info[10]),	-- Mom's Heart
				funct.check_if_any(bossroom_info[11]),	-- It Lives
				funct.check_if_any(bossroom_info[37]),	-- Mom's Heart 2
			})
		end
	elseif stg == 6 then		--阴间和天堂一大堆，下一层则改为全随机
		if typ == 0 then return choose("3600","5130") end
		if typ == 1 then return choose("3380","3390") end
		return choose("3600","3380","5130","3390")
	else
		return funct.DecideBoss(choose(1,2,3,4,6),-1)
	end
	return "1010"
end

function funct.find_a_decide_boss(shape)
	local ret = nil
	if shape == RoomShape.ROOMSHAPE_1x1 then
		if math.random(1000) > 500 then ret = funct.DecideBoss()
		elseif math.random(1000) > 500 then ret = funct.DecideBoss(nil,-1)
		else ret = funct.DecideBoss(funct.get_level_door_info() + choose(1,-1),-1) end
	elseif otherroom_info[shape] then
		ret = funct.check_if_any(otherroom_info[shape])
	end
	if type(ret) == "string" then ret = {name = ret,} end
	return ret
end

function funct.get_near_gridindex(orig_idx,dir)
	local ret = {}
	dir = dir or 40
	if dir < 0 then dir = - dir end
	dir = math.ceil(dir/40)
	local room = Game():GetRoom()
	local orig_pos = room:GetGridPosition(orig_idx)
	local dx = 1
	local dy = room:GetGridIndex(orig_pos + Vector(0,40)) - orig_idx
	local lr = orig_idx - dx * dir - dy * dir
	for i = 1,(dir * 2 + 1) do
		for j = 1,(dir * 2 + 1) do
			local grididx = lr + dx * (i - 1) + dy * (j - 1)
			if grididx >= 0 then
				table.insert(ret,#ret + 1,grididx)
			end
		end
	end
	return ret
end

function funct.check_to_number(num,rng)
	local n1 = math.floor(num)
	local n2 = math.ceil(num)
	local rnd = math.random(1000)/1000
	if rng then rnd = rng:RandomFloat() end
	if rnd > num - n1 then return n1 else return n2 end
end

function funct.check_exists(ent)
	return ent and type(ent) ~= "function" and ent.Exists and ent:Exists()
end

function funct.check_all_exists(ent)
	return (ent and type(ent) ~= "function" and ent.Exists and ent:Exists() and ent.IsDead and not ent:IsDead()) == true
end

function funct.check_on_all_exists(ent)
	if funct.check_all_exists(ent) then return ent else return nil end
end

function funct.check_if_any(val,...)
	if type(val) == "function" then return funct.check_if_any(val(...),...) end
	if type(val) == "table" and val["Function"] then return funct.check_if_any(val["Function"],val,...) end
	return val
end

function funct.check_delay_exists(ent)
	return ent and (type(ent) == "function" or type(ent) == "table" or (ent.Exists and ent:Exists()))
end

local removed_pickups = {
	[50] = true,
	[51] = true,
	[52] = true,
	[53] = true,
	[54] = true,
	[55] = true,
	[56] = true,
	[57] = true,
	[58] = true,
	[60] = true,
	[100] = true,
	[360] = true,
}

function funct.would_be_removed_entity(ent)
	if ent.Type == 5 and removed_pickups[ent.Variant] and ent.SubType == 0 then return true end
end

function funct.fire_lung(pos,vel,player,params)
	player = player or Game():GetPlayer(0)
	pos = pos or player.Position
	params = params or {}
	vel = vel or ((params.dir or Vector(1,0)) * player.ShotSpeed * 10)
	local ret = {}
	local cnt = params.cnt or (12 + math.random(8))
	if params.Boss then
		local ent = params.Boss
		for i = 1,cnt do 
			local q = Isaac.Spawn(9,0,0,pos,auxi.get_by_rotate(vel,auxi.random_2() * (params.round or 12),vel:Length() * (1 + auxi.random_2() * 0.3)),ent):ToProjectile()
			q.Damage = (params.dmg or q.Damage) * (params.dmgrate or 1)
			q.FallingSpeed = -7.5 + auxi.random_2() * 5 + (params.raiseup or 0)
			q.FallingAccel = 0.5
			q.Scale = q.Scale * (1.2 + auxi.random_2() * 0.3)
			table.insert(ret,#ret + 1,q)
		end
	else
		for i = 1,cnt do 
			local q = player:FireTear(pos,auxi.get_by_rotate(vel,auxi.random_2() * 12,vel:Length() * (1 + auxi.random_2() * 0.3)),true,true,true)
			q.CollisionDamage = (params.dmg or q.CollisionDamage) * (params.dmgrate or 1)
			q.FallingSpeed = -7.5 + auxi.random_2() * 5
			q.FallingAcceleration = 0.5
			q.Scale = q.Scale * (1.2 + auxi.random_2() * 0.3)
			q:ResetSpriteScale()
			table.insert(ret,#ret + 1,q)
		end
	end
	return ret
end

function funct.Lerp(v1,v2,percent) return v1 * (1 - percent) + v2 * percent end
function funct.onLerp(v1,v2,percent) return v1 + (v2 - v1) * math.max(0,math.min(1,percent)) end
function funct.random_r() return auxi.MakeVector(math.random(3600)/10) end
function funct.random_c(val) if val - math.floor(val) > auxi.random_1() then return math.ceil(val) else return math.floor(val) end end
function funct.random_1() return math.random(1000)/1000 end
function funct.random_0() return math.random(2) * 2 - 3 end
function funct.random_2() return auxi.random_0() * auxi.random_1() * auxi.random_1() end
function funct.random_v() return Vector(auxi.random_1(),auxi.random_1()) end
function funct.sigmod(x,params) params = params or {} return 1/(1+math.exp(-((params.range2 or 5) * 2) * (x - (params.mid or 0.5))/(params.range or 1))) end
function funct.Get_rotate(t) return Vector(-t.Y,t.X) end
function funct.get_by_rotate(v,ang,length) v = v or Vector(0,1)	return (length or v:Length()) * funct.MakeVector(ang + v:GetAngleDegrees()) end

function funct.check_all_exists(ent)
	return (ent and type(ent) ~= "function" and ent.Exists and ent:Exists() and ent.IsDead and not ent:IsDead()) == true
end

function funct.GetDimension(roomDesc)
    roomDesc = roomDesc or Game():GetLevel():GetCurrentRoomDesc()
    if roomDesc.GridIndex < 0 then return 0 end
    local hash = GetPtrHash(roomDesc)
    for dimension = 0,2 do
        local dimensionDesc = Game():GetLevel():GetRoomByIdx(roomDesc.SafeGridIndex, dimension)
        if GetPtrHash(dimensionDesc) == hash then
            return dimension
        end
    end
end

function funct.get_acceptible_index(sgid,dim)
	sgid = sgid or Game():GetLevel():GetCurrentRoomDesc().SafeGridIndex
	if dim == -1 then dim = nil end
	dim = dim or funct.GetDimension()
	if sgid < 0 then return sgid 
	else return dim * 1000 + sgid end
end

function funct.make_red_room(id)
	local level = Game():GetLevel()
	if level:GetRoomByIdx(id).Data then return false end
	for i = 0,3 do 
		local iid = auxi.move_in_gridroom(id,i)
		if iid ~= id then 
			local ti = auxi.flipdirection(i)
			local desc_ = level:GetRoomByIdx(iid)
			if desc_ and desc_.Data and desc_.SafeGridIndex ~= iid then
				iid = desc_.SafeGridIndex
				ti = Gridroom_move_shape_info[desc_.Data.Shape][id - iid]
			end
			if level:MakeRedRoomDoor(iid,ti) then return true 
			else end	--print("Fail "..tostring(iid).." "..tostring(id).." "..tostring(i))	end
		end
	end
	return nil
end

function funct.check_equal(val1,val2)
	if val1 == nil or val2 == nil or val1 == -1 or val2 == -1 or val1 == val2 then return true end
	return false
end

local flip_directions = {
	[0] = 2,
	[1] = 3,
	[2] = 0,
	[3] = 1,
}
function funct.flipdirection(dir) return flip_directions[dir] end
local Gridroom_dir_move = {
	[-1] = 0,
	[-13] = 1,
	[1] = 2,
	[13] = 3,
}
function funct.move2dir(dir) return Gridroom_dir_move[dir] or -1 end
local Gridroom_move_dir = {
	[0] = -1,
	[1] = -13,
	[2] = 1,
	[3] = 13,
}
function funct.move_in_gridroom(id,dir)		--dir = 0,1,2,3
	if (id % 13 == 0 and dir == 0) or (id % 13 == 12 and dir == 2) or (id < 13 and dir == 1) or (id >= 13 * 12 and dir == 3) then return id end
	return id + Gridroom_move_dir[dir]
end

function funct.get_nearest(tbl,pos)
	tbl = tbl or {}
	pos = pos or Game():GetPlayer(0).Position
	local targ = tbl[1]
	local tu = 1
	if targ then 
		local dis = (targ.Position - pos):Length()
		for u,v in pairs(tbl) do
			local leg = (v.Position - pos):Length()
			if leg < dis then
				targ = v
				tu = u
				dis = leg
			end
		end
		return {tg = targ,tu = tu,dis = dis,}
	end
end

function funct.has_have_coll(player,collid)
	if player == nil or collid == nil then return false end
	player = player:ToPlayer() if player == nil then return false end
	return player:HasCollectible(collid)
end

function funct.check_lerp(frame,info,params)
	params = params or {}
	params.banlist = params.banlist or {}
	local st = #info
	local ed = #info
	for i = 1,#info do
		local v = info[i]
		if frame <= v.frame then 
			st = math.max(1,i - 1)
			ed = i
			break
		end
	end
	if params.shouldlerp then 
		local succ = auxi.check_if_any(params.shouldlerp,info[st],info[ed])
		if succ ~= true then 
			if frame == info[ed].frame then return auxi.deepCopy(info[ed]) end
			return auxi.deepCopy(info[st]) 
		end
	end
	local lerper = (frame - info[st].frame)/math.max(0.01,(info[ed].frame - info[st].frame))
	local ret = {}
	for u,v in pairs(info[st]) do
		if params.banlist[u] then 
			if frame == info[ed].frame then ret[u] = info[ed][u]
			else ret[u] = info[st][u] end
		else ret[u] = funct.Lerp(info[st][u],info[ed][u],lerper) end
	end
	return ret
end

function funct.GetPlayers()
	local ret = {}
	for i = 0,Game():GetNumPlayers() - 1 do table.insert(ret,#ret + 1,Game():GetPlayer(i)) end
	return ret
end

function funct.get_nearest_enemy(enemies,pos,val)
	enemies = enemies or funct.getenemies()
	pos = pos or Game():GetPlayer(0).Position
	local targ = enemies[1]
	if targ then 
		local dis = (targ.Position - pos):Length()
		for u,v in pairs(enemies) do
			local leg = (v.Position - pos):Length()
			if val then leg = auxi.check_if_any(val,leg,v) or leg end
			if leg < dis then
				targ = v
				dis = leg
			end
		end
	end
	return targ
end

local possible_targets = {
	{Type = 3,Variant = FamiliarVariant.PUNCHING_BAG,},
	{Type = 3,Variant = FamiliarVariant.LOST_FLY,},
}

function funct.get_acceptible_player_target(ent)
	local ret = nil
	local tbl = {}
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		table.insert(tbl,#tbl + 1,player)
	end
	for u_,v_ in pairs(possible_targets) do
		local tg = funct.getothers(nil,v_.Type,v_.Variant)
		for u,v in pairs(tg) do table.insert(tbl,#tbl + 1,v) end
	end
	for u,v in pairs(tbl) do
		if ret == nil or (ret.Position - ent.Position):Length() > (v.Position - ent.Position):Length() then	ret = v	end
	end
	return ret or Game():GetPlayer(0)
end

function funct.get_acceptible_target(ent)
	if ent.Target then return ent.Target end
	if ent:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then 
		return funct.get_nearest_enemy(nil,ent.Position) or funct.get_acceptible_player_target(ent)
	else
		return funct.get_acceptible_player_target(ent)
	end
end
function funct.Bool2str(v) if v == true then return "true" else return "false" end end
function funct.str2Bool(v) if v == "true" or v == true then return true else return false end end
function funct.ProtectVector(v) return Vector(v.X or 1,v.Y or 1) end
function funct.Vector2Table(v) return {X = v.X,Y = v.Y,} end
function funct.Flip2XorY(v) if math.abs(v.X) > math.abs(v.Y) then return Vector(v.X,0) else return Vector(0,v.Y) end end

function funct.remove_others_option_pickup(ent,effect)
	if ent.OptionsPickupIndex == 0 then return end
	effect = effect or true
	ent:GetData().OptionsPickupIndex_should_remove = true
	local n_entity = Isaac.GetRoomEntities()
	for u,v in pairs(n_entity) do
		if v:ToPickup() then
			local pickup = v:ToPickup()
			if pickup.OptionsPickupIndex == ent.OptionsPickupIndex and pickup:GetData().OptionsPickupIndex_should_remove ~= true then
				if effect then Isaac.Spawn(1000,15,0,pickup.Position,Vector(0,0),nil) end
				pickup:Remove()
			end
		end
	end
end

function funct.apply_friction(vel,val)
	return vel:Normalized() * (math.max(0,vel:Length() - (val or 1)))
end
function funct.get_id(val,lim)
	lim = lim or 0
	if val > lim then return 1 end
	if val < -lim then return -1 end
	return 0
end

local unstopable = {
	[EntityType.ENTITY_PLAYER] = true,
	--[EntityType.ENTITY_TEAR] = true,
	[EntityType.ENTITY_LASER] = true,
	--[EntityType.ENTITY_MINECART] = true,
	[EntityType.ENTITY_KNIFE] = true,
	[EntityType.ENTITY_PROJECTILE] = true,
	[EntityType.ENTITY_TEXT] = true,
	[EntityType.ENTITY_EFFECT] = true,
}

local eventlist = {
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
}

function funct.time_stop(name)
	name = name or ""
	local n_entity = Isaac.GetRoomEntities() 
	for u,v in pairs(n_entity) do 
		if funct.check_if_any(unstopable[v.Type],v) ~= true then
			local s = v:GetSprite()
			for u,v in pairs(eventlist) do if s:IsEventTriggered(v) ~= false then s:Update() end end
			local d = v:GetData()
			if d[name.."_freeze_succ"] == nil then d[name.."_freeze_succ"] = Attribute_holder.try_hold_attribute(v,"EntityFlag_FLAG_FREEZE",true,{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_FREEZE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_FREEZE) else ent:AddEntityFlags(EntityFlag.FLAG_FREEZE) end end,}) end
			if d[name.."_no_sprite_update_succ"] == nil then d[name.."_no_sprite_update_succ"] = Attribute_holder.try_hold_attribute(v,"EntityFlag_FLAG_NO_SPRITE_UPDATE",true,{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) else ent:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end end,}) end
			if d[name.."_position_succ"] == nil then d[name.."_position_succ"] = Attribute_holder.try_hold_attribute(v,"Position",Vector(v.Position.X,v.Position.Y),{tocompare = function(v1,v2) return (v1 - v2):Length() < 0.001 end,}) end
			if d[name.."_velocity_succ"] == nil then d[name.."_velocity_succ"] = Attribute_holder.try_hold_attribute(v,"Velocity",Vector(0,0),{tocompare = function(v1,v2) return (v1 - v2):Length() < 0.001 end,})	end
		end
	end
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		local d = player:GetData()
		if d[name.."_entitycollisionclass_none_succ"] == nil then d[name.."_entitycollisionclass_none_succ"] = Attribute_holder.try_hold_attribute(player,"EntityCollisionClass",EntityCollisionClass.ENTCOLL_NONE)	end
		if d[name.."_data_should_not_attack_succ"] == nil then d[name.."_data_should_not_attack_succ"] = Attribute_holder.try_hold_attribute(player,"Data_should_not_attack",true,{toget = function(ent) return ent:GetData().should_not_attack end,tochange = function(ent,value) ent:GetData().should_not_attack = value end,}) end
	end
end

function funct.time_free(name)
	name = name or ""
	local n_entity = Isaac.GetRoomEntities() 
	for u,v in pairs(n_entity) do 
		if funct.check_if_any(unstopable[v.Type],v) ~= true then
			local d = v:GetData()
			if d[name.."_freeze_succ"] then
				Attribute_holder.try_rewind_attribute(v,"EntityFlag_FLAG_FREEZE",d[name.."_freeze_succ"],{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_FREEZE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_FREEZE) else ent:AddEntityFlags(EntityFlag.FLAG_FREEZE) end end,})
				d[name.."_freeze_succ"] = nil
			end
			if d[name.."_no_sprite_update_succ"] then
				Attribute_holder.try_rewind_attribute(v,"EntityFlag_FLAG_NO_SPRITE_UPDATE",d[name.."_no_sprite_update_succ"],{toget = function(ent) return ent:HasEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end,tochange = function(ent,value) if value ~= true then ent:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) else ent:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE) end end,})
				d[name.."_no_sprite_update_succ"] = nil
			end
			if d[name.."_position_succ"] then
				Attribute_holder.try_rewind_attribute(v,"Position",d[name.."_position_succ"],{tocompare = function(v1,v2) return (v1 - v2):Length() < 0.001 end,})
				d[name.."_position_succ"] = nil
			end
			if d[name.."_velocity_succ"] then
				Attribute_holder.try_rewind_attribute(v,"Velocity",d[name.."_velocity_succ"],{tocompare = function(v1,v2) return (v1 - v2):Length() < 0.001 end,})
				d[name.."_velocity_succ"] = nil
			end
		end
	end
	for playerNum = 1, Game():GetNumPlayers() do
		local player = Game():GetPlayer(playerNum - 1)
		local d = player:GetData()
		if d[name.."_entitycollisionclass_none_succ"] then
			Attribute_holder.try_rewind_attribute(player,"EntityCollisionClass",d[name.."_entitycollisionclass_none_succ"])
			d[name.."_entitycollisionclass_none_succ"] = nil
		end
		if d[name.."_data_should_not_attack_succ"] then
			Attribute_holder.try_rewind_attribute(player,"Data_should_not_attack",d[name.."_data_should_not_attack_succ"],{toget = function(ent) return ent:GetData().should_not_attack end,tochange = function(ent,value) ent:GetData().should_not_attack = value end,})
			d[name.."_data_should_not_attack_succ"] = nil
		end
	end
end

function funct.GetScreenSize()
	local room = Game():GetRoom()
	local pos = room:WorldToScreenPosition(Vector(0,0)) - room:GetRenderScrollOffset() - Game().ScreenShakeOffset
	local rx = pos.X + 60 * 26 / 40
	local ry = pos.Y + 140 * (26 / 40)
	return Vector(rx*2 + 13*26, ry*2 + 7*26)
end

function funct.GetWaterRenderOffset()
	return - (auxi.GetScreenSize() - Vector(442,288)) * 0.5
end

function funct.GetScreenCenter()
	return funct.GetScreenSize() / 2
end

function funct.is_normal_game() return (Isaac.GetChallenge() > 0 or Game():GetVictoryLap() > 0) ~= true end
local color_adder = {
	["R"] = true,
	["G"] = true,
	["B"] = true,
	["A"] = true,
	["RO"] = true,
	["GO"] = true,
	["BO"] = true,
}
function funct.equalcolor(c1,c2) for u,v in pairs(color_adder) do if c1[u] ~= c2[u] then return false end end return true end
function funct.color2table(c) local ret = {} for u,v in pairs(color_adder) do ret[u] = c[u] end return ret end
function funct.table2color(tbl) return Color(tbl.R or 1,tbl.G or 1,tbl.B or 1,tbl.A or 1,tbl.RO or 0,tbl.GO or 0,tbl.BO or 0) end
function funct.PrintColor(col)
	print(col.R.." "..col.G.." "..col.B.." "..col.A.." "..col.RO.." "..col.GO.." "..col.BO)
end
function funct.xor(a, b)
    return (a and not b) or (not a and b)
end
function funct.softmax(inputs)
    local max_input = math.max(table.unpack(inputs))
    local exp_values = {}
    local sum_exp = 0

    -- 计算每个调整后的输入的指数值，并计算总和
    for i = 1, #inputs do
        exp_values[i] = math.exp(inputs[i] - max_input)
        sum_exp = sum_exp + exp_values[i]
    end

    -- 归一化指数值
    local softmax_values = {}
    for i = 1, #exp_values do
        softmax_values[i] = exp_values[i] / sum_exp
    end

    return softmax_values
end

local sprite_copy_list = {
	["Scale"] = "S",
	["FlipX"] = {name = "FX",default = false,},
	["FlipY"] = {name = "FY",default = false,},
	["Offset"] = true,
	["PlaybackSpeed"] = {name = "PS",default = 1,},
	["Rotation"] = {name = "R",default = 0,},
}

function funct.copy_sprite(s,s2,params)       --没有检测IsFinished与IsOverlayFinished
	params = params or {}
	s2 = s2 or Sprite()
	if (params.filename or s2:GetFilename()) ~= s:GetFilename() then s2:Load(params.filename or s:GetFilename(),true) end
	funct.check_if_any(params.on_replace,s2,s,params)
	if params.SetFrame ~= true then s2:SetFrame(params.Anim or s:GetAnimation(),params.Frame or s:GetFrame()) end
	if params.Play then s2:Play(params.Anim or s:GetAnimation(),true) end
	if params.SetOverLayFrame ~= true and (params.OverAnim or s:GetOverlayAnimation()) ~= "" then s2:SetOverlayFrame(params.OverAnim or s:GetOverlayAnimation(),params.OverFrame or s:GetOverlayFrame()) end
	if params.PlayOverlay and (params.OverAnim or s:GetOverlayAnimation()) ~= "" then s2:PlayOverlay(params.OverAnim or s:GetOverlayAnimation(),true) end
	if params.SetColor ~= true then s2.Color = Color(s.Color.R,s.Color.G,s.Color.B,s.Color.A,s.Color.RO,s.Color.GO,s.Color.BO) end
	for u,v in pairs(sprite_copy_list) do if params["Set"..u] ~= true then s2[u] = s[u] end end
	return s2
end

function funct.get_last_parentnpc(ent)
	if ent:ToNPC().ParentNPC then return auxi.get_last_parentnpc(ent:ToNPC().ParentNPC)
	else return ent:ToNPC() end
end

function funct.get_parentnpc_list(ent)
	local ret = {}
	if ent:ToNPC().ParentNPC then
		ret = auxi.get_parentnpc_list(ent.ParentNPC)
	end
	table.insert(ret,ent:ToNPC())
	return ret
end
function funct.copyVec(v) return Vector(v.X,v.Y) end
function funct.TryCopy(v)
	if type(v) == "userdata" and v.X and v.Y then return funct.copyVec(v) end
	if type(v) == "table" then return funct.deepCopy(v) end
	return v
end

function funct.is_under_water()
	local rm = Game():GetRoom():GetRenderMode()
	return rm == RenderMode.RENDER_WATER_REFRACT or rm == RenderMode.RENDER_WATER_REFLECT
end

function funct.update_related_grids(grid)
	local room = Game():GetRoom()
	local pos = grid.Position
	local offsets = {
        Vector(40, 40), Vector(40, 0), Vector(40, -40),
        Vector(0, 40),                Vector(0, -40),
        Vector(-40, 40), Vector(-40, 0), Vector(-40, -40)
    }
    
    for _, offset in ipairs(offsets) do
        local newPos = pos + offset
        local grid = room:GetGridEntity(room:GetGridIndex(newPos))
		if grid and grid:ToPit() then
			grid:PostInit()
		end
    end
end

function funct.xor(val1,val2)
	if val1 and not val2 then return true end
	if val2 and not val1 then return true end
end

return funct