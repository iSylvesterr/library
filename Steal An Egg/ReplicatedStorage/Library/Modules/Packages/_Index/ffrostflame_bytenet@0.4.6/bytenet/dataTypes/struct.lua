-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local namespacesDependencies = require(script.Parent.Parent.namespaces.namespacesDependencies);
local values = require(script.Parent.Parent.replicated.values);
require(script.Parent.Parent.types);
local u1 = RunService:IsServer() and "server" or "client";

return function(u2) -- Line: 13
    -- upvalues: u1 (copy), namespacesDependencies (copy), values (copy)
    local u3 = {};
    local u4 = {};

    if u1 == "server" then
        local v5 = 0;
        local v6 = {};

        for i in u2 do
            v5 = v5 + 1;
            v6[i] = v5;
            u3[v5] = u2[i];
            u4[v5] = i;
        end;

        namespacesDependencies.add(v6);
    elseif u1 == "client" then
        namespacesDependencies.add(u2);
        local v7 = namespacesDependencies.currentName();
        values.access(v7):read();

        for i, v in structData do
            u3[v] = u2[i];
            u4[v] = i;
        end;
    end;

    return {
        read = function(p8, p9) -- Line: 74, Name: read
            -- upvalues: u2 (copy), u3 (copy), u4 (copy)
            local v10 = table.clone(u2);
            local v11 = p9;

            for i, v in u3 do
                local v12, v13 = v.read(p8, p9);
                v10[u4[i]] = v12;
                p9 = p9 + v13;
            end;

            return v10, p9 - v11;
        end,

        write = function(p14) -- Line: 89, Name: write
            -- upvalues: u3 (copy), u4 (copy)
            for i, v in u3 do
                v.write(p14[u4[i]]);
            end;
        end
    };
end;