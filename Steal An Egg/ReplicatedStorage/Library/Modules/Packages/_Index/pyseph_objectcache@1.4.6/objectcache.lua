-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Mutex = require(ReplicatedStorage.Library.Modules.Mutex);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local InvisibleRenderSpace = workspace:WaitForChild("__OBJECTS"):WaitForChild("InvisibleRenderSpace");
local v2 = InvisibleRenderSpace.Size * 0.5;
local u3 = InvisibleRenderSpace.Position - v2;
local u4 = InvisibleRenderSpace.Position + v2;
local u5 = Constants.IS_MOBILE and 0.006 or 0.004;
local u6 = table.create(10000);
local u7 = table.create(10000);
local u8 = Constants.IS_CLIENT and {} or nil;
local u9 = false;
local u10 = coroutine.create(function() -- Line: 27, Name: UpdateMovement
    -- upvalues: u6 (copy), u7 (copy), u9 (ref)
    while true do
        workspace:BulkMoveTo(u6, u7, Enum.BulkMoveMode.FireCFrameChanged);
        table.clear(u6);
        table.clear(u7);
        u9 = false;
        coroutine.yield();
    end;
end);
local u11 = {};
u11.__index = u11;

local function randFloat(p12, p13) -- Line: 60
    return math.random() * (p13 - p12) + p12;
end;

local function hiddenCFrame() -- Line: 64
    -- upvalues: u3 (ref), u4 (ref)
    local new = CFrame.new;
    local X = u3.X;
    local X2 = u4.X;
    local v14 = math.random() * (X2 - X) + X;
    local Y = u3.Y;
    local Y2 = u4.Y;
    local v15 = math.random() * (Y2 - Y) + Y;
    local Z = u3.Z;
    local Z2 = u4.Z;

    return new(v14, v15, math.random() * (Z2 - Z) + Z);
end;

function u11._GetNew(p16, p17, p18) -- Line: 72
    -- upvalues: u3 (ref), u4 (ref), u5 (copy)
    if p18 then
        warn((`ObjectCache: Cache retrieval exceeded preallocated amount! expanding by {p17}...`));
    end;

    local _FreeObjects = p16._FreeObjects;
    local v19 = #p16._FreeObjects;
    local CacheHolder = p16.CacheHolder;
    local _IsTemplateModel = p16._IsTemplateModel;
    local _Template = p16._Template;
    local v20 = table.create(p17);
    local v21 = table.create(p17);
    local v22 = os.clock();

    for i = v19 + 1, v19 + p17 do
        local v23 = _Template:Clone();
        local v24;

        if _IsTemplateModel then
            v24 = v23.PrimaryPart;
        else
            v24 = v23;
        end;

        _FreeObjects[i] = v24;
        p16._DesiredAnchored[v24] = v24.Anchored;
        v24.Anchored = true;
        v23.Parent = CacheHolder;
        local v25 = i - v19;
        v20[v25] = v24;
        local new = CFrame.new;
        local X = u3.X;
        local X2 = u4.X;
        local v26 = math.random() * (X2 - X) + X;
        local Y = u3.Y;
        local Y2 = u4.Y;
        local v27 = math.random() * (Y2 - Y) + Y;
        local Z = u3.Z;
        local Z2 = u4.Z;
        v21[v25] = new(v26, v27, math.random() * (Z2 - Z) + Z);

        if u5 <= os.clock() - v22 then
            task.wait();
            v22 = os.clock();
        end;
    end;

    workspace:BulkMoveTo(v20, v21, Enum.BulkMoveMode.FireCFrameChanged);

    return table.remove(_FreeObjects);
end;

function u11.GetPart(u28, p29) -- Line: 116
    -- upvalues: u1 (copy), u6 (copy), u7 (copy), u9 (ref), u10 (copy)
    local u30 = table.remove(u28._FreeObjects);

    if not u30 then
        u28._ExpandMutex:run(function() -- Line: 119
            -- upvalues: u1 (ref), u28 (copy), u30 (ref)
            u1:AtTrace():Log("free objects at creation:", u28._FreeObjects, "SELF", u28);
            u30 = u28:_GetNew(u28._ExpandAmount, true);
            u1:AtTrace():Log("part found after expanding cache:", u30, "self:", u28);
        end);
    end;

    assert(u30, "ObjectCache: failed to allocate part");
    u28._Objects[u30] = nil;

    if p29 then
        table.insert(u6, u30);
        table.insert(u7, p29);

        if not u9 then
            u9 = true;
            task.defer(u10);
        end;
    end;

    local u31 = u28._DesiredAnchored[u30];

    if u31 ~= nil then
        u28._DesiredAnchored[u30] = nil;
        task.defer(function() -- Line: 146
            -- upvalues: u30 (ref), u31 (copy)
            u30.Anchored = u31;
        end);
    end;

    return u30;
end;

function u11.ReturnPart(p32, p33) -- Line: 154
    -- upvalues: u6 (copy), u7 (copy), hiddenCFrame (copy), u9 (ref), u10 (copy)
    if p32._Objects[p33] then
        return;
    end;

    p32._Objects[p33] = true;
    p32._DesiredAnchored[p33] = p33.Anchored;
    p33.Anchored = true;
    table.insert(p32._FreeObjects, p33);
    table.insert(u6, p33);
    table.insert(u7, hiddenCFrame());

    if not u9 then
        u9 = true;
        task.defer(u10);
    end;
end;

function u11.Update(p34) -- Line: 174
    -- upvalues: u10 (copy)
    task.spawn(u10);
end;

function u11.ExpandCache(u35, u36) -- Line: 178
    local v37 = typeof(u36) ~= "number" and true or u36 >= 0;
    local v38 = `Invalid argument #1 to 'ObjectCache:ExpandCache' (positive number expected, got {typeof(u36)})`;
    assert(v37, v38);
    u35._ExpandMutex:run(function() -- Line: 184
        -- upvalues: u35 (copy), u36 (copy)
        u35:_GetNew(u36, false);
    end);

    return u35;
end;

function u11.SetExpandAmount(p39, p40) -- Line: 190
    local v41 = typeof(p40) ~= "number" and true or p40 > 0;
    local v42 = `Invalid argument #1 to 'ObjectCache:SetExpandAmount' (positive number expected, got {typeof(p40)})`;
    assert(v41, v42);
    p39._ExpandAmount = p40;

    return p39;
end;

function u11.IsInUse(p43, p44) -- Line: 200
    return p43._Objects[p44] == nil;
end;

local function CollectFlush(p45, p46, p47) -- Line: 204
    -- upvalues: u6 (copy), u7 (copy)
    debug.profilebegin("ObjectCache :: CollectFlush");

    for _, v in ipairs(p45._FreeObjects) do
        table.insert(u6, v);
        local new = CFrame.new;
        local X = p46.X;
        local X2 = p47.X;
        local v48 = math.random() * (X2 - X) + X;
        local Y = p46.Y;
        local Y2 = p47.Y;
        local v49 = math.random() * (Y2 - Y) + Y;
        local Z = p46.Z;
        local Z2 = p47.Z;
        local v50 = math.random() * (Z2 - Z) + Z;
        table.insert(u7, new(v48, v49, v50));
    end;

    debug.profileend();
end;

function u11.FlushToBounds(p51, p52, p53) -- Line: 218
    -- upvalues: CollectFlush (copy), u9 (ref), u10 (copy)
    CollectFlush(p51, p52, p53);

    if not u9 then
        u9 = true;
        task.defer(u10);
    end;
end;

function u11.Destroy(p54) -- Line: 227
    -- upvalues: u8 (copy)
    debug.profilebegin("ObjectCache :: Destroy");

    if u8 then
        u8[p54] = nil;
    end;

    p54.CacheHolder:Destroy();
    debug.profileend();
end;

local function GetCacheContainer() -- Line: 238
    local Folder = Instance.new("Folder");
    Folder.Name = "ObjectCache";

    return Folder;
end;

return {
    new = function(p55, p56, p57) -- Line: 246, Name: new
        -- upvalues: Mutex (copy), u11 (copy), u3 (ref), u4 (ref), u5 (copy), u8 (copy)
        local v58 = typeof(p55);
        local v59 = `Invalid argument #1 to 'ObjectCache.new' (BasePart expected, got {v58})`;
        assert(v58 == "Instance", v59);
        local v60 = p55:IsA("BasePart") or p55:IsA("Model");
        local v61 = `Invalid argument #1 to 'ObjectCache.new' (BasePart or Model expected, got {p55.ClassName})`;
        assert(v60, v61);
        assert(p55.Archivable, "ObjectCache: Cannot use template object provided, as it has Archivable set to false.");

        if p55:IsA("Model") then
            assert(p55.PrimaryPart ~= nil, "Invalid Template provided to \'ObjectCache.new\': Model has no PrimaryPart set!");
        end;

        local v62 = typeof(p56);
        local v63 = `Invalid argument #2 to 'ObjectCache.new' (number expected, got {v62})`;
        assert(p56 == nil and true or v62 == "number", v63);
        local v64 = `Invalid argument #2 to 'ObjectCache.new' (positive number expected, got {p56})`;
        assert(p56 == nil and true or p56 >= 0, v64);
        local v65 = typeof(p57);
        local v66 = `Invalid argument #3 to 'ObjectCache.new' (Instance expected, got {v65})`;
        assert(p57 == nil and true or v65 == "Instance", v66);
        local v67 = p56 or 1;
        local Folder = Instance.new("Folder");
        Folder.Name = "ObjectCache";
        local v68 = table.create(v67);
        local v69 = {};
        local v70 = p55:IsA("Model");
        local v71 = {
            CacheHolder = Folder,
            _ExpandAmount = p56 or 1,
            _Template = p55,
            _FreeObjects = v68,
            _Objects = {},
            _IsTemplateModel = v70,
            _PreallocatedAmount = v67,
            _DesiredAnchored = v69,
            _ExpandMutex = Mutex.new()
        };
        local v72 = setmetatable(v71, u11);

        if p57 then
            Folder.Parent = p57;
        else
            Folder.Parent = workspace;
        end;

        local v73 = os.clock();

        for i = 1, v67 do
            local v74 = p55:Clone();
            local v75;

            if v70 then
                v75 = v74.PrimaryPart;
            else
                v75 = v74;
            end;

            v68[i] = v75;
            v69[v75] = v75.Anchored;
            v75.Anchored = true;
            v74.Parent = Folder;
            local new = CFrame.new;
            local X = u3.X;
            local X2 = u4.X;
            local v76 = math.random() * (X2 - X) + X;
            local Y = u3.Y;
            local Y2 = u4.Y;
            local v77 = math.random() * (Y2 - Y) + Y;
            local Z = u3.Z;
            local Z2 = u4.Z;
            v75.CFrame = new(v76, v77, math.random() * (Z2 - Z) + Z);

            if u5 <= os.clock() - v73 then
                task.wait();
                v73 = os.clock();
            end;
        end;

        if u8 then
            u8[v72] = true;
        end;

        return v72;
    end,

    SetInvisibleBounds = function(p78, p79) -- Line: 338, Name: SetInvisibleBounds
        -- upvalues: u3 (ref), u4 (ref)
        u3 = p78;
        u4 = p79;
    end,

    is = function(p80) -- Line: 343, Name: is
        -- upvalues: u11 (copy)
        if typeof(p80) == "table" then
            return getmetatable(p80) == u11;
        end;

        return false;
    end,

    GetRandomHiddenCFrame = hiddenCFrame
};