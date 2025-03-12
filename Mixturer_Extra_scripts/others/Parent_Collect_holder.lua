local g = require("Mixturer_Extra_scripts.core.globals")
local save = require("Mixturer_Extra_scripts.core.savedata")
local enums = require("Mixturer_Extra_scripts.core.enums")
local auxi = require("Mixturer_Extra_scripts.auxiliary.functions")

local item = {
	ToCall = {},
	own_key = "Parent_Collect_holder_",
}

function item.collect_all_parents(ent)
	ent = ent:ToNPC() if ent:Exists() ~= true then return {} end
	local n_entity = Isaac.GetRoomEntities()
	local ret = {}
	for u,v in pairs(n_entity) do if v:ToNPC() and auxi.check_for_the_same(auxi.get_last_parentnpc(v:ToNPC()),ent) == true then table.insert(ret,v) end end
	return ret
end

function item.collect(ent)
	ent = ent:ToNPC() if ent:Exists() ~= true then return {} end
	local n_entity = Isaac.GetRoomEntities()
	local ret = {}
	for u,v in pairs(n_entity) do if v:ToNPC() and auxi.check_for_the_same(v:ToNPC().ParentNPC,ent) == true then table.insert(ret,v) end end
	return ret
end

function item.try_collect(ent,params)
	params = params or {}
	local d = ent:GetData()
	d[item.own_key.."data"] = d[item.own_key.."data"] or {}
	if #d[item.own_key.."data"] > 0 then 
		for i = #(d[item.own_key.."data"]),1,-1 do
			local v = d[item.own_key.."data"][i]
			if auxi.check_all_exists(v) and auxi.check_for_the_same(v:ToNPC().ParentNPC,ent) == true then 
				if params.just_one then return v end
			else table.remove(d[item.own_key.."data"],i) end
		end
	end
	if #(d[item.own_key.."data"]) == 0 or params.force then
		local data = item.collect(ent)
		d[item.own_key.."data"] = data
	end
	if params.just_one then return d[item.own_key.."data"][1]
	else return d[item.own_key.."data"] end
end

function item.searchAndRecord(ent, key, tbl)
	local mix = require("Mixturer_Extra_scripts.bosses.Boss_Mixturer")
	key = key or mix.own_key
	tbl = tbl or mix.targets
    -- 创建一个表来记录所有访问过的节点
    local visited = {}

    -- 定义一个递归函数来执行搜索
    local function recursiveSearch(node)
        if not node then return end

        local d = node:GetData()
		if d[item.own_key.."Visited"] then return end
		d[item.own_key.."Visited"] = true

        -- 标记当前节点为已访问
        if visited[node] then return end
        visited[node] = true

        -- 检查并访问父节点
        if node.ParentNPC then
            recursiveSearch(node.ParentNPC)
        end

        -- 检查并访问链接节点
        if d[key .. "linkee"] and d[key .. "linkee"].linker then
            local linkerNode = d[key .. "linkee"].linker
            recursiveSearch(linkerNode)

			local ld = linkerNode:GetData()
            -- 遍历链接节点的所有后继
            if ld[key.."effect"] then
				for u,v in pairs(tbl) do
					local vv = ld[key.."effect"][u]
					if auxi.check_for_the_same(vv.ent,node) ~= true then
                        recursiveSearch(vv.ent)
                    end
				end
            end
        end
    end
    -- 开始搜索
    recursiveSearch(ent)
	-- 将所有访问过的节点指针存储在 all_list
	local d = ent:GetData()
	d[item.own_key.."all_list"] = {}
	for v, _ in pairs(visited) do
		v:GetData()[item.own_key.."Visited"] = nil
		table.insert(d[item.own_key.."all_list"], v)
	end
	for u,v in pairs(d[item.own_key.."all_list"]) do
		print(v.Type.." "..v.Variant)
	end
	return ent
end

function item.search_for_linkage(ent,key,tbl,params)
	local mix = require("Mixturer_Extra_scripts.bosses.Boss_Mixturer")
	params = params or {}
	key = key or mix.own_key
	tbl = tbl or mix.targets
	local ents = Isaac.GetRoomEntities()
	local tgs = {}
	for u,v in pairs(ents) do
		if v:ToNPC() and v:IsEnemy() then 
			if v:ToNPC().ParentNPC then 
				local vd = v:ToNPC().ParentNPC:GetData()
				vd[item.own_key.."check"] = vd[item.own_key.."check"] or {}
				table.insert(vd[item.own_key.."check"],v)
			end
			if params.check_parent and v.Parent and v.Parent:ToNPC() then 
				local vd = v.Parent:GetData()
				vd[item.own_key.."check"] = vd[item.own_key.."check"] or {}
				table.insert(vd[item.own_key.."check"],v)
			end
			table.insert(tgs,v) 
		end
	end

    local stack = params.stack or {ent}
    local connectedEntities = {}

    while #stack > 0 do
        local current = table.remove(stack) -- 从栈中取出一个节点
        if not current:GetData()[item.own_key.."Visited"] then
            current:GetData()[item.own_key.."Visited"] = true
            table.insert(connectedEntities, current)
            
            for _, neighbor in ipairs(current:GetData()[item.own_key.."check"] or {}) do
                if not neighbor:GetData()[item.own_key.."Visited"] then
                    table.insert(stack, neighbor)
                end
            end
			if current.ParentNPC and not current.ParentNPC:GetData()[item.own_key.."Visited"] then
				table.insert(stack, current.ParentNPC)
			end
			if params.check_parent and current.Parent and current.Parent:ToNPC() then 
				table.insert(stack, current.Parent)
			end
			local cd = current:GetData()
			if cd[key .. "linkee"] and cd[key .. "linkee"].linker then
				local linkerNode = cd[key .. "linkee"].linker
				local ld = linkerNode:GetData()
				if params.take_linker then table.insert(stack,linkerNode) end
				if ld[key.."effect"] then
					for u,v in pairs(tbl) do
						local vv = ld[key.."effect"][u]
						if vv.ent and (not vv.ent:GetData()[item.own_key.."Visited"]) then
							table.insert(stack, vv.ent)
						end
					end
				end
			end
        end
    end
	for u,v in pairs(tgs) do v:GetData()[item.own_key.."Visited"] = nil end
	for u,v in pairs(tgs) do v:GetData()[item.own_key.."check"] = nil end
	return connectedEntities
end

function item.is_in_the_same_npc_group(e1,e2)
	local tbl = item.search_for_linkage(e2)
	for u,v in pairs(tbl) do if auxi.check_for_the_same(v,e1) then return true end end
	return false
end

function item.update_npc(ent,tbl,i_flag)
	tbl = tbl or auxi.getallenemies()
	i_flag = i_flag or (EntityFlag.FLAG_FRIENDLY | EntityFlag.FLAG_PERSISTENT | EntityFlag.FLAG_CHARM)
	for u,v in pairs(tbl) do if auxi.check_for_the_same(v,ent) ~= true then 
		v:AddEntityFlags(i_flag) 
	end end
	ent:Update() 
	for u,v in pairs(tbl) do if auxi.check_for_the_same(v,ent) ~= true then 
		v:ClearEntityFlags(i_flag)
	end end
end

return item