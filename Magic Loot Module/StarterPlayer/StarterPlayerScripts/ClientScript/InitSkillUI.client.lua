-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local CfgFind = UtilsSystem.CfgFind;
local GetData = UtilsSystem.GetData;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local SystemBuyRoblox = UtilsSystem.SystemBuyRoblox;
local TipsModule = UtilsSystem.TipsModule;
local TranslationHelper = UtilsSystem.TranslationHelper;
local UIMgr = UtilsSystem.UIMgr;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local Skill = LocalPlayer:WaitForChild("PlayerGui", (1 / 0)):WaitForChild("ScreenGui", (1 / 0)):WaitForChild("Main", (1 / 0)):WaitForChild("Skill", (1 / 0));
UIMgr.SetSkillBarHasEquippedSkill(false);
local Skill1 = Skill:WaitForChild("Skill1", (1 / 0));
local Skill2 = Skill:WaitForChild("Skill2", (1 / 0));
local Skill3 = Skill:WaitForChild("Skill3", (1 / 0));
local v1 = Skill1:WaitForChild("可选择", (1 / 0));
local v2 = Skill2:WaitForChild("可选择", (1 / 0));
local u3 = Skill3:WaitForChild("可选择", (1 / 0));
local u4 = Skill2:FindFirstChild("未解锁");
local Unlock = Skill3:FindFirstChild("Unlock");
local u5 = LocalPlayer:WaitForChild("技能CD时间戳", (1 / 0));
local v6 = LocalPlayer:WaitForChild("技能相关", (1 / 0));
local Skill12 = v6:WaitForChild("Skill1", (1 / 0));
local Skill22 = v6:WaitForChild("Skill2", (1 / 0));
local Skill32 = v6:WaitForChild("Skill3", (1 / 0));
local u7 = LocalPlayer:WaitForChild("待选择槽位的技能", (1 / 0));
local u8 = { Skill1, Skill2, Skill3 };
local u9 = { Skill12, Skill22, Skill32 };
local u10 = { v1, v2, u3 };
local u11 = { nil, nil, nil };
local u12 = 0;
local u13 = { nil, nil, nil };
local u14 = { nil, nil, nil };
local u15 = false;

local function _normalizeUpdateKey(p16) -- Line: 88
    if p16 == nil then
        return nil;
    end;

    if type(p16) == "string" then
        return p16;
    end;

    if type(p16) == "table" then
        return p16[1];
    end;

    return nil;
end;

local function _hasSkillSlot3Pass() -- Line: 106
    -- upvalues: GetData (copy), LocalPlayer (copy)
    return GetData.IsHasPass(LocalPlayer, "SkillSlot3");
end;

local function _isLearnSlotUnlocked(p17) -- Line: 116
    -- upvalues: _hasSkillSlot3Pass (copy)
    if p17 <= 2 then
        return true;
    end;

    if p17 == 3 then
        return _hasSkillSlot3Pass();
    end;

    return false;
end;

local function _findLinfoFrame(p18) -- Line: 132
    return p18:FindFirstChild("Linfo") or p18:FindFirstChild("LInfo");
end;

local function _applySkill2UnlockVisual() -- Line: 141
    -- upvalues: u4 (copy), Skill2 (copy)
    if u4 then
        u4.Visible = false;
    end;

    local v19 = Skill2;
    local v20 = v19:FindFirstChild("Linfo") or v19:FindFirstChild("LInfo");

    if v20 then
        v20.Visible = true;
    end;

    return nil;
end;

local function _applySkill3UnlockVisual() -- Line: 157
    -- upvalues: GetData (copy), LocalPlayer (copy), Unlock (copy), Skill3 (copy), u3 (copy)
    local v21 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

    if Unlock then
        Unlock.Visible = not v21;
    end;

    local v22 = Skill3;
    local v23 = v22:FindFirstChild("Linfo") or v22:FindFirstChild("LInfo");

    if v23 then
        v23.Visible = v21;
    end;

    if v21 then
        u3.Visible = false;
    end;

    return nil;
end;

local function _bindSkill3UnlockBuy() -- Line: 177
    -- upvalues: u15 (ref), Unlock (copy), AddListen (copy), GetData (copy), LocalPlayer (copy), Skill3 (copy), u3 (copy), SystemBuyRoblox (copy)
    if u15 or not Unlock then
        return nil;
    end;

    local Btn = Unlock:FindFirstChild("Btn");

    if not (Btn and Btn:IsA("GuiButton")) then
        return nil;
    end;

    u15 = true;
    AddListen.AddMouseCLick(Btn, function() -- Line: 186
        -- upvalues: GetData (ref), LocalPlayer (ref), Unlock (ref), Skill3 (ref), u3 (ref), SystemBuyRoblox (ref)
        if not GetData.IsHasPass(LocalPlayer, "SkillSlot3") then
            SystemBuyRoblox.BuyRobloxByOnlyTag(LocalPlayer, "SkillSlot3");

            return;
        end;

        local v24 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

        if Unlock then
            Unlock.Visible = not v24;
        end;

        local v25 = Skill3;
        local v26 = v25:FindFirstChild("Linfo") or v25:FindFirstChild("LInfo");

        if v26 then
            v26.Visible = v24;
        end;

        if v24 then
            u3.Visible = false;
        end;
    end, Unlock);

    return nil;
end;

local function _calcCdProgress(p27, p28, p29) -- Line: 204
    -- upvalues: u13 (copy)
    local v30 = p28 - p29;

    if v30 <= 0.05 then
        u13[p27] = nil;

        return 0, false;
    end;

    local v31 = u13[p27];

    if not v31 or v31 < v30 then
        u13[p27] = v30;
        v31 = v30;
    end;

    return math.clamp(v30 / v31, 0, 1), true;
end;

local function _resolveRuntimeSkillId(p32) -- Line: 224
    -- upvalues: u9 (copy), PlayerData (copy), LocalPlayer (copy)
    local v33 = u9[p32];
    local v34 = v33 and v33.Value or 0;

    if v34 > 0 then
        return v34;
    end;

    local v35 = PlayerData.GetPlrDataByKey(LocalPlayer, "skills");

    if type(v35) == "table" then
        local v36 = v35[p32];
        v34 = type(v36) == "table" and (tonumber(v36.skillID) or 0) or v34;
    end;

    return v34 <= 0 and 0 or v34;
end;

local function _hasAnyEquippedSkill() -- Line: 245
    -- upvalues: _resolveRuntimeSkillId (copy)
    return _resolveRuntimeSkillId(1) > 0 and true or (_resolveRuntimeSkillId(2) > 0 and true or _resolveRuntimeSkillId(3) > 0);
end;

local function _areUnlockedSkillSlotsFull() -- Line: 259
    -- upvalues: GetData (copy), LocalPlayer (copy), _resolveRuntimeSkillId (copy)
    for i = 1, 3 do
        local v37;

        if i <= 2 then
            v37 = true;
        elseif i == 3 then
            v37 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");
        else
            v37 = false;
        end;

        if v37 and _resolveRuntimeSkillId(i) <= 0 then
            return false;
        end;
    end;

    return true;
end;

local function _syncCurrentSkillIds() -- Line: 275
    -- upvalues: _resolveRuntimeSkillId (copy), u11 (copy)
    local v38 = _resolveRuntimeSkillId(1);

    if v38 <= 0 then
        v38 = nil;
    end;

    u11[1] = v38;
    local v39 = _resolveRuntimeSkillId(2);

    if v39 <= 0 then
        v39 = nil;
    end;

    u11[2] = v39;
    local v40 = _resolveRuntimeSkillId(3);

    if v40 <= 0 then
        v40 = nil;
    end;

    u11[3] = v40;

    return nil;
end;

local function _setEmptySkillName(p41) -- Line: 289
    -- upvalues: TranslationHelper (copy)
    if p41 then
        TranslationHelper.SetText(p41, "还未学习技能");
    end;

    return nil;
end;

local function _renderSkillName(p42, p43) -- Line: 303
    -- upvalues: u11 (copy), TranslationHelper (copy), CfgFind (copy), ItemType (copy)
    local v44 = u11[p43];
    local v45 = p42:FindFirstChild("Linfo") or p42:FindFirstChild("LInfo");

    if v45 then
        v45 = v45:FindFirstChild("SkillName");
    end;

    if not v44 or v44 <= 0 then
        if v45 then
            TranslationHelper.SetText(v45, "还未学习技能");
        end;

        return nil;
    end;

    local v46 = CfgFind.FindCfgByID(v44, ItemType.Skill);

    if v46 then
        if v45 then
            TranslationHelper.SetText(v45, v46.ZhName or "");
        end;

        return nil;
    end;

    if v45 then
        TranslationHelper.SetText(v45, "还未学习技能");
    end;

    return nil;
end;

local function _renderSkillCd(p47, p48) -- Line: 332
    -- upvalues: u11 (copy), u13 (copy), u14 (copy), u5 (copy)
    local v49 = u11[p48];
    local CD = p47:FindFirstChild("CD");

    if not CD then
        return nil;
    end;

    if not v49 or v49 <= 0 then
        u13[p48] = nil;
        CD.Visible = false;

        return nil;
    end;

    local v50 = u14[p48];

    if not v50 then
        v50 = u5:FindFirstChild("Slot" .. tostring(p48));
        u14[p48] = v50;
    end;

    if not v50 then
        CD.Visible = false;

        return nil;
    end;

    local v51 = workspace:GetServerTimeNow();
    local v52 = v50.Value - v51;
    local v53, v54;

    if v52 <= 0.05 then
        u13[p48] = nil;
        v53 = false;
        v54 = 0;
    else
        local v55 = u13[p48];

        if not v55 or v55 < v52 then
            u13[p48] = v52;
            v55 = v52;
        end;

        v54 = math.clamp(v52 / v55, 0, 1);
        v53 = true;
    end;

    if v53 then
        CD.Visible = true;
        CD.AnchorPoint = Vector2.new(1, CD.AnchorPoint.Y);
        CD.Position = UDim2.new(1, 0, CD.Position.Y.Scale, CD.Position.Y.Offset);
        CD.Size = UDim2.new(v54, 0, CD.Size.Y.Scale, CD.Size.Y.Offset);
    else
        CD.Visible = false;
    end;

    return nil;
end;

local function _renderSkillSlot(p56, p57) -- Line: 377
    -- upvalues: _renderSkillName (copy), _renderSkillCd (copy)
    _renderSkillName(p56, p57);
    _renderSkillCd(p56, p57);

    return nil;
end;

local function _bindCooldownSlotListener(u58, p59) -- Line: 390
    -- upvalues: u14 (copy), AddListen (copy), u13 (copy), _renderSkillCd (copy), u8 (copy)
    u14[u58] = p59;
    AddListen.NumValueAdd(p59, function(p60) -- Line: 392
        -- upvalues: u13 (ref), u58 (copy), _renderSkillCd (ref), u8 (ref)
        local v61 = p60 - workspace:GetServerTimeNow();

        if v61 > 0.05 then
            u13[u58] = v61;
        else
            u13[u58] = nil;
        end;

        _renderSkillCd(u8[u58], u58);
    end);

    return nil;
end;

local function _renderSkillBar() -- Line: 437
    -- upvalues: u4 (copy), Skill2 (copy), GetData (copy), LocalPlayer (copy), Unlock (copy), Skill3 (copy), u3 (copy), u8 (copy), _renderSkillName (copy), _renderSkillCd (copy)
    if u4 then
        u4.Visible = false;
    end;

    local v62 = Skill2;
    local v63 = v62:FindFirstChild("Linfo") or v62:FindFirstChild("LInfo");

    if v63 then
        v63.Visible = true;
    end;

    local v64 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

    if Unlock then
        Unlock.Visible = not v64;
    end;

    local v65 = Skill3;
    local v66 = v65:FindFirstChild("Linfo") or v65:FindFirstChild("LInfo");

    if v66 then
        v66.Visible = v64;
    end;

    if v64 then
        u3.Visible = false;
    end;

    local v67 = u8[1];
    _renderSkillName(v67, 1);
    _renderSkillCd(v67, 1);
    local v68 = u8[2];
    _renderSkillName(v68, 2);
    _renderSkillCd(v68, 2);
    local v69 = u8[3];
    _renderSkillName(v69, 3);
    _renderSkillCd(v69, 3);

    return nil;
end;

local function _renderSkillBarCdOnly() -- Line: 451
    -- upvalues: _renderSkillCd (copy), u8 (copy)
    _renderSkillCd(u8[1], 1);
    _renderSkillCd(u8[2], 2);
    _renderSkillCd(u8[3], 3);

    return nil;
end;

local function _renderPendingSlots() -- Line: 463
    -- upvalues: u7 (copy), _areUnlockedSkillSlotsFull (copy), u10 (copy), GetData (copy), LocalPlayer (copy), _resolveRuntimeSkillId (copy)
    local Value = u7.Value;

    if Value == 0 or not _areUnlockedSkillSlotsFull() then
        for _, v in ipairs(u10) do
            v.Visible = false;
        end;

        return nil;
    end;

    for i = 1, 3 do
        local v70 = u10[i];
        local v71;

        if i <= 2 then
            v71 = true;
        elseif i == 3 then
            v71 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");
        else
            v71 = false;
        end;

        if v71 then
            v70.Visible = _resolveRuntimeSkillId(i) ~= Value;
        else
            v70.Visible = false;
        end;
    end;

    return nil;
end;

local function _trySetSkillSlot(u72) -- Line: 489
    -- upvalues: GetData (copy), LocalPlayer (copy), TipsModule (copy), NetWork (copy), NetMsg (copy)
    local v73;

    if u72 <= 2 then
        v73 = true;
    elseif u72 == 3 then
        v73 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");
    else
        v73 = false;
    end;

    if not v73 then
        TipsModule.ErrorTips(LocalPlayer, "技能槽未解锁");

        return nil;
    end;

    local success, result = pcall(function() -- Line: 494
        -- upvalues: NetWork (ref), NetMsg (ref), u72 (copy)
        return NetWork.InvokeServer(NetMsg.SET_SKILL_SLOT, {
            slotIndex = u72
        });
    end);

    if success and result then
        TipsModule.NormalTips(LocalPlayer, "药水使用成功");
    else
        TipsModule.ErrorTips(LocalPlayer, "使用失败");
    end;

    return nil;
end;

local function _bindPendingClick(p74, u75) -- Line: 512
    -- upvalues: AddListen (copy), _trySetSkillSlot (copy)
    local Btn = p74:FindFirstChild("Btn");

    if Btn and Btn:IsA("GuiButton") then
        local v76 = p74:FindFirstChild("选中框") or p74;
        AddListen.AddMouseCLick(Btn, function() -- Line: 516
            -- upvalues: _trySetSkillSlot (ref), u75 (copy)
            _trySetSkillSlot(u75);
        end, v76);
    end;

    local IndexBtn = p74:FindFirstChild("IndexBtn");

    if IndexBtn then
        local Btn2 = IndexBtn:FindFirstChild("Btn");

        if Btn2 and Btn2:IsA("GuiButton") then
            AddListen.AddMouseCLick(Btn2, function() -- Line: 525
                -- upvalues: _trySetSkillSlot (ref), u75 (copy)
                _trySetSkillSlot(u75);
            end, IndexBtn);
        end;
    end;

    return nil;
end;

local function _bindSkillSlot3PassWatcher() -- Line: 538
    -- upvalues: GetData (copy), LocalPlayer (copy), Unlock (copy), Skill3 (copy), u3 (copy), _renderPendingSlots (copy), AddListen (copy)
    local function onPassChanged() -- Line: 539
        -- upvalues: GetData (ref), LocalPlayer (ref), Unlock (ref), Skill3 (ref), u3 (ref), _renderPendingSlots (ref)
        local v77 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

        if Unlock then
            Unlock.Visible = not v77;
        end;

        local v78 = Skill3;
        local v79 = v78:FindFirstChild("Linfo") or v78:FindFirstChild("LInfo");

        if v79 then
            v79.Visible = v77;
        end;

        if v77 then
            u3.Visible = false;
        end;

        _renderPendingSlots();
    end;

    local GamePass = LocalPlayer:FindFirstChild("GamePass");

    if GamePass then
        local SkillSlot3 = GamePass:FindFirstChild("SkillSlot3");

        if SkillSlot3 and SkillSlot3:IsA("NumberValue") then
            AddListen.NumValueAdd(SkillSlot3, onPassChanged);
        end;

        GamePass.ChildAdded:Connect(function(p80) -- Line: 550
            -- upvalues: AddListen (ref), onPassChanged (copy), GetData (ref), LocalPlayer (ref), Unlock (ref), Skill3 (ref), u3 (ref), _renderPendingSlots (ref)
            if p80.Name == "SkillSlot3" and p80:IsA("NumberValue") then
                AddListen.NumValueAdd(p80, onPassChanged);
                local v81 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

                if Unlock then
                    Unlock.Visible = not v81;
                end;

                local v82 = Skill3;
                local v83 = v82:FindFirstChild("Linfo") or v82:FindFirstChild("LInfo");

                if v83 then
                    v83.Visible = v81;
                end;

                if v81 then
                    u3.Visible = false;
                end;

                _renderPendingSlots();
            end;
        end);
    else
        LocalPlayer.ChildAdded:Connect(function(p84) -- Line: 557
            -- upvalues: AddListen (ref), onPassChanged (copy), GetData (ref), LocalPlayer (ref), Unlock (ref), Skill3 (ref), u3 (ref), _renderPendingSlots (ref)
            if p84.Name == "GamePass" then
                local SkillSlot3 = p84:WaitForChild("SkillSlot3", 10);

                if SkillSlot3 and SkillSlot3:IsA("NumberValue") then
                    AddListen.NumValueAdd(SkillSlot3, onPassChanged);
                    local v85 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

                    if Unlock then
                        Unlock.Visible = not v85;
                    end;

                    local v86 = Skill3;
                    local v87 = v86:FindFirstChild("Linfo") or v86:FindFirstChild("LInfo");

                    if v87 then
                        v87.Visible = v85;
                    end;

                    if v85 then
                        u3.Visible = false;
                    end;

                    _renderPendingSlots();
                end;
            end;
        end);
    end;

    return nil;
end;

local function _onSkillDataChanged() -- Line: 570
    -- upvalues: u13 (copy), _resolveRuntimeSkillId (copy), u11 (copy), u4 (copy), Skill2 (copy), GetData (copy), LocalPlayer (copy), Unlock (copy), Skill3 (copy), u3 (copy), u8 (copy), _renderSkillName (copy), _renderSkillCd (copy), _renderPendingSlots (copy), UIMgr (copy)
    u13[1] = nil;
    u13[2] = nil;
    u13[3] = nil;
    local v88 = _resolveRuntimeSkillId(1);

    if v88 <= 0 then
        v88 = nil;
    end;

    u11[1] = v88;
    local v89 = _resolveRuntimeSkillId(2);

    if v89 <= 0 then
        v89 = nil;
    end;

    u11[2] = v89;
    local v90 = _resolveRuntimeSkillId(3);

    if v90 <= 0 then
        v90 = nil;
    end;

    u11[3] = v90;

    if u4 then
        u4.Visible = false;
    end;

    local v91 = Skill2;
    local v92 = v91:FindFirstChild("Linfo") or v91:FindFirstChild("LInfo");

    if v92 then
        v92.Visible = true;
    end;

    local v93 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

    if Unlock then
        Unlock.Visible = not v93;
    end;

    local v94 = Skill3;
    local v95 = v94:FindFirstChild("Linfo") or v94:FindFirstChild("LInfo");

    if v95 then
        v95.Visible = v93;
    end;

    if v93 then
        u3.Visible = false;
    end;

    local v96 = u8[1];
    _renderSkillName(v96, 1);
    _renderSkillCd(v96, 1);
    local v97 = u8[2];
    _renderSkillName(v97, 2);
    _renderSkillCd(v97, 2);
    local v98 = u8[3];
    _renderSkillName(v98, 3);
    _renderSkillCd(v98, 3);
    _renderPendingSlots();
    UIMgr.SetSkillBarHasEquippedSkill(_resolveRuntimeSkillId(1) > 0 and true or (_resolveRuntimeSkillId(2) > 0 and true or _resolveRuntimeSkillId(3) > 0));
end;

Skill1.Visible = true;
Skill2.Visible = true;
Skill3.Visible = true;
v1.Visible = false;
v2.Visible = false;
u3.Visible = false;
_bindPendingClick(v1, 1);
_bindPendingClick(v2, 2);
_bindPendingClick(u3, 3);
_bindSkill3UnlockBuy();
(function() -- Line: 410, Name: _setupCooldownTimestampListeners
    -- upvalues: u5 (copy), u14 (copy), AddListen (copy), u13 (copy), _renderSkillCd (copy), u8 (copy)
    for i = 1, 3 do
        local v99 = u5:WaitForChild("Slot" .. tostring(i), 60);
        u14[i] = v99;
        AddListen.NumValueAdd(v99, function(p100) -- Line: 392
            -- upvalues: u13 (ref), i (copy), _renderSkillCd (ref), u8 (ref)
            local v101 = p100 - workspace:GetServerTimeNow();

            if v101 > 0.05 then
                u13[i] = v101;
            else
                u13[i] = nil;
            end;

            _renderSkillCd(u8[i], i);
        end);
    end;

    u5.ChildAdded:Connect(function(p102) -- Line: 416
        -- upvalues: u14 (ref), AddListen (ref), u13 (ref), _renderSkillCd (ref), u8 (ref)
        if not p102:IsA("NumberValue") then
            return;
        end;

        local u103 = tonumber(string.match(p102.Name, "^Slot(%d+)$"));

        if not u103 or (u103 < 1 or u103 > 3) then
            return;
        end;

        if u14[u103] then
            return;
        end;

        u14[u103] = p102;
        AddListen.NumValueAdd(p102, function(p104) -- Line: 392
            -- upvalues: u13 (ref), u103 (copy), _renderSkillCd (ref), u8 (ref)
            local v105 = p104 - workspace:GetServerTimeNow();

            if v105 > 0.05 then
                u13[u103] = v105;
            else
                u13[u103] = nil;
            end;

            _renderSkillCd(u8[u103], u103);
        end);
    end);

    return nil;
end)();

if u4 then
    u4.Visible = false;
end;

local v106 = Skill2:FindFirstChild("Linfo") or Skill2:FindFirstChild("LInfo");

if v106 then
    v106.Visible = true;
end;

local v107 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

if Unlock then
    Unlock.Visible = not v107;
end;

local v108 = Skill3:FindFirstChild("Linfo") or Skill3:FindFirstChild("LInfo");

if v108 then
    v108.Visible = v107;
end;

if v107 then
    u3.Visible = false;
end;

_bindSkillSlot3PassWatcher();
AddListen.NumValueAdd(u7, _onSkillDataChanged);
u13[1] = nil;
u13[2] = nil;
u13[3] = nil;
local v109 = _resolveRuntimeSkillId(1);

if v109 <= 0 then
    v109 = nil;
end;

u11[1] = v109;
local v110 = _resolveRuntimeSkillId(2);

if v110 <= 0 then
    v110 = nil;
end;

u11[2] = v110;
local v111 = _resolveRuntimeSkillId(3);

if v111 <= 0 then
    v111 = nil;
end;

u11[3] = v111;

if u4 then
    u4.Visible = false;
end;

local v112 = Skill2:FindFirstChild("Linfo") or Skill2:FindFirstChild("LInfo");

if v112 then
    v112.Visible = true;
end;

local v113 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

if Unlock then
    Unlock.Visible = not v113;
end;

local v114 = Skill3:FindFirstChild("Linfo") or Skill3:FindFirstChild("LInfo");

if v114 then
    v114.Visible = v113;
end;

if v113 then
    u3.Visible = false;
end;

local v115 = u8[1];
_renderSkillName(v115, 1);
_renderSkillCd(v115, 1);
local v116 = u8[2];
_renderSkillName(v116, 2);
_renderSkillCd(v116, 2);
local v117 = u8[3];
_renderSkillName(v117, 3);
_renderSkillCd(v117, 3);
_renderPendingSlots();
UIMgr.SetSkillBarHasEquippedSkill(_resolveRuntimeSkillId(1) > 0 and true or (_resolveRuntimeSkillId(2) > 0 and true or _resolveRuntimeSkillId(3) > 0));
AddListen.NumValueAdd(Skill12, _onSkillDataChanged);
AddListen.NumValueAdd(Skill22, _onSkillDataChanged);
AddListen.NumValueAdd(Skill32, _onSkillDataChanged);
PlayerData.ListenClientSync(function(p118, p119) -- Line: 605
    -- upvalues: u13 (copy), _resolveRuntimeSkillId (copy), u11 (copy), u4 (copy), Skill2 (copy), GetData (copy), LocalPlayer (copy), Unlock (copy), Skill3 (copy), u3 (copy), u8 (copy), _renderSkillName (copy), _renderSkillCd (copy), _renderPendingSlots (copy), UIMgr (copy)
    if p118 == nil then
        p118 = nil;
    elseif type(p118) ~= "string" then
        if type(p118) == "table" then
            p118 = p118[1];
        else
            p118 = nil;
        end;
    end;

    if p118 == nil or p118 == "skills" then
        u13[1] = nil;
        u13[2] = nil;
        u13[3] = nil;
        local v120 = _resolveRuntimeSkillId(1);

        if v120 <= 0 then
            v120 = nil;
        end;

        u11[1] = v120;
        local v121 = _resolveRuntimeSkillId(2);

        if v121 <= 0 then
            v121 = nil;
        end;

        u11[2] = v121;
        local v122 = _resolveRuntimeSkillId(3);

        if v122 <= 0 then
            v122 = nil;
        end;

        u11[3] = v122;

        if u4 then
            u4.Visible = false;
        end;

        local v123 = Skill2;
        local v124 = v123:FindFirstChild("Linfo") or v123:FindFirstChild("LInfo");

        if v124 then
            v124.Visible = true;
        end;

        local v125 = GetData.IsHasPass(LocalPlayer, "SkillSlot3");

        if Unlock then
            Unlock.Visible = not v125;
        end;

        local v126 = Skill3;
        local v127 = v126:FindFirstChild("Linfo") or v126:FindFirstChild("LInfo");

        if v127 then
            v127.Visible = v125;
        end;

        if v125 then
            u3.Visible = false;
        end;

        local v128 = u8[1];
        _renderSkillName(v128, 1);
        _renderSkillCd(v128, 1);
        local v129 = u8[2];
        _renderSkillName(v129, 2);
        _renderSkillCd(v129, 2);
        local v130 = u8[3];
        _renderSkillName(v130, 3);
        _renderSkillCd(v130, 3);
        _renderPendingSlots();
        UIMgr.SetSkillBarHasEquippedSkill(_resolveRuntimeSkillId(1) > 0 and true or (_resolveRuntimeSkillId(2) > 0 and true or _resolveRuntimeSkillId(3) > 0));
    end;
end);
RunService.Heartbeat:Connect(function(p131) -- Line: 612
    -- upvalues: u12 (ref), _renderSkillCd (copy), u8 (copy)
    u12 = u12 + p131;

    if u12 < 0.05 then
        return;
    end;

    u12 = 0;
    _renderSkillCd(u8[1], 1);
    _renderSkillCd(u8[2], 2);
    _renderSkillCd(u8[3], 3);
end);