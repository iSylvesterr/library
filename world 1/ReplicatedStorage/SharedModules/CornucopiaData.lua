-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedPacks = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("SeedPacks");
local CrateShopEnabled = require(ReplicatedStorage.SharedModules.CrateShopEnabled);
local EggData = require(ReplicatedStorage.SharedModules.EggData);
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local SeedShopEnabled = require(ReplicatedStorage.SharedModules.SeedShopEnabled);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);

local function PoolFlag(p1, p2) -- Line: 63
    -- upvalues: FastFlags (copy), Asserts (copy)
    return FastFlags.Replicated(p1, Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), p2);
end;

local u3 = FastFlags.Replicated("Game.Cornucopia.CategoryChances", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Seeds = 55,
    Pets = 15,
    Eggs = 20,
    Crates = 10,
    SeedPacks = 0
});
local u4 = FastFlags.Replicated("Game.Cornucopia.CategoryChancesFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Seeds = 40,
    Pets = 22,
    Eggs = 18,
    Crates = 12,
    SeedPacks = 8
});
local u5 = FastFlags.Replicated("Game.Cornucopia.Seeds", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Baby Cactus"] = 50,
    ["Horned Melon"] = 30,
    ["Glow Mushroom"] = 15,
    ["Poison Ivy"] = 4,
    ["Ghost Pepper"] = 1
});
local u6 = FastFlags.Replicated("Game.Cornucopia.SeedsFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Maple Mushroom"] = 40,
    ["Maple Grape"] = 30,
    ["Maple Apple"] = 20,
    Potato = 40,
    Honeysuckle = 8.33,
    Romanesco = 6,
    ["Cinnamon Stick"] = 6,
    Plum = 2.67,
    ["Atlantic Giant Pumpkin"] = 2,
    ["Amber Cranberry"] = 0.33
});
local u7 = FastFlags.Replicated("Game.Cornucopia.Pets", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Frog = 30,
    Bunny = 30,
    Owl = 25,
    Deer = 20,
    Turtle = 17.5
});
local u8 = FastFlags.Replicated("Game.Cornucopia.PetsFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    Dog = 35,
    Turkey = 25,
    Hedgehog = 20,
    Squirrel = 12,
    Swan = 6,
    Fox = 2,
    ShadowDragon = 0.15
});
local u9 = FastFlags.Replicated("Game.Cornucopia.Eggs", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Common Egg"] = 60,
    ["Big Egg"] = 30,
    ["Mega Egg"] = 10
});
local u10 = FastFlags.Replicated("Game.Cornucopia.EggsFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Fall Common Egg"] = 62,
    ["Fall Big Egg"] = 25,
    ["Fall Mega Egg"] = 9,
    ["Fall Rainbow Egg"] = 4
});
local u11 = FastFlags.Replicated("Game.Cornucopia.Crates", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Bench Crate"] = 50,
    ["Fence Crate"] = 30,
    ["Light Crate"] = 20
});
local u12 = FastFlags.Replicated("Game.Cornucopia.CratesFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Fall Cosmetic Crate"] = 35,
    ["Lantern Crate"] = 30,
    ["Cobblestone Crate"] = 18,
    ["Fall Structure Crate"] = 14,
    ["Rake Crate"] = 3
});
local u13 = FastFlags.Replicated("Game.Cornucopia.SeedPacks", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {});
local u14 = FastFlags.Replicated("Game.Cornucopia.SeedPacksFallHarvest", Asserts.Map(Asserts.String, Asserts.FiniteNonNegative), {
    ["Common Fall Seed Pack"] = 35,
    ["Uncommon Fall Seed Pack"] = 27,
    ["Rare Fall Seed Pack"] = 20,
    ["Mythic Fall Seed Pack"] = 11,
    ["Legendary Fall Seed Pack"] = 5,
    ["Super Fall Seed Pack"] = 2
});
local u15 = {};

local function SortedNames(p16) -- Line: 181
    local v17 = {};

    for i, v in p16 do
        if type(v) == "number" and v > 0 then
            table.insert(v17, i);
        end;
    end;

    table.sort(v17);

    return v17;
end;

local function WeightedItemsFrom(p18, p19) -- Line: 196
    -- upvalues: SortedNames (copy)
    local v20 = {};

    for _, v in SortedNames(p18) do
        if p19 == nil or p19(v) then
            table.insert(v20, {
                Name = v,
                Chance = p18[v]
            });
        end;
    end;

    return v20;
end;

local function PetItemsFrom(p21) -- Line: 209
    -- upvalues: SortedNames (copy)
    local v22 = {};

    for _, v in SortedNames(p21) do
        table.insert(v22, {
            PetName = v,
            Chance = p21[v]
        });
    end;

    return v22;
end;

local function IsFall() -- Line: 217
    -- upvalues: Worlds (copy)
    return Worlds.CurrentId == "FallHarvest";
end;

local function BuildEntry() -- Line: 222
    -- upvalues: Worlds (copy), u4 (copy), u3 (copy), SeedPacks (copy), WeightedItemsFrom (copy), u6 (copy), u5 (copy), SeedShopEnabled (copy), PetItemsFrom (copy), u8 (copy), u7 (copy), u10 (copy), u9 (copy), u12 (copy), u11 (copy), CrateShopEnabled (copy), u14 (copy), u13 (copy)
    local v23 = Worlds.CurrentId == "FallHarvest";
    local v24;

    if v23 then
        v24 = u4:Get();
    else
        v24 = u3:Get();
    end;

    local v25 = {
        Name = "Cornucopia",
        IMG = "rbxassetid://135212281437965",
        OpensCount = 5,
        RainbowChance = 0.5,
        Model = SeedPacks:FindFirstChild("Cornucopia"),
        CategoryChances = {
            Seeds = v24.Seeds or 0,
            Pets = v24.Pets or 0,
            Eggs = v24.Eggs or 0,
            Crates = v24.Crates or 0,
            SeedPacks = v24.SeedPacks or 0
        }
    };
    local v26;

    if v23 then
        v26 = u6:Get();
    else
        v26 = u5:Get();
    end;

    v25.Seeds = WeightedItemsFrom(v26, SeedShopEnabled.IsSeedReleased);
    local v27;

    if v23 then
        v27 = u8:Get();
    else
        v27 = u7:Get();
    end;

    v25.Pets = PetItemsFrom(v27);
    local v28;

    if v23 then
        v28 = u10:Get();
    else
        v28 = u9:Get();
    end;

    v25.Eggs = WeightedItemsFrom(v28);
    local v29;

    if v23 then
        v29 = u12:Get();
    else
        v29 = u11:Get();
    end;

    v25.Crates = WeightedItemsFrom(v29, CrateShopEnabled.IsCrateEnabled);
    local v30;

    if v23 then
        v30 = u14:Get();
    else
        v30 = u13:Get();
    end;

    v25.SeedPacks = WeightedItemsFrom(v30);

    return v25;
end;

u15.Data = { (BuildEntry()) };

function u15.GetData(p31) -- Line: 266
    -- upvalues: BuildEntry (copy)
    local v32 = BuildEntry();

    if v32.Name == p31 then
        return v32;
    end;

    return nil;
end;

local function WeightedPick(p33) -- Line: 276
    if not p33 or #p33 == 0 then
        return nil;
    end;

    local v34 = 0;

    for _, v in p33 do
        v34 = v34 + v.Chance;
    end;

    if v34 <= 0 then
        return p33[#p33];
    end;

    local v35 = math.random() * v34;
    local v36 = 0;

    for _, v in p33 do
        v36 = v36 + v.Chance;

        if v35 <= v36 then
            return v;
        end;
    end;

    return p33[#p33];
end;

local function PickCategory(u37) -- Line: 305
    local CategoryChances = u37.CategoryChances;
    local v38 = { "Seeds", "Pets", "Eggs", "Crates", "SeedPacks" };

    local function poolSize(p39) -- Line: 309
        -- upvalues: u37 (copy)
        return p39 == "Seeds" and #u37.Seeds or (p39 == "Pets" and #u37.Pets or (p39 == "Eggs" and #u37.Eggs or (p39 == "Crates" and #u37.Crates or #(u37.SeedPacks or {}))));
    end;

    local v40 = {};
    local v41 = 0;

    for _, v in v38 do
        local v42 = CategoryChances[v] or 0;

        if v42 > 0 and poolSize(v) > 0 then
            table.insert(v40, v);
            v41 = v41 + v42;
        end;
    end;

    if v41 <= 0 then
        for _, v in v38 do
            if poolSize(v) > 0 then
                return v;
            end;
        end;

        return nil;
    end;

    local v43 = math.random() * v41;
    local v44 = 0;

    for _, v in v40 do
        v44 = v44 + (CategoryChances[v] or 0);

        if v43 <= v44 then
            return v;
        end;
    end;

    return v40[#v40];
end;

local function BuildPetPool(p45) -- Line: 350
    local v46 = {};

    for _, v in p45 do
        table.insert(v46, {
            PetName = v.PetName,
            Chance = v.Chance
        });
        table.insert(v46, {
            Big = true,
            PetName = v.PetName,
            Chance = v.Chance * 0.02
        });
        table.insert(v46, {
            Huge = true,
            PetName = v.PetName,
            Chance = v.Chance * 0.001
        });
    end;

    return v46;
end;

function u15.RollOne(p47) -- Line: 362
    -- upvalues: u15 (copy), PickCategory (copy), BuildPetPool (copy), EggData (copy), WeightedPick (copy)
    local v48 = u15.GetData(p47);

    if not v48 then
        return nil;
    end;

    local v49 = PickCategory(v48);

    if not v49 then
        return nil;
    end;

    if v49 == "Pets" then
        local v50 = BuildPetPool(v48.Pets);
        local v51 = EggData.RollFromPool(v50, v48.RainbowChance);

        if v51 then
            return {
                Category = "Pets",
                ItemName = v51.PetName,
                Size = v51.Size,
                Type = v51.Type
            };
        end;

        v49 = "Seeds";
    end;

    local v52;

    if v49 == "Seeds" then
        v52 = v48.Seeds;
    elseif v49 == "Eggs" then
        v52 = v48.Eggs;
    elseif v49 == "Crates" then
        v52 = v48.Crates;
    elseif v49 == "SeedPacks" then
        v52 = v48.SeedPacks or {};
    else
        v52 = v48.Seeds;
    end;

    local v53 = WeightedPick(v52);

    return v53 and {
        Category = v49,
        ItemName = v53.Name
    } or nil;
end;

function u15.RollMany(p54, p55) -- Line: 393
    -- upvalues: u15 (copy)
    local v56 = u15.GetData(p54);

    if not v56 then
        return {};
    end;

    local v57 = {};

    for _ = 1, p55 or (v56.OpensCount or 1) do
        local v58 = u15.RollOne(p54);

        if v58 then
            table.insert(v57, v58);
        end;
    end;

    return v57;
end;

return u15;