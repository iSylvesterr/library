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
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64
};
local u2 = CFrame.new(0, 1.4, -6.5);
local u3 = {
    fireballFly = "熔炉核心施法火球飞行",
    meshRotate = "熔炉核心MeshSphere自转",
    hitPulse = "熔炉核心命中盒"
};
local u4 = { 0.8, 0.95, 1.083, 1.233, 1.383, 1.517, 1.667 };

local function scheduleEnableThenRecycle(u5, u6, p7, p8) -- Line: 73
    -- upvalues: FXUtil (copy), VisibleMgr (copy)
    if not u6 then
        return;
    end;

    if p8 then
        p8();
    end;

    task.delay(p7, function() -- Line: 81
        -- upvalues: u5 (copy), u6 (copy), FXUtil (ref), VisibleMgr (ref)
        if not (u5() and u6.Parent) then
            return;
        end;

        FXUtil.OffEnableVfx(u6);
        FXUtil.SetEmittersTrailsBeamsEnabled(u6, false);
        task.delay(2, function() -- Line: 88
            -- upvalues: u5 (ref), u6 (ref), VisibleMgr (ref)
            if not (u5() and u6.Parent) then
                return;
            end;

            VisibleMgr.fadeAll(u6, 1);
            task.delay(0.15, function() -- Line: 93
                -- upvalues: u6 (ref)
                if u6.Parent then
                    u6:Destroy();
                end;
            end);
        end);
    end);
end;

local function scheduleEnableOffOnly(u9, u10, p11, p12) -- Line: 103
    -- upvalues: FXUtil (copy)
    if not u10 then
        return;
    end;

    if p12 then
        p12();
    end;

    task.delay(p11, function() -- Line: 110
        -- upvalues: u9 (copy), u10 (copy), FXUtil (ref)
        if not (u9() and u10.Parent) then
            return;
        end;

        FXUtil.OffEnableVfx(u10);
        FXUtil.SetEmittersTrailsBeamsEnabled(u10, false);
    end);
end;

local function cleanupRunFx(p13) -- Line: 119
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p13.skillRunData, { "熔炉核心施法火球飞行", "熔炉核心MeshSphere自转", "熔炉核心命中盒" });
end;

local function strikeHrpPos(p14) -- Line: 127
    -- upvalues: SkillCommon (copy)
    local v15 = SkillCommon.resolveTrackTargetHrp(p14);

    if v15 and v15.Parent then
        return v15.Position;
    end;

    return SkillCommon.resolveStrikeWorldPos(p14);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Recovery";
v1.States = {
    Startup = {
        Duration = 0.25,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Channel = {
        Duration = 4.5,
        OnEnterClient = "Client_EnterChannel",
        OnEnterServer = "Server_EnterChannel",
        OnExitClient = "Client_ExitChannel",
        OnExitServer = "Server_ExitChannel"
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

function v1.Client_EnterStartup(p16) -- Line: 174
    -- upvalues: SkillCommon (copy)
    local v17 = p16.skillInputData and p16.skillInputData.character;

    if not v17 then
        return;
    end;

    local v18 = SkillCommon.resolveWandTipFromCharacter(v17);

    if v18 then
        SkillCommon.scheduleWandTipElementTrail(p16, v18, {
            trailMaterialKey = "火系尾迹",
            runEventKey = "熔炉核心Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.6
        });
    end;
end;

function v1.Server_EnterStartup(p19) -- Line: 190
    -- upvalues: SkillCommon (copy)
    local v20 = 25 * SkillCommon.scaleBandFromData(p19, SkillCommon.bandScaleOptsFromSkillData(p19));
    local v21 = Vector3.new(v20, v20, v20);
    local v22 = p19.hitbox[1];

    if v22 and v22.hitbox then
        local hitbox = v22.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = v21;
    end;
end;

function v1.Client_EnterChannel(u23) -- Line: 204
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), u2 (copy), FXUtil (copy), RunService (copy)
    local skillInputData = u23.skillInputData;
    local u24;

    if skillInputData then
        u24 = skillInputData.character;
    else
        u24 = skillInputData;
    end;

    if u24 then
        u24 = u24:FindFirstChild("HumanoidRootPart");
    end;

    if not (skillInputData and u24) then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u23);
    local runGeneration = u23.runGeneration;
    local skillRunData = u23.skillRunData;
    local u25 = SkillCommon.scaleBandFromData(u23, SkillCommon.bandScaleOptsFromSkillData(u23));
    local material = skillRunData.material;
    local v26 = SkillCommon.resolveStruckTargetGroundWorldPos(skillInputData, 4, 0, "Ground");
    local u27 = v26 + Vector3.new(0, 0.6, 0);
    local u28 = v26 + Vector3.new(0, 2, 0);
    local Rotation = CFrame.lookAt(u28, u28 + u24.CFrame.LookVector, Vector3.new(0, 1, 0)).Rotation;

    local function still() -- Line: 224
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy)
        return SkillCommon.isRunningSameGeneration(u23, runGeneration);
    end;

    local function deploy(p29, p30, p31) -- Line: 229
        -- upvalues: u25 (copy), VisibleMgr (ref), SkillCommon (ref), skillRunData (copy)
        if not p29 then
            return;
        end;

        p29:ScaleTo(u25);
        VisibleMgr.UnQueryAll(p29);
        SkillCommon.pivotInstanceToWorldCF(p29, CFrame.new(p30) * (p31 or p29:GetPivot().Rotation));
        p29.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "FurnaceCoreSpawned", p29);
    end;

    local function resolveFormationCF() -- Line: 240
        -- upvalues: material (copy), u24 (copy), u2 (ref)
        local v32 = material["熔炉核心_法阵Emit"];

        if v32 and v32.Parent then
            return v32:GetPivot();
        end;

        return u24:GetPivot():ToWorldSpace(u2);
    end;

    task.delay(0.16666666666666666, function() -- Line: 249
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), u25 (copy), VisibleMgr (ref), u24 (copy), u2 (ref), FXUtil (ref), skillRunData (copy)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local v33 = material["熔炉核心_法阵Emit"];

        if not v33 then
            return;
        end;

        v33:ScaleTo(u25);
        VisibleMgr.UnQueryAll(v33);
        v33:PivotTo(u24:GetPivot():ToWorldSpace(u2));
        v33.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v33, true);
        SkillCommon.playSoundLocal3D("音效-技能-火法阵2", v33:GetPivot().Position);
        SkillCommon.appendRunSpawnList(skillRunData, "FurnaceCoreSpawned", v33);
    end);
    task.delay(0.25, function() -- Line: 267
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), u24 (copy), u2 (ref), deploy (copy), FXUtil (ref), skillRunData (copy), u28 (copy), still (copy), VisibleMgr (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local u34 = material["熔炉核心_施法火球"];

        if not u34 then
            return;
        end;

        local v35 = material["熔炉核心_法阵Emit"];
        local v36;

        if v35 and v35.Parent then
            v36 = v35:GetPivot();
        else
            v36 = u24:GetPivot():ToWorldSpace(u2);
        end;

        deploy(u34, v36.Position, v36.Rotation);
        FXUtil.SetEnableNameVfx(u34, true);
        FXUtil.SetEmittersTrailsBeamsEnabled(u34, true);
        FXUtil.Emit_Particles_GetDescendants(u34, false);
        SkillCommon.playSoundLocal3D("音效-技能-熔火核心-飞行熔火", u34:GetPivot().Position);
        SkillCommon.disconnectRunEventKeys(skillRunData, { "熔炉核心施法火球飞行" });
        skillRunData.runEvent["熔炉核心施法火球飞行"] = FXUtil.Pivot_Instance_CF_Lerp_Heartbeat(u34, 0.25, CFrame.new(u28) * u34:GetPivot().Rotation, Enum.EasingStyle.Quad, Enum.EasingDirection.In, still);
        task.delay(0.75, function() -- Line: 294
            -- upvalues: SkillCommon (ref), u23 (ref), runGeneration (ref), u34 (copy), FXUtil (ref), VisibleMgr (ref)
            if not (SkillCommon.isRunningSameGeneration(u23, runGeneration) and u34.Parent) then
                return;
            end;

            FXUtil.OffEnableVfx(u34);
            FXUtil.SetEmittersTrailsBeamsEnabled(u34, false);
            task.delay(2, function() -- Line: 300
                -- upvalues: u34 (ref), VisibleMgr (ref)
                if u34.Parent then
                    VisibleMgr.fadeAll(u34, 1);
                    task.delay(0.15, function() -- Line: 303
                        -- upvalues: u34 (ref)
                        if u34.Parent then
                            u34:Destroy();
                        end;
                    end);
                end;
            end);
        end);
    end);
    task.delay(0.5, function() -- Line: 314
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), deploy (copy), u27 (copy), FXUtil (ref), still (copy)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local v37 = material["熔炉核心_地面特效"];

        if not v37 then
            return;
        end;

        deploy(v37, u27);
        local Part_Emit = v37:FindFirstChild("Part_Emit", true);

        if Part_Emit then
            FXUtil.Emit_Particles_GetDescendants(Part_Emit, true);
        end;

        local Part_Cylinder_02_Enable = v37:FindFirstChild("Part_Cylinder_02_Enable", true);

        if Part_Cylinder_02_Enable then
            local u38 = still;

            local function v39() -- Line: 329
                -- upvalues: FXUtil (ref), Part_Cylinder_02_Enable (copy)
                FXUtil.Emit_Particles_GetDescendants(Part_Cylinder_02_Enable, false);
                FXUtil.SetEnableNameVfx(Part_Cylinder_02_Enable, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(Part_Cylinder_02_Enable, true);
            end;

            if not Part_Cylinder_02_Enable then
                return;
            end;

            if v39 then
                FXUtil.Emit_Particles_GetDescendants(Part_Cylinder_02_Enable, false);
                FXUtil.SetEnableNameVfx(Part_Cylinder_02_Enable, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(Part_Cylinder_02_Enable, true);
            end;

            task.delay(0.5, function() -- Line: 110
                -- upvalues: u38 (copy), Part_Cylinder_02_Enable (copy), FXUtil (ref)
                if not (u38() and Part_Cylinder_02_Enable.Parent) then
                    return;
                end;

                FXUtil.OffEnableVfx(Part_Cylinder_02_Enable);
                FXUtil.SetEmittersTrailsBeamsEnabled(Part_Cylinder_02_Enable, false);
            end);
        end;
    end);
    task.delay(0.533, function() -- Line: 338
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), still (copy), FXUtil (ref), deploy (copy), u28 (copy), Rotation (copy)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local u40 = material["熔炉核心_地面特效"];

        if u40 then
            u40 = u40:FindFirstChild("Part_Cylinder_01", true);
        end;

        if u40 then
            local u41 = still;

            local function v42() -- Line: 345
                -- upvalues: FXUtil (ref), u40 (copy)
                FXUtil.Emit_Particles_GetDescendants(u40, false);
                FXUtil.SetEnableNameVfx(u40, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(u40, true);
            end;

            if u40 then
                if v42 then
                    FXUtil.Emit_Particles_GetDescendants(u40, false);
                    FXUtil.SetEnableNameVfx(u40, true);
                    FXUtil.SetEmittersTrailsBeamsEnabled(u40, true);
                end;

                task.delay(0.5, function() -- Line: 110
                    -- upvalues: u41 (copy), u40 (copy), FXUtil (ref)
                    if not (u41() and u40.Parent) then
                        return;
                    end;

                    FXUtil.OffEnableVfx(u40);
                    FXUtil.SetEmittersTrailsBeamsEnabled(u40, false);
                end);
            end;
        end;

        local v43 = material["熔炉核心_03_EmitEnable"];

        if v43 then
            deploy(v43, u28, Rotation);
        end;
    end);
    task.delay(0.583, function() -- Line: 358
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local v44 = material["熔炉核心_地面特效"];

        if v44 then
            v44 = v44:FindFirstChild("Part_Cylinder_03", true);
        end;

        if v44 then
            FXUtil.Emit_Particles_GetDescendants(v44, false);
            FXUtil.SetEnableNameVfx(v44, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(v44, true);
        end;
    end);
    task.delay(1.05, function() -- Line: 371
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local v45 = material["熔炉核心_地面特效"];

        if v45 then
            v45 = v45:FindFirstChild("Part_Cylinder_03", true);
        end;

        if v45 then
            FXUtil.OffEnableVfx(v45);
            FXUtil.SetEmittersTrailsBeamsEnabled(v45, false);
        end;
    end);
    task.delay(0.833, function() -- Line: 384
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), deploy (copy), u28 (copy), Rotation (copy), still (copy), FXUtil (ref), VisibleMgr (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local u46 = material["熔炉核心_04_EmitEnable"];

        if not u46 then
            return;
        end;

        deploy(u46, u28, Rotation);
        local u47 = still;

        local function v48() -- Line: 393
            -- upvalues: FXUtil (ref), u46 (copy)
            FXUtil.Emit_Particles_GetDescendants(u46, false);
            FXUtil.SetEnableNameVfx(u46, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(u46, true);
        end;

        if not u46 then
            return;
        end;

        if v48 then
            FXUtil.Emit_Particles_GetDescendants(u46, false);
            FXUtil.SetEnableNameVfx(u46, true);
            FXUtil.SetEmittersTrailsBeamsEnabled(u46, true);
        end;

        task.delay(0.3, function() -- Line: 81
            -- upvalues: u47 (copy), u46 (copy), FXUtil (ref), VisibleMgr (ref)
            if not (u47() and u46.Parent) then
                return;
            end;

            FXUtil.OffEnableVfx(u46);
            FXUtil.SetEmittersTrailsBeamsEnabled(u46, false);
            task.delay(2, function() -- Line: 88
                -- upvalues: u47 (ref), u46 (ref), VisibleMgr (ref)
                if not (u47() and u46.Parent) then
                    return;
                end;

                VisibleMgr.fadeAll(u46, 1);
                task.delay(0.15, function() -- Line: 93
                    -- upvalues: u46 (ref)
                    if u46.Parent then
                        u46:Destroy();
                    end;
                end);
            end);
        end);
    end);
    task.delay(0.883, function() -- Line: 401
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), still (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local u49 = material["熔炉核心_03_EmitEnable"];

        if u49 then
            u49 = u49:FindFirstChild("Part_Cylinder_02", true);
        end;

        if u49 then
            local u50 = still;

            local function v51() -- Line: 408
                -- upvalues: FXUtil (ref), u49 (copy)
                FXUtil.Emit_Particles_GetDescendants(u49, false);
                FXUtil.SetEnableNameVfx(u49, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(u49, true);
            end;

            if not u49 then
                return;
            end;

            if v51 then
                FXUtil.Emit_Particles_GetDescendants(u49, false);
                FXUtil.SetEnableNameVfx(u49, true);
                FXUtil.SetEmittersTrailsBeamsEnabled(u49, true);
            end;

            task.delay(0.3, function() -- Line: 110
                -- upvalues: u50 (copy), u49 (copy), FXUtil (ref)
                if not (u50() and u49.Parent) then
                    return;
                end;

                FXUtil.OffEnableVfx(u49);
                FXUtil.SetEmittersTrailsBeamsEnabled(u49, false);
            end);
        end;
    end);
    task.delay(0.55, function() -- Line: 417
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), deploy (copy), u28 (copy), Rotation (copy), u25 (copy), FXUtil (ref), skillRunData (copy), RunService (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local u52 = material["熔炉核心_MeshShpere"];

        if not u52 then
            return;
        end;

        deploy(u52, u28, Rotation);
        u52:SetAttribute("ModelScale", u25);
        local u53 = 0.001 / u25;
        u52:SetAttribute("Scale", u53);
        FXUtil.Set_Scale_Model(u52, u53);
        local u54 = { { 0.867, 0.25 }, { 0.933, 0.1 }, { 1.017, 0.4 }, { 1.083, 0.3 }, { 1.15, 0.7 }, { 1.417, 1 }, { 1.583, 1 }, { 1.617, 1.15 }, { 1.65, 1 } };

        local function meshScaleMulAtAbsT(p55) -- Line: 443
            -- upvalues: u53 (copy), u54 (copy)
            local v56 = u53;
            local v57 = 0.8;

            for _, v in u54 do
                local v58 = v[1];
                local v59 = v[2];

                if p55 <= v58 then
                    local v60 = v58 - v57;

                    if v60 <= 0 then
                        return v59;
                    end;

                    return v56 + (v59 - v56) * ((p55 - v57) / v60);
                end;

                v56 = v59;
                v57 = v58;
            end;

            return v56;
        end;

        local Rotation2 = u52:GetPivot().Rotation;
        local Sphere_Dark = u52:FindFirstChild("Sphere_Dark", true);
        local u61;

        if Sphere_Dark then
            u61 = Sphere_Dark:FindFirstChild("MeshPart", true);
        else
            u61 = Sphere_Dark;
        end;

        SkillCommon.disconnectRunEventKeys(skillRunData, { "熔炉核心MeshSphere自转" });
        local u62 = 0;
        skillRunData.runEvent["熔炉核心MeshSphere自转"] = RunService.Heartbeat:Connect(function(p63) -- Line: 467
            -- upvalues: SkillCommon (ref), u23 (ref), runGeneration (ref), u52 (copy), u62 (ref), meshScaleMulAtAbsT (copy), FXUtil (ref), u28 (ref), Rotation2 (copy), u54 (copy), skillRunData (ref)
            if not (SkillCommon.isRunningSameGeneration(u23, runGeneration) and u52.Parent) then
                return;
            end;

            u62 = u62 + p63;
            local v64 = u62 + 0.8;
            local v65 = meshScaleMulAtAbsT(v64);
            FXUtil.Set_Scale_Model(u52, v65);
            local v66 = math.min(u62, 0.883) * 6.283185307179586;
            u52:PivotTo(CFrame.new(u28) * Rotation2 * CFrame.Angles(0, v66, 0));
            local v67 = u62 >= 0.883 and (u54[#u54][1] <= v64 and skillRunData.runEvent["熔炉核心MeshSphere自转"]);

            if v67 then
                v67:Disconnect();
                skillRunData.runEvent["熔炉核心MeshSphere自转"] = nil;
            end;
        end);

        if Sphere_Dark and Sphere_Dark:IsA("BasePart") then
            local u68 = Color3.fromRGB(186, 153, 68);
            local u69 = Color3.fromRGB(241, 198, 88);
            Sphere_Dark.Color = Color3.fromRGB(17, 17, 17);
            task.delay(0.517, function() -- Line: 491
                -- upvalues: SkillCommon (ref), u23 (ref), runGeneration (ref), Sphere_Dark (copy), FXUtil (ref), u68 (copy)
                if not (SkillCommon.isRunningSameGeneration(u23, runGeneration) and Sphere_Dark.Parent) then
                    return;
                end;

                FXUtil.Instance_Color_Tween(Sphere_Dark, 0.2, u68, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
            end);
            task.delay(0.717, function() -- Line: 498
                -- upvalues: SkillCommon (ref), u23 (ref), runGeneration (ref), Sphere_Dark (copy), FXUtil (ref), u69 (copy)
                if not (SkillCommon.isRunningSameGeneration(u23, runGeneration) and Sphere_Dark.Parent) then
                    return;
                end;

                FXUtil.Instance_Color_Tween(Sphere_Dark, 0.016, u69, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
            end);
        end;

        if u61 and u61:IsA("BasePart") then
            u61.Transparency = 1;
            task.delay(0.383, function() -- Line: 509
                -- upvalues: SkillCommon (ref), u23 (ref), runGeneration (ref), u61 (copy), FXUtil (ref)
                if SkillCommon.isRunningSameGeneration(u23, runGeneration) and u61.Parent then
                    FXUtil.Instance_Transparency_Tween(u61, 0.067, 0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
                end;
            end);
        end;

        task.delay(0.867, function() -- Line: 517
            -- upvalues: SkillCommon (ref), u23 (ref), runGeneration (ref), u52 (copy), FXUtil (ref)
            if SkillCommon.isRunningSameGeneration(u23, runGeneration) and u52.Parent then
                FXUtil.Instance_Transparency_Tween(u52, 0.033, 1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
            end;
        end);
        task.delay(2.383, function() -- Line: 523
            -- upvalues: SkillCommon (ref), skillRunData (ref), u52 (copy)
            SkillCommon.disconnectRunEventKeys(skillRunData, { "熔炉核心MeshSphere自转" });

            if u52.Parent then
                u52:Destroy();
            end;
        end);
    end);
    task.delay(1.117, function() -- Line: 532
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), deploy (copy), u28 (copy), Rotation (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local v70 = material["熔炉核心_Sphere_Emi"];

        if not v70 then
            return;
        end;

        deploy(v70, u28, Rotation);

        for _, descendant in v70:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Transparency = 1;
            end;
        end;

        if v70:IsA("BasePart") then
            v70.Transparency = 1;
        end;

        FXUtil.Instance_Transparency_Tween(v70, 0.1, 0, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    end);
    task.delay(1.417, function() -- Line: 552
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local v71 = material["熔炉核心_Sphere_Emi"];

        if v71 and v71.Parent then
            FXUtil.Instance_Transparency_Tween(v71, 0.033, 1, Enum.EasingStyle.Linear, Enum.EasingDirection.In);
        end;
    end);
    task.delay(2.917, function() -- Line: 562
        -- upvalues: material (copy)
        local v72 = material["熔炉核心_Sphere_Emi"];

        if v72 and v72.Parent then
            v72:Destroy();
        end;
    end);
    task.delay(1.383, function() -- Line: 570
        -- upvalues: SkillCommon (ref), u23 (copy), runGeneration (copy), material (copy), deploy (copy), u28 (copy), Rotation (copy), FXUtil (ref), still (copy)
        if not SkillCommon.isRunningSameGeneration(u23, runGeneration) then
            return;
        end;

        local v73 = material["熔炉核心_05_Emit"];

        if v73 then
            deploy(v73, u28, Rotation);
            SkillCommon.playSoundLocal3D("音效-技能-熔火核心-爆炸", u28);
            local Part_Sphere = v73:FindFirstChild("Part_Sphere", true);

            if Part_Sphere then
                FXUtil.Emit_Particles_GetDescendants(Part_Sphere, true);
            end;
        end;

        local v74 = material["熔炉核心_地面特效"];

        if v74 then
            local Part_Cylinder_Ground = v74:FindFirstChild("Part_Cylinder_Ground", true);

            if Part_Cylinder_Ground then
                FXUtil.Emit_Particles_GetDescendants(Part_Cylinder_Ground, true);
            end;

            local u75 = v74:FindFirstChild("Part_Cylinder_Emit和Enable", true);

            if u75 then
                local u76 = still;

                local function v77() -- Line: 591
                    -- upvalues: FXUtil (ref), u75 (copy)
                    FXUtil.Emit_Particles_GetDescendants(u75, false);
                    FXUtil.SetEnableNameVfx(u75, true);
                    FXUtil.SetEmittersTrailsBeamsEnabled(u75, true);
                end;

                if not u75 then
                    return;
                end;

                if v77 then
                    FXUtil.Emit_Particles_GetDescendants(u75, false);
                    FXUtil.SetEnableNameVfx(u75, true);
                    FXUtil.SetEmittersTrailsBeamsEnabled(u75, true);
                end;

                task.delay(1, function() -- Line: 110
                    -- upvalues: u76 (copy), u75 (copy), FXUtil (ref)
                    if not (u76() and u75.Parent) then
                        return;
                    end;

                    FXUtil.OffEnableVfx(u75);
                    FXUtil.SetEmittersTrailsBeamsEnabled(u75, false);
                end);
            end;
        end;
    end);
    SkillCommon.scheduleRunSpawnClear(u23, runGeneration, skillRunData, "FurnaceCoreSpawned", 6.5);
end;

function v1.Client_ExitChannel(p78) -- Line: 603
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p78.skillRunData, { u3.fireballFly, u3.meshRotate, u3.hitPulse });
    local skillRunData = p78.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p78, p78.runGeneration, skillRunData, "FurnaceCoreSpawned");
    end;
end;

function v1.Client_EnterRecovery(p79) -- Line: 611
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.cleanupWandTipTrailFromMaterial(p79.skillRunData, "火系尾迹", "熔炉核心Cast尾迹");
    SkillCommon.disconnectRunEventKeys(p79.skillRunData, { u3.fireballFly, u3.meshRotate, u3.hitPulse });
end;

function v1.onEnd(p80) -- Line: 616
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p80.skillRunData, { u3.fireballFly, u3.meshRotate, u3.hitPulse });
    SkillCommon.cleanupWandTipTrailFromMaterial(p80.skillRunData, "火系尾迹", "熔炉核心Cast尾迹");
end;

function v1.Server_EnterChannel(u81) -- Line: 621
    -- upvalues: SkillCommon (copy), strikeHrpPos (copy), u4 (copy), RunService (copy)
    local skillInputData = u81.skillInputData;

    if not skillInputData then
        return;
    end;

    local u82 = u81.hitbox[1];

    if not (u82 and u82.hitbox) then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u81);
    local v83 = 25 * SkillCommon.scaleBandFromData(u81, SkillCommon.bandScaleOptsFromSkillData(u81));
    u82.hitbox.Size = Vector3.new(v83, v83, v83);
    local runGeneration = u81.runGeneration;
    local u84 = CFrame.new(strikeHrpPos(skillInputData));
    local u85 = 0;
    local u86 = 0;
    local u87 = u4[#u4];
    SkillCommon.disconnectRunEventKeys(u81.skillRunData, { "熔炉核心命中盒" });
    u81.skillRunData.runEvent["熔炉核心命中盒"] = RunService.Heartbeat:Connect(function(p88) -- Line: 642
        -- upvalues: u81 (copy), runGeneration (copy), u86 (ref), u85 (ref), u4 (ref), u82 (copy), u84 (copy), u87 (copy)
        if not u81:isRunningFlow() or u81.runGeneration ~= runGeneration then
            return;
        end;

        u86 = u86 + p88;

        while u85 < #u4 and u86 >= u4[u85 + 1] - 0.25 do
            u85 = u85 + 1;
            u82.hitbox:PivotTo(u84);
            u82:start();
            task.delay(0.12, function() -- Line: 652
                -- upvalues: u82 (ref)
                if u82.isActive then
                    u82:stop();
                end;
            end);
        end;

        local v89 = u86 >= u87 - 0.25 + 0.15 and u81.skillRunData.runEvent["熔炉核心命中盒"];

        if v89 then
            v89:Disconnect();
            u81.skillRunData.runEvent["熔炉核心命中盒"] = nil;
        end;
    end);
end;

function v1.Server_ExitChannel(p90) -- Line: 668
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p90.skillRunData, { u3.fireballFly, u3.meshRotate, u3.hitPulse });
    local v91 = p90.hitbox[1];

    if v91 and v91.isActive then
        v91:stop();
    end;
end;

function v1.Server_EnterRecovery(p92) -- Line: 676
    p92:releaseControl();
end;

function v1.onEndServer(p93) -- Line: 680
    -- upvalues: SkillCommon (copy), u3 (copy)
    SkillCommon.disconnectRunEventKeys(p93.skillRunData, { u3.fireballFly, u3.meshRotate, u3.hitPulse });
    local v94 = p93.hitbox[1];

    if v94 and v94.isActive then
        v94:stop();
    end;
end;

v1.SoundList = { "音效-技能-火法阵2", "音效-技能-熔火核心-飞行熔火", "音效-技能-熔火核心-爆炸" };
v1.AnimateList = { "技能释放动作10" };
v1.ResNameList = { "火系尾迹", "熔炉核心_法阵Emit", "熔炉核心_施法火球", "熔炉核心_地面特效", "熔炉核心_03_EmitEnable", "熔炉核心_04_EmitEnable", "熔炉核心_05_Emit", "熔炉核心_MeshShpere", "熔炉核心_Sphere_Emi" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.25,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.57,
        animationName = "技能释放动作10",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;