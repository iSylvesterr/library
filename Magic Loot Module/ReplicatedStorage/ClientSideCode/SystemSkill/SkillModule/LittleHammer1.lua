-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Space,
    skillDistanceLimit = 50
};

local function cleanupTargetFxRunEvents(p2) -- Line: 46
    -- upvalues: SkillCommon (copy)
    if not p2 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p2, { "小锤小锤跟头", "小锤小锤锤旋转", "小锤小锤锤缩放" });
end;

local function spawnCasterFormation(p3, p4, p5, p6, p7) -- Line: 54
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy)
    p6:ScaleTo((SkillCommon.scaleBandFromData(p3, SkillCommon.bandScaleOptsFromSkillData(p3))));
    VisibleMgr.UnQueryAll(p6);
    local Rotation = p6:GetPivot().Rotation;
    local v8 = p7.CFrame.Rotation:Inverse() * Rotation;
    p6:PivotTo(SkillCommon.resolveCasterFeetFormationCF(p7, v8));
    p6.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p4, "LittleHammerSpawned", p6);
    local v9 = p6:FindFirstChild("Emit_法阵", true);

    if v9 then
        FXUtil.EmitBurstEmitInName(v9, true);
        SkillCommon.playSoundLocal3D("音效-技能-小锤-法阵", p6:GetPivot().Position);
    end;

    local v10 = p6:FindFirstChild("Emit_法杖", true);

    if v10 then
        local v11 = SkillCommon.resolveWandTipWorldCFrame(SkillCommon.resolveWandTipFromCharacter(p5));

        if v11 then
            SkillCommon.pivotInstanceToWorldCF(v10, v11);
        end;

        FXUtil.EmitBurstEmitInName(v10, true);
    end;
end;

local function connectTargetFollow(u12, u13, u14, u15, u16) -- Line: 87
    -- upvalues: SkillCommon (copy), RunService (copy)
    SkillCommon.disconnectRunEventKeys(u13, { "小锤小锤跟头" });
    local u17;

    if u15 then
        u17 = u15.character;
    else
        u17 = u15;
    end;

    if u17 then
        u17 = u17:FindFirstChild("HumanoidRootPart");
    end;

    u13.runEvent["小锤小锤跟头"] = RunService.RenderStepped:Connect(function() -- Line: 97
        -- upvalues: SkillCommon (ref), u12 (copy), u14 (copy), u13 (copy), u15 (copy), u17 (copy), u16 (copy)
        if not SkillCommon.isRunningSameGeneration(u12, u14) then
            SkillCommon.disconnectRunEventKeys(u13, { "小锤小锤跟头" });

            return;
        end;

        local v18 = SkillCommon.resolveStrikeHeadAnchorLive(u15, u17);
        local lhAppearFx = u13.lhAppearFx;

        if lhAppearFx and lhAppearFx.Parent then
            local v19 = SkillCommon.strikeHeadAnchorPosBehind(v18, 7, u16);
            SkillCommon.pivotInstanceToWorldCF(lhAppearFx, CFrame.new(v19) * lhAppearFx:GetPivot().Rotation);
        end;

        local lhHammer = u13.lhHammer;

        if lhHammer and lhHammer.Parent then
            local v20 = SkillCommon.strikeHeadAnchorPosBehind(v18, 5, u16);
            SkillCommon.pivotModelAtStrikeAnchorHammerOri(lhHammer, v20, v18, u13.lhHammerOriDeg or Vector3.new(42.429, 0, 0), Vector3.new(0, 180, 0));
        end;
    end);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.4,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup"
    },
    Main = {
        Duration = 0.83,
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

function v1.Client_EnterStartup(p21) -- Line: 158
    -- upvalues: SkillCommon (copy)
    local skillInputData = p21.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if not skillInputData then
        return;
    end;

    local v22 = SkillCommon.resolveWandTipFromCharacter(skillInputData);

    if v22 then
        SkillCommon.scheduleWandTipElementTrail(p21, v22, {
            trailMaterialKey = "空间系尾迹",
            runEventKey = "小锤小锤Cast尾迹",
            enableAt = 0.33,
            disableAt = 1.53
        });
    end;
end;

function v1.Client_ExitStartup(p23) -- Line: 175
end;

function v1.Server_EnterStartup(p24) -- Line: 177
    -- upvalues: SkillCommon (copy)
    local v25 = p24.hitbox[1];

    if v25 and v25.hitbox then
        local v26 = 7 * SkillCommon.scaleBandFromData(p24, SkillCommon.bandScaleOptsFromSkillData(p24));
        v25.hitbox.Size = Vector3.new(v26, v26, v26);
    end;
end;

function v1.Client_EnterMain(u27) -- Line: 187
    -- upvalues: SkillCommon (copy), connectTargetFollow (copy), spawnCasterFormation (copy), VisibleMgr (copy), FXUtil (copy)
    local skillInputData = u27.skillInputData;
    local skillRunData = u27.skillRunData;

    if not (skillInputData and (skillRunData and skillRunData.material)) then
        return;
    end;

    local runGeneration = u27.runGeneration;
    local u28 = SkillCommon.scaleBandFromData(u27, SkillCommon.bandScaleOptsFromSkillData(u27));
    local character = skillInputData.character;
    local u29;

    if character then
        u29 = character:FindFirstChild("HumanoidRootPart");
    else
        u29 = character;
    end;

    skillRunData.lhHammerOriDeg = Vector3.new(42.429, 0, 0);
    skillRunData.lhHammerScale = 0.1 * u28;
    connectTargetFollow(u27, skillRunData, runGeneration, skillInputData, u28);
    SkillCommon.scheduleRunSpawnClear(u27, runGeneration, skillRunData, "LittleHammerSpawned", 3.23);
    task.delay(0.33, function() -- Line: 204
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), skillRunData (copy), u29 (copy), character (copy), spawnCasterFormation (ref)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        local v30 = skillRunData.material["小锤小锤_法阵"];

        if v30 and (u29 and character) then
            spawnCasterFormation(u27, skillRunData, character, v30, u29);
        end;
    end);
    task.delay(0.363, function() -- Line: 215
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), u29 (copy), skillInputData (copy), skillRunData (copy), u28 (copy), VisibleMgr (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        local v31 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, u29);
        local v32 = skillRunData.material["小锤小锤_锤出现特效"];

        if v32 then
            v32:ScaleTo(u28);
            VisibleMgr.UnQueryAll(v32);
            local v33 = SkillCommon.strikeHeadAnchorPosBehind(v31, 7, u28);
            SkillCommon.pivotInstanceToWorldCF(v32, CFrame.new(v33) * v32:GetPivot().Rotation);
            v32.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "LittleHammerSpawned", v32);
            skillRunData.lhAppearFx = v32;
            local v34 = v32:FindFirstChild("Emit_锤出现", true) or v32:FindFirstChild("Emit", true);

            if v34 then
                FXUtil.EmitBurstEmitInName(v34, true);
            else
                FXUtil.Emit_Particles_GetDescendants(v32, true);
            end;
        end;

        local v35 = skillRunData.material["小锤小锤_金属锤子"];

        if v35 then
            v35:ScaleTo(0.1 * u28);
            VisibleMgr.UnQueryAll(v35);
            local v36 = SkillCommon.strikeHeadAnchorPosBehind(v31, 5, u28);
            SkillCommon.pivotModelAtStrikeAnchorHammerOri(v35, v36, v31, skillRunData.lhHammerOriDeg, Vector3.new(0, 180, 0));
            v35.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "LittleHammerSpawned", v35);
            skillRunData.lhHammer = v35;
            SkillCommon.tweenModelScaleOnHeartbeat(u27, skillRunData, runGeneration, "小锤小锤锤缩放", v35, 0.1 * u28, 1 * u28, 0.167, {
                resultKey = "lhHammerScale"
            });
        end;
    end);
    task.delay(0.463, function() -- Line: 256
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), skillRunData (copy)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        skillRunData.lhHammerOriDeg = Vector3.new(4.04, 0, 0);
        SkillCommon.tweenRunDataVector3(u27, skillRunData, runGeneration, "小锤小锤锤旋转", "lhHammerOriDeg", Vector3.new(4.04, 0, 0), Vector3.new(-18.723, 0, 0), 0.15);
    end);
    task.delay(0.647, function() -- Line: 266
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), skillRunData (copy)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤锤旋转" });
        skillRunData.lhHammerOriDeg = Vector3.new(25.812, 0, 0);
        SkillCommon.tweenRunDataVector3(u27, skillRunData, runGeneration, "小锤小锤锤旋转", "lhHammerOriDeg", Vector3.new(25.812, 0, 0), Vector3.new(15, 180, 180), 0.05);
    end);
    task.delay(0.697, function() -- Line: 277
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), u29 (copy), skillInputData (copy), skillRunData (copy), u28 (copy), VisibleMgr (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u27);
        local v37 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, u29);
        local v38 = SkillCommon.strikeHeadAnchorTargetPos(v37);
        local v39 = skillRunData.material["小锤小锤_锤爆特效"];

        if v39 then
            v39:ScaleTo(u28);
            VisibleMgr.UnQueryAll(v39);
            v39:PivotTo(CFrame.new(v38) * v39:GetPivot().Rotation);
            v39.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "LittleHammerSpawned", v39);
            local v40 = v39:FindFirstChild("Emit_锤爆", true);

            if v40 then
                FXUtil.EmitBurstEmitInName(v40, true);
            else
                FXUtil.Emit_Particles_GetDescendants(v39, true);
            end;
        end;

        SkillCommon.playSoundLocal3D("音效-技能-小锤-攻击", v38);
        local lhHammer = skillRunData.lhHammer;

        if lhHammer and lhHammer.Parent then
            FXUtil.Instance_Transparency_Tween(lhHammer, 0.133, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;
    end);
    task.delay(0.83, function() -- Line: 315
        -- upvalues: SkillCommon (ref), u27 (copy), runGeneration (copy), skillRunData (copy)
        if not SkillCommon.isRunningSameGeneration(u27, runGeneration) then
            return;
        end;

        local v41 = skillRunData;

        if v41 then
            SkillCommon.disconnectRunEventKeys(v41, { "小锤小锤跟头", "小锤小锤锤旋转", "小锤小锤锤缩放" });
        end;

        local lhHammer = skillRunData.lhHammer;

        if lhHammer and lhHammer.Parent then
            lhHammer:Destroy();
        end;

        skillRunData.lhHammer = nil;
    end);
end;

function v1.Client_ExitMain(p42) -- Line: 328
end;

local function cleanupServerHitWindow(p43) -- Line: 332
    -- upvalues: SkillCommon (copy)
    local skillRunData = p43.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤命中跟位" });
    end;

    local v44 = p43.hitbox[1];

    if v44 and v44.isActive then
        v44:stop();
    end;
end;

function v1.Server_EnterMain(u45) -- Line: 343
    -- upvalues: SkillCommon (copy), RunService (copy)
    local skillInputData = u45.skillInputData;
    local u46 = u45.hitbox[1];

    if not (u46 and (u46.hitbox and skillInputData)) then
        return;
    end;

    local runGeneration = u45.runGeneration;
    local v47 = 7 * SkillCommon.scaleBandFromData(u45, SkillCommon.bandScaleOptsFromSkillData(u45));
    u46.hitbox.Size = Vector3.new(v47, v47, v47);
    task.delay(0.697, function() -- Line: 355
        -- upvalues: SkillCommon (ref), u45 (copy), runGeneration (copy), u46 (copy), RunService (ref), skillInputData (copy)
        if not SkillCommon.isRunningSameGeneration(u45, runGeneration) then
            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u45);
        local skillRunData = u45.skillRunData;
        u46:start();
        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤命中跟位" });
        skillRunData.runEvent["小锤小锤命中跟位"] = RunService.Heartbeat:Connect(function() -- Line: 363
            -- upvalues: SkillCommon (ref), u45 (ref), runGeneration (ref), u46 (ref), skillRunData (copy), skillInputData (ref)
            if not (SkillCommon.isRunningSameGeneration(u45, runGeneration) and u46.isActive) then
                SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤命中跟位" });

                return;
            end;

            local v48 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, nil);
            local v49 = SkillCommon.strikeHeadAnchorTargetPos(v48);
            u46.hitbox:PivotTo(CFrame.new(v49));
        end);
        local v50 = SkillCommon.resolveStrikeHeadAnchorLive(skillInputData, nil);
        local v51 = SkillCommon.strikeHeadAnchorTargetPos(v50);
        u46.hitbox:PivotTo(CFrame.new(v51));
        task.delay(0.08, function() -- Line: 375
            -- upvalues: SkillCommon (ref), skillRunData (copy), u46 (ref)
            SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤命中跟位" });

            if u46.isActive then
                u46:stop();
            end;
        end);
    end);
end;

function v1.Server_ExitMain(p52) -- Line: 384
    -- upvalues: SkillCommon (copy)
    local skillRunData = p52.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤命中跟位" });
    end;

    local v53 = p52.hitbox[1];

    if v53 and v53.isActive then
        v53:stop();
    end;
end;

function v1.Client_EnterRecovery(p54) -- Line: 389
    -- upvalues: SkillCommon (copy)
    local skillRunData = p54.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "小锤小锤Cast尾迹");

        if not skillRunData then
            return;
        end;

        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤跟头", "小锤小锤锤旋转", "小锤小锤锤缩放" });
    end;
end;

function v1.Server_EnterRecovery(p55) -- Line: 397
    -- upvalues: SkillCommon (copy)
    local skillRunData = p55.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤命中跟位" });
    end;

    local v56 = p55.hitbox[1];

    if v56 and v56.isActive then
        v56:stop();
    end;

    p55:releaseControl();
end;

function v1.onEnd(p57) -- Line: 402
    -- upvalues: SkillCommon (copy)
    local skillRunData = p57.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤跟头", "小锤小锤锤旋转", "小锤小锤锤缩放" });
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "小锤小锤Cast尾迹");
end;

function v1.onEndServer(p58) -- Line: 411
    -- upvalues: SkillCommon (copy)
    local skillRunData = p58.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "小锤小锤命中跟位" });
    end;

    local v59 = p58.hitbox[1];

    if v59 and v59.isActive then
        v59:stop();
    end;
end;

v1.SoundList = { "音效-技能-小锤-法阵", "音效-技能-小锤-攻击" };
v1.AnimateList = { "技能释放动作1" };
v1.ResNameList = { "空间系尾迹", "小锤小锤_法阵", "小锤小锤_锤出现特效", "小锤小锤_金属锤子", "小锤小锤_锤爆特效" };
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
        overTime = 0.73,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.53,
        animationName = "技能释放动作1",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;