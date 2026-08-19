-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {
    Neck = { CFrame.new(0, 1, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1), CFrame.new(0, -0.5, 0, 0, -1, 0, 1, 0, -0, 0, 0, 1) },
    ["Left Shoulder"] = { CFrame.new(-1.3, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1), CFrame.new(0.2, 0.75, 0, -1, 0, 0, 0, -1, 0, 0, 0, 1) },
    ["Right Shoulder"] = { CFrame.new(1.3, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), CFrame.new(-0.2, 0.75, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1) },
    ["Left Hip"] = { CFrame.new(-0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1) },
    ["Right Hip"] = { CFrame.new(0.5, -1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1), CFrame.new(0, 1, 0, 0, 1, -0, -1, 0, 0, 0, 0, 1) }
};
local u3 = {
    Torso = Vector3.new(2, 2, 1),
    Head = Vector3.new(2, 1, 1),
    ["Left Arm"] = Vector3.new(1, 2, 1),
    ["Right Arm"] = Vector3.new(1, 2, 1),
    ["Left Leg"] = Vector3.new(1, 2, 1),
    ["Right Leg"] = Vector3.new(1, 2, 1)
};
local u4 = { "RagdollAttachment", "RagdollConstraint", "ColliderPart" };

local function _(p5) -- Line: 21
    -- upvalues: u3 (copy)
    local v6 = u3[p5.Name];

    return not v6 and Vector3.new(1, 1, 1) or p5.Size / v6;
end;

local function _(p7, p8) -- Line: 28
    local v9, v10, v11, v12, v13, v14, v15, v16, v17, v18, v19, v20 = p7:GetComponents();

    return CFrame.new(v9 * p8.X, v10 * p8.Y, v11 * p8.Z, v12, v13, v14, v15, v16, v17, v18, v19, v20);
end;

function v1.setupCharacter(p21) -- Line: 32
    local Humanoid = p21:FindFirstChild("Humanoid");

    if not Humanoid then
        return nil;
    end;

    Humanoid.BreakJointsOnDeath = false;
    Humanoid.RequiresNeck = false;
end;

local function _(p22) -- Line: 41
    if not p22 then
        return nil;
    end;

    local Part = Instance.new("Part");
    Part.Name = "ColliderPart";
    Part.Size = p22.Size / 1.7;
    Part.Massless = true;
    Part.CFrame = p22.CFrame;
    Part.Transparency = 1;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Part0 = Part;
    WeldConstraint.Part1 = p22;
    WeldConstraint.Parent = Part;
    Part.Parent = p22;
end;

local function u53(p23) -- Line: 57
    -- upvalues: u2 (copy), u3 (copy)
    for _, descendant in p23:GetDescendants() do
        if descendant:IsA("Motor6D") then
            local v24 = u2[descendant.Name];

            if v24 then
                descendant.Enabled = false;
                local Part0 = descendant.Part0;
                local v25 = u3[Part0.Name];
                local v26 = not v25 and Vector3.new(1, 1, 1) or Part0.Size / v25;
                local Part1 = descendant.Part1;
                local v27 = u3[Part1.Name];
                local v28 = not v27 and Vector3.new(1, 1, 1) or Part1.Size / v27;
                local Attachment = Instance.new("Attachment");
                local Attachment2 = Instance.new("Attachment");
                local v29, v30, v31, v32, v33, v34, v35, v36, v37, v38, v39, v40 = v24[1]:GetComponents();
                Attachment.CFrame = CFrame.new(v29 * v26.X, v30 * v26.Y, v31 * v26.Z, v32, v33, v34, v35, v36, v37, v38, v39, v40);
                local v41, v42, v43, v44, v45, v46, v47, v48, v49, v50, v51, v52 = v24[2]:GetComponents();
                Attachment2.CFrame = CFrame.new(v41 * v28.X, v42 * v28.Y, v43 * v28.Z, v44, v45, v46, v47, v48, v49, v50, v51, v52);
                Attachment.Name = "RagdollAttachment";
                Attachment2.Name = "RagdollAttachment";
                local Part12 = descendant.Part1;

                if Part12 then
                    local Part = Instance.new("Part");
                    Part.Name = "ColliderPart";
                    Part.Size = Part12.Size / 1.7;
                    Part.Massless = true;
                    Part.CFrame = Part12.CFrame;
                    Part.Transparency = 1;
                    local WeldConstraint = Instance.new("WeldConstraint");
                    WeldConstraint.Part0 = Part;
                    WeldConstraint.Part1 = Part12;
                    WeldConstraint.Parent = Part;
                    Part.Parent = Part12;
                end;

                local BallSocketConstraint = Instance.new("BallSocketConstraint");
                BallSocketConstraint.Attachment0 = Attachment;
                BallSocketConstraint.Attachment1 = Attachment2;
                BallSocketConstraint.Name = "RagdollConstraint";
                BallSocketConstraint.Radius = 0.15 * ((v26.X + v26.Y + v26.Z) / 3);
                BallSocketConstraint.LimitsEnabled = true;
                BallSocketConstraint.TwistLimitsEnabled = false;
                BallSocketConstraint.MaxFrictionTorque = 0;
                BallSocketConstraint.Restitution = 0;
                BallSocketConstraint.UpperAngle = 90;
                BallSocketConstraint.TwistLowerAngle = -45;
                BallSocketConstraint.TwistUpperAngle = 45;

                if descendant.Name == "Neck" then
                    BallSocketConstraint.TwistLimitsEnabled = true;
                    BallSocketConstraint.UpperAngle = 45;
                    BallSocketConstraint.TwistLowerAngle = -70;
                    BallSocketConstraint.TwistUpperAngle = 70;
                end;

                Attachment.Parent = descendant.Part0;
                Attachment2.Parent = descendant.Part1;
                BallSocketConstraint.Parent = descendant.Parent;
            end;
        end;
    end;

    local Humanoid = p23:FindFirstChild("Humanoid");

    if Humanoid then
        Humanoid.AutoRotate = false;
        Humanoid.PlatformStand = true;
    end;
end;

local function u55(p54) -- Line: 106
    -- upvalues: u4 (copy)
    for _, descendant in p54:GetDescendants() do
        if table.find(u4, descendant.Name) ~= nil then
            descendant:Destroy();
        end;

        if descendant:IsA("Motor6D") then
            descendant.Enabled = true;
        end;
    end;
end;

local function u57(p56) -- Line: 117
    -- upvalues: u4 (copy)
    local Humanoid = p56:FindFirstChild("Humanoid");

    for _, descendant in p56:GetDescendants() do
        if table.find(u4, descendant.Name) ~= nil then
            descendant:Destroy();
        end;

        if descendant:IsA("Motor6D") then
            descendant.Enabled = true;
        end;
    end;

    if Humanoid then
        Humanoid.AutoRotate = true;
        Humanoid.PlatformStand = false;
        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
    end;
end;

function v1.setRagdollEnabled(p58, p59) -- Line: 134
    -- upvalues: u55 (copy), u53 (copy), u57 (copy)
    local Humanoid = p58:FindFirstChild("Humanoid");

    if not Humanoid then
        return nil;
    end;

    if not p59 then
        u57(p58);
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true);
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false);
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false);

        return;
    end;

    u55(p58);
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true);
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true);
    Humanoid:ChangeState(Enum.HumanoidStateType.Ragdoll);
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, false);
    u53(p58);
end;

return {
    R6Ragdoll = v1
};