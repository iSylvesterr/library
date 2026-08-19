-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1) -- Line: 11
    -- upvalues: Asserts (copy), Players (copy)
    Asserts.Tool(p1);
    local Parent = p1.Parent;

    if not Parent then
        return nil;
    end;

    if Parent:IsA("Player") then
        return Parent;
    end;

    if Parent:IsA("Model") then
        return Players:GetPlayerFromCharacter(Parent);
    end;

    return nil;
end;