-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local values = require(script.Parent.Parent.replicated.values);
require(script.Parent.Parent.types);
local namespacesDependencies = require(script.Parent.namespacesDependencies);
local packetIDs = require(script.Parent.packetIDs);
local u1 = RunService:IsServer() and "server" or "client";
local u2 = 0;

return function(p3, p4) -- Line: 19
    -- upvalues: values (copy), namespacesDependencies (copy), u1 (copy), u2 (ref), packetIDs (copy)
    local v5 = values.access(p3);
    namespacesDependencies.start(p3);
    local v6 = p4();
    local v7 = namespacesDependencies.empty();
    local v8 = {};

    if u1 ~= "server" then
        if u1 == "client" then
            local v9 = v5:read();

            for i, v in v6 do
                v8[i] = v(v9.packets[i]);
                packetIDs.set(v9.packets[i], v8[i]);
            end;
        end;

        return v8;
    end;

    local v10 = {
        structs = {},
        packets = {}
    };

    for i in v6 do
        u2 = u2 + 1;
        v10.packets[i] = u2;
        v8[i] = v6[i](u2);
        packetIDs.set(u2, v8[i]);
    end;

    for i, v in v7 do
        v10.structs[i] = v;
    end;

    v5:write(v10);

    return v8;
end;