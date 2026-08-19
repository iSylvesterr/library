-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = CFrame.Angles(-1.5707963267948966, 0, 0);
local u2 = {
    ["Right Arm"] = "RightGlove",
    ["Left Arm"] = "LeftGlove"
};
local u3 = {
    ["Right Arm"] = "RightHand",
    ["Left Arm"] = "LeftHand"
};

local function applyGloveConfig(p4, p5, p6, p7, p8) -- Line: 33
    -- upvalues: u1 (copy)
    if p6 then
        p6 = p6:FindFirstChild("Character");
    end;

    if p7 then
        p7 = p7:FindFirstChild("Character");
    end;

    if p8 then
        p8 = p8:FindFirstChild("Character");
    end;

    local v9 = p6 and p6.Value or Vector3.new(1, 1, 1);
    local v10 = p7 and p7.Value or Vector3.new(0, 0, -0.025);
    local v11 = p8 and p8.Value or Vector3.new(0, 0, 0);
    local v12 = math.rad(v11.X);
    local v13 = math.rad(v11.Y);
    local v14 = math.rad(v11.Z);
    local v15 = Vector3.new(v12, v13, v14);
    local v16 = u1 * CFrame.Angles(v15.X, v15.Y, v15.Z);
    p4.Size = v9;
    p5.C0 = CFrame.new(v10);
    p5.C1 = p4.PivotOffset * v16;
end;

return function(p17, p18, p19, p20) -- Line: 50
    -- upvalues: u3 (copy), u2 (copy), applyGloveConfig (copy), RunService (copy)
    local v21 = {};

    for _, v in ipairs(p17) do
        if v:IsA("BasePart") then
            local v22 = u3[v.Name];

            if v22 then
                local v23 = p18:FindFirstChild(v22);

                if v23 then
                    local u24 = v:Clone();
                    u24.Name = u2[v.Name];
                    u24.CastShadow = false;
                    u24.CanCollide = false;
                    u24.CanTouch = false;
                    u24.Anchored = false;
                    u24.CanQuery = false;

                    if p20 and p20.collisionGroup then
                        u24.CollisionGroup = p20.collisionGroup;
                    end;

                    local Rotations = u24:FindFirstChild("Rotations");
                    local Offsets = u24:FindFirstChild("Offsets");
                    local Scales = u24:FindFirstChild("Scales");
                    local Motor6D = Instance.new("Motor6D");
                    Motor6D.Name = "GloveAttachment";
                    Motor6D.Part0 = v23;
                    Motor6D.Part1 = u24;
                    Motor6D.Parent = u24;
                    u24.Parent = p19;
                    applyGloveConfig(u24, Motor6D, Scales, Offsets, Rotations);

                    if RunService:IsStudio() then
                        local v25 = ipairs;
                        local v26 = {};
                        local v27;

                        if Scales then
                            v27 = Scales:FindFirstChild("Character");
                        else
                            v27 = Scales;
                        end;

                        local v28;

                        if Offsets then
                            v28 = Offsets:FindFirstChild("Character");
                        else
                            v28 = Offsets;
                        end;

                        local v29;

                        if Rotations then
                            v29 = Rotations:FindFirstChild("Character");
                        else
                            v29 = Rotations;
                        end;

                        v26[1], v26[2], v26[3] = v27, v28, v29;

                        for _, v2 in v25(v26) do
                            if v2 then
                                v2:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 106
                                    -- upvalues: applyGloveConfig (ref), u24 (copy), Motor6D (copy), Scales (copy), Offsets (copy), Rotations (copy)
                                    applyGloveConfig(u24, Motor6D, Scales, Offsets, Rotations);
                                end);
                            end;
                        end;
                    else
                        local v30 = ipairs;
                        local v31 = {};

                        if Scales then
                            Scales = Scales:FindFirstChild("Character");
                        end;

                        if Offsets then
                            Offsets = Offsets:FindFirstChild("Character");
                        end;

                        if Rotations then
                            Rotations = Rotations:FindFirstChild("Character");
                        end;

                        v31[1], v31[2], v31[3] = Scales, Offsets, Rotations;

                        for _, v2 in v30(v31) do
                            if v2 then
                                v2:Destroy();
                            end;
                        end;
                    end;

                    table.insert(v21, u24);
                end;
            end;
        end;
    end;

    return v21;
end;