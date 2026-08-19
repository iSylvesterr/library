-- Decompiled with Potassium's decompiler.

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"));
local ReplicatedStorage = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").ReplicatedStorage;
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "constants", "items", "Items");
local itemScaleForWeight = v1.itemScaleForWeight;
local Items = v1.Items;
local MAX_ITEM_SPAN = v1.MAX_ITEM_SPAN;
local u2 = {};
local v3 = {};

local function structuralChildren(p4) -- Line: 15
    local function _(p5) -- Line: 19
        return p5:IsA("BasePart") or (p5:IsA("Model") or p5:IsA("Folder"));
    end;

    local v6 = 0;
    local v7 = {};

    for i, child in p4:GetChildren() do
        local _ = i - 1;

        if (child:IsA("BasePart") or (child:IsA("Model") or child:IsA("Folder"))) == true then
            v6 = v6 + 1;
            v7[v6] = child;
        end;
    end;

    return v7;
end;

local function toModel(p8, p9) -- Line: 32
    local v10 = p9 == nil and 1 or p9;
    local v11 = p8:Clone();
    local Handle = v11:FindFirstChild("Handle");

    if Handle ~= nil then
        Handle = Handle:IsA("BasePart");
    end;

    if not Handle then
        v11:Destroy();

        return nil;
    end;

    local Model = Instance.new("Model");

    for _, child in v11:GetChildren() do
        child.Parent = Model;
    end;

    v11:Destroy();

    for _, descendant in Model:GetDescendants() do
        if descendant.Name == "ItemOverhead" then
            descendant:Destroy();
        end;
    end;

    Model.PrimaryPart = Model:FindFirstChild("Handle");

    if math.abs(v10 - 1) > 0.001 then
        Model:ScaleTo(v10);
    end;

    return Model;
end;

v3.toModel = toModel;

local function baseSpanOf(p12) -- Line: 63
    -- upvalues: u2 (copy), ReplicatedStorage (copy), Items (copy), toModel (copy)
    local v13 = u2[p12];

    if v13 ~= nil then
        return v13;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets ~= nil then
        Assets = Assets:FindFirstChild("Items");

        if Assets ~= nil then
            Assets = Assets:FindFirstChild(Items[p12].displayName);
        end;
    end;

    local v14;

    if Assets == nil then
        v14 = Assets;
    else
        v14 = Assets:IsA("Tool");
    end;

    local v15;

    if v14 then
        v15 = toModel(Assets);
    else
        v15 = nil;
    end;

    local v16;

    if v15 then
        local _, v17 = v15:GetBoundingBox();
        v15:Destroy();
        v16 = math.max(v17.X, v17.Y, v17.Z);
    else
        v16 = 0;
    end;

    u2[p12] = v16;

    return v16;
end;

function v3.scaleFor(p18, p19) -- Line: 93
    -- upvalues: itemScaleForWeight (copy), baseSpanOf (copy), MAX_ITEM_SPAN (copy)
    local v20 = itemScaleForWeight(p18, p19);
    local v21 = baseSpanOf(p18);

    if v21 > 0 then
        return math.min(v20, MAX_ITEM_SPAN / v21);
    end;

    return v20;
end;

function v3.build(p22, p23, p24) -- Line: 99
    -- upvalues: Items (copy), toModel (copy), itemScaleForWeight (copy), baseSpanOf (copy), MAX_ITEM_SPAN (copy)
    if p24 == nil then
        p24 = Items[p23].averageKg;
    end;

    local v25 = itemScaleForWeight(p23, p24);
    local v26 = baseSpanOf(p23);

    if v26 > 0 then
        v25 = math.min(v25, MAX_ITEM_SPAN / v26);
    end;

    return toModel(p22, v25);
end;

function v3.applyDisplayRotation(p27, p28) -- Line: 106
    -- upvalues: Items (copy)
    local PrimaryPart = p27.PrimaryPart;

    if not PrimaryPart then
        return nil;
    end;

    local v29 = Items[p28].displayRotation or { 0, 0, 0 };
    local v30 = v29[2];
    local v31 = v29[3];
    PrimaryPart.PivotOffset = CFrame.Angles(math.rad(v29[1]), math.rad(v30), (math.rad(v31))):Inverse();
end;

function v3.applyOverheadGrip(p32, p33) -- Line: 118
    -- upvalues: Items (copy)
    if Items[p33].holdOverhead ~= true then
        return nil;
    end;

    local Handle = p32:FindFirstChild("Handle");
    local v34;

    if Handle == nil then
        v34 = Handle;
    else
        v34 = Handle:IsA("BasePart");
    end;

    if not v34 then
        return nil;
    end;

    local CFrame2 = Handle.CFrame;
    local v35 = nil;
    local v36 = nil;

    for _, descendant in p32:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v37 = CFrame2:ToObjectSpace(descendant.CFrame);
            local v38 = descendant.Size / 2;
            local v39 = math.abs(v37.XVector.X) * v38.X + math.abs(v37.YVector.X) * v38.Y + math.abs(v37.ZVector.X) * v38.Z;
            local v40 = math.abs(v37.XVector.Y) * v38.X + math.abs(v37.YVector.Y) * v38.Y + math.abs(v37.ZVector.Y) * v38.Z;
            local v41 = math.abs(v37.XVector.Z) * v38.X + math.abs(v37.YVector.Z) * v38.Y + math.abs(v37.ZVector.Z) * v38.Z;
            local v42 = Vector3.new(v39, v40, v41);
            local v43 = v37.Position - v42;
            local v44 = v37.Position + v42;

            if v35 then
                local v45 = math.min(v35.X, v43.X);
                local v46 = math.min(v35.Y, v43.Y);
                local v47 = math.min(v35.Z, v43.Z);
                v35 = Vector3.new(v45, v46, v47);
            else
                v35 = v43;
            end;

            if v36 then
                local v48 = math.max(v36.X, v44.X);
                local v49 = math.max(v36.Y, v44.Y);
                local v50 = math.max(v36.Z, v44.Z);
                v36 = Vector3.new(v48, v49, v50);
            else
                v36 = v44;
            end;
        end;
    end;

    if not (v35 and v36) then
        return nil;
    end;

    local v51 = v36 - v35;
    local v52;

    if v51.X >= v51.Y and v51.X >= v51.Z then
        v52 = CFrame.new();
    elseif v51.Y >= v51.Z then
        v52 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(0, -1, 0), Vector3.new(1, 0, 0), Vector3.new(0, 0, 1));
    else
        v52 = CFrame.fromMatrix(Vector3.new(0, 0, 0), Vector3.new(0, 0, -1), Vector3.new(0, 1, 0), Vector3.new(1, 0, 0));
    end;

    local v53 = v52:VectorToObjectSpace(Vector3.new(0, -1, 0));
    local v54 = (v35 + v36) / 2 + v53 * ((math.abs(v53.X) * v51.X + math.abs(v53.Y) * v51.Y + math.abs(v53.Z) * v51.Z) / 2);
    local v55 = CFrame.new(v54);
    local v56 = v52:Inverse();
    local v57 = CFrame.Angles(1.2740903539558606, 0, 0);
    p32.Grip = v55 * v56 * v57;
end;

function v3.scaleTool(p58, p59) -- Line: 165
    -- upvalues: structuralChildren (copy)
    if math.abs(p59 - 1) < 0.001 then
        return nil;
    end;

    local Handle = p58:FindFirstChild("Handle");
    local v60;

    if Handle == nil then
        v60 = Handle;
    else
        v60 = Handle:IsA("BasePart");
    end;

    if not v60 then
        return nil;
    end;

    local Model = Instance.new("Model");
    local v61 = structuralChildren(p58);

    for _, v in v61 do
        v.Parent = Model;
    end;

    Model.PrimaryPart = Handle;
    Model:ScaleTo(p59);

    for _, v in v61 do
        v.Parent = p58;
    end;

    Model:Destroy();
    p58.Grip = CFrame.new(p58.Grip.Position * p59) * (p58.Grip - p58.Grip.Position);
end;

return {
    ItemModel = v3
};