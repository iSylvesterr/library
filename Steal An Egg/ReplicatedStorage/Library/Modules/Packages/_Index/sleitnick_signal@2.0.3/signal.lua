-- Decompiled with Potassium's decompiler.

local u1 = nil;
local Asserts = require(game:GetService("ReplicatedStorage").Library.Asserts);

local function acquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 47
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function runEventHandlerInFreeThread(...) -- Line: 58
    -- upvalues: acquireRunnerThreadAndCallEventHandler (copy)
    acquireRunnerThreadAndCallEventHandler(...);

    while true do
        acquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local function getOrCreateReusableRunnerThread(...) -- Line: 65
    -- upvalues: u1 (ref), runEventHandlerInFreeThread (copy)
    if not u1 then
        u1 = coroutine.create(runEventHandlerInFreeThread);
    end;

    task.spawn(u1, ...);
end;

local u4 = {};
u4.__index = u4;

function u4.Disconnect(p5) -- Line: 91
    if not p5.Connected then
        return;
    end;

    p5.Connected = false;

    if p5._signal._handlerListHead == p5 then
        p5._signal._handlerListHead = p5._next;

        return;
    end;

    local _handlerListHead = p5._signal._handlerListHead;

    while _handlerListHead and _handlerListHead._next ~= p5 do
        _handlerListHead = _handlerListHead._next;
    end;

    if _handlerListHead then
        _handlerListHead._next = p5._next;
    end;
end;

u4.Destroy = u4.Disconnect;
setmetatable(u4, {
    __index = function(p6, p7) -- Line: 118, Name: __index
        error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p7))), 2);
    end,

    __newindex = function(p8, p9, p10) -- Line: 121, Name: __newindex
        error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p9))), 2);
    end
});
local u11 = {};
u11.__index = u11;

function u11._deployStickyBehavior(p12, p13) -- Line: 158
    -- upvalues: getOrCreateReusableRunnerThread (copy)
    local v14 = rawget(p12, "_stickyBehavior");

    if not v14 then
        return;
    end;

    getOrCreateReusableRunnerThread(v14, p13);
end;

function u11.new(p15) -- Line: 172
    -- upvalues: Asserts (copy), u11 (copy)
    Asserts.optional.func(p15);

    return setmetatable({
        _handlerListHead = false,
        _proxyHandler = nil,
        _yieldedThreads = nil,
        _stickyBehavior = p15
    }, u11);
end;

function u11.Wrap(p16) -- Line: 198
    -- upvalues: u11 (copy)
    local v17 = typeof(p16) == "RBXScriptSignal";
    local v18 = "Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(p16);
    assert(v17, v18);
    local u19 = u11.new();
    u19._proxyHandler = p16:Connect(function(...) -- Line: 205
        -- upvalues: u19 (copy)
        u19:Fire(...);
    end);

    return u19;
end;

function u11.Is(p20) -- Line: 218
    -- upvalues: u11 (copy)
    local v21;

    if type(p20) == "table" then
        v21 = getmetatable(p20) == u11;
    else
        v21 = false;
    end;

    return v21;
end;

function u11.Connect(p22, p23) -- Line: 235
    -- upvalues: u4 (copy)
    local v24 = setmetatable({
        Connected = true,
        _next = false,
        _signal = p22,
        _fn = p23
    }, u4);

    if p22._handlerListHead then
        v24._next = p22._handlerListHead;
        p22._handlerListHead = v24;
    else
        p22._handlerListHead = v24;
    end;

    p22:_deployStickyBehavior(p23);

    return v24;
end;

function u11.ConnectOnce(p25, p26) -- Line: 259
    return p25:Once(p26);
end;

function u11.Once(p27, u28) -- Line: 278
    local u29 = nil;
    local u30 = false;
    u29 = p27:Connect(function(...) -- Line: 282
        -- upvalues: u30 (ref), u29 (ref), u28 (copy)
        if u30 then
            return;
        end;

        u30 = true;
        u29:Disconnect();
        u28(...);
    end);

    return u29;
end;

function u11.GetConnections(p31) -- Line: 295
    local _handlerListHead = p31._handlerListHead;
    local v32 = {};

    while _handlerListHead do
        table.insert(v32, _handlerListHead);
        _handlerListHead = _handlerListHead._next;
    end;

    return v32;
end;

function u11.DisconnectAll(p33) -- Line: 315
    local _handlerListHead = p33._handlerListHead;

    while _handlerListHead do
        _handlerListHead.Connected = false;
        _handlerListHead = _handlerListHead._next;
    end;

    p33._handlerListHead = false;
    local v34 = rawget(p33, "_yieldedThreads");

    if v34 then
        for i in v34 do
            if coroutine.status(i) == "suspended" then
                warn(debug.traceback(i, "signal disconnected; yielded thread cancelled", 2));
                task.cancel(i);
            end;
        end;

        table.clear(p33._yieldedThreads);
    end;
end;

function u11.Fire(p35, ...) -- Line: 350
    -- upvalues: getOrCreateReusableRunnerThread (copy)
    local _handlerListHead = p35._handlerListHead;

    while _handlerListHead do
        if _handlerListHead.Connected then
            getOrCreateReusableRunnerThread(_handlerListHead._fn, ...);
        end;

        _handlerListHead = _handlerListHead._next;
    end;
end;

function u11.FireDeferred(p36, ...) -- Line: 368
    local _handlerListHead = p36._handlerListHead;

    while _handlerListHead do
        task.defer(function(...) -- Line: 372
            -- upvalues: _handlerListHead (copy)
            if _handlerListHead.Connected then
                _handlerListHead._fn(...);
            end;
        end, ...);
        _handlerListHead = _handlerListHead._next;
    end;
end;

function u11.Wait(p37) -- Line: 396
    local u38 = rawget(p37, "_yieldedThreads");

    if not u38 then
        u38 = {};
        rawset(p37, "_yieldedThreads", u38);
    end;

    local u39 = coroutine.running();
    u38[u39] = true;
    p37:Once(function(...) -- Line: 406
        -- upvalues: u38 (ref), u39 (copy)
        u38[u39] = nil;

        if coroutine.status(u39) == "suspended" then
            task.spawn(u39, ...);
        end;
    end);

    return coroutine.yield();
end;

function u11.Destroy(p40, p41) -- Line: 429
    p40:DisconnectAll();
    local v42 = rawget(p40, "_proxyHandler");

    if v42 then
        v42:Disconnect();
    end;

    if not p41 then
        return;
    end;

    setmetatable(p40, nil);
    table.clear(p40);
end;

setmetatable(u11, {
    __index = function(p43, p44) -- Line: 446, Name: __index
        error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p44))), 2);
    end,

    __newindex = function(p45, p46, p47) -- Line: 449, Name: __newindex
        error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p46))), 2);
    end
});

return table.freeze({
    new = u11.new,
    Wrap = u11.Wrap,
    Is = u11.Is
});