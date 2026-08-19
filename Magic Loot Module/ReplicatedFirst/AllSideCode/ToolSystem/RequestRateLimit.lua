-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local TipsModule = UtilsSystem.TipsModule;
local Copy = UtilsSystem.Copy;
local u1 = {};
local u2 = RunService:IsServer();
local u3 = {
    ["私人服务器玩家id"] = {
        maxRequests = 5,
        timeWindow = 10
    },
    ["RNG请求"] = {
        maxRequests = 1,
        timeWindow = 1
    },
    _default = {
        maxRequests = 20,
        timeWindow = 1
    }
};
local u4 = {
    ["私人服务器玩家id"] = {
        enabled = true,
        cheatTypes = { "rate_limit_exceeded", "data_invalid" },
        thresholds = {
            rate_limit_exceeded = {
                severity = 3,
                maxCount = 5,
                maxSeverity = 15,
                action = "warn"
            },
            data_invalid = {
                severity = 5,
                maxCount = 3,
                maxSeverity = 15,
                action = "warn"
            }
        },
        globalThresholds = {
            warnThreshold = {
                maxCount = 8,
                maxSeverity = 25
            },
            kickThreshold = {
                maxCount = 15,
                maxSeverity = 40
            }
        }
    },
    ["领取等级奖励"] = {
        enabled = true,
        cheatTypes = { "rate_limit_exceeded", "data_invalid", "request_pattern_abnormal" },
        thresholds = {
            rate_limit_exceeded = {
                severity = 4,
                maxCount = 3,
                maxSeverity = 12,
                action = "warn"
            },
            data_invalid = {
                severity = 6,
                maxCount = 2,
                maxSeverity = 12,
                action = "warn"
            },
            request_pattern_abnormal = {
                severity = 7,
                maxCount = 2,
                maxSeverity = 14,
                action = "warn"
            }
        },
        globalThresholds = {
            warnThreshold = {
                maxCount = 5,
                maxSeverity = 20
            },
            kickThreshold = {
                maxCount = 10,
                maxSeverity = 35
            }
        }
    }
};
local u5 = {
    rate_limit_exceeded = {
        severity = 3,
        maxCount = 5,
        maxSeverity = 15,
        action = "warn"
    },
    data_invalid = {
        severity = 5,
        maxCount = 3,
        maxSeverity = 15,
        action = "warn"
    },
    data_format_error = {
        severity = 4,
        maxCount = 5,
        maxSeverity = 20,
        action = "warn"
    },
    request_pattern_abnormal = {
        severity = 6,
        maxCount = 3,
        maxSeverity = 18,
        action = "warn"
    },
    severe_cheat = {
        severity = 10,
        maxCount = 1,
        maxSeverity = 10,
        action = "kick"
    }
};
local u6 = {
    warnThreshold = {
        maxCount = 10,
        maxSeverity = 30
    },
    kickThreshold = {
        maxCount = 20,
        maxSeverity = 50
    }
};
local u7 = false;
local u8 = nil;
local u9 = {};
local u10 = {};

local function _cleanupExpiredRecords(p11, p12, p13) -- Line: 256
    -- upvalues: u9 (copy)
    local v14 = u9[p11];

    if not (v14 and v14[p12]) then
        return;
    end;

    local timestamps = v14[p12].timestamps;
    local v15 = os.time() - p13;

    for i = #timestamps, 1, -1 do
        if timestamps[i] < v15 then
            table.remove(timestamps, i);
        end;
    end;
end;

local function _isCheatDetectionEnabled(p16) -- Line: 278
    -- upvalues: u4 (copy)
    local v17 = u4[p16];
    local v18;

    if v17 == nil then
        v18 = false;
    else
        v18 = v17.enabled == true;
    end;

    return v18;
end;

local function _getCheatTypeConfig(p19, p20) -- Line: 289
    -- upvalues: u4 (copy), u5 (copy)
    local v21 = u4[p19];

    if not (v21 and v21.enabled) then
        return nil;
    end;

    if not v21.cheatTypes then
        return nil;
    end;

    local v22 = false;

    for _, v in ipairs(v21.cheatTypes) do
        if v == p20 then
            v22 = true;
            break;
        end;
    end;

    if not v22 then
        return nil;
    end;

    if v21.thresholds and v21.thresholds[p20] then
        return v21.thresholds[p20];
    end;

    return u5[p20];
end;

local function _getGlobalThresholds(p23) -- Line: 322
    -- upvalues: u4 (copy), u6 (copy)
    local v24 = u4[p23];

    return v24 and v24.globalThresholds and {
        warnThreshold = {
            maxCount = v24.globalThresholds.warnThreshold.maxCount or u6.warnThreshold.maxCount,
            maxSeverity = v24.globalThresholds.warnThreshold.maxSeverity or u6.warnThreshold.maxSeverity
        },
        kickThreshold = {
            maxCount = v24.globalThresholds.kickThreshold.maxCount or u6.kickThreshold.maxCount,
            maxSeverity = v24.globalThresholds.kickThreshold.maxSeverity or u6.kickThreshold.maxSeverity
        }
    } or u6;
end;

local function _evaluateCheatAction(p25, p26, p27, p28) -- Line: 352
    local v29 = false;
    local v30 = false;

    if p26.count >= p27.maxCount or p26.severity >= p27.maxSeverity then
        if p27.action == "kick" then
            v30 = true;
        else
            v29 = true;
        end;
    end;

    if p25.totalCount >= p28.kickThreshold.maxCount or p25.totalSeverity >= p28.kickThreshold.maxSeverity then
        v30 = true;
    elseif p25.totalCount >= p28.warnThreshold.maxCount or p25.totalSeverity >= p28.warnThreshold.maxSeverity then
        v29 = true;
    end;

    return v30, v29;
end;

local function _executeKick(p31, p32, p33, p34, p35) -- Line: 388
    -- upvalues: Log (copy)
    Log.warn(string.format("检测到玩家 %s (%d) 严重异常行为，消息: %s，类型: %s，总次数: %d，总程度: %d，执行踢出", p31.Name, p32, p33, p34, p35.totalCount, p35.totalSeverity));
    p31:Kick("检测到异常行为，已被踢出游戏");
end;

local function _executeWarn(p36, p37, p38, p39, p40) -- Line: 415
    -- upvalues: Log (copy), TipsModule (copy)
    local v41 = os.time();

    if v41 - p40.lastWarnTime < 10 then
        return;
    end;

    p40.warnCount = p40.warnCount + 1;
    p40.lastWarnTime = v41;
    Log.warn(string.format("警告玩家 %s (%d) 异常行为，消息: %s，类型: %s，总次数: %d，总程度: %d，警告次数: %d", p36.Name, p37, p38, p39, p40.totalCount, p40.totalSeverity, p40.warnCount));
    TipsModule.ErrorTips(p36, string.format("检测到异常行为，警告次数: %d", p40.warnCount));
end;

local function _clearPlayerRecords(p42) -- Line: 447
    -- upvalues: u9 (copy), u10 (copy)
    u9[p42] = nil;
    u10[p42] = nil;
end;

function u1.DetectDataAnomaly(p43) -- Line: 461
    if type(p43) == "number" and tostring(p43) == "nan" then
        return "data_invalid";
    end;

    if p43 == nil then
        return "data_invalid";
    end;

    if type(p43) == "table" then
        for _, v in pairs(p43) do
            if type(v) == "number" and tostring(v) == "nan" then
                return "data_invalid";
            end;
        end;
    end;

    return nil;
end;

function u1.DetectRequestPatternAnomaly(p44) -- Line: 486
    -- upvalues: u9 (copy)
    local v45 = u9[p44];

    if not v45 then
        return false;
    end;

    local v46 = os.time();
    local v47 = 0;

    for _, v in pairs(v45) do
        if v.timestamps then
            for _, v2 in ipairs(v.timestamps) do
                if v46 - v2 <= 5 then
                    v47 = v47 + 1;
                    break;
                end;
            end;
        end;
    end;

    return v47 > 10;
end;

function u1.RecordCheatAndCheck(p48, p49, p50) -- Line: 516
    -- upvalues: u4 (copy), _getCheatTypeConfig (copy), u10 (copy), _getGlobalThresholds (copy), _evaluateCheatAction (copy), Log (copy), _executeWarn (copy)
    local v51 = u4[p49];
    local v52;

    if v51 == nil then
        v52 = false;
    else
        v52 = v51.enabled == true;
    end;

    if not v52 then
        return false;
    end;

    local v53 = _getCheatTypeConfig(p49, p50);

    if not v53 then
        return false;
    end;

    local UserId = p48.UserId;
    local severity = v53.severity;

    if not u10[UserId] then
        u10[UserId] = {
            totalCount = 0,
            totalSeverity = 0,
            warnCount = 0,
            lastWarnTime = 0,
            records = {}
        };
    end;

    local v54 = u10[UserId];
    local v55 = p49 .. "_" .. p50;

    if not v54.records[v55] then
        v54.records[v55] = {
            count = 0,
            severity = 0,
            lastTime = 0
        };
    end;

    local v56 = v54.records[v55];
    v56.count = v56.count + 1;
    v56.severity = v56.severity + severity;
    v56.lastTime = os.time();
    v54.totalCount = v54.totalCount + 1;
    v54.totalSeverity = v54.totalSeverity + severity;
    local v57, v58 = _evaluateCheatAction(v54, v56, v53, (_getGlobalThresholds(p49)));

    if not v57 then
        if v58 then
            _executeWarn(p48, UserId, p49, p50, v54);
        end;

        return false;
    end;

    Log.warn(string.format("检测到玩家 %s (%d) 严重异常行为，消息: %s，类型: %s，总次数: %d，总程度: %d，执行踢出", p48.Name, UserId, p49, p50, v54.totalCount, v54.totalSeverity));
    p48:Kick("检测到异常行为，已被踢出游戏");

    return true;
end;

function u1.CheckRateLimit(p59, p60) -- Line: 583
    -- upvalues: u3 (copy), u9 (copy), _cleanupExpiredRecords (copy), u1 (copy), Log (copy)
    local UserId = p59.UserId;
    local v61 = u3[p60] or u3._default;
    local maxRequests = v61.maxRequests;
    local timeWindow = v61.timeWindow;

    if not u9[UserId] then
        u9[UserId] = {};
    end;

    if not u9[UserId][p60] then
        u9[UserId][p60] = {
            timestamps = {}
        };
    end;

    _cleanupExpiredRecords(UserId, p60, timeWindow);
    local timestamps = u9[UserId][p60].timestamps;

    if maxRequests > #timestamps then
        table.insert(timestamps, os.time());

        return true;
    end;

    if u1.RecordCheatAndCheck(p59, p60, "rate_limit_exceeded") then
        return false;
    end;

    Log.warn(string.format("玩家 %s (%d) 的请求 \'%s\' 超过频率限制: %d次/%d秒", p59.Name, UserId, p60, maxRequests, timeWindow));

    return false;
end;

function u1.SetRateLimitConfig(p62, p63) -- Line: 629
    -- upvalues: u3 (copy)
    u3[p62] = p63;
end;

function u1.SetCheatDetectionConfig(p64, p65) -- Line: 638
    -- upvalues: u4 (copy)
    u4[p64] = p65;
end;

function u1.IsCheatDetectionEnabled(p66) -- Line: 647
    -- upvalues: u4 (copy)
    local v67 = u4[p66];
    local v68;

    if v67 == nil then
        v68 = false;
    else
        v68 = v67.enabled == true;
    end;

    return v68;
end;

function u1.GetPlayerCheatRecord(p69) -- Line: 660
    -- upvalues: u10 (copy), Copy (copy)
    if not p69 then
        return nil;
    end;

    local v70 = u10[p69.UserId];

    if v70 then
        return Copy.deepCopy(v70);
    end;

    return nil;
end;

function u1.ClearPlayerCheatRecord(p71) -- Line: 677
    -- upvalues: u9 (copy), u10 (copy), Log (copy)
    if not p71 then
        return;
    end;

    local UserId = p71.UserId;
    u9[UserId] = nil;
    u10[UserId] = nil;
    Log.print(string.format("已清除玩家 %s (%d) 的异常记录", p71.Name, p71.UserId));
end;

function u1.Init() -- Line: 693
    -- upvalues: u7 (ref), u2 (copy), u8 (ref), Players (copy), u9 (copy), u10 (copy)
    if u7 then
        return;
    end;

    u7 = true;

    if not u2 then
        return;
    end;

    u8 = Players.PlayerRemoving:Connect(function(p72) -- Line: 703
        -- upvalues: u9 (ref), u10 (ref)
        local UserId = p72.UserId;
        u9[UserId] = nil;
        u10[UserId] = nil;
    end);
end;

return u1;