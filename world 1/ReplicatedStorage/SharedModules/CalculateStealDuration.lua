-- Decompiled with Potassium's decompiler.

local v1 = {};
local SellValueData = require(game.ReplicatedStorage.SharedModules.SellValueData);
local MutationData = require(game.ReplicatedStorage.SharedModules.MutationData);

function v1.Start(p2) -- Line: 6
end;

function v1.Init(p3) -- Line: 10
end;

function v1.CalculateStealDuration(p4, p5, p6, p7) -- Line: 14
    -- upvalues: SellValueData (copy), MutationData (copy)
    local v8 = math.floor(SellValueData[p5 or "Carrot"] * (p6 == nil and 1 or p6) ^ 3);

    if p7 then
        v8 = v8 * MutationData.ReturnPriceMultiplier(p7);
    end;

    return math.sqrt(v8);
end;

return v1;