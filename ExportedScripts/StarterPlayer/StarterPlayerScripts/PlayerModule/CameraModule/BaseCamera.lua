-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UserInputService = game:GetService("UserInputService");
local VRService = game:GetService("VRService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"));
local ZoomController = require(script.Parent:WaitForChild("ZoomController"));
local CameraToggleStateController = require(script.Parent:WaitForChild("CameraToggleStateController"));
local CameraInput = require(script.Parent:WaitForChild("CameraInput"));
local CameraUI = require(script.Parent:WaitForChild("CameraUI"));
local LocalPlayer = Players.LocalPlayer;
local success, result = pcall(function() -- Line: 24
    return UserSettings():IsUserFeatureEnabled("UserFixGamepadMaxZoom");
end);
local u1 = success and result;
local u2 = FlagUtil.getUserFlag("UserFixCameraCameraCharacterUpdates");
Vector2.new(0, 0);
local u3 = {};
u3.__index = u3;

function u3.new() -- Line: 83
    -- upvalues: u3 (copy), ConnectionUtil (copy), LocalPlayer (copy), u2 (copy), UserGameSettings (copy)
    local v4 = setmetatable({}, u3);
    v4._connections = ConnectionUtil.new();
    v4.gamepadZoomLevels = { 0, 10, 20 };
    v4.FIRST_PERSON_DISTANCE_THRESHOLD = 1;
    v4.cameraType = nil;
    v4.cameraMovementMode = nil;
    v4.lastCameraTransform = nil;
    v4.lastUserPanCamera = tick();
    v4.humanoidRootPart = nil;
    v4.humanoidCache = {};
    v4.lastSubject = nil;
    v4.lastSubjectPosition = Vector3.new(0, 5, 0);
    v4.lastSubjectCFrame = CFrame.new(v4.lastSubjectPosition);
    v4.currentSubjectDistance = math.clamp(12.5, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);
    v4.inFirstPerson = false;
    v4.inMouseLockedMode = false;
    v4.portraitMode = false;
    v4.isSmallTouchScreen = false;
    v4.resetCameraAngle = true;
    v4.enabled = false;

    if not u2 then
        v4.PlayerGui = nil;
    end;

    v4.cameraChangedConn = nil;
    v4.viewportSizeChangedConn = nil;
    v4.shouldUseVRRotation = false;
    v4.VRRotationIntensityAvailable = false;
    v4.lastVRRotationIntensityCheckTime = 0;
    v4.lastVRRotationTime = 0;
    v4.vrRotateKeyCooldown = {};
    v4.cameraTranslationConstraints = Vector3.new(1, 1, 1);
    v4.humanoidJumpOrigin = nil;
    v4.trackingHumanoid = nil;
    v4.cameraFrozen = false;
    v4.subjectStateChangedConn = nil;
    v4.gamepadZoomPressConnection = nil;
    v4.mouseLockOffset = Vector3.new(0, 0, 0);
    UserGameSettings:SetCameraYInvertVisible();
    UserGameSettings:SetGamepadCameraSensitivityVisible();

    return v4;
end;

function u3.GetModuleName(p5) -- Line: 152
    return "BaseCamera";
end;

function u3._setUpConfigurations(u6) -- Line: 156
    -- upvalues: LocalPlayer (copy), u2 (copy)
    u6._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p7) -- Line: 159
        -- upvalues: u6 (copy)
        u6:OnCharacterAdded(p7);
    end));

    if u2 then
        u6.humanoidRootPart = nil;
    elseif LocalPlayer.Character then
        u6:OnCharacterAdded(LocalPlayer.Character);
    end;

    u6._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- Line: 173
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end));
    u6._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- Line: 179
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end));
    u6._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- Line: 185
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end));
    u6:OnPlayerCameraPropertyChange();
end;

function u3.OnCharacterAdded(u8, p9) -- Line: 192
    -- upvalues: u2 (copy), UserInputService (copy), LocalPlayer (copy)
    u8.resetCameraAngle = u8.resetCameraAngle or u8:GetEnabled();
    u8.humanoidRootPart = nil;

    if not u2 and UserInputService.TouchEnabled then
        u8.PlayerGui = LocalPlayer:WaitForChild("PlayerGui");

        for _, child in ipairs(p9:GetChildren()) do
            if child:IsA("Tool") then
                u8.isAToolEquipped = true;
            end;
        end;

        u8._connections:trackConnection("char.ChildAdded", p9.ChildAdded:Connect(function(p10) -- Line: 207
            -- upvalues: u8 (copy)
            if p10:IsA("Tool") then
                u8.isAToolEquipped = true;
            end;
        end));
        u8._connections:trackConnection("char.ChildRemoved", p9.ChildRemoved:Connect(function(p11) -- Line: 215
            -- upvalues: u8 (copy)
            if p11:IsA("Tool") then
                u8.isAToolEquipped = false;
            end;
        end));
    end;
end;

function u3.GetHumanoidRootPart(p12) -- Line: 225
    -- upvalues: LocalPlayer (copy)
    local v13 = (not p12.humanoidRootPart and LocalPlayer.Character and true or false) and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");

    if v13 then
        p12.humanoidRootPart = v13.RootPart;
    end;

    return p12.humanoidRootPart;
end;

function u3.GetBodyPartToFollow(p14, p15, p16) -- Line: 237
    if p15:GetState() == Enum.HumanoidStateType.Dead then
        local Parent = p15.Parent;

        if Parent and Parent:IsA("Model") then
            return Parent:FindFirstChild("Head") or p15.RootPart;
        end;
    end;

    return p15.RootPart;
end;

function u3.GetSubjectCFrame(p17) -- Line: 249
    local lastSubjectCFrame = p17.lastSubjectCFrame;
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return lastSubjectCFrame;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local v18 = CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = CurrentCamera.CameraOffset;

        if p17:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = CurrentCamera.RootPart;

        if v18 and (CurrentCamera.Parent and CurrentCamera.Parent:IsA("Model")) then
            RootPart = CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v19;

            if CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if CurrentCamera.AutomaticScalingEnabled then
                    v19 = Vector3.new(0, 1.5, 0);
                    local RootPart2 = CurrentCamera.RootPart;

                    if RootPart == RootPart2 then
                        v19 = v19 + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0);
                    end;
                else
                    v19 = Vector3.new(0, 2, 0);
                end;
            else
                v19 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectCFrame = RootPart.CFrame * CFrame.new((v18 and Vector3.new(0, 0, 0) or v19) + CameraOffset);
        end;
    elseif CurrentCamera:IsA("BasePart") then
        lastSubjectCFrame = CurrentCamera.CFrame;
    elseif CurrentCamera:IsA("Model") then
        if CurrentCamera.PrimaryPart then
            lastSubjectCFrame = CurrentCamera:GetPrimaryPartCFrame();
        else
            lastSubjectCFrame = CFrame.new();
        end;
    end;

    if lastSubjectCFrame then
        p17.lastSubjectCFrame = lastSubjectCFrame;
    end;

    return lastSubjectCFrame;
end;

function u3.GetSubjectVelocity(p20) -- Line: 320
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return Vector3.new(0, 0, 0);
    end;

    if CurrentCamera:IsA("BasePart") then
        return CurrentCamera.Velocity;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local RootPart = CurrentCamera.RootPart;

        if RootPart then
            return RootPart.Velocity;
        end;
    else
        local v21 = CurrentCamera:IsA("Model") and CurrentCamera.PrimaryPart;

        if v21 then
            return v21.Velocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u3.GetSubjectRotVelocity(p22) -- Line: 347
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return Vector3.new(0, 0, 0);
    end;

    if CurrentCamera:IsA("BasePart") then
        return CurrentCamera.RotVelocity;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local RootPart = CurrentCamera.RootPart;

        if RootPart then
            return RootPart.RotVelocity;
        end;
    else
        local v23 = CurrentCamera:IsA("Model") and CurrentCamera.PrimaryPart;

        if v23 then
            return v23.RotVelocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u3.StepZoom(p24) -- Line: 374
    -- upvalues: CameraInput (copy), ZoomController (copy)
    local currentSubjectDistance = p24.currentSubjectDistance;
    local v25 = CameraInput.getZoomDelta();

    if math.abs(v25) > 0 then
        local v26;

        if v25 > 0 then
            v26 = math.max(currentSubjectDistance + v25 * (currentSubjectDistance * 0.5 + 1), p24.FIRST_PERSON_DISTANCE_THRESHOLD);
        else
            v26 = math.max((currentSubjectDistance + v25) / (1 - v25 * 0.5), 0);
        end;

        p24:SetCameraToSubjectDistance(v26 < p24.FIRST_PERSON_DISTANCE_THRESHOLD and 0 or v26);
    end;

    return ZoomController.GetZoomRadius();
end;

function u3.GetSubjectPosition(p27) -- Line: 399
    local lastSubjectPosition = p27.lastSubjectPosition;
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local v28 = CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = CurrentCamera.CameraOffset;

        if p27:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = CurrentCamera.RootPart;

        if v28 and (CurrentCamera.Parent and CurrentCamera.Parent:IsA("Model")) then
            RootPart = CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v29;

            if CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if CurrentCamera.AutomaticScalingEnabled then
                    v29 = Vector3.new(0, 1.5, 0);

                    if RootPart == CurrentCamera.RootPart then
                        v29 = v29 + Vector3.new(0, CurrentCamera.RootPart.Size.Y / 2 - 1, 0);
                    end;
                else
                    v29 = Vector3.new(0, 2, 0);
                end;
            else
                v29 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectPosition = RootPart.CFrame.p + RootPart.CFrame:vectorToWorldSpace((v28 and Vector3.new(0, 0, 0) or v29) + CameraOffset);
        end;
    elseif CurrentCamera:IsA("VehicleSeat") then
        lastSubjectPosition = CurrentCamera.CFrame.p + CurrentCamera.CFrame:vectorToWorldSpace(Vector3.new(0, 5, 0));
    elseif CurrentCamera:IsA("SkateboardPlatform") then
        lastSubjectPosition = CurrentCamera.CFrame.p + Vector3.new(0, 5, 0);
    elseif CurrentCamera:IsA("BasePart") then
        lastSubjectPosition = CurrentCamera.CFrame.p;
    elseif CurrentCamera:IsA("Model") then
        if CurrentCamera.PrimaryPart then
            lastSubjectPosition = CurrentCamera:GetPrimaryPartCFrame().p;
        else
            lastSubjectPosition = CurrentCamera:GetModelCFrame().p;
        end;
    end;

    p27.lastSubject = CurrentCamera;
    p27.lastSubjectPosition = lastSubjectPosition;

    return lastSubjectPosition;
end;

function u3.OnViewportSizeChanged(p30) -- Line: 476
    -- upvalues: UserInputService (copy)
    local ViewportSize = workspace.CurrentCamera.ViewportSize;
    p30.portraitMode = ViewportSize.X < ViewportSize.Y;
    p30.isSmallTouchScreen = UserInputService.TouchEnabled and (ViewportSize.Y < 500 and true or ViewportSize.X < 700);
end;

function u3.OnCurrentCameraChanged(u31) -- Line: 484
    -- upvalues: UserInputService (copy)
    if UserInputService.TouchEnabled then
        if u31.viewportSizeChangedConn then
            u31.viewportSizeChangedConn:Disconnect();
            u31.viewportSizeChangedConn = nil;
        end;

        local CurrentCamera = workspace.CurrentCamera;

        if CurrentCamera then
            u31:OnViewportSizeChanged();
            u31.viewportSizeChangedConn = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 495
                -- upvalues: u31 (copy)
                u31:OnViewportSizeChanged();
            end);
        end;
    end;

    if u31.cameraSubjectChangedConn then
        u31.cameraSubjectChangedConn:Disconnect();
        u31.cameraSubjectChangedConn = nil;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        u31.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 509
            -- upvalues: u31 (copy)
            u31:OnNewCameraSubject();
        end);
        u31:OnNewCameraSubject();
    end;
end;

function u3.OnPlayerCameraPropertyChange(p32) -- Line: 516
    p32:SetCameraToSubjectDistance(p32.currentSubjectDistance);
end;

function u3.InputTranslationToCameraAngleChange(p33, p34, p35) -- Line: 521
    return p34 * p35;
end;

function u3.GamepadZoomPress(p36) -- Line: 527
    -- upvalues: LocalPlayer (copy), u1 (ref)
    local v37 = p36:GetCameraToSubjectDistance();
    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance;

    for i = #p36.gamepadZoomLevels, 1, -1 do
        local v38 = p36.gamepadZoomLevels[i];

        if CameraMaxZoomDistance >= v38 then
            if v38 < LocalPlayer.CameraMinZoomDistance then
                v38 = LocalPlayer.CameraMinZoomDistance;

                if u1 and CameraMaxZoomDistance == v38 then
                    break;
                end;
            end;

            if not u1 and CameraMaxZoomDistance == v38 then
                break;
            end;

            if v38 + (CameraMaxZoomDistance - v38) / 2 < v37 then
                p36:SetCameraToSubjectDistance(v38);

                return;
            end;

            CameraMaxZoomDistance = v38;
        end;
    end;

    p36:SetCameraToSubjectDistance(p36.gamepadZoomLevels[#p36.gamepadZoomLevels]);
end;

function u3.Enable(p39, p40) -- Line: 572
    if p39.enabled ~= p40 then
        p39.enabled = p40;
        p39:OnEnabledChanged();
    end;
end;

function u3.OnEnabledChanged(u41) -- Line: 580
    -- upvalues: CameraInput (copy), LocalPlayer (copy)
    if not u41.enabled then
        u41._connections:disconnectAll();
        CameraInput.setInputEnabled(false);

        if u41.gamepadZoomPressConnection then
            u41.gamepadZoomPressConnection:Disconnect();
            u41.gamepadZoomPressConnection = nil;
        end;

        u41:Cleanup();

        return;
    end;

    u41:_setUpConfigurations();
    CameraInput.setInputEnabled(true);
    u41.gamepadZoomPressConnection = CameraInput.gamepadZoomPress:Connect(function() -- Line: 586
        -- upvalues: u41 (copy)
        u41:GamepadZoomPress();
    end);

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        u41.currentSubjectDistance = 0;

        if not u41.inFirstPerson then
            u41:EnterFirstPerson();
        end;
    end;

    if u41.cameraChangedConn then
        u41.cameraChangedConn:Disconnect();
        u41.cameraChangedConn = nil;
    end;

    u41.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 601
        -- upvalues: u41 (copy)
        u41:OnCurrentCameraChanged();
    end);
    u41:OnCurrentCameraChanged();
end;

function u3.GetEnabled(p42) -- Line: 619
    return p42.enabled;
end;

function u3.Cleanup(p43) -- Line: 623
    -- upvalues: CameraUtils (copy)
    if p43.subjectStateChangedConn then
        p43.subjectStateChangedConn:Disconnect();
        p43.subjectStateChangedConn = nil;
    end;

    if p43.viewportSizeChangedConn then
        p43.viewportSizeChangedConn:Disconnect();
        p43.viewportSizeChangedConn = nil;
    end;

    if p43.cameraChangedConn then
        p43.cameraChangedConn:Disconnect();
        p43.cameraChangedConn = nil;
    end;

    p43.lastCameraTransform = nil;
    p43.lastSubjectCFrame = nil;
    CameraUtils.restoreMouseBehavior();
end;

function u3.UpdateMouseBehavior(p44) -- Line: 644
    -- upvalues: UserGameSettings (copy), CameraUI (copy), CameraInput (copy), CameraToggleStateController (copy), CameraUtils (copy)
    if p44.isCameraToggle and UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
        CameraUI.setCameraModeToastEnabled(true);
        CameraInput.enableCameraToggleInput();
        CameraToggleStateController(p44.inFirstPerson);

        return;
    end;

    CameraUI.setCameraModeToastEnabled(false);
    CameraInput.disableCameraToggleInput();

    if p44.inFirstPerson or p44.inMouseLockedMode then
        CameraUtils.setRotationTypeOverride(Enum.RotationType.CameraRelative);
        CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCenter);

        return;
    end;

    CameraUtils.restoreRotationType();

    if CameraInput.getRotationActivated() then
        CameraUtils.setMouseBehaviorOverride(Enum.MouseBehavior.LockCurrentPosition);

        return;
    end;

    CameraUtils.restoreMouseBehavior();
end;

function u3.UpdateForDistancePropertyChange(p45) -- Line: 672
    p45:SetCameraToSubjectDistance(p45.currentSubjectDistance);
end;

function u3.SetCameraToSubjectDistance(p46, p47) -- Line: 678
    -- upvalues: LocalPlayer (copy), ZoomController (copy)
    local currentSubjectDistance = p46.currentSubjectDistance;

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        p46.currentSubjectDistance = 0;

        if not p46.inFirstPerson then
            p46:EnterFirstPerson();
        end;
    else
        local v48 = math.clamp(p47, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);

        if v48 < 1 then
            p46.currentSubjectDistance = 0;

            if not p46.inFirstPerson then
                p46:EnterFirstPerson();
            end;
        else
            p46.currentSubjectDistance = v48;

            if p46.inFirstPerson then
                p46:LeaveFirstPerson();
            end;
        end;
    end;

    ZoomController.SetZoomParameters(p46.currentSubjectDistance, (math.sign(p47 - currentSubjectDistance)));

    return p46.currentSubjectDistance;
end;

function u3.SetCameraType(p49, p50) -- Line: 716
    p49.cameraType = p50;
end;

function u3.GetCameraType(p51) -- Line: 721
    return p51.cameraType;
end;

function u3.SetCameraMovementMode(p52, p53) -- Line: 726
    p52.cameraMovementMode = p53;
end;

function u3.GetCameraMovementMode(p54) -- Line: 730
    return p54.cameraMovementMode;
end;

function u3.SetIsMouseLocked(p55, p56) -- Line: 734
    p55.inMouseLockedMode = p56;
end;

function u3.GetIsMouseLocked(p57) -- Line: 738
    return p57.inMouseLockedMode;
end;

function u3.SetMouseLockOffset(p58, p59) -- Line: 742
    p58.mouseLockOffset = p59;
end;

function u3.GetMouseLockOffset(p60) -- Line: 746
    return p60.mouseLockOffset;
end;

function u3.InFirstPerson(p61) -- Line: 750
    return p61.inFirstPerson;
end;

function u3.EnterFirstPerson(p62) -- Line: 754
    p62.inFirstPerson = true;
    p62:UpdateMouseBehavior();
end;

function u3.LeaveFirstPerson(p63) -- Line: 759
    p63.inFirstPerson = false;
    p63:UpdateMouseBehavior();
end;

function u3.GetCameraToSubjectDistance(p64) -- Line: 765
    return p64.currentSubjectDistance;
end;

function u3.GetMeasuredDistanceToFocus(p65) -- Line: 772
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        return (CurrentCamera.CoordinateFrame.p - CurrentCamera.Focus.p).magnitude;
    end;

    return nil;
end;

function u3.GetCameraLookVector(p66) -- Line: 780
    return workspace.CurrentCamera and workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1);
end;

function u3.CalculateNewLookCFrameFromArg(p67, p68, p69) -- Line: 784
    local v70 = p68 or p67:GetCameraLookVector();
    local v71 = math.asin(v70.Y);
    local v72 = math.clamp(p69.Y, v71 + -1.3962634015954636, v71 + 1.3962634015954636);
    local v73 = Vector2.new(p69.X, v72);
    local v74 = CFrame.new(Vector3.new(0, 0, 0), v70);

    return CFrame.Angles(0, -v73.X, 0) * v74 * CFrame.Angles(-v73.Y, 0, 0);
end;

function u3.CalculateNewLookVectorFromArg(p75, p76, p77) -- Line: 796
    return p75:CalculateNewLookCFrameFromArg(p76, p77).LookVector;
end;

function u3.CalculateNewLookVectorVRFromArg(p78, p79) -- Line: 801
    local unit = ((p78:GetSubjectPosition() - workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit;
    local v80 = Vector2.new(p79.X, 0);
    local v81 = CFrame.new(Vector3.new(0, 0, 0), unit);

    return ((CFrame.Angles(0, -v80.X, 0) * v81 * CFrame.Angles(-v80.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit;
end;

function u3.GetHumanoid(p82) -- Line: 815
    -- upvalues: LocalPlayer (copy)
    local v83 = LocalPlayer and LocalPlayer.Character;

    if not v83 then
        return nil;
    end;

    local v84 = p82.humanoidCache[LocalPlayer];

    if v84 and v84.Parent == v83 then
        return v84;
    end;

    p82.humanoidCache[LocalPlayer] = nil;
    local v85 = v83:FindFirstChildOfClass("Humanoid");

    if v85 then
        p82.humanoidCache[LocalPlayer] = v85;
    end;

    return v85;
end;

function u3.GetHumanoidPartToFollow(p86, p87, p88) -- Line: 833
    if p88 ~= Enum.HumanoidStateType.Dead then
        return p87.Torso;
    end;

    local Parent = p87.Parent;

    if Parent then
        return Parent:FindFirstChild("Head") or p87.Torso;
    end;

    return p87.Torso;
end;

function u3.OnNewCameraSubject(p89) -- Line: 846
    if p89.subjectStateChangedConn then
        p89.subjectStateChangedConn:Disconnect();
        p89.subjectStateChangedConn = nil;
    end;
end;

function u3.IsInFirstPerson(p90) -- Line: 853
    return p90.inFirstPerson;
end;

function u3.Update(p91, p92) -- Line: 857
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2);
end;

function u3.GetCameraHeight(p93) -- Line: 861
    -- upvalues: VRService (copy)
    return (not VRService.VREnabled or p93.inFirstPerson) and 0 or 0.25881904510252074 * p93.currentSubjectDistance;
end;

return u3;