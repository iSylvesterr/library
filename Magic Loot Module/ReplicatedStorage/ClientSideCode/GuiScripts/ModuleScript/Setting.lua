-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local AddListen = UtilsSystem.AddListen;
local Log = UtilsSystem.Log;
local v2 = CfgFind.GetCfgByName("settingConf") or {};
local UIMgr = UtilsSystem.UIMgr;
local TranslationHelper = UtilsSystem.TranslationHelper;
local EnumMgr = UtilsSystem.EnumMgr;
local PlayerData = UtilsSystem.PlayerData;
local TipsModule = UtilsSystem.TipsModule;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local LocalPlayer = UtilsSystem.LocalPlayer;
local AllUI = require(script.AllUI);
local SlideBar = require(script.SlideBar);
local SettingDropdown = require(script.SettingDropdown);
local SettingRowBind = require(script.SettingRowBind);
local UIRoot = AllUI.UIRoot;
local ScrollingFrame = AllUI.ScrollingFrame;
local SecondFrame = AllUI.SecondFrame;
local Temp = AllUI.Temp;
local TempBar = AllUI.TempBar;
local TempChoose = AllUI.TempChoose;
local TempInput = AllUI.TempInput;
local TabTemp = AllUI.TabTemp;
local TopTab = AllUI.TopTab;
local SettingTempType = EnumMgr.SettingTempType;
local u3 = {
    openDropdownScroll = nil,
    categoryToSecondFrame = {}
};
local u4 = {};
local u5 = {};
local u8 = SettingRowBind.create({
    settingConf = v2,
    dropdownState = u3,
    UIMgr = UIMgr,
    AddListen = AddListen,
    CfgFind = CfgFind,
    TranslationHelper = TranslationHelper,
    TipsModule = TipsModule,
    NetWork = NetWork,
    NetMsg = NetMsg,
    LocalPlayer = LocalPlayer,
    EnumMgr = EnumMgr,
    PlayerData = PlayerData,
    SlideBar = SlideBar,

    pushSettingChange = function(u6, u7) -- Line: 79, Name: _pushSettingChange
        -- upvalues: NetWork (copy), NetMsg (copy), Log (copy)
        local success, result = pcall(function() -- Line: 80
            -- upvalues: NetWork (ref), NetMsg (ref), u6 (copy), u7 (copy)
            return NetWork.InvokeServer(NetMsg.SETTING_CHANGE, u6, u7);
        end);

        if success then
            return;
        end;

        Log.warn("[Setting] SETTING_CHANGE failed:", u6, result);
    end
});
u8.registerBagSync();

local function _categoryTitle(p9) -- Line: 113
    -- upvalues: EnumMgr (copy)
    local v10 = EnumMgr.SettingCategory[p9];

    return type(v10) ~= "string" and "设置" or v10;
end;

local function _setTabSelected(p11) -- Line: 126
    -- upvalues: u4 (copy)
    for _, v in ipairs(u4) do
        local frame = v.frame;
        local v12 = v.setType == p11;
        local ChooseBg = frame:FindFirstChild("ChooseBg");
        local DefaultBg = frame:FindFirstChild("DefaultBg");

        if ChooseBg then
            ChooseBg.Visible = v12;
        end;

        if DefaultBg then
            DefaultBg.Visible = not v12;
        end;
    end;
end;

local function _scrollToSecondFrame(u13) -- Line: 146
    -- upvalues: ScrollingFrame (copy)
    task.defer(function() -- Line: 147
        -- upvalues: u13 (copy), ScrollingFrame (ref)
        task.wait();

        if not (u13.Parent and u13:IsDescendantOf(ScrollingFrame)) then
            return;
        end;

        local v14 = u13.AbsolutePosition.Y - ScrollingFrame.AbsolutePosition.Y + ScrollingFrame.CanvasPosition.Y;
        local v15 = math.max(0, ScrollingFrame.AbsoluteCanvasSize.Y - ScrollingFrame.AbsoluteWindowSize.Y);
        ScrollingFrame.CanvasPosition = Vector2.new(0, (math.clamp(v14, 0, v15)));
    end);
end;

(function() -- Line: 162, Name: _buildSettingUI
    -- upvalues: SecondFrame (copy), TabTemp (copy), Temp (copy), TempBar (copy), TempChoose (copy), TempInput (copy), u8 (copy), u5 (copy), ScrollingFrame (copy), TranslationHelper (copy), EnumMgr (copy), u3 (copy), SettingTempType (copy), UIMgr (copy), SettingDropdown (copy), TopTab (copy), _setTabSelected (copy)
    SecondFrame.Visible = false;
    TabTemp.Visible = false;
    Temp.Visible = false;
    TempBar.Visible = false;
    TempChoose.Visible = false;
    TempInput.Visible = false;
    local v16 = u8.collectVisibleRows();
    local v17 = {};

    for _, v in ipairs(v16) do
        local v18 = v.v.SetType or 1;

        if not v17[v18] then
            v17[v18] = {};
        end;

        table.insert(v17[v18], v);
    end;

    table.clear(u5);
    local v19 = {};

    for _, v in ipairs(v16) do
        local v20 = v.v.SetType or 1;

        if not v19[v20] then
            v19[v20] = true;
            table.insert(u5, v20);
        end;
    end;

    local v21 = 0;

    for _, v in ipairs(u5) do
        local v22 = SecondFrame:Clone();
        v22.Visible = true;
        v22.Name = "Cat_" .. tostring(v);
        v21 = v21 + 1;
        v22.LayoutOrder = v21;
        v22.Parent = ScrollingFrame;
        local TitleFrame = v22:FindFirstChild("TitleFrame");
        local v23 = TitleFrame and TitleFrame:FindFirstChild("Title");

        if v23 then
            local v24 = EnumMgr.SettingCategory[v];
            TranslationHelper.SetText(v23, type(v24) ~= "string" and "设置" or v24);
        end;

        for _, child in v22:GetChildren() do
            if child.Name == "_Temp" or (child.Name == "_TempBar" or (child.Name == "_TempChoose" or child.Name == "_TempInput")) then
                child:Destroy();
            end;
        end;

        u3.categoryToSecondFrame[v] = v22;
        local v25 = v17[v] or {};
        local v26 = 0;

        for _, v3 in ipairs(v25) do
            if v26 < v3.id then
                v26 = v3.id;
            end;
        end;

        local v27 = 0;

        for _, v3 in ipairs(v25) do
            local v4 = v3.v;
            local v28 = v4.TempType or SettingTempType.Toggle;
            v27 = v27 + 1;
            local v29;

            if v28 == SettingTempType.Slider then
                v29 = TempBar;
            elseif v28 == SettingTempType.Choose then
                v29 = TempChoose;
            elseif v28 == SettingTempType.Input then
                v29 = TempInput;
            else
                v29 = Temp;
            end;

            local v30 = v29:Clone();
            v30.Visible = true;
            v30.Name = v4.ShowName;
            v30.LayoutOrder = v27;
            v30.ZIndex = v26 - v3.id + 1;
            v30.Parent = v22;
            local Title = v30:FindFirstChild("Title");

            if Title then
                TranslationHelper.SetText(Title, v4.ZhName);
            end;

            local ShowName = v4.ShowName;

            if v28 == SettingTempType.Slider then
                u8.bindSliderRow(v4, v30, ShowName);
            elseif v28 == SettingTempType.Choose then
                if ShowName == "EquipTitle" then
                    u8.bindEquipTitleRow(v30, ShowName, v22);
                else
                    u8.bindChooseRow(v4, v30, ShowName, v22);
                end;
            elseif v28 == SettingTempType.Input then
                u8.bindCodeRow(v4, v30, ShowName);
            else
                u8.bindToggleRow(v4, v30, ShowName);
            end;
        end;

        UIMgr.SetUIlistSize(v22);
    end;

    SettingDropdown.closeAny(u3);
    UIMgr.SetUIlistSize(ScrollingFrame);
    TopTab.Visible = false;

    if #u5 > 0 then
        _setTabSelected(u5[1]);
    end;

    u8.flushDeferredNvBinds();
end)();

local function _requestClose() -- Line: 309
    -- upvalues: NetWork (copy), NetMsg (copy)
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Setting", nil, false, true);
end;

local Exit = AllUI.Exit;

if Exit then
    Exit = Exit:FindFirstChild("Btn") or Exit:FindFirstChild("Button");
end;

if Exit then
    AddListen.AddMouseCLick(Exit, _requestClose, Exit.Parent);
end;

function v1.updateUi(p31, p32) -- Line: 324
end;

function v1.openUi(p33) -- Line: 331
    -- upvalues: UIMgr (copy), UIRoot (copy), u8 (copy), u5 (copy), u3 (copy), ScrollingFrame (copy)
    UIMgr.SetMainUIVisible(false);

    if not UIRoot then
        error("[Setting] UIRoot missing in openUi");
    end;

    u8.flushDeferredNvBinds();
    task.defer(function() -- Line: 337
        -- upvalues: u8 (ref), u5 (ref), u3 (ref), UIMgr (ref), ScrollingFrame (ref)
        task.wait();
        local v34 = u8.getEquipTitleRebuild();

        if v34 then
            v34();
        end;

        for _, v in ipairs(u5) do
            local v35 = u3.categoryToSecondFrame[v];

            if v35 then
                UIMgr.SetUIlistSize(v35);
            end;
        end;

        UIMgr.SetUIlistSize(ScrollingFrame);
    end);
end;

function v1.closeUi(p36) -- Line: 357
    -- upvalues: UIRoot (copy), SettingDropdown (copy), u3 (copy), SlideBar (copy), UIMgr (copy)
    if not UIRoot then
        error("[Setting] UIRoot missing in closeUi");
    end;

    SettingDropdown.closeAny(u3);
    SlideBar.CancelActive();
    UIMgr.SetMainUIVisible(true);
end;

return v1;