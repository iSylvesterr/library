-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.Disconnect(p2) -- Line: 60
    p2._sequent:_disconnect(p2);
end;

local u3 = {};
u3.__index = u3;

function u3.new(p4) -- Line: 123
    -- upvalues: u3 (copy)
    return setmetatable({
        _firing = false,
        _queuedDisconnect = false,
        _firingThread = nil,
        _taskThread = nil,
        _connections = {},
        _cancellable = p4 and true or false
    }, u3);
end;

function u3.Fire(u5, p6) -- Line: 145
    assert(not u5._firing, "cannot fire while already firing");
    u5._firing = true;
    local u7 = false;
    local u9 = table.freeze({
        Value = p6,
        Cancellable = u5._cancellable,

        Cancel = function(p8) -- Line: 153, Name: Cancel
            -- upvalues: u5 (copy), u7 (ref)
            if u5._cancellable then
                u7 = true;

                return;
            end;

            warn("attempted to cancel non-cancellable event");
        end
    });
    local u10 = coroutine.running();
    u5._firingThread = u10;

    for _, v in u5._connections do
        if v.Connected then
            local u11 = nil;
            local u12 = nil;
            local v13 = task.spawn(function() -- Line: 171
                -- upvalues: u5 (copy), v (copy), u9 (copy), u10 (copy), u11 (ref), u12 (ref)
                u5._taskThread = coroutine.running();
                local success, result = pcall(function() -- Line: 174
                    -- upvalues: v (ref), u9 (ref)
                    v._callback(u9);
                end);
                u5._taskThread = nil;

                if coroutine.status(u10) == "suspended" then
                    task.spawn(u10, success, result);

                    return;
                end;

                u11 = success;
                u12 = result;
            end);

            if u11 == nil then
                local v14, v15 = coroutine.yield();
                u11 = v14;
                u12 = v15;
            end;

            u5._firingThread = nil;

            if not u11 then
                error(debug.traceback(v13, (tostring(u12))));
            end;

            if u7 then
                break;
            end;
        end;
    end;

    if u5._queuedDisconnect then
        u5._queuedDisconnect = false;

        for i = #u5._connections, 1, -1 do
            local v16 = u5._connections[i];

            if not v16.Connected then
                u5:_removeConnection(v16);
            end;
        end;
    end;

    u5._firing = false;
end;

function u3.IsFiring(p17) -- Line: 222
    return p17._firing;
end;

function u3.Connect(p18, p19, p20) -- Line: 234
    -- upvalues: u1 (copy)
    assert(not p18._firing, "cannot connect while firing");
    local v21 = setmetatable({
        Connected = true,
        _callback = p19,
        _priority = p20,
        _sequent = p18
    }, u1);
    local v22 = #p18._connections + 1;

    for i, v in p18._connections do
        if v._priority < p20 then
            v22 = i;
            break;
        end;
    end;

    table.insert(p18._connections, v22, v21);

    return v21;
end;

function u3.Once(p23, u24, p25) -- Line: 262
    local u26 = nil;
    u26 = p23:Connect(function(...) -- Line: 265
        -- upvalues: u26 (ref), u24 (copy)
        if not u26.Connected then
            return;
        end;

        u26:Disconnect();
        u24(...);
    end, p25);

    return u26;
end;

function u3.Cancel(u27) -- Line: 279
    if not u27._firing then
        return;
    end;

    if u27._taskThread == coroutine.running() then
        error("cannot cancel sequent from connected task", 2);
    end;

    if u27._taskThread then
        pcall(function() -- Line: 291
            -- upvalues: u27 (copy)
            task.cancel(u27._taskThread);
        end);
        u27._taskThread = nil;
    end;

    if u27._firingThread then
        local _firingThread = u27._firingThread;
        u27._firingThread = nil;
        task.spawn(_firingThread, true);
    end;
end;

function u3.Destroy(p28) -- Line: 308
    p28:Cancel();

    for _, v in p28._connections do
        v.Connected = false;
    end;
end;

function u3._disconnect(p29, p30) -- Line: 316
    if not p30.Connected then
        return;
    end;

    p30.Connected = false;

    if p29._firing then
        p29._queuedDisconnect = true;

        return;
    end;

    p29:_removeConnection(p30);
end;

function u3._removeConnection(p31, p32) -- Line: 330
    local v33 = table.find(p31._connections, p32);

    if v33 then
        table.remove(p31._connections, v33);
    end;
end;

return table.freeze({
    new = u3.new,
    Priority = {
        Highest = (1 / 0),
        High = 1000,
        Normal = 0,
        Low = -1000,
        Lowest = (-1 / 0)
    }
});