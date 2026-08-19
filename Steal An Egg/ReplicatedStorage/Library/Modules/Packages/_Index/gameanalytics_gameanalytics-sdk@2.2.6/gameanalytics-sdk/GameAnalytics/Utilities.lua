-- Decompiled with Potassium's decompiler.

return {
    isStringNullOrEmpty = function(p1, p2) -- Line: 3, Name: isStringNullOrEmpty
        return not p2 or #p2 == 0;
    end,

    stringArrayContainsString = function(p3, p4, p5) -- Line: 7, Name: stringArrayContainsString
        if #p4 == 0 then
            return false;
        end;

        for _, v in ipairs(p4) do
            if v == p5 then
                return true;
            end;
        end;

        return false;
    end,

    copyTable = function(p6, p7) -- Line: 21, Name: copyTable
        local v8 = {};

        for i, v in pairs(p7) do
            if typeof(v) == "table" then
                v8[i] = p6:copyTable(v);
            else
                v8[i] = v;
            end;
        end;

        return v8;
    end
};