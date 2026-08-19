-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local BurstStone = UtilsSystem.BurstStone;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth,
    skillDistanceLimit = 55
};

local function hitboxShortPulseOnce(p2, p3, p4, p5) -- Line: 42
    local u6 = p2.hitbox[p3];

    if not (u6 and u6.hitbox) then
        return;
    end;

    u6.hitbox.Size = Vector3.new(p5, p5, p5);
    u6.hitbox:PivotTo(CFrame.new(p4));
    u6:start();
    task.delay(0.12, function() -- Line: 50
        -- upvalues: u6 (copy)
        if u6.isActive then
            u6:stop();
        end;
    end);
end;

local function resolveImpactPos(p7, p8) -- Line: 65
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p7);
    local skillRunData = p7.skillRunData;
    local v9 = SkillCommon.resolveTrackTargetHrp(p8);

    if v9 then
        local Position = SkillCommon.getGroundCF(CFrame.new(v9.Position), 4, 0.5, "Ground").Position;

        if skillRunData then
            skillRunData.lastImpactPos = Position;
        end;

        return Position;
    end;

    if skillRunData and typeof(skillRunData.lastImpactPos) == "Vector3" then
        return skillRunData.lastImpactPos;
    end;

    local v10 = SkillCommon.resolveStrikeGroundWorldPos(p8, 4, 0.5, "Ground");

    if skillRunData then
        skillRunData.lastImpactPos = v10;
    end;

    return v10;
end;

local function emitStrikeFxOnce(p11, p12, p13, p14) -- Line: 94
    -- upvalues: VisibleMgr (copy), SkillCommon (copy), FXUtil (copy)
    local v15 = p11.material and p11.material[p12];

    if not v15 then
        return;
    end;

    v15:ScaleTo(p14);
    VisibleMgr.UnQueryAll(v15);
    v15:PivotTo(CFrame.new(p13) * v15:GetPivot().Rotation);
    v15.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p11, "DinoTrampleSpawned", v15);
    FXUtil.Emit_Particles_GetDescendants(v15, true);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.47,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 1.1866666666666668,
        OnEnterClient = "Client_EnterMain",
        OnEnterServer = "Server_EnterMain",
        OnExitClient = "Client_ExitMain",
        OnExitServer = "Server_ExitMain"
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
};
v1.Transitions = {
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
};

function v1.Client_EnterStartup(p16) -- Line: 148
    -- upvalues: SkillCommon (copy)
    local v17 = p16.skillInputData and p16.skillInputData.character;

    if not v17 then
        return;
    end;

    local v18 = SkillCommon.resolveWandTipFromCharacter(v17);

    if v18 then
        SkillCommon.scheduleWandTipElementTrail(p16, v18, {
            trailMaterialKey = "土系尾迹",
            runEventKey = "恐龙踩踏Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.8
        });
    end;
end;

function v1.Client_EnterMain(u19) -- Line: 165
    -- upvalues: SkillCommon (copy), resolveImpactPos (copy), VisibleMgr (copy), FXUtil (copy), emitStrikeFxOnce (copy), BurstStone (copy)
    local skillInputData = u19.skillInputData;
    local v20;

    if skillInputData then
        v20 = skillInputData.character;
    else
        v20 = skillInputData;
    end;

    if not v20 then
        return;
    end;

    local HumanoidRootPart = v20:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u19.runGeneration;
    local skillRunData = u19.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local u21 = SkillCommon.scaleBandFromData(u19, SkillCommon.bandScaleOptsFromSkillData(u19));
    resolveImpactPos(u19, skillInputData);
    local v22 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -4 * u21));
    local Position = SkillCommon.getGroundCF(v22, 4, 0.5, "Ground").Position;
    local v23 = skillRunData.material["恐龙踩踏_法阵"];

    if v23 then
        v23:ScaleTo(u21);
        VisibleMgr.UnQueryAll(v23);
        v23:PivotTo(CFrame.new(Position) * v23:GetPivot().Rotation);
        v23.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "DinoTrampleSpawned", v23);
        FXUtil.Emit_Particles_GetDescendants(v23, true);
        SkillCommon.playSoundLocal3D("音效-技能-地法阵", v23:GetPivot().Position);
    end;

    task.delay(0.03333333333333333, function() -- Line: 202
        -- upvalues: SkillCommon (ref), u19 (copy), runGeneration (copy), emitStrikeFxOnce (ref), skillRunData (copy), resolveImpactPos (ref), skillInputData (copy), u21 (copy)
        if not SkillCommon.isRunningSameGeneration(u19, runGeneration) then
            return;
        end;

        emitStrikeFxOnce(skillRunData, "恐龙踩踏_打击特效1", resolveImpactPos(u19, skillInputData), u21);
    end);
    task.delay(0.43333333333333335, function() -- Line: 209
        -- upvalues: SkillCommon (ref), u19 (copy), runGeneration (copy), emitStrikeFxOnce (ref), skillRunData (copy), resolveImpactPos (ref), skillInputData (copy), u21 (copy)
        if not SkillCommon.isRunningSameGeneration(u19, runGeneration) then
            return;
        end;

        emitStrikeFxOnce(skillRunData, "恐龙踩踏_打击特效2", resolveImpactPos(u19, skillInputData), u21);
    end);
    task.delay(0.9333333333333333, function() -- Line: 216
        -- upvalues: SkillCommon (ref), u19 (copy), runGeneration (copy), emitStrikeFxOnce (ref), skillRunData (copy), resolveImpactPos (ref), skillInputData (copy), u21 (copy)
        if not SkillCommon.isRunningSameGeneration(u19, runGeneration) then
            return;
        end;

        emitStrikeFxOnce(skillRunData, "恐龙踩踏_打击特效3", resolveImpactPos(u19, skillInputData), u21);
    end);
    task.delay(0.11666666666666667, function() -- Line: 226
        -- upvalues: SkillCommon (ref), u19 (copy), runGeneration (copy), resolveImpactPos (ref), skillInputData (copy), u21 (copy), BurstStone (ref)
        if not SkillCommon.isRunningSameGeneration(u19, runGeneration) then
            return;
        end;

        local v24 = resolveImpactPos(u19, skillInputData);
        local v25 = CFrame.new(v24);
        local v26 = 0.5270833333333332 * u21;
        BurstStone.CreateLandBreak(v25, "DinoTrample", v26);
        BurstStone.CreateStoneFly(v25, "DinoTrampleFly", v26);
        SkillCommon.playSoundLocal3D("音效-恐龙踩踏-第一下", v24);
    end);
    task.delay(0.5166666666666667, function() -- Line: 238
        -- upvalues: SkillCommon (ref), u19 (copy), runGeneration (copy), resolveImpactPos (ref), skillInputData (copy), u21 (copy), BurstStone (ref)
        if not SkillCommon.isRunningSameGeneration(u19, runGeneration) then
            return;
        end;

        local v27 = resolveImpactPos(u19, skillInputData);
        local v28 = CFrame.new(v27);
        local v29 = 0.8145833333333333 * u21;
        BurstStone.CreateLandBreak(v28, "DinoTrample", v29);
        BurstStone.CreateStoneFly(v28, "DinoTrampleFly", v29);
        SkillCommon.playSoundLocal3D("音效-恐龙踩踏-第二下", v27);
    end);
    task.delay(1.0166666666666666, function() -- Line: 250
        -- upvalues: SkillCommon (ref), u19 (copy), runGeneration (copy), resolveImpactPos (ref), skillInputData (copy), u21 (copy), BurstStone (ref)
        if not SkillCommon.isRunningSameGeneration(u19, runGeneration) then
            return;
        end;

        local v30 = resolveImpactPos(u19, skillInputData);
        local v31 = CFrame.new(v30);
        local v32 = 1.1020833333333333 * u21;
        BurstStone.CreateLandBreak(v31, "DinoTrample", v32);
        BurstStone.CreateStoneFly(v31, "DinoTrampleFly", v32);
        SkillCommon.playSoundLocal3D("音效-恐龙踩踏-第三下", v30);
    end);
    SkillCommon.scheduleRunSpawnClear(u19, runGeneration, skillRunData, "DinoTrampleSpawned", 3);
end;

function v1.Client_ExitMain(p33) -- Line: 266
    -- upvalues: SkillCommon (copy)
    local skillRunData = p33.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p33, p33.runGeneration, skillRunData, "DinoTrampleSpawned");
    end;
end;

function v1.Client_EnterRecovery(p34) -- Line: 273
    -- upvalues: SkillCommon (copy)
    local skillRunData = p34.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "土系尾迹", "恐龙踩踏Cast尾迹");
    end;
end;

function v1.onEnd(p35) -- Line: 280
    -- upvalues: SkillCommon (copy)
    local skillRunData = p35.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "土系尾迹", "恐龙踩踏Cast尾迹");
end;

function v1.Server_EnterStartup(p36) -- Line: 289
    -- upvalues: SkillCommon (copy)
    local v37 = SkillCommon.scaleBandFromData(p36, SkillCommon.bandScaleOptsFromSkillData(p36));
    local v38 = p36.hitbox[1];
    local v39 = p36.hitbox[2];
    local v40 = p36.hitbox[3];

    if v38 and v38.hitbox then
        local v41 = 22 * v37;
        v38.hitbox.Size = Vector3.new(v41, v41, v41);
    end;

    if v39 and v39.hitbox then
        local v42 = 34 * v37;
        v39.hitbox.Size = Vector3.new(v42, v42, v42);
    end;

    if v40 and v40.hitbox then
        local v43 = 46 * v37;
        v40.hitbox.Size = Vector3.new(v43, v43, v43);
    end;
end;

function v1.Server_EnterMain(u44) -- Line: 307
    -- upvalues: SkillCommon (copy), resolveImpactPos (copy), hitboxShortPulseOnce (copy)
    local skillInputData = u44.skillInputData;

    if not skillInputData then
        return;
    end;

    local runGeneration = u44.runGeneration;
    local u45 = SkillCommon.scaleBandFromData(u44, SkillCommon.bandScaleOptsFromSkillData(u44));
    resolveImpactPos(u44, skillInputData);
    task.delay(0.11666666666666667, function() -- Line: 318
        -- upvalues: u44 (copy), runGeneration (copy), hitboxShortPulseOnce (ref), resolveImpactPos (ref), skillInputData (copy), u45 (copy)
        if not u44:isRunningFlow() or u44.runGeneration ~= runGeneration then
            return;
        end;

        hitboxShortPulseOnce(u44, 1, resolveImpactPos(u44, skillInputData), 22 * u45);
    end);
    task.delay(0.5166666666666667, function() -- Line: 325
        -- upvalues: u44 (copy), runGeneration (copy), hitboxShortPulseOnce (ref), resolveImpactPos (ref), skillInputData (copy), u45 (copy)
        if not u44:isRunningFlow() or u44.runGeneration ~= runGeneration then
            return;
        end;

        hitboxShortPulseOnce(u44, 2, resolveImpactPos(u44, skillInputData), 34 * u45);
    end);
    task.delay(1.0166666666666666, function() -- Line: 332
        -- upvalues: u44 (copy), runGeneration (copy), hitboxShortPulseOnce (ref), resolveImpactPos (ref), skillInputData (copy), u45 (copy)
        if not u44:isRunningFlow() or u44.runGeneration ~= runGeneration then
            return;
        end;

        hitboxShortPulseOnce(u44, 3, resolveImpactPos(u44, skillInputData), 46 * u45);
    end);
end;

function v1.Server_ExitMain(p46) -- Line: 340
    local v47 = p46.hitbox[1];

    if v47 and v47.isActive then
        v47:stop();
    end;

    local v48 = p46.hitbox[2];

    if v48 and v48.isActive then
        v48:stop();
    end;

    local v49 = p46.hitbox[3];

    if v49 and v49.isActive then
        v49:stop();
    end;
end;

function v1.Server_EnterRecovery(p50) -- Line: 349
    p50:releaseControl();
end;

function v1.onEndServer(p51) -- Line: 353
    local v52 = p51.hitbox[1];

    if v52 and v52.isActive then
        v52:stop();
    end;

    local v53 = p51.hitbox[2];

    if v53 and v53.isActive then
        v53:stop();
    end;

    local v54 = p51.hitbox[3];

    if v54 and v54.isActive then
        v54:stop();
    end;
end;

v1.SoundList = { "音效-技能-地法阵", "音效-恐龙踩踏-第一下", "音效-恐龙踩踏-第二下", "音效-恐龙踩踏-第三下" };
v1.AnimateList = { "技能释放动作9" };
v1.ResNameList = { "土系尾迹", "恐龙踩踏_法阵", "恐龙踩踏_打击特效1", "恐龙踩踏_打击特效2", "恐龙踩踏_打击特效3" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "地属性受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "地属性受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 3,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "地属性受击",
        PhysicsEffectName = "中等力度受击物理效果",
        CameraShakeProfile = "中等碰撞震"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.47,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.57,
        animationName = "技能释放动作9",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;