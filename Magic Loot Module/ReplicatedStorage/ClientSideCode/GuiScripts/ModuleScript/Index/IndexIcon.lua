-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local ShowDetail = UtilsSystem.ShowDetail;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIanima = UtilsSystem.UIanima;
local UIMgr = UtilsSystem.UIMgr;
local ItemID = EnumMgr.ItemID;
local AllUI = require(script.Parent.AllUI);
local List = AllUI.List;
local Temp = List.Temp;
local u1 = AllUI["材料"];
local u2 = AllUI["药水"];
local u3 = u1["红点"];
local u4 = u2["红点"];
local u5 = AllUI.Title["进度"];
local v6 = AllUI["收集进度条"];
local Bar = v6.Bar;
local u7 = Bar:FindFirstChildOfClass("UIGradient");

if not u7 then
    error((`IndexIcon: {Bar:GetFullName()} missing UIGradient`));
end;

local u8 = v6["进度"];
local u9 = v6["绿光"];
local u10 = v6["已领取"];
local u11 = v6["增加容量"];
local u12 = AllUI["奖励图标"];
local u13 = AllUI["奖励数值"];
local u14 = AllUI["可领取"];
local u15 = TweenInfo.new(0.75, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true);
local u16 = {
    Material = UDim2.fromOffset(100, 100),
    Potion = UDim2.fromOffset(80, 80)
};
local u17 = Color3.fromHex("#FFD865");
local u18 = Color3.fromHex("#4594DC");
local u19 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#5ab433")), ColorSequenceKeypoint.new(1, Color3.fromHex("#0c6a15")) });
local u20 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromHex("#C6B317")), ColorSequenceKeypoint.new(1, Color3.fromHex("#8B5800")) });
TranslationHelper.SetText(u10, "已全部领取");
u8.RichText = true;
local u21 = {
    Material = "materialConf",
    Potion = "potionConf"
};
local v22 = {};

local function _getSelectedMark(p23) -- Line: 112
    local v24 = p23:FindFirstChild("已选中");

    if v24 and v24:IsA("GuiObject") then
        return v24;
    end;

    return nil;
end;

local function _clearListSelectedMarks() -- Line: 124
    -- upvalues: List (copy), Temp (copy)
    for _, child in ipairs(List:GetChildren()) do
        if child:IsA("GuiObject") and child ~= Temp then
            local v25 = child:FindFirstChild("已选中");

            if not (v25 and v25:IsA("GuiObject")) then
                v25 = nil;
            end;

            if v25 then
                v25.Visible = false;
            end;
        end;
    end;
end;

List:GetPropertyChangedSignal("CanvasPosition"):Connect(function() -- Line: 139, Name: _onListCanvasPositionChanged
    -- upvalues: ShowDetail (copy), EnumMgr (copy), _clearListSelectedMarks (copy)
    if not ShowDetail.GetDetailVisible(EnumMgr.ItemType.Potion) then
        return;
    end;

    ShowDetail.HideAllDetail();
    _clearListSelectedMarks();
end);

local function _getRewardValueColor(p26) -- Line: 155
    -- upvalues: ItemID (copy), u17 (copy), u18 (copy)
    if p26 == ItemID.LimitBagSize then
        return u17;
    end;

    if p26 == ItemID.ExtraMoveSpeed then
        return u18;
    end;

    return Color3.fromRGB(255, 255, 255);
end;

local function _applyProgressBarVisual(p27) -- Line: 171
    -- upvalues: u7 (copy), u20 (copy), u19 (copy), UIMgr (copy), u9 (copy)
    local v28;

    if p27 then
        v28 = u20;
    else
        v28 = u19;
    end;

    u7.Color = v28;
    UIMgr.SetImage(u9, p27 and "110291336807069" or "92052136888685");
end;

local u29 = (function() -- Line: 186, Name: _getOrCreateClaimMarkScale
    -- upvalues: u14 (copy)
    local ClaimPulseScale = u14:FindFirstChild("ClaimPulseScale");

    if ClaimPulseScale then
        if not ClaimPulseScale:IsA("UIScale") then
            error((`IndexIcon: {u14:GetFullName()}.ClaimPulseScale must be a UIScale`));
        end;

        return ClaimPulseScale;
    end;

    local UIScale = Instance.new("UIScale");
    UIScale.Name = "ClaimPulseScale";
    UIScale.Scale = 1;
    UIScale.Parent = u14;

    return UIScale;
end)();
local u30 = nil;

local function _setClaimMarkVisible(p31, p32) -- Line: 211
    -- upvalues: u14 (copy), u30 (ref), u29 (copy), TweenService (copy), u15 (copy)
    u14.Visible = p31;

    if not p31 then
        if u30 then
            u30:Cancel();
            u30 = nil;
        end;

        u29.Scale = 1;

        return;
    end;

    if u30 and not p32 then
        return;
    end;

    if u30 then
        u30:Cancel();
        u30 = nil;
    end;

    u29.Scale = 1;
    u30 = TweenService:Create(u29, u15, {
        Scale = 1.12
    });
    u30:Play();
end;

local function _drawRow(u33, u34, p35, p36) -- Line: 251
    -- upvalues: TranslationHelper (copy), UIMgr (copy), AddListen (copy), _clearListSelectedMarks (copy), ShowDetail (copy), EnumMgr (copy)
    local cfg = u34.cfg;
    local TextName = u33:FindFirstChild("TextName");
    local BG = u33:FindFirstChild("BG");
    local Icon = u33:FindFirstChild("Icon");

    if not (TextName and (BG and Icon)) then
        error((`IndexIcon: Temp row missing child on {u33:GetFullName()}`));
    end;

    if p35 == false then
        TranslationHelper.SetText_UnTrans(TextName, "???");
    else
        TranslationHelper.SetText(TextName, cfg.ZhName);
    end;

    Icon.Image = "rbxassetid://" .. cfg.Icon;
    Icon.Visible = true;
    local v37;

    if p35 then
        v37 = Color3.fromRGB(255, 255, 255);
    else
        v37 = Color3.fromRGB(0, 0, 0);
    end;

    Icon.ImageColor3 = v37;

    if p36 ~= "Potion" then
        p35 = false;
    end;

    u33.Active = p35;
    u33.Selectable = false;
    u33.AutoButtonColor = false;
    local u38 = u33:FindFirstChild("已选中");

    if not (u38 and u38:IsA("GuiObject")) then
        u38 = nil;
    end;

    if u38 then
        u38.Visible = false;
    end;

    local v39 = tostring(UIMgr.NormalizeXyd(cfg.xyd));
    UIMgr.AddGradientColor(v39, TextName, true, nil, false);

    if p35 then
        AddListen.AddMouseCLick(u33, function() -- Line: 287
            -- upvalues: _clearListSelectedMarks (ref), ShowDetail (ref), u34 (copy), u33 (copy), EnumMgr (ref), u38 (copy)
            _clearListSelectedMarks();
            ShowDetail.ShowDetailByCfgID(u34.id, u33, true);

            if ShowDetail.GetDetailVisible(EnumMgr.ItemType.Potion) and u38 then
                u38.Visible = true;
            end;
        end, nil);
    end;
end;

local function _drawList(p40, p41) -- Line: 304
    -- upvalues: ShowDetail (copy), CfgFind (copy), u21 (copy), UIMgr (copy), List (copy), Temp (copy), _drawRow (copy)
    ShowDetail.HideAllDetail();
    local v42 = CfgFind.GetSortedConfRows(u21[p40]);
    UIMgr.ClearScrollItems(List, {
        keepInstances = { Temp }
    });
    Temp.Visible = false;

    for i, v in ipairs(v42) do
        local v43 = Temp:Clone();
        v43.Name = `Index_{v.id}`;
        v43.LayoutOrder = i;
        v43.Parent = List;
        v43.Visible = true;
        _drawRow(v43, v, p41[v.id] == true, p40);
    end;

    UIMgr.SetUIlistSize(List);
    List.CanvasPosition = Vector2.zero;
end;

local function _drawTabHighlight(p44, p45) -- Line: 331
    p44["选中"].Visible = p45;
    p44["未选中"].Visible = not p45;
end;

local function _drawTabs(p46) -- Line: 342
    -- upvalues: u1 (copy), u2 (copy)
    local v47 = u1;
    local v48 = p46 == "Material";
    v47["选中"].Visible = v48;
    v47["未选中"].Visible = not v48;
    local v49 = u2;
    local v50 = p46 == "Potion";
    v49["选中"].Visible = v50;
    v49["未选中"].Visible = not v50;
end;

local function _setTabRedPointVisible(p51, p52) -- Line: 354
    -- upvalues: UIanima (copy)
    local Visible = p51.Visible;
    p51.Visible = p52;

    if p52 and not Visible then
        UIanima.RedPointScaleAnim(p51);

        return;
    end;

    if not p52 and Visible then
        UIanima.StopRedPointScaleAnim(p51);
    end;
end;

function v22.DrawList(p53, p54) -- Line: 371
    -- upvalues: _drawList (copy)
    _drawList(p53, p54);
end;

local function _formatProgressFraction(p55, p56, p57) -- Line: 383
    if p57 then
        return `<font color='#FF4D4D'>{p55}</font>/{p56}`;
    end;

    return `{p55}/{p56}`;
end;

function v22.DrawTitleProgress(p58) -- Line: 396
    -- upvalues: TranslationHelper (copy), u5 (copy)
    TranslationHelper.SetText(u5, "图鉴顶部收集进度", { p58.unlockCount, p58.totalCount });
end;

function v22.DrawMilestoneProgress(p59, p60, p61) -- Line: 412
    -- upvalues: Bar (copy), u7 (copy), u20 (copy), u19 (copy), UIMgr (copy), u9 (copy), u10 (copy), u8 (copy), u14 (copy), u30 (ref), u29 (copy), _setClaimMarkVisible (copy), TranslationHelper (copy), u11 (copy), u16 (copy), u12 (copy), u13 (copy), ItemID (copy), u17 (copy), u18 (copy)
    Bar.Size = UDim2.new(p60.allClaimed and 1 or p60.barRatio, 0, Bar.Size.Y.Scale, Bar.Size.Y.Offset);
    local v62 = p60.canClaim or p60.allClaimed;
    local v63;

    if v62 then
        v63 = u20;
    else
        v63 = u19;
    end;

    u7.Color = v63;
    UIMgr.SetImage(u9, v62 and "110291336807069" or "92052136888685");

    if p60.allClaimed then
        u10.Visible = true;
        u8.Visible = false;
        u14.Visible = false;

        if u30 then
            u30:Cancel();
            u30 = nil;
        end;

        u29.Scale = 1;
        u9.Visible = false;
    else
        u10.Visible = false;
        u8.Visible = true;
        _setClaimMarkVisible(p60.canClaim, p61);
        u9.Visible = p60.canClaim;

        if p60.canClaim then
            TranslationHelper.SetText(u8, "图鉴里程碑点击领取");
        else
            local SetText = TranslationHelper.SetText;
            local v64 = {};
            local textNumerator = p60.textNumerator;
            local textDenominator = p60.textDenominator;
            local v65;

            if p60.textNumerator < p60.textDenominator then
                v65 = `<font color='#FF4D4D'>{textNumerator}</font>/{textDenominator}`;
            else
                v65 = `{textNumerator}/{textDenominator}`;
            end;

            v64[1] = v65;
            SetText(u8, "图鉴里程碑进度", v64);
        end;
    end;

    u11.Visible = true;
    local v66 = u16[p59];

    if v66 then
        u12.Size = v66;
    end;

    if p60.rewardIcon == "" then
        u12.Image = "";
        u12.Visible = false;
    else
        UIMgr.SetImage(u12, p60.rewardIcon);
        u12.Visible = true;
    end;

    TranslationHelper.SetText_UnTrans(u13, (`+{p60.rewardCount}`));
    local primaryAwardId = p60.primaryAwardId;
    local v67;

    if primaryAwardId == ItemID.LimitBagSize then
        v67 = u17;
    elseif primaryAwardId == ItemID.ExtraMoveSpeed then
        v67 = u18;
    else
        v67 = Color3.fromRGB(255, 255, 255);
    end;

    u13.TextColor3 = v67;
end;

function v22.DrawTabs(p68) -- Line: 471
    -- upvalues: u1 (copy), u2 (copy)
    local v69 = u1;
    local v70 = p68 == "Material";
    v69["选中"].Visible = v70;
    v69["未选中"].Visible = not v70;
    local v71 = u2;
    local v72 = p68 == "Potion";
    v71["选中"].Visible = v72;
    v71["未选中"].Visible = not v72;
end;

function v22.DrawTabRedDots(p73, p74) -- Line: 482
    -- upvalues: u3 (copy), UIanima (copy), u4 (copy)
    local v75 = u3;
    local Visible = v75.Visible;
    v75.Visible = p73;

    if p73 and not Visible then
        UIanima.RedPointScaleAnim(v75);
    elseif not p73 and Visible then
        UIanima.StopRedPointScaleAnim(v75);
    end;

    local v76 = u4;
    local Visible2 = v76.Visible;
    v76.Visible = p74;

    if p74 and not Visible2 then
        UIanima.RedPointScaleAnim(v76);

        return;
    end;

    if not p74 and Visible2 then
        UIanima.StopRedPointScaleAnim(v76);
    end;
end;

function v22.ClearList() -- Line: 492
    -- upvalues: ShowDetail (copy), UIMgr (copy), List (copy), Temp (copy)
    ShowDetail.HideAllDetail();
    UIMgr.ClearScrollItems(List, {
        keepInstances = { Temp }
    });
end;

return v22;