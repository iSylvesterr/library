-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = require(ReplicatedStorage.Library.Modules.BetterRandom).new();

return function(p2, p3, p4) -- Line: 5
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.BasePart(p2);
    Asserts.table(p4);
    p2.Anchored = false;
    local v5 = assert(p4[1], "Offsets must contain at least one value for X");
    local v6 = assert(p4[2], "Offsets must contain at least one value for Z");
    local v7 = type(p3) == "number" and p3 and p3 or u1:numberArray(p3);
    Asserts.number(v7);
    local v8 = p2.Position + Vector3.new(v5, 0, v6);
    p2:ApplyImpulse(((p2.Position - v8) / v7 + Vector3.new(0, workspace.Gravity * v7 * 0.5, 0)) * p2.AssemblyMass);
end;