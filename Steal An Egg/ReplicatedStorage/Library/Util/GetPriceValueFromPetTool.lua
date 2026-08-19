-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local GetPriceValueForPet = require(script.Parent.GetPriceValueForPet);
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Directory.PetRegistry);

return function(p1) -- Line: 12
    -- upvalues: Asserts (copy), GetPriceValueForPet (copy)
    Asserts.Tool(p1);
    local v2 = p1:GetAttribute("PetType");
    local v3 = p1:GetAttribute("BaseWeight");
    local v4 = p1:GetAttribute("Scale");
    local v5 = p1:GetAttribute("Age");
    local v6 = p1:GetAttribute("Level");

    return not (v2 and (v3 and v4)) and 0 or GetPriceValueForPet({
        UUID = p1:GetAttribute("PET_UUID") or "",
        PetType = v2,
        PetData = {
            LevelProgress = 0,
            Age = v5 or 0,
            Level = v6 or 1,
            Name = p1.Name,
            BaseWeight = v3,
            Weight = v4
        }
    });
end;