-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local CfgFind = UtilsSystem.CfgFind;
local Copy = UtilsSystem.Copy;
local Log = UtilsSystem.Log;
local u1 = {};
local u2 = {
    Material = {
        confName = "materialConf"
    },
    Potion = {
        confName = "potionConf"
    }
};
local u3 = { "Material", "Potion" };
local u4 = {};

local function _isTab(p5) -- Line: 64
    -- upvalues: u2 (copy)
    return u2[p5] ~= nil;
end;

local function _normalizeRewardStateMap(p6) -- Line: 77
    local v7 = {};

    for i, v in pairs(p6) do
        local v8 = tonumber(i);
        local v9 = tonumber(v);

        if v8 and v9 ~= nil then
            local v10 = v7[v8];

            if v10 == nil or v10 < v9 then
                v7[v8] = v9;
            end;
        end;
    end;

    return v7;
end;

local function _toNumList(p11) -- Line: 100
    if type(p11) ~= "table" then
        local v12 = tonumber(p11);

        return v12 and { v12 } or {};
    end;

    local v13 = {};

    for _, v in ipairs(p11) do
        local v14 = tonumber(v);

        if v14 then
            table.insert(v13, v14);
        end;
    end;

    return v13;
end;

local function _getItemConf(p15) -- Line: 124
    -- upvalues: u2 (copy), CfgFind (copy)
    if u2[p15] == nil then
        return nil;
    end;

    return CfgFind.GetCfgByName(u2[p15].confName);
end;

local function _getItemTotal(p16) -- Line: 137
    -- upvalues: u4 (copy), u2 (copy), CfgFind (copy)
    local v17 = u4[p16];

    if v17 ~= nil then
        return v17;
    end;

    local v18;

    if u2[p16] == nil then
        v18 = nil;
    else
        v18 = CfgFind.GetCfgByName(u2[p16].confName);
    end;

    if v18 == nil then
        u4[p16] = 0;

        return 0;
    end;

    local v19 = 0;

    for i, v in pairs(v18) do
        if tonumber(i) and CfgFind.IsShowInIndex(v) then
            v19 = v19 + 1;
        end;
    end;

    u4[p16] = v19;

    return v19;
end;

local function _toUnlockSet(p20, p21) -- Line: 166
    -- upvalues: u2 (copy), CfgFind (copy)
    local v22;

    if u2[p20] == nil then
        v22 = nil;
    else
        v22 = CfgFind.GetCfgByName(u2[p20].confName);
    end;

    local v23 = {};

    for i, v in pairs(p21) do
        local v24 = tonumber(i);

        if v24 and (v ~= nil and (v22 and CfgFind.IsShowInIndex(v22[v24]))) then
            v23[v24] = true;
        end;
    end;

    return v23;
end;

local function _countUnlock(p25, p26) -- Line: 185
    -- upvalues: _toUnlockSet (copy)
    local v27 = _toUnlockSet(p25, p26);
    local v28 = 0;

    for _ in pairs(v27) do
        v28 = v28 + 1;
    end;

    return v28;
end;

local function _pickClaimed(p29) -- Line: 200
    local v30 = {};

    if p29 == nil then
        return v30;
    end;

    for i, v in pairs(p29) do
        local v31 = tonumber(i);

        if v31 ~= nil and tonumber(v) == 1 then
            v30[v31] = 1;
        end;
    end;

    return v30;
end;

local function _calcSegmentProgress(p32, p33, p34) -- Line: 222
    local v35 = p33 - p32;

    if v35 <= 0 then
        return 0, 0, false;
    end;

    local v36 = p34 - p32;

    return v35, v36, v35 <= v36;
end;

local function _buildRewardState(p37, p38, p39) -- Line: 243
    -- upvalues: CfgFind (copy)
    local v40 = CfgFind.GetIndexRewardRowsByTag(p37);
    local v41 = 0;
    local v42 = false;
    local v43 = {};

    for _, v in ipairs(v40) do
        local v44 = tonumber(v.NeedCount);

        if v44 then
            if p39[v44] == 1 then
                v43[v44] = 1;
                v41 = v44;
            else
                local v45 = v44 - v41;
                local v46;

                if v45 <= 0 then
                    v46 = false;
                else
                    v46 = v45 <= p38 - v41;
                end;

                if v42 then
                    v43[v44] = -1;
                else
                    v43[v44] = v46 and 0 or -1;
                    v42 = true;
                end;
            end;
        end;
    end;

    return v43;
end;

local function _findNextRewardRow(p47, p48) -- Line: 280
    for _, v in ipairs(p48) do
        local v49 = tonumber(v.NeedCount);

        if v49 and p47[v49] ~= 1 then
            return v;
        end;
    end;

    return nil;
end;

local function _resolveRewardDisplay(p50) -- Line: 296
    -- upvalues: _toNumList (copy), CfgFind (copy)
    local v51 = _toNumList(p50.AwardID);
    local v52 = 0;

    for _, v in ipairs((_toNumList(p50.CountID))) do
        v52 = v52 + v;
    end;

    local v53 = "";
    local v54 = v51[1];

    if v54 then
        local v55 = CfgFind.FindCfgByID(v54);

        if v55 and (v55.Icon ~= nil and tostring(v55.Icon) ~= "") then
            v53 = tostring(v55.Icon);
        end;
    end;

    return v53, v52, v54;
end;

local function _makeProgressView(p56, p57, p58, p59) -- Line: 323
    -- upvalues: _findNextRewardRow (copy), _resolveRewardDisplay (copy)
    local v60 = _findNextRewardRow(p58, p59);

    if v60 == nil then
        local v61 = p59[#p59];
        local v62, v63, v64;

        if v61 then
            v62, v63, v64 = _resolveRewardDisplay(v61);
        else
            v63 = 0;
            v62 = "";
            v64 = nil;
        end;

        return {
            barRatio = 1,
            canClaim = false,
            targetProgress = nil,
            allClaimed = true,
            unlockCount = p56,
            totalCount = p57,
            textNumerator = p56,
            textDenominator = p56,
            rewardCount = v63,
            rewardIcon = v62,
            primaryAwardId = v64
        };
    end;

    local v65 = tonumber(v60.NeedCount);

    if not v65 then
        error("IndexView: indexawardConf missing NeedCount");
    end;

    local v66 = p58[v65] == 0;
    local v67 = v65 <= 0 and 0 or math.clamp(p56 / v65, 0, 1);
    local v68, v69, v70 = _resolveRewardDisplay(v60);

    return {
        allClaimed = false,
        unlockCount = p56,
        totalCount = p57,
        textNumerator = p56,
        textDenominator = v65,
        barRatio = v66 and 1 or v67,
        canClaim = v66,
        targetProgress = v65,
        rewardCount = v69,
        rewardIcon = v68,
        primaryAwardId = v70
    };
end;

function u1.buildTabSnapshot(p71, p72) -- Line: 391
    -- upvalues: u2 (copy), CfgFind (copy), Log (copy), _toUnlockSet (copy), _pickClaimed (copy), _normalizeRewardStateMap (copy), _buildRewardState (copy), _getItemTotal (copy), _makeProgressView (copy), Copy (copy)
    if u2[p71] == nil or type(p72) ~= "table" then
        return nil;
    end;

    local v73 = p72[p71];
    local v74 = type(v73) ~= "table" and {} or v73;
    local Reward = p72.Reward;
    local v75 = (type(Reward) ~= "table" or type(Reward[p71]) ~= "table") and {} or Reward[p71];
    local v76 = CfgFind.GetIndexRewardRowsByTag(p71);

    if #v76 == 0 then
        Log.warn((`IndexView: indexawardConf empty for {p71}`));

        return nil;
    end;

    local v77 = _toUnlockSet(p71, v74);
    local v78 = 0;

    for _ in pairs(v77) do
        v78 = v78 + 1;
    end;

    local v79 = _buildRewardState(p71, v78, (_pickClaimed((_normalizeRewardStateMap(v75)))));
    local v80 = _makeProgressView(v78, _getItemTotal(p71), v79, v76);

    return {
        unlockSet = Copy.deepCopy((_toUnlockSet(p71, v74))),
        progress = v80
    };
end;

function u1.buildAllTabSnapshots(p81) -- Line: 431
    -- upvalues: u3 (copy), u1 (copy)
    if type(p81) ~= "table" then
        return nil;
    end;

    local v82 = {};

    for _, v in ipairs(u3) do
        local v83 = u1.buildTabSnapshot(v, p81);

        if v83 == nil then
            return nil;
        end;

        v82[v] = v83;
    end;

    return v82;
end;

return u1;