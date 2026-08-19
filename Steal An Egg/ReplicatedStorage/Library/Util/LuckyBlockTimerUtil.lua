-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Assets = require(ReplicatedStorage.Directory.Assets);
local v1 = {};

local function parseMutations(p2) -- Line: 25
    if typeof(p2) ~= "string" or p2 == "" then
        return {};
    end;

    local v3 = {};

    for i in string.gmatch(p2, "[^,%s]+") do
        if i ~= "" and i ~= "Alpha" then
            table.insert(v3, i);
        end;
    end;

    return v3;
end;

local function cloneDropTable(p4) -- Line: 40
    if not p4 then
        return nil;
    end;

    local v5 = {};

    for i, v in ipairs(p4) do
        v5[i] = { v[1], v[2] };
    end;

    return v5;
end;

function v1.GetTimerConfig(p6) -- Line: 54
    -- upvalues: Assets (copy), parseMutations (copy), cloneDropTable (copy)
    if not p6:IsA("BasePart") then
        return nil;
    end;

    local v7 = p6:GetAttribute("AssetId");
    local v8 = p6:GetAttribute("Time");

    if typeof(v7) ~= "string" or typeof(v8) ~= "number" then
        return nil;
    end;

    local v9 = Assets.Directory[v7];

    if not v9 then
        return nil;
    end;

    local v10 = p6:GetAttribute("BaseMutation");

    if typeof(v10) ~= "string" or v10 == "Alpha" then
        v10 = nil;
    end;

    local v11 = parseMutations(p6:GetAttribute("Mutations"));
    local v12 = math.max(v8, 0);
    local v13 = p6:GetAttribute("BaseScale");
    local v14;

    if typeof(v13) == "number" then
        v14 = math.max(v13, 0);
    else
        v14 = math.max(v9.BaseModelScale or 1, 0);
    end;

    return {
        assetId = v7,
        duration = v12,
        mutations = v11,
        baseMutation = v10,
        baseScale = v14,
        scale = v14,
        dropTable = cloneDropTable(v9.LuckyBlockDropTable) or {}
    };
end;

function v1.CloneDropTable(p15) -- Line: 95
    -- upvalues: cloneDropTable (copy)
    return cloneDropTable(p15);
end;

return v1;