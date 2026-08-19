-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
require(ReplicatedStorage.Library.Types.AreaEggs);
require(ReplicatedStorage.Library.Types.AreaEggResetCycle);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Assets = require(ReplicatedStorage.Directory.Assets);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Rarity = require(ReplicatedStorage.Directory.Rarity);
local WorkspaceEggVisibility = require(script.Parent.WorkspaceEggVisibility);
local u1 = Log.new();
local u2 = {};
local u3 = {};
local u4 = {};
local u5 = nil;
local u6 = false;
local u7 = (-1 / 0);
local u8 = false;
local v9 = {};

local function getOutlineColor(p10) -- Line: 47
    -- upvalues: Assets (copy), Rarity (copy)
    local v11 = Assets.Directory[p10];
    local v12 = `Missing asset config {p10}`;
    assert(v11 ~= nil, v12);
    local Rarity2 = v11.Rarity;

    if Rarity2 == Rarity.Rarities.Secret or Rarity2 == Rarity.Rarities.Eternal then
        return Rarity2.Color;
    end;

    return nil;
end;

local function clearBinding(p13) -- Line: 57
    -- upvalues: u3 (copy)
    local v14 = u3[p13];

    if v14 == nil then
        return;
    end;

    u3[p13] = nil;
    local DestroyConnection = v14.DestroyConnection;

    if DestroyConnection ~= nil then
        DestroyConnection:Disconnect();
    end;

    if v14.Highlight.Parent ~= nil then
        v14.Highlight:Destroy();
    end;
end;

local function clearAllBindings() -- Line: 72
    -- upvalues: u3 (copy)
    for i in pairs(u3) do
        local v15 = u3[i];

        if v15 ~= nil then
            u3[i] = nil;
            local DestroyConnection = v15.DestroyConnection;

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect();
            end;

            if v15.Highlight.Parent ~= nil then
                v15.Highlight:Destroy();
            end;
        end;
    end;
end;

local function bindModel(u16, p17, p18) -- Line: 78
    -- upvalues: u3 (copy)
    local v19 = u3[u16];

    if v19 ~= nil and v19.Model == p17 then
        v19.Highlight.OutlineColor = p18;

        return;
    end;

    local v20 = u3[u16];

    if v20 ~= nil then
        u3[u16] = nil;
        local DestroyConnection = v20.DestroyConnection;

        if DestroyConnection ~= nil then
            DestroyConnection:Disconnect();
        end;

        if v20.Highlight.Parent ~= nil then
            v20.Highlight:Destroy();
        end;
    end;

    local Highlight = Instance.new("Highlight");
    Highlight.Name = "RareAreaEggHighlight";
    Highlight.Adornee = p17;
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop;
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 0.25;
    Highlight.OutlineColor = p18;
    Highlight.Parent = p17;
    local u21 = {
        DestroyConnection = nil,
        Model = p17,
        Highlight = Highlight
    };
    u3[u16] = u21;
    u21.DestroyConnection = p17.Destroying:Connect(function() -- Line: 101
        -- upvalues: u3 (ref), u16 (copy), u21 (copy)
        if u3[u16] == u21 then
            u3[u16] = nil;
        end;
    end);
end;

local function syncUid(p22) -- Line: 108
    -- upvalues: u2 (copy), u4 (copy), u3 (copy), u6 (ref), Assets (copy), Rarity (copy), bindModel (copy), WorkspaceEggVisibility (copy)
    local v23 = u2[p22];

    if v23 == nil then
        u4[p22] = nil;
        local v24 = u3[p22];

        if v24 == nil then
            return;
        end;

        u3[p22] = nil;
        local DestroyConnection = v24.DestroyConnection;

        if DestroyConnection ~= nil then
            DestroyConnection:Disconnect();
        end;

        if v24.Highlight.Parent ~= nil then
            v24.Highlight:Destroy();
        end;

        return;
    end;

    if u6 then
        local v25 = u3[p22];

        if v25 == nil then
            return;
        end;

        u3[p22] = nil;
        local DestroyConnection = v25.DestroyConnection;

        if DestroyConnection ~= nil then
            DestroyConnection:Disconnect();
        end;

        if v25.Highlight.Parent ~= nil then
            v25.Highlight:Destroy();
        end;

        return;
    end;

    local v26 = Assets.Directory[v23];
    local v27 = `Missing asset config {v23}`;
    assert(v26 ~= nil, v27);
    local Rarity2 = v26.Rarity;
    local v28;

    if Rarity2 == Rarity.Rarities.Secret or Rarity2 == Rarity.Rarities.Eternal then
        v28 = Rarity2.Color;
    else
        v28 = nil;
    end;

    if v28 == nil then
        u4[p22] = nil;
        local v29 = u3[p22];

        if v29 == nil then
            return;
        end;

        u3[p22] = nil;
        local DestroyConnection = v29.DestroyConnection;

        if DestroyConnection ~= nil then
            DestroyConnection:Disconnect();
        end;

        if v29.Highlight.Parent ~= nil then
            v29.Highlight:Destroy();
        end;

        return;
    end;

    local v30 = u4[p22];
    u4[p22] = nil;

    if v30 ~= nil and v30.Parent ~= nil then
        bindModel(p22, v30, v28);

        return;
    end;

    local v31 = u3[p22];

    if v31 ~= nil and v31.Model.Parent ~= nil then
        v31.Highlight.OutlineColor = v28;

        return;
    end;

    local v32 = WorkspaceEggVisibility.ResolveModel(p22);

    if v32 ~= nil then
        bindModel(p22, v32, v28);
    end;
end;

local function beginResetReveal(p33) -- Line: 143
    -- upvalues: u7 (ref), u6 (ref), u4 (copy), u3 (copy)
    if p33.DayStartsAt <= u7 then
        return;
    end;

    u7 = p33.DayStartsAt;
    u6 = true;
    table.clear(u4);

    for i in pairs(u3) do
        local v34 = u3[i];

        if v34 ~= nil then
            u3[i] = nil;
            local DestroyConnection = v34.DestroyConnection;

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect();
            end;

            if v34.Highlight.Parent ~= nil then
                v34.Highlight:Destroy();
            end;
        end;
    end;
end;

local function completeResetReveal() -- Line: 153
    -- upvalues: u6 (ref), u2 (copy), syncUid (copy)
    u6 = false;

    for i in pairs(u2) do
        syncUid(i);
    end;
end;

local function applyRecord(p35) -- Line: 160
    -- upvalues: u2 (copy), syncUid (copy)
    u2[p35.Uid] = p35.AssetCategory;
    syncUid(p35.Uid);
end;

local function applySnapshot(p36) -- Line: 165
    -- upvalues: u2 (copy), u5 (ref), u4 (copy), u3 (copy), syncUid (copy)
    local v37 = {};

    for _, v in ipairs(p36.Records) do
        v37[v.Uid] = true;
        u2[v.Uid] = v.AssetCategory;
    end;

    for i in pairs(u2) do
        if v37[i] ~= true and i ~= u5 then
            u2[i] = nil;
            u4[i] = nil;
            local v38 = u3[i];

            if v38 ~= nil then
                u3[i] = nil;
                local DestroyConnection = v38.DestroyConnection;

                if DestroyConnection ~= nil then
                    DestroyConnection:Disconnect();
                end;

                if v38.Highlight.Parent ~= nil then
                    v38.Highlight:Destroy();
                end;
            end;
        end;
    end;

    for i in pairs(v37) do
        syncUid(i);
    end;
end;

local function applyCarryState(p39) -- Line: 183
    -- upvalues: u5 (ref), u2 (copy), syncUid (copy), EggCmds (copy), u4 (copy), u3 (copy)
    local v40 = u5;

    if p39.IsCarrying then
        local v41 = assert(p39.Uid, "Carried area egg state must include Uid");
        local v42 = assert(p39.AssetCategory, "Carried area egg state must include AssetCategory");
        u5 = v41;
        u2[v41] = v42;
        syncUid(v41);

        return;
    end;

    u5 = nil;

    if v40 == nil then
        return;
    end;

    local v43 = EggCmds.GetAreaEggRecord(v40);

    if v43 ~= nil then
        u2[v43.Uid] = v43.AssetCategory;
        syncUid(v43.Uid);

        return;
    end;

    u2[v40] = nil;
    u4[v40] = nil;
    local v44 = u3[v40];

    if v44 == nil then
        return;
    end;

    u3[v40] = nil;
    local DestroyConnection = v44.DestroyConnection;

    if DestroyConnection ~= nil then
        DestroyConnection:Disconnect();
    end;

    if v44.Highlight.Parent ~= nil then
        v44.Highlight:Destroy();
    end;
end;

local function observeWorkspaceChild(u45) -- Line: 208
    -- upvalues: u6 (ref), u2 (copy), Workspace (copy), Assets (copy), Rarity (copy), bindModel (copy)
    if not u45:IsA("Model") then
        return;
    end;

    task.defer(function() -- Line: 212
        -- upvalues: u6 (ref), u45 (copy), u2 (ref), Workspace (ref), Assets (ref), Rarity (ref), bindModel (ref)
        if u6 then
            return;
        end;

        local Name = u45.Name;
        local v46 = u2[Name];

        if u45.Parent ~= Workspace or v46 == nil then
            return;
        end;

        local v47 = Assets.Directory[v46];
        local v48 = `Missing asset config {v46}`;
        assert(v47 ~= nil, v48);
        local Rarity2 = v47.Rarity;
        local v49;

        if Rarity2 == Rarity.Rarities.Secret or Rarity2 == Rarity.Rarities.Eternal then
            v49 = Rarity2.Color;
        else
            v49 = nil;
        end;

        if v49 ~= nil then
            bindModel(Name, u45, v49);
        end;
    end);
end;

function v9.BindRenderedModel(p50, p51) -- Line: 232
    -- upvalues: Asserts (copy), u2 (copy), u6 (ref), u4 (copy), u3 (copy), Assets (copy), Rarity (copy), bindModel (copy)
    Asserts.table(p50);
    Asserts.Model(p51);
    u2[p50.Uid] = p50.AssetCategory;

    if u6 then
        u4[p50.Uid] = p51;
        local Uid = p50.Uid;
        local v52 = u3[Uid];

        if v52 == nil then
            return;
        end;

        u3[Uid] = nil;
        local DestroyConnection = v52.DestroyConnection;

        if DestroyConnection ~= nil then
            DestroyConnection:Disconnect();
        end;

        if v52.Highlight.Parent ~= nil then
            v52.Highlight:Destroy();
        end;

        return;
    end;

    local AssetCategory = p50.AssetCategory;
    local v53 = Assets.Directory[AssetCategory];
    local v54 = `Missing asset config {AssetCategory}`;
    assert(v53 ~= nil, v54);
    local Rarity2 = v53.Rarity;
    local v55;

    if Rarity2 == Rarity.Rarities.Secret or Rarity2 == Rarity.Rarities.Eternal then
        v55 = Rarity2.Color;
    else
        v55 = nil;
    end;

    if v55 ~= nil then
        bindModel(p50.Uid, p51, v55);

        return;
    end;

    local Uid = p50.Uid;
    local v56 = u3[Uid];

    if v56 == nil then
        return;
    end;

    u3[Uid] = nil;
    local DestroyConnection = v56.DestroyConnection;

    if DestroyConnection ~= nil then
        DestroyConnection:Disconnect();
    end;

    if v56.Highlight.Parent ~= nil then
        v56.Highlight:Destroy();
    end;
end;

function v9.Start() -- Line: 249
    -- upvalues: u8 (ref), EggCmds (copy), beginResetReveal (copy), completeResetReveal (copy), applySnapshot (copy), applyRecord (copy), u5 (ref), u2 (copy), u4 (copy), u3 (copy), syncUid (copy), applyCarryState (copy), Workspace (copy), observeWorkspaceChild (copy), u1 (copy)
    assert(not u8, "RareEggHighlight.Start may only be called once");
    u8 = true;
    EggCmds.AreaEggResetStartCountdown:Connect(beginResetReveal);
    EggCmds.AreaEggRareSpawnsPresented:Connect(completeResetReveal);
    EggCmds.AreaEggSnapshotUpdated:Connect(applySnapshot);
    EggCmds.AreaEggUpdated:Connect(applyRecord);
    EggCmds.AreaEggRemoved:Connect(function(p57) -- Line: 256
        -- upvalues: u5 (ref), u2 (ref), u4 (ref), u3 (ref), syncUid (ref)
        if p57 == u5 then
            syncUid(p57);
        else
            u2[p57] = nil;
            u4[p57] = nil;
            local v58 = u3[p57];

            if v58 == nil then
                return;
            end;

            u3[p57] = nil;
            local DestroyConnection = v58.DestroyConnection;

            if DestroyConnection ~= nil then
                DestroyConnection:Disconnect();
            end;

            if v58.Highlight.Parent ~= nil then
                v58.Highlight:Destroy();
            end;
        end;
    end);
    EggCmds.AreaEggCarryStateChanged:Connect(applyCarryState);
    Workspace.ChildAdded:Connect(observeWorkspaceChild);
    applySnapshot(EggCmds.GetAreaEggSnapshot());
    u1:AtDebug():Log("Rare area egg highlight lifecycle started");
end;

return table.freeze(v9);