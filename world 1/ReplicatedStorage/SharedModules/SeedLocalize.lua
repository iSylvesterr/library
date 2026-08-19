-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local v1 = {};

local function FindSeed(p2) -- Line: 31
    -- upvalues: SeedData (copy)
    for _, v in SeedData do
        if v.SeedName == p2 then
            return v;
        end;
    end;

    return nil;
end;

local function FamilyRoot(p3) -- Line: 41
    local ReskinOf = p3.ReskinOf;

    if type(ReskinOf) == "string" then
        return ReskinOf;
    end;

    return p3.SeedName;
end;

function v1.LocalizeSeedName(p4) -- Line: 49
    -- upvalues: SeedData (copy), Worlds (copy)
    for _, v in SeedData do
        if v.SeedName == p4 then
            break;
        end;
    end;

    if v == nil then
        return nil;
    end;

    if Worlds.EntryAvailableHere(v) then
        return p4;
    end;

    local ReskinOf = v.ReskinOf;

    if type(ReskinOf) ~= "string" then
        ReskinOf = v.SeedName;
    end;

    for _, v in SeedData do
        local ReskinOf2 = v.ReskinOf;

        if type(ReskinOf2) ~= "string" then
            ReskinOf2 = v.SeedName;
        end;

        if ReskinOf2 == ReskinOf and Worlds.EntryAvailableHere(v) then
            return v.SeedName;
        end;
    end;

    return nil;
end;

return v1;