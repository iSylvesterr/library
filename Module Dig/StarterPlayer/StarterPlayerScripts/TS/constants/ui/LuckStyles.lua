-- Decompiled with Potassium's decompiler.

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "ui", "TextEffectTags");
local u2 = {
    {
        minLuck = 10,
        gradient = v1.COSMIC_SEQUENCE,
        animationTag = v1.COSMIC_TEXT_TAG
    },
    {
        minLuck = 5,
        gradient = v1.PRISMATIC_SEQUENCE,
        animationTag = v1.PRISMATIC_TEXT_TAG
    },
    {
        minLuck = 3,
        gradient = v1.EMBER_SEQUENCE,
        animationTag = v1.EMBER_TEXT_TAG
    },
    {
        minLuck = 1,
        gradient = v1.SHINY_GOLD_SEQUENCE,
        animationTag = v1.SHINY_GOLD_TEXT_TAG
    }
};

return {
    LUCK_GRADIENT_ROTATION = 90,

    luckStyleFor = function(u3) -- Line: 31, Name: luckStyleFor
        -- upvalues: u2 (copy)
        if u3 <= 1 then
            return nil;
        end;

        local function _(p4) -- Line: 37
            -- upvalues: u3 (copy)
            return u3 >= p4.minLuck;
        end;

        local v5 = nil;

        for i, v in u2 do
            local _ = i - 1;

            if v.minLuck <= u3 == true then
                v5 = v;
                break;
            end;
        end;

        return v5;
    end,

    formatLuck = function(p6) -- Line: 52, Name: formatLuck
        return `{string.format("%g", p6)}X LUCK`;
    end,

    LUCK_STYLES = u2
};