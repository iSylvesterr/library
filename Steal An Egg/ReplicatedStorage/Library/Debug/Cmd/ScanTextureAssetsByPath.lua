-- Decompiled with Potassium's decompiler.

local HttpService = game:GetService("HttpService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local v1 = { "Workspace.KnivesAndGuns.KnifeSkins", "Workspace.KnivesAndGuns.GunSkins" };
local u2 = {
    Exclude = true
};
local v3 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();

local function resolvePath(p4) -- Line: 26
    local v5 = game;

    for i in string.gmatch(p4, "[^.]+") do
        if v5 == game and i == "Workspace" then
            v5 = workspace;
        else
            v5 = v5:FindFirstChild(i);
        end;

        if not v5 then
            error((`Missing path segment "{i}" while resolving "{p4}"`));
        end;
    end;

    return v5;
end;

local function upsertValue(p6) -- Line: 46
    -- upvalues: ReplicatedStorage (copy)
    local v7 = ReplicatedStorage:FindFirstChild(p6);

    if v7 and v7:IsA("StringValue") then
        return v7;
    end;

    if v7 then
        v7:Destroy();
    end;

    local StringValue = Instance.new("StringValue");
    StringValue.Name = p6;
    StringValue.Parent = ReplicatedStorage;

    return StringValue;
end;

local function hasExcludedAncestor(p8, p9) -- Line: 62
    -- upvalues: u2 (copy)
    local Parent = p8.Parent;

    while Parent and Parent ~= p9 do
        if u2[Parent.Name] then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function appendEntry(p10, u11) -- Line: 74
    if u11:IsA("SpecialMesh") then
        if u11.TextureId == "" then
            return;
        end;

        local v12 = {
            path = u11:GetFullName(),
            className = u11.ClassName,
            textureId = u11.TextureId,
            meshId = u11.MeshId
        };
        table.insert(p10, v12);

        return;
    end;

    if u11:IsA("Decal") or u11:IsA("Texture") then
        if u11.Texture == "" then
            return;
        end;

        local v13 = {
            path = u11:GetFullName(),
            className = u11.ClassName,
            texture = u11.Texture
        };
        table.insert(p10, v13);

        return;
    end;

    if not u11:IsA("MeshPart") then
        if u11:IsA("SurfaceAppearance") then
            local v14 = tostring(u11.ColorMap);
            local v15 = tostring(u11.ColorMapContent);

            if v14 == "" and v15 == "" then
                return;
            end;

            local v16 = {
                path = u11:GetFullName(),
                className = u11.ClassName,
                colorMap = v14,
                colorMapContent = v15
            };
            table.insert(p10, v16);
        end;

        return;
    end;

    local success, result = pcall(function() -- Line: 97
        -- upvalues: u11 (copy)
        return u11.TextureID;
    end);
    local success2, result2 = pcall(function() -- Line: 100
        -- upvalues: u11 (copy)
        return u11.MeshId;
    end);

    if not success or tostring(result) == "" then
        return;
    end;

    local v17 = {
        path = u11:GetFullName(),
        className = u11.ClassName,
        textureId = tostring(result),
        meshId = success2 and tostring(result2) or ""
    };
    table.insert(p10, v17);
end;

local function scanRoot(p18) -- Line: 129
    -- upvalues: resolvePath (copy), u2 (copy), appendEntry (copy)
    local v19 = resolvePath(p18);
    local Parent = v19.Parent;
    local v20 = {};
    local v21;

    while true do
        if not Parent or Parent == v19 then
            v21 = false;
            break;
        end;

        if u2[Parent.Name] then
            v21 = true;
            break;
        end;

        Parent = Parent.Parent;
    end;

    if not v21 then
        appendEntry(v20, v19);
    end;

    for _, descendant in ipairs(v19:GetDescendants()) do
        local Parent2 = descendant.Parent;
        local v22;

        while true do
            if not Parent2 or Parent2 == v19 then
                v22 = false;
                break;
            end;

            if u2[Parent2.Name] then
                v22 = true;
                break;
            end;

            Parent2 = Parent2.Parent;
        end;

        if not v22 then
            appendEntry(v20, descendant);
        end;
    end;

    return {
        rootPath = p18,
        entryCount = #v20,
        entries = v20
    };
end;

local v23 = 0;
local v24 = {};

for _, v in ipairs(v1) do
    local v25 = scanRoot(v);
    v23 = v23 + v25.entryCount;
    table.insert(v24, v25);
end;

local v26 = {
    rootPaths = v1,
    excludedFolderNames = u2,
    generatedAtUtc = DateTime.now():ToIsoDate(),
    scans = v24
};
local TextureAssetScanManifest = ReplicatedStorage:FindFirstChild("TextureAssetScanManifest");

if not (TextureAssetScanManifest and TextureAssetScanManifest:IsA("StringValue")) then
    if TextureAssetScanManifest then
        TextureAssetScanManifest:Destroy();
    end;

    TextureAssetScanManifest = Instance.new("StringValue");
    TextureAssetScanManifest.Name = "TextureAssetScanManifest";
    TextureAssetScanManifest.Parent = ReplicatedStorage;
end;

TextureAssetScanManifest.Value = HttpService:JSONEncode(v26);
v3:AtInfo():Log("Texture asset scan complete", {
    OutputValue = "TextureAssetScanManifest",
    RootCount = #v1,
    TotalEntries = v23
});