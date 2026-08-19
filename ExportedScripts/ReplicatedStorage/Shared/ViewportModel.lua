-- Decompiled with Potassium's decompiler.

local u1 = { 0, 1, 2, 3, 4, 5, 6, 7 };
local u2 = { 0, 1, 3, 4, 5, 7 };
local u3 = { 0, 1, 4, 5, 6 };
local u4 = {};
u4.__index = u4;
u4.ClassName = "ViewportModel";

local function getIndices(p5) -- Line: 37
    -- upvalues: u2 (copy), u3 (copy), u1 (copy)
    if p5:IsA("WedgePart") then
        return u2;
    end;

    if p5:IsA("CornerWedgePart") then
        return u3;
    end;

    return u1;
end;

local function getCorners(p6, p7, p8) -- Line: 46
    local v9 = {};

    for i, v in pairs(p8) do
        local v10 = math.floor(v / 4) % 2 * 2 - 1;
        local v11 = math.floor(v / 2) % 2 * 2 - 1;
        v9[i] = p6 * (p7 * Vector3.new(v10, v11, 2 * (v % 2) - 1));
    end;

    return v9;
end;

local function getModelPointCloud(p12) -- Line: 58
    -- upvalues: u2 (copy), u3 (copy), u1 (copy), getCorners (copy)
    local v13 = {};

    for _, descendant in pairs(p12:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local v14;

            if descendant:IsA("WedgePart") then
                v14 = u2;
            elseif descendant:IsA("CornerWedgePart") then
                v14 = u3;
            else
                v14 = u1;
            end;

            local v15 = getCorners(descendant.CFrame, descendant.Size / 2, v14);

            for _, v in pairs(v15) do
                table.insert(v13, v);
            end;
        end;
    end;

    return v13;
end;

local function viewProjectionEdgeHits(p16, p17, p18, p19) -- Line: 72
    local v20 = (-1 / 0);
    local v21 = (1 / 0);

    for _, v in pairs(p16) do
        local v22 = p19 * (p18 - v.Z);
        local v23 = v[p17] + v22;
        local v24 = v[p17] - v22;
        v20 = math.max(v20, v23, v24);
        v21 = math.min(v21, v23, v24);
    end;

    return v20, v21;
end;

function u4.GenerateViewport(p25, p26, p27) -- Line: 91
    -- upvalues: u4 (copy)
    local v28 = p27 or CFrame.Angles(0, 0, 0);
    local v29 = p25:FindFirstChildOfClass("Camera");

    if not v29 then
        v29 = Instance.new("Camera");
        v29.FieldOfView = 70;
        v29.Parent = p25;
        p25.CurrentCamera = v29;
    end;

    p26.Parent = p25;
    local v30 = u4.new(p25, v29);
    v30:SetModel(p26);
    v29.CFrame = v30:GetMinimumFitCFrame(v28);
end;

function u4.CleanViewport(p31) -- Line: 109
    local v32 = p31:FindFirstChildOfClass("Model");

    if v32 then
        v32:Destroy();
    end;
end;

function u4.new(p33, p34) -- Line: 118
    -- upvalues: u4 (copy)
    local v35 = setmetatable({}, u4);
    v35.Model = nil;
    v35.ViewportFrame = p33;
    v35.Camera = p34;
    v35._points = {};
    v35._modelCFrame = CFrame.new();
    v35._modelSize = Vector3.new();
    v35._modelRadius = 0;
    v35._viewport = {};
    v35:Calibrate();

    return v35;
end;

function u4.SetModel(p36, p37) -- Line: 142
    -- upvalues: getModelPointCloud (copy)
    p36.Model = p37;
    local v38, v39 = p37:GetBoundingBox();
    p36._points = getModelPointCloud(p37);
    p36._modelCFrame = v38;
    p36._modelSize = v39;
    p36._modelRadius = v39.Magnitude / 2;
end;

function u4.Calibrate(p40) -- Line: 155
    local v41 = {};
    local AbsoluteSize = p40.ViewportFrame.AbsoluteSize;
    v41.aspect = AbsoluteSize.X / AbsoluteSize.Y;
    v41.yFov2 = math.rad(p40.Camera.FieldOfView / 2);
    v41.tanyFov2 = math.tan(v41.yFov2);
    v41.xFov2 = math.atan(v41.tanyFov2 * v41.aspect);
    v41.tanxFov2 = math.tan(v41.xFov2);
    local v42 = v41.tanyFov2 * math.min(1, v41.aspect);
    v41.cFov2 = math.atan(v42);
    v41.sincFov2 = math.sin(v41.cFov2);
    p40._viewport = v41;
end;

function u4.GetFitDistance(p43, p44) -- Line: 177
    return (p43._modelRadius + (p44 and ((p44 - p43._modelCFrame.Position).Magnitude or 0) or 0)) / p43._viewport.sincFov2;
end;

function u4.GetMinimumFitCFrame(p45, p46) -- Line: 189
    -- upvalues: viewProjectionEdgeHits (copy)
    if not p45.Model then
        return CFrame.new();
    end;

    local v47 = (p46 - p46.Position):Inverse();
    local _points = p45._points;
    local v48 = { v47 * _points[1] };
    local Z = v48[1].Z;

    for i = 2, #_points do
        local v49 = v47 * _points[i];
        Z = math.min(Z, v49.Z);
        v48[i] = v49;
    end;

    local v50, v51 = viewProjectionEdgeHits(v48, "X", Z, p45._viewport.tanxFov2);
    local v52, v53 = viewProjectionEdgeHits(v48, "Y", Z, p45._viewport.tanyFov2);
    local v54 = math.max((v50 - v51) / 2 / p45._viewport.tanxFov2, (v52 - v53) / 2 / p45._viewport.tanyFov2);

    return p46 * CFrame.new((v50 + v51) / 2, (v52 + v53) / 2, Z + v54);
end;

return u4;