-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = {};

for _, v in require(ReplicatedStorage.SharedModules.SeedData) do
    u1[v.SeedName] = v;
end;

return table.freeze({
    GrowsForever = function(p2) -- Line: 19, Name: GrowsForever
        -- upvalues: u1 (copy)
        if type(p2) ~= "string" then
            return false;
        end;

        local v3 = u1[p2];
        local v4;

        if v3 == nil then
            v4 = false;
        else
            v4 = v3.GrowsForever == true;
        end;

        return v4;
    end,

    WateringImmune = function(p5) -- Line: 26, Name: WateringImmune
        -- upvalues: u1 (copy)
        if type(p5) ~= "string" then
            return false;
        end;

        local v6 = u1[p5];
        local v7;

        if v6 == nil then
            v7 = false;
        else
            v7 = v6.WateringImmune == true;
        end;

        return v7;
    end,

    MutationImmune = function(p8) -- Line: 36, Name: MutationImmune
        -- upvalues: u1 (copy)
        if type(p8) ~= "string" then
            return false;
        end;

        local v9 = u1[p8];
        local v10;

        if v9 == nil then
            v10 = false;
        else
            v10 = v9.MutationImmune == true;
        end;

        return v10;
    end
});