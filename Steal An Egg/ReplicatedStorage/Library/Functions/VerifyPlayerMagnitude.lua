-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 1
    local v4 = p3 or 10;

    if p2 then
        local Character = p1.Character;

        if Character then
            Character = Character.PrimaryPart;
        end;

        if Character then
            return (Character.Position - p2).Magnitude < v4;
        end;
    end;

    return false;
end;