-- Decompiled with Potassium's decompiler.

require(script.Types);
local u1 = nil;

local function table_swapremove(p2, p3) -- Line: 14
    local _ = p2[p3];
    local v4 = p2[#p2];
    p2[p3] = v4;
    p2[#p2] = nil;

    return v4;
end;

local function acquireRunnerThreadAndCallEventHandler(p5, ...) -- Line: 24
    -- upvalues: u1 (ref)
    local v6 = u1;
    u1 = nil;
    p5(...);
    u1 = v6;
end;

local function runEventHandlerInFreeThread() -- Line: 31
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u7 = {};
u7.__index = u7;

function u7.Disconnect(p8) -- Line: 40
    if not p8.Connected then
        return;
    end;

    local _connections = p8._connections;
    local _pos = p8._pos;
    local _ = _connections[_pos];
    local v9 = _connections[#_connections];
    _connections[_pos] = v9;
    _connections[#_connections] = nil;
    v9._pos = p8._pos;
    p8.Connected = false;
end;

local u10 = {};
u10.__index = u10;

function u10.Destroy(p11) -- Line: 54
    p11:DisconnectAll();
    setmetatable(p11, nil);
    table.clear(p11);
end;

function u10.Connect(p12, p13) -- Line: 61
    -- upvalues: u7 (copy)
    local v14 = `Function expected, got {p13}`;
    assert(p13 ~= nil, v14);
    local Connections = p12.Connections;
    local v15 = setmetatable({
        Connected = true,
        _fn = p13,
        _pos = #Connections + 1,
        _connections = Connections
    }, u7);
    table.insert(Connections, v15);

    return v15;
end;

function u10.Once(p16, u17) -- Line: 79
    local v18 = `Function expected, got {u17}`;
    assert(u17 ~= nil, v18);
    local u19 = nil;
    u19 = p16:Connect(function(...) -- Line: 83
        -- upvalues: u19 (ref), u17 (copy)
        u19:Disconnect();
        u17(...);
    end);

    return u19;
end;

function u10.DisconnectAll(p20) -- Line: 92
    for _, v in p20.Connections do
        v.Connected = false;
    end;

    table.clear(p20.Connections);
end;

function u10.Fire(p21, ...) -- Line: 99
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    if #p21.Connections == 0 then
        return;
    end;

    for _, v in p21.Connections do
        if not u1 then
            u1 = task.spawn(runEventHandlerInFreeThread);
        end;

        task.spawn(u1, v._fn, ...);
    end;
end;

function u10.Wait(p22) -- Line: 112
    local u23 = coroutine.running();
    local u24 = nil;
    u24 = p22:Connect(function(...) -- Line: 116
        -- upvalues: u24 (ref), u23 (copy)
        u24:Disconnect();

        if coroutine.status(u23) ~= "suspended" then
            return;
        end;

        task.spawn(u23, ...);
    end);

    return coroutine.yield();
end;

return {
    new = function() -- Line: 130, Name: signal_new
        -- upvalues: u10 (copy)
        return setmetatable({
            Connections = {}
        }, u10);
    end
};