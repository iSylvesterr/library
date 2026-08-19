-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local Signal = require(script.Parent.Signal);
local u1 = {};

function u1.new(p2, p3) -- Line: 28
    -- upvalues: u1 (copy), Signal (copy), RunService (copy)
    local u4 = setmetatable({}, {
        __index = u1
    });
    u4.TimeOut = p2;
    u4.Callback = p3;
    u4.TimeElapsed = 0;
    u4.Elapsed = Signal.new();
    u4.Elapsed:Connect(p3);
    u4.HeartbeatConnection = RunService.Heartbeat:Connect(function(p5) -- Line: 40
        -- upvalues: u4 (copy)
        u4:_Interval(p5);
    end);

    return u4;
end;

function u1._Interval(p6, p7) -- Line: 47
    p6.TimeElapsed = p6.TimeElapsed + p7;

    if p6.TimeElapsed >= p6.TimeOut * 10 then
        p6.TimeElapsed = p6.TimeElapsed - math.floor(p6.TimeElapsed / p6.TimeOut) * p6.TimeOut;

        return;
    end;

    if p6.TimeElapsed >= p6.TimeOut then
        p6.TimeElapsed = p6.TimeElapsed - p6.TimeOut;
        p6.Elapsed:Fire();
    end;
end;

function u1.On(u8) -- Line: 69
    -- upvalues: RunService (copy)
    if u8.HeartbeatConnection and u8.HeartbeatConnection.Connected then
        return;
    end;

    u8.HeartbeatConnection = RunService.Heartbeat:Connect(function(p9) -- Line: 76
        -- upvalues: u8 (copy)
        u8:_Interval(p9);
    end);
end;

function u1.Off(p10) -- Line: 81
    if not p10.HeartbeatConnection then
        return;
    end;

    p10.HeartbeatConnection:Disconnect();
end;

function u1.Destroy(p11) -- Line: 91
    p11:Off();
    p11.Elapsed:Destroy();
    table.clear(p11);
end;

return u1;