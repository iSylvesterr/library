-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 4
    local v3 = {};

    for _, v in ipairs(p1.Keypoints) do
        table.insert(v3, NumberSequenceKeypoint.new(v.Time, v.Value * p2, v.Envelope * p2));
    end;

    return NumberSequence.new(v3);
end;