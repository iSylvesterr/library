-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AreaEggs = require(ReplicatedStorage.Library.Types.AreaEggs);
local AreaEggResetCycle = require(ReplicatedStorage.Library.Types.AreaEggResetCycle);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local Eggs = require(ReplicatedStorage.Library.Types.Eggs);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local TableUtil = require(ReplicatedStorage.Library.Modules.Packages.TableUtil);
local Eggs2 = Network.NET_MAP.Eggs;
local u1 = {};
local u2 = {};
local u3 = 0;
local u4 = nil;
local u5 = {};
local u6 = {};
local u7 = 0;
local u8 = {};
local u9 = Log.new();
local u10 = {
    RuntimeSnapshotUpdated = Signal.new(),
    RuntimeOwnerUpdated = Signal.new(),
    RuntimeOwnerCleared = Signal.new(),
    AreaEggSnapshotUpdated = Signal.new(),
    AreaEggUpdated = Signal.new(),
    AreaEggRemoved = Signal.new(),
    AreaEggCarryStateChanged = Signal.new(),
    AreaEggClaimed = Signal.new(),
    AreaEggResetTeleportFade = Signal.new(),
    AreaEggResetStartCountdown = Signal.new(),
    AreaEggRareSpawnsPresented = Signal.new()
};

local function buildRuntimeSnapshotPayload(p11) -- Line: 52
    -- upvalues: TableUtil (copy)
    local v12 = {};

    for i, v in pairs(p11) do
        local v13 = {
            OwnerUserId = i,
            Records = TableUtil.Copy(v, true)
        };
        table.insert(v12, v13);
    end;

    return v12;
end;

local function applySnapshot(p14, p15) -- Line: 65
    -- upvalues: u1 (ref), u2 (copy), TableUtil (copy), u10 (copy)
    local v16 = {};

    for i, v in pairs(u1) do
        if p15 < (u2[i] or 0) then
            v16[i] = TableUtil.Copy(v, true);
        end;
    end;

    for _, v in ipairs(p14) do
        if (u2[v.OwnerUserId] or 0) <= p15 then
            v16[v.OwnerUserId] = TableUtil.Copy(v.Records, true);
        end;
    end;

    u1 = v16;
    u10.RuntimeSnapshotUpdated:Fire(u10.GetRuntimeSnapshot());
end;

local function applyOwnerUpdate(p17) -- Line: 82
    -- upvalues: u1 (ref), TableUtil (copy), u10 (copy)
    u1[p17.OwnerUserId] = TableUtil.Copy(p17.Records, true);
    u10.RuntimeOwnerUpdated:Fire(p17.OwnerUserId, u10.GetOwnerRuntimeRecords(p17.OwnerUserId));
    u10.RuntimeSnapshotUpdated:Fire(u10.GetRuntimeSnapshot());
end;

local function applyOwnerClear(p18) -- Line: 88
    -- upvalues: u1 (ref), u10 (copy)
    u1[p18.OwnerUserId] = nil;
    u10.RuntimeOwnerCleared:Fire(p18.OwnerUserId);
    u10.RuntimeSnapshotUpdated:Fire(u10.GetRuntimeSnapshot());
end;

local function buildAreaEggSnapshot(p19) -- Line: 94
    -- upvalues: TableUtil (copy), Workspace (copy)
    local v20 = {};

    for _, v in pairs(p19) do
        table.insert(v20, TableUtil.Copy(v, true));
    end;

    return {
        Records = v20,
        ServerTime = Workspace:GetServerTimeNow()
    };
end;

local function applyAreaEggSnapshot(p21, p22) -- Line: 108
    -- upvalues: u5 (ref), u6 (copy), TableUtil (copy), u10 (copy)
    local v23 = {};

    for i, v in pairs(u5) do
        if p22 < (u6[i] or 0) then
            v23[i] = TableUtil.Copy(v, true);
        end;
    end;

    for _, v in ipairs(p21.Records) do
        if (u6[v.Uid] or 0) <= p22 then
            v23[v.Uid] = TableUtil.Copy(v, true);
        end;
    end;

    u5 = v23;
    u10.AreaEggSnapshotUpdated:Fire(u10.GetAreaEggSnapshot());
end;

local function applyAreaEggUpdate(p24) -- Line: 125
    -- upvalues: u5 (ref), TableUtil (copy), u10 (copy)
    u5[p24.Uid] = TableUtil.Copy(p24, true);
    u10.AreaEggUpdated:Fire((u10.GetAreaEggRecord(p24.Uid)));
end;

local function applyAreaEggRemoved(p25) -- Line: 130
    -- upvalues: u5 (ref), u10 (copy)
    u5[p25] = nil;
    u10.AreaEggRemoved:Fire(p25);
end;

local function applyAreaEggBatchUpdate(p26) -- Line: 135
    -- upvalues: u5 (ref), TableUtil (copy), u10 (copy)
    for _, v in ipairs(p26.RemovedUids) do
        u5[v] = nil;
    end;

    for _, v in ipairs(p26.UpdatedRecords) do
        u5[v.Uid] = TableUtil.Copy(v, true);
    end;

    u10.AreaEggSnapshotUpdated:Fire(u10.GetAreaEggSnapshot());
end;

local function handleOwnerUpdated(p27) -- Line: 145
    -- upvalues: Eggs (copy), u9 (copy), u3 (ref), u2 (copy), applyOwnerUpdate (copy)
    local v28, v29 = Eggs.SchemaValidation.RuntimeEggOwnerUpdate(p27);

    if not v28 then
        u9:AtError():Log((`Ignored invalid egg runtime owner update: {v29}`));

        return;
    end;

    u3 = u3 + 1;
    u2[p27.OwnerUserId] = u3;
    applyOwnerUpdate(p27);
end;

local function handleOwnerCleared(p30) -- Line: 158
    -- upvalues: Eggs (copy), u9 (copy), u3 (ref), u2 (copy), u1 (ref), u10 (copy)
    local v31, v32 = Eggs.SchemaValidation.RuntimeEggOwnerClear(p30);

    if not v31 then
        u9:AtError():Log((`Ignored invalid egg runtime owner clear: {v32}`));

        return;
    end;

    u3 = u3 + 1;
    u2[p30.OwnerUserId] = u3;
    u1[p30.OwnerUserId] = nil;
    u10.RuntimeOwnerCleared:Fire(p30.OwnerUserId);
    u10.RuntimeSnapshotUpdated:Fire(u10.GetRuntimeSnapshot());
end;

local function handleAreaEggUpdated(p33) -- Line: 171
    -- upvalues: AreaEggs (copy), u9 (copy), u7 (ref), u6 (copy), u5 (ref), TableUtil (copy), u10 (copy)
    local v34, v35 = AreaEggs.SchemaValidation.AreaEggRecord(p33);

    if not v34 then
        u9:AtError():Log((`Ignored invalid area egg update: {v35}`));

        return;
    end;

    u7 = u7 + 1;
    u6[p33.Uid] = u7;
    u5[p33.Uid] = TableUtil.Copy(p33, true);
    u10.AreaEggUpdated:Fire((u10.GetAreaEggRecord(p33.Uid)));
end;

local function handleAreaEggRemoved(p36) -- Line: 184
    -- upvalues: u9 (copy), u7 (ref), u6 (copy), u5 (ref), u10 (copy)
    if typeof(p36) ~= "string" then
        u9:AtError():Log("Ignored invalid area egg removal");

        return;
    end;

    u7 = u7 + 1;
    u6[p36] = u7;
    u5[p36] = nil;
    u10.AreaEggRemoved:Fire(p36);
end;

local function handleAreaEggBatchUpdated(p37) -- Line: 195
    -- upvalues: AreaEggs (copy), u9 (copy), u7 (ref), u6 (copy), applyAreaEggBatchUpdate (copy)
    local v38, v39 = AreaEggs.SchemaValidation.AreaEggBatchUpdate(p37);

    if not v38 then
        u9:AtError():Log((`Ignored invalid area egg batch update: {v39}`));

        return;
    end;

    for _, v in ipairs(p37.RemovedUids) do
        u7 = u7 + 1;
        u6[v] = u7;
    end;

    for _, v in ipairs(p37.UpdatedRecords) do
        u7 = u7 + 1;
        u6[v.Uid] = u7;
    end;

    applyAreaEggBatchUpdate(p37);
end;

function u10.RequestLocalEggRecord(p40) -- Line: 256
    -- upvalues: Asserts (copy), Network (copy), Eggs2 (copy), Eggs (copy), u9 (copy), TableUtil (copy)
    Asserts.string(p40);
    local v41 = Network.Invoke(Eggs2.REQUEST_EGG_RECORD, p40);

    if v41 == nil then
        return nil;
    end;

    local v42, v43 = Eggs.SchemaValidation.SavedEgg(v41);

    if v42 then
        return TableUtil.Copy(v41, true);
    end;

    u9:AtError():Log((`Ignored invalid local egg record for {p40}: {v43}`));

    return nil;
end;

function u10.RequestRuntimeSnapshot() -- Line: 273
    -- upvalues: u3 (ref), Network (copy), Eggs2 (copy), Eggs (copy), applySnapshot (copy), u10 (copy)
    local v44 = Network.Invoke(Eggs2.REQUEST_RUNTIME_SNAPSHOT);
    local v45, v46 = Eggs.SchemaValidation.RuntimeEggSnapshot(v44);
    local v47 = `Invalid egg runtime snapshot: {v46}`;
    assert(v45, v47);
    applySnapshot(v44, u3);

    return u10.GetRuntimeSnapshot();
end;

function u10.RequestAreaEggSnapshot() -- Line: 284
    -- upvalues: u7 (ref), Network (copy), Eggs2 (copy), AreaEggs (copy), applyAreaEggSnapshot (copy), u10 (copy)
    local v48 = Network.Invoke(Eggs2.REQUEST_AREA_EGG_SNAPSHOT);
    local v49, v50 = AreaEggs.SchemaValidation.AreaEggSnapshot(v48);
    local v51 = `Invalid area egg snapshot: {v50}`;
    assert(v49, v51);
    applyAreaEggSnapshot(v48, u7);

    return u10.GetAreaEggSnapshot();
end;

function u10.RequestAreaEggRareSpawnPresentations() -- Line: 295
    -- upvalues: Network (copy), Eggs2 (copy), Asserts (copy), AreaEggResetCycle (copy)
    local v52, v53 = Network.Invoke(Eggs2.REQUEST_AREA_EGG_RARE_SPAWN_PRESENTATIONS);
    Asserts.boolean(v52);

    if not v52 then
        return false, nil;
    end;

    local v54, v55 = AreaEggResetCycle.SchemaValidation.RareSpawnPresentations(v53);
    local v56 = `Invalid area egg rare spawn presentations: {v55}`;
    assert(v54, v56);

    return true, v53;
end;

function u10.RequestEquipTool(p57) -- Line: 308
    -- upvalues: Asserts (copy), Network (copy), Eggs2 (copy)
    Asserts.string(p57);
    local v58, v59 = Network.Invoke(Eggs2.REQUEST_EQUIP_TOOL, p57);
    local v60 = v58 == true;

    if typeof(v59) == "string" then
        return v60, v59;
    end;

    return v60, nil;
end;

function u10.RequestCarryAreaEgg(p61, p62) -- Line: 315
    -- upvalues: Asserts (copy), Network (copy), Eggs2 (copy)
    Asserts.string(p61);
    Asserts.optional.string(p62);
    local v63, v64 = Network.Invoke(Eggs2.REQUEST_AREA_EGG_CARRY, {
        Uid = p61,
        FirstAreaSlotKey = p62
    });
    local v65 = v63 == true;

    if typeof(v64) == "string" then
        return v65, v64;
    end;

    return v65, nil;
end;

function u10.RequestDropHeldAreaEgg(p66) -- Line: 326
    -- upvalues: AreaEggs (copy), Network (copy), Eggs2 (copy)
    if p66 ~= nil then
        local v67, v68 = AreaEggs.SchemaValidation.DropReason(p66);
        assert(v67, v68);
    end;

    local v69, v70 = Network.Invoke(Eggs2.REQUEST_AREA_EGG_DROP, {
        Reason = p66
    });
    local v71 = v69 == true;

    if typeof(v70) == "string" then
        return v71, v70;
    end;

    return v71, nil;
end;

function u10.RequestUnequipTool(p72) -- Line: 338
    -- upvalues: Asserts (copy), Network (copy), Eggs2 (copy)
    Asserts.optional.string(p72);
    local v73, v74 = Network.Invoke(Eggs2.REQUEST_UNEQUIP_TOOL, p72);
    local v75 = v73 == true;

    if typeof(v74) == "string" then
        return v75, v74;
    end;

    return v75, nil;
end;

function u10.RequestPlaceEgg(p76, p77) -- Line: 345
    -- upvalues: Asserts (copy), u8 (copy), Network (copy), Eggs2 (copy)
    Asserts.string(p76);
    Asserts.CFrame(p77);
    u8[p76] = true;
    local v78, v79 = Network.Invoke(Eggs2.REQUEST_PLACE_EGG, {
        Uid = p76,
        LocalCFrame = p77
    });

    if v78 ~= true then
        u8[p76] = nil;
    end;

    local v80 = v78 == true;

    if typeof(v79) == "string" then
        return v80, v79;
    end;

    return v80, nil;
end;

function u10.ConsumeLocalPlaceAnimation(p81) -- Line: 360
    -- upvalues: Asserts (copy), u8 (copy)
    Asserts.string(p81);

    if u8[p81] ~= true then
        return false;
    end;

    u8[p81] = nil;

    return true;
end;

function u10.RequestSkipGrowth(p82) -- Line: 371
    -- upvalues: Asserts (copy), Network (copy), Eggs2 (copy), u9 (copy), u4 (ref)
    Asserts.string(p82);
    local v83, v84, v85 = Network.Invoke(Eggs2.REQUEST_SKIP_GROWTH, p82);

    if v83 == true then
        if typeof(v85) == "number" then
            u4 = p82;

            return true, nil, v85;
        end;

        u9:AtError():Log("Successful skip-growth request returned an invalid product ID");

        return false, "Invalid skip growth product", nil;
    end;

    if typeof(v84) ~= "string" then
        v84 = nil;
    end;

    return false, v84, nil;
end;

function u10.RequestHatchEgg(p86) -- Line: 387
    -- upvalues: Asserts (copy), Network (copy), Eggs2 (copy)
    Asserts.string(p86);
    local v87, v88 = Network.Invoke(Eggs2.REQUEST_HATCH_EGG, p86);
    local v89 = v87 == true;

    if typeof(v88) == "string" then
        return v89, v88;
    end;

    return v89, nil;
end;

function u10.RequestCompleteHatchEgg(p90) -- Line: 394
    -- upvalues: Asserts (copy), Network (copy), Eggs2 (copy), u9 (copy)
    Asserts.string(p90);
    local v91, v92, v93 = Network.Invoke(Eggs2.REQUEST_COMPLETE_HATCH_EGG, p90);

    if v91 == true then
        if typeof(v93) == "string" then
            return true, nil, v93;
        end;

        u9:AtError():Log("Successful hatch completion returned an invalid granted asset UID");

        return false, "Invalid granted asset UID", nil;
    end;

    if typeof(v92) ~= "string" then
        v92 = nil;
    end;

    return false, v92, nil;
end;

function u10.GetSelectedSkipGrowthUid() -- Line: 409
    -- upvalues: u4 (ref)
    return u4;
end;

function u10.ClearSelectedSkipGrowthUid() -- Line: 413
    -- upvalues: u4 (ref)
    u4 = nil;
end;

function u10.IsLocalEggReady(p94) -- Line: 417
    -- upvalues: Asserts (copy), u10 (copy), Players (copy), Workspace (copy), EggItemUtil (copy)
    Asserts.string(p94);
    local v95 = u10.GetRuntimeRecord(Players.LocalPlayer.UserId, p94);

    if v95 == nil or v95.Placement == nil then
        return false;
    end;

    local v96 = Workspace:GetServerTimeNow();

    return EggItemUtil.IsGrowthReady(v95, v96, v95.GrowthSpeedMultiplier, EggItemUtil.GetCurrentNightGrowthCreditSeconds(v95, v96, v95.GrowthSpeedMultiplier), Players.LocalPlayer);
end;

function u10.CanPurchaseSelectedSkipGrowth() -- Line: 434
    -- upvalues: u4 (ref), u10 (copy), Players (copy)
    local v97 = u4;

    if v97 == nil then
        return false, "No egg selected";
    end;

    local v98 = u10.GetRuntimeRecord(Players.LocalPlayer.UserId, v97);

    if v98 == nil or v98.Placement == nil then
        return false, "Egg not placed";
    end;

    if u10.IsLocalEggReady(v97) then
        return false, "Egg is already ready";
    end;

    return true;
end;

function u10.CanPurchaseGrowAll() -- Line: 451
    -- upvalues: u1 (ref), Players (copy), u10 (copy)
    local v99 = u1[Players.LocalPlayer.UserId];

    if v99 == nil then
        return false, "You have no growing eggs!";
    end;

    for i, v in pairs(v99) do
        if v.Placement ~= nil and not u10.IsLocalEggReady(i) then
            return true;
        end;
    end;

    return false, "You have no growing eggs!";
end;

function u10.GetRuntimeSnapshot() -- Line: 466
    -- upvalues: buildRuntimeSnapshotPayload (copy), u1 (ref)
    return buildRuntimeSnapshotPayload(u1);
end;

function u10.GetOwnerRuntimeRecords(p100) -- Line: 470
    -- upvalues: Asserts (copy), u1 (ref), TableUtil (copy)
    Asserts.number(p100);
    local v101 = u1[p100];

    return not v101 and {} or TableUtil.Copy(v101, true);
end;

function u10.GetRuntimeRecord(p102, p103) -- Line: 477
    -- upvalues: Asserts (copy), u1 (ref), TableUtil (copy)
    Asserts.number(p102);
    Asserts.string(p103);
    local v104 = u1[p102];
    local v105;

    if v104 then
        v105 = v104[p103];
    else
        v105 = nil;
    end;

    if v105 then
        return TableUtil.Copy(v105, true);
    end;

    return nil;
end;

function u10.GetAreaEggSnapshot() -- Line: 486
    -- upvalues: buildAreaEggSnapshot (copy), u5 (ref)
    return buildAreaEggSnapshot(u5);
end;

function u10.GetAreaEggRecord(p106) -- Line: 490
    -- upvalues: Asserts (copy), u5 (ref), TableUtil (copy)
    Asserts.string(p106);
    local v107 = u5[p106];

    if v107 then
        return TableUtil.Copy(v107, true);
    end;

    return nil;
end;

local function requestRuntimeSnapshotUntilReady() -- Line: 497
    -- upvalues: u10 (copy), u9 (copy), requestRuntimeSnapshotUntilReady (copy)
    local success, result = pcall(u10.RequestRuntimeSnapshot);

    if success then
        return;
    end;

    u9:AtError():Log((`Failed to load egg runtime snapshot; retrying: {result}`));
    task.delay(5, requestRuntimeSnapshotUntilReady);
end;

local function requestAreaEggSnapshotUntilReady() -- Line: 507
    -- upvalues: u10 (copy), u9 (copy), requestAreaEggSnapshotUntilReady (copy)
    local success, result = pcall(u10.RequestAreaEggSnapshot);

    if success then
        return;
    end;

    u9:AtError():Log((`Failed to load area egg snapshot; retrying: {result}`));
    task.delay(5, requestAreaEggSnapshotUntilReady);
end;

Network.Fired(Eggs2.RUNTIME_OWNER_UPDATED):Connect(handleOwnerUpdated);
Network.Fired(Eggs2.RUNTIME_OWNER_CLEARED):Connect(handleOwnerCleared);
Network.Fired(Eggs2.AREA_EGG_UPDATED):Connect(handleAreaEggUpdated);
Network.Fired(Eggs2.AREA_EGG_REMOVED):Connect(handleAreaEggRemoved);
Network.Fired(Eggs2.AREA_EGG_BATCH_UPDATED):Connect(handleAreaEggBatchUpdated);
Network.Fired(Eggs2.AREA_EGG_CARRY_STATE):Connect(function(p108) -- Line: 214, Name: handleAreaEggCarryState
    -- upvalues: AreaEggs (copy), u9 (copy), u10 (copy), TableUtil (copy)
    local v109, v110 = AreaEggs.SchemaValidation.AreaEggCarryState(p108);

    if v109 then
        u10.AreaEggCarryStateChanged:Fire(TableUtil.Copy(p108, true));

        return;
    end;

    u9:AtError():Log((`Ignored invalid area egg carry state: {v110}`));
end);
Network.Fired(Eggs2.AREA_EGG_CLAIM_FEEDBACK):Connect(function(p111) -- Line: 224, Name: handleAreaEggClaimFeedback
    -- upvalues: AreaEggs (copy), u9 (copy), Players (copy), Workspace (copy), u10 (copy)
    local v112, v113 = AreaEggs.SchemaValidation.AreaEggClaimFeedback(p111);

    if not v112 then
        u9:AtError():Log((`Ignored invalid area egg claim feedback: {v113}`));

        return;
    end;

    u9:AtInfo():Log("Area egg claim latency trace", {
        Stage = "CLIENT_FEEDBACK_RECEIVED",
        UserId = Players.LocalPlayer.UserId,
        ServerTime = Workspace:GetServerTimeNow(),
        AssetCategory = p111.AssetCategory,
        DisplayName = p111.DisplayName
    });
    u10.AreaEggClaimed:Fire(p111);
end);
Network.Fired(Eggs2.AREA_EGG_RESET_START_COUNTDOWN):Connect(function(p114) -- Line: 242, Name: handleAreaEggResetStartCountdown
    -- upvalues: AreaEggResetCycle (copy), u9 (copy), u10 (copy)
    local v115, v116 = AreaEggResetCycle.SchemaValidation.SequencePayload(p114);

    if v115 then
        u10.AreaEggResetStartCountdown:Fire(p114);

        return;
    end;

    u9:AtError():Log((`Ignored invalid area egg reset sequence: {v116}`));
end);
task.spawn(requestRuntimeSnapshotUntilReady);
task.spawn(requestAreaEggSnapshotUntilReady);
Players.PlayerRemoving:Connect(function(p117) -- Line: 532
    -- upvalues: u3 (ref), u2 (copy), u1 (ref), u10 (copy)
    u3 = u3 + 1;
    u2[p117.UserId] = u3;
    local v118 = {
        OwnerUserId = p117.UserId
    };
    u1[v118.OwnerUserId] = nil;
    u10.RuntimeOwnerCleared:Fire(v118.OwnerUserId);
    u10.RuntimeSnapshotUpdated:Fire(u10.GetRuntimeSnapshot());
end);

return u10;