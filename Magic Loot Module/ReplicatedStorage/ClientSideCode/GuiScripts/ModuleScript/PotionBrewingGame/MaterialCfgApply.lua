-- Decompiled with Potassium's decompiler.

local ResourceUtil = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).ResourceUtil;
local v1 = {};
local u2 = {};
local u3 = {};

local function _findFirstMeshPart(p4) -- Line: 40
    if p4:IsA("MeshPart") then
        return p4;
    end;

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("MeshPart") then
            return descendant;
        end;
    end;

    return nil;
end;

local function _resolveAppearance(p5) -- Line: 57
    -- upvalues: u2 (copy), ResourceUtil (copy), _findFirstMeshPart (copy)
    local v6 = u2[p5];

    if v6 then
        return v6;
    end;

    local v7 = ResourceUtil.GetModel(ResourceUtil.ModelCategory.Material, p5, {
        clone = false
    });

    if not (v7 and v7:IsA("Model")) then
        return nil;
    end;

    local v8 = _findFirstMeshPart(v7);

    if not v8 then
        return nil;
    end;

    local v9 = {
        color = v8.Color,
        material = v8.Material
    };
    u2[p5] = v9;

    return v9;
end;

function v1.ApplyFragmentAppearance(p10, p11, p12) -- Line: 90
    -- upvalues: _resolveAppearance (copy), u3 (copy)
    if typeof(p10) ~= "Instance" or not p10:IsA("Model") then
        return false;
    end;

    if typeof(p11) ~= "string" or p11 == "" then
        return false;
    end;

    local v13 = _resolveAppearance(p11);

    if v13 then
        for _, descendant in p10:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Color = v13.color;
                descendant.Material = v13.material;
            end;
        end;

        return true;
    end;

    if not u3[p11] then
        u3[p11] = true;
        warn("[MaterialCfgApply] 无法从材料读取 MeshPart 外观:", p11);
    end;

    return false;
end;

return v1;