-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Space,
    skillDistanceLimit = 50
};
local u2 = { 0, 0.183, 0.35, 0.517, 0.683, 0.85, 1.033, 1.2, 1.367, 1.533 };
local u3 = { 0.367, 0.55, 0.717, 0.884, 1.05, 1.217, 1.4, 1.567, 1.734, 1.9 };
local u4 = {
    {
        materialKey = "魔能钉刺",
        spawnLocal = Vector3.new(3.734, 10.58, -6.809),
        spawnOri = Vector3.new(0, 50, 51.667),
        midLocal = Vector3.new(5.89, 12.961, -3.364),
        midOri = Vector3.new(0, 50, 55),
        landLocal = Vector3.new(-5.605, -2.561, 4.24),
        landOri = Vector3.new(0, 50, 55),
        fxNodeName = "FX_钉刺Enabled和Emit"
    },
    {
        materialKey = "符文铁片",
        spawnLocal = Vector3.new(-5.665, 14.278, -4.976),
        spawnOri = Vector3.new(26.065, 44.311, -24.232),
        midLocal = Vector3.new(-7.176, 16.437, -4.976),
        midOri = Vector3.new(26.065, 44.311, -24.232),
        landLocal = Vector3.new(3.73, -2.138, -4.976),
        landOri = Vector3.new(26.065, 44.311, -24.232),
        fxNodeName = "FX_钉刺Enabled和Emit"
    },
    {
        materialKey = "铁砧",
        spawnLocal = Vector3.new(5.02, 13.192, 1.936),
        spawnOri = Vector3.new(-14.476, 26.569, 26.573),
        midLocal = Vector3.new(7.143, 16.868, 1.936),
        midOri = Vector3.new(-14.475, 26.571, 26.574),
        landLocal = Vector3.new(-2.488, -2.809, 1.939),
        landOri = Vector3.new(-14.474, 26.572, 26.574),
        fxNodeName = "FX_钉刺Enabled和Emit"
    },
    {
        materialKey = "锁链重锤",
        spawnLocal = Vector3.new(-3.104, 12.849, 2.835),
        spawnOri = Vector3.new(18.929, 123.822, -13.443),
        midLocal = Vector3.new(-3.575, 16.112, 1.135),
        midOri = Vector3.new(18.929, 123.822, -13.443),
        landLocal = Vector3.new(-1.323, -2.497, -2.114),
        landOri = Vector3.new(18.929, 123.822, -13.444),
        fxNodeName = "FX_钉刺Enabled和Emit"
    },
    {
        materialKey = "齿轮",
        spawnLocal = Vector3.new(-0.314, 13.993, -1.987),
        spawnOri = Vector3.new(0, 0, 0),
        midLocal = Vector3.new(-0.314, 17.812, -1.987),
        midOri = Vector3.new(0, 0, 0),
        landLocal = Vector3.new(-0.314, -2.364, -0.413),
        landOri = Vector3.new(0, 0, 0),
        fxNodeName = "FX_钉刺Enabled和Emit"
    }
};

local function still(p5, p6) -- Line: 152
    -- upvalues: SkillCommon (copy)
    return SkillCommon.isRunningSameGeneration(p5, p6);
end;

local function refreshLockedStrike(p7, p8, p9) -- Line: 157
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p7);
    local skillRunData = p7.skillRunData;

    if not skillRunData.Logic then
        skillRunData.Logic = {};
    end;

    skillRunData.Logic[p8] = nil;

    return SkillCommon.commitLockedStrike(p7, p8, {
        rayTag = "Ground",
        rayUp = p9 * 4,
        lift = p9 * 0.5
    });
end;

local function getLockedStrike(p10, p11, p12) -- Line: 176
    -- upvalues: refreshLockedStrike (copy)
    local skillRunData = p10.skillRunData;

    return skillRunData and skillRunData.Logic and skillRunData.Logic[p11] or refreshLockedStrike(p10, p11, p12);
end;

local function basisCFFromLocked(p13) -- Line: 190
    local hrpCenter = p13.hrpCenter;
    local forward = p13.forward;

    return CFrame.lookAt(hrpCenter, hrpCenter + (forward.Magnitude < 0.05 and Vector3.new(0, 0, -1) or forward).Unit, Vector3.new(0, 1, 0));
end;

local function borrowPooledModel(p14) -- Line: 200
    -- upvalues: FXUtil (copy), UtilsSystem (copy)
    if not (p14 and p14:IsA("Model")) then
        return nil;
    end;

    local v15 = FXUtil.GetInstance_From_Pool(p14);

    if not (v15 and v15:IsA("Model")) then
        return nil;
    end;

    local ResRestore = UtilsSystem.ResRestore;

    if ResRestore and ResRestore.Restore then
        ResRestore.Restore(v15);
    end;

    FXUtil.PreparePooledModelForReuse(v15, p14);

    return v15;
end;

local function takeStrikeModel(p16, p17, p18) -- Line: 216
    -- upvalues: FXUtil (copy), borrowPooledModel (copy)
    if not (p16 and p16.material) then
        return nil;
    end;

    if p18 > 5 then
        local v19 = p16.Logic and p16.Logic.magnetoPoolTpl;

        if v19 then
            v19 = v19[p17];
        end;

        if v19 and v19:IsA("Model") then
            return borrowPooledModel(v19);
        end;

        local v20 = p16.material[p17];

        if v20 and v20:IsA("Model") then
            return borrowPooledModel(v20);
        end;

        return nil;
    end;

    local v21 = p16.material[p17];

    if not (v21 and v21:IsA("Model")) then
        return nil;
    end;

    if not p16.Logic then
        p16.Logic = {};
    end;

    if not p16.Logic.magnetoPoolTpl then
        p16.Logic.magnetoPoolTpl = {};
    end;

    p16.Logic.magnetoPoolTpl[p17] = v21;
    p16.material[p17] = nil;
    FXUtil.PreparePooledModelForReuse(v21, v21);

    return v21;
end;

local function worldCFFromBaked(p22, p23, p24, p25) -- Line: 250
    -- upvalues: SkillCommon (copy)
    local v26 = p22:PointToWorldSpace(p23 * p25);
    local v27 = SkillCommon.composeHammerWorldRotFromRefEnemy(p22.Rotation, p24, Vector3.new(0, 180, 0));

    return CFrame.new(v26) * v27;
end;

local function landCFFromBaked(p28, p29, p30, p31) -- Line: 258
    -- upvalues: SkillCommon (copy)
    local v32 = p28:PointToWorldSpace(p29 * p31);
    local Position = SkillCommon.getGroundCF(CFrame.new(v32.X, v32.Y, v32.Z), p31 * 4, p31 * 0.5, "Ground").Position;
    local v33 = SkillCommon.composeHammerWorldRotFromRefEnemy(p28.Rotation, p30, Vector3.new(0, 180, 0));

    return CFrame.new(Position) * v33;
end;

local function groundBurstCF(p34, p35, p36) -- Line: 267
    -- upvalues: FXUtil (copy), SkillCommon (copy)
    local Position = p34.Position;
    local v37 = p36 * 0.4;
    local v38 = FXUtil.GetGroundAlignedCF(Position, p35, "Ground", p36 * 4, v37);

    if v38 then
        return v38;
    end;

    local Position2 = SkillCommon.getGroundCF(CFrame.new(Position), p36 * 4, v37, "Ground").Position;

    return CFrame.new(Position2);
end;

local function spawnCasterFormation(p39, p40, p41, p42) -- Line: 279
    -- upvalues: VisibleMgr (copy), SkillCommon (copy), FXUtil (copy)
    p40:ScaleTo(p42);
    VisibleMgr.UnQueryAll(p40);
    local Rotation = p40:GetPivot().Rotation;
    local v43 = p41.CFrame.Rotation:Inverse() * Rotation;
    p40:PivotTo(SkillCommon.resolveCasterFeetFormationCF(p41, v43));
    p40.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(p39, "MagnetoSpawned", p40);
    local v44 = p40:FindFirstChild("Emit_法阵", true);

    if v44 then
        FXUtil.EmitBurstEmitInName(v44, true);
    end;

    SkillCommon.playSoundLocal3D("音效-技能-万磁王-法阵", p40:GetPivot().Position);
    p39.material["万磁王_法阵"] = nil;
end;

local function tweenModelPivot(u45, p46, u47, p48, u49, p50, p51, p52, p53, p54) -- Line: 296
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    SkillCommon.disconnectRunEventKeys(p46, { p48 });

    if not p46.runEvent then
        p46.runEvent = {};
    end;

    if p52 <= 0 then
        if u49.Parent then
            u49:PivotTo(p51);
        end;

        return;
    end;

    u49:PivotTo(p50);
    p46.runEvent[p48] = FXUtil.Pivot_Instance_CF_Lerp_Heartbeat(u49, p52, p51, p53, p54, function() -- Line: 325
        -- upvalues: u45 (copy), u47 (copy), SkillCommon (ref), u49 (copy)
        local v55 = SkillCommon.isRunningSameGeneration(u45, u47) and u49.Parent ~= nil;

        return v55;
    end);
end;

local function runStrikeModelClient(u56, u57, u58, p59, u60) -- Line: 332
    -- upvalues: SkillCommon (copy), refreshLockedStrike (copy), takeStrikeModel (copy), VisibleMgr (copy), landCFFromBaked (copy), FXUtil (copy), tweenModelPivot (copy), groundBurstCF (copy), borrowPooledModel (copy)
    local skillRunData = u56.skillRunData;

    if not (u56.skillInputData and (skillRunData and skillRunData.material)) then
        return;
    end;

    local u61 = SkillCommon.scaleBandFromData(u56, SkillCommon.bandScaleOptsFromSkillData(u56));
    local u62 = "magnetoStrike_" .. u60;
    local u63 = "万磁王模型缩放" .. u60;
    local u64 = "万磁王CFrame升起" .. u60;
    local u65 = "万磁王CFrame落下" .. u60;
    task.delay(p59, function() -- Line: 350
        -- upvalues: u56 (copy), u57 (copy), SkillCommon (ref), refreshLockedStrike (ref), u62 (copy), u61 (copy), takeStrikeModel (ref), skillRunData (copy), u58 (copy), u60 (copy), VisibleMgr (ref), landCFFromBaked (ref), u63 (copy), FXUtil (ref), tweenModelPivot (ref), u64 (copy), u65 (copy), groundBurstCF (ref), borrowPooledModel (ref)
        if not SkillCommon.isRunningSameGeneration(u56, u57) then
            return;
        end;

        local u66 = refreshLockedStrike(u56, u62, u61);
        local hrpCenter = u66.hrpCenter;
        local forward = u66.forward;
        local v67 = CFrame.lookAt(hrpCenter, hrpCenter + (forward.Magnitude < 0.05 and Vector3.new(0, 0, -1) or forward).Unit, Vector3.new(0, 1, 0));
        local u68 = takeStrikeModel(skillRunData, u58.materialKey, u60);

        if not u68 then
            return;
        end;

        u68:ScaleTo(0.1 * u61);
        VisibleMgr.UnQueryAll(u68);
        local spawnOri = u58.spawnOri;
        local v69 = v67:PointToWorldSpace(u58.spawnLocal * u61);
        local v70 = SkillCommon.composeHammerWorldRotFromRefEnemy(v67.Rotation, spawnOri, Vector3.new(0, 180, 0));
        local u71 = CFrame.new(v69) * v70;
        local midOri = u58.midOri;
        local v72 = v67:PointToWorldSpace(u58.midLocal * u61);
        local v73 = SkillCommon.composeHammerWorldRotFromRefEnemy(v67.Rotation, midOri, Vector3.new(0, 180, 0));
        local u74 = CFrame.new(v72) * v73;
        local u75 = landCFFromBaked(v67, u58.landLocal, u58.landOri, u61);
        u68:PivotTo(u71);
        u68.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "MagnetoSpawned", u68);
        task.delay(0.033, function() -- Line: 369
            -- upvalues: u56 (ref), u57 (ref), SkillCommon (ref), u68 (copy), skillRunData (ref), u63 (ref), u61 (ref), u58 (ref), FXUtil (ref)
            if not (SkillCommon.isRunningSameGeneration(u56, u57) and u68.Parent) then
                return;
            end;

            SkillCommon.tweenModelScaleOnHeartbeat(u56, skillRunData, u57, u63, u68, 0.1 * u61, 1.5 * u61, 0.034, {
                easingStyle = Enum.EasingStyle.Quad,
                easingDirection = Enum.EasingDirection.Out
            });
            local v76 = u68:FindFirstChild(u58.fxNodeName, true);

            if v76 then
                FXUtil.EmitBurstEmitInName(v76, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(v76, true);
                FXUtil.SetEnableNameVfx(v76, true);
            end;
        end);
        task.delay(0.067, function() -- Line: 392
            -- upvalues: u56 (ref), u57 (ref), SkillCommon (ref), u68 (copy), skillRunData (ref), u63 (ref), u61 (ref)
            if not (SkillCommon.isRunningSameGeneration(u56, u57) and u68.Parent) then
                return;
            end;

            SkillCommon.tweenModelScaleOnHeartbeat(u56, skillRunData, u57, u63, u68, 1.5 * u61, 0.7 * u61, 0.033, {
                easingStyle = Enum.EasingStyle.Quad,
                easingDirection = Enum.EasingDirection.Out
            });
        end);
        task.delay(0.1, function() -- Line: 409
            -- upvalues: u56 (ref), u57 (ref), SkillCommon (ref), u68 (copy), skillRunData (ref), u63 (ref), u61 (ref), tweenModelPivot (ref), u64 (ref), u71 (copy), u74 (copy)
            if not (SkillCommon.isRunningSameGeneration(u56, u57) and u68.Parent) then
                return;
            end;

            SkillCommon.tweenModelScaleOnHeartbeat(u56, skillRunData, u57, u63, u68, 0.7 * u61, 1 * u61, 0.15, {
                easingStyle = Enum.EasingStyle.Quad,
                easingDirection = Enum.EasingDirection.Out
            });
            tweenModelPivot(u56, skillRunData, u57, u64, u68, u71, u74, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end);
        task.delay(0.25, function() -- Line: 438
            -- upvalues: u56 (ref), u57 (ref), SkillCommon (ref), u68 (copy), tweenModelPivot (ref), skillRunData (ref), u65 (ref), u74 (copy), u75 (copy)
            if not (SkillCommon.isRunningSameGeneration(u56, u57) and u68.Parent) then
                return;
            end;

            tweenModelPivot(u56, skillRunData, u57, u65, u68, u74, u75, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        end);
        task.delay(0.367, function() -- Line: 456
            -- upvalues: u56 (ref), u57 (ref), SkillCommon (ref), groundBurstCF (ref), u75 (copy), u66 (copy), u61 (ref), skillRunData (ref), borrowPooledModel (ref), VisibleMgr (ref), FXUtil (ref), u60 (ref)
            if not SkillCommon.isRunningSameGeneration(u56, u57) then
                return;
            end;

            local v77 = groundBurstCF(u75, u66.forward, u61);
            local v78 = skillRunData.material["万磁王_地面爆炸"];
            local u79 = v78 and v78:IsA("Model") and borrowPooledModel(v78);

            if u79 then
                u79:ScaleTo(u61);
                VisibleMgr.UnQueryAll(u79);
                u79:PivotTo(v77);
                u79.Parent = workspace.Debris;
                SkillCommon.appendRunSpawnList(skillRunData, "MagnetoSpawned", u79);
                FXUtil.Emit_Particles_GetDescendants(u79, true);
                task.delay(2, function() -- Line: 471
                    -- upvalues: SkillCommon (ref), skillRunData (ref), u79 (copy)
                    SkillCommon.returnPooledModelFromSpawnList(skillRunData, "MagnetoSpawned", u79);
                end);
            end;

            if u60 == 1 then
                SkillCommon.playSoundLocal3D("音效-技能-万磁王-攻击", v77.Position);
            end;
        end);
        task.delay(0.4, function() -- Line: 480
            -- upvalues: u56 (ref), u57 (ref), SkillCommon (ref), u68 (copy), FXUtil (ref), u58 (ref), skillRunData (ref)
            if not SkillCommon.isRunningSameGeneration(u56, u57) then
                return;
            end;

            if u68.Parent then
                FXUtil.Instance_Transparency_Tween(u68, 0.017, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;

            local v80 = u68:FindFirstChild(u58.fxNodeName, true);

            if v80 then
                FXUtil.SetEmittersTrailsBeamsEnabled(v80, false);
                FXUtil.OffEnableVfx(v80);
            end;

            task.delay(0.017, function() -- Line: 498
                -- upvalues: SkillCommon (ref), skillRunData (ref), u68 (ref)
                SkillCommon.returnPooledModelFromSpawnList(skillRunData, "MagnetoSpawned", u68);
            end);
        end);
    end);
end;

local function scheduleStrikeHitServer(u81, u82, u83, p84, p85, p86) -- Line: 506
    -- upvalues: SkillCommon (copy), refreshLockedStrike (copy), landCFFromBaked (copy), groundBurstCF (copy)
    local u87 = u81.hitbox[1];

    if not (u81.skillInputData and (u87 and u87.hitbox)) then
        return;
    end;

    local u88 = SkillCommon.scaleBandFromData(u81, SkillCommon.bandScaleOptsFromSkillData(u81));
    local u89 = 14 * u88;
    local u90 = "magnetoStrike_" .. p86;
    task.delay(p84, function() -- Line: 523
        -- upvalues: u81 (copy), u82 (copy), SkillCommon (ref), refreshLockedStrike (ref), u90 (copy), u88 (copy)
        if not SkillCommon.isRunningSameGeneration(u81, u82) then
            return;
        end;

        refreshLockedStrike(u81, u90, u88);
    end);
    task.delay(p85, function() -- Line: 530
        -- upvalues: u81 (copy), u82 (copy), SkillCommon (ref), u90 (copy), u88 (copy), refreshLockedStrike (ref), landCFFromBaked (ref), u83 (copy), groundBurstCF (ref), u87 (copy), u89 (copy)
        if not SkillCommon.isRunningSameGeneration(u81, u82) then
            return;
        end;

        local v91 = u81;
        local v92 = u90;
        local skillRunData = v91.skillRunData;
        local v93 = skillRunData and skillRunData.Logic and skillRunData.Logic[v92] or refreshLockedStrike(v91, v92, u88);
        local hrpCenter = v93.hrpCenter;
        local forward = v93.forward;
        local Position = groundBurstCF(landCFFromBaked(CFrame.lookAt(hrpCenter, hrpCenter + (forward.Magnitude < 0.05 and Vector3.new(0, 0, -1) or forward).Unit, Vector3.new(0, 1, 0)), u83.landLocal, u83.landOri, u88), v93.forward, u88).Position;
        u87.hitbox.Size = Vector3.new(u89, u89, u89);
        SkillCommon.pulseSphereHitboxAtPos(u87, Position, Vector3.new(u89, u89, u89), 0.12);
    end);
end;

local function cleanupStrikeRunEvents(p94) -- Line: 543
    -- upvalues: SkillCommon (copy)
    if not p94 then
        return;
    end;

    local v95 = {};

    for i = 1, 10 do
        table.insert(v95, "万磁王模型缩放" .. i);
        table.insert(v95, "万磁王CFrame升起" .. i);
        table.insert(v95, "万磁王CFrame落下" .. i);
    end;

    SkillCommon.disconnectRunEventKeys(p94, v95);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.73,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 2.083,
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

function v1.Client_EnterStartup(p96) -- Line: 593
    -- upvalues: SkillCommon (copy)
    local v97 = p96.skillInputData and p96.skillInputData.character;

    if not v97 then
        return;
    end;

    local v98 = SkillCommon.resolveWandTipFromCharacter(v97);

    if v98 then
        SkillCommon.scheduleWandTipElementTrail(p96, v98, {
            trailMaterialKey = "空间系尾迹",
            runEventKey = "万磁王Cast尾迹",
            enableAt = 0.3,
            disableAt = 0.9
        });
    end;
end;

function v1.Server_EnterStartup(p99) -- Line: 609
    -- upvalues: SkillCommon (copy)
    local v100 = p99.hitbox[1];

    if v100 and v100.hitbox then
        local v101 = 14 * SkillCommon.scaleBandFromData(p99, SkillCommon.bandScaleOptsFromSkillData(p99));
        v100.hitbox.Size = Vector3.new(v101, v101, v101);
    end;
end;

function v1.Client_EnterMain(u102) -- Line: 618
    -- upvalues: SkillCommon (copy), spawnCasterFormation (copy), u4 (copy), u2 (copy), runStrikeModelClient (copy)
    local skillInputData = u102.skillInputData;
    local skillRunData = u102.skillRunData;

    if not (skillInputData and (skillRunData and skillRunData.material)) then
        return;
    end;

    local runGeneration = u102.runGeneration;
    local v103 = SkillCommon.scaleBandFromData(u102, SkillCommon.bandScaleOptsFromSkillData(u102));
    local v104 = skillInputData.character and skillInputData.character:FindFirstChild("HumanoidRootPart");
    task.delay(4.05, function() -- Line: 628
        -- upvalues: u102 (copy), runGeneration (copy), SkillCommon (ref), skillRunData (copy)
        if not SkillCommon.isRunningSameGeneration(u102, runGeneration) then
            return;
        end;

        SkillCommon.returnAllRunSpawnListToPool(skillRunData, "MagnetoSpawned");
    end);
    local v105 = skillRunData.material["万磁王_法阵"];

    if v105 and (v105:IsA("Model") and v104) then
        spawnCasterFormation(skillRunData, v105, v104, v103);
    end;

    local v106 = 0;

    for _ = 1, 2 do
        for _, v in ipairs(u4) do
            v106 = v106 + 1;
            runStrikeModelClient(u102, runGeneration, v, u2[v106], v106);
        end;
    end;
end;

function v1.Client_ExitMain(p107) -- Line: 651
    -- upvalues: cleanupStrikeRunEvents (copy)
    cleanupStrikeRunEvents(p107.skillRunData);
end;

function v1.Server_EnterMain(p108) -- Line: 655
    -- upvalues: u4 (copy), u2 (copy), u3 (copy), scheduleStrikeHitServer (copy)
    if not p108.skillInputData then
        return;
    end;

    local runGeneration = p108.runGeneration;
    local v109 = 0;

    for _ = 1, 2 do
        for _, v in ipairs(u4) do
            v109 = v109 + 1;
            scheduleStrikeHitServer(p108, runGeneration, v, u2[v109], u3[v109], v109);
        end;
    end;
end;

function v1.Server_ExitMain(p110) -- Line: 672
end;

function v1.Client_EnterRecovery(p111) -- Line: 674
    -- upvalues: SkillCommon (copy), cleanupStrikeRunEvents (copy)
    local skillRunData = p111.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "万磁王Cast尾迹");
        cleanupStrikeRunEvents(skillRunData);
    end;
end;

function v1.Server_EnterRecovery(p112) -- Line: 682
    local v113 = p112.hitbox[1];

    if v113 and v113.isActive then
        v113:stop();
    end;

    p112:releaseControl();
end;

function v1.onEnd(p114) -- Line: 690
    -- upvalues: cleanupStrikeRunEvents (copy), SkillCommon (copy)
    local skillRunData = p114.skillRunData;

    if not skillRunData then
        return;
    end;

    cleanupStrikeRunEvents(skillRunData);
    SkillCommon.returnAllRunSpawnListToPool(skillRunData, "MagnetoSpawned");
    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "万磁王Cast尾迹");
end;

function v1.onClearRunData(p115, p116) -- Line: 700
    -- upvalues: cleanupStrikeRunEvents (copy), SkillCommon (copy)
    if not p116 then
        return;
    end;

    cleanupStrikeRunEvents(p116);
    SkillCommon.returnAllRunSpawnListToPool(p116, "MagnetoSpawned");
    SkillCommon.cleanupWandTipTrailFromMaterial(p116, "空间系尾迹", "万磁王Cast尾迹");
end;

function v1.onEndServer(p117) -- Line: 709
    local v118 = p117.hitbox[1];

    if v118 and v118.isActive then
        v118:stop();
    end;
end;

v1.SoundList = { "音效-技能-万磁王-法阵", "音效-技能-万磁王-攻击" };
v1.AnimateList = { "技能释放动作4" };
v1.ResNameList = { "空间系尾迹", "万磁王_法阵", "万磁王_地面爆炸", "魔能钉刺", "符文铁片", "铁砧", "锁链重锤", "齿轮" };
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
        overTime = 1.4,
        animationName = "技能释放动作4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;