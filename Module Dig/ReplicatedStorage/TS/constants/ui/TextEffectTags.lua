-- Decompiled with Potassium's decompiler.

local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 165, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 100, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(130, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
});
local v2 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) });
local v3 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)) });
local v4 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 130, 255)),
    ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 230, 50)),
    ColorSequenceKeypoint.new(0.75, Color3.fromRGB(0, 210, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 130, 255))
});
local v5 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 50, 255)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(255, 100, 200)),
    ColorSequenceKeypoint.new(0.66, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 50, 255))
});

local function cyclicSequence(u6) -- Line: 7
    local v7 = table.create(#u6);

    local function _(p8, p9) -- Line: 10
        -- upvalues: u6 (copy)
        return ColorSequenceKeypoint.new(p9 / #u6, p8);
    end;

    for i, v in u6 do
        v7[i] = ColorSequenceKeypoint.new((i - 1) / #u6, v);
    end;

    local v10 = ColorSequenceKeypoint.new(1, u6[1]);
    table.insert(v7, v10);

    return ColorSequence.new(v7);
end;

local v11 = {
    Color3.fromRGB(196, 126, 8),
    Color3.fromRGB(255, 186, 28),
    Color3.fromRGB(255, 245, 190),
    Color3.fromRGB(255, 186, 28)
};
local v12 = {
    Color3.fromRGB(150, 12, 24),
    Color3.fromRGB(255, 45, 45),
    Color3.fromRGB(255, 150, 120),
    Color3.fromRGB(255, 45, 45)
};
local v13 = {
    Color3.fromRGB(255, 188, 52),
    Color3.fromRGB(255, 226, 122),
    Color3.fromRGB(255, 253, 228),
    Color3.fromRGB(255, 226, 122),
    Color3.fromRGB(255, 188, 52),
    Color3.fromRGB(243, 168, 38)
};
local v14 = {
    Color3.fromRGB(90, 30, 200),
    Color3.fromRGB(255, 60, 190),
    Color3.fromRGB(60, 220, 255),
    Color3.fromRGB(255, 255, 255)
};
local v15 = {
    Color3.fromRGB(0, 90, 95),
    Color3.fromRGB(0, 240, 200),
    Color3.fromRGB(225, 255, 250),
    Color3.fromRGB(0, 190, 170)
};
local v16 = {
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(255, 70, 120),
    Color3.fromRGB(255, 190, 50),
    Color3.fromRGB(130, 255, 110),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(70, 190, 255),
    Color3.fromRGB(200, 90, 255)
};

return {
    RADIANT_TEXT_TAG = "RadiantText",
    SHINY_GOLD_TEXT_TAG = "ShinyGoldText",
    EMBER_TEXT_TAG = "EmberText",
    COSMIC_TEXT_TAG = "CosmicText",
    ETERNAL_TEXT_TAG = "EternalText",
    TRANSCENDENT_TEXT_TAG = "TranscendentText",
    RAINBOW_TAG = "RainbowText",
    SECRET_TEXT_TAG = "SecretText",
    DIVINE_TEXT_TAG = "DivineText",
    DISCO_TEXT_TAG = "DiscoText",
    PRISMATIC_TEXT_TAG = "PrismaticText",
    RAINBOW_PLATFORM_TAG = "RainbowPlatform",
    SECRET_PLATFORM_TAG = "SecretPlatform",
    DIVINE_PLATFORM_TAG = "DivinePlatform",
    RAINBOW_SEQUENCE = v1,
    SECRET_SEQUENCE = v2,
    DIVINE_SEQUENCE = v3,
    DISCO_SEQUENCE = v4,
    PRISMATIC_SEQUENCE = v5,
    RADIANT_COLORS = v11,
    EMBER_COLORS = v12,
    SHINY_GOLD_COLORS = v13,
    COSMIC_COLORS = v14,
    ETERNAL_COLORS = v15,
    TRANSCENDENT_COLORS = v16,
    RADIANT_SEQUENCE = cyclicSequence(v11),
    SHINY_GOLD_SEQUENCE = cyclicSequence(v13),
    EMBER_SEQUENCE = cyclicSequence(v12),
    COSMIC_SEQUENCE = cyclicSequence(v14),
    ETERNAL_SEQUENCE = cyclicSequence(v15),
    TRANSCENDENT_SEQUENCE = cyclicSequence(v16)
};