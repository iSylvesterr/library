-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local UIMgr = UtilsSystem.UIMgr;
local UIanima = UtilsSystem.UIanima;
local TranslationHelper = UtilsSystem.TranslationHelper;
local MathMgr = UtilsSystem.MathMgr;
local EquipShop = UtilsSystem.EquipShop;
local GetData = UtilsSystem.GetData;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local LocalPlayer = UtilsSystem.LocalPlayer;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local TipsModule = UtilsSystem.TipsModule;
local PlrAttr = EnumMgr.PlrAttr;
local ItemType = EnumMgr.ItemType;
local v1 = {};
local u2 = false;

local function _isFlyingBlockingBroomChange() -- Line: 74
    -- upvalues: GetData (copy), LocalPlayer (copy)
    if GetData.GetIsFly(LocalPlayer) then
        return true;
    end;

    local StageJumping = LocalPlayer:FindFirstChild("StageJumping");

    return StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value > 0) and true or false;
end;

local function _blockBroomChangeIfFlying(p3) -- Line: 91
    -- upvalues: ItemType (copy), GetData (copy), LocalPlayer (copy), TipsModule (copy)
    if p3 ~= ItemType.Broom then
        return false;
    end;

    local v4;

    if GetData.GetIsFly(LocalPlayer) then
        v4 = true;
    else
        local StageJumping = LocalPlayer:FindFirstChild("StageJumping");
        v4 = StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value > 0) and true or false;
    end;

    if not v4 then
        return false;
    end;

    TipsModule.ErrorTips(LocalPlayer, "飞行时无法替换扫把");

    return true;
end;

local function _setPriceNumText(p5, p6) -- Line: 108
    -- upvalues: TranslationHelper (copy), MathMgr (copy)
    if not p5 then
        return;
    end;

    local PriceNum = p5:FindFirstChild("PriceNum");

    if PriceNum and PriceNum:IsA("TextLabel") then
        PriceNum.RichText = false;
        TranslationHelper.SetText_UnTrans(PriceNum, MathMgr.getNumStr(p6));
    end;
end;

local function _setCoinBuyPrice(p7, p8) -- Line: 125
    -- upvalues: TranslationHelper (copy), MathMgr (copy)
    local Price = p7:FindFirstChild("Price");

    if not Price then
        return;
    end;

    local PriceNum = Price:FindFirstChild("PriceNum");

    if PriceNum and PriceNum:IsA("TextLabel") then
        PriceNum.RichText = false;
        TranslationHelper.SetText_UnTrans(PriceNum, MathMgr.getNumStr(p8));
    end;
end;

local function _formatEquipPowerText(p9, p10) -- Line: 136
    -- upvalues: PlrAttr (copy), MathMgr (copy)
    local v11 = tonumber(p10);

    if p9 == PlrAttr.Train_Base then
        if v11 then
            return "+" .. MathMgr.getNumStr(v11);
        end;

        return "+" .. tostring(p10);
    end;

    if p9 ~= PlrAttr.Train_Mul then
        return nil;
    end;

    if v11 then
        return "x " .. MathMgr.getNumStr(v11 + 1);
    end;

    return "x " .. tostring(p10);
end;

local function _setEquipBtn(p12, p13) -- Line: 159
    local Bg = p12:FindFirstChild("Bg");
    local Btn = p12:FindFirstChild("Btn");
    local v14 = p12:FindFirstChild("装备");
    local v15 = p12:FindFirstChild("已装备");

    if p13 then
        if Bg then
            Bg.Visible = false;
        end;

        if Btn then
            Btn.Visible = false;
            Btn.Active = false;
        end;

        if v14 then
            v14.Visible = false;
        end;

        if v15 then
            v15.Visible = true;
        end;

        return;
    end;

    if Bg then
        Bg.Visible = true;
    end;

    if Btn then
        Btn.Visible = true;
        Btn.Active = true;
    end;

    if v14 then
        v14.Visible = true;
    end;

    if v15 then
        v15.Visible = false;
    end;
end;

local function _hasRobuxPurchase(p16) -- Line: 202
    -- upvalues: EquipShop (copy), CfgFind (copy)
    local v17 = EquipShop.GetOnlyTag(p16);

    if v17 == "" then
        return false;
    end;

    return CfgFind.FindCfgByOnlyTag(v17) ~= nil;
end;

local function _setBtnState(p18, p19, p20, p21, p22) -- Line: 219
    -- upvalues: EquipShop (copy), _setEquipBtn (copy), TranslationHelper (copy), CfgFind (copy), MathMgr (copy), UIMgr (copy)
    local v23 = p18:FindFirstChild("BottomFrame") and p18:FindFirstChild("BottomFrame"):FindFirstChild("_Btns");

    if not v23 then
        return;
    end;

    local _BuyBtn = v23:FindFirstChild("_BuyBtn");
    local _RobuxBuyBtn = v23:FindFirstChild("_RobuxBuyBtn");
    local _EquipBtn = v23:FindFirstChild("_EquipBtn");
    local _JumpBtn = v23:FindFirstChild("_JumpBtn");
    local v24;

    if p21 then
        v24 = p22 == p19;
    else
        v24 = p21;
    end;

    local v25 = EquipShop.IsJumpEntry(p20);

    if p21 then
        if _BuyBtn then
            _BuyBtn.Visible = false;
        end;

        if _RobuxBuyBtn then
            _RobuxBuyBtn.Visible = false;
        end;

        if _JumpBtn then
            _JumpBtn.Visible = false;
        end;

        if _EquipBtn then
            _EquipBtn.Visible = true;
            _setEquipBtn(_EquipBtn, v24);
        end;

        return;
    end;

    if _EquipBtn then
        _EquipBtn.Visible = false;
    end;

    if v25 then
        if _BuyBtn then
            _BuyBtn.Visible = false;
        end;

        if _RobuxBuyBtn then
            _RobuxBuyBtn.Visible = false;
        end;

        if _JumpBtn then
            _JumpBtn.Visible = true;
            local EventName = _JumpBtn:FindFirstChild("EventName");

            if EventName and EventName:IsA("TextLabel") then
                TranslationHelper.SetText(EventName, p20.JumpName or "");
            end;
        end;

        return;
    end;

    if _JumpBtn then
        _JumpBtn.Visible = false;
    end;

    local v26 = EquipShop.IsCoinPurchasable(p20);
    local v27 = EquipShop.GetOnlyTag(p20);
    local v28;

    if v27 == "" then
        v28 = false;
    else
        v28 = CfgFind.FindCfgByOnlyTag(v27) ~= nil;
    end;

    if _BuyBtn then
        _BuyBtn.Visible = v26;

        if v26 then
            local v29 = tonumber(p20.Price) or 0;
            local Price = _BuyBtn:FindFirstChild("Price");

            if Price then
                local PriceNum = Price:FindFirstChild("PriceNum");

                if PriceNum and PriceNum:IsA("TextLabel") then
                    PriceNum.RichText = false;
                    TranslationHelper.SetText_UnTrans(PriceNum, MathMgr.getNumStr(v29));
                end;
            end;
        end;
    end;

    if _RobuxBuyBtn then
        _RobuxBuyBtn.Visible = v28;

        if v28 then
            UIMgr.SetRobuxBuyBtnPrice(_RobuxBuyBtn, EquipShop.GetOnlyTag(p20));
        end;
    end;
end;

local function _decorateItem(p30, p31, p32, p33) -- Line: 300
    -- upvalues: TranslationHelper (copy), UIMgr (copy), ItemType (copy), _formatEquipPowerText (copy)
    local Top = p30:FindFirstChild("Top");

    if Top then
        local Name = Top:FindFirstChild("Name");

        if Name then
            TranslationHelper.SetText(Name, p32.ZhName or "");
        end;

        local Xyd = Top:FindFirstChild("Xyd");

        if Xyd then
            UIMgr.setXydLabel(Xyd, p32.xyd or 1, false);
        end;

        local PowerFrame = Top:FindFirstChild("PowerFrame");

        if PowerFrame then
            local Power = PowerFrame:FindFirstChild("Power");

            if p33 == ItemType.Broom then
                local v34 = tonumber(p32.Dungeon);

                if v34 and Power then
                    PowerFrame.Visible = true;
                    TranslationHelper.SetText(Power, "阶段N", { v34 });
                else
                    PowerFrame.Visible = false;
                end;
            else
                local v35 = type(p32.attr) == "table" and p32.attr or (p32.attr and ({ p32.attr } or {}) or {});
                local v36 = type(p32.attrNum) == "table" and p32.attrNum or (p32.attrNum and ({ p32.attrNum } or {}) or {});
                local v37 = tonumber(v35[1]);
                local v38;

                if v37 then
                    v38 = _formatEquipPowerText(v37, v36[1]);
                else
                    v38 = nil;
                end;

                if v38 and Power then
                    PowerFrame.Visible = true;
                    TranslationHelper.SetText_UnTrans(Power, v38);
                else
                    PowerFrame.Visible = false;
                end;
            end;
        end;
    end;

    local v39 = p30:FindFirstChildOfClass("ViewportFrame");

    if v39 then
        v39.Visible = true;
        UIMgr.SetViewPort(v39, p31, true, {
            itemTp = p33
        });
    end;

    local BG = p30:FindFirstChild("BG");

    if BG then
        UIMgr.ApplyEquipmentItemBg(BG, p32.xyd or 1);
    end;
end;

local function _invokeRemote(u40, u41, u42) -- Line: 352
    -- upvalues: u2 (ref), NetWork (copy)
    if u2 then
        return false;
    end;

    u2 = true;
    local success, result = pcall(function() -- Line: 357
        -- upvalues: NetWork (ref), u40 (copy), u41 (copy), u42 (copy)
        return NetWork.InvokeServer(u40, {
            equipID = u41,
            itemType = u42
        });
    end);
    u2 = false;

    if success then
        success = result == true;
    end;

    return success;
end;

local function _updateItemBtnById(p43, p44, p45, p46) -- Line: 372
    -- upvalues: EquipShop (copy), _setBtnState (copy)
    local equipmentFrame = p43.equipmentFrame;

    if not equipmentFrame or p44 <= 0 then
        return;
    end;

    local v47 = equipmentFrame:FindFirstChild("Equip_" .. tostring(p44));

    if not (v47 and v47:IsA("Frame")) then
        return;
    end;

    local v48 = EquipShop.FindShopCfg(p44, p43.itemType);

    if not v48 then
        return;
    end;

    _setBtnState(v47, p44, v48, p45, p46);
end;

local function _optimisticOwnedEquip(p49, p50, p51) -- Line: 395
    -- upvalues: _updateItemBtnById (copy)
    _updateItemBtnById(p49, p50, true, p50);

    if p51 > 0 and p51 ~= p50 then
        _updateItemBtnById(p49, p51, true, p50);
    end;
end;

local function _bindActions(p52, u53, u54, u55) -- Line: 410
    -- upvalues: UIMgr (copy), EquipShop (copy), AddListen (copy), LocalPlayer (copy), NetMsg (copy), u2 (ref), NetWork (copy), ItemType (copy), GetData (copy), _updateItemBtnById (copy), CfgFind (copy), SystemBuyRoblox (copy), TipsModule (copy)
    local v56 = p52:FindFirstChild("BottomFrame") and p52:FindFirstChild("BottomFrame"):FindFirstChild("_Btns");
    local v57;

    if v56 then
        v57 = v56:FindFirstChild("_BuyBtn");
    else
        v57 = v56;
    end;

    local v58;

    if v57 then
        v58 = UIMgr.FindButtonInFrame(v57);
    else
        v58 = v57;
    end;

    if v58 and EquipShop.IsCoinPurchasable(u54) then
        AddListen.AddMouseCLick(v58, function() -- Line: 417
            -- upvalues: EquipShop (ref), LocalPlayer (ref), u53 (copy), u55 (copy), NetMsg (ref), u2 (ref), NetWork (ref), ItemType (ref), GetData (ref), _updateItemBtnById (ref)
            if EquipShop.OwnsInBag(LocalPlayer, u53, u55.itemType) then
                return;
            end;

            local v59 = EquipShop.GetEquippedCfgId(LocalPlayer, u55.saveKey);
            local EQUIP_SHOP_BUY = NetMsg.EQUIP_SHOP_BUY;
            local u60 = u53;
            local itemType = u55.itemType;
            local v61;

            if u2 then
                v61 = false;
            else
                u2 = true;
                local v62;
                v61, v62 = pcall(function() -- Line: 357
                    -- upvalues: NetWork (ref), EQUIP_SHOP_BUY (copy), u60 (copy), itemType (copy)
                    return NetWork.InvokeServer(EQUIP_SHOP_BUY, {
                        equipID = u60,
                        itemType = itemType
                    });
                end);
                u2 = false;

                if v61 then
                    v61 = v62 == true;
                end;
            end;

            if v61 then
                if u55.itemType == ItemType.Broom then
                    local v63;

                    if GetData.GetIsFly(LocalPlayer) then
                        v63 = true;
                    else
                        local StageJumping = LocalPlayer:FindFirstChild("StageJumping");
                        v63 = StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value > 0) and true or false;
                    end;

                    if v63 then
                        _updateItemBtnById(u55, u53, true, v59);

                        return;
                    end;
                end;

                local v64 = u55;
                local v65 = u53;
                _updateItemBtnById(v64, v65, true, v65);

                if v59 > 0 and v59 ~= v65 then
                    _updateItemBtnById(v64, v59, true, v65);
                end;
            end;
        end, v57);
    end;

    local v66;

    if v56 then
        v66 = v56:FindFirstChild("_RobuxBuyBtn");
    else
        v66 = v56;
    end;

    local v67;

    if v66 then
        v67 = UIMgr.FindButtonInFrame(v66);
    else
        v67 = v66;
    end;

    if v67 then
        local v68 = EquipShop.GetOnlyTag(u54);
        local v69;

        if v68 == "" then
            v69 = false;
        else
            v69 = CfgFind.FindCfgByOnlyTag(v68) ~= nil;
        end;

        if v69 then
            AddListen.AddMouseCLick(v67, function() -- Line: 436
                -- upvalues: EquipShop (ref), LocalPlayer (ref), u53 (copy), u55 (copy), u54 (copy), SystemBuyRoblox (ref)
                if EquipShop.OwnsInBag(LocalPlayer, u53, u55.itemType) then
                    return;
                end;

                local v70 = EquipShop.GetOnlyTag(u54);

                if v70 == "" or not (SystemBuyRoblox and SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, v70)) then
                end;
            end, v66);
        end;
    end;

    local v71;

    if v56 then
        v71 = v56:FindFirstChild("_EquipBtn");
    else
        v71 = v56;
    end;

    local v72;

    if v71 then
        v72 = UIMgr.FindButtonInFrame(v71);
    else
        v72 = v71;
    end;

    if v72 then
        AddListen.AddMouseCLick(v72, function() -- Line: 450
            -- upvalues: EquipShop (ref), LocalPlayer (ref), u53 (copy), u55 (copy), ItemType (ref), GetData (ref), TipsModule (ref), NetMsg (ref), u2 (ref), NetWork (ref), _updateItemBtnById (ref)
            if not EquipShop.OwnsInBag(LocalPlayer, u53, u55.itemType) then
                return;
            end;

            local v73 = EquipShop.GetEquippedCfgId(LocalPlayer, u55.saveKey);

            if v73 == u53 then
                return;
            end;

            local v74;

            if u55.itemType == ItemType.Broom then
                local v75;

                if GetData.GetIsFly(LocalPlayer) then
                    v75 = true;
                else
                    local StageJumping = LocalPlayer:FindFirstChild("StageJumping");
                    v75 = StageJumping and (StageJumping:IsA("NumberValue") and StageJumping.Value > 0) and true or false;
                end;

                if v75 then
                    TipsModule.ErrorTips(LocalPlayer, "飞行时无法替换扫把");
                    v74 = true;
                else
                    v74 = false;
                end;
            else
                v74 = false;
            end;

            if v74 then
                return;
            end;

            local EQUIP_SHOP_EQUIP = NetMsg.EQUIP_SHOP_EQUIP;
            local u76 = u53;
            local itemType = u55.itemType;
            local v77;

            if u2 then
                v77 = false;
            else
                u2 = true;
                local v78;
                v77, v78 = pcall(function() -- Line: 357
                    -- upvalues: NetWork (ref), EQUIP_SHOP_EQUIP (copy), u76 (copy), itemType (copy)
                    return NetWork.InvokeServer(EQUIP_SHOP_EQUIP, {
                        equipID = u76,
                        itemType = itemType
                    });
                end);
                u2 = false;

                if v77 then
                    v77 = v78 == true;
                end;
            end;

            if v77 then
                local v79 = u55;
                local v80 = u53;
                _updateItemBtnById(v79, v80, true, v80);

                if v73 > 0 and v73 ~= v80 then
                    _updateItemBtnById(v79, v73, true, v80);
                end;
            end;
        end, v71);
    end;

    if v56 then
        v56 = v56:FindFirstChild("_JumpBtn");
    end;

    local v81;

    if v56 then
        v81 = UIMgr.FindButtonInFrame(v56);
    else
        v81 = v56;
    end;

    if v81 and EquipShop.IsJumpEntry(u54) then
        AddListen.AddMouseCLick(v81, function() -- Line: 470
            -- upvalues: EquipShop (ref), u54 (copy), u55 (copy), NetWork (ref), NetMsg (ref)
            local v82, v83 = EquipShop.ParseJumpUI(u54);

            if type(v82) ~= "string" or v82 == "" then
                return;
            end;

            local shopUiName = u55.shopUiName;

            if type(shopUiName) == "string" and shopUiName ~= "" then
                NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, shopUiName, nil, false, true);
            end;

            NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, v82, v83 and {
                Tab = v83
            } or nil, true);
        end, v56);
    end;
end;

function v1.ResolveSyncRefreshIds(p84, p85, p86, p87) -- Line: 496
    local v88;

    if type(p84) == "table" then
        v88 = p84[1];
    else
        v88 = p84;
    end;

    if v88 == nil then
        return nil, nil;
    end;

    if v88 ~= p86.saveKey then
        if type(p84) == "table" and (p84[1] == "Bag" and (#p84 == 2 and (type(p85) == "table" and tonumber(p85.tp) == p86.itemType))) then
            local v89 = tonumber(p85.id) or 0;

            if v89 > 0 then
                return { v89 }, nil;
            end;
        end;

        return nil, nil;
    end;

    local v90 = tonumber(p85) or 0;
    local v91 = {};

    if v90 > 0 then
        table.insert(v91, v90);
    end;

    local v92 = tonumber(p87) or 0;

    if v92 > 0 and v92 ~= v90 then
        table.insert(v91, v92);
    end;

    if #v91 == 0 then
        return nil, v90;
    end;

    return v91, v90;
end;

function v1.RefreshItemStates(u93, p94) -- Line: 542
    -- upvalues: EquipShop (copy), LocalPlayer (copy), _updateItemBtnById (copy)
    local equipmentFrame = u93.equipmentFrame;

    if not equipmentFrame then
        return nil;
    end;

    local u95 = EquipShop.GetEquippedCfgId(LocalPlayer, u93.saveKey);

    local function refreshOne(p96) -- Line: 550
        -- upvalues: EquipShop (ref), LocalPlayer (ref), u93 (copy), _updateItemBtnById (ref), u95 (copy)
        if p96 <= 0 then
            return;
        end;

        _updateItemBtnById(u93, p96, EquipShop.OwnsInBag(LocalPlayer, p96, u93.itemType), u95);
    end;

    if p94 then
        for _, v in ipairs(p94) do
            local v97 = tonumber(v) or 0;

            if v97 > 0 then
                _updateItemBtnById(u93, v97, EquipShop.OwnsInBag(LocalPlayer, v97, u93.itemType), u95);
            end;
        end;

        return nil;
    end;

    for _, child in ipairs(equipmentFrame:GetChildren()) do
        if child:IsA("Frame") then
            local v98 = string.match(child.Name, "^Equip_(%d+)$");

            if v98 then
                local v99 = tonumber(v98) or 0;

                if v99 > 0 then
                    _updateItemBtnById(u93, v99, EquipShop.OwnsInBag(LocalPlayer, v99, u93.itemType), u95);
                end;
            end;
        end;
    end;

    return nil;
end;

function v1.RefreshList(p100) -- Line: 582
    -- upvalues: UIMgr (copy), EquipShop (copy), LocalPlayer (copy), _decorateItem (copy), _setBtnState (copy), UIanima (copy), AddListen (copy), _bindActions (copy)
    local equipmentFrame = p100.equipmentFrame;
    local equipmentTemp = p100.equipmentTemp;

    if not (equipmentFrame and equipmentTemp) then
        return nil;
    end;

    UIMgr.ClearScrollItems(equipmentFrame, {
        keepInstances = { equipmentTemp }
    });
    equipmentTemp.Visible = false;
    local v101 = EquipShop.GetEquippedCfgId(LocalPlayer, p100.saveKey);

    for _, v in ipairs(EquipShop.BuildShopList(p100.confName)) do
        local id = v.id;
        local cfg = v.cfg;
        local v102 = EquipShop.OwnsInBag(LocalPlayer, id, p100.itemType);
        local u103 = equipmentTemp:Clone();
        u103.Name = "Equip_" .. tostring(id);
        u103.Visible = true;
        u103.Parent = equipmentFrame;
        _decorateItem(u103, id, cfg, p100.itemType);
        _setBtnState(u103, id, cfg, v102, v101);

        if UIanima.SetViewportItemHoverEffect then
            AddListen.AddMouseHover(u103, function() -- Line: 606
                -- upvalues: UIanima (ref), u103 (copy)
                UIanima.SetViewportItemHoverEffect(u103, true, 1);
            end, function() -- Line: 608
                -- upvalues: UIanima (ref), u103 (copy)
                UIanima.SetViewportItemHoverEffect(u103, false);
            end);
        end;

        _bindActions(u103, id, cfg, p100);
    end;

    UIMgr.SetUIlistSize(equipmentFrame);

    if p100.scrollToEquipped then
        equipmentFrame.CanvasPosition = Vector2.new(0, equipmentFrame.CanvasPosition.Y);

        if v101 > 0 then
            local v104 = equipmentFrame:FindFirstChild("Equip_" .. tostring(v101));

            if v104 and v104:IsA("GuiObject") then
                UIMgr.ScheduleScrollToChild(equipmentFrame, v104, {
                    alignX = "left",
                    skipLayoutRefresh = true,
                    waitSec = 0.12,
                    layoutWaitFrames = 8
                });
            end;
        end;
    end;

    return nil;
end;

return v1;