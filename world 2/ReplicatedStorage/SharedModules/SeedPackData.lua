-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedPacks = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("SeedPacks");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local SellValueData = require(ReplicatedStorage.SharedModules.SellValueData);
local SeedShopEnabled = require(ReplicatedStorage.SharedModules.SeedShopEnabled);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local u1 = {
    Data = {
        {
            PackName = "Ghost Pepper Pack",
            IMG = "rbxassetid://133021483253462",
            CustomProgressBased = false,
            Model = SeedPacks:WaitForChild("Ghost Pepper Pack"),
            Seeds = { {
                    SeedName = "Baby Cactus",
                    Chance = 50
                }, {
                    SeedName = "Horned Melon",
                    Chance = 30
                }, {
                    SeedName = "Glow Mushroom",
                    Chance = 15
                }, {
                    SeedName = "Poison Ivy",
                    Chance = 4
                }, {
                    SeedName = "Ghost Pepper",
                    Chance = 1
                } },
            Worlds = { "Main" }
        },
        {
            PackName = "Harvest Pack",
            IMG = "rbxassetid://138120954020866",
            CustomProgressBased = false,
            Model = SeedPacks:WaitForChild("Harvest Pack"),
            Seeds = { {
                    SeedName = "Potato",
                    Chance = 45
                }, {
                    SeedName = "Cinnamon Stick",
                    Chance = 30
                }, {
                    SeedName = "Honeysuckle",
                    Chance = 15
                }, {
                    SeedName = "Plum",
                    Chance = 9
                }, {
                    SeedName = "Romanesco",
                    Chance = 1
                } },
            Worlds = { "FallHarvest" }
        },
        {
            PackName = "Common Seed Pack",
            Rarity = "Common",
            IMG = "rbxassetid://115799317193062",
            CustomProgressBased = true,
            TargetPercentile = 0.1,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Common Seed Pack"),
            Worlds = { "Main" }
        },
        {
            PackName = "Uncommon Seed Pack",
            Rarity = "Uncommon",
            IMG = "rbxassetid://95821847618828",
            CustomProgressBased = true,
            TargetPercentile = 0.22,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Uncommon Seed Pack"),
            Worlds = { "Main" }
        },
        {
            PackName = "Rare Seed Pack",
            Rarity = "Rare",
            IMG = "rbxassetid://100209155560487",
            CustomProgressBased = true,
            TargetPercentile = 0.35,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Rare Seed Pack"),
            Worlds = { "Main" }
        },
        {
            PackName = "Mythic Seed Pack",
            Rarity = "Mythic",
            IMG = "rbxassetid://107746478038169",
            CustomProgressBased = true,
            TargetPercentile = 0.5,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Mythic Seed Pack"),
            Worlds = { "Main" }
        },
        {
            PackName = "Legendary Seed Pack",
            Rarity = "Legendary",
            IMG = "rbxassetid://125344445268180",
            CustomProgressBased = true,
            TargetPercentile = 0.65,
            Spread = 0.13,
            Model = SeedPacks:WaitForChild("Legendary Seed Pack"),
            Worlds = { "Main" }
        },
        {
            PackName = "Super Seed Pack",
            Rarity = "Super",
            IMG = "rbxassetid://99496177404475",
            CustomProgressBased = true,
            TargetPercentile = 0.78,
            Spread = 0.13,
            Model = SeedPacks:WaitForChild("Super Seed Pack"),
            Worlds = { "Main" }
        },
        {
            PackName = "Secret Seed Pack",
            Rarity = "Secret",
            IMG = "rbxassetid://113604428669546",
            CustomProgressBased = true,
            TargetPercentile = 0.87,
            Spread = 0.13,
            Model = SeedPacks:WaitForChild("Secret Seed Pack"),
            Worlds = { "Main" }
        },
        {
            PackName = "Common Fall Seed Pack",
            Rarity = "Common",
            IMG = "rbxassetid://81064196385455",
            CustomProgressBased = true,
            TargetPercentile = 0.1,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Common Fall Seed Pack"),
            Worlds = { "FallHarvest" }
        },
        {
            PackName = "Uncommon Fall Seed Pack",
            Rarity = "Uncommon",
            IMG = "rbxassetid://97421812487017",
            CustomProgressBased = true,
            TargetPercentile = 0.22,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Uncommon Fall Seed Pack"),
            Worlds = { "FallHarvest" }
        },
        {
            PackName = "Rare Fall Seed Pack",
            Rarity = "Rare",
            IMG = "rbxassetid://109893344562212",
            CustomProgressBased = true,
            TargetPercentile = 0.35,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Rare Fall Seed Pack"),
            Worlds = { "FallHarvest" }
        },
        {
            PackName = "Mythic Fall Seed Pack",
            Rarity = "Mythic",
            IMG = "rbxassetid://80551769520163",
            CustomProgressBased = true,
            TargetPercentile = 0.5,
            Spread = 0.15,
            Model = SeedPacks:WaitForChild("Mythic Fall Seed Pack"),
            Worlds = { "FallHarvest" }
        },
        {
            PackName = "Legendary Fall Seed Pack",
            Rarity = "Legendary",
            IMG = "rbxassetid://136168387420408",
            CustomProgressBased = true,
            TargetPercentile = 0.65,
            Spread = 0.13,
            Model = SeedPacks:WaitForChild("Legendary Fall Seed Pack"),
            Worlds = { "FallHarvest" }
        },
        {
            PackName = "Super Fall Seed Pack",
            Rarity = "Super",
            IMG = "rbxassetid://77784351643551",
            CustomProgressBased = true,
            TargetPercentile = 0.78,
            Spread = 0.13,
            Model = SeedPacks:WaitForChild("Super Fall Seed Pack"),
            Worlds = { "FallHarvest" }
        },
        {
            PackName = "Secret Fall Seed Pack",
            Rarity = "Secret",
            IMG = "rbxassetid://96404867825312",
            CustomProgressBased = true,
            TargetPercentile = 0.93,
            Spread = 0.11,
            Model = SeedPacks:WaitForChild("Secret Fall Seed Pack"),
            Worlds = { "FallHarvest" }
        }
    }
};

function u1.GetData(p2) -- Line: 236
    -- upvalues: u1 (copy)
    for _, v in u1.Data do
        if v.PackName == p2 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetPackNameForRarity(p3) -- Line: 255
    -- upvalues: u1 (copy), Worlds (copy)
    for _, v in u1.Data do
        if v.Rarity == p3 and Worlds.EntryAvailableHere(v) then
            return v.PackName;
        end;
    end;

    return nil;
end;

function u1.LocalizePackName(p4) -- Line: 272
    -- upvalues: u1 (copy), Worlds (copy)
    local v5 = u1.GetData(p4);

    if v5 == nil then
        return nil;
    end;

    if Worlds.EntryAvailableHere(v5) then
        return p4;
    end;

    local Rarity = v5.Rarity;

    if type(Rarity) == "string" then
        return u1.GetPackNameForRarity(Rarity);
    end;

    return nil;
end;

local function FindSeed(p6) -- Line: 287
    -- upvalues: SeedData (copy)
    for _, v in SeedData do
        if v.SeedName == p6 then
            return v;
        end;
    end;

    return nil;
end;

local function EstimateSeedGeneration(p7) -- Line: 296
    -- upvalues: SellValueData (copy)
    local v8 = SellValueData[p7.SeedName] or 0;

    if p7.IsSingleHarvest then
        return v8;
    end;

    return v8 * 6;
end;

local function PackWorldId(p9) -- Line: 311
    -- upvalues: Worlds (copy)
    local Worlds2 = p9.Worlds;

    if type(Worlds2) == "table" and type(Worlds2[1]) == "string" then
        return Worlds2[1];
    end;

    return Worlds.CurrentId;
end;

local u10 = {};

local function GetSortedEligibleSeeds(p11) -- Line: 324
    -- upvalues: u10 (copy), SeedData (copy), SeedShopEnabled (copy), SellValueData (copy)
    local v12 = u10[p11];

    if v12 then
        return v12;
    end;

    local v13 = {};

    for _, v in SeedData do
        if v.RestockShop and v.SeedName then
            local Worlds2 = v.Worlds;

            if (type(Worlds2) ~= "table" or table.find(Worlds2, p11) ~= nil) and SeedShopEnabled.IsSeedEnabled(v.SeedName) then
                local v14 = {
                    Name = v.SeedName
                };
                local v15 = SellValueData[v.SeedName] or 0;

                if not v.IsSingleHarvest then
                    v15 = v15 * 6;
                end;

                v14.Gen = v15;
                table.insert(v13, v14);
            end;
        end;
    end;

    table.sort(v13, function(p16, p17) -- Line: 351
        if p16.Gen == p17.Gen then
            return p16.Name < p17.Name;
        end;

        return p16.Gen < p17.Gen;
    end);
    local v18 = {};

    for _, v in v13 do
        table.insert(v18, v.Name);
    end;

    u10[p11] = v18;

    return v18;
end;

function u1.GetRandomSeed(p19, p20) -- Line: 379
    -- upvalues: u1 (copy), Worlds (copy), SeedData (copy), SeedShopEnabled (copy), GetSortedEligibleSeeds (copy)
    local v21 = u1.GetData(p19);

    if not v21 then
        return nil;
    end;

    local Worlds2 = v21.Worlds;
    local v22;

    if type(Worlds2) == "table" and type(Worlds2[1]) == "string" then
        v22 = Worlds2[1];
    else
        v22 = Worlds.CurrentId;
    end;

    local v23, v24, v25, v26, v27, v28, v29, v30, v31, v32, v33;

    if not v21.Seeds or #v21.Seeds <= 0 then
        v23 = GetSortedEligibleSeeds(v22);

        if #v23 == 0 then
            return nil;
        end;

        if #v23 == 1 then
            return v23[1];
        end;

        v24 = v21.TargetPercentile or 0.5;
        v25 = v21.Spread or 0.15;

        if p20 and p20 > 0 then
            v24 = math.min(1, v24 + p20);
        end;

        v26 = v25 <= 0 and 0.0001 or v25;
        v27 = #v23;
        v28 = table.create(v27);
        v29 = 0;

        for i = 1, v27 do
            v30 = ((i - 1) / (v27 - 1) - v24) / v26;
            v31 = math.exp(-0.5 * v30 * v30);
            v28[i] = v31;
            v29 = v29 + v31;
        end;

        if v29 <= 0 then
            return v23[v27];
        end;

        v32 = math.random() * v29;
        v33 = 0;

        for i = 1, v27 do
            v33 = v33 + v28[i];

            if v32 <= v33 then
                return v23[i];
            end;
        end;

        return v23[v27];
    end;

    local v34 = {};
    local v35 = 0;

    for _, v in v21.Seeds do
        local SeedName = v.SeedName;

        for _, v2 in SeedData do
            if v2.SeedName == SeedName then
                break;
            end;
        end;

        local v36;

        if v2 == nil then
            v36 = nil;
        else
            v36 = v2.Worlds;
        end;

        if (type(v36) ~= "table" or table.find(v36, v22) ~= nil) and SeedShopEnabled.IsSeedEnabled(v.SeedName) then
            table.insert(v34, v);
            v35 = v35 + v.Chance;
        end;
    end;

    if #v34 > 0 then
        local v37 = math.random() * v35;
        local v38 = 0;

        for _, v in v34 do
            v38 = v38 + v.Chance;

            if v37 <= v38 then
                return v.SeedName;
            end;
        end;

        return v34[#v34].SeedName;
    end;

    v23 = GetSortedEligibleSeeds(v22);

    if #v23 == 0 then
        return nil;
    end;

    if #v23 == 1 then
        return v23[1];
    end;

    v24 = v21.TargetPercentile or 0.5;
    v25 = v21.Spread or 0.15;

    if p20 and p20 > 0 then
        v24 = math.min(1, v24 + p20);
    end;

    v26 = v25 <= 0 and 0.0001 or v25;
    v27 = #v23;
    v28 = table.create(v27);
    v29 = 0;

    for i = 1, v27 do
        v30 = ((i - 1) / (v27 - 1) - v24) / v26;
        v31 = math.exp(-0.5 * v30 * v30);
        v28[i] = v31;
        v29 = v29 + v31;
    end;

    if v29 <= 0 then
        return v23[v27];
    end;

    v32 = math.random() * v29;
    v33 = 0;

    for i = 1, v27 do
        v33 = v33 + v28[i];

        if v32 <= v33 then
            return v23[i];
        end;
    end;

    return v23[v27];
end;

return u1;