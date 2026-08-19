-- Decompiled with Potassium's decompiler.

local v1 = {};

local function transformInstanceSet(p2) -- Line: 13
    local v3 = {};

    for i = 1, #p2 do
        v3[i] = p2[i].Name;
    end;

    return v3, p2;
end;

function v1.GetNames(p4) -- Line: 26
    local v5 = {};

    for i = 1, #p4 do
        v5[i] = p4[i].Name or tostring(p4[i]);
    end;

    return v5;
end;

function v1.MakeFuzzyFinder(p6) -- Line: 39
    local u7 = nil;
    local u8 = {};

    if typeof(p6) == "Enum" then
        p6 = p6:GetEnumItems();
    end;

    if typeof(p6) == "Instance" then
        u8 = p6:GetChildren();
        u7 = {};

        for i = 1, #u8 do
            u7[i] = u8[i].Name;
        end;
    elseif typeof(p6) == "table" then
        if typeof(p6[1]) == "Instance" or (typeof(p6[1]) == "EnumItem" or typeof(p6[1]) == "table" and typeof(p6[1].Name) == "string") then
            u7 = {};
            u8 = p6;

            for i = 1, #p6 do
                u7[i] = u8[i].Name;
                p6 = u8;
                u8 = p6;
            end;
        elseif type(p6[1]) == "string" then
            u7 = p6;
        elseif p6[1] == nil then
            u7 = {};
        else
            error("MakeFuzzyFinder only accepts tables of instances or strings.");
        end;
    else
        error("MakeFuzzyFinder only accepts a table, Enum, or Instance.");
    end;

    return function(p9, p10) -- Line: 67
        -- upvalues: u7 (ref), u8 (ref)
        local v11 = {};

        for i, v in pairs(u7) do
            local v12;

            if u8 then
                v12 = u8[i] or v;
            else
                v12 = v;
            end;

            if v:lower() == p9:lower() then
                if p10 then
                    return v12;
                end;

                table.insert(v11, 1, v12);
            elseif v:lower():find(p9:lower(), 1, true) then
                v11[#v11 + 1] = v12;
            end;
        end;

        if p10 then
            return v11[1];
        end;

        return v11;
    end;
end;

return v1;