-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 1
    local v4 = {};
    local v5 = {};

    for _, v in p3 do
        local v6 = v:GetCollisions(p2, p1.Radius);

        if #v6 > 0 then
            table.insert(v4, v:GetObject());
        end;

        for _, v2 in v6 do
            table.insert(v5, v2);
        end;
    end;

    for _, v in v5 do
        p2 = v.ClosestPoint + v.Normal * p1.Radius;
    end;

    p1.CollisionsData = v5;
    p1.CollisionHits = v4;

    return p2;
end;