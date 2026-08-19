-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local u1 = CFrame.new(0, 0, -3);
local u2 = CFrame.new(0, -2, 0) * CFrame.Angles(-1.5707963267948966, 0, 0);
local v3 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2.8,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "ThrownMoving",
    States = {
        Startup = {
            Duration = 0.76,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = nil,
            OnExitServer = nil
        },
        ThrownMoving = {
            Duration = 2.5,
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

local function get_skillScale(p4) -- Line: 84
    -- upvalues: SkillCommon (copy)
    local v5 = SkillCommon.skillScaleFromSkillData(p4);
    local v6 = math.max(v5, 0.1);
    local v7 = math.sqrt(v6);
    local v8, v9 = SkillCommon.scaleDualFromData(p4, SkillCommon.bandScaleOptsFromSkillData(p4));

    return v8, v9, math.clamp(v7, 0.5, 2);
end;

local function resolveThrowArm(p10) -- Line: 92
    return p10:FindFirstChild("Left Arm") or p10:FindFirstChild("LeftHand");
end;

local function buildThrowPath(p11, p12, p13) -- Line: 97
    -- upvalues: u2 (copy), u1 (copy)
    local Position = p12.Position;
    local v14 = nil;

    if p13 and p13.Parent then
        v14 = p13:GetPivot();
    elseif p11 then
        local v15 = p11:FindFirstChild("Left Arm") or p11:FindFirstChild("LeftHand");
        local HumanoidRootPart = p11:FindFirstChild("HumanoidRootPart");

        if v15 then
            v14 = v15:GetPivot():ToWorldSpace(u2);
        elseif HumanoidRootPart then
            v14 = HumanoidRootPart:GetPivot():ToWorldSpace(u1);
        end;
    end;

    if not v14 then
        return nil, nil, nil;
    end;

    local v16 = Position - v14.Position;
    local v17;

    if v16.Magnitude > 0.0001 then
        v17 = v16.Unit;
    else
        v17 = v14.LookVector;
    end;

    local v18 = CFrame.lookAt(v14.Position, v14.Position + v17);
    local v19 = v18.Position + v17 * 120;

    return v18, CFrame.lookAt(v19, v19 + v17), v17;
end;

local function evalThrowFlightCF(p20, p21, p22, p23) -- Line: 128
    local v24 = p20.Position:Lerp(p21.Position, p23);

    return CFrame.lookAt(v24, v24 + p22);
end;

local function buildStopCFrame(p25, p26, p27) -- Line: 133
    if p26 and p26.Magnitude > 0.0001 then
        p27 = -p26;
    end;

    return CFrame.lookAt(p25, p25 + (p27.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p27).Unit);
end;

local function isCharacterObstaclePart(p28) -- Line: 144
    if p28 then
        p28 = p28.Parent;
    end;

    local v29;

    if p28 == nil then
        v29 = false;
    else
        v29 = p28:IsA("Model") and p28:FindFirstChildOfClass("Humanoid") ~= nil;
    end;

    return v29;
end;

local function releaseProjectileWelds(p30) -- Line: 151
    if not (p30 and p30:IsA("Model")) then
        return;
    end;

    for _, descendant in p30:GetDescendants() do
        if descendant:IsA("WeldConstraint") or descendant:IsA("Weld") then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;
            local v31 = Part0 and not Part0:IsDescendantOf(p30);

            if v31 then
                Part1 = v31;
            elseif Part1 then
                Part1 = not Part1:IsDescendantOf(p30);
            end;

            if Part1 then
                descendant:Destroy();
            end;
        end;
    end;
end;

local function detachThrownProjectileVisual(p32) -- Line: 168
    if not (p32 and p32:IsA("Model")) then
        return;
    end;

    if p32.Parent and p32.Parent ~= workspace.Debris then
        p32.Parent = workspace.Debris;
    end;
end;

local function scheduleObstacleHoldFade(u33) -- Line: 177
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    local u34 = {};
    u33.stopFadeToken = u34;
    task.delay(2, function() -- Line: 180
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

local function freezeThrownVisualAtCurrent(u35) -- Line: 192
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    if u35.stopped or not (u35.model and u35.model.Parent) then
        return;
    end;

    u35.stopped = true;
    local u36 = {};
    u35.stopFadeToken = u36;
    task.delay(2, function() -- Line: 180
        -- upvalues: u35 (copy), u36 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u35.stopFadeToken ~= u36 then
            return;
        end;

        releaseProjectileWelds(u35.model);
        local model = u35.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u35.model and u35.model.Parent then
            FXUtil.Model_Fade(u35.model, 0.3);
        end;
    end);
end;

local function tryClientObstacleStop(u37, p38, p39, p40, p41) -- Line: 200
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    if u37.stopped then
        return true;
    end;

    local v42 = p41.Position - p40;

    if v42.Magnitude < 0.01 then
        return false;
    end;

    local v43 = RaycastParams.new();
    v43.FilterType = Enum.RaycastFilterType.Exclude;
    v43.FilterDescendantsInstances = { p38, p39 };
    local v44 = workspace:Raycast(p40, v42, v43);

    if v44 then
        local Instance = v44.Instance;

        if Instance then
            Instance = Instance.Parent;
        end;

        local v45;

        if Instance == nil then
            v45 = false;
        else
            v45 = Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid") ~= nil;
        end;

        if not v45 then
            p39:PivotTo(p41);
            u37.inFlight = true;
            u37.lastFlightCF = p41;

            if not u37.stopped and (u37.model and u37.model.Parent) then
                u37.stopped = true;
                local u46 = {};
                u37.stopFadeToken = u46;
                task.delay(2, function() -- Line: 180
                    -- upvalues: u37 (copy), u46 (copy), releaseProjectileWelds (ref), FXUtil (ref)
                    if u37.stopFadeToken ~= u46 then
                        return;
                    end;

                    releaseProjectileWelds(u37.model);
                    local model = u37.model;

                    if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
                        model.Parent = workspace.Debris;
                    end;

                    if u37.model and u37.model.Parent then
                        FXUtil.Model_Fade(u37.model, 0.3);
                    end;
                end);
            end;

            return true;
        end;
    end;

    return false;
end;

local function resolveStickCF(p47, p48) -- Line: 232
    local model = p47.model;

    if p47.inFlight and (model and model.Parent) then
        return p47.lastFlightCF or model:GetPivot();
    end;

    local hitPosition = p48.hitPosition;

    if hitPosition then
        return CFrame.lookAt(hitPosition, hitPosition + p47.flyDir);
    end;

    return model:GetPivot();
end;

local function finalizeThrownHitStop(u49, p50) -- Line: 245
    -- upvalues: SkillEventConst (copy), FXUtil (copy), releaseProjectileWelds (copy)
    if u49.stopped or not (u49.model and u49.model.Parent) then
        return;
    end;

    if p50.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    u49.stopped = true;
    local model = u49.model;
    local v51;

    if u49.inFlight and (model and model.Parent) then
        v51 = u49.lastFlightCF or model:GetPivot();
    else
        local hitPosition = p50.hitPosition;

        if hitPosition then
            v51 = CFrame.lookAt(hitPosition, hitPosition + u49.flyDir);
        else
            v51 = model:GetPivot();
        end;
    end;

    u49.model:PivotTo(v51);
    FXUtil.Model_Fade_In(u49.model, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u52 = {};
    u49.stopFadeToken = u52;
    task.delay(2, function() -- Line: 180
        -- upvalues: u49 (copy), u52 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u49.stopFadeToken ~= u52 then
            return;
        end;

        releaseProjectileWelds(u49.model);
        local model2 = u49.model;

        if model2 and (model2:IsA("Model") and (model2.Parent and model2.Parent ~= workspace.Debris)) then
            model2.Parent = workspace.Debris;
        end;

        if u49.model and u49.model.Parent then
            FXUtil.Model_Fade(u49.model, 0.3);
        end;
    end);
end;

local function disconnectThrownMoveEvent(p53) -- Line: 261
    if p53.skillRunData.runEvent["投掷物移动"] then
        p53.skillRunData.runEvent["投掷物移动"]:Disconnect();
        p53.skillRunData.runEvent["投掷物移动"] = nil;
    end;
end;

local function handleClientHitStop(p54, p55, p56) -- Line: 268
    -- upvalues: finalizeThrownHitStop (copy)
    if p55.stopped then
        return;
    end;

    if p54.skillRunData.runEvent["投掷物移动"] then
        p54.skillRunData.runEvent["投掷物移动"]:Disconnect();
        p54.skillRunData.runEvent["投掷物移动"] = nil;
    end;

    finalizeThrownHitStop(p55, p56);
end;

local function cleanupThrownProjectileVisual(p57) -- Line: 276
    -- upvalues: releaseProjectileWelds (copy)
    local skillRunData = p57.skillRunData;

    if not skillRunData then
        return;
    end;

    local v58 = skillRunData.Visual and skillRunData.Visual.thrownProjectile;

    if v58 then
        v58.stopFadeToken = nil;
        releaseProjectileWelds(v58.model);
        local model = v58.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;
    end;

    local v59 = skillRunData.material and skillRunData.material["箭"];
    releaseProjectileWelds(v59);

    if v59 then
        if not v59:IsA("Model") then
            return;
        end;

        if v59.Parent and v59.Parent ~= workspace.Debris then
            v59.Parent = workspace.Debris;
        end;
    end;
end;

function v3.Client_EnterStartup(p60) -- Line: 295
    -- upvalues: RunService (copy), u2 (copy), SoundModule (copy)
    local character = p60.skillInputData.character;

    if not character then
        return;
    end;

    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return;
    end;

    local u61 = character:FindFirstChild("Left Arm");

    if not u61 then
        return;
    end;

    local u62 = p60.skillRunData.material["箭"];
    u62.Parent = workspace.Debris;
    p60.skillRunData.runEvent["投掷物跟手"] = RunService.Heartbeat:Connect(function(p63) -- Line: 308
        -- upvalues: u61 (copy), u62 (copy), u2 (ref)
        if u61 and u61.Parent ~= nil then
            u62:PivotTo(u61:GetPivot():ToWorldSpace(u2));
        end;
    end);
    task.delay(0.3, function() -- Line: 315
        -- upvalues: SoundModule (ref), HumanoidRootPart (copy)
        SoundModule:PlaySoundLocal({
            SoundName = "音效-技能-弓箭松手",
            Is2D = false,
            PlayPosition = HumanoidRootPart.Position
        });
    end);
end;

function v3.Server_EnterStartup(p64) -- Line: 324
    local v65 = p64.hitbox[1];

    if v65 and v65.hitbox then
        v65.hitbox.Size = Vector3.new(6, 6, 6);
    end;
end;

function v3.Client_EnterThrownMoving(u66) -- Line: 330
    -- upvalues: buildThrowPath (copy), FXUtil (copy), finalizeThrownHitStop (copy), RunService (copy), tryClientObstacleStop (copy)
    if u66.skillRunData.runEvent["投掷物跟手"] then
        u66.skillRunData.runEvent["投掷物跟手"]:Disconnect();
        u66.skillRunData.runEvent["投掷物跟手"] = nil;
    end;

    local character = u66.skillInputData.character;

    if not character then
        return;
    end;

    local u67 = u66.skillRunData.material["箭"];
    local u68, u69, u70 = buildThrowPath(character, u66:getTargetCF(), u67);

    if not (u68 and (u69 and u70)) then
        return;
    end;

    FXUtil.Model_Fade_In(u67, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    u66.skillRunData.Visual = u66.skillRunData.Visual or {};
    local u71 = {
        stopped = false,
        inFlight = false,
        model = u67,
        flyDir = u70,
        lastFlightCF = u68
    };
    u66.skillRunData.Visual.thrownProjectile = u71;
    local pendingHitStop = u66.skillRunData.Visual.pendingHitStop;

    if pendingHitStop then
        u66.skillRunData.Visual.pendingHitStop = nil;
        finalizeThrownHitStop(u71, pendingHitStop);

        return;
    end;

    local u72 = 0;
    local Position = u68.Position;
    u66.skillRunData.runEvent["投掷物移动"] = RunService.Heartbeat:Connect(function(p73) -- Line: 367
        -- upvalues: u71 (copy), u72 (ref), u68 (copy), u69 (copy), u70 (copy), tryClientObstacleStop (ref), character (copy), u67 (copy), Position (ref), u66 (copy), FXUtil (ref)
        if u71.stopped then
            return;
        end;

        u72 = u72 + p73;
        local v74 = game.TweenService:GetValue(math.clamp(u72 / 0.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v75 = u68.Position:Lerp(u69.Position, v74);
        local v76 = CFrame.lookAt(v75, v75 + u70);

        if tryClientObstacleStop(u71, character, u67, Position, v76) then
            local v77 = u66;

            if v77.skillRunData.runEvent["投掷物移动"] then
                v77.skillRunData.runEvent["投掷物移动"]:Disconnect();
                v77.skillRunData.runEvent["投掷物移动"] = nil;
            end;

            return;
        end;

        u71.inFlight = true;
        u71.lastFlightCF = v76;
        u67:PivotTo(v76);
        Position = v76.Position;

        if v74 >= 1 then
            if not u71.stopped then
                FXUtil.Model_Fade(u67, 0.1);
            end;

            local v78 = u66.skillRunData.runEvent["投掷物移动"];

            if v78 then
                v78:Disconnect();
                u66.skillRunData.runEvent["投掷物移动"] = nil;
            end;
        end;
    end);
end;

function v3.Client_ExitThrownMoving(p79) -- Line: 399
end;

function v3.Server_EnterThrownMoving(u80) -- Line: 406
    -- upvalues: buildThrowPath (copy), RunService (copy), evalThrowFlightCF (copy)
    local u81 = u80.hitbox[1];

    if not u81 then
        return;
    end;

    u81:start();
    local character = u80.character;

    if not character then
        return;
    end;

    local hitbox = u81.hitbox;
    hitbox.Size = hitbox.Size * character:GetScale();
    local u82, u83, u84 = buildThrowPath(character, u80:getTargetCF(), nil);

    if not (u82 and (u83 and u84)) then
        return;
    end;

    u80.skillRunData.Logic = u80.skillRunData.Logic or {};
    u80.skillRunData.Logic.projectileLastPosition = u82.Position;
    u80.skillRunData.Logic.projectileStuck = false;
    u80.skillRunData.Logic.flyDir = u84;
    hitbox:PivotTo(u82);
    local u85 = 0;
    u80.skillRunData.runEvent["投掷物伤害盒移动"] = RunService.Heartbeat:Connect(function(p86) -- Line: 432
        -- upvalues: u80 (copy), u85 (ref), hitbox (copy), evalThrowFlightCF (ref), u82 (copy), u83 (copy), u84 (copy), u81 (copy)
        if u80.skillRunData.Logic.projectileStuck then
            return;
        end;

        u85 = u85 + p86;
        local v87 = game.TweenService:GetValue(math.clamp(u85 / 0.5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        hitbox:PivotTo(evalThrowFlightCF(u82, u83, u84, v87));

        if v87 >= 1 then
            u81:stop();
            local v88 = u80.skillRunData.runEvent["投掷物伤害盒移动"];

            if v88 then
                v88:Disconnect();
                u80.skillRunData.runEvent["投掷物伤害盒移动"] = nil;
            end;
        end;
    end);
end;

function v3.Server_ExitThrownMoving(p89) -- Line: 453
    if p89.skillRunData.runEvent["投掷物伤害盒移动"] then
        p89.skillRunData.runEvent["投掷物伤害盒移动"]:Disconnect();
        p89.skillRunData.runEvent["投掷物伤害盒移动"] = nil;
    end;

    local v90 = p89.hitbox[1];

    if v90 and v90.isActive then
        v90:stop();
    end;
end;

function v3.Server_EnterRecovery(p91) -- Line: 463
    p91:releaseControl();
end;

function v3.Client_EnterRecovery(p92) -- Line: 467
end;

function v3.Server_UpdateProjectileObstacleCheck(p93) -- Line: 471
    -- upvalues: buildStopCFrame (copy), SkillEventConst (copy)
    local skillRunData = p93.skillRunData;

    if not skillRunData or skillRunData.State.current ~= "ThrownMoving" then
        return;
    end;

    local Logic = skillRunData.Logic;

    if not Logic or Logic.projectileStuck then
        return;
    end;

    local v94 = p93.hitbox[1];

    if not (v94 and v94.hitbox) then
        return;
    end;

    local hitbox = v94.hitbox;
    local Position = hitbox.Position;
    local v95 = Logic.projectileLastPosition or Position;
    local v96 = Position - v95;

    if v96.Magnitude < 0.01 then
        Logic.projectileLastPosition = Position;

        return;
    end;

    local v97 = RaycastParams.new();
    v97.FilterType = Enum.RaycastFilterType.Exclude;
    local v98;

    if typeof(hitbox) == "Instance" then
        v98 = { p93.character, hitbox };
    else
        v98 = { p93.character };
    end;

    v97.FilterDescendantsInstances = v98;
    local v99 = workspace:Raycast(v95, v96, v97);

    if not v99 then
        Logic.projectileLastPosition = Position;

        return;
    end;

    local Instance = v99.Instance;

    if Instance then
        Instance = Instance.Parent;
    end;

    local v100 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

    if v100 then
        Logic.projectileLastPosition = Position;

        return;
    end;

    Logic.projectileStuck = true;
    hitbox:PivotTo(buildStopCFrame(v99.Position, v99.Normal, Logic.flyDir));
    v94:stop();
    p93:fireProjectileHitConfirmed(v99.Position, SkillEventConst.HitType.Obstacle, nil, {
        hitNormal = v99.Normal
    });
end;

function v3.onServerEvent(p101, p102) -- Line: 522
    -- upvalues: SkillEventConst (copy), finalizeThrownHitStop (copy)
    if p102.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    if p102.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    local skillRunData = p101.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    local thrownProjectile = skillRunData.Visual.thrownProjectile;

    if not thrownProjectile then
        skillRunData.Visual.pendingHitStop = p102;

        return;
    end;

    if thrownProjectile.stopped then
        return;
    end;

    if p101.skillRunData.runEvent["投掷物移动"] then
        p101.skillRunData.runEvent["投掷物移动"]:Disconnect();
        p101.skillRunData.runEvent["投掷物移动"] = nil;
    end;

    finalizeThrownHitStop(thrownProjectile, p102);
end;

function v3.onEnd(p103) -- Line: 544
    -- upvalues: cleanupThrownProjectileVisual (copy)
    cleanupThrownProjectileVisual(p103);
end;

v3.SoundList = { "音效-技能-弓箭松手" };
v3.AnimateList = { "人形生物拉弓1" };
v3.ResNameList = { "箭" };
v3.hitboxConfig = { {
        HitboxIndex = 1,
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果"
    } };
v3.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.8,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 0.8,
        animationName = "人形生物拉弓1",
        animationSpeed = 0.5,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v3;