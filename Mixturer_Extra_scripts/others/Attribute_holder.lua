local enums = require("Mixturer_Extra_scripts.core.enums")
local delay_buffer = require("Mixturer_Extra_scripts.auxiliary.delay_buffer")

local item = {
	ToCall = {},
	pre_name = "Attribute_Holder_",
	pre_name2 = "Attribute_Holder_N_",
	post_name = "Attribute_H_E_F",
	own_key = "Attribute_holder_",
	hash_map = {},
}

function item.Init()
	local Assemble_holder = require("Mixturer_Extra_scripts.others.Assemble_holder")
	Assemble_holder.register_on(item.own_key,item)
end

function item.check_if_any(...)
	local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
	return auxi.check_if_any(...)
end

function item.TryCopy(...)
	local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")
	return auxi.TryCopy(...)
end

function item.on_Assemble_fail(self,target)
	self.try_hold_and_rewind_attribute = target.try_hold_and_rewind_attribute
	self.try_hold_attribute = target.try_hold_attribute
	self.try_rewind_attribute = target.try_rewind_attribute
	self.Assemble_negative = true
end

--再次扩展
table.insert(item.ToCall,#item.ToCall + 1,{CallBack = ModCallbacks.MC_POST_UPDATE, params = nil,			--注意！这样的写法可能覆盖其他MOD，或是导致部分bug的发生。
Function = function(_)
	if item.Assemble_negative then return end
	local n_entity = Isaac.GetRoomEntities()
	for u,v in pairs(n_entity) do
		local ent = v
		local d = ent:GetData()
		if d[item.post_name] ~= nil then
			if d[item.post_name.."_T_D"] ~= true then
				if #d[item.post_name] == 0 then
					d[item.post_name] = nil
				else
					if ent:ToPlayer() then ent = ent:ToPlayer()
					elseif ent:ToEffect() then ent = ent:ToEffect()
					elseif ent:ToNPC() then ent = ent:ToNPC()
					elseif ent:ToPickup() then ent = ent:ToPickup()
					elseif ent:ToFamiliar() then ent = ent:ToFamiliar()
					elseif ent:ToBomb() then ent = ent:ToBomb()
					elseif ent:ToKnife() then ent = ent:ToKnife()
					elseif ent:ToLaser() then ent = ent:ToLaser()
					elseif ent:ToTear() then ent = ent:ToTear()
					elseif ent:ToProjectile() then ent = ent:ToProjectile()
					end
					for u,v in pairs(d[item.post_name]) do
						local name = v.name
						local tb = d[item.pre_name..name]
						local ent_name = ent[name]
						if v.toget and v.tochange then ent_name = v.toget(ent) end
						if tb == nil or #tb == 0 then			--此项已为空，恢复最初状态。
							if v.tochange then v.tochange(ent,v.origin_value) else ent[name] = v.origin_value end
							if d[item.pre_name2..name] then d[item.pre_name2..name] = nil end
							table.remove(d[item.post_name],u)
							d[item.pre_name..name] = nil
						else
							local now_v = item.check_if_any(d[item.pre_name2..name],ent)
							if now_v ~= nil then
								local comparevalue = (now_v ~= ent_name)
								if v.tocompare then comparevalue = not v.tocompare(now_v,ent_name) end
								if comparevalue then			--以非委托的方式被修改，直接修改初值，并且恢复委托状态。
									--print("Found change:"..tostring(name)..tostring(now_v).." "..tostring(ent_name).." "..tostring(v.origin_value))
									if v.protect ~= true then v.origin_value = ent_name end
									if v.tochange then v.tochange(ent,now_v) else ent[name] = now_v end
								end
							end
						end
					end
				end
			else
				d[item.post_name.."_T_D"] = nil
			end
		end
	end
end,
})

function item.try_hold_and_rewind_attribute(ent,name,change_to,rewind_cooldown,params)
	local succ = item.try_hold_attribute(ent,name,change_to,params)
	if succ then
		delay_buffer.addeffe(function(params)
			local succ = params.succ
			local name = params.name
			local ent = params.ent
			local pr = params.pr
			if succ ~= nil and ent and ent:Exists() and ent:IsDead() == false then
				local succc = item.try_rewind_attribute(ent,name,succ,pr)
				--if succc == false then print("Fail to End:"..name.." "..succ.." "..tostring(succc)) end		--记得报错
			end
		end,{succ = succ,ent = ent,name = name,pr = params,},rewind_cooldown)
	end
end

function item.try_hold_attribute(ent,name,change_to,params)			--可以传入的参数：appoint_id、binder、tochange、toget
	--print("try hold: "..tostring(name))
	if params == nil then params = {} end
	if ent == nil then return -1 end
	if name == nil then return -1 end
	if change_to == nil then return -1 end
	local d = ent:GetData()
	if params.binder then d = params.binder end			--有时不要绑在本体上。不过请尽量不这么做。
	local ent_name = ent[name]
	if params.toget and params.tochange then ent_name = params.toget(ent) end
	if ent_name ~= nil then
		d[item.post_name.."_T_D"] = true				--即使在原属性相同的情况下，也需要委托。
		if d[item.post_name] == nil then d[item.post_name] = {} end		--插入检索标记
		if d[item.pre_name..name] == nil then 
			table.insert(d[item.post_name],#d[item.post_name] + 1,{name = name,origin_value = item.TryCopy(ent[name]),tochange = params.tochange,toget = params.toget,tocompare = params.tocompare,protect = params.protect,})
			d[item.pre_name..name] = {}
		end
		local appoint_id = math.random(10000000) + 1
		while(item.hash_map[tostring(appoint_id)] ~= nil) do appoint_id = math.random(10000000) + 1 end
		item.hash_map[tostring(appoint_id)] = true
		if params.appoint_id then appoint_id = params.appoint_id end
		table.insert(d[item.pre_name..name],#d[item.pre_name..name] + 1,{value = ent_name,id = appoint_id,})
		d[item.pre_name2..name] = change_to					--与委托一起出现，也应该与委托一起消失。
		if params.tochange then params.tochange(ent,item.check_if_any(change_to,ent)) else ent[name] = item.check_if_any(change_to,ent) end
		return appoint_id
	end
	return -1
end

function item.try_rewind_attribute(ent,name,id,params)				--可以传入的参数：binder。请在rewind的时候重新传入tochange与toget。
	--print("try rewind: "..tostring(name))
	if params == nil then params = {} end
	if ent == nil then return false end
	if name == nil then return false end
	if id == nil then return false end
	local d = ent:GetData()
	if params.binder then d = params.binder end
	local ent_name = ent[name]
	if params.toget and params.tochange then ent_name = params.toget(ent) end
	if ent_name ~= nil then
		d[item.post_name.."_T_D"] = true
		if d[item.post_name] == nil or d[item.pre_name..name] == nil then return false end
		for i = #d[item.pre_name..name],1,-1 do
			local v = d[item.pre_name..name][i]
			if v.id == id then
				if i == #d[item.pre_name..name] then		--作为最后一个被委托的参数，当其被消除时，必须恢复现场。
					if params.tochange then params.tochange(ent,v.value) else ent[name] = v.value end
				end
				--print("Back to "..tostring(v.value))
				item.hash_map[tostring(id)] = nil
				table.remove(d[item.pre_name..name],i)
				return true
			end
		end
	end
	return false
end

return item