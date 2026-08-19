-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Water,
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "Pillar",
    States = {
        Startup = {
            Duration = 0.45,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Pillar = {
            Duration = 1.55,
            OnEnterClient = "Client_EnterPillar",
            OnEnterServer = "Server_EnterPillar",
            OnExitClient = "Client_ExitPillar",
            OnExitServer = "Server_ExitPillar"
        },
        Recovery = {
            Duration = 0.22,
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
            To = "Pillar",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Pillar",
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
            From = "Pillar",
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
            From = "Pillar",
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

local function getEndCF(p2) -- Line: 84
    -- upvalues: SkillCommon (copy)
    SkillCommon.refreshSkillAimSnapshot(p2);

    return SkillCommon.clampEndCF(SkillCommon.getHRPStartCF(p2), p2:getTargetCF(), 130, 0.75);
end;

local function registerSpawn(p3, p4, p5) -- Line: 89
    if not p3[p4] then
        p3[p4] = {};
    end;

    table.insert(p3[p4], p5);
end;

local function disconnectWaterColumnBeamReveal(p6) -- Line: 96
    if not p6 then
        return;
    end;

    local WaterColumnBeamRevealConn = p6.WaterColumnBeamRevealConn;

    if WaterColumnBeamRevealConn then
        WaterColumnBeamRevealConn:Disconnect();
        p6.WaterColumnBeamRevealConn = nil;
    end;
end;

local function fadeOutSpawnList(p7, p8, p9, p10) -- Line: 107
    -- upvalues: FXUtil (copy)
    if not p7 then
        return;
    end;

    local v11 = p10 and p7 and p7.WaterColumnBeamRevealConn;

    if v11 then
        v11:Disconnect();
        p7.WaterColumnBeamRevealConn = nil;
    end;

    local v12 = p7[p8];

    if not v12 then
        return;
    end;

    for _, v in v12 do
        if v and v.Parent then
            if v:IsA("Model") then
                FXUtil.Model_Fade(v, p9);
            end;

            FXUtil.Slow_Destroy_Instance(v, p9);
        end;
    end;

    p7[p8] = {};
end;

local function isEmitterUnderWaterSurface(p13) -- Line: 129
    local Parent = p13.Parent;

    while Parent do
        if Parent.Name == "水面" then
            return true;
        end;

        Parent = Parent.Parent;
    end;

    return false;
end;

local function scheduleGroundWaterSurfaceAndBeamsFade(u14) -- Line: 143
    -- upvalues: FXUtil (copy)
    task.delay(1.17, function() -- Line: 145
        -- upvalues: u14 (copy), FXUtil (ref)
        if not u14.Parent then
            return;
        end;

        for _, descendant in u14:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local Parent = descendant.Parent;
                local v15;

                while true do
                    if not Parent then
                        v15 = false;
                        break;
                    end;

                    if Parent.Name == "水面" then
                        v15 = true;
                        break;
                    end;

                    Parent = Parent.Parent;
                end;

                if v15 then
                    descendant.Enabled = false;
                end;
            end;
        end;

        for _, descendant in u14:GetDescendants() do
            if descendant:IsA("Beam") and (descendant.Name == "水柱" or descendant.Name == "水柱1") then
                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            end;
        end;
    end);
end;

local function emitBurstParticleExcludingWaterSurface(u16) -- Line: 162
    u16.Enabled = false;
    task.spawn(function() -- Line: 164
        -- upvalues: u16 (copy)
        local v17 = u16:GetAttribute("EmitDelay");
        local v18 = u16:GetAttribute("EmitCount") or 1;

        if v17 then
            task.wait(v17);
        end;

        if u16.Parent then
            u16:Emit(v18);
        end;
    end);
end;

local function enableWaterSurfaceEmittersOnly(p19) -- Line: 177
    for _, descendant in p19:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local Parent = descendant.Parent;
            local v20;

            while true do
                if not Parent then
                    v20 = false;
                    break;
                end;

                if Parent.Name == "水面" then
                    v20 = true;
                    break;
                end;

                Parent = Parent.Parent;
            end;

            if v20 then
                descendant.Enabled = true;
            end;
        end;
    end;
end;

local function emitBurstParticlesExceptWaterSurface(p21) -- Line: 185
    for _, descendant in p21:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local Parent = descendant.Parent;
            local v22;

            while true do
                if not Parent then
                    v22 = false;
                    break;
                end;

                if Parent.Name == "水面" then
                    v22 = true;
                    break;
                end;

                Parent = Parent.Parent;
            end;

            if not v22 then
                descendant.Enabled = false;
                task.spawn(function() -- Line: 164
                    -- upvalues: descendant (copy)
                    local v23 = descendant:GetAttribute("EmitDelay");
                    local v24 = descendant:GetAttribute("EmitCount") or 1;

                    if v23 then
                        task.wait(v23);
                    end;

                    if descendant.Parent then
                        descendant:Emit(v24);
                    end;
                end);
            end;
        end;
    end;
end;

local function startPillarGroundBeamsReveal(p25, p26) -- Line: 193
    -- upvalues: FXUtil (copy)
    local v27 = p26 and p26.WaterColumnBeamRevealConn;

    if v27 then
        v27:Disconnect();
        p26.WaterColumnBeamRevealConn = nil;
    end;

    local v28 = {};

    for _, descendant in p25:GetDescendants() do
        if descendant:IsA("Beam") and (descendant.Name == "水柱" or descendant.Name == "水柱1") then
            table.insert(v28, descendant);
        end;
    end;

    if #v28 == 0 then
        return;
    end;

    p26.WaterColumnBeamRevealConn = FXUtil.Beam_Reveal_From_Left(v28, 0.42, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
end;

local function playSkyPillarGroundDecalFx(u29, p30, p31) -- Line: 211
    -- upvalues: enableWaterSurfaceEmittersOnly (copy), startPillarGroundBeamsReveal (copy), emitBurstParticlesExceptWaterSurface (copy), FXUtil (copy)
    if not p31 then
        enableWaterSurfaceEmittersOnly(u29);
    end;

    startPillarGroundBeamsReveal(u29, p30);
    emitBurstParticlesExceptWaterSurface(u29);
    task.delay(1.17, function() -- Line: 145
        -- upvalues: u29 (copy), FXUtil (ref)
        if not u29.Parent then
            return;
        end;

        for _, descendant in u29:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                local Parent = descendant.Parent;
                local v32;

                while true do
                    if not Parent then
                        v32 = false;
                        break;
                    end;

                    if Parent.Name == "水面" then
                        v32 = true;
                        break;
                    end;

                    Parent = Parent.Parent;
                end;

                if v32 then
                    descendant.Enabled = false;
                end;
            end;
        end;

        for _, descendant in u29:GetDescendants() do
            if descendant:IsA("Beam") and (descendant.Name == "水柱" or descendant.Name == "水柱1") then
                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            end;
        end;
    end);
end;

local function trySpawnEarlyWaterSurfaceGroundFx(p33, p34, p35) -- Line: 223
    -- upvalues: SkillCommon (copy), FXUtil (copy), enableWaterSurfaceEmittersOnly (copy)
    if not p33:isRunningFlow() or (p33.runGeneration ~= p35 or p33:isTerminal()) then
        return;
    end;

    if p33.GetCurrentState and p33:GetCurrentState() ~= "Startup" then
        return;
    end;

    local skillRunData = p33.skillRunData;

    if not skillRunData or skillRunData.WaterColumnGroundFxEarly and skillRunData.WaterColumnGroundFxEarly.Parent then
        return;
    end;

    local character = p33.skillInputData.character;

    if character then
        character = character:FindFirstChild("HumanoidRootPart");
    end;

    if not character then
        return;
    end;

    local v36 = skillRunData.material["通天水柱_地面特效"];

    if not v36 then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(p33);
    local v37 = SkillCommon.clampEndCF(SkillCommon.getHRPStartCF(p33), p33:getTargetCF(), 130, 0.75);
    local v38 = p33:getTargetCF();
    local Position = SkillCommon.getGroundCF(v37).Position;
    local v39 = v38.Position - character.Position;
    local _, v40 = SkillCommon.scaleDualFromData(p33, SkillCommon.bandScaleOptsFromSkillData(p33));
    v36:ScaleTo(v40);
    local v41 = FXUtil.GetGroundAlignedCF(v37.Position, v39, "Ground");

    if v41 then
        v36:PivotTo(v41);
    else
        v36:PivotTo(CFrame.new(Position));
    end;

    v36.Parent = workspace.Debris;

    if not skillRunData.WaterColumnFootSpawned then
        skillRunData.WaterColumnFootSpawned = {};
    end;

    table.insert(skillRunData.WaterColumnFootSpawned, v36);
    enableWaterSurfaceEmittersOnly(v36);
    skillRunData.WaterColumnGroundFxEarly = v36;
end;

local function scheduleSplasherFxFadeWithGround(u42) -- Line: 266
    -- upvalues: FXUtil (copy)
    task.delay(1.07, function() -- Line: 268
        -- upvalues: u42 (copy), FXUtil (ref)
        if not u42.Parent then
            return;
        end;

        FXUtil.Stop_All_Emit(u42);

        if u42:IsA("Model") then
            FXUtil.Model_Fade(u42, 0.38);
        end;

        for _, descendant in u42:GetDescendants() do
            if descendant:IsA("Beam") then
                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
            end;
        end;
    end);
end;

function v1.Client_EnterStartup(u43) -- Line: 285
    -- upvalues: SkillCommon (copy), FXUtil (copy), trySpawnEarlyWaterSurfaceGroundFx (copy)
    local character = u43.skillInputData.character;

    if not character then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    local skillRunData = u43.skillRunData;

    if not skillRunData then
        return;
    end;

    local v44 = SkillCommon.resolveWandTipFromCharacter(character);

    if v44 then
        SkillCommon.scheduleWandTipElementTrail(u43, v44, {
            trailMaterialKey = "水系尾迹",
            runEventKey = "通天水柱Cast尾迹",
            enableAt = 0.3,
            disableAt = 0.9
        });
    end;

    local _, u45 = SkillCommon.scaleDualFromData(u43, SkillCommon.bandScaleOptsFromSkillData(u43));
    local runGeneration = u43.runGeneration;
    task.delay(0.73, function() -- Line: 313
        -- upvalues: u43 (copy), runGeneration (copy), SkillCommon (ref), u45 (copy), FXUtil (ref)
        if not u43:isRunningFlow() or (u43.runGeneration ~= runGeneration or u43:isTerminal()) then
            return;
        end;

        local character2 = u43.skillInputData.character;

        if character2 then
            character2 = character2:FindFirstChild("HumanoidRootPart");
        end;

        if not character2 then
            return;
        end;

        local skillRunData2 = u43.skillRunData;

        if not skillRunData2 then
            return;
        end;

        SkillCommon.refreshSkillAimSnapshot(u43);
        local v46 = u43:getTargetCF();
        local v47 = skillRunData2.material["通天水柱法阵"];

        if v47 then
            v47:ScaleTo(u45);
            v47:PivotTo(SkillCommon.formationCFHorizontal(character2, v46.Position, CFrame.new(0, 1.4, -2)));
            v47.Parent = workspace.Debris;

            if not skillRunData2.WaterColumnCircleSpawned then
                skillRunData2.WaterColumnCircleSpawned = {};
            end;

            table.insert(skillRunData2.WaterColumnCircleSpawned, v47);
            FXUtil.Emit_Particles_GetDescendants(v47, true);
            SkillCommon.playSoundLocal3D("音效-技能-水法阵", v47:GetPivot().Position);
        end;
    end);
    task.delay(0.25, function() -- Line: 343
        -- upvalues: trySpawnEarlyWaterSurfaceGroundFx (ref), u43 (copy), skillRunData (copy), runGeneration (copy)
        trySpawnEarlyWaterSurfaceGroundFx(u43, skillRunData, runGeneration);
    end);
end;

function v1.Server_EnterStartup(p48) -- Line: 349
    for i = 1, 3 do
        local v49 = p48.hitbox[i];

        if v49 and v49.hitbox then
            v49.hitbox.Size = Vector3.new(1, 1, 1);
            v49.hitbox:PivotTo(CFrame.new(0, -5000, 0));
        end;
    end;
end;

function v1.Client_EnterPillar(u50) -- Line: 360
    -- upvalues: SkillCommon (copy), FXUtil (copy), enableWaterSurfaceEmittersOnly (copy), startPillarGroundBeamsReveal (copy), emitBurstParticlesExceptWaterSurface (copy)
    local character = u50.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = u50.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u50);
    local u51 = SkillCommon.clampEndCF(SkillCommon.getHRPStartCF(u50), u50:getTargetCF(), 130, 0.75);
    local v52 = u50:getTargetCF();
    local u53 = SkillCommon.getGroundCF(u51);
    local Position = u53.Position;
    local u54 = v52.Position - HumanoidRootPart.Position;
    local _, u55 = SkillCommon.scaleDualFromData(u50, SkillCommon.bandScaleOptsFromSkillData(u50));

    local function stillValid() -- Line: 382
        -- upvalues: u50 (copy)
        if u50:isRunningFlow() then
            return (not u50.GetCurrentState or u50:GetCurrentState() == "Pillar") and true or false;
        end;

        return false;
    end;

    task.defer(function() -- Line: 393
        -- upvalues: skillRunData (copy), u50 (copy), u55 (copy), FXUtil (ref), u51 (copy), u54 (copy), Position (copy), u53 (copy), enableWaterSurfaceEmittersOnly (ref), startPillarGroundBeamsReveal (ref), emitBurstParticlesExceptWaterSurface (ref), SkillCommon (ref)
        local WaterColumnGroundFxEarly = skillRunData.WaterColumnGroundFxEarly;
        skillRunData.WaterColumnGroundFxEarly = nil;
        local v56;

        if u50:isRunningFlow() then
            v56 = (not u50.GetCurrentState or u50:GetCurrentState() == "Pillar") and true or false;
        else
            v56 = false;
        end;

        if not v56 then
            return;
        end;

        for _, v in { "通天水柱_地面特效", "通天水柱_水柱上扬光效", "通天水柱_水柱的水花特效" } do
            local u57 = skillRunData.material[v];

            if u57 then
                local v58 = false;

                if v == "通天水柱_地面特效" and (WaterColumnGroundFxEarly and (WaterColumnGroundFxEarly:IsA("Model") and WaterColumnGroundFxEarly.Parent)) then
                    u57 = WaterColumnGroundFxEarly;
                    v58 = true;
                else
                    local v59 = skillRunData;

                    if not v59.WaterColumnFootSpawned then
                        v59.WaterColumnFootSpawned = {};
                    end;

                    table.insert(v59.WaterColumnFootSpawned, u57);
                end;

                u57:ScaleTo(u55);

                if v == "通天水柱_地面特效" then
                    local v60 = FXUtil.GetGroundAlignedCF(u51.Position, u54, "Ground");

                    if v60 then
                        u57:PivotTo(v60);
                    else
                        u57:PivotTo(CFrame.new(Position));
                    end;
                else
                    u57:PivotTo(CFrame.new(Position) * u53.Rotation);
                end;

                if not u57.Parent then
                    u57.Parent = workspace.Debris;
                end;

                if v == "通天水柱_地面特效" then
                    if not v58 then
                        enableWaterSurfaceEmittersOnly(u57);
                    end;

                    startPillarGroundBeamsReveal(u57, skillRunData);
                    emitBurstParticlesExceptWaterSurface(u57);
                    task.delay(1.17, function() -- Line: 145
                        -- upvalues: u57 (copy), FXUtil (ref)
                        if not u57.Parent then
                            return;
                        end;

                        for _, descendant in u57:GetDescendants() do
                            if descendant:IsA("ParticleEmitter") then
                                local Parent = descendant.Parent;
                                local v61;

                                while true do
                                    if not Parent then
                                        v61 = false;
                                        break;
                                    end;

                                    if Parent.Name == "水面" then
                                        v61 = true;
                                        break;
                                    end;

                                    Parent = Parent.Parent;
                                end;

                                if v61 then
                                    descendant.Enabled = false;
                                end;
                            end;
                        end;

                        for _, descendant in u57:GetDescendants() do
                            if descendant:IsA("Beam") and (descendant.Name == "水柱" or descendant.Name == "水柱1") then
                                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                            end;
                        end;
                    end);
                elseif v == "通天水柱_水柱上扬光效" then
                    FXUtil.Emit_Particles_GetDescendants(u57, true);
                    SkillCommon.playSoundLocal3D("音效-技能-通天水柱-喷发", u57:GetPivot().Position);
                else
                    FXUtil.Start_All_Emit(u57, 4.05);
                    task.delay(1.07, function() -- Line: 268
                        -- upvalues: u57 (copy), FXUtil (ref)
                        if not u57.Parent then
                            return;
                        end;

                        FXUtil.Stop_All_Emit(u57);

                        if u57:IsA("Model") then
                            FXUtil.Model_Fade(u57, 0.38);
                        end;

                        for _, descendant in u57:GetDescendants() do
                            if descendant:IsA("Beam") then
                                FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.38, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                            end;
                        end;
                    end);
                end;
            end;
        end;
    end);
end;

function v1.Client_ExitPillar(p62) -- Line: 446
    -- upvalues: fadeOutSpawnList (copy)
    fadeOutSpawnList(p62.skillRunData, "WaterColumnFootSpawned", 0.55, true);
end;

function v1.Client_EnterRecovery(p63) -- Line: 450
    -- upvalues: SkillCommon (copy)
    local skillRunData = p63.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "通天水柱Cast尾迹");
    end;
end;

function v1.onEnd(p64) -- Line: 457
    -- upvalues: SkillCommon (copy), fadeOutSpawnList (copy)
    local skillRunData = p64.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "通天水柱Cast尾迹");
    fadeOutSpawnList(skillRunData, "WaterColumnFootSpawned", 0.55, true);
    fadeOutSpawnList(skillRunData, "WaterColumnCircleSpawned", 0.3);
end;

function v1.Server_EnterPillar(u65) -- Line: 468
    -- upvalues: SkillCommon (copy), getEndCF (copy)
    local v66 = SkillCommon.getGroundCF(getEndCF(u65));
    local _, v67 = SkillCommon.scaleDualFromData(u65, SkillCommon.bandScaleOptsFromSkillData(u65));
    local v68 = 21 * v67;
    local v69 = 14 * v67;
    local v70 = v66.Position + Vector3.new(0, v68 * 0.5 + 0.1, 0);
    local v71 = CFrame.new(v70);
    local v72 = Vector3.new(v69, v68, v69);

    local function stopAllPillarHits() -- Line: 478
        -- upvalues: u65 (copy)
        local v73 = u65.hitbox[1];

        if v73 then
            v73:stop();
        end;

        local v74 = u65.hitbox[2];

        if v74 then
            v74:stop();
        end;

        local v75 = u65.hitbox[3];

        if v75 then
            v75:stop();
        end;
    end;

    local function stillPillar() -- Line: 487
        -- upvalues: u65 (copy)
        if u65:isRunningFlow() then
            return u65:GetCurrentState() == "Pillar";
        end;

        return false;
    end;

    for i = 1, 3 do
        local v76 = u65.hitbox[i];

        if not (v76 and v76.hitbox) then
            return;
        end;

        local hitbox = v76.hitbox;
        hitbox.Size = v72;
        hitbox:PivotTo(v71);
    end;

    local v77 = u65.hitbox[1];

    if v77 then
        v77:stop();
    end;

    local v78 = u65.hitbox[2];

    if v78 then
        v78:stop();
    end;

    local v79 = u65.hitbox[3];

    if v79 then
        v79:stop();
    end;

    for i = 1, 3 do
        task.delay((i - 1) * 0.6 + 0.1, function() -- Line: 509
            -- upvalues: u65 (copy), i (copy)
            local v80;

            if u65:isRunningFlow() then
                v80 = u65:GetCurrentState() == "Pillar";
            else
                v80 = false;
            end;

            if not v80 then
                return;
            end;

            local v81 = u65.hitbox[1];

            if v81 then
                v81:stop();
            end;

            local v82 = u65.hitbox[2];

            if v82 then
                v82:stop();
            end;

            local v83 = u65.hitbox[3];

            if v83 then
                v83:stop();
            end;

            local u84 = u65.hitbox[i];

            if u84 and u84.hitbox then
                u84:start(true);
            end;

            task.delay(0.14, function() -- Line: 519
                -- upvalues: u65 (ref), u84 (copy)
                local v85;

                if u65:isRunningFlow() then
                    v85 = u65:GetCurrentState() == "Pillar";
                else
                    v85 = false;
                end;

                if not v85 then
                    return;
                end;

                if u84 then
                    u84:stop();
                end;
            end);
        end);
    end;
end;

function v1.Server_ExitPillar(p86) -- Line: 531
    local v87 = p86.hitbox[1];

    if v87 and v87.isActive then
        v87:stop();
    end;

    local v88 = p86.hitbox[2];

    if v88 and v88.isActive then
        v88:stop();
    end;

    local v89 = p86.hitbox[3];

    if v89 and v89.isActive then
        v89:stop();
    end;
end;

function v1.Server_EnterRecovery(p90) -- Line: 541
    p90:releaseControl();
end;

v1.SoundList = { "音效-技能-水法阵", "音效-技能-通天水柱-喷发" };
v1.AnimateList = { "技能释放动作4" };
v1.ResNameList = { "水系尾迹", "通天水柱法阵", "通天水柱_地面特效", "通天水柱_水柱上扬光效", "通天水柱_水柱的水花特效" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "水属性受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "水属性受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 3,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "水属性受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.73,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.4,
        animationName = "技能释放动作4",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;