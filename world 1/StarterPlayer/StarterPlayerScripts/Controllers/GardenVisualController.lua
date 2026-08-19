-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 2
};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Gardens = workspace:WaitForChild("Gardens");
local PlotAssets = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("PlotAssets");
local TopLayer = workspace:WaitForChild("Baseplate").TopLayer;
local u2 = nil;
local u3 = nil;
local u4 = {};
local u5 = {};
local u6 = {};

local function getModelSize(p7) -- Line: 30
    local BottomFace = p7:FindFirstChild("BottomFace", true);

    return BottomFace and (BottomFace:IsA("BasePart") and BottomFace.Size) or p7:GetExtentsSize();
end;

local function initSizes() -- Line: 35
    -- upvalues: u2 (ref), PlotAssets (copy), u3 (ref)
    if u2 then
        return;
    end;

    local BedSection = PlotAssets.BedSection;
    local BottomFace = BedSection:FindFirstChild("BottomFace", true);
    u2 = BottomFace and (BottomFace:IsA("BasePart") and BottomFace.Size) or BedSection:GetExtentsSize();
    local FRONT_BedSection = PlotAssets.FRONT_BedSection;
    local BottomFace2 = FRONT_BedSection:FindFirstChild("BottomFace", true);
    u3 = BottomFace2 and (BottomFace2:IsA("BasePart") and BottomFace2.Size) or FRONT_BedSection:GetExtentsSize();
end;

local function alignModel(p8, p9) -- Line: 41
    local BottomFace = p8:FindFirstChild("BottomFace", true);

    if BottomFace and BottomFace:IsA("BasePart") then
        local Y = (BottomFace.CFrame * CFrame.new(0, -BottomFace.Size.Y * 0.5, 0)).Position.Y;

        if math.abs(p9 - Y) > 0.0001 then
            p8:TranslateBy((Vector3.new(0, p9 - Y, 0)));
        end;
    end;
end;

local function getFenceThemeAssets(p10) -- Line: 51
    -- upvalues: PlotAssets (copy)
    local FenceThemes = PlotAssets:FindFirstChild("FenceThemes");
    local v11;

    if FenceThemes then
        v11 = FenceThemes:FindFirstChild("Default");
    else
        v11 = FenceThemes;
    end;

    local v12 = (typeof(p10) ~= "string" or (p10 == "" or not p10)) and "Default" or p10;

    if FenceThemes then
        FenceThemes = FenceThemes:FindFirstChild(v12);
    end;

    if not FenceThemes then
        FenceThemes = v11;
        v12 = "Default";
    end;

    if not FenceThemes then
        return nil, nil, "Default";
    end;

    local FencePole = FenceThemes:FindFirstChild("FencePole");
    local FenceConnectors = FenceThemes:FindFirstChild("FenceConnectors");

    if v11 then
        FencePole = FencePole or v11:FindFirstChild("FencePole");
        FenceConnectors = FenceConnectors or v11:FindFirstChild("FenceConnectors");
    end;

    return FencePole, FenceConnectors, v12;
end;

local function updatePlotVisual(p13, u14, p15) -- Line: 75
    -- upvalues: u2 (ref), PlotAssets (copy), u3 (ref), u4 (copy), getFenceThemeAssets (copy), TopLayer (copy), alignModel (copy)
    if not u2 then
        local BedSection = PlotAssets.BedSection;
        local BottomFace = BedSection:FindFirstChild("BottomFace", true);
        u2 = BottomFace and (BottomFace:IsA("BasePart") and BottomFace.Size) or BedSection:GetExtentsSize();
        local FRONT_BedSection = PlotAssets.FRONT_BedSection;
        local BottomFace2 = FRONT_BedSection:FindFirstChild("BottomFace", true);
        u3 = BottomFace2 and (BottomFace2:IsA("BasePart") and BottomFace2.Size) or FRONT_BedSection:GetExtentsSize();
    end;

    local u16 = u4[u14];

    if not u16 then
        u16 = {
            fenceSkin = "Default",
            poles = {},
            connectors = {},
            beds = {}
        };
        u4[u14] = u16;
    end;

    local u17, u18, v19 = getFenceThemeAssets(p15);

    if not (u17 and u18) then
        return;
    end;

    if u16.fenceSkin ~= v19 then
        for _, v in u16.poles do
            v:Destroy();
        end;

        for _, v in u16.connectors do
            v:Destroy();
        end;

        u16.poles = {};
        u16.connectors = {};
        u16.fenceSkin = v19;
    end;

    local BottomFace = u17:FindFirstChild("BottomFace", true);
    local u20 = BottomFace and (BottomFace:IsA("BasePart") and BottomFace.Size) or u17:GetExtentsSize();
    local BottomFace2 = u18:FindFirstChild("BottomFace", true);
    local u21 = BottomFace2 and (BottomFace2:IsA("BasePart") and BottomFace2.Size) or u18:GetExtentsSize();
    local u22 = u20.X + u21.X;
    local v23 = math.ceil(18 / u22);
    local u24 = TopLayer.Position.Y + TopLayer.Size.X * 0.5;
    local v25 = math.floor((p13.Size.Z - u3.X) / (u2.X + 0)) + 1;
    local v26 = math.max(1, v25);
    local v27 = u3.X + (v26 - 1) * (u2.X + 0);

    local function centerCount(p28, p29) -- Line: 110
        if p29 <= 0 then
            return math.max(p28, 1);
        end;

        local v30 = math.max(p28, p29 + 2);

        if (v30 - p29) % 2 ~= 0 then
            v30 = v30 + 1 or v30;
        end;

        return v30;
    end;

    local v31 = math.ceil((2 * u2.Z + 11 + 5) / u22);
    local v32;

    if v23 > 0 then
        v32 = math.max(v31, v23 + 2);

        if (v32 - v23) % 2 ~= 0 then
            v32 = v32 + 1 or v32;
        end;
    else
        v32 = math.max(v31, 1);
    end;

    local v33 = math.ceil((v27 + 4) / u22);
    local v34 = math.max(1, v33);
    local v35 = v32 * u22 * 0.5;
    local v36 = v34 * u22 * 0.5;
    local v37 = p13.Size.Z * 0.5 - v36;
    local u38 = 1;
    local u39 = 1;
    local u40 = {};
    local u41 = {};

    local function placeLine(p42, p43, p44, p45, p46) -- Line: 132
        -- upvalues: u16 (ref), u38 (ref), u17 (copy), u14 (copy), u40 (copy), u22 (copy), alignModel (ref), u24 (copy), u39 (ref), u18 (copy), u41 (copy), u20 (copy), u21 (copy)
        local v47 = p45 and (math.floor((p44 - p46) / 2 + 1e-6) or -1) or -1;
        local v48 = p45 and (v47 + p46 - 1 or -1) or -1;

        for i = 0, p44 do
            if not p45 or (v47 + 1 > i or i > v48) then
                local v49 = u16.poles[u38] or u17:Clone();

                if not u16.poles[u38] then
                    v49.Parent = u14;
                end;

                u40[u38] = v49;
                v49:PivotTo(CFrame.lookAt(p42 + p43 * (i * u22), p42 + p43 * (i * u22) + p43) * CFrame.Angles(0, 1.5707963267948966, 0));
                alignModel(v49, u24);
                u38 = u38 + 1;
            end;
        end;

        for i = 0, p44 - 1 do
            if not p45 or (v47 > i or i > v48) then
                local v50 = u16.connectors[u39] or u18:Clone();

                if not u16.connectors[u39] then
                    v50.Parent = u14;
                end;

                u41[u39] = v50;
                local v51 = p42 + p43 * (i * u22 + u20.X * 0.5 + u21.X * 0.5);
                v50:PivotTo(CFrame.lookAt(v51, v51 + p43) * CFrame.Angles(0, 1.5707963267948966, 0));
                alignModel(v50, u24);
                u39 = u39 + 1;
            end;
        end;
    end;

    local CFrame2 = p13.CFrame;
    placeLine(CFrame2:PointToWorldSpace((Vector3.new(-v35, 0, -v36 + v37))), CFrame2:VectorToWorldSpace(Vector3.new(1, 0, 0)), v32, false, 0);
    placeLine(CFrame2:PointToWorldSpace((Vector3.new(v35, 0, -v36 + v37))), CFrame2:VectorToWorldSpace(Vector3.new(0, 0, 1)), v34, false, 0);
    placeLine(CFrame2:PointToWorldSpace((Vector3.new(v35, 0, v36 + v37))), CFrame2:VectorToWorldSpace(Vector3.new(-1, 0, 0)), v32, true, v23);
    placeLine(CFrame2:PointToWorldSpace((Vector3.new(-v35, 0, v36 + v37))), CFrame2:VectorToWorldSpace(Vector3.new(0, 0, -1)), v34, false, 0);

    for i = u38, #u16.poles do
        u16.poles[i]:Destroy();
    end;

    for i = u39, #u16.connectors do
        u16.connectors[i]:Destroy();
    end;

    u16.poles = u40;
    u16.connectors = u41;
    local v52 = -(u2.Z * 0.5 + 5.5);
    local v53 = u2.Z * 0.5 + 5.5;
    local v54 = p13.Size.Z * 0.5 - 2 - u3.X * 0.5;
    local v55 = -v27 * 0.5 + u2.X * 0.5 + (v54 - (-v27 * 0.5 + (v26 - 1) * (u2.X + 0) + u3.X * 0.5));
    local v56 = 1;
    local v57 = {};

    for i = 1, 2 do
        local v58 = i == 1 and v52 and v52 or v53;

        for i2 = 1, v26 do
            local v59 = i2 == v26;
            local v60 = v59 and PlotAssets.FRONT_BedSection or PlotAssets.BedSection;
            local v61 = u16.beds[v56];

            if v61 and v61.Name ~= v60.Name then
                v61:Destroy();
                v61 = nil;
            end;

            if not v61 then
                v61 = v60:Clone();
                v61.Parent = u14;
            end;

            v57[v56] = v61;
            v61:PivotTo(CFrame2 * CFrame.new(v58, u24 - p13.Position.Y + (v59 and u3 or u2).Y * 0.5, v59 and v54 and v54 or v55 + (i2 - 1) * (u2.X + 0)) * CFrame.Angles(0, 1.5707963267948966, 0));
            alignModel(v61, u24);
            v56 = v56 + 1;
        end;
    end;

    for i = v56, #u16.beds do
        u16.beds[i]:Destroy();
    end;

    u16.beds = v57;
end;

local function clearPlotVisual(p62) -- Line: 217
    -- upvalues: u4 (copy)
    local v63 = u4[p62];

    if not v63 then
        return;
    end;

    for _, v in v63.poles do
        v:Destroy();
    end;

    for _, v in v63.connectors do
        v:Destroy();
    end;

    for _, v in v63.beds do
        v:Destroy();
    end;

    u4[p62] = nil;
end;

function v1.RenderPlot(p64, u65) -- Line: 226
    -- upvalues: u6 (copy), updatePlotVisual (copy)
    if u6[u65] then
        return;
    end;

    u6[u65] = true;
    task.defer(function() -- Line: 229
        -- upvalues: u6 (ref), u65 (copy), updatePlotVisual (ref)
        u6[u65] = nil;
        local PlotSizeReference = u65:FindFirstChild("PlotSizeReference");
        local Visual = u65:FindFirstChild("Visual");

        if not (PlotSizeReference and Visual) then
            return;
        end;

        if not (PlotSizeReference:IsA("BasePart") and Visual:IsA("Folder")) then
            return;
        end;

        local v66 = u65:GetAttribute("FenceSkin");
        updatePlotVisual(PlotSizeReference, Visual, typeof(v66) == "string" and v66 and v66 or "Default");
    end);
end;

function v1.SetupPlot(u67, u68) -- Line: 241
    -- upvalues: u5 (copy), clearPlotVisual (copy)
    if not u68:IsA("Model") then
        return;
    end;

    if not string.match(u68.Name, "^Plot%d+$") then
        return;
    end;

    local v69 = u5[u68];

    if v69 then
        for _, v in v69 do
            v:Disconnect();
        end;
    end;

    local v70 = {};
    u5[u68] = v70;
    local v71 = u68:GetAttributeChangedSignal("FenceSkin");
    table.insert(v70, v71:Connect(function() -- Line: 255
        -- upvalues: u67 (copy), u68 (copy)
        u67:RenderPlot(u68);
    end));
    local v72 = u68:GetAttributeChangedSignal("GardenExpansion");
    table.insert(v70, v72:Connect(function() -- Line: 258
        -- upvalues: u67 (copy), u68 (copy)
        u67:RenderPlot(u68);
    end));
    local PlotSizeReference = u68:FindFirstChild("PlotSizeReference");

    if PlotSizeReference and PlotSizeReference:IsA("BasePart") then
        local v73 = PlotSizeReference:GetPropertyChangedSignal("Size");
        table.insert(v70, v73:Connect(function() -- Line: 264
            -- upvalues: u67 (copy), u68 (copy)
            u67:RenderPlot(u68);
        end));
        local v74 = PlotSizeReference:GetPropertyChangedSignal("CFrame");
        table.insert(v70, v74:Connect(function() -- Line: 267
            -- upvalues: u67 (copy), u68 (copy)
            u67:RenderPlot(u68);
        end));
    end;

    table.insert(v70, u68.AncestryChanged:Connect(function(p75, p76) -- Line: 272
        -- upvalues: u68 (copy), clearPlotVisual (ref), u5 (ref)
        if p76 then
            return;
        end;

        local Visual = u68:FindFirstChild("Visual");

        if Visual and Visual:IsA("Folder") then
            clearPlotVisual(Visual);
        end;

        local v77 = u5[u68];

        if v77 then
            for _, v in v77 do
                v:Disconnect();
            end;

            u5[u68] = nil;
        end;
    end));
    u67:RenderPlot(u68);
end;

function v1.Init(p78) -- Line: 290
end;

function v1.Start(u79) -- Line: 293
    -- upvalues: Gardens (copy)
    for _, child in Gardens:GetChildren() do
        u79:SetupPlot(child);
    end;

    Gardens.ChildAdded:Connect(function(p80) -- Line: 298
        -- upvalues: u79 (copy)
        u79:SetupPlot(p80);
    end);
end;

return v1;