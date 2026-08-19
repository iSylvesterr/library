-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = { "TextureID", "TextureId", "TextureContent" };
local u2 = { "ColorMap", "ColorMapContent", "MetalnessMap", "MetalnessMapContent", "NormalMap", "NormalMapContent", "RoughnessMap", "RoughnessMapContent" };
local u3 = {
    Decal = true,
    Texture = true,
    SurfaceAppearance = true,
    SpecialMesh = true
};
local v4 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();

local function hasProp(u5, u6) -- Line: 46
    return pcall(function() -- Line: 47
        -- upvalues: u5 (copy), u6 (copy)
        return u5[u6];
    end);
end;

local function firstChildByNames(p7, p8) -- Line: 53
    for _, v in ipairs(p8) do
        local v9 = p7:FindFirstChild(v);

        if v9 then
            return v9;
        end;
    end;

    error((`Missing expected folder under {p7:GetFullName()}: {table.concat(p8, ", ")}`));
end;

local function relativePath(p10, p11) -- Line: 64
    local v12 = {};

    while p11 and p11 ~= p10 do
        table.insert(v12, 1, p11.Name);
        p11 = p11.Parent;
    end;

    return table.concat(v12, "/");
end;

local function copyAttributes(p13, p14) -- Line: 76
    for i, _ in pairs(p13:GetAttributes()) do
        if p14:GetAttribute(i) == nil then
            p13:SetAttribute(i, nil);
        end;
    end;

    for i, v in pairs(p14:GetAttributes()) do
        p13:SetAttribute(i, v);
    end;
end;

local function copySimpleProperties(u15, u16, p17) -- Line: 88
    for _, v in ipairs(p17) do
        if pcall(function() -- Line: 47
            -- upvalues: u15 (copy), v (copy)
            return u15[v];
        end) and pcall(function() -- Line: 47
            -- upvalues: u16 (copy), v (copy)
            return u16[v];
        end) then
            local success, result = pcall(function() -- Line: 91
                -- upvalues: u16 (copy), v (copy)
                return u16[v];
            end);

            if success then
                pcall(function() -- Line: 95
                    -- upvalues: u15 (copy), v (copy), result (copy)
                    u15[v] = result;
                end);
            end;
        end;
    end;
end;

local function syncSurfaceAppearance(p18, p19) -- Line: 103
    -- upvalues: copySimpleProperties (copy), u2 (copy), copyAttributes (copy)
    local v20 = p18:FindFirstChildOfClass("SurfaceAppearance");
    local v21 = p19:FindFirstChildOfClass("SurfaceAppearance");

    if not v21 then
        if v20 then
            v20:Destroy();
        end;

        return;
    end;

    if not v20 then
        v21:Clone().Parent = p18;

        return;
    end;

    copySimpleProperties(v20, v21, u2);
    copyAttributes(v20, v21);
end;

local function syncVisualChildren(p22, p23) -- Line: 123
    -- upvalues: u3 (copy), copyAttributes (copy), copySimpleProperties (copy), syncSurfaceAppearance (copy)
    local v24 = {};

    for _, child in ipairs(p22:GetChildren()) do
        if u3[child.ClassName] then
            v24[child.Name .. ":" .. child.ClassName] = child;
        end;
    end;

    for _, child in ipairs(p23:GetChildren()) do
        if u3[child.ClassName] and not child:IsA("SurfaceAppearance") then
            local v25 = child.Name .. ":" .. child.ClassName;
            local v26 = v24[v25];

            if child:IsA("Decal") or child:IsA("Texture") then
                if v26 then
                    copyAttributes(v26, child);
                    copySimpleProperties(v26, child, { "Texture", "TextureID", "TextureId", "TextureContent", "Color3", "Transparency" });
                else
                    child:Clone().Parent = p22;
                end;

                v24[v25] = nil;
            elseif child:IsA("SpecialMesh") then
                if v26 then
                    copyAttributes(v26, child);
                    copySimpleProperties(v26, child, { "MeshId", "TextureId", "Scale", "VertexColor", "Offset" });
                else
                    child:Clone().Parent = p22;
                end;

                v24[v25] = nil;
            end;
        end;
    end;

    for _, v in pairs(v24) do
        v:Destroy();
    end;

    syncSurfaceAppearance(p22, p23);
end;

local v27 = firstChildByNames(ReplicatedStorage, { "AssetMutationTargets", "AssetModels" });
local v28 = firstChildByNames(ReplicatedStorage, { "AssetMutationReplacements", "ActiveAssetModels" });
local v29 = 0;

local function collectTargetParts(p30) -- Line: 233
    -- upvalues: relativePath (copy)
    local v31 = {};

    for _, descendant in ipairs(p30:GetDescendants()) do
        if descendant:IsA("BasePart") then
            v31[relativePath(p30, descendant)] = descendant;
        end;
    end;

    return v31;
end;

local function copyBasePartVisuals(u32, u33) -- Line: 177
    -- upvalues: copySimpleProperties (copy), copyAttributes (copy), syncVisualChildren (copy), u1 (copy), u3 (copy)
    copySimpleProperties(u32, u33, { "Color", "Material", "MaterialVariant", "Transparency", "Reflectance", "CastShadow" });
    copyAttributes(u32, u33);
    syncVisualChildren(u32, u33);

    if u32:IsA("MeshPart") and u33:IsA("MeshPart") then
        copySimpleProperties(u32, u33, u1);
        local v34 = false;
        local u35 = "MeshId";

        if pcall(function() -- Line: 47
            -- upvalues: u32 (copy), u35 (copy)
            return u32[u35];
        end) then
            local u36 = "MeshId";

            if pcall(function() -- Line: 47
                -- upvalues: u33 (copy), u36 (copy)
                return u33[u36];
            end) then
                v34 = pcall(function() -- Line: 194
                    -- upvalues: u32 (copy), u33 (copy)
                    u32.MeshId = u33.MeshId;
                end);
            end;
        end;

        if not v34 then
            local u37 = "MeshContent";

            if pcall(function() -- Line: 47
                -- upvalues: u32 (copy), u37 (copy)
                return u32[u37];
            end) then
                local u38 = "MeshContent";

                if pcall(function() -- Line: 47
                    -- upvalues: u33 (copy), u38 (copy)
                    return u33[u38];
                end) then
                    v34 = pcall(function() -- Line: 200
                        -- upvalues: u32 (copy), u33 (copy)
                        u32.MeshContent = u33.MeshContent;
                    end);
                end;
            end;
        end;

        if not v34 then
            local Parent = u32.Parent;
            assert(Parent, "MeshPart target must have a parent");
            local v39 = u33:Clone();
            v39.Name = u32.Name;
            v39.CFrame = u32.CFrame;
            v39.Anchored = u32.Anchored;
            v39.CanCollide = u32.CanCollide;
            v39.CanQuery = u32.CanQuery;
            v39.CanTouch = u32.CanTouch;
            v39.CastShadow = u32.CastShadow;
            v39.Massless = u32.Massless;
            v39.Locked = u32.Locked;
            v39.Parent = Parent;

            for _, child in ipairs(u32:GetChildren()) do
                if not u3[child.ClassName] then
                    child.Parent = v39;
                end;
            end;

            copyAttributes(v39, u33);
            u32:Destroy();
        end;
    end;
end;

local v40 = 0;
local v41 = 0;

for _, child in ipairs(v27:GetChildren()) do
    if child:IsA("Model") then
        local v42 = v28:FindFirstChild(child.Name);

        if v42 and v42:IsA("Model") then
            local v43 = collectTargetParts(v42);

            for i, v in pairs((collectTargetParts(child))) do
                local v44 = v43[i];

                if v44 then
                    copyBasePartVisuals(v, v44);
                    v40 = v40 + 1;
                else
                    v4:AtWarning():Log("Missing replacement part", {
                        Model = child.Name,
                        Path = i
                    });
                    v29 = v29 + 1;
                end;
            end;
        else
            v4:AtWarning():Log("Missing replacement model", {
                Model = child.Name
            });
            v41 = v41 + 1;
        end;
    end;
end;

v4:AtInfo():Log("Studio mesh update complete", {
    UpdatedParts = v40,
    SkippedModels = v41,
    MissingParts = v29,
    TargetFolder = v27.Name,
    SourceFolder = v28.Name
});