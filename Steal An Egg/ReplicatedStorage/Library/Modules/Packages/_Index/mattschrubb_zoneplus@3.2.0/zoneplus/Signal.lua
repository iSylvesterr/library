-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function acquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 51
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function runEventHandlerInFreeThread(...) -- Line: 62
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...);

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u4 = {};
u4.__index = u4;

function u4.new(p5, p6) -- Line: 73
    -- upvalues: u4 (copy)
    return setmetatable({
        _connected = true,
        _next = false,
        _signal = p5,
        _fn = p6
    }, u4);
end;

function u4.Disconnect(p7) -- Line: 82
    assert(p7._connected, "Can\'t disconnect a connection twice.");
    p7._connected = false;
    local _signal = p7._signal;

    if _signal._handlerListHead == p7 then
        _signal._handlerListHead = p7._next;
    else
        local _handlerListHead = _signal._handlerListHead;

        while _handlerListHead and _handlerListHead._next ~= p7 do
            _handlerListHead = _handlerListHead._next;
        end;

        if _handlerListHead then
            _handlerListHead._next = p7._next;
        end;
    end;

    if _signal.connectionsChanged then
        _signal.totalConnections = _signal.totalConnections - 1;
        _signal.connectionsChanged:Fire(-1);
    end;
end;

u4.Destroy = u4.Disconnect;
setmetatable(u4, {
    __index = function(p8, p9) -- Line: 113, Name: __index
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p9))), 2);
    end,

    __newindex = function(p10, p11) -- Line: 116, Name: __newindex
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p11))), 2);
    end
});
local u12 = {};
u12.__index = u12;

function u12.new(p13) -- Line: 125
    -- upvalues: u12 (copy)
    local v14 = setmetatable({
        _handlerListHead = false
    }, u12);

    if p13 then
        v14.totalConnections = 0;
        v14.connectionsChanged = u12.new();
    end;

    return v14;
end;

function u12.Connect(p15, p16) -- Line: 136
    -- upvalues: u4 (copy)
    local v17 = u4.new(p15, p16);

    if p15._handlerListHead then
        v17._next = p15._handlerListHead;
        p15._handlerListHead = v17;
    else
        p15._handlerListHead = v17;
    end;

    if p15.connectionsChanged then
        p15.totalConnections = p15.totalConnections + 1;
        p15.connectionsChanged:Fire(1);
    end;

    return v17;
end;

function u12.DisconnectAll(p18) -- Line: 155
    p18._handlerListHead = false;

    if p18.connectionsChanged then
        p18.connectionsChanged:Fire(-p18.totalConnections);
        p18.connectionsChanged:Destroy();
        p18.connectionsChanged = nil;
        p18.totalConnections = 0;
    end;
end;

u12.Destroy = u12.DisconnectAll;
u12.destroy = u12.DisconnectAll;

function u12.Fire(p19, ...) -- Line: 173
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    local _handlerListHead = p19._handlerListHead;

    while _handlerListHead do
        if _handlerListHead._connected then
            if not u1 then
                u1 = coroutine.create(runEventHandlerInFreeThread);
            end;

            task.spawn(u1, _handlerListHead._fn, ...);
        end;

        _handlerListHead = _handlerListHead._next;
    end;
end;

function u12.Wait(p20) -- Line: 188
    local u21 = coroutine.running();
    local u22 = nil;
    u22 = p20:Connect(function(...) -- Line: 191
        -- upvalues: u22 (ref), u21 (copy)
        u22:Disconnect();
        task.spawn(u21, ...);
    end);

    return coroutine.yield();
end;

return u12;