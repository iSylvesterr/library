-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
u1.Errors = {
    Stopped = "Stopped",
    Timeout = "Timeout"
};

function u1._new(u2, p3, ...) -- Line: 54
    -- upvalues: u1 (copy)
    local u4 = setmetatable({
        _completed = false,
        _res = nil,
        _err = nil,
        _thread = nil,
        _awaitingThreads = {}
    }, u1);
    u4._thread = p3(function(...) -- Line: 63
        -- upvalues: u2 (copy), u4 (copy)
        local v5 = table.pack(pcall(u2, ...));
        u4._completed = true;
        local v6;

        if v5[1] then
            v6 = nil;
        else
            v6 = v5[2];
        end;

        u4._err = v6;

        if u4._err ~= nil then
            for _, v in ipairs(u4._awaitingThreads) do
                task.spawn(v, u4._err);
            end;

            return;
        end;

        local v7 = table.move(v5, 2, #v5, 1, table.create(#v5 - 1));
        u4._res = v7;

        for _, v in ipairs(u4._awaitingThreads) do
            task.spawn(v, nil, table.unpack(v7, 1, v7.n));
        end;
    end, ...);

    return u4;
end;

function u1.spawn(p8, ...) -- Line: 100
    -- upvalues: u1 (copy)
    if type(p8) ~= "function" then
        error("Concur.spawn argument must be a function; got " .. type(p8), 2);
    end;

    return u1._new(p8, task.spawn, ...);
end;

function u1.defer(p9, ...) -- Line: 110
    -- upvalues: u1 (copy)
    if type(p9) ~= "function" then
        error("Concur.defer argument must be a function; got " .. type(p9), 2);
    end;

    return u1._new(p9, task.defer, ...);
end;

function u1.delay(u10, p11, ...) -- Line: 120
    -- upvalues: u1 (copy)
    if type(p11) ~= "function" then
        error("Concur.delay argument must be a function; got " .. type(p11), 2);
    end;

    return u1._new(p11, function(...) -- Line: 124
        -- upvalues: u10 (copy)
        return task.delay(u10, ...);
    end, ...);
end;

function u1.value(u12) -- Line: 139
    -- upvalues: u1 (copy)
    return u1.spawn(function() -- Line: 140
        -- upvalues: u12 (copy)
        return u12;
    end);
end;

function u1.event(p13, u14) -- Line: 163
    -- upvalues: u1 (copy)
    local u15 = nil;
    local u16 = nil;
    u15 = p13:Connect(function(...) -- Line: 166
        -- upvalues: u16 (ref), u14 (copy), u15 (ref)
        if not u16 then
            return;
        end;

        if u14 == nil or u14(...) then
            u15:Disconnect();
            task.spawn(u16, ...);
        end;
    end);
    local v17 = u1.spawn(function() -- Line: 176
        -- upvalues: u16 (ref)
        u16 = coroutine.running();

        return coroutine.yield();
    end);
    v17:OnCompleted(function(p18) -- Line: 181
        -- upvalues: u15 (ref), u16 (ref)
        u15:Disconnect();

        if coroutine.status(u16) == "suspended" then
            task.spawn(u16, p18);
        end;
    end);

    return v17;
end;

function u1.all(u19) -- Line: 215
    -- upvalues: u1 (copy)
    if #u19 == 0 then
        return u1.value(nil);
    end;

    return u1.spawn(function() -- Line: 220
        -- upvalues: u19 (copy)
        local u20 = #u19;
        local u21 = coroutine.running();
        local u22 = table.create(u20);
        local u23 = 0;

        for i, v in ipairs(u19) do
            v:OnCompleted(function(...) -- Line: 226
                -- upvalues: u22 (copy), i (copy), u23 (ref), u20 (copy), u21 (copy)
                u22[i] = table.pack(...);
                u23 = u23 + 1;

                if u20 <= u23 and coroutine.status(u21) == "suspended" then
                    task.spawn(u21);
                end;
            end);
        end;

        if u23 < u20 then
            coroutine.yield();
        end;

        return u22;
    end);
end;

function u1.first(u24) -- Line: 259
    -- upvalues: u1 (copy)
    if #u24 == 0 then
        return u1.value(nil);
    end;

    return u1.spawn(function() -- Line: 264
        -- upvalues: u24 (copy)
        local u25 = coroutine.running();
        local u26 = nil;
        local u27 = nil;

        for _, v in ipairs(u24) do
            v:OnCompleted(function(p28, ...) -- Line: 269
                -- upvalues: u26 (ref), u27 (ref), v (copy), u25 (copy)
                if u26 or p28 ~= nil then
                    return;
                end;

                u27 = v;
                u26 = table.pack(...);

                if coroutine.status(u25) == "suspended" then
                    task.spawn(u25);
                end;
            end);
        end;

        if u26 == nil then
            coroutine.yield();
        end;

        for _, v in ipairs(u24) do
            if v ~= u27 then
                v:Stop();
            end;
        end;

        return table.unpack(u26, 1, u26.n);
    end);
end;

function u1.Stop(p29) -- Line: 310
    -- upvalues: u1 (copy)
    if p29._completed then
        return;
    end;

    p29._completed = true;
    p29._err = u1.Errors.Stopped;
    task.cancel(p29._thread);

    for _, v in ipairs(p29._awaitingThreads) do
        task.spawn(v, u1.Errors.Stopped);
    end;
end;

function u1.IsCompleted(p30) -- Line: 325
    return p30._completed;
end;

function u1.Await(u31, p32) -- Line: 402
    -- upvalues: u1 (copy)
    if u31._completed then
        if u31._err ~= nil then
            return u31._err;
        end;

        local v33 = nil;

        if u31._res == nil then
            return v33, nil;
        end;

        return v33, table.unpack(u31._res, 1, u31._res.n);
    end;

    local u34 = coroutine.running();
    table.insert(u31._awaitingThreads, u34);

    if not p32 then
        return coroutine.yield();
    end;

    local v36 = task.delay(p32, function() -- Line: 415
        -- upvalues: u31 (copy), u34 (copy), u1 (ref)
        local v35 = table.find(u31._awaitingThreads, u34);

        if v35 then
            table.remove(u31._awaitingThreads, v35);
            task.spawn(u34, u1.Errors.Timeout);
        end;
    end);
    local v37 = table.pack(coroutine.yield());

    if coroutine.status(v36) ~= "normal" then
        task.cancel(v36);
    end;

    return table.unpack(v37, 1, v37.n);
end;

function u1.OnCompleted(u38, u39, u40) -- Line: 517
    local u41 = task.spawn(function() -- Line: 518
        -- upvalues: u39 (copy), u38 (copy), u40 (copy)
        u39(u38:Await(u40));
    end);

    return function() -- Line: 523
        -- upvalues: u41 (copy), u38 (copy)
        task.cancel(u41);
        local v42 = table.find(u38._awaitingThreads, u41);

        if v42 then
            table.remove(u38._awaitingThreads, v42);
        end;
    end;
end;

return u1;