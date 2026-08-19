-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local Debris = game:GetService("Debris");
local TweenService = game:GetService("TweenService");
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Space,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "Main"
};

local function resolveCasterFormationCF(p2, p3) -- Line: 58
    -- upvalues: SkillCommon (copy)
    local v4 = SkillCommon.casterFeetGroundWorldPos(p2, 4, 0.5, "Ground") + Vector3.new(0, 0.5, 0);
    local LookVector = p2.CFrame.LookVector;
    local v5 = Vector3.new(LookVector.X, 0, LookVector.Z);

    if v5.Magnitude > 0.05 then
        return CFrame.lookAt(v4, v4 + v5.Unit) * p3;
    end;

    return CFrame.new(v4) * p3;
end;

local function stopFormationFollow(p6) -- Line: 69
    -- upvalues: SkillCommon (copy)
    if not p6 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p6, { "空间光柱法阵跟随" });
end;

local function strikeGroundAfterRefresh(p7, p8, p9, p10) -- Line: 76
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p7);

    return SkillCommon.getGroundCF(p7:getTargetCF(), p8, p9, p10).Position;
end;

v1.States = {
    Startup = {
        Duration = 0.85,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Main = {
        Duration = 1.4699999999999998,
        OnEnterClient = "Client_EnterMain",
        OnEnterServer = "Server_EnterMain",
        OnExitClient = "Client_ExitMain",
        OnExitServer = "Server_ExitMain"
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

function v1.Client_EnterStartup(u11) -- Line: 127
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), resolveCasterFormationCF (copy), RunService (copy), FXUtil (copy), TweenService (copy), Debris (copy)
    local skillInputData = u11.skillInputData;
    local u12;

    if skillInputData then
        u12 = skillInputData.character;
    else
        u12 = skillInputData;
    end;

    if not u12 then
        return;
    end;

    local v13 = SkillCommon.resolveWandTipFromCharacter(u12);

    if v13 then
        SkillCommon.scheduleWandTipElementTrail(u11, v13, {
            trailMaterialKey = "空间系尾迹",
            runEventKey = "空间光柱Cast尾迹",
            enableAt = 0.33,
            disableAt = 2.32
        });
    end;

    local runGeneration = u11.runGeneration;
    local skillRunData = u11.skillRunData;

    if not (skillInputData and (skillRunData and skillRunData.material)) then
        return;
    end;

    local u14 = SkillCommon.scaleBandFromData(u11, SkillCommon.bandScaleOptsFromSkillData(u11));
    local u15 = 4 * u14;
    local u16 = 0.5 * u14;
    SkillCommon.refreshSkillAimSnapshot(u11);
    local Position = SkillCommon.getGroundCF(u11:getTargetCF(), u15, u16, "Ground").Position;
    local HumanoidRootPart = u12:FindFirstChild("HumanoidRootPart");
    task.delay(0.85, function() -- Line: 158
        -- upvalues: SkillCommon (ref), u11 (copy), runGeneration (copy), skillRunData (copy), u14 (copy), VisibleMgr (ref), HumanoidRootPart (copy), resolveCasterFormationCF (ref), Position (copy), RunService (ref), u12 (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u11, runGeneration) then
            return;
        end;

        local v17 = skillRunData.material["空间光柱法阵"];

        if not v17 then
            return;
        end;

        v17:ScaleTo(u14);
        VisibleMgr.UnQueryAll(v17);
        local Rotation = v17:GetPivot().Rotation;
        local v18;

        if HumanoidRootPart then
            v18 = HumanoidRootPart.CFrame.Rotation;
        else
            v18 = CFrame.identity;
        end;

        local u19 = v18:Inverse() * Rotation;

        if HumanoidRootPart then
            v17:PivotTo((resolveCasterFormationCF(HumanoidRootPart, u19)));
        else
            v17:PivotTo(CFrame.new(Position) * Rotation);
        end;

        v17.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "SpaceLightPillarSpawned", v17);
        skillRunData.slpFormation = v17;

        if HumanoidRootPart then
            local v20 = skillRunData;

            if v20 then
                SkillCommon.disconnectRunEventKeys(v20, { "空间光柱法阵跟随" });
            end;

            skillRunData.runEvent["空间光柱法阵跟随"] = RunService.Heartbeat:Connect(function() -- Line: 182
                -- upvalues: SkillCommon (ref), u11 (ref), runGeneration (ref), skillRunData (ref), u12 (ref), resolveCasterFormationCF (ref), u19 (copy)
                if not SkillCommon.isRunningSameGeneration(u11, runGeneration) then
                    return;
                end;

                local slpFormation = skillRunData.slpFormation;
                local HumanoidRootPart2 = u12:FindFirstChild("HumanoidRootPart");

                if not (slpFormation and (slpFormation.Parent and HumanoidRootPart2)) then
                    return;
                end;

                slpFormation:PivotTo((resolveCasterFormationCF(HumanoidRootPart2, u19)));
            end);
        end;

        local v21 = v17:FindFirstChild("Emit_法阵", true);

        if v21 then
            FXUtil.EmitBurstEmitInName(v21, true);
        end;

        local v22 = v17:FindFirstChild("吸收Emit和Enabled", true);

        if v22 then
            FXUtil.EmitBurstEmitInName(v22, true);
            FXUtil.SetEnableNameVfx(v22, true);
        end;

        SkillCommon.playSoundLocal3D("音效-技能-空间系法阵", v17:GetPivot().Position);
    end);
    task.delay(1.314161667192927, function() -- Line: 208
        -- upvalues: SkillCommon (ref), u11 (copy), runGeneration (copy), skillRunData (copy), Position (copy), u14 (copy), VisibleMgr (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u11, runGeneration) then
            return;
        end;

        local v23 = skillRunData.material["空间光柱爆炸"];

        if v23 then
            local v24 = Position + Vector3.new(0, 2 * u14, 0);
            v23:ScaleTo(u14);
            VisibleMgr.UnQueryAll(v23);
            v23:PivotTo(CFrame.new(v24) * v23:GetPivot().Rotation);
            v23.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v23, true);
            SkillCommon.appendRunSpawnList(skillRunData, "SpaceLightPillarSpawned", v23);
        end;

        local slpFormation = skillRunData.slpFormation;

        if slpFormation and slpFormation.Parent then
            local v25 = slpFormation:FindFirstChild("吸收爆Emit", true);

            if v25 then
                FXUtil.EmitBurstEmitInName(v25, true);
            end;

            local v26 = slpFormation:FindFirstChild("吸收Emit和Enabled", true);

            if v26 then
                FXUtil.OffEnableVfx(v26);
            end;
        end;
    end);
    task.delay(1.3758951689295862, function() -- Line: 243
        -- upvalues: SkillCommon (ref), u11 (copy), runGeneration (copy), skillRunData (copy), u15 (copy), u16 (copy), u14 (copy), VisibleMgr (ref), FXUtil (ref), TweenService (ref)
        if not SkillCommon.isRunningSameGeneration(u11, runGeneration) then
            return;
        end;

        local u27 = skillRunData.material["光柱"];

        if not u27 then
            return;
        end;

        local v28 = u11;
        SkillCommon.refreshSkillAimSnapshot(v28);
        local Position2 = SkillCommon.getGroundCF(v28:getTargetCF(), u15, u16, "Ground").Position;
        local v29 = Vector3.new(Position2.X, Position2.Y - 8 * u14, Position2.Z);
        u27:ScaleTo(u14);
        VisibleMgr.UnQueryAll(u27);
        u27.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "SpaceLightPillarSpawned", u27);
        skillRunData.slpPillar = u27;
        FXUtil.SetAllBasePartsSize(u27, Vector3.new(20, 20, 20) * u14);
        FXUtil.SetAllBasePartsTransparency(u27, 1);
        FXUtil.PivotModelOnGroundAtWorldY(u27, v29);
        SkillCommon.playSoundLocal3D("音效-技能-空间4阶-攻击", u27:GetPivot().Position);
        local u30 = FXUtil.CollectModelBaseParts(u27);

        if #u30 == 0 then
            return;
        end;

        local v31 = TweenInfo.new(0.03333333333333333, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

        for _, v in u30 do
            TweenService:Create(v, v31, {
                Transparency = 0.5
            }):Play();
        end;

        task.delay(0.03333333333333333, function() -- Line: 272
            -- upvalues: SkillCommon (ref), u11 (ref), runGeneration (ref), u27 (copy), u14 (ref), u30 (copy), TweenService (ref)
            if not (SkillCommon.isRunningSameGeneration(u11, runGeneration) and u27.Parent) then
                return;
            end;

            u27:PivotTo(u27:GetPivot() + Vector3.new(0, 17.5 * u14, 0));
            local v32 = Vector3.new(55, 20, 20) * u14;
            local v33 = TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);

            for _, v in u30 do
                TweenService:Create(v, v33, {
                    Transparency = 1,
                    Size = v32
                }):Play();
            end;
        end);
    end);
    task.delay(1.391676665614146, function() -- Line: 286
        -- upvalues: SkillCommon (ref), u11 (copy), runGeneration (copy), skillRunData (copy), Position (copy), u15 (copy), u16 (copy), u14 (copy), VisibleMgr (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u11, runGeneration) then
            return;
        end;

        local v34 = skillRunData.material["空间光柱Emit和Enabled"];

        if v34 and Position then
            local v35 = u11;
            SkillCommon.refreshSkillAimSnapshot(v35);
            local v36 = SkillCommon.getGroundCF(v35:getTargetCF(), u15, u16, "Ground").Position + Vector3.new(0, 8.5 * u14, 0);
            v34:ScaleTo(u14);
            VisibleMgr.UnQueryAll(v34);
            v34:PivotTo(CFrame.new(v36) * v34:GetPivot().Rotation);
            v34.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "SpaceLightPillarSpawned", v34);
            skillRunData.slpFxPillar = v34;
            FXUtil.EmitBurstEmitInName(v34, false);
            FXUtil.SetEmittersTrailsBeamsEnabled(v34, true);
        end;
    end);
    task.delay(2.32, function() -- Line: 305
        -- upvalues: SkillCommon (ref), u11 (copy), runGeneration (copy), skillRunData (copy), FXUtil (ref), Debris (ref)
        if not SkillCommon.isRunningSameGeneration(u11, runGeneration) then
            return;
        end;

        local slpFxPillar = skillRunData.slpFxPillar;

        if slpFxPillar and slpFxPillar.Parent then
            FXUtil.OffEnableVfx(slpFxPillar);
            FXUtil.SetEmittersTrailsBeamsEnabled(slpFxPillar, false);
            FXUtil.Model_Fade(slpFxPillar, 0.35);
            Debris:AddItem(slpFxPillar, 2);
            skillRunData.slpFxPillar = nil;
        end;

        local slpPillar = skillRunData.slpPillar;

        if slpPillar and slpPillar.Parent then
            FXUtil.Model_Fade(slpPillar, 0.4);
            Debris:AddItem(slpPillar, 2.5);
            skillRunData.slpPillar = nil;
        end;
    end);
    task.delay(4.82, function() -- Line: 325
        -- upvalues: SkillCommon (ref), u11 (copy), runGeneration (copy), skillRunData (copy)
        if not (SkillCommon.isRunningSameGeneration(u11, runGeneration) and skillRunData) then
            return;
        end;

        local v37 = skillRunData;

        if v37 then
            SkillCommon.disconnectRunEventKeys(v37, { "空间光柱法阵跟随" });
        end;

        skillRunData.slpFormation = nil;
        skillRunData.slpPillar = nil;
        skillRunData.slpFxPillar = nil;
    end);
    SkillCommon.scheduleRunSpawnClear(u11, runGeneration, skillRunData, "SpaceLightPillarSpawned", 4.82);
end;

function v1.Client_EnterMain(p38) -- Line: 338
end;

function v1.Client_ExitMain(p39) -- Line: 342
    -- upvalues: SkillCommon (copy)
    local skillRunData = p39.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "空间光柱法阵跟随" });
    end;

    SkillCommon.clearSpawnIfTerminalAfterExit(p39, p39.runGeneration, skillRunData, "SpaceLightPillarSpawned");
end;

function v1.Client_EnterRecovery(p40) -- Line: 351
    -- upvalues: SkillCommon (copy)
    local skillRunData = p40.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "空间光柱Cast尾迹");
    end;
end;

function v1.onEnd(p41) -- Line: 358
    -- upvalues: SkillCommon (copy)
    local skillRunData = p41.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "空间光柱法阵跟随" });
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "空间光柱Cast尾迹");
end;

function v1.Server_EnterStartup(p42) -- Line: 368
    -- upvalues: SkillCommon (copy)
    local v43 = p42.hitbox[1];

    if not (v43 and v43.hitbox) then
        return;
    end;

    local v44 = SkillCommon.scaleBandFromData(p42, SkillCommon.bandScaleOptsFromSkillData(p42));
    v43.hitbox.Size = Vector3.new(30, 75, 30) * v44;
end;

function v1.Server_EnterMain(u45) -- Line: 378
    -- upvalues: SkillCommon (copy), RunService (copy)
    local u46 = u45.hitbox[1];

    if not (u46 and u46.hitbox) then
        return;
    end;

    local skillInputData = u45.skillInputData;
    local v47 = SkillCommon.scaleBandFromData(u45, SkillCommon.bandScaleOptsFromSkillData(u45));
    u46.hitbox.Size = Vector3.new(30, 75, 30) * v47;
    SkillCommon.refreshSkillAimSnapshot(u45);
    local v48 = SkillCommon.getGroundCF(u45:getTargetCF(), 4 * v47, 0.5 * v47, "Ground").Position + Vector3.new(0, 37.5 * v47, 0);
    local v49 = SkillCommon.resolveTrackPos(skillInputData, v48);
    local u50 = CFrame.new((Vector3.new(v49.X, v48.Y, v49.Z)));
    local u51 = table.create(5);
    local u52 = 0.85;

    for i, v in ipairs({ 1.917, 2.333, 2.75, 3.167, 4 }) do
        local v53 = 0.85 + (v - 0.75) * 0.464161667192927;
        u51[i] = v53 > 2.32 and 2.32 or v53;
    end;

    local u54 = 0;
    local u55 = nil;
    u55 = RunService.Heartbeat:Connect(function(p56) -- Line: 406
        -- upvalues: u45 (copy), u52 (ref), u54 (ref), u51 (copy), u46 (copy), u50 (copy), u55 (ref)
        if not u45:isRunningFlow() then
            return;
        end;

        u52 = u52 + p56;

        while true do
            local v57 = u54 + 1;

            if #u51 < v57 or u52 < u51[v57] then
                break;
            end;

            u54 = v57;
            u46.hitbox:PivotTo(u50);
            u46:start();
            task.delay(0.12, function() -- Line: 420
                -- upvalues: u46 (ref)
                if u46.isActive then
                    u46:stop();
                end;
            end);
        end;

        if u52 >= 2.42 then
            u55:Disconnect();
        end;
    end);
    u45:BindRunConn(u55);
end;

function v1.Server_ExitMain(p58) -- Line: 433
    local v59 = p58.hitbox[1];

    if v59 and v59.isActive then
        v59:stop();
    end;
end;

function v1.Server_EnterRecovery(p60) -- Line: 440
    p60:releaseControl();
end;

function v1.onEndServer(p61) -- Line: 444
    local v62 = p61.hitbox[1];

    if v62 and v62.isActive then
        v62:stop();
    end;
end;

v1.SoundList = { "音效-技能-空间系法阵", "音效-技能-空间4阶-攻击" };
v1.AnimateList = { "技能释放动作8" };
v1.ResNameList = { "空间系尾迹", "空间光柱法阵", "光柱", "空间光柱爆炸", "空间光柱Emit和Enabled" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.85,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.32,
        animationName = "技能释放动作8",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;