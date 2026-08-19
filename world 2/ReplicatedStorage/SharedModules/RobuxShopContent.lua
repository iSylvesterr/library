-- Decompiled with Potassium's decompiler.

local function generateFullPalette(p1) -- Line: 1
    local v2, v3, v4 = p1:ToHSV();
    local v5 = v4 * (1 - v3 / 2);
    local v6 = (v5 == 0 or v5 == 1) and 0 or (v4 - v5) / math.min(v5, 1 - v5);
    local v7 = {};
    local v8 = 0.6 + v3 * 0.4;
    local v9 = Color3.fromHSV(v2 + 0.03333333333333333, v8 == 0 and 0 or 2 * (1 - 0.6 / v8), v8);
    local v10 = 0.15 + v6 * 0.35 * 0.15;
    local v11 = Color3.fromHSV(v2, v10 == 0 and 0 or 2 * (1 - 0.15 / v10), v10);
    local v12 = 0.17 + v6 * 0.7 * 0.17;
    v7[1], v7[2], v7[3], v7[4] = v9, v11, Color3.fromHSV(v2, v12 == 0 and 0 or 2 * (1 - 0.17 / v12), v12), (function(p13, p14, p15) -- Line: 6, Name: fromHSL
    local v16 = p15 + p14 * math.min(p15, 1 - p15);

    return Color3.fromHSV(p13, v16 == 0 and 0 or 2 * (1 - p15 / v16), v16);
end)(v2 + 0.013888888888888888, v6 * 0.9, 0.85);
    table.insert(v7, 1, p1);

    return v7;
end;

return {
    SeedPacks = {
        {
            Name = "Ghost Pepper Pack",
            DisplayName = "Ghost Pepper Pack",
            Colors = generateFullPalette(Color3.fromRGB(255, 0, 0))
        },
        {
            Name = "Harvest Pack",
            DisplayName = "Harvest Pack",
            DecorImage = "rbxassetid://73215242763691",
            Colors = generateFullPalette(Color3.fromRGB(226, 116, 26))
        }
    },
    StarterPack = {
        DisplayName = "Starter Pack",
        Products = {
            Main = {
                Key = "Standalone:StarterPack:1",
                DisplayName = "Starter Pack"
            },
            FallHarvest = {
                Key = "Standalone:FallStarterPack:1",
                DisplayName = "Fall Starter Pack"
            }
        },
        Items = { {
                Type = "SeedPack",
                Name = "Legendary Seed Pack",
                Count = 1
            }, {
                Type = "Gear",
                Name = "Common Watering Can",
                Count = 5
            }, {
                Type = "SeedPack",
                Name = "Rare Seed Pack",
                Count = 3
            } }
    },
    Gears = {
        {
            Name = "Vine Wrapper",
            Description = "Wrap people in vines!",
            GamepassKey = "Gamepass:VineWrapper:1",
            Colors = generateFullPalette(Color3.fromRGB(0, 170, 0))
        },
        {
            Name = "Power Hose",
            Description = "Spray people from distance!",
            GamepassKey = "Gamepass:PowerHose:1",
            Colors = generateFullPalette(Color3.fromRGB(56, 168, 255))
        },
        {
            Name = "Freeze Ray",
            Description = "Freeze people!",
            GamepassKey = "Gamepass:FreezeRay:1",
            Colors = generateFullPalette(Color3.fromRGB(120, 220, 255))
        },
        {
            Name = "Rainbow Carpet",
            Description = "Fly anywhere!",
            GamepassKey = "Gamepass:RainbowCarpet:1",
            Colors = generateFullPalette(Color3.fromRGB(255, 100, 200))
        }
    },
    GrapplingHookGear = {
        Name = "Grappling Hook",
        Description = "Reel yourself across the map!",
        GamepassKey = "Gamepass:GrapplingHook:1",
        Colors = generateFullPalette(Color3.fromRGB(255, 200, 45))
    },
    Sheckles = { {
            Amount = 5000,
            Price = 10,
            Image = "rbxassetid://88931175983845",
            WorldImages = {
                FallHarvest = "rbxassetid://93680699734342"
            }
        }, {
            Amount = 10000,
            Price = 20,
            Image = "rbxassetid://132134544257550",
            WorldImages = {
                FallHarvest = "rbxassetid://125835073598412"
            }
        }, {
            Amount = 25000,
            Price = 50,
            Image = "rbxassetid://72067131155642",
            WorldImages = {
                FallHarvest = "rbxassetid://101026181937462"
            }
        }, {
            Amount = 50000,
            Price = 100,
            Image = "rbxassetid://93115005224214",
            WorldImages = {
                FallHarvest = "rbxassetid://104228130768300"
            }
        }, {
            Amount = 100000,
            Price = 200,
            Image = "rbxassetid://99416757982094",
            WorldImages = {
                FallHarvest = "rbxassetid://131598382997774"
            }
        } },
    PetTeleporters = {
        {
            Name = "Legendary Pet Teleporter",
            Description = "Join a hunt to compete for a wild Legendary pet.",
            Colors = generateFullPalette(Color3.fromRGB(255, 196, 64))
        },
        {
            Name = "Mythic Pet Teleporter",
            Description = "Join a hunt to compete for a wild Mythic pet.",
            Colors = generateFullPalette(Color3.fromRGB(190, 95, 255))
        },
        {
            Name = "Super Pet Teleporter",
            Description = "Join a hunt to compete for a wild Super pet.",
            Colors = generateFullPalette(Color3.fromRGB(80, 225, 255))
        }
    }
};