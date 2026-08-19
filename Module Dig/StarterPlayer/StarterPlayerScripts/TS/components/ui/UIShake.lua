-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 13, Name: __tostring
        return "UIShake";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 19
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, ...) -- Line: 23
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p4, ...);
    p4.destroyed = false;
end;

function u2.onStart(p5) -- Line: 27
    -- upvalues: TweenService (copy)
    local v6 = TweenInfo.new(0.1, Enum.EasingStyle.Sine);
    local v7 = TweenService:Create(p5.instance, v6, {
        Rotation = -7
    });
    local v8 = TweenService:Create(p5.instance, v6, {
        Rotation = 7
    });
    local v9 = TweenService:Create(p5.instance, v6, {
        Rotation = 0
    });

    repeat
        v7:Play();
        v7.Completed:Wait();
        v8:Play();
        v8.Completed:Wait();
        v9:Play();
        task.wait(4);
    until p5.destroyed;
end;

function u2.destroy(p10) -- Line: 49
    p10.destroyed = true;
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/UIShake@UIShake");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "UIShake",
        attributes = {},
        instanceGuard = t.instanceIsA("ImageLabel")
    }
});

return {
    UIShake = u2
};