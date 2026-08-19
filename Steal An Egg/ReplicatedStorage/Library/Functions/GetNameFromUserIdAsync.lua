-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Modules = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Modules");
local u6 = require(Modules.SmartCache).new(15, 3600, 60, function(p1) -- Line: 6
    -- upvalues: Players (copy)
    local v2 = Players:GetPlayerByUserId(p1);

    if v2 then
        return true, v2.Name;
    end;

    local v3 = Players:GetNameFromUserIdAsync(p1);
    local v4 = type(v3) == "string";
    assert(v4);
    local v5;

    if #v3 > 0 then
        v5 = #v3 <= 20;
    else
        v5 = false;
    end;

    assert(v5);

    return true, v3;
end);

return function(p7) -- Line: 18
    -- upvalues: u6 (copy)
    return u6.get(p7, nil, true) or u6.get(p7);
end;