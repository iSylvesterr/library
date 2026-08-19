-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local RoundSweepComponent = require(script.Parent.RoundSweepComponent);
local u1 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u2 = {};
u2.__index = u2;

local function getTargetPart(p3) -- Line: 71
    local Character = p3.Character;

    if not Character then
        return nil;
    end;

    local v4 = Character:FindFirstChild("UpperTorso") or Character:FindFirstChild("Torso");

    if v4 and v4:IsA("BasePart") then
        return v4;
    end;

    local PrimaryPart = Character.PrimaryPart;

    if PrimaryPart and PrimaryPart:IsA("BasePart") then
        return PrimaryPart;
    end;

    local v5 = Character:FindFirstChildOfClass("Humanoid");

    if v5 then
        return v5.RootPart;
    end;

    return nil;
end;

local function computeTargetOffset(p6) -- Line: 91
    local v7 = (p6 - 1) * 1.7278759594743864;
    local v8 = p6 % 3 * 0.08 + 0.65;
    local v9 = math.cos(v7) * v8;
    local v10 = math.sin(v7) * v8;

    return Vector3.new(v9, 0, v10);
end;

local function computeStartSoundPlaybackSpeed(p11) -- Line: 97
    return (p11 - 1) * 0.04 + 1;
end;

local function cleanupState(p12, p13) -- Line: 101
    -- upvalues: RoundSweepComponent (copy)
    local v14 = p12._statesBySpawnId[p13];

    if not v14 then
        return;
    end;

    p12._statesBySpawnId[p13] = nil;
    RoundSweepComponent.Destroy(v14.component);
end;

local function tweenFov(u15, p16) -- Line: 111
    -- upvalues: Workspace (copy), TweenService (copy), u1 (copy)
    if u15._fovTarget == p16 then
        return;
    end;

    u15._fovTarget = p16;

    if u15._fovTween then
        u15._fovTween:Cancel();
        u15._fovTween = nil;
    end;

    local CurrentCamera = Workspace.CurrentCamera;

    if not CurrentCamera then
        return;
    end;

    local u17 = TweenService:Create(CurrentCamera, u1, {
        FieldOfView = p16
    });
    u15._fovTween = u17;
    u17.Completed:Connect(function() -- Line: 130
        -- upvalues: u15 (copy), u17 (copy)
        if u15._fovTween == u17 then
            u15._fovTween = nil;
        end;
    end);
    u17:Play();
end;

function u2.new(p18) -- Line: 139
    -- upvalues: u2 (copy)
    local v19 = setmetatable({}, u2);
    v19._resolveEntry = p18.ResolveEntry;
    v19._setEntrySweepActive = p18.SetEntrySweepActive;
    v19._onEntryCompleted = p18.OnEntryCompleted;
    v19._statesBySpawnId = {};
    v19._moveParts = {};
    v19._moveCFrames = {};
    v19._fovTween = nil;
    v19._fovTarget = nil;
    v19._cameraEffectsEnabled = false;
    v19._targetUserId = nil;

    return v19;
end;

function u2.Start(p20, p21, p22) -- Line: 154
    -- upvalues: RoundSweepComponent (copy), tweenFov (copy)
    p20._cameraEffectsEnabled = p22.EnableCameraEffects;
    p20._targetUserId = p22.TargetUserId;
    local v23 = false;

    for i, v in ipairs(p21) do
        local v24 = p20._resolveEntry(v.spawnId);

        if v24 then
            local spawnId = v.spawnId;
            local v25 = p20._statesBySpawnId[spawnId];

            if v25 then
                p20._statesBySpawnId[spawnId] = nil;
                RoundSweepComponent.Destroy(v25.component);
            end;

            p20._setEntrySweepActive(v24, true);
            local Create = RoundSweepComponent.Create;
            local v26 = (i - 1) * 1.7278759594743864;
            local v27 = i % 3 * 0.08 + 0.65;
            local v28 = math.cos(v26) * v27;
            local v29 = math.sin(v26) * v27;
            local v30 = Create(v24, (i - 1) * 0.12, Vector3.new(v28, 0, v29), (i - 1) * 0.04 + 1);

            if v30 then
                p20._statesBySpawnId[v.spawnId] = {
                    entry = v24,
                    sweepEntry = v,
                    component = v30,
                    playCompletionEffects = p22.PlayCompletionEffects
                };
                v23 = true;
            end;
        end;
    end;

    if v23 and p20._cameraEffectsEnabled then
        tweenFov(p20, 120);

        return;
    end;

    if p20._cameraEffectsEnabled and next(p20._statesBySpawnId) == nil then
        tweenFov(p20, 70);
        p20._cameraEffectsEnabled = false;
    end;
end;

function u2.CleanupSpawn(p31, p32) -- Line: 195
    -- upvalues: RoundSweepComponent (copy), tweenFov (copy)
    local v33 = p31._statesBySpawnId[p32];

    if v33 then
        p31._statesBySpawnId[p32] = nil;
        RoundSweepComponent.Destroy(v33.component);
    end;

    if p31._cameraEffectsEnabled and next(p31._statesBySpawnId) == nil then
        tweenFov(p31, 70);
        p31._cameraEffectsEnabled = false;
    end;
end;

function u2.Step(p34, p35) -- Line: 203
    -- upvalues: Players (copy), getTargetPart (copy), RoundSweepComponent (copy), Workspace (copy), tweenFov (copy)
    if next(p34._statesBySpawnId) == nil then
        return;
    end;

    local _targetUserId = p34._targetUserId;

    if not _targetUserId then
        return;
    end;

    local v36 = Players:GetPlayerByUserId(_targetUserId);

    if not v36 then
        return;
    end;

    local v37 = getTargetPart(v36);

    if not v37 then
        return;
    end;

    local v38 = 0;

    for i, v in pairs(p34._statesBySpawnId) do
        local v39 = p34._resolveEntry(i);

        if v39 and (v39.model == v.entry.model and v.component.model.Parent) then
            local v40 = RoundSweepComponent.Step(v.component, p35, v37.Position);

            if v40 then
                v38 = v38 + 1;
                p34._moveParts[v38] = v.component.root;
                p34._moveCFrames[v38] = v40;
            end;

            if v.component.completed then
                p34._onEntryCompleted(v.sweepEntry, v.playCompletionEffects);
                p34._statesBySpawnId[i] = nil;
            end;
        else
            local v41 = p34._statesBySpawnId[i];

            if v41 then
                p34._statesBySpawnId[i] = nil;
                RoundSweepComponent.Destroy(v41.component);
            end;
        end;
    end;

    for i = v38 + 1, #p34._moveParts do
        p34._moveParts[i] = nil;
    end;

    for i = v38 + 1, #p34._moveCFrames do
        p34._moveCFrames[i] = nil;
    end;

    if v38 > 0 then
        Workspace:BulkMoveTo(p34._moveParts, p34._moveCFrames, Enum.BulkMoveMode.FireCFrameChanged);
    end;

    if p34._cameraEffectsEnabled and next(p34._statesBySpawnId) == nil then
        tweenFov(p34, 70);
        p34._cameraEffectsEnabled = false;
    end;

    if next(p34._statesBySpawnId) == nil then
        p34._targetUserId = nil;
    end;
end;

function u2.Destroy(p42) -- Line: 266
    -- upvalues: RoundSweepComponent (copy), tweenFov (copy)
    for i in pairs(p42._statesBySpawnId) do
        local v43 = p42._statesBySpawnId[i];

        if v43 then
            p42._statesBySpawnId[i] = nil;
            RoundSweepComponent.Destroy(v43.component);
        end;
    end;

    if p42._cameraEffectsEnabled then
        tweenFov(p42, 70);
        p42._cameraEffectsEnabled = false;
    end;

    p42._targetUserId = nil;
end;

return u2;