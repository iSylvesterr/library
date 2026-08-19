-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth,
    InitialState = "Startup",
    ControlOpenState = "Recovery",
    States = {
        Startup = {
            Duration = 1.63,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = "Client_ExitStartup",
            OnExitServer = nil
        },
        ThrowRock = {
            Duration = -1,
            OnEnterClient = "Client_EnterThrowRock",
            OnEnterServer = "Server_EnterThrowRock",
            OnExitClient = "Client_ExitThrowRock",
            OnExitServer = "Server_ExitThrowRock"
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
    },
    Transitions = {
        {
            From = "Startup",
            To = "ThrowRock",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "ThrowRock",
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
            From = "ThrowRock",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "ThrowRock",
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

local function getRockPos(p2, p3) -- Line: 86
    if p2 and p3 then
        return (p2:GetPivot():PointToWorldSpace((Vector3.new(0, -p2.Size.Y / 4, 0))) + p3:GetPivot():PointToWorldSpace((Vector3.new(0, -p3.Size.Y / 4, 0)))) / 2;
    end;

    return nil;
end;

local function resolveThrowHands(p4) -- Line: 96
    local v5 = p4:FindFirstChild("Left Arm");
    local v6 = p4:FindFirstChild("Right Arm");

    if v5 and (v5:IsA("BasePart") and (v6 and v6:IsA("BasePart"))) then
        return v5, v6;
    end;

    return nil, nil;
end;

local function estimateRockFlightSec(p7, p8) -- Line: 112
    -- upvalues: getRockPos (copy)
    local v9 = p7:FindFirstChild("Left Arm");
    local v10 = p7:FindFirstChild("Right Arm");

    if not (v9 and (v9:IsA("BasePart") and (v10 and v10:IsA("BasePart")))) then
        v9 = nil;
        v10 = nil;
    end;

    local v11 = getRockPos(v9, v10);

    return not v11 and 0 or (p8 - (v11 + Vector3.new(0, 8, 0))).Magnitude / 160;
end;

local function applyTelegraphWarnDuration(p12, p13) -- Line: 128
    if p12 and p12.setWarnDuration then
        p12:setWarnDuration(p13 + 1.63);
    end;
end;

local function stopTelegraphAimLoop(p14) -- Line: 134
    if not (p14 and p14.runEvent) then
        return;
    end;

    local damageTelegraphAim = p14.runEvent.damageTelegraphAim;

    if damageTelegraphAim then
        damageTelegraphAim:Disconnect();
        p14.runEvent.damageTelegraphAim = nil;
    end;
end;

local function destroyDangerTelegraph(p15) -- Line: 145
    local v16 = p15 and p15.runEvent and p15.runEvent.damageTelegraphAim;

    if v16 then
        v16:Disconnect();
        p15.runEvent.damageTelegraphAim = nil;
    end;

    if not (p15 and p15.Logic) then
        return;
    end;

    local dangerTelegraph = p15.Logic.dangerTelegraph;

    if dangerTelegraph then
        dangerTelegraph:destroy();
        p15.Logic.dangerTelegraph = nil;
    end;
end;

local function resolveLiveStrikeGroundPos(p17, p18) -- Line: 157
    -- upvalues: SkillCommon (copy)
    local skillInputData = p17.skillInputData;

    if not skillInputData then
        return p18.Logic and p18.Logic.lastTelegraphGroundPos;
    end;

    local v19 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 0.3, "Ground");

    if v19 then
        p18.Logic = p18.Logic or {};
        p18.Logic.lastTelegraphGroundPos = v19;

        return v19;
    end;

    return p18.Logic and p18.Logic.lastTelegraphGroundPos;
end;

local function lockStrikeAtConfirm(p20) -- Line: 171
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p20);

    return SkillCommon.commitLockedStrike(p20, "throwHugeRockLocked", {
        rayUp = 4,
        lift = 0.3,
        rayTag = "Ground"
    });
end;

local function getEarlyLockedStrike(p21) -- Line: 186
    if p21 and p21.Logic then
        return p21.Logic.throwHugeRockLocked;
    end;

    return nil;
end;

local function earlyLockStrikeAndTelegraph(p22) -- Line: 198
    -- upvalues: SkillCommon (copy), getRockPos (copy)
    local skillRunData = p22.skillRunData;

    if not skillRunData then
        return;
    end;

    local v23 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v23 then
        v23:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    SkillCommon.refreshSkillAimSnapshot(p22);
    local v24 = SkillCommon.commitLockedStrike(p22, "throwHugeRockLocked", {
        rayUp = 4,
        lift = 0.3,
        rayTag = "Ground"
    });

    if not v24 then
        return;
    end;

    local v25 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v25 then
        local v26 = p22.skillInputData and p22.skillInputData.character;

        if v26 then
            local groundCenter = v24.groundCenter;
            local v27 = v26:FindFirstChild("Left Arm");
            local v28 = v26:FindFirstChild("Right Arm");

            if not (v27 and (v27:IsA("BasePart") and (v28 and v28:IsA("BasePart")))) then
                v27 = nil;
                v28 = nil;
            end;

            local v29 = getRockPos(v27, v28);
            local v30 = not v29 and 0 or (groundCenter - (v29 + Vector3.new(0, 8, 0))).Magnitude / 160;

            if v25 and v25.setWarnDuration then
                v25:setWarnDuration(v30 + 1.63);
            end;
        end;

        v25:update({
            hitboxSize = Vector3.new(35, 35, 35),
            lockPosition = true,
            worldCFrame = CFrame.new(v24.groundCenter)
        });
    end;
end;

local function earlyLockStrikeServer(p31) -- Line: 227
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p31);
    SkillCommon.commitLockedStrike(p31, "throwHugeRockLocked", {
        rayUp = 4,
        lift = 0.3,
        rayTag = "Ground"
    });
end;

local function startTelegraphAimLoop(u32, u33, u34) -- Line: 231
    -- upvalues: RunService (copy), SkillCommon (copy), resolveLiveStrikeGroundPos (copy)
    local v35 = u33 and u33.runEvent and u33.runEvent.damageTelegraphAim;

    if v35 then
        v35:Disconnect();
        u33.runEvent.damageTelegraphAim = nil;
    end;

    u33.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 233
        -- upvalues: SkillCommon (ref), u32 (copy), u34 (copy), u33 (copy), resolveLiveStrikeGroundPos (ref)
        if not SkillCommon.isRunningSameGeneration(u32, u34) then
            local v36 = u33;

            if v36 then
                if not v36.runEvent then
                    return;
                end;

                local damageTelegraphAim = v36.runEvent.damageTelegraphAim;

                if damageTelegraphAim then
                    damageTelegraphAim:Disconnect();
                    v36.runEvent.damageTelegraphAim = nil;
                end;
            end;

            return;
        end;

        local v37 = u33.Logic and u33.Logic.dangerTelegraph;

        if not v37 then
            return;
        end;

        local v38 = resolveLiveStrikeGroundPos(u32, u33);

        if not v38 then
            return;
        end;

        v37:update({
            hitboxSize = Vector3.new(35, 35, 35),
            worldCFrame = CFrame.new(v38)
        });
    end);
end;

function v1.Client_EnterStartup(u39) -- Line: 253
    -- upvalues: UtilsSystem (copy), resolveLiveStrikeGroundPos (copy), getRockPos (copy), SkillTelegraph (copy), RunService (copy), SkillCommon (copy), earlyLockStrikeAndTelegraph (copy), FXUtil (copy)
    local character = u39.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u40 = character:FindFirstChild("Left Arm");
    local u41 = character:FindFirstChild("Right Arm");

    if not (u40 and (u40:IsA("BasePart") and (u41 and u41:IsA("BasePart")))) then
        u40 = nil;
        u41 = nil;
    end;

    if not (u40 and u41) then
        return;
    end;

    local v42 = character:GetScale();
    local u43 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -3.5 * v42));
    local v44 = UtilsSystem.RayCast.RayCastDirection(u43.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v44 then
        u43 = u43.Rotation + v44.Position + Vector3.new(0, 0.3, 0);
    end;

    local skillRunData = u39.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v45 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v45 then
        v45:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    local v46 = skillRunData and skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v46 then
        v46:destroy();
        skillRunData.Logic.dangerTelegraph = nil;
    end;

    local v47 = resolveLiveStrikeGroundPos(u39, skillRunData);

    if v47 then
        local v48 = character:FindFirstChild("Left Arm");
        local v49 = character:FindFirstChild("Right Arm");

        if not (v48 and (v48:IsA("BasePart") and (v49 and v49:IsA("BasePart")))) then
            v48 = nil;
            v49 = nil;
        end;

        local v50 = getRockPos(v48, v49);
        local v51 = not v50 and 0 or (v47 - (v50 + Vector3.new(0, 8, 0))).Magnitude / 160;
        local Logic = skillRunData.Logic;
        local new = SkillTelegraph.new;
        local v52 = {
            shape = "Circle",
            hitboxSize = Vector3.new(35, 35, 35),
            worldCFrame = CFrame.new(v47),
            warnDuration = v51 + 1.63
        };
        v52.casterCharacter = u39.skillInputData and u39.skillInputData.character;
        v52.characterType = u39.characterType;
        Logic.dangerTelegraph = new(v52);
        local runGeneration = u39.runGeneration;
        local v53 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

        if v53 then
            v53:Disconnect();
            skillRunData.runEvent.damageTelegraphAim = nil;
        end;

        skillRunData.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 233
            -- upvalues: SkillCommon (ref), u39 (copy), runGeneration (copy), skillRunData (copy), resolveLiveStrikeGroundPos (ref)
            if not SkillCommon.isRunningSameGeneration(u39, runGeneration) then
                local v54 = skillRunData;

                if v54 then
                    if not v54.runEvent then
                        return;
                    end;

                    local damageTelegraphAim = v54.runEvent.damageTelegraphAim;

                    if damageTelegraphAim then
                        damageTelegraphAim:Disconnect();
                        v54.runEvent.damageTelegraphAim = nil;
                    end;
                end;

                return;
            end;

            local v55 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

            if not v55 then
                return;
            end;

            local v56 = resolveLiveStrikeGroundPos(u39, skillRunData);

            if not v56 then
                return;
            end;

            v55:update({
                hitboxSize = Vector3.new(35, 35, 35),
                worldCFrame = CFrame.new(v56)
            });
        end);
        local runGeneration2 = u39.runGeneration;
        task.delay(1.0299999999999998, function() -- Line: 291
            -- upvalues: SkillCommon (ref), u39 (copy), runGeneration2 (copy), earlyLockStrikeAndTelegraph (ref)
            if not SkillCommon.isRunningSameGeneration(u39, runGeneration2) then
                return;
            end;

            earlyLockStrikeAndTelegraph(u39);
        end);
    end;

    local u57 = skillRunData.material["投掷巨石巨石"];
    local v58 = getRockPos(u40, u41);

    if not v58 then
        return;
    end;

    u57:PivotTo(CFrame.new(v58 + Vector3.new(0, 8, 0)));
    FXUtil.Instance_Transparency_Tween(u57, 0.1, 0, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local u59 = skillRunData.material["投掷巨石烟雾"];
    local u60 = false;
    local u61 = 0;
    skillRunData.runEvent["控制举起巨石"] = RunService.Heartbeat:Connect(function(p62) -- Line: 310
        -- upvalues: u61 (ref), u60 (ref), u57 (copy), u59 (copy), u43 (ref), FXUtil (ref), getRockPos (ref), u40 (copy), u41 (copy)
        u61 = u61 + p62;

        if u61 >= 0.6 then
            if not u60 then
                u60 = true;
                u57.Parent = workspace.Debris;
                u59.Parent = workspace.Debris;
                u59:PivotTo(CFrame.new(u43.Position));
                FXUtil.Emit_Particles_GetDescendants(u59, true);
            end;

            local v63 = getRockPos(u40, u41);

            if v63 then
                u57:PivotTo(CFrame.new(v63 + Vector3.new(0, 8, 0)));
            end;
        end;
    end);
end;

function v1.Client_ExitStartup(p64) -- Line: 328
    if p64.skillRunData.runEvent["控制举起巨石"] then
        p64.skillRunData.runEvent["控制举起巨石"]:Disconnect();
        p64.skillRunData.runEvent["控制举起巨石"] = nil;
    end;

    local skillRunData = p64.skillRunData;

    if skillRunData then
        if not skillRunData.runEvent then
            return;
        end;

        local damageTelegraphAim = skillRunData.runEvent.damageTelegraphAim;

        if damageTelegraphAim then
            damageTelegraphAim:Disconnect();
            skillRunData.runEvent.damageTelegraphAim = nil;
        end;
    end;
end;

function v1.Server_EnterStartup(u65) -- Line: 336
    -- upvalues: SkillCommon (copy)
    local v66 = u65.hitbox[1];

    if v66 and v66.hitbox then
        v66.hitbox.Size = Vector3.new(35, 35, 35);
    end;

    local runGeneration = u65.runGeneration;
    task.delay(1.0299999999999998, function() -- Line: 342
        -- upvalues: SkillCommon (ref), u65 (copy), runGeneration (copy)
        if not SkillCommon.isRunningSameGeneration(u65, runGeneration) then
            return;
        end;

        local v67 = u65;
        SkillCommon.refreshSkillAimSnapshot(v67);
        SkillCommon.commitLockedStrike(v67, "throwHugeRockLocked", {
            rayUp = 4,
            lift = 0.3,
            rayTag = "Ground"
        });
    end);
end;

function v1.Client_EnterThrowRock(u68) -- Line: 350
    -- upvalues: SkillCommon (copy), getRockPos (copy), RunService (copy), UtilsSystem (copy), FXUtil (copy), SkillEventConst (copy)
    local character = u68.skillInputData.character;

    if not character then
        return;
    end;

    local v69 = character:FindFirstChild("Left Arm");
    local v70 = character:FindFirstChild("Right Arm");

    if not (v69 and (v69:IsA("BasePart") and (v70 and v70:IsA("BasePart")))) then
        v69 = nil;
        v70 = nil;
    end;

    if not (v69 and v70) then
        return;
    end;

    local skillRunData = u68.skillRunData;
    local v71 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v71 then
        v71:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    local skillRunData2 = u68.skillRunData;
    local v72;

    if skillRunData2 and skillRunData2.Logic then
        v72 = skillRunData2.Logic.throwHugeRockLocked;
    else
        v72 = nil;
    end;

    if not v72 then
        SkillCommon.refreshSkillAimSnapshot(u68);
        v72 = SkillCommon.commitLockedStrike(u68, "throwHugeRockLocked", {
            rayUp = 4,
            lift = 0.3,
            rayTag = "Ground"
        });
    end;

    if not v72 then
        return;
    end;

    local u73 = CFrame.new(v72.groundCenter);
    local u74 = skillRunData2.Logic and skillRunData2.Logic.dangerTelegraph;
    local u75 = skillRunData2.material["投掷巨石巨石"];
    local u76 = skillRunData2.material["投掷巨石爆炸"];
    local v77 = getRockPos(v69, v70);

    if not v77 then
        return;
    end;

    local u78 = CFrame.new(v77 + Vector3.new(0, 8, 0));
    u75:PivotTo(u78);
    u76.Parent = workspace.Debris;
    u76:PivotTo(u73);
    local u79 = (u73.Position - u78.Position).Magnitude / 160;

    if u74 and u74.setWarnDuration then
        u74:setWarnDuration(u79 + 1.63);
    end;

    local runGeneration = u68.runGeneration;
    local u80 = 0;
    skillRunData2.runEvent["控制巨石"] = RunService.Heartbeat:Connect(function(p81) -- Line: 387
        -- upvalues: SkillCommon (ref), u68 (copy), runGeneration (copy), skillRunData2 (copy), u80 (ref), UtilsSystem (ref), u79 (copy), u75 (copy), u78 (copy), u73 (copy), u74 (copy), FXUtil (ref), u76 (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u68, runGeneration) then
            SkillCommon.disconnectRunEventKeys(skillRunData2, { "控制巨石" });

            return;
        end;

        u80 = u80 + p81;
        local v82 = UtilsSystem.TweenService:GetValue(math.clamp(u80 / u79, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
        u75:PivotTo(u78:Lerp(u73, v82));

        if v82 >= 1 then
            if u74 then
                u74:activate(0.15);
            end;

            FXUtil.Emit_Particles_GetDescendants(u76, true);
            FXUtil.Instance_Transparency_Tween(u75, 0.1, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            SkillCommon.disconnectRunEventKeys(skillRunData2, { "控制巨石" });
            u68:TryTransition(SkillEventConst.StateTimeout, nil);
        end;
    end);
end;

function v1.Client_ExitThrowRock(p83) -- Line: 409
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p83.skillRunData, { "控制巨石" });
end;

function v1.Server_EnterThrowRock(u84) -- Line: 413
    -- upvalues: SkillCommon (copy), getRockPos (copy), RunService (copy), UtilsSystem (copy), SkillEventConst (copy)
    local u85 = u84.hitbox[1];

    if not u85 then
        return;
    end;

    local character = u84.skillInputData.character;

    if not character then
        return;
    end;

    local v86 = character:FindFirstChild("Left Arm");
    local v87 = character:FindFirstChild("Right Arm");

    if not (v86 and (v86:IsA("BasePart") and (v87 and v87:IsA("BasePart")))) then
        v86 = nil;
        v87 = nil;
    end;

    if not (v86 and v87) then
        return;
    end;

    local skillRunData = u84.skillRunData;
    local v88;

    if skillRunData and skillRunData.Logic then
        v88 = skillRunData.Logic.throwHugeRockLocked;
    else
        v88 = nil;
    end;

    if not v88 then
        SkillCommon.refreshSkillAimSnapshot(u84);
        v88 = SkillCommon.commitLockedStrike(u84, "throwHugeRockLocked", {
            rayUp = 4,
            lift = 0.3,
            rayTag = "Ground"
        });
    end;

    if not v88 then
        return;
    end;

    local groundCenter = v88.groundCenter;
    local v89 = getRockPos(v86, v87);

    if not v89 then
        return;
    end;

    local v90 = CFrame.new(v89 + Vector3.new(0, 8, 0));
    CFrame.new(groundCenter);
    local u91 = (groundCenter - v90.Position).Magnitude / 160;
    local skillRunData2 = u84.skillRunData;
    local runGeneration = u84.runGeneration;
    local u92 = 0;
    skillRunData2.runEvent.throwRockFlightTimer = RunService.Heartbeat:Connect(function(p93) -- Line: 445
        -- upvalues: SkillCommon (ref), u84 (copy), runGeneration (copy), skillRunData2 (copy), u92 (ref), UtilsSystem (ref), u91 (copy), u85 (copy), groundCenter (copy), SkillEventConst (ref)
        if not SkillCommon.isRunningSameGeneration(u84, runGeneration) then
            SkillCommon.disconnectRunEventKeys(skillRunData2, { "throwRockFlightTimer" });

            return;
        end;

        u92 = u92 + p93;

        if UtilsSystem.TweenService:GetValue(math.clamp(u92 / u91, 0, 1), Enum.EasingStyle.Linear, Enum.EasingDirection.Out) >= 1 then
            SkillCommon.pulseSphereHitboxAtPos(u85, groundCenter, Vector3.new(35, 35, 35), 0.15);
            SkillCommon.disconnectRunEventKeys(skillRunData2, { "throwRockFlightTimer" });
            u84:TryTransition(SkillEventConst.StateTimeout, nil);
        end;
    end);
end;

function v1.Server_ExitThrowRock(p94) -- Line: 461
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p94.skillRunData, { "throwRockFlightTimer" });
end;

function v1.Server_EnterRecovery(p95) -- Line: 466
    p95:releaseControl();
end;

function v1.Client_EnterRecovery(p96) -- Line: 470
end;

function v1.Client_EnterInterrupted(p97) -- Line: 473
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p97.skillRunData, { "控制巨石" });
    local skillRunData = p97.skillRunData;
    local v98 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v98 then
        v98:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
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

v1.SoundList = {};
v1.AnimateList = { "土元素投掷巨石" };
v1.ResNameList = { "投掷巨石巨石", "投掷巨石烟雾", "投掷巨石爆炸" };
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
        overTime = 1.8,
        animationName = "土元素投掷巨石",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;