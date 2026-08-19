-- Decompiled with Potassium's decompiler.

local AbbreviateNumber = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "AbbreviateNumber").AbbreviateNumber;

return {
    formatAbbrevMoney = function(p1) -- Line: 4, Name: formatAbbrevMoney
        -- upvalues: AbbreviateNumber (copy)
        return `{AbbreviateNumber(p1)}¢`;
    end
};