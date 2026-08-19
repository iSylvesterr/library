-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local VisibleMgr = UtilsSystem.VisibleMgr;
local EnumMgr = UtilsSystem.EnumMgr;
local CfgFind = UtilsSystem.CfgFind;
local ResourceUtil = UtilsSystem.ResourceUtil;
local v7 = {
    sortItemIdsByXyd = function(p1) -- Line: 22, Name: sortItemIdsByXyd
        -- upvalues: CfgFind (copy), EnumMgr (copy)
        local v2 = table.clone(p1);
        table.sort(v2, function(p3, p4) -- Line: 25
            -- upvalues: CfgFind (ref), EnumMgr (ref)
            local v5 = CfgFind.FindCfgByID(p3, EnumMgr.ItemType.Pet);
            local v6 = CfgFind.FindCfgByID(p4, EnumMgr.ItemType.Pet);

            return (v5 and v5.xyd or 0) > (v6 and v6.xyd or 0);
        end);

        return v2;
    end
};

local function _buildPetModel(p8) -- Line: 41
    -- upvalues: CfgFind (copy), EnumMgr (copy), ResourceUtil (copy), VisibleMgr (copy)
    local v9 = CfgFind.FindCfgByID(tonumber(p8), EnumMgr.ItemType.Pet);

    if not (v9 and v9.Model) then
        warn(p8, "缺少模型");

        return nil;
    end;

    local v10 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.Pet, v9.Model);
    VisibleMgr.DisableTrail(v10);
    VisibleMgr.AnchoredAll(v10);
    VisibleMgr.UnCollideAll(v10);
    VisibleMgr.UnTouchAll(v10);
    VisibleMgr.UnQueryAll(v10);
    v10:SetAttribute("xyd", v9.xyd);
    v10:SetAttribute("idle", v9.NormalIdleName);

    return v10;
end;

function v7.buildPetModels(p11) -- Line: 66
    -- upvalues: _buildPetModel (copy)
    local v12 = {};

    for _, v in ipairs(p11) do
        local v13 = _buildPetModel(v);

        if v13 then
            table.insert(v12, v13);
        end;
    end;

    table.sort(v12, function(p14, p15) -- Line: 76
        return p14:GetAttribute("xyd") > p15:GetAttribute("xyd");
    end);

    return v12;
end;

return v7;