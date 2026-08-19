-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");

local function makeFuzzyFinder(u1) -- Line: 3
    return function(p2, p3) -- Line: 4
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
end;

return function(p5) -- Line: 19
    -- upvalues: ReplicatedStorage (copy)
    local u6 = {};

    for i in require(ReplicatedStorage.SharedData.PetTypes).Registry do
        table.insert(u6, i);
    end;

    table.sort(u6);

    local function u10(p7, p8) -- Line: 4
        -- upvalues: u6 (copy)
        local v9 = {};

        for _, v in u6 do
            if v:lower() == p7:lower() then
                if p8 then
                    return v;
                end;

                table.insert(v9, 1, v);
            elseif v:lower():find(p7:lower(), 1, true) then
                table.insert(v9, v);
            end;
        end;

        if p8 then
            return v9[1];
        end;

        return v9;
    end;

    p5:RegisterType("petType", {
        Validate = function(p11) -- Line: 32, Name: Validate
            -- upvalues: u10 (copy), u6 (copy)
            return u10(p11, true) ~= nil, string.format("%q is not a valid pet type. Valid types: %s", p11, table.concat(u6, ", "));
        end,

        Autocomplete = function(p12) -- Line: 36, Name: Autocomplete
            -- upvalues: u10 (copy)
            return u10(p12);
        end,

        Parse = function(p13) -- Line: 39, Name: Parse
            -- upvalues: u10 (copy)
            return u10(p13, true);
        end
    });
end;