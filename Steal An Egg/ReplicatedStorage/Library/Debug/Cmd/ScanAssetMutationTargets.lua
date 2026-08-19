-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = { "MeshId", "MeshID", "MeshContent", "Texture", "TextureID", "TextureId", "TextureContent", "ColorMap", "ColorMapContent", "MetalnessMap", "MetalnessMapContent", "NormalMap", "NormalMapContent", "RoughnessMap", "RoughnessMapContent" };
local v2 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();

local function relativePath(p3, p4) -- Line: 52
    local v5 = {};

    while p4 and p4 ~= p3 do
        table.insert(v5, 1, p4.Name);
        p4 = p4.Parent;
    end;

    return table.concat(v5, "/");
end;

local function captureProperties(u6) -- Line: 64
    -- upvalues: u1 (copy)
    local v7 = {};

    for _, v in ipairs(u1) do
        local success, result = pcall(function() -- Line: 68
            -- upvalues: u6 (copy), v (copy)
            return u6[v];
        end);

        if success and (result ~= nil and tostring(result) ~= "") then
            v7[v] = tostring(result);
        end;
    end;

    return v7;
end;

local function appendEntry(p8, p9, p10) -- Line: 79
    -- upvalues: captureProperties (copy), relativePath (copy)
    local v11 = captureProperties(p10);
    local v12 = next(v11) ~= nil;
    local v13 = p10:GetAttributes();

    if not v12 and next(v13) == nil then
        return;
    end;

    local v14 = {
        className = p10.ClassName,
        path = relativePath(p9, p10),
        properties = v11,
        attributes = v13
    };
    table.insert(p8, v14);
end;

local function upsertManifestValue() -- Line: 112
    -- upvalues: ReplicatedStorage (copy)
    local AssetMutationManifest = ReplicatedStorage:FindFirstChild("AssetMutationManifest");

    if AssetMutationManifest and AssetMutationManifest:IsA("StringValue") then
        return AssetMutationManifest;
    end;

    if AssetMutationManifest then
        AssetMutationManifest:Destroy();
    end;

    local StringValue = Instance.new("StringValue");
    StringValue.Name = "AssetMutationManifest";
    StringValue.Parent = ReplicatedStorage;

    return StringValue;
end;

local v18 = (function(p15, p16) -- Line: 41, Name: firstChildByNames
    for _, v in ipairs(p16) do
        local v17 = p15:FindFirstChild(v);

        if v17 then
            return v17;
        end;
    end;

    error((`Missing expected folder under {p15:GetFullName()}: {table.concat(p16, ", ")}`));
end)(ReplicatedStorage, { "AssetMutationTargets", "AssetModels" });

local function buildModelEntry(p19) -- Line: 97
    -- upvalues: appendEntry (copy)
    local v20 = {};
    appendEntry(v20, p19, p19);

    for _, descendant in ipairs(p19:GetDescendants()) do
        appendEntry(v20, p19, descendant);
    end;

    return {
        assetKey = p19.Name,
        modelName = p19.Name,
        entries = v20
    };
end;

local v21 = {};

for _, child in ipairs(v18:GetChildren()) do
    if child:IsA("Model") then
        local v22 = buildModelEntry(child);
        table.insert(v21, v22);
    end;
end;

local v23 = HttpService:JSONEncode({
    version = 1,
    targetFolder = v18.Name,
    generatedAtUtc = DateTime.now():ToIsoDate(),
    models = v21
});
local AssetMutationManifest = ReplicatedStorage:FindFirstChild("AssetMutationManifest");

if not (AssetMutationManifest and AssetMutationManifest:IsA("StringValue")) then
    if AssetMutationManifest then
        AssetMutationManifest:Destroy();
    end;

    AssetMutationManifest = Instance.new("StringValue");
    AssetMutationManifest.Name = "AssetMutationManifest";
    AssetMutationManifest.Parent = ReplicatedStorage;
end;

AssetMutationManifest.Value = v23;
v2:AtInfo():Log("Asset mutation manifest generated", {
    TargetFolder = v18.Name,
    ModelCount = #v21,
    ManifestBytes = #v23
});