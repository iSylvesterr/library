-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local BindToRenderStep = require(ReplicatedStorage.Library.Functions.BindToRenderStep);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
local u2 = 0;

function u1.Destroy(p3) -- Line: 31
    p3:Disconnect();
    table.clear(p3);
    setmetatable(p3, nil);
end;

function u1.Disconnect(p4) -- Line: 37
    local _bound = p4._bound;

    if _bound then
        p4._bound = nil;
        _bound();
    end;

    local _callbacks = p4._callbacks;

    if #_callbacks > 0 then
        p4._callbacks = {};

        for _, v in ipairs(_callbacks) do
            v();
        end;
    end;
end;

function u1.IsConnected(p5) -- Line: 53
    return p5._bound ~= nil;
end;

function u1.Then(p6, p7) -- Line: 57
    -- upvalues: Asserts (copy)
    Asserts.func(p7);

    if p6._bound then
        table.insert(p6._callbacks, p7);

        return p6;
    end;

    p7();

    return p6;
end;

function u1.Wait(p8) -- Line: 71
    while p8:IsConnected() do
        task.wait();
    end;
end;

function u1._Step(p9, p10) -- Line: 77
    local _t = p9._t;
    local _duration = p9._duration;
    local _timeUnrestricted = p9._timeUnrestricted;

    if not _timeUnrestricted then
        p10 = math.min(p10, _duration - _t);
    end;

    local v11 = _t + p10;

    if not _timeUnrestricted then
        v11 = math.min(v11, _duration);
    end;

    p9._t = v11;
    local v12;

    if p9._timeScaled and _duration ~= (1 / 0) then
        p10 = p10 / _duration;
        v12 = v11 / _duration;

        if not _timeUnrestricted then
            p10 = math.min(p10, 1 - v12);
            v12 = math.min(v12, 1);
        end;
    else
        v12 = v11;
    end;

    if p9._fn(p10, v12) or _duration <= v11 then
        p9:Disconnect();
    end;
end;

return function(p13, p14, p15, p16, p17) -- Line: 116
    -- upvalues: Asserts (copy), u2 (ref), u1 (copy), BindToRenderStep (copy)
    Asserts.func(p13);

    if p14 ~= nil then
        Asserts.number(p14);
        assert(p14 > 0, "Duration must be positive");
        assert(p14 == p14, "Duration must not be NaN");
    end;

    if p17 ~= nil then
        Asserts.number(p17);
        assert(p17 >= 0, "Priority must be positive");
        assert(p17 == p17, "Priority must not be NaN");
    end;

    u2 = u2 + 1;
    local v18 = {
        _t = 0,
        _connection = nil,
        _fn = p13,
        _duration = p14 or (1 / 0),
        _timeScaled = p15 == true,
        _timeUnrestricted = p16 == true,
        _key = ("__internal_rs_%d"):format(u2),
        _uid = u2,
        _priority = p17 or Enum.RenderPriority.Last.Value,
        _callbacks = {}
    };
    local u19 = setmetatable(v18, {
        __index = u1
    });
    u19._bound = BindToRenderStep(u19._key, u19._priority, function(p20) -- Line: 152
        -- upvalues: u19 (copy)
        u19:_Step(p20);
    end);

    return u19;
end;