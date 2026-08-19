-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local FXUtil = UtilsSystem.FXUtil;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local ResourceUtil = UtilsSystem.ResourceUtil;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local TipsConfig = UtilsSystem.TipsConfig;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local VisibleMgr = UtilsSystem.VisibleMgr;
local Alchemy = UtilsSystem.GetData.Alchemy;
local Xyd10 = EnumMgr.Rare.Xyd10;
local Xyd4 = EnumMgr.Rare.Xyd4;
local Xyd42 = EnumMgr.Rare.Xyd4;
local v1 = AssetRegistry.BuildCatalogPath("BillBoard", "Drop");
local u2 = { "Dungeon", "掉落表现" };
local u3 = 0;
local u4 = ResourceUtil.GetTemplate(v1);

if not u4 then
    Log.warn("[SystemDrop.client] 缺少 Assets.BillBoard.Drop，路径:", v1);
end;

local ModelRes = game.ReplicatedStorage:FindFirstChild("ModelRes");
local v5 = ModelRes and ModelRes:FindFirstChild("Guide");

if v5 then
    v5 = v5:FindFirstChild("炼金箭头");
end;

local u6 = v5;
local u7 = nil;
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = nil;
local u12 = nil;
local u13 = false;
local u14 = nil;
local u15 = false;
local u16 = nil;
local u17 = false;
local u18 = {};
local u19 = false;

local function _getDropVisualConfig() -- Line: 165
    -- upvalues: SystemGameConfig (copy), u2 (copy)
    local v20 = SystemGameConfig.GetValue(u2);
    local u21 = type(v20) ~= "table" and {} or v20;

    local function readNumber(p22, p23) -- Line: 169
        -- upvalues: u21 (copy)
        return tonumber(u21[p22]) or p23;
    end;

    return {
        arcHeight = tonumber(u21["抛物线高度"]) or 6,
        arcDuration = tonumber(u21["抛物线时长"]) or 1.5,
        floatAmplitude = tonumber(u21["浮动幅度"]) or 0.12,
        floatPeriod = tonumber(u21["浮动周期"]) or 2.5,
        rotateSpeedDeg = tonumber(u21["旋转速度"]) or 45,
        surfaceClearance = tonumber(u21["表面间隙"]) or 0.08,
        pickupHoldDuration = tonumber(u21["拾取时长"]) or 0.5
    };
end;

local function _attachDropRareHighlight(p24, p25) -- Line: 192
    -- upvalues: UIMgr (copy)
    local v26 = UIMgr.GetColor3ByXYD(p25);

    if not v26 then
        return;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "DropRareHighlight";
    Highlight.Adornee = p24;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 0.5;
    Highlight.OutlineColor = v26;
    Highlight.Parent = p24;
end;

local function _applyAlchemyMarkPresent(p27, p28) -- Line: 217
    -- upvalues: Alchemy (copy), LocalPlayer (copy), u6 (ref)
    if Alchemy.GetMarkMaterialRemain(LocalPlayer, p28) <= 0 then
        return;
    end;

    if not u6 then
        return;
    end;

    local v29 = u6:Clone();
    v29.Name = "AlchemyMarkArrow";
    v29:PivotTo(p27:GetPivot() + Vector3.new(0, 6, 0));
    v29.Parent = p27;
end;

local function _initDropsClient() -- Line: 238
    -- upvalues: u7 (ref), Workspace (copy), u8 (copy), EnumMgr (copy), UIMgr (copy)
    if u7 and u7.Parent then
        return u7;
    end;

    local DropsClient = Workspace:FindFirstChild("DropsClient");

    if DropsClient and DropsClient:IsA("Model") then
        u7 = DropsClient;
        table.clear(u8);

        for _, child in DropsClient:GetChildren() do
            if child:IsA("Model") then
                u8[child.Name] = child;
            end;
        end;

        return DropsClient;
    end;

    local Model = Instance.new("Model");
    Model.Name = "DropsClient";
    Model.Parent = Workspace;
    u7 = Model;

    for _, v in pairs(EnumMgr.Rare) do
        local v30 = tonumber(v);

        if v30 and v30 > 0 then
            local Model2 = Instance.new("Model");
            Model2.Name = tostring(v30);
            Model2.Parent = Model;
            u8[tostring(v30)] = Model2;
            local v31 = UIMgr.GetColor3ByXYD(v30);

            if v31 then
                local Highlight = Instance.new("Highlight");
                Highlight.Name = "DropRareHighlight";
                Highlight.Adornee = Model2;
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
                Highlight.FillTransparency = 1;
                Highlight.OutlineTransparency = 0.5;
                Highlight.OutlineColor = v31;
                Highlight.Parent = Model2;
            end;
        end;
    end;

    return Model;
end;

local function _getDropRareFolder(p32) -- Line: 282
    -- upvalues: _initDropsClient (copy), u8 (copy), u7 (ref)
    _initDropsClient();
    local v33 = tonumber(p32) or 1;
    local v34 = math.floor(v33);
    local v35 = math.max(1, v34);

    return u8[tostring(v35)] or u7;
end;

local function _applyDropPhysicsState(p36) -- Line: 300
    -- upvalues: VisibleMgr (copy)
    VisibleMgr.AnchoredAll(p36);
    VisibleMgr.UnCollideAll(p36);
    VisibleMgr.UnTouchAll(p36);
end;

local function _destroyDrop(p37) -- Line: 312
    -- upvalues: u10 (copy), u9 (copy), u11 (ref)
    local v38 = u10[p37];

    if v38 then
        v38:Disconnect();
        u10[p37] = nil;
    end;

    local v39 = u9[p37];

    if v39 then
        u9[p37] = nil;
        local dropLight = v39.dropLight;

        if dropLight then
            dropLight:Destroy();
        end;

        if v39.model then
            v39.model:Destroy();
        end;
    end;

    if not next(u9) and u11 then
        u11:Disconnect();
        u11 = nil;
    end;
end;

local function _getDropCost(p40) -- Line: 343
    if not p40 then
        return 0;
    end;

    local v41 = tonumber(p40.GoldValue);

    if not v41 then
        return 0;
    end;

    local v42 = math.floor(v41);

    return math.max(0, v42);
end;

local function _applyDropBillboard(p43, p44) -- Line: 363
    -- upvalues: TranslationHelper (copy), UIMgr (copy), MathMgr (copy)
    local ZhName = p43:FindFirstChild("ZhName");

    if ZhName and ZhName:IsA("TextLabel") then
        TranslationHelper.SetText(ZhName, p44.ZhName);
    end;

    local XYD = p43:FindFirstChild("XYD");

    if XYD and XYD:IsA("TextLabel") then
        local setXydLabel = UIMgr.setXydLabel;
        local v45 = tonumber(p44.xyd) or 1;
        setXydLabel(XYD, math.floor(v45), false);
    end;

    local Cost = p43:FindFirstChild("Cost");

    if Cost and Cost:IsA("TextLabel") then
        local SetText_UnTrans = TranslationHelper.SetText_UnTrans;
        local getNumStr = MathMgr.getNumStr;
        local v46;

        if p44 then
            local v47 = tonumber(p44.GoldValue);

            if v47 then
                local v48 = math.floor(v47);
                v46 = math.max(0, v48);
            else
                v46 = 0;
            end;
        else
            v46 = 0;
        end;

        SetText_UnTrans(Cost, getNumStr(v46));
    end;
end;

local function _shouldActivateDropStageVisual(p49) -- Line: 386
    -- upvalues: u3 (ref)
    return p49 <= 0 and true or u3 == p49;
end;

local function _ensureDropBillboard(p50) -- Line: 399
    -- upvalues: u4 (copy), CfgFind (copy), _applyDropBillboard (copy)
    local PrimaryPart = p50.PrimaryPart;

    if not PrimaryPart then
        return nil;
    end;

    local Drop = PrimaryPart:FindFirstChild("Drop");

    if Drop and Drop:IsA("BillboardGui") then
        return Drop;
    end;

    if not u4 then
        return nil;
    end;

    local v51 = tonumber(p50:GetAttribute("ItemId"));
    local v52;

    if v51 then
        v52 = CfgFind.FindCfgByID(v51);
    else
        v52 = nil;
    end;

    if not v52 then
        return nil;
    end;

    local v53 = u4:Clone();
    v53.Name = "Drop";
    v53.Parent = PrimaryPart;
    _applyDropBillboard(v53, v52);

    return v53;
end;

local function _applyDropBillboardVisibility(p54) -- Line: 433
    -- upvalues: u3 (ref), _ensureDropBillboard (copy)
    local PrimaryPart = p54.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local v55 = tonumber(p54:GetAttribute("Stage")) or 0;
    local v56 = math.floor(v55);
    local v57 = math.max(0, v56);
    local v58;

    if p54:GetAttribute("DropLanded") == true then
        v58 = v57 <= 0 and true or u3 == v57;
    else
        v58 = false;
    end;

    if v58 then
        local v59 = _ensureDropBillboard(p54);

        if v59 then
            v59.Enabled = true;
        end;

        return;
    end;

    local Drop = PrimaryPart:FindFirstChild("Drop");

    if Drop and Drop:IsA("BillboardGui") then
        Drop.Enabled = false;
    end;
end;

local function _placeDropLightOnGround(p60) -- Line: 464
    -- upvalues: FXUtil (copy)
    local dropLight = p60.dropLight;

    if not (dropLight and dropLight.Parent) then
        return;
    end;

    local groundPos = p60.groundPos;

    if dropLight:IsA("Model") then
        FXUtil.PivotModelOnGroundAtWorldY(dropLight, groundPos);

        return;
    end;

    if dropLight:IsA("BasePart") then
        local v61 = Vector3.new(groundPos.X, groundPos.Y + dropLight.Size.Y * 0.5, groundPos.Z);
        dropLight.CFrame = CFrame.new(v61) * dropLight.CFrame.Rotation;
    end;
end;

local function _snapDropIdleRest(p62) -- Line: 490
    local model = p62.model;

    if not model.Parent then
        return;
    end;

    model:PivotTo(CFrame.new(p62.landPos) * p62.baseRotation);
    local arrowModel = p62.arrowModel;

    if arrowModel and arrowModel.Parent then
        arrowModel:PivotTo(CFrame.new(p62.landPos + Vector3.new(0, 6, 0)));
    end;
end;

local function _syncAllDropBillboards() -- Line: 509
    -- upvalues: u9 (copy), _applyDropBillboardVisibility (copy)
    for _, v in u9 do
        _applyDropBillboardVisibility(v.model);
    end;
end;

local function _onAggroStageChanged(p63) -- Line: 521
    -- upvalues: u3 (ref), u9 (copy), _applyDropBillboardVisibility (copy), _snapDropIdleRest (copy)
    local v64 = math.floor(p63);
    u3 = math.max(0, v64);

    for _, v in u9 do
        _applyDropBillboardVisibility(v.model);
    end;

    for _, v in u9 do
        if v.phase == "idle" then
            local stageId = v.stageId;

            if stageId > 0 and u3 ~= stageId then
                _snapDropIdleRest(v);
            end;
        end;
    end;
end;

local function _initDropGradients() -- Line: 537
    -- upvalues: u19 (ref), AssetPaths (copy), AssetRegistry (copy), Log (copy), Xyd10 (copy), u18 (copy)
    if u19 then
        return;
    end;

    u19 = true;
    local v65 = AssetPaths.GetCatalog(AssetRegistry.Catalog.AllGridients);

    if not v65 then
        Log.warn("[SystemDrop.client] Assets/AllGridients 未找到");

        return;
    end;

    local Drop = v65:FindFirstChild("Drop");

    if Drop and Drop:IsA("Folder") then
        for i = 1, Xyd10 do
            local v66 = tostring(i);
            local v67 = Drop:FindFirstChild(v66);

            if v67 and v67:IsA("UIGradient") then
                u18[v66] = v67;
            else
                Log.warn("[SystemDrop.client] 缺少掉落渐变 UIGradient:", v66);
            end;
        end;

        return;
    end;

    Log.warn("[SystemDrop.client] 缺少 Assets/AllGridients/Drop");
end;

local function _getDropEffectColorSequence(p68) -- Line: 572
    -- upvalues: _initDropGradients (copy), Xyd10 (copy), u18 (copy)
    _initDropGradients();
    local v69 = tonumber(p68) or 1;
    local v70 = math.floor(v69);
    local v71 = math.clamp(v70, 1, Xyd10);
    local v72 = u18[tostring(v71)];

    if v72 then
        return v72.Color;
    end;

    return nil;
end;

local function _sampleDropEffectSolidColor(p73) -- Line: 586
    local Keypoints = p73.Keypoints;

    if not Keypoints or #Keypoints == 0 then
        return Color3.new(1, 1, 1);
    end;

    if #Keypoints == 1 then
        return Keypoints[1].Value;
    end;

    if Keypoints[1].Time >= 0.5 then
        return Keypoints[1].Value;
    end;

    if Keypoints[#Keypoints].Time <= 0.5 then
        return Keypoints[#Keypoints].Value;
    end;

    for i = 1, #Keypoints - 1 do
        local v74 = Keypoints[i];
        local v75 = Keypoints[i + 1];

        if v74.Time <= 0.5 and v75.Time >= 0.5 then
            local v76 = v75.Time - v74.Time;

            return v74.Value:Lerp(v75.Value, v76 <= 0 and 0 or (0.5 - v74.Time) / v76);
        end;
    end;

    return Keypoints[#Keypoints].Value;
end;

local function _applyDropEffectRarityColor(p77, p78) -- Line: 623
    -- upvalues: _initDropGradients (copy), Xyd10 (copy), u18 (copy), _sampleDropEffectSolidColor (copy)
    _initDropGradients();
    local v79 = tonumber(p78) or 1;
    local v80 = math.floor(v79);
    local v81 = math.clamp(v80, 1, Xyd10);
    local v82 = u18[tostring(v81)];
    local u83;

    if v82 then
        u83 = v82.Color;
    else
        u83 = nil;
    end;

    if not u83 then
        return;
    end;

    local u84 = _sampleDropEffectSolidColor(u83);

    local function applyTo(p85) -- Line: 631
        -- upvalues: u83 (copy), u84 (copy)
        if p85:IsA("ParticleEmitter") or (p85:IsA("Trail") or p85:IsA("Beam")) then
            p85.Color = u83;

            return;
        end;

        if p85:IsA("PointLight") or (p85:IsA("SpotLight") or p85:IsA("SurfaceLight")) then
            p85.Color = u84;
        end;
    end;

    applyTo(p77);

    for _, descendant in p77:GetDescendants() do
        applyTo(descendant);
    end;
end;

local function _getDropTrailTemplate() -- Line: 650
    -- upvalues: u13 (ref), u12 (ref), AssetRegistry (copy), ResourceUtil (copy), Log (copy)
    if u13 then
        return u12;
    end;

    u13 = true;
    local v86 = AssetRegistry.BuildCatalogPath("DropTrail", "Temp");
    u12 = ResourceUtil.GetTemplate(v86);

    if not u12 then
        Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v86);
    end;

    return u12;
end;

local function _getDropParticleTemplate() -- Line: 669
    -- upvalues: u15 (ref), u14 (ref), AssetRegistry (copy), ResourceUtil (copy), Log (copy)
    if u15 then
        return u14;
    end;

    u15 = true;
    local v87 = AssetRegistry.BuildCatalogPath("DropParticle", "Temp");
    u14 = ResourceUtil.GetTemplate(v87);

    if not u14 then
        Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v87);
    end;

    return u14;
end;

local function _getDropLightTemplate() -- Line: 688
    -- upvalues: u17 (ref), u16 (ref), AssetRegistry (copy), ResourceUtil (copy), Log (copy)
    if u17 then
        return u16;
    end;

    u17 = true;
    local v88 = AssetRegistry.BuildCatalogPath("DropLight", "Temp");
    u16 = ResourceUtil.GetTemplate(v88);

    if not u16 then
        Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v88);
    end;

    return u16;
end;

local function _attachDropEffectInstance(p89, p90, p91, p92) -- Line: 711
    -- upvalues: FXUtil (copy), _applyDropEffectRarityColor (copy)
    local v93 = p90:Clone();
    v93.Name = p92;
    v93.Parent = p89;

    if v93:IsA("Model") then
        v93:PivotTo(p89.CFrame);
    elseif v93:IsA("BasePart") then
        v93.CFrame = p89.CFrame;
    end;

    FXUtil.SetEmittersTrailsBeamsEnabled(v93, true);
    _applyDropEffectRarityColor(v93, p91);
end;

local function _attachDropRarityEffects(p94, p95) -- Line: 735
    -- upvalues: u13 (ref), u12 (ref), AssetRegistry (copy), ResourceUtil (copy), Log (copy), _attachDropEffectInstance (copy), Xyd4 (copy), u15 (ref), u14 (ref)
    local v96;

    if u13 then
        v96 = u12;
    else
        u13 = true;
        local v97 = AssetRegistry.BuildCatalogPath("DropTrail", "Temp");
        u12 = ResourceUtil.GetTemplate(v97);

        if not u12 then
            Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v97);
        end;

        v96 = u12;
    end;

    if v96 then
        _attachDropEffectInstance(p94, v96, p95, "DropTrail");
    end;

    if Xyd4 <= p95 then
        local v98;

        if u15 then
            v98 = u14;
        else
            u15 = true;
            local v99 = AssetRegistry.BuildCatalogPath("DropParticle", "Temp");
            u14 = ResourceUtil.GetTemplate(v99);

            if not u14 then
                Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v99);
            end;

            v98 = u14;
        end;

        if v98 then
            _attachDropEffectInstance(p94, v98, p95, "DropParticle");
        end;
    end;
end;

local function _attachDropLightAtGround(p100, p101) -- Line: 757
    -- upvalues: Xyd42 (copy), u17 (ref), u16 (ref), AssetRegistry (copy), ResourceUtil (copy), Log (copy), _initDropsClient (copy), VisibleMgr (copy), _placeDropLightOnGround (copy), FXUtil (copy), _applyDropEffectRarityColor (copy)
    if p100.xyd <= Xyd42 then
        return;
    end;

    if p100.dropLight and p100.dropLight.Parent then
        return;
    end;

    local v102;

    if u17 then
        v102 = u16;
    else
        u17 = true;
        local v103 = AssetRegistry.BuildCatalogPath("DropLight", "Temp");
        u16 = ResourceUtil.GetTemplate(v103);

        if not u16 then
            Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v103);
        end;

        v102 = u16;
    end;

    if not v102 then
        return;
    end;

    local v104 = v102:Clone();
    v104.Name = "DropLight" .. "_" .. p101;
    v104.Parent = _initDropsClient();

    if v104:IsA("BasePart") then
        v104.Anchored = true;
        v104.CanCollide = false;
        v104.CanQuery = false;
        v104.CanTouch = false;
    elseif v104:IsA("Model") then
        VisibleMgr.AnchoredAll(v104);
        VisibleMgr.UnCollideAll(v104);
        VisibleMgr.UnTouchAll(v104);
    end;

    p100.dropLight = v104;
    _placeDropLightOnGround(p100);
    FXUtil.SetEmittersTrailsBeamsEnabled(v104, true);
    _applyDropEffectRarityColor(v104, p100.xyd);
end;

local function _fadeOutDropTrail(p105, p106) -- Line: 802
    -- upvalues: FXUtil (copy)
    local PrimaryPart = p105.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local DropTrail = PrimaryPart:FindFirstChild("DropTrail");

    if not DropTrail then
        return;
    end;

    local Parent = p105.Parent;

    if Parent then
        DropTrail.Parent = Parent;
    end;

    if DropTrail:IsA("Model") then
        DropTrail:PivotTo(p106);
        FXUtil.Stop_All_Emit(DropTrail);
    elseif DropTrail:IsA("BasePart") then
        DropTrail.Anchored = true;
        DropTrail.CFrame = p106;
    end;

    FXUtil.FadeModel_KeepTrails(DropTrail, 0.1, 2);
end;

local function _sampleParabolicPosition(p107, p108, p109, p110) -- Line: 836
    local v111 = math.clamp(p109, 0, 1);

    return p107:Lerp(p108, v111) + Vector3.new(0, p110 * 4 * v111 * (1 - v111), 0);
end;

local function _resolveDropLandPosition(p112, p113, p114) -- Line: 851
    -- upvalues: _getDropVisualConfig (copy)
    p112:PivotTo(CFrame.new(p113) * p114);
    local v115, v116 = p112:GetBoundingBox();
    local v117 = v115.Position.Y - v116.Y / 2;
    local surfaceClearance = _getDropVisualConfig().surfaceClearance;
    local v118 = math.max(0, surfaceClearance);
    local v119 = p113.Y + v118 - v117;

    if v119 > 0 then
        return p113 + Vector3.new(0, v119, 0);
    end;

    return p113;
end;

local function _createDropVisual(p120, p121, p122) -- Line: 875
    -- upvalues: CfgFind (copy), ResourceUtil (copy), u13 (ref), u12 (ref), AssetRegistry (copy), Log (copy), _attachDropEffectInstance (copy), Xyd4 (copy), u15 (ref), u14 (ref), VisibleMgr (copy), Alchemy (copy), LocalPlayer (copy), u6 (ref), _initDropsClient (copy), u8 (copy), u7 (ref)
    local v123 = CfgFind.FindCfgByID(p120);

    if not v123 then
        return nil, 1;
    end;

    local v124 = tonumber(v123.xyd) or 1;
    local v125 = math.floor(v124);
    local Model = Instance.new("Model");
    Model.Name = "DropItem";
    local Part = Instance.new("Part");
    Part.Name = "Root";
    Part.Size = Vector3.new(0.8, 0.8, 0.8);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.Transparency = 1;
    Part.CFrame = CFrame.new(p121);
    Part.Parent = Model;
    Model.PrimaryPart = Part;
    Model:SetAttribute("ItemId", p120);
    local v126;

    if v123 then
        local v127 = tonumber(v123.GoldValue);

        if v127 then
            local v128 = math.floor(v127);
            v126 = math.max(0, v128);
        else
            v126 = 0;
        end;
    else
        v126 = 0;
    end;

    Model:SetAttribute("GoldValue", v126);
    Model:SetAttribute("Xyd", v125);
    local v129 = math.floor(p122);
    Model:SetAttribute("Stage", (math.max(0, v129)));
    Model:SetAttribute("DropLanded", false);
    local Model2 = v123.Model;
    local v130 = type(Model2) == "string" and Model2 ~= "" and ResourceUtil.GetModel(ResourceUtil.ModelCategory.Material, Model2);

    if v130 then
        v130.Parent = Model;

        if v130:IsA("Model") and v130.PrimaryPart then
            v130:PivotTo(Part.CFrame);
        end;
    end;

    local v131;

    if u13 then
        v131 = u12;
    else
        u13 = true;
        local v132 = AssetRegistry.BuildCatalogPath("DropTrail", "Temp");
        u12 = ResourceUtil.GetTemplate(v132);

        if not u12 then
            Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v132);
        end;

        v131 = u12;
    end;

    if v131 then
        _attachDropEffectInstance(Part, v131, v125, "DropTrail");
    end;

    if Xyd4 <= v125 then
        local v133;

        if u15 then
            v133 = u14;
        else
            u15 = true;
            local v134 = AssetRegistry.BuildCatalogPath("DropParticle", "Temp");
            u14 = ResourceUtil.GetTemplate(v134);

            if not u14 then
                Log.warn("[SystemDrop.client] 缺少掉落表现模板:", v134);
            end;

            v133 = u14;
        end;

        if v133 then
            _attachDropEffectInstance(Part, v133, v125, "DropParticle");
        end;
    end;

    VisibleMgr.AnchoredAll(Model);
    VisibleMgr.UnCollideAll(Model);
    VisibleMgr.UnTouchAll(Model);

    if Alchemy.GetMarkMaterialRemain(LocalPlayer, p120) > 0 and u6 then
        local v135 = u6:Clone();
        v135.Name = "AlchemyMarkArrow";
        v135:PivotTo(Model:GetPivot() + Vector3.new(0, 6, 0));
        v135.Parent = Model;
    end;

    _initDropsClient();
    local v136 = tonumber(v125) or 1;
    local v137 = math.floor(v136);
    local v138 = math.max(1, v137);
    Model.Parent = u8[tostring(v138)] or u7;

    return Model, v125;
end;

local function _attachPickupPrompt(u139, p140) -- Line: 929
    -- upvalues: _getDropVisualConfig (copy), u10 (copy), LocalPlayer (copy), NetWork (copy), NetMsg (copy)
    local PrimaryPart = p140.PrimaryPart;

    if not PrimaryPart then
        return;
    end;

    local v141 = _getDropVisualConfig();
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "PickupPrompt";
    ProximityPrompt.ActionText = "拾取";
    ProximityPrompt.ObjectText = "";
    ProximityPrompt.HoldDuration = v141.pickupHoldDuration;
    ProximityPrompt.MaxActivationDistance = 10;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    ProximityPrompt.Parent = PrimaryPart;
    u10[u139] = ProximityPrompt.Triggered:Connect(function(p142) -- Line: 946
        -- upvalues: LocalPlayer (ref), NetWork (ref), NetMsg (ref), u139 (copy)
        if p142 ~= LocalPlayer then
            return;
        end;

        NetWork.FireServer(NetMsg.DROP_PICKUP, u139);
    end);
end;

local function _onDropLanded(p143, p144) -- Line: 961
    -- upvalues: _fadeOutDropTrail (copy), _attachDropLightAtGround (copy), _applyDropBillboardVisibility (copy), VisibleMgr (copy), _attachPickupPrompt (copy), u3 (ref), _snapDropIdleRest (copy)
    local model = p144.model;
    local v145 = CFrame.new(p144.landPos) * p144.baseRotation;
    model:PivotTo(v145);
    model:SetAttribute("DropLanded", true);
    _fadeOutDropTrail(model, v145);
    _attachDropLightAtGround(p144, p143);
    _applyDropBillboardVisibility(model);
    VisibleMgr.AnchoredAll(model);
    VisibleMgr.UnCollideAll(model);
    VisibleMgr.UnTouchAll(model);
    _attachPickupPrompt(p143, model);
    p144.phase = "idle";
    p144.startTime = os.clock();
    p144.arrowModel = model:FindFirstChild("AlchemyMarkArrow");
    local stageId = p144.stageId;

    if stageId > 0 and u3 ~= stageId then
        _snapDropIdleRest(p144);
    end;
end;

local function _onDropFrame() -- Line: 987
    -- upvalues: u9 (copy), _onDropLanded (copy), u3 (ref)
    local v146 = os.clock();

    for i, v in u9 do
        local model = v.model;

        if model.Parent then
            local v147 = v146 - v.startTime;

            if v.phase == "fly" then
                local v148 = math.clamp(v147 / v.arcDuration, 0, 1);
                local originPos = v.originPos;
                local landPos = v.landPos;
                local arcHeight = v.arcHeight;
                local v149 = math.clamp(v148, 0, 1);
                local v150 = originPos:Lerp(landPos, v149) + Vector3.new(0, arcHeight * 4 * v149 * (1 - v149), 0);
                local v151 = CFrame.Angles(0, v.rotateSpeedRad * v147, 0);
                model:PivotTo(CFrame.new(v150) * v.baseRotation * v151);

                if v148 >= 1 then
                    _onDropLanded(i, v);
                end;
            else
                local stageId = v.stageId;

                if stageId <= 0 and true or u3 == stageId then
                    local v152 = math.sin(v147 * 3.141592653589793 * 2 / v.floatPeriod) * v.floatAmplitude;
                    local v153 = CFrame.Angles(0, v.rotateSpeedRad * v147, 0);
                    model:PivotTo(CFrame.new(v.landPos + Vector3.new(0, v152, 0)) * v.baseRotation * v153);
                    local arrowModel = v.arrowModel;

                    if arrowModel and arrowModel.Parent then
                        local v154 = math.sin(v147 * 3.141592653589793 * 2 / 1.2) * 0.25;
                        arrowModel:PivotTo(CFrame.new(v.landPos + Vector3.new(0, v152 + 6 + v154, 0)));
                    end;
                end;
            end;
        end;
    end;
end;

local function _ensureFrameConnection() -- Line: 1026
    -- upvalues: u11 (ref), RunService (copy), _onDropFrame (copy)
    if u11 then
        return;
    end;

    u11 = RunService.Heartbeat:Connect(_onDropFrame);
end;

local function _playDropAnimation(p155, p156, p157, p158, p159) -- Line: 1043
    -- upvalues: _createDropVisual (copy), _getDropVisualConfig (copy), _resolveDropLandPosition (copy), u9 (copy), u11 (ref), RunService (copy), _onDropFrame (copy)
    local v160, v161 = _createDropVisual(p156, p157, p159);

    if not (v160 and v160.PrimaryPart) then
        return;
    end;

    local v162 = _getDropVisualConfig();
    local v163 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0);
    local v164 = _resolveDropLandPosition(v160, p158, v163);
    local v165 = {
        phase = "fly",
        arrowModel = nil,
        dropLight = nil,
        model = v160
    };
    local v166 = math.floor(p159);
    v165.stageId = math.max(0, v166);
    v165.xyd = v161;
    v165.originPos = p157;
    v165.landPos = v164;
    v165.groundPos = p158;
    v165.baseRotation = v163;
    v165.arcHeight = math.max(0, v162.arcHeight);
    v165.arcDuration = math.max(0.05, v162.arcDuration);
    v165.floatAmplitude = math.max(0, v162.floatAmplitude);
    v165.floatPeriod = math.max(0.1, v162.floatPeriod);
    v165.rotateSpeedRad = math.rad(v162.rotateSpeedDeg);
    v165.startTime = os.clock();
    u9[p155] = v165;

    if u11 then
        return;
    end;

    u11 = RunService.Heartbeat:Connect(_onDropFrame);
end;

NetWork.RegisterClientRemoteEvent(NetMsg.DROP_SPAWN, function(p167) -- Line: 1081, Name: _onDropSpawn
    -- upvalues: _playDropAnimation (copy), Alchemy (copy), LocalPlayer (copy), TipsModule (copy), TipsConfig (copy)
    if type(p167) ~= "table" then
        return;
    end;

    local v168 = p167[1];
    local v169 = p167[2];
    local v170 = tonumber(p167[3]) or 0;
    local v171 = math.floor(v170);
    local v172 = math.max(0, v171);

    if typeof(v168) ~= "Vector3" or type(v169) ~= "table" then
        return;
    end;

    local v173 = false;

    for _, v in v169 do
        if type(v) == "table" then
            local v174 = v[1];
            local v175 = tonumber(v[2]);
            local v176 = v[4];

            if type(v174) == "string" and (v175 and typeof(v176) == "Vector3") then
                _playDropAnimation(v174, v175, v168, v176, v172);

                if not v173 and Alchemy.GetMarkMaterialRemain(LocalPlayer, v175) > 0 then
                    v173 = true;
                end;
            end;
        end;
    end;

    if v173 then
        TipsModule.RainbowTips(LocalPlayer, "配方材料掉落", nil, nil, TipsConfig.GRADIENT_TIP_YELLOW);
    end;
end);
NetWork.RegisterClientRemoteEvent(NetMsg.DROP_PICKED, function(p177) -- Line: 1115
    -- upvalues: _destroyDrop (copy)
    if type(p177) ~= "string" then
        return;
    end;

    _destroyDrop(p177);
end);
local DungeonAggroStage = LocalPlayer:WaitForChild("DungeonAggroStage", (1 / 0));
AddListen.NumValueAdd(DungeonAggroStage, _onAggroStageChanged, true);
_initDropsClient();