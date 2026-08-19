-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 4
    -- upvalues: u1 (copy)
    return setmetatable({
        _first = 0,
        _last = -1,
        _queue = {}
    }, u1);
end;

function u1.isEmpty(p2) -- Line: 12
    return p2._first > p2._last;
end;

function u1.enqueue(p3, p4) -- Line: 16
    local v5 = p3._last + 1;
    p3._last = v5;
    p3._queue[v5] = p4;
end;

function u1.dequeue(p6) -- Line: 22
    if p6:isEmpty() then
        error("Cannot dequeue from empty queue");
    end;

    local _first = p6._first;
    local v7 = p6._queue[_first];
    p6._queue[_first] = nil;
    p6._first = _first + 1;

    return v7;
end;

return u1;