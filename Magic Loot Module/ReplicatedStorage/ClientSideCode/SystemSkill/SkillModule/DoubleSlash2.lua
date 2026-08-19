-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local VisibleMgr = UtilsSystem.VisibleMgr;
local RunService = UtilsSystem.RunService;
local TweenService = UtilsSystem.TweenService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "Swing1",
    States = {
        Startup = {
            Duration = 0.7,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        Swing1 = {
            Duration = 0.8,
            OnEnterClient = "Client_EnterSwing1",
            OnEnterServer = "Server_EnterSwing1",
            OnExitClient = nil,
            OnExitServer = "Server_ExitSwing1"
        },
        Swing2 = {
            Duration = 1.3,
            OnEnterClient = "Client_EnterSwing2",
            OnEnterServer = "Server_EnterSwing2",
            OnExitClient = nil,
            OnExitServer = "Server_ExitSwing2"
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
            IsTerminal = true,
            OnEnterClient = "Client_EnterInterrupted"
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "Swing1",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Swing1",
            To = "Swing2",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Swing2",
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        }
    }
};

for _, v in { "Startup", "Swing1", "Swing2", "Recovery" } do
    table.insert(v1.Transitions, {
        To = "Interrupted",
        From = v,
        Event = SkillEventConst.Interrupt
    });
    table.insert(v1.Transitions, {
        To = "Finished",
        From = v,
        Event = SkillEventConst.ForceFinish
    });
end;

local function get_skillScale(p2) -- Line: 108
    -- upvalues: SkillCommon (copy)
    local v3 = p2.skillInputData and p2.skillInputData.character;

    return (v3 and v3:GetScale() or 1) * SkillCommon.scaleBandFromData(p2, SkillCommon.bandScaleOptsFromSkillData(p2));
end;

local function stopTelegraphAimLoop(p4) -- Line: 120
    if not (p4 and p4.runEvent) then
        return;
    end;

    local damageTelegraphAim = p4.runEvent.damageTelegraphAim;

    if damageTelegraphAim then
        damageTelegraphAim:Disconnect();
        p4.runEvent.damageTelegraphAim = nil;
    end;
end;

local function destroyDangerTelegraphs(p5) -- Line: 136
    local v6 = p5 and p5.runEvent and p5.runEvent.damageTelegraphAim;

    if v6 then
        v6:Disconnect();
        p5.runEvent.damageTelegraphAim = nil;
    end;

    if not (p5 and p5.Logic) then
        return;
    end;

    local dangerTelegraphs = p5.Logic.dangerTelegraphs;

    if not dangerTelegraphs then
        return;
    end;

    for i, v in dangerTelegraphs do
        if v then
            v:destroy();
        end;

        dangerTelegraphs[i] = nil;
    end;

    p5.Logic.dangerTelegraphs = nil;
end;

local function resolveSwingHitboxCF(p7) -- Line: 160
    -- upvalues: SkillCommon (copy)
    local v8 = p7.skillInputData and p7.skillInputData.character;

    if not v8 then
        return nil;
    end;

    local HumanoidRootPart = v8:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local v9 = HumanoidRootPart:GetPivot();
    local v10 = p7.skillInputData and p7.skillInputData.character;

    return v9:ToWorldSpace(CFrame.new(0, 0, (v10 and v10:GetScale() or 1) * SkillCommon.scaleBandFromData(p7, SkillCommon.bandScaleOptsFromSkillData(p7)) * -1));
end;

local function resolveSwingHitboxSize(p11) -- Line: 178
    -- upvalues: SkillCommon (copy)
    local v12 = p11.skillInputData and p11.skillInputData.character;

    return Vector3.new(13, 13, 13) * ((v12 and v12:GetScale() or 1) * SkillCommon.scaleBandFromData(p11, SkillCommon.bandScaleOptsFromSkillData(p11)));
end;

local function startTelegraphAimLoop(u13, u14, u15) -- Line: 189
    -- upvalues: RunService (copy), SkillCommon (copy), resolveSwingHitboxCF (copy)
    local v16 = u14 and u14.runEvent and u14.runEvent.damageTelegraphAim;

    if v16 then
        v16:Disconnect();
        u14.runEvent.damageTelegraphAim = nil;
    end;

    u14.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 191
        -- upvalues: SkillCommon (ref), u13 (copy), u15 (copy), u14 (copy), resolveSwingHitboxCF (ref)
        if not SkillCommon.isRunningSameGeneration(u13, u15) then
            local v17 = u14;

            if v17 then
                if not v17.runEvent then
                    return;
                end;

                local damageTelegraphAim = v17.runEvent.damageTelegraphAim;

                if damageTelegraphAim then
                    damageTelegraphAim:Disconnect();
                    v17.runEvent.damageTelegraphAim = nil;
                end;
            end;

            return;
        end;

        local v18 = u14.Logic and u14.Logic.dangerTelegraphs;

        if not v18 then
            return;
        end;

        local v19 = resolveSwingHitboxCF(u13);

        if not v19 then
            return;
        end;

        local v20 = u13;
        local v21 = v20.skillInputData and v20.skillInputData.character;
        local v22 = Vector3.new(13, 13, 13) * ((v21 and v21:GetScale() or 1) * SkillCommon.scaleBandFromData(v20, SkillCommon.bandScaleOptsFromSkillData(v20)));

        for _, v in v18 do
            if v then
                v:update({
                    worldCFrame = v19,
                    hitboxSize = v22
                });
            end;
        end;
    end);
end;

local function orientationToLocalCF(p23, p24) -- Line: 216
    return CFrame.new(p23) * CFrame.Angles(math.rad(p24.X), math.rad(p24.Y), (math.rad(p24.Z)));
end;

local function playBladeRotateControl(p25, p26, p27) -- Line: 221
    -- upvalues: TweenService (copy)
    local Main = p25:FindFirstChild("Main");

    if not Main then
        return;
    end;

    local Rotate = Main:FindFirstChild("Rotate");

    if not (Rotate and Rotate:IsA("Attachment")) then
        return;
    end;

    local Position = Rotate.CFrame.Position;
    Rotate.CFrame = CFrame.new(Position) * CFrame.Angles(0, -2.9670597283903604, 0);

    for _, child in Rotate:GetChildren() do
        if child:IsA("Beam") then
            child.Enabled = true;
        end;
    end;

    local v28 = CFrame.new(Position) * CFrame.Angles(0, 0, 0);
    local v29 = TweenService:Create(Rotate, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = v28
    });
    p27.skillRunData.runEvent[p26] = v29;
    v29:Play();
end;

local function playSwingClient(p30, p31, p32, p33) -- Line: 251
    -- upvalues: SkillCommon (copy), VisibleMgr (copy), FXUtil (copy), playBladeRotateControl (copy), SoundModule (copy), RunService (copy)
    local character = p30.skillInputData.character;

    if not character then
        return;
    end;

    local u34 = p30.skillRunData.material[p33];
    local v35 = p30.skillInputData and p30.skillInputData.character;
    local v36 = (v35 and v35:GetScale() or 1) * SkillCommon.scaleBandFromData(p30, SkillCommon.bandScaleOptsFromSkillData(p30));
    VisibleMgr.UnQueryAll(u34);
    u34:ScaleTo(v36);
    u34.Parent = workspace.Debris;
    u34:PivotTo(character:GetPivot());
    FXUtil.Emit_Particles_GetDescendants(u34, true);
    playBladeRotateControl(u34, p32, p30);

    if p31 == "刀光跟随1" then
        SoundModule:PlaySoundLocal({
            SoundName = "音效-幽灵船长-二连斩1",
            Is2D = false,
            PlayPosition = character:GetPivot().Position
        });
    else
        SoundModule:PlaySoundLocal({
            SoundName = "音效-幽灵船长-二连斩2",
            Is2D = false,
            PlayPosition = character:GetPivot().Position
        });
    end;

    p30.skillRunData.runEvent[p31] = RunService.Heartbeat:Connect(function() -- Line: 280
        -- upvalues: u34 (copy), character (copy)
        if u34 and character then
            u34:PivotTo(character:GetPivot());
        end;
    end);
end;

local function startSwingServer(u37, p38, p39) -- Line: 288
    -- upvalues: RunService (copy), SkillCommon (copy)
    local u40 = u37.hitbox[p39];

    if not u40 then
        return;
    end;

    u40:start();
    local character = u37.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    u37.skillRunData.runEvent[p38] = RunService.Heartbeat:Connect(function() -- Line: 304
        -- upvalues: HumanoidRootPart (copy), u40 (copy), u37 (copy), SkillCommon (ref)
        if HumanoidRootPart and HumanoidRootPart.Parent then
            local hitbox = u40.hitbox;
            local v41 = HumanoidRootPart:GetPivot();
            local v42 = u37;
            local v43 = v42.skillInputData and v42.skillInputData.character;
            hitbox:PivotTo(v41:ToWorldSpace(CFrame.new(0, 0, (v43 and v43:GetScale() or 1) * SkillCommon.scaleBandFromData(v42, SkillCommon.bandScaleOptsFromSkillData(v42)) * -1)));
        end;
    end);
end;

local function stopSwingServer(p44, p45, p46) -- Line: 311
    local v47 = p44.hitbox[p46];

    if v47 and v47.isActive then
        v47:stop();
    end;

    if p44.skillRunData.runEvent[p45] then
        p44.skillRunData.runEvent[p45]:Disconnect();
        p44.skillRunData.runEvent[p45] = nil;
    end;
end;

function v1.Client_EnterStartup(u48) -- Line: 323
    -- upvalues: destroyDangerTelegraphs (copy), resolveSwingHitboxCF (copy), SkillTelegraph (copy), SkillCommon (copy), RunService (copy)
    local skillRunData = u48.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    destroyDangerTelegraphs(skillRunData);
    local v49 = resolveSwingHitboxCF(u48);

    if not v49 then
        return;
    end;

    local Logic = skillRunData.Logic;
    local v50 = {};
    local new = SkillTelegraph.new;
    local v51 = {
        shape = "Circle",
        warnDuration = 0.7,
        worldCFrame = v49
    };
    local v52 = u48.skillInputData and u48.skillInputData.character;
    v51.hitboxSize = Vector3.new(13, 13, 13) * ((v52 and v52:GetScale() or 1) * SkillCommon.scaleBandFromData(u48, SkillCommon.bandScaleOptsFromSkillData(u48)));
    v51.casterCharacter = u48.skillInputData and u48.skillInputData.character;
    v51.characterType = u48.characterType;
    v50[1] = new(v51);
    Logic.dangerTelegraphs = v50;
    local runGeneration = u48.runGeneration;
    local v53 = skillRunData and skillRunData.runEvent and skillRunData.runEvent.damageTelegraphAim;

    if v53 then
        v53:Disconnect();
        skillRunData.runEvent.damageTelegraphAim = nil;
    end;

    skillRunData.runEvent.damageTelegraphAim = RunService.Heartbeat:Connect(function() -- Line: 191
        -- upvalues: SkillCommon (ref), u48 (copy), runGeneration (copy), skillRunData (copy), resolveSwingHitboxCF (ref)
        if not SkillCommon.isRunningSameGeneration(u48, runGeneration) then
            local v54 = skillRunData;

            if v54 then
                if not v54.runEvent then
                    return;
                end;

                local damageTelegraphAim = v54.runEvent.damageTelegraphAim;

                if damageTelegraphAim then
                    damageTelegraphAim:Disconnect();
                    v54.runEvent.damageTelegraphAim = nil;
                end;
            end;

            return;
        end;

        local v55 = skillRunData.Logic and skillRunData.Logic.dangerTelegraphs;

        if not v55 then
            return;
        end;

        local v56 = resolveSwingHitboxCF(u48);

        if not v56 then
            return;
        end;

        local v57 = u48;
        local v58 = v57.skillInputData and v57.skillInputData.character;
        local v59 = Vector3.new(13, 13, 13) * ((v58 and v58:GetScale() or 1) * SkillCommon.scaleBandFromData(v57, SkillCommon.bandScaleOptsFromSkillData(v57)));

        for _, v in v55 do
            if v then
                v:update({
                    worldCFrame = v56,
                    hitboxSize = v59
                });
            end;
        end;
    end);
end;

function v1.Server_EnterStartup(p60) -- Line: 346
    -- upvalues: SkillCommon (copy)
    local v61 = p60.skillInputData and p60.skillInputData.character;
    local v62 = (v61 and v61:GetScale() or 1) * SkillCommon.scaleBandFromData(p60, SkillCommon.bandScaleOptsFromSkillData(p60));

    for _, v in p60.hitbox do
        if v and v.hitbox then
            v.hitbox.Size = Vector3.new(13, 13, 13) * v62;
        end;
    end;
end;

function v1.Client_EnterSwing1(p63) -- Line: 357
    -- upvalues: playSwingClient (copy), resolveSwingHitboxCF (copy), SkillTelegraph (copy), SkillCommon (copy)
    playSwingClient(p63, "刀光跟随1", "刀光旋转1", "幽灵船长刀光1");
    local skillRunData = p63.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local dangerTelegraphs = skillRunData.Logic.dangerTelegraphs;

    if dangerTelegraphs and dangerTelegraphs[1] then
        dangerTelegraphs[1]:activate(0.8);
    end;

    local v64 = resolveSwingHitboxCF(p63);

    if v64 then
        skillRunData.Logic.dangerTelegraphs = dangerTelegraphs or {};
        local dangerTelegraphs2 = skillRunData.Logic.dangerTelegraphs;
        local new = SkillTelegraph.new;
        local v65 = {
            shape = "Circle",
            warnDuration = 0.8,
            worldCFrame = v64
        };
        local v66 = p63.skillInputData and p63.skillInputData.character;
        v65.hitboxSize = Vector3.new(13, 13, 13) * ((v66 and v66:GetScale() or 1) * SkillCommon.scaleBandFromData(p63, SkillCommon.bandScaleOptsFromSkillData(p63)));
        v65.casterCharacter = p63.skillInputData and p63.skillInputData.character;
        v65.characterType = p63.characterType;
        dangerTelegraphs2[2] = new(v65);
    end;
end;

function v1.Server_EnterSwing1(p67) -- Line: 381
    -- upvalues: startSwingServer (copy)
    startSwingServer(p67, "命中盒控制1", 1);
end;

function v1.Server_ExitSwing1(p68) -- Line: 385
    local v69 = p68.hitbox[1];

    if v69 and v69.isActive then
        v69:stop();
    end;

    if p68.skillRunData.runEvent["命中盒控制1"] then
        p68.skillRunData.runEvent["命中盒控制1"]:Disconnect();
        p68.skillRunData.runEvent["命中盒控制1"] = nil;
    end;
end;

function v1.Client_EnterSwing2(p70) -- Line: 390
    -- upvalues: playSwingClient (copy)
    playSwingClient(p70, "刀光跟随2", "刀光旋转2", "幽灵船长刀光2");
    local skillRunData = p70.skillRunData;
    local v71 = skillRunData.Logic and skillRunData.Logic.dangerTelegraphs;

    if v71 and v71[2] then
        v71[2]:activate(1.3);
    end;
end;

function v1.Server_EnterSwing2(p72) -- Line: 400
    -- upvalues: startSwingServer (copy)
    startSwingServer(p72, "命中盒控制2", 2);
end;

function v1.Server_ExitSwing2(p73) -- Line: 404
    local v74 = p73.hitbox[2];

    if v74 and v74.isActive then
        v74:stop();
    end;

    if p73.skillRunData.runEvent["命中盒控制2"] then
        p73.skillRunData.runEvent["命中盒控制2"]:Disconnect();
        p73.skillRunData.runEvent["命中盒控制2"] = nil;
    end;
end;

function v1.Server_EnterRecovery(p75) -- Line: 409
    p75:releaseControl();
end;

function v1.Client_EnterRecovery(p76) -- Line: 413
    -- upvalues: destroyDangerTelegraphs (copy)
    destroyDangerTelegraphs(p76.skillRunData);
end;

function v1.Client_EnterInterrupted(p77) -- Line: 417
    -- upvalues: destroyDangerTelegraphs (copy)
    destroyDangerTelegraphs(p77.skillRunData);
end;

v1.SoundList = { "音效-幽灵船长-二连斩1", "音效-幽灵船长-二连斩2" };
v1.AnimateList = { "二连斩" };
v1.ResNameList = { "幽灵船长刀光1", "幽灵船长刀光2" };
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
        overTime = 3,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 3,
        animationName = "二连斩",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v1;