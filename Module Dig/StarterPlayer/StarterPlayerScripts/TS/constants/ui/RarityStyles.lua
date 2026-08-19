-- Decompiled with Potassium's decompiler.

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "TextEffectTags");
local COSMIC_SEQUENCE = v1.COSMIC_SEQUENCE;
local COSMIC_TEXT_TAG = v1.COSMIC_TEXT_TAG;
local EMBER_SEQUENCE = v1.EMBER_SEQUENCE;
local EMBER_TEXT_TAG = v1.EMBER_TEXT_TAG;
local ETERNAL_SEQUENCE = v1.ETERNAL_SEQUENCE;
local ETERNAL_TEXT_TAG = v1.ETERNAL_TEXT_TAG;
local RADIANT_SEQUENCE = v1.RADIANT_SEQUENCE;
local RADIANT_TEXT_TAG = v1.RADIANT_TEXT_TAG;
local TRANSCENDENT_SEQUENCE = v1.TRANSCENDENT_SEQUENCE;
local TRANSCENDENT_TEXT_TAG = v1.TRANSCENDENT_TEXT_TAG;
local v2 = ColorSequence.new(Color3.fromRGB(238, 238, 238), Color3.fromRGB(158, 158, 158));
local v3 = ColorSequence.new(Color3.fromRGB(150, 255, 180), Color3.fromRGB(52, 220, 96));
local v4 = ColorSequence.new(Color3.fromRGB(150, 205, 255), Color3.fromRGB(55, 140, 255));
local v5 = ColorSequence.new(Color3.fromRGB(215, 155, 255), Color3.fromRGB(150, 65, 240));
local u6 = { "common", "uncommon", "rare", "epic", "legendary", "mythic", "divine", "eternal", "transcendent" };
local u7 = {
    common = {
        rotation = 90,
        color = Color3.fromRGB(168, 168, 168),
        gradient = v2
    },
    uncommon = {
        rotation = 90,
        color = Color3.fromRGB(88, 255, 130),
        gradient = v3
    },
    rare = {
        rotation = 90,
        color = Color3.fromRGB(85, 170, 255),
        gradient = v4
    },
    epic = {
        rotation = 90,
        color = Color3.fromRGB(180, 95, 255),
        gradient = v5
    },
    legendary = {
        color = Color3.fromRGB(255, 178, 32),
        gradient = RADIANT_SEQUENCE,
        animationTag = RADIANT_TEXT_TAG
    },
    mythic = {
        color = Color3.fromRGB(255, 45, 45),
        gradient = EMBER_SEQUENCE,
        animationTag = EMBER_TEXT_TAG
    },
    divine = {
        color = Color3.fromRGB(215, 120, 255),
        gradient = COSMIC_SEQUENCE,
        animationTag = COSMIC_TEXT_TAG
    },
    eternal = {
        color = Color3.fromRGB(0, 240, 200),
        gradient = ETERNAL_SEQUENCE,
        animationTag = ETERNAL_TEXT_TAG
    },
    transcendent = {
        color = Color3.fromRGB(255, 105, 180),
        gradient = TRANSCENDENT_SEQUENCE,
        animationTag = TRANSCENDENT_TEXT_TAG
    }
};

return {
    rarityStyleFor = function(p8) -- Line: 68, Name: rarityStyleFor
        -- upvalues: u7 (copy)
        return u7[p8];
    end,

    rarityTierIndex = function(p9) -- Line: 71, Name: rarityTierIndex
        -- upvalues: u6 (copy)
        return (table.find(u6, p9) or 0) - 1;
    end,

    RARITY_ORDER = u6,
    RARITY_TIER_COUNT = #u6,
    RARITY_STYLES = u7
};