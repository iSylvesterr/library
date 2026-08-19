-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local v1 = {};
local u2 = nil;

local function _loadConfigData() -- Line: 36
    -- upvalues: u2 (ref), UtilsSystem (copy)
    if u2 then
        return u2;
    end;

    local GameConfig = UtilsSystem.GameConfig;

    if not GameConfig then
        return nil;
    end;

    u2 = GameConfig;

    return u2;
end;

function v1.Get() -- Line: 59
    -- upvalues: u2 (ref), UtilsSystem (copy)
    local v3;

    if u2 then
        v3 = u2;
    else
        local GameConfig = UtilsSystem.GameConfig;

        if GameConfig then
            u2 = GameConfig;
            v3 = u2;
        else
            v3 = nil;
        end;
    end;

    if not v3 then
        return nil;
    end;

    local Copy = UtilsSystem.Copy;

    if Copy then
        return Copy.deepCopy(v3);
    end;

    return nil;
end;

function v1.GetValue(p4) -- Line: 76
    -- upvalues: u2 (ref), UtilsSystem (copy)
    local v5;

    if u2 then
        v5 = u2;
    else
        local GameConfig = UtilsSystem.GameConfig;

        if GameConfig then
            u2 = GameConfig;
            v5 = u2;
        else
            v5 = nil;
        end;
    end;

    if not v5 then
        return nil;
    end;

    if type(p4) == "string" then
        return v5[p4];
    end;

    if type(p4) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(p4) do
        if v5 == nil then
            return nil;
        end;

        v5 = v5[v];
    end;

    return v5;
end;

function v1.ClearCache() -- Line: 103
    -- upvalues: u2 (ref)
    u2 = nil;
end;

return v1;