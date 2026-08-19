-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
require(script.Parent.Parent.BaseSkill.GetSkillData);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local FXUtil = UtilsSystem.FXUtil;
local _ = UtilsSystem.RayCast;
local BurstStone = UtilsSystem.BurstStone;
local RunService = UtilsSystem.RunService;
local _ = UtilsSystem.CameraModule;
local u1 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2,
    skillElementType = ElementTp.Earth,
    PresentationScale = 0.25
};
local u2 = { 1, 1.33, 1.66 };
local u3 = { 1, 1.5, 3 };
local u4 = { 1, 1.1, 1 };
u1.InitialState = "Startup";
u1.ControlOpenState = "Recovery";
u1.States = {
    Startup = {
        Duration = 1,
        OnEnterClient = "Client_EnterStartup",
        OnEnterServer = "Server_EnterStartup",
        OnExitClient = nil,
        OnExitServer = nil
    },
    HitLand1 = {
        Duration = 0.8,
        OnEnterClient = "Client_EnterHitLand1",
        OnEnterServer = "Server_EnterHitLand1",
        OnExitClient = nil,
        OnExitServer = "Server_ExitHitLandWave"
    },
    HitLand2 = {
        Duration = 0.8999999999999999,
        OnEnterClient = "Client_EnterHitLand2",
        OnEnterServer = "Server_EnterHitLand2",
        OnExitClient = nil,
        OnExitServer = "Server_ExitHitLandWave"
    },
    HitLand3 = {
        Duration = 0.30000000000000004,
        OnEnterClient = "Client_EnterHitLand3",
        OnEnterServer = "Server_EnterHitLand3",
        OnExitClient = "Client_ExitHitLand3",
        OnExitServer = "Server_ExitHitLandWave"
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
u1.Transitions = {
    {
        From = "Startup",
        To = "HitLand1",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "HitLand1",
        To = "HitLand2",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "HitLand2",
        To = "HitLand3",
        Event = SkillEventConst.StateTimeout
    },
    {
        From = "HitLand3",
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
        From = "HitLand1",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "HitLand2",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "HitLand3",
        To = "Interrupted",
        Event = SkillEventConst.Interrupt
    },
    {
        From = "Startup",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "HitLand1",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "HitLand2",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "HitLand3",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    },
    {
        From = "Recovery",
        To = "Finished",
        Event = SkillEventConst.ForceFinish
    }
};

local function get_skillScale(p5) -- Line: 119
    local character = p5.skillInputData.character;

    return character and character:GetScale() or 1;
end;

local function get_presentation_scale(p6) -- Line: 124
    -- upvalues: u1 (copy)
    local character = p6.skillInputData.character;

    return (character and character:GetScale() or 1) * u1.PresentationScale;
end;

local function get_wave_shock_scale(p7, p8) -- Line: 128
    -- upvalues: u2 (copy), u1 (copy)
    local v9 = u2[p8] or 1;
    local character = p7.skillInputData.character;

    return (character and character:GetScale() or 1) * u1.PresentationScale * v9;
end;

local function get_shockwave_scale(p10, p11) -- Line: 133
    -- upvalues: u3 (copy), u1 (copy)
    local v12 = u3[p11] or 1;
    local character = p10.skillInputData.character;

    return (character and character:GetScale() or 1) * u1.PresentationScale * v12;
end;

local function get_wave_hitbox_size(p13, p14) -- Line: 138
    -- upvalues: u3 (copy), u4 (copy), u1 (copy)
    local v15 = u3[p14] or 1;
    local v16 = u4[p14] or 1;
    local character = p13.skillInputData.character;
    local v17 = (character and character:GetScale() or 1) * u1.PresentationScale * 60 * v15 * v16;

    return Vector3.new(v17, v17, v17);
end;

local function resolve_landCF(p18) -- Line: 145
    -- upvalues: UtilsSystem (copy)
    local character = p18.skillInputData.character;

    if not character then
        return nil;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil;
    end;

    local character2 = p18.skillInputData.character;
    local v19 = character2 and character2:GetScale() or 1;
    local v20 = HumanoidRootPart:GetPivot():ToWorldSpace(CFrame.new(1.8 * v19, 0, -3.5 * v19));
    local v21 = UtilsSystem.RayCast.RayCastDirection(v20.Position, Vector3.new(0, -1, 0), 30, "Ground");

    if v21 then
        v20 = v20.Rotation + v21.Position + Vector3.new(0, 0.3, 0);
    end;

    return v20;
end;

local function get_or_cache_landCF(p22) -- Line: 165
    -- upvalues: resolve_landCF (copy)
    local skillRunData = p22.skillRunData;

    if skillRunData.landCF then
        return skillRunData.landCF;
    end;

    local v23 = resolve_landCF(p22);

    if v23 then
        skillRunData.landCF = v23;
    end;

    return v23;
end;

local function client_play_wave(p24, p25, p26) -- Line: 177
    -- upvalues: resolve_landCF (copy), u2 (copy), u1 (copy), u3 (copy), FXUtil (copy), UtilsSystem (copy), BurstStone (copy), SoundModule (copy)
    local skillRunData = p24.skillRunData;
    local v27;

    if skillRunData.landCF then
        v27 = skillRunData.landCF;
    else
        v27 = resolve_landCF(p24);

        if v27 then
            skillRunData.landCF = v27;
        end;
    end;

    if not v27 then
        return;
    end;

    local v28 = u2[p25] or 1;
    local character = p24.skillInputData.character;
    local v29 = (character and character:GetScale() or 1) * u1.PresentationScale * v28;
    local v30 = p24.skillRunData.material["大地震击冲击波"];
    local v31 = u3[p25] or 1;
    local character2 = p24.skillInputData.character;
    v30:ScaleTo((character2 and character2:GetScale() or 1) * u1.PresentationScale * v31);
    FXUtil.Emit_Particles_GetDescendants(v30, true);
    UtilsSystem.BurstStone.CreateLandBreak(CFrame.new(v27.Position), p26, v29);
    BurstStone.CreateStoneFly(v27, "Meteor", v29);
    SoundModule:PlaySoundLocal({
        SoundName = "技能-砸地",
        Is2D = false,
        PlayPosition = v27.Position
    });
end;

local function server_start_wave_hitbox(p32, p33, p34) -- Line: 196
    -- upvalues: resolve_landCF (copy)
    local skillRunData = p32.skillRunData;
    local v35;

    if skillRunData.landCF then
        v35 = skillRunData.landCF;
    else
        v35 = resolve_landCF(p32);

        if v35 then
            skillRunData.landCF = v35;
        end;
    end;

    if not v35 then
        return;
    end;

    local u36 = p32.hitbox[p33];

    if not u36 then
        return;
    end;

    u36.hitbox:PivotTo(v35);
    u36.hitbox.Size = p34;
    u36:start();
    task.delay(0.15, function() -- Line: 210
        -- upvalues: u36 (copy)
        u36:stop();
    end);
end;

function u1.Client_EnterStartup(p37) -- Line: 216
    -- upvalues: u1 (copy), FXUtil (copy), RunService (copy)
    local character = p37.skillInputData.character;

    if not character then
        return;
    end;

    local u38 = character:FindFirstChild("Right Arm");

    if not u38 then
        return;
    end;

    local u39 = p37.skillRunData.material["大地震击手上能量"];
    u39.Parent = workspace.Debris;
    local character2 = p37.skillInputData.character;
    u39:ScaleTo((character2 and character2:GetScale() or 1) * u1.PresentationScale);
    u39:PivotTo(u38:GetPivot():ToWorldSpace(CFrame.new(0, u38.Size.Y / 2, 0)));
    FXUtil.Emit_Particles_GetDescendants(u39, true);
    p37.skillRunData.runEvent["手上能量跟随"] = RunService.RenderStepped:Connect(function() -- Line: 232
        -- upvalues: u39 (copy), u38 (copy)
        if u39.Parent and u38 then
            u39:PivotTo(u38:GetPivot());
        end;
    end);
end;

function u1.Server_EnterStartup(p40) -- Line: 239
    local v41 = p40.hitbox[1];

    if v41 and v41.hitbox then
        local character = p40.skillInputData.character;
        local v42 = character and character:GetScale() or 1;
        local v43 = Vector3.new(9, 9, 9 * v42);
        v41.hitbox.Size = v43;
    end;
end;

function u1.Client_EnterHitLand1(u44) -- Line: 249
    -- upvalues: resolve_landCF (copy), u3 (copy), u1 (copy), client_play_wave (copy)
    local skillRunData = u44.skillRunData;
    local v45;

    if skillRunData.landCF then
        v45 = skillRunData.landCF;
    else
        v45 = resolve_landCF(u44);

        if v45 then
            skillRunData.landCF = v45;
        end;
    end;

    if not v45 then
        return;
    end;

    local v46 = u44.skillRunData.material["大地震击冲击波"];
    v46.Parent = workspace.Debris;
    local v47 = u3[1] or 1;
    local character = u44.skillInputData.character;
    v46:ScaleTo((character and character:GetScale() or 1) * u1.PresentationScale * v47);
    v46:PivotTo(CFrame.new(v45.Position));
    task.delay(0.2, function() -- Line: 260
        -- upvalues: u44 (copy), client_play_wave (ref)
        if not u44:isRunningFlow() then
            return;
        end;

        client_play_wave(u44, 1, "HitLand1");
    end);
end;

function u1.Server_EnterHitLand1(u48) -- Line: 268
    -- upvalues: resolve_landCF (copy), server_start_wave_hitbox (copy), u3 (copy), u4 (copy), u1 (copy)
    local skillRunData = u48.skillRunData;

    if skillRunData.landCF then
        local _ = skillRunData.landCF;
    else
        local v49 = resolve_landCF(u48);

        if v49 then
            skillRunData.landCF = v49;
        end;
    end;

    task.delay(0.2, function() -- Line: 270
        -- upvalues: server_start_wave_hitbox (ref), u48 (copy), u3 (ref), u4 (ref), u1 (ref)
        local v50 = u3[1] or 1;
        local v51 = u4[1] or 1;
        local character = u48.skillInputData.character;
        local v52 = (character and character:GetScale() or 1) * u1.PresentationScale * 60 * v50 * v51;
        server_start_wave_hitbox(u48, 1, (Vector3.new(v52, v52, v52)));
    end);
end;

function u1.Client_EnterHitLand2(p53) -- Line: 276
    -- upvalues: client_play_wave (copy)
    client_play_wave(p53, 2, "HitLand2");
end;

function u1.Server_EnterHitLand2(p54) -- Line: 280
    -- upvalues: server_start_wave_hitbox (copy), u3 (copy), u4 (copy), u1 (copy)
    local v55 = u3[2] or 1;
    local v56 = u4[2] or 1;
    local character = p54.skillInputData.character;
    local v57 = (character and character:GetScale() or 1) * u1.PresentationScale * 60 * v55 * v56;
    server_start_wave_hitbox(p54, 2, (Vector3.new(v57, v57, v57)));
end;

function u1.Client_EnterHitLand3(p58) -- Line: 285
    -- upvalues: client_play_wave (copy)
    client_play_wave(p58, 3, "HitLand3");
end;

function u1.Server_EnterHitLand3(p59) -- Line: 289
    -- upvalues: server_start_wave_hitbox (copy), u3 (copy), u4 (copy), u1 (copy)
    local v60 = u3[3] or 1;
    local v61 = u4[3] or 1;
    local character = p59.skillInputData.character;
    local v62 = (character and character:GetScale() or 1) * u1.PresentationScale * 60 * v60 * v61;
    server_start_wave_hitbox(p59, 3, (Vector3.new(v62, v62, v62)));
end;

function u1.Client_ExitHitLand3(p63) -- Line: 293
    if p63.skillRunData.runEvent["手上能量跟随"] then
        p63.skillRunData.runEvent["手上能量跟随"]:Disconnect();
        p63.skillRunData.runEvent["手上能量跟随"] = nil;
    end;
end;

function u1.Server_ExitHitLandWave(p64) -- Line: 300
    local v65 = p64.hitbox[1];

    if v65 and v65.isActive then
        v65:stop();
    end;

    local v66 = p64.hitbox[2];

    if v66 and v66.isActive then
        v66:stop();
    end;

    local v67 = p64.hitbox[3];

    if v67 and v67.isActive then
        v67:stop();
    end;
end;

function u1.Server_EnterRecovery(p68) -- Line: 310
    p68:releaseControl();
end;

function u1.Client_EnterRecovery(p69) -- Line: 314
end;

u1.SoundList = { "技能-砸地" };
u1.AnimateList = { "土元素地震波" };
u1.ResNameList = { "大地震击冲击波", "大地震击手上能量" };
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
u1.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 3.14,
        animationName = "土元素地震波",
        animationSpeed = 0.5,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return u1;