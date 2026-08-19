-- Decompiled with Potassium's decompiler.

local TextGradient = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, script.Parent, "TextGradient").TextGradient;
local u1 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(246, 197, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 247, 0)) });

return {
    GOLD_GRADIENT_ROTATION = -90,

    applyGoldGradient = function(p2) -- Line: 6, Name: applyGoldGradient
        -- upvalues: TextGradient (copy), u1 (copy)
        p2.TextColor3 = Color3.new(1, 1, 1);

        return TextGradient.apply(p2, u1, -90);
    end,

    GOLD_GRADIENT_COLOR = u1
};