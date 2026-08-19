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
local success, result = pcall(function() -- Line: 34
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
    [Enum.TouchMovementMode.Default] = DynamicThumbstick,
    [Enum.ComputerMovementMode.Default] = Keyboard,
    [Enum.ComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.KeyboardMouse] = Keyboard,
    [Enum.DevComputerMovementMode.Scriptable] = nil,
    [Enum.ComputerMovementMode.ClickToMove] = ClickToMoveController,
    [Enum.DevComputerMovementMode.ClickToMove] = ClickToMoveController
};
local u4 = {
    [Enum.UserInputType.Keyboard] = Keyboard,
    [Enum.UserInputType.MouseButton1] = Keyboard,
    [Enum.UserInputType.MouseButton2] = Keyboard,
    [Enum.UserInputType.MouseButton3] = Keyboard,
    [Enum.UserInputType.MouseWheel] = Keyboard,
    [Enum.UserInputType.MouseMovement] = Keyboard,
    [Enum.UserInputType.Gamepad1] = Gamepad,
    [Enum.UserInputType.Gamepad2] = Gamepad,
    [Enum.UserInputType.Gamepad3] = Gamepad,
    [Enum.UserInputType.Gamepad4] = Gamepad
};
local u5 = nil;

function u1.new() -- Line: 94
    -- upvalues: u1 (copy), Players (copy), VehicleController (copy), Value (copy), RunService (copy), UserInputService (copy), UserGameSettings (copy), GuiService (copy)
    local u6 = setmetatable({}, u1);
    u6.controllers = {};
    u6.activeControlModule = nil;
    u6.activeController = nil;
    u6.touchJumpController = nil;
    u6.moveFunction = Players.LocalPlayer.Move;
    u6.humanoid = nil;
    u6.lastInputType = Enum.UserInputType.None;
    u6.controlsEnabled = true;
    u6.humanoidSeatedConn = nil;
    u6.vehicleController = nil;
    u6.touchControlFrame = nil;
    u6.currentTorsoAngle = 0;
    u6.inputMoveVector = Vector3.new(0, 0, 0);
    u6.vehicleController = VehicleController.new(Value);
    Players.LocalPlayer.CharacterAdded:Connect(function(p7) -- Line: 120
        -- upvalues: u6 (copy)
        u6:OnCharacterAdded(p7);
    end);
    Players.LocalPlayer.CharacterRemoving:Connect(function(p8) -- Line: 121
        -- upvalues: u6 (copy)
        u6:OnCharacterRemoving(p8);
    end);

    if Players.LocalPlayer.Character then
        u6:OnCharacterAdded(Players.LocalPlayer.Character);
    end;

    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p9) -- Line: 126
        -- upvalues: u6 (copy)
        u6:OnRenderStepped(p9);
    end);
    UserInputService.LastInputTypeChanged:Connect(function(p10) -- Line: 130
        -- upvalues: u6 (copy)
        u6:OnLastInputTypeChanged(p10);
    end);
    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- Line: 135
        -- upvalues: u6 (copy)
        u6:OnTouchMovementModeChange();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- Line: 138
        -- upvalues: u6 (copy)
        u6:OnTouchMovementModeChange();
    end);
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- Line: 142
        -- upvalues: u6 (copy)
        u6:OnComputerMovementModeChange();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 145
        -- upvalues: u6 (copy)
        u6:OnComputerMovementModeChange();
    end);
    u6.playerGui = nil;
    u6.touchGui = nil;
    u6.playerGuiAddedConn = nil;
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- Line: 154
        -- upvalues: u6 (copy)
        u6:UpdateTouchGuiVisibility();
        u6:UpdateActiveControlModuleEnabled();
    end);

    if not UserInputService.TouchEnabled then
        u6:OnLastInputTypeChanged(UserInputService:GetLastInputType());

        return u6;
    end;

    u6.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not u6.playerGui then
        u6.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p11) -- Line: 165
            -- upvalues: u6 (copy), UserInputService (ref)
            if p11:IsA("PlayerGui") then
                u6.playerGui = p11;
                u6:CreateTouchGuiContainer();
                u6.playerGuiAddedConn:Disconnect();
                u6.playerGuiAddedConn = nil;
                u6:OnLastInputTypeChanged(UserInputService:GetLastInputType());
            end;
        end);

        return u6;
    end;

    u6:CreateTouchGuiContainer();
    u6:OnLastInputTypeChanged(UserInputService:GetLastInputType());

    return u6;
end;

function u1.GetMoveVector(p12) -- Line: 185
    return not p12.activeController and Vector3.new(0, 0, 0) or p12.activeController:GetMoveVector();
end;

local function NormalizeAngle(p13) -- Line: 192
    local v14 = (p13 + 12.566370614359172) % 6.283185307179586;

    if v14 > 3.141592653589793 then
        v14 = v14 - 6.283185307179586;
    end;

    return v14;
end;

local function AverageAngle(p15, p16) -- Line: 200
    local v17 = (p16 - p15 + 12.566370614359172) % 6.283185307179586;

    if v17 > 3.141592653589793 then
        v17 = v17 - 6.283185307179586;
    end;

    local v18 = (p15 + v17 / 2 + 12.566370614359172) % 6.283185307179586;

    if v18 > 3.141592653589793 then
        v18 = v18 - 6.283185307179586;
    end;

    return v18;
end;

function u1.GetEstimatedVRTorsoFrame(p19) -- Line: 205
    -- upvalues: VRService (copy)
    local v20 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local _, v21, _ = v20:ToEulerAnglesYXZ();
    local v22 = -v21;

    if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        local v23 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand);
        local v24 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand);
        local v25 = v20.Position - v23.Position;
        local v26 = v20.Position - v24.Position;
        local v27 = -math.atan2(v25.X, v25.Z);
        local v28 = (-math.atan2(v26.X, v26.Z) - v27 + 12.566370614359172) % 6.283185307179586;

        if v28 > 3.141592653589793 then
            v28 = v28 - 6.283185307179586;
        end;

        local v29 = (v27 + v28 / 2 + 12.566370614359172) % 6.283185307179586;

        if v29 > 3.141592653589793 then
            v29 = v29 - 6.283185307179586;
        end;

        local v30 = (v22 - p19.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v30 > 3.141592653589793 then
            v30 = v30 - 6.283185307179586;
        end;

        local v31 = (v29 - p19.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v31 > 3.141592653589793 then
            v31 = v31 - 6.283185307179586;
        end;

        local v32;

        if v31 > -1.5707963267948966 then
            v32 = v31 < 1.5707963267948966;
        else
            v32 = false;
        end;

        if not v32 then
            v31 = v30;
        end;

        local v33 = math.min(v31, v30);
        local v34 = math.max(v31, v30);
        local v35 = 0;

        if v33 > 0 then
            v34 = v33;
        elseif v34 >= 0 then
            v34 = v35;
        end;

        p19.currentTorsoAngle = v34 + p19.currentTorsoAngle;
    else
        p19.currentTorsoAngle = v22;
    end;

    return CFrame.new(v20.Position) * CFrame.fromEulerAnglesYXZ(0, -p19.currentTorsoAngle, 0);
end;

function u1.GetActiveController(p36) -- Line: 249
    return p36.activeController;
end;

function u1.UpdateActiveControlModuleEnabled(u37) -- Line: 254
    -- upvalues: Players (copy), ClickToMoveController (copy), TouchThumbstick (copy), DynamicThumbstick (copy), TouchJump (copy), GuiService (copy), UserInputService (copy)
    local function _() -- Line: 256
        -- upvalues: u37 (copy), Players (ref)
        u37.activeController:Enable(false);

        if u37.touchJumpController then
            u37.touchJumpController:Enable(false);
        end;

        if u37.moveFunction then
            u37.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;
    end;

    local function v38() -- Line: 267
        -- upvalues: u37 (copy), ClickToMoveController (ref), TouchThumbstick (ref), DynamicThumbstick (ref), TouchJump (ref), Players (ref)
        if u37.touchControlFrame and (u37.activeControlModule == ClickToMoveController or (u37.activeControlModule == TouchThumbstick or u37.activeControlModule == DynamicThumbstick)) then
            if not u37.controllers[TouchJump] then
                u37.controllers[TouchJump] = TouchJump.new();
            end;

            u37.touchJumpController = u37.controllers[TouchJump];
            u37.touchJumpController:Enable(true, u37.touchControlFrame);
        elseif u37.touchJumpController then
            u37.touchJumpController:Enable(false);
        end;

        if u37.activeControlModule == ClickToMoveController then
            u37.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, u37.touchJumpController);

            return;
        end;

        if u37.touchControlFrame then
            u37.activeController:Enable(true, u37.touchControlFrame);

            return;
        end;

        u37.activeController:Enable(true);
    end;

    if not u37.activeController then
        return;
    end;

    if not u37.controlsEnabled then
        u37.activeController:Enable(false);

        if u37.touchJumpController then
            u37.touchJumpController:Enable(false);
        end;

        if u37.moveFunction then
            u37.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;

        return;
    end;

    if GuiService.TouchControlsEnabled or (not UserInputService.TouchEnabled or u37.activeControlModule ~= ClickToMoveController and (u37.activeControlModule ~= TouchThumbstick and u37.activeControlModule ~= DynamicThumbstick)) then
        v38();

        return;
    end;

    u37.activeController:Enable(false);

    if u37.touchJumpController then
        u37.touchJumpController:Enable(false);
    end;

    if u37.moveFunction then
        u37.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
    end;
end;

function u1.Enable(p39, p40) -- Line: 326
    local v41 = p40 == nil and true or p40;

    if p39.controlsEnabled == v41 then
        return;
    end;

    p39.controlsEnabled = v41;

    if not p39.activeController then
        return;
    end;

    p39:UpdateActiveControlModuleEnabled();
end;

function u1.Disable(p42) -- Line: 341
    p42:Enable(false);
end;

function u1.SelectComputerMovementModule(p43) -- Line: 347
    -- upvalues: UserInputService (copy), Players (copy), u4 (copy), u5 (ref), UserGameSettings (copy), Keyboard (copy), ClickToMoveController (copy), u3 (copy)
    if not (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled) then
        return nil, false;
    end;

    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode;
    local v44;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        v44 = u4[u5];

        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v44 == Keyboard then
            v44 = ClickToMoveController;
        end;
    else
        v44 = u3[DevComputerMovementMode];

        if not v44 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode);
        end;
    end;

    if v44 then
        return v44, true;
    end;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true;
    end;

    return nil, false;
end;

function u1.SelectTouchModule(p45) -- Line: 385
    -- upvalues: UserInputService (copy), Players (copy), UserGameSettings (copy), DynamicThumbstick (copy), u3 (copy)
    if not UserInputService.TouchEnabled then
        return nil, false;
    end;

    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode;
    local v46;

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        local TouchMovementMode = UserGameSettings.TouchMovementMode;

        if TouchMovementMode == Enum.TouchMovementMode.ClickToMove then
            v46 = DynamicThumbstick;
        else
            v46 = u3[TouchMovementMode] or DynamicThumbstick;
        end;
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true;
        end;

        if DevTouchMovementMode == Enum.DevTouchMovementMode.ClickToMove then
            v46 = DynamicThumbstick;
        else
            v46 = u3[DevTouchMovementMode] or DynamicThumbstick;
        end;
    end;

    return v46, true;
end;

local function getGamepadRightThumbstickPosition() -- Line: 418
    -- upvalues: UserInputService (copy)
    local v47 = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1);

    for _, v in pairs(v47) do
        if v.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v.Position;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u1.calculateRawMoveVector(p48, p49, p50) -- Line: 428
    -- upvalues: Workspace (copy), VRService (copy), getGamepadRightThumbstickPosition (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return p50;
    end;

    local CFrame2 = CurrentCamera.CFrame;

    if VRService.VREnabled and p49.RootPart then
        VRService:GetUserCFrame(Enum.UserCFrame.Head);
        local v51 = p48:GetEstimatedVRTorsoFrame();

        if (CurrentCamera.Focus.Position - CFrame2.Position).Magnitude < 3 then
            CFrame2 = CFrame2 * v51;
        else
            CFrame2 = CurrentCamera.CFrame * (v51.Rotation + v51.Position * CurrentCamera.HeadScale);
        end;
    end;

    if p49:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, _, _, v52, v53, v54, _, _, v55, _, _, v52 = CFrame2:GetComponents();

        if v55 >= 1 or v55 <= -1 then
            v54 = -v53 * math.sign(v55);
        end;

        local v56 = math.sqrt(v52 * v52 + v54 * v54);

        return Vector3.new((v52 * p50.X + v54 * p50.Z) / v56, 0, (v52 * p50.Z - v54 * p50.X) / v56);
    end;

    if not VRService.VREnabled then
        return CFrame2:VectorToWorldSpace(p50);
    end;

    local v57 = Vector3.new(p50.X, 0, p50.Z);

    if v57.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0);
    end;

    local v58 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636;
    local v59 = math.atan2(-v57.X, -v57.Z);
    local _, v60, _ = CFrame2:ToEulerAnglesYXZ();

    return CFrame.fromEulerAnglesYXZ(v58, v59 + v60, 0).LookVector;
end;

function u1.OnRenderStepped(p61, p62) -- Line: 487
    -- upvalues: Gamepad (copy), VRService (copy), Players (copy)
    if p61.activeController and (p61.activeController.enabled and p61.humanoid) then
        local v63 = p61.activeController:GetMoveVector();
        local v64 = p61.activeController:IsMoveVectorCameraRelative();
        local v65 = p61:GetClickToMoveController();

        if p61.activeController == v65 then
            v65:OnRenderStepped(p62);
        elseif v63.magnitude > 0 then
            v65:CleanupPath();
        else
            v65:OnRenderStepped(p62);
            v63 = v65:GetMoveVector();
            v64 = v65:IsMoveVectorCameraRelative();
        end;

        if p61.vehicleController then
            local v66;
            v63, v66 = p61.vehicleController:Update(v63, v64, p61.activeControlModule == Gamepad);
        end;

        if v64 then
            v63 = p61:calculateRawMoveVector(p61.humanoid, v63);
        end;

        p61.inputMoveVector = v63;

        if VRService.VREnabled then
            v63 = p61:updateVRMoveVector(v63);
        end;

        p61.moveFunction(Players.LocalPlayer, v63, false);
    end;
end;

function u1.updateVRMoveVector(p67, p68) -- Line: 536
    -- upvalues: VRService (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if p68.Magnitude ~= 0 or ((CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude >= 5 or (not VRService.AvatarGestures or (not p67.humanoid or p67.humanoid.Sit))) then
        return p68;
    end;

    local v69 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local v70 = (CurrentCamera.CFrame * (v69.Rotation + v69.Position * CurrentCamera.HeadScale) * CFrame.new(0, -0.7 * p67.humanoid.RootPart.Size.Y / 2, 0)).Position - p67.humanoid.RootPart.CFrame.Position;

    return Vector3.new(v70.x, 0, v70.z);
end;

function u1.OnHumanoidSeated(p71, p72, p73) -- Line: 561
    -- upvalues: Value (copy)
    if p72 then
        if p73 and p73:IsA("VehicleSeat") then
            if not p71.vehicleController then
                p71.vehicleController = p71.vehicleController.new(Value);
            end;

            p71.vehicleController:Enable(true, p73);
        end;
    elseif p71.vehicleController then
        p71.vehicleController:Enable(false, p73);
    end;
end;

function u1.OnCharacterAdded(u74, p75) -- Line: 576
    u74.humanoid = p75:FindFirstChildOfClass("Humanoid");

    while not u74.humanoid do
        p75.ChildAdded:wait();
        u74.humanoid = p75:FindFirstChildOfClass("Humanoid");
    end;

    u74:UpdateTouchGuiVisibility();

    if u74.humanoidSeatedConn then
        u74.humanoidSeatedConn:Disconnect();
        u74.humanoidSeatedConn = nil;
    end;

    u74.humanoidSeatedConn = u74.humanoid.Seated:Connect(function(p76, p77) -- Line: 589
        -- upvalues: u74 (copy)
        u74:OnHumanoidSeated(p76, p77);
    end);
end;

function u1.OnCharacterRemoving(p78, p79) -- Line: 594
    p78.humanoid = nil;
    p78:UpdateTouchGuiVisibility();
end;

function u1.UpdateTouchGuiVisibility(p80) -- Line: 600
    -- upvalues: GuiService (copy)
    if p80.touchGui then
        p80.touchGui.Enabled = p80.humanoid and GuiService.TouchControlsEnabled and true or false;
    end;
end;

function u1.SwitchToController(p81, p82) -- Line: 614
    -- upvalues: Value (copy)
    if p82 then
        if not p81.controllers[p82] then
            p81.controllers[p82] = p82.new(Value);
        end;

        if p81.activeController ~= p81.controllers[p82] then
            if p81.activeController then
                p81.activeController:Enable(false);
            end;

            p81.activeController = p81.controllers[p82];
            p81.activeControlModule = p82;
            p81:UpdateActiveControlModuleEnabled();
        end;

        return;
    end;

    if p81.activeController then
        p81.activeController:Enable(false);
    end;

    p81.activeController = nil;
    p81.activeControlModule = nil;
end;

function u1.OnLastInputTypeChanged(p83, p84) -- Line: 642
    -- upvalues: u5 (ref), u4 (copy)
    if u5 == p84 then
        warn("LastInputType Change listener called with current type.");
    end;

    u5 = p84;

    if u5 == Enum.UserInputType.Touch then
        local v85, v86 = p83:SelectTouchModule();

        if v86 then
            while not p83.touchControlFrame do
                wait();
            end;

            p83:SwitchToController(v85);
        end;
    elseif u4[u5] ~= nil then
        local v87 = p83:SelectComputerMovementModule();

        if v87 then
            p83:SwitchToController(v87);
        end;
    end;

    p83:UpdateTouchGuiVisibility();
end;

function u1.OnComputerMovementModeChange(p88) -- Line: 669
    local v89, v90 = p88:SelectComputerMovementModule();

    if v90 then
        p88:SwitchToController(v89);
    end;
end;

function u1.OnTouchMovementModeChange(p91) -- Line: 676
    local v92, v93 = p91:SelectTouchModule();

    if v93 then
        while not p91.touchControlFrame do
            wait();
        end;

        p91:SwitchToController(v92);
    end;
end;

function u1.CreateTouchGuiContainer(p94) -- Line: 686
    -- upvalues: u2 (ref)
    if p94.touchGui then
        p94.touchGui:Destroy();
    end;

    p94.touchGui = Instance.new("ScreenGui");
    p94.touchGui.Name = "TouchGui";
    p94.touchGui.ResetOnSpawn = false;
    p94.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    p94:UpdateTouchGuiVisibility();

    if u2 then
        p94.touchGui.ClipToDeviceSafeArea = false;
    end;

    p94.touchControlFrame = Instance.new("Frame");
    p94.touchControlFrame.Name = "TouchControlFrame";
    p94.touchControlFrame.Size = UDim2.new(1, 0, 1, 0);
    p94.touchControlFrame.BackgroundTransparency = 1;
    p94.touchControlFrame.Parent = p94.touchGui;
    p94.touchGui.Parent = p94.playerGui;
end;

function u1.GetClickToMoveController(p95) -- Line: 709
    -- upvalues: ClickToMoveController (copy), Value (copy)
    if not p95.controllers[ClickToMoveController] then
        p95.controllers[ClickToMoveController] = ClickToMoveController.new(Value);
    end;

    return p95.controllers[ClickToMoveController];
end;

return u1.new();