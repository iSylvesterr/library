-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u1 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u2 = TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = setmetatable({}, {
    __tostring = function() -- Line: 15, Name: __tostring
        return "TransitionController";
    end
});
u3.__index = u3;

function u3.new(...) -- Line: 20
    -- upvalues: u3 (ref)
    local v4 = setmetatable({}, u3);

    return v4:constructor(...) or v4;
end;

function u3.constructor(p5) -- Line: 24
    p5.busy = false;
end;

function u3.onStart(p6) -- Line: 27
    -- upvalues: WFChain (copy), PlayerGui (copy)
    local v7 = WFChain(PlayerGui, "TransitionUI");
    v7.DisplayOrder = 1000000;
    local v8 = WFChain(v7, "Circle");
    v8.AnchorPoint = Vector2.new(0.5, 0.5);
    v8.Position = UDim2.fromScale(0.5, 0.5);
    v8.Size = UDim2.fromScale(3.5, 3.5);
    v8.Visible = false;
    p6.circle = v8;
end;

u3.play = RuntimeLib.async(function(p9, p10, p11) -- Line: 37
    -- upvalues: RuntimeLib (copy), u1 (copy), u2 (copy)
    local v12 = p11 == nil and 0 or p11;

    if p9.busy then
        return nil;
    end;

    p9.busy = true;
    p9.circle.Size = UDim2.fromScale(3.5, 3.5);
    p9.circle.Visible = true;
    RuntimeLib.await(p9:tweenTo(UDim2.fromScale(0, 0), u1));
    local v13 = p10();

    if RuntimeLib.Promise.is(v13) then
        RuntimeLib.await(v13);
    end;

    if v12 > 0 then
        RuntimeLib.await(RuntimeLib.Promise.delay(v12));
    end;

    RuntimeLib.await(p9:tweenTo(UDim2.fromScale(3.5, 3.5), u2));
    p9.circle.Visible = false;
    p9.busy = false;
end);

function u3.tweenTo(u14, u15, u16) -- Line: 59
    -- upvalues: RuntimeLib (copy), TweenService (copy)
    return RuntimeLib.Promise.new(function(u17) -- Line: 60
        -- upvalues: TweenService (ref), u14 (copy), u16 (copy), u15 (copy)
        local u18 = TweenService:Create(u14.circle, u16, {
            Size = u15
        });
        u18.Completed:Once(function() -- Line: 64
            -- upvalues: u18 (copy), u17 (copy)
            u18:Destroy();
            u17();
        end);
        u18:Play();
    end);
end;

Reflect.defineMetadata(u3, "identifier", "client/controllers/world/TransitionController@TransitionController");
Reflect.defineMetadata(u3, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u3, "$:flamework@Controller", Controller, { {} });

return {
    TransitionController = u3
};