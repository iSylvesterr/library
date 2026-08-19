-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Shake = require(ReplicatedStorage.Library.Modules.Packages.Shake);
local v1 = {
    Bump = Shake.new()
};
v1.Bump.Amplitude = 2.5;
v1.Bump.Frequency = 0.25;
v1.Bump.FadeInTime = 0.1;
v1.Bump.FadeOutTime = 0.75;
v1.Bump.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
v1.Bump.RotationInfluence = Vector3.new(1, 1, 1);
v1.BumpS = Shake.new();
v1.BumpS.Amplitude = 1.5;
v1.BumpS.Frequency = 0.25;
v1.BumpS.FadeInTime = 0.1;
v1.BumpS.FadeOutTime = 0.75;
v1.BumpS.PositionInfluence = Vector3.new(0.15, 0.15, 0.15);
v1.BumpS.RotationInfluence = Vector3.new(1, 1, 1);
v1.Explosion = Shake.new();
v1.Explosion.Amplitude = 5;
v1.Explosion.Frequency = 0.1;
v1.Explosion.FadeInTime = 0;
v1.Explosion.FadeOutTime = 1.5;
v1.Explosion.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
v1.Explosion.RotationInfluence = Vector3.new(4, 1, 1);
v1.Earthquake = Shake.new();
v1.Earthquake.Amplitude = 0.6;
v1.Earthquake.Frequency = 0.2857142857142857;
v1.Earthquake.FadeInTime = 2;
v1.Earthquake.FadeOutTime = 10;
v1.Earthquake.PositionInfluence = Vector3.new(0.25, 0.25, 0.25);
v1.Earthquake.RotationInfluence = Vector3.new(1, 1, 4);
v1.BadTrip = Shake.new();
v1.BadTrip.Amplitude = 10;
v1.BadTrip.Frequency = 6.666666666666667;
v1.BadTrip.FadeInTime = 5;
v1.BadTrip.FadeOutTime = 10;
v1.BadTrip.PositionInfluence = Vector3.new(0, 0, 0.15);
v1.BadTrip.RotationInfluence = Vector3.new(2, 1, 4);
v1.HandheldCamera = Shake.new();
v1.HandheldCamera.Amplitude = 1;
v1.HandheldCamera.Frequency = 0.25;
v1.HandheldCamera.FadeInTime = 5;
v1.HandheldCamera.FadeOutTime = 10;
v1.HandheldCamera.PositionInfluence = Vector3.new(0, 0, 0);
v1.HandheldCamera.RotationInfluence = Vector3.new(1, 0.5, 0.5);
v1.Vibration = Shake.new();
v1.Vibration.Amplitude = 0.4;
v1.Vibration.Frequency = 0.05;
v1.Vibration.FadeInTime = 2;
v1.Vibration.FadeOutTime = 2;
v1.Vibration.PositionInfluence = Vector3.new(0, 0.15, 0);
v1.Vibration.RotationInfluence = Vector3.new(1.25, 0, 4);
v1.RoughDriving = Shake.new();
v1.RoughDriving.Amplitude = 1;
v1.RoughDriving.Frequency = 0.5;
v1.RoughDriving.FadeInTime = 1;
v1.RoughDriving.FadeOutTime = 1;
v1.RoughDriving.PositionInfluence = Vector3.new(0, 0, 0);
v1.RoughDriving.RotationInfluence = Vector3.new(1, 1, 1);

function v1.BindShakeToCamera(u2, p3) -- Line: 79
    -- upvalues: Shake (copy), RunService (copy)
    local u4 = p3 or workspace.CurrentCamera;
    assert(u4, "camera not found");
    local u5 = nil;
    local u6 = nil;
    local u7 = true;
    u2:BindToRenderStep(Shake.NextRenderName(), Enum.RenderPriority.Last.Value, function(p8, p9, p10) -- Line: 90
        -- upvalues: u5 (ref), u4 (ref), u7 (ref), u6 (ref)
        u5 = u4.CFrame;
        u4.CFrame = u4.CFrame * (CFrame.new(p8) * CFrame.Angles(0, math.rad(p9.Y), 0) * CFrame.Angles(math.rad(p9.X), 0, (math.rad(p9.Z))));

        if p10 then
            u7 = false;

            if u6 then
                u6:Disconnect();
                u6 = nil;
            end;
        end;
    end);

    if u7 then
        u6 = RunService.PostSimulation:Connect(function() -- Line: 109
            -- upvalues: u5 (ref), u4 (ref)
            if u5 then
                u4.CFrame = u5;
            end;
        end);
    end;

    return function() -- Line: 116
        -- upvalues: u6 (ref), u2 (copy)
        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        u2:Destroy();
    end;
end;

return v1;