-- Decompiled with Potassium's decompiler.

local u1 = { "perch", "eat", "circle", "dropseed" };

local function findAction(p2, p3) -- Line: 3
    -- upvalues: u1 (copy)
    local v4 = {};

    for _, v in u1 do
        if v:lower() == p2:lower() then
            if p3 then
                return v;
            end;

            table.insert(v4, 1, v);
        elseif v:lower():find(p2:lower(), 1, true) then
            table.insert(v4, v);
        end;
    end;

    if p3 then
        return v4[1];
    end;

    return v4;
end;

return function(p5) -- Line: 17
    -- upvalues: findAction (copy), u1 (copy)
    p5:RegisterType("robinAction", {
        Validate = function(p6) -- Line: 19, Name: Validate
            -- upvalues: findAction (ref), u1 (ref)
            return findAction(p6, true) ~= nil, string.format("%q is not a valid action. Valid actions: %s", p6, table.concat(u1, ", "));
        end,

        Autocomplete = function(p7) -- Line: 23, Name: Autocomplete
            -- upvalues: findAction (ref)
            return findAction(p7);
        end,

        Parse = function(p8) -- Line: 26, Name: Parse
            -- upvalues: findAction (ref)
            return findAction(p8, true);
        end
    });
end;