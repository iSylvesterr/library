-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 1
    local v3 = type(p1) ~= "table" and { p1 } or p1;

    for _, v in ipairs(v3) do
        local v4 = {};

        for _, v2 in ipairs(v.Size.Keypoints) do
            table.insert(v4, NumberSequenceKeypoint.new(v2.Time, v2.Value * p2, v2.Envelope * p2));
        end;

        v.Size = NumberSequence.new(v4);
        v.Drag = v.Drag * p2;
        v.Speed = NumberRange.new(v.Speed.Min * p2, v.Speed.Max * p2);
        v.Acceleration = Vector3.new(v.Acceleration.X * p2, v.Acceleration.Y * p2, v.Acceleration.Z * p2);
        v.ZOffset = v.ZOffset * p2;
    end;
end;