-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Water,
    skillDistanceLimit = 64
};
local u2 = { 0.5, 0.8, 1.1 };
local u3 = u2[3];
v1.InitialState = "Startup";
v1.ControlOpenState = "Casting";
v1.States = {
    Startup = {
        Duration = 0.45,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Casting = {
        Duration = 0.8,
        OnEnterClient = "Client_EnterCasting",
        OnEnterServer = "Server_EnterCasting",
        OnExitClient = nil,
        OnExitServer = "Server_ExitCasting"
    },
    Detonation = {
        Duration = 0.2,
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

local function resolveStrikeGroundPos(p4) -- Line: 98
    -- upvalues: SkillCommon (copy)
    return SkillCommon.resolveStruckTargetGroundWorldPos(p4, 4, 0.1, "Ground");
end;

local function resolveStrikeCF(p5, p6) -- Line: 108
    -- upvalues: SkillCommon (copy), resolveStrikeGroundPos (copy)
    SkillCommon.refreshSkillAimSnapshot(p5);

    return CFrame.new(resolveStrikeGroundPos(p6));
end;

local function resolveStrikeGroundFxCF(p7, p8) -- Line: 119
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    local v9 = SkillCommon.resolveStruckTargetGroundWorldPos(p8, 4, 0.1, "Ground");

    return FXUtil.GetGroundAlignedCF(v9, v9 - p7.Position, "Ground", 4, 0.1) or CFrame.new(v9);
end;

local function resolveFormationCF(p10, p11) -- Line: 141
    -- upvalues: SkillCommon (copy)
    local v12 = SkillCommon.resolveStruckTargetGroundWorldPos(p11, 4, 0.1, "Ground");
    local v13 = SkillCommon.casterFeetGroundWorldPos(p10, 4, 0.5, "Ground");
    local v14 = Vector3.new(v12.X - v13.X, 0, v12.Z - v13.Z);
    local v15;

    if v14.Magnitude < 0.05 then
        local LookVector = p10.CFrame.LookVector;
        local v16 = Vector3.new(LookVector.X, 0, LookVector.Z);
        v15 = v16.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v16.Unit;
    else
        v15 = v14.Unit;
    end;

    local v17 = v13 + v15 * 2 + Vector3.new(0, 0.1, 0);

    return CFrame.lookAt(v17, v17 + v15, Vector3.new(0, 1, 0)) * CFrame.Angles(1.5707963267948966, 0, 0);
end;

local function cleanupRockBoomHitWindow(p18) -- Line: 165
    local v19 = p18.skillRunData.runEvent["水渊爆炸命中窗"];

    if v19 then
        v19:Disconnect();
        p18.skillRunData.runEvent["水渊爆炸命中窗"] = nil;
    end;
end;

function v1.Client_EnterStartup(p20) -- Line: 174
    -- upvalues: SkillCommon (copy)
    local character = p20.skillInputData.character;

    if not character then
        return;
    end;

    local v21 = SkillCommon.resolveWandTipFromCharacter(character);

    if v21 then
        SkillCommon.scheduleWandTipElementTrail(p20, v21, {
            trailMaterialKey = "水系尾迹",
            runEventKey = "水渊Cast尾迹",
            enableAt = 0.3,
            disableAt = 0.9
        });
    end;
end;

function v1.Server_EnterStartup(p22) -- Line: 190
    local v23 = p22.hitbox[1];

    if v23 and v23.hitbox then
        v23.hitbox.Size = Vector3.new(55, 55, 55);
    end;
end;

function v1.Client_EnterCasting(u24) -- Line: 198
    -- upvalues: SkillCommon (copy), resolveFormationCF (copy), FXUtil (copy), resolveStrikeGroundFxCF (copy), u2 (copy), u3 (copy)
    local character = u24.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u24.runGeneration;
    local u25 = SkillCommon.scaleBandFromData(u24, SkillCommon.bandScaleOptsFromSkillData(u24));
    local skillInputData = u24.skillInputData;
    local v26 = u24.skillRunData.material["水渊法阵"];
    local u27 = u24.skillRunData.material["水渊循环"];
    local u28 = u24.skillRunData.material["水渊爆炸"];
    local u29 = false;

    local function stillFxValid() -- Line: 216
        -- upvalues: u24 (copy), runGeneration (copy)
        local v30 = u24:isRunningFlow() and u24.runGeneration == runGeneration;

        return v30;
    end;

    local v31 = u24:isRunningFlow() and u24.runGeneration == runGeneration;

    if v31 and v26 then
        SkillCommon.refreshSkillAimSnapshot(u24);
        v26:ScaleTo(u25);
        v26:PivotTo(resolveFormationCF(HumanoidRootPart, skillInputData) + Vector3.new(0, 3, 0));
        v26.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v26, true);
        SkillCommon.playSoundLocal3D("音效-技能-水法阵", v26:GetPivot().Position);
    end;

    local function playLastingWave() -- Line: 230
        -- upvalues: u24 (copy), runGeneration (copy), u27 (copy), SkillCommon (ref), u29 (ref), u25 (copy), resolveStrikeGroundFxCF (ref), HumanoidRootPart (copy), skillInputData (copy), FXUtil (ref)
        local v32 = u24:isRunningFlow() and u24.runGeneration == runGeneration;

        if not (v32 and u27) then
            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u24);

        if not u29 then
            u27:ScaleTo(u25);
            u29 = true;
        end;

        u27:PivotTo(resolveStrikeGroundFxCF(HumanoidRootPart, skillInputData));
        u27.Parent = workspace.Debris;

        for _, descendant in pairs(u27:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        FXUtil.Emit_Particles_GetDescendants(u27, false);
        SkillCommon.playSoundLocal3D("音效-技能-水渊术-水浪攻击", u27:GetPivot().Position);
    end;

    for _, v in ipairs(u2) do
        if v < u3 then
            task.delay(v, playLastingWave);
        end;
    end;

    task.delay(u3, function() -- Line: 256
        -- upvalues: u24 (copy), runGeneration (copy), u28 (copy), u27 (copy), SkillCommon (ref), u25 (copy), resolveStrikeGroundFxCF (ref), HumanoidRootPart (copy), skillInputData (copy), FXUtil (ref)
        local v33 = u24:isRunningFlow() and u24.runGeneration == runGeneration;

        if not (v33 and (u28 and u27)) then
            return;
        end;

        for _, descendant in pairs(u27:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;

        SkillCommon.refreshSkillAimSnapshot(u24);
        u28:ScaleTo(u25);
        u28:PivotTo(resolveStrikeGroundFxCF(HumanoidRootPart, skillInputData));
        u28.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(u28, true);
    end);
end;

function v1.Server_EnterCasting(u34) -- Line: 277
    -- upvalues: SkillCommon (copy), UtilsSystem (copy), u2 (copy), resolveStrikeCF (copy)
    local u35 = u34.hitbox[1];

    if not u35 then
        return;
    end;

    local hitbox = u35.hitbox;

    if not hitbox then
        return;
    end;

    local u36 = u34.hitbox[2];

    if not u36 then
        return;
    end;

    local hitbox2 = u36.hitbox;

    if not hitbox2 then
        return;
    end;

    local u37 = u34.hitbox[3];

    if not u37 then
        return;
    end;

    local hitbox3 = u37.hitbox;

    if not hitbox3 then
        return;
    end;

    local v38 = 55 * SkillCommon.scaleBandFromData(u34, SkillCommon.bandScaleOptsFromSkillData(u34));
    hitbox.Size = Vector3.new(v38, v38, v38);
    hitbox2.Size = Vector3.new(v38, v38, v38);
    hitbox3.Size = Vector3.new(v38, v38, v38);
    local skillInputData = u34.skillInputData;
    local u39 = 0;
    local u40 = false;
    local u41 = false;
    local u42 = false;
    local u43 = false;
    u34.skillRunData.runEvent["水渊爆炸命中窗"] = UtilsSystem.RunService.Heartbeat:Connect(function(p44) -- Line: 317
        -- upvalues: u39 (ref), u2 (ref), u40 (ref), hitbox (copy), resolveStrikeCF (ref), u34 (copy), skillInputData (copy), u35 (copy), u41 (ref), hitbox2 (copy), u36 (copy), u42 (ref), hitbox3 (copy), u37 (copy), u43 (ref)
        u39 = u39 + p44;

        if u39 >= u2[1] and not u40 then
            u40 = true;
            hitbox:PivotTo(resolveStrikeCF(u34, skillInputData));
            u35:start();
        end;

        if u39 >= u2[2] and not u41 then
            u41 = true;
            hitbox2:PivotTo(resolveStrikeCF(u34, skillInputData));
            u36:start();

            if u35 and u35.isActive then
                u35:stop();
            end;
        end;

        if u39 >= u2[3] and not u42 then
            u42 = true;
            hitbox3:PivotTo(resolveStrikeCF(u34, skillInputData));
            u37:start();

            if u36 and u36.isActive then
                u36:stop();
            end;
        end;

        if u39 >= 1.3 and not u43 then
            u43 = true;
            local v45 = u34;
            local v46 = v45.skillRunData.runEvent["水渊爆炸命中窗"];

            if v46 then
                v46:Disconnect();
                v45.skillRunData.runEvent["水渊爆炸命中窗"] = nil;
            end;

            if u37 and u37.isActive then
                u37:stop();
            end;
        end;
    end);
end;

function v1.Server_ExitCasting(p47) -- Line: 350
    local v48 = p47.skillRunData.runEvent["水渊爆炸命中窗"];

    if v48 then
        v48:Disconnect();
        p47.skillRunData.runEvent["水渊爆炸命中窗"] = nil;
    end;
end;

function v1.Client_EnterDetonation(p49) -- Line: 355
end;

function v1.Server_EnterDetonation(p50) -- Line: 357
end;

function v1.Server_ExitDetonation(p51) -- Line: 359
    local v52 = p51.skillRunData.runEvent["水渊爆炸命中窗"];

    if v52 then
        v52:Disconnect();
        p51.skillRunData.runEvent["水渊爆炸命中窗"] = nil;
    end;
end;

function v1.Server_EnterRecovery(p53) -- Line: 364
    p53:releaseControl();
end;

function v1.Client_EnterRecovery(p54) -- Line: 368
    -- upvalues: SkillCommon (copy)
    local skillRunData = p54.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "水渊Cast尾迹");
    end;
end;

v1.SoundList = { "音效-技能-水法阵", "音效-技能-水渊术-水浪攻击" };
v1.AnimateList = { "技能释放动作4" };
v1.ResNameList = { "水系尾迹", "水渊法阵", "水渊爆炸", "水渊循环" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "水属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "水属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    }, {
        HitboxIndex = 3,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "水属性受击",
        PhysicsEffectName = "中等力度受击物理效果",
        CameraShakeProfile = "中等碰撞震"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.45,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 0.45,
        animationName = "技能释放动作4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;