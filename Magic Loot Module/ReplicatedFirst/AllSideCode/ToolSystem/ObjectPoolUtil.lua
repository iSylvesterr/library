-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local VisibleMgr = UtilsSystem.VisibleMgr;
local ResRestore = UtilsSystem.ResRestore;
local u1 = {};
local u2 = {};

local function _ensurePoolFolder() -- Line: 153
    -- upvalues: ReplicatedStorage (copy)
    local ObjectPool = ReplicatedStorage:FindFirstChild("ObjectPool");

    if not ObjectPool then
        ObjectPool = Instance.new("Folder");
        ObjectPool.Name = "ObjectPool";
        ObjectPool.Parent = ReplicatedStorage;
    end;

    return ObjectPool;
end;

local function _getPoolFolder() -- Line: 170
    -- upvalues: ReplicatedStorage (copy)
    local ObjectPool = ReplicatedStorage:FindFirstChild("ObjectPool");

    if not ObjectPool then
        ObjectPool = Instance.new("Folder");
        ObjectPool.Name = "ObjectPool";
        ObjectPool.Parent = ReplicatedStorage;
    end;

    return ObjectPool;
end;

local function _registerInIndex(p3) -- Line: 179
    -- upvalues: u2 (copy)
    local v4 = p3:GetAttribute("ModelName");

    if type(v4) ~= "string" or v4 == "" then
        return;
    end;

    local v5 = u2[v4];

    if not v5 then
        v5 = {};
        u2[v4] = v5;
    end;

    table.insert(v5, p3);
end;

local function _takeFromIndex(p6) -- Line: 198
    -- upvalues: u2 (copy)
    local v7 = u2[p6];

    if not v7 then
        return nil;
    end;

    while #v7 > 0 do
        local v8 = table.remove(v7);

        if v8 and v8.Parent ~= nil then
            return v8;
        end;
    end;

    return nil;
end;

local function _unregisterFromIndex(p9) -- Line: 219
    -- upvalues: u2 (copy)
    local v10 = p9:GetAttribute("ModelName");

    if type(v10) ~= "string" then
        return;
    end;

    local v11 = u2[v10];

    if not v11 then
        return;
    end;

    for i, v in v11 do
        if v == p9 then
            table.remove(v11, i);

            return;
        end;
    end;
end;

local function _rebuildIndexFromFolder(p12) -- Line: 243
    -- upvalues: u2 (copy)
    table.clear(u2);

    for _, child in p12:GetChildren() do
        local v13 = child:GetAttribute("ModelName");

        if type(v13) == "string" then
            if v13 ~= "" then
                local v14 = u2[v13];

                if not v14 then
                    v14 = {};
                    u2[v13] = v14;
                end;

                table.insert(v14, child);
            end;
        end;
    end;
end;

local function _refreshFreshTimeAttribute(p15) -- Line: 255
    p15:SetAttribute("FreshTime", os.time());
end;

local function _setObjectAttributes(p16) -- Line: 264
    p16:SetAttribute("ModelName", p16.Name);
    p16:SetAttribute("FreshTime", os.time());
end;

function u1.addObjectToPool(p17) -- Line: 278
    -- upvalues: ResRestore (copy), ReplicatedStorage (copy), u2 (copy)
    local v18 = p17:Clone();

    if ResRestore then
        ResRestore.PrepareInstance(v18);
    end;

    v18:SetAttribute("ModelName", v18.Name);
    v18:SetAttribute("FreshTime", os.time());
    local ObjectPool = ReplicatedStorage:FindFirstChild("ObjectPool");

    if not ObjectPool then
        ObjectPool = Instance.new("Folder");
        ObjectPool.Name = "ObjectPool";
        ObjectPool.Parent = ReplicatedStorage;
    end;

    v18.Parent = ObjectPool;
    local v19 = v18:GetAttribute("ModelName");

    if type(v19) == "string" then
        if v19 == "" then
            return;
        end;

        local v20 = u2[v19];

        if not v20 then
            v20 = {};
            u2[v19] = v20;
        end;

        table.insert(v20, v18);
    end;
end;

function u1.backToPool(p21) -- Line: 296
    -- upvalues: Debris (copy), VisibleMgr (copy), ReplicatedStorage (copy), u2 (copy)
    if p21.Parent == nil then
        return;
    end;

    local v22 = p21:GetAttribute("ModelName");

    if type(v22) ~= "string" or v22 == "" then
        Debris:AddItem(p21, 0);

        return;
    end;

    p21.Name = v22;
    p21:SetAttribute("FreshTime", os.time());

    if VisibleMgr then
        VisibleMgr.AnchoredAll(p21);
        VisibleMgr.SpeedDown(p21);
    end;

    local ObjectPool = ReplicatedStorage:FindFirstChild("ObjectPool");

    if not ObjectPool then
        ObjectPool = Instance.new("Folder");
        ObjectPool.Name = "ObjectPool";
        ObjectPool.Parent = ReplicatedStorage;
    end;

    p21.Parent = ObjectPool;
    local v23 = p21:GetAttribute("ModelName");

    if type(v23) == "string" then
        if v23 == "" then
            return;
        end;

        local v24 = u2[v23];

        if not v24 then
            v24 = {};
            u2[v23] = v24;
        end;

        table.insert(v24, p21);
    end;
end;

function u1.getObjectFromPool(p25) -- Line: 326
    -- upvalues: _takeFromIndex (copy), ResRestore (copy), u1 (copy)
    local Name = p25.Name;
    local v26 = _takeFromIndex(Name);

    if v26 then
        if ResRestore then
            ResRestore.PrepareInstance(v26);
        end;

        v26.Parent = workspace;

        return v26;
    end;

    u1.addObjectToPool(p25);
    local v27 = _takeFromIndex(Name);

    if not v27 then
        return nil;
    end;

    v27.Parent = workspace;

    return v27;
end;

function u1.clearIdleObjects() -- Line: 353
    -- upvalues: ReplicatedStorage (copy), _unregisterFromIndex (copy), Debris (copy)
    local ObjectPool = ReplicatedStorage:FindFirstChild("ObjectPool");

    if not ObjectPool then
        ObjectPool = Instance.new("Folder");
        ObjectPool.Name = "ObjectPool";
        ObjectPool.Parent = ReplicatedStorage;
    end;

    local v28 = os.time();

    for _, child in ObjectPool:GetChildren() do
        local v29 = child:GetAttribute("FreshTime");

        if type(v29) == "number" and v28 - v29 > 60 then
            _unregisterFromIndex(child);
            Debris:AddItem(child, 0);
        end;
    end;
end;

function u1.Init() -- Line: 371
    -- upvalues: ReplicatedStorage (copy), u2 (copy)
    local ObjectPool = ReplicatedStorage:FindFirstChild("ObjectPool");

    if not ObjectPool then
        ObjectPool = Instance.new("Folder");
        ObjectPool.Name = "ObjectPool";
        ObjectPool.Parent = ReplicatedStorage;
    end;

    table.clear(u2);

    for _, child in ObjectPool:GetChildren() do
        local v30 = child:GetAttribute("ModelName");

        if type(v30) == "string" then
            if v30 ~= "" then
                local v31 = u2[v30];

                if not v31 then
                    v31 = {};
                    u2[v30] = v31;
                end;

                table.insert(v31, child);
            end;
        end;
    end;

    return ObjectPool;
end;

return u1;