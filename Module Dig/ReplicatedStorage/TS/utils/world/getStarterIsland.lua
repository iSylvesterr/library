-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;

return {
    getIslandsFolder = function() -- Line: 7
        -- upvalues: WFChain (copy), Workspace (copy)
        return WFChain(Workspace, "Islands");
    end,

    getStarterIsland = function() -- Line: 10
        -- upvalues: WFChain (copy), Workspace (copy)
        return WFChain(WFChain(Workspace, "Islands"), "Home Beach");
    end
};