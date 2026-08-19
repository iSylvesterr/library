-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local SoundModule = UtilsSystem.SoundModule;
local ElementTp = UtilsSystem.EnumMgr.ElementTp;
require(game.ReplicatedFirst.AllSideCode.Class.Class);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local HitResolver = require(script.Parent.Parent.BaseSkill.HitResolver);
local ShootProjectilePathSync = require(script.Parent._Templates.ShootProjectilePathSync);
local FXUtil = UtilsSystem.FXUtil;
local RunService = UtilsSystem.RunService;
local SkillTelegraph = UtilsSystem.SkillTelegraph;
local RayCast = UtilsSystem.RayCast;
local u1 = { -50, -25, 0, 25, 50 };
local AIM_RUN_EVENT_KEY = SkillTelegraph.AIM_RUN_EVENT_KEY;
local v2 = {
    skillTotalTime = -1,
    visualFadeoutTime = 2.2,
    skillElementType = ElementTp.Poison,
    InitialState = "Startup",
    ControlOpenState = "ThrownMoving",
    States = {
        Startup = {
            Duration = 0.7,
            OnEnterClient = "Client_EnterStartup",
            OnEnterServer = "Server_EnterStartup",
            OnExitClient = "Client_ExitStartup"
        },
        ThrownMoving = {
            Duration = 2.1,
            OnEnterClient = "Client_EnterThrownMoving",
            OnEnterServer = "Server_EnterThrownMoving",
            OnExitClient = "Client_ExitThrownMoving",
            OnExitServer = "Server_ExitThrownMoving"
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
            IsTerminal = true,
            OnEnterClient = "Client_EnterInterrupted"
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

local function getNeedleMaterialKey(p3) -- Line: 145
    return p3 == 1 and "毒针" or "毒针" .. p3;
end;

local function getCharacterScale(p4) -- Line: 152
    return p4 and p4:GetScale() or 1;
end;

local function horizontalizeUnit(p5) -- Line: 159
    local v6 = Vector3.new(p5.X, 0, p5.Z);

    return v6.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v6.Unit;
end;

local function applyFanYawToDirection(p7, p8) -- Line: 170
    if math.abs(p8) < 0.0001 then
        local v9 = Vector3.new(p7.X, 0, p7.Z);

        return v9.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v9.Unit;
    end;

    local v10 = Vector3.new(p7.X, 0, p7.Z);
    local v11 = v10.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v10.Unit;

    return (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p8))) * v11).Unit;
end;

local function resolveHeadSpawnCF(p12, p13) -- Line: 181
    local v14 = p12:FindFirstChild("头");

    if v14 and v14:IsA("BasePart") then
        local CFrame2 = v14.CFrame;
        local LookVector = CFrame2.LookVector;
        local v15 = Vector3.new(LookVector.X, 0, LookVector.Z);
        local v16 = v15.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v15.Unit;
        local v17 = CFrame2.Position + v16 * 3 * p13;

        return CFrame.lookAt(v17, v17 + v16, Vector3.new(0, 1, 0));
    end;

    local HumanoidRootPart = p12:FindFirstChild("HumanoidRootPart");

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        return nil;
    end;

    local CFrame2 = HumanoidRootPart.CFrame;
    local LookVector = CFrame2.LookVector;
    local v18 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local v19 = v18.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v18.Unit;
    local v20 = CFrame2.Position + v19 * 3 * p13;

    return CFrame.lookAt(v20, v20 + v19, Vector3.new(0, 1, 0));
end;

local function buildNeedlePath(p21, p22, p23, p24) -- Line: 201
    local v25;

    if math.abs(p23) < 0.0001 then
        local v26 = Vector3.new(p22.X, 0, p22.Z);
        v25 = v26.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v26.Unit;
    else
        local v27 = Vector3.new(p22.X, 0, p22.Z);
        local v28 = v27.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v27.Unit;
        v25 = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(p23))) * v28).Unit;
    end;

    local v29 = CFrame.lookAt(p21, p21 + v25);
    local v30 = p21 + v25 * p24;

    return v29, CFrame.lookAt(v30, v30 + v25), v25;
end;

local function evalFlightCF(p31, p32, p33) -- Line: 214
    local v34 = p31.Position:Lerp(p32.Position, p33);
    local v35 = p32.Position - p31.Position;
    local v36;

    if v35.Magnitude < 0.0001 then
        v36 = p31.LookVector;
    else
        v36 = v35.Unit;
    end;

    return CFrame.lookAt(v34, v34 + v36);
end;

local function buildStopCFrame(p37, p38, p39) -- Line: 225
    if p38 and p38.Magnitude > 0.0001 then
        p39 = -p38;
    end;

    return CFrame.lookAt(p37, p37 + (p39.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p39).Unit);
end;

local function computeHorizontalReflectDir(p40, p41) -- Line: 239
    local Unit = p40.Unit;
    local Unit2 = p41.Unit;
    local v42 = Unit - 2 * Unit:Dot(Unit2) * Unit2;
    local v43 = Vector3.new(v42.X, 0, v42.Z);

    if v43.Magnitude >= 0.0001 then
        return v43.Unit;
    end;

    local v44 = Vector3.new(Unit2.X, 0, Unit2.Z);

    if v44.Magnitude > 0.0001 then
        return Vector3.new(-v44.Z, 0, v44.X).Unit;
    end;

    local v45 = Vector3.new(Unit.X, 0, Unit.Z);

    return v45.Magnitude <= 0.0001 and Vector3.new(0, 0, -1) or v45.Unit;
end;

local function isCharacterObstaclePart(p46) -- Line: 258
    if p46 then
        p46 = p46.Parent;
    end;

    local v47;

    if p46 == nil then
        v47 = false;
    else
        v47 = p46:IsA("Model") and p46:FindFirstChildOfClass("Humanoid") ~= nil;
    end;

    return v47;
end;

local function resolveObstacleModel(p48) -- Line: 265
    if not p48 then
        return nil;
    end;

    local Parent = p48.Parent;

    if Parent and Parent:IsA("Model") then
        return Parent;
    end;

    return nil;
end;

local function clearObstacleIgnore(p49) -- Line: 276
    p49.ignoreObstaclePart = nil;
    p49.ignoreObstacleModel = nil;
    p49.ignoreObstacleUntil = nil;
end;

local function isIgnoredObstacleHit(p50, p51) -- Line: 282
    local ignoreObstacleUntil = p51.ignoreObstacleUntil;

    if not ignoreObstacleUntil then
        return false;
    end;

    if ignoreObstacleUntil > os.clock() then
        if p50 and (p51.ignoreObstaclePart and p50 == p51.ignoreObstaclePart) then
            return true;
        end;

        local v52;

        if p50 then
            v52 = p50.Parent;

            if not (v52 and v52:IsA("Model")) then
                v52 = nil;
            end;
        else
            v52 = nil;
        end;

        return v52 and (p51.ignoreObstacleModel and v52 == p51.ignoreObstacleModel) and true or false;
    end;

    p51.ignoreObstaclePart = nil;
    p51.ignoreObstacleModel = nil;
    p51.ignoreObstacleUntil = nil;

    return false;
end;

local function markObstacleIgnoreAfterRicochet(p53, p54) -- Line: 301
    p53.ignoreObstaclePart = p54;
    local v55;

    if p54 then
        v55 = p54.Parent;

        if not (v55 and v55:IsA("Model")) then
            v55 = nil;
        end;
    else
        v55 = nil;
    end;

    p53.ignoreObstacleModel = v55;
    p53.ignoreObstacleUntil = os.clock() + 0.15;
end;

local function findNeedleTemplate() -- Line: 309
    local ModelRes = game.ReplicatedStorage:FindFirstChild("ModelRes");

    if ModelRes then
        ModelRes = ModelRes:FindFirstChild("Skill");
    end;

    if not ModelRes then
        return nil;
    end;

    local SpiderSting1 = ModelRes:FindFirstChild("SpiderSting1");

    if SpiderSting1 then
        local v56 = SpiderSting1:FindFirstChild("毒针");

        if v56 and v56:IsA("Model") then
            return v56;
        end;
    end;

    local v57 = ModelRes:FindFirstChild("毒针");

    if v57 and v57:IsA("Model") then
        return v57;
    end;

    return nil;
end;

local function syncNeedleModelFromTemplate(p58) -- Line: 336
    -- upvalues: findNeedleTemplate (copy)
    if not (p58 and p58:IsA("Model")) then
        return;
    end;

    p58:SetAttribute("Scale", nil);
    p58:SetAttribute("ModelScale", nil);
    local v59 = findNeedleTemplate();
    local v60 = 1;
    local v61;

    if v59 then
        v61 = v59:GetScale();

        if v61 <= 0.0001 then
            v61 = v60;
        end;
    else
        v61 = v60;
    end;

    p58:ScaleTo(v61);
end;

local function setNeedleModelTransparency(p62, p63) -- Line: 356
    if not (p62 and p62:IsA("Model")) then
        return;
    end;

    for _, descendant in p62:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = p63;
        end;
    end;

    if p62:IsA("BasePart") then
        p62.Transparency = p63;
    end;
end;

local function fadeInNeedleModel(p64) -- Line: 370
    -- upvalues: FXUtil (copy)
    if not (p64 and p64:IsA("Model")) then
        return;
    end;

    FXUtil.Model_Fade_In(p64, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0);
end;

local function destroyNeedleMaterial(p65, p66) -- Line: 383
    if not (p65 and p65.material) then
        return;
    end;

    local v67 = p65.material[p66];

    if not (v67 and v67:IsA("Model")) then
        return;
    end;

    p65.material[p66] = nil;
    v67.Parent = nil;
    v67:Destroy();
end;

local function setHitboxDebugVisible(p68, p69) -- Line: 396
    if not (p68 and p68.hitbox) then
        return;
    end;

    p68.hitbox.Transparency = 1;
end;

local function releaseProjectileWelds(p70) -- Line: 407
    if not (p70 and p70:IsA("Model")) then
        return;
    end;

    for _, descendant in p70:GetDescendants() do
        if descendant:IsA("WeldConstraint") or descendant:IsA("Weld") then
            local Part0 = descendant.Part0;
            local Part1 = descendant.Part1;
            local v71 = Part0 and not Part0:IsDescendantOf(p70);

            if v71 then
                Part1 = v71;
            elseif Part1 then
                Part1 = not Part1:IsDescendantOf(p70);
            end;

            if Part1 then
                descendant:Destroy();
            end;
        end;
    end;
end;

local function detachThrownProjectileVisual(p72) -- Line: 424
    if not (p72 and p72:IsA("Model")) then
        return;
    end;

    if p72.Parent and p72.Parent ~= workspace.Debris then
        p72.Parent = workspace.Debris;
    end;
end;

local function scheduleObstacleHoldFade(u73) -- Line: 433
    -- upvalues: releaseProjectileWelds (copy), FXUtil (copy)
    local u74 = {};
    u73.stopFadeToken = u74;
    task.delay(0.1, function() -- Line: 436
        -- upvalues: u73 (copy), u74 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u73.stopFadeToken ~= u74 then
            return;
        end;

        releaseProjectileWelds(u73.model);
        local model = u73.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u73.model and u73.model.Parent then
            FXUtil.Model_Fade(u73.model, 0.1);
        end;
    end);
end;

local function playRicochetFx(p75, p76) -- Line: 448
    -- upvalues: FXUtil (copy)
    FXUtil.PlayEffect("毒针齐射弹射特效", CFrame.lookAt(p75, p75 + (p76.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p76)), 0.3, 3, nil, nil, {
        resourceCategory = "Skill",
        parent = workspace.Debris
    });
end;

local function beginProjectileSegment(p77, p78, p79, p80, p81) -- Line: 464
    p77.inLinearFlight = false;
    p77.flyDir = p79;
    p77.segmentStartCF = p78;
    p77.segmentEndCF = CFrame.lookAt(p78.Position + p79 * p80, p78.Position + p79 * (p80 + 1));
    p77.segmentElapsed = 0;
    p77.segmentDuration = p81;
    p77.lastPosition = p78.Position;
end;

local function beginLinearFlight(p82, p83, p84, p85) -- Line: 483
    local v86;

    if p84.Magnitude < 0.0001 then
        v86 = p83.LookVector;
    else
        v86 = p84.Unit;
    end;

    p82.inLinearFlight = true;
    p82.flyDir = v86;
    p82.linearSpeed = p85;
    p82.linearFlightCF = CFrame.lookAt(p83.Position, p83.Position + v86);
    p82.lastPosition = p83.Position;
end;

local function finishEasedSegment(p87) -- Line: 497
    local flyDir = p87.flyDir;
    local v88;

    if flyDir.Magnitude < 0.0001 then
        v88 = p87.segmentStartCF.LookVector;
    else
        v88 = flyDir.Unit;
    end;

    local Position = p87.segmentEndCF.Position;
    local Magnitude = (p87.segmentEndCF.Position - p87.segmentStartCF.Position).Magnitude;
    local segmentDuration = p87.segmentDuration;
    local v89 = CFrame.lookAt(Position, Position + v88);
    local v90;

    if v88.Magnitude < 0.0001 then
        v90 = v89.LookVector;
    else
        v90 = v88.Unit;
    end;

    p87.inLinearFlight = true;
    p87.flyDir = v90;
    p87.linearSpeed = (Magnitude < 0.0001 and 100 or Magnitude) / (segmentDuration < 0.0001 and 2 or segmentDuration);
    p87.linearFlightCF = CFrame.lookAt(v89.Position, v89.Position + v90);
    p87.lastPosition = v89.Position;
end;

local function advanceProjectileMotion(p91, p92) -- Line: 516
    -- upvalues: finishEasedSegment (copy), evalFlightCF (copy)
    if p91.inLinearFlight then
        local v93 = p91.linearFlightCF.Position + p91.flyDir * p91.linearSpeed * p92;

        return CFrame.lookAt(v93, v93 + p91.flyDir);
    end;

    p91.segmentElapsed = p91.segmentElapsed + p92;
    local v94 = math.clamp(p91.segmentElapsed / p91.segmentDuration, 0, 1);

    if v94 < 1 then
        return evalFlightCF(p91.segmentStartCF, p91.segmentEndCF, v94);
    end;

    local segmentStartCF = p91.segmentStartCF;
    local segmentEndCF = p91.segmentEndCF;
    local v95 = segmentStartCF.Position:Lerp(segmentEndCF.Position, 1);
    local v96 = segmentEndCF.Position - segmentStartCF.Position;
    local v97;

    if v96.Magnitude < 0.0001 then
        v97 = segmentStartCF.LookVector;
    else
        v97 = v96.Unit;
    end;

    local v98 = CFrame.lookAt(v95, v95 + v97);
    finishEasedSegment(p91);

    return v98;
end;

local function commitProjectileMotion(p99, p100) -- Line: 535
    if p99.inLinearFlight then
        p99.linearFlightCF = p100;
    end;
end;

local function endProjectileFlightServer(p101, p102) -- Line: 541
    if p102.stuck or p102.flightEnded then
        return;
    end;

    p102.flightEnded = true;

    if p101.hitbox and p101.hitbox.isActive then
        p101.hitbox:stop();
        local hitbox = p101.hitbox;

        if hitbox then
            if not hitbox.hitbox then
                return;
            end;

            hitbox.hitbox.Transparency = 1;
        end;
    end;
end;

local function endProjectileFlightClient(p103) -- Line: 552
    -- upvalues: FXUtil (copy)
    if p103.stopped or p103.flightEnded then
        return;
    end;

    p103.flightEnded = true;
    p103.stopped = true;
    local model = p103.model;

    if model and model.Parent then
        FXUtil.Model_Fade(model, 0.1);
    end;
end;

local function tickProjectileFlightElapsed(p104, p105) -- Line: 564
    p104.flightElapsed = (p104.flightElapsed or 0) + p105;

    return p104.flightElapsed >= 2;
end;

local function disconnectMotionKey(p106, p107) -- Line: 569
    local v108 = p106.skillRunData.runEvent[p107];

    if v108 then
        v108:Disconnect();
        p106.skillRunData.runEvent[p107] = nil;
    end;
end;

local function areAllProjectilesStopped(p109) -- Line: 577
    for _, v in p109 do
        if v and not v.stopped then
            return false;
        end;
    end;

    return true;
end;

local function finalizeThrownHitStop(u110, p111) -- Line: 586
    -- upvalues: SkillEventConst (copy), syncNeedleModelFromTemplate (copy), FXUtil (copy), releaseProjectileWelds (copy)
    if u110.stopped or not (u110.model and u110.model.Parent) then
        return;
    end;

    if p111.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    u110.stopped = true;
    local v112;

    if u110.inFlight and u110.lastFlightCF then
        v112 = u110.lastFlightCF;
    elseif p111.hitPosition then
        v112 = CFrame.lookAt(p111.hitPosition, p111.hitPosition + u110.flyDir);
    else
        v112 = u110.model:GetPivot();
    end;

    u110.model:PivotTo(v112);
    syncNeedleModelFromTemplate(u110.model);
    FXUtil.Model_Fade_In(u110.model, 0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.Out);
    local u113 = {};
    u110.stopFadeToken = u113;
    task.delay(0.1, function() -- Line: 436
        -- upvalues: u110 (copy), u113 (copy), releaseProjectileWelds (ref), FXUtil (ref)
        if u110.stopFadeToken ~= u113 then
            return;
        end;

        releaseProjectileWelds(u110.model);
        local model = u110.model;

        if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
            model.Parent = workspace.Debris;
        end;

        if u110.model and u110.model.Parent then
            FXUtil.Model_Fade(u110.model, 0.1);
        end;
    end);
end;

local function applyClientRicochetSegment(p114, p115, p116) -- Line: 609
    -- upvalues: playRicochetFx (copy)
    if p114.stopped then
        return;
    end;

    local v117 = p116.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or p116.Unit;
    local v118 = p115 + v117 * 0.2;
    local v119 = CFrame.lookAt(v118, v118 + v117);
    p114.inLinearFlight = false;
    p114.flyDir = v117;
    p114.segmentStartCF = v119;
    p114.segmentEndCF = CFrame.lookAt(v119.Position + v117 * 60, v119.Position + v117 * 61);
    p114.segmentElapsed = 0;
    p114.segmentDuration = 1.5;
    p114.lastPosition = v119.Position;
    p114.inFlight = true;
    p114.lastFlightCF = v119;
    playRicochetFx(p115, v117);
end;

local function tryClientObstacleBounceOrStick(u120, p121, p122, p123, p124) -- Line: 634
    -- upvalues: isIgnoredObstacleHit (copy), computeHorizontalReflectDir (copy), applyClientRicochetSegment (copy), syncNeedleModelFromTemplate (copy), releaseProjectileWelds (copy), FXUtil (copy)
    if u120.stopped then
        return true;
    end;

    local v125 = p124.Position - p123;

    if v125.Magnitude < 0.01 then
        return false;
    end;

    local v126 = RaycastParams.new();
    v126.FilterType = Enum.RaycastFilterType.Exclude;
    v126.FilterDescendantsInstances = { p121, p122 };
    local v127 = workspace:Raycast(p123, v125, v126);

    if v127 then
        local Instance = v127.Instance;

        if Instance then
            Instance = Instance.Parent;
        end;

        local v128;

        if Instance == nil then
            v128 = false;
        else
            v128 = Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid") ~= nil;
        end;

        if not v128 then
            if isIgnoredObstacleHit(v127.Instance, u120) then
                return false;
            end;

            if u120.bouncesRemaining <= 0 then
                p122:PivotTo(p124);
                u120.inFlight = true;
                u120.lastFlightCF = p124;
                syncNeedleModelFromTemplate(p122);
                u120.stopped = true;
                local u129 = {};
                u120.stopFadeToken = u129;
                task.delay(0.1, function() -- Line: 436
                    -- upvalues: u120 (copy), u129 (copy), releaseProjectileWelds (ref), FXUtil (ref)
                    if u120.stopFadeToken ~= u129 then
                        return;
                    end;

                    releaseProjectileWelds(u120.model);
                    local model = u120.model;

                    if model and (model:IsA("Model") and (model.Parent and model.Parent ~= workspace.Debris)) then
                        model.Parent = workspace.Debris;
                    end;

                    if u120.model and u120.model.Parent then
                        FXUtil.Model_Fade(u120.model, 0.1);
                    end;
                end);

                return true;
            end;

            u120.bouncesRemaining = u120.bouncesRemaining - 1;
            local v130 = computeHorizontalReflectDir(u120.flyDir, v127.Normal);
            p122:PivotTo(p124);
            local Instance2 = v127.Instance;
            u120.ignoreObstaclePart = Instance2;
            local v131;

            if Instance2 then
                v131 = Instance2.Parent;

                if not (v131 and v131:IsA("Model")) then
                    v131 = nil;
                end;
            else
                v131 = nil;
            end;

            u120.ignoreObstacleModel = v131;
            u120.ignoreObstacleUntil = os.clock() + 0.15;
            applyClientRicochetSegment(u120, v127.Position, v130);

            return false;
        end;
    end;

    return false;
end;

local function buildNeedlePaths(p132) -- Line: 681
    -- upvalues: resolveHeadSpawnCF (copy), u1 (copy)
    local v133 = resolveHeadSpawnCF(p132, p132 and (p132:GetScale() or 1) or 1);

    if not v133 then
        return {};
    end;

    local Position = v133.Position;
    local LookVector = v133.LookVector;
    local v134 = Vector3.new(LookVector.X, 0, LookVector.Z);
    local v135 = v134.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v134.Unit;
    local v136 = {};

    for i = 1, 5 do
        local v137 = u1[i] or 0;
        local v138;

        if math.abs(v137) < 0.0001 then
            local v139 = Vector3.new(v135.X, 0, v135.Z);
            v138 = v139.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v139.Unit;
        else
            local v140 = Vector3.new(v135.X, 0, v135.Z);
            local v141 = v140.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v140.Unit;
            v138 = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), (math.rad(v137))) * v141).Unit;
        end;

        local v142 = CFrame.lookAt(Position, Position + v138);
        local v143 = Position + v138 * 100;
        local v144 = {
            index = i,
            moveStart = v142,
            moveEnd = CFrame.lookAt(v143, v143 + v138),
            flyDir = v138
        };
        table.insert(v136, v144);
    end;

    return v136;
end;

local function resolveClientNeedlePaths(p145, p146) -- Line: 713
    -- upvalues: ShootProjectilePathSync (copy), buildNeedlePaths (copy), RunService (copy)
    local v147 = os.clock() + 0.5;
    local runGeneration = p145.runGeneration;

    while p145:isRunningFlow() and p145.runGeneration == runGeneration do
        local v148 = true;

        for i = 1, 5 do
            if not ShootProjectilePathSync.getPath(p145.skillRunData, i) then
                v148 = false;
                break;
            end;
        end;

        if v148 then
            break;
        end;

        if v147 <= os.clock() then
            return buildNeedlePaths(p146);
        end;

        RunService.Heartbeat:Wait();
    end;

    if not p145:isRunningFlow() or p145.runGeneration ~= runGeneration then
        return {};
    end;

    local v149 = {};

    for i = 1, 5 do
        local v150 = ShootProjectilePathSync.getPath(p145.skillRunData, i);

        if not v150 then
            return buildNeedlePaths(p146);
        end;

        table.insert(v149, {
            index = i,
            moveStart = v150.moveStart,
            moveEnd = v150.moveEnd,
            flyDir = v150.flyDir
        });
    end;

    return v149;
end;

local function performServerRicochet(p151, p152, p153, p154, p155, p156, p157) -- Line: 755
    -- upvalues: computeHorizontalReflectDir (copy), SkillEventConst (copy)
    if p152.stuck or p152.bouncesRemaining <= 0 then
        return false;
    end;

    p152.bouncesRemaining = p152.bouncesRemaining - 1;
    local v158 = computeHorizontalReflectDir(p152.flyDir, p155);
    local v159 = p154 + v158 * 0.2;
    local v160 = CFrame.lookAt(v159, v159 + v158);
    p152.inLinearFlight = false;
    p152.flyDir = v158;
    p152.segmentStartCF = v160;
    p152.segmentEndCF = CFrame.lookAt(v160.Position + v158 * 60, v160.Position + v158 * 61);
    p152.segmentElapsed = 0;
    p152.segmentDuration = 1.5;
    p152.lastPosition = v160.Position;

    if p153 and p153.part then
        p153.part:PivotTo(v160);
    end;

    p152.ignoreObstaclePart = p156;
    local v161;

    if p156 then
        v161 = p156.Parent;

        if not (v161 and v161:IsA("Model")) then
            v161 = nil;
        end;
    else
        v161 = nil;
    end;

    p152.ignoreObstacleModel = v161;
    p152.ignoreObstacleUntil = os.clock() + 0.15;
    p151:fireProjectileHitConfirmed(p154, SkillEventConst.HitType.Obstacle, nil, {
        ricochet = true,
        projectileIndex = p157,
        hitNormal = p155,
        newFlyDir = v158,
        bouncesRemaining = p152.bouncesRemaining,
        hitPart = p156
    });

    return true;
end;

local function cleanupThrownProjectileVisual(p162) -- Line: 795
    -- upvalues: releaseProjectileWelds (copy)
    local skillRunData = p162.skillRunData;

    if not skillRunData then
        return;
    end;

    local v163 = p162.skillRunData.runEvent["蜘蛛毒针客户端弹道"];

    if v163 then
        v163:Disconnect();
        p162.skillRunData.runEvent["蜘蛛毒针客户端弹道"] = nil;
    end;

    local v164 = skillRunData.Visual and skillRunData.Visual.thrownProjectiles;

    if v164 then
        for _, v in v164 do
            if v then
                v.stopFadeToken = nil;
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

    for i = 1, 5 do
        local v165 = i == 1 and "毒针" or "毒针" .. i;

        if skillRunData then
            if skillRunData.material then
                local v166 = skillRunData.material[v165];

                if v166 then
                    if v166:IsA("Model") then
                        skillRunData.material[v165] = nil;
                        v166.Parent = nil;
                        v166:Destroy();
                    end;
                end;
            end;
        end;
    end;
end;

local function ensureNeedleTelegraphGroundY(p167, p168, p169) -- Line: 827
    -- upvalues: RayCast (copy)
    p167.Logic = p167.Logic or {};
    local needleTelegraphGroundY = p167.Logic.needleTelegraphGroundY;

    if type(needleTelegraphGroundY) == "number" then
        return needleTelegraphGroundY;
    end;

    local Y = p168.Y;

    if p169 then
        p169 = p169:FindFirstChild("HumanoidRootPart");
    end;

    if p169 and p169:IsA("BasePart") then
        Y = p169.Position.Y;
    end;

    local v170 = RayCast.RayCastDirection(Vector3.new(p168.X, Y + 4, p168.Z), Vector3.new(0, -1, 0), 500, "Ground");

    if not v170 then
        return nil;
    end;

    local v171 = v170.Position.Y + 0.1;
    p167.Logic.needleTelegraphGroundY = v171;

    return v171;
end;

local function getCachedTelegraphGroundY(p172) -- Line: 861
    local v173 = p172.Logic and p172.Logic.needleTelegraphGroundY;

    if type(v173) == "number" then
        return v173;
    end;

    return nil;
end;

local function resolveNeedleTelegraphPose(p174, p175, p176) -- Line: 878
    local Position = p174.moveStart.Position;
    local Position2 = p174.moveEnd.Position;
    local v177 = Vector3.new(Position2.X - Position.X, 0, Position2.Z - Position.Z);
    local Magnitude = v177.Magnitude;

    if Magnitude < 0.0001 then
        return nil, nil;
    end;

    local v178 = Vector3.new(v177.X, 0, v177.Z);
    local v179 = v178.Magnitude < 0.0001 and Vector3.new(0, 0, -1) or v178.Unit;
    local v180 = Vector3.new((Position.X + Position2.X) * 0.5, p176, (Position.Z + Position2.Z) * 0.5);

    return CFrame.lookAt(v180, v180 + v179, Vector3.new(0, 1, 0)), Vector3.new(p175 * 1, 1, Magnitude);
end;

local function resolveSharedNeedleSpawnPos(p181) -- Line: 905
    local v182 = p181[1];

    if v182 and v182.moveStart then
        return v182.moveStart.Position;
    end;

    return nil;
end;

local function stopTelegraphAimLoop(p183) -- Line: 918
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    if not (p183 and p183.runEvent) then
        return;
    end;

    local v184 = p183.runEvent[AIM_RUN_EVENT_KEY];

    if v184 then
        v184:Disconnect();
        p183.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;
end;

local function startTelegraphAimLoop(u185, u186, u187) -- Line: 936
    -- upvalues: AIM_RUN_EVENT_KEY (copy), RunService (copy), buildNeedlePaths (copy), resolveNeedleTelegraphPose (copy)
    local v188 = u186 and u186.runEvent and u186.runEvent[AIM_RUN_EVENT_KEY];

    if v188 then
        v188:Disconnect();
        u186.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    u186.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 938
        -- upvalues: u185 (copy), u187 (copy), u186 (copy), AIM_RUN_EVENT_KEY (ref), buildNeedlePaths (ref), resolveNeedleTelegraphPose (ref)
        if not u185:isRunningFlow() or u185.runGeneration ~= u187 then
            local v189 = u186;

            if v189 then
                if not v189.runEvent then
                    return;
                end;

                local v190 = v189.runEvent[AIM_RUN_EVENT_KEY];

                if v190 then
                    v190:Disconnect();
                    v189.runEvent[AIM_RUN_EVENT_KEY] = nil;
                end;
            end;

            return;
        end;

        local v191 = u186.Logic and u186.Logic.dangerTelegraphs;

        if not v191 then
            return;
        end;

        local character = u185.skillInputData.character;

        if not character then
            return;
        end;

        local v192 = character and (character:GetScale() or 1) or 1;
        local v193 = buildNeedlePaths(character);
        local v194 = u186;
        local v195 = v194.Logic and v194.Logic.needleTelegraphGroundY;

        if type(v195) ~= "number" then
            v195 = nil;
        end;

        if not v195 then
            return;
        end;

        for _, v in v193 do
            local v196 = v191[v.index];

            if v196 then
                local v197, v198 = resolveNeedleTelegraphPose(v, v192, v195);

                if v197 and v198 then
                    v196:update({
                        worldCFrame = v197,
                        hitboxSize = v198
                    });
                end;
            end;
        end;
    end);
end;

local function setupStartupTelegraphs(u199) -- Line: 977
    -- upvalues: SkillTelegraph (copy), buildNeedlePaths (copy), ensureNeedleTelegraphGroundY (copy), resolveNeedleTelegraphPose (copy), AIM_RUN_EVENT_KEY (copy), RunService (copy)
    local character = u199.skillInputData.character;

    if not character then
        return;
    end;

    local skillRunData = u199.skillRunData;
    skillRunData.Logic = skillRunData.Logic or {};
    SkillTelegraph.destroyAllInRunData(skillRunData);
    skillRunData.Logic.needleTelegraphGroundY = nil;
    local v200 = character and (character:GetScale() or 1) or 1;
    local v201 = buildNeedlePaths(character);

    if #v201 == 0 then
        return;
    end;

    local v202 = v201[1];
    local v203;

    if v202 and v202.moveStart then
        v203 = v202.moveStart.Position;
    else
        v203 = nil;
    end;

    if not v203 then
        return;
    end;

    local v204 = ensureNeedleTelegraphGroundY(skillRunData, v203, character);

    if not v204 then
        return;
    end;

    skillRunData.Logic.dangerTelegraphs = {};

    for _, v in v201 do
        local v205, v206 = resolveNeedleTelegraphPose(v, v200, v204);

        if v205 and v206 then
            skillRunData.Logic.dangerTelegraphs[v.index] = SkillTelegraph.new({
                shape = "Rect",
                warnDuration = 0.7,
                skipGroundAlign = true,
                worldCFrame = v205,
                hitboxSize = v206,
                casterCharacter = character,
                characterType = u199.characterType
            });
        end;
    end;

    local runGeneration = u199.runGeneration;
    local v207 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v207 then
        v207:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    skillRunData.runEvent[AIM_RUN_EVENT_KEY] = RunService.Heartbeat:Connect(function() -- Line: 938
        -- upvalues: u199 (copy), runGeneration (copy), skillRunData (copy), AIM_RUN_EVENT_KEY (ref), buildNeedlePaths (ref), resolveNeedleTelegraphPose (ref)
        if not u199:isRunningFlow() or u199.runGeneration ~= runGeneration then
            local v208 = skillRunData;

            if v208 then
                if not v208.runEvent then
                    return;
                end;

                local v209 = v208.runEvent[AIM_RUN_EVENT_KEY];

                if v209 then
                    v209:Disconnect();
                    v208.runEvent[AIM_RUN_EVENT_KEY] = nil;
                end;
            end;

            return;
        end;

        local v210 = skillRunData.Logic and skillRunData.Logic.dangerTelegraphs;

        if not v210 then
            return;
        end;

        local character2 = u199.skillInputData.character;

        if not character2 then
            return;
        end;

        local v211 = character2 and (character2:GetScale() or 1) or 1;
        local v212 = buildNeedlePaths(character2);
        local v213 = skillRunData;
        local v214 = v213.Logic and v213.Logic.needleTelegraphGroundY;

        if type(v214) ~= "number" then
            v214 = nil;
        end;

        if not v214 then
            return;
        end;

        for _, v in v212 do
            local v215 = v210[v.index];

            if v215 then
                local v216, v217 = resolveNeedleTelegraphPose(v, v211, v214);

                if v216 and v217 then
                    v215:update({
                        worldCFrame = v216,
                        hitboxSize = v217
                    });
                end;
            end;
        end;
    end);
end;

local function deployFlightTelegraphs(p218, p219) -- Line: 1029
    -- upvalues: AIM_RUN_EVENT_KEY (copy), SkillTelegraph (copy), resolveNeedleTelegraphPose (copy)
    local skillRunData = p218.skillRunData;
    local v220 = skillRunData and skillRunData.runEvent and skillRunData.runEvent[AIM_RUN_EVENT_KEY];

    if v220 then
        v220:Disconnect();
        skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
    end;

    SkillTelegraph.destroyAllInRunData(skillRunData);
    local character = p218.skillInputData.character;

    if not character then
        return;
    end;

    local v221 = character and (character:GetScale() or 1) or 1;
    skillRunData.Logic = skillRunData.Logic or {};
    skillRunData.Logic.dangerTelegraphs = {};
    local v222 = skillRunData.Logic and skillRunData.Logic.needleTelegraphGroundY;

    if type(v222) ~= "number" then
        v222 = nil;
    end;

    if not v222 then
        return;
    end;

    for _, v in p219 do
        local v223, v224 = resolveNeedleTelegraphPose(v, v221, v222);

        if v223 and v224 then
            skillRunData.Logic.dangerTelegraphs[v.index] = SkillTelegraph.new({
                shape = "Rect",
                warnDuration = 0,
                activeDuration = 2,
                skipGroundAlign = true,
                worldCFrame = v223,
                hitboxSize = v224,
                casterCharacter = character,
                characterType = p218.characterType
            });
        end;
    end;
end;

function v2.onStart(p225) -- Line: 1070
    -- upvalues: syncNeedleModelFromTemplate (copy)
    local v226 = p225.skillRunData.material["毒针"];

    if v226 and v226:IsA("Model") then
        syncNeedleModelFromTemplate(v226);
    end;
end;

function v2.Client_EnterStartup(p227) -- Line: 1077
    -- upvalues: syncNeedleModelFromTemplate (copy), setNeedleModelTransparency (copy), setupStartupTelegraphs (copy)
    if not p227.skillInputData.character then
        return;
    end;

    local v228 = p227.skillRunData.material["毒针"];

    if not v228 then
        return;
    end;

    syncNeedleModelFromTemplate(v228);
    v228.Parent = workspace.Debris;

    for i = 2, 5 do
        local v229 = i == 1 and "毒针" or "毒针" .. i;
        local skillRunData = p227.skillRunData;

        if skillRunData and skillRunData.material then
            local v230 = skillRunData.material[v229];

            if v230 and v230:IsA("Model") then
                skillRunData.material[v229] = nil;
                v230.Parent = nil;
                v230:Destroy();
            end;
        end;

        local v231 = v228:Clone();
        v231:SetAttribute("SpiderStingClone", true);
        syncNeedleModelFromTemplate(v231);
        p227.skillRunData.material[v229] = v231;
        v231.Parent = workspace.Debris;
    end;

    for i = 1, 5 do
        local v232 = p227.skillRunData.material[i == 1 and "毒针" or "毒针" .. i];

        if v232 then
            syncNeedleModelFromTemplate(v232);
            setNeedleModelTransparency(v232, 1);
            v232.Parent = nil;
        end;
    end;

    setupStartupTelegraphs(p227);
end;

function v2.Client_ExitStartup(p233) -- Line: 1115
    -- upvalues: AIM_RUN_EVENT_KEY (copy)
    local skillRunData = p233.skillRunData;

    if skillRunData then
        if not skillRunData.runEvent then
            return;
        end;

        local v234 = skillRunData.runEvent[AIM_RUN_EVENT_KEY];

        if v234 then
            v234:Disconnect();
            skillRunData.runEvent[AIM_RUN_EVENT_KEY] = nil;
        end;
    end;
end;

function v2.Server_EnterStartup(p235) -- Line: 1119
    for _, v in p235.hitbox do
        if v.hitbox then
            v.hitbox.Size = Vector3.new(1, 1, 6);

            if v then
                if v.hitbox then
                    v.hitbox.Transparency = 1;
                end;
            end;
        end;
    end;
end;

function v2.Client_EnterThrownMoving(u236) -- Line: 1132
    -- upvalues: resolveClientNeedlePaths (copy), deployFlightTelegraphs (copy), SoundModule (copy), syncNeedleModelFromTemplate (copy), setNeedleModelTransparency (copy), FXUtil (copy), finalizeThrownHitStop (copy), applyClientRicochetSegment (copy), RunService (copy), advanceProjectileMotion (copy), tryClientObstacleBounceOrStick (copy)
    local character = u236.skillInputData.character;

    if not character then
        return;
    end;

    local u237 = resolveClientNeedlePaths(u236, character);

    if #u237 == 0 then
        return;
    end;

    deployFlightTelegraphs(u236, u237);
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart");

    if HumanoidRootPart then
        SoundModule:PlaySoundLocal({
            SoundName = "音效-技能-剑-whoosh",
            Is2D = false,
            PlayPosition = HumanoidRootPart.Position
        });
    end;

    u236.skillRunData.Visual = u236.skillRunData.Visual or {};
    local u238 = {};
    local u239 = {};

    for _, v in u237 do
        local index = v.index;
        local v240 = u236.skillRunData.material[index == 1 and "毒针" or "毒针" .. index];

        if v240 then
            v240.Parent = workspace.Debris;
            v240:PivotTo(v.moveStart);
            syncNeedleModelFromTemplate(v240);
            setNeedleModelTransparency(v240, 1);

            if v240 and v240:IsA("Model") then
                FXUtil.Model_Fade_In(v240, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0);
            end;

            local v241 = {
                stopped = false,
                flightEnded = false,
                flightElapsed = 0,
                inFlight = false,
                inLinearFlight = false,
                bouncesRemaining = 0,
                segmentElapsed = 0,
                segmentDuration = 2,
                model = v240,
                flyDir = v.flyDir,
                lastFlightCF = v.moveStart,
                segmentStartCF = v.moveStart,
                segmentEndCF = v.moveEnd,
                lastPosition = v.moveStart.Position
            };
            u239[v.index] = v241;
            u238[v240] = v.moveStart.Position;
            v.thrownState = v241;
        end;
    end;

    u236.skillRunData.Visual.thrownProjectiles = u239;
    local pendingHitStops = u236.skillRunData.Visual.pendingHitStops;

    if pendingHitStops then
        u236.skillRunData.Visual.pendingHitStops = nil;

        for i, v in pendingHitStops do
            local v242 = u239[i];

            if v242 then
                finalizeThrownHitStop(v242, v);
            end;
        end;
    end;

    local pendingRicochets = u236.skillRunData.Visual.pendingRicochets;

    if pendingRicochets then
        u236.skillRunData.Visual.pendingRicochets = nil;

        for i, v in pendingRicochets do
            local v243 = u239[i];

            if v243 and v.newFlyDir then
                applyClientRicochetSegment(v243, v.hitPosition, v.newFlyDir);
            end;
        end;
    end;

    local v244 = true;

    for _, v in u239 do
        if v and not v.stopped then
            v244 = false;
            break;
        end;
    end;

    if v244 then
        return;
    end;

    local v245 = u236.skillRunData.runEvent["蜘蛛毒针客户端弹道"];

    if v245 then
        v245:Disconnect();
        u236.skillRunData.runEvent["蜘蛛毒针客户端弹道"] = nil;
    end;

    u236.skillRunData.runEvent["蜘蛛毒针客户端弹道"] = RunService.Heartbeat:Connect(function(p246) -- Line: 1219
        -- upvalues: u237 (copy), FXUtil (ref), advanceProjectileMotion (ref), u238 (copy), tryClientObstacleBounceOrStick (ref), character (copy), u239 (copy), u236 (copy)
        local v247 = true;

        for _, v in u237 do
            local thrownState = v.thrownState;
            local v248;

            if thrownState then
                v248 = thrownState.model;
            else
                v248 = thrownState;
            end;

            if v248 and (v248.Parent and not (thrownState.stopped or thrownState.flightEnded)) then
                v247 = false;
                thrownState.flightElapsed = (thrownState.flightElapsed or 0) + p246;

                if thrownState.flightElapsed >= 2 then
                    if not thrownState.stopped then
                        if not thrownState.flightEnded then
                            thrownState.flightEnded = true;
                            thrownState.stopped = true;
                            local model = thrownState.model;

                            if model and model.Parent then
                                FXUtil.Model_Fade(model, 0.1);
                            end;
                        end;
                    end;
                else
                    local v249 = advanceProjectileMotion(thrownState, p246);

                    if thrownState.inLinearFlight then
                        thrownState.linearFlightCF = v249;
                    end;

                    if not tryClientObstacleBounceOrStick(thrownState, character, v248, u238[v248] or v249.Position, v249) then
                        thrownState.inFlight = true;
                        thrownState.lastFlightCF = v249;
                        v248:PivotTo(v249);
                        u238[v248] = v249.Position;
                    end;
                end;
            end;
        end;

        local v250, v251;

        if v247 then
            v250 = u236;
            v251 = v250.skillRunData.runEvent["蜘蛛毒针客户端弹道"];

            if v251 then
                v251:Disconnect();
                v250.skillRunData.runEvent["蜘蛛毒针客户端弹道"] = nil;
            end;
        else
            local v252 = true;

            for _, v in u239 do
                if v and not v.stopped then
                    v252 = false;
                    break;
                end;
            end;

            if v252 then
                v250 = u236;
                v251 = v250.skillRunData.runEvent["蜘蛛毒针客户端弹道"];

                if v251 then
                    v251:Disconnect();
                    v250.skillRunData.runEvent["蜘蛛毒针客户端弹道"] = nil;
                end;
            end;
        end;
    end);
end;

function v2.Client_ExitThrownMoving(p253) -- Line: 1255
    -- upvalues: FXUtil (copy)
    local v254 = p253.skillRunData.runEvent["蜘蛛毒针客户端弹道"];

    if v254 then
        v254:Disconnect();
        p253.skillRunData.runEvent["蜘蛛毒针客户端弹道"] = nil;
    end;

    local skillRunData = p253.skillRunData;
    local v255 = skillRunData and skillRunData.Visual and skillRunData.Visual.thrownProjectiles;

    if not v255 then
        return;
    end;

    for _, v in v255 do
        if v and not (v.stopped or (v.flightEnded or v.stopped)) then
            if not v.flightEnded then
                v.flightEnded = true;
                v.stopped = true;
                local model = v.model;

                if model and model.Parent then
                    FXUtil.Model_Fade(model, 0.1);
                end;
            end;
        end;
    end;
end;

function v2.Server_EnterThrownMoving(u256) -- Line: 1269
    -- upvalues: buildNeedlePaths (copy), RunService (copy), advanceProjectileMotion (copy)
    local character = u256.character;

    if not character then
        return;
    end;

    local v257 = buildNeedlePaths(character);

    if #v257 == 0 then
        return;
    end;

    for _, v in v257 do
        u256:fireProjectilePathConfirmed(v.index, v.moveStart.Position, v.moveEnd.Position, v.flyDir);
    end;

    local v258 = character and character:GetScale() or 1;
    local v259 = {};

    for _, v in v257 do
        local v260 = u256.hitbox[v.index];

        if v260 and v260.hitbox then
            v260:start();

            if v260 and v260.hitbox then
                v260.hitbox.Transparency = 1;
            end;

            local hitbox = v260.hitbox;
            hitbox.Size = hitbox.Size * v258;
            hitbox:PivotTo(v.moveStart);
            table.insert(v259, {
                index = v.index,
                hitbox = v260,
                part = hitbox,
                moveStart = v.moveStart,
                moveEnd = v.moveEnd
            });
        end;
    end;

    if #v259 == 0 then
        return;
    end;

    u256.skillRunData.Logic = u256.skillRunData.Logic or {};
    u256.skillRunData.Logic.hitboxPaths = v259;
    u256.skillRunData.Logic.projectiles = {};

    for _, v in v259 do
        local v261 = {
            bouncesRemaining = 0,
            stuck = false,
            flightEnded = false,
            flightElapsed = 0,
            inLinearFlight = false,
            segmentElapsed = 0,
            segmentDuration = 2,
            flyDir = v.moveEnd.Position - v.moveStart.Position,
            segmentStartCF = v.moveStart,
            segmentEndCF = v.moveEnd,
            lastPosition = v.moveStart.Position
        };

        if v261.flyDir.Magnitude > 0.0001 then
            v261.flyDir = v261.flyDir.Unit;
        else
            v261.flyDir = v.moveStart.LookVector;
        end;

        u256.skillRunData.Logic.projectiles[v.index] = v261;
    end;

    local v262 = u256.skillRunData.runEvent["蜘蛛毒针服务端弹道"];

    if v262 then
        v262:Disconnect();
        u256.skillRunData.runEvent["蜘蛛毒针服务端弹道"] = nil;
    end;

    u256.skillRunData.runEvent["蜘蛛毒针服务端弹道"] = RunService.Heartbeat:Connect(function(p263) -- Line: 1344
        -- upvalues: u256 (copy), advanceProjectileMotion (ref)
        local Logic = u256.skillRunData.Logic;

        if not (Logic and (Logic.projectiles and Logic.hitboxPaths)) then
            return;
        end;

        local v264 = math.clamp(p263, 0, 0.1);

        for _, v in Logic.hitboxPaths do
            local v265 = Logic.projectiles[v.index];

            if v265 and not (v265.stuck or v265.flightEnded) then
                v265.flightElapsed = (v265.flightElapsed or 0) + v264;

                if v265.flightElapsed >= 2 then
                    if not v265.stuck then
                        if not v265.flightEnded then
                            v265.flightEnded = true;

                            if v.hitbox and v.hitbox.isActive then
                                v.hitbox:stop();
                                local hitbox = v.hitbox;

                                if hitbox then
                                    if hitbox.hitbox then
                                        hitbox.hitbox.Transparency = 1;
                                    end;
                                end;
                            end;
                        end;
                    end;
                else
                    local v266 = advanceProjectileMotion(v265, v264);

                    if v265.inLinearFlight then
                        v265.linearFlightCF = v266;
                    end;

                    v.part:PivotTo(v266);
                end;
            end;
        end;
    end);
end;

function v2.Server_ExitThrownMoving(p267) -- Line: 1369
    local v268 = p267.skillRunData.runEvent["蜘蛛毒针服务端弹道"];

    if v268 then
        v268:Disconnect();
        p267.skillRunData.runEvent["蜘蛛毒针服务端弹道"] = nil;
    end;

    for i = 1, 5 do
        local v269 = p267.hitbox[i];

        if v269 and v269.isActive then
            v269:stop();
        end;

        if v269 then
            if v269.hitbox then
                v269.hitbox.Transparency = 1;
            end;
        end;
    end;
end;

function v2.Client_EnterRecovery(p270) -- Line: 1384
    -- upvalues: SkillTelegraph (copy)
    SkillTelegraph.destroyAllInRunData(p270.skillRunData);
end;

function v2.Client_EnterInterrupted(p271) -- Line: 1388
    -- upvalues: SkillTelegraph (copy)
    SkillTelegraph.destroyAllInRunData(p271.skillRunData);
end;

function v2.Server_EnterRecovery(p272) -- Line: 1392
    p272:releaseControl();
end;

function v2.Server_UpdateProjectileObstacleCheck(p273) -- Line: 1400
    -- upvalues: isIgnoredObstacleHit (copy), performServerRicochet (copy), buildStopCFrame (copy), SkillEventConst (copy)
    local skillRunData = p273.skillRunData;

    if not skillRunData or skillRunData.State.current ~= "ThrownMoving" then
        return;
    end;

    local Logic = skillRunData.Logic;

    if not (Logic and (Logic.projectiles and Logic.hitboxPaths)) then
        return;
    end;

    for _, v in Logic.hitboxPaths do
        local index = v.index;
        local v274 = Logic.projectiles[index];

        if v274 and not (v274.stuck or v274.flightEnded) then
            local part = v.part;
            local Position = part.Position;
            local v275 = v274.lastPosition or Position;
            local v276 = Position - v275;

            if v276.Magnitude < 0.01 then
                v274.lastPosition = Position;
            else
                local v277 = RaycastParams.new();
                v277.FilterType = Enum.RaycastFilterType.Exclude;
                local v278;

                if typeof(part) == "Instance" then
                    v278 = { p273.character, part };
                else
                    v278 = { p273.character };
                end;

                v277.FilterDescendantsInstances = v278;
                local v279 = workspace:Raycast(v275, v276, v277);

                if v279 then
                    local Instance = v279.Instance;

                    if Instance then
                        Instance = Instance.Parent;
                    end;

                    local v280;

                    if Instance == nil then
                        v280 = false;
                    else
                        v280 = Instance:IsA("Model") and Instance:FindFirstChildOfClass("Humanoid") ~= nil;
                    end;

                    if v280 then
                        v274.lastPosition = Position;
                    elseif isIgnoredObstacleHit(v279.Instance, v274) then
                        v274.lastPosition = Position;
                    elseif not performServerRicochet(p273, v274, v, v279.Position, v279.Normal, v279.Instance, index) then
                        v274.stuck = true;
                        part:PivotTo(buildStopCFrame(v279.Position, v279.Normal, v274.flyDir));
                        v.hitbox:stop();
                        local hitbox = v.hitbox;

                        if hitbox and hitbox.hitbox then
                            hitbox.hitbox.Transparency = 1;
                        end;

                        p273:fireProjectileHitConfirmed(v279.Position, SkillEventConst.HitType.Obstacle, nil, {
                            hitNormal = v279.Normal,
                            projectileIndex = index
                        });
                    end;
                else
                    v274.lastPosition = Position;
                end;
            end;
        end;
    end;
end;

function v2.onProjectileHitServer(p281, p282, p283) -- Line: 1471
    -- upvalues: HitResolver (copy)
    local Logic = p281.skillRunData.Logic;

    if not (Logic and Logic.projectiles) then
        return;
    end;

    local v284 = Logic.projectiles[p282.hitboxIndex];

    if not v284 or (v284.stuck or v284.flightEnded) then
        return;
    end;

    for i, v in p283 do
        HitResolver.applyHit(p281, p282, v, i);
    end;
end;

function v2.onServerEvent(p285, p286) -- Line: 1488
    -- upvalues: ShootProjectilePathSync (copy), SkillEventConst (copy), applyClientRicochetSegment (copy), finalizeThrownHitStop (copy)
    if ShootProjectilePathSync.handleServerEvent(p285, p286) then
        return;
    end;

    if p286.eventType ~= SkillEventConst.SyncEventType.ProjectileHitConfirmed then
        return;
    end;

    local skillRunData = p285.skillRunData;

    if not skillRunData then
        return;
    end;

    skillRunData.Visual = skillRunData.Visual or {};
    local v287 = p286.projectileIndex or 1;
    local thrownProjectiles = skillRunData.Visual.thrownProjectiles;

    if thrownProjectiles then
        thrownProjectiles = thrownProjectiles[v287];
    end;

    if p286.ricochet then
        if p286.newFlyDir and thrownProjectiles then
            local bouncesRemaining = p286.bouncesRemaining;

            if type(bouncesRemaining) ~= "number" and true or bouncesRemaining < thrownProjectiles.bouncesRemaining then
                local hitPart = p286.hitPart;

                if typeof(hitPart) == "Instance" and hitPart:IsA("BasePart") then
                    thrownProjectiles.ignoreObstaclePart = hitPart;
                    local v288;

                    if hitPart then
                        v288 = hitPart.Parent;

                        if not (v288 and v288:IsA("Model")) then
                            v288 = nil;
                        end;
                    else
                        v288 = nil;
                    end;

                    thrownProjectiles.ignoreObstacleModel = v288;
                    thrownProjectiles.ignoreObstacleUntil = os.clock() + 0.15;
                end;

                applyClientRicochetSegment(thrownProjectiles, p286.hitPosition, p286.newFlyDir);
            end;

            if type(bouncesRemaining) == "number" then
                thrownProjectiles.bouncesRemaining = bouncesRemaining;

                return;
            end;
        else
            skillRunData.Visual.pendingRicochets = skillRunData.Visual.pendingRicochets or {};
            skillRunData.Visual.pendingRicochets[v287] = p286;
        end;

        return;
    end;

    if p286.hitType ~= SkillEventConst.HitType.Obstacle then
        return;
    end;

    if thrownProjectiles then
        finalizeThrownHitStop(thrownProjectiles, p286);

        return;
    end;

    skillRunData.Visual.pendingHitStops = skillRunData.Visual.pendingHitStops or {};
    skillRunData.Visual.pendingHitStops[v287] = p286;
end;

function v2.onEnd(p289) -- Line: 1540
    -- upvalues: SkillTelegraph (copy), cleanupThrownProjectileVisual (copy)
    SkillTelegraph.destroyAllInRunData(p289.skillRunData);
    cleanupThrownProjectileVisual(p289);
end;

function v2.onClearRunData(p290, p291) -- Line: 1545
    -- upvalues: SkillTelegraph (copy)
    if not p291 then
        return;
    end;

    SkillTelegraph.destroyAllInRunData(p291);

    if p291.Logic then
        p291.Logic.needleTelegraphGroundY = nil;
    end;

    for i = 1, 5 do
        local v292 = i == 1 and "毒针" or "毒针" .. i;

        if p291 then
            if p291.material then
                local v293 = p291.material[v292];

                if v293 then
                    if v293:IsA("Model") then
                        p291.material[v292] = nil;
                        v293.Parent = nil;
                        v293:Destroy();
                    end;
                end;
            end;
        end;
    end;
end;

local v294 = {
    hitOncePerTarget = true,
    canPierceEnemy = true,
    stopOnFirstEnemy = false,
    stopOnObstacle = false
};
local v295 = {};

for i = 1, 5 do
    table.insert(v295, {
        PartName = "通用长方体",
        CollisionGroup = "Player",
        HitPresentationProfile = "通用受击",
        PhysicsEffectName = "通用受击物理效果",
        HitboxIndex = i,
        HitPolicy = v294
    });
end;

v2.SoundList = { "音效-技能-剑-whoosh" };
v2.AnimateList = { "蜘蛛毒针" };
v2.ResNameList = { "毒针", "毒针齐射弹射特效" };
v2.hitboxConfig = v295;
v2.Action = {
    {
        action = "LookAt",
        startTime = 0,
        overTime = 0.7,
        speedType = "RELEASE_SKILL_STATE_HALF"
    },
    {
        action = "Animation",
        startTime = 0,
        overTime = 1.6,
        animationName = "蜘蛛毒针",
        animationSpeed = 1,
        animationFadeTime = 0.1,
        animationPriority = Enum.AnimationPriority.Action4
    }
};

return v2;