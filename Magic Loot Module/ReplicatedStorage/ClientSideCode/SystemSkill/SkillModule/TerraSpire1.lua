-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local TweenService = game:GetService("TweenService");
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 3,
    skillElementType = ElementTp.Earth,
    skillDistanceLimit = 64
};

local function disableEnabledThenRecycle(u2, u3, u4, p5, p6) -- Line: 52
    -- upvalues: FXUtil (copy)
    if not u4 then
        return;
    end;

    local u7 = p6 or 3;
    task.delay(p5, function() -- Line: 63
        -- upvalues: u2 (copy), u3 (copy), u4 (copy), FXUtil (ref), u7 (copy)
        if u2.runGeneration ~= u3 or not u4.Parent then
            return;
        end;

        FXUtil.SetEmittersTrailsBeamsEnabled(u4, false);
        task.delay(u7, function() -- Line: 68
            -- upvalues: u2 (ref), u3 (ref), u4 (ref)
            if u2.runGeneration ~= u3 then
                return;
            end;

            if u4.Parent then
                u4:Destroy();
            end;
        end);
    end);
end;

local function groundAnchorPos(p8) -- Line: 80
    -- upvalues: SkillCommon (copy)
    return SkillCommon.getGroundCF(CFrame.new(p8)).Position;
end;

local function pivotModelAtPos(p9, p10) -- Line: 84
    local Rotation = p9:GetPivot().Rotation;
    p9:PivotTo(CFrame.new(p10) * Rotation);
end;

local function pivotPartAtPos(p11, p12) -- Line: 89
    local Rotation = p11.CFrame.Rotation;
    p11:PivotTo(CFrame.new(p12) * Rotation);
end;

local function cleanupSpikePhaseRunEvents(p13) -- Line: 94
    local v14 = p13.skillRunData and p13.skillRunData.runEvent;

    if not v14 then
        return;
    end;

    if v14["大地突起尖刺升起动画"] then
        v14["大地突起尖刺升起动画"]:Disconnect();
        v14["大地突起尖刺升起动画"] = nil;
    end;

    if v14["大地突起突刺命中盒跟随"] then
        v14["大地突起突刺命中盒跟随"]:Disconnect();
        v14["大地突起突刺命中盒跟随"] = nil;
    end;
end;

local function cleanupBlastRunEvent(p15) -- Line: 109
    local v16 = p15.skillRunData and p15.skillRunData.runEvent;

    if not v16 then
        return;
    end;

    if v16["大地突起爆炸命中盒窗口"] then
        v16["大地突起爆炸命中盒窗口"]:Disconnect();
        v16["大地突起爆炸命中盒窗口"] = nil;
    end;
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "SpikeAscend";
v1.States = {
    Startup = {
        Duration = 0.34,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    SpikeAscend = {
        Duration = 0.25,
        OnEnterClient = "Client_EnterSpikeAscend",
        OnEnterServer = "Server_EnterSpikeAscend",
        OnExitClient = "Client_ExitSpikeAscend",
        OnExitServer = "Server_ExitSpikeAscend"
    },
    WaitBlast = {
        Duration = 0.2,
        OnEnterClient = "Client_EnterWaitBlast",
        OnEnterServer = "Server_EnterWaitBlast",
        OnExitClient = "Client_ExitWaitBlast",
        OnExitServer = nil
    },
    Blast = {
        Duration = 0.22,
        OnEnterClient = "Client_EnterBlast",
        OnEnterServer = "Server_EnterBlast",
        OnExitClient = "Client_ExitBlast",
        OnExitServer = "Server_ExitBlast"
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
        To = "SpikeAscend",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "SpikeAscend",
        To = "WaitBlast",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "WaitBlast",
        To = "Blast",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "Blast",
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
        From = "SpikeAscend",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "WaitBlast",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Blast",
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
        From = "SpikeAscend",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "WaitBlast",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Blast",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

function v1.Client_EnterStartup(p17) -- Line: 183
    -- upvalues: SkillCommon (copy)
    local character = p17.skillInputData.character;

    if not character then
        return;
    end;

    local v18 = SkillCommon.resolveWandTipFromCharacter(character);

    if v18 then
        SkillCommon.scheduleWandTipElementTrail(p17, v18, {
            trailMaterialKey = "土系尾迹",
            runEventKey = "大地突起Cast尾迹",
            enableAt = 0.47,
            disableAt = 0.85
        });
    end;
end;

function v1.Server_EnterStartup(p19) -- Line: 199
    -- upvalues: SkillCommon (copy)
    local v20 = Vector3.new(40, 40, 40) * SkillCommon.scaleBandFromData(p19, SkillCommon.bandScaleOptsFromSkillData(p19));
    local v21 = p19.hitbox[1];

    if v21 and v21.hitbox then
        v21.hitbox.Size = v20;
    end;

    local v22 = p19.hitbox[2];

    if v22 and v22.hitbox then
        v22.hitbox.Size = v20;
    end;
end;

function v1.Client_EnterSpikeAscend(u23) -- Line: 212
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), RunService (copy), TweenService (copy)
    local character = u23.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u23);
    local skillRunData = u23.skillRunData;
    local runGeneration = u23.runGeneration;
    local v24 = SkillCommon.scaleBandFromData(u23, SkillCommon.bandScaleOptsFromSkillData(u23));
    local v25 = SkillCommon.resolveStrikeWorldPos(u23.skillInputData);
    local Position = SkillCommon.getGroundCF(CFrame.new(HumanoidRootPart.Position)).Position;
    local Position2 = SkillCommon.getGroundCF(CFrame.new(v25)).Position;

    local function still() -- Line: 232
        -- upvalues: u23 (copy), runGeneration (copy)
        local v26 = u23:isRunningFlow();

        if v26 then
            if u23.runGeneration == runGeneration then
                v26 = not u23:isTerminal();
            else
                v26 = false;
            end;
        end;

        return v26;
    end;

    local u27 = skillRunData.material["大地突起法阵"];

    if u27 then
        u27:ScaleTo(v24);
        VisibleMgr.UnQueryAll(u27);
        local Rotation = u27:GetPivot().Rotation;
        u27:PivotTo(CFrame.new(Position) * Rotation);
        u27.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(u27, true);
        SkillCommon.appendRunSpawnList(skillRunData, "TerraSpireSpawned", u27);
        SkillCommon.playSoundLocal3D("音效-技能-地法阵", u27:GetPivot().Position);

        if u27 then
            local u28 = 3;
            task.delay(0.25, function() -- Line: 63
                -- upvalues: u23 (copy), runGeneration (copy), u27 (copy), FXUtil (ref), u28 (copy)
                if u23.runGeneration ~= runGeneration or not u27.Parent then
                    return;
                end;

                FXUtil.SetEmittersTrailsBeamsEnabled(u27, false);
                task.delay(u28, function() -- Line: 68
                    -- upvalues: u23 (ref), runGeneration (ref), u27 (ref)
                    if u23.runGeneration ~= runGeneration then
                        return;
                    end;

                    if u27.Parent then
                        u27:Destroy();
                    end;
                end);
            end);
        end;
    end;

    local u29 = skillRunData.material["大地突起爆炸尘土效果"];

    if u29 then
        u29:ScaleTo(v24);
        VisibleMgr.UnQueryAll(u29);
        local Rotation = u29:GetPivot().Rotation;
        u29:PivotTo(CFrame.new(Position2) * Rotation);
        u29.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(u29, true);
        SkillCommon.appendRunSpawnList(skillRunData, "TerraSpireSpawned", u29);

        if u29 then
            local u30 = 2.55;
            task.delay(0.45, function() -- Line: 63
                -- upvalues: u23 (copy), runGeneration (copy), u29 (copy), FXUtil (ref), u30 (copy)
                if u23.runGeneration ~= runGeneration or not u29.Parent then
                    return;
                end;

                FXUtil.SetEmittersTrailsBeamsEnabled(u29, false);
                task.delay(u30, function() -- Line: 68
                    -- upvalues: u23 (ref), runGeneration (ref), u29 (ref)
                    if u23.runGeneration ~= runGeneration then
                        return;
                    end;

                    if u29.Parent then
                        u29:Destroy();
                    end;
                end);
            end);
        end;
    end;

    local u31 = skillRunData.material["大地突起尖刺群"];

    if not u31 then
        return;
    end;

    u31:ScaleTo(v24);
    VisibleMgr.UnQueryAll(u31);
    local v32 = u31.PrimaryPart or u31:FindFirstChildWhichIsA("BasePart", true);

    if not v32 then
        return;
    end;

    local Y = v32.Size.Y;
    local Rotation = u31:GetPivot().Rotation;
    local X = Position2.X;
    local Y2 = Position2.Y;
    local Z = Position2.Z;
    local u33 = Vector3.new(X, Y2 - Y / 2, Z);
    local u34 = Vector3.new(X, Y2 + Y / 2, Z);
    u31:PivotTo(CFrame.new(u33) * Rotation);
    u31.Parent = workspace.Debris;
    SkillCommon.appendRunSpawnList(skillRunData, "TerraSpireSpawned", u31);
    skillRunData.TerraSpireSpikeModel = u31;
    local u35 = 0;
    u23.skillRunData.runEvent["大地突起尖刺升起动画"] = RunService.Heartbeat:Connect(function(p36) -- Line: 290
        -- upvalues: u23 (copy), runGeneration (copy), u35 (ref), TweenService (ref), u33 (copy), u34 (copy), u31 (copy), Rotation (copy), SkillCommon (ref), Position2 (copy)
        local v37 = u23:isRunningFlow();

        if v37 then
            if u23.runGeneration == runGeneration then
                v37 = not u23:isTerminal();
            else
                v37 = false;
            end;
        end;

        if v37 then
            u35 = u35 + p36;
            local v38 = math.clamp(u35 / 0.25, 0, 1);
            local v39 = u33:Lerp(u34, (TweenService:GetValue(v38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)));
            u31:PivotTo(CFrame.new(v39) * Rotation);

            if v38 >= 1 then
                SkillCommon.playSoundLocal3D("音效-技能-大地突起-突起攻击", Position2);

                if u23.skillRunData.runEvent["大地突起尖刺升起动画"] then
                    u23.skillRunData.runEvent["大地突起尖刺升起动画"]:Disconnect();
                    u23.skillRunData.runEvent["大地突起尖刺升起动画"] = nil;
                end;
            end;

            return;
        end;

        local v40 = u23;
        local v41 = v40.skillRunData and v40.skillRunData.runEvent;

        if not v41 then
            return;
        end;

        if v41["大地突起尖刺升起动画"] then
            v41["大地突起尖刺升起动画"]:Disconnect();
            v41["大地突起尖刺升起动画"] = nil;
        end;

        if v41["大地突起突刺命中盒跟随"] then
            v41["大地突起突刺命中盒跟随"]:Disconnect();
            v41["大地突起突刺命中盒跟随"] = nil;
        end;
    end);
end;

function v1.Client_ExitSpikeAscend(p42) -- Line: 310
    -- upvalues: SkillCommon (copy)
    local v43 = p42.skillRunData and p42.skillRunData.runEvent;

    if v43 then
        if v43["大地突起尖刺升起动画"] then
            v43["大地突起尖刺升起动画"]:Disconnect();
            v43["大地突起尖刺升起动画"] = nil;
        end;

        if v43["大地突起突刺命中盒跟随"] then
            v43["大地突起突刺命中盒跟随"]:Disconnect();
            v43["大地突起突刺命中盒跟随"] = nil;
        end;
    end;

    local skillRunData = p42.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p42, p42.runGeneration, skillRunData, "TerraSpireSpawned");
    end;
end;

function v1.Client_ExitWaitBlast(p44) -- Line: 318
    -- upvalues: SkillCommon (copy)
    local skillRunData = p44.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p44, p44.runGeneration, skillRunData, "TerraSpireSpawned");
    end;
end;

function v1.Client_ExitBlast(p45) -- Line: 325
    -- upvalues: SkillCommon (copy)
    local skillRunData = p45.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p45, p45.runGeneration, skillRunData, "TerraSpireSpawned");
    end;
end;

function v1.Server_EnterSpikeAscend(u46) -- Line: 332
    -- upvalues: SkillCommon (copy), RunService (copy), TweenService (copy)
    local u47 = u46.hitbox[1];

    if not (u47 and u47.hitbox) then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u46);
    local hitbox = u47.hitbox;
    local v48 = SkillCommon.scaleBandFromData(u46, SkillCommon.bandScaleOptsFromSkillData(u46));
    local v49 = SkillCommon.resolveStrikeWorldPos(u46.skillInputData);
    local Position = SkillCommon.getGroundCF(CFrame.new(v49)).Position;
    local v50 = 22 * v48;
    hitbox.Size = Vector3.new(40, 40, 40) * v48;
    local Rotation = hitbox.CFrame.Rotation;
    local X = Position.X;
    local Y = Position.Y;
    local Z = Position.Z;
    local u51 = Vector3.new(X, Y - v50 / 2, Z);
    local u52 = Vector3.new(X, Y + v50 / 2, Z);
    u47:start();
    local Rotation2 = hitbox.CFrame.Rotation;
    hitbox:PivotTo(CFrame.new(u51) * Rotation2);
    local u53 = 0;
    u46.skillRunData.runEvent["大地突起突刺命中盒跟随"] = RunService.Heartbeat:Connect(function(p54) -- Line: 354
        -- upvalues: u46 (copy), u47 (copy), u53 (ref), TweenService (ref), u51 (copy), u52 (copy), hitbox (copy), Rotation (copy)
        if u46:isRunningFlow() then
            u53 = u53 + p54;
            local v55 = math.clamp(u53 / 0.25, 0, 1);
            local v56 = u51:Lerp(u52, (TweenService:GetValue(v55, Enum.EasingStyle.Back, Enum.EasingDirection.Out)));
            hitbox:PivotTo(CFrame.new(v56) * Rotation);

            if v55 >= 1 then
                if u47.isActive then
                    u47:stop();
                end;

                if u46.skillRunData.runEvent["大地突起突刺命中盒跟随"] then
                    u46.skillRunData.runEvent["大地突起突刺命中盒跟随"]:Disconnect();
                    u46.skillRunData.runEvent["大地突起突刺命中盒跟随"] = nil;
                end;
            end;

            return;
        end;

        local v57 = u46;
        local v58 = v57.skillRunData and v57.skillRunData.runEvent;

        if v58 then
            if v58["大地突起尖刺升起动画"] then
                v58["大地突起尖刺升起动画"]:Disconnect();
                v58["大地突起尖刺升起动画"] = nil;
            end;

            if v58["大地突起突刺命中盒跟随"] then
                v58["大地突起突刺命中盒跟随"]:Disconnect();
                v58["大地突起突刺命中盒跟随"] = nil;
            end;
        end;

        if u47.isActive then
            u47:stop();
        end;
    end);
end;

function v1.Server_ExitSpikeAscend(p59) -- Line: 379
    local v60 = p59.skillRunData and p59.skillRunData.runEvent;

    if v60 then
        if v60["大地突起尖刺升起动画"] then
            v60["大地突起尖刺升起动画"]:Disconnect();
            v60["大地突起尖刺升起动画"] = nil;
        end;

        if v60["大地突起突刺命中盒跟随"] then
            v60["大地突起突刺命中盒跟随"]:Disconnect();
            v60["大地突起突刺命中盒跟随"] = nil;
        end;
    end;

    local v61 = p59.hitbox[1];

    if v61 and v61.isActive then
        v61:stop();
    end;
end;

function v1.Client_EnterWaitBlast(p62) -- Line: 388
end;

function v1.Server_EnterWaitBlast(p63) -- Line: 390
end;

function v1.Client_EnterBlast(u64) -- Line: 393
    -- upvalues: SkillCommon (copy), FXUtil (copy), VisibleMgr (copy)
    local skillRunData = u64.skillRunData;
    local runGeneration = u64.runGeneration;
    local u65 = SkillCommon.scaleBandFromData(u64, SkillCommon.bandScaleOptsFromSkillData(u64));
    local v66 = SkillCommon.resolveStrikeWorldPos(u64.skillInputData);
    local Position = SkillCommon.getGroundCF(CFrame.new(v66)).Position;
    local TerraSpireSpikeModel = skillRunData.TerraSpireSpikeModel;

    if TerraSpireSpikeModel and TerraSpireSpikeModel.Parent then
        FXUtil.SetEmittersTrailsBeamsEnabled(TerraSpireSpikeModel, false);
        FXUtil.Model_Fade(TerraSpireSpikeModel, 0.18);

        if TerraSpireSpikeModel then
            local u67 = 3;
            task.delay(0, function() -- Line: 63
                -- upvalues: u64 (copy), runGeneration (copy), TerraSpireSpikeModel (copy), FXUtil (ref), u67 (copy)
                if u64.runGeneration ~= runGeneration or not TerraSpireSpikeModel.Parent then
                    return;
                end;

                FXUtil.SetEmittersTrailsBeamsEnabled(TerraSpireSpikeModel, false);
                task.delay(u67, function() -- Line: 68
                    -- upvalues: u64 (ref), runGeneration (ref), TerraSpireSpikeModel (ref)
                    if u64.runGeneration ~= runGeneration then
                        return;
                    end;

                    if TerraSpireSpikeModel.Parent then
                        TerraSpireSpikeModel:Destroy();
                    end;
                end);
            end);
        end;

        skillRunData.TerraSpireSpikeModel = nil;
    end;

    local function _() -- Line: 408
        -- upvalues: u64 (copy), runGeneration (copy)
        local v68 = u64:isRunningFlow() and u64.runGeneration == runGeneration;

        return v68;
    end;

    task.defer(function() -- Line: 412
        -- upvalues: u64 (copy), runGeneration (copy), skillRunData (copy), u65 (copy), VisibleMgr (ref), Position (copy), FXUtil (ref), SkillCommon (ref)
        local v69 = u64:isRunningFlow() and u64.runGeneration == runGeneration;

        if not v69 then
            return;
        end;

        local u70 = skillRunData.material["大地突起爆炸"];

        if u70 then
            u70:ScaleTo(u65);
            VisibleMgr.UnQueryAll(u70);
            local Rotation = u70:GetPivot().Rotation;
            u70:PivotTo(CFrame.new(Position) * Rotation);
            u70.Parent = workspace.Debris;
            FXUtil.Emit_Particles_GetDescendants(u70, true);
            SkillCommon.appendRunSpawnList(skillRunData, "TerraSpireSpawned", u70);
            local u71 = u64;
            local u72 = runGeneration;

            if not u70 then
                return;
            end;

            local u73 = 3;
            task.delay(0.22, function() -- Line: 63
                -- upvalues: u71 (copy), u72 (copy), u70 (copy), FXUtil (ref), u73 (copy)
                if u71.runGeneration ~= u72 or not u70.Parent then
                    return;
                end;

                FXUtil.SetEmittersTrailsBeamsEnabled(u70, false);
                task.delay(u73, function() -- Line: 68
                    -- upvalues: u71 (ref), u72 (ref), u70 (ref)
                    if u71.runGeneration ~= u72 then
                        return;
                    end;

                    if u70.Parent then
                        u70:Destroy();
                    end;
                end);
            end);
        end;
    end);
end;

function v1.Server_EnterBlast(u74) -- Line: 430
    -- upvalues: SkillCommon (copy), RunService (copy)
    local u75 = u74.hitbox[2];

    if not (u75 and u75.hitbox) then
        return;
    end;

    local hitbox = u75.hitbox;
    local v76 = SkillCommon.scaleBandFromData(u74, SkillCommon.bandScaleOptsFromSkillData(u74));
    local v77 = SkillCommon.resolveStrikeWorldPos(u74.skillInputData);
    local Position = SkillCommon.getGroundCF(CFrame.new(v77)).Position;
    hitbox.Size = Vector3.new(40, 40, 40) * v76;
    local Rotation = hitbox.CFrame.Rotation;
    hitbox:PivotTo(CFrame.new(Position) * Rotation);
    local u78 = false;
    local u79 = 0;
    u74.skillRunData.runEvent["大地突起爆炸命中盒窗口"] = RunService.Heartbeat:Connect(function(p80) -- Line: 444
        -- upvalues: u74 (copy), u75 (copy), u79 (ref), u78 (ref)
        if u74:isRunningFlow() then
            u79 = u79 + p80;

            if not u78 and u79 >= 0.02 then
                u78 = true;
                u75:start();
            end;

            if u79 >= 0.14 then
                if u75.isActive then
                    u75:stop();
                end;

                local v81 = u74;
                local v82 = v81.skillRunData and v81.skillRunData.runEvent;

                if not v82 then
                    return;
                end;

                if v82["大地突起爆炸命中盒窗口"] then
                    v82["大地突起爆炸命中盒窗口"]:Disconnect();
                    v82["大地突起爆炸命中盒窗口"] = nil;
                end;
            end;

            return;
        end;

        local v83 = u74;
        local v84 = v83.skillRunData and v83.skillRunData.runEvent;

        if v84 and v84["大地突起爆炸命中盒窗口"] then
            v84["大地突起爆炸命中盒窗口"]:Disconnect();
            v84["大地突起爆炸命中盒窗口"] = nil;
        end;

        if u75.isActive then
            u75:stop();
        end;
    end);
end;

function v1.Server_ExitBlast(p85) -- Line: 466
    local v86 = p85.skillRunData and p85.skillRunData.runEvent;

    if v86 and v86["大地突起爆炸命中盒窗口"] then
        v86["大地突起爆炸命中盒窗口"]:Disconnect();
        v86["大地突起爆炸命中盒窗口"] = nil;
    end;

    local v87 = p85.hitbox[2];

    if v87 and v87.isActive then
        v87:stop();
    end;
end;

function v1.Server_EnterRecovery(p88) -- Line: 475
    p88:releaseControl();
end;

function v1.Client_EnterRecovery(p89) -- Line: 479
    -- upvalues: SkillCommon (copy)
    local v90 = p89.skillRunData and p89.skillRunData.runEvent;

    if v90 then
        if v90["大地突起尖刺升起动画"] then
            v90["大地突起尖刺升起动画"]:Disconnect();
            v90["大地突起尖刺升起动画"] = nil;
        end;

        if v90["大地突起突刺命中盒跟随"] then
            v90["大地突起突刺命中盒跟随"]:Disconnect();
            v90["大地突起突刺命中盒跟随"] = nil;
        end;
    end;

    local skillRunData = p89.skillRunData;

    if skillRunData then
        SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "土系尾迹", "大地突起Cast尾迹");
    end;

    local v91;

    if skillRunData then
        v91 = skillRunData.TerraSpireSpikeModel;
    else
        v91 = skillRunData;
    end;

    if v91 and v91.Parent then
        game.Debris:AddItem(v91, 0);
        skillRunData.TerraSpireSpikeModel = nil;
    end;
end;

function v1.onEnd(p92) -- Line: 492
    -- upvalues: SkillCommon (copy)
    local v93 = p92.skillRunData and p92.skillRunData.runEvent;

    if v93 then
        if v93["大地突起尖刺升起动画"] then
            v93["大地突起尖刺升起动画"]:Disconnect();
            v93["大地突起尖刺升起动画"] = nil;
        end;

        if v93["大地突起突刺命中盒跟随"] then
            v93["大地突起突刺命中盒跟随"]:Disconnect();
            v93["大地突起突刺命中盒跟随"] = nil;
        end;
    end;

    local skillRunData = p92.skillRunData;

    if not skillRunData then
        return;
    end;

    SkillCommon.cleanupWandTipTrailFromMaterial(skillRunData, "土系尾迹", "大地突起Cast尾迹");

    if skillRunData.TerraSpireSpikeModel and skillRunData.TerraSpireSpikeModel.Parent then
        skillRunData.TerraSpireSpikeModel:Destroy();
        skillRunData.TerraSpireSpikeModel = nil;
    end;
end;

function v1.onEndServer(p94) -- Line: 505
    local v95 = p94.hitbox[1];

    if v95 and v95.isActive then
        v95:stop();
    end;

    local v96 = p94.hitbox[2];

    if v96 and v96.isActive then
        v96:stop();
    end;
end;

v1.SoundList = { "音效-技能-地法阵", "音效-技能-大地突起-突起攻击" };
v1.AnimateList = { "技能释放动作6" };
v1.ResNameList = { "土系尾迹", "大地突起法阵", "大地突起尖刺群", "大地突起爆炸", "大地突起爆炸尘土效果" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "地属性受击",
        CameraShakeProfile = "轻攻击震",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "地属性受击",
        CameraShakeProfile = "轻攻击震",
        PhysicsEffectName = "通用受击物理效果"
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