-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local WATER_TAG = RuntimeLib.import(script, script.Parent.Parent.Parent, "controllers", "world", "WaterFieldController").WATER_TAG;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 13, Name: __tostring
        return "WaterComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 19
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, p5) -- Line: 23
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p4);
    p4.waterField = p5;
end;

function u2.onStart(p6) -- Line: 27
    p6.waterField:registerTile(p6.instance);
end;

function u2.destroy(p7) -- Line: 30
    -- upvalues: BaseComponent (copy)
    p7.waterField:unregisterTile(p7.instance);
    BaseComponent.destroy(p7);
end;

Reflect.defineMetadata(u2, "identifier", "client/components/world/WaterComponent@WaterComponent");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/controllers/world/WaterFieldController@WaterFieldController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = WATER_TAG,
        attributes = {},
        instanceGuard = t.instanceIsA("BasePart")
    }
});

return {
    WaterComponent = u2
};