-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Asserts = require(ReplicatedStorage.Library.Asserts);
require(ReplicatedStorage.Directory.Guards.Types.Interface);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Player = require(ReplicatedStorage.Library.Player);
local WaitFor = require(ReplicatedStorage.Library.Modules.Packages.WaitFor);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GuardDistance = require(script.Parent.GuardDistance);
local GuardChasePolicy = require(script.Parent.GuardChasePolicy);
local GuardEggRetrievalComponent = require(script.Parent.GuardEggRetrievalComponent);
local GuardMovementRecovery = require(script.Parent.GuardMovementRecovery);
local GuardPresentationComponent = require(script.Parent.GuardPresentationComponent);
local GuardReturnHomeDistanceResolver = require(script.Parent.GuardReturnHomeDistanceResolver);
require(script.Parent.Types.Interface);
local CollisionGroups = require(ReplicatedStorage.Library.Types.CollisionGroups);
local u1 = {};
u1.__index = u1;
u1.__class = "GuardComponent";
u1.ATTACK_MIN_INTERVAL = 0.75;
local ATTACK_MIN_INTERVAL = u1.ATTACK_MIN_INTERVAL;
local u2 = Log.new();

function u1.new(p3, p4, p5, p6, p7, p8, p9) -- Line: 85
    -- upvalues: u1 (copy), Asserts (copy), WaitFor (copy), Constants (copy), CollisionGroups (copy), GuardEggRetrievalComponent (copy), GuardMovementRecovery (copy), GuardPresentationComponent (copy)
    local v10 = setmetatable({}, u1);
    Asserts.string(p3);
    Asserts.Model(p4);
    Asserts.BasePart(p5);
    Asserts.BasePart(p6);
    Asserts.table(p7);
    Asserts.func(p8);
    Asserts.table(p9);
    Asserts.func(p9.Attack);
    Asserts.boolean(p9.ServerOwnsPhysics);
    Asserts.func(p9.Wake);
    local v11, v12 = WaitFor.Descendant(p4, "Humanoid", Constants.STUDIO_YIELD_TIMEOUT):await();
    local v13, v14 = WaitFor.Descendant(p4, "Animator", Constants.STUDIO_YIELD_TIMEOUT):await();
    local HumanoidRootPart = p4:WaitForChild("HumanoidRootPart", Constants.STUDIO_YIELD_TIMEOUT);
    local Collider = p4:WaitForChild("Collider", Constants.STUDIO_YIELD_TIMEOUT);
    local v15, v16 = WaitFor.Descendant(p4, "Head", Constants.STUDIO_YIELD_TIMEOUT):await();
    local v17 = `Failed to resolve Humanoid under {p4:GetFullName()}: {tostring(v12)}`;
    assert(v11, v17);
    local v18 = `Failed to resolve Animator under {p4:GetFullName()}: {tostring(v14)}`;
    assert(v13, v18);
    local v19 = `Failed to resolve HumanoidRootPart under {p4:GetFullName()}: {tostring(HumanoidRootPart)}`;
    assert(HumanoidRootPart, v19);
    local v20 = `Failed to resolve Collider under {p4:GetFullName()}`;
    assert(Collider, v20);
    local v21 = `Failed to resolve Head under {p4:GetFullName()}: {tostring(v16)}`;
    assert(v15, v21);
    local v22 = v12:IsA("Humanoid");
    local v23 = `{p4:GetFullName()}.Humanoid must be a Humanoid`;
    assert(v22, v23);
    local v24 = v14:IsA("Animator");
    local v25 = `{p4:GetFullName()}.Animator must be an Animator`;
    assert(v24, v25);
    local v26 = HumanoidRootPart:IsA("BasePart");
    local v27 = `{p4:GetFullName()}.HumanoidRootPart must be a BasePart`;
    assert(v26, v27);
    local v28 = Collider:IsA("BasePart");
    local v29 = `{p4:GetFullName()}.Collider must be a BasePart`;
    assert(v28, v29);

    if Constants.IS_STUDIO and (v14.Parent == v12 and not p4:FindFirstChild("Model")) then
        error((`Animator has to be parented to the animation controller for {p4:GetFullName()}`));
    end;

    local CurrentPhysicalProperties = Collider.CurrentPhysicalProperties;
    Collider.CustomPhysicalProperties = PhysicalProperties.new(0.01, CurrentPhysicalProperties.Friction, CurrentPhysicalProperties.Elasticity, CurrentPhysicalProperties.FrictionWeight, CurrentPhysicalProperties.ElasticityWeight);

    for _, descendant in p4:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = false;
            descendant.CollisionGroup = CollisionGroups.GUARD_COLLISION_GROUP;
        end;
    end;

    v10._areaId = p3;
    v10._attackHandler = p9.Attack;
    v10._bounds = p5;
    v10._config = p7;
    v10._eggRetrieval = GuardEggRetrievalComponent.new(p4, HumanoidRootPart, HumanoidRootPart.CFrame);
    v10._currentMoveTo = nil;
    v10._guardModel = p4;
    v10._homeCFrame = HumanoidRootPart.CFrame;
    v10._humanoid = v12;
    v10._lastAttackTime = 0;
    v10._lastNetworkOwnerRetry = (-1 / 0);
    v10._lastTargetRefresh = 0;
    v10._movementRecovery = GuardMovementRecovery.new(HumanoidRootPart, p6);
    v10._attackResumeTime = 0;
    v10._ragdollEndTime = 0;
    v10._presentation = GuardPresentationComponent.new(HumanoidRootPart, v14, p7);
    v10._root = HumanoidRootPart;
    v10._serverOwnsPhysics = p9.ServerOwnsPhysics;
    v10._sleepTurnConnection = nil;
    v10._sleepTurnFromCFrame = nil;
    v10._sleepTurnStartTime = 0;
    v10._state = "Sleeping";
    v10._stolenEggUidByPlayer = {};
    v10._stolenPlayerByEggUid = {};
    v10._stolenPriorityByEggUid = {};
    v10._targetPlayer = nil;
    v10._targetResolver = p8;
    v10._wakeHandler = p9.Wake;
    v10._wakingStartedAt = 0;
    v10._walkResumeTime = 0;
    p4:SetAttribute("TargetPlayer", "");
    p4:SetAttribute("Sleeping", false);
    p4:SetAttribute("GuardState", "");
    p4:SetAttribute("AreaId", p3);
    p4:SetAttribute("WakeTargetPlayer", "");
    v12.WalkSpeed = p7.WalkSpeed;
    v12:SetStateEnabled(Enum.HumanoidStateType.Dead, false);
    v10:_trySetNetworkOwner(os.clock(), true);
    v10:_enterSleepState();

    return v10;
end;

function u1._setState(p30, p31) -- Line: 205
    p30._state = p31;

    if p31 ~= "Chasing" then
        p30._presentation:CancelAfterWake();
    end;
end;

function u1._isHitPaused(p32, p33) -- Line: 212
    -- upvalues: Asserts (copy)
    Asserts.number(p33);

    return p33 < math.max(p32._walkResumeTime, p32._attackResumeTime);
end;

function u1._enterSleepState(p34) -- Line: 218
    p34:_setState("Sleeping");
    p34._targetPlayer = nil;
    p34._currentMoveTo = nil;
    p34._movementRecovery:Reset();
    p34:_cancelSleepTurn();
    p34._wakingStartedAt = 0;
    p34._root.Anchored = false;
    p34._root.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    p34._root.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p34._guardModel:PivotTo(p34._homeCFrame);
    p34._root.AssemblyAngularVelocity = Vector3.new(0, 0, 0);
    p34._root.AssemblyLinearVelocity = Vector3.new(0, 0, 0);
    p34._humanoid.WalkSpeed = 0;
    p34._humanoid:Move(Vector3.new(0, 0, 0), false);
    p34._guardModel:SetAttribute("Sleeping", true);
    p34._guardModel:SetAttribute("TargetPlayer", "");
    p34._guardModel:SetAttribute("WakeTargetPlayer", "");
    p34._guardModel:SetAttribute("GuardState", p34._state);
    p34._presentation:StopWalkAnimation();
    p34._presentation:StopIdleAnimation();
    p34._presentation:StopFootstepSound();
    p34._presentation:PlaySleep(0.75);
end;

function u1._enterWakingState(p35, p36) -- Line: 243
    -- upvalues: Asserts (copy)
    Asserts.number(p36);

    if p35._state == "Waking" then
        return;
    end;

    p35:_cancelSleepTurn();
    p35:_setTarget(nil);
    p35:_setState("Waking");
    p35._currentMoveTo = nil;
    p35._movementRecovery:Reset();
    p35._wakingStartedAt = p36;
    p35._guardModel:SetAttribute("TargetPlayer", "");
    p35._guardModel:SetAttribute("GuardState", p35._state);
    p35:_refreshWakeTarget();
end;

function u1._updateWaking(p37, p38) -- Line: 261
    -- upvalues: Asserts (copy), GuardChasePolicy (copy)
    Asserts.number(p38);

    if not (p37:HasStolenEggs() or p37._eggRetrieval:HasPending()) then
        p37:_enterSleepState();

        return;
    end;

    p37:_refreshWakeTarget();

    if p38 - p37._wakingStartedAt < GuardChasePolicy.GetWakingDuration() then
        return;
    end;

    if p37._eggRetrieval:HasPending() then
        p37:_enterEggRetrievalState(p38);

        return;
    end;

    p37:_enterChaseState(p38);
    p37:_updateChase(p38);
end;

function u1._getChaseWalkSpeed(p39, p40) -- Line: 283
    -- upvalues: Asserts (copy), GuardChasePolicy (copy)
    Asserts.number(p40);

    return GuardChasePolicy.ResolveWalkSpeed(p39._config.WalkSpeed, p39._config.FlatRadius, p40);
end;

function u1._getReturnWalkSpeed(p41) -- Line: 289
    return p41._config.WalkSpeed * 1.5;
end;

function u1._enterChaseState(p42, p43) -- Line: 293
    local v44 = p42._state == "Waking";
    p42:_cancelSleepTurn();

    if p42._state ~= "Chasing" then
        p42._wakingStartedAt = 0;
        p42._root.Anchored = false;
        p42:_trySetNetworkOwner(p43, true);
        p42._humanoid.WalkSpeed = p42._config.WalkSpeed;
        p42._guardModel:SetAttribute("Sleeping", false);
        p42._guardModel:SetAttribute("GuardState", "Chasing");
        p42._guardModel:SetAttribute("WakeTargetPlayer", "");
        p42._presentation:StopSleep(0.4);
        p42._wakeHandler(p42._guardModel);
    end;

    p42:_setState("Chasing");

    if v44 then
        p42._presentation:ScheduleAfterWake(p43);
    end;

    if p42._walkResumeTime < p43 then
        p42._walkResumeTime = p43;
    end;
end;

function u1._enterEggRetrievalState(p45, p46) -- Line: 318
    -- upvalues: Asserts (copy)
    Asserts.number(p46);
    local v47 = p45._state == "Waking";
    p45:_cancelSleepTurn();
    p45:_setTarget(nil);
    p45:_setState("RetrievingEgg");
    p45._wakingStartedAt = 0;
    p45._root.Anchored = false;
    p45:_trySetNetworkOwner(p46, true);
    p45._guardModel:SetAttribute("Sleeping", false);
    p45._guardModel:SetAttribute("GuardState", p45._state);
    p45._guardModel:SetAttribute("WakeTargetPlayer", "");

    if v47 then
        p45._presentation:StopSleep(0.4);
        p45._wakeHandler(p45._guardModel);
    end;
end;

function u1._updateEggRetrieval(p48, p49) -- Line: 336
    -- upvalues: Asserts (copy), GuardChasePolicy (copy)
    Asserts.number(p49);

    if not p48._eggRetrieval:HasPending() then
        if p48:HasStolenEggs() then
            p48:_enterChaseState(p49);
            p48:_updateChase(p49);
        else
            p48:_enterReturnHomeState(p49);
        end;

        return nil;
    end;

    if p48:_isHitPaused(p49) then
        p48._humanoid.WalkSpeed = 0;
        p48:_stopMovement();
        p48._presentation:StopWalkAnimation();
        p48._presentation:EnsureIdleAnimation();
        p48._presentation:StopFootstepSound();

        return nil;
    end;

    local v50 = p48._eggRetrieval:GetCurrentEggUid();
    local v51 = p48._config.EggPickupDistance or GuardChasePolicy.ResolveHitDistance(p48._config.HitDistance);
    local v52 = p48._eggRetrieval:TryTransition(v51);

    if v52 == nil then
        local v53 = p48._eggRetrieval:GetMoveTarget();
        assert(v53 ~= nil, "Pending guard retrieval requires a movement target");
        p48._humanoid.WalkSpeed = p48:_getReturnWalkSpeed();
        p48:_ensureWalkAnimation(p49);
        p48:_moveTo(v53);

        return nil;
    end;

    assert(v50 ~= nil, "Guard retrieval transition requires an egg UID");
    local v54 = {
        AreaId = p48._areaId,
        EggUid = v50,
        Kind = v52
    };

    if v52 == "Deposited" then
        if p48._eggRetrieval:HasPending() then
            p48:_enterEggRetrievalState(p49);

            return v54;
        end;

        if not p48:HasStolenEggs() then
            p48:_enterReturnHomeState(p49);

            return v54;
        end;

        p48:_enterChaseState(p49);
        p48:_updateChase(p49);

        return v54;
    end;

    local v55 = p48._eggRetrieval:GetMoveTarget();
    assert(v55 ~= nil, "Attached guard retrieval egg requires a home movement target");
    p48._humanoid.WalkSpeed = p48:_getReturnWalkSpeed();
    p48:_ensureWalkAnimation(p49);
    p48:_moveTo(v55);

    return v54;
end;

function u1._enterReturnHomeState(p56, p57) -- Line: 396
    if p56._eggRetrieval:HasPending() then
        p56:_enterEggRetrievalState(p57);

        return;
    end;

    p56:_setState("ReturningHome");
    p56._guardModel:SetAttribute("GuardState", "ReturningHome");
    p56:_setTarget(nil);
    p56:_cancelSleepTurn();
    p56._root.Anchored = false;

    if not p56:_isHitPaused(p57) then
        p56._humanoid.WalkSpeed = p56:_getReturnWalkSpeed();
        p56:_moveTo(p56._homeCFrame.Position);

        return;
    end;

    p56._humanoid.WalkSpeed = 0;
    p56:_stopMovement();
    p56._presentation:StopWalkAnimation();
    p56._presentation:EnsureIdleAnimation();
    p56._presentation:StopFootstepSound();
end;

function u1._updateChase(p58, p59) -- Line: 419
    -- upvalues: GuardDistance (copy), GuardChasePolicy (copy)
    if p58._eggRetrieval:HasPending() then
        p58:_enterEggRetrievalState(p59);

        return;
    end;

    if not p58:HasStolenEggs() then
        p58:_enterReturnHomeState(p59);

        return;
    end;

    local _targetPlayer = p58._targetPlayer;
    local v60, v61, v62;

    if _targetPlayer == nil or p58._stolenEggUidByPlayer[_targetPlayer] == nil then
        v60 = nil;
        v61 = nil;
        v62 = nil;
    else
        v60, v61 = p58:_resolvePlayerTarget(_targetPlayer);
        v62 = p58._stolenEggUidByPlayer[_targetPlayer];
    end;

    if v60 == nil or (v61 == nil or p59 - p58._lastTargetRefresh >= 0.3) then
        _targetPlayer, v60, v61, v62 = p58:_chooseTargetPlayer();
        p58._lastTargetRefresh = p59;
    end;

    if _targetPlayer == nil or (v60 == nil or v61 == nil) then
        p58:_setTarget(nil);
        p58:_enterReturnHomeState(p59);

        return;
    end;

    p58:_setTarget(_targetPlayer);

    if GuardDistance.XZ(p58._root.Position, v60.Position) <= GuardChasePolicy.ResolveHitDistance(p58._config.HitDistance) then
        p58:_attemptAttack(_targetPlayer, v60, v61, v62, p59);

        return;
    end;

    local v63 = p58:_getChaseWalkSpeed(GuardDistance.XZ(p58._root.Position, v60.Position));
    p58._humanoid.WalkSpeed = v63;
    p58:_ensureWalkAnimation(p59);
    p58:_moveThrough(v60.Position);
end;

function u1._updateReturnHome(p64, p65) -- Line: 463
    -- upvalues: GuardReturnHomeDistanceResolver (copy)
    if p64._eggRetrieval:HasPending() then
        p64:_enterEggRetrievalState(p65);

        return;
    end;

    if p64:HasStolenEggs() then
        p64:_enterChaseState(p65);

        return;
    end;

    if p64._sleepTurnConnection ~= nil then
        return;
    end;

    if p64:_updateSleepTurn(p65) then
        return;
    end;

    if (p64._root.Position - p64._homeCFrame.Position).Magnitude <= GuardReturnHomeDistanceResolver.Resolve(p64._areaId) then
        p64:_beginSleepTurn(p65);

        return;
    end;

    if not p64:_isHitPaused(p65) then
        p64._humanoid.WalkSpeed = p64:_getReturnWalkSpeed();
        p64:_ensureWalkAnimation(p65);
        p64:_moveTo(p64._homeCFrame.Position);

        return;
    end;

    p64._humanoid.WalkSpeed = 0;
    p64:_stopMovement();
    p64._presentation:StopWalkAnimation();
    p64._presentation:EnsureIdleAnimation();
    p64._presentation:StopFootstepSound();
end;

function u1._beginSleepTurn(u66, p67) -- Line: 500
    -- upvalues: Asserts (copy), RunService (copy)
    Asserts.number(p67);
    u66._sleepTurnFromCFrame = u66._root.CFrame;
    u66._sleepTurnStartTime = p67;

    if u66._sleepTurnConnection == nil then
        u66._sleepTurnConnection = RunService.Heartbeat:Connect(function() -- Line: 506
            -- upvalues: u66 (copy)
            u66:_updateSleepTurn(os.clock());
        end);
    end;

    u66._humanoid.WalkSpeed = 0;
    u66:_stopMovement();
    u66._presentation:StopWalkAnimation();
    u66._presentation:EnsureIdleAnimation();
    u66._presentation:StopFootstepSound();
    u66:_updateSleepTurn(p67);
end;

function u1._cancelSleepTurn(p68) -- Line: 518
    local _sleepTurnConnection = p68._sleepTurnConnection;

    if _sleepTurnConnection ~= nil then
        p68._sleepTurnConnection = nil;
        _sleepTurnConnection:Disconnect();
    end;

    p68._sleepTurnFromCFrame = nil;
    p68._sleepTurnStartTime = 0;
end;

function u1._updateSleepTurn(p69, p70) -- Line: 529
    -- upvalues: Asserts (copy)
    Asserts.number(p70);
    local _sleepTurnFromCFrame = p69._sleepTurnFromCFrame;

    if _sleepTurnFromCFrame == nil then
        return false;
    end;

    if p69:HasStolenEggs() or p69._eggRetrieval:HasPending() then
        p69:_cancelSleepTurn();

        return false;
    end;

    local v71 = math.clamp((p70 - p69._sleepTurnStartTime) / 0.3, 0, 1);
    local v72 = Vector3.new(p69._homeCFrame.Position.X, p69._root.Position.Y, p69._homeCFrame.Position.Z);
    local v73 = CFrame.new(v72) * _sleepTurnFromCFrame.Rotation;
    local v74 = CFrame.new(v72) * p69._homeCFrame.Rotation;
    p69._guardModel:PivotTo(v73:Lerp(v74, v71));

    if v71 >= 1 then
        p69:_enterSleepState();
    end;

    return true;
end;

function u1._updateMovementRecovery(p75, p76) -- Line: 557
    -- upvalues: Asserts (copy)
    Asserts.number(p76);
    local v77;

    if p75._currentMoveTo == nil or p75._state ~= "Chasing" and (p75._state ~= "ReturningHome" and p75._state ~= "RetrievingEgg") then
        v77 = false;
    else
        v77 = not p75:_isHitPaused(p76);
    end;

    if p75._movementRecovery:Step(p76, v77, p75._state == "ReturningHome") then
        return p75:_recoverToHome();
    end;

    return nil;
end;

function u1._recoverToHome(p78) -- Line: 569
    p78:_stopMovement();

    if not p78._eggRetrieval:HasPending() then
        p78:_enterSleepState();

        return nil;
    end;

    p78._guardModel:PivotTo(p78._homeCFrame);
    p78:_enterEggRetrievalState(os.clock());

    return p78:_updateEggRetrieval(os.clock());
end;

function u1._chooseTargetPlayer(p79) -- Line: 581
    -- upvalues: Players (copy)
    local v80 = (-1 / 0);
    local v81 = (1 / 0);
    local v82 = nil;
    local v83 = nil;
    local v84 = nil;
    local v85 = nil;

    for i, v in pairs(p79._stolenPlayerByEggUid) do
        if v ~= nil and table.find(Players:GetPlayers(), v) then
            local v86, v87 = p79:_resolvePlayerTarget(v);

            if v86 ~= nil and v87 ~= nil then
                local v88 = p79._stolenPriorityByEggUid[i] or 0;
                local Magnitude = (p79._root.Position - v86.Position).Magnitude;

                if v80 < v88 or v88 == v80 and Magnitude < v81 then
                    v85 = i;
                    v84 = v87;
                    v83 = v86;
                    v82 = v;
                    v81 = Magnitude;
                    v80 = v88;
                end;
            end;
        end;
    end;

    return v82, v83, v84, v85;
end;

function u1._refreshWakeTarget(p89) -- Line: 618
    local v90 = p89:_chooseTargetPlayer();
    local v91 = v90 == nil and "" or tostring(v90.UserId);

    if p89._guardModel:GetAttribute("WakeTargetPlayer") == v91 then
        return;
    end;

    p89._guardModel:SetAttribute("WakeTargetPlayer", v91);
end;

function u1._resolvePlayerTarget(p92, p93) -- Line: 628
    -- upvalues: Player (copy)
    if not p92._targetResolver(p93) then
        return nil, nil;
    end;

    if Player.Optional.Character(p93) == nil then
        return nil, nil;
    end;

    local v94 = Player.Optional.HumanoidRootPart(p93);
    local v95 = Player.Optional.Humanoid(p93);

    if v94 == nil or v95 == nil then
        return nil, nil;
    end;

    local v96 = v94:IsA("BasePart");
    local v97 = `{v94:GetFullName()} must be a BasePart`;
    assert(v96, v97);

    if v95.Health <= 0 then
        return nil, nil;
    end;

    return v94, v95;
end;

function u1._attemptAttack(p98, p99, p100, p101, p102, p103) -- Line: 651
    -- upvalues: Asserts (copy), ATTACK_MIN_INTERVAL (copy)
    Asserts.Player(p99);
    Asserts.BasePart(p100);
    Asserts.Humanoid(p101);
    Asserts.optional.string(p102);
    Asserts.number(p103);

    if p103 < p98._attackResumeTime then
        return;
    end;

    if p103 < p98._ragdollEndTime then
        return;
    end;

    if p103 - p98._lastAttackTime < ATTACK_MIN_INTERVAL then
        return;
    end;

    p98._lastAttackTime = p103;
    p98._currentMoveTo = nil;
    p98._movementRecovery:Reset();
    local v104 = p98._presentation:PlayHit();
    local v105 = ATTACK_MIN_INTERVAL;

    if v104 > 0 then
        v105 = math.max(v105, v104);
    end;

    p98._walkResumeTime = p103 + v105;
    p98._attackResumeTime = math.max(p98._attackResumeTime, p103 + v105);
    p98._attackHandler({
        AreaId = p98._areaId,
        Bounds = p98._bounds,
        EggUid = p102,
        GuardHomePosition = p98._homeCFrame.Position,
        GuardModel = p98._guardModel,
        GuardRoot = p98._root,
        GuardWalkSpeed = p98._config.WalkSpeed,
        Player = p99,
        PlayerHumanoid = p101,
        PlayerRoot = p100
    });
end;

function u1._moveTo(p106, p107) -- Line: 702
    -- upvalues: Asserts (copy)
    Asserts.Vector3(p107);
    local v108 = Vector3.new(p107.X, p106._root.Position.Y, p107.Z);
    p106._currentMoveTo = v108;
    p106._humanoid:MoveTo(v108);
end;

function u1._moveThrough(p109, p110) -- Line: 711
    -- upvalues: Asserts (copy)
    Asserts.Vector3(p110);
    p109:_moveTo(p110 + Vector3.new(p110.X - p109._root.Position.X, 0, p110.Z - p109._root.Position.Z).Unit * 100);
end;

function u1._stopMovement(p111) -- Line: 718
    p111._currentMoveTo = nil;
    p111._movementRecovery:Reset();
    p111._humanoid:MoveTo(p111._root.Position);
    p111._humanoid:Move(Vector3.new(0, 0, 0), false);
end;

function u1._setTarget(p112, p113) -- Line: 725
    if p112._targetPlayer == p113 then
        return;
    end;

    p112._targetPlayer = p113;

    if p113 == nil then
        p112._guardModel:SetAttribute("TargetPlayer", "");

        return;
    end;

    p112._guardModel:SetAttribute("TargetPlayer", (tostring(p113.UserId)));
    p112._presentation:PlayWake();
end;

function u1._ensureWalkAnimation(p114, p115) -- Line: 740
    -- upvalues: Asserts (copy)
    Asserts.number(p115);

    if p115 < p114._walkResumeTime then
        p114._presentation:EnsureIdleAnimation();

        return;
    end;

    p114._presentation:EnsureWalkAnimation(p114._humanoid.WalkSpeed);
end;

function u1._trySetNetworkOwner(p116, p117, p118) -- Line: 751
    -- upvalues: Asserts (copy), u2 (copy)
    Asserts.number(p117);
    Asserts.boolean(p118);

    if not p116._serverOwnsPhysics or p116._root.Anchored then
        return;
    end;

    if not p118 and p117 - p116._lastNetworkOwnerRetry < 5 then
        return;
    end;

    p116._lastNetworkOwnerRetry = p117;

    if p116._root:CanSetNetworkOwnership() then
        p116._root:SetNetworkOwner(nil);

        return;
    end;

    u2:AtWarning():Log((`Guard root network ownership cannot be set yet: {p116._root:GetFullName()}`));
end;

function u1.Destroy(p119) -- Line: 776
    p119._eggRetrieval:Destroy();
    p119:_cancelSleepTurn();
    p119:_stopMovement();
    p119._presentation:Destroy();
    table.clear(p119._stolenEggUidByPlayer);
    table.clear(p119._stolenPlayerByEggUid);
    table.clear(p119._stolenPriorityByEggUid);
end;

function u1.RegisterStolenEgg(p120, p121, p122, p123) -- Line: 786
    -- upvalues: Asserts (copy)
    Asserts.Player(p121);
    Asserts.string(p122);
    Asserts.number(p123);
    local v124 = p120._stolenPlayerByEggUid[p122];

    if v124 == p121 then
        return false;
    end;

    if v124 ~= nil then
        error((`Stolen egg "{p122}" is already registered to {v124.Name}`));
    end;

    local v125 = p120._stolenEggUidByPlayer[p121];

    if v125 ~= nil then
        p120._stolenPlayerByEggUid[v125] = nil;
        p120._stolenPriorityByEggUid[v125] = nil;
    end;

    p120._stolenPlayerByEggUid[p122] = p121;
    p120._stolenEggUidByPlayer[p121] = p122;
    p120._stolenPriorityByEggUid[p122] = p123;
    local v126 = os.clock();

    if p120._eggRetrieval:HasPending() then
        if p120._state == "Sleeping" then
            p120:_enterWakingState(v126);
        end;

        return true;
    end;

    if p120._state == "Sleeping" or p120._state == "Waking" then
        p120:_enterWakingState(v126);
    else
        p120:_enterChaseState(v126);
        p120:_updateChase(v126);
    end;

    return true;
end;

function u1.RegisterDroppedEgg(p127, p128) -- Line: 829
    -- upvalues: Asserts (copy)
    Asserts.table(p128);

    if not p127._eggRetrieval:Register(p128) then
        return false;
    end;

    local v129 = os.clock();

    if p127._state == "Sleeping" then
        p127:_enterWakingState(v129);
    elseif p127._state ~= "Waking" then
        p127:_enterEggRetrievalState(v129);
    end;

    return true;
end;

function u1.ClearDroppedEgg(p130, p131) -- Line: 844
    -- upvalues: Asserts (copy)
    Asserts.string(p131);

    if not p130._eggRetrieval:Clear(p131) then
        return false;
    end;

    if p130._state == "RetrievingEgg" and not p130._eggRetrieval:HasPending() then
        local v132 = os.clock();

        if p130:HasStolenEggs() then
            p130:_enterChaseState(v132);
            p130:_updateChase(v132);
        else
            p130:_enterReturnHomeState(v132);
        end;
    end;

    return true;
end;

function u1.IsDroppedEggAttached(p133, p134) -- Line: 862
    return p133._eggRetrieval:IsAttached(p134);
end;

function u1.ClearStolenEgg(p135, p136) -- Line: 866
    -- upvalues: Asserts (copy)
    Asserts.string(p136);
    local v137 = p135._stolenPlayerByEggUid[p136];

    if v137 == nil then
        return false;
    end;

    p135._stolenPlayerByEggUid[p136] = nil;
    p135._stolenPriorityByEggUid[p136] = nil;

    if p135._stolenEggUidByPlayer[v137] == p136 then
        p135._stolenEggUidByPlayer[v137] = nil;
    end;

    if p135._targetPlayer == v137 then
        p135:_setTarget(nil);
    end;

    if not p135:HasStolenEggs() then
        if p135._eggRetrieval:HasPending() then
            return true;
        end;

        if p135._state == "Waking" or p135._state == "Sleeping" then
            p135:_enterSleepState();
        else
            p135:_enterReturnHomeState(os.clock());
        end;
    end;

    return true;
end;

function u1.ClearPlayer(p138, p139) -- Line: 896
    -- upvalues: Asserts (copy)
    Asserts.Player(p139);
    local v140 = p138._stolenEggUidByPlayer[p139];

    if v140 ~= nil then
        p138._stolenEggUidByPlayer[p139] = nil;
        p138._stolenPlayerByEggUid[v140] = nil;
        p138._stolenPriorityByEggUid[v140] = nil;
    end;

    if p138._targetPlayer == p139 then
        p138:_setTarget(nil);
    end;

    if not p138:HasStolenEggs() then
        if p138._eggRetrieval:HasPending() then
            return;
        end;

        if p138._state == "Waking" or p138._state == "Sleeping" then
            p138:_enterSleepState();

            return;
        end;

        p138:_enterReturnHomeState(os.clock());
    end;
end;

function u1.HasStolenEggs(p141) -- Line: 920
    return next(p141._stolenPlayerByEggUid) ~= nil;
end;

function u1.Step(p142, p143) -- Line: 924
    -- upvalues: Asserts (copy)
    Asserts.number(p143);

    if p142._movementRecovery:ShouldRecoverFromFall() then
        return p142:_recoverToHome();
    end;

    p142:_trySetNetworkOwner(p143, false);

    if p142._state ~= "Waking" and (p142._state ~= "RetrievingEgg" and p142._eggRetrieval:HasPending()) then
        p142:_enterEggRetrievalState(p143);
    end;

    local v144 = nil;

    if p142._state == "Sleeping" then
        if p142:HasStolenEggs() then
            p142:_enterWakingState(p143);
        end;
    elseif p142._state == "Waking" then
        p142:_updateWaking(p143);
    elseif p142._state == "Chasing" then
        p142:_updateChase(p143);
    elseif p142._state == "ReturningHome" then
        p142:_updateReturnHome(p143);
    elseif p142._state == "RetrievingEgg" then
        v144 = p142:_updateEggRetrieval(p143);
    end;

    p142._presentation:UpdateAfterWake(p143, p142._state == "Chasing");

    if v144 == nil then
        return p142:_updateMovementRecovery(p143);
    end;

    return v144;
end;

return u1;