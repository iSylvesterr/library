-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Signal = require(script.Parent.Parent.Parent.Signal);
require(script.Parent.Parent.Types);
local u1 = {};
u1.__index = u1;

function u1.new(p2, p3, p4, u5, p6) -- Line: 27
    -- upvalues: u1 (copy), Signal (copy)
    local u7 = setmetatable({}, u1);
    local v8;

    if p4 == true then
        v8 = Instance.new("UnreliableRemoteEvent");
    else
        v8 = Instance.new("RemoteEvent");
    end;

    u7._re = v8;
    u7._re.Name = p3;
    u7._re.Parent = p2;

    if p6 and #p6 > 0 then
        u7._hasOutbound = true;
        u7._outbound = p6;
    else
        u7._hasOutbound = false;
    end;

    if not u5 or #u5 <= 0 then
        u7._directConnect = true;

        return u7;
    end;

    u7._directConnect = false;
    u7._signal = Signal.new();
    u7._re.OnServerEvent:Connect(function(p9, ...) -- Line: 47
        -- upvalues: u5 (copy), u7 (copy)
        local v10 = table.pack(...);

        for _, v in u5 do
            if not table.pack(v(p9, v10))[1] then
                return;
            end;

            v10.n = #v10;
        end;

        u7._signal:Fire(p9, table.unpack(v10, 1, v10.n));
    end);

    return u7;
end;

function u1.IsUnreliable(p11) -- Line: 69
    return p11._re:IsA("UnreliableRemoteEvent");
end;

function u1.Connect(p12, p13) -- Line: 80
    if p12._directConnect then
        return p12._re.OnServerEvent:Connect(p13);
    end;

    return p12._signal:Connect(p13);
end;

function u1._processOutboundMiddleware(p14, p15, ...) -- Line: 88
    if not p14._hasOutbound then
        return ...;
    end;

    local v16 = table.pack(...);

    for _, v in p14._outbound do
        local v17 = table.pack(v(p15, v16));

        if not v17[1] then
            return table.unpack(v17, 2, v17.n);
        end;

        v16.n = #v16;
    end;

    return table.unpack(v16, 1, v16.n);
end;

function u1.Fire(p18, p19, ...) -- Line: 113
    p18._re:FireClient(p19, p18:_processOutboundMiddleware(p19, ...));
end;

function u1.FireAll(p20, ...) -- Line: 126
    p20._re:FireAllClients(p20:_processOutboundMiddleware(nil, ...));
end;

function u1.FireExcept(p21, u22, ...) -- Line: 141
    p21:FireFilter(function(p23) -- Line: 142
        -- upvalues: u22 (copy)
        return p23 ~= u22;
    end, ...);
end;

function u1.FireFilter(p24, p25, ...) -- Line: 171
    -- upvalues: Players (copy)
    for _, v in Players:GetPlayers() do
        if p25(v, ...) then
            p24._re:FireClient(v, p24:_processOutboundMiddleware(nil, ...));
        end;
    end;
end;

function u1.FireFor(p26, p27, ...) -- Line: 195
    for _, v in p27 do
        p26._re:FireClient(v, p26:_processOutboundMiddleware(nil, ...));
    end;
end;

function u1.Destroy(p28) -- Line: 204
    p28._re:Destroy();

    if p28._signal then
        p28._signal:Destroy();
    end;
end;

return u1;