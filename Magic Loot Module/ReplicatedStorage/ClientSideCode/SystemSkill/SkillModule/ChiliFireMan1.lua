-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local EnumMgr = UtilsSystem.EnumMgr;
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local HeldItemVisualUtil = UtilsSystem.HeldItemVisualUtil;
local SystemDungeon = UtilsSystem.SystemDungeon;
local SoundModule = UtilsSystem.SoundModule;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = EnumMgr.ElementTp.Fire,
    skillConfSkillId = 10111004,
    InitialState = "Apply",
    ControlOpenState = "Recovery",
    States = {
        Apply = {
            Duration = 0.83,
            OnEnterClient = "Client_EnterApply",
            OnEnterServer = "Server_EnterApply",
            OnExitClient = "Client_ExitApply",
            OnExitServer = nil
        },
        Recovery = {
            Duration = 0.1,
            OnEnterClient = nil,
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
            IsTerminal = true,
            OnEnterClient = "Client_EnterInterrupted",
            OnEnterServer = nil,
            OnExitClient = nil,
            OnExitServer = nil
        }
    },
    Transitions = {
        {
            From = "Apply",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Apply",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Apply",
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
local u2 = {};
local u3 = {};

local function _isTimelineAlive(p4, p5, p6) -- Line: 106
    local v7;

    if p4.runGeneration == p5 then
        v7 = p6.Parent ~= nil;
    else
        v7 = false;
    end;

    return v7;
end;

local function _hasAuraFlag(p8) -- Line: 115
    return p8:GetAttribute("ChiliFireManAura") ~= nil;
end;

local function _takeMaterial(p9, p10) -- Line: 125
    local skillRunData = p9.skillRunData;

    if not skillRunData or type(skillRunData.material) ~= "table" then
        return nil;
    end;

    local v11 = skillRunData.material[p10];

    if not (v11 and v11:IsA("Model")) then
        return nil;
    end;

    skillRunData.material[p10] = nil;

    return v11;
end;

local function _hideHeldWeapon(p12) -- Line: 142
    -- upvalues: HeldItemVisualUtil (copy)
    local v13 = p12:FindFirstChild("当前手持");

    if v13 then
        HeldItemVisualUtil.SetModelHiddenLocal(v13, true);
    end;
end;

local function _showHeldWeapon(p14) -- Line: 153
    -- upvalues: HeldItemVisualUtil (copy)
    local v15 = p14:FindFirstChild("当前手持");

    if v15 then
        HeldItemVisualUtil.SetModelHiddenLocal(v15, false);
    end;
end;

local function _destroyBodyFxWelds(p16) -- Line: 164
    for _, descendant in p16:GetDescendants() do
        if descendant:IsA("WeldConstraint") then
            descendant:Destroy();
        end;
    end;
end;

local function _weldBodyChiliFx(p17, p18) -- Line: 178
    -- upvalues: FXUtil (copy), VisibleMgr (copy)
    if not FXUtil.WeldFxModelToBasePart(p17, p18) then
        return false;
    end;

    VisibleMgr.UnAnchoredAll(p17);
    VisibleMgr.MasslessAll(p17);
    VisibleMgr.UnCollideAll(p17);
    VisibleMgr.UnTouchAll(p17);
    VisibleMgr.UnQueryAll(p17);

    return true;
end;

local function _stopChiliFollow(p19) -- Line: 195
    local skillRunData = p19.skillRunData;

    if not (skillRunData and skillRunData.runEvent) then
        return;
    end;

    local v20 = skillRunData.runEvent["辣椒跟随右手"];

    if v20 then
        v20:Disconnect();
        skillRunData.runEvent["辣椒跟随右手"] = nil;
    end;
end;

local function _startChiliFollowRightWeapon(u21, u22, u23) -- Line: 214
    -- upvalues: Workspace (copy), FXUtil (copy), RunService (copy)
    local v24 = u22:FindFirstChild("Right Weapon");

    if not (v24 and v24:IsA("BasePart")) then
        return false;
    end;

    local Root = u23:FindFirstChild("Root");

    if Root and Root:IsA("BasePart") then
        u23.PrimaryPart = Root;
    else
        local v25 = not u23.PrimaryPart and u23:FindFirstChildWhichIsA("BasePart", true);

        if v25 then
            u23.PrimaryPart = v25;
        end;
    end;

    if not u23.PrimaryPart then
        return false;
    end;

    u23.Parent = Workspace:FindFirstChild("Debris") or Workspace;
    u23:PivotTo(v24.CFrame);
    local v26 = u23:FindFirstChild("FX_炎晶", true);

    if v26 then
        FXUtil.SetEmittersTrailsBeamsEnabled(v26, true);
    end;

    local skillRunData = u21.skillRunData;

    if not skillRunData then
        return false;
    end;

    skillRunData.runEvent = skillRunData.runEvent or {};
    local skillRunData2 = u21.skillRunData;
    local v27 = skillRunData2 and skillRunData2.runEvent and skillRunData2.runEvent["辣椒跟随右手"];

    if v27 then
        v27:Disconnect();
        skillRunData2.runEvent["辣椒跟随右手"] = nil;
    end;

    local u28 = v24;
    skillRunData.runEvent["辣椒跟随右手"] = RunService.RenderStepped:Connect(function() -- Line: 250
        -- upvalues: u23 (copy), u22 (copy), u21 (copy), u28 (ref)
        if u23.Parent and u22.Parent then
            if not u28.Parent then
                local v29 = u22:FindFirstChild("Right Weapon");

                if not (v29 and v29:IsA("BasePart")) then
                    return;
                end;

                u28 = v29;
            end;

            u23:PivotTo(u28.CFrame);

            return;
        end;

        local skillRunData3 = u21.skillRunData;

        if skillRunData3 then
            if not skillRunData3.runEvent then
                return;
            end;

            local v30 = skillRunData3.runEvent["辣椒跟随右手"];

            if v30 then
                v30:Disconnect();
                skillRunData3.runEvent["辣椒跟随右手"] = nil;
            end;
        end;
    end);

    return true;
end;

local function _recycleChili(p31, p32) -- Line: 272
    -- upvalues: _destroyBodyFxWelds (copy), FXUtil (copy)
    if p31 then
        local skillRunData = p31.skillRunData;
        local v33 = skillRunData and skillRunData.runEvent and skillRunData.runEvent["辣椒跟随右手"];

        if v33 then
            v33:Disconnect();
            skillRunData.runEvent["辣椒跟随右手"] = nil;
        end;

        local skillRunData2 = p31.skillRunData;

        if skillRunData2 then
            skillRunData2._chiliFireManChili = nil;
        end;
    end;

    if p32 and p32.Parent then
        _destroyBodyFxWelds(p32);
        FXUtil.BackPool_Instance(p32);
    end;
end;

local function _auraLoopSoundTag(p34) -- Line: 291
    return "ChiliFireManAuraLoop_" .. p34:GetFullName();
end;

local function _stopAuraLoopSound(p35) -- Line: 299
    -- upvalues: u3 (copy), SoundModule (copy)
    local v36 = u3[p35];

    if v36 then
        v36:Disconnect();
        u3[p35] = nil;
    end;

    if not SoundModule then
        return;
    end;

    SoundModule:StopSoundLocal({
        SoundName = "音效-辣椒火焰-火焰loop",
        FadeTime = 0.15,
        DestroyAfter = true,
        SoundTag = "ChiliFireManAuraLoop_" .. p35:GetFullName()
    });
end;

local function _startAuraLoopSound(u37) -- Line: 320
    -- upvalues: SoundModule (copy), _stopAuraLoopSound (copy), u3 (copy)
    if not SoundModule then
        return;
    end;

    if u37:GetAttribute("ChiliFireManAura") == nil then
        return;
    end;

    local HumanoidRootPart = u37:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    _stopAuraLoopSound(u37);
    SoundModule:PlaySoundLocal({
        SoundName = "音效-辣椒火焰-火焰loop",
        Is2D = false,
        AttachPart = HumanoidRootPart,
        SoundTag = "ChiliFireManAuraLoop_" .. u37:GetFullName()
    });
    u3[u37] = u37:GetAttributeChangedSignal("ChiliFireManAura"):Connect(function() -- Line: 340
        -- upvalues: u37 (copy), _stopAuraLoopSound (ref)
        if u37:GetAttribute("ChiliFireManAura") == nil then
            _stopAuraLoopSound(u37);
        end;
    end);

    if u37:GetAttribute("ChiliFireManAura") == nil then
        _stopAuraLoopSound(u37);
    end;
end;

local function _playEatFx(p38, p39) -- Line: 355
    -- upvalues: SkillCommon (copy), FXUtil (copy), Workspace (copy), _startAuraLoopSound (copy)
    if p39:GetAttribute("ChiliFireManAura") == nil then
        return;
    end;

    local HumanoidRootPart = p39:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local v40 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.5, "Ground");
    local skillRunData = p38.skillRunData;
    local u41;

    if skillRunData and type(skillRunData.material) == "table" then
        u41 = skillRunData.material["辣椒火人_吃辣椒时触发特效"];

        if u41 and u41:IsA("Model") then
            skillRunData.material["辣椒火人_吃辣椒时触发特效"] = nil;
        else
            u41 = nil;
        end;
    else
        u41 = nil;
    end;

    if u41 then
        FXUtil.PrepEffectForWorldShared(u41, true);
        u41.Parent = Workspace:FindFirstChild("Debris") or Workspace;
        u41:PivotTo(CFrame.new(v40) * u41:GetPivot().Rotation);
        FXUtil.Emit_Particles_GetDescendants(u41, true);
        task.delay(2, function() -- Line: 371
            -- upvalues: u41 (copy), FXUtil (ref)
            if u41 and u41.Parent then
                FXUtil.BackPool_Instance(u41);
            end;
        end);
    end;

    SkillCommon.playSoundLocal3D("音效-辣椒火焰-火焰迸出", v40);
    _startAuraLoopSound(p39);
end;

local function _teardownAuraFx(u42) -- Line: 385
    -- upvalues: u2 (copy), FXUtil (copy), _destroyBodyFxWelds (copy)
    local v43 = u2[u42];

    if not v43 then
        return;
    end;

    u2[u42] = nil;

    if v43.attrConn then
        v43.attrConn:Disconnect();
        v43.attrConn = nil;
    end;

    local fx = v43.fx;

    if not fx then
        return;
    end;

    FXUtil.SetEmittersTrailsBeamsEnabled(fx, false);
    FXUtil.Stop_All_Particles(fx);
    task.delay(2, function() -- Line: 401
        -- upvalues: u2 (ref), u42 (copy), fx (copy), _destroyBodyFxWelds (ref), FXUtil (ref)
        local v44 = u2[u42];

        if v44 and v44.fx == fx then
            return;
        end;

        if fx and fx.Parent then
            _destroyBodyFxWelds(fx);
            FXUtil.BackPool_Instance(fx);
        end;
    end);
end;

local function _teardownAura(p45) -- Line: 417
    -- upvalues: _stopAuraLoopSound (copy), _teardownAuraFx (copy)
    _stopAuraLoopSound(p45);
    _teardownAuraFx(p45);
end;

local function _startAura(p46, u47) -- Line: 427
    -- upvalues: _teardownAuraFx (copy), Workspace (copy), _weldBodyChiliFx (copy), FXUtil (copy), u2 (copy), _stopAuraLoopSound (copy)
    _teardownAuraFx(u47);

    if u47:GetAttribute("ChiliFireManAura") == nil then
        return;
    end;

    local HumanoidRootPart = u47:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return;
    end;

    local skillRunData = p46.skillRunData;
    local v48;

    if skillRunData and type(skillRunData.material) == "table" then
        v48 = skillRunData.material["辣椒火人_常驻特效"];

        if v48 and v48:IsA("Model") then
            skillRunData.material["辣椒火人_常驻特效"] = nil;
        else
            v48 = nil;
        end;
    else
        v48 = nil;
    end;

    if not v48 then
        return;
    end;

    v48.Parent = Workspace:FindFirstChild("Debris") or Workspace;
    HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0);

    if not _weldBodyChiliFx(v48, HumanoidRootPart) then
        FXUtil.BackPool_Instance(v48);

        return;
    end;

    FXUtil.EmitOnceThenEnableContinuous(v48);
    local v49 = {
        attrConn = nil,
        fx = v48
    };
    u2[u47] = v49;
    v49.attrConn = u47:GetAttributeChangedSignal("ChiliFireManAura"):Connect(function() -- Line: 458
        -- upvalues: u47 (copy), _stopAuraLoopSound (ref), _teardownAuraFx (ref)
        if u47:GetAttribute("ChiliFireManAura") == nil then
            local v50 = u47;
            _stopAuraLoopSound(v50);
            _teardownAuraFx(v50);
        end;
    end);

    if u47:GetAttribute("ChiliFireManAura") == nil then
        _stopAuraLoopSound(u47);
        _teardownAuraFx(u47);
    end;
end;

function v1.Client_EnterApply(u51) -- Line: 471
    -- upvalues: HeldItemVisualUtil (copy), _startChiliFollowRightWeapon (copy), _destroyBodyFxWelds (copy), FXUtil (copy), SkillCommon (copy), _playEatFx (copy), _startAura (copy)
    local u52 = u51.skillInputData and u51.skillInputData.character;

    if not u52 then
        return;
    end;

    local runGeneration = u51.runGeneration;
    local v53 = u52:FindFirstChild("当前手持");

    if v53 then
        HeldItemVisualUtil.SetModelHiddenLocal(v53, true);
    end;

    local skillRunData = u51.skillRunData;
    local u54;

    if skillRunData and type(skillRunData.material) == "table" then
        u54 = skillRunData.material["辣椒火人_辣椒"];

        if u54 and u54:IsA("Model") then
            skillRunData.material["辣椒火人_辣椒"] = nil;
        else
            u54 = nil;
        end;
    else
        u54 = nil;
    end;

    if u54 then
        if _startChiliFollowRightWeapon(u51, u52, u54) then
            u51.skillRunData._chiliFireManChili = u54;
        else
            if u51 then
                local skillRunData2 = u51.skillRunData;
                local v55 = skillRunData2 and skillRunData2.runEvent and skillRunData2.runEvent["辣椒跟随右手"];

                if v55 then
                    v55:Disconnect();
                    skillRunData2.runEvent["辣椒跟随右手"] = nil;
                end;

                local skillRunData3 = u51.skillRunData;

                if skillRunData3 then
                    skillRunData3._chiliFireManChili = nil;
                end;
            end;

            if u54 and u54.Parent then
                _destroyBodyFxWelds(u54);
                FXUtil.BackPool_Instance(u54);
            end;

            u54 = nil;
            local v56 = u52:FindFirstChild("当前手持");

            if v56 then
                HeldItemVisualUtil.SetModelHiddenLocal(v56, false);
            end;
        end;
    end;

    task.delay(0.38, function() -- Line: 493
        -- upvalues: u51 (copy), runGeneration (copy), u52 (copy), SkillCommon (ref)
        local v57 = u52;
        local v58;

        if runGeneration == u51.runGeneration then
            v58 = v57.Parent ~= nil;
        else
            v58 = false;
        end;

        if not v58 then
            return;
        end;

        local HumanoidRootPart = u52:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then
            SkillCommon.playSoundLocal3D("音效-辣椒火焰-咬辣椒", HumanoidRootPart.Position);
        end;
    end);
    task.delay(0.46, function() -- Line: 504
        -- upvalues: u51 (copy), runGeneration (copy), u52 (copy), _playEatFx (ref)
        local v59 = u52;
        local v60;

        if runGeneration == u51.runGeneration then
            v60 = v59.Parent ~= nil;
        else
            v60 = false;
        end;

        if not v60 then
            return;
        end;

        if u52:GetAttribute("ChiliFireManAura") == nil then
            return;
        end;

        _playEatFx(u51, u52);
    end);
    task.delay(0.5, function() -- Line: 515
        -- upvalues: u51 (copy), runGeneration (copy), u52 (copy), u54 (ref), _destroyBodyFxWelds (ref), FXUtil (ref), _startAura (ref)
        local v61 = u52;
        local v62;

        if runGeneration == u51.runGeneration then
            v62 = v61.Parent ~= nil;
        else
            v62 = false;
        end;

        if not v62 then
            local v63 = u51;
            local v64 = u54;

            if v63 then
                local skillRunData2 = v63.skillRunData;
                local v65 = skillRunData2 and skillRunData2.runEvent and skillRunData2.runEvent["辣椒跟随右手"];

                if v65 then
                    v65:Disconnect();
                    skillRunData2.runEvent["辣椒跟随右手"] = nil;
                end;

                local skillRunData3 = v63.skillRunData;

                if skillRunData3 then
                    skillRunData3._chiliFireManChili = nil;
                end;
            end;

            if v64 and v64.Parent then
                _destroyBodyFxWelds(v64);
                FXUtil.BackPool_Instance(v64);
            end;

            return;
        end;

        local v66 = u51;
        local v67 = u54;

        if v66 then
            local skillRunData2 = v66.skillRunData;
            local v68 = skillRunData2 and skillRunData2.runEvent and skillRunData2.runEvent["辣椒跟随右手"];

            if v68 then
                v68:Disconnect();
                skillRunData2.runEvent["辣椒跟随右手"] = nil;
            end;

            local skillRunData3 = v66.skillRunData;

            if skillRunData3 then
                skillRunData3._chiliFireManChili = nil;
            end;
        end;

        if v67 and v67.Parent then
            _destroyBodyFxWelds(v67);
            FXUtil.BackPool_Instance(v67);
        end;

        u54 = nil;

        if u52:GetAttribute("ChiliFireManAura") == nil then
            return;
        end;

        _startAura(u51, u52);
    end);
end;

function v1.Client_ExitApply(p69) -- Line: 529
    -- upvalues: HeldItemVisualUtil (copy)
    local v70 = p69.skillInputData and p69.skillInputData.character;
    local v71 = v70 and v70:FindFirstChild("当前手持");

    if v71 then
        HeldItemVisualUtil.SetModelHiddenLocal(v71, false);
    end;
end;

function v1.Server_EnterApply(p72) -- Line: 536
    -- upvalues: Players (copy), Workspace (copy), SystemDungeon (copy)
    local v73 = p72.skillInputData and p72.skillInputData.character;

    if not v73 then
        return;
    end;

    local u74 = Players:GetPlayerFromCharacter(v73);

    if not u74 then
        return;
    end;

    v73:SetAttribute("ChiliFireManAura", Workspace:GetServerTimeNow());

    if not SystemDungeon then
        return;
    end;

    SystemDungeon.overrideNormalAtk(u74, 10207001);
    SystemDungeon.registerEffect(u74, "ChiliFireMan", function() -- Line: 552
        -- upvalues: u74 (copy)
        local Character = u74.Character;

        if Character then
            Character:SetAttribute("ChiliFireManAura", nil);
        end;
    end);
    local v75 = p72.skillInputData and p72.skillInputData.slotIndex;

    if v75 then
        SystemDungeon.registerCdSlot(u74, v75);
    end;
end;

function v1.Server_EnterRecovery(p76) -- Line: 564
    p76:releaseControl();
end;

function v1.Client_EnterInterrupted(p77) -- Line: 568
    -- upvalues: _destroyBodyFxWelds (copy), FXUtil (copy), _stopAuraLoopSound (copy), _teardownAuraFx (copy), HeldItemVisualUtil (copy)
    local v78 = p77.skillInputData and p77.skillInputData.character;
    local skillRunData = p77.skillRunData;

    if skillRunData then
        skillRunData = skillRunData._chiliFireManChili;
    end;

    if skillRunData then
        if p77 then
            local skillRunData2 = p77.skillRunData;
            local v79 = skillRunData2 and skillRunData2.runEvent and skillRunData2.runEvent["辣椒跟随右手"];

            if v79 then
                v79:Disconnect();
                skillRunData2.runEvent["辣椒跟随右手"] = nil;
            end;

            local skillRunData3 = p77.skillRunData;

            if skillRunData3 then
                skillRunData3._chiliFireManChili = nil;
            end;
        end;

        if skillRunData and skillRunData.Parent then
            _destroyBodyFxWelds(skillRunData);
            FXUtil.BackPool_Instance(skillRunData);
        end;
    else
        local skillRunData2 = p77.skillRunData;
        local v80 = skillRunData2 and skillRunData2.runEvent and skillRunData2.runEvent["辣椒跟随右手"];

        if v80 then
            v80:Disconnect();
            skillRunData2.runEvent["辣椒跟随右手"] = nil;
        end;
    end;

    if v78 then
        _stopAuraLoopSound(v78);
        _teardownAuraFx(v78);
        local v81 = v78:FindFirstChild("当前手持");

        if v81 then
            HeldItemVisualUtil.SetModelHiddenLocal(v81, false);
        end;
    end;
end;

v1.SoundList = { "音效-辣椒火焰-咬辣椒", "音效-辣椒火焰-火焰迸出", "音效-辣椒火焰-火焰loop" };
v1.AnimateList = { "吃辣椒" };
v1.ResNameList = { "辣椒火人_辣椒", "辣椒火人_吃辣椒时触发特效", "辣椒火人_常驻特效" };
v1.hitboxConfig = {};
v1.DamageProfiles = {};
v1.Action = {
    {
        action = "LockMovement",
        startTime = 0,
        overTime = 1.58,
        speedMultiplier = 0
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.58,
        animationName = "吃辣椒",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v1;