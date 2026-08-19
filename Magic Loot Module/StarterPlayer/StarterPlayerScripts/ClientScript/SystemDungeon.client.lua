-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local CollectionService = UtilsSystem.CollectionService;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local RunService = UtilsSystem.RunService;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local TipsConfig = UtilsSystem.TipsConfig;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local VisibleMgr = UtilsSystem.VisibleMgr;
local DwarfKingAppearPresentation = UtilsSystem.DwarfKingAppearPresentation;
local Alchemy = UtilsSystem.GetData.Alchemy;
local u1 = { "Dungeon", "前门UI距离淡出", "完全透明距离" };
local u2 = { "Dungeon", "前门UI距离淡出", "完全不透明距离" };
local u3 = 0;
local u4 = 0;
local u5 = 0;
local u6 = 0;
local u7 = {};
local u8 = {};
local u9 = false;
local u10 = {};
local u11 = {};
local u12 = nil;
local u13 = nil;

local function _isDwarfKingCutscenePlaying() -- Line: 109
    -- upvalues: DwarfKingAppearPresentation (copy)
    local v14;

    if type(DwarfKingAppearPresentation) == "table" and type(DwarfKingAppearPresentation.IsPlaying) == "function" then
        v14 = DwarfKingAppearPresentation.IsPlaying() == true;
    else
        v14 = false;
    end;

    return v14;
end;

local function _getSkyNameForStage(p15) -- Line: 121
    -- upvalues: CfgFind (copy)
    if p15 <= 0 then
        return "世界1";
    end;

    local v16 = CfgFind.GetCfgByNameAndID("dungeonConf", p15);

    if type(v16) ~= "table" then
        return "世界1";
    end;

    local Sky = v16.Sky;

    if type(Sky) == "string" and Sky ~= "" then
        return Sky;
    end;

    local v17 = tostring(Sky or "");

    return (v17 == "" or v17 == "nil") and "世界1" or v17;
end;

local function _resolveSkyStageId() -- Line: 145
    -- upvalues: u6 (ref), u5 (ref)
    if u6 > 0 then
        return u6;
    end;

    return u5 <= 0 and 0 or u5;
end;

local function _applyDungeonSky() -- Line: 160
    -- upvalues: u6 (ref), u5 (ref), CfgFind (copy), NetWork (copy), NetMsg (copy)
    local v18;

    if u6 > 0 then
        v18 = u6;
    else
        v18 = u5 <= 0 and 0 or u5;
    end;

    local v19;

    if v18 <= 0 then
        v19 = "世界1";
    else
        local v20 = CfgFind.GetCfgByNameAndID("dungeonConf", v18);

        if type(v20) == "table" then
            v19 = v20.Sky;

            if type(v19) ~= "string" or v19 == "" then
                local v21 = tostring(v19 or "");
                v19 = (v21 == "" or v21 == "nil") and "世界1" or v21;
            end;
        else
            v19 = "世界1";
        end;
    end;

    NetWork.FireBindable(NetMsg.LIGHTING_CHANGE, v19, 2);
end;

local function _getRespawnCountdownRemain(p22) -- Line: 171
    -- upvalues: u7 (copy)
    local v23 = u7[p22];

    if not v23 or v23 <= 0 then
        return nil;
    end;

    local v24 = v23 - workspace:GetServerTimeNow();
    local v25 = math.ceil(v24);

    return math.max(0, v25);
end;

local function _clearAllRespawnVisualState() -- Line: 184
    -- upvalues: u7 (copy), u8 (copy)
    table.clear(u7);
    table.clear(u8);
end;

local function _getDoorStageId(p26) -- Line: 195
    local v27 = tonumber(p26:GetAttribute("Stage"));

    if v27 and v27 > 0 then
        return v27;
    end;

    return nil;
end;

local function _findNamedSurfaceGui(p28, p29) -- Line: 210
    local v30 = p28:FindFirstChild(p29, true);

    if v30 and v30:IsA("SurfaceGui") then
        return v30;
    end;

    return nil;
end;

local function _findDoorRootStageSurfaceGui(p31) -- Line: 224
    local Root = p31:FindFirstChild("Root", true);

    if not Root then
        return nil;
    end;

    local SurfaceGui = Root:FindFirstChild("SurfaceGui");

    if SurfaceGui and SurfaceGui:IsA("SurfaceGui") then
        return SurfaceGui;
    end;

    return nil;
end;

local function _findFrontDoorRootCanvasGroup(p32) -- Line: 242
    local Root = p32:FindFirstChild("Root", true);
    local v33;

    if Root then
        v33 = Root:FindFirstChild("SurfaceGui");

        if not (v33 and v33:IsA("SurfaceGui")) then
            v33 = nil;
        end;
    else
        v33 = nil;
    end;

    if v33 then
        return v33:FindFirstChildWhichIsA("CanvasGroup") or nil;
    end;

    return nil;
end;

local function _findFrontDoorModel(p34) -- Line: 260
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged("DungeonFrontDoor") do
        if v:IsA("Model") then
            local v35 = tonumber(v:GetAttribute("Stage"));

            if not v35 or v35 <= 0 then
                v35 = nil;
            end;

            if v35 == p34 then
                return v;
            end;
        end;
    end;

    return nil;
end;

local function _getFrontDoorGuiFadeDistances() -- Line: 275
    -- upvalues: SystemGameConfig (copy), u1 (copy), u2 (copy)
    local v36 = tonumber(SystemGameConfig.GetValue(u1)) or 16;
    local v37 = tonumber(SystemGameConfig.GetValue(u2)) or 36;

    if v37 < v36 then
        v37 = v36;
    end;

    return v36, v37;
end;

local function _computeFrontDoorGuiGroupTransparency(p38) -- Line: 290
    -- upvalues: SystemGameConfig (copy), u1 (copy), u2 (copy)
    local v39 = tonumber(SystemGameConfig.GetValue(u1)) or 16;
    local v40 = tonumber(SystemGameConfig.GetValue(u2)) or 36;

    if v40 < v39 then
        v40 = v39;
    end;

    return p38 <= v39 and 1 or (v40 <= p38 and 0 or 1 - (p38 - v39) / (v40 - v39));
end;

local function _resetLastFadedFrontDoorCanvas() -- Line: 306
    -- upvalues: u13 (ref)
    if u13 and u13.Parent then
        u13.GroupTransparency = 0;
    end;

    u13 = nil;
end;

local function _updateFrontDoorGuiDistanceFade() -- Line: 318
    -- upvalues: DwarfKingAppearPresentation (copy), u5 (ref), u13 (ref), _findFrontDoorModel (copy), SystemGameConfig (copy), u1 (copy), u2 (copy)
    local v41;

    if type(DwarfKingAppearPresentation) == "table" and type(DwarfKingAppearPresentation.IsPlaying) == "function" then
        v41 = DwarfKingAppearPresentation.IsPlaying() == true;
    else
        v41 = false;
    end;

    if v41 then
        return;
    end;

    if u5 <= 0 then
        if u13 and u13.Parent then
            u13.GroupTransparency = 0;
        end;

        u13 = nil;

        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local v42 = _findFrontDoorModel(u5);

    if not v42 then
        if u13 and u13.Parent then
            u13.GroupTransparency = 0;
        end;

        u13 = nil;

        return;
    end;

    local Root = v42:FindFirstChild("Root", true);
    local v43;

    if Root then
        v43 = Root:FindFirstChild("SurfaceGui");

        if not (v43 and v43:IsA("SurfaceGui")) then
            v43 = nil;
        end;
    else
        v43 = nil;
    end;

    local v44;

    if v43 then
        v44 = v43:FindFirstChildWhichIsA("CanvasGroup") or nil;
    else
        v44 = nil;
    end;

    if not v44 then
        if u13 and u13.Parent then
            u13.GroupTransparency = 0;
        end;

        u13 = nil;

        return;
    end;

    if u13 and (u13 ~= v44 and u13.Parent) then
        u13.GroupTransparency = 0;
    end;

    u13 = v44;
    local Root2 = v42:FindFirstChild("Root", true);
    local v45;

    if Root2 and Root2:IsA("BasePart") then
        v45 = Root2.Position;
    else
        v45 = v42:GetPivot().Position;
    end;

    local Magnitude = (CurrentCamera.CFrame.Position - v45).Magnitude;
    local v46 = tonumber(SystemGameConfig.GetValue(u1)) or 16;
    local v47 = tonumber(SystemGameConfig.GetValue(u2)) or 36;

    if v47 < v46 then
        v47 = v46;
    end;

    v44.GroupTransparency = Magnitude <= v46 and 1 or (v47 <= Magnitude and 0 or 1 - (Magnitude - v46) / (v47 - v46));
end;

local function _setFrontDoorGuiDistanceFadeEnabled(p48) -- Line: 363
    -- upvalues: u12 (ref), u13 (ref), RunService (copy), _updateFrontDoorGuiDistanceFade (copy)
    if p48 then
        if u12 then
            return;
        end;

        u12 = RunService.Heartbeat:Connect(_updateFrontDoorGuiDistanceFade);

        return;
    end;

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    if u13 and u13.Parent then
        u13.GroupTransparency = 0;
    end;

    u13 = nil;
end;

local function _findTextLabelUnderSurfaceGui(p49, p50) -- Line: 387
    local v51 = p49:FindFirstChild(p50, true);

    if v51 and v51:IsA("TextLabel") then
        return v51;
    end;

    return nil;
end;

local function _findStageNameTextLabel(p52, p53) -- Line: 402
    local v54 = p52:FindFirstChild("阶段N", true);

    if not (v54 and v54:IsA("TextLabel")) then
        v54 = nil;
    end;

    if v54 then
        return v54;
    end;

    if not p53 then
        return nil;
    end;

    local TextLabel = p52:FindFirstChild("TextLabel", true);

    if TextLabel and TextLabel:IsA("TextLabel") then
        return TextLabel;
    end;

    return nil;
end;

local function _applyDoorRootStageLabel(p55, p56, p57, p58) -- Line: 422
    -- upvalues: TranslationHelper (copy)
    local Root = p55:FindFirstChild("Root", true);
    local v59;

    if Root then
        v59 = Root:FindFirstChild("SurfaceGui");

        if not (v59 and v59:IsA("SurfaceGui")) then
            v59 = nil;
        end;
    else
        v59 = nil;
    end;

    if not v59 then
        return;
    end;

    local v60 = v59:FindFirstChild("阶段N", true);

    if not (v60 and v60:IsA("TextLabel")) then
        v60 = nil;
    end;

    if not v60 then
        if p57 then
            v60 = v59:FindFirstChild("TextLabel", true);

            if not (v60 and v60:IsA("TextLabel")) then
                v60 = nil;
            end;
        else
            v60 = nil;
        end;
    end;

    if v60 then
        TranslationHelper.SetText(v60, "阶段N", { (tostring(p56)) });
    end;

    v59.Enabled = p58;
end;

local function _applyBackDoorRootSurfaceGui(p61, p62, p63, p64, p65) -- Line: 451
    -- upvalues: TranslationHelper (copy)
    local Root = p61:FindFirstChild("Root", true);
    local v66;

    if Root then
        v66 = Root:FindFirstChild("SurfaceGui");

        if not (v66 and v66:IsA("SurfaceGui")) then
            v66 = nil;
        end;
    else
        v66 = nil;
    end;

    if not v66 then
        return;
    end;

    local v67 = v66:FindFirstChild("阶段N", true);

    if not (v67 and v67:IsA("TextLabel")) then
        v67 = nil;
    end;

    local v68 = v67 or nil;

    if v68 then
        TranslationHelper.SetText(v68, "阶段N", { (tostring(p62)) });
    end;

    local TextLabel = v66:FindFirstChild("TextLabel", true);

    if not (TextLabel and TextLabel:IsA("TextLabel")) then
        TextLabel = nil;
    end;

    if TextLabel and p64 then
        TranslationHelper.SetText(TextLabel, p64, p65);
    end;

    v66.Enabled = p63;
end;

local function _setAllDoorBeamsEnabled(p69, p70) -- Line: 483
    for _, descendant in p69:GetDescendants() do
        if descendant:IsA("Beam") then
            descendant.Enabled = p70;
        end;
    end;
end;

local function _setBeamsInFolderEnabled(p71, p72) -- Line: 498
    if not p71 then
        return;
    end;

    for _, descendant in p71:GetDescendants() do
        if descendant:IsA("Beam") then
            descendant.Enabled = p72;
        end;
    end;
end;

local function _applyDoorBeamColor(p73, p74) -- Line: 516
    -- upvalues: _setAllDoorBeamsEnabled (copy), _setBeamsInFolderEnabled (copy)
    _setAllDoorBeamsEnabled(p73, false);
    _setBeamsInFolderEnabled(p73:FindFirstChild(p74 and "红" or "绿", true), true);
end;

local function _syncDoorBeamEnabled(p75, p76, p77) -- Line: 531
    if not p77.visible then
        p75.Enabled = false;

        return;
    end;

    local v78 = p77.isRed == true;
    local v79 = p76:FindFirstChild("红", true);
    local v80 = p76:FindFirstChild("绿", true);

    if v79 and p75:IsDescendantOf(v79) then
        p75.Enabled = v78;

        return;
    end;

    if v80 and p75:IsDescendantOf(v80) then
        p75.Enabled = not v78;

        return;
    end;

    p75.Enabled = false;
end;

local function _bindDoorBeamWatch(u81) -- Line: 554
    -- upvalues: u11 (copy), u10 (copy), _syncDoorBeamEnabled (copy)
    if u11[u81] then
        return;
    end;

    u11[u81] = u81.DescendantAdded:Connect(function(p82) -- Line: 559
        -- upvalues: u10 (ref), u81 (copy), _syncDoorBeamEnabled (ref)
        if not p82:IsA("Beam") then
            return;
        end;

        local v83 = u10[u81];

        if not v83 then
            return;
        end;

        _syncDoorBeamEnabled(p82, u81, v83);
    end);
    u81.Destroying:Connect(function() -- Line: 570
        -- upvalues: u11 (ref), u81 (copy), u10 (ref)
        local v84 = u11[u81];

        if v84 then
            v84:Disconnect();
            u11[u81] = nil;
        end;

        u10[u81] = nil;
    end);
end;

local function _setAllDoorSurfaceGuisEnabled(p85, p86) -- Line: 587
    for _, descendant in p85:GetDescendants() do
        if descendant:IsA("SurfaceGui") then
            descendant.Enabled = p86;
        end;
    end;
end;

local function _applyDoorVisual(p87, p88, p89) -- Line: 603
    -- upvalues: u10 (copy), _bindDoorBeamWatch (copy), _setAllDoorBeamsEnabled (copy), _setAllDoorSurfaceGuisEnabled (copy), VisibleMgr (copy), DwarfKingAppearPresentation (copy), _setBeamsInFolderEnabled (copy), _applyDoorRootStageLabel (copy), _applyBackDoorRootSurfaceGui (copy)
    u10[p87] = p88;
    _bindDoorBeamWatch(p87);

    if not p88.visible then
        _setAllDoorBeamsEnabled(p87, false);
        _setAllDoorSurfaceGuisEnabled(p87, false);
        VisibleMgr.UnCollideAll(p87);

        return;
    end;

    if p88.canCollide then
        VisibleMgr.CollideAll(p87);
    else
        VisibleMgr.UnCollideAll(p87);
    end;

    local v90;

    if type(DwarfKingAppearPresentation) == "table" and type(DwarfKingAppearPresentation.IsPlaying) == "function" then
        v90 = DwarfKingAppearPresentation.IsPlaying() == true;
    else
        v90 = false;
    end;

    if v90 then
        _setAllDoorSurfaceGuisEnabled(p87, false);
        local v91 = p88.isRed == true;
        _setAllDoorBeamsEnabled(p87, false);
        _setBeamsInFolderEnabled(p87:FindFirstChild(v91 and "红" or "绿", true), true);

        return;
    end;

    if p89 then
        local v92 = p87:FindFirstChild("SurfaceGui无法返回", true);

        if not (v92 and v92:IsA("SurfaceGui")) then
            v92 = nil;
        end;

        if v92 then
            v92.Enabled = p88.noReturnGuiEnabled == true;
        end;

        local v93 = tonumber(p87:GetAttribute("Stage"));

        if not v93 or v93 <= 0 then
            v93 = nil;
        end;

        if v93 then
            _applyDoorRootStageLabel(p87, v93, true, p88.rootStageGuiEnabled ~= false);
        end;
    else
        local v94 = tonumber(p87:GetAttribute("Stage"));

        if not v94 or v94 <= 0 then
            v94 = nil;
        end;

        if v94 then
            _applyBackDoorRootSurfaceGui(p87, v94 + 1, p88.surfaceGuiEnabled == true, p88.surfaceGuiKey, p88.surfaceGuiArgs);
        end;
    end;

    local v95 = p88.isRed == true;
    _setAllDoorBeamsEnabled(p87, false);
    _setBeamsInFolderEnabled(p87:FindFirstChild(v95 and "红" or "绿", true), true);
end;

local function _getWalkRangeBounds() -- Line: 663
    -- upvalues: u3 (ref)
    if u3 <= 0 then
        return 1, 1;
    end;

    return u3, u3 + 1;
end;

local function _isStageInWalkRange(p96) -- Line: 676
    -- upvalues: u3 (ref)
    local v97, v98;

    if u3 <= 0 then
        v97 = 1;
        v98 = 1;
    else
        v97 = u3;
        v98 = u3 + 1;
    end;

    local v99;

    if v97 <= p96 then
        v99 = p96 <= v98;
    else
        v99 = false;
    end;

    return v99;
end;

local function _isJumpOpenStage(p100) -- Line: 687
    -- upvalues: u4 (ref)
    local v101;

    if u4 > 0 then
        v101 = p100 <= u4;
    else
        v101 = false;
    end;

    return v101;
end;

local function _isFrontDoorBlocked(p102) -- Line: 697
    -- upvalues: u4 (ref), u3 (ref)
    local v103;

    if u4 > 0 then
        v103 = p102 <= u4;
    else
        v103 = false;
    end;

    if v103 then
        return false;
    end;

    return p102 < u3 and true or (u3 + 1 < p102 and true or p102 == u3 and u3 >= 2);
end;

local function _isFrontDoorRootStageGuiVisible(p104) -- Line: 720
    -- upvalues: u3 (ref)
    return u3 >= p104 - 1;
end;

local function _computeFrontDoorConfig(p105) -- Line: 730
    -- upvalues: u3 (ref), u4 (ref)
    local v106 = u3 >= p105 - 1;
    local v107;

    if u4 > 0 then
        v107 = p105 <= u4;
    else
        v107 = false;
    end;

    local v108;

    if v107 then
        v108 = false;
    else
        v108 = p105 < u3 and true or (u3 + 1 < p105 and true or p105 == u3 and u3 >= 2);
    end;

    return v108 and {
        visible = true,
        isRed = true,
        canCollide = true,
        noReturnGuiEnabled = true,
        rootStageGuiEnabled = v106
    } or {
        visible = true,
        isRed = false,
        canCollide = false,
        noReturnGuiEnabled = false,
        rootStageGuiEnabled = v106
    };
end;

local function _computeBackDoorConfig(p109) -- Line: 759
    -- upvalues: u4 (ref), u3 (ref)
    local v110 = {
        visible = true,
        isRed = true,
        canCollide = true,
        surfaceGuiEnabled = false
    };
    local v111;

    if u4 > 0 then
        v111 = p109 <= u4;
    else
        v111 = false;
    end;

    if v111 then
        return {
            visible = true,
            isRed = false,
            canCollide = false,
            surfaceGuiEnabled = false
        };
    end;

    if p109 <= u3 and u3 > 0 then
        return {
            visible = false,
            canCollide = false,
            surfaceGuiEnabled = false
        };
    end;

    local v112, v113;

    if u3 <= 0 then
        v112 = 1;
        v113 = 1;
    else
        v112 = u3;
        v113 = u3 + 1;
    end;

    local v114;

    if v112 <= p109 then
        v114 = p109 <= v113;
    else
        v114 = false;
    end;

    return v114 and (p109 == u3 + 1 and {
        visible = true,
        isRed = true,
        canCollide = true,
        surfaceGuiEnabled = true,
        surfaceGuiKey = "击败敌人"
    } or {
        visible = false,
        canCollide = false,
        surfaceGuiEnabled = false
    }) or v110;
end;

local function _findStageRespawnCountdownGui(p115) -- Line: 815
    -- upvalues: CollectionService (copy)
    for _, v in CollectionService:GetTagged("DungeonRespawnCountdown") do
        if v:IsA("BasePart") and tonumber(v:GetAttribute("Stage")) == p115 then
            local v116 = v:FindFirstChildWhichIsA("BillboardGui");

            if v116 then
                return v116, v116:FindFirstChildWhichIsA("TextLabel", true);
            end;

            return nil, nil;
        end;
    end;

    return nil, nil;
end;

local function _applyStageRespawnCountdown(p117) -- Line: 841
    -- upvalues: _findStageRespawnCountdownGui (copy), u3 (ref), u8 (copy), u7 (copy), TranslationHelper (copy)
    local v118, v119 = _findStageRespawnCountdownGui(p117);

    if not v118 then
        return;
    end;

    local v120, v121;

    if p117 == u3 and (u3 > 0 and not u8[p117]) then
        local v122 = u7[p117];

        if v122 and v122 > 0 then
            local v123 = v122 - workspace:GetServerTimeNow();
            local v124 = math.ceil(v123);
            v120 = math.max(0, v124);
        else
            v120 = nil;
        end;

        if v120 == nil then
            v121 = false;
        else
            v121 = true;
        end;
    else
        v121 = false;
        v120 = nil;
    end;

    v118.Enabled = v121;

    if v121 and (v119 and v120 ~= nil) then
        TranslationHelper.SetText(v119, "怪物刷新倒计时", { v120 });
    end;
end;

local function _refreshAllRespawnCountdowns() -- Line: 865
    -- upvalues: CollectionService (copy), u3 (ref), _applyStageRespawnCountdown (copy)
    local v125 = {};

    for _, v in CollectionService:GetTagged("DungeonRespawnCountdown") do
        if v:IsA("BasePart") then
            local v126 = tonumber(v:GetAttribute("Stage"));

            if v126 then
                v125[v126] = true;
            end;
        end;
    end;

    if u3 > 0 then
        v125[u3] = true;
    end;

    for i in v125 do
        _applyStageRespawnCountdown(i);
    end;
end;

local function _applyStageDoorState(p127) -- Line: 892
    -- upvalues: CollectionService (copy), _applyDoorVisual (copy), _computeFrontDoorConfig (copy), _computeBackDoorConfig (copy), _applyStageRespawnCountdown (copy)
    for _, v in CollectionService:GetTagged("DungeonFrontDoor") do
        if v:IsA("Model") then
            local v128 = tonumber(v:GetAttribute("Stage"));

            if not v128 or v128 <= 0 then
                v128 = nil;
            end;

            if v128 == p127 then
                _applyDoorVisual(v, _computeFrontDoorConfig(p127), true);
            end;
        end;
    end;

    for _, v in CollectionService:GetTagged("DungeonBackDoor") do
        if v:IsA("Model") then
            local v129 = tonumber(v:GetAttribute("Stage"));

            if not v129 or v129 <= 0 then
                v129 = nil;
            end;

            if v129 == p127 then
                _applyDoorVisual(v, _computeBackDoorConfig(p127), false);
            end;
        end;
    end;

    _applyStageRespawnCountdown(p127);
end;

local function _refreshAllStageDoors() -- Line: 913
    -- upvalues: CollectionService (copy), _applyStageDoorState (copy), _refreshAllRespawnCountdowns (copy)
    local v130 = {};

    for _, v in CollectionService:GetTagged("DungeonFrontDoor") do
        if v:IsA("Model") then
            local v131 = tonumber(v:GetAttribute("Stage"));

            if not v131 or v131 <= 0 then
                v131 = nil;
            end;

            if v131 then
                v130[v131] = true;
            end;
        end;
    end;

    for _, v in CollectionService:GetTagged("DungeonBackDoor") do
        if v:IsA("Model") then
            local v132 = tonumber(v:GetAttribute("Stage"));

            if not v132 or v132 <= 0 then
                v132 = nil;
            end;

            if v132 then
                v130[v132] = true;
            end;
        end;
    end;

    for i in v130 do
        _applyStageDoorState(i);
    end;

    _refreshAllRespawnCountdowns();
end;

local function _resetDungeonRunVisual() -- Line: 946
    -- upvalues: u3 (ref), u4 (ref), LocalPlayer (copy), u5 (ref), u6 (ref), u7 (copy), u8 (copy), u12 (ref), u13 (ref), _refreshAllStageDoors (copy), _refreshAllRespawnCountdowns (copy), CfgFind (copy), NetWork (copy), NetMsg (copy)
    u3 = 0;
    u4 = 0;
    LocalPlayer:SetAttribute("DungeonJumpOpenThrough", nil);
    u5 = 0;
    u6 = 0;
    table.clear(u7);
    table.clear(u8);

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    if u13 and u13.Parent then
        u13.GroupTransparency = 0;
    end;

    u13 = nil;
    _refreshAllStageDoors();
    _refreshAllRespawnCountdowns();
    local v133;

    if u6 > 0 then
        v133 = u6;
    else
        v133 = u5 <= 0 and 0 or u5;
    end;

    local v134;

    if v133 <= 0 then
        v134 = "世界1";
    else
        local v135 = CfgFind.GetCfgByNameAndID("dungeonConf", v133);

        if type(v135) == "table" then
            v134 = v135.Sky;

            if type(v134) ~= "string" or v134 == "" then
                local v136 = tostring(v134 or "");
                v134 = (v136 == "" or v136 == "nil") and "世界1" or v136;
            end;
        else
            v134 = "世界1";
        end;
    end;

    NetWork.FireBindable(NetMsg.LIGHTING_CHANGE, v134, 2);
end;

local function _onDungeonDoorAdded(p137, p138) -- Line: 966
    -- upvalues: _applyDoorVisual (copy), _computeFrontDoorConfig (copy), _computeBackDoorConfig (copy)
    if not p137:IsA("Model") then
        return;
    end;

    local v139 = tonumber(p137:GetAttribute("Stage"));

    if not v139 or v139 <= 0 then
        v139 = nil;
    end;

    if not v139 then
        return;
    end;

    if p138 then
        _applyDoorVisual(p137, _computeFrontDoorConfig(v139), true);

        return;
    end;

    _applyDoorVisual(p137, _computeBackDoorConfig(v139), false);
end;

local function _onRespawnCountdownPartAdded(p140) -- Line: 1010
    -- upvalues: _applyStageRespawnCountdown (copy)
    if not p140:IsA("BasePart") then
        return;
    end;

    local v141 = tonumber(p140:GetAttribute("Stage"));

    if not v141 then
        return;
    end;

    _applyStageRespawnCountdown(v141);
end;

local function _ensureCountdownLoop() -- Line: 1040
    -- upvalues: u9 (ref), u3 (ref), u7 (copy), _applyStageDoorState (copy), _applyStageRespawnCountdown (copy)
    if u9 then
        return;
    end;

    u9 = true;
    task.spawn(function() -- Line: 1046
        -- upvalues: u9 (ref), u3 (ref), u7 (ref), _applyStageDoorState (ref), _applyStageRespawnCountdown (ref)
        while u9 do
            task.wait(1);

            if u3 > 0 and u7[u3] then
                _applyStageDoorState(u3);
                _applyStageRespawnCountdown(u3);
            end;
        end;
    end);
end;

local function _onStageCleared(p142) -- Line: 1063
    -- upvalues: u3 (ref), u7 (copy), u8 (copy), _refreshAllStageDoors (copy)
    if u3 < p142 then
        for i in u7 do
            if i ~= p142 then
                u7[i] = nil;
            end;
        end;

        for i in u8 do
            if i ~= p142 then
                u8[i] = nil;
            end;
        end;

        u3 = p142;
    end;

    _refreshAllStageDoors();
end;

local function _applyJumpOpenThroughStage(p143) -- Line: 1087
    -- upvalues: u4 (ref), _refreshAllStageDoors (copy)
    local v144 = tonumber(p143) or 0;
    local v145 = math.floor(v144);
    local v146 = math.max(0, v145);

    if v146 == u4 then
        return;
    end;

    u4 = v146;
    _refreshAllStageDoors();
end;

local function _applyRunMaxClearStage(p147) -- Line: 1102
    -- upvalues: u3 (ref), u4 (ref), LocalPlayer (copy), _refreshAllStageDoors (copy)
    local v148 = math.floor(p147);
    u3 = math.max(0, v148);

    if u3 <= 0 and u4 > 0 then
        u4 = 0;
        LocalPlayer:SetAttribute("DungeonJumpOpenThrough", nil);
    end;

    _refreshAllStageDoors();
end;

local function _onRespawnTimerSync(p149, p150) -- Line: 1119
    -- upvalues: u7 (copy), u8 (copy), _refreshAllStageDoors (copy), u3 (ref), u9 (ref), _applyStageDoorState (copy), _applyStageRespawnCountdown (copy)
    if p149 <= 0 then
        table.clear(u7);
        table.clear(u8);
        _refreshAllStageDoors();

        return;
    end;

    if p150 <= 0 then
        u7[p149] = nil;

        if p149 > 0 and (p149 == u3 and u3 > 0) then
            u8[p149] = true;
        end;

        _refreshAllStageDoors();

        return;
    end;

    u8[p149] = nil;

    for i in u7 do
        if i ~= p149 then
            u7[i] = nil;
        end;
    end;

    u7[p149] = p150;
    _refreshAllStageDoors();

    if u9 then
        return;
    end;

    u9 = true;
    task.spawn(function() -- Line: 1046
        -- upvalues: u9 (ref), u3 (ref), u7 (ref), _applyStageDoorState (ref), _applyStageRespawnCountdown (ref)
        while u9 do
            task.wait(1);

            if u3 > 0 and u7[u3] then
                _applyStageDoorState(u3);
                _applyStageRespawnCountdown(u3);
            end;
        end;
    end);
end;

(function() -- Line: 988, Name: _bindDungeonDoorTags
    -- upvalues: CollectionService (copy), _applyDoorVisual (copy), _computeFrontDoorConfig (copy), _computeBackDoorConfig (copy)
    for _, v in CollectionService:GetTagged("DungeonFrontDoor") do
        if v:IsA("Model") then
            local v151 = tonumber(v:GetAttribute("Stage"));

            if not v151 or v151 <= 0 then
                v151 = nil;
            end;

            if v151 then
                _applyDoorVisual(v, _computeFrontDoorConfig(v151), true);
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal("DungeonFrontDoor"):Connect(function(p152) -- Line: 992
        -- upvalues: _applyDoorVisual (ref), _computeFrontDoorConfig (ref)
        if not p152:IsA("Model") then
            return;
        end;

        local v153 = tonumber(p152:GetAttribute("Stage"));

        if not v153 or v153 <= 0 then
            v153 = nil;
        end;

        if not v153 then
            return;
        end;

        _applyDoorVisual(p152, _computeFrontDoorConfig(v153), true);
    end);

    for _, v in CollectionService:GetTagged("DungeonBackDoor") do
        if v:IsA("Model") then
            local v154 = tonumber(v:GetAttribute("Stage"));

            if not v154 or v154 <= 0 then
                v154 = nil;
            end;

            if v154 then
                _applyDoorVisual(v, _computeBackDoorConfig(v154), false);
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal("DungeonBackDoor"):Connect(function(p155) -- Line: 999
        -- upvalues: _applyDoorVisual (ref), _computeBackDoorConfig (ref)
        if not p155:IsA("Model") then
            return;
        end;

        local v156 = tonumber(p155:GetAttribute("Stage"));

        if not v156 or v156 <= 0 then
            v156 = nil;
        end;

        if not v156 then
            return;
        end;

        _applyDoorVisual(p155, _computeBackDoorConfig(v156), false);
    end);
end)();
(function() -- Line: 1028, Name: _bindRespawnCountdownParts
    -- upvalues: CollectionService (copy), _applyStageRespawnCountdown (copy), _onRespawnCountdownPartAdded (copy)
    for _, v in CollectionService:GetTagged("DungeonRespawnCountdown") do
        if v:IsA("BasePart") then
            local v157 = tonumber(v:GetAttribute("Stage"));

            if v157 then
                _applyStageRespawnCountdown(v157);
            end;
        end;
    end;

    CollectionService:GetInstanceAddedSignal("DungeonRespawnCountdown"):Connect(_onRespawnCountdownPartAdded);
end)();
NetWork.RegisterClientRemoteEvent(NetMsg.DUNGEON_STAGE_CLEARED, function(p158) -- Line: 1150
    -- upvalues: _onStageCleared (copy)
    local v159 = tonumber(p158);

    if not v159 or v159 <= 0 then
        return;
    end;

    _onStageCleared(v159);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.DUNGEON_RESPAWN_TIMER, function(p160, p161) -- Line: 1158
    -- upvalues: _onRespawnTimerSync (copy)
    _onRespawnTimerSync(tonumber(p160) or 0, tonumber(p161) or 0);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.DUNGEON_STAGE_SPAWNED, function(p162) -- Line: 1164
    -- upvalues: _applyStageDoorState (copy), u5 (ref), u6 (ref), CfgFind (copy), NetWork (copy), NetMsg (copy)
    local v163 = tonumber(p162);

    if not v163 or v163 <= 0 then
        return;
    end;

    _applyStageDoorState(v163);
    u5 = v163;
    u6 = v163;
    local v164;

    if u6 > 0 then
        v164 = u6;
    else
        v164 = u5 <= 0 and 0 or u5;
    end;

    local v165;

    if v164 <= 0 then
        v165 = "世界1";
    else
        local v166 = CfgFind.GetCfgByNameAndID("dungeonConf", v164);

        if type(v166) == "table" then
            v165 = v166.Sky;

            if type(v165) ~= "string" or v165 == "" then
                local v167 = tostring(v165 or "");
                v165 = (v167 == "" or v167 == "nil") and "世界1" or v167;
            end;
        else
            v165 = "世界1";
        end;
    end;

    NetWork.FireBindable(NetMsg.LIGHTING_CHANGE, v165, 2);
end);
NetWork.RegisterClientRemoteEvent(NetMsg.DUNGEON_STAGE_RESPAWNED, function(p168) -- Line: 1176
    -- upvalues: u8 (copy), u7 (copy), _applyStageDoorState (copy)
    local v169 = tonumber(p168);

    if not v169 or v169 <= 0 then
        return;
    end;

    u8[v169] = true;
    u7[v169] = nil;
    _applyStageDoorState(v169);
end);
local InDungeonChallenge = LocalPlayer:WaitForChild("InDungeonChallenge", (1 / 0));

if InDungeonChallenge.Value > 0 then
    u5 = InDungeonChallenge.Value;
else
    u5 = 0;
end;

AddListen.NumValueAdd(InDungeonChallenge, function(p170) -- Line: 1189
    -- upvalues: u5 (ref), u3 (ref), u4 (ref), LocalPlayer (copy), u6 (ref), u7 (copy), u8 (copy), u12 (ref), u13 (ref), _refreshAllStageDoors (copy), _refreshAllRespawnCountdowns (copy), CfgFind (copy), NetWork (copy), NetMsg (copy), RunService (copy), _updateFrontDoorGuiDistanceFade (copy), Alchemy (copy), TipsModule (copy), TipsConfig (copy)
    local v171 = u5 > 0;
    u5 = p170 <= 0 and 0 or p170;

    if u5 > 0 then
        if not u12 then
            u12 = RunService.Heartbeat:Connect(_updateFrontDoorGuiDistanceFade);
        end;

        local v172;

        if u6 > 0 then
            v172 = u6;
        else
            v172 = u5 <= 0 and 0 or u5;
        end;

        local v173;

        if v172 <= 0 then
            v173 = "世界1";
        else
            local v174 = CfgFind.GetCfgByNameAndID("dungeonConf", v172);

            if type(v174) == "table" then
                v173 = v174.Sky;

                if type(v173) ~= "string" or v173 == "" then
                    local v175 = tostring(v173 or "");
                    v173 = (v175 == "" or v175 == "nil") and "世界1" or v175;
                end;
            else
                v173 = "世界1";
            end;
        end;

        NetWork.FireBindable(NetMsg.LIGHTING_CHANGE, v173, 2);

        if not v171 and Alchemy.GetMarkedRecipeId(LocalPlayer) > 0 then
            TipsModule.RainbowTips(LocalPlayer, "战斗中的配方材料会被标记", nil, nil, TipsConfig.GRADIENT_TIP_YELLOW);
        end;

        return;
    end;

    u3 = 0;
    u4 = 0;
    LocalPlayer:SetAttribute("DungeonJumpOpenThrough", nil);
    u5 = 0;
    u6 = 0;
    table.clear(u7);
    table.clear(u8);

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    if u13 and u13.Parent then
        u13.GroupTransparency = 0;
    end;

    u13 = nil;
    _refreshAllStageDoors();
    _refreshAllRespawnCountdowns();
    local v176;

    if u6 > 0 then
        v176 = u6;
    else
        v176 = u5 <= 0 and 0 or u5;
    end;

    local v177;

    if v176 <= 0 then
        v177 = "世界1";
    else
        local v178 = CfgFind.GetCfgByNameAndID("dungeonConf", v176);

        if type(v178) == "table" then
            v177 = v178.Sky;

            if type(v177) ~= "string" or v177 == "" then
                local v179 = tostring(v177 or "");
                v177 = (v179 == "" or v179 == "nil") and "世界1" or v179;
            end;
        else
            v177 = "世界1";
        end;
    end;

    NetWork.FireBindable(NetMsg.LIGHTING_CHANGE, v177, 2);
end, true);
local DungeonAggroStage = LocalPlayer:WaitForChild("DungeonAggroStage", (1 / 0));
AddListen.NumValueAdd(DungeonAggroStage, function(p180) -- Line: 1211
    -- upvalues: u6 (ref), u5 (ref), CfgFind (copy), NetWork (copy), NetMsg (copy)
    u6 = p180 <= 0 and 0 or p180;
    local v181;

    if u6 > 0 then
        v181 = u6;
    else
        v181 = u5 <= 0 and 0 or u5;
    end;

    local v182;

    if v181 <= 0 then
        v182 = "世界1";
    else
        local v183 = CfgFind.GetCfgByNameAndID("dungeonConf", v181);

        if type(v183) == "table" then
            v182 = v183.Sky;

            if type(v182) ~= "string" or v182 == "" then
                local v184 = tostring(v182 or "");
                v182 = (v184 == "" or v184 == "nil") and "世界1" or v184;
            end;
        else
            v182 = "世界1";
        end;
    end;

    NetWork.FireBindable(NetMsg.LIGHTING_CHANGE, v182, 2);
end, true);
local DungeonRunMaxClear = LocalPlayer:WaitForChild("DungeonRunMaxClear", (1 / 0));
AddListen.NumValueAdd(DungeonRunMaxClear, function(p185) -- Line: 1217
    -- upvalues: u3 (ref), u4 (ref), LocalPlayer (copy), _refreshAllStageDoors (copy)
    local v186 = math.floor(p185);
    u3 = math.max(0, v186);

    if u3 <= 0 and u4 > 0 then
        u4 = 0;
        LocalPlayer:SetAttribute("DungeonJumpOpenThrough", nil);
    end;

    _refreshAllStageDoors();
end, true);
LocalPlayer:GetAttributeChangedSignal("DungeonJumpOpenThrough"):Connect(function() -- Line: 1221
    -- upvalues: LocalPlayer (copy), u4 (ref), _refreshAllStageDoors (copy)
    local v187 = tonumber(LocalPlayer:GetAttribute("DungeonJumpOpenThrough")) or 0;
    local v188 = tonumber(v187) or 0;
    local v189 = math.floor(v188);
    local v190 = math.max(0, v189);

    if v190 == u4 then
        return;
    end;

    u4 = v190;
    _refreshAllStageDoors();
end);
local v191 = tonumber(LocalPlayer:GetAttribute("DungeonJumpOpenThrough")) or 0;
local v192 = tonumber(v191) or 0;
local v193 = math.floor(v192);
local v194 = math.max(0, v193);

if v194 ~= u4 then
    u4 = v194;
    _refreshAllStageDoors();
end;