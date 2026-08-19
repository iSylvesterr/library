-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local ToolSetup = require(ReplicatedStorage.Library.Util.ToolSetup);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local ShakePresets = require(ReplicatedStorage.Library.Modules.ShakePresets);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Boogie = require(ReplicatedStorage.Directory.Gears._Index.Other.Boogie);
local Boogie2 = Constants.NETWORK_MAP.Boogie;
local u2 = Asserts.defined(Players.LocalPlayer);
local u3 = Trove.new();
local CurrentCamera = workspace.CurrentCamera;
local FieldOfView = CurrentCamera.FieldOfView;

local function playBoogieAnimation(p4) -- Line: 32
    -- upvalues: Asserts (copy), u1 (copy), Boogie (copy), u3 (copy)
    Asserts.Model(p4);
    local v5 = p4:FindFirstChildOfClass("Humanoid");

    if not v5 then
        u1:AtError():Log("[BoogieClient] Humanoid not found");

        return nil;
    end;

    local v6 = v5:FindFirstChildOfClass("Animator");

    if not v6 then
        u1:AtError():Log("[BoogieClient] Animator not found");

        return nil;
    end;

    local Animation = Instance.new("Animation");
    Animation.AnimationId = Boogie.BOOGIE_ANIMATION_ID;
    local u7 = v6:LoadAnimation(Animation);
    u7:Play();
    u3:Add(function() -- Line: 53
        -- upvalues: u7 (copy), Animation (copy)
        if not u7 then
            return;
        end;

        u7:Stop();
        Animation:Destroy();
    end);

    return u7;
end;

local function applyScreenEffects(p8) -- Line: 64
    -- upvalues: u3 (copy), Boogie (copy), Lighting (copy), TweenService (copy), CurrentCamera (copy), FieldOfView (copy), ShakePresets (copy)
    u3:Clean();
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Saturation = Boogie.COLOR_CORRECTION.Saturation;
    ColorCorrectionEffect.Brightness = Boogie.COLOR_CORRECTION.Brightness;
    ColorCorrectionEffect.Contrast = Boogie.COLOR_CORRECTION.Contrast;
    ColorCorrectionEffect.Parent = Lighting;
    u3:Add(ColorCorrectionEffect);
    local u9 = TweenService:Create(CurrentCamera, Boogie.FOV_TWEEN_INFO, {
        FieldOfView = FieldOfView + Boogie.FOV_OFFSET
    });
    u9:Play();
    u3:Add(function() -- Line: 78
        -- upvalues: u9 (copy), CurrentCamera (ref), FieldOfView (ref)
        u9:Cancel();
        CurrentCamera.FieldOfView = FieldOfView;
    end);
    local u10 = TweenService:Create(ColorCorrectionEffect, Boogie.COLOR_CORRECTION_TWEEN_INFO, {
        Brightness = Boogie.COLOR_CORRECTION_TWEEN.Brightness
    });
    u10:Play();
    u3:Add(function() -- Line: 87
        -- upvalues: u10 (copy)
        u10:Cancel();
    end);
    local v11 = ShakePresets[Boogie.SHAKE_PRESET]:Clone();
    u3:Add((ShakePresets.BindShakeToCamera(v11, CurrentCamera)));
    u3:Add(task.delay(p8, function() -- Line: 95
        -- upvalues: u3 (ref)
        u3:Clean();
    end));
end;

local function playBoogieSFX() -- Line: 100
    print("Boogie SFX");
end;

ToolSetup.Initialize(Boogie.DisplayName, {
    onActivated = function(p12) -- Line: 122, Name: onActivated
        -- upvalues: Network (copy), Boogie2 (copy)
        Network.Fire(Boogie2.REQUEST_BOOGIE);
    end
});
Network.Fired(Boogie2.APPLY_EFFECT):Connect(function(p13) -- Line: 104, Name: onBoogieEffectApplied
    -- upvalues: applyScreenEffects (copy), u2 (copy), playBoogieAnimation (copy)
    applyScreenEffects(p13);
    print("Boogie SFX");
    local Character = u2.Character;

    if Character then
        playBoogieAnimation(Character);
    end;
end);
Network.Fired(Boogie2.REMOVE_EFFECT):Connect(function() -- Line: 114, Name: onBoogieEffectRemoved
    -- upvalues: u3 (copy)
    u3:Clean();
end);
Network.Fired(Boogie2.PLAY_SFX):Connect(function() -- Line: 118, Name: onPlaySFX
    print("Boogie SFX");
end);