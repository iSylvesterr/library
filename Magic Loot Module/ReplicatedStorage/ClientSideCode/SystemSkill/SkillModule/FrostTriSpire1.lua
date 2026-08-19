-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local Debris = game:GetService("Debris");
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local u1 = { "冰冻尖刺小", "冰冻尖刺中", "冰冻尖刺大" };

local function resolveTargetXZ(p2, p3) -- Line: 58
    -- upvalues: SkillCommon (copy)
    local v4 = SkillCommon.resolveTrackTargetHrp(p3);

    if v4 then
        local Position = v4.Position;

        return Vector3.new(Position.X, 0, Position.Z);
    end;

    SkillCommon.refreshSkillAimSnapshot(p2);
    local v5 = SkillCommon.resolveStrikeGroundWorldPos(p3, 4, 0.5, "Ground");

    return Vector3.new(v5.X, 0, v5.Z);
end;

local function commitFrostTriSpireLockedStrike(p6, p7) -- Line: 76
    -- upvalues: SkillCommon (copy), resolveTargetXZ (copy)
    local skillRunData = p6.skillRunData;

    if not skillRunData then
        return nil;
    end;

    if not skillRunData.Logic then
        skillRunData.Logic = {};
    end;

    local frostTriSpireLocked = skillRunData.Logic.frostTriSpireLocked;

    if frostTriSpireLocked then
        return frostTriSpireLocked;
    end;

    local skillInputData = p6.skillInputData;
    local v8;

    if skillInputData then
        v8 = skillInputData.character;
    else
        v8 = skillInputData;
    end;

    if v8 then
        v8 = v8:FindFirstChild("HumanoidRootPart");
    end;

    if not v8 then
        return nil;
    end;

    SkillCommon.refreshSkillAimSnapshot(p6);
    local v9 = p7 * 6;
    local Position = v8:GetPivot():ToWorldSpace(CFrame.new(0, 0, -(p7 * 6))).Position;
    local v10 = Vector3.new(Position.X, 0, Position.Z);
    local v11 = resolveTargetXZ(p6, skillInputData);
    local v12 = v11 - v10;
    local Magnitude = v12.Magnitude;

    if Magnitude >= 0.0001 and Magnitude >= v9 then
        v10 = v11 - v12.Unit * v9;
    end;

    local Position2 = SkillCommon.getGroundCF(CFrame.new(v10.X, v8.Position.Y, v10.Z), 4, 0.5, "Ground").Position;
    local v13 = v11 - v10;
    local v14;

    if v13.Magnitude >= 0.05 then
        v14 = v13.Unit;
    else
        local v15 = Vector3.new(v8.CFrame.LookVector.X, 0, v8.CFrame.LookVector.Z);
        v14 = v15.Magnitude < 0.05 and Vector3.new(0, 0, -1) or v15.Unit;
    end;

    local v16 = {
        groundCenter = Position2,
        forward = v14
    };
    skillRunData.Logic.frostTriSpireLocked = v16;

    return v16;
end;

local function aimRotFromForward(p17) -- Line: 146
    return CFrame.lookAt(Vector3.new(0, 0, 0), p17, Vector3.new(0, 1, 0)).Rotation;
end;

local function applySpikePillarOutlineDefaults(p18) -- Line: 150
    local v19 = p18:FindFirstChild("冰柱", true);
    local v20 = p18:FindFirstChild("描边", true);

    if v19 and v19:IsA("BasePart") then
        v19.Transparency = 0.15;
    end;

    if v20 and v20:IsA("BasePart") then
        v20.Transparency = 0;
    end;
end;

local function tweenSpikeAppearUp(p21, p22) -- Line: 161
    -- upvalues: FXUtil (copy)
    local v23 = p21:GetPivot();
    local v24 = CFrame.new(v23.Position + Vector3.new(0, p22, 0)) * v23.Rotation;
    FXUtil.Set_CFrame_Model_Tween(p21, 0.05, v24, Enum.EasingStyle.Linear, Enum.EasingDirection.In, true);
end;

local function sinkFadeSpikeModel(u25, p26) -- Line: 172
    -- upvalues: RunService (copy)
    local u27 = u25:FindFirstChild("冰柱", true);
    local u28 = u25:FindFirstChild("描边", true);

    if not (u27 and (u27:IsA("BasePart") and u27)) then
        u27 = nil;
    end;

    if not (u28 and (u28:IsA("BasePart") and u28)) then
        u28 = nil;
    end;

    local u29 = u25:GetPivot();
    local u30 = CFrame.new(u29.Position + Vector3.new(0, -p26, 0)) * u29.Rotation;
    local u31 = 0;
    local u32 = nil;
    u32 = RunService.Heartbeat:Connect(function(p33) -- Line: 183
        -- upvalues: u25 (copy), u32 (ref), u31 (ref), u29 (copy), u30 (copy), u27 (copy), u28 (copy)
        if not u25.Parent then
            if u32 then
                u32:Disconnect();
            end;

            return;
        end;

        u31 = u31 + p33;
        local v34 = math.clamp(u31 / 0.3, 0, 1);
        u25:PivotTo(u29:Lerp(u30, v34));
        local v35 = 1;
        local v36 = math.min(u31, 0.3);
        local v37;

        if v36 <= 0.15 then
            local v38 = math.clamp(v36 / 0.15, 0, 1);
            v35 = v38 * 0.85 + 0.15;
            v37 = v38 * 0.85 + 0;
        else
            v37 = math.clamp((v36 - 0.15) / 0.15, 0, 1) * 0.15000000000000002 + 0.85;
        end;

        if u27 then
            u27.Transparency = v35;
        end;

        if u28 then
            u28.Transparency = v37;
        end;

        if v34 >= 1 and u32 then
            u32:Disconnect();
        end;
    end);
end;

local function hitboxCfAfterSpikeRise(p39, p40, p41) -- Line: 222
    local v42 = p39 * CFrame.new(0, 0, p40);

    return CFrame.new(v42.Position + Vector3.new(0, p41, 0)) * v42.Rotation;
end;

return {
    skillTotalTime = -1,
    visualFadeoutTime = 3,
    skillElementType = ElementTp.Ice,
    InitialState = "Startup",
    ControlOpenState = "Main",
    States = {
        Startup = {
            Duration = 0.25,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Main = {
            Duration = 1.1,
            OnEnterClient = "Client_EnterMain",
            OnEnterServer = "Server_EnterMain",
            OnExitClient = "Client_ExitMain"
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
    },

    Client_EnterStartup = function(p43) -- Line: 269, Name: Client_EnterStartup
        -- upvalues: SkillCommon (copy)
        local v44 = p43.skillInputData and p43.skillInputData.character;

        if not v44 then
            return;
        end;

        local v45 = SkillCommon.resolveWandTipFromCharacter(v44);

        if v45 then
            SkillCommon.scheduleWandTipElementTrail(p43, v45, {
                trailMaterialKey = "冰系尾迹",
                runEventKey = "冰霜三棘Cast尾迹",
                enableAt = 0.1,
                disableAt = 0.6
            });
        end;
    end,

    Server_EnterStartup = function(p46) -- Line: 285, Name: Server_EnterStartup
        -- upvalues: SkillCommon (copy)
        local v47 = SkillCommon.scaleBandFromData(p46, SkillCommon.bandScaleOptsFromSkillData(p46));
        local v48 = Vector3.new(9.333 * v47, 14 * v47, 9.333 * v47);

        for i = 1, 3 do
            local v49 = p46.hitbox[i];

            if v49 and v49.hitbox then
                local hitbox = v49.hitbox;

                if hitbox:IsA("BasePart") then
                    hitbox.Shape = Enum.PartType.Block;
                end;

                hitbox.Size = v48;
            end;
        end;
    end,

    Client_EnterMain = function(u50) -- Line: 300, Name: Client_EnterMain
        -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), commitFrostTriSpireLockedStrike (copy), u1 (copy), applySpikePillarOutlineDefaults (copy), tweenSpikeAppearUp (copy), Debris (copy), sinkFadeSpikeModel (copy)
        local skillInputData = u50.skillInputData;

        if skillInputData then
            skillInputData = skillInputData.character;
        end;

        local skillRunData = u50.skillRunData;

        if not (skillInputData and (skillRunData and skillRunData.material)) then
            return;
        end;

        SkillCommon.flushPhase1AndRelease(u50);
        local runGeneration = u50.runGeneration;
        local HumanoidRootPart = skillInputData:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local u51 = SkillCommon.scaleBandFromData(u50, SkillCommon.bandScaleOptsFromSkillData(u50));
        local u52 = 14 * u51;
        local u53 = 16 * u51;
        local v54 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.35, "Ground");
        local u55 = skillRunData.material["冰霜三棘_法阵"];
        local u56 = skillRunData.material["冰霜三棘_冰刺以及爆炸"];

        if not (u55 and u56) then
            return;
        end;

        u55:ScaleTo(u51);
        VisibleMgr.UnQueryAll(u55);
        local Rotation = u55:GetPivot().Rotation;
        u55:PivotTo(CFrame.new(v54) * Rotation);
        u55.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "FrostTriSpireSpawned", u55);
        local v57 = u55:FindFirstChild("Emit_法阵", true);
        local v58 = nil;
        local v59 = nil;
        local v60, u61;

        if v57 and v57:IsA("BasePart") then
            v60 = v57:FindFirstChild("法阵");
            u61 = v57:FindFirstChild("爆");

            if v60 then
                if not v60:IsA("Attachment") then
                    v60 = v58;
                end;
            else
                v60 = v58;
            end;

            if not (u61 and u61:IsA("Attachment")) then
                u61 = v59;
            end;
        else
            u61 = v59;
            v60 = v58;
        end;

        if v60 then
            FXUtil.Emit_Particles_Children(v60, nil);
            SkillCommon.playSoundLocal3D("音效-技能-冰系法阵", u55:GetPivot().Position);
        end;

        task.delay(0.25, function() -- Line: 354
            -- upvalues: SkillCommon (ref), u50 (copy), runGeneration (copy), u55 (copy), u61 (ref), FXUtil (ref), commitFrostTriSpireLockedStrike (ref), u51 (copy), u56 (copy), VisibleMgr (ref), skillRunData (copy), u1 (ref), applySpikePillarOutlineDefaults (ref), tweenSpikeAppearUp (ref), u52 (copy), Debris (ref), sinkFadeSpikeModel (ref), u53 (copy)
            if not SkillCommon.isRunningSameGeneration(u50, runGeneration) then
                return;
            end;

            if u55.Parent and u61 then
                FXUtil.Emit_Particles_Children(u61, nil);
            end;

            local v62 = commitFrostTriSpireLockedStrike(u50, u51);

            if not v62 then
                return;
            end;

            local v63 = v62.groundCenter + Vector3.new(0, 0, 0);
            local Rotation2 = CFrame.lookAt(Vector3.new(0, 0, 0), v62.forward, Vector3.new(0, 1, 0)).Rotation;
            local u64 = u56;
            u64:ScaleTo(u51);
            VisibleMgr.UnQueryAll(u64);
            u64:PivotTo(CFrame.new(v63) * Rotation2);
            u64.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "FrostTriSpireSpawned", u64);
            SkillCommon.playSoundLocal3D("音效-技能-冰霜三棘-攻击", v63);
            local u65 = u64:FindFirstChild("冰霜三棘_爆炸", true);
            local v66 = u64:FindFirstChild("冰冻尖刺小", true);
            local u67 = u64:FindFirstChild("冰冻尖刺中", true);
            local u68 = u64:FindFirstChild("冰冻尖刺大", true);

            for _, v in ipairs(u1) do
                local v69 = u64:FindFirstChild(v, true);

                if v69 and v69:IsA("Model") then
                    applySpikePillarOutlineDefaults(v69);
                end;
            end;

            local u70 = u64:FindFirstChild("FX_冰柱循环Emit和Enabled", true);
            local u71;

            if u65 then
                u71 = u65:FindFirstChild("冰面", true);
            else
                u71 = u65;
            end;

            local function _(p72) -- Line: 392
                -- upvalues: u65 (copy), FXUtil (ref)
                local v73 = u65 and u65:FindFirstChild(p72, true);

                if v73 then
                    FXUtil.Emit_Particles_GetDescendants(v73, true);
                end;
            end;

            if v66 and v66:IsA("Model") then
                tweenSpikeAppearUp(v66, u52);
            end;

            task.delay(0.05, function() -- Line: 404
                -- upvalues: SkillCommon (ref), u50 (ref), runGeneration (ref), u67 (copy), tweenSpikeAppearUp (ref), u52 (ref), u71 (copy), FXUtil (ref), u70 (copy), Debris (ref)
                if not SkillCommon.isRunningSameGeneration(u50, runGeneration) then
                    return;
                end;

                if u67 and (u67:IsA("Model") and u67.Parent) then
                    tweenSpikeAppearUp(u67, u52);
                end;

                if u71 then
                    FXUtil.Emit_Particles_GetDescendants(u71, true);
                end;

                if u70 then
                    FXUtil.Emit_Particles_GetDescendants(u70, true);
                    FXUtil.SetEmittersTrailsBeamsEnabled(u70, true);
                    task.delay(0.4, function() -- Line: 419
                        -- upvalues: u70 (ref), FXUtil (ref), Debris (ref)
                        if not u70.Parent then
                            return;
                        end;

                        FXUtil.SetEmittersTrailsBeamsEnabled(u70, false);
                        task.delay(2, function() -- Line: 424
                            -- upvalues: u70 (ref), Debris (ref)
                            if u70 and u70.Parent then
                                Debris:AddItem(u70, 0);
                            end;
                        end);
                    end);
                end;
            end);
            task.delay(0.1, function() -- Line: 434
                -- upvalues: SkillCommon (ref), u50 (ref), runGeneration (ref), u68 (copy), tweenSpikeAppearUp (ref), u52 (ref)
                if not SkillCommon.isRunningSameGeneration(u50, runGeneration) then
                    return;
                end;

                if u68 and (u68:IsA("Model") and u68.Parent) then
                    tweenSpikeAppearUp(u68, u52);
                end;
            end);
            task.delay(0.9, function() -- Line: 444
                -- upvalues: u64 (copy), u1 (ref), sinkFadeSpikeModel (ref), u53 (ref)
                if not u64.Parent then
                    return;
                end;

                for _, v in ipairs(u1) do
                    local v74 = u64:FindFirstChild(v, true);

                    if v74 and (v74:IsA("Model") and v74.Parent) then
                        sinkFadeSpikeModel(v74, u53);
                    end;
                end;
            end);
            task.delay(0.033, function() -- Line: 457
                -- upvalues: SkillCommon (ref), u50 (ref), runGeneration (ref), u65 (copy), FXUtil (ref)
                if not SkillCommon.isRunningSameGeneration(u50, runGeneration) then
                    return;
                end;

                local v75 = u65 and u65:FindFirstChild("上升_小", true);

                if v75 then
                    FXUtil.Emit_Particles_GetDescendants(v75, true);
                end;

                local v76 = u65 and u65:FindFirstChild("爆_小", true);

                if v76 then
                    FXUtil.Emit_Particles_GetDescendants(v76, true);
                end;
            end);
            task.delay(0.083, function() -- Line: 466
                -- upvalues: SkillCommon (ref), u50 (ref), runGeneration (ref), u65 (copy), FXUtil (ref)
                if not SkillCommon.isRunningSameGeneration(u50, runGeneration) then
                    return;
                end;

                local v77 = u65 and u65:FindFirstChild("上升_中", true);

                if v77 then
                    FXUtil.Emit_Particles_GetDescendants(v77, true);
                end;

                local v78 = u65 and u65:FindFirstChild("爆_中", true);

                if v78 then
                    FXUtil.Emit_Particles_GetDescendants(v78, true);
                end;
            end);
            task.delay(0.133, function() -- Line: 475
                -- upvalues: SkillCommon (ref), u50 (ref), runGeneration (ref), u65 (copy), FXUtil (ref)
                if not SkillCommon.isRunningSameGeneration(u50, runGeneration) then
                    return;
                end;

                local v79 = u65 and u65:FindFirstChild("上升_大", true);

                if v79 then
                    FXUtil.Emit_Particles_GetDescendants(v79, true);
                end;

                local v80 = u65 and u65:FindFirstChild("爆_大", true);

                if v80 then
                    FXUtil.Emit_Particles_GetDescendants(v80, true);
                end;
            end);
        end);
        SkillCommon.scheduleRunSpawnClear(u50, runGeneration, skillRunData, "FrostTriSpireSpawned", 4.1);
    end,

    Server_EnterMain = function(u81) -- Line: 487, Name: Server_EnterMain
        -- upvalues: SkillCommon (copy), commitFrostTriSpireLockedStrike (copy)
        SkillCommon.flushPhase1AndRelease(u81);
        local u82 = u81.hitbox[1];
        local u83 = u81.hitbox[2];
        local u84 = u81.hitbox[3];

        if not (u82 and (u83 and u84)) then
            return;
        end;

        local u85 = SkillCommon.scaleBandFromData(u81, SkillCommon.bandScaleOptsFromSkillData(u81));
        local u86 = Vector3.new(9.333 * u85, 14 * u85, 9.333 * u85);
        local u87 = 6 * u85;
        local u88 = 9.333 * u85;
        local runGeneration = u81.runGeneration;

        local function armHitboxHoldThenStop(u89, p90) -- Line: 499
            -- upvalues: u81 (copy), runGeneration (copy)
            task.delay(p90, function() -- Line: 500
                -- upvalues: u81 (ref), runGeneration (ref), u89 (copy)
                if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
                    return;
                end;

                if u89.isActive then
                    u89:stop();
                    u89.hitbox.Transparency = 1;
                end;
            end);
        end;

        task.delay(0.25, function() -- Line: 512
            -- upvalues: u81 (copy), runGeneration (copy), commitFrostTriSpireLockedStrike (ref), u85 (copy), u87 (copy), u86 (copy), u82 (copy), u88 (copy), u83 (copy), u84 (copy)
            if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
                return;
            end;

            local v91 = commitFrostTriSpireLockedStrike(u81, u85);

            if not v91 then
                return;
            end;

            local u92 = CFrame.new(v91.groundCenter + Vector3.new(0, 0, 0)) * CFrame.lookAt(Vector3.new(0, 0, 0), v91.forward, Vector3.new(0, 1, 0)).Rotation;

            local function placeSpikeHitboxAtStrike(p93, p94) -- Line: 523
                -- upvalues: u92 (copy), u87 (ref), u86 (ref)
                local hitbox = p93.hitbox;
                local v95 = u92 * CFrame.new(0, 0, p94);
                hitbox:PivotTo(CFrame.new(v95.Position + Vector3.new(0, u87, 0)) * v95.Rotation);
                p93.hitbox.Size = u86;
                p93:start();
            end;

            local v96 = u82;
            local hitbox = v96.hitbox;
            local v97 = u92 * CFrame.new(0, 0, u88);
            hitbox:PivotTo(CFrame.new(v97.Position + Vector3.new(0, u87, 0)) * v97.Rotation);
            v96.hitbox.Size = u86;
            v96:start();
            local u98 = u82;
            task.delay(1.9, function() -- Line: 500
                -- upvalues: u81 (ref), runGeneration (ref), u98 (copy)
                if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
                    return;
                end;

                if u98.isActive then
                    u98:stop();
                    u98.hitbox.Transparency = 1;
                end;
            end);
            task.delay(0.05, function() -- Line: 533
                -- upvalues: u81 (ref), runGeneration (ref), u83 (ref), u92 (copy), u87 (ref), u86 (ref)
                if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
                    return;
                end;

                local v99 = u83;
                local hitbox2 = v99.hitbox;
                local v100 = u92 * CFrame.new(0, 0, 0);
                hitbox2:PivotTo(CFrame.new(v100.Position + Vector3.new(0, u87, 0)) * v100.Rotation);
                v99.hitbox.Size = u86;
                v99:start();
                local u101 = u83;
                task.delay(1.85, function() -- Line: 500
                    -- upvalues: u81 (ref), runGeneration (ref), u101 (copy)
                    if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
                        return;
                    end;

                    if u101.isActive then
                        u101:stop();
                        u101.hitbox.Transparency = 1;
                    end;
                end);
            end);
            task.delay(0.1, function() -- Line: 541
                -- upvalues: u81 (ref), runGeneration (ref), u84 (ref), u88 (ref), u92 (copy), u87 (ref), u86 (ref)
                if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
                    return;
                end;

                local v102 = u84;
                local hitbox2 = v102.hitbox;
                local v103 = u92 * CFrame.new(0, 0, -u88);
                hitbox2:PivotTo(CFrame.new(v103.Position + Vector3.new(0, u87, 0)) * v103.Rotation);
                v102.hitbox.Size = u86;
                v102:start();
                local u104 = u84;
                task.delay(1.8, function() -- Line: 500
                    -- upvalues: u81 (ref), runGeneration (ref), u104 (copy)
                    if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
                        return;
                    end;

                    if u104.isActive then
                        u104:stop();
                        u104.hitbox.Transparency = 1;
                    end;
                end);
            end);
        end);
    end,

    Client_ExitMain = function(p105) -- Line: 551, Name: Client_ExitMain
        -- upvalues: SkillCommon (copy)
        local skillRunData = p105.skillRunData;

        if skillRunData then
            SkillCommon.clearSpawnIfTerminalAfterExit(p105, p105.runGeneration, skillRunData, "FrostTriSpireSpawned");
        end;
    end,

    Server_EnterRecovery = function(p106) -- Line: 558, Name: Server_EnterRecovery
        -- upvalues: SkillCommon (copy)
        SkillCommon.flushPhase1AndRelease(p106);
    end,

    Client_EnterRecovery = function(p107) -- Line: 562, Name: Client_EnterRecovery
        -- upvalues: SkillCommon (copy)
        local skillRunData = p107.skillRunData;

        if skillRunData and skillRunData.material then
            SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "冰系尾迹", "冰霜三棘Cast尾迹");
        end;
    end,

    onEnd = function(p108) -- Line: 569, Name: onEnd
    end,

    onEndServer = function(p109) -- Line: 572, Name: onEndServer
        for i = 1, 3 do
            local v110 = p109.hitbox and p109.hitbox[i];

            if v110 and v110.isActive then
                v110:stop();
            end;
        end;
    end,

    SoundList = { "音效-技能-冰系法阵", "音效-技能-冰霜三棘-攻击" },
    AnimateList = { "技能释放动作10" },
    ResNameList = { "冰系尾迹", "冰霜三棘_法阵", "冰霜三棘_冰刺以及爆炸" },
    hitboxConfig = { {
            HitboxIndex = 1,
            PartName = "通用长方体",
            CollisionGroup = "Player",
            HitPresentationProfile = "冰属性受击",
            PhysicsEffectName = "通用受击物理效果",
            CameraShakeProfile = "轻攻击震"
        }, {
            HitboxIndex = 2,
            PartName = "通用长方体",
            CollisionGroup = "Player",
            HitPresentationProfile = "冰属性受击",
            PhysicsEffectName = "通用受击物理效果",
            CameraShakeProfile = "轻攻击震"
        }, {
            HitboxIndex = 3,
            PartName = "通用长方体",
            CollisionGroup = "Player",
            HitPresentationProfile = "冰属性受击",
            PhysicsEffectName = "通用受击物理效果",
            CameraShakeProfile = "轻攻击震"
        } },
    Action = {
        {
            action = "LookAt",
            startTime = 0,
            overTime = 0.25,
            speedType = "RELEASE_SKILL_STATE_HALF"
        },
        {
            action = "Animation",
            startTime = 0,
            overTime = 1.57,
            animationName = "技能释放动作10",
            animationSpeed = 1,
            animationFadeTime = 0.1,
            animationPriority = Enum.AnimationPriority.Action4
        }
    }
};