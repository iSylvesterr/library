-- Decompiled with Potassium's decompiler.

return table.freeze({
    applyTo = function(p1, p2, p3) -- Line: 3, Name: applyTo
        if math.abs(p3 - 1) < 0.0001 then
            return;
        end;

        if not p2.Parent then
            return;
        end;

        p2.Size = p2.Size * p3;
        local v4 = p1.CFrame:ToObjectSpace(p2.CFrame);
        local v5 = v4 - v4.Position;
        p2.CFrame = p1.CFrame * CFrame.new(v4.Position * p3) * v5;
    end
});