-- Decompiled with Potassium's decompiler.

local u1 = workspace;

return function(p2, p3, p4, p5) -- Line: 11, Name: SafeRaycast
    -- upvalues: u1 (copy)
    local v6 = p5 or 0.001;
    assert(v6 >= 0, "luau");
    local Magnitude = p3.Magnitude;
    assert(v6 < Magnitude, "luau");
    local v7 = u1:Raycast(p2, p3, p4);

    if not v7 then
        return nil;
    end;

    local v8 = math.max(0, v7.Distance - v6);

    return {
        Distance = v8,
        Instance = v7.Instance,
        Material = v7.Material,
        Position = p2 + v8 * p3 / Magnitude,
        Normal = v7.Normal
    };
end;