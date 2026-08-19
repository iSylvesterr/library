-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AssetItem = require(ReplicatedStorage.Library.Types.AssetItem);
local Personalities = require(ReplicatedStorage.Directory.Assets.Personalities);
require(ReplicatedStorage.Directory.Assets.Types.Personality);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AssetMutationWalkSpeed = require(script.Parent.AssetMutationWalkSpeed);
local AssetPersonalityMotion = require(script.Parent.AssetPersonalityMotion);
local AssetWanderArea = require(script.Parent.AssetWanderArea);
local AssetWanderMotion = require(script.Parent.AssetWanderMotion);
local AssetRetreatMotion = require(script.Parent.AssetRetreatMotion);
local u1 = Log.new();
local u2 = {};
u2.__index = u2;
u2.__class = "AssetWanderSimulator";

function u2.new(p3, p4, p5, p6, p7, p8, p9) -- Line: 114
    -- upvalues: Asserts (copy), AssetItem (copy), Players (copy), Personalities (copy), u2 (copy), AssetPersonalityMotion (copy), u1 (copy)
    Asserts.number(p3);
    Asserts.Player(p4);
    Asserts.BasePart(p5);
    local v10 = AssetItem.AssetItemData(p6);
    assert(v10, "Invalid asset item data");
    Asserts.boolean(p7);
    Asserts.number(p8);
    Asserts.number(p9);
    local v11 = Random.new(p3);
    local LocalPlayer = Players.LocalPlayer;
    assert(LocalPlayer ~= nil, "Asset wander simulator requires a local player");
    local v12 = Personalities.GetConfig(p6.Personality);
    local v13 = setmetatable({}, u2);
    v13._random = v11;
    v13._owner = p4;
    v13._localPlayer = LocalPlayer;
    v13._assetArea = p5;
    v13._itemData = p6;
    v13._config = v12;
    v13._greetingOrbitRadius = math.max(p8, 2.5);
    local v14 = math.max(p9, 1) * 2;
    v13._jumpHeight = math.min(v14, 20);
    v13._destination = p5.Position;
    v13._idleRemaining = 0;
    v13._idleAnchorCFrame = nil;
    v13._idleElapsed = 0;
    v13._walkSpeed = v13:_rollWalkSpeed();
    v13._mode = "Destination";
    v13._phase = "Normal";
    v13._greetRemaining = 0;
    v13._randomOrbitInsideSeconds = 0;
    v13._farSeconds = 0;
    v13._farRequiredSeconds = v11:NextNumber(105, 180);
    v13._joinGreetingPending = true;
    v13._finishJumpsRemaining = 0;
    v13._finishJumpCooldown = 0;
    v13._returnGreetingHoldRemaining = 0;
    v13._returnGreetingJumpsRemaining = 0;
    v13._returnGreetingJumpCooldown = 0;
    v13._returnGreetingOwnerOffset = nil;
    v13._affectionInsideSeconds = 0;
    v13._affectionHoldRemaining = 0;
    v13._affectionJumpsRemaining = 0;
    v13._affectionJumpCooldown = 0;
    v13._affectionOwnerOffset = nil;
    v13._loyalOwnerOffset = AssetPersonalityMotion.RandomOwnerOffset(p5, v11, v13._greetingOrbitRadius);
    v13._pendingBubbleText = nil;
    v13._jumpRemaining = 0;
    v13._jumpElapsed = 0;
    v13._spinYaw = 0;
    v13._spinAppliedYaw = 0;
    v13._curveAngle = v11:NextNumber(-3.141592653589793, 3.141592653589793);
    v13._curveRotationSpeed = v11:NextNumber(-0.8, 0.8);
    v13._nextCurveChangeSeconds = v11:NextNumber(5, 10);
    v13._curveChangeElapsed = 0;
    v13._retreatOwnerWasClose = false;
    v13._retreatActive = false;
    v13._lastOwnerPosition = nil;
    v13:_chooseNextDestination();

    if p7 then
        v13:_tryStartFirstPlacementGreeting();
    end;

    u1:AtDebug():Log((`Created asset wander simulator with seed {p3}`));

    return v13;
end;

function u2._rollWalkSpeed(p15) -- Line: 197
    -- upvalues: AssetMutationWalkSpeed (copy)
    local Movement = p15._config.Movement;
    local v16 = p15._random:NextNumber(Movement.WalkSpeedMin, Movement.WalkSpeedMax);

    return math.max(v16, 4.5) * AssetMutationWalkSpeed.GetMultiplier(p15._itemData);
end;

function u2._ownerRootPosition(p17) -- Line: 204
    -- upvalues: AssetPersonalityMotion (copy)
    return AssetPersonalityMotion.OwnerRootPosition(p17._owner);
end;

function u2._distanceFromLocalPlayerToAreaCenter(p18) -- Line: 208
    -- upvalues: AssetPersonalityMotion (copy)
    return AssetPersonalityMotion.DistanceFromPlayerToAreaCenter(p18._localPlayer, p18._assetArea);
end;

function u2._chooseNextDestination(p19) -- Line: 212
    -- upvalues: AssetPersonalityMotion (copy)
    local v20 = p19:_ownerRootPosition();
    local Movement = p19._config.Movement;
    p19._walkSpeed = p19:_rollWalkSpeed();
    p19._destination = AssetPersonalityMotion.ChooseDestination(p19._assetArea, p19._random, Movement, v20);
    p19._mode = p19._random:NextNumber() < Movement.CurvedWanderChance and "Curve" or "Destination";
end;

function u2._tryRetreatFromOwner(p21, p22, p23) -- Line: 222
    -- upvalues: AssetRetreatMotion (copy), AssetPersonalityMotion (copy)
    local Retreat = p21._config.Movement.Retreat;

    if Retreat == nil then
        p21._retreatOwnerWasClose = false;
        p21._retreatActive = false;

        return false;
    end;

    if Vector3.new(p22.X - p23.X, 0, p22.Z - p23.Z).Magnitude > Retreat.TriggerDistance then
        p21._retreatOwnerWasClose = false;
        p21._retreatActive = false;

        return false;
    end;

    if p21._retreatActive then
        p21._destination = AssetRetreatMotion.Destination(p21._assetArea, p21._random, Retreat, p23, p22);
        p21._mode = "Destination";
        p21._idleRemaining = 0;
        p21._idleAnchorCFrame = nil;

        return true;
    end;

    if p21._retreatOwnerWasClose then
        return false;
    end;

    p21._retreatOwnerWasClose = true;

    if not AssetPersonalityMotion.RollChance(p21._random, Retreat.Chance) then
        return false;
    end;

    p21._retreatActive = true;
    p21._destination = AssetRetreatMotion.Destination(p21._assetArea, p21._random, Retreat, p23, p22);
    p21._mode = "Destination";
    p21._idleRemaining = 0;
    p21._idleAnchorCFrame = nil;
    p21._walkSpeed = p21:_rollWalkSpeed();

    return true;
end;

function u2._beginIdle(p24, p25) -- Line: 269
    local Movement = p24._config.Movement;
    p24._idleRemaining = p24._random:NextNumber(Movement.IdleSecondsMin, Movement.IdleSecondsMax);
    p24._idleAnchorCFrame = p25;
    p24._idleElapsed = 0;
end;

function u2._stepIdle(p26, p27) -- Line: 276
    -- upvalues: AssetPersonalityMotion (copy)
    local _idleAnchorCFrame = p26._idleAnchorCFrame;
    assert(_idleAnchorCFrame ~= nil, "Idle phase requires a stable anchor CFrame");
    local v28, v29, v30, v31 = AssetPersonalityMotion.StepIdle(p27, p26._idleRemaining, p26._idleElapsed, _idleAnchorCFrame, p26._config.Movement.IdleTremble);
    p26._idleRemaining = v29;
    p26._idleElapsed = v30;

    if v31 then
        p26._idleAnchorCFrame = nil;
        p26._idleElapsed = 0;
    end;

    return p26:_applyJump(p27, v28);
end;

function u2._tryAmbientJump(p32, p33) -- Line: 296
    -- upvalues: AssetPersonalityMotion (copy)
    local Movement = p32._config.Movement;

    if AssetPersonalityMotion.ShouldStartAmbientJump(p32._random, Movement.AmbientJumpRatePerSecond, p33, p32._jumpRemaining > 0) then
        p32:_startJump(Movement.AmbientSpinJumpChance);
    end;
end;

function u2._startJump(p34, p35) -- Line: 310
    if p34._jumpRemaining > 0 then
        return;
    end;

    if p35 == nil then
        p35 = p34._config.Greeting.SpinJumpChance;
    end;

    p34._jumpRemaining = 0.45;
    p34._jumpElapsed = 0;
    p34._spinAppliedYaw = 0;
    local v36 = p34._random:NextNumber() < 0.5 and -1 or 1;
    p34._spinYaw = p34._random:NextNumber() >= p35 and 0 or 6.283185307179586 * v36;
end;

function u2._resetGreetingFinish(p37) -- Line: 323
    p37._finishJumpsRemaining = 0;
    p37._finishJumpCooldown = 0;
end;

function u2._resetReturnGreeting(p38) -- Line: 328
    p38._returnGreetingHoldRemaining = 0;
    p38._returnGreetingJumpsRemaining = 0;
    p38._returnGreetingJumpCooldown = 0;
    p38._returnGreetingOwnerOffset = nil;
end;

function u2._resetAffection(p39) -- Line: 335
    p39._affectionHoldRemaining = 0;
    p39._affectionJumpsRemaining = 0;
    p39._affectionJumpCooldown = 0;
    p39._affectionOwnerOffset = nil;
    p39._pendingBubbleText = nil;
end;

function u2._popBubbleText(p40) -- Line: 343
    local _pendingBubbleText = p40._pendingBubbleText;
    p40._pendingBubbleText = nil;

    return _pendingBubbleText;
end;

function u2._beginGreetingFinish(p41) -- Line: 350
    p41._phase = "GreetingFinish";
    p41._greetRemaining = 1.2;
    p41._finishJumpsRemaining = 2;
    p41._finishJumpCooldown = 0;
    p41._lastOwnerPosition = nil;
end;

function u2._beginGreetingOrbit(p42, p43) -- Line: 358
    -- upvalues: Asserts (copy), AssetPersonalityMotion (copy)
    Asserts.boolean(p43);
    local Greeting = p42._config.Greeting;
    p42._phase = "GreetingOrbit";
    p42._greetRemaining = math.min(Greeting.DurationSeconds, 3);
    p42._randomOrbitInsideSeconds = 0;
    p42._idleRemaining = 0;
    p42._lastOwnerPosition = nil;
    p42:_resetGreetingFinish();
    p42:_resetReturnGreeting();
    p42:_resetAffection();

    if p43 then
        p42._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(p42._random, Greeting.Texts, p42._config._id, "greeting");
    end;
end;

function u2._tryStartGreetingOrbit(p44, p45, p46) -- Line: 376
    -- upvalues: Asserts (copy), AssetPersonalityMotion (copy)
    Asserts.boolean(p46);

    if p45 <= 0 or p44._config.Greeting.DurationSeconds <= 0 then
        return false;
    end;

    if not AssetPersonalityMotion.RollChance(p44._random, p45) then
        return false;
    end;

    p44:_beginGreetingOrbit(p46);

    return true;
end;

function u2._beginNormalGreeting(p47, p48, p49, p50, p51) -- Line: 393
    -- upvalues: Asserts (copy), AssetPersonalityMotion (copy), AssetWanderArea (copy)
    Asserts.boolean(p51);
    local v52 = AssetPersonalityMotion.RandomOwnerOffset(p47._assetArea, p47._random, p47._greetingOrbitRadius);
    p47._phase = "ReturnGreetingApproach";
    p47._returnGreetingOwnerOffset = v52;
    p47._returnGreetingHoldRemaining = math.min(p50, 20);
    p47._returnGreetingJumpsRemaining = p49;
    p47._returnGreetingJumpCooldown = 0;
    p47._destination = AssetWanderArea.PointNearOwner(p47._assetArea, p48, v52);
    p47._idleRemaining = 0;
    p47._walkSpeed = p47:_rollWalkSpeed();
    p47._lastOwnerPosition = nil;
    p47:_resetGreetingFinish();
    p47:_resetAffection();

    if p51 then
        p47._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(p47._random, p47._config.Greeting.Texts, p47._config._id, "greeting");
    end;
end;

function u2._tryStartFirstPlacementGreeting(p53) -- Line: 426
    -- upvalues: AssetPersonalityMotion (copy)
    p53._joinGreetingPending = false;
    local Greeting = p53._config.Greeting;

    if p53:_tryStartGreetingOrbit(Greeting.FirstPlacementChance, true) then
        return;
    end;

    local FirstPlacementBubbleChance = Greeting.FirstPlacementBubbleChance;

    if FirstPlacementBubbleChance ~= nil and (FirstPlacementBubbleChance > 0 and AssetPersonalityMotion.RollChance(p53._random, FirstPlacementBubbleChance)) then
        p53._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(p53._random, Greeting.Texts, p53._config._id, "greeting");

        return;
    end;

    local v54 = p53:_ownerRootPosition();

    if v54 == nil or not AssetPersonalityMotion.RollChance(p53._random, Greeting.FirstPlacementNormalChance) then
        return;
    end;

    local FirstPlacementNormalJumpCount = Greeting.FirstPlacementNormalJumpCount;

    if FirstPlacementNormalJumpCount <= 0 then
        return;
    end;

    p53:_beginNormalGreeting(v54, FirstPlacementNormalJumpCount, 0.6 * FirstPlacementNormalJumpCount, true);
end;

function u2._tryStartReturnGreeting(p55, p56, p57) -- Line: 454
    -- upvalues: Asserts (copy), AssetPersonalityMotion (copy)
    Asserts.boolean(p57);
    local Greeting = p55._config.Greeting;

    if Greeting.Chance <= 0 or Greeting.DurationSeconds <= 0 then
        return;
    end;

    if not AssetPersonalityMotion.RollChance(p55._random, Greeting.Chance) then
        return;
    end;

    if p57 and p55:_tryStartGreetingOrbit(Greeting.ReturnOrbitChance, false) then
        return;
    end;

    p55:_beginNormalGreeting(p56, Greeting.ReturnNormalJumpCount, math.min(Greeting.DurationSeconds, 20), false);
end;

function u2._beginAffection(p58, p59) -- Line: 479
    -- upvalues: AssetPersonalityMotion (copy), AssetWanderArea (copy)
    local Affection = p58._config.Affection;
    local v60 = AssetPersonalityMotion.RandomOwnerOffset(p58._assetArea, p58._random, p58._greetingOrbitRadius);
    p58._phase = "AffectionApproach";
    p58._affectionOwnerOffset = v60;
    p58._destination = AssetWanderArea.PointNearOwner(p58._assetArea, p59, v60);
    p58._idleRemaining = 0;
    p58._walkSpeed = p58:_rollWalkSpeed();
    p58._affectionHoldRemaining = Affection.DurationSeconds;
    p58._affectionJumpsRemaining = Affection.JumpCount;
    p58._affectionJumpCooldown = 0;
    p58._pendingBubbleText = nil;
    p58._lastOwnerPosition = nil;
    p58:_resetGreetingFinish();
end;

function u2._updateAffectionTrigger(p61, p62, p63) -- Line: 497
    -- upvalues: AssetWanderArea (copy), AssetPersonalityMotion (copy)
    if p61._phase ~= "Normal" then
        return;
    end;

    local Affection = p61._config.Affection;

    if not Affection.Enabled or (Affection.IntervalSeconds <= 0 or p63 == nil) then
        p61._affectionInsideSeconds = 0;

        return;
    end;

    if not AssetWanderArea.IsPositionInside(p61._assetArea, p63) then
        p61._affectionInsideSeconds = 0;

        return;
    end;

    p61._affectionInsideSeconds = p61._affectionInsideSeconds + p62;

    if p61._affectionInsideSeconds < Affection.IntervalSeconds then
        return;
    end;

    p61._affectionInsideSeconds = 0;

    if AssetPersonalityMotion.RollChance(p61._random, Affection.Chance) then
        p61:_beginAffection(p63);
    end;
end;

function u2._updateOrbitGreetingTrigger(p64, p65, p66) -- Line: 528
    -- upvalues: AssetWanderArea (copy)
    if p64._phase ~= "Normal" then
        return;
    end;

    local Greeting = p64._config.Greeting;

    if Greeting.RandomOrbitChance <= 0 or (Greeting.RandomOrbitIntervalSeconds <= 0 or (Greeting.DurationSeconds <= 0 or p66 == nil)) then
        p64._randomOrbitInsideSeconds = 0;

        return;
    end;

    if not AssetWanderArea.IsPositionInside(p64._assetArea, p66) then
        p64._randomOrbitInsideSeconds = 0;

        return;
    end;

    p64._randomOrbitInsideSeconds = p64._randomOrbitInsideSeconds + p65;

    if p64._randomOrbitInsideSeconds < Greeting.RandomOrbitIntervalSeconds then
        return;
    end;

    p64._randomOrbitInsideSeconds = 0;
    p64:_tryStartGreetingOrbit(Greeting.RandomOrbitChance, false);
end;

function u2._updateReturnGreeting(p67, p68) -- Line: 562
    -- upvalues: AssetWanderArea (copy)
    if p67._phase ~= "Normal" then
        return;
    end;

    if not p67._joinGreetingPending then
        local v69 = p67:_distanceFromLocalPlayerToAreaCenter();

        if v69 == nil then
            return;
        end;

        if v69 >= 200 then
            p67._farSeconds = p67._farSeconds + p68;

            return;
        end;

        if p67._farSeconds >= p67._farRequiredSeconds and v69 <= 200 then
            p67._farSeconds = 0;
            p67._farRequiredSeconds = p67._random:NextNumber(105, 180);
            local v70 = p67:_ownerRootPosition();

            if v70 ~= nil and AssetWanderArea.IsPositionInside(p67._assetArea, v70) then
                p67:_tryStartReturnGreeting(v70, true);

                return;
            end;
        else
            p67._farSeconds = 0;
        end;

        return;
    end;

    local v71 = p67:_ownerRootPosition();

    if v71 == nil then
        return;
    end;

    p67._joinGreetingPending = false;
    p67._farSeconds = 0;
    p67._farRequiredSeconds = p67._random:NextNumber(105, 180);
    p67:_tryStartReturnGreeting(v71, AssetWanderArea.IsPositionInside(p67._assetArea, v71));
end;

function u2._updateGreeting(p72, p73) -- Line: 598
    if p72._phase ~= "GreetingOrbit" and p72._phase ~= "GreetingFinish" then
        return;
    end;

    local v74 = p72:_distanceFromLocalPlayerToAreaCenter();

    if v74 == nil or v74 <= 300 then
        p72._greetRemaining = math.max(p72._greetRemaining - p73, 0);

        if p72._phase == "GreetingOrbit" then
            if p72._greetRemaining <= 0 then
                p72:_beginGreetingFinish();

                return;
            end;

            if p72._random:NextNumber() < p72._config.Greeting.JumpChancePerSecond * p73 then
                p72:_startJump();
            end;

            return;
        end;

        p72._finishJumpCooldown = math.max(p72._finishJumpCooldown - p73, 0);

        if p72._finishJumpsRemaining > 0 and p72._finishJumpCooldown <= 0 then
            p72:_startJump(0);
            p72._finishJumpsRemaining = p72._finishJumpsRemaining - 1;
            p72._finishJumpCooldown = 0.6;
        end;

        if p72._finishJumpsRemaining <= 0 and (p72._jumpRemaining <= 0 and p72._greetRemaining <= 0) then
            p72._phase = "Normal";
            p72:_resetGreetingFinish();
            p72:_resetReturnGreeting();
            p72:_resetAffection();
            p72:_chooseNextDestination();
        end;

        return;
    end;

    p72._phase = "Normal";
    p72._greetRemaining = 0;
    p72:_resetGreetingFinish();
    p72:_resetReturnGreeting();
    p72:_resetAffection();
    p72:_chooseNextDestination();
end;

function u2._stepReturnGreeting(p75, p76, p77, p78) -- Line: 642
    -- upvalues: AssetWanderArea (copy), AssetWanderMotion (copy)
    if p75._phase ~= "ReturnGreetingApproach" then
        p75._returnGreetingHoldRemaining = math.max(p75._returnGreetingHoldRemaining - p76, 0);
        p75._returnGreetingJumpCooldown = math.max(p75._returnGreetingJumpCooldown - p76, 0);

        if p75._returnGreetingJumpsRemaining > 0 and p75._returnGreetingJumpCooldown <= 0 then
            p75:_startJump(0);
            p75._returnGreetingJumpsRemaining = p75._returnGreetingJumpsRemaining - 1;
            p75._returnGreetingJumpCooldown = 0.6;
        end;

        local v79, v80 = p75:_applyJump(p76, (AssetWanderMotion.FaceOwnerCFrame(p77, p78, p76)));

        if p75._returnGreetingHoldRemaining <= 0 and (p75._returnGreetingJumpsRemaining <= 0 and p75._jumpRemaining <= 0) then
            p75._phase = "Normal";
            p75:_resetReturnGreeting();
            p75:_chooseNextDestination();
        end;

        return v79, p75._jumpRemaining > 0, v80, p75._walkSpeed;
    end;

    local _returnGreetingOwnerOffset = p75._returnGreetingOwnerOffset;
    assert(_returnGreetingOwnerOffset ~= nil, "Return greeting approach requires a stable owner offset");
    p75._destination = AssetWanderArea.PointNearOwner(p75._assetArea, p78, _returnGreetingOwnerOffset);
    local v81, v82, v83 = AssetWanderMotion.StepMoveToward(p76, p77, p75._destination, p75._walkSpeed);

    if Vector3.new(p75._destination.X - v81.Position.X, 0, p75._destination.Z - v81.Position.Z).Magnitude > 2.25 then
        local v84, v85 = p75:_applyJump(p76, v81);

        return v84, v82 or p75._jumpRemaining > 0, v85, v83;
    end;

    p75._phase = "ReturnGreetingHold";
    p75._returnGreetingJumpCooldown = 0;

    if p75._returnGreetingJumpsRemaining > 0 then
        p75:_startJump(0);
        p75._returnGreetingJumpsRemaining = p75._returnGreetingJumpsRemaining - 1;
        p75._returnGreetingJumpCooldown = 0.6;
    end;

    local v86, v87 = p75:_applyJump(p76, (AssetWanderMotion.FaceOwnerCFrame(v81, p78, p76, true)));

    return v86, v82 or p75._jumpRemaining > 0, v87, v83;
end;

function u2._stepAffection(p88, p89, p90, p91) -- Line: 699
    -- upvalues: AssetWanderArea (copy), AssetWanderMotion (copy), AssetPersonalityMotion (copy)
    if p88._phase ~= "AffectionApproach" then
        p88._affectionHoldRemaining = math.max(p88._affectionHoldRemaining - p89, 0);
        p88._affectionJumpCooldown = math.max(p88._affectionJumpCooldown - p89, 0);

        if p88._affectionJumpsRemaining > 0 and p88._affectionJumpCooldown <= 0 then
            p88:_startJump(0);
            p88._affectionJumpsRemaining = p88._affectionJumpsRemaining - 1;
            p88._affectionJumpCooldown = 0.6;
        end;

        local v92, v93 = p88:_applyJump(p89, (AssetWanderMotion.FaceOwnerCFrame(p90, p91, p89)));

        if p88._affectionHoldRemaining <= 0 and (p88._affectionJumpsRemaining <= 0 and p88._jumpRemaining <= 0) then
            p88._phase = "Normal";
            p88:_resetAffection();
            p88:_chooseNextDestination();
        end;

        return v92, p88._jumpRemaining > 0, v93, p88._walkSpeed;
    end;

    local _affectionOwnerOffset = p88._affectionOwnerOffset;
    assert(_affectionOwnerOffset ~= nil, "Affection approach requires a stable owner offset");
    p88._destination = AssetWanderArea.PointNearOwner(p88._assetArea, p91, _affectionOwnerOffset);
    local v94, v95, v96 = AssetWanderMotion.StepMoveToward(p89, p90, p88._destination, p88._walkSpeed);

    if Vector3.new(p88._destination.X - v94.Position.X, 0, p88._destination.Z - v94.Position.Z).Magnitude > 2.25 then
        local v97, v98 = p88:_applyJump(p89, v94);

        return v97, v95 or p88._jumpRemaining > 0, v98, v96;
    end;

    p88._phase = "AffectionHold";
    p88._affectionJumpCooldown = 0.6;
    p88._pendingBubbleText = AssetPersonalityMotion.RandomConfiguredText(p88._random, p88._config.Affection.Texts, p88._config._id, "affection");

    if p88._affectionJumpsRemaining > 0 then
        p88:_startJump(0);
        p88._affectionJumpsRemaining = p88._affectionJumpsRemaining - 1;
    end;

    local v99, v100 = p88:_applyJump(p89, (AssetWanderMotion.FaceOwnerCFrame(v94, p91, p89, true)));

    return v99, v95 or p88._jumpRemaining > 0, v100, v96;
end;

function u2._updateCurve(p101, p102, p103) -- Line: 755
    -- upvalues: AssetWanderArea (copy)
    p101._curveChangeElapsed = p101._curveChangeElapsed + p102;

    if p101._curveChangeElapsed >= p101._nextCurveChangeSeconds then
        p101._curveChangeElapsed = 0;
        p101._nextCurveChangeSeconds = p101._random:NextNumber(5, 10);
        p101._curveAngle = p101._random:NextNumber(-3.141592653589793, 3.141592653589793);
        p101._curveRotationSpeed = p101._random:NextNumber(-0.8, 0.8);
    end;

    p101._curveAngle = p101._curveAngle + p101._curveRotationSpeed * p102;
    local v104 = math.cos(p101._curveAngle);
    local v105 = math.sin(p101._curveAngle);
    local v106 = p103 + Vector3.new(v104, 0, v105) * 9;
    p101._destination = AssetWanderArea.ClampedPointToward(p101._assetArea, v106);
end;

function u2._orbitGreetingCFrame(p107, p108, p109, p110) -- Line: 770
    -- upvalues: AssetWanderMotion (copy)
    local v111, v112 = AssetWanderMotion.OwnerMoveVector(p108, p110, p107._lastOwnerPosition);
    p107._lastOwnerPosition = v112;

    return AssetWanderMotion.OrbitGreetingCFrame(p107._assetArea, p108, p109, p110, v111, p107._greetingOrbitRadius, 22, 0.75);
end;

function u2._applyJump(p113, p114, p115) -- Line: 791
    if p113._jumpRemaining <= 0 then
        return p115, true;
    end;

    p113._jumpRemaining = math.max(p113._jumpRemaining - p114, 0);
    p113._jumpElapsed = math.min(p113._jumpElapsed + p114, 0.45);
    local v116 = p113._jumpElapsed / 0.45;
    local v117 = math.sin(v116 * 3.141592653589793) * p113._jumpHeight;
    local v118 = p113._spinYaw == 0 and 0 or p113._spinYaw * v116;
    local v119 = v118 - p113._spinAppliedYaw;
    p113._spinAppliedYaw = v118;
    local v120 = CFrame.new(p115.Position + Vector3.new(0, v117, 0)) * p115.Rotation;

    if v119 ~= 0 then
        v120 = v120 * CFrame.Angles(0, v119, 0);
    end;

    if p113._jumpRemaining <= 0 then
        p113._spinAppliedYaw = 0;
    end;

    return v120, p113._jumpRemaining <= 0;
end;

function u2.SetAssetArea(p121, p122) -- Line: 818
    -- upvalues: Asserts (copy), AssetPersonalityMotion (copy)
    Asserts.BasePart(p122);
    local v123 = p121._assetArea ~= p122;
    p121._assetArea = p122;

    if v123 then
        p121._loyalOwnerOffset = AssetPersonalityMotion.RandomOwnerOffset(p122, p121._random, p121._greetingOrbitRadius);
        local v124;

        if p121._returnGreetingOwnerOffset == nil then
            v124 = nil;
        else
            v124 = AssetPersonalityMotion.RandomOwnerOffset(p122, p121._random, p121._greetingOrbitRadius);
        end;

        p121._returnGreetingOwnerOffset = v124;
        local v125;

        if p121._affectionOwnerOffset == nil then
            v125 = nil;
        else
            v125 = AssetPersonalityMotion.RandomOwnerOffset(p122, p121._random, p121._greetingOrbitRadius);
        end;

        p121._affectionOwnerOffset = v125;
    end;

    p121:_chooseNextDestination();
end;

function u2.SetItemData(p126, p127, p128) -- Line: 836
    -- upvalues: AssetItem (copy), Asserts (copy), Personalities (copy)
    local v129 = AssetItem.AssetItemData(p127);
    assert(v129, "Invalid asset item data");
    Asserts.boolean(p128);
    p126._itemData = p127;
    p126._config = Personalities.GetConfig(p127.Personality);

    if p128 then
        p126:_tryStartFirstPlacementGreeting();
    end;
end;

function u2.Step(p130, p131, p132) -- Line: 851
    -- upvalues: Asserts (copy), AssetWanderMotion (copy), AssetWanderArea (copy), AssetMutationWalkSpeed (copy)
    Asserts.number(p131);
    Asserts.CFrame(p132);
    p130:_updateReturnGreeting(p131);
    p130:_updateGreeting(p131);
    local Position = p132.Position;
    local v133 = p130:_ownerRootPosition();

    if p130._phase ~= "Normal" and v133 == nil then
        p130._phase = "Normal";
        p130._greetRemaining = 0;
        p130:_resetGreetingFinish();
        p130:_resetReturnGreeting();
        p130:_resetAffection();
        p130:_chooseNextDestination();
    end;

    p130:_updateAffectionTrigger(p131, v133);
    p130:_updateOrbitGreetingTrigger(p131, v133);
    local v134;

    if p130._phase == "Normal" and v133 ~= nil then
        v134 = p130:_tryRetreatFromOwner(Position, v133);
    else
        v134 = false;
    end;

    if p130._phase == "Normal" then
        p130:_tryAmbientJump(p131);
    end;

    if p130._idleRemaining > 0 and p130._phase == "Normal" then
        local v135, v136 = p130:_stepIdle(p131);

        return v135, p130._jumpRemaining > 0, v136, 0, false, p130:_popBubbleText();
    end;

    if p130._phase == "GreetingOrbit" and v133 ~= nil then
        local v137, v138, v139 = p130:_orbitGreetingCFrame(p131, p132, v133);
        local v140, v141 = p130:_applyJump(p131, v137);

        return v140, v138 or p130._jumpRemaining > 0, v141, v139, true, p130:_popBubbleText();
    end;

    if p130._phase == "GreetingFinish" and v133 ~= nil then
        local v142, v143 = p130:_applyJump(p131, (AssetWanderMotion.FaceOwnerCFrame(p132, v133, p131)));

        return v142, p130._jumpRemaining > 0, v143, p130._walkSpeed, true, p130:_popBubbleText();
    end;

    if (p130._phase == "ReturnGreetingApproach" or p130._phase == "ReturnGreetingHold") and v133 ~= nil then
        local v144, v145, v146, v147 = p130:_stepReturnGreeting(p131, p132, v133);

        return v144, v145, v146, v147, false, p130:_popBubbleText();
    end;

    if (p130._phase == "AffectionApproach" or p130._phase == "AffectionHold") and v133 ~= nil then
        local v148, v149, v150, v151 = p130:_stepAffection(p131, p132, v133);

        return v148, v149, v150, v151, false, p130:_popBubbleText();
    end;

    if p130._config.Movement.FollowOwnerInPen and (v133 ~= nil and AssetWanderArea.IsPositionInside(p130._assetArea, v133)) then
        local v152, v153, v154 = AssetWanderMotion.StepFollowOwner(p130._assetArea, p131, p132, v133, p130._loyalOwnerOffset, p130._walkSpeed, 2.25);
        local v155, v156 = p130:_applyJump(p131, v152);

        return v155, v153 or p130._jumpRemaining > 0, v156, v154, false, p130:_popBubbleText();
    end;

    if p130._mode == "Curve" then
        p130:_updateCurve(p131, p132.Position);
    end;

    local _destination = p130._destination;
    local v157 = _destination - Position;

    if Vector3.new(v157.X, 0, v157.Z).Magnitude <= 0.35 and not v134 then
        p130:_beginIdle(p132);
        p130:_chooseNextDestination();
        local v158, v159 = p130:_applyJump(p131, p132);

        return v158, p130._jumpRemaining > 0, v159, p130._walkSpeed, false, p130:_popBubbleText();
    end;

    local _walkSpeed = p130._walkSpeed;

    if p130._random:NextNumber() < p130._config.Movement.BurstChance * p131 then
        _walkSpeed = p130._config.Movement.WalkSpeedMax * 1.25 * AssetMutationWalkSpeed.GetMultiplier(p130._itemData);
        p130:_startJump();
    end;

    local v160, v161, v162 = AssetWanderMotion.StepMoveToward(p131, p132, _destination, _walkSpeed);
    local v163, v164 = p130:_applyJump(p131, v160);

    return v163, v161 or p130._jumpRemaining > 0, v164, v162, false, p130:_popBubbleText();
end;

return u2;