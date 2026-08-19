-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local u1 = {
    Turtle = true,
    Butterfly = true,
    BaldEagle = true,
    Firefly = true,
    Turkey = true,
    Dog = true,
    Squirrel = true,
    Hedgehog = true,
    Wolf = true,
    Fox = true,
    ShadowDragon = true,
    Swan = true,
    JandelMonkey = true
};
local u2 = FastFlags.Replicated("Game.Pets.AcquisitionEnabled", Asserts.Map(Asserts.String, Asserts.Boolean), {});
local u3 = {};

local function exclusiveWorldId(p4) -- Line: 62
    -- upvalues: PetData (copy)
    local v5 = PetData[p4];

    if type(v5) ~= "table" then
        return nil;
    end;

    local Worlds2 = v5.Worlds;

    if type(Worlds2) ~= "table" or #Worlds2 ~= 1 then
        return nil;
    end;

    local v6 = Worlds2[1];

    if v6 == "Main" then
        return nil;
    end;

    return v6;
end;

local function isExclusiveToThisWorld(p7) -- Line: 76
    -- upvalues: PetData (copy), Worlds (copy)
    local v8 = PetData[p7];
    local v9;

    if type(v8) == "table" then
        local Worlds2 = v8.Worlds;

        if type(Worlds2) == "table" and #Worlds2 == 1 then
            v9 = Worlds2[1];

            if v9 == "Main" then
                v9 = nil;
            end;
        else
            v9 = nil;
        end;
    else
        v9 = nil;
    end;

    return v9 == Worlds.CurrentId;
end;

function u3.IsAcquirable(p10) -- Line: 82
    -- upvalues: u1 (copy), PetData (copy), Worlds (copy), u2 (copy)
    if not u1[p10] then
        return true;
    end;

    local v11 = PetData[p10];
    local v12;

    if type(v11) == "table" then
        local Worlds2 = v11.Worlds;

        if type(Worlds2) == "table" and #Worlds2 == 1 then
            v12 = Worlds2[1];

            if v12 == "Main" then
                v12 = nil;
            end;
        else
            v12 = nil;
        end;
    else
        v12 = nil;
    end;

    return v12 == Worlds.CurrentId and true or u2:Get()[p10] == true;
end;

function u3.IsAcquirableFromOwnWorld(p13) -- Line: 97
    -- upvalues: u3 (copy), PetData (copy), Worlds (copy)
    if u3.IsAcquirable(p13) then
        return true;
    end;

    local v14 = PetData[p13];
    local v15;

    if type(v14) == "table" then
        local Worlds2 = v14.Worlds;

        if type(Worlds2) == "table" and #Worlds2 == 1 then
            v15 = Worlds2[1];

            if v15 == "Main" then
                v15 = nil;
            end;
        else
            v15 = nil;
        end;
    else
        v15 = nil;
    end;

    local v16;

    if v15 == nil then
        v16 = false;
    else
        v16 = Worlds.GetPlaceId(v15) ~= nil;
    end;

    return v16;
end;

return table.freeze(u3);