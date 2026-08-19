-- Decompiled with Potassium's decompiler.

return table.freeze({
    QueryObject = function(p1, p2, p3) -- Line: 29, Name: QueryObject
        for _, v in ipairs(string.split(p2, ".")) do
            if p1 == nil then
                return false;
            end;

            if p1 == p3 then
                return true;
            end;

            if type(p1) ~= "table" then
                return false;
            end;

            p1 = p1[v];
        end;

        if p1 == nil then
            return false;
        end;

        if p1 == p3 then
            return true;
        end;

        return true, p1;
    end,

    HasHierarchicalOverlap = function(p4, p5) -- Line: 57, Name: HasHierarchicalOverlap
        if p4 == p5 then
            return true;
        end;

        local v6 = string.split(p4, ".");
        local v7 = string.split(p5, ".");

        for i = 1, math.min(#v6, #v7) do
            if v6[i] ~= v7[i] then
                return false;
            end;
        end;

        return true;
    end
});