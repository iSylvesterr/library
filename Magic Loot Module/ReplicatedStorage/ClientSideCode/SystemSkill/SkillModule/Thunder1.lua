-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 5.5,
    skillElementType = ElementTp.Thunder,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "Main",
    States = {
        Startup = {
            Duration = 1.28,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Main = {
            Duration = 4.167,
            OnEnterClient = "Client_EnterMain",
            OnEnterServer = "Server_EnterMain"
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
    },
    Transitions = {
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
    }
};

local function strikeFallDelayRel(p2) -- Line: 99
    return ((p2 - 1) * 15 + 5) / 60;
end;

local function strikeGroundDelayRel(p3) -- Line: 103
    return ((p3 - 1) * 15 + 10) / 60;
end;

local function emitThunderFallAttachment(p4, p5) -- Line: 108
    -- upvalues: FXUtil (copy)
    local v6 = p4:FindFirstChild("下落_电" .. p5);

    if v6 and v6:IsA("Attachment") then
        FXUtil.Emit_Particles_GetDescendants(v6, true);
    end;
end;

local function emitThunderGroundAttachment(p7, p8) -- Line: 116
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    local v9 = p7:FindFirstChild("下落_电" .. p8);
    local v10 = p7:FindFirstChild("地面" .. p8);

    if not (v10 and v10:IsA("Attachment")) then
        return nil;
    end;

    local v11 = v9 and (v9:IsA("Attachment") and v9.WorldPosition) or v10.WorldPosition;
    local Position = SkillCommon.getGroundCF(CFrame.new(v11), 4, 0.15, "Ground").Position;
    v10.WorldPosition = Position;
    FXUtil.Emit_Particles_GetDescendants(v10, true);

    return Position;
end;

local function commitStrike(p12) -- Line: 129
    -- upvalues: SkillCommon (copy)
    return SkillCommon.commitLockedStrike(p12, "thunderLocked", {
        rayUp = 4,
        lift = 0.5,
        rayTag = "Ground"
    });
end;

function v1.Client_EnterStartup(p13) -- Line: 137
    -- upvalues: SkillCommon (copy)
    local character = p13.skillInputData.character;

    if not character then
        return;
    end;

    local v14 = SkillCommon.resolveWandTipFromCharacter(character);

    if v14 then
        SkillCommon.scheduleWandTipElementTrail(p13, v14, {
            trailMaterialKey = "雷系尾迹",
            runEventKey = "ThunderCast尾迹",
            enableAt = 0.27,
            disableAt = 2.07
        });
    end;
end;

function v1.Server_EnterStartup(p15) -- Line: 153
end;

function v1.Client_EnterMain(u16) -- Line: 155
    -- upvalues: SkillCommon (copy), FXUtil (copy), emitThunderGroundAttachment (copy)
    SkillCommon.refreshSkillAimSnapshot(u16);
    local skillInputData = u16.skillInputData;
    local v17;

    if skillInputData then
        v17 = skillInputData.character;
    else
        v17 = skillInputData;
    end;

    if v17 then
        v17 = v17:FindFirstChild("HumanoidRootPart");
    end;

    local skillRunData = u16.skillRunData;

    if not (skillInputData and (v17 and (skillRunData and skillRunData.material))) then
        return;
    end;

    local runGeneration = u16.runGeneration;
    local v18 = SkillCommon.commitLockedStrike(u16, "thunderLocked", {
        rayUp = 4,
        lift = 0.5,
        rayTag = "Ground"
    });
    local v19 = skillRunData.material["乌云打雷法阵"];
    local u20 = skillRunData.material["乌云和打雷"];

    if not (v19 and (u20 and u20:IsA("Model"))) then
        return;
    end;

    local u21 = u20:FindFirstChild("Emit_雷电", true);
    local u22 = u20:FindFirstChild("云Emit和Enabled", true);

    if not (u21 and (u22 and (u21:IsA("BasePart") and u22:IsA("BasePart")))) then
        return;
    end;

    local function stillInMain() -- Line: 181
        -- upvalues: SkillCommon (ref), u16 (copy), runGeneration (copy)
        if SkillCommon.isRunningSameGeneration(u16, runGeneration) then
            return (not u16.GetCurrentState or u16:GetCurrentState() == "Main") and true or false;
        end;

        return false;
    end;

    local _, u23 = SkillCommon.scaleDualFromData(u16, SkillCommon.bandScaleOptsFromSkillData(u16));
    v19:ScaleTo(u23);
    local v24 = SkillCommon.casterFeetGroundWorldPos(v17, 4, 0.5, "Ground");
    SkillCommon.pivotModelAtWorldPosKeepRotation(v19, v24);
    v19.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v19, true);
    SkillCommon.playSoundLocal3D("音效-技能-雷系-法阵", v19:GetPivot().Position);
    local u25 = SkillCommon.worldPosPlusVerticalStuds(v18.groundCenter, 48, u23);
    task.delay(0.083, function() -- Line: 201
        -- upvalues: SkillCommon (ref), u16 (copy), runGeneration (copy), u20 (copy), u23 (copy), u25 (copy), FXUtil (ref), u22 (copy), u21 (copy)
        local v26;

        if SkillCommon.isRunningSameGeneration(u16, runGeneration) then
            v26 = (not u16.GetCurrentState or u16:GetCurrentState() == "Main") and true or false;
        else
            v26 = false;
        end;

        if not v26 then
            return;
        end;

        u20:ScaleTo(u23);
        SkillCommon.pivotModelAtWorldPosKeepRotation(u20, u25);
        u20.Parent = workspace.Debris;
        FXUtil.Start_All_Particles(u22);
        FXUtil.Emit_Particles_GetDescendants(u22, false);
        SkillCommon.playSoundLocal3D("音效-技能-雷4-乌云", u25);
        local v27 = u21:FindFirstChild("下落_电" .. 1);

        if v27 and v27:IsA("Attachment") then
            FXUtil.Emit_Particles_GetDescendants(v27, true);
        end;
    end);

    for i = 2, 9 do
        task.delay(((i - 1) * 15 + 5) / 60, function() -- Line: 215
            -- upvalues: SkillCommon (ref), u16 (copy), runGeneration (copy), u21 (copy), i (copy), FXUtil (ref)
            local v28;

            if SkillCommon.isRunningSameGeneration(u16, runGeneration) then
                v28 = (not u16.GetCurrentState or u16:GetCurrentState() == "Main") and true or false;
            else
                v28 = false;
            end;

            if v28 then
                local v29 = u21:FindFirstChild("下落_电" .. i);

                if v29 and v29:IsA("Attachment") then
                    FXUtil.Emit_Particles_GetDescendants(v29, true);
                end;
            end;
        end);
    end;

    for i = 1, 9 do
        task.delay(((i - 1) * 15 + 10) / 60, function() -- Line: 223
            -- upvalues: SkillCommon (ref), u16 (copy), runGeneration (copy), emitThunderGroundAttachment (ref), u21 (copy), i (copy)
            local v30;

            if SkillCommon.isRunningSameGeneration(u16, runGeneration) then
                v30 = (not u16.GetCurrentState or u16:GetCurrentState() == "Main") and true or false;
            else
                v30 = false;
            end;

            if not v30 then
                return;
            end;

            local v31 = emitThunderGroundAttachment(u21, i);

            if v31 then
                SkillCommon.playSoundLocal3D("音效-技能-雷4-打雷" .. i, v31);
            end;
        end);
    end;

    task.delay(2.167, function() -- Line: 234
        -- upvalues: SkillCommon (ref), u16 (copy), runGeneration (copy), FXUtil (ref), u22 (copy)
        if not SkillCommon.isRunningSameGeneration(u16, runGeneration) then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(u22, false);

        for _, descendant in u22:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end);
    task.delay(4.167, function() -- Line: 246
        -- upvalues: u20 (copy)
        if u20 and u20.Parent then
            u20:Destroy();
        end;
    end);
end;

function v1.Server_EnterMain(u32) -- Line: 253
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(u32);
    local skillInputData = u32.skillInputData;
    local v33;

    if skillInputData then
        v33 = skillInputData.character;
    else
        v33 = skillInputData;
    end;

    if not (skillInputData and (v33 and u32.skillRunData)) then
        return;
    end;

    local v34 = SkillCommon.commitLockedStrike(u32, "thunderLocked", {
        rayUp = 4,
        lift = 0.5,
        rayTag = "Ground"
    });
    local runGeneration = u32.runGeneration;
    local _, v35 = SkillCommon.scaleDualFromData(u32, SkillCommon.bandScaleOptsFromSkillData(u32));
    local v36 = Vector3.new(44 * v35, 22 * v35, 44 * v35);
    local u37 = CFrame.new(v34.hrpCenter);
    SkillCommon.setupBlockHitboxesAtCf(u32.hitbox, 9, u37, v36);
    task.delay(0.083, function() -- Line: 270
        -- upvalues: SkillCommon (ref), u32 (copy), runGeneration (copy), u37 (copy)
        if not SkillCommon.isRunningSameGeneration(u32, runGeneration) then
            return;
        end;

        for i = 1, 9 do
            task.delay(((i - 1) * 15 + 5) / 60, function() -- Line: 275
                -- upvalues: SkillCommon (ref), u32 (ref), runGeneration (ref), i (copy), u37 (ref)
                if not SkillCommon.isRunningSameGeneration(u32, runGeneration) then
                    return;
                end;

                local u38 = u32.hitbox[i];

                if not (u38 and u38.hitbox) then
                    return;
                end;

                u38.hitbox:PivotTo(u37);
                u38:start();
                task.delay(0.15, function() -- Line: 285
                    -- upvalues: u38 (copy)
                    if u38.isActive then
                        u38:stop();
                    end;
                end);
            end);
        end;
    end);
end;

function v1.Server_EnterRecovery(p39) -- Line: 295
    p39:releaseControl();
end;

function v1.Client_EnterRecovery(p40) -- Line: 299
    -- upvalues: SkillCommon (copy)
    local skillRunData = p40.skillRunData;

    if skillRunData and skillRunData.material then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "雷系尾迹", "ThunderCast尾迹");
    end;
end;

function v1.onEnd(p41) -- Line: 306
    -- upvalues: SkillCommon (copy)
    local skillRunData = p41.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "雷系尾迹", "ThunderCast尾迹");
    local v42 = skillRunData.material["乌云和打雷"];

    if v42 and v42.Parent then
        v42:Destroy();
    end;

    local v43 = skillRunData.material["乌云打雷法阵"];

    if v43 and v43.Parent then
        v43:Destroy();
    end;
end;

function v1.onEndServer(p44) -- Line: 322
    for i = 1, 9 do
        local v45 = p44.hitbox[i];

        if v45 and v45.isActive then
            v45:stop();
        end;
    end;
end;

v1.SoundList = { "音效-技能-雷系-法阵", "音效-技能-雷4-乌云", "音效-技能-雷4-打雷1", "音效-技能-雷4-打雷2", "音效-技能-雷4-打雷3", "音效-技能-雷4-打雷4", "音效-技能-雷4-打雷5", "音效-技能-雷4-打雷6", "音效-技能-雷4-打雷7", "音效-技能-雷4-打雷8", "音效-技能-雷4-打雷9" };
v1.AnimateList = { "技能释放动作5" };
v1.ResNameList = { "乌云打雷法阵", "乌云和打雷", "雷系尾迹" };
v1.hitboxConfig = {};

for i = 1, 9 do
    v1.hitboxConfig[i] = {
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果",
        HitboxIndex = i
    };
end;

v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 1.28,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.07,
        animationName = "技能释放动作5",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;