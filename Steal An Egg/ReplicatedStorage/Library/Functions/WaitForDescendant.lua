-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");

return function(p1, p2, p3) -- Line: 3
    -- upvalues: RunService (copy)
    local v4 = p1:FindFirstChild(p2, true);

    if v4 then
        return v4;
    end;

    local v5 = p3 or (1 / 0);
    local v6 = 0;
    local v7 = false;
    local v8;

    while true do
        v8 = p1:FindFirstChild(p2, true);

        if v5 <= v6 then
            break;
        end;

        if v6 >= 5 and not v7 then
            warn((("Infinite yield possible on \'game.%s:WaitForDescendant(\"%s\")\' %s"):format(p1:GetFullName(), p2, debug.traceback())));
            v7 = true;
        end;

        v6 = v6 + RunService.PreSimulation:Wait();

        if v8 then
            return v8;
        end;
    end;

    return v8;
end;