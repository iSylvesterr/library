-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local GetData = UtilsSystem.GetData;
local EnumMgr = UtilsSystem.EnumMgr;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local AllUI = require(script.AllUI);
local UIRoot = AllUI.UIRoot;
local OnlineScroll = AllUI.OnlineScroll;
local Temp = AllUI.Temp;
local ClaimAll = AllUI.ClaimAll;
local u2 = false;
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = 0;
local u7 = 0;
local u8 = 0;
Temp.Visible = false;

local function _calcRebirthScaledAwardCount(p9, p10) -- Line: 70
    -- upvalues: EnumMgr (copy), GetData (copy), LocalPlayer (copy)
    local v11 = tonumber(p10) or 0;
    local v12 = math.max(0, v11);

    if v12 <= 0 then
        return 0;
    end;

    local v13 = tonumber(p9);

    if not v13 then
        return math.floor(v12);
    end;

    local v14;

    if v13 == EnumMgr.ItemID.Coin then
        v14 = GetData.GetGoldAdd(LocalPlayer);
    else
        if v13 ~= EnumMgr.ItemID.Power then
            return math.floor(v12);
        end;

        v14 = GetData.GetRebirthExpAddMul(LocalPlayer);
    end;

    local v15 = (type(v14) ~= "number" or (v14 ~= v14 or v14 <= 0)) and 1 or v14;

    return math.ceil(v12 * v15);
end;

local function _child(p16, p17) -- Line: 99
    local v18 = p16:FindFirstChild(p17);

    if v18 and v18:IsA("GuiObject") then
        return v18;
    end;

    return nil;
end;

local function _getClaimBtnRoot(p19) -- Line: 112
    local Btns = p19:FindFirstChild("Btns");

    if not Btns then
        return nil;
    end;

    local ClaimBtn = Btns:FindFirstChild("ClaimBtn");

    if ClaimBtn and ClaimBtn:IsA("Frame") then
        return ClaimBtn;
    end;

    return nil;
end;

local function _getClaimClickBtn(p20) -- Line: 129
    local Btns = p20:FindFirstChild("Btns");
    local v21;

    if Btns then
        v21 = Btns:FindFirstChild("ClaimBtn");

        if not (v21 and v21:IsA("Frame")) then
            v21 = nil;
        end;
    else
        v21 = nil;
    end;

    if not v21 then
        return nil;
    end;

    local Btn = v21:FindFirstChild("Btn");

    if Btn and Btn:IsA("GuiButton") then
        return Btn;
    end;

    return nil;
end;

local function _estimateOnlineSeconds(p22) -- Line: 146
    -- upvalues: u8 (ref), u7 (ref)
    if p22 then
        p22 = p22.OnlineSeconds;
    end;

    local v23 = tonumber(p22) or 0;

    if u8 <= 0 then
        return v23;
    end;

    local v24 = os.clock() - u8;

    return u7 + math.max(0, v24);
end;

local function _refreshTimeAnchor(p25) -- Line: 159
    -- upvalues: u7 (ref), u8 (ref)
    if p25 then
        p25 = p25.OnlineSeconds;
    end;

    u7 = tonumber(p25) or 0;
    u8 = os.clock();
end;

local function _onlineView(p26) -- Line: 169
    -- upvalues: u8 (ref), u7 (ref)
    local v27 = {};

    if type(p26) == "table" then
        for i, v in pairs(p26) do
            v27[i] = v;
        end;
    end;

    if p26 then
        p26 = p26.OnlineSeconds;
    end;

    local v28 = tonumber(p26) or 0;

    if u8 > 0 then
        local v29 = os.clock() - u8;
        v28 = u7 + math.max(0, v29);
    end;

    v27.OnlineSeconds = v28;

    return v27;
end;

local function _hasLockedUnclaimed(p30) -- Line: 185
    -- upvalues: u8 (ref), u7 (ref), CfgFind (copy)
    local v31;

    if p30 then
        v31 = p30.OnlineSeconds;
    else
        v31 = p30;
    end;

    local v32 = tonumber(v31) or 0;

    if u8 > 0 then
        local v33 = os.clock() - u8;
        v32 = u7 + math.max(0, v33);
    end;

    local v34 = CfgFind.GetOnlineAwardList();

    for _, v in ipairs(v34) do
        local v35 = tonumber(v.id) or 0;

        if v35 > 0 and not CfgFind.IsOnlineTierClaimed(p30, v35) then
            local v36 = tonumber(v.OnlinTime) or 0;
            local v37;

            if p30 then
                v37 = p30[tostring(v35)];
            else
                v37 = p30;
            end;

            local v38;

            if type(v37) == "table" then
                v38 = tonumber(v37.Unlock) == 1;
            else
                v38 = false;
            end;

            if v32 < v36 and not v38 then
                return true;
            end;
        end;
    end;

    return false;
end;

local function _fillSlotCount(p39, p40) -- Line: 208
    -- upvalues: _calcRebirthScaledAwardCount (copy), TranslationHelper (copy), MathMgr (copy)
    local v41 = _calcRebirthScaledAwardCount(tonumber(p40.AwardID) or 0, tonumber(p40.CountID) or 1);
    local Count = p39:FindFirstChild("Count");

    if not (Count and Count:IsA("GuiObject")) then
        Count = nil;
    end;

    if not Count then
        return;
    end;

    if v41 <= 1 then
        Count.Visible = false;

        return;
    end;

    Count.Visible = true;
    TranslationHelper.SetText_UnTrans(Count, "x" .. MathMgr.getNumStr(v41));
end;

local function _fillSlotStatic(p42, p43) -- Line: 230
    -- upvalues: CfgFind (copy), TranslationHelper (copy), UIMgr (copy), _fillSlotCount (copy)
    local v44 = tonumber(p43.AwardID) or 0;
    local v45 = CfgFind.FindCfgByID(v44);
    local Name = p42:FindFirstChild("Name");

    if not (Name and Name:IsA("GuiObject")) then
        Name = nil;
    end;

    if Name and (v45 and v45.ZhName) then
        TranslationHelper.SetText(Name, v45.ZhName);
        local xyd = v45.xyd;

        if xyd then
            UIMgr.AddGradientColor(tostring(xyd), Name, true);
        end;
    end;

    _fillSlotCount(p42, p43);
    UIMgr.ApplyItemIconOrViewport(p42, v44, (tostring(p43.Icon or "")));
end;

local function _refreshSlotState(p46, p47, p48) -- Line: 255
    -- upvalues: _onlineView (copy), CfgFind (copy), TranslationHelper (copy), TimeTransfer (copy)
    local u49 = p46:FindFirstChild("可领取");

    if not (u49 and u49:IsA("GuiObject")) then
        u49 = nil;
    end;

    local u50 = p46:FindFirstChild("已领取");

    if not (u50 and u50:IsA("GuiObject")) then
        u50 = nil;
    end;

    local Btns = p46:FindFirstChild("Btns");
    local u51;

    if Btns then
        u51 = Btns:FindFirstChild("ClaimBtn");

        if not (u51 and u51:IsA("Frame")) then
            u51 = nil;
        end;
    else
        u51 = nil;
    end;

    local u52;

    if u51 then
        u52 = u51:FindFirstChild("Bg");
    else
        u52 = nil;
    end;

    local u53;

    if u51 then
        u53 = u51:FindFirstChild("UnBg");
    else
        u53 = nil;
    end;

    local v54;

    if u53 and u53:IsA("GuiObject") then
        v54 = u53:FindFirstChild("Text");
    else
        v54 = nil;
    end;

    local v55 = _onlineView(p48);
    local v56 = tonumber(p47.id) or 0;
    local v57 = CfgFind.IsOnlineTierClaimed(p48, v56);
    local v58 = CfgFind.IsOnlineTierClaimable(v55, p47);

    local function _setClaimVisual(p59, p60, p61, p62) -- Line: 268
        -- upvalues: u49 (copy), u50 (copy), u51 (copy), u52 (copy), u53 (copy)
        if u49 then
            u49.Visible = p59;
        end;

        if u50 then
            u50.Visible = p60;
        end;

        if u51 then
            u51.Visible = p62;
        end;

        if u52 and u52:IsA("GuiObject") then
            u52.Visible = p61;
        end;

        if u53 and u53:IsA("GuiObject") then
            u53.Visible = not p61;
        end;
    end;

    if v57 then
        if u49 then
            u49.Visible = false;
        end;

        if u50 then
            u50.Visible = true;
        end;

        if u51 then
            u51.Visible = false;
        end;

        if u52 and u52:IsA("GuiObject") then
            u52.Visible = false;
        end;

        if u53 and u53:IsA("GuiObject") then
            u53.Visible = true;
        end;

        return;
    end;

    if v58 then
        if u49 then
            u49.Visible = true;
        end;

        if u50 then
            u50.Visible = false;
        end;

        if u51 then
            u51.Visible = true;
        end;

        if u52 and u52:IsA("GuiObject") then
            u52.Visible = true;
        end;

        if u53 and u53:IsA("GuiObject") then
            u53.Visible = false;
        end;

        return;
    end;

    if u49 then
        u49.Visible = false;
    end;

    if u50 then
        u50.Visible = false;
    end;

    if u51 then
        u51.Visible = true;
    end;

    if u52 and u52:IsA("GuiObject") then
        u52.Visible = false;
    end;

    if u53 and u53:IsA("GuiObject") then
        u53.Visible = true;
    end;

    if v54 and v54:IsA("TextLabel") then
        local v63 = (tonumber(p47.OnlinTime) or 0) - (tonumber(v55.OnlineSeconds) or 0);
        local v64 = math.max(0, v63);
        TranslationHelper.SetText_UnTrans(v54, TimeTransfer.FormatTimeS(v64));
    end;
end;

local function _refreshClaimAllBtn(p65) -- Line: 310
    -- upvalues: ClaimAll (copy), _hasLockedUnclaimed (copy), CfgFind (copy), UIMgr (copy)
    if not ClaimAll then
        return;
    end;

    local v66 = _hasLockedUnclaimed(p65) and CfgFind.FindCfgByOnlyTag("OnlineAwardClaimAll") ~= nil;
    ClaimAll.Visible = v66;

    if v66 then
        UIMgr.SetRobuxBuyBtnPrice(ClaimAll, "OnlineAwardClaimAll");
    end;
end;

local function _onClaimClick(p67, p68) -- Line: 327
    -- upvalues: PlayerData (copy), LocalPlayer (copy), CfgFind (copy), _onlineView (copy), u3 (ref), NetWork (copy), NetMsg (copy), u7 (ref), u8 (ref), OnlineScroll (copy), _refreshSlotState (copy), ClaimAll (copy), _hasLockedUnclaimed (copy), UIMgr (copy)
    local v69 = PlayerData.GetPlrDataByKey(LocalPlayer, "OnlineBox");
    local v70 = CfgFind.GetOnlineAward(p67);

    if not v70 then
        return;
    end;

    v70.id = p67;

    if not CfgFind.IsOnlineTierClaimable(_onlineView(v69), v70) then
        return;
    end;

    if u3 then
        return;
    end;

    u3 = true;
    local v71 = NetWork.InvokeServer(NetMsg.CLAIM_ONLINE_AWARD, p67);
    u3 = false;

    if v71 then
        local v72 = PlayerData.GetPlrDataByKey(LocalPlayer, "OnlineBox");
        local v73;

        if v72 then
            v73 = v72.OnlineSeconds;
        else
            v73 = v72;
        end;

        u7 = tonumber(v73) or 0;
        u8 = os.clock();
        local v74 = CfgFind.GetOnlineAwardList();

        for _, v in ipairs(v74) do
            local v75 = tonumber(v.id) or 0;
            local v76 = OnlineScroll:FindFirstChild((tostring(v75)));

            if v76 and v76:IsA("GuiObject") then
                _refreshSlotState(v76, v, v72);
            end;
        end;

        if not ClaimAll then
            return;
        end;

        local v77 = _hasLockedUnclaimed(v72) and CfgFind.FindCfgByOnlyTag("OnlineAwardClaimAll") ~= nil;
        ClaimAll.Visible = v77;

        if v77 then
            UIMgr.SetRobuxBuyBtnPrice(ClaimAll, "OnlineAwardClaimAll");
        end;
    end;
end;

local function _bindClaimClick(u78, u79) -- Line: 365
    -- upvalues: Log (copy), AddListen (copy), _onClaimClick (copy)
    local Btns = u78:FindFirstChild("Btns");
    local v80;

    if Btns then
        v80 = Btns:FindFirstChild("ClaimBtn");

        if not (v80 and v80:IsA("Frame")) then
            v80 = nil;
        end;
    else
        v80 = nil;
    end;

    local v81;

    if v80 then
        v81 = v80:FindFirstChild("Btn");

        if not (v81 and v81:IsA("GuiButton")) then
            v81 = nil;
        end;
    else
        v81 = nil;
    end;

    if v81 then
        AddListen.AddMouseCLick(v81, function() -- Line: 371
            -- upvalues: _onClaimClick (ref), u79 (copy), u78 (copy)
            _onClaimClick(u79, u78);
        end, v81);

        return;
    end;

    Log.warn("[OnlineAward] ClaimBtn.Btn 缺失", u79);
end;

local function _buildList() -- Line: 380
    -- upvalues: u2 (ref), UIMgr (copy), OnlineScroll (copy), Temp (copy), CfgFind (copy), _fillSlotStatic (copy), _bindClaimClick (copy)
    if u2 then
        return;
    end;

    u2 = true;
    UIMgr.ClearScrollItems(OnlineScroll, {
        keepInstances = { Temp }
    });
    local v82 = CfgFind.GetOnlineAwardList();

    for _, v in ipairs(v82) do
        local v83 = tonumber(v.id) or 0;

        if v83 > 0 then
            local v84 = Temp:Clone();
            v84.Name = tostring(v83);
            v84.LayoutOrder = v83;
            v84.Visible = true;
            v84.Parent = OnlineScroll;
            _fillSlotStatic(v84, v);
            _bindClaimClick(v84, v83);
        end;
    end;

    UIMgr.SetUIlistSize(OnlineScroll);
end;

local function _refreshAll() -- Line: 409
    -- upvalues: PlayerData (copy), LocalPlayer (copy), CfgFind (copy), OnlineScroll (copy), _fillSlotCount (copy), _refreshSlotState (copy), ClaimAll (copy), _hasLockedUnclaimed (copy), UIMgr (copy)
    local v85 = PlayerData.GetPlrDataByKey(LocalPlayer, "OnlineBox");
    local v86 = CfgFind.GetOnlineAwardList();

    for _, v in ipairs(v86) do
        local v87 = tonumber(v.id) or 0;
        local v88 = OnlineScroll:FindFirstChild((tostring(v87)));

        if v88 and v88:IsA("GuiObject") then
            _fillSlotCount(v88, v);
            _refreshSlotState(v88, v, v85);
        end;
    end;

    if not ClaimAll then
        return;
    end;

    local v89 = _hasLockedUnclaimed(v85) and CfgFind.FindCfgByOnlyTag("OnlineAwardClaimAll") ~= nil;
    ClaimAll.Visible = v89;

    if v89 then
        UIMgr.SetRobuxBuyBtnPrice(ClaimAll, "OnlineAwardClaimAll");
    end;
end;

local function _ensureRebirthListen() -- Line: 427
    -- upvalues: u5 (ref), LocalPlayer (copy), UIRoot (copy), _refreshAll (copy), AddListen (copy)
    if u5 then
        return;
    end;

    u5 = true;
    task.spawn(function() -- Line: 432
        -- upvalues: LocalPlayer (ref), UIRoot (ref), _refreshAll (ref), AddListen (ref)
        local RebirthBonus = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0));

        local function onBonusChanged() -- Line: 434
            -- upvalues: UIRoot (ref), _refreshAll (ref)
            if UIRoot.Visible then
                _refreshAll();
            end;
        end;

        local ExpAdd = RebirthBonus:WaitForChild("ExpAdd", (1 / 0));

        if ExpAdd:IsA("NumberValue") then
            AddListen.NumValueAdd(ExpAdd, onBonusChanged, false);
        end;

        local GoldAdd = RebirthBonus:WaitForChild("GoldAdd", (1 / 0));

        if GoldAdd:IsA("NumberValue") then
            AddListen.NumValueAdd(GoldAdd, onBonusChanged, false);
        end;
    end);
end;

local function _startCountdownLoop() -- Line: 454
    -- upvalues: u6 (ref), UIRoot (copy), _refreshAll (copy)
    u6 = u6 + 1;
    local u90 = u6;
    task.spawn(function() -- Line: 457
        -- upvalues: u90 (copy), u6 (ref), UIRoot (ref), _refreshAll (ref)
        while u90 == u6 and UIRoot.Visible do
            _refreshAll();
            task.wait(1);
        end;
    end);
end;

function v1.updateUi(p91, p92) -- Line: 470
    -- upvalues: _buildList (copy), u5 (ref), LocalPlayer (copy), UIRoot (copy), _refreshAll (copy), AddListen (copy), PlayerData (copy), u7 (ref), u8 (ref)
    _buildList();

    if not u5 then
        u5 = true;
        task.spawn(function() -- Line: 432
            -- upvalues: LocalPlayer (ref), UIRoot (ref), _refreshAll (ref), AddListen (ref)
            local RebirthBonus = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0));

            local function v93() -- Line: 434
                -- upvalues: UIRoot (ref), _refreshAll (ref)
                if UIRoot.Visible then
                    _refreshAll();
                end;
            end;

            local ExpAdd = RebirthBonus:WaitForChild("ExpAdd", (1 / 0));

            if ExpAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(ExpAdd, v93, false);
            end;

            local GoldAdd = RebirthBonus:WaitForChild("GoldAdd", (1 / 0));

            if GoldAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(GoldAdd, v93, false);
            end;
        end);
    end;

    local v94 = PlayerData.GetPlrDataByKey(LocalPlayer, "OnlineBox");

    if v94 then
        v94 = v94.OnlineSeconds;
    end;

    u7 = tonumber(v94) or 0;
    u8 = os.clock();
    _refreshAll();
end;

function v1.openUi(p95) -- Line: 481
    -- upvalues: UIMgr (copy), UIRoot (copy), _buildList (copy), u5 (ref), LocalPlayer (copy), _refreshAll (copy), AddListen (copy), PlayerData (copy), u7 (ref), u8 (ref), u6 (ref), u4 (ref)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();
    _buildList();

    if not u5 then
        u5 = true;
        task.spawn(function() -- Line: 432
            -- upvalues: LocalPlayer (ref), UIRoot (ref), _refreshAll (ref), AddListen (ref)
            local RebirthBonus = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0));

            local function v96() -- Line: 434
                -- upvalues: UIRoot (ref), _refreshAll (ref)
                if UIRoot.Visible then
                    _refreshAll();
                end;
            end;

            local ExpAdd = RebirthBonus:WaitForChild("ExpAdd", (1 / 0));

            if ExpAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(ExpAdd, v96, false);
            end;

            local GoldAdd = RebirthBonus:WaitForChild("GoldAdd", (1 / 0));

            if GoldAdd:IsA("NumberValue") then
                AddListen.NumValueAdd(GoldAdd, v96, false);
            end;
        end);
    end;

    local v97 = PlayerData.GetPlrDataByKey(LocalPlayer, "OnlineBox");

    if v97 then
        v97 = v97.OnlineSeconds;
    end;

    u7 = tonumber(v97) or 0;
    u8 = os.clock();
    _refreshAll();
    u6 = u6 + 1;
    local u98 = u6;
    task.spawn(function() -- Line: 457
        -- upvalues: u98 (copy), u6 (ref), UIRoot (ref), _refreshAll (ref)
        while u98 == u6 and UIRoot.Visible do
            _refreshAll();
            task.wait(1);
        end;
    end);

    if not u4 then
        u4 = true;
        PlayerData.ListenClientSync(function(p99, p100) -- Line: 493
            -- upvalues: UIRoot (ref), PlayerData (ref), LocalPlayer (ref), u7 (ref), u8 (ref), _refreshAll (ref)
            if not UIRoot.Visible then
                return;
            end;

            if type(p99) == "table" then
                p99 = p99[1];
            end;

            if p99 == nil or p99 == "OnlineBox" then
                local v101 = PlayerData.GetPlrDataByKey(LocalPlayer, "OnlineBox");

                if v101 then
                    v101 = v101.OnlineSeconds;
                end;

                u7 = tonumber(v101) or 0;
                u8 = os.clock();
                _refreshAll();
            end;
        end);
    end;
end;

function v1.closeUi(p102) -- Line: 512
    -- upvalues: u6 (ref), UIRoot (copy), UIMgr (copy)
    u6 = u6 + 1;
    UIRoot.Visible = false;
    UIMgr.SetMainUIVisible(nil);
    UIMgr.UpdateBlurVisible();
end;

local v103 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v103 then
    AddListen.AddMouseCLick(v103, function() -- Line: 521
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "OnlineAward", nil, false, true);
    end, AllUI.Exit);
else
    Log.warn("[OnlineAward] Exit 按钮缺失");
end;

local v104 = UIMgr.FindButtonInFrame(ClaimAll);

if v104 then
    AddListen.AddMouseCLick(v104, function() -- Line: 530
        -- upvalues: PlayerData (copy), LocalPlayer (copy), _hasLockedUnclaimed (copy), SystemBuyRoblox (copy)
        if not _hasLockedUnclaimed((PlayerData.GetPlrDataByKey(LocalPlayer, "OnlineBox"))) then
            return;
        end;

        SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, "OnlineAwardClaimAll");
    end, ClaimAll);
else
    Log.warn("[OnlineAward] ClaimAll 按钮缺失");
end;

return v1;