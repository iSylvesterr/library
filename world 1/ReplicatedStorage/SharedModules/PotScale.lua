-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local u1 = nil;

local function BuildOverrides() -- Line: 23
    -- upvalues: SeedData (copy)
    local v2 = {};

    for _, v in SeedData do
        local PotScale = v.PotScale;

        if type(PotScale) == "number" and PotScale > 0 then
            v2[v.SeedName] = PotScale;
        end;
    end;

    return v2;
end;

return table.freeze({
    Get = function(p3) -- Line: 37, Name: Get
        -- upvalues: u1 (ref), BuildOverrides (copy)
        if type(p3) ~= "string" then
            return 1;
        end;

        local v4 = u1;

        if not v4 then
            v4 = BuildOverrides();
            u1 = v4;
        end;

        return v4[p3] or 1;
    end
});