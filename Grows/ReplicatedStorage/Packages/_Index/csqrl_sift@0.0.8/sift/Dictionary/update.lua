-- Decompiled with Potassium's decompiler.

local copy = require(script.Parent.copy);

local function call(p1, p2) -- Line: 7
    if type(p1) == "function" then
        return p1(p2);
    end;
end;

return function(p3, p4, p5, p6) -- Line: 39, Name: update
    -- upvalues: copy (copy)
    local v7 = copy(p3);

    if v7[p4] == nil then
        if p6 then
            local v8;

            if type(p6) == "function" then
                v8 = p6(p4);
            else
                v8 = nil;
            end;

            v7[p4] = v8;
        end;
    elseif p5 then
        v7[p4] = p5(v7[p4], p4);

        return v7;
    end;

    return v7;
end;