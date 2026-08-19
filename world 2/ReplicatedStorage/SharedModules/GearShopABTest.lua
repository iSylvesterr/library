-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ABTests = require(ReplicatedStorage.UserGenerated.ABTests);
local GearShopFlags = require(ReplicatedStorage.SharedModules.Flags.GearShopFlags);
local u1 = {
    ["Strawberry Sniper"] = true,
    ["Magic Dice"] = true,
    Teleporter = true,
    ["Bull Horn"] = true,
    Harp = true,
    ["Wind Staff"] = true,
    ["Super Magic Mail"] = true,
    ["Legendary Pet Teleporter"] = true,
    ["Mythic Pet Teleporter"] = true,
    ["Super Pet Teleporter"] = true
};

return table.freeze({
    KeyFor = function(p2) -- Line: 35, Name: KeyFor
        return `GearShop.{p2:gsub(" ", "")}.Enabled`;
    end,

    DefaultFor = function(p3) -- Line: 39, Name: DefaultFor
        -- upvalues: u1 (copy)
        return not u1[p3];
    end,

    IsGearEnabled = function(p4, p5) -- Line: 43, Name: IsGearEnabled
        -- upvalues: GearShopFlags (copy), u1 (copy), ABTests (copy)
        local v6 = GearShopFlags.EnabledOverrides:Get()[p5];

        if type(v6) == "boolean" then
            return v6;
        end;

        local v7 = not u1[p5];
        local v8 = ABTests.GetAttribute(p4, `GearShop.{p5:gsub(" ", "")}.Enabled`, v7);

        if type(v8) == "boolean" then
            return v8;
        end;

        return v7;
    end
});