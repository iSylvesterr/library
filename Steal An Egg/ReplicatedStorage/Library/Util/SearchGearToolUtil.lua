-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GearTools = ReplicatedStorage.GearTools;

return function(p1) -- Line: 13
    -- upvalues: Asserts (copy), GearTools (copy)
    Asserts.string(p1);
    local v2 = GearTools:FindFirstChild(p1, true);

    if v2 and v2:IsA("Tool") then
        return v2;
    end;

    for _, descendant in ipairs(GearTools:GetDescendants()) do
        if descendant.Name == p1 and descendant:IsA("Tool") then
            return descendant;
        end;
    end;
end;