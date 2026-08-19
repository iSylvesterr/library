-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 23
    -- upvalues: u1 (copy)
    return setmetatable({
        locked = false,
        counter = 0,
        waiters = {}
    }, u1);
end;

function u1.nextCounter(p2) -- Line: 31
    local counter = p2.counter;
    p2.counter = p2.counter + 1;

    return counter;
end;

function u1.getLock(p3) -- Line: 38
    return p3.lockHolder;
end;

function u1.tryLock(p4) -- Line: 42
    if p4.lockHolder then
        return nil;
    end;

    local v5 = p4:nextCounter();
    p4.lockHolder = v5;

    return v5;
end;

function u1.lock(p6) -- Line: 53
    local v7 = p6:tryLock();

    if v7 ~= nil then
        return v7;
    end;

    local v8 = coroutine.running();
    table.insert(p6.waiters, v8);

    return coroutine.yield();
end;

function u1.unlock(p9, p10) -- Line: 64
    -- upvalues: Asserts (copy)
    Asserts.number(p10);
    local v11 = p10 == p9.lockHolder;
    local v12 = `Attempt to unlock mutex with the wrong lockHolder: {p10}, current holder: {p9.lockHolder}`;
    assert(v11, v12);
    p9.lockHolder = nil;

    while #p9.waiters > 0 do
        local v13 = assert(table.remove(p9.waiters, 1));

        if coroutine.status(v13) == "suspended" then
            local v14 = p9:nextCounter();
            p9.lockHolder = v14;
            task.delay(0, v13, v14);

            return;
        end;
    end;
end;

function u1.wrun(p15, p16, ...) -- Line: 83
    local v17 = p15:lock();
    local u18 = nil;
    local u19 = nil;
    local v21 = table.pack(xpcall(p16, function(p20) -- Line: 88
        -- upvalues: u18 (ref), u19 (ref)
        u18 = tostring(p20);
        u19 = tostring(debug.traceback(nil, 3));
    end, ...));
    p15:unlock(v17);
    local v22 = v21[1];

    if v22 ~= true then
        error((`[Mutex] {tostring(u18)}\nStack Begin\n{tostring(u19)}Stack End`));
    end;

    return v22, table.unpack(v21, 2);
end;

function u1.run(p23, p24, ...) -- Line: 103
    local v25 = p23:lock();
    local u26 = nil;
    local u27 = nil;
    local v29 = table.pack(xpcall(p24, function(p28) -- Line: 108
        -- upvalues: u26 (ref), u27 (ref)
        u26 = tostring(p28);
        u27 = tostring(debug.traceback(nil, 3));
    end, ...));
    p23:unlock(v25);

    if v29[1] ~= true then
        error((`[Mutex] {tostring(u26)}\nStack Begin\n{tostring(u27)}Stack End`));
    end;

    return table.unpack(v29, 2);
end;

function u1.async(u30, u31, ...) -- Line: 121
    task.spawn(function(...) -- Line: 122
        -- upvalues: u30 (copy), u31 (copy)
        local v32 = u30:lock();
        local u33 = nil;
        local u34 = nil;
        local v36 = xpcall(u31, function(p35) -- Line: 127
            -- upvalues: u33 (ref), u34 (ref)
            u33 = tostring(p35);
            u34 = tostring(debug.traceback(nil, 3));
        end, ...);
        u30:unlock(v32);

        if v36 ~= true then
            error((`[Mutex] {tostring(u33)}\nStack Begin\n{tostring(u34)}Stack End`));
        end;
    end, ...);
end;

function u1.Destroy(p37) -- Line: 139
    if p37.lockHolder ~= nil then
        return;
    end;

    table.clear(p37);
    setmetatable(p37, nil);
end;

u1.destroy = u1.Destroy;

return u1;