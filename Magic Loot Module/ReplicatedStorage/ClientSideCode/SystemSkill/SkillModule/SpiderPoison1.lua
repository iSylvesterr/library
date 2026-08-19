-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);
local Hitbox = require(script.Parent.Parent.BaseSkill.Hitbox);
local HitPolicy = require(script.Parent.Parent.BaseSkill.HitPolicy);
local SkillHitPresentationProfile = require(game.ReplicatedFirst.AllSideCode.ToolSystem.SkillHitPresentation.SkillHitPresentationProfile);
local SkillDamageRateFromCfg = require(script.Parent.Parent.BaseSkill.SkillDamageRateFromCfg);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local MathMgr = UtilsSystem.MathMgr;
local SoundModule = UtilsSystem.SoundModule;
local v1 = {};
local u2 = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 3,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
local u3 = {
    {
        angleOffsetDeg = -30,
        flightSec = 2,
        trackDurationSec = 1.7,
        launchSoundName = "音效-技能-毒素气泡-发射",
        flightSoundName = "音效-技能-毒素气泡-飞行",
        explosionSoundName = "音效-技能-毒素气泡-爆炸",
        targetOffset = CFrame.new(1, 0, 0),
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.In
    },
    {
        angleOffsetDeg = 0,
        flightSec = 2.5,
        trackDurationSec = 2.2,
        launchSoundName = "音效-技能-毒素气泡-发射",
        flightSoundName = "音效-技能-毒素气泡-飞行",
        explosionSoundName = "音效-技能-毒素气泡-爆炸",
        targetOffset = CFrame.new(0, 0, 0),
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.In
    },
    {
        angleOffsetDeg = 30,
        flightSec = 3,
        trackDurationSec = 2.7,
        launchSoundName = "音效-技能-毒素气泡-发射",
        flightSoundName = "音效-技能-毒素气泡-飞行",
        explosionSoundName = "音效-技能-毒素气泡-爆炸",
        targetOffset = CFrame.new(-1, 0, 0),
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.In
    }
};
local u4 = { "毒素气泡", "毒素爆炸" };
local u5 = {
    clientMotion = "蜘蛛猛毒客户端弹道",
    serverMotion = "蜘蛛猛毒服务端弹道"
};
local u6 = {
    canCritical = false,
    showDamageText = true,
    randomOffset = 0.05,
    elementType = ElementTp.Poison,
    damageTags = { "Magic", "Projectile", "Explosion", "Poison" }
};

local function _maxFlightSec() -- Line: 172
    -- upvalues: u3 (copy)
    local v7 = math.max(0, u3[1].flightSec);
    local v8 = math.max(v7, u3[2].flightSec);

    return math.max(v8, u3[3].flightSec);
end;

local function _resKey(p9, p10) -- Line: 180
    if p10 == 1 then
        return p9;
    end;

    return p9 .. p10;
end;

local function _getBubbleProfile(p11) -- Line: 187
    -- upvalues: u3 (copy)
    return u3[p11] or u3[1];
end;

local function _resolveLaunchSoundName(p12) -- Line: 191
    return p12.launchSoundName or "音效-技能-毒素气泡-发射";
end;

local function _resolveExplosionSoundName(p13) -- Line: 195
    return p13.explosionSoundName or "音效-技能-毒素气泡-爆炸";
end;

local function _resolveFlightSoundName(p14) -- Line: 199
    return p14.flightSoundName or "音效-技能-毒素气泡-飞行";
end;

local function _playConfiguredSound3D(p15, p16) -- Line: 203
    -- upvalues: SkillCommon (copy)
    if p15 and p15 ~= "" then
        SkillCommon.playSoundLocal3D(p15, p16);
    end;
end;

local function _makeBubbleFlightSoundTag(p17, p18) -- Line: 209
    -- upvalues: SkillCommon (copy)
    local v19 = SkillCommon.resolveSkillCastSoundTag(p17);

    if v19 then
        return v19 .. "_bubbleFly_" .. tostring(p18);
    end;

    return nil;
end;

local function _playBubbleFlightSound(p20, u21, p22, u23, u24) -- Line: 217
    -- upvalues: SkillCommon (copy), SoundModule (copy)
    if not u21 or u21 == "" then
        return;
    end;

    if u23 then
        u23 = SkillCommon.resolveModelAttachPart(u23);
    end;

    if u23 then
        u24 = u23.Position;
    end;

    local function buildPayload(p25) -- Line: 231
        -- upvalues: u24 (copy), u21 (copy), u23 (copy)
        if not u24 then
            return nil;
        end;

        local v26 = {
            Is2D = false,
            Looped = true,
            SoundName = u21,
            PlayPosition = u24
        };

        if u23 then
            v26.AttachPart = u23;
        end;

        if p25 then
            v26.SoundTag = p25;
        end;

        return v26;
    end;

    if p22 then
        local v27;

        if u24 then
            v27 = {
                Is2D = false,
                Looped = true,
                SoundName = u21,
                PlayPosition = u24
            };

            if u23 then
                v27.AttachPart = u23;
            end;

            if p22 then
                v27.SoundTag = p22;
            end;
        else
            v27 = nil;
        end;

        if v27 then
            SoundModule:PlaySoundLocal(v27);
        end;

        return;
    end;

    local v28;

    if u24 then
        v28 = {
            Is2D = false,
            Looped = true,
            SoundName = u21,
            PlayPosition = u24
        };

        if u23 then
            v28.AttachPart = u23;
        end;
    else
        v28 = nil;
    end;

    if v28 then
        SoundModule:PlaySoundLocal(v28);
    end;
end;

local function _stopBubbleFlightSound(p29) -- Line: 264
    -- upvalues: SoundModule (copy)
    if not p29 or p29.flightSoundStopped then
        return;
    end;

    local flightSoundName = p29.flightSoundName;
    local flightSoundTag = p29.flightSoundTag;

    if not flightSoundName or (flightSoundName == "" or not flightSoundTag) then
        return;
    end;

    SoundModule:StopSoundLocal({
        FadeTime = 0.15,
        SoundName = flightSoundName,
        SoundTag = flightSoundTag
    });
    p29.flightSoundStopped = true;
end;

local function _stopAllClientFlightSounds(p30) -- Line: 281
    -- upvalues: _stopBubbleFlightSound (copy)
    local skillRunData = p30.skillRunData;
    local v31 = skillRunData and skillRunData.SpiderPoisonClient and skillRunData.SpiderPoisonClient.projectiles;

    if not v31 then
        return;
    end;

    for _, v in v31 do
        _stopBubbleFlightSound(v);
    end;
end;

local function _explosionDamageProfileId(p32) -- Line: 323
    local v33 = math.floor(p32);

    return "ExplosionBubble" .. math.clamp(v33, 1, 3);
end;

local function _cloneBubbleMaterials(p34) -- Line: 327
    -- upvalues: u4 (copy)
    for _, v in u4 do
        local v35 = p34.material[v];

        if v35 then
            for i = 2, 3 do
                local v36;

                if i == 1 then
                    v36 = v;
                else
                    v36 = v .. i;
                end;

                if not p34.material[v36] then
                    p34.material[v36] = v35:Clone();
                end;
            end;
        end;
    end;
end;

local function _resolveLiveStrikePos(p37, p38) -- Line: 349
    -- upvalues: SkillCommon (copy)
    if p37 then
        p37 = SkillCommon.resolveTrackTargetHrp(p37);
    end;

    if p37 and p37.Parent then
        return p37.Position;
    end;

    return p38;
end;

local function _resolveHeadSpawnCF(p39, p40) -- Line: 364
    local v41 = p39:FindFirstChild("头");

    if v41 and v41:IsA("BasePart") then
        local CFrame2 = v41.CFrame;
        local LookVector = CFrame2.LookVector;
        local v42 = CFrame2.Position + LookVector * 3 * p40;

        return CFrame.lookAt(v42, v42 + LookVector, Vector3.new(0, 1, 0));
    end;

    local HumanoidRootPart = p39:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local CFrame2 = HumanoidRootPart.CFrame;
    local LookVector = CFrame2.LookVector;
    local v43 = CFrame2.Position + LookVector * 3 * p40;

    return CFrame.lookAt(v43, v43 + LookVector, Vector3.new(0, 1, 0));
end;

local function _sameRun(p44, p45) -- Line: 384
    return p44.runGeneration == p45;
end;

local function _hasActiveClientProjectiles(p46) -- Line: 388
    local v47 = p46.SpiderPoisonClient and p46.SpiderPoisonClient.projectiles;

    if not v47 then
        return false;
    end;

    for _, v in v47 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _hasActiveServerProjectiles(p48) -- Line: 401
    local v49 = p48.SpiderPoisonServer and p48.SpiderPoisonServer.projectiles;

    if not v49 then
        return false;
    end;

    for _, v in v49 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _cleanupRunMotion(p50, p51) -- Line: 417
    -- upvalues: SkillCommon (copy)
    local skillRunData = p50.skillRunData;

    if not (skillRunData and skillRunData.runEvent) then
        return;
    end;

    local v52 = {};

    if skillRunData.runEvent["蜘蛛猛毒客户端弹道"] then
        if p51 then
            table.insert(v52, "蜘蛛猛毒客户端弹道");
        else
            local v53 = skillRunData.SpiderPoisonClient and skillRunData.SpiderPoisonClient.projectiles;
            local v54;

            if v53 then
                v54 = false;

                for _, v in v53 do
                    if v and not v.impacted then
                        v54 = true;
                        break;
                    end;
                end;
            else
                v54 = false;
            end;

            if not v54 then
                table.insert(v52, "蜘蛛猛毒客户端弹道");
            end;
        end;
    end;

    if skillRunData.runEvent["蜘蛛猛毒服务端弹道"] then
        if p51 then
            table.insert(v52, "蜘蛛猛毒服务端弹道");
        else
            local v55 = skillRunData.SpiderPoisonServer and skillRunData.SpiderPoisonServer.projectiles;
            local v56;

            if v55 then
                v56 = false;

                for _, v in v55 do
                    if v and not v.impacted then
                        v56 = true;
                        break;
                    end;
                end;
            else
                v56 = false;
            end;

            if not v56 then
                table.insert(v52, "蜘蛛猛毒服务端弹道");
            end;
        end;
    end;

    if #v52 > 0 then
        SkillCommon.disconnectRunEventKeys(skillRunData, v52);
    end;
end;

local function _shouldKeepClientProjectileMotion(p57, p58, p59) -- Line: 438
    if p57.runGeneration ~= p58 then
        return false;
    end;

    if p57:isRunningFlow() then
        return true;
    end;

    local v60 = p59.SpiderPoisonClient and p59.SpiderPoisonClient.projectiles;

    if not v60 then
        return false;
    end;

    for _, v in v60 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _shouldKeepServerProjectileMotion(p61, p62, p63) -- Line: 448
    if p61.runGeneration ~= p62 then
        return false;
    end;

    if p61:isRunningFlow() then
        return true;
    end;

    local v64 = p63.SpiderPoisonServer and p63.SpiderPoisonServer.projectiles;

    if not v64 then
        return false;
    end;

    for _, v in v64 do
        if v and not v.impacted then
            return true;
        end;
    end;

    return false;
end;

local function _strikePosAfterRefresh(p65) -- Line: 458
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p65);
    local skillInputData = p65.skillInputData;

    if skillInputData then
        return SkillCommon.resolveStrikeWorldPos(skillInputData);
    end;

    return p65:getTargetCF().Position;
end;

local function _flatDirToTarget(p66, p67) -- Line: 467
    local v68 = Vector3.new(p67.X - p66.X, 0, p67.Z - p66.Z);

    return v68.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v68.Unit;
end;

local function _applyTargetOffset(p69, p70, p71, p72) -- Line: 484
    local v73 = p71.Position * p72;

    if v73.Magnitude < 0.0001 then
        return p70;
    end;

    local v74 = Vector3.new(p70.X - p69.X, 0, p70.Z - p69.Z);

    return (CFrame.lookAt(p70, p70 + (v74.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v74.Unit)) * CFrame.new(v73)).Position;
end;

local function _resolveBubbleSnapEnd(p75, p76, p77, p78) -- Line: 494
    -- upvalues: u3 (copy)
    local v79 = ((u3[p77] or u3[1]).targetOffset or CFrame.new()).Position * p78;

    if v79.Magnitude < 0.0001 then
        return p76;
    end;

    local v80 = Vector3.new(p76.X - p75.X, 0, p76.Z - p75.Z);

    return (CFrame.lookAt(p76, p76 + (v80.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v80.Unit)) * CFrame.new(v79)).Position;
end;

local function _resolveLiveEndForProjectile(p81, p82) -- Line: 500
    -- upvalues: SkillCommon (copy)
    if p82.frozenEnd then
        return p82.frozenEnd;
    end;

    local v83 = p82.baseSnapEnd0 or p82.snapEnd0;

    if p81 then
        if p81 then
            p81 = SkillCommon.resolveTrackTargetHrp(p81);
        end;

        if p81 and p81.Parent then
            v83 = p81.Position;
        end;
    end;

    local v84 = p82.targetOffsetCF or CFrame.new();
    local bubbleStart = p82.bubbleStart;
    local v85 = v84.Position * (p82.targetOffsetScale or 1);

    if v85.Magnitude >= 0.0001 then
        local v86 = Vector3.new(v83.X - bubbleStart.X, 0, v83.Z - bubbleStart.Z);
        v83 = (CFrame.lookAt(v83, v83 + (v86.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v86.Unit)) * CFrame.new(v85)).Position;
    end;

    if (p82.trackDurationSec or 1.5) < p82.moveT then
        p82.frozenEnd = v83;
    end;

    return v83;
end;

local function _evaluateCubicBezier(p87, p88, p89, p90, p91) -- Line: 523
    local v92 = math.clamp(p91, 0, 1);
    local v93 = 1 - v92;

    return v93 * v93 * v93 * p87 + v93 * 3 * v93 * v92 * p88 + v93 * 3 * v92 * v92 * p89 + v92 * v92 * v92 * p90;
end;

local function _cubicBezierTangent(p94, p95, p96, p97, p98) -- Line: 529
    local v99 = math.clamp(p98 - 0.002, 0, 1);
    local v100 = math.clamp(p98 + 0.002, 0, 1);

    if v100 - v99 < 1e-6 then
        local v101 = p97 - p94;

        return v101.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v101.Unit;
    end;

    local v102 = math.clamp(v100, 0, 1);
    local v103 = 1 - v102;
    local v104 = math.clamp(v99, 0, 1);
    local v105 = 1 - v104;
    local v106 = v103 * v103 * v103 * p94 + v103 * 3 * v103 * v102 * p95 + v103 * 3 * v102 * v102 * p96 + v102 * v102 * v102 * p97 - (v105 * v105 * v105 * p94 + v105 * 3 * v105 * v104 * p95 + v105 * 3 * v104 * v104 * p96 + v104 * v104 * v104 * p97);

    return v106.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v106.Unit;
end;

local function _angleOffsetFlatDir(p107, p108) -- Line: 540
    if math.abs(p108) < 0.0001 then
        return p107;
    end;

    local v109 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p108))):VectorToWorldSpace(p107);
    local v110 = Vector3.new(v109.X, 0, v109.Z);

    if v110.Magnitude > 0.05 then
        return v110.Unit;
    end;

    return p107;
end;

local function _resolveInitialTangent(p111, p112, p113) -- Line: 552
    local v114 = p112 - p111;

    if v114.Magnitude < 0.0001 then
        local v115 = Vector3.new(p112.X - p111.X, 0, p112.Z - p111.Z);

        return v115.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v115.Unit;
    end;

    if p113 and math.abs(p113) > 0.0001 then
        local v116 = Vector3.new(p112.X - p111.X, 0, p112.Z - p111.Z);
        local v117 = v116.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v116.Unit;

        if math.abs(p113) >= 0.0001 then
            local v118 = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p113))):VectorToWorldSpace(v117);
            local v119 = Vector3.new(v118.X, 0, v118.Z);

            if v119.Magnitude > 0.05 then
                v117 = v119.Unit;
            end;
        end;

        local Magnitude = Vector3.new(v114.X, 0, v114.Z).Magnitude;
        local v120 = v117 + Vector3.new(0, Magnitude <= 0.0001 and 0 or v114.Y / Magnitude, 0);

        if v120.Magnitude > 0.0001 then
            return v120.Unit;
        end;
    end;

    return v114.Unit;
end;

local function _ensureBezierState(p121, p122) -- Line: 569
    if p121.bezierP0 then
        return;
    end;

    local bubbleStart = p121.bubbleStart;
    local v123 = p122 - bubbleStart;
    local initialTangent = p121.initialTangent;

    if not initialTangent or initialTangent.Magnitude < 0.0001 then
        initialTangent = v123.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v123.Unit;
    end;

    local v124 = math.max(v123.Magnitude * 0.6666666666666666, 0.001);
    p121.bezierP0 = bubbleStart;
    p121.bezierP1 = bubbleStart + initialTangent * v124;
    p121.bezierArmLen = v124;
end;

local function _sampleProjectileMotion(p125, p126, p127) -- Line: 595
    -- upvalues: TweenService (copy), _cubicBezierTangent (copy)
    if not p125.bezierP0 then
        local bubbleStart = p125.bubbleStart;
        local v128 = p127 - bubbleStart;
        local initialTangent = p125.initialTangent;

        if not initialTangent or initialTangent.Magnitude < 0.0001 then
            initialTangent = v128.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v128.Unit;
        end;

        local v129 = math.max(v128.Magnitude * 0.6666666666666666, 0.001);
        p125.bezierP0 = bubbleStart;
        p125.bezierP1 = bubbleStart + initialTangent * v129;
        p125.bezierArmLen = v129;
    end;

    local bezierP0 = p125.bezierP0;
    local bezierP1 = p125.bezierP1;
    local v130 = p127 - bezierP0;
    local v131;

    if v130.Magnitude > 0.0001 then
        v131 = v130.Unit;
    else
        v131 = (bezierP1 - bezierP0).Unit;
    end;

    local v132 = p127 - (v131.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v131) * p125.bezierArmLen;
    local v133 = TweenService:GetValue(p126, p125.easingStyle, p125.easingDirection);
    local v134 = math.clamp(v133, 0, 1);
    local v135 = 1 - v134;

    return v135 * v135 * v135 * bezierP0 + v135 * 3 * v135 * v134 * bezierP1 + v135 * 3 * v134 * v134 * v132 + v134 * v134 * v134 * p127, _cubicBezierTangent(bezierP0, bezierP1, v132, p127, v133);
end;

local function _resolveImpactWorldPos(p136, p137) -- Line: 618
    -- upvalues: _resolveLiveEndForProjectile (copy), _sampleProjectileMotion (copy)
    local v138 = _resolveLiveEndForProjectile(p137, p136);

    return select(1, _sampleProjectileMotion(p136, 1, v138));
end;

local function _pivotExplosionCenterToWorldPos(p139, p140) -- Line: 626
    local v141, _ = p139:GetBoundingBox();
    local v142 = v141.Position - p139:GetPivot().Position;
    local v143 = p139:GetPivot() - p139:GetPivot().Position;
    p139:PivotTo(CFrame.new(p140 - v142) * v143);
end;

local function _buildBubbleTrajectory(p144, p145, p146, p147) -- Line: 633
    -- upvalues: u3 (copy)
    local v148 = u3[p147] or u3[1];

    return {
        flightSec = v148.flightSec,
        trackDurationSec = v148.trackDurationSec or 1.5,
        easingStyle = v148.easingStyle,
        easingDirection = v148.easingDirection
    };
end;

local function _ensureClientProjectileList(p149) -- Line: 643
    p149.SpiderPoisonClient = p149.SpiderPoisonClient or {};
    p149.SpiderPoisonClient.projectiles = p149.SpiderPoisonClient.projectiles or {};

    return p149.SpiderPoisonClient.projectiles;
end;

local function _ensureServerProjectileList(p150) -- Line: 649
    p150.SpiderPoisonServer = p150.SpiderPoisonServer or {};
    p150.SpiderPoisonServer.projectiles = p150.SpiderPoisonServer.projectiles or {};

    return p150.SpiderPoisonServer.projectiles;
end;

local function _enableBubbleVfx(p151) -- Line: 655
    -- upvalues: FXUtil (copy)
    FXUtil.Emit_Particles_GetDescendants(p151, false);
    FXUtil.SetEnableNameVfx(p151, true);
    FXUtil.SetEmittersTrailsBeamsEnabled(p151, true);
end;

local function _playBubbleAppearFx(p152, p153, p154) -- Line: 661
    -- upvalues: VisibleMgr (copy), FXUtil (copy), SkillCommon (copy)
    local v155 = p152.material and p152.material["毒素气泡出现"];

    if not v155 then
        return;
    end;

    local v156 = v155:Clone();

    if v156:IsA("Model") then
        VisibleMgr.UnQueryAll(v156);
        v156:ScaleTo(p154);
        v156:PivotTo(p153 * (v156:GetPivot() - v156:GetPivot().Position));
    elseif v156:IsA("BasePart") then
        v156.CFrame = p153;
    end;

    v156.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v156, true);
    SkillCommon.appendRunSpawnList(p152, "SpiderPoisonSpawns", v156);
end;

local function _disableBubbleVfx(p157) -- Line: 681
    -- upvalues: FXUtil (copy)
    FXUtil.Stop_All_Emit(p157);
    FXUtil.SetEmittersTrailsBeamsEnabled(p157, false);
    FXUtil.OffEnableVfx(p157);
end;

local function _removeFromSpawnList(p158, p159) -- Line: 687
    local SpiderPoisonSpawns = p158.SpiderPoisonSpawns;

    if not SpiderPoisonSpawns then
        return;
    end;

    for i = #SpiderPoisonSpawns, 1, -1 do
        if SpiderPoisonSpawns[i] == p159 then
            table.remove(SpiderPoisonSpawns, i);
        end;
    end;
end;

local function _clearBigBubbleAttachmentParticles(p160) -- Line: 699
    local v161 = nil;

    if p160:IsA("Model") then
        p160 = p160.PrimaryPart;
    elseif not p160:IsA("BasePart") then
        p160 = v161;
    end;

    if not p160 then
        return;
    end;

    local v162 = p160:FindFirstChild("大泡");

    if not (v162 and v162:IsA("Attachment")) then
        return;
    end;

    local function clearPe(p163) -- Line: 715
        p163.Enabled = false;
        p163:Clear();
    end;

    for _, child in v162:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false;
            child:Clear();
        end;
    end;

    for _, descendant in v162:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
            descendant:Clear();
        end;
    end;
end;

local function _scheduleBubbleRecycle(u164, p165) -- Line: 732
    -- upvalues: _removeFromSpawnList (copy)
    if not (u164 and u164.Parent) then
        return;
    end;

    _removeFromSpawnList(p165, u164);
    task.delay(2, function() -- Line: 737
        -- upvalues: u164 (copy)
        if u164.Parent then
            u164:Destroy();
        end;
    end);
end;

local function _onBubbleExplodedVisual(u166, p167) -- Line: 747
    -- upvalues: FXUtil (copy), _clearBigBubbleAttachmentParticles (copy), _removeFromSpawnList (copy)
    if not (u166 and u166.Parent) then
        return;
    end;

    if u166:GetAttribute("PoisonBubbleExplodeHandled") then
        return;
    end;

    u166:SetAttribute("PoisonBubbleExplodeHandled", true);
    FXUtil.Stop_All_Emit(u166);
    FXUtil.SetEmittersTrailsBeamsEnabled(u166, false);
    FXUtil.OffEnableVfx(u166);
    _clearBigBubbleAttachmentParticles(u166);

    if u166 then
        if not u166.Parent then
            return;
        end;

        _removeFromSpawnList(p167, u166);
        task.delay(2, function() -- Line: 737
            -- upvalues: u166 (copy)
            if u166.Parent then
                u166:Destroy();
            end;
        end);
    end;
end;

local function _playClientExplosion(p168, p169, p170, p171) -- Line: 761
    -- upvalues: _pivotExplosionCenterToWorldPos (copy), FXUtil (copy), u3 (copy), SkillCommon (copy)
    local v172 = p168.material and p168.material[p169 == 1 and "毒素爆炸" or "毒素爆炸" .. p169];

    if not v172 then
        return;
    end;

    local v173 = v172:Clone();

    if v173:IsA("Model") then
        v173:ScaleTo(p171);
        _pivotExplosionCenterToWorldPos(v173, p170);
    elseif v173:IsA("BasePart") then
        v173.CFrame = CFrame.new(p170);
    end;

    v173.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v173, true);
    local v174 = (u3[p169] or u3[1]).explosionSoundName or "音效-技能-毒素气泡-爆炸";

    if v174 and v174 ~= "" then
        SkillCommon.playSoundLocal3D(v174, p170);
    end;

    SkillCommon.appendRunSpawnList(p168, "SpiderPoisonSpawns", v173);
end;

local function _doClientBubbleArrive(p175, p176, p177) -- Line: 782
    -- upvalues: _stopBubbleFlightSound (copy), SkillCommon (copy), _onBubbleExplodedVisual (copy), _playClientExplosion (copy)
    if p176.impacted then
        return;
    end;

    p176.impacted = true;
    _stopBubbleFlightSound(p176);
    local skillRunData = p175.skillRunData;
    local _, v178 = SkillCommon.scaleDualFromData(p175, SkillCommon.bandScaleOptsFromSkillData(p175));

    if p176.bubble and p176.bubble.Parent then
        p176.bubble:PivotTo(CFrame.new(p177) * p176.bubble:GetPivot().Rotation);
        _onBubbleExplodedVisual(p176.bubble, skillRunData);
    end;

    _playClientExplosion(skillRunData, p176.bubbleIndex, p177, v178);
end;

local function _allServerProjectilesImpacted(p179) -- Line: 801
    local v180 = p179.SpiderPoisonServer and p179.SpiderPoisonServer.projectiles;

    if not v180 then
        return true;
    end;

    for _, v in v180 do
        if v and not v.impacted then
            return false;
        end;
    end;

    return true;
end;

local function _tryFinishProjectileFlying(u181) -- Line: 814
    -- upvalues: SkillEventConst (copy)
    local skillRunData = u181.skillRunData;

    if skillRunData then
        local v182 = skillRunData.SpiderPoisonServer and skillRunData.SpiderPoisonServer.projectiles;
        local v183;

        if v182 then
            v183 = true;

            for _, v in v182 do
                if v and not v.impacted then
                    v183 = false;
                    break;
                end;
            end;
        else
            v183 = true;
        end;

        if v183 then
            skillRunData.Logic = skillRunData.Logic or {};

            if skillRunData.Logic.explodingTransitionScheduled then
                return;
            end;

            skillRunData.Logic.explodingTransitionScheduled = true;
            local runGeneration = u181.runGeneration;
            task.delay(0.14, function() -- Line: 827
                -- upvalues: u181 (copy), runGeneration (copy), SkillEventConst (ref)
                if not u181.skillRunData or u181.runGeneration ~= runGeneration then
                    return;
                end;

                local skillRunData2 = u181.skillRunData;
                local v184 = skillRunData2.SpiderPoisonServer and skillRunData2.SpiderPoisonServer.projectiles;
                local v185;

                if v184 then
                    v185 = true;

                    for _, v in v184 do
                        if v and not v.impacted then
                            v185 = false;
                            break;
                        end;
                    end;
                else
                    v185 = true;
                end;

                if not v185 then
                    return;
                end;

                if u181.GetCurrentState and u181:GetCurrentState() == "ProjectileFlying" then
                    u181:TryTransition(SkillEventConst.StateTimeout);
                end;
            end);
        end;
    end;
end;

local function _applyHitboxVisibility(p186, p187) -- Line: 840
    if not p186 then
        return;
    end;

    p186.Transparency = 1;
end;

local function _resolveImpactScale(p188, p189) -- Line: 851
    -- upvalues: SkillCommon (copy)
    if p189 then
        p189 = p189.SpiderPoisonServer;
    end;

    if p189 and (p189.impactScale and p189.impactScale > 0) then
        return p189.impactScale;
    end;

    local _, v190 = SkillCommon.scaleDualFromData(p188, SkillCommon.bandScaleOptsFromSkillData(p188));

    return v190 or 1;
end;

local function _createLingeringHitboxes(p191, p192) -- Line: 863
    -- upvalues: u2 (copy), SkillHitPresentationProfile (copy), Hitbox (copy), HitPolicy (copy)
    local SpiderPoisonServer = p192.SpiderPoisonServer;

    if not SpiderPoisonServer or SpiderPoisonServer.lingeringHitboxes then
        return;
    end;

    local skillInputData = p191.skillInputData;

    if not skillInputData then
        return;
    end;

    local v193 = {};

    for _, v in u2 do
        local HitboxIndex = v.HitboxIndex;
        local v194 = SkillHitPresentationProfile.resolveHitboxEntry(v);
        v193[HitboxIndex] = Hitbox.new({
            hitboxOwnerType = skillInputData.characterType,
            hitboxOwnerId = skillInputData.characterId,
            hitboxIndex = HitboxIndex,
            PartName = v.PartName,
            EffectName = v194.effectName,
            SoundName = v194.soundKey,
            SuppressHitPresentation = v194.skipPresentation == true,
            skillName = p191.skillName,
            combatSeed = p191.combatSeed or skillInputData.combatSeed,
            hitPolicy = HitPolicy.fromHitboxEntry(v)
        });
    end;

    SpiderPoisonServer.lingeringHitboxes = v193;
end;

local function _destroyLingeringHitboxes(p195) -- Line: 893
    if p195 then
        p195 = p195.SpiderPoisonServer;
    end;

    if not (p195 and p195.lingeringHitboxes) then
        return;
    end;

    for _, v in p195.lingeringHitboxes do
        if v and v.destroy then
            v:destroy();
        end;
    end;

    p195.lingeringHitboxes = nil;
end;

local function _resolveExplosionHitbox(p196, p197, p198) -- Line: 906
    if p197 then
        p197 = p197.SpiderPoisonServer;
    end;

    if p197 and p197.lingeringHitboxes then
        return p197.lingeringHitboxes[p198];
    end;

    return p196.hitbox and p196.hitbox[p198];
end;

local function _applyExplosionHitServer(p199, p200, p201) -- Line: 914
    -- upvalues: HitResolver (copy)
    if not p200 or (p200.hitboxIndex < 1 or p200.hitboxIndex > 3) then
        return;
    end;

    if not p200.isActive then
        return;
    end;

    for i, v in p201 do
        local applyHit = HitResolver.applyHit;
        local v202 = {
            sourceState = "ProjectileFlying"
        };
        local v203 = math.floor(p200.hitboxIndex);
        v202.damageProfileId = "ExplosionBubble" .. math.clamp(v203, 1, 3);
        v202.skillName = p199.skillName;
        v202.skillCastId = p199.skillCastId;
        v202.baseSkillInstanceId = p199.baseSkillInstanceId;
        v202.activeBaseSkillIndex = p199.activeBaseSkillIndex;
        v202.skillPower = p199.skillPower;
        v202.skillPurity = p199.skillPurity;
        v202.combatSeed = p199.combatSeed;
        v202.hitboxIndex = p200.hitboxIndex;
        applyHit(p199, p200, v, i, v202);
    end;
end;

local function _runExplosionHitboxPoll(u204, u205) -- Line: 938
    -- upvalues: RunService (copy), _applyExplosionHitServer (copy)
    if u204 then
        return RunService.Heartbeat:Connect(function() -- Line: 942
            -- upvalues: u204 (copy), _applyExplosionHitServer (ref), u205 (copy)
            if not u204.isActive then
                return;
            end;

            local v206 = u204:check();

            if v206 and next(v206) then
                _applyExplosionHitServer(u205, u204, v206);
            end;
        end);
    end;

    return nil;
end;

local function _openExplosionHitboxForBubble(u207, p208, p209, p210) -- Line: 961
    -- upvalues: SkillCommon (copy), RunService (copy), _applyExplosionHitServer (copy)
    if p208 < 1 or p208 > 3 then
        return;
    end;

    local v211;

    if p210 then
        v211 = p210.SpiderPoisonServer;
    else
        v211 = p210;
    end;

    local u212;

    if v211 and v211.lingeringHitboxes then
        u212 = v211.lingeringHitboxes[p208];
    else
        u212 = u207.hitbox and u207.hitbox[p208];
    end;

    if not (u212 and u212.hitbox) then
        return;
    end;

    if u212.isActive then
        u212:stop();
    end;

    local v213;

    if p210 then
        v213 = p210.SpiderPoisonServer;
    else
        v213 = p210;
    end;

    local v214;

    if v213 and (v213.impactScale and v213.impactScale > 0) then
        v214 = v213.impactScale;
    else
        local _, v215 = SkillCommon.scaleDualFromData(u207, SkillCommon.bandScaleOptsFromSkillData(u207));
        v214 = v215 or 1;
    end;

    local hitbox = u212.hitbox;

    if hitbox:IsA("BasePart") then
        hitbox.Shape = Enum.PartType.Ball;
    end;

    hitbox.Size = Vector3.new(6, 6, 6) * v214;
    hitbox:PivotTo(CFrame.new(p209));

    if hitbox then
        hitbox.Transparency = 1;
    end;

    u212:start(true);
    local u216;

    if p210 and p210.SpiderPoisonServer and p210.SpiderPoisonServer.lingeringHitboxes ~= nil and u212 then
        u216 = RunService.Heartbeat:Connect(function() -- Line: 942
            -- upvalues: u212 (copy), _applyExplosionHitServer (ref), u207 (copy)
            if not u212.isActive then
                return;
            end;

            local v217 = u212:check();

            if v217 and next(v217) then
                _applyExplosionHitServer(u207, u212, v217);
            end;
        end);
    else
        u216 = nil;
    end;

    task.delay(0.14, function() -- Line: 991
        -- upvalues: u216 (ref), u212 (copy), hitbox (copy)
        if u216 then
            u216:Disconnect();
        end;

        if u212.isActive then
            u212:stop();
            local v218 = hitbox;

            if not v218 then
                return;
            end;

            v218.Transparency = 1;
        end;
    end);
end;

local function _doServerBubbleImpact(p219, p220, p221, p222) -- Line: 1002
    -- upvalues: _openExplosionHitboxForBubble (copy), _tryFinishProjectileFlying (copy)
    if p220.impacted then
        return;
    end;

    p220.impacted = true;
    _openExplosionHitboxForBubble(p219, p220.bubbleIndex, p221, p222);
    _tryFinishProjectileFlying(p219);
end;

local function _ensureClientMotionLoop(u223, u224, u225) -- Line: 1012
    -- upvalues: RunService (copy), _ensureClientProjectileList (copy), _doClientBubbleArrive (copy), _resolveImpactWorldPos (copy), _resolveLiveEndForProjectile (copy), _sampleProjectileMotion (copy), MathMgr (copy), _cleanupRunMotion (copy)
    local skillRunData = u223.skillRunData;

    if skillRunData.runEvent["蜘蛛猛毒客户端弹道"] then
        return;
    end;

    skillRunData.runEvent["蜘蛛猛毒客户端弹道"] = RunService.Heartbeat:Connect(function(p226) -- Line: 1018
        -- upvalues: u223 (copy), u225 (copy), skillRunData (copy), _ensureClientProjectileList (ref), _doClientBubbleArrive (ref), _resolveImpactWorldPos (ref), _resolveLiveEndForProjectile (ref), _sampleProjectileMotion (ref), MathMgr (ref), u224 (copy), _cleanupRunMotion (ref)
        local v227 = u223;
        local v228 = skillRunData;
        local v229;

        if u225 == v227.runGeneration then
            if v227:isRunningFlow() then
                v229 = true;
            else
                local v230 = v228.SpiderPoisonClient and v228.SpiderPoisonClient.projectiles;

                if v230 then
                    v229 = false;

                    for _, v in v230 do
                        if v and not v.impacted then
                            v229 = true;
                            break;
                        end;
                    end;
                else
                    v229 = false;
                end;
            end;
        else
            v229 = false;
        end;

        if not v229 then
            local v231 = skillRunData.runEvent["蜘蛛猛毒客户端弹道"];

            if v231 then
                v231:Disconnect();
                skillRunData.runEvent["蜘蛛猛毒客户端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData = u223.skillInputData;
        local v232 = false;

        for _, v in _ensureClientProjectileList(skillRunData) do
            if v and not v.impacted then
                if v.bubble and v.bubble.Parent then
                    v232 = true;
                    v.moveT = v.moveT + p226;
                    local v233 = math.clamp(v.moveT / v.flightSec, 0, 1);
                    local v234, v235 = _sampleProjectileMotion(v, v233, (_resolveLiveEndForProjectile(skillInputData, v)));

                    if v.oriLocal then
                        local v236 = MathMgr.rotLookAtForwardSafe(v235, Vector3.new(0, 1, 0), u224.CFrame.RightVector);
                        v.bubble:PivotTo(CFrame.new(v234) * v236 * v.oriLocal);
                    else
                        v.bubble:PivotTo(CFrame.new(v234));
                    end;

                    if v233 >= 1 then
                        _doClientBubbleArrive(u223, v, v234);
                    end;
                else
                    _doClientBubbleArrive(u223, v, _resolveImpactWorldPos(v, skillInputData));
                end;
            end;
        end;

        if not v232 then
            _cleanupRunMotion(u223);
        end;
    end);
end;

local function _ensureServerMotionLoop(u237, u238) -- Line: 1065
    -- upvalues: RunService (copy), _ensureServerProjectileList (copy), _resolveLiveEndForProjectile (copy), _sampleProjectileMotion (copy), _openExplosionHitboxForBubble (copy), _tryFinishProjectileFlying (copy), _cleanupRunMotion (copy), _destroyLingeringHitboxes (copy)
    local skillRunData = u237.skillRunData;

    if skillRunData.runEvent["蜘蛛猛毒服务端弹道"] then
        return;
    end;

    skillRunData.runEvent["蜘蛛猛毒服务端弹道"] = RunService.Heartbeat:Connect(function(p239) -- Line: 1071
        -- upvalues: u237 (copy), u238 (copy), skillRunData (copy), _ensureServerProjectileList (ref), _resolveLiveEndForProjectile (ref), _sampleProjectileMotion (ref), _openExplosionHitboxForBubble (ref), _tryFinishProjectileFlying (ref), _cleanupRunMotion (ref), _destroyLingeringHitboxes (ref)
        local v240 = u237;
        local v241 = skillRunData;
        local v242;

        if u238 == v240.runGeneration then
            if v240:isRunningFlow() then
                v242 = true;
            else
                local v243 = v241.SpiderPoisonServer and v241.SpiderPoisonServer.projectiles;

                if v243 then
                    v242 = false;

                    for _, v in v243 do
                        if v and not v.impacted then
                            v242 = true;
                            break;
                        end;
                    end;
                else
                    v242 = false;
                end;
            end;
        else
            v242 = false;
        end;

        if not v242 then
            local v244 = skillRunData.runEvent["蜘蛛猛毒服务端弹道"];

            if v244 then
                v244:Disconnect();
                skillRunData.runEvent["蜘蛛猛毒服务端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData = u237.skillInputData;
        local v245 = false;

        for _, v in _ensureServerProjectileList(skillRunData) do
            if v and not v.impacted then
                v245 = true;
                v.moveT = v.moveT + p239;
                local v246 = math.clamp(v.moveT / v.flightSec, 0, 1);
                local v247 = _resolveLiveEndForProjectile(skillInputData, v);
                local v248 = select(1, _sampleProjectileMotion(v, v246, v247));

                if v246 >= 1 then
                    local v249 = u237;
                    local v250 = skillRunData;

                    if not v.impacted then
                        v.impacted = true;
                        _openExplosionHitboxForBubble(v249, v.bubbleIndex, v248, v250);
                        _tryFinishProjectileFlying(v249);
                    end;
                end;
            end;
        end;

        if not v245 then
            _cleanupRunMotion(u237);
            _destroyLingeringHitboxes(skillRunData);
        end;
    end);
end;

local function _prepareBubbleMaterialTemplates(p251, p252) -- Line: 1108
    for i = 1, 3 do
        local v253 = p251.material and p251.material[i == 1 and "毒素爆炸" or "毒素爆炸" .. i];

        if v253 and v253:IsA("Model") then
            v253:ScaleTo(p252);
        end;
    end;
end;

local function _fireClientBubble(p254, p255, p256, p257, p258, p259, p260) -- Line: 1117
    -- upvalues: u3 (copy), _resolveInitialTangent (copy), MathMgr (copy), _playBubbleAppearFx (copy), SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), _playBubbleFlightSound (copy), _ensureClientProjectileList (copy)
    local v261 = u3[p255] or u3[1];
    local v262 = v261.targetOffset or CFrame.new();
    local v263 = ((u3[p255] or u3[1]).targetOffset or CFrame.new()).Position * p259;
    local v264;

    if v263.Magnitude < 0.0001 then
        v264 = p258;
    else
        local v265 = Vector3.new(p258.X - p256.X, 0, p258.Z - p256.Z);
        v264 = (CFrame.lookAt(p258, p258 + (v265.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v265.Unit)) * CFrame.new(v263)).Position;
    end;

    local skillRunData = p254.skillRunData;
    local v266 = u3[p255] or u3[1];
    local v267 = {
        flightSec = v266.flightSec,
        trackDurationSec = v266.trackDurationSec or 1.5,
        easingStyle = v266.easingStyle,
        easingDirection = v266.easingDirection
    };
    local v268 = _resolveInitialTangent(p256, v264, v261.angleOffsetDeg);
    local v269 = MathMgr.rotLookAtForwardSafe(v268, Vector3.new(0, 1, 0), p260.CFrame.RightVector);
    _playBubbleAppearFx(skillRunData, CFrame.new(p256) * v269, p259);
    local v270 = v261.launchSoundName or "音效-技能-毒素气泡-发射";

    if v270 and v270 ~= "" then
        SkillCommon.playSoundLocal3D(v270, p256);
    end;

    local v271 = skillRunData.material and skillRunData.material[p255 == 1 and "毒素气泡" or "毒素气泡" .. p255];
    local v272;

    if v271 and v271:IsA("Model") then
        VisibleMgr.UnQueryAll(v271);
        v271:ScaleTo(p259);
        v272 = v271:GetPivot() - v271:GetPivot().Position;

        if v272 then
            v271:PivotTo(CFrame.new(p256) * v269 * v272);
        else
            v271:PivotTo(p257);
        end;

        v271.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v271, false);
        FXUtil.SetEnableNameVfx(v271, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(v271, true);
        SkillCommon.appendRunSpawnList(skillRunData, "SpiderPoisonSpawns", v271);
    else
        v272 = nil;
    end;

    local v273 = v261.flightSoundName or "音效-技能-毒素气泡-飞行";
    local v274 = SkillCommon.resolveSkillCastSoundTag(p254);
    local v275;

    if v274 then
        v275 = v274 .. "_bubbleFly_" .. tostring(p255);
    else
        v275 = nil;
    end;

    _playBubbleFlightSound(p254, v273, v275, v271, p256);
    local v276 = _ensureClientProjectileList(skillRunData);
    table.insert(v276, {
        moveT = 0,
        impacted = false,
        bubbleIndex = p255,
        bubble = v271,
        bubbleStart = p256,
        baseSnapEnd0 = p258,
        targetOffsetCF = v262,
        targetOffsetScale = p259,
        snapEnd0 = v264,
        initialTangent = v268,
        flightSec = v267.flightSec,
        trackDurationSec = v267.trackDurationSec,
        easingStyle = v267.easingStyle,
        easingDirection = v267.easingDirection,
        flightSoundName = v273,
        flightSoundTag = v275,
        oriLocal = v272
    });
end;

local function _fireClientBubbles(u277) -- Line: 1185
    -- upvalues: SkillCommon (copy), _resolveHeadSpawnCF (copy), _prepareBubbleMaterialTemplates (copy), _fireClientBubble (copy), u5 (copy), RunService (copy), _ensureClientProjectileList (copy), _doClientBubbleArrive (copy), _resolveImpactWorldPos (copy), _resolveLiveEndForProjectile (copy), _sampleProjectileMotion (copy), MathMgr (copy), _cleanupRunMotion (copy)
    local skillInputData = u277.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u277.runGeneration;

    if u277.runGeneration ~= runGeneration then
        return;
    end;

    local skillRunData = u277.skillRunData;
    local v278 = SkillCommon.scaleBandFromData(u277, SkillCommon.bandScaleOptsFromSkillData(u277));
    local v279 = _resolveHeadSpawnCF(character, v278);

    if not v279 then
        return;
    end;

    local Position = v279.Position;
    SkillCommon.refreshSkillAimSnapshot(u277);
    SkillCommon.refreshSkillAimSnapshot(u277);
    local skillInputData2 = u277.skillInputData;
    local v280;

    if skillInputData2 then
        v280 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        v280 = u277:getTargetCF().Position;
    end;

    _prepareBubbleMaterialTemplates(skillRunData, v278);

    for i = 1, 3 do
        _fireClientBubble(u277, i, Position, v279, v280, v278, HumanoidRootPart);
    end;

    local skillRunData2 = u277.skillRunData;

    if skillRunData2.runEvent[u5.clientMotion] then
        return;
    end;

    skillRunData2.runEvent[u5.clientMotion] = RunService.Heartbeat:Connect(function(p281) -- Line: 1018
        -- upvalues: u277 (copy), runGeneration (copy), skillRunData2 (copy), _ensureClientProjectileList (ref), _doClientBubbleArrive (ref), _resolveImpactWorldPos (ref), _resolveLiveEndForProjectile (ref), _sampleProjectileMotion (ref), MathMgr (ref), HumanoidRootPart (copy), _cleanupRunMotion (ref)
        local v282 = u277;
        local v283 = skillRunData2;
        local v284;

        if runGeneration == v282.runGeneration then
            if v282:isRunningFlow() then
                v284 = true;
            else
                local v285 = v283.SpiderPoisonClient and v283.SpiderPoisonClient.projectiles;

                if v285 then
                    v284 = false;

                    for _, v in v285 do
                        if v and not v.impacted then
                            v284 = true;
                            break;
                        end;
                    end;
                else
                    v284 = false;
                end;
            end;
        else
            v284 = false;
        end;

        if not v284 then
            local v286 = skillRunData2.runEvent["蜘蛛猛毒客户端弹道"];

            if v286 then
                v286:Disconnect();
                skillRunData2.runEvent["蜘蛛猛毒客户端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData3 = u277.skillInputData;
        local v287 = false;

        for _, v in _ensureClientProjectileList(skillRunData2) do
            if v and not v.impacted then
                if v.bubble and v.bubble.Parent then
                    v287 = true;
                    v.moveT = v.moveT + p281;
                    local v288 = math.clamp(v.moveT / v.flightSec, 0, 1);
                    local v289, v290 = _sampleProjectileMotion(v, v288, (_resolveLiveEndForProjectile(skillInputData3, v)));

                    if v.oriLocal then
                        local v291 = MathMgr.rotLookAtForwardSafe(v290, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector);
                        v.bubble:PivotTo(CFrame.new(v289) * v291 * v.oriLocal);
                    else
                        v.bubble:PivotTo(CFrame.new(v289));
                    end;

                    if v288 >= 1 then
                        _doClientBubbleArrive(u277, v, v289);
                    end;
                else
                    _doClientBubbleArrive(u277, v, _resolveImpactWorldPos(v, skillInputData3));
                end;
            end;
        end;

        if not v287 then
            _cleanupRunMotion(u277);
        end;
    end);
end;

local function _fireServerBubble(p292, p293, p294, p295, p296) -- Line: 1224
    -- upvalues: u3 (copy), _resolveInitialTangent (copy), _ensureServerProjectileList (copy)
    local v297 = u3[p293] or u3[1];
    local v298 = v297.targetOffset or CFrame.new();
    local v299 = ((u3[p293] or u3[1]).targetOffset or CFrame.new()).Position * p296;
    local v300;

    if v299.Magnitude < 0.0001 then
        v300 = p295;
    else
        local v301 = Vector3.new(p295.X - p294.X, 0, p295.Z - p294.Z);
        v300 = (CFrame.lookAt(p295, p295 + (v301.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v301.Unit)) * CFrame.new(v299)).Position;
    end;

    local v302 = u3[p293] or u3[1];
    local v303 = {
        flightSec = v302.flightSec,
        trackDurationSec = v302.trackDurationSec or 1.5,
        easingStyle = v302.easingStyle,
        easingDirection = v302.easingDirection
    };
    local v304 = _resolveInitialTangent(p294, v300, v297.angleOffsetDeg);
    local v305 = _ensureServerProjectileList(p292.skillRunData);
    table.insert(v305, {
        moveT = 0,
        impacted = false,
        bubbleIndex = p293,
        bubbleStart = p294,
        baseSnapEnd0 = p295,
        targetOffsetCF = v298,
        targetOffsetScale = p296,
        snapEnd0 = v300,
        initialTangent = v304,
        flightSec = v303.flightSec,
        trackDurationSec = v303.trackDurationSec,
        easingStyle = v303.easingStyle,
        easingDirection = v303.easingDirection
    });
end;

local function _fireServerBubbles(u306) -- Line: 1261
    -- upvalues: SkillCommon (copy), _resolveHeadSpawnCF (copy), _ensureServerProjectileList (copy), _fireServerBubble (copy), u5 (copy), RunService (copy), _resolveLiveEndForProjectile (copy), _sampleProjectileMotion (copy), _openExplosionHitboxForBubble (copy), _tryFinishProjectileFlying (copy), _cleanupRunMotion (copy), _destroyLingeringHitboxes (copy)
    local skillInputData = u306.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    local runGeneration = u306.runGeneration;

    if u306.runGeneration ~= runGeneration then
        return;
    end;

    local v307 = SkillCommon.scaleBandFromData(u306, SkillCommon.bandScaleOptsFromSkillData(u306));
    local v308 = _resolveHeadSpawnCF(character, v307);

    if not v308 then
        return;
    end;

    local Position = v308.Position;
    SkillCommon.refreshSkillAimSnapshot(u306);
    SkillCommon.refreshSkillAimSnapshot(u306);
    local skillInputData2 = u306.skillInputData;
    local v309;

    if skillInputData2 then
        v309 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        v309 = u306:getTargetCF().Position;
    end;

    local skillRunData = u306.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.projectileFlyingStartTime = os.clock();
    local _, v310 = SkillCommon.scaleDualFromData(u306, SkillCommon.bandScaleOptsFromSkillData(u306));
    _ensureServerProjectileList(skillRunData);
    skillRunData.SpiderPoisonServer.impactScale = v310;
    _fireServerBubble(u306, 1, Position, v309, v307);
    _fireServerBubble(u306, 2, Position, v309, v307);
    _fireServerBubble(u306, 3, Position, v309, v307);
    local skillRunData2 = u306.skillRunData;

    if skillRunData2.runEvent[u5.serverMotion] then
        return;
    end;

    skillRunData2.runEvent[u5.serverMotion] = RunService.Heartbeat:Connect(function(p311) -- Line: 1071
        -- upvalues: u306 (copy), runGeneration (copy), skillRunData2 (copy), _ensureServerProjectileList (ref), _resolveLiveEndForProjectile (ref), _sampleProjectileMotion (ref), _openExplosionHitboxForBubble (ref), _tryFinishProjectileFlying (ref), _cleanupRunMotion (ref), _destroyLingeringHitboxes (ref)
        local v312 = u306;
        local v313 = skillRunData2;
        local v314;

        if runGeneration == v312.runGeneration then
            if v312:isRunningFlow() then
                v314 = true;
            else
                local v315 = v313.SpiderPoisonServer and v313.SpiderPoisonServer.projectiles;

                if v315 then
                    v314 = false;

                    for _, v in v315 do
                        if v and not v.impacted then
                            v314 = true;
                            break;
                        end;
                    end;
                else
                    v314 = false;
                end;
            end;
        else
            v314 = false;
        end;

        if not v314 then
            local v316 = skillRunData2.runEvent["蜘蛛猛毒服务端弹道"];

            if v316 then
                v316:Disconnect();
                skillRunData2.runEvent["蜘蛛猛毒服务端弹道"] = nil;
            end;

            return;
        end;

        local skillInputData3 = u306.skillInputData;
        local v317 = false;

        for _, v in _ensureServerProjectileList(skillRunData2) do
            if v and not v.impacted then
                v317 = true;
                v.moveT = v.moveT + p311;
                local v318 = math.clamp(v.moveT / v.flightSec, 0, 1);
                local v319 = _resolveLiveEndForProjectile(skillInputData3, v);
                local v320 = select(1, _sampleProjectileMotion(v, v318, v319));

                if v318 >= 1 then
                    local v321 = u306;
                    local v322 = skillRunData2;

                    if not v.impacted then
                        v.impacted = true;
                        _openExplosionHitboxForBubble(v321, v.bubbleIndex, v320, v322);
                        _tryFinishProjectileFlying(v321);
                    end;
                end;
            end;
        end;

        if not v317 then
            _cleanupRunMotion(u306);
            _destroyLingeringHitboxes(skillRunData2);
        end;
    end);
end;

local function _flushClientProjectiles(p323) -- Line: 1300
    -- upvalues: _doClientBubbleArrive (copy), _resolveImpactWorldPos (copy)
    local skillRunData = p323.skillRunData;

    if not (skillRunData and (skillRunData.SpiderPoisonClient and skillRunData.SpiderPoisonClient.projectiles)) then
        return;
    end;

    local skillInputData = p323.skillInputData;

    for _, v in skillRunData.SpiderPoisonClient.projectiles do
        if v and not v.impacted then
            _doClientBubbleArrive(p323, v, _resolveImpactWorldPos(v, skillInputData));
        end;
    end;
end;

local function _flushServerProjectiles(p324) -- Line: 1313
    -- upvalues: _resolveLiveEndForProjectile (copy), _sampleProjectileMotion (copy), _openExplosionHitboxForBubble (copy), _tryFinishProjectileFlying (copy)
    local skillRunData = p324.skillRunData;

    if not (skillRunData and (skillRunData.SpiderPoisonServer and skillRunData.SpiderPoisonServer.projectiles)) then
        return;
    end;

    local skillInputData = p324.skillInputData;

    for _, v in skillRunData.SpiderPoisonServer.projectiles do
        if v and not v.impacted then
            local v325 = _resolveLiveEndForProjectile(skillInputData, v);
            local v326 = select(1, _sampleProjectileMotion(v, 1, v325));

            if not v.impacted then
                v.impacted = true;
                _openExplosionHitboxForBubble(p324, v.bubbleIndex, v326, skillRunData);
                _tryFinishProjectileFlying(p324);
            end;
        end;
    end;
end;

local function _stopAllHitboxes(p327) -- Line: 1326
    for i = 1, 3 do
        local v328 = p327.hitbox[i];

        if v328 and v328.isActive then
            v328:stop();
        end;

        if v328 and v328.hitbox then
            local hitbox = v328.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;
        end;
    end;
end;

v1.skillTotalTime = -1;
local v329 = math.max(0, u3[1].flightSec);
local v330 = math.max(v329, u3[2].flightSec);
v1.visualFadeoutTime = math.max(v330, u3[3].flightSec) + 0.3 + 1.2;
v1.skillElementType = ElementTp.Poison;
v1.skillDistanceLimit = 64;
v1.InitialState = "Startup";
v1.ControlOpenState = "ProjectileFlying";
v1.States = {
    Startup = {
        Duration = 0.6,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    ProjectileFlying = {
        Duration = -1,
        OnEnterClient = "Client_EnterProjectileFlying",
        OnEnterServer = "Server_EnterProjectileFlying",
        OnExitClient = "Client_ExitProjectileFlying",
        OnExitServer = "Server_ExitProjectileFlying"
    },
    Exploding = {
        Duration = 0.3,
        OnEnterClient = "Client_EnterExploding",
        OnEnterServer = "Server_EnterExploding",
        OnExitClient = "Client_ExitExploding",
        OnExitServer = "Server_ExitExploding"
    },
    Recovery = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery"
    },
    Finished = {
        Duration = 0,
        IsTerminal = true
    },
    Interrupted = {
        Duration = 0,
        IsTerminal = true,
        OnEnterClient = "Client_EnterInterrupted",
        OnEnterServer = "Server_EnterInterrupted"
    }
};
v1.Transitions = {
    {
        From = "Startup",
        To = "ProjectileFlying",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "ProjectileFlying",
        To = "Exploding",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Exploding",
        To = "Recovery",
        Event = SkillEventConst.StateTimeout
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
        From = "Exploding",
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
        From = "Exploding",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function v1.Client_EnterStartup(p331) -- Line: 1405
    -- upvalues: _cloneBubbleMaterials (copy)
    local skillRunData = p331.skillRunData;

    if skillRunData then
        _cloneBubbleMaterials(skillRunData);
    end;
end;

function v1.Server_EnterStartup(p332) -- Line: 1412
    for i = 1, 3 do
        local v333 = p332.hitbox[i];

        if v333 and v333.hitbox then
            local hitbox = v333.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;

            v333.hitbox:PivotTo(CFrame.new(0, -5000, 0));
        end;
    end;
end;

function v1.Client_EnterProjectileFlying(p334) -- Line: 1422
    -- upvalues: PlayerAimSync (copy), _fireClientBubbles (copy)
    PlayerAimSync.refreshAimSnapshot(p334);
    local skillRunData = p334.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.runEvent = skillRunData.runEvent or {};
    _fireClientBubbles(p334);
end;

function v1.Client_ExitProjectileFlying(p335) -- Line: 1434
    -- upvalues: _cleanupRunMotion (copy)
    _cleanupRunMotion(p335);
end;

function v1.Server_EnterProjectileFlying(p336) -- Line: 1439
    -- upvalues: PlayerAimSync (copy), _fireServerBubbles (copy)
    PlayerAimSync.refreshAimSnapshot(p336);

    for i = 1, 3 do
        local v337 = p336.hitbox[i];

        if v337 and v337.hitbox then
            local hitbox = v337.hitbox;

            if hitbox then
                hitbox.Transparency = 1;
            end;
        end;
    end;

    local skillRunData = p336.skillRunData;
    skillRunData.runEvent = skillRunData.runEvent or {};
    _fireServerBubbles(p336);
end;

function v1.Server_ExitProjectileFlying(p338) -- Line: 1455
    -- upvalues: _cleanupRunMotion (copy)
    _cleanupRunMotion(p338);
end;

function v1.Client_EnterInterrupted(p339) -- Line: 1459
end;

function v1.Server_EnterInterrupted(p340) -- Line: 1463
    -- upvalues: _stopAllHitboxes (copy), _createLingeringHitboxes (copy)
    _stopAllHitboxes(p340);
    local skillRunData = p340.skillRunData;

    if skillRunData then
        local v341 = skillRunData.SpiderPoisonServer and skillRunData.SpiderPoisonServer.projectiles;
        local v342;

        if v341 then
            v342 = false;

            for _, v in v341 do
                if v and not v.impacted then
                    v342 = true;
                    break;
                end;
            end;
        else
            v342 = false;
        end;

        if v342 then
            _createLingeringHitboxes(p340, skillRunData);
        end;
    end;
end;

function v1.Client_EnterExploding(p343) -- Line: 1471
    -- upvalues: SkillCommon (copy)
    local skillRunData = p343.skillRunData;

    if skillRunData then
        SkillCommon.scheduleRunSpawnClear(p343, p343.runGeneration, skillRunData, "SpiderPoisonSpawns", 1.2);
    end;
end;

function v1.Client_ExitExploding(p344) -- Line: 1478
    -- upvalues: SkillCommon (copy)
    local skillRunData = p344.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p344, p344.runGeneration, skillRunData, "SpiderPoisonSpawns");
    end;
end;

function v1.Server_EnterExploding(p345) -- Line: 1485
end;

function v1.Server_ExitExploding(p346) -- Line: 1488
    -- upvalues: _stopAllHitboxes (copy)
    _stopAllHitboxes(p346);
end;

function v1.Server_EnterRecovery(p347) -- Line: 1492
    p347:releaseControl();
end;

function v1.Client_EnterRecovery(p348) -- Line: 1496
end;

function v1.onEndServer(p349) -- Line: 1499
    -- upvalues: _flushServerProjectiles (copy), _cleanupRunMotion (copy), _stopAllHitboxes (copy), _destroyLingeringHitboxes (copy)
    local skillRunData = p349.skillRunData;
    _flushServerProjectiles(p349);
    _cleanupRunMotion(p349, true);
    _stopAllHitboxes(p349);

    if skillRunData then
        _destroyLingeringHitboxes(skillRunData);
        skillRunData.SpiderPoisonServer = nil;
    end;
end;

function v1.onEnd(p350) -- Line: 1510
    -- upvalues: _stopBubbleFlightSound (copy), _flushClientProjectiles (copy), _cleanupRunMotion (copy), SkillCommon (copy)
    local skillRunData = p350.skillRunData;
    local v351 = skillRunData and skillRunData.SpiderPoisonClient and skillRunData.SpiderPoisonClient.projectiles;

    if v351 then
        for _, v in v351 do
            _stopBubbleFlightSound(v);
        end;
    end;

    _flushClientProjectiles(p350);
    _cleanupRunMotion(p350, true);

    if p350.skillRunData then
        SkillCommon.clearRunSpawnList(p350.skillRunData, "SpiderPoisonSpawns");
        p350.skillRunData.SpiderPoisonClient = nil;
    end;
end;

function v1.onProjectileHitServer(p352, p353, p354) -- Line: 1527
    -- upvalues: _applyExplosionHitServer (copy)
    _applyExplosionHitServer(p352, p353, p354);
end;

v1.SoundList = (function() -- Line: 292, Name: _collectBubbleSoundList
    -- upvalues: u3 (copy)
    local u355 = {};
    local u356 = {};

    local function append(p357) -- Line: 295
        -- upvalues: u355 (copy), u356 (copy)
        if not p357 or (p357 == "" or u355[p357]) then
            return;
        end;

        u355[p357] = true;
        table.insert(u356, p357);
    end;

    if not u355["音效-技能-毒素气泡-发射"] then
        u355["音效-技能-毒素气泡-发射"] = true;
        table.insert(u356, "音效-技能-毒素气泡-发射");
    end;

    if not u355["音效-技能-毒素气泡-飞行"] then
        u355["音效-技能-毒素气泡-飞行"] = true;
        table.insert(u356, "音效-技能-毒素气泡-飞行");
    end;

    if not u355["音效-技能-毒素气泡-爆炸"] then
        u355["音效-技能-毒素气泡-爆炸"] = true;
        table.insert(u356, "音效-技能-毒素气泡-爆炸");
    end;

    for i = 1, 3 do
        local v358 = u3[i];

        if v358 then
            local v359 = v358.launchSoundName or "音效-技能-毒素气泡-发射";

            if v359 and (v359 ~= "" and not u355[v359]) then
                u355[v359] = true;
                table.insert(u356, v359);
            end;

            local v360 = v358.flightSoundName or "音效-技能-毒素气泡-飞行";

            if v360 and (v360 ~= "" and not u355[v360]) then
                u355[v360] = true;
                table.insert(u356, v360);
            end;

            local v361 = v358.explosionSoundName or "音效-技能-毒素气泡-爆炸";

            if v361 and v361 ~= "" then
                if not u355[v361] then
                    u355[v361] = true;
                    table.insert(u356, v361);
                end;
            end;
        end;
    end;

    return u356;
end)();
v1.AnimateList = { "蜘蛛毒素" };
v1.ResNameList = { "毒素气泡", "毒素气泡2", "毒素气泡3", "毒素气泡出现", "毒素爆炸", "毒素爆炸2", "毒素爆炸3" };
v1.hitboxConfig = u2;
v1.DamageProfiles = (function() -- Line: 1531, Name: _buildExplosionDamageProfiles
    -- upvalues: SkillDamageRateFromCfg (copy), u6 (copy)
    local v362 = {};

    for i = 1, 3 do
        local v363 = math.floor(i);
        v362["ExplosionBubble" .. math.clamp(v363, 1, 3)] = {
            damageRate = SkillDamageRateFromCfg.get(10300039, i),
            elementType = u6.elementType,
            canCritical = u6.canCritical,
            damageTags = u6.damageTags,
            showDamageText = u6.showDamageText,
            randomOffset = u6.randomOffset
        };
    end;

    return v362;
end)();
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.6,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 0.6,
        animationName = "蜘蛛毒素",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;