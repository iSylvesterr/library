-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UserInputService = game:GetService("UserInputService");
local GuiService = game:GetService("GuiService");
local Workspace = game:GetService("Workspace");
local UserGameSettings = UserSettings():GetService("UserGameSettings");
local VRService = game:GetService("VRService");
script.Parent:WaitForChild("CommonUtils");
local Keyboard = require(script:WaitForChild("Keyboard"));
local Gamepad = require(script:WaitForChild("Gamepad"));
local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"));
local success, result = pcall(function() -- Line: 41
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate");
end);
local u2 = success and result;
local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"));
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"));
local TouchJump = require(script:WaitForChild("TouchJump"));
local VehicleController = require(script:WaitForChild("VehicleController"));
local Value = Enum.ContextActionPriority.Medium.Value;
local u3 = {
    [Enum.TouchMovementMode.DPad] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.DPad] = DynamicThumbstick,
    [Enum.TouchMovementMode.Thumbpad] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.Thumbpad] = DynamicThumbstick,
    [Enum.TouchMovementMode.Thumbstick] = TouchThumbstick,
    [Enum.DevTouchMovementMode.Thumbstick] = TouchThumbstick,
    [Enum.TouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
    [Enum.DevTouchMovementMode.DynamicThumbstick] = DynamicThumbstick,
    [Enum.TouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevTouchMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.TouchMovementMode.Default] = DynamicThumbstick,
    [Enum.ComputerMovementMode.Default] = Keyboard,
    [Enum.ComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController
};

function u1.new() -- Line: 84
    -- upvalues: u1 (copy), Players (copy), VehicleController (copy), Value (copy), RunService (copy), UserGameSettings (copy), GuiService (copy), UserInputService (copy)
    local u4 = setmetatable({}, u1);
    u4.controllers = {};
    u4.activeControlModule = nil;
    u4.activeController = nil;
    u4.touchJumpController = nil;
    u4.moveFunction = Players.LocalPlayer.Move;
    u4.humanoid = nil;
    u4.controlsEnabled = true;
    u4.humanoidSeatedConn = nil;
    u4.vehicleController = nil;
    u4.touchControlFrame = nil;
    u4.currentTorsoAngle = 0;
    u4.inputMoveVector = Vector3.new(0, 0, 0);
    u4.vehicleController = VehicleController.new(Value);
    Players.LocalPlayer.CharacterAdded:Connect(function(p5) -- Line: 109
        -- upvalues: u4 (copy)
        u4:OnCharacterAdded(p5);
    end);
    Players.LocalPlayer.CharacterRemoving:Connect(function(p6) -- Line: 110
        -- upvalues: u4 (copy)
        u4:OnCharacterRemoving(p6);
    end);

    if Players.LocalPlayer.Character then
        u4:OnCharacterAdded(Players.LocalPlayer.Character);
    end;

    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p7) -- Line: 115
        -- upvalues: u4 (copy)
        u4:OnRenderStepped(p7);
    end);
    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- Line: 119
        -- upvalues: u4 (copy)
        u4:UpdateMovementMode();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- Line: 122
        -- upvalues: u4 (copy)
        u4:UpdateMovementMode();
    end);
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- Line: 126
        -- upvalues: u4 (copy)
        u4:UpdateMovementMode();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 129
        -- upvalues: u4 (copy)
        u4:UpdateMovementMode();
    end);
    u4.playerGui = nil;
    u4.touchGui = nil;
    u4.playerGuiAddedConn = nil;
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- Line: 138
        -- upvalues: u4 (copy)
        u4:UpdateMovementMode();
        u4:UpdateActiveControlModuleEnabled();
    end);
    UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 143
        -- upvalues: u4 (copy)
        u4:UpdateMovementMode();
    end);
    u4.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not u4.playerGui then
        u4.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p8) -- Line: 149
            -- upvalues: u4 (copy)
            if p8:IsA("PlayerGui") then
                u4.playerGui = p8;
                u4.playerGuiAddedConn:Disconnect();
                u4.playerGuiAddedConn = nil;
                u4:UpdateMovementMode();
            end;
        end);
    end;

    u4:UpdateMovementMode();

    return u4;
end;

function u1.GetMoveVector(p9) -- Line: 167
    return not p9.activeController and Vector3.new(0, 0, 0) or p9.activeController:GetMoveVector();
end;

local function NormalizeAngle(p10) -- Line: 174
    local v11 = (p10 + 12.566370614359172) % 6.283185307179586;

    if v11 > 3.141592653589793 then
        v11 = v11 - 6.283185307179586;
    end;

    return v11;
end;

local function AverageAngle(p12, p13) -- Line: 182
    local v14 = (p13 - p12 + 12.566370614359172) % 6.283185307179586;

    if v14 > 3.141592653589793 then
        v14 = v14 - 6.283185307179586;
    end;

    local v15 = (p12 + v14 / 2 + 12.566370614359172) % 6.283185307179586;

    if v15 > 3.141592653589793 then
        v15 = v15 - 6.283185307179586;
    end;

    return v15;
end;

function u1.GetEstimatedVRTorsoFrame(p16) -- Line: 187
    -- upvalues: VRService (copy)
    local v17 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local _, v18, _ = v17:ToEulerAnglesYXZ();
    local v19 = -v18;

    if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        local v20 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand);
        local v21 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand);
        local v22 = v17.Position - v20.Position;
        local v23 = v17.Position - v21.Position;
        local v24 = -math.atan2(v22.X, v22.Z);
        local v25 = (-math.atan2(v23.X, v23.Z) - v24 + 12.566370614359172) % 6.283185307179586;

        if v25 > 3.141592653589793 then
            v25 = v25 - 6.283185307179586;
        end;

        local v26 = (v24 + v25 / 2 + 12.566370614359172) % 6.283185307179586;

        if v26 > 3.141592653589793 then
            v26 = v26 - 6.283185307179586;
        end;

        local v27 = (v19 - p16.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v27 > 3.141592653589793 then
            v27 = v27 - 6.283185307179586;
        end;

        local v28 = (v26 - p16.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v28 > 3.141592653589793 then
            v28 = v28 - 6.283185307179586;
        end;

        local v29;

        if v28 > -1.5707963267948966 then
            v29 = v28 < 1.5707963267948966;
        else
            v29 = false;
        end;

        if not v29 then
            v28 = v27;
        end;

        local v30 = math.min(v28, v27);
        local v31 = math.max(v28, v27);
        local v32 = 0;

        if v30 > 0 then
            v31 = v30;
        elseif v31 >= 0 then
            v31 = v32;
        end;

        p16.currentTorsoAngle = v31 + p16.currentTorsoAngle;
    else
        p16.currentTorsoAngle = v19;
    end;

    return CFrame.new(v17.Position) * CFrame.fromEulerAnglesYXZ(0, -p16.currentTorsoAngle, 0);
end;

function u1.GetActiveController(p33) -- Line: 231
    return p33.activeController;
end;

function u1.UpdateActiveControlModuleEnabled(u34) -- Line: 236
    -- upvalues: Players (copy), UserInputService (copy), ClickToMoveController (copy), TouchThumbstick (copy), DynamicThumbstick (copy), TouchJump (copy), GuiService (copy)
    local function _() -- Line: 238
        -- upvalues: u34 (copy), Players (ref)
        u34.activeController:Enable(false);

        if u34.touchJumpController then
            u34.touchJumpController:Enable(false);
        end;

        if u34.moveFunction then
            u34.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;
    end;

    local function v35() -- Line: 249
        -- upvalues: u34 (copy), UserInputService (ref), ClickToMoveController (ref), TouchThumbstick (ref), DynamicThumbstick (ref), TouchJump (ref), Players (ref)
        if u34.touchControlFrame and (UserInputService.PreferredInput == Enum.PreferredInput.Touch and (u34.activeControlModule == ClickToMoveController or (u34.activeControlModule == TouchThumbstick or u34.activeControlModule == DynamicThumbstick))) then
            if not u34.controllers[TouchJump] then
                u34.controllers[TouchJump] = TouchJump.new();
            end;

            u34.touchJumpController = u34.controllers[TouchJump];
            u34.touchJumpController:Enable(true, u34.touchControlFrame);
        elseif u34.touchJumpController then
            u34.touchJumpController:Enable(false);
        end;

        if u34.activeControlModule == ClickToMoveController then
            u34.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, u34.touchJumpController);

            return;
        end;

        if u34.touchControlFrame then
            u34.activeController:Enable(true, u34.touchControlFrame);

            return;
        end;

        u34.activeController:Enable(true);
    end;

    if not u34.activeController then
        return;
    end;

    if not u34.controlsEnabled then
        u34.activeController:Enable(false);

        if u34.touchJumpController then
            u34.touchJumpController:Enable(false);
        end;

        if u34.moveFunction then
            u34.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;

        return;
    end;

    if GuiService.TouchControlsEnabled or (UserInputService.PreferredInput ~= Enum.PreferredInput.Touch or u34.activeControlModule ~= ClickToMoveController and (u34.activeControlModule ~= TouchThumbstick and u34.activeControlModule ~= DynamicThumbstick)) then
        v35();

        return;
    end;

    u34.activeController:Enable(false);

    if u34.touchJumpController then
        u34.touchJumpController:Enable(false);
    end;

    if u34.moveFunction then
        u34.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
    end;
end;

function u1.Enable(p36, p37) -- Line: 307
    local v38 = p37 == nil and true or p37;

    if p36.controlsEnabled == v38 then
        return;
    end;

    p36.controlsEnabled = v38;

    if not p36.activeController then
        return;
    end;

    p36:UpdateActiveControlModuleEnabled();
end;

function u1.Disable(p39) -- Line: 322
    p39:Enable(false);
end;

function u1.SelectComputerMovementModule(p40) -- Line: 328
    -- upvalues: UserInputService (copy), Players (copy), Gamepad (copy), Keyboard (copy), UserGameSettings (copy), ClickToMoveController (copy), u3 (copy)
    if not (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled) then
        return nil, false;
    end;

    local v41 = nil;
    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
            v41 = Gamepad;
        elseif UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
            v41 = Keyboard;
        end;

        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v41 == Keyboard then
            v41 = ClickToMoveController;
        end;
    else
        v41 = u3[DevComputerMovementMode];

        if not v41 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode);
        end;
    end;

    if v41 then
        return v41, true;
    end;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true;
    end;

    return nil, false;
end;

function u1.SelectTouchModule(p42) -- Line: 371
    -- upvalues: Players (copy), u3 (copy), UserGameSettings (copy)
    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode;
    local v43;

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        v43 = u3[UserGameSettings.TouchMovementMode];
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true;
        end;

        v43 = u3[DevTouchMovementMode];
    end;

    return v43, true;
end;

local function getGamepadRightThumbstickPosition() -- Line: 384
    -- upvalues: UserInputService (copy)
    local v44 = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1);

    for _, v in pairs(v44) do
        if v.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v.Position;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u1.calculateRawMoveVector(p45, p46, p47) -- Line: 394
    -- upvalues: Workspace (copy), VRService (copy), getGamepadRightThumbstickPosition (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return p47;
    end;

    local CFrame2 = CurrentCamera.CFrame;

    if VRService.VREnabled and p46.RootPart then
        VRService:GetUserCFrame(Enum.UserCFrame.Head);
        local v48 = p45:GetEstimatedVRTorsoFrame();

        if (CurrentCamera.Focus.Position - CFrame2.Position).Magnitude < 3 then
            CFrame2 = CFrame2 * v48;
        else
            CFrame2 = CurrentCamera.CFrame * (v48.Rotation + v48.Position * CurrentCamera.HeadScale);
        end;
    end;

    if p46:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, _, _, v49, v50, v51, _, _, v52, _, _, v49 = CFrame2:GetComponents();

        if v52 >= 1 or v52 <= -1 then
            v51 = -v50 * math.sign(v52);
        end;

        local v53 = math.sqrt(v49 * v49 + v51 * v51);

        return Vector3.new((v49 * p47.X + v51 * p47.Z) / v53, 0, (v49 * p47.Z - v51 * p47.X) / v53);
    end;

    if not VRService.VREnabled then
        return CFrame2:VectorToWorldSpace(p47);
    end;

    local v54 = Vector3.new(p47.X, 0, p47.Z);

    if v54.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0);
    end;

    local v55 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636;
    local v56 = math.atan2(-v54.X, -v54.Z);
    local _, v57, _ = CFrame2:ToEulerAnglesYXZ();

    return CFrame.fromEulerAnglesYXZ(v55, v56 + v57, 0).LookVector;
end;

function u1.OnRenderStepped(p58, p59) -- Line: 453
    -- upvalues: Gamepad (copy), VRService (copy), Players (copy)
    if p58.activeController and (p58.activeController.enabled and p58.humanoid) then
        local v60 = p58.activeController:GetMoveVector();
        local v61 = p58.activeController:IsMoveVectorCameraRelative();
        local v62 = p58:GetClickToMoveController();

        if p58.activeController == v62 then
            v62:OnRenderStepped(p59);
        elseif v60.magnitude > 0 then
            v62:CleanupPath();
        else
            v62:OnRenderStepped(p59);
            v60 = v62:GetMoveVector();
            v61 = v62:IsMoveVectorCameraRelative();
        end;

        if p58.vehicleController then
            local v63;
            v60, v63 = p58.vehicleController:Update(v60, v61, p58.activeControlModule == Gamepad);
        end;

        if v61 then
            v60 = p58:calculateRawMoveVector(p58.humanoid, v60);
        end;

        p58.inputMoveVector = v60;

        if VRService.VREnabled then
            v60 = p58:updateVRMoveVector(v60);
        end;

        p58.moveFunction(Players.LocalPlayer, v60, false);
        local humanoid = p58.humanoid;
        local v64 = p58.activeController:GetIsJumping() or p58.touchJumpController and p58.touchJumpController:GetIsJumping();
        humanoid.Jump = v64;
    end;
end;

function u1.updateVRMoveVector(p65, p66) -- Line: 502
    -- upvalues: VRService (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if p66.Magnitude ~= 0 or ((CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude >= 5 or (not VRService.AvatarGestures or (not p65.humanoid or p65.humanoid.Sit))) then
        return p66;
    end;

    local v67 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local v68 = (CurrentCamera.CFrame * (v67.Rotation + v67.Position * CurrentCamera.HeadScale) * CFrame.new(0, -0.7 * p65.humanoid.RootPart.Size.Y / 2, 0)).Position - p65.humanoid.RootPart.CFrame.Position;

    return Vector3.new(v68.x, 0, v68.z);
end;

function u1.OnHumanoidSeated(p69, p70, p71) -- Line: 527
    -- upvalues: Value (copy)
    if p70 then
        if p71 and p71:IsA("VehicleSeat") then
            if not p69.vehicleController then
                p69.vehicleController = p69.vehicleController.new(Value);
            end;

            p69.vehicleController:Enable(true, p71);
        end;
    elseif p69.vehicleController then
        p69.vehicleController:Enable(false, p71);
    end;
end;

function u1.OnCharacterAdded(u72, p73) -- Line: 542
    u72.humanoid = p73:FindFirstChildOfClass("Humanoid");

    while not u72.humanoid do
        p73.ChildAdded:wait();
        u72.humanoid = p73:FindFirstChildOfClass("Humanoid");
    end;

    if u72.humanoidSeatedConn then
        u72.humanoidSeatedConn:Disconnect();
        u72.humanoidSeatedConn = nil;
    end;

    u72.humanoidSeatedConn = u72.humanoid.Seated:Connect(function(p74, p75) -- Line: 553
        -- upvalues: u72 (copy)
        u72:OnHumanoidSeated(p74, p75);
    end);
    u72:UpdateMovementMode();
end;

function u1.OnCharacterRemoving(p76, p77) -- Line: 560
    p76.humanoid = nil;
    p76:UpdateMovementMode();
end;

function u1.UpdateTouchGuiVisibility(p78) -- Line: 566
    -- upvalues: GuiService (copy), UserInputService (copy)
    local v79 = p78.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch;

    if v79 and not p78.touchGui then
        p78:CreateTouchGuiContainer();
    end;

    if p78.touchGui then
        p78.touchGui.Enabled = v79 and true or false;
    end;
end;

function u1.SwitchToController(p80, p81) -- Line: 585
    -- upvalues: Value (copy)
    if p81 then
        if not p80.controllers[p81] then
            p80.controllers[p81] = p81.new(Value);
        end;

        if p80.activeController ~= p80.controllers[p81] then
            if p80.activeController then
                p80.activeController:Enable(false);
            end;

            p80.activeController = p80.controllers[p81];
            p80.activeControlModule = p81;
            p80:UpdateActiveControlModuleEnabled();
        end;

        return;
    end;

    if p80.activeController then
        p80.activeController:Enable(false);
    end;

    p80.activeController = nil;
    p80.activeControlModule = nil;
end;

function u1.UpdateMovementMode(p82) -- Line: 624
    -- upvalues: UserInputService (copy)
    p82:UpdateTouchGuiVisibility();

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v83, v84 = p82:SelectTouchModule();

        if v84 and p82.touchControlFrame then
            p82:SwitchToController(v83);
        end;
    else
        p82:SwitchToController((p82:SelectComputerMovementModule()));
    end;
end;

function u1.CreateTouchGuiContainer(p85) -- Line: 640
    -- upvalues: u2 (ref)
    if not p85.playerGui then
        return;
    end;

    if p85.touchGui then
        p85.touchGui:Destroy();
    end;

    p85.touchGui = Instance.new("ScreenGui");
    p85.touchGui.Name = "TouchGui";
    p85.touchGui.ResetOnSpawn = false;
    p85.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

    if u2 then
        p85.touchGui.ClipToDeviceSafeArea = false;
    end;

    p85.touchControlFrame = Instance.new("Frame");
    p85.touchControlFrame.Name = "TouchControlFrame";
    p85.touchControlFrame.Size = UDim2.new(1, 0, 1, 0);
    p85.touchControlFrame.BackgroundTransparency = 1;
    p85.touchControlFrame.Parent = p85.touchGui;
    p85.touchGui.Parent = p85.playerGui;
end;

function u1.GetClickToMoveController(p86) -- Line: 666
    -- upvalues: ClickToMoveController (copy), Value (copy)
    if not p86.controllers[ClickToMoveController] then
        p86.controllers[ClickToMoveController] = ClickToMoveController.new(Value);
    end;

    return p86.controllers[ClickToMoveController];
end;

return u1.new();