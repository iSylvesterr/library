-- Decompiled with Potassium's decompiler.

local u1 = { "BaseSpeed", "BaseJump", "ShovelPower", "MaxBackpack" };

local function makeFuzzyFinder(u2) -- Line: 3
    return function(p3, p4) -- Line: 4
        -- upvalues: u2 (copy)
        local v5 = {};

        for _, v in u2 do
            if v:lower() == p3:lower() then
                if p4 then
                    return v;
                end;

                table.insert(v5, 1, v);
            elseif v:lower():find(p3:lower(), 1, true) then
                table.insert(v5, v);
            end;
        end;

        if p4 then
            return v5[1];
        end;

        return v5;
    end;
end;

return function(p6) -- Line: 19
    -- upvalues: u1 (copy)
    local u7 = u1;

    local function u11(p8, p9) -- Line: 4
        -- upvalues: u7 (copy)
        local v10 = {};

        for _, v in u7 do
            if v:lower() == p8:lower() then
                if p9 then
                    return v;
                end;

                table.insert(v10, 1, v);
            elseif v:lower():find(p8:lower(), 1, true) then
                table.insert(v10, v);
            end;
        end;

        if p9 then
            return v10[1];
        end;

        return v10;
    end;

    p6:RegisterType("skillName", {
        Validate = function(p12) -- Line: 23, Name: Validate
            -- upvalues: u11 (copy), u1 (ref)
            return u11(p12, true) ~= nil, string.format("%q is not a valid skill. Valid skills: %s", p12, table.concat(u1, ", "));
        end,

        Autocomplete = function(p13) -- Line: 27, Name: Autocomplete
            -- upvalues: u11 (copy)
            return u11(p13);
        end,

        Parse = function(p14) -- Line: 30, Name: Parse
            -- upvalues: u11 (copy)
            return u11(p14, true);
        end
    });
end;