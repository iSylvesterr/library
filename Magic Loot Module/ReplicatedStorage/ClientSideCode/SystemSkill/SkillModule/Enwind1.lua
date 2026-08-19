-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local BurstStone = UtilsSystem.BurstStone;
local SkillCommon = require(script.Parent._Templates.SkillCommon);

return {
    skillTotalTime = -1,
    visualFadeoutTime = 3,
    skillElementType = ElementTp.Earth,
    InitialState = "Startup",
    ControlOpenState = "Main",
    States = {
        Startup = {
            Duration = 0.25,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Main = {
            Duration = 4.2,
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

    Client_EnterStartup = function(p1) -- Line: 90, Name: Client_EnterStartup
        -- upvalues: SkillCommon (copy)
        local v2 = p1.skillInputData and p1.skillInputData.character;

        if not v2 then
            return;
        end;

        local v3 = SkillCommon.resolveWandTipFromCharacter(v2);

        if v3 then
            SkillCommon.scheduleWandTipElementTrail(p1, v3, {
                trailMaterialKey = "地系尾迹2",
                runEventKey = "缠绕Cast尾迹",
                enableAt = 0.1,
                disableAt = 0.6
            });
        end;
    end,

    Server_EnterStartup = function(p4) -- Line: 108, Name: Server_EnterStartup
        -- upvalues: SkillCommon (copy)
        local v5 = p4.hitbox[1];

        if v5 and v5.hitbox then
            local v6 = 10 * SkillCommon.scaleBandFromData(p4, SkillCommon.bandScaleOptsFromSkillData(p4));
            local v7 = Vector3.new(v6, v6, v6);
            local hitbox = v5.hitbox;

            if hitbox:IsA("BasePart") then
                hitbox.Shape = Enum.PartType.Ball;
            end;

            hitbox.Size = v7;
        end;
    end,

    Client_EnterMain = function(u8) -- Line: 122, Name: Client_EnterMain
        -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), BurstStone (copy), RunService (copy)
        local skillInputData = u8.skillInputData;

        if skillInputData then
            skillInputData = skillInputData.character;
        end;

        local skillRunData = u8.skillRunData;

        if not (skillInputData and (skillRunData and skillRunData.material)) then
            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u8);
        local runGeneration = u8.runGeneration;
        local HumanoidRootPart = skillInputData:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local u9 = SkillCommon.scaleBandFromData(u8, SkillCommon.bandScaleOptsFromSkillData(u8));
        local u10 = 6.4 * u9;
        local v11 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.35, "Ground");
        local u12 = skillRunData.material["缠绕_法阵"];
        local u13 = skillRunData.material["缠绕_施法vfx"];
        local u14 = skillRunData.material["缠绕藤曼及特效"];

        if not (u12 and (u13 and u14)) then
            return;
        end;

        u12:ScaleTo(u9);
        VisibleMgr.UnQueryAll(u12);
        local Rotation = u12:GetPivot().Rotation;
        u12:PivotTo(CFrame.new(v11) * Rotation);
        u12.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "EnwindSpawned", u12);
        local v15 = u12:FindFirstChild("Emit_法阵", true);
        local v16 = nil;
        local v17;

        if v15 then
            v17 = v15:FindFirstChild("法阵", true);

            if v17 then
                if not v17:IsA("Attachment") then
                    v17 = v16;
                end;
            else
                v17 = v16;
            end;
        else
            v17 = v16;
        end;

        if v17 then
            FXUtil.Emit_Particles_Children(v17, nil);
            SkillCommon.playSoundLocal3D("音效-技能-木系法阵", u12:GetPivot().Position);
        end;

        task.delay(0.25, function() -- Line: 171
            -- upvalues: SkillCommon (ref), u8 (copy), runGeneration (copy), u12 (copy), u13 (copy), u9 (copy), VisibleMgr (ref), skillInputData (copy), skillRunData (copy), FXUtil (ref), u14 (copy), u10 (copy), BurstStone (ref), RunService (ref)
            if not SkillCommon.isRunningSameGeneration(u8, runGeneration) then
                return;
            end;

            if not u12.Parent then
                return;
            end;

            local v18 = u13;
            v18:ScaleTo(u9);
            VisibleMgr.UnQueryAll(v18);
            local v19 = SkillCommon.resolveWandTipFromCharacter(skillInputData);

            if v19 then
                v19 = SkillCommon.resolveWandTipWorldCFrame(v19);
            end;

            if v19 then
                v18:PivotTo(v19);
            else
                v18:PivotTo(u12:GetPivot());
            end;

            v18.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "EnwindSpawned", v18);
            local v20 = v18:FindFirstChild("Emit_施法vfx", true);
            local v21 = nil;
            local v22;

            if v20 and v20:IsA("BasePart") then
                v22 = v20:FindFirstChild("爆", true);

                if v22 then
                    if not v22:IsA("Attachment") then
                        v22 = v21;
                    end;
                else
                    v22 = v21;
                end;
            else
                v22 = v21;
            end;

            if v22 and v19 then
                v22.CFrame = CFrame.new();
                v22.WorldCFrame = v19;
                FXUtil.Emit_Particles_Children(v22, nil);
            end;

            task.delay(0.2, function() -- Line: 209
                -- upvalues: SkillCommon (ref), u8 (ref), runGeneration (ref), u14 (ref), u9 (ref), VisibleMgr (ref), skillRunData (ref), u10 (ref), FXUtil (ref), BurstStone (ref), RunService (ref)
                if not SkillCommon.isRunningSameGeneration(u8, runGeneration) then
                    return;
                end;

                local v23 = SkillCommon.commitLockedStrike(u8, "enwindLocked", {
                    rayUp = 4,
                    lift = 0.5,
                    rayTag = "Ground"
                });
                local u24 = v23.groundCenter + Vector3.new(0, -1.8, 0);
                local Rotation2 = CFrame.lookAt(Vector3.new(0, 0, 0), v23.forward, Vector3.new(0, 1, 0)).Rotation;
                local u25 = u14;
                u25:ScaleTo(u9);
                VisibleMgr.UnQueryAll(u25);
                SkillCommon.pivotInstanceToWorldCF(u25, CFrame.new(u24) * Rotation2);
                u25.Parent = workspace.Debris;
                SkillCommon.appendRunSpawnList(skillRunData, "EnwindSpawned", u25);
                local v26 = u25:FindFirstChild("藤曼");
                local v27;

                if v26 then
                    v27 = v26:FindFirstChild("藤曼");

                    if not (v27 and (v27:IsA("Model") or v27:IsA("BasePart"))) then
                        v27 = v26:FindFirstChildWhichIsA("BasePart", true);
                    end;
                else
                    v27 = nil;
                end;

                if v27 and (v27:IsA("Model") or v27:IsA("BasePart")) then
                    local v28;

                    if v27:IsA("Model") then
                        v28 = v27:GetPivot();
                    else
                        v28 = v27.CFrame;
                    end;

                    local v29 = CFrame.new(v28.Position + Vector3.new(0, u10, 0)) * v28.Rotation * CFrame.Angles(0, 3.141592653589793, 0);
                    u8:BindRunConn((FXUtil.Pivot_Instance_CF_Lerp_Heartbeat(v27, 0.25, v29, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 251
                        -- upvalues: SkillCommon (ref), u8 (ref), runGeneration (ref)
                        return SkillCommon.isRunningSameGeneration(u8, runGeneration);
                    end)));
                end;

                task.delay(0.033, function() -- Line: 259
                    -- upvalues: SkillCommon (ref), u8 (ref), runGeneration (ref), u25 (copy), FXUtil (ref), u24 (copy), u9 (ref), Rotation2 (copy), BurstStone (ref)
                    if not SkillCommon.isRunningSameGeneration(u8, runGeneration) then
                        return;
                    end;

                    local v30 = u25:FindFirstChild("Emit_藤蔓出现", true);

                    if v30 then
                        FXUtil.Emit_Particles_GetDescendants(v30, true);
                    end;

                    if v30 then
                        v30 = v30:FindFirstChild("地面_爆", true);
                    end;

                    local v31 = u24;

                    if v30 and v30:IsA("Attachment") then
                        v31 = v30.WorldPosition;
                    end;

                    SkillCommon.playSoundLocal3D("音效-技能-木2禁锢-攻击", v31);
                    local v32 = u9 * 0.2222222222222222;
                    local v33 = CFrame.new(v31) * Rotation2;
                    BurstStone.CreateLandBreak(v33, "MeteorEnwind", v32);
                    BurstStone.CreateStoneFly(v33, "Meteor", v32);
                end);
                task.delay(3.25, function() -- Line: 283
                    -- upvalues: SkillCommon (ref), u8 (ref), runGeneration (ref), u25 (copy), u10 (ref), RunService (ref)
                    if not SkillCommon.isRunningSameGeneration(u8, runGeneration) then
                        return;
                    end;

                    if not u25.Parent then
                        return;
                    end;

                    local u34 = {};
                    local u35 = {};

                    for _, descendant in u25:GetDescendants() do
                        if descendant:IsA("BasePart") then
                            table.insert(u34, descendant);
                            u35[descendant] = descendant.Transparency;
                        end;
                    end;

                    local v36 = u25;
                    local v37 = u25:FindFirstChild("藤曼");
                    local u38;

                    if v37 then
                        u38 = v37:FindFirstChild("藤曼");

                        if not (u38 and (u38:IsA("Model") or u38:IsA("BasePart"))) then
                            u38 = v37:FindFirstChildWhichIsA("BasePart", true);
                        end;
                    else
                        u38 = nil;
                    end;

                    if not (u38 and (u38:IsA("Model") or u38:IsA("BasePart"))) then
                        u38 = v36;
                    end;

                    local u39 = nil;
                    local u40 = nil;

                    if u38:IsA("Model") then
                        u39 = u38:GetPivot();
                        u40 = CFrame.new(u39.Position + Vector3.new(0, -u10, 0)) * u39.Rotation * CFrame.Angles(0, -3.141592653589793, 0);
                    elseif u38:IsA("BasePart") then
                        u39 = u38.CFrame;
                        u40 = CFrame.new(u39.Position + Vector3.new(0, -u10, 0)) * u39.Rotation * CFrame.Angles(0, -3.141592653589793, 0);
                    end;

                    local u41 = 0;
                    local u42 = nil;
                    u42 = RunService.Heartbeat:Connect(function(p43) -- Line: 334
                        -- upvalues: SkillCommon (ref), u8 (ref), runGeneration (ref), u42 (ref), u25 (ref), u41 (ref), u39 (ref), u40 (ref), u38 (ref), u34 (copy), u35 (copy)
                        if not SkillCommon.isRunningSameGeneration(u8, runGeneration) then
                            if u42 then
                                u42:Disconnect();
                            end;

                            return;
                        end;

                        if not u25.Parent then
                            if u42 then
                                u42:Disconnect();
                            end;

                            return;
                        end;

                        u41 = u41 + p43;
                        local v44 = math.clamp(u41 / 0.5, 0, 1);
                        local v45 = 1 - (1 - v44) * (1 - v44);

                        if u39 and u40 then
                            local v46 = u39:Lerp(u40, v45);

                            if u38:IsA("Model") then
                                u38:PivotTo(v46);
                            elseif u38:IsA("BasePart") then
                                u38.CFrame = v46;
                            end;
                        end;

                        for _, v in u34 do
                            if v.Parent then
                                local v47 = u35[v];
                                v.Transparency = v47 + (1 - v47) * v45;
                            end;
                        end;

                        if v44 >= 1 then
                            if u42 then
                                u42:Disconnect();
                            end;

                            if u25.Parent then
                                u25:Destroy();
                            end;
                        end;
                    end);
                    u8:BindRunConn(u42);
                end);
            end);
        end);
        SkillCommon.scheduleRunSpawnClear(u8, runGeneration, skillRunData, "EnwindSpawned", 4.2);
    end,

    Server_EnterMain = function(u48) -- Line: 386, Name: Server_EnterMain
        -- upvalues: SkillCommon (copy)
        local u49 = u48.hitbox[1];

        if not u49 then
            return;
        end;

        local runGeneration = u48.runGeneration;
        SkillCommon.refreshSkillAimSnapshot(u48);
        task.delay(0.45, function() -- Line: 394
            -- upvalues: SkillCommon (ref), u48 (copy), runGeneration (copy)
            if SkillCommon.isRunningSameGeneration(u48, runGeneration) then
                SkillCommon.commitLockedStrike(u48, "enwindLocked", {
                    rayUp = 4,
                    lift = 0.5,
                    rayTag = "Ground"
                });
            end;
        end);
        task.delay(0.483, function() -- Line: 405
            -- upvalues: SkillCommon (ref), u48 (copy), runGeneration (copy), u49 (copy)
            if not SkillCommon.isRunningSameGeneration(u48, runGeneration) then
                return;
            end;

            local v50 = u48.skillRunData.Logic and u48.skillRunData.Logic.enwindLocked;

            if not v50 then
                return;
            end;

            local v51 = 10 * SkillCommon.scaleBandFromData(u48, SkillCommon.bandScaleOptsFromSkillData(u48));
            local hitbox = u49.hitbox;

            if hitbox:IsA("BasePart") then
                hitbox.Shape = Enum.PartType.Ball;
            end;

            hitbox:PivotTo(CFrame.new(v50.groundCenter + Vector3.new(0, -1.8, 0)) * CFrame.lookAt(Vector3.new(0, 0, 0), v50.forward, Vector3.new(0, 1, 0)).Rotation);
            hitbox.Size = Vector3.new(v51, v51, v51);
            u49:start();
            task.delay(0.2, function() -- Line: 424
                -- upvalues: SkillCommon (ref), u48 (ref), runGeneration (ref), u49 (ref)
                if not SkillCommon.isRunningSameGeneration(u48, runGeneration) then
                    return;
                end;

                if u49.isActive then
                    u49:stop();
                    u49.hitbox.Transparency = 1;
                end;
            end);
        end);
    end,

    Client_ExitMain = function(p52) -- Line: 436, Name: Client_ExitMain
        -- upvalues: SkillCommon (copy)
        local skillRunData = p52.skillRunData;

        if skillRunData then
            SkillCommon.clearSpawnIfTerminalAfterExit(p52, p52.runGeneration, skillRunData, "EnwindSpawned");
        end;
    end,

    Server_EnterRecovery = function(p53) -- Line: 443, Name: Server_EnterRecovery
        p53:releaseControl();
    end,

    Client_EnterRecovery = function(p54) -- Line: 447, Name: Client_EnterRecovery
        -- upvalues: SkillCommon (copy)
        local skillRunData = p54.skillRunData;

        if skillRunData and skillRunData.material then
            SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "地系尾迹2", "缠绕Cast尾迹");
        end;
    end,

    onEnd = function(p55) -- Line: 454, Name: onEnd
    end,

    onEndServer = function(p56) -- Line: 457, Name: onEndServer
        local v57 = p56.hitbox and p56.hitbox[1];

        if v57 and v57.isActive then
            v57:stop();
        end;
    end,

    SoundList = { "音效-技能-木系法阵", "音效-技能-木2禁锢-攻击" },
    AnimateList = { "技能释放动作10" },
    ResNameList = { "地系尾迹2", "缠绕_法阵", "缠绕_施法vfx", "缠绕藤曼及特效" },
    hitboxConfig = { {
            HitboxIndex = 1,
            PartName = "通用球",
            CollisionGroup = "Player",
            HitPresentationProfile = "通用受击",
            PhysicsEffectName = "通用受击物理效果"
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