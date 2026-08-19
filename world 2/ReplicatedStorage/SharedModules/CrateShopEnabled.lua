-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local CrateShopFlags = require(ReplicatedStorage.SharedModules.Flags.CrateShopFlags);
local CrateShopLimited = require(ReplicatedStorage.SharedModules.CrateShopLimited);
local u1 = {
    ["Picture Frame Crate"] = true,
    ["Boombox Crate"] = true,
    ["Fourth Of July Crate"] = true,
    ["Rake Crate"] = true,
    ["Lantern Crate"] = true,
    ["Fall Structure Crate"] = true,
    ["Cobblestone Crate"] = true,
    ["Fall Cosmetic Crate"] = true
};

return table.freeze({
    DefaultFor = function(p2) -- Line: 26, Name: DefaultFor
        -- upvalues: u1 (copy)
        return not u1[p2];
    end,

    IsCrateEnabled = function(p3) -- Line: 30, Name: IsCrateEnabled
        -- upvalues: CrateShopFlags (copy), CrateShopLimited (copy), u1 (copy)
        local v4 = CrateShopFlags.EnabledOverrides:Get()[p3];

        if type(v4) == "boolean" then
            return v4;
        end;

        if CrateShopLimited.IsExpired(p3) then
            return false;
        end;

        return not u1[p3];
    end
});