-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local u1 = CFrame.Angles(0, 0, 3.141592653589793);
local v2 = {};

local function requiredWeld(p3, p4) -- Line: 27
    local v5 = p3:FindFirstChild(p4);
    local v6 = `{p3:GetFullName()} must contain {p4}`;
    local v7 = assert(v5, v6);
    local v8 = v7:IsA("WeldConstraint");
    local v9 = `{v7:GetFullName()} must be a WeldConstraint`;
    assert(v8, v9);

    return v7;
end;

local function captureAndDisableWelds(p10) -- Line: 33
    local v11 = {};

    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("WeldConstraint") then
            v11[descendant] = descendant.Enabled;
            descendant.Enabled = false;
        end;
    end;

    return v11;
end;

local function restoreWelds(p12) -- Line: 44
    for i, v in p12 do
        i.Enabled = v;
    end;
end;

local function assertFrameUnchanged(p13, p14, p15) -- Line: 50
    local v16 = (p13.Position - p14.Position).Magnitude <= 0.00001;
    local v17 = p13.XVector:Dot(p14.XVector) >= 0.99999;
    local v18 = p13.YVector:Dot(p14.YVector) >= 0.99999;
    local v19 = p13.ZVector:Dot(p14.ZVector) >= 0.99999;

    if v16 then
        if v17 then
            if not v18 then
                v19 = v18;
            end;
        else
            v19 = v17;
        end;
    else
        v19 = v16;
    end;

    local v20 = `{p15} world CFrame changed during inversion`;
    assert(v19, v20);
end;

function v2.Apply(p21) -- Line: 62
    -- upvalues: Asserts (copy), requiredWeld (copy), BBFromModelVisibleOnly (copy), captureAndDisableWelds (copy), u1 (copy), assertFrameUnchanged (copy)
    Asserts.Model(p21);
    local HumanoidRootPart = p21:FindFirstChild("HumanoidRootPart");
    local v22 = `{p21.Name} must contain HumanoidRootPart`;
    local v23 = assert(HumanoidRootPart, v22);
    local v24 = v23:IsA("BasePart");
    local v25 = `{p21.Name}.HumanoidRootPart must be a BasePart`;
    assert(v24, v25);
    local CENTER = p21:FindFirstChild("CENTER");
    local v26 = `{p21.Name} must contain CENTER`;
    local v27 = assert(CENTER, v26);
    local v28 = v27:IsA("BasePart");
    local v29 = `{p21.Name}.CENTER must be a BasePart`;
    assert(v28, v29);
    local Model = p21:FindFirstChild("Model");
    local v30 = `{p21.Name} must contain visual Model`;
    local v31 = assert(Model, v30);
    local v32 = v31:IsA("Model");
    local v33 = `{p21.Name}.Model must be a Model`;
    assert(v32, v33);
    local v34 = requiredWeld(v23, "AssetWeld");
    local v35 = requiredWeld(v27, "CenterWeld");
    local CFrame2 = v23.CFrame;
    local CFrame3 = v27.CFrame;
    local v36 = BBFromModelVisibleOnly(p21);
    local v37 = v36:ToObjectSpace(v31:GetPivot());
    local v38 = captureAndDisableWelds(p21);
    assert(v38[v34] ~= nil, "Root AssetWeld must be disabled before inversion");
    assert(v38[v35] ~= nil, "CENTER CenterWeld must be disabled before inversion");
    v31:PivotTo(v36 * u1 * v37);
    v23.Name = "InvertedModelOriginalRoot";
    local Part = Instance.new("Part");
    Part.Name = "HumanoidRootPart";
    Part.Size = v23.Size;
    Part.CFrame = CFrame2;
    Part.PivotOffset = v23.PivotOffset;
    Part.Transparency = 1;
    Part.CastShadow = false;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Massless = true;
    Part.RootPriority = v23.RootPriority;
    Part.CollisionGroup = v23.CollisionGroup;
    Part.Parent = p21;
    v23.Anchored = false;
    local WeldConstraint = Instance.new("WeldConstraint");
    WeldConstraint.Name = "InvertedModelRootWeld";
    WeldConstraint.Part0 = Part;
    WeldConstraint.Part1 = v23;
    WeldConstraint.Parent = Part;
    p21.PrimaryPart = Part;

    for i, v in v38 do
        i.Enabled = v;
    end;

    assertFrameUnchanged(Part.CFrame, CFrame2, "Proxy HumanoidRootPart");
    assertFrameUnchanged(v27.CFrame, CFrame3, "CENTER");
end;

return v2;