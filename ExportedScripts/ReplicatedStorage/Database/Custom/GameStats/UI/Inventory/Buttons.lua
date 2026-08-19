-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.Database.Custom.Types);
local v1 = {
    LayoutOrder = 0,
    Search = { "Badge", "Zeus x27", "C4", "Graffiti", "Charm", "Charm Capsule", "Sticker", "Sticker Capsule", "Music Kit", "Weapon", "Glove", "Melee", "Case", "Package" }
};

return require(ReplicatedStorage.Packages.Sift).Dictionary.freezeDeep({
    GetEffectiveItemType = function(p2) -- Line: 65, Name: GetEffectiveItemType
        local v3;

        if p2.Type == "Case" and p2.Name then
            local v4 = string.find(p2.Skin, "Sticker") ~= nil;
            local v5 = string.find(p2.Skin, "Charm") ~= nil;
            v3 = v5 or v4;
        else
            v3 = false;
        end;

        return v3 and (p2.Name and string.find(p2.Name, "Charm") and "Charm Capsule" or (p2.Name and string.find(p2.Name, "Sticker") and "Sticker Capsule" or (p2.Type == "Charm Capsule" and "Charm Capsule" or "Sticker Capsule"))) or (p2.Type or "");
    end,

    IsCapsule = function(p6) -- Line: 51, Name: IsCapsule
        if p6.Type ~= "Case" or not p6.Name then
            return false;
        end;

        local v7 = string.find(p6.Skin, "Sticker") ~= nil;

        return string.find(p6.Skin, "Charm") ~= nil or v7;
    end,

    Everything = {
        Default = v1
    },
    Equipment = {
        ["All Equipment"] = v1,
        Melee = {
            Search = { "Melee" },
            LayoutOrder = 1
        },
        Pistols = {
            Search = { "Weapon:Pistol" },
            LayoutOrder = 2
        },
        ["Mid-Tier"] = {
            Search = { "Weapon:Heavy", "Weapon:SMG" },
            LayoutOrder = 3
        },
        Rifles = {
            Search = { "Weapon:Rifle" },
            LayoutOrder = 4
        },
        Misc = {
            Search = { "Zeus x27", "C4" },
            LayoutOrder = 5
        },
        Gloves = {
            Search = { "Glove" },
            LayoutOrder = 6
        },
        ["Music Kits"] = {
            Search = { "Music Kit" },
            LayoutOrder = 7
        }
    },
    ["Graphic Art"] = {
        ["All Graphic Art"] = {
            Search = { "Badge", "Graffiti", "Charm", "Sticker" },
            LayoutOrder = 0
        },
        Badges = {
            Search = { "Badge" },
            LayoutOrder = 1
        },
        Stickers = {
            Search = { "Sticker" },
            LayoutOrder = 2
        },
        Graffiti = {
            Search = { "Graffiti" },
            LayoutOrder = 3
        },
        Charms = {
            Search = { "Charm" },
            LayoutOrder = 4
        }
    },
    Display = {
        All = {
            Search = { "Case", "Package", "Charm Capsule", "Sticker Capsule" },
            LayoutOrder = 0
        },
        Cases = {
            Search = { "Case" },
            LayoutOrder = 1
        },
        Packages = {
            Search = { "Package" },
            LayoutOrder = 2
        },
        Capsules = {
            Search = { "Charm Capsule", "Sticker Capsule" },
            LayoutOrder = 3
        }
    }
});