-- Decompiled with Potassium's decompiler.

require(script.Parent.TypeDefinitions);
local TestService = game:GetService("TestService");
local Table = require(script.Parent.Table);
local u1 = {};
u1.__index = u1;
u1.__type = "Signal";
local u2 = {};
u2.__index = u2;
u2.__type = "SignalConnection";

function u1.new(p3) -- Line: 45
    -- upvalues: u1 (copy)
    return setmetatable({
        Name = p3,
        Connections = {},
        YieldingThreads = {}
    }, u1);
end;

local function NewConnection(p4, p5) -- Line: 54
    -- upvalues: u2 (copy)
    return setmetatable({
        Index = -1,
        Signal = p4,
        Delegate = p5
    }, u2);
end;

local function ThreadAndReportError(u6, u7, p8) -- Line: 63
    -- upvalues: TestService (copy)
    local v9 = coroutine.create(function() -- Line: 64
        -- upvalues: u6 (copy), u7 (copy)
        u6(unpack(u7));
    end);
    local v10, v11 = coroutine.resume(v9);

    if not v10 then
        TestService:Error(string.format("Exception thrown in your %s event handler: %s", p8, v11));
        TestService:Checkpoint(debug.traceback(v9));
    end;
end;

function u1.Connect(p12, p13) -- Line: 76
    -- upvalues: u1 (copy), u2 (copy), Table (copy)
    local v14 = getmetatable(p12) == u1;
    assert(v14, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Connect", "Signal.new()"));
    local v15 = setmetatable({
        Index = -1,
        Signal = p12,
        Delegate = p13
    }, u2);
    v15.Index = #p12.Connections + 1;
    Table.insert(p12.Connections, v15.Index, v15);

    return v15;
end;

function u1.Fire(p16, ...) -- Line: 84
    -- upvalues: u1 (copy), Table (copy), ThreadAndReportError (copy)
    local v17 = getmetatable(p16) == u1;
    assert(v17, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Fire", "Signal.new()"));
    local v18 = Table.pack(...);
    local Connections = p16.Connections;
    local YieldingThreads = p16.YieldingThreads;

    for i = 1, #Connections do
        local v19 = Connections[i];

        if v19.Delegate ~= nil then
            ThreadAndReportError(v19.Delegate, v18, v19.Signal.Name);
        end;
    end;

    for i = 1, #YieldingThreads do
        local v20 = YieldingThreads[i];

        if v20 ~= nil then
            coroutine.resume(v20, ...);
        end;
    end;
end;

function u1.FireSync(p21, ...) -- Line: 104
    -- upvalues: u1 (copy), Table (copy)
    local v22 = getmetatable(p21) == u1;
    assert(v22, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("FireSync", "Signal.new()"));
    local v23 = Table.pack(...);
    local Connections = p21.Connections;
    local YieldingThreads = p21.YieldingThreads;

    for i = 1, #Connections do
        local v24 = Connections[i];

        if v24.Delegate ~= nil then
            v24.Delegate(unpack(v23));
        end;
    end;

    for i = 1, #YieldingThreads do
        local v25 = YieldingThreads[i];

        if v25 ~= nil then
            coroutine.resume(v25, ...);
        end;
    end;
end;

function u1.Wait(p26) -- Line: 124
    -- upvalues: u1 (copy), Table (copy)
    local v27 = getmetatable(p26) == u1;
    assert(v27, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Wait", "Signal.new()"));
    local v28 = coroutine.running();
    Table.insert(p26.YieldingThreads, v28);
    local v29 = { coroutine.yield() };
    Table.removeObject(p26.YieldingThreads, v28);

    return unpack(v29);
end;

function u1.Dispose(p30) -- Line: 134
    -- upvalues: u1 (copy)
    local v31 = getmetatable(p30) == u1;
    assert(v31, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Dispose", "Signal.new()"));
    local Connections = p30.Connections;

    for i = 1, #Connections do
        Connections[i]:Disconnect();
    end;

    p30.Connections = {};
    setmetatable(p30, nil);
end;

function u2.Disconnect(p32) -- Line: 144
    -- upvalues: u2 (copy), Table (copy)
    local v33 = getmetatable(p32) == u2;
    assert(v33, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Disconnect", "private function NewConnection()"));
    Table.remove(p32.Signal.Connections, p32.Index);
    p32.SignalStatic = nil;
    p32.Delegate = nil;
    p32.YieldingThreads = {};
    p32.Index = -1;
    setmetatable(p32, nil);
end;

return u1;