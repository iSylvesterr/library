-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local SoundModule = UtilsSystem.SoundModule;
local HumanModule = UtilsSystem.HumanModule;
local NetWork = UtilsSystem.NetWork;
local NetMsg = UtilsSystem.NetMsg;
local LocalPlayer = UtilsSystem.LocalPlayer;
local ProjectileCore = require(script.Parent.Projectile.ProjectileCore);
local ProjectileExplosionProfile = require(script.Parent.Projectile.ProjectileExplosionProfile);
local ProjectileExplosionHitPick = require(script.Parent.Projectile.ProjectileExplosionHitPick);
local ProjectileImpact = require(script.Parent.Projectile.ProjectileImpact);
local ProjectileVisualProfile = require(script.Parent.Projectile.ProjectileVisualProfile);
local ProjectileObjectTracking = require(script.Parent.Projectile.ProjectileObjectTracking);
local PlayerAimSync = require(script.Parent.Parent.Parent.BaseSkill.PlayerAimSync);
local HitPolicy = require(script.Parent.Parent.Parent.BaseSkill.HitPolicy);
local SkillCommon = require(script.Parent.SkillCommon);
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local GetData = UtilsSystem.GetData;
local EnumMgr = UtilsSystem.EnumMgr;
local BezierCurve = UtilsSystem.BezierCurve;
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");

local function _getExtraProj(p1) -- Line: 71
    -- upvalues: Players (copy), GetData (copy), EnumMgr (copy)
    local v2 = nil;

    if typeof(p1) == "Instance" then
        if p1:IsA("Player") then
            v2 = p1;
        elseif p1:IsA("Model") then
            v2 = Players:GetPlayerFromCharacter(p1);
        end;
    end;

    if not v2 then
        return 0, 0;
    end;

    local v3 = GetData.GetPlrAttr(v2, EnumMgr.PlrAttr.ExtraProjCount);

    return math.floor(v3), GetData.GetPlrAttr(v2, EnumMgr.PlrAttr.ExtraProjDmgMul);
end;

local function _retireExtraClone(u4) -- Line: 93
    -- upvalues: FXUtil (copy), TweenService (copy)
    if not (u4 and u4.Parent) then
        return;
    end;

    if u4:GetAttribute("_retiring") then
        return;
    end;

    u4:SetAttribute("_retiring", true);
    FXUtil.Stop_All_Emit(u4);
    local v5 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for _, descendant in u4:GetDescendants() do
        if descendant:IsA("Trail") then
            descendant.Enabled = false;
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        elseif descendant:IsA("BasePart") then
            TweenService:Create(descendant, v5, {
                Transparency = 1
            }):Play();
        end;
    end;

    task.delay(0.3, function() -- Line: 112
        -- upvalues: u4 (copy)
        if u4 and u4.Parent then
            u4:Destroy();
        end;
    end);
end;

local u6 = {
    startupDuration = 0.7,
    explodingDuration = 0.3,
    recoveryDuration = 0.2,
    visualFadeoutTime = 2,
    actionOverTime = 1.1,
    flySpeed = 130,
    maxFlyTime = 1,
    minTrackedMoveTime = 0.15,
    bezierSeed = 10000,
    stopOnObstacle = false,
    obstacleRaycastMinFlightTime = 0,
    stopOnFirstEnemy = false,
    enableFlyHitDetection = false,
    releaseSound = "玩家普攻-施法1",
    flySound = "玩家普攻-飞行1",
    expSound = "玩家普攻-爆炸1",
    explosionVisualYOffset = 0,
    startupResName = "普攻一段起手",
    explosionResName = "普攻爆炸",
    explosionLightResName = "普攻爆炸灯",
    trailResName = "普攻魔杖尾迹",
    projectileResName = "普攻魔法弹",
    animationName = "魔法弹1",
    animationFadeTime = 0.1,
    animationSpeed = 1,
    skillElementType = EnumMgr.ElementTp.None,
    hitbox1Size = Vector3.new(2, 2, 2),
    hitbox2Size = Vector3.new(3, 3, 3),
    hitbox2DamageRate = 1,
    hitPresentationProfile = "通用受击",
    skillConfSkillId = nil,
    trailParent = workspace.Debris,
    impactNextState = "Exploding",
    refreshAimOnEnterProjectileFlying = false,
    tracking = {
        enabled = false,
        objectValueName = "NowTargetCurrent",
        getTrackTargetObjectValue = nil,
        getTargetWorldPosition = nil,
        extractTargetId = nil,
        curveRefreshInterval = 0,
        middlePointCount = 8,
        objectValuePathSegments = {}
    },
    telegraph = {
        enabled = false,
        shape = "Circle",
        lockAtStartupElapsed = nil,
        earlyLockBeforeImpact = 0.4,
        activeDuration = nil,
        groundRayUp = 4,
        groundLift = 0.3,
        groundRayTag = "Ground"
    }
};

local function mergeTracking(p7, p8) -- Line: 199
    -- upvalues: u6 (copy)
    for i, v in pairs(u6.tracking) do
        p7[i] = v;
    end;

    if p8 then
        for i, v in pairs(p8) do
            p7[i] = v;
        end;
    end;
end;

local function mergeTelegraph(p9, p10) -- Line: 210
    -- upvalues: u6 (copy)
    for i, v in pairs(u6.telegraph) do
        p9[i] = v;
    end;

    if p10 then
        for i, v in pairs(p10) do
            p9[i] = v;
        end;
    end;
end;

local function mergeConfig(p11) -- Line: 221
    -- upvalues: u6 (copy)
    local v12 = {};

    for i, v in pairs(u6) do
        if i == "tracking" then
            v12.tracking = {};
            local tracking = v12.tracking;

            for i2, v2 in pairs(u6.tracking) do
                tracking[i2] = v2;
            end;
        elseif i == "telegraph" then
            v12.telegraph = {};
            local telegraph = v12.telegraph;

            for i2, v2 in pairs(u6.telegraph) do
                telegraph[i2] = v2;
            end;
        else
            v12[i] = v;
        end;
    end;

    if p11 then
        for i, v in pairs(p11) do
            if i == "tracking" and type(v) == "table" then
                local tracking = v12.tracking;

                for i2, v2 in pairs(u6.tracking) do
                    tracking[i2] = v2;
                end;

                if v then
                    for i2, v2 in pairs(v) do
                        tracking[i2] = v2;
                    end;
                end;
            elseif i == "telegraph" and type(v) == "table" then
                local telegraph = v12.telegraph;

                for i2, v2 in pairs(u6.telegraph) do
                    telegraph[i2] = v2;
                end;

                if v then
                    for i2, v2 in pairs(v) do
                        telegraph[i2] = v2;
                    end;
                end;
            else
                v12[i] = v;
            end;
        end;
    end;

    return v12;
end;

local function mergeHitboxConfig(p13, p14) -- Line: 254
    -- upvalues: HitPolicy (copy)
    if not p14 or #p14 == 0 then
        return p13;
    end;

    local v15 = {};

    for _, v in p13 do
        v15[v.HitboxIndex] = v;
    end;

    for _, v in p14 do
        local HitboxIndex = v.HitboxIndex;

        if HitboxIndex then
            local v16 = v15[HitboxIndex];

            if v16 then
                local v17 = {};

                for i, v2 in pairs(v16) do
                    v17[i] = v2;
                end;

                for i, v2 in pairs(v) do
                    if i == "HitPolicy" and type(v2) == "table" then
                        v17.HitPolicy = HitPolicy.merge(HitPolicy.fromHitboxEntry({
                            HitPolicy = v17.HitPolicy
                        }), v2);
                    else
                        v17[i] = v2;
                    end;
                end;

                v15[HitboxIndex] = v17;
            else
                v15[HitboxIndex] = v;
            end;
        end;
    end;

    local v18 = {};

    for _, v in p13 do
        table.insert(v18, v15[v.HitboxIndex] or v);
    end;

    return v18;
end;

return {
    create = function(p19) -- Line: 298, Name: create
        -- upvalues: mergeConfig (copy), ProjectileCore (copy), ProjectileExplosionProfile (copy), ProjectileVisualProfile (copy), SkillEventConst (copy), PlayerAimSync (copy), RunService (copy), ProjectileObjectTracking (copy), SkillCommon (copy), LocalPlayer (copy), NetWork (copy), NetMsg (copy), SkillTelegraph (copy), SoundModule (copy), FXUtil (copy), HumanModule (copy), _getExtraProj (copy), _retireExtraClone (copy), BezierCurve (copy), ProjectileImpact (copy), HitPolicy (copy), ProjectileExplosionHitPick (copy), mergeHitboxConfig (copy)
        local u20 = mergeConfig(p19);
        local u21 = u20.enableFlyHitDetection == true;
        local u22 = ProjectileCore.create(u20);
        local u23 = ProjectileExplosionProfile.create(u20);
        local u24 = ProjectileVisualProfile.create(u20);
        local u25 = {
            skillTotalTime = -1,
            visualFadeoutTime = u20.visualFadeoutTime,
            skillElementType = u20.skillElementType
        };
        local v26 = u20.impactNextState or "Exploding";
        local u27 = v26 == "Exploding";
        u25.InitialState = "Startup";
        u25.States = {
            Startup = {
                OnEnterClient = "Client_EnterStartup",
                OnEnterServer = "Server_EnterStartup",
                OnExitClient = "Client_ExitStartup",
                OnExitServer = nil,
                Duration = u20.startupDuration
            },
            ProjectileFlying = {
                Duration = -1,
                OnEnterClient = "Client_EnterProjectileFlying",
                OnEnterServer = "Server_EnterProjectileFlying",
                OnExitClient = "Client_ExitProjectileFlying",
                OnExitServer = "Server_ExitProjectileFlying"
            },
            Recovery = {
                OnEnterClient = "Client_EnterRecovery",
                OnEnterServer = "Server_EnterRecovery",
                OnExitClient = nil,
                OnExitServer = nil,
                Duration = u20.recoveryDuration
            },
            Finished = {
                Duration = 0,
                IsTerminal = true
            },
            Interrupted = {
                Duration = 0,
                IsTerminal = true
            }
        };

        if u27 then
            u25.States.Exploding = {
                OnEnterClient = "Client_EnterExploding",
                OnEnterServer = "Server_EnterExploding",
                OnExitClient = nil,
                OnExitServer = nil,
                Duration = u20.explodingDuration
            };
        end;

        u25.Transitions = {
            {
                From = "Startup",
                To = "ProjectileFlying",
                Event = SkillEventConst.StateTimeout
            },
            {
                From = "ProjectileFlying",
                To = v26,
                Event = SkillEventConst.EnemyHit
            },
            {
                From = "ProjectileFlying",
                To = v26,
                Event = SkillEventConst.ObstacleHit
            },
            {
                From = "ProjectileFlying",
                To = v26,
                Event = SkillEventConst.Timeout
            },
            {
                From = "Recovery",
                To = "Finished",
                Event = SkillEventConst.StateTimeout
            },
            {
                From = "Startup",
                To = "Interrupted",
                Event = SkillEventConst.Interrupt
            },
            {
                From = "ProjectileFlying",
                To = "Interrupted",
                Event = SkillEventConst.Interrupt
            },
            {
                From = "Recovery",
                To = "Interrupted",
                Event = SkillEventConst.Interrupt
            },
            {
                From = "Startup",
                To = "Finished",
                Event = SkillEventConst.ForceFinish
            },
            {
                From = "ProjectileFlying",
                To = "Finished",
                Event = SkillEventConst.ForceFinish
            },
            {
                From = "Recovery",
                To = "Finished",
                Event = SkillEventConst.ForceFinish
            }
        };

        if u27 then
            table.insert(u25.Transitions, {
                From = "Exploding",
                To = "Recovery",
                Event = SkillEventConst.StateTimeout
            });
            table.insert(u25.Transitions, {
                From = "Exploding",
                To = "Interrupted",
                Event = SkillEventConst.Interrupt
            });
            table.insert(u25.Transitions, {
                From = "Exploding",
                To = "Finished",
                Event = SkillEventConst.ForceFinish
            });
        end;

        u25.StateOrder = u27 and {
            Startup = 1,
            ProjectileFlying = 2,
            Exploding = 3,
            Recovery = 4,
            Finished = 5,
            Interrupted = 6
        } or {
            Startup = 1,
            ProjectileFlying = 2,
            Recovery = 3,
            Finished = 4,
            Interrupted = 5
        };
        local onProjectileStart = u20.onProjectileStart;
        local onProjectileImpact = u20.onProjectileImpact;
        local onProjectileTimeout = u20.onProjectileTimeout;
        local onProjectileFinish = u20.onProjectileFinish;

        local function refreshAimOnEnterProjectileFlyingIfNeeded(p28) -- Line: 380
            -- upvalues: u20 (copy), PlayerAimSync (ref)
            if u20.refreshAimOnEnterProjectileFlying then
                PlayerAimSync.refreshAimSnapshot(p28);
            end;
        end;

        local function refreshTrackTargetOnEnterProjectileFlyingIfNeeded(p29) -- Line: 390
            -- upvalues: u20 (copy), RunService (ref), ProjectileObjectTracking (ref)
            local tracking = u20.tracking;

            if not u20.refreshAimOnEnterProjectileFlying or (not tracking or tracking.enabled ~= true) then
                return;
            end;

            local skillInputData = p29.skillInputData;

            if not skillInputData then
                return;
            end;

            local _castSnapshotRef = skillInputData._castSnapshotRef;
            local v30;

            if RunService:IsClient() then
                v30 = ProjectileObjectTracking.refreshTrackTargetIdForSkillInput(tracking);
                skillInputData.trackTargetId = v30;

                if _castSnapshotRef then
                    _castSnapshotRef.trackTargetId = v30;
                end;
            else
                v30 = ProjectileObjectTracking.resolveTrackTargetIdForProjectileFlying(skillInputData.trackTargetId, _castSnapshotRef, p29.character, p29.characterId, p29.characterType);
                skillInputData.trackTargetId = v30;

                if _castSnapshotRef then
                    _castSnapshotRef.trackTargetId = v30;
                end;
            end;

            local v31 = p29.skillRunData and p29.skillRunData.Logic;

            if v31 then
                v31.trackTargetId = v30;
            end;
        end;

        local function makeGetTrackedEndPosition(u32, u33) -- Line: 431
            -- upvalues: ProjectileObjectTracking (ref)
            return function() -- Line: 432
                -- upvalues: u32 (copy), ProjectileObjectTracking (ref), u33 (copy)
                local v34 = u32.skillRunData and u32.skillRunData.Logic;

                if v34 and v34.lockedExplosionGroundPos then
                    return v34.lockedExplosionGroundPos;
                end;

                local skillInputData = u32.skillInputData;
                local v35 = v34 and v34.trackTargetId;

                if v35 then
                    skillInputData = v35;
                elseif skillInputData then
                    skillInputData = skillInputData.trackTargetId;
                end;

                return ProjectileObjectTracking.getLiveTrackedWorldPosition(skillInputData, u32.character, u33);
            end;
        end;

        local function resolveAuthoritativeExplosionHitPosition(p36, p37) -- Line: 449
            -- upvalues: u20 (copy), u27 (copy), SkillCommon (ref), ProjectileObjectTracking (ref)
            local v38 = p36.skillRunData and p36.skillRunData.Logic;

            if v38 and v38.lockedExplosionGroundPos then
                return v38.lockedExplosionGroundPos;
            end;

            local telegraph = u20.telegraph;

            if u27 and (telegraph and telegraph.enabled == true) then
                local skillInputData = p36.skillInputData;
                local v39 = skillInputData and SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, telegraph.groundRayUp, telegraph.groundLift, telegraph.groundRayTag);

                if v39 then
                    return v39;
                end;
            end;

            local tracking = u20.tracking;

            if tracking and tracking.enabled == true then
                local skillInputData = p36.skillInputData;
                local v40 = v38 and v38.trackTargetId;

                if v40 then
                    skillInputData = v40;
                elseif skillInputData then
                    skillInputData = skillInputData.trackTargetId;
                end;

                local v41 = skillInputData and ProjectileObjectTracking.getLiveTrackedWorldPosition(skillInputData, p36.character, tracking);

                if v41 then
                    return v41;
                end;
            end;

            if v38 and v38.impactPosition then
                return v38.impactPosition;
            end;

            return p37;
        end;

        local function pushTrackTargetRefreshToServerIfNeeded(p42) -- Line: 491
            -- upvalues: u20 (copy), LocalPlayer (ref), NetWork (ref), NetMsg (ref)
            local tracking = u20.tracking;

            if not u20.refreshAimOnEnterProjectileFlying or (not tracking or tracking.enabled ~= true) then
                return;
            end;

            local skillInputData = p42.skillInputData;

            if not skillInputData or (p42.characterType ~= "Player" or (not LocalPlayer or p42.characterId ~= LocalPlayer.UserId)) then
                return;
            end;

            local slotIndex = skillInputData.slotIndex;

            if type(slotIndex) ~= "number" or not p42.skillCastId then
                return;
            end;

            NetWork.FireServer(NetMsg.RELEASE_GROUP_SKILL, slotIndex, {
                trackTargetRefreshOnly = true,
                skillCastId = p42.skillCastId,
                trackTargetId = skillInputData.trackTargetId,
                targetCF = skillInputData.targetCF
            });
        end;

        local playExplosion = u23.playExplosion;
        u25.playExplosion = playExplosion;
        local telegraph = u20.telegraph;
        local EXPLOSION_HITBOX_SIZE = u23.EXPLOSION_HITBOX_SIZE;
        local EXPLOSION_TWEEN_TIME = u23.EXPLOSION_TWEEN_TIME;
        local AIM_RUN_EVENT_KEY = SkillTelegraph.AIM_RUN_EVENT_KEY;

        local function isTelegraphEnabled() -- Line: 524
            -- upvalues: u27 (copy), telegraph (copy)
            return u27 and telegraph and telegraph.enabled == true;
        end;

        local function resolveTelegraphHitboxSize(p43) -- Line: 534
            -- upvalues: EXPLOSION_HITBOX_SIZE (copy)
            return EXPLOSION_HITBOX_SIZE;
        end;

        local function resolveTelegraphGroundCF(p44) -- Line: 544
            -- upvalues: SkillCommon (ref), telegraph (copy)
            local skillInputData = p44.skillInputData;

            if not skillInputData then
                return nil;
            end;

            local v45 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, telegraph.groundRayUp, telegraph.groundLift, telegraph.groundRayTag);

            if v45 then
                return CFrame.new(v45);
            end;

            return nil;
        end;

        local function estimateTelegraphFlightSec(u46) -- Line: 567
            -- upvalues: u20 (copy), u22 (copy)
            local tracking = u20.tracking;

            if tracking and tracking.enabled == true then
                return u20.maxFlyTime;
            end;

            local success, result = pcall(function() -- Line: 572
                -- upvalues: u22 (ref), u46 (copy)
                local _, _, _, v47 = u22.computeTrajectory(u46);

                return v47;
            end);

            if success and (type(result) == "number" and result > 0) then
                return result;
            end;

            return u20.maxFlyTime;
        end;

        local function stopTelegraphAimLoop(p48) -- Line: 587
            -- upvalues: AIM_RUN_EVENT_KEY (copy)
            if not (p48 and p48.runEvent) then
                return;
            end;

            local v49 = p48.runEvent[AIM_RUN_EVENT_KEY];

            if v49 then
                v49:Disconnect();
                p48.runEvent[AIM_RUN_EVENT_KEY] = nil;
            end;
        end;

        local function destroyDangerTelegraph(p50) -- Line: 603
            -- upvalues: AIM_RUN_EVENT_KEY (copy)
            local v51 = p50 and p50.runEvent and p50.runEvent[AIM_RUN_EVENT_KEY];

            if v51 then
                v51:Disconnect();
                p50.runEvent[AIM_RUN_EVENT_KEY] = nil;
            end;

            if not (p50 and p50.Logic) then
                return;
            end;

            local dangerTelegraph = p50.Logic.dangerTelegraph;

            if dangerTelegraph and dangerTelegraph.destroy then
                dangerTelegraph:destroy();
            end;

            p50.Logic.dangerTelegraph = nil;
            p50.Logic.telegraphLocked = nil;
            p50.Logic.telegraphFrozenGroundCF = nil;
            p50.Logic.lockedExplosionGroundPos = nil;
            p50.Logic._explosionGroundLockScheduled = nil;
        end;

        local function commitLockedExplosionGroundPos(p52, p53) -- Line: 626
            -- upvalues: SkillCommon (ref), telegraph (copy)
            SkillCommon.refreshSkillAimSnapshot(p52);
            local skillInputData = p52.skillInputData;
            local v54;

            if skillInputData then
                local v55 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, telegraph.groundRayUp, telegraph.groundLift, telegraph.groundRayTag);

                if v55 then
                    v54 = CFrame.new(v55);
                else
                    v54 = nil;
                end;
            else
                v54 = nil;
            end;

            if not v54 then
                return false;
            end;

            p53.lockedExplosionGroundPos = v54.Position;
            p53.telegraphFrozenGroundCF = v54;
            p53.telegraphLocked = true;

            return true;
        end;

        local function resolveTelegraphLockAtElapsed() -- Line: 643
            -- upvalues: telegraph (copy)
            local lockAtStartupElapsed = telegraph.lockAtStartupElapsed;

            if type(lockAtStartupElapsed) == "number" and lockAtStartupElapsed >= 0 then
                return lockAtStartupElapsed;
            end;

            return nil;
        end;

        local function resolveServerExplosionGroundLockDelay(p56) -- Line: 657
            -- upvalues: telegraph (copy), estimateTelegraphFlightSec (copy), u20 (copy)
            local lockAtStartupElapsed = telegraph.lockAtStartupElapsed;

            if type(lockAtStartupElapsed) ~= "number" or lockAtStartupElapsed < 0 then
                lockAtStartupElapsed = nil;
            end;

            if lockAtStartupElapsed ~= nil then
                return lockAtStartupElapsed;
            end;

            local earlyLockBeforeImpact = telegraph.earlyLockBeforeImpact;

            if type(earlyLockBeforeImpact) ~= "number" or earlyLockBeforeImpact <= 0 then
                return nil;
            end;

            local v57 = p56.skillRunData.Logic and p56.skillRunData.Logic.telegraphFlightSec or estimateTelegraphFlightSec(p56);

            return math.max(0, u20.startupDuration + v57 - earlyLockBeforeImpact);
        end;

        local function scheduleServerExplosionGroundLock(u58) -- Line: 676
            -- upvalues: resolveServerExplosionGroundLockDelay (copy), SkillCommon (ref), telegraph (copy)
            local v59 = resolveServerExplosionGroundLockDelay(u58);

            if v59 == nil then
                return;
            end;

            local skillRunData = u58.skillRunData;

            if not skillRunData then
                return;
            end;

            skillRunData.Logic = skillRunData.Logic or {};

            if skillRunData.Logic.lockedExplosionGroundPos or skillRunData.Logic._explosionGroundLockScheduled then
                return;
            end;

            skillRunData.Logic._explosionGroundLockScheduled = true;
            local runGeneration = u58.runGeneration;
            task.delay(v59, function() -- Line: 692
                -- upvalues: u58 (copy), runGeneration (copy), SkillCommon (ref), telegraph (ref)
                if not u58:isRunningFlow() or u58.runGeneration ~= runGeneration then
                    return;
                end;

                local skillRunData2 = u58.skillRunData;

                if not (skillRunData2 and skillRunData2.Logic) then
                    return;
                end;

                if skillRunData2.Logic.lockedExplosionGroundPos then
                    return;
                end;

                local v60 = u58;
                local Logic = skillRunData2.Logic;
                SkillCommon.refreshSkillAimSnapshot(v60);
                local skillInputData = v60.skillInputData;
                local v61;

                if skillInputData then
                    local v62 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, telegraph.groundRayUp, telegraph.groundLift, telegraph.groundRayTag);

                    if v62 then
                        v61 = CFrame.new(v62);
                    else
                        v61 = nil;
                    end;
                else
                    v61 = nil;
                end;

                if not v61 then
                    return;
                end;

                Logic.lockedExplosionGroundPos = v61.Position;
                Logic.telegraphFrozenGroundCF = v61;
                Logic.telegraphLocked = true;
            end);
        end;

        local function lockTelegraphAtCurrentGround(p63, p64, p65) -- Line: 714
            -- upvalues: SkillCommon (ref), telegraph (copy), EXPLOSION_HITBOX_SIZE (copy)
            SkillCommon.refreshSkillAimSnapshot(p63);
            local skillInputData = p63.skillInputData;
            local v66;

            if skillInputData then
                local v67 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, telegraph.groundRayUp, telegraph.groundLift, telegraph.groundRayTag);

                if v67 then
                    v66 = CFrame.new(v67);
                else
                    v66 = nil;
                end;
            else
                v66 = nil;
            end;

            local v68;

            if v66 then
                p64.lockedExplosionGroundPos = v66.Position;
                p64.telegraphFrozenGroundCF = v66;
                p64.telegraphLocked = true;
                v68 = true;
            else
                v68 = false;
            end;

            if not v68 then
                return;
            end;

            p65:update({
                lockPosition = true,
                worldCFrame = p64.telegraphFrozenGroundCF,
                hitboxSize = EXPLOSION_HITBOX_SIZE
            });
        end;

        local function startTelegraphAimLoop(u69, u70, u71) -- Line: 732
            -- upvalues: AIM_RUN_EVENT_KEY (copy), RunService (ref), EXPLOSION_HITBOX_SIZE (copy), telegraph (copy), u20 (copy), lockTelegraphAtCurrentGround (copy), SkillCommon (ref)
            local v72 = u70 and u70.runEvent and u70.runEvent[AIM_RUN_EVENT_KEY];

            if v72 then
                v72:Disconnect();
                u70.runEvent[AIM_RUN_EVENT_KEY] = nil;
            end;

            u70.runEvent = u70.runEvent or {};
            u70.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 735
                -- upvalues: u69 (copy), u71 (copy), u70 (copy), AIM_RUN_EVENT_KEY (ref), EXPLOSION_HITBOX_SIZE (ref), telegraph (ref), u20 (ref), lockTelegraphAtCurrentGround (ref), SkillCommon (ref)
                if not u69:isRunningFlow() or u69.runGeneration ~= u71 then
                    local v73 = u70;

                    if v73 then
                        if not v73.runEvent then
                            return;
                        end;

                        local v74 = v73.runEvent[AIM_RUN_EVENT_KEY];

                        if v74 then
                            v74:Disconnect();
                            v73.runEvent[AIM_RUN_EVENT_KEY] = nil;
                        end;
                    end;

                    return;
                end;

                local Logic = u70.Logic;
                local v75;

                if Logic then
                    v75 = Logic.dangerTelegraph;
                else
                    v75 = Logic;
                end;

                if not v75 then
                    return;
                end;

                local v76 = os.clock() - (Logic and Logic.telegraphStartAt or os.clock());

                if Logic.telegraphLocked then
                    local telegraphFrozenGroundCF = Logic.telegraphFrozenGroundCF;

                    if telegraphFrozenGroundCF then
                        v75:update({
                            lockPosition = true,
                            worldCFrame = telegraphFrozenGroundCF,
                            hitboxSize = EXPLOSION_HITBOX_SIZE
                        });
                    end;

                    return;
                end;

                local lockAtStartupElapsed = telegraph.lockAtStartupElapsed;

                if type(lockAtStartupElapsed) ~= "number" or lockAtStartupElapsed < 0 then
                    lockAtStartupElapsed = nil;
                end;

                local v77;

                if lockAtStartupElapsed == nil then
                    local v78 = u20.startupDuration + (Logic and Logic.telegraphFlightSec or u20.maxFlyTime);
                    local v79 = telegraph.earlyLockBeforeImpact or 0;

                    if v79 > 0 then
                        v77 = v78 - v79 <= v76;
                    else
                        v77 = false;
                    end;
                else
                    v77 = lockAtStartupElapsed <= v76;
                end;

                if v77 then
                    lockTelegraphAtCurrentGround(u69, Logic, v75);

                    return;
                end;

                local skillInputData = u69.skillInputData;
                local v80;

                if skillInputData then
                    local v81 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, telegraph.groundRayUp, telegraph.groundLift, telegraph.groundRayTag);

                    if v81 then
                        v80 = CFrame.new(v81);
                    else
                        v80 = nil;
                    end;
                else
                    v80 = nil;
                end;

                if v80 then
                    v75:update({
                        worldCFrame = v80,
                        hitboxSize = EXPLOSION_HITBOX_SIZE
                    });
                end;
            end);
        end;

        local function refineTelegraphOnProjectileFlying(p82, p83, p84, p85) -- Line: 794
            -- upvalues: u27 (copy), telegraph (copy), u20 (copy), u22 (copy)
            if not (u27 and telegraph and telegraph.enabled == true) then
                return;
            end;

            local skillRunData = p82.skillRunData;

            if skillRunData then
                skillRunData = skillRunData.Logic;
            end;

            local v86;

            if skillRunData then
                v86 = skillRunData.dangerTelegraph;
            else
                v86 = skillRunData;
            end;

            if not (v86 and v86.setWarnDuration) then
                return;
            end;

            local maxFlyTime = u20.maxFlyTime;

            if p83 and p84 then
                local v87 = (u22.getProjectileStartCF(p82).Position - p84).Magnitude / u20.flySpeed;
                local v88 = math.min(v87, u20.maxFlyTime);
                p85 = math.max(v88, u20.minTrackedMoveTime or 0.15);
            elseif type(p85) == "number" then
                if p85 <= 0 then
                    p85 = maxFlyTime;
                end;
            else
                p85 = maxFlyTime;
            end;

            skillRunData.telegraphFlightSec = p85;
            v86:setWarnDuration(u20.startupDuration + p85);
        end;

        local function activateExplosionTelegraph(p89) -- Line: 829
            -- upvalues: u27 (copy), telegraph (copy), AIM_RUN_EVENT_KEY (copy), EXPLOSION_HITBOX_SIZE (copy), EXPLOSION_TWEEN_TIME (copy)
            if not (u27 and telegraph and telegraph.enabled == true) then
                return;
            end;

            local skillRunData = p89.skillRunData;
            local v90 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

            if v90 then
                v90:Disconnect();
                skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
            end;

            if skillRunData then
                skillRunData = skillRunData.Logic;
            end;

            local v91;

            if skillRunData then
                v91 = skillRunData.dangerTelegraph;
            else
                v91 = skillRunData;
            end;

            if not (v91 and v91.activate) then
                return;
            end;

            local telegraphFrozenGroundCF = skillRunData.telegraphFrozenGroundCF;

            if not telegraphFrozenGroundCF and skillRunData.lockedExplosionGroundPos then
                telegraphFrozenGroundCF = CFrame.new(skillRunData.lockedExplosionGroundPos);
            end;

            if not telegraphFrozenGroundCF then
                return;
            end;

            v91:update({
                lockPosition = true,
                worldCFrame = telegraphFrozenGroundCF,
                hitboxSize = EXPLOSION_HITBOX_SIZE
            });
            v91:activate(telegraph.activeDuration or EXPLOSION_TWEEN_TIME);
            skillRunData.dangerTelegraph = nil;
        end;

        function u25.Client_EnterStartup(p92) -- Line: 861
            -- upvalues: SoundModule (ref), u20 (copy), RunService (ref), u27 (copy), telegraph (copy), destroyDangerTelegraph (copy), SkillCommon (ref), estimateTelegraphFlightSec (copy), SkillTelegraph (ref), EXPLOSION_HITBOX_SIZE (copy), startTelegraphAimLoop (copy)
            local character = p92.skillInputData.character;

            if not character then
                return;
            end;

            local v93 = character:FindFirstChild("当前手持");

            if not v93 then
                return;
            end;

            local v94 = v93:FindFirstChildOfClass("Model");

            if not v94 then
                return;
            end;

            local u95 = v94:FindFirstChild("魔杖尖端");

            if not u95 then
                return;
            end;

            SoundModule:PlaySoundLocal({
                Is2D = false,
                SoundName = u20.releaseSound,
                PlayPosition = u95.Position
            });
            local u96 = p92.skillRunData.material and p92.skillRunData.material[u20.trailResName];

            if u96 then
                for _, descendant in pairs(u96:GetDescendants()) do
                    if descendant:IsA("Trail") then
                        descendant.Enabled = true;
                    elseif descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = true;
                    end;
                end;

                u96.Parent = u20.trailParent;
                p92:BindStateConn("Startup", RunService.RenderStepped:Connect(function() -- Line: 886
                    -- upvalues: u95 (copy), u96 (copy)
                    if u95.Parent and u96.Parent then
                        u96:PivotTo(u95:GetPivot());
                    end;
                end));
            end;

            if u27 and telegraph and telegraph.enabled == true then
                local skillRunData = p92.skillRunData;
                skillRunData.Logic = skillRunData.Logic or {};
                destroyDangerTelegraph(skillRunData);
                local skillInputData = p92.skillInputData;
                local v97;

                if skillInputData then
                    local v98 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, telegraph.groundRayUp, telegraph.groundLift, telegraph.groundRayTag);

                    if v98 then
                        v97 = CFrame.new(v98);
                    else
                        v97 = nil;
                    end;
                else
                    v97 = nil;
                end;

                if v97 then
                    local v99 = estimateTelegraphFlightSec(p92);
                    skillRunData.Logic.telegraphFlightSec = v99;
                    skillRunData.Logic.telegraphStartAt = os.clock();
                    skillRunData.Logic.telegraphLocked = false;
                    skillRunData.Logic.telegraphFrozenGroundCF = nil;
                    skillRunData.Logic.lockedExplosionGroundPos = nil;
                    skillRunData.Logic.dangerTelegraph = SkillTelegraph.new({
                        skipGroundAlign = true,
                        shape = telegraph.shape or "Circle",
                        worldCFrame = v97,
                        hitboxSize = EXPLOSION_HITBOX_SIZE,
                        warnDuration = u20.startupDuration + v99,
                        casterCharacter = character,
                        characterType = p92.characterType
                    });
                    startTelegraphAimLoop(p92, skillRunData, p92.runGeneration);
                end;
            end;
        end;

        function u25.Server_EnterStartup(p100) -- Line: 920
            -- upvalues: u27 (copy), u20 (copy), telegraph (copy), scheduleServerExplosionGroundLock (copy)
            local v101 = p100.hitbox[1];
            local v102;

            if u27 then
                v102 = p100.hitbox[2] or nil;
            else
                v102 = nil;
            end;

            if v101 and v101.hitbox then
                v101.hitbox.Size = u20.hitbox1Size;
            end;

            if v102 and v102.hitbox then
                v102.hitbox.Size = u20.hitbox2Size;
            end;

            if u27 and telegraph and telegraph.enabled == true then
                local skillRunData = p100.skillRunData;
                skillRunData.Logic = skillRunData.Logic or {};
                skillRunData.Logic.lockedExplosionGroundPos = nil;
                skillRunData.Logic.telegraphLocked = false;
                scheduleServerExplosionGroundLock(p100);
            end;
        end;

        function u25.Client_ExitStartup(p103) -- Line: 935
            -- upvalues: u20 (copy)
            p103:CleanupStateConns("Startup");
            local v104 = p103.skillRunData.material and p103.skillRunData.material[u20.trailResName];

            if v104 then
                for _, descendant in pairs(v104:GetDescendants()) do
                    if descendant:IsA("Trail") then
                        descendant.Enabled = false;
                    elseif descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end;

        function u25.Client_EnterProjectileFlying(u105) -- Line: 948
            -- upvalues: refreshTrackTargetOnEnterProjectileFlyingIfNeeded (copy), u20 (copy), PlayerAimSync (ref), pushTrackTargetRefreshToServerIfNeeded (copy), RunService (ref), FXUtil (ref), u24 (copy), HumanModule (ref), ProjectileObjectTracking (ref), u22 (copy), refineTelegraphOnProjectileFlying (copy), u27 (copy), telegraph (copy), SoundModule (ref), u25 (copy), onProjectileStart (copy), _getExtraProj (ref), _retireExtraClone (ref), BezierCurve (ref)
            refreshTrackTargetOnEnterProjectileFlyingIfNeeded(u105);

            if u20.refreshAimOnEnterProjectileFlying then
                PlayerAimSync.refreshAimSnapshot(u105);
            end;

            pushTrackTargetRefreshToServerIfNeeded(u105);
            local character = u105.skillInputData.character;

            if not character then
                return;
            end;

            local v106 = character:FindFirstChild("当前手持");

            if not v106 then
                return;
            end;

            local v107 = v106:FindFirstChildOfClass("Model");

            if not v107 then
                return;
            end;

            local u108 = v107:FindFirstChild("魔杖尖端");

            if not u108 then
                return;
            end;

            local u109 = u105.skillRunData.material and u105.skillRunData.material[u20.trailResName];

            if u109 and u109.Parent then
                u105:BindStateConn("ProjectileFlying", RunService.RenderStepped:Connect(function() -- Line: 967
                    -- upvalues: u108 (copy), u109 (copy)
                    if u108.Parent and u109.Parent then
                        u109:PivotTo(u108:GetPivot());
                    end;
                end));
            end;

            local skillRunData = u105.skillRunData;
            local v110 = u108:GetPivot();
            local v111 = skillRunData.material and skillRunData.material[u20.startupResName];

            if v111 then
                v111:PivotTo(v110);
                v111.Parent = workspace.Debris;
                FXUtil.Emit_Particles_GetDescendants(v111, true);
            end;

            local v112 = skillRunData.material and skillRunData.material[u20.projectileResName];

            if not v112 then
                warn("[ProjectileSpellTemplate] 必选资源缺失:", u20.projectileResName);

                return;
            end;

            u24.onSpawnVisual(u105, v112);
            local v113 = u105.character or character;
            local tracking = u20.tracking;
            local v114;

            if tracking then
                v114 = tracking.enabled == true;
            else
                v114 = tracking;
            end;

            local v115 = u105.skillInputData and u105.skillInputData.trackTargetId;
            local v116, v117;

            if v114 and not HumanModule.GetIsShiftLocked() then
                local v118;
                v118, v116, v117 = ProjectileObjectTracking.resolveAtCast(v115, v113, tracking);
            else
                v117 = nil;
                v116 = nil;
            end;

            local v119 = v117 or v115;
            skillRunData.Visual.projectileModel = v112;
            skillRunData.Visual.explosionPlayed = false;
            skillRunData.Logic.hasExploded = false;
            local v120, v121;

            if v114 and v116 then
                v120 = u22.getProjectileStartCF(u105);
                skillRunData.Logic.trackTargetId = v119;
                v121 = u22.runTrackedBezierMotion(v112, {
                    startCF = v120,
                    flySpeed = u20.flySpeed,
                    maxFlyTime = u20.maxFlyTime,
                    minTrackedMoveTime = u20.minTrackedMoveTime,
                    bezierSeed = u20.bezierSeed,
                    middlePointCount = tracking.middlePointCount,
                    initialEndPosition = v116,
                    curveRefreshInterval = tracking.curveRefreshInterval,

                    getTrackedEndPosition = function() -- Line: 432
                        -- upvalues: u105 (copy), ProjectileObjectTracking (ref), tracking (copy)
                        local v122 = u105.skillRunData and u105.skillRunData.Logic;

                        if v122 and v122.lockedExplosionGroundPos then
                            return v122.lockedExplosionGroundPos;
                        end;

                        local skillInputData = u105.skillInputData;
                        local v123 = v122 and v122.trackTargetId;

                        if v123 then
                            skillInputData = v123;
                        elseif skillInputData then
                            skillInputData = skillInputData.trackTargetId;
                        end;

                        return ProjectileObjectTracking.getLiveTrackedWorldPosition(skillInputData, u105.character, tracking);
                    end,

                    onStep = function(p124, p125) -- Line: 1022, Name: onStep
                        -- upvalues: skillRunData (copy)
                        skillRunData.Logic.impactPosition = p124;
                    end
                }, function() -- Line: 1025
                end);
                skillRunData.Logic.impactPosition = v116;
                refineTelegraphOnProjectileFlying(u105, true, v116, nil);
            else
                local v126, v127, v128, v129, v130;
                v120, v126, v127, v128, v129, v130 = u22.computeTrajectory(u105);
                v121 = u22.runBezierMotion(v112, v127, v129, v130, function() -- Line: 1031
                end);
                skillRunData.Logic.impactPosition = v126.Position;

                if u27 and telegraph and telegraph.enabled == true then
                    local skillRunData2 = u105.skillRunData;

                    if skillRunData2 then
                        skillRunData2 = skillRunData2.Logic;
                    end;

                    local v131;

                    if skillRunData2 then
                        v131 = skillRunData2.dangerTelegraph;
                    else
                        v131 = skillRunData2;
                    end;

                    if v131 and v131.setWarnDuration then
                        local maxFlyTime = u20.maxFlyTime;

                        if type(v128) == "number" then
                            if v128 <= 0 then
                                v128 = maxFlyTime;
                            end;
                        else
                            v128 = maxFlyTime;
                        end;

                        skillRunData2.telegraphFlightSec = v128;
                        v131:setWarnDuration(u20.startupDuration + v128);
                    end;
                end;
            end;

            if v112:IsA("Model") and v112.PrimaryPart then
                SoundModule:PlaySoundLocal({
                    Is2D = false,
                    SoundName = u20.flySound,
                    PlayPosition = u108.Position
                });
            end;

            v112:PivotTo(v120);
            v112.Parent = workspace.Debris;
            skillRunData.Visual.projectileMotion = v121;
            u105:BindStateConn("ProjectileFlying", v121);
            local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

            if pendingProjectileHitEvent then
                skillRunData.Visual.pendingProjectileHitEvent = nil;
                v121:Disconnect();
                skillRunData.Visual.projectileMotion = nil;
                u25.onServerEvent(u105, pendingProjectileHitEvent);
            end;

            if type(onProjectileStart) == "function" then
                onProjectileStart(u105);
            end;

            local v132 = _getExtraProj(character);

            if v132 > 0 and v112 then
                local v133 = {};

                for i = 1, v132 do
                    local u134 = v112:Clone();
                    u134.Name = v112.Name .. "_Extra" .. i;
                    local v135 = math.ceil(i / 2);
                    local v136 = v120 * CFrame.new((i % 2 == 1 and 1 or -1) * (v135 * 0.3 + 1.2), v135 * 0.3 + 0.3, 0);
                    u134:PivotTo(v136);
                    u134.Parent = workspace.Debris;
                    local v137 = u20.bezierSeed + i * 7777;
                    local v138;

                    if v114 and v116 then
                        v138 = u22.runTrackedBezierMotion(u134, {
                            startCF = v136,
                            flySpeed = u20.flySpeed,
                            maxFlyTime = u20.maxFlyTime,
                            minTrackedMoveTime = u20.minTrackedMoveTime,
                            bezierSeed = v137,
                            middlePointCount = tracking and (tracking.middlePointCount or 8) or 8,
                            initialEndPosition = v116,
                            curveRefreshInterval = tracking and (tracking.curveRefreshInterval or 0) or 0,

                            getTrackedEndPosition = function() -- Line: 432
                                -- upvalues: u105 (copy), ProjectileObjectTracking (ref), tracking (copy)
                                local v139 = u105.skillRunData and u105.skillRunData.Logic;

                                if v139 and v139.lockedExplosionGroundPos then
                                    return v139.lockedExplosionGroundPos;
                                end;

                                local skillInputData = u105.skillInputData;
                                local v140 = v139 and v139.trackTargetId;

                                if v140 then
                                    skillInputData = v140;
                                elseif skillInputData then
                                    skillInputData = skillInputData.trackTargetId;
                                end;

                                return ProjectileObjectTracking.getLiveTrackedWorldPosition(skillInputData, u105.character, tracking);
                            end,

                            onStep = function() -- Line: 1087, Name: onStep
                            end
                        }, function() -- Line: 1088
                            -- upvalues: _retireExtraClone (ref), u134 (copy)
                            _retireExtraClone(u134);
                        end);
                    else
                        local v141 = u22.getProjectileEndCF(u105);
                        local Magnitude = (v136.Position - v141.Position).Magnitude;
                        local v142 = math.min(Magnitude / u20.flySpeed, u20.maxFlyTime) * 60;
                        local v143 = BezierCurve.GenerateBezierPoints(v136.Position, v141.Position, tracking and (tracking.middlePointCount or 8) or 8, {
                            RandomSeed = v137,
                            HeightOffsetRandom = math.min(Magnitude * 0.15, 10),
                            SideOffsetRandom = math.min(Magnitude * 0.35, 24),
                            EasingStyle = Enum.EasingStyle.Quad,
                            EasingDirection = Enum.EasingDirection.Out
                        });
                        v138 = u22.runBezierMotion(u134, v143, v142, 60, function() -- Line: 1105
                            -- upvalues: _retireExtraClone (ref), u134 (copy)
                            _retireExtraClone(u134);
                        end);
                    end;

                    table.insert(v133, u134);
                    u105:BindStateConn("ExtraProjectileFlying", v138);
                end;

                skillRunData.Visual.extraProjectileModels = v133;
            end;
        end;

        function u25.Client_ExitProjectileFlying(p144) -- Line: 1116
            -- upvalues: _retireExtraClone (ref)
            p144.skillRunData.Visual.projectileMotion = nil;
            local extraProjectileModels = p144.skillRunData.Visual.extraProjectileModels;

            if extraProjectileModels then
                p144:CleanupStateConns("ExtraProjectileFlying");

                for _, v in extraProjectileModels do
                    _retireExtraClone(v);
                end;

                p144.skillRunData.Visual.extraProjectileModels = nil;
            end;
        end;

        function u25.Server_EnterProjectileFlying(u145) -- Line: 1128
            -- upvalues: refreshTrackTargetOnEnterProjectileFlyingIfNeeded (copy), u20 (copy), PlayerAimSync (ref), ProjectileObjectTracking (ref), u22 (copy), resolveAuthoritativeExplosionHitPosition (copy), SkillEventConst (ref), ProjectileImpact (ref), u27 (copy), telegraph (copy), scheduleServerExplosionGroundLock (copy), u21 (copy), onProjectileStart (copy)
            refreshTrackTargetOnEnterProjectileFlyingIfNeeded(u145);

            if u20.refreshAimOnEnterProjectileFlying then
                PlayerAimSync.refreshAimSnapshot(u145);
            end;

            local v146 = u145.hitbox[1];

            if not v146 then
                return;
            end;

            u145.skillRunData.Logic.projectileFlyingStartTime = os.clock();
            local hitbox = v146.hitbox;
            local tracking = u20.tracking;
            local v147;

            if tracking then
                v147 = tracking.enabled == true;
            else
                v147 = tracking;
            end;

            local v148 = u145.skillInputData and u145.skillInputData.trackTargetId;
            local v149, v150;

            if v147 then
                local v151;
                v151, v149, v150 = ProjectileObjectTracking.resolveAtCast(v148, u145.character, tracking);
            else
                v150 = nil;
                v149 = nil;
            end;

            local v152 = v150 or v148;
            u145.skillRunData.Logic.hasExploded = false;
            local v153, v154;

            if v147 and v149 then
                v153 = u22.getProjectileStartCF(u145);
                u145.skillRunData.Logic.projectileLastPosition = v153.Position;
                u145.skillRunData.Logic.trackTargetId = v152;
                v154 = u22.runTrackedBezierMotion(hitbox, {
                    startCF = v153,
                    flySpeed = u20.flySpeed,
                    maxFlyTime = u20.maxFlyTime,
                    minTrackedMoveTime = u20.minTrackedMoveTime,
                    bezierSeed = u20.bezierSeed,
                    middlePointCount = tracking.middlePointCount,
                    initialEndPosition = v149,
                    curveRefreshInterval = tracking.curveRefreshInterval,

                    getTrackedEndPosition = function() -- Line: 432
                        -- upvalues: u145 (copy), ProjectileObjectTracking (ref), tracking (copy)
                        local v155 = u145.skillRunData and u145.skillRunData.Logic;

                        if v155 and v155.lockedExplosionGroundPos then
                            return v155.lockedExplosionGroundPos;
                        end;

                        local skillInputData = u145.skillInputData;
                        local v156 = v155 and v155.trackTargetId;

                        if v156 then
                            skillInputData = v156;
                        elseif skillInputData then
                            skillInputData = skillInputData.trackTargetId;
                        end;

                        return ProjectileObjectTracking.getLiveTrackedWorldPosition(skillInputData, u145.character, tracking);
                    end,

                    onStep = function(p157, p158) -- Line: 1168, Name: onStep
                        -- upvalues: u145 (copy)
                        u145.skillRunData.Logic.impactPosition = p157;
                    end
                }, function(p159) -- Line: 1171
                    -- upvalues: resolveAuthoritativeExplosionHitPosition (ref), u145 (copy), SkillEventConst (ref), ProjectileImpact (ref)
                    local v160 = resolveAuthoritativeExplosionHitPosition(u145, p159) or p159;
                    ProjectileImpact.resolveImpact(u145, {
                        type = SkillEventConst.HitType.Timeout,
                        position = v160,
                        source = ProjectileImpact.ImpactSource.Lifetime
                    });
                end);
                u145.skillRunData.Logic.impactPosition = v149;
            else
                local v161, v162, v163, v164, v165;
                v153, v161, v162, v163, v164, v165 = u22.computeTrajectory(u145);
                local u166 = v161;
                u145.skillRunData.Logic.projectileLastPosition = v153.Position;
                v154 = u22.runBezierMotion(hitbox, v162, v164, v165, function() -- Line: 1185
                    -- upvalues: resolveAuthoritativeExplosionHitPosition (ref), u145 (copy), u166 (ref), SkillEventConst (ref), ProjectileImpact (ref)
                    local v167 = resolveAuthoritativeExplosionHitPosition(u145, u166.Position) or u166.Position;
                    ProjectileImpact.resolveImpact(u145, {
                        type = SkillEventConst.HitType.Timeout,
                        position = v167,
                        source = ProjectileImpact.ImpactSource.Lifetime
                    });
                end);
                u145.skillRunData.Logic.impactPosition = u166.Position;
            end;

            if u27 and telegraph and telegraph.enabled == true then
                local lockAtStartupElapsed = telegraph.lockAtStartupElapsed;

                if type(lockAtStartupElapsed) ~= "number" or lockAtStartupElapsed < 0 then
                    lockAtStartupElapsed = nil;
                end;

                if lockAtStartupElapsed == nil then
                    local Logic = u145.skillRunData.Logic;
                    local maxFlyTime = u20.maxFlyTime;

                    if v147 and v149 then
                        local v168 = math.min((v153.Position - v149).Magnitude / u20.flySpeed, u20.maxFlyTime);
                        maxFlyTime = math.max(v168, u20.minTrackedMoveTime or 0.15);
                    end;

                    Logic.telegraphFlightSec = maxFlyTime;
                    scheduleServerExplosionGroundLock(u145);
                end;
            end;

            hitbox:PivotTo(v153);

            if u21 then
                v146:start();
            end;

            u145.skillRunData.Logic.projectileHitboxMotion = v154;
            u145:BindStateConn("ProjectileFlying", v154);

            if type(onProjectileStart) == "function" then
                onProjectileStart(u145);
            end;
        end;

        function u25.Server_ExitProjectileFlying(p169) -- Line: 1222
            p169.skillRunData.Logic.projectileHitboxMotion = nil;
            local v170 = p169.hitbox[1];

            if v170 and v170.isActive then
                v170:stop();
            end;

            if v170 and v170.hitbox then
                v170.hitbox.Transparency = 1;
            end;
        end;

        if u21 then
            u25.Server_UpdateProjectileObstacleCheck = u22.createObstacleCheck();
        end;

        function u25.onProjectileImpact(p171, p172) -- Line: 1235
            -- upvalues: onProjectileImpact (copy), SkillEventConst (ref), onProjectileTimeout (copy), u27 (copy)
            if type(onProjectileImpact) == "function" then
                onProjectileImpact(p171, p172);
            end;

            if p172.impactType == SkillEventConst.HitType.Timeout and type(onProjectileTimeout) == "function" then
                onProjectileTimeout(p171);
            end;

            if not u27 then
                p171:fireProjectileHitConfirmed(p172.hitPosition, p172.impactType, p172.targetId or p171.skillRunData.Logic and p171.skillRunData.Logic.impactTargetId);
            end;
        end;

        local function clientFallbackExplosionPosition(p173) -- Line: 1252
            local Logic = p173.skillRunData.Logic;

            if Logic and Logic.impactPosition then
                return Logic.impactPosition;
            end;

            local v174 = p173.skillInputData and p173.skillInputData.targetCF;

            if v174 and v174.Position then
                return v174.Position;
            end;

            local v175 = p173.character or p173.skillInputData and p173.skillInputData.character;

            if v175 then
                local v176 = v175:FindFirstChild("HumanoidRootPart") or v175.PrimaryPart;

                if v176 and v176:IsA("BasePart") then
                    return v176.Position;
                end;
            end;

            return nil;
        end;

        local function resolveClientExplosionGroundHitPosition(p177, p178) -- Line: 1278
            -- upvalues: u27 (copy), telegraph (copy), clientFallbackExplosionPosition (copy)
            local v179 = p177.skillRunData and p177.skillRunData.Logic;

            if u27 and telegraph and telegraph.enabled == true and v179 then
                if v179.lockedExplosionGroundPos then
                    return v179.lockedExplosionGroundPos;
                end;

                local telegraphFrozenGroundCF = v179.telegraphFrozenGroundCF;

                if telegraphFrozenGroundCF then
                    return telegraphFrozenGroundCF.Position;
                end;
            end;

            if p178 and p178.hitPosition then
                return p178.hitPosition;
            end;

            if v179 and v179.lockedExplosionGroundPos then
                return v179.lockedExplosionGroundPos;
            end;

            if v179 and v179.impactPosition then
                return v179.impactPosition;
            end;

            return clientFallbackExplosionPosition(p177);
        end;

        function u25.Client_EnterExploding(p180, p181) -- Line: 1302
            -- upvalues: activateExplosionTelegraph (copy), resolveClientExplosionGroundHitPosition (copy), u27 (copy), telegraph (copy), playExplosion (copy), u20 (copy)
            activateExplosionTelegraph(p180);
            local Logic = p180.skillRunData.Logic;
            local v182 = resolveClientExplosionGroundHitPosition(p180, p181);

            if not v182 then
                warn("[ProjectileSpellTemplate] Client_EnterExploding: 无 hitPosition，爆炸表现已跳过");

                return;
            end;

            local projectileModel = p180.skillRunData.Visual.projectileModel;

            if projectileModel and projectileModel.Parent then
                if u27 and telegraph and telegraph.enabled == true or not (Logic and Logic.trackTargetId) then
                    projectileModel:PivotTo(CFrame.new(v182));
                else
                    v182 = projectileModel:GetPivot().Position;
                end;
            end;

            playExplosion(p180, CFrame.new(v182 + Vector3.new(0, u20.explosionVisualYOffset or 0, 0)));
        end;

        function u25.Server_EnterExploding(p183, p184) -- Line: 1324
            -- upvalues: resolveAuthoritativeExplosionHitPosition (copy), FXUtil (ref), u23 (copy), SkillEventConst (ref)
            local v185 = p184 and p184.hitPosition or (p183.skillRunData.Logic and p183.skillRunData.Logic.impactPosition or p183:getCharacterPosition());
            local v186 = resolveAuthoritativeExplosionHitPosition(p183, v185) or v185;

            if not v186 then
                warn("[ProjectileSpellTemplate] Server_EnterExploding: 无 hitPosition，爆炸与同步已跳过");

                return;
            end;

            local u187 = p183.hitbox[2];

            if u187 and u187.hitbox then
                local hitbox = u187.hitbox;
                hitbox:PivotTo(CFrame.new(v186));
                u187:start();
                FXUtil.BasePart_Size_Tween(hitbox, u23.EXPLOSION_TWEEN_TIME, u23.EXPLOSION_HITBOX_SIZE, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 1338
                    -- upvalues: u187 (copy), hitbox (copy)
                    if u187.isActive then
                        u187:stop();
                        hitbox.Transparency = 1;
                    end;
                end);
            end;

            p183:fireProjectileHitConfirmed(v186, p183.skillRunData.Logic.impactType or SkillEventConst.HitType.Timeout, p183.skillRunData.Logic.impactTargetId);
        end;

        function u25.Server_EnterRecovery(p188) -- Line: 1354
            -- upvalues: onProjectileFinish (copy)
            p188:releaseControl();

            if type(onProjectileFinish) == "function" then
                onProjectileFinish(p188);
            end;
        end;

        function u25.Client_EnterRecovery(p189) -- Line: 1361
            -- upvalues: u20 (copy), u27 (copy), onProjectileFinish (copy)
            local skillRunData = p189.skillRunData;
            local v190 = skillRunData.material and skillRunData.material[u20.trailResName];

            if v190 then
                for _, descendant in pairs(v190:GetDescendants()) do
                    if descendant:IsA("Trail") then
                        descendant.Enabled = false;
                    elseif descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false;
                    end;
                end;
            end;

            if not u27 then
                local v191 = skillRunData.Visual and skillRunData.Visual.projectileModel;

                if v191 and v191.Parent then
                    v191.Parent = nil;
                end;
            end;

            if type(onProjectileFinish) == "function" then
                onProjectileFinish(p189);
            end;
        end;

        function u25.onProjectileHitServer(p192, p193, p194) -- Line: 1384
            -- upvalues: u27 (copy), HitPolicy (ref), ProjectileExplosionHitPick (ref), _getExtraProj (ref), u25 (copy), u21 (copy), SkillEventConst (ref), ProjectileImpact (ref)
            if not p193 then
                return;
            end;

            local v195;

            if u27 then
                v195 = p192.hitbox[2] or nil;
            else
                v195 = nil;
            end;

            if not p192.hitbox[1] then
                return;
            end;

            local skillRunData = p192.skillRunData;

            if not (skillRunData and skillRunData.State) then
                return;
            end;

            if not u27 or (not v195 or p193.hitboxIndex ~= 2) then
                if p193.hitboxIndex ~= 1 then
                    return;
                end;

                if not u21 then
                    return;
                end;

                local v196, v197 = next(p194);

                if not (v196 and v197) then
                    return;
                end;

                ProjectileImpact.resolveImpact(p192, {
                    type = SkillEventConst.HitType.Enemy,
                    position = v197.Position,
                    target = v196,
                    hitResult = p194,
                    source = ProjectileImpact.ImpactSource.Hitbox
                });

                return;
            end;

            local HitResolver = require(script.Parent.Parent.Parent.BaseSkill.HitResolver);
            local v198 = p193.hitPolicy or HitPolicy.default();

            if v198.hitOncePerActivation and (p193._activationHitCount or 0) >= 1 then
                return;
            end;

            local v199 = {};

            if v198.hitOncePerActivation then
                local v200, v201 = ProjectileExplosionHitPick.pickPrimaryTarget(p194, p193, p192);

                if v200 and v201 then
                    table.insert(v199, {
                        model = v200,
                        part = v201
                    });
                end;
            else
                for i, v in p194 do
                    table.insert(v199, {
                        model = i,
                        part = v
                    });
                end;
            end;

            local v202 = 0;

            for _, v in v199 do
                v202 = v202 + 1;
                local v203 = {
                    damageProfileId = "ExplosionMain",
                    hitboxIndex = 2,
                    skillName = p192.skillName,
                    skillCastId = p192.skillCastId,
                    baseSkillInstanceId = p192.baseSkillInstanceId,
                    activeBaseSkillIndex = p192.activeBaseSkillIndex,
                    combatSeed = p192.combatSeed,
                    hitIndex = v202,
                    sourceState = p192.GetCurrentState and (p192:GetCurrentState() or "Exploding") or "Exploding"
                };
                HitResolver.applyHit(p192, p193, v.part, v.model, v203);
            end;

            local v204, v205 = _getExtraProj(p192.character);

            if v204 > 0 and (v205 > 0 and #v199 > 0) then
                local ExplosionExtra = u25.DamageProfiles.ExplosionExtra;
                local damageRate = ExplosionExtra.damageRate;
                ExplosionExtra.damageRate = u25.DamageProfiles.ExplosionMain.damageRate * v205;

                for _ = 1, v204 do
                    for _, v in v199 do
                        v202 = v202 + 1;
                        local v206 = {
                            damageProfileId = "ExplosionExtra",
                            hitboxIndex = 2,
                            skillName = p192.skillName,
                            skillCastId = p192.skillCastId,
                            baseSkillInstanceId = p192.baseSkillInstanceId,
                            activeBaseSkillIndex = p192.activeBaseSkillIndex,
                            combatSeed = p192.combatSeed,
                            hitIndex = v202,
                            sourceState = p192.GetCurrentState and (p192:GetCurrentState() or "Exploding") or "Exploding"
                        };
                        HitResolver.applyHit(p192, p193, v.part, v.model, v206);
                    end;
                end;

                ExplosionExtra.damageRate = damageRate;
            end;
        end;

        function u25.onServerEvent(p207, p208) -- Line: 1473
            -- upvalues: SkillEventConst (ref), u21 (copy)
            if p208.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
                return;
            end;

            local skillRunData = p207.skillRunData;

            if not skillRunData then
                return;
            end;

            local hitPosition = p208.hitPosition;

            if not hitPosition then
                return;
            end;

            if not u21 and (p207.GetCurrentState and (p207:GetCurrentState() == "ProjectileFlying" and (p208.hitType == SkillEventConst.HitType.Enemy or p208.hitType == SkillEventConst.HitType.Obstacle))) then
                return;
            end;

            local v209 = p208.hitType == SkillEventConst.HitType.Obstacle and SkillEventConst.ObstacleHit or (p208.hitType == SkillEventConst.HitType.Timeout and SkillEventConst.Timeout or SkillEventConst.EnemyHit);

            if p207.GetCurrentState and p207:GetCurrentState() == "ProjectileFlying" then
                p207:TryTransition(v209, {
                    hitPosition = hitPosition,
                    hitType = p208.hitType,
                    targetId = p208.targetId
                });

                return;
            end;

            skillRunData.Visual.pendingProjectileHitEvent = p208;
        end;

        u25.SoundList = { u20.expSound, u20.flySound, u20.releaseSound };
        u25.AnimateList = { u20.animationName };
        u25.ResNameList = {
            u20.startupResName,
            u20.explosionResName,
            u20.explosionLightResName,
            u20.trailResName,
            u20.projectileResName
        };
        local v210 = u21 and {
            stopOnFirstEnemy = true,
            stopOnObstacle = true,
            hitOncePerTarget = true
        } or {
            stopOnFirstEnemy = false,
            stopOnObstacle = false,
            hitOncePerTarget = true
        };
        u25.hitboxConfig = mergeHitboxConfig(u27 and {
            {
                HitboxIndex = 1,
                PartName = "通用球",
                CollisionGroup = "Player",
                HitPresentationProfile = u20.hitPresentationProfile,
                HitPolicy = v210
            },
            {
                HitboxIndex = 2,
                PartName = "通用球",
                CollisionGroup = "Player",
                PhysicsEffectName = "通用受击物理效果",
                CameraShakeProfile = "轻攻击震",
                HitPresentationProfile = u20.hitPresentationProfile,
                HitPolicy = {
                    hitOncePerTarget = true
                }
            }
        } or {
            {
                HitboxIndex = 1,
                PartName = "通用球",
                CollisionGroup = "Player",
                HitPresentationProfile = u20.hitPresentationProfile,
                HitPolicy = v210
            }
        }, u20.hitboxConfig);
        local SkillDamageRateFromCfg = require(script.Parent.Parent.Parent.BaseSkill.SkillDamageRateFromCfg);
        local v211, v212;

        if type(u20.skillConfSkillId) == "number" and u20.skillConfSkillId > 0 then
            v211 = SkillDamageRateFromCfg.get(u20.skillConfSkillId, 1);
            v212 = SkillDamageRateFromCfg.get(u20.skillConfSkillId, 2);
        else
            v211 = u20.hitbox1DamageRate or 0;
            v212 = u20.hitbox2DamageRate or 1.2;
        end;

        u25.DamageProfiles = {
            ProjectileDirect = {
                canCritical = true,
                showDamageText = true,
                randomOffset = 0.05,
                damageRate = v211,
                elementType = u20.skillElementType,
                damageTags = { "Magic", "Projectile" }
            },
            ExplosionMain = {
                canCritical = true,
                showDamageText = true,
                randomOffset = 0.05,
                damageRate = v212,
                elementType = u20.skillElementType,
                damageTags = { "Magic", "Projectile", "Explosion" }
            },
            KnockbackOnly = {
                baseDamage = 0,
                canCritical = false,
                showDamageText = false,
                elementType = u20.skillElementType,
                damageTags = { "Knockback" }
            },
            DebuffApply = {
                baseDamage = 0,
                canCritical = false,
                showDamageText = false,
                elementType = u20.skillElementType,
                damageTags = { "Debuff", "Magic" }
            },
            ExplosionExtra = {
                damageRate = 0,
                canCritical = true,
                showDamageText = true,
                randomOffset = 0.05,
                elementType = u20.skillElementType,
                damageTags = { "Magic", "Projectile", "Explosion", "ExtraProjectile" }
            }
        };
        u25.Action = {
            {
                action = "LookAt",
                startTime = 0,
                speedType = "RELEASE_SKILL_STATE_HALF",
                overTime = u20.actionOverTime
            },
            {
                action = "Animation",
                startTime = 0,
                overTime = u20.actionOverTime,
                animationName = u20.animationName,
                animationSpeed = u20.animationSpeed,
                animationPriority = Enum.AnimationPriority.Action4,
                animationFadeTime = u20.animationFadeTime
            }
        };

        return u25;
    end
};