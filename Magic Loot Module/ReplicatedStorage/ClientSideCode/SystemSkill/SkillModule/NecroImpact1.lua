-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local MathMgr = UtilsSystem.MathMgr;
local RunService = UtilsSystem.RunService;
local TweenService = game:GetService("TweenService");
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Dark,
    skillDistanceLimit = 64
};
local u2 = CFrame.Angles(0, 0, 0);
local u3 = {
    skullMove = "死灵冲击骷髅位移"
};

local function cleanupRunFx(p4) -- Line: 57
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p4.skillRunData, { "死灵冲击骷髅位移" });
end;

local function stillChannel(p5, p6) -- Line: 63
    local v7 = p5:isRunningFlow() and p5.runGeneration == p6;

    return v7;
end;

local function strikePosAfterRefresh(p8) -- Line: 67
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p8);
    local skillInputData = p8.skillInputData;

    if skillInputData then
        return SkillCommon.resolveStrikeWorldPos(skillInputData);
    end;

    return p8:getTargetCF().Position;
end;

local function resolveLiveStrikePos(p9, p10) -- Line: 79
    -- upvalues: SkillCommon (copy)
    if p9 then
        p9 = SkillCommon.resolveTrackTargetHrp(p9);
    end;

    if p9 and p9.Parent then
        return p9.Position;
    end;

    return p10;
end;

local function horizontalStrikeFaceRot(p11, p12) -- Line: 88
    -- upvalues: SkillCommon (copy), MathMgr (copy)
    local _, v13 = SkillCommon.horizontalHrpStrikeFlatBasis(p11, p12);

    return MathMgr.rotLookAtForwardSafe(v13, Vector3.new(0, 1, 0), p11.CFrame.RightVector);
end;

local function horizontalStrikeFaceBackRot(p14, p15) -- Line: 94
    -- upvalues: SkillCommon (copy), MathMgr (copy)
    local _, v16 = SkillCommon.horizontalHrpStrikeFlatBasis(p14, p15);

    return MathMgr.rotLookAtForwardSafe(-v16, Vector3.new(0, 1, 0), p14.CFrame.RightVector);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Recovery";
v1.States = {
    Startup = {
        Duration = 0.5,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Channel = {
        Duration = 4.5,
        OnEnterClient = "Client_EnterChannel",
        OnEnterServer = "Server_EnterChannel",
        OnExitClient = "Client_ExitChannel",
        OnExitServer = "Server_ExitChannel"
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
        To = "Channel",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Channel",
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
        From = "Channel",
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
        From = "Channel",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function v1.Client_EnterStartup(p17) -- Line: 141
    -- upvalues: SkillCommon (copy)
    local v18 = p17.skillInputData and p17.skillInputData.character;

    if not v18 then
        return;
    end;

    local v19 = SkillCommon.resolveWandTipFromCharacter(v18);

    if v19 then
        SkillCommon.scheduleWandTipElementTrail(p17, v19, {
            trailMaterialKey = "暗系尾迹2",
            runEventKey = "死灵冲击Cast尾迹",
            enableAt = 0.27,
            disableAt = 0.9
        });
    end;
end;

function v1.Server_EnterStartup(p20) -- Line: 157
    -- upvalues: SkillCommon (copy)
    local v21 = 28 * SkillCommon.scaleBandFromData(p20, SkillCommon.bandScaleOptsFromSkillData(p20));
    local v22 = Vector3.new(v21, v21, v21);
    local v23 = p20.hitbox[1];

    if v23 and v23.hitbox then
        v23.hitbox.Size = v22;
    end;
end;

function v1.Client_EnterChannel(u24) -- Line: 168
    -- upvalues: SkillCommon (copy), MathMgr (copy), u2 (copy), FXUtil (copy), VisibleMgr (copy), RunService (copy), TweenService (copy)
    local skillInputData = u24.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u24.runGeneration;
    local skillRunData = u24.skillRunData;
    local u25 = SkillCommon.scaleBandFromData(u24, SkillCommon.bandScaleOptsFromSkillData(u24));
    local v26 = skillRunData.material["死灵冲击法阵"];
    local u27 = skillRunData.material["死灵冲击骷髅Emit和Enabled"];
    local v28 = skillRunData.material["死灵冲击骷髅出现时特效"];
    local u29 = skillRunData.material["死灵冲击爆炸"];

    if skillRunData.runEvent["死灵冲击骷髅位移"] then
        skillRunData.runEvent["死灵冲击骷髅位移"]:Disconnect();
        skillRunData.runEvent["死灵冲击骷髅位移"] = nil;
    end;

    local u30 = false;

    local function doImpactAt(p31, p32) -- Line: 198
        -- upvalues: u30 (ref), skillRunData (copy), u27 (copy), HumanoidRootPart (copy), SkillCommon (ref), MathMgr (ref), u2 (ref), FXUtil (ref), VisibleMgr (ref), u29 (copy), u25 (copy), u24 (copy), runGeneration (copy)
        if u30 then
            return;
        end;

        u30 = true;
        local v33 = skillRunData.runEvent["死灵冲击骷髅位移"];

        if v33 then
            v33:Disconnect();
            skillRunData.runEvent["死灵冲击骷髅位移"] = nil;
        end;

        if u27 and u27.Parent then
            local v34 = p32 or u27:GetPivot().Position;

            if oriLocal then
                local v35 = CFrame.new(v34);
                local v36 = HumanoidRootPart;
                local _, v37 = SkillCommon.horizontalHrpStrikeFlatBasis(v36, p31);
                u27:PivotTo(v35 * MathMgr.rotLookAtForwardSafe(v37, Vector3.new(0, 1, 0), v36.CFrame.RightVector) * oriLocal * u2);
            end;

            FXUtil.Stop_All_Emit(u27);
            FXUtil.SetEmittersTrailsBeamsEnabled(u27, false);
            FXUtil.OffEnableVfx(u27);
            VisibleMgr.fadeAll(u27, 1);
        end;

        if u29 then
            VisibleMgr.UnQueryAll(u29);
            u29:ScaleTo(u25);
            local v38 = CFrame.new(p31);
            local v39 = HumanoidRootPart;
            local _, v40 = SkillCommon.horizontalHrpStrikeFlatBasis(v39, p31);
            u29:PivotTo(v38 * MathMgr.rotLookAtForwardSafe(-v40, Vector3.new(0, 1, 0), v39.CFrame.RightVector));
            u29.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(u29, true);
            SkillCommon.appendRunSpawnList(skillRunData, "necroImpactSpawns", u29);
        end;

        SkillCommon.scheduleRunSpawnClear(u24, runGeneration, skillRunData, "necroImpactSpawns", 2);
    end;

    local v41 = u24:isRunningFlow() and u24.runGeneration == runGeneration;

    if not v41 then
        return;
    end;

    local v42 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart) + Vector3.new(0, 0.5, 0);
    local u43 = v42 + Vector3.new(0, 18, 0);
    SkillCommon.refreshSkillAimSnapshot(u24);
    local skillInputData2 = u24.skillInputData;
    local u44;

    if skillInputData2 then
        u44 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        u44 = u24:getTargetCF().Position;
    end;

    local u45 = 45 * u25;
    local u46 = 80 * u25;
    local u47 = 15 * u25;
    local u48 = math.clamp((u44 - u43).Magnitude * 0.12, 3, 40);

    if v26 then
        VisibleMgr.UnQueryAll(v26);
        v26:ScaleTo(u25);
        v26:PivotTo(CFrame.new(v42) * v26:GetPivot().Rotation);
        v26.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v26, true);
        SkillCommon.playSoundLocal3D("音效-技能-死灵法阵", v26:GetPivot().Position);
        SkillCommon.appendRunSpawnList(skillRunData, "necroImpactSpawns", v26);
    end;

    if v28 then
        VisibleMgr.UnQueryAll(v28);
        v28:ScaleTo(u25);
        v28:PivotTo(CFrame.new(u43) * v28:GetPivot().Rotation);
        v28.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v28, true);
        SkillCommon.appendRunSpawnList(skillRunData, "necroImpactSpawns", v28);
    end;

    local u49;

    if u27 then
        VisibleMgr.UnQueryAll(u27);
        u27:ScaleTo(u25);
        u49 = u27:GetPivot() - u27:GetPivot().Position;
        local _, v50 = MathMgr.spiralFibLikeChordPosTangent(u43, u44, 0, u48, u45, u47, u46);
        local v51 = MathMgr.rotLookAtForwardSafe(v50, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector);

        if u49 then
            u27:PivotTo(CFrame.new(u43) * v51 * u49 * u2);
        end;

        u27.Parent = workspace.Debris;
        FXUtil.SetEmittersTrailsBeamsEnabled(u27, true);
        FXUtil.Emit_Particles_GetDescendants(u27, false);
        SkillCommon.playSoundLocal3D("音效-技能-死灵冲击-攻击", u27:GetPivot().Position);
        SkillCommon.appendRunSpawnList(skillRunData, "necroImpactSpawns", u27);
    else
        u49 = nil;
    end;

    local u52 = 0;
    skillRunData.runEvent["死灵冲击骷髅位移"] = RunService.Heartbeat:Connect(function(p53) -- Line: 289
        -- upvalues: u24 (copy), runGeneration (copy), u30 (ref), u27 (copy), u52 (ref), TweenService (ref), skillInputData (copy), u44 (copy), SkillCommon (ref), MathMgr (ref), u43 (copy), u48 (copy), u45 (copy), u47 (copy), u46 (copy), HumanoidRootPart (copy), u49 (ref), u2 (ref), doImpactAt (copy)
        local v54 = u24;
        local v55 = v54:isRunningFlow() and v54.runGeneration == runGeneration;

        if not v55 or u30 then
            return;
        end;

        if not (u27 and u27.Parent) then
            return;
        end;

        u52 = u52 + p53;
        local v56 = math.clamp(u52 / 1, 0, 1);
        local v57 = TweenService:GetValue(v56, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        local v58 = skillInputData;
        local v59 = u44;

        if v58 then
            v58 = SkillCommon.resolveTrackTargetHrp(v58);
        end;

        if v58 and v58.Parent then
            v59 = v58.Position;
        end;

        local SPIRAL_FIB_SPIRAL_U_PORTION = MathMgr.SPIRAL_FIB_SPIRAL_U_PORTION;
        local v60 = SPIRAL_FIB_SPIRAL_U_PORTION - 0.0001 <= v57;
        local v61, v62;

        if v60 then
            v61 = select(1, MathMgr.spiralFibLikeChordPosTangent(u43, u44, SPIRAL_FIB_SPIRAL_U_PORTION, u48, u45, u47, u46)):Lerp(v59, (v57 - SPIRAL_FIB_SPIRAL_U_PORTION) / (1 - SPIRAL_FIB_SPIRAL_U_PORTION));
            local v63;
            v63, v62 = SkillCommon.horizontalHrpStrikeFlatBasis(HumanoidRootPart, v59);
        else
            v61, v62 = MathMgr.spiralFibLikeChordPosTangent(u43, u44, v57, u48, u45, u47, u46);
        end;

        if u49 then
            local v64 = MathMgr.rotLookAtForwardSafe(v62, Vector3.new(0, 1, 0), HumanoidRootPart.CFrame.RightVector);
            u27:PivotTo(CFrame.new(v61) * v64 * u49 * u2);
        else
            u27:PivotTo(CFrame.new(v61));
        end;

        if v60 and (v61 - v59).Magnitude < u47 then
            doImpactAt(v59, v61);

            return;
        end;

        if v56 >= 1 then
            doImpactAt(v59, v61);
        end;
    end);
    SkillCommon.scheduleRunSpawnClear(u24, runGeneration, skillRunData, "necroImpactSpawns", 4.5);
end;

function v1.Client_ExitChannel(p65) -- Line: 335
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p65.skillRunData, { u3.skullMove });
    local skillRunData = p65.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p65, p65.runGeneration, skillRunData, "necroImpactSpawns");
    end;
end;

function v1.Client_EnterRecovery(p66) -- Line: 343
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p66.skillRunData, { u3.skullMove });
end;

function v1.onEnd(p67) -- Line: 347
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p67.skillRunData, { u3.skullMove });
end;

function v1.Server_EnterChannel(u68) -- Line: 352
    -- upvalues: SkillCommon (copy), RunService (copy), TweenService (copy), MathMgr (copy)
    local skillInputData = u68.skillInputData;

    if not skillInputData then
        return;
    end;

    local u69 = u68.hitbox[1];

    if not (u69 and u69.hitbox) then
        return;
    end;

    local hitbox = u69.hitbox;
    local v70 = SkillCommon.scaleBandFromData(u68, SkillCommon.bandScaleOptsFromSkillData(u68));
    local u71 = 28 * v70;
    local v72 = nil;
    local v73;

    if skillInputData.character then
        v73 = skillInputData.character:FindFirstChild("HumanoidRootPart");

        if v73 then
            if not v73:IsA("BasePart") then
                v73 = v72;
            end;
        else
            v73 = v72;
        end;
    else
        v73 = v72;
    end;

    if not v73 then
        return;
    end;

    local runGeneration = u68.runGeneration;

    if u68.skillRunData.runEvent["死灵冲击骷髅位移"] then
        u68.skillRunData.runEvent["死灵冲击骷髅位移"]:Disconnect();
        u68.skillRunData.runEvent["死灵冲击骷髅位移"] = nil;
    end;

    local u74 = false;

    if not u68:isRunningFlow() or u68.runGeneration ~= runGeneration then
        return;
    end;

    local u75 = SkillCommon.casterFeetGroundWorldPos(v73) + Vector3.new(0, 0.5, 0) + Vector3.new(0, 18, 0);
    SkillCommon.refreshSkillAimSnapshot(u68);
    local skillInputData2 = u68.skillInputData;
    local u76;

    if skillInputData2 then
        u76 = SkillCommon.resolveStrikeWorldPos(skillInputData2);
    else
        u76 = u68:getTargetCF().Position;
    end;

    local u77 = 45 * v70;
    local u78 = 80 * v70;
    local u79 = 15 * v70;
    local u80 = math.clamp((u76 - u75).Magnitude * 0.12, 3, 40);

    local function doImpactSrv(p81) -- Line: 397
        -- upvalues: u74 (ref), u68 (copy), u71 (copy), hitbox (copy), u69 (copy)
        if u74 then
            return;
        end;

        u74 = true;
        local v82 = u68.skillRunData.runEvent["死灵冲击骷髅位移"];

        if v82 then
            v82:Disconnect();
            u68.skillRunData.runEvent["死灵冲击骷髅位移"] = nil;
        end;

        hitbox.Size = Vector3.new(u71, u71, u71);
        hitbox:PivotTo(CFrame.new(p81));

        if not u69.isActive then
            u69:start();
        end;

        task.delay(0.12, function() -- Line: 413
            -- upvalues: u69 (ref)
            if u69.isActive then
                u69:stop();
            end;
        end);
    end;

    local u83 = 0;
    u68.skillRunData.runEvent["死灵冲击骷髅位移"] = RunService.Heartbeat:Connect(function(p84) -- Line: 423
        -- upvalues: u68 (copy), runGeneration (copy), u74 (ref), u83 (ref), TweenService (ref), skillInputData (copy), u76 (copy), SkillCommon (ref), MathMgr (ref), u75 (copy), u80 (copy), u77 (copy), u79 (copy), u78 (copy), doImpactSrv (copy)
        if not u68:isRunningFlow() or (u68.runGeneration ~= runGeneration or u74) then
            return;
        end;

        u83 = u83 + p84;
        local v85 = math.clamp(u83 / 1, 0, 1);
        local v86 = TweenService:GetValue(v85, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        local v87 = skillInputData;
        local v88 = u76;

        if v87 then
            v87 = SkillCommon.resolveTrackTargetHrp(v87);
        end;

        if v87 and v87.Parent then
            v88 = v87.Position;
        end;

        local SPIRAL_FIB_SPIRAL_U_PORTION = MathMgr.SPIRAL_FIB_SPIRAL_U_PORTION;
        local v89 = SPIRAL_FIB_SPIRAL_U_PORTION - 0.0001 <= v86;
        local v90;

        if v89 then
            v90 = select(1, MathMgr.spiralFibLikeChordPosTangent(u75, u76, SPIRAL_FIB_SPIRAL_U_PORTION, u80, u77, u79, u78)):Lerp(v88, (v86 - SPIRAL_FIB_SPIRAL_U_PORTION) / (1 - SPIRAL_FIB_SPIRAL_U_PORTION));
        else
            v90 = select(1, MathMgr.spiralFibLikeChordPosTangent(u75, u76, v86, u80, u77, u79, u78));
        end;

        if v89 and (v90 - v88).Magnitude < u79 then
            doImpactSrv(v88);

            return;
        end;

        if v85 >= 1 then
            doImpactSrv(v88);
        end;
    end);
end;

function v1.Server_ExitChannel(p91) -- Line: 457
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p91.skillRunData, { u3.skullMove });
    local v92 = p91.hitbox[1];

    if v92 and v92.isActive then
        v92:stop();
    end;
end;

function v1.Server_EnterRecovery(p93) -- Line: 465
    p93:releaseControl();
end;

function v1.onEndServer(p94) -- Line: 469
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p94.skillRunData, { u3.skullMove });
    local v95 = p94.hitbox[1];

    if v95 and v95.isActive then
        v95:stop();
    end;
end;

v1.SoundList = { "音效-技能-死灵法阵", "音效-技能-死灵冲击-攻击" };
v1.AnimateList = { "魔法弹3" };
v1.ResNameList = { "暗系尾迹2", "死灵冲击法阵", "死灵冲击骷髅Emit和Enabled", "死灵冲击骷髅出现时特效", "死灵冲击爆炸" };
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
        overTime = 1,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1,
        animationName = "魔法弹3",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;