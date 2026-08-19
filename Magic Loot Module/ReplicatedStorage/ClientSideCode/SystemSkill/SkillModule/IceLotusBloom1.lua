-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local VisibleMgr = UtilsSystem.VisibleMgr;
local Debris = game:GetService("Debris");
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Ice
};
local u2 = { "冰莲绽放_小冰莲花Emit和Enabled1", "冰莲绽放_小冰莲花Emit和Enabled2", "冰莲绽放_小冰莲花Emit和Enabled3" };

local function hitboxShortPulseOnce(p3, p4, p5, p6) -- Line: 64
    local u7 = p3.hitbox[p4];

    if not (u7 and u7.hitbox) then
        return;
    end;

    u7.hitbox.Size = Vector3.new(p6, p6, p6);
    u7.hitbox:PivotTo(CFrame.new(p5));
    u7:start();
    task.delay(0.12, function() -- Line: 72
        -- upvalues: u7 (copy)
        if u7.isActive then
            u7:stop();
        end;
    end);
end;

u1.InitialState = "Startup";
u1.ControlOpenState = "Main";
u1.States = {
    Startup = {
        Duration = 0.47,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 1.583,
        OnEnterClient = "Client_EnterMain",
        OnEnterServer = "Server_EnterMain",
        OnExitClient = "Client_ExitMain",
        OnExitServer = "Server_ExitMain"
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

function u1.Client_EnterStartup(p8) -- Line: 117
    -- upvalues: SkillCommon (copy)
    local skillInputData = p8.skillInputData;

    if skillInputData then
        skillInputData = skillInputData.character;
    end;

    if not skillInputData then
        return;
    end;

    local v9 = SkillCommon.resolveWandTipFromCharacter(skillInputData);

    if v9 then
        SkillCommon.scheduleWandTipElementTrail(p8, v9, {
            trailMaterialKey = "冰系尾迹",
            runEventKey = "冰莲Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.8
        });
    end;
end;

function u1.Client_EnterMain(u10) -- Line: 136
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), u2 (copy), RunService (copy), Debris (copy)
    local skillInputData = u10.skillInputData;
    local v11;

    if skillInputData then
        v11 = skillInputData.character;
    else
        v11 = skillInputData;
    end;

    if not v11 then
        return;
    end;

    local runGeneration = u10.runGeneration;
    local skillRunData = u10.skillRunData;

    if not (skillInputData and (skillRunData and skillRunData.material)) then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u10);
    local u12 = SkillCommon.scaleBandFromData(u10, SkillCommon.bandScaleOptsFromSkillData(u10));
    local v13 = SkillCommon.resolveStrikeGroundWorldPos(skillInputData, 4, 0.5, "Ground");
    local HumanoidRootPart = v11:FindFirstChild("HumanoidRootPart");
    local u14;

    if HumanoidRootPart then
        u14 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.5, "Ground") + Vector3.new(0, 0.5, 0) or v13;
    else
        u14 = v13;
    end;

    local u15 = v13 + Vector3.new(0, 8 * u12, 0);
    local u16 = 26.567 * u12;
    local u17, u18, u19 = SkillCommon.horizontalRingThreeWaypoints(u15.X, u15.Y, u15.Z, u16);
    local u20 = { math.atan2(u17.Z - u15.Z, u17.X - u15.X), math.atan2(u18.Z - u15.Z, u18.X - u15.X), (math.atan2(u19.Z - u15.Z, u19.X - u15.X)) };
    task.delay(0, function() -- Line: 164
        -- upvalues: SkillCommon (ref), u10 (copy), runGeneration (copy), skillRunData (copy), u12 (copy), VisibleMgr (ref), u14 (copy), FXUtil (ref), u2 (ref), u15 (copy), u17 (copy), u18 (copy), u19 (copy), u16 (copy), u20 (copy), RunService (ref)
        if not SkillCommon.isRunningSameGeneration(u10, runGeneration) then
            return;
        end;

        if not skillRunData.ilbConn then
            skillRunData.ilbConn = {};
        end;

        local v21 = skillRunData.material["冰莲绽放法阵"];

        if v21 then
            v21:ScaleTo(u12);
            VisibleMgr.UnQueryAll(v21);
            v21:PivotTo(CFrame.new(u14) * v21:GetPivot().Rotation);
            v21.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "IceLotusSpawned", v21);
            local v22 = v21:FindFirstChild("Emit_法阵", true);

            if v22 then
                FXUtil.EmitBurstEmitInName(v22, true);
            end;

            SkillCommon.playSoundLocal3D("音效-技能-冰系法阵", v21:GetPivot().Position);
        end;

        local u23 = skillRunData.material["冰莲绽放_冰莲花Emit和Enabled"];

        if not (u23 and (skillRunData.material[u2[1]] and (skillRunData.material[u2[2]] and skillRunData.material[u2[3]]))) then
            return;
        end;

        local function scaleLotusOvershoot(u24) -- Line: 199
            -- upvalues: FXUtil (ref), u12 (ref)
            FXUtil.Model_Scale_Tween(u24, 0.1 * u12, 1.2 * u12, 0.041666666666666664, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 207
                -- upvalues: FXUtil (ref), u24 (copy), u12 (ref)
                FXUtil.Model_Scale_Tween(u24, 1.2 * u12, 1 * u12, 0.041666666666666664, Enum.EasingStyle.Quad, Enum.EasingDirection.In, nil, true);
            end, true);
        end;

        u23:ScaleTo(u12);
        VisibleMgr.UnQueryAll(u23);
        local Rotation = u23:GetPivot().Rotation;
        u23:PivotTo(CFrame.new(u15) * Rotation);
        u23.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "IceLotusSpawned", u23);
        skillRunData.ilbMain = u23;
        FXUtil.Model_Scale_Tween(u23, 0.1 * u12, 1.2 * u12, 0.041666666666666664, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 207
            -- upvalues: FXUtil (ref), u23 (copy), u12 (ref)
            FXUtil.Model_Scale_Tween(u23, 1.2 * u12, 1 * u12, 0.041666666666666664, Enum.EasingStyle.Quad, Enum.EasingDirection.In, nil, true);
        end, true);
        SkillCommon.playSoundLocal3D("音效-技能-冰莲绽放-三朵冰莲结冰", u15);
        local v25 = skillRunData.material["冰莲绽放_冰莲花出现"];

        if v25 then
            v25:ScaleTo(u12);
            VisibleMgr.UnQueryAll(v25);
            v25:PivotTo(CFrame.new(u15));
            v25.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "IceLotusSpawned", v25);
            FXUtil.Emit_Particles_GetDescendants(v25, true);
        end;

        local v26 = skillRunData.material["冰莲绽放_小冰莲花出现"];
        local u27 = table.create(3);
        local v28 = nil;

        for i = 1, 3 do
            local v29 = ({ u17, u18, u19 })[i];
            local u30 = skillRunData.material[u2[i]];
            u30:ScaleTo(u12);
            VisibleMgr.UnQueryAll(u30);
            local Rotation2 = u30:GetPivot().Rotation;
            u30:PivotTo(CFrame.new(v29) * Rotation2);
            u30.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "IceLotusSpawned", u30);
            u27[i] = u30;
            FXUtil.Model_Scale_Tween(u30, 0.1 * u12, 1.2 * u12, 0.041666666666666664, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function() -- Line: 207
                -- upvalues: FXUtil (ref), u30 (copy), u12 (ref)
                FXUtil.Model_Scale_Tween(u30, 1.2 * u12, 1 * u12, 0.041666666666666664, Enum.EasingStyle.Quad, Enum.EasingDirection.In, nil, true);
            end, true);

            if v26 then
                local v31;

                if v28 == nil then
                    v31 = v26;
                    v28 = v31;
                    local v32 = v31;
                    v31 = v28;
                    v32 = v28;
                else
                    v31 = v28:Clone();
                end;

                v31:ScaleTo(u12);
                VisibleMgr.UnQueryAll(v31);
                v31:PivotTo(CFrame.new(v29));
                v31.Parent = workspace.Debris;
                SkillCommon.appendRunSpawnList(skillRunData, "IceLotusSpawned", v31);
                FXUtil.Emit_Particles_GetDescendants(v31, true);
            end;
        end;

        skillRunData.ilbSmalls = u27;
        skillRunData.ilbPMain = u15;
        local v33 = {};
        local v34 = u27[1] and u27[1]:GetPivot().Rotation;
        local v35 = u27[2] and u27[2]:GetPivot().Rotation;
        local v36 = u27[3] and u27[3]:GetPivot().Rotation;
        v33[1], v33[2], v33[3] = v34, v35, v36;
        skillRunData.ilbSmR0 = v33;
        skillRunData.ilbR = u16;
        skillRunData.ilbA0 = u20;
        task.delay(0.083, function() -- Line: 282
            -- upvalues: SkillCommon (ref), u10 (ref), runGeneration (ref), u23 (copy), FXUtil (ref), u27 (copy), RunService (ref), u15 (ref), Rotation (copy), skillRunData (ref), u20 (ref), u16 (ref)
            if not SkillCommon.isRunningSameGeneration(u10, runGeneration) then
                return;
            end;

            if u23.Parent then
                FXUtil.EmitBurstEmitInName(u23, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(u23, true);
            end;

            for i = 1, 3 do
                local v37 = u27[i];

                if v37 and v37.Parent then
                    FXUtil.EmitBurstEmitInName(v37, true);
                    FXUtil.SetEmittersTrailsBeamsEnabled(v37, true);
                end;
            end;

            local u38 = 0;
            local u39 = nil;
            u39 = RunService.Heartbeat:Connect(function(p40) -- Line: 300
                -- upvalues: SkillCommon (ref), u10 (ref), runGeneration (ref), u23 (ref), u39 (ref), u38 (ref), u15 (ref), Rotation (ref)
                if not (SkillCommon.isRunningSameGeneration(u10, runGeneration) and u23.Parent) then
                    if u39 then
                        u39:Disconnect();
                    end;

                    return;
                end;

                u38 = u38 + p40;
                local v41 = math.clamp(u38 / 1.5, 0, 1);
                u23:PivotTo(CFrame.new(u15) * CFrame.Angles(0, math.rad(v41 * -180), 0) * Rotation);

                if v41 >= 1 and u39 then
                    u39:Disconnect();
                end;
            end);
            local v42 = skillRunData;
            v42.ilbConn.mainR = u39;
            local u43 = 0;
            local u44 = nil;
            u44 = RunService.Heartbeat:Connect(function(p45) -- Line: 319
                -- upvalues: SkillCommon (ref), u10 (ref), runGeneration (ref), u44 (ref), u43 (ref), u27 (ref), u20 (ref), skillRunData (ref), u15 (ref), u16 (ref)
                if not SkillCommon.isRunningSameGeneration(u10, runGeneration) then
                    if u44 then
                        u44:Disconnect();
                    end;

                    return;
                end;

                u43 = u43 + p45;
                local v46 = math.clamp(u43 / 0.667, 0, 1);

                for i = 1, 3 do
                    local v47 = u27[i];
                    local v48 = u20[i];
                    local v49 = skillRunData.ilbSmR0 and skillRunData.ilbSmR0[i] or CFrame.new().Rotation;

                    if v47 and v47.Parent then
                        local v50 = SkillCommon.horizontalOrbitCWSweepFromAngle(u15, u16, v48, v46, 0);
                        v47:PivotTo(CFrame.new(v50) * CFrame.Angles(0, math.rad(v46 * 90), 0) * v49);
                    end;
                end;

                if v46 >= 1 and u44 then
                    u44:Disconnect();
                end;
            end);
            v42.ilbConn.smM = u44;
        end);
    end);
    task.delay(0.75, function() -- Line: 353
        -- upvalues: SkillCommon (ref), u10 (copy), runGeneration (copy), skillRunData (copy), FXUtil (ref), u12 (copy), VisibleMgr (ref), Debris (ref)
        if not SkillCommon.isRunningSameGeneration(u10, runGeneration) then
            return;
        end;

        local v51 = skillRunData.ilbConn and skillRunData.ilbConn.smM;

        if v51 then
            v51:Disconnect();
            skillRunData.ilbConn.smM = nil;
        end;

        local v52 = skillRunData.material["冰莲绽放_小冰莲花消失"];
        local v53 = v52 and { v52, v52:Clone(), v52:Clone() } or nil;

        for i = 1, 3 do
            local v54 = skillRunData.ilbSmalls and skillRunData.ilbSmalls[i];

            if v54 and v54.Parent then
                FXUtil.OffEnableVfx(v54);
                FXUtil.SetEmittersTrailsBeamsEnabled(v54, false);
                FXUtil.HideModelBasePartsStopEmit(v54);
                local v55;

                if v53 then
                    v55 = v53[i];
                else
                    v55 = v53;
                end;

                if v55 then
                    v55:ScaleTo(u12);
                    VisibleMgr.UnQueryAll(v55);
                    v55:PivotTo(CFrame.new(v54:GetPivot().Position));
                    v55.Parent = workspace.Debris;
                    SkillCommon.appendRunSpawnList(skillRunData, "IceLotusSpawned", v55);
                    FXUtil.Emit_Particles_GetDescendants(v55, true);
                    SkillCommon.playSoundLocal3D("音效-技能-冰莲绽放-第一次破冰", v54:GetPivot().Position);
                end;

                Debris:AddItem(v54, 2);
            end;
        end;

        skillRunData.ilbSmalls = nil;
    end);
    task.delay(1.583, function() -- Line: 394
        -- upvalues: SkillCommon (ref), u10 (copy), runGeneration (copy), skillRunData (copy), FXUtil (ref), u12 (copy), VisibleMgr (ref), Debris (ref)
        if not SkillCommon.isRunningSameGeneration(u10, runGeneration) then
            return;
        end;

        local v56 = skillRunData.ilbConn and skillRunData.ilbConn.mainR;

        if v56 then
            v56:Disconnect();
            skillRunData.ilbConn.mainR = nil;
        end;

        local ilbMain = skillRunData.ilbMain;
        local v57 = skillRunData.material["冰莲绽放_冰莲花消失"];

        if ilbMain and ilbMain.Parent then
            FXUtil.OffEnableVfx(ilbMain);
            FXUtil.SetEmittersTrailsBeamsEnabled(ilbMain, false);

            if v57 then
                v57:ScaleTo(u12);
                VisibleMgr.UnQueryAll(v57);
                v57:PivotTo(CFrame.new(ilbMain:GetPivot().Position));
                v57.Parent = workspace.Debris;
                SkillCommon.appendRunSpawnList(skillRunData, "IceLotusSpawned", v57);
                FXUtil.Emit_Particles_GetDescendants(v57, true);
                SkillCommon.playSoundLocal3D("音效-技能-冰莲绽放-第二次破冰", ilbMain:GetPivot().Position);
            end;

            FXUtil.HideModelBasePartsStopEmit(ilbMain);
            Debris:AddItem(ilbMain, 2);
        end;

        skillRunData.ilbMain = nil;
    end);
    SkillCommon.scheduleRunSpawnClear(u10, runGeneration, skillRunData, "IceLotusSpawned", 3.583);
end;

function u1.Client_ExitMain(p58) -- Line: 429
    -- upvalues: SkillCommon (copy)
    local skillRunData = p58.skillRunData;

    if not skillRunData then
        return;
    end;

    if skillRunData.ilbConn then
        for i, v in pairs(skillRunData.ilbConn) do
            if v then
                v:Disconnect();
            end;

            skillRunData.ilbConn[i] = nil;
        end;
    end;

    SkillCommon.clearSpawnIfTerminalAfterExit(p58, p58.runGeneration, skillRunData, "IceLotusSpawned");
end;

function u1.Client_EnterRecovery(p59) -- Line: 445
    -- upvalues: SkillCommon (copy)
    local skillRunData = p59.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "冰系尾迹", "冰莲Cast尾迹");
    end;
end;

function u1.onEnd(p60) -- Line: 452
    -- upvalues: SkillCommon (copy)
    local skillRunData = p60.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "冰系尾迹", "冰莲Cast尾迹");

    if skillRunData.ilbConn then
        for i, v in pairs(skillRunData.ilbConn) do
            if v then
                v:Disconnect();
            end;

            skillRunData.ilbConn[i] = nil;
        end;
    end;

    skillRunData.ilbMain = nil;
    skillRunData.ilbSmalls = nil;
end;

function u1.Server_EnterStartup(p61) -- Line: 471
end;

function u1.Server_EnterMain(u62) -- Line: 473
    -- upvalues: SkillCommon (copy), RunService (copy), hitboxShortPulseOnce (copy)
    local skillInputData = u62.skillInputData;

    if not skillInputData then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u62);
    local runGeneration = u62.runGeneration;
    local v63 = SkillCommon.scaleBandFromData(u62, SkillCommon.bandScaleOptsFromSkillData(u62));
    local v64 = 32 * v63;
    local v65 = 64 * v63;
    local u66 = 19 * v63;

    for i = 1, 8 do
        local v67 = u62.hitbox[i];

        if v67 and v67.hitbox then
            local v68;

            if i == 8 then
                v68 = v65;
            elseif i == 1 then
                v68 = v64;
            else
                v68 = u66;
            end;

            v67.hitbox.Size = Vector3.new(v68, v68, v68);
        end;
    end;

    local u69 = SkillCommon.resolveStrikeGroundWorldPos(skillInputData, 4, 0.5, "Ground") + Vector3.new(0, 8 * v63, 0);
    local u70 = 26.567 * v63;
    local u71, u72, u73 = SkillCommon.horizontalRingThreeWaypoints(u69.X, u69.Y, u69.Z, u70);
    local u74 = { math.atan2(u71.Z - u69.Z, u71.X - u69.X), math.atan2(u72.Z - u69.Z, u72.X - u69.X), (math.atan2(u73.Z - u69.Z, u73.X - u69.X)) };
    local skillRunData = u62.skillRunData;

    if skillRunData then
        skillRunData.ilbPLotus = u69;
        skillRunData.ilbDMainBurst = v65;
        skillRunData.ilbFollowConn = nil;
    end;

    local u75 = nil;
    task.delay(0, function() -- Line: 510
        -- upvalues: u62 (copy), runGeneration (copy), u71 (copy), u72 (copy), u73 (copy), u69 (copy), u75 (ref), RunService (ref), SkillCommon (ref), u70 (copy), u74 (copy), skillRunData (copy)
        if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
            return;
        end;

        local u76 = u62.hitbox[1];
        local v77 = u62.hitbox[2];
        local v78 = u62.hitbox[3];
        local v79 = u62.hitbox[4];

        if not (u76 and (v77 and (v78 and v79))) then
            return;
        end;

        local u80 = { u71, u72, u73 };
        u76.hitbox:PivotTo(CFrame.new(u69));
        u76:start();
        local u81 = { v77, v78, v79 };

        for i = 1, 3 do
            u81[i].hitbox:PivotTo(CFrame.new(u80[i]));
            u81[i]:start();
        end;

        local u82 = 0.47;
        u75 = RunService.Heartbeat:Connect(function(p83) -- Line: 530
            -- upvalues: u62 (ref), runGeneration (ref), u76 (copy), u82 (ref), u69 (ref), u81 (copy), u80 (copy), SkillCommon (ref), u70 (ref), u74 (ref)
            if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
                return;
            end;

            if not (u76 and u76.isActive) then
                return;
            end;

            u82 = u82 + p83;
            u76.hitbox:PivotTo(CFrame.new(u69));

            if u82 < 0.553 then
                for i = 1, 3 do
                    if u81[i].isActive then
                        u81[i].hitbox:PivotTo(CFrame.new(u80[i]));
                    end;
                end;

                return;
            end;

            if u82 < 1.22 then
                local v84 = math.clamp((u82 - 0.553) / 0.667, 0, 1);

                for i = 1, 3 do
                    if u81[i].isActive then
                        local v85 = SkillCommon.horizontalOrbitCWSweepFromAngle(u69, u70, u74[i], v84, 0);
                        u81[i].hitbox:PivotTo(CFrame.new(v85));
                    end;
                end;
            end;
        end);

        if skillRunData then
            skillRunData.ilbFollowConn = u75;
        end;

        u62:BindRunConn(u75);
    end);
    task.delay(0.75, function() -- Line: 562
        -- upvalues: u62 (copy), runGeneration (copy), u75 (ref), skillRunData (copy), SkillCommon (ref), u69 (copy), u70 (copy), u74 (copy), hitboxShortPulseOnce (ref), u66 (copy), RunService (ref)
        if not u62:isRunningFlow() or u62.runGeneration ~= runGeneration then
            return;
        end;

        if u75 then
            u75:Disconnect();
            u75 = nil;
        end;

        if skillRunData then
            skillRunData.ilbFollowConn = nil;
        end;

        local v86 = u62.hitbox[2];

        if v86 and v86.isActive then
            v86:stop();
        end;

        local v87 = u62.hitbox[3];

        if v87 and v87.isActive then
            v87:stop();
        end;

        local v88 = u62.hitbox[4];

        if v88 and v88.isActive then
            v88:stop();
        end;

        for i = 1, 3 do
            local v89 = SkillCommon.horizontalOrbitCWSweepFromAngle(u69, u70, u74[i], 1, 0);
            hitboxShortPulseOnce(u62, i + 4, v89, u66);
        end;

        local u90 = u62.hitbox[1];
        u75 = RunService.Heartbeat:Connect(function(p91) -- Line: 585
            -- upvalues: u62 (ref), runGeneration (ref), u90 (copy), u69 (ref)
            if not u62:isRunningFlow() or (u62.runGeneration ~= runGeneration or not (u90 and u90.isActive)) then
                return;
            end;

            u90.hitbox:PivotTo(CFrame.new(u69));
        end);

        if skillRunData then
            skillRunData.ilbFollowConn = u75;
        end;

        u62:BindRunConn(u75);
    end);
end;

function u1.Server_ExitMain(p92) -- Line: 599
    -- upvalues: u1 (copy), hitboxShortPulseOnce (copy)
    local skillRunData = p92.skillRunData;

    if skillRunData and skillRunData.ilbFollowConn then
        skillRunData.ilbFollowConn:Disconnect();
        skillRunData.ilbFollowConn = nil;
    end;

    for i = 1, 7 do
        local v93 = p92.hitbox[i];

        if v93 and v93.isActive then
            v93:stop();
        end;
    end;

    local v94 = skillRunData and skillRunData.State and skillRunData.State.enteredAt;

    if skillRunData and (skillRunData.ilbPLotus and (skillRunData.ilbDMainBurst and (v94 and p92.nowTime - v94 >= u1.States.Main.Duration - 0.05))) then
        hitboxShortPulseOnce(p92, 8, skillRunData.ilbPLotus, skillRunData.ilbDMainBurst);
    end;
end;

function u1.Server_EnterRecovery(p95) -- Line: 625
    p95:releaseControl();
end;

function u1.onEndServer(p96) -- Line: 629
    local skillRunData = p96.skillRunData;

    if skillRunData and skillRunData.ilbFollowConn then
        skillRunData.ilbFollowConn:Disconnect();
        skillRunData.ilbFollowConn = nil;
    end;

    for i = 1, 8 do
        local v97 = p96.hitbox[i];

        if v97 and v97.isActive then
            v97:stop();
        end;
    end;
end;

u1.SoundList = { "音效-技能-冰系法阵", "音效-技能-冰莲绽放-三朵冰莲结冰", "音效-技能-冰莲绽放-第一次破冰", "音效-技能-冰莲绽放-第二次破冰" };
u1.AnimateList = { "技能释放动作9" };
u1.ResNameList = { "冰系尾迹", "冰莲绽放法阵", "冰莲绽放_冰莲花Emit和Enabled", "冰莲绽放_冰莲花出现", "冰莲绽放_冰莲花消失", "冰莲绽放_小冰莲花Emit和Enabled1", "冰莲绽放_小冰莲花Emit和Enabled2", "冰莲绽放_小冰莲花Emit和Enabled3", "冰莲绽放_小冰莲花出现", "冰莲绽放_小冰莲花消失" };
u1.hitboxConfig = {};

for i = 1, 8 do
    u1.hitboxConfig[i] = {
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "冰属性受击",
        HitboxIndex = i
    };
end;

u1.hitboxConfig[8].CameraShakeProfile = "中等碰撞震";
u1.hitboxConfig[8].PhysicsEffectName = "中等力度受击物理效果";
u1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.47,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.57,
        animationName = "技能释放动作9",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;