-- Decompiled with Potassium's decompiler.

return {
    teleportStreamed = function(u1, u2) -- Line: 3, Name: teleportStreamed
        local Character = u1.Character;

        if not Character then
            return nil;
        end;

        pcall(function() -- Line: 8
            -- upvalues: u1 (copy), u2 (copy)
            return u1:RequestStreamAroundAsync(u2.Position, 5);
        end);

        if u1.Character ~= Character or Character.Parent == nil then
            return nil;
        end;

        Character:PivotTo(u2);
    end
};