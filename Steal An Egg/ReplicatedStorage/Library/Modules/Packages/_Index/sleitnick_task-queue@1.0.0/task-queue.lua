-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 37
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3._queue = {};
    v3._flushing = false;
    v3._scheduled = nil;
    v3._onFlush = p2;

    return v3;
end;

function u1.Add(u4, p5) -- Line: 52
    table.insert(u4._queue, p5);

    if u4._scheduled == nil then
        u4._scheduled = task.defer(function() -- Line: 56
            -- upvalues: u4 (copy)
            u4._flushing = true;
            u4._onFlush(u4._queue);
            table.clear(u4._queue);
            u4._flushing = false;
            u4._scheduled = nil;
        end);
    end;
end;

function u1.Clear(p6) -- Line: 77
    if p6._flushing then
        return;
    end;

    if p6._scheduled ~= nil then
        task.cancel(p6._scheduled);
        p6._scheduled = nil;
    end;

    table.clear(p6._queue);
end;

function u1.Destroy(p7) -- Line: 93
    p7:Clear();
end;

return u1;