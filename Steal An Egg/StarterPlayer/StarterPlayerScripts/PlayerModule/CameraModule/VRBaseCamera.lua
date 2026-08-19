-- Decompiled with Potassium's decompiler.

local success, result = pcall(function() -- Line: 17
    return UserSettings():IsUserFeatureEnabled("UserVRVehicleCamera2");
end);
local u1 = success and result;
local VRService = game:GetService("VRService");
local LocalPlayer = game:GetService("Players").LocalPlayer;
local Lighting = game:GetService("Lighting");
local RunService = game:GetService("RunService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local u2 = require(CommonUtils:WaitForChild("FlagUtil")).getUserFlag("UserCameraInputDt");
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"));
local u3 = setmetatable({}, BaseCamera);
u3.__index = u3;

function u3.new() -- Line: 41
    -- upvalues: BaseCamera (copy), u3 (copy)
    local v4 = BaseCamera.new();
    local v5 = setmetatable(v4, u3);
    v5.gamepadZoomLevels = { 0, 7 };
    v5.headScale = 1;
    v5:SetCameraToSubjectDistance(7);
    v5.VRFadeResetTimer = 0;
    v5.VREdgeBlurTimer = 0;
    v5.gamepadResetConnection = nil;
    v5.needsReset = true;
    v5.recentered = false;
    v5:Reset();

    return v5;
end;

function u3.Reset(p6) -- Line: 67
    p6.stepRotateTimeout = 0;
end;

function u3.GetModuleName(p7) -- Line: 71
    return "VRBaseCamera";
end;

function u3.GamepadZoomPress(p8) -- Line: 75
    -- upvalues: BaseCamera (copy)
    BaseCamera.GamepadZoomPress(p8);
    p8:GamepadReset();
    p8:ResetZoom();
end;

function u3.GamepadReset(p9) -- Line: 83
    p9.stepRotateTimeout = 0;
    p9.needsReset = true;
end;

function u3.ResetZoom(p10) -- Line: 88
    -- upvalues: ZoomController (copy)
    ZoomController.SetZoomParameters(p10.currentSubjectDistance, 0);
    ZoomController.ReleaseSpring();
end;

function u3.OnEnabledChanged(u11) -- Line: 93
    -- upvalues: BaseCamera (copy), CameraInput (copy), VRService (copy), u1 (ref), LocalPlayer (copy), Lighting (copy)
    BaseCamera.OnEnabledChanged(u11);

    if u11.enabled then
        u11.gamepadResetConnection = CameraInput.gamepadReset:Connect(function() -- Line: 97
            -- upvalues: u11 (copy)
            u11:GamepadReset();
        end);
        u11.thirdPersonOptionChanged = VRService:GetPropertyChangedSignal("ThirdPersonFollowCamEnabled"):Connect(function() -- Line: 102
            -- upvalues: u1 (ref), u11 (copy)
            if u1 then
                u11:Reset();

                return;
            end;

            if not u11:IsInFirstPerson() then
                u11:Reset();
            end;
        end);
        u11.vrRecentered = VRService.UserCFrameChanged:Connect(function(p12, p13) -- Line: 113
            -- upvalues: u11 (copy)
            if p12 == Enum.UserCFrame.Floor then
                u11.recentered = true;
            end;
        end);

        return;
    end;

    if u11.inFirstPerson then
        u11:GamepadZoomPress();
    end;

    if u11.thirdPersonOptionChanged then
        u11.thirdPersonOptionChanged:Disconnect();
        u11.thirdPersonOptionChanged = nil;
    end;

    if u11.vrRecentered then
        u11.vrRecentered:Disconnect();
        u11.vrRecentered = nil;
    end;

    if u11.cameraHeadScaleChangedConn then
        u11.cameraHeadScaleChangedConn:Disconnect();
        u11.cameraHeadScaleChangedConn = nil;
    end;

    if u11.gamepadResetConnection then
        u11.gamepadResetConnection:Disconnect();
        u11.gamepadResetConnection = nil;
    end;

    u11.VREdgeBlurTimer = 0;
    u11:UpdateEdgeBlur(LocalPlayer, 1);
    local VRFade = Lighting:FindFirstChild("VRFade");

    if VRFade then
        VRFade.Brightness = 0;
    end;
end;

function u3.OnCurrentCameraChanged(u14) -- Line: 155
    -- upvalues: BaseCamera (copy)
    BaseCamera.OnCurrentCameraChanged(u14);

    if u14.cameraHeadScaleChangedConn then
        u14.cameraHeadScaleChangedConn:Disconnect();
        u14.cameraHeadScaleChangedConn = nil;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        u14.cameraHeadScaleChangedConn = CurrentCamera:GetPropertyChangedSignal("HeadScale"):Connect(function() -- Line: 167
            -- upvalues: u14 (copy)
            u14:OnHeadScaleChanged();
        end);
        u14:OnHeadScaleChanged();
    end;
end;

function u3.OnHeadScaleChanged(p15) -- Line: 172
    local HeadScale = workspace.CurrentCamera.HeadScale;

    for i, v in p15.gamepadZoomLevels do
        p15.gamepadZoomLevels[i] = v * HeadScale / p15.headScale;
    end;

    p15:SetCameraToSubjectDistance(p15:GetCameraToSubjectDistance() * HeadScale / p15.headScale);
    p15.headScale = HeadScale;
end;

function u3.GetVRFocus(p16, p17, p18) -- Line: 188
    local v19 = p16.lastCameraFocus or p17;
    local x = p16.cameraTranslationConstraints.x;
    local v20 = math.min(1, p16.cameraTranslationConstraints.y + p18);
    p16.cameraTranslationConstraints = Vector3.new(x, v20, p16.cameraTranslationConstraints.z);
    local v21 = p16:GetCameraHeight();
    local v22 = Vector3.new(0, v21, 0);

    return CFrame.new(Vector3.new(p17.x, v19.y, p17.z):Lerp(p17 + v22, p16.cameraTranslationConstraints.y));
end;

function u3.StartFadeFromBlack(p23) -- Line: 204
    -- upvalues: UserGameSettings (copy), Lighting (copy)
    if UserGameSettings.VignetteEnabled == false then
        return;
    end;

    local VRFade = Lighting:FindFirstChild("VRFade");

    if not VRFade then
        VRFade = Instance.new("ColorCorrectionEffect");
        VRFade.Name = "VRFade";
        VRFade.Parent = Lighting;
    end;

    VRFade.Brightness = -1;
    p23.VRFadeResetTimer = 0.1;
end;

function u3.UpdateFadeFromBlack(p24, p25) -- Line: 219
    -- upvalues: Lighting (copy)
    local VRFade = Lighting:FindFirstChild("VRFade");

    if p24.VRFadeResetTimer > 0 then
        p24.VRFadeResetTimer = math.max(p24.VRFadeResetTimer - p25, 0);
        local VRFade2 = Lighting:FindFirstChild("VRFade");

        if VRFade2 and VRFade2.Brightness < 0 then
            VRFade2.Brightness = math.min(VRFade2.Brightness + p25 * 10, 0);
        end;
    elseif VRFade then
        VRFade.Brightness = 0;
    end;
end;

function u3.StartVREdgeBlur(p26, p27) -- Line: 235
    -- upvalues: UserGameSettings (copy), RunService (copy), VRService (copy)
    if UserGameSettings.VignetteEnabled == false then
        return;
    end;

    local VRBlurPart = workspace.CurrentCamera:FindFirstChild("VRBlurPart");

    if not VRBlurPart then
        VRBlurPart = Instance.new("Part");
        VRBlurPart.Name = "VRBlurPart";
        VRBlurPart.Parent = workspace.CurrentCamera;
        VRBlurPart.CanTouch = false;
        VRBlurPart.CanCollide = false;
        VRBlurPart.CanQuery = false;
        VRBlurPart.Anchored = true;
        VRBlurPart.Size = Vector3.new(0.44, 0.47, 1);
        VRBlurPart.Transparency = 1;
        VRBlurPart.CastShadow = false;
        RunService.RenderStepped:Connect(function(p28) -- Line: 255
            -- upvalues: VRService (ref), VRBlurPart (ref)
            local v29 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
            local v30 = workspace.CurrentCamera.CFrame * (CFrame.new(v29.p * workspace.CurrentCamera.HeadScale) * (v29 - v29.p));
            VRBlurPart.CFrame = v30 * CFrame.Angles(0, 3.141592653589793, 0) + v30.LookVector * (1.05 * workspace.CurrentCamera.HeadScale);
            VRBlurPart.Size = Vector3.new(0.44, 0.47, 1) * workspace.CurrentCamera.HeadScale;
        end);
    end;

    local VRBlurScreen = p27.PlayerGui:FindFirstChild("VRBlurScreen");
    local v31;

    if VRBlurScreen then
        v31 = VRBlurScreen:FindFirstChild("VRBlur");
    else
        v31 = nil;
    end;

    if not v31 then
        local v32 = VRBlurScreen or (Instance.new("SurfaceGui") or Instance.new("ScreenGui"));
        v32.Name = "VRBlurScreen";
        v32.Parent = p27.PlayerGui;
        v32.Adornee = VRBlurPart;
        v31 = Instance.new("ImageLabel");
        v31.Name = "VRBlur";
        v31.Parent = v32;
        v31.Image = "rbxasset://textures/ui/VR/edgeBlur.png";
        v31.AnchorPoint = Vector2.new(0.5, 0.5);
        v31.Position = UDim2.new(0.5, 0, 0.5, 0);
        v31.Size = UDim2.fromScale(workspace.CurrentCamera.ViewportSize.X * 2.3 / 512, workspace.CurrentCamera.ViewportSize.Y * 2.3 / 512);
        v31.BackgroundTransparency = 1;
        v31.Active = true;
        v31.ScaleType = Enum.ScaleType.Stretch;
    end;

    v31.Visible = true;
    v31.ImageTransparency = 0;
    p26.VREdgeBlurTimer = 0.14;
end;

function u3.UpdateEdgeBlur(p33, p34, p35) -- Line: 304
    local VRBlurScreen = p34.PlayerGui:FindFirstChild("VRBlurScreen");
    local v36;

    if VRBlurScreen then
        v36 = VRBlurScreen:FindFirstChild("VRBlur");
    else
        v36 = nil;
    end;

    if v36 then
        if p33.VREdgeBlurTimer > 0 then
            p33.VREdgeBlurTimer = p33.VREdgeBlurTimer - p35;
            local VRBlurScreen2 = p34.PlayerGui:FindFirstChild("VRBlurScreen");
            local v37 = VRBlurScreen2 and VRBlurScreen2:FindFirstChild("VRBlur");

            if v37 then
                v37.ImageTransparency = 1 - math.clamp(p33.VREdgeBlurTimer, 0.01, 0.14) * 7.142857142857142;
            end;
        else
            v36.Visible = false;
        end;
    end;
end;

function u3.GetCameraHeight(p38) -- Line: 329
    return p38.inFirstPerson and 0 or 0.25881904510252074 * p38.currentSubjectDistance;
end;

function u3.GetSubjectCFrame(p39) -- Line: 336
    -- upvalues: BaseCamera (copy)
    local v40 = BaseCamera.GetSubjectCFrame(p39);
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return v40;
    end;

    if CurrentCamera:IsA("Humanoid") and (CurrentCamera:GetState() == Enum.HumanoidStateType.Dead and CurrentCamera == p39.lastSubject) then
        v40 = p39.lastSubjectCFrame;
    end;

    if v40 then
        p39.lastSubjectCFrame = v40;
    end;

    return v40;
end;

function u3.GetSubjectPosition(p41) -- Line: 362
    -- upvalues: BaseCamera (copy)
    local v42 = BaseCamera.GetSubjectPosition(p41);
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera:IsA("Humanoid") then
        if CurrentCamera:GetState() == Enum.HumanoidStateType.Dead and CurrentCamera == p41.lastSubject then
            v42 = p41.lastSubjectPosition;
        end;
    elseif CurrentCamera:IsA("VehicleSeat") then
        v42 = CurrentCamera.CFrame.p + CurrentCamera.CFrame:vectorToWorldSpace(Vector3.new(0, 4, 0));
    end;

    p41.lastSubjectPosition = v42;

    return v42;
end;

function u3.getRotation(p43, p44) -- Line: 391
    -- upvalues: CameraInput (copy), UserGameSettings (copy), u2 (copy)
    local v45 = CameraInput.getRotation(p44);

    if UserGameSettings.VRSmoothRotationEnabled then
        if u2 then
            return v45.X;
        end;

        return v45.X * 40 * p44;
    end;

    if math.abs(v45.X) > 0.03 then
        if p43.stepRotateTimeout > 0 then
            p43.stepRotateTimeout = p43.stepRotateTimeout - p44;
        end;

        if p43.stepRotateTimeout <= 0 then
            local v46 = (v45.X < 0 and -1 or 1) * 0.5235987755982988;
            p43:StartFadeFromBlack();
            p43.stepRotateTimeout = 0.25;

            return v46;
        end;
    elseif math.abs(v45.X) < 0.02 then
        p43.stepRotateTimeout = 0;
    end;

    return 0;
end;

return u3;