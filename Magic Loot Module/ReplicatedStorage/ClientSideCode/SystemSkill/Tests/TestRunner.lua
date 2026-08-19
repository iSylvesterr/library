-- Decompiled with Potassium's decompiler.

return {
    run = function(p1, p2) -- Line: 15, Name: run
        local v3 = 0;
        local v4 = 0;
        local v5 = {};

        for i, v in ipairs(p2) do
            local v6 = v.name or "case_" .. tostring(i);
            local fn = v.fn;

            if type(fn) == "function" then
                local success, result = pcall(fn);

                if success then
                    v3 = v3 + 1;
                    print(("[PASS] %s.%s"):format(p1 or "?", v6));
                else
                    v4 = v4 + 1;
                    local v7 = {
                        name = v6,
                        msg = tostring(result)
                    };
                    table.insert(v5, v7);
                    warn(("[FAIL] %s.%s: %s"):format(p1 or "?", v6, (tostring(result))));
                end;
            else
                table.insert(v5, {
                    msg = "missing fn",
                    name = v6
                });
                v4 = v4 + 1;
            end;
        end;

        return {
            passed = v3,
            failed = v4,
            errors = v5,
            name = p1 or "Unknown"
        };
    end,

    assert = function(p8, p9) -- Line: 47, Name: assert
        if not p8 then
            error(p9 or "assertion failed");
        end;
    end,

    assertEqual = function(p10, p11, p12) -- Line: 53, Name: assertEqual
        if p10 ~= p11 then
            error(p12 or "expected " .. tostring(p11) .. ", got " .. tostring(p10));
        end;
    end
};