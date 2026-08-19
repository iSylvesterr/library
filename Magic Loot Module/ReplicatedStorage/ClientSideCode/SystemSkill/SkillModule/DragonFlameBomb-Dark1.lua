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
    skillDistanceLimit = 64,
    InitialState = "Startup",
    ControlOpenState = "Recovery",
    States = {
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
    },
    Transitions = {
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
    }
};

local function disconnectRunEvent(p2, p3) -- Line: 81
    local v4 = p2.skillRunData and p2.skillRunData.runEvent;

    if v4 and v4[p3] then
        v4[p3]:Disconnect();
        v4[p3] = nil;
    end;
end;

local function resolveTongueFromCharacter(p5) -- Line: 89
    return p5:FindFirstChild("舌头", true);
end;

local function getTonguePivotCF(p6) -- Line: 93
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

local function resolveGroundTargetCF(p7) -- Line: 106
    -- upvalues: RayCast (copy)
    local v8 = RayCast.RayCastDirection(p7.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v8 then
        return p7.Rotation + v8.Position + Vector3.new(0, 0.5, 0);
    end;

    return p7;
end;

local function cleanupChargeVfx(p9) -- Line: 114
    -- upvalues: FXUtil (copy)
    if not p9 then
        return;
    end;

    FXUtil.Stop_All_Emit(p9);
    FXUtil.Model_Fade(p9, 0.08);
end;

local function setFireballTrailsEnabled(p10, p11) -- Line: 122
    for _, descendant in p10:GetDescendants() do
        if descendant:IsA("Trail") then
            descendant.Enabled = p11;
        end;
    end;
end;

local function fadeFireballVfx(p12) -- Line: 130
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

local function prepareFireballMesh(p13) -- Line: 142
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

local function getSkillScale(p14) -- Line: 154
    -- upvalues: SkillCommon (copy)
    return SkillCommon.npcSummonBodySkillScale(p14);
end;

function v1.Client_EnterStartup(p15) -- Line: 159
    -- upvalues: getTonguePivotCF (copy), SkillCommon (copy), FXUtil (copy), RunService (copy)
    local character = p15.skillInputData.character;

    if not character then
        return;
    end;

    local u16 = character:FindFirstChild("舌头", true);

    if not u16 then
        return;
    end;

    local skillRunData = p15.skillRunData;
    local u17 = skillRunData.material["龙炎弹蓄力-暗"];

    if not u17 then
        return;
    end;

    local v18 = getTonguePivotCF(u16);
    u17:ScaleTo((SkillCommon.npcSummonBodySkillScale(p15)));
    u17:PivotTo(v18);
    u17.Parent = workspace.Debris;
    FXUtil.Start_All_Emit(u17, 10);
    SkillCommon.playSoundLocal3D("音效-龙喷火球-蓄力", v18.Position);
    skillRunData.runEvent["龙炎弹蓄力-暗跟随"] = RunService.Heartbeat:Connect(function() -- Line: 184
        -- upvalues: u16 (copy), u17 (copy), getTonguePivotCF (ref)
        if u16.Parent and u17.Parent then
            u17:PivotTo(getTonguePivotCF(u16));
        end;
    end);
end;

function v1.Client_ExitStartup(p19) -- Line: 191
    -- upvalues: FXUtil (copy)
    local v20 = p19.skillRunData and p19.skillRunData.runEvent;

    if v20 and v20["龙炎弹蓄力-暗跟随"] then
        v20["龙炎弹蓄力-暗跟随"]:Disconnect();
        v20["龙炎弹蓄力-暗跟随"] = nil;
    end;

    local skillRunData = p19.skillRunData;

    if skillRunData and skillRunData.material then
        local v21 = skillRunData.material["龙炎弹蓄力-暗"];

        if not v21 then
            return;
        end;

        FXUtil.Stop_All_Emit(v21);
        FXUtil.Model_Fade(v21, 0.08);
    end;
end;

function v1.Server_EnterStartup(p22) -- Line: 199
    local v23 = p22.hitbox[1];

    if v23 and v23.hitbox then
        v23.hitbox.Size = Vector3.new(30, 30, 30);
    end;
end;

function v1.Client_EnterShotBomb(u24) -- Line: 208
    -- upvalues: SkillCommon (copy), getTonguePivotCF (copy), FXUtil (copy), RayCast (copy), prepareFireballMesh (copy), RunService (copy), fadeFireballVfx (copy)
    local character = u24.skillInputData.character;

    if not character then
        return;
    end;

    local v25 = character:FindFirstChild("舌头", true);

    if not v25 then
        return;
    end;

    local skillRunData = u24.skillRunData;
    local material = skillRunData.material;
    local v26 = SkillCommon.npcSummonBodySkillScale(u24);
    local v27 = getTonguePivotCF(v25);
    local v28 = material["龙炎弹出现-暗"];

    if v28 then
        v28:ScaleTo(v26);
        v28:PivotTo(v27);
        v28.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v28, true);
    end;

    local v29 = u24:getTargetCF();
    local v30 = RayCast.RayCastDirection(v29.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v30 then
        v29 = v29.Rotation + v30.Position + Vector3.new(0, 0.5, 0);
    end;

    local Position = v29.Position;
    local Position2 = v27.Position;
    local u31 = material["龙炎弹火球-暗"];
    local u32 = material["龙炎弹爆炸-暗"];

    if not u31 then
        return;
    end;

    u31:ScaleTo(v26);
    u31:PivotTo(CFrame.lookAt(Position2, Position));
    u31.Parent = workspace.Debris;
    prepareFireballMesh(u31);
    FXUtil.Start_All_Emit(u31, 10);

    if u32 then
        u32:ScaleTo(v26);
        u32:PivotTo(CFrame.new(Position));
        u32.Parent = workspace.Debris;
    end;

    SkillCommon.playSoundLocal3D("音效-龙喷火球-喷出", v27.Position);
    local u33 = 0;
    local u34 = false;
    skillRunData.runEvent["龙炎弹火球-暗移动"] = RunService.Heartbeat:Connect(function(p35) -- Line: 258
        -- upvalues: u33 (ref), Position2 (copy), Position (copy), u31 (copy), u34 (ref), fadeFireballVfx (ref), u32 (copy), FXUtil (ref), SkillCommon (ref), u24 (copy)
        u33 = u33 + p35;
        local v36 = math.clamp(u33 / 0.2, 0, 1);
        local v37 = Position2:Lerp(Position, v36);
        u31:PivotTo(CFrame.lookAt(v37, Position));

        if v36 >= 1 and not u34 then
            u34 = true;
            fadeFireballVfx(u31);

            if u32 then
                u32:PivotTo(CFrame.new(Position));
                FXUtil.Emit_Particles_GetDescendants(u32, true);
            end;

            SkillCommon.playSoundLocal3D("音效-龙喷火球-击中", Position);
            local v38 = u24;
            local v39 = v38.skillRunData and v38.skillRunData.runEvent;

            if v39 and v39["龙炎弹火球-暗移动"] then
                v39["龙炎弹火球-暗移动"]:Disconnect();
                v39["龙炎弹火球-暗移动"] = nil;
            end;
        end;
    end);
end;

function v1.Client_ExitShotBomb(p40) -- Line: 277
    -- upvalues: setFireballTrailsEnabled (copy)
    local v41 = p40.skillRunData and p40.skillRunData.runEvent;

    if v41 and v41["龙炎弹火球-暗移动"] then
        v41["龙炎弹火球-暗移动"]:Disconnect();
        v41["龙炎弹火球-暗移动"] = nil;
    end;

    local v42 = p40.skillRunData and p40.skillRunData.material and p40.skillRunData.material["龙炎弹火球-暗"];

    if v42 then
        setFireballTrailsEnabled(v42, false);
    end;
end;

function v1.Server_EnterShotBomb(u43) -- Line: 285
    -- upvalues: SkillCommon (copy), RayCast (copy), RunService (copy)
    local u44 = u43.hitbox[1];

    if not (u44 and u44.hitbox) then
        return;
    end;

    if not u43.skillInputData.character then
        return;
    end;

    local v45 = Vector3.new(30, 30, 30) * SkillCommon.npcSummonBodySkillScale(u43);
    local v46 = u43:getTargetCF();
    local v47 = RayCast.RayCastDirection(v46.Position + Vector3.new(0, 3, 0), Vector3.new(0, -1, 0), 100, "Ground");

    if v47 then
        v46 = v46.Rotation + v47.Position + Vector3.new(0, 0.5, 0);
    end;

    u44.hitbox.Size = v45;
    u44.hitbox:PivotTo(v46);
    local u48 = 0;
    local u49 = false;
    u43.skillRunData.runEvent["龙炎弹命中检测"] = RunService.Heartbeat:Connect(function(p50) -- Line: 306
        -- upvalues: u48 (ref), u49 (ref), u44 (copy), u43 (copy)
        u48 = u48 + p50;

        if u48 >= 0.15000000000000002 and not u49 then
            u49 = true;
            u44:start();
        end;

        if u48 >= 0.35 then
            if u44.isActive then
                u44:stop();
            end;

            local v51 = u43;
            local v52 = v51.skillRunData and v51.skillRunData.runEvent;

            if v52 and v52["龙炎弹命中检测"] then
                v52["龙炎弹命中检测"]:Disconnect();
                v52["龙炎弹命中检测"] = nil;
            end;
        end;
    end);
end;

function v1.Server_ExitShotBomb(p53) -- Line: 321
    local v54 = p53.skillRunData and p53.skillRunData.runEvent;

    if v54 and v54["龙炎弹命中检测"] then
        v54["龙炎弹命中检测"]:Disconnect();
        v54["龙炎弹命中检测"] = nil;
    end;

    local v55 = p53.hitbox[1];

    if v55 and v55.isActive then
        v55:stop();
    end;
end;

function v1.Server_EnterRecovery(p56) -- Line: 330
end;

function v1.Client_EnterRecovery(p57) -- Line: 334
    local v58 = p57.skillRunData and p57.skillRunData.runEvent;

    if v58 and v58["龙炎弹蓄力-暗跟随"] then
        v58["龙炎弹蓄力-暗跟随"]:Disconnect();
        v58["龙炎弹蓄力-暗跟随"] = nil;
    end;

    local v59 = p57.skillRunData and p57.skillRunData.runEvent;

    if v59 and v59["龙炎弹火球-暗移动"] then
        v59["龙炎弹火球-暗移动"]:Disconnect();
        v59["龙炎弹火球-暗移动"] = nil;
    end;
end;

v1.SoundList = { "音效-龙喷火球-击中", "音效-龙喷火球-喷出", "音效-龙喷火球-蓄力" };
v1.AnimateList = { "龙炎弹" };
v1.ResNameList = { "龙炎弹出现-暗", "龙炎弹火球-暗", "龙炎弹爆炸-暗", "龙炎弹蓄力-暗" };
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