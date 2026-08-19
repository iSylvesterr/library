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
local u2 = {
    explosionTrack = "烈火焚身爆炸跟随",
    hitPulse = "烈火焚身命中盒"
};
local u3 = { 0.317, 0.817, 1.317, 1.817, 2.317 };
local u4 = { 0.6, 0.75, 0.9, 1.05, 1.2 };
local u5 = { "音效-技能-烈火焚身-火1", "音效-技能-烈火焚身-火2", "音效-技能-烈火焚身-火3", "音效-技能-烈火焚身-火4", "音效-技能-烈火焚身-火5" };

local function strikeHrpPos(p6) -- Line: 58
    -- upvalues: SkillCommon (copy)
    local v7 = SkillCommon.resolveTrackTargetHrp(p6);

    if v7 and v7.Parent then
        return v7.Position;
    end;

    return SkillCommon.resolveStrikeWorldPos(p6);
end;

local function explosionWorldCF(p8, p9, p10, p11) -- Line: 67
    -- upvalues: SkillCommon (copy), FXUtil (copy)
    local v12 = SkillCommon.resolveStruckTargetGroundWorldPos(p8, 4, 0.5, "Ground");
    local v13 = p10 * 4 * p11;
    local _, v14 = SkillCommon.horizontalHrpStrikeFlatBasis(p9, v12);
    local v15 = SkillCommon.resolveTrackTargetHrp(p8);
    local v16;

    if v15 then
        v16 = v15.Position;
    else
        v16 = v12;
    end;

    local v17 = FXUtil.GetGroundAlignedCF(v16, v14, "Ground", 4, 0);

    if v17 then
        return v17 * CFrame.new(0, -v13, 0);
    end;

    return CFrame.new(v12 + Vector3.new(0, -v13, 0)) * CFrame.lookAt(Vector3.new(0, 0, 0), v14, Vector3.new(0, 1, 0)).Rotation;
end;

local function cleanupRunFx(p18) -- Line: 80
    -- upvalues: SkillCommon (copy)
    SkillCommon.disconnectRunEventKeys(p18.skillRunData, { "烈火焚身爆炸跟随", "烈火焚身命中盒" });
end;

local function scheduleFxRecycle(u19, u20, u21) -- Line: 87
    -- upvalues: VisibleMgr (copy)
    if not u21 then
        return;
    end;

    task.delay(2, function() -- Line: 91
        -- upvalues: u20 (copy), u19 (copy), u21 (copy), VisibleMgr (ref)
        if u20.runGeneration ~= u19 or not u21.Parent then
            return;
        end;

        VisibleMgr.fadeAll(u21, 1);
        task.delay(0.15, function() -- Line: 96
            -- upvalues: u21 (ref)
            if u21.Parent then
                u21:Destroy();
            end;
        end);
    end);
end;

v1.InitialState = "Startup";
v1.ControlOpenState = "Main";
v1.States = {
    Startup = {
        Duration = 0.25,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    Main = {
        Duration = 2.45,
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

function v1.Client_EnterStartup(p22) -- Line: 141
    -- upvalues: SkillCommon (copy)
    local v23 = p22.skillInputData and p22.skillInputData.character;

    if not v23 then
        return;
    end;

    local v24 = SkillCommon.resolveWandTipFromCharacter(v23);

    if v24 then
        SkillCommon.scheduleWandTipElementTrail(p22, v24, {
            trailMaterialKey = "火系尾迹",
            runEventKey = "烈火焚身Cast尾迹",
            enableAt = 0.1,
            disableAt = 0.6
        });
    end;
end;

function v1.Server_EnterStartup(p25) -- Line: 157
    -- upvalues: SkillCommon (copy), u4 (copy)
    local v26 = 20 * SkillCommon.scaleBandFromData(p25, SkillCommon.bandScaleOptsFromSkillData(p25)) * u4[1];
    local v27 = p25.hitbox[1];

    if v27 and v27.hitbox then
        local hitbox = v27.hitbox;

        if hitbox:IsA("BasePart") then
            hitbox.Shape = Enum.PartType.Ball;
        end;

        hitbox.Size = Vector3.new(v26, v26, v26);
    end;
end;

function v1.Client_EnterMain(u28) -- Line: 170
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), u4 (copy), explosionWorldCF (copy), RunService (copy), u5 (copy), u3 (copy)
    local skillInputData = u28.skillInputData;
    local v29;

    if skillInputData then
        v29 = skillInputData.character;
    else
        v29 = skillInputData;
    end;

    local skillRunData = u28.skillRunData;

    if not (v29 and (skillRunData and skillRunData.material)) then
        return;
    end;

    local runGeneration = u28.runGeneration;
    local HumanoidRootPart = v29:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local material = skillRunData.material;
    local u30 = SkillCommon.scaleBandFromData(u28, SkillCommon.bandScaleOptsFromSkillData(u28));

    local function still() -- Line: 186
        -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy)
        return SkillCommon.isRunningSameGeneration(u28, runGeneration);
    end;

    local function deployFormation(p31, p32) -- Line: 190
        -- upvalues: u30 (copy), VisibleMgr (ref), SkillCommon (ref), skillRunData (copy)
        p31:ScaleTo(u30);
        VisibleMgr.UnQueryAll(p31);
        SkillCommon.pivotInstanceToWorldCF(p31, CFrame.new(p32) * p31:GetPivot().Rotation);
        p31.Parent = workspace.Debris;
        SkillCommon.appendRunSpawnList(skillRunData, "BlazingBodySpawned", p31);
    end;

    local v33 = material["烈火焚身_法阵"];

    if v33 and v33:IsA("Model") then
        local v34 = SkillCommon.casterFeetGroundWorldPos(HumanoidRootPart, 4, 0.35, "Ground");
        deployFormation(v33, v34);
        FXUtil.Emit_Particles_GetDescendants(v33, true);
        SkillCommon.playSoundLocal3D("音效-技能-火法阵2", v34);
    end;

    local u35 = nil;
    local u36 = u4[1];

    local function pulseExplosionAtTarget(p37, p38) -- Line: 210
        -- upvalues: u36 (ref), explosionWorldCF (ref), skillInputData (copy), HumanoidRootPart (copy), u30 (copy), u35 (ref), material (copy), VisibleMgr (ref), SkillCommon (ref), skillRunData (copy), RunService (ref), u28 (copy), runGeneration (copy), FXUtil (ref), u5 (ref)
        u36 = p37;
        local v39 = explosionWorldCF(skillInputData, HumanoidRootPart, u30, p37);
        local u40 = u35;

        if not (u40 and u40.Parent) then
            local v41 = material["烈火焚身_爆炸"];

            if not (v41 and v41:IsA("Model")) then
                return;
            end;

            u40 = v41;
            u40:ScaleTo(u30);
            u40:SetAttribute("ModelScale", u30);
            VisibleMgr.UnQueryAll(u40);
            u40.Parent = workspace.Debris;
            SkillCommon.appendRunSpawnList(skillRunData, "BlazingBodySpawned", u40);
            u35 = u40;
            SkillCommon.disconnectRunEventKeys(skillRunData, { "烈火焚身爆炸跟随" });
            skillRunData.runEvent["烈火焚身爆炸跟随"] = RunService.Heartbeat:Connect(function() -- Line: 227
                -- upvalues: SkillCommon (ref), u28 (ref), runGeneration (ref), u40 (ref), explosionWorldCF (ref), skillInputData (ref), HumanoidRootPart (ref), u30 (ref), u36 (ref)
                if not (SkillCommon.isRunningSameGeneration(u28, runGeneration) and u40.Parent) then
                    return;
                end;

                u40:PivotTo((explosionWorldCF(skillInputData, HumanoidRootPart, u30, u36)));
            end);
        end;

        FXUtil.Set_Scale_Model(u40, p37);
        u40:PivotTo(v39);
        FXUtil.Emit_Particles_GetDescendants(u40, true);
        local v42 = u5[p38];

        if v42 then
            SkillCommon.playSoundLocal3D(v42, v39.Position);
        end;
    end;

    for i = 1, #u3 do
        local u43 = u4[i];
        local u44 = i == #u3;
        task.delay(u3[i], function() -- Line: 247
            -- upvalues: SkillCommon (ref), u28 (copy), runGeneration (copy), pulseExplosionAtTarget (copy), u43 (copy), i (copy), u44 (copy), skillRunData (copy), u35 (ref), VisibleMgr (ref)
            if not SkillCommon.isRunningSameGeneration(u28, runGeneration) then
                return;
            end;

            pulseExplosionAtTarget(u43, i);

            if u44 then
                SkillCommon.disconnectRunEventKeys(skillRunData, { "烈火焚身爆炸跟随" });
                local u45 = runGeneration;
                local u46 = u28;
                local u47 = u35;

                if not u47 then
                    return;
                end;

                task.delay(2, function() -- Line: 91
                    -- upvalues: u46 (copy), u45 (copy), u47 (copy), VisibleMgr (ref)
                    if u46.runGeneration ~= u45 or not u47.Parent then
                        return;
                    end;

                    VisibleMgr.fadeAll(u47, 1);
                    task.delay(0.15, function() -- Line: 96
                        -- upvalues: u47 (ref)
                        if u47.Parent then
                            u47:Destroy();
                        end;
                    end);
                end);
            end;
        end);
    end;

    SkillCommon.scheduleRunSpawnClear(u28, runGeneration, skillRunData, "BlazingBodySpawned", u3[#u3] + 2 + 0.15);
end;

function v1.Client_ExitMain(p48) -- Line: 263
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p48.skillRunData, { u2.explosionTrack, u2.hitPulse });
    local skillRunData = p48.skillRunData;

    if skillRunData then
        SkillCommon.clearSpawnIfTerminalAfterExit(p48, p48.runGeneration, skillRunData, "BlazingBodySpawned");
    end;
end;

function v1.Client_EnterRecovery(p49) -- Line: 271
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.cleanupWandTipTrailFromMaterial(p49.skillRunData, "火系尾迹", "烈火焚身Cast尾迹");
    SkillCommon.disconnectRunEventKeys(p49.skillRunData, { u2.explosionTrack, u2.hitPulse });
end;

function v1.onEnd(p50) -- Line: 276
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p50.skillRunData, { u2.explosionTrack, u2.hitPulse });
    SkillCommon.cleanupWandTipTrailFromMaterial(p50.skillRunData, "火系尾迹", "烈火焚身Cast尾迹");
end;

function v1.Server_EnterMain(u51) -- Line: 281
    -- upvalues: SkillCommon (copy), u3 (copy), RunService (copy), u4 (copy), strikeHrpPos (copy)
    local skillInputData = u51.skillInputData;

    if not skillInputData then
        return;
    end;

    local u52 = u51.hitbox[1];

    if not (u52 and u52.hitbox) then
        return;
    end;

    local u53 = SkillCommon.scaleBandFromData(u51, SkillCommon.bandScaleOptsFromSkillData(u51));
    local runGeneration = u51.runGeneration;
    local u54 = 0;
    local u55 = 0;
    local u56 = u3[#u3];
    SkillCommon.disconnectRunEventKeys(u51.skillRunData, { "烈火焚身命中盒" });
    u51.skillRunData.runEvent["烈火焚身命中盒"] = RunService.Heartbeat:Connect(function(p57) -- Line: 298
        -- upvalues: u51 (copy), runGeneration (copy), u55 (ref), u54 (ref), u3 (ref), u4 (ref), u53 (copy), u52 (copy), strikeHrpPos (ref), skillInputData (copy), u56 (copy)
        if not u51:isRunningFlow() or u51.runGeneration ~= runGeneration then
            return;
        end;

        u55 = u55 + p57;

        while u54 < #u3 and u55 >= u3[u54 + 1] do
            u54 = u54 + 1;
            local v58 = 20 * u53 * u4[u54];
            u52.hitbox.Size = Vector3.new(v58, v58, v58);
            u52.hitbox:PivotTo(CFrame.new(strikeHrpPos(skillInputData)));
            u52:start();
            task.delay(0.12, function() -- Line: 310
                -- upvalues: u52 (ref)
                if u52.isActive then
                    u52:stop();
                end;
            end);
        end;

        local v59 = u55 >= u56 + 0.15 and u51.skillRunData.runEvent["烈火焚身命中盒"];

        if v59 then
            v59:Disconnect();
            u51.skillRunData.runEvent["烈火焚身命中盒"] = nil;
        end;
    end);
end;

function v1.Server_ExitMain(p60) -- Line: 326
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p60.skillRunData, { u2.explosionTrack, u2.hitPulse });
    local v61 = p60.hitbox[1];

    if v61 and v61.isActive then
        v61:stop();
    end;
end;

function v1.Server_EnterRecovery(p62) -- Line: 334
    p62:releaseControl();
end;

function v1.onEndServer(p63) -- Line: 338
    -- upvalues: SkillCommon (copy), u2 (copy)
    SkillCommon.disconnectRunEventKeys(p63.skillRunData, { u2.explosionTrack, u2.hitPulse });
    local v64 = p63.hitbox[1];

    if v64 and v64.isActive then
        v64:stop();
    end;
end;

v1.SoundList = { "音效-技能-火法阵2", "音效-技能-烈火焚身-火1", "音效-技能-烈火焚身-火2", "音效-技能-烈火焚身-火3", "音效-技能-烈火焚身-火4", "音效-技能-烈火焚身-火5" };
v1.AnimateList = { "技能释放动作10" };
v1.ResNameList = { "火系尾迹", "烈火焚身_法阵", "烈火焚身_爆炸" };
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