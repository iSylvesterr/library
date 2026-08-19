-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local SkillBuffRuntimeTag = UtilsSystem.EnumMgr.SkillBuffRuntimeTag;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SoundModule = UtilsSystem.SoundModule;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = SkillBuffUtil.GetDurSecForBuffRuntimeTag(SkillBuffRuntimeTag.ReflectThorns);
local u2 = math.max(v1, 0.01);
local v3 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2.1,
    skillElementType = ElementTp.Ice,
    InitialState = "Startup",
    ControlOpenState = "Float",
    States = {
        Startup = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Float = {
            OnEnterClient = "Client_EnterFloat",
            OnEnterServer = "Server_EnterFloat",
            OnExitClient = "Client_ExitFloat",
            OnExitServer = "Server_ExitFloat",
            Duration = u2
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
            To = "Float",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Float",
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
            From = "Float",
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
            From = "Float",
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

local function discVfxFollow(p4) -- Line: 77
    if p4 and (p4.runEvent and p4.runEvent["冰龟VFX跟随"]) then
        p4.runEvent["冰龟VFX跟随"]:Disconnect();
        p4.runEvent["冰龟VFX跟随"] = nil;
    end;
end;

local function discShellFollow(p5) -- Line: 84
    if p5 and (p5.runEvent and p5.runEvent["冰龟反甲跟旋"]) then
        p5.runEvent["冰龟反甲跟旋"]:Disconnect();
        p5.runEvent["冰龟反甲跟旋"] = nil;
    end;
end;

local function stopIceTurtleShieldLoop(p6) -- Line: 91
    -- upvalues: SoundModule (copy)
    if not SoundModule then
        return;
    end;

    local skillInputData = p6.skillInputData;
    local skillCastId = p6.skillCastId;

    if skillCastId then
        skillInputData = skillCastId;
    elseif skillInputData then
        skillInputData = skillInputData.skillCastId;
    end;

    if not skillInputData then
        return;
    end;

    SoundModule:StopSoundLocal({
        SoundName = "音效-技能-冰系反伤护盾-护盾loop",
        SoundTag = skillInputData
    });
end;

function v3.Client_EnterStartup(u7) -- Line: 106
    -- upvalues: SkillCommon (copy), FXUtil (copy), RunService (copy)
    local character = u7.skillInputData.character;

    if not character then
        return;
    end;

    local u8 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u8 then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    task.delay(0.23, function() -- Line: 120
        -- upvalues: u7 (copy), FXUtil (ref), RunService (ref), u8 (copy)
        if not u7:isRunningFlow() then
            return;
        end;

        local u9 = u7.skillRunData.material["冰系尾迹"];

        if not u9 then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(u9, true);
        u9.Parent = workspace.Debris;
        u7.skillRunData.runEvent["冰龟魔杖尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 130
            -- upvalues: u8 (ref), u9 (copy)
            if u8.Parent then
                u9:PivotTo(u8:GetPivot());
            end;
        end);
    end);
end;

function v3.Server_EnterStartup(p10) -- Line: 138
end;

function v3.Client_EnterFloat(u11) -- Line: 140
    -- upvalues: FXUtil (copy), VisibleMgr (copy), SkillCommon (copy), RunService (copy), u2 (copy), SoundModule (copy)
    local character = u11.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = u11.skillRunData;

    if skillRunData.runEvent["冰龟魔杖尾迹"] then
        skillRunData.runEvent["冰龟魔杖尾迹"]:Disconnect();
        skillRunData.runEvent["冰龟魔杖尾迹"] = nil;
    end;

    local v12 = skillRunData.material["冰系尾迹"];

    if v12 then
        FXUtil.SetEmittersTrailsBeamsEnabled(v12, false);
    end;

    local u13 = skillRunData.material["冰龟术VFX"];
    local runGeneration = u11.runGeneration;

    if u13 then
        VisibleMgr.UnQueryAll(u13);
        u13.Parent = workspace.Debris;
        u13:PivotTo(HumanoidRootPart:GetPivot() * CFrame.new(0, 0.5, 0));
        SkillCommon.playSoundLocal3D("音效-技能-冰系反伤护盾-挥动与结冰法阵", u13:GetPivot().Position);
        local u14, u15, u16 = u13:GetPivot():ToOrientation();
        FXUtil.Emit_Particles_GetDescendants(u13, false);
        FXUtil.SetEmittersTrailsBeamsEnabled(u13, true);

        if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["冰龟VFX跟随"]) then
            skillRunData.runEvent["冰龟VFX跟随"]:Disconnect();
            skillRunData.runEvent["冰龟VFX跟随"] = nil;
        end;

        skillRunData.runEvent["冰龟VFX跟随"] = RunService.RenderStepped:Connect(function() -- Line: 171
            -- upvalues: HumanoidRootPart (copy), u13 (copy), u14 (copy), u15 (copy), u16 (copy)
            if not (HumanoidRootPart.Parent and u13.Parent) then
                return;
            end;

            local Position = (HumanoidRootPart:GetPivot() * CFrame.new(0, 0.5, 0)).Position;
            u13:PivotTo(CFrame.new(Position) * CFrame.fromOrientation(u14, u15, u16));
        end);
        task.delay(u2, function() -- Line: 179
            -- upvalues: u11 (copy), runGeneration (copy), FXUtil (ref), u13 (copy)
            if not u11:isRunningFlow() or u11.runGeneration ~= runGeneration then
                return;
            end;

            FXUtil.SetEmittersTrailsBeamsEnabled(u13, false);
        end);
        task.delay(u2 + 2, function() -- Line: 185
            -- upvalues: u11 (copy), runGeneration (copy), FXUtil (ref), u13 (copy)
            if not u11:isRunningFlow() or u11.runGeneration ~= runGeneration then
                return;
            end;

            FXUtil.SetEmittersTrailsBeamsEnabled(u13, false);
        end);
    end;

    local u17 = skillRunData.material["冰龟术反甲"];

    if u17 then
        VisibleMgr.UnQueryAll(u17);
        u17.Parent = workspace.Debris;
        u17:PivotTo(HumanoidRootPart:GetPivot());
        u17:ScaleTo(1);
        FXUtil.SetAllBasePartsTransparency(u17, 1);
        FXUtil.Instance_Transparency_Tween(u17, 0.5, 0.88, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
        local skillInputData = u11.skillInputData;
        local skillCastId = u11.skillCastId;

        if skillCastId then
            skillInputData = skillCastId;
        elseif skillInputData then
            skillInputData = skillInputData.skillCastId;
        end;

        if SoundModule and skillInputData then
            SoundModule:PlaySoundLocal({
                SoundName = "音效-技能-冰系反伤护盾-护盾loop",
                Is2D = false,
                Looped = true,
                AttachPart = HumanoidRootPart,
                SoundTag = skillInputData
            });
        end;

        local u18 = false;
        local u19 = 0;
        local u20 = os.clock();

        if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["冰龟反甲跟旋"]) then
            skillRunData.runEvent["冰龟反甲跟旋"]:Disconnect();
            skillRunData.runEvent["冰龟反甲跟旋"] = nil;
        end;

        skillRunData.runEvent["冰龟反甲跟旋"] = RunService.Heartbeat:Connect(function(p21) -- Line: 219
            -- upvalues: HumanoidRootPart (copy), u17 (copy), u20 (copy), u2 (ref), u19 (ref)
            if not (HumanoidRootPart.Parent and u17.Parent) then
                return;
            end;

            local v22 = os.clock() - u20;

            if v22 >= 0.5 and v22 < u2 + 0.5 then
                u19 = u19 + -0.39269908169872414 * p21;
            end;

            u17:PivotTo(HumanoidRootPart:GetPivot() * CFrame.Angles(0, u19, 0));
        end);
        task.delay(0.5, function() -- Line: 231
            -- upvalues: u11 (copy), runGeneration (copy), u18 (ref), FXUtil (ref), u17 (copy)
            if not u11:isRunningFlow() or u11.runGeneration ~= runGeneration then
                return;
            end;

            local function pulseDown() -- Line: 235
                -- upvalues: u18 (ref), u11 (ref), runGeneration (ref), FXUtil (ref), u17 (ref), pulseDown (copy)
                if u18 or (not u11:isRunningFlow() or u11.runGeneration ~= runGeneration) then
                    return;
                end;

                FXUtil.Model_Scale_Tween(u17, 1, 0.9, 0.34, Enum.EasingStyle.Linear, Enum.EasingDirection.In, function() -- Line: 246
                    -- upvalues: u18 (ref), u11 (ref), runGeneration (ref), FXUtil (ref), u17 (ref), pulseDown (ref)
                    if u18 or (not u11:isRunningFlow() or u11.runGeneration ~= runGeneration) then
                        return;
                    end;

                    FXUtil.Model_Scale_Tween(u17, 0.9, 1, 0.34, Enum.EasingStyle.Linear, Enum.EasingDirection.In, function() -- Line: 257
                        -- upvalues: pulseDown (ref)
                        pulseDown();
                    end, true);
                end, true);
            end;

            pulseDown();
        end);
        task.delay(u2, function() -- Line: 269
            -- upvalues: u18 (ref), u11 (copy), SoundModule (ref), FXUtil (ref), u17 (copy)
            u18 = true;
            local v23 = u11;

            if SoundModule then
                local skillInputData2 = v23.skillInputData;
                local skillCastId2 = v23.skillCastId;

                if skillCastId2 then
                    skillInputData2 = skillCastId2;
                elseif skillInputData2 then
                    skillInputData2 = skillInputData2.skillCastId;
                end;

                if skillInputData2 then
                    SoundModule:StopSoundLocal({
                        SoundName = "音效-技能-冰系反伤护盾-护盾loop",
                        SoundTag = skillInputData2
                    });
                end;
            end;

            FXUtil.Instance_Transparency_Tween(u17, 0.6, 1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
        end);
    end;
end;

function v3.Client_ExitFloat(p24) -- Line: 278
    -- upvalues: SoundModule (copy)
    if not SoundModule then
        return;
    end;

    local skillInputData = p24.skillInputData;
    local skillCastId = p24.skillCastId;

    if skillCastId then
        skillInputData = skillCastId;
    elseif skillInputData then
        skillInputData = skillInputData.skillCastId;
    end;

    if not skillInputData then
        return;
    end;

    SoundModule:StopSoundLocal({
        SoundName = "音效-技能-冰系反伤护盾-护盾loop",
        SoundTag = skillInputData
    });
end;

function v3.Server_EnterFloat(p25) -- Line: 282
end;

function v3.Server_ExitFloat(p26) -- Line: 284
end;

function v3.Server_EnterRecovery(p27) -- Line: 286
    p27:releaseControl();
end;

function v3.Client_EnterRecovery(p28) -- Line: 290
end;

function v3.onEnd(p29) -- Line: 292
    -- upvalues: SoundModule (copy), FXUtil (copy)
    if SoundModule then
        local skillInputData = p29.skillInputData;
        local skillCastId = p29.skillCastId;

        if skillCastId then
            skillInputData = skillCastId;
        elseif skillInputData then
            skillInputData = skillInputData.skillCastId;
        end;

        if skillInputData then
            SoundModule:StopSoundLocal({
                SoundName = "音效-技能-冰系反伤护盾-护盾loop",
                SoundTag = skillInputData
            });
        end;
    end;

    local skillRunData = p29.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["冰龟VFX跟随"]) then
        skillRunData.runEvent["冰龟VFX跟随"]:Disconnect();
        skillRunData.runEvent["冰龟VFX跟随"] = nil;
    end;

    if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["冰龟反甲跟旋"]) then
        skillRunData.runEvent["冰龟反甲跟旋"]:Disconnect();
        skillRunData.runEvent["冰龟反甲跟旋"] = nil;
    end;

    if skillRunData.material and skillRunData.material["冰龟术VFX"] then
        FXUtil.SetEmittersTrailsBeamsEnabled(skillRunData.material["冰龟术VFX"], false);
    end;
end;

function v3.onEndServer(p30) -- Line: 306
end;

v3.SoundList = { "音效-技能-冰系反伤护盾-挥动与结冰法阵", "音效-技能-冰系反伤护盾-护盾loop" };
v3.AnimateList = { "技能释放动作2" };
v3.ResNameList = { "冰系尾迹", "冰龟术VFX", "冰龟术反甲" };
v3.hitboxConfig = {};
v3.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.5,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 0.85,
        animationName = "技能释放动作2",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v3;