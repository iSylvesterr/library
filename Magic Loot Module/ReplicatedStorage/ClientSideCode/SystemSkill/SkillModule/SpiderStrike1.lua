-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SoundModule = UtilsSystem.SoundModule;
local RunService = UtilsSystem.RunService;
local u1 = {
    clawFxFollow = "蜘蛛爪击特效跟随",
    hitboxFollow = "蜘蛛爪击命中盒跟随",
    beamReveal = "蜘蛛爪击Beam揭示"
};
local v2 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = UtilsSystem.EnumMgr.ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "Swing",
    States = {
        Startup = {
            Duration = 0.43,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Swing = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterSwing",
            OnEnterServer = "Server_EnterSwing",
            OnExitClient = "Client_ExitSwing",
            OnExitServer = "Server_ExitSwing"
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
            To = "Swing",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Swing",
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
            From = "Swing",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Swing",
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

local function _getSkillScale(p3) -- Line: 116
    -- upvalues: SkillCommon (copy)
    return SkillCommon.npcSummonBodySkillScale(p3);
end;

local function _getHrp(p4) -- Line: 120
    local v5 = p4.skillInputData and p4.skillInputData.character;

    if v5 then
        return v5:FindFirstChild("HumanoidRootPart");
    end;

    return nil;
end;

local function _casterPivotCF(p6) -- Line: 128
    return p6:GetPivot();
end;

local function _hitboxPivotCF(p7, p8) -- Line: 132
    return p7:GetPivot():ToWorldSpace(CFrame.new(0, 0, p8 * -3));
end;

local function _disconnectBeamReveal(p9) -- Line: 136
    local v10 = p9 and p9.runEvent and p9.runEvent["蜘蛛爪击Beam揭示"];

    if v10 then
        v10:Disconnect();
        p9.runEvent["蜘蛛爪击Beam揭示"] = nil;
    end;
end;

local function _playClawFx(u11, p12) -- Line: 144
    -- upvalues: FXUtil (copy), u1 (copy)
    local u13 = {};

    for _, descendant in u11:GetDescendants() do
        if descendant:IsA("Beam") then
            table.insert(u13, descendant);
        end;
    end;

    task.delay(0.1, function() -- Line: 152
        -- upvalues: u11 (copy), FXUtil (ref)
        if u11.Parent then
            FXUtil.Emit_Particles_GetDescendants(u11, true);
        end;
    end);
    local v14 = p12 and p12.runEvent and p12.runEvent[u1.beamReveal];

    if v14 then
        v14:Disconnect();
        p12.runEvent[u1.beamReveal] = nil;
    end;

    if #u13 > 0 then
        p12.runEvent["蜘蛛爪击Beam揭示"] = FXUtil.Beam_Reveal_From_Left(u13, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        task.delay(0.15, function() -- Line: 166
            -- upvalues: u13 (copy), FXUtil (ref)
            for _, v in u13 do
                if v.Parent then
                    FXUtil.Beam_Fade_To_Transparent_Then_Disable(v, 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                end;
            end;
        end);
    end;
end;

function v2.Client_EnterStartup(p15) -- Line: 185
end;

function v2.Server_EnterStartup(p16) -- Line: 188
    -- upvalues: SkillCommon (copy)
    local v17 = p16.hitbox[1];

    if not (v17 and v17.hitbox) then
        return;
    end;

    local v18 = SkillCommon.npcSummonBodySkillScale(p16);
    v17.hitbox.Size = Vector3.new(9, 9, v18 * 9);
end;

function v2.Client_EnterSwing(p19) -- Line: 201
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), _casterPivotCF (copy), SoundModule (copy), _playClawFx (copy), RunService (copy)
    local skillRunData = p19.skillRunData;
    local u20 = skillRunData.material["蜘蛛爪击特效"];

    if not u20 then
        return;
    end;

    local v21 = p19.skillInputData and p19.skillInputData.character;
    local u22;

    if v21 then
        u22 = v21:FindFirstChild("HumanoidRootPart");
    else
        u22 = nil;
    end;

    if not u22 then
        return;
    end;

    local v23 = SkillCommon.npcSummonBodySkillScale(p19);
    VisibleMgr.UnQueryAll(u20);

    if u20:IsA("Model") then
        u20:ScaleTo(v23);
    end;

    u20:PivotTo(_casterPivotCF(u22));
    u20.Parent = workspace.Debris;
    SoundModule:PlaySoundLocal({
        SoundName = "技能-熊撕裂攻击",
        Is2D = false,
        PlayPosition = u22.Position
    });
    _playClawFx(u20, skillRunData);
    skillRunData.runEvent["蜘蛛爪击特效跟随"] = RunService.Heartbeat:Connect(function() -- Line: 229
        -- upvalues: u22 (copy), u20 (copy), _casterPivotCF (ref)
        if u22.Parent then
            u20:PivotTo(_casterPivotCF(u22));
        end;
    end);
end;

function v2.Client_ExitSwing(p24) -- Line: 236
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p24.skillRunData, { "蜘蛛爪击特效跟随", "蜘蛛爪击Beam揭示" });
end;

function v2.Server_EnterSwing(p25) -- Line: 241
    -- upvalues: SkillCommon (copy), RunService (copy), _hitboxPivotCF (copy)
    local u26 = p25.hitbox[1];
    local v27 = p25.skillInputData and p25.skillInputData.character;
    local u28;

    if v27 then
        u28 = v27:FindFirstChild("HumanoidRootPart");
    else
        u28 = nil;
    end;

    if not (u26 and u28) then
        return;
    end;

    u26:start();
    local u29 = SkillCommon.npcSummonBodySkillScale(p25);
    p25.skillRunData.runEvent["蜘蛛爪击命中盒跟随"] = RunService.Heartbeat:Connect(function() -- Line: 255
        -- upvalues: u28 (copy), u26 (copy), _hitboxPivotCF (ref), u29 (copy)
        if u28.Parent then
            u26.hitbox:PivotTo(_hitboxPivotCF(u28, u29));
        end;
    end);
end;

function v2.Server_ExitSwing(p30) -- Line: 262
    -- upvalues: SkillCommon (copy)
    local v31 = p30.hitbox[1];

    if v31 and v31.isActive then
        v31:stop();
    end;

    SkillCommon.disconnectRunEventKeys(p30.skillRunData, { "蜘蛛爪击命中盒跟随" });
end;

function v2.Server_EnterRecovery(p32) -- Line: 274
    p32:releaseControl();
end;

function v2.Client_EnterRecovery(p33) -- Line: 278
end;

v2.SoundList = { "技能-熊撕裂攻击" };
v2.AnimateList = { "蜘蛛爪击" };
v2.ResNameList = { "蜘蛛爪击特效" };
v2.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v2.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1,
        animationName = "蜘蛛爪击",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v2;