-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CurrentCamera = workspace.CurrentCamera;
local u2 = Vector2.new(9.42477796076938, 5.497787143782138);

local function GetReplicationFocus() -- Line: 43
    local Map = workspace:FindFirstChild("Map");

    if not Map then
        return nil;
    end;

    local ReplicationFocus = Map:FindFirstChild("ReplicationFocus");

    if ReplicationFocus then
        return ReplicationFocus:FindFirstChild("Focus");
    end;

    return nil;
end;

function u1.UpdateMovement(p3, p4) -- Line: 56
    -- upvalues: InputController (copy)
    local v5 = Vector3.new(0, 0, 0);

    if InputController.isActionActive("Move Forward") then
        v5 = v5 + Vector3.new(0, 0, -1);
    end;

    if InputController.isActionActive("Move Backward") then
        v5 = v5 + Vector3.new(0, 0, 1);
    end;

    if InputController.isActionActive("Move Left (Strafe)") then
        v5 = v5 + Vector3.new(-1, 0, 0);
    end;

    if InputController.isActionActive("Move Right (Strafe)") then
        v5 = v5 + Vector3.new(1, 0, 0);
    end;

    local v6 = 40 * (InputController.isActionActive("Walk") and 0.2 or 1);

    if v5 ~= Vector3.new(0, 0, 0) then
        v5 = v5.Unit;
    end;

    local CameraCFrame = p3.CameraCFrame;
    local LookVector = CameraCFrame.LookVector;
    local v7 = p3.CameraCFrame.Position + (CameraCFrame.RightVector * v5.X + CameraCFrame.UpVector * v5.Y + LookVector * -v5.Z) * (v6 * p4);
    p3.CameraCFrame = CFrame.new(v7, v7 + LookVector);
    p3:UpdateMouseWheel(p4);
end;

function u1.UpdateMouseWheel(p8, p9) -- Line: 111
    -- upvalues: InputController (copy)
    if p8.MouseWheelDelta ~= 0 then
        local v10 = InputController.isActionActive("Walk");
        local CameraCFrame = p8.CameraCFrame;
        local LookVector = CameraCFrame.LookVector;
        local v11 = 15 * (v10 and 0.5 or 1);
        local v12 = CameraCFrame.Position + LookVector * (p8.MouseWheelDelta > 0 and v11 and v11 or -v11);
        p8.CameraCFrame = CFrame.new(v12, v12 + LookVector);
        p8.MouseWheelDelta = 0;
    end;
end;

function u1.UpdateRotation(p13, p14) -- Line: 138
    -- upvalues: UserInputService (copy), InputController (copy), CurrentCamera (copy), u2 (copy)
    local v15 = UserInputService:GetMouseDelta();
    local v16 = InputController.isActionActive("Walk") and 0.5 or 1;
    local ViewportSize = CurrentCamera.ViewportSize;
    local v17 = v15.X / ViewportSize.X * (u2.X * v16);
    local v18 = v15.Y / ViewportSize.Y * (u2.Y * v16);
    local CameraCFrame = p13.CameraCFrame;
    local Position = CameraCFrame.Position;
    local LookVector = CameraCFrame.LookVector;
    local v19 = math.asin(LookVector.Y) - v18;
    local v20 = math.clamp(v19, -1.3962634015954636, 1.3962634015954636);
    local v21 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local Magnitude = v21.Magnitude;
    local v22 = Magnitude < 0.001 and Vector3.new(0, 0, -1) or v21 / Magnitude;
    local v23 = math.atan2(-v22.X, -v22.Z) - v17;
    local v24 = math.cos(v20);
    local v25 = -math.sin(v23) * v24;
    local v26 = math.sin(v20);
    local v27 = -math.cos(v23) * v24;
    local v28 = Vector3.new(v25, v26, v27);
    p13.CameraCFrame = CFrame.new(Position, Position + v28);
end;

function u1.UpdateCamera(p29) -- Line: 200
    -- upvalues: CurrentCamera (copy)
    CurrentCamera.CFrame = p29.CameraCFrame;
end;

function u1.Render(p30, p31) -- Line: 206
    p30:UpdateMovement(p31);
    p30:UpdateRotation(p31);
    p30:UpdateCamera();
end;

function u1.Start(u32) -- Line: 220
    -- upvalues: CurrentCamera (copy), CameraController (copy), UserInputService (copy), RunServiceController (copy), LocalPlayer (copy)
    if u32.IsActive then
        return;
    end;

    u32.IsActive = true;
    u32.CameraCFrame = CurrentCamera.CFrame;
    u32.MouseWheelDelta = 0;
    CurrentCamera.CameraType = Enum.CameraType.Scriptable;
    CameraController.setMouseEnabled(false);
    u32.Janitor:Add(UserInputService:GetPropertyChangedSignal("MouseBehavior"):Connect(function() -- Line: 243
        -- upvalues: u32 (copy), UserInputService (ref)
        if u32.IsActive and UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter;
        end;
    end), "Disconnect", "EnforceMouseBehavior");
    u32.RenderStepName = "Freecam";
    RunServiceController.BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value + 10, function(p33) -- Line: 251
        -- upvalues: u32 (copy)
        if not u32.IsActive then
            return;
        end;

        u32:Render(p33);
    end);
    local Map = workspace:FindFirstChild("Map");
    local v34;

    if Map then
        local ReplicationFocus = Map:FindFirstChild("ReplicationFocus");

        if ReplicationFocus then
            v34 = ReplicationFocus:FindFirstChild("Focus");
        else
            v34 = nil;
        end;
    else
        v34 = nil;
    end;

    if v34 then
        LocalPlayer.ReplicationFocus = v34;
        u32.Janitor:Add(function() -- Line: 265
            -- upvalues: LocalPlayer (ref)
            LocalPlayer.ReplicationFocus = nil;
        end, true, "ReplicationFocus");
    end;

    u32.Janitor:Add(function() -- Line: 271
        -- upvalues: RunServiceController (ref)
        RunServiceController.UnbindFromRenderStep("Freecam");
    end, true);
end;

function u1.Stop(p35) -- Line: 278
    -- upvalues: RunServiceController (copy), CurrentCamera (copy)
    if p35.IsActive then
        p35.IsActive = false;
        RunServiceController.UnbindFromRenderStep("Freecam");
        p35.RenderStepName = nil;
        CurrentCamera.CameraType = Enum.CameraType.Custom;

        if p35.Janitor:Get("EnforceMouseBehavior") then
            p35.Janitor:Remove("EnforceMouseBehavior");
        end;

        if p35.Janitor:Get("ReplicationFocus") then
            p35.Janitor:Remove("ReplicationFocus");
        end;
    end;
end;

function u1.new() -- Line: 305
    -- upvalues: u1 (copy), Janitor (copy), UserInputService (copy)
    local u36 = setmetatable({}, u1);
    u36.Janitor = Janitor.new();
    u36.CameraCFrame = CFrame.identity;
    u36.MouseWheelDelta = 0;
    u36.RenderStepName = nil;
    u36.IsActive = false;
    u36.Janitor:Add(UserInputService.InputChanged:Connect(function(p37, p38) -- Line: 322
        -- upvalues: u36 (copy)
        if u36.IsActive and (not p38 and p37.UserInputType == Enum.UserInputType.MouseWheel) then
            u36.MouseWheelDelta = p37.Position.Z;
        end;
    end), "Disconnect");
    u36.Janitor:Add(function() -- Line: 329
        -- upvalues: u36 (copy)
        if u36.IsActive then
            u36:Stop();
        end;
    end);

    return u36;
end;

function u1.Destroy(p39) -- Line: 343
    p39.Janitor:Destroy();
end;

return u1;