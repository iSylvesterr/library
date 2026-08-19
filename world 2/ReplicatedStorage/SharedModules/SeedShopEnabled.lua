-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SeedShopFlags = require(ReplicatedStorage.SharedModules.Flags.SeedShopFlags);
local SeedShopLimited = require(ReplicatedStorage.SharedModules.SeedShopLimited);
local u1 = {
    ["Briar Rose"] = true,
    ["Hypno Bloom"] = true,
    ["Rocket Pop"] = true,
    ["Fire Fern"] = true,
    ["Sun Bloom"] = true,
    ["Star Fruit"] = true,
    ["Conifer Cone"] = true,
    ["Atlantic Giant Pumpkin"] = true,
    ["Amber Cranberry"] = true,
    ["Conifer Cone Sapling"] = true
};

return table.freeze({
    DefaultFor = function(p2) -- Line: 42, Name: DefaultFor
        -- upvalues: u1 (copy)
        return not u1[p2];
    end,

    IsSeedEnabled = function(p3) -- Line: 46, Name: IsSeedEnabled
        -- upvalues: SeedShopFlags (copy), SeedShopLimited (copy), u1 (copy)
        local v4 = SeedShopFlags.EnabledOverrides:Get()[p3];

        if type(v4) == "boolean" then
            return v4;
        end;

        if SeedShopLimited.IsExpired(p3) then
            return false;
        end;

        return not u1[p3];
    end,

    IsSeedReleased = function(p5) -- Line: 72, Name: IsSeedReleased
        -- upvalues: SeedShopFlags (copy), u1 (copy)
        local v6 = SeedShopFlags.EnabledOverrides:Get()[p5];

        if type(v6) == "boolean" then
            return v6;
        end;

        return not u1[p5];
    end
});