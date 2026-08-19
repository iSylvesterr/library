-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Parent = script.Parent;
local Humanoid = Parent:WaitForChild("Humanoid");
Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);
Humanoid.AutoJumpEnabled = false;
local HumanoidRootPart = Parent:WaitForChild("HumanoidRootPart");
local u3 = RunService.PostSimulation:Connect(function(p1) -- Line: 15, Name: onPostSimulation
    -- upvalues: Humanoid (copy), HumanoidRootPart (copy)
    local v2 = Humanoid:GetState();

    if (v2 == Enum.HumanoidStateType.Running or v2 == Enum.HumanoidStateType.RunningNoPhysics) and (Humanoid.WalkSpeed >= 50 and HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 10) then
        HumanoidRootPart.AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity + Vector3.new(0, -50 * p1, 0);
    end;
end);
Humanoid.Died:Connect(function() -- Line: 24
    -- upvalues: u3 (copy)
    u3:Disconnect();
end);