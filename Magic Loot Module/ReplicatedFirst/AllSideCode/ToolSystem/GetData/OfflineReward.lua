-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SystemGameConfig = UtilsSystem.SystemGameConfig;
local CfgFind = UtilsSystem.CfgFind;
local Train = require(script.Parent.Train);
local Sell = require(script.Parent.Sell);
local u1 = {};

local function _getCfgNumber(p2, p3) -- Line: 52
    -- upvalues: SystemGameConfig (copy)
    local v4 = SystemGameConfig.GetValue({ "离线收益", p2 });
    local v5 = tonumber(v4);

    if v5 and v5 == v5 then
        return v5;
    end;

    return p3;
end;

local function _findCareerFirstMaterialId(p6) -- Line: 67
    -- upvalues: CfgFind (copy)
    local v7 = tonumber(p6) or 0;
    local v8 = math.floor(v7);

    if v8 <= 0 then
        return nil;
    end;

    local v9 = CfgFind.GetCfgByNameAndID("dungeonConf", v8);

    if not v9 then
        return nil;
    end;

    local drop = v9.drop;

    if type(drop) ~= "table" then
        return nil;
    end;

    local v10 = tonumber(drop[1]);

    if not v10 or v10 <= 0 then
        return nil;
    end;

    local v11 = CfgFind.GetCfgByNameAndID("boxitemConf", v10);

    if not v11 then
        return nil;
    end;

    local AwardID = v11.AwardID;

    if type(AwardID) ~= "table" then
        return nil;
    end;

    local v12 = tonumber(AwardID[1]);

    if v12 and v12 > 0 then
        return v12;
    end;

    return nil;
end;

function u1.GetOfflineConfigValue(p13) -- Line: 105
    -- upvalues: SystemGameConfig (copy)
    local v14 = SystemGameConfig.GetValue({ "离线收益", p13 });
    local v15 = tonumber(v14);

    if v15 and v15 == v15 then
        return v15;
    end;

    return nil;
end;

function u1.GetLobbySingleTrainGain(p16) -- Line: 120
    -- upvalues: Train (copy)
    return Train.CalcTrainGain(p16, 1);
end;

local function _getMaterialSellPrice(p17, p18) -- Line: 131
    -- upvalues: CfgFind (copy), Sell (copy)
    local v19 = tonumber(p18) or 0;
    local v20 = math.floor(v19);

    if v20 <= 0 then
        return 0;
    end;

    local v21 = CfgFind.FindCfgByID(v20);

    return not v21 and 0 or math.max(0, Sell.GetSellPrice(p17, v21));
end;

function u1.GetCareerStageUnitSellPrice(p22, p23) -- Line: 150
    -- upvalues: _findCareerFirstMaterialId (copy), SystemGameConfig (copy), CfgFind (copy), Sell (copy)
    local v24 = _findCareerFirstMaterialId(p23);

    if not v24 then
        local v25 = SystemGameConfig.GetValue({ "离线收益", "离线金币保底材料ID" });
        local v26 = tonumber(v25);
        v24 = math.floor((not v26 or v26 ~= v26) and 2010001 or v26);
    end;

    local v27 = tonumber(v24) or 0;
    local v28 = math.floor(v27);

    if v28 <= 0 then
        return 0;
    end;

    local v29 = CfgFind.FindCfgByID(v28);

    return not v29 and 0 or math.max(0, Sell.GetSellPrice(p22, v29));
end;

function u1.CalcOfflineRewards(p30, p31, p32) -- Line: 168
    -- upvalues: SystemGameConfig (copy), u1 (copy)
    local v33 = SystemGameConfig.GetValue({ "离线收益", "离线收益上限" });
    local v34 = tonumber(v33);
    local v35 = math.floor((not v34 or v34 ~= v34) and 10800 or v34);
    local v36 = math.max(0, v35);
    local v37 = SystemGameConfig.GetValue({ "离线收益", "离线训练每秒次数" });
    local v38 = tonumber(v37);
    local v39 = math.max(0, (not v38 or v38 ~= v38) and 1 or v38);
    local v40 = SystemGameConfig.GetValue({ "离线收益", "离线金币时间单位秒" });
    local v41 = tonumber(v40);
    local v42 = math.floor((not v41 or v41 ~= v41) and 600 or v41);
    local v43 = math.max(1, v42);
    local v44 = tonumber(p31) or 0;
    local v45 = math.floor(v44);
    local v46 = math.clamp(v45, 0, v36);
    local v47 = u1.GetLobbySingleTrainGain(p30);
    local v48 = v47 < 0 and 0 or v47;
    local v49 = math.floor(v46 * v39) * v48;
    local v50 = u1.GetCareerStageUnitSellPrice(p30, p32);

    return {
        offlineSec = v46,
        powerGain = v49,
        coinGain = (v50 <= 0 or v46 <= 0) and 0 or math.floor(v50 * v46 / v43),
        singleGain = v48
    };
end;

function u1.CalcOfflineTrainPower(p51, p52) -- Line: 205
    -- upvalues: u1 (copy)
    return u1.CalcOfflineRewards(p51, p52, 0);
end;

return u1;