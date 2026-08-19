-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local CrateData = require(ReplicatedStorage.SharedModules.CrateData);
local EggData = require(ReplicatedStorage.SharedModules.EggData);
local SeedPackData = require(ReplicatedStorage.SharedModules.SeedPackData);
local GearShopData = require(ReplicatedStorage.SharedModules.GearShopData);
local u1 = {
    RarityRanks = {
        Common = 1,
        Uncommon = 2,
        Rare = 3,
        Epic = 4,
        Legendary = 5,
        Mythic = 6,
        Super = 7,
        Secret = 8
    },
    UnresolvedRank = 99
};
u1.Items = {
    ["Rare Magic Mail"] = {
        Rarity = "Rare",
        DisplayName = "Rare Magic Mail",
        Description = "Mails one Common, Uncommon, or Rare item from Fall Harvest back to Garden Valley. Consumed on send; claim it from your Garden Valley mailbox.",
        MaxSendableRank = u1.RarityRanks.Rare
    },
    ["Legendary Magic Mail"] = {
        Rarity = "Legendary",
        DisplayName = "Legendary Magic Mail",
        Description = "Mails one item up to Legendary rarity from Fall Harvest back to Garden Valley. Consumed on send; claim it from your Garden Valley mailbox.",
        MaxSendableRank = u1.RarityRanks.Legendary
    },
    ["Super Magic Mail"] = {
        Rarity = "Super",
        MaxSendableRank = 99,
        DisplayName = "Super Magic Mail",
        Description = "Mails ANY item from Fall Harvest back to Garden Valley. Consumed on send; claim it from your Garden Valley mailbox."
    }
};
u1.Order = { "Rare Magic Mail", "Legendary Magic Mail", "Super Magic Mail" };
u1.SendableCategories = {
    HarvestedFruits = true,
    Pets = true,
    Seeds = true,
    Sprinklers = true,
    WateringCans = true,
    Mushrooms = true,
    Gnomes = true,
    Raccoons = true,
    Crates = true,
    Teleporters = true,
    Magnets = true,
    SeedPacks = true,
    Wheelbarrows = true,
    Trowels = true,
    Crowbars = true,
    Ladders = true,
    FreezeRays = true,
    Signs = true,
    PowerHoses = true,
    Rakes = true,
    Props = true,
    Eggs = true
};

function u1.Get(p2) -- Line: 102
    -- upvalues: u1 (copy)
    return u1.Items[p2];
end;

local u3 = nil;

local function getSeedRarity(p4) -- Line: 109
    -- upvalues: u3 (ref), SeedData (copy)
    if not u3 then
        local v5 = {};

        for _, v in SeedData do
            if type(v) == "table" and (type(v.SeedName) == "string" and type(v.Rarity) == "string") then
                v5[v.SeedName] = v.Rarity;
            end;
        end;

        u3 = v5;
    end;

    return u3[p4];
end;

local u6 = nil;

local function getGearRarity(p7) -- Line: 125
    -- upvalues: u6 (ref), GearShopData (copy)
    if not u6 then
        local v8 = {};

        for _, v in GearShopData.Data do
            if type(v) == "table" and (type(v.ItemName) == "string" and type(v.Rarity) == "string") then
                v8[v.ItemName] = v.Rarity;
            end;
        end;

        u6 = v8;
    end;

    return u6[p7];
end;

local v9 = nil;
local SharedData = ReplicatedStorage:FindFirstChild("SharedData");

if SharedData then
    SharedData = SharedData:FindFirstChild("PetData");
end;

local u10;

if SharedData and SharedData:IsA("ModuleScript") then
    local v11;
    v11, u10 = pcall(require, SharedData);

    if not v11 then
        u10 = v9;
    end;
else
    u10 = v9;
end;

function u1.ResolveRarity(p12, p13, p14) -- Line: 156
    -- upvalues: getSeedRarity (copy), u10 (ref), CrateData (copy), EggData (copy), SeedPackData (copy), getGearRarity (copy)
    if p12 == "Seeds" then
        return getSeedRarity(p13);
    end;

    if p12 == "HarvestedFruits" then
        return getSeedRarity(p14 or p13);
    end;

    if p12 == "Pets" then
        local v15 = p14 or p13;

        if type(u10) == "table" then
            local v16 = u10[v15];

            if type(v16) == "table" and type(v16.Rarity) == "string" then
                return v16.Rarity;
            end;
        end;

        return nil;
    end;

    if p12 == "Crates" then
        local v17 = CrateData.GetData(p13);

        if type(v17) == "table" and type(v17.Rarity) == "string" then
            return v17.Rarity;
        end;

        return nil;
    end;

    if p12 == "Eggs" then
        local v18 = EggData.GetData(p13);

        if v18 and type(v18.Rarity) == "string" then
            return v18.Rarity;
        end;

        return nil;
    end;

    if p12 ~= "SeedPacks" then
        return getGearRarity(p13);
    end;

    local v19 = SeedPackData.GetData(p13);

    if type(v19) == "table" and type(v19.Rarity) == "string" then
        return v19.Rarity;
    end;

    return nil;
end;

function u1.ResolveRank(p20, p21, p22) -- Line: 194
    -- upvalues: u1 (copy)
    local v23 = u1.ResolveRarity(p20, p21, p22);

    return v23 == nil and 99 or (u1.RarityRanks[v23] or 99);
end;

return u1;