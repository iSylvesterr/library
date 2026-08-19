-- Decompiled with Potassium's decompiler.

local Signal = require(script.Parent.Parent.Parent.Signal);
require(script.Parent.Parent.Types);
local u1 = {};
u1.__index = u1;

function u1.new(p2, u3, p4) -- Line: 24
    -- upvalues: u1 (copy), Signal (copy)
    local u5 = setmetatable({}, u1);
    u5._re = p2;

    if p4 and #p4 > 0 then
        u5._hasOutbound = true;
        u5._outbound = p4;
    else
        u5._hasOutbound = false;
    end;

    if not u3 or #u3 <= 0 then
        u5._directConnect = true;

        return u5;
    end;

    u5._directConnect = false;
    u5._signal = Signal.new();
    u5._reConn = u5._re.OnClientEvent:Connect(function(...) -- Line: 40
        -- upvalues: u3 (copy), u5 (copy)
        local v6 = table.pack(...);

        for _, v in u3 do
            if not table.pack(v(v6))[1] then
                return;
            end;

            v6.n = #v6;
        end;

        u5._signal:Fire(table.unpack(v6, 1, v6.n));
    end);

    return u5;
end;

function u1._processOutboundMiddleware(p7, ...) -- Line: 57
    local v8 = table.pack(...);

    for _, v in p7._outbound do
        local v9 = table.pack(v(v8));

        if not v9[1] then
            return table.unpack(v9, 2, v9.n);
        end;

        v8.n = #v8;
    end;

    return table.unpack(v8, 1, v8.n);
end;

function u1.Connect(p10, p11) -- Line: 76
    if p10._directConnect then
        return p10._re.OnClientEvent:Connect(p11);
    end;

    return p10._signal:Connect(p11);
end;

function u1.Fire(p12, ...) -- Line: 92
    if p12._hasOutbound then
        p12._re:FireServer(p12:_processOutboundMiddleware(...));

        return;
    end;

    p12._re:FireServer(...);
end;

function u1.Destroy(p13) -- Line: 103
    if p13._signal then
        p13._signal:Destroy();
    end;
end;

return u1;