-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastFlags = require(ReplicatedStorage.UserGenerated.FastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local v1 = FastFlags.Replicated("Game.Merge.Enabled", Asserts.Boolean, true);
local v2 = FastFlags.Replicated("Game.Merge.RangeStuds", Asserts.FinitePositive, 30);
local v3 = FastFlags.Replicated("Game.Merge.SizeVariance", Asserts.Range(0, 1), 0.4);
local v4 = FastFlags.Replicated("Game.Merge.PulseSeconds", Asserts.FinitePositive, 5);
local v5 = FastFlags.Replicated("Game.Merge.PromptHoldSeconds", Asserts.FinitePositive, 2);
local u6 = table.freeze({
    ["Moon Bloom+Sun Bloom"] = "Eclipse Bloom"
});

local function RecipeKey(p7, p8) -- Line: 36
    if p7 < p8 then
        return `{p7}+{p8}`;
    end;

    return `{p8}+{p7}`;
end;

return table.freeze({
    Enabled = v1,
    RangeStuds = v2,
    SizeVariance = v3,
    PulseSeconds = v4,
    PromptHoldSeconds = v5,
    Recipes = u6,

    GetMergeResult = function(p9, p10) -- Line: 45, Name: GetMergeResult
        -- upvalues: u6 (copy)
        if type(p9) ~= "string" or type(p10) ~= "string" then
            return nil;
        end;

        local v11;

        if p9 < p10 then
            v11 = `{p9}+{p10}`;
        else
            v11 = `{p10}+{p9}`;
        end;

        return u6[v11];
    end
});