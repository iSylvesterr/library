-- Decompiled with Potassium's decompiler.

local RunService = game:GetService("RunService");
local ServerScriptService = game:GetService("ServerScriptService");
local Players = game:GetService("Players");
game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local u1 = RunService:IsClient();
local Utility = script.Utility;
local Templates = script.Templates;
local BVH = require(Utility.BVH);
local SimpleSignal = require(Utility.SimpleSignal);
local JumpTable = require(Utility.JumpTable);
local SearchFor = require(script.SearchFor);
local PlayerLookup = require(script.PlayerLookup);
local Zones = require(script.Zones);
local characterObjects = PlayerLookup.characterObjects;
local ClientWorker = Templates.ClientWorker;
local ServerWorker = Templates.ServerWorker;
local v2 = {};
local u3 = {
    __index = v2
};
local Folder = Instance.new("Folder");
Folder.Name = "SIMPLEZONE_ZONE_ACTORS";

if u1 then
    ServerScriptService = Players.LocalPlayer.PlayerScripts or ServerScriptService;
end;

Folder.Parent = ServerScriptService;

if u1 then
    ServerWorker = ClientWorker or ServerWorker;
end;

local Folder2 = Instance.new("Folder");
Folder2.Name = `SIMPLE_ZONE_QUERY_SPACES:CLIENT:{u1}`;
Folder2.Parent = game:GetService("ReplicatedStorage");
local u13 = JumpTable({
    Block = function(p4, p5, p6) -- Line: 76, Name: Block
        return p4:GetPartBoundsInBox(p5.CFrame, p5.Size, p6);
    end,

    Ball = function(p7, p8, p9) -- Line: 79, Name: Ball
        return p7:GetPartBoundsInRadius(p8.Position, p8.ExtentsSize.Y, p9);
    end,

    _ = function(p10, p11, p12) -- Line: 82, Name: _
        return p10:GetPartsInPart(p11, p12);
    end
});
local u14 = {
    Shape = true
};
local u15 = {
    CFrame = true,
    Position = true,
    Orientation = true
};

local function queryop_new() -- Line: 95
    return {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    };
end;

local function isArray(p16) -- Line: 109
    if type(p16) ~= "table" then
        return false;
    end;

    local v17 = #p16;

    if v17 == 0 then
        return false;
    end;

    return next(p16, v17) == nil;
end;

local function isPointInBox(p18, p19, p20) -- Line: 121
    local v21 = p19:PointToObjectSpace(p18);
    local v22;

    if math.abs(v21.X) <= p20.X and math.abs(v21.Y) <= p20.Y then
        v22 = math.abs(v21.Z) <= p20.Z;
    else
        v22 = false;
    end;

    return v22;
end;

local function areAnyItemPointsInBox(p23, p24, p25) -- Line: 127
    local v26 = p25 / 2;

    for _, v in p23 do
        local v27 = p24:PointToObjectSpace(v.Position);
        local v28;

        if math.abs(v27.X) <= v26.X and math.abs(v27.Y) <= v26.Y then
            v28 = math.abs(v27.Z) <= v26.Z;
        else
            v28 = false;
        end;

        if v28 then
            return true;
        end;
    end;

    return false;
end;

local function removeFromQuerySpace(p29, p30) -- Line: 140
    if not p30:IsA("BasePart") then
        return;
    end;

    local _querySpace = p29._querySpace;

    for _, v in p29._replicaConnect[p30] do
        v:Disconnect();
    end;

    local v31 = table.find(_querySpace.static.index, p30);
    local v32;

    if v31 then
        v32 = _querySpace.static;
    else
        v31 = table.find(_querySpace.dynamic.index, p30);
        v32 = _querySpace.dynamic;
    end;

    if not v31 then
        return;
    end;

    table.remove(v32.index, v31);
    table.remove(v32.replicas, v31);
end;

local function copyToQuerySpace(u33, u34, p35, u36, p37) -- Line: 168
    -- upvalues: u15 (copy), removeFromQuerySpace (copy)
    if u34:IsA("BasePart") then
        local _querySpace = u33._querySpace;
        local _worldModel = u33._worldModel;
        local _replicaConnect = u33._replicaConnect;
        local v38 = p35 and _querySpace.static.index or _querySpace.dynamic.index;
        local v39 = p35 and _querySpace.static.replicas or _querySpace.dynamic.replicas;
        local v40 = #v39 + 1;
        local u41 = Instance.fromExisting(u34);
        u41.Name = `REPLICA:{v40}`;
        u41.Parent = _worldModel;
        v38[v40] = u34;
        v39[v40] = u41;
        local v42 = {};
        local v43;

        if u36 == nil then
            v43 = false;
        else
            v43 = u34.Changed:Connect(function(p44) -- Line: 190
                -- upvalues: u15 (ref), u36 (copy), u41 (copy), u34 (copy)
                if u15[p44] then
                    return;
                end;

                if not u36[p44] then
                    return;
                end;

                u41[p44] = u34[p44];
            end);
        end;

        v42[1], v42[2] = v43, u34.Destroying:Once(function() -- Line: 200
    -- upvalues: removeFromQuerySpace (ref), u33 (copy), u34 (copy)
    removeFromQuerySpace(u33, u34);
end);
        _replicaConnect[u34] = v42;

        if p37 then
            table.insert(p37, u41);
        end;

        return u41;
    end;
end;

local function getOnEnterExit(p45) -- Line: 211
    local _queryOptions = p45._queryOptions;
    local _ = p45._items;
    local _ = _queryOptions.FireMode;
    local v46;

    if _queryOptions.FireMode == "OnEnter" or _queryOptions.FireMode == "Both" then
        v46 = _queryOptions.FireMode ~= "None";
    else
        v46 = false;
    end;

    local v47;

    if _queryOptions.FireMode == "OnExit" or _queryOptions.FireMode == "Both" then
        v47 = _queryOptions.FireMode ~= "None";
    else
        v47 = false;
    end;

    return v46, v47;
end;

local function getTracked(p48, p49) -- Line: 223
    for i in p48._tracked do
        if p49:IsDescendantOf(i) then
            return i;
        end;
    end;
end;

local function getItem(p50, p51) -- Line: 231
    -- upvalues: characterObjects (copy)
    local _querySpace = p50._querySpace;
    local _queryOptions = p50._queryOptions;

    if typeof(p51) == "table" and _queryOptions.AcceptMetadata then
        p51 = p51.item or p51;
    end;

    if _querySpace ~= nil then
        local v52 = table.find(_querySpace.dynamic.replicas, p51);

        if v52 then
            p51 = _querySpace.dynamic.index[v52];
        end;
    end;

    local v53;

    if _queryOptions.TrackItemEnabled then
        v53 = p51;

        for i in p50._tracked do
            if p51:IsDescendantOf(i) then
                break;
            end;
        end;

        if i then
            return i;
        end;
    else
        v53 = p51;
    end;

    local i = characterObjects[v53] or v53;

    return i;
end;

function v2.Update(p54, p55, p56, p57) -- Line: 249
    -- upvalues: getItem (copy)
    local _queryOptions = p54._queryOptions;
    local StoreByClass = _queryOptions.StoreByClass;
    local AcceptMetadata = _queryOptions.AcceptMetadata;
    local v58 = p54:Query(p55);
    print(v58);
    local v59 = {};

    for _, v in v58 do
        if not v59[v] then
            local v60 = getItem(p54, v);

            if not v59[v60] then
                v59[v60] = true;

                if not p54._items[v60] then
                    local v61 = typeof(v) == "table";

                    if AcceptMetadata then
                        p54._items[v60] = v61 and (v.metadata or true) or true;
                    else
                        p54._items[v60] = true;
                    end;

                    if StoreByClass then
                        local v62 = typeof(v60);

                        if v62 == "Instance" then
                            v62 = v60.ClassName or v62;
                        end;

                        local v63 = p54._storedClasses[v62];

                        if not v63 then
                            v63 = {};
                            p54._storedClasses[v62] = v63;
                        end;

                        v63[#v63 + 1] = v60;
                    end;

                    if p56 then
                        if AcceptMetadata then
                            if v61 then
                                p54.ItemEntered:Fire(v60, v.metadata);
                            else
                                p54.ItemEntered:Fire(v60);
                            end;
                        else
                            p54.ItemEntered:Fire(v60);
                        end;
                    end;
                end;
            end;
        end;
    end;

    for i, v in p54._items do
        if not v59[i] then
            p54._items[i] = nil;

            if StoreByClass then
                local v64 = typeof(i);

                if v64 == "Instance" then
                    v64 = i.ClassName or v64;
                end;

                local v65 = p54._storedClasses[v64];
                local v66 = v65 and table.find(v65, i);

                if v66 then
                    table.remove(v65, v66);

                    if #v65 == 0 then
                        p54._storedClasses[v64] = nil;
                    end;
                end;
            end;

            if p57 then
                if AcceptMetadata then
                    if v == true then
                        local v = nil;
                    end;

                    p54.ItemExited:Fire(i, v);
                else
                    p54.ItemExited:Fire(i);
                end;
            end;
        end;
    end;
end;

function v2.UnbindFromHeartbeat(p67) -- Line: 364
    -- upvalues: Zones (copy)
    Zones.deregisterZone(p67);
    table.clear(p67._items);
end;

function v2.BindToHeartbeat(p68, p69) -- Line: 373
    -- upvalues: Zones (copy)
    p68:UnbindFromHeartbeat();
    Zones.registerZone(p68, {
        QueryParams = p69,
        QueryOptions = p68._queryOptions
    });
end;

function v2.TrackItem(u70, u71) -- Line: 385
    local v72 = typeof(u71) == "Instance";
    local v73 = `Bad item argument: {u71} must be an instance.`;
    assert(v72, v73);

    if not u70._queryOptions.TrackItemEnabled then
        warn("TrackItemEnabled is not enabled, cannot call Zone:TrackItem(...)");

        return;
    end;

    if u70._tracked[u71] then
        warn((`Item {u71} is already being tracked.`));

        return;
    end;

    u70._tracked[u71] = true;
    local _trackedConnect = u70._trackedConnect;
    _trackedConnect[u71] = u71.Destroying:Once(function() -- Line: 400
        -- upvalues: _trackedConnect (copy), u71 (copy), u70 (copy)
        _trackedConnect[u71] = nil;
        u70:UntrackItem(u71);
    end);
end;

function v2.UntrackItem(p74, p75) -- Line: 409
    if not p74._tracked[p75] then
        warn((`Item {p75} is not currently being tracked.`));

        return;
    end;

    p74._tracked[p75] = nil;
    local _trackedConnect = p74._trackedConnect;

    if _trackedConnect[p75] then
        _trackedConnect[p75]:Disconnect();
        _trackedConnect[p75] = nil;
    end;
end;

function v2.GetItemsWhichAreA(p76, p77) -- Line: 426
    if p76._queryOptions.StoreByClass then
        return p76._storedClasses[p77] or {};
    end;

    warn("StoreByClass is not enabled, cannot call Zone:GetItemsWhichAreA(...)");
end;

function v2.SearchFor(p78, p79, p80) -- Line: 441
    -- upvalues: SearchFor (copy)
    assert(p79 ~= nil, "Bad properties argument.");

    return SearchFor(p78:Query(), p79, p80);
end;

function v2.ListenTo(p81, u82, p83, u84) -- Line: 451
    -- upvalues: u1 (copy), Players (copy)
    if u82 == "LocalPlayer" and not u1 then
        error("Can only listen to LocalPlayer on the client.");
    end;

    assert(p83 == "Entered" and true or p83 == "Exited", "Bad mode argument.");

    return p81[`Item{p83}`]:Connect(function(p85, p86) -- Line: 461
        -- upvalues: u82 (copy), Players (ref), u84 (copy)
        if u82 == "LocalPlayer" and p85 ~= Players.LocalPlayer then
            return;
        end;

        if u82 ~= "LocalPlayer" and not p85:IsA(u82) then
            return;
        end;

        u84(p85, p86);
    end);
end;

function v2.IsItemTracked(p87, p88) -- Line: 476
    return p87._tracked[p88] ~= nil;
end;

function v2.IsItemWithinZone(p89, p90) -- Line: 483
    return p89._items[p90] ~= nil;
end;

function v2.GetContainedItems(p91) -- Line: 490
    return p91._items;
end;

function v2.GetTracked(p92) -- Line: 497
    return p92._tracked;
end;

function v2.Destroy(u93) -- Line: 504
    local _trackedConnect = u93._trackedConnect;
    local _replicaConnect = u93._replicaConnect;

    for _, v in u93._bin do
        if typeof(v) == "Instance" then
            v:Destroy();
        elseif typeof(v) == "RBXScriptConnection" then
            v:Disconnect();
        end;
    end;

    for _, v in _trackedConnect do
        v:Disconnect();
    end;

    for _, v in _replicaConnect do
        for _, v3 in v do
            v3:Disconnect();
        end;
    end;

    task.defer(function() -- Line: 523
        -- upvalues: u93 (copy)
        u93.ItemEntered:Destroy();
        u93.ItemExited:Destroy();
        setmetatable(u93, nil);
        table.clear(u93);
    end);
end;

function v2.GetQuerySpace(p94) -- Line: 532
    return p94._worldModel;
end;

function v2.CopyToQuerySpace(p95, p96, p97, p98) -- Line: 539
    -- upvalues: copyToQuerySpace (copy)
    assert(p95._queryOptions.InSeperateQuerySpace, "InSeperateQuerySpace is not enabled, cannot call Zone:RegisterToQuerySpace(...)");
    local v99 = table.create(#p96);

    for _, v in p96 do
        copyToQuerySpace(p95, v, p97, p98, v99);
    end;

    return v99;
end;

function v2.RemoveFromQuerySpace(p100, p101) -- Line: 557
    -- upvalues: removeFromQuerySpace (copy)
    assert(p100._queryOptions.InSeperateQuerySpace, "InSeperateQuerySpace is not enabled, cannot call Zone:RemoveFromQuerySpace(...)");

    for _, v in p101 do
        removeFromQuerySpace(p100, v);
    end;
end;

function v2.UseQuerySpaceOf(p102, p103) -- Line: 567
    assert(p102._queryOptions.InSeperateQuerySpace, "InSeperateQuerySpace is not enabled, cannot call Zone:UseQuerySpaceOf(...)");
    assert(p103 ~= nil, "Bad otherZone argument");
    assert(not (not p102._queryOptions.InSeperateQuerySpace and p103 == "self"), "Cannot use query space of self because zone was not created in a seperate query space.");
    local v104, v105;

    if p103 == "self" then
        v104 = p102._ownQuerySpace or p102._querySpace;
        v105 = p102._worldModel;
    else
        v104 = p103._querySpace;
        v105 = p103._worldModel;
    end;

    if p103 == "self" then
        p102._ownQuerySpace = nil;
    else
        p102._ownQuerySpace = p102._querySpace;
    end;

    p102._querySpace = v104;
    p102._worldModel = v105;
end;

function v2.OverwriteQuerySpace(p106, p107) -- Line: 599
    assert(p106._queryOptions.InSeperateQuerySpace, "InSeperateQuerySpace is not enabled, cannot call Zone:OverwriteQuerySpace(...)");
    assert(p107 ~= nil, "Bad otherZone argument");
    local _querySpace = p106._querySpace;
    p106:RemoveFromQuerySpace(_querySpace.dynamic.index);
    p106:RemoveFromQuerySpace(_querySpace.static.index);
    p106._worldModel:Destroy();
    p106._querySpace = p107._querySpace;
    p106._worldModel = p107._worldModel;
end;

local function assertQueryOp(p108) -- Line: 616
    if not p108 then
        return;
    end;

    local FireMode = p108.FireMode;
    assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

    if p108.ThrottlingEnabled and not p108.UpdateInterval then
        error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
    end;
end;

local function zone_new(p109, ...) -- Line: 648
    -- upvalues: SimpleSignal (copy), u3 (copy), HttpService (copy), Folder2 (copy)
    local v110 = p109 or {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    };

    if v110 then
        local FireMode = v110.FireMode;
        assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

        if v110.ThrottlingEnabled and not v110.UpdateInterval then
            error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
        end;
    end;

    local v111 = { ... };
    local v112 = {
        _trackedConnect = {},
        _replicaConnect = {},
        _items = {},
        _storedClasses = {},
        _tracked = {},
        _bin = v111,
        _queryOptions = v110,
        _lastUpdate = os.clock(),
        _worldModel = workspace,
        ItemEntered = SimpleSignal.new(),
        ItemExited = SimpleSignal.new()
    };
    local v113 = setmetatable(v112, u3);

    if not v110.InSeperateQuerySpace or v110.QuerySpace ~= nil then
        if v110.QuerySpace ~= nil then
            local v114;

            if v110.QuerySpace.World == nil then
                v114 = false;
            else
                v114 = v110.QuerySpace.Space ~= nil;
            end;

            assert(v114, "Missing world/space fields for QuerySpace");
            v113._worldModel = v110.QuerySpace.World;
            v113._querySpace = v110.QuerySpace.Space;
        end;

        return v113;
    end;

    local WorldModel = Instance.new("WorldModel");
    WorldModel.Name = `SimpleZone_QuerySpace({HttpService:GenerateGUID(false)})`;
    WorldModel.Parent = Folder2;
    table.insert(v111, WorldModel);
    v113._worldModel = WorldModel;
    v113._querySpace = {
        dynamic = {
            index = {},
            replicas = {}
        },
        static = {
            index = {},
            replicas = {}
        }
    };

    return v113;
end;

local function getBoxFromPart(p115) -- Line: 705
    -- upvalues: BVH (copy)
    local VoxelSize = BVH.VoxelSize;
    local Position = p115.Position;
    local Size = p115.Size;

    if p115.Size.Magnitude > 500 then
        Position = Vector3.new(Position.X // VoxelSize * VoxelSize, Position.Y // VoxelSize * VoxelSize, Position.Z // VoxelSize * VoxelSize);
        Size = Vector3.new(Size.X // VoxelSize * VoxelSize, Size.Y // VoxelSize * VoxelSize, Size.Z // VoxelSize * VoxelSize);
    end;

    return {
        cframe = p115.CFrame.Rotation + Position,
        size = Size,
        part = p115
    };
end;

local function getBoxesFromParts(p116) -- Line: 731
    -- upvalues: getBoxFromPart (copy)
    local v117 = {};

    for _, v in p116 do
        v117[#v117 + 1] = getBoxFromPart(v);
    end;

    return v117;
end;

local function zone_fromPart(u118, p119) -- Line: 742
    -- upvalues: zone_new (copy), copyToQuerySpace (copy), u14 (copy), u13 (copy)
    if p119 then
        local FireMode = p119.FireMode;
        assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

        if p119.ThrottlingEnabled and not p119.UpdateInterval then
            error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
        end;
    end;

    local v120 = p119 or {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    };
    local v121 = zone_new(v120);

    if v120.InSeperateQuerySpace then
        u118 = copyToQuerySpace(v121, u118, v120.Static, u14);
    end;

    function v121.Query(p122, p123) -- Line: 751
        -- upvalues: u118 (ref), u13 (ref)
        local _worldModel = p122._worldModel;

        if u118:IsA("Part") then
            return u13(u118.Shape.Name, _worldModel, u118, p123);
        end;

        return _worldModel:GetPartsInPart(u118, p123);
    end;

    return v121;
end;

local function zone_fromBox(u124, u125, p126) -- Line: 764
    -- upvalues: zone_new (copy)
    if p126 then
        local FireMode = p126.FireMode;
        assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

        if p126.ThrottlingEnabled and not p126.UpdateInterval then
            error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
        end;
    end;

    local v127 = zone_new(p126 or {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    });

    function v127.Query(p128, p129) -- Line: 770
        -- upvalues: u124 (copy), u125 (copy)
        return p128._worldModel:GetPartBoundsInBox(u124, u125, p129);
    end;

    return v127;
end;

local function zone_fromBoxes(p130, p131) -- Line: 778
    -- upvalues: BVH (copy), zone_new (copy), areAnyItemPointsInBox (copy)
    if p131 then
        local FireMode = p131.FireMode;
        assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

        if p131.ThrottlingEnabled and not p131.UpdateInterval then
            error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
        end;
    end;

    local v132 = p131 or {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    };
    local u133, _ = BVH.createBVH(p130);
    local v134 = zone_new(v132);

    function v134.Query(u135, u136) -- Line: 786
        -- upvalues: BVH (ref), u133 (copy), areAnyItemPointsInBox (ref)
        local _ = u135._queryOptions;
        local _querySpace = u135._querySpace;
        local _worldModel = u135._worldModel;
        local u137 = {};
        BVH.traverseBVH(u133, function(p138) -- Line: 792
            -- upvalues: _querySpace (copy), areAnyItemPointsInBox (ref), _worldModel (copy), u136 (copy), u135 (copy), u137 (copy)
            local v139;

            if _querySpace == nil then
                v139 = _worldModel:GetPartBoundsInBox(p138.cframe, p138.size, u136);

                if #v139 == 0 then
                    return false;
                end;

                if p138.right or p138.left then
                    return true;
                end;
            else
                if not areAnyItemPointsInBox(_querySpace.dynamic.replicas, p138.cframe, p138.size) then
                    return false;
                end;

                if p138.right or p138.left then
                    return true;
                end;

                v139 = _worldModel:GetPartBoundsInBox(p138.cframe, p138.size, u136);
            end;

            if u135._queryOptions.AcceptMetadata then
                for _, v in v139 do
                    table.insert(u137, {
                        item = v,
                        metadata = {
                            box = p138
                        }
                    });
                end;
            else
                table.move(v139, 1, #v139, #u137 + 1, u137);
            end;

            return false;
        end);

        return u137;
    end;

    return v134;
end;

local function zone_fromParts(p140, p141) -- Line: 833
    -- upvalues: zone_new (copy), u14 (copy), getBoxesFromParts (copy), BVH (copy), areAnyItemPointsInBox (copy), u13 (copy)
    if p141 then
        local FireMode = p141.FireMode;
        assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

        if p141.ThrottlingEnabled and not p141.UpdateInterval then
            error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
        end;
    end;

    local v142 = p141 or {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    };
    local v143 = zone_new(v142);
    local v144;

    if v142.InSeperateQuerySpace then
        v144 = getBoxesFromParts((v143:CopyToQuerySpace(p140, v142.Static, u14)));
    else
        v144 = getBoxesFromParts(p140);
    end;

    local u145 = BVH.createBVH(v144);

    function v143.Query(p146, u147) -- Line: 868
        -- upvalues: BVH (ref), u145 (copy), areAnyItemPointsInBox (ref), u13 (ref)
        local _querySpace = p146._querySpace;
        local _queryOptions = p146._queryOptions;
        local _worldModel = p146._worldModel;
        local u148 = {};
        local u149;

        if _querySpace == nil then
            u149 = false;
        else
            u149 = _queryOptions.Static and _querySpace.static or _querySpace.dynamic;
        end;

        BVH.traverseBVH(u145, function(p150) -- Line: 876
            -- upvalues: _querySpace (copy), areAnyItemPointsInBox (ref), _worldModel (copy), u147 (copy), u13 (ref), _queryOptions (copy), u149 (copy), u148 (copy)
            local v151 = nil;

            if _querySpace then
                if not areAnyItemPointsInBox(_querySpace.dynamic.replicas, p150.cframe, p150.size) then
                    return false;
                end;

                if not p150.part then
                    return true;
                end;
            else
                v151 = _worldModel:GetPartBoundsInBox(p150.cframe, p150.size, u147);

                if not p150.part then
                    return #v151 > 0;
                end;
            end;

            local part = p150.part;
            local v152;

            if part:IsA("Part") then
                v152 = part.Shape == Enum.PartType.Block and v151 and v151 or u13(part.Shape.Name, _worldModel, part, u147);
            else
                v152 = _worldModel:GetPartsInPart(part, u147);
            end;

            if _queryOptions.AcceptMetadata then
                local part2 = p150.part;

                if _queryOptions.InSeperateQuerySpace then
                    local v153 = table.find(u149.replicas, p150.part);
                    part2 = u149.index[v153];
                end;

                for _, v in v152 do
                    table.insert(u148, {
                        item = v,
                        metadata = {
                            part = part2
                        }
                    });
                end;
            else
                table.move(v152, 1, #v152, #u148 + 1, u148);
            end;

            return false;
        end);

        return u148;
    end;

    return v143;
end;

local function zone_fromPartsLPO() -- Line: 929
    error("Zone.fromPartsLPO() is deprecated, it should not be used for new work.");
end;

local function zone_fromPartsUpdatable() -- Line: 933
    error("Zone.fromPartsUpdatable() is deprecated, it should not be used for new work.");
end;

local function zone_fromPartParallel(u154, p155) -- Line: 938
    -- upvalues: ServerWorker (copy), Folder (copy), zone_new (copy), copyToQuerySpace (copy), u14 (copy)
    if p155 then
        local FireMode = p155.FireMode;
        assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

        if p155.ThrottlingEnabled and not p155.UpdateInterval then
            error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
        end;
    end;

    local v156 = p155 or {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    };
    local u157 = ServerWorker:Clone();
    u157.Parent = Folder;
    local Result = u157.Result;
    local v158 = zone_new(v156, u157);

    if v156.InSeperateQuerySpace then
        u154 = copyToQuerySpace(v158, u154, v156.Static, u14);
    end;

    function v158.Query(p159, p160) -- Line: 952
        -- upvalues: u157 (copy), u154 (ref), Result (copy)
        task.defer(u157.SendMessage, u157, "GetPartsInPart", p159._worldModel, p160, u154);

        return Result.Event:Wait();
    end;

    return v158;
end;

local function zone_fromCustom(p161, p162) -- Line: 962
    -- upvalues: zone_new (copy)
    assert(p161 ~= nil, "Bad queryFn argument.");

    if p162 then
        local FireMode = p162.FireMode;
        assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

        if p162.ThrottlingEnabled and not p162.UpdateInterval then
            error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
        end;
    end;

    local v163 = zone_new(p162 or {
        FireMode = "Both",
        TrackItemEnabled = false,
        ThrottlingEnabled = false,
        StoreByClass = false,
        AcceptMetadata = false,
        UpdateInterval = 0,
        InSeperateQuerySpace = false,
        Static = false,
        DoBoxQueryForBVHNodes = false
    });
    v163.Query = p161;

    return v163;
end;

local function v172(u164, u165, p166) -- Line: 979
    -- upvalues: zone_fromParts (copy), zone_fromBoxes (copy), zone_new (copy), zone_fromPart (copy)
    local v167;

    if type(u164) == "table" then
        local v168 = #u164;

        if v168 == 0 then
            v167 = false;
        else
            v167 = next(u164, v168) == nil;
        end;
    else
        v167 = false;
    end;

    if v167 then
        if typeof(u164[1]) == "Instance" and u164[1]:IsA("BasePart") then
            return zone_fromParts(u164, u165);
        end;

        if typeof(u164[1]) == "table" then
            return zone_fromBoxes(u164, u165);
        end;

        error("Unable to find an overload.");
    end;

    if typeof(u164) == "CFrame" and typeof(u165) == "Vector3" then
        if p166 then
            local FireMode = p166.FireMode;
            assert((FireMode == "Both" or (FireMode == "OnExit" or FireMode == "OnEnter")) and true or FireMode == "None", "Bad QueryOptions argument. (FireMode not specified)");

            if p166.ThrottlingEnabled and not p166.UpdateInterval then
                error("QueryOptions.UpdateInterval must be specified if QueryOptions.ThrottlingEnabled is true.");
            end;
        end;

        local v169 = zone_new(p166 or {
            FireMode = "Both",
            TrackItemEnabled = false,
            ThrottlingEnabled = false,
            StoreByClass = false,
            AcceptMetadata = false,
            UpdateInterval = 0,
            InSeperateQuerySpace = false,
            Static = false,
            DoBoxQueryForBVHNodes = false
        });

        function v169.Query(p170, p171) -- Line: 770
            -- upvalues: u164 (copy), u165 (copy)
            return p170._worldModel:GetPartBoundsInBox(u164, u165, p171);
        end;

        return v169;
    end;

    if typeof(u164) == "Instance" and u164:IsA("BasePart") then
        return zone_fromPart(u164, u165);
    end;

    error("Unable to find an overload.");
end;

if script:GetAttribute("ClientOnlyDetectLocalPlayer") and RunService:IsClient() then
    PlayerLookup.onPlayerAdded(Players.LocalPlayer);
else
    PlayerLookup.start();
end;

return table.freeze({
    new = v172,
    fromBox = zone_fromBox,
    fromPart = zone_fromPart,
    fromParts = zone_fromParts,
    fromBoxes = zone_fromBoxes,
    fromCustom = zone_fromCustom,
    fromPartParallel = zone_fromPartParallel,
    fromPartsUpdatable = zone_fromPartsUpdatable,
    fromPartsLPO = zone_fromPartsLPO,
    QueryOptions = {
        new = queryop_new
    },
    newInternal = zone_new,
    searchFor = SearchFor,
    BVH = BVH,
    ZoneClass = v2,
    PlayerLookup = PlayerLookup,
    PartQueryJump = u13
});