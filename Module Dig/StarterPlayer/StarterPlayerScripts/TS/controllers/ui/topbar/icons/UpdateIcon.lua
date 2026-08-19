-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework;
local Icon = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "topbar-plus", "out").Icon;
local EVENT_ID_KEY = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "config", "Config").EVENT_ID_KEY;
local u1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "EventUtils");

return {
    setup = function() -- Line: 7, Name: setup
        -- upvalues: Flamework (copy), Icon (copy), u1 (copy), EVENT_ID_KEY (copy)
        local u2 = Flamework.resolveDependency("client/controllers/config/ConfigController@ConfigController");
        local u3 = nil;
        u3 = Icon.new():setLabel("UPDATE"):bindEvent("selected", function() -- Line: 10
            -- upvalues: u3 (ref), u1 (ref), u2 (copy), EVENT_ID_KEY (ref)
            u3:deselect();
            u1.PromptEvent(u2:getConfigValue(EVENT_ID_KEY));
        end):align("Right"):setOrder(3);
    end
};