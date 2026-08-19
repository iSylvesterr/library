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
local CommonUtils = script.Parent:WaitForChild("CommonUtils");
local Keyboard = require(script:WaitForChild("Keyboard"));
local Gamepad = require(script:WaitForChild("Gamepad"));
local DynamicThumbstick = require(script:WaitForChild("DynamicThumbstick"));
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"));
local success, result = pcall(function() -- Line: 42
    return UserSettings():IsUserFeatureEnabled("UserDynamicThumbstickSafeAreaUpdate");
end);
local u2 = success and result;
local u3 = FlagUtil.getUserFlag("UserPreferredInputPlayerScripts2");
local u4 = FlagUtil.getUserFlag("UserPSRemoveTouchEnabled");
local TouchThumbstick = require(script:WaitForChild("TouchThumbstick"));
local ClickToMoveController = require(script:WaitForChild("ClickToMoveController"));
local TouchJump = require(script:WaitForChild("TouchJump"));
local VehicleController = require(script:WaitForChild("VehicleController"));
local Value = Enum.ContextActionPriority.Medium.Value;
local u5 = {
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
local u6 = {
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
local u7 = nil;

function u1.new() -- Line: 106
    -- upvalues: u1 (copy), Players (copy), u3 (copy), VehicleController (copy), Value (copy), RunService (copy), UserInputService (copy), UserGameSettings (copy), GuiService (copy)
    local u8 = setmetatable({}, u1);
    u8.controllers = {};
    u8.activeControlModule = nil;
    u8.activeController = nil;
    u8.touchJumpController = nil;
    u8.moveFunction = Players.LocalPlayer.Move;
    u8.humanoid = nil;

    if not u3 then
        u8.lastInputType = Enum.UserInputType.None;
    end;

    u8.controlsEnabled = true;
    u8.humanoidSeatedConn = nil;
    u8.vehicleController = nil;
    u8.touchControlFrame = nil;
    u8.currentTorsoAngle = 0;
    u8.inputMoveVector = Vector3.new(0, 0, 0);
    u8.vehicleController = VehicleController.new(Value);
    Players.LocalPlayer.CharacterAdded:Connect(function(p9) -- Line: 134
        -- upvalues: u8 (copy)
        u8:OnCharacterAdded(p9);
    end);
    Players.LocalPlayer.CharacterRemoving:Connect(function(p10) -- Line: 135
        -- upvalues: u8 (copy)
        u8:OnCharacterRemoving(p10);
    end);

    if Players.LocalPlayer.Character then
        u8:OnCharacterAdded(Players.LocalPlayer.Character);
    end;

    RunService:BindToRenderStep("ControlScriptRenderstep", Enum.RenderPriority.Input.Value, function(p11) -- Line: 140
        -- upvalues: u8 (copy)
        u8:OnRenderStepped(p11);
    end);

    if not u3 then
        UserInputService.LastInputTypeChanged:Connect(function(p12) -- Line: 145
            -- upvalues: u8 (copy)
            u8:OnLastInputTypeChanged(p12);
        end);
    end;

    UserGameSettings:GetPropertyChangedSignal("TouchMovementMode"):Connect(function() -- Line: 150
        -- upvalues: u3 (ref), u8 (copy)
        if u3 then
            u8:UpdateMovementMode();

            return;
        end;

        u8:OnTouchMovementModeChange();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevTouchMovementMode"):Connect(function() -- Line: 157
        -- upvalues: u3 (ref), u8 (copy)
        if u3 then
            u8:UpdateMovementMode();

            return;
        end;

        u8:OnTouchMovementModeChange();
    end);
    UserGameSettings:GetPropertyChangedSignal("ComputerMovementMode"):Connect(function() -- Line: 165
        -- upvalues: u3 (ref), u8 (copy)
        if u3 then
            u8:UpdateMovementMode();

            return;
        end;

        u8:OnComputerMovementModeChange();
    end);
    Players.LocalPlayer:GetPropertyChangedSignal("DevComputerMovementMode"):Connect(function() -- Line: 172
        -- upvalues: u3 (ref), u8 (copy)
        if u3 then
            u8:UpdateMovementMode();

            return;
        end;

        u8:OnComputerMovementModeChange();
    end);
    u8.playerGui = nil;
    u8.touchGui = nil;
    u8.playerGuiAddedConn = nil;
    GuiService:GetPropertyChangedSignal("TouchControlsEnabled"):Connect(function() -- Line: 185
        -- upvalues: u3 (ref), u8 (copy)
        if u3 then
            u8:UpdateMovementMode();
        else
            u8:UpdateTouchGuiVisibility();
        end;

        u8:UpdateActiveControlModuleEnabled();
    end);

    if u3 then
        UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function() -- Line: 195
            -- upvalues: u8 (copy)
            u8:UpdateMovementMode();
        end);
        u8.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

        if not u8.playerGui then
            u8.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p13) -- Line: 201
                -- upvalues: u8 (copy)
                if p13:IsA("PlayerGui") then
                    u8.playerGui = p13;
                    u8.playerGuiAddedConn:Disconnect();
                    u8.playerGuiAddedConn = nil;
                    u8:UpdateMovementMode();
                end;
            end);
        end;

        u8:UpdateMovementMode();

        return u8;
    end;

    if not UserInputService.TouchEnabled then
        u8:OnLastInputTypeChanged(UserInputService:GetLastInputType());

        return u8;
    end;

    u8.playerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui");

    if not u8.playerGui then
        u8.playerGuiAddedConn = Players.LocalPlayer.ChildAdded:Connect(function(p14) -- Line: 219
            -- upvalues: u8 (copy), UserInputService (ref)
            if p14:IsA("PlayerGui") then
                u8.playerGui = p14;
                u8:CreateTouchGuiContainer();
                u8.playerGuiAddedConn:Disconnect();
                u8.playerGuiAddedConn = nil;
                u8:OnLastInputTypeChanged(UserInputService:GetLastInputType());
            end;
        end);

        return u8;
    end;

    u8:CreateTouchGuiContainer();
    u8:OnLastInputTypeChanged(UserInputService:GetLastInputType());

    return u8;
end;

function u1.GetMoveVector(p15) -- Line: 240
    return not p15.activeController and Vector3.new(0, 0, 0) or p15.activeController:GetMoveVector();
end;

local function NormalizeAngle(p16) -- Line: 247
    local v17 = (p16 + 12.566370614359172) % 6.283185307179586;

    if v17 > 3.141592653589793 then
        v17 = v17 - 6.283185307179586;
    end;

    return v17;
end;

local function AverageAngle(p18, p19) -- Line: 255
    local v20 = (p19 - p18 + 12.566370614359172) % 6.283185307179586;

    if v20 > 3.141592653589793 then
        v20 = v20 - 6.283185307179586;
    end;

    local v21 = (p18 + v20 / 2 + 12.566370614359172) % 6.283185307179586;

    if v21 > 3.141592653589793 then
        v21 = v21 - 6.283185307179586;
    end;

    return v21;
end;

function u1.GetEstimatedVRTorsoFrame(p22) -- Line: 260
    -- upvalues: VRService (copy)
    local v23 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local _, v24, _ = v23:ToEulerAnglesYXZ();
    local v25 = -v24;

    if VRService:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) and VRService:GetUserCFrameEnabled(Enum.UserCFrame.LeftHand) then
        local v26 = VRService:GetUserCFrame(Enum.UserCFrame.LeftHand);
        local v27 = VRService:GetUserCFrame(Enum.UserCFrame.RightHand);
        local v28 = v23.Position - v26.Position;
        local v29 = v23.Position - v27.Position;
        local v30 = -math.atan2(v28.X, v28.Z);
        local v31 = (-math.atan2(v29.X, v29.Z) - v30 + 12.566370614359172) % 6.283185307179586;

        if v31 > 3.141592653589793 then
            v31 = v31 - 6.283185307179586;
        end;

        local v32 = (v30 + v31 / 2 + 12.566370614359172) % 6.283185307179586;

        if v32 > 3.141592653589793 then
            v32 = v32 - 6.283185307179586;
        end;

        local v33 = (v25 - p22.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v33 > 3.141592653589793 then
            v33 = v33 - 6.283185307179586;
        end;

        local v34 = (v32 - p22.currentTorsoAngle + 12.566370614359172) % 6.283185307179586;

        if v34 > 3.141592653589793 then
            v34 = v34 - 6.283185307179586;
        end;

        local v35;

        if v34 > -1.5707963267948966 then
            v35 = v34 < 1.5707963267948966;
        else
            v35 = false;
        end;

        if not v35 then
            v34 = v33;
        end;

        local v36 = math.min(v34, v33);
        local v37 = math.max(v34, v33);
        local v38 = 0;

        if v36 > 0 then
            v37 = v36;
        elseif v37 >= 0 then
            v37 = v38;
        end;

        p22.currentTorsoAngle = v37 + p22.currentTorsoAngle;
    else
        p22.currentTorsoAngle = v25;
    end;

    return CFrame.new(v23.Position) * CFrame.fromEulerAnglesYXZ(0, -p22.currentTorsoAngle, 0);
end;

function u1.GetActiveController(p39) -- Line: 304
    return p39.activeController;
end;

function u1.UpdateActiveControlModuleEnabled(u40) -- Line: 309
    -- upvalues: Players (copy), u3 (copy), UserInputService (copy), ClickToMoveController (copy), TouchThumbstick (copy), DynamicThumbstick (copy), TouchJump (copy), GuiService (copy)
    local function _() -- Line: 311
        -- upvalues: u40 (copy), Players (ref)
        u40.activeController:Enable(false);

        if u40.touchJumpController then
            u40.touchJumpController:Enable(false);
        end;

        if u40.moveFunction then
            u40.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;
    end;

    local function v41() -- Line: 322
        -- upvalues: u40 (copy), u3 (ref), UserInputService (ref), ClickToMoveController (ref), TouchThumbstick (ref), DynamicThumbstick (ref), TouchJump (ref), Players (ref)
        if u40.touchControlFrame and (not u3 or UserInputService.PreferredInput == Enum.PreferredInput.Touch) and (u40.activeControlModule == ClickToMoveController or (u40.activeControlModule == TouchThumbstick or u40.activeControlModule == DynamicThumbstick)) then
            if not u40.controllers[TouchJump] then
                u40.controllers[TouchJump] = TouchJump.new();
            end;

            u40.touchJumpController = u40.controllers[TouchJump];
            u40.touchJumpController:Enable(true, u40.touchControlFrame);
        elseif u40.touchJumpController then
            u40.touchJumpController:Enable(false);
        end;

        if u40.activeControlModule == ClickToMoveController then
            u40.activeController:Enable(true, Players.LocalPlayer.DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice, u40.touchJumpController);

            return;
        end;

        if u40.touchControlFrame then
            u40.activeController:Enable(true, u40.touchControlFrame);

            return;
        end;

        u40.activeController:Enable(true);
    end;

    if not u40.activeController then
        return;
    end;

    if not u40.controlsEnabled then
        u40.activeController:Enable(false);

        if u40.touchJumpController then
            u40.touchJumpController:Enable(false);
        end;

        if u40.moveFunction then
            u40.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
        end;

        return;
    end;

    local v42;

    if u3 then
        v42 = UserInputService.PreferredInput == Enum.PreferredInput.Touch;
    else
        v42 = UserInputService.TouchEnabled;
    end;

    if GuiService.TouchControlsEnabled or (not v42 or u40.activeControlModule ~= ClickToMoveController and (u40.activeControlModule ~= TouchThumbstick and u40.activeControlModule ~= DynamicThumbstick)) then
        v41();

        return;
    end;

    u40.activeController:Enable(false);

    if u40.touchJumpController then
        u40.touchJumpController:Enable(false);
    end;

    if u40.moveFunction then
        u40.moveFunction(Players.LocalPlayer, Vector3.new(0, 0, 0), true);
    end;
end;

function u1.Enable(p43, p44) -- Line: 388
    local v45 = p44 == nil and true or p44;

    if p43.controlsEnabled == v45 then
        return;
    end;

    p43.controlsEnabled = v45;

    if not p43.activeController then
        return;
    end;

    p43:UpdateActiveControlModuleEnabled();
end;

function u1.Disable(p46) -- Line: 403
    p46:Enable(false);
end;

function u1.SelectComputerMovementModule(p47) -- Line: 409
    -- upvalues: UserInputService (copy), Players (copy), u3 (copy), Gamepad (copy), Keyboard (copy), u6 (copy), u7 (ref), UserGameSettings (copy), ClickToMoveController (copy), u5 (copy)
    if not (UserInputService.KeyboardEnabled or UserInputService.GamepadEnabled) then
        return nil, false;
    end;

    local v48 = nil;
    local DevComputerMovementMode = Players.LocalPlayer.DevComputerMovementMode;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.UserChoice then
        if u3 then
            if UserInputService.PreferredInput == Enum.PreferredInput.Gamepad then
                v48 = Gamepad;
            elseif UserInputService.PreferredInput == Enum.PreferredInput.KeyboardAndMouse then
                v48 = Keyboard;
            end;
        else
            v48 = u6[u7];
        end;

        if UserGameSettings.ComputerMovementMode == Enum.ComputerMovementMode.ClickToMove and v48 == Keyboard then
            v48 = ClickToMoveController;
        end;
    else
        v48 = u5[DevComputerMovementMode];

        if not v48 and DevComputerMovementMode ~= Enum.DevComputerMovementMode.Scriptable then
            warn("No character control module is associated with DevComputerMovementMode ", DevComputerMovementMode);
        end;
    end;

    if v48 then
        return v48, true;
    end;

    if DevComputerMovementMode == Enum.DevComputerMovementMode.Scriptable then
        return nil, true;
    end;

    return nil, false;
end;

function u1.SelectTouchModule(p49) -- Line: 456
    -- upvalues: u4 (copy), UserInputService (copy), Players (copy), u5 (copy), UserGameSettings (copy)
    if not (u4 or UserInputService.TouchEnabled) then
        return nil, false;
    end;

    local DevTouchMovementMode = Players.LocalPlayer.DevTouchMovementMode;
    local v50;

    if DevTouchMovementMode == Enum.DevTouchMovementMode.UserChoice then
        v50 = u5[UserGameSettings.TouchMovementMode];
    else
        if DevTouchMovementMode == Enum.DevTouchMovementMode.Scriptable then
            return nil, true;
        end;

        v50 = u5[DevTouchMovementMode];
    end;

    return v50, true;
end;

local function getGamepadRightThumbstickPosition() -- Line: 474
    -- upvalues: UserInputService (copy)
    local v51 = UserInputService:GetGamepadState(Enum.UserInputType.Gamepad1);

    for _, v in pairs(v51) do
        if v.KeyCode == Enum.KeyCode.Thumbstick2 then
            return v.Position;
        end;
    end;

    return Vector3.new(0, 0, 0);
end;

function u1.calculateRawMoveVector(p52, p53, p54) -- Line: 484
    -- upvalues: Workspace (copy), VRService (copy), getGamepadRightThumbstickPosition (copy)
    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return p54;
    end;

    local CFrame2 = CurrentCamera.CFrame;

    if VRService.VREnabled and p53.RootPart then
        VRService:GetUserCFrame(Enum.UserCFrame.Head);
        local v55 = p52:GetEstimatedVRTorsoFrame();

        if (CurrentCamera.Focus.Position - CFrame2.Position).Magnitude < 3 then
            CFrame2 = CFrame2 * v55;
        else
            CFrame2 = CurrentCamera.CFrame * (v55.Rotation + v55.Position * CurrentCamera.HeadScale);
        end;
    end;

    if p53:GetState() ~= Enum.HumanoidStateType.Swimming then
        local _, _, _, v56, v57, v58, _, _, v59, _, _, v56 = CFrame2:GetComponents();

        if v59 >= 1 or v59 <= -1 then
            v58 = -v57 * math.sign(v59);
        end;

        local v60 = math.sqrt(v56 * v56 + v58 * v58);

        return Vector3.new((v56 * p54.X + v58 * p54.Z) / v60, 0, (v56 * p54.Z - v58 * p54.X) / v60);
    end;

    if not VRService.VREnabled then
        return CFrame2:VectorToWorldSpace(p54);
    end;

    local v61 = Vector3.new(p54.X, 0, p54.Z);

    if v61.Magnitude < 0.01 then
        return Vector3.new(0, 0, 0);
    end;

    local v62 = -getGamepadRightThumbstickPosition().Y * 1.3962634015954636;
    local v63 = math.atan2(-v61.X, -v61.Z);
    local _, v64, _ = CFrame2:ToEulerAnglesYXZ();

    return CFrame.fromEulerAnglesYXZ(v62, v63 + v64, 0).LookVector;
end;

function u1.OnRenderStepped(p65, p66) -- Line: 543
    -- upvalues: Gamepad (copy), VRService (copy), Players (copy)
    if p65.activeController and (p65.activeController.enabled and p65.humanoid) then
        local v67 = p65.activeController:GetMoveVector();
        local v68 = p65.activeController:IsMoveVectorCameraRelative();
        local v69 = p65:GetClickToMoveController();

        if p65.activeController == v69 then
            v69:OnRenderStepped(p66);
        elseif v67.magnitude > 0 then
            v69:CleanupPath();
        else
            v69:OnRenderStepped(p66);
            v67 = v69:GetMoveVector();
            v68 = v69:IsMoveVectorCameraRelative();
        end;

        if p65.vehicleController then
            local v70;
            v67, v70 = p65.vehicleController:Update(v67, v68, p65.activeControlModule == Gamepad);
        end;

        if v68 then
            v67 = p65:calculateRawMoveVector(p65.humanoid, v67);
        end;

        p65.inputMoveVector = v67;

        if VRService.VREnabled then
            v67 = p65:updateVRMoveVector(v67);
        end;

        p65.moveFunction(Players.LocalPlayer, v67, false);
        local humanoid = p65.humanoid;
        local v71 = p65.activeController:GetIsJumping() or p65.touchJumpController and p65.touchJumpController:GetIsJumping();
        humanoid.Jump = v71;
    end;
end;

function u1.updateVRMoveVector(p72, p73) -- Line: 592
    -- upvalues: VRService (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if p73.Magnitude ~= 0 or ((CurrentCamera.Focus.Position - CurrentCamera.CFrame.Position).Magnitude >= 5 or (not VRService.AvatarGestures or (not p72.humanoid or p72.humanoid.Sit))) then
        return p73;
    end;

    local v74 = VRService:GetUserCFrame(Enum.UserCFrame.Head);
    local v75 = (CurrentCamera.CFrame * (v74.Rotation + v74.Position * CurrentCamera.HeadScale) * CFrame.new(0, -0.7 * p72.humanoid.RootPart.Size.Y / 2, 0)).Position - p72.humanoid.RootPart.CFrame.Position;

    return Vector3.new(v75.x, 0, v75.z);
end;

function u1.OnHumanoidSeated(p76, p77, p78) -- Line: 617
    -- upvalues: Value (copy)
    if p77 then
        if p78 and p78:IsA("VehicleSeat") then
            if not p76.vehicleController then
                p76.vehicleController = p76.vehicleController.new(Value);
            end;

            p76.vehicleController:Enable(true, p78);
        end;
    elseif p76.vehicleController then
        p76.vehicleController:Enable(false, p78);
    end;
end;

function u1.OnCharacterAdded(u79, p80) -- Line: 632
    -- upvalues: u3 (copy)
    u79.humanoid = p80:FindFirstChildOfClass("Humanoid");

    while not u79.humanoid do
        p80.ChildAdded:wait();
        u79.humanoid = p80:FindFirstChildOfClass("Humanoid");
    end;

    if not u3 then
        u79:UpdateTouchGuiVisibility();
    end;

    if u79.humanoidSeatedConn then
        u79.humanoidSeatedConn:Disconnect();
        u79.humanoidSeatedConn = nil;
    end;

    u79.humanoidSeatedConn = u79.humanoid.Seated:Connect(function(p81, p82) -- Line: 647
        -- upvalues: u79 (copy)
        u79:OnHumanoidSeated(p81, p82);
    end);

    if u3 then
        u79:UpdateMovementMode();
    end;
end;

function u1.OnCharacterRemoving(p83, p84) -- Line: 656
    -- upvalues: u3 (copy)
    p83.humanoid = nil;

    if u3 then
        p83:UpdateMovementMode();

        return;
    end;

    p83:UpdateTouchGuiVisibility();
end;

function u1.UpdateTouchGuiVisibility(p85) -- Line: 666
    -- upvalues: u3 (copy), GuiService (copy), UserInputService (copy)
    local v86;

    if u3 then
        v86 = p85.humanoid and GuiService.TouchControlsEnabled and UserInputService.PreferredInput == Enum.PreferredInput.Touch;

        if v86 and not p85.touchGui then
            p85:CreateTouchGuiContainer();
        end;
    else
        v86 = p85.humanoid and GuiService.TouchControlsEnabled;
    end;

    if p85.touchGui then
        p85.touchGui.Enabled = v86 and true or false;
    end;
end;

function u1.SwitchToController(p87, p88) -- Line: 690
    -- upvalues: Value (copy)
    if p88 then
        if not p87.controllers[p88] then
            p87.controllers[p88] = p88.new(Value);
        end;

        if p87.activeController ~= p87.controllers[p88] then
            if p87.activeController then
                p87.activeController:Enable(false);
            end;

            p87.activeController = p87.controllers[p88];
            p87.activeControlModule = p88;
            p87:UpdateActiveControlModuleEnabled();
        end;

        return;
    end;

    if p87.activeController then
        p87.activeController:Enable(false);
    end;

    p87.activeController = nil;
    p87.activeControlModule = nil;
end;

function u1.UpdateMovementMode(p89) -- Line: 729
    -- upvalues: UserInputService (copy)
    p89:UpdateTouchGuiVisibility();

    if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
        local v90, v91 = p89:SelectTouchModule();

        if v91 and p89.touchControlFrame then
            p89:SwitchToController(v90);
        end;
    else
        p89:SwitchToController((p89:SelectComputerMovementModule()));
    end;
end;

function u1.OnLastInputTypeChanged(p92, p93) -- Line: 746
    -- upvalues: u7 (ref), u6 (copy)
    if u7 == p93 then
        warn("LastInputType Change listener called with current type.");
    end;

    u7 = p93;

    if u7 == Enum.UserInputType.Touch then
        local v94, v95 = p92:SelectTouchModule();

        if v95 then
            while not p92.touchControlFrame do
                wait();
            end;

            p92:SwitchToController(v94);
        end;
    elseif u6[u7] ~= nil then
        local v96 = p92:SelectComputerMovementModule();

        if v96 then
            p92:SwitchToController(v96);
        end;
    end;

    p92:UpdateTouchGuiVisibility();
end;

function u1.OnComputerMovementModeChange(p97) -- Line: 774
    local v98, v99 = p97:SelectComputerMovementModule();

    if v99 then
        p97:SwitchToController(v98);
    end;
end;

function u1.OnTouchMovementModeChange(p100) -- Line: 782
    local v101, v102 = p100:SelectTouchModule();

    if v102 then
        while not p100.touchControlFrame do
            wait();
        end;

        p100:SwitchToController(v101);
    end;
end;

function u1.CreateTouchGuiContainer(p103) -- Line: 792
    -- upvalues: u3 (copy), u2 (ref)
    if u3 and not p103.playerGui then
        return;
    end;

    if p103.touchGui then
        p103.touchGui:Destroy();
    end;

    p103.touchGui = Instance.new("ScreenGui");
    p103.touchGui.Name = "TouchGui";
    p103.touchGui.ResetOnSpawn = false;
    p103.touchGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

    if not u3 then
        p103:UpdateTouchGuiVisibility();
    end;

    if u2 then
        p103.touchGui.ClipToDeviceSafeArea = false;
    end;

    p103.touchControlFrame = Instance.new("Frame");
    p103.touchControlFrame.Name = "TouchControlFrame";
    p103.touchControlFrame.Size = UDim2.new(1, 0, 1, 0);
    p103.touchControlFrame.BackgroundTransparency = 1;
    p103.touchControlFrame.Parent = p103.touchGui;
    p103.touchGui.Parent = p103.playerGui;
end;

function u1.GetClickToMoveController(p104) -- Line: 823
    -- upvalues: ClickToMoveController (copy), Value (copy)
    if not p104.controllers[ClickToMoveController] then
        p104.controllers[ClickToMoveController] = ClickToMoveController.new(Value);
    end;

    return p104.controllers[ClickToMoveController];
end;

return u1.new();