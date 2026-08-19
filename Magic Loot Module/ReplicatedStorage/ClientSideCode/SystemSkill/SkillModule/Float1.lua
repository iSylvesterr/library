-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local SkillBuffRuntimeTag = UtilsSystem.EnumMgr.SkillBuffRuntimeTag;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local _ = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local HumanModule = UtilsSystem.HumanModule;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = SkillBuffUtil.GetDurSecForBuffRuntimeTag(SkillBuffRuntimeTag.FloatLightness);
local v2 = math.max(v1, 0.01);

return {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Wind,
    InitialState = "Startup",
    ControlOpenState = "Float",
    States = {
        Startup = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Float = {
            OnEnterClient = "Client_EnterFloat",
            OnEnterServer = "Server_EnterFloat",
            OnExitClient = "Client_ExitFloat",
            OnExitServer = "Server_ExitFloat",
            Duration = v2
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
    },

    Client_EnterStartup = function(u3) -- Line: 79, Name: Client_EnterStartup
        -- upvalues: SkillCommon (copy), RunService (copy)
        local character = u3.skillInputData.character;

        if not character then
            return;
        end;

        local u4 = SkillCommon.resolveWandTipFromCharacter(character);

        if not u4 then
            return;
        end;

        if not character:FindFirstChild("HumanoidRootPart") then
            return;
        end;

        task.delay(0.23, function() -- Line: 88
            -- upvalues: u3 (copy), RunService (ref), u4 (copy)
            if not u3:isRunningFlow() then
                return;
            end;

            local u5 = u3.skillRunData.material["风系尾迹"];

            for _, descendant in pairs(u5:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true;
                end;
            end;

            u5.Parent = workspace.Debris;
            u3.skillRunData.runEvent["轻盈魔杖尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 97
                -- upvalues: u4 (ref), u5 (copy)
                if u4.Parent then
                    u5:PivotTo(u4:GetPivot());
                end;
            end);
        end);
    end,

    Server_EnterStartup = function(p6) -- Line: 105, Name: Server_EnterStartup
    end,

    Client_EnterFloat = function(p7) -- Line: 110, Name: Client_EnterFloat
        -- upvalues: FXUtil (copy), SkillCommon (copy), RunService (copy), HumanModule (copy)
        local character = p7.skillInputData.character;

        if not character then
            return;
        end;

        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local targetCF = p7.skillInputData.targetCF;
        local v8 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
        local v9 = CFrame.lookAt(v8.Position, (Vector3.new(targetCF.X, v8.Y, targetCF.Z)));
        local v10 = p7.skillRunData.material["风刃法阵"];
        v10:PivotTo(v9 * CFrame.Angles(1.5707963267948966, 0, 0));
        v10.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v10, true);

        if p7.skillRunData.runEvent["轻盈魔杖尾迹"] then
            p7.skillRunData.runEvent["轻盈魔杖尾迹"]:Disconnect();
            p7.skillRunData.runEvent["轻盈魔杖尾迹"] = nil;
        end;

        local v11 = p7.skillRunData.material["风系尾迹"];

        if v11 then
            for _, descendant in pairs(v11:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        local u12 = p7.skillRunData.material["轻盈身上特效"];

        for _, descendant in pairs(u12:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u12.Parent = workspace.Debris;
        SkillCommon.playSoundLocal3D("音效-技能-轻盈", u12:GetPivot().Position);
        p7.skillRunData.runEvent["轻盈特效跟随"] = RunService.RenderStepped:Connect(function() -- Line: 147
            -- upvalues: HumanoidRootPart (copy), u12 (copy)
            if HumanoidRootPart and HumanoidRootPart.Parent then
                u12:PivotTo(HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, -3.5, 0)));
            end;
        end);

        if SkillCommon.isLocalPlayerCaster(p7) then
            HumanModule.SetLocalPlayerSpeedAttribute("FLOAT_BUFF", true);
            HumanModule.UpdateLocalPlayerSpeed(0.1);
        end;
    end,

    Client_ExitFloat = function(p13) -- Line: 160, Name: Client_ExitFloat
        -- upvalues: SkillCommon (copy), HumanModule (copy)
        if p13.skillRunData.runEvent["轻盈特效跟随"] then
            p13.skillRunData.runEvent["轻盈特效跟随"]:Disconnect();
            p13.skillRunData.runEvent["轻盈特效跟随"] = nil;
        end;

        local v14 = p13.skillRunData.material["轻盈身上特效"];

        if v14 then
            for _, descendant in pairs(v14:GetDescendants()) do
                if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = false;
                end;
            end;
        end;

        if SkillCommon.isLocalPlayerCaster(p13) then
            HumanModule.SetLocalPlayerSpeedAttribute("FLOAT_BUFF", false);
            HumanModule.UpdateLocalPlayerSpeed(0.1);
        end;
    end,

    Server_EnterFloat = function(p15) -- Line: 181, Name: Server_EnterFloat
    end,

    Server_ExitFloat = function(p16) -- Line: 183, Name: Server_ExitFloat
    end,

    Server_EnterRecovery = function(p17) -- Line: 186, Name: Server_EnterRecovery
        p17:releaseControl();
    end,

    Client_EnterRecovery = function(p18) -- Line: 190, Name: Client_EnterRecovery
    end,

    SoundList = { "音效-技能-轻盈" },
    AnimateList = { "技能释放动作2" },
    ResNameList = { "风系尾迹", "轻盈身上特效", "风刃法阵" },
    hitboxConfig = {},
    Action = {
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
    }
};