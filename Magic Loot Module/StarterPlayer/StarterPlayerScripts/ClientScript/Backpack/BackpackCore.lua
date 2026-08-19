-- Decompiled with Potassium's decompiler.

local ContextActionService = game:GetService("ContextActionService");
local StarterGui = game:GetService("StarterGui");
local UserInputService = game:GetService("UserInputService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local BackpackAllUI = require(script.Parent.BackpackAllUI);
local BackpackLock = require(script.Parent.BackpackLock);
local AddListen = UtilsSystem.AddListen;
local UIMgr = UtilsSystem.UIMgr;
local TranslationHelper = UtilsSystem.TranslationHelper;
local PlayerData = UtilsSystem.PlayerData;
local CfgFind = UtilsSystem.CfgFind;
local GetData = UtilsSystem.GetData;
local InsMgr = UtilsSystem.InsMgr;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local TipsModule = UtilsSystem.TipsModule;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local Alchemy = GetData.Alchemy;
local u1 = {};
local u2 = {
    [Enum.KeyCode.One] = 1,
    [Enum.KeyCode.Two] = 2,
    [Enum.KeyCode.Three] = 3,
    [Enum.KeyCode.Four] = 4,
    [Enum.KeyCode.Five] = 5,
    [Enum.KeyCode.Six] = 6,
    [Enum.KeyCode.Seven] = 7,
    [Enum.KeyCode.Eight] = 8,
    [Enum.KeyCode.Nine] = 9
};
local u3 = nil;
local u4 = {};
local u5 = false;
local u6 = "All";
local u7 = "";
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};

local function _isAutoTraining() -- Line: 84
    -- upvalues: LocalPlayer (copy)
    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        return IsAutoTraining.Value;
    end;

    return false;
end;

local function _isDungeonCombat() -- Line: 97
    -- upvalues: LocalPlayer (copy)
    local InDungeonChallenge = LocalPlayer:FindFirstChild("InDungeonChallenge");

    if not InDungeonChallenge or (not InDungeonChallenge:IsA("NumberValue") or InDungeonChallenge.Value <= 0) then
        return false;
    end;

    local InStageSafeArea = LocalPlayer:FindFirstChild("InStageSafeArea");

    return (not InStageSafeArea or (not InStageSafeArea:IsA("NumberValue") or InStageSafeArea.Value <= 0)) and true or false;
end;

local function _isHeldSwitchBlocked() -- Line: 114
    -- upvalues: LocalPlayer (copy), _isDungeonCombat (copy)
    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v13;

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        v13 = IsAutoTraining.Value;
    else
        v13 = false;
    end;

    return v13 or _isDungeonCombat();
end;

local function _notifyHeldSwitchBlocked() -- Line: 123
    -- upvalues: LocalPlayer (copy), TipsModule (copy), _isDungeonCombat (copy)
    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v14;

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        v14 = IsAutoTraining.Value;
    else
        v14 = false;
    end;

    if v14 then
        TipsModule.ErrorTips(LocalPlayer, "训练中无法切换手持物品");
    elseif _isDungeonCombat() then
        TipsModule.ErrorTips(LocalPlayer, "战斗中无法切换手持物品");
    end;

    return nil;
end;

function u1.isWarehouseOpen() -- Line: 136
    -- upvalues: u5 (ref)
    return u5;
end;

function u1.toggleWarehouse() -- Line: 144
    -- upvalues: u3 (ref), u5 (ref), UIMgr (copy), BackpackLock (copy), u1 (copy)
    if not u3 then
        return nil;
    end;

    u5 = not u5;
    u3.warehouse.Visible = u5;
    UIMgr.SetSkillBarVisible(not u5);

    if not u5 then
        BackpackLock.onWarehouseClosed();
    end;

    u1.refreshAll();

    return nil;
end;

function u1.setWarehouseOpen(p15) -- Line: 163
    -- upvalues: u3 (ref), u5 (ref), UIMgr (copy), BackpackLock (copy), u1 (copy)
    if not u3 then
        return nil;
    end;

    u5 = p15;
    u3.warehouse.Visible = p15;
    UIMgr.SetSkillBarVisible(not p15);

    if not p15 then
        BackpackLock.onWarehouseClosed();
    end;

    u1.refreshAll();

    return nil;
end;

function u1.getToolbarSlots() -- Line: 181
    -- upvalues: u4 (copy)
    return u4;
end;

function u1.getWarehouseSlotFrames() -- Line: 189
    -- upvalues: u8 (ref)
    return u8;
end;

function u1.getWarehouseSlotByOnlyId(p16) -- Line: 199
    -- upvalues: u9 (ref)
    local v17 = tonumber(p16) or 0;

    if v17 <= 0 then
        return nil;
    end;

    return u9[v17];
end;

local function _refreshHeldMarks() -- Line: 211
    -- upvalues: PlayerData (copy), LocalPlayer (copy), u4 (copy), GetData (copy), u8 (ref)
    local v18 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local v19 = type(v18) ~= "table" and {} or v18;

    for i, v in u4 do
        if v.Visible then
            local v20 = GetData.GetBackpackToolbarItemAtUiSlot(v19, i, LocalPlayer);
            local v21 = v:FindFirstChild("已手持");

            if v21 then
                v21.Visible = GetData.IsToolbarSlotHeld(i, v20, LocalPlayer);
            end;
        end;
    end;

    for _, v in u8 do
        if v.Visible then
            local v22 = tonumber(v:GetAttribute("OnlyID")) or 0;
            local v23;

            if v22 > 0 then
                v23 = v19[tostring(v22)];
            else
                v23 = nil;
            end;

            local v24 = v:FindFirstChild("已手持");

            if v24 then
                v24.Visible = GetData.IsToolbarSlotHeld(0, v23, LocalPlayer);
            end;
        end;
    end;

    return nil;
end;

local function _isItemLocked(p25) -- Line: 243
    if type(p25) ~= "table" then
        return false;
    end;

    local lock = p25.lock;

    return lock == 1 and true or lock == true;
end;

local function _shouldShowMarkIndicator(p26) -- Line: 257
    -- upvalues: ItemType (copy), Alchemy (copy), LocalPlayer (copy)
    if not p26 then
        return false;
    end;

    if tonumber(p26.tp) ~= ItemType.Material then
        return false;
    end;

    local v27;

    if type(p26) == "table" then
        local lock = p26.lock;
        v27 = lock == 1 and true or lock == true;
    else
        v27 = false;
    end;

    if v27 then
        return true;
    end;

    local v28 = tonumber(p26.id);

    if v28 then
        return Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v28);
    end;

    return false;
end;

local function _refreshMarkIndicators() -- Line: 278
    -- upvalues: PlayerData (copy), LocalPlayer (copy), u4 (copy), GetData (copy), ItemType (copy), Alchemy (copy), u8 (ref)
    local v29 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local v30 = type(v29) ~= "table" and {} or v29;

    for i, v in u4 do
        if v.Visible then
            local v31 = GetData.GetBackpackToolbarItemAtUiSlot(v30, i, LocalPlayer);
            local v32 = v:FindFirstChild("已标记", true);

            if v32 then
                local v33;

                if v31 and tonumber(v31.tp) == ItemType.Material then
                    local v34;

                    if type(v31) == "table" then
                        local lock = v31.lock;
                        v34 = lock == 1 and true or lock == true;
                    else
                        v34 = false;
                    end;

                    if v34 then
                        v33 = true;
                    else
                        local v35 = tonumber(v31.id);

                        if v35 then
                            v33 = Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v35);
                        else
                            v33 = false;
                        end;
                    end;
                else
                    v33 = false;
                end;

                v32.Visible = v33;
            end;
        end;
    end;

    for _, v in u8 do
        if v.Visible and v.Parent then
            local v36 = tonumber(v:GetAttribute("OnlyID")) or 0;
            local v37;

            if v36 > 0 then
                v37 = v30[tostring(v36)];
            else
                v37 = nil;
            end;

            local v38 = v:FindFirstChild("已标记", true);

            if v38 then
                local v39;

                if v37 and tonumber(v37.tp) == ItemType.Material then
                    local v40;

                    if type(v37) == "table" then
                        local lock = v37.lock;
                        v40 = lock == 1 and true or lock == true;
                    else
                        v40 = false;
                    end;

                    if v40 then
                        v39 = true;
                    else
                        local v41 = tonumber(v37.id);

                        if v41 then
                            v39 = Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v41);
                        else
                            v39 = false;
                        end;
                    end;
                else
                    v39 = false;
                end;

                v38.Visible = v39;
            end;
        end;
    end;

    return nil;
end;

local function _applyOptimisticHeldMark(p42) -- Line: 310
    -- upvalues: PlayerData (copy), LocalPlayer (copy), GetData (copy), u4 (copy)
    local v43 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local v44 = type(v43) ~= "table" and {} or v43;
    local v45 = GetData.GetBackpackToolbarItemAtUiSlot(v44, p42, LocalPlayer);

    if not v45 then
        return nil;
    end;

    local v46 = GetData.IsToolbarSlotHeld(p42, v45, LocalPlayer);

    for i, v in u4 do
        if v.Visible then
            local v47 = v:FindFirstChild("已手持");

            if v47 then
                if v46 then
                    v47.Visible = false;
                else
                    v47.Visible = i == p42;
                end;
            end;
        end;
    end;

    return nil;
end;

local function _applyOptimisticHeldMarkByOnlyId(p48) -- Line: 340
    -- upvalues: GetData (copy), LocalPlayer (copy), u4 (copy), PlayerData (copy), u8 (ref)
    local v49 = GetData.GetHeldToolbarOnlyId(LocalPlayer) == p48;

    for i, v in u4 do
        if v.Visible then
            local v50 = v:FindFirstChild("已手持");

            if v50 then
                if v49 then
                    v50.Visible = false;
                else
                    local v51 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
                    local v52 = type(v51) ~= "table" and {} or v51;
                    local v53 = GetData.GetBackpackToolbarItemAtUiSlot(v52, i, LocalPlayer);

                    if v53 then
                        v53 = v53.onlyID;
                    end;

                    local v54 = tonumber(v53) or 0;
                    local v55;

                    if v54 > 0 then
                        v55 = v54 == p48;
                    else
                        v55 = false;
                    end;

                    v50.Visible = v55;
                end;
            end;
        end;
    end;

    for _, v in u8 do
        if v.Visible then
            local v56 = tonumber(v:GetAttribute("OnlyID")) or 0;
            local v57 = v:FindFirstChild("已手持");

            if v57 then
                if v49 then
                    v57.Visible = false;
                else
                    v57.Visible = v56 == p48;
                end;
            end;
        end;
    end;

    return nil;
end;

local function _renderSlot(p58, p59, p60, p61, p62) -- Line: 386
    -- upvalues: TranslationHelper (copy), UIMgr (copy), CfgFind (copy), Log (copy), GetData (copy), LocalPlayer (copy), ItemType (copy), Alchemy (copy)
    local Icon = p58:FindFirstChild("Icon");
    local ViewportFrame = p58:FindFirstChild("ViewportFrame");
    local Name = p58:FindFirstChild("Name");
    local Number = p58:FindFirstChild("Number");
    local v63 = p58:FindFirstChild("已手持");
    local v64 = p58:FindFirstChild("付费");
    local v65 = p58:FindFirstChild("已标记", true);

    if Icon then
        Icon.Visible = false;
    end;

    if ViewportFrame then
        ViewportFrame.Visible = false;
    end;

    if Name then
        Name.Visible = false;
    end;

    if Number then
        if p62 == "slotIndex" then
            Number.Visible = true;
        else
            local v66;

            if p59 == nil or p59.count == nil then
                v66 = false;
            else
                v66 = p59.count > 1;
            end;

            Number.Visible = v66;

            if Number.Visible then
                TranslationHelper.SetText_UnTrans(Number, (tostring(p59.count)));
            else
                TranslationHelper.SetText_UnTrans(Number, "");
            end;
        end;
    end;

    if not p59 then
        if v63 then
            v63.Visible = false;
        end;

        if v64 then
            v64.Visible = false;
        end;

        if v65 then
            v65.Visible = false;
        end;

        if Name then
            UIMgr.RemoveGradientColor(Name);
        end;

        return nil;
    end;

    local v67 = tonumber(p59.tp) or 0;
    local v68 = CfgFind.FindCfgByID(p59.id, v67);

    if not v68 then
        Log.warn("[BackpackCore] cfg missing", p59.id, v67);

        return nil;
    end;

    if Name then
        Name.Visible = true;
        TranslationHelper.SetText(Name, v68.ZhName or "");
        local v69 = tonumber(p59.xyd) or tonumber(v68.xyd);

        if v69 then
            UIMgr.RemoveGradientColor(Name);
            UIMgr.AddGradientColor(v69, Name, true, nil, false);
        else
            UIMgr.RemoveGradientColor(Name);
            Log.warn("[BackpackCore] xyd missing for Name color", p59.id, v67);
        end;
    end;

    if v63 then
        v63.Visible = GetData.IsToolbarSlotHeld(p61, p59, LocalPlayer);
    end;

    if v64 then
        v64.Visible = p59.Pay == true;
    end;

    if v65 then
        local v70;

        if p59 and tonumber(p59.tp) == ItemType.Material then
            local v71;

            if type(p59) == "table" then
                local lock = p59.lock;
                v71 = lock == 1 and true or lock == true;
            else
                v71 = false;
            end;

            if v71 then
                v70 = true;
            else
                local v72 = tonumber(p59.id);

                if v72 then
                    v70 = Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v72);
                else
                    v70 = false;
                end;
            end;
        else
            v70 = false;
        end;

        v65.Visible = v70;
    end;

    if p60 and ViewportFrame then
        ViewportFrame.Visible = true;
        UIMgr.SetViewPort(ViewportFrame, p59.id, false, {
            itemTp = ItemType.Weapon
        });
    elseif Icon then
        Icon.Visible = true;

        if v68.Icon then
            Icon.Image = "rbxassetid://" .. tostring(v68.Icon);
        end;
    end;

    return nil;
end;

local function _onToolbarSlotClick(p73) -- Line: 489
    -- upvalues: PlayerData (copy), LocalPlayer (copy), GetData (copy), BackpackLock (copy), _isDungeonCombat (copy), TipsModule (copy), _applyOptimisticHeldMark (copy), NetWork (copy), NetMsg (copy)
    local v74 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local v75 = type(v74) ~= "table" and {} or v74;
    local v76 = GetData.GetBackpackToolbarItemAtUiSlot(v75, p73, LocalPlayer);
    local v77;

    if v76 then
        v77 = v76.onlyID;
    else
        v77 = v76;
    end;

    local v78 = tonumber(v77) or 0;

    if BackpackLock.tryHandleSlotClick(v78, v76) then
        return nil;
    end;

    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v79;

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        v79 = IsAutoTraining.Value;
    else
        v79 = false;
    end;

    if not (v79 or _isDungeonCombat()) then
        _applyOptimisticHeldMark(p73);
        NetWork.FireServer(NetMsg.BACKPACK_TOGGLE_HELD, {
            uiSlotIndex = p73
        });

        return nil;
    end;

    local IsAutoTraining2 = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v80;

    if IsAutoTraining2 and IsAutoTraining2:IsA("BoolValue") then
        v80 = IsAutoTraining2.Value;
    else
        v80 = false;
    end;

    if v80 then
        TipsModule.ErrorTips(LocalPlayer, "训练中无法切换手持物品");
    elseif _isDungeonCombat() then
        TipsModule.ErrorTips(LocalPlayer, "战斗中无法切换手持物品");
    end;

    return nil;
end;

local function _onWarehouseSlotClick(p81) -- Line: 513
    -- upvalues: PlayerData (copy), LocalPlayer (copy), BackpackLock (copy), _isDungeonCombat (copy), TipsModule (copy), _applyOptimisticHeldMarkByOnlyId (copy), NetWork (copy), NetMsg (copy)
    if p81 <= 0 then
        return nil;
    end;

    local v82 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local v83;

    if type(v82) == "table" then
        v83 = v82[tostring(p81)];
    else
        v83 = nil;
    end;

    if BackpackLock.tryHandleSlotClick(p81, v83) then
        return nil;
    end;

    local IsAutoTraining = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v84;

    if IsAutoTraining and IsAutoTraining:IsA("BoolValue") then
        v84 = IsAutoTraining.Value;
    else
        v84 = false;
    end;

    if not (v84 or _isDungeonCombat()) then
        _applyOptimisticHeldMarkByOnlyId(p81);
        NetWork.FireServer(NetMsg.BACKPACK_TOGGLE_HELD, {
            onlyID = p81
        });

        return nil;
    end;

    local IsAutoTraining2 = LocalPlayer:FindFirstChild("IsAutoTraining");
    local v85;

    if IsAutoTraining2 and IsAutoTraining2:IsA("BoolValue") then
        v85 = IsAutoTraining2.Value;
    else
        v85 = false;
    end;

    if v85 then
        TipsModule.ErrorTips(LocalPlayer, "训练中无法切换手持物品");
    elseif _isDungeonCombat() then
        TipsModule.ErrorTips(LocalPlayer, "战斗中无法切换手持物品");
    end;

    return nil;
end;

local function _rebuildToolbarOnlyIdCache(p86) -- Line: 536
    -- upvalues: u11 (copy), GetData (copy), LocalPlayer (copy)
    table.clear(u11);

    for i = GetData.GetBackpackToolbarItemSlotMin(), GetData.GetBackpackToolbarSlotCount() do
        local v87 = GetData.GetBackpackToolbarItemAtUiSlot(p86, i, LocalPlayer);

        if v87 then
            local v88 = tonumber(v87.onlyID) or 0;

            if v88 > 0 then
                u11[i] = v88;
            end;
        end;
    end;

    return nil;
end;

local function _rebuildWarehouseOnlyIdCache(p89) -- Line: 557
    -- upvalues: u12 (copy), GetData (copy)
    table.clear(u12);

    for _, v in GetData.QueryBackpackWarehouseItems(p89, "All", "") do
        local v90 = tonumber(v.onlyID) or 0;

        if v90 > 0 then
            u12[v90] = true;
        end;
    end;

    return nil;
end;

local function _refreshToolbar(p91) -- Line: 575
    -- upvalues: GetData (copy), BackpackLock (copy), u4 (copy), LocalPlayer (copy), u5 (ref), ItemType (copy), _renderSlot (copy), TranslationHelper (copy)
    local v92 = GetData.GetBackpackToolbarSlotCount();
    local v93 = BackpackLock.isActive();

    for i, v in u4 do
        if v92 < i then
            v.Visible = false;
        else
            local v94 = GetData.GetBackpackToolbarItemAtUiSlot(p91, i, LocalPlayer);
            local v95 = u5 or v94 ~= nil;

            if v93 then
                if v94 == nil then
                    v95 = false;
                else
                    v95 = tonumber(v94.tp) == ItemType.Material;
                end;
            end;

            v.Visible = v95;

            if v95 then
                _renderSlot(v, v94, i == 1, i, "slotIndex");
                local Number = v:FindFirstChild("Number");

                if Number then
                    TranslationHelper.SetText_UnTrans(Number, (tostring(i)));
                end;
            end;
        end;
    end;

    return nil;
end;

local function _warehouseRenderSig(p96) -- Line: 607
    -- upvalues: Alchemy (copy), LocalPlayer (copy)
    local v97 = tonumber(p96.id) or 0;
    local v98;

    if v97 > 0 then
        v98 = Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v97);
    else
        v98 = false;
    end;

    local v99;

    if type(p96) == "table" then
        local lock = p96.lock;
        v99 = lock == 1 and true or lock == true;
    else
        v99 = false;
    end;

    return string.format("%s_%s_%s_%s_%s", tostring(p96.id), tostring(p96.count or 1), p96.Pay == true and "1" or "0", v98 and "1" or "0", v99 and "1" or "0");
end;

local function _refreshWarehouse(p100) -- Line: 627
    -- upvalues: u3 (ref), BackpackLock (copy), u6 (ref), GetData (copy), u7 (ref), u8 (ref), u9 (ref), _warehouseRenderSig (copy), _renderSlot (copy), BackpackAllUI (copy), AddListen (copy), _onWarehouseSlotClick (copy), UIMgr (copy), LocalPlayer (copy), TranslationHelper (copy)
    local v101 = {};
    local v102 = {};

    if not u3 then
        return v101, v102;
    end;

    local v103 = BackpackLock.isActive() and "Material" or u6;
    local v104 = GetData.QueryBackpackWarehouseItems(p100, v103, u7);
    local warehouseTemp = u3.warehouseTemp;
    warehouseTemp.Visible = false;
    local v105 = #u8;
    local v106 = {};
    local v107 = {};
    local v108 = {};

    for i, v in ipairs(v104) do
        local u109 = tonumber(v.onlyID) or 0;

        if u109 > 0 then
            v106[u109] = true;
            local v110 = u9[u109];
            local v111 = _warehouseRenderSig(v);

            if v110 and v110.Parent ~= nil then
                if v110:GetAttribute("RenderSig") ~= v111 then
                    v110:SetAttribute("RenderSig", v111);
                    _renderSlot(v110, v, false, 0, "count");
                end;
            else
                v110 = warehouseTemp:Clone();
                v110.Name = "Warehouse_" .. tostring(u109);
                v110.Visible = true;
                v110.Parent = u3.warehouseScroll;
                v110:SetAttribute("OnlyID", u109);
                v110:SetAttribute("RenderSig", v111);
                _renderSlot(v110, v, false, 0, "count");
                local v112 = BackpackAllUI.findSlotButton(v110, "warehouse:" .. tostring(u109));

                if v112 then
                    AddListen.AddMouseCLick(v112, function() -- Line: 661
                        -- upvalues: _onWarehouseSlotClick (ref), u109 (copy)
                        _onWarehouseSlotClick(u109);
                    end);
                end;

                table.insert(v101, u109);
            end;

            v110.LayoutOrder = i;
            v107[u109] = v110;
            table.insert(v108, v110);
        end;
    end;

    for i, v in u9 do
        if not v106[i] then
            table.insert(v102, i);

            if v.Parent then
                v:Destroy();
            end;
        end;
    end;

    u9 = v107;
    u8 = v108;

    if #v108 ~= v105 then
        UIMgr.SetUIlistSize(u3.warehouseScroll);
    end;

    local v113 = GetData.GetBackpackWarehouseCurrentSize(LocalPlayer);
    local v114 = GetData.GetBackpackWarehouseMaxSize();

    if u3.capacitySize then
        TranslationHelper.SetText_UnTrans(u3.capacitySize, string.format("%d / %d", v113, v114));
    end;

    return v101, v102;
end;

local function _refreshWarehouseAndRebind(p115) -- Line: 708
    -- upvalues: _refreshWarehouse (copy), _rebuildWarehouseOnlyIdCache (copy)
    local v116, v117 = _refreshWarehouse(p115);
    _rebuildWarehouseOnlyIdCache(p115);
    local BackpackDrag = require(script.Parent.BackpackDrag);

    if #v116 == 0 and #v117 == 0 then
        return nil;
    end;

    BackpackDrag.rebindWarehouseSlots(v116, v117);

    return nil;
end;

function u1.refreshAll() -- Line: 724
    -- upvalues: PlayerData (copy), LocalPlayer (copy), _refreshToolbar (copy), _rebuildToolbarOnlyIdCache (copy), u5 (ref), _refreshWarehouse (copy), _rebuildWarehouseOnlyIdCache (copy)
    local v118 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
    local v119 = type(v118) ~= "table" and {} or v118;
    _refreshToolbar(v119);
    _rebuildToolbarOnlyIdCache(v119);

    if u5 then
        local v120, v121 = _refreshWarehouse(v119);
        _rebuildWarehouseOnlyIdCache(v119);
        local BackpackDrag = require(script.Parent.BackpackDrag);

        if #v120 ~= 0 or #v121 ~= 0 then
            BackpackDrag.rebindWarehouseSlots(v120, v121);
        end;
    end;

    return nil;
end;

local function _findBagKeyByEquipOnCopy(p122, p123) -- Line: 744
    -- upvalues: ItemType (copy)
    for i, v in pairs(p122) do
        if type(v) == "table" then
            local v124 = tonumber(v.tp) or 0;

            if (v124 == ItemType.Potion or v124 == ItemType.Material) and tonumber(v.equip) == p123 then
                return i;
            end;
        end;
    end;

    return nil;
end;

function u1.applyOptimisticDrag(p125, p126) -- Line: 764
    -- upvalues: PlayerData (copy), LocalPlayer (copy), GetData (copy), _findBagKeyByEquipOnCopy (copy), ItemType (copy), _refreshToolbar (copy), _rebuildToolbarOnlyIdCache (copy), u5 (ref), _refreshWarehouse (copy), _rebuildWarehouseOnlyIdCache (copy)
    if type(p125) ~= "table" or type(p126) ~= "table" then
        return nil;
    end;

    local v127 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v127) ~= "table" then
        return nil;
    end;

    local v128 = GetData.GetBackpackToolbarItemSlotMin();
    local zone = p125.zone;
    local zone2 = p126.zone;

    if zone == "toolbar" and zone2 == "toolbar" then
        local v129 = tonumber(p125.equipSlot) or 0;
        local v130 = tonumber(p126.equipSlot) or 0;

        if v129 < v128 or (v130 < v128 or v129 == v130) then
            return nil;
        end;

        local v131 = _findBagKeyByEquipOnCopy(v127, v129);
        local v132 = _findBagKeyByEquipOnCopy(v127, v130);

        if v131 ~= nil and type(v127[v131]) == "table" then
            v127[v131].equip = v130;
        end;

        if v132 ~= nil and type(v127[v132]) == "table" then
            v127[v132].equip = v129;
        end;
    elseif zone == "toolbar" and zone2 == "warehouse" then
        local v133 = tonumber(p125.equipSlot) or 0;

        if v133 < v128 then
            return nil;
        end;

        local v134 = _findBagKeyByEquipOnCopy(v127, v133);

        if v134 ~= nil and type(v127[v134]) == "table" then
            v127[v134].equip = 0;
        end;
    else
        if zone ~= "warehouse" or zone2 ~= "toolbar" then
            return nil;
        end;

        local v135 = tonumber(p125.onlyID) or 0;
        local v136 = tonumber(p126.equipSlot) or 0;

        if v135 <= 0 or v136 < v128 then
            return nil;
        end;

        local v137 = tostring(v135);
        local v138 = v127[v137];

        if type(v138) ~= "table" then
            v138 = v127[v135];
        end;

        if type(v138) ~= "table" then
            return nil;
        end;

        local v139 = tonumber(v138.tp) or 0;

        if v139 ~= ItemType.Potion and v139 ~= ItemType.Material then
            return nil;
        end;

        for i, v in pairs(v127) do
            if tostring(i) ~= v137 and type(v) == "table" then
                local v140 = tonumber(v.tp) or 0;

                if (v140 == ItemType.Potion or v140 == ItemType.Material) and tonumber(v.equip) == v136 then
                    v.equip = 0;
                end;
            end;
        end;

        v138.equip = v136;
    end;

    _refreshToolbar(v127);
    _rebuildToolbarOnlyIdCache(v127);

    if u5 and (zone ~= "toolbar" or zone2 ~= "toolbar") then
        local v141, v142 = _refreshWarehouse(v127);
        _rebuildWarehouseOnlyIdCache(v127);
        local BackpackDrag = require(script.Parent.BackpackDrag);

        if #v141 ~= 0 or #v142 ~= 0 then
            BackpackDrag.rebindWarehouseSlots(v141, v142);
        end;
    end;

    return nil;
end;

local function _updateTabHighlight() -- Line: 848
    -- upvalues: u3 (ref), u6 (ref)
    if not u3 then
        return nil;
    end;

    for i, v in u3.tabFrames do
        local v143 = i == u6;
        local ChooseBg = v:FindFirstChild("ChooseBg");
        local Bg = v:FindFirstChild("Bg");

        if ChooseBg then
            ChooseBg.Visible = v143;
        end;

        if Bg then
            Bg.Visible = not v143;
        end;
    end;

    return nil;
end;

local function _bindTabs() -- Line: 870
    -- upvalues: u3 (ref), BackpackAllUI (copy), u10 (copy), AddListen (copy), u6 (ref), _updateTabHighlight (copy), u1 (copy)
    if not u3 then
        return nil;
    end;

    for _, v in { "All", "Potion", "Material" } do
        local v144 = u3.tabFrames[v];
        local v145 = BackpackAllUI.findSlotButton(v144, "tab:" .. v);

        if v145 then
            u10[v] = v145;
            AddListen.AddMouseCLick(v145, function() -- Line: 880
                -- upvalues: u6 (ref), v (copy), _updateTabHighlight (ref), u1 (ref)
                u6 = v;
                _updateTabHighlight();
                u1.refreshAll();
            end, v144);
        end;
    end;

    _updateTabHighlight();

    return nil;
end;

local function _bindSearch() -- Line: 895
    -- upvalues: u3 (ref), u7 (ref), u1 (copy)
    if not (u3 and u3.searchBox) then
        return nil;
    end;

    u3.searchBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 899
        -- upvalues: u7 (ref), u3 (ref), u1 (ref)
        u7 = u3.searchBox.Text or "";
        u1.refreshAll();
    end);

    return nil;
end;

local function _buildToolbarSlots() -- Line: 910
    -- upvalues: u3 (ref), u4 (copy), GetData (copy), BackpackAllUI (copy), AddListen (copy), _onToolbarSlotClick (copy)
    if not u3 then
        return nil;
    end;

    local toolbarTemp = u3.toolbarTemp;
    toolbarTemp.Visible = false;
    table.clear(u4);

    for i = 1, GetData.GetBackpackToolbarSlotCount() do
        local v146 = toolbarTemp:Clone();
        v146.Name = "Slot" .. i;
        v146.Visible = true;
        v146.Parent = u3.toolbar;
        v146:SetAttribute("UiSlotIndex", i);
        v146:SetAttribute("EquipSlot", i);
        local v147 = BackpackAllUI.findSlotButton(v146, "toolbar:" .. i);

        if v147 then
            AddListen.AddMouseCLick(v147, function() -- Line: 928
                -- upvalues: _onToolbarSlotClick (ref), i (copy)
                _onToolbarSlotClick(i);
            end);
        end;

        table.insert(u4, v146);
    end;

    return nil;
end;

local function _bindWarehouseHotkey() -- Line: 941
    -- upvalues: ContextActionService (copy), u1 (copy)
    ContextActionService:BindAction("BackpackWarehouseToggle", function(p148, p149) -- Line: 944
        -- upvalues: u1 (ref)
        if p149 == Enum.UserInputState.Begin then
            u1.toggleWarehouse();
        end;

        return Enum.ContextActionResult.Sink;
    end, false, Enum.KeyCode.Backquote);

    return nil;
end;

local function _bindToolbarHotkeys() -- Line: 960
    -- upvalues: UserInputService (copy), u2 (copy), GetData (copy), u4 (copy), _onToolbarSlotClick (copy)
    UserInputService.InputBegan:Connect(function(p150, p151) -- Line: 961
        -- upvalues: u2 (ref), GetData (ref), u4 (ref), _onToolbarSlotClick (ref)
        if p151 then
            return;
        end;

        if p150.UserInputType ~= Enum.UserInputType.Keyboard then
            return;
        end;

        local v152 = u2[p150.KeyCode];

        if not v152 then
            return;
        end;

        if GetData.GetBackpackToolbarSlotCount() < v152 then
            return;
        end;

        local v153 = u4[v152];

        if not (v153 and v153.Visible) then
            return;
        end;

        _onToolbarSlotClick(v152);
    end);

    return nil;
end;

local function _bindHeldOnlyIdWatch() -- Line: 988
    -- upvalues: LocalPlayer (copy), AddListen (copy), _refreshHeldMarks (copy)
    local v154 = LocalPlayer:WaitForChild("当前手持OnlyID", (1 / 0));
    AddListen.NumValueAdd(v154, function(p155) -- Line: 990
        -- upvalues: _refreshHeldMarks (ref)
        _refreshHeldMarks();
    end, true);

    return nil;
end;

local function _bindAlchemyMarkWatch() -- Line: 1000
    -- upvalues: LocalPlayer (copy), Alchemy (copy), AddListen (copy), _refreshMarkIndicators (copy), PlayerData (copy)
    task.defer(function() -- Line: 1001
        -- upvalues: LocalPlayer (ref), Alchemy (ref), AddListen (ref), _refreshMarkIndicators (ref), PlayerData (ref)
        local v156 = LocalPlayer:WaitForChild(Alchemy.GetMarkFolderName(), 10);

        if v156 and v156:IsA("Folder") then
            local u157 = Alchemy.GetMarkRecipeIdValueName();
            local v158 = v156:WaitForChild(u157, 5);

            if v158 and v158:IsA("NumberValue") then
                AddListen.NumValueAdd(v158, function(p159) -- Line: 1007
                    -- upvalues: _refreshMarkIndicators (ref)
                    _refreshMarkIndicators();
                end, false);
            end;

            v156.ChildAdded:Connect(function(p160) -- Line: 1011
                -- upvalues: u157 (copy), _refreshMarkIndicators (ref)
                if p160:IsA("NumberValue") and p160.Name ~= u157 then
                    _refreshMarkIndicators();
                end;
            end);
            v156.ChildRemoved:Connect(function(p161) -- Line: 1016
                -- upvalues: u157 (copy), _refreshMarkIndicators (ref)
                if p161:IsA("NumberValue") and p161.Name ~= u157 then
                    _refreshMarkIndicators();
                end;
            end);
        end;

        PlayerData.ListenClientSync(function(p162, p163) -- Line: 1023
            -- upvalues: _refreshMarkIndicators (ref)
            if type(p162) == "table" then
                p162 = p162[1];
            end;

            if p162 == "AlchemyMarkRecipeId" then
                _refreshMarkIndicators();
            end;
        end);
        _refreshMarkIndicators();

        return nil;
    end);

    return nil;
end;

local function _bindBagDataWatch() -- Line: 1040
    -- upvalues: PlayerData (copy), GetData (copy), LocalPlayer (copy), u11 (copy), u5 (ref), u12 (copy), _refreshToolbar (copy), _rebuildToolbarOnlyIdCache (copy), _refreshWarehouse (copy), _rebuildWarehouseOnlyIdCache (copy)
    PlayerData.ListenClientSync(function(p164, p165) -- Line: 1041
        -- upvalues: GetData (ref), LocalPlayer (ref), u11 (ref), u5 (ref), u12 (ref), PlayerData (ref), _refreshToolbar (ref), _rebuildToolbarOnlyIdCache (ref), _refreshWarehouse (ref), _rebuildWarehouseOnlyIdCache (ref)
        local v166 = GetData.ShouldRefreshToolbarOnPlayerDataSync(p164, p165, LocalPlayer, u11);
        local v167 = u5 and GetData.ShouldRefreshWarehouseOnPlayerDataSync(p164, p165, LocalPlayer, u11, u12);

        if not (v166 or v167) then
            return nil;
        end;

        local v168 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
        local v169 = type(v168) ~= "table" and {} or v168;

        if v166 then
            _refreshToolbar(v169);
            _rebuildToolbarOnlyIdCache(v169);
        end;

        if v167 then
            local v170, v171 = _refreshWarehouse(v169);
            _rebuildWarehouseOnlyIdCache(v169);
            local BackpackDrag = require(script.Parent.BackpackDrag);

            if #v170 ~= 0 or #v171 ~= 0 then
                BackpackDrag.rebindWarehouseSlots(v170, v171);
            end;
        end;

        return nil;
    end);

    return nil;
end;

function u1.bindToggleEvent() -- Line: 1084
    -- upvalues: InsMgr (copy), LocalPlayer (copy), u1 (copy)
    InsMgr.GetIns("ToggleBackpackWarehouse", "BindableEvent", LocalPlayer).Event:Connect(function() -- Line: 1086
        -- upvalues: u1 (ref)
        u1.toggleWarehouse();
    end);

    return nil;
end;

function u1.init(p172) -- Line: 1097
    -- upvalues: StarterGui (copy), u3 (ref), BackpackAllUI (copy), Log (copy), u5 (ref), UIMgr (copy), _buildToolbarSlots (copy), _bindTabs (copy), u7 (ref), u1 (copy), BackpackLock (copy), _refreshMarkIndicators (copy), ContextActionService (copy), UserInputService (copy), u2 (copy), GetData (copy), u4 (copy), _onToolbarSlotClick (copy), LocalPlayer (copy), AddListen (copy), _refreshHeldMarks (copy), Alchemy (copy), PlayerData (copy), u11 (copy), u12 (copy), _refreshToolbar (copy), _rebuildToolbarOnlyIdCache (copy), _refreshWarehouse (copy), _rebuildWarehouseOnlyIdCache (copy)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false);
    u3 = BackpackAllUI.collect(p172);

    if not u3 then
        Log.warn("[BackpackCore] Main.Backpack collect failed");

        return false;
    end;

    u3.warehouse.Visible = false;
    u5 = false;
    UIMgr.SetSkillBarVisible(true);
    _buildToolbarSlots();
    _bindTabs();

    if u3 and u3.searchBox then
        u3.searchBox:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 899
            -- upvalues: u7 (ref), u3 (ref), u1 (ref)
            u7 = u3.searchBox.Text or "";
            u1.refreshAll();
        end);
    end;

    BackpackLock.bind(u3, {
        onModeChanged = function() -- Line: 1114, Name: onModeChanged
            -- upvalues: u1 (ref)
            u1.refreshAll();
        end,

        onLockChanged = function() -- Line: 1117, Name: onLockChanged
            -- upvalues: _refreshMarkIndicators (ref)
            _refreshMarkIndicators();
        end
    });
    ContextActionService:BindAction("BackpackWarehouseToggle", function(p173, p174) -- Line: 944
        -- upvalues: u1 (ref)
        if p174 == Enum.UserInputState.Begin then
            u1.toggleWarehouse();
        end;

        return Enum.ContextActionResult.Sink;
    end, false, Enum.KeyCode.Backquote);
    UserInputService.InputBegan:Connect(function(p175, p176) -- Line: 961
        -- upvalues: u2 (ref), GetData (ref), u4 (ref), _onToolbarSlotClick (ref)
        if p176 then
            return;
        end;

        if p175.UserInputType ~= Enum.UserInputType.Keyboard then
            return;
        end;

        local v177 = u2[p175.KeyCode];

        if not v177 then
            return;
        end;

        if GetData.GetBackpackToolbarSlotCount() < v177 then
            return;
        end;

        local v178 = u4[v177];

        if not (v178 and v178.Visible) then
            return;
        end;

        _onToolbarSlotClick(v177);
    end);
    local v179 = LocalPlayer:WaitForChild("当前手持OnlyID", (1 / 0));
    AddListen.NumValueAdd(v179, function(p180) -- Line: 990
        -- upvalues: _refreshHeldMarks (ref)
        _refreshHeldMarks();
    end, true);
    task.defer(function() -- Line: 1001
        -- upvalues: LocalPlayer (ref), Alchemy (ref), AddListen (ref), _refreshMarkIndicators (ref), PlayerData (ref)
        local v181 = LocalPlayer:WaitForChild(Alchemy.GetMarkFolderName(), 10);

        if v181 and v181:IsA("Folder") then
            local u182 = Alchemy.GetMarkRecipeIdValueName();
            local v183 = v181:WaitForChild(u182, 5);

            if v183 and v183:IsA("NumberValue") then
                AddListen.NumValueAdd(v183, function(p184) -- Line: 1007
                    -- upvalues: _refreshMarkIndicators (ref)
                    _refreshMarkIndicators();
                end, false);
            end;

            v181.ChildAdded:Connect(function(p185) -- Line: 1011
                -- upvalues: u182 (copy), _refreshMarkIndicators (ref)
                if p185:IsA("NumberValue") and p185.Name ~= u182 then
                    _refreshMarkIndicators();
                end;
            end);
            v181.ChildRemoved:Connect(function(p186) -- Line: 1016
                -- upvalues: u182 (copy), _refreshMarkIndicators (ref)
                if p186:IsA("NumberValue") and p186.Name ~= u182 then
                    _refreshMarkIndicators();
                end;
            end);
        end;

        PlayerData.ListenClientSync(function(p187, p188) -- Line: 1023
            -- upvalues: _refreshMarkIndicators (ref)
            if type(p187) == "table" then
                p187 = p187[1];
            end;

            if p187 == "AlchemyMarkRecipeId" then
                _refreshMarkIndicators();
            end;
        end);
        _refreshMarkIndicators();

        return nil;
    end);
    PlayerData.ListenClientSync(function(p189, p190) -- Line: 1041
        -- upvalues: GetData (ref), LocalPlayer (ref), u11 (ref), u5 (ref), u12 (ref), PlayerData (ref), _refreshToolbar (ref), _rebuildToolbarOnlyIdCache (ref), _refreshWarehouse (ref), _rebuildWarehouseOnlyIdCache (ref)
        local v191 = GetData.ShouldRefreshToolbarOnPlayerDataSync(p189, p190, LocalPlayer, u11);
        local v192 = u5 and GetData.ShouldRefreshWarehouseOnPlayerDataSync(p189, p190, LocalPlayer, u11, u12);

        if not (v191 or v192) then
            return nil;
        end;

        local v193 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");
        local v194 = type(v193) ~= "table" and {} or v193;

        if v191 then
            _refreshToolbar(v194);
            _rebuildToolbarOnlyIdCache(v194);
        end;

        if v192 then
            local v195, v196 = _refreshWarehouse(v194);
            _rebuildWarehouseOnlyIdCache(v194);
            local BackpackDrag = require(script.Parent.BackpackDrag);

            if #v195 ~= 0 or #v196 ~= 0 then
                BackpackDrag.rebindWarehouseSlots(v195, v196);
            end;
        end;

        return nil;
    end);
    u1.bindToggleEvent();
    u1.refreshAll();

    return true;
end;

function u1.getBackpackIconAsset() -- Line: 1131
    return "rbxassetid://94344314841529";
end;

return u1;