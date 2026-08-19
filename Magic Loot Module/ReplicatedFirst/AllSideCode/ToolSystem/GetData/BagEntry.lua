-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local Copy = UtilsSystem.Copy;
local PlayerData = UtilsSystem.PlayerData;
local Players = UtilsSystem.Players;
local v1 = {};

local function _findBagEntryByOnlyID(p2, p3) -- Line: 33
    for _, v in pairs(p2) do
        if v.onlyID == p3 then
            return v;
        end;
    end;

    return nil;
end;

function v1.GetDataAndCfg(p4, p5) -- Line: 49
    -- upvalues: RunService (copy), PlayerData (copy), Players (copy), CfgFind (copy), Copy (copy)
    if not p4 then
        return nil, nil;
    end;

    if not p5 then
        if not RunService:IsClient() then
            return nil, nil;
        end;

        p5 = PlayerData.GetPlrDataByKey(Players.LocalPlayer, "Bag");
    end;

    if type(p5) ~= "table" then
        return nil, nil;
    end;

    for _, v in pairs(p5) do
        if v.onlyID == p4 then
            break;
        end;
    end;

    if not v then
        return nil, nil;
    end;

    local v6 = CfgFind.FindCfgByID(v.id, v.tp);

    if v6 then
        return Copy.deepCopy(v), v6;
    end;

    return nil, nil;
end;

return v1;