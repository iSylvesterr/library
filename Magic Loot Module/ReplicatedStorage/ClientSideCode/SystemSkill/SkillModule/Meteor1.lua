-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local _ = UtilsSystem.CameraModule;
local FXUtil = UtilsSystem.FXUtil;
local BurstStone = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "MeteorFalling",
    States = {
        Startup = {
            Duration = 0.45,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        MeteorFalling = {
            Duration = 1.1,
            OnEnterClient = "Client_EnterMeteorFalling",
            OnEnterServer = "Server_EnterMeteorFalling",
            OnExitClient = "Client_ExitMeteorFalling",
            OnExitServer = "Server_ExitMeteorFalling"
        },
        Recovery = {
            Duration = 1,
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
    },
    Transitions = {
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
    }
};

local function tryMarkMeteorSpawned(p2) -- Line: 100
    if not p2 then
        return false;
    end;

    if not p2.Logic then
        p2.Logic = {};
    end;

    if p2.Logic.meteorSpawned then
        return false;
    end;

    p2.Logic.meteorSpawned = true;

    return true;
end;

local function lockMeteorStrikeAtSpawn(p3, p4) -- Line: 120
    -- upvalues: SkillCommon (copy)
    return SkillCommon.commitLockedStrike(p3, "meteorLocked", {
        rayUp = 3,
        rayTag = "Ground",
        lift = p4
    });
end;

local function finalCFFromLockedStrike(p5, p6) -- Line: 134
    return p6.Rotation + p5.groundCenter;
end;

local function cleanupWandTrail(p7) -- Line: 142
    if not p7 then
        return;
    end;

    local runEvent = p7.runEvent;

    if runEvent and runEvent["陨石术魔杖尾迹"] then
        runEvent["陨石术魔杖尾迹"]:Disconnect();
        runEvent["陨石术魔杖尾迹"] = nil;
    end;

    local v8 = p7.material and p7.material["火系尾迹"];

    if v8 then
        for _, descendant in pairs(v8:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;
end;

function v1.Client_EnterStartup(u9) -- Line: 162
    -- upvalues: SkillCommon (copy), PlayerAimSync (copy), FXUtil (copy), RunService (copy), BurstStone (copy)
    local character = u9.skillInputData.character;

    if not character then
        return;
    end;

    local u10 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u10 then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = u9.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local runGeneration = u9.runGeneration;

    local function stillTrail() -- Line: 183
        -- upvalues: u9 (copy), runGeneration (copy)
        local v11 = u9:isRunningFlow() and u9.runGeneration == runGeneration;

        return v11;
    end;

    local v12;

    if skillRunData then
        if not skillRunData.Logic then
            skillRunData.Logic = {};
        end;

        if skillRunData.Logic.meteorSpawned then
            v12 = false;
        else
            skillRunData.Logic.meteorSpawned = true;
            v12 = true;
        end;
    else
        v12 = false;
    end;

    if v12 then
        PlayerAimSync.refreshAimSnapshot(u9);
        local v13 = SkillCommon.commitLockedStrike(u9, "meteorLocked", {
            rayUp = 3,
            lift = 0.5,
            rayTag = "Ground"
        });
        local u14 = SkillCommon.scaleBandFromData(u9, SkillCommon.bandScaleOptsFromSkillData(u9));
        local v15 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
        local v16 = skillRunData.material["陨石术法阵"];
        v16:ScaleTo(u14);
        v16:PivotTo(v15 * CFrame.Angles(1.5707963267948966, 0, 0));
        v16.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v16, true);
        local groundCenter = v13.groundCenter;
        local v17 = HumanoidRootPart:GetPivot();
        local v18 = 60 * (1 - 2 * math.random());
        local v19 = v17:PointToWorldSpace((Vector3.new(v18, 60, 60)));
        local u20 = CFrame.lookAt(v19, groundCenter);
        local u21 = u20.Rotation + v13.groundCenter;
        local u22 = skillRunData.material["陨石术火球"];
        local u23 = skillRunData.material["陨石术爆炸"];
        u22:ScaleTo(u14);
        u22:PivotTo(u20);
        u22.Parent = workspace.Debris;
        u23:ScaleTo(u14);
        u23:PivotTo(CFrame.new(u21.Position));
        u23.Parent = workspace.Debris;
        SkillCommon.playSoundLocal3D("音效-技能-陨石术-飞行", u22:GetPivot().Position);
        FXUtil.Start_All_Emit(u22, 10);

        for _, descendant in pairs(u22:GetDescendants()) do
            if descendant:IsA("Beam") then
                descendant.Enabled = true;
                FXUtil.Beam_Fade_From_Transparent(descendant, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;

            if descendant:IsA("MeshPart") then
                descendant.Transparency = 0;
            end;
        end;

        local u24 = 0;

        if not skillRunData.runEvent then
            skillRunData.runEvent = {};
        end;

        skillRunData.runEvent["陨石坠落移动"] = RunService.Heartbeat:Connect(function(p25) -- Line: 232
            -- upvalues: u9 (copy), runGeneration (copy), skillRunData (copy), u24 (ref), u20 (copy), u21 (copy), u22 (copy), SkillCommon (ref), FXUtil (ref), u23 (copy), BurstStone (ref), u14 (copy)
            if not u9:isRunningFlow() or u9.runGeneration ~= runGeneration then
                if skillRunData.runEvent["陨石坠落移动"] then
                    skillRunData.runEvent["陨石坠落移动"]:Disconnect();
                    skillRunData.runEvent["陨石坠落移动"] = nil;
                end;

                return;
            end;

            u24 = u24 + p25;
            local v26 = game.TweenService:GetValue(math.clamp(u24 / 0.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            u22:PivotTo((u20:Lerp(u21, v26)));

            if v26 >= 1 then
                SkillCommon.playSoundLocal3D("音效-技能-陨石术-爆炸", u22:GetPivot().Position);
                FXUtil.Emit_Particles_GetDescendants(u23, true);
                BurstStone.CreateLandBreak(u21, "Meteor", u14);
                BurstStone.CreateStoneFly(u21, "Meteor", u14);

                if skillRunData.runEvent["陨石坠落移动"] then
                    skillRunData.runEvent["陨石坠落移动"]:Disconnect();
                    skillRunData.runEvent["陨石坠落移动"] = nil;
                end;

                FXUtil.Stop_All_Emit(u22);

                for _, descendant in pairs(u22:GetDescendants()) do
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

    task.delay(0.15, function() -- Line: 272
        -- upvalues: u9 (copy), runGeneration (copy), RunService (ref), u10 (copy)
        local v27 = u9:isRunningFlow() and u9.runGeneration == runGeneration;

        if not v27 then
            return;
        end;

        local skillRunData2 = u9.skillRunData;

        if not (skillRunData2 and skillRunData2.material) then
            return;
        end;

        local u28 = skillRunData2.material["火系尾迹"];

        if not u28 then
            return;
        end;

        for _, descendant in pairs(u28:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u28.Parent = workspace.Debris;

        if not skillRunData2.runEvent then
            skillRunData2.runEvent = {};
        end;

        skillRunData2.runEvent["陨石术魔杖尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 293
            -- upvalues: u10 (ref), u28 (copy)
            if u10.Parent and u28.Parent then
                u28:PivotTo(u10:GetPivot());
            end;
        end);
    end);
end;

function v1.Server_EnterStartup(u29) -- Line: 301
    -- upvalues: SkillCommon (copy), RunService (copy)
    local u30 = u29.hitbox[1];

    if not (u30 and u30.hitbox) then
        return;
    end;

    local v31 = SkillCommon.scaleBandFromData(u29, SkillCommon.bandScaleOptsFromSkillData(u29));
    u30.hitbox.Size = Vector3.new(40, 40, 40) * v31;
    local skillRunData = u29.skillRunData;

    if skillRunData then
        local v32;

        if skillRunData then
            if not skillRunData.Logic then
                skillRunData.Logic = {};
            end;

            if skillRunData.Logic.meteorSpawned then
                v32 = false;
            else
                skillRunData.Logic.meteorSpawned = true;
                v32 = true;
            end;
        else
            v32 = false;
        end;

        if v32 then
            SkillCommon.refreshSkillAimSnapshot(u29);
            local v33 = SkillCommon.commitLockedStrike(u29, "meteorLocked", {
                rayUp = 3,
                lift = 0.1,
                rayTag = "Ground"
            });
            local groundCenter = v33.groundCenter;
            local hitbox = u30.hitbox;
            local v34 = (CFrame.new(groundCenter) * CFrame.Angles(0, math.random() * 6.283185307179586, 0)):PointToWorldSpace(Vector3.new(0, 60, -60));
            hitbox:PivotTo(CFrame.lookAt(v34, groundCenter).Rotation + v33.groundCenter);
            local u35 = 0;
            local u36 = false;

            if not skillRunData.runEvent then
                skillRunData.runEvent = {};
            end;

            skillRunData.runEvent["陨石命中检测坠落移动"] = RunService.Heartbeat:Connect(function(p37) -- Line: 332
                -- upvalues: u29 (copy), skillRunData (copy), u30 (copy), u35 (ref), u36 (ref)
                if not u29:isRunningFlow() then
                    if skillRunData.runEvent["陨石命中检测坠落移动"] then
                        skillRunData.runEvent["陨石命中检测坠落移动"]:Disconnect();
                        skillRunData.runEvent["陨石命中检测坠落移动"] = nil;
                    end;

                    if u30.isActive then
                        u30:stop();
                    end;

                    return;
                end;

                u35 = u35 + p37;

                if u35 < 0.5 or u36 then
                    if u35 >= 0.7 then
                        if skillRunData.runEvent["陨石命中检测坠落移动"] then
                            skillRunData.runEvent["陨石命中检测坠落移动"]:Disconnect();
                            skillRunData.runEvent["陨石命中检测坠落移动"] = nil;
                        end;

                        u30:stop();
                    end;

                    return;
                end;

                u36 = true;
                u30:start();
            end);
        end;
    end;
end;

function v1.Client_EnterMeteorFalling(p38) -- Line: 360
    -- upvalues: cleanupWandTrail (copy)
    cleanupWandTrail(p38.skillRunData);
end;

function v1.Client_ExitMeteorFalling(p39) -- Line: 364
    local skillRunData = p39.skillRunData;

    if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["陨石坠落移动"]) then
        skillRunData.runEvent["陨石坠落移动"]:Disconnect();
        skillRunData.runEvent["陨石坠落移动"] = nil;
    end;
end;

function v1.Server_EnterMeteorFalling(p40) -- Line: 372
end;

function v1.Server_ExitMeteorFalling(p41) -- Line: 374
    local skillRunData = p41.skillRunData;

    if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["陨石命中检测坠落移动"]) then
        skillRunData.runEvent["陨石命中检测坠落移动"]:Disconnect();
        skillRunData.runEvent["陨石命中检测坠落移动"] = nil;
    end;

    local v42 = p41.hitbox[1];

    if v42 and v42.isActive then
        v42:stop();
    end;
end;

function v1.Server_EnterRecovery(p43) -- Line: 387
    p43:releaseControl();
end;

function v1.Client_EnterRecovery(p44) -- Line: 391
    -- upvalues: cleanupWandTrail (copy)
    cleanupWandTrail(p44.skillRunData);
end;

v1.SoundList = { "音效-技能-陨石术-飞行", "音效-技能-陨石术-爆炸" };
v1.AnimateList = { "技能释放动作4" };
v1.ResNameList = { "陨石术爆炸", "陨石术法阵", "陨石术火球", "火系尾迹" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        CameraShakeProfile = "中等碰撞震",
        HitPresentationProfile = "火属性受击",
        PhysicsEffectName = "中等力度受击物理效果"
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
        overTime = 1.4,
        animationName = "技能释放动作4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;