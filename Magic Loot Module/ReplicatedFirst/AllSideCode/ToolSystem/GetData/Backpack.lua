-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local Log = UtilsSystem.Log;
local PlayerData = UtilsSystem.PlayerData;
local Players = UtilsSystem.Players;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local TranslationHelper = UtilsSystem.TranslationHelper;
local ItemType = UtilsSystem.EnumMgr.ItemType;
local u1 = {
    HELD_TOOLBAR_ONLY_ID_NONE = 0,
    HELD_TOOLBAR_ONLY_ID_WEAPON = -1
};

local function _isWarehouseItemTp(p2) -- Line: 52
    -- upvalues: ItemType (copy)
    return p2 == ItemType.Potion and true or p2 == ItemType.Material;
end;

local function _resolveBagItemTp(p3) -- Line: 61
    -- upvalues: Log (copy)
    if type(p3) ~= "table" then
        return nil;
    end;

    local v4 = tonumber(p3.tp);

    if v4 then
        return v4;
    end;

    Log.warn("[GetData.Backpack] bag item missing tp", p3.id);

    return nil;
end;

local function _isOnlyIdOnToolbarCache(p5, p6) -- Line: 80
    if p5 <= 0 or type(p6) ~= "table" then
        return false;
    end;

    for _, v in p6 do
        if v == p5 then
            return true;
        end;
    end;

    return false;
end;

local function _getBagRowByKey(p7, p8) -- Line: 98
    -- upvalues: RunService (copy), Players (copy), PlayerData (copy)
    if type(p8) ~= "string" or p8 == "" then
        return nil;
    end;

    if RunService:IsClient() then
        p7 = p7 or Players.LocalPlayer;
    end;

    if not p7 then
        return nil;
    end;

    local v9 = PlayerData.GetPlrDataByKey(p7, "Bag");

    if type(v9) == "table" then
        return v9[p8];
    end;

    return nil;
end;

function u1.ShouldRefreshToolbarOnPlayerDataSync(p10, p11, p12, p13) -- Line: 123
    -- upvalues: RunService (copy), Players (copy), PlayerData (copy), Log (copy), ItemType (copy), u1 (copy)
    if p10 == nil or (p10 == "Weapon" or p10 == "Bag") then
        return true;
    end;

    if type(p10) ~= "table" or p10[1] ~= "Bag" then
        return false;
    end;

    local v14 = p10[2];

    if type(v14) ~= "string" then
        return false;
    end;

    local v15 = p10[3];

    if v15 ~= "lock" then
        if v15 == "equip" then
            return true;
        end;

        if p11 == nil and v15 == nil then
            local v16 = tonumber(v14) or 0;

            if v16 > 0 and v16 == u1.GetHeldToolbarOnlyId(p12) then
                return true;
            end;

            if v16 <= 0 or type(p13) ~= "table" then
                return false;
            end;

            for _, v in p13 do
                if v == v16 then
                    return true;
                end;
            end;

            return false;
        end;

        if type(p11) ~= "table" then
            if type(v14) == "string" and v14 ~= "" then
                if RunService:IsClient() then
                    p12 = p12 or Players.LocalPlayer;
                end;

                if p12 then
                    local v17 = PlayerData.GetPlrDataByKey(p12, "Bag");

                    if type(v17) == "table" then
                        p11 = v17[v14];
                    else
                        p11 = nil;
                    end;
                else
                    p11 = nil;
                end;
            else
                p11 = nil;
            end;
        end;

        local v18;

        if type(p11) == "table" then
            v18 = tonumber(p11.tp);

            if not v18 then
                Log.warn("[GetData.Backpack] bag item missing tp", p11.id);
                v18 = nil;
            end;
        else
            v18 = nil;
        end;

        if v18 ~= ItemType.Potion and v18 ~= ItemType.Material then
            return false;
        end;

        if p11 then
            p11 = p11.equip;
        end;

        local v19 = tonumber(p11) or 0;

        return u1.IsBackpackToolbarItemEquipSlot(v19);
    end;

    local v20;

    if type(v14) == "string" and v14 ~= "" then
        if RunService:IsClient() then
            p12 = p12 or Players.LocalPlayer;
        end;

        if p12 then
            local v21 = PlayerData.GetPlrDataByKey(p12, "Bag");

            if type(v21) == "table" then
                v20 = v21[v14];
            else
                v20 = nil;
            end;
        else
            v20 = nil;
        end;
    else
        v20 = nil;
    end;

    local v22;

    if type(v20) == "table" then
        v22 = tonumber(v20.tp);

        if not v22 then
            Log.warn("[GetData.Backpack] bag item missing tp", v20.id);
            v22 = nil;
        end;
    else
        v22 = nil;
    end;

    if v22 ~= ItemType.Potion and v22 ~= ItemType.Material then
        return false;
    end;

    local v23 = tonumber(v14) or 0;

    if v20 then
        v20 = v20.equip;
    end;

    local v24 = tonumber(v20) or 0;
    local v25 = u1.IsBackpackToolbarItemEquipSlot(v24);

    if not v25 then
        if v23 <= 0 or type(p13) ~= "table" then
            return false;
        end;

        for _, v in p13 do
            if v == v23 then
                return true;
            end;
        end;

        v25 = false;
    end;

    return v25;
end;

function u1.ShouldRefreshWarehouseOnPlayerDataSync(p26, p27, p28, p29, p30) -- Line: 186
    -- upvalues: RunService (copy), Players (copy), PlayerData (copy), Log (copy), ItemType (copy), u1 (copy)
    if p26 == nil or p26 == "Bag" then
        return true;
    end;

    if type(p26) ~= "table" or p26[1] ~= "Bag" then
        return false;
    end;

    local v31 = p26[2];

    if type(v31) ~= "string" then
        return false;
    end;

    local v32 = p26[3];

    if v32 == "lock" then
        local v33;

        if type(v31) == "string" and v31 ~= "" then
            if RunService:IsClient() then
                p28 = p28 or Players.LocalPlayer;
            end;

            if p28 then
                local v34 = PlayerData.GetPlrDataByKey(p28, "Bag");

                if type(v34) == "table" then
                    v33 = v34[v31];
                else
                    v33 = nil;
                end;
            else
                v33 = nil;
            end;
        else
            v33 = nil;
        end;

        local v35;

        if type(v33) == "table" then
            v35 = tonumber(v33.tp);

            if not v35 then
                Log.warn("[GetData.Backpack] bag item missing tp", v33.id);
                v35 = nil;
            end;
        else
            v35 = nil;
        end;

        return v35 == ItemType.Potion and true or v35 == ItemType.Material;
    end;

    if v32 ~= "equip" then
        if p27 == nil and v32 == nil then
            local v36 = tonumber(v31) or 0;

            if v36 <= 0 then
                return false;
            end;

            return type(p30) == "table" and p30[v36] and true or false;
        end;

        if type(p27) ~= "table" then
            if type(v31) == "string" and v31 ~= "" then
                if RunService:IsClient() then
                    p28 = p28 or Players.LocalPlayer;
                end;

                if p28 then
                    local v37 = PlayerData.GetPlrDataByKey(p28, "Bag");

                    if type(v37) == "table" then
                        p27 = v37[v31];
                    else
                        p27 = nil;
                    end;
                else
                    p27 = nil;
                end;
            else
                p27 = nil;
            end;
        end;

        local v38;

        if type(p27) == "table" then
            v38 = tonumber(p27.tp);

            if not v38 then
                Log.warn("[GetData.Backpack] bag item missing tp", p27.id);
                v38 = nil;
            end;
        else
            v38 = nil;
        end;

        return v38 == ItemType.Potion and true or v38 == ItemType.Material;
    end;

    local v39 = tonumber(v31) or 0;
    local v40;

    if type(v31) == "string" and v31 ~= "" then
        if RunService:IsClient() then
            p28 = p28 or Players.LocalPlayer;
        end;

        if p28 then
            local v41 = PlayerData.GetPlrDataByKey(p28, "Bag");

            if type(v41) == "table" then
                v40 = v41[v31];
            else
                v40 = nil;
            end;
        else
            v40 = nil;
        end;
    else
        v40 = nil;
    end;

    local v42;

    if type(v40) == "table" then
        v42 = tonumber(v40.tp);

        if not v42 then
            Log.warn("[GetData.Backpack] bag item missing tp", v40.id);
            v42 = nil;
        end;
    else
        v42 = nil;
    end;

    if v42 ~= ItemType.Potion and v42 ~= ItemType.Material then
        return false;
    end;

    local v43 = tonumber(p27);

    if v43 == nil then
        if v40 then
            v40 = v40.equip;
        end;

        v43 = tonumber(v40) or 0;
    end;

    return not u1.IsBackpackToolbarItemEquipSlot(v43) and true or (type(p30) == "table" and (v39 > 0 and p30[v39]) and true or false);
end;

local function _copyBagRow(p44, p45) -- Line: 253
    if type(p44) ~= "table" or p45 < 0 then
        return nil;
    end;

    local v46 = {};

    for i, v in pairs(p44) do
        v46[i] = v;
    end;

    v46.onlyID = p45;

    return v46;
end;

local function _getEquippedWeaponCfgId(p47) -- Line: 270
    -- upvalues: PlayerData (copy), RunService (copy), Players (copy)
    return p47 and (tonumber(PlayerData.GetPlrDataByKey(p47, "Weapon")) or 0) or (RunService:IsClient() and (tonumber(PlayerData.GetPlrDataByKey(Players.LocalPlayer, "Weapon")) or 0) or 0);
end;

function u1.GetBackpackToolbarSlotCount() -- Line: 284
    return 9;
end;

function u1.GetBackpackToolbarItemSlotMin() -- Line: 292
    return 2;
end;

function u1.GetBackpackToolbarItemSlotMax() -- Line: 300
    return 9;
end;

function u1.GetBackpackToolbarItemSlotCount() -- Line: 308
    -- upvalues: SystemGameConfig (copy)
    local v48 = SystemGameConfig.GetValue({ "背包配置", "工具栏快捷槽数" });
    local v49 = tonumber(v48);

    if not v49 or v49 <= 0 then
        return 8;
    end;

    local v50 = math.floor(v49);

    return math.min(v50, 8);
end;

function u1.GetBackpackWarehouseMaxSize() -- Line: 324
    -- upvalues: SystemGameConfig (copy)
    local v51 = SystemGameConfig.GetValue({ "背包配置", "仓库上限" });
    local v52 = tonumber(v51);

    return (not v52 or v52 <= 0) and 999 or math.floor(v52);
end;

function u1.IsBackpackToolbarItemEquipSlot(p53) -- Line: 338
    local v54 = tonumber(p53) or 0;
    local v55;

    if v54 >= 2 then
        v55 = v54 <= 9;
    else
        v55 = false;
    end;

    return v55;
end;

function u1.GetBackpackWarehouseCurrentSize(p56) -- Line: 348
    -- upvalues: PlayerData (copy), Log (copy), ItemType (copy)
    if not p56 then
        return 0;
    end;

    local v57 = PlayerData.GetPlrDataByKey(p56, "Bag");

    if type(v57) ~= "table" then
        return 0;
    end;

    local v58 = 0;

    for _, v in pairs(v57) do
        if type(v) == "table" then
            local v59;

            if type(v) == "table" then
                v59 = tonumber(v.tp);

                if not v59 then
                    Log.warn("[GetData.Backpack] bag item missing tp", v.id);
                    v59 = nil;
                end;
            else
                v59 = nil;
            end;

            if v59 == ItemType.Potion or v59 == ItemType.Material then
                v58 = v58 + 1;
            end;
        end;
    end;

    return v58;
end;

function u1.IsBagFullForItem(p60, p61, p62) -- Line: 375
    -- upvalues: ItemType (copy), u1 (copy)
    if p62 == ItemType.Potion or p62 == ItemType.Material then
        return u1.GetBackpackWarehouseCurrentSize(p60) >= u1.GetBackpackWarehouseMaxSize();
    end;

    return false;
end;

function u1.GetBackpackToolbarEquipByUiSlot(p63) -- Line: 387
    -- upvalues: u1 (copy)
    local v64 = tonumber(p63) or 0;

    return (v64 < 1 or u1.GetBackpackToolbarSlotCount() < v64) and 0 or v64;
end;

function u1.GetBackpackToolbarItemAtUiSlot(p65, p66, p67) -- Line: 402
    -- upvalues: PlayerData (copy), RunService (copy), Players (copy), ItemType (copy), u1 (copy), Log (copy), _copyBagRow (copy)
    local v68 = tonumber(p66) or 0;

    if v68 == 1 then
        local v69;

        if p67 then
            v69 = tonumber(PlayerData.GetPlrDataByKey(p67, "Weapon")) or 0;
        else
            v69 = RunService:IsClient() and (tonumber(PlayerData.GetPlrDataByKey(Players.LocalPlayer, "Weapon")) or 0) or 0;
        end;

        return v69 > 0 and {
            onlyID = 0,
            id = v69,
            tp = ItemType.Weapon
        } or nil;
    end;

    if type(p65) ~= "table" then
        return nil;
    end;

    local v70 = u1.GetBackpackToolbarEquipByUiSlot(v68);

    if v70 <= 0 then
        return nil;
    end;

    for i, v in pairs(p65) do
        if type(v) == "table" then
            local v71 = tonumber(v.onlyID) or (tonumber(i) or 0);
            local v72 = tonumber(v.equip) or 0;

            if v71 > 0 and v72 == v70 then
                local v73;

                if type(v) == "table" then
                    v73 = tonumber(v.tp);

                    if not v73 then
                        Log.warn("[GetData.Backpack] bag item missing tp", v.id);
                        v73 = nil;
                    end;
                else
                    v73 = nil;
                end;

                if v73 == ItemType.Potion or v73 == ItemType.Material then
                    return _copyBagRow(v, v71);
                end;
            end;
        end;
    end;

    return nil;
end;

local function _backpackItemMatchesSearch(p74, p75, p76) -- Line: 446
    -- upvalues: TranslationHelper (copy), Log (copy)
    if p75 == "" then
        return true;
    end;

    if not p74 then
        return false;
    end;

    local v77 = p74.ZhName or "";
    local v78 = TranslationHelper.TranslateByKey(v77);

    if type(v78) == "string" and v78 ~= "" then
        return string.find(string.lower(v78), p75, 1, true) ~= nil;
    end;

    Log.warn("[GetData.Backpack] TranslateByKey empty, skip search match", p76, v77);

    return false;
end;

local function _isBuffPotionCfg(p79) -- Line: 468
    if p79 then
        p79 = p79.BuffID;
    end;

    return (tonumber(p79) or 0) > 0;
end;

local function _compareBackpackWarehouseItems(p80, p81, p82) -- Line: 480
    -- upvalues: Log (copy), ItemType (copy), CfgFind (copy)
    local v83;

    if type(p80) == "table" then
        v83 = tonumber(p80.tp);

        if not v83 then
            Log.warn("[GetData.Backpack] bag item missing tp", p80.id);
            v83 = nil;
        end;
    else
        v83 = nil;
    end;

    local v84;

    if type(p81) == "table" then
        v84 = tonumber(p81.tp);

        if not v84 then
            Log.warn("[GetData.Backpack] bag item missing tp", p81.id);
            v84 = nil;
        end;
    else
        v84 = nil;
    end;

    if p82 == "All" and v83 ~= v84 then
        if v83 == ItemType.Potion then
            return true;
        end;

        if v84 == ItemType.Potion then
            return false;
        end;
    end;

    local v85;

    if v83 then
        v85 = CfgFind.FindCfgByID(p80.id, v83) or nil;
    else
        v85 = nil;
    end;

    local v86;

    if v84 then
        v86 = CfgFind.FindCfgByID(p81.id, v84) or nil;
    else
        v86 = nil;
    end;

    if v83 == ItemType.Potion and v84 == ItemType.Potion then
        local v87;

        if v85 then
            v87 = v85.BuffID;
        else
            v87 = v85;
        end;

        local v88 = (tonumber(v87) or 0) > 0;
        local v89;

        if v86 then
            v89 = v86.BuffID;
        else
            v89 = v86;
        end;

        if v88 ~= ((tonumber(v89) or 0) > 0) then
            return v88;
        end;
    end;

    local v90 = tonumber(p80.xyd) or (v85 and tonumber(v85.xyd) or 0);
    local v91 = tonumber(p81.xyd) or (v86 and tonumber(v86.xyd) or 0);

    if v90 == v91 then
        return (tonumber(p80.id) or 0) > (tonumber(p81.id) or 0);
    end;

    return v91 < v90;
end;

function u1.QueryBackpackWarehouseItems(p92, u93, p94) -- Line: 517
    -- upvalues: Log (copy), ItemType (copy), u1 (copy), CfgFind (copy), _backpackItemMatchesSearch (copy), _copyBagRow (copy), _compareBackpackWarehouseItems (copy)
    local v95 = {};

    if type(p92) ~= "table" then
        return v95;
    end;

    local v96 = string.lower(p94 or "");

    for i, v in pairs(p92) do
        if type(v) == "table" then
            local v97;

            if type(v) == "table" then
                v97 = tonumber(v.tp);

                if not v97 then
                    Log.warn("[GetData.Backpack] bag item missing tp", v.id);
                    v97 = nil;
                end;
            else
                v97 = nil;
            end;

            if v97 == ItemType.Potion or v97 == ItemType.Material then
                local v98 = tonumber(v.equip) or 0;

                if not u1.IsBackpackToolbarItemEquipSlot(v98) then
                    local v99;

                    if u93 == "All" or u93 == "Potion" and v97 == ItemType.Potion then
                        v99 = true;
                    elseif u93 == "Material" then
                        v99 = v97 == ItemType.Material;
                    else
                        v99 = false;
                    end;

                    if v99 then
                        local v100 = CfgFind.FindCfgByID(v.id, v97);

                        if v100 then
                            if _backpackItemMatchesSearch(v100, v96, (tonumber(v.id))) then
                                local v101 = _copyBagRow(v, tonumber(v.onlyID) or (tonumber(i) or 0));

                                if v101 then
                                    table.insert(v95, v101);
                                end;
                            end;
                        else
                            Log.warn("[GetData.Backpack] cfg missing for warehouse item", v.id, v97);
                        end;
                    end;
                end;
            end;
        end;
    end;

    table.sort(v95, function(p102, p103) -- Line: 552
        -- upvalues: _compareBackpackWarehouseItems (ref), u93 (copy)
        return _compareBackpackWarehouseItems(p102, p103, u93);
    end);

    return v95;
end;

function u1.GetHeldToolbarOnlyId(p104) -- Line: 563
    -- upvalues: RunService (copy), Players (copy), u1 (copy)
    if RunService:IsClient() then
        p104 = p104 or Players.LocalPlayer;
    end;

    if not p104 then
        return u1.HELD_TOOLBAR_ONLY_ID_NONE;
    end;

    local v105 = p104:FindFirstChild("当前手持OnlyID");

    if v105 and v105:IsA("NumberValue") then
        return math.floor(v105.Value);
    end;

    return u1.HELD_TOOLBAR_ONLY_ID_NONE;
end;

function u1.IsToolbarSlotHeld(p106, p107, p108) -- Line: 584
    -- upvalues: u1 (copy)
    local v109 = u1.GetHeldToolbarOnlyId(p108);

    if v109 == u1.HELD_TOOLBAR_ONLY_ID_NONE then
        return false;
    end;

    if p106 == 1 then
        return v109 == u1.HELD_TOOLBAR_ONLY_ID_WEAPON;
    end;

    if p107 then
        p107 = p107.onlyID;
    end;

    local v110 = tonumber(p107) or 0;
    local v111;

    if v110 > 0 then
        v111 = v110 == v109;
    else
        v111 = false;
    end;

    return v111;
end;

function u1.GetFirstFreeBackpackToolbarItemSlot(p112) -- Line: 601
    -- upvalues: u1 (copy), Log (copy), ItemType (copy)
    if type(p112) ~= "table" then
        return 0;
    end;

    local v113 = u1.GetBackpackToolbarItemSlotCount();
    local v114 = {};

    for _, v in pairs(p112) do
        if type(v) == "table" then
            local v115;

            if type(v) == "table" then
                v115 = tonumber(v.tp);

                if not v115 then
                    Log.warn("[GetData.Backpack] bag item missing tp", v.id);
                    v115 = nil;
                end;
            else
                v115 = nil;
            end;

            if (v115 == ItemType.Potion or v115 == ItemType.Material) and u1.IsBackpackToolbarItemEquipSlot(v.equip) then
                v114[tonumber(v.equip) or 0] = true;
            end;
        end;
    end;

    for i = 1, v113 do
        local v116 = i + 2 - 1;

        if not v114[v116] then
            return v116;
        end;
    end;

    return 0;
end;

return u1;