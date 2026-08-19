-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local GetWeaponProperties = require(script.Parent.GetWeaponProperties);

local function CreateFallbackStockInformation(p1) -- Line: 17
    -- upvalues: GetWeaponProperties (copy)
    local success, result = pcall(GetWeaponProperties, p1);

    if success then
        return result and {
            paintId = "stock",
            skin = "Stock",
            rarity = "Stock",
            supportsStatTrak = false,
            statTrakChance = 0,
            isEnabled = true,
            isMarketplaceVisible = false,
            collection = nil,
            description = "Standard issue finish.",
            caseRarity = "Stock",
            type = result.Class,
            name = p1,
            floatRange = {
                min = 0,
                max = 0.07
            },
            floatChances = { {
                    wear = "Factory New",
                    chance = 100
                } },
            charmImages = {},
            wearImages = {},
            imageAssetId = result.Icon or result.ReverseIcon
        } or nil;
    end;

    return nil;
end;

return function(p2, p3) -- Line: 60
    -- upvalues: Skins (copy), CreateFallbackStockInformation (copy)
    local v4 = Skins.GetSkinInformation(p2, p3);

    if v4 or p3 ~= "Stock" then
        return v4;
    end;

    return CreateFallbackStockInformation(p2);
end;