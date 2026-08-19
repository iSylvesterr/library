-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth,
    skillDistanceLimit = 55
};
local u2 = CFrame.new(0, 1.4, -6.5);
v1.InitialState = "Startup";
v1.ControlOpenState = "Detonation";
v1.States = {
    Startup = {
        Duration = 0.47,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Casting = {
        Duration = 1.27,
        OnEnterClient = "Client_EnterCasting",
        OnEnterServer = "Server_EnterCasting",
        OnExitClient = nil,
        OnExitServer = "Server_ExitCasting"
    },
    Detonation = {
        Duration = 0.48,
        OnEnterClient = "Client_EnterDetonation",
        OnEnterServer = "Server_EnterDetonation",
        OnExitClient = nil,
        OnExitServer = "Server_ExitDetonation"
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
        To = "Casting",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Casting",
        To = "Detonation",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Detonation",
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
        From = "Detonation",
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
        From = "Detonation",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function resolveBlastPosition(p3) -- Line: 85
    -- upvalues: RayCast (copy)
    local v4 = RayCast.RayCastDirection(p3.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 120, "Ground");

    if v4 then
        return v4.Position + Vector3.new(0, 0.06, 0);
    end;

    return p3.Position;
end;

local function cleanupRockBoomHitWindow(p5) -- Line: 94
    local v6 = p5.skillRunData.runEvent["岩石爆破命中窗"];

    if v6 then
        v6:Disconnect();
        p5.skillRunData.runEvent["岩石爆破命中窗"] = nil;
    end;

    local v7 = p5.hitbox[1];

    if v7 and v7.isActive then
        v7:stop();
    end;
end;

function v1.Client_EnterStartup(p8) -- Line: 107
    -- upvalues: SkillCommon (copy)
    local character = p8.skillInputData.character;

    if not character then
        return;
    end;

    local v9 = SkillCommon.resolveWandTipFromCharacter(character);

    if v9 then
        SkillCommon.scheduleWandTipElementTrail(p8, v9, {
            trailMaterialKey = "土系尾迹",
            runEventKey = "岩石爆破Cast尾迹",
            enableAt = 0.27,
            disableAt = 0.47
        });
    end;
end;

function v1.Server_EnterStartup(p10) -- Line: 123
    local v11 = p10.hitbox[1];

    if v11 and v11.hitbox then
        v11.hitbox.Size = Vector3.new(5, 5, 5);
    end;
end;

function v1.Client_EnterCasting(u12) -- Line: 131
    -- upvalues: SkillCommon (copy), u2 (copy), FXUtil (copy), RayCast (copy)
    local character = u12.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u12);
    local runGeneration = u12.runGeneration;
    local u13 = SkillCommon.scaleBandFromData(u12, SkillCommon.bandScaleOptsFromSkillData(u12));
    local skillInputData = u12.skillInputData;
    local v14 = u12.skillRunData.material["岩石爆破法阵"];
    local u15 = u12.skillRunData.material["岩石爆破爆炸"];

    local function stillFxValid() -- Line: 147
        -- upvalues: u12 (copy), runGeneration (copy)
        local v16 = u12:isRunningFlow() and u12.runGeneration == runGeneration;

        return v16;
    end;

    if v14 then
        v14:ScaleTo(u13);
        v14:PivotTo(SkillCommon.formationCF(HumanoidRootPart, SkillCommon.resolveTrackPos(skillInputData, skillInputData.targetCF.Position), u2));
        v14.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v14, true);
    end;

    task.delay(0.08, function() -- Line: 159
        -- upvalues: u12 (copy), runGeneration (copy), u15 (copy), u13 (copy), SkillCommon (ref), skillInputData (copy), RayCast (ref), FXUtil (ref)
        local v17 = u12:isRunningFlow() and u12.runGeneration == runGeneration;

        if not (v17 and u15) then
            return;
        end;

        u15:ScaleTo(u13);
        local new = CFrame.new;
        local resolveTrackPos = SkillCommon.resolveTrackPos;
        local targetCF = skillInputData.targetCF;
        local v18 = RayCast.RayCastDirection(targetCF.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 120, "Ground");
        local v19;

        if v18 then
            v19 = v18.Position + Vector3.new(0, 0.06, 0);
        else
            v19 = targetCF.Position;
        end;

        u15:PivotTo(new(resolveTrackPos(skillInputData, v19)));
        u15.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(u15, true);
        SkillCommon.playSoundLocal3D("音效-技能-岩石爆破", u15:GetPivot().Position);
    end);
end;

function v1.Server_EnterCasting(u20) -- Line: 171
    -- upvalues: SkillCommon (copy), UtilsSystem (copy), RayCast (copy)
    local u21 = u20.hitbox[1];

    if not u21 then
        return;
    end;

    local hitbox = u21.hitbox;

    if not hitbox then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u20);
    local v22 = 5 * SkillCommon.scaleBandFromData(u20, SkillCommon.bandScaleOptsFromSkillData(u20));
    hitbox.Size = Vector3.new(v22, v22, v22);
    local u23 = 0;
    u20.skillRunData.runEvent["岩石爆破命中窗"] = UtilsSystem.RunService.Heartbeat:Connect(function(p24) -- Line: 187
        -- upvalues: u23 (ref), u21 (copy), SkillCommon (ref), u20 (copy), RayCast (ref), hitbox (copy)
        u23 = u23 + p24;

        if u23 >= 0.08 and not u21.isActive then
            local resolveTrackPos = SkillCommon.resolveTrackPos;
            local skillInputData = u20.skillInputData;
            local targetCF = u20.skillInputData.targetCF;
            local v25 = RayCast.RayCastDirection(targetCF.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 120, "Ground");
            local v26;

            if v25 then
                v26 = v25.Position + Vector3.new(0, 0.06, 0);
            else
                v26 = targetCF.Position;
            end;

            local v27 = resolveTrackPos(skillInputData, v26);
            hitbox:PivotTo(CFrame.new(v27));
            u21:start();
        end;

        if u23 >= 0.22 then
            local v28 = u20;
            local v29 = v28.skillRunData.runEvent["岩石爆破命中窗"];

            if v29 then
                v29:Disconnect();
                v28.skillRunData.runEvent["岩石爆破命中窗"] = nil;
            end;

            local v30 = v28.hitbox[1];

            if v30 and v30.isActive then
                v30:stop();
            end;
        end;
    end);
end;

function v1.Server_ExitCasting(p31) -- Line: 200
    local v32 = p31.skillRunData.runEvent["岩石爆破命中窗"];

    if v32 then
        v32:Disconnect();
        p31.skillRunData.runEvent["岩石爆破命中窗"] = nil;
    end;

    local v33 = p31.hitbox[1];

    if v33 and v33.isActive then
        v33:stop();
    end;
end;

function v1.Client_EnterDetonation(p34) -- Line: 205
end;

function v1.Server_EnterDetonation(p35) -- Line: 207
end;

function v1.Server_ExitDetonation(p36) -- Line: 209
    local v37 = p36.skillRunData.runEvent["岩石爆破命中窗"];

    if v37 then
        v37:Disconnect();
        p36.skillRunData.runEvent["岩石爆破命中窗"] = nil;
    end;

    local v38 = p36.hitbox[1];

    if v38 and v38.isActive then
        v38:stop();
    end;
end;

function v1.Server_EnterRecovery(p39) -- Line: 214
    p39:releaseControl();
end;

function v1.Client_EnterRecovery(p40) -- Line: 218
    -- upvalues: SkillCommon (copy)
    local skillRunData = p40.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "土系尾迹", "岩石爆破Cast尾迹");
    end;
end;

v1.SoundList = { "音效-技能-岩石爆破" };
v1.AnimateList = { "技能释放动作3" };
v1.ResNameList = { "土系尾迹", "岩石爆破法阵", "岩石爆破爆炸" };
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
        overTime = 1.27,
        animationName = "技能释放动作3",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;