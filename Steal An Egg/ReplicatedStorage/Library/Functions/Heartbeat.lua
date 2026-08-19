-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local u11 = {
    Disconnect = function(p1) -- Line: 5, Name: Disconnect
        local _connection = p1._connection;

        if _connection then
            p1._connection = nil;
            _connection:Disconnect();
        end;

        local _callbacks = p1._callbacks;

        if #_callbacks > 0 then
            p1._callbacks = {};

            for _, v in ipairs(_callbacks) do
                v();
            end;
        end;
    end,

    IsConnected = function(p2) -- Line: 20, Name: IsConnected
        return p2._connection ~= nil;
    end,

    Then = function(p3, p4) -- Line: 24, Name: Then
        local v5 = type(p4) == "function";
        assert(v5);

        if p3._connection then
            table.insert(p3._callbacks, p4);

            return p3;
        end;

        p4();

        return p3;
    end,

    Wait = function(p6) -- Line: 34, Name: Wait
        while p6:IsConnected() do
            task.wait();
        end;
    end,

    _Step = function(p7, p8) -- Line: 40, Name: _Step
        local _t = p7._t;
        local _duration = p7._duration;
        local _timeUnrestricted = p7._timeUnrestricted;

        if not _timeUnrestricted then
            p8 = math.min(p8, _duration - _t);
        end;

        local v9 = _t + p8;

        if not _timeUnrestricted then
            v9 = math.min(v9, _duration);
        end;

        p7._t = v9;
        local v10;

        if p7._timeScaled and _duration ~= (1 / 0) then
            p8 = p8 / _duration;
            v10 = v9 / _duration;

            if not _timeUnrestricted then
                p8 = math.min(p8, 1 - v10);
                v10 = math.min(v10, 1);
            end;
        else
            v10 = v9;
        end;

        if p7._fn(p8, v10) or _duration <= v9 then
            p7:Disconnect();
        end;
    end
};

return function(p12, p13, p14, p15) -- Line: 74
    -- upvalues: u11 (copy), RunService (copy)
    local v16 = type(p12) == "function";
    assert(v16);

    if p13 ~= nil then
        local v17 = type(p13) == "number";
        assert(v17);
        assert(p13 > 0);
        assert(p13 == p13);
    end;

    local u18 = setmetatable({
        _t = 0,
        _connection = nil,
        _fn = p12,
        _duration = p13 or (1 / 0),
        _timeScaled = p14 == true,
        _timeUnrestricted = p15 == true,
        _callbacks = {}
    }, {
        __index = u11
    });
    u18._connection = RunService.Heartbeat:Connect(function(p19) -- Line: 90
        -- upvalues: u18 (copy)
        u18:_Step(p19);
    end);

    return u18;
end;