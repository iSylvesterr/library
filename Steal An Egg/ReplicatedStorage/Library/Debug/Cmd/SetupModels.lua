-- Decompiled with Potassium's decompiler.

local Selection = game:GetService("Selection");
game:GetService("ChangeHistoryService");

for _, v in ipairs(Selection:Get()) do
    if v:IsA("Model") then
        local v1 = v:FindFirstChildOfClass("Humanoid");
        local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart");

        if v1 and HumanoidRootPart then
            local v2, v3 = v:GetBoundingBox();
            local Model = Instance.new("Model");
            Model.Parent = v.Parent;
            v.Parent = Model;

            for _, child in ipairs(v1:GetChildren()) do
                child:Destroy();
            end;

            v1.Parent = Model;
            local v4 = HumanoidRootPart:Clone();

            for _, child in ipairs(v4:GetChildren()) do
                child:Destroy();
            end;

            HumanoidRootPart.Anchored = false;
            v4.Anchored = false;
            v4.Parent = Model;
            local WeldConstraint = Instance.new("WeldConstraint");
            WeldConstraint.Part0 = HumanoidRootPart;
            WeldConstraint.Part1 = v4;
            WeldConstraint.Parent = HumanoidRootPart;
            local AnimationController = Instance.new("AnimationController");
            Instance.new("Animator").Parent = AnimationController;
            AnimationController.Parent = v;
            Model.Name = v.Name;
            v.Name = "Model";
            Model.PrimaryPart = v4;
            local Part = Instance.new("Part");
            Part.Name = "CENTER";
            Part.Size = Vector3.new(0.831, 0.741, 0.002);
            Part.Transparency = 1;
            Part.Anchored = false;
            Part.CanCollide = false;
            Part.CanTouch = false;
            Part.CanQuery = false;
            Part.Parent = Model;
            Part.CFrame = v2 * CFrame.new(0, v3.Y / 2 + 3, 0);
            local WeldConstraint2 = Instance.new("WeldConstraint");
            WeldConstraint2.Part0 = Part;
            WeldConstraint2.Part1 = v4;
            WeldConstraint2.Parent = Part;
        end;
    end;
end;