-- Decompiled with Potassium's decompiler.

local u1 = game:GetService("RunService"):IsStudio();
local u2 = game:GetService("RunService"):IsServer();
local HttpService = game:GetService("HttpService");
local AnalyticsService = game:GetService("AnalyticsService");
local AnalyticsLogLevel = Enum.AnalyticsLogLevel;
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u3;

if u2 then
    u3 = nil;
else
    u3 = Players.LocalPlayer or nil;
end;

local Log = script:FindFirstAncestor("Packages").Configs:FindFirstChild("Log");
local v4 = Log and require(Log) or "Debug";
local Asserts = require(ReplicatedStorage.Library.Asserts);
local JSON = require(ReplicatedStorage.Library.Functions.JSON);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local u5 = nil;
local clock = os.clock;
local u6 = {
    Trace = AnalyticsLogLevel.Trace.Value,
    Debug = AnalyticsLogLevel.Debug.Value,
    Info = AnalyticsLogLevel.Information.Value,
    Warning = AnalyticsLogLevel.Warning.Value,
    Error = AnalyticsLogLevel.Error.Value,
    Fatal = AnalyticsLogLevel.Fatal.Value
};

local function ToSeconds(p7, p8) -- Line: 192
    if p8 == 0 then
        return p7 / 1000;
    end;

    if p8 == 1 then
        return p7;
    end;

    if p8 == 2 then
        return p7 * 60;
    end;

    if p8 == 3 then
        return p7 * 3600;
    end;

    if p8 == 4 then
        return p7 * 86400;
    end;

    if p8 == 5 then
        return p7 * 604800;
    end;

    if p8 == 6 then
        return p7 * 2592000;
    end;

    if p8 == 7 then
        return p7 * 31536000;
    end;

    error("Unknown time unit", 2);
end;

local function GetPlayerFromCustomData(p9) -- Line: 214
    local v10 = type(p9) == "table" and (p9.Player or p9.PlayerId);

    if v10 then
        return game:GetService("Players"):GetPlayerByUserId(v10);
    end;

    return nil;
end;

local u22 = u1 and function(p11, p12, p13, p14) -- Line: 226
end or function(u15, u16, u17, u18) -- Line: 228
    -- upvalues: u3 (copy), AnalyticsService (copy)
    local success, result = pcall(function() -- Line: 229
        -- upvalues: u3 (ref), u18 (copy), AnalyticsService (ref), u15 (copy), u16 (copy), u17 (copy)
        local v19 = u3;

        if not v19 then
            local v20 = u18;

            if type(v20) == "table" then
                local v21 = v20.Player or v20.PlayerId;

                if v21 then
                    v19 = game:GetService("Players"):GetPlayerByUserId(v21);
                else
                    v19 = nil;
                end;
            else
                v19 = nil;
            end;
        end;

        AnalyticsService:FireLogEvent(v19, u15, u16, {
            stackTrace = u17
        }, u18);
    end);

    if not success then
        warn(result);
    end;
end;
local u23 = {};
u23.__index = u23;

function u23.new(p24, p25, p26, p27, p28) -- Line: 256
    -- upvalues: u23 (copy)
    return setmetatable({
        _muted = p28,
        _log = p24,
        _traceback = p26,
        _levelName = p25,
        _modifiers = {
            Throw = false
        },
        _key = p27
    }, u23);
end;

function u23._shouldLog(p29, p30) -- Line: 270
    -- upvalues: clock (copy)
    if p29._modifiers.Every and not p30:_checkAndIncrementCount(p29._modifiers.Every) then
        return false;
    end;

    return (not p29._modifiers.AtMostEvery or p30:_checkLastTimestamp(clock(), p29._modifiers.AtMostEvery)) and true or false;
end;

function u23.Every(p31, p32) -- Line: 280
    p31._modifiers.Every = p32;

    return p31;
end;

function u23.AtMostEvery(p33, p34, p35) -- Line: 285
    -- upvalues: ToSeconds (copy)
    p33._modifiers.AtMostEvery = ToSeconds(p34, p35);

    return p33;
end;

function u23.Throw(p36) -- Line: 290
    p36._modifiers.Throw = true;

    return p36;
end;

function u23.Log(p37, p38, ...) -- Line: 295
    -- upvalues: wcall (copy), HttpService (copy), u1 (copy), JSON (copy), clock (copy), u6 (copy), u22 (ref)
    if p37._muted then
        return;
    end;

    local v39 = select("#", ...);
    local v40 = nil;
    local v41;

    if v39 == 1 then
        v41 = select(1, ...);
    else
        v41 = v39 > 1 and { ... } or v40;
    end;

    local v42 = p37._log:_getLogStats(p37._key);
    local v43 = false;

    if not p37:_shouldLog(v42) then
        return;
    end;

    local v44;

    if type(p38) == "function" then
        local v45;
        v44, v45 = p38();

        if v45 ~= nil then
            v41 = v45;
        end;
    elseif type(p38) == "table" then
        local v46;
        v46, v44 = wcall(HttpService.JSONEncode, HttpService, p38);

        if v46 then
            if not v44 then
                v44 = p38;
            end;
        else
            v44 = p38;
        end;
    else
        v44 = p38;
    end;

    if not u1 and (p37._log._settings.EnableStringRead and (type(v44) == "string" and type(v41) == "table")) then
        local v47, v48 = wcall(JSON.stringify, v41, nil, 2, true);

        if v47 and v48 then
            v44 = v44 .. " " .. v48;
            v43 = true;
        end;
    end;

    v42:_setTimestamp(clock());
    local v49 = ("%s: [%s] %s"):format(p37._log._name, p37._levelName, v44);
    local v50 = u6[p37._levelName];
    u22(v50, ("%s: %s"):format(p37._log._name, v44), p37._traceback, v41);

    if p37._modifiers.Throw then
        error(v49 .. (v41 and not v43 and (" " .. HttpService:JSONEncode(v41) or "") or ""), 4);

        return;
    end;

    if v50 < u6.Warning then
        print(v49, v43 and "" or (v41 or ""));

        return;
    end;

    warn(v49, v43 and "" or (v41 or ""));
end;

function u23.SepLog(p51, p52, p53) -- Line: 357
    -- upvalues: Asserts (copy)
    Asserts.optional.string(p53);
    Asserts.optional.number(p52);
    p51:Log(string.rep(p53 or "-", p52 or 100));
end;

function u23.Wrap(u54) -- Line: 364
    return function(...) -- Line: 365
        -- upvalues: u54 (copy)
        u54:Log(...);
    end;
end;

function u23.Assert(p55, p56, ...) -- Line: 370
    if p56 then
        p55:Throw():Log(...);
    end;
end;

local u57 = {};
u57.__index = u57;
setmetatable(u57, u23);

function u57.new(...) -- Line: 380
    -- upvalues: u23 (copy), u57 (copy)
    local v58 = u23.new(...);

    return setmetatable(v58, u57);
end;

function u57.Log(p59) -- Line: 385
end;

local u60 = {};
u60.__index = u60;

function u60.new() -- Line: 400
    -- upvalues: u60 (copy)
    local v61 = setmetatable({}, u60);
    v61._invocationCount = 0;
    v61._lastTimestamp = 0;

    return v61;
end;

function u60._checkAndIncrementCount(p62, p63) -- Line: 407
    local v64 = p62._invocationCount % p63 == 0;
    p62._invocationCount = p62._invocationCount + 1;

    return v64;
end;

function u60._checkLastTimestamp(p65, p66, p67) -- Line: 413
    return p67 <= p66 - p65._lastTimestamp;
end;

function u60._setTimestamp(p68, p69) -- Line: 417
    p68._lastTimestamp = p69;
end;

local u70 = {};
u70.__index = u70;
u70.TimeUnit = {
    Milliseconds = 0,
    Seconds = 1,
    Minutes = 2,
    Hours = 3,
    Days = 4,
    Weeks = 5,
    Months = 6,
    Years = 7
};
u70.Level = u6;
u70.LevelNames = {};

for i, v in pairs(u70.Level) do
    u70.LevelNames[v] = i;
end;

function u70.new(p71) -- Line: 621
    -- upvalues: Asserts (copy), u70 (copy)
    Asserts.optional.table(p71);
    local v72 = setmetatable({}, u70);
    v72._name = debug.info(2, "s"):match("([^%.]-)$");
    v72._muted = false;
    v72._stats = {};
    v72._settings = p71 or {};

    return v72;
end;

function u70.getLevelFromName(p73) -- Line: 633
    -- upvalues: Asserts (copy), u70 (copy)
    Asserts.string(p73);
    local v74 = u70.Level[p73];
    local v75 = `Invalid log level: "{p73}"`;

    return assert(v74, v75);
end;

function u70.isWithinLevel(p76) -- Line: 638
    -- upvalues: u70 (copy), u5 (ref)
    return u5 <= u70.getLevelFromName(p76), u5;
end;

function u70._getLogStats(p77, p78) -- Line: 643
    -- upvalues: u60 (copy)
    local v79 = p77._stats[p78];

    if not v79 then
        v79 = u60.new();
        p77._stats[p78] = v79;
    end;

    return v79;
end;

function u70._at(p80, p81) -- Line: 652
    -- upvalues: u5 (ref), u57 (copy), u70 (copy), u23 (copy)
    local v82, v83 = debug.info(3, "lf");
    local v84 = debug.traceback("Log", 3);
    local v85 = tostring(v82) .. tostring(v83);

    if p81 < (p80._limitUnder or u5) then
        return u57.new(p80, u70.LevelNames[p81], v84, v85);
    end;

    return u23.new(p80, u70.LevelNames[p81], v84, v85, p80._muted);
end;

function u70.Mute(p86) -- Line: 664
    p86._muted = true;

    return p86;
end;

function u70.UnMute(p87) -- Line: 669
    p87._muted = false;

    return p87;
end;

function u70.LimitUnderLevel(p88, p89) -- Line: 674
    -- upvalues: u70 (copy)
    p88._limitUnder = u70.getLevelFromName(p89);

    return p88;
end;

function u70.At(p90, p91) -- Line: 683
    return p90:_at(p91);
end;

function u70.AtTrace(p92) -- Line: 691
    -- upvalues: u70 (copy)
    return p92:_at(u70.Level.Trace);
end;

function u70.AtDebug(p93) -- Line: 699
    -- upvalues: u70 (copy)
    return p93:_at(u70.Level.Debug);
end;

function u70.AtInfo(p94) -- Line: 707
    -- upvalues: u70 (copy)
    return p94:_at(u70.Level.Info);
end;

function u70.AtWarning(p95) -- Line: 715
    -- upvalues: u70 (copy)
    return p95:_at(u70.Level.Warning);
end;

function u70.AtError(p96) -- Line: 723
    -- upvalues: u70 (copy)
    return p96:_at(u70.Level.Error);
end;

function u70.AtFatal(p97) -- Line: 731
    -- upvalues: u70 (copy)
    return p97:_at(u70.Level.Fatal);
end;

function u70.Assert(p98, p99, ...) -- Line: 742
    -- upvalues: u70 (copy)
    if not p99 then
        p98:_at(u70.Level.Error):Throw():Log(...);
    end;
end;

function u70.Destroy(p100) -- Line: 748
end;

function u70.__tostring(p101) -- Line: 750
    return ("Log<%s>"):format(p101._name);
end;

local function SetLogLevel(p102) -- Line: 756
    -- upvalues: u70 (copy), u1 (copy), u2 (copy), u5 (ref)
    local v103 = p102:lower();

    for i, v in pairs(u70.Level) do
        if i:lower() == v103 then
            if u1 then
                local v104 = u2 and "LogLevel" or "LogLevelClient";
                local v105 = v103:sub(1, 1):upper() .. v103:sub(2);
                local v106 = workspace:GetAttribute(v104) or "";

                if tostring(v106) ~= v105 then
                    workspace:SetAttribute(v104, v105);
                end;
            end;

            u5 = v;

            return;
        end;
    end;

    error("Unknown log level: " .. tostring(p102));
end;

local v107 = type(v4);
assert(v107 == "table" and true or v107 == "string", "LogConfig must return a table or a string; got " .. v107);

if v107 == "string" then
    SetLogLevel(v4);
elseif u1 and v4.Studio then
    local v108 = type(v4.Studio);
    assert(v108 == "table" and true or v108 == "string", "LogConfig.Studio must be a table or a string; got " .. v108);

    if v108 == "string" then
        SetLogLevel(v4.Studio);
    elseif u2 then
        local Server = v4.Studio.Server;
        local v109 = type(Server) == "string";
        local v110 = "LogConfig.Studio.Server must be a string; got " .. type(Server);
        assert(v109, v110);
        SetLogLevel(Server);
    else
        local Client = v4.Studio.Client;
        local v111 = type(Client) == "string";
        local v112 = "LogConfig.Studio.Client must be a string; got " .. type(Client);
        assert(v111, v112);
        SetLogLevel(Client);
    end;
else
    local v113 = false;
    local v114 = nil;
    local v115 = 0;
    local v116 = nil;

    for i, v in pairs(v4) do
        if i ~= "Studio" then
            if type(v) == "string" then
                v115 = v115 + 1;
                v116 = v;
            elseif type(v) == "table" then
                local v117 = false;
                local v118;

                if type(v.PlaceId) == "number" then
                    v118 = v.PlaceId == game.PlaceId;
                elseif type(v.PlaceIds) == "table" then
                    v118 = table.find(v.PlaceIds, game.PlaceId) ~= nil;
                elseif type(v.GameId) == "number" then
                    v118 = v.GameId == game.GameId;
                elseif type(v.GameIds) == "table" then
                    v118 = table.find(v.GameIds, game.GameId) ~= nil;
                else
                    v117 = true;
                    v118 = true;
                end;

                if not v117 then
                    assert(not v113, ("More than one LogConfig mapping matched (%s and %s)"):format(v114 or "", i or ""));
                end;

                if v118 then
                    if u2 then
                        local Server = v.Server;
                        local v119 = type(Server) == "string";
                        local v120 = type(Server);
                        assert(v119, ("LogConfig.%s.Server must be a string; got %s"):format(i, v120));
                        SetLogLevel(Server);
                        v114 = i;
                        v113 = true;
                    else
                        local Client = v.Client;
                        local v121 = type(Client) == "string";
                        local v122 = type(Client);
                        assert(v121, ("LogConfig.%s.Client must be a string; got %s"):format(i, v122));
                        SetLogLevel(Client);
                        v114 = i;
                        v113 = true;
                    end;
                end;
            else
                warn(("LogConfig.%s must be a table or a string; got %s"):format(i, (typeof(v))));
            end;
        end;
    end;

    if v115 > 1 then
        warn("Ambiguous default logging level");
    end;

    if v116 and not v113 then
        SetLogLevel(v116);
    end;
end;

local v123 = type(u5) == "number";
assert(v123, "LogLevel failed to be determined");

if u1 then
    local u124 = u2 and "LogLevel" or "LogLevelClient";
    workspace:GetAttributeChangedSignal(u124):Connect(function() -- Line: 880
        -- upvalues: SetLogLevel (copy), u124 (copy)
        SetLogLevel(workspace:GetAttribute(u124));
    end);
end;

return u70;