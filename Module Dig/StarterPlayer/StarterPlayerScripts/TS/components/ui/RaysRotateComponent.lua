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
    __tostring = function() -- Line: 15, Name: __tostring
        return "RaysRotateComponent";
    end,

    __index = BaseComponent
});
u2.__index = u2;

function u2.new(...) -- Line: 21
    -- upvalues: u2 (ref)
    local v3 = setmetatable({}, u2);

    return v3:constructor(...) or v3;
end;

function u2.constructor(p4, ...) -- Line: 25
    -- upvalues: BaseComponent (copy), Janitor (copy)
    BaseComponent.constructor(p4, ...);
    p4.janitor = Janitor.new();
end;

function u2.onStart(u5) -- Line: 29
    -- upvalues: RunService (copy)
    local speed = u5.attributes.speed;
    local u6 = speed == nil and 30 or speed;
    u5.janitor:Add(RunService.Heartbeat:Connect(function(p7) -- Line: 35
        -- upvalues: u5 (copy), u6 (copy)
        local instance = u5.instance;
        instance.Rotation = instance.Rotation + u6 * p7;
    end), "Disconnect");
end;

function u2.destroy(p8) -- Line: 39
    p8.janitor:Destroy();
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/RaysRotateComponent@RaysRotateComponent");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "RaysRotate",
        attributes = {
            speed = t.optional(t.number)
        },
        instanceGuard = t.instanceIsA("ImageLabel")
    }
});

return {
    RaysRotateComponent = u2
};