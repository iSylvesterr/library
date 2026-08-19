-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local BurstStone = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64
};
local AIM_RUN_EVENT_KEY = SkillTelegraph.AIM_RUN_EVENT_KEY;
v1.InitialState = "Startup";
v1.ControlOpenState = "MeteorFalling";
v1.States = {
    Startup = {
        Duration = 0.73,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup",
        OnExitServer = nil
    },
    MeteorFalling = {
        Duration = 0.6,
        OnEnterClient = "Client_EnterMeteorFalling",
        OnEnterServer = "Server_EnterMeteorFalling",
        OnExitClient = "Client_ExitMeteorFalling",
        OnExitServer = "Server_ExitMeteorFalling"
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
        IsTerminal = true,
        OnEnterClient = "Client_EnterInterrupted"
    }
};
v1.Transitions = {
    {
        From = "Startup",
        To = "MeteorFalling",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "MeteorFalling",
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
        From = "MeteorFalling",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "MeteorFalling",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};
local u2 = {
    rayUp = 3,
    lift = 0.1,
    rayTag = "Ground"
};

local function getHitboxBurstSize(p3) -- Line: 104
    -- upvalues: SkillCommon (copy)
    return Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(p3, SkillCommon.bandScaleOptsFromSkillData(p3));
end;

local function stopTelegraphAimLoop(p4) -- Line: 114
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    if not (p4 and p4.runEvent) then
        return;
    end;

    local v5 = p4.runEvent[AIM_RUN_EVENT_KEY];

    if v5 then
        v5:Disconnect();
        p4.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;
end;

local function destroyDangerTelegraph(p6) -- Line: 130
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local v7 = p6 and p6.runEvent and p6.runEvent[AIM_RUN_EVENT_KEY];

    if v7 then
        v7:Disconnect();
        p6.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    if not (p6 and p6.Logic) then
        return;
    end;

    local dangerTelegraph = p6.Logic.dangerTelegraph;

    if dangerTelegraph then
        dangerTelegraph:destroy();
        p6.Logic.dangerTelegraph = nil;
    end;
end;

local function resolveLiveStrikeGroundPos(p8, p9) -- Line: 149
    -- upvalues: SkillCommon (copy)
    local skillInputData = p8.skillInputData;

    if not skillInputData then
        return p9.Logic and p9.Logic.lastTelegraphGroundPos;
    end;

    local v10 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 3, 0.1, "Ground");

    if v10 then
        p9.Logic = p9.Logic or {};
        p9.Logic.lastTelegraphGroundPos = v10;

        return v10;
    end;

    return p9.Logic and p9.Logic.lastTelegraphGroundPos;
end;

local function lockStrikeAtConfirm(p11) -- Line: 169
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.refreshSkillAimSnapshot(p11);

    return SkillCommon.commitLockedStrike(p11, "lavaBallLocked", u2);
end;

local function getEarlyLockedStrike(p12) -- Line: 180
    if p12 and p12.Logic then
        return p12.Logic.lavaBallLocked;
    end;

    return nil;
end;

local function startTelegraphAimLoop(u13, u14, u15) -- Line: 194
    -- upvalues: AIM_RUN_EVENT_KEY (copy), RunService (copy), SkillCommon (copy), resolveLiveStrikeGroundPos (copy)
    local v16 = u14 and u14.runEvent and u14.runEvent[AIM_RUN_EVENT_KEY];

    if v16 then
        v16:Disconnect();
        u14.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    u14.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 196
        -- upvalues: SkillCommon (ref), u13 (copy), u15 (copy), u14 (copy), AIM_RUN_EVENT_KEY (ref), resolveLiveStrikeGroundPos (ref)
        if not SkillCommon.isRunningSameGeneration(u13, u15) then
            local v17 = u14;

            if v17 then
                if not v17.runEvent then
                    return;
                end;

                local v18 = v17.runEvent[AIM_RUN_EVENT_KEY];

                if v18 then
                    v18:Disconnect();
                    v17.runEvent[AIM_RUN_EVENT_KEY] = nil;
                end;
            end;

            return;
        end;

        local v19 = u14.Logic and u14.Logic.dangerTelegraph;

        if not v19 then
            return;
        end;

        local v20 = resolveLiveStrikeGroundPos(u13, u14);

        if not v20 then
            return;
        end;

        local v21 = {
            worldCFrame = CFrame.new(v20)
        };
        local v22 = u13;
        v21.hitboxSize = Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(v22, SkillCommon.bandScaleOptsFromSkillData(v22));
        v19:update(v21);
    end);
end;

local function lockStrikeAndTelegraph(p23) -- Line: 221
    -- upvalues: AIM_RUN_EVENT_KEY (copy), SkillCommon (copy), u2 (copy)
    local skillRunData = p23.skillRunData;

    if not skillRunData then
        return;
    end;

    local v24 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v24 then
        v24:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    SkillCommon.refreshSkillAimSnapshot(p23);
    local v25 = SkillCommon.commitLockedStrike(p23, "lavaBallLocked", u2);

    if not v25 then
        return;
    end;

    local v26 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v26 then
        v26:setWarnDuration(1.13);
        v26:update({
            lockPosition = true,
            worldCFrame = CFrame.new(v25.groundCenter),
            hitboxSize = Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(p23, SkillCommon.bandScaleOptsFromSkillData(p23))
        });
    end;
end;

local function resolveMeteorLandPos(p27, p28) -- Line: 249
    -- upvalues: SkillCommon (copy), u2 (copy)
    local v29;

    if p28 and p28.Logic then
        v29 = p28.Logic.lavaBallLocked;
    else
        v29 = nil;
    end;

    if not v29 then
        SkillCommon.refreshSkillAimSnapshot(p27);
        v29 = SkillCommon.commitLockedStrike(p27, "lavaBallLocked", u2);
    end;

    if v29 then
        return v29.groundCenter;
    end;

    return nil;
end;

function v1.Client_EnterStartup(u30) -- Line: 258
    -- upvalues: SkillCommon (copy), AIM_RUN_EVENT_KEY (copy), resolveLiveStrikeGroundPos (copy), SkillTelegraph (copy), RunService (copy), lockStrikeAndTelegraph (copy), FXUtil (copy)
    local character = u30.skillInputData.character;

    if not character then
        return;
    end;

    local u31 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u31 then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u30.runGeneration;
    local u32 = nil;
    local u33 = nil;
    local skillRunData = u30.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v34 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v34 then
        v34:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local v35 = skillRunData and skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v35 then
        v35:destroy();
        skillRunData.Logic.dangerTelegraph = nil;
    end;

    local v36 = resolveLiveStrikeGroundPos(u30, skillRunData);

    if v36 then
        skillRunData.Logic.dangerTelegraph = SkillTelegraph.new({
            shape = "Circle",
            warnDuration = 1.13,
            worldCFrame = CFrame.new(v36),
            hitboxSize = Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(u30, SkillCommon.bandScaleOptsFromSkillData(u30)),
            casterCharacter = character,
            characterType = u30.characterType
        });
        local v37 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

        if v37 then
            v37:Disconnect();
            skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
        end;

        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 196
            -- upvalues: SkillCommon (ref), u30 (copy), runGeneration (copy), skillRunData (copy), AIM_RUN_EVENT_KEY (ref), resolveLiveStrikeGroundPos (ref)
            if not SkillCommon.isRunningSameGeneration(u30, runGeneration) then
                local v38 = skillRunData;

                if v38 then
                    if not v38.runEvent then
                        return;
                    end;

                    local v39 = v38.runEvent[AIM_RUN_EVENT_KEY];

                    if v39 then
                        v39:Disconnect();
                        v38.runEvent[AIM_RUN_EVENT_KEY] = nil;
                    end;
                end;

                return;
            end;

            local v40 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

            if not v40 then
                return;
            end;

            local v41 = resolveLiveStrikeGroundPos(u30, skillRunData);

            if not v41 then
                return;
            end;

            local v42 = {
                worldCFrame = CFrame.new(v41)
            };
            local v43 = u30;
            v42.hitboxSize = Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(v43, SkillCommon.bandScaleOptsFromSkillData(v43));
            v40:update(v42);
        end);
        task.delay(0.73, function() -- Line: 285
            -- upvalues: SkillCommon (ref), u30 (copy), runGeneration (copy), lockStrikeAndTelegraph (ref)
            if not SkillCommon.isRunningSameGeneration(u30, runGeneration) then
                return;
            end;

            lockStrikeAndTelegraph(u30);
        end);
    end;

    local function stillTrail() -- Line: 293
        -- upvalues: u30 (copy), runGeneration (copy)
        local v44 = u30:isRunningFlow() and u30.runGeneration == runGeneration;

        return v44;
    end;

    local function cleanupMeteorTrail() -- Line: 297
        -- upvalues: u32 (ref), u33 (ref), u30 (copy)
        if u32 then
            for _, descendant in pairs(u32:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        if u33 then
            u33:Disconnect();
            u33 = nil;
        end;

        u32 = nil;
        local skillRunData2 = u30.skillRunData;

        if skillRunData2 and (skillRunData2.runEvent and skillRunData2.runEvent["陨石术魔杖尾迹"]) then
            skillRunData2.runEvent["陨石术魔杖尾迹"] = nil;
        end;
    end;

    task.delay(0.3, function() -- Line: 317
        -- upvalues: u30 (copy), runGeneration (copy), u32 (ref), u33 (ref), RunService (ref), u31 (copy)
        local v45 = u30:isRunningFlow() and u30.runGeneration == runGeneration;

        if not v45 then
            return;
        end;

        local skillRunData2 = u30.skillRunData;

        if not (skillRunData2 and skillRunData2.material) then
            return;
        end;

        local v46 = skillRunData2.material["火系尾迹"];

        if not v46 then
            return;
        end;

        u32 = v46;

        for _, descendant in pairs(v46:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        v46.Parent = workspace.Debris;

        if not skillRunData2.runEvent then
            skillRunData2.runEvent = {};
        end;

        u33 = RunService.RenderStepped:Connect(function() -- Line: 339
            -- upvalues: u31 (ref), u32 (ref)
            if u31.Parent and u32 then
                u32:PivotTo(u31:GetPivot());
            end;
        end);
        skillRunData2.runEvent["陨石术魔杖尾迹"] = u33;
    end);
    task.delay(0.73, function() -- Line: 348
        -- upvalues: u30 (copy), skillRunData (copy), HumanoidRootPart (copy), SkillCommon (ref), FXUtil (ref)
        if not u30:isRunningFlow() then
            return;
        end;

        local v47 = skillRunData;
        local v48;

        if v47 and v47.Logic then
            v48 = v47.Logic.lavaBallLocked;
        else
            v48 = nil;
        end;

        local v49;

        if v48 then
            v49 = v48.groundCenter;
        else
            v49 = u30.skillInputData.targetCF.Position;
        end;

        local v50 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
        CFrame.lookAt(v50.Position, v49);
        local v51 = u30.skillRunData.material["陨石术法阵"];
        v51:ScaleTo(SkillCommon.scaleBandFromData(u30, SkillCommon.bandScaleOptsFromSkillData(u30)));
        v51:PivotTo(v50 * CFrame.Angles(1.5707963267948966, 0, 0));
        v51.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v51, true);
        SkillCommon.playSoundLocal3D("音效-技能-陨石术-法阵", v51:GetPivot().Position);
    end);
    task.delay(0.9, function() -- Line: 363
        -- upvalues: u30 (copy), runGeneration (copy), cleanupMeteorTrail (copy)
        if u30.runGeneration ~= runGeneration then
            return;
        end;

        cleanupMeteorTrail();
    end);
end;

function v1.Client_ExitStartup(p52) -- Line: 371
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p52.skillRunData;

    if skillRunData then
        if not skillRunData.runEvent then
            return;
        end;

        local v53 = skillRunData.runEvent[AIM_RUN_EVENT_KEY];

        if v53 then
            v53:Disconnect();
            skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
        end;
    end;
end;

function v1.Server_EnterStartup(u54) -- Line: 375
    -- upvalues: SkillCommon (copy), u2 (copy)
    local v55 = u54.hitbox[1];

    if v55 and v55.hitbox then
        v55.hitbox.Size = Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(u54, SkillCommon.bandScaleOptsFromSkillData(u54));
    end;

    local runGeneration = u54.runGeneration;
    task.delay(0.73, function() -- Line: 381
        -- upvalues: SkillCommon (ref), u54 (copy), runGeneration (copy), u2 (ref)
        if not SkillCommon.isRunningSameGeneration(u54, runGeneration) then
            return;
        end;

        local v56 = u54;
        SkillCommon.refreshSkillAimSnapshot(v56);
        SkillCommon.commitLockedStrike(v56, "lavaBallLocked", u2);
    end);
end;

function v1.Client_EnterMeteorFalling(p57) -- Line: 390
    -- upvalues: AIM_RUN_EVENT_KEY (copy), SkillCommon (copy), u2 (copy), FXUtil (copy), RunService (copy), BurstStone (copy)
    local character = p57.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = p57.skillRunData;
    local v58 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v58 then
        v58:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local v59;

    if skillRunData and skillRunData.Logic then
        v59 = skillRunData.Logic.lavaBallLocked;
    else
        v59 = nil;
    end;

    if not v59 then
        SkillCommon.refreshSkillAimSnapshot(p57);
        v59 = SkillCommon.commitLockedStrike(p57, "lavaBallLocked", u2);
    end;

    local v60;

    if v59 then
        v60 = v59.groundCenter;
    else
        v60 = nil;
    end;

    if not v60 then
        return;
    end;

    local u61 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if u61 then
        u61:update({
            lockPosition = true,
            worldCFrame = CFrame.new(v60),
            hitboxSize = Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(p57, SkillCommon.bandScaleOptsFromSkillData(p57))
        });
    end;

    local u62 = SkillCommon.scaleBandFromData(p57, SkillCommon.bandScaleOptsFromSkillData(p57));
    local v63 = HumanoidRootPart:GetPivot();
    local v64 = 60 * (1 - 2 * math.random());
    local v65 = v63:PointToWorldSpace((Vector3.new(v64, 60, 60)));
    local u66 = CFrame.lookAt(v65, v60);
    local u67 = u66.Rotation + v60;
    local u68 = skillRunData.material["熔岩球火球"];
    local u69 = skillRunData.material["熔岩球爆炸"];
    u68:ScaleTo(u62);
    u68:PivotTo(u66);
    u68.Parent = workspace.Debris;
    u69:ScaleTo(u62);
    u69:PivotTo(CFrame.new(u67.Position));
    u69.Parent = workspace.Debris;
    SkillCommon.playSoundLocal3D("音效-技能-陨石术-飞行爆炸", u68:GetPivot().Position);
    FXUtil.Start_All_Emit(u68, 10);

    for _, descendant in pairs(u68:GetDescendants()) do
        if descendant:IsA("Beam") then
            descendant.Enabled = true;
            FXUtil.Beam_Fade_From_Transparent(descendant, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;

        if descendant:IsA("MeshPart") then
            descendant.Transparency = 0;
        end;
    end;

    local u70 = 0;
    local u71 = false;
    skillRunData.runEvent["陨石坠落移动"] = RunService.Heartbeat:Connect(function(p72) -- Line: 441
        -- upvalues: u70 (ref), u66 (copy), u67 (copy), u68 (copy), u71 (ref), u61 (copy), FXUtil (ref), u69 (copy), BurstStone (ref), u62 (copy), skillRunData (copy)
        u70 = u70 + p72;
        local v73 = game.TweenService:GetValue(math.clamp(u70 / 0.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        u68:PivotTo((u66:Lerp(u67, v73)));

        if not u71 and u70 >= 0.4 then
            u71 = true;

            if u61 then
                u61:activate(0.2);
            end;
        end;

        if v73 >= 1 then
            FXUtil.Emit_Particles_GetDescendants(u69, true);
            BurstStone.CreateLandBreak(u67, "LavaBall", u62 * 0.5);
            BurstStone.CreateStoneFly(u67, "Meteor", u62 * 0.5);

            if skillRunData.runEvent["陨石坠落移动"] then
                skillRunData.runEvent["陨石坠落移动"]:Disconnect();
                skillRunData.runEvent["陨石坠落移动"] = nil;
            end;

            FXUtil.Stop_All_Emit(u68);

            for _, descendant in pairs(u68:GetDescendants()) do
                if descendant:IsA("Beam") then
                    FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                end;

                if descendant:IsA("MeshPart") then
                    descendant.Transparency = 1;
                end;
            end;
        end;
    end);
end;

function v1.Client_ExitMeteorFalling(p74) -- Line: 475
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    if p74.skillRunData.runEvent["陨石坠落移动"] then
        p74.skillRunData.runEvent["陨石坠落移动"]:Disconnect();
        p74.skillRunData.runEvent["陨石坠落移动"] = nil;
    end;

    local skillRunData = p74.skillRunData;
    local v75 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v75 then
        v75:Disconnect();
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

function v1.Server_EnterMeteorFalling(p76) -- Line: 483
    -- upvalues: SkillCommon (copy), u2 (copy), RunService (copy)
    local u77 = p76.hitbox[1];

    if not u77 then
        return;
    end;

    local skillRunData = p76.skillRunData;
    local v78;

    if skillRunData and skillRunData.Logic then
        v78 = skillRunData.Logic.lavaBallLocked;
    else
        v78 = nil;
    end;

    if not v78 then
        SkillCommon.refreshSkillAimSnapshot(p76);
        v78 = SkillCommon.commitLockedStrike(p76, "lavaBallLocked", u2);
    end;

    local v79;

    if v78 then
        v79 = v78.groundCenter;
    else
        v79 = nil;
    end;

    if not v79 then
        return;
    end;

    local hitbox = u77.hitbox;
    hitbox.Size = Vector3.new(24, 24, 24) * SkillCommon.scaleBandFromData(p76, SkillCommon.bandScaleOptsFromSkillData(p76));
    local v80 = (CFrame.new(v79) * CFrame.Angles(0, math.random() * 6.283185307179586, 0)):PointToWorldSpace(Vector3.new(0, 60, -60));
    hitbox:PivotTo(CFrame.lookAt(v80, v79).Rotation + v79);
    local u81 = 0;
    local u82 = false;
    skillRunData.runEvent["陨石命中检测坠落移动"] = RunService.Heartbeat:Connect(function(p83) -- Line: 502
        -- upvalues: u81 (ref), u82 (ref), u77 (copy), skillRunData (copy)
        u81 = u81 + p83;

        if u81 < 0.4 or u82 then
            if u81 >= 0.6 then
                if skillRunData.runEvent["陨石命中检测坠落移动"] then
                    skillRunData.runEvent["陨石命中检测坠落移动"]:Disconnect();
                    skillRunData.runEvent["陨石命中检测坠落移动"] = nil;
                end;

                u77:stop();
            end;

            return;
        end;

        u82 = true;
        u77:start();
    end);
end;

function v1.Server_ExitMeteorFalling(p84) -- Line: 519
    if p84.skillRunData.runEvent["陨石命中检测坠落移动"] then
        p84.skillRunData.runEvent["陨石命中检测坠落移动"]:Disconnect();
        p84.skillRunData.runEvent["陨石命中检测坠落移动"] = nil;
    end;

    local v85 = p84.hitbox[1];

    if v85 and v85.isActive then
        v85:stop();
    end;
end;

function v1.Server_EnterRecovery(p86) -- Line: 531
    p86:releaseControl();
end;

function v1.Client_EnterRecovery(p87) -- Line: 535
    local skillRunData = p87.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local v88 = skillRunData.material["火系尾迹"];

    if v88 then
        for _, descendant in pairs(v88:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local runEvent = skillRunData.runEvent;

    if runEvent and runEvent["陨石术魔杖尾迹"] then
        runEvent["陨石术魔杖尾迹"]:Disconnect();
        runEvent["陨石术魔杖尾迹"] = nil;
    end;
end;

function v1.Client_EnterInterrupted(p89) -- Line: 555
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p89.skillRunData;
    local v90 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v90 then
        v90:Disconnect();
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

v1.SoundList = { "音效-技能-陨石术-法阵", "音效-技能-陨石术-飞行爆炸" };
v1.AnimateList = { "技能释放动作4-慢" };
v1.ResNameList = { "熔岩球爆炸", "陨石术法阵", "熔岩球火球", "火系尾迹" };
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
        animationName = "技能释放动作4-慢",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;