-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64
};
local AIM_RUN_EVENT_KEY = SkillTelegraph.AIM_RUN_EVENT_KEY;
v1.InitialState = "Startup";
v1.ControlOpenState = "Recovery";
v1.States = {
    Startup = {
        Duration = 0.57,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = "Client_ExitStartup",
        OnExitServer = nil
    },
    ShotBomb = {
        Duration = 1.5999999999999999,
        OnEnterClient = "Client_EnterShotBomb",
        OnEnterServer = "Server_EnterShotBomb",
        OnExitClient = "Client_ExitShotBomb",
        OnExitServer = "Server_ExitShotBomb"
    },
    Recovery = {
        Duration = 0.3,
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
        To = "ShotBomb",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "ShotBomb",
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
        From = "ShotBomb",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "ShotBomb",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function disconnectRunEvent(p2, p3) -- Line: 87
    local v4 = p2.skillRunData and p2.skillRunData.runEvent;

    if v4 and v4[p3] then
        v4[p3]:Disconnect();
        v4[p3] = nil;
    end;
end;

local function resolveTongueFromCharacter(p5) -- Line: 95
    return p5:FindFirstChild("舌头", true);
end;

local function getTonguePivotCF(p6) -- Line: 99
    if p6:IsA("BasePart") then
        return p6:GetPivot();
    end;

    if p6:IsA("Attachment") then
        return p6.WorldCFrame;
    end;

    if p6:IsA("Model") then
        return p6:GetPivot();
    end;

    return CFrame.new();
end;

local function resolveGroundTargetCF(p7) -- Line: 112
    -- upvalues: RayCast (copy)
    local v8 = RayCast.RayCastDirection(p7.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v8 then
        return p7.Rotation + v8.Position + Vector3.new(0, 0.5, 0);
    end;

    return p7;
end;

local function cleanupChargeVfx(p9) -- Line: 120
    -- upvalues: FXUtil (copy)
    if not p9 then
        return;
    end;

    FXUtil.Stop_All_Emit(p9);
    FXUtil.Model_Fade(p9, 0.08);
end;

local function setFireballTrailsEnabled(p10, p11) -- Line: 128
    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("Trail") then
            descendant.Enabled = p11;
        end;
    end;
end;

local function fadeFireballVfx(p12) -- Line: 136
    -- upvalues: FXUtil (copy), setFireballTrailsEnabled (copy)
    FXUtil.Stop_All_Emit(p12);
    setFireballTrailsEnabled(p12, false);

    for _, descendant in p12:GetDescendants() do
        if descendant:IsA("Beam") then
            FXUtil.Beam_Fade_To_Transparent_Then_Disable(descendant, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;
    end;

    FXUtil.SetAllBasePartsTransparency(p12, 1);
    FXUtil.Model_Fade(p12, 0.1);
end;

local function prepareFireballMesh(p13) -- Line: 148
    -- upvalues: FXUtil (copy)
    FXUtil.SetAllBasePartsTransparency(p13, 0);

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("Beam") then
            descendant.Enabled = true;
            FXUtil.Beam_Fade_From_Transparent(descendant, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;
    end;

    FXUtil.Start_All_Trail(p13);
end;

local function getSkillScale(p14) -- Line: 160
    -- upvalues: SkillCommon (copy)
    return SkillCommon.npcSummonBodySkillScale(p14);
end;

local function getVfxScale(p15) -- Line: 170
    -- upvalues: SkillCommon (copy)
    return SkillCommon.npcSummonBodySkillScale(p15) * 2;
end;

local function getHitboxExplosionSize(p16) -- Line: 180
    -- upvalues: SkillCommon (copy)
    return Vector3.new(30, 30, 30) * SkillCommon.npcSummonBodySkillScale(p16) * 0.5;
end;

local function lockGroundTargetCF(p17) -- Line: 190
    -- upvalues: RayCast (copy)
    local skillRunData = p17.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v18 = p17:getTargetCF();
    local v19 = RayCast.RayCastDirection(v18.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v19 then
        v18 = v18.Rotation + v19.Position + Vector3.new(0, 0.5, 0);
    end;

    skillRunData.Logic.lockedGroundCF = v18;

    return v18;
end;

local function getLockedGroundTargetCF(p20) -- Line: 204
    -- upvalues: RayCast (copy)
    local skillRunData = p20.skillRunData;
    local v21 = skillRunData and skillRunData.Logic and skillRunData.Logic.lockedGroundCF;

    if typeof(v21) == "CFrame" then
        return v21;
    end;

    local skillRunData2 = p20.skillRunData;
    skillRunData2.Logic = skillRunData2.Logic or {};
    local v22 = p20:getTargetCF();
    local v23 = RayCast.RayCastDirection(v22.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v23 then
        v22 = v22.Rotation + v23.Position + Vector3.new(0, 0.5, 0);
    end;

    skillRunData2.Logic.lockedGroundCF = v22;

    return v22;
end;

local function stopTelegraphAimLoop(p24) -- Line: 218
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    if not (p24 and p24.runEvent) then
        return;
    end;

    local v25 = p24.runEvent[AIM_RUN_EVENT_KEY];

    if v25 then
        v25:Disconnect();
        p24.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;
end;

local function destroyDangerTelegraph(p26) -- Line: 234
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local v27 = p26 and p26.runEvent and p26.runEvent[AIM_RUN_EVENT_KEY];

    if v27 then
        v27:Disconnect();
        p26.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    if not (p26 and p26.Logic) then
        return;
    end;

    local dangerTelegraph = p26.Logic.dangerTelegraph;

    if dangerTelegraph then
        dangerTelegraph:destroy();
        p26.Logic.dangerTelegraph = nil;
    end;
end;

function v1.Client_EnterStartup(p28) -- Line: 247
    -- upvalues: AIM_RUN_EVENT_KEY (copy), RayCast (copy), SkillTelegraph (copy), SkillCommon (copy), getTonguePivotCF (copy), FXUtil (copy), RunService (copy)
    local character = p28.skillInputData.character;

    if not character then
        return;
    end;

    local skillRunData = p28.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v29 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v29 then
        v29:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    local v30 = skillRunData and skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if v30 then
        v30:destroy();
        skillRunData.Logic.dangerTelegraph = nil;
    end;

    local skillRunData2 = p28.skillRunData;
    skillRunData2.Logic = skillRunData2.Logic or {};
    local v31 = p28:getTargetCF();
    local v32 = RayCast.RayCastDirection(v31.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v32 then
        v31 = v31.Rotation + v32.Position + Vector3.new(0, 0.5, 0);
    end;

    skillRunData2.Logic.lockedGroundCF = v31;
    local v33 = SkillTelegraph.new({
        shape = "Circle",
        warnDuration = 0.77,
        worldCFrame = v31,
        hitboxSize = Vector3.new(30, 30, 30) * SkillCommon.npcSummonBodySkillScale(p28) * 0.5,
        casterCharacter = character,
        characterType = p28.characterType
    });
    skillRunData.Logic.dangerTelegraph = v33;
    v33:update({
        lockPosition = true,
        worldCFrame = v31,
        hitboxSize = Vector3.new(30, 30, 30) * SkillCommon.npcSummonBodySkillScale(p28) * 0.5
    });
    local u34 = character:FindFirstChild("舌头", true);

    if not u34 then
        return;
    end;

    local u35 = skillRunData.material["龙炎弹蓄力-冰"];

    if not u35 then
        return;
    end;

    local v36 = getTonguePivotCF(u34);
    u35:ScaleTo(SkillCommon.npcSummonBodySkillScale(p28) * 2);
    u35:PivotTo(v36);
    u35.Parent = workspace.Debris;
    FXUtil.Start_All_Emit(u35, 10);
    SkillCommon.playSoundLocal3D("音效-龙喷火球-蓄力", v36.Position);
    skillRunData.runEvent["龙炎弹蓄力-冰跟随"] = RunService.Heartbeat:Connect(function() -- Line: 292
        -- upvalues: u34 (copy), u35 (copy), getTonguePivotCF (ref)
        if u34.Parent and u35.Parent then
            u35:PivotTo(getTonguePivotCF(u34));
        end;
    end);
end;

function v1.Client_ExitStartup(p37) -- Line: 299
    -- upvalues: FXUtil (copy)
    local v38 = p37.skillRunData and p37.skillRunData.runEvent;

    if v38 and v38["龙炎弹蓄力-冰跟随"] then
        v38["龙炎弹蓄力-冰跟随"]:Disconnect();
        v38["龙炎弹蓄力-冰跟随"] = nil;
    end;

    local skillRunData = p37.skillRunData;

    if skillRunData and skillRunData.material then
        local v39 = skillRunData.material["龙炎弹蓄力-冰"];

        if not v39 then
            return;
        end;

        FXUtil.Stop_All_Emit(v39);
        FXUtil.Model_Fade(v39, 0.08);
    end;
end;

function v1.Server_EnterStartup(p40) -- Line: 307
    -- upvalues: RayCast (copy), SkillCommon (copy)
    local skillRunData = p40.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    local v41 = p40:getTargetCF();
    local v42 = RayCast.RayCastDirection(v41.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v42 then
        v41 = v41.Rotation + v42.Position + Vector3.new(0, 0.5, 0);
    end;

    skillRunData.Logic.lockedGroundCF = v41;
    local v43 = p40.hitbox[1];

    if v43 and v43.hitbox then
        v43.hitbox.Size = Vector3.new(30, 30, 30) * SkillCommon.npcSummonBodySkillScale(p40) * 0.5;
    end;
end;

function v1.Client_EnterShotBomb(u44) -- Line: 317
    -- upvalues: SkillCommon (copy), getTonguePivotCF (copy), FXUtil (copy), RayCast (copy), prepareFireballMesh (copy), RunService (copy), fadeFireballVfx (copy)
    local character = u44.skillInputData.character;

    if not character then
        return;
    end;

    local v45 = character:FindFirstChild("舌头", true);

    if not v45 then
        return;
    end;

    local skillRunData = u44.skillRunData;
    local material = skillRunData.material;
    local v46 = SkillCommon.npcSummonBodySkillScale(u44) * 2;
    local v47 = Vector3.new(30, 30, 30) * SkillCommon.npcSummonBodySkillScale(u44) * 0.5;
    local v48 = getTonguePivotCF(v45);
    local v49 = material["龙炎弹出现-冰"];

    if v49 then
        v49:ScaleTo(v46);
        v49:PivotTo(v48);
        v49.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v49, true);
    end;

    local skillRunData2 = u44.skillRunData;
    local v50 = skillRunData2 and skillRunData2.Logic and skillRunData2.Logic.lockedGroundCF;

    if typeof(v50) ~= "CFrame" then
        local skillRunData3 = u44.skillRunData;
        skillRunData3.Logic = skillRunData3.Logic or {};
        v50 = u44:getTargetCF();
        local v51 = RayCast.RayCastDirection(v50.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

        if v51 then
            v50 = v50.Rotation + v51.Position + Vector3.new(0, 0.5, 0);
        end;

        skillRunData3.Logic.lockedGroundCF = v50;
    end;

    local Position = v50.Position;
    local Position2 = v48.Position;
    local u52 = skillRunData.Logic and skillRunData.Logic.dangerTelegraph;

    if u52 then
        u52:update({
            lockPosition = true,
            worldCFrame = CFrame.new(Position),
            hitboxSize = v47
        });
    end;

    local u53 = material["龙炎弹火球-冰"];
    local u54 = material["龙炎弹爆炸-冰"];

    if not u53 then
        return;
    end;

    u53:ScaleTo(v46);
    u53:PivotTo(CFrame.lookAt(Position2, Position));
    u53.Parent = workspace.Debris;
    prepareFireballMesh(u53);
    FXUtil.Start_All_Emit(u53, 10);

    if u54 then
        u54:ScaleTo(v46);
        u54:PivotTo(CFrame.new(Position));
        u54.Parent = workspace.Debris;
    end;

    SkillCommon.playSoundLocal3D("音效-龙喷火球-喷出", v48.Position);
    local u55 = 0;
    local u56 = false;
    skillRunData.runEvent["龙炎弹火球-冰移动"] = RunService.Heartbeat:Connect(function(p57) -- Line: 377
        -- upvalues: u55 (ref), Position2 (copy), Position (copy), u53 (copy), u56 (ref), fadeFireballVfx (ref), u54 (copy), FXUtil (ref), SkillCommon (ref), u52 (copy), u44 (copy)
        u55 = u55 + p57;
        local v58 = math.clamp(u55 / 0.2, 0, 1);
        local v59 = Position2:Lerp(Position, v58);
        u53:PivotTo(CFrame.lookAt(v59, Position));

        if v58 >= 1 and not u56 then
            u56 = true;
            fadeFireballVfx(u53);

            if u54 then
                u54:PivotTo(CFrame.new(Position));
                FXUtil.Emit_Particles_GetDescendants(u54, true);
            end;

            SkillCommon.playSoundLocal3D("音效-龙喷火球-击中", Position);

            if u52 then
                u52:activate(0.2);
            end;

            local v60 = u44;
            local v61 = v60.skillRunData and v60.skillRunData.runEvent;

            if v61 and v61["龙炎弹火球-冰移动"] then
                v61["龙炎弹火球-冰移动"]:Disconnect();
                v61["龙炎弹火球-冰移动"] = nil;
            end;
        end;
    end);
end;

function v1.Client_ExitShotBomb(p62) -- Line: 399
    -- upvalues: setFireballTrailsEnabled (copy)
    local v63 = p62.skillRunData and p62.skillRunData.runEvent;

    if v63 and v63["龙炎弹火球-冰移动"] then
        v63["龙炎弹火球-冰移动"]:Disconnect();
        v63["龙炎弹火球-冰移动"] = nil;
    end;

    local v64 = p62.skillRunData and p62.skillRunData.material and p62.skillRunData.material["龙炎弹火球-冰"];

    if v64 then
        setFireballTrailsEnabled(v64, false);
    end;
end;

function v1.Server_EnterShotBomb(u65) -- Line: 407
    -- upvalues: SkillCommon (copy), RayCast (copy), RunService (copy)
    local u66 = u65.hitbox[1];

    if not (u66 and u66.hitbox) then
        return;
    end;

    if not u65.skillInputData.character then
        return;
    end;

    local v67 = Vector3.new(30, 30, 30) * SkillCommon.npcSummonBodySkillScale(u65) * 0.5;
    local skillRunData = u65.skillRunData;
    local v68 = skillRunData and skillRunData.Logic and skillRunData.Logic.lockedGroundCF;

    if typeof(v68) ~= "CFrame" then
        local skillRunData2 = u65.skillRunData;
        skillRunData2.Logic = skillRunData2.Logic or {};
        v68 = u65:getTargetCF();
        local v69 = RayCast.RayCastDirection(v68.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

        if v69 then
            v68 = v68.Rotation + v69.Position + Vector3.new(0, 0.5, 0);
        end;

        skillRunData2.Logic.lockedGroundCF = v68;
    end;

    u66.hitbox.Size = v67;
    u66.hitbox:PivotTo(v68);
    local u70 = 0;
    local u71 = false;
    u65.skillRunData.runEvent["龙炎弹命中检测"] = RunService.Heartbeat:Connect(function(p72) -- Line: 426
        -- upvalues: u70 (ref), u71 (ref), u66 (copy), u65 (copy)
        u70 = u70 + p72;

        if u70 >= 0.15000000000000002 and not u71 then
            u71 = true;
            u66:start();
        end;

        if u70 >= 0.35 then
            if u66.isActive then
                u66:stop();
            end;

            local v73 = u65;
            local v74 = v73.skillRunData and v73.skillRunData.runEvent;

            if v74 and v74["龙炎弹命中检测"] then
                v74["龙炎弹命中检测"]:Disconnect();
                v74["龙炎弹命中检测"] = nil;
            end;
        end;
    end);
end;

function v1.Server_ExitShotBomb(p75) -- Line: 441
    local v76 = p75.skillRunData and p75.skillRunData.runEvent;

    if v76 and v76["龙炎弹命中检测"] then
        v76["龙炎弹命中检测"]:Disconnect();
        v76["龙炎弹命中检测"] = nil;
    end;

    local v77 = p75.hitbox[1];

    if v77 and v77.isActive then
        v77:stop();
    end;
end;

function v1.Server_EnterRecovery(p78) -- Line: 450
end;

function v1.Client_EnterRecovery(p79) -- Line: 454
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local v80 = p79.skillRunData and p79.skillRunData.runEvent;

    if v80 and v80["龙炎弹蓄力-冰跟随"] then
        v80["龙炎弹蓄力-冰跟随"]:Disconnect();
        v80["龙炎弹蓄力-冰跟随"] = nil;
    end;

    local v81 = p79.skillRunData and p79.skillRunData.runEvent;

    if v81 and v81["龙炎弹火球-冰移动"] then
        v81["龙炎弹火球-冰移动"]:Disconnect();
        v81["龙炎弹火球-冰移动"] = nil;
    end;

    local skillRunData = p79.skillRunData;
    local v82 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v82 then
        v82:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    if skillRunData then
        if not skillRunData.Logic then
            return;
        end;

        local dangerTelegraph = skillRunData.Logic.dangerTelegraph;

        if dangerTelegraph then
            dangerTelegraph:destroy();
            skillRunData.Logic.dangerTelegraph = nil;
        end;
    end;
end;

v1.SoundList = { "音效-龙喷火球-击中", "音效-龙喷火球-喷出", "音效-龙喷火球-蓄力" };
v1.AnimateList = { "龙炎弹" };
v1.ResNameList = { "龙炎弹出现-冰", "龙炎弹火球-冰", "龙炎弹爆炸-冰", "龙炎弹蓄力-冰" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 2.47,
        animationName = "龙炎弹",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;