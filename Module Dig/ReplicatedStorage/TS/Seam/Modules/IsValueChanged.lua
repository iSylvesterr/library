-- Decompiled with Potassium's decompiler.

return function(p1, p2) -- Line: 6
    local v3 = typeof(p1);

    if typeof(p1) ~= typeof(p2) then
        return true;
    end;

    if v3 == "table" then
        for i, v in p1 do
            if not p2[i] then
                return true;
            end;

            if typeof(v) == "number" then
                return math.abs(v - p2[i]) > 0.001;
            end;

            if typeof(v) ~= "boolean" then
                return true;
            end;

            if v ~= p2[i] then
                return true;
            end;
        end;

        for i, _ in p2 do
            if not p1[i] then
                return true;
            end;
        end;
    end;

    return p1 ~= p2;
end;