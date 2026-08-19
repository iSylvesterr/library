-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = t.tuple(t.numberPositive, t.optional(t.boolean), t.optional(t.boolean));
local u2 = t.tuple(t.any, t.CFrame, t.Vector3, t.optional(t.any));
local u3 = t.tuple(t.Vector3, t.numberPositive, t.optional(t.any), t.optional(t.callback), t.optional(t.number));
local u4 = t.tuple(t.CFrame, t.Vector3, t.optional(t.any), t.optional(t.callback), t.optional(t.number));
local u5 = t.tuple(t.Vector3, t.Vector3, t.optional(t.any), t.optional(t.callback), t.optional(t.number));
local Terrain = workspace.Terrain;
local max = math.max;
local abs = math.abs;
local new = Vector3.new;
local BoxHandleAdornment = Instance.new("BoxHandleAdornment");
BoxHandleAdornment.Name = "DebugPart";
BoxHandleAdornment.Size = Vector3.new(1, 1, 1);
BoxHandleAdornment.Transparency = 0.9;
BoxHandleAdornment.Color3 = Color3.fromRGB(255, 255, 255);
BoxHandleAdornment.AlwaysOnTop = false;
BoxHandleAdornment.Adornee = Terrain;
local u6 = {};
u6.__index = u6;

function u6.new(p7, p8, p9) -- Line: 69
    -- upvalues: u1 (copy), u6 (copy), Trove (copy), BoxHandleAdornment (copy)
    assert(u1(p7, p8, p9));
    local v10 = setmetatable({}, u6);
    v10._trove = Trove.new();
    v10._size = p7;
    v10._debugPartitions = p8;
    v10._debugChecks = p9;
    v10._nodes = {};
    v10._nodeDestroyConnections = {};
    v10._nodeCount = 0;
    v10._debugBoxes = {};
    v10._partitions = {};
    v10._boxTrove = v10._trove:Extend();
    v10._debugTemplate = v10._trove:Clone(BoxHandleAdornment);
    v10._debugTemplate.Size = Vector3.new(1, 1, 1) * p7;

    return v10;
end;

function u6.GetTotalObjects(p11) -- Line: 89
    return p11._nodeCount;
end;

function u6.GetObjectsInRadius(p12, u13, u14, p15, u16, p17) -- Line: 93
    -- upvalues: u3 (copy)
    local v18 = p15 or "Default";
    assert(u3(u13, u14, v18, u16, p17));
    local v19, v20 = p12:_getBoundsFromCFrameAndSize(CFrame.new(u13), Vector3.new(1, 1, 1) * u14 * 2);

    return p12:GetObjectsInBounds(v19, v20, v18, function(p21, p22, p23) -- Line: 105
        -- upvalues: u16 (copy), u13 (copy), u14 (copy)
        local v24 = (not u16 or u16(p21, p22, p23)) and (p23.CFrame.Position - u13).Magnitude <= u14;

        return v24;
    end, p17);
end;

function u6.GetObjectsFromCFrameAndSize(p25, p26, p27, p28, p29, p30) -- Line: 111
    -- upvalues: u4 (copy)
    local v31 = p28 or "Default";
    assert(u4(p26, p27, v31, p29, p30));
    local v32, v33 = p25:_getBoundsFromCFrameAndSize(p26, p27);

    return p25:GetObjectsInBounds(v32, v33, v31, p29, p30);
end;

function u6.GetObjectsInBounds(u34, p35, p36, p37, u38, u39) -- Line: 126
    -- upvalues: u5 (copy), Terrain (copy), Debris (copy)
    local v40 = p37 or "Default";
    assert(u5(p35, p36, v40, u38, u39));

    if u34._debugChecks then
        u34._boxTrove:Clean();
        local v41 = u34._boxTrove:Clone(u34._debugTemplate);
        v41.Color3 = Color3.fromRGB(163, 192, 255);
        v41.Size = p36 - p35;
        v41.CFrame = CFrame.new(p35:Lerp(p36, 0.5));
        v41.Parent = Terrain;
        Debris:AddItem(v41, 1);
    end;

    local v42 = u34:_vectorToSpace(p35);
    local v43 = u34:_vectorToSpace(p36);
    local u44 = {};
    local u45 = 0;
    local u46 = {};

    local function maybePush(p47) -- Line: 154
        -- upvalues: u46 (copy), u34 (copy), u38 (copy), u44 (copy), u45 (ref), u39 (copy)
        if u46[p47] then
            return false;
        end;

        if u38 and not u38(p47, u44, u34._nodes[p47]) then
            return false;
        end;

        u46[p47] = true;
        u45 = u45 + 1;
        u44[#u44 + 1] = p47;

        return u39 and u39 <= u45 and true or false;
    end;

    for i = v42.X, v43.X do
        for i2 = v42.Y, v43.Y do
            for i3 = v42.Z, v43.Z do
                local v48 = u34._partitions[Vector3.new(i, i2, i3)];

                if v48 then
                    v48 = v48.ByType[v40];
                end;

                if v48 then
                    for i4 in pairs(v48) do
                        local v49;

                        if u46[i4] or u38 and not u38(i4, u44, u34._nodes[i4]) then
                            v49 = false;
                        else
                            u46[i4] = true;
                            u45 = u45 + 1;
                            u44[#u44 + 1] = i4;

                            if u39 and u39 <= u45 then
                                v49 = true;
                            else
                                v49 = false;
                            end;
                        end;

                        if v49 then
                            return u44, u45;
                        end;
                    end;
                end;
            end;
        end;
    end;

    return u44, u45;
end;

function u6.RemoveNode(p50, p51) -- Line: 190
    -- upvalues: new (copy)
    local v52 = p50._nodes[p51];

    if not v52 then
        return;
    end;

    p50._nodes[p51] = nil;
    p50._nodeCount = p50._nodeCount - 1;
    local v53 = p50._nodeDestroyConnections[p51];

    if v53 then
        p50._nodeDestroyConnections[p51] = nil;
        p50._trove:Remove(v53);
        v53:Disconnect();
    end;

    local v54, v55 = p50:_getSpaceBoundsFromCFrameAndSize(v52.CFrame, v52.Size);

    for i = v54.X, v55.X do
        for i2 = v54.Y, v55.Y do
            for i3 = v54.Z, v55.Z do
                p50:_removeObjectFromPartition(p51, new(i, i2, i3), v52.Type);
            end;
        end;
    end;
end;

function u6.SetNodeBox(p56, p57, p58, p59, p60) -- Line: 216
    -- upvalues: u2 (copy)
    local v61 = p60 or "Default";
    assert(u2(p57, p58, p59, v61));
    local v62, v63 = p56:_findOrCreateNode(p57, v61, p58, p59);
    local v64, v65 = p56:_getSpaceBoundsFromCFrameAndSize(p58, p59);
    local v66, v67;

    if v63 then
        v66 = nil;
        v67 = nil;
    else
        v66, v67 = p56:_getSpaceBoundsFromCFrameAndSize(v62.CFrame, v62.Size);
    end;

    v62.CFrame = p58;
    v62.Size = p59;
    p56:_setNodeBounds(p57, v61, v66, v67, v64, v65);
end;

function u6._findOrCreateNode(u68, u69, p70, p71, p72) -- Line: 239
    local v73 = u68._nodes[u69];

    if v73 then
        return v73, false;
    end;

    local v74 = {
        Size = p72,
        CFrame = p71,
        Type = p70 or "Default"
    };
    u68._nodes[u69] = v74;
    u68._nodeCount = u68._nodeCount + 1;

    if typeof(u69) == "Instance" then
        u68._nodeDestroyConnections[u69] = u68._trove:Connect(u69.Destroying, function() -- Line: 259
            -- upvalues: u68 (copy), u69 (copy)
            u68:RemoveNode(u69);
        end);
    end;

    return v74, true;
end;

function u6._getBoundsFromCFrameAndSize(p75, p76, p77) -- Line: 268
    -- upvalues: new (copy), abs (copy), max (copy)
    local Position = p76.Position;
    local v78 = p76 - Position;
    local v79 = p77 * 0.5;
    local v80 = v78 * new(-v79.X, -v79.Y, -v79.Z);
    local v81 = v78 * new(v79.X, v79.Y, v79.Z);
    local v82 = v78 * new(-v79.X, v79.Y, -v79.Z);
    local v83 = v78 * new(-v79.X, -v79.Y, v79.Z);
    local v84 = max(abs(v80.X), abs(v81.X), abs(v82.X), (abs(v83.X)));
    local v85 = max(abs(v80.Y), abs(v81.Y), abs(v82.Y), (abs(v83.Y)));
    local v86 = max(abs(v80.Z), abs(v81.Z), abs(v82.Z), (abs(v83.Z)));

    return new(Position.X - v84, Position.Y - v85, Position.Z - v86), new(Position.X + v84, Position.Y + v85, Position.Z + v86);
end;

function u6._getSpaceBoundsFromCFrameAndSize(p87, p88, p89) -- Line: 284
    local v90, v91 = p87:_getBoundsFromCFrameAndSize(p88, p89);

    return p87:_vectorToSpace(v90), p87:_vectorToSpace(v91);
end;

function u6._vectorToSpace(p92, p93) -- Line: 293
    -- upvalues: new (copy)
    return new(math.floor(p93.X / p92._size), math.floor(p93.Y / p92._size), (math.floor(p93.Z / p92._size)));
end;

function u6._setNodeBounds(p94, p95, p96, p97, p98, p99, p100) -- Line: 297
    -- upvalues: new (copy)
    if p97 == p99 and p98 == p100 then
        return;
    end;

    if not (p97 and p98) then
        for i = p99.X, p100.X do
            for i2 = p99.Y, p100.Y do
                for i3 = p99.Z, p100.Z do
                    p94:_addObjectToPartition(p95, new(i, i2, i3), p96);
                end;
            end;
        end;

        return;
    end;

    for i = p97.X, p98.X do
        for i2 = p97.Y, p98.Y do
            for i3 = p97.Z, p98.Z do
                if i < p99.X or (p100.X < i or (i2 < p99.Y or (p100.Y < i2 or (i3 < p99.Z or p100.Z < i3)))) then
                    p94:_removeObjectFromPartition(p95, new(i, i2, i3), p96);
                end;
            end;
        end;
    end;

    for i = p99.X, p100.X do
        for i2 = p99.Y, p100.Y do
            for i3 = p99.Z, p100.Z do
                if i < p97.X or (p98.X < i or (i2 < p97.Y or (p98.Y < i2 or (i3 < p97.Z or p98.Z < i3)))) then
                    p94:_addObjectToPartition(p95, new(i, i2, i3), p96);
                end;
            end;
        end;
    end;
end;

function u6._addObjectToPartition(p101, p102, p103, p104) -- Line: 354
    local v105 = p101._partitions[p103];

    if not v105 then
        v105 = {
            Total = 0,
            ByType = {},
            CountByType = {}
        };
        p101._partitions[p103] = v105;
        p101:_createPartitionBox(p103);
    end;

    local v106 = p104 or "Default";
    local v107 = v105.ByType[v106];

    if not v107 then
        v107 = {};
        v105.ByType[v106] = v107;
        v105.CountByType[v106] = 0;
    end;

    if not v107[p102] then
        v107[p102] = true;
        local CountByType = v105.CountByType;
        CountByType[v106] = CountByType[v106] + 1;
        v105.Total = v105.Total + 1;
    end;
end;

function u6._removeObjectFromPartition(p108, p109, p110, p111) -- Line: 387
    local v112 = p108._partitions[p110];

    if not v112 then
        return;
    end;

    local v113 = p111 or "Default";
    local v114 = v112.ByType[v113];

    if not (v114 and v114[p109]) then
        return;
    end;

    v114[p109] = nil;
    local CountByType = v112.CountByType;
    CountByType[v113] = CountByType[v113] - 1;
    v112.Total = v112.Total - 1;

    if v112.CountByType[v113] <= 0 then
        local CountByType2 = v112.CountByType;
        v112.ByType[v113] = nil;
        CountByType2[v113] = nil;
    end;

    if v112.Total <= 0 then
        p108:_removePartitionBox(p110);
        p108._partitions[p110] = nil;
    end;
end;

function u6._createDebugBox(p115, p116, p117) -- Line: 418
    -- upvalues: Terrain (copy), Debris (copy)
    if not p115._debugChecks then
        return;
    end;

    local v118 = p115._boxTrove:Clone(p115._debugTemplate);
    v118.Color3 = p117 and Color3.new(0, 1, 0) or Color3.new(1, 0, 0);
    v118.CFrame = CFrame.new((p116.X + 0.5) * p115._size, (p116.Y + 0.5) * p115._size, (p116.Z + 0.5) * p115._size);
    v118.Transparency = p117 and 0.8 or 0.99;
    v118.AlwaysOnTop = true;
    v118.Parent = Terrain;
    Debris:AddItem(v118, 1);
end;

function u6._createPartitionBox(p119, p120) -- Line: 438
    -- upvalues: Terrain (copy)
    if not p119._debugPartitions or p119._debugBoxes[p120] then
        return;
    end;

    local v121 = p119._trove:Clone(p119._debugTemplate);
    p119._debugBoxes[p120] = v121;
    v121.CFrame = CFrame.new((p120.X + 0.5) * p119._size, (p120.Y + 0.5) * p119._size, (p120.Z + 0.5) * p119._size);
    v121.Parent = Terrain;
end;

function u6._removePartitionBox(p122, p123) -- Line: 455
    local v124 = p122._debugPartitions and p122._debugBoxes[p123];

    if v124 then
        p122._trove:Remove(v124);
        v124:Destroy();
        p122._debugBoxes[p123] = nil;
    end;
end;

function u6.Destroy(p125) -- Line: 464
    p125._partitions = nil;
    p125._nodes = nil;
    p125._debugBoxes = nil;
    p125._trove:Destroy();
    p125._trove = nil;
end;

return u6;