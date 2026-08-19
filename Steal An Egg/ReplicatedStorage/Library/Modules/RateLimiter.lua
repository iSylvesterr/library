-- Decompiled with Potassium's decompiler.

local Asserts = require(game.ReplicatedStorage.Library.Asserts);
local DebugGetCallerName = require(game.ReplicatedStorage.Library.Functions.DebugGetCallerName);
local u1 = require(game.ReplicatedStorage.Library.Modules.Packages.Log).new():AtWarning():Wrap();
local u2 = {
    DefaultBanLength = 60,
    DefaultWarn = true,
    Message = {
        STANDARD_ERROR = "You\'re doing that too fast!",
        TEMP_BANNED = "You\'re on cooldown. Please try again later.",
        GARBAGE_COLLECTED = "Endpoint not permitted."
    },
    LogTemplates = {
        BAN = "[RATE LIMIT][%*] (%*): %*, %*: (%*)"
    }
};
local u3 = {};

local function loadEndpoint(p4, p5) -- Line: 103
    assert(p5.MaximumTokens, "MaximumTokens must be provided");

    if p5.InitialTokens then
        assert(p5.InitialTokens <= p5.MaximumTokens, "InitialTokens must be less than or equal to MaximumTokens");
    end;

    local v6 = {};

    if p5.Refresh then
        for _, v in ipairs(p5.Refresh) do
            assert(v.Tokens > 0, "Tokens must be greater than 0");
            assert(v.Interval > 0, "Interval must be greater than 0");
            table.insert(v6, {
                tokens = v.Tokens,
                interval = v.Interval
            });
        end;
    end;

    table.freeze(v6);

    return {
        timestamps = {},
        tokens = {},
        refresh = {},
        refreshConfig = v6,
        initialTokens = p5.InitialTokens or p5.MaximumTokens,
        maxTokens = p5.MaximumTokens,
        causesBan = p5.Ban == true,
        name = p4
    };
end;

local function tryEndpoint(p7, p8, p9) -- Line: 137
    local v10 = workspace:GetServerTimeNow();

    if not p9.timestamps[p8] then
        p9.timestamps[p8] = v10;
    end;

    if not p9.tokens[p8] then
        p9.tokens[p8] = p9.initialTokens;
    end;

    if not p9.refresh[p8] then
        local v11 = {};

        for _, v in ipairs(p9.refreshConfig) do
            table.insert(v11, {
                credit = 0,
                tokens = v.tokens,
                interval = v.interval
            });
        end;

        p9.refresh[p8] = v11;
    end;

    local v12 = p9.refresh[p8];
    local v13 = p9.tokens[p8];
    local v14 = math.max(v10 - p9.timestamps[p8], 0);
    local v15 = 0;

    if p9.refresh then
        for _, v in ipairs(v12) do
            local v16 = math.min(v.credit + v14, p9.maxTokens / (v.tokens / v.interval));
            local v17 = math.floor(v16 / v.interval);

            if v17 <= 0 then
                v.credit = v16;
            else
                v15 = v15 + v17 * v.tokens;
                v.credit = math.fmod(v16, v17 * v.interval);
            end;
        end;
    end;

    local v18 = v13 + v15 >= 1;
    local v19 = math.min(v13 + v15, p9.maxTokens);

    if v18 then
        v19 = v19 - 1;
    end;

    p9.tokens[p8] = math.clamp(v19, -1, p9.maxTokens);
    p9.timestamps[p8] = v10;

    if v18 then
        return true;
    end;

    if v18 and p7._warn then
        warn(string.format(p7._logTemplate, "ENDPOINT_EXHAUSTED", p8.Name, p8.UserId, p9.name));
    end;

    if p9.causesBan then
        p7:ApplyBan(p8);
    end;

    return false;
end;

local function track(u20, u21) -- Line: 206
    if not u20._tracked[u21] then
        u20._tracked[u21] = true;
        u21.Destroying:Connect(function() -- Line: 209
            -- upvalues: u20 (copy), u21 (copy)
            u20:Reset(u21);
            u20._tracked[u21] = nil;
        end);
    end;
end;

local function ensureEndpoint(p22, p23) -- Line: 216
    -- upvalues: Asserts (copy)
    Asserts.optional.string(p23);

    if not p23 then
        return;
    end;

    assert(p22._endpoints[p23] and p23 ~= "Global", string.format("Endpoint \'%s\' was provided but does not exist", p23));
end;

function u3.ApplyBan(p24, p25, p26) -- Line: 229
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Player(p25);
    Asserts.optional.number(p26);
    local v27 = p26 or p24._banLength;
    local v28 = p24._bans[p25] ~= nil;
    local v29 = workspace:GetServerTimeNow() + v27;

    if v28 then
        v29 = math.max(v29, p24._bans[p25]);
    end;

    p24._bans[p25] = v29;

    if not p24._warn or v28 then
        return;
    end;

    u1(string.format(p24._logTemplate, "BAN", p25.Name, p25.UserId, "Banned!"));
end;

function u3.RemoveBan(p30, p31) -- Line: 249
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Player(p31);

    if not p30._bans[p31] then
        return false, u1(string.format(p30._logTemplate, "BAN", p31.Name, p31.UserId, "Attempt to unban a never banned player!"));
    end;

    p30._bans[p31] = nil;

    return true;
end;

function u3.IsBanned(p32, p33) -- Line: 269
    -- upvalues: Asserts (copy)
    Asserts.Player(p33);

    if not p32._bans[p33] then
        return false;
    end;

    if p32._bans[p33] >= workspace:GetServerTimeNow() then
        return true;
    end;

    p32._bans[p33] = nil;

    return false;
end;

function u3.Reset(p34, p35) -- Line: 284
    local v36 = p35 and { p35 } or game.Players:GetPlayers();

    for _, v in ipairs(v36) do
        p34._bans[v] = nil;

        for _, v2 in pairs(p34._endpoints) do
            v2.timestamps[v] = nil;
            v2.tokens[v] = nil;
            v2.refresh[v] = nil;
        end;
    end;
end;

function u3.Limit(u37, u38, p39) -- Line: 297
    -- upvalues: Asserts (copy), u2 (copy), tryEndpoint (copy)
    Asserts.Player(u38);
    Asserts.optional.string(p39);

    if p39 then
        assert(u37._endpoints[p39] and p39 ~= "Global", string.format("Endpoint \'%s\' was provided but does not exist", p39));
    end;

    if not (u37._tracked[u38] or u37._tracked[u38]) then
        u37._tracked[u38] = true;
        u38.Destroying:Connect(function() -- Line: 209
            -- upvalues: u37 (copy), u38 (copy)
            u37:Reset(u38);
            u37._tracked[u38] = nil;
        end);
    end;

    if u37._destroyed then
        return false, u2.Message.GARBAGE_COLLECTED;
    end;

    if u37:IsBanned(u38) then
        return false, u2.Message.TEMP_BANNED;
    end;

    if p39 and not tryEndpoint(u37, u38, u37._endpoints[p39]) then
        return false, u2.Message.STANDARD_ERROR;
    end;

    if u37._endpoints.Global and not tryEndpoint(u37, u38, u37._endpoints.Global) then
        return false, u2.Message.STANDARD_ERROR;
    end;

    return true;
end;

function u2.new(p40) -- Line: 325
    -- upvalues: Asserts (copy), loadEndpoint (copy), u2 (copy), DebugGetCallerName (copy), u3 (copy)
    Asserts.table(p40);
    Asserts.optional.number(p40.BanLength);
    assert(p40.Global or p40.Endpoints, "At least one endpoint must be provided");
    local v41 = {};

    if p40.Global then
        v41.Global = loadEndpoint("Global", p40.Global);
    end;

    if p40.Endpoints then
        for i, v in pairs(p40.Endpoints) do
            assert(i ~= "Global", "Global endpoint cannot be overridden");
            v41[i] = loadEndpoint(i, v);
        end;
    end;

    local v42 = next(v41) ~= nil;
    assert(v42, "No endpoints were provided");
    local DefaultWarn = u2.DefaultWarn;

    if p40.Warn ~= nil then
        DefaultWarn = p40.Warn;
    end;

    local v43 = p40.Id or DebugGetCallerName();
    local v44 = {
        _destroyed = false,
        _id = v43,
        _logTemplate = string.format(u2.LogTemplates.BAN, "%*", v43, "%*", "%*", "%*"),
        _warn = DefaultWarn,
        _endpoints = v41,
        _bans = {},
        _banLength = p40.BanLength or u2.DefaultBanLength,
        _tracked = {}
    };

    return setmetatable(v44, {
        __index = u3
    });
end;

function u2.AllowOnce() -- Line: 362
    -- upvalues: u2 (copy)
    return u2.new({
        BanLength = (1 / 0),
        Global = {
            MaximumTokens = 1
        }
    });
end;

function u2.AllowPerSecond(p45, p46) -- Line: 371
    -- upvalues: Asserts (copy), u2 (copy)
    assert(p45 > 0, "Rate must be positive");
    Asserts.optional.number(p46);

    return u2.new({
        BanLength = u2.DefaultBanLength,
        Global = {
            Ban = false,
            MaximumTokens = p46 or 1,
            Refresh = {
                {
                    Tokens = 1,
                    Interval = 1 / p45
                }
            }
        }
    });
end;

return u2;