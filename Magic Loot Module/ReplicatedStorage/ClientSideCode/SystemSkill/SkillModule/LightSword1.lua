-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local TweenService = game:GetService("TweenService");
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    skillElementType = ElementTp.Light,
    skillDistanceLimit = 64
};

local function skillStartDelay(p2) -- Line: 60
    return p2 / 1;
end;

v1.visualFadeoutTime = 2.53;
local u3 = { "光辉之剑剑落", "光辉之剑Cast尾迹" };

local function releaseMaterialModel(p4, p5) -- Line: 84
    if not (p4 and p4.material) then
        return nil;
    end;

    local v6 = p4.material[p5];

    if v6 then
        p4.material[p5] = nil;
    end;

    return v6;
end;

local function scheduleResourceDestroy(u7, u8, p9, u10, p11) -- Line: 95
    -- upvalues: SkillCommon (copy)
    if not (u10 and p9) then
        return;
    end;

    SkillCommon.appendRunSpawnList(p9, "LightSwordSpawned", u10);
    task.delay(p11 / 1, function() -- Line: 106
        -- upvalues: u7 (copy), u8 (copy), u10 (copy)
        if u7.runGeneration ~= u8 then
            return;
        end;

        if u10.Parent then
            u10:Destroy();
        end;
    end);
end;

local function pulseImpactHitbox(u12, p13) -- Line: 121
    local u14 = u12.hitbox[1];

    if not (u14 and u14.hitbox) then
        return;
    end;

    local runGeneration = u12.runGeneration;
    u14.hitbox:PivotTo(CFrame.new(p13));
    u14:start();
    task.delay(0.5, function() -- Line: 129
        -- upvalues: u12 (copy), runGeneration (copy), u14 (copy)
        if u12.runGeneration ~= runGeneration then
            return;
        end;

        if u14.isActive then
            u14:stop();
        end;
    end);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Casting";
v1.States = {
    Startup = {
        Duration = 0.37,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Casting = {
        Duration = 0.3,
        OnEnterClient = "Client_EnterCasting",
        OnEnterServer = "Server_EnterCasting",
        OnExitClient = "Client_ExitCasting",
        OnExitServer = "Server_ExitCasting"
    },
    Recovery = {
        Duration = 1.2,
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
        To = "Casting",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Casting",
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
        From = "Casting",
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
        From = "Casting",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function cleanupRunFx(p15) -- Line: 180
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p15.skillRunData, u3);
end;

local function lockSwordGroundAndAnchor(p16, p17) -- Line: 193
    -- upvalues: SkillCommon (copy)
    local skillRunData = p16.skillRunData;

    if not skillRunData.Logic then
        skillRunData.Logic = {};
    end;

    local lightSwordLockedGround = skillRunData.Logic.lightSwordLockedGround;

    if not lightSwordLockedGround then
        local v18 = SkillCommon.resolveStrikeWorldPos(p17);
        lightSwordLockedGround = SkillCommon.getGroundCF(CFrame.new(v18), 4, 0, "Ground").Position;
        skillRunData.Logic.lightSwordLockedGround = lightSwordLockedGround;
    end;

    return lightSwordLockedGround, lightSwordLockedGround.Y + 3, lightSwordLockedGround.X, lightSwordLockedGround.Z;
end;

function v1.Client_EnterStartup(u19) -- Line: 208
    -- upvalues: SkillCommon (copy), lockSwordGroundAndAnchor (copy), VisibleMgr (copy), FXUtil (copy), scheduleResourceDestroy (copy), RunService (copy), u3 (copy), TweenService (copy)
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

    if not v20:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    local runGeneration = u19.runGeneration;
    local skillRunData = u19.skillRunData;
    SkillCommon.refreshSkillAimSnapshot(u19);
    local u21 = SkillCommon.scaleBandFromData(u19, SkillCommon.bandScaleOptsFromSkillData(u19));
    local u22, u23, u24, u25 = lockSwordGroundAndAnchor(u19, skillInputData);
    local v26 = u22 + Vector3.new(0, 0.8, 0);

    local function still() -- Line: 226
        -- upvalues: u19 (copy), runGeneration (copy)
        local v27 = u19:isRunningFlow();

        if v27 then
            if u19.runGeneration == runGeneration then
                v27 = not u19:isTerminal();
            else
                v27 = false;
            end;
        end;

        return v27;
    end;

    local v28 = SkillCommon.resolveWandTipFromCharacter(v20);

    if v28 then
        SkillCommon.scheduleWandTipElementTrail(u19, v28, {
            trailMaterialKey = "光系尾迹",
            runEventKey = "光辉之剑Cast尾迹",
            enableAt = 0.15,
            disableAt = 0.5
        });
        task.delay(3.5, function() -- Line: 238
            -- upvalues: u19 (copy), runGeneration (copy), SkillCommon (ref), skillRunData (copy)
            if u19.runGeneration ~= runGeneration then
                return;
            end;

            SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "光系尾迹", "光辉之剑Cast尾迹");
            local v29 = skillRunData;
            local v30;

            if v29 and v29.material then
                v30 = v29.material["光系尾迹"];

                if v30 then
                    v29.material["光系尾迹"] = nil;
                end;
            else
                v30 = nil;
            end;

            if v30 and v30.Parent then
                v30:Destroy();
            end;
        end);
    end;

    task.delay(0.167, function() -- Line: 251
        -- upvalues: u19 (copy), runGeneration (copy), skillRunData (copy), u21 (copy), VisibleMgr (ref), SkillCommon (ref), u24 (copy), u23 (copy), u25 (copy), FXUtil (ref), scheduleResourceDestroy (ref)
        if u19.runGeneration ~= runGeneration then
            return;
        end;

        local v31 = skillRunData;
        local v32;

        if v31 and v31.material then
            v32 = v31.material["光辉之剑大剑出现法阵低"];

            if v32 then
                v31.material["光辉之剑大剑出现法阵低"] = nil;
            end;
        else
            v32 = nil;
        end;

        if not v32 then
            return;
        end;

        v32:ScaleTo(u21);
        VisibleMgr.UnQueryAll(v32);
        SkillCommon.pivotModelAtWorldPosKeepRotation(v32, (Vector3.new(u24, u23 + 95.2 * u21, u25)));
        v32.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v32, true);
        scheduleResourceDestroy(u19, runGeneration, skillRunData, v32, 3.167);
    end);
    local u33 = nil;
    local v34 = nil;
    local u35;

    if skillRunData and skillRunData.material then
        u35 = skillRunData.material["光辉之剑目标受击特效"];

        if u35 then
            skillRunData.material["光辉之剑目标受击特效"] = nil;
        end;
    else
        u35 = nil;
    end;

    if u35 then
        u35:ScaleTo(u21);
        VisibleMgr.UnQueryAll(u35);
        SkillCommon.pivotModelAtWorldPosKeepRotation(u35, v26);
        u35.Parent = workspace.Debris;
        FXUtil.SetEmittersTrailsBeamsEnabled(u35, false);
        scheduleResourceDestroy(u19, runGeneration, skillRunData, u35, 4);
    else
        u35 = v34;
    end;

    task.delay(0.25, function() -- Line: 282
        -- upvalues: u19 (copy), runGeneration (copy), skillRunData (copy), u21 (copy), VisibleMgr (ref), SkillCommon (ref), u24 (copy), u23 (copy), u25 (copy), FXUtil (ref), scheduleResourceDestroy (ref), u33 (ref), RunService (ref), u3 (ref), u22 (copy), TweenService (ref)
        if u19.runGeneration ~= runGeneration then
            return;
        end;

        local v36 = skillRunData;
        local v37;

        if v36 and v36.material then
            v37 = v36.material["光辉之剑大剑出现法阵高"];

            if v37 then
                v36.material["光辉之剑大剑出现法阵高"] = nil;
            end;
        else
            v37 = nil;
        end;

        if v37 then
            v37:ScaleTo(u21);
            VisibleMgr.UnQueryAll(v37);
            SkillCommon.pivotModelAtWorldPosKeepRotation(v37, (Vector3.new(u24, u23 + 117.6 * u21, u25)));
            v37.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v37, true);
            scheduleResourceDestroy(u19, runGeneration, skillRunData, v37, 3.25);
        end;

        local v38 = skillRunData;
        local u39;

        if v38 and v38.material then
            u39 = v38.material["光辉之剑大剑模型"];

            if u39 then
                v38.material["光辉之剑大剑模型"] = nil;
            end;
        else
            u39 = nil;
        end;

        if not u39 then
            return;
        end;

        u39:ScaleTo(u21);
        VisibleMgr.UnQueryAll(u39);
        local u40 = Vector3.new(u24, u23 + 129.6 * u21, u25);
        SkillCommon.pivotModelAtWorldPosKeepRotation(u39, u40);
        u39.Parent = workspace.Debris;
        SkillCommon.playSoundLocal3D("音效-技能-光辉之剑-剑下落", u39:GetPivot().Position);
        scheduleResourceDestroy(u19, runGeneration, skillRunData, u39, 4.25);
        u33 = u39;
        local u41 = 0;
        u19.skillRunData.runEvent["光辉之剑剑落"] = RunService.Heartbeat:Connect(function(p42) -- Line: 310
            -- upvalues: u19 (ref), runGeneration (ref), u39 (copy), SkillCommon (ref), u3 (ref), u41 (ref), u22 (ref), TweenService (ref), u40 (copy)
            local v43 = u19:isRunningFlow();

            if v43 then
                if u19.runGeneration == runGeneration then
                    v43 = not u19:isTerminal();
                else
                    v43 = false;
                end;
            end;

            if not (v43 and u39.Parent) then
                SkillCommon.disconnectRunEventKeys(u19.skillRunData, u3);

                return;
            end;

            u41 = u41 + p42;

            if u41 >= 0.25 then
                SkillCommon.pivotModelAtWorldPosKeepRotation(u39, u22);
                SkillCommon.disconnectRunEventKeys(u19.skillRunData, u3);

                return;
            end;

            local v44 = u40:Lerp(u22, (TweenService:GetValue(u41 / 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)));
            SkillCommon.pivotModelAtWorldPosKeepRotation(u39, v44);
        end);
    end);
    task.delay(0.4, function() -- Line: 329
        -- upvalues: u19 (copy), runGeneration (copy), FXUtil (ref), u35 (ref)
        if u19.runGeneration ~= runGeneration then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(u35, true);
        FXUtil.Emit_Particles_GetDescendants(u35, true);
    end);
    task.delay(1, function() -- Line: 337
        -- upvalues: u19 (copy), runGeneration (copy), FXUtil (ref), u35 (ref)
        if u19.runGeneration ~= runGeneration then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(u35, false);
    end);
    task.delay(1, function() -- Line: 344
        -- upvalues: u19 (copy), runGeneration (copy), u33 (ref), FXUtil (ref)
        if u19.runGeneration ~= runGeneration or not (u33 and u33.Parent) then
            return;
        end;

        FXUtil.Instance_Transparency_Tween(u33, 0.25, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    end);
    SkillCommon.scheduleRunSpawnClear(u19, runGeneration, skillRunData, "LightSwordSpawned", 4.25);
end;

function v1.Server_EnterStartup(u45) -- Line: 360
    -- upvalues: SkillCommon (copy), lockSwordGroundAndAnchor (copy), pulseImpactHitbox (copy)
    SkillCommon.refreshSkillAimSnapshot(u45);
    local u46 = lockSwordGroundAndAnchor(u45, u45.skillInputData);
    local v47 = SkillCommon.scaleBandFromData(u45, SkillCommon.bandScaleOptsFromSkillData(u45));
    local v48 = u45.hitbox[1];

    if v48 and v48.hitbox then
        v48.hitbox.Size = Vector3.new(70, 70, 70) * v47;
    end;

    task.delay(0.5, function() -- Line: 371
        -- upvalues: u45 (copy), pulseImpactHitbox (ref), u46 (copy)
        if not u45:isRunningFlow() then
            return;
        end;

        pulseImpactHitbox(u45, u46);
    end);
end;

function v1.Client_EnterCasting(p49) -- Line: 379
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), scheduleResourceDestroy (copy)
    local skillInputData = p49.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if not skillInputData then
        return;
    end;

    local HumanoidRootPart = skillInputData:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = p49.skillRunData;
    local runGeneration = p49.runGeneration;
    local v50 = SkillCommon.scaleBandFromData(p49, SkillCommon.bandScaleOptsFromSkillData(p49));
    local v51;

    if skillRunData and skillRunData.material then
        v51 = skillRunData.material["光辉之剑法阵"];

        if v51 then
            skillRunData.material["光辉之剑法阵"] = nil;
        end;
    else
        v51 = nil;
    end;

    if v51 then
        v51:ScaleTo(v50);
        VisibleMgr.UnQueryAll(v51);
        SkillCommon.pivotModelAtWorldPosKeepRotation(v51, SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart));
        v51.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v51, true);
        SkillCommon.playSoundLocal3D("音效-技能-光辉之剑-光法阵", v51:GetPivot().Position);
        scheduleResourceDestroy(p49, runGeneration, skillRunData, v51, 3.37);
    end;
end;

function v1.Client_ExitCasting(p52) -- Line: 405
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p52.skillRunData, u3);
    local skillRunData = p52.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p52, p52.runGeneration, skillRunData, "LightSwordSpawned");
    end;
end;

function v1.Client_EnterRecovery(p53) -- Line: 413
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.flushPhase1AndRelease(p53);
    SkillCommon.disconnectRunEventKeys(p53.skillRunData, u3);
end;

function v1.onEnd(p54) -- Line: 418
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p54.skillRunData, u3);
    local skillRunData = p54.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "光系尾迹", "光辉之剑Cast尾迹");
    local v55;

    if skillRunData and skillRunData.material then
        v55 = skillRunData.material["光系尾迹"];

        if v55 then
            skillRunData.material["光系尾迹"] = nil;
        end;
    else
        v55 = nil;
    end;

    if v55 and v55.Parent then
        v55:Destroy();
    end;

    if skillRunData.material then
        skillRunData.material["光辉之剑大剑模型"] = nil;
    end;
end;

function v1.Server_EnterCasting(p56) -- Line: 434
end;

function v1.Server_ExitCasting(p57) -- Line: 437
    local v58 = p57.hitbox[1];

    if v58 and v58.isActive then
        v58:stop();
    end;
end;

function v1.Server_EnterRecovery(p59) -- Line: 444
    -- upvalues: SkillCommon (copy)
    SkillCommon.flushPhase1AndRelease(p59);
end;

function v1.onEndServer(p60) -- Line: 448
    local v61 = p60.hitbox[1];

    if v61 and v61.isActive then
        v61:stop();
    end;
end;

v1.SoundList = { "音效-技能-光辉之剑-光法阵", "音效-技能-光辉之剑-剑下落" };
v1.AnimateList = { "技能释放动作5" };
v1.ResNameList = { "光系尾迹", "光辉之剑法阵", "光辉之剑大剑模型", "光辉之剑大剑出现法阵低", "光辉之剑大剑出现法阵高", "光辉之剑目标受击特效" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "光属性受击",
        PhysicsEffectName = "中等力度受击物理效果",
        CameraShakeProfile = "中等碰撞震"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.37,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1,
        animationName = "技能释放动作5",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;