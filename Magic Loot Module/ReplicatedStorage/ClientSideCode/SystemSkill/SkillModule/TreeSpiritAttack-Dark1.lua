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
local u1 = { 13.896, 12.359, 15.237 };
local u2 = {
    skillTotalTime = -1,
    visualFadeoutTime = 3,
    skillElementType = ElementTp.Earth,
    skillSizeScale = 0.5,
    InitialState = "Startup",
    ControlOpenState = "Main",
    States = {
        Startup = {
            Duration = 0.56,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Main = {
            Duration = 4.1,
            OnEnterClient = "Client_EnterMain",
            OnEnterServer = "Server_EnterMain"
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

local function getSkillScale(p3) -- Line: 77
    -- upvalues: SkillCommon (copy), u2 (copy)
    local v4 = p3.skillInputData and p3.skillInputData.character;
    local v5 = v4 and v4:GetScale() or 1;
    local v6 = SkillCommon.scaleBandFromData(p3, SkillCommon.bandScaleOptsFromSkillData(p3));
    local skillSizeScale = u2.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        return v6 * skillSizeScale * v5;
    end;

    return v6 * v5;
end;

local function spikeSpawnCFFromLayout(p7, p8) -- Line: 89
    if p8 == 1 or p8 == 2 then
        return p7 * CFrame.Angles(0, 0, 3.141592653589793);
    end;

    return p7;
end;

local function resolveSpikeRoot(p9) -- Line: 96
    local Root = p9:FindFirstChild("Root");

    if Root and Root:IsA("BasePart") then
        p9.PrimaryPart = Root;

        return Root;
    end;

    local v10 = p9.PrimaryPart or p9:FindFirstChildWhichIsA("BasePart", true);

    if v10 then
        p9.PrimaryPart = v10;
    end;

    return v10;
end;

local function spikeHalfHeight(p11, p12, p13, p14) -- Line: 109
    -- upvalues: u1 (copy)
    local v15 = p11:FindFirstChild(p13) or p11:FindFirstChild(p13, true);

    if v15 and (v15:IsA("BasePart") and v15.Size.Y > 0.05) then
        return v15.Size.Y * 0.5;
    end;

    return (u1[p12] or u1[3]) * p14 * 0.5;
end;

local function emitAppearFxOnceAtStrikeGround(p16, p17, p18, p19, p20) -- Line: 118
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy)
    local v21 = p18.material["花御木刺_出现特效-暗"];

    if not v21 then
        return;
    end;

    if not SkillCommon.isRunningSameGeneration(p16, p17) then
        return;
    end;

    local v22 = v21:Clone();

    if v22:IsA("Model") then
        v22:ScaleTo(p20);
    end;

    VisibleMgr.UnQueryAll(v22);
    local Rotation = v22:GetPivot().Rotation;
    SkillCommon.pivotInstanceToWorldCF(v22, CFrame.new(p19) * Rotation);
    v22.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p18, "HanamiWoodSpikeSpawned", v22);
    FXUtil.Emit_Particles_GetDescendants(v22, true);
end;

local function emitRingMeteorStoneBurst(p23, p24, p25, p26) -- Line: 141
    -- upvalues: BurstStone (copy)
    local v27 = BurstStone;

    if not v27 then
        return;
    end;

    local Rotation = CFrame.lookAt(Vector3.new(0, 0, 0), p24, Vector3.new(0, 1, 0)).Rotation;
    local v28 = CFrame.new(p23) * Rotation;
    local v29 = p25 * 0.4444444444444444 * (p26 / 8);
    v27.CreateLandBreak(v28, "HanamiWoodMeteorEnwind", v29);
    v27.CreateStoneFly(v28, "HanamiWoodMeteor", v29);
end;

local function spawnOneStick(u30, u31, p32, p33, p34) -- Line: 154
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), spikeHalfHeight (copy), FXUtil (copy), TweenService (copy)
    local material = p32.material;
    local v35 = math.random(1, 3);
    local v36 = "花御木刺" .. v35 .. "-暗";
    local v37 = material[v36];

    if not v37 then
        return;
    end;

    if v35 == 1 or v35 == 2 then
        p33 = p33 * CFrame.Angles(0, 0, 3.141592653589793);
    end;

    local u38 = v37:Clone();

    local function u39() -- Line: 166
        -- upvalues: SkillCommon (ref), u30 (copy), u31 (copy)
        return SkillCommon.isRunningSameGeneration(u30, u31);
    end;

    if not u38:IsA("Model") then
        if not u38:IsA("BasePart") then
            u38:Destroy();

            return;
        end;

        u38.Size = u38.Size * p34;
        VisibleMgr.UnQueryAll(u38);
        VisibleMgr.UnTouchAll(u38);
        VisibleMgr.TransparencyAll(u38);
        VisibleMgr.UnCollideAll(u38);
        VisibleMgr.AnchoredAll(u38);
        local Position = p33.Position;
        local v40 = Vector3.new(0, u38.Size.Y * 0.5, 0);
        local u41 = CFrame.new(Position - v40) * p33.Rotation;
        local v42 = CFrame.new(Position + v40) * p33.Rotation;
        u38.CFrame = u41;
        u38.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(p32, "HanamiWoodSpikeSpawned", u38);
        local u43 = TweenService:Create(u38, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            CFrame = v42
        });
        u43:Play();
        u43.Completed:Once(function() -- Line: 258
            -- upvalues: u43 (copy)
            u43:Destroy();
        end);
        task.delay(1, function() -- Line: 262
            -- upvalues: SkillCommon (ref), u30 (copy), u31 (copy), u38 (copy), TweenService (ref), u38 (copy), u41 (copy)
            if not SkillCommon.isRunningSameGeneration(u30, u31) then
                if u38.Parent then
                    u38:Destroy();
                end;

                return;
            end;

            local u44 = TweenService:Create(u38, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {
                CFrame = u41
            });
            u44:Play();
            u44.Completed:Once(function() -- Line: 275
                -- upvalues: u44 (copy), u38 (ref)
                u44:Destroy();

                if u38.Parent then
                    u38:Destroy();
                end;
            end);
        end);

        return;
    end;

    u38:ScaleTo(p34);
    local Root = u38:FindFirstChild("Root");

    if Root and Root:IsA("BasePart") then
        u38.PrimaryPart = Root;
    else
        Root = u38.PrimaryPart or u38:FindFirstChildWhichIsA("BasePart", true);

        if Root then
            u38.PrimaryPart = Root;
        end;
    end;

    if not Root then
        u38:Destroy();

        return;
    end;

    VisibleMgr.UnQueryAll(u38);
    VisibleMgr.UnTouchAll(u38);
    VisibleMgr.TransparencyAll(u38);
    VisibleMgr.UnCollideAll(u38);
    VisibleMgr.AnchoredAll(u38);
    local v45 = spikeHalfHeight(u38, v35, v36, p34);
    local Position = p33.Position;
    local Rotation = p33.Rotation;
    local v46 = Vector3.new(0, v45, 0);
    local u47 = CFrame.new(Position - v46) * Rotation;
    local v48 = CFrame.new(Position + v46) * Rotation;
    u38:PivotTo(u47);
    u38.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p32, "HanamiWoodSpikeSpawned", u38);
    FXUtil.Pivot_Instance_CF_Lerp_Heartbeat(u38, 0.2, v48, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, u39);
    task.delay(1, function() -- Line: 204
        -- upvalues: SkillCommon (ref), u30 (copy), u31 (copy), u38 (copy), FXUtil (ref), u38 (copy), u47 (copy), u39 (copy)
        if not SkillCommon.isRunningSameGeneration(u30, u31) then
            if u38.Parent then
                u38:Destroy();
            end;

            return;
        end;

        FXUtil.Pivot_Instance_CF_Lerp_Heartbeat(u38, 0.8, u47, Enum.EasingStyle.Exponential, Enum.EasingDirection.In, u39);
        task.delay(0.8, function() -- Line: 219
            -- upvalues: u38 (ref)
            if u38.Parent then
                u38:Destroy();
            end;
        end);
    end);
end;

local function spawnWoodRing(p49, p50, p51, p52, p53, p54, p55, p56) -- Line: 284
    -- upvalues: spawnOneStick (copy)
    local Rotation = CFrame.lookAt(Vector3.new(0, 0, 0), p53, Vector3.new(0, 1, 0)).Rotation;
    local v57 = CFrame.new(p52) * Rotation;
    local v58 = p55 * p56;

    for i = 1, p54 do
        spawnOneStick(p49, p50, p51, (v57 * CFrame.Angles(0, math.rad((i - 1) * 360 / p54), 0)):ToWorldSpace(CFrame.new(0, 0, -v58) * CFrame.Angles(0, 3.141592653589793, 0)), p56);
    end;
end;

function u2.Client_EnterStartup(p59) -- Line: 305
    -- upvalues: SkillCommon (copy)
    local v60 = p59.skillInputData and p59.skillInputData.character;

    if not v60 then
        return;
    end;

    local v61 = SkillCommon.resolveWandTipFromCharacter(v60);

    if v61 then
        SkillCommon.scheduleWandTipElementTrail(p59, v61, {
            trailMaterialKey = "地系尾迹2",
            runEventKey = "花御木刺Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.6
        });
    end;
end;

function u2.Server_EnterStartup(p62) -- Line: 322
    local v63 = p62.hitbox[1];

    if v63 and v63.hitbox then
        local hitbox = v63.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = Vector3.new(48, 48, 48);
    end;
end;

function u2.Client_EnterMain(u64) -- Line: 333
    -- upvalues: getSkillScale (copy), SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), emitAppearFxOnceAtStrikeGround (copy), emitRingMeteorStoneBurst (copy), spawnWoodRing (copy)
    local skillInputData = u64.skillInputData;
    local v65;

    if skillInputData then
        v65 = skillInputData.character;
    else
        v65 = skillInputData;
    end;

    local skillRunData = u64.skillRunData;

    if not (v65 and (skillRunData and skillRunData.material)) then
        return;
    end;

    local runGeneration = u64.runGeneration;
    local HumanoidRootPart = v65:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u66 = getSkillScale(u64);
    local u67 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 0.5, "Ground");
    local _, u68 = SkillCommon.horizontalHrpStrikeFlatBasis(HumanoidRootPart, u67);
    local u69 = skillRunData.material["花御木刺_法阵-暗"];

    local function emitCasterFormOnce() -- Line: 351
        -- upvalues: u69 (copy), u66 (copy), VisibleMgr (ref), SkillCommon (ref), HumanoidRootPart (copy), skillRunData (copy), FXUtil (ref)
        if not u69 then
            return;
        end;

        local v70 = u69:Clone();

        if v70:IsA("Model") then
            v70:ScaleTo(u66);
        end;

        VisibleMgr.UnQueryAll(v70);
        local v71 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.35, "Ground");
        local Rotation = v70:GetPivot().Rotation;

        if v70:IsA("Model") then
            v70:PivotTo(CFrame.new(v71) * Rotation);
        else
            SkillCommon.pivotInstanceToWorldCF(v70, CFrame.new(v71) * Rotation);
        end;

        v70.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "HanamiWoodSpikeSpawned", v70);
        FXUtil.Emit_Particles_GetDescendants(v70, true);
        SkillCommon.playSoundLocal3D("音效-技能-木系法阵", v70:GetPivot().Position);
    end;

    task.delay(0.05, function() -- Line: 373
        -- upvalues: SkillCommon (ref), u64 (copy), runGeneration (copy), emitCasterFormOnce (copy)
        if not SkillCommon.isRunningSameGeneration(u64, runGeneration) then
            return;
        end;

        emitCasterFormOnce();
    end);
    task.delay(0.25, function() -- Line: 379
        -- upvalues: SkillCommon (ref), u64 (copy), runGeneration (copy), emitAppearFxOnceAtStrikeGround (ref), skillRunData (copy), u67 (copy), u66 (copy), emitRingMeteorStoneBurst (ref), u68 (copy), spawnWoodRing (ref)
        if not SkillCommon.isRunningSameGeneration(u64, runGeneration) then
            return;
        end;

        emitAppearFxOnceAtStrikeGround(u64, runGeneration, skillRunData, u67, u66);
        SkillCommon.playSoundLocal3D("音效-技能-木3花御木刺-攻击", u67);
        emitRingMeteorStoneBurst(u67, u68, u66, 8);
        spawnWoodRing(u64, runGeneration, skillRunData, u67, u68, 8, 8, u66);
    end);
    task.delay(0.35, function() -- Line: 388
        -- upvalues: SkillCommon (ref), u64 (copy), runGeneration (copy), emitRingMeteorStoneBurst (ref), u67 (copy), u68 (copy), u66 (copy), spawnWoodRing (ref), skillRunData (copy)
        if not SkillCommon.isRunningSameGeneration(u64, runGeneration) then
            return;
        end;

        emitRingMeteorStoneBurst(u67, u68, u66, 16);
        spawnWoodRing(u64, runGeneration, skillRunData, u67, u68, 16, 16, u66);
    end);
    task.delay(0.45, function() -- Line: 395
        -- upvalues: SkillCommon (ref), u64 (copy), runGeneration (copy), emitRingMeteorStoneBurst (ref), u67 (copy), u68 (copy), u66 (copy), spawnWoodRing (ref), skillRunData (copy)
        if not SkillCommon.isRunningSameGeneration(u64, runGeneration) then
            return;
        end;

        emitRingMeteorStoneBurst(u67, u68, u66, 24);
        spawnWoodRing(u64, runGeneration, skillRunData, u67, u68, 24, 24, u66);
    end);
end;

function u2.Server_EnterMain(u72) -- Line: 404
    -- upvalues: SkillCommon (copy), getSkillScale (copy)
    local u73 = u72.hitbox[1];

    if not u73 then
        return;
    end;

    local u74 = SkillCommon.resolveStruckTargetGroundWorldPos(u72.skillInputData, 4, 0.5, "Ground");
    local runGeneration = u72.runGeneration;
    local u75 = getSkillScale(u72);
    task.delay(0.25, function() -- Line: 415
        -- upvalues: u72 (copy), runGeneration (copy), u75 (copy), u73 (copy), u74 (copy)
        if not u72:isRunningFlow() or u72.runGeneration ~= runGeneration then
            return;
        end;

        local v76 = u75 * 48;
        local v77 = Vector3.new(v76, v76, v76);
        u73.hitbox:PivotTo(CFrame.new(u74));
        u73.hitbox.Size = v77;
        u73:start();
        task.delay(0.55, function() -- Line: 424
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

function u2.Server_EnterRecovery(p78) -- Line: 436
    p78:releaseControl();
end;

function u2.Client_EnterRecovery(p79) -- Line: 440
    -- upvalues: SkillCommon (copy)
    local skillRunData = p79.skillRunData;

    if skillRunData and skillRunData.material then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "地系尾迹2", "花御木刺Cast尾迹");
    end;
end;

function u2.onEnd(p80) -- Line: 447
    -- upvalues: SkillCommon (copy)
    local skillRunData = p80.skillRunData;

    if skillRunData then
        SkillCommon.clearRunSpawnList(skillRunData, "HanamiWoodSpikeSpawned");
    end;
end;

function u2.onEndServer(p81) -- Line: 454
    local v82 = p81.hitbox and p81.hitbox[1];

    if v82 and v82.isActive then
        v82:stop();
    end;
end;

u2.SoundList = { "音效-技能-木系法阵", "音效-技能-木3花御木刺-攻击" };
u2.AnimateList = { "树灵树枝攻击" };
u2.ResNameList = { "地系尾迹2", "花御木刺_法阵-暗", "花御木刺_出现特效-暗", "花御木刺1-暗", "花御木刺2-暗", "花御木刺3-暗" };
u2.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
u2.Action = {
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
        animationName = "树灵树枝攻击",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u2;