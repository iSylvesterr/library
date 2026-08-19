-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local PlayerAimSync = require(script.Parent.Parent.BaseSkill.PlayerAimSync);
local SkillCommon = require(script.Parent._Templates.SkillCommon);
local ShootProjectilePathSync = require(script.Parent._Templates.ShootProjectilePathSync);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local u1 = CFrame.new(1, 1.5, -2.5);
local v2 = {
    skillTotalTime = -1,
    visualFadeoutTime = 6.7,
    skillElementType = ElementTp.None,
    InitialState = "Startup",
    ControlOpenState = "Shot1",
    States = {
        Startup = {
            Duration = 0.3,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup"
        },
        Shot1 = {
            Duration = 0.25,
            OnEnterClient = "Client_EnterShot1",
            OnEnterServer = "Server_EnterShot1"
        },
        Shot2 = {
            Duration = 0.29,
            OnEnterClient = "Client_EnterShot2",
            OnEnterServer = "Server_EnterShot2"
        },
        Shot3 = {
            Duration = 2.5,
            OnEnterClient = "Client_EnterShot3",
            OnEnterServer = "Server_EnterShot3",
            OnExitClient = "Client_ExitShot3",
            OnExitServer = "Server_ExitShot3"
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
    },
    Transitions = {
        {
            From = "Startup",
            To = "Shot1",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Shot1",
            To = "Shot2",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Shot2",
            To = "Shot3",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Shot3",
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
            From = "Shot1",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Shot2",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Shot3",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Shot1",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Shot2",
            To = "Finished",
            Event = SkillEventConst.ForceFinish
        },
        {
            From = "Shot3",
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

local function getBulletMaterialKey(p3) -- Line: 96
    return p3 == 1 and "火枪子弹" or "火枪子弹" .. p3;
end;

local function getMuzzleFxMaterialKey(p4) -- Line: 103
    return p4 == 1 and "火枪射击枪口特效" or "火枪射击枪口特效" .. p4;
end;

local function buildShootPath(p5, p6) -- Line: 110
    -- upvalues: u1 (copy)
    local HumanoidRootPart = p5:FindFirstChild("HumanoidRootPart");

    if not HumanoidRootPart then
        return nil, nil, nil;
    end;

    local Position = HumanoidRootPart:GetPivot():ToWorldSpace(u1).Position;
    local v7 = p6.Position - Position;
    local v8;

    if v7.Magnitude > 0.0001 then
        v8 = v7.Unit;
    else
        v8 = HumanoidRootPart:GetPivot().LookVector.Unit;
    end;

    local v9 = CFrame.lookAt(Position, Position + v8);
    local v10 = Position + v8 * 120;

    return v9, CFrame.lookAt(v10, v10 + v8), v8;
end;

local function resolveClientProjectilePath(p11, p12, p13) -- Line: 132
    -- upvalues: ShootProjectilePathSync (copy), PlayerAimSync (copy), buildShootPath (copy)
    local v14 = ShootProjectilePathSync.waitForPath(p11, p13, p11.runGeneration);

    if v14 then
        return v14.moveStart, v14.moveEnd, v14.flyDir;
    end;

    PlayerAimSync.refreshAimSnapshot(p11);

    return buildShootPath(p12, p11:getTargetCF());
end;

local function setBulletTrailEnabled(p15, p16) -- Line: 145
    if not p15 then
        return;
    end;

    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("Trail") then
            descendant.Enabled = p16;
        end;
    end;
end;

local function playMuzzleFxAtShotPoint(p17, p18, p19) -- Line: 156
    -- upvalues: FXUtil (copy)
    local v20 = p17.skillRunData.material[p18 == 1 and "火枪射击枪口特效" or "火枪射击枪口特效" .. p18];

    if not v20 then
        return;
    end;

    v20:PivotTo(p19);
    v20.Parent = workspace.Debris;
    FXUtil.Emit_Particles_GetDescendants(v20, true);
end;

local function evalThrowFlightCF(p21, p22, p23, p24) -- Line: 166
    local v25 = p21.Position:Lerp(p22.Position, p24);

    return CFrame.lookAt(v25, v25 + p23);
end;

local function buildStopCFrame(p26, p27, p28) -- Line: 171
    if p27 and p27.Magnitude > 0.0001 then
        p28 = -p27;
    end;

    return CFrame.lookAt(p26, p26 + (p28.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p28).Unit);
end;

local function isCharacterObstaclePart(p29) -- Line: 182
    if p29 then
        p29 = p29.Parent;
    end;

    local v30;

    if p29 == nil then
        v30 = false;
    else
        v30 = p29:IsA("Model") and p29:FindFirstChildOfClass("Humanoid") ~= nil;
    end;

    return v30;
end;

local function releaseProjectileWelds(p31) -- Line: 189
    if not (p31 and p31:IsA("Model")) then
        return;
    end;

    for _, descendant in p31:GetDescendants() do
        if descendant:IsA("WeldConstraint") or descendant:IsA("Weld") then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;
            local v32 = Part0 and not Part0:IsDescendantOf(p31);

            if v32 then
                Part1 = v32;
            elseif Part1 then
                Part1 = not Part1:IsDescendantOf(p31);
            end;

            if Part1 then
                descendant:Destroy();
            end;
        end;
    end;
end;

local function detachThrownProjectileVisual(p33) -- Line: 206
    if not (p33 and p33:IsA("Model")) then
        return;
    end;

    if p33.Parent and p33.Parent ~= workspace.Debris then
        p33.Parent = workspace.Debris;
    end;
end;

local function scheduleObstacleHoldFade(u34) -- Line: 215
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    local u35 = {};
    u34.stopFadeToken = u35;
    task.delay(2, function() -- Line: 218
        -- upvalues: u34 (copy), u35 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u34.stopFadeToken ~= u35 then
            return;
        end;

        releaseProjectileWelds(u34.model);
        local model = u34.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u34.model and u34.model.Parent then
            FXUtil.Model_Fade(u34.model, 0.3);
        end;
    end);
end;

local function freezeThrownVisualAtCurrent(u36) -- Line: 230
    -- upvalues: setBulletTrailEnabled (copy), releaseProjectileWelds (copy), FXUtil (copy)
    if u36.stopped or not (u36.model and u36.model.Parent) then
        return;
    end;

    u36.stopped = true;
    setBulletTrailEnabled(u36.model, false);
    local u37 = {};
    u36.stopFadeToken = u37;
    task.delay(2, function() -- Line: 218
        -- upvalues: u36 (copy), u37 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u36.stopFadeToken ~= u37 then
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

local function tryClientObstacleStop(u38, p39, p40, p41, p42) -- Line: 239
    -- upvalues: setBulletTrailEnabled (copy), releaseProjectileWelds (copy), FXUtil (copy)
    if u38.stopped then
        return true;
    end;

    local v43 = p42.Position - p41;

    if v43.Magnitude < 0.01 then
        return false;
    end;

    local v44 = RaycastParams.new();
    v44.FilterType = Enum.RaycastFilterType.Exclude;
    v44.FilterDescendantsInstances = { p39, p40 };
    local v45 = workspace:Raycast(p41, v43, v44);

    if v45 then
        local Instance = v45.Instance;

        if Instance then
            Instance = Instance.Parent;
        end;

        local v46;

        if Instance == nil then
            v46 = false;
        else
            v46 = Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid") ~= nil;
        end;

        if not v46 then
            p40:PivotTo(p42);
            u38.inFlight = true;
            u38.lastFlightCF = p42;

            if not u38.stopped and (u38.model and u38.model.Parent) then
                u38.stopped = true;
                setBulletTrailEnabled(u38.model, false);
                local u47 = {};
                u38.stopFadeToken = u47;
                task.delay(2, function() -- Line: 218
                    -- upvalues: u38 (copy), u47 (copy), releaseProjectileWelds (ref), FXUtil (ref)
                    if u38.stopFadeToken ~= u47 then
                        return;
                    end;

                    releaseProjectileWelds(u38.model);
                    local model = u38.model;

                    if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
                        model.Parent = workspace.Debris;
                    end;

                    if u38.model and u38.model.Parent then
                        FXUtil.Model_Fade(u38.model, 0.3);
                    end;
                end);
            end;

            return true;
        end;
    end;

    return false;
end;

local function resolveStickCF(p48, p49) -- Line: 271
    local model = p48.model;

    if p48.inFlight and (model and model.Parent) then
        return p48.lastFlightCF or model:GetPivot();
    end;

    local hitPosition = p49.hitPosition;

    if hitPosition then
        return CFrame.lookAt(hitPosition, hitPosition + p48.flyDir);
    end;

    return model:GetPivot();
end;

local function finalizeThrownHitStop(u50, p51) -- Line: 284
    -- upvalues: SkillEventConst (copy), setBulletTrailEnabled (copy), FXUtil (copy), releaseProjectileWelds (copy)
    if u50.stopped or not (u50.model and u50.model.Parent) then
        return;
    end;

    if p51.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    u50.stopped = true;
    setBulletTrailEnabled(u50.model, false);
    local model = u50.model;
    local v52;

    if u50.inFlight and (model and model.Parent) then
        v52 = u50.lastFlightCF or model:GetPivot();
    else
        local hitPosition = p51.hitPosition;

        if hitPosition then
            v52 = CFrame.lookAt(hitPosition, hitPosition + u50.flyDir);
        else
            v52 = model:GetPivot();
        end;
    end;

    u50.model:PivotTo(v52);
    FXUtil.Model_Fade_In(u50.model, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u53 = {};
    u50.stopFadeToken = u53;
    task.delay(2, function() -- Line: 218
        -- upvalues: u50 (copy), u53 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u50.stopFadeToken ~= u53 then
            return;
        end;

        releaseProjectileWelds(u50.model);
        local model2 = u50.model;

        if model2 and (model2:IsA("Model") and (model2.Parent and model2.Parent ~= workspace.Debris)) then
            model2.Parent = workspace.Debris;
        end;

        if u50.model and u50.model.Parent then
            FXUtil.Model_Fade(u50.model, 0.3);
        end;
    end);
end;

local function areAllProjectilesStopped(p54) -- Line: 301
    for _, v in p54 do
        if v and not v.stopped then
            return false;
        end;
    end;

    return true;
end;

local function disconnectClientProjectileMotion(p55) -- Line: 310
    if p55.skillRunData.runEvent["子弹移动"] then
        p55.skillRunData.runEvent["子弹移动"]:Disconnect();
        p55.skillRunData.runEvent["子弹移动"] = nil;
    end;
end;

local function disconnectServerProjectileMotion(p56) -- Line: 317
    if p56.skillRunData.runEvent["子弹伤害盒移动"] then
        p56.skillRunData.runEvent["子弹伤害盒移动"]:Disconnect();
        p56.skillRunData.runEvent["子弹伤害盒移动"] = nil;
    end;
end;

local function handleClientHitStop(p57, p58, p59, p60) -- Line: 324
    -- upvalues: finalizeThrownHitStop (copy)
    if p58.stopped then
        return;
    end;

    finalizeThrownHitStop(p58, p59);

    if p60 then
        local v61 = true;

        for _, v in p60 do
            if v and not v.stopped then
                v61 = false;
                break;
            end;
        end;

        if v61 and p57.skillRunData.runEvent["子弹移动"] then
            p57.skillRunData.runEvent["子弹移动"]:Disconnect();
            p57.skillRunData.runEvent["子弹移动"] = nil;
        end;
    end;
end;

local function tryServerObstacleStop(p62, p63, p64) -- Line: 334
    -- upvalues: buildStopCFrame (copy), SkillEventConst (copy)
    if p64.stuck then
        return false;
    end;

    local part = p63.part;
    local Position = part.Position;
    local v65 = p64.lastPosition or Position;
    local v66 = Position - v65;

    if v66.Magnitude < 0.01 then
        p64.lastPosition = Position;

        return false;
    end;

    local v67 = RaycastParams.new();
    v67.FilterType = Enum.RaycastFilterType.Exclude;
    local v68;

    if typeof(part) == "Instance" then
        v68 = { p62.character, part };
    else
        v68 = { p62.character };
    end;

    v67.FilterDescendantsInstances = v68;
    local v69 = workspace:Raycast(v65, v66, v67);

    if not v69 then
        p64.lastPosition = Position;

        return false;
    end;

    local Instance = v69.Instance;

    if Instance then
        Instance = Instance.Parent;
    end;

    local v70 = Instance and Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid");

    if v70 then
        p64.lastPosition = Position;

        return false;
    end;

    p64.stuck = true;
    part:PivotTo(buildStopCFrame(v69.Position, v69.Normal, p64.flyDir));
    p63.hitbox:stop();
    p62:fireProjectileHitConfirmed(v69.Position, SkillEventConst.HitType.Obstacle, nil, {
        hitNormal = v69.Normal,
        projectileIndex = p63.index
    });

    return true;
end;

local function ensureClientProjectileMotionLoop(u71, u72) -- Line: 377
    -- upvalues: RunService (copy), tryClientObstacleStop (copy), setBulletTrailEnabled (copy), FXUtil (copy)
    if u71.skillRunData.runEvent["子弹移动"] then
        return;
    end;

    u71.skillRunData.runEvent["子弹移动"] = RunService.Heartbeat:Connect(function(p73) -- Line: 382
        -- upvalues: u71 (copy), tryClientObstacleStop (ref), u72 (copy), setBulletTrailEnabled (ref), FXUtil (ref)
        local Visual = u71.skillRunData.Visual;

        if not (Visual and Visual.thrownProjectiles) then
            return;
        end;

        local thrownProjectiles = Visual.thrownProjectiles;
        local clientPaths = Visual.clientPaths;

        if not clientPaths then
            return;
        end;

        local v74 = false;

        for _, v in clientPaths do
            local v75 = thrownProjectiles[v.index];
            local model = v.model;

            if v75 and (not v75.stopped and (not v75.finishedFly and (model and model.Parent))) then
                v74 = true;
                v.elapsed = (v.elapsed or 0) + p73;
                local v76 = game.TweenService:GetValue(math.clamp(v.elapsed / 4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                local flyDir = v.flyDir;
                local v77 = v.moveStart.Position:Lerp(v.moveEnd.Position, v76);
                local v78 = CFrame.lookAt(v77, v77 + flyDir);

                if tryClientObstacleStop(v75, u72, model, v.lastPos, v78) then
                    local v79 = true;

                    for _, v3 in thrownProjectiles do
                        if v3 and not v3.stopped then
                            v79 = false;
                            break;
                        end;
                    end;

                    if v79 then
                        local v80 = u71;

                        if v80.skillRunData.runEvent["子弹移动"] then
                            v80.skillRunData.runEvent["子弹移动"]:Disconnect();
                            v80.skillRunData.runEvent["子弹移动"] = nil;
                        end;

                        return;
                    end;
                else
                    v75.inFlight = true;
                    v75.lastFlightCF = v78;
                    model:PivotTo(v78);
                    v.lastPos = v78.Position;

                    if v76 >= 1 and not v75.finishedFly then
                        v75.finishedFly = true;

                        if not v75.stopped then
                            setBulletTrailEnabled(model, false);
                            FXUtil.Model_Fade(model, 0.1);
                        end;
                    end;
                end;
            end;
        end;

        if not v74 then
            local v81 = u71;

            if v81.skillRunData.runEvent["子弹移动"] then
                v81.skillRunData.runEvent["子弹移动"]:Disconnect();
                v81.skillRunData.runEvent["子弹移动"] = nil;
            end;
        end;
    end);
end;

local function ensureServerProjectileMotionLoop(u82) -- Line: 440
    -- upvalues: RunService (copy), tryServerObstacleStop (copy), evalThrowFlightCF (copy)
    if u82.skillRunData.runEvent["子弹伤害盒移动"] then
        return;
    end;

    u82.skillRunData.runEvent["子弹伤害盒移动"] = RunService.Heartbeat:Connect(function(p83) -- Line: 445
        -- upvalues: u82 (copy), tryServerObstacleStop (ref), evalThrowFlightCF (ref)
        local Logic = u82.skillRunData.Logic;

        if not (Logic and (Logic.hitboxPaths and Logic.projectiles)) then
            return;
        end;

        local v84 = false;

        for _, v in Logic.hitboxPaths do
            local v85 = Logic.projectiles[v.index];

            if v85 and not (v85.stuck or v85.finishedFly) then
                v84 = true;
                tryServerObstacleStop(u82, v, v85);

                if not v85.stuck then
                    v.elapsed = (v.elapsed or 0) + p83;
                    local v86 = game.TweenService:GetValue(math.clamp(v.elapsed / 4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    v.part:PivotTo(evalThrowFlightCF(v.moveStart, v.moveEnd, v.flyDir, v86));

                    if v86 >= 1 and not v85.finishedFly then
                        v85.finishedFly = true;

                        if not v85.stuck then
                            v.hitbox:stop();
                        end;
                    end;
                end;
            end;
        end;

        if not v84 then
            local v87 = u82;

            if v87.skillRunData.runEvent["子弹伤害盒移动"] then
                v87.skillRunData.runEvent["子弹伤害盒移动"]:Disconnect();
                v87.skillRunData.runEvent["子弹伤害盒移动"] = nil;
            end;
        end;
    end);
end;

local function fireClientShot(u88, p89) -- Line: 487
    -- upvalues: ShootProjectilePathSync (copy), PlayerAimSync (copy), buildShootPath (copy), FXUtil (copy), setBulletTrailEnabled (copy), SoundModule (copy), finalizeThrownHitStop (copy), RunService (copy), tryClientObstacleStop (copy)
    local character = u88.skillInputData.character;

    if not character then
        return;
    end;

    local v90 = ShootProjectilePathSync.waitForPath(u88, p89, u88.runGeneration);
    local v91, v92, v93;

    if v90 then
        v91 = v90.moveStart;
        v92 = v90.moveEnd;
        v93 = v90.flyDir;
    else
        PlayerAimSync.refreshAimSnapshot(u88);
        v91, v92, v93 = buildShootPath(character, u88:getTargetCF());
    end;

    if not (v91 and (v92 and v93)) then
        return;
    end;

    local v94 = u88.skillRunData.material[p89 == 1 and "火枪子弹" or "火枪子弹" .. p89];

    if not v94 then
        return;
    end;

    local v95 = u88.skillRunData.material[p89 == 1 and "火枪射击枪口特效" or "火枪射击枪口特效" .. p89];

    if v95 then
        v95:PivotTo(v91);
        v95.Parent = workspace.Debris;
        FXUtil.Emit_Particles_GetDescendants(v95, true);
    end;

    setBulletTrailEnabled(v94, true);
    v94:PivotTo(v91);
    FXUtil.Model_Fade_In(v94, 0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);

    if p89 == 3 then
        SoundModule:PlaySoundLocal({
            SoundName = "音效-射击4",
            Is2D = false,
            PlayPosition = character:GetPivot().Position
        });
    else
        SoundModule:PlaySoundLocal({
            SoundName = "音效-射击3",
            Is2D = false,
            PlayPosition = character:GetPivot().Position
        });
    end;

    local skillRunData = u88.skillRunData;
    skillRunData.Visual = skillRunData.Visual or {};
    skillRunData.Visual.thrownProjectiles = skillRunData.Visual.thrownProjectiles or {};
    skillRunData.Visual.clientPaths = skillRunData.Visual.clientPaths or {};
    local v96 = {
        stopped = false,
        inFlight = false,
        model = v94,
        flyDir = v93,
        lastFlightCF = v91
    };
    skillRunData.Visual.thrownProjectiles[p89] = v96;
    table.insert(skillRunData.Visual.clientPaths, {
        elapsed = 0,
        index = p89,
        model = v94,
        moveStart = v91,
        moveEnd = v92,
        flyDir = v93,
        lastPos = v91.Position,
        thrownState = v96
    });
    local pendingHitStops = skillRunData.Visual.pendingHitStops;

    if pendingHitStops and pendingHitStops[p89] then
        local v97 = pendingHitStops[p89];
        pendingHitStops[p89] = nil;
        local thrownProjectiles = skillRunData.Visual.thrownProjectiles;

        if not v96.stopped then
            finalizeThrownHitStop(v96, v97);

            if thrownProjectiles then
                local v98 = true;

                for _, v in thrownProjectiles do
                    if v and not v.stopped then
                        v98 = false;
                        break;
                    end;
                end;

                if v98 and u88.skillRunData.runEvent["子弹移动"] then
                    u88.skillRunData.runEvent["子弹移动"]:Disconnect();
                    u88.skillRunData.runEvent["子弹移动"] = nil;
                end;
            end;
        end;
    end;

    if u88.skillRunData.runEvent["子弹移动"] then
        return;
    end;

    u88.skillRunData.runEvent["子弹移动"] = RunService.Heartbeat:Connect(function(p99) -- Line: 382
        -- upvalues: u88 (copy), tryClientObstacleStop (ref), character (copy), setBulletTrailEnabled (ref), FXUtil (ref)
        local Visual = u88.skillRunData.Visual;

        if not (Visual and Visual.thrownProjectiles) then
            return;
        end;

        local thrownProjectiles = Visual.thrownProjectiles;
        local clientPaths = Visual.clientPaths;

        if not clientPaths then
            return;
        end;

        local v100 = false;

        for _, v in clientPaths do
            local v101 = thrownProjectiles[v.index];
            local model = v.model;

            if v101 and (not v101.stopped and (not v101.finishedFly and (model and model.Parent))) then
                v100 = true;
                v.elapsed = (v.elapsed or 0) + p99;
                local v102 = game.TweenService:GetValue(math.clamp(v.elapsed / 4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                local flyDir = v.flyDir;
                local v103 = v.moveStart.Position:Lerp(v.moveEnd.Position, v102);
                local v104 = CFrame.lookAt(v103, v103 + flyDir);

                if tryClientObstacleStop(v101, character, model, v.lastPos, v104) then
                    local v105 = true;

                    for _, v3 in thrownProjectiles do
                        if v3 and not v3.stopped then
                            v105 = false;
                            break;
                        end;
                    end;

                    if v105 then
                        local v106 = u88;

                        if v106.skillRunData.runEvent["子弹移动"] then
                            v106.skillRunData.runEvent["子弹移动"]:Disconnect();
                            v106.skillRunData.runEvent["子弹移动"] = nil;
                        end;

                        return;
                    end;
                else
                    v101.inFlight = true;
                    v101.lastFlightCF = v104;
                    model:PivotTo(v104);
                    v.lastPos = v104.Position;

                    if v102 >= 1 and not v101.finishedFly then
                        v101.finishedFly = true;

                        if not v101.stopped then
                            setBulletTrailEnabled(model, false);
                            FXUtil.Model_Fade(model, 0.1);
                        end;
                    end;
                end;
            end;
        end;

        if not v100 then
            local v107 = u88;

            if v107.skillRunData.runEvent["子弹移动"] then
                v107.skillRunData.runEvent["子弹移动"]:Disconnect();
                v107.skillRunData.runEvent["子弹移动"] = nil;
            end;
        end;
    end);
end;

local function fireServerShot(u108, p109) -- Line: 558
    -- upvalues: SkillCommon (copy), buildShootPath (copy), RunService (copy), tryServerObstacleStop (copy), evalThrowFlightCF (copy)
    local character = u108.character;

    if not character then
        return;
    end;

    SkillCommon.refreshSkillAimSnapshot(u108);
    local v110 = u108.hitbox[p109];

    if not (v110 and v110.hitbox) then
        return;
    end;

    local v111, v112, v113 = buildShootPath(character, u108:getTargetCF());

    if not (v111 and (v112 and v113)) then
        return;
    end;

    u108:fireProjectilePathConfirmed(p109, v111.Position, v112.Position, v113);
    v110:start();
    local hitbox = v110.hitbox;
    hitbox.Size = hitbox.Size * character:GetScale();
    hitbox:PivotTo(v111);
    local skillRunData = u108.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.hitboxPaths = skillRunData.Logic.hitboxPaths or {};
    skillRunData.Logic.projectiles = skillRunData.Logic.projectiles or {};
    table.insert(skillRunData.Logic.hitboxPaths, {
        elapsed = 0,
        index = p109,
        hitbox = v110,
        part = hitbox,
        moveStart = v111,
        moveEnd = v112,
        flyDir = v113
    });
    skillRunData.Logic.projectiles[p109] = {
        stuck = false,
        lastPosition = v111.Position,
        flyDir = v113
    };

    if u108.skillRunData.runEvent["子弹伤害盒移动"] then
        return;
    end;

    u108.skillRunData.runEvent["子弹伤害盒移动"] = RunService.Heartbeat:Connect(function(p114) -- Line: 445
        -- upvalues: u108 (copy), tryServerObstacleStop (ref), evalThrowFlightCF (ref)
        local Logic = u108.skillRunData.Logic;

        if not (Logic and (Logic.hitboxPaths and Logic.projectiles)) then
            return;
        end;

        local v115 = false;

        for _, v in Logic.hitboxPaths do
            local v116 = Logic.projectiles[v.index];

            if v116 and not (v116.stuck or v116.finishedFly) then
                v115 = true;
                tryServerObstacleStop(u108, v, v116);

                if not v116.stuck then
                    v.elapsed = (v.elapsed or 0) + p114;
                    local v117 = game.TweenService:GetValue(math.clamp(v.elapsed / 4, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
                    v.part:PivotTo(evalThrowFlightCF(v.moveStart, v.moveEnd, v.flyDir, v117));

                    if v117 >= 1 and not v116.finishedFly then
                        v116.finishedFly = true;

                        if not v116.stuck then
                            v.hitbox:stop();
                        end;
                    end;
                end;
            end;
        end;

        if not v115 then
            local v118 = u108;

            if v118.skillRunData.runEvent["子弹伤害盒移动"] then
                v118.skillRunData.runEvent["子弹伤害盒移动"]:Disconnect();
                v118.skillRunData.runEvent["子弹伤害盒移动"] = nil;
            end;
        end;
    end);
end;

local function cleanupThrownProjectileVisual(p119) -- Line: 607
    -- upvalues: setBulletTrailEnabled (copy), releaseProjectileWelds (copy)
    local skillRunData = p119.skillRunData;

    if not skillRunData then
        return;
    end;

    if p119.skillRunData.runEvent["子弹移动"] then
        p119.skillRunData.runEvent["子弹移动"]:Disconnect();
        p119.skillRunData.runEvent["子弹移动"] = nil;
    end;

    local v120 = skillRunData.Visual and skillRunData.Visual.thrownProjectiles;

    if v120 then
        for _, v in v120 do
            if v then
                v.stopFadeToken = nil;
                setBulletTrailEnabled(v.model, false);
                releaseProjectileWelds(v.model);
                local model = v.model;

                if model then
                    if model:IsA("Model") then
                        if model.Parent and model.Parent ~= workspace.Debris then
                            model.Parent = workspace.Debris;
                        end;
                    end;
                end;
            end;
        end;
    end;

    for i = 1, 3 do
        local v121 = skillRunData.material and skillRunData.material[i == 1 and "火枪子弹" or "火枪子弹" .. i];
        setBulletTrailEnabled(v121, false);
        releaseProjectileWelds(v121);

        if v121 then
            if v121:IsA("Model") then
                if v121.Parent and v121.Parent ~= workspace.Debris then
                    v121.Parent = workspace.Debris;
                end;
            end;
        end;
    end;
end;

local function cleanupServerProjectiles(p122) -- Line: 635
    if p122.skillRunData.runEvent["子弹伤害盒移动"] then
        p122.skillRunData.runEvent["子弹伤害盒移动"]:Disconnect();
        p122.skillRunData.runEvent["子弹伤害盒移动"] = nil;
    end;

    local v123 = p122.hitbox[1];

    if v123 and v123.isActive then
        v123:stop();
    end;

    local v124 = p122.hitbox[2];

    if v124 and v124.isActive then
        v124:stop();
    end;

    local v125 = p122.hitbox[3];

    if v125 and v125.isActive then
        v125:stop();
    end;
end;

function v2.Client_EnterStartup(p126) -- Line: 646
    -- upvalues: setBulletTrailEnabled (copy), FXUtil (copy)
    local character = p126.skillInputData.character;

    if not character then
        return;
    end;

    if not character:FindFirstChild("HumanoidRootPart") then
        return;
    end;

    local v127 = p126.skillRunData.material["火枪子弹"];

    if not v127 then
        return;
    end;

    v127.Parent = workspace.Debris;
    setBulletTrailEnabled(v127, false);
    FXUtil.Model_Fade(v127, 0);

    for i = 2, 3 do
        local v128 = i == 1 and "火枪子弹" or "火枪子弹" .. i;
        p126.skillRunData.material[v128] = v127:Clone();
        p126.skillRunData.material[v128].Parent = workspace.Debris;
        setBulletTrailEnabled(p126.skillRunData.material[v128], false);
        FXUtil.Model_Fade(p126.skillRunData.material[v128], 0);
    end;

    local v129 = p126.skillRunData.material["火枪射击枪口特效"];

    if v129 then
        p126.skillRunData.material["火枪射击枪口特效" .. 2] = v129:Clone();
        p126.skillRunData.material["火枪射击枪口特效" .. 3] = v129:Clone();
    end;
end;

function v2.Server_EnterStartup(p130) -- Line: 683
    for _, v in p130.hitbox do
        if v and v.hitbox then
            v.hitbox.Size = Vector3.new(1, 1, 1);
        end;
    end;
end;

function v2.Client_EnterShot1(p131) -- Line: 693
    -- upvalues: fireClientShot (copy)
    fireClientShot(p131, 1);
end;

function v2.Server_EnterShot1(p132) -- Line: 697
    -- upvalues: fireServerShot (copy)
    fireServerShot(p132, 1);
end;

function v2.Client_EnterShot2(p133) -- Line: 701
    -- upvalues: fireClientShot (copy)
    fireClientShot(p133, 2);
end;

function v2.Server_EnterShot2(p134) -- Line: 705
    -- upvalues: fireServerShot (copy)
    fireServerShot(p134, 2);
end;

function v2.Client_EnterShot3(p135) -- Line: 709
    -- upvalues: fireClientShot (copy)
    fireClientShot(p135, 3);
end;

function v2.Server_EnterShot3(p136) -- Line: 713
    -- upvalues: fireServerShot (copy)
    fireServerShot(p136, 3);
end;

function v2.Client_ExitShot3(p137) -- Line: 717
end;

function v2.Server_ExitShot3(p138) -- Line: 720
end;

function v2.Server_EnterRecovery(p139) -- Line: 724
    -- upvalues: cleanupServerProjectiles (copy)
    cleanupServerProjectiles(p139);
    p139:releaseControl();
end;

function v2.Client_EnterRecovery(p140) -- Line: 729
end;

function v2.onServerEvent(p141, p142) -- Line: 732
    -- upvalues: ShootProjectilePathSync (copy), SkillEventConst (copy), finalizeThrownHitStop (copy)
    if ShootProjectilePathSync.handleServerEvent(p141, p142) then
        return;
    end;

    if p142.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    if p142.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    local skillRunData = p141.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    local v143 = p142.projectileIndex or 1;
    local thrownProjectiles = skillRunData.Visual.thrownProjectiles;
    local v144;

    if thrownProjectiles then
        v144 = thrownProjectiles[v143];
    else
        v144 = thrownProjectiles;
    end;

    if not v144 then
        skillRunData.Visual.pendingHitStops = skillRunData.Visual.pendingHitStops or {};
        skillRunData.Visual.pendingHitStops[v143] = p142;

        return;
    end;

    if v144.stopped then
        return;
    end;

    finalizeThrownHitStop(v144, p142);

    if thrownProjectiles then
        local v145 = true;

        for _, v in thrownProjectiles do
            if v and not v.stopped then
                v145 = false;
                break;
            end;
        end;

        if v145 and p141.skillRunData.runEvent["子弹移动"] then
            p141.skillRunData.runEvent["子弹移动"]:Disconnect();
            p141.skillRunData.runEvent["子弹移动"] = nil;
        end;
    end;
end;

function v2.onEnd(p146) -- Line: 760
    -- upvalues: cleanupThrownProjectileVisual (copy)
    cleanupThrownProjectileVisual(p146);
end;

v2.SoundList = { "音效-射击3", "音效-射击4" };
v2.AnimateList = { "步枪连发射击" };
v2.ResNameList = { "火枪子弹", "火枪射击枪口特效" };
v2.hitboxConfig = { {
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
v2.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 1.9,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.9,
        animationName = "步枪连发射击",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action
    }
};

return v2;