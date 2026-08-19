-- Decompiled with Potassium's decompiler.

local v1 = {};
local u2 = {};
u2.__index = u2;

local function asInstance(p3) -- Line: 35
    return p3;
end;

local function isPoolable(p4) -- Line: 39
    local v5;

    if typeof(p4) == "Instance" then
        v5 = p4:IsA("BasePart") or p4:IsA("Model");
    else
        v5 = false;
    end;

    return v5;
end;

local function destroy(p6) -- Line: 43
    pcall(p6.Destroy, p6);
end;

local function unparent(u7) -- Line: 47
    return pcall(function() -- Line: 48
        -- upvalues: u7 (copy)
        u7.Parent = nil;
    end);
end;

local function park(u8, u9) -- Line: 53
    return pcall(function() -- Line: 54
        -- upvalues: u9 (copy), u8 (copy)
        u9.Parent = u8.Storage;
    end);
end;

local function clone(p10) -- Line: 59
    return p10.Template:Clone();
end;

function u2.Acquire(p11) -- Line: 63
    assert(not p11.Destroyed, "Cannot acquire from a destroyed ObjectPool");
    local u12 = table.remove(p11.Available);

    while u12 and (u12.Parent ~= p11.Storage or not pcall(function() -- Line: 48
        -- upvalues: u12 (copy)
        u12.Parent = nil;
    end)) do
        pcall(u12.Destroy, u12);
        u12 = table.remove(p11.Available);
    end;

    local v13 = u12 or p11.Template:Clone();
    p11.NextLease = p11.NextLease + 1;
    p11.Active[v13] = p11.NextLease;

    return v13, p11.NextLease;
end;

function u2.Release(u14, u15, p16) -- Line: 83
    if u14.Destroyed then
        return false;
    end;

    if u14.Active[u15] ~= p16 then
        return false;
    end;

    u14.Active[u15] = nil;

    if #u14.Available >= u14.MaxRetained then
        pcall(u15.Destroy, u15);

        return true;
    end;

    if not pcall(function() -- Line: 54
        -- upvalues: u15 (copy), u14 (copy)
        u15.Parent = u14.Storage;
    end) then
        pcall(u15.Destroy, u15);

        return true;
    end;

    if u14.Reset then
        local success, result = pcall(u14.Reset, u15);

        if not success then
            warn((`ObjectPool reset failed; discarding object: {tostring(result)}`));
            pcall(u15.Destroy, u15);

            return true;
        end;
    end;

    table.insert(u14.Available, u15);

    return true;
end;

function u2.IsAcquired(p17, p18, p19) -- Line: 117
    return not p17.Destroyed and p17.Active[p18] == p19;
end;

function u2.Destroy(p20) -- Line: 121
    if p20.Destroyed then
        return;
    end;

    p20.Destroyed = true;

    for i in pairs(p20.Active) do
        pcall(i.Destroy, i);
    end;

    p20.Storage:Destroy();
    table.clear(p20.Available);
    table.clear(p20.Active);
end;

function v1.new(p21, p22) -- Line: 136
    -- upvalues: u2 (copy)
    local v23;

    if typeof(p21) == "Instance" then
        v23 = p21:IsA("BasePart") or p21:IsA("Model");
    else
        v23 = false;
    end;

    assert(v23, "ObjectPool template must be a BasePart, MeshPart, or Model");
    local v24 = p22 or {};
    local v25 = math.floor(v24.MaxRetained or 32);
    local v26 = math.max(0, v25);
    local v27 = math.floor(v24.InitialSize or 0);
    local v28 = math.clamp(v27, 0, v26);
    local Folder = Instance.new("Folder");
    Folder.Name = "ObjectPool";
    local u29 = setmetatable({
        NextLease = 0,
        Destroyed = false,
        Template = p21,
        Storage = Folder,
        Available = {},
        Active = {},
        MaxRetained = v26,
        Reset = v24.Reset
    }, u2);

    for _ = 1, v28 do
        local u30 = u29.Template:Clone();

        if pcall(function() -- Line: 54
            -- upvalues: u30 (copy), u29 (copy)
            u30.Parent = u29.Storage;
        end) then
            table.insert(u29.Available, u30);
        else
            pcall(u30.Destroy, u30);
        end;
    end;

    return u29;
end;

return v1;