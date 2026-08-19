-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local Janitor = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "janitor", "src").Janitor;
local RunService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").RunService;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "SpinItem";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 20
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, ...) -- Line: 24
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4, ...);
    p4.spinJanitor = Janitor.new();
end;

function u2.onStart(u5) -- Line: 28
    -- upvalues: RunService (copy)
    u5.spinJanitor:Add(RunService.Heartbeat:Connect(function(p6) -- Line: 30
        -- upvalues: u5 (copy)
        local v7 = u5.instance:GetPivot() * CFrame.Angles(0, 0.5235987755982988 * p6, 0);
        u5.instance:PivotTo(v7);
    end));
end;

function u2.destroy(p8) -- Line: 37
    p8.spinJanitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/SpinItem@SpinItem");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "SpinItem",
        attributes = {},
        instanceGuard = t.union(t.instanceIsA("Model"), t.instanceIsA("BasePart"))
    }
});

return {
    SpinItem = u2
};