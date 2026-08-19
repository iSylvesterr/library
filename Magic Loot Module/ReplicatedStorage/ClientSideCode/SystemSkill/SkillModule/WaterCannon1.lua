-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local TweenService = game:GetService("TweenService");
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local SkillActionLock = require(script.Parent.Parent.BaseSkill.SkillActionLock);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Water,
    skillDistanceLimit = 64
};
local u2 = CFrame.new(0, 1.4, -6.5);
local u3 = {
    follow = "水炮身前特效跟随",
    hitSync = "水炮命中盒同步",
    jumpCancel = "水炮跳跃打断",
    columnRetract = "水炮跳跃水柱回缩"
};
local u4 = { {
        t = 0,
        y = 0
    }, {
        t = 0.1,
        y = -85
    }, {
        t = 0.2,
        y = -170
    }, {
        t = 0.283,
        y = 105
    }, {
        t = 0.35,
        y = 0
    }, {
        t = 0.45,
        y = -85
    } };

local function flatHorizLook(p5) -- Line: 80
    local v6 = Vector3.new(p5.LookVector.X, 0, p5.LookVector.Z);

    return v6.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v6.Unit;
end;

local function buildFormCFFromCaster(p7) -- Line: 88
    -- upvalues: SkillCommon (copy), u2 (copy)
    local buildFormationCFFromSnappedFlat = SkillCommon.buildFormationCFFromSnappedFlat;
    local CFrame2 = p7.CFrame;
    local v8 = Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);

    return buildFormationCFFromSnappedFlat(p7, v8.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v8.Unit, u2);
end;

local function resolveSprayHitFromFormation(p9, p10, p11, p12, p13, p14) -- Line: 92
    -- upvalues: SkillCommon (copy)
    local resolveHorizSprayHitEnd = SkillCommon.resolveHorizSprayHitEnd;
    local Position = p12.Position;
    local v15 = Vector3.new(p12.LookVector.X, 0, p12.LookVector.Z);

    return resolveHorizSprayHitEnd(p9, p10, 45, p11, Position, v15.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v15.Unit, p13, p14);
end;

local function cleanupRunFx(p16) -- Line: 112
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p16.skillRunData, { "水炮身前特效跟随", "水炮命中盒同步", "水炮跳跃打断", "水炮跳跃水柱回缩" });
end;

local function stillMain(p17, p18) -- Line: 121
    -- upvalues: SkillCommon (copy)
    if not SkillCommon.isRunningSameGeneration(p17, p18) then
        return false;
    end;

    local v19 = p17.GetCurrentState and p17:GetCurrentState();

    return v19 == "Main";
end;

local function mainElapsed(p20) -- Line: 129
    local skillRunData = p20.skillRunData;

    return not (skillRunData and skillRunData.State) and 0 or p20.nowTime - skillRunData.State.enteredAt;
end;

local function shouldPlayMainEarlyLeaveFx(p21) -- Line: 138
    local skillRunData = p21.skillRunData;

    return (not (skillRunData and skillRunData.State) and 0 or p21.nowTime - skillRunData.State.enteredAt) < 3.4;
end;

local function setSustainEmittersEnabled(p22, p23, p24, p25) -- Line: 142
    -- upvalues: FXUtil (copy), SkillCommon (copy)
    FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(p22, "Emit和Enabled1_法阵"), p25);
    FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(p23, "水柱地面Emit和Enabled1"), p25);
    FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(p22, "往后喷水Enabled和Emit"), p25);
    FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(p24, "Enabled和Emit_受击"), p25);
end;

local function resolveCasterSoundPos(p26) -- Line: 149
    if not p26 then
        return nil;
    end;

    local HumanoidRootPart = p26:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart and HumanoidRootPart.Parent then
        return HumanoidRootPart:GetPivot().Position;
    end;

    return p26:GetPivot().Position;
end;

local function fadeStopColumnAttackSound(p27) -- Line: 160
    -- upvalues: SkillCommon (copy)
    SkillCommon.stopSoundLocalForSkill(p27, "音效-技能-水5-水柱攻击", 0.2);
end;

local function playColumnEndSoundIfActive(p28, p29) -- Line: 165
    -- upvalues: SkillCommon (copy)
    if not p29 or (p29.waterColumnEndSoundPlayed or not p29.waterColumnSustainOn) then
        return;
    end;

    local v30 = p28.skillInputData and p28.skillInputData.character;
    local v31;

    if v30 then
        local HumanoidRootPart = v30:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and HumanoidRootPart.Parent then
            v31 = HumanoidRootPart:GetPivot().Position;
        else
            v31 = v30:GetPivot().Position;
        end;
    else
        v31 = nil;
    end;

    if not v31 then
        return;
    end;

    p29.waterColumnEndSoundPlayed = true;
    SkillCommon.stopSoundLocalForSkill(p28, "音效-技能-水5-水柱攻击", 0.2);
    SkillCommon.playSoundLocal3D("音效-技能-水5-水柱消失", v31);
end;

local function disableSustainWithColumnEndSound(p32, p33, p34, p35, p36) -- Line: 178
    -- upvalues: setSustainEmittersEnabled (copy), SkillCommon (copy)
    setSustainEmittersEnabled(p34, p35, p36, false);

    if p33 and not p33.waterColumnEndSoundPlayed then
        if not p33.waterColumnSustainOn then
            return;
        end;

        local v37 = p32.skillInputData and p32.skillInputData.character;
        local v38;

        if v37 then
            local HumanoidRootPart = v37:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart and HumanoidRootPart.Parent then
                v38 = HumanoidRootPart:GetPivot().Position;
            else
                v38 = v37:GetPivot().Position;
            end;
        else
            v38 = nil;
        end;

        if not v38 then
            return;
        end;

        p33.waterColumnEndSoundPlayed = true;
        SkillCommon.stopSoundLocalForSkill(p32, "音效-技能-水5-水柱攻击", 0.2);
        SkillCommon.playSoundLocal3D("音效-技能-水5-水柱消失", v38);
    end;
end;

local function resolveWaterAttachLocalY(p39, p40) -- Line: 190
    local v41 = p39 * -1;

    return v41, v41 + (p40 or 1) * (p39 * 45 - v41);
end;

local function playMainEarlyLeaveFx(u42, u43) -- Line: 198
    -- upvalues: setSustainEmittersEnabled (copy), SkillCommon (copy), FXUtil (copy), RunService (copy), TweenService (copy), VisibleMgr (copy)
    local skillRunData = u42.skillRunData;

    if not skillRunData or skillRunData.mainEarlyLeaveFxDone then
        return;
    end;

    skillRunData.mainEarlyLeaveFxDone = true;
    local u44 = skillRunData.material["水炮_法阵"];
    local u45 = skillRunData.material["水炮_水柱"];
    local u46 = skillRunData.material["水炮_水龙卷"];
    local u47 = skillRunData.material["水炮_爆炸"];
    setSustainEmittersEnabled(u44, u45, u47, false);

    if skillRunData and (not skillRunData.waterColumnEndSoundPlayed and skillRunData.waterColumnSustainOn) then
        local v48 = u42.skillInputData and u42.skillInputData.character;
        local v49;

        if v48 then
            local HumanoidRootPart = v48:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart and HumanoidRootPart.Parent then
                v49 = HumanoidRootPart:GetPivot().Position;
            else
                v49 = v48:GetPivot().Position;
            end;
        else
            v49 = nil;
        end;

        if v49 then
            skillRunData.waterColumnEndSoundPlayed = true;
            SkillCommon.stopSoundLocalForSkill(u42, "音效-技能-水5-水柱攻击", 0.2);
            SkillCommon.playSoundLocal3D("音效-技能-水5-水柱消失", v49);
        end;
    end;

    if u44 and u44.Parent then
        FXUtil.Emit_Particles_GetDescendants(SkillCommon.findDescendantByName(u44, "水爆炸_Emit"), true);
    end;

    local v50 = SkillCommon.scaleBandFromData(u42, SkillCommon.bandScaleOptsFromSkillData(u42));
    local u51 = SkillCommon.findDescendantByName(u45, "水_1");

    if u51 and u51.Parent then
        local u52 = v50 * -1;
        local _ = u52 + 0 * (v50 * 45 - u52);
        local Y = u51.CFrame.Position.Y;
        local u53 = 0;
        SkillCommon.disconnectRunEventKeys(skillRunData, { "水炮跳跃水柱回缩" });
        skillRunData.runEvent["水炮跳跃水柱回缩"] = RunService.Heartbeat:Connect(function(p54) -- Line: 222
            -- upvalues: u42 (copy), u43 (copy), SkillCommon (ref), skillRunData (copy), u53 (ref), TweenService (ref), Y (copy), u52 (copy), u51 (copy)
            if u42.runGeneration ~= u43 then
                SkillCommon.disconnectRunEventKeys(skillRunData, { "水炮跳跃水柱回缩" });

                return;
            end;

            u53 = u53 + p54;
            local v55 = math.clamp(u53 / 0.18, 0, 1);
            local v56 = TweenService:GetValue(v55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            u51.CFrame = CFrame.new(0, Y + (u52 - Y) * v56, 0) * CFrame.Angles(0, 0, 1.5707963267948966);

            if v55 >= 1 then
                SkillCommon.disconnectRunEventKeys(skillRunData, { "水炮跳跃水柱回缩" });
            end;
        end);
    end;

    local v57 = SkillCommon.findDescendantByName(u46, "龙卷_1");

    if v57 and v57:IsA("BasePart") then
        local Decal = v57:FindFirstChild("Decal");

        if Decal and Decal:IsA("Decal") then
            Decal.Transparency = 1;
        end;

        local Mesh = v57:FindFirstChild("Mesh");

        if Mesh and (Mesh:IsA("SpecialMesh") or Mesh:IsA("BlockMesh")) then
            local Scale = Mesh.Scale;
            Mesh.Scale = Vector3.new(Scale.X, Scale.Y * 0.15, Scale.Z);
        end;
    end;

    task.delay(0.1, function() -- Line: 253
        -- upvalues: u42 (copy), u43 (copy), u44 (copy), u45 (copy), u46 (copy), u47 (copy), VisibleMgr (ref)
        if u42.runGeneration ~= u43 then
            return;
        end;

        for _, v in {
            u44,
            u45,
            u46,
            u47
        } do
            if v and v.Parent then
                VisibleMgr.fadeAllTween(v, 1, nil, 0.35);
            end;
        end;
    end);
end;

local function finishMainEarlyLeaveClient(p58) -- Line: 265
    -- upvalues: SkillActionLock (copy)
    if p58.skillAction then
        p58.skillAction:Over(p58.nowTime);
    end;

    local v59 = p58.skillInputData and p58.skillInputData.character;

    if v59 then
        SkillActionLock.turn_Off_Action_Lock(v59);
    end;
end;

local function tryJumpCancelMain(p60, p61, p62) -- Line: 276
    -- upvalues: SkillCommon (copy), playMainEarlyLeaveFx (copy), SkillActionLock (copy), SkillEventConst (copy)
    local v63;

    if SkillCommon.isRunningSameGeneration(p60, p61) then
        local v64 = p60.GetCurrentState and p60:GetCurrentState();
        v63 = v64 == "Main";
    else
        v63 = false;
    end;

    if not v63 then
        return;
    end;

    local skillRunData = p60.skillRunData;

    if not skillRunData or skillRunData.mainEarlyLeave then
        return;
    end;

    skillRunData.mainEarlyLeave = true;

    if not p62 then
        playMainEarlyLeaveFx(p60, p61);

        if p60.skillAction then
            p60.skillAction:Over(p60.nowTime);
        end;

        local v65 = p60.skillInputData and p60.skillInputData.character;

        if v65 then
            SkillActionLock.turn_Off_Action_Lock(v65);
        end;
    end;

    if p60:TryTransition(SkillEventConst.JumpCancel) and p62 then
        SkillCommon.dispatchBaseSkillStateTransition(p60, SkillEventConst.JumpCancel, "WaterCannon");
    end;
end;

local function bindMainJumpCancel(u66, p67, u68, u69) -- Line: 298
    -- upvalues: SkillCommon (copy), tryJumpCancelMain (copy)
    if not p67 then
        return;
    end;

    SkillCommon.bindHumanoidJumpWhile(u66, p67, "水炮跳跃打断", function() -- Line: 302
        -- upvalues: tryJumpCancelMain (ref), u66 (copy), u68 (copy), u69 (copy)
        tryJumpCancelMain(u66, u68, u69);
    end);
end;

local function sampleTornadoDecalTransparency(p70) -- Line: 310
    if p70 < 0 then
        return 1;
    end;

    if p70 <= 0 then
        return 0.8;
    end;

    if p70 <= 0.267 then
        return p70 / 0.267 * -0.8 + 0.8;
    end;

    return p70 < 3.5 and 0 or (p70 > 3.733 and 1 or (p70 - 3.5) / 0.233);
end;

local function sampleTornadoAngleY(p71) -- Line: 332
    -- upvalues: u4 (copy)
    if p71 >= 3.733 then
        return u4[#u4].y;
    end;

    local v72 = p71 % 0.45;

    if v72 <= u4[1].t then
        return u4[1].y;
    end;

    for i = 2, #u4 do
        local v73 = u4[i];
        local v74 = u4[i - 1];

        if v72 <= v73.t then
            return v74.y + (v73.y - v74.y) * ((v72 - v74.t) / (v73.t - v74.t));
        end;
    end;

    return u4[#u4].y;
end;

local function resolveSprayLengthRatio(p75, p76, p77) -- Line: 352
    local v78 = p77 * 45;

    if v78 <= 0.001 then
        return 1;
    end;

    local v79 = Vector3.new(p76.X - p75.X, 0, p76.Z - p75.Z).Magnitude / v78;

    return math.clamp(v79, 0.01, 1);
end;

local function applyTornadoPartVisual(p80, p81, p82, p83, p84, p85) -- Line: 365
    -- upvalues: SkillCommon (copy)
    SkillCommon.applyPartLocalCFWithYaw(p80, p81, p82, p83);
    local v86 = math.clamp(p84, 0.01, 1);
    local Mesh = p80:FindFirstChild("Mesh");

    if Mesh and (Mesh:IsA("SpecialMesh") or Mesh:IsA("BlockMesh")) then
        Mesh.Scale = Vector3.new(p85 * 0.30000001192092896, p85 * 1.5 * v86, p85 * 0.30000001192092896);
    end;

    if v86 >= 0.999 or not p83 then
        return;
    end;

    local Position = p83:GetPivot().Position;
    local Position2 = p80.Position;
    local v87 = Position2 - Position;

    if v87.Magnitude <= 0.0001 then
        v87 = p83:GetPivot():VectorToWorldSpace(Vector3.new(-0.425, 0.332, -18.426) * p85);
    end;

    if v87.Magnitude <= 0.0001 then
        return;
    end;

    local v88 = p80.CFrame - Position2;
    p80.CFrame = CFrame.new(Position + v87.Unit * (p85 * 18.435 * v86)) * v88;
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Recovery";

function v1.CanReleaseControl(p89) -- Line: 409
    local skillRunData = p89.skillRunData;
    local v90 = skillRunData and skillRunData.State and skillRunData.State.current;

    return (v90 == "Recovery" or v90 == "Finished") and true or v90 == "Interrupted";
end;

v1.States = {
    Startup = {
        Duration = 1.233,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 4,
        OnEnterClient = "Client_EnterMain",
        OnEnterServer = "Server_EnterMain",
        OnExitClient = "Client_ExitMain",
        OnExitServer = "Server_ExitMain"
    },
    Recovery = {
        Duration = 1,
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
        From = "Main",
        To = "Recovery",
        Event = SkillEventConst.JumpCancel
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

function v1.Client_EnterStartup(p91) -- Line: 450
    -- upvalues: SkillCommon (copy)
    local v92 = p91.skillInputData and p91.skillInputData.character;
    local _ = p91.skillRunData;

    if not v92 then
        return;
    end;

    if not p91._presentationPredictActive then
        SkillCommon.enterSkillShiftLock(p91, 90);
    end;

    local v93 = SkillCommon.resolveWandTipFromCharacter(v92);

    if v93 then
        SkillCommon.scheduleWandTipElementTrail(p91, v93, {
            trailMaterialKey = "水系尾迹",
            runEventKey = "水炮Cast尾迹",
            enableAt = 0.17,
            disableAt = 1.23
        });
    end;
end;

function v1.Server_EnterStartup(p94) -- Line: 471
    -- upvalues: SkillCommon (copy)
    local v95 = SkillCommon.scaleBandFromData(p94, SkillCommon.bandScaleOptsFromSkillData(p94));
    local v96 = p94.hitbox[1];

    if v96 and v96.hitbox then
        SkillCommon.placeBoxHitboxBetween(v96.hitbox, Vector3.new(0, 0, 0), Vector3.new(0, 0, -1), Vector3.new(9, 36, 9), v95);
        v96.hitbox:PivotTo(CFrame.new(0, -5000, 0));
    end;
end;

function v1.Client_EnterMain(u97) -- Line: 480
    -- upvalues: SkillCommon (copy), SkillActionLock (copy), VisibleMgr (copy), u2 (copy), FXUtil (copy), setSustainEmittersEnabled (copy), RunService (copy), applyTornadoPartVisual (copy), sampleTornadoAngleY (copy), TweenService (copy), u3 (copy), tryJumpCancelMain (copy)
    local skillInputData = u97.skillInputData;
    local u98;

    if skillInputData then
        u98 = skillInputData.character;
    else
        u98 = skillInputData;
    end;

    local skillRunData = u97.skillRunData;

    if not (u98 and (skillRunData and skillRunData.material)) then
        return;
    end;

    local HumanoidRootPart = u98:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local runGeneration = u97.runGeneration;
    local u99 = SkillCommon.scaleBandFromData(u97, SkillCommon.bandScaleOptsFromSkillData(u97));
    SkillActionLock.turn_Off_Action_Lock(u98);
    task.delay(1.6, function() -- Line: 496
        -- upvalues: u97 (copy), runGeneration (copy), SkillCommon (ref), SkillActionLock (ref), u98 (copy)
        local v100 = u97;
        local v101;

        if SkillCommon.isRunningSameGeneration(v100, runGeneration) then
            local v102 = v100.GetCurrentState and v100:GetCurrentState();
            v101 = v102 == "Main";
        else
            v101 = false;
        end;

        if v101 then
            SkillActionLock.turn_Off_Action_Lock(u98);
        end;
    end);
    local u103 = skillRunData.material["水炮_法阵"];
    local u104 = skillRunData.material["水炮_水柱"];
    local u105 = skillRunData.material["水炮_水龙卷"];
    local u106 = skillRunData.material["水炮_爆炸"];
    local v107 = {};

    for _, v in {
        u103,
        u104,
        u105,
        u106
    } do
        if v then
            table.insert(v107, v);
        end;
    end;

    local u108 = {
        wallRayTag = "Ground",
        lowVisualClearStuds = 2.5,
        fullHorizSprayRange = true,
        extraIgnore = v107
    };
    local u109 = nil;
    local u110 = nil;
    local u111 = nil;
    local u112 = nil;

    local function deployModels(p113) -- Line: 527
        -- upvalues: u103 (copy), u109 (ref), u99 (copy), VisibleMgr (ref), SkillCommon (ref), skillRunData (copy), u104 (copy), u110 (ref), u105 (copy), u111 (ref), u106 (copy), u112 (ref)
        if u103 and u103.Parent ~= workspace.Debris then
            if not u109 then
                u109 = u103:GetPivot() - u103:GetPivot().Position;
            end;

            u103:ScaleTo(u99);
            VisibleMgr.UnQueryAll(u103);
            SkillCommon.pivotModelAtFormationAnchor(p113, u103, u109);
            u103.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "WaterCannonSpawned", u103);
        end;

        if u104 and u104.Parent ~= workspace.Debris then
            if not u110 then
                u110 = u104:GetPivot() - u104:GetPivot().Position;
            end;

            u104:ScaleTo(u99);
            VisibleMgr.UnQueryAll(u104);
            SkillCommon.pivotModelOffsetFromFormationAnchor(p113, u104, Vector3.new(1.081, 1.063, 0.543), u110);
            u104.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "WaterCannonSpawned", u104);
        end;

        if u105 and u105.Parent ~= workspace.Debris then
            if not u111 then
                u111 = u105:GetPivot() - u105:GetPivot().Position;
            end;

            u105:ScaleTo(u99);
            VisibleMgr.UnQueryAll(u105);
            SkillCommon.pivotModelOffsetFromFormationAnchor(p113, u105, Vector3.new(1.451, 0.559, 3.998), u111);
            u105.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "WaterCannonSpawned", u105);
        end;

        if u106 and u106.Parent ~= workspace.Debris then
            if not u112 then
                u112 = u106:GetPivot() - u106:GetPivot().Position;
            end;

            u106:ScaleTo(u99);
            VisibleMgr.UnQueryAll(u106);
            u106.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "WaterCannonSpawned", u106);
        end;
    end;

    local u114 = SkillCommon.resolveStrikeWorldPos(skillInputData);
    local buildFormationCFFromSnappedFlat = SkillCommon.buildFormationCFFromSnappedFlat;
    local CFrame2 = HumanoidRootPart.CFrame;
    local v115 = Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);
    deployModels((buildFormationCFFromSnappedFlat(HumanoidRootPart, v115.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v115.Unit, u2)));
    local v116 = SkillCommon.findDescendantByName(u105, "龙卷_1");
    local u117;

    if v116 and v116:IsA("BasePart") then
        u117 = SkillCommon.capturePartLocalCF(v116, u105);
    else
        u117 = nil;
    end;

    skillRunData.waterColumnSustainOn = false;
    skillRunData.waterColumnEndSoundPlayed = false;
    FXUtil.Emit_Particles_GetDescendants(SkillCommon.findDescendantByName(u103, "Emit和Enabled1_法阵"), true);
    FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(u103, "Emit和Enabled1_法阵"), true);
    FXUtil.Emit_Particles_GetDescendants(SkillCommon.findDescendantByName(u103, "水爆炸_Emit"), false);
    local v118;

    if u98 then
        local HumanoidRootPart2 = u98:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart2 and HumanoidRootPart2.Parent then
            v118 = HumanoidRootPart2:GetPivot().Position;
        else
            v118 = u98:GetPivot().Position;
        end;
    else
        v118 = nil;
    end;

    if v118 then
        SkillCommon.playSoundLocal3D("音效-技能-水5-起手法阵", v118);
    end;

    task.delay(0.1, function() -- Line: 592
        -- upvalues: u97 (copy), runGeneration (copy), SkillCommon (ref), skillRunData (copy), FXUtil (ref), u104 (copy), u98 (copy)
        local v119 = u97;
        local v120;

        if SkillCommon.isRunningSameGeneration(v119, runGeneration) then
            local v121 = v119.GetCurrentState and v119:GetCurrentState();
            v120 = v121 == "Main";
        else
            v120 = false;
        end;

        if not v120 then
            return;
        end;

        skillRunData.waterColumnSustainOn = true;
        FXUtil.Emit_Particles_GetDescendants(SkillCommon.findDescendantByName(u104, "水柱地面Emit和Enabled1"), true);
        FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(u104, "水柱地面Emit和Enabled1"), true);
        local v122 = u98;
        local v123;

        if v122 then
            local HumanoidRootPart2 = v122:FindFirstChild("HumanoidRootPart");

            if HumanoidRootPart2 and HumanoidRootPart2.Parent then
                v123 = HumanoidRootPart2:GetPivot().Position;
            else
                v123 = v122:GetPivot().Position;
            end;
        else
            v123 = nil;
        end;

        if v123 then
            SkillCommon.playSoundLocal3DForSkill(u97, "音效-技能-水5-水柱攻击", v123);
        end;
    end);
    task.delay(0.15, function() -- Line: 606
        -- upvalues: u97 (copy), runGeneration (copy), SkillCommon (ref), FXUtil (ref), u103 (copy)
        local v124 = u97;
        local v125;

        if SkillCommon.isRunningSameGeneration(v124, runGeneration) then
            local v126 = v124.GetCurrentState and v124:GetCurrentState();
            v125 = v126 == "Main";
        else
            v125 = false;
        end;

        if not v125 then
            return;
        end;

        FXUtil.Emit_Particles_GetDescendants(SkillCommon.findDescendantByName(u103, "往后喷水Enabled和Emit"), true);
        FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(u103, "往后喷水Enabled和Emit"), true);
    end);
    task.delay(3.5, function() -- Line: 615
        -- upvalues: u97 (copy), runGeneration (copy), SkillCommon (ref), FXUtil (ref), u103 (copy), VisibleMgr (ref)
        local v127 = u97;
        local v128;

        if SkillCommon.isRunningSameGeneration(v127, runGeneration) then
            local v129 = v127.GetCurrentState and v127:GetCurrentState();
            v128 = v129 == "Main";
        else
            v128 = false;
        end;

        if not v128 then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(u103, "Emit和Enabled1_法阵"), false);
        task.delay(2, function() -- Line: 620
            -- upvalues: u97 (ref), runGeneration (ref), u103 (ref), VisibleMgr (ref)
            if u97.runGeneration ~= runGeneration then
                return;
            end;

            if u103 and u103.Parent then
                VisibleMgr.fadeAll(u103, 1);
            end;
        end);
    end);
    task.delay(3.733, function() -- Line: 631
        -- upvalues: u97 (copy), runGeneration (copy), SkillCommon (ref), skillRunData (copy), u103 (copy), u104 (copy), u106 (copy), setSustainEmittersEnabled (ref), VisibleMgr (ref)
        local v130 = u97;
        local v131;

        if SkillCommon.isRunningSameGeneration(v130, runGeneration) then
            local v132 = v130.GetCurrentState and v130:GetCurrentState();
            v131 = v132 == "Main";
        else
            v131 = false;
        end;

        if not v131 then
            return;
        end;

        local v133 = u97;
        local v134 = skillRunData;
        setSustainEmittersEnabled(u103, u104, u106, false);

        if v134 and (not v134.waterColumnEndSoundPlayed and v134.waterColumnSustainOn) then
            local v135 = v133.skillInputData and v133.skillInputData.character;
            local v136;

            if v135 then
                local HumanoidRootPart2 = v135:FindFirstChild("HumanoidRootPart");

                if HumanoidRootPart2 and HumanoidRootPart2.Parent then
                    v136 = HumanoidRootPart2:GetPivot().Position;
                else
                    v136 = v135:GetPivot().Position;
                end;
            else
                v136 = nil;
            end;

            if v136 then
                v134.waterColumnEndSoundPlayed = true;
                SkillCommon.stopSoundLocalForSkill(v133, "音效-技能-水5-水柱攻击", 0.2);
                SkillCommon.playSoundLocal3D("音效-技能-水5-水柱消失", v136);
            end;
        end;

        task.delay(2, function() -- Line: 636
            -- upvalues: u97 (ref), runGeneration (ref), u104 (ref), VisibleMgr (ref)
            if u97.runGeneration ~= runGeneration then
                return;
            end;

            if u104 and u104.Parent then
                VisibleMgr.fadeAll(u104, 1);
            end;
        end);
    end);
    local u137 = 0;
    local u138 = false;
    local u139 = SkillCommon.findDescendantByName(u104, "水_1");
    skillRunData.runEvent["水炮身前特效跟随"] = RunService.Heartbeat:Connect(function(p140) -- Line: 650
        -- upvalues: u97 (copy), runGeneration (copy), SkillCommon (ref), HumanoidRootPart (copy), u137 (ref), u2 (ref), u103 (copy), u109 (ref), u104 (copy), u110 (ref), u114 (copy), u99 (copy), u98 (copy), u108 (copy), u105 (copy), u111 (ref), u117 (ref), applyTornadoPartVisual (ref), sampleTornadoAngleY (ref), u139 (copy), TweenService (ref), u106 (copy), u138 (ref), u112 (ref), FXUtil (ref)
        local v141 = u97;
        local v142;

        if SkillCommon.isRunningSameGeneration(v141, runGeneration) then
            local v143 = v141.GetCurrentState and v141:GetCurrentState();
            v142 = v143 == "Main";
        else
            v142 = false;
        end;

        if not v142 then
            return;
        end;

        if not HumanoidRootPart.Parent then
            return;
        end;

        u137 = u137 + p140;
        local v144 = HumanoidRootPart;
        local buildFormationCFFromSnappedFlat2 = SkillCommon.buildFormationCFFromSnappedFlat;
        local CFrame3 = v144.CFrame;
        local v145 = Vector3.new(CFrame3.LookVector.X, 0, CFrame3.LookVector.Z);
        local v146 = buildFormationCFFromSnappedFlat2(v144, v145.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v145.Unit, u2);

        if u103 and u103.Parent then
            SkillCommon.pivotModelAtFormationAnchor(v146, u103, u109 or CFrame.identity);
        end;

        if u104 and u104.Parent then
            SkillCommon.pivotModelOffsetFromFormationAnchor(v146, u104, Vector3.new(1.081, 1.063, 0.543), u110 or CFrame.identity);
        end;

        local resolveHorizSprayHitEnd = SkillCommon.resolveHorizSprayHitEnd;
        local Position = v146.Position;
        local v147 = Vector3.new(v146.LookVector.X, 0, v146.LookVector.Z);
        local v148, v149 = resolveHorizSprayHitEnd(HumanoidRootPart, u114, 45, u99, Position, v147.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v147.Unit, u98, u108);

        if u105 and u105.Parent then
            SkillCommon.pivotModelOffsetFromFormationAnchor(v146, u105, Vector3.new(1.451, 0.559, 3.998), u111 or CFrame.identity);
            local v150 = SkillCommon.findDescendantByName(u105, "龙卷_1");

            if v150 and v150:IsA("BasePart") then
                if not u117 then
                    u117 = SkillCommon.capturePartLocalCF(v150, u105);
                end;

                if u117 then
                    local v151;

                    if v149 then
                        local Position2 = v146.Position;
                        local v152 = u99 * 45;

                        if v152 <= 0.001 then
                            v151 = 1;
                        else
                            local v153 = Vector3.new(v148.X - Position2.X, 0, v148.Z - Position2.Z).Magnitude / v152;
                            v151 = math.clamp(v153, 0.01, 1);
                        end;
                    else
                        v151 = 1;
                    end;

                    applyTornadoPartVisual(v150, u117, sampleTornadoAngleY(u137), u105, v151, u99);
                end;

                local Decal = v150:FindFirstChild("Decal");

                if Decal and Decal:IsA("Decal") then
                    local v154 = u137;
                    local v155;

                    if v154 < 0 then
                        v155 = 1;
                    elseif v154 <= 0 then
                        v155 = 0.8;
                    elseif v154 <= 0.267 then
                        v155 = v154 / 0.267 * -0.8 + 0.8;
                    else
                        v155 = v154 < 3.5 and 0 or (v154 > 3.733 and 1 or (v154 - 3.5) / 0.233);
                    end;

                    Decal.Transparency = v155;
                end;
            end;
        end;

        if u139 and u139.Parent then
            local Parent = u139.Parent;

            if Parent and Parent:IsA("BasePart") then
                local v156;

                if v149 then
                    local Position2 = v146.Position;
                    local v157 = u99 * 45;
                    local v158;

                    if v157 <= 0.001 then
                        v158 = 1;
                    else
                        local v159 = Vector3.new(v148.X - Position2.X, 0, v148.Z - Position2.Z).Magnitude / v157;
                        v158 = math.clamp(v159, 0.01, 1);
                    end;

                    v156 = v158 or nil;
                else
                    v156 = nil;
                end;

                local v160 = u99;
                local v161 = v160 * -1;
                local v162 = v161 + (v156 or 1) * (v160 * 45 - v161);

                if u137 <= 0.267 then
                    local v163 = TweenService:GetValue(math.clamp(u137 / 0.267, 0, 1), Enum.EasingStyle.Quint, Enum.EasingDirection.Out);
                    u139.CFrame = CFrame.new(0, v161 + (v162 - v161) * v163, 0) * CFrame.Angles(0, 0, 1.5707963267948966);
                else
                    u139.CFrame = CFrame.new(0, v162, 0) * CFrame.Angles(0, 0, 1.5707963267948966);
                end;
            end;
        end;

        if u137 >= 0.1 and (u106 and u106.Parent) then
            if v149 then
                if u138 then
                    SkillCommon.pivotInstanceToWorldCF(u106, CFrame.new(v148) * (v146 - v146.Position) * (u112 or CFrame.identity));

                    return;
                end;

                u138 = true;
                SkillCommon.pivotInstanceToWorldCF(u106, CFrame.new(v148) * (v146 - v146.Position) * (u112 or CFrame.identity));
                FXUtil.Emit_Particles_GetDescendants(SkillCommon.findDescendantByName(u106, "Enabled和Emit_受击"), true);
                FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(u106, "Enabled和Emit_受击"), true);

                return;
            end;

            if u138 then
                u138 = false;
                FXUtil.SetEmittersTrailsBeamsEnabled(SkillCommon.findDescendantByName(u106, "Enabled和Emit_受击"), false);
            end;
        end;
    end);
    local v164 = u98:FindFirstChildOfClass("Humanoid");

    if v164 then
        local u165 = false;
        SkillCommon.bindHumanoidJumpWhile(u97, v164, u3.jumpCancel, function() -- Line: 302
            -- upvalues: tryJumpCancelMain (ref), u97 (copy), runGeneration (copy), u165 (copy)
            tryJumpCancelMain(u97, runGeneration, u165);
        end);
    end;

    SkillCommon.scheduleRunSpawnClear(u97, runGeneration, skillRunData, "WaterCannonSpawned", 5.733);
end;

function v1.Client_ExitMain(p166) -- Line: 751
    -- upvalues: SkillCommon (copy), u3 (copy), playMainEarlyLeaveFx (copy), SkillActionLock (copy)
    SkillCommon.disconnectRunEventKeys(p166.skillRunData, {
        u3.follow,
        u3.hitSync,
        u3.jumpCancel,
        u3.columnRetract
    });
    local skillRunData = p166.skillRunData;
    local v167, v168, v169;

    if skillRunData and not skillRunData.mainEarlyLeave then
        local skillRunData2 = p166.skillRunData;

        if (not (skillRunData2 and skillRunData2.State) and 0 or p166.nowTime - skillRunData2.State.enteredAt) < 3.4 then
            skillRunData.mainEarlyLeave = true;
            playMainEarlyLeaveFx(p166, p166.runGeneration);

            if p166.skillAction then
                p166.skillAction:Over(p166.nowTime);
            end;

            local v170 = p166.skillInputData and p166.skillInputData.character;

            if v170 then
                SkillActionLock.turn_Off_Action_Lock(v170);
            end;
        elseif skillRunData and (skillRunData and (not skillRunData.waterColumnEndSoundPlayed and skillRunData.waterColumnSustainOn)) then
            v167 = p166.skillInputData and p166.skillInputData.character;

            if v167 then
                v168 = v167:FindFirstChild("HumanoidRootPart");

                if v168 and v168.Parent then
                    v169 = v168:GetPivot().Position;
                else
                    v169 = v167:GetPivot().Position;
                end;
            else
                v169 = nil;
            end;

            if v169 then
                skillRunData.waterColumnEndSoundPlayed = true;
                SkillCommon.stopSoundLocalForSkill(p166, "音效-技能-水5-水柱攻击", 0.2);
                SkillCommon.playSoundLocal3D("音效-技能-水5-水柱消失", v169);
            end;
        end;
    elseif skillRunData and (skillRunData and (not skillRunData.waterColumnEndSoundPlayed and skillRunData.waterColumnSustainOn)) then
        v167 = p166.skillInputData and p166.skillInputData.character;

        if v167 then
            v168 = v167:FindFirstChild("HumanoidRootPart");

            if v168 and v168.Parent then
                v169 = v168:GetPivot().Position;
            else
                v169 = v167:GetPivot().Position;
            end;
        else
            v169 = nil;
        end;

        if v169 then
            skillRunData.waterColumnEndSoundPlayed = true;
            SkillCommon.stopSoundLocalForSkill(p166, "音效-技能-水5-水柱攻击", 0.2);
            SkillCommon.playSoundLocal3D("音效-技能-水5-水柱消失", v169);
        end;
    end;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p166, p166.runGeneration, skillRunData, "WaterCannonSpawned");
    end;
end;

local function cleanupShiftLockAndCastTrail(p171) -- Line: 768
    -- upvalues: SkillCommon (copy)
    local skillRunData = p171.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.restoreSkillShiftLock(p171);
    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "水炮Cast尾迹");
end;

function v1.Client_EnterRecovery(p172) -- Line: 777
    -- upvalues: SkillCommon (copy)
    SkillCommon.flushPhase1AndRelease(p172);
    local skillRunData = p172.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.restoreSkillShiftLock(p172);
    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "水炮Cast尾迹");
end;

function v1.onEnd(p173) -- Line: 782
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p173.skillRunData, {
        u3.follow,
        u3.hitSync,
        u3.jumpCancel,
        u3.columnRetract
    });

    if p173.skillRunData then
        SkillCommon.stopSoundLocalForSkill(p173, "音效-技能-水5-水柱攻击", 0.2);
        local skillRunData = p173.skillRunData;

        if not skillRunData then
            return;
        end;

        SkillCommon.restoreSkillShiftLock(p173);
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "水系尾迹", "水炮Cast尾迹");
    end;
end;

function v1.Server_EnterMain(u174) -- Line: 791
    -- upvalues: SkillCommon (copy), u2 (copy), buildFormCFFromCaster (copy), RunService (copy), u3 (copy), tryJumpCancelMain (copy)
    local skillInputData = u174.skillInputData;
    local u175;

    if skillInputData then
        u175 = skillInputData.character;
    else
        u175 = skillInputData;
    end;

    if not u175 then
        return;
    end;

    local HumanoidRootPart = u175:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u176 = u174.hitbox[1];

    if not (u176 and u176.hitbox) then
        return;
    end;

    local runGeneration = u174.runGeneration;
    local u177 = SkillCommon.scaleBandFromData(u174, SkillCommon.bandScaleOptsFromSkillData(u174));
    local hitbox = u176.hitbox;
    local u178 = {
        wallRayTag = "Ground",
        lowVisualClearStuds = 2.5,
        fullHorizSprayRange = true
    };
    local u179 = SkillCommon.resolveStrikeWorldPos(skillInputData);

    local function sprayOriginNow() -- Line: 817
        -- upvalues: HumanoidRootPart (copy), SkillCommon (ref), u2 (ref)
        local v180 = HumanoidRootPart;
        local buildFormationCFFromSnappedFlat = SkillCommon.buildFormationCFFromSnappedFlat;
        local CFrame2 = v180.CFrame;
        local v181 = Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);

        return (buildFormationCFFromSnappedFlat(v180, v181.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v181.Unit, u2) * CFrame.new(Vector3.new(1.081, 1.063, 0.543))).Position;
    end;

    local function formCFNow() -- Line: 821
        -- upvalues: buildFormCFFromCaster (ref), HumanoidRootPart (copy)
        return buildFormCFFromCaster(HumanoidRootPart);
    end;

    local function onHitTick() -- Line: 825
        -- upvalues: u174 (copy), runGeneration (copy), SkillCommon (ref), HumanoidRootPart (copy), u2 (ref), u179 (copy), u177 (copy), u175 (copy), u178 (copy), u176 (copy), hitbox (copy)
        local v182 = u174;
        local v183;

        if SkillCommon.isRunningSameGeneration(v182, runGeneration) then
            local v184 = v182.GetCurrentState and v182:GetCurrentState();
            v183 = v184 == "Main";
        else
            v183 = false;
        end;

        if not (v183 and HumanoidRootPart.Parent) then
            return;
        end;

        local v185 = HumanoidRootPart;
        local buildFormationCFFromSnappedFlat = SkillCommon.buildFormationCFFromSnappedFlat;
        local CFrame2 = v185.CFrame;
        local v186 = Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);
        local v187 = buildFormationCFFromSnappedFlat(v185, v186.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v186.Unit, u2);
        local v188 = HumanoidRootPart;
        local buildFormationCFFromSnappedFlat2 = SkillCommon.buildFormationCFFromSnappedFlat;
        local CFrame3 = v188.CFrame;
        local v189 = Vector3.new(CFrame3.LookVector.X, 0, CFrame3.LookVector.Z);
        local Position = (buildFormationCFFromSnappedFlat2(v188, v189.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v189.Unit, u2) * CFrame.new(Vector3.new(1.081, 1.063, 0.543))).Position;
        local resolveHorizSprayHitEnd = SkillCommon.resolveHorizSprayHitEnd;
        local Position2 = v187.Position;
        local v190 = Vector3.new(v187.LookVector.X, 0, v187.LookVector.Z);
        local v191, v192 = resolveHorizSprayHitEnd(HumanoidRootPart, u179, 45, u177, Position2, v190.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v190.Unit, u175, u178);

        if not v192 then
            if u176.isActive then
                u176:stop();
            end;

            return;
        end;

        SkillCommon.placeBoxHitboxBetween(hitbox, Position, v191, Vector3.new(9, 36, 9), u177);
        u176:start(true);
    end;

    onHitTick();

    for i = 1, 7 do
        task.delay(i * 0.5, function() -- Line: 853
            -- upvalues: onHitTick (copy)
            onHitTick();
        end);
    end;

    u174.skillRunData.runEvent["水炮命中盒同步"] = RunService.Heartbeat:Connect(function() -- Line: 859
        -- upvalues: u174 (copy), runGeneration (copy), SkillCommon (ref), HumanoidRootPart (copy), u2 (ref), u179 (copy), u177 (copy), u175 (copy), u178 (copy), hitbox (copy)
        local v193 = u174;
        local v194;

        if SkillCommon.isRunningSameGeneration(v193, runGeneration) then
            local v195 = v193.GetCurrentState and v193:GetCurrentState();
            v194 = v195 == "Main";
        else
            v194 = false;
        end;

        if not (v194 and HumanoidRootPart.Parent) then
            return;
        end;

        local v196 = HumanoidRootPart;
        local buildFormationCFFromSnappedFlat = SkillCommon.buildFormationCFFromSnappedFlat;
        local CFrame2 = v196.CFrame;
        local v197 = Vector3.new(CFrame2.LookVector.X, 0, CFrame2.LookVector.Z);
        local v198 = buildFormationCFFromSnappedFlat(v196, v197.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v197.Unit, u2);
        local v199 = HumanoidRootPart;
        local buildFormationCFFromSnappedFlat2 = SkillCommon.buildFormationCFFromSnappedFlat;
        local CFrame3 = v199.CFrame;
        local v200 = Vector3.new(CFrame3.LookVector.X, 0, CFrame3.LookVector.Z);
        local Position = (buildFormationCFFromSnappedFlat2(v199, v200.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v200.Unit, u2) * CFrame.new(Vector3.new(1.081, 1.063, 0.543))).Position;
        local resolveHorizSprayHitEnd = SkillCommon.resolveHorizSprayHitEnd;
        local Position2 = v198.Position;
        local v201 = Vector3.new(v198.LookVector.X, 0, v198.LookVector.Z);
        local v202, v203 = resolveHorizSprayHitEnd(HumanoidRootPart, u179, 45, u177, Position2, v201.Magnitude < 0.08 and Vector3.new(0, 0, -1) or v201.Unit, u175, u178);

        if v203 then
            SkillCommon.placeBoxHitboxBetween(hitbox, Position, v202, Vector3.new(9, 36, 9), u177);
        end;
    end);
    local v204 = u175:FindFirstChildOfClass("Humanoid");

    if not v204 then
        return;
    end;

    local u205 = true;
    SkillCommon.bindHumanoidJumpWhile(u174, v204, u3.jumpCancel, function() -- Line: 302
        -- upvalues: tryJumpCancelMain (ref), u174 (copy), runGeneration (copy), u205 (copy)
        tryJumpCancelMain(u174, runGeneration, u205);
    end);
end;

function v1.Server_ExitMain(p206) -- Line: 881
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p206.skillRunData, {
        u3.follow,
        u3.hitSync,
        u3.jumpCancel,
        u3.columnRetract
    });
    local v207 = p206.hitbox[1];

    if v207 and v207.isActive then
        v207:stop();
    end;
end;

function v1.Server_EnterRecovery(p208) -- Line: 889
    -- upvalues: SkillCommon (copy)
    SkillCommon.flushPhase1AndRelease(p208);
end;

function v1.onEndServer(p209) -- Line: 893
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p209.skillRunData, {
        u3.follow,
        u3.hitSync,
        u3.jumpCancel,
        u3.columnRetract
    });
    local v210 = p209.hitbox[1];

    if v210 and v210.isActive then
        v210:stop();
    end;
end;

v1.SoundList = { "音效-技能-水5-起手法阵", "音效-技能-水5-水柱攻击", "音效-技能-水5-水柱消失" };
v1.AnimateList = { "水泡动作起手", "水炮动作循环", "水炮动作结束" };
v1.ResNameList = { "水系尾迹", "水炮_法阵", "水炮_水柱", "水炮_水龙卷", "水炮_爆炸" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.6,
        animationName = "水泡动作起手",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    },
    {
        action = "Animation",
        startTime = 1.6,
        overTime = 5.233,
        animationName = "水炮动作循环",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationLoop = true,
        animationPriority = Enum.AnimationPriority.Action4
    },
    {
        action = "Animation",
        startTime = 5.233,
        overTime = 6.233,
        animationName = "水炮动作结束",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;