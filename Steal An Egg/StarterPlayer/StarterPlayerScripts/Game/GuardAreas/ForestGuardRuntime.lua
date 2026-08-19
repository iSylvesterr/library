-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local AreaEggs = require(ReplicatedStorage.Library.Types.AreaEggs);
local AreaEggPriority = require(ReplicatedStorage.Library.Util.AreaEggPriority);
local AreaEggSlotIdentity = require(ReplicatedStorage.Library.Util.AreaEggSlotIdentity);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
require(ReplicatedStorage.Library.Types.GuardAreas);
local Guards = require(ReplicatedStorage.Directory.Guards);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Player = require(ReplicatedStorage.Library.Player);
local GuardComponent = require(ReplicatedStorage.Library.Modules.GuardAreas.GuardComponent);
require(ReplicatedStorage.Library.Modules.GuardAreas.Types.Interface);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = {};
u1.__index = u1;
u1.__class = "ForestGuardRuntime";
local Guards2 = Constants.NETWORK_MAP.Guards;
local States = AreaEggs.States;
local LocalPlayer = Players.LocalPlayer;

local function stageGuardForConstruction(p2, p3) -- Line: 68
    p2.Name = "ForestGuardStaging";
    local u4 = {};
    local u5 = {};

    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA("BasePart") then
            u4[descendant] = {
                CanCollide = descendant.CanCollide,
                CanQuery = descendant.CanQuery,
                CanTouch = descendant.CanTouch,
                LocalTransparencyModifier = descendant.LocalTransparencyModifier
            };
            descendant.LocalTransparencyModifier = 1;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or (descendant:IsA("Trail") or descendant:IsA("BillboardGui"))) then
            local Enabled = descendant.Enabled;
            table.insert(u5, function() -- Line: 100
                -- upvalues: descendant (copy), Enabled (copy)
                descendant.Enabled = Enabled;
            end);
            descendant.Enabled = false;
        end;
    end;

    p2.Parent = p3;

    return function() -- Line: 107
        -- upvalues: u4 (copy), u5 (copy)
        for i, v in pairs(u4) do
            i.LocalTransparencyModifier = v.LocalTransparencyModifier;
            i.CanCollide = v.CanCollide;
            i.CanQuery = v.CanQuery;
            i.CanTouch = v.CanTouch;
        end;

        for _, v in ipairs(u5) do
            v();
        end;
    end;
end;

function u1.new(u6) -- Line: 124
    -- upvalues: Asserts (copy), Workspace (copy), u1 (copy), Trove (copy), LocalPlayer (copy), Network (copy), Guards2 (copy), stageGuardForConstruction (copy), GuardComponent (copy), Guards (copy), Player (copy), GuardAreaLookupUtil (copy)
    Asserts.Model(u6);
    assert(u6.Name == "Forest", "ForestGuardRuntime requires area Forest");
    local Guard = u6.Guard;
    local Bounds = u6.Bounds;
    local v7 = u6:IsDescendantOf(Workspace);
    assert(v7, "Forest area must be in Workspace before guard construction");
    assert(Guard.Parent == u6, "Forest authored guard must belong to its area before guard construction");
    local u8 = Guard:Clone();
    local u9 = setmetatable({}, u1);
    u9._areaModel = u6;
    u9._clientEggFolder = nil;
    u9._droppedModelByUid = {};
    u9._droppedTroveByUid = {};
    u9._guardModel = u8;
    u9._registeredDroppedUids = {};
    u9._registeredStolenUids = {};
    u9._trove = Trove.new();
    u9._wake = nil;
    local u12 = {
        ServerOwnsPhysics = false,

        Attack = function(p10) -- Line: 146, Name: Attack
            -- upvalues: LocalPlayer (ref), Network (ref), Guards2 (ref)
            if p10.Player ~= LocalPlayer or p10.EggUid == nil then
                return;
            end;

            Network.Fire(Guards2.FOREST_HIT, {
                EggUid = p10.EggUid,
                GuardCFrame = p10.GuardRoot.CFrame
            });
        end,

        Wake = function(p11) -- Line: 157, Name: Wake
            -- upvalues: u9 (copy)
            local _wake = u9._wake;

            if _wake ~= nil then
                _wake(p11);
            end;
        end
    };
    local u13 = nil;
    local u14 = nil;
    local v20, v21 = xpcall(function() -- Line: 166
        -- upvalues: u13 (ref), stageGuardForConstruction (ref), u8 (copy), u6 (copy), u14 (ref), GuardComponent (ref), Bounds (copy), Workspace (ref), Guards (ref), LocalPlayer (ref), Player (ref), GuardAreaLookupUtil (ref), u12 (copy), Guard (copy)
        u13 = stageGuardForConstruction(u8, u6);
        u14 = GuardComponent.new("Forest", u8, Bounds, Workspace.__OBJECTS.Areas.Ground, Guards.Directory.Forest, function(p15) -- Line: 174
            -- upvalues: LocalPlayer (ref), Player (ref), GuardAreaLookupUtil (ref), Workspace (ref)
            if p15 ~= LocalPlayer then
                return false;
            end;

            local v16 = Player.Optional.HumanoidRootPart(LocalPlayer);
            local v17;

            if v16 == nil then
                v17 = false;
            else
                v17 = GuardAreaLookupUtil.IsInGameplaySide(Workspace.__OBJECTS.Areas.SeparationLine, v16.Position);
            end;

            return v17;
        end, u12);
        local v18 = u6:IsDescendantOf(Workspace);
        assert(v18, "Forest area was removed during guard construction");
        assert(Guard.Parent == u6, "Forest authored guard was removed during guard construction");
    end, function(p19) -- Line: 186
        return debug.traceback(tostring(p19), 2);
    end);

    if not v20 then
        if u14 ~= nil then
            u14:Destroy();
        end;

        u8:Destroy();
        u9._trove:Destroy();
        error(v21, 0);
    end;

    u9._component = assert(u14, "Forest shared guard component did not initialize");
    local v22 = assert(u13, "Forest guard staging did not initialize");
    u9._trove:Add(u8);
    u9._trove:Add(function() -- Line: 200
        -- upvalues: Guard (copy)
        if Guard.Parent ~= nil then
            Guard.Name = "Guard";
        end;
    end);
    Guard.Name = "ForestGuardAuthored";
    u8.Name = "Guard";

    for _, descendant in ipairs(Guard:GetDescendants()) do
        if descendant:IsA("BasePart") then
            local LocalTransparencyModifier = descendant.LocalTransparencyModifier;
            u9._trove:Add(function() -- Line: 211
                -- upvalues: descendant (copy), LocalTransparencyModifier (copy)
                if descendant.Parent ~= nil then
                    descendant.LocalTransparencyModifier = LocalTransparencyModifier;
                end;
            end);
            descendant.LocalTransparencyModifier = 1;
        elseif descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or (descendant:IsA("Trail") or descendant:IsA("BillboardGui"))) then
            local Enabled = descendant.Enabled;
            u9._trove:Add(function() -- Line: 225
                -- upvalues: descendant (copy), Enabled (copy)
                if descendant.Parent ~= nil then
                    descendant.Enabled = Enabled;
                end;
            end);
            descendant.Enabled = false;
        end;
    end;

    v22();

    return u9;
end;

function u1._isOwnedForestRecord(p23, p24) -- Line: 242
    -- upvalues: AreaEggSlotIdentity (copy), LocalPlayer (copy)
    local v25;

    if p24.AreaId == "Forest" then
        v25 = AreaEggSlotIdentity.GetFirstAreaOwnerUserId(p24.Uid) == LocalPlayer.UserId;
    else
        v25 = false;
    end;

    return v25;
end;

function u1._clearStolen(p26, p27) -- Line: 246
    if p26._registeredStolenUids[p27] ~= true then
        return;
    end;

    p26._registeredStolenUids[p27] = nil;
    p26._component:ClearStolenEgg(p27);
end;

function u1._registerStolen(p28, p29, p30) -- Line: 254
    -- upvalues: LocalPlayer (copy), AreaEggPriority (copy)
    if p28._registeredStolenUids[p29] == true then
        return;
    end;

    for i in pairs(p28._registeredStolenUids) do
        p28:_clearStolen(i);
    end;

    p28._registeredStolenUids[p29] = true;
    p28._component:RegisterStolenEgg(LocalPlayer, p29, AreaEggPriority.FromAssetCategory(p30));
end;

function u1._clearDropped(p31, p32) -- Line: 265
    local v33 = p31._droppedTroveByUid[p32];

    if v33 ~= nil then
        p31._droppedTroveByUid[p32] = nil;
        v33:Destroy();
    end;

    p31._droppedModelByUid[p32] = nil;

    if p31._registeredDroppedUids[p32] ~= true then
        return;
    end;

    p31._registeredDroppedUids[p32] = nil;
    p31._component:ClearDroppedEgg(p32);
end;

function u1._tryRegisterDropped(u34, u35) -- Line: 279
    -- upvalues: GuardAreaLookupUtil (copy), AreaEggSlotIdentity (copy), AreaEggPriority (copy), Trove (copy), EggCmds (copy), States (copy)
    if u34._registeredDroppedUids[u35.Uid] == true then
        return;
    end;

    if not GuardAreaLookupUtil.IsWorldPositionInsideXZBounds(u34._areaModel.Bounds, u35.BoundsCFrame.Position) then
        return;
    end;

    local _clientEggFolder = u34._clientEggFolder;

    if _clientEggFolder == nil then
        return;
    end;

    local u36 = _clientEggFolder:FindFirstChild(u35.Uid);

    if u36 == nil then
        return;
    end;

    local v37 = u36:IsA("Model");
    local v38 = `{_clientEggFolder:GetFullName()}.{u35.Uid} must be a Model`;
    assert(v37, v38);
    local EggSpotBottom = AreaEggSlotIdentity.ResolveNest(u34._areaModel, u35.NestId).EggSpotBottom;

    if not u34._component:RegisterDroppedEgg({
        EggUid = u35.Uid,
        Model = u36,
        DroppedPosition = u35.BottomCFrame.Position,
        NestBottomCFrame = EggSpotBottom.CFrame,
        Priority = AreaEggPriority.FromAssetCategory(u35.AssetCategory)
    }) then
        return;
    end;

    u34._registeredDroppedUids[u35.Uid] = true;
    u34._droppedModelByUid[u35.Uid] = u36;
    local v39 = Trove.new();
    u34._droppedTroveByUid[u35.Uid] = v39;
    v39:Connect(u36.AncestryChanged, function(p40, p41) -- Line: 314
        -- upvalues: u34 (copy), u35 (copy), u36 (copy), EggCmds (ref), States (ref)
        if p41 ~= nil or u34._droppedModelByUid[u35.Uid] ~= u36 then
            return;
        end;

        u34:_clearDropped(u35.Uid);
        local v42 = EggCmds.GetAreaEggRecord(u35.Uid);

        if v42 ~= nil and v42.State == States.Dropped then
            u34:_tryRegisterDropped(v42);
        end;
    end);
end;

function u1._syncRecord(p43, p44) -- Line: 326
    -- upvalues: States (copy), LocalPlayer (copy)
    if not p43:_isOwnedForestRecord(p44) then
        return;
    end;

    if p44.State == States.Carried and p44.CarrierUserId == LocalPlayer.UserId then
        p43:_clearDropped(p44.Uid);
        p43:_registerStolen(p44.Uid, p44.AssetCategory);

        return;
    end;

    p43:_clearStolen(p44.Uid);

    if p44.State == States.Dropped then
        p43:_tryRegisterDropped(p44);

        return;
    end;

    p43:_clearDropped(p44.Uid);
end;

function u1._syncSnapshot(p45, p46) -- Line: 344
    local v47 = {};

    for _, v in ipairs(p46.Records) do
        if p45:_isOwnedForestRecord(v) then
            v47[v.Uid] = true;
            p45:_syncRecord(v);
        end;
    end;

    for i in pairs(p45._registeredStolenUids) do
        if v47[i] ~= true then
            p45:_clearStolen(i);
        end;
    end;

    for i in pairs(p45._registeredDroppedUids) do
        if v47[i] ~= true then
            p45:_clearDropped(i);
        end;
    end;
end;

function u1._handleRetrievalEvent(p48, p49) -- Line: 364
    -- upvalues: Network (copy), Guards2 (copy)
    if p49.Kind == "Attached" then
        local v50 = p48._droppedModelByUid[p49.EggUid];

        if v50 ~= nil then
            local CarryAreaEgg = v50:FindFirstChild("CarryAreaEgg", true);

            if CarryAreaEgg ~= nil then
                local v51 = CarryAreaEgg:IsA("ProximityPrompt");
                local v52 = `{CarryAreaEgg:GetFullName()} must be a ProximityPrompt`;
                assert(v51, v52);
                CarryAreaEgg:Destroy();
            end;
        end;

        Network.Fire(Guards2.FOREST_DEPOSIT, {
            Kind = "Attached",
            EggUid = p49.EggUid
        });

        return;
    end;

    local v53 = {
        Kind = "Deposited",
        EggUid = p49.EggUid
    };
    p48._registeredDroppedUids[p49.EggUid] = nil;
    p48._droppedModelByUid[p49.EggUid] = nil;
    local v54 = p48._droppedTroveByUid[p49.EggUid];

    if v54 ~= nil then
        p48._droppedTroveByUid[p49.EggUid] = nil;
        v54:Destroy();
    end;

    Network.Fire(Guards2.FOREST_DEPOSIT, v53);
end;

function u1.GetGuardModel(p55) -- Line: 403
    return p55._guardModel;
end;

function u1.SetWakeHandler(p56, p57) -- Line: 407
    -- upvalues: Asserts (copy)
    Asserts.func(p57);
    p56._wake = p57;
end;

function u1.Start(u58) -- Line: 412
    -- upvalues: EggCmds (copy), Workspace (copy), RunService (copy)
    u58._trove:Add(EggCmds.AreaEggSnapshotUpdated:Connect(function(p59) -- Line: 413
        -- upvalues: u58 (copy)
        u58:_syncSnapshot(p59);
    end));
    u58._trove:Add(EggCmds.AreaEggUpdated:Connect(function(p60) -- Line: 416
        -- upvalues: u58 (copy)
        u58:_syncRecord(p60);
    end));
    u58._trove:Add(EggCmds.AreaEggRemoved:Connect(function(p61) -- Line: 419
        -- upvalues: u58 (copy)
        u58:_clearStolen(p61);
        u58:_clearDropped(p61);
    end));
    u58._trove:Add(EggCmds.AreaEggCarryStateChanged:Connect(function(p62) -- Line: 423
        -- upvalues: u58 (copy)
        if p62.IsCarrying and (p62.Uid ~= nil and (p62.AssetCategory ~= nil and p62.AreaId == "Forest")) then
            u58:_registerStolen(p62.Uid, p62.AssetCategory);

            return;
        end;

        for i in pairs(u58._registeredStolenUids) do
            u58:_clearStolen(i);
        end;
    end));
    task.spawn(function() -- Line: 433
        -- upvalues: Workspace (ref), u58 (copy), EggCmds (ref)
        local AreaEggSlotsClient = Workspace:WaitForChild("AreaEggSlotsClient");
        local v63 = AreaEggSlotsClient:IsA("Folder");
        assert(v63, "Workspace.AreaEggSlotsClient must be a Folder");

        if u58._guardModel.Parent == nil then
            return;
        end;

        u58._clientEggFolder = AreaEggSlotsClient;
        u58._trove:Connect(AreaEggSlotsClient.ChildAdded, function(p64) -- Line: 440
            -- upvalues: u58 (ref), AreaEggSlotsClient (copy), EggCmds (ref)
            if u58._clientEggFolder ~= AreaEggSlotsClient or p64.Parent ~= AreaEggSlotsClient then
                return;
            end;

            local v65 = EggCmds.GetAreaEggRecord(p64.Name);

            if v65 ~= nil then
                u58:_syncRecord(v65);
            end;
        end);
        u58:_syncSnapshot(EggCmds.GetAreaEggSnapshot());
    end);
    local u66 = 0;
    u58._trove:Connect(RunService.Heartbeat, function(p67) -- Line: 453
        -- upvalues: u66 (ref), u58 (copy)
        u66 = u66 + p67;

        if u66 < 0.03 then
            return;
        end;

        u66 = 0;
        local v68 = u58._component:Step(os.clock());

        if v68 ~= nil then
            u58:_handleRetrievalEvent(v68);
        end;
    end);
    u58:_syncSnapshot(EggCmds.GetAreaEggSnapshot());
end;

function u1.Destroy(p69) -- Line: 467
    p69._clientEggFolder = nil;

    for i in pairs(p69._registeredDroppedUids) do
        p69:_clearDropped(i);
    end;

    for _, v in pairs(p69._droppedTroveByUid) do
        if v ~= nil then
            v:Destroy();
        end;
    end;

    p69._component:Destroy();
    p69._trove:Destroy();
    table.clear(p69._registeredDroppedUids);
    table.clear(p69._registeredStolenUids);
    table.clear(p69._droppedModelByUid);
    table.clear(p69._droppedTroveByUid);
end;

return u1;