-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FastTween = require(ReplicatedStorage.Library.Functions.FastTween);
require(script.Types.Interface);
local u1 = Color3.fromRGB(191, 0, 3);
local u2 = TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local u3 = {};
u3.__index = u3;
u3.__class = "GuardRunBackEffects";

function u3.new() -- Line: 40
    -- upvalues: u3 (copy), PlayerGui (copy)
    local v4 = setmetatable({}, u3);
    local RunBackEffects = PlayerGui:WaitForChild("RunBackEffects");
    local v5 = RunBackEffects:IsA("ScreenGui");
    assert(v5, "PlayerGui.RunBackEffects must be a ScreenGui");
    local Run = RunBackEffects:WaitForChild("Run");
    local v6 = Run:IsA("GuiObject");
    assert(v6, "RunBackEffects.Run must be a GuiObject");
    local Blur = RunBackEffects:WaitForChild("Blur");
    local v7 = Blur:IsA("ImageLabel");
    assert(v7, "RunBackEffects.Blur must be an ImageLabel");
    v4._activeSerial = 0;
    v4._blurOriginalTransparency = Blur.ImageTransparency;
    v4._blurTween = nil;
    v4._runOriginalColor = Run.BackgroundColor3;
    v4._runTween = nil;
    v4._widgets = {
        Blur = Blur,
        Run = Run,
        ScreenGui = RunBackEffects
    };
    v4:_init();

    return v4;
end;

function u3._cancelTweens(p8) -- Line: 70
    local _blurTween = p8._blurTween;

    if _blurTween ~= nil then
        _blurTween:Cancel();
        _blurTween:Destroy();
    end;

    p8._blurTween = nil;
    local _runTween = p8._runTween;

    if _runTween ~= nil then
        _runTween:Cancel();
        _runTween:Destroy();
    end;

    p8._runTween = nil;
end;

function u3._resetVisualState(p9) -- Line: 86
    local _widgets = p9._widgets;
    _widgets.Blur.ImageTransparency = p9._blurOriginalTransparency;
    _widgets.Run.BackgroundColor3 = p9._runOriginalColor;
    _widgets.ScreenGui.Enabled = false;
end;

function u3._playCycle(u10, u11, u12) -- Line: 93
    -- upvalues: u1 (copy), FastTween (copy), u2 (copy)
    if u11 ~= u10._activeSerial then
        return;
    end;

    local _widgets = u10._widgets;
    local v13 = u12 and 1 or u10._blurOriginalTransparency;
    local v14;

    if u12 then
        v14 = u1;
    else
        v14 = u10._runOriginalColor;
    end;

    u10:_cancelTweens();
    u10._blurTween = FastTween(_widgets.Blur, u2, {
        ImageTransparency = v13
    });
    u10._runTween = FastTween(_widgets.Run, u2, {
        BackgroundColor3 = v14
    });
    local _blurTween = u10._blurTween;
    local _runTween = u10._runTween;
    assert(_blurTween ~= nil, "Blur tween must exist during run-back effect cycle");
    assert(_runTween ~= nil, "Run tween must exist during run-back effect cycle");
    task.spawn(function() -- Line: 115
        -- upvalues: _blurTween (copy), u11 (copy), u10 (copy), u12 (copy)
        _blurTween.Completed:Wait();

        if u11 ~= u10._activeSerial then
            return;
        end;

        u10:_playCycle(u11, not u12);
    end);
end;

function u3.Start(p15) -- Line: 129
    p15._activeSerial = p15._activeSerial + 1;
    local _widgets = p15._widgets;
    _widgets.ScreenGui.Enabled = true;
    _widgets.Blur.ImageTransparency = p15._blurOriginalTransparency;
    _widgets.Run.BackgroundColor3 = p15._runOriginalColor;
    p15:_playCycle(p15._activeSerial, true);
end;

function u3.Stop(p16) -- Line: 138
    p16._activeSerial = p16._activeSerial + 1;
    p16:_cancelTweens();
    p16:_resetVisualState();
end;

function u3._init(p17) -- Line: 148
    p17:Stop();
end;

return u3;