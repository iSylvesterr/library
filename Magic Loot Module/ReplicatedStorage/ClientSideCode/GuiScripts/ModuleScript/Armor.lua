-- Decompiled with Potassium's decompiler.

local v1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AddListen = UtilsSystem.AddListen;
local EnumMgr = UtilsSystem.EnumMgr;
local EquipShop = UtilsSystem.EquipShop;
local EquipShopUi = UtilsSystem.EquipShopUi;
local LocalPlayer = UtilsSystem.LocalPlayer;
local NetMsg = UtilsSystem.NetMsg;
local NetWork = UtilsSystem.NetWork;
local PlayerData = UtilsSystem.PlayerData;
local UIMgr = UtilsSystem.UIMgr;
local AllUI = require(script.AllUI);
local UIRoot = AllUI.UIRoot;
local u2 = {
    confName = "armorConf",
    saveKey = "Armor",
    shopUiName = "Armor",
    itemType = EnumMgr.ItemType.Armor,
    equipmentFrame = AllUI.EquipmentFrame,
    equipmentTemp = AllUI.EquipmentTemp
};
local u3 = 0;

local function _refresh(p4) -- Line: 36
    -- upvalues: EquipShopUi (copy), u2 (copy), u3 (ref), EquipShop (copy), LocalPlayer (copy)
    EquipShopUi.RefreshList({
        confName = u2.confName,
        saveKey = u2.saveKey,
        itemType = u2.itemType,
        equipmentFrame = u2.equipmentFrame,
        equipmentTemp = u2.equipmentTemp,
        shopUiName = u2.shopUiName,
        scrollToEquipped = p4
    });
    u3 = EquipShop.GetEquippedCfgId(LocalPlayer, u2.saveKey);
end;

PlayerData.ListenClientSync(function(p5, p6) -- Line: 49
    -- upvalues: UIRoot (copy), EquipShopUi (copy), u2 (copy), u3 (ref)
    if not UIRoot.Visible then
        return;
    end;

    local u7, v8 = EquipShopUi.ResolveSyncRefreshIds(p5, p6, u2, u3);

    if v8 ~= nil then
        u3 = v8;
    end;

    if u7 then
        task.defer(function() -- Line: 58
            -- upvalues: EquipShopUi (ref), u2 (ref), u7 (copy)
            EquipShopUi.RefreshItemStates(u2, u7);
        end);
    end;
end);
local v9 = UIMgr.FindButtonInFrame(AllUI.Exit);

if v9 then
    AddListen.AddMouseCLick(v9, function() -- Line: 66
        -- upvalues: NetWork (copy), NetMsg (copy)
        NetWork.FireBindable(NetMsg.SHOW_LOCAL_UI, "Armor", nil, false, true);
    end, AllUI.Exit);
end;

function v1.updateUi(p10, p11) -- Line: 71
    -- upvalues: UIRoot (copy), _refresh (copy)
    if not UIRoot.Visible then
        return;
    end;

    _refresh();
end;

function v1.openUi(p12) -- Line: 78
    -- upvalues: UIMgr (copy), UIRoot (copy), _refresh (copy)
    UIMgr.SetMainUIVisible(false);
    UIRoot.Visible = true;
    UIMgr.UpdateBlurVisible();
    _refresh(true);
end;

function v1.closeUi(p13) -- Line: 85
    -- upvalues: UIMgr (copy), AllUI (copy), UIRoot (copy)
    UIMgr.ClearScrollItems(AllUI.EquipmentFrame, {
        keepInstances = { AllUI.EquipmentTemp }
    });
    UIMgr.SetMainUIVisible(true);
    UIRoot.Visible = false;
    UIMgr.UpdateBlurVisible();
end;

return v1;