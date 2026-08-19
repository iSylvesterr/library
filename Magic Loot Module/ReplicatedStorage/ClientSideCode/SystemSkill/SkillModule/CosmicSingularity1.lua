-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local TweenService = game:GetService("TweenService");
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Space,
    skillDistanceLimit = 73,
    InitialState = "Startup",
    ControlOpenState = "SingularityBurst",
    States = {
        Startup = {
            Duration = 0.73,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        HelixDescent = {
            Duration = 0.67,
            OnEnterClient = "Client_EnterHelixDescent",
            OnEnterServer = "Server_EnterHelixDescent",
            OnExitClient = nil,
            OnExitServer = nil
        },
        SingularityBurst = {
            Duration = 1.767,
            OnEnterClient = "Client_EnterSingularityBurst",
            OnEnterServer = "Server_EnterSingularityBurst",
            OnExitClient = nil,
            OnExitServer = nil
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
            To = "HelixDescent",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "HelixDescent",
            To = "SingularityBurst",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "SingularityBurst",
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
            From = "HelixDescent",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "SingularityBurst",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "HelixDescent",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "SingularityBurst",
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

local function fusionAboveY(p2) -- Line: 86
    -- upvalues: SkillCommon (copy)
    return 12 * SkillCommon.skillScaleFromSkillData(p2);
end;

local function vfxAboveY(p3) -- Line: 90
    -- upvalues: SkillCommon (copy)
    return 20 * SkillCommon.skillScaleFromSkillData(p3);
end;

local function helixStartYOffset(p4) -- Line: 94
    -- upvalues: SkillCommon (copy)
    return 80 * SkillCommon.skillScaleFromSkillData(p4);
end;

local function helixBandYOffset(p5) -- Line: 98
    -- upvalues: SkillCommon (copy)
    return 12 * SkillCommon.skillScaleFromSkillData(p5);
end;

local function targetGroundWorldPos(p6) -- Line: 102
    -- upvalues: SkillCommon (copy)
    local v7 = SkillCommon.resolveTrackTargetHrp(p6);

    return not (v7 and v7.Parent) and (p6 and (p6.targetCF and SkillCommon.resolveStrikeGroundWorldPos(p6, 4, 0.5, "Ground")) or Vector3.new(0, 0, 0)) or SkillCommon.getGroundCF(CFrame.new(v7.Position), 4, 0.5, "Ground").Position;
end;

local function fusionWorldPos(p8) -- Line: 110
    -- upvalues: targetGroundWorldPos (copy), SkillCommon (copy)
    local v9 = targetGroundWorldPos(p8.skillInputData);
    local v10 = 12 * SkillCommon.skillScaleFromSkillData(p8);

    return v9 + Vector3.new(0, v10, 0);
end;

local function strikeLockHitCF(p11, p12) -- Line: 116
    -- upvalues: SkillCommon (copy), targetGroundWorldPos (copy)
    if p12 then
        SkillCommon.refreshSkillAimSnapshot(p11);
    end;

    local skillInputData = p11.skillInputData;
    local v13 = targetGroundWorldPos(skillInputData);
    local v14 = 20 * SkillCommon.skillScaleFromSkillData(p11);
    local v15 = v13 + Vector3.new(0, v14, 0);
    local v16 = SkillCommon.resolveTrackPos(skillInputData, v15);

    return CFrame.new((Vector3.new(v16.X, v15.Y, v16.Z)));
end;

function v1.Client_EnterStartup(p17) -- Line: 128
    -- upvalues: SkillCommon (copy)
    local character = p17.skillInputData.character;

    if not character then
        return;
    end;

    local v18 = SkillCommon.resolveWandTipFromCharacter(character);

    if v18 then
        SkillCommon.scheduleWandTipElementTrail(p17, v18, {
            trailMaterialKey = "空间系尾迹",
            runEventKey = "宇宙奇点尾迹",
            enableAt = 0.3,
            disableAt = 0.9
        });
    end;
end;

function v1.Server_EnterStartup(p19) -- Line: 144
    -- upvalues: SkillCommon (copy), targetGroundWorldPos (copy), RunService (copy)
    local u20 = p19.hitbox[1];

    if not (u20 and u20.hitbox) then
        return;
    end;

    local v21 = 80 * SkillCommon.scaleBandFromData(p19, SkillCommon.bandScaleOptsFromSkillData(p19));
    u20.hitbox.Size = Vector3.new(v21, v21, v21);
    local hitbox = u20.hitbox;
    local skillRunData = p19.skillRunData;
    skillRunData.cosmicSingularity = skillRunData.cosmicSingularity or {};
    local cosmicSingularity = skillRunData.cosmicSingularity;
    local skillInputData = p19.skillInputData;
    local v22 = targetGroundWorldPos(skillInputData);
    local v23 = 20 * SkillCommon.skillScaleFromSkillData(p19);
    local v24 = v22 + Vector3.new(0, v23, 0);
    local v25 = SkillCommon.resolveTrackPos(skillInputData, v24);
    cosmicSingularity.lockHitCF = CFrame.new((Vector3.new(v25.X, v24.Y, v25.Z)));
    local u26 = 0;
    local u27 = 0;
    local u28 = nil;
    local u29 = { 1.4, 1.667, 2.083, 2.5, 2.917, 3.167 };
    local u30 = u29[#u29];
    u28 = RunService.Heartbeat:Connect(function(p31) -- Line: 171
        -- upvalues: u26 (ref), u27 (ref), u29 (copy), skillRunData (copy), hitbox (copy), u20 (copy), u30 (copy), u28 (ref)
        u26 = u26 + p31;

        while true do
            local v32 = u27 + 1;

            if #u29 < v32 or u26 < u29[v32] then
                break;
            end;

            u27 = v32;
            local v33 = skillRunData.cosmicSingularity and skillRunData.cosmicSingularity.lockHitCF;

            if v33 then
                hitbox:PivotTo(v33);
            end;

            u20:start();
            task.delay(0.12, function() -- Line: 184
                -- upvalues: u20 (ref)
                if u20.isActive then
                    u20:stop();
                end;
            end);
        end;

        if u26 >= u30 + 0.15 then
            u28:Disconnect();
        end;
    end);
    p19:BindRunConn(u28);
end;

function v1.Client_EnterHelixDescent(u34) -- Line: 199
    -- upvalues: SkillCommon (copy), targetGroundWorldPos (copy), VisibleMgr (copy), FXUtil (copy), RunService (copy)
    local character = u34.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local skillRunData = u34.skillRunData;
    local material = skillRunData.material;

    if not material then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u34);
    local v35 = targetGroundWorldPos(u34.skillInputData);
    local v36 = 12 * SkillCommon.skillScaleFromSkillData(u34);
    local u37 = v35 + Vector3.new(0, v36, 0);
    local u38, u39 = SkillCommon.horizontalHrpStrikeFlatBasis(HumanoidRootPart, u37);
    local v40 = SkillCommon.scaleBandFromData(u34, SkillCommon.bandScaleOptsFromSkillData(u34));
    local v41 = material["宇宙奇点法阵"];

    if v41 then
        v41:ScaleTo(v40);
        local v42 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.5, "Ground");
        v41:PivotTo(CFrame.new(v42));
        VisibleMgr.UnQueryAll(v41);
        v41.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v41, true);
        SkillCommon.playSoundLocal3D("音效-技能-空间系法阵", v41:GetPivot().Position);
    end;

    local u43 = material["宇宙奇点白球"];
    local u44 = material["宇宙奇点黑球"];

    if not (u43 and u44) then
        return;
    end;

    u43:ScaleTo(v40);
    u44:ScaleTo(v40);
    VisibleMgr.UnQueryAll(u43);
    VisibleMgr.UnQueryAll(u44);
    u43.Parent = workspace.Debris;
    u44.Parent = workspace.Debris;
    FXUtil.SetEnableNameVfx(u43, true);
    FXUtil.SetEnableNameVfx(u44, true);
    local v45 = 80 * SkillCommon.skillScaleFromSkillData(u34);
    local u46 = u37 + Vector3.new(0, v45, 0);
    SkillCommon.playSoundLocal3D("音效-技能-宇宙奇点-双球下降", u46);
    local runGeneration = u34.runGeneration;
    local u47 = os.clock();
    local u48 = 6 * v40;

    local function smoothstep01(p49) -- Line: 267
        local v50 = math.clamp(p49, 0, 1);

        return v50 * v50 * (3 - v50 * 2);
    end;

    local function halfSepFromElapsed(p51, p52) -- Line: 271
        local v53 = math.clamp(p51 / p52, 0, 1);

        if v53 <= 0.75 then
            return v53 / 0.75 * 12.5 + 12.5;
        end;

        return math.max(2.5, (1 - (v53 - 0.75) / 0.25) ^ 3 * 25);
    end;

    local function axisMergeSpiralHalf(p54, p55, p56) -- Line: 280
        -- upvalues: u48 (copy)
        local v57 = math.clamp(p54 / p55, 0, 1);

        if v57 <= 0.75 then
            return 0;
        end;

        return u48 * math.clamp(1 - p56 / 8, 0, 1) * (1 - (v57 - 0.75) / 0.25) ^ 0.35;
    end;

    local u58 = u37.Y + 12 * SkillCommon.skillScaleFromSkillData(u34);
    local u59 = nil;
    local u60 = nil;
    local u61 = nil;
    local u62 = nil;
    skillRunData.cosmicSingularity = {
        white = u43,
        black = u44
    };
    u34:BindStateConn("HelixDescent", (RunService.RenderStepped:Connect(function() -- Line: 304
        -- upvalues: u34 (copy), runGeneration (copy), u47 (copy), u46 (copy), u37 (copy), u38 (copy), u39 (copy), u58 (copy), u48 (copy), u43 (copy), u44 (copy), u59 (ref), u60 (ref), u61 (ref), u62 (ref)
        if not u34:isRunningFlow() or u34.runGeneration ~= runGeneration then
            return;
        end;

        local v63 = os.clock() - u47;
        local v64 = math.min(v63 / 0.67, 1) * 1.3;
        local u65 = u46:Lerp(u37, v64 / 1.3);
        local u66 = v64 * 2 * 3.141592653589793;
        local v67 = math.cos(u66) * u38 + math.sin(u66) * u39;
        local v68 = math.cos(u66 + 3.141592653589793) * u38 + math.sin(u66 + 3.141592653589793) * u39;

        if u58 < u65.Y then
            local v69 = math.clamp(v63 / 0.67, 0, 1);
            local v70;

            if v69 <= 0.75 then
                v70 = v69 / 0.75 * 12.5 + 12.5;
            else
                v70 = math.max(2.5, (1 - (v69 - 0.75) / 0.25) ^ 3 * 25);
            end;

            local v71 = math.clamp(v63 / 0.67, 0, 1);
            local v72;

            if v71 <= 0.75 then
                v72 = 0;
            else
                v72 = u48 * math.clamp(1 - v70 / 8, 0, 1) * (1 - (v71 - 0.75) / 0.25) ^ 0.35;
            end;

            local v73 = u65 + v72 * (math.cos(u66) * u38 + math.sin(u66) * u39);
            u43:PivotTo(CFrame.new(v73 + v70 * v67));
            u44:PivotTo(CFrame.new(v73 + v70 * v68));

            return;
        end;

        if u59 == nil then
            u59 = v63;
            local v74 = math.clamp(v63 / 0.67, 0, 1);
            local v75;

            if v74 <= 0.75 then
                v75 = v74 / 0.75 * 12.5 + 12.5;
            else
                v75 = math.max(2.5, (1 - (v74 - 0.75) / 0.25) ^ 3 * 25);
            end;

            u60 = v75 * 2;
        end;

        local v76 = u59;
        local v77 = u60;
        local v78 = 0.67 - v76;
        local v79 = v78 <= 0.00001 and 1 or math.clamp((v63 - v76) / v78, 0, 1);
        local u80 = nil;
        local u81 = nil;

        local function applyPlateauHorizontal(p82) -- Line: 340
            -- upvalues: u61 (ref), u66 (copy), u81 (ref), u38 (ref), u39 (ref), u80 (ref), u62 (ref), u65 (copy), u43 (ref), u44 (ref)
            if u61 == nil then
                u61 = u66;
            end;

            u81 = u61;
            local v83 = math.cos(u81) * u38 + math.sin(u81) * u39;
            local v84 = math.clamp(p82, 0, 1);
            local v85 = math.clamp(v84, 0, 1);
            u80 = v85 * v85 * (3 - v85 * 2) * -2.5 + 5;

            if u62 == nil then
                u62 = u65.Y;
            end;

            local v86 = Vector3.new(u65.X, u62, u65.Z);
            local v87 = v86 + u80 * (math.cos(u81 + 3.141592653589793) * u38 + math.sin(u81 + 3.141592653589793) * u39);
            u43:PivotTo(CFrame.new(v86 + u80 * v83));
            u44:PivotTo(CFrame.new(v87));
        end;

        if v77 <= 10 then
            if u61 == nil then
                u61 = u66;
            end;

            u81 = u61;
            local v88 = v77 / 2;
            local v89 = math.clamp(v79, 0, 1);
            u80 = v88 + (2.5 - v88) * (v89 * v89 * (3 - v89 * 2));

            if u62 == nil then
                u62 = u65.Y;
            end;

            local v90 = Vector3.new(u65.X, u62, u65.Z);
            local v91 = math.cos(u81) * u38 + math.sin(u81) * u39;
            local v92 = math.cos(u81 + 3.141592653589793) * u38 + math.sin(u81 + 3.141592653589793) * u39;
            u43:PivotTo(CFrame.new(v90 + u80 * v91));
            u44:PivotTo(CFrame.new(v90 + u80 * v92));

            return;
        end;

        if v79 >= 0.679999 then
            applyPlateauHorizontal((v79 - 0.68) / 0.31999999999999995);

            return;
        end;

        local v93 = math.clamp(v79 / 0.68, 0, 1);
        u80 = (v77 + (10 - v77) * (v93 * v93 * (3 - v93 * 2))) / 2;
        local v94 = math.clamp(v63 / 0.67, 0, 1);
        local v95;

        if v94 <= 0.75 then
            v95 = v94 / 0.75 * 12.5 + 12.5;
        else
            v95 = math.max(2.5, (1 - (v94 - 0.75) / 0.25) ^ 3 * 25);
        end;

        local v96 = math.clamp(v63 / 0.67, 0, 1);
        local v97;

        if v96 <= 0.75 then
            v97 = 0;
        else
            v97 = u48 * math.clamp(1 - v95 / 8, 0, 1) * (1 - (v96 - 0.75) / 0.25) ^ 0.35;
        end;

        u81 = u66;
        local v98 = u65 + v97 * (math.cos(u66) * u38 + math.sin(u66) * u39);
        u43:PivotTo(CFrame.new(v98 + u80 * v67));
        u44:PivotTo(CFrame.new(v98 + u80 * v68));
    end)));
end;

function v1.Server_EnterHelixDescent(p99) -- Line: 405
end;

local function holeModelScaleTween(u100, u101, u102, u103, u104, u105, u106, u107) -- Line: 411
    -- upvalues: RunService (copy), TweenService (copy)
    task.spawn(function() -- Line: 421
        -- upvalues: u105 (ref), u106 (ref), u104 (copy), u100 (copy), u101 (copy), RunService (ref), u103 (copy), TweenService (ref), u102 (copy), u107 (copy)
        u105 = u105 or Enum.EasingStyle.Linear;
        u106 = u106 or Enum.EasingDirection.In;

        if u104.abort or not u100.Parent then
            return;
        end;

        if not u100:GetAttribute("ModelScale") then
            u100:SetAttribute("ModelScale", u100:GetScale());
        end;

        u100:ScaleTo(u101);
        local v108 = u100:GetPivot();
        local v109 = 0;

        while v109 < 1 do
            if u104.abort or not u100.Parent then
                return;
            end;

            local v110 = v109 + RunService.Heartbeat:Wait() / u103;
            v109 = math.min(v110, 1);

            if u104.abort or not u100.Parent then
                return;
            end;

            local v111 = TweenService:GetValue(v109, u105, u106);
            u100:ScaleTo(u101 + (u102 - u101) * v111);
            u100:PivotTo(v108);
        end;

        if u104.abort then
            return;
        end;

        if u107 then
            u107();
        end;
    end);
end;

function v1.Client_EnterSingularityBurst(u112) -- Line: 455
    -- upvalues: FXUtil (copy), SkillCommon (copy), targetGroundWorldPos (copy), VisibleMgr (copy), RunService (copy), TweenService (copy)
    local skillRunData = u112.skillRunData;
    local material = skillRunData.material;
    local cosmicSingularity = skillRunData.cosmicSingularity;
    local runGeneration = u112.runGeneration;

    if cosmicSingularity then
        if cosmicSingularity.white then
            FXUtil.HideModelBasePartsStopEmit(cosmicSingularity.white);
        end;

        if cosmicSingularity.black then
            FXUtil.HideModelBasePartsStopEmit(cosmicSingularity.black);
        end;

        task.delay(0.25, function() -- Line: 467
            -- upvalues: u112 (copy), cosmicSingularity (copy)
            if not u112:isRunningFlow() then
                return;
            end;

            if cosmicSingularity.white then
                cosmicSingularity.white:Destroy();
            end;

            if cosmicSingularity.black then
                cosmicSingularity.black:Destroy();
            end;

            cosmicSingularity.white = nil;
            cosmicSingularity.black = nil;
        end);
    end;

    local skillInputData = u112.skillInputData;
    SkillCommon.refreshSkillAimSnapshot(u112);
    local v113 = targetGroundWorldPos(skillInputData);
    local v114 = 20 * SkillCommon.skillScaleFromSkillData(u112);
    local v115 = v113 + Vector3.new(0, v114, 0);
    local v116 = SkillCommon.resolveTrackPos(skillInputData, v115);
    local v117 = Vector3.new(v116.X, v115.Y, v116.Z);
    local u118 = SkillCommon.scaleBandFromData(u112, SkillCommon.bandScaleOptsFromSkillData(u112));
    local u119 = CFrame.new(v117);
    local u120 = material["宇宙奇点_大黑洞_Emit和Enabled"];
    local v121 = material["宇宙奇点爆炸"];
    local u122 = nil;

    if u120 then
        u120:ScaleTo(u118);
        VisibleMgr.UnQueryAll(u120);
        u120:PivotTo(u119);
        u120.Parent = workspace.Debris;
        FXUtil.EmitBurstEmitInName(u120, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(u120, true);
        FXUtil.SetEnableNameVfx(u120, true);
        local u123 = u120:FindFirstChild("黑洞model");

        if u123 then
            u122 = {
                abort = false
            };
            skillRunData.cosmicSingularity = skillRunData.cosmicSingularity or {};
            skillRunData.cosmicSingularity.holeTweenAbort = u122;
            VisibleMgr.fadeAll(u123, 1);
            local u124 = { 1, 1.2, 0.6, 1.4, 0.6, 1 };

            local function runHoleRoundSeg(u125, u126) -- Line: 514
                -- upvalues: u112 (copy), runGeneration (copy), u123 (copy), runHoleRoundSeg (copy), u124 (copy), u118 (copy), u122 (copy), RunService (ref), TweenService (ref)
                if not u112:isRunningFlow() or u112.runGeneration ~= runGeneration then
                    return;
                end;

                if not u123.Parent then
                    return;
                end;

                if u126 > 5 then
                    if u125 >= 4 then
                        return;
                    end;

                    runHoleRoundSeg(u125 + 1, 1);

                    return;
                end;

                local u127 = u118 * u124[u126];
                local u128 = u118 * u124[u126 + 1];
                local u129 = u123;
                local u130 = u122;
                local Quad = Enum.EasingStyle.Quad;
                local InOut = Enum.EasingDirection.InOut;

                local function u131() -- Line: 532
                    -- upvalues: u112 (ref), runGeneration (ref), runHoleRoundSeg (ref), u125 (copy), u126 (copy)
                    if not u112:isRunningFlow() or u112.runGeneration ~= runGeneration then
                        return;
                    end;

                    runHoleRoundSeg(u125, u126 + 1);
                end;

                local u132 = 0.083;
                task.spawn(function() -- Line: 421
                    -- upvalues: Quad (ref), InOut (ref), u130 (copy), u129 (copy), u127 (copy), RunService (ref), u132 (copy), TweenService (ref), u128 (copy), u131 (copy)
                    Quad = Quad or Enum.EasingStyle.Linear;
                    InOut = InOut or Enum.EasingDirection.In;

                    if u130.abort or not u129.Parent then
                        return;
                    end;

                    if not u129:GetAttribute("ModelScale") then
                        u129:SetAttribute("ModelScale", u129:GetScale());
                    end;

                    u129:ScaleTo(u127);
                    local v133 = u129:GetPivot();
                    local v134 = 0;

                    while v134 < 1 do
                        if u130.abort or not u129.Parent then
                            return;
                        end;

                        local v135 = v134 + RunService.Heartbeat:Wait() / u132;
                        v134 = math.min(v135, 1);

                        if u130.abort or not u129.Parent then
                            return;
                        end;

                        local v136 = TweenService:GetValue(v134, Quad, InOut);
                        u129:ScaleTo(u127 + (u128 - u127) * v136);
                        u129:PivotTo(v133);
                    end;

                    if u130.abort then
                        return;
                    end;

                    if u131 then
                        u131();
                    end;
                end);
            end;

            task.delay(0.017, function() -- Line: 540
                -- upvalues: u112 (copy), runGeneration (copy), u123 (copy), VisibleMgr (ref), u118 (copy), u124 (copy), runHoleRoundSeg (copy)
                if not u112:isRunningFlow() or u112.runGeneration ~= runGeneration then
                    return;
                end;

                if not u123.Parent then
                    return;
                end;

                VisibleMgr.showAll(u123);
                u123:ScaleTo(u118 * u124[1]);
                runHoleRoundSeg(1, 1);
            end);
        end;
    end;

    if v121 then
        v121:ScaleTo(u118);
        VisibleMgr.UnQueryAll(v121);
        v121:PivotTo(u119);
        v121.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v121, true);
        SkillCommon.playSoundLocal3D("音效-技能-宇宙奇点-第一次爆炸加蓄力", u119.Position);
    end;

    skillRunData.cosmicSingularity = skillRunData.cosmicSingularity or {};
    skillRunData.cosmicSingularity.blackHole = u120;

    if u120 then
        skillRunData._blackHoleF190Refs = {
            model = u120,
            abort = u122
        };
    end;

    task.delay(1.767, function() -- Line: 571
        -- upvalues: u112 (copy), runGeneration (copy), skillRunData (copy), u120 (copy), FXUtil (ref), material (copy), u118 (copy), VisibleMgr (ref), u119 (copy), SkillCommon (ref)
        local v137 = u112:isRunningFlow() and u112.runGeneration == runGeneration;
        local _blackHoleF190Refs = skillRunData._blackHoleF190Refs;

        if _blackHoleF190Refs and _blackHoleF190Refs.abort then
            _blackHoleF190Refs.abort.abort = true;
        end;

        task.defer(function() -- Line: 577
            -- upvalues: u120 (ref)
            local v138 = u120;

            if v138 and v138.Parent then
                local v139 = v138:FindFirstChild("黑洞model", true);

                if v139 and v139.Parent then
                    v139:Destroy();
                end;
            end;
        end);

        if u120 and u120.Parent then
            FXUtil.OffEnableVfx(u120);
            FXUtil.SetEmittersTrailsBeamsEnabled(u120, false);
        end;

        skillRunData._blackHoleF190Refs = nil;
        local v140 = v137 and material["宇宙奇点爆炸"];

        if v140 then
            v140:ScaleTo(u118);
            VisibleMgr.UnQueryAll(v140);
            v140:PivotTo(u119);
            v140.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(v140, true);
            SkillCommon.playSoundLocal3D("音效-技能-宇宙奇点-第二次爆炸", u119.Position);
        end;

        task.delay(2, function() -- Line: 602
            -- upvalues: u120 (ref)
            if u120 and u120.Parent then
                u120:Destroy();
            end;
        end);
    end);
end;

function v1.onEnd(p141) -- Line: 611
    -- upvalues: FXUtil (copy)
    local skillRunData = p141.skillRunData;

    if not skillRunData then
        return;
    end;

    local _blackHoleF190Refs = skillRunData._blackHoleF190Refs;

    if not (_blackHoleF190Refs and _blackHoleF190Refs.model) then
        return;
    end;

    skillRunData._blackHoleF190Refs = nil;

    if _blackHoleF190Refs.abort then
        _blackHoleF190Refs.abort.abort = true;
    end;

    local model = _blackHoleF190Refs.model;

    if model.Parent then
        local v142 = model:FindFirstChild("黑洞model", true);

        if v142 and v142.Parent then
            v142:Destroy();
        end;

        FXUtil.OffEnableVfx(model);
        FXUtil.SetEmittersTrailsBeamsEnabled(model, false);
        model:Destroy();
    end;
end;

function v1.Server_EnterSingularityBurst(p143) -- Line: 636
    -- upvalues: strikeLockHitCF (copy)
    local skillRunData = p143.skillRunData;
    skillRunData.cosmicSingularity = skillRunData.cosmicSingularity or {};
    skillRunData.cosmicSingularity.lockHitCF = strikeLockHitCF(p143, true);
end;

function v1.Server_EnterRecovery(p144) -- Line: 643
    p144:releaseControl();
end;

function v1.Client_EnterRecovery(p145) -- Line: 647
    -- upvalues: SkillCommon (copy)
    local skillRunData = p145.skillRunData;
    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "空间系尾迹", "宇宙奇点尾迹");

    if skillRunData.cosmicSingularity then
        skillRunData.cosmicSingularity = nil;
    end;
end;

v1.SoundList = { "音效-技能-空间系法阵", "音效-技能-宇宙奇点-双球下降", "音效-技能-宇宙奇点-第一次爆炸加蓄力", "音效-技能-宇宙奇点-第二次爆炸" };
v1.AnimateList = { "技能释放动作4" };
v1.ResNameList = { "宇宙奇点法阵", "宇宙奇点白球", "宇宙奇点黑球", "宇宙奇点_大黑洞_Emit和Enabled", "宇宙奇点爆炸", "空间系尾迹" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
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