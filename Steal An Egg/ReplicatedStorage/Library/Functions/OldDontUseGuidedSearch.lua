-- Decompiled with Potassium's decompiler.

local function Safe_Index(p1, p2, p3) -- Line: 1
    if typeof(p1) == "Instance" then
        return p1[p3 and "WaitForChild" or "FindFirstChild"](p1, p2);
    end;

    if typeof(p1) == "table" then
        return p1[p2];
    end;
end;

return function(p4, p5, p6, p7, p8, p9, p10) -- Line: 9, Name: Exe_GS
    local v11 = typeof(p4);

    if v11 ~= "Instance" and v11 ~= "table" then
        warn("Failled to execute due to: (Base must be a table or Instance)");

        return nil;
    end;

    local v12 = typeof(p5);

    if v12 == "string" then
        p5 = p5:split("|");
    elseif v12 ~= "table" then
        warn("Failled to execute due to: (Path must be a string or a table)");

        return nil;
    end;

    local v13 = typeof(p6) == "number" and p6 and p6 or 1;
    local v14 = typeof(p9) == "function";

    for i = v13, #p5 do
        local v15 = p5[i];

        if v14 then
            p9(p4, p5, i);
        end;

        if i == #p5 then
            if p7 then
                p4[v15] = p8;
            end;

            local v16;

            if typeof(p4) == "Instance" then
                v16 = p4[p10 and "WaitForChild" or "FindFirstChild"](p4, v15);
            elseif typeof(p4) == "table" then
                v16 = p4[v15];
            else
                v16 = nil;
            end;

            return v16, v15;
        end;

        if typeof(p4) == "Instance" then
            p4 = p4[p10 and "WaitForChild" or "FindFirstChild"](p4, v15);
        elseif typeof(p4) == "table" then
            p4 = p4[v15];
        else
            p4 = nil;
        end;

        if not p4 then
            return warn(("Path not found at step \'%s\', trace: \'%s\'"):format(tostring(v15), debug.traceback()));
        end;
    end;
end;