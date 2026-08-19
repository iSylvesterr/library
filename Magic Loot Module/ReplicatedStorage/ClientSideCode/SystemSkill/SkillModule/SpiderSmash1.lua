-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SoundModule = UtilsSystem.SoundModule;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local AIM_RUN_EVENT_KEY = SkillTelegraph.AIM_RUN_EVENT_KEY;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.None,
    skillDistanceLimit = 64,
    animationPlaySide = "Server",
    InitialState = "Startup",
    ControlOpenState = "Swing",
    States = {
        Startup = {
            Duration = 1.03,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = "Client_ExitStartup",
            OnExitServer = nil
        },
        Swing = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterSwing",
            OnEnterServer = "Server_EnterSwing",
            OnExitClient = nil,
            OnExitServer = "Server_ExitSwing"
        },
        Recovery = {
            Duration = 0.6,
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
            IsTerminal = true,
            OnEnterClient = "Client_EnterInterrupted"
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "Swing",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Swing",
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
            From = "Swing",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Swing",
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

local function _getSkillScale(p2) -- Line: 125
    -- upvalues: SkillCommon (copy)
    return SkillCommon.npcSummonBodySkillScale(p2);
end;

local function _getHrp(p3) -- Line: 129
    local v4 = p3.skillInputData and p3.skillInputData.character;

    if v4 then
        return v4:FindFirstChild("HumanoidRootPart");
    end;

    return nil;
end;

local function _playStartupSounds(u5) -- Line: 137
    -- upvalues: SkillCommon (copy)
    local v6 = u5.skillInputData and u5.skillInputData.character;
    local v7;

    if v6 then
        v7 = v6:FindFirstChild("HumanoidRootPart");
    else
        v7 = nil;
    end;

    if not v7 then
        return;
    end;

    local runGeneration = u5.runGeneration;
    SkillCommon.playSoundLocal3DOnPart("音效-技能-boss下砸-前转身", v7);
    task.delay(1.5, function() -- Line: 145
        -- upvalues: u5 (copy), runGeneration (copy), SkillCommon (ref)
        if u5.runGeneration ~= runGeneration then
            return;
        end;

        local v8 = u5;
        local v9 = v8.skillInputData and v8.skillInputData.character;
        local v10;

        if v9 then
            v10 = v9:FindFirstChild("HumanoidRootPart");
        else
            v10 = nil;
        end;

        if v10 and v10.Parent then
            SkillCommon.playSoundLocal3DOnPart("音效-技能-boss下砸-后转身", v10);
        end;
    end);
end;

local function _resolveImpactAnchor(p11) -- Line: 164
    -- upvalues: SkillCommon (copy)
    local skillInputData = p11.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if not skillInputData then
        return nil;
    end;

    local HumanoidRootPart = skillInputData:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    local v12 = SkillCommon.npcSummonBodySkillScale(p11);
    local Position = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, v12 * -6)).Position;
    local Position2 = SkillCommon.getGroundCF(CFrame.new(Position), 4, 0.1, "Ground").Position;
    local _, v13 = SkillCommon.horizontalHrpStrikeFlatBasis(HumanoidRootPart, Position2);

    return {
        groundCenter = Position2,
        forward = v13
    };
end;

local function _resolveGroundAlignedCF(p14) -- Line: 193
    -- upvalues: FXUtil (copy)
    return FXUtil.GetGroundAlignedCF(p14.groundCenter, p14.forward, "Ground", 4, 0.1) or CFrame.new(p14.groundCenter + Vector3.new(0, 0.1, 0));
end;

local function _stopTelegraphAimLoop(p15) -- Line: 212
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    if not (p15 and p15.runEvent) then
        return;
    end;

    local v16 = p15.runEvent[AIM_RUN_EVENT_KEY];

    if v16 then
        v16:Disconnect();
        p15.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;
end;

local function _destroyDangerTelegraph(p17) -- Line: 228
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local v18 = p17 and p17.runEvent and p17.runEvent[AIM_RUN_EVENT_KEY];

    if v18 then
        v18:Disconnect();
        p17.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    if not (p17 and p17.Logic) then
        return;
    end;

    local dangerTelegraph = p17.Logic.dangerTelegraph;

    if dangerTelegraph then
        dangerTelegraph:destroy();
        p17.Logic.dangerTelegraph = nil;
    end;
end;

local function _resolveTelegraphPose(p19) -- Line: 247
    -- upvalues: _resolveImpactAnchor (copy), SkillCommon (copy), FXUtil (copy)
    local v20 = _resolveImpactAnchor(p19);

    if not v20 then
        return nil, nil;
    end;

    local v21 = SkillCommon.npcSummonBodySkillScale(p19) * 20;

    return FXUtil.GetGroundAlignedCF(v20.groundCenter, v20.forward, "Ground", 4, 0.1) or CFrame.new(v20.groundCenter + Vector3.new(0, 0.1, 0)), Vector3.new(v21, v21, v21);
end;

local function _startTelegraphAimLoop(u22, u23, u24) -- Line: 264
    -- upvalues: AIM_RUN_EVENT_KEY (copy), RunService (copy), SkillCommon (copy), _resolveImpactAnchor (copy), FXUtil (copy)
    local v25 = u23 and u23.runEvent and u23.runEvent[AIM_RUN_EVENT_KEY];

    if v25 then
        v25:Disconnect();
        u23.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    u23.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 266
        -- upvalues: SkillCommon (ref), u22 (copy), u24 (copy), u23 (copy), AIM_RUN_EVENT_KEY (ref), _resolveImpactAnchor (ref), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u22, u24) then
            local v26 = u23;

            if v26 then
                if not v26.runEvent then
                    return;
                end;

                local v27 = v26.runEvent[AIM_RUN_EVENT_KEY];

                if v27 then
                    v27:Disconnect();
                    v26.runEvent[AIM_RUN_EVENT_KEY] = nil;
                end;
            end;

            return;
        end;

        local v28 = u23.Logic and u23.Logic.dangerTelegraph;

        if not v28 then
            return;
        end;

        local v29 = u22;
        local v30 = _resolveImpactAnchor(v29);
        local v31, v32;

        if v30 then
            local v33 = SkillCommon.npcSummonBodySkillScale(v29) * 20;
            v31 = FXUtil.GetGroundAlignedCF(v30.groundCenter, v30.forward, "Ground", 4, 0.1) or CFrame.new(v30.groundCenter + Vector3.new(0, 0.1, 0));
            v32 = Vector3.new(v33, v33, v33);
        else
            v31 = nil;
            v32 = nil;
        end;

        if not (v31 and v32) then
            return;
        end;

        v28:update({
            worldCFrame = v31,
            hitboxSize = v32
        });
    end);
end;

local function _deployImpactFx(p34, p35, p36, p37) -- Line: 286
    -- upvalues: VisibleMgr (copy), FXUtil (copy), SkillCommon (copy)
    local v38 = p34.material[p35];

    if not v38 then
        return;
    end;

    VisibleMgr.UnQueryAll(v38);

    if v38:IsA("Model") then
        v38:ScaleTo(p37);
    end;

    v38:PivotTo(p36);
    v38.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v38, true);
    SkillCommon.appendRunSpawnList(p34, "spiderSmashSpawns", v38);
end;

local function _playImpactFx(p39, p40) -- Line: 306
    -- upvalues: SkillCommon (copy), FXUtil (copy), _deployImpactFx (copy), SoundModule (copy)
    local skillRunData = p39.skillRunData;
    local v41 = SkillCommon.npcSummonBodySkillScale(p39);
    local v42 = FXUtil.GetGroundAlignedCF(p40.groundCenter, p40.forward, "Ground", 4, 0.1) or CFrame.new(p40.groundCenter + Vector3.new(0, 0.1, 0));
    _deployImpactFx(skillRunData, "蜘蛛坠击地面特效", v42, v41);
    _deployImpactFx(skillRunData, "蜘蛛坠击爆炸特效", v42, v41);
    SoundModule:PlaySoundLocal({
        SoundName = "音效-技能-boss下砸-攻击",
        Is2D = false,
        PlayPosition = v42.Position
    });
    SkillCommon.scheduleRunSpawnClear(p39, p39.runGeneration, skillRunData, "spiderSmashSpawns", 2);
end;

local function _pulseImpactHitbox(p43, p44) -- Line: 323
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    local u45 = p43.hitbox[1];

    if not (u45 and u45.hitbox) then
        return;
    end;

    local v46 = SkillCommon.npcSummonBodySkillScale(p43) * 20;
    local v47 = FXUtil.GetGroundAlignedCF(p44.groundCenter, p44.forward, "Ground", 4, 0.1) or CFrame.new(p44.groundCenter + Vector3.new(0, 0.1, 0));
    u45.hitbox.Size = Vector3.new(v46, v46, v46);
    u45.hitbox:PivotTo(v47);
    u45:start();
    task.delay(0.2, function() -- Line: 340
        -- upvalues: u45 (copy)
        if u45.isActive then
            u45:stop();
        end;
    end);
end;

function v1.Client_EnterStartup(u48) -- Line: 350
    -- upvalues: _playStartupSounds (copy), AIM_RUN_EVENT_KEY (copy), _resolveImpactAnchor (copy), SkillCommon (copy), FXUtil (copy), SkillTelegraph (copy), RunService (copy)
    _playStartupSounds(u48);
    local skillRunData = u48.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v49 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v49 then
        v49:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local v50 = skillRunData and skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v50 then
        v50:destroy();
        skillRunData.Logic.dangerTelegraph = nil;
    end;

    local v51 = _resolveImpactAnchor(u48);
    local v52, v53;

    if v51 then
        local v54 = SkillCommon.npcSummonBodySkillScale(u48) * 20;
        v52 = FXUtil.GetGroundAlignedCF(v51.groundCenter, v51.forward, "Ground", 4, 0.1) or CFrame.new(v51.groundCenter + Vector3.new(0, 0.1, 0));
        v53 = Vector3.new(v54, v54, v54);
    else
        v52 = nil;
        v53 = nil;
    end;

    if v52 and v53 then
        local Logic = skillRunData.Logic;
        local new = SkillTelegraph.new;
        local v55 = {
            shape = "Circle",
            warnDuration = 1.03,
            worldCFrame = v52,
            hitboxSize = v53
        };
        v55.casterCharacter = u48.skillInputData and u48.skillInputData.character;
        v55.characterType = u48.characterType;
        Logic.dangerTelegraph = new(v55);
        local runGeneration = u48.runGeneration;
        local v56 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

        if v56 then
            v56:Disconnect();
            skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
        end;

        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 266
            -- upvalues: SkillCommon (ref), u48 (copy), runGeneration (copy), skillRunData (copy), AIM_RUN_EVENT_KEY (ref), _resolveImpactAnchor (ref), FXUtil (ref)
            if not SkillCommon.isRunningSameGeneration(u48, runGeneration) then
                local v57 = skillRunData;

                if v57 then
                    if not v57.runEvent then
                        return;
                    end;

                    local v58 = v57.runEvent[AIM_RUN_EVENT_KEY];

                    if v58 then
                        v58:Disconnect();
                        v57.runEvent[AIM_RUN_EVENT_KEY] = nil;
                    end;
                end;

                return;
            end;

            local v59 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

            if not v59 then
                return;
            end;

            local v60 = u48;
            local v61 = _resolveImpactAnchor(v60);
            local v62, v63;

            if v61 then
                local v64 = SkillCommon.npcSummonBodySkillScale(v60) * 20;
                v62 = FXUtil.GetGroundAlignedCF(v61.groundCenter, v61.forward, "Ground", 4, 0.1) or CFrame.new(v61.groundCenter + Vector3.new(0, 0.1, 0));
                v63 = Vector3.new(v64, v64, v64);
            else
                v62 = nil;
                v63 = nil;
            end;

            if not (v62 and v63) then
                return;
            end;

            v59:update({
                worldCFrame = v62,
                hitboxSize = v63
            });
        end);
    end;
end;

function v1.Client_ExitStartup(p65) -- Line: 371
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p65.skillRunData;

    if skillRunData then
        if not skillRunData.runEvent then
            return;
        end;

        local v66 = skillRunData.runEvent[AIM_RUN_EVENT_KEY];

        if v66 then
            v66:Disconnect();
            skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
        end;
    end;
end;

function v1.Server_EnterStartup(p67) -- Line: 375
    -- upvalues: SkillCommon (copy)
    local v68 = p67.hitbox[1];

    if not (v68 and v68.hitbox) then
        return;
    end;

    local v69 = SkillCommon.npcSummonBodySkillScale(p67) * 20;
    v68.hitbox.Size = Vector3.new(v69, v69, v69);
end;

function v1.Client_EnterSwing(p70) -- Line: 388
    -- upvalues: AIM_RUN_EVENT_KEY (copy), _resolveImpactAnchor (copy), SkillCommon (copy), FXUtil (copy), _playImpactFx (copy)
    local skillRunData = p70.skillRunData;
    local v71 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v71 then
        v71:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local v72 = _resolveImpactAnchor(p70);

    if not v72 then
        return;
    end;

    local v73 = _resolveImpactAnchor(p70);
    local v74, v75;

    if v73 then
        local v76 = SkillCommon.npcSummonBodySkillScale(p70) * 20;
        v74 = FXUtil.GetGroundAlignedCF(v73.groundCenter, v73.forward, "Ground", 4, 0.1) or CFrame.new(v73.groundCenter + Vector3.new(0, 0.1, 0));
        v75 = Vector3.new(v76, v76, v76);
    else
        v74 = nil;
        v75 = nil;
    end;

    local v77 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v77 and (v74 and v75) then
        v77:update({
            lockPosition = true,
            worldCFrame = v74,
            hitboxSize = v75
        });
        v77:activate(0.2);
    end;

    _playImpactFx(p70, v72);
end;

function v1.Server_EnterSwing(p78) -- Line: 411
    -- upvalues: _resolveImpactAnchor (copy), _pulseImpactHitbox (copy)
    local v79 = _resolveImpactAnchor(p78);

    if not v79 then
        return;
    end;

    _pulseImpactHitbox(p78, v79);
end;

function v1.Server_ExitSwing(p80) -- Line: 419
    local v81 = p80.hitbox[1];

    if v81 and v81.isActive then
        v81:stop();
    end;
end;

function v1.Client_EnterRecovery(p82) -- Line: 429
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p82.skillRunData;
    local v83 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v83 then
        v83:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    if skillRunData then
        if not skillRunData.Logic then
            return;
        end;

        local dangerTelegraph = skillRunData.Logic.dangerTelegraph;

        if dangerTelegraph then
            dangerTelegraph:destroy();
            skillRunData.Logic.dangerTelegraph = nil;
        end;
    end;
end;

function v1.Client_EnterInterrupted(p84) -- Line: 433
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p84.skillRunData;
    local v85 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v85 then
        v85:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    if skillRunData then
        if not skillRunData.Logic then
            return;
        end;

        local dangerTelegraph = skillRunData.Logic.dangerTelegraph;

        if dangerTelegraph then
            dangerTelegraph:destroy();
            skillRunData.Logic.dangerTelegraph = nil;
        end;
    end;
end;

function v1.Server_EnterRecovery(p86) -- Line: 437
    p86:releaseControl();
end;

function v1.onEnd(p87) -- Line: 441
    -- upvalues: SkillCommon (copy)
    local skillRunData = p87.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p87, p87.runGeneration, skillRunData, "spiderSmashSpawns");
    end;
end;

v1.SoundList = { "音效-技能-boss下砸-攻击", "音效-技能-boss下砸-前转身", "音效-技能-boss下砸-后转身" };
v1.AnimateList = { "蜘蛛坠击" };
v1.ResNameList = { "蜘蛛坠击爆炸特效", "蜘蛛坠击地面特效" };
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
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.1,
        animationName = "蜘蛛坠击",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v1;