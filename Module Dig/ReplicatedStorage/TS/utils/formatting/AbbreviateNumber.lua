-- Decompiled with Potassium's decompiler.

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "abbreviate", "src");
local u2 = v1.new();
u2:setSetting("stripTrailingZeroes", true);
u2:setSetting("decimalPlaces", 1);
local u3 = v1.new();
u3:setSetting("stripTrailingZeroes", true);
u3:setSetting("decimalPlaces", 0);

return {
    AbbreviateNumber = function(p4) -- Line: 7, Name: AbbreviateNumber
        -- upvalues: u2 (copy)
        return u2:numberToString(p4);
    end,

    AbbreviateInteger = function(p5) -- Line: 13, Name: AbbreviateInteger
        -- upvalues: u3 (copy)
        return u3:numberToString(p5);
    end
};