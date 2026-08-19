-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
game:GetService("UserInputService");
local VRService = game:GetService("VRService");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils");
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"));
require(CommonUtils:WaitForChild("FlagUtil"));
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
Vector2.new(0, 0);
local u2 = {};
u2.__index = u2;

function u2.new() -- Line: 78
    -- upvalues: u2 (copy), ConnectionUtil (copy), LocalPlayer (copy), UserGameSettings (copy)
    local v3 = setmetatable({}, u2);
    v3._connections = ConnectionUtil.new();
    v3.gamepadZoomLevels = { 0, 10, 20 };
    v3.FIRST_PERSON_DISTANCE_THRESHOLD = 1;
    v3.cameraType = nil;
    v3.cameraMovementMode = nil;
    v3.lastCameraTransform = nil;
    v3.lastUserPanCamera = tick();
    v3.humanoidRootPart = nil;
    v3.humanoidCache = {};
    v3.lastSubject = nil;
    v3.lastSubjectPosition = Vector3.new(0, 5, 0);
    v3.lastSubjectCFrame = CFrame.new(v3.lastSubjectPosition);
    v3.currentSubjectDistance = math.clamp(12.5, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);
    v3.inFirstPerson = false;
    v3.inMouseLockedMode = false;
    v3.resetCameraAngle = true;
    v3.enabled = false;
    v3.cameraChangedConn = nil;
    v3.shouldUseVRRotation = false;
    v3.VRRotationIntensityAvailable = false;
    v3.lastVRRotationIntensityCheckTime = 0;
    v3.lastVRRotationTime = 0;
    v3.vrRotateKeyCooldown = {};
    v3.cameraTranslationConstraints = Vector3.new(1, 1, 1);
    v3.humanoidJumpOrigin = nil;
    v3.trackingHumanoid = nil;
    v3.cameraFrozen = false;
    v3.subjectStateChangedConn = nil;
    v3.gamepadZoomPressConnection = nil;
    v3.mouseLockOffset = Vector3.new(0, 0, 0);
    UserGameSettings:SetCameraYInvertVisible();
    UserGameSettings:SetGamepadCameraSensitivityVisible();

    return v3;
end;

function u2.GetModuleName(p4) -- Line: 138
    return "BaseCamera";
end;

function u2._setUpConfigurations(u5) -- Line: 142
    -- upvalues: LocalPlayer (copy)
    u5._connections:trackConnection("CHARACTER_ADDED", LocalPlayer.CharacterAdded:Connect(function(p6) -- Line: 143
        -- upvalues: u5 (copy)
        u5:OnCharacterAdded(p6);
    end));
    u5.humanoidRootPart = nil;
    u5._connections:trackConnection("CAMERA_MODE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMode"):Connect(function() -- Line: 148
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5._connections:trackConnection("CAMERA_MIN_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function() -- Line: 151
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5._connections:trackConnection("CAMERA_MAX_DISTANCE_CHANGED", LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function() -- Line: 154
        -- upvalues: u5 (copy)
        u5:OnPlayerCameraPropertyChange();
    end));
    u5:OnPlayerCameraPropertyChange();
end;

function u2.OnCharacterAdded(p7, p8) -- Line: 160
    p7.resetCameraAngle = p7.resetCameraAngle or p7:GetEnabled();
    p7.humanoidRootPart = nil;
end;

function u2.GetHumanoidRootPart(p9) -- Line: 167
    -- upvalues: LocalPlayer (copy)
    local v10 = (not p9.humanoidRootPart and LocalPlayer.Character and true or false) and LocalPlayer.Character:FindFirstChildOfClass("Humanoid");

    if v10 then
        p9.humanoidRootPart = v10.RootPart;
    end;

    return p9.humanoidRootPart;
end;

function u2.GetBodyPartToFollow(p11, p12, p13) -- Line: 179
    if p12:GetState() == Enum.HumanoidStateType.Dead then
        local Parent = p12.Parent;

        if Parent and Parent:IsA("Model") then
            return Parent:FindFirstChild("Head") or p12.RootPart;
        end;
    end;

    return p12.RootPart;
end;

function u2.GetSubjectCFrame(p14) -- Line: 191
    local lastSubjectCFrame = p14.lastSubjectCFrame;
    local CurrentCamera = workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return lastSubjectCFrame;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local v15 = CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = CurrentCamera.CameraOffset;

        if p14:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = CurrentCamera.RootPart;

        if v15 and (CurrentCamera.Parent and CurrentCamera.Parent:IsA("Model")) then
            RootPart = CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v16;

            if CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if CurrentCamera.AutomaticScalingEnabled then
                    v16 = Vector3.new(0, 1.5, 0);
                    local RootPart2 = CurrentCamera.RootPart;

                    if RootPart == RootPart2 then
                        v16 = v16 + Vector3.new(0, (RootPart2.Size.Y - 2) / 2, 0);
                    end;
                else
                    v16 = Vector3.new(0, 2, 0);
                end;
            else
                v16 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectCFrame = RootPart.CFrame * CFrame.new((v15 and Vector3.new(0, 0, 0) or v16) + CameraOffset);
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
        p14.lastSubjectCFrame = lastSubjectCFrame;
    end;

    return lastSubjectCFrame;
end;

function u2.GetSubjectVelocity(p17) -- Line: 265
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
        local v18 = CurrentCamera:IsA("Model") and CurrentCamera.PrimaryPart;

        if v18 then
            return v18.Velocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u2.GetSubjectRotVelocity(p19) -- Line: 294
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
        local v20 = CurrentCamera:IsA("Model") and CurrentCamera.PrimaryPart;

        if v20 then
            return v20.RotVelocity;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u2.StepZoom(p21) -- Line: 323
    -- upvalues: CameraInput (copy), ZoomController (copy)
    local currentSubjectDistance = p21.currentSubjectDistance;
    local v22 = CameraInput.getZoomDelta();

    if math.abs(v22) > 0 then
        local v23;

        if v22 > 0 then
            v23 = math.max(currentSubjectDistance + v22 * (currentSubjectDistance * 0.5 + 1), p21.FIRST_PERSON_DISTANCE_THRESHOLD);
        else
            v23 = math.max((currentSubjectDistance + v22) / (1 - v22 * 0.5), 0.5);
        end;

        p21:SetCameraToSubjectDistance(v23 < p21.FIRST_PERSON_DISTANCE_THRESHOLD and 0.5 or v23);
    end;

    return ZoomController.GetZoomRadius();
end;

function u2.GetSubjectPosition(p24) -- Line: 348
    local lastSubjectPosition = p24.lastSubjectPosition;
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        CurrentCamera = CurrentCamera.CameraSubject;
    end;

    if not CurrentCamera then
        return nil;
    end;

    if CurrentCamera:IsA("Humanoid") then
        local v25 = CurrentCamera:GetState() == Enum.HumanoidStateType.Dead;
        local CameraOffset = CurrentCamera.CameraOffset;

        if p24:GetIsMouseLocked() then
            CameraOffset = Vector3.new();
        end;

        local RootPart = CurrentCamera.RootPart;

        if v25 and (CurrentCamera.Parent and CurrentCamera.Parent:IsA("Model")) then
            RootPart = CurrentCamera.Parent:FindFirstChild("Head") or RootPart;
        end;

        if RootPart and RootPart:IsA("BasePart") then
            local v26;

            if CurrentCamera.RigType == Enum.HumanoidRigType.R15 then
                if CurrentCamera.AutomaticScalingEnabled then
                    v26 = Vector3.new(0, 1.5, 0);

                    if RootPart == CurrentCamera.RootPart then
                        v26 = v26 + Vector3.new(0, CurrentCamera.RootPart.Size.Y / 2 - 1, 0);
                    end;
                else
                    v26 = Vector3.new(0, 2, 0);
                end;
            else
                v26 = Vector3.new(0, 1.5, 0);
            end;

            lastSubjectPosition = RootPart.CFrame.p + RootPart.CFrame:vectorToWorldSpace((v25 and Vector3.new(0, 0, 0) or v26) + CameraOffset);
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

    p24.lastSubject = CurrentCamera;
    p24.lastSubjectPosition = lastSubjectPosition;

    return lastSubjectPosition;
end;

function u2.OnCurrentCameraChanged(u27) -- Line: 426
    if u27.cameraSubjectChangedConn then
        u27.cameraSubjectChangedConn:Disconnect();
        u27.cameraSubjectChangedConn = nil;
    end;

    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        u27.cameraSubjectChangedConn = CurrentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function() -- Line: 435
            -- upvalues: u27 (copy)
            u27:OnNewCameraSubject();
        end);
        u27:OnNewCameraSubject();
    end;
end;

function u2.OnPlayerCameraPropertyChange(p28) -- Line: 442
    p28:SetCameraToSubjectDistance(p28.currentSubjectDistance);
end;

function u2.InputTranslationToCameraAngleChange(p29, p30, p31) -- Line: 447
    return p30 * p31;
end;

function u2.GamepadZoomPress(p32) -- Line: 453
    -- upvalues: LocalPlayer (copy), u1 (ref)
    local v33 = p32:GetCameraToSubjectDistance();
    local CameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance;

    for i = #p32.gamepadZoomLevels, 1, -1 do
        local v34 = p32.gamepadZoomLevels[i];

        if CameraMaxZoomDistance >= v34 then
            if v34 < LocalPlayer.CameraMinZoomDistance then
                v34 = LocalPlayer.CameraMinZoomDistance;

                if u1 and CameraMaxZoomDistance == v34 then
                    break;
                end;
            end;

            if not u1 and CameraMaxZoomDistance == v34 then
                break;
            end;

            if v34 + (CameraMaxZoomDistance - v34) / 2 < v33 then
                p32:SetCameraToSubjectDistance(v34);

                return;
            end;

            CameraMaxZoomDistance = v34;
        end;
    end;

    p32:SetCameraToSubjectDistance(p32.gamepadZoomLevels[#p32.gamepadZoomLevels]);
end;

function u2.Enable(p35, p36) -- Line: 498
    if p35.enabled ~= p36 then
        p35.enabled = p36;
        p35:OnEnabledChanged();
    end;
end;

function u2.OnEnabledChanged(u37) -- Line: 506
    -- upvalues: CameraInput (copy), LocalPlayer (copy)
    if not u37.enabled then
        u37._connections:disconnectAll();
        CameraInput.setInputEnabled(false);

        if u37.gamepadZoomPressConnection then
            u37.gamepadZoomPressConnection:Disconnect();
            u37.gamepadZoomPressConnection = nil;
        end;

        u37:Cleanup();

        return;
    end;

    u37:_setUpConfigurations();
    CameraInput.setInputEnabled(true);
    u37.gamepadZoomPressConnection = CameraInput.gamepadZoomPress:Connect(function() -- Line: 512
        -- upvalues: u37 (copy)
        u37:GamepadZoomPress();
    end);

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        u37.currentSubjectDistance = 0.5;

        if not u37.inFirstPerson then
            u37:EnterFirstPerson();
        end;
    end;

    if u37.cameraChangedConn then
        u37.cameraChangedConn:Disconnect();
        u37.cameraChangedConn = nil;
    end;

    u37.cameraChangedConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 524
        -- upvalues: u37 (copy)
        u37:OnCurrentCameraChanged();
    end);
    u37:OnCurrentCameraChanged();
end;

function u2.GetEnabled(p38) -- Line: 542
    return p38.enabled;
end;

function u2.Cleanup(p39) -- Line: 546
    -- upvalues: CameraUtils (copy)
    if p39.subjectStateChangedConn then
        p39.subjectStateChangedConn:Disconnect();
        p39.subjectStateChangedConn = nil;
    end;

    if p39.cameraChangedConn then
        p39.cameraChangedConn:Disconnect();
        p39.cameraChangedConn = nil;
    end;

    p39.lastCameraTransform = nil;
    p39.lastSubjectCFrame = nil;
    CameraUtils.restoreMouseBehavior();
end;

function u2.UpdateMouseBehavior(p40) -- Line: 563
    -- upvalues: UserGameSettings (copy), CameraUI (copy), CameraInput (copy), CameraToggleStateController (copy), CameraUtils (copy)
    if p40.isCameraToggle and UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove == false then
        CameraUI.setCameraModeToastEnabled(true);
        CameraInput.enableCameraToggleInput();
        CameraToggleStateController(p40.inFirstPerson);

        return;
    end;

    CameraUI.setCameraModeToastEnabled(false);
    CameraInput.disableCameraToggleInput();

    if p40.inFirstPerson or p40.inMouseLockedMode then
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

function u2.UpdateForDistancePropertyChange(p41) -- Line: 591
    p41:SetCameraToSubjectDistance(p41.currentSubjectDistance);
end;

function u2.SetCameraToSubjectDistance(p42, p43) -- Line: 597
    -- upvalues: LocalPlayer (copy), ZoomController (copy)
    local currentSubjectDistance = p42.currentSubjectDistance;

    if LocalPlayer.CameraMode == Enum.CameraMode.LockFirstPerson then
        p42.currentSubjectDistance = 0.5;

        if not p42.inFirstPerson then
            p42:EnterFirstPerson();
        end;
    else
        local v44 = math.clamp(p43, LocalPlayer.CameraMinZoomDistance, LocalPlayer.CameraMaxZoomDistance);

        if v44 < 1 then
            p42.currentSubjectDistance = 0.5;

            if not p42.inFirstPerson then
                p42:EnterFirstPerson();
            end;
        else
            p42.currentSubjectDistance = v44;

            if p42.inFirstPerson then
                p42:LeaveFirstPerson();
            end;
        end;
    end;

    ZoomController.SetZoomParameters(p42.currentSubjectDistance, (math.sign(p43 - currentSubjectDistance)));

    return p42.currentSubjectDistance;
end;

function u2.SetCameraType(p45, p46) -- Line: 631
    p45.cameraType = p46;
end;

function u2.GetCameraType(p47) -- Line: 636
    return p47.cameraType;
end;

function u2.SetCameraMovementMode(p48, p49) -- Line: 641
    p48.cameraMovementMode = p49;
end;

function u2.GetCameraMovementMode(p50) -- Line: 645
    return p50.cameraMovementMode;
end;

function u2.SetIsMouseLocked(p51, p52) -- Line: 649
    p51.inMouseLockedMode = p52;
end;

function u2.GetIsMouseLocked(p53) -- Line: 653
    return p53.inMouseLockedMode;
end;

function u2.SetMouseLockOffset(p54, p55) -- Line: 657
    p54.mouseLockOffset = p55;
end;

function u2.GetMouseLockOffset(p56) -- Line: 661
    return p56.mouseLockOffset;
end;

function u2.InFirstPerson(p57) -- Line: 665
    return p57.inFirstPerson;
end;

function u2.EnterFirstPerson(p58) -- Line: 669
    p58.inFirstPerson = true;
    p58:UpdateMouseBehavior();
end;

function u2.LeaveFirstPerson(p59) -- Line: 674
    p59.inFirstPerson = false;
    p59:UpdateMouseBehavior();
end;

function u2.GetCameraToSubjectDistance(p60) -- Line: 680
    return p60.currentSubjectDistance;
end;

function u2.GetMeasuredDistanceToFocus(p61) -- Line: 687
    local CurrentCamera = game.Workspace.CurrentCamera;

    if CurrentCamera then
        return (CurrentCamera.CoordinateFrame.p - CurrentCamera.Focus.p).magnitude;
    end;

    return nil;
end;

function u2.GetCameraLookVector(p62) -- Line: 695
    return game.Workspace.CurrentCamera and game.Workspace.CurrentCamera.CFrame.LookVector or Vector3.new(0, 0, 1);
end;

function u2.CalculateNewLookCFrameFromArg(p63, p64, p65) -- Line: 699
    local v66 = p64 or p63:GetCameraLookVector();
    local v67 = math.asin(v66.Y);
    local v68 = math.clamp(p65.Y, v67 + -1.3962634015954636, v67 + 1.3962634015954636);
    local v69 = Vector2.new(p65.X, v68);
    local v70 = CFrame.new(Vector3.new(0, 0, 0), v66);

    return CFrame.Angles(0, -v69.X, 0) * v70 * CFrame.Angles(-v69.Y, 0, 0);
end;

function u2.CalculateNewLookVectorFromArg(p71, p72, p73) -- Line: 709
    return p71:CalculateNewLookCFrameFromArg(p72, p73).LookVector;
end;

function u2.CalculateNewLookVectorVRFromArg(p74, p75) -- Line: 714
    local unit = ((p74:GetSubjectPosition() - game.Workspace.CurrentCamera.CFrame.p) * Vector3.new(1, 0, 1)).unit;
    local v76 = Vector2.new(p75.X, 0);
    local v77 = CFrame.new(Vector3.new(0, 0, 0), unit);

    return ((CFrame.Angles(0, -v76.X, 0) * v77 * CFrame.Angles(-v76.Y, 0, 0)).LookVector * Vector3.new(1, 0, 1)).unit;
end;

function u2.GetHumanoid(p78) -- Line: 724
    -- upvalues: LocalPlayer (copy)
    local v79 = LocalPlayer and LocalPlayer.Character;

    if not v79 then
        return nil;
    end;

    local v80 = p78.humanoidCache[LocalPlayer];

    if v80 and v80.Parent == v79 then
        return v80;
    end;

    p78.humanoidCache[LocalPlayer] = nil;
    local v81 = v79:FindFirstChildOfClass("Humanoid");

    if v81 then
        p78.humanoidCache[LocalPlayer] = v81;
    end;

    return v81;
end;

function u2.GetHumanoidPartToFollow(p82, p83, p84) -- Line: 742
    if p84 ~= Enum.HumanoidStateType.Dead then
        return p83.Torso;
    end;

    local Parent = p83.Parent;

    if Parent then
        return Parent:FindFirstChild("Head") or p83.Torso;
    end;

    return p83.Torso;
end;

function u2.OnNewCameraSubject(p85) -- Line: 756
    if p85.subjectStateChangedConn then
        p85.subjectStateChangedConn:Disconnect();
        p85.subjectStateChangedConn = nil;
    end;
end;

function u2.IsInFirstPerson(p86) -- Line: 763
    return p86.inFirstPerson;
end;

function u2.Update(p87, p88) -- Line: 767
    error("BaseCamera:Update() This is a virtual function that should never be getting called.", 2);
end;

function u2.GetCameraHeight(p89) -- Line: 771
    -- upvalues: VRService (copy)
    return (not VRService.VREnabled or p89.inFirstPerson) and 0 or 0.25881904510252074 * p89.currentSubjectDistance;
end;

return u2;