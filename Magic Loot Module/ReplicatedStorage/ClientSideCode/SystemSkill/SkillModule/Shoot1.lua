-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local ShootProjectilePathSync = require(script.Parent._Templates.ShootProjectilePathSync);
local FriendlyRayUtil = require(script.Parent.Parent.BaseSkill.FriendlyRayUtil);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local u1 = CFrame.new(1, 1.5, -2);
local v2 = {
    skillTotalTime = -1,
    visualFadeoutTime = 6.3,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "ThrownMoving",
    States = {
        Startup = {
            Duration = 0.2,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        ThrownMoving = {
            Duration = 6,
            OnEnterClient = "Client_EnterThrownMoving",
            OnEnterServer = "Server_EnterThrownMoving",
            OnExitClient = "Client_ExitThrownMoving",
            OnExitServer = "Server_ExitThrownMoving"
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
    },
    Transitions = {
        {
            From = "Startup",
            To = "ThrownMoving",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "ThrownMoving",
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
            From = "ThrownMoving",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "ThrownMoving",
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

local function buildShootPath(p3, p4) -- Line: 87
    -- upvalues: u1 (copy)
    local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil, nil, nil;
    end;

    local Position = HumanoidRootPart:GetPivot():ToWorldSpace(u1).Position;
    local v5 = p4.Position - Position;
    local v6;

    if v5.Magnitude > 0.0001 then
        v6 = v5.Unit;
    else
        v6 = HumanoidRootPart:GetPivot().LookVector.Unit;
    end;

    local v7 = CFrame.lookAt(Position, Position + v6);
    local v8 = Position + v6 * 120;

    return v7, CFrame.lookAt(v8, v8 + v6), v6;
end;

local function resolveClientProjectilePath(p9, p10, p11) -- Line: 109
    -- upvalues: ShootProjectilePathSync (copy), PlayerAimSync (copy), buildShootPath (copy)
    local v12 = ShootProjectilePathSync.waitForPath(p9, p11, p9.runGeneration);

    if v12 then
        return v12.moveStart, v12.moveEnd, v12.flyDir;
    end;

    PlayerAimSync.refreshAimSnapshot(p9);

    return buildShootPath(p10, p9:getTargetCF());
end;

local function setBulletTrailEnabled(p13, p14) -- Line: 122
    if not p13 then
        return;
    end;

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("Trail") then
            descendant.Enabled = p14;
        end;
    end;
end;

local function playMuzzleFxAtShotPoint(p15, p16) -- Line: 133
    -- upvalues: FXUtil (copy)
    local v17 = p15.skillRunData.material["火枪射击枪口特效"];

    if not v17 then
        return;
    end;

    v17:PivotTo(p16);
    v17.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v17, true);
end;

local function evalThrowFlightCF(p18, p19, p20, p21) -- Line: 143
    local v22 = p18.Position:Lerp(p19.Position, p21);

    return CFrame.lookAt(v22, v22 + p20);
end;

local function buildStopCFrame(p23, p24, p25) -- Line: 148
    if p24 and p24.Magnitude > 0.0001 then
        p25 = -p24;
    end;

    return CFrame.lookAt(p23, p23 + (p25.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p25).Unit);
end;

local function isCharacterObstaclePart(p26) -- Line: 159
    if p26 then
        p26 = p26.Parent;
    end;

    local v27;

    if p26 == nil then
        v27 = false;
    else
        v27 = p26:IsA("Model") and p26:FindFirstChildOfClass("Humanoid") ~= nil;
    end;

    return v27;
end;

local function releaseProjectileWelds(p28) -- Line: 166
    if not (p28 and p28:IsA("Model")) then
        return;
    end;

    for _, descendant in p28:GetDescendants() do
        if descendant:IsA("WeldConstraint") or descendant:IsA("Weld") then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;
            local v29 = Part0 and not Part0:IsDescendantOf(p28);

            if v29 then
                Part1 = v29;
            elseif Part1 then
                Part1 = not Part1:IsDescendantOf(p28);
            end;

            if Part1 then
                descendant:Destroy();
            end;
        end;
    end;
end;

local function detachThrownProjectileVisual(p30) -- Line: 183
    if not (p30 and p30:IsA("Model")) then
        return;
    end;

    if p30.Parent and p30.Parent ~= workspace.Debris then
        p30.Parent = workspace.Debris;
    end;
end;

local function scheduleObstacleHoldFade(u31) -- Line: 192
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    local u32 = {};
    u31.stopFadeToken = u32;
    task.delay(2, function() -- Line: 195
        -- upvalues: u31 (copy), u32 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u31.stopFadeToken ~= u32 then
            return;
        end;

        releaseProjectileWelds(u31.model);
        local model = u31.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u31.model and u31.model.Parent then
            FXUtil.Model_Fade(u31.model, 0.3);
        end;
    end);
end;

local function freezeThrownVisualAtCurrent(u33) -- Line: 207
    -- upvalues: setBulletTrailEnabled (copy), releaseProjectileWelds (copy), FXUtil (copy)
    if u33.stopped or not (u33.model and u33.model.Parent) then
        return;
    end;

    u33.stopped = true;
    setBulletTrailEnabled(u33.model, false);
    local u34 = {};
    u33.stopFadeToken = u34;
    task.delay(2, function() -- Line: 195
        -- upvalues: u33 (copy), u34 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u33.stopFadeToken ~= u34 then
            return;
        end;

        releaseProjectileWelds(u33.model);
        local model = u33.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u33.model and u33.model.Parent then
            FXUtil.Model_Fade(u33.model, 0.3);
        end;
    end);
end;

local function tryClientObstacleStop(p35, u36, p37, p38, p39, p40) -- Line: 216
    -- upvalues: FriendlyRayUtil (copy), setBulletTrailEnabled (copy), releaseProjectileWelds (copy), FXUtil (copy)
    if u36.stopped then
        return true;
    end;

    local v41 = p40.Position - p39;

    if v41.Magnitude < 0.01 then
        return false;
    end;

    local v42 = FriendlyRayUtil.raycastProjectileObstacle(p39, v41, {
        id = p35.characterId,
        type = p35.characterType
    }, {
        extraIgnore = { p37, p38 }
    });

    if v42 then
        local Instance = v42.Instance;

        if Instance then
            Instance = Instance.Parent;
        end;

        local v43;

        if Instance == nil then
            v43 = false;
        else
            v43 = Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid") ~= nil;
        end;

        if not v43 then
            p38:PivotTo(p40);
            u36.inFlight = true;
            u36.lastFlightCF = p40;

            if not u36.stopped and (u36.model and u36.model.Parent) then
                u36.stopped = true;
                setBulletTrailEnabled(u36.model, false);
                local u44 = {};
                u36.stopFadeToken = u44;
                task.delay(2, function() -- Line: 195
                    -- upvalues: u36 (copy), u44 (copy), releaseProjectileWelds (ref), FXUtil (ref)
                    if u36.stopFadeToken ~= u44 then
                        return;
                    end;

                    releaseProjectileWelds(u36.model);
                    local model = u36.model;

                    if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
                        model.Parent = workspace.Debris;
                    end;

                    if u36.model and u36.model.Parent then
                        FXUtil.Model_Fade(u36.model, 0.3);
                    end;
                end);
            end;

            return true;
        end;
    end;

    return false;
end;

local function resolveStickCF(p45, p46) -- Line: 252
    local model = p45.model;

    if p45.inFlight and (model and model.Parent) then
        return p45.lastFlightCF or model:GetPivot();
    end;

    local hitPosition = p46.hitPosition;

    if hitPosition then
        return CFrame.lookAt(hitPosition, hitPosition + p45.flyDir);
    end;

    return model:GetPivot();
end;

local function finalizeThrownHitStop(u47, p48) -- Line: 265
    -- upvalues: SkillEventConst (copy), setBulletTrailEnabled (copy), FXUtil (copy), releaseProjectileWelds (copy)
    if u47.stopped or not (u47.model and u47.model.Parent) then
        return;
    end;

    if p48.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    u47.stopped = true;
    setBulletTrailEnabled(u47.model, false);
    local model = u47.model;
    local v49;

    if u47.inFlight and (model and model.Parent) then
        v49 = u47.lastFlightCF or model:GetPivot();
    else
        local hitPosition = p48.hitPosition;

        if hitPosition then
            v49 = CFrame.lookAt(hitPosition, hitPosition + u47.flyDir);
        else
            v49 = model:GetPivot();
        end;
    end;

    u47.model:PivotTo(v49);
    FXUtil.Model_Fade_In(u47.model, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u50 = {};
    u47.stopFadeToken = u50;
    task.delay(2, function() -- Line: 195
        -- upvalues: u47 (copy), u50 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u47.stopFadeToken ~= u50 then
            return;
        end;

        releaseProjectileWelds(u47.model);
        local model2 = u47.model;

        if model2 and (model2:IsA("Model") and (model2.Parent and model2.Parent ~= workspace.Debris)) then
            model2.Parent = workspace.Debris;
        end;

        if u47.model and u47.model.Parent then
            FXUtil.Model_Fade(u47.model, 0.3);
        end;
    end);
end;

local function disconnectThrownMoveEvent(p51) -- Line: 282
    if p51.skillRunData.runEvent["投掷物移动"] then
        p51.skillRunData.runEvent["投掷物移动"]:Disconnect();
        p51.skillRunData.runEvent["投掷物移动"] = nil;
    end;
end;

local function handleClientHitStop(p52, p53, p54) -- Line: 289
    -- upvalues: finalizeThrownHitStop (copy)
    if p53.stopped then
        return;
    end;

    if p52.skillRunData.runEvent["投掷物移动"] then
        p52.skillRunData.runEvent["投掷物移动"]:Disconnect();
        p52.skillRunData.runEvent["投掷物移动"] = nil;
    end;

    finalizeThrownHitStop(p53, p54);
end;

local function cleanupThrownProjectileVisual(p55) -- Line: 297
    -- upvalues: setBulletTrailEnabled (copy), releaseProjectileWelds (copy)
    local skillRunData = p55.skillRunData;

    if not skillRunData then
        return;
    end;

    local v56 = skillRunData.Visual and skillRunData.Visual.thrownProjectile;

    if v56 then
        v56.stopFadeToken = nil;
        setBulletTrailEnabled(v56.model, false);
        releaseProjectileWelds(v56.model);
        local model = v56.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;
    end;

    local v57 = skillRunData.material and skillRunData.material["火枪子弹"];
    setBulletTrailEnabled(v57, false);
    releaseProjectileWelds(v57);

    if v57 then
        if not v57:IsA("Model") then
            return;
        end;

        if v57.Parent and v57.Parent ~= workspace.Debris then
            v57.Parent = workspace.Debris;
        end;
    end;
end;

function v2.Client_EnterStartup(p58) -- Line: 318
    -- upvalues: setBulletTrailEnabled (copy), FXUtil (copy), SoundModule (copy)
    local character = p58.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local v59 = p58.skillRunData.material["火枪子弹"];
    v59.Parent = workspace.Debris;
    setBulletTrailEnabled(v59, false);
    FXUtil.Model_Fade(v59, 0);
    task.delay(0.3, function() -- Line: 333
        -- upvalues: SoundModule (ref), HumanoidRootPart (copy)
        SoundModule:PlaySoundLocal({
            SoundName = "音效-射击3",
            Is2D = false,
            PlayPosition = HumanoidRootPart.Position
        });
    end);
end;

function v2.Server_EnterStartup(p60) -- Line: 342
    local v61 = p60.hitbox[1];

    if v61 and v61.hitbox then
        v61.hitbox.Size = Vector3.new(1, 1, 1);
    end;
end;

function v2.Client_EnterThrownMoving(u62) -- Line: 350
    -- upvalues: ShootProjectilePathSync (copy), PlayerAimSync (copy), buildShootPath (copy), FXUtil (copy), setBulletTrailEnabled (copy), finalizeThrownHitStop (copy), RunService (copy), tryClientObstacleStop (copy)
    local character = u62.skillInputData.character;

    if not character then
        return;
    end;

    local u63 = u62.skillRunData.material["火枪子弹"];
    local v64 = ShootProjectilePathSync.waitForPath(u62, 1, u62.runGeneration);
    local u65, u66, u67;

    if v64 then
        u65 = v64.moveStart;
        u66 = v64.moveEnd;
        u67 = v64.flyDir;
    else
        PlayerAimSync.refreshAimSnapshot(u62);
        u65, u66, u67 = buildShootPath(character, u62:getTargetCF());
    end;

    if not (u65 and (u66 and u67)) then
        return;
    end;

    local v68 = u62.skillRunData.material["火枪射击枪口特效"];

    if v68 then
        v68:PivotTo(u65);
        v68.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v68, true);
    end;

    setBulletTrailEnabled(u63, true);
    u63:PivotTo(u65);
    FXUtil.Model_Fade_In(u63, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    u62.skillRunData.Visual = u62.skillRunData.Visual or {};
    local u69 = {
        stopped = false,
        inFlight = false,
        model = u63,
        flyDir = u67,
        lastFlightCF = u65
    };
    u62.skillRunData.Visual.thrownProjectile = u69;
    local pendingHitStop = u62.skillRunData.Visual.pendingHitStop;

    if pendingHitStop then
        u62.skillRunData.Visual.pendingHitStop = nil;
        finalizeThrownHitStop(u69, pendingHitStop);

        return;
    end;

    local u70 = 0;
    local Position = u65.Position;
    u62.skillRunData.runEvent["投掷物移动"] = RunService.Heartbeat:Connect(function(p71) -- Line: 386
        -- upvalues: u69 (copy), u70 (ref), u65 (copy), u66 (copy), u67 (copy), tryClientObstacleStop (ref), u62 (copy), character (copy), u63 (copy), Position (ref), setBulletTrailEnabled (ref), FXUtil (ref)
        if u69.stopped then
            return;
        end;

        u70 = u70 + p71;
        local v72 = game.TweenService:GetValue(math.clamp(u70 / 4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v73 = u65.Position:Lerp(u66.Position, v72);
        local v74 = CFrame.lookAt(v73, v73 + u67);

        if tryClientObstacleStop(u62, u69, character, u63, Position, v74) then
            local v75 = u62;

            if v75.skillRunData.runEvent["投掷物移动"] then
                v75.skillRunData.runEvent["投掷物移动"]:Disconnect();
                v75.skillRunData.runEvent["投掷物移动"] = nil;
            end;

            return;
        end;

        u69.inFlight = true;
        u69.lastFlightCF = v74;
        u63:PivotTo(v74);
        Position = v74.Position;

        if v72 >= 1 then
            if not u69.stopped then
                setBulletTrailEnabled(u63, false);
                FXUtil.Model_Fade(u63, 0.1);
            end;

            local v76 = u62.skillRunData.runEvent["投掷物移动"];

            if v76 then
                v76:Disconnect();
                u62.skillRunData.runEvent["投掷物移动"] = nil;
            end;
        end;
    end);
end;

function v2.Client_ExitThrownMoving(p77) -- Line: 419
end;

function v2.Server_EnterThrownMoving(u78) -- Line: 426
    -- upvalues: SkillCommon (copy), buildShootPath (copy), RunService (copy), evalThrowFlightCF (copy)
    local u79 = u78.hitbox[1];

    if not u79 then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u78);
    u79:start();
    local character = u78.character;

    if not character then
        return;
    end;

    local hitbox = u79.hitbox;
    hitbox.Size = hitbox.Size * character:GetScale();
    local u80, u81, u82 = buildShootPath(character, u78:getTargetCF());

    if not (u80 and (u81 and u82)) then
        return;
    end;

    u78:fireProjectilePathConfirmed(1, u80.Position, u81.Position, u82);
    u78.skillRunData.Logic = u78.skillRunData.Logic or {};
    u78.skillRunData.Logic.projectileLastPosition = u80.Position;
    u78.skillRunData.Logic.projectileStuck = false;
    u78.skillRunData.Logic.flyDir = u82;
    hitbox:PivotTo(u80);
    local u83 = 0;
    u78.skillRunData.runEvent["投掷物伤害盒移动"] = RunService.Heartbeat:Connect(function(p84) -- Line: 455
        -- upvalues: u78 (copy), u83 (ref), hitbox (copy), evalThrowFlightCF (ref), u80 (copy), u81 (copy), u82 (copy), u79 (copy)
        if u78.skillRunData.Logic.projectileStuck then
            return;
        end;

        u83 = u83 + p84;
        local v85 = game.TweenService:GetValue(math.clamp(u83 / 4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        hitbox:PivotTo(evalThrowFlightCF(u80, u81, u82, v85));

        if v85 >= 1 then
            u79:stop();
            local v86 = u78.skillRunData.runEvent["投掷物伤害盒移动"];

            if v86 then
                v86:Disconnect();
                u78.skillRunData.runEvent["投掷物伤害盒移动"] = nil;
            end;
        end;
    end);
end;

function v2.Server_ExitThrownMoving(p87) -- Line: 476
    if p87.skillRunData.runEvent["投掷物伤害盒移动"] then
        p87.skillRunData.runEvent["投掷物伤害盒移动"]:Disconnect();
        p87.skillRunData.runEvent["投掷物伤害盒移动"] = nil;
    end;

    local v88 = p87.hitbox[1];

    if v88 and v88.isActive then
        v88:stop();
    end;
end;

function v2.Server_EnterRecovery(p89) -- Line: 486
    p89:releaseControl();
end;

function v2.Client_EnterRecovery(p90) -- Line: 490
end;

function v2.Server_UpdateProjectileObstacleCheck(p91) -- Line: 494
    -- upvalues: FriendlyRayUtil (copy), buildStopCFrame (copy), SkillEventConst (copy)
    local skillRunData = p91.skillRunData;

    if not skillRunData or skillRunData.State.current ~= "ThrownMoving" then
        return;
    end;

    local Logic = skillRunData.Logic;

    if not Logic or Logic.projectileStuck then
        return;
    end;

    local v92 = p91.hitbox[1];

    if not (v92 and v92.hitbox) then
        return;
    end;

    local hitbox = v92.hitbox;
    local Position = hitbox.Position;
    local v93 = Logic.projectileLastPosition or Position;
    local v94 = Position - v93;

    if v94.Magnitude < 0.01 then
        Logic.projectileLastPosition = Position;

        return;
    end;

    local v95 = {
        id = p91.characterId,
        type = p91.characterType
    };
    local raycastProjectileObstacle = FriendlyRayUtil.raycastProjectileObstacle;
    local v96 = {};
    local v97;

    if typeof(hitbox) == "Instance" then
        v97 = { p91.character, hitbox };
    else
        v97 = { p91.character };
    end;

    v96.extraIgnore = v97;
    local v98 = raycastProjectileObstacle(v93, v94, v95, v96);

    if not v98 then
        Logic.projectileLastPosition = Position;

        return;
    end;

    Logic.projectileStuck = true;
    hitbox:PivotTo(buildStopCFrame(v98.Position, v98.Normal, Logic.flyDir));
    v92:stop();
    p91:fireProjectileHitConfirmed(v98.Position, SkillEventConst.HitType.Obstacle, nil, {
        hitNormal = v98.Normal
    });
end;

function v2.onServerEvent(p99, p100) -- Line: 540
    -- upvalues: ShootProjectilePathSync (copy), SkillEventConst (copy), finalizeThrownHitStop (copy)
    if ShootProjectilePathSync.handleServerEvent(p99, p100) then
        return;
    end;

    if p100.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    if p100.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    local skillRunData = p99.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    local thrownProjectile = skillRunData.Visual.thrownProjectile;

    if not thrownProjectile then
        skillRunData.Visual.pendingHitStop = p100;

        return;
    end;

    if thrownProjectile.stopped then
        return;
    end;

    if p99.skillRunData.runEvent["投掷物移动"] then
        p99.skillRunData.runEvent["投掷物移动"]:Disconnect();
        p99.skillRunData.runEvent["投掷物移动"] = nil;
    end;

    finalizeThrownHitStop(thrownProjectile, p100);
end;

function v2.onEnd(p101) -- Line: 565
    -- upvalues: cleanupThrownProjectileVisual (copy)
    cleanupThrownProjectileVisual(p101);
end;

v2.SoundList = { "音效-射击3" };
v2.AnimateList = { "手枪单发射击" };
v2.ResNameList = { "火枪子弹", "火枪射击枪口特效" };
v2.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用球",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v2.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 1.1,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.1,
        animationName = "手枪单发射击",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v2;