-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Poison,
    skillDistanceLimit = 50
};
local u2 = {
    staffFollow = "巫毒领域法杖跟魔杖尖端",
    mainNodeSpin = "巫毒领域主节点自转",
    hitPulse = "巫毒领域命中脉冲"
};
local u3 = { 0.25, 0.624, 0.998, 1.372, 1.746, 2.12, 2.494, 2.868, 3.242, 3.617 };
local u4 = { 0.783, 0.932, 1.081, 1.231, 1.38, 1.529, 1.678, 1.827, 1.976, 2.125, 2.274, 2.423, 2.572, 2.721, 2.87, 3.019, 3.168, 3.317, 3.466, 3.617 };

local function openEmitEnable(p5) -- Line: 77
    -- upvalues: FXUtil (copy)
    FXUtil.EmitBurstEmitInName(p5, true);
    FXUtil.SetEnableNameVfx(p5, true);
    FXUtil.SetEmittersTrailsBeamsEnabled(p5, true);
end;

local function openStartGroundFx(p6) -- Line: 84
    -- upvalues: FXUtil (copy)
    FXUtil.EmitBurstEmitInName(p6, true);
    FXUtil.SetEnableNameVfx(p6, true);
end;

local function dropRunSpawnEntry(p7, p8, p9) -- Line: 90
    if p7 then
        p7 = p7[p8];
    end;

    if not p7 then
        return;
    end;

    for i, v in p7 do
        if v == p9 then
            table.remove(p7, i);

            return;
        end;
    end;
end;

local function scheduleEnableOffThenRecycle(u10, u11, u12, u13, p14, p15, p16, u17) -- Line: 104
    -- upvalues: FXUtil (copy), dropRunSpawnEntry (copy)
    if not u13 then
        return;
    end;

    local u18 = p16 or 2;

    if p15 then
        p15();
    end;

    task.delay(p14, function() -- Line: 121
        -- upvalues: u10 (copy), u13 (copy), FXUtil (ref), u17 (copy), dropRunSpawnEntry (ref), u11 (copy), u12 (copy), u18 (copy)
        if not (u10() and u13.Parent) then
            return;
        end;

        FXUtil.OffEnableVfx(u13);

        if u17 then
            dropRunSpawnEntry(u11, u12, u13);
        end;

        task.delay(u18, function() -- Line: 129
            -- upvalues: u10 (ref), u13 (ref)
            if not (u10() and u13.Parent) then
                return;
            end;

            u13:Destroy();
        end);
    end);
end;

local function resolveCasterLockedGroundPos(p19, p20) -- Line: 139
    -- upvalues: SkillCommon (copy)
    return SkillCommon.casterFeetGroundWorldPos(p19, 4, 0.5, "Ground") + Vector3.new(0, p20, 0);
end;

local function resolveSphereCenterFromGround(p21, p22) -- Line: 144
    return p21 - Vector3.new(0, p22 * 15, 0);
end;

local function sampleDomainGroundPos(p23, p24, p25, p26, p27) -- Line: 149
    -- upvalues: SkillCommon (copy)
    local v28 = (p25:NextNumber() * 2 - 1) * p24;
    local v29 = (p25:NextNumber() * 2 - 1) * p24;
    local v30 = p23 + Vector3.new(v28, p26, v29);

    return SkillCommon.getGroundCF(CFrame.new(v30), p26, p27, "Ground").Position;
end;

local function cacheDomainAnchor(p31, p32, p33, p34) -- Line: 163
    -- upvalues: SkillCommon (copy)
    local v35 = p33 * 0.5;
    local v36 = SkillCommon.casterFeetGroundWorldPos(p32, 4, 0.5, "Ground") + Vector3.new(0, v35, 0);
    local v37 = v36 - Vector3.new(0, p33 * 15, 0);
    local LookVector = p32.CFrame.LookVector;
    local v38 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local Rotation = CFrame.lookAt(v37, v37 + (v38.Magnitude <= 0.05 and Vector3.new(0, 0, -1) or v38.Unit), Vector3.new(0, 1, 0)).Rotation;
    local v39;

    if p34 then
        v39 = CFrame.new(v37 + Vector3.new(0, p34 * 0.25, 0));
    else
        v39 = nil;
    end;

    p31._voodooDomainAnchor = {
        domainGround = v36,
        domainCenter = v37,
        domainRot = Rotation,
        groundLift = v35,
        lockCF = v39
    };
end;

local function domainFxStill(p40, p41, p42) -- Line: 193
    if p40.runGeneration ~= p41 then
        return false;
    end;

    if p40:isRunningFlow() then
        return true;
    end;

    local v43;

    if p42 == nil then
        v43 = false;
    else
        v43 = p42._voodooDomainDeployed == true;
    end;

    return v43;
end;

local function cleanupRunFx(p44) -- Line: 204
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p44.skillRunData, { "巫毒领域法杖跟魔杖尖端", "巫毒领域主节点自转", "巫毒领域命中脉冲" });
end;

local function cleanupInterruptPresentation(p45) -- Line: 213
    -- upvalues: SkillCommon (copy)
    local skillRunData = p45.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "巫毒领域Cast尾迹");
        SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域法杖跟魔杖尖端" });
    end;
end;

function v1.CanInterruptFromMain(p46) -- Line: 222
    local skillRunData = p46.skillRunData;

    if skillRunData then
        skillRunData = skillRunData._voodooDomainDeployed;
    end;

    return not skillRunData;
end;

v1.suppressions = {
    TransitionFuncCondition = "原因：领域落地后 Main→Interrupted 须运行时判断 _voodooDomainDeployed，保证地面领域与 10 次打击跑完"
};
v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.75,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup"
    },
    Main = {
        Duration = 8.6,
        OnEnterClient = "Client_EnterMain",
        OnEnterServer = "Server_EnterMain",
        OnExitClient = "Client_ExitMain",
        OnExitServer = "Server_ExitMain"
    },
    Recovery = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterRecovery",
        OnEnterServer = "Server_EnterRecovery",
        OnExitClient = "Client_ExitRecovery",
        OnExitServer = "Server_ExitRecovery"
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
v1.Transitions = {
    {
        From = "Startup",
        To = "Main",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Main",
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
        From = "Main",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt,
        Condition = v1.CanInterruptFromMain
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
        From = "Main",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function v1.Client_EnterStartup(u47) -- Line: 271
    -- upvalues: SkillCommon (copy), cacheDomainAnchor (copy), VisibleMgr (copy), FXUtil (copy), dropRunSpawnEntry (copy), RunService (copy)
    local skillInputData = u47.skillInputData;
    local u48;

    if skillInputData then
        u48 = skillInputData.character;
    else
        u48 = skillInputData;
    end;

    local v49;

    if u48 then
        v49 = u48:FindFirstChild("HumanoidRootPart");
    else
        v49 = u48;
    end;

    local skillRunData = u47.skillRunData;

    if not (u48 and (skillInputData and (v49 and (skillRunData and skillRunData.material)))) then
        return;
    end;

    local runGeneration = u47.runGeneration;
    local v50 = SkillCommon.scaleBandFromData(u47, SkillCommon.bandScaleOptsFromSkillData(u47));
    local material = skillRunData.material;
    local v51 = 0.5 * v50;

    local function still() -- Line: 285
        -- upvalues: SkillCommon (ref), u47 (copy), runGeneration (copy)
        return SkillCommon.isRunningSameGeneration(u47, runGeneration);
    end;

    cacheDomainAnchor(skillRunData, v49, v50);
    local v52 = SkillCommon.resolveWandTipFromCharacter(u48);

    if v52 then
        SkillCommon.scheduleWandTipElementTrail(u47, v52, {
            trailMaterialKey = "毒系尾迹",
            runEventKey = "巫毒领域Cast尾迹",
            enableAt = 0.23,
            disableAt = 0.9
        });
    end;

    local u53 = material["巫毒领域_法阵"];

    if u53 and u53:IsA("Model") then
        u53:ScaleTo(v50);
        VisibleMgr.UnQueryAll(u53);
        local Rotation = u53:GetPivot().Rotation;
        local v54 = v49.CFrame.Rotation:Inverse() * Rotation;
        u53:PivotTo(SkillCommon.resolveCasterFeetFormationCF(v49, v54, {
            extraLift = v51
        }));
        u53.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "VoodooDomainSpawned", u53);
        task.delay(0.717, function() -- Line: 313
            -- upvalues: SkillCommon (ref), u47 (copy), runGeneration (copy), u53 (copy), FXUtil (ref)
            if not (SkillCommon.isRunningSameGeneration(u47, runGeneration) and u53.Parent) then
                return;
            end;

            local v55 = u53;
            FXUtil.EmitBurstEmitInName(v55, true);
            FXUtil.SetEnableNameVfx(v55, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v55, true);
            SkillCommon.playSoundLocal3D("音效-技能-毒气弹-法阵", u53:GetPivot().Position);
        end);

        if u53 then
            local u56 = nil;
            local u57 = "VoodooDomainSpawned";
            local u58 = 2;
            task.delay(1.85, function() -- Line: 121
                -- upvalues: still (copy), u53 (copy), FXUtil (ref), u56 (copy), dropRunSpawnEntry (ref), skillRunData (copy), u57 (copy), u58 (copy)
                if not (still() and u53.Parent) then
                    return;
                end;

                FXUtil.OffEnableVfx(u53);

                if u56 then
                    dropRunSpawnEntry(skillRunData, u57, u53);
                end;

                task.delay(u58, function() -- Line: 129
                    -- upvalues: still (ref), u53 (ref)
                    if not (still() and u53.Parent) then
                        return;
                    end;

                    u53:Destroy();
                end);
            end);
        end;
    end;

    local u59 = material["巫毒领域_法杖"];

    if u59 and u59:IsA("Model") then
        u59:ScaleTo(v50);
        VisibleMgr.UnQueryAll(u59);
        u59.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "VoodooDomainSpawned", u59);
        task.delay(0.683, function() -- Line: 332
            -- upvalues: SkillCommon (ref), u47 (copy), runGeneration (copy), u59 (copy), FXUtil (ref), u48 (copy), skillRunData (copy), RunService (ref)
            if not (SkillCommon.isRunningSameGeneration(u47, runGeneration) and u59.Parent) then
                return;
            end;

            local v60 = SkillCommon.findDescendantByName(u59, "Enabled_普攻") or u59;
            FXUtil.EmitBurstEmitInName(v60, true);
            FXUtil.SetEnableNameVfx(v60, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v60, true);
            FXUtil.SetEnableNameVfx(u59, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(u59, true);

            local function pivotStaffToWandTip() -- Line: 341
                -- upvalues: SkillCommon (ref), u48 (ref), u59 (ref)
                local v61 = SkillCommon.resolveWandTipFromCharacter(u48);

                if v61 then
                    v61 = SkillCommon.resolveWandTipWorldCFrame(v61);
                end;

                if v61 and u59.Parent then
                    SkillCommon.pivotInstanceToWorldCF(u59, v61);
                end;
            end;

            local v62 = SkillCommon.resolveWandTipFromCharacter(u48);

            if v62 then
                v62 = SkillCommon.resolveWandTipWorldCFrame(v62);
            end;

            if v62 and u59.Parent then
                SkillCommon.pivotInstanceToWorldCF(u59, v62);
            end;

            SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域法杖跟魔杖尖端" });
            skillRunData.runEvent["巫毒领域法杖跟魔杖尖端"] = RunService.RenderStepped:Connect(function() -- Line: 351
                -- upvalues: SkillCommon (ref), u47 (ref), runGeneration (ref), u59 (ref), u48 (ref)
                if not (SkillCommon.isRunningSameGeneration(u47, runGeneration) and u59.Parent) then
                    return;
                end;

                local v63 = SkillCommon.resolveWandTipFromCharacter(u48);

                if v63 then
                    v63 = SkillCommon.resolveWandTipWorldCFrame(v63);
                end;

                if v63 and u59.Parent then
                    SkillCommon.pivotInstanceToWorldCF(u59, v63);
                end;
            end);
        end);

        if not u59 then
            return;
        end;

        local u64 = nil;
        local u65 = "VoodooDomainSpawned";
        local u66 = 2;
        task.delay(0.06699999999999995, function() -- Line: 121
            -- upvalues: still (copy), u59 (copy), FXUtil (ref), u64 (copy), dropRunSpawnEntry (ref), skillRunData (copy), u65 (copy), u66 (copy)
            if not (still() and u59.Parent) then
                return;
            end;

            FXUtil.OffEnableVfx(u59);

            if u64 then
                dropRunSpawnEntry(skillRunData, u65, u59);
            end;

            task.delay(u66, function() -- Line: 129
                -- upvalues: still (ref), u59 (ref)
                if not (still() and u59.Parent) then
                    return;
                end;

                u59:Destroy();
            end);
        end);
    end;
end;

function v1.Client_ExitStartup(p67) -- Line: 362
    -- upvalues: SkillCommon (copy)
    local skillRunData = p67.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域法杖跟魔杖尖端" });
    end;
end;

function v1.Client_EnterMain(u68) -- Line: 369
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), sampleDomainGroundPos (copy), FXUtil (copy), dropRunSpawnEntry (copy), RunService (copy), u4 (copy)
    SkillCommon.flushPhase1AndRelease(u68);
    u68:releaseControl();
    local skillInputData = u68.skillInputData;
    local v69;

    if skillInputData then
        v69 = skillInputData.character;
    else
        v69 = skillInputData;
    end;

    local skillRunData = u68.skillRunData;

    if not (v69 and (skillInputData and (skillRunData and skillRunData.material))) then
        return;
    end;

    local _voodooDomainAnchor = skillRunData._voodooDomainAnchor;

    if not _voodooDomainAnchor then
        return;
    end;

    local runGeneration = u68.runGeneration;
    local u70 = SkillCommon.scaleBandFromData(u68, SkillCommon.bandScaleOptsFromSkillData(u68));
    local material = skillRunData.material;
    local domainGround = _voodooDomainAnchor.domainGround;
    local domainCenter = _voodooDomainAnchor.domainCenter;
    local domainRot = _voodooDomainAnchor.domainRot;
    local groundLift = _voodooDomainAnchor.groundLift;

    local function deploy(p71, p72, p73) -- Line: 397
        -- upvalues: u70 (copy), VisibleMgr (ref), SkillCommon (ref), skillRunData (copy)
        if not p71 then
            return;
        end;

        p71:ScaleTo(u70);
        VisibleMgr.UnQueryAll(p71);
        SkillCommon.pivotInstanceToWorldCF(p71, CFrame.new(p72) * (p73 or p71:GetPivot().Rotation));
        p71.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "VoodooDomainSpawned", p71);
    end;

    local v74 = Random.new((u68.combatSeed or 0) + 109004);
    local u75 = {};

    local function u79() -- Line: 393
        -- upvalues: u68 (copy), runGeneration (copy), skillRunData (copy)
        local v76 = u68;
        local v77 = skillRunData;

        if runGeneration ~= v76.runGeneration then
            return false;
        end;

        if v76:isRunningFlow() then
            return true;
        end;

        local v78;

        if v77 == nil then
            v78 = false;
        else
            v78 = v77._voodooDomainDeployed == true;
        end;

        return v78;
    end;

    for _ = 1, 20 do
        local v80 = sampleDomainGroundPos(domainGround, 37.5 * u70, v74, 4, groundLift);
        table.insert(u75, v80);
    end;

    task.delay(0.25, function() -- Line: 417
        -- upvalues: u68 (copy), runGeneration (copy), skillRunData (copy), material (copy), deploy (copy), domainGround (copy), FXUtil (ref), u79 (copy), dropRunSpawnEntry (ref)
        local v81 = u68;
        local v82 = skillRunData;
        local v83;

        if runGeneration == v81.runGeneration then
            if v81:isRunningFlow() then
                v83 = true;
            elseif v82 == nil then
                v83 = false;
            else
                v83 = v82._voodooDomainDeployed == true;
            end;
        else
            v83 = false;
        end;

        if not v83 then
            return;
        end;

        local u84 = material["巫毒领域_起手地面特效"];

        if u84 and u84:IsA("Model") then
            deploy(u84, domainGround);
            FXUtil.EmitBurstEmitInName(u84, true);
            FXUtil.SetEnableNameVfx(u84, true);
            local u85 = u79;
            local u86 = skillRunData;

            if not u84 then
                return;
            end;

            local u87 = true;
            local u88 = "VoodooDomainSpawned";
            local u89 = 2;
            task.delay(3.767, function() -- Line: 121
                -- upvalues: u85 (copy), u84 (copy), FXUtil (ref), u87 (copy), dropRunSpawnEntry (ref), u86 (copy), u88 (copy), u89 (copy)
                if not (u85() and u84.Parent) then
                    return;
                end;

                FXUtil.OffEnableVfx(u84);

                if u87 then
                    dropRunSpawnEntry(u86, u88, u84);
                end;

                task.delay(u89, function() -- Line: 129
                    -- upvalues: u85 (ref), u84 (ref)
                    if not (u85() and u84.Parent) then
                        return;
                    end;

                    u84:Destroy();
                end);
            end);
        end;
    end);
    local u90 = material["巫毒领域_球形领域"];
    local u91 = material["巫毒领域_地面领域"];
    local u92 = nil;
    local u93 = nil;
    task.delay(0.233, function() -- Line: 434
        -- upvalues: u68 (copy), runGeneration (copy), skillRunData (copy), u90 (copy), u92 (ref), u70 (copy), VisibleMgr (ref), domainCenter (copy), domainRot (copy), SkillCommon (ref), FXUtil (ref), RunService (ref), u91 (copy), u93 (ref), domainGround (copy), u79 (copy), dropRunSpawnEntry (ref)
        local v94 = u68;
        local v95 = skillRunData;
        local v96;

        if runGeneration == v94.runGeneration then
            if v94:isRunningFlow() then
                v96 = true;
            elseif v95 == nil then
                v96 = false;
            else
                v96 = v95._voodooDomainDeployed == true;
            end;
        else
            v96 = false;
        end;

        if not v96 then
            return;
        end;

        skillRunData._voodooDomainDeployed = true;

        if u90 and u90:IsA("Model") then
            u92 = u90;
            u92:ScaleTo(u70);
            VisibleMgr.UnQueryAll(u92);
            u92:PivotTo(CFrame.new(domainCenter) * domainRot);
            u92.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "VoodooDomainSpawned", u92);
            u92:SetAttribute("ModelScale", u70);
            u92:SetAttribute("Scale", 0.01);
            FXUtil.Set_Scale_Model(u92, 0.01);
            local u97 = u92:FindFirstChild("主节点");
            local u98;

            if u97 and (u97:IsA("Model") or u97:IsA("BasePart")) then
                local v99 = u92:GetPivot();
                local v100;

                if u97:IsA("Model") then
                    v100 = u97:GetPivot();
                else
                    v100 = u97:GetPivot();
                end;

                u98 = v99:ToObjectSpace(v100);
            else
                u98 = nil;
            end;

            local u101 = 0;
            local u102 = 0;
            SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域主节点自转" });
            skillRunData.runEvent["巫毒领域主节点自转"] = RunService.Heartbeat:Connect(function(p103) -- Line: 462
                -- upvalues: u68 (ref), runGeneration (ref), skillRunData (ref), u92 (ref), u97 (copy), u98 (ref), u102 (ref), u101 (ref)
                local v104 = u68;
                local v105 = skillRunData;
                local v106;

                if runGeneration == v104.runGeneration then
                    if v104:isRunningFlow() then
                        v106 = true;
                    elseif v105 == nil then
                        v106 = false;
                    else
                        v106 = v105._voodooDomainDeployed == true;
                    end;
                else
                    v106 = false;
                end;

                if not (v106 and (u92 and (u92.Parent and (u97 and u97.Parent)))) then
                    return;
                end;

                local v107 = u98;

                if not v107 then
                    return;
                end;

                u102 = u102 + p103;
                u101 = u101 + (u102 < 3.784 and 1 or 1 - math.clamp((u102 - 3.784) / 0.4, 0, 1)) * 5 * p103;
                local v108 = u92:GetPivot() * v107 * CFrame.Angles(0, math.rad(u101), 0);

                if u97:IsA("Model") then
                    u97:PivotTo(v108);

                    return;
                end;

                if u97:IsA("BasePart") then
                    u97:PivotTo(v108);
                end;
            end);
            task.delay(3.784, function() -- Line: 484
                -- upvalues: u68 (ref), runGeneration (ref), skillRunData (ref), u92 (ref), FXUtil (ref)
                local v109 = u68;
                local v110 = skillRunData;
                local v111;

                if runGeneration == v109.runGeneration then
                    if v109:isRunningFlow() then
                        v111 = true;
                    elseif v110 == nil then
                        v111 = false;
                    else
                        v111 = v110._voodooDomainDeployed == true;
                    end;
                else
                    v111 = false;
                end;

                if not (v111 and (u92 and u92.Parent)) then
                    return;
                end;

                FXUtil.Instance_Transparency_Tween(u92, 0.4, 1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
            end);
            task.delay(4.184, function() -- Line: 490
                -- upvalues: SkillCommon (ref), skillRunData (ref), u92 (ref)
                SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域主节点自转" });

                if u92 and u92.Parent then
                    u92:Destroy();
                end;
            end);
        end;

        if u91 and u91:IsA("Model") then
            u93 = u91;
            u93:ScaleTo(u70);
            VisibleMgr.UnQueryAll(u93);
            u93:PivotTo(CFrame.new(domainGround) * domainRot);
            u93.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "VoodooDomainSpawned", u93);
            u93:SetAttribute("ModelScale", u70);
            u93:SetAttribute("Scale", 0.01);
            FXUtil.Set_Scale_Model(u93, 0.01);
            local v112 = u93;
            FXUtil.EmitBurstEmitInName(v112, true);
            FXUtil.SetEnableNameVfx(v112, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v112, true);
            local u113 = u79;
            local u114 = skillRunData;
            local u115 = u93;

            if u115 then
                local u116 = true;
                local u117 = "VoodooDomainSpawned";
                local u118 = 2;
                task.delay(3.784, function() -- Line: 121
                    -- upvalues: u113 (copy), u115 (copy), FXUtil (ref), u116 (copy), dropRunSpawnEntry (ref), u114 (copy), u117 (copy), u118 (copy)
                    if not (u113() and u115.Parent) then
                        return;
                    end;

                    FXUtil.OffEnableVfx(u115);

                    if u116 then
                        dropRunSpawnEntry(u114, u117, u115);
                    end;

                    task.delay(u118, function() -- Line: 129
                        -- upvalues: u113 (ref), u115 (ref)
                        if not (u113() and u115.Parent) then
                            return;
                        end;

                        u115:Destroy();
                    end);
                end);
            end;
        end;

        task.delay(0.017, function() -- Line: 513
            -- upvalues: u68 (ref), runGeneration (ref), skillRunData (ref), u92 (ref), FXUtil (ref), SkillCommon (ref), domainCenter (ref), u93 (ref)
            local v119 = u68;
            local v120 = skillRunData;
            local v121;

            if runGeneration == v119.runGeneration then
                if v119:isRunningFlow() then
                    v121 = true;
                elseif v120 == nil then
                    v121 = false;
                else
                    v121 = v120._voodooDomainDeployed == true;
                end;
            else
                v121 = false;
            end;

            if v121 and (u92 and u92.Parent) then
                FXUtil.Set_Scale_Model_Tween(u92, 0.767, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                SkillCommon.playSoundLocal3D("音效-技能-巫毒领域-攻击", domainCenter);
            end;

            local v122 = u68;
            local v123 = skillRunData;
            local v124;

            if runGeneration == v122.runGeneration then
                if v122:isRunningFlow() then
                    v124 = true;
                elseif v123 == nil then
                    v124 = false;
                else
                    v124 = v123._voodooDomainDeployed == true;
                end;
            else
                v124 = false;
            end;

            if v124 and (u93 and u93.Parent) then
                FXUtil.Set_Scale_Model_Tween(u93, 0.767, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            end;
        end);
    end);
    task.delay(0.7, function() -- Line: 524
        -- upvalues: u68 (copy), runGeneration (copy), skillRunData (copy), material (copy), deploy (copy), domainCenter (copy), domainRot (copy), FXUtil (ref), u79 (copy), dropRunSpawnEntry (ref)
        local v125 = u68;
        local v126 = skillRunData;
        local v127;

        if runGeneration == v125.runGeneration then
            if v125:isRunningFlow() then
                v127 = true;
            elseif v126 == nil then
                v127 = false;
            else
                v127 = v126._voodooDomainDeployed == true;
            end;
        else
            v127 = false;
        end;

        if not v127 then
            return;
        end;

        local u128 = material["巫毒领域_领域展开后开启"];

        if not (u128 and u128:IsA("Model")) then
            return;
        end;

        deploy(u128, domainCenter, domainRot);
        FXUtil.EmitBurstEmitInName(u128, true);
        FXUtil.SetEnableNameVfx(u128, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(u128, true);
        local u129 = u79;
        local u130 = skillRunData;

        if not u128 then
            return;
        end;

        local u131 = true;
        local u132 = "VoodooDomainSpawned";
        local u133 = 3.5;
        task.delay(4.317, function() -- Line: 121
            -- upvalues: u129 (copy), u128 (copy), FXUtil (ref), u131 (copy), dropRunSpawnEntry (ref), u130 (copy), u132 (copy), u133 (copy)
            if not (u129() and u128.Parent) then
                return;
            end;

            FXUtil.OffEnableVfx(u128);

            if u131 then
                dropRunSpawnEntry(u130, u132, u128);
            end;

            task.delay(u133, function() -- Line: 129
                -- upvalues: u129 (ref), u128 (ref)
                if not (u129() and u128.Parent) then
                    return;
                end;

                u128:Destroy();
            end);
        end);
    end);
    local u134 = material["巫毒领域_领域展开地面毒特效"];

    for i, v in u4 do
        task.delay(v, function() -- Line: 540
            -- upvalues: u68 (copy), runGeneration (copy), skillRunData (copy), u134 (copy), u70 (copy), VisibleMgr (ref), u75 (copy), i (copy), domainGround (copy), SkillCommon (ref), FXUtil (ref)
            local v135 = u68;
            local v136 = skillRunData;
            local v137;

            if runGeneration == v135.runGeneration then
                if v135:isRunningFlow() then
                    v137 = true;
                elseif v136 == nil then
                    v137 = false;
                else
                    v137 = v136._voodooDomainDeployed == true;
                end;
            else
                v137 = false;
            end;

            if not v137 then
                return;
            end;

            if not (u134 and u134:IsA("Model")) then
                return;
            end;

            local u138 = u134:Clone();
            u138:ScaleTo(u70);
            VisibleMgr.UnQueryAll(u138);
            SkillCommon.pivotModelAtWorldPosKeepRotation(u138, u75[i] or domainGround);
            u138.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "VoodooDomainSpawned", u138);
            FXUtil.EmitBurstEmitInName(u138, true);
            task.delay(2, function() -- Line: 555
                -- upvalues: u138 (copy)
                if u138.Parent then
                    u138:Destroy();
                end;
            end);
        end);
    end;

    SkillCommon.scheduleRunSpawnClear(u68, runGeneration, skillRunData, "VoodooDomainSpawned", 8.6);
end;

function v1.Client_ExitMain(p139) -- Line: 566
    -- upvalues: SkillCommon (copy), u2 (copy)
    local skillRunData = p139.skillRunData;

    if skillRunData and skillRunData._voodooDomainDeployed then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p139.skillRunData, { u2.staffFollow, u2.mainNodeSpin, u2.hitPulse });
end;

function v1.Client_EnterRecovery(p140) -- Line: 574
    -- upvalues: SkillCommon (copy)
    local skillRunData = p140.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "巫毒领域Cast尾迹");
    end;
end;

function v1.Client_ExitRecovery(p141) -- Line: 581
    -- upvalues: SkillCommon (copy)
    local skillRunData = p141.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p141, p141.runGeneration, skillRunData, "VoodooDomainSpawned");
    end;
end;

function v1.onEnd(p142) -- Line: 588
    -- upvalues: SkillCommon (copy), u2 (copy)
    local skillRunData = p142.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "毒系尾迹", "巫毒领域Cast尾迹");
        SkillCommon.disconnectRunEventKeys(skillRunData, { u2.staffFollow });
    end;

    local skillRunData2 = p142.skillRunData;

    if skillRunData2 and skillRunData2._voodooDomainDeployed then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p142.skillRunData, { u2.staffFollow, u2.mainNodeSpin, u2.hitPulse });
end;

function v1.Server_EnterStartup(p143) -- Line: 597
    -- upvalues: SkillCommon (copy), cacheDomainAnchor (copy)
    local skillInputData = p143.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if character then
        character = character:FindFirstChild("HumanoidRootPart");
    end;

    local v144 = p143.hitbox[1];

    if not (v144 and (v144.hitbox and character)) then
        return;
    end;

    local v145 = SkillCommon.scaleBandFromData(p143, SkillCommon.bandScaleOptsFromSkillData(p143));
    local hitbox = v144.hitbox;
    local v146 = 90 * v145;
    hitbox.Size = Vector3.new(v146, v146 * 0.5, v146);
    hitbox:PivotTo(CFrame.new(0, -5000, 0));
    cacheDomainAnchor(p143.skillRunData, character, v145, v146);
end;

function v1.Server_EnterMain(u147) -- Line: 619
    -- upvalues: SkillCommon (copy), RunService (copy), u3 (copy)
    SkillCommon.flushPhase1AndRelease(u147);
    u147:releaseControl();
    local skillRunData = u147.skillRunData;
    local v148;

    if skillRunData then
        v148 = skillRunData._voodooDomainAnchor;
    else
        v148 = skillRunData;
    end;

    local u149 = u147.hitbox[1];

    if not (v148 and (u149 and (u149.hitbox and v148.lockCF))) then
        return;
    end;

    local hitbox = u149.hitbox;
    local lockCF = v148.lockCF;
    local runGeneration = u147.runGeneration;
    local u150 = 0;
    local u151 = 0;
    SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域命中脉冲" });
    skillRunData.runEvent["巫毒领域命中脉冲"] = RunService.Heartbeat:Connect(function(p152) -- Line: 637
        -- upvalues: u147 (copy), runGeneration (copy), skillRunData (copy), SkillCommon (ref), u151 (ref), u150 (ref), u3 (ref), hitbox (copy), lockCF (copy), u149 (copy)
        local v153 = u147;
        local v154 = skillRunData;
        local v155;

        if runGeneration == v153.runGeneration then
            if v153:isRunningFlow() then
                v155 = true;
            elseif v154 == nil then
                v155 = false;
            else
                v155 = v154._voodooDomainDeployed == true;
            end;
        else
            v155 = false;
        end;

        if not v155 then
            SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域命中脉冲" });

            return;
        end;

        u151 = u151 + p152;

        while u150 < #u3 and u151 >= u3[u150 + 1] do
            u150 = u150 + 1;

            if u150 == 1 then
                skillRunData._voodooDomainDeployed = true;
            end;

            hitbox:PivotTo(lockCF);
            u149:start();
            task.delay(0.12, function() -- Line: 650
                -- upvalues: u149 (ref)
                if u149.isActive then
                    u149:stop();
                end;
            end);
        end;

        if u151 >= u3[#u3] + 0.15 then
            SkillCommon.disconnectRunEventKeys(skillRunData, { "巫毒领域命中脉冲" });
        end;
    end);
end;

function v1.Server_ExitMain(p156) -- Line: 662
    -- upvalues: SkillCommon (copy), u2 (copy)
    local skillRunData = p156.skillRunData;

    if skillRunData and skillRunData._voodooDomainDeployed then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p156.skillRunData, { u2.staffFollow, u2.mainNodeSpin, u2.hitPulse });
    local v157 = p156.hitbox[1];

    if v157 and v157.isActive then
        v157:stop();
    end;
end;

function v1.Server_EnterRecovery(p158) -- Line: 674
end;

function v1.Server_ExitRecovery(p159) -- Line: 676
    local v160 = p159.hitbox[1];

    if v160 and v160.isActive then
        v160:stop();
    end;
end;

function v1.onEndServer(p161) -- Line: 683
    -- upvalues: SkillCommon (copy), u2 (copy)
    local skillRunData = p161.skillRunData;

    if skillRunData and skillRunData._voodooDomainDeployed then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p161.skillRunData, { u2.staffFollow, u2.mainNodeSpin, u2.hitPulse });
    local v162 = p161.hitbox[1];

    if v162 and v162.isActive then
        v162:stop();
    end;
end;

v1.AnimateList = { "技能释放动作4" };
v1.ResNameList = { "毒系尾迹", "巫毒领域_法阵", "巫毒领域_法杖", "巫毒领域_起手地面特效", "巫毒领域_球形领域", "巫毒领域_地面领域", "巫毒领域_领域展开后开启", "巫毒领域_领域展开地面毒特效" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "毒属性受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.SoundList = { "音效-技能-毒气弹-法阵", "音效-技能-巫毒领域-攻击" };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.75,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.32,
        animationName = "技能释放动作4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;