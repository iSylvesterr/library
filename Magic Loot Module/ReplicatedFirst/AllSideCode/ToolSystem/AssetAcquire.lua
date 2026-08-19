-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local AssetPaths = UtilsSystem.AssetPaths;
local AssetRegistry = UtilsSystem.AssetRegistry;
local ResRestore = UtilsSystem.ResRestore;
local ObjectPoolUtil = UtilsSystem.ObjectPoolUtil;
local u1 = {};

local function _normalizeOptions(p2) -- Line: 169
    -- upvalues: AssetPaths (copy)
    local v3 = {
        clone = true,
        restore = true,
        usePool = false,
        poolTemplate = nil,
        scope = AssetPaths.Scope.Shared
    };

    if not p2 then
        return v3;
    end;

    if p2.scope ~= nil then
        v3.scope = p2.scope;
    end;

    if p2.clone ~= nil then
        v3.clone = p2.clone;
    end;

    if p2.restore ~= nil then
        v3.restore = p2.restore;
    end;

    if p2.usePool ~= nil then
        v3.usePool = p2.usePool;
    end;

    if p2.poolTemplate ~= nil then
        v3.poolTemplate = p2.poolTemplate;
    end;

    return v3;
end;

local function _maybeRestore(p4, p5) -- Line: 203
    -- upvalues: ResRestore (copy)
    if p5 then
        ResRestore.PrepareInstance(p4);
    end;
end;

u1.Scope = AssetPaths.Scope;

function u1.Get(p6, p7) -- Line: 224
    -- upvalues: _normalizeOptions (copy), AssetPaths (copy), ObjectPoolUtil (copy), ResRestore (copy)
    if type(p6) ~= "string" or p6 == "" then
        return nil;
    end;

    local v8 = _normalizeOptions(p7);
    local v9 = AssetPaths.Resolve(p6, v8.scope);

    if not v9 then
        return nil;
    end;

    if v8.usePool then
        return ObjectPoolUtil.getObjectFromPool(v8.poolTemplate or v9);
    end;

    if v8.clone == false then
        return v9;
    end;

    local v10 = v9:Clone();

    if v8.restore == true then
        ResRestore.PrepareInstance(v10);
    end;

    return v10;
end;

function u1.GetModel(p11, p12, p13) -- Line: 259
    -- upvalues: AssetRegistry (copy), AssetPaths (copy), u1 (copy)
    if type(p11) ~= "string" or p11 == "" then
        return nil;
    end;

    if type(p12) ~= "string" or p12 == "" then
        return nil;
    end;

    local v14 = AssetRegistry.BuildModelPath(p11, p12);

    if p11 == AssetRegistry.ModelCategory.Enemy then
        p13 = not p13 and {} or table.clone(p13);
        p13.scope = AssetPaths.Scope.Shared;
    end;

    local v15 = u1.Get(v14, p13);

    if v15 and v15:IsA("Model") then
        return v15;
    end;

    return nil;
end;

function u1.GetUI(p16, p17) -- Line: 286
    -- upvalues: u1 (copy), AssetRegistry (copy)
    if type(p16) == "string" and p16 ~= "" then
        return u1.Get(AssetRegistry.BuildUIPath(p16), p17);
    end;

    return nil;
end;

function u1.GetTemplate(p18, p19) -- Line: 299
    -- upvalues: AssetPaths (copy)
    return AssetPaths.Resolve(p18, p19 or AssetPaths.Scope.Shared);
end;

return u1;