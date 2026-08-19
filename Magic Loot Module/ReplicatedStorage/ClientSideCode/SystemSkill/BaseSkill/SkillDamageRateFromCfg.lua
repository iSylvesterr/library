-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local v1 = {};

local function rateFromDamageRateField(p2, p3) -- Line: 13
    if type(p2) == "number" then
        return p2;
    end;

    if type(p2) ~= "table" then
        return 1;
    end;

    if #p2 == 0 then
        return 1;
    end;

    local v4 = p2[p3];

    if type(v4) == "number" then
        return v4;
    end;

    local v5 = p2[1];

    return type(v5) ~= "number" and 1 or v5;
end;

function v1.get(p6, p7) -- Line: 39
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    if not p6 or p6 <= 0 then
        return 1;
    end;

    local v8 = CfgFind.FindCfgByID(p6, EnumMgr.ItemType.Skill);

    if not v8 then
        return 1;
    end;

    local DamageRate = v8.DamageRate;

    if type(DamageRate) == "number" then
        return DamageRate;
    end;

    if type(DamageRate) ~= "table" then
        return 1;
    end;

    if #DamageRate == 0 then
        return 1;
    end;

    local v9 = DamageRate[p7 or 1];

    if type(v9) == "number" then
        return v9;
    end;

    local v10 = DamageRate[1];

    return type(v10) ~= "number" and 1 or v10;
end;

return v1;