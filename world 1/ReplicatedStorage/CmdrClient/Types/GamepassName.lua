-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

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

local function getGamepassNames() -- Line: 19
    -- upvalues: HttpService (copy)
    local v5 = workspace:GetAttribute("RemoteGamepasses");

    if type(v5) ~= "string" or v5 == "" then
        return {};
    end;

    local success, result = pcall(HttpService.JSONDecode, HttpService, v5);

    if not success or type(result) ~= "table" then
        return {};
    end;

    local v6 = {};

    for _, v in result do
        if type(v) == "table" and type(v[3]) == "string" then
            table.insert(v6, v[3]);
        end;
    end;

    return v6;
end;

return function(p7) -- Line: 33
    -- upvalues: getGamepassNames (copy)
    p7:RegisterType("gamepassName", {
        Validate = function(p8) -- Line: 35, Name: Validate
            -- upvalues: getGamepassNames (ref)
            local u9 = getGamepassNames();

            return (function(p10, p11) -- Line: 4
                -- upvalues: u9 (copy)
                local v12 = {};

                for _, v in u9 do
                    if v:lower() == p10:lower() then
                        if p11 then
                            return v;
                        end;

                        table.insert(v12, 1, v);
                    elseif v:lower():find(p10:lower(), 1, true) then
                        table.insert(v12, v);
                    end;
                end;

                if p11 then
                    return v12[1];
                end;

                return v12;
            end)(p8, true) ~= nil, string.format("%q is not a valid gamepass. Valid gamepasses: %s", p8, table.concat(u9, ", "));
        end,

        Autocomplete = function(p13) -- Line: 40, Name: Autocomplete
            -- upvalues: getGamepassNames (ref)
            local u14 = getGamepassNames();

            return (function(p15, p16) -- Line: 4
                -- upvalues: u14 (copy)
                local v17 = {};

                for _, v in u14 do
                    if v:lower() == p15:lower() then
                        if p16 then
                            return v;
                        end;

                        table.insert(v17, 1, v);
                    elseif v:lower():find(p15:lower(), 1, true) then
                        table.insert(v17, v);
                    end;
                end;

                if p16 then
                    return v17[1];
                end;

                return v17;
            end)(p13);
        end,

        Parse = function(p18) -- Line: 43, Name: Parse
            -- upvalues: getGamepassNames (ref)
            local u19 = getGamepassNames();

            return (function(p20, p21) -- Line: 4
                -- upvalues: u19 (copy)
                local v22 = {};

                for _, v in u19 do
                    if v:lower() == p20:lower() then
                        if p21 then
                            return v;
                        end;

                        table.insert(v22, 1, v);
                    elseif v:lower():find(p20:lower(), 1, true) then
                        table.insert(v22, v);
                    end;
                end;

                if p21 then
                    return v22[1];
                end;

                return v22;
            end)(p18, true);
        end
    });
end;