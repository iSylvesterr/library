-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local CrateData = require(ReplicatedStorage.SharedModules.CrateData);
local EggData = require(ReplicatedStorage.SharedModules.EggData);
local SeedPackData = require(ReplicatedStorage.SharedModules.SeedPackData);
local ImageAssetId = require(ReplicatedStorage.SharedModules.ImageAssetId);
local GuildFeedData = require(ReplicatedStorage.SharedModules.GuildFeedData);
local SeedShopEnabled = require(ReplicatedStorage.SharedModules.SeedShopEnabled);
local CrateShopEnabled = require(ReplicatedStorage.SharedModules.CrateShopEnabled);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local u1 = {
    Categories = { "Seeds", "Crates", "Eggs", "SeedPacks" },
    CategoryLabels = {
        Seeds = "Seeds",
        Crates = "Crates",
        Eggs = "Eggs",
        SeedPacks = "Packs"
    },
    IncludedItems = {
        Seeds = {
            ["Baby Cactus"] = true,
            ["Horned Melon"] = true,
            ["Glow Mushroom"] = true,
            ["Poison Ivy"] = true,
            ["Ghost Pepper"] = true,
            ["Rocket Pop"] = true
        },
        Crates = {
            ["Fourth Of July Crate"] = true
        },
        Eggs = {},
        SeedPacks = {}
    }
};

local function IsForceIncluded(p2, p3) -- Line: 54
    -- upvalues: u1 (copy)
    local v4 = u1.IncludedItems[p2];
    local v5;

    if v4 == nil then
        v5 = false;
    else
        v5 = v4[p3] == true;
    end;

    return v5;
end;

local function ResolveImage(u6) -- Line: 60
    -- upvalues: ImageAssetId (copy)
    if typeof(u6) ~= "string" or u6 == "" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 64
        -- upvalues: ImageAssetId (ref), u6 (copy)
        return ImageAssetId.ResolveForDisplay(u6);
    end);

    return success and result and result or u6;
end;

local SeedImages = ReplicatedStorage.SharedModules.SeedData:FindFirstChild("SeedImages");
ReplicatedStorage.SharedModules.SeedData:FindFirstChild("FruitImages");
local PlantImages = ReplicatedStorage.SharedModules.SeedData:FindFirstChild("PlantImages");

local function SeedImage(p7) -- Line: 75
    -- upvalues: SeedImages (copy), PlantImages (copy)
    local v8 = SeedImages and SeedImages:FindFirstChild(p7) or PlantImages and PlantImages:FindFirstChild(p7);

    if v8 and (v8:IsA("StringValue") and v8.Value ~= "") then
        return v8.Value;
    end;

    return nil;
end;

local function BuildSeeds() -- Line: 85
    -- upvalues: SeedData (copy), Worlds (copy), SeedShopEnabled (copy), u1 (copy), SeedImages (copy), PlantImages (copy)
    local v9 = {};

    for _, v in ipairs(SeedData) do
        local SeedName = v.SeedName;

        if Worlds.EntryAvailableHere(v) then
            local v10;

            if v.RestockShop == true then
                v10 = SeedShopEnabled.IsSeedEnabled(SeedName);
            else
                v10 = false;
            end;

            if SeedName then
                local v11, v12, v13;

                if v10 then
                    v11 = {
                        Category = "Seeds",
                        ItemKey = SeedName,
                        DisplayName = SeedName
                    };
                    v12 = SeedImages and SeedImages:FindFirstChild(SeedName) or PlantImages and PlantImages:FindFirstChild(SeedName);

                    if v12 and (v12:IsA("StringValue") and v12.Value ~= "") then
                        v13 = v12.Value;
                    else
                        v13 = nil;
                    end;

                    v11.Image = v13;
                    table.insert(v9, v11);
                else
                    local Seeds = u1.IncludedItems.Seeds;
                    local v14;

                    if Seeds == nil then
                        v14 = false;
                    else
                        v14 = Seeds[SeedName] == true;
                    end;

                    if v14 then
                        v11 = {
                            Category = "Seeds",
                            ItemKey = SeedName,
                            DisplayName = SeedName
                        };
                        v12 = SeedImages and SeedImages:FindFirstChild(SeedName) or PlantImages and PlantImages:FindFirstChild(SeedName);

                        if v12 and (v12:IsA("StringValue") and v12.Value ~= "") then
                            v13 = v12.Value;
                        else
                            v13 = nil;
                        end;

                        v11.Image = v13;
                        table.insert(v9, v11);
                    end;
                end;
            end;
        end;
    end;

    return v9;
end;

local function BuildCrates() -- Line: 106
    -- upvalues: CrateData (copy), Worlds (copy), CrateShopEnabled (copy), u1 (copy)
    local v15 = {};
    local success, result = pcall(CrateData.GetAllCrates);

    if not success or typeof(result) ~= "table" then
        return v15;
    end;

    for _, v in pairs(result) do
        if typeof(v) == "table" and (v.Name and Worlds.EntryAvailableHere(v)) then
            local v16;

            if v.CrateType == "Prop" then
                v16 = CrateShopEnabled.IsCrateEnabled(v.Name);
            else
                v16 = false;
            end;

            if v16 then
                table.insert(v15, {
                    Category = "Crates",
                    ItemKey = v.Name,
                    DisplayName = v.Name,
                    Image = v.IMG
                });
            else
                local Name = v.Name;
                local Crates = u1.IncludedItems.Crates;
                local v17;

                if Crates == nil then
                    v17 = false;
                else
                    v17 = Crates[Name] == true;
                end;

                if v17 then
                    table.insert(v15, {
                        Category = "Crates",
                        ItemKey = v.Name,
                        DisplayName = v.Name,
                        Image = v.IMG
                    });
                end;
            end;
        end;
    end;

    return v15;
end;

local function BuildEggs() -- Line: 130
    -- upvalues: EggData (copy), Worlds (copy)
    local v18 = {};

    for _, v in ipairs(EggData.Data) do
        if typeof(v) == "table" and (v.EggName and Worlds.EntryAvailableHere(v)) then
            table.insert(v18, {
                Category = "Eggs",
                ItemKey = v.EggName,
                DisplayName = v.EggName,
                Image = v.IMG
            });
        end;
    end;

    return v18;
end;

local function BuildSeedPacks() -- Line: 151
    -- upvalues: SeedPackData (copy), Worlds (copy)
    local v19 = {};

    for _, v in ipairs(SeedPackData.Data) do
        if typeof(v) == "table" and (v.PackName and Worlds.EntryAvailableHere(v)) then
            table.insert(v19, {
                Category = "SeedPacks",
                ItemKey = v.PackName,
                DisplayName = v.PackName,
                Image = v.IMG
            });
        end;
    end;

    return v19;
end;

local u20 = nil;

local function BuildAll() -- Line: 174
    -- upvalues: u20 (ref), BuildSeeds (copy), BuildCrates (copy), BuildEggs (copy), BuildSeedPacks (copy)
    if u20 then
        return u20;
    end;

    local v21 = {
        Seeds = BuildSeeds(),
        Crates = BuildCrates(),
        Eggs = BuildEggs(),
        SeedPacks = BuildSeedPacks()
    };
    u20 = v21;

    return v21;
end;

function u1.GetItems(p22) -- Line: 188
    -- upvalues: BuildAll (copy), GuildFeedData (copy)
    local v23 = BuildAll()[p22] or {};
    local ExcludedItems = GuildFeedData.Gifting.ExcludedItems;

    if typeof(ExcludedItems) ~= "table" then
        return v23;
    end;

    local v24 = {};

    for _, v in ipairs(v23) do
        if not ExcludedItems[v.ItemKey] then
            table.insert(v24, v);
        end;
    end;

    return v24;
end;

function u1.GetImageOrFallback(p25) -- Line: 206
    return p25.Image or "";
end;

function u1.GetImageForKey(p26, p27) -- Line: 211
    -- upvalues: BuildAll (copy)
    if not (p26 and p27) then
        return nil;
    end;

    local v28 = BuildAll()[p26];

    if not v28 then
        return nil;
    end;

    for _, v in ipairs(v28) do
        if v.ItemKey == p27 then
            return v.Image;
        end;
    end;

    return nil;
end;

function u1.GetRarityForKey(p29, u30) -- Line: 225
    -- upvalues: SeedData (copy), CrateData (copy), EggData (copy), SeedPackData (copy)
    if not (p29 and u30) then
        return nil;
    end;

    if p29 == "Seeds" then
        for _, v in pairs(SeedData) do
            if typeof(v) == "table" and v.SeedName == u30 then
                return v.Rarity;
            end;
        end;

        return nil;
    end;

    if p29 == "Crates" then
        local success, result = pcall(function() -- Line: 238
            -- upvalues: CrateData (ref), u30 (copy)
            return CrateData.GetData(u30);
        end);

        if success and typeof(result) == "table" then
            return result.Rarity;
        end;

        return nil;
    end;

    if p29 == "Eggs" then
        local success, result = pcall(function() -- Line: 244
            -- upvalues: EggData (ref), u30 (copy)
            return EggData.GetData(u30);
        end);

        if success and typeof(result) == "table" then
            return result.Rarity;
        end;

        return nil;
    end;

    if p29 ~= "SeedPacks" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 250
        -- upvalues: SeedPackData (ref), u30 (copy)
        return SeedPackData.GetData(u30);
    end);

    if success and typeof(result) == "table" then
        return result.Rarity;
    end;

    return nil;
end;

return u1;