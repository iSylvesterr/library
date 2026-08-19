-- Decompiled with Potassium's decompiler.

return function(p1, ...) -- Line: 3
    local u2 = nil;
    local u3 = nil;
    local v5 = table.pack(xpcall(p1, function(p4) -- Line: 7
        -- upvalues: u2 (ref), u3 (ref)
        u2 = tostring(p4);
        u3 = tostring(debug.traceback(nil, 3));
    end, ...));
    local v6 = v5[1];

    if v6 then
        return v6, table.unpack(v5, 2);
    end;

    warn(string.format("Error: %s\nStack Begin\n%s\nStack End", tostring(u2), (tostring(u3))));

    return false, u2;
end;