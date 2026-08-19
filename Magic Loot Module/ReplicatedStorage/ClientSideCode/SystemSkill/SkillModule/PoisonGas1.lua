-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Poison,
    skillDistanceLimit = 50
};
local u2 = { 0.033, 0.326, 0.618, 0.911, 1.203, 1.496, 1.789, 2.081, 2.374, 2.666 };

local function resolveTargetStrikePos(p3, p4) -- Line: 43
    -- upvalues: SkillCommon (copy)
    local v5 = SkillCommon.resolveStrikeHeadAnchorLive(p3, p4);

    return SkillCommon.strikeHeadAnchorTargetPos(v5);
end;

local function borrowPooledBurst(p6) -- Line: 49
    -- upvalues: FXUtil (copy), UtilsSystem (copy)
    if not (p6 and p6:IsA("Model")) then
        return nil;
    end;

    local v7 = FXUtil.GetInstance_From_Pool(p6);

    if not (v7 and v7:IsA("Model")) then
        return nil;
    end;

    local ResRestore = UtilsSystem.ResRestore;

    if ResRestore and ResRestore.Restore then
        ResRestore.Restore(v7);
    end;

    FXUtil.PreparePooledModelForReuse(v7, p6);

    return v7;
end;

local function emitBurstAtTarget(p8, p9, u10, p11, p12, p13, p14, p15) -- Line: 66
    -- upvalues: SkillCommon (copy), borrowPooledBurst (copy), VisibleMgr (copy), FXUtil (copy)
    if not SkillCommon.isRunningSameGeneration(p8, p9) then
        return;
    end;

    local v16 = u10.material[p14];

    if not (v16 and v16:IsA("Model")) then
        return;
    end;

    local v17 = SkillCommon.resolveStrikeHeadAnchorLive(p11, p13);
    local v18 = SkillCommon.strikeHeadAnchorTargetPos(v17);
    local u19 = borrowPooledBurst(v16);

    if not u19 then
        return;
    end;

    u19:ScaleTo(p12);
    VisibleMgr.UnQueryAll(u19);
    u19:PivotTo(CFrame.new(v18) * u19:GetPivot().Rotation);
    u19.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(u10, "PoisonGasBurstPool", u19);
    local v20 = SkillCommon.findDescendantByName(u19, "Emit_Burst") or u19;
    FXUtil.EmitBurstEmitInName(v20, true);

    if p15 then
        SkillCommon.playSoundLocal3D(p14 == "毒气_大毒爆" and "音效-技能-毒气-大毒爆" or "音效-技能-毒气-小毒爆", v18);
    end;

    task.delay(2, function() -- Line: 99
        -- upvalues: u19 (copy), FXUtil (ref), SkillCommon (ref), u10 (copy)
        if u19.Parent then
            FXUtil.BackPool_Instance(u19);
            SkillCommon.removeFromRunSpawnList(u10, "PoisonGasBurstPool", u19);
        end;
    end);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.25,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 4.667,
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

function v1.Client_EnterStartup(p21) -- Line: 144
    -- upvalues: SkillCommon (copy)
    local v22 = p21.skillInputData and p21.skillInputData.character;

    if not v22 then
        return;
    end;

    local v23 = SkillCommon.resolveWandTipFromCharacter(v22);

    if v23 then
        SkillCommon.scheduleWandTipElementTrail(p21, v23, {
            trailMaterialKey = "毒系尾迹",
            runEventKey = "毒气Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.6
        });
    end;
end;

function v1.Server_EnterStartup(p24) -- Line: 160
    -- upvalues: SkillCommon (copy)
    local v25 = p24.hitbox[1];

    if not (v25 and v25.hitbox) then
        return;
    end;

    local v26 = SkillCommon.scaleBandFromData(p24, SkillCommon.bandScaleOptsFromSkillData(p24));
    local hitbox = v25.hitbox;

    if hitbox:IsA("BasePart") then
        hitbox.Shape = Enum.PartType.Ball;
    end;

    hitbox.Size = Vector3.new(5, 5, 5) * v26;
    hitbox:PivotTo(CFrame.new(0, -5000, 0));
end;

function v1.Client_EnterMain(u27) -- Line: 174
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), RunService (copy), u2 (copy), emitBurstAtTarget (copy)
    local skillInputData = u27.skillInputData;
    local v28;

    if skillInputData then
        v28 = skillInputData.character;
    else
        v28 = skillInputData;
    end;

    local skillRunData = u27.skillRunData;

    if not (v28 and (skillInputData and (skillRunData and skillRunData.material))) then
        return;
    end;

    local HumanoidRootPart = v28:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u27.runGeneration;
    local u29 = SkillCommon.scaleBandFromData(u27, SkillCommon.bandScaleOptsFromSkillData(u27));
    local v30 = HumanoidRootPart:GetPivot() * CFrame.new(0, 1.4, -2);
    local v31 = skillRunData.material["毒气_法阵"];

    if v31 and v31:IsA("Model") then
        v31:ScaleTo(u29);
        VisibleMgr.UnQueryAll(v31);
        SkillCommon.pivotModelAtFormationAnchor(v30, v31, v31:GetPivot() - v31:GetPivot().Position);
        v31.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "PoisonGasSpawned", v31);
        FXUtil.EmitBurstEmitInName(SkillCommon.findDescendantByName(v31, "Emit_法阵") or v31, true);
        SkillCommon.playSoundLocal3D("音效-技能-毒气弹-法阵", v30.Position);
    end;

    local u32 = nil;
    local u33 = nil;
    task.delay(0.033, function() -- Line: 206
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), skillRunData (copy), u32 (ref), u29 (copy), VisibleMgr (ref), skillInputData (copy), HumanoidRootPart (copy), u33 (ref), FXUtil (ref), RunService (ref)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        local v34 = skillRunData.material["毒气"];

        if not (v34 and v34:IsA("Model")) then
            return;
        end;

        u32 = v34;
        u32:ScaleTo(u29);
        VisibleMgr.UnQueryAll(u32);
        local v35 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, HumanoidRootPart);
        local v36 = SkillCommon.strikeHeadAnchorTargetPos(v35);
        u32:PivotTo(CFrame.new(v36) * u32:GetPivot().Rotation);
        u32.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "PoisonGasSpawned", u32);
        u33 = SkillCommon.findDescendantByName(u32, "Enable_Burst") or u32;
        FXUtil.EmitBurstEmitInName(u33, false);
        FXUtil.Emit_Particles_GetDescendants(u33, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(u33, true);
        FXUtil.SetEnableNameVfx(u33, true);
        SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气跟敌" });
        skillRunData.runEvent["毒气跟敌"] = RunService.Heartbeat:Connect(function() -- Line: 229
            -- upvalues: SkillCommon (ref), u27 (ref), runGeneration (ref), u32 (ref), skillRunData (ref), skillInputData (ref), HumanoidRootPart (ref)
            if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
                return;
            end;

            if not (u32 and u32.Parent) then
                SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气跟敌" });

                return;
            end;

            local v37 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, HumanoidRootPart);
            local v38 = SkillCommon.strikeHeadAnchorTargetPos(v37);
            u32:PivotTo(CFrame.new(v38) * u32:GetPivot().Rotation);
        end);
    end);
    task.delay(2.666, function() -- Line: 243
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), u33 (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        if u33 then
            FXUtil.SetEmittersTrailsBeamsEnabled(u33, false);
            FXUtil.OffEnableVfx(u33);
        end;
    end);
    task.delay(4.666, function() -- Line: 254
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), skillRunData (copy), u32 (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气跟敌" });

        if u32 and u32.Parent then
            FXUtil.FadeModel_KeepTrails(u32, 0.12, 1);
            SkillCommon.removeFromRunSpawnList(skillRunData, "PoisonGasSpawned", u32);
        end;
    end);
    local u39 = 0;
    local u40 = 0;
    skillRunData.runEvent["毒气目标毒爆"] = RunService.Heartbeat:Connect(function(p41) -- Line: 267
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), u40 (ref), u39 (ref), u2 (ref), emitBurstAtTarget (ref), skillRunData (copy), skillInputData (copy), u29 (copy), HumanoidRootPart (copy)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        u40 = u40 + p41;

        while u39 < #u2 and u40 >= u2[u39 + 1] do
            u39 = u39 + 1;
            emitBurstAtTarget(u27, runGeneration, skillRunData, skillInputData, u29, HumanoidRootPart, u39 == #u2 and "毒气_大毒爆" or "毒气_小毒爆", u39 == 1 and true or u39 == #u2);
        end;

        if u40 >= u2[#u2] + 0.15 then
            SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气目标毒爆" });
        end;
    end);
    SkillCommon.scheduleRunSpawnClear(u27, runGeneration, skillRunData, "PoisonGasSpawned", 4.667);
end;

function v1.Client_ExitMain(p42) -- Line: 286
    -- upvalues: SkillCommon (copy)
    local skillRunData = p42.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气跟敌", "毒气目标毒爆" });
        SkillCommon.returnAllRunSpawnListToPool(skillRunData, "PoisonGasBurstPool");
        SkillCommon.clearSpawnIfTerminalAfterExit(p42, p42.runGeneration, skillRunData, "PoisonGasSpawned");
    end;
end;

function v1.Server_EnterMain(u43) -- Line: 295
    -- upvalues: SkillCommon (copy), RunService (copy), u2 (copy)
    local skillInputData = u43.skillInputData;

    if not skillInputData then
        return;
    end;

    local u44 = u43.hitbox[1];

    if not (u44 and u44.hitbox) then
        return;
    end;

    local v45 = SkillCommon.scaleBandFromData(u43, SkillCommon.bandScaleOptsFromSkillData(u43));
    local hitbox = u44.hitbox;

    if hitbox:IsA("BasePart") then
        hitbox.Shape = Enum.PartType.Ball;
    end;

    local v46 = 5 * v45;
    hitbox.Size = Vector3.new(v46, v46, v46);
    local runGeneration = u43.runGeneration;
    local u47 = 0;
    local u48 = 0;
    local u49 = nil;
    u49 = RunService.Heartbeat:Connect(function(p50) -- Line: 317
        -- upvalues: u43 (copy), runGeneration (copy), u48 (ref), u47 (ref), u2 (ref), SkillCommon (ref), skillInputData (copy), hitbox (copy), u44 (copy), RunService (ref), u49 (ref)
        if not u43:isRunningFlow() or u43.runGeneration ~= runGeneration then
            return;
        end;

        u48 = u48 + p50;

        while u47 < #u2 and u48 >= u2[u47 + 1] do
            u47 = u47 + 1;
            SkillCommon.refreshSkillAimSnapshot(u43);
            local v51 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, nil);
            local v52 = SkillCommon.strikeHeadAnchorTargetPos(v51);
            hitbox:PivotTo(CFrame.new(v52));
            u44:start();
            local skillRunData = u43.skillRunData;
            SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气命中跟位" });
            skillRunData.runEvent["毒气命中跟位"] = RunService.Heartbeat:Connect(function() -- Line: 330
                -- upvalues: u43 (ref), runGeneration (ref), u44 (ref), SkillCommon (ref), skillRunData (copy), skillInputData (ref), hitbox (ref)
                if not u43:isRunningFlow() or (u43.runGeneration ~= runGeneration or not u44.isActive) then
                    SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气命中跟位" });

                    return;
                end;

                local v53 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, nil);
                local v54 = SkillCommon.strikeHeadAnchorTargetPos(v53);
                hitbox:PivotTo(CFrame.new(v54));
            end);
            task.delay(0.12, function() -- Line: 338
                -- upvalues: SkillCommon (ref), skillRunData (copy), u44 (ref)
                SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气命中跟位" });

                if u44.isActive then
                    u44:stop();
                end;
            end);
        end;

        if u48 >= u2[#u2] + 0.15 then
            u49:Disconnect();
        end;
    end);
    u43:BindRunConn(u49);
end;

function v1.Server_ExitMain(p55) -- Line: 352
    -- upvalues: SkillCommon (copy)
    local skillRunData = p55.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气命中跟位" });
    end;

    local v56 = p55.hitbox[1];

    if v56 and v56.isActive then
        v56:stop();
    end;
end;

function v1.Server_EnterRecovery(p57) -- Line: 363
    p57:releaseControl();
end;

function v1.Client_EnterRecovery(p58) -- Line: 367
    -- upvalues: SkillCommon (copy)
    local skillRunData = p58.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "毒气Cast尾迹");
    end;
end;

function v1.onEnd(p59) -- Line: 374
    -- upvalues: SkillCommon (copy)
    local skillRunData = p59.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "毒气Cast尾迹");
    end;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气跟敌", "毒气目标毒爆" });
    end;
end;

function v1.onEndServer(p60) -- Line: 384
    -- upvalues: SkillCommon (copy)
    local skillRunData = p60.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "毒气命中跟位" });
    end;

    local v61 = p60.hitbox[1];

    if v61 and v61.isActive then
        v61:stop();
    end;
end;

v1.AnimateList = { "技能释放动作10" };
v1.SoundList = { "音效-技能-毒气弹-法阵", "音效-技能-毒气-小毒爆", "音效-技能-毒气-大毒爆" };
v1.ResNameList = { "毒系尾迹", "毒气_法阵", "毒气", "毒气_小毒爆", "毒气_大毒爆" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
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

return v1;