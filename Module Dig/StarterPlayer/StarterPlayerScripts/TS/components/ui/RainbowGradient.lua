-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 13, Name: __tostring
        return "RainbowGradient";
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
    p4.rainbowUIController = p5;
end;

function u2.onStart(p6) -- Line: 27
    -- upvalues: WFChain (copy), ReplicatedStorage (copy)
    local v7 = WFChain(ReplicatedStorage, "Assets", "UI", "RainbowGradient"):Clone();
    v7.Parent = p6.instance;
    p6.gradient = v7;
    p6.rainbowUIController:addGradient(v7, 45);
end;

function u2.destroy(p8) -- Line: 33
    if p8.gradient then
        p8.rainbowUIController:removeGradient(p8.gradient);
    end;
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/RainbowGradient@RainbowGradient");
Reflect.defineMetadata(u2, "flamework:parameters", { "client/components/ui/RainbowUIController@RainbowUIController" });
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, { {
        tag = "RainbowGradient",
        attributes = {}
    } });

return {
    RainbowGradient = u2
};