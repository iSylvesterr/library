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
local SoundModule = UtilsSystem.SoundModule;
local u1 = UtilsSystem.SystemGameConfig.Get();
local v2 = {
    skillTotalTime = 1.07,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "Recovery",
    States = {
        Startup = {
            Duration = 0,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Rolling = {
            Duration = 0.7,
            OnEnterClient = "Client_EnterRolling",
            OnEnterServer = "Server_EnterRolling",
            OnExitClient = "Client_ExitRolling",
            OnExitServer = nil
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

local function getDirection(p3) -- Line: 78
    -- upvalues: GetSkillData (copy)
    local v4 = p3.skillInputData and p3.skillInputData.character;

    return not v4 and "Forward" or GetSkillData.getCharacterDirectionStr(v4);
end;

local function getCharacterParts(p5) -- Line: 84
    local v6 = p5.skillInputData and p5.skillInputData.character;

    if v6 then
        return v6, v6:FindFirstChild("HumanoidRootPart"), v6:FindFirstChildOfClass("Humanoid");
    end;

    return nil, nil;
end;

function v2.Client_EnterStartup(p7) -- Line: 93
    local v8 = p7.skillInputData and p7.skillInputData.character;
    local v9;

    if v8 then
        v9 = v8:FindFirstChild("HumanoidRootPart");
        v8:FindFirstChildOfClass("Humanoid");
    else
        v8 = nil;
        v9 = nil;
    end;

    if v8 and v9 then
    end;
end;

function v2.Server_EnterStartup(p10) -- Line: 99
end;

function v2.Client_EnterRolling(u11) -- Line: 104
    -- upvalues: GetSkillData (copy), SoundModule (copy), FXUtil (copy), VisibleMgr (copy), RunService (copy), RayCast (copy)
    local u12 = u11.skillInputData and u11.skillInputData.character;
    local u13, u14;

    if u12 then
        u13 = u12:FindFirstChild("HumanoidRootPart");
        u14 = u12:FindFirstChildOfClass("Humanoid");
    else
        u12 = nil;
        u13 = nil;
        u14 = nil;
    end;

    if not (u12 and u13) then
        return;
    end;

    local v15 = u11.skillInputData and u11.skillInputData.character;
    local v16 = not v15 and "Forward" or GetSkillData.getCharacterDirectionStr(v15);
    local skillRunData = u11.skillRunData;
    local u17 = skillRunData.runEvent or {};

    if v16 == "Forward" then
        SoundModule:PlaySoundLocal({
            SoundName = "技能_向前闪避-小光圈",
            Is2D = false,
            PlayPosition = u13.Position
        });
        task.delay(0.05, function() -- Line: 120
            -- upvalues: u11 (copy), u13 (copy), FXUtil (ref), u12 (copy), VisibleMgr (ref), SoundModule (ref)
            local v18 = u11.skillRunData.material["闪现收缩特效"];

            if v18 then
                v18.Parent = workspace.Debris;
                v18:PivotTo(u13:GetPivot():ToWorldSpace(CFrame.new(0, 0, 1)));
                FXUtil.Emit_Particles_GetDescendants(v18, true);
            end;

            u11.skillRunData.FadeCharacter = u12;
            VisibleMgr.FadeCharacterModel(u12, 1, 0.08, Enum.EasingStyle.Quart, Enum.EasingDirection.In);
            task.delay(0.1, function() -- Line: 131
                -- upvalues: u13 (ref), SoundModule (ref)
                if u13 then
                    SoundModule:PlaySoundLocal({
                        SoundName = "技能_向前闪避-大光圈",
                        Is2D = false,
                        PlayPosition = u13.Position
                    });
                end;
            end);
            task.delay(0.17, function() -- Line: 141
                -- upvalues: u11 (ref), FXUtil (ref)
                if not u11:isRunningFlow() then
                    return;
                end;

                local v19 = u11;
                local v20 = v19.skillInputData and v19.skillInputData.character;
                local v21;

                if v20 then
                    v21 = v20:FindFirstChild("HumanoidRootPart");
                    v20:FindFirstChildOfClass("Humanoid");
                else
                    v20 = nil;
                    v21 = nil;
                end;

                local v22 = v20 and (v21 and u11.skillRunData.material["闪现释放特效"]);

                if v22 then
                    v22.Parent = workspace.Debris;
                    v22:PivotTo(v21:GetPivot():ToWorldSpace(CFrame.new(0, 0, -1)));
                    FXUtil.Emit_Particles_GetDescendants(v22, true);
                end;
            end);
            task.delay(0.25, function() -- Line: 156
                -- upvalues: u11 (ref), VisibleMgr (ref)
                local FadeCharacter = u11.skillRunData.FadeCharacter;

                if FadeCharacter then
                    VisibleMgr.UnFadeCharacterModel(FadeCharacter, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    u11.skillRunData.FadeCharacter = nil;
                end;
            end);
        end);
    end;

    if v16 == "Backward" then
        SoundModule:PlaySoundLocal({
            SoundName = "技能_左后右闪避",
            Is2D = false,
            PlayPosition = u13.Position
        });
        task.delay(0.12, function() -- Line: 174
            -- upvalues: u11 (copy), skillRunData (copy), u14 (copy), u13 (copy), RunService (ref), RayCast (ref), FXUtil (ref), u17 (copy)
            if not u11:isRunningFlow() then
                return;
            end;

            local u23 = skillRunData.material["翻滚烟尘"];

            if u23 and (u14 and u13) then
                u23.Parent = workspace.Debris;
                local u24 = 0;
                u17["向后翻滚烟尘"] = RunService.RenderStepped:Connect(function(p25) -- Line: 181
                    -- upvalues: u24 (ref), u13 (ref), u14 (ref), RayCast (ref), u23 (copy), FXUtil (ref)
                    u24 = u24 + p25;

                    if u24 >= 0.03 then
                        u24 = 0;
                        local v26 = u13 and (u13.Parent and u14) and (u14.FloorMaterial ~= "Air" and RayCast.RayCast(u13.Position, u13.Position - Vector3.new(0, 10, 0), "Ground"));

                        if v26 then
                            if v26.Instance and v26.Instance:IsA("BasePart") then
                                for _, descendant in pairs(u23:GetDescendants()) do
                                    if descendant:IsA("ParticleEmitter") then
                                        descendant.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, v26.Instance.Color), ColorSequenceKeypoint.new(1, v26.Instance.Color) });
                                    end;
                                end;
                            end;

                            u23:PivotTo(CFrame.new(v26.Position));
                            FXUtil.Emit_Particles_GetDescendants(u23, true);
                        end;
                    end;
                end);
            end;
        end);
        task.delay(0.35, function() -- Line: 207
            -- upvalues: u17 (copy)
            if u17["向后翻滚烟尘"] then
                u17["向后翻滚烟尘"]:Disconnect();
                u17["向后翻滚烟尘"] = nil;
            end;
        end);
    end;

    if v16 == "Left" or v16 == "Right" then
        SoundModule:PlaySoundLocal({
            SoundName = "技能_左后右闪避",
            Is2D = false,
            PlayPosition = u13.Position
        });
        task.delay(0.16, function() -- Line: 225
            -- upvalues: u11 (copy), skillRunData (copy), u14 (copy), u13 (copy), RunService (ref), RayCast (ref), FXUtil (ref), u17 (copy)
            if not u11:isRunningFlow() then
                return;
            end;

            local u27 = skillRunData.material["翻滚烟尘"];

            if u27 and (u14 and u13) then
                u27.Parent = workspace.Debris;
                local u28 = 0;
                u17["翻滚烟尘"] = RunService.RenderStepped:Connect(function(p29) -- Line: 232
                    -- upvalues: u28 (ref), u13 (ref), u14 (ref), RayCast (ref), u27 (copy), FXUtil (ref)
                    u28 = u28 + p29;

                    if u28 >= 0.03 then
                        u28 = 0;
                        local v30 = u13 and (u13.Parent and u14) and (u14.FloorMaterial ~= "Air" and RayCast.RayCast(u13.Position, u13.Position - Vector3.new(0, 10, 0), "Ground"));

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
    end;
end;

function v2.Client_ExitRolling(p31) -- Line: 261
    local runEvent = p31.skillRunData.runEvent;

    if not runEvent then
        return;
    end;

    if runEvent["向后翻滚烟尘"] then
        runEvent["向后翻滚烟尘"]:Disconnect();
        runEvent["向后翻滚烟尘"] = nil;
    end;

    if runEvent["翻滚烟尘"] then
        runEvent["翻滚烟尘"]:Disconnect();
        runEvent["翻滚烟尘"] = nil;
    end;
end;

function v2.Server_EnterRolling(p32) -- Line: 275
    -- upvalues: UtilsSystem (copy), u1 (copy)
    local SystemPlrAttr = UtilsSystem.SystemPlrAttr;

    if p32 and (p32.characterType and p32.characterType == "Player") then
        SystemPlrAttr.WudiPlr(p32.characterId, u1["技能系统"]["闪避"]["无敌时间"]);
    end;
end;

function v2.Server_EnterRecovery(p33) -- Line: 285
end;

function v2.Client_EnterRecovery(p34) -- Line: 289
end;

function v2.onEnd(p35) -- Line: 293
    -- upvalues: VisibleMgr (copy)
    local FadeCharacter = p35.skillRunData.FadeCharacter;

    if FadeCharacter then
        VisibleMgr.UnFadeCharacterModel(FadeCharacter, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        p35.skillRunData.FadeCharacter = nil;
    end;
end;

v2.SoundList = { "技能_向前闪避-大光圈", "技能_向前闪避-小光圈", "技能_左后右闪避" };
v2.AnimateList = { "RollForward", "RollBackward", "RollLeft", "RollRight" };
v2.ResNameList = { "翻滚烟尘", "闪现收缩特效", "闪现释放特效" };
v2.hitboxConfig = {};
v2.Action = {
    {
        action = "DashStyleRoll",
        allowParallelTracks = false,
        startTime = 0,
        overTime = 1.7,
        animationNameForward = "RollForward",
        animationNameBackward = "RollBackward",
        animationNameLeft = "RollLeft",
        animationNameRight = "RollRight",
        animationSpeed = 1,
        animationFadeInTime = 0.25,
        animationFadeTime = 0.25,
        earlyEndBoostDuration = 0.22,
        earlyEndBoostPeakSpeed = 0,
        animationPriority = Enum.AnimationPriority.Action3,
        earlyEndBoostEasingStyle = Enum.EasingStyle.Quad,
        earlyEndBoostEasingDirection = Enum.EasingDirection.Out,
        directionConfig = {
            Forward = {
                overTime = 1.7,
                tweenDuration = 0.4,
                planeSpeed = 152.4,
                vectorEndFactor = 0.18,
                animationSpeed = 1,
                animationFadeInTime = 0.05,
                animationFadeTime = 0.25,
                moveInterruptWindowOffset = 0.5,
                moveInterruptWindowTime = 0.8
            },
            Backward = {
                overTime = 0.9,
                tweenDuration = 0.4,
                planeSpeed = 102.4,
                vectorEndFactor = 0.05,
                animationSpeed = 1.3,
                animationFadeInTime = 0.05,
                animationFadeTime = 0.25,
                moveInterruptWindowOffset = 0.45,
                moveInterruptWindowTime = 0.3
            },
            Left = {
                overTime = 1,
                tweenDuration = 0.7,
                planeSpeed = 102.4,
                vectorEndFactor = 0.05,
                animationSpeed = 1.3,
                animationFadeInTime = 0.05,
                animationFadeTime = 0.25,
                moveInterruptWindowOffset = 0.6,
                moveInterruptWindowTime = 0.3
            },
            Right = {
                overTime = 1,
                tweenDuration = 0.7,
                planeSpeed = 102.4,
                vectorEndFactor = 0.05,
                animationSpeed = 1.3,
                animationFadeInTime = 0.05,
                animationFadeTime = 0.25,
                moveInterruptWindowOffset = 0.6,
                moveInterruptWindowTime = 0.3
            }
        }
    }
};

return v2;