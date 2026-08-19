-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = Vector3.new(p1.R, p1.G, p1.B);
    local v4 = 0;
    local v5 = {};

    for _, v in ipairs(p2) do
        local a = v.a;
        local v6 = (v3 - Vector3.new(a.R, a.G, a.B)).Magnitude / 1.7320508075688772;
        local v7 = 1 - math.clamp(v6, 0, 1);

        if v.response then
            local v8 = v.response(v7);
            v7 = math.clamp(v8, 0, 1);
        end;

        if (v.threshold or 1e-6) < v7 and v7 == v7 then
            local v9;

            if v.weight then
                v9 = v7 * v.weight or v7;
            else
                v9 = v7;
            end;

            v4 = v4 + v9;
            table.insert(v5, {
                ratio = v7,
                weight = v9,
                keypoint = v
            });
        end;
    end;

    if v4 <= 0 then
        return p1;
    end;

    local v10 = Vector3.new(0, 0, 0);

    for _, v in ipairs(v5) do
        local b = v.keypoint.b;
        local v11 = Vector3.new(b.R, b.G, b.B);
        v10 = v10 + (v3 * (1 - v.ratio) + v11 * v.ratio) * v.weight;
    end;

    local v12 = v10 / v4;

    return Color3.new(math.clamp(v12.X, 0, 1), math.clamp(v12.Y, 0, 1), (math.clamp(v12.Z, 0, 1)));
end;