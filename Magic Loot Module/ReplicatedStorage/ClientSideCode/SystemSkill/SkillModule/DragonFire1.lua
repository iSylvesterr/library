-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local RunService = UtilsSystem.RunService;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64
};
local u2 = CFrame.new(0, 1.4, -6.5);

local function strikePosAfterRefresh(p3) -- Line: 45
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p3);

    return p3:getTargetCF().Position;
end;

local function cleanupBreathRunEvents(p4) -- Line: 50
    local v5 = p4.skillRunData and p4.skillRunData.runEvent;

    if not v5 then
        return;
    end;

    if v5["龙息术喷火计时"] then
        v5["龙息术喷火计时"]:Disconnect();
        v5["龙息术喷火计时"] = nil;
    end;
end;

local function setBreathEmittersEnabled(p6, p7) -- Line: 61
    local v8 = p6:FindFirstChild("Enabled_喷火");

    if not (v8 and v8:IsA("BasePart")) then
        return;
    end;

    local Attachment = v8:FindFirstChild("Attachment");

    if not (Attachment and Attachment:IsA("Attachment")) then
        return;
    end;

    for _, child in Attachment:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Enabled = p7;
        end;
    end;
end;

u1.InitialState = "Startup";
u1.ControlOpenState = "BreathPhase";
u1.States = {
    Startup = {
        Duration = 0.47,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    BreathPhase = {
        Duration = 0.53,
        OnEnterClient = "Client_EnterBreathPhase",
        OnEnterServer = "Server_EnterBreathPhase",
        OnExitClient = "Client_ExitBreathPhase",
        OnExitServer = "Server_ExitBreathPhase"
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
u1.Transitions = {
    {
        From = "Startup",
        To = "BreathPhase",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "BreathPhase",
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
        From = "BreathPhase",
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
        From = "BreathPhase",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function u1.Client_EnterStartup(p9) -- Line: 118
    -- upvalues: SkillCommon (copy)
    local character = p9.skillInputData.character;

    if not character then
        return;
    end;

    local v10 = SkillCommon.resolveWandTipFromCharacter(character);

    if v10 then
        SkillCommon.scheduleWandTipElementTrail(p9, v10, {
            trailMaterialKey = "火系尾迹",
            runEventKey = "龙息术Cast尾迹",
            enableAt = 0.27,
            disableAt = 0.47
        });
    end;
end;

function u1.Server_EnterStartup(p11) -- Line: 134
    -- upvalues: SkillCommon (copy)
    local v12 = SkillCommon.scaleBandFromData(p11, SkillCommon.bandScaleOptsFromSkillData(p11));
    local v13 = p11.hitbox[1];

    if v13 and v13.hitbox then
        v13.hitbox.Size = Vector3.new(1.5, 2.258, 1.5) * v12;
    end;

    local v14 = p11.hitbox[2];

    if v14 and v14.hitbox then
        local v15 = 40 * v12;
        v14.hitbox.Size = Vector3.new(v15, v15, v15);
    end;
end;

function u1.Client_EnterBreathPhase(u16) -- Line: 149
    -- upvalues: SkillCommon (copy), u2 (copy), VisibleMgr (copy), FXUtil (copy), setBreathEmittersEnabled (copy), u1 (copy)
    local character = u16.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = u16.skillRunData;
    local skillInputData = u16.skillInputData;
    local runGeneration = u16.runGeneration;
    local v17 = SkillCommon.scaleBandFromData(u16, SkillCommon.bandScaleOptsFromSkillData(u16));
    SkillCommon.refreshSkillAimSnapshot(u16);
    local Position = u16:getTargetCF().Position;
    local v18 = SkillCommon.resolveCasterWorldPosForRange(skillInputData);
    local v19;

    if v18 == nil then
        v19 = false;
    else
        v19 = SkillCommon.isWithinHorizReleaseRange(v18, Position, 64, v17);
    end;

    local v20 = SkillCommon.formationCFHorizontal(HumanoidRootPart, Position, u2);
    local v21 = SkillCommon.horizontalAimCF(HumanoidRootPart, Position, u2);

    local function still() -- Line: 170
        -- upvalues: u16 (copy), runGeneration (copy)
        local v22 = u16:isRunningFlow();

        if v22 then
            if u16.runGeneration == runGeneration then
                v22 = not u16:isTerminal();
            else
                v22 = false;
            end;
        end;

        return v22;
    end;

    local v23 = skillRunData.material["龙息术法阵"];

    if v23 then
        v23:ScaleTo(v17);
        VisibleMgr.UnQueryAll(v23);
        v23:PivotTo(v20);
        v23.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v23, true);
        SkillCommon.appendRunSpawnList(skillRunData, "DragonFireSpawned", v23);
        SkillCommon.playSoundLocal3D("音效-技能-火法阵", v23:GetPivot().Position);
    end;

    local u24 = skillRunData.material["龙息术喷火"];

    if u24 then
        u24:ScaleTo(v17);
        VisibleMgr.UnQueryAll(u24);
        u24:PivotTo(v21);
        u24.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "DragonFireSpawned", u24);
        setBreathEmittersEnabled(u24, true);
        SkillCommon.playSoundLocal3D("音效-技能-龙息术-喷火攻击", Position);
        task.delay(0.5, function() -- Line: 195
            -- upvalues: u24 (copy), setBreathEmittersEnabled (ref)
            if u24.Parent then
                setBreathEmittersEnabled(u24, false);
            end;
        end);
    end;

    local u25 = skillRunData.material["龙息术爆炸"];

    if v19 and u25 then
        u25:ScaleTo(v17);
        VisibleMgr.UnQueryAll(u25);
        u25:PivotTo(CFrame.new(Position));
        u25.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "DragonFireSpawned", u25);
        task.delay(0.33, function() -- Line: 211
            -- upvalues: u16 (copy), runGeneration (copy), u25 (copy), FXUtil (ref)
            local v26 = u16:isRunningFlow();

            if v26 then
                if u16.runGeneration == runGeneration then
                    v26 = not u16:isTerminal();
                else
                    v26 = false;
                end;
            end;

            if not v26 then
                return;
            end;

            local v27 = u25:FindFirstChild("Emit_大爆炸");

            if v27 then
                FXUtil.Emit_Particles_GetDescendants(v27, false);
            end;
        end);
        task.delay(0.5, function() -- Line: 222
            -- upvalues: u16 (copy), runGeneration (copy), u25 (copy), FXUtil (ref)
            local v28 = u16:isRunningFlow();

            if v28 then
                if u16.runGeneration == runGeneration then
                    v28 = not u16:isTerminal();
                else
                    v28 = false;
                end;
            end;

            if not v28 then
                return;
            end;

            for _, v in { "Emit_爆炸1", "Emit_爆炸2", "Emit_爆炸3" } do
                local v29 = u25:FindFirstChild(v);

                if v29 then
                    FXUtil.Emit_Particles_GetDescendants(v29, false);
                end;
            end;
        end);
    end;

    SkillCommon.scheduleRunSpawnClear(u16, runGeneration, skillRunData, "DragonFireSpawned", 0.5 + (u1.visualFadeoutTime or 2));
end;

function u1.Client_ExitBreathPhase(p30) -- Line: 239
    -- upvalues: setBreathEmittersEnabled (copy), SkillCommon (copy)
    local v31 = p30.skillRunData and p30.skillRunData.runEvent;

    if v31 and v31["龙息术喷火计时"] then
        v31["龙息术喷火计时"]:Disconnect();
        v31["龙息术喷火计时"] = nil;
    end;

    local skillRunData = p30.skillRunData;
    local v32;

    if skillRunData then
        v32 = skillRunData.DragonFireSpawned;
    else
        v32 = skillRunData;
    end;

    if v32 then
        for _, v in v32 do
            if v and (v:IsA("Model") and v:FindFirstChild("Enabled_喷火")) then
                setBreathEmittersEnabled(v, false);
            end;
        end;
    end;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p30, p30.runGeneration, skillRunData, "DragonFireSpawned");
    end;
end;

function u1.Server_EnterBreathPhase(u33) -- Line: 255
    -- upvalues: SkillCommon (copy), u2 (copy), RunService (copy)
    local skillInputData = u33.skillInputData;
    SkillCommon.refreshSkillAimSnapshot(u33);
    local Position = u33:getTargetCF().Position;
    local v34 = SkillCommon.scaleBandFromData(u33, SkillCommon.bandScaleOptsFromSkillData(u33));
    local v35 = SkillCommon.resolveCasterWorldPosForRange(skillInputData);
    local v36;

    if v35 == nil then
        v36 = false;
    else
        v36 = SkillCommon.isWithinHorizReleaseRange(v35, Position, 64, v34);
    end;

    if not v36 then
        return;
    end;

    local v37;

    if skillInputData then
        v37 = skillInputData.character;
    else
        v37 = skillInputData;
    end;

    if v37 then
        v37 = v37:FindFirstChild("HumanoidRootPart");
    end;

    local u38, u39;

    if v37 then
        u38 = SkillCommon.formationHorizontalAnchorPos(v37, Position, u2);
        u39 = SkillCommon.horizontalFlatFormationToStrike(v37, Position, u2);
    else
        if skillInputData and skillInputData.releaseCF then
            u38 = skillInputData.releaseCF.Position;
        else
            u38 = Position;
        end;

        local v40 = Vector3.new(Position.X - u38.X, 0, Position.Z - u38.Z);

        if v40.Magnitude < 0.05 then
            u39 = Vector3.new(0, 0, -1);
        else
            u39 = v40.Unit;
        end;
    end;

    local u41 = Vector3.new(1.5, 2.258, 1.5) * v34;
    local u42 = Vector3.new(16.5, 17.668, 30) * v34;
    local u43 = 40 * v34;
    local u44 = 50 * v34;
    local u45 = u33.hitbox[1];
    local u46 = u33.hitbox[2];
    local u47;

    if u45 then
        u47 = u45.hitbox;
    else
        u47 = u45;
    end;

    local u48;

    if u46 then
        u48 = u46.hitbox;
    else
        u48 = u46;
    end;

    local u49 = 0;
    local u50 = false;
    local u51 = false;
    local u52 = false;
    local u53 = false;
    u33.skillRunData.runEvent["龙息术喷火计时"] = RunService.Heartbeat:Connect(function(p54) -- Line: 302
        -- upvalues: u33 (copy), u53 (ref), u45 (copy), u46 (copy), u49 (ref), u47 (copy), u50 (ref), u41 (copy), u42 (copy), u38 (ref), u39 (ref), u51 (ref), u48 (copy), u52 (ref), u43 (copy), u44 (copy), Position (copy)
        if not u33:isRunningFlow() or u53 then
            if not u53 then
                local v55 = u33;
                local v56 = v55.skillRunData and v55.skillRunData.runEvent;

                if v56 and v56["龙息术喷火计时"] then
                    v56["龙息术喷火计时"]:Disconnect();
                    v56["龙息术喷火计时"] = nil;
                end;

                if u45 and u45.isActive then
                    u45:stop();
                end;

                if u46 and u46.isActive then
                    u46:stop();
                end;
            end;

            return;
        end;

        u49 = u49 + p54;

        if u49 < 0.33 then
            if u47 and (u45 and not u50) then
                u50 = true;
                u45:start();
            end;

            if u47 then
                local v57 = u41:Lerp(u42, u49 / 0.33);
                u47.Size = v57;
                local v58 = u38 + u39 * (v57.Z * 0.5);
                u47.CFrame = CFrame.lookAt(v58, v58 + u39);
            end;
        elseif not u51 then
            u51 = true;

            if u45 and u45.isActive then
                u45:stop();
            end;
        end;

        if u49 >= 0.33 and u49 < 0.5 then
            if u48 and (u46 and not u52) then
                u52 = true;
                u46:start();
            end;

            if u48 then
                local v59 = u43 + (u44 - u43) * math.clamp((u49 - 0.33) / 0.17, 0, 1);
                u48.Size = Vector3.new(v59, v59, v59);
                u48.CFrame = CFrame.new(Position);
            end;
        elseif u49 >= 0.5 then
            if u46 and u46.isActive then
                u46:stop();
            end;

            u53 = true;
            local v60 = u33;
            local v61 = v60.skillRunData and v60.skillRunData.runEvent;

            if not v61 then
                return;
            end;

            if v61["龙息术喷火计时"] then
                v61["龙息术喷火计时"]:Disconnect();
                v61["龙息术喷火计时"] = nil;
            end;
        end;
    end);
end;

function u1.Server_ExitBreathPhase(p62) -- Line: 361
    local v63 = p62.skillRunData and p62.skillRunData.runEvent;

    if v63 and v63["龙息术喷火计时"] then
        v63["龙息术喷火计时"]:Disconnect();
        v63["龙息术喷火计时"] = nil;
    end;

    local v64 = p62.hitbox[1];

    if v64 and v64.isActive then
        v64:stop();
    end;

    local v65 = p62.hitbox[2];

    if v65 and v65.isActive then
        v65:stop();
    end;
end;

function u1.Server_EnterRecovery(p66) -- Line: 373
    p66:releaseControl();
end;

function u1.Client_EnterRecovery(p67) -- Line: 377
    -- upvalues: SkillCommon (copy)
    local v68 = p67.skillRunData and p67.skillRunData.runEvent;

    if v68 and v68["龙息术喷火计时"] then
        v68["龙息术喷火计时"]:Disconnect();
        v68["龙息术喷火计时"] = nil;
    end;

    local skillRunData = p67.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "火系尾迹", "龙息术Cast尾迹");
    end;
end;

function u1.onEnd(p69) -- Line: 385
    -- upvalues: SkillCommon (copy)
    local v70 = p69.skillRunData and p69.skillRunData.runEvent;

    if v70 and v70["龙息术喷火计时"] then
        v70["龙息术喷火计时"]:Disconnect();
        v70["龙息术喷火计时"] = nil;
    end;

    local skillRunData = p69.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "火系尾迹", "龙息术Cast尾迹");
    end;
end;

function u1.onEndServer(p71) -- Line: 393
    local v72 = p71.skillRunData and p71.skillRunData.runEvent;

    if v72 and v72["龙息术喷火计时"] then
        v72["龙息术喷火计时"]:Disconnect();
        v72["龙息术喷火计时"] = nil;
    end;

    local v73 = p71.hitbox[1];

    if v73 and v73.isActive then
        v73:stop();
    end;

    local v74 = p71.hitbox[2];

    if v74 and v74.isActive then
        v74:stop();
    end;
end;

u1.SoundList = { "音效-技能-火法阵", "音效-技能-龙息术-喷火攻击" };
u1.AnimateList = { "技能释放动作3" };
u1.ResNameList = { "火系尾迹", "龙息术法阵", "龙息术爆炸", "龙息术喷火" };
u1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "火属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "火属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    } };
u1.Action = {
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

return u1;