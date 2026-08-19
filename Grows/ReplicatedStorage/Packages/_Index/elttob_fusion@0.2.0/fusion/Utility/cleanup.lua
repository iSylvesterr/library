-- Decompiled with Potassium's decompiler.

local function cleanupOne(p1) -- Line: 14
    -- upvalues: cleanupOne (copy)
    local v2 = typeof(p1);

    if v2 == "Instance" then
        p1:Destroy();

        return;
    end;

    if v2 == "RBXScriptConnection" then
        p1:Disconnect();

        return;
    end;

    if v2 == "function" then
        p1();

        return;
    end;

    if v2 == "table" then
        if typeof(p1.destroy) == "function" then
            p1:destroy();

            return;
        end;

        if typeof(p1.Destroy) == "function" then
            p1:Destroy();

            return;
        end;

        if p1[1] ~= nil then
            for _, v in ipairs(p1) do
                cleanupOne(v);
            end;
        end;
    end;
end;

return function(...) -- Line: 47, Name: cleanup
    -- upvalues: cleanupOne (copy)
    for i = 1, select("#", ...) do
        cleanupOne(select(i, ...));
    end;
end;