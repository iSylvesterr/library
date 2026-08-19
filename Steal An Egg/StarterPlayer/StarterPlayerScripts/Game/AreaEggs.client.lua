-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local AreaEggs = require(ReplicatedStorage.Library.Types.AreaEggs);
local AreaEggNearbyPulse = require(script.AreaEggNearbyPulse);
local CarryRunBackEffects = require(script.CarryRunBackEffects);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local EggRenderer = require(ReplicatedStorage.Library.Client.Eggs.EggRenderer);
local AreaEggSlotIdentity = require(ReplicatedStorage.Library.Util.AreaEggSlotIdentity);
local GuardAreaLookupUtil = require(ReplicatedStorage.Library.Util.GuardAreaLookupUtil);
local HoverHighlight = require(script.HoverHighlight);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local RewardScreenTransition = require(ReplicatedStorage.Library.Client.GUIFX.RewardScreenTransition);
local NestResolver = require(script.NestResolver);
local Message = require(ReplicatedStorage.Library.Client.NotificationCmds.Message);
local Player = require(ReplicatedStorage.Library.Player);
local RareEggHighlight = require(script.RareEggHighlight);
local RenderBudget = require(ReplicatedStorage.Library.Modules.RenderBudget);
local SmartProximityPrompt = require(ReplicatedStorage.Library.Client.SmartProximityPrompt);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local WorkspaceEggVisibility = require(script.WorkspaceEggVisibility);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local States = AreaEggs.States;
local LocalPlayer = Players.LocalPlayer;
local u1 = Log.new();
local u2 = AreaEggNearbyPulse.new(LocalPlayer);
local u3 = RenderBudget.new({
    Name = "AreaEggRenderBudget",
    MaxJobsPerStep = 1,
    MaxStepTime = 0.004166666666666667,
    StepInterval = 0.03333333333333333,
    TargetSpreadSeconds = 3,
    SpreadMinJobs = 10
});
local u4 = RenderBudget.new({
    Name = "InitialAreaEggRenderBudget",
    MaxJobsPerStep = 8,
    MaxStepTime = 0.008333333333333333,
    StepInterval = 0.03333333333333333,
    TargetSpreadSeconds = 0.35,
    SpreadMinJobs = 10
});
local __OBJECTS = Workspace.__OBJECTS;
local v5 = __OBJECTS:IsA("Folder");
assert(v5, "Workspace.__OBJECTS must be a Folder");
local Areas = __OBJECTS.Areas;
local v6 = Areas:IsA("Folder");
assert(v6, "Workspace.__OBJECTS.Areas must be a Folder");
local SeparationLine = Areas.SeparationLine;
local v7 = SeparationLine:IsA("BasePart");
assert(v7, "Workspace.__OBJECTS.Areas.SeparationLine must be a BasePart");
local Folder = Instance.new("Folder");
Folder.Name = "AreaEggSlotsClient";
Folder.Parent = Workspace;
local u8 = {};
local u9 = {};
local u10 = nil;

local function isLocalPlayerInGameplay() -- Line: 101
    -- upvalues: Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy)
    local v11 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v12;

    if v11 == nil then
        v12 = false;
    else
        v12 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v11.Position);
    end;

    return v12;
end;

local function isLocalPlayerTrapLocked() -- Line: 106
    -- upvalues: Player (copy), LocalPlayer (copy)
    local v13 = Player.Optional.Character(LocalPlayer);
    local v14;

    if v13 == nil then
        v14 = false;
    else
        v14 = v13:GetAttribute("IsTrapped") == true;
    end;

    return v14;
end;

local function updatePromptEnabled(p15) -- Line: 115
    -- upvalues: Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy)
    local Prompt = p15.Prompt;
    local v16 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v17;

    if v16 == nil then
        v17 = false;
    else
        v17 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v16.Position);
    end;

    if v17 then
        local v18 = Player.Optional.Character(LocalPlayer);
        local v19;

        if v18 == nil then
            v19 = false;
        else
            v19 = v18:GetAttribute("IsTrapped") == true;
        end;

        v17 = not v19;
    end;

    Prompt.Enabled = v17;
end;

local function cleanupRendered(p20) -- Line: 119
    -- upvalues: u9 (copy), u3 (copy), u4 (copy), u8 (copy), wcall (copy)
    u9[p20] = nil;
    u3:Cancel(p20);
    u4:Cancel(p20);
    local v21 = u8[p20];

    if v21 == nil then
        return;
    end;

    u8[p20] = nil;
    v21.Trove:Destroy();

    if v21.OwnsModel and v21.Model.Parent ~= nil then
        wcall(v21.Model.Destroy, v21.Model);
    end;
end;

local function scaleNestForRecord(p22) -- Line: 134
    -- upvalues: NestResolver (copy)
    local v23 = NestResolver.Resolve(p22);
    v23:ScaleTo(p22.NestScale);

    return v23;
end;

local function renderClientEgg(p24) -- Line: 140
    -- upvalues: EggRenderer (copy), Folder (copy)
    local Model = EggRenderer.RenderVisual({
        OwnerUserId = 0,
        ScaleAlpha = 1,
        UID = p24.Uid,
        ModelName = p24.Uid,
        Record = {
            AssetCategory = p24.AssetCategory,
            AssetScale = p24.AssetScale,
            AssetEyeColor = p24.AssetEyeColor,
            AssetColorSeed = p24.AssetColorSeed,
            AssetColorIndex = p24.AssetColorIndex,
            Mutations = table.clone(p24.Mutations),
            BaseMutation = p24.BaseMutation
        }
    }, Folder, false).Model;
    Model:PivotTo(p24.BottomCFrame);

    return Model;
end;

local function bindPrompt(u25, p26, p27) -- Line: 161
    -- upvalues: RareEggHighlight (copy), SmartProximityPrompt (copy), Trove (copy), u8 (copy), States (copy), u2 (copy), Workspace (copy), HoverHighlight (copy), LocalPlayer (copy), AreaEggSlotIdentity (copy), EggCmds (copy), cleanupRendered (copy), WorkspaceEggVisibility (copy), u1 (copy), Player (copy), GuardAreaLookupUtil (copy), SeparationLine (copy)
    RareEggHighlight.BindRenderedModel(u25, p26);
    local ProximityPrompt = Instance.new("ProximityPrompt");
    ProximityPrompt.Name = "CarryAreaEgg";
    ProximityPrompt.ActionText = "Steal";
    ProximityPrompt.ObjectText = "Egg";
    ProximityPrompt.MaxActivationDistance = 8;
    ProximityPrompt.HoldDuration = 1.2;
    ProximityPrompt.RequiresLineOfSight = false;
    ProximityPrompt.Style = Enum.ProximityPromptStyle.Custom;
    local v28 = SmartProximityPrompt.AttachToModel(ProximityPrompt, p26, {
        MaxActivationDistance = 8,
        TrackDistance = 8,
        SurfaceOffset = 0.75
    });
    local v29 = Trove.new();
    v29:Add(v28);
    local v30 = {
        Record = u25,
        Model = p26,
        OwnsModel = p27,
        Prompt = ProximityPrompt,
        Trove = v29
    };
    u8[u25.Uid] = v30;

    if u25.State == States.Slot then
        v29:Add(u2:Bind(u25.Uid, p26, Workspace:GetServerTimeNow()));
    end;

    HoverHighlight.Bind(p26, ProximityPrompt, v29);
    v29:Connect(ProximityPrompt.Triggered, function(p31) -- Line: 190
        -- upvalues: LocalPlayer (ref), AreaEggSlotIdentity (ref), u25 (copy), EggCmds (ref), cleanupRendered (ref), WorkspaceEggVisibility (ref), u1 (ref)
        if p31 ~= LocalPlayer then
            return;
        end;

        local v32;

        if AreaEggSlotIdentity.IsFirstAreaUid(u25.Uid) then
            v32 = AreaEggSlotIdentity.BuildSlotKey(u25.AreaId, u25.NestId);
        else
            v32 = nil;
        end;

        local v33, v34 = EggCmds.RequestCarryAreaEgg(u25.Uid, v32);

        if v33 and v32 ~= nil then
            cleanupRendered(u25.Uid);
            WorkspaceEggVisibility.SetHidden(u25.Uid, false);
        end;

        if not v33 and v34 ~= nil then
            u1:AtDebug():Log((`Area egg carry denied for {u25.Uid}: {v34}`));
        end;
    end);
    local Prompt = v30.Prompt;
    local v35 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v36;

    if v35 == nil then
        v36 = false;
    else
        v36 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v35.Position);
    end;

    if v36 then
        local v37 = Player.Optional.Character(LocalPlayer);
        local v38;

        if v37 == nil then
            v38 = false;
        else
            v38 = v37:GetAttribute("IsTrapped") == true;
        end;

        v36 = not v38;
    end;

    Prompt.Enabled = v36;
end;

local function renderSlot(p39) -- Line: 209
    -- upvalues: cleanupRendered (copy), NestResolver (copy), AreaEggSlotIdentity (copy), WorkspaceEggVisibility (copy), bindPrompt (copy), renderClientEgg (copy)
    cleanupRendered(p39.Uid);
    local v40 = NestResolver.Resolve(p39);
    v40:ScaleTo(p39.NestScale);
    v40:PivotTo(v40:GetPivot());

    if AreaEggSlotIdentity.IsFirstAreaUid(p39.Uid) then
        WorkspaceEggVisibility.SetHidden(p39.Uid, true);
    else
        local v41 = WorkspaceEggVisibility.ResolveModel(p39.Uid);

        if v41 ~= nil then
            WorkspaceEggVisibility.SetHidden(p39.Uid, false);
            bindPrompt(p39, v41, false);

            return;
        end;
    end;

    bindPrompt(p39, renderClientEgg(p39), true);
end;

local function renderDropped(p42) -- Line: 227
    -- upvalues: cleanupRendered (copy), AreaEggSlotIdentity (copy), WorkspaceEggVisibility (copy), bindPrompt (copy), renderClientEgg (copy), u1 (copy)
    cleanupRendered(p42.Uid);

    if AreaEggSlotIdentity.IsFirstAreaUid(p42.Uid) then
        WorkspaceEggVisibility.SetHidden(p42.Uid, true);
        bindPrompt(p42, renderClientEgg(p42), true);

        return;
    end;

    WorkspaceEggVisibility.SetHidden(p42.Uid, false);
    local v43 = WorkspaceEggVisibility.ResolveModel(p42.Uid);

    if v43 == nil then
        u1:AtDebug():Log((`Dropped area egg {p42.Uid} skipped because its Workspace model is not parented`));

        return;
    end;

    bindPrompt(p42, v43, false);
end;

local function applyRecordNow(p44) -- Line: 243
    -- upvalues: WorkspaceEggVisibility (copy), States (copy), renderDropped (copy), cleanupRendered (copy), renderSlot (copy)
    WorkspaceEggVisibility.SetHidden(p44.Uid, false);

    if p44.State == States.Dropped then
        renderDropped(p44);

        return;
    end;

    if p44.State == States.Slot then
        renderSlot(p44);

        return;
    end;

    cleanupRendered(p44.Uid);
end;

local function shouldQueueRender(p45) -- Line: 256
    -- upvalues: u9 (copy), u8 (copy)
    if u9[p45.Uid] == p45.Version then
        return false;
    end;

    local v46 = u8[p45.Uid];

    return (v46 == nil or v46.Record.Version ~= p45.Version) and true or v46.Record.State ~= p45.State;
end;

local function queueApplyRecord(u47, p48) -- Line: 265
    -- upvalues: u9 (copy), u8 (copy), EggCmds (copy), WorkspaceEggVisibility (copy), States (copy), renderDropped (copy), cleanupRendered (copy), renderSlot (copy)
    local v49;

    if u9[u47.Uid] == u47.Version then
        v49 = false;
    else
        local v50 = u8[u47.Uid];
        v49 = (v50 == nil or v50.Record.Version ~= u47.Version) and true or v50.Record.State ~= u47.State;
    end;

    if not v49 then
        return;
    end;

    u9[u47.Uid] = u47.Version;
    p48:Queue(u47.Uid, function() -- Line: 271
        -- upvalues: EggCmds (ref), u47 (copy), u9 (ref), WorkspaceEggVisibility (ref), States (ref), renderDropped (ref), cleanupRendered (ref), renderSlot (ref)
        local v51 = EggCmds.GetAreaEggRecord(u47.Uid);

        if v51 == nil or v51.Version ~= u47.Version then
            return;
        end;

        u9[u47.Uid] = nil;
        WorkspaceEggVisibility.SetHidden(v51.Uid, false);

        if v51.State == States.Dropped then
            renderDropped(v51);

            return;
        end;

        if v51.State == States.Slot then
            renderSlot(v51);

            return;
        end;

        cleanupRendered(v51.Uid);
    end);
end;

local function applySnapshot(p52, p53) -- Line: 281
    -- upvalues: WorkspaceEggVisibility (copy), States (copy), u8 (copy), cleanupRendered (copy), u9 (copy), EggCmds (copy), renderDropped (copy), renderSlot (copy)
    local v54 = {};
    local v55 = {};

    for _, v in ipairs(p52.Records) do
        v54[v.Uid] = true;
        WorkspaceEggVisibility.SetHidden(v.Uid, false);

        if v.State == States.Slot or v.State == States.Dropped then
            table.insert(v55, v);
        end;
    end;

    for i in pairs(u8) do
        if not v54[i] then
            cleanupRendered(i);
        end;
    end;

    for _, v in ipairs(v55) do
        local v56;

        if u9[v.Uid] == v.Version then
            v56 = false;
        else
            local v57 = u8[v.Uid];
            v56 = (v57 == nil or v57.Record.Version ~= v.Version) and true or v57.Record.State ~= v.State;
        end;

        if v56 then
            u9[v.Uid] = v.Version;
            p53:Queue(v.Uid, function() -- Line: 271
                -- upvalues: EggCmds (ref), v (copy), u9 (ref), WorkspaceEggVisibility (ref), States (ref), renderDropped (ref), cleanupRendered (ref), renderSlot (ref)
                local v58 = EggCmds.GetAreaEggRecord(v.Uid);

                if v58 == nil or v58.Version ~= v.Version then
                    return;
                end;

                u9[v.Uid] = nil;
                WorkspaceEggVisibility.SetHidden(v58.Uid, false);

                if v58.State == States.Dropped then
                    renderDropped(v58);

                    return;
                end;

                if v58.State == States.Slot then
                    renderSlot(v58);

                    return;
                end;

                cleanupRendered(v58.Uid);
            end);
        end;
    end;
end;

EggCmds.AreaEggClaimed:Connect(function(p59) -- Line: 334
    -- upvalues: RewardScreenTransition (copy), Message (copy)
    RewardScreenTransition();
    Message.Bottom({
        Time = 2.5,
        Message = `You stole an <font color="#{p59.Color:ToHex()}">EGG</font>!`,
        Color = Color3.new(1, 1, 1)
    });
end);
EggCmds.AreaEggSnapshotUpdated:Connect(function(p60) -- Line: 343
    -- upvalues: applySnapshot (copy), u3 (copy)
    applySnapshot(p60, u3);
end);
EggCmds.AreaEggUpdated:Connect(function(u61) -- Line: 346
    -- upvalues: WorkspaceEggVisibility (copy), States (copy), cleanupRendered (copy), u3 (copy), u4 (copy), u9 (copy), u8 (copy), EggCmds (copy), renderDropped (copy), renderSlot (copy)
    WorkspaceEggVisibility.SetHidden(u61.Uid, false);

    if u61.State ~= States.Slot and u61.State ~= States.Dropped then
        cleanupRendered(u61.Uid);

        return;
    end;

    u3:Cancel(u61.Uid);
    u4:Cancel(u61.Uid);
    u9[u61.Uid] = nil;
    local v62;

    if u9[u61.Uid] == u61.Version then
        v62 = false;
    else
        local v63 = u8[u61.Uid];
        v62 = (v63 == nil or v63.Record.Version ~= u61.Version) and true or v63.Record.State ~= u61.State;
    end;

    if not v62 then
        return;
    end;

    u9[u61.Uid] = u61.Version;
    u3:Queue(u61.Uid, function() -- Line: 271
        -- upvalues: EggCmds (ref), u61 (copy), u9 (ref), WorkspaceEggVisibility (ref), States (ref), renderDropped (ref), cleanupRendered (ref), renderSlot (ref)
        local v64 = EggCmds.GetAreaEggRecord(u61.Uid);

        if v64 == nil or v64.Version ~= u61.Version then
            return;
        end;

        u9[u61.Uid] = nil;
        WorkspaceEggVisibility.SetHidden(v64.Uid, false);

        if v64.State == States.Dropped then
            renderDropped(v64);

            return;
        end;

        if v64.State == States.Slot then
            renderSlot(v64);

            return;
        end;

        cleanupRendered(v64.Uid);
    end);
end);
EggCmds.AreaEggCarryStateChanged:Connect(function(p65) -- Line: 357
    -- upvalues: u10 (ref), AreaEggSlotIdentity (copy), cleanupRendered (copy), WorkspaceEggVisibility (copy)
    u10 = p65;

    if p65.IsCarrying and p65.Uid ~= nil then
        if AreaEggSlotIdentity.IsFirstAreaUid(p65.Uid) then
            cleanupRendered(p65.Uid);
            WorkspaceEggVisibility.SetHidden(p65.Uid, false);

            return;
        end;

        WorkspaceEggVisibility.SetHidden(p65.Uid, false);
    end;
end);
EggCmds.AreaEggRemoved:Connect(function(p66) -- Line: 368
    -- upvalues: cleanupRendered (copy), u10 (ref), WorkspaceEggVisibility (copy)
    cleanupRendered(p66);
    local v67 = u10;
    local v68;

    if v67 == nil then
        v68 = false;
    else
        v68 = v67.IsCarrying and v67.Uid == p66;
    end;

    WorkspaceEggVisibility.SetHidden(p66, not v68);
end);
WorkspaceEggVisibility.ModelAdded:Connect(function(p69) -- Line: 373
    -- upvalues: EggCmds (copy), States (copy), AreaEggSlotIdentity (copy), u3 (copy), u9 (copy), u8 (copy), WorkspaceEggVisibility (copy), renderDropped (copy), cleanupRendered (copy), renderSlot (copy)
    local u70 = EggCmds.GetAreaEggRecord(p69.Name);

    if u70 ~= nil and (u70.State == States.Dropped and not AreaEggSlotIdentity.IsFirstAreaUid(u70.Uid)) then
        local v71;

        if u9[u70.Uid] == u70.Version then
            v71 = false;
        else
            local v72 = u8[u70.Uid];
            v71 = (v72 == nil or v72.Record.Version ~= u70.Version) and true or v72.Record.State ~= u70.State;
        end;

        if not v71 then
            return;
        end;

        u9[u70.Uid] = u70.Version;
        u3:Queue(u70.Uid, function() -- Line: 271
            -- upvalues: EggCmds (ref), u70 (copy), u9 (ref), WorkspaceEggVisibility (ref), States (ref), renderDropped (ref), cleanupRendered (ref), renderSlot (ref)
            local v73 = EggCmds.GetAreaEggRecord(u70.Uid);

            if v73 == nil or v73.Version ~= u70.Version then
                return;
            end;

            u9[u70.Uid] = nil;
            WorkspaceEggVisibility.SetHidden(v73.Uid, false);

            if v73.State == States.Dropped then
                renderDropped(v73);

                return;
            end;

            if v73.State == States.Slot then
                renderSlot(v73);

                return;
            end;

            cleanupRendered(v73.Uid);
        end);
    end;
end);
CarryRunBackEffects.Start();
WorkspaceEggVisibility.Start();
RareEggHighlight.Start();
RunService.Heartbeat:Connect(function() -- Line: 383
    -- upvalues: u2 (copy), Workspace (copy), u8 (copy), Player (copy), LocalPlayer (copy), GuardAreaLookupUtil (copy), SeparationLine (copy)
    u2:Step(Workspace:GetServerTimeNow());

    for _, v in pairs(u8) do
        local Prompt = v.Prompt;
        local v74 = Player.Optional.HumanoidRootPart(LocalPlayer);
        local v75;

        if v74 == nil then
            v75 = false;
        else
            v75 = GuardAreaLookupUtil.IsInGameplaySide(SeparationLine, v74.Position);
        end;

        if v75 then
            local v76 = Player.Optional.Character(LocalPlayer);
            local v77;

            if v76 == nil then
                v77 = false;
            else
                v77 = v76:GetAttribute("IsTrapped") == true;
            end;

            v75 = not v77;
        end;

        Prompt.Enabled = v75;
    end;
end);
(function(p78) -- Line: 301, Name: applyInitialSnapshot
    -- upvalues: WorkspaceEggVisibility (copy), States (copy), AreaEggSlotIdentity (copy), u8 (copy), cleanupRendered (copy), u9 (copy), renderDropped (copy), renderSlot (copy), u4 (copy), EggCmds (copy)
    local v79 = {};
    local v80 = {};
    local v81 = {};

    for _, v in ipairs(p78.Records) do
        v79[v.Uid] = true;
        WorkspaceEggVisibility.SetHidden(v.Uid, false);

        if v.State == States.Slot or v.State == States.Dropped then
            if AreaEggSlotIdentity.IsFirstAreaUid(v.Uid) then
                table.insert(v80, v);
            else
                table.insert(v81, v);
            end;
        end;
    end;

    for i in pairs(u8) do
        if not v79[i] then
            cleanupRendered(i);
        end;
    end;

    for _, v in ipairs(v80) do
        u9[v.Uid] = nil;
        WorkspaceEggVisibility.SetHidden(v.Uid, false);

        if v.State == States.Dropped then
            renderDropped(v);
        elseif v.State == States.Slot then
            renderSlot(v);
        else
            cleanupRendered(v.Uid);
        end;
    end;

    for _, v in ipairs(v81) do
        local v82 = u4;
        local v83;

        if u9[v.Uid] == v.Version then
            v83 = false;
        else
            local v84 = u8[v.Uid];
            v83 = (v84 == nil or v84.Record.Version ~= v.Version) and true or v84.Record.State ~= v.State;
        end;

        if v83 then
            u9[v.Uid] = v.Version;
            v82:Queue(v.Uid, function() -- Line: 271
                -- upvalues: EggCmds (ref), v (copy), u9 (ref), WorkspaceEggVisibility (ref), States (ref), renderDropped (ref), cleanupRendered (ref), renderSlot (ref)
                local v85 = EggCmds.GetAreaEggRecord(v.Uid);

                if v85 == nil or v85.Version ~= v.Version then
                    return;
                end;

                u9[v.Uid] = nil;
                WorkspaceEggVisibility.SetHidden(v85.Uid, false);

                if v85.State == States.Dropped then
                    renderDropped(v85);

                    return;
                end;

                if v85.State == States.Slot then
                    renderSlot(v85);

                    return;
                end;

                cleanupRendered(v85.Uid);
            end);
        end;
    end;
end)((EggCmds.RequestAreaEggSnapshot()));