-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local SequenceManager = UtilsSystem.SequenceManager;
local AllUI = require(script.AllUI);
local u2 = {
    Power1 = true,
    Power2 = true,
    Power3 = true
};
local Train_Mul = EnumMgr.PlrAttr.Train_Mul;
local GamePass = EnumMgr.RobuxType.GamePass;
local BLOCK_BUY_LIMIT = GetData.Shop.BLOCK_BUY_LIMIT;
local ROBUX_MATERIAL_OFFER_FOLDER = GetData.Shop.ROBUX_MATERIAL_OFFER_FOLDER;
local UIRoot = AllUI.UIRoot;
local Scroll = AllUI.Scroll;
local u3 = {};
local u4 = false;
local u5 = false;

local function _readOnlyTag(p6) -- Line: 92
    local v7 = p6:FindFirstChild("付费项");

    if not (v7 and v7:IsA("StringValue")) then
        return nil;
    end;

    local Value = v7.Value;

    if type(Value) == "string" and Value ~= "" then
        return Value;
    end;

    return nil;
end;

local function _collectPaidFrames() -- Line: 109
    -- upvalues: Scroll (copy)
    local v8 = {};

    for _, descendant in ipairs(Scroll:GetDescendants()) do
        if descendant:IsA("StringValue") and descendant.Name == "付费项" then
            local Parent = descendant.Parent;

            if Parent and Parent:IsA("Frame") then
                table.insert(v8, Parent);
            end;
        end;
    end;

    return v8;
end;

local function _getFirstItemId(p9) -- Line: 128
    local itemID = p9.itemID;

    if type(itemID) ~= "table" then
        return nil;
    end;

    for _, v in ipairs(itemID) do
        local v10 = tonumber(v);

        if v10 and v10 ~= 0 then
            return v10;
        end;
    end;

    for _, v in pairs(itemID) do
        local v11 = tonumber(v);

        if v11 and v11 ~= 0 then
            return v11;
        end;
    end;

    return nil;
end;

local function _findGrantItemCfg(p12) -- Line: 154
    -- upvalues: CfgFind (copy), EnumMgr (copy)
    return CfgFind.FindCfgByID(p12) or (CfgFind.FindCfgByID(p12, EnumMgr.ItemType.Potion) or (CfgFind.FindCfgByID(p12, EnumMgr.ItemType.Weapon) or CfgFind.FindCfgByID(p12, EnumMgr.ItemType.Armor)));
end;

local function _getArmorTrainMulDisplayStr(p13) -- Line: 176
    -- upvalues: Train_Mul (copy), MathMgr (copy)
    local v14 = type(p13.attr) == "table" and p13.attr or (p13.attr and ({ p13.attr } or {}) or {});
    local v15 = type(p13.attrNum) == "table" and p13.attrNum or (p13.attrNum and { p13.attrNum } or {});

    for i, v in ipairs(v14) do
        if tonumber(v) == Train_Mul then
            local v16 = tonumber(v15[i]);

            if v16 then
                return MathMgr.getNumStr(v16 + 1);
            end;
        end;
    end;

    return nil;
end;

local function _shouldShowOwned(p17, p18, p19) -- Line: 199
    -- upvalues: GamePass (copy), GetData (copy), LocalPlayer (copy), BLOCK_BUY_LIMIT (copy)
    if p19 then
        return tonumber(p17.cost) == GamePass and GetData.IsHasPass(LocalPlayer, p18) and true or GetData.GetShopBuyBlockReason(LocalPlayer, p17) == BLOCK_BUY_LIMIT;
    end;

    return false;
end;

local function _setRobuxBuyBtnOwnedState(p20, p21) -- Line: 218
    local v22 = p20:FindFirstChild("已拥有");

    if not (v22 and v22:IsA("GuiObject")) then
        return;
    end;

    for _, child in ipairs(p20:GetChildren()) do
        if child:IsA("GuiObject") then
            if child.Name == "已拥有" then
                child.Visible = p21;
            else
                child.Visible = not p21;
            end;
        end;
    end;
end;

local function _getRobuxMaterialCfg(p23) -- Line: 240
    -- upvalues: GetData (copy), LocalPlayer (copy), CfgFind (copy), EnumMgr (copy)
    local v24 = GetData.GetRobuxMaterialOfferId(LocalPlayer, p23);

    if v24 then
        return CfgFind.FindCfgByID(v24, EnumMgr.ItemType.Material);
    end;

    return nil;
end;

local function _refreshIcon(p25, p26, p27) -- Line: 256
    -- upvalues: GetData (copy), UIMgr (copy)
    if not GetData.IsRobuxMaterialPack(p26) then
        return;
    end;

    local Icon = p25:FindFirstChild("Icon");

    if not (Icon and Icon:IsA("ImageLabel")) then
        return;
    end;

    if p27 then
        p27 = p27.Icon;
    end;

    if p27 == nil or p27 == "" then
        Icon.Image = "";

        return;
    end;

    UIMgr.SetImage(Icon, p27);
end;

local function _refreshMaterialPrice(p28, p29, p30) -- Line: 282
    -- upvalues: GetData (copy), TranslationHelper (copy), MathMgr (copy)
    if not GetData.IsRobuxMaterialPack(p29) then
        return;
    end;

    local Price = p28:FindFirstChild("Price");

    if not Price then
        return;
    end;

    local PriceNum = Price:FindFirstChild("PriceNum");

    if not (PriceNum and PriceNum:IsA("TextLabel")) then
        return;
    end;

    if p30 then
        p30 = p30.GoldValue;
    end;

    local v31 = tonumber(p30) or 0;
    local v32 = math.floor(v31);
    local v33 = math.max(0, v32);
    PriceNum.RichText = false;
    TranslationHelper.SetText_UnTrans(PriceNum, MathMgr.getNumStr(v33));
end;

local function _refreshPaidPowerDisplay(p34, p35, p36) -- Line: 309
    -- upvalues: GetData (copy), LocalPlayer (copy), MathMgr (copy), TranslationHelper (copy), u2 (copy)
    local v37 = GetData.CalcPaidPowerGrant(LocalPlayer, p35);

    if v37 == nil then
        return false;
    end;

    local getNumStr = MathMgr.getNumStr;
    local v38 = math.floor(v37);
    local v39 = getNumStr((math.max(0, v38)));

    if p35 == "Power4" then
        if p36 then
            TranslationHelper.SetText(p36, "+N魔力值", { v39 });
        end;

        return true;
    end;

    if u2[p35] then
        local Power = p34:FindFirstChild("Power");

        if Power and Power:IsA("TextLabel") then
            TranslationHelper.SetText_UnTrans(Power, "+" .. v39);
        end;
    end;

    return false;
end;

local function _refreshLimitedGrantDisplay(p40, p41, p42, p43) -- Line: 342
    -- upvalues: _getFirstItemId (copy), _findGrantItemCfg (copy), TranslationHelper (copy), _getArmorTrainMulDisplayStr (copy)
    local v44 = p40 == "LimitedArmor1";

    if not (p40 == "LimitedPotion1" or v44) then
        return false, false;
    end;

    local v45 = _getFirstItemId(p41);
    local v46;

    if v45 then
        v46 = _findGrantItemCfg(v45);
    else
        v46 = nil;
    end;

    if p42 then
        TranslationHelper.SetText(p42, v46 and (v46.ZhName or "") or "");
    end;

    local v47;

    if v44 and p43 then
        local v48;

        if v46 then
            v48 = _getArmorTrainMulDisplayStr(v46);
        else
            v48 = nil;
        end;

        if v48 then
            TranslationHelper.SetText(p43, "xN魔力值", { v48 });
            v47 = true;
        else
            TranslationHelper.SetText_UnTrans(p43, "");
            v47 = true;
        end;
    else
        v47 = false;
    end;

    return true, v47;
end;

local function _refreshPaidFrame(p49) -- Line: 380
    -- upvalues: CfgFind (copy), SequenceManager (copy), GetData (copy), LocalPlayer (copy), EnumMgr (copy), _refreshPaidPowerDisplay (copy), _refreshLimitedGrantDisplay (copy), TranslationHelper (copy), _refreshIcon (copy), _refreshMaterialPrice (copy), GamePass (copy), BLOCK_BUY_LIMIT (copy), _setRobuxBuyBtnOwnedState (copy), UIMgr (copy)
    local v50 = p49:FindFirstChild("付费项");
    local v51;

    if v50 and v50:IsA("StringValue") then
        v51 = v50.Value;

        if type(v51) ~= "string" or v51 == "" then
            v51 = nil;
        end;
    else
        v51 = nil;
    end;

    if not v51 then
        return;
    end;

    local v52 = CfgFind.FindCfgByOnlyTag(v51);

    if not v52 then
        return;
    end;

    local Effect = p49:FindFirstChild("Effect");

    if Effect then
        SequenceManager:PlaySequence(Effect, "付费商店_金币_星", 5, true);
    end;

    local Name = p49:FindFirstChild("Name");

    if not (Name and Name:IsA("TextLabel")) then
        Name = nil;
    end;

    local Des = p49:FindFirstChild("Des");

    if not (Des and Des:IsA("TextLabel")) then
        Des = nil;
    end;

    local v53 = GetData.IsRobuxMaterialPack(v51);
    local v54;

    if v53 then
        local v55 = GetData.GetRobuxMaterialOfferId(LocalPlayer, v51);

        if v55 then
            v54 = CfgFind.FindCfgByID(v55, EnumMgr.ItemType.Material);
        else
            v54 = nil;
        end;
    else
        v54 = nil;
    end;

    local v56 = _refreshPaidPowerDisplay(p49, v51, Name);
    local v57, v58 = _refreshLimitedGrantDisplay(v51, v52, Name, Des);

    if Name and not (v56 or v57) then
        local v59;

        if v53 then
            v59 = v54 and (v54.ZhName or "") or "";
        else
            v59 = v52.ZhName or "";
        end;

        TranslationHelper.SetText(Name, v59);
    end;

    if Des and not v58 then
        local ZhDes = v52.ZhDes;

        if type(ZhDes) == "string" and ZhDes ~= "" then
            TranslationHelper.SetText(Des, ZhDes);
        else
            TranslationHelper.SetText_UnTrans(Des, "");
        end;
    end;

    _refreshIcon(p49, v51, v54);
    _refreshMaterialPrice(p49, v51, v54);
    local RobuxBuyBtn = p49:FindFirstChild("RobuxBuyBtn");

    if not (RobuxBuyBtn and RobuxBuyBtn:IsA("Frame")) then
        return;
    end;

    local v60 = RobuxBuyBtn:FindFirstChild("已拥有");
    local v61;

    if v60 == nil then
        v61 = false;
    else
        v61 = v60:IsA("GuiObject");
    end;

    local v62;

    if v61 then
        v62 = tonumber(v52.cost) == GamePass and GetData.IsHasPass(LocalPlayer, v51) and true or GetData.GetShopBuyBlockReason(LocalPlayer, v52) == BLOCK_BUY_LIMIT;
    else
        v62 = false;
    end;

    _setRobuxBuyBtnOwnedState(RobuxBuyBtn, v62);

    if not v62 then
        UIMgr.SetRobuxBuyBtnPrice(RobuxBuyBtn, v51);
    end;
end;

local function _refreshAll() -- Line: 450
    -- upvalues: u3 (ref), _refreshPaidFrame (copy)
    for _, v in ipairs(u3) do
        _refreshPaidFrame(v);
    end;
end;

local function _bindBuyButtons() -- Line: 461
    -- upvalues: u4 (ref), u3 (ref), UIMgr (copy), AddListen (copy), SystemBuyRoblox (copy), LocalPlayer (copy)
    if u4 then
        return;
    end;

    u4 = true;

    for _, v in ipairs(u3) do
        local RobuxBuyBtn = v:FindFirstChild("RobuxBuyBtn");

        if RobuxBuyBtn and RobuxBuyBtn:IsA("Frame") then
            local v63 = UIMgr.FindButtonInFrame(RobuxBuyBtn);

            if v63 then
                AddListen.AddMouseCLick(v63, function() -- Line: 472
                    -- upvalues: v (copy), SystemBuyRoblox (ref), LocalPlayer (ref)
                    local v64 = v:FindFirstChild("付费项");
                    local v65;

                    if v64 and v64:IsA("StringValue") then
                        v65 = v64.Value;

                        if type(v65) ~= "string" or v65 == "" then
                            v65 = nil;
                        end;
                    else
                        v65 = nil;
                    end;

                    if not v65 then
                        return;
                    end;

                    SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, v65);
                end, RobuxBuyBtn);
            end;
        end;
    end;
end;

local function _bindWatchers() -- Line: 489
    -- upvalues: u5 (ref), PlayerData (copy), UIRoot (copy), u3 (ref), _refreshPaidFrame (copy), LocalPlayer (copy), AddListen (copy), ROBUX_MATERIAL_OFFER_FOLDER (copy)
    if u5 then
        return;
    end;

    u5 = true;
    PlayerData.ListenClientSync(function(p66, p67) -- Line: 495
        -- upvalues: UIRoot (ref), u3 (ref), _refreshPaidFrame (ref)
        if not UIRoot.Visible then
            return;
        end;

        if p66 == nil then
            for _, v in ipairs(u3) do
                _refreshPaidFrame(v);
            end;

            return;
        end;

        if type(p66) == "table" then
            p66 = p66[1];
        end;

        if p66 == "Shop" or p66 == "GamePass" then
            for _, v in ipairs(u3) do
                _refreshPaidFrame(v);
            end;
        end;
    end);
    task.spawn(function() -- Line: 509
        -- upvalues: LocalPlayer (ref), UIRoot (ref), u3 (ref), _refreshPaidFrame (ref), AddListen (ref)
        local GamePass2 = LocalPlayer:WaitForChild("GamePass", (1 / 0));

        local function onPassChanged() -- Line: 511
            -- upvalues: UIRoot (ref), u3 (ref), _refreshPaidFrame (ref)
            if UIRoot.Visible then
                for _, v in ipairs(u3) do
                    _refreshPaidFrame(v);
                end;
            end;
        end;

        local function bindPassValue(p68) -- Line: 516
            -- upvalues: AddListen (ref), onPassChanged (copy)
            if p68:IsA("NumberValue") then
                AddListen.NumValueAdd(p68, onPassChanged, false);
            end;
        end;

        for _, child in ipairs(GamePass2:GetChildren()) do
            if child:IsA("NumberValue") then
                AddListen.NumValueAdd(child, onPassChanged, false);
            end;
        end;

        GamePass2.ChildAdded:Connect(bindPassValue);
    end);
    task.spawn(function() -- Line: 527
        -- upvalues: LocalPlayer (ref), ROBUX_MATERIAL_OFFER_FOLDER (ref), UIRoot (ref), u3 (ref), _refreshPaidFrame (ref), AddListen (ref)
        local v69 = LocalPlayer:WaitForChild(ROBUX_MATERIAL_OFFER_FOLDER, (1 / 0));

        local function onOfferChanged() -- Line: 529
            -- upvalues: UIRoot (ref), u3 (ref), _refreshPaidFrame (ref)
            if UIRoot.Visible then
                for _, v in ipairs(u3) do
                    _refreshPaidFrame(v);
                end;
            end;
        end;

        local function bindOfferValue(p70) -- Line: 534
            -- upvalues: AddListen (ref), onOfferChanged (copy)
            if p70:IsA("NumberValue") then
                AddListen.NumValueAdd(p70, onOfferChanged, false);
            end;
        end;

        for _, child in ipairs(v69:GetChildren()) do
            if child:IsA("NumberValue") then
                AddListen.NumValueAdd(child, onOfferChanged, false);
            end;
        end;

        v69.ChildAdded:Connect(bindOfferValue);
    end);
    task.spawn(function() -- Line: 546
        -- upvalues: LocalPlayer (ref), AddListen (ref), UIRoot (ref), u3 (ref), _refreshPaidFrame (ref)
        local ExpAdd = LocalPlayer:WaitForChild("RebirthBonus", (1 / 0)):WaitForChild("ExpAdd", (1 / 0));

        if ExpAdd:IsA("NumberValue") then
            AddListen.NumValueAdd(ExpAdd, function() -- Line: 550
                -- upvalues: UIRoot (ref), u3 (ref), _refreshPaidFrame (ref)
                if UIRoot.Visible then
                    for _, v in ipairs(u3) do
                        _refreshPaidFrame(v);
                    end;
                end;
            end, false);
        end;
    end);
end;

local function _ensureInit() -- Line: 564
    -- upvalues: u3 (ref), _collectPaidFrames (copy), _bindBuyButtons (copy), _bindWatchers (copy)
    if #u3 == 0 then
        u3 = _collectPaidFrames();
    end;

    _bindBuyButtons();
    _bindWatchers();
end;

local v71 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v71 then
    AddListen.AddMouseCLick(v71, function() -- Line: 577
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "RuboxShop", nil, false, true);
    end, AllUI.Exit);
end;

if #u3 == 0 then
    u3 = _collectPaidFrames();
end;

_bindBuyButtons();
_bindWatchers();

function v1.updateUi(p72, p73) -- Line: 594
    -- upvalues: u3 (ref), _collectPaidFrames (copy), _bindBuyButtons (copy), _bindWatchers (copy), _refreshPaidFrame (copy)
    if #u3 == 0 then
        u3 = _collectPaidFrames();
    end;

    _bindBuyButtons();
    _bindWatchers();

    for _, v in ipairs(u3) do
        _refreshPaidFrame(v);
    end;
end;

function v1.openUi(p74) -- Line: 604
    -- upvalues: UIMgr (copy), UIRoot (copy), u3 (ref), _collectPaidFrames (copy), _bindBuyButtons (copy), _bindWatchers (copy), _refreshPaidFrame (copy)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();

    if #u3 == 0 then
        u3 = _collectPaidFrames();
    end;

    _bindBuyButtons();
    _bindWatchers();

    for _, v in ipairs(u3) do
        _refreshPaidFrame(v);
    end;
end;

function v1.closeUi(p75) -- Line: 617
    -- upvalues: UIRoot (copy), UIMgr (copy)
    UIRoot.Visible = false;
    UIMgr.SetMainUIVisible(nil);
    UIMgr.UpdateBlurVisible();
end;

return v1;