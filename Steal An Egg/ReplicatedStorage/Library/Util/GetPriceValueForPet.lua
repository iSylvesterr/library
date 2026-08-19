-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PetRegistry = require(ReplicatedStorage.Directory.PetRegistry);

return function(p1) -- Line: 10
    -- upvalues: PetRegistry (copy)
    if typeof(p1) ~= "table" or typeof(p1.PetData) ~= "table" then
        return 0;
    end;

    local v2 = PetRegistry.PetList[p1.PetType];

    if not v2 then
        return 0;
    end;

    local v3 = v2.SellPrice or 0;
    local PetData = p1.PetData;
    local v4 = typeof(PetData.Level) == "number" and (PetData.Level or 1) or 1;
    local v5 = typeof(PetData.Age) == "number" and (PetData.Age or 0) or 0;
    local v6 = typeof(PetData.Weight) == "number" and PetData.Weight or (PetData.BaseWeight or 1);
    local v7;

    if typeof(PetData.BaseWeight) == "number" then
        v7 = PetData.BaseWeight or v6;
    else
        v7 = v6;
    end;

    local v8 = math.max(0, v6 - v7) * 0.05 + 1;

    return math.floor(v3 * (1 + (v4 - 1) * 0.1) * (1 + v5 * 0.05) * v8);
end;