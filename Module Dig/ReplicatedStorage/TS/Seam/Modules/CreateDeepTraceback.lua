-- Decompiled with Potassium's decompiler.

return function() -- Line: 6
    local v1 = "";

    for i = 1, 10 do
        local v2 = debug.traceback(nil, i + 1);

        if v2:len() == 0 then
            break;
        end;

        v1 = v1 .. v2 .. "\n";
    end;

    return v1;
end;