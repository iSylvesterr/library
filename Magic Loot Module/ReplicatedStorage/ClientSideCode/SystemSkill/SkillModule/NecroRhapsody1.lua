-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Dark,
    skillDistanceLimit = 73
};
local u2 = {
    hitPulse = "死灵狂想曲命中盒"
};

local function cleanupRunFx(p3) -- Line: 48
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p3.skillRunData, { "死灵狂想曲命中盒" });
end;

local function stillChannel(p4, p5) -- Line: 54
    local v6 = p4:isRunningFlow() and p4.runGeneration == p5;

    return v6;
end;

local function strikeGroundAfterRefresh(p7, p8, p9, p10, p11) -- Line: 58
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p7);
    local v12 = SkillCommon.resolveTrackTargetHrp(p8);

    if v12 then
        return SkillCommon.getGroundCF(CFrame.new(v12.Position), p9, p10, p11).Position;
    end;

    return SkillCommon.getGroundCF(p7:getTargetCF(), p9, p10, p11).Position;
end;

local function strikePosAfterRefresh(p13) -- Line: 73
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p13);

    return p13:getTargetCF().Position;
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Recovery";
v1.States = {
    Startup = {
        Duration = 0.47,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Channel = {
        Duration = 7.5,
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

function v1.Client_EnterStartup(p14) -- Line: 122
    -- upvalues: SkillCommon (copy)
    local v15 = p14.skillInputData and p14.skillInputData.character;

    if not v15 then
        return;
    end;

    local v16 = SkillCommon.resolveWandTipFromCharacter(v15);

    if v16 then
        SkillCommon.scheduleWandTipElementTrail(p14, v16, {
            trailMaterialKey = "暗系尾迹2",
            runEventKey = "死灵狂想曲Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.8
        });
    end;
end;

function v1.Server_EnterStartup(p17) -- Line: 139
    -- upvalues: SkillCommon (copy)
    local v18 = 42 * SkillCommon.scaleBandFromData(p17, SkillCommon.bandScaleOptsFromSkillData(p17));
    local v19 = Vector3.new(v18, v18, v18);
    local v20 = p17.hitbox[1];

    if v20 and v20.hitbox then
        v20.hitbox.Size = v19;
    end;
end;

function v1.Client_EnterChannel(u21) -- Line: 150
    -- upvalues: SkillCommon (copy), strikeGroundAfterRefresh (copy), VisibleMgr (copy), FXUtil (copy)
    local skillInputData = u21.skillInputData;

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

    local runGeneration = u21.runGeneration;
    local skillRunData = u21.skillRunData;
    local v22 = SkillCommon.scaleBandFromData(u21, SkillCommon.bandScaleOptsFromSkillData(u21));
    local v23 = skillRunData.material["死灵狂想曲法阵"];
    local v24 = skillRunData.material["死灵狂想曲爆炸"];
    local u25 = skillRunData.material["死灵狂想曲死灵缠绕特效"];
    local v26 = u21:isRunningFlow() and u21.runGeneration == runGeneration;

    if not v26 then
        return;
    end;

    local v27 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart) + Vector3.new(0, 0.5, 0);
    local v28 = strikeGroundAfterRefresh(u21, skillInputData) + Vector3.new(0, 0.85, 0);

    if v23 then
        VisibleMgr.UnQueryAll(v23);
        v23:ScaleTo(v22);
        v23:PivotTo(CFrame.new(v27) * v23:GetPivot().Rotation);
        v23.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v23, true);
        SkillCommon.playSoundLocal3D("音效-技能-死灵法阵", v23:GetPivot().Position);
        SkillCommon.appendRunSpawnList(skillRunData, "necroRhapsodySpawns", v23);
    end;

    if v24 then
        VisibleMgr.UnQueryAll(v24);
        v24:ScaleTo(v22);
        v24:PivotTo(CFrame.new(v28) * v24:GetPivot().Rotation);
        v24.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v24, true);
        SkillCommon.appendRunSpawnList(skillRunData, "necroRhapsodySpawns", v24);
    end;

    if u25 then
        VisibleMgr.UnQueryAll(u25);
        u25:ScaleTo(v22);
        u25:PivotTo(CFrame.new(v28) * u25:GetPivot().Rotation);
        u25.Parent = workspace.Debris;
        FXUtil.SetEmittersTrailsBeamsEnabled(u25, true);
        FXUtil.Emit_Particles_GetDescendants(u25, false);
        SkillCommon.playSoundLocal3D("音效-技能-死灵狂想曲-攻击", u25:GetPivot().Position);
        SkillCommon.appendRunSpawnList(skillRunData, "necroRhapsodySpawns", u25);
    end;

    task.delay(5, function() -- Line: 213
        -- upvalues: u21 (copy), runGeneration (copy), u25 (copy), FXUtil (ref)
        local v29 = u21;
        local v30 = v29:isRunningFlow() and v29.runGeneration == runGeneration;

        if not v30 then
            return;
        end;

        if u25 and u25.Parent then
            FXUtil.Stop_All_Emit(u25);
            FXUtil.SetEmittersTrailsBeamsEnabled(u25, false);
            FXUtil.OffEnableVfx(u25);
        end;
    end);
    task.delay(7, function() -- Line: 225
        -- upvalues: u21 (copy), runGeneration (copy), u25 (copy)
        local v31 = u21;
        local v32 = v31:isRunningFlow() and v31.runGeneration == runGeneration;

        if not v32 then
            return;
        end;

        if u25 and u25.Parent then
            u25:Destroy();
        end;
    end);
    SkillCommon.scheduleRunSpawnClear(u21, runGeneration, skillRunData, "necroRhapsodySpawns", 7.5);
end;

function v1.Client_ExitChannel(p33) -- Line: 237
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p33.skillRunData, { u2.hitPulse });
    local skillRunData = p33.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p33, p33.runGeneration, skillRunData, "necroRhapsodySpawns");
    end;
end;

function v1.Client_EnterRecovery(p34) -- Line: 245
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p34.skillRunData, { u2.hitPulse });
end;

function v1.onEnd(p35) -- Line: 249
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p35.skillRunData, { u2.hitPulse });
end;

function v1.Server_EnterChannel(u36) -- Line: 254
    -- upvalues: SkillCommon (copy), RunService (copy)
    if not u36.skillInputData then
        return;
    end;

    local u37 = u36.hitbox[1];

    if not (u37 and u37.hitbox) then
        return;
    end;

    local hitbox = u37.hitbox;
    local u38 = 42 * SkillCommon.scaleBandFromData(u36, SkillCommon.bandScaleOptsFromSkillData(u36));
    local runGeneration = u36.runGeneration;

    if u36.skillRunData.runEvent["死灵狂想曲命中盒"] then
        u36.skillRunData.runEvent["死灵狂想曲命中盒"]:Disconnect();
        u36.skillRunData.runEvent["死灵狂想曲命中盒"] = nil;
    end;

    local u39 = 0;
    local u40 = 0;
    u36.skillRunData.runEvent["死灵狂想曲命中盒"] = RunService.Heartbeat:Connect(function(p41) -- Line: 275
        -- upvalues: u36 (copy), runGeneration (copy), u37 (copy), u39 (ref), u40 (ref), SkillCommon (ref), u38 (copy), hitbox (copy)
        if u36:isRunningFlow() and u36.runGeneration == runGeneration then
            u39 = u39 + p41;

            while u40 < 5 and u39 >= u40 * 1 do
                if u37.isActive then
                    u37:stop();
                end;

                local v42 = u36;
                SkillCommon.refreshSkillAimSnapshot(v42);
                local Position = v42:getTargetCF().Position;
                hitbox.Size = Vector3.new(u38, u38, u38);
                hitbox:PivotTo(CFrame.new(Position));
                u37:start();
                u40 = u40 + 1;
            end;

            if u39 >= 5 then
                if u37.isActive then
                    u37:stop();
                end;

                local v43 = u36.skillRunData.runEvent["死灵狂想曲命中盒"];

                if v43 then
                    v43:Disconnect();
                    u36.skillRunData.runEvent["死灵狂想曲命中盒"] = nil;
                end;
            end;

            return;
        end;

        if u37.isActive then
            u37:stop();
        end;

        local v44 = u36.skillRunData.runEvent["死灵狂想曲命中盒"];

        if v44 then
            v44:Disconnect();
            u36.skillRunData.runEvent["死灵狂想曲命中盒"] = nil;
        end;
    end);
end;

function v1.Server_ExitChannel(p45) -- Line: 314
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p45.skillRunData, { u2.hitPulse });
    local v46 = p45.hitbox[1];

    if v46 and v46.isActive then
        v46:stop();
    end;
end;

function v1.Server_EnterRecovery(p47) -- Line: 322
    p47:releaseControl();
end;

function v1.onEndServer(p48) -- Line: 326
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p48.skillRunData, { u2.hitPulse });
    local v49 = p48.hitbox[1];

    if v49 and v49.isActive then
        v49:stop();
    end;
end;

v1.SoundList = { "音效-技能-死灵法阵", "音效-技能-死灵狂想曲-攻击" };
v1.AnimateList = { "技能释放动作9" };
v1.ResNameList = { "暗系尾迹2", "死灵狂想曲法阵", "死灵狂想曲爆炸", "死灵狂想曲死灵缠绕特效" };
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