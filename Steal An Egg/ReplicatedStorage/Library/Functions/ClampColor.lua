-- Decompiled with Potassium's decompiler.

local Map3 = require(script.Parent:WaitForChild("Map3"));

return function(p1) -- Line: 2
    -- upvalues: Map3 (copy)
    local v2 = Vector3.new(p1.R, p1.G, p1.B);
    local v3 = math.min(0, v2.X, v2.Y, v2.Z);
    local v4 = math.max(1, v2.X, v2.Y, v2.Z);
    local v5 = Map3(v2, Vector3.new(v3, v3, v3), Vector3.new(v4, v4, v4), Vector3.new(0, 0, 0), Vector3.new(1, 1, 1));

    return Color3.new(v5.X, v5.Y, v5.Z);
end;