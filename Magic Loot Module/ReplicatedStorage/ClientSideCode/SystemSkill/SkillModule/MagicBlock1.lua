-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local SystemPlrAttr = UtilsSystem.SystemPlrAttr;
local GetData = UtilsSystem.GetData;
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local SoundModule = UtilsSystem.SoundModule;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local u3 = {
    SustainHoldDelaysPhase1Complete = true,
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None,
    skillDistanceLimit = 64,
    MagicDefenseConfig = {
        perfectDefenseDuration = 0.3,
        defensePlaceholderDuration = 600,
        perfectBlockChargeCount = 1,
        normalBlockChargeCount = 999999
    },

    CanReleaseControl = function(p1) -- Line: 43, Name: CanReleaseControl
        local skillRunData = p1.skillRunData;
        local v2 = skillRunData and skillRunData.State and skillRunData.State.current;

        return (v2 == "Recovery" or v2 == "Finished") and true or v2 == "Interrupted";
    end
};

local function clearDodgeInvulnIfBlockEndedEarly(p4) -- Line: 49
    -- upvalues: GetData (copy), SystemPlrAttr (copy)
    local skillRunData = p4.skillRunData;

    if not skillRunData then
        return;
    end;

    local magicBlockDefenseEndAt = skillRunData.magicBlockDefenseEndAt;

    if type(magicBlockDefenseEndAt) ~= "number" then
        return;
    end;

    skillRunData.magicBlockDefenseEndAt = nil;

    if magicBlockDefenseEndAt <= workspace:GetServerTimeNow() + 0.02 then
        return;
    end;

    local v5 = GetData.GetPlayerByID(p4.characterId);

    if not v5 then
        return;
    end;

    SystemPlrAttr.ClearMagicShieldBlockBudget(v5);
    local v6 = v5:FindFirstChild("闪避无敌");

    if v6 and v6:IsA("NumberValue") then
        v6.Value = 0;
    end;
end;

local function emitParticle(p7, p8) -- Line: 74
    local v9 = p7.skillRunData.material[p8];

    if v9 then
        for _, descendant in pairs(v9:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant:Emit(1);
            end;
        end;
    end;
end;

local function clearParticle(p10, p11) -- Line: 85
    local v12 = p10.skillRunData.material[p11];

    if v12 then
        for _, descendant in pairs(v12:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant:Clear();
            end;
        end;
    end;
end;

local function showTrail(p13) -- Line: 99
    -- upvalues: SkillCommon (copy), RunService (copy)
    local character = p13.skillInputData.character;

    if not character then
        return;
    end;

    local u14 = SkillCommon.resolveWandTipFromCharacter(character);

    if not u14 then
        return;
    end;

    local u15 = p13.skillRunData.material and p13.skillRunData.material["普攻魔杖尾迹"];

    if u15 then
        for _, descendant in pairs(u15:GetDescendants()) do
            if descendant:IsA("Trail") then
                descendant.Enabled = true;
            elseif descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u15.Parent = workspace.Debris;
        p13:BindStateConn("Startup", RunService.RenderStepped:Connect(function() -- Line: 114
            -- upvalues: u14 (copy), u15 (copy)
            if u14.Parent and u15.Parent then
                u15:PivotTo(u14:GetPivot());
            end;
        end));
    end;
end;

local function hideTrail(p16) -- Line: 123
    p16:CleanupStateConns("Startup");
    local v17 = p16.skillRunData.material and p16.skillRunData.material["普攻魔杖尾迹"];

    if v17 then
        for _, descendant in pairs(v17:GetDescendants()) do
            if descendant:IsA("Trail") then
                descendant.Enabled = false;
            elseif descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;
end;

local function PlayLoopSound(p18) -- Line: 135
    -- upvalues: SoundModule (copy)
    local character = p18.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    SoundModule:PlaySoundLocal({
        SoundName = "音效-格挡-无互动loop",
        Is2D = false,
        PlayPosition = HumanoidRootPart.Position,
        SoundTag = p18.skillInputData.skillCastId
    });
end;

local function StopLoopSound(p19) -- Line: 149
    -- upvalues: SoundModule (copy)
    if p19.skillInputData.skillCastId then
        SoundModule:StopSoundLocal({
            SoundName = "音效-格挡-无互动loop",
            SoundTag = p19.skillInputData.skillCastId
        });
    end;
end;

u3.InitialState = "Startup";
u3.ControlOpenState = nil;
u3.States = {
    Startup = {
        Duration = 0.3,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup",
        OnExitServer = nil
    },
    ActiveBlock = {
        Duration = -1,
        OnEnterClient = "Client_EnterActiveBlock",
        OnEnterServer = "Server_EnterActiveBlock",
        OnExitClient = "Client_ExitActiveBlock",
        OnExitServer = "Server_ExitActiveBlock"
    },
    BackSwing = {
        Duration = 0.2,
        OnEnterClient = nil,
        OnEnterServer = nil,
        OnExitClient = nil,
        OnExitServer = nil
    },
    PerfectBackSwing = {
        Duration = 0.8,
        OnEnterClient = "Client_EnterPerfectBackSwing",
        OnEnterServer = "Server_EnterPerfectBackSwing",
        OnExitClient = "Client_ExitPerfectBackSwing",
        OnExitServer = "Server_ExitPerfectBackSwing"
    },
    Recovery = {
        Duration = 1,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery",
        OnExitClient = "Client_ExitRecovery",
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
};
u3.Transitions = {
    {
        From = "Startup",
        To = "ActiveBlock",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Startup",
        To = "PerfectBackSwing",
        Event = SkillEventConst.PerfectBlock
    },
    {
        From = "ActiveBlock",
        To = "BackSwing",
        Event = SkillEventConst.SkillButtonRelease
    },
    {
        From = "ActiveBlock",
        To = "PerfectBackSwing",
        Event = SkillEventConst.PerfectBlock
    },
    {
        From = "BackSwing",
        To = "Recovery",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "PerfectBackSwing",
        To = "Finished",
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
        From = "ActiveBlock",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "BackSwing",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "PerfectBackSwing",
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
        From = "ActiveBlock",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "BackSwing",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "PerfectBackSwing",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function BackSwingClient(p20) -- Line: 231
    -- upvalues: clearParticle (copy), SoundModule (copy), FXUtil (copy), RunService (copy)
    local character = p20.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    clearParticle(p20, "魔法盾持续");

    if p20.skillInputData.skillCastId then
        SoundModule:StopSoundLocal({
            SoundName = "音效-格挡-无互动loop",
            SoundTag = p20.skillInputData.skillCastId
        });
    end;

    local u21 = p20.skillRunData.material["魔法盾消失"];
    u21:PivotTo(HumanoidRootPart:GetPivot());
    u21.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants_NoDelay(u21, true);
    p20.skillRunData.runEvent["护盾消失跟随"] = RunService.Heartbeat:Connect(function() -- Line: 243
        -- upvalues: HumanoidRootPart (copy), u21 (copy)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            u21:PivotTo(HumanoidRootPart:GetPivot());
        end;
    end);
end;

function u3.Client_EnterStartup(u22) -- Line: 251
    -- upvalues: SkillCommon (copy), RunService (copy), FXUtil (copy), PlayLoopSound (copy), showTrail (copy)
    local character = u22.skillInputData.character;

    if not character then
        return;
    end;

    if not SkillCommon.resolveWandTipFromCharacter(character) then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-格挡-施法", HumanoidRootPart:GetPivot().Position);
    local u23 = u22.skillRunData.material["魔法盾出现"];
    u23:PivotTo(HumanoidRootPart:GetPivot());
    u23.Parent = workspace.Debris;
    local u24 = false;
    local u25 = 0;
    u22.skillRunData.runEvent["护盾出现粒子"] = RunService.Heartbeat:Connect(function(p26) -- Line: 267
        -- upvalues: u25 (ref), u24 (ref), FXUtil (ref), u23 (copy), u22 (copy), PlayLoopSound (ref)
        u25 = u25 + p26;

        if u25 >= 0.1 and not u24 then
            u24 = true;
            FXUtil.Emit_Particles_GetDescendants_NoDelay(u23, true);

            if u22.skillRunData.runEvent and u22.skillRunData.runEvent["护盾出现粒子"] then
                u22.skillRunData.runEvent["护盾出现粒子"]:Disconnect();
                u22.skillRunData.runEvent["护盾出现粒子"] = nil;
            end;

            PlayLoopSound(u22);
        end;
    end);
    u22.skillRunData.runEvent["护盾出现跟随"] = RunService.Heartbeat:Connect(function(p27) -- Line: 283
        -- upvalues: HumanoidRootPart (copy), u23 (copy)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            u23:PivotTo(HumanoidRootPart:GetPivot());
        end;
    end);
    showTrail(u22);
end;

function u3.Client_ExitStartup(p28) -- Line: 294
    -- upvalues: hideTrail (copy)
    hideTrail(p28);
end;

function u3.Server_EnterStartup(p29) -- Line: 298
    -- upvalues: UtilsSystem (copy), u3 (copy), SystemPlrAttr (copy)
    local _ = UtilsSystem.SystemSummon;
    local character = p29.skillInputData.character;

    if character then
        game.Players:GetPlayerFromCharacter(character);
    end;

    local MagicDefenseConfig = u3.MagicDefenseConfig;
    local defensePlaceholderDuration = MagicDefenseConfig.defensePlaceholderDuration;
    local skillRunData = p29.skillRunData;

    if skillRunData then
        skillRunData.magicBlockDefenseEndAt = workspace:GetServerTimeNow() + defensePlaceholderDuration;
    end;

    SystemPlrAttr.DefensePlr(p29.characterId, defensePlaceholderDuration);
    SystemPlrAttr.PerfectDefensePlr(p29.characterId, MagicDefenseConfig.perfectDefenseDuration);
    SystemPlrAttr.SetMagicShieldBlockBudget(p29.characterId, MagicDefenseConfig.perfectBlockChargeCount, MagicDefenseConfig.normalBlockChargeCount);
end;

function u3.Client_EnterActiveBlock(u30) -- Line: 327
    -- upvalues: clearParticle (copy), FXUtil (copy), RunService (copy)
    local character = u30.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    clearParticle(u30, "魔法盾出现");
    local u31 = u30.skillRunData.material["魔法盾持续"];
    u31:PivotTo(HumanoidRootPart:GetPivot());
    u31.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants_NoDelay(u31, true);
    local u32 = 0;
    u30.skillRunData.runEvent["护盾持续跟随"] = RunService.Heartbeat:Connect(function(p33) -- Line: 340
        -- upvalues: u32 (ref), HumanoidRootPart (copy), u31 (copy), clearParticle (ref), u30 (copy), FXUtil (ref)
        u32 = u32 + p33;

        if HumanoidRootPart and HumanoidRootPart.Parent then
            u31:PivotTo(HumanoidRootPart:GetPivot());
        end;

        if u32 > 8 then
            u32 = 0;
            clearParticle(u30, "魔法盾持续");
            FXUtil.Emit_Particles_GetDescendants_NoDelay(u31, true);
        end;
    end);
end;

function u3.Client_ExitActiveBlock(p34) -- Line: 356
end;

function u3.Server_EnterActiveBlock(p35) -- Line: 360
end;

function u3.Server_ExitActiveBlock(p36) -- Line: 364
    -- upvalues: GetData (copy), SystemPlrAttr (copy), clearDodgeInvulnIfBlockEndedEarly (copy)
    local v37 = GetData.GetPlayerByID(p36.characterId);

    if v37 then
        SystemPlrAttr.ClearMagicShieldBlockBudget(v37);
    end;

    clearDodgeInvulnIfBlockEndedEarly(p36);
    local v38 = GetData.GetPlayerByID(p36.characterId);

    if v38 then
        local v39 = v38:FindFirstChild("完美弹反防御");

        if v39 and v39:IsA("NumberValue") then
            v39:Destroy();
        end;

        local v40 = v38:FindFirstChild("普通防御");

        if v40 and v40:IsA("NumberValue") then
            v40:Destroy();
        end;
    end;
end;

function u3.Client_ExitBackSwing(p41) -- Line: 385
end;

function u3.Server_EnterPerfectBackSwing(u42) -- Line: 391
    task.delay(0.3, function() -- Line: 392
        -- upvalues: u42 (copy)
        local u43 = u42.hitbox[1];

        if not u43 then
            return;
        end;

        local character = u42.skillInputData.character;

        if not character then
            return;
        end;

        local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

        if not HumanoidRootPart then
            return;
        end;

        local hitbox = u43.hitbox;

        if hitbox then
            hitbox:PivotTo(HumanoidRootPart:GetPivot());
            hitbox.Size = Vector3.new(10, 10, 10);
        end;

        local skillRunData = u42.skillRunData;
        local v44;

        if skillRunData then
            v44 = skillRunData.perfectParryAttackerModel;
        else
            v44 = skillRunData;
        end;

        if v44 and v44:IsA("Model") then
            u43.parryInjectAttackerModel = v44;
            skillRunData.perfectParryAttackerModel = nil;
        end;

        u43:start();
        task.delay(0.2, function() -- Line: 414
            -- upvalues: u43 (copy)
            if u43 then
                u43:stop();
            end;
        end);
    end);
end;

function u3.Server_ExitPerfectBackSwing(p45) -- Line: 424
end;

function u3.Client_EnterPerfectBackSwing(u46) -- Line: 429
    -- upvalues: SoundModule (copy), clearParticle (copy), FXUtil (copy), SkillCommon (copy)
    local character = u46.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if u46.skillRunData.runEvent and u46.skillRunData.runEvent["护盾出现粒子"] then
        u46.skillRunData.runEvent["护盾出现粒子"]:Disconnect();
        u46.skillRunData.runEvent["护盾出现粒子"] = nil;
    end;

    if u46.skillInputData.skillCastId then
        SoundModule:StopSoundLocal({
            SoundName = "音效-格挡-无互动loop",
            SoundTag = u46.skillInputData.skillCastId
        });
    end;

    clearParticle(u46, "魔法盾出现");
    clearParticle(u46, "魔法盾持续");
    local v47 = u46.skillRunData.material["魔法盾持续"];
    v47:PivotTo(HumanoidRootPart:GetPivot());
    v47.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants_NoDelay(v47, true);
    task.delay(0.1, function() -- Line: 453
        -- upvalues: u46 (copy), HumanoidRootPart (copy), FXUtil (ref), clearParticle (ref), SkillCommon (ref)
        local v48 = u46.skillRunData.material["魔法粒子吸收效果"];
        v48.Parent = workspace.Debris;
        v48:PivotTo(HumanoidRootPart:GetPivot());
        FXUtil.Emit_Particles_GetDescendants_NoDelay(v48, true);
        clearParticle(u46, "魔法盾持续");
        local v49 = u46.skillRunData.material["魔法护盾吸收"];
        v49.Parent = workspace.Debris;
        v49:PivotTo(HumanoidRootPart:GetPivot());
        FXUtil.Emit_Particles_GetDescendants_NoDelay(v49, true);
        SkillCommon.playSoundLocal3D("音效-完美格挡受击", HumanoidRootPart:GetPivot().Position);
    end);
    task.delay(0.395, function() -- Line: 470
        -- upvalues: u46 (copy), HumanoidRootPart (copy), FXUtil (ref)
        local v50 = u46.skillRunData.material["魔法护盾震荡波"];
        v50.Parent = workspace.Debris;
        v50:PivotTo(HumanoidRootPart:GetPivot());
        FXUtil.Emit_Particles_GetDescendants_NoDelay(v50, true);
    end);
end;

function u3.Client_ExitPerfectBackSwing(p51) -- Line: 485
    -- upvalues: u3 (copy)
    u3.onEnd(p51);
end;

function u3.Server_EnterRecovery(p52) -- Line: 492
end;

function u3.Client_EnterRecovery(p53) -- Line: 496
    -- upvalues: BackSwingClient (copy)
    BackSwingClient(p53);
end;

function u3.Client_ExitRecovery(p54) -- Line: 503
    -- upvalues: u3 (copy)
    u3.onEnd(p54);
end;

function u3.onEnd(p55) -- Line: 510
    -- upvalues: hideTrail (copy), SoundModule (copy), clearParticle (copy)
    hideTrail(p55);

    if p55.skillInputData.skillCastId then
        SoundModule:StopSoundLocal({
            SoundName = "音效-格挡-无互动loop",
            SoundTag = p55.skillInputData.skillCastId
        });
    end;

    if p55.skillRunData.runEvent and p55.skillRunData.runEvent["护盾出现跟随"] then
        p55.skillRunData.runEvent["护盾出现跟随"]:Disconnect();
        p55.skillRunData.runEvent["护盾出现跟随"] = nil;
    end;

    if p55.skillRunData.runEvent and p55.skillRunData.runEvent["护盾持续跟随"] then
        p55.skillRunData.runEvent["护盾持续跟随"]:Disconnect();
        p55.skillRunData.runEvent["护盾持续跟随"] = nil;
    end;

    if p55.skillRunData.runEvent and p55.skillRunData.runEvent["护盾消失跟随"] then
        p55.skillRunData.runEvent["护盾消失跟随"]:Disconnect();
        p55.skillRunData.runEvent["护盾消失跟随"] = nil;
    end;

    clearParticle(p55, "魔法盾持续");
end;

function u3.onEndServer(p56) -- Line: 537
    -- upvalues: u3 (copy)
    u3.Server_ExitActiveBlock(p56);
end;

u3.SoundList = { "音效-完美格挡受击", "音效-普通格挡受击", "音效-格挡-施法", "音效-格挡-无互动loop" };
u3.AnimateList = { "魔法防御前摇", "魔法防御持续", "魔法防御后摇", "技能释放动作1" };
u3.ResNameList = { "魔法盾出现", "魔法盾持续", "魔法盾消失", "魔法护盾震荡波", "完美弹反特效", "完美防御反馈", "普攻魔杖尾迹", "魔法粒子吸收效果", "魔法护盾吸收" };
u3.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
u3.StateActions = {
    Startup = {
        {
            action = "Animation",
            startTime = 0,
            overTime = 0.5,
            animationName = "魔法防御前摇",
            animationSpeed = 1,
            animationFadeTime = 0.1,
            animationLoop = false,
            animationPriority = Enum.AnimationPriority.Action3
        },
        {
            action = "LookAt",
            startTime = 0,
            overTime = -1,
            speedType = "MOVE_SPEED_LOCK"
        }
    },
    ActiveBlock = {
        {
            action = "Animation",
            startTime = 0,
            overTime = -1,
            animationName = "魔法防御持续",
            animationSpeed = 1,
            animationFadeTime = 0.1,
            animationLoop = true,
            animationPriority = Enum.AnimationPriority.Action3
        },
        {
            action = "LookAt",
            startTime = 0,
            overTime = -1,
            speedType = "MOVE_SPEED_LOCK"
        }
    },
    BackSwing = {
        {
            action = "Animation",
            startTime = 0,
            overTime = 0.2,
            animationName = "魔法防御持续",
            animationSpeed = 1,
            animationFadeTime = 0.1,
            animationLoop = true,
            animationPriority = Enum.AnimationPriority.Action3
        }
    },
    PerfectBackSwing = {
        {
            action = "Animation",
            startTime = 0,
            overTime = 1,
            animationName = "技能释放动作1",
            animationSpeed = 2,
            animationFadeTime = 0.1,
            animationLoop = true,
            animationPriority = Enum.AnimationPriority.Action3
        }
    },
    Recovery = {
        {
            action = "Animation",
            startTime = 0,
            overTime = 0.33,
            animationName = "魔法防御后摇",
            animationSpeed = 1,
            animationFadeTime = 0.1,
            animationLoop = false,
            animationPriority = Enum.AnimationPriority.Action3
        }
    }
};
u3.Action = {};

return u3;