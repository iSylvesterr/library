-- Decompiled with Potassium's decompiler.

local GearShopData = require(game:GetService("ReplicatedStorage"):WaitForChild("SharedModules"):WaitForChild("GearShopData"));
local SeedPackData = require(game.ReplicatedStorage.SharedModules.SeedPackData);
local v1 = {};
local u2 = {};

for _, v in GearShopData.Data do
    v1[v.ItemName] = v.IMG;
end;

local v3 = {};

for _, v in SeedPackData.Data do
    v3[v.PackName] = v.IMG;
end;

u2.Data = {
    Secret = {
        RestockChance = 0.7,
        RestockTime = 10,
        GarenteedStock = 0,
        MaximumStock = 10,
        Items = {
            {
                ID = "Super Watering Can ExclusiveGear",
                ItemName = "Super Watering Can",
                ItemType = "Watering Can",
                ItemRestockChance = 100,
                PriceInRobux = 129,
                Giftable = true,
                Image = v1["Super Watering Can"],
                RestockAmounts = { {
                        Amount = 1,
                        Chance = 50
                    }, {
                        Amount = 2,
                        Chance = 23
                    }, {
                        Amount = 3,
                        Chance = 2
                    } }
            },
            {
                ID = "Common Seed Pack ExclusiveGear",
                ItemName = "Common Seed Pack",
                ItemType = "Seed Pack",
                ItemRestockChance = 100,
                PriceInRobux = 129,
                Giftable = true,
                Image = v3["Common Seed Pack"],
                RestockAmounts = { {
                        Amount = 1,
                        Chance = 50
                    }, {
                        Amount = 2,
                        Chance = 23
                    }, {
                        Amount = 3,
                        Chance = 2
                    } },
                Worlds = { "Main" }
            },
            {
                ID = "Common Fall Seed Pack ExclusiveGear",
                ItemName = "Common Fall Seed Pack",
                ItemType = "Seed Pack",
                ItemRestockChance = 100,
                PriceInRobux = 129,
                Giftable = true,
                Image = v3["Common Fall Seed Pack"],
                RestockAmounts = { {
                        Amount = 1,
                        Chance = 50
                    }, {
                        Amount = 2,
                        Chance = 23
                    }, {
                        Amount = 3,
                        Chance = 2
                    } },
                Worlds = { "FallHarvest" }
            }
        },
        RestockAmounts = { {
                Chance = 75,
                Amount = 1
            }, {
                Chance = 23,
                Amount = 2
            }, {
                Chance = 2,
                Amount = 3
            } }
    },
    Exotic = {
        RestockChance = 60,
        RestockTime = 300,
        GarenteedStock = 3,
        MaximumStock = 10,
        Items = {
            {
                ID = "Jump Mushroom ExclusiveGear",
                ItemName = "Jump Mushroom",
                ItemType = "Jump Mushroom",
                ItemRestockChance = 100,
                PriceInRobux = 29,
                Giftable = true,
                Image = v1["Jump Mushroom"],
                RestockAmounts = { {
                        Amount = 1,
                        Chance = 50
                    }, {
                        Amount = 2,
                        Chance = 23
                    }, {
                        Amount = 3,
                        Chance = 2
                    } },
                Worlds = { "Main" }
            }
        }
    }
};

function u2.GetItemType(p4) -- Line: 155
    -- upvalues: u2 (copy)
    for _, v in u2.Data do
        for _, v2 in v.Items do
            if v2.ItemName == p4 then
                return v2.ItemType;
            end;
        end;
    end;

    return nil;
end;

return u2;