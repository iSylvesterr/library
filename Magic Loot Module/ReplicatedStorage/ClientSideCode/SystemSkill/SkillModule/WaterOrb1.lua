-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local TweenService = game:GetService("TweenService");
local Players = UtilsSystem.Players;
local BezierCurve = UtilsSystem.BezierCurve;
local ProjectileObjectTracking = require(script.Parent._Templates.Projectile.ProjectileObjectTracking);
local ProjectileCore = require(script.Parent._Templates.Projectile.ProjectileCore);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Water,
    skillDistanceLimit = 55
};

local function hitboxStartupSize(p2) -- Line: 51
    -- upvalues: SkillCommon (copy)
    return Vector3.new(3, 3, 3) * SkillCommon.skillScaleFromSkillData(p2);
end;

local function hitboxPulseEndSize(p3) -- Line: 55
    -- upvalues: SkillCommon (copy)
    return Vector3.new(9, 9, 9) * SkillCommon.skillScaleFromSkillData(p3);
end;

local u4 = {
    enabled = true,
    curveRefreshInterval = 0.05,
    objectValueName = ProjectileObjectTracking.DEFAULT_OV_NAME,
    objectValuePathSegments = {}
};
u1.InitialState = "Startup";
u1.ControlOpenState = "ProjectileFlying";
u1.States = {
    Startup = {
        Duration = 0.27,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    ProjectileFlying = {
        Duration = -1,
        OnEnterClient = "Client_EnterProjectileFlying",
        OnEnterServer = "Server_EnterProjectileFlying",
        OnExitClient = "Client_ExitProjectileFlying",
        OnExitServer = "Server_ExitProjectileFlying"
    },
    Recovery = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery",
        OnExitClient = nil,
        OnExitServer = nil
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
u1.Transitions = {
    {
        From = "Startup",
        To = "ProjectileFlying",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "ProjectileFlying",
        To = "Recovery",
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
        To = "Finished",
        Event = SkillEventConst.ForceFinish
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
    }
};

local function getFormationPivotCF(p5) -- Line: 123
    -- upvalues: SkillCommon (copy)
    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
        return SkillCommon.formationCF(HumanoidRootPart, nil, CFrame.new(0, 1.4, -6.5));
    end;

    return nil;
end;

local function getStaticClampedEndPos(p6, p7) -- Line: 132
    -- upvalues: ProjectileCore (copy)
    local skillInputData = p6.skillInputData;
    local v8;

    if skillInputData and skillInputData.targetCF then
        v8 = skillInputData.targetCF.Position;
    else
        v8 = nil;
    end;

    return ProjectileCore.clampProjectileEndToMaxRange(p7, v8 or Vector3.new(0, 0, 0), 60, 1);
end;

local function queryLiveTrackWorldPos(p9, p10, p11) -- Line: 144
    -- upvalues: ProjectileObjectTracking (copy), u4 (copy)
    if p9 == nil or p9 == "" then
        return nil;
    end;

    if p11 then
        return ProjectileObjectTracking.getWorldPositionByTrackTargetId(p9);
    end;

    return ProjectileObjectTracking.getLiveTrackedWorldPosition(p9, p10, u4);
end;

local function resolveTrackingAtCast(p12) -- Line: 159
    -- upvalues: u4 (copy), ProjectileObjectTracking (copy)
    if not u4.enabled then
        return false, nil, nil;
    end;

    local v13 = p12.skillInputData and p12.skillInputData.trackTargetId;

    if v13 == nil or v13 == "" then
        return false, nil, nil;
    end;

    local _, v14, v15 = ProjectileObjectTracking.resolveAtCast(v13, p12.character or p12.skillInputData and p12.skillInputData.character, u4);
    local v16 = v13 or v15;

    if v14 and (v16 ~= nil and v16 ~= "") then
        return true, v16, v14;
    end;

    return false, nil, nil;
end;

local function createWaterOrbTrackState(p17, p18, p19, p20, p21, p22, p23) -- Line: 179
    -- upvalues: ProjectileCore (copy)
    local v24;

    if p21 and p23 then
        v24 = ProjectileCore.clampProjectileEndToMaxRange(p18, p23, 60, 1);
    else
        local skillInputData = p17.skillInputData;
        local v25;

        if skillInputData and skillInputData.targetCF then
            v25 = skillInputData.targetCF.Position;
        else
            v25 = nil;
        end;

        v24 = ProjectileCore.clampProjectileEndToMaxRange(p18, v25 or Vector3.new(0, 0, 0), 60, 1);
    end;

    return {
        lastRefreshAt = -0.05,
        trackingActive = p21,
        effectiveTrackId = p22,
        startPos = p18,
        lastEnd = v24,
        character = p19,
        isServer = p20 == true
    };
end;

local function refreshSharedTrackedEnd(p26, p27) -- Line: 211
    -- upvalues: ProjectileObjectTracking (copy), u4 (copy), ProjectileCore (copy)
    if not p26.trackingActive then
        return p26.lastEnd;
    end;

    local v28 = p27 or os.clock();

    if v28 - p26.lastRefreshAt >= 0.05 then
        p26.lastRefreshAt = v28;
        local effectiveTrackId = p26.effectiveTrackId;
        local character = p26.character;
        local isServer = p26.isServer;
        local v29;

        if effectiveTrackId == nil or effectiveTrackId == "" then
            v29 = nil;
        elseif isServer then
            v29 = ProjectileObjectTracking.getWorldPositionByTrackTargetId(effectiveTrackId);
        else
            v29 = ProjectileObjectTracking.getLiveTrackedWorldPosition(effectiveTrackId, character, u4);
        end;

        if v29 then
            p26.lastEnd = ProjectileCore.clampProjectileEndToMaxRange(p26.startPos, v29, 60, 1);
        end;
    end;

    return p26.lastEnd;
end;

local function buildBezierPoints(p30, p31, p32) -- Line: 229
    -- upvalues: BezierCurve (copy)
    return (p31 - p30).Magnitude < 0.05 and { p30, p31 } or { p30, BezierCurve.GetMiddlePosition(p30, p31, (p32 - 1) * 60 + -60, 0.76), p31 };
end;

local function rayObstacleSegment(p33, p34, p35) -- Line: 244
    local v36 = p34 - p33;

    if v36.Magnitude <= 0.01 then
        return nil;
    end;

    local v37 = {};
    local v38 = 0;

    if p35 then
        for _, v in p35 do
            if v then
                v38 = v38 + 1;
                v37[v38] = v;
            end;
        end;
    end;

    local v39 = RaycastParams.new();
    v39.FilterType = Enum.RaycastFilterType.Exclude;
    v39.FilterDescendantsInstances = v37;
    local v40 = workspace:Raycast(p33, v36, v39);

    if not v40 then
        return nil;
    end;

    local Instance = v40.Instance;

    if Instance then
        Instance = Instance.Parent;
    end;

    local v41 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

    if v41 then
        return nil;
    end;

    return v40;
end;

local function runTrackedWaterOrbBallMotion(u42, u43, u44, p45, u46, u47) -- Line: 278
    -- upvalues: refreshSharedTrackedEnd (copy), RunService (copy), TweenService (copy), buildBezierPoints (copy), ProjectileCore (copy), rayObstacleSegment (copy)
    local u48 = p45 < 0.0001 and 0.0001 or p45;
    local startPos = u43.startPos;
    local v49 = refreshSharedTrackedEnd(u43);
    local Rotation = CFrame.lookAt(startPos, v49).Rotation;
    local u50 = 0;
    local u51 = startPos;
    local u52 = nil;
    u52 = RunService.Heartbeat:Connect(function(p53) -- Line: 295
        -- upvalues: u42 (copy), u52 (ref), u46 (copy), u50 (ref), u48 (ref), TweenService (ref), refreshSharedTrackedEnd (ref), u43 (copy), buildBezierPoints (ref), startPos (copy), u44 (copy), ProjectileCore (ref), Rotation (copy), u51 (ref), rayObstacleSegment (ref), u47 (copy)
        if not u42.Parent then
            if u52 then
                u52:Disconnect();
            end;

            return;
        end;

        if not u46() then
            if u52 then
                u52:Disconnect();
            end;

            return;
        end;

        u50 = u50 + p53;
        local v54 = math.clamp(u50 / u48, 0, 1);
        local v55 = TweenService:GetValue(v54, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
        local v56 = refreshSharedTrackedEnd(u43);
        local v57 = buildBezierPoints(startPos, v56, u44);
        local v58 = ProjectileCore.evaluateBezierPoint(v57, v55);

        if (v56 - v58).Magnitude > 0.03 then
            u42:PivotTo(CFrame.lookAt(v58, v56, Vector3.new(0, 1, 0)));
        else
            u42:PivotTo(CFrame.new(v58) * Rotation);
        end;

        local v59 = (v58 - u51).Magnitude > 0.01 and rayObstacleSegment(u51, v58, { u43.character, u42 });

        if v59 then
            if u52 then
                u52:Disconnect();
            end;

            u47(v59.Position);

            return;
        end;

        u51 = v58;

        if v54 >= 1 then
            if u52 then
                u52:Disconnect();
            end;

            u47(v56);
        end;
    end);

    return u52;
end;

local function bumpWaterOrbGen(p60) -- Line: 341
    p60.Logic = p60.Logic or {};
    p60.Logic.waterOrbGen = (p60.Logic.waterOrbGen or 0) + 1;

    return p60.Logic.waterOrbGen;
end;

local function scheduleRecoveryAfterLastExplosion(u61, u62) -- Line: 350
    -- upvalues: SkillEventConst (copy)
    task.delay(0.28, function() -- Line: 352
        -- upvalues: u61 (copy), u62 (copy), SkillEventConst (ref)
        local skillRunData = u61.skillRunData;
        local v63;

        if skillRunData then
            v63 = skillRunData.Logic;
        else
            v63 = skillRunData;
        end;

        if not v63 or v63.waterOrbGen ~= u62 then
            return;
        end;

        if skillRunData.State.current ~= "ProjectileFlying" then
            return;
        end;

        u61:TryTransition(SkillEventConst.Timeout, nil);
    end);
end;

local function playLocalExplosion(p64, p65, p66) -- Line: 365
    -- upvalues: VisibleMgr (copy), FXUtil (copy)
    if not p64 then
        return;
    end;

    local u67 = p64:Clone();
    VisibleMgr.UnQueryAll(u67);
    u67:ScaleTo((math.clamp(p66, 0.12, 2.2)));
    u67:PivotTo(CFrame.new(p65));
    u67.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(u67, true);
    task.delay(2.5, function() -- Line: 375
        -- upvalues: u67 (copy)
        if u67.Parent then
            u67:Destroy();
        end;
    end);
end;

local function fadeWaterOrbBallOnHit(u68) -- Line: 385
    -- upvalues: FXUtil (copy)
    local u69 = u68:FindFirstChild("水球", true);

    for _, descendant in u68:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            if not (u69 and descendant:IsDescendantOf(u69)) then
                descendant.Enabled = false;
            end;
        elseif descendant:IsA("BasePart") then
            descendant.Transparency = 1;
        elseif descendant:IsA("Beam") then
            FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;
    end;

    if u69 then
        task.delay(0.22, function() -- Line: 401
            -- upvalues: u69 (copy), FXUtil (ref)
            if u69.Parent then
                FXUtil.FadeModel_KeepTrails(u69, 0.08, 0);
            end;
        end);
    end;

    task.delay(0.5, function() -- Line: 408
        -- upvalues: u68 (copy)
        if u68.Parent then
            u68:Destroy();
        end;
    end);
end;

function u1.Client_EnterStartup(p70) -- Line: 416
    -- upvalues: SkillCommon (copy)
    local character = p70.skillInputData.character;

    if not character then
        return;
    end;

    local v71 = SkillCommon.resolveWandTipFromCharacter(character);

    if v71 then
        SkillCommon.scheduleWandTipElementTrail(p70, v71, {
            trailMaterialKey = "水系尾迹",
            runEventKey = "水球术Cast尾迹",
            enableAt = 0.27,
            disableAt = 0.27
        });
    end;
end;

function u1.Server_EnterStartup(p72) -- Line: 432
    -- upvalues: SkillCommon (copy)
    local v73 = p72.hitbox[1];

    if v73 and v73.hitbox then
        v73.hitbox.Size = Vector3.new(3, 3, 3) * SkillCommon.skillScaleFromSkillData(p72);
    end;
end;

function u1.Client_EnterProjectileFlying(u74) -- Line: 440
    -- upvalues: PlayerAimSync (copy), u1 (copy), getFormationPivotCF (copy), SkillCommon (copy), resolveTrackingAtCast (copy), createWaterOrbTrackState (copy), FXUtil (copy), VisibleMgr (copy), SoundModule (copy), refreshSharedTrackedEnd (copy), BezierCurve (copy), buildBezierPoints (copy), runTrackedWaterOrbBallMotion (copy), playLocalExplosion (copy), fadeWaterOrbBallOnHit (copy)
    PlayerAimSync.refreshAimSnapshot(u74);
    local character = u74.skillInputData.character;

    if not character then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    local skillRunData = u74.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.waterOrbGen = (skillRunData.Logic.waterOrbGen or 0) + 1;
    local waterOrbGen = skillRunData.Logic.waterOrbGen;
    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Visual.waterBalls = {};
    skillRunData.Visual.ballMotions = {};
    skillRunData.Visual.ownerPredictsExplosions = true;
    local pendingProjectileHitEvent = skillRunData.Visual.pendingProjectileHitEvent;

    if pendingProjectileHitEvent then
        skillRunData.Visual.pendingProjectileHitEvent = nil;
        u1.onServerEvent(u74, pendingProjectileHitEvent);
    end;

    if u74.GetCurrentState and u74:GetCurrentState() ~= "ProjectileFlying" then
        return;
    end;

    local function stillValid() -- Line: 469
        -- upvalues: u74 (copy), waterOrbGen (copy), skillRunData (copy)
        if not u74:isRunningFlow() or u74.runGeneration ~= waterOrbGen then
            return false;
        end;

        if u74.GetCurrentState and u74:GetCurrentState() ~= "ProjectileFlying" then
            return false;
        end;

        return skillRunData.Logic.waterOrbGen == waterOrbGen;
    end;

    local u75 = getFormationPivotCF(character);
    local u76 = u75 and u75.Position or SkillCommon.getHRPStartCF(u74).Position;
    local v77, v78, v79 = resolveTrackingAtCast(u74);

    if v77 and v78 then
        skillRunData.Logic.trackTargetId = v78;
    end;

    local u80 = createWaterOrbTrackState(u74, u76, character, false, v77, v78, v79);
    skillRunData.Logic.waterOrbTrackState = u80;
    local u81 = false;

    local function scheduleFormationFadeAfterLastOrbLaunched() -- Line: 501
        -- upvalues: u81 (ref), skillRunData (copy), FXUtil (ref)
        if u81 then
            return;
        end;

        u81 = true;
        task.delay(0, function() -- Line: 506
            -- upvalues: skillRunData (ref), FXUtil (ref)
            local v82 = skillRunData.Visual and skillRunData.Visual.waterOrbFormationFx;

            if v82 and v82.Parent then
                FXUtil.Stop_All_Emit(v82);

                if v82:IsA("Model") then
                    FXUtil.Model_Fade(v82, 0.45);
                end;

                FXUtil.Slow_Destroy_Instance(v82, 0.45);
            end;

            if skillRunData.Visual then
                skillRunData.Visual.waterOrbFormationFx = nil;
            end;
        end);
    end;

    local u83 = false;

    local function spawnFormationSameFrameAsFirstOrb() -- Line: 523
        -- upvalues: u83 (ref), u74 (copy), waterOrbGen (copy), skillRunData (copy), SkillCommon (ref), u75 (copy), getFormationPivotCF (ref), VisibleMgr (ref), FXUtil (ref), SoundModule (ref)
        if u83 then
            return;
        end;

        u83 = true;
        local v84;

        if u74:isRunningFlow() and u74.runGeneration == waterOrbGen and (not u74.GetCurrentState or u74:GetCurrentState() == "ProjectileFlying") then
            v84 = skillRunData.Logic.waterOrbGen == waterOrbGen;
        else
            v84 = false;
        end;

        if not v84 then
            return;
        end;

        local _, v85 = SkillCommon.scaleDualFromData(u74, SkillCommon.bandScaleOptsFromSkillData(u74));
        local v86 = skillRunData.material["水球术法阵"];

        if v86 then
            v86:ScaleTo(v85 * 1);
            local v87 = u75;

            if not v87 then
                local character2 = u74.skillInputData.character;

                if character2 then
                    v87 = getFormationPivotCF(character2);
                end;
            end;

            if v87 then
                v86:PivotTo(v87);
            end;

            VisibleMgr.UnQueryAll(v86);
            v86.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v86, true);

            if SoundModule then
                SoundModule:PlaySoundLocal({
                    SoundName = "技能_水球术法阵",
                    Is2D = false,
                    PlayPosition = v86:GetPivot().Position
                });
            end;

            skillRunData.Visual.waterOrbFormationFx = v86;
            skillRunData.material["水球术法阵"] = nil;
        end;
    end;

    local u88 = skillRunData.material["水球术水球"];
    local u89 = skillRunData.material["水球术爆炸"];

    if not (u88 and u89) then
        return;
    end;

    local u90, u91 = SkillCommon.scaleDualFromData(u74, SkillCommon.bandScaleOptsFromSkillData(u74));

    for i = 1, 3 do
        task.delay((i - 1) * 0.4, function() -- Line: 570
            -- upvalues: u74 (copy), waterOrbGen (copy), skillRunData (copy), i (copy), spawnFormationSameFrameAsFirstOrb (copy), u76 (copy), refreshSharedTrackedEnd (ref), u80 (copy), BezierCurve (ref), buildBezierPoints (ref), u88 (copy), VisibleMgr (ref), FXUtil (ref), u90 (copy), u91 (copy), runTrackedWaterOrbBallMotion (ref), stillValid (copy), SoundModule (ref), playLocalExplosion (ref), u89 (copy), fadeWaterOrbBallOnHit (ref), u81 (ref)
            local v92;

            if u74:isRunningFlow() and u74.runGeneration == waterOrbGen and (not u74.GetCurrentState or u74:GetCurrentState() == "ProjectileFlying") then
                v92 = skillRunData.Logic.waterOrbGen == waterOrbGen;
            else
                v92 = false;
            end;

            if not v92 then
                return;
            end;

            if i == 1 then
                spawnFormationSameFrameAsFirstOrb();
            end;

            local v93 = u76;
            local v94 = refreshSharedTrackedEnd(u80);
            local v95 = BezierCurve.EstimateFlightTime(buildBezierPoints(v93, v94, i), 60, 1);
            local u96 = u88:Clone();
            VisibleMgr.UnQueryAll(u96);
            table.insert(skillRunData.Visual.waterBalls, u96);

            for _, descendant in pairs(u96:GetDescendants()) do
                if descendant:IsA("Beam") then
                    descendant.Enabled = true;
                    FXUtil.Beam_Fade_From_Transparent(descendant, 0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
                end;
            end;

            FXUtil.Model_Scale_Tween(u96, u90, u91, 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, nil, true);
            u96:PivotTo(CFrame.lookAt(v93, v94));
            u96.Parent = workspace.Debris;
            FXUtil.Start_All_Emit(u96, 10);
            local v99 = runTrackedWaterOrbBallMotion(u96, u80, i, v95, stillValid, function(p97) -- Line: 596
                -- upvalues: u74 (ref), waterOrbGen (ref), skillRunData (ref), SoundModule (ref), playLocalExplosion (ref), u89 (ref), u91 (ref), u96 (copy), fadeWaterOrbBallOnHit (ref)
                local v98;

                if u74:isRunningFlow() and u74.runGeneration == waterOrbGen and (not u74.GetCurrentState or u74:GetCurrentState() == "ProjectileFlying") then
                    v98 = skillRunData.Logic.waterOrbGen == waterOrbGen;
                else
                    v98 = false;
                end;

                if not v98 then
                    return;
                end;

                if SoundModule then
                    SoundModule:PlaySoundLocal({
                        SoundName = "技能_水球术击中",
                        Is2D = false,
                        PlayPosition = p97
                    });
                end;

                playLocalExplosion(u89, p97, u91);

                if u96.Parent then
                    fadeWaterOrbBallOnHit(u96);
                end;
            end);

            if v99 then
                table.insert(skillRunData.Visual.ballMotions, v99);
            end;

            if i == 3 then
                if u81 then
                    return;
                end;

                u81 = true;
                task.delay(0, function() -- Line: 506
                    -- upvalues: skillRunData (ref), FXUtil (ref)
                    local v100 = skillRunData.Visual and skillRunData.Visual.waterOrbFormationFx;

                    if v100 and v100.Parent then
                        FXUtil.Stop_All_Emit(v100);

                        if v100:IsA("Model") then
                            FXUtil.Model_Fade(v100, 0.45);
                        end;

                        FXUtil.Slow_Destroy_Instance(v100, 0.45);
                    end;

                    if skillRunData.Visual then
                        skillRunData.Visual.waterOrbFormationFx = nil;
                    end;
                end);
            end;
        end);
    end;
end;

function u1.Client_ExitProjectileFlying(p101) -- Line: 623
    local skillRunData = p101.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.waterOrbGen = (skillRunData.Logic.waterOrbGen or 0) + 1;
    local _ = skillRunData.Logic.waterOrbGen;
    local v102 = skillRunData.Visual and skillRunData.Visual.ballMotions;

    if v102 then
        for _, v in v102 do
            if v and v.Disconnect then
                v:Disconnect();
            end;
        end;

        skillRunData.Visual.ballMotions = {};
    end;
end;

local function serverPulseExplosion(u103, p104, u105, u106) -- Line: 640
    -- upvalues: SkillEventConst (copy), SkillCommon (copy), FXUtil (copy)
    local u107 = u103.hitbox[1];
    local v108 = u103.skillRunData and u103.skillRunData.Logic;

    if not u107 or (not v108 or v108.waterOrbGen ~= u105) then
        if u106 and (v108 and (v108.waterOrbGen == u105 and u103.skillRunData.State.current == "ProjectileFlying")) then
            task.delay(0.28, function() -- Line: 352
                -- upvalues: u103 (copy), u105 (copy), SkillEventConst (ref)
                local skillRunData = u103.skillRunData;
                local v109;

                if skillRunData then
                    v109 = skillRunData.Logic;
                else
                    v109 = skillRunData;
                end;

                if not v109 or v109.waterOrbGen ~= u105 then
                    return;
                end;

                if skillRunData.State.current ~= "ProjectileFlying" then
                    return;
                end;

                u103:TryTransition(SkillEventConst.Timeout, nil);
            end);
        end;

        return;
    end;

    v108.waterOrbPulseAllowDamage = true;
    local hitbox = u107.hitbox;
    hitbox.Size = Vector3.new(3, 3, 3) * SkillCommon.skillScaleFromSkillData(u103);
    hitbox.Transparency = 1;
    hitbox:PivotTo(CFrame.new(p104));
    u107:start(true);
    FXUtil.BasePart_Size_Tween(hitbox, 0.11, Vector3.new(9, 9, 9) * SkillCommon.skillScaleFromSkillData(u103), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    task.delay(0.12, function() -- Line: 658
        -- upvalues: u107 (copy), hitbox (copy), u103 (copy), u106 (copy), u105 (copy), SkillEventConst (ref)
        if u107.isActive then
            u107:stop();
            hitbox.Transparency = 1;
        end;

        local v110 = u103.skillRunData and u103.skillRunData.Logic;

        if v110 then
            v110.waterOrbPulseAllowDamage = false;
        end;

        if not u106 then
            return;
        end;

        local v111 = u103.skillRunData and u103.skillRunData.Logic;

        if v111 and (v111.waterOrbGen == u105 and u103.skillRunData.State.current == "ProjectileFlying") then
            local u112 = u103;
            local u113 = u105;
            task.delay(0.28, function() -- Line: 352
                -- upvalues: u112 (copy), u113 (copy), SkillEventConst (ref)
                local skillRunData = u112.skillRunData;
                local v114;

                if skillRunData then
                    v114 = skillRunData.Logic;
                else
                    v114 = skillRunData;
                end;

                if not v114 or v114.waterOrbGen ~= u113 then
                    return;
                end;

                if skillRunData.State.current ~= "ProjectileFlying" then
                    return;
                end;

                u112:TryTransition(SkillEventConst.Timeout, nil);
            end);
        end;
    end);
    u103:fireProjectileHitConfirmed(p104, SkillEventConst.HitType.Timeout, nil);
end;

function u1.Server_EnterProjectileFlying(p115) -- Line: 679
    -- upvalues: PlayerAimSync (copy), getFormationPivotCF (copy), SkillCommon (copy), resolveTrackingAtCast (copy), createWaterOrbTrackState (copy), ProjectileCore (copy), BezierCurve (copy), buildBezierPoints (copy)
    PlayerAimSync.refreshAimSnapshot(p115);
    local skillRunData = p115.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.waterOrbGen = (skillRunData.Logic.waterOrbGen or 0) + 1;
    local waterOrbGen = skillRunData.Logic.waterOrbGen;
    local character = p115.character;
    local v116;

    if character then
        local v117 = getFormationPivotCF(character);

        if v117 then
            v116 = v117.Position;
        else
            v116 = SkillCommon.getHRPStartCF(p115).Position;
        end;
    else
        v116 = SkillCommon.getHRPStartCF(p115).Position;
    end;

    local v118, v119, v120 = resolveTrackingAtCast(p115);

    if v118 and v119 then
        skillRunData.Logic.trackTargetId = v119;
    end;

    skillRunData.Logic.waterOrbTrackState = createWaterOrbTrackState(p115, v116, character, true, v118, v119, v120);
    skillRunData.Logic.waterOrbPulseAllowDamage = false;
    skillRunData.Logic.waterOrbSimGen = waterOrbGen;
    local waterOrbTrackState = skillRunData.Logic.waterOrbTrackState;
    local v121 = {};

    for i = 1, 3 do
        local v122 = waterOrbTrackState and waterOrbTrackState.lastEnd;

        if not v122 then
            local skillInputData = p115.skillInputData;
            local v123;

            if skillInputData and skillInputData.targetCF then
                v123 = skillInputData.targetCF.Position;
            else
                v123 = nil;
            end;

            v122 = ProjectileCore.clampProjectileEndToMaxRange(v116, v123 or Vector3.new(0, 0, 0), 60, 1);
        end;

        local v124 = BezierCurve.EstimateFlightTime(buildBezierPoints(v116, v122, i), 60, 1);
        table.insert(v121, {
            motionStarted = false,
            done = false,
            ballIndex = i,
            launchAt = (i - 1) * 0.4,
            moveTime = v124,
            startPos = v116,
            lastPos = v116,
            isLast = i == 3
        });
    end;

    skillRunData.Logic.waterOrbSims = v121;
end;

function u1.Server_UpdateProjectileObstacleCheck(p125) -- Line: 746
    -- upvalues: refreshSharedTrackedEnd (copy), ProjectileCore (copy), TweenService (copy), buildBezierPoints (copy), rayObstacleSegment (copy), serverPulseExplosion (copy)
    local skillRunData = p125.skillRunData;

    if not skillRunData or skillRunData.State.current ~= "ProjectileFlying" then
        return;
    end;

    local Logic = skillRunData.Logic;

    if not Logic or (not Logic.waterOrbSims or Logic.waterOrbGen ~= Logic.waterOrbSimGen) then
        return;
    end;

    local character = p125.character;
    local v126 = p125.nowTime - skillRunData.State.enteredAt;
    local v127 = {};

    if character then
        v127[1] = character;
    end;

    local waterOrbTrackState = Logic.waterOrbTrackState;

    if waterOrbTrackState then
        refreshSharedTrackedEnd(waterOrbTrackState, p125.nowTime);
    end;

    local v128 = waterOrbTrackState and waterOrbTrackState.lastEnd;

    if not v128 then
        local skillInputData = p125.skillInputData;
        local v129;

        if skillInputData and skillInputData.targetCF then
            v129 = skillInputData.targetCF.Position;
        else
            v129 = nil;
        end;

        v128 = ProjectileCore.clampProjectileEndToMaxRange(Logic.waterOrbSims[1].startPos, v129 or Vector3.new(0, 0, 0), 60, 1);
    end;

    for _, v in Logic.waterOrbSims do
        if not v.done then
            if v126 >= v.launchAt then
                if not v.motionStarted then
                    v.motionStarted = true;
                    v.lastPos = v.startPos;
                end;

                local v130 = math.min(v126 - v.launchAt, v.moveTime) / v.moveTime;
                local v131 = TweenService:GetValue(v130, Enum.EasingStyle.Quint, Enum.EasingDirection.In);
                local v132 = buildBezierPoints(v.startPos, v128, v.ballIndex);
                local v133 = ProjectileCore.evaluateBezierPoint(v132, v131);
                local v134 = (v133 - v.lastPos).Magnitude > 0.01 and rayObstacleSegment(v.lastPos, v133, v127);

                if v134 then
                    v.done = true;
                    serverPulseExplosion(p125, v134.Position, Logic.waterOrbSimGen, v.isLast);
                end;

                if not v.done then
                    v.lastPos = v133;
                end;

                if not v.done and v130 >= 0.999999 then
                    v.done = true;
                    serverPulseExplosion(p125, v128, Logic.waterOrbSimGen, v.isLast);
                end;
            end;
        end;
    end;
end;

function u1.Server_ExitProjectileFlying(p135) -- Line: 803
    local skillRunData = p135.skillRunData;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};
        skillRunData.Logic.waterOrbGen = (skillRunData.Logic.waterOrbGen or 0) + 1;
        local _ = skillRunData.Logic.waterOrbGen;
    end;
end;

function u1.Server_EnterRecovery(p136) -- Line: 811
    p136:releaseControl();
end;

function u1.Client_EnterRecovery(p137) -- Line: 815
    -- upvalues: SkillCommon (copy)
    local skillRunData = p137.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "水球术Cast尾迹");
    end;
end;

function u1.onServerEvent(p138, p139) -- Line: 826
    -- upvalues: SkillEventConst (copy), Players (copy), SkillCommon (copy), SoundModule (copy), playLocalExplosion (copy)
    if p139.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p138.skillRunData;

    if not skillRunData then
        return;
    end;

    local LocalPlayer = Players.LocalPlayer;

    if LocalPlayer and (p138.skillInputData and (p138.skillInputData.characterType == "Player" and (p138.skillInputData.characterId == LocalPlayer.UserId and (skillRunData.Visual and skillRunData.Visual.ownerPredictsExplosions)))) then
        return;
    end;

    local hitPosition = p139.hitPosition;

    if not hitPosition then
        return;
    end;

    local v140 = skillRunData.material and skillRunData.material["水球术爆炸"];

    if v140 then
        local _, v141 = SkillCommon.scaleDualFromData(p138, SkillCommon.bandScaleOptsFromSkillData(p138));

        if SoundModule then
            SoundModule:PlaySoundLocal({
                SoundName = "技能_水球术击中",
                Is2D = false,
                PlayPosition = hitPosition
            });
        end;

        playLocalExplosion(v140, hitPosition, v141);
    end;
end;

function u1.onProjectileHitServer(p142, p143, p144) -- Line: 863
    -- upvalues: HitResolver (copy)
    if not p143 or p143.hitboxIndex ~= 1 then
        return;
    end;

    local skillRunData = p142.skillRunData;

    if not skillRunData or (not skillRunData.State or skillRunData.State.current ~= "ProjectileFlying") then
        return;
    end;

    local Logic = skillRunData.Logic;

    if not (Logic and Logic.waterOrbPulseAllowDamage) then
        return;
    end;

    for i, v in p144 do
        HitResolver.applyHit(p142, p143, v, i);
    end;
end;

function u1.onEnd(p145) -- Line: 880
    -- upvalues: SkillCommon (copy), u1 (copy), FXUtil (copy)
    local skillRunData = p145.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "水球术Cast尾迹");
    u1.Client_ExitProjectileFlying(p145);
    local v146 = skillRunData.Visual and skillRunData.Visual.waterOrbFormationFx;

    if v146 and v146.Parent then
        FXUtil.Stop_All_Emit(v146);
        FXUtil.Slow_Destroy_Instance(v146, 0.12);
    end;

    if skillRunData.Visual then
        skillRunData.Visual.waterOrbFormationFx = nil;
    end;

    local v147 = skillRunData.Visual and skillRunData.Visual.waterBalls;

    if v147 then
        for _, v in v147 do
            if v and v.Parent then
                v:Destroy();
            end;
        end;

        if skillRunData.Visual then
            skillRunData.Visual.waterBalls = {};
        end;
    end;
end;

function u1.onEndServer(p148) -- Line: 908
    local skillRunData = p148.skillRunData;

    if skillRunData then
        skillRunData.Logic = skillRunData.Logic or {};
        skillRunData.Logic.waterOrbGen = (skillRunData.Logic.waterOrbGen or 0) + 1;
        local _ = skillRunData.Logic.waterOrbGen;
    end;
end;

u1.SoundList = { "技能_水球术法阵", "技能_水球术击中" };
u1.AnimateList = { "技能释放动作3" };
u1.ResNameList = { "水系尾迹", "水球术水球", "水球术法阵", "水球术爆炸" };
u1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "水属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    } };
u1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.47,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.27,
        animationName = "技能释放动作3",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;