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
    local u6 = { "None" };

    for _, child in ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("MutationData"):GetChildren() do
        if child:IsA("ModuleScript") then
            table.insert(u6, child.Name);
        end;
    end;

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

    local u11 = {
        ["."] = true,
        ["-"] = true,
        _ = true,
        x = true,
        d = true,
        default = true,
        ["nil"] = true
    };
    p5:RegisterType("mutationName", {
        Validate = function(p12) -- Line: 36, Name: Validate
            -- upvalues: u11 (copy), u10 (copy), u6 (copy)
            if u11[p12:lower()] then
                return true;
            end;

            return u10(p12, true) ~= nil, string.format("%q is not a valid mutation. Valid mutations: %s", p12, table.concat(u6, ", "));
        end,

        Autocomplete = function(p13) -- Line: 41, Name: Autocomplete
            -- upvalues: u10 (copy)
            return u10(p13);
        end,

        Parse = function(p14) -- Line: 44, Name: Parse
            -- upvalues: u11 (copy), u10 (copy)
            return u11[p14:lower()] and "None" or u10(p14, true);
        end
    });
end;