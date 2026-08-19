-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect;
local Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller;
local TweenService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").TweenService;
local playSound = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "sound", "SoundUtil").playSound;
local u1 = setmetatable({}, {
    __tostring = function() -- Line: 14, Name: __tostring
        return "MusicController";
    end
});
u1.__index = u1;

function u1.new(...) -- Line: 19
    -- upvalues: u1 (ref)
    local v2 = setmetatable({}, u1);

    return v2:constructor(...) or v2;
end;

function u1.constructor(p3) -- Line: 23
end;

function u1.onStart(p4) -- Line: 25
    -- upvalues: playSound (copy)
    p4.player = playSound("Music", {
        looped = true,
        volume = 0.02
    });
end;

function u1.duck(p5) -- Line: 31
    p5:tweenVolume(0.01, 0.25);
end;

function u1.restore(p6) -- Line: 34
    p6:tweenVolume(0.02, 0.6);
end;

function u1.tweenVolume(p7, p8, p9) -- Line: 37
    -- upvalues: TweenService (copy)
    if not p7.player then
        return nil;
    end;

    local volumeTween = p7.volumeTween;

    if volumeTween ~= nil then
        volumeTween:Cancel();
    end;

    p7.volumeTween = TweenService:Create(p7.player, TweenInfo.new(p9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = p8
    });
    p7.volumeTween:Play();
end;

Reflect.defineMetadata(u1, "identifier", "client/controllers/misc/MusicController@MusicController");
Reflect.defineMetadata(u1, "flamework:implements", { "$:flamework@OnStart" });
Reflect.decorate(u1, "$:flamework@Controller", Controller, { {} });

return {
    MusicController = u1
};