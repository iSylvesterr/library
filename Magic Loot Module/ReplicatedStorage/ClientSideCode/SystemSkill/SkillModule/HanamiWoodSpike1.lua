-- Decompiled with Potassium's decompiler.

local TweenService = game:GetService("TweenService");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local BurstStone = UtilsSystem.BurstStone;
local SkillCommon = require(script.Parent._Templates.SkillCommon);

local function lockStrikeAtHitTime(p1) -- Line: 39
    -- upvalues: SkillCommon (copy)
    return SkillCommon.commitLockedStrike(p1, "hanamiWoodSpikeLocked", {
        rayUp = 4,
        lift = 0.5,
        rayTag = "Ground"
    });
end;

local function getCachedLockedStrike(p2) -- Line: 47
    if p2 and p2.Logic then
        return p2.Logic.hanamiWoodSpikeLocked;
    end;

    return nil;
end;

local u3 = { 13.896, 12.359, 15.237 };
local v4 = {
    skillTotalTime = -1,
    visualFadeoutTime = 3,
    skillElementType = ElementTp.Earth,
    InitialState = "Startup",
    ControlOpenState = "Main",
    States = {
        Startup = {
            Duration = 0.25,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Main = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterMain",
            OnEnterServer = "Server_EnterMain",
            OnExitClient = "Client_ExitMain"
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
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "Main",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Main",
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
            From = "Main",
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
            From = "Main",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        }
    }
};

local function spikeSpawnCFFromLayout(p5, p6) -- Line: 104
    if p6 == 1 or p6 == 2 then
        return p5 * CFrame.Angles(0, 0, 3.141592653589793);
    end;

    return p5;
end;

local function resolveSpikeRoot(p7) -- Line: 111
    local Root = p7:FindFirstChild("Root");

    if Root and Root:IsA("BasePart") then
        p7.PrimaryPart = Root;

        return Root;
    end;

    local v8 = p7.PrimaryPart or p7:FindFirstChildWhichIsA("BasePart", true);

    if v8 then
        p7.PrimaryPart = v8;
    end;

    return v8;
end;

local function spikeHalfHeight(p9, p10, p11, p12) -- Line: 124
    -- upvalues: u3 (copy)
    local v13 = p9:FindFirstChild(p11) or p9:FindFirstChild(p11, true);

    if v13 and (v13:IsA("BasePart") and v13.Size.Y > 0.05) then
        return v13.Size.Y * 0.5;
    end;

    return (u3[p10] or u3[3]) * p12 * 0.5;
end;

local function emitAppearFxOnceAtStrikeGround(p14, p15, p16, p17, p18) -- Line: 133
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy)
    local v19 = p16.material["花御木刺_出现特效"];

    if not v19 then
        return;
    end;

    if not SkillCommon.isRunningSameGeneration(p14, p15) then
        return;
    end;

    local v20 = v19:Clone();

    if v20:IsA("Model") then
        v20:ScaleTo(p18);
    end;

    VisibleMgr.UnQueryAll(v20);
    local Rotation = v20:GetPivot().Rotation;
    SkillCommon.pivotInstanceToWorldCF(v20, CFrame.new(p17) * Rotation);
    v20.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p16, "HanamiWoodSpikeSpawned", v20);
    FXUtil.Emit_Particles_GetDescendants(v20, true);
end;

local function emitRingMeteorStoneBurst(p21, p22, p23, p24) -- Line: 156
    -- upvalues: BurstStone (copy)
    local v25 = BurstStone;

    if not v25 then
        return;
    end;

    local Rotation = CFrame.lookAt(Vector3.new(0, 0, 0), p22, Vector3.new(0, 1, 0)).Rotation;
    local v26 = CFrame.new(p21) * Rotation;
    local v27 = p23 * 0.4444444444444444 * (p24 / 8);
    v25.CreateLandBreak(v26, "HanamiWoodMeteorEnwind", v27);
    v25.CreateStoneFly(v26, "HanamiWoodMeteor", v27);
end;

local function spawnOneStick(u28, u29, p30, p31, p32) -- Line: 169
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), spikeHalfHeight (copy), FXUtil (copy), TweenService (copy)
    local material = p30.material;
    local v33 = math.random(1, 3);
    local v34 = "花御木刺" .. v33;
    local v35 = material[v34];

    if not v35 then
        return;
    end;

    if v33 == 1 or v33 == 2 then
        p31 = p31 * CFrame.Angles(0, 0, 3.141592653589793);
    end;

    local u36 = v35:Clone();

    local function u37() -- Line: 181
        -- upvalues: SkillCommon (ref), u28 (copy), u29 (copy)
        return SkillCommon.isRunningSameGeneration(u28, u29);
    end;

    if not u36:IsA("Model") then
        if not u36:IsA("BasePart") then
            u36:Destroy();

            return;
        end;

        u36.Size = u36.Size * p32;
        VisibleMgr.UnQueryAll(u36);
        VisibleMgr.UnTouchAll(u36);
        VisibleMgr.TransparencyAll(u36);
        VisibleMgr.UnCollideAll(u36);
        VisibleMgr.AnchoredAll(u36);
        local Position = p31.Position;
        local v38 = Vector3.new(0, u36.Size.Y * 0.5, 0);
        local u39 = CFrame.new(Position - v38) * p31.Rotation;
        local v40 = CFrame.new(Position + v38) * p31.Rotation;
        u36.CFrame = u39;
        u36.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(p30, "HanamiWoodSpikeSpawned", u36);
        local u41 = TweenService:Create(u36, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            CFrame = v40
        });
        u41:Play();
        u41.Completed:Once(function() -- Line: 273
            -- upvalues: u41 (copy)
            u41:Destroy();
        end);
        task.delay(1, function() -- Line: 277
            -- upvalues: SkillCommon (ref), u28 (copy), u29 (copy), u36 (copy), TweenService (ref), u36 (copy), u39 (copy)
            if not SkillCommon.isRunningSameGeneration(u28, u29) then
                if u36.Parent then
                    u36:Destroy();
                end;

                return;
            end;

            local u42 = TweenService:Create(u36, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                CFrame = u39
            });
            u42:Play();
            u42.Completed:Once(function() -- Line: 290
                -- upvalues: u42 (copy), u36 (ref)
                u42:Destroy();

                if u36.Parent then
                    u36:Destroy();
                end;
            end);
        end);

        return;
    end;

    u36:ScaleTo(p32);
    local Root = u36:FindFirstChild("Root");

    if Root and Root:IsA("BasePart") then
        u36.PrimaryPart = Root;
    else
        Root = u36.PrimaryPart or u36:FindFirstChildWhichIsA("BasePart", true);

        if Root then
            u36.PrimaryPart = Root;
        end;
    end;

    if not Root then
        u36:Destroy();

        return;
    end;

    VisibleMgr.UnQueryAll(u36);
    VisibleMgr.UnTouchAll(u36);
    VisibleMgr.TransparencyAll(u36);
    VisibleMgr.UnCollideAll(u36);
    VisibleMgr.AnchoredAll(u36);
    local v43 = spikeHalfHeight(u36, v33, v34, p32);
    local Position = p31.Position;
    local Rotation = p31.Rotation;
    local v44 = Vector3.new(0, v43, 0);
    local u45 = CFrame.new(Position - v44) * Rotation;
    local v46 = CFrame.new(Position + v44) * Rotation;
    u36:PivotTo(u45);
    u36.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p30, "HanamiWoodSpikeSpawned", u36);
    FXUtil.Pivot_Instance_CF_Lerp_Heartbeat(u36, 0.2, v46, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, u37);
    task.delay(1, function() -- Line: 219
        -- upvalues: SkillCommon (ref), u28 (copy), u29 (copy), u36 (copy), FXUtil (ref), u36 (copy), u45 (copy), u37 (copy)
        if not SkillCommon.isRunningSameGeneration(u28, u29) then
            if u36.Parent then
                u36:Destroy();
            end;

            return;
        end;

        FXUtil.Pivot_Instance_CF_Lerp_Heartbeat(u36, 0.8, u45, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, u37);
        task.delay(0.8, function() -- Line: 234
            -- upvalues: u36 (ref)
            if u36.Parent then
                u36:Destroy();
            end;
        end);
    end);
end;

local function spawnWoodRing(p47, p48, p49, p50, p51, p52, p53, p54) -- Line: 299
    -- upvalues: spawnOneStick (copy)
    local Rotation = CFrame.lookAt(Vector3.new(0, 0, 0), p51, Vector3.new(0, 1, 0)).Rotation;
    local v55 = CFrame.new(p50) * Rotation;
    local v56 = p53 * p54;

    for i = 1, p52 do
        spawnOneStick(p47, p48, p49, (v55 * CFrame.Angles(0, math.rad((i - 1) * 360 / p52), 0)):ToWorldSpace(CFrame.new(0, 0, -v56) * CFrame.Angles(0, 3.141592653589793, 0)), p54);
    end;
end;

function v4.Client_EnterStartup(p57) -- Line: 320
    -- upvalues: SkillCommon (copy)
    local v58 = p57.skillInputData and p57.skillInputData.character;

    if not v58 then
        return;
    end;

    local v59 = SkillCommon.resolveWandTipFromCharacter(v58);

    if v59 then
        SkillCommon.scheduleWandTipElementTrail(p57, v59, {
            trailMaterialKey = "地系尾迹2",
            runEventKey = "花御木刺Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.6
        });
    end;
end;

function v4.Server_EnterStartup(p60) -- Line: 337
    local v61 = p60.hitbox[1];

    if v61 and v61.hitbox then
        local hitbox = v61.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = Vector3.new(53, 53, 53);
    end;
end;

function v4.Client_EnterMain(u62) -- Line: 348
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), emitAppearFxOnceAtStrikeGround (copy), emitRingMeteorStoneBurst (copy), spawnWoodRing (copy)
    local skillInputData = u62.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    local skillRunData = u62.skillRunData;

    if not (skillInputData and (skillRunData and skillRunData.material)) then
        return;
    end;

    local runGeneration = u62.runGeneration;
    local HumanoidRootPart = skillInputData:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u63 = SkillCommon.scaleBandFromData(u62, SkillCommon.bandScaleOptsFromSkillData(u62));
    local u64 = skillRunData.material["花御木刺_法阵"];

    local function emitCasterFormOnce() -- Line: 364
        -- upvalues: u64 (copy), u63 (copy), VisibleMgr (ref), SkillCommon (ref), HumanoidRootPart (copy), skillRunData (copy), FXUtil (ref)
        if not u64 then
            return;
        end;

        local v65 = u64:Clone();

        if v65:IsA("Model") then
            v65:ScaleTo(u63);
        end;

        VisibleMgr.UnQueryAll(v65);
        local v66 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.35, "Ground");
        local Rotation = v65:GetPivot().Rotation;

        if v65:IsA("Model") then
            v65:PivotTo(CFrame.new(v66) * Rotation);
        else
            SkillCommon.pivotInstanceToWorldCF(v65, CFrame.new(v66) * Rotation);
        end;

        v65.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "HanamiWoodSpikeSpawned", v65);
        FXUtil.Emit_Particles_GetDescendants(v65, true);
        SkillCommon.playSoundLocal3D("音效-技能-木系法阵", v65:GetPivot().Position);
    end;

    task.delay(0.05, function() -- Line: 386
        -- upvalues: SkillCommon (ref), u62 (copy), runGeneration (copy), emitCasterFormOnce (copy)
        if not SkillCommon.isRunningSameGeneration(u62, runGeneration) then
            return;
        end;

        emitCasterFormOnce();
    end);
    task.delay(0.25, function() -- Line: 392
        -- upvalues: SkillCommon (ref), u62 (copy), runGeneration (copy), emitAppearFxOnceAtStrikeGround (ref), skillRunData (copy), u63 (copy), emitRingMeteorStoneBurst (ref), spawnWoodRing (ref)
        if not SkillCommon.isRunningSameGeneration(u62, runGeneration) then
            return;
        end;

        local v67 = SkillCommon.commitLockedStrike(u62, "hanamiWoodSpikeLocked", {
            rayUp = 4,
            lift = 0.5,
            rayTag = "Ground"
        });
        local groundCenter = v67.groundCenter;
        local forward = v67.forward;
        emitAppearFxOnceAtStrikeGround(u62, runGeneration, skillRunData, groundCenter, u63);
        SkillCommon.playSoundLocal3D("音效-技能-木3花御木刺-攻击", groundCenter);
        emitRingMeteorStoneBurst(groundCenter, forward, u63, 8);
        spawnWoodRing(u62, runGeneration, skillRunData, groundCenter, forward, 8, 8, u63);
    end);
    task.delay(0.35, function() -- Line: 404
        -- upvalues: SkillCommon (ref), u62 (copy), runGeneration (copy), skillRunData (copy), emitRingMeteorStoneBurst (ref), u63 (copy), spawnWoodRing (ref)
        if not SkillCommon.isRunningSameGeneration(u62, runGeneration) then
            return;
        end;

        local v68 = skillRunData;
        local v69;

        if v68 and v68.Logic then
            v69 = v68.Logic.hanamiWoodSpikeLocked;
        else
            v69 = nil;
        end;

        if not v69 then
            return;
        end;

        local groundCenter = v69.groundCenter;
        local forward = v69.forward;
        emitRingMeteorStoneBurst(groundCenter, forward, u63, 16);
        spawnWoodRing(u62, runGeneration, skillRunData, groundCenter, forward, 16, 16, u63);
    end);
    task.delay(0.45, function() -- Line: 417
        -- upvalues: SkillCommon (ref), u62 (copy), runGeneration (copy), skillRunData (copy), emitRingMeteorStoneBurst (ref), u63 (copy), spawnWoodRing (ref)
        if not SkillCommon.isRunningSameGeneration(u62, runGeneration) then
            return;
        end;

        local v70 = skillRunData;
        local v71;

        if v70 and v70.Logic then
            v71 = v70.Logic.hanamiWoodSpikeLocked;
        else
            v71 = nil;
        end;

        if not v71 then
            return;
        end;

        local groundCenter = v71.groundCenter;
        local forward = v71.forward;
        emitRingMeteorStoneBurst(groundCenter, forward, u63, 24);
        spawnWoodRing(u62, runGeneration, skillRunData, groundCenter, forward, 24, 24, u63);
    end);
    SkillCommon.scheduleRunSpawnClear(u62, runGeneration, skillRunData, "HanamiWoodSpikeSpawned", 4.1);
end;

function v4.Server_EnterMain(u72) -- Line: 434
    -- upvalues: SkillCommon (copy)
    local u73 = u72.hitbox[1];

    if not u73 then
        return;
    end;

    local runGeneration = u72.runGeneration;
    local u74 = SkillCommon.scaleBandFromData(u72, SkillCommon.bandScaleOptsFromSkillData(u72));
    task.delay(0.25, function() -- Line: 442
        -- upvalues: u72 (copy), runGeneration (copy), SkillCommon (ref), u74 (copy), u73 (copy)
        if not u72:isRunningFlow() or u72.runGeneration ~= runGeneration then
            return;
        end;

        local groundCenter = SkillCommon.commitLockedStrike(u72, "hanamiWoodSpikeLocked", {
            rayUp = 4,
            lift = 0.5,
            rayTag = "Ground"
        }).groundCenter;
        local v75 = 53 * u74;
        local v76 = Vector3.new(v75, v75, v75);
        u73.hitbox:PivotTo(CFrame.new(groundCenter));
        u73.hitbox.Size = v76;
        u73:start();
        task.delay(0.55, function() -- Line: 453
            -- upvalues: u72 (ref), runGeneration (ref), u73 (ref)
            if not u72:isRunningFlow() or u72.runGeneration ~= runGeneration then
                return;
            end;

            if u73.isActive then
                u73:stop();
                u73.hitbox.Transparency = 1;
            end;
        end);
    end);
end;

function v4.Client_ExitMain(p77) -- Line: 465
    -- upvalues: SkillCommon (copy)
    local skillRunData = p77.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p77, p77.runGeneration, skillRunData, "HanamiWoodSpikeSpawned");
    end;
end;

function v4.Server_EnterRecovery(p78) -- Line: 472
    p78:releaseControl();
end;

function v4.Client_EnterRecovery(p79) -- Line: 476
    -- upvalues: SkillCommon (copy)
    local skillRunData = p79.skillRunData;

    if skillRunData and skillRunData.material then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "地系尾迹2", "花御木刺Cast尾迹");
    end;
end;

function v4.onEnd(p80) -- Line: 483
end;

function v4.onEndServer(p81) -- Line: 486
    local v82 = p81.hitbox and p81.hitbox[1];

    if v82 and v82.isActive then
        v82:stop();
    end;
end;

v4.SoundList = { "音效-技能-木系法阵", "音效-技能-木3花御木刺-攻击" };
v4.AnimateList = { "技能释放动作10" };
v4.ResNameList = { "地系尾迹2", "花御木刺_法阵", "花御木刺_出现特效", "花御木刺1", "花御木刺2", "花御木刺3" };
v4.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "地属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    } };
v4.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.25,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.57,
        animationName = "技能释放动作10",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v4;