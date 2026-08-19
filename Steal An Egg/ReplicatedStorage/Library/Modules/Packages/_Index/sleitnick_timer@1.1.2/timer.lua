-- Decompiled with Potassium's decompiler.

local Signal = require(script.Parent.Signal);
local RunService = game:GetService("RunService");
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 73
    -- upvalues: u1 (copy), RunService (copy), Signal (copy)
    local v3 = type(p2) == "number";
    local v4 = "Argument #1 to Timer.new must be a number; got " .. type(p2);
    assert(v3, v4);
    local v5 = "Argument #1 to Timer.new must be greater or equal to 0; got " .. tostring(p2);
    assert(p2 >= 0, v5);
    local v6 = setmetatable({}, u1);
    v6._runHandle = nil;
    v6.Interval = p2;
    v6.UpdateSignal = RunService.Heartbeat;
    v6.TimeFunction = time;
    v6.AllowDrift = true;
    v6.Tick = Signal.new();

    return v6;
end;

function u1.Simple(u7, u8, p9, p10, p11) -- Line: 103
    -- upvalues: RunService (copy)
    local v12 = p10 or RunService.Heartbeat;
    local u13 = p11 or time;
    local u14 = u13() + u7;

    if p9 then
        task.defer(u8);
    end;

    return v12:Connect(function() -- Line: 116
        -- upvalues: u13 (copy), u14 (ref), u7 (copy), u8 (copy)
        local v15 = u13();

        if u14 <= v15 then
            u14 = v15 + u7;
            task.defer(u8);
        end;
    end);
end;

function u1.Is(p16) -- Line: 128
    -- upvalues: u1 (copy)
    local v17;

    if type(p16) == "table" then
        v17 = getmetatable(p16) == u1;
    else
        v17 = false;
    end;

    return v17;
end;

function u1._startTimer(u18) -- Line: 132
    local TimeFunction = u18.TimeFunction;
    local u19 = TimeFunction() + u18.Interval;
    u18._runHandle = u18.UpdateSignal:Connect(function() -- Line: 135
        -- upvalues: TimeFunction (copy), u19 (ref), u18 (copy)
        local v20 = TimeFunction();

        if u19 <= v20 then
            u19 = v20 + u18.Interval;
            u18.Tick:Fire();
        end;
    end);
end;

function u1._startTimerNoDrift(u21) -- Line: 144
    assert(u21.Interval > 0, "Interval must be greater than 0 when AllowDrift is set to false");
    local TimeFunction = u21.TimeFunction;
    local u22 = 1;
    local u23 = TimeFunction();
    local u24 = u23 + u21.Interval;
    u21._runHandle = u21.UpdateSignal:Connect(function() -- Line: 150
        -- upvalues: TimeFunction (copy), u24 (ref), u22 (ref), u23 (copy), u21 (copy)
        local v25 = TimeFunction();

        while u24 <= v25 do
            u22 = u22 + 1;
            u24 = u23 + u21.Interval * u22;
            u21.Tick:Fire();
        end;
    end);
end;

function u1.Start(p26) -- Line: 167
    if p26._runHandle then
        return;
    end;

    if p26.AllowDrift then
        p26:_startTimer();

        return;
    end;

    p26:_startTimerNoDrift();
end;

function u1.StartNow(p27) -- Line: 186
    if p27._runHandle then
        return;
    end;

    p27.Tick:Fire();
    p27:Start();
end;

function u1.Stop(p28) -- Line: 201
    if not p28._runHandle then
        return;
    end;

    p28._runHandle:Disconnect();
    p28._runHandle = nil;
end;

function u1.IsRunning(p29) -- Line: 218
    return p29._runHandle ~= nil;
end;

function u1.Destroy(p30) -- Line: 225
    p30.Tick:Destroy();
    p30:Stop();
end;

return u1;