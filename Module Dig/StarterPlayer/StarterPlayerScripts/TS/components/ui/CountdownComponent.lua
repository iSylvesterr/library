-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out");
local Component = v1.Component;
local BaseComponent = v1.BaseComponent;
local formatSeconds = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "formatting", "formatSeconds").formatSeconds;
local u2 = setmetatable({}, {
    __tostring = function() -- Line: 13, Name: __tostring
        return "CountdownComponent";
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
    p4.initialTime = p4.attributes.time + os.time();
end;

function u2.onStart(p5) -- Line: 27
end;

function u2.updateCountdown(p6) -- Line: 29
    -- upvalues: formatSeconds (copy)
    local v7 = p6.initialTime - os.time();
    local prefix = p6.attributes.prefix;
    p6.instance.Text = `{prefix == nil and "" or prefix} {formatSeconds((math.abs(v7)))}`;
end;

Reflect.defineMetadata(u2, "identifier", "client/components/ui/CountdownComponent@CountdownComponent");
Reflect.defineMetadata(u2, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u2, "$c:components@Component", Component, {
    {
        tag = "Countdown",
        attributes = {
            time = t.number,
            prefix = t.optional(t.string)
        },
        instanceGuard = t.instanceIsA("TextLabel")
    }
});

return {
    CountdownComponent = u2
};