-- Decompiled with Potassium's decompiler.

return function(p1) -- Line: 9
    function p1.Number_Filtrate(p2, p3) -- Line: 22
        if p2 % p3 == 0 then
            return true, p2 + 1;
        end;

        return false, p2 + 1;
    end;

    function p1.Scale_Particle(p4, p5) -- Line: 35
        if math.abs(p5 - 1) < 0.01 then
            return;
        end;

        local v6 = type(p4) ~= "table" and { p4 } or p4;

        for _, v in pairs(v6) do
            local v7 = {};

            for _, v2 in pairs(v.Size.Keypoints) do
                table.insert(v7, NumberSequenceKeypoint.new(v2.Time, v2.Value * p5, v2.Envelope * p5));
            end;

            v.Size = NumberSequence.new(v7);
            v.Drag = v.Drag * p5;
            v.VelocityInheritance = v.VelocityInheritance * p5;
            v.Speed = NumberRange.new(v.Speed.Min * p5, v.Speed.Max * p5);
            v.Acceleration = Vector3.new(v.Acceleration.X * p5, v.Acceleration.Y * p5, v.Acceleration.Z * p5);
        end;
    end;

    function p1.Scale_Particle_Size(p8, p9) -- Line: 71
        if math.abs(p9 - 1) < 0.01 then
            return;
        end;

        local v10 = type(p8) ~= "table" and { p8 } or p8;

        for _, v in pairs(v10) do
            local v11 = {};

            for _, v2 in pairs(v.Size.Keypoints) do
                table.insert(v11, NumberSequenceKeypoint.new(v2.Time, v2.Value * p9, v2.Envelope * p9));
            end;

            v.Size = NumberSequence.new(v11);
        end;
    end;
end;