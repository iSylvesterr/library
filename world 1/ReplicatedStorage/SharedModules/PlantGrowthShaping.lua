-- Decompiled with Potassium's decompiler.

return table.freeze({
    TipTowardUp = function(p1, p2, p3) -- Line: 32, Name: TipTowardUp
        if p3 <= 0 then
            return p1;
        end;

        local UpVector = p1.UpVector;
        local v4 = UpVector:Lerp(Vector3.new(0, 1, 0), p3);

        if v4.Magnitude < 1e-6 then
            return p1;
        end;

        local v5 = UpVector:Cross(v4.Unit);
        local Magnitude = v5.Magnitude;

        if Magnitude < 1e-6 then
            return p1;
        end;

        local v6 = p1 * CFrame.new(0, -p2, 0);
        local fromAxisAngle = CFrame.fromAxisAngle;
        local Unit = v5.Unit;
        local v7 = math.min(Magnitude, 1);
        local v8 = fromAxisAngle(Unit, (math.asin(v7)));
        local Position = v6.Position;

        return CFrame.new(Position) * v8 * (v6 - Position) * CFrame.new(0, p2, 0);
    end,

    GeometryShrink = function(p9, p10) -- Line: 67, Name: GeometryShrink
        return p10 >= p9 and 1 or p10 * (math.log(p9 / p10) + 1) / p9;
    end
});