-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = game:GetService("RunService"):IsServer();
local u2;

if u1 then
    u2 = game:GetService("ServerStorage");
else
    u2 = nil;
end;

local u3 = {
    ASSETS_ROOT_NAME = "Assets",
    Scope = table.freeze({
        Shared = "Shared",
        Server = "Server",
        Auto = "Auto"
    })
};
local u4 = {
    ModelRes = true
};
local u5 = {};
local u6 = {};
local u7 = {};

local function _normalizeScope(p8) -- Line: 131
    -- upvalues: u3 (copy), u7 (copy)
    local v9 = p8 or u3.Scope.Shared;

    if v9 == u3.Scope.Shared or (v9 == u3.Scope.Server or v9 == u3.Scope.Auto) then
        return v9;
    end;

    if not u7[v9] then
        u7[v9] = true;
        warn((`[AssetPaths] 非法 scope "{v9}"，已回退为 Shared`));
    end;

    return u3.Scope.Shared;
end;

local function _readFolderCache(p10) -- Line: 150
    if p10 == nil then
        return nil, false;
    end;

    if p10 == false then
        return nil, true;
    end;

    return p10, true;
end;

local function _makeCatalogCacheKey(p11, p12) -- Line: 166
    return p11 .. ":" .. p12;
end;

local function _findAssetsRootUnder(p13) -- Line: 175
    -- upvalues: u3 (copy)
    local v14 = p13:FindFirstChild(u3.ASSETS_ROOT_NAME);

    if v14 and v14:IsA("Folder") then
        return v14;
    end;

    return nil;
end;

local function _findLegacyCatalogUnder(p15, p16) -- Line: 189
    -- upvalues: u4 (copy)
    if not u4[p16] then
        return nil;
    end;

    local v17 = p15:FindFirstChild(p16);

    if v17 and v17:IsA("Folder") then
        return v17;
    end;

    return nil;
end;

local function _traversePath(p18, p19) -- Line: 206
    for _, v in p19 do
        if v ~= "" then
            p18 = p18:FindFirstChild(v);

            if not p18 then
                return nil;
            end;
        end;
    end;

    return p18;
end;

local function _resolveCatalogUnderStorage(p20, p21, p22) -- Line: 228
    -- upvalues: u6 (copy), u3 (copy), u4 (copy)
    local v23 = p22 .. ":" .. p20;
    local v24 = u6[v23];
    local v25;

    if v24 == nil then
        v25 = false;
        v24 = nil;
    elseif v24 == false then
        v25 = true;
        v24 = nil;
    else
        v25 = true;
    end;

    if v25 then
        return v24;
    end;

    local v26 = nil;
    local v27 = p21:FindFirstChild(u3.ASSETS_ROOT_NAME);

    if not (v27 and v27:IsA("Folder")) then
        v27 = nil;
    end;

    local v28;

    if v27 then
        v28 = v27:FindFirstChild(p20);

        if v28 then
            if not v28:IsA("Folder") then
                v28 = v26;
            end;
        else
            v28 = v26;
        end;
    else
        v28 = v26;
    end;

    if not v28 then
        if u4[p20] then
            v28 = p21:FindFirstChild(p20);

            if not (v28 and v28:IsA("Folder")) then
                v28 = nil;
            end;
        else
            v28 = nil;
        end;
    end;

    u6[v23] = v28 or false;

    return v28;
end;

function u3.GetAssetsRoot(p29) -- Line: 266
    -- upvalues: _normalizeScope (copy), u3 (copy), u5 (copy), ReplicatedStorage (copy), u2 (copy), u1 (copy)
    local v30 = _normalizeScope(p29);

    if v30 == u3.Scope.Shared then
        local v31 = u5[u3.Scope.Shared];
        local v32;

        if v31 == nil then
            v32 = false;
            v31 = nil;
        elseif v31 == false then
            v32 = true;
            v31 = nil;
        else
            v32 = true;
        end;

        if v32 then
            return v31;
        end;

        local v33 = ReplicatedStorage:FindFirstChild(u3.ASSETS_ROOT_NAME);

        if not (v33 and v33:IsA("Folder")) then
            v33 = nil;
        end;

        u5[u3.Scope.Shared] = v33 or false;

        return v33;
    end;

    if v30 ~= u3.Scope.Server then
        return u1 and (u2 and u3.GetAssetsRoot(u3.Scope.Server)) or u3.GetAssetsRoot(u3.Scope.Shared);
    end;

    if not u2 then
        return nil;
    end;

    local v34 = u5[u3.Scope.Server];
    local v35;

    if v34 == nil then
        v35 = false;
        v34 = nil;
    elseif v34 == false then
        v35 = true;
        v34 = nil;
    else
        v35 = true;
    end;

    if v35 then
        return v34;
    end;

    local v36 = u2:FindFirstChild(u3.ASSETS_ROOT_NAME);

    if not (v36 and v36:IsA("Folder")) then
        v36 = nil;
    end;

    u5[u3.Scope.Server] = v36 or false;

    return v36;
end;

function u3.GetCatalog(p37, p38) -- Line: 315
    -- upvalues: _normalizeScope (copy), u3 (copy), u1 (copy), u2 (copy), _resolveCatalogUnderStorage (copy), ReplicatedStorage (copy)
    local v39 = _normalizeScope(p38);

    if v39 == u3.Scope.Auto then
        return u1 and u2 and _resolveCatalogUnderStorage(p37, u2, u3.Scope.Server) or _resolveCatalogUnderStorage(p37, ReplicatedStorage, u3.Scope.Shared);
    end;

    if v39 ~= u3.Scope.Server then
        return _resolveCatalogUnderStorage(p37, ReplicatedStorage, u3.Scope.Shared);
    end;

    if u2 then
        return _resolveCatalogUnderStorage(p37, u2, u3.Scope.Server);
    end;

    return nil;
end;

function u3.Resolve(p40, p41) -- Line: 355
    -- upvalues: _normalizeScope (copy), u3 (copy), _traversePath (copy)
    if type(p40) ~= "string" or p40 == "" then
        return nil;
    end;

    local v42 = _normalizeScope(p41);
    local v43 = {};

    for i in string.gmatch(p40, "[^/]+") do
        table.insert(v43, i);
    end;

    if #v43 == 0 then
        return nil;
    end;

    local v44 = u3.GetCatalog(v43[1], v42);

    if not v44 then
        return nil;
    end;

    if #v43 == 1 then
        return v44;
    end;

    return _traversePath(v44, { table.unpack(v43, 2) });
end;

function u3.ClearCache() -- Line: 392
    -- upvalues: u5 (copy), u6 (copy)
    table.clear(u5);
    table.clear(u6);
end;

return u3;