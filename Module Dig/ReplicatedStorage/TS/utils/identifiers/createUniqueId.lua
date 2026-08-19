-- Decompiled with Potassium's decompiler.

local HttpService = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService;

return {
    createUniqueIdentifier = function(p1) -- Line: 11
        -- upvalues: HttpService (copy)
        return `{p1}_{HttpService:GenerateGUID(false)}`;
    end
};