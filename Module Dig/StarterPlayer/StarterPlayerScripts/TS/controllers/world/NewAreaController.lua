-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local PlayerGui = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "player", "playerConstants").PlayerGui;
local v1 = RuntimeLib.import(script, script.Parent.Parent.Parent, "constants", "ui", "LuckStyles");
local LUCK_GRADIENT_ROTATION = v1.LUCK_GRADIENT_ROTATION;
local formatLuck = v1.formatLuck;
local luckStyleFor = v1.luckStyleFor;
local TextGradient = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "gradient", "TextGradient").TextGradient;
local tweenAndDestroy = RuntimeLib.import(script, script.Parent.Parent.Parent, "utils", "ui", "tween", "playAndDestroy").tweenAndDestroy;
local WFChain = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "instances", "WFChain").WFChain;
local u2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u4 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
local u5 = Color3.new(1, 1, 1);
local u6 = setmetatable({}, {
    __tostring = function() -- Line: 25, Name: __tostring
        return "NewAreaController";
    end
});
u6.__index = u6;

function u6.new(...) -- Line: 30
    -- upvalues: u6 (ref)
    local v7 = setmetatable({}, u6);

    return v7:constructor(...) or v7;
end;

function u6.constructor(p8) -- Line: 34
    p8.sequence = 0;
end;

function u6.onStart(p9) -- Line: 37
    -- upvalues: WFChain (copy), PlayerGui (copy)
    p9.screen = WFChain(PlayerGui, "NewArea");
    p9.screen.ResetOnSpawn = false;
    p9.screen.Enabled = false;
    p9.container = WFChain(p9.screen, "NameContainer");
    p9.title = WFChain(p9.container, "Title");
    p9.titleStroke = WFChain(p9.title, "UIStroke");
    p9.luck = WFChain(p9.screen, "Luck");
    p9.luckStroke = WFChain(p9.luck, "UIStroke");
end;

function u6.play(u10, p11, p12) -- Line: 47
    -- upvalues: formatLuck (copy), u2 (copy), u3 (copy), u4 (copy), TextGradient (copy)
    u10.sequence = u10.sequence + 1;
    local sequence = u10.sequence;
    u10.title.Text = p11;
    u10.luck.Text = formatLuck(p12);
    u10:styleLuck(p12);
    u10.container.BackgroundTransparency = 1;
    u10.title.TextTransparency = 1;
    u10.titleStroke.Transparency = 1;
    u10.luck.TextTransparency = 1;
    u10.luckStroke.Transparency = 1;
    u10.screen.Enabled = true;
    u10:fadeName(0, u2);
    task.spawn(function() -- Line: 60
        -- upvalues: u10 (copy), sequence (copy), u3 (ref), u4 (ref), TextGradient (ref)
        task.wait(0.9);

        if u10.sequence ~= sequence then
            return nil;
        end;

        u10:fadeLuck(0, u3);
        task.wait(3.35);

        if u10.sequence ~= sequence then
            return nil;
        end;

        u10:fadeName(1, u4);
        u10:fadeLuck(1, u4);
        task.wait(0.5);

        if u10.sequence ~= sequence then
            return nil;
        end;

        u10.screen.Enabled = false;
        TextGradient.clear(u10.luck);
    end);
end;

function u6.styleLuck(p13, p14) -- Line: 80
    -- upvalues: luckStyleFor (copy), u5 (copy), TextGradient (copy), LUCK_GRADIENT_ROTATION (copy)
    local v15 = luckStyleFor(p14);
    p13.luck.TextColor3 = u5;

    if v15 == nil then
        TextGradient.clear(p13.luck);

        return nil;
    end;

    TextGradient.apply(p13.luck, v15.gradient, LUCK_GRADIENT_ROTATION, v15.animationTag);
end;

function u6.fadeName(p16, p17, p18) -- Line: 89
    -- upvalues: tweenAndDestroy (copy)
    tweenAndDestroy(p16.container, p18, {
        BackgroundTransparency = p17
    });
    tweenAndDestroy(p16.title, p18, {
        TextTransparency = p17
    });
    tweenAndDestroy(p16.titleStroke, p18, {
        Transparency = p17
    });
end;

function u6.fadeLuck(p19, p20, p21) -- Line: 100
    -- upvalues: tweenAndDestroy (copy)
    tweenAndDestroy(p19.luck, p21, {
        TextTransparency = p20
    });
    tweenAndDestroy(p19.luckStroke, p21, {
        Transparency = p20
    });
end;

Reflect.defineMetadata(u6, "identifier", "client/controllers/world/NewAreaController@NewAreaController");
Reflect.defineMetadata(u6, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u6, "$:flamework@Controller", Controller, { {} });

return {
    NewAreaController = u6
};