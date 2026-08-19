-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);

return function(p1, p2, p3) -- Line: 9
    -- upvalues: Asserts (copy)
    Asserts.CFrame(p1);
    Asserts.Vector3(p2);
    Asserts.Vector3(p3);
    local v4 = p1:PointToObjectSpace(p3);
    local v5 = p2 * 0.5;
    local v6;

    if math.abs(v4.X) <= v5.X and math.abs(v4.Y) <= v5.Y then
        v6 = math.abs(v4.Z) <= v5.Z;
    else
        v6 = false;
    end;

    return v6;
end;