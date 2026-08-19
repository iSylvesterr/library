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
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.Parent.AllUI);
local ItemType = EnumMgr.ItemType;
local PlrAttr = EnumMgr.PlrAttr;
local u2 = false;

local function _isEquipTp(p3) -- Line: 57
    -- upvalues: ItemType (copy)
    return (p3 == ItemType.Weapon or p3 == ItemType.Armor) and true or p3 == ItemType.Broom;
end;

local function _shouldHideStock(p4, p5) -- Line: 67
    local v6;

    if (tonumber(p4.Sort) or 0) == 1 then
        v6 = p5 <= 1;
    else
        v6 = false;
    end;

    return v6;
end;

local function _getRemain(p7, p8) -- Line: 78
    -- upvalues: PlayerData (copy), LocalPlayer (copy), CfgFind (copy)
    local v9 = PlayerData.GetPlrDataByKey(LocalPlayer, "Event");
    local v10;

    if type(v9) == "table" and type(v9.Shop) == "table" then
        local v11 = v9.Shop[tostring(p7)];
        v10 = tonumber(v11) or 0;
    else
        v10 = 0;
    end;

    return CfgFind.GetEventShopRemain(v10, p8);
end;

local function _formatEquipPowerText(p12, p13) -- Line: 93
    -- upvalues: PlrAttr (copy), MathMgr (copy)
    local v14 = tonumber(p13);

    if p12 == PlrAttr.Train_Base then
        if v14 then
            return "+" .. MathMgr.getNumStr(v14);
        end;

        return "+" .. tostring(p13);
    end;

    if p12 ~= PlrAttr.Train_Mul then
        return nil;
    end;

    if v14 then
        return "x " .. MathMgr.getNumStr(v14 + 1);
    end;

    return "x " .. tostring(p13);
end;

local function _getBtns(p15) -- Line: 115
    local BottomFrame = p15:FindFirstChild("BottomFrame");

    if not BottomFrame then
        return nil;
    end;

    local Btns = BottomFrame:FindFirstChild("Btns");

    if Btns and Btns:IsA("Frame") then
        return Btns;
    end;

    return nil;
end;

local function _getBuyBtn(p16) -- Line: 132
    local BuyBtn = p16:FindFirstChild("BuyBtn");

    if BuyBtn and BuyBtn:IsA("Frame") then
        return BuyBtn;
    end;

    return nil;
end;

local function _getBuyClickBtn(p17) -- Line: 145
    -- upvalues: UIMgr (copy)
    return UIMgr.FindButtonInFrame(p17);
end;

local function _decorateForeverBadge(p18, p19) -- Line: 154
    -- upvalues: GetData (copy), TranslationHelper (copy)
    local v20 = p18:FindFirstChild("永久");

    if not (v20 and v20:IsA("GuiObject")) then
        return;
    end;

    local v21 = GetData.Alchemy.ShouldGrantEventPotionAsPay(p19);
    v20.Visible = v21;

    if v21 and v20:IsA("TextLabel") then
        TranslationHelper.SetText(v20, "永久");
    end;
end;

local function _decorateTop(p22, p23, p24, p25) -- Line: 173
    -- upvalues: TranslationHelper (copy), UIMgr (copy), _decorateForeverBadge (copy), ItemType (copy), _formatEquipPowerText (copy)
    local Top = p22:FindFirstChild("Top");

    if not Top then
        return;
    end;

    local Name = Top:FindFirstChild("Name");

    if Name and Name:IsA("TextLabel") then
        TranslationHelper.SetText(Name, p23.ZhName or "");
    end;

    local Xyd = Top:FindFirstChild("Xyd");

    if Xyd and Xyd:IsA("TextLabel") then
        UIMgr.setXydLabel(Xyd, p23.xyd or 1, false);
    end;

    _decorateForeverBadge(Top, p25);
    local PowerFrame = Top:FindFirstChild("PowerFrame");

    if not (PowerFrame and PowerFrame:IsA("Frame")) then
        return;
    end;

    if p24 ~= ItemType.Weapon and p24 ~= ItemType.Armor and p24 ~= ItemType.Broom then
        PowerFrame.Visible = false;

        return;
    end;

    local Power = PowerFrame:FindFirstChild("Power");
    local PowerIcon = PowerFrame:FindFirstChild("PowerIcon");

    if PowerIcon and PowerIcon:IsA("GuiObject") then
        PowerIcon.Visible = p24 ~= ItemType.Broom;
    end;

    if p24 == ItemType.Broom then
        local v26 = tonumber(p23.Dungeon);

        if not (v26 and (Power and Power:IsA("TextLabel"))) then
            PowerFrame.Visible = false;

            return;
        end;

        PowerFrame.Visible = true;
        TranslationHelper.SetText(Power, "阶段N", { v26 });

        return;
    end;

    local v27 = type(p23.attr) == "table" and p23.attr or (p23.attr and ({ p23.attr } or {}) or {});
    local v28 = type(p23.attrNum) == "table" and p23.attrNum or (p23.attrNum and { p23.attrNum } or {});
    local v29 = tonumber(v27[1]);
    local v30;

    if v29 then
        v30 = _formatEquipPowerText(v29, v28[1]);
    else
        v30 = nil;
    end;

    if not (v30 and (Power and Power:IsA("TextLabel"))) then
        PowerFrame.Visible = false;

        return;
    end;

    PowerFrame.Visible = true;
    TranslationHelper.SetText_UnTrans(Power, v30);
end;

local function _decorateBuyAndStock(p31, p32, p33, p34) -- Line: 234
    -- upvalues: TranslationHelper (copy), MathMgr (copy), CfgFind (copy), UIMgr (copy)
    local Stock = p31:FindFirstChild("Stock");

    if Stock and Stock:IsA("TextLabel") then
        if p34 or p33 <= 0 then
            Stock.Visible = false;
        else
            Stock.Visible = true;
            TranslationHelper.SetText(Stock, "库存为", { MathMgr.getNumStr(p33) });
        end;
    end;

    local BottomFrame = p31:FindFirstChild("BottomFrame");
    local BottomFrame2 = p31:FindFirstChild("BottomFrame");
    local v35;

    if BottomFrame2 then
        v35 = BottomFrame2:FindFirstChild("Btns");

        if not (v35 and v35:IsA("Frame")) then
            v35 = nil;
        end;
    else
        v35 = nil;
    end;

    if BottomFrame then
        BottomFrame = BottomFrame:FindFirstChild("已售罄");
    end;

    local v36 = p33 <= 0;

    if BottomFrame and BottomFrame:IsA("GuiObject") then
        BottomFrame.Visible = v36;
    end;

    if v35 then
        v35.Visible = not v36;
    end;

    if v35 then
        v35 = v35:FindFirstChild("BuyBtn");

        if not (v35 and v35:IsA("Frame")) then
            v35 = nil;
        end;
    end;

    local v37 = v35 and v35:FindFirstChild("Price");

    if v37 then
        local PriceNum = v37:FindFirstChild("PriceNum");

        if PriceNum and PriceNum:IsA("TextLabel") then
            PriceNum.RichText = false;
            TranslationHelper.SetText_UnTrans(PriceNum, MathMgr.getNumStr(tonumber(p32.price) or 0));
        end;

        local Icon = v37:FindFirstChild("Icon");

        if Icon and Icon:IsA("ImageLabel") then
            local v38 = CfgFind.FindCfgByID(CfgFind.GetEventCurrencyItemId());
            local v39 = v38 and tostring(v38.Icon or "") or "";

            if v39 ~= "" and v39 ~= "0" then
                UIMgr.SetImage(Icon, v39);
                Icon.Visible = true;
            end;
        end;
    end;
end;

local function _decorateItem(p40, p41) -- Line: 286
    -- upvalues: CfgFind (copy), Log (copy), _decorateTop (copy), UIMgr (copy), _getRemain (copy), _decorateBuyAndStock (copy)
    local v42 = tonumber(p41.ItemId) or 0;
    local v43 = CfgFind.FindCfgByID(v42);

    if not v43 then
        Log.warn("[EventShopTab] 无物品配置:", v42);

        return;
    end;

    _decorateTop(p40, v43, tonumber(v43.tp), v42);
    UIMgr.ApplyItemIconOrViewport(p40, v42, (tostring(v43.Icon or "")));
    local BG = p40:FindFirstChild("BG");

    if BG and BG:IsA("Frame") then
        UIMgr.ApplyEquipmentItemBg(BG, v43.xyd or 1);
    end;

    local v44 = CfgFind.ParseEventShopStock(p41);
    local v45;

    if (tonumber(p41.Sort) or 0) == 1 then
        v45 = v44 <= 1;
    else
        v45 = false;
    end;

    _decorateBuyAndStock(p40, p41, _getRemain(tonumber(p41.id) or 0, v44), v45);
end;

local function _bindBuy(p46, u47) -- Line: 314
    -- upvalues: Log (copy), UIMgr (copy), AddListen (copy), u2 (ref), NetWork (copy), NetMsg (copy), u1 (copy)
    if p46:GetAttribute("EventShopBuyBound") == true then
        return;
    end;

    local BottomFrame = p46:FindFirstChild("BottomFrame");
    local v48;

    if BottomFrame then
        v48 = BottomFrame:FindFirstChild("Btns");

        if not (v48 and v48:IsA("Frame")) then
            v48 = nil;
        end;
    else
        v48 = nil;
    end;

    if not v48 then
        Log.warn("[EventShopTab] 缺少 Btns:", p46:GetFullName());

        return;
    end;

    local BuyBtn = v48:FindFirstChild("BuyBtn");

    if not (BuyBtn and BuyBtn:IsA("Frame")) then
        BuyBtn = nil;
    end;

    if not BuyBtn then
        Log.warn("[EventShopTab] 缺少 BuyBtn:", p46:GetFullName());

        return;
    end;

    local v49 = UIMgr.FindButtonInFrame(BuyBtn);

    if not v49 then
        Log.warn("[EventShopTab] 缺少购买按钮 BuyBtn.Btn:", p46:GetFullName());

        return;
    end;

    p46:SetAttribute("EventShopBuyBound", true);
    p46:SetAttribute("EventShopId", u47);
    AddListen.AddMouseCLick(v49, function() -- Line: 335
        -- upvalues: u2 (ref), NetWork (ref), NetMsg (ref), u47 (copy), u1 (ref)
        if u2 then
            return;
        end;

        u2 = true;
        local success, result = pcall(function() -- Line: 340
            -- upvalues: NetWork (ref), NetMsg (ref), u47 (ref)
            return NetWork.InvokeServer(NetMsg.EVENT_SHOP_BUY, u47);
        end);
        u2 = false;

        if success and result == true then
            u1.RefreshStates();
        end;
    end, BuyBtn);
end;

function u1.RefreshStates(u50) -- Line: 355
    -- upvalues: CfgFind (copy), _getRemain (copy), _decorateBuyAndStock (copy), AllUI (copy)
    local u51 = {};

    for _, v in ipairs(CfgFind.GetEventShopList()) do
        local v52 = tonumber(v.id) or 0;

        if v52 > 0 then
            u51[v52] = v;
        end;
    end;

    local function _applyOne(p53) -- Line: 364
        -- upvalues: u50 (copy), u51 (copy), CfgFind (ref), _getRemain (ref), _decorateBuyAndStock (ref)
        local v54 = tonumber(p53:GetAttribute("EventShopId"));

        if not v54 then
            local v55 = string.match(p53.Name, "^Shop_(%d+)$");
            v54 = v55 and tonumber(v55) or nil;
        end;

        if not v54 then
            return;
        end;

        if u50 and v54 ~= u50 then
            return;
        end;

        local v56 = u51[v54];

        if not v56 then
            return;
        end;

        local v57 = CfgFind.ParseEventShopStock(v56);
        local v58 = _getRemain(v54, v57);
        local v59;

        if (tonumber(v56.Sort) or 0) == 1 then
            v59 = v57 <= 1;
        else
            v59 = false;
        end;

        _decorateBuyAndStock(p53, v56, v58, v59);
    end;

    if AllUI.BigTemp.Visible then
        _applyOne(AllUI.BigTemp);
    end;

    for _, child in ipairs(AllUI.SmallFrame:GetChildren()) do
        if child:IsA("GuiObject") and string.sub(child.Name, 1, 5) == "Shop_" then
            _applyOne(child);
        end;
    end;
end;

function u1.Clear() -- Line: 398
    -- upvalues: UIMgr (copy), AllUI (copy)
    UIMgr.ClearScrollItems(AllUI.SmallFrame, {
        keepInstances = { AllUI.Temp }
    });
end;

function u1.Refresh() -- Line: 405
    -- upvalues: AllUI (copy), UIMgr (copy), CfgFind (copy), _decorateItem (copy), _bindBuy (copy)
    AllUI.Temp.Visible = false;
    AllUI.BigTemp.Visible = false;
    UIMgr.ClearScrollItems(AllUI.SmallFrame, {
        keepInstances = { AllUI.Temp }
    });
    AllUI.BigTemp:SetAttribute("EventShopBuyBound", nil);
    AllUI.BigTemp:SetAttribute("EventShopId", nil);
    local v60 = {};
    local v61 = nil;

    for _, v in ipairs(CfgFind.GetEventShopList()) do
        local v62 = tonumber(v.Sort) or 0;

        if v62 == 1 then
            v61 = v;
        elseif v62 >= 2 and v62 <= 7 then
            table.insert(v60, v);
        end;
    end;

    if v61 then
        AllUI.BigTemp.Visible = true;
        AllUI.BigTemp.LayoutOrder = 1;
        _decorateItem(AllUI.BigTemp, v61);
        _bindBuy(AllUI.BigTemp, tonumber(v61.id) or 0);
    end;

    for _, v in ipairs(v60) do
        local v63 = tonumber(v.id) or 0;
        local v64 = AllUI.Temp:Clone();
        v64.Name = "Shop_" .. tostring(v63);
        v64.Visible = true;
        v64.LayoutOrder = tonumber(v.Sort) or v63;
        v64.Parent = AllUI.SmallFrame;
        _decorateItem(v64, v);
        _bindBuy(v64, v63);
    end;

    UIMgr.SetUIlistSize(AllUI.SmallFrame);
end;

return u1;