-- Decompiled with Potassium's decompiler.

local u1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local TimeTransfer = UtilsSystem.TimeTransfer;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.Parent.AllUI);
local ItemType = EnumMgr.ItemType;
local PlrAttr = EnumMgr.PlrAttr;
local u2 = { 1, 2, 3, 4, 6, 5, 2, 1 };
local u3 = Color3.fromHex("#e84d4d");
local u4 = Color3.fromHex("#ffffff");
local u5 = false;
local u6 = false;
local u7 = 0;
local u8 = 0;
local u9 = nil;

local function _buildGlowStepWaits(p10) -- Line: 87
    local v11 = math.floor(p10);
    local v12 = math.max(1, v11);
    local v13 = 1.5749999999999997;
    local v14 = {};
    local v15 = math.min(3, v12);
    local v16 = v12 - v15;

    if v16 > 0 then
        local v17 = 2.9250000000000003 / v16;

        for i = 1, v16 do
            v14[i] = v17;
        end;
    else
        v13 = 4.5;
    end;

    local v18 = { 1, 2, 4 };

    for i = 1, v15 do
        v14[v16 + i] = v13 * (v18[i] / 7);
    end;

    return v14;
end;

local function _getHatchDrawn() -- Line: 114
    -- upvalues: PlayerData (copy), LocalPlayer (copy)
    local v19 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");

    if type(v19) == "table" and type(v19.HatchDrawn) == "table" then
        return v19.HatchDrawn;
    end;

    return nil;
end;

local function _findTargetCycleIndex(p20, p21) -- Line: 128
    local v22 = nil;

    for i, v in ipairs(p20) do
        if v == p21 then
            v22 = i;
        end;
    end;

    return v22;
end;

local function _findHatchRowBySort(p23) -- Line: 143
    -- upvalues: CfgFind (copy)
    for _, v in ipairs(CfgFind.GetEventHatchList()) do
        if tonumber(v.Sort) == p23 then
            return v;
        end;
    end;

    return nil;
end;

local function _isSortExcludedFromRoll(p24, p25, p26) -- Line: 159
    -- upvalues: CfgFind (copy)
    if p25 and p24 == p25 then
        return false;
    end;

    for _, v in ipairs(CfgFind.GetEventHatchList()) do
        if tonumber(v.Sort) == p24 then
            break;
        end;
    end;

    if not v then
        return true;
    end;

    if not CfgFind.IsEventHatchLimitRow(v) then
        return false;
    end;

    local v27 = tonumber(v.ItemId) or 0;

    return CfgFind.IsEventHatchDrawn(p26, v27, v);
end;

local function _buildActiveGlowCycle(p28) -- Line: 183
    -- upvalues: PlayerData (copy), LocalPlayer (copy), u2 (copy), CfgFind (copy)
    local v29 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local v30;

    if type(v29) == "table" and type(v29.HatchDrawn) == "table" then
        v30 = v29.HatchDrawn;
    else
        v30 = nil;
    end;

    local v31 = {};

    for _, v in ipairs(u2) do
        local v32;

        if not p28 or v ~= p28 then
            for _, v2 in ipairs(CfgFind.GetEventHatchList()) do
                if tonumber(v2.Sort) == v then
                    break;
                end;
            end;

            if v2 then
                if CfgFind.IsEventHatchLimitRow(v2) then
                    local v33 = tonumber(v2.ItemId) or 0;
                    v32 = CfgFind.IsEventHatchDrawn(v30, v33, v2);
                else
                    v32 = false;
                end;
            else
                v32 = true;
            end;

            if not v32 then
                table.insert(v31, v);
            end;
        end;

        v32 = false;

        if not v32 then
            table.insert(v31, v);
        end;
    end;

    if #v31 == 0 then
        if p28 then
            return { p28 };
        end;

        for _, v in ipairs(u2) do
            table.insert(v31, v);
        end;
    end;

    return v31;
end;

local function _buildGlowSteps(p34) -- Line: 208
    -- upvalues: _buildActiveGlowCycle (copy)
    local v35 = _buildActiveGlowCycle(p34);
    local v36 = #v35;

    if v36 <= 0 then
        return {}, false;
    end;

    local v37 = math.max(v36 * 3, v36);
    local v38;

    if p34 then
        v38 = nil;

        for i, v in ipairs(v35) do
            if v == p34 then
                v38 = i;
            end;
        end;
    else
        v38 = nil;
    end;

    local v39;

    if v38 then
        while (v37 - 1) % v36 + 1 ~= v38 do
            v37 = v37 + 1;
        end;

        v39 = true;
    else
        v39 = false;
    end;

    local v40 = {};

    for i = 1, v37 do
        v40[i] = v35[(i - 1) % v36 + 1];
    end;

    return v40, v39;
end;

local function _getTicketIntervalSec() -- Line: 237
    -- upvalues: CfgFind (copy)
    local TicketIntervalSec = CfgFind.GetEventGameConfig().TicketIntervalSec;
    local v41 = tonumber(TicketIntervalSec) or 900;

    return math.max(1, v41);
end;

local function _getTicketDailyMax() -- Line: 246
    -- upvalues: CfgFind (copy)
    local TicketDailyMax = CfgFind.GetEventGameConfig().TicketDailyMax;
    local v42 = tonumber(TicketDailyMax) or 3;

    return math.max(0, v42);
end;

local function _getTicketGranted() -- Line: 255
    -- upvalues: PlayerData (copy), LocalPlayer (copy)
    local v43 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");

    if type(v43) ~= "table" or type(v43.Ticket) ~= "table" then
        return 0;
    end;

    local v44 = tonumber(v43.Ticket.Granted) or 0;

    return math.max(0, v44);
end;

local function _getAccSec() -- Line: 267
    -- upvalues: PlayerData (copy), LocalPlayer (copy)
    local v45 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");

    if type(v45) ~= "table" or type(v45.Ticket) ~= "table" then
        return 0;
    end;

    local v46 = tonumber(v45.Ticket.AccSec) or 0;

    return math.max(0, v46);
end;

local function _findHatchRowByItemId(p47) -- Line: 280
    -- upvalues: CfgFind (copy)
    for _, v in ipairs(CfgFind.GetEventHatchList()) do
        if tonumber(v.ItemId) == p47 then
            return v;
        end;
    end;

    return nil;
end;

local function _pickHighlightItemId(p48) -- Line: 294
    -- upvalues: CfgFind (copy)
    local v49 = p48[1];
    local v50, v51, v52;
    v50, v51, v52 = ipairs(p48);
    local v53 = (1 / 0);

    while true do
        local v54, v55 = v50(v51, v52);

        if v54 == nil then
            break;
        end;

        v52 = v54;

        for _, v in ipairs(CfgFind.GetEventHatchList()) do
            if tonumber(v.ItemId) == v55 then
                break;
            end;
        end;

        local v56 = v and (tonumber(v.Weight) or (1 / 0)) or (1 / 0);

        if v56 < v53 then
            v49 = v55;
            v53 = v56;
        end;
    end;
end;

local function _collectPrizeFrames() -- Line: 312
    -- upvalues: AllUI (copy)
    local v57 = {};

    if AllUI.HatchBigTemp.Visible then
        table.insert(v57, AllUI.HatchBigTemp);
    end;

    if AllUI.HatchMiddleTemp.Visible then
        table.insert(v57, AllUI.HatchMiddleTemp);
    end;

    for _, child in ipairs(AllUI.HatchFrame3:GetChildren()) do
        if child:IsA("GuiObject") and string.sub(child.Name, 1, 6) == "Hatch_" then
            table.insert(v57, child);
        end;
    end;

    return v57;
end;

local function _findPrizeFrameBySort(p58) -- Line: 333
    -- upvalues: _collectPrizeFrames (copy)
    for _, v in ipairs((_collectPrizeFrames())) do
        if tonumber(v:GetAttribute("EventHatchSort")) == p58 then
            return v;
        end;
    end;

    return nil;
end;

local function _setGlowVisible(p59, p60) -- Line: 347
    local v61 = p59:FindFirstChild("抽中时发光");

    if v61 and v61:IsA("GuiObject") then
        v61.Visible = p60;
    end;
end;

local function _clearAllGlows() -- Line: 357
    -- upvalues: _collectPrizeFrames (copy)
    for _, v in ipairs((_collectPrizeFrames())) do
        local v62 = v:FindFirstChild("抽中时发光");

        if v62 and v62:IsA("GuiObject") then
            v62.Visible = false;
        end;
    end;
end;

local function _cancelGlowRoll() -- Line: 366
    -- upvalues: u8 (ref), _collectPrizeFrames (copy)
    u8 = u8 + 1;

    for _, v in ipairs((_collectPrizeFrames())) do
        local v63 = v:FindFirstChild("抽中时发光");

        if v63 and v63:IsA("GuiObject") then
            v63.Visible = false;
        end;
    end;
end;

local function _showDrawResultUI(p64, p65) -- Line: 376
    -- upvalues: NetWork (copy), NetMsg (copy), TipsModule (copy), LocalPlayer (copy)
    if p65 == 3 or p65 == 10 then
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "HatchPop", {
            itemIds = p64,
            times = p65
        }, true, true);

        return;
    end;

    for _, v in ipairs(p64) do
        TipsModule.NewShowTipsTemplate(LocalPlayer, {
            Type = "获得奖励",
            Count = 1,
            ID = v
        });
    end;
end;

local function _playGlowRollThenShow(u66, u67) -- Line: 394
    -- upvalues: u8 (ref), u5 (ref), AllUI (copy), _collectPrizeFrames (copy), u9 (ref), _showDrawResultUI (copy), u1 (copy), _pickHighlightItemId (copy), CfgFind (copy), _buildGlowSteps (copy), _buildGlowStepWaits (copy), _findPrizeFrameBySort (copy)
    u8 = u8 + 1;
    local u68 = u8;
    u5 = true;
    local v69;

    if AllUI.Hatch.Visible == true then
        v69 = #_collectPrizeFrames() > 0;
    else
        v69 = false;
    end;

    if not v69 then
        u9 = nil;
        _showDrawResultUI(u66, u67);
        u5 = false;
        u1.RefreshStates();

        return;
    end;

    local v70 = _pickHighlightItemId(u66);

    for _, v in ipairs(CfgFind.GetEventHatchList()) do
        if tonumber(v.ItemId) == v70 then
            break;
        end;
    end;

    local u71;

    if v then
        u71 = tonumber(v.Sort);
    else
        u71 = nil;
    end;

    local u72, u73 = _buildGlowSteps(u71);
    local u74 = _buildGlowStepWaits(#u72);
    task.spawn(function() -- Line: 414
        -- upvalues: _collectPrizeFrames (ref), u72 (copy), u68 (copy), u8 (ref), u5 (ref), _findPrizeFrameBySort (ref), u74 (copy), u71 (copy), u73 (copy), u67 (copy), u9 (ref), _showDrawResultUI (ref), u66 (copy), u1 (ref)
        for _, v in ipairs((_collectPrizeFrames())) do
            local v75 = v:FindFirstChild("抽中时发光");

            if v75 and v75:IsA("GuiObject") then
                v75.Visible = false;
            end;
        end;

        local v76 = nil;

        for i, v in ipairs(u72) do
            if u68 ~= u8 then
                u5 = false;

                return;
            end;

            local v77 = _findPrizeFrameBySort(v);

            if v76 and v76 ~= v77 then
                local v78 = v76:FindFirstChild("抽中时发光");

                if v78 and v78:IsA("GuiObject") then
                    v78.Visible = false;
                end;
            end;

            if v77 then
                local v79 = v77:FindFirstChild("抽中时发光");

                if v79 and v79:IsA("GuiObject") then
                    v79.Visible = true;
                end;
            else
                v77 = v76;
            end;

            task.wait(u74[i] or 0.05);
            v76 = v77;
        end;

        if u68 ~= u8 then
            u5 = false;

            return;
        end;

        if u71 and not u73 then
            for _, v in ipairs((_collectPrizeFrames())) do
                local v80 = v:FindFirstChild("抽中时发光");

                if v80 and v80:IsA("GuiObject") then
                    v80.Visible = false;
                end;
            end;

            local v81 = _findPrizeFrameBySort(u71);

            if v81 then
                local v82 = v81:FindFirstChild("抽中时发光");

                if v82 and v82:IsA("GuiObject") then
                    v82.Visible = true;
                end;
            end;
        end;

        task.wait((u67 == 3 or u67 == 10) and 1 or 0.5);

        if u68 ~= u8 then
            u5 = false;

            return;
        end;

        u9 = nil;
        _showDrawResultUI(u66, u67);
        u5 = false;
        u1.RefreshStates();
    end);
end;

local function _formatRate(p83, p84) -- Line: 467
    if p84 <= 0 or p83 <= 0 then
        return "0%";
    end;

    local v85 = p83 / p84 * 100;

    if v85 >= 10 then
        return string.format("%d%%", (math.floor(v85 + 0.5)));
    end;

    return string.format("%.1f%%", v85);
end;

local function _applyRateLabel(p86, p87, p88) -- Line: 484
    -- upvalues: TranslationHelper (copy), u3 (copy), u4 (copy)
    if p87 then
        TranslationHelper.SetText(p86, "已拥有");
        p86.TextColor3 = u3;

        return;
    end;

    TranslationHelper.SetText_UnTrans(p86, p88 or "0%");
    p86.TextColor3 = u4;
end;

local function _setHatchBtnPrice(p89, p90) -- Line: 499
    -- upvalues: UIMgr (copy)
    UIMgr.SetRobuxBuyBtnPrice(p89, p90);
end;

local function _setPriceVisible(p91, p92) -- Line: 508
    local Price = p91:FindFirstChild("Price");

    if Price and Price:IsA("GuiObject") then
        Price.Visible = p92;
    end;
end;

local function _formatEquipPowerText(p93, p94) -- Line: 521
    -- upvalues: PlrAttr (copy), MathMgr (copy)
    local v95 = tonumber(p94);

    if p93 == PlrAttr.Train_Base then
        if v95 then
            return "+" .. MathMgr.getNumStr(v95);
        end;

        return "+" .. tostring(p94);
    end;

    if p93 ~= PlrAttr.Train_Mul then
        return nil;
    end;

    if v95 then
        return "x " .. MathMgr.getNumStr(v95 + 1);
    end;

    return "x " .. tostring(p94);
end;

local function _decoratePowerFrame(p96, p97, p98) -- Line: 544
    -- upvalues: ItemType (copy), TranslationHelper (copy), _formatEquipPowerText (copy)
    local PowerFrame = p96:FindFirstChild("PowerFrame");

    if not (PowerFrame and PowerFrame:IsA("Frame")) then
        return;
    end;

    if p98 ~= ItemType.Weapon and p98 ~= ItemType.Armor and p98 ~= ItemType.Broom then
        PowerFrame.Visible = false;

        return;
    end;

    local Power = PowerFrame:FindFirstChild("Power");
    local PowerIcon = PowerFrame:FindFirstChild("PowerIcon");

    if PowerIcon and PowerIcon:IsA("GuiObject") then
        PowerIcon.Visible = p98 ~= ItemType.Broom;
    end;

    if p98 == ItemType.Broom then
        local v99 = tonumber(p97.Dungeon);

        if not (v99 and (Power and Power:IsA("TextLabel"))) then
            PowerFrame.Visible = false;

            return;
        end;

        PowerFrame.Visible = true;
        TranslationHelper.SetText(Power, "阶段N", { v99 });

        return;
    end;

    local v100 = type(p97.attr) == "table" and p97.attr or (p97.attr and ({ p97.attr } or {}) or {});
    local v101 = type(p97.attrNum) == "table" and p97.attrNum or (p97.attrNum and { p97.attrNum } or {});
    local v102 = tonumber(v100[1]);
    local v103;

    if v102 then
        v103 = _formatEquipPowerText(v102, v101[1]);
    else
        v103 = nil;
    end;

    if not (v103 and (Power and Power:IsA("TextLabel"))) then
        PowerFrame.Visible = false;

        return;
    end;

    PowerFrame.Visible = true;
    TranslationHelper.SetText_UnTrans(Power, v103);
end;

local function _decoratePrize(p104, p105, p106, p107) -- Line: 592
    -- upvalues: CfgFind (copy), Log (copy), TranslationHelper (copy), UIMgr (copy), GetData (copy), _decoratePowerFrame (copy), u3 (copy), u4 (copy)
    local v108 = tonumber(p105.ItemId) or 0;
    local v109 = CfgFind.FindCfgByID(v108);

    if not v109 then
        Log.warn("[EventHatchTab] 无物品配置:", v108);

        return;
    end;

    local v110 = tonumber(v109.tp);
    local Top = p104:FindFirstChild("Top");

    if Top and Top:IsA("Frame") then
        local Name = Top:FindFirstChild("Name");

        if Name and Name:IsA("TextLabel") then
            TranslationHelper.SetText(Name, v109.ZhName or "");
        end;

        local Xyd = Top:FindFirstChild("Xyd");

        if Xyd and Xyd:IsA("TextLabel") then
            UIMgr.setXydLabel(Xyd, v109.xyd or 1);
        end;

        local v111 = Top:FindFirstChild("永久");

        if v111 and v111:IsA("GuiObject") then
            local v112 = GetData.Alchemy.ShouldGrantEventPotionAsPay(v108);
            v111.Visible = v112;

            if v112 and v111:IsA("TextLabel") then
                TranslationHelper.SetText(v111, "永久");
            end;
        end;

        _decoratePowerFrame(Top, v109, v110);
    end;

    UIMgr.ApplyItemIconOrViewport(p104, v108, (tostring(v109.Icon or "")));
    local BG = p104:FindFirstChild("BG");

    if BG and BG:IsA("Frame") then
        UIMgr.ApplyEquipmentItemBg(BG, v109.xyd or 1);
    end;

    local v113 = p104:FindFirstChild("抽中时发光");

    if v113 and v113:IsA("GuiObject") then
        v113.Visible = false;
    end;

    local Limit = p104:FindFirstChild("Limit");

    if Limit and Limit:IsA("GuiObject") then
        Limit.Visible = tonumber(p105.isLimit) == 1;
    end;

    local Rate = p104:FindFirstChild("Rate");

    if Rate and Rate:IsA("TextLabel") then
        local v114 = CfgFind.IsEventHatchLimitRow(p105) and CfgFind.IsEventHatchDrawn(p107, v108, p105);

        if v114 then
            TranslationHelper.SetText(Rate, "已拥有");
            Rate.TextColor3 = u3;

            return;
        end;

        local v115 = tonumber(p105.Weight) or 0;
        local v116;

        if p106 <= 0 or v115 <= 0 then
            v116 = "0%";
        else
            local v117 = v115 / p106 * 100;

            if v117 >= 10 then
                v116 = string.format("%d%%", (math.floor(v117 + 0.5)));
            else
                v116 = string.format("%.1f%%", v117);
            end;
        end;

        TranslationHelper.SetText_UnTrans(Rate, v116 or "0%");
        Rate.TextColor3 = u4;
    end;
end;

local function _refreshBtn1Bg() -- Line: 662
    -- upvalues: AllUI (copy), GetData (copy), EnumMgr (copy), UIMgr (copy)
    local HatchBtn1 = AllUI.HatchBtn1;
    local FreeBg = HatchBtn1:FindFirstChild("FreeBg");
    local RobuxBg = HatchBtn1:FindFirstChild("RobuxBg");
    local v118 = (GetData.GetItemCountByIDOnClient(EnumMgr.ItemID.EventTicket) or 0) > 0;

    if FreeBg and FreeBg:IsA("GuiObject") then
        FreeBg.Visible = v118;
    end;

    if RobuxBg and RobuxBg:IsA("GuiObject") then
        RobuxBg.Visible = not v118;
    end;

    local v119 = not v118;
    local Price = HatchBtn1:FindFirstChild("Price");

    if Price and Price:IsA("GuiObject") then
        Price.Visible = v119;
    end;

    if not v118 then
        UIMgr.SetRobuxBuyBtnPrice(HatchBtn1, "x1Spin");
    end;
end;

local function _ensureBtnBinds() -- Line: 683
    -- upvalues: u6 (ref), UIMgr (copy), Log (copy), AddListen (copy), AllUI (copy), u5 (ref), GetData (copy), EnumMgr (copy), NetWork (copy), NetMsg (copy), u1 (copy), SystemBuyRoblox (copy), LocalPlayer (copy)
    if u6 then
        return;
    end;

    u6 = true;

    local function bind(p120, p121) -- Line: 689
        -- upvalues: UIMgr (ref), Log (ref), AddListen (ref)
        local v122 = UIMgr.FindButtonInFrame(p120);

        if v122 then
            AddListen.AddMouseCLick(v122, p121, p120);

            return;
        end;

        Log.warn("[EventHatchTab] 缺少 Btn:", p120:GetFullName());
    end;

    local HatchBtn1 = AllUI.HatchBtn1;

    local function v125() -- Line: 698
        -- upvalues: u5 (ref), GetData (ref), EnumMgr (ref), NetWork (ref), NetMsg (ref), u1 (ref), SystemBuyRoblox (ref), LocalPlayer (ref)
        if u5 then
            return;
        end;

        if (GetData.GetItemCountByIDOnClient(EnumMgr.ItemID.EventTicket) or 0) <= 0 then
            SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, "x1Spin");

            return;
        end;

        u5 = true;
        local success, result = pcall(function() -- Line: 705
            -- upvalues: NetWork (ref), NetMsg (ref)
            return NetWork.InvokeServer(NetMsg.EVENT_HATCH_DRAW, "ticket");
        end);

        if not success or (type(result) ~= "table" or type(result.itemIds) ~= "table") then
            u5 = false;

            return;
        end;

        local v123 = {};

        for _, v in ipairs(result.itemIds) do
            local v124 = tonumber(v);

            if v124 then
                table.insert(v123, v124);
            end;
        end;

        if #v123 == 0 then
            u5 = false;

            return;
        end;

        u1.RefreshStates();
        u1.PlayDrawResult(v123, tonumber(result.times) or 1);
    end;

    local v126 = UIMgr.FindButtonInFrame(HatchBtn1);

    if v126 then
        AddListen.AddMouseCLick(v126, v125, HatchBtn1);
    else
        Log.warn("[EventHatchTab] 缺少 Btn:", HatchBtn1:GetFullName());
    end;

    local HatchBtn2 = AllUI.HatchBtn2;

    local function v127() -- Line: 731
        -- upvalues: u5 (ref), SystemBuyRoblox (ref), LocalPlayer (ref)
        if u5 then
            return;
        end;

        SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, "x3Spin");
    end;

    local v128 = UIMgr.FindButtonInFrame(HatchBtn2);

    if v128 then
        AddListen.AddMouseCLick(v128, v127, HatchBtn2);
    else
        Log.warn("[EventHatchTab] 缺少 Btn:", HatchBtn2:GetFullName());
    end;

    local HatchBtn3 = AllUI.HatchBtn3;

    local function v129() -- Line: 738
        -- upvalues: u5 (ref), SystemBuyRoblox (ref), LocalPlayer (ref)
        if u5 then
            return;
        end;

        SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, "x10Spin");
    end;

    local v130 = UIMgr.FindButtonInFrame(HatchBtn3);

    if v130 then
        AddListen.AddMouseCLick(v130, v129, HatchBtn3);

        return;
    end;

    Log.warn("[EventHatchTab] 缺少 Btn:", HatchBtn3:GetFullName());
end;

function u1.RefreshProgress() -- Line: 749
    -- upvalues: AllUI (copy), CfgFind (copy), PlayerData (copy), LocalPlayer (copy), TimeTransfer (copy), TranslationHelper (copy)
    local v131 = AllUI["进度条"];

    if not v131 then
        return;
    end;

    local TicketIntervalSec = CfgFind.GetEventGameConfig().TicketIntervalSec;
    local v132 = tonumber(TicketIntervalSec) or 900;
    local v133 = math.max(1, v132);
    local TicketDailyMax = CfgFind.GetEventGameConfig().TicketDailyMax;
    local v134 = tonumber(TicketDailyMax) or 3;
    local v135 = math.max(0, v134);
    local v136 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local v137;

    if type(v136) == "table" and type(v136.Ticket) == "table" then
        local v138 = tonumber(v136.Ticket.Granted) or 0;
        v137 = math.max(0, v138);
    else
        v137 = 0;
    end;

    local v139;

    if v135 > 0 then
        v139 = v135 <= v137;
    else
        v139 = false;
    end;

    local v140;

    if v139 then
        v140 = v133;
    else
        local v141 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
        local v142;

        if type(v141) == "table" and type(v141.Ticket) == "table" then
            local v143 = tonumber(v141.Ticket.AccSec) or 0;
            v142 = math.max(0, v143);
        else
            v142 = 0;
        end;

        v140 = math.min(v142, v133);
    end;

    local v144 = v139 and 1 or math.clamp(v140 / v133, 0, 1);
    local Bar = v131:FindFirstChild("Bar");

    if Bar and Bar:IsA("GuiObject") then
        local Y = Bar.Size.Y;
        Bar.Size = UDim2.new(v144, 0, Y.Scale, Y.Offset);
    end;

    local v145 = v131:FindFirstChild("进度");

    if v145 and v145:IsA("TextLabel") then
        local v146 = TimeTransfer.FormatTimeMMSS(v140) .. "/" .. TimeTransfer.FormatTimeMMSS(v133);
        TranslationHelper.SetText_UnTrans(v145, v146);
    end;

    local v147 = AllUI["在线领取抽奖券提示"];

    if v147 and v147:IsA("TextLabel") then
        local v148 = math.floor(v133 / 60);
        TranslationHelper.SetText(v147, "在线领取抽奖券提示", { tostring(v148), tostring(v137), (tostring(v135)) });
    end;
end;

function u1.RefreshRates() -- Line: 789
    -- upvalues: u5 (ref), u9 (ref), PlayerData (copy), LocalPlayer (copy), CfgFind (copy), TranslationHelper (copy), u3 (copy), u4 (copy), AllUI (copy)
    if u5 or u9 then
        return;
    end;

    local v149 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local u150;

    if type(v149) == "table" and type(v149.HatchDrawn) == "table" then
        u150 = v149.HatchDrawn;
    else
        u150 = nil;
    end;

    local u151 = CfgFind.GetEventHatchPoolTotalWeight(u150);
    local u152 = {};

    for _, v in ipairs(CfgFind.GetEventHatchList()) do
        local v153 = tonumber(v.id) or 0;

        if v153 > 0 then
            u152[v153] = v;
        end;
    end;

    local function applyRate(p154) -- Line: 804
        -- upvalues: u152 (copy), CfgFind (ref), u150 (copy), TranslationHelper (ref), u3 (ref), u151 (copy), u4 (ref)
        local v155 = tonumber(p154:GetAttribute("EventHatchId"));

        if not v155 then
            return;
        end;

        local v156 = u152[v155];

        if not v156 then
            return;
        end;

        local Rate = p154:FindFirstChild("Rate");

        if not (Rate and Rate:IsA("TextLabel")) then
            return;
        end;

        local v157 = tonumber(v156.ItemId) or 0;
        local v158 = CfgFind.IsEventHatchLimitRow(v156) and CfgFind.IsEventHatchDrawn(u150, v157, v156);

        if v158 then
            TranslationHelper.SetText(Rate, "已拥有");
            Rate.TextColor3 = u3;

            return;
        end;

        local v159 = tonumber(v156.Weight) or 0;
        local v160 = u151;
        local v161;

        if v160 <= 0 or v159 <= 0 then
            v161 = "0%";
        else
            local v162 = v159 / v160 * 100;

            if v162 >= 10 then
                v161 = string.format("%d%%", (math.floor(v162 + 0.5)));
            else
                v161 = string.format("%.1f%%", v162);
            end;
        end;

        TranslationHelper.SetText_UnTrans(Rate, v161 or "0%");
        Rate.TextColor3 = u4;
    end;

    if AllUI.HatchBigTemp.Visible then
        applyRate(AllUI.HatchBigTemp);
    end;

    if AllUI.HatchMiddleTemp.Visible then
        applyRate(AllUI.HatchMiddleTemp);
    end;

    for _, child in ipairs(AllUI.HatchFrame3:GetChildren()) do
        if child:IsA("GuiObject") and string.sub(child.Name, 1, 6) == "Hatch_" then
            applyRate(child);
        end;
    end;
end;

function u1.RefreshDrawBtns() -- Line: 844
    -- upvalues: AllUI (copy), UIMgr (copy), _refreshBtn1Bg (copy)
    for _, v in ipairs({
        { AllUI.HatchBtn2, "x3Spin" },
        { AllUI.HatchBtn3, "x10Spin" }
    }) do
        local v163 = v[1];
        local v164 = v[2];
        local RobuxBg = v163:FindFirstChild("RobuxBg");

        if RobuxBg and RobuxBg:IsA("GuiObject") then
            RobuxBg.Visible = true;
        end;

        local Price = v163:FindFirstChild("Price");

        if Price and Price:IsA("GuiObject") then
            Price.Visible = true;
        end;

        UIMgr.SetRobuxBuyBtnPrice(v163, v164);
    end;

    _refreshBtn1Bg();
end;

function u1.StartProgressLoop() -- Line: 865
    -- upvalues: u7 (ref), u1 (copy), AllUI (copy)
    u7 = u7 + 1;
    local u165 = u7;
    u1.RefreshProgress();
    task.spawn(function() -- Line: 869
        -- upvalues: u165 (copy), u7 (ref), AllUI (ref), u1 (ref)
        while u165 == u7 do
            task.wait(1);

            if u165 ~= u7 then
                return;
            end;

            if not AllUI.Hatch.Visible then
                return;
            end;

            u1.RefreshProgress();
        end;
    end);
end;

function u1.StopProgressLoop() -- Line: 886
    -- upvalues: u7 (ref)
    u7 = u7 + 1;
end;

function u1.RefreshStates() -- Line: 893
    -- upvalues: u1 (copy)
    u1.RefreshProgress();
    u1.RefreshRates();
    u1.RefreshDrawBtns();
end;

function u1.Clear() -- Line: 902
    -- upvalues: u1 (copy), UIMgr (copy), AllUI (copy)
    u1.AbortGlowAndFlushResult();
    u1.StopProgressLoop();
    UIMgr.ClearScrollItems(AllUI.HatchFrame3, {
        keepInstances = { AllUI.HatchSmallTemp }
    });
end;

function u1.PlayDrawResult(p166, p167) -- Line: 913
    -- upvalues: u9 (ref), u5 (ref), u1 (copy), _playGlowRollThenShow (copy)
    if type(p166) ~= "table" or #p166 == 0 then
        return;
    end;

    local v168 = tonumber(p167) or 0;
    local v169 = math.floor(v168);

    if v169 ~= 1 and (v169 ~= 3 and v169 ~= 10) then
        local v170 = #p166;
        v169 = v170 ~= 1 and (v170 ~= 3 and v170 ~= 10) and 1 or v170;
    end;

    if u9 or u5 then
        u1.AbortGlowAndFlushResult();
    end;

    local v171 = {};

    for _, v in ipairs(p166) do
        local v172 = tonumber(v);

        if v172 then
            table.insert(v171, v172);
        end;
    end;

    if #v171 == 0 then
        return;
    end;

    u9 = {
        itemIds = v171,
        times = v169
    };
    _playGlowRollThenShow(v171, v169);
end;

function u1.AbortGlowAndFlushResult() -- Line: 951
    -- upvalues: u9 (ref), u8 (ref), _collectPrizeFrames (copy), u5 (ref), _showDrawResultUI (copy), u1 (copy)
    local v173 = u9;
    u9 = nil;
    u8 = u8 + 1;

    for _, v in ipairs((_collectPrizeFrames())) do
        local v174 = v:FindFirstChild("抽中时发光");

        if v174 and v174:IsA("GuiObject") then
            v174.Visible = false;
        end;
    end;

    u5 = false;

    if v173 then
        _showDrawResultUI(v173.itemIds, v173.times);
        u1.RefreshStates();
    end;
end;

function u1.Refresh() -- Line: 965
    -- upvalues: u9 (ref), u5 (ref), u1 (copy), u8 (ref), _collectPrizeFrames (copy), AllUI (copy), UIMgr (copy), PlayerData (copy), LocalPlayer (copy), CfgFind (copy), _decoratePrize (copy), _ensureBtnBinds (copy)
    if u9 or u5 then
        u1.AbortGlowAndFlushResult();
    else
        u8 = u8 + 1;

        for _, v in ipairs((_collectPrizeFrames())) do
            local v175 = v:FindFirstChild("抽中时发光");

            if v175 and v175:IsA("GuiObject") then
                v175.Visible = false;
            end;
        end;
    end;

    AllUI.HatchBigTemp.Visible = false;
    AllUI.HatchMiddleTemp.Visible = false;
    AllUI.HatchSmallTemp.Visible = false;
    UIMgr.ClearScrollItems(AllUI.HatchFrame3, {
        keepInstances = { AllUI.HatchSmallTemp }
    });
    AllUI.HatchBigTemp:SetAttribute("EventHatchId", nil);
    AllUI.HatchBigTemp:SetAttribute("EventHatchSort", nil);
    AllUI.HatchMiddleTemp:SetAttribute("EventHatchId", nil);
    AllUI.HatchMiddleTemp:SetAttribute("EventHatchSort", nil);
    local v176 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local v177;

    if type(v176) == "table" and type(v176.HatchDrawn) == "table" then
        v177 = v176.HatchDrawn;
    else
        v177 = nil;
    end;

    local v178 = CfgFind.GetEventHatchPoolTotalWeight(v177);
    local v179 = {};
    local v180 = nil;
    local v181 = nil;

    for _, v in ipairs(CfgFind.GetEventHatchList()) do
        local v182 = tonumber(v.Sort) or 0;

        if v182 == 1 then
            v180 = v;
        elseif v182 == 2 then
            v181 = v;
        elseif v182 >= 3 and v182 <= 7 then
            table.insert(v179, v);
        end;
    end;

    if v180 then
        AllUI.HatchBigTemp.Visible = true;
        AllUI.HatchBigTemp.LayoutOrder = 1;
        AllUI.HatchBigTemp:SetAttribute("EventHatchId", tonumber(v180.id) or 0);
        AllUI.HatchBigTemp:SetAttribute("EventHatchSort", 1);
        _decoratePrize(AllUI.HatchBigTemp, v180, v178, v177);
    end;

    if v181 then
        AllUI.HatchMiddleTemp.Visible = true;
        AllUI.HatchMiddleTemp.LayoutOrder = 2;
        AllUI.HatchMiddleTemp:SetAttribute("EventHatchId", tonumber(v181.id) or 0);
        AllUI.HatchMiddleTemp:SetAttribute("EventHatchSort", 2);
        _decoratePrize(AllUI.HatchMiddleTemp, v181, v178, v177);
    end;

    table.sort(v179, function(p183, p184) -- Line: 1015
        return (tonumber(p183.Sort) or 0) < (tonumber(p184.Sort) or 0);
    end);

    for _, v in ipairs(v179) do
        local v185 = tonumber(v.id) or 0;
        local v186 = tonumber(v.Sort) or v185;
        local v187 = AllUI.HatchSmallTemp:Clone();
        v187.Name = "Hatch_" .. tostring(v185);
        v187.Visible = true;
        v187.LayoutOrder = v186;
        v187:SetAttribute("EventHatchId", v185);
        v187:SetAttribute("EventHatchSort", v186);
        v187.Parent = AllUI.HatchFrame3;
        _decoratePrize(v187, v, v178, v177);
    end;

    UIMgr.SetUIlistSize(AllUI.HatchFrame3);
    _ensureBtnBinds();
    u1.RefreshDrawBtns();
    u1.RefreshProgress();
    u1.StartProgressLoop();
end;

return u1;