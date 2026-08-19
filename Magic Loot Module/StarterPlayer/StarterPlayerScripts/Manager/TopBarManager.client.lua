-- Decompiled with Potassium's decompiler.

local GuiService = game:GetService("GuiService");
local SocialService = game:GetService("SocialService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Icon = require(game.ReplicatedStorage.ClientSideCode.Tool.TopbarPlus.Icon);
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local MathMgr = UtilsSystem.MathMgr;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIanima = UtilsSystem.UIanima;
local InsMgr = UtilsSystem.InsMgr;
local u1 = GuiService.ViewportDisplaySize == Enum.DisplaySize.Small;
local u2 = Color3.new(1, 0, 0.0156863);
local u3 = Color3.new(1, 1, 1);
Color3.fromHex("FFD865");
Color3.fromHex("000000");

local function _applyNoticeTheme(p4) -- Line: 130
    -- upvalues: u2 (copy), u3 (copy)
    return p4:modifyTheme({ "Notice", "BackgroundColor3", u2 }):modifyTheme({ "NoticeLabel", "TextColor3", u3 });
end;

local function _syncTopbarEntryVisible(p5) -- Line: 141
    -- upvalues: Icon (copy)
    Icon.setTopbarEnabled(not p5);
end;

local function _fireShowLocalUI(p6, p7, p8, p9, ...) -- Line: 154
    -- upvalues: NetWork (copy), NetMsg (copy)
    NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, p6, p7, p8, p9, ...);
end;

local function _closeDropdownParentIfJoined(p10) -- Line: 163
    -- upvalues: Icon (copy)
    local parentIconUID = p10.parentIconUID;

    if not parentIconUID then
        return;
    end;

    local v11 = Icon.getIconByUID(parentIconUID);

    if v11 then
        v11:deselect();
    end;
end;

local function _bindOpenUiClick(u12, u13, u14, u15) -- Line: 182
    -- upvalues: _fireShowLocalUI (copy)
    u12:bindEvent("selected", function() -- Line: 183
        -- upvalues: _fireShowLocalUI (ref), u13 (copy), u14 (copy), u15 (copy), u12 (copy)
        _fireShowLocalUI(u13, nil, u14, u15);
        u12:clearNotices();
        u12:deselect();
    end);
end;

local function _deferRefreshSettingMenuDropdown(u16) -- Line: 195
    task.defer(function() -- Line: 196
        -- upvalues: u16 (copy)
        local v17 = u16:getInstance("Dropdown");

        if v17 then
            u16:refreshAppearance(v17);
        end;
    end);
end;

local function _animateCoinLabel(p18, u19, p20, p21) -- Line: 212
    -- upvalues: MathMgr (copy), UIanima (copy)
    local u22 = MathMgr.getNumStr(p21);

    if u19 then
        u19:setLabel(u22, "Viewing");
        u19:setLabel(u22, "Selected");
    end;

    UIanima.AnimateNumberChange(p18, p20 < p21 and "up" or "down", {
        mode = "roll",
        duration = 0.25,
        fromValue = p20,
        toValue = p21,

        formatFn = function(p23) -- Line: 226, Name: formatFn
            -- upvalues: MathMgr (ref)
            return MathMgr.getNumStr((math.floor(p23)));
        end,

        onComplete = function() -- Line: 229, Name: onComplete
            -- upvalues: u19 (copy), u22 (copy)
            if u19 then
                u19:setLabel(u22);

                if u19.updateSize and u19.updateSize.Fire then
                    u19.updateSize:Fire();
                end;
            end;
        end
    });
end;

local function _bindCoinValueDisplay(u24, u25, u26) -- Line: 247
    -- upvalues: UIanima (copy), _animateCoinLabel (copy), TranslationHelper (copy), MathMgr (copy)
    local u27 = nil;

    local function updateMoneyLabel() -- Line: 254
        -- upvalues: u24 (copy), u25 (copy), u27 (ref), UIanima (ref), u26 (copy), _animateCoinLabel (ref), TranslationHelper (ref), MathMgr (ref)
        local v28 = math.floor(u24.Value);
        local v29 = u25();
        local v30;

        if u27 == nil or u27 == v28 then
            v30 = false;
        else
            v30 = v29 and UIanima and UIanima.AnimateNumberChange;
        end;

        if v30 then
            if u26 then
                _animateCoinLabel(v29, u26, u27, v28);
            else
                TranslationHelper.SetText_UnTrans(v29, MathMgr.getNumStr(v28), true);
                _animateCoinLabel(v29, nil, u27, v28);
            end;
        elseif v29 then
            if u26 then
                u26:setLabel(MathMgr.getNumStr(v28));
            else
                TranslationHelper.SetText_UnTrans(v29, MathMgr.getNumStr(v28), true);
            end;
        end;

        u27 = v28;
    end;

    updateMoneyLabel();
    u24.Changed:Connect(updateMoneyLabel);
end;

local function _createSettingMenuIcon() -- Line: 289
    -- upvalues: Icon (copy)
    return Icon.new():setName("SettingMenu"):setRight():setOrder(3):setLabel(""):setImage("rbxassetid://80613834867873"):setImageScale(0.85):setCornerRadius(UDim.new(1, 0)):autoDeselect(false):modifyTheme({
        { "Dropdown", "AnchorPoint", Vector2.new(1, 0) },
        { "Dropdown", "Position", UDim2.new(1, 0, 1, 10) }
    });
end;

local function _createNewsMailIcon() -- Line: 387
    -- upvalues: Icon (copy), _applyNoticeTheme (copy), _fireShowLocalUI (copy)
    local u31 = Icon.new():setName("NewsMail"):setRight():setOrder(1):setLabel(""):setImage("rbxassetid://140443240603234"):setImageScale(0.6):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    _applyNoticeTheme(u31);
    u31:bindEvent("selected", function() -- Line: 400
        -- upvalues: _fireShowLocalUI (ref), u31 (copy), Icon (ref)
        _fireShowLocalUI("Update", nil, true, true);
        u31:clearNotices();
        u31:deselect();
        local parentIconUID = u31.parentIconUID;

        if not parentIconUID then
            return;
        end;

        local v32 = Icon.getIconByUID(parentIconUID);

        if v32 then
            v32:deselect();
        end;
    end);

    return u31;
end;

local function _createFeedbackLeftIcon() -- Line: 414
    -- upvalues: Icon (copy), _applyNoticeTheme (copy), _fireShowLocalUI (copy)
    local u33 = Icon.new():setName("feedbackLeft"):setLeft():setImageScale(0.7):setOrder(3):setImage("rbxassetid://107840429862080"):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    _applyNoticeTheme(u33);
    local u34 = "Feedback";
    local u35 = nil;
    local u36 = nil;
    u33:bindEvent("selected", function() -- Line: 183
        -- upvalues: _fireShowLocalUI (ref), u34 (copy), u35 (copy), u36 (copy), u33 (copy)
        _fireShowLocalUI(u34, nil, u35, u36);
        u33:clearNotices();
        u33:deselect();
    end);
end;

local function _applySmallScreenDropdownLayout(p37, p38, p39, p40) -- Line: 436
    p38:setLabel("Setting");
    p38:setImageScale(0.6);
    p38:joinDropdown(p37);
    p39:setLabel("Feedback");
    p39:setImageScale(0.6);
    p39:joinDropdown(p37);
end;

local function _createBackpackIcon() -- Line: 461
    -- upvalues: Icon (copy), u1 (copy), _applyNoticeTheme (copy), InsMgr (copy), LocalPlayer (copy)
    local u41 = Icon.new():setName("BackpackWarehouse");

    if u1 then
        u41:setRight();
    else
        u41:setLeft();
    end;

    u41:setOrder(1):setLabel(""):setImage("rbxassetid://118736042007083"):setImageScale(0.65):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    _applyNoticeTheme(u41);
    u41:bindEvent("selected", function() -- Line: 480
        -- upvalues: InsMgr (ref), LocalPlayer (ref), u41 (copy)
        InsMgr.GetIns("ToggleBackpackWarehouse", "BindableEvent", LocalPlayer):Fire();
        u41:deselect();
    end);
end;

local function _refreshOnlineAwardNotice(p42, p43) -- Line: 493
    if p43.Value > 0 then
        if (p42.totalNotices or 0) < 1 then
            p42:notify();
        end;
    else
        p42:clearNotices();
    end;
end;

local function _createOnlineAwardIcon() -- Line: 507
    -- upvalues: Icon (copy), u1 (copy), _applyNoticeTheme (copy), GetData (copy), LocalPlayer (copy), _fireShowLocalUI (copy)
    local u44 = Icon.new():setName("OnlineAward");

    if u1 then
        u44:setRight();
    else
        u44:setLeft();
    end;

    u44:setOrder(2):setLabel(""):setImage("rbxassetid://75856038792641"):setImageScale(0.85):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    _applyNoticeTheme(u44);
    u44:modifyTheme({ "NoticeLabel", "TextTransparency", 1 }):modifyTheme({ "Notice", "AutomaticSize", Enum.AutomaticSize.None }):modifyTheme({ "Notice", "Size", UDim2.fromOffset(12, 12) });
    local u45 = GetData.WaitRedPointValue(LocalPlayer, "在线奖励红点");
    u44:bindEvent("selected", function() -- Line: 534
        -- upvalues: _fireShowLocalUI (ref), u44 (copy), u45 (copy)
        _fireShowLocalUI("OnlineAward", nil, nil, true);
        u44:deselect();
        local v46 = u44;

        if u45.Value > 0 then
            if (v46.totalNotices or 0) < 1 then
                v46:notify();
            end;
        else
            v46:clearNotices();
        end;
    end);
    u45.Changed:Connect(function() -- Line: 541
        -- upvalues: u44 (copy), u45 (copy)
        local v47 = u44;

        if u45.Value > 0 then
            if (v47.totalNotices or 0) < 1 then
                v47:notify();
            end;
        else
            v47:clearNotices();
        end;
    end);
    task.defer(function() -- Line: 544
        -- upvalues: u44 (copy), u45 (copy)
        local v48 = u44;

        if u45.Value > 0 then
            if (v48.totalNotices or 0) < 1 then
                v48:notify();
            end;
        else
            v48:clearNotices();
        end;
    end);
end;

(function() -- Line: 309, Name: _createFriendIcon
    -- upvalues: Icon (copy), LocalPlayer (copy), SocialService (copy), Log (copy)
    local u49 = Icon.new():setName("FriendTopbar"):setRight():setOrder(2):setLabel(""):setImage("rbxassetid://73815092203036"):setImageScale(0.65):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    u49:bindEvent("selected", function() -- Line: 320
        -- upvalues: LocalPlayer (ref), SocialService (ref), Log (ref), u49 (copy)
        local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions");
        ExperienceInviteOptions.PromptMessage = "Invite Friend";
        ExperienceInviteOptions.LaunchData = tostring(LocalPlayer.UserId);
        local success, result = pcall(SocialService.PromptGameInvite, SocialService, LocalPlayer, ExperienceInviteOptions);

        if not success then
            Log.warn("[TopBarManager] PromptGameInvite failed:", result);
        end;

        u49:deselect();
    end);

    return u49;
end)();
(function() -- Line: 361, Name: _createShowUIIcon
    -- upvalues: Icon (copy), _applyNoticeTheme (copy), NetWork (copy), NetMsg (copy)
    local u50 = Icon.new():setEnabled(false):setName("ShowUI"):setRight():setImageScale(0.7):setOrder(0):setLabel(""):setImage("rbxassetid://108026101285797"):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    _applyNoticeTheme(u50);
    u50:bindEvent("selected", function() -- Line: 375
        -- upvalues: NetWork (ref), NetMsg (ref), u50 (copy)
        NetWork.InvokeServer(NetMsg.SETTING_CHANGE, "HideUI", 1);
        u50:deselect();
    end);

    return u50;
end)();
local v53 = (function() -- Line: 338, Name: _createSettingIcon
    -- upvalues: Icon (copy), _fireShowLocalUI (copy)
    local u51 = Icon.new():setName("Setting"):setRight():setOrder(2):setImage("rbxassetid://121912900687510"):setImageScale(0.65):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    u51:bindEvent("selected", function() -- Line: 348
        -- upvalues: _fireShowLocalUI (ref), u51 (copy), Icon (ref)
        _fireShowLocalUI("Setting", nil, true, true);
        u51:deselect();
        local parentIconUID = u51.parentIconUID;

        if not parentIconUID then
            return;
        end;

        local v52 = Icon.getIconByUID(parentIconUID);

        if v52 then
            v52:deselect();
        end;
    end);

    return u51;
end)();
local v56 = (function() -- Line: 553, Name: _createFeedbackIcon
    -- upvalues: Icon (copy), _applyNoticeTheme (copy), _fireShowLocalUI (copy)
    local u54 = Icon.new():setName("feedback"):setRight():setImageScale(0.7):setOrder(0):setLabel(""):setImage("rbxassetid://71141863602929"):setCornerRadius(UDim.new(1, 0)):autoDeselect(false);
    _applyNoticeTheme(u54);
    u54:bindEvent("selected", function() -- Line: 566
        -- upvalues: _fireShowLocalUI (ref), u54 (copy), Icon (ref)
        _fireShowLocalUI("Feedback", nil, true, true);
        u54:clearNotices();
        u54:deselect();
        local parentIconUID = u54.parentIconUID;

        if not parentIconUID then
            return;
        end;

        local v55 = Icon.getIconByUID(parentIconUID);

        if v55 then
            v55:deselect();
        end;
    end);

    return u54;
end)();

if u1 then
    local u57 = _createSettingMenuIcon();
    _applySmallScreenDropdownLayout(u57, v53, v56, nil);
    task.defer(function() -- Line: 196
        -- upvalues: u57 (copy)
        local v58 = u57:getInstance("Dropdown");

        if v58 then
            u57:refreshAppearance(v58);
        end;
    end);
end;

_createBackpackIcon();
_createOnlineAwardIcon();
local v59 = InsMgr.GetIns("是否弹窗打开中", "BoolValue", LocalPlayer);
Icon.setTopbarEnabled(not v59.Value);
v59.Changed:Connect(function(p60) -- Line: 600
    -- upvalues: Icon (copy)
    Icon.setTopbarEnabled(not p60);
end);