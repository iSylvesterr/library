-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local PlayerData = UtilsSystem.PlayerData;
local Players = UtilsSystem.Players;
local v1 = {};

local function _countItemInBagByID(p2, p3) -- Line: 31
    local v4 = 0;

    for i = #p2, 1, -1 do
        local v5 = p2[i];

        if v5 and v5.id == p3 then
            v4 = v4 + 1;
        end;
    end;

    return v4;
end;

function v1.GetItemCountByIDOnClient(p6) -- Line: 47
    -- upvalues: RunService (copy), Players (copy), PlayerData (copy)
    if not RunService:IsClient() then
        warn("GetData.Bag.GetItemCountByIDOnClient 必须客户端调用");

        return nil;
    end;

    local LocalPlayer = Players.LocalPlayer;
    local Bag = LocalPlayer:FindFirstChild("Bag");

    if not Bag then
        local v7 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

        if type(v7) ~= "table" then
            return 0;
        end;

        local v8 = 0;

        for i = #v7, 1, -1 do
            local v9 = v7[i];

            if v9 and v9.id == p6 then
                v8 = v8 + 1;
            end;
        end;

        return v8;
    end;

    local v10 = Bag:FindFirstChild((tostring(p6)));

    if v10 then
        return v10.Value;
    end;

    local v11 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v11) ~= "table" then
        return 0;
    end;

    local v12 = 0;

    for i = #v11, 1, -1 do
        local v13 = v11[i];

        if v13 and v13.id == p6 then
            v12 = v12 + 1;
        end;
    end;

    return v12;
end;

function v1.GetItemCountByID(p14, p15) -- Line: 81
    if not p14 then
        return 0;
    end;

    local Bag = p14:FindFirstChild("Bag");

    if not Bag then
        return 0;
    end;

    local v16 = Bag:FindFirstChild((tostring(p15)));

    if v16 then
        return v16.Value;
    end;

    local Shard = p14:FindFirstChild("Shard");

    if not Shard then
        return 0;
    end;

    local v17 = Shard:FindFirstChild((tostring(p15)));

    return not v17 and 0 or v17.Value;
end;

function v1.WaitBagNumberValue(p18, p19) -- Line: 115
    if not p18 then
        error("GetData.Bag.WaitBagNumberValue: plr is required");
    end;

    return p18:WaitForChild("Bag", (1 / 0)):WaitForChild(tostring(p19), (1 / 0));
end;

return v1;