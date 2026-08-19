-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Eggs = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Eggs");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local PetGating = require(ReplicatedStorage.SharedModules.PetGating);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local u1 = FastFlags.Replicated("Game.Eggs.RainbowChanceMultiplier", Asserts.FiniteNonNegative, 1);
local u2 = FastFlags.Replicated("Game.Eggs.BigChanceMultiplier", Asserts.FiniteNonNegative, 1);
local u3 = FastFlags.Replicated("Game.Eggs.HugeChanceMultiplier", Asserts.FiniteNonNegative, 1);
local u4 = FastFlags.Replicated("Game.Eggs.PetWeightMultipliers", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Mythic = 0.25,
    Super = 0.25,
    Secret = 0.25
});
local u5 = FastFlags.Replicated("Game.Eggs.SpeciesWeightMultipliers", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {});

local function isAvailableHere(p6) -- Line: 37
    -- upvalues: PetData (copy), Worlds (copy)
    local v7 = PetData[p6];

    return type(v7) ~= "table" and true or Worlds.EntryAvailableHere(v7);
end;

local function isEligible(p8, p9) -- Line: 55
    -- upvalues: PetGating (copy), PetData (copy), Worlds (copy)
    if p9 then
        return PetGating.IsAcquirableFromOwnWorld(p8);
    end;

    local v10 = PetData[p8];
    local v11 = (type(v10) ~= "table" and true or Worlds.EntryAvailableHere(v10)) and PetGating.IsAcquirable(p8);

    return v11;
end;

local function lastAvailable(p12, p13) -- Line: 65
    -- upvalues: PetGating (copy), PetData (copy), Worlds (copy)
    for i = #p12, 1, -1 do
        local PetName = p12[i].PetName;
        local v14;

        if p13 then
            v14 = PetGating.IsAcquirableFromOwnWorld(PetName);
        else
            local v15 = PetData[PetName];
            v14 = (type(v15) ~= "table" and true or Worlds.EntryAvailableHere(v15)) and PetGating.IsAcquirable(PetName);
        end;

        if v14 then
            return p12[i];
        end;
    end;

    return nil;
end;

local function getPetWeightMultiplier(p16, p17) -- Line: 77
    -- upvalues: PetGating (copy), PetData (copy), Worlds (copy), u4 (copy), u5 (copy), u3 (copy), u2 (copy)
    local PetName = p16.PetName;
    local v18;

    if p17 then
        v18 = PetGating.IsAcquirableFromOwnWorld(PetName);
    else
        local v19 = PetData[PetName];
        v18 = (type(v19) ~= "table" and true or Worlds.EntryAvailableHere(v19)) and PetGating.IsAcquirable(PetName);
    end;

    if not v18 then
        return 0;
    end;

    local v20 = PetData[p16.PetName];
    local v21 = (not v20 or type(v20.Rarity) ~= "string") and "Common" or v20.Rarity;
    local v22 = (u4:Get()[v21] or 1) * (u5:Get()[p16.PetName] or 1);

    if p16.Huge then
        return v22 * u3:Get();
    end;

    if p16.Big then
        v22 = v22 * u2:Get();
    end;

    return v22;
end;

local u23 = {};
local v24 = { {
        PetName = "Frog",
        Chance = 30
    }, {
        PetName = "Bunny",
        Chance = 30
    }, {
        PetName = "Owl",
        Chance = 25
    }, {
        PetName = "Deer",
        Chance = 20
    }, {
        PetName = "Turtle",
        Chance = 17.5
    }, {
        PetName = "Robin",
        Chance = 4.5
    }, {
        PetName = "Bee",
        Chance = 4.5
    }, {
        PetName = "Unicorn",
        Chance = 0.3
    }, {
        PetName = "GoldenDragonfly",
        Chance = 0.3
    }, {
        PetName = "Monkey",
        Chance = 0.3
    }, {
        PetName = "JandelMonkey",
        Chance = 0.3
    }, {
        PetName = "Bear",
        Chance = 0.3
    }, {
        PetName = "Dog",
        Chance = 0.3
    }, {
        PetName = "Firefly",
        Chance = 0.3
    }, {
        PetName = "Raccoon",
        Chance = 0.2
    } };
u23.CommonBaseSpecies = v24;

local function derivePool(p25, p26, p27) -- Line: 171
    local v28 = table.create(#p25);

    for _, v in p25 do
        local v29 = {
            PetName = v.PetName,
            Chance = v.Chance * p26
        };

        if p27 == "Mega" then
            v29.Huge = true;
        elseif p27 == "Big" then
            v29.Big = true;
        end;

        table.insert(v28, v29);
    end;

    return v28;
end;

local function mergePools(...) -- Line: 186
    local v30 = {};

    for _, v in { ... } do
        for _, v2 in v do
            table.insert(v30, v2);
        end;
    end;

    return v30;
end;

local v31 = mergePools(derivePool(v24, 1), derivePool(v24, 0.02, "Big"), (derivePool(v24, 0.001, "Huge")));
local v32 = { {
        PetName = "Dog",
        Chance = 30
    }, {
        PetName = "Turkey",
        Chance = 22
    }, {
        PetName = "Hedgehog",
        Chance = 22
    }, {
        PetName = "Fox",
        Chance = 16
    }, {
        PetName = "Squirrel",
        Chance = 12
    }, {
        PetName = "Swan",
        Chance = 8
    }, {
        PetName = "Wolf",
        Chance = 8
    }, {
        PetName = "ShadowDragon",
        Chance = 0.0524
    } };
local v33 = mergePools(derivePool(v32, 1), derivePool(v32, 0.02, "Big"), (derivePool(v32, 0.001, "Huge")));
u23.Data = {
    {
        EggName = "Common Egg",
        Rarity = "Common",
        IMG = "rbxassetid://126687482540593",
        RainbowChance = 0.5,
        Model = Eggs:WaitForChild("Common Egg"),
        Worlds = { "Main" },
        Pets = v31
    },
    {
        EggName = "Test Egg",
        Rarity = "Common",
        IMG = "rbxassetid://126687482540593",
        RainbowChance = 0.5,
        Model = Eggs:WaitForChild("Common Egg"),
        Worlds = { "Main" },
        Pets = { {
                PetName = "Frog",
                Chance = 10
            }, {
                PetName = "Frog",
                Chance = 10,
                Big = true
            }, {
                PetName = "Frog",
                Chance = 10,
                Huge = true
            } }
    },
    {
        EggName = "Big Egg",
        Rarity = "Mythic",
        IMG = "rbxassetid://139701076502420",
        RainbowChance = 0.5,
        Model = Eggs:WaitForChild("Big Egg"),
        Worlds = { "Main" },
        Pets = derivePool(v24, 1, "Big")
    },
    {
        EggName = "Mega Egg",
        Rarity = "Super",
        IMG = "rbxassetid://118018636650710",
        RainbowChance = 0.5,
        Model = Eggs:WaitForChild("Mega Egg"),
        Worlds = { "Main" },
        Pets = derivePool(v24, 1, "Mega")
    },
    {
        EggName = "Rainbow Egg",
        Rarity = "Super",
        IMG = "rbxassetid://80085205883233",
        RainbowChance = 100,
        Model = Eggs:WaitForChild("Rainbow Egg"),
        Worlds = { "Main" },
        Pets = derivePool(v24, 1)
    },
    {
        EggName = "Fall Common Egg",
        Rarity = "Common",
        IMG = "rbxassetid://121496937465932",
        RainbowChance = 0.5,
        PoolIgnoresWorld = true,
        Model = Eggs:WaitForChild("Fall Common Egg"),
        Worlds = { "FallHarvest" },
        Pets = v33
    },
    {
        EggName = "Fall Big Egg",
        Rarity = "Mythic",
        IMG = "rbxassetid://84815791424113",
        RainbowChance = 0.5,
        PoolIgnoresWorld = true,
        Model = Eggs:WaitForChild("Fall Big Egg"),
        Worlds = { "FallHarvest" },
        Pets = derivePool(v32, 1, "Big")
    },
    {
        EggName = "Fall Mega Egg",
        Rarity = "Super",
        IMG = "rbxassetid://90593172825213",
        RainbowChance = 0.5,
        PoolIgnoresWorld = true,
        Model = Eggs:WaitForChild("Fall Mega Egg"),
        Worlds = { "FallHarvest" },
        Pets = derivePool(v32, 1, "Mega")
    },
    {
        EggName = "Fall Rainbow Egg",
        Rarity = "Super",
        IMG = "rbxassetid://80085205883233",
        RainbowChance = 100,
        PoolIgnoresWorld = true,
        Model = Eggs:WaitForChild("Fall Rainbow Egg"),
        Worlds = { "FallHarvest" },
        Pets = derivePool(v32, 1)
    }
};

function u23.GetData(p34) -- Line: 383
    -- upvalues: u23 (copy)
    for _, v in u23.Data do
        if v.EggName == p34 then
            return v;
        end;
    end;

    return nil;
end;

function u23.GetRandomPet(p35) -- Line: 394
    -- upvalues: u23 (copy), getPetWeightMultiplier (copy), lastAvailable (copy)
    local v36 = u23.GetData(p35);

    if not v36 then
        return nil;
    end;

    if not v36.Pets or #v36.Pets == 0 then
        return nil;
    end;

    local v37 = v36.PoolIgnoresWorld == true;
    local v38 = 0;

    for _, v in v36.Pets do
        v38 = v38 + v.Chance * getPetWeightMultiplier(v, v37);
    end;

    if v38 <= 0 then
        return lastAvailable(v36.Pets, v37);
    end;

    local v39 = math.random() * v38;
    local v40 = 0;

    for _, v in v36.Pets do
        v40 = v40 + v.Chance * getPetWeightMultiplier(v, v37);

        if v39 <= v40 then
            return v;
        end;
    end;

    return lastAvailable(v36.Pets, v37);
end;

function u23.RollRainbow(p41) -- Line: 426
    -- upvalues: u23 (copy), u1 (copy)
    local v42 = u23.GetData(p41);
    local v43 = (v42 and v42.RainbowChance or 0) * u1:Get();

    if v43 <= 0 then
        return false;
    end;

    return math.random() * 100 < v43;
end;

function u23.Roll(p44) -- Line: 434
    -- upvalues: u23 (copy)
    local v45 = u23.GetRandomPet(p44);

    if not v45 then
        return nil;
    end;

    local v46 = v45.Huge and "Huge" or (v45.Big and "Big" or nil);
    local v47 = u23.RollRainbow(p44) and "Rainbow" or nil;

    return {
        PetName = v45.PetName,
        Size = v46,
        Type = v47
    };
end;

function u23.GetRandomPetFromPool(p48) -- Line: 447
    -- upvalues: getPetWeightMultiplier (copy), lastAvailable (copy)
    if not p48 or #p48 == 0 then
        return nil;
    end;

    local v49 = 0;

    for _, v in p48 do
        v49 = v49 + v.Chance * getPetWeightMultiplier(v);
    end;

    if v49 <= 0 then
        return lastAvailable(p48);
    end;

    local v50 = math.random() * v49;
    local v51 = 0;

    for _, v in p48 do
        v51 = v51 + v.Chance * getPetWeightMultiplier(v);

        if v50 <= v51 then
            return v;
        end;
    end;

    return lastAvailable(p48);
end;

function u23.RollFromPool(p52, p53) -- Line: 475
    -- upvalues: u23 (copy), u1 (copy)
    local v54 = u23.GetRandomPetFromPool(p52);

    if not v54 then
        return nil;
    end;

    local v55 = v54.Huge and "Huge" or (v54.Big and "Big" or nil);
    local v56 = (p53 or 0) * u1:Get();
    local v57 = v56 > 0 and math.random() * 100 < v56 and "Rainbow" or nil;

    return {
        PetName = v54.PetName,
        Size = v55,
        Type = v57
    };
end;

return u23;