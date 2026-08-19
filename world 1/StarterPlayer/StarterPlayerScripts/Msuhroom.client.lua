-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local CollectionService = game:GetService("CollectionService");
local LocalPlayer = Players.LocalPlayer;

local function RegisterCap(u1) -- Line: 8
    -- upvalues: LocalPlayer (copy)
    local u2 = 0;
    u1.Touched:Connect(function(p3) -- Line: 12
        -- upvalues: u2 (ref), LocalPlayer (ref), u1 (copy)
        local v4 = os.clock();

        if v4 - u2 < 0.25 then
            return;
        end;

        local Character = LocalPlayer.Character;

        if not Character then
            return;
        end;

        if not p3:IsDescendantOf(Character) then
            return;
        end;

        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local v5 = Character:FindFirstChildOfClass("Humanoid");

        if not v5 then
            return;
        end;

        if HumanoidRootPart.Position.Y - v5.HipHeight < u1.Position.Y + u1.Size.Y / 2 - 1 then
            return;
        end;

        u2 = v4;
        HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X * 0.2, 120, HumanoidRootPart.AssemblyLinearVelocity.Z * 0.2);
    end);
end;

for _, v in CollectionService:GetTagged("MushroomCap") do
    if v:IsA("BasePart") then
        local u6 = 0;
        v.Touched:Connect(function(p7) -- Line: 12
            -- upvalues: u6 (ref), LocalPlayer (copy), v (copy)
            local v8 = os.clock();

            if v8 - u6 < 0.25 then
                return;
            end;

            local Character = LocalPlayer.Character;

            if not Character then
                return;
            end;

            if not p7:IsDescendantOf(Character) then
                return;
            end;

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

            if not HumanoidRootPart then
                return;
            end;

            local v9 = Character:FindFirstChildOfClass("Humanoid");

            if not v9 then
                return;
            end;

            if HumanoidRootPart.Position.Y - v9.HipHeight < v.Position.Y + v.Size.Y / 2 - 1 then
                return;
            end;

            u6 = v8;
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X * 0.2, 120, HumanoidRootPart.AssemblyLinearVelocity.Z * 0.2);
        end);
    end;
end;

CollectionService:GetInstanceAddedSignal("MushroomCap"):Connect(function(u10) -- Line: 46
    -- upvalues: LocalPlayer (copy)
    if u10:IsA("BasePart") then
        local u11 = 0;
        u10.Touched:Connect(function(p12) -- Line: 12
            -- upvalues: u11 (ref), LocalPlayer (ref), u10 (copy)
            local v13 = os.clock();

            if v13 - u11 < 0.25 then
                return;
            end;

            local Character = LocalPlayer.Character;

            if not Character then
                return;
            end;

            if not p12:IsDescendantOf(Character) then
                return;
            end;

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

            if not HumanoidRootPart then
                return;
            end;

            local v14 = Character:FindFirstChildOfClass("Humanoid");

            if not v14 then
                return;
            end;

            if HumanoidRootPart.Position.Y - v14.HipHeight < u10.Position.Y + u10.Size.Y / 2 - 1 then
                return;
            end;

            u11 = v13;
            HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(HumanoidRootPart.AssemblyLinearVelocity.X * 0.2, 120, HumanoidRootPart.AssemblyLinearVelocity.Z * 0.2);
        end);
    end;
end);