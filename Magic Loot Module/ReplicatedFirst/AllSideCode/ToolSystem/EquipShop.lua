-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local PlayerData = UtilsSystem.PlayerData;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local u2 = {
    GetOnlyTag = function(p1) -- Line: 54, Name: GetOnlyTag
        if not p1 then
            return "";
        end;

        local OnlyTag = p1.OnlyTag;

        return (type(OnlyTag) ~= "string" or OnlyTag == "") and "" or OnlyTag;
    end
};

function u2.HasOnlyTag(p3) -- Line: 70
    -- upvalues: u2 (copy)
    return u2.GetOnlyTag(p3) ~= "";
end;

function u2.ParseJumpUI(p4) -- Line: 80
    if not p4 then
        return nil, nil;
    end;

    local JumpUI = p4.JumpUI;

    if type(JumpUI) ~= "table" then
        return nil, nil;
    end;

    local v5 = JumpUI[1];

    if type(v5) ~= "string" or v5 == "" then
        return nil, nil;
    end;

    local v6 = JumpUI[2];

    if type(v6) == "string" and v6 ~= "" then
        return v5, v6;
    end;

    return v5, nil;
end;

function u2.IsJumpEntry(p7) -- Line: 104
    -- upvalues: u2 (copy)
    if not p7 then
        return false;
    end;

    if u2.GetOnlyTag(p7) ~= "" then
        return false;
    end;

    if (tonumber(p7.Price) or 0) == -1 then
        return u2.ParseJumpUI(p7) ~= nil;
    end;

    return false;
end;

function u2.IsCoinPurchasable(p8) -- Line: 123
    if p8 then
        return (tonumber(p8.Price) or 0) > 0;
    end;

    return false;
end;

function u2.IsListEntry(p9) -- Line: 137
    -- upvalues: u2 (copy), CfgFind (copy)
    if not p9 then
        return false;
    end;

    if p9.ShowInShop ~= nil and p9.ShowInShop ~= 1 then
        return false;
    end;

    local v10 = u2.GetOnlyTag(p9);
    local v11;

    if v10 == "" then
        v11 = false;
    else
        v11 = CfgFind.FindCfgByOnlyTag(v10) ~= nil;
    end;

    local v12 = tonumber(p9.Price) or 0;
    local v13;

    if v12 == 0 then
        v13 = v10 == "";
    else
        v13 = false;
    end;

    return v11 or (v12 > 0 or (v13 or u2.IsJumpEntry(p9)));
end;

function u2.GetDisplayPrice(p14) -- Line: 159
    -- upvalues: u2 (copy), CfgFind (copy)
    local v15 = u2.GetOnlyTag(p14);

    if v15 == "" then
        return tonumber(p14.Price) or 0, false;
    end;

    local v16 = CfgFind.FindCfgByOnlyTag(v15);

    return v16 and (tonumber(v16.price) or 0) or 0, true;
end;

function u2.FindShopCfg(p17, p18) -- Line: 174
    -- upvalues: CfgFind (copy)
    local v19 = CfgFind.FindCfgByID(p17, p18);

    if v19 and tonumber(v19.tp) == p18 then
        return v19;
    end;

    return nil;
end;

function u2.GetSaveKey(p20) -- Line: 187
    -- upvalues: ItemType (copy)
    return p20 == ItemType.Weapon and "Weapon" or (p20 == ItemType.Armor and "Armor" or (p20 == ItemType.Broom and "NowBroom" or nil));
end;

function u2.OwnsInBag(p21, p22, p23) -- Line: 211
    -- upvalues: PlayerData (copy)
    if not p21 then
        return false;
    end;

    local v24 = PlayerData.GetPlrDataByKey(p21, "Bag");

    if type(v24) ~= "table" then
        return false;
    end;

    for _, v in pairs(v24) do
        if type(v) == "table" and (tonumber(v.id) == p22 and tonumber(v.tp) == p23) then
            return true;
        end;
    end;

    return false;
end;

function u2.GetEquippedCfgId(p25, p26) -- Line: 233
    -- upvalues: PlayerData (copy)
    return p25 and (tonumber(PlayerData.GetPlrDataByKey(p25, p26)) or 0) or 0;
end;

function u2.BuildAttrEffectMap(p27) -- Line: 245
    local v28 = {};

    if not p27 then
        return v28;
    end;

    local attr = p27.attr;
    local attrNum = p27.attrNum;

    if type(attr) ~= "table" or type(attrNum) ~= "table" then
        return v28;
    end;

    for i = 1, math.min(#attr, #attrNum) do
        local v29 = tonumber(attr[i]);
        local v30 = tonumber(attrNum[i]);

        if v29 and v30 then
            v28[v29] = (v28[v29] or 0) + v30;
        end;
    end;

    return v28;
end;

function u2.IsAttrEffectBetter(p31, p32) -- Line: 272
    -- upvalues: u2 (copy)
    local v33 = u2.BuildAttrEffectMap(p31);
    local v34 = u2.BuildAttrEffectMap(p32);
    local v35 = false;

    for i, v in pairs(v34) do
        local v36 = v33[i] or 0;

        if v36 < v then
            return false;
        end;

        if v < v36 then
            v35 = true;
        end;
    end;

    for i, v in pairs(v33) do
        if (v34[i] or 0) < v then
            v35 = true;
        end;
    end;

    return v35;
end;

function u2.IsBroomDungeonBetter(p37, p38) -- Line: 299
    if p37 then
        p37 = p37.Dungeon;
    end;

    local v39 = tonumber(p37) or 0;

    if p38 then
        p38 = p38.Dungeon;
    end;

    return (tonumber(p38) or 0) < v39;
end;

function u2.IsAutoEquipBetter(p40, p41, p42) -- Line: 314
    -- upvalues: ItemType (copy), u2 (copy)
    local v43 = tonumber(p42);

    if not v43 then
        local v44;

        if p40 then
            v44 = p40.tp;
        else
            v44 = p40;
        end;

        v43 = tonumber(v44);
    end;

    if v43 == ItemType.Broom then
        return u2.IsBroomDungeonBetter(p40, p41);
    end;

    return u2.IsAttrEffectBetter(p40, p41);
end;

function u2.BuildShopList(p45) -- Line: 331
    -- upvalues: CfgFind (copy), u2 (copy)
    local v46 = {};
    local v47 = CfgFind.GetCfgByName(p45);

    if not v47 then
        return v46;
    end;

    for i, v in pairs(v47) do
        local v48 = tonumber(i);

        if v48 and u2.IsListEntry(v) then
            table.insert(v46, {
                id = v48,
                cfg = v
            });
        end;
    end;

    table.sort(v46, function(p49, p50) -- Line: 343
        local v51 = tonumber(p49.cfg.xyd) or 1;
        local v52 = tonumber(p50.cfg.xyd) or 1;

        if v51 == v52 then
            return p49.id < p50.id;
        end;

        return v51 < v52;
    end);

    return v46;
end;

function u2.ParseShopPayload(p53) -- Line: 360
    -- upvalues: ItemType (copy)
    local Weapon = ItemType.Weapon;

    if type(p53) == "table" then
        return tonumber(p53.equipID), tonumber(p53.itemType) or ItemType.Weapon;
    end;

    return tonumber(p53), Weapon;
end;

return u2;