-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);
local u2 = {
    Neck = {
        CF = { CFrame.new(0, 1, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1), CFrame.new(0, -0.5, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1) }
    },
    HumanoidRootPart = {
        CF = { CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), CFrame.new(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0) }
    },
    ["Right Shoulder"] = {
        CF = { CFrame.new(1.3, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.2, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) }
    },
    ["Left Shoulder"] = {
        CF = { CFrame.new(-1.3, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1), CFrame.new(0.2, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1) }
    },
    ["Right Hip"] = {
        CF = { CFrame.new(0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1) }
    },
    ["Left Hip"] = {
        CF = { CFrame.new(-0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1) }
    }
};

local function ToggleMotor6D(p3, p4) -- Line: 33
    local Torso = p3:FindFirstChild("Torso");

    if not Torso then
        return;
    end;

    for _, descendant in Torso:GetDescendants() do
        if descendant:IsA("Motor6D") then
            descendant.Enabled = p4;
        end;
    end;
end;

local function ClearMomentum(p5) -- Line: 49
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
            descendant.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
        end;
    end;
end;

local function ToggleCollisionParts(p6, p7) -- Line: 58
    if p7 then
        for _, child in pairs(p6:GetChildren()) do
            if child:IsA("BasePart") and child.Name ~= "HumanoidRootPart" then
                local v8 = child:Clone();
                v8.Size = child.Size * 0.75;
                v8.CanCollide = true;
                v8.Massless = true;
                v8.Name = "Collider";
                v8.Transparency = 1;
                v8.Parent = p6;
                local Weld = Instance.new("Weld");
                Weld.Part0 = child;
                Weld.Part1 = v8;
                Weld.Parent = v8;
            end;
        end;

        return;
    end;

    for _, child in pairs(p6:GetChildren()) do
        if child.Name == "Collider" then
            child:Destroy();
        end;
    end;
end;

local function BuildConstraints(p9, p10) -- Line: 85
    -- upvalues: u2 (copy)
    local Torso = p9:FindFirstChild("Torso");

    if not Torso then
        return;
    end;

    if p10 then
        for _, child in pairs(Torso:GetChildren()) do
            if child:IsA("Motor6D") and child.Part1 then
                local v11 = u2[child.Name];

                if v11 then
                    local Attachment = Instance.new("Attachment");
                    local Attachment2 = Instance.new("Attachment");
                    local BallSocketConstraint = Instance.new("BallSocketConstraint");
                    Attachment.Name = "RagdollAttachment";
                    Attachment.CFrame = v11.CF[2];
                    Attachment.Parent = child.Part1;
                    Attachment2.Name = "RagdollAttachment";
                    Attachment2.CFrame = v11.CF[1];
                    Attachment2.Parent = Torso;
                    BallSocketConstraint.Name = "RagdollConstraint";
                    BallSocketConstraint.Attachment0 = Attachment;
                    BallSocketConstraint.Attachment1 = Attachment2;
                    BallSocketConstraint.LimitsEnabled = true;
                    BallSocketConstraint.UpperAngle = 180;
                    BallSocketConstraint.TwistLimitsEnabled = true;
                    BallSocketConstraint.TwistLowerAngle = -90;
                    BallSocketConstraint.TwistUpperAngle = 90;
                    BallSocketConstraint.Parent = Torso;
                    child.Part1:SetAttribute("PreRagdollCollisionGroup", child.Part1.CollisionGroup);
                    child.Part1.CollisionGroup = "Ragdoll";
                end;
            end;
        end;

        return;
    end;

    for _, child in pairs(Torso:GetChildren()) do
        if child:IsA("BallSocketConstraint") and child.Name == "RagdollConstraint" then
            if child.Attachment0 then
                child.Attachment0:Destroy();
            end;

            if child.Attachment1 then
                child.Attachment1:Destroy();
            end;

            child:Destroy();
        elseif child:IsA("Motor6D") and child.Part1 then
            local v12 = child.Part1:GetAttribute("PreRagdollCollisionGroup");
            child.Part1.CollisionGroup = type(v12) ~= "string" and "Default" or v12;
            child.Part1:SetAttribute("PreRagdollCollisionGroup", nil);
        end;
    end;
end;

function u1.Unragdoll(p13, p14) -- Line: 152
    -- upvalues: Players (copy), ToggleMotor6D (copy), BuildConstraints (copy), ClearMomentum (copy)
    local v15 = p14:FindFirstChildWhichIsA("Humanoid");
    Players:GetPlayerFromCharacter(p14);

    if not v15 then
        return;
    end;

    p14:SetAttribute("Ragdolled", nil);
    v15.RequiresNeck = true;
    ToggleMotor6D(p14, true);

    for _, child in pairs(p14:GetChildren()) do
        if child.Name == "Collider" then
            child:Destroy();
        end;
    end;

    BuildConstraints(p14, false);
    ClearMomentum(p14);
    v15.AutoRotate = true;
    v15.PlatformStand = false;

    if v15:GetState() ~= Enum.HumanoidStateType.Dead then
        v15:ChangeState(Enum.HumanoidStateType.GettingUp);
    end;
end;

function u1.Ragdoll(p16, u17, p18) -- Line: 185
    -- upvalues: Players (copy), u1 (copy), ToggleMotor6D (copy), ToggleCollisionParts (copy), BuildConstraints (copy)
    local v19 = u17:FindFirstChildWhichIsA("Humanoid");
    Players:GetPlayerFromCharacter(u17);

    if not (v19 and v19.RootPart) then
        return;
    end;

    if v19:GetState() == Enum.HumanoidStateType.Dead then
        return;
    end;

    if u17:GetAttribute("Ragdolled") then
        return;
    end;

    u17:SetAttribute("Ragdolled", true);

    if p18 then
        task.delay(p18, function() -- Line: 201
            -- upvalues: u1 (ref), u17 (copy)
            u1:Unragdoll(u17);
        end);
    end;

    v19.RequiresNeck = false;
    ToggleMotor6D(u17, false);
    ToggleCollisionParts(u17, true);
    BuildConstraints(u17, true);
    v19.AutoRotate = false;
    v19.PlatformStand = true;
    v19:ChangeState(Enum.HumanoidStateType.Physics);
end;

if game:GetService("RunService"):IsClient() then
    Networking.Ragdoll.Enable.OnClientEvent:Connect(function(p20) -- Line: 226
        -- upvalues: u1 (copy)
        u1:Ragdoll(game.Players.LocalPlayer.Character, p20);
    end);
    Networking.Ragdoll.Disable.OnClientEvent:Connect(function(p21) -- Line: 231
        -- upvalues: u1 (copy)
        local Character = game.Players.LocalPlayer.Character;

        if Character then
            u1:Unragdoll(Character);
        end;
    end);
    Networking.Ragdoll.EnableForRig.OnClientEvent:Connect(function(p22) -- Line: 239
        -- upvalues: u1 (copy)
        if not (p22 and p22:IsDescendantOf(workspace)) then
            return;
        end;

        u1:Ragdoll(p22);
    end);
    Networking.Ragdoll.DisableForRig.OnClientEvent:Connect(function(p23) -- Line: 244
        -- upvalues: u1 (copy)
        if not p23 then
            return;
        end;

        u1:Unragdoll(p23);
    end);
    Networking.Ragdoll.StartRagdoll.OnClientEvent:Connect(function(p24) -- Line: 250
        -- upvalues: u1 (copy)
        if not (p24 and p24:IsDescendantOf(workspace)) then
            return;
        end;

        u1:Ragdoll(p24);
    end);
    Networking.Ragdoll.StopRagdoll.OnClientEvent:Connect(function(p25) -- Line: 255
        -- upvalues: u1 (copy)
        if not p25 then
            return;
        end;

        u1:Unragdoll(p25);
    end);
    Networking.ShovelFX.RagdollRecover.OnClientEvent:Connect(function() -- Line: 263
        -- upvalues: u1 (copy)
        local Character = game.Players.LocalPlayer.Character;

        if Character then
            u1:Unragdoll(Character);
        end;
    end);
end;

return u1;