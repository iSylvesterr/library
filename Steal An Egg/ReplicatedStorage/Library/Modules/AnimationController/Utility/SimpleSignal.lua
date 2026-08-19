-- Decompiled with Potassium's decompiler.

require(script.Types);
local u1 = nil;

local function acquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 14
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function runEventHandlerInFreeThread() -- Line: 21
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local v4 = {};
local u5 = {
    __index = v4
};

function v4.Disconnect(p6) -- Line: 30
    local _signal = p6._signal;
    _signal._connections[p6] = nil;
    _signal._connectionCount = _signal._connectionCount - 1;
    setmetatable(p6, nil);
    table.clear(p6);
    p6.Connected = false;
end;

local function connection_new(p7, p8) -- Line: 42
    -- upvalues: u5 (copy)
    return setmetatable({
        Connected = true,
        _signal = p7,
        _fn = p8
    }, u5);
end;

local v9 = {};
local u10 = {
    __index = v9
};

function v9.Destroy(p11) -- Line: 54
    p11:DisconnectAll();
    setmetatable(p11, nil);
    table.clear(p11);
end;

function v9.Connect(p12, p13) -- Line: 61
    -- upvalues: u5 (copy)
    local v14 = setmetatable({
        Connected = true,
        _signal = p12,
        _fn = p13
    }, u5);
    p12._connections[v14] = true;
    p12._connectionCount = p12._connectionCount + 1;

    return v14;
end;

function v9.Once(p15, u16) -- Line: 70
    local u17 = nil;
    u17 = p15:Connect(function(...) -- Line: 72
        -- upvalues: u17 (ref), u16 (copy)
        u17:Disconnect();
        u16(...);
    end);

    return u17;
end;

function v9.DisconnectAll(p18) -- Line: 81
    for i in p18._connections do
        i:Disconnect();
    end;
end;

function v9.Fire(p19, ...) -- Line: 88
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    for i in p19._connections do
        if not u1 then
            u1 = coroutine.create(runEventHandlerInFreeThread);
            coroutine.resume(u1);
        end;

        task.spawn(u1, i._fn, ...);
    end;
end;

function v9.Wait(p20) -- Line: 99
    local u21 = coroutine.running();
    local u22 = nil;
    u22 = p20:Connect(function(...) -- Line: 103
        -- upvalues: u22 (ref), u21 (copy)
        u22:Disconnect();

        if coroutine.status(u21) ~= "suspended" then
            return;
        end;

        task.spawn(u21, ...);
    end);

    return coroutine.yield();
end;

return {
    new = function() -- Line: 117, Name: signal_new
        -- upvalues: u10 (copy)
        return setmetatable({
            _connectionCount = 0,
            _connections = {}
        }, u10);
    end
};