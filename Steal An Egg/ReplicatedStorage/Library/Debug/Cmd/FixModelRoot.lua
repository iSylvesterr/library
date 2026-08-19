-- Decompiled with Potassium's decompiler.

local Selection = game:GetService("Selection");
game:GetService("ChangeHistoryService");

for _, v in ipairs(Selection:Get()) do
    if v:IsA("Model") then
        local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart then
            local v1 = v:FindFirstChildWhichIsA("Humanoid");

            if v1 then
                v1.Parent = nil;
            end;

            HumanoidRootPart.Name = "RootPart";
            local _, v2 = v:GetBoundingBox();
            HumanoidRootPart.Position = HumanoidRootPart.Position - Vector3.new(0, v2.Y / 2, 0);
        end;
    end;
end;