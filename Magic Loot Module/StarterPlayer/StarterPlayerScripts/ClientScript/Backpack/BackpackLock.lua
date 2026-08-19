-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local BackpackAllUI = require(script.Parent.BackpackAllUI);
local AddListen = UtilsSystem.AddListen;
local LocalPlayer = UtilsSystem.LocalPlayer;
local Log = UtilsSystem.Log;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local TipsModule = UtilsSystem.TipsModule;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local Alchemy = UtilsSystem.GetData.Alchemy;
local v1 = {};
local u2 = nil;
local u3 = nil;
local u4 = false;
local u5 = nil;
local u6 = nil;

local function _isItemLocked(p7) -- Line: 49
    if type(p7) ~= "table" then
        return false;
    end;

    local lock = p7.lock;

    return lock == 1 and true or lock == true;
end;

local function _isRecipeMarkedMaterial(p8) -- Line: 62
    -- upvalues: ItemType (copy), Alchemy (copy), LocalPlayer (copy)
    if type(p8) ~= "table" or tonumber(p8.tp) ~= ItemType.Material then
        return false;
    end;

    local v9 = tonumber(p8.id);

    if v9 then
        return Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v9);
    end;

    return false;
end;

local function _refreshChrome() -- Line: 77
    -- upvalues: u2 (ref), u3 (ref), u4 (ref)
    if not u2 then
        return nil;
    end;

    if u3 then
        u3.Visible = not u4;
    end;

    u2.statusFrame.Visible = not u4;
    u2.lockAllFrame.Visible = u4;
    u2.unlockAllFrame.Visible = u4;
    u2.backFrame.Visible = u4;

    if u2.listLayout then
        local v10;

        if u4 then
            v10 = Enum.HorizontalAlignment.Left;
        else
            v10 = Enum.HorizontalAlignment.Right;
        end;

        u2.listLayout.HorizontalAlignment = v10;
    end;

    return nil;
end;

local function _notifyModeChanged() -- Line: 100
    -- upvalues: u5 (ref)
    if u5 then
        u5();
    end;

    return nil;
end;

local function _notifyLockChanged() -- Line: 111
    -- upvalues: u6 (ref)
    if u6 then
        u6();
    end;

    return nil;
end;

local function _enterLockMode() -- Line: 122
    -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref)
    if u4 or not u2 then
        return nil;
    end;

    u4 = true;

    if u2 then
        if u3 then
            u3.Visible = not u4;
        end;

        u2.statusFrame.Visible = not u4;
        u2.lockAllFrame.Visible = u4;
        u2.unlockAllFrame.Visible = u4;
        u2.backFrame.Visible = u4;

        if u2.listLayout then
            local v11;

            if u4 then
                v11 = Enum.HorizontalAlignment.Left;
            else
                v11 = Enum.HorizontalAlignment.Right;
            end;

            u2.listLayout.HorizontalAlignment = v11;
        end;
    end;

    if u5 then
        u5();
    end;

    return nil;
end;

local function _exitLockMode() -- Line: 136
    -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref)
    if not u4 then
        if u2 then
            if u3 then
                u3.Visible = not u4;
            end;

            u2.statusFrame.Visible = not u4;
            u2.lockAllFrame.Visible = u4;
            u2.unlockAllFrame.Visible = u4;
            u2.backFrame.Visible = u4;

            if u2.listLayout then
                local v12;

                if u4 then
                    v12 = Enum.HorizontalAlignment.Left;
                else
                    v12 = Enum.HorizontalAlignment.Right;
                end;

                u2.listLayout.HorizontalAlignment = v12;
            end;
        end;

        return nil;
    end;

    u4 = false;

    if u2 then
        if u3 then
            u3.Visible = not u4;
        end;

        u2.statusFrame.Visible = not u4;
        u2.lockAllFrame.Visible = u4;
        u2.unlockAllFrame.Visible = u4;
        u2.backFrame.Visible = u4;

        if u2.listLayout then
            local v13;

            if u4 then
                v13 = Enum.HorizontalAlignment.Left;
            else
                v13 = Enum.HorizontalAlignment.Right;
            end;

            u2.listLayout.HorizontalAlignment = v13;
        end;
    end;

    if u5 then
        u5();
    end;

    return nil;
end;

local function _applyLockOne(p14, p15, p16) -- Line: 154
    -- upvalues: NetWork (copy), NetMsg (copy), u6 (ref)
    p14.lock = p16 and 1 or 0;
    NetWork.FireServer(NetMsg.BAG_LOCK_ITEMS, {
        onlyID = p15,
        isLock = p16 and 1 or 0
    });

    if u6 then
        u6();
    end;

    return nil;
end;

local function _lockAllMaterials() -- Line: 168
    -- upvalues: u4 (ref), PlayerData (copy), LocalPlayer (copy), ItemType (copy), NetWork (copy), NetMsg (copy), u6 (ref)
    if not u4 then
        return nil;
    end;

    local v17 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v17) ~= "table" then
        return nil;
    end;

    local v18 = {};

    for i, v in pairs(v17) do
        if type(v) == "table" and tonumber(v.tp) == ItemType.Material then
            local v19 = tonumber(v.onlyID) or (tonumber(i) or 0);

            if v19 > 0 then
                local v20;

                if type(v) == "table" then
                    local lock = v.lock;
                    v20 = lock == 1 and true or lock == true;
                else
                    v20 = false;
                end;

                if not v20 then
                    v.lock = 1;
                    table.insert(v18, v19);
                end;
            end;
        end;
    end;

    if #v18 > 0 then
        NetWork.FireServer(NetMsg.BAG_LOCK_ITEMS, {
            lockOnlyIds = v18
        });

        if u6 then
            u6();
        end;
    end;

    return nil;
end;

local function _unlockAllMaterials() -- Line: 199
    -- upvalues: u4 (ref), PlayerData (copy), LocalPlayer (copy), ItemType (copy), Alchemy (copy), NetWork (copy), NetMsg (copy), u6 (ref)
    if not u4 then
        return nil;
    end;

    local v21 = PlayerData.GetPlrDataByKey(LocalPlayer, "Bag");

    if type(v21) ~= "table" then
        return nil;
    end;

    local v22 = {};

    for i, v in pairs(v21) do
        if type(v) == "table" and tonumber(v.tp) == ItemType.Material then
            local v23 = tonumber(v.onlyID) or (tonumber(i) or 0);

            if v23 > 0 then
                local v24;

                if type(v) == "table" then
                    local lock = v.lock;
                    v24 = lock == 1 and true or lock == true;
                else
                    v24 = false;
                end;

                if v24 then
                    local v25;

                    if type(v) == "table" and tonumber(v.tp) == ItemType.Material then
                        local v26 = tonumber(v.id);

                        if v26 then
                            v25 = Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v26);
                        else
                            v25 = false;
                        end;
                    else
                        v25 = false;
                    end;

                    if not v25 then
                        v.lock = 0;
                        table.insert(v22, v23);
                    end;
                end;
            end;
        end;
    end;

    if #v22 > 0 then
        NetWork.FireServer(NetMsg.BAG_LOCK_ITEMS, {
            unlockOnlyIds = v22
        });

        if u6 then
            u6();
        end;
    end;

    return nil;
end;

function v1.isActive() -- Line: 230
    -- upvalues: u4 (ref)
    return u4;
end;

function v1.tryHandleSlotClick(p27, p28) -- Line: 240
    -- upvalues: u4 (ref), ItemType (copy), Alchemy (copy), LocalPlayer (copy), TipsModule (copy), NetWork (copy), NetMsg (copy), u6 (ref)
    if not u4 then
        return false;
    end;

    if p27 <= 0 then
        return true;
    end;

    if type(p28) ~= "table" or tonumber(p28.tp) ~= ItemType.Material then
        return true;
    end;

    local v29;

    if type(p28) == "table" and tonumber(p28.tp) == ItemType.Material then
        local v30 = tonumber(p28.id);

        if v30 then
            v29 = Alchemy.IsMarkedRecipeMaterial(LocalPlayer, v30);
        else
            v29 = false;
        end;
    else
        v29 = false;
    end;

    if v29 then
        TipsModule.ErrorTips(LocalPlayer, "该材料是配方标记材料不建议解锁");

        return true;
    end;

    local v31;

    if type(p28) == "table" then
        local lock = p28.lock;
        v31 = lock == 1 and true or lock == true;
    else
        v31 = false;
    end;

    local v32 = not v31;
    p28.lock = v32 and 1 or 0;
    NetWork.FireServer(NetMsg.BAG_LOCK_ITEMS, {
        onlyID = p27,
        isLock = v32 and 1 or 0
    });

    if u6 then
        u6();
    end;

    return true;
end;

function v1.onWarehouseClosed() -- Line: 262
    -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref)
    if u4 then
        if u4 then
            u4 = false;

            if u2 then
                if u3 then
                    u3.Visible = not u4;
                end;

                u2.statusFrame.Visible = not u4;
                u2.lockAllFrame.Visible = u4;
                u2.unlockAllFrame.Visible = u4;
                u2.backFrame.Visible = u4;

                if u2.listLayout then
                    local v33;

                    if u4 then
                        v33 = Enum.HorizontalAlignment.Left;
                    else
                        v33 = Enum.HorizontalAlignment.Right;
                    end;

                    u2.listLayout.HorizontalAlignment = v33;
                end;
            end;

            if u5 then
                u5();
            end;
        elseif u2 then
            if u3 then
                u3.Visible = not u4;
            end;

            u2.statusFrame.Visible = not u4;
            u2.lockAllFrame.Visible = u4;
            u2.unlockAllFrame.Visible = u4;
            u2.backFrame.Visible = u4;

            if u2.listLayout then
                local v34;

                if u4 then
                    v34 = Enum.HorizontalAlignment.Left;
                else
                    v34 = Enum.HorizontalAlignment.Right;
                end;

                u2.listLayout.HorizontalAlignment = v34;
            end;
        end;
    end;

    return nil;
end;

function v1.bind(p35, p36) -- Line: 275
    -- upvalues: u2 (ref), u3 (ref), u5 (ref), u6 (ref), u4 (ref), Log (copy), BackpackAllUI (copy), AddListen (copy), _lockAllMaterials (copy), _unlockAllMaterials (copy)
    u2 = p35.lockUi;
    u3 = p35.tabContainer;
    u5 = p36.onModeChanged;
    u6 = p36.onLockChanged;
    u4 = false;

    if not u2 then
        Log.warn("[BackpackLock] lockUi missing, skip bind");

        return nil;
    end;

    local v37 = BackpackAllUI.findSlotButton(u2.statusFrame, "lock:status");

    if v37 then
        AddListen.AddMouseCLick(v37, function() -- Line: 292
            -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref)
            if not u4 then
                if not u2 then
                    return;
                end;

                u4 = true;

                if u2 then
                    if u3 then
                        u3.Visible = not u4;
                    end;

                    u2.statusFrame.Visible = not u4;
                    u2.lockAllFrame.Visible = u4;
                    u2.unlockAllFrame.Visible = u4;
                    u2.backFrame.Visible = u4;

                    if u2.listLayout then
                        local v38;

                        if u4 then
                            v38 = Enum.HorizontalAlignment.Left;
                        else
                            v38 = Enum.HorizontalAlignment.Right;
                        end;

                        u2.listLayout.HorizontalAlignment = v38;
                    end;
                end;

                if u5 then
                    u5();
                end;
            end;
        end, u2.statusFrame);
    end;

    local v39 = BackpackAllUI.findSlotButton(u2.lockAllFrame, "lock:lockAll");

    if v39 then
        AddListen.AddMouseCLick(v39, function() -- Line: 299
            -- upvalues: _lockAllMaterials (ref)
            _lockAllMaterials();
        end, u2.lockAllFrame);
    end;

    local v40 = BackpackAllUI.findSlotButton(u2.unlockAllFrame, "lock:unlockAll");

    if v40 then
        AddListen.AddMouseCLick(v40, function() -- Line: 306
            -- upvalues: _unlockAllMaterials (ref)
            _unlockAllMaterials();
        end, u2.unlockAllFrame);
    end;

    local v41 = BackpackAllUI.findSlotButton(u2.backFrame, "lock:back");

    if v41 then
        AddListen.AddMouseCLick(v41, function() -- Line: 313
            -- upvalues: u4 (ref), u2 (ref), u3 (ref), u5 (ref)
            if u4 then
                u4 = false;

                if u2 then
                    if u3 then
                        u3.Visible = not u4;
                    end;

                    u2.statusFrame.Visible = not u4;
                    u2.lockAllFrame.Visible = u4;
                    u2.unlockAllFrame.Visible = u4;
                    u2.backFrame.Visible = u4;

                    if u2.listLayout then
                        local v42;

                        if u4 then
                            v42 = Enum.HorizontalAlignment.Left;
                        else
                            v42 = Enum.HorizontalAlignment.Right;
                        end;

                        u2.listLayout.HorizontalAlignment = v42;
                    end;
                end;

                if u5 then
                    u5();
                end;
            else
                if not u2 then
                    return;
                end;

                if u3 then
                    u3.Visible = not u4;
                end;

                u2.statusFrame.Visible = not u4;
                u2.lockAllFrame.Visible = u4;
                u2.unlockAllFrame.Visible = u4;
                u2.backFrame.Visible = u4;

                if u2.listLayout then
                    local v43;

                    if u4 then
                        v43 = Enum.HorizontalAlignment.Left;
                    else
                        v43 = Enum.HorizontalAlignment.Right;
                    end;

                    u2.listLayout.HorizontalAlignment = v43;
                end;
            end;
        end, u2.backFrame);
    end;

    if u2 then
        if u3 then
            u3.Visible = not u4;
        end;

        u2.statusFrame.Visible = not u4;
        u2.lockAllFrame.Visible = u4;
        u2.unlockAllFrame.Visible = u4;
        u2.backFrame.Visible = u4;

        if u2.listLayout then
            local v44;

            if u4 then
                v44 = Enum.HorizontalAlignment.Left;
            else
                v44 = Enum.HorizontalAlignment.Right;
            end;

            u2.listLayout.HorizontalAlignment = v44;
        end;
    end;

    return nil;
end;

return v1;