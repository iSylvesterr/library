-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64
};
local u2 = { "火流星Cast尾迹" };
v1.InitialState = "Startup";
v1.ControlOpenState = "MeteorFalling";
v1.States = {
    Startup = {
        Duration = 1.33,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    MeteorFalling = {
        Duration = 1.2,
        OnEnterClient = "Client_EnterMeteorFalling",
        OnEnterServer = "Server_EnterMeteorFalling",
        OnExitClient = "Client_ExitMeteorFalling",
        OnExitServer = "Server_ExitMeteorFalling"
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
v1.Transitions = {
    {
        From = "Startup",
        To = "MeteorFalling",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "MeteorFalling",
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
        From = "MeteorFalling",
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
        From = "MeteorFalling",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function still(p3, p4) -- Line: 94
    local v5 = p3:isRunningFlow();

    if v5 then
        if p3.runGeneration == p4 then
            v5 = not p3:isTerminal();
        else
            v5 = false;
        end;
    end;

    return v5;
end;

local function commitStrike(p6) -- Line: 98
    -- upvalues: SkillCommon (copy)
    return SkillCommon.commitLockedStrike(p6, "fireMeteorLocked");
end;

local function refreshLockedStrike(p7) -- Line: 103
    -- upvalues: SkillCommon (copy), commitStrike (copy)
    SkillCommon.refreshSkillAimSnapshot(p7);
    local skillRunData = p7.skillRunData;

    if skillRunData.Logic then
        skillRunData.Logic.fireMeteorLocked = nil;
    end;

    return commitStrike(p7);
end;

local function pentagonOffsets(p8, p9, p10) -- Line: 112
    local v11 = {};

    for i = 0, 4 do
        local v12 = math.rad(i * 72 + -90);
        v11[i + 1] = p9 * math.cos(v12) * p10 + p8 * math.sin(v12) * p10;
    end;

    return v11;
end;

local function resolveLandCF(p13, p14) -- Line: 124
    -- upvalues: FXUtil (copy)
    return FXUtil.GetGroundAlignedCF(p13, p14, "Ground", 3, 0.1) or CFrame.new(p13 + Vector3.new(0, 0.1, 0));
end;

local function landCFAtStrike(p15) -- Line: 132
    -- upvalues: resolveLandCF (copy)
    return resolveLandCF(p15.groundCenter, p15.forward);
end;

local function spawnCenterFromCaster(p16) -- Line: 136
    return p16:GetPivot():PointToWorldSpace(Vector3.new(60, 60, 60));
end;

local function spawnTimeForIndex(p17) -- Line: 140
    return (p17 - 1) * 0.25 + 0.33;
end;

local function fallStartForIndex(p18) -- Line: 144
    return (p18 - 1) * 0.15 + 1.33;
end;

local function impactTimeForIndex(p19) -- Line: 148
    return (p19 - 1) * 0.15 + 1.33 + 0.5;
end;

local function spawnClearAtSec() -- Line: 153
    return 1.9300000000000002 + 0.5 + 2;
end;

local function setupMeteorFireballVisual(p20, p21) -- Line: 157
    -- upvalues: FXUtil (copy)
    p20:ScaleTo(p21);

    for _, descendant in pairs(p20:GetDescendants()) do
        if descendant:IsA("Beam") then
            descendant.Enabled = true;
            FXUtil.Beam_Fade_From_Transparent(descendant, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;

        if descendant:IsA("MeshPart") then
            descendant.Transparency = 0;
        end;
    end;

    FXUtil.Start_All_Emit(p20, 10);
end;

local function runFireballFall(u22, u23, p24, u25, u26, u27, u28) -- Line: 171
    -- upvalues: RunService (copy)
    local u29 = "火流星坠落_" .. p24;
    local u30 = 0;
    u22.skillRunData.runEvent[u29] = RunService.Heartbeat:Connect(function(p31) -- Line: 183
        -- upvalues: u22 (copy), u23 (copy), u25 (copy), u29 (copy), u30 (ref), u28 (copy), u26 (copy), u27 (copy)
        local v32 = u22;
        local v33 = u23;
        local v34 = v32:isRunningFlow();

        if v34 then
            if v32.runGeneration == v33 then
                v34 = not v32:isTerminal();
            else
                v34 = false;
            end;
        end;

        if not (v34 and u25.Parent) then
            local v35 = u22.skillRunData.runEvent[u29];

            if v35 then
                v35:Disconnect();
                u22.skillRunData.runEvent[u29] = nil;
            end;

            return;
        end;

        u30 = u30 + p31;
        local v36 = math.max(u28, 0.05);
        local v37 = game.TweenService:GetValue(math.clamp(u30 / v36, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        u25:PivotTo(u26:Lerp(u27, v37));
        local v38 = v37 >= 1 and u22.skillRunData.runEvent[u29];

        if v38 then
            v38:Disconnect();
            u22.skillRunData.runEvent[u29] = nil;
        end;
    end);
end;

local u39 = { "音效-技能-火流星-爆炸1", "音效-技能-火流星-爆炸2", "音效-技能-火流星-爆炸3", "音效-技能-火流星-爆炸4", "音效-技能-火流星-爆炸5" };

local function clientExplosionAtLand(p40, p41, p42, p43, p44, p45) -- Line: 214
    -- upvalues: VisibleMgr (copy), FXUtil (copy), SkillCommon (copy), u39 (copy)
    local v46 = p40:isRunningFlow();

    if v46 then
        if p40.runGeneration == p41 then
            v46 = not p40:isTerminal();
        else
            v46 = false;
        end;
    end;

    if not v46 then
        return;
    end;

    local v47 = p45.material["火流星_爆炸"];

    if v47 then
        local v48 = v47:Clone();

        if v48:IsA("Model") then
            v48:ScaleTo(p44);
        end;

        VisibleMgr.UnQueryAll(v48);
        v48:PivotTo(p43);
        v48.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v48, true);
        SkillCommon.appendRunSpawnList(p45, "FireMeteorSpawned", v48);
    end;

    SkillCommon.playSoundLocal3D(u39[p42] or u39[1], p43.Position);
end;

function v1.Client_EnterStartup(u49) -- Line: 243
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), setupMeteorFireballVisual (copy), pentagonOffsets (copy), FXUtil (copy), RunService (copy), clientExplosionAtLand (copy)
    local character = u49.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v50 = SkillCommon.resolveWandTipFromCharacter(character);

    if v50 then
        SkillCommon.scheduleWandTipElementTrail(u49, v50, {
            trailMaterialKey = "火系尾迹",
            runEventKey = "火流星Cast尾迹",
            enableAt = 0.17,
            disableAt = 1.33
        });
    end;

    local runGeneration = u49.runGeneration;
    local skillRunData = u49.skillRunData;
    local u51 = SkillCommon.scaleBandFromData(u49, SkillCommon.bandScaleOptsFromSkillData(u49));
    local u52 = skillRunData.material["火流星_火球Enabled"];

    if not u52 then
        return;
    end;

    if not skillRunData.Logic then
        skillRunData.Logic = {};
    end;

    skillRunData.Logic.fireMeteorBalls = {};
    local skillInputData = u49.skillInputData;
    local u53 = HumanoidRootPart:GetPivot():PointToWorldSpace(Vector3.new(60, 60, 60));
    local u54 = 7 * u51;

    for i = 1, 5 do
        task.delay((i - 1) * 0.25 + 0.33, function() -- Line: 280
            -- upvalues: u49 (copy), runGeneration (copy), u52 (copy), VisibleMgr (ref), setupMeteorFireballVisual (ref), u51 (copy), SkillCommon (ref), skillInputData (copy), HumanoidRootPart (copy), pentagonOffsets (ref), u54 (copy), u53 (copy), i (copy), skillRunData (copy)
            local v55 = u49;
            local v56 = runGeneration;
            local v57 = v55:isRunningFlow();

            if v57 then
                if v55.runGeneration == v56 then
                    v57 = not v55:isTerminal();
                else
                    v57 = false;
                end;
            end;

            if not v57 then
                return;
            end;

            local v58 = u52:Clone();

            if not v58:IsA("Model") then
                if v58.Parent then
                    v58:Destroy();
                end;

                return;
            end;

            VisibleMgr.UnQueryAll(v58);
            setupMeteorFireballVisual(v58, u51);
            SkillCommon.refreshSkillAimSnapshot(u49);
            local v59 = SkillCommon.resolveStrikeWorldPos(skillInputData);
            local v60, v61 = SkillCommon.horizontalHrpStrikeFlatBasis(HumanoidRootPart, v59);
            local v62 = u53 + pentagonOffsets(v60, v61, u54)[i];
            local v63 = CFrame.lookAt(v62, v62 + v61);
            v58:PivotTo(v63);
            v58.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "FireMeteorSpawned", v58);
            skillRunData.Logic.fireMeteorBalls[i] = {
                model = v58,
                startCF = v63
            };
        end);
    end;

    task.delay(1.33, function() -- Line: 309
        -- upvalues: u49 (copy), runGeneration (copy), skillRunData (copy), HumanoidRootPart (copy), u51 (copy), FXUtil (ref), SkillCommon (ref)
        local v64 = u49;
        local v65 = runGeneration;
        local v66 = v64:isRunningFlow();

        if v66 then
            if v64.runGeneration == v65 then
                v66 = not v64:isTerminal();
            else
                v66 = false;
            end;
        end;

        if not v66 then
            return;
        end;

        local v67 = skillRunData.material["火流星_法阵"];

        if v67 then
            local v68 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(0, 0, -2));
            v67:ScaleTo(u51);
            v67:PivotTo(v68 * CFrame.Angles(1.5707963267948966, 0, 0));
            v67.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v67, true);
            SkillCommon.playSoundLocal3D("音效-技能-火法阵2", v67:GetPivot().Position);
            SkillCommon.appendRunSpawnList(skillRunData, "FireMeteorSpawned", v67);
        end;
    end);

    for i = 1, 5 do
        task.delay((i - 1) * 0.15 + 1.33, function() -- Line: 326
            -- upvalues: u49 (copy), runGeneration (copy), skillRunData (copy), i (copy), SkillCommon (ref), FXUtil (ref), RunService (ref), clientExplosionAtLand (ref), u51 (copy)
            local v69 = u49;
            local v70 = runGeneration;
            local v71 = v69:isRunningFlow();

            if v71 then
                if v69.runGeneration == v70 then
                    v71 = not v69:isTerminal();
                else
                    v71 = false;
                end;
            end;

            if not v71 then
                return;
            end;

            local u72 = skillRunData.Logic.fireMeteorBalls[i];

            if not (u72 and u72.model.Parent) then
                return;
            end;

            local v73 = u49;
            SkillCommon.refreshSkillAimSnapshot(v73);
            local skillRunData2 = v73.skillRunData;

            if skillRunData2.Logic then
                skillRunData2.Logic.fireMeteorLocked = nil;
            end;

            local v74 = SkillCommon.commitLockedStrike(v73, "fireMeteorLocked");
            local groundCenter = v74.groundCenter;
            local u75 = FXUtil.GetGroundAlignedCF(groundCenter, v74.forward, "Ground", 3, 0.1) or CFrame.new(groundCenter + Vector3.new(0, 0.1, 0));
            u72.landCF = u75;
            local model = u72.model;
            local u76 = model:GetPivot();
            local u77 = u49;
            local u78 = runGeneration;
            local u79 = "火流星坠落_" .. i;
            local u80 = 0;
            local u81 = 0.5;
            u77.skillRunData.runEvent[u79] = RunService.Heartbeat:Connect(function(p82) -- Line: 183
                -- upvalues: u77 (copy), u78 (copy), model (copy), u79 (copy), u80 (ref), u81 (copy), u76 (copy), u75 (copy)
                local v83 = u77;
                local v84 = u78;
                local v85 = v83:isRunningFlow();

                if v85 then
                    if v83.runGeneration == v84 then
                        v85 = not v83:isTerminal();
                    else
                        v85 = false;
                    end;
                end;

                if not (v85 and model.Parent) then
                    local v86 = u77.skillRunData.runEvent[u79];

                    if v86 then
                        v86:Disconnect();
                        u77.skillRunData.runEvent[u79] = nil;
                    end;

                    return;
                end;

                u80 = u80 + p82;
                local v87 = math.max(u81, 0.05);
                local v88 = game.TweenService:GetValue(math.clamp(u80 / v87, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                model:PivotTo(u76:Lerp(u75, v88));
                local v89 = v88 >= 1 and u77.skillRunData.runEvent[u79];

                if v89 then
                    v89:Disconnect();
                    u77.skillRunData.runEvent[u79] = nil;
                end;
            end);
            local Position = u76.Position;

            if i == 1 then
                SkillCommon.playSoundLocal3D("音效-技能-火流星-飞行1", Position);
            elseif i == 5 then
                SkillCommon.playSoundLocal3D("音效-技能-火流星-飞行2", Position);
            end;

            task.delay(0.5, function() -- Line: 347
                -- upvalues: u49 (ref), runGeneration (ref), model (copy), u72 (copy), FXUtil (ref), clientExplosionAtLand (ref), i (ref), u51 (ref), skillRunData (ref)
                local v90 = u49;
                local v91 = runGeneration;
                local v92 = v90:isRunningFlow();

                if v92 then
                    if v90.runGeneration == v91 then
                        v92 = not v90:isTerminal();
                    else
                        v92 = false;
                    end;
                end;

                if not v92 then
                    return;
                end;

                if model.Parent then
                    model:PivotTo(u72.landCF);
                end;

                FXUtil.Stop_All_Emit(model);
                FXUtil.FadeModel_KeepTrails(model, 0.1, 2);
                clientExplosionAtLand(u49, runGeneration, i, u72.landCF, u51, skillRunData);
            end);
        end);
    end;

    SkillCommon.scheduleRunSpawnClear(u49, runGeneration, skillRunData, "FireMeteorSpawned", 1.9300000000000002 + 0.5 + 2);
end;

function v1.Server_EnterStartup(u93) -- Line: 364
    -- upvalues: SkillCommon (copy)
    local runGeneration = u93.runGeneration;
    local skillRunData = u93.skillRunData;

    if not skillRunData.Logic then
        skillRunData.Logic = {};
    end;

    skillRunData.Logic.fireMeteorStrikeByIdx = {};
    local v94 = 14 * SkillCommon.scaleBandFromData(u93, SkillCommon.bandScaleOptsFromSkillData(u93));
    local u95 = Vector3.new(v94, v94, v94);

    for i = 1, 5 do
        task.delay((i - 1) * 0.15 + 1.33, function() -- Line: 377
            -- upvalues: u93 (copy), runGeneration (copy), skillRunData (copy), i (copy), SkillCommon (ref)
            if not u93:isRunningFlow() or u93.runGeneration ~= runGeneration then
                return;
            end;

            local fireMeteorStrikeByIdx = skillRunData.Logic.fireMeteorStrikeByIdx;
            local v96 = u93;
            SkillCommon.refreshSkillAimSnapshot(v96);
            local skillRunData2 = v96.skillRunData;

            if skillRunData2.Logic then
                skillRunData2.Logic.fireMeteorLocked = nil;
            end;

            fireMeteorStrikeByIdx[i] = SkillCommon.commitLockedStrike(v96, "fireMeteorLocked");
        end);
        task.delay((i - 1) * 0.15 + 1.33 + 0.5, function() -- Line: 385
            -- upvalues: u93 (copy), runGeneration (copy), skillRunData (copy), i (copy), u95 (copy)
            if not u93:isRunningFlow() or u93.runGeneration ~= runGeneration then
                return;
            end;

            local v97 = skillRunData.Logic.fireMeteorStrikeByIdx[i];

            if not v97 then
                return;
            end;

            local v98 = CFrame.new(v97.hrpCenter);
            local u99 = u93.hitbox[i];

            if not (u99 and u99.hitbox) then
                return;
            end;

            local hitbox = u99.hitbox;

            if hitbox:IsA("BasePart") then
                hitbox.Shape = Enum.PartType.Ball;
            end;

            hitbox.Size = u95;
            hitbox:PivotTo(v98);
            u99:start();
            task.delay(0.1, function() -- Line: 405
                -- upvalues: u93 (ref), runGeneration (ref), u99 (copy)
                if u93:isRunningFlow() and (u93.runGeneration == runGeneration and u99.isActive) then
                    u99:stop();
                    u99.hitbox.Transparency = 1;
                end;
            end);
        end);
    end;
end;

function v1.Client_EnterMeteorFalling(p100) -- Line: 415
end;

function v1.Server_EnterMeteorFalling(p101) -- Line: 417
end;

function v1.Client_ExitMeteorFalling(p102) -- Line: 419
    -- upvalues: SkillCommon (copy)
    local skillRunData = p102.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData.runEvent then
        for i = 1, 5 do
            local v103 = "火流星坠落_" .. i;
            local v104 = skillRunData.runEvent[v103];

            if v104 then
                v104:Disconnect();
                skillRunData.runEvent[v103] = nil;
            end;
        end;
    end;

    SkillCommon.clearSpawnIfTerminalAfterExit(p102, p102.runGeneration, skillRunData, "FireMeteorSpawned");
end;

function v1.Server_ExitMeteorFalling(p105) -- Line: 437
    for i = 1, 5 do
        local v106 = p105.hitbox[i];

        if v106 and v106.isActive then
            v106:stop();
        end;
    end;
end;

function v1.Server_EnterRecovery(p107) -- Line: 446
    p107:releaseControl();
end;

function v1.Client_EnterRecovery(p108) -- Line: 450
    -- upvalues: SkillCommon (copy)
    local skillRunData = p108.skillRunData;

    if skillRunData and skillRunData.material then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "火系尾迹", "火流星Cast尾迹");
    end;
end;

function v1.onEnd(p109) -- Line: 457
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p109.skillRunData, u2);

    for i = 1, 5 do
        local v110 = "火流星坠落_" .. i;
        local v111 = p109.skillRunData and p109.skillRunData.runEvent and p109.skillRunData.runEvent[v110];

        if v111 then
            v111:Disconnect();
            p109.skillRunData.runEvent[v110] = nil;
        end;
    end;
end;

function v1.onEndServer(p112) -- Line: 469
    for i = 1, 5 do
        local v113 = p112.hitbox and p112.hitbox[i];

        if v113 and v113.isActive then
            v113:stop();
        end;
    end;
end;

v1.SoundList = { "音效-技能-火法阵2", "音效-技能-火流星-飞行1", "音效-技能-火流星-飞行2", "音效-技能-火流星-爆炸1", "音效-技能-火流星-爆炸2", "音效-技能-火流星-爆炸3", "音效-技能-火流星-爆炸4", "音效-技能-火流星-爆炸5" };
v1.AnimateList = { "技能释放动作5" };
v1.ResNameList = { "火流星_爆炸", "火流星_法阵", "火流星_火球Enabled", "火系尾迹" };
v1.hitboxConfig = (function(p114) -- Line: 497, Name: genHitboxConfig
    local v115 = {};

    for i = 1, p114 do
        v115[i] = {
            PartName = "通用球",
            CollisionGroup = "Player",
            HitPresentationProfile = "通用受击",
            PhysicsEffectName = "通用受击物理效果",
            HitboxIndex = i
        };
    end;

    return v115;
end)(5);
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 1.33,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.07,
        animationName = "技能释放动作5",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;