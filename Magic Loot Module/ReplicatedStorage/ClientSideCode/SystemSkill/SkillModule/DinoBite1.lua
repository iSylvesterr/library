-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local BurstStone = UtilsSystem.BurstStone;
local AnimationModule = UtilsSystem.AnimationModule;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2.5,
    skillElementType = ElementTp.Earth,
    skillDistanceLimit = 55
};
local u2 = { "恐龙咬人_头骨模型1", "恐龙咬人_头骨模型2" };

local function hitboxShortPulseOnce(p3, p4, p5) -- Line: 67
    local u6 = p3.hitbox[1];

    if not (u6 and u6.hitbox) then
        return;
    end;

    u6.hitbox.Size = Vector3.new(p5, p5, p5);
    u6.hitbox:PivotTo(CFrame.new(p4));
    u6:start();
    task.delay(0.12, function() -- Line: 75
        -- upvalues: u6 (copy)
        if u6.isActive then
            u6:stop();
        end;
    end);
end;

local function resolveImpactPos(p7, p8, p9) -- Line: 91
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p7);
    local skillRunData = p7.skillRunData;
    local v10 = SkillCommon.resolveTrackTargetHrp(p8);

    if v10 then
        local Position = SkillCommon.getGroundCF(CFrame.new(v10.Position), 4, p9, "Ground").Position;

        if skillRunData then
            skillRunData.lastImpactPos = Position;
        end;

        return Position;
    end;

    if skillRunData and typeof(skillRunData.lastImpactPos) == "Vector3" then
        return skillRunData.lastImpactPos;
    end;

    local v11 = SkillCommon.resolveStrikeGroundWorldPos(p8, 4, p9, "Ground");

    if skillRunData then
        skillRunData.lastImpactPos = v11;
    end;

    return v11;
end;

local function emitFxOnce(p12, p13, p14, p15) -- Line: 119
    -- upvalues: VisibleMgr (copy), SkillCommon (copy), FXUtil (copy)
    local v16 = p12.material and p12.material[p13];

    if not v16 then
        return;
    end;

    v16:ScaleTo(p15);
    VisibleMgr.UnQueryAll(v16);
    v16:PivotTo(CFrame.new(p14) * v16:GetPivot().Rotation);
    v16.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p12, "DinoBiteSpawned", v16);
    FXUtil.Emit_Particles_GetDescendants(v16, true);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.467,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 1.546,
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

function v1.Client_EnterStartup(u17) -- Line: 173
    -- upvalues: SkillCommon (copy), resolveImpactPos (copy), u2 (copy), VisibleMgr (copy), AnimationModule (copy), FXUtil (copy), emitFxOnce (copy), BurstStone (copy)
    local skillInputData = u17.skillInputData;
    local v18;

    if skillInputData then
        v18 = skillInputData.character;
    else
        v18 = skillInputData;
    end;

    if not v18 then
        return;
    end;

    local runGeneration = u17.runGeneration;
    local skillRunData = u17.skillRunData;
    local u19 = SkillCommon.scaleBandFromData(u17, SkillCommon.bandScaleOptsFromSkillData(u17));
    local HumanoidRootPart = v18:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        SkillCommon.playSoundLocal3D("音效-技能-巨噬", HumanoidRootPart.Position);
    end;

    local v20 = SkillCommon.resolveWandTipFromCharacter(v18);

    if v20 then
        SkillCommon.scheduleWandTipElementTrail(u17, v20, {
            trailMaterialKey = "土系尾迹",
            runEventKey = "恐龙咬人Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.8
        });
    end;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    resolveImpactPos(u17, skillInputData, 1.5);
    task.delay(0.117, function() -- Line: 207
        -- upvalues: SkillCommon (ref), u17 (copy), runGeneration (copy), resolveImpactPos (ref), skillInputData (copy), u2 (ref), skillRunData (copy), u19 (copy), VisibleMgr (ref), AnimationModule (ref), FXUtil (ref), emitFxOnce (ref), BurstStone (ref)
        if not SkillCommon.isRunningSameGeneration(u17, runGeneration) then
            return;
        end;

        local v21 = resolveImpactPos(u17, skillInputData, 1.5);
        local u22 = {};

        for _, v in ipairs(u2) do
            local v23 = skillRunData.material[v];
            skillRunData.material[v] = nil;
            v23:ScaleTo(v23:GetScale() * u19);
            VisibleMgr.UnQueryAll(v23);
            VisibleMgr.SnapshotDefaultVisualState(v23);
            VisibleMgr.UnTransparencyAll(v23);

            for _, descendant in ipairs(v23:GetDescendants()) do
                if descendant:IsA("Decal") or descendant:IsA("Texture") then
                    descendant.Transparency = 1;
                end;
            end;

            v23:PivotTo(CFrame.new(v21) * v23:GetPivot().Rotation);
            v23.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "DinoBiteSpawned", v23);
            table.insert(u22, v23);
        end;

        skillRunData.Visual = skillRunData.Visual or {};
        skillRunData.Visual.skullModels = u22;
        task.delay(0.017, function() -- Line: 236
            -- upvalues: SkillCommon (ref), u17 (ref), runGeneration (ref), resolveImpactPos (ref), skillInputData (ref), u22 (copy), AnimationModule (ref), VisibleMgr (ref), FXUtil (ref), skillRunData (ref), emitFxOnce (ref), u19 (ref), BurstStone (ref)
            if not SkillCommon.isRunningSameGeneration(u17, runGeneration) then
                return;
            end;

            local v24 = resolveImpactPos(u17, skillInputData, 1.5);

            for _, v in ipairs(u22) do
                v:PivotTo(CFrame.new(v24) * v:GetPivot().Rotation);
                AnimationModule.PlayAnimByModel(v, "恐龙咬人动作", 1, nil, nil, Enum.AnimationPriority.Action4, 0);
            end;

            task.spawn(function() -- Line: 248
                -- upvalues: SkillCommon (ref), u17 (ref), runGeneration (ref), u22 (ref), VisibleMgr (ref)
                task.wait();

                if not SkillCommon.isRunningSameGeneration(u17, runGeneration) then
                    return;
                end;

                for _, v in ipairs(u22) do
                    VisibleMgr.RestoreDefaultVisualState(v);
                end;
            end);
            task.delay(1, function() -- Line: 259
                -- upvalues: SkillCommon (ref), u17 (ref), runGeneration (ref), u22 (ref), FXUtil (ref)
                if not SkillCommon.isRunningSameGeneration(u17, runGeneration) then
                    return;
                end;

                for _, v in ipairs(u22) do
                    FXUtil.Model_Fade(v, 0.8);
                end;
            end);
            task.delay(1.8, function() -- Line: 268
                -- upvalues: SkillCommon (ref), u17 (ref), runGeneration (ref), u22 (ref), skillRunData (ref)
                if not SkillCommon.isRunningSameGeneration(u17, runGeneration) then
                    return;
                end;

                for _, v in ipairs(u22) do
                    SkillCommon.removeFromRunSpawnList(skillRunData, "DinoBiteSpawned", v);
                    v:Destroy();
                end;

                if skillRunData.Visual then
                    skillRunData.Visual.skullModels = nil;
                end;
            end);
            task.delay(0.28, function() -- Line: 282
                -- upvalues: SkillCommon (ref), u17 (ref), runGeneration (ref), resolveImpactPos (ref), skillInputData (ref), emitFxOnce (ref), skillRunData (ref), u19 (ref), BurstStone (ref)
                if not SkillCommon.isRunningSameGeneration(u17, runGeneration) then
                    return;
                end;

                local v25 = resolveImpactPos(u17, skillInputData, 0.5);
                emitFxOnce(skillRunData, "恐龙咬人_地面特效", v25, u19);
                local v26 = CFrame.new(v25);
                local v27 = 0.6229166666666666 * u19;
                BurstStone.CreateLandBreak(v26, "DinoBite", v27);
                BurstStone.CreateStoneFly(v26, "DinoBiteFly", v27);
            end);
        end);
    end);
end;

function v1.Client_EnterMain(u28) -- Line: 297
    -- upvalues: SkillCommon (copy), resolveImpactPos (copy), VisibleMgr (copy), FXUtil (copy), emitFxOnce (copy)
    local skillInputData = u28.skillInputData;
    local v29;

    if skillInputData then
        v29 = skillInputData.character;
    else
        v29 = skillInputData;
    end;

    if not v29 then
        return;
    end;

    local HumanoidRootPart = v29:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u28.runGeneration;
    local skillRunData = u28.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local u30 = SkillCommon.scaleBandFromData(u28, SkillCommon.bandScaleOptsFromSkillData(u28));
    resolveImpactPos(u28, skillInputData, 1.5);
    local v31 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -6 * u30));
    local Position = SkillCommon.getGroundCF(v31, 4, 2, "Ground").Position;
    local v32 = skillRunData.material["恐龙咬人_法阵"];

    if v32 then
        v32:ScaleTo(u30);
        VisibleMgr.UnQueryAll(v32);
        v32:PivotTo(CFrame.new(Position) * v32:GetPivot().Rotation);
        v32.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "DinoBiteSpawned", v32);
        FXUtil.Emit_Particles_GetDescendants(v32, true);
        SkillCommon.playSoundLocal3D("音效-技能-地法阵", v32:GetPivot().Position);
    end;

    task.delay(0.227, function() -- Line: 334
        -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), skillRunData (copy), emitFxOnce (ref), u30 (copy)
        if not SkillCommon.isRunningSameGeneration(u28, runGeneration) then
            return;
        end;

        local v33 = skillRunData.Visual and skillRunData.Visual.skullModels;

        if v33 then
            v33 = v33[1];
        end;

        if v33 then
            v33 = v33:FindFirstChild("HumanoidRootPart");
        end;

        if v33 then
            emitFxOnce(skillRunData, "恐龙咬人_咬人爆炸", v33.Position + Vector3.new(0, 11.2 * u30, 0), u30);
        end;
    end);
    SkillCommon.scheduleRunSpawnClear(u28, runGeneration, skillRunData, "DinoBiteSpawned", 2);
end;

function v1.Client_ExitMain(p34) -- Line: 350
    -- upvalues: SkillCommon (copy)
    local skillRunData = p34.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p34, p34.runGeneration, skillRunData, "DinoBiteSpawned");
    end;
end;

function v1.Client_EnterRecovery(p35) -- Line: 357
    -- upvalues: SkillCommon (copy)
    local skillRunData = p35.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "土系尾迹", "恐龙咬人Cast尾迹");
    end;
end;

function v1.onEnd(p36) -- Line: 364
    -- upvalues: SkillCommon (copy)
    local skillRunData = p36.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "土系尾迹", "恐龙咬人Cast尾迹");
end;

function v1.Server_EnterStartup(p37) -- Line: 373
    -- upvalues: SkillCommon (copy)
    local v38 = SkillCommon.scaleBandFromData(p37, SkillCommon.bandScaleOptsFromSkillData(p37));
    local v39 = p37.hitbox[1];

    if v39 and v39.hitbox then
        local v40 = 26 * v38;
        local hitbox = v39.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = Vector3.new(v40, v40, v40);
    end;
end;

function v1.Server_EnterMain(u41) -- Line: 386
    -- upvalues: SkillCommon (copy), resolveImpactPos (copy), hitboxShortPulseOnce (copy)
    local skillInputData = u41.skillInputData;

    if not skillInputData then
        return;
    end;

    local runGeneration = u41.runGeneration;
    local u42 = SkillCommon.scaleBandFromData(u41, SkillCommon.bandScaleOptsFromSkillData(u41));
    resolveImpactPos(u41, skillInputData, 1.5);
    task.delay(0.227, function() -- Line: 396
        -- upvalues: u41 (copy), runGeneration (copy), resolveImpactPos (ref), skillInputData (copy), u42 (copy), hitboxShortPulseOnce (ref)
        if not u41:isRunningFlow() or u41.runGeneration ~= runGeneration then
            return;
        end;

        hitboxShortPulseOnce(u41, resolveImpactPos(u41, skillInputData, 1.5) + Vector3.new(0, 11.2 * u42, 0), 26 * u42);
    end);
end;

function v1.Server_ExitMain(p43) -- Line: 406
    local v44 = p43.hitbox[1];

    if v44 and v44.isActive then
        v44:stop();
    end;
end;

function v1.Server_EnterRecovery(p45) -- Line: 413
    p45:releaseControl();
end;

function v1.onEndServer(p46) -- Line: 417
    local v47 = p46.hitbox[1];

    if v47 and v47.isActive then
        v47:stop();
    end;
end;

v1.SoundList = { "音效-技能-巨噬", "音效-技能-地法阵" };
v1.AnimateList = { "技能释放动作9", "恐龙咬人动作" };
v1.ResNameList = { "土系尾迹", "恐龙咬人_法阵", "恐龙咬人_地面特效", "恐龙咬人_头骨模型1", "恐龙咬人_头骨模型2", "恐龙咬人_咬人爆炸" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
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
        overTime = 0.467,
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