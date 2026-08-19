-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Pipeline = require(ReplicatedStorage.Directory.Animations.Pipeline);
local SimplePath = require(ReplicatedStorage.Library.Modules.SimplePath);
require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Asserts = require(ReplicatedStorage.Library.Asserts);
local wcall = require(ReplicatedStorage.Library.Functions.wcall);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u2 = {};
u2.__index = u2;
local Heartbeat = RunService.Heartbeat;

local function getRaycastFilterList() -- Line: 74
    return { workspace.Map.FloorParts };
end;

local function getCFrameFromTarget(p3) -- Line: 80
    if typeof(p3) == "CFrame" then
        return p3;
    end;

    if typeof(p3) == "Vector3" then
        return CFrame.new(p3);
    end;

    return p3.CFrame;
end;

local function loadMovementTrack(p4, p5) -- Line: 91
    -- upvalues: Pipeline (copy)
    if p5 == nil then
        return nil;
    end;

    local v6 = p4:LoadAnimation(Pipeline:GetAndSerializeAnimation(p5).anim);
    v6.Looped = true;

    return v6;
end;

local function setupMovementAnimations(p7, u8, p9) -- Line: 102
    -- upvalues: Pipeline (copy)
    if u8.IdleAnimationId == nil and u8.WalkAnimationId == nil then
        return;
    end;

    local v10 = p7:FindFirstChildOfClass("Animator");

    if not v10 then
        v10 = Instance.new("Animator");
        v10.Parent = p7;
        p9:Add(v10);
    end;

    local IdleAnimationId = u8.IdleAnimationId;
    local u11;

    if IdleAnimationId == nil then
        u11 = nil;
    else
        u11 = v10:LoadAnimation(Pipeline:GetAndSerializeAnimation(IdleAnimationId).anim);
        u11.Looped = true;
    end;

    local WalkAnimationId = u8.WalkAnimationId;
    local u12;

    if WalkAnimationId == nil then
        u12 = nil;
    else
        u12 = v10:LoadAnimation(Pipeline:GetAndSerializeAnimation(WalkAnimationId).anim);
        u12.Looped = true;
    end;

    local u13 = false;

    local function setWalking(p14, p15) -- Line: 121
        -- upvalues: u13 (ref), u11 (copy), u12 (copy), u8 (copy)
        if u13 == p14 and p14 == false then
            return;
        end;

        u13 = p14;

        if p14 then
            if u11 and u11.IsPlaying then
                u11:Stop(0.15);
            end;

            if u12 then
                u12:AdjustSpeed((math.clamp(p15 / 16 * (u8.WalkAnimationSpeedMultiplier or 1), 0.65, 2)));

                if not u12.IsPlaying then
                    u12:Play(0.15);
                end;
            end;

            return;
        end;

        if u12 and u12.IsPlaying then
            u12:Stop(0.15);
        end;

        if u11 and not u11.IsPlaying then
            u11:Play(0.15);
        end;
    end;

    if u11 then
        u11:Play(0.15);
    end;

    p9:Add(p7.Running:Connect(function(p16) -- Line: 155
        -- upvalues: setWalking (copy)
        setWalking(p16 > 0.5, p16);
    end));
    p9:Add(function() -- Line: 158
        -- upvalues: u11 (copy), u12 (copy)
        if u11 then
            u11:Stop();
            u11:Destroy();
        end;

        if u12 then
            u12:Stop();
            u12:Destroy();
        end;
    end);
end;

local function stopActivePath(p17) -- Line: 170
    -- upvalues: SimplePath (copy)
    if p17._path.Status == SimplePath.StatusType.Active then
        p17._path:Stop();
    end;
end;

local function cleanupPrecisionMove(p18) -- Line: 176
    if p18._precisionMoveConnection then
        p18._precisionMoveConnection:Disconnect();
        p18._precisionMoveConnection = nil;
    end;
end;

local function rotateTowardsDirection(p19, p20, p21) -- Line: 183
    -- upvalues: Heartbeat (copy)
    if not p19.Parent then
        return false;
    end;

    local v22 = Vector3.new(p20.X, 0, p20.Z);

    if v22.Magnitude < 0.01 then
        return true;
    end;

    local Unit = v22.Unit;
    local v23 = p19:GetPivot();
    local Position = v23.Position;
    local v24 = CFrame.lookAt(Position, Position + Unit);
    local LookVector = v23.LookVector;
    local v25 = Vector3.new(LookVector.X, 0, LookVector.Z).Unit:Dot(Unit);
    local v26 = math.clamp(v25, -1, 1);

    if math.acos(v26) < 0.08726646259971647 then
        return true;
    end;

    local v27 = 0;

    while v27 < p21 and p19.Parent do
        v27 = v27 + Heartbeat:Wait();
        local v28 = math.min(v27 / p21, 1);
        p19:PivotTo((v23:Lerp(v24, v28 * v28 * (3 - v28 * 2))));
    end;

    p19:PivotTo(v24);

    return true;
end;

local function applyFinalPositioning(p29, p30) -- Line: 222
    -- upvalues: rotateTowardsDirection (copy), u1 (copy), Heartbeat (copy)
    if not p29._model.Parent then
        return false;
    end;

    local Position = p29._model:GetPivot().Position;
    local Position2 = p30.Position;
    local v31 = Vector3.new(Position2.X, Position.Y, Position2.Z);
    p29._humanoid:MoveTo(Position);
    local Magnitude = (Position - v31).Magnitude;

    if Magnitude <= 0.2 then
        rotateTowardsDirection(p29._model, p30.LookVector, 0.35);

        return true;
    end;

    if Magnitude <= 2 then
        u1:AtInfo():Log((`[NPCMovement] Close to target (distance: {math.floor(Magnitude * 100) / 100}), quick adjustment`));
        p29._humanoid:MoveTo(p29._rootPart.Position);
        local v32 = 0;

        while v32 < 0.1 and p29._model.Parent do
            v32 = v32 + Heartbeat:Wait();

            if (p29._rootPart.Position - v31).Magnitude <= 0.2 then
                break;
            end;
        end;

        rotateTowardsDirection(p29._model, p30.LookVector, 0.35);

        return true;
    end;

    u1:AtWarning():Log((`[NPCMovement] Far from target (distance: {math.floor(Magnitude * 100) / 100}), full movement`));
    p29._humanoid:MoveTo(v31);
    local v33 = 0;

    while v33 < 2 and p29._model.Parent do
        v33 = v33 + Heartbeat:Wait();

        if (p29._rootPart.Position - v31).Magnitude <= 0.2 then
            break;
        end;
    end;

    p29._humanoid:MoveTo(p29._rootPart.Position);
    rotateTowardsDirection(p29._model, p30.LookVector, 0.175);
    u1:AtInfo():Log("[NPCMovement] Final positioning complete");

    return true;
end;

local function cleanupMoveToFinished(p34) -- Line: 298
    if p34._moveToFinishedConnection then
        p34._moveToFinishedConnection:Disconnect();
        p34._moveToFinishedConnection = nil;
    end;
end;

local function directMoveTo(p35, p36) -- Line: 305
    -- upvalues: Heartbeat (copy)
    local v37 = Vector3.new(p36.X, p35._rootPart.Position.Y, p36.Z);
    p35._humanoid:MoveTo(v37);
    local u38 = false;

    if p35._moveToFinishedConnection then
        p35._moveToFinishedConnection:Disconnect();
        p35._moveToFinishedConnection = nil;
    end;

    p35._moveToFinishedConnection = p35._humanoid.MoveToFinished:Connect(function(p39) -- Line: 314
        -- upvalues: u38 (ref)
        u38 = p39;
    end);
    local v40 = 0;

    while not u38 and (p35._model.Parent and (p35._isMoving and v40 < 10)) do
        v40 = v40 + Heartbeat:Wait();
    end;

    if p35._moveToFinishedConnection then
        p35._moveToFinishedConnection:Disconnect();
        p35._moveToFinishedConnection = nil;
    end;

    return u38;
end;

function u2.ensureRobotOnGround(p41) -- Line: 327
    local v42 = p41.rootPart.Position + Vector3.new(0, 2, 0);
    local v43 = RaycastParams.new();
    v43.FilterType = Enum.RaycastFilterType.Include;
    v43.FilterDescendantsInstances = { workspace.Map.FloorParts };
    v43.IgnoreWater = true;
    local v44 = workspace:Raycast(v42, Vector3.new(0, -10, 0), v43);

    if v44 then
        local v45 = v44.Position + Vector3.new(0, p41.humanoid.HipHeight or 0, 0);
        local v46 = p41.model:GetPivot();
        local v47 = CFrame.new(v45) * (v46 - v46.Position);
        p41.model:PivotTo(v47);
    end;
end;

function u2.new(p48, p49, p50) -- Line: 350
    -- upvalues: Asserts (copy), u1 (copy), Constants (copy), wcall (copy), SimplePath (copy), setupMovementAnimations (copy), u2 (copy), applyFinalPositioning (copy)
    Asserts.Model(p48);
    Asserts.table(p49);
    local PrimaryPart = p48.PrimaryPart;

    if not PrimaryPart then
        u1:AtError():Log("[NPCMovement] Model missing PrimaryPart");

        return nil;
    end;

    local v51 = p48:FindFirstChildOfClass("Humanoid");

    if not v51 then
        u1:AtError():Log("[NPCMovement] Model missing Humanoid");

        return nil;
    end;

    if Constants.IS_SERVER then
        wcall(function() -- Line: 367
            -- upvalues: PrimaryPart (copy)
            PrimaryPart:SetNetworkOwner(nil);
        end);
    end;

    local u52 = SimplePath.new(p48, p49.PathfindingAgentParams or {
        AgentRadius = 2,
        AgentHeight = 5,
        AgentCanJump = false,
        AgentCanClimb = false,
        WaypointSpacing = 4,
        Costs = {
            Water = (1 / 0)
        }
    });
    u52.Visualize = false;
    setupMovementAnimations(v51, p49, p50);
    local BindableEvent = Instance.new("BindableEvent");
    p50:Add(function() -- Line: 391
        -- upvalues: BindableEvent (copy), u52 (copy)
        BindableEvent:Destroy();
        u52:Destroy();
    end);
    local u53 = setmetatable({
        _isMoving = false,
        _targetPosition = nil,
        _targetCFrame = nil,
        _currentRequest = nil,
        _precisionMoveConnection = nil,
        _moveToFinishedConnection = nil,
        _initialRotationComplete = false,
        _model = p48,
        _config = p49,
        _trove = p50,
        _path = u52,
        _humanoid = v51,
        _rootPart = PrimaryPart,
        _moveCompleteSignal = BindableEvent
    }, u2);
    p50:Add(u52.Reached:Connect(function() -- Line: 413
        -- upvalues: u53 (copy), applyFinalPositioning (ref)
        if not (u53._isMoving and u53._targetCFrame) then
            return;
        end;

        u53:_onMoveComplete((applyFinalPositioning(u53, u53._targetCFrame)));
    end));
    p50:Add(u52.Blocked:Connect(function() -- Line: 422
        -- upvalues: u1 (ref), u53 (copy), u52 (copy)
        u1:AtWarning():Log("[NPCMovement] Path blocked, attempting recompute");

        if u53._targetPosition and u53._isMoving then
            task.wait(0.5);

            if u53._isMoving and (u53._targetPosition and not u52:Run(u53._targetPosition)) then
                u1:AtError():Log("[NPCMovement] Failed to recompute path after block");
                u53:_onMoveComplete(false);
            end;
        end;
    end));
    p50:Add(u52.Error:Connect(function(p54) -- Line: 438
        -- upvalues: u1 (ref), u53 (copy), SimplePath (ref), u52 (copy)
        u1:AtError():Log((`[NPCMovement] Path error: {p54}`));

        if u53._targetPosition and (u53._isMoving and p54 ~= SimplePath.ErrorType.ComputationError) then
            task.wait(0.5);

            if u53._isMoving and (u53._targetPosition and not u52:Run(u53._targetPosition)) then
                u53:_onMoveComplete(false);
            end;
        else
            u53:_onMoveComplete(false);
        end;
    end));

    return u53;
end;

function u2._onMoveComplete(p55, p56) -- Line: 458
    -- upvalues: SimplePath (copy)
    if not p55._isMoving then
        return;
    end;

    p55._isMoving = false;
    p55._initialRotationComplete = false;

    if p55._path.Status == SimplePath.StatusType.Active then
        p55._path:Stop();
    end;

    if p55._moveToFinishedConnection then
        p55._moveToFinishedConnection:Disconnect();
        p55._moveToFinishedConnection = nil;
    end;

    if p55._precisionMoveConnection then
        p55._precisionMoveConnection:Disconnect();
        p55._precisionMoveConnection = nil;
    end;

    local _currentRequest = p55._currentRequest;
    p55._currentRequest = nil;
    p55._targetCFrame = nil;
    p55._targetPosition = nil;

    if _currentRequest and _currentRequest.callback then
        task.spawn(_currentRequest.callback, p56);
    end;

    p55._moveCompleteSignal:Fire(p56);
end;

function u2.MoveTo(u57, p58, p59) -- Line: 481
    -- upvalues: u1 (copy), applyFinalPositioning (copy), rotateTowardsDirection (copy), directMoveTo (copy)
    if u57._isMoving then
        u1:AtWarning():Log("[NPCMovement] Already moving, stopping previous");
        u57:Stop();
    end;

    local u60;

    if typeof(p58) == "CFrame" then
        u60 = p58;
    elseif typeof(p58) == "Vector3" then
        u60 = CFrame.new(p58);
    else
        u60 = p58.CFrame;
    end;

    local Position = u60.Position;
    local Magnitude = (u57._rootPart.Position - Position).Magnitude;

    if Magnitude <= 0.2 then
        u1:AtInfo():Log("[NPCMovement] Already at target");
        applyFinalPositioning(u57, u60);

        if p59 then
            task.spawn(p59, true);
        end;

        return true;
    end;

    u57._isMoving = true;
    u57._initialRotationComplete = false;
    u57._targetCFrame = u60;
    u57._targetPosition = Position;
    u57._currentRequest = {
        target = p58,
        callback = p59
    };
    task.spawn(function() -- Line: 513
        -- upvalues: Position (copy), u57 (copy), u1 (ref), rotateTowardsDirection (ref), Magnitude (copy), directMoveTo (ref), applyFinalPositioning (ref), u60 (copy)
        local v61 = Position - u57._rootPart.Position;
        u1:AtInfo():Log("[NPCMovement] Rotating towards target");
        rotateTowardsDirection(u57._model, v61, 0.35);

        if not u57._isMoving then
            return;
        end;

        u57._initialRotationComplete = true;

        if Magnitude <= 5 then
            u1:AtInfo():Log("[NPCMovement] Close target, direct movement");
            local v62 = directMoveTo(u57, Position);

            if v62 then
                applyFinalPositioning(u57, u60);
            end;

            u57:_onMoveComplete(v62);

            return;
        end;

        u1:AtInfo():Log("[NPCMovement] Using pathfinding");

        if u57._path:Run(Position) then
            task.spawn(function() -- Line: 554
                -- upvalues: u57 (ref)
                while u57._isMoving do
                    task.wait(0.5);

                    if not u57._isMoving then
                        break;
                    end;
                end;
            end);

            return;
        end;

        u1:AtError():Log("[NPCMovement] Pathfinding failed");

        if Magnitude > 10 then
            u57:_onMoveComplete(false);

            return;
        end;

        u1:AtInfo():Log("[NPCMovement] Fallback to direct movement");
        local v63 = directMoveTo(u57, Position);

        if v63 then
            applyFinalPositioning(u57, u60);
        end;

        u57:_onMoveComplete(v63);
    end);

    return true;
end;

function u2.MoveToAsync(p64, p65) -- Line: 567
    local u66 = false;
    local u67 = false;
    p64:MoveTo(p65, function(p68) -- Line: 571
        -- upvalues: u66 (ref), u67 (ref)
        u66 = p68;
        u67 = true;
    end);

    while not u67 and p64._isMoving do
        task.wait(0.1);
    end;

    return u66;
end;

function u2.Stop(p69) -- Line: 583
    -- upvalues: u1 (copy), SimplePath (copy)
    if not p69._isMoving then
        return;
    end;

    u1:AtInfo():Log("[NPCMovement] Stopping");
    p69._isMoving = false;
    p69._initialRotationComplete = false;

    if p69._path.Status == SimplePath.StatusType.Active then
        p69._path:Stop();
    end;

    if p69._moveToFinishedConnection then
        p69._moveToFinishedConnection:Disconnect();
        p69._moveToFinishedConnection = nil;
    end;

    if p69._precisionMoveConnection then
        p69._precisionMoveConnection:Disconnect();
        p69._precisionMoveConnection = nil;
    end;

    p69._humanoid:MoveTo(p69._rootPart.Position);
    local _currentRequest = p69._currentRequest;
    p69._currentRequest = nil;
    p69._targetCFrame = nil;
    p69._targetPosition = nil;

    if _currentRequest and _currentRequest.callback then
        task.spawn(_currentRequest.callback, false);
    end;
end;

function u2.IsMoving(p70) -- Line: 608
    return p70._isMoving;
end;

function u2.GetMoveCompleteSignal(p71) -- Line: 612
    return p71._moveCompleteSignal.Event;
end;

return u2;