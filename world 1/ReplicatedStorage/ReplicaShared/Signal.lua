-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function AcquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 42
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function RunEventHandlerInFreeThread(...) -- Line: 50
    -- upvalues: AcquireRunnerThreadAndCallEventHandler (copy)
    AcquireRunnerThreadAndCallEventHandler(...);

    while true do
        AcquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local u4 = {};
u4.__index = u4;
local u5 = {};
u5.__index = u5;

function u4.Disconnect(p6) -- Line: 77
    if p6.IsConnected == false then
        return;
    end;

    local signal = p6.signal;
    p6.IsConnected = false;

    if signal.head == p6 then
        signal.head = p6.next;

        return;
    end;

    local head = signal.head;

    while head ~= nil and head.next ~= p6 do
        head = head.next;
    end;

    if head ~= nil then
        head.next = p6.next;
    end;
end;

function u5.New() -- Line: 100
    -- upvalues: u5 (copy)
    local v7 = {
        head = nil
    };
    setmetatable(v7, u5);

    return v7;
end;

function u5.Connect(p8, p9) -- Line: 111
    -- upvalues: u4 (copy)
    if type(p9) ~= "function" then
        error((`[{script.Name}]: "listener" must be a function; Received {typeof(p9)}`));
    end;

    local v10 = {
        IsConnected = true,
        listener = p9,
        signal = p8,
        next = p8.head
    };
    setmetatable(v10, u4);
    p8.head = v10;

    return v10;
end;

function u5.Fire(p11, ...) -- Line: 131
    -- upvalues: u1 (ref), RunEventHandlerInFreeThread (copy)
    local head = p11.head;

    while head ~= nil do
        if head.IsConnected == true then
            if not u1 then
                u1 = coroutine.create(RunEventHandlerInFreeThread);
            end;

            task.spawn(u1, head.listener, ...);
        end;

        head = head.next;
    end;
end;

function u5.Wait(p12) -- Line: 144
    local u13 = coroutine.running();
    local u14 = nil;
    u14 = p12:Connect(function(...) -- Line: 147
        -- upvalues: u14 (ref), u13 (copy)
        u14:Disconnect();
        task.spawn(u13, ...);
    end);

    return coroutine.yield();
end;

function u5.FireUntil(p15, u16, ...) -- Line: 154
    if type(u16) ~= "function" then
        error((`[{script.Name}]: "continue_callback" must be a function; Received {typeof(u16)}`));
    end;

    local u17 = table.pack(...);
    local head = p15.head;
    local u18 = {};

    while head ~= nil do
        table.insert(u18, head);
        head = head.next;
    end;

    task.spawn(function() -- Line: 169
        -- upvalues: u18 (copy), u17 (copy), u16 (copy)
        for _, v in ipairs(u18) do
            if v.IsConnected == true then
                v.listener(table.unpack(u17));

                if u16() ~= true then
                    return;
                end;
            end;
        end;
    end);
end;

return table.freeze({
    New = u5.New
});