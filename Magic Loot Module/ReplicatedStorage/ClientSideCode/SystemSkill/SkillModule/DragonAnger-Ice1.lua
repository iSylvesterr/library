-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local VisibleMgr = UtilsSystem.VisibleMgr;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local RunService = UtilsSystem.RunService;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64,
    skillSizeScale = 1
};
local AIM_RUN_EVENT_KEY = SkillTelegraph.AIM_RUN_EVENT_KEY;
local u2 = CFrame.new();
local u3 = CFrame.Angles(0, 0, 1.5707963267948966);
local u4 = {
    {
        duration = 1,
        scaleTweenTime = 0.2,
        startScale = 0.1,
        endScale = 1,
        startupScale = 1,
        groundYOffset = 0.1,
        hitboxSize = Vector3.new(50, 50, 50),
        hitboxStartDelay = 0,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.Out
    },
    {
        duration = 1,
        scaleTweenTime = 0.2,
        startScale = 0.1,
        endScale = 1.4,
        startupScale = 1.4,
        groundYOffset = 0.1,
        hitboxSize = Vector3.new(46, 46, 46),
        hitboxStartDelay = 0,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.Out
    },
    {
        duration = 1,
        scaleTweenTime = 0.2,
        startScale = 0.1,
        endScale = 1.8,
        startupScale = 1.8,
        groundYOffset = 0.1,
        hitboxSize = Vector3.new(50, 50, 50),
        hitboxStartDelay = 0,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.Out
    }
};
local u5 = u4[1].duration + u4[2].duration + u4[3].duration;
u1.InitialState = "Startup";
u1.ControlOpenState = "Recovery";
u1.States = {
    Startup = {
        Duration = 0.9,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup"
    },
    AngerRoar1 = {
        OnEnterClient = "Client_EnterAngerRoar1",
        OnEnterServer = "Server_EnterAngerRoar1",
        OnExitClient = "Client_ExitAngerRoar1",
        OnExitServer = "Server_ExitAngerRoar1",
        Duration = u4[1].duration
    },
    AngerRoar2 = {
        OnEnterClient = "Client_EnterAngerRoar2",
        OnEnterServer = "Server_EnterAngerRoar2",
        OnExitClient = "Client_ExitAngerRoar2",
        OnExitServer = "Server_ExitAngerRoar2",
        Duration = u4[2].duration
    },
    AngerRoar3 = {
        OnEnterClient = "Client_EnterAngerRoar3",
        OnEnterServer = "Server_EnterAngerRoar3",
        OnExitClient = "Client_ExitAngerRoar3",
        OnExitServer = "Server_ExitAngerRoar3",
        Duration = u4[3].duration
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
        To = "AngerRoar1",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "AngerRoar1",
        To = "AngerRoar2",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "AngerRoar2",
        To = "AngerRoar3",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "AngerRoar3",
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
        From = "AngerRoar1",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "AngerRoar2",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "AngerRoar3",
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
        From = "AngerRoar1",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "AngerRoar2",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "AngerRoar3",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function getSkillScale(p6) -- Line: 163
    -- upvalues: SkillCommon (copy), u1 (copy)
    local v7 = SkillCommon.npcSummonBodySkillScale(p6);
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        return v7 * skillSizeScale;
    end;

    return v7;
end;

local function resolveGroundPos(p8, p9) -- Line: 172
    -- upvalues: RayCast (copy)
    local HumanoidRootPart = p8:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local v10 = RayCast.RayCastDirection(HumanoidRootPart.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v10 then
        return v10.Position + Vector3.new(0, p9, 0);
    end;

    return (HumanoidRootPart:GetPivot() * CFrame.new(0, p9, 0)).Position;
end;

local function cfStartupAtPos(p11) -- Line: 185
    -- upvalues: u2 (copy)
    return CFrame.new(p11) * u2;
end;

local function cfRingAtPos(p12) -- Line: 189
    -- upvalues: u3 (copy)
    return CFrame.new(p12) * u3;
end;

local function resolveStartupScale(p13) -- Line: 193
    local startupScale = p13.startupScale;

    if type(startupScale) == "number" and startupScale > 0 then
        return startupScale;
    end;

    return p13.endScale;
end;

local function resolveMaxTelegraphSize(p14) -- Line: 207
    -- upvalues: u4 (copy)
    local v15 = u4[3];

    return v15.hitboxSize * v15.endScale * p14;
end;

local function tweenHitboxSizeLikeRing(p16, p17, p18) -- Line: 219
    -- upvalues: FXUtil (copy)
    local v19 = p17.hitboxSize * p18;
    p16.Size = v19 * p17.startScale;
    FXUtil.BasePart_Size_Tween(p16, p17.scaleTweenTime, v19 * p17.endScale, p17.easingStyle, p17.easingDirection);
end;

local function startTelegraphAimLoop(u20, u21, u22) -- Line: 238
    -- upvalues: AIM_RUN_EVENT_KEY (copy), u4 (copy), RunService (copy), SkillCommon (copy), resolveGroundPos (copy), u1 (copy)
    local runEvent = u21.runEvent;

    if not runEvent then
        return;
    end;

    local v23 = runEvent[AIM_RUN_EVENT_KEY];

    if v23 then
        v23:Disconnect();
        runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local u24 = u4[3].groundYOffset or 0;
    runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 250
        -- upvalues: SkillCommon (ref), u20 (copy), u22 (copy), runEvent (copy), AIM_RUN_EVENT_KEY (ref), u21 (copy), resolveGroundPos (ref), u24 (copy), u1 (ref), u4 (ref)
        if not SkillCommon.isRunningSameGeneration(u20, u22) then
            local v25 = runEvent[AIM_RUN_EVENT_KEY];

            if v25 then
                v25:Disconnect();
                runEvent[AIM_RUN_EVENT_KEY] = nil;
            end;

            return;
        end;

        local v26 = u21.Logic and u21.Logic.dangerTelegraph;

        if not v26 then
            return;
        end;

        local v27 = u20.skillInputData and u20.skillInputData.character;

        if not v27 then
            return;
        end;

        local v28 = resolveGroundPos(v27, u24);

        if not v28 then
            return;
        end;

        local v29 = {
            worldCFrame = CFrame.new(v28)
        };
        local v30 = SkillCommon.npcSummonBodySkillScale(u20);
        local skillSizeScale = u1.skillSizeScale;

        if type(skillSizeScale) == "number" and skillSizeScale > 0 then
            v30 = v30 * skillSizeScale;
        end;

        local v31 = u4[3];
        v29.hitboxSize = v31.hitboxSize * v31.endScale * v30;
        v26:update(v29);
    end);
end;

local function stopRingFx(p32) -- Line: 278
    -- upvalues: FXUtil (copy)
    if not p32 then
        return;
    end;

    FXUtil.Stop_All_Emit(p32);
end;

local function clientEnterRoar(u33, p34) -- Line: 285
    -- upvalues: u4 (copy), resolveGroundPos (copy), SkillCommon (copy), u1 (copy), VisibleMgr (copy), u2 (copy), FXUtil (copy), u3 (copy), RunService (copy)
    local v35 = u4[p34];

    if not v35 then
        return;
    end;

    local character = u33.skillInputData.character;

    if not character then
        return;
    end;

    local v36 = resolveGroundPos(character, v35.groundYOffset or 0);

    if not v36 then
        return;
    end;

    local skillRunData = u33.skillRunData;
    local material = skillRunData.material;

    if not material then
        return;
    end;

    local v37 = SkillCommon.npcSummonBodySkillScale(u33);
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        v37 = v37 * skillSizeScale;
    end;

    local v38 = v37 * 2.2;
    local runGeneration = u33.runGeneration;
    local u39 = v35.groundYOffset or 0;
    local u40 = material["龙之怒起手-冰"];

    if u40 and u40:IsA("Model") then
        local startupScale = v35.startupScale;

        if type(startupScale) ~= "number" or startupScale <= 0 then
            startupScale = v35.endScale;
        end;

        u40:ScaleTo(startupScale * v38);
        VisibleMgr.UnQueryAll(u40);
        u40:PivotTo(CFrame.new(v36) * u2);
        u40.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(u40, true);
    end;

    local u41 = material["龙之怒火圈-冰"];

    if not (u41 and u41:IsA("Model")) then
        return;
    end;

    VisibleMgr.UnQueryAll(u41);
    u41:PivotTo(CFrame.new(v36) * u3);
    u41.Parent = workspace.Debris;
    local v42 = v35.startScale * v38;
    local v43 = v35.endScale * v38;
    u41:ScaleTo(v42);
    FXUtil.Start_All_Emit(u41, v35.scaleTweenTime + 1);
    FXUtil.Model_Scale_Tween(u41, v42, v43, v35.scaleTweenTime, v35.easingStyle, v35.easingDirection, function() -- Line: 343
        -- upvalues: SkillCommon (ref), u33 (copy), runGeneration (copy), u41 (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u33, runGeneration) then
            return;
        end;

        local v44 = u41;

        if not v44 then
            return;
        end;

        FXUtil.Stop_All_Emit(v44);
    end, true);
    skillRunData.runEvent["龙之怒地面跟随" .. p34] = RunService.Heartbeat:Connect(function() -- Line: 352
        -- upvalues: character (copy), resolveGroundPos (ref), u39 (copy), u40 (copy), u2 (ref), u41 (copy), u3 (ref)
        if not character.Parent then
            return;
        end;

        local v45 = resolveGroundPos(character, u39);

        if not v45 then
            return;
        end;

        if u40 and u40.Parent then
            u40:PivotTo(CFrame.new(v45) * u2);
        end;

        if u41 and u41.Parent then
            u41:PivotTo(CFrame.new(v45) * u3);
        end;
    end);
end;

local function clientExitRoar(p46, p47) -- Line: 369
    -- upvalues: FXUtil (copy)
    local v48 = p46.skillRunData and p46.skillRunData.runEvent;
    local v49 = "龙之怒地面跟随" .. p47;

    if v48 and v48[v49] then
        v48[v49]:Disconnect();
        v48[v49] = nil;
    end;

    local v50 = p46.skillRunData and p46.skillRunData.material;

    if v50 then
        v50 = v50["龙之怒火圈-冰"];
    end;

    if not v50 then
        return;
    end;

    FXUtil.Stop_All_Emit(v50);
end;

local function serverEnterRoar(u51, p52) -- Line: 380
    -- upvalues: u4 (copy), resolveGroundPos (copy), SkillCommon (copy), u1 (copy), FXUtil (copy), RunService (copy)
    local u53 = u4[p52];

    if not u53 then
        return;
    end;

    local character = u51.skillInputData.character;

    if not character then
        return;
    end;

    local v54 = resolveGroundPos(character, u53.groundYOffset or 0);

    if not v54 then
        return;
    end;

    local u55 = u51.hitbox[p52];

    if not (u55 and u55.hitbox) then
        return;
    end;

    local u56 = SkillCommon.npcSummonBodySkillScale(u51);
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        u56 = u56 * skillSizeScale;
    end;

    u55.hitbox:PivotTo(CFrame.new(v54));
    u55.hitbox.Transparency = 1;
    local u57 = u53.groundYOffset or 0;
    local u58 = "龙之怒命中跟随" .. p52;
    task.delay(u53.hitboxStartDelay or 0, function() -- Line: 411
        -- upvalues: u51 (copy), resolveGroundPos (ref), character (copy), u57 (copy), u55 (copy), u53 (copy), u56 (copy), FXUtil (ref), u58 (copy), RunService (ref)
        if not u51:isRunningFlow() then
            return;
        end;

        local v59 = resolveGroundPos(character, u57);

        if v59 then
            u55.hitbox:PivotTo(CFrame.new(v59));
        end;

        u55.hitbox.Transparency = 1;
        local hitbox = u55.hitbox;
        local v60 = u53;
        local v61 = v60.hitboxSize * u56;
        hitbox.Size = v61 * v60.startScale;
        FXUtil.BasePart_Size_Tween(hitbox, v60.scaleTweenTime, v61 * v60.endScale, v60.easingStyle, v60.easingDirection);
        u55:start();
        u51.skillRunData.runEvent[u58] = RunService.Heartbeat:Connect(function() -- Line: 426
            -- upvalues: character (ref), resolveGroundPos (ref), u57 (ref), u55 (ref)
            if not character.Parent then
                return;
            end;

            local v62 = resolveGroundPos(character, u57);

            if v62 then
                u55.hitbox:PivotTo(CFrame.new(v62));
            end;
        end);
        task.delay(u53.scaleTweenTime, function() -- Line: 436
            -- upvalues: u51 (ref), u58 (ref), u55 (ref)
            local v63 = u51.skillRunData and u51.skillRunData.runEvent;

            if v63 and v63[u58] then
                v63[u58]:Disconnect();
                v63[u58] = nil;
            end;

            if u55.isActive then
                u55:stop();
            end;
        end);
    end);
end;

local function serverExitRoar(p64, p65) -- Line: 449
    local v66 = p64.skillRunData and p64.skillRunData.runEvent;
    local v67 = "龙之怒命中跟随" .. p65;

    if v66 and v66[v67] then
        v66[v67]:Disconnect();
        v66[v67] = nil;
    end;

    local v68 = p64.hitbox[p65];

    if v68 and v68.isActive then
        v68:stop();
    end;

    if v68 and v68.hitbox then
        v68.hitbox.Transparency = 1;
    end;
end;

function u1.Client_EnterStartup(p69) -- Line: 466
    -- upvalues: u4 (copy), resolveGroundPos (copy), SkillTelegraph (copy), SkillCommon (copy), u1 (copy), startTelegraphAimLoop (copy)
    local v70 = p69.skillInputData and p69.skillInputData.character;

    if not v70 then
        return;
    end;

    local v71 = resolveGroundPos(v70, u4[3].groundYOffset or 0);

    if not v71 then
        return;
    end;

    local skillRunData = p69.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    SkillTelegraph.destroyAllInRunData(skillRunData);
    local v72 = SkillCommon.npcSummonBodySkillScale(p69);
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        v72 = v72 * skillSizeScale;
    end;

    local Logic = skillRunData.Logic;
    local new = SkillTelegraph.new;
    local v73 = {
        shape = "Circle",
        warnDuration = 0.9,
        worldCFrame = CFrame.new(v71)
    };
    local v74 = u4[3];
    v73.hitboxSize = v74.hitboxSize * v74.endScale * v72;
    v73.casterCharacter = v70;
    v73.characterType = p69.characterType;
    Logic.dangerTelegraph = new(v73);
    startTelegraphAimLoop(p69, skillRunData, p69.runGeneration);
end;

function u1.Server_EnterStartup(p75) -- Line: 494
end;

function u1.Client_EnterAngerRoar1(p76) -- Line: 497
    -- upvalues: u5 (copy), clientEnterRoar (copy), SkillCommon (copy)
    local skillRunData = p76.skillRunData;
    local v77 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v77 then
        v77:activate(u5);
    end;

    clientEnterRoar(p76, 1);
    local character = p76.skillInputData.character;

    if not character then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-龙大招-龙叫背景", character:GetPivot().Position);
    SkillCommon.playSoundLocal3D("音效-龙大招-火圈1", character:GetPivot().Position);
end;

function u1.Client_ExitAngerRoar1(p78) -- Line: 514
    -- upvalues: FXUtil (copy)
    local v79 = p78.skillRunData and p78.skillRunData.runEvent;
    local v80 = "龙之怒地面跟随" .. 1;

    if v79 and v79[v80] then
        v79[v80]:Disconnect();
        v79[v80] = nil;
    end;

    local v81 = p78.skillRunData and p78.skillRunData.material;

    if v81 then
        v81 = v81["龙之怒火圈-冰"];
    end;

    if not v81 then
        return;
    end;

    FXUtil.Stop_All_Emit(v81);
end;

function u1.Server_EnterAngerRoar1(p82) -- Line: 518
    -- upvalues: serverEnterRoar (copy)
    serverEnterRoar(p82, 1);
end;

function u1.Server_ExitAngerRoar1(p83) -- Line: 522
    local v84 = p83.skillRunData and p83.skillRunData.runEvent;
    local v85 = "龙之怒命中跟随" .. 1;

    if v84 and v84[v85] then
        v84[v85]:Disconnect();
        v84[v85] = nil;
    end;

    local v86 = p83.hitbox[1];

    if v86 and v86.isActive then
        v86:stop();
    end;

    if v86 and v86.hitbox then
        v86.hitbox.Transparency = 1;
    end;
end;

function u1.Client_EnterAngerRoar2(p87) -- Line: 526
    -- upvalues: clientEnterRoar (copy), SkillCommon (copy)
    clientEnterRoar(p87, 2);
    local character = p87.skillInputData.character;

    if not character then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-龙大招-火圈2", character:GetPivot().Position);
end;

function u1.Client_ExitAngerRoar2(p88) -- Line: 533
    -- upvalues: FXUtil (copy)
    local v89 = p88.skillRunData and p88.skillRunData.runEvent;
    local v90 = "龙之怒地面跟随" .. 2;

    if v89 and v89[v90] then
        v89[v90]:Disconnect();
        v89[v90] = nil;
    end;

    local v91 = p88.skillRunData and p88.skillRunData.material;

    if v91 then
        v91 = v91["龙之怒火圈-冰"];
    end;

    if not v91 then
        return;
    end;

    FXUtil.Stop_All_Emit(v91);
end;

function u1.Server_EnterAngerRoar2(p92) -- Line: 537
    -- upvalues: serverEnterRoar (copy)
    serverEnterRoar(p92, 2);
end;

function u1.Server_ExitAngerRoar2(p93) -- Line: 541
    local v94 = p93.skillRunData and p93.skillRunData.runEvent;
    local v95 = "龙之怒命中跟随" .. 2;

    if v94 and v94[v95] then
        v94[v95]:Disconnect();
        v94[v95] = nil;
    end;

    local v96 = p93.hitbox[2];

    if v96 and v96.isActive then
        v96:stop();
    end;

    if v96 and v96.hitbox then
        v96.hitbox.Transparency = 1;
    end;
end;

function u1.Client_EnterAngerRoar3(p97) -- Line: 545
    -- upvalues: clientEnterRoar (copy), SkillCommon (copy)
    clientEnterRoar(p97, 3);
    local character = p97.skillInputData.character;

    if not character then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-龙大招-火圈3", character:GetPivot().Position);
end;

function u1.Client_ExitAngerRoar3(p98) -- Line: 552
    -- upvalues: FXUtil (copy)
    local v99 = p98.skillRunData and p98.skillRunData.runEvent;
    local v100 = "龙之怒地面跟随" .. 3;

    if v99 and v99[v100] then
        v99[v100]:Disconnect();
        v99[v100] = nil;
    end;

    local v101 = p98.skillRunData and p98.skillRunData.material;

    if v101 then
        v101 = v101["龙之怒火圈-冰"];
    end;

    if not v101 then
        return;
    end;

    FXUtil.Stop_All_Emit(v101);
end;

function u1.Server_EnterAngerRoar3(p102) -- Line: 556
    -- upvalues: serverEnterRoar (copy)
    serverEnterRoar(p102, 3);
end;

function u1.Server_ExitAngerRoar3(p103) -- Line: 560
    local v104 = p103.skillRunData and p103.skillRunData.runEvent;
    local v105 = "龙之怒命中跟随" .. 3;

    if v104 and v104[v105] then
        v104[v105]:Disconnect();
        v104[v105] = nil;
    end;

    local v106 = p103.hitbox[3];

    if v106 and v106.isActive then
        v106:stop();
    end;

    if v106 and v106.hitbox then
        v106.hitbox.Transparency = 1;
    end;
end;

function u1.Server_EnterRecovery(p107) -- Line: 565
    p107:releaseControl();
end;

function u1.Client_EnterRecovery(p108) -- Line: 569
    -- upvalues: FXUtil (copy), SkillTelegraph (copy)
    local v109 = p108.skillRunData and p108.skillRunData.runEvent;
    local v110 = "龙之怒地面跟随" .. 1;

    if v109 and v109[v110] then
        v109[v110]:Disconnect();
        v109[v110] = nil;
    end;

    local v111 = p108.skillRunData and p108.skillRunData.material;

    if v111 then
        v111 = v111["龙之怒火圈-冰"];
    end;

    if v111 then
        FXUtil.Stop_All_Emit(v111);
    end;

    local v112 = p108.skillRunData and p108.skillRunData.runEvent;
    local v113 = "龙之怒地面跟随" .. 2;

    if v112 and v112[v113] then
        v112[v113]:Disconnect();
        v112[v113] = nil;
    end;

    local v114 = p108.skillRunData and p108.skillRunData.material;

    if v114 then
        v114 = v114["龙之怒火圈-冰"];
    end;

    if v114 then
        FXUtil.Stop_All_Emit(v114);
    end;

    local v115 = p108.skillRunData and p108.skillRunData.runEvent;
    local v116 = "龙之怒地面跟随" .. 3;

    if v115 and v115[v116] then
        v115[v116]:Disconnect();
        v115[v116] = nil;
    end;

    local v117 = p108.skillRunData and p108.skillRunData.material;

    if v117 then
        v117 = v117["龙之怒火圈-冰"];
    end;

    if v117 then
        FXUtil.Stop_All_Emit(v117);
    end;

    SkillTelegraph.destroyAllInRunData(p108.skillRunData);
end;

u1.SoundList = { "音效-龙大招-火圈1", "音效-龙大招-火圈2", "音效-龙大招-火圈3", "音效-龙大招-龙叫背景" };
u1.AnimateList = { "龙之怒" };
u1.ResNameList = { "龙之怒起手-冰", "龙之怒火圈-冰" };
u1.hitboxConfig = { {
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
    }, {
        HitboxIndex = 3,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
u1.animationPlaySide = "Server";
u1.Action = {
    {
        action = "Animation",
        startTime = 0,
        animationName = "龙之怒",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        overTime = u5 + 0.9 + 0.2,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;