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
local u2 = FlagUtil.getUserFlag("UserPSRemoveTouchEnabled");
Vector2.new(0, 0);
local u3 = {};
u3.__index = u3;

function u3.new() -- Line: 80
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

    if not u2 then
        v4.portraitMode = false;
        v4.isSmallTouchScreen = false;
    end;

    v4.resetCameraAngle = true;
    v4.enabled = false;
    v4.cameraChangedConn = nil;

    if not u2 then
        v4.viewportSizeChangedConn = nil;
    end;

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

function u3.GetModuleName(p5) -- Line: 147
    return "BaseCamera";
end;

function u3._setUpConfigurations(u6) -- Line: 151
    -- upvalues: LocalPlayer (copy)
    u6._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p7) -- Line: 152
        -- upvalues: u6 (copy)
        u6:OnCharacterAdded(p7);
    end));
    u6.humanoidRootPart = nil;
    u6._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- Line: 157
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end));
    u6._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- Line: 160
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end));
    u6._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- Line: 163
        -- upvalues: u6 (copy)
        u6:OnPlayerCameraPropertyChange();
    end));
    u6:OnPlayerCameraPropertyChange();
end;

function u3.OnCharacterAdded(p8, p9) -- Line: 169
    p8.resetCameraAngle = p8.resetCameraAngle or p8:GetEnabled();
    p8.humanoidRootPart = nil;
end;

function u3.GetHumanoidRootPart(p10) -- Line: 176
    -- upvalues: LocalPlayer (copy)
    local v11 = (not p10.humanoidRootPart and LocalPlayer.Character and true or false) and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");

    if v11 then
        p10.humanoidRootPart = v11.RootPart;
    end;

    return p10.humanoidRootPart;
end;

function u3.GetBodyPartToFollow(p12, p13, p14) -- Line: 188
    if p13:GetState() == Enum.HumanoidStateType.Dead then
        local Parent = p13.Parent;

        if Parent and Parent:IsA("Model") then
            return Parent:FindFirstChild("Head") or p13.RootPart;
        end;
    end;

    return p13.RootPart;
end;

function u3.GetSubjectCFrame(p15) -- Line: 200
    local lastSubjectCFrame = p15.lastSubjectCFrame;
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return lastSubjectCFrame;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local v16 = CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = CurrentCamera.CameraOffset;

        if p15:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = CurrentCamera.RootPart;

        if v16 and (CurrentCamera.Parent and CurrentCamera.Parent:IsA("Model")) then
            RootPart = CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v17;

            if CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if CurrentCamera.AutomaticScalingEnabled then
                    v17 = Vector3.new(0, 1.5, 0);
                    local RootPart2 = CurrentCamera.RootPart;

                    if RootPart == RootPart2 then
                        v17 = v17 + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0);
                    end;
                else
                    v17 = Vector3.new(0, 2, 0);
                end;
            else
                v17 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectCFrame = RootPart.CFrame * CFrame.new((v16 and Vector3.new(0, 0, 0) or v17) + CameraOffset);
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
        p15.lastSubjectCFrame = lastSubjectCFrame;
    end;

    return lastSubjectCFrame;
end;

function u3.GetSubjectVelocity(p18) -- Line: 274
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
        local v19 = CurrentCamera:IsA("Model") and CurrentCamera.PrimaryPart;

        if v19 then
            return v19.Velocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u3.GetSubjectRotVelocity(p20) -- Line: 303
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
        local v21 = CurrentCamera:IsA("Model") and CurrentCamera.PrimaryPart;

        if v21 then
            return v21.RotVelocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u3.StepZoom(p22) -- Line: 332
    -- upvalues: CameraInput (copy), ZoomController (copy)
    local currentSubjectDistance = p22.currentSubjectDistance;
    local v23 = CameraInput.getZoomDelta();

    if math.abs(v23) > 0 then
        local v24;

        if v23 > 0 then
            v24 = math.max(currentSubjectDistance + v23 * (currentSubjectDistance * 0.5 + 1), p22.FIRST_PERSON_DISTANCE_THRESHOLD);
        else
            v24 = math.max((currentSubjectDistance + v23) / (1 - v23 * 0.5), 0.5);
        end;

        p22:SetCameraToSubjectDistance(v24 < p22.FIRST_PERSON_DISTANCE_THRESHOLD and 0.5 or v24);
    end;

    return ZoomController.GetZoomRadius();
end;

function u3.GetSubjectPosition(p25) -- Line: 357
    local lastSubjectPosition = p25.lastSubjectPosition;
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local v26 = CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = CurrentCamera.CameraOffset;

        if p25:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = CurrentCamera.RootPart;

        if v26 and (CurrentCamera.Parent and CurrentCamera.Parent:IsA("Model")) then
            RootPart = CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v27;

            if CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if CurrentCamera.AutomaticScalingEnabled then
                    v27 = Vector3.new(0, 1.5, 0);

                    if RootPart == CurrentCamera.RootPart then
                        v27 = v27 + Vector3.new(0, CurrentCamera.RootPart.Size.Y / 2 - 1, 0);
                    end;
                else
                    v27 = Vector3.new(0, 2, 0);
                end;
            else
                v27 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectPosition = RootPart.CFrame.p + RootPart.CFrame:vectorToWorldSpace((v26 and Vector3.new(0, 0, 0) or v27) + CameraOffset);
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

    p25.lastSubject = CurrentCamera;
    p25.lastSubjectPosition = lastSubjectPosition;

    return lastSubjectPosition;
end;

if not u2 then
    function u3.OnViewportSizeChanged(p28) -- Line: 435
        -- upvalues: UserInputService (copy)
        local ViewportSize = game.Workspace.CurrentCamera.ViewportSize;
        p28.portraitMode = ViewportSize.X < ViewportSize.Y;
        p28.isSmallTouchScreen = UserInputService.TouchEnabled and (ViewportSize.Y < 500 and true or ViewportSize.X < 700);
    end;
end;

function u3.OnCurrentCameraChanged(u29) -- Line: 444
    -- upvalues: u2 (copy), UserInputService (copy)
    if not u2 and UserInputService.TouchEnabled then
        if u29.viewportSizeChangedConn then
            u29.viewportSizeChangedConn:Disconnect();
            u29.viewportSizeChangedConn = nil;
        end;

        local CurrentCamera = game.Workspace.CurrentCamera;

        if CurrentCamera then
            u29:OnViewportSizeChanged();
            u29.viewportSizeChangedConn = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- Line: 456
                -- upvalues: u29 (copy)
                u29:OnViewportSizeChanged();
            end);
        end;
    end;

    if u29.cameraSubjectChangedConn then
        u29.cameraSubjectChangedConn:Disconnect();
        u29.cameraSubjectChangedConn = nil;
    end;

    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        u29.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 471
            -- upvalues: u29 (copy)
            u29:OnNewCameraSubject();
        end);
        u29:OnNewCameraSubject();
    end;
end;

function u3.OnPlayerCameraPropertyChange(p30) -- Line: 478
    p30:SetCameraToSubjectDistance(p30.currentSubjectDistance);
end;

function u3.InputTranslationToCameraAngleChange(p31, p32, p33) -- Line: 483
    return p32 * p33;
end;

function u3.GamepadZoomPress(p34) -- Line: 489
    -- upvalues: LocalPlayer (copy), u1 (ref)
    local v35 = p34:GetCameraToSubjectDistance();
    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance;

    for i = #p34.gamepadZoomLevels, 1, -1 do
        local v36 = p34.gamepadZoomLevels[i];

        if CameraMaxZoomDistance >= v36 then
            if v36 < LocalPlayer.CameraMinZoomDistance then
                v36 = LocalPlayer.CameraMinZoomDistance;

                if u1 and CameraMaxZoomDistance == v36 then
                    break;
                end;
            end;

            if not u1 and CameraMaxZoomDistance == v36 then
                break;
            end;

            if v36 + (CameraMaxZoomDistance - v36) / 2 < v35 then
                p34:SetCameraToSubjectDistance(v36);

                return;
            end;

            CameraMaxZoomDistance = v36;
        end;
    end;

    p34:SetCameraToSubjectDistance(p34.gamepadZoomLevels[#p34.gamepadZoomLevels]);
end;

function u3.Enable(p37, p38) -- Line: 534
    if p37.enabled ~= p38 then
        p37.enabled = p38;
        p37:OnEnabledChanged();
    end;
end;

function u3.OnEnabledChanged(u39) -- Line: 542
    -- upvalues: CameraInput (copy), LocalPlayer (copy)
    if not u39.enabled then
        u39._connections:disconnectAll();
        CameraInput.setInputEnabled(false);

        if u39.gamepadZoomPressConnection then
            u39.gamepadZoomPressConnection:Disconnect();
            u39.gamepadZoomPressConnection = nil;
        end;

        u39:Cleanup();

        return;
    end;

    u39:_setUpConfigurations();
    CameraInput.setInputEnabled(true);
    u39.gamepadZoomPressConnection = CameraInput.gamepadZoomPress:Connect(function() -- Line: 548
        -- upvalues: u39 (copy)
        u39:GamepadZoomPress();
    end);

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        u39.currentSubjectDistance = 0.5;

        if not u39.inFirstPerson then
            u39:EnterFirstPerson();
        end;
    end;

    if u39.cameraChangedConn then
        u39.cameraChangedConn:Disconnect();
        u39.cameraChangedConn = nil;
    end;

    u39.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 560
        -- upvalues: u39 (copy)
        u39:OnCurrentCameraChanged();
    end);
    u39:OnCurrentCameraChanged();
end;

function u3.GetEnabled(p40) -- Line: 578
    return p40.enabled;
end;

function u3.Cleanup(p41) -- Line: 582
    -- upvalues: u2 (copy), CameraUtils (copy)
    if p41.subjectStateChangedConn then
        p41.subjectStateChangedConn:Disconnect();
        p41.subjectStateChangedConn = nil;
    end;

    if not u2 and p41.viewportSizeChangedConn then
        p41.viewportSizeChangedConn:Disconnect();
        p41.viewportSizeChangedConn = nil;
    end;

    if p41.cameraChangedConn then
        p41.cameraChangedConn:Disconnect();
        p41.cameraChangedConn = nil;
    end;

    p41.lastCameraTransform = nil;
    p41.lastSubjectCFrame = nil;
    CameraUtils.restoreMouseBehavior();
end;

function u3.UpdateMouseBehavior(p42) -- Line: 605
    -- upvalues: UserGameSettings (copy), CameraUI (copy), CameraInput (copy), CameraToggleStateController (copy), CameraUtils (copy)
    if p42.isCameraToggle and UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
        CameraUI.setCameraModeToastEnabled(true);
        CameraInput.enableCameraToggleInput();
        CameraToggleStateController(p42.inFirstPerson);

        return;
    end;

    CameraUI.setCameraModeToastEnabled(false);
    CameraInput.disableCameraToggleInput();

    if p42.inFirstPerson or p42.inMouseLockedMode then
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

function u3.UpdateForDistancePropertyChange(p43) -- Line: 633
    p43:SetCameraToSubjectDistance(p43.currentSubjectDistance);
end;

function u3.SetCameraToSubjectDistance(p44, p45) -- Line: 639
    -- upvalues: LocalPlayer (copy), ZoomController (copy)
    local currentSubjectDistance = p44.currentSubjectDistance;

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        p44.currentSubjectDistance = 0.5;

        if not p44.inFirstPerson then
            p44:EnterFirstPerson();
        end;
    else
        local v46 = math.clamp(p45, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);

        if v46 < 1 then
            p44.currentSubjectDistance = 0.5;

            if not p44.inFirstPerson then
                p44:EnterFirstPerson();
            end;
        else
            p44.currentSubjectDistance = v46;

            if p44.inFirstPerson then
                p44:LeaveFirstPerson();
            end;
        end;
    end;

    ZoomController.SetZoomParameters(p44.currentSubjectDistance, (math.sign(p45 - currentSubjectDistance)));

    return p44.currentSubjectDistance;
end;

function u3.SetCameraType(p47, p48) -- Line: 673
    p47.cameraType = p48;
end;

function u3.GetCameraType(p49) -- Line: 678
    return p49.cameraType;
end;

function u3.SetCameraMovementMode(p50, p51) -- Line: 683
    p50.cameraMovementMode = p51;
end;

function u3.GetCameraMovementMode(p52) -- Line: 687
    return p52.cameraMovementMode;
end;

function u3.SetIsMouseLocked(p53, p54) -- Line: 691
    p53.inMouseLockedMode = p54;
end;

function u3.GetIsMouseLocked(p55) -- Line: 695
    return p55.inMouseLockedMode;
end;

function u3.SetMouseLockOffset(p56, p57) -- Line: 699
    p56.mouseLockOffset = p57;
end;

function u3.GetMouseLockOffset(p58) -- Line: 703
    return p58.mouseLockOffset;
end;

function u3.InFirstPerson(p59) -- Line: 707
    return p59.inFirstPerson;
end;

function u3.EnterFirstPerson(p60) -- Line: 711
    p60.inFirstPerson = true;
    p60:UpdateMouseBehavior();
end;

function u3.LeaveFirstPerson(p61) -- Line: 716
    p61.inFirstPerson = false;
    p61:UpdateMouseBehavior();
end;

function u3.GetCameraToSubjectDistance(p62) -- Line: 722
    return p62.currentSubjectDistance;
end;

function u3.GetMeasuredDistanceToFocus(p63) -- Line: 729
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        return (CurrentCamera.CoordinateFrame.p - CurrentCamera.Focus.p).magnitude;
    end;

    return nil;
end;

function u3.GetCameraLookVector(p64) -- Line: 737
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1);
end;

function u3.CalculateNewLookCFrameFromArg(p65, p66, p67) -- Line: 741
    local v68 = p66 or p65:GetCameraLookVector();
    local v69 = math.asin(v68.Y);
    local v70 = math.clamp(p67.Y, v69 + -1.3962634015954636, v69 + 1.3962634015954636);
    local v71 = Vector2.new(p67.X, v70);
    local v72 = CFrame.new(Vector3.new(0, 0, 0), v68);

    return CFrame.Angles(0, -v71.X, 0) * v72 * CFrame.Angles(-v71.Y, 0, 0);
end;

function u3.CalculateNewLookVectorFromArg(p73, p74, p75) -- Line: 751
    return p73:CalculateNewLookCFrameFromArg(p74, p75).LookVector;
end;

function u3.CalculateNewLookVectorVRFromArg(p76, p77) -- Line: 756
    local unit = ((p76:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit;
    local v78 = Vector2.new(p77.X, 0);
    local v79 = CFrame.new(Vector3.new(0, 0, 0), unit);

    return ((CFrame.Angles(0, -v78.X, 0) * v79 * CFrame.Angles(-v78.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit;
end;

function u3.GetHumanoid(p80) -- Line: 766
    -- upvalues: LocalPlayer (copy)
    local v81 = LocalPlayer and LocalPlayer.Character;

    if not v81 then
        return nil;
    end;

    local v82 = p80.humanoidCache[LocalPlayer];

    if v82 and v82.Parent == v81 then
        return v82;
    end;

    p80.humanoidCache[LocalPlayer] = nil;
    local v83 = v81:FindFirstChildOfClass("Humanoid");

    if v83 then
        p80.humanoidCache[LocalPlayer] = v83;
    end;

    return v83;
end;

function u3.GetHumanoidPartToFollow(p84, p85, p86) -- Line: 784
    if p86 ~= Enum.HumanoidStateType.Dead then
        return p85.Torso;
    end;

    local Parent = p85.Parent;

    if Parent then
        return Parent:FindFirstChild("Head") or p85.Torso;
    end;

    return p85.Torso;
end;

function u3.OnNewCameraSubject(p87) -- Line: 798
    if p87.subjectStateChangedConn then
        p87.subjectStateChangedConn:Disconnect();
        p87.subjectStateChangedConn = nil;
    end;
end;

function u3.IsInFirstPerson(p88) -- Line: 805
    return p88.inFirstPerson;
end;

function u3.Update(p89, p90) -- Line: 809
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2);
end;

function u3.GetCameraHeight(p91) -- Line: 813
    -- upvalues: VRService (copy)
    return (not VRService.VREnabled or p91.inFirstPerson) and 0 or 0.25881904510252074 * p91.currentSubjectDistance;
end;

return u3;