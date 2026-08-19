-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local BurstStone = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Wind,
    InitialState = "Startup",
    ControlOpenState = "TornadoMoving",
    States = {
        Startup = {
            Duration = 0.73,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        TornadoMoving = {
            Duration = 3,
            OnEnterClient = "Client_EnterTornadoMoving",
            OnEnterServer = "Server_EnterTornadoMoving",
            OnExitClient = "Client_ExitTornadoMoving",
            OnExitServer = "Server_ExitTornadoMoving"
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
    },
    Transitions = {
        {
            From = "Startup",
            To = "TornadoMoving",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "TornadoMoving",
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
            From = "TornadoMoving",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "TornadoMoving",
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

local function get_skillScale(p2) -- Line: 79
    -- upvalues: SkillCommon (copy)
    local v3 = SkillCommon.skillScaleFromSkillData(p2);
    local v4 = math.max(v3, 0.1);
    local v5 = math.sqrt(v4);
    local v6, v7 = SkillCommon.scaleDualFromData(p2, SkillCommon.bandScaleOptsFromSkillData(p2));

    return v6, v7, math.clamp(v5, 0.5, 2);
end;

function v1.Client_EnterStartup(p8) -- Line: 89
    -- upvalues: SkillCommon (copy), RunService (copy)
    local character = p8.skillInputData.character;

    if not character then
        return;
    end;

    local u9 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u9 then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    local u10 = p8.skillRunData.material["风系尾迹"];

    for _, descendant in pairs(u10:GetDescendants()) do
        if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        end;
    end;

    u10.Parent = workspace.Debris;
    p8.skillRunData.runEvent["龙卷风Cast尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 105
        -- upvalues: u9 (copy), u10 (copy)
        if u9.Parent then
            u10:PivotTo(u9:GetPivot());
        end;
    end);
end;

function v1.Server_EnterStartup(p11) -- Line: 113
    local v12 = p11.hitbox[1];

    if v12 and v12.hitbox then
        v12.hitbox.Size = Vector3.new(14, 28, 14);
    end;
end;

function v1.Client_EnterTornadoMoving(u13) -- Line: 121
    -- upvalues: SkillCommon (copy), FXUtil (copy), BurstStone (copy), RunService (copy)
    SkillCommon.refreshSkillAimSnapshot(u13);
    task.delay(0, function() -- Line: 123
        -- upvalues: u13 (copy), SkillCommon (ref), FXUtil (ref), BurstStone (ref), RunService (ref)
        if not u13:isRunningFlow() then
            return;
        end;

        if u13.GetCurrentState and u13:GetCurrentState() ~= "TornadoMoving" then
            return;
        end;

        local character = u13.skillInputData.character;

        if not character then
            return;
        end;

        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local targetCF = u13.skillInputData.targetCF;
        local v14 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
        local v15 = CFrame.lookAt(v14.Position, targetCF.Position);
        local v16 = u13;
        local v17 = SkillCommon.skillScaleFromSkillData(v16);
        local v18 = math.max(v17, 0.1);
        local v19 = math.sqrt(v18);
        local _, v20 = SkillCommon.scaleDualFromData(v16, SkillCommon.bandScaleOptsFromSkillData(v16));
        math.clamp(v19, 0.5, 2);
        local v21 = u13.skillRunData.material["风刃法阵"];
        v21:ScaleTo(v20);
        v21:PivotTo(v15 * CFrame.Angles(1.5707963267948966, 0, 0));
        v21.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v21, true);
        local v22 = u13;
        local v23 = SkillCommon.skillScaleFromSkillData(v22);
        local v24 = math.max(v23, 0.1);
        local v25 = math.sqrt(v24);
        local v26, v27 = SkillCommon.scaleDualFromData(v22, SkillCommon.bandScaleOptsFromSkillData(v22));
        local v28 = math.clamp(v25, 0.5, 2);
        local u29 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -3));
        local u30 = u13.skillRunData.material["龙卷风模型"];
        local u31 = u13.skillRunData.material["龙卷风风特效"];

        for _, descendant in pairs(u30:GetDescendants()) do
            if descendant:IsA("Beam") then
                descendant.Enabled = true;
                FXUtil.Beam_Fade_From_Transparent(descendant, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;
        end;

        FXUtil.Model_Scale_Tween(u30, v26, v27, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, nil, true);
        FXUtil.Model_Scale_Tween(u31, v26, v27, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, nil, true);
        u30.Parent = workspace.Debris;
        u31.Parent = workspace.Debris;
        FXUtil.Start_All_Emit(u31, 10);
        SkillCommon.playSoundLocal3D("技能_龙卷风", u30:GetPivot().Position);
        local u32 = u29 + (Vector3.new(targetCF.X, u29.Y, targetCF.Z) - u29.Position).Unit * 64;
        local v33 = CFrame.lookAt(u29.Position, u32.Position);
        BurstStone.CreateShockOneSide(v33, "单条向左偏移石块", v28);
        BurstStone.CreateShockOneSide(v33, "单条向右偏移石块", v28);
        local u34 = 0;
        local u35 = false;
        u13.skillRunData.runEvent["龙卷风移动"] = RunService.Heartbeat:Connect(function(p36) -- Line: 172
            -- upvalues: u34 (ref), u29 (copy), u32 (copy), u30 (copy), u31 (copy), u35 (ref), FXUtil (ref), u13 (ref)
            u34 = u34 + p36;
            local v37 = game.TweenService:GetValue(math.clamp(u34 / 1.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            local v38 = u29:Lerp(u32, v37);
            u30:PivotTo(v38 * CFrame.Angles(0, u34 * 20, 0));
            u31:PivotTo(v38);

            if v37 > 0.9 and not u35 then
                local v39 = math.clamp(1 - v37, 0.01, 1) * 1.5 * 0.8;
                u35 = true;
                FXUtil.Stop_All_Emit(u31);

                for _, descendant in pairs(u31:GetDescendants()) do
                    if descendant:IsA("Beam") then
                        FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, v39, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    end;
                end;

                local v40 = u30:FindFirstChild("龙卷_1");

                if v40 then
                    v40 = v40:FindFirstChildOfClass("Decal");
                end;

                if v40 then
                    FXUtil.Tween_Instance(v40, TweenInfo.new(v39, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Transparency = 1
                    });
                end;
            end;

            if v37 >= 1 and u13.skillRunData.runEvent["龙卷风移动"] then
                u13.skillRunData.runEvent["龙卷风移动"]:Disconnect();
                u13.skillRunData.runEvent["龙卷风移动"] = nil;
            end;
        end);
        task.delay(0.07, function() -- Line: 207
            -- upvalues: u13 (ref)
            local v41 = u13.skillRunData.material["风系尾迹"];

            if v41 then
                for _, descendant in pairs(v41:GetDescendants()) do
                    if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false;
                    end;
                end;
            end;

            if u13.skillRunData.runEvent["龙卷风Cast尾迹"] then
                u13.skillRunData.runEvent["龙卷风Cast尾迹"]:Disconnect();
                u13.skillRunData.runEvent["龙卷风Cast尾迹"] = nil;
            end;
        end);
    end);
end;

function v1.Client_ExitTornadoMoving(p42) -- Line: 224
    if p42.skillRunData.runEvent["龙卷风移动"] then
        p42.skillRunData.runEvent["龙卷风移动"]:Disconnect();
        p42.skillRunData.runEvent["龙卷风移动"] = nil;
    end;
end;

function v1.Server_EnterTornadoMoving(u43) -- Line: 231
    -- upvalues: SkillCommon (copy), FXUtil (copy), RunService (copy)
    local u44 = u43.hitbox[1];
    SkillCommon.refreshSkillAimSnapshot(u43);

    if not u44 then
        return;
    end;

    u44:stop();
    task.delay(0, function() -- Line: 238
        -- upvalues: u43 (copy), SkillCommon (ref), u44 (copy), FXUtil (ref), RunService (ref)
        if not u43:isRunningFlow() then
            return;
        end;

        if u43:GetCurrentState() ~= "TornadoMoving" then
            return;
        end;

        local character = u43.character;

        if not character then
            return;
        end;

        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local v45 = u43;
        local v46 = SkillCommon.skillScaleFromSkillData(v45);
        local v47 = math.max(v46, 0.1);
        local v48 = math.sqrt(v47);
        local v49, v50 = SkillCommon.scaleDualFromData(v45, SkillCommon.bandScaleOptsFromSkillData(v45));
        math.clamp(v48, 0.5, 2);
        local hitbox = u44.hitbox;
        FXUtil.Part_Scale_Tween(hitbox, v49, v50, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local u51 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -3));
        local targetCF = u43.skillInputData.targetCF;
        local u52 = u51 + (Vector3.new(targetCF.X, u51.Y, targetCF.Z) - u51.Position).Unit * 64;
        local u53 = 0;
        local u54 = 0;
        u44:start();
        u43.skillRunData.runEvent["龙卷风伤害盒移动"] = RunService.Heartbeat:Connect(function(p55) -- Line: 262
            -- upvalues: u53 (ref), u54 (ref), u51 (copy), u52 (copy), hitbox (copy), u43 (ref)
            u53 = u53 + p55;
            u54 = u54 + p55;
            local v56 = game.TweenService:GetValue(math.clamp(u53 / 1.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            hitbox:PivotTo(u51:Lerp(u52, v56) * CFrame.Angles(0, u53 * 20, 0));

            if v56 >= 1 and u43.skillRunData.runEvent["龙卷风伤害盒移动"] then
                u43.skillRunData.runEvent["龙卷风伤害盒移动"]:Disconnect();
                u43.skillRunData.runEvent["龙卷风伤害盒移动"] = nil;
            end;
        end);
    end);
end;

function v1.Server_ExitTornadoMoving(p57) -- Line: 281
    if p57.skillRunData.runEvent["龙卷风伤害盒移动"] then
        p57.skillRunData.runEvent["龙卷风伤害盒移动"]:Disconnect();
        p57.skillRunData.runEvent["龙卷风伤害盒移动"] = nil;
    end;

    local v58 = p57.hitbox[1];

    if v58 and v58.isActive then
        v58:stop();
    end;
end;

function v1.Server_EnterRecovery(p59) -- Line: 292
    p59:releaseControl();
end;

function v1.Client_EnterRecovery(p60) -- Line: 296
    local v61 = p60.skillRunData.material["风系尾迹"];

    if v61 then
        for _, descendant in pairs(v61:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    if p60.skillRunData.runEvent["龙卷风Cast尾迹"] then
        p60.skillRunData.runEvent["龙卷风Cast尾迹"]:Disconnect();
        p60.skillRunData.runEvent["龙卷风Cast尾迹"] = nil;
    end;
end;

v1.SoundList = { "技能_龙卷风" };
v1.AnimateList = { "技能释放动作1" };
v1.ResNameList = { "龙卷风模型", "风刃法阵", "龙卷风风特效", "风系尾迹" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
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
        overTime = 1.53,
        animationName = "技能释放动作1",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;