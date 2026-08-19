-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local Heartbeat = game:GetService("RunService").Heartbeat;
local u1 = {};
u1.__index = u1;
u1.ClassName = "Signal";
u1.totalConnections = 0;

function u1.new(p2) -- Line: 12
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);

    if p2 then
        v3.connectionsChanged = u1.new();
    end;

    v3.connections = {};
    v3.totalConnections = 0;
    v3.waiting = {};
    v3.totalWaiting = 0;

    return v3;
end;

function u1.Fire(p4, ...) -- Line: 30
    for _, v in pairs(p4.connections) do
        task.spawn(v.Handler, ...);
    end;

    if p4.totalWaiting > 0 then
        local v5 = table.pack(...);

        for i, _ in pairs(p4.waiting) do
            p4.waiting[i] = v5;
        end;
    end;
end;

u1.fire = u1.Fire;

function u1.Connect(u6, p7) -- Line: 44
    -- upvalues: HttpService (copy)
    if type(p7) ~= "function" then
        error(("connect(%s)"):format((typeof(p7))), 2);
    end;

    local u8 = HttpService:GenerateGUID(false);
    local u9 = {
        Connected = true,
        ConnectionId = u8,
        Handler = p7
    };
    u6.connections[u8] = u9;

    function u9.Disconnect(p10) -- Line: 57
        -- upvalues: u6 (copy), u8 (copy), u9 (copy)
        u6.connections[u8] = nil;
        u9.Connected = false;
        local v11 = u6;
        v11.totalConnections = v11.totalConnections - 1;

        if u6.connectionsChanged then
            u6.connectionsChanged:Fire(-1);
        end;
    end;

    u9.Destroy = u9.Disconnect;
    u9.destroy = u9.Disconnect;
    u9.disconnect = u9.Disconnect;
    u6.totalConnections = u6.totalConnections + 1;

    if u6.connectionsChanged then
        u6.connectionsChanged:Fire(1);
    end;

    return u9;
end;

u1.connect = u1.Connect;

function u1.Wait(p12) -- Line: 77
    -- upvalues: HttpService (copy), Heartbeat (copy)
    local v13 = HttpService:GenerateGUID(false);
    p12.waiting[v13] = true;
    p12.totalWaiting = p12.totalWaiting + 1;

    repeat
        Heartbeat:Wait();
    until p12.waiting[v13] ~= true;

    p12.totalWaiting = p12.totalWaiting - 1;
    local v14 = p12.waiting[v13];
    p12.waiting[v13] = nil;

    return unpack(v14);
end;

u1.wait = u1.Wait;

function u1.Destroy(p15) -- Line: 89
    if p15.bindableEvent then
        p15.bindableEvent:Destroy();
        p15.bindableEvent = nil;
    end;

    if p15.connectionsChanged then
        p15.connectionsChanged:Fire(-p15.totalConnections);
        p15.connectionsChanged:Destroy();
        p15.connectionsChanged = nil;
    end;

    p15.totalConnections = 0;

    for i, _ in pairs(p15.connections) do
        p15.connections[i] = nil;
    end;
end;

u1.destroy = u1.Destroy;
u1.Disconnect = u1.Destroy;
u1.disconnect = u1.Destroy;

return u1;