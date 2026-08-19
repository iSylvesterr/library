-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");

local function GenerateEntropy() -- Line: 22
    -- upvalues: HttpService (copy)
    local v1 = HttpService:GenerateGUID(false);
    local v2 = string.sub(v1, 1, 8);
    local v3 = tonumber(v2, 16);
    local v4 = string.sub(v1, 10, 13) .. string.sub(v1, 25, 28);
    local v5 = tonumber(v4, 16);
    local v6 = string.sub(v1, 29, 36);

    return v3, v5, tonumber(v6, 16);
end;

return function(p7) -- Line: 30, Name: GenerateSeed
    -- upvalues: HttpService (copy)
    local v8 = table.create(p7, 0);
    local v9 = p7 // 3;

    for i = 0, v9 - 1 do
        local v10 = HttpService:GenerateGUID(false);
        local v11 = string.sub(v10, 1, 8);
        local v12 = tonumber(v11, 16);
        local v13 = string.sub(v10, 10, 13) .. string.sub(v10, 25, 28);
        local v14 = tonumber(v13, 16);
        local v15 = string.sub(v10, 29, 36);
        local v16 = tonumber(v15, 16);
        v8[i * 3 + 1] = v12;
        v8[i * 3 + 2] = v14;
        v8[i * 3 + 3] = v16;
    end;

    local v17 = p7 - v9 * 3;

    if v17 ~= 1 then
        if v17 == 2 then
            local v18 = HttpService:GenerateGUID(false);
            local v19 = string.sub(v18, 1, 8);
            local v20 = tonumber(v19, 16);
            local v21 = string.sub(v18, 10, 13) .. string.sub(v18, 25, 28);
            local v22 = tonumber(v21, 16);
            local v23 = string.sub(v18, 29, 36);
            tonumber(v23, 16);
            v8[p7 - 1] = v20;
            v8[p7] = v22;
        end;

        return v8;
    end;

    local v24 = HttpService:GenerateGUID(false);
    local v25 = string.sub(v24, 1, 8);
    local v26 = tonumber(v25, 16);
    local v27 = string.sub(v24, 10, 13) .. string.sub(v24, 25, 28);
    tonumber(v27, 16);
    local v28 = string.sub(v24, 29, 36);
    tonumber(v28, 16);
    v8[p7] = v26;

    return v8;
end;