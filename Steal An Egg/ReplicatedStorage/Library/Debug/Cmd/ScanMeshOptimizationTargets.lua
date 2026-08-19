-- Decompiled with Potassium's decompiler.

local AssetService = game:GetService("AssetService");
local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Selection = game:GetService("Selection");
local v1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();

local function sanitizeSegment(p2) -- Line: 30
    return string.gsub(p2, "[^%w_%-]+", "_");
end;

local function buildSourceKey(p3, p4) -- Line: 34
    -- upvalues: sanitizeSegment (copy)
    local v5 = string.gsub(p4, "/", "__");

    return sanitizeSegment(p3 .. "__" .. string.gsub(v5, "%.", "_"));
end;

local function relativeSegments(p6, p7) -- Line: 40
    if p6 == p7 then
        return { p7.Name };
    end;

    local v8 = {};

    while p7 and p7 ~= p6 do
        table.insert(v8, 1, p7.Name);
        p7 = p7.Parent;
    end;

    table.insert(v8, 1, p6.Name);

    return v8;
end;

local function absoluteSegments(p9) -- Line: 56
    local v10 = {};

    while p9 and p9 ~= game do
        table.insert(v10, 1, p9.Name);
        p9 = p9.Parent;
    end;

    return v10;
end;

local function joinSegments(p11) -- Line: 66
    return table.concat(p11, "/");
end;

local function extractAssetId(p12) -- Line: 70
    local v13 = string.match(p12, "(%d%d%d%d%d+)");

    if v13 then
        return tonumber(v13);
    end;

    return nil;
end;

local function upsertManifestValue() -- Line: 78
    -- upvalues: ReplicatedStorage (copy)
    local MeshOptimizationManifest = ReplicatedStorage:FindFirstChild("MeshOptimizationManifest");

    if MeshOptimizationManifest and MeshOptimizationManifest:IsA("StringValue") then
        return MeshOptimizationManifest;
    end;

    if MeshOptimizationManifest then
        MeshOptimizationManifest:Destroy();
    end;

    local StringValue = Instance.new("StringValue");
    StringValue.Name = "MeshOptimizationManifest";
    StringValue.Parent = ReplicatedStorage;

    return StringValue;
end;

local function probeMeshPartGeometry(u14, p15) -- Line: 94
    -- upvalues: AssetService (copy)
    local v16 = tostring(u14.MeshContent);
    local v17 = p15[v16];

    if v17 then
        return v17;
    end;

    local u18 = nil;
    local success, result = pcall(function() -- Line: 102
        -- upvalues: u18 (ref), AssetService (ref), u14 (copy)
        u18 = AssetService:CreateEditableMeshAsync(u14.MeshContent);
    end);
    local v19;

    if success then
        if u18 == nil then
            v19 = {
                triangleCount = nil,
                boneCount = 0,
                queryStatus = "EditableMeshUnavailable",
                errorMessage = "CreateEditableMeshAsync returned nil"
            };
        else
            v19 = {
                queryStatus = "EditableMesh",
                errorMessage = nil,
                triangleCount = #u18:GetFaces(),
                boneCount = #u18:GetBones()
            };
            u18:Destroy();
        end;
    else
        v19 = {
            triangleCount = nil,
            boneCount = 0,
            queryStatus = "EditableMeshError",
            errorMessage = tostring(result)
        };
    end;

    p15[v16] = v19;

    return v19;
end;

local function classifyMeshPart(p20, p21) -- Line: 135
    if p21.boneCount > 0 then
        return "skinned_source_required", true;
    end;

    local v22 = tostring(p20.MeshId);
    local v23 = string.match(v22, "(%d%d%d%d%d+)");
    local v24;

    if v23 then
        v24 = tonumber(v23);
    else
        v24 = nil;
    end;

    if v24 == nil then
        return "rigid_source_optional", false;
    end;

    return "rigid_meshpart_downloadable", false;
end;

local function classifySpecialMesh(p25) -- Line: 148
    local v26 = tostring(p25.MeshId);
    local v27 = string.match(v26, "(%d%d%d%d%d+)");
    local v28;

    if v27 then
        v28 = tonumber(v27);
    else
        v28 = nil;
    end;

    if v28 == nil then
        return "rigid_source_optional", false;
    end;

    return "rigid_downloadable", false;
end;

local function buildMeshPartEntry(p29, p30, p31) -- Line: 157
    -- upvalues: relativeSegments (copy), absoluteSegments (copy)
    local v32, v33;

    if p31.boneCount > 0 then
        v32 = true;
        v33 = "skinned_source_required";
    else
        local v34 = tostring(p30.MeshId);
        local v35 = string.match(v34, "(%d%d%d%d%d+)");
        local v36;

        if v35 then
            v36 = tonumber(v35);
        else
            v36 = nil;
        end;

        if v36 == nil then
            v32 = false;
            v33 = "rigid_source_optional";
        else
            v32 = false;
            v33 = "rigid_meshpart_downloadable";
        end;
    end;

    local v37 = relativeSegments(p29, p30);
    local v38 = {
        targetClassName = "MeshPart"
    };
    local Name = p29.Name;
    local v39 = table.concat(v37, "/");
    local v40 = string.gsub(v39, "/", "__");
    local v41 = Name .. "__" .. string.gsub(v40, "%.", "_");
    v38.sourceKey = string.gsub(v41, "[^%w_%-]+", "_");
    v38.assetKey = p30.Name;
    v38.targetPath = p30:GetFullName();
    v38.targetSegments = absoluteSegments(p30);
    v38.relativePath = table.concat(v37, "/");
    local v42 = tostring(p30.MeshId);
    local v43 = string.match(v42, "(%d%d%d%d%d+)");
    local v44;

    if v43 then
        v44 = tonumber(v43);
    else
        v44 = nil;
    end;

    v38.meshId = v44;
    local v45 = tostring(p30.TextureID);
    local v46 = string.match(v45, "(%d%d%d%d%d+)");
    local v47;

    if v46 then
        v47 = tonumber(v46);
    else
        v47 = nil;
    end;

    v38.textureId = v47;
    v38.meshContent = tostring(p30.MeshContent);
    v38.triangleCount = p31.triangleCount;
    v38.boneCount = p31.boneCount;
    v38.queryStatus = p31.queryStatus;
    v38.errorMessage = p31.errorMessage;
    v38.needsSourceFile = v32;
    v38.optimizationMode = v33;

    return v38;
end;

local function buildSpecialMeshEntry(p48, p49) -- Line: 180
    -- upvalues: relativeSegments (copy), absoluteSegments (copy)
    local v50 = tostring(p49.MeshId);
    local v51 = string.match(v50, "(%d%d%d%d%d+)");
    local v52;

    if v51 then
        v52 = tonumber(v51);
    else
        v52 = nil;
    end;

    local v53, v54;

    if v52 == nil then
        v53 = false;
        v54 = "rigid_source_optional";
    else
        v53 = false;
        v54 = "rigid_downloadable";
    end;

    local v55 = relativeSegments(p48, p49);
    local v56 = {
        targetClassName = "SpecialMesh",
        meshContent = "",
        triangleCount = nil,
        boneCount = 0,
        queryStatus = "MeshIdOnly",
        errorMessage = nil
    };
    local Name = p48.Name;
    local v57 = table.concat(v55, "/");
    local v58 = string.gsub(v57, "/", "__");
    local v59 = Name .. "__" .. string.gsub(v58, "%.", "_");
    v56.sourceKey = string.gsub(v59, "[^%w_%-]+", "_");
    v56.assetKey = p49.Name;
    v56.targetPath = p49:GetFullName();
    v56.targetSegments = absoluteSegments(p49);
    v56.relativePath = table.concat(v55, "/");
    local v60 = tostring(p49.MeshId);
    local v61 = string.match(v60, "(%d%d%d%d%d+)");
    local v62;

    if v61 then
        v62 = tonumber(v61);
    else
        v62 = nil;
    end;

    v56.meshId = v62;
    local v63 = tostring(p49.TextureId);
    local v64 = string.match(v63, "(%d%d%d%d%d+)");
    local v65;

    if v64 then
        v65 = tonumber(v64);
    else
        v65 = nil;
    end;

    v56.textureId = v65;
    v56.needsSourceFile = v53;
    v56.optimizationMode = v54;

    return v56;
end;

local function appendEntriesForRoot(p66, p67) -- Line: 203
    -- upvalues: buildMeshPartEntry (copy), probeMeshPartGeometry (copy), buildSpecialMeshEntry (copy)
    local v68 = {};

    if p66:IsA("MeshPart") then
        local v69 = buildMeshPartEntry(p66, p66, (probeMeshPartGeometry(p66, p67)));
        table.insert(v68, v69);
    end;

    for _, descendant in ipairs(p66:GetDescendants()) do
        if descendant:IsA("MeshPart") then
            local v70 = buildMeshPartEntry(p66, descendant, (probeMeshPartGeometry(descendant, p67)));
            table.insert(v68, v70);
        elseif descendant:IsA("SpecialMesh") then
            local v71 = buildSpecialMeshEntry(p66, descendant);
            table.insert(v68, v71);
        end;
    end;

    return {
        modelName = p66.Name,
        modelPath = p66:GetFullName(),
        meshes = v68
    };
end;

local v72 = Selection:Get();

if #v72 == 0 then
    error("Select one or more Models / MeshParts before running ScanMeshOptimizationTargets.");
end;

local v73 = {};
local v74 = {};
local v75 = 0;
local v76 = {};

for _, v in ipairs(v72) do
    table.insert(v73, v:GetFullName());
    local v77 = appendEntriesForRoot(v, v74);
    v75 = v75 + #v77.meshes;
    table.insert(v76, v77);
end;

local v78 = HttpService:JSONEncode({
    version = 1,
    generatedAtUtc = DateTime.now():ToIsoDate(),
    selectionPaths = v73,
    models = v76
});
local MeshOptimizationManifest = ReplicatedStorage:FindFirstChild("MeshOptimizationManifest");

if not (MeshOptimizationManifest and MeshOptimizationManifest:IsA("StringValue")) then
    if MeshOptimizationManifest then
        MeshOptimizationManifest:Destroy();
    end;

    MeshOptimizationManifest = Instance.new("StringValue");
    MeshOptimizationManifest.Name = "MeshOptimizationManifest";
    MeshOptimizationManifest.Parent = ReplicatedStorage;
end;

MeshOptimizationManifest.Value = v78;
v1:AtInfo():Log("Mesh optimization manifest generated", {
    SelectedRoots = #v72,
    MeshCount = v75,
    ManifestBytes = #v78
});