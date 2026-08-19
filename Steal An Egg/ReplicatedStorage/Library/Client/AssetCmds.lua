-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetRuntime = require(ReplicatedStorage.Library.Types.AssetRuntime);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local ActiveAssets = Network.NET_MAP.ActiveAssets;
local u1 = Log.new();
local u2 = {
    RuntimeSnapshotUpdated = Signal.new(),
    RuntimeOwnerUpdated = Signal.new(),
    RuntimeOwnerCleared = Signal.new(),
    AssetAreaAvailabilityChanged = Signal.new()
};
local u3 = {};
local u4 = {};
local u5 = 0;

local function cloneRecord(p6) -- Line: 41
    local v7 = table.clone(p6.ItemData);
    v7.Mutations = table.clone(p6.ItemData.Mutations);

    return {
        OwnerUserId = p6.OwnerUserId,
        UID = p6.UID,
        ItemData = v7,
        MoneyPerSecond = p6.MoneyPerSecond,
        Seed = p6.Seed,
        IsFirstPlacement = p6.IsFirstPlacement
    };
end;

local function materializeRuntimeRecords(p8) -- Line: 54
    -- upvalues: cloneRecord (copy)
    local v9 = {};

    for i, v in pairs(p8) do
        v9[i] = cloneRecord(v);
    end;

    return v9;
end;

local function buildSnapshot() -- Line: 62
    -- upvalues: u3 (ref), materializeRuntimeRecords (copy)
    local v10 = {};

    for i, v in pairs(u3) do
        local v11 = {
            OwnerUserId = i,
            Records = materializeRuntimeRecords(v)
        };
        table.insert(v10, v11);
    end;

    return v10;
end;

local function applySnapshot(p12, p13) -- Line: 70
    -- upvalues: u3 (ref), u4 (copy), materializeRuntimeRecords (copy), u2 (copy), buildSnapshot (copy)
    local v14 = {};

    for i, v in pairs(u3) do
        if p13 < (u4[i] or 0) then
            v14[i] = materializeRuntimeRecords(v);
        end;
    end;

    for _, v in ipairs(p12) do
        if (u4[v.OwnerUserId] or 0) <= p13 then
            v14[v.OwnerUserId] = materializeRuntimeRecords(v.Records);
        end;
    end;

    u3 = v14;
    u2.RuntimeSnapshotUpdated:Fire((buildSnapshot()));
end;

local function handleOwnerUpdated(p15) -- Line: 87
    -- upvalues: AssetRuntime (copy), u1 (copy), u5 (ref), u4 (copy), u3 (ref), materializeRuntimeRecords (copy), u2 (copy), buildSnapshot (copy)
    local v16, v17 = AssetRuntime.SchemaValidation.RuntimeAssetOwnerUpdate(p15);

    if not v16 then
        u1:AtError():Log((`Invalid asset runtime owner update: {v17}`));

        return;
    end;

    u5 = u5 + 1;
    u4[p15.OwnerUserId] = u5;
    u3[p15.OwnerUserId] = materializeRuntimeRecords(p15.Records);
    u2.RuntimeOwnerUpdated:Fire(p15.OwnerUserId, (materializeRuntimeRecords(p15.Records)));
    u2.RuntimeSnapshotUpdated:Fire((buildSnapshot()));
end;

local function handleOwnerCleared(p18) -- Line: 101
    -- upvalues: AssetRuntime (copy), u1 (copy), u5 (ref), u4 (copy), u3 (ref), u2 (copy), buildSnapshot (copy)
    local v19, v20 = AssetRuntime.SchemaValidation.RuntimeAssetOwnerClear(p18);

    if not v19 then
        u1:AtError():Log((`Invalid asset runtime owner clear: {v20}`));

        return;
    end;

    u5 = u5 + 1;
    u4[p18.OwnerUserId] = u5;
    u3[p18.OwnerUserId] = nil;
    u2.RuntimeOwnerCleared:Fire(p18.OwnerUserId);
    u2.RuntimeSnapshotUpdated:Fire((buildSnapshot()));
end;

local function requestRuntimeSnapshot() -- Line: 125
    -- upvalues: u5 (ref), Network (copy), ActiveAssets (copy), AssetRuntime (copy), applySnapshot (copy)
    local success, result = pcall(function() -- Line: 127
        -- upvalues: Network (ref), ActiveAssets (ref)
        return Network.Invoke(ActiveAssets.REQUEST_RUNTIME_SNAPSHOT);
    end);

    if not success then
        return false, tostring(result);
    end;

    local v21, v22 = AssetRuntime.SchemaValidation.RuntimeAssetSnapshot(result);

    if not v21 then
        return false, `Invalid asset runtime snapshot: {v22}`;
    end;

    applySnapshot(result, u5);

    return true, nil;
end;

local function requestRuntimeSnapshotUntilReady() -- Line: 143
    -- upvalues: requestRuntimeSnapshot (copy), u1 (copy), requestRuntimeSnapshotUntilReady (copy)
    local v23, v24 = requestRuntimeSnapshot();

    if v23 then
        return;
    end;

    u1:AtError():Log((`Failed to load asset runtime snapshot; retrying: {v24}`));
    task.delay(5, requestRuntimeSnapshotUntilReady);
end;

function u2.RequestEquipAsset(p25) -- Line: 157
    -- upvalues: Network (copy), ActiveAssets (copy)
    local v26, v27, v28 = Network.Invoke(ActiveAssets.REQUEST_EQUIP, p25);
    local v29 = v26 == true;

    if typeof(v27) ~= "string" then
        v27 = nil;
    end;

    if typeof(v28) == "string" then
        return v29, v27, v28;
    end;

    return v29, v27, nil;
end;

function u2.RequestUnequipAsset(p30) -- Line: 164
    -- upvalues: Network (copy), ActiveAssets (copy)
    local v31, v32 = Network.Invoke(ActiveAssets.REQUEST_UNEQUIP, p30);
    local v33 = v31 == true;

    if typeof(v32) == "string" then
        return v33, v32;
    end;

    return v33, nil;
end;

function u2.RequestEquipLimit() -- Line: 169
    -- upvalues: Network (copy), ActiveAssets (copy)
    local v34 = Network.Invoke(ActiveAssets.REQUEST_EQUIP_LIMIT);

    return typeof(v34) ~= "number" and 0 or v34;
end;

function u2.AcknowledgePenFullPetsBadge() -- Line: 174
    -- upvalues: Network (copy), ActiveAssets (copy)
    return Network.Invoke(ActiveAssets.ACKNOWLEDGE_PEN_FULL_PETS_BADGE) == true;
end;

function u2.AcknowledgePenFullEquipBestBadge() -- Line: 178
    -- upvalues: Network (copy), ActiveAssets (copy)
    return Network.Invoke(ActiveAssets.ACKNOWLEDGE_PEN_FULL_EQUIP_BEST_BADGE) == true;
end;

function u2.GetRuntimeSnapshot() -- Line: 182
    -- upvalues: buildSnapshot (copy)
    return buildSnapshot();
end;

function u2.GetOwnerRuntimeRecords(p35) -- Line: 186
    -- upvalues: u3 (ref), materializeRuntimeRecords (copy)
    local v36 = u3[p35];

    return v36 == nil and {} or materializeRuntimeRecords(v36);
end;

function u2.ResolveAssetArea(p37) -- Line: 191
    -- upvalues: PlotCmds (copy)
    local v38 = PlotCmds.GetPlotData(p37);

    if v38 == nil then
        return nil;
    end;

    return v38.PetArea;
end;

Network.Fired(ActiveAssets.RUNTIME_OWNER_UPDATED):Connect(handleOwnerUpdated);
Network.Fired(ActiveAssets.RUNTIME_OWNER_CLEARED):Connect(handleOwnerCleared);
PlotCmds.OnAnyPlotUpdated:Connect(function(p39, p40) -- Line: 115, Name: handlePlotUpdated
    -- upvalues: Players (copy), u2 (copy)
    if p40 == nil then
        return;
    end;

    local v41 = Players:GetPlayerByUserId(p40);

    if v41 ~= nil then
        u2.AssetAreaAvailabilityChanged:Fire(v41, u2.ResolveAssetArea(v41));
    end;
end);
task.spawn(requestRuntimeSnapshotUntilReady);

return u2;