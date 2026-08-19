-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local GetData = UtilsSystem.GetData;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local SystemGuide = UtilsSystem.SystemGuide;
local TipsConfig = UtilsSystem.TipsConfig;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local InsMgr = UtilsSystem.InsMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local AllUI = require(script.AllUI);
local ItemType = EnumMgr.ItemType;
local Alchemy = GetData.Alchemy;
local UIRoot = AllUI.UIRoot;

local function _ensureHideMainMarker() -- Line: 64
    -- upvalues: InsMgr (copy), UIRoot (copy)
    InsMgr.GetIns("隐藏主界面", "BoolValue", UIRoot).Value = true;
end;

InsMgr.GetIns("隐藏主界面", "BoolValue", UIRoot).Value = true;
local u2 = {};
local u3 = false;
local u4 = false;
local u5 = false;
local u6 = false;
local u7 = nil;
local u8 = Color3.new(1, 1, 1);
local u9 = Color3.new(0, 0, 0);

local function _getRecipeOnlyTag(p10) -- Line: 89
    if p10 then
        p10 = p10.OnlyTag;
    end;

    return (type(p10) ~= "string" or p10 == "") and "" or p10;
end;

local function _hasRobuxPurchase(p11) -- Line: 103
    -- upvalues: CfgFind (copy)
    if p11 then
        p11 = p11.OnlyTag;
    end;

    local v12 = (type(p11) ~= "string" or p11 == "") and "" or p11;

    if v12 == "" then
        return false;
    end;

    return CfgFind.FindCfgByOnlyTag(v12) ~= nil;
end;

local function _setCfgNameLabel(p13, p14) -- Line: 118
    -- upvalues: TranslationHelper (copy), UIMgr (copy)
    TranslationHelper.SetText(p13, p14.ZhName or "");
    local v15 = tonumber(p14.xyd);

    if v15 then
        UIMgr.AddGradientColor(v15, p13, true);

        return;
    end;

    UIMgr.RemoveGradientColor(p13);
end;

local function _setUnknownNameLabel(p16, p17) -- Line: 135
    -- upvalues: TranslationHelper (copy), UIMgr (copy)
    TranslationHelper.SetText_UnTrans(p16, "???");

    if p17 then
        p17 = tonumber(p17.xyd);
    end;

    if p17 then
        UIMgr.AddGradientColor(p17, p16, true);

        return;
    end;

    UIMgr.RemoveGradientColor(p16);
end;

local function _setPotionRowDisplay(p18, p19, p20, p21) -- Line: 154
    -- upvalues: UIMgr (copy), u8 (copy), u9 (copy), TranslationHelper (copy)
    local Icon = p18:FindFirstChild("Icon", true);

    if Icon and Icon:IsA("ImageLabel") then
        UIMgr.SetImage(Icon, p19.Icon);
        local v22;

        if p21 then
            v22 = u8;
        else
            v22 = u9;
        end;

        Icon.ImageColor3 = v22;
    end;

    local Name = p18:FindFirstChild("Name", true);

    if Name and Name:IsA("TextLabel") then
        if p20 then
            TranslationHelper.SetText(Name, p19.ZhName or "");
            local v23 = tonumber(p19.xyd);

            if v23 then
                UIMgr.AddGradientColor(v23, Name, true);

                return;
            end;

            UIMgr.RemoveGradientColor(Name);

            return;
        end;

        TranslationHelper.SetText_UnTrans(Name, "???");

        if p19 then
            p19 = tonumber(p19.xyd);
        end;

        if p19 then
            UIMgr.AddGradientColor(p19, Name, true);

            return;
        end;

        UIMgr.RemoveGradientColor(Name);
    end;
end;

local function _setMaterialRowDisplay(p24, p25, p26) -- Line: 178
    -- upvalues: UIMgr (copy), u8 (copy), u9 (copy), TranslationHelper (copy)
    local Icon = p24:FindFirstChild("Icon", true);

    if Icon and Icon:IsA("ImageLabel") then
        UIMgr.SetImage(Icon, p25.Icon);
        local v27;

        if p26 then
            v27 = u8;
        else
            v27 = u9;
        end;

        Icon.ImageColor3 = v27;
    end;

    local Name = p24:FindFirstChild("Name", true);

    if Name and Name:IsA("TextLabel") then
        if p26 then
            TranslationHelper.SetText(Name, p25.ZhName or "");
            local v28 = tonumber(p25.xyd);

            if v28 then
                UIMgr.AddGradientColor(v28, Name, true);

                return;
            end;

            UIMgr.RemoveGradientColor(Name);

            return;
        end;

        TranslationHelper.SetText_UnTrans(Name, "???");

        if p25 then
            p25 = tonumber(p25.xyd);
        end;

        if p25 then
            UIMgr.AddGradientColor(p25, Name, true);

            return;
        end;

        UIMgr.RemoveGradientColor(Name);
    end;
end;

local function _isMaterialBrewing() -- Line: 199
    -- upvalues: Alchemy (copy), LocalPlayer (copy)
    return Alchemy.IsPlayerMaterialBrewing(LocalPlayer);
end;

local function _canShowOkBtnBg(p29) -- Line: 209
    -- upvalues: Alchemy (copy), LocalPlayer (copy), PlayerData (copy)
    if not (p29 and Alchemy.CanMeetRecipeRebirth(LocalPlayer, p29)) then
        return false;
    end;

    if Alchemy.IsPlayerMaterialBrewing(LocalPlayer) then
        return false;
    end;

    local v30 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v30) == "table" then
        return Alchemy.CanCraftRecipe(v30, p29);
    end;

    return false;
end;

local function _setOkBtnVisual(p31, p32) -- Line: 230
    if not p31 then
        return;
    end;

    local Bg = p31:FindFirstChild("Bg");
    local UnBg = p31:FindFirstChild("UnBg");

    if Bg and Bg:IsA("GuiObject") then
        Bg.Visible = not p32;
    end;

    if UnBg and UnBg:IsA("GuiObject") then
        UnBg.Visible = p32;
    end;
end;

local function _refreshAllRowBtnStates() -- Line: 249
    -- upvalues: u2 (copy), CfgFind (copy), _canShowOkBtnBg (copy), _setOkBtnVisual (copy), UIMgr (copy)
    for i, v in pairs(u2) do
        local v33 = CfgFind.FindAlchemyRecipeById(i);
        local v34 = not (v33 and _canShowOkBtnBg(v33));
        local Btns = v:FindFirstChild("Btns", true);

        if Btns then
            Btns = Btns:FindFirstChild("OkBtn");
        end;

        if Btns then
            _setOkBtnVisual(Btns, v34);
            local v35 = UIMgr.FindButtonInFrame(Btns);

            if v35 then
                v35.Active = true;
            end;
        end;
    end;
end;

local function _setRowMarkVisual(p36, p37) -- Line: 273
    local Title = p36:FindFirstChild("Title");

    if Title then
        Title = Title:FindFirstChild("标记Frame");
    end;

    if Title then
        Title = Title:FindFirstChild("标记Btn");
    end;

    if not Title then
        return;
    end;

    local v38 = Title:FindFirstChild("标记");
    local v39 = Title:FindFirstChild("未标记");

    if v38 and v38:IsA("GuiObject") then
        v38.Visible = p37;
    end;

    if v39 and v39:IsA("GuiObject") then
        v39.Visible = not p37;
    end;
end;

local function _refreshAllMarkVisuals() -- Line: 295
    -- upvalues: Alchemy (copy), LocalPlayer (copy), u2 (copy), _setRowMarkVisual (copy)
    local v40 = Alchemy.GetMarkedRecipeId(LocalPlayer);

    for i, v in pairs(u2) do
        _setRowMarkVisual(v, i == v40);
    end;
end;

local function _refreshMaterialCounts() -- Line: 307
    -- upvalues: PlayerData (copy), LocalPlayer (copy), u2 (copy), CfgFind (copy), Alchemy (copy), TranslationHelper (copy)
    local v41 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    for i, v in pairs(u2) do
        local v42 = CfgFind.FindAlchemyRecipeById(i);

        if v42 then
            local MaterialList = v:FindFirstChild("MaterialList", true);
            local MID = v42.MID;
            local NeedCount = v42.NeedCount;

            if MaterialList and (type(MID) == "table" and type(NeedCount) == "table") then
                for i2 = 1, #MID do
                    local v43 = tonumber(MID[i2]);
                    local v44 = tonumber(NeedCount[i2]) or 0;

                    if v43 and v44 > 0 then
                        local v45 = MaterialList:FindFirstChild("Material_" .. tostring(v43));

                        if v45 then
                            v45 = v45:FindFirstChild("Count", true);
                        end;

                        if v45 and v45:IsA("TextLabel") then
                            local v46 = type(v41) ~= "table" and 0 or Alchemy.GetMaterialOwnedCount(v41, v43);
                            TranslationHelper.SetText_UnTrans(v45, Alchemy.FormatNeedCount(v46, v44));
                            v45.TextColor3 = Alchemy.GetNeedCountColor(v46, v44);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function _refreshPotionReveal(p47) -- Line: 340
    -- upvalues: CfgFind (copy), ItemType (copy), Alchemy (copy), LocalPlayer (copy), u2 (copy), _setPotionRowDisplay (copy)
    if p47 <= 0 then
        return;
    end;

    local v48 = CfgFind.FindCfgByID(p47, ItemType.Potion);

    if not v48 then
        return;
    end;

    local v49 = Alchemy.IsPotionBrewed(LocalPlayer, p47);

    for i, v in pairs(u2) do
        local v50 = CfgFind.FindAlchemyRecipeById(i);

        if v50 and tonumber(v50.PID) == p47 then
            local v51 = Alchemy.CanMeetRecipeRebirth(LocalPlayer, v50);
            local Potion = v:FindFirstChild("Potion", true);

            if Potion then
                _setPotionRowDisplay(Potion, v48, v51, v49);
            end;
        end;
    end;
end;

local function _scheduleStateRefresh() -- Line: 366
    -- upvalues: u5 (ref), UIRoot (copy), _refreshMaterialCounts (copy), _refreshAllRowBtnStates (copy), _refreshAllMarkVisuals (copy)
    if u5 then
        return;
    end;

    u5 = true;
    task.defer(function() -- Line: 371
        -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
        u5 = false;

        if not UIRoot.Visible then
            return;
        end;

        _refreshMaterialCounts();
        _refreshAllRowBtnStates();
        _refreshAllMarkVisuals();
    end);
end;

local function _isMaterialBagSync(p52, p53) -- Line: 389
    -- upvalues: ItemType (copy), PlayerData (copy), LocalPlayer (copy)
    if type(p52) ~= "table" or (p52[1] ~= "Bag" or not p52[2]) then
        return false;
    end;

    if #p52 == 2 then
        if type(p53) == "table" then
            return tonumber(p53.tp) == ItemType.Material;
        end;

        return p53 == nil;
    end;

    if p52[3] ~= "count" and p52[3] ~= "lock" then
        return false;
    end;

    local v54 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local v55;

    if type(v54) == "table" then
        v55 = v54[tostring(p52[2])];
    else
        v55 = false;
    end;

    local v56;

    if type(v55) == "table" then
        v56 = tonumber(v55.tp) == ItemType.Material;
    else
        v56 = false;
    end;

    return v56;
end;

local function _setRowRobuxBtnState(p57, p58) -- Line: 414
    -- upvalues: CfgFind (copy), UIMgr (copy)
    local Btns = p57:FindFirstChild("Btns", true);

    if Btns then
        Btns = Btns:FindFirstChild("RobuxBuyBtn");
    end;

    if not Btns then
        return;
    end;

    local v59;

    if p58 then
        v59 = p58.OnlyTag;
    else
        v59 = p58;
    end;

    local v60 = (type(v59) ~= "string" or v59 == "") and "" or v59;
    local v61;

    if v60 == "" then
        v61 = false;
    else
        v61 = CfgFind.FindCfgByOnlyTag(v60) ~= nil;
    end;

    Btns.Visible = v61;

    if not v61 then
        return;
    end;

    if p58 then
        p58 = p58.OnlyTag;
    end;

    UIMgr.SetRobuxBuyBtnPrice(Btns, (type(p58) ~= "string" or p58 == "") and "" or p58);
end;

local function _canCraftOnClient(p62) -- Line: 436
    -- upvalues: Alchemy (copy), LocalPlayer (copy), TipsModule (copy), CfgFind (copy), PlayerData (copy)
    if Alchemy.IsPlayerMaterialBrewing(LocalPlayer) then
        TipsModule.ErrorTips(LocalPlayer, "已有药水正在炼制", nil);

        return false;
    end;

    local v63 = CfgFind.FindAlchemyRecipeById(p62);

    if not v63 then
        return false;
    end;

    if not Alchemy.CanMeetRecipeRebirth(LocalPlayer, v63) then
        TipsModule.ErrorTips(LocalPlayer, "该配方需要重生N次", { Alchemy.GetRecipeNeedRebirth(v63) });

        return false;
    end;

    local v64 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v64) ~= "table" then
        return false;
    end;

    if Alchemy.CanCraftRecipe(v64, v63) then
        return true;
    end;

    local MID = v63.MID;
    local NeedCount = v63.NeedCount;

    if type(MID) == "table" and type(NeedCount) == "table" then
        for i = 1, #MID do
            local v65 = tonumber(MID[i]);
            local v66 = tonumber(NeedCount[i]) or 0;

            if v65 and v66 > 0 then
                local v67 = Alchemy.GetMaterialOwnedCount(v64, v65);

                if v67 < v66 then
                    TipsModule.TipsNotEnoughItem(LocalPlayer, v65, v66, v67);

                    return false;
                end;
            end;
        end;
    end;

    TipsModule.ErrorTips(LocalPlayer, "材料不足", nil);

    return false;
end;

local function _setRecipeTitleLabel(p68, p69, p70) -- Line: 483
    -- upvalues: TranslationHelper (copy), UIMgr (copy)
    TranslationHelper.SetText(p68, p69.ZhName or "");

    if p70 then
        p70 = tonumber(p70.xyd);
    end;

    if p70 then
        UIMgr.AddGradientColor(p70, p68, true);

        return;
    end;

    UIMgr.RemoveGradientColor(p68);
end;

local function _setRowTitleSection(p71, p72) -- Line: 500
    -- upvalues: Alchemy (copy), LocalPlayer (copy), TranslationHelper (copy), CfgFind (copy), ItemType (copy), UIMgr (copy)
    local v73 = Alchemy.CanMeetRecipeRebirth(LocalPlayer, p72);
    local Title = p71:FindFirstChild("Title");

    if not Title then
        return;
    end;

    local Rebirth = Title:FindFirstChild("Rebirth");
    local v74 = Title:FindFirstChild("标记Frame");
    local v75 = Title:FindFirstChild("配方标题");

    if Rebirth and Rebirth:IsA("GuiObject") then
        Rebirth.Visible = not v73;

        if not v73 then
            local Rebirth2 = Rebirth:FindFirstChild("Rebirth");

            if Rebirth2 and Rebirth2:IsA("TextLabel") then
                local v76 = Rebirth2:GetAttribute("Title");
                local v77 = (type(v76) ~= "string" or v76 == "") and "重生N次解锁该配方" or v76;
                TranslationHelper.SetText(Rebirth2, v77, { Alchemy.GetRecipeNeedRebirth(p72) });
            end;
        end;
    end;

    if v74 and v74:IsA("GuiObject") then
        v74.Visible = v73;
    end;

    if v75 and v75:IsA("GuiObject") then
        v75.Visible = v73;

        if v73 then
            local Recipe = v75:FindFirstChild("Recipe");
            local v78 = tonumber(p72.PID);
            local v79;

            if v78 then
                v79 = CfgFind.FindCfgByID(v78, ItemType.Potion);
            else
                v79 = nil;
            end;

            if Recipe and Recipe:IsA("TextLabel") then
                TranslationHelper.SetText(Recipe, p72.ZhName or "");

                if v79 then
                    v79 = tonumber(v79.xyd);
                end;

                if v79 then
                    UIMgr.AddGradientColor(v79, Recipe, true);

                    return;
                end;

                UIMgr.RemoveGradientColor(Recipe);
            end;
        end;
    end;
end;

local function _fillRecipeRow(p80, p81) -- Line: 547
    -- upvalues: _setRowTitleSection (copy), Alchemy (copy), LocalPlayer (copy), CfgFind (copy), ItemType (copy), _setPotionRowDisplay (copy), PlayerData (copy), _setMaterialRowDisplay (copy), TranslationHelper (copy)
    local v82 = p80:FindFirstChild("选中");

    if v82 and v82:IsA("GuiObject") then
        v82.Visible = false;
    end;

    p80:SetAttribute("Title", nil);
    _setRowTitleSection(p80, p81);
    local v83 = Alchemy.CanMeetRecipeRebirth(LocalPlayer, p81);
    local Potion = p80:FindFirstChild("Potion", true);
    local v84 = tonumber(p81.PID);
    local v85;

    if v84 then
        v85 = CfgFind.FindCfgByID(v84, ItemType.Potion);
    else
        v85 = nil;
    end;

    if Potion and v85 then
        local v86;

        if v84 then
            v86 = Alchemy.IsPotionBrewed(LocalPlayer, v84);
        else
            v86 = false;
        end;

        _setPotionRowDisplay(Potion, v85, v83, v86);
    end;

    local MaterialList = p80:FindFirstChild("MaterialList", true);

    if not MaterialList then
        return;
    end;

    local MaterialTemp = MaterialList:FindFirstChild("MaterialTemp");
    local Add = MaterialList:FindFirstChild("Add");

    if not MaterialTemp then
        return;
    end;

    for _, child in MaterialList:GetChildren() do
        if child:IsA("GuiObject") and (child ~= MaterialTemp and (child ~= Add and child.Name ~= "UIListLayout")) then
            child:Destroy();
        end;
    end;

    MaterialTemp.Visible = false;

    if Add and Add:IsA("GuiObject") then
        Add.Visible = false;
    end;

    local v87 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local MID = p81.MID;
    local NeedCount = p81.NeedCount;

    if type(MID) ~= "table" or type(NeedCount) ~= "table" then
        return;
    end;

    local v88 = 0;

    for i = 1, #MID do
        local v89 = tonumber(MID[i]);
        local v90 = tonumber(NeedCount[i]) or 0;

        if v89 and v90 > 0 then
            v88 = v88 + 1;
            local v91 = MaterialTemp:Clone();
            v91.Name = "Material_" .. tostring(v89);
            v91.LayoutOrder = v88;
            v91.Visible = true;
            v91.Parent = MaterialList;
            local v92 = CfgFind.FindCfgByID(v89, ItemType.Material);

            if v92 then
                _setMaterialRowDisplay(v91, v92, v83);
            end;

            local Count = v91:FindFirstChild("Count", true);

            if Count and Count:IsA("TextLabel") then
                local v93 = type(v87) ~= "table" and 0 or Alchemy.GetMaterialOwnedCount(v87, v89);
                TranslationHelper.SetText_UnTrans(Count, Alchemy.FormatNeedCount(v93, v90));
                Count.TextColor3 = Alchemy.GetNeedCountColor(v93, v90);
            end;

            if i < #MID and (Add and Add:IsA("GuiObject")) then
                v88 = v88 + 1;
                local v94 = Add:Clone();
                v94.Name = "Add_" .. tostring(i);
                v94.LayoutOrder = v88;
                v94.Visible = true;
                v94.Parent = MaterialList;
            end;
        end;
    end;
end;

local function _getUiScaleValue() -- Line: 638
    -- upvalues: LocalPlayer (copy), UIRoot (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return 1;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if not (ScreenGui and ScreenGui:IsA("ScreenGui")) then
        return 1;
    end;

    local v95 = ScreenGui:FindFirstChildOfClass("UIScale");
    local v96 = UIRoot;

    if v96 then
        v96 = v96:FindFirstChildOfClass("UIScale");
    end;

    local v97 = 1;

    if v95 then
        v97 = v97 * v95.Scale;
    end;

    if v96 then
        v97 = v97 * v96.Scale;
    end;

    return v97 <= 0 and 1 or v97;
end;

local function _syncScrollCanvas(u98) -- Line: 669
    -- upvalues: UIMgr (copy), _getUiScaleValue (copy)
    local u99 = u98:FindFirstChildOfClass("UIListLayout");

    if not u99 then
        UIMgr.SetUIlistSize(u98);

        return;
    end;

    local function apply() -- Line: 676
        -- upvalues: u98 (copy), _getUiScaleValue (ref), u99 (copy)
        if not u98.Parent then
            return;
        end;

        u98.AutomaticCanvasSize = Enum.AutomaticSize.None;
        local v100 = _getUiScaleValue();
        local v101 = u98:FindFirstChildOfClass("UIPadding");
        u98.CanvasSize = UDim2.new(0, 0, 0, (math.max(u99.AbsoluteContentSize.Y / v100 + (not v101 and 0 or v101.PaddingTop.Offset + v101.PaddingBottom.Offset + (v101.PaddingTop.Scale + v101.PaddingBottom.Scale) * (u98.AbsoluteSize.Y / v100)), u98.AbsoluteSize.Y / v100)));
    end;

    apply();
    task.defer(apply);
end;

local function _refresh(p102) -- Line: 706
    -- upvalues: AllUI (copy), u2 (copy), UIMgr (copy), Alchemy (copy), LocalPlayer (copy), _fillRecipeRow (copy), _setRowRobuxBtnState (copy), _setRowMarkVisual (copy), u7 (ref), _syncScrollCanvas (copy), _refreshAllRowBtnStates (copy)
    local Scroll = AllUI.Scroll;
    local Temp = AllUI.Temp;

    if not (Scroll and Temp) then
        return;
    end;

    table.clear(u2);
    UIMgr.ClearScrollItems(Scroll, {
        keepInstances = { Temp }
    });
    Temp.Visible = false;
    local v103 = Alchemy.GetRecipeList();
    local v104 = Alchemy.GetMarkedRecipeId(LocalPlayer);

    for i, v in ipairs(v103) do
        local v105 = tonumber(v.recipeId);

        if v105 then
            local v106 = Temp:Clone();
            v106.Name = "Recipe_" .. tostring(v105);
            v106.LayoutOrder = i;
            v106.Visible = true;
            v106.Parent = Scroll;
            _fillRecipeRow(v106, v);
            _setRowRobuxBtnState(v106, v);
            _setRowMarkVisual(v106, v105 == v104);
            u7(v106, v105, v);
            u2[v105] = v106;
        end;
    end;

    _syncScrollCanvas(Scroll);
    _refreshAllRowBtnStates();

    if p102 then
        Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, 0);
        local v107 = v104 > 0 and u2[v104];

        if v107 then
            UIMgr.ScheduleScrollToChild(Scroll, v107, {
                alignY = "top",
                skipLayoutRefresh = true,
                waitSec = 0.12,
                layoutWaitFrames = 8
            });
        end;
    end;
end;

local function _ensureBrewStateListen() -- Line: 761
    -- upvalues: u6 (ref), AddListen (copy), u5 (ref), UIRoot (copy), _refreshMaterialCounts (copy), _refreshAllRowBtnStates (copy), _refreshAllMarkVisuals (copy), LocalPlayer (copy), Alchemy (copy)
    if u6 then
        return;
    end;

    u6 = true;

    local function bindValue(p108) -- Line: 767
        -- upvalues: AddListen (ref), u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
        if p108 and p108:IsA("NumberValue") then
            AddListen.NumValueAdd(p108, function(p109) -- Line: 769
                -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                if u5 then
                    return;
                end;

                u5 = true;
                task.defer(function() -- Line: 371
                    -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                    u5 = false;

                    if not UIRoot.Visible then
                        return;
                    end;

                    _refreshMaterialCounts();
                    _refreshAllRowBtnStates();
                    _refreshAllMarkVisuals();
                end);
            end, false);
        end;
    end;

    task.defer(function() -- Line: 775
        -- upvalues: LocalPlayer (ref), Alchemy (ref), AddListen (ref), u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
        local v110 = LocalPlayer:WaitForChild(Alchemy.GetBrewPotionIdValueName(), 10);

        if v110 and v110:IsA("NumberValue") then
            AddListen.NumValueAdd(v110, function(p111) -- Line: 769
                -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                if u5 then
                    return;
                end;

                u5 = true;
                task.defer(function() -- Line: 371
                    -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                    u5 = false;

                    if not UIRoot.Visible then
                        return;
                    end;

                    _refreshMaterialCounts();
                    _refreshAllRowBtnStates();
                    _refreshAllMarkVisuals();
                end);
            end, false);
        end;

        local v112 = LocalPlayer:WaitForChild(Alchemy.GetBrewFinishUnixValueName(), 10);

        if v112 and v112:IsA("NumberValue") then
            AddListen.NumValueAdd(v112, function(p113) -- Line: 769
                -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                if u5 then
                    return;
                end;

                u5 = true;
                task.defer(function() -- Line: 371
                    -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                    u5 = false;

                    if not UIRoot.Visible then
                        return;
                    end;

                    _refreshMaterialCounts();
                    _refreshAllRowBtnStates();
                    _refreshAllMarkVisuals();
                end);
            end, false);
        end;

        local v114 = LocalPlayer:WaitForChild(Alchemy.GetMarkFolderName(), 10);

        if v114 and v114:IsA("Folder") then
            local v115 = v114:WaitForChild(Alchemy.GetMarkRecipeIdValueName(), 5);

            if v115 and v115:IsA("NumberValue") then
                AddListen.NumValueAdd(v115, function(p116) -- Line: 782
                    -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                    if u5 then
                        return;
                    end;

                    u5 = true;
                    task.defer(function() -- Line: 371
                        -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                        u5 = false;

                        if not UIRoot.Visible then
                            return;
                        end;

                        _refreshMaterialCounts();
                        _refreshAllRowBtnStates();
                        _refreshAllMarkVisuals();
                    end);
                end, false);
            end;
        end;
    end);
end;

local function _invokeCraft(u117) -- Line: 796
    -- upvalues: u3 (ref), NetWork (copy), NetMsg (copy), Log (copy)
    if u3 then
        return false;
    end;

    u3 = true;
    local success, result = pcall(function() -- Line: 801
        -- upvalues: NetWork (ref), NetMsg (ref), u117 (copy)
        return NetWork.InvokeServer(NetMsg.ALCHEMY_CRAFT_RECIPE, {
            recipeId = u117
        });
    end);
    u3 = false;

    if success then
        return result == true;
    end;

    Log.warn("[AlchemyUI] InvokeServer error:", result);

    return false;
end;

local function _invokeMark(u118) -- Line: 818
    -- upvalues: u4 (ref), NetWork (copy), NetMsg (copy), Log (copy)
    if u4 then
        return false;
    end;

    u4 = true;
    local success, result = pcall(function() -- Line: 823
        -- upvalues: NetWork (ref), NetMsg (ref), u118 (copy)
        return NetWork.InvokeServer(NetMsg.ALCHEMY_MARK_RECIPE, {
            recipeId = u118
        });
    end);
    u4 = false;

    if success then
        return result == true;
    end;

    Log.warn("[AlchemyUI] Mark InvokeServer error:", result);

    return false;
end;

u7 = function(p119, u120, u121) -- Line: 842, Name: _bindRowButtonsImpl
    -- upvalues: UIMgr (copy), _setOkBtnVisual (copy), _canShowOkBtnBg (copy), AddListen (copy), _canCraftOnClient (copy), _refreshAllRowBtnStates (copy), u3 (ref), NetWork (copy), NetMsg (copy), Log (copy), CfgFind (copy), SystemBuyRoblox (copy), LocalPlayer (copy), Alchemy (copy), u4 (ref), _refreshAllMarkVisuals (copy), TipsModule (copy), TipsConfig (copy)
    local Btns = p119:FindFirstChild("Btns", true);

    if not Btns then
        return;
    end;

    local OkBtn = Btns:FindFirstChild("OkBtn");
    local v122;

    if OkBtn then
        v122 = UIMgr.FindButtonInFrame(OkBtn);
    else
        v122 = OkBtn;
    end;

    if v122 then
        _setOkBtnVisual(OkBtn, not _canShowOkBtnBg(u121));
        AddListen.AddMouseCLick(v122, function() -- Line: 852
            -- upvalues: _canCraftOnClient (ref), u120 (copy), _refreshAllRowBtnStates (ref), u3 (ref), NetWork (ref), NetMsg (ref), Log (ref)
            if not _canCraftOnClient(u120) then
                _refreshAllRowBtnStates();

                return;
            end;

            local u123 = u120;
            local v124;

            if u3 then
                v124 = false;
            else
                u3 = true;
                local success, result = pcall(function() -- Line: 801
                    -- upvalues: NetWork (ref), NetMsg (ref), u123 (copy)
                    return NetWork.InvokeServer(NetMsg.ALCHEMY_CRAFT_RECIPE, {
                        recipeId = u123
                    });
                end);
                u3 = false;

                if success then
                    v124 = result == true;
                else
                    Log.warn("[AlchemyUI] InvokeServer error:", result);
                    v124 = false;
                end;
            end;

            if v124 then
                NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Alchemy", nil, false, true);
            end;
        end, OkBtn);
    end;

    local RobuxBuyBtn = Btns:FindFirstChild("RobuxBuyBtn");
    local v125;

    if RobuxBuyBtn then
        v125 = UIMgr.FindButtonInFrame(RobuxBuyBtn);
    else
        v125 = RobuxBuyBtn;
    end;

    if v125 then
        local v126;

        if u121 then
            v126 = u121.OnlyTag;
        else
            v126 = u121;
        end;

        local v127 = (type(v126) ~= "string" or v126 == "") and "" or v126;
        local v128;

        if v127 == "" then
            v128 = false;
        else
            v128 = CfgFind.FindCfgByOnlyTag(v127) ~= nil;
        end;

        if v128 then
            AddListen.AddMouseCLick(v125, function() -- Line: 867
                -- upvalues: u121 (copy), SystemBuyRoblox (ref), LocalPlayer (ref)
                local v129 = u121;

                if v129 then
                    v129 = v129.OnlyTag;
                end;

                local v130 = (type(v129) ~= "string" or v129 == "") and "" or v129;

                if v130 == "" or not SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, v130) then
                end;
            end, RobuxBuyBtn);
        end;
    end;

    local Title = p119:FindFirstChild("Title");

    if Title then
        Title = Title:FindFirstChild("标记Frame");
    end;

    if Title then
        Title = Title:FindFirstChild("标记Btn");
    end;

    local v131;

    if Title then
        v131 = UIMgr.FindButtonInFrame(Title);
    else
        v131 = Title;
    end;

    if v131 then
        AddListen.AddMouseCLick(v131, function() -- Line: 880
            -- upvalues: Alchemy (ref), LocalPlayer (ref), u120 (copy), u4 (ref), NetWork (ref), NetMsg (ref), Log (ref), _refreshAllMarkVisuals (ref), TipsModule (ref), TipsConfig (ref)
            local v132 = Alchemy.GetMarkedRecipeId(LocalPlayer) == u120;
            local u133 = u120;
            local v134;

            if u4 then
                v134 = false;
            else
                u4 = true;
                local success, result = pcall(function() -- Line: 823
                    -- upvalues: NetWork (ref), NetMsg (ref), u133 (copy)
                    return NetWork.InvokeServer(NetMsg.ALCHEMY_MARK_RECIPE, {
                        recipeId = u133
                    });
                end);
                u4 = false;

                if success then
                    v134 = result == true;
                else
                    Log.warn("[AlchemyUI] Mark InvokeServer error:", result);
                    v134 = false;
                end;
            end;

            if v134 then
                _refreshAllMarkVisuals();

                if not v132 then
                    TipsModule.RainbowTips(LocalPlayer, "已标记配方所需材料", nil, nil, TipsConfig.GRADIENT_TIP_YELLOW);
                end;
            end;
        end, Title);
    end;
end;

PlayerData.ListenClientSync(function(p135, p136) -- Line: 895
    -- upvalues: UIRoot (copy), _isMaterialBagSync (copy), u5 (ref), _refreshMaterialCounts (copy), _refreshAllRowBtnStates (copy), _refreshAllMarkVisuals (copy), _refreshPotionReveal (copy)
    if not UIRoot.Visible then
        return;
    end;

    local v137;

    if type(p135) == "table" then
        v137 = p135[1];
    else
        v137 = p135;
    end;

    if v137 == "Bag" then
        if _isMaterialBagSync(p135, p136) then
            if u5 then
                return;
            end;

            u5 = true;
            task.defer(function() -- Line: 371
                -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                u5 = false;

                if not UIRoot.Visible then
                    return;
                end;

                _refreshMaterialCounts();
                _refreshAllRowBtnStates();
                _refreshAllMarkVisuals();
            end);
        end;

        return;
    end;

    if v137 == "Record" and type(p135) == "table" then
        local v138 = p135[2];

        if type(v138) == "string" then
            local v139 = string.match(v138, "^炼制药水_(%d+)$");
            local u140 = tonumber(v139);

            if u140 and (type(p136) == "number" and p136 > 0) then
                task.defer(function() -- Line: 912
                    -- upvalues: UIRoot (ref), _refreshPotionReveal (ref), u140 (copy)
                    if UIRoot.Visible then
                        _refreshPotionReveal(u140);
                    end;
                end);
            end;
        end;
    end;
end);
local v141 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v141 then
    AddListen.AddMouseCLick(v141, function() -- Line: 924
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Alchemy", nil, false, true);
    end, AllUI.Exit);
end;

function v1.updateUi(p142, p143) -- Line: 929
    -- upvalues: UIRoot (copy), _refresh (copy)
    if UIRoot.Visible then
        _refresh();
    end;
end;

function v1.openUi(p144) -- Line: 935
    -- upvalues: InsMgr (copy), UIRoot (copy), UIMgr (copy), u6 (ref), AddListen (copy), u5 (ref), _refreshMaterialCounts (copy), _refreshAllRowBtnStates (copy), _refreshAllMarkVisuals (copy), LocalPlayer (copy), Alchemy (copy), _refresh (copy), SystemGuide (copy)
    InsMgr.GetIns("隐藏主界面", "BoolValue", UIRoot).Value = true;
    UIRoot:SetAttribute("HideButtomLeft", true);
    UIMgr.SetMainUIVisible(false, true);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();

    if not u6 then
        u6 = true;

        local function _(p145) -- Line: 767
            -- upvalues: AddListen (ref), u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
            if p145 and p145:IsA("NumberValue") then
                AddListen.NumValueAdd(p145, function(p146) -- Line: 769
                    -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                    if u5 then
                        return;
                    end;

                    u5 = true;
                    task.defer(function() -- Line: 371
                        -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                        u5 = false;

                        if not UIRoot.Visible then
                            return;
                        end;

                        _refreshMaterialCounts();
                        _refreshAllRowBtnStates();
                        _refreshAllMarkVisuals();
                    end);
                end, false);
            end;
        end;

        task.defer(function() -- Line: 775
            -- upvalues: LocalPlayer (ref), Alchemy (ref), AddListen (ref), u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
            local v147 = LocalPlayer:WaitForChild(Alchemy.GetBrewPotionIdValueName(), 10);

            if v147 and v147:IsA("NumberValue") then
                AddListen.NumValueAdd(v147, function(p148) -- Line: 769
                    -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                    if u5 then
                        return;
                    end;

                    u5 = true;
                    task.defer(function() -- Line: 371
                        -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                        u5 = false;

                        if not UIRoot.Visible then
                            return;
                        end;

                        _refreshMaterialCounts();
                        _refreshAllRowBtnStates();
                        _refreshAllMarkVisuals();
                    end);
                end, false);
            end;

            local v149 = LocalPlayer:WaitForChild(Alchemy.GetBrewFinishUnixValueName(), 10);

            if v149 and v149:IsA("NumberValue") then
                AddListen.NumValueAdd(v149, function(p150) -- Line: 769
                    -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                    if u5 then
                        return;
                    end;

                    u5 = true;
                    task.defer(function() -- Line: 371
                        -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                        u5 = false;

                        if not UIRoot.Visible then
                            return;
                        end;

                        _refreshMaterialCounts();
                        _refreshAllRowBtnStates();
                        _refreshAllMarkVisuals();
                    end);
                end, false);
            end;

            local v151 = LocalPlayer:WaitForChild(Alchemy.GetMarkFolderName(), 10);

            if v151 and v151:IsA("Folder") then
                local v152 = v151:WaitForChild(Alchemy.GetMarkRecipeIdValueName(), 5);

                if v152 and v152:IsA("NumberValue") then
                    AddListen.NumValueAdd(v152, function(p153) -- Line: 782
                        -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                        if u5 then
                            return;
                        end;

                        u5 = true;
                        task.defer(function() -- Line: 371
                            -- upvalues: u5 (ref), UIRoot (ref), _refreshMaterialCounts (ref), _refreshAllRowBtnStates (ref), _refreshAllMarkVisuals (ref)
                            u5 = false;

                            if not UIRoot.Visible then
                                return;
                            end;

                            _refreshMaterialCounts();
                            _refreshAllRowBtnStates();
                            _refreshAllMarkVisuals();
                        end);
                    end, false);
                end;
            end;
        end);
    end;

    _refresh(true);
    SystemGuide.CompleteGuide(LocalPlayer, "炼制药水", 1);
end;

function v1.closeUi(p154) -- Line: 947
    -- upvalues: u2 (copy), UIMgr (copy), AllUI (copy), UIRoot (copy)
    table.clear(u2);
    UIMgr.ClearScrollItems(AllUI.Scroll, {
        keepInstances = { AllUI.Temp }
    });
    UIRoot.Visible = false;
    UIRoot:SetAttribute("HideButtomLeft", nil);
    UIMgr.SetMainUIVisible(nil);
    UIMgr.UpdateBlurVisible();
end;

return v1;