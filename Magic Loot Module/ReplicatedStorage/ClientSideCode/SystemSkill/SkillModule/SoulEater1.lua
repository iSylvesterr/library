-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Dark,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "Float",
    States = {
        Startup = {
            Duration = 0.5,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Float = {
            Duration = 5.5,
            OnEnterClient = "Client_EnterFloat",
            OnEnterServer = "Server_EnterFloat",
            OnExitClient = "Client_ExitFloat",
            OnExitServer = "Server_ExitFloat"
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

local function resolveCasterSoundPos(p2) -- Line: 78
    if not p2 then
        return nil;
    end;

    local HumanoidRootPart = p2:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart.Parent then
        return HumanoidRootPart:GetPivot().Position;
    end;

    return p2:GetPivot().Position;
end;

local function playAttackSound(p3, p4) -- Line: 89
    -- upvalues: SkillCommon (copy)
    local v5;

    if p4 then
        local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart.Parent then
            v5 = HumanoidRootPart:GetPivot().Position;
        else
            v5 = p4:GetPivot().Position;
        end;
    else
        v5 = nil;
    end;

    if not v5 then
        return;
    end;

    if not SkillCommon.playSoundLocal3DForSkill(p3, "音效-技能-暗3噬魂-攻击", v5, true) then
        SkillCommon.playSoundLocal3D("音效-技能-暗3噬魂-攻击", v5);
    end;
end;

local function fadeStopAttackSound(p6) -- Line: 100
    -- upvalues: SkillCommon (copy)
    SkillCommon.stopSoundLocalForSkill(p6, "音效-技能-暗3噬魂-攻击", 0.2);
end;

function v1.Client_EnterStartup(p7) -- Line: 104
    -- upvalues: SkillCommon (copy)
    local v8 = p7.skillInputData and p7.skillInputData.character;

    if not v8 then
        return;
    end;

    local v9 = SkillCommon.resolveWandTipFromCharacter(v8);

    if v9 then
        SkillCommon.scheduleWandTipElementTrail(p7, v9, {
            trailMaterialKey = "暗系尾迹2",
            runEventKey = "噬魂Cast尾迹",
            enableAt = 0.23,
            disableAt = 0.5
        });
    end;
end;

function v1.Server_EnterStartup(p10) -- Line: 121
    -- upvalues: SkillCommon (copy)
    local v11 = p10.hitbox[1];

    if not (v11 and v11.hitbox) then
        return;
    end;

    local v12 = 12 * SkillCommon.scaleBandFromData(p10, SkillCommon.bandScaleOptsFromSkillData(p10));
    v11.hitbox.Size = Vector3.new(v12, v12, v12);
end;

function v1.Client_EnterFloat(u13) -- Line: 131
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), RunService (copy)
    local skillInputData = u13.skillInputData;
    local u14;

    if skillInputData then
        u14 = skillInputData.character;
    else
        u14 = skillInputData;
    end;

    local skillRunData = u13.skillRunData;

    if not (u14 and (skillRunData and skillRunData.material)) then
        return;
    end;

    local HumanoidRootPart = u14:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u13.runGeneration;
    local u15 = SkillCommon.scaleBandFromData(u13, SkillCommon.bandScaleOptsFromSkillData(u13));
    local v16 = skillRunData.material["噬魂_法阵"];

    if v16 then
        v16:ScaleTo(u15);
        VisibleMgr.UnQueryAll(v16);
        local v17 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.5, "Ground");
        v16:PivotTo(CFrame.new(v17) * v16:GetPivot().Rotation);
        v16.Parent = workspace.Debris;
        local v18 = v16:FindFirstChild("Emit_法阵", true);

        if v18 then
            FXUtil.EmitBurstEmitInName(v18, true);
        else
            FXUtil.Emit_Particles_GetDescendants(v16, true);
        end;

        SkillCommon.playSoundLocal3D("音效-技能-暗3-法阵", v17);
    end;

    task.delay(0.083, function() -- Line: 163
        -- upvalues: u13 (copy), runGeneration (copy), SkillCommon (ref), skillInputData (copy), HumanoidRootPart (copy), skillRunData (copy), u15 (copy), VisibleMgr (ref), FXUtil (ref), u14 (copy), RunService (ref)
        if u13.runGeneration ~= runGeneration then
            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u13);
        local v19 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 0.5, "Ground");
        local v20 = SkillCommon.resolveTrackTargetHrp(skillInputData);
        local v21;

        if v20 and v20.Parent then
            v21 = v20.Position;
        else
            v21 = v19;
        end;

        local _, v22 = SkillCommon.horizontalHrpStrikeFlatBasis(HumanoidRootPart, v19);
        local u23 = skillRunData.material["噬魂_攻击"];
        local u24 = skillRunData.material["噬魂_攻击_地面部分"];
        local u25;

        if u23 then
            u23:ScaleTo(u15);
            VisibleMgr.UnQueryAll(u23);
            u23:PivotTo(CFrame.new(v19) * u23:GetPivot().Rotation);
            u23.Parent = workspace.Debris;
            u25 = u23:GetPivot().Rotation;
            local v26 = u23:FindFirstChild("噬魂_Emit和Enabled", true);

            if v26 then
                FXUtil.EmitBurstEmitInName(v26, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(v26, true);
                FXUtil.SetEnableNameVfx(v26, true);
            else
                FXUtil.Emit_Particles_GetDescendants(u23, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(u23, true);
            end;
        else
            u25 = nil;
        end;

        if u24 then
            u24:ScaleTo(u15);
            VisibleMgr.UnQueryAll(u24);
            u24:PivotTo(FXUtil.GetGroundAlignedCF(v21, v22, "Ground", 4, 0.5) or CFrame.new(v19));
            u24.Parent = workspace.Debris;
            local v27 = u24:FindFirstChild("噬魂_Emit和Enabled", true) or u24:FindFirstChild("Emit和Enabled", true);

            if v27 then
                FXUtil.EmitBurstEmitInName(v27, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(v27, true);
                FXUtil.SetEnableNameVfx(v27, true);
            else
                FXUtil.Emit_Particles_GetDescendants(u24, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(u24, true);
            end;
        end;

        if u23 then
            local v28 = u14;
            local v29;

            if v28 then
                local HumanoidRootPart2 = v28:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart2 and HumanoidRootPart2.Parent then
                    v29 = HumanoidRootPart2:GetPivot().Position;
                else
                    v29 = v28:GetPivot().Position;
                end;
            else
                v29 = nil;
            end;

            if v29 and not SkillCommon.playSoundLocal3DForSkill(u13, "音效-技能-暗3噬魂-攻击", v29, true) then
                SkillCommon.playSoundLocal3D("音效-技能-暗3噬魂-攻击", v29);
            end;
        end;

        if skillRunData.runEvent["噬魂攻击跟随"] then
            skillRunData.runEvent["噬魂攻击跟随"]:Disconnect();
            skillRunData.runEvent["噬魂攻击跟随"] = nil;
        end;

        skillRunData.runEvent["噬魂攻击跟随"] = RunService.Heartbeat:Connect(function() -- Line: 221
            -- upvalues: u13 (ref), runGeneration (ref), SkillCommon (ref), skillInputData (ref), HumanoidRootPart (ref), u23 (copy), u25 (ref), u24 (copy), FXUtil (ref)
            if u13.runGeneration ~= runGeneration then
                return;
            end;

            local v30 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 0.5, "Ground");
            local v31 = SkillCommon.resolveTrackTargetHrp(skillInputData);
            local v32;

            if v31 and v31.Parent then
                v32 = v31.Position;
            else
                v32 = v30;
            end;

            local _, v33 = SkillCommon.horizontalHrpStrikeFlatBasis(HumanoidRootPart, v30);

            if u23 and (u23.Parent and u25) then
                u23:PivotTo(CFrame.new(v30) * u25);
            end;

            if u24 and u24.Parent then
                u24:PivotTo(FXUtil.GetGroundAlignedCF(v32, v33, "Ground", 4, 0.5) or CFrame.new(v30));
            end;
        end);
    end);
    task.delay(3.5, function() -- Line: 240
        -- upvalues: u13 (copy), runGeneration (copy), u14 (copy), SkillCommon (ref), skillRunData (copy), FXUtil (ref)
        if u13.runGeneration ~= runGeneration then
            return;
        end;

        local v34 = u14;
        local v35;

        if v34 then
            local HumanoidRootPart2 = v34:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart2 and HumanoidRootPart2.Parent then
                v35 = HumanoidRootPart2:GetPivot().Position;
            else
                v35 = v34:GetPivot().Position;
            end;
        else
            v35 = nil;
        end;

        if v35 then
            SkillCommon.stopSoundLocalForSkill(u13, "音效-技能-暗3噬魂-攻击", 0.2);
            SkillCommon.playSoundLocal3D("音效-技能-暗3-攻击消失", v35);
        end;

        for _, v in { "噬魂_攻击", "噬魂_攻击_地面部分" } do
            local v36 = skillRunData.material[v];

            if v36 then
                local v37 = v36:FindFirstChild("噬魂_Emit和Enabled", true) or (v36:FindFirstChild("Emit和Enabled", true) or v36);
                FXUtil.SetEmittersTrailsBeamsEnabled(v37, false);
                FXUtil.OffEnableVfx(v37);
            end;
        end;
    end);
    task.delay(5.5, function() -- Line: 262
        -- upvalues: u13 (copy), runGeneration (copy), skillRunData (copy), FXUtil (ref)
        if u13.runGeneration ~= runGeneration then
            return;
        end;

        if skillRunData.runEvent["噬魂攻击跟随"] then
            skillRunData.runEvent["噬魂攻击跟随"]:Disconnect();
            skillRunData.runEvent["噬魂攻击跟随"] = nil;
        end;

        for _, v in { "噬魂_攻击", "噬魂_攻击_地面部分" } do
            local v38 = skillRunData.material[v];

            if v38 then
                local v39 = v38:FindFirstChild("噬魂_Emit和Enabled", true) or (v38:FindFirstChild("Emit和Enabled", true) or v38);
                FXUtil.SetEmittersTrailsBeamsEnabled(v39, false);
                FXUtil.OffEnableVfx(v39);
            end;
        end;
    end);
end;

function v1.Client_ExitFloat(p40) -- Line: 283
    local skillRunData = p40.skillRunData;

    if skillRunData and (skillRunData.runEvent and skillRunData.runEvent["噬魂攻击跟随"]) then
        skillRunData.runEvent["噬魂攻击跟随"]:Disconnect();
        skillRunData.runEvent["噬魂攻击跟随"] = nil;
    end;
end;

function v1.Server_EnterFloat(u41) -- Line: 291
    -- upvalues: SkillCommon (copy), RunService (copy)
    local skillInputData = u41.skillInputData;

    if not skillInputData then
        return;
    end;

    local u42 = u41.hitbox[1];

    if not (u42 and u42.hitbox) then
        return;
    end;

    local v43 = 12 * SkillCommon.scaleBandFromData(u41, SkillCommon.bandScaleOptsFromSkillData(u41));
    u42.hitbox.Size = Vector3.new(v43, v43, v43);
    local runGeneration = u41.runGeneration;
    local u44 = 0;
    local u45 = 0;
    local u46 = { 0.083, 0.938, 1.792, 2.646, 3.5 };

    if u41.skillRunData.runEvent["噬魂命中盒"] then
        u41.skillRunData.runEvent["噬魂命中盒"]:Disconnect();
        u41.skillRunData.runEvent["噬魂命中盒"] = nil;
    end;

    u41.skillRunData.runEvent["噬魂命中盒"] = RunService.Heartbeat:Connect(function(p47) -- Line: 314
        -- upvalues: u41 (copy), runGeneration (copy), u45 (ref), u44 (ref), u46 (copy), SkillCommon (ref), skillInputData (copy), u42 (copy)
        if not u41:isRunningFlow() or u41.runGeneration ~= runGeneration then
            return;
        end;

        u45 = u45 + p47;

        while u44 < #u46 and u45 >= u46[u44 + 1] do
            u44 = u44 + 1;
            local v48 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 0.5, "Ground");
            u42.hitbox:PivotTo(CFrame.new(v48));
            u42:start();
            task.delay(0.12, function() -- Line: 324
                -- upvalues: u42 (ref)
                if u42.isActive then
                    u42:stop();
                end;
            end);
        end;

        local v49 = u45 >= u46[#u46] + 0.15 and u41.skillRunData.runEvent["噬魂命中盒"];

        if v49 then
            v49:Disconnect();
            u41.skillRunData.runEvent["噬魂命中盒"] = nil;
        end;
    end);
end;

function v1.Server_ExitFloat(p50) -- Line: 340
    if p50.skillRunData.runEvent["噬魂命中盒"] then
        p50.skillRunData.runEvent["噬魂命中盒"]:Disconnect();
        p50.skillRunData.runEvent["噬魂命中盒"] = nil;
    end;

    local v51 = p50.hitbox[1];

    if v51 and v51.isActive then
        v51:stop();
    end;
end;

function v1.Server_EnterRecovery(p52) -- Line: 351
    p52:releaseControl();
end;

function v1.Client_EnterRecovery(p53) -- Line: 355
    -- upvalues: SkillCommon (copy)
    SkillCommon.cleanupWandTipTrailFromMaterial(p53.skillRunData, "暗系尾迹2", "噬魂Cast尾迹");
end;

function v1.onEnd(p54) -- Line: 359
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    SkillCommon.cleanupWandTipTrailFromMaterial(p54.skillRunData, "暗系尾迹2", "噬魂Cast尾迹");
    SkillCommon.stopSoundLocalForSkill(p54, "音效-技能-暗3噬魂-攻击", 0.2);
    local skillRunData = p54.skillRunData;

    if not (skillRunData and skillRunData.material) then
        return;
    end;

    if skillRunData.runEvent and skillRunData.runEvent["噬魂攻击跟随"] then
        skillRunData.runEvent["噬魂攻击跟随"]:Disconnect();
        skillRunData.runEvent["噬魂攻击跟随"] = nil;
    end;

    for _, v in { "噬魂_攻击", "噬魂_攻击_地面部分" } do
        local v55 = skillRunData.material[v];

        if v55 then
            local v56 = v55:FindFirstChild("噬魂_Emit和Enabled", true) or (v55:FindFirstChild("Emit和Enabled", true) or v55);
            FXUtil.SetEmittersTrailsBeamsEnabled(v56, false);
            FXUtil.OffEnableVfx(v56);
        end;
    end;
end;

function v1.onEndServer(p57) -- Line: 382
    local v58 = p57.hitbox[1];

    if v58 and v58.isActive then
        v58:stop();
    end;
end;

v1.SoundList = { "音效-技能-暗3-法阵", "音效-技能-暗3噬魂-攻击", "音效-技能-暗3-攻击消失" };
v1.AnimateList = { "技能释放动作2" };
v1.ResNameList = { "暗系尾迹2", "噬魂_法阵", "噬魂_攻击", "噬魂_攻击_地面部分" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
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

return v1;