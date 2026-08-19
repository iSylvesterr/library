-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local LocalPlayer = Players.LocalPlayer;

local function zoomCameraCloser() -- Line: 57
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local FieldOfView = CurrentCamera.FieldOfView;
    CurrentCamera.FieldOfView = FieldOfView / 2.4;
    spawn(function() -- Line: 67
        -- upvalues: CurrentCamera (copy), FieldOfView (copy)
        wait(5);

        if CurrentCamera then
            CurrentCamera.FieldOfView = FieldOfView;
        end;
    end);
end;

(function() -- Line: 8, Name: createScreenEffect
    local Lighting = game:GetService("Lighting");
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Name = "BeeEffect";
    ColorCorrectionEffect.TintColor = Color3.fromRGB(255, 255, 0);
    ColorCorrectionEffect.Saturation = 0.5;
    ColorCorrectionEffect.Parent = Lighting;
    game:GetService("Debris"):AddItem(ColorCorrectionEffect, 5);
end)();
(function() -- Line: 20, Name: createVFX
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy)
    local v1 = ReplicatedStorage.Assets.ToolEffects.BeeToolEffect:Clone();
    local Character = LocalPlayer.Character;

    if Character then
        Character = Character:FindFirstChild("Head");
    end;

    if not Character then
        return;
    end;

    v1.CFrame = Character.CFrame;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Parent = v1;
    WeldConstraint.Part0 = Character;
    WeldConstraint.Part1 = v1;
    v1.Parent = Character;
    game:GetService("Debris"):AddItem(v1, 5);
end)();
(function() -- Line: 39, Name: invertMovement
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts");
    local u2 = require(PlayerScripts:WaitForChild("PlayerModule")):GetControls();
    local moveFunction = u2.moveFunction;

    function u2.moveFunction(p3, p4, p5) -- Line: 47
        -- upvalues: moveFunction (copy)
        return moveFunction(p3, -p4, p5);
    end;

    spawn(function() -- Line: 51
        -- upvalues: u2 (copy), moveFunction (copy)
        wait(5);
        u2.moveFunction = moveFunction;
    end);
end)();
local CurrentCamera = workspace.CurrentCamera;

if not CurrentCamera then
    return;
end;

local FieldOfView = CurrentCamera.FieldOfView;
CurrentCamera.FieldOfView = FieldOfView / 2.4;
spawn(function() -- Line: 67
    -- upvalues: CurrentCamera (copy), FieldOfView (copy)
    wait(5);

    if CurrentCamera then
        CurrentCamera.FieldOfView = FieldOfView;
    end;
end);