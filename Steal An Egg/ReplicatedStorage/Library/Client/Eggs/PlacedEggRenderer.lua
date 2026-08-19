-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Library.Types.AreaEggResetCycle);
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil);
local EggActionMovement = require(script.Parent.EggActionMovement);
local EggCmds = require(ReplicatedStorage.Library.Client.EggCmds);
local EggHatchAnimation = require(script.Parent.EggHatchAnimation);
local EggGrowthAnimation = require(script.Parent.EggGrowthAnimation);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local EggRenderer = require(script.Parent.EggRenderer);
local EggSkipAnimation = require(script.Parent.EggSkipAnimation);
require(ReplicatedStorage.Library.Types.Eggs);
local Lock = require(ReplicatedStorage.Library.Functions.Lock);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local NightEggTimeSkipAnimation = require(script.Parent.NightEggTimeSkipAnimation);
local PlacedEggBillboard = require(script.Parent.PlacedEggBillboard);
local PlacedEggGrowthPresentationPolicy = require(script.Parent.PlacedEggGrowthPresentationPolicy);
local PlacedEggReadyPulse = require(script.Parent.PlacedEggReadyPulse);
local PlotCmds = require(ReplicatedStorage.Library.Client.PlotCmds);
local Products = require(ReplicatedStorage.Directory.Products);
local PromptPurchase = require(ReplicatedStorage.Library.Shared.Functions.PromptPurchase);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local SmartProximityPrompt = require(ReplicatedStorage.Library.Client.SmartProximityPrompt);
local ModelCameraOcclusionController = require(ReplicatedStorage.Library.Client.ModelCameraOcclusionController);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Parent.Types);
local EggPlaceAnimation = require(script.Parent.EggPlaceAnimation);
require(ReplicatedStorage.Library.Types.Plots);
local u1 = TweenInfo.new(2.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
local u2 = TweenInfo.new(1.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
local u3 = {};
local u4 = 0;
local u5 = Random.new();
local u6 = Random.new();
local u7 = nil;
local u8 = false;
local Folder = Instance.new("Folder");
Folder.Name = "PlacedEggRenders";
Folder.Parent = workspace;
local u9 = Log.new();
local u10 = {
    LocalEggHatchStarted = Signal.new()
};
local GetDirectGrowthTweenRemainingSeconds = PlacedEggGrowthPresentationPolicy.GetDirectGrowthTweenRemainingSeconds;
local GetStartScale = PlacedEggGrowthPresentationPolicy.GetStartScale;
local GetTargetScale = PlacedEggGrowthPresentationPolicy.GetTargetScale;
local GetVisualScale = PlacedEggGrowthPresentationPolicy.GetVisualScale;
local IsReady = PlacedEggGrowthPresentationPolicy.IsReady;
local GetRemainingGrowthSeconds = PlacedEggGrowthPresentationPolicy.GetRemainingGrowthSeconds;

local function getKey(p11, p12) -- Line: 112
    return `{p11}:{p12}`;
end;

local function getOwnerPlayer(p13) -- Line: 116
    -- upvalues: Players (copy)
    return Players:GetPlayerByUserId(p13);
end;

local function readOwnerPlotData(p14) -- Line: 120
    -- upvalues: Players (copy), PlotCmds (copy)
    local v15 = Players:GetPlayerByUserId(p14);

    if v15 == nil then
        return nil;
    end;

    return PlotCmds.GetPlotData(v15);
end;

local function isLocalOwner(p16) -- Line: 129
    -- upvalues: Players (copy)
    return p16 == Players.LocalPlayer.UserId;
end;

local function getNextReadyPulseAt(p17) -- Line: 133
    -- upvalues: u5 (copy)
    return p17 + u5:NextNumber(5, 10);
end;

local function getNextGrowthPulseAt(p18) -- Line: 137
    -- upvalues: u6 (copy)
    return p18 + u6:NextNumber(27, 65);
end;

local function getInitialGrowthUpdateAt(p19) -- Line: 141
    -- upvalues: u4 (ref)
    local v20 = p19 + u4 * 0.2;
    u4 = (u4 + 1) % 25;

    return v20;
end;

local function getNightTimeSkipSecondsValue(p21) -- Line: 147
    local NightTimeSkipAnimation = p21.NightTimeSkipAnimation;

    if NightTimeSkipAnimation == nil then
        return nil;
    end;

    return NightTimeSkipAnimation:GetAppliedSecondsValue();
end;

local function getNightTimeSkipSeconds(p22) -- Line: 152
    local NightTimeSkipAnimation = p22.NightTimeSkipAnimation;
    local v23;

    if NightTimeSkipAnimation == nil then
        v23 = nil;
    else
        v23 = NightTimeSkipAnimation:GetAppliedSecondsValue();
    end;

    return v23 == nil and 0 or v23.Value;
end;

local function isNightTimeSkipControllingPresentation(p24) -- Line: 157
    local NightTimeSkipAnimation = p24.NightTimeSkipAnimation;
    local v25;

    if NightTimeSkipAnimation == nil then
        v25 = false;
    else
        v25 = not NightTimeSkipAnimation:IsComplete();
    end;

    return v25;
end;

local function clearNightTimeSkipAnimation(p26) -- Line: 162
    -- upvalues: PlacedEggBillboard (copy)
    local NightTimeSkipAnimation = p26.NightTimeSkipAnimation;

    if NightTimeSkipAnimation == nil then
        return;
    end;

    p26.NightTimeSkipAnimation = nil;

    if p26.NightBillboardSuppressed then
        p26.NightBillboardSuppressed = false;
        PlacedEggBillboard.SetNightPresentationActive(p26.OwnerUserId, p26.Uid, false);
    end;

    NightTimeSkipAnimation:Destroy();
    local ScaleValue = p26.ScaleValue;

    if ScaleValue ~= nil and p26.Result.Model.Parent ~= nil then
        ScaleValue.Value = p26.Result.Model:GetScale();
    end;
end;

local function startNightTimeSkipForState(p27, p28) -- Line: 180
    -- upvalues: Players (copy), AreaEggResetTimeUtil (copy), EggItemUtil (copy), Workspace (copy), NightEggTimeSkipAnimation (copy), PlacedEggBillboard (copy)
    if p27.OwnerUserId ~= Players.LocalPlayer.UserId or (p27.IsHatching or (p27.Result.Model.Parent == nil or p27.NightTimeSkipAnimation ~= nil)) then
        return;
    end;

    local Placement = p27.Record.Placement;
    local v29 = p28 - AreaEggResetTimeUtil.GetNightDurationSeconds();

    if Placement == nil or (Placement.ReadyAt ~= nil or v29 < Placement.PlacedAt) then
        return;
    end;

    if EggItemUtil.IsGrowthReady(p27.Record, v29, p27.Record.GrowthSpeedMultiplier, nil, Players:GetPlayerByUserId(p27.OwnerUserId)) then
        return;
    end;

    if p28 <= Workspace:GetServerTimeNow() then
        return;
    end;

    local GrowthAnimation = p27.GrowthAnimation;

    if GrowthAnimation ~= nil then
        GrowthAnimation:Cancel();
    end;

    local ReadyPulse = p27.ReadyPulse;

    if ReadyPulse ~= nil then
        ReadyPulse:Cancel();
    end;

    local ScaleTween = p27.ScaleTween;

    if ScaleTween ~= nil then
        ScaleTween:Cancel();
        p27.ScaleTween = nil;
        p27.DirectGrowthTweenActive = false;
    end;

    local v30 = NightEggTimeSkipAnimation.new(p27.Result.Model, p27.Uid, p27.Record, p27.BasePivot, p27.StartScale, p27.TargetScale, v29, p28);
    p27.NightTimeSkipAnimation = v30;
    PlacedEggBillboard.SetEntry({
        OwnerUserId = p27.OwnerUserId,
        Uid = p27.Uid,
        Record = p27.Record,
        Model = p27.Result.Model,
        TimeSkipSeconds = v30:GetAppliedSecondsValue()
    });
    p27.NightBillboardSuppressed = true;
    PlacedEggBillboard.SetNightPresentationActive(p27.OwnerUserId, p27.Uid, true);
end;

local function startNightTimeSkip(p31) -- Line: 239
    -- upvalues: u7 (ref), u3 (copy), startNightTimeSkipForState (copy)
    u7 = p31.DayStartsAt;

    for _, v in pairs(u3) do
        startNightTimeSkipForState(v, p31.DayStartsAt);
    end;
end;

local function setStateScale(u32, p33, p34, p35, u36) -- Line: 246
    -- upvalues: Players (copy), EggRenderer (copy), TweenService (copy), u1 (copy)
    if u32.OwnerUserId ~= Players.LocalPlayer.UserId then
        u32.Result.Model:ScaleTo(p33);
        EggRenderer.ApplyPlacedCollisionPolicy(u32.Result.Model);

        return false;
    end;

    local ScaleValue = u32.ScaleValue;

    if ScaleValue == nil then
        u32.Result.Model:ScaleTo(p33);
        EggRenderer.ApplyPlacedCollisionPolicy(u32.Result.Model);

        return false;
    end;

    local ScaleTween = u32.ScaleTween;
    local v37 = ScaleTween ~= nil;

    if ScaleTween ~= nil then
        ScaleTween:Cancel();
        u32.ScaleTween = nil;
        u32.DirectGrowthTweenActive = false;
    end;

    if p35 == false then
        if u36 == true then
            u32.DirectGrowthTweenActive = true;
        end;

        local v38 = math.abs(ScaleValue.Value - p33) > 0.001;

        if v38 then
            ScaleValue.Value = p33;
        end;

        return v37 or v38;
    end;

    if math.abs(ScaleValue.Value - p33) <= 0.001 then
        if u36 == true then
            u32.DirectGrowthTweenActive = true;
        end;

        return false;
    end;

    local u39 = TweenService:Create(ScaleValue, p34 or u1, {
        Value = p33
    });
    u32.ScaleTween = u39;
    u32.DirectGrowthTweenActive = u36 == true;
    u39.Completed:Once(function() -- Line: 297
        -- upvalues: u32 (copy), u39 (copy), u36 (copy)
        if u32.ScaleTween == u39 then
            u32.ScaleTween = nil;

            if u36 == true then
                u32.DirectGrowthTweenActive = false;
            end;
        end;
    end);
    u39:Play();

    return false;
end;

local function startDirectGrowthTween(p40, p41) -- Line: 309
    -- upvalues: setStateScale (copy)
    local v42 = TweenInfo.new(math.max(p41, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    setStateScale(p40, p40.TargetScale, v42, true, true);
end;

local function updatePrompt(p43) -- Line: 318
    -- upvalues: IsReady (copy), Products (copy), GetRemainingGrowthSeconds (copy), u8 (ref)
    local Prompt = p43.Prompt;

    if Prompt == nil then
        return;
    end;

    local NightTimeSkipAnimation = p43.NightTimeSkipAnimation;
    local v44;

    if NightTimeSkipAnimation == nil then
        v44 = nil;
    else
        v44 = NightTimeSkipAnimation:GetAppliedSecondsValue();
    end;

    local v45 = v44 == nil and 0 or v44.Value;
    local v46 = IsReady(p43.Record, v45);
    local v47 = v46 and "Hatch!" or "Skip Growth!";
    local v48 = v46 or Products.GetEggSkipGrowthProduct(GetRemainingGrowthSeconds(p43.Record, v45)) ~= nil;
    local v49 = not u8;

    if v49 then
        local v50 = not p43.IsHatching;

        if not v50 then
            v48 = v50;
        end;
    else
        v48 = v49;
    end;

    Prompt.Enabled = v48;
    Prompt.ActionText = v47;
    Prompt.ObjectText = v47;
end;

local function trackOcclusion(p51) -- Line: 335
    -- upvalues: ModelCameraOcclusionController (copy)
    local v52 = not p51.OcclusionTracked;
    local v53 = `Placed egg {p51.Uid} occlusion is already tracked`;
    assert(v52, v53);
    ModelCameraOcclusionController.TrackModel(p51.Result.Model, 1);
    p51.OcclusionTracked = true;
end;

local function untrackOcclusion(p54) -- Line: 341
    -- upvalues: ModelCameraOcclusionController (copy)
    if not p54.OcclusionTracked then
        return;
    end;

    ModelCameraOcclusionController.UntrackModel(p54.Result.Model);
    p54.OcclusionTracked = false;
end;

local u55 = nil;
local u56 = nil;

local function activatePrompt(u57) -- Line: 353
    -- upvalues: IsReady (copy), ModelCameraOcclusionController (copy), updatePrompt (copy), EggCmds (copy), u9 (copy), Players (copy), u10 (copy), EggHatchAnimation (copy), u55 (ref), u56 (ref), PromptPurchase (copy)
    local ReadyPulse = u57.ReadyPulse;

    if ReadyPulse == nil then
        return false, "Egg is not owned by the local player";
    end;

    local Record = u57.Record;
    local NightTimeSkipAnimation = u57.NightTimeSkipAnimation;
    local v58;

    if NightTimeSkipAnimation == nil then
        v58 = nil;
    else
        v58 = NightTimeSkipAnimation:GetAppliedSecondsValue();
    end;

    if IsReady(Record, v58 == nil and 0 or v58.Value) then
        if u57.HatchLock(function() -- Line: 361
            -- upvalues: u57 (copy), ModelCameraOcclusionController (ref), ReadyPulse (copy), updatePrompt (ref), EggCmds (ref), u9 (ref), Players (ref), u10 (ref), EggHatchAnimation (ref), u55 (ref), u56 (ref)
            u57.IsHatching = true;
            local v59 = u57;

            if v59.OcclusionTracked then
                ModelCameraOcclusionController.UntrackModel(v59.Result.Model);
                v59.OcclusionTracked = false;
            end;

            u57.NextReadyPulseAt = nil;
            ReadyPulse:Cancel();
            updatePrompt(u57);
            local v60, v61 = EggCmds.RequestHatchEgg(u57.Uid);

            if v60 then
                if u57.OwnerUserId == Players.LocalPlayer.UserId then
                    u10.LocalEggHatchStarted:Fire(u57.Uid);
                end;

                local v62 = EggHatchAnimation.Play(u57.OwnerUserId, u57.Uid, u57.Record, u57.Result.Model);
                local v63, v64, v65 = EggCmds.RequestCompleteHatchEgg(u57.Uid);

                if v63 then
                    if v62 ~= nil then
                        local v66 = assert(v65, "Successful hatch completion must return the granted asset UID");
                        EggHatchAnimation.FadeSoundWhenGrantedToolUnequips(v62, v66);
                    end;

                    return;
                end;

                u9:AtWarning():Log((`Failed to complete hatch for egg {u57.Uid}: {v64 or "unknown"}`));
                u55((`{u57.OwnerUserId}:{u57.Uid}`));
                u56(u57.OwnerUserId);

                return;
            end;

            u57.IsHatching = false;
            local v67 = u57;
            local v68 = not v67.OcclusionTracked;
            local v69 = `Placed egg {v67.Uid} occlusion is already tracked`;
            assert(v68, v69);
            ModelCameraOcclusionController.TrackModel(v67.Result.Model, 1);
            v67.OcclusionTracked = true;
            updatePrompt(u57);
            u9:AtWarning():Log((`Failed to hatch egg {u57.Uid}: {v61 or "unknown"}`));
        end) then
            return true;
        end;

        u9:AtDebug():Log((`Ignored duplicate hatch prompt for egg {u57.Uid}`));

        return false, "Egg is already hatching";
    end;

    local v70, v71, v72 = EggCmds.RequestSkipGrowth(u57.Uid);

    if v70 and v72 then
        PromptPurchase.Prompt(v72, true);

        return true;
    end;

    u9:AtWarning():Log((`Failed to request skip growth for egg {u57.Uid}: {v71 or "unknown"}`));

    return false, v71;
end;

u55 = function(p73) -- Line: 409
    -- upvalues: u3 (copy), ModelCameraOcclusionController (copy), clearNightTimeSkipAnimation (copy), PlacedEggBillboard (copy)
    local v74 = u3[p73];

    if v74 == nil then
        return;
    end;

    if v74.OcclusionTracked then
        ModelCameraOcclusionController.UntrackModel(v74.Result.Model);
        v74.OcclusionTracked = false;
    end;

    u3[p73] = nil;
    clearNightTimeSkipAnimation(v74);
    PlacedEggBillboard.RemoveEntry(v74.OwnerUserId, v74.Uid);
    v74.Trove:Destroy();
end;

local function destroyOwnerStates(p75) -- Line: 422
    -- upvalues: u3 (copy), u55 (ref)
    for i, v in pairs(u3) do
        if v.OwnerUserId == p75 then
            u55(i);
        end;
    end;
end;

local function addPlacedEggRenderState(p76, p77, p78) -- Line: 430
    -- upvalues: Players (copy), PlotCmds (copy), Trove (copy), GetStartScale (copy), GetTargetScale (copy), GetVisualScale (copy), EggRenderer (copy), Folder (copy), EggActionMovement (copy), EggCmds (copy), EggPlaceAnimation (copy), SmartProximityPrompt (copy), EggGrowthAnimation (copy), PlacedEggReadyPulse (copy), Workspace (copy), u4 (ref), Lock (copy), u7 (ref), startNightTimeSkipForState (copy), u3 (copy), ModelCameraOcclusionController (copy), PlacedEggBillboard (copy), updatePrompt (copy), activatePrompt (copy), GetDirectGrowthTweenRemainingSeconds (copy), setStateScale (copy), u9 (copy)
    local Placement = p78.Placement;

    if Placement == nil then
        return;
    end;

    local v79 = Players:GetPlayerByUserId(p76);
    local v80;

    if v79 == nil then
        v80 = nil;
    else
        v80 = PlotCmds.GetPlotData(v79);
    end;

    if v80 == nil then
        return;
    end;

    local v81 = Trove.new();
    local v82 = GetStartScale(p78);
    local v83 = GetTargetScale(p78);
    local v84 = GetVisualScale(p78, v82, v83);
    local v85 = v80.CenterPoint.CFrame * Placement.LocalCFrame;
    local u86 = EggRenderer.RenderVisual({
        OwnerUserId = p76,
        UID = p77,
        ModelName = `{p76}_{p77}`,
        Record = p78,
        ScaleMultiplier = v84
    }, Folder, true);
    v81:Add(u86.Model);
    EggActionMovement.SetPivot(u86.Model, v85);

    if p76 == Players.LocalPlayer.UserId and EggCmds.ConsumeLocalPlaceAnimation(p77) then
        EggPlaceAnimation.Play(u86.Model, v85, Folder);
    end;

    local v87;

    if p76 == Players.LocalPlayer.UserId then
        v87 = Instance.new("NumberValue");
        v87.Value = v84;
        v81:Add(v87);
        v81:Add(v87.Changed:Connect(function(p88) -- Line: 465
            -- upvalues: u86 (copy), EggRenderer (ref)
            u86.Model:ScaleTo(p88);
            EggRenderer.ApplyPlacedCollisionPolicy(u86.Model);
        end));
    else
        v87 = nil;
    end;

    local v89 = p76 == Players.LocalPlayer.UserId;
    local v90, u91, u92;

    if v89 then
        v90 = Instance.new("ProximityPrompt");
        v90.RequiresLineOfSight = false;
        v90.Style = Enum.ProximityPromptStyle.Custom;
        v90.MaxActivationDistance = 7;
        v90.HoldDuration = 0;
        v81:Add(SmartProximityPrompt.AttachToModel(v90, u86.Model, {
            SurfaceOffset = 0.75,
            TrackDistance = 7,
            MaxActivationDistance = v90.MaxActivationDistance
        }));
        u91 = EggGrowthAnimation.new(u86.Model, v85, 1);
        u92 = PlacedEggReadyPulse.new(u86.Model, v85, v83);
    else
        v90 = nil;
        u91 = nil;
        u92 = nil;
    end;

    local u93 = {
        ScaleTween = nil,
        DirectGrowthTweenActive = false,
        NextGrowthPulseAt = nil,
        NightTimeSkipAnimation = nil,
        NightBillboardSuppressed = false,
        NextReadyPulseAt = nil,
        IsHatching = false,
        OcclusionTracked = false,
        OwnerUserId = p76,
        Uid = p77,
        Record = p78,
        Result = u86,
        BasePivot = v85,
        StartScale = v82,
        TargetScale = v83,
        ScaleValue = v87,
        GrowthAnimation = u91
    };
    local v94 = Workspace:GetServerTimeNow() + u4 * 0.2;
    u4 = (u4 + 1) % 25;
    u93.NextGrowthUpdateAt = v94;
    u93.ReadyPulse = u92;
    u93.Prompt = v90;
    u93.Trove = v81;
    u93.HatchLock = Lock();
    local v95 = u7;

    if v95 ~= nil then
        startNightTimeSkipForState(u93, v95);
    end;

    if u92 ~= nil then
        v81:Add(function() -- Line: 520
            -- upvalues: u92 (ref)
            u92:Destroy();
        end);
    end;

    if u91 ~= nil then
        v81:Add(function() -- Line: 525
            -- upvalues: u91 (ref)
            u91:Destroy();
        end);
    end;

    v81:Add(function() -- Line: 529
        -- upvalues: u93 (copy)
        local ScaleTween = u93.ScaleTween;

        if ScaleTween ~= nil then
            ScaleTween:Cancel();
            u93.ScaleTween = nil;
            u93.DirectGrowthTweenActive = false;
        end;
    end);
    u3[`{p76}:{p77}`] = u93;
    local v96 = not u93.OcclusionTracked;
    local v97 = `Placed egg {u93.Uid} occlusion is already tracked`;
    assert(v96, v97);
    ModelCameraOcclusionController.TrackModel(u93.Result.Model, 1);
    u93.OcclusionTracked = true;
    local SetEntry = PlacedEggBillboard.SetEntry;
    local v98 = {
        OwnerUserId = p76,
        Uid = p77,
        Record = p78,
        Model = u86.Model
    };
    local NightTimeSkipAnimation = u93.NightTimeSkipAnimation;
    local v99;

    if NightTimeSkipAnimation == nil then
        v99 = nil;
    else
        v99 = NightTimeSkipAnimation:GetAppliedSecondsValue();
    end;

    v98.TimeSkipSeconds = v99;
    SetEntry(v98);
    updatePrompt(u93);

    if v90 ~= nil then
        v81:Add(v90.Triggered:Connect(function(p100) -- Line: 548
            -- upvalues: Players (ref), activatePrompt (ref), u93 (copy)
            if p100 ~= Players.LocalPlayer then
                return;
            end;

            activatePrompt(u93);
        end));
    end;

    local v101 = GetDirectGrowthTweenRemainingSeconds(p78, (Workspace:GetServerTimeNow()));

    if v89 and v101 > 0 then
        local NightTimeSkipAnimation2 = u93.NightTimeSkipAnimation;
        local v102;

        if NightTimeSkipAnimation2 == nil then
            v102 = false;
        else
            v102 = not NightTimeSkipAnimation2:IsComplete();
        end;

        if not v102 then
            local v103 = TweenInfo.new(math.max(v101, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
            setStateScale(u93, u93.TargetScale, v103, true, true);
        end;
    end;

    u9:AtDebug():Log((`Rendered placed egg {p77} for owner {p76}`));
end;

u56 = function(p104) -- Line: 564
    -- upvalues: EggCmds (copy), Players (copy), PlotCmds (copy), u3 (copy), IsReady (copy), GetStartScale (copy), GetTargetScale (copy), EggActionMovement (copy), clearNightTimeSkipAnimation (copy), PlacedEggBillboard (copy), setStateScale (copy), u2 (copy), EggSkipAnimation (copy), PlacedEggGrowthPresentationPolicy (copy), updatePrompt (copy), addPlacedEggRenderState (copy), u55 (ref)
    local v105 = EggCmds.GetOwnerRuntimeRecords(p104);
    local v106 = Players:GetPlayerByUserId(p104);
    local v107;

    if v106 == nil then
        v107 = nil;
    else
        v107 = PlotCmds.GetPlotData(v106);
    end;

    if v107 == nil then
        return;
    end;

    local v108 = {};

    for i, v in pairs(v105) do
        if v.Placement ~= nil then
            local v109 = `{p104}:{i}`;
            v108[v109] = true;
            local v110 = u3[v109];

            if v110 == nil then
                addPlacedEggRenderState(p104, i, v);
            elseif not v110.IsHatching then
                local NightTimeSkipAnimation = v110.NightTimeSkipAnimation;
                local v111;

                if NightTimeSkipAnimation == nil then
                    v111 = nil;
                else
                    v111 = NightTimeSkipAnimation:GetAppliedSecondsValue();
                end;

                local v112 = v111 == nil and 0 or v111.Value;
                local v113 = IsReady(v110.Record, v112);
                local v114 = IsReady(v, v112);
                v110.Record = v;
                v110.StartScale = GetStartScale(v);
                v110.TargetScale = GetTargetScale(v);

                if v.Placement ~= nil then
                    v110.BasePivot = v107.CenterPoint.CFrame * v.Placement.LocalCFrame;
                    local ReadyPulse = v110.ReadyPulse;

                    if ReadyPulse ~= nil then
                        ReadyPulse:SetTransform(v110.BasePivot, v110.TargetScale);
                    end;

                    local GrowthAnimation = v110.GrowthAnimation;

                    if GrowthAnimation ~= nil then
                        GrowthAnimation:SetBasePivot(v110.BasePivot);
                    end;

                    local NightTimeSkipAnimation2 = v110.NightTimeSkipAnimation;

                    if NightTimeSkipAnimation2 ~= nil then
                        NightTimeSkipAnimation2:SetTransform(v110.BasePivot, v110.StartScale, v110.TargetScale);
                        NightTimeSkipAnimation2:AcknowledgeRecord(v);

                        if v114 then
                            NightTimeSkipAnimation2:CancelVisual();
                        end;
                    end;

                    local NightTimeSkipAnimation3 = v110.NightTimeSkipAnimation;
                    local v115;

                    if NightTimeSkipAnimation3 == nil then
                        v115 = false;
                    else
                        v115 = not NightTimeSkipAnimation3:IsComplete();
                    end;

                    if not v115 and (ReadyPulse == nil or not ReadyPulse:IsPlaying()) and (GrowthAnimation == nil or not GrowthAnimation:IsPlaying()) then
                        EggActionMovement.SetPivot(v110.Result.Model, v110.BasePivot);
                    end;
                end;

                local NightTimeSkipAnimation2 = v110.NightTimeSkipAnimation;

                if NightTimeSkipAnimation2 ~= nil and NightTimeSkipAnimation2:IsComplete() then
                    clearNightTimeSkipAnimation(v110);
                end;

                local SetEntry = PlacedEggBillboard.SetEntry;
                local v116 = {
                    OwnerUserId = p104,
                    Uid = i,
                    Record = v,
                    Model = v110.Result.Model
                };
                local NightTimeSkipAnimation3 = v110.NightTimeSkipAnimation;
                local v117;

                if NightTimeSkipAnimation3 == nil then
                    v117 = nil;
                else
                    v117 = NightTimeSkipAnimation3:GetAppliedSecondsValue();
                end;

                v116.TimeSkipSeconds = v117;
                SetEntry(v116);

                if p104 == Players.LocalPlayer.UserId and (not v113 and (v114 and v110.NightTimeSkipAnimation == nil)) then
                    if EggCmds.GetSelectedSkipGrowthUid() == i then
                        setStateScale(v110, v110.TargetScale, u2);
                        task.spawn(EggSkipAnimation.Play, v110.Result.Model);
                    else
                        local v118 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v110.Result.Model);

                        if setStateScale(v110, v110.TargetScale, nil, v118 == nil) then
                            local v119 = assert(v118, "Skipped natural completion requires a presentation reason");
                            PlacedEggGrowthPresentationPolicy.LogSkipped(v110.Uid, "natural completion", v119);
                        end;
                    end;
                end;

                updatePrompt(v110);
            end;
        end;
    end;

    for i, v in pairs(u3) do
        if v.OwnerUserId == p104 and not v108[i] then
            u55(i);
        end;
    end;
end;

local function refreshAll() -- Line: 665
    -- upvalues: EggCmds (copy), u56 (ref), u3 (copy), u55 (ref)
    local v120 = EggCmds.GetRuntimeSnapshot();
    local v121 = {};

    for _, v in ipairs(v120) do
        v121[v.OwnerUserId] = true;
        u56(v.OwnerUserId);
    end;

    for i, v in pairs(u3) do
        if not v121[v.OwnerUserId] then
            u55(i);
        end;
    end;
end;

local function updateReadyPulses(p122) -- Line: 680
    -- upvalues: u3 (copy), IsReady (copy), PlacedEggGrowthPresentationPolicy (copy), u5 (copy)
    for _, v in pairs(u3) do
        local ReadyPulse = v.ReadyPulse;

        if ReadyPulse ~= nil then
            if v.IsHatching or v.Result.Model.Parent == nil then
                v.NextReadyPulseAt = nil;
                ReadyPulse:Cancel();
            else
                local Record = v.Record;
                local NightTimeSkipAnimation = v.NightTimeSkipAnimation;
                local v123;

                if NightTimeSkipAnimation == nil then
                    v123 = nil;
                else
                    v123 = NightTimeSkipAnimation:GetAppliedSecondsValue();
                end;

                if IsReady(Record, v123 == nil and 0 or v123.Value) then
                    local NightTimeSkipAnimation2 = v.NightTimeSkipAnimation;
                    local v124;

                    if NightTimeSkipAnimation2 == nil then
                        v124 = false;
                    else
                        v124 = not NightTimeSkipAnimation2:IsComplete();
                    end;

                    if v124 then
                        v.NextReadyPulseAt = nil;
                        ReadyPulse:Cancel();
                    else
                        local NextReadyPulseAt = v.NextReadyPulseAt;

                        if ReadyPulse:IsPlaying() then
                            local v125 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v.Result.Model);

                            if v125 == nil then
                                if NextReadyPulseAt == nil then
                                    v.NextReadyPulseAt = p122 + u5:NextNumber(5, 10);
                                end;
                            else
                                ReadyPulse:Cancel();
                                v.NextReadyPulseAt = p122 + u5:NextNumber(5, 10);
                                PlacedEggGrowthPresentationPolicy.LogSkipped(v.Uid, "ready pulse cancellation", v125);
                            end;
                        elseif NextReadyPulseAt == nil then
                            v.NextReadyPulseAt = p122 + u5:NextNumber(5, 10);
                        elseif NextReadyPulseAt <= p122 then
                            local v126 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v.Result.Model);

                            if v126 == nil then
                                if ReadyPulse:Play() then
                                    v.NextReadyPulseAt = nil;
                                end;
                            else
                                v.NextReadyPulseAt = p122 + u5:NextNumber(5, 10);
                                PlacedEggGrowthPresentationPolicy.LogSkipped(v.Uid, "ready pulse", v126);
                            end;
                        end;
                    end;
                else
                    v.NextReadyPulseAt = nil;
                    ReadyPulse:Cancel();
                end;
            end;
        end;
    end;
end;

local function updateGrowthPulses(p127) -- Line: 723
    -- upvalues: u3 (copy), GetDirectGrowthTweenRemainingSeconds (copy), IsReady (copy), PlacedEggGrowthPresentationPolicy (copy), u6 (copy)
    for _, v in pairs(u3) do
        local GrowthAnimation = v.GrowthAnimation;

        if GrowthAnimation ~= nil then
            local v128 = GetDirectGrowthTweenRemainingSeconds(v.Record, p127);

            if v.IsHatching or v.Result.Model.Parent == nil then
                v.NextGrowthPulseAt = nil;
                GrowthAnimation:Cancel();
            else
                local Record = v.Record;
                local NightTimeSkipAnimation = v.NightTimeSkipAnimation;
                local v129;

                if NightTimeSkipAnimation == nil then
                    v129 = nil;
                else
                    v129 = NightTimeSkipAnimation:GetAppliedSecondsValue();
                end;

                if IsReady(Record, v129 == nil and 0 or v129.Value) or v128 > 0 then
                    v.NextGrowthPulseAt = nil;
                    GrowthAnimation:Cancel();
                else
                    local NightTimeSkipAnimation2 = v.NightTimeSkipAnimation;
                    local v130;

                    if NightTimeSkipAnimation2 == nil then
                        v130 = false;
                    else
                        v130 = not NightTimeSkipAnimation2:IsComplete();
                    end;

                    if v130 then
                        v.NextGrowthPulseAt = nil;
                        GrowthAnimation:Cancel();
                    else
                        local NextGrowthPulseAt = v.NextGrowthPulseAt;

                        if GrowthAnimation:IsPlaying() then
                            local v131 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v.Result.Model);

                            if v131 ~= nil then
                                GrowthAnimation:Cancel();
                                v.NextGrowthPulseAt = p127 + u6:NextNumber(27, 65);
                                PlacedEggGrowthPresentationPolicy.LogSkipped(v.Uid, "random growth jump cancellation", v131);
                            end;
                        elseif NextGrowthPulseAt == nil then
                            v.NextGrowthPulseAt = p127 + u6:NextNumber(27, 65);
                        elseif NextGrowthPulseAt <= p127 then
                            v.NextGrowthPulseAt = p127 + u6:NextNumber(27, 65);
                            local v132 = PlacedEggGrowthPresentationPolicy.GetSkipReason(v.Result.Model);

                            if v132 == nil then
                                GrowthAnimation:Play();
                            else
                                PlacedEggGrowthPresentationPolicy.LogSkipped(v.Uid, "random growth jump", v132);
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function updateGrowth(p133) -- Line: 764
    -- upvalues: u3 (copy), GetDirectGrowthTweenRemainingSeconds (copy), Players (copy), updatePrompt (copy), setStateScale (copy), GetVisualScale (copy), PlacedEggGrowthPresentationPolicy (copy)
    for _, v in pairs(u3) do
        if not v.IsHatching and v.Result.Model.Parent ~= nil then
            local NightTimeSkipAnimation = v.NightTimeSkipAnimation;
            local v134;

            if NightTimeSkipAnimation == nil then
                v134 = false;
            else
                v134 = not NightTimeSkipAnimation:IsComplete();
            end;

            if not v134 then
                local v135 = GetDirectGrowthTweenRemainingSeconds(v.Record, p133);

                if v.OwnerUserId == Players.LocalPlayer.UserId and v135 > 0 then
                    if not v.DirectGrowthTweenActive then
                        updatePrompt(v);
                        local v136 = TweenInfo.new(math.max(v135, 0.05), Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                        setStateScale(v, v.TargetScale, v136, true, true);
                    end;
                else
                    local NextGrowthUpdateAt = v.NextGrowthUpdateAt;

                    if p133 >= NextGrowthUpdateAt then
                        v.NextGrowthUpdateAt = NextGrowthUpdateAt + (math.floor((p133 - NextGrowthUpdateAt) / 5) + 1) * 5;
                        updatePrompt(v);
                        local v137 = GetVisualScale(v.Record, v.StartScale, v.TargetScale);
                        local v138 = PlacedEggGrowthPresentationPolicy.GetNaturalGrowthSkipReason(v.Result.Model, v137);

                        if setStateScale(v, v137, nil, v138 == nil) then
                            local v139 = assert(v138, "Skipped natural growth requires a presentation reason");
                            PlacedEggGrowthPresentationPolicy.LogSkipped(v.Uid, "natural growth", v139);
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

local function updateNightTimeSkips() -- Line: 796
    -- upvalues: u3 (copy), clearNightTimeSkipAnimation (copy), updatePrompt (copy), PlacedEggBillboard (copy)
    for _, v in pairs(u3) do
        local NightTimeSkipAnimation = v.NightTimeSkipAnimation;

        if NightTimeSkipAnimation ~= nil then
            if v.IsHatching or v.Result.Model.Parent == nil then
                clearNightTimeSkipAnimation(v);
            else
                updatePrompt(v);

                if v.NightBillboardSuppressed and NightTimeSkipAnimation:IsBillboardFadeFinished() then
                    v.NightBillboardSuppressed = false;
                    PlacedEggBillboard.SetNightPresentationActive(v.OwnerUserId, v.Uid, false);
                end;

                if NightTimeSkipAnimation:IsComplete() then
                    clearNightTimeSkipAnimation(v);
                    PlacedEggBillboard.SetEntry({
                        TimeSkipSeconds = nil,
                        OwnerUserId = v.OwnerUserId,
                        Uid = v.Uid,
                        Record = v.Record,
                        Model = v.Result.Model
                    });
                end;
            end;
        end;
    end;
end;

function u10.GetRenderFolder() -- Line: 837
    -- upvalues: Folder (copy)
    return Folder;
end;

function u10.Refresh() -- Line: 841
    -- upvalues: refreshAll (copy)
    refreshAll();
end;

function u10.SetPromptsSuppressed(p140) -- Line: 845
    -- upvalues: Asserts (copy), u8 (ref), u3 (copy), updatePrompt (copy)
    Asserts.boolean(p140);
    u8 = p140;

    for _, v in pairs(u3) do
        updatePrompt(v);
    end;
end;

function u10.ActivateLocalEgg(p141) -- Line: 854
    -- upvalues: Asserts (copy), u3 (copy), Players (copy), activatePrompt (copy)
    Asserts.string(p141);
    local v142 = u3[`{Players.LocalPlayer.UserId}:{p141}`];

    if v142 == nil then
        return false, "Egg is not rendered";
    end;

    return activatePrompt(v142);
end;

function u10.RequestSkipGrowthForLocalEgg(p143) -- Line: 865
    -- upvalues: Asserts (copy), u3 (copy), Players (copy), IsReady (copy), activatePrompt (copy)
    Asserts.string(p143);
    local v144 = u3[`{Players.LocalPlayer.UserId}:{p143}`];

    if v144 == nil then
        return false, "Egg is not rendered";
    end;

    local Record = v144.Record;
    local NightTimeSkipAnimation = v144.NightTimeSkipAnimation;
    local v145;

    if NightTimeSkipAnimation == nil then
        v145 = nil;
    else
        v145 = NightTimeSkipAnimation:GetAppliedSecondsValue();
    end;

    if IsReady(Record, v145 == nil and 0 or v145.Value) then
        return false, "Egg is already ready";
    end;

    return activatePrompt(v144);
end;

function u10.AppendRaycastTargets(p146, p147) -- Line: 879
    -- upvalues: Asserts (copy), u3 (copy)
    Asserts.number(p147);

    for _, v in pairs(u3) do
        if v.OwnerUserId == p147 and v.Result.Model.Parent ~= nil then
            table.insert(p146, v.Result.Model);
        end;
    end;
end;

function u10.DestroyOwner(p148) -- Line: 889
    -- upvalues: Asserts (copy), destroyOwnerStates (copy), PlacedEggBillboard (copy)
    Asserts.number(p148);
    destroyOwnerStates(p148);
    PlacedEggBillboard.DestroyOwner(p148);
end;

EggCmds.RuntimeSnapshotUpdated:Connect(refreshAll);
EggCmds.RuntimeOwnerUpdated:Connect(u56);
EggCmds.RuntimeOwnerCleared:Connect(u10.DestroyOwner);
EggCmds.AreaEggResetStartCountdown:Connect(startNightTimeSkip);
PlotCmds.OnAnyPlotUpdated:Connect(refreshAll);
RunService.Heartbeat:Connect(function() -- Line: 825, Name: stepPlacedEggs
    -- upvalues: Workspace (copy), updateNightTimeSkips (copy), updateGrowthPulses (copy), updateReadyPulses (copy), updateGrowth (copy)
    local v149 = Workspace:GetServerTimeNow();
    updateNightTimeSkips();
    updateGrowthPulses(v149);
    updateReadyPulses(v149);
    updateGrowth(v149);
end);
task.defer(function() -- Line: 906
    -- upvalues: refreshAll (copy), Workspace (copy), AreaEggResetTimeUtil (copy), u7 (ref), u3 (copy), startNightTimeSkipForState (copy)
    refreshAll();
    local v150 = Workspace:GetServerTimeNow();

    if AreaEggResetTimeUtil.IsNight(v150) then
        local v151 = {
            DayStartsAt = AreaEggResetTimeUtil.GetNextResetAt(v150),
            RareSpawns = {}
        };
        u7 = v151.DayStartsAt;

        for _, v in pairs(u3) do
            startNightTimeSkipForState(v, v151.DayStartsAt);
        end;
    end;
end);

return u10;