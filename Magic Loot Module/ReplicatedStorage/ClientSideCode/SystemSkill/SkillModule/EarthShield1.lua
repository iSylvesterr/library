-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "StoneBurst",
    States = {
        Startup = {
            Duration = 0.73,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        StoneBurst = {
            Duration = 6,
            OnEnterClient = "Client_EnterStoneBurst",
            OnEnterServer = "Server_EnterStoneBurst",
            OnExitClient = "Client_ExitStoneBurst",
            OnExitServer = "Server_ExitStoneBurst"
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
            To = "StoneBurst",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "StoneBurst",
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
            From = "StoneBurst",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "StoneBurst",
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

local function get_skillScale(p2) -- Line: 84
    -- upvalues: SkillCommon (copy)
    return SkillCommon.scaleBandFromData(p2, SkillCommon.bandScaleOptsFromSkillData(p2));
end;

function v1.onStart(p3) -- Line: 88
    -- upvalues: FXUtil (copy)
    local v4 = p3.skillRunData and p3.skillRunData.material and p3.skillRunData.material["地之护盾岩墙"];

    if v4 and v4:IsA("Model") then
        FXUtil.SetAllBasePartsTransparency(v4, 0);
    end;
end;

function v1.Client_EnterStartup(u5) -- Line: 96
    -- upvalues: SkillCommon (copy), RunService (copy), get_skillScale (copy), FXUtil (copy)
    local character = u5.skillInputData.character;

    if not character then
        return;
    end;

    local u6 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u6 then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u5.runGeneration;
    local u7 = nil;
    local u8 = nil;

    local function stillTrail() -- Line: 111
        -- upvalues: u5 (copy), runGeneration (copy)
        local v9 = u5:isRunningFlow() and u5.runGeneration == runGeneration;

        return v9;
    end;

    local function cleanupEarthShieldTrail() -- Line: 115
        -- upvalues: u7 (ref), u8 (ref), u5 (copy)
        if u7 then
            for _, descendant in pairs(u7:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        if u8 then
            u8:Disconnect();
            u8 = nil;
        end;

        u7 = nil;
        local skillRunData = u5.skillRunData;

        if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["地之护盾魔杖尾迹"]) then
            skillRunData.runEvent["地之护盾魔杖尾迹"] = nil;
        end;
    end;

    task.delay(0.3, function() -- Line: 134
        -- upvalues: u5 (copy), runGeneration (copy), u7 (ref), u8 (ref), RunService (ref), u6 (copy)
        local v10 = u5:isRunningFlow() and u5.runGeneration == runGeneration;

        if not v10 then
            return;
        end;

        local skillRunData = u5.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local v11 = skillRunData.material["土系尾迹"];

        if not v11 then
            return;
        end;

        u7 = v11;

        for _, descendant in pairs(v11:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        v11.Parent = workspace.Debris;

        if not skillRunData.runEvent then
            skillRunData.runEvent = {};
        end;

        u8 = RunService.RenderStepped:Connect(function() -- Line: 156
            -- upvalues: u6 (ref), u7 (ref)
            if u6.Parent and u7 then
                u7:PivotTo(u6:GetPivot());
            end;
        end);
        skillRunData.runEvent["地之护盾魔杖尾迹"] = u8;
    end);
    task.delay(0.73, function() -- Line: 165
        -- upvalues: u5 (copy), HumanoidRootPart (copy), get_skillScale (ref), FXUtil (ref), SkillCommon (ref)
        if not u5:isRunningFlow() then
            return;
        end;

        local skillRunData = u5.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local _ = u5.skillInputData.targetCF;
        local v12 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
        local v13 = skillRunData.material["地之护盾法阵"];

        if not v13 then
            return;
        end;

        v13:ScaleTo(get_skillScale(u5));
        v13:PivotTo(v12 * CFrame.Angles(1.5707963267948966, 0, 0));
        v13.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v13, true);
        SkillCommon.playSoundLocal3D("音效-技能-地法阵", v13:GetPivot().Position);
    end);
    task.delay(0.9, function() -- Line: 186
        -- upvalues: u5 (copy), runGeneration (copy), cleanupEarthShieldTrail (copy)
        if u5.runGeneration ~= runGeneration then
            return;
        end;

        cleanupEarthShieldTrail();
    end);
end;

function v1.Server_EnterStartup(p14) -- Line: 194
    local v15 = p14.hitbox[1];

    if v15 and v15.hitbox then
        v15.hitbox.Size = Vector3.new(30, 30, 30);
    end;
end;

function v1.Client_EnterStoneBurst(u16) -- Line: 202
    -- upvalues: SkillCommon (copy), RayCast (copy), FXUtil (copy), RunService (copy)
    SkillCommon.refreshSkillAimSnapshot(u16);
    local releaseCF = u16.skillInputData.releaseCF;
    local targetCF = u16.skillInputData.targetCF;
    local v17 = CFrame.new(Vector3.new(releaseCF.X, 0, releaseCF.Z), (Vector3.new(targetCF.X, 0, targetCF.Z)));
    local v18 = RayCast.RayCastDirection(targetCF.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v18 then
        targetCF = v17.Rotation + v18.Position + Vector3.new(0, 0.5, 0);
    end;

    local v19 = SkillCommon.scaleBandFromData(u16, SkillCommon.bandScaleOptsFromSkillData(u16));
    local u20 = u16.skillRunData.material["地之护盾岩墙"];
    local u21 = u16.skillRunData.material["地之护盾石头出土爆炸"];
    u20:ScaleTo(v19);
    local Main = u20.Main;
    local u22 = targetCF - Vector3.new(0, Main.Size.Y / 2 + 1 * v19, 0);
    local u23 = targetCF + Vector3.new(0, Main.Size.Y / 2 - 1.5 * v19, 0);
    u20.Parent = workspace.Debris;
    u20:PivotTo(u22);
    u21:ScaleTo(v19);
    u21.Parent = workspace.Debris;
    u21:PivotTo(targetCF);
    SkillCommon.playSoundLocal3D("音效-技能-地之护盾-突起", u21:GetPivot().Position);
    FXUtil.Emit_Particles_GetDescendants(u21, true);
    FXUtil.Start_All_Emit(u20, 10);
    local u24 = 0;
    local u25 = 0;
    local u26 = false;
    u16.skillRunData.runEvent["岩石出现"] = RunService.Heartbeat:Connect(function(p27) -- Line: 237
        -- upvalues: u24 (ref), u22 (copy), u23 (copy), u20 (copy), u25 (ref), u26 (ref), FXUtil (ref), u16 (copy), SkillCommon (ref), u21 (copy)
        u24 = u24 + p27;
        local v28 = game.TweenService:GetValue(math.clamp(u24 / 0.2, 0, 1), Enum.EasingStyle.Back, Enum.EasingDirection.Out);
        u20:PivotTo((u22:Lerp(u23, v28)));

        if v28 >= 1 then
            u25 = u25 + p27;

            if not u26 and u25 >= 4.5 then
                u26 = true;
                FXUtil.Stop_All_Emit(u20);
            end;

            if u25 >= 5 then
                if u16.skillRunData.runEvent["岩石出现"] then
                    u16.skillRunData.runEvent["岩石出现"]:Disconnect();
                    u16.skillRunData.runEvent["岩石出现"] = nil;
                end;

                FXUtil.Tween_Instance(u20.Main, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
                    Transparency = 1
                });
                SkillCommon.playSoundLocal3D("音效-技能-地之护盾-护盾消失", u21:GetPivot().Position);
            end;
        end;
    end);
end;

function v1.Client_ExitStoneBurst(p29) -- Line: 266
end;

function v1.Server_EnterStoneBurst(u30) -- Line: 270
    -- upvalues: SkillCommon (copy), RayCast (copy), RunService (copy)
    SkillCommon.refreshSkillAimSnapshot(u30);
    local u31 = u30.hitbox[1];

    if not u31 then
        return;
    end;

    local v32 = SkillCommon.scaleBandFromData(u30, SkillCommon.bandScaleOptsFromSkillData(u30));
    local hitbox = u31.hitbox;
    local u33 = script["地之护盾岩墙碰撞"]:Clone();
    u33.Parent = workspace.Debris;
    u33.Anchored = true;
    u33.Transparency = 1;
    u33.Size = Vector3.new(18.631, 13.322, 5.788) * v32;
    hitbox.Size = u33.Size * 2;
    u30.skillRunData.material["地之护盾岩墙碰撞"] = u33;
    game.Debris:AddItem(u33, 5);
    local releaseCF = u30.skillInputData.releaseCF;
    local targetCF = u30.skillInputData.targetCF;
    local v34 = CFrame.new(Vector3.new(releaseCF.X, 0, releaseCF.Z), (Vector3.new(targetCF.X, 0, targetCF.Z)));
    local v35 = RayCast.RayCastDirection(targetCF.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v35 then
        targetCF = v34.Rotation + v35.Position + Vector3.new(0, 0.5, 0);
    end;

    local u36 = targetCF - Vector3.new(0, u33.Size.Y / 2 + 1 * v32, 0);
    local u37 = targetCF + Vector3.new(0, u33.Size.Y / 2 - 1.5 * v32, 0);
    hitbox:PivotTo(u36);
    u31:start();
    local u38 = 0;
    local u39 = 0;
    u30.skillRunData.runEvent["岩石实体出现"] = RunService.Heartbeat:Connect(function(p40) -- Line: 302
        -- upvalues: u38 (ref), u36 (copy), u37 (copy), u33 (copy), hitbox (copy), u39 (ref), u31 (copy), u30 (copy)
        u38 = u38 + p40;
        local v41 = game.TweenService:GetValue(math.clamp(u38 / 0.2, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v42 = u36:Lerp(u37, v41);
        u33:PivotTo(v42);
        hitbox:PivotTo(v42);

        if v41 >= 1 then
            if u39 > 0.3 then
                u31:stop();
            end;

            u39 = u39 + p40;

            if u39 >= 5 and u30.skillRunData.runEvent["岩石实体出现"] then
                u30.skillRunData.runEvent["岩石实体出现"]:Disconnect();
                u30.skillRunData.runEvent["岩石实体出现"] = nil;
            end;
        end;
    end);
end;

function v1.Server_ExitStoneBurst(p43) -- Line: 332
    local v44 = p43.hitbox[1];

    if v44 and v44.isActive then
        v44:stop();
    end;
end;

function v1.Server_EnterRecovery(p45) -- Line: 340
    p45:releaseControl();
end;

function v1.Client_EnterRecovery(p46) -- Line: 344
    local skillRunData = p46.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local v47 = skillRunData.material["土系尾迹"];

    if v47 then
        for _, descendant in pairs(v47:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local runEvent = skillRunData.runEvent;

    if runEvent and runEvent["地之护盾魔杖尾迹"] then
        runEvent["地之护盾魔杖尾迹"]:Disconnect();
        runEvent["地之护盾魔杖尾迹"] = nil;
    end;
end;

function v1.onEndServer(p48) -- Line: 364
    if p48.skillRunData.material and p48.skillRunData.material["地之护盾岩墙碰撞"] then
        print("技能中断删除资源");
        game.Debris:AddItem(p48.skillRunData.material["地之护盾岩墙碰撞"], 0);
    end;
end;

v1.SoundList = { "音效-技能-地法阵", "音效-技能-地之护盾-突起" };
v1.AnimateList = { "技能释放动作4" };
v1.ResNameList = { "地之护盾石头出土爆炸", "土系尾迹", "地之护盾法阵", "地之护盾岩墙" };
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
        overTime = 1.4,
        animationName = "技能释放动作4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;