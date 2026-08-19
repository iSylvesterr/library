-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GuardTutorialPresentationComponent = require(ReplicatedStorage.Library.Client.GuardTutorialPresentationComponent);
local GuardTutorialSteps = require(ReplicatedStorage.Directory.GuardTutorialSteps);
local GuardTutorial = require(ReplicatedStorage.Library.Types.GuardTutorial);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local MilestoneAdapter = require(script.MilestoneAdapter);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Save = require(ReplicatedStorage.Library.Client.Save);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Types.Interface);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local EquipEgg = require(script.Steps.EquipEgg);
local ExpandPen = require(script.Steps.ExpandPen);
local HatchEgg = require(script.Steps.HatchEgg);
local HeadToPen = require(script.Steps.HeadToPen);
local PlaceEgg = require(script.Steps.PlaceEgg);
local PlacePet = require(script.Steps.PlacePet);
local StealEgg = require(script.Steps.StealEgg);
local TreadmillIntro = require(script.Steps.TreadmillIntro);
local u1 = {};
u1.__index = u1;
u1.__class = "GuardTutorialController";
local GuardTutorial2 = Constants.NETWORK_MAP.GuardTutorial;
local u2 = {
    [StealEgg.StepId] = StealEgg,
    [HeadToPen.StepId] = HeadToPen,
    [EquipEgg.StepId] = EquipEgg,
    [PlaceEgg.StepId] = PlaceEgg,
    [HatchEgg.StepId] = HatchEgg,
    [PlacePet.StepId] = PlacePet,
    [ExpandPen.StepId] = ExpandPen,
    [TreadmillIntro.StepId] = TreadmillIntro
};
local u3 = Log.new();

function u1.new() -- Line: 71
    -- upvalues: u1 (copy), MilestoneAdapter (copy), GuardTutorial (copy), GuardTutorialPresentationComponent (copy), Trove (copy)
    local v4 = setmetatable({}, u1);
    v4._activeStepCleanup = nil;
    v4._activeStepId = nil;
    v4._adapter = MilestoneAdapter.new();
    v4._currentProgress = GuardTutorial.CloneProgress(GuardTutorial.DEFAULT_PROGRESS);
    v4._presentation = GuardTutorialPresentationComponent.new();
    v4._refreshGeneration = 0;
    v4._retryScheduled = false;
    v4._started = false;
    v4._trove = Trove.new();

    return v4;
end;

function u1._clearActiveStep(p5) -- Line: 91
    local _activeStepCleanup = p5._activeStepCleanup;

    if _activeStepCleanup ~= nil then
        p5._activeStepCleanup = nil;
        _activeStepCleanup();
    end;

    p5._presentation:ClearAll();
    p5._activeStepId = nil;
end;

function u1._readStoredProgress(p6) -- Line: 101
    -- upvalues: Save (copy), GuardTutorial (copy)
    local v7 = Save.Get();

    if v7 == nil then
        return GuardTutorial.CloneProgress(GuardTutorial.DEFAULT_PROGRESS);
    end;

    return GuardTutorial.NormalizeProgress(v7.GuardTutorialProgress);
end;

function u1._syncProgress(p8, p9) -- Line: 110
    -- upvalues: wcall (copy), Network (copy), GuardTutorial2 (copy), GuardTutorial (copy)
    local v10, v11, v12 = wcall(Network.Invoke, GuardTutorial2.REQUEST_SYNC_PROGRESS, p9);

    if not v10 then
        return nil;
    end;

    if v11 ~= true then
        return nil;
    end;

    local v13, v14 = GuardTutorial.SchemaValidation.Progress(v12);
    assert(v13, v14);

    return GuardTutorial.NormalizeProgress(v12);
end;

function u1._queueSyncRetry(u15) -- Line: 127
    -- upvalues: u3 (copy)
    if u15._retryScheduled or not u15._started then
        return;
    end;

    u3:AtTrace():Log("[GuardTutorialController] Queueing tutorial progress sync retry");
    u15._retryScheduled = true;
    task.delay(0.5, function() -- Line: 134
        -- upvalues: u15 (copy)
        if not u15._started then
            u15._retryScheduled = false;

            return;
        end;

        u15._retryScheduled = false;
        u15:RefreshProgress();
    end);
end;

function u1._resolveNextProgress(p16, p17) -- Line: 145
    -- upvalues: GuardTutorial (copy), GuardTutorialSteps (copy), u2 (copy)
    if p17.Completed then
        return GuardTutorial.CloneProgress(p17);
    end;

    local v18 = GuardTutorialSteps.GetOrderedStepIds();
    local v19;

    if p17.CurrentStepId == nil then
        v19 = 1;
    else
        v19 = GuardTutorialSteps.GetIndex(p17.CurrentStepId);
        local v20 = `Unknown guard tutorial step id: {p17.CurrentStepId}`;
        assert(v19 ~= nil, v20);
    end;

    for i = v19, #v18 do
        local v21 = v18[i];
        local v22 = u2[v21];
        local v23 = `Missing guard tutorial step module for {v21}`;
        assert(v22 ~= nil, v23);

        if not v22.IsSatisfied(p16._adapter) then
            return {
                Completed = false,
                CurrentStepId = v21
            };
        end;
    end;

    return {
        Completed = true,
        CurrentStepId = nil
    };
end;

function u1._bindCurrentStep(u24) -- Line: 179
    -- upvalues: u2 (copy)
    local CurrentStepId = u24._currentProgress.CurrentStepId;

    if u24._currentProgress.Completed or CurrentStepId == nil then
        u24:_clearActiveStep();

        return;
    end;

    if u24._activeStepId == CurrentStepId and u24._activeStepCleanup ~= nil then
        return;
    end;

    u24:_clearActiveStep();
    local v25 = u2[CurrentStepId];
    local v26 = `Missing guard tutorial step module for {CurrentStepId}`;
    assert(v25 ~= nil, v26);
    u24._activeStepId = CurrentStepId;
    local u27;

    if v25.Present == nil then
        u27 = nil;
    else
        u27 = v25.Present(u24._presentation, u24._adapter);
    end;

    local u28 = v25.Bind(u24._adapter, function() -- Line: 201
        -- upvalues: u24 (copy), CurrentStepId (copy)
        if u24._currentProgress.Completed or u24._currentProgress.CurrentStepId ~= CurrentStepId then
            return;
        end;

        u24:RefreshProgress();
    end);

    function u24._activeStepCleanup() -- Line: 208
        -- upvalues: u28 (copy), u27 (ref), u24 (copy)
        u28();

        if u27 ~= nil then
            u27();
        end;

        u24._presentation:ClearAll();
    end;
end;

function u1._startAfterReadiness(p29) -- Line: 217
    local v30 = p29:_readStoredProgress();
    p29._currentProgress = v30;

    if v30.Completed then
        p29:_clearActiveStep();

        return;
    end;

    p29:RefreshProgress();
end;

function u1.Start(u31) -- Line: 233
    -- upvalues: Save (copy)
    if u31._started then
        return;
    end;

    u31._started = true;
    u31._trove:Add(u31._adapter.Changed:Connect(function() -- Line: 240
        -- upvalues: u31 (copy)
        u31:RefreshProgress();
    end));
    u31._trove:Add(Save.GetStatChangedSignal("GuardTutorialProgress"):Connect(function() -- Line: 243
        -- upvalues: u31 (copy)
        u31:RefreshProgress();
    end));

    if Save.IsLocalDataLoaded() then
        u31:_startAfterReadiness();

        return;
    end;

    local v32 = Save.LoadedStats:Connect(function() -- Line: 252
        -- upvalues: u31 (copy)
        u31:_startAfterReadiness();
    end);
    u31._trove:Add(v32);

    if Save.IsLocalDataLoaded() then
        v32:Disconnect();
        u31:_startAfterReadiness();
    end;
end;

function u1.RefreshProgress(p33) -- Line: 263
    -- upvalues: Save (copy)
    if not (p33._started and Save.IsLocalDataLoaded()) then
        return;
    end;

    p33._refreshGeneration = p33._refreshGeneration + 1;
    local _refreshGeneration = p33._refreshGeneration;
    local v34 = p33:_readStoredProgress();
    local v35 = p33:_resolveNextProgress(v34);
    local v36 = v34.Completed ~= v35.Completed and true or v34.CurrentStepId ~= v35.CurrentStepId;
    p33._currentProgress = v35;
    p33:_bindCurrentStep();

    if v36 then
        local v37 = p33:_syncProgress(v35);

        if not p33._started or _refreshGeneration ~= p33._refreshGeneration then
            return;
        end;

        if v37 ~= nil then
            p33._currentProgress = v37;
            p33:_bindCurrentStep();

            return;
        end;

        p33:_queueSyncRetry();
    end;
end;

function u1.Destroy(p38) -- Line: 292
    p38._started = false;
    p38:_clearActiveStep();
    p38._trove:Destroy();
    p38._presentation:Destroy();
    p38._adapter:Destroy();
end;

return u1;