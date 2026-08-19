-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Workspace = game:GetService("Workspace");
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local CurrentCamera = Workspace.CurrentCamera;
local Debris = Workspace:WaitForChild("Debris");
local CaptureController = require(ReplicatedStorage.Controllers.CaptureController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Signal = require(ReplicatedStorage.Packages.Signal);
local Sound = require(ReplicatedStorage.Classes.Sound);
local u1 = Color3.new(1, 1, 1);
local u2 = RaycastParams.new();
u2.CollisionGroup = "Barriers";
u2.FilterType = Enum.RaycastFilterType.Exclude;
u2.IgnoreWater = true;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = 0;
local u17 = nil;
local u18 = Signal.new();
local u19 = Signal.new();

local function IsFlashDebugEnabled() -- Line: 80
    -- upvalues: LocalPlayer (copy)
    local v20 = LocalPlayer:GetAttribute("DebugFlashbang");

    return typeof(v20) ~= "boolean" and true or v20;
end;

local function FlashDebug(p21, ...) -- Line: 89
    -- upvalues: LocalPlayer (copy)
    local v22 = LocalPlayer:GetAttribute("DebugFlashbang");

    if typeof(v22) ~= "boolean" and true or v22 then
    end;
end;

local function CancelTweens() -- Line: 97
    -- upvalues: u6 (ref), u7 (ref)
    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    if u7 then
        u7:Cancel();
        u7 = nil;
    end;
end;

local function CleanupFlash() -- Line: 109
    -- upvalues: u6 (ref), u7 (ref), u3 (ref), u4 (ref), u5 (ref), u10 (ref), u8 (ref), u9 (ref), u13 (ref), u14 (ref), u15 (ref), u19 (copy)
    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    if u7 then
        u7:Cancel();
        u7 = nil;
    end;

    if u3 then
        u3:Destroy();
        u3 = nil;
        u4 = nil;
    end;

    if u5 then
        u5:Destroy();
        u5 = nil;
    end;

    if u10 then
        u10:Cancel();
        u10 = nil;
    end;

    if u8 then
        u8:Destroy();
        u8 = nil;
        u9 = nil;
    end;

    u13 = nil;
    u14 = nil;
    u15 = nil;
    u19:Fire();
end;

local function CreateFlashGui() -- Line: 144
    -- upvalues: u1 (copy), PlayerGui (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "FlashbangEffect";
    ScreenGui.DisplayOrder = 999;
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    local Frame = Instance.new("Frame");
    Frame.Name = "FlashOverlay";
    Frame.Size = UDim2.new(1, 0, 1, 0);
    Frame.Position = UDim2.new(0, 0, 0, 0);
    Frame.BackgroundColor3 = u1;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.ZIndex = 999;
    Frame.Parent = ScreenGui;
    ScreenGui.Parent = PlayerGui;

    return ScreenGui, Frame;
end;

local function CreateColorCorrection() -- Line: 166
    -- upvalues: Lighting (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "FlashbangColorCorrection";
    ColorCorrectionEffect.Brightness = 0;
    ColorCorrectionEffect.Contrast = 0;
    ColorCorrectionEffect.Saturation = 0;
    ColorCorrectionEffect.TintColor = Color3.new(1, 1, 1);
    ColorCorrectionEffect.Parent = Lighting;

    return ColorCorrectionEffect;
end;

local function EnsureFlashInstances() -- Line: 178
    -- upvalues: u3 (ref), u4 (ref), u5 (ref), CreateFlashGui (copy), Lighting (copy)
    local v23 = u3;
    local v24 = u4;
    local v25 = u5;

    if not (v23 and v24) then
        v23, v24 = CreateFlashGui();
        u3 = v23;
        u4 = v24;
    end;

    if not v25 then
        v25 = Instance.new("ColorCorrectionEffect");
        v25.Name = "FlashbangColorCorrection";
        v25.Brightness = 0;
        v25.Contrast = 0;
        v25.Saturation = 0;
        v25.TintColor = Color3.new(1, 1, 1);
        v25.Parent = Lighting;
        u5 = v25;
    end;

    return v23, v24, v25;
end;

local function StartDriver(p26) -- Line: 197
    -- upvalues: u16 (ref), u13 (ref), u14 (ref), u15 (ref), u3 (ref), u4 (ref), u5 (ref), CreateFlashGui (copy), Lighting (copy), u6 (ref), u7 (ref), u18 (copy), TweenService (copy), CleanupFlash (copy)
    task.wait(0.05);

    while u16 == p26 do
        local v27 = u13;
        local v28 = u14;
        local v29 = u15;

        if not (v27 and (v28 and v29)) then
            break;
        end;

        local v30 = os.clock();

        if v27 <= v30 then
            break;
        end;

        local v31 = u3;
        local v32 = u4;
        local v33 = u5;

        if not (v31 and v32) then
            v31, v32 = CreateFlashGui();
            u3 = v31;
            u4 = v32;
        end;

        if not v33 then
            v33 = Instance.new("ColorCorrectionEffect");
            v33.Name = "FlashbangColorCorrection";
            v33.Brightness = 0;
            v33.Contrast = 0;
            v33.Saturation = 0;
            v33.TintColor = Color3.new(1, 1, 1);
            v33.Parent = Lighting;
            u5 = v33;
        end;

        if v30 < v28 then
            if u6 then
                u6:Cancel();
                u6 = nil;
            end;

            if u7 then
                u7:Cancel();
                u7 = nil;
            end;

            v32.BackgroundTransparency = 1 - v29;
            v33.Brightness = v29;
            v33.Saturation = -v29;
            task.wait();
        else
            local v34 = v27 - v30;

            if v34 <= 0 then
                break;
            end;

            u18:Fire();

            if u6 then
                u6:Cancel();
                u6 = nil;
            end;

            if u7 then
                u7:Cancel();
                u7 = nil;
            end;

            u6 = TweenService:Create(v32, TweenInfo.new(v34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            });
            u7 = TweenService:Create(v33, TweenInfo.new(v34, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Brightness = 0,
                Saturation = 0
            });
            u6:Play();
            u7:Play();

            while u16 == p26 do
                local v35 = os.clock();

                if v27 <= v35 or u14 and v35 < u14 then
                    break;
                end;

                task.wait(0.05);
            end;
        end;
    end;

    if u16 == p26 then
        CleanupFlash();
    end;
end;

local function CalculateAdjustedFlashStrength(p36) -- Line: 272
    return 3 - p36 * 0.01309090909090909;
end;

local function CalculateFlashDuration(p37, p38, p39) -- Line: 277
    if p38.Magnitude <= 0 then
        return 0, 0, 0, "zero_direction", 0;
    end;

    local v40 = 3 - p39 * 0.01309090909090909;

    if v40 <= 0 then
        return 0, 0, v40, "zero_strength", 0;
    end;

    local v41 = p37:Dot(p38.Unit);
    local v42 = math.clamp(v41, -1, 1);
    local v43, v44, v45;

    if v42 >= 0.6 then
        v43 = v40 * 2.5;
        v44 = v40 * 1.25;
        v45 = "front";
    elseif v42 >= 0.3 then
        v43 = v40 * 1.75;
        v44 = v40 * 0.8;
        v45 = "side_front";
    elseif v42 >= -0.2 then
        v43 = v40 * 1;
        v44 = v40 * 0.5;
        v45 = "side_back";
    else
        v43 = v40 * 0.5;
        v44 = v40 * 0.25;
        v45 = "back";
    end;

    return v43 / 1.4, v42, v40, v45, v43 <= 0 and 0 or v44 / v43;
end;

local u46 = { -0.5, 0, 0.5 };
local u47 = nil;

local function GetMapBarriers() -- Line: 323
    -- upvalues: u47 (ref), Workspace (copy)
    local v48 = not u47 and Workspace:FindFirstChild("Map");

    if v48 then
        u47 = v48:FindFirstChild("Barriers");
    end;

    return u47;
end;

local function HasLineOfSight(p49, p50) -- Line: 333
    -- upvalues: Debris (copy), LocalPlayer (copy), u47 (ref), Workspace (copy), u2 (copy), u46 (copy)
    debug.profilebegin("VFX.Flash.HasLineOfSight");
    local v51 = { Debris };
    local Character = LocalPlayer.Character;

    if Character then
        table.insert(v51, Character);
    end;

    local v52 = not u47 and Workspace:FindFirstChild("Map");

    if v52 then
        u47 = v52:FindFirstChild("Barriers");
    end;

    local v53 = u47;

    if v53 then
        table.insert(v51, v53);
    end;

    u2.FilterDescendantsInstances = v51;

    for _, v in ipairs(u46) do
        for _, v2 in ipairs(u46) do
            for _, v3 in ipairs(u46) do
                local v54 = p49 + Vector3.new(v, v2, v3);
                local v55 = p50 - v54;
                local Magnitude = v55.Magnitude;

                if Magnitude < 0.1 then
                    return true;
                end;

                local v56 = Workspace:Raycast(v54, v55, u2);

                if not v56 or v56.Distance >= Magnitude - 0.5 then
                    debug.profileend();

                    return true;
                end;
            end;
        end;
    end;

    debug.profileend();

    return false;
end;

return {
    OnFlashRecoveryStarted = u18,
    OnFlashCleared = u19,

    Flash = function(p57) -- Line: 387, Name: Flash
        -- upvalues: FlashDebug (copy), CurrentCamera (copy), HasLineOfSight (copy), CalculateFlashDuration (copy), u11 (ref), u12 (ref), Sound (copy), RunServiceController (copy), u13 (ref), u17 (ref), u15 (ref), u14 (ref), u9 (ref), u10 (ref), TweenService (copy), u8 (ref), u3 (ref), u4 (ref), u5 (ref), CreateFlashGui (copy), Lighting (copy), u6 (ref), u7 (ref), u16 (ref), StartDriver (copy), CaptureController (copy), PlayerGui (copy)
        debug.profilebegin("VFX.Flash");
        local Position = p57.Position;
        local v58 = not p57.Duration and "nil" or string.format("%.3f", p57.Duration);
        FlashDebug("recv pos=(%.2f, %.2f, %.2f) netDuration=%s attacker=%s", Position.X, Position.Y, Position.Z, v58, (tostring(p57.AttackerUserId)));
        local Position2 = CurrentCamera.CFrame.Position;
        local LookVector = CurrentCamera.CFrame.LookVector;
        local u59 = 0;
        local u60;

        if p57.Duration then
            u60 = p57.Duration;
            FlashDebug("spectator_duration=%.3f", u60);
        else
            local v61 = Position - Position2;
            local Magnitude = v61.Magnitude;

            if Magnitude > 229.16666666666669 then
                FlashDebug("skip=out_of_range distance=%.3f radius=%.3f", Magnitude, 229.16666666666669);
                debug.profileend();

                return false;
            end;

            if not HasLineOfSight(Position, Position2) then
                FlashDebug("skip=no_los distance=%.3f", Magnitude);
                debug.profileend();

                return false;
            end;

            debug.profilebegin("VFX.Flash.CalculateDuration");
            local v62, v63, v64, v65, v66 = CalculateFlashDuration(LookVector, v61, Magnitude);
            debug.profileend();
            u60 = v62;
            u59 = v66;
            FlashDebug("calc distance=%.3f dot=%.3f bucket=%s strength=%.3f duration=%.3f sourceHold=%.3f", Magnitude, v63, v65, v64, u60, u59);
        end;

        if u60 < 0.01 then
            FlashDebug("skip=below_threshold duration=%.3f threshold=0.010", u60);
            debug.profileend();

            return false;
        end;

        debug.profilebegin("VFX.Flash.Sound");

        if u11 then
            if u12 then
                u12:Disconnect();
                u12 = nil;
            end;

            if u11.Parent then
                u11:Stop();
                u11:Destroy();
            end;

            u11 = nil;
        end;

        local u67 = Sound.new("Flashbang"):play({
            Name = "Flashed",
            Parent = CurrentCamera
        });

        if u67 then
            u11 = u67;
            local u68 = tick();
            local Volume = u67.Volume;

            local function getFadeMultiplier(p69) -- Line: 476
                return p69 >= 4 and 0 or 1 - p69 * 0.225;
            end;

            u12 = RunServiceController.BindToHeartbeat("VFX.FlashEffect.SoundFade", function() -- Line: 484
                -- upvalues: u68 (copy), u12 (ref), u67 (copy), u11 (ref), Volume (copy)
                local v70 = tick() - u68;

                if v70 >= 4 then
                    if u12 then
                        u12:Disconnect();
                        u12 = nil;
                    end;

                    if u67 and u67.Parent then
                        u67:Stop();
                        u67:Destroy();
                    end;

                    if u11 == u67 then
                        u11 = nil;
                    end;
                else
                    if u67 and u67.Parent then
                        u67.Volume = Volume * (v70 >= 4 and 0 or 1 - v70 * 0.225);

                        return;
                    end;

                    if not (u67 and u67.Parent) then
                        if u12 then
                            u12:Disconnect();
                            u12 = nil;
                        end;

                        if u11 == u67 then
                            u11 = nil;
                        end;
                    end;
                end;
            end);
        end;

        debug.profileend();

        local function applyFlashEffect() -- Line: 520
            -- upvalues: u13 (ref), u60 (ref), FlashDebug (ref), u59 (ref), u17 (ref), u15 (ref), u14 (ref), u9 (ref), u10 (ref), TweenService (ref), u8 (ref), u3 (ref), u4 (ref), u5 (ref), CreateFlashGui (ref), Lighting (ref), u6 (ref), u7 (ref), u16 (ref), StartDriver (ref)
            debug.profilebegin("VFX.Flash.Apply");
            local v71 = os.clock();
            local v72 = u13 and (math.max(0, u13 - v71) or 0) or 0;
            local v73 = math.max(v72, u60);
            local v74 = math.max(0, v73 - 3);
            local v75 = v73 > 3 and 1 or math.clamp((v73 / 3) ^ 0.6, 0, 1);
            FlashDebug("apply incoming=%.3f remaining=%.3f result=%.3f holdWindow=%.3f peakAlpha=%.3f sourceHold=%.3f", u60, v72, v73, v74, v75, u59);
            u17 = v71;
            u13 = v71 + v73;
            u15 = v75;
            local v76 = math.max(u14 or 0, v71 + 0.05 + v74);
            u14 = math.min(u13, v76);

            if u60 >= 4 and u9 then
                if u10 then
                    u10:Cancel();
                    u10 = nil;
                end;

                u9.ImageTransparency = 0;
                local u77 = TweenService:Create(u9, TweenInfo.new(v73, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    ImageTransparency = 1
                });
                u10 = u77;
                u77:Play();
                u77.Completed:Connect(function() -- Line: 577
                    -- upvalues: u8 (ref), u9 (ref), u10 (ref), u77 (copy)
                    if u8 then
                        u8:Destroy();
                        u8 = nil;
                        u9 = nil;
                    end;

                    if u10 == u77 then
                        u10 = nil;
                    end;
                end);
            end;

            local v78 = u3;
            local v79 = u4;
            local v80 = u5;

            if not (v78 and v79) then
                v78, v79 = CreateFlashGui();
                u3 = v78;
                u4 = v79;
            end;

            if not v80 then
                v80 = Instance.new("ColorCorrectionEffect");
                v80.Name = "FlashbangColorCorrection";
                v80.Brightness = 0;
                v80.Contrast = 0;
                v80.Saturation = 0;
                v80.TintColor = Color3.new(1, 1, 1);
                v80.Parent = Lighting;
                u5 = v80;
            end;

            debug.profilebegin("VFX.Flash.Apply.CreateTweens");

            if u6 then
                u6:Cancel();
                u6 = nil;
            end;

            if u7 then
                u7:Cancel();
                u7 = nil;
            end;

            local v81 = TweenService:Create(v79, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1 - v75
            });
            local v82 = TweenService:Create(v80, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Brightness = v75,
                Saturation = -v75
            });
            v81:Play();
            v82:Play();
            debug.profileend();
            u16 = u16 + 1;
            local u83 = u16;
            task.spawn(function() -- Line: 618
                -- upvalues: StartDriver (ref), u83 (copy)
                StartDriver(u83);
            end);
            debug.profileend();
        end;

        if u60 >= 4 then
            debug.profilebegin("VFX.Flash.CaptureScreenshot");
            CaptureController.CaptureScreenshot(function(p84) -- Line: 629
                -- upvalues: u10 (ref), u8 (ref), PlayerGui (ref), u9 (ref), u13 (ref), TweenService (ref)
                debug.profilebegin("VFX.Flash.CaptureScreenshot.Callback");

                if u10 then
                    u10:Cancel();
                    u10 = nil;
                end;

                if u8 then
                    if u9 then
                        u9.Image = p84;
                        u9.ImageTransparency = 0;
                    end;
                else
                    local ScreenGui = Instance.new("ScreenGui");
                    ScreenGui.Name = "FlashScreenshot";
                    ScreenGui.DisplayOrder = 998;
                    ScreenGui.IgnoreGuiInset = true;
                    ScreenGui.ResetOnSpawn = false;
                    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
                    local ImageLabel = Instance.new("ImageLabel");
                    ImageLabel.Name = "ScreenshotImage";
                    ImageLabel.Size = UDim2.new(1, 0, 1, 0);
                    ImageLabel.Position = UDim2.new(0, 0, 0, 0);
                    ImageLabel.BackgroundTransparency = 1;
                    ImageLabel.BorderSizePixel = 0;
                    ImageLabel.Image = p84;
                    ImageLabel.ImageTransparency = 0;
                    ImageLabel.ScaleType = Enum.ScaleType.Fit;
                    ImageLabel.ZIndex = 998;
                    ImageLabel.Parent = ScreenGui;
                    ScreenGui.Parent = PlayerGui;
                    u8 = ScreenGui;
                    u9 = ImageLabel;
                end;

                if u9 then
                    local v85 = os.clock();
                    local v86 = (not u13 or v85 >= u13) and 0 or math.max(0, u13 - v85);
                    local v87 = math.max(v86, 0.01);

                    if u10 then
                        u10:Cancel();
                        u10 = nil;
                    end;

                    local u88 = TweenService:Create(u9, TweenInfo.new(v87, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        ImageTransparency = 1
                    });
                    u10 = u88;
                    u88:Play();
                    u88.Completed:Connect(function() -- Line: 702
                        -- upvalues: u8 (ref), u9 (ref), u10 (ref), u88 (copy)
                        if u8 then
                            u8:Destroy();
                            u8 = nil;
                            u9 = nil;
                        end;

                        if u10 == u88 then
                            u10 = nil;
                        end;
                    end);
                end;

                debug.profileend();
            end):catch(function() -- Line: 714
            end);
            debug.profileend();
            task.delay(0.01, function() -- Line: 720
                -- upvalues: applyFlashEffect (copy)
                applyFlashEffect();
            end);
        else
            applyFlashEffect();
        end;

        debug.profileend();

        return true;
    end,

    CancelFlash = function() -- Line: 733, Name: CancelFlash
        -- upvalues: FlashDebug (copy), u16 (ref), CleanupFlash (copy), u17 (ref), u12 (ref), u11 (ref)
        debug.profilebegin("VFX.Flash.Cancel");
        FlashDebug("cancel");
        u16 = u16 + 1;
        CleanupFlash();
        u17 = nil;

        if u12 then
            u12:Disconnect();
            u12 = nil;
        end;

        if u11 and u11.Parent then
            u11:Stop();
            u11:Destroy();
        end;

        u11 = nil;
        debug.profileend();
    end,

    IsFlashed = function() -- Line: 755, Name: IsFlashed
        -- upvalues: u13 (ref)
        if u13 then
            return os.clock() < u13;
        end;

        return false;
    end,

    GetAudioFadeMultiplier = function() -- Line: 767, Name: GetAudioFadeMultiplier
        -- upvalues: u17 (ref)
        if not u17 then
            return 1;
        end;

        local v89 = os.clock() - u17;

        return v89 >= 1.5 and 1 or (v89 < 0.5 and 0 or math.clamp((v89 - 0.5) / 1, 0, 1));
    end
};