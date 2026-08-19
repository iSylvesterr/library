-- Decompiled with Potassium's decompiler.

local Lighting = game:GetService("Lighting");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Audio = require(ReplicatedStorage.Library.Audio);
local Flash = require(ReplicatedStorage.Library.Client.GUIFX.Flash);
local Functions = require(ReplicatedStorage.Library.Functions);
local u1 = {
    BIG_SUSPENSE_SFX = { "rbxassetid://117036144605831" },
    TICK_SFX = { "rbxassetid://87230100487320" }
};
local DepthOfField = script.DepthOfField;
local CurrentCamera = workspace.CurrentCamera;
local FieldOfView = CurrentCamera.FieldOfView;

return function(p2) -- Line: 41
    -- upvalues: Audio (copy), u1 (copy), DepthOfField (copy), Lighting (copy), Functions (copy), TweenService (copy), CurrentCamera (copy), Flash (copy), FieldOfView (copy)
    local v3 = (not p2 or p2.PlayBlur == nil) and true or p2.PlayBlur;
    local v4 = (not p2 or p2.PlayFlash == nil) and true or p2.PlayFlash;
    local v5 = (not p2 or p2.PlaySuspenseSound == nil) and true or p2.PlaySuspenseSound;
    local v6 = (not p2 or p2.PlayTickSound == nil) and true or p2.PlayTickSound;
    local v7;

    if p2 and p2.Duration ~= nil then
        v7 = p2.Duration;
    else
        v7 = nil;
    end;

    local v8 = (not p2 or p2.SpeedMultiplier == nil) and 1 or p2.SpeedMultiplier;
    assert(v8 > 0, "AmazingImpactVFX speed multiplier must be positive");

    if v7 ~= nil then
        assert(v7 > 0, "AmazingImpactVFX duration must be positive");
    end;

    local v9;

    if v7 == nil then
        v9 = 1.75 * (1 / v8);
    else
        v9 = v7 * 0.9210526315789475;
    end;

    local v10;

    if v7 == nil then
        v10 = 0.15 * (1 / v8);
    else
        v10 = v7 * 0.07894736842105263;
    end;

    local u11 = v9 / 1.75;
    local v12;

    if v5 then
        v12 = Audio.Play(u1.BIG_SUSPENSE_SFX, script, v8, 3.5);
    else
        v12 = nil;
    end;

    local v13;

    if v3 then
        v13 = DepthOfField:Clone();
    else
        v13 = nil;
    end;

    if v13 ~= nil then
        v13.Parent = Lighting;
    end;

    local v14;

    if v12 == nil then
        v14 = 1.1 * u11;
    else
        v14 = v12.TimeLength / v8 + 1.1 * u11;
    end;

    task.delay(math.min(v9, v14), function() -- Line: 81
        -- upvalues: Functions (ref)
        Functions.Vibrate(0.25, nil, Enum.VibrationMotor.Small);
        Functions.Vibrate(1, nil, Enum.VibrationMotor.Large);
    end);
    TweenService:Create(CurrentCamera, TweenInfo.new(v9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
        FieldOfView = 120
    }):Play();

    if v4 then
        Flash(v9, 0.1 * u11, Color3.new(1, 1, 1), 0.2);
    end;

    local u15 = script.Hyperspace:Clone();
    local Size = u15.Size;
    local u16 = Size + Vector3.new(80, 40, 0);
    local Lines = u15:FindFirstChild("Lines");
    local v17;

    if Lines == nil then
        v17 = false;
    else
        v17 = Lines:IsA("ParticleEmitter");
    end;

    assert(v17, "AmazingImpactVFX.Hyperspace.Lines must be a ParticleEmitter");
    u15.Parent = workspace:WaitForChild("__DEBRIS");
    local u18 = 120 - FieldOfView;
    local u19 = 0;
    local u20 = nil;
    u20 = Functions.BindToRenderStep("AmazingImpactVFX", Enum.RenderPriority.Camera.Value + 1, function(p21) -- Line: 113
        -- upvalues: u15 (copy), u20 (ref), u19 (ref), CurrentCamera (ref), FieldOfView (ref), u18 (copy), Size (copy), u16 (copy), u11 (copy), Lines (copy)
        if not u15.Parent then
            local v22 = u20;

            if v22 ~= nil then
                u20 = nil;
                v22();
            end;

            return;
        end;

        u19 = u19 + p21;
        local v23 = Size:Lerp(u16, (math.clamp((CurrentCamera.FieldOfView - FieldOfView) / u18, 0, 1)));
        u15.CFrame = CFrame.lookAt(CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 50, CurrentCamera.CFrame.Position);
        u15.Size = v23;

        if u19 > 0.0025 * u11 then
            u19 = 0;
            Lines:Emit(1);
        end;
    end);
    task.wait(v9);
    Functions.AddDebris(u15, 1);

    if v13 ~= nil then
        Functions.AddDebris(v13, 0.2 * u11);
    end;

    if v4 then
        Flash(0, 0.25 * u11, Color3.new(1, 1, 1), 0);
    end;

    TweenService:Create(CurrentCamera, TweenInfo.new(v10, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        FieldOfView = FieldOfView
    }):Play();

    if v6 then
        Audio.Play(u1.TICK_SFX, script, 1, 2.5);
    end;

    task.wait(v10);

    if v12 ~= nil and (v12.Parent ~= nil and v12.IsPlaying) then
        v12:Stop();
    end;

    local v24 = u20;

    if v24 ~= nil then
        u20 = nil;
        v24();
    end;
end;