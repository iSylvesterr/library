-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local VisibleMgr = UtilsSystem.VisibleMgr;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64,
    skillSizeScale = 1
};
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
        hitboxSize = Vector3.new(50, 2, 50),
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
        hitboxSize = Vector3.new(46, 1, 46),
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
        hitboxSize = Vector3.new(50, 1, 50),
        hitboxStartDelay = 0,
        easingStyle = Enum.EasingStyle.Quad,
        easingDirection = Enum.EasingDirection.Out
    }
};
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

local function getSkillScale(p5) -- Line: 155
    -- upvalues: SkillCommon (copy), u1 (copy)
    local v6 = SkillCommon.npcSummonBodySkillScale(p5);
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        return v6 * skillSizeScale;
    end;

    return v6;
end;

local function resolveGroundPos(p7, p8) -- Line: 164
    -- upvalues: RayCast (copy)
    local HumanoidRootPart = p7:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local v9 = RayCast.RayCastDirection(HumanoidRootPart.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v9 then
        return v9.Position + Vector3.new(0, p8, 0);
    end;

    return (HumanoidRootPart:GetPivot() * CFrame.new(0, p8, 0)).Position;
end;

local function cfStartupAtPos(p10) -- Line: 177
    -- upvalues: u2 (copy)
    return CFrame.new(p10) * u2;
end;

local function cfRingAtPos(p11) -- Line: 181
    -- upvalues: u3 (copy)
    return CFrame.new(p11) * u3;
end;

local function resolveStartupScale(p12) -- Line: 185
    local startupScale = p12.startupScale;

    if type(startupScale) == "number" and startupScale > 0 then
        return startupScale;
    end;

    return p12.endScale;
end;

local function tweenHitboxSizeLikeRing(p13, p14, p15) -- Line: 196
    -- upvalues: FXUtil (copy)
    p13.Size = p14.hitboxSize * p15;
    FXUtil.Part_Scale_Tween(p13, p14.startScale, p14.endScale, p14.scaleTweenTime, p14.easingStyle, p14.easingDirection);
end;

local function stopRingFx(p16) -- Line: 209
    -- upvalues: FXUtil (copy)
    if not p16 then
        return;
    end;

    FXUtil.Stop_All_Emit(p16);
end;

local function clientEnterRoar(u17, p18) -- Line: 216
    -- upvalues: u4 (copy), resolveGroundPos (copy), SkillCommon (copy), u1 (copy), VisibleMgr (copy), u2 (copy), FXUtil (copy), u3 (copy), UtilsSystem (copy)
    local v19 = u4[p18];

    if not v19 then
        return;
    end;

    local character = u17.skillInputData.character;

    if not character then
        return;
    end;

    local v20 = resolveGroundPos(character, v19.groundYOffset or 0);

    if not v20 then
        return;
    end;

    local skillRunData = u17.skillRunData;
    local material = skillRunData.material;

    if not material then
        return;
    end;

    local v21 = SkillCommon.npcSummonBodySkillScale(u17);
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        v21 = v21 * skillSizeScale;
    end;

    local runGeneration = u17.runGeneration;
    local u22 = v19.groundYOffset or 0;
    local u23 = material["龙之怒起手"];

    if u23 and u23:IsA("Model") then
        local startupScale = v19.startupScale;

        if type(startupScale) ~= "number" or startupScale <= 0 then
            startupScale = v19.endScale;
        end;

        u23:ScaleTo(startupScale * v21);
        VisibleMgr.UnQueryAll(u23);
        u23:PivotTo(CFrame.new(v20) * u2);
        u23.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(u23, true);
    end;

    local u24 = material["龙之怒火圈"];

    if not (u24 and u24:IsA("Model")) then
        return;
    end;

    VisibleMgr.UnQueryAll(u24);
    u24:PivotTo(CFrame.new(v20) * u3);
    u24.Parent = workspace.Debris;
    local v25 = v19.startScale * v21;
    local v26 = v19.endScale * v21;
    u24:ScaleTo(v25);
    FXUtil.Start_All_Emit(u24, v19.scaleTweenTime + 1);
    FXUtil.Model_Scale_Tween(u24, v25, v26, v19.scaleTweenTime, v19.easingStyle, v19.easingDirection, function() -- Line: 273
        -- upvalues: SkillCommon (ref), u17 (copy), runGeneration (copy), u24 (copy), FXUtil (ref)
        if not SkillCommon.isRunningSameGeneration(u17, runGeneration) then
            return;
        end;

        local v27 = u24;

        if not v27 then
            return;
        end;

        FXUtil.Stop_All_Emit(v27);
    end, true);
    skillRunData.runEvent["龙之怒地面跟随" .. p18] = UtilsSystem.RunService.Heartbeat:Connect(function() -- Line: 282
        -- upvalues: character (copy), resolveGroundPos (ref), u22 (copy), u23 (copy), u2 (ref), u24 (copy), u3 (ref)
        if not character.Parent then
            return;
        end;

        local v28 = resolveGroundPos(character, u22);

        if not v28 then
            return;
        end;

        if u23 and u23.Parent then
            u23:PivotTo(CFrame.new(v28) * u2);
        end;

        if u24 and u24.Parent then
            u24:PivotTo(CFrame.new(v28) * u3);
        end;
    end);
end;

local function clientExitRoar(p29, p30) -- Line: 299
    -- upvalues: FXUtil (copy)
    local v31 = p29.skillRunData and p29.skillRunData.runEvent;
    local v32 = "龙之怒地面跟随" .. p30;

    if v31 and v31[v32] then
        v31[v32]:Disconnect();
        v31[v32] = nil;
    end;

    local v33 = p29.skillRunData and p29.skillRunData.material;

    if v33 then
        v33 = v33["龙之怒火圈"];
    end;

    if not v33 then
        return;
    end;

    FXUtil.Stop_All_Emit(v33);
end;

local function serverEnterRoar(u34, p35) -- Line: 310
    -- upvalues: u4 (copy), resolveGroundPos (copy), SkillCommon (copy), u1 (copy), FXUtil (copy), UtilsSystem (copy)
    local u36 = u4[p35];

    if not u36 then
        return;
    end;

    local character = u34.skillInputData.character;

    if not character then
        return;
    end;

    local v37 = resolveGroundPos(character, u36.groundYOffset or 0);

    if not v37 then
        return;
    end;

    local u38 = u34.hitbox[p35];

    if not (u38 and u38.hitbox) then
        return;
    end;

    local u39 = SkillCommon.npcSummonBodySkillScale(u34);
    local skillSizeScale = u1.skillSizeScale;

    if type(skillSizeScale) == "number" and skillSizeScale > 0 then
        u39 = u39 * skillSizeScale;
    end;

    u38.hitbox:PivotTo(CFrame.new(v37));
    u38.hitbox.Transparency = 1;
    local u40 = u36.groundYOffset or 0;
    local u41 = "龙之怒命中跟随" .. p35;
    task.delay(u36.hitboxStartDelay or 0, function() -- Line: 341
        -- upvalues: u34 (copy), resolveGroundPos (ref), character (copy), u40 (copy), u38 (copy), u36 (copy), u39 (copy), FXUtil (ref), u41 (copy), UtilsSystem (ref)
        if not u34:isRunningFlow() then
            return;
        end;

        local v42 = resolveGroundPos(character, u40);

        if v42 then
            u38.hitbox:PivotTo(CFrame.new(v42));
        end;

        u38.hitbox.Transparency = 1;
        local hitbox = u38.hitbox;
        local v43 = u36;
        hitbox.Size = v43.hitboxSize * u39;
        FXUtil.Part_Scale_Tween(hitbox, v43.startScale, v43.endScale, v43.scaleTweenTime, v43.easingStyle, v43.easingDirection);
        u38:start();
        u34.skillRunData.runEvent[u41] = UtilsSystem.RunService.Heartbeat:Connect(function() -- Line: 356
            -- upvalues: character (ref), resolveGroundPos (ref), u40 (ref), u38 (ref)
            if not character.Parent then
                return;
            end;

            local v44 = resolveGroundPos(character, u40);

            if v44 then
                u38.hitbox:PivotTo(CFrame.new(v44));
            end;
        end);
        task.delay(u36.scaleTweenTime, function() -- Line: 366
            -- upvalues: u34 (ref), u41 (ref), u38 (ref)
            local v45 = u34.skillRunData and u34.skillRunData.runEvent;

            if v45 and v45[u41] then
                v45[u41]:Disconnect();
                v45[u41] = nil;
            end;

            if u38.isActive then
                u38:stop();
            end;
        end);
    end);
end;

local function serverExitRoar(p46, p47) -- Line: 379
    local v48 = p46.skillRunData and p46.skillRunData.runEvent;
    local v49 = "龙之怒命中跟随" .. p47;

    if v48 and v48[v49] then
        v48[v49]:Disconnect();
        v48[v49] = nil;
    end;

    local v50 = p46.hitbox[p47];

    if v50 and v50.isActive then
        v50:stop();
    end;

    if v50 and v50.hitbox then
        v50.hitbox.Transparency = 1;
    end;
end;

function u1.Client_EnterStartup(p51) -- Line: 396
end;

function u1.Server_EnterStartup(p52) -- Line: 398
end;

function u1.Client_EnterAngerRoar1(p53) -- Line: 401
    -- upvalues: clientEnterRoar (copy), SkillCommon (copy)
    clientEnterRoar(p53, 1);
    local character = p53.skillInputData.character;

    if not character then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-龙大招-龙叫背景", character:GetPivot().Position);
    SkillCommon.playSoundLocal3D("音效-龙大招-火圈1", character:GetPivot().Position);
end;

function u1.Client_ExitAngerRoar1(p54) -- Line: 410
    -- upvalues: FXUtil (copy)
    local v55 = p54.skillRunData and p54.skillRunData.runEvent;
    local v56 = "龙之怒地面跟随" .. 1;

    if v55 and v55[v56] then
        v55[v56]:Disconnect();
        v55[v56] = nil;
    end;

    local v57 = p54.skillRunData and p54.skillRunData.material;

    if v57 then
        v57 = v57["龙之怒火圈"];
    end;

    if not v57 then
        return;
    end;

    FXUtil.Stop_All_Emit(v57);
end;

function u1.Server_EnterAngerRoar1(p58) -- Line: 414
    -- upvalues: serverEnterRoar (copy)
    serverEnterRoar(p58, 1);
end;

function u1.Server_ExitAngerRoar1(p59) -- Line: 418
    local v60 = p59.skillRunData and p59.skillRunData.runEvent;
    local v61 = "龙之怒命中跟随" .. 1;

    if v60 and v60[v61] then
        v60[v61]:Disconnect();
        v60[v61] = nil;
    end;

    local v62 = p59.hitbox[1];

    if v62 and v62.isActive then
        v62:stop();
    end;

    if v62 and v62.hitbox then
        v62.hitbox.Transparency = 1;
    end;
end;

function u1.Client_EnterAngerRoar2(p63) -- Line: 422
    -- upvalues: clientEnterRoar (copy), SkillCommon (copy)
    clientEnterRoar(p63, 2);
    local character = p63.skillInputData.character;

    if not character then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-龙大招-火圈2", character:GetPivot().Position);
end;

function u1.Client_ExitAngerRoar2(p64) -- Line: 429
    -- upvalues: FXUtil (copy)
    local v65 = p64.skillRunData and p64.skillRunData.runEvent;
    local v66 = "龙之怒地面跟随" .. 2;

    if v65 and v65[v66] then
        v65[v66]:Disconnect();
        v65[v66] = nil;
    end;

    local v67 = p64.skillRunData and p64.skillRunData.material;

    if v67 then
        v67 = v67["龙之怒火圈"];
    end;

    if not v67 then
        return;
    end;

    FXUtil.Stop_All_Emit(v67);
end;

function u1.Server_EnterAngerRoar2(p68) -- Line: 433
    -- upvalues: serverEnterRoar (copy)
    serverEnterRoar(p68, 2);
end;

function u1.Server_ExitAngerRoar2(p69) -- Line: 437
    local v70 = p69.skillRunData and p69.skillRunData.runEvent;
    local v71 = "龙之怒命中跟随" .. 2;

    if v70 and v70[v71] then
        v70[v71]:Disconnect();
        v70[v71] = nil;
    end;

    local v72 = p69.hitbox[2];

    if v72 and v72.isActive then
        v72:stop();
    end;

    if v72 and v72.hitbox then
        v72.hitbox.Transparency = 1;
    end;
end;

function u1.Client_EnterAngerRoar3(p73) -- Line: 441
    -- upvalues: clientEnterRoar (copy), SkillCommon (copy)
    clientEnterRoar(p73, 3);
    local character = p73.skillInputData.character;

    if not character then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-龙大招-火圈3", character:GetPivot().Position);
end;

function u1.Client_ExitAngerRoar3(p74) -- Line: 448
    -- upvalues: FXUtil (copy)
    local v75 = p74.skillRunData and p74.skillRunData.runEvent;
    local v76 = "龙之怒地面跟随" .. 3;

    if v75 and v75[v76] then
        v75[v76]:Disconnect();
        v75[v76] = nil;
    end;

    local v77 = p74.skillRunData and p74.skillRunData.material;

    if v77 then
        v77 = v77["龙之怒火圈"];
    end;

    if not v77 then
        return;
    end;

    FXUtil.Stop_All_Emit(v77);
end;

function u1.Server_EnterAngerRoar3(p78) -- Line: 452
    -- upvalues: serverEnterRoar (copy)
    serverEnterRoar(p78, 3);
end;

function u1.Server_ExitAngerRoar3(p79) -- Line: 456
    local v80 = p79.skillRunData and p79.skillRunData.runEvent;
    local v81 = "龙之怒命中跟随" .. 3;

    if v80 and v80[v81] then
        v80[v81]:Disconnect();
        v80[v81] = nil;
    end;

    local v82 = p79.hitbox[3];

    if v82 and v82.isActive then
        v82:stop();
    end;

    if v82 and v82.hitbox then
        v82.hitbox.Transparency = 1;
    end;
end;

function u1.Server_EnterRecovery(p83) -- Line: 461
    p83:releaseControl();
end;

function u1.Client_EnterRecovery(p84) -- Line: 465
    -- upvalues: FXUtil (copy)
    local v85 = p84.skillRunData and p84.skillRunData.runEvent;
    local v86 = "龙之怒地面跟随" .. 1;

    if v85 and v85[v86] then
        v85[v86]:Disconnect();
        v85[v86] = nil;
    end;

    local v87 = p84.skillRunData and p84.skillRunData.material;

    if v87 then
        v87 = v87["龙之怒火圈"];
    end;

    if v87 then
        FXUtil.Stop_All_Emit(v87);
    end;

    local v88 = p84.skillRunData and p84.skillRunData.runEvent;
    local v89 = "龙之怒地面跟随" .. 2;

    if v88 and v88[v89] then
        v88[v89]:Disconnect();
        v88[v89] = nil;
    end;

    local v90 = p84.skillRunData and p84.skillRunData.material;

    if v90 then
        v90 = v90["龙之怒火圈"];
    end;

    if v90 then
        FXUtil.Stop_All_Emit(v90);
    end;

    local v91 = p84.skillRunData and p84.skillRunData.runEvent;
    local v92 = "龙之怒地面跟随" .. 3;

    if v91 and v91[v92] then
        v91[v92]:Disconnect();
        v91[v92] = nil;
    end;

    local v93 = p84.skillRunData and p84.skillRunData.material;

    if v93 then
        v93 = v93["龙之怒火圈"];
    end;

    if not v93 then
        return;
    end;

    FXUtil.Stop_All_Emit(v93);
end;

u1.SoundList = { "音效-龙大招-火圈1", "音效-龙大招-火圈2", "音效-龙大招-火圈3", "音效-龙大招-龙叫背景" };
u1.AnimateList = { "龙之怒" };
u1.ResNameList = { "龙之怒起手", "龙之怒火圈" };
u1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用圆环",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 2,
        PartName = "通用圆环",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    }, {
        HitboxIndex = 3,
        PartName = "通用圆环",
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
        overTime = u4[1].duration + 0.9 + u4[2].duration + u4[3].duration + 0.2,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;