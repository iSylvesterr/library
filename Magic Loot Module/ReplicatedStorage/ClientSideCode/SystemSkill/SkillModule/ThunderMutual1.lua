-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SkillBuffUtil = UtilsSystem.SkillBuffUtil;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SoundModule = UtilsSystem.SoundModule;
local TipsModule = UtilsSystem.TipsModule;
local GetData = UtilsSystem.GetData;
local SkillBuffRuntimeTag = UtilsSystem.EnumMgr.SkillBuffRuntimeTag;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = SkillBuffUtil.GetDurSecForBuffRuntimeTag(SkillBuffRuntimeTag.ThunderMutualDmg);
local u2 = math.max(v1, 0.01);
local v3 = {
    skillTotalTime = -1,
    visualFadeoutTime = 1.9,
    skillElementType = ElementTp.Thunder,
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
            Duration = u2
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

local function emitAndEnableMutualVfxParts(p4) -- Line: 85
    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") and string.find(descendant.Name, "Emit和Enable", 1, true) then
            for _, descendant2 in descendant:GetDescendants() do
                if descendant2:IsA("ParticleEmitter") then
                    descendant2.Enabled = true;
                    descendant2:Emit(descendant2:GetAttribute("EmitCount") or 1);
                end;
            end;
        end;
    end;
end;

local function disableAllParticles(p5) -- Line: 99
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;
    end;
end;

local function disconnectMutualVfxFollow(p6) -- Line: 107
    if not (p6 and p6.runEvent) then
        return;
    end;

    local v7 = p6.runEvent["电流相生VFX跟随"];

    if v7 then
        v7:Disconnect();
        p6.runEvent["电流相生VFX跟随"] = nil;
    end;
end;

local function stopThunderMutualLoopSfx(p8) -- Line: 118
    -- upvalues: SoundModule (copy)
    if not SoundModule then
        return;
    end;

    local skillInputData = p8.skillInputData;
    local skillCastId = p8.skillCastId;

    if skillCastId then
        skillInputData = skillCastId;
    elseif skillInputData then
        skillInputData = skillInputData.skillCastId;
    end;

    if not skillInputData then
        return;
    end;

    SoundModule:StopSoundLocal({
        SoundName = "音效-技能-雷系2阶loop",
        SoundTag = skillInputData
    });
end;

function v3.Client_EnterStartup(u9) -- Line: 133
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), RunService (copy)
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

    local u11 = u9.skillRunData.material["电流相生VFX"];

    if u11 then
        VisibleMgr.UnQueryAll(u11);
        u11.Parent = workspace.Debris;
        u11:PivotTo(HumanoidRootPart:GetPivot() * CFrame.new(0, 0.5, 0));
        local skillRunData = u9.skillRunData;
        local v12 = skillRunData and skillRunData.runEvent and skillRunData.runEvent["电流相生VFX跟随"];

        if v12 then
            v12:Disconnect();
            skillRunData.runEvent["电流相生VFX跟随"] = nil;
        end;

        u9.skillRunData.runEvent["电流相生VFX跟随"] = RunService.RenderStepped:Connect(function() -- Line: 155
            -- upvalues: HumanoidRootPart (copy), u11 (copy)
            if HumanoidRootPart.Parent and u11.Parent then
                u11:PivotTo(HumanoidRootPart:GetPivot() * CFrame.new(0, 0.5, 0));
            end;
        end);
    end;

    task.delay(0.23, function() -- Line: 163
        -- upvalues: u9 (copy), RunService (ref), u10 (copy)
        if not u9:isRunningFlow() then
            return;
        end;

        local u13 = u9.skillRunData.material["雷系尾迹"];

        if not u13 then
            return;
        end;

        for _, descendant in u13:GetDescendants() do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        u13.Parent = workspace.Debris;
        u9.skillRunData.runEvent["电流相生魔杖尾迹"] = RunService.RenderStepped:Connect(function() -- Line: 177
            -- upvalues: u10 (ref), u13 (copy)
            if u10.Parent then
                u13:PivotTo(u10:GetPivot());
            end;
        end);
    end);
end;

function v3.Server_EnterStartup(p14) -- Line: 185
end;

function v3.Client_EnterFloat(u15) -- Line: 187
    -- upvalues: SkillCommon (copy), emitAndEnableMutualVfxParts (copy), SoundModule (copy), u2 (copy), disableAllParticles (copy), UtilsSystem (copy), SkillBuffUtil (copy), SkillBuffRuntimeTag (copy), GetData (copy), TipsModule (copy)
    local character = u15.skillInputData.character;

    if character then
        character = character:FindFirstChild("HumanoidRootPart");
    end;

    if u15.skillRunData.runEvent["电流相生魔杖尾迹"] then
        u15.skillRunData.runEvent["电流相生魔杖尾迹"]:Disconnect();
        u15.skillRunData.runEvent["电流相生魔杖尾迹"] = nil;
    end;

    local v16 = u15.skillRunData.material["雷系尾迹"];

    if v16 then
        for _, descendant in v16:GetDescendants() do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local u17 = u15.skillRunData.material["电流相生VFX"];

    if u17 then
        SkillCommon.playSoundLocal3D("音效-技能-雷系2阶-法阵", u17:GetPivot().Position);
        emitAndEnableMutualVfxParts(u17);
        local skillInputData = u15.skillInputData;
        local skillCastId = u15.skillCastId;

        if skillCastId then
            skillInputData = skillCastId;
        elseif skillInputData then
            skillInputData = skillInputData.skillCastId;
        end;

        if SoundModule and (character and skillInputData) then
            SoundModule:PlaySoundLocal({
                SoundName = "音效-技能-雷系2阶loop",
                Is2D = false,
                Looped = true,
                AttachPart = character,
                SoundTag = skillInputData
            });
        end;

        local runGeneration = u15.runGeneration;
        task.delay(u2, function() -- Line: 221
            -- upvalues: u15 (copy), runGeneration (copy), SoundModule (ref), u17 (copy), disableAllParticles (ref)
            if not u15:isRunningFlow() or u15.runGeneration ~= runGeneration then
                return;
            end;

            local v18 = u15;

            if SoundModule then
                local skillInputData2 = v18.skillInputData;
                local skillCastId2 = v18.skillCastId;

                if skillCastId2 then
                    skillInputData2 = skillCastId2;
                elseif skillInputData2 then
                    skillInputData2 = skillInputData2.skillCastId;
                end;

                if skillInputData2 then
                    SoundModule:StopSoundLocal({
                        SoundName = "音效-技能-雷系2阶loop",
                        SoundTag = skillInputData2
                    });
                end;
            end;

            if u17.Parent then
                disableAllParticles(u17);
            end;
        end);
    end;

    local v19 = SkillCommon.isLocalPlayerCaster(u15) and UtilsSystem.LocalPlayer;

    if v19 then
        local v20 = (SkillBuffUtil.GetPrimaryScalarForBuffRuntimeTag(SkillBuffRuntimeTag.ThunderMutualDmg) or 0) * GetData.GetSkillBuffCasterDamageMul(u15.skillPower, u15.skillPurity, u15.mpTp) * 100;

        if v20 ~= math.floor(v20) then
            v20 = math.floor(v20 * 10 + 0.5) / 10;
        end;

        TipsModule.ShowTips(v19, "电流相生增伤提示", { u2, v20 });
    end;
end;

function v3.Client_ExitFloat(p21) -- Line: 246
    -- upvalues: SoundModule (copy), disableAllParticles (copy)
    if SoundModule then
        local skillInputData = p21.skillInputData;
        local skillCastId = p21.skillCastId;

        if skillCastId then
            skillInputData = skillCastId;
        elseif skillInputData then
            skillInputData = skillInputData.skillCastId;
        end;

        if skillInputData then
            SoundModule:StopSoundLocal({
                SoundName = "音效-技能-雷系2阶loop",
                SoundTag = skillInputData
            });
        end;
    end;

    local skillRunData = p21.skillRunData;
    local v22 = skillRunData and skillRunData.runEvent and skillRunData.runEvent["电流相生VFX跟随"];

    if v22 then
        v22:Disconnect();
        skillRunData.runEvent["电流相生VFX跟随"] = nil;
    end;

    local v23 = p21.skillRunData.material["电流相生VFX"];

    if v23 then
        disableAllParticles(v23);
    end;
end;

function v3.Server_EnterFloat(p24) -- Line: 255
end;

function v3.Server_ExitFloat(p25) -- Line: 257
end;

function v3.Server_EnterRecovery(p26) -- Line: 259
    p26:releaseControl();
end;

function v3.Client_EnterRecovery(p27) -- Line: 263
end;

function v3.onEnd(p28) -- Line: 265
    -- upvalues: SoundModule (copy), disableAllParticles (copy)
    if SoundModule then
        local skillInputData = p28.skillInputData;
        local skillCastId = p28.skillCastId;

        if skillCastId then
            skillInputData = skillCastId;
        elseif skillInputData then
            skillInputData = skillInputData.skillCastId;
        end;

        if skillInputData then
            SoundModule:StopSoundLocal({
                SoundName = "音效-技能-雷系2阶loop",
                SoundTag = skillInputData
            });
        end;
    end;

    local skillRunData = p28.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local v29 = skillRunData and skillRunData.runEvent and skillRunData.runEvent["电流相生VFX跟随"];

    if v29 then
        v29:Disconnect();
        skillRunData.runEvent["电流相生VFX跟随"] = nil;
    end;

    local v30 = skillRunData.material["电流相生VFX"];

    if v30 and v30.Parent then
        disableAllParticles(v30);
    end;
end;

function v3.onEndServer(p31) -- Line: 278
end;

v3.SoundList = { "音效-技能-雷系2阶-法阵", "音效-技能-雷系2阶loop" };
v3.AnimateList = { "技能释放动作2" };
v3.ResNameList = { "雷系尾迹", "电流相生VFX" };
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