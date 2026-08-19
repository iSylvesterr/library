-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local LocalPlayer = Players.LocalPlayer;
local Parent = script.Parent;
local LaserGunRemote = Parent.LaserGunRemote;
local u1 = LocalPlayer:GetMouse();

local function getRootPart(p2) -- Line: 20
    local PrimaryPart = p2.PrimaryPart;

    if PrimaryPart then
        return PrimaryPart;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return HumanoidRootPart;
    end;

    return nil;
end;

Parent.Activated:Connect(function() -- Line: 34, Name: onActivated
    -- upvalues: ToolGameplayGuard (copy), Parent (copy), LocalPlayer (copy), u1 (copy), LaserGunRemote (copy)
    if not ToolGameplayGuard.CanActivateLocal(Parent) then
        return;
    end;

    local Character = LocalPlayer.Character;

    if not Character then
        return;
    end;

    local PrimaryPart = Character.PrimaryPart;

    if not PrimaryPart then
        PrimaryPart = Character:FindFirstChild("HumanoidRootPart");

        if not (PrimaryPart and PrimaryPart:IsA("BasePart")) then
            PrimaryPart = nil;
        end;
    end;

    if not PrimaryPart then
        return;
    end;

    local v3 = u1.Hit.Position - PrimaryPart.Position;
    local Magnitude = v3.Magnitude;

    if Magnitude == 0 or Magnitude ~= Magnitude then
        return;
    end;

    LaserGunRemote:FireServer({
        direction = v3.Unit
    });
end);