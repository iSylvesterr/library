-- Decompiled with Potassium's decompiler.

local u1 = {};

function u1.CopyTable(p2) -- Line: 3
    -- upvalues: u1 (copy)
    local v3 = {};

    for i, v in pairs(p2) do
        if typeof(v) == "table" then
            local v = u1.CopyTable(v) or v;
        end;

        v3[i] = v;
    end;

    return v3;
end;

function u1.Reconcile(p4, p5, p6) -- Line: 11
    -- upvalues: u1 (copy)
    if p6 then
        p4 = u1.CopyTable(p4) or p4;
    end;

    for i, v in pairs(p5) do
        if p4[i] == nil then
            if typeof(v) == "table" then
                local v = u1.CopyTable(v) or v;
            end;

            p4[i] = v;
        end;
    end;

    return p4;
end;

function u1.CacheDirectory(p7, p8) -- Line: 21
    -- upvalues: u1 (copy)
    local v9 = {};

    for _, child in ipairs(p7:GetChildren()) do
        local v10;

        if child:IsA("ModuleScript") then
            v10 = p8 and p8(child) or require(child);
        else
            v10 = nil;
        end;

        if v10 then
            v9[child.Name] = v10;
        elseif child:IsA("Folder") or child:IsA("Model") then
            v9[child.Name] = u1.CacheDirectory(child, p8);
        else
            v9[child.Name] = nil;
        end;
    end;

    return v9;
end;

function u1.DeepCopy(p11) -- Line: 39
    -- upvalues: u1 (copy)
    if type(p11) ~= "table" then
        return p11;
    end;

    local v12 = {};

    for i, v in pairs(p11) do
        v12[u1.DeepCopy(i)] = u1.DeepCopy(v);
    end;

    local DeepCopy = u1.DeepCopy;
    local v13 = getmetatable(p11);
    setmetatable(v12, DeepCopy(v13));

    return v12;
end;

function u1.DeepCopyRecursive(p14, p15) -- Line: 52
    -- upvalues: u1 (copy)
    local v16 = p15 or {};

    if type(p14) ~= "table" then
        return p14;
    end;

    if v16[p14] then
        return v16[p14];
    end;

    local v17 = {};
    v16[p14] = v17;

    for i, v in pairs(p14) do
        v17[u1.DeepCopyRecursive(i, v16)] = u1.DeepCopyRecursive(v, v16);
    end;

    local DeepCopyRecursive = u1.DeepCopyRecursive;
    local v18 = getmetatable(p14);
    setmetatable(v17, DeepCopyRecursive(v18, v16));

    return v17;
end;

return u1;