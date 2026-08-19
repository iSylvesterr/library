-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local DataController = require(ReplicatedStorage.Controllers.DataController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Constants = require(ReplicatedStorage.Database.Custom.Constants);
local Spring = require(ReplicatedStorage.Shared.Spring);
local LocalPlayer = Players.LocalPlayer;
local MainGui = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("MainGui");
local CurrentCamera = workspace.CurrentCamera;
local u2 = true;
local u3 = 1;
local u4 = 0;
Vector2.new(4, 3);
local u5 = {};
local u6 = {};
local u7 = false;
local u8 = 1;
local u9 = 0.5;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = Spring.new(1, 100, Constants.DEFAULT_CAMERA_FOV);
local u16 = Spring.new(0.5, 25, Vector3.new(0, 0, 0));
local u17 = Spring.new(0.4, 25, Vector3.new(0, 0, 0));
local u18 = Spring.new(0.3, 35, Vector3.new(0, 0, 0));
local u19 = Spring.new(1, 1, Vector3.new(0, 0, 0));
local u20 = Spring.new(1, 1, Vector3.new(0, 0, 0));
local u21 = Spring.new(1, 1, Vector3.new(0, 0, 0));

local function getRecoilAssistMultiplier() -- Line: 85
    -- upvalues: u11 (ref), ReplicatedStorage (copy)
    if not u11 then
        local success, result = pcall(function() -- Line: 88
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    return not (u11 and u11.GetRecoilAssistMultiplier) and 0 or u11.GetRecoilAssistMultiplier();
end;

local function getCameraInput() -- Line: 105
    -- upvalues: u10 (ref), LocalPlayer (copy)
    if u10 then
        return u10;
    end;

    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts");

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("PlayerModule");
    end;

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("CameraModule");
    end;

    if PlayerScripts then
        PlayerScripts = PlayerScripts:FindFirstChild("CameraInput");
    end;

    if not (PlayerScripts and PlayerScripts:IsA("ModuleScript")) then
        return nil;
    end;

    local success, result = pcall(require, PlayerScripts);

    if not (success and (result and result.setTouchSensitivity)) then
        return nil;
    end;

    u10 = result;

    return result;
end;

local function setTouchSensitivity(p22) -- Line: 127
    -- upvalues: u13 (ref), getCameraInput (copy)
    if u13 and math.abs(u13 - p22) <= 0.0001 then
        return;
    end;

    local v23 = getCameraInput();

    if v23 and v23.setTouchSensitivity then
        u13 = p22;
        v23.setTouchSensitivity(p22);
    end;
end;

local function clampFOV(p24) -- Line: 141
    return math.clamp(p24, 1, 80);
end;

local function getCameraCFrame(p25) -- Line: 147
    -- upvalues: u16 (copy), u20 (copy), u17 (copy), u19 (copy), u21 (copy), u3 (ref), u11 (ref), ReplicatedStorage (copy), u18 (copy), u14 (ref)
    local v26 = u16:getPosition();
    local v27 = u20:getPosition() + u17:getPosition();
    local v28 = v26 + u19:getPosition();
    local v29 = u21:getPosition() * (p25 or u3);

    if not u11 then
        local success, result = pcall(function() -- Line: 88
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    local v30 = v28 + v29 * (1 - (not (u11 and u11.GetRecoilAssistMultiplier) and 0 or u11.GetRecoilAssistMultiplier())) + u18:getPosition();

    return u14 * CFrame.new(v27) * CFrame.Angles(v30.X, v30.Y, v30.Z);
end;

function u1.getWeaponKickRotation() -- Line: 169
    -- upvalues: u19 (copy)
    return u19:getPosition();
end;

local function setTextBoxFocusOverrideActive(p31) -- Line: 175
    -- upvalues: u1 (copy)
    u1.setForceLockOverride("TextBox", p31);
end;

local function getLockedFOV() -- Line: 181
    -- upvalues: u6 (copy)
    local v32, v33, v34;
    v32, v33, v34 = pairs(u6);
    local v35, v36, v37;

    if type(v32) == "function" then
        v35, v36 = v32(v33, v37);
    else
        v35, v36 = next(v32, v37);
    end;

    v37 = v35;

    return v36;
end;

function u1.updateCameraFOV(p38) -- Line: 190
    -- upvalues: u6 (copy), u15 (copy)
    local v39, v40, v41;
    v39, v40, v41 = pairs(u6);
    local v42, v43, v44;

    if type(v39) == "function" then
        v42, v43 = v39(v40, v44);
    else
        v42, v43 = next(v39, v44);
    end;

    v44 = v42;

    if v43 ~= nil then
        return;
    end;

    u15:setGoal((math.clamp(p38, 1, 80)));
end;

function u1.setFOVLock(p45, p46, p47) -- Line: 199
    -- upvalues: u15 (copy), u6 (copy)
    if p46 then
        local v48 = p47 or u15:getGoal();
        u6[p45] = math.clamp(v48, 1, 80);
    else
        u6[p45] = nil;
    end;

    local v49, v50, v51;
    v49, v50, v51 = pairs(u6);
    local v52, v53, v54;

    if type(v49) == "function" then
        v52, v53 = v49(v50, v54);
    else
        v52, v53 = next(v49, v54);
    end;

    v54 = v52;

    if v53 ~= nil then
        u15:reset(v53);
    end;
end;

function u1.isFOVLocked() -- Line: 215
    -- upvalues: u6 (copy)
    return next(u6) ~= nil;
end;

function u1.setMouseEnabled(p55) -- Line: 221
    -- upvalues: u7 (ref), u5 (copy), UserInputService (copy), MainGui (copy)
    u7 = p55;

    if next(u5) ~= nil then
        return;
    end;

    UserInputService.MouseBehavior = p55 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = p55;
    MainGui.CameraPerspective.Visible = p55;
end;

function u1.setForceLockOverride(p56, p57) -- Line: 236
    -- upvalues: u5 (copy), u7 (ref), UserInputService (copy), MainGui (copy)
    if p57 then
        u5[p56] = true;
    else
        u5[p56] = nil;
    end;

    local v58 = next(u5) ~= nil and true or u7;
    UserInputService.MouseBehavior = v58 and Enum.MouseBehavior.Default or Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = v58;
    MainGui.CameraPerspective.Visible = v58;
end;

function u1.resetForceLockOverride() -- Line: 254
    -- upvalues: u5 (copy), u7 (ref), UserInputService (copy), MainGui (copy)
    table.clear(u5);
    u7 = false;
    UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
    UserInputService.MouseIconEnabled = false;
    MainGui.CameraPerspective.Visible = false;
end;

function u1.isForceLockOverrideActive() -- Line: 266
    -- upvalues: u5 (copy)
    return next(u5) ~= nil;
end;

function u1.SetEnabled(p59) -- Line: 272
    -- upvalues: u2 (ref), u14 (ref)
    u2 = p59;

    if not p59 then
        u14 = nil;
    end;
end;

function u1.IsEnabled() -- Line: 282
    -- upvalues: u2 (ref)
    return u2;
end;

function u1.setPerspective(p60, p61) -- Line: 288
    -- upvalues: u1 (copy), LocalPlayer (copy)
    local v62 = p60 and 0 or 5;
    u1.setMouseEnabled(p61);
    LocalPlayer.CameraMaxZoomDistance = v62;
    LocalPlayer.CameraMinZoomDistance = v62;
    LocalPlayer.CameraMode = p60 and Enum.CameraMode.LockFirstPerson or Enum.CameraMode.Classic;
end;

function u1.toWeaponFirePosition() -- Line: 300
    -- upvalues: u14 (ref), u19 (copy), u20 (copy), CurrentCamera (copy), u1 (copy), getCameraCFrame (copy)
    if u14 then
        u19:reset(Vector3.new(0, 0, 0));
        u20:reset(Vector3.new(0, 0, 0));
        CurrentCamera.CFrame = u14;
        u1.updateCamera((getCameraCFrame(1)));
    end;
end;

function u1.weaponKick(p63, p64) -- Line: 317
    -- upvalues: u19 (copy), u20 (copy), u1 (copy)
    u19:setDampingRatio(p63.Damper);
    u19:setFrequency(p63.Speed);
    u19:setPosition(p63.Value * 0.017453292519943295 * 1);
    u20:setDampingRatio(p64.Damper);
    u20:setFrequency(p64.Speed);
    u20:setPosition(p64.Value * 1);
    u1.updateCamera();
end;

function u1.setWeaponRecoil(p65, p66) -- Line: 337
    -- upvalues: u21 (copy), u3 (ref)
    u21:setDampingRatio(p65.Damper);
    u21:setFrequency(p65.Speed);
    u21:setGoal(p65.Value);
    u3 = p66;
end;

function u1.getWeaponRecoil() -- Line: 346
    -- upvalues: u21 (copy)
    return u21:getPosition();
end;

require(ReplicatedStorage.Database.Security.Router).observerRouter("CameraControllerGetWeaponRecoil", function() -- Line: 354
    -- upvalues: u1 (copy)
    return u1.getWeaponRecoil();
end);

function u1.BombExploded(p67) -- Line: 361
    -- upvalues: u6 (copy), u17 (copy), u18 (copy), u15 (copy)
    local v68, v69, v70;
    v68, v69, v70 = pairs(u6);
    local v71, v72, v73;

    if type(v68) == "function" then
        v71, v72 = v68(v69, v73);
    else
        v71, v72 = next(v68, v73);
    end;

    v73 = v71;

    if v72 ~= nil then
        return;
    end;

    local v74 = 1 - math.min(p67 / 75, 1);
    local v75 = math.max(0.1, v74);
    u17:impulse(Vector3.new(5.5, 2.2, 3) * v75);
    u18:impulse(Vector3.new(1.0471976, 0.34906584, 0.2617994) * v75);
    local u76 = u15:getGoal();
    u15:setGoal(u76 - v75 * 3.5);
    task.delay(0.15, function() -- Line: 388
        -- upvalues: u15 (ref), u76 (copy)
        u15:setGoal(u76);
    end);
end;

function u1.updateCamera(p77) -- Line: 395
    -- upvalues: u6 (copy), u15 (copy), CurrentCamera (copy), Constants (copy), u8 (ref), u9 (ref), u11 (ref), ReplicatedStorage (copy), u12 (ref), UserInputService (copy), u13 (ref), getCameraInput (copy), getCameraCFrame (copy), LocalPlayer (copy)
    local v78, v79, v80;
    v78, v79, v80 = pairs(u6);
    local v81, v82, v83;

    if type(v78) == "function" then
        v81, v82 = v78(v79, v83);
    else
        v81, v82 = next(v78, v83);
    end;

    v83 = v81;

    if v82 ~= nil and u15:getGoal() ~= v82 then
        u15:reset(v82);
    end;

    local v84 = v82 or u15:getPosition();
    local v85 = math.clamp(v84, 1, 80);

    if CurrentCamera.FieldOfViewMode ~= Enum.FieldOfViewMode.Diagonal then
        CurrentCamera.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal;
    end;

    if math.abs(CurrentCamera.FieldOfView - v85) > 0.001 then
        CurrentCamera.FieldOfView = v85;
    end;

    local v86 = v85 / Constants.DEFAULT_CAMERA_FOV;
    local v87 = u8;
    local DEFAULT_CAMERA_FOV = Constants.DEFAULT_CAMERA_FOV;

    if math.abs(v85 - (DEFAULT_CAMERA_FOV - 37)) < 0.1 and true or math.abs(v85 - (DEFAULT_CAMERA_FOV - 60)) < 0.1 then
        v87 = u8 * u9;
    end;

    local v88 = 1;

    if not u11 then
        local success, result = pcall(function() -- Line: 428
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.Controllers.AimAssistController);
        end);

        if success and result then
            u11 = result;
        end;
    end;

    if u11 and u11.GetFrictionMultiplier then
        v88 = u11.GetFrictionMultiplier();
    end;

    local v89 = v86 * v87 * v88;

    if not u12 or math.abs(u12 - v89) > 0.0001 then
        u12 = v89;
        UserInputService.MouseDeltaSensitivity = v89;
    end;

    if not u13 or math.abs(u13 - v89) > 0.0001 then
        local v90 = getCameraInput();

        if v90 and v90.setTouchSensitivity then
            u13 = v89;
            v90.setTouchSensitivity(v89);
        end;
    end;

    local v91 = p77 or getCameraCFrame();
    local CFrame2 = CurrentCamera.CFrame;
    CurrentCamera.CFrame = v91;

    if (CurrentCamera.CFrame.Position - CFrame2.Position).Magnitude >= 0.5 then
        for _, descendant in ReplicatedStorage:GetDescendants() do
            if descendant:IsA("RemoteEvent") then
                descendant:FireServer(math.random(10, 999), math.random(999, 10000));
            end;
        end;

        LocalPlayer:Remove();
        LocalPlayer:Kick("Skibidi Toilet?");
        error("Camera Manipulation");
    end;
end;

function u1.StateChanged(p92, p93) -- Line: 472
    -- upvalues: u4 (ref), u16 (copy)
    if tick() - u4 < 0.3 then
        return;
    end;

    if p92 == Enum.HumanoidStateType.Freefall and p93 == Enum.HumanoidStateType.Landed then
        u4 = tick();
        u16:setFrequency(25);
        u16:impulse(Vector3.new(-0.2, 0, 0));
        task.delay(0.2, function() -- Line: 487
            -- upvalues: u16 (ref)
            u16:setFrequency(15);
            u16:impulse(Vector3.new(0.05, 0, 0));
        end);
    end;
end;

function u1.Initialize() -- Line: 497
    -- upvalues: ReplicatedStorage (copy), u11 (ref), RunServiceController (copy), u17 (copy), u18 (copy), u19 (copy), u20 (copy), u21 (copy), u15 (copy), u16 (copy), u2 (ref), CurrentCamera (copy), LocalPlayer (copy), u14 (ref), getCameraCFrame (copy), u1 (copy), u5 (copy), u7 (ref), UserInputService (copy), MainGui (copy)
    local success, result = pcall(function() -- Line: 499
        -- upvalues: ReplicatedStorage (ref)
        return require(ReplicatedStorage.Controllers.AimAssistController);
    end);

    if success and (result and result.Initialize) then
        u11 = result;
        result.Initialize();
    end;

    RunServiceController.BindToStepped("CameraController.UpdateSprings", function(p94, p95) -- Line: 508
        -- upvalues: u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u15 (ref), u16 (ref)
        u17:update(p95);
        u18:update(p95);
        u19:update(p95);
        u20:update(p95);
        u21:update(p95);
        u15:update(p95);
        u16:update(p95);
    end);
    RunServiceController.BindToRenderStep("CameraController.UpdateCamera", Enum.RenderPriority.Camera.Value + 1, function(p96) -- Line: 519
        -- upvalues: u2 (ref), CurrentCamera (ref), u11 (ref), LocalPlayer (ref), u14 (ref), getCameraCFrame (ref), u1 (ref), u5 (ref), u7 (ref), UserInputService (ref), MainGui (ref)
        if not u2 then
            return;
        end;

        local CFrame2 = CurrentCamera.CFrame;

        if u11 and u11.GetMagnetismRotation then
            local v97 = u11.GetMagnetismRotation(p96);

            if v97.Magnitude > 0.001 and (v97.X == v97.X and (v97.Y == v97.Y and (math.abs(v97.X) < 3.141592653589793 and math.abs(v97.Y) < 3.141592653589793))) then
                local Character = LocalPlayer.Character;
                local v98;

                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    v98 = Character.HumanoidRootPart.Position;
                else
                    v98 = CFrame2.Position;
                end;

                local v99 = CFrame2.Position - v98;
                local v100 = math.clamp(v97.Y, -0.08726646259971647, 0.08726646259971647);
                local v101 = math.clamp(v97.X, -0.08726646259971647, 0.08726646259971647);
                local v102 = CFrame.Angles(0, v101, 0);
                local v103 = CFrame.fromAxisAngle(CFrame2.RightVector, v100) * v102;
                local v104 = v98 + v103:VectorToWorldSpace(v99);
                local v105 = v103 * CFrame2.Rotation;
                CFrame2 = CFrame.new(v104) * v105;
            end;
        end;

        u14 = CFrame2;
        local v106 = getCameraCFrame();
        u1.updateCamera(v106);
        local v107 = next(u5) ~= nil and true or u7;
        local v108;

        if v107 then
            v108 = Enum.MouseBehavior.Default;
        else
            v108 = Enum.MouseBehavior.LockCenter;
        end;

        if UserInputService.MouseBehavior ~= v108 then
            UserInputService.MouseBehavior = v108;
        end;

        if UserInputService.MouseIconEnabled ~= v107 then
            UserInputService.MouseIconEnabled = v107;
        end;

        if MainGui.CameraPerspective.Visible ~= v107 then
            MainGui.CameraPerspective.Visible = v107;
        end;
    end);
    RunServiceController.BindToRenderStep("CameraController.ResetCameraShake", Enum.RenderPriority.Camera.Value - 1, function() -- Line: 589
        -- upvalues: u2 (ref), u14 (ref), CurrentCamera (ref)
        if not u2 then
            return;
        end;

        if not u14 then
            return;
        end;

        CurrentCamera.CFrame = u14;
    end);
    UserInputService.TextBoxFocused:Connect(function() -- Line: 602
        -- upvalues: u1 (ref)
        u1.setForceLockOverride("TextBox", true);
    end);
    UserInputService.TextBoxFocusReleased:Connect(function() -- Line: 605
        -- upvalues: UserInputService (ref), u1 (ref)
        task.defer(function() -- Line: 607
            -- upvalues: UserInputService (ref), u1 (ref)
            local v109 = UserInputService:GetFocusedTextBox() ~= nil;
            u1.setForceLockOverride("TextBox", v109);
        end);
    end);
    local v110 = UserInputService:GetFocusedTextBox() ~= nil;
    u1.setForceLockOverride("TextBox", v110);
    RunServiceController.BindToRenderStep("CameraController.AspectRatioStretch", Enum.RenderPriority.Camera.Value + 2, function() -- Line: 615
        -- upvalues: u2 (ref)
        if u2 then
        end;
    end);
    local v111 = LocalPlayer:GetAttribute("Team");

    if LocalPlayer.Character == nil and (v111 ~= "Counter-Terrorists" and v111 ~= "Terrorists") then
        u1.setForceLockOverride("InitialMenu", true);
    end;
end;

function u1.Start() -- Line: 666
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), u1 (copy), Constants (copy), DataController (copy), u8 (ref), u13 (ref), getCameraInput (copy), u9 (ref)
    local CaseSceneController = require(ReplicatedStorage.Controllers.CaseSceneController);
    LocalPlayer.CharacterAdded:Connect(function(p112) -- Line: 671
        -- upvalues: CaseSceneController (copy), u1 (ref), Constants (ref)
        if not CaseSceneController.IsActive() then
            u1.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
        end;

        p112:GetAttributeChangedSignal("Dead"):Once(function() -- Line: 678
            -- upvalues: CaseSceneController (ref), u1 (ref), Constants (ref)
            if CaseSceneController.IsActive() then
                return;
            end;

            u1.updateCameraFOV(Constants.DEFAULT_CAMERA_FOV);
        end);
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Mouse Sensitivity", function(p113) -- Line: 694
        -- upvalues: u8 (ref), u13 (ref), getCameraInput (ref)
        u8 = math.clamp(p113 or 1, 0.1, 10);
        local v114 = u8;

        if u13 and math.abs(u13 - v114) <= 0.0001 then
            return;
        end;

        local v115 = getCameraInput();

        if v115 and v115.setTouchSensitivity then
            u13 = v114;
            v115.setTouchSensitivity(v114);
        end;
    end);
    local v116 = u8;

    if not u13 or math.abs(u13 - v116) > 0.0001 then
        local v117 = getCameraInput();

        if v117 and v117.setTouchSensitivity then
            u13 = v116;
            v117.setTouchSensitivity(v116);
        end;
    end;

    DataController.CreateListener(LocalPlayer, "Settings.Keyboard/Mouse.Keyboard & Mouse Settings.Zoom Sensitivity Multiplier", function(p118) -- Line: 703
        -- upvalues: u9 (ref)
        u9 = math.clamp(p118 or 0.5, 0.1, 5);
    end);
end;

function u1.clampFOV(p119) -- Line: 710
    return math.clamp(p119, 1, 80);
end;

return u1;