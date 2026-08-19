-- Decompiled with Potassium's decompiler.

return function(p1, p2, p3) -- Line: 4
    local Gravity = game.Workspace.Gravity;
    local v4 = (p3 ^ 2 + math.sqrt(p3 ^ 4 - Gravity * (Gravity * p1 ^ 2 + 2 * p2 * p3 ^ 2))) / (Gravity * p1);
    local v5 = math.atan(v4);

    return v5 ~= v5 and 0.7853981633974483 or v5;
end;