-- Decompiled with Potassium's decompiler.

local u1 = {};
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local _ = UtilsSystem.CameraModule;
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local _ = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
u1.summonMaxCount = 1;
u1.summonSkillKey = "Summon10";

local function cleanupSummonTrail(p2) -- Line: 51
    if not p2 then
        return;
    end;

    local v3 = p2.material and p2.material["召唤系尾迹"];

    if v3 then
        for _, descendant in v3:GetDescendants() do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;
    end;

    local runEvent = p2.runEvent;

    if runEvent and runEvent["召唤术魔杖尾迹"] then
        runEvent["召唤术魔杖尾迹"]:Disconnect();
        runEvent["召唤术魔杖尾迹"] = nil;
    end;
end;

local function playTargetBurstVfx(u4, u5) -- Line: 71
    -- upvalues: FXUtil (copy)
    local function doBurstEmit() -- Line: 72
        -- upvalues: u4 (copy), FXUtil (ref), u5 (copy)
        if not u4.Parent then
            return;
        end;

        FXUtil.Emit_Particles_GetDescendants(u4, true);

        if u5 then
            u5();
        end;
    end;

    local u6 = u4:FindFirstChild("爆发前吸收_Emit和Enable", true);

    if u6 then
        FXUtil.SetEmittersTrailsBeamsEnabled(u6, true);
        task.delay(0.6, function() -- Line: 89
            -- upvalues: u6 (copy), FXUtil (ref), u4 (copy), u5 (copy)
            if u6.Parent then
                FXUtil.SetEmittersTrailsBeamsEnabled(u6, false);
                FXUtil.Stop_All_Emit(u6);
                FXUtil.OffEnableVfx(u6);
            end;

            if not u4.Parent then
                return;
            end;

            FXUtil.Emit_Particles_GetDescendants(u4, true);

            if u5 then
                u5();
            end;
        end);

        return;
    end;

    if not u4.Parent then
        return;
    end;

    FXUtil.Emit_Particles_GetDescendants(u4, true);

    if u5 then
        u5();
    end;
end;

local function playFormationL5Vfx(u7) -- Line: 99
    -- upvalues: FXUtil (copy)
    FXUtil.Emit_Particles_GetDescendants(u7, true);
    FXUtil.SetEmittersTrailsBeamsEnabled(u7, true);
    task.delay(2, function() -- Line: 102
        -- upvalues: u7 (copy), FXUtil (ref)
        if not u7.Parent then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(u7, false);
        FXUtil.Stop_All_Emit(u7);
        FXUtil.OffEnableVfx(u7);
    end);
end;

local function disableSphereFlyVfx(p8) -- Line: 112
    -- upvalues: FXUtil (copy)
    FXUtil.SetEmittersTrailsBeamsEnabled(p8, false);
    FXUtil.Stop_All_Emit(p8);

    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("Beam") then
            FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;
    end;
end;

u1.skillTotalTime = -1;
u1.visualFadeoutTime = 2;
u1.skillElementType = ElementTp.Fire;
u1.skillDistanceLimit = 64;
u1.InitialState = "Startup";
u1.ControlOpenState = "Summon";
u1.States = {
    Startup = {
        Duration = 4,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Summon = {
        Duration = 3.1,
        OnEnterClient = "Client_EnterSummon",
        OnEnterServer = "Server_EnterSummon",
        OnExitClient = "Client_ExitSummon",
        OnExitServer = "Server_ExitSummon"
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
};
u1.Transitions = {
    {
        From = "Startup",
        To = "Summon",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Summon",
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
        From = "Summon",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Summon",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function u1.Client_EnterStartup(u9) -- Line: 172
    -- upvalues: SkillCommon (copy), RunService (copy), RayCast (copy), FXUtil (copy)
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

    local runGeneration = u9.runGeneration;
    local u11 = nil;

    local function stillTrail() -- Line: 183
        -- upvalues: u9 (copy), runGeneration (copy)
        local v12 = u9:isRunningFlow() and u9.runGeneration == runGeneration;

        return v12;
    end;

    task.delay(0.3, function() -- Line: 188
        -- upvalues: u9 (copy), runGeneration (copy), u11 (ref), SkillCommon (ref), RunService (ref), stillTrail (copy), u10 (copy)
        local v13 = u9:isRunningFlow() and u9.runGeneration == runGeneration;

        if not v13 then
            return;
        end;

        local skillRunData = u9.skillRunData;

        if not (skillRunData and skillRunData.material) then
            return;
        end;

        local v14 = skillRunData.material["召唤系尾迹"];

        if not v14 then
            return;
        end;

        u11 = v14;

        for _, descendant in pairs(v14:GetDescendants()) do
            if descendant:IsA("Trail") or descendant:IsA("ParticleEmitter") then
                descendant.Enabled = true;
            end;
        end;

        v14.Parent = workspace.Debris;
        SkillCommon.connectRunEventWhile(skillRunData, "召唤术魔杖尾迹", RunService.RenderStepped, stillTrail, function() -- Line: 207
            -- upvalues: u10 (ref), u11 (ref)
            if u10.Parent and u11 then
                u11:PivotTo(u10:GetPivot());
            end;
        end);
    end);
    task.delay(0, function() -- Line: 215
        -- upvalues: u9 (copy), HumanoidRootPart (copy), RayCast (ref), SkillCommon (ref), FXUtil (ref)
        if not u9:isRunningFlow() then
            return;
        end;

        local targetCF = u9.skillInputData.targetCF;
        local v15 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, 0));
        local v16 = RayCast.RayCastDirection(v15.Position, Vector3.new(0, -1, 0), 20, "Ground");

        if v16 then
            v15 = v15.Rotation + v16.Position + Vector3.new(0, 0.2, 0);
        end;

        CFrame.lookAt(v15.Position, targetCF.Position);
        local v17 = u9.skillRunData.material["召唤法阵A01_起手空间法阵_Emit"];
        v17:ScaleTo(SkillCommon.scaleBandFromData(u9, SkillCommon.bandScaleOptsFromSkillData(u9)));
        v17:PivotTo(v15 * CFrame.Angles(0, 0, 0));
        v17.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v17, true);
        SkillCommon.playSoundLocal3D("音效-龙召唤法术-法阵", v17:GetPivot().Position);
        SkillCommon.playSoundLocal3D("音效-龙召唤法术-背景音效", HumanoidRootPart:GetPivot().Position);
    end);
    task.delay(0.5, function() -- Line: 234
        -- upvalues: SkillCommon (ref), HumanoidRootPart (copy)
        SkillCommon.playSoundLocal3D("音效-龙召唤法术-绕圈1", HumanoidRootPart:GetPivot().Position);
    end);
    task.delay(1.5, function() -- Line: 237
        -- upvalues: SkillCommon (ref), HumanoidRootPart (copy)
        SkillCommon.playSoundLocal3D("音效-龙召唤法术-绕圈2", HumanoidRootPart:GetPivot().Position);
    end);
    task.delay(2.5, function() -- Line: 240
        -- upvalues: SkillCommon (ref), HumanoidRootPart (copy)
        SkillCommon.playSoundLocal3D("音效-龙召唤法术-绕圈3", HumanoidRootPart:GetPivot().Position);
    end);
    task.delay(3.5, function() -- Line: 243
        -- upvalues: SkillCommon (ref), HumanoidRootPart (copy)
        SkillCommon.playSoundLocal3D("音效-龙召唤法术-投掷天空法阵", HumanoidRootPart:GetPivot().Position);
    end);
end;

function u1.Server_EnterStartup(p18) -- Line: 249
end;

function u1.Client_EnterSummon(u19) -- Line: 254
    -- upvalues: SkillCommon (copy), playFormationL5Vfx (copy), FXUtil (copy), RunService (copy), disableSphereFlyVfx (copy), playTargetBurstVfx (copy)
    local character = u19.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = u19.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    local material = skillRunData.material;
    local runGeneration = u19.runGeneration;
    local u20 = SkillCommon.scaleBandFromData(u19, SkillCommon.bandScaleOptsFromSkillData(u19));

    local function stillSummon() -- Line: 268
        -- upvalues: u19 (copy), runGeneration (copy)
        local v21 = u19:isRunningFlow() and u19.runGeneration == runGeneration;

        return v21;
    end;

    local v22 = SkillCommon.resolveWandTipFromCharacter(character);
    local v23 = SkillCommon.resolveWandTipWorldCFrame(v22) or HumanoidRootPart:GetPivot() * CFrame.new(0, 0, -2);
    local v24 = u19.skillInputData.releaseCF or HumanoidRootPart:GetPivot();
    local u25 = SkillCommon.resolveSummonFormationCF(v24, u20, {
        forwardOffsetStuds = 30,
        upOffsetStuds = 30,
        groundRaycast = false
    });
    local Position = u25.Position;

    local function scheduleFormationL5() -- Line: 287
        -- upvalues: u19 (copy), runGeneration (copy), material (copy), u20 (copy), Position (copy), playFormationL5Vfx (ref)
        task.delay(0.4, function() -- Line: 288
            -- upvalues: u19 (ref), runGeneration (ref), material (ref), u20 (ref), Position (ref), playFormationL5Vfx (ref)
            local v26 = u19:isRunningFlow() and u19.runGeneration == runGeneration;

            if not v26 then
                return;
            end;

            local v27 = material["召唤法阵5级_Emit和Enable"];

            if not v27 then
                return;
            end;

            v27:ScaleTo(u20);
            v27:PivotTo(CFrame.new(Position) * v27:GetPivot().Rotation);
            v27.Parent = workspace.Debris;
            playFormationL5Vfx(v27);
        end);
    end;

    local v28 = material["召唤法阵A02_起手空间爆点_Emit"];

    if v28 then
        v28:ScaleTo(u20);
        v28:PivotTo(v23);
        v28.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v28, true);
    end;

    local u29 = material["召唤法阵A03_空间球_Enable"];

    if not u29 then
        return;
    end;

    local u30 = CFrame.lookAt(v23.Position, Position);
    u29:ScaleTo(u20);
    u29:PivotTo(u30);
    u29.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(u29, true);
    FXUtil.SetEmittersTrailsBeamsEnabled(u29, true);
    local u31 = 0;
    local u32 = false;
    SkillCommon.connectRunEventWhile(skillRunData, "召唤空间球飞行", RunService.Heartbeat, stillSummon, function(p33) -- Line: 327
        -- upvalues: u31 (ref), u29 (copy), u30 (copy), u25 (copy), u32 (ref), SkillCommon (ref), skillRunData (copy), disableSphereFlyVfx (ref), material (copy), u20 (copy), playTargetBurstVfx (ref), scheduleFormationL5 (copy), u19 (copy), runGeneration (copy), Position (copy), playFormationL5Vfx (ref)
        u31 = u31 + p33;
        local v34 = game.TweenService:GetValue(math.clamp(u31 / 0.25, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        u29:PivotTo(u30:Lerp(u25, v34));

        if v34 < 1 or u32 then
            return;
        end;

        u32 = true;
        SkillCommon.disconnectRunEventKeys(skillRunData, { "召唤空间球飞行" });
        disableSphereFlyVfx(u29);
        local v35 = material["召唤法阵A04_空间爆发_Emit"];

        if not v35 then
            task.delay(0.4, function() -- Line: 288
                -- upvalues: u19 (ref), runGeneration (ref), material (ref), u20 (ref), Position (ref), playFormationL5Vfx (ref)
                local v36 = u19:isRunningFlow() and u19.runGeneration == runGeneration;

                if not v36 then
                    return;
                end;

                local v37 = material["召唤法阵5级_Emit和Enable"];

                if not v37 then
                    return;
                end;

                v37:ScaleTo(u20);
                v37:PivotTo(CFrame.new(Position) * v37:GetPivot().Rotation);
                v37.Parent = workspace.Debris;
                playFormationL5Vfx(v37);
            end);

            return;
        end;

        v35:ScaleTo(u20);
        v35:PivotTo(CFrame.new(u25.Position));
        v35.Parent = workspace.Debris;
        playTargetBurstVfx(v35, scheduleFormationL5);
        SkillCommon.playSoundLocal3D("音效-龙召唤法术-天空法阵形成展开", u25.Position);
        task.delay(3, function() -- Line: 353
            -- upvalues: SkillCommon (ref), u25 (ref)
            SkillCommon.playSoundLocal3D("音效-龙召唤法术-天上的法阵消失", u25.Position);
        end);
    end);
end;

function u1.Client_ExitSummon(p38) -- Line: 362
    -- upvalues: cleanupSummonTrail (copy), SkillCommon (copy), disableSphereFlyVfx (copy)
    local skillRunData = p38.skillRunData;

    if not skillRunData then
        return;
    end;

    cleanupSummonTrail(skillRunData);
    SkillCommon.disconnectRunEventKeys(skillRunData, { "召唤空间球飞行" });
    local v39 = skillRunData.material and skillRunData.material["召唤法阵A03_空间球_Enable"];

    if v39 and v39.Parent then
        disableSphereFlyVfx(v39);
    end;
end;

function u1.Server_EnterSummon(u40) -- Line: 375
    -- upvalues: SkillCommon (copy), UtilsSystem (copy), u1 (copy)
    local character = u40.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    if not game.Players:GetPlayerFromCharacter(character) then
        return;
    end;

    local u41 = SkillCommon.scaleBandFromData(u40, SkillCommon.bandScaleOptsFromSkillData(u40));
    local v42 = u40.skillInputData.releaseCF or HumanoidRootPart:GetPivot();
    local u43 = SkillCommon.resolveSummonFormationCF(v42, u41, {
        forwardOffsetStuds = 30,
        upOffsetStuds = 30,
        groundRaycast = false
    });
    local v44 = v42:PointToWorldSpace((Vector3.new(0, 0, -30 * (u41 <= 0 and 1 or u41)))) + Vector3.new(0, 5, 0);
    local u45 = v42.Rotation + v44;
    task.delay(1, function() -- Line: 401, Name: doSummon
        -- upvalues: u40 (copy), UtilsSystem (ref), u43 (copy), u1 (ref), u41 (copy), u45 (copy)
        if not u40:isRunningFlow() then
            return;
        end;

        local character2 = u40.skillInputData.character;

        if not (character2 and character2.Parent) then
            return;
        end;

        local v46 = game.Players:GetPlayerFromCharacter(character2);

        if not v46 then
            return;
        end;

        UtilsSystem.SystemSummon.CreateSummon(v46, 20000010, u43, {
            spawnGroundOffsetY = 6,
            spawnIntroDuration = 3,
            summonSkillKey = u1.summonSkillKey or u40.skillName,
            maxCount = u1.summonMaxCount,
            scale = u41,
            skillPower = u40.skillPower,
            skillPurity = u40.skillPurity,
            mpTp = u40.mpTp,
            spawnGroundRayCFrame = u45
        });
    end);
end;

function u1.Server_ExitSummon(p47) -- Line: 435
end;

function u1.Server_EnterRecovery(p48) -- Line: 440
    p48:releaseControl();
end;

function u1.Client_EnterRecovery(p49) -- Line: 444
end;

function u1.onEnd(p50) -- Line: 448
    -- upvalues: cleanupSummonTrail (copy)
    local skillRunData = p50.skillRunData;

    if skillRunData then
        cleanupSummonTrail(skillRunData);
    end;
end;

u1.SoundList = { "音效-龙召唤法术-天上的法阵消失", "音效-龙召唤法术-天空法阵形成展开", "音效-龙召唤法术-投掷天空法阵", "音效-龙召唤法术-法阵", "音效-龙召唤法术-绕圈1", "音效-龙召唤法术-绕圈2", "音效-龙召唤法术-绕圈3", "音效-龙召唤法术-背景音效" };
u1.AnimateList = { "大召唤术" };
u1.ResNameList = { "召唤法阵A01_起手空间法阵_Emit", "召唤法阵A02_起手空间爆点_Emit", "召唤法阵A03_空间球_Enable", "召唤法阵A04_空间爆发_Emit", "召唤法阵5级_Emit和Enable", "召唤系尾迹" };
u1.hitboxConfig = {};
u1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 5,
        animationName = "大召唤术",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;