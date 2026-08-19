-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.AllUI);
local EventShopTab = require(script.EventShopTab);
local EventHatchTab = require(script.EventHatchTab);
local EventBuyTab = require(script.EventBuyTab);
local EventTaskTab = require(script.EventTaskTab);
local UIRoot = AllUI.UIRoot;
local u2 = { "Shop", "Hatch", "Buy", "Task" };
local u3 = {
    Shop = "商店",
    Hatch = "抽奖",
    Buy = "付费",
    Task = "任务"
};
local u4 = {
    Shop = "活动商店",
    Hatch = "活动抽奖",
    Buy = "活动付费",
    Task = "活动任务"
};
local u5 = Color3.fromHex("EEEEEE");
local u6 = Color3.fromHex("ffffff");
local u7 = "Shop";
local u8 = false;
local u9 = {};
local u10 = false;
local u11 = 0;

local function _refreshEndTime() -- Line: 80
    -- upvalues: CfgFind (copy), TranslationHelper (copy), AllUI (copy), TimeTransfer (copy)
    local v12 = CfgFind.GetActiveEventCfg();
    local v13 = v12 and tonumber(v12.EndTime) or 0;

    if v13 <= 0 then
        TranslationHelper.SetText(AllUI.EndTime, "活动已结束");

        return;
    end;

    local v14 = workspace:GetServerTimeNow();
    local v15 = v13 - math.floor(v14);
    local v16 = math.max(0, v15);

    if v16 <= 0 then
        TranslationHelper.SetText(AllUI.EndTime, "活动已结束");

        return;
    end;

    local v17 = TimeTransfer.FormatTimeS(v16);

    if v17 == "" then
        TranslationHelper.SetText(AllUI.EndTime, "活动已结束");

        return;
    end;

    TranslationHelper.SetText(AllUI.EndTime, "活动结束倒计时", { v17 });
end;

local function _startEndTimeLoop() -- Line: 103
    -- upvalues: u11 (ref), _refreshEndTime (copy), UIRoot (copy)
    u11 = u11 + 1;
    local u18 = u11;
    _refreshEndTime();
    task.spawn(function() -- Line: 107
        -- upvalues: u18 (copy), u11 (ref), UIRoot (ref), _refreshEndTime (ref)
        while u18 == u11 and UIRoot.Visible do
            task.wait(1);

            if u18 ~= u11 or not UIRoot.Visible then
                return;
            end;

            _refreshEndTime();
        end;
    end);
end;

local function _refreshMoneyShow() -- Line: 121
    -- upvalues: u7 (ref), EnumMgr (copy), CfgFind (copy), GetData (copy), AllUI (copy), UIMgr (copy), TranslationHelper (copy), MathMgr (copy), u6 (copy), u5 (copy)
    local v19;

    if u7 == "Hatch" then
        v19 = EnumMgr.ItemID.EventTicket;
    else
        v19 = CfgFind.GetEventCurrencyItemId();
    end;

    local v20 = GetData.GetItemCountByIDOnClient(v19) or 0;
    local Icon = AllUI.MoneyShow:FindFirstChild("Icon");
    local Num = AllUI.MoneyShow:FindFirstChild("Num");
    local v21 = CfgFind.FindCfgByID(v19);

    if Icon and Icon:IsA("ImageLabel") then
        local v22 = v21 and tostring(v21.Icon or "") or "";

        if v22 ~= "" and v22 ~= "0" then
            UIMgr.SetImage(Icon, v22);
            Icon.Visible = true;
        end;
    end;

    if Num and Num:IsA("TextLabel") then
        TranslationHelper.SetText_UnTrans(Num, MathMgr.getNumStr(v20));

        if u7 == "Hatch" then
            Num.TextColor3 = u6;

            return;
        end;

        Num.TextColor3 = u5;
    end;
end;

local function _setTabRedDot(p23, p24) -- Line: 149
    -- upvalues: u9 (copy)
    local v25 = u9[p23];

    if not v25 then
        return;
    end;

    local v26 = v25:FindFirstChild("红点");

    if not (v26 and v26:IsA("GuiObject")) then
        return;
    end;

    v26.Visible = p24;
end;

local function _refreshHatchRedDot() -- Line: 164
    -- upvalues: GetData (copy), EnumMgr (copy), u9 (copy)
    local v27 = (GetData.GetItemCountByIDOnClient(EnumMgr.ItemID.EventTicket) or 0) >= 1;
    local Hatch = u9.Hatch;

    if not Hatch then
        return;
    end;

    local v28 = Hatch:FindFirstChild("红点");

    if v28 then
        if not v28:IsA("GuiObject") then
            return;
        end;

        v28.Visible = v27;
    end;
end;

local function _refreshTaskRedDot() -- Line: 172
    -- upvalues: EventTaskTab (copy), u9 (copy)
    local v29 = EventTaskTab.HasClaimable();
    local Task = u9.Task;

    if not Task then
        return;
    end;

    local v30 = Task:FindFirstChild("红点");

    if v30 then
        if not v30:IsA("GuiObject") then
            return;
        end;

        v30.Visible = v29;
    end;
end;

local function _refreshTabSelection() -- Line: 179
    -- upvalues: u9 (copy), u7 (ref)
    for i, v in pairs(u9) do
        local v31 = i == u7;
        local ChooseBg = v:FindFirstChild("ChooseBg");
        local Bg = v:FindFirstChild("Bg");

        if ChooseBg and ChooseBg:IsA("GuiObject") then
            ChooseBg.Visible = v31;
        end;

        if Bg and Bg:IsA("GuiObject") then
            Bg.Visible = not v31;
        end;
    end;
end;

local function _applyTabContent(p32) -- Line: 197
    -- upvalues: AllUI (copy), u7 (ref), TranslationHelper (copy), u4 (copy), EventHatchTab (copy), EventTaskTab (copy), EventShopTab (copy), EventBuyTab (copy), _refreshMoneyShow (copy), GetData (copy), EnumMgr (copy), u9 (copy)
    local Visible = AllUI.Hatch.Visible;
    AllUI.Shop.Visible = u7 == "Shop";
    AllUI.Hatch.Visible = u7 == "Hatch";
    AllUI.Buy.Visible = u7 == "Buy";
    AllUI.Task.Visible = u7 == "Task";
    TranslationHelper.SetText(AllUI.CurTitle, u4[u7] or "活动商店");

    if Visible and u7 ~= "Hatch" then
        EventHatchTab.AbortGlowAndFlushResult();
    end;

    if u7 == "Shop" then
        EventHatchTab.StopProgressLoop();
        EventTaskTab.StopTitleLoop();

        if p32 then
            EventShopTab.Refresh();
        else
            EventShopTab.RefreshStates();
        end;
    elseif u7 == "Hatch" then
        EventTaskTab.StopTitleLoop();

        if p32 then
            EventHatchTab.Refresh();
        else
            EventHatchTab.RefreshStates();
            EventHatchTab.StartProgressLoop();
        end;
    elseif u7 == "Buy" then
        EventHatchTab.StopProgressLoop();
        EventTaskTab.StopTitleLoop();

        if p32 then
            EventBuyTab.Refresh();
        else
            EventBuyTab.RefreshStates();
        end;
    elseif u7 == "Task" then
        EventHatchTab.StopProgressLoop();

        if p32 then
            EventTaskTab.Refresh();
        else
            EventTaskTab.RefreshStates();
            EventTaskTab.StartTitleLoop();
        end;
    else
        EventHatchTab.StopProgressLoop();
        EventTaskTab.StopTitleLoop();
    end;

    _refreshMoneyShow();
    local v33 = (GetData.GetItemCountByIDOnClient(EnumMgr.ItemID.EventTicket) or 0) >= 1;
    local Hatch = u9.Hatch;

    if Hatch then
        local v34 = Hatch:FindFirstChild("红点");

        if v34 and v34:IsA("GuiObject") then
            v34.Visible = v33;
        end;
    end;

    local v35 = EventTaskTab.HasClaimable();
    local Task = u9.Task;

    if not Task then
        return;
    end;

    local v36 = Task:FindFirstChild("红点");

    if v36 then
        if not v36:IsA("GuiObject") then
            return;
        end;

        v36.Visible = v35;
    end;
end;

local function _switchTab(p37) -- Line: 256
    -- upvalues: u7 (ref), _refreshTabSelection (copy), _applyTabContent (copy)
    if u7 == p37 then
        return;
    end;

    u7 = p37;
    _refreshTabSelection();
    _applyTabContent(true);
end;

local function _buildTabs() -- Line: 268
    -- upvalues: u8 (ref), AllUI (copy), u2 (copy), TranslationHelper (copy), u3 (copy), u9 (copy), UIMgr (copy), AddListen (copy), u7 (ref), _refreshTabSelection (copy), _applyTabContent (copy)
    if u8 then
        return;
    end;

    u8 = true;
    AllUI.TabTemp.Visible = false;

    for _, child in ipairs(AllUI.Tab:GetChildren()) do
        if child ~= AllUI.TabTemp and (child:IsA("GuiObject") and not (child:IsA("UIListLayout") or child:IsA("UIPadding"))) then
            child:Destroy();
        end;
    end;

    for i, v in ipairs(u2) do
        local v38 = AllUI.TabTemp:Clone();
        v38.Name = "Tab_" .. v;
        v38.Visible = true;
        v38.LayoutOrder = i;
        v38.Parent = AllUI.Tab;
        local TabName = v38:FindFirstChild("TabName");

        if TabName and TabName:IsA("TextLabel") then
            TranslationHelper.SetText(TabName, u3[v] or v);
        end;

        local v39 = v38:FindFirstChild("红点");

        if v39 and v39:IsA("GuiObject") then
            v39.Visible = false;
        end;

        u9[v] = v38;
        local v40 = UIMgr.FindButtonInFrame(v38);

        if v40 then
            AddListen.AddMouseCLick(v40, function() -- Line: 300
                -- upvalues: v (copy), u7 (ref), _refreshTabSelection (ref), _applyTabContent (ref)
                local v41 = v;

                if u7 == v41 then
                    return;
                end;

                u7 = v41;
                _refreshTabSelection();
                _applyTabContent(true);
            end, v38);
        elseif v38:IsA("GuiButton") then
            AddListen.AddMouseCLick(v38, function() -- Line: 305
                -- upvalues: v (copy), u7 (ref), _refreshTabSelection (ref), _applyTabContent (ref)
                local v42 = v;

                if u7 == v42 then
                    return;
                end;

                u7 = v42;
                _refreshTabSelection();
                _applyTabContent(true);
            end, v38);
        end;
    end;

    _refreshTabSelection();
end;

local function _normalizeTab(p43) -- Line: 320
    -- upvalues: u3 (copy)
    if type(p43) == "table" then
        p43 = p43.Tab or p43.tab;
    end;

    if type(p43) ~= "string" or p43 == "" then
        return nil;
    end;

    if u3[p43] then
        return p43;
    end;

    return nil;
end;

local function _ensureListeners() -- Line: 337
    -- upvalues: u10 (ref), UIMgr (copy), AllUI (copy), AddListen (copy), NetWork (copy), NetMsg (copy), PlayerData (copy), UIRoot (copy), _refreshMoneyShow (copy), GetData (copy), EnumMgr (copy), u9 (copy), EventTaskTab (copy), u7 (ref), EventHatchTab (copy), EventShopTab (copy)
    if u10 then
        return;
    end;

    u10 = true;
    local v44 = UIMgr.FindButtonInFrame(AllUI.Exit);

    if v44 then
        AddListen.AddMouseCLick(v44, function() -- Line: 345
            -- upvalues: NetWork (ref), NetMsg (ref)
            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Event", nil, false, true);
        end, AllUI.Exit);
    end;

    PlayerData.ListenClientSync(function(p45, p46) -- Line: 350
        -- upvalues: UIRoot (ref), _refreshMoneyShow (ref), GetData (ref), EnumMgr (ref), u9 (ref), EventTaskTab (ref), u7 (ref), EventHatchTab (ref), EventShopTab (ref)
        if not UIRoot.Visible then
            return;
        end;

        local v47;

        if type(p45) == "table" then
            v47 = p45[1];
        else
            v47 = p45;
        end;

        local u48;

        if type(p45) == "table" then
            u48 = p45[2];
        else
            u48 = nil;
        end;

        if v47 == "Bag" then
            task.defer(function() -- Line: 359
                -- upvalues: UIRoot (ref), _refreshMoneyShow (ref), GetData (ref), EnumMgr (ref), u9 (ref), EventTaskTab (ref), u7 (ref), EventHatchTab (ref)
                if not UIRoot.Visible then
                    return;
                end;

                _refreshMoneyShow();
                local v49 = (GetData.GetItemCountByIDOnClient(EnumMgr.ItemID.EventTicket) or 0) >= 1;
                local Hatch = u9.Hatch;

                if Hatch then
                    local v50 = Hatch:FindFirstChild("红点");

                    if v50 and v50:IsA("GuiObject") then
                        v50.Visible = v49;
                    end;
                end;

                local v51 = EventTaskTab.HasClaimable();
                local Task = u9.Task;

                if Task then
                    local v52 = Task:FindFirstChild("红点");

                    if v52 and v52:IsA("GuiObject") then
                        v52.Visible = v51;
                    end;
                end;

                if u7 == "Hatch" then
                    EventHatchTab.RefreshDrawBtns();
                end;
            end);

            return;
        end;

        if v47 ~= "Event" then
            return;
        end;

        task.defer(function() -- Line: 378
            -- upvalues: UIRoot (ref), u48 (copy), u7 (ref), EventHatchTab (ref), EventShopTab (ref), EventTaskTab (ref), u9 (ref), _refreshMoneyShow (ref), GetData (ref), EnumMgr (ref)
            if not UIRoot.Visible then
                return;
            end;

            if u48 == "Ticket" then
                if u7 == "Hatch" then
                    EventHatchTab.RefreshProgress();
                end;

                return;
            end;

            if u48 == "Shop" then
                if u7 == "Shop" then
                    EventShopTab.RefreshStates();
                end;

                return;
            end;

            if u48 == "HatchDrawn" then
                if u7 == "Hatch" then
                    EventHatchTab.RefreshRates();
                end;

                return;
            end;

            if u48 == "EventTask" then
                if u7 == "Task" then
                    EventTaskTab.RefreshStates();
                end;

                local v53 = EventTaskTab.HasClaimable();
                local Task = u9.Task;

                if not Task then
                    return;
                end;

                local v54 = Task:FindFirstChild("红点");

                if v54 then
                    if not v54:IsA("GuiObject") then
                        return;
                    end;

                    v54.Visible = v53;
                end;

                return;
            end;

            if u7 == "Shop" then
                EventShopTab.RefreshStates();
            elseif u7 == "Hatch" then
                EventHatchTab.RefreshStates();
            elseif u7 == "Task" then
                EventTaskTab.RefreshStates();
            end;

            _refreshMoneyShow();
            local v55 = (GetData.GetItemCountByIDOnClient(EnumMgr.ItemID.EventTicket) or 0) >= 1;
            local Hatch = u9.Hatch;

            if Hatch then
                local v56 = Hatch:FindFirstChild("红点");

                if v56 and v56:IsA("GuiObject") then
                    v56.Visible = v55;
                end;
            end;

            local v57 = EventTaskTab.HasClaimable();
            local Task = u9.Task;

            if not Task then
                return;
            end;

            local v58 = Task:FindFirstChild("红点");

            if v58 then
                if not v58:IsA("GuiObject") then
                    return;
                end;

                v58.Visible = v57;
            end;
        end);
    end);
end;

function v1.updateUi(p59, p60) -- Line: 423
    -- upvalues: u3 (copy), u7 (ref), UIRoot (copy), _refreshTabSelection (copy), _applyTabContent (copy), _refreshEndTime (copy)
    if type(p60) == "table" then
        p60 = p60.Tab or p60.tab;
    end;

    if type(p60) == "string" and p60 ~= "" then
        if not u3[p60] then
            p60 = nil;
        end;
    else
        p60 = nil;
    end;

    local v61;

    if p60 and p60 ~= u7 then
        u7 = p60;
        v61 = true;
    else
        v61 = false;
    end;

    if not UIRoot.Visible then
        return;
    end;

    if v61 then
        _refreshTabSelection();
        _applyTabContent(true);
    else
        _applyTabContent(false);
    end;

    _refreshEndTime();
end;

function v1.openUi(p62, p63) -- Line: 443
    -- upvalues: UIMgr (copy), UIRoot (copy), _buildTabs (copy), _ensureListeners (copy), NetWork (copy), NetMsg (copy), _refreshTabSelection (copy), _applyTabContent (copy), u11 (ref), _refreshEndTime (copy)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();
    _buildTabs();
    _ensureListeners();
    NetWork.FireServer(NetMsg.EVENT_UI_OPENED);
    _refreshTabSelection();
    _applyTabContent(true);
    u11 = u11 + 1;
    local u64 = u11;
    _refreshEndTime();
    task.spawn(function() -- Line: 107
        -- upvalues: u64 (copy), u11 (ref), UIRoot (ref), _refreshEndTime (ref)
        while u64 == u11 and UIRoot.Visible do
            task.wait(1);

            if u64 ~= u11 or not UIRoot.Visible then
                return;
            end;

            _refreshEndTime();
        end;
    end);
end;

function v1.closeUi(p65) -- Line: 457
    -- upvalues: u11 (ref), u7 (ref), EventShopTab (copy), EventHatchTab (copy), EventBuyTab (copy), EventTaskTab (copy), UIMgr (copy), UIRoot (copy)
    u11 = u11 + 1;
    u7 = "Shop";
    EventShopTab.Clear();
    EventHatchTab.Clear();
    EventBuyTab.Clear();
    EventTaskTab.Clear();
    UIMgr.SetMainUIVisible(true);
    UIRoot.Visible = false;
    UIMgr.UpdateBlurVisible();
end;

return v1;