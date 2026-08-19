-- Decompiled with Potassium's decompiler.

local u1 = {
    k = "e3",
    m = "e6",
    b = "e9",
    t = "e12",
    q = "e15"
};

return function(p2) -- Line: 13
    -- upvalues: u1 (copy)
    if type(p2) == "string" then
        p2 = p2:gsub("[,%s%c%z]", "");

        if #p2 > 0 then
            local v3 = u1[p2:sub(#p2):lower()];

            if v3 then
                p2 = p2:sub(1, #p2 - 1) .. v3;
            end;
        end;
    end;

    return tonumber(p2);
end;