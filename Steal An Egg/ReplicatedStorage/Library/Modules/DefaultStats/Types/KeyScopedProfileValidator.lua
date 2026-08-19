-- Decompiled with Potassium's decompiler.

local SchemaFields = require(script.Parent.SchemaFields);
local u1 = {
    Inventory = true
};

local function validateChangedField(p2, p3) -- Line: 15
    -- upvalues: SchemaFields (copy)
    local v4 = SchemaFields[p2];

    if not v4 then
        return true;
    end;

    local v5, v6 = v4(p3);

    if v5 then
        return true;
    end;

    return false, `Invalid profile field '{p2}': {v6 or "schema mismatch"}`;
end;

return function(p7, p8) -- Line: 29, Name: KeyScopedProfileValidator
    -- upvalues: SchemaFields (copy), u1 (copy)
    if typeof(p7) ~= "table" then
        return false, "profile data must be a table";
    end;

    if typeof(p8) == "table" then
        for i in SchemaFields do
            local v9 = p7[i];
            local v10 = p8[i];

            if (v9 ~= v10 or not u1[i]) and v9 ~= v10 then
                local v11 = SchemaFields[i];
                local v12, v13;

                if v11 then
                    local v14, v15 = v11(v9);

                    if v14 then
                        v12 = true;
                        v13 = nil;
                    else
                        v13 = `Invalid profile field '{i}': {v15 or "schema mismatch"}`;
                        v12 = false;
                    end;
                else
                    v12 = true;
                    v13 = nil;
                end;

                if not v12 then
                    return false, v13;
                end;
            end;
        end;

        return true;
    end;

    for i in SchemaFields do
        local v16 = p7[i];
        local v17 = SchemaFields[i];
        local v18, v19;

        if v17 then
            local v20, v21 = v17(v16);

            if v20 then
                v18 = true;
                v19 = nil;
            else
                v19 = `Invalid profile field '{i}': {v21 or "schema mismatch"}`;
                v18 = false;
            end;
        else
            v18 = true;
            v19 = nil;
        end;

        if not v18 then
            return false, v19;
        end;
    end;

    return true;
end;