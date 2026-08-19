-- Decompiled with Potassium's decompiler.

local Table = require(script:WaitForChild("Table"));
local Workspace = game:GetService("Workspace");
local u1 = {};
u1.__index = u1;
u1.__type = "PartCache";
local u2 = CFrame.new(0, 1000000000, 0);

function u1.new(p3, p4, p5) -- Line: 10
    -- upvalues: Workspace (copy), u1 (copy), u2 (copy), Table (copy)
    if not p5 then
        p5 = Instance.new("Folder");
        p5.Parent = Workspace;
    end;

    assert(p4 > 0, "PrecreatedParts can not be negative!");

    if p4 == 0 then
        warn("PrecreatedParts is 0! This may have adverse effects when initially using the cache.");
    end;

    if not p3.Archivable then
        warn("The template\'s Archivable property has been set to false, which prevents it from being cloned. It will temporarily be set to true.");
    end;

    local Archivable = p3.Archivable;
    p3.Archivable = true;
    local v6 = p3:Clone();
    p3.Archivable = Archivable;
    local v7 = {
        ExpansionSize = 30,
        Open = {},
        InUse = {},
        CurrentCacheParent = p5 or Workspace,
        Template = v6
    };
    setmetatable(v7, u1);

    for _ = 1, p4 or 5 do
        local v8 = v6:Clone();
        v8.CFrame = u2;
        v8.Anchored = true;
        v8.Parent = v7.CurrentCacheParent;
        Table.insert(v7.Open, v8);
    end;

    v7.Template.Parent = nil;

    return v7;
end;

function u1.GetPart(p9) -- Line: 57
    -- upvalues: u1 (copy), u2 (copy), Table (copy)
    local v10 = getmetatable(p9) == u1;
    assert(v10, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("GetPart", "PartCache.new"));

    if #p9.Open == 0 then
        warn("No parts available in the cache! Creating [" .. p9.ExpansionSize .. "] new part instance(s) - this amount can be edited by changing the ExpansionSize property of the PartCache instance... (This cache now contains a grand total of " .. tostring(#p9.Open + #p9.InUse + p9.ExpansionSize) .. " parts.)");

        for _ = 1, p9.ExpansionSize do
            local v11 = p9.Template:Clone();
            v11.CFrame = u2;
            v11.Anchored = true;
            v11.Parent = p9.CurrentCacheParent;
            Table.insert(p9.Open, v11);
        end;
    end;

    local v12 = p9.Open[#p9.Open];
    p9.Open[#p9.Open] = nil;
    Table.insert(p9.InUse, v12);

    return v12;
end;

function u1.ReturnPart(p13, p14) -- Line: 90
    -- upvalues: u1 (copy), Table (copy), u2 (copy)
    local v15 = getmetatable(p13) == u1;
    assert(v15, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("ReturnPart", "PartCache.new"));
    local v16 = Table.indexOf(p13.InUse, p14);

    if v16 == nil then
        error("Attempted to return part \"" .. p14.Name .. "\" (" .. p14:GetFullName() .. ") to the cache, but it\'s not in-use! Did you call this on the wrong part?");

        return;
    end;

    Table.remove(p13.InUse, v16);
    Table.insert(p13.Open, p14);
    p14.CFrame = u2;
    p14.Anchored = true;
end;

function u1.SetCacheParent(p17, p18) -- Line: 117
    -- upvalues: u1 (copy), Workspace (copy)
    local v19 = getmetatable(p17) == u1;
    assert(v19, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("SetCacheParent", "PartCache.new"));
    local v20 = p18:IsDescendantOf(Workspace) or p18 == Workspace;
    assert(v20, "Cache parent is not a descendant of Workspace! Parts should be kept where they will remain in the visible world.");
    p17.CurrentCacheParent = p18;

    for i = 1, #p17.Open do
        p17.Open[i].Parent = p18;
    end;

    for i = 1, #p17.InUse do
        p17.InUse[i].Parent = p18;
    end;
end;

function u1.Expand(p21, p22) -- Line: 141
    -- upvalues: u1 (copy), u2 (copy), Table (copy)
    local v23 = getmetatable(p21) == u1;
    assert(v23, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Expand", "PartCache.new"));

    if p22 == nil then
        p22 = p21.ExpansionSize;
    end;

    for _ = 1, p22 do
        local v24 = p21.Template:Clone();
        v24.CFrame = u2;
        v24.Anchored = true;
        v24.Parent = p21.CurrentCacheParent;
        Table.insert(p21.Open, v24);
    end;
end;

function u1.Dispose(p25) -- Line: 163
    -- upvalues: u1 (copy)
    local v26 = getmetatable(p25) == u1;
    assert(v26, ("Cannot statically invoke method \'%s\' - It is an instance method. Call it on an instance of this class created via %s"):format("Dispose", "PartCache.new"));

    for i = 1, #p25.Open do
        p25.Open[i]:Destroy();
    end;

    for i = 1, #p25.InUse do
        p25.InUse[i]:Destroy();
    end;

    p25.Template:Destroy();
    p25.Open = {};
    p25.InUse = {};
    p25.CurrentCacheParent = nil;
    p25.GetPart = nil;
    p25.ReturnPart = nil;
    p25.SetCacheParent = nil;
    p25.Expand = nil;
    p25.Dispose = nil;
end;

return u1;