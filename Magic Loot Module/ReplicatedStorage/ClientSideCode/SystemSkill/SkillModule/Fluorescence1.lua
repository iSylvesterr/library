-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local HumanModule = UtilsSystem.HumanModule;
local AnimationModule = UtilsSystem.AnimationModule;
local GetData = UtilsSystem.GetData;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 0.5,
    skillElementType = ElementTp.Light,
    skillDistanceLimit = 0,
    InitialState = "Startup",
    ControlOpenState = "Glow"
};
local u2 = {};

function u1.checkOnOtherGroupSkillRelease(p3) -- Line: 55
    -- upvalues: SkillCommon (copy), u1 (copy), SkillEventConst (copy)
    local v4 = SkillCommon.getCrossCheckSession(u1, p3.characterId);

    if not (v4 and (v4.isRunningFlow and v4:isRunningFlow())) then
        return;
    end;

    v4:TryTransition(SkillEventConst.ForceFinish, nil);
end;

local function applyFluorescencePointLightRange(p5, p6) -- Line: 63
    local v7 = p5:FindFirstChild("FX_灯Enabled", true);

    if not v7 then
        return;
    end;

    local v8 = v7:FindFirstChildOfClass("PointLight");

    if not v8 then
        return;
    end;

    local v9 = v8:GetAttribute("BaseRange");

    if type(v9) ~= "number" or v9 <= 0 then
        v9 = v8.Range;
        v8:SetAttribute("BaseRange", v9);
    end;

    v8.Range = v9 * p6;
end;

local function setFluorescenceLightEnabled(p10, p11) -- Line: 80
    -- upvalues: FXUtil (copy)
    if not p10 then
        return;
    end;

    FXUtil.SetEmittersTrailsBeamsEnabled(p10, p11);

    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("PointLight") or descendant:IsA("SpotLight") then
            descendant.Enabled = p11;
        end;
    end;
end;

local function playFlashBurst(p12, p13, p14) -- Line: 92
    -- upvalues: VisibleMgr (copy), FXUtil (copy)
    p12:ScaleTo(p14);
    VisibleMgr.UnQueryAll(p12);
    p12:PivotTo(p13);
    p12.Parent = workspace.Debris;
    local v15 = p12:FindFirstChild("爆", true);

    if not (v15 and v15:IsA("Attachment")) then
        FXUtil.Emit_Particles_GetDescendants(p12, true);

        return;
    end;

    v15.CFrame = CFrame.new();
    v15.WorldCFrame = p13;
    FXUtil.Emit_Particles_Children(v15, nil);
end;

local function resolveFormFeetPos(p16, p17) -- Line: 108
    -- upvalues: SkillCommon (copy)
    return SkillCommon.casterFeetGroundWorldPos(p16, 4, 0.2, "Ground") + Vector3.new(0, p17 * -0.5, 0);
end;

local function playFeetFormation(p18, p19, p20) -- Line: 114
    -- upvalues: VisibleMgr (copy), SkillCommon (copy), FXUtil (copy)
    p18:ScaleTo(p20);
    VisibleMgr.UnQueryAll(p18);
    p18:PivotTo(CFrame.new(SkillCommon.casterFeetGroundWorldPos(p19, 4, 0.2, "Ground") + Vector3.new(0, p20 * -0.5, 0)) * p18:GetPivot().Rotation);
    p18.Parent = workspace.Debris;
    local v21 = p18:FindFirstChild("Emit_法阵", true);

    if not v21 then
        FXUtil.Emit_Particles_GetDescendants(p18, true);

        return;
    end;

    local v22 = v21:FindFirstChild("法阵", true);

    if v22 and v22:IsA("Attachment") then
        FXUtil.Emit_Particles_Children(v22, nil);

        return;
    end;

    FXUtil.Emit_Particles_GetDescendants(v21, true);
end;

local function switchToFlashlightAnim(p23) -- Line: 133
    -- upvalues: AnimationModule (copy)
    local v24 = p23:FindFirstChildOfClass("Humanoid");

    if not v24 then
        return;
    end;

    local v25 = v24:FindFirstChildOfClass("Animator");

    if not v25 then
        return;
    end;

    AnimationModule.StopAnim(v25, "小召唤术", 0.1);
    AnimationModule.PlayAnim(v25, "拿手电筒", 1, nil, nil, Enum.AnimationPriority.Action4, 0.1);

    for _, v in v25:GetPlayingAnimationTracks() do
        if v.Name == "拿手电筒" then
            v.Looped = true;

            return;
        end;
    end;
end;

local function stopFlashlightAnim(p26) -- Line: 152
    -- upvalues: AnimationModule (copy)
    if not p26 then
        return;
    end;

    local v27 = p26:FindFirstChildOfClass("Humanoid");

    if v27 then
        v27 = v27:FindFirstChildOfClass("Animator");
    end;

    if v27 then
        AnimationModule.StopAnim(v27, "拿手电筒", 0.1);
    end;
end;

local function disconnectGlowWatch(p28) -- Line: 163
    if not (p28 and p28.runEvent) then
        return;
    end;

    for _, v in { "荧光魔杖光跟随", "荧光收杖监测" } do
        local v29 = p28.runEvent[v];

        if v29 then
            v29:Disconnect();
            p28.runEvent[v] = nil;
        end;
    end;
end;

local function cleanupGlowFx(p30, p31) -- Line: 176
    -- upvalues: disconnectGlowWatch (copy), setFluorescenceLightEnabled (copy), FXUtil (copy), AnimationModule (copy)
    local skillRunData = p30.skillRunData;

    if not skillRunData then
        return;
    end;

    disconnectGlowWatch(skillRunData);
    local v32 = skillRunData.material and skillRunData.material["荧光_光"];

    if v32 then
        setFluorescenceLightEnabled(v32, false);
        FXUtil.OffEnableVfx(v32);
    end;

    if not p31 then
        return;
    end;

    local v33 = p31:FindFirstChildOfClass("Humanoid");

    if v33 then
        v33 = v33:FindFirstChildOfClass("Animator");
    end;

    if v33 then
        AnimationModule.StopAnim(v33, "拿手电筒", 0.1);
    end;
end;

local function cancelClientActiveForCharacter(p34, p35) -- Line: 190
    -- upvalues: u2 (copy), SkillEventConst (copy)
    local v36 = u2[p34];

    if v36 and (v36 ~= p35 and (v36.isRunningFlow and v36:isRunningFlow())) then
        v36:TryTransition(SkillEventConst.ForceFinish, nil);
    end;
end;

u1.States = {
    Startup = {
        Duration = 1.33,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Glow = {
        Duration = 60,
        OnEnterClient = "Client_EnterGlow",
        OnEnterServer = "Server_EnterGlow",
        OnExitClient = "Client_ExitGlow",
        OnExitServer = "Server_ExitGlow"
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
};
u1.Transitions = {
    {
        From = "Startup",
        To = "Glow",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Glow",
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
        From = "Glow",
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
        From = "Glow",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function u1.Client_EnterStartup(p37) -- Line: 231
    -- upvalues: u2 (copy), SkillEventConst (copy), SkillCommon (copy)
    local v38 = u2[p37.characterId];

    if v38 and (v38 ~= p37 and (v38.isRunningFlow and v38:isRunningFlow())) then
        v38:TryTransition(SkillEventConst.ForceFinish, nil);
    end;

    local v39 = p37.skillInputData and p37.skillInputData.character;

    if not v39 then
        return;
    end;

    local HumanoidRootPart = v39:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        SkillCommon.playSoundLocal3D("音效-技能-萤火", HumanoidRootPart:GetPivot().Position);
    end;
end;

function u1.Server_EnterStartup(p40) -- Line: 243
    -- upvalues: SkillCommon (copy), u1 (copy)
    SkillCommon.cancelCrossCheckExcept(u1, p40.characterId, p40);
    SkillCommon.beginCrossCheck(p40, u1);
end;

function u1.Client_EnterGlow(u41) -- Line: 248
    -- upvalues: SkillCommon (copy), u2 (copy), playFeetFormation (copy), playFlashBurst (copy), applyFluorescencePointLightRange (copy), VisibleMgr (copy), setFluorescenceLightEnabled (copy), RunService (copy), switchToFlashlightAnim (copy), UtilsSystem (copy), HumanModule (copy), SkillEventConst (copy)
    local skillInputData = u41.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    local skillRunData = u41.skillRunData;

    if not (skillInputData and (skillRunData and skillRunData.material)) then
        return;
    end;

    local HumanoidRootPart = skillInputData:FindFirstChild("HumanoidRootPart");
    local v42 = SkillCommon.resolveWandTipFromCharacter(skillInputData);
    local v43 = SkillCommon.resolveWandTipWorldCFrame(v42);

    if not (HumanoidRootPart and v43) then
        return;
    end;

    u2[u41.characterId] = u41;
    local runGeneration = u41.runGeneration;
    local v44 = SkillCommon.scaleBandFromData(u41, SkillCommon.bandScaleOptsFromSkillData(u41));
    local v45 = skillRunData.material["荧光_法阵"];

    if v45 then
        playFeetFormation(v45, HumanoidRootPart, v44);
    end;

    local v46 = skillRunData.material["荧光_爆闪"];

    if v46 then
        playFlashBurst(v46, v43, v44);
    end;

    local u47 = skillRunData.material["荧光_光"];

    if u47 then
        u47:ScaleTo(v44);
        applyFluorescencePointLightRange(u47, v44);
        VisibleMgr.UnQueryAll(u47);
        u47:PivotTo(v43);
        u47.Parent = workspace.Debris;
        setFluorescenceLightEnabled(u47, true);

        if not skillRunData.runEvent then
            skillRunData.runEvent = {};
        end;

        skillRunData.runEvent["荧光魔杖光跟随"] = RunService.RenderStepped:Connect(function() -- Line: 287
            -- upvalues: u41 (copy), runGeneration (copy), SkillCommon (ref), skillInputData (copy), u47 (copy)
            if not u41:isRunningFlow() or u41.runGeneration ~= runGeneration then
                return;
            end;

            local v48 = SkillCommon.resolveWandTipFromCharacter(skillInputData);

            if v48 then
                v48 = SkillCommon.resolveWandTipWorldCFrame(v48);
            end;

            if v48 and u47.Parent then
                u47:PivotTo(v48);
            end;
        end);
    end;

    switchToFlashlightAnim(skillInputData);

    if SkillCommon.isLocalPlayerCaster(u41) then
        local LocalPlayer = UtilsSystem.LocalPlayer;
        skillRunData.runEvent["荧光收杖监测"] = RunService.Heartbeat:Connect(function() -- Line: 303
            -- upvalues: u41 (copy), runGeneration (copy), LocalPlayer (copy), HumanModule (ref), SkillCommon (ref), skillInputData (copy), SkillEventConst (ref)
            if not u41:isRunningFlow() or u41.runGeneration ~= runGeneration then
                return;
            end;

            if not (LocalPlayer and LocalPlayer.Parent) then
                return;
            end;

            if HumanModule.GetHeldItemType(LocalPlayer) ~= "Weapon" or not SkillCommon.resolveWandTipFromCharacter(skillInputData) then
                u41:TryTransition(SkillEventConst.ForceFinish, nil);
            end;
        end);
    end;
end;

function u1.Server_EnterGlow(u49) -- Line: 318
    -- upvalues: GetData (copy), RunService (copy), HumanModule (copy), SkillEventConst (copy)
    local runGeneration = u49.runGeneration;
    local u50 = GetData.GetPlayerByID(u49.characterId);

    if not u50 then
        return;
    end;

    u49:BindRunConn(RunService.Heartbeat:Connect(function() -- Line: 324
        -- upvalues: u49 (copy), runGeneration (copy), HumanModule (ref), u50 (copy), SkillEventConst (ref)
        if not u49:isRunningFlow() or u49.runGeneration ~= runGeneration then
            return;
        end;

        if HumanModule.GetHeldItemType(u50) ~= "Weapon" then
            u49:TryTransition(SkillEventConst.ForceFinish, nil);
        end;
    end));
end;

function u1.Client_ExitGlow(p51) -- Line: 335
    -- upvalues: u2 (copy), disconnectGlowWatch (copy), setFluorescenceLightEnabled (copy), FXUtil (copy), AnimationModule (copy)
    if u2[p51.characterId] == p51 then
        u2[p51.characterId] = nil;
    end;

    local v52 = p51.skillInputData and p51.skillInputData.character;
    local skillRunData = p51.skillRunData;

    if not skillRunData then
        return;
    end;

    disconnectGlowWatch(skillRunData);
    local v53 = skillRunData.material and skillRunData.material["荧光_光"];

    if v53 then
        setFluorescenceLightEnabled(v53, false);
        FXUtil.OffEnableVfx(v53);
    end;

    if not v52 then
        return;
    end;

    local v54 = v52:FindFirstChildOfClass("Humanoid");

    if v54 then
        v54 = v54:FindFirstChildOfClass("Animator");
    end;

    if v54 then
        AnimationModule.StopAnim(v54, "拿手电筒", 0.1);
    end;
end;

function u1.Server_ExitGlow(p55) -- Line: 342
end;

function u1.Server_EnterRecovery(p56) -- Line: 344
    p56:releaseControl();
end;

function u1.Client_EnterRecovery(p57) -- Line: 348
end;

function u1.onEnd(p58) -- Line: 350
    -- upvalues: u2 (copy), disconnectGlowWatch (copy), setFluorescenceLightEnabled (copy), FXUtil (copy), AnimationModule (copy)
    if u2[p58.characterId] == p58 then
        u2[p58.characterId] = nil;
    end;

    local v59 = p58.skillInputData and p58.skillInputData.character;
    local skillRunData = p58.skillRunData;

    if not skillRunData then
        return;
    end;

    disconnectGlowWatch(skillRunData);
    local v60 = skillRunData.material and skillRunData.material["荧光_光"];

    if v60 then
        setFluorescenceLightEnabled(v60, false);
        FXUtil.OffEnableVfx(v60);
    end;

    if not v59 then
        return;
    end;

    local v61 = v59:FindFirstChildOfClass("Humanoid");

    if v61 then
        v61 = v61:FindFirstChildOfClass("Animator");
    end;

    if v61 then
        AnimationModule.StopAnim(v61, "拿手电筒", 0.1);
    end;
end;

function u1.onEndServer(p62) -- Line: 357
    -- upvalues: SkillCommon (copy), u1 (copy)
    SkillCommon.endCrossCheck(p62, u1);
end;

u1.SoundList = { "音效-技能-萤火" };
u1.AnimateList = { "小召唤术", "拿手电筒" };
u1.ResNameList = { "荧光_法阵", "荧光_爆闪", "荧光_光" };
u1.hitboxConfig = {};
u1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.5,
        animationName = "小召唤术",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;