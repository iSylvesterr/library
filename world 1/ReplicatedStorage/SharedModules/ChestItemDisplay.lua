-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local PropData = require(ReplicatedStorage.SharedModules.PropData);
local FenceData = require(ReplicatedStorage.SharedModules.FenceData);
local GearShopData = require(ReplicatedStorage.SharedModules.GearShopData);
local SeedPackData = require(ReplicatedStorage.SharedModules.SeedPackData);
local RakeData = require(ReplicatedStorage.SharedModules.RakeData);
local EggData = require(ReplicatedStorage.SharedModules.EggData);
local CrateData = require(ReplicatedStorage.SharedModules.CrateData);
local ChestData = require(ReplicatedStorage.SharedModules.ChestData);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;

local function EnsureMaps() -- Line: 29
    -- upvalues: u2 (ref), PropData (copy), FenceData (copy), u3 (ref), GearShopData (copy), u4 (ref), SeedPackData (copy), u5 (ref), RakeData (copy), u6 (ref), EggData (copy), u7 (ref), u8 (ref), u9 (ref)
    if u2 then
        return;
    end;

    u2 = {};

    for _, v in PropData.Data do
        u2[v.PropName] = v.IMG;
    end;

    for _, v in FenceData.Data do
        u2[v.PropName] = v.IMG;
    end;

    u3 = {};

    for _, v in GearShopData.Data do
        u3[v.ItemName] = v.IMG;
    end;

    u4 = {};

    for _, v in SeedPackData.Data do
        u4[v.PackName] = v.IMG;
    end;

    u5 = {};

    for _, v in RakeData do
        u5[v.RakeName] = v.Image;
    end;

    u6 = {};

    for _, v in EggData.Data do
        u6[v.EggName] = v.IMG;
    end;

    u7 = {};

    for _, v in GearShopData.Data do
        u7[v.ItemName] = v.Rarity;
    end;

    u8 = {};

    for _, v in SeedPackData.Data do
        u8[v.PackName] = v.Rarity;
    end;

    u9 = {};

    for _, v in EggData.Data do
        u9[v.EggName] = v.Rarity;
    end;
end;

local function ResolveSeedPackImage(p10) -- Line: 87
    -- upvalues: u4 (ref), SeedPackData (copy)
    local v11 = u4[p10];

    if v11 then
        return v11;
    end;

    local v12 = SeedPackData.LocalizePackName(p10);

    return v12 and u4[v12] or "";
end;

function v1.Image(p13) -- Line: 99
    -- upvalues: EnsureMaps (copy), PetData (copy), u3 (ref), u2 (ref), u4 (ref), SeedPackData (copy), u5 (ref), u6 (ref), CrateData (copy), ChestData (copy)
    if p13.IMG then
        return p13.IMG;
    end;

    EnsureMaps();

    if p13.IsPet then
        return PetData.GetImage(p13.Name) or "";
    end;

    if p13.RewardType == "Gear" then
        return u3[p13.Name] or u2[p13.Name] or "";
    end;

    if p13.RewardType == "SeedPack" then
        local Name = p13.Name;
        local v14 = u4[Name];

        if v14 then
            return v14;
        end;

        local v15 = SeedPackData.LocalizePackName(Name);

        return v15 and u4[v15] or "";
    end;

    if p13.RewardType == "Rake" then
        return u5[p13.Name] or "";
    end;

    if p13.RewardType == "Egg" then
        return u6[p13.Name] or "";
    end;

    if p13.RewardType == "Crate" then
        local v16 = CrateData.GetData(p13.Name);

        return v16 and v16.IMG or "";
    end;

    if p13.RewardType ~= "Chest" then
        return u2[p13.Name] or "";
    end;

    local v17 = ChestData.GetData(p13.Name);

    return v17 and v17.IMG or "";
end;

function v1.Name(p18) -- Line: 137
    -- upvalues: PetData (copy), SeedPackData (copy)
    if p18.IsPet then
        return PetData.GetSpeciesDisplayName(p18.Name) or p18.Name;
    end;

    if p18.RewardType == "SeedPack" then
        return SeedPackData.LocalizePackName(p18.Name) or p18.Name;
    end;

    return p18.Name;
end;

function v1.Rarity(p19) -- Line: 153
    -- upvalues: EnsureMaps (copy), PetData (copy), u7 (ref), u8 (ref), SeedPackData (copy), u9 (ref), CrateData (copy), ChestData (copy)
    if p19.Rarity then
        return p19.Rarity;
    end;

    EnsureMaps();

    if p19.IsPet then
        local v20 = PetData[p19.Name];

        return v20 and v20.Rarity or nil;
    end;

    if p19.RewardType == "Gear" then
        return u7[p19.Name];
    end;

    if p19.RewardType == "SeedPack" then
        local v21 = u8[p19.Name];

        if v21 then
            return v21;
        end;

        local v22 = SeedPackData.LocalizePackName(p19.Name);

        return v22 and u8[v22] or nil;
    end;

    if p19.RewardType == "Egg" then
        return u9[p19.Name];
    end;

    if p19.RewardType == "Crate" then
        local v23 = CrateData.GetData(p19.Name);

        if v23 then
            v23 = v23.Rarity;
        end;

        return v23;
    end;

    if p19.RewardType ~= "Chest" then
        return nil;
    end;

    local v24 = ChestData.GetData(p19.Name);

    if v24 then
        v24 = v24.Rarity;
    end;

    return v24;
end;

return v1;