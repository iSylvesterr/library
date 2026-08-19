-- Decompiled with Potassium's decompiler.

local wcall = require(script.Parent.wcall);

return function(p1, p2, ...) -- Line: 3
    -- upvalues: wcall (copy)
    local u3 = nil;
    local u4 = nil;
    local v6 = table.pack(xpcall(p1, function(p5) -- Line: 6
        -- upvalues: u3 (ref), u4 (ref)
        u3 = tostring(p5);
        u4 = tostring(debug.traceback(nil, 3));
    end, ...));

    if not v6[1] then
        wcall(p2);
        error(("%s\nStack Begin\n%sStack End"):format(u3, u4));
    end;

    wcall(p2);

    return table.unpack(v6, 2);
end;