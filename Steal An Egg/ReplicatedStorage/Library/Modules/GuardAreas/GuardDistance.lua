-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return {
    XZ = function(p1, p2) -- Line: 16, Name: XZ
        -- upvalues: Asserts (copy)
        Asserts.Vector3(p1);
        Asserts.Vector3(p2);
        local v3 = p1 - p2;

        return Vector3.new(v3.X, 0, v3.Z).Magnitude;
    end
};