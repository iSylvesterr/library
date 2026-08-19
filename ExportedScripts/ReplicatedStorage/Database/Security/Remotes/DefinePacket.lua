-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Network = require(ReplicatedStorage.Database.Security.Network);
require(script:WaitForChild("Types"));

return function(u1, p2) -- Line: 10
    -- upvalues: Network (copy)
    local u3 = p2 or {};

    return function(p4, p5) -- Line: 13
        -- upvalues: Network (ref), u1 (copy), u3 (copy)
        return Network.CreatePacket(p4, p5, u1, u3);
    end;
end;