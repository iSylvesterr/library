-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ConfigInstance = UtilsSystem.ConfigInstance;
local Copy = UtilsSystem.Copy;
local EnumMgr = UtilsSystem.EnumMgr;
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local key = ConfigInstance.key;

for i, v in pairs(ConfigInstance) do
    if i ~= "key" then
        local v1 = key[i];

        for i2, v2 in pairs(v) do
            local v3 = {};

            for i3, v4 in pairs(v2) do
                v3[tostring(v1[i3])] = v4;
            end;

            ConfigInstance[i][i2] = v3;
        end;
    end;
end;

local u4 = {};
local u5 = SystemGameConfig.GetValue({ "每日签到", "每日签到最大天数" }) or 7;
local itemdataConf = ConfigInstance.itemdataConf;
local itemshopdataConf = ConfigInstance.itemshopdataConf;
local petConf = ConfigInstance.petConf;
local peteggConf = ConfigInstance.peteggConf;
local loginConf = ConfigInstance.loginConf;
local onlineawardConf = ConfigInstance.onlineawardConf;
local _ = ConfigInstance.settingConf;
local skillConf = ConfigInstance.skillConf;
local weaponConf = ConfigInstance.weaponConf;
local armorConf = ConfigInstance.armorConf;
local broomConf = ConfigInstance.broomConf;
local enemyConf = ConfigInstance.enemyConf;
local materialConf = ConfigInstance.materialConf;
local potionConf = ConfigInstance.potionConf;
local indexawardConf = ConfigInstance.indexawardConf;
local alchemyConf = ConfigInstance.alchemyConf;
local trainConf = ConfigInstance.trainConf;
local buffdataConf = ConfigInstance.buffdataConf;
local eventConf = ConfigInstance.eventConf;
local eventshopConf = ConfigInstance.eventshopConf;
local eventhatchConf = ConfigInstance.eventhatchConf;
local taskConf = ConfigInstance.taskConf;
local tasktypeConf = ConfigInstance.tasktypeConf;
local u6 = nil;

local function _copyCfg(p7) -- Line: 94
    -- upvalues: Copy (copy)
    if p7 == nil then
        return nil;
    end;

    return Copy.deepCopy(p7);
end;

local function _isShowInIndex(p8) -- Line: 110
    if type(p8) ~= "table" then
        return false;
    end;

    if tonumber(p8.xyd) == nil then
        return false;
    end;

    return p8.ShowIndex == nil or tonumber(p8.ShowIndex) ~= 0;
end;

function u4.FindCfgByID(p9, p10) -- Line: 134
    -- upvalues: itemdataConf (copy), petConf (copy), peteggConf (copy), materialConf (copy), potionConf (copy), weaponConf (copy), armorConf (copy), broomConf (copy), _copyCfg (copy), EnumMgr (copy), skillConf (copy), enemyConf (copy)
    local v11 = tonumber(p9);

    if not v11 then
        return nil;
    end;

    if p10 == nil then
        return _copyCfg(itemdataConf[v11] or petConf[v11] or peteggConf[v11] or materialConf[v11] or potionConf[v11] or weaponConf[v11] or armorConf[v11] or broomConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Item or p10 == EnumMgr.ItemType.UseItem then
        return _copyCfg(itemdataConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Title then
        return _copyCfg(itemdataConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Material then
        return _copyCfg(materialConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Pet then
        return _copyCfg(petConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.PetEgg then
        return _copyCfg(peteggConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Skill then
        return _copyCfg(skillConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Potion then
        return _copyCfg(potionConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Weapon then
        return _copyCfg(weaponConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Armor then
        return _copyCfg(armorConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Broom then
        return _copyCfg(broomConf[v11]);
    end;

    if p10 == EnumMgr.ItemType.Enemy then
        return _copyCfg(enemyConf[v11]);
    end;

    return nil;
end;

function u4.FindCfgByPassID(p12) -- Line: 198
    -- upvalues: itemshopdataConf (copy), _copyCfg (copy)
    local v13 = tonumber(p12);

    if not v13 then
        return nil;
    end;

    for _, v in pairs(itemshopdataConf) do
        if v.passID == v13 or v.passID_old == v13 then
            return _copyCfg(v);
        end;
    end;

    return nil;
end;

function u4.FindCfgByPassID_Gift(p14) -- Line: 218
    -- upvalues: itemshopdataConf (copy), _copyCfg (copy)
    local v15 = tonumber(p14);

    if not v15 then
        return nil;
    end;

    for _, v in pairs(itemshopdataConf) do
        if tonumber(v.GiftID) == v15 then
            return _copyCfg(v);
        end;
    end;

    return nil;
end;

function u4.FindCfgByOnlyTag(p16) -- Line: 238
    -- upvalues: itemshopdataConf (copy), _copyCfg (copy)
    local v17 = tostring(p16);

    for _, v in pairs(itemshopdataConf) do
        if v.OnlyTag == v17 then
            return _copyCfg(v);
        end;
    end;

    return nil;
end;

function u4.FindOnlyTagByItemID(p18) -- Line: 256
    -- upvalues: itemshopdataConf (copy)
    local v19 = tonumber(p18);

    if not v19 then
        return nil;
    end;

    for _, v in pairs(itemshopdataConf) do
        local itemID = v.itemID;

        if type(itemID) == "table" then
            for _, v2 in ipairs(itemID) do
                if tonumber(v2) == v19 then
                    local OnlyTag = v.OnlyTag;

                    if type(OnlyTag) == "string" and OnlyTag ~= "" then
                        return OnlyTag;
                    end;
                end;
            end;
        end;
    end;

    return nil;
end;

function u4.GetGamePassItemIDByOnlyID(p20) -- Line: 282
    -- upvalues: itemshopdataConf (copy)
    for _, v in pairs(itemshopdataConf) do
        if v.OnlyTag == p20 and v.gamePassItemID ~= "" then
            return v.gamePassItemID;
        end;
    end;

    return nil;
end;

function u4.GetCfgByName(p21) -- Line: 303
    -- upvalues: ConfigInstance (copy), _copyCfg (copy)
    if ConfigInstance[p21] then
        return _copyCfg(ConfigInstance[p21]);
    end;

    return nil;
end;

function u4.GetCfgByNameAndID(p22, p23) -- Line: 316
    -- upvalues: ConfigInstance (copy), _copyCfg (copy)
    if ConfigInstance[p22] then
        return _copyCfg(ConfigInstance[p22][p23]);
    end;

    return nil;
end;

function u4.GetNowVisionCfg() -- Line: 327
    -- upvalues: ConfigInstance (copy), _copyCfg (copy)
    local updatelogConf = ConfigInstance.updatelogConf;

    if not updatelogConf then
        return nil;
    end;

    local v24 = 0;
    local v25 = nil;

    for _, v in pairs(updatelogConf) do
        if v24 < v.UpdateTime then
            v24 = v.UpdateTime;
            v25 = v;
        end;
    end;

    return _copyCfg(v25);
end;

function u4.GetLoginAward(p26) -- Line: 351
    -- upvalues: _copyCfg (copy), loginConf (copy)
    local v27 = tonumber(p26);

    if not v27 then
        return nil;
    end;

    return _copyCfg(loginConf and loginConf[v27]);
end;

function u4.GetLoginMaxDays() -- Line: 363
    -- upvalues: u5 (copy)
    local v28 = tonumber(u5) or 7;

    return v28 < 1 and 7 or v28;
end;

function u4.GetOnlineAward(p29) -- Line: 376
    -- upvalues: _copyCfg (copy), onlineawardConf (copy)
    local v30 = tonumber(p29);

    if not v30 then
        return nil;
    end;

    return _copyCfg(onlineawardConf and onlineawardConf[v30]);
end;

function u4.GetOnlineAwardList() -- Line: 388
    -- upvalues: onlineawardConf (copy), Copy (copy)
    local v31 = {};

    if not onlineawardConf then
        return v31;
    end;

    local v32 = {};

    for i in pairs(onlineawardConf) do
        local v33 = tonumber(i);

        if v33 then
            table.insert(v32, v33);
        end;
    end;

    table.sort(v32);

    for _, v in ipairs(v32) do
        local v34 = onlineawardConf[v];
        local v35;

        if v34 == nil then
            v35 = nil;
        else
            v35 = Copy.deepCopy(v34);
        end;

        if v35 then
            v35.id = v;
            table.insert(v31, v35);
        end;
    end;

    return v31;
end;

function u4.GetLoginAwardList() -- Line: 415
    -- upvalues: loginConf (copy), Copy (copy)
    local v36 = {};

    if not loginConf then
        return v36;
    end;

    local v37 = {};

    for i in pairs(loginConf) do
        local v38 = tonumber(i);

        if v38 then
            table.insert(v37, v38);
        end;
    end;

    table.sort(v37);

    for _, v in ipairs(v37) do
        local v39 = loginConf[v];
        local v40;

        if v39 == nil then
            v40 = nil;
        else
            v40 = Copy.deepCopy(v39);
        end;

        if v40 then
            v40.id = v;
            table.insert(v36, v40);
        end;
    end;

    return v36;
end;

function u4.IsOnlineTierClaimed(p41, p42) -- Line: 446
    if type(p41) ~= "table" or not p42 then
        return false;
    end;

    local v43 = p41[tostring(p42)];
    local v44;

    if type(v43) == "table" then
        v44 = tonumber(v43.State) == 1;
    else
        v44 = false;
    end;

    return v44;
end;

function u4.IsOnlineTierClaimable(p45, p46) -- Line: 460
    -- upvalues: u4 (copy)
    if type(p45) ~= "table" or type(p46) ~= "table" then
        return false;
    end;

    local v47 = tonumber(p46.id);

    if not v47 or u4.IsOnlineTierClaimed(p45, v47) then
        return false;
    end;

    local v48 = p45[tostring(v47)];

    return type(v48) == "table" and tonumber(v48.Unlock) == 1 and true or (tonumber(p46.OnlinTime) or 0) <= (tonumber(p45.OnlineSeconds) or 0);
end;

function u4.HasClaimableOnlineAward(p49) -- Line: 482
    -- upvalues: u4 (copy)
    return u4.CountClaimableOnlineAward(p49) > 0;
end;

function u4.CountClaimableOnlineAward(p50) -- Line: 491
    -- upvalues: u4 (copy)
    if type(p50) ~= "table" then
        return 0;
    end;

    local v51 = u4.GetOnlineAwardList();
    local v52 = 0;

    for _, v in ipairs(v51) do
        if u4.IsOnlineTierClaimable(p50, v) then
            v52 = v52 + 1;
        end;
    end;

    return v52;
end;

function u4.IsShowInIndex(p53) -- Line: 519
    if type(p53) ~= "table" then
        return false;
    end;

    if tonumber(p53.xyd) == nil then
        return false;
    end;

    return p53.ShowIndex == nil or tonumber(p53.ShowIndex) ~= 0;
end;

function u4.GetSortedConfRows(p54) -- Line: 531
    -- upvalues: ConfigInstance (copy)
    local v55 = {};

    for i, v in pairs(ConfigInstance[p54]) do
        local v56;

        if type(v) == "table" and tonumber(v.xyd) ~= nil then
            v56 = v.ShowIndex == nil or tonumber(v.ShowIndex) ~= 0;
        else
            v56 = false;
        end;

        if v56 then
            table.insert(v55, {
                id = i,
                cfg = v
            });
        end;
    end;

    table.sort(v55, function(p57, p58) -- Line: 539
        if p57.cfg.xyd == p58.cfg.xyd then
            return p57.id < p58.id;
        end;

        return p57.cfg.xyd < p58.cfg.xyd;
    end);

    return v55;
end;

function u4.GetIndexRewardRowsByTag(p59) -- Line: 554
    -- upvalues: indexawardConf (copy), Copy (copy)
    local v60 = {};

    for _, v in pairs(indexawardConf) do
        if v.Tag == p59 then
            local v61;

            if v == nil then
                v61 = nil;
            else
                v61 = Copy.deepCopy(v);
            end;

            if v61 then
                table.insert(v60, v61);
            end;
        end;
    end;

    table.sort(v60, function(p62, p63) -- Line: 564
        local v64 = tonumber(p62.NeedCount);
        local v65 = tonumber(p63.NeedCount);

        if not (v64 and v65) then
            error("indexawardConf missing NeedCount");
        end;

        return v64 < v65;
    end);

    return v60;
end;

function u4.FindIndexRewardRow(p66, p67) -- Line: 582
    -- upvalues: indexawardConf (copy), _copyCfg (copy)
    local v68 = tonumber(p67);

    if not v68 then
        return nil;
    end;

    for _, v in pairs(indexawardConf) do
        if v.Tag == p66 and tonumber(v.NeedCount) == v68 then
            return _copyCfg(v);
        end;
    end;

    return nil;
end;

function u4.FindSkillBuffInst(p69) -- Line: 602
    -- upvalues: u4 (copy)
    local v70 = tonumber(p69);

    if v70 then
        return u4.GetCfgByNameAndID("skillbuffConf", v70);
    end;

    return nil;
end;

function u4.GetPlrDataCfg(p71) -- Line: 615
    -- upvalues: u4 (copy)
    local v72 = tonumber(p71);

    if v72 then
        return u4.GetCfgByNameAndID("plrdataConf", v72);
    end;

    return nil;
end;

function u4.FindSkillBuffType(p73) -- Line: 626
    -- upvalues: u4 (copy)
    local v74 = tonumber(p73);

    if v74 then
        return u4.GetCfgByNameAndID("skillbufftypeConf", v74);
    end;

    return nil;
end;

function u4.FindAlchemyRecipeById(p75) -- Line: 640
    -- upvalues: _copyCfg (copy), alchemyConf (copy)
    local v76 = tonumber(p75);

    if v76 then
        return _copyCfg(alchemyConf[v76]);
    end;

    return nil;
end;

function u4.GetAlchemyRecipeList() -- Line: 653
    -- upvalues: alchemyConf (copy), Copy (copy)
    local v77 = {};

    for i, v in pairs(alchemyConf) do
        local v78;

        if v == nil then
            v78 = nil;
        else
            v78 = Copy.deepCopy(v);
        end;

        if v78 then
            v78.recipeId = tonumber(i);
            table.insert(v77, v78);
        end;
    end;

    return v77;
end;

function u4.FindTrainCfgById(p79) -- Line: 671
    -- upvalues: _copyCfg (copy), trainConf (copy)
    local v80 = tonumber(p79) or 0;
    local v81 = math.floor(v80);

    if v81 <= 0 then
        return nil;
    end;

    return _copyCfg(trainConf[v81]);
end;

function u4.CollectTrainPassOnlyTags() -- Line: 684
    -- upvalues: trainConf (copy)
    local v82 = {};
    local v83 = {};

    for _, v in trainConf do
        local OnlyTag = v.OnlyTag;

        if type(OnlyTag) == "string" and (OnlyTag ~= "" and not v82[OnlyTag]) then
            v82[OnlyTag] = true;
            table.insert(v83, OnlyTag);
        end;
    end;

    return v83;
end;

function u4.GetBuffCfgByID(p84) -- Line: 703
    -- upvalues: u4 (copy)
    local v85 = tonumber(p84);

    if v85 then
        return u4.GetCfgByNameAndID("buffdataConf", v85);
    end;

    return nil;
end;

function u4.BuffCfgHasAttr(p86, p87) -- Line: 718
    if p86 then
        p86 = p86.buffAttr;
    end;

    if type(p86) ~= "table" then
        return false;
    end;

    for _, v in ipairs(p86) do
        if tostring(v) == tostring(p87) then
            return true;
        end;
    end;

    return false;
end;

function u4.GetBuffRemainingSec(p88) -- Line: 737
    if type(p88) == "number" then
        return p88;
    end;

    if type(p88) == "table" and p88.BuffTime ~= nil then
        return tonumber(p88.BuffTime);
    end;

    return nil;
end;

function u4.GetBuffTrackedAttrIds() -- Line: 752
    -- upvalues: u6 (ref), buffdataConf (copy)
    if u6 then
        return u6;
    end;

    local v89 = {};

    if type(buffdataConf) == "table" then
        for _, v in pairs(buffdataConf) do
            if v then
                local v = v.buffAttr;
            end;

            if type(v) == "table" then
                for _, v2 in ipairs(v) do
                    local v90 = tostring(v2);

                    if v90 ~= "" then
                        v89[v90] = true;
                    end;
                end;
            end;
        end;
    end;

    u6 = v89;

    return v89;
end;

function u4.BuffAddPowerToRate(p91) -- Line: 781
    return (tonumber(p91) or 0) / 100;
end;

function u4.GetEventCfg(p92) -- Line: 790
    -- upvalues: eventConf (copy), Copy (copy)
    local v93 = tonumber(p92);

    if not (v93 and eventConf) then
        return nil;
    end;

    local v94 = eventConf[v93];
    local v95;

    if v94 == nil then
        v95 = nil;
    else
        v95 = Copy.deepCopy(v94);
    end;

    if v95 then
        v95.id = v93;
    end;

    return v95;
end;

function u4.GetEventList() -- Line: 806
    -- upvalues: eventConf (copy), Copy (copy)
    local v96 = {};

    if not eventConf then
        return v96;
    end;

    local v97 = {};

    for i in pairs(eventConf) do
        local v98 = tonumber(i);

        if v98 then
            table.insert(v97, v98);
        end;
    end;

    table.sort(v97);

    for _, v in ipairs(v97) do
        local v99 = eventConf[v];
        local v100;

        if v99 == nil then
            v100 = nil;
        else
            v100 = Copy.deepCopy(v99);
        end;

        if v100 then
            v100.id = v;
            table.insert(v96, v100);
        end;
    end;

    return v96;
end;

function u4.GetEventShopCfg(p101) -- Line: 834
    -- upvalues: eventshopConf (copy), Copy (copy)
    local v102 = tonumber(p101);

    if not (v102 and eventshopConf) then
        return nil;
    end;

    local v103 = eventshopConf[v102];
    local v104;

    if v103 == nil then
        v104 = nil;
    else
        v104 = Copy.deepCopy(v103);
    end;

    if v104 then
        v104.id = v102;
    end;

    return v104;
end;

function u4.GetEventShopList() -- Line: 850
    -- upvalues: eventshopConf (copy), u4 (copy)
    local v105 = {};

    if not eventshopConf then
        return v105;
    end;

    for i, _ in pairs(eventshopConf) do
        local v106 = u4.GetEventShopCfg(i);

        if v106 then
            table.insert(v105, v106);
        end;
    end;

    table.sort(v105, function(p107, p108) -- Line: 861
        local v109 = tonumber(p107.Sort) or 0;
        local v110 = tonumber(p108.Sort) or 0;

        if v109 == v110 then
            return (tonumber(p107.id) or 0) < (tonumber(p108.id) or 0);
        end;

        return v109 < v110;
    end);

    return v105;
end;

function u4.GetEventHatchList() -- Line: 876
    -- upvalues: eventhatchConf (copy), Copy (copy)
    local v111 = {};

    if not eventhatchConf then
        return v111;
    end;

    local v112 = {};

    for i in pairs(eventhatchConf) do
        local v113 = tonumber(i);

        if v113 then
            table.insert(v112, v113);
        end;
    end;

    table.sort(v112);

    for _, v in ipairs(v112) do
        local v114 = eventhatchConf[v];
        local v115;

        if v114 == nil then
            v115 = nil;
        else
            v115 = Copy.deepCopy(v114);
        end;

        if v115 then
            v115.id = v;
            table.insert(v111, v115);
        end;
    end;

    table.sort(v111, function(p116, p117) -- Line: 896
        local v118 = tonumber(p116.Sort) or 0;
        local v119 = tonumber(p117.Sort) or 0;

        if v118 == v119 then
            return (tonumber(p116.id) or 0) < (tonumber(p117.id) or 0);
        end;

        return v118 < v119;
    end);

    return v111;
end;

function u4.IsEventCfgActive(p120, p121) -- Line: 913
    if type(p120) ~= "table" or tonumber(p120.active) ~= 1 then
        return false;
    end;

    local v122 = tonumber(p121) or workspace:GetServerTimeNow();
    local v123 = math.floor(v122);
    local v124 = tonumber(p120.StartTime) or 0;
    local v125 = tonumber(p120.EndTime) or 0;

    if v124 <= 0 or (v125 <= 0 or v125 <= v124) then
        return false;
    end;

    local v126;

    if v124 <= v123 then
        v126 = v123 <= v125;
    else
        v126 = false;
    end;

    return v126;
end;

function u4.GetEventGameConfig() -- Line: 930
    -- upvalues: SystemGameConfig (copy)
    local v127 = SystemGameConfig.GetValue({ "Event" });

    return type(v127) ~= "table" and {} or v127;
end;

function u4.IsEventActive() -- Line: 942
    -- upvalues: u4 (copy)
    if u4.GetEventGameConfig().ForceActive == true then
        return true;
    end;

    local v128 = workspace:GetServerTimeNow();
    local v129 = math.floor(v128);

    for _, v in ipairs(u4.GetEventList()) do
        if u4.IsEventCfgActive(v, v129) then
            return true;
        end;
    end;

    return false;
end;

function u4.GetActiveEventCfg() -- Line: 960
    -- upvalues: u4 (copy)
    local v130 = u4.GetEventGameConfig();
    local v131 = u4.GetEventList();

    if v130.ForceActive == true then
        return v131[1];
    end;

    local v132 = workspace:GetServerTimeNow();
    local v133 = math.floor(v132);

    for _, v in ipairs(v131) do
        if u4.IsEventCfgActive(v, v133) then
            return v;
        end;
    end;

    return nil;
end;

function u4.GetEventCurrencyItemId() -- Line: 979
    -- upvalues: u4 (copy), EnumMgr (copy)
    local v134 = u4.GetActiveEventCfg();

    if v134 then
        local v135 = tonumber(v134.EventMoney);

        if v135 and v135 > 0 then
            return v135;
        end;
    end;

    return EnumMgr.ItemID.DinosaurCoin;
end;

function u4.ParseEventShopStock(p136) -- Line: 996
    if p136 then
        p136 = p136.Stock;
    end;

    if type(p136) == "string" and string.lower(p136) == "limit" then
        return 1, false;
    end;

    local v137 = tonumber(p136) or 0;

    return math.max(0, v137), false;
end;

function u4.GetEventShopRemain(p138, p139) -- Line: 1011
    local v140 = tonumber(p139) or 0;
    local v141 = math.max(0, v140);

    if v141 <= 0 then
        return 0;
    end;

    local v142 = tonumber(p138) or 0;
    local v143 = math.max(0, v142);

    return math.max(0, v141 - v143);
end;

function u4.IsEventHatchLimitRow(p144) -- Line: 1025
    -- upvalues: u4 (copy), EnumMgr (copy)
    if type(p144) ~= "table" then
        return false;
    end;

    if tonumber(p144.isLimit) == 1 then
        return true;
    end;

    local v145 = tonumber(p144.ItemId) or 0;

    if v145 <= 0 then
        return false;
    end;

    local v146 = u4.FindCfgByID(v145);

    if not v146 then
        return false;
    end;

    local v147 = tonumber(v146.tp);
    local ItemType = EnumMgr.ItemType;

    return (v147 == ItemType.Weapon or v147 == ItemType.Armor) and true or v147 == ItemType.Broom;
end;

function u4.IsEventHatchDrawn(p148, p149, p150) -- Line: 1052
    if type(p148) ~= "table" then
        return false;
    end;

    local v151 = tonumber(p149) or 0;

    if v151 <= 0 then
        return false;
    end;

    local v152 = p148[tostring(v151)];
    local v153 = tonumber(v152) or 0;
    local v154 = math.floor(v153);
    local v155 = math.max(0, v154);
    local v156 = 1;

    if p150 then
        p150 = p150.LimitNum;
    end;

    if type(p150) == "table" then
        local v157 = tonumber(p150[1]);

        if v157 and v157 > 0 then
            v156 = math.floor(v157);
        end;
    end;

    return v156 <= v155;
end;

function u4.GetEventHatchPoolTotalWeight(p158) -- Line: 1081
    -- upvalues: u4 (copy)
    local v159 = 0;

    for _, v in ipairs(u4.GetEventHatchList()) do
        local v160 = tonumber(v.ItemId) or 0;
        local v161 = tonumber(v.Weight) or 0;

        if v160 > 0 and (v161 > 0 and not (u4.IsEventHatchLimitRow(v) and u4.IsEventHatchDrawn(p158, v160, v))) then
            v159 = v159 + v161;
        end;
    end;

    return v159;
end;

function u4.GetTasktypeCfg(p162) -- Line: 1101
    -- upvalues: tasktypeConf (copy), Copy (copy)
    if type(p162) ~= "string" or (p162 == "" or not tasktypeConf) then
        return nil;
    end;

    for i, v in pairs(tasktypeConf) do
        if v and tostring(v.onlyTag) == p162 then
            local v163;

            if v == nil then
                v163 = nil;
            else
                v163 = Copy.deepCopy(v);
            end;

            if v163 then
                v163.id = tonumber(i) or i;
            end;

            return v163;
        end;
    end;

    return nil;
end;

function u4.GetTaskCfgByOnlyTag(p164) -- Line: 1122
    -- upvalues: taskConf (copy), Copy (copy)
    if type(p164) ~= "string" or (p164 == "" or not taskConf) then
        return nil;
    end;

    for i, v in pairs(taskConf) do
        if v and tostring(v.onlyTag) == p164 then
            local v165;

            if v == nil then
                v165 = nil;
            else
                v165 = Copy.deepCopy(v);
            end;

            if v165 then
                v165.id = tonumber(i) or i;
            end;

            return v165;
        end;
    end;

    return nil;
end;

function u4.GetTaskListByResetType(p166) -- Line: 1143
    -- upvalues: taskConf (copy), Copy (copy)
    local v167 = {};
    local v168 = tonumber(p166);

    if not (v168 and taskConf) then
        return v167;
    end;

    local v169 = {};

    for i, v in pairs(taskConf) do
        local v170 = tonumber(i);

        if v170 and (v and tonumber(v.ResetType) == v168) then
            table.insert(v169, v170);
        end;
    end;

    table.sort(v169);

    for _, v in ipairs(v169) do
        local v171 = taskConf[v];
        local v172;

        if v171 == nil then
            v172 = nil;
        else
            v172 = Copy.deepCopy(v171);
        end;

        if v172 then
            v172.id = v;
            table.insert(v167, v172);
        end;
    end;

    return v167;
end;

return u4;