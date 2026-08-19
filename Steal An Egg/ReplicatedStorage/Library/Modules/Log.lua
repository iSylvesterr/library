-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u1 = { "fatal", "error", "warn", "info", "debug", "trace" };
local v2 = {};

local function fallbackSentinel() -- Line: 64
end;

function v2.createDefaultCallback(p3) -- Line: 66
    -- upvalues: RunService (copy)
    local u4 = typeof(p3) == "string" and p3 or (typeof(p3) == "Instance" and (`{p3.Parent and (p3.Parent.Name or "?") or "?"}/{p3.Name}` or "UNKNOWN") or "UNKNOWN");

    local function setTraceBackIfNeeded(p5, p6) -- Line: 71
        if p5.level == "error" or p5.level == "fatal" then
            warn(debug.traceback(p6 or "Log faced fatal or error case!"));

            return true;
        end;
    end;

    return RunService:IsStudio() and function(p7) -- Line: 81
        -- upvalues: u4 (ref)
        local v8 = p7.level == "warn" and warn or print;
        local v9 = `[{u4}][{p7.level}] {p7.message}`;

        if p7.context then
            print("[Log_Pre_State]:(Context):", p7.context);
        end;

        local v10;

        if p7.level == "error" or p7.level == "fatal" then
            warn(debug.traceback(v9 or "Log faced fatal or error case!"));
            v10 = true;
        else
            v10 = nil;
        end;

        if v10 then
            return;
        end;

        v8(v9);
    end or function(p11) -- Line: 96
        -- upvalues: u4 (ref)
        local v12 = `[{u4}] {p11.message}`;

        if p11.level ~= "error" and p11.level ~= "fatal" then
            return;
        end;

        warn(debug.traceback(v12 or "Log faced fatal or error case!"));
    end;
end;

local u13 = {};
u13.__index = u13;

function u13.log(u14, u15, u16, p17) -- Line: 105
    -- upvalues: u1 (copy)
    if table.find(u1, u15) > table.find(u1, u14._level) then
        return;
    end;

    local u18 = table.clone(u14._context);

    if p17 then
        for i, v in p17 do
            u18[i] = v;
        end;
    end;

    local success, result = pcall(function() -- Line: 117
        -- upvalues: u14 (copy), u15 (copy), u16 (copy), u18 (copy)
        u14._logCallback({
            level = u15,
            message = u16,
            context = u18
        });
    end);

    if not success then
        warn((`Error logging message: {result}`));
    end;
end;

function u13.extend(p19, p20) -- Line: 130
    -- upvalues: u13 (copy)
    local v21 = table.clone(p19._context);

    for i, v in p20 do
        v21[i] = v;
    end;

    return setmetatable({
        _logCallback = p19._logCallback,
        _context = v21,
        _level = p19._level
    }, u13);
end;

function u13.setLevel(p22, p23) -- Line: 143
    -- upvalues: u1 (copy)
    if table.find(u1, p23) == nil then
        error("Invalid log level");
    end;

    p22._level = p23;

    return p22;
end;

function v2.createLogger(p24, p25) -- Line: 151
    -- upvalues: fallbackSentinel (copy), u13 (copy)
    local v26 = {
        _level = "info",
        _logCallback = typeof(p24) == "function" and p24 and p24 or fallbackSentinel,
        _context = p25 or {}
    };

    return setmetatable(v26, u13);
end;

return v2;