-- Decompiled with Potassium's decompiler.

require(script.Parent.Rarity);

return {
    ArrayData = {
        { "Common", Color3.new(0.666667, 0.666667, 0.666667) },
        { "Uncommon", Color3.new(0.32549, 0.666667, 0.384314) },
        { "Rare", Color3.new(0.027451, 0.466667, 1) },
        { "Legendary", Color3.new(1, 1, 0) },
        { "Mythical", Color3.new(0.666667, 0.333333, 1) },
        { "Divine", Color3.fromRGB(255, 85, 0) },
        { "Prismatic", Color3.fromHSV(0, 1, 1), true },
        { "Transcendent", Color3.fromHSV(0.7, 1, 1), true }
    },
    ByRarityToData = {
        Common = {
            Animated = false,
            Color = Color3.new(0.666667, 0.666667, 0.666667)
        },
        Uncommon = {
            Animated = false,
            Color = Color3.new(0.32549, 0.666667, 0.384314)
        },
        Rare = {
            Animated = false,
            Color = Color3.new(0.027451, 0.466667, 1)
        },
        Legendary = {
            Animated = false,
            Color = Color3.new(1, 1, 0)
        },
        Mythical = {
            Animated = false,
            Color = Color3.new(0.666667, 0.333333, 1)
        },
        Divine = {
            Animated = false,
            Color = Color3.fromRGB(255, 85, 0)
        },
        Prismatic = {
            Animated = true,
            Color = Color3.fromHSV(0, 1, 1)
        },
        Transcendent = {
            Animated = true,
            Color = Color3.fromHSV(0.7, 1, 1)
        }
    }
};