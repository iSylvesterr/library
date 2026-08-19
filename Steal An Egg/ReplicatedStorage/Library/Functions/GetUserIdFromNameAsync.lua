-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Modules = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Modules");
local u5 = require(Modules.SmartCache).new(15, 3600, 60, function(p1) -- Line: 4
    -- upvalues: Players (copy)
    local v2 = Players:FindFirstChild(p1);

    if v2 and v2:IsA("Player") then
        return true, v2.UserId;
    end;

    local v3 = Players:GetUserIdFromNameAsync(p1);
    local v4 = typeof(v3) == "number";
    assert(v4);

    return true, v3;
end);

return function(p6) -- Line: 14
    -- upvalues: u5 (copy)
    return u5.get(p6, nil, true) or u5.get(p6);
end;