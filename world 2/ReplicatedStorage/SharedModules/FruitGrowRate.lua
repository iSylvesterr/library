-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FruitIdentity = require(ReplicatedStorage.SharedModules.FruitIdentity);
local GrowRateData = require(ReplicatedStorage.SharedModules.GrowRateData);
local Fruits = ReplicatedStorage.PlantGenerationModules.Fruits;
local u1 = {};

return function(u2) -- Line: 29
    -- upvalues: u1 (copy), GrowRateData (copy), Fruits (copy), FruitIdentity (copy)
    if type(u2) ~= "string" or u2 == "" then
        return 0.025;
    end;

    local v3 = u1[u2];

    if v3 then
        return v3;
    end;

    local v4 = nil;
    local v5 = GrowRateData[u2];
    local v6;

    if v5 and v5.FruitGrowRate then
        v6 = v5.FruitGrowRate;
    else
        local v7;
        v7, v6 = pcall(function() -- Line: 44
            -- upvalues: Fruits (ref), FruitIdentity (ref), u2 (copy)
            local v8 = Fruits:FindFirstChild(FruitIdentity.ResolveFruitName(u2));

            if v8 then
                return (require(v8).GrowData or {}).GrowRate;
            end;

            return nil;
        end);

        if not v7 then
            v6 = v4;
        end;
    end;

    local v9 = v6 or 0.025;
    u1[u2] = v9;

    return v9;
end;