-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local GetSkillData = require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RayCast = UtilsSystem.RayCast;
local RunService = UtilsSystem.RunService;
local _ = UtilsSystem.Debris;
local _ = UtilsSystem.InsMgr;
local SystemPlrAttr = UtilsSystem.SystemPlrAttr;
local u1 = UtilsSystem.SystemGameConfig.Get();
local v2 = {
    skillTotalTime = 1.07,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "Rolling",
    States = {
        Startup = {
            Duration = 0.05,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Rolling = {
            Duration = 0.55,
            OnEnterClient = "Client_EnterRolling",
            OnEnterServer = "Server_EnterRolling",
            OnExitClient = "Client_ExitRolling",
            OnExitServer = nil
        },
        Recovery = {
            Duration = 0.57,
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
            To = "Rolling",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Rolling",
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
            From = "Rolling",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Rolling",
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

local function getDirection(p3) -- Line: 79
    -- upvalues: GetSkillData (copy)
    local v4 = p3.skillInputData and p3.skillInputData.character;

    return not v4 and "Forward" or GetSkillData.getCharacterDirectionStr(v4);
end;

local function getCharacterParts(p5) -- Line: 85
    local v6 = p5.skillInputData and p5.skillInputData.character;

    if v6 then
        return v6, v6:FindFirstChild("HumanoidRootPart"), v6:FindFirstChildOfClass("Humanoid");
    end;

    return nil, nil;
end;

function v2.Client_EnterStartup(p7) -- Line: 94
    -- upvalues: GetSkillData (copy)
    local v8 = p7.skillInputData and p7.skillInputData.character;
    local v9;

    if v8 then
        v9 = v8:FindFirstChild("HumanoidRootPart");
        v8:FindFirstChildOfClass("Humanoid");
    else
        v8 = nil;
        v9 = nil;
    end;

    if not (v8 and v9) then
        return;
    end;

    local v10 = p7.skillInputData and p7.skillInputData.character;
    local v11 = (not v10 and "Forward" or GetSkillData.getCharacterDirectionStr(v10)) == "Forward" and p7.skillRunData.material["闪现收缩特效"];

    if v11 then
        v11.Parent = workspace.Debris;
        v11:PivotTo(v9:GetPivot():ToWorldSpace(CFrame.new(0, 0, -5)));
    end;
end;

function v2.Server_EnterStartup(p12) -- Line: 109
end;

function v2.Client_EnterRolling(u13) -- Line: 114
    -- upvalues: VisibleMgr (copy), GetSkillData (copy), FXUtil (copy), RunService (copy), RayCast (copy)
    local v14 = u13.skillInputData and u13.skillInputData.character;
    local u15, u16;

    if v14 then
        u15 = v14:FindFirstChild("HumanoidRootPart");
        u16 = v14:FindFirstChildOfClass("Humanoid");
    else
        v14 = nil;
        u15 = nil;
        u16 = nil;
    end;

    if not (v14 and u15) then
        return;
    end;

    VisibleMgr.CloseShade(v14);
    local v17 = u13.skillInputData and u13.skillInputData.character;
    local v18 = not v17 and "Forward" or GetSkillData.getCharacterDirectionStr(v17);
    local skillRunData = u13.skillRunData;
    local u19 = skillRunData.runEvent or {};

    if v18 == "Forward" then
        VisibleMgr.FadeCharacterModel(v14, 1, 0.1, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        local u20 = skillRunData.material["前冲跟随特效"];

        if u20 then
            u20:PivotTo(u15:GetPivot());
            u20.Parent = workspace.Debris;
            local _ = u20["冲刺新做"]["Enabled1_L_1普攻1"].Trail;
            local u21 = u20["冲刺新做"]["Enabled1_L_1普攻1"];
            local u22 = u20["冲刺新做"]["Enabled1_R_1普攻1"];
            u21.CFrame = CFrame.new(0, 0, 0);
            u22.CFrame = CFrame.new(0, 0, 0);
            local bm_2 = u20["冲刺新做"].bm_2;
            u20["冲刺新做"].bm_1.CFrame = CFrame.new(0, 0, 0);
            bm_2.CFrame = CFrame.new(0, 0, 0);

            for _, descendant in pairs(u20:GetDescendants()) do
                if descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true;

                    if descendant.Name == "1_Emit" or descendant.Name == "2_Emit" then
                        descendant:Emit(2);
                    end;
                end;

                if descendant:IsA("Trail") then
                    descendant.Enabled = true;
                end;

                if descendant:IsA("Beam") then
                    descendant.Enabled = true;
                    FXUtil.Beam_Fade_From_Transparent(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                end;
            end;

            local u23 = 0;
            u19["闪现角色黑烟"] = RunService.RenderStepped:Connect(function(p24) -- Line: 163
                -- upvalues: u23 (ref), u15 (copy), u20 (copy), u21 (copy), u22 (copy), bm_2 (copy)
                u23 = u23 + p24;

                if u15 and u15.Parent then
                    u20:PivotTo(u15:GetPivot());
                end;

                local v25 = game.TweenService:GetValue(math.clamp(u23 / 0.05, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                u21.CFrame = CFrame.new(0, -v25 * 12, 0);
                u22.CFrame = CFrame.new(0, v25 * 12, 0);
                local v26 = game.TweenService:GetValue(math.clamp(u23 / 0.2, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                bm_2.CFrame = CFrame.new(-v26 * 25, 0, 0);
            end);
        end;
    end;

    if v18 == "Backward" then
        task.delay(0.07, function() -- Line: 185
            -- upvalues: u13 (copy), skillRunData (copy), u16 (copy), u15 (copy), RunService (ref), RayCast (ref), FXUtil (ref), u19 (copy)
            if not u13:isRunningFlow() then
                return;
            end;

            local u27 = skillRunData.material["翻滚烟尘"];

            if u27 and (u16 and u15) then
                u27.Parent = workspace.Debris;
                local u28 = 0;
                u19["向后翻滚烟尘"] = RunService.RenderStepped:Connect(function(p29) -- Line: 192
                    -- upvalues: u28 (ref), u15 (ref), u16 (ref), RayCast (ref), u27 (copy), FXUtil (ref)
                    u28 = u28 + p29;

                    if u28 >= 0.03 then
                        u28 = 0;
                        local v30 = u15 and (u15.Parent and u16) and (u16.FloorMaterial ~= "Air" and RayCast.RayCast(u15.Position, u15.Position - Vector3.new(0, 10, 0), "Ground"));

                        if v30 then
                            if v30.Instance and v30.Instance:IsA("BasePart") then
                                for _, descendant in pairs(u27:GetDescendants()) do
                                    if descendant:IsA("ParticleEmitter") then
                                        descendant.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v30.Instance.Color), ColorSequenceKeypoint.new(1, v30.Instance.Color) });
                                    end;
                                end;
                            end;

                            u27:PivotTo(CFrame.new(v30.Position));
                            FXUtil.Emit_Particles_GetDescendants(u27, true);
                        end;
                    end;
                end);
            end;
        end);
        task.delay(0.3, function() -- Line: 218
            -- upvalues: u19 (copy)
            if u19["向后翻滚烟尘"] then
                u19["向后翻滚烟尘"]:Disconnect();
                u19["向后翻滚烟尘"] = nil;
            end;
        end);
    end;

    if v18 == "Left" or v18 == "Right" then
        task.delay(0.11, function() -- Line: 228
            -- upvalues: u13 (copy), skillRunData (copy), u16 (copy), u15 (copy), RunService (ref), RayCast (ref), FXUtil (ref), u19 (copy)
            if not u13:isRunningFlow() then
                return;
            end;

            local u31 = skillRunData.material["翻滚烟尘"];

            if u31 and (u16 and u15) then
                u31.Parent = workspace.Debris;
                local u32 = 0;
                u19["翻滚烟尘"] = RunService.RenderStepped:Connect(function(p33) -- Line: 235
                    -- upvalues: u32 (ref), u15 (ref), u16 (ref), RayCast (ref), u31 (copy), FXUtil (ref)
                    u32 = u32 + p33;

                    if u32 >= 0.03 then
                        u32 = 0;
                        local v34 = u15 and (u15.Parent and u16) and (u16.FloorMaterial ~= "Air" and RayCast.RayCast(u15.Position, u15.Position - Vector3.new(0, 10, 0), "Ground"));

                        if v34 then
                            if v34.Instance and v34.Instance:IsA("BasePart") then
                                for _, descendant in pairs(u31:GetDescendants()) do
                                    if descendant:IsA("ParticleEmitter") then
                                        descendant.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v34.Instance.Color), ColorSequenceKeypoint.new(1, v34.Instance.Color) });
                                    end;
                                end;
                            end;

                            u31:PivotTo(CFrame.new(v34.Position));
                            FXUtil.Emit_Particles_GetDescendants(u31, true);
                        end;
                    end;
                end);
            end;
        end);
    end;

    if v18 == "Forward" then
        task.delay(0.39, function() -- Line: 265
            -- upvalues: u19 (copy)
            if u19["前冲跟随特效"] then
                u19["前冲跟随特效"]:Disconnect();
                u19["前冲跟随特效"] = nil;
            end;
        end);
        task.delay(0.3, function() -- Line: 271
            -- upvalues: skillRunData (copy), FXUtil (ref)
            local v35 = skillRunData.material["前冲跟随特效"];

            if v35 then
                for _, descendant in pairs(v35:GetDescendants()) do
                    if descendant:IsA("Beam") then
                        FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                    end;
                end;
            end;
        end);
        task.delay(0.38, function() -- Line: 282
            -- upvalues: skillRunData (copy)
            local v36 = skillRunData.material["前冲跟随特效"];

            if v36 then
                for _, descendant in pairs(v36:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") then
                        descendant.Enabled = false;
                    end;

                    if descendant:IsA("Trail") then
                        descendant.Enabled = false;
                    end;
                end;
            end;
        end);
        task.delay(0.34, function() -- Line: 297
            -- upvalues: u13 (copy), skillRunData (copy), FXUtil (ref)
            if not u13:isRunningFlow() then
                return;
            end;

            local v37 = u13;
            local v38 = v37.skillInputData and v37.skillInputData.character;
            local v39;

            if v38 then
                v39 = v38:FindFirstChild("HumanoidRootPart");
                v38:FindFirstChildOfClass("Humanoid");
            else
                v38 = nil;
                v39 = nil;
            end;

            local v40 = v38 and (v39 and skillRunData.material["前冲出现特效"]);

            if v40 then
                v40.Parent = workspace.Debris;
                v40:PivotTo(v39:GetPivot());
                FXUtil.Emit_Particles_GetDescendants(v40, true);
            end;

            local v41 = skillRunData.material["前冲跟随特效"];

            if v41 then
                for _, descendant in pairs(v41:GetDescendants()) do
                    if descendant:IsA("ParticleEmitter") and (descendant.Name == "1_Emit" or descendant.Name == "2_Emit") then
                        descendant.Enabled = false;
                        descendant:Clear();
                    end;
                end;
            end;
        end);
        task.delay(0.35, function() -- Line: 321
            -- upvalues: u13 (copy), VisibleMgr (ref)
            if not u13:isRunningFlow() then
                return;
            end;

            local v42 = u13;
            local v43 = v42.skillInputData and v42.skillInputData.character;
            local v44;

            if v43 then
                v44 = v43:FindFirstChild("HumanoidRootPart");
                v43:FindFirstChildOfClass("Humanoid");
            else
                v43 = nil;
                v44 = nil;
            end;

            if v43 and v44 then
                VisibleMgr.UnFadeCharacterModel(v43, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            end;
        end);
    end;
end;

function v2.Client_ExitRolling(p45) -- Line: 331
    -- upvalues: VisibleMgr (copy)
    local v46 = p45.skillInputData and p45.skillInputData.character;

    if v46 then
        v46:FindFirstChild("HumanoidRootPart");
        v46:FindFirstChildOfClass("Humanoid");
    else
        v46 = nil;
    end;

    if v46 then
        VisibleMgr.OpenShade(v46);
    end;

    local runEvent = p45.skillRunData.runEvent;

    if not runEvent then
        return;
    end;

    if runEvent["向后翻滚烟尘"] then
        runEvent["向后翻滚烟尘"]:Disconnect();
        runEvent["向后翻滚烟尘"] = nil;
    end;

    if runEvent["闪现角色黑烟"] then
        runEvent["闪现角色黑烟"]:Disconnect();
        runEvent["闪现角色黑烟"] = nil;
    end;

    if runEvent["翻滚烟尘"] then
        runEvent["翻滚烟尘"]:Disconnect();
        runEvent["翻滚烟尘"] = nil;
    end;
end;

function v2.Server_EnterRolling(p47) -- Line: 355
    -- upvalues: SystemPlrAttr (copy), u1 (copy)
    local characterId = p47.characterId;

    if characterId then
        SystemPlrAttr.WudiPlr(characterId, u1["技能系统"]["闪避"]["无敌时间"]);
    end;
end;

function v2.Server_EnterRecovery(p48) -- Line: 366
end;

function v2.Client_EnterRecovery(p49) -- Line: 370
end;

v2.SoundList = {};
v2.AnimateList = { "RollForward", "RollBackward", "RollLeft", "RollRight" };
v2.ResNameList = { "闪现角色黑烟", "翻滚烟尘", "闪现收缩特效", "闪现释放特效", "前冲出现特效", "前冲跟随特效" };
v2.hitboxConfig = {};
v2.Action = {
    {
        action = "DirectionalRoll",
        allowParallelTracks = false,
        startTime = 0,
        overTime = 1.07,
        animationNameForward = "RollForward",
        animationNameBackward = "RollBackward",
        animationNameLeft = "RollLeft",
        animationNameRight = "RollRight",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action3,
        directionConfig = {
            Forward = {
                overTime = 0.85,
                distance = 100,
                angle = 0,
                moveDuration = 0.3,
                animationSpeed = 1
            },
            Backward = {
                overTime = 0.9,
                distance = 70,
                angle = 180,
                moveDuration = 0.25,
                animationSpeed = 1.7
            },
            Left = {
                overTime = 0.8,
                distance = 70,
                angle = 90,
                moveDuration = 0.3,
                animationSpeed = 1.5
            },
            Right = {
                overTime = 0.8,
                distance = 70,
                angle = -90,
                moveDuration = 0.3,
                animationSpeed = 1.5
            }
        }
    },
    {
        action = "LockMovement",
        allowParallelTracks = false,
        startTime = 0,
        overTime = 0.95,
        speedMultiplier = 0.1,
        saveOriginalSpeed = true,
        directionConfig = {
            Forward = {
                overTime = 0.95,
                speedMultiplier = 0
            },
            Backward = {
                overTime = 0.6,
                speedMultiplier = 0
            },
            Left = {
                overTime = 0.7,
                speedMultiplier = 0
            },
            Right = {
                overTime = 0.7,
                speedMultiplier = 0
            }
        }
    }
};

return v2;