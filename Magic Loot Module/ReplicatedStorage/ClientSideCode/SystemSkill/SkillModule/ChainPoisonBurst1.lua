-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local EntityUtil = require(script.Parent.Parent.BaseSkill.EntityUtil);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Poison,
    skillDistanceLimit = 50
};
local u2 = { 0.5, 0.813, 1.125, 1.438, 1.75 };

local function borrowPooledBurst(p3) -- Line: 55
    -- upvalues: FXUtil (copy), UtilsSystem (copy)
    if not (p3 and p3:IsA("Model")) then
        return nil;
    end;

    local v4 = FXUtil.GetInstance_From_Pool(p3);

    if not (v4 and v4:IsA("Model")) then
        return nil;
    end;

    local ResRestore = UtilsSystem.ResRestore;

    if ResRestore and ResRestore.Restore then
        ResRestore.Restore(v4);
    end;

    FXUtil.PreparePooledModelForReuse(v4, p3);

    return v4;
end;

local function gatherSphereStrikeTargets(u5, u6, u7) -- Line: 72
    -- upvalues: EntityUtil (copy), Players (copy)
    local u8 = {};
    local u9 = {};
    local u10 = {
        id = u5.characterId,
        type = u5.characterType
    };

    local function tryModel(p11) -- Line: 77
        -- upvalues: u9 (copy), u6 (copy), u7 (copy), EntityUtil (ref), u10 (copy), u5 (copy), u8 (copy)
        if not p11 or (not p11:IsA("Model") or u9[p11]) then
            return;
        end;

        local v12 = p11:FindFirstChildOfClass("Humanoid");
        local HumanoidRootPart = p11:FindFirstChild("HumanoidRootPart");

        if not v12 or (v12.Health <= 0 or not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart"))) then
            return;
        end;

        if u7 < (HumanoidRootPart.Position - u6).Magnitude then
            return;
        end;

        if EntityUtil.isFriendly(u10, p11) then
            return;
        end;

        if EntityUtil.isForeignPlayerOwnedSummon(u5.characterId, u5.characterType, p11) then
            return;
        end;

        u9[p11] = true;
        table.insert(u8, p11);
    end;

    if u5.characterType == "NPC" then
        for _, v in Players:GetPlayers() do
            tryModel(v.Character);
        end;

        local Summons = workspace:FindFirstChild("Summons");

        if Summons then
            for _, child in Summons:GetChildren() do
                if child:IsA("Model") then
                    tryModel(child);
                end;
            end;

            return u8;
        end;
    else
        local Monster = workspace:FindFirstChild("Monster");

        if Monster then
            for _, child in Monster:GetChildren() do
                if child:IsA("Model") then
                    tryModel(child);
                end;
            end;
        end;

        local Summons = workspace:FindFirstChild("Summons");

        if Summons then
            for _, child in Summons:GetChildren() do
                if child:IsA("Model") then
                    tryModel(child);
                end;
            end;
        end;
    end;

    return u8;
end;

local function emitPoisonBurstOnSphereTargets(p13, p14, u15, p16, p17, p18) -- Line: 133
    -- upvalues: SkillCommon (copy), gatherSphereStrikeTargets (copy), borrowPooledBurst (copy), VisibleMgr (copy), FXUtil (copy)
    if not SkillCommon.isRunningSameGeneration(p13, p14) then
        return;
    end;

    local v19 = u15.material[p18];

    if not (v19 and v19:IsA("Model")) then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(p13);

    for _, v in gatherSphereStrikeTargets(p13, SkillCommon.resolveStruckTargetGroundWorldPos(p16, 4, 0.5, "Ground"), p17 * 20) do
        local HumanoidRootPart = v:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            local u20 = borrowPooledBurst(v19);

            if u20 then
                u20:ScaleTo(p17);
                VisibleMgr.UnQueryAll(u20);
                u20:PivotTo(HumanoidRootPart:GetPivot());
                u20.Parent = workspace.Debris;
                SkillCommon.appendRunSpawnList(u15, "ChainPoisonBurstBurstPool", u20);
                local v21 = SkillCommon.findDescendantByName(u20, "Emit_Burst") or u20;
                FXUtil.EmitBurstEmitInName(v21, true);
                task.delay(2, function() -- Line: 164
                    -- upvalues: u20 (copy), FXUtil (ref), SkillCommon (ref), u15 (copy)
                    if u20.Parent then
                        FXUtil.BackPool_Instance(u20);
                        SkillCommon.removeFromRunSpawnList(u15, "ChainPoisonBurstBurstPool", u20);
                    end;
                end);
            end;
        end;
    end;
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.27,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 3.917,
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

function v1.Client_EnterStartup(p22) -- Line: 212
    -- upvalues: SkillCommon (copy)
    local v23 = p22.skillInputData and p22.skillInputData.character;

    if not v23 then
        return;
    end;

    local v24 = SkillCommon.resolveWandTipFromCharacter(v23);

    if v24 then
        SkillCommon.scheduleWandTipElementTrail(p22, v24, {
            trailMaterialKey = "毒系尾迹",
            runEventKey = "连环毒爆Cast尾迹",
            enableAt = 0.27,
            disableAt = 0.47
        });
    end;
end;

function v1.Server_EnterStartup(p25) -- Line: 228
    -- upvalues: SkillCommon (copy)
    local v26 = p25.hitbox[1];

    if not (v26 and v26.hitbox) then
        return;
    end;

    local v27 = SkillCommon.scaleBandFromData(p25, SkillCommon.bandScaleOptsFromSkillData(p25));
    local hitbox = v26.hitbox;

    if hitbox:IsA("BasePart") then
        hitbox.Shape = Enum.PartType.Ball;
    end;

    hitbox.Size = Vector3.new(45, 45, 45) * v27;
    hitbox:PivotTo(CFrame.new(0, -5000, 0));
end;

function v1.Client_EnterMain(u28) -- Line: 242
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), RunService (copy), u2 (copy), emitPoisonBurstOnSphereTargets (copy)
    PlayerAimSync.refreshAimSnapshot(u28);
    local skillInputData = u28.skillInputData;
    local v29;

    if skillInputData then
        v29 = skillInputData.character;
    else
        v29 = skillInputData;
    end;

    local skillRunData = u28.skillRunData;

    if not (v29 and (skillInputData and (skillRunData and skillRunData.material))) then
        return;
    end;

    local HumanoidRootPart = v29:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u28.runGeneration;
    local u30 = SkillCommon.scaleBandFromData(u28, SkillCommon.bandScaleOptsFromSkillData(u28));
    local v31 = HumanoidRootPart:GetPivot() * CFrame.new(0, 1.4, -2);
    local v32 = skillRunData.material["连环毒爆_法阵"];

    if v32 and v32:IsA("Model") then
        v32:ScaleTo(u30);
        VisibleMgr.UnQueryAll(v32);
        SkillCommon.pivotModelAtFormationAnchor(v31, v32, v32:GetPivot() - v32:GetPivot().Position);
        v32.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "ChainPoisonBurstSpawned", v32);
        FXUtil.EmitBurstEmitInName(SkillCommon.findDescendantByName(v32, "Emit_法阵") or v32, true);
        SkillCommon.playSoundLocal3D("音效-技能-毒爆-法阵", v31.Position);
    end;

    local u33 = skillRunData.material["连环毒爆_毒球"];

    if u33 and u33:IsA("Model") then
        u33:ScaleTo(0.1 * u30);
        VisibleMgr.UnQueryAll(u33);
        SkillCommon.pivotModelAtFormationAnchor(v31, u33, u33:GetPivot() - u33:GetPivot().Position);
        u33.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "ChainPoisonBurstSpawned", u33);
        local u34 = SkillCommon.findDescendantByName(u33, "毒球Emit且enabled") or u33;
        SkillCommon.tweenModelScaleOnHeartbeat(u28, skillRunData, runGeneration, "连环毒爆毒球缩放", u33, 0.1 * u30, 1 * u30, 0.017);
        FXUtil.Emit_Particles_GetDescendants(u34, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(u34, true);
        FXUtil.SetEnableNameVfx(u34, true);
        local v35 = SkillCommon.resolveModelAttachPart(u33);

        if v35 and not SkillCommon.playSoundLocal3DOnPartForSkill(u28, "音效-技能-毒爆-毒球飞行", v35, true) then
            SkillCommon.playSoundLocal3DOnPart("音效-技能-毒爆-毒球飞行", v35);
        end;

        local v36 = u33:GetPivot();
        local v37 = SkillCommon.resolveTrackTargetHrp(skillInputData);
        local v38;

        if v37 and v37.Parent then
            v38 = v37.Position;
        else
            v38 = SkillCommon.resolveStrikeWorldPos(skillInputData);
        end;

        FXUtil.Set_CFrame_Model_Tween(u33, 0.5, CFrame.new(v38) * v36.Rotation, Enum.EasingStyle.Linear, Enum.EasingDirection.In, true);
        task.delay(0.5, function() -- Line: 304
            -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), u33 (copy), FXUtil (ref), u34 (copy), skillRunData (copy)
            if not (SkillCommon.isRunningSameGeneration(u28, runGeneration) and u33.Parent) then
                return;
            end;

            SkillCommon.stopSoundLocalForSkill(u28, "音效-技能-毒爆-毒球飞行");
            FXUtil.SetEmittersTrailsBeamsEnabled(u34, false);
            FXUtil.OffEnableVfx(u34);
            task.delay(2, function() -- Line: 311
                -- upvalues: SkillCommon (ref), u28 (ref), runGeneration (ref), u33 (ref), FXUtil (ref), skillRunData (ref)
                if not (SkillCommon.isRunningSameGeneration(u28, runGeneration) and u33.Parent) then
                    return;
                end;

                FXUtil.FadeModel_KeepTrails(u33, 0.12, 1);
                SkillCommon.removeFromRunSpawnList(skillRunData, "ChainPoisonBurstSpawned", u33);
            end);
        end);
    end;

    task.delay(0.467, function() -- Line: 321
        -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), skillRunData (copy), skillInputData (copy), u30 (copy), VisibleMgr (ref)
        if not SkillCommon.isRunningSameGeneration(u28, runGeneration) then
            return;
        end;

        local v39 = skillRunData.material["连环毒爆_打击特效"];

        if not (v39 and v39:IsA("Model")) then
            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u28);
        local v40 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 2.5 * u30, "Ground");
        v39:ScaleTo(u30);
        VisibleMgr.UnQueryAll(v39);
        SkillCommon.pivotModelAtWorldPosKeepRotation(v39, v40);
        v39.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "ChainPoisonBurstSpawned", v39);
        local v41 = SkillCommon.findDescendantByName(v39, "Emit且Enable毒雾特效VFX");

        if v41 and v41:IsA("Model") then
            v41:ScaleTo(0.1 * u30);
            SkillCommon.tweenModelScaleOnHeartbeat(u28, skillRunData, runGeneration, "连环毒爆毒雾缩放", v41, 0.1 * u30, 1 * u30, 0.117);
        end;
    end);
    task.delay(0.5, function() -- Line: 354
        -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), skillRunData (copy), skillInputData (copy), u30 (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u28, runGeneration) then
            return;
        end;

        local v42 = skillRunData.material["连环毒爆_打击特效"];

        if not (v42 and v42:IsA("Model")) then
            return;
        end;

        local v43 = SkillCommon.findDescendantByName(v42, "Emit_毒球触碰时特效");
        local v44 = SkillCommon.findDescendantByName(v42, "Emit且Enable毒雾特效");
        local v45 = SkillCommon.findDescendantByName(v42, "Emit且Enable_毒地面特效");

        if v43 then
            SkillCommon.refreshSkillAimSnapshot(u28);
            local v46 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 2.5 * u30, "Ground");
            SkillCommon.playSoundLocal3D("音效-技能-毒爆-攻击", v46);
            FXUtil.EmitBurstEmitInName(v43, true);
        end;

        if v44 then
            FXUtil.Emit_Particles_GetDescendants(v44, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v44, true);
            FXUtil.SetEnableNameVfx(v44, true);
        end;

        if v45 then
            FXUtil.Emit_Particles_GetDescendants(v45, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v45, true);
            FXUtil.SetEnableNameVfx(v45, true);
        end;
    end);
    task.delay(1.75, function() -- Line: 384
        -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), skillRunData (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u28, runGeneration) then
            return;
        end;

        local u47 = skillRunData.material["连环毒爆_打击特效"];

        if not (u47 and u47:IsA("Model")) then
            return;
        end;

        local v48 = SkillCommon.findDescendantByName(u47, "Emit且Enable毒雾特效");

        if v48 then
            FXUtil.SetEmittersTrailsBeamsEnabled(v48, false);
            FXUtil.OffEnableVfx(v48);
        end;

        task.delay(2, function() -- Line: 398
            -- upvalues: SkillCommon (ref), u28 (ref), runGeneration (ref), u47 (copy), FXUtil (ref), skillRunData (ref)
            if not (SkillCommon.isRunningSameGeneration(u28, runGeneration) and u47.Parent) then
                return;
            end;

            FXUtil.FadeModel_KeepTrails(u47, 0.12, 1);
            SkillCommon.removeFromRunSpawnList(skillRunData, "ChainPoisonBurstSpawned", u47);
        end);
    end);
    task.delay(1.917, function() -- Line: 407
        -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), skillRunData (copy), FXUtil (ref), skillInputData (copy), u30 (copy)
        if not SkillCommon.isRunningSameGeneration(u28, runGeneration) then
            return;
        end;

        local v49 = skillRunData.material["连环毒爆_打击特效"];

        if not (v49 and v49:IsA("Model")) then
            return;
        end;

        local v50 = SkillCommon.findDescendantByName(v49, "Emit且Enable_毒地面特效");

        if v50 then
            FXUtil.SetEmittersTrailsBeamsEnabled(v50, false);
            FXUtil.OffEnableVfx(v50);
            SkillCommon.refreshSkillAimSnapshot(u28);
            local v51 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 2.5 * u30, "Ground");
            SkillCommon.playSoundLocal3D("音效-技能-毒爆-攻击结束", v51);
        end;
    end);
    local u52 = 0;
    local u53 = 0;
    skillRunData.runEvent["连环毒爆目标毒爆"] = RunService.Heartbeat:Connect(function(p54) -- Line: 427
        -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), u53 (ref), u52 (ref), u2 (ref), emitPoisonBurstOnSphereTargets (ref), skillRunData (copy), skillInputData (copy), u30 (copy)
        if not SkillCommon.isRunningSameGeneration(u28, runGeneration) then
            return;
        end;

        u53 = u53 + p54;

        while u52 < #u2 and u53 >= u2[u52 + 1] do
            u52 = u52 + 1;
            emitPoisonBurstOnSphereTargets(u28, runGeneration, skillRunData, skillInputData, u30, u52 == #u2 and "连环毒爆_大毒爆" or "连环毒爆_小毒爆");
        end;

        if u53 >= u2[#u2] + 0.15 then
            SkillCommon.disconnectRunEventKeys(skillRunData, { "连环毒爆目标毒爆" });
        end;
    end);
    SkillCommon.scheduleRunSpawnClear(u28, runGeneration, skillRunData, "ChainPoisonBurstSpawned", 3.917);
end;

function v1.Client_ExitMain(p55) -- Line: 445
    -- upvalues: SkillCommon (copy)
    SkillCommon.stopSoundLocalForSkill(p55, "音效-技能-毒爆-毒球飞行");
    local skillRunData = p55.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "连环毒爆毒球缩放", "连环毒爆毒雾缩放", "连环毒爆目标毒爆" });
        SkillCommon.returnAllRunSpawnListToPool(skillRunData, "ChainPoisonBurstBurstPool");
        SkillCommon.clearSpawnIfTerminalAfterExit(p55, p55.runGeneration, skillRunData, "ChainPoisonBurstSpawned");
    end;
end;

function v1.Server_EnterMain(u56) -- Line: 455
    -- upvalues: PlayerAimSync (copy), SkillCommon (copy), RunService (copy), u2 (copy)
    PlayerAimSync.refreshAimSnapshot(u56);
    local skillInputData = u56.skillInputData;

    if not skillInputData then
        return;
    end;

    local u57 = u56.hitbox[1];

    if not (u57 and u57.hitbox) then
        return;
    end;

    local v58 = SkillCommon.scaleBandFromData(u56, SkillCommon.bandScaleOptsFromSkillData(u56));
    local hitbox = u57.hitbox;

    if hitbox:IsA("BasePart") then
        hitbox.Shape = Enum.PartType.Ball;
    end;

    local v59 = 40 * v58;
    hitbox.Size = Vector3.new(v59, v59, v59);
    local runGeneration = u56.runGeneration;
    local u60 = 0;
    local u61 = 0;
    local u62 = nil;
    u62 = RunService.Heartbeat:Connect(function(p63) -- Line: 479
        -- upvalues: u56 (copy), runGeneration (copy), u61 (ref), u60 (ref), u2 (ref), SkillCommon (ref), hitbox (copy), skillInputData (copy), u57 (copy), u62 (ref)
        if not u56:isRunningFlow() or u56.runGeneration ~= runGeneration then
            return;
        end;

        u61 = u61 + p63;

        while u60 < #u2 and u61 >= u2[u60 + 1] do
            u60 = u60 + 1;
            SkillCommon.refreshSkillAimSnapshot(u56);
            hitbox:PivotTo(CFrame.new(SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 0.5, "Ground")));
            u57:start();
            task.delay(0.12, function() -- Line: 489
                -- upvalues: u57 (ref)
                if u57.isActive then
                    u57:stop();
                end;
            end);
        end;

        if u61 >= u2[#u2] + 0.15 then
            u62:Disconnect();
        end;
    end);
    u56:BindRunConn(u62);
end;

function v1.Server_ExitMain(p64) -- Line: 502
    local v65 = p64.hitbox[1];

    if v65 and v65.isActive then
        v65:stop();
    end;
end;

function v1.Server_EnterRecovery(p66) -- Line: 509
    p66:releaseControl();
end;

function v1.Client_EnterRecovery(p67) -- Line: 513
    -- upvalues: SkillCommon (copy)
    local skillRunData = p67.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "连环毒爆Cast尾迹");
    end;
end;

function v1.onEnd(p68) -- Line: 520
    -- upvalues: SkillCommon (copy)
    SkillCommon.stopSoundLocalForSkill(p68, "音效-技能-毒爆-毒球飞行");
    local skillRunData = p68.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "连环毒爆Cast尾迹");
    end;
end;

function v1.onEndServer(p69) -- Line: 528
    local v70 = p69.hitbox[1];

    if v70 and v70.isActive then
        v70:stop();
    end;
end;

v1.AnimateList = { "技能释放动作3" };
v1.SoundList = { "音效-技能-毒爆-法阵", "音效-技能-毒爆-毒球飞行", "音效-技能-毒爆-攻击", "音效-技能-毒爆-攻击结束" };
v1.ResNameList = { "毒系尾迹", "连环毒爆_法阵", "连环毒爆_毒球", "连环毒爆_打击特效", "连环毒爆_小毒爆", "连环毒爆_大毒爆" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "毒属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
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
        overTime = 1.27,
        animationName = "技能释放动作3",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;