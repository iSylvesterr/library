-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local RequiemConfig = require(script:WaitForChild("RequiemConfig"));
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local TweenService = game:GetService("TweenService");
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Dark,
    skillDistanceLimit = 64
};
local u2 = {
    min = 0.5,
    max = 1
};
local u3 = { "暗夜亡魂跟随", "暗夜亡魂外形1", "暗夜亡魂外形2", "暗夜亡魂外形3" };
local u4 = { "暗夜亡魂跟随", "暗夜亡魂外形1", "暗夜亡魂外形2", "暗夜亡魂外形3", "暗夜亡魂Cast尾迹" };

local function disconnectRequiemRunEvents(p5, p6) -- Line: 75
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p5, p6);
end;

local function returnRequiemSpawnListToPool(p7) -- Line: 80
    -- upvalues: FXUtil (copy)
    if not p7 then
        return;
    end;

    local requiemSpawns = p7.requiemSpawns;

    if not requiemSpawns then
        return;
    end;

    for _, v in requiemSpawns do
        if v and v.Parent then
            FXUtil.Stop_All_Emit(v);
            FXUtil.SetEmittersTrailsBeamsEnabled(v, false);
            FXUtil.OffEnableVfx(v);

            if v:IsA("Model") then
                FXUtil.BackPool_Instance(v);
            else
                v:Destroy();
            end;
        end;
    end;

    p7.requiemSpawns = nil;
end;

local function destroyRequiemChannelVfx(p8) -- Line: 104
    -- upvalues: u3 (copy), SkillCommon (copy), returnRequiemSpawnListToPool (copy)
    if not p8 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p8, u3);
    returnRequiemSpawnListToPool(p8);
end;

local function cleanupRequiemClientVfx(p9) -- Line: 113
    -- upvalues: u4 (copy), SkillCommon (copy), returnRequiemSpawnListToPool (copy)
    if not p9 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p9, u4);
    returnRequiemSpawnListToPool(p9);
    SkillCommon.cleanupWandTipTrailFromMaterial(p9, "暗系尾迹", "暗夜亡魂Cast尾迹");
end;

local function cleanupRequiemServerFx(p10) -- Line: 122
    -- upvalues: SkillCommon (copy)
    if not p10 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p10, { "暗夜亡魂命中盒" });
end;

local function groundPivotAt(p11, p12) -- Line: 130
    -- upvalues: RequiemConfig (copy)
    if RequiemConfig.GroundPivotIdentityRotation then
        return CFrame.new(p11);
    end;

    if p12 then
        return CFrame.new(p11) * p12:GetPivot().Rotation;
    end;

    return CFrame.new(p11);
end;

local function groundPosLift(p13) -- Line: 141
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p13), 4, 1.5, "Ground").Position;
end;

local function nightmareCfFromKeyframes(p14, p15, p16, p17) -- Line: 148
    -- upvalues: RequiemConfig (copy), groundPosLift (copy)
    if RequiemConfig.UseLookAtNightmareRotation then
        return RequiemConfig.nightmareCFrameLookAtAtTime(p15, p16, p14, p17, groundPosLift);
    end;

    local v18 = RequiemConfig.strikeOffsetWorld(p14, RequiemConfig.nightmarePosDeltaAtTime(p15, p16), p17);

    return CFrame.new(v18) * RequiemConfig.nightmareRotationOnlyAtTime(p15, p16);
end;

local function playShapeTween(p19, u20, u21) -- Line: 158
    -- upvalues: RunService (copy), TweenService (copy)
    local u22 = p19:FindFirstChild("外形", true);

    if not (u22 and u22:IsA("Model")) then
        return;
    end;

    u22:ScaleTo(0.01);
    local u23 = 0;

    if u20.runEvent[u21] then
        u20.runEvent[u21]:Disconnect();
        u20.runEvent[u21] = nil;
    end;

    u20.runEvent[u21] = RunService.Heartbeat:Connect(function(p24) -- Line: 169
        -- upvalues: u23 (ref), TweenService (ref), u22 (copy), u20 (copy), u21 (copy)
        u23 = u23 + p24;
        local v25 = math.clamp(u23 / 0.167, 0, 1);
        local v26 = 0.01 + TweenService:GetValue(v25, Enum.EasingStyle.Back, Enum.EasingDirection.Out) * 0.99;

        if u22.Parent then
            u22:ScaleTo(v26);
        end;

        if v25 >= 1 and u20.runEvent[u21] then
            u20.runEvent[u21]:Disconnect();
            u20.runEvent[u21] = nil;
        end;
    end);
end;

local function burstEyeFlashEmitOnce(p27) -- Line: 188
    -- upvalues: FXUtil (copy)
    local v28 = p27:FindFirstChild("外形");

    if not v28 then
        return;
    end;

    local v29 = v28:FindFirstChild("眼球闪光");

    if not v29 then
        return;
    end;

    FXUtil.EmitBurstEmitInName(v29, true);
end;

local function fadeShapeModelAtF150(p30) -- Line: 200
    -- upvalues: VisibleMgr (copy)
    local v31 = p30:FindFirstChild("外形");

    if not (v31 and v31:IsA("Model")) then
        return;
    end;

    VisibleMgr.FadeCharacterModel(v31, 1, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
end;

local function stillChannel(p32, p33) -- Line: 208
    local v34 = p32:isRunningFlow() and p32.runGeneration == p33;

    return v34;
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Recovery";
v1.States = {
    Startup = {
        Duration = 0.75,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    Channel = {
        Duration = 4,
        OnEnterClient = "Client_EnterChannel",
        OnEnterServer = "Server_EnterChannel",
        OnExitClient = "Client_ExitChannel",
        OnExitServer = "Server_ExitChannel"
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
        To = "Channel",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Channel",
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
        From = "Channel",
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
        From = "Channel",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function v1.Client_EnterStartup(p35) -- Line: 256
    -- upvalues: SkillCommon (copy)
    local character = p35.skillInputData.character;

    if not character then
        return;
    end;

    local v36 = SkillCommon.resolveWandTipFromCharacter(character);

    if v36 then
        SkillCommon.scheduleWandTipElementTrail(p35, v36, {
            trailMaterialKey = "暗系尾迹",
            runEventKey = "暗夜亡魂Cast尾迹",
            enableAt = 0.47,
            disableAt = 0.85
        });
    end;
end;

function v1.Server_EnterStartup(p37) -- Line: 272
    -- upvalues: SkillCommon (copy), u2 (copy), RequiemConfig (copy)
    local v38 = SkillCommon.scaleBandFromData(p37, u2);
    local v39 = RequiemConfig.HitboxSize * v38;
    local v40 = p37.hitbox[1];

    if v40 and v40.hitbox then
        v40.hitbox.Size = v39;
    end;

    local v41 = p37.hitbox[2];

    if v41 and v41.hitbox then
        v41.hitbox.Size = v39;
    end;

    local v42 = p37.hitbox[3];

    if v42 and v42.hitbox then
        v42.hitbox.Size = v39;
    end;
end;

function v1.Client_EnterChannel(u43) -- Line: 285
    -- upvalues: SkillCommon (copy), RequiemConfig (copy), u2 (copy), VisibleMgr (copy), FXUtil (copy), nightmareCfFromKeyframes (copy), playShapeTween (copy), groundPivotAt (copy), RunService (copy)
    local skillInputData = u43.skillInputData;

    if not skillInputData then
        return;
    end;

    local character = skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u43);
    local runGeneration = u43.runGeneration;
    local skillRunData = u43.skillRunData;
    local u44 = RequiemConfig.flatHorizontalLookAtCast(HumanoidRootPart, skillInputData.releaseCF);
    local u45 = SkillCommon.scaleBandFromData(u43, u2);
    local v46 = skillRunData.material["暗夜亡魂法阵"];
    local u47 = skillRunData.material["暗夜亡魂法阵上空眼球"];
    local u48 = skillRunData.material["暗夜亡魂魇梦模板"];
    local u49 = skillRunData.material["暗夜亡魂地面模板"];
    local v50 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart) + Vector3.new(0, 0.5, 0);
    local v51 = v50 + (RequiemConfig.CasterDeltaF30.eyeAboveFormation - RequiemConfig.CasterDeltaF30.formation);

    if v46 then
        VisibleMgr.UnQueryAll(v46);
        v46:ScaleTo(u45);
        v46:PivotTo(CFrame.new(v50) * v46:GetPivot().Rotation);
        v46.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v46, true);

        if u43:isRunningFlow() then
            SkillCommon.playSoundLocal3D("音效-技能-暗夜亡魂-法阵", v50);
        end;

        SkillCommon.appendRunSpawnList(skillRunData, "requiemSpawns", v46);
        skillRunData.material["暗夜亡魂法阵"] = nil;
    end;

    if u47 then
        VisibleMgr.UnQueryAll(u47);
        u47:ScaleTo(u45);
        u47:PivotTo(CFrame.new(v51) * u47:GetPivot().Rotation);
        u47.Parent = workspace.Debris;
        FXUtil.SetEmittersTrailsBeamsEnabled(u47, true);
        FXUtil.Emit_Particles_GetDescendants(u47, false);
        SkillCommon.appendRunSpawnList(skillRunData, "requiemSpawns", u47);
        skillRunData.material["暗夜亡魂法阵上空眼球"] = nil;
    end;

    task.delay(1.5, function() -- Line: 343
        -- upvalues: u43 (copy), runGeneration (copy), u47 (copy), FXUtil (ref)
        local v52 = u43;
        local v53 = v52:isRunningFlow() and v52.runGeneration == runGeneration;

        if not v53 then
            return;
        end;

        if u47 and u47.Parent then
            FXUtil.Stop_All_Emit(u47);
            FXUtil.SetEmittersTrailsBeamsEnabled(u47, false);
            FXUtil.OffEnableVfx(u47);
        end;
    end);
    local u54 = {};
    local u55 = {};
    task.delay(0.333, function() -- Line: 357
        -- upvalues: u43 (copy), runGeneration (copy), SkillCommon (ref), skillInputData (copy), u48 (copy), FXUtil (ref), u45 (copy), nightmareCfFromKeyframes (ref), u44 (copy), VisibleMgr (ref), u54 (copy), skillRunData (copy), playShapeTween (ref), u49 (copy), RequiemConfig (ref), groundPivotAt (ref), u55 (copy)
        local v56 = u43;
        local v57 = v56:isRunningFlow() and v56.runGeneration == runGeneration;

        if not v57 then
            return;
        end;

        local v58 = SkillCommon.resolveStrikeWorldPos(skillInputData);

        if u48 then
            for i = 1, 3 do
                local v59 = FXUtil.GetInstance_From_Pool(u48);

                if v59 and v59:IsA("Model") then
                    v59:ScaleTo(u45);
                    local v60 = nightmareCfFromKeyframes(v58, i, 0.333, u44);
                    VisibleMgr.UnQueryAll(v59);
                    v59:PivotTo(v60);
                    v59.Parent = workspace.Debris;
                    FXUtil.SetEmittersTrailsBeamsEnabled(v59, true);
                    local v61 = v59:FindFirstChild("外形");
                    local v62 = v61 and v61:FindFirstChild("眼球闪光");

                    if v62 then
                        FXUtil.EmitBurstEmitInName(v62, true);
                    end;

                    local v63 = v59.PrimaryPart or v59:FindFirstChildWhichIsA("BasePart");
                    SkillCommon.playSoundLocal3D("音效-技能-暗夜亡魂-攻击", v63 and v63.Position or v59:GetPivot().Position);
                    u54[i] = v59;
                    SkillCommon.appendRunSpawnList(skillRunData, "requiemSpawns", v59);

                    if i == 1 then
                        playShapeTween(v59, skillRunData, "暗夜亡魂外形1");
                    elseif i == 2 then
                        playShapeTween(v59, skillRunData, "暗夜亡魂外形2");
                    else
                        playShapeTween(v59, skillRunData, "暗夜亡魂外形3");
                    end;
                end;
            end;
        end;

        if u49 then
            for i = 1, 3 do
                local v64 = FXUtil.GetInstance_From_Pool(u49);

                if v64 and v64:IsA("Model") then
                    v64:ScaleTo(u45);
                    local v65 = RequiemConfig.groundDeltaAtTime(i, 0.333);
                    local v66 = RequiemConfig.strikeOffsetWorld(v58, v65, u44);
                    local Position = SkillCommon.getGroundCF(CFrame.new(v66), 4, 1.5, "Ground").Position;
                    VisibleMgr.UnQueryAll(v64);
                    v64:PivotTo(groundPivotAt(Position, v64));
                    v64.Parent = workspace.Debris;
                    FXUtil.SetEmittersTrailsBeamsEnabled(v64, true);
                    FXUtil.Start_All_Emit(v64, 10);
                    u55[i] = v64;
                    SkillCommon.appendRunSpawnList(skillRunData, "requiemSpawns", v64);
                end;
            end;
        end;

        for i = 1, 3 do
            local v67 = u54[i];
            local v68 = u55[i];

            if v67 and v68 then
                FXUtil.WireAllBeamsBetweenAttachments(v67, v68, RequiemConfig.LaserBeamAttStart, RequiemConfig.LaserBeamAttEnd);
            end;
        end;
    end);
    local u69 = 0;
    local u70 = false;
    local u71 = nil;

    if skillRunData.runEvent["暗夜亡魂跟随"] then
        skillRunData.runEvent["暗夜亡魂跟随"]:Disconnect();
        skillRunData.runEvent["暗夜亡魂跟随"] = nil;
    end;

    skillRunData.runEvent["暗夜亡魂跟随"] = RunService.Heartbeat:Connect(function(p72) -- Line: 421
        -- upvalues: u43 (copy), runGeneration (copy), skillRunData (copy), SkillCommon (ref), u69 (ref), skillInputData (copy), RequiemConfig (ref), u71 (ref), u54 (copy), nightmareCfFromKeyframes (ref), u44 (copy), u55 (copy), groundPivotAt (ref), u70 (ref), FXUtil (ref), VisibleMgr (ref)
        if not u43:isRunningFlow() or u43.runGeneration ~= runGeneration then
            SkillCommon.disconnectRunEventKeys(skillRunData, { "暗夜亡魂跟随" });

            return;
        end;

        u69 = u69 + p72;

        if u69 < 0.333 then
            return;
        end;

        local v73 = SkillCommon.resolveStrikeWorldPos(skillInputData);
        local StrikeFollowSmoothLambda = RequiemConfig.StrikeFollowSmoothLambda;

        if StrikeFollowSmoothLambda > 0 then
            if u71 == nil then
                u71 = v73;
            else
                u71 = u71:Lerp(v73, 1 - math.exp(-StrikeFollowSmoothLambda * p72));
            end;
        else
            u71 = v73;
        end;

        local v74 = u71;

        for i = 1, 3 do
            local v75 = u54[i];

            if v75 and v75.Parent then
                v75:PivotTo(nightmareCfFromKeyframes(v74, i, u69, u44));
            end;

            local v76 = u55[i];

            if v76 and v76.Parent then
                local v77 = RequiemConfig.groundDeltaAtTime(i, u69);
                local v78 = RequiemConfig.strikeOffsetWorld(v74, v77, u44);
                v76:PivotTo(groundPivotAt(SkillCommon.getGroundCF(CFrame.new(v78), 4, 1.5, "Ground").Position, v76));
            end;
        end;

        if not u70 and u69 >= 2 then
            u70 = true;

            for i = 1, 3 do
                local v79 = u54[i];

                if v79 and v79.Parent then
                    local v80 = v79:FindFirstChild("外形");
                    local v81 = v80 and v80:FindFirstChild("眼球闪光");

                    if v81 then
                        FXUtil.EmitBurstEmitInName(v81, true);
                    end;

                    FXUtil.OffEnableVfx(v79);
                    local v82 = v79:FindFirstChild("外形");

                    if v82 and v82:IsA("Model") then
                        VisibleMgr.FadeCharacterModel(v82, 1, 0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    end;
                end;

                local v83 = u55[i];

                if v83 and v83.Parent then
                    FXUtil.Stop_All_Emit(v83);
                    FXUtil.SetEmittersTrailsBeamsEnabled(v83, false);
                end;
            end;
        end;
    end);
end;

function v1.Client_ExitChannel(p84) -- Line: 476
    -- upvalues: u3 (copy), SkillCommon (copy), returnRequiemSpawnListToPool (copy)
    local skillRunData = p84.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, u3);
    returnRequiemSpawnListToPool(skillRunData);
end;

function v1.Client_EnterRecovery(p85) -- Line: 480
    -- upvalues: SkillCommon (copy)
    local skillRunData = p85.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "暗系尾迹", "暗夜亡魂Cast尾迹");
    end;
end;

function v1.onEnd(p86) -- Line: 487
    -- upvalues: u4 (copy), SkillCommon (copy), returnRequiemSpawnListToPool (copy)
    local skillRunData = p86.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(skillRunData, u4);
    returnRequiemSpawnListToPool(skillRunData);
    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "暗系尾迹", "暗夜亡魂Cast尾迹");
end;

function v1.onClearRunData(p87, p88) -- Line: 491
    -- upvalues: u4 (copy), SkillCommon (copy), returnRequiemSpawnListToPool (copy)
    if not p88 then
        return;
    end;

    SkillCommon.disconnectRunEventKeys(p88, u4);
    returnRequiemSpawnListToPool(p88);
    SkillCommon.cleanupWandTipTrailFromMaterial(p88, "暗系尾迹", "暗夜亡魂Cast尾迹");
end;

function v1.Server_EnterChannel(u89) -- Line: 497
    -- upvalues: SkillCommon (copy), u2 (copy), RequiemConfig (copy), RunService (copy)
    local skillInputData = u89.skillInputData;

    if not skillInputData then
        return;
    end;

    local v90 = SkillCommon.scaleBandFromData(u89, u2);
    local u91 = RequiemConfig.HitboxSize * v90;
    SkillCommon.refreshSkillAimSnapshot(u89);
    local u92 = u89.hitbox[1];
    local u93 = u89.hitbox[2];
    local u94 = u89.hitbox[3];

    if not (u92 and (u93 and u94)) then
        return;
    end;

    if not (u92.hitbox and (u93.hitbox and u94.hitbox)) then
        return;
    end;

    local u95 = false;
    local u96 = 0;
    local u97 = nil;
    local v98 = nil;
    local v99;

    if skillInputData.character then
        v99 = skillInputData.character:FindFirstChild("HumanoidRootPart");

        if v99 then
            if not v99:IsA("BasePart") then
                v99 = v98;
            end;
        else
            v99 = v98;
        end;
    else
        v99 = v98;
    end;

    local u100 = RequiemConfig.flatHorizontalLookAtCast(v99, skillInputData.releaseCF);

    if u89.skillRunData.runEvent["暗夜亡魂命中盒"] then
        u89.skillRunData.runEvent["暗夜亡魂命中盒"]:Disconnect();
        u89.skillRunData.runEvent["暗夜亡魂命中盒"] = nil;
    end;

    u89.skillRunData.runEvent["暗夜亡魂命中盒"] = RunService.Heartbeat:Connect(function(p101) -- Line: 532
        -- upvalues: u89 (copy), u96 (ref), SkillCommon (ref), skillInputData (copy), RequiemConfig (ref), u97 (ref), u100 (copy), u91 (copy), u95 (ref), u92 (copy), u93 (copy), u94 (copy)
        if u89:isRunningFlow() then
            u96 = u96 + p101;

            if u96 >= 0.333 and u96 < 2 then
                local v102 = SkillCommon.resolveStrikeWorldPos(skillInputData);
                local StrikeFollowSmoothLambda = RequiemConfig.StrikeFollowSmoothLambda;

                if StrikeFollowSmoothLambda > 0 then
                    if u97 == nil then
                        u97 = v102;
                    else
                        u97 = u97:Lerp(v102, 1 - math.exp(-StrikeFollowSmoothLambda * p101));
                    end;
                else
                    u97 = v102;
                end;

                local v103 = u97;

                for i = 1, 3 do
                    local v104 = u89.hitbox[i];

                    if v104 then
                        v104 = v104.hitbox;
                    end;

                    if v104 then
                        local v105 = RequiemConfig.groundDeltaAtTime(i, u96);
                        local v106 = RequiemConfig.strikeOffsetWorld(v103, v105, u100);
                        local Position = SkillCommon.getGroundCF(CFrame.new(v106), 4, 1.5, "Ground").Position;
                        v104.Size = u91;
                        v104:PivotTo(CFrame.new(Position));
                    end;
                end;

                if not u95 then
                    u95 = true;
                    u92:start();
                    u93:start();
                    u94:start();

                    return;
                end;
            elseif u96 >= 2 then
                local v107 = u89.skillRunData.runEvent["暗夜亡魂命中盒"];

                if v107 then
                    v107:Disconnect();
                    u89.skillRunData.runEvent["暗夜亡魂命中盒"] = nil;
                end;

                for i = 1, 3 do
                    local v108 = u89.hitbox[i];

                    if v108 then
                        if v108.isActive then
                            v108:stop();
                        end;

                        v108:destroy();
                        u89.hitbox[i] = nil;
                    end;
                end;
            end;

            return;
        end;

        local v109 = u89.hitbox[1];

        if v109 and v109.isActive then
            v109:stop();
        end;

        local v110 = u89.hitbox[2];

        if v110 and v110.isActive then
            v110:stop();
        end;

        local v111 = u89.hitbox[3];

        if v111 and v111.isActive then
            v111:stop();
        end;

        local v112 = u89.skillRunData.runEvent["暗夜亡魂命中盒"];

        if v112 then
            v112:Disconnect();
            u89.skillRunData.runEvent["暗夜亡魂命中盒"] = nil;
        end;
    end);
end;

function v1.Server_ExitChannel(p113) -- Line: 599
    -- upvalues: SkillCommon (copy)
    local skillRunData = p113.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "暗夜亡魂命中盒" });
    end;

    local v114 = p113.hitbox[1];

    if v114 and v114.isActive then
        v114:stop();
    end;

    local v115 = p113.hitbox[2];

    if v115 and v115.isActive then
        v115:stop();
    end;

    local v116 = p113.hitbox[3];

    if v116 and v116.isActive then
        v116:stop();
    end;
end;

function v1.Server_EnterRecovery(p117) -- Line: 609
    p117:releaseControl();
end;

function v1.onEndServer(p118) -- Line: 613
    -- upvalues: SkillCommon (copy)
    local skillRunData = p118.skillRunData;

    if skillRunData then
        SkillCommon.disconnectRunEventKeys(skillRunData, { "暗夜亡魂命中盒" });
    end;

    local v119 = p118.hitbox[1];

    if v119 and v119.isActive then
        v119:stop();
    end;

    local v120 = p118.hitbox[2];

    if v120 and v120.isActive then
        v120:stop();
    end;

    local v121 = p118.hitbox[3];

    if v121 and v121.isActive then
        v121:stop();
    end;
end;

v1.SoundList = { "音效-技能-暗夜亡魂-法阵", "音效-技能-暗夜亡魂-攻击" };
v1.AnimateList = { "技能释放动作6" };
v1.ResNameList = { "暗系尾迹", "暗夜亡魂法阵", "暗夜亡魂法阵上空眼球", "暗夜亡魂魇梦模板", "暗夜亡魂地面模板" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "暗属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "暗属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    }, {
        HitboxIndex = 3,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "暗属性受击",
        PhysicsEffectName = "通用受击物理效果",
        CameraShakeProfile = "轻攻击震"
    } };
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
        overTime = 1.57,
        animationName = "技能释放动作6",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;