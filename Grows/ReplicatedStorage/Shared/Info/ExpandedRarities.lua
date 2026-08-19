-- Decompiled with Potassium's decompiler.

local CustomEnum = require(game.ReplicatedStorage.Shared.Info.CustomEnum);

return {
    [CustomEnum.RARITIES.COMMON] = {
        name = "Common",
        rarityTier = 1,
        mainColor = Color3.new(0.623529, 0.623529, 0.623529),
        subColor = Color3.new(0.478431, 0.478431, 0.478431),
        darkColor = Color3.new(0.22745, 0.22745, 0.22745)
    },
    [CustomEnum.RARITIES.UNCOMMON] = {
        name = "Uncommon",
        rarityTier = 2,
        mainColor = Color3.new(0.282352, 1, 0.184313),
        subColor = Color3.new(0.254901, 0.615686, 0.207843),
        darkColor = Color3.new(0.12549, 0.309803, 0.10196)
    },
    [CustomEnum.RARITIES.RARE] = {
        name = "Rare",
        rarityTier = 3,
        mainColor = Color3.new(0.349019, 0.733333, 0.988235),
        subColor = Color3.new(0.180392, 0.443137, 0.619607),
        darkColor = Color3.new(0.10196, 0.262745, 0.368627)
    },
    [CustomEnum.RARITIES.EPIC] = {
        name = "Epic",
        rarityTier = 4,
        mainColor = Color3.new(0.972549, 0.490196, 0.788235),
        subColor = Color3.new(0.631372, 0.286274, 0.50196),
        darkColor = Color3.new(0.341176, 0.149019, 0.270588)
    },
    [CustomEnum.RARITIES.LEGENDARY] = {
        name = "Legendary",
        rarityTier = 5,
        mainColor = Color3.new(0.956862, 0.270588, 0.149019),
        subColor = Color3.new(0.678431, 0.17647, 0.090196),
        darkColor = Color3.new(0.333333, 0.086274, 0.043137)
    },
    [CustomEnum.RARITIES.MYTHIC] = {
        name = "Mythic",
        rarityTier = 6,
        mainColor = Color3.new(0.992156, 0.886274, 0.082352),
        subColor = Color3.new(0.858823, 0.647058, 0.062745),
        darkColor = Color3.new(0.494117, 0.372549, 0.039215)
    },
    [CustomEnum.RARITIES.CELESTIAL] = {
        name = "Celestial",
        rarityTier = 7,
        mainColor = Color3.fromRGB(12, 45, 138),
        subColor = Color3.fromRGB(8, 30, 100),
        darkColor = Color3.fromRGB(4, 15, 60)
    },
    [CustomEnum.RARITIES.SECRET] = {
        name = "Secret",
        rarityTier = 8,
        mainColor = Color3.fromRGB(180, 40, 230),
        subColor = Color3.fromRGB(120, 20, 160),
        darkColor = Color3.fromRGB(60, 10, 80)
    },
    [CustomEnum.RARITIES.DIVINE] = {
        name = "Divine",
        rarityTier = 9,
        mainColor = Color3.fromRGB(255, 240, 180),
        subColor = Color3.fromRGB(220, 190, 110),
        darkColor = Color3.fromRGB(150, 120, 50)
    },
    [CustomEnum.RARITIES.TRANSCENDENT] = {
        name = "Transcendent",
        rarityTier = 10,
        mainColor = Color3.fromHex("#5BC6FF"),
        subColor = Color3.fromHex("#F2E8C9"),
        darkColor = Color3.fromRGB(40, 90, 125)
    },
    [CustomEnum.RARITIES.ANCIENT] = {
        name = "Ancient",
        rarityTier = 11,
        mainColor = Color3.fromHex("#C2B070"),
        subColor = Color3.fromHex("#6E9A47"),
        darkColor = Color3.fromHex("#5E3D26")
    }
};