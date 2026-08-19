-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RayCast = UtilsSystem.RayCast;
local RunService = UtilsSystem.RunService;
local v1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Fire,
    skillDistanceLimit = 64
};
local u2 = CFrame.new(0, 0, 0);
local u3 = CFrame.Angles(0, 0, 0);
v1.InitialState = "Startup";
v1.ControlOpenState = "Recovery";
v1.States = {
    Startup = {
        Duration = 0.85,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    FlyFire = {
        Duration = 3.05,
        OnEnterClient = "Client_EnterFlyFire",
        OnEnterServer = "Server_EnterFlyFire",
        OnExitClient = "Client_ExitFlyFire",
        OnExitServer = "Server_ExitFlyFire"
    },
    Recovery = {
        Duration = 0.5,
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
        To = "FlyFire",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "FlyFire",
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
        From = "FlyFire",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "FlyFire",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function disconnectRunEvent(p4, p5) -- Line: 91
    local v6 = p4.skillRunData and p4.skillRunData.runEvent;

    if v6 and v6[p5] then
        v6[p5]:Disconnect();
        v6[p5] = nil;
    end;
end;

local function getSkillScale(p7) -- Line: 99
    -- upvalues: SkillCommon (copy)
    return SkillCommon.npcSummonBodySkillScale(p7);
end;

local function resolveHeadFromCharacter(p8) -- Line: 103
    return p8:FindFirstChild("舌头", true);
end;

local function getHeadRawPivotCF(p9) -- Line: 107
    if p9:IsA("BasePart") then
        return p9:GetPivot();
    end;

    if p9:IsA("Attachment") then
        return p9.WorldCFrame;
    end;

    if p9:IsA("Model") then
        return p9:GetPivot();
    end;

    return CFrame.new();
end;

local function getHeadPivotCF(p10) -- Line: 120
    -- upvalues: getHeadRawPivotCF (copy), u2 (copy)
    return getHeadRawPivotCF(p10):ToWorldSpace(u2);
end;

local function castRayEndFromDirection(p11, p12) -- Line: 124
    -- upvalues: RayCast (copy)
    local v13 = p12.Magnitude < 0.001 and Vector3.new(0, 0, -1) or p12;
    local v14 = RayCast.RayCastDirection(p11, v13, 50, "Ground");

    if v14 then
        return v14.Position;
    end;

    return p11 + v13.Unit * 50;
end;

local function computeBreathLayout(p15, p16) -- Line: 136
    -- upvalues: RayCast (copy)
    local Position = p15.Position;
    local Position2 = p16.Position;
    local LookVector = p16.LookVector;

    if LookVector.Magnitude < 0.001 then
        LookVector = p16.RightVector;
    end;

    local v17 = LookVector.Magnitude < 0.001 and Vector3.new(0, 0, -1) or LookVector;
    local v18 = RayCast.RayCastDirection(Position2, v17, 50, "Ground");
    local v19;

    if v18 then
        v19 = v18.Position;
    else
        v19 = Position2 + v17.Unit * 50;
    end;

    return Position, v19, CFrame.new(v19) * CFrame.new(0, 0, 0).Rotation;
end;

local function computeHitboxRayEnd(p20) -- Line: 151
    -- upvalues: u3 (copy), RayCast (copy)
    local Position = p20.Position;
    local v21 = p20:ToWorldSpace(u3);
    local LookVector = v21.LookVector;

    if LookVector.Magnitude < 0.001 then
        LookVector = v21.RightVector;
    end;

    local v22 = LookVector.Magnitude < 0.001 and Vector3.new(0, 0, -1) or LookVector;
    local v23 = RayCast.RayCastDirection(Position, v22, 50, "Ground");

    if v23 then
        return v23.Position;
    end;

    return Position + v22.Unit * 50;
end;

local function resolveSprayCF(p24, p25) -- Line: 161
    if not (p25 and p25:IsA("Model")) then
        return p24;
    end;

    p25:PivotTo(p24);

    return p25:GetPivot();
end;

local function placeBoxHitbox(p26, p27, p28, p29, p30) -- Line: 173
    local Magnitude = (p27 - p28).Magnitude;
    local v31 = Magnitude < 0.001 and 0.5 or math.max(Magnitude, 0.5);
    p26.Size = Vector3.new(p29.X, p29.Y, v31) * p30;
    p26:PivotTo(CFrame.new(p27, p28).Rotation + (p27 + p28) * 0.5);
    p26.Transparency = 1;
end;

local function syncBreathHitboxes(p32, p33, p34, p35) -- Line: 188
    -- upvalues: getHeadRawPivotCF (copy), u2 (copy), u3 (copy), RayCast (copy)
    if not p33.Parent then
        return;
    end;

    local v36 = getHeadRawPivotCF(p33):ToWorldSpace(u2);
    local v37;

    if p34 and p34:IsA("Model") then
        p34:PivotTo(v36);
        v37 = p34:GetPivot();
    else
        v37 = v36;
    end;

    local Position = v36.Position;
    local Position2 = v37.Position;
    local v38 = v37:ToWorldSpace(u3);
    local LookVector = v38.LookVector;

    if LookVector.Magnitude < 0.001 then
        LookVector = v38.RightVector;
    end;

    local v39 = LookVector.Magnitude < 0.001 and Vector3.new(0, 0, -1) or LookVector;
    local v40 = RayCast.RayCastDirection(Position2, v39, 50, "Ground");
    local v41;

    if v40 then
        v41 = v40.Position;
    else
        v41 = Position2 + v39.Unit * 50;
    end;

    local v42 = p32.hitbox[1];

    if v42 and v42.hitbox then
        local hitbox = v42.hitbox;
        local Magnitude = (Position - v41).Magnitude;
        local v43 = Magnitude < 0.001 and 0.5 or math.max(Magnitude, 0.5);
        hitbox.Size = Vector3.new(9, 10, v43) * p35;
        hitbox:PivotTo(CFrame.new(Position, v41).Rotation + (Position + v41) * 0.5);
        hitbox.Transparency = 1;
    end;
end;

local function cleanupBreathVfx(p44, p45) -- Line: 203
    -- upvalues: FXUtil (copy)
    if p44 then
        FXUtil.Stop_All_Emit(p44);
        FXUtil.Model_Fade(p44, 0.12);
    end;

    if p45 then
        FXUtil.Stop_All_Emit(p45);
        FXUtil.Model_Fade(p45, 0.12);
    end;
end;

function v1.Client_EnterStartup(p46) -- Line: 215
    -- upvalues: SkillCommon (copy)
    local character = p46.skillInputData.character;

    if not character then
        return;
    end;

    SkillCommon.playSoundLocal3D("音效-龙叫", character:GetPivot().Position);
end;

function v1.Server_EnterStartup(p47) -- Line: 223
    -- upvalues: SkillCommon (copy)
    local v48 = p47.hitbox[1];

    if v48 and v48.hitbox then
        local v49 = SkillCommon.npcSummonBodySkillScale(p47);
        v48.hitbox.Size = Vector3.new(9, 10, 1) * v49;
        v48.hitbox.Transparency = 1;
    end;
end;

function v1.Client_EnterFlyFire(p50) -- Line: 235
    -- upvalues: SkillCommon (copy), getHeadPivotCF (copy), FXUtil (copy), RunService (copy), getHeadRawPivotCF (copy), u2 (copy), computeBreathLayout (copy)
    local character = p50.skillInputData.character;

    if not character then
        return;
    end;

    local u51 = character:FindFirstChild("舌头", true);

    if not u51 then
        return;
    end;

    local skillRunData = p50.skillRunData;
    local material = skillRunData.material;
    local v52 = SkillCommon.npcSummonBodySkillScale(p50);
    local v53 = material["飞龙吐息起手"];

    if v53 then
        v53:ScaleTo(v52);
        v53:PivotTo(getHeadPivotCF(u51));
        v53.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v53, true);
    end;

    local u54 = material["飞龙吐息喷射火焰"];
    local u55 = material["飞龙吐息地面火焰"];

    if not u54 then
        return;
    end;

    u54:ScaleTo(v52);
    u54.Parent = workspace.Debris;
    FXUtil.Start_All_Emit(u54, 10);

    if u55 then
        u55:ScaleTo(v52);
        u55.Parent = workspace.Debris;
        FXUtil.Start_All_Emit(u55, 10);
    end;

    SkillCommon.playSoundLocal3D("音效-龙喷火", u51:GetPivot().Position);
    SkillCommon.playSoundLocal3D("音效-龙煽动翅膀", u51:GetPivot().Position);
    skillRunData.runEvent["飞龙吐息特效跟随"] = RunService.Heartbeat:Connect(function() -- Line: 276
        -- upvalues: u51 (copy), getHeadRawPivotCF (ref), u2 (ref), u54 (copy), computeBreathLayout (ref), u55 (copy)
        if not u51.Parent then
            return;
        end;

        local v56 = getHeadRawPivotCF(u51):ToWorldSpace(u2);
        local v57 = u54;
        local v58;

        if v57 and v57:IsA("Model") then
            v57:PivotTo(v56);
            v58 = v57:GetPivot();
        else
            v58 = v56;
        end;

        local _, _, v59 = computeBreathLayout(v56, v58);

        if u55 and u55.Parent then
            u55:PivotTo(v59);
        end;
    end);
end;

function v1.Client_ExitFlyFire(p60) -- Line: 289
    -- upvalues: FXUtil (copy)
    local v61 = p60.skillRunData and p60.skillRunData.runEvent;

    if v61 and v61["飞龙吐息特效跟随"] then
        v61["飞龙吐息特效跟随"]:Disconnect();
        v61["飞龙吐息特效跟随"] = nil;
    end;

    local v62 = p60.skillRunData and p60.skillRunData.material;

    if v62 then
        local v63 = v62["飞龙吐息喷射火焰"];
        local v64 = v62["飞龙吐息地面火焰"];

        if v63 then
            FXUtil.Stop_All_Emit(v63);
            FXUtil.Model_Fade(v63, 0.12);
        end;

        if v64 then
            FXUtil.Stop_All_Emit(v64);
            FXUtil.Model_Fade(v64, 0.12);
        end;
    end;
end;

function v1.Server_EnterFlyFire(u65) -- Line: 297
    -- upvalues: SkillCommon (copy), syncBreathHitboxes (copy), RunService (copy)
    local character = u65.skillInputData.character;

    if not character then
        return;
    end;

    local u66 = character:FindFirstChild("舌头", true);

    if not u66 then
        return;
    end;

    local v67 = u65.hitbox[1];

    if not (v67 and v67.hitbox) then
        return;
    end;

    local u68 = SkillCommon.npcSummonBodySkillScale(u65);
    v67:start();
    v67.hitbox.Transparency = 1;

    local function onHitboxSync() -- Line: 319
        -- upvalues: syncBreathHitboxes (ref), u65 (copy), u66 (copy), u68 (copy)
        syncBreathHitboxes(u65, u66, nil, u68);
    end;

    syncBreathHitboxes(u65, u66, nil, u68);
    u65.skillRunData.runEvent["飞龙吐息命中同步"] = RunService.Heartbeat:Connect(onHitboxSync);
end;

function v1.Server_ExitFlyFire(p69) -- Line: 326
    local v70 = p69.skillRunData and p69.skillRunData.runEvent;

    if v70 and v70["飞龙吐息命中同步"] then
        v70["飞龙吐息命中同步"]:Disconnect();
        v70["飞龙吐息命中同步"] = nil;
    end;

    local v71 = p69.hitbox[1];

    if v71 and v71.isActive then
        v71:stop();
    end;

    if v71 and v71.hitbox then
        v71.hitbox.Transparency = 1;
    end;
end;

function v1.Server_EnterRecovery(p72) -- Line: 338
    local v73 = p72.skillRunData and p72.skillRunData.runEvent;

    if v73 and v73["飞龙吐息命中同步"] then
        v73["飞龙吐息命中同步"]:Disconnect();
        v73["飞龙吐息命中同步"] = nil;
    end;

    p72:releaseControl();
end;

function v1.Client_EnterRecovery(p74) -- Line: 343
    local v75 = p74.skillRunData and p74.skillRunData.runEvent;

    if v75 and v75["飞龙吐息特效跟随"] then
        v75["飞龙吐息特效跟随"]:Disconnect();
        v75["飞龙吐息特效跟随"] = nil;
    end;
end;

v1.SoundList = { "音效-龙煽动翅膀", "音效-龙喷火", "音效-龙叫" };
v1.AnimateList = { "飞龙吐息" };
v1.ResNameList = { "飞龙吐息喷射火焰", "飞龙吐息地面火焰", "飞龙吐息起手" };
v1.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v1.animationPlaySide = "Server";
v1.Action = {
    {
        action = "Animation",
        startTime = 0,
        overTime = 4.4,
        animationName = "飞龙吐息",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v1;