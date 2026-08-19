-- Decompiled with Potassium's decompiler.

local MarketplaceService = game:GetService("MarketplaceService");
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActiveAssetIncomePopup = require(script.Parent.Parent.Parent.GUI.ActiveAssetIncomePopup);
local ActiveAssetPerformanceTest = require(script.ActiveAssetPerformanceTest);
local ActiveAssetPerformanceTestConfig = require(script.ActiveAssetPerformanceTestConfig);
local AssetHoverDataDisplay = require(script.Parent.Parent.Parent.GUI.AssetHoverDataDisplay);
local AssetBillboardController = require(script.AssetBillboardController);
local AssetChatBubbleComponent = require(ReplicatedStorage.Library.Client.UI.AssetChatBubbleComponent);
local AssetCmds = require(ReplicatedStorage.Library.Client.AssetCmds);
local AssetComponent = require(script.AssetComponent);
local AssetMovementBatch = require(script.AssetMovementBatch);
local AssetPlacementHints = require(script.AssetPlacementHints);
require(ReplicatedStorage.Library.Types.AssetRuntime);
local ActiveAssets = require(ReplicatedStorage.Library.Types.ActiveAssets);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Products = require(ReplicatedStorage.Directory.Products);
local SettingsCmds = require(ReplicatedStorage.Library.Client.SettingsCmds);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local ModelCameraOcclusionController = require(ReplicatedStorage.Library.Client.ModelCameraOcclusionController);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local ActiveAssets2 = Network.NET_MAP.ActiveAssets;
local u1 = AssetMovementBatch.new();
local u2 = AssetBillboardController.new();
local u3 = SettingsCmds.IsEnabled("HideOtherPets");
local Folder = Instance.new("Folder");
Folder.Name = "ClientRenderedAssets";
Folder.Parent = workspace;
local u4 = {};
local u5 = false;
local u6 = {};
local u7 = {};

for _, v in pairs(Products.Directory) do
    if typeof(v.StealRarity) == "string" then
        u4[v.ProductId] = true;
    end;
end;

local u8 = {
    ItemAdded = Signal.new(),
    ItemRemoved = Signal.new(),
    CashCollected = Signal.new(),
    InitialLoadCompleted = Signal.new()
};

local function makeKey(p9, p10) -- Line: 71
    return `{p9}:{p10}`;
end;

local function recordForComponent(p11, p12) -- Line: 75
    -- upvalues: u6 (copy)
    if p12.IsFirstPlacement ~= true then
        return p12;
    end;

    if u6[p11] ~= true then
        u6[p11] = true;

        return p12;
    end;

    local v13 = table.clone(p12);
    local v14 = table.clone(p12.ItemData);
    v14.Mutations = table.clone(p12.ItemData.Mutations);
    v13.ItemData = v14;
    v13.IsFirstPlacement = nil;

    return v13;
end;

local function syncHoverEntry(u15) -- Line: 94
    -- upvalues: u3 (ref), Players (copy), AssetHoverDataDisplay (copy), Constants (copy)
    local v16 = u15:GetOwnerUserId();
    local v17 = u15:GetUid();

    if u3 and v16 ~= Players.LocalPlayer.UserId then
        AssetHoverDataDisplay.RemoveEntry(v16, v17);

        return;
    end;

    local v18 = u15:GetRuntimeRecord();
    AssetHoverDataDisplay.SetEntry({
        Record = v18,
        Model = u15:GetModel(),
        ActivateSteal = Constants.ASSET_DNA_STEAL_ENABLED and v16 ~= Players.LocalPlayer.UserId and function() -- Line: 108
            -- upvalues: u15 (copy)
            u15:ActivateDnaSteal();
        end or nil
    });
end;

local function applyComponentHiddenState(p19) -- Line: 114
    -- upvalues: Players (copy), u3 (ref), ModelCameraOcclusionController (copy), u2 (copy)
    if p19:GetOwnerUserId() == Players.LocalPlayer.UserId then
        return;
    end;

    local v20 = u3;

    if p19:IsHidden() == v20 then
        return;
    end;

    local v21 = p19:GetModel();

    if v20 then
        ModelCameraOcclusionController.SetModelSuppressed(v21, true);
        p19:SetHidden(true);
        u2:SetSuppressed(v21, true);

        return;
    end;

    p19:SetHidden(false);
    u2:SetSuppressed(v21, false);
    ModelCameraOcclusionController.SetModelSuppressed(v21, false);
end;

local function setHideOtherPets(p22) -- Line: 137
    -- upvalues: u3 (ref), u1 (copy), u7 (copy), applyComponentHiddenState (copy), syncHoverEntry (copy)
    if u3 == p22 then
        return;
    end;

    u3 = p22;

    if p22 then
        u1:SetForeignPresentationSuppressed(true);
    end;

    for _, v in pairs(u7) do
        if v ~= nil then
            applyComponentHiddenState(v);
            syncHoverEntry(v);
        end;
    end;

    if not p22 then
        u1:SetForeignPresentationSuppressed(false);
    end;
end;

local function destroyComponent(p23) -- Line: 157
    -- upvalues: u7 (copy), u2 (copy), AssetHoverDataDisplay (copy), u8 (copy)
    local v24 = u7[p23];

    if v24 == nil then
        return;
    end;

    local v25 = v24:GetModel();
    u2:Remove(v25);
    AssetHoverDataDisplay.RemoveEntry(v24:GetOwnerUserId(), v24:GetUid());
    v24:Destroy();
    u7[p23] = nil;
    u8.ItemRemoved:Fire(v25);
end;

local function clearOwner(p26) -- Line: 170
    -- upvalues: u7 (copy), destroyComponent (copy)
    for i, v in pairs(u7) do
        if v ~= nil and v:GetOwnerUserId() == p26 then
            destroyComponent(i);
        end;
    end;
end;

local function reconcileOwner(p27, p28) -- Line: 178
    -- upvalues: Players (copy), clearOwner (copy), AssetCmds (copy), recordForComponent (copy), u7 (copy), AssetPlacementHints (copy), AssetComponent (copy), Folder (copy), u2 (copy), u1 (copy), u8 (copy), applyComponentHiddenState (copy), syncHoverEntry (copy), destroyComponent (copy)
    local v29 = Players:GetPlayerByUserId(p27);

    if v29 == nil then
        clearOwner(p27);

        return;
    end;

    local v30 = AssetCmds.ResolveAssetArea(v29);

    if v30 == nil then
        return;
    end;

    local v31 = {};

    for i, v in pairs(p28) do
        local v32 = `{p27}:{i}`;
        v31[v32] = true;
        local v33 = recordForComponent(v32, v);
        local v34 = u7[v32];

        if v34 == nil then
            local v35;

            if v29 == Players.LocalPlayer then
                v35 = AssetPlacementHints.ConsumeFrontPlacement(i, v30);
            else
                v35 = nil;
            end;

            v34 = AssetComponent.new(v33, v29, v30, Folder, u2, u1, v35);
            u7[v32] = v34;
            u2:Add(v34:GetModel(), v33.ItemData, v33.MoneyPerSecond);
            u8.ItemAdded:Fire(v34:GetModel());
        else
            if v29 == Players.LocalPlayer then
                AssetPlacementHints.ClearFrontPlacement(i);
            end;

            v34:SetRuntimeRecord(v33);
            v34:SetAssetArea(v30);
            u2:UpdateMoneyPerSecond(v34:GetModel(), v33.MoneyPerSecond);
        end;

        applyComponentHiddenState(v34);
        syncHoverEntry(v34);
    end;

    for i, v in pairs(u7) do
        if v ~= nil and (v:GetOwnerUserId() == p27 and v31[i] ~= true) then
            destroyComponent(i);
        end;
    end;
end;

local function reconcileSnapshot(p36) -- Line: 230
    -- upvalues: reconcileOwner (copy), u7 (copy), destroyComponent (copy)
    local v37 = {};

    for _, v in ipairs(p36) do
        v37[v.OwnerUserId] = true;
        reconcileOwner(v.OwnerUserId, v.Records);
    end;

    for i, v in pairs(u7) do
        if v ~= nil and v37[v:GetOwnerUserId()] ~= true then
            destroyComponent(i);
        end;
    end;
end;

function u8.GetModelByUID(p38) -- Line: 247
    -- upvalues: u7 (copy)
    for _, v in pairs(u7) do
        if v ~= nil and v:GetUid() == p38 then
            return v:GetModel();
        end;
    end;

    return nil;
end;

function u8.GetAll() -- Line: 256
    -- upvalues: u7 (copy)
    local v39 = {};

    for _, v in pairs(u7) do
        if v ~= nil then
            v39[v:GetUid()] = v:GetModel();
        end;
    end;

    return v39;
end;

function u8.GetActiveModels() -- Line: 266
    -- upvalues: u8 (copy)
    local v40 = {};

    for _, v in pairs(u8.GetAll()) do
        table.insert(v40, v);
    end;

    return v40;
end;

AssetCmds.RuntimeSnapshotUpdated:Connect(reconcileSnapshot);
AssetCmds.RuntimeOwnerUpdated:Connect(reconcileOwner);
AssetCmds.RuntimeOwnerCleared:Connect(clearOwner);
u8.ItemAdded:Connect(function(p41) -- Line: 281
    -- upvalues: ModelCameraOcclusionController (copy)
    ModelCameraOcclusionController.TrackModel(p41, 1);
end);
u8.ItemRemoved:Connect(ModelCameraOcclusionController.UntrackModel);
SettingsCmds.Changed:Connect(function(p42) -- Line: 285
    -- upvalues: setHideOtherPets (copy), SettingsCmds (copy)
    if p42 == "HideOtherPets" then
        setHideOtherPets(SettingsCmds.IsEnabled("HideOtherPets"));
    end;
end);
Network.Fired(Network.NET_MAP.Treadmills.ACTIVE_TREADMILL_EVENT):Connect(function(p43) -- Line: 290
    -- upvalues: u5 (ref), ModelCameraOcclusionController (copy), AssetChatBubbleComponent (copy)
    u5 = p43 ~= nil;
    ModelCameraOcclusionController.SetSessionActive(u5);
    AssetChatBubbleComponent.SetAlwaysOnTop(not u5);
end);
AssetCmds.AssetAreaAvailabilityChanged:Connect(function(p44) -- Line: 295
    -- upvalues: reconcileOwner (copy), AssetCmds (copy)
    reconcileOwner(p44.UserId, AssetCmds.GetOwnerRuntimeRecords(p44.UserId));
end);
Players.PlayerRemoving:Connect(function(p45) -- Line: 298
    -- upvalues: clearOwner (copy)
    clearOwner(p45.UserId);
end);
Network.Fired(ActiveAssets2.MONEY_COLLECTED_EVENT):Connect(function(p46) -- Line: 301
    -- upvalues: u8 (copy), ActiveAssetIncomePopup (copy), u5 (ref)
    for _, v in ipairs(p46) do
        local uid = v.uid;

        if uid ~= nil then
            u8.CashCollected:Fire(uid);
            local v47 = v.amount > 0;
            local v48 = `Active asset income popup requires positive amount for uid "{uid}"`;
            assert(v47, v48);
            local v49 = u8.GetModelByUID(uid);
            local v50 = `Active asset income popup missing rendered model for uid "{uid}"`;
            local v51 = assert(v49, v50);
            ActiveAssetIncomePopup.Show(v51, v.amount, {
                alwaysOnTop = not u5
            });
        end;
    end;
end);
Network.Fired(ActiveAssets2.DNA_STEAL_ANIMATION):Connect(function(p52) -- Line: 317
    -- upvalues: ActiveAssets (copy), u7 (copy)
    local v53 = ActiveAssets.DnaStealAnimationPayload(p52);
    assert(v53, "Invalid DNA steal animation payload");
    local v54 = u7[`{p52.OwnerUserId}:{p52.UID}`];
    local v55 = `DNA steal animation missing rendered asset {p52.OwnerUserId}:{p52.UID}`;
    assert(v54, v55):PlayDnaStealAnimation(p52);
end);
MarketplaceService.PromptProductPurchaseFinished:Connect(function(p56, p57, p58) -- Line: 325
    -- upvalues: Players (copy), u4 (copy), Network (copy), ActiveAssets2 (copy)
    if p56 == Players.LocalPlayer.UserId and (not p58 and u4[p57] == true) then
        Network.Fire(ActiveAssets2.STEAL_TARGET_EVENT, {
            Clear = true,
            ProductId = p57
        });
    end;
end);

if ActiveAssetPerformanceTestConfig.Enabled and Constants.IS_STUDIO then
    ActiveAssetPerformanceTest.Start(Folder, u2, u1);
end;

u1:SetForeignPresentationSuppressed(u3);
reconcileSnapshot(AssetCmds.GetRuntimeSnapshot());
u8.InitialLoadCompleted:Fire();

return u8;