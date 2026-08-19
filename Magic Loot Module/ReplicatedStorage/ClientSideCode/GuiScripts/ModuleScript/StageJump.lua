-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local EnumMgr = UtilsSystem.EnumMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local AllUI = require(script.AllUI);
local v1 = {};
local UIRoot = AllUI.UIRoot;
local u2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = false;
local u4 = false;
local u5 = nil;
local u6 = nil;
local u7 = false;

local function _requestClose() -- Line: 51
    -- upvalues: NetWork (copy), NetMsg (copy)
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "StageJump", nil, false, true);
end;

local function _isUiScaleSettled() -- Line: 60
    -- upvalues: UIRoot (copy)
    local v8 = UIRoot:FindFirstChildOfClass("UIScale");

    if not v8 then
        return true;
    end;

    local v9 = tonumber(v8:GetAttribute("PopScale")) or 1;

    return v8.Scale >= v9 * 0.99;
end;

local function _trySaveCanvasPos() -- Line: 72
    -- upvalues: u7 (ref), UIRoot (copy), u5 (ref), AllUI (copy)
    if not u7 and UIRoot.Visible then
        local v10 = UIRoot:FindFirstChildOfClass("UIScale");
        local v11;

        if v10 then
            local v12 = tonumber(v10:GetAttribute("PopScale")) or 1;
            v11 = v10.Scale >= v12 * 0.99;
        else
            v11 = true;
        end;

        if v11 then
            u5 = AllUI.ScrollingFrame.CanvasPosition;
        end;
    end;
end;

AllUI.ScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(_trySaveCanvasPos);

local function _tweenRestoreCanvasPos(u13) -- Line: 86
    -- upvalues: AllUI (copy), u6 (ref), u7 (ref), TweenService (copy), u2 (copy), UIRoot (copy), u5 (ref)
    local ScrollingFrame = AllUI.ScrollingFrame;

    if u6 then
        u6:Cancel();
        u6 = nil;
    end;

    u7 = true;
    local u14 = TweenService:Create(ScrollingFrame, u2, {
        CanvasPosition = u13
    });
    u6 = u14;
    u14.Completed:Once(function() -- Line: 96
        -- upvalues: u6 (ref), u14 (copy), u7 (ref), ScrollingFrame (copy), UIRoot (ref), u13 (copy), u5 (ref)
        if u6 == u14 then
            u6 = nil;
        end;

        u7 = false;

        if ScrollingFrame.Parent and UIRoot.Visible then
            ScrollingFrame.CanvasPosition = u13;
            u5 = u13;
        end;
    end);
    u14:Play();
end;

local function _getCareerMaxStage() -- Line: 114
    -- upvalues: LocalPlayer (copy), PlayerData (copy)
    local CareerMaxStage = LocalPlayer:FindFirstChild("CareerMaxStage");

    if CareerMaxStage and CareerMaxStage:IsA("NumberValue") then
        local v15 = tonumber(CareerMaxStage.Value) or 0;
        local v16 = math.floor(v15);

        return math.max(0, v16);
    end;

    local v17 = PlayerData.GetPlrDataByKey(LocalPlayer, "CareerMaxStage");
    local v18 = tonumber(v17) or 0;
    local v19 = math.floor(v18);

    return math.max(0, v19);
end;

local function _getBroomJumpMax() -- Line: 128
    -- upvalues: PlayerData (copy), LocalPlayer (copy), CfgFind (copy), EnumMgr (copy)
    local v20 = tonumber(PlayerData.GetPlrDataByKey(LocalPlayer, "NowBroom")) or 0;

    if v20 <= 0 then
        local NowBroom = LocalPlayer:FindFirstChild("NowBroom");

        if NowBroom and NowBroom:IsA("NumberValue") then
            local v21 = tonumber(NowBroom.Value) or 0;
            v20 = math.floor(v21);
        end;
    end;

    if v20 <= 0 then
        return 0;
    end;

    local v22 = CfgFind.FindCfgByID(v20, EnumMgr.ItemType.Broom);

    if not v22 or tonumber(v22.tp) ~= EnumMgr.ItemType.Broom then
        return 0;
    end;

    local v23 = tonumber(v22.Dungeon) or 0;
    local v24 = math.floor(v23);

    return math.max(0, v24);
end;

local function _getActualJumpMax() -- Line: 152
    -- upvalues: _getCareerMaxStage (copy), _getBroomJumpMax (copy)
    local v25 = _getCareerMaxStage();
    local v26 = _getBroomJumpMax();

    return (v25 <= 0 or v26 <= 0) and 0 or math.min(v25 + 1, v26);
end;

local function _collectTeleStages() -- Line: 166
    -- upvalues: CfgFind (copy)
    local v27 = CfgFind.GetCfgByName("dungeonConf");
    local v28 = {};

    if type(v27) ~= "table" then
        return v28;
    end;

    for i, v in pairs(v27) do
        local v29 = tonumber(i);

        if v29 and (v29 > 0 and type(v) == "table") then
            local TeleIcon = v.TeleIcon;

            if type(TeleIcon) == "string" and TeleIcon ~= "" then
                table.insert(v28, v29);
            end;
        end;
    end;

    table.sort(v28);

    return v28;
end;

local function _setTeleportBtnMode(p30, p31) -- Line: 193
    local Bg = p30:FindFirstChild("Bg");
    local GrayBg = p30:FindFirstChild("GrayBg");
    local Button = p30:FindFirstChild("Button");

    if p31 == "hidden" then
        p30.Visible = false;

        if Bg and Bg:IsA("GuiObject") then
            Bg.Visible = false;
        end;

        if GrayBg and GrayBg:IsA("GuiObject") then
            GrayBg.Visible = false;
        end;

        if Button and Button:IsA("GuiObject") then
            Button.Visible = false;
        end;

        return;
    end;

    p30.Visible = true;

    if Button and Button:IsA("GuiObject") then
        Button.Visible = true;
    end;

    local v32 = p31 == "enabled";

    if Bg and Bg:IsA("GuiObject") then
        Bg.Visible = v32;
    end;

    if GrayBg and GrayBg:IsA("GuiObject") then
        GrayBg.Visible = not v32;
    end;
end;

local function _refreshSlotState(p33, p34, p35, p36) -- Line: 234
    local v37 = p33:FindFirstChild("传送按钮");

    if not (v37 and v37:IsA("Frame")) then
        return;
    end;

    if p36 >= p34 then
        if p34 <= p35 and p35 > 0 then
            local Bg = v37:FindFirstChild("Bg");
            local GrayBg = v37:FindFirstChild("GrayBg");
            local Button = v37:FindFirstChild("Button");
            v37.Visible = true;

            if Button and Button:IsA("GuiObject") then
                Button.Visible = true;
            end;

            if Bg and Bg:IsA("GuiObject") then
                Bg.Visible = true;
            end;

            if GrayBg and GrayBg:IsA("GuiObject") then
                GrayBg.Visible = false;

                return;
            end;
        else
            local Bg = v37:FindFirstChild("Bg");
            local GrayBg = v37:FindFirstChild("GrayBg");
            local Button = v37:FindFirstChild("Button");
            v37.Visible = true;

            if Button and Button:IsA("GuiObject") then
                Button.Visible = true;
            end;

            if Bg and Bg:IsA("GuiObject") then
                Bg.Visible = false;
            end;

            if GrayBg and GrayBg:IsA("GuiObject") then
                GrayBg.Visible = true;
            end;
        end;

        return;
    end;

    local Bg = v37:FindFirstChild("Bg");
    local GrayBg = v37:FindFirstChild("GrayBg");
    local Button = v37:FindFirstChild("Button");
    v37.Visible = false;

    if Bg and Bg:IsA("GuiObject") then
        Bg.Visible = false;
    end;

    if GrayBg and GrayBg:IsA("GuiObject") then
        GrayBg.Visible = false;
    end;

    if Button and Button:IsA("GuiObject") then
        Button.Visible = false;
    end;
end;

local function _bindTeleportClick(p38, u39) -- Line: 258
    -- upvalues: UIMgr (copy), AddListen (copy), _getCareerMaxStage (copy), _getBroomJumpMax (copy), TipsModule (copy), LocalPlayer (copy), NetWork (copy), NetMsg (copy)
    local v40 = p38:FindFirstChild("传送按钮");

    if not (v40 and v40:IsA("Frame")) then
        return;
    end;

    local v41 = v40:FindFirstChild("Button") or v40;
    local v42;

    if v41:IsA("GuiButton") then
        v42 = v41;
    else
        v42 = UIMgr.FindButtonInFrame(v41);
    end;

    if not v42 then
        return;
    end;

    AddListen.AddMouseCLick(v42, function() -- Line: 271
        -- upvalues: _getCareerMaxStage (ref), _getBroomJumpMax (ref), u39 (copy), TipsModule (ref), LocalPlayer (ref), NetWork (ref), NetMsg (ref)
        local v43 = _getCareerMaxStage();
        local v44 = _getBroomJumpMax();
        local v45 = (v43 <= 0 or v44 <= 0) and 0 or math.min(v43 + 1, v44);

        if v45 < u39 or v45 <= 0 then
            TipsModule.ErrorTips(LocalPlayer, "需要先通关该关卡才可以传送");

            return;
        end;

        NetWork.FireServer(NetMsg.STAGE_JUMP_REQUEST, u39);
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "StageJump", nil, false, true);
    end, v41);
end;

local function _fillSlotStatic(p46, p47, p48) -- Line: 289
    -- upvalues: UIMgr (copy), TranslationHelper (copy)
    local BG = p46:FindFirstChild("BG");

    if BG and (BG:IsA("ImageLabel") or BG:IsA("ImageButton")) then
        UIMgr.SetImage(BG, p48);
    end;

    local v49 = p46:FindFirstChild("关卡");

    if v49 and v49:IsA("TextLabel") then
        TranslationHelper.SetText(v49, "阶段N", { (tostring(p47)) });
    end;
end;

local function _getUiScaleForScroll(p50) -- Line: 307
    -- upvalues: LocalPlayer (copy)
    local v51 = 1;
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui");

    if not PlayerGui then
        return v51;
    end;

    local ScreenGui = PlayerGui:FindFirstChild("ScreenGui");

    if not (ScreenGui and ScreenGui:IsA("ScreenGui")) then
        return v51;
    end;

    local UIScale = ScreenGui:FindFirstChild("UIScale");

    while p50 and p50.Parent ~= ScreenGui do
        p50 = p50.Parent;
    end;

    if p50 then
        p50 = p50:FindFirstChild("UIScale");
    end;

    if UIScale and (UIScale:IsA("UIScale") and (p50 and p50:IsA("UIScale"))) then
        v51 = UIScale.Scale * p50.Scale;
    elseif UIScale and UIScale:IsA("UIScale") then
        v51 = UIScale.Scale;
    elseif p50 and p50:IsA("UIScale") then
        v51 = p50.Scale;
    end;

    return math.max(v51, 0.001);
end;

local function _scrollToMaxJumpable() -- Line: 340
    -- upvalues: u4 (ref), _getCareerMaxStage (copy), _getBroomJumpMax (copy), AllUI (copy), UIMgr (copy)
    if u4 then
        return;
    end;

    u4 = true;
    local v52 = _getCareerMaxStage();
    local v53 = _getBroomJumpMax();
    local v54 = (v52 <= 0 or v53 <= 0) and 0 or math.min(v52 + 1, v53);

    if v54 <= 0 then
        return;
    end;

    local ScrollingFrame = AllUI.ScrollingFrame;
    local v55 = ScrollingFrame:FindFirstChild((tostring(v54)));

    if v55 and v55:IsA("GuiObject") then
        UIMgr.ScheduleScrollToChild(ScrollingFrame, v55, {
            alignX = "center",
            skipLayoutRefresh = true
        });
    end;
end;

local function _applyScrollCanvasSize(u56, u57) -- Line: 367
    -- upvalues: _getUiScaleForScroll (copy), UIMgr (copy)
    task.spawn(function() -- Line: 368
        -- upvalues: u56 (copy), _getUiScaleForScroll (ref), UIMgr (ref), u57 (copy)
        task.wait();

        if not u56.Parent then
            return;
        end;

        task.wait();

        if not u56.Parent then
            return;
        end;

        task.wait();

        if not u56.Parent then
            return;
        end;

        local v58 = u56:FindFirstChildOfClass("UIListLayout");
        local ScrollingDirection = u56.ScrollingDirection;

        if v58 and (ScrollingDirection == Enum.ScrollingDirection.X and true or ScrollingDirection == Enum.ScrollingDirection.XY) then
            local v59 = _getUiScaleForScroll(u56);
            local Padding = v58.Padding;
            local v60 = v58.AbsoluteContentSize.X / v59 + (Padding.Offset + Padding.Scale * (u56.AbsoluteSize.X / v59));
            local v61 = u56:FindFirstChildOfClass("UIPadding");

            if v61 then
                v60 = v60 + (v61.PaddingLeft.Offset + v61.PaddingRight.Offset) + (v61.PaddingLeft.Scale + v61.PaddingRight.Scale) * (u56.AbsoluteSize.X / v59);
            end;

            u56.CanvasSize = UDim2.new(0, math.max(0, v60), 0, 0);
        else
            UIMgr.SetUIlistSize(u56);
        end;

        if u57 then
            u57();
        end;
    end);
end;

local function _buildList() -- Line: 408
    -- upvalues: u3 (ref), AllUI (copy), UIMgr (copy), _getCareerMaxStage (copy), _getBroomJumpMax (copy), _collectTeleStages (copy), CfgFind (copy), _fillSlotStatic (copy), _refreshSlotState (copy), _bindTeleportClick (copy), _scrollToMaxJumpable (copy), _getUiScaleForScroll (copy)
    if u3 then
        return;
    end;

    u3 = true;
    local ScrollingFrame = AllUI.ScrollingFrame;
    local Temp = AllUI.Temp;
    UIMgr.ClearScrollItems(ScrollingFrame, {
        keepInstances = { Temp }
    });
    local v62 = _getCareerMaxStage();
    local v63 = _getBroomJumpMax();
    local v64 = (v62 <= 0 or v63 <= 0) and 0 or math.min(v62 + 1, v63);
    local v65 = _getBroomJumpMax();
    local v66 = _collectTeleStages();

    for _, v in ipairs(v66) do
        local v67 = CfgFind.GetCfgByNameAndID("dungeonConf", v);

        if v67 and (type(v67.TeleIcon) == "string" and v67.TeleIcon ~= "") then
            local v68 = Temp:Clone();
            v68.Name = tostring(v);
            v68.LayoutOrder = v;
            v68.Visible = true;
            v68.Parent = ScrollingFrame;
            _fillSlotStatic(v68, v, v67.TeleIcon);
            _refreshSlotState(v68, v, v64, v65);
            _bindTeleportClick(v68, v);
        end;
    end;

    Temp:Destroy();
    local u69 = _scrollToMaxJumpable;
    task.spawn(function() -- Line: 368
        -- upvalues: ScrollingFrame (copy), _getUiScaleForScroll (ref), UIMgr (ref), u69 (copy)
        task.wait();

        if not ScrollingFrame.Parent then
            return;
        end;

        task.wait();

        if not ScrollingFrame.Parent then
            return;
        end;

        task.wait();

        if not ScrollingFrame.Parent then
            return;
        end;

        local v70 = ScrollingFrame:FindFirstChildOfClass("UIListLayout");
        local ScrollingDirection = ScrollingFrame.ScrollingDirection;

        if v70 and (ScrollingDirection == Enum.ScrollingDirection.X and true or ScrollingDirection == Enum.ScrollingDirection.XY) then
            local v71 = _getUiScaleForScroll(ScrollingFrame);
            local Padding = v70.Padding;
            local v72 = v70.AbsoluteContentSize.X / v71 + (Padding.Offset + Padding.Scale * (ScrollingFrame.AbsoluteSize.X / v71));
            local v73 = ScrollingFrame:FindFirstChildOfClass("UIPadding");

            if v73 then
                v72 = v72 + (v73.PaddingLeft.Offset + v73.PaddingRight.Offset) + (v73.PaddingLeft.Scale + v73.PaddingRight.Scale) * (ScrollingFrame.AbsoluteSize.X / v71);
            end;

            ScrollingFrame.CanvasSize = UDim2.new(0, math.max(0, v72), 0, 0);
        else
            UIMgr.SetUIlistSize(ScrollingFrame);
        end;

        if u69 then
            u69();
        end;
    end);
end;

local function _refreshAllStates() -- Line: 445
    -- upvalues: _getCareerMaxStage (copy), _getBroomJumpMax (copy), AllUI (copy), _refreshSlotState (copy)
    local v74 = _getCareerMaxStage();
    local v75 = _getBroomJumpMax();
    local v76 = (v74 <= 0 or v75 <= 0) and 0 or math.min(v74 + 1, v75);
    local v77 = _getBroomJumpMax();

    for _, child in AllUI.ScrollingFrame:GetChildren() do
        if child:IsA("Frame") then
            local v78 = tonumber(child.Name);

            if v78 then
                _refreshSlotState(child, v78, v76, v77);
            end;
        end;
    end;
end;

local v79 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v79 then
    AddListen.AddMouseCLick(v79, _requestClose, AllUI.Exit);
end;

function v1.openUi(p80, p81) -- Line: 471
    -- upvalues: UIRoot (copy), _buildList (copy), _refreshAllStates (copy), u4 (ref), u5 (ref), _tweenRestoreCanvasPos (copy)
    UIRoot.Visible = true;
    _buildList();
    _refreshAllStates();

    if u4 and u5 then
        local u82 = u5;
        task.spawn(function() -- Line: 479
            -- upvalues: UIRoot (ref), _tweenRestoreCanvasPos (ref), u82 (copy)
            local v83 = os.clock() + 0.5;

            while os.clock() < v83 do
                local v84 = UIRoot:FindFirstChildOfClass("UIScale");
                local v85;

                if v84 then
                    local v86 = tonumber(v84:GetAttribute("PopScale")) or 1;
                    v85 = v84.Scale >= v86 * 0.99;
                else
                    v85 = true;
                end;

                if v85 then
                    break;
                end;

                task.wait();
            end;

            task.wait();

            if UIRoot.Visible and UIRoot.Parent then
                _tweenRestoreCanvasPos(u82);
            end;
        end);
    end;
end;

function v1.closeUi(p87) -- Line: 500
    -- upvalues: u7 (ref), UIRoot (copy), u5 (ref), AllUI (copy)
    if not u7 and UIRoot.Visible then
        local v88 = UIRoot:FindFirstChildOfClass("UIScale");
        local v89;

        if v88 then
            local v90 = tonumber(v88:GetAttribute("PopScale")) or 1;
            v89 = v88.Scale >= v90 * 0.99;
        else
            v89 = true;
        end;

        if v89 then
            u5 = AllUI.ScrollingFrame.CanvasPosition;
        end;
    end;

    UIRoot.Visible = false;
end;

function v1.updateUi(p91, p92) -- Line: 511
    -- upvalues: _refreshAllStates (copy)
    _refreshAllStates();
end;

task.spawn(function() -- Line: 516
    -- upvalues: LocalPlayer (copy), UIRoot (copy), _refreshAllStates (copy)
    local CareerMaxStage = LocalPlayer:WaitForChild("CareerMaxStage", 30);

    if CareerMaxStage and CareerMaxStage:IsA("NumberValue") then
        CareerMaxStage:GetPropertyChangedSignal("Value"):Connect(function() -- Line: 519
            -- upvalues: UIRoot (ref), _refreshAllStates (ref)
            if UIRoot.Visible then
                _refreshAllStates();
            end;
        end);
    end;
end);

return v1;