-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ServerScriptService = game:GetService("ServerScriptService");
local AntiCheatService = require(ServerScriptService.Controllers.AntiCheatService);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Config = require(script.Parent.Config);
require(script.Parent.Types.Interface);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local GameplayToolGuard = require(ServerScriptService.Library.Tools.Internal.GameplayToolGuard);
local Interface = require(ReplicatedStorage.Directory.Gears.Types.Interface);
local GetPlayerFromTool = require(ReplicatedStorage.Library.Functions.GetPlayerFromTool);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ServerScriptService.Library.Network);
local Player = require(ReplicatedStorage.Library.Player);
local Ragdoll = require(ReplicatedStorage.Library.Modules.Ragdoll);
local SentryHitResolver = require(script.Parent.SentryHitResolver);
local SlapShared = require(ServerScriptService.Library.Tools.Internal.SlapShared);
require(ReplicatedStorage.Library.Types.Tools);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
u1.__class = "BatServerController";
local Bat = Network.NET_MAP.Bat;
local u2 = Log.new();

function u1.new(p3, p4) -- Line: 63
    -- upvalues: Asserts (copy), Interface (copy), u1 (copy), Config (copy), Trove (copy)
    Asserts.Tool(p3);
    local v5, v6 = Interface.BatControllerData(p4);
    assert(v5, v6);
    local Handle = p3.Handle;
    local v7 = Handle:IsA("BasePart");
    assert(v7, "Bat.Handle must be a BasePart");
    local v8 = setmetatable({}, u1);
    v8._tool = p3;
    v8._handle = Handle;
    v8._range = Config.Range + p4.RangeBonus;
    v8._slapProfile = table.freeze({
        BrainrotDamage = 0,
        MaxBrainrotTargets = 0,
        Duration = p4.Duration,
        Force = p4.Force
    });
    v8._cooldownLockedUntil = 0;
    v8._nextDebugLogAt = 0;
    v8._processing = false;
    v8._idleTrack = nil;
    v8._trove = Trove.new();
    v8:_init();

    return v8;
end;

function u1._setCooldownAttributes(u9, p10) -- Line: 95
    local _tool = u9._tool;
    local u11 = workspace:GetServerTimeNow() + p10;
    _tool:SetAttribute("CooldownDuration", p10);
    _tool:SetAttribute("CooldownEndTime", u11);
    _tool:SetAttribute("CooldownActive", true);
    task.delay(p10, function() -- Line: 102
        -- upvalues: _tool (copy), u11 (copy), u9 (copy)
        if _tool.Parent and _tool:GetAttribute("CooldownEndTime") == u11 then
            _tool:SetAttribute("CooldownActive", false);
            _tool:SetAttribute("CooldownDuration", 0);
            _tool:SetAttribute("CooldownEndTime", 0);
            u9._cooldownLockedUntil = 0;
        end;
    end);
end;

function u1._playIdle(p12, p13) -- Line: 112
    -- upvalues: Player (copy)
    if p12._idleTrack then
        return;
    end;

    local v14 = Player.Optional.Humanoid(p13);

    if v14 then
        v14 = v14:FindFirstChildOfClass("Animator");
    end;

    if v14 and p12._tool:FindFirstChild("IdleAnim") then
    end;
end;

function u1._stopIdle(p15) -- Line: 127
    local _idleTrack = p15._idleTrack;

    if not _idleTrack then
        return;
    end;

    p15._idleTrack = nil;
    _idleTrack:Stop();
    _idleTrack:Destroy();
end;

function u1._playHitAnimation(p16, p17) -- Line: 138
    -- upvalues: Player (copy)
    local v18 = Player.Optional.Humanoid(p17);

    if v18 then
        v18 = v18:FindFirstChildOfClass("Animator");
    end;

    local HitAnim = p16._tool:FindFirstChild("HitAnim");

    if not (v18 and HitAnim) then
        return;
    end;

    local v19 = v18:LoadAnimation(HitAnim);
    v19.Priority = Enum.AnimationPriority.Action;
    v19:Play();
end;

function u1._applyPlayerHit(p20, p21, p22) -- Line: 151
    -- upvalues: Player (copy), GameplayToolGuard (copy), SlapShared (copy), Ragdoll (copy)
    local v23 = Player.Optional.Character(p21);
    local v24 = Player.Optional.HumanoidRootPart(p21);

    if not (v23 and (v24 and v24:IsA("BasePart"))) then
        return;
    end;

    if v23:GetAttribute("IsTrapped") == true then
        return;
    end;

    GameplayToolGuard.DropHeldEggFromPlayerHit(p21);
    local v25, v26 = SlapShared.ComputeImpulse(v24, p22, p20._slapProfile);
    p21:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow() + v26);
    Ragdoll.TimedRagdollAsync(v23, v26, v25);
end;

function u1._canLogDebugTrace(p27, p28) -- Line: 167
    -- upvalues: Constants (copy)
    if not Constants.IS_STUDIO or p28 < p27._nextDebugLogAt then
        return false;
    end;

    p27._nextDebugLogAt = p28 + 0.1;

    return true;
end;

function u1._logDecisionTrace(p29, p30, p31, p32, p33, p34, p35, p36, p37, p38) -- Line: 176
    -- upvalues: Player (copy), Config (copy), u2 (copy)
    if not p29:_canLogDebugTrace(p32) then
        return;
    end;

    if p35 and p35.Target then
        p34 = p35.Target;
    end;

    local v39;

    if p34 then
        v39 = Player.Optional.HumanoidRootPart(p34);
    else
        v39 = nil;
    end;

    if not (v39 and v39:IsA("BasePart")) then
        v39 = nil;
    end;

    local v40 = Player.Optional.Humanoid(p30);
    local v41 = not p33 and Vector3.new(0, 0, 0) or p33.AssemblyLinearVelocity;
    local v42 = not v39 and Vector3.new(0, 0, 0) or v39.AssemblyLinearVelocity;
    local v43 = p29._range + Config.HitTolerance;
    local v44;

    if p35 then
        v44 = p35.CurrentDistance;
    else
        v44 = not (p33 and v39) and -1 or (v39.Position - p33.Position).Magnitude;
    end;

    local v45 = u2:AtInfo();
    local v46 = {
        Stage = "SERVER_DECISION",
        TraceId = p31,
        Decision = p36,
        Explanation = p37,
        Action = p38,
        Accepted = p38 == "HIT_ACTION_DISPATCHED",
        ServerTime = p32,
        AttackerName = p30.Name,
        AttackerUserId = p30.UserId,
        TargetName = not p34 and "None" or p34.Name,
        TargetUserId = not p34 and 0 or p34.UserId,
        MaximumRange = v43,
        ServerCurrentDistance = v44,
        ServerHistoricalDistance = not p35 and -1 or p35.HistoricalDistance,
        TargetViewAgeSeconds = not p35 and -1 or p35.TargetViewAge,
        HistoricalTimestamp = not p35 and -1 or p35.HistoricalTimestamp,
        HistoricalSampleIntervalSeconds = not p35 and -1 or p35.HistoricalSampleInterval,
        NetworkPingSeconds = p30:GetNetworkPing(),
        CooldownRemainingSeconds = math.max(0, p29._cooldownLockedUntil - p32),
        CooldownToApplySeconds = (p38 == "HIT_ACTION_DISPATCHED" or p38 == "MISS_COOLDOWN_APPLIED") and 0.7 or 0,
        AttackerServerPosition = not p33 and Vector3.new(0, 0, 0) or p33.Position
    };
    local v47;

    if p35 then
        v47 = p35.TargetServerPosition;
    else
        v47 = not v39 and Vector3.new(0, 0, 0) or v39.Position;
    end;

    v46.TargetCurrentServerPosition = v47;
    v46.TargetHistoricalServerPosition = not p35 and Vector3.new(0, 0, 0) or p35.TargetHistoricalServerPosition;
    v46.AttackerWalkSpeed = not v40 and -1 or v40.WalkSpeed;
    v46.AttackerHorizontalSpeed = Vector3.new(v41.X, 0, v41.Z).Magnitude;
    v46.TargetHorizontalSpeed = Vector3.new(v42.X, 0, v42.Z).Magnitude;
    local v48;

    if v39 == nil then
        v48 = false;
    else
        v48 = Vector3.new(v42.X, 0, v42.Z).Magnitude <= 1;
    end;

    v46.TargetServerStationary = v48;
    v45:Log("Bat hit validation trace", v46);
end;

function u1._resolveValidTarget(p49, p50, p51, p52, p53) -- Line: 241
    -- upvalues: Players (copy), Player (copy), Ragdoll (copy), Config (copy), AntiCheatService (copy)
    local v54 = {
        Delta = nil,
        Decision = "CLIENT_NO_TARGET",
        Explanation = "The client did not nominate a player inside its rendered selection range.",
        CurrentDistance = -1,
        HistoricalDistance = -1,
        TargetViewAge = -1,
        HistoricalTimestamp = -1,
        HistoricalSampleInterval = -1,
        TargetServerPosition = Vector3.new(0, 0, 0),
        TargetHistoricalServerPosition = Vector3.new(0, 0, 0),
        Target = p51
    };

    if p51 == nil then
        return v54;
    end;

    if p51 == p50 then
        v54.Decision = "SELF_TARGET_REJECTED";
        v54.Explanation = "The nominated target was the attacker.";

        return v54;
    end;

    if p51.Parent ~= Players then
        v54.Decision = "TARGET_NOT_IN_SERVER";
        v54.Explanation = "The nominated player was no longer in this server.";

        return v54;
    end;

    local v55 = Player.Optional.Character(p51);
    local v56 = Player.Optional.HumanoidRootPart(p51);
    local v57 = Player.Optional.Humanoid(p51);

    if not (v55 and (v56 and (v56:IsA("BasePart") and v57))) then
        v54.Decision = "TARGET_CHARACTER_UNAVAILABLE";
        v54.Explanation = "The server could not resolve the nominated target\'s live character, root, or Humanoid.";

        return v54;
    end;

    v54.TargetServerPosition = v56.Position;

    if v57.Health <= 0 then
        v54.Decision = "TARGET_DEAD";
        v54.Explanation = "The nominated target was dead when the server handled the swing.";

        return v54;
    end;

    if Ragdoll.IsRagdolled(v55) then
        v54.Decision = "TARGET_ALREADY_RAGDOLLED";
        v54.Explanation = "The nominated target was already ragdolled and is not eligible for another Bat hit.";

        return v54;
    end;

    local v58 = v56.Position - p52.Position;
    local v59 = p49._range + Config.HitTolerance;
    v54.CurrentDistance = v58.Magnitude;

    if v54.CurrentDistance <= v59 then
        v54.Target = p51;
        v54.Delta = v58;
        v54.Decision = "CURRENT_RANGE_ACCEPTED";
        v54.Explanation = "The server currently sees the target inside MaximumRange; history compensation was not needed.";

        return v54;
    end;

    local v60 = p50:GetNetworkPing() + Config.TargetViewSamplePadding;
    local v61 = math.clamp(v60, Config.TargetViewSamplePadding, Config.MaximumTargetViewAge);
    local v62 = p53 - v61;
    v54.TargetViewAge = v61;
    v54.HistoricalTimestamp = v62;
    local v63 = AntiCheatService.GetHistoricalPosition(p51, v62);

    if v63 == nil then
        v54.Decision = "HISTORY_UNAVAILABLE";
        v54.Explanation = "Current distance exceeded MaximumRange and the server could not reconstruct the target at HistoricalTimestamp.";

        return v54;
    end;

    v54.HistoricalSampleInterval = v63.SampleInterval;
    v54.TargetHistoricalServerPosition = v63.Position;
    v54.HistoricalDistance = (v63.Position - p52.Position).Magnitude;

    if v59 < v54.HistoricalDistance then
        v54.Decision = "CURRENT_AND_HISTORY_OUT_OF_RANGE";
        v54.Explanation = "Both ServerCurrentDistance and ServerHistoricalDistance exceeded MaximumRange.";

        return v54;
    end;

    v54.Target = p51;
    v54.Delta = v58;
    v54.Decision = "HISTORICAL_RANGE_ACCEPTED";
    v54.Explanation = "Current distance exceeded MaximumRange, but server-owned history proves the target was inside range in the estimated client view.";

    return v54;
end;

function u1._beginActivation(p64, p65) -- Line: 341
    -- upvalues: Player (copy), Ragdoll (copy), GameplayToolGuard (copy)
    local v66 = Player.Optional.Character(p65);

    if not v66 then
        return nil, "ATTACKER_CHARACTER_UNAVAILABLE", "The server could not resolve the attacker\'s character.";
    end;

    if Ragdoll.IsRagdolled(v66) then
        return nil, "ATTACKER_RAGDOLLED", "The server rejected the swing because the attacker was ragdolled.";
    end;

    if not GameplayToolGuard.CanActivate(p65) then
        return nil, "GAMEPLAY_GUARD_REJECTED", "The gameplay tool guard rejected the swing before target validation.";
    end;

    p64:_playHitAnimation(p65);
    local v67 = Player.Optional.HumanoidRootPart(p65);

    if v67 and v67:IsA("BasePart") then
        return v67, "ACTIVATION_ACCEPTED", "The swing passed attacker and gameplay activation guards.";
    end;

    return nil, "ATTACKER_ROOT_UNAVAILABLE", "The server could not resolve the attacker\'s HumanoidRootPart.";
end;

function u1._finishMiss(p68) -- Line: 361
    local Slash = p68._handle:FindFirstChild("Slash");

    if Slash then
        Slash:Play();
    end;

    return 0.7;
end;

function u1._applyHits(p69, p70, p71) -- Line: 369
    -- upvalues: SentryHitResolver (copy)
    if #p71 == 0 then
        return p69:_finishMiss();
    end;

    local Hit = p69._handle:FindFirstChild("Hit");

    if Hit then
        Hit:Play();
    end;

    SentryHitResolver(p70.Position, p69._range);

    for _, v in ipairs(p71) do
        p69:_applyPlayerHit(v.target, v.delta);
    end;

    return 0.7;
end;

function u1._activate(p72, p73, p74, p75, p76) -- Line: 389
    local v77, v78, v79 = p72:_beginActivation(p73);

    if not v77 then
        p72:_logDecisionTrace(p73, p76, p75, nil, p74, nil, v78, v79, "NO_ACTION");

        return nil;
    end;

    local v80 = p72:_resolveValidTarget(p73, p74, v77, p75);
    local Target = v80.Target;
    local Delta = v80.Delta;

    if Target and Delta then
        local v81 = p72:_applyHits(v77, {
            {
                target = Target,
                delta = Delta
            }
        });
        p72:_logDecisionTrace(p73, p76, p75, v77, p74, v80, v80.Decision, v80.Explanation, "HIT_ACTION_DISPATCHED");

        return v81;
    end;

    local v82 = p72:_finishMiss();
    p72:_logDecisionTrace(p73, p76, p75, v77, p74, v80, v80.Decision, v80.Explanation, "MISS_COOLDOWN_APPLIED");

    return v82;
end;

function u1._canProcessRequest(p83, p84) -- Line: 446
    -- upvalues: Player (copy), GetPlayerFromTool (copy), Ragdoll (copy)
    local v85 = Player.Optional.Character(p84);

    if not v85 then
        return false, "REQUEST_CHARACTER_UNAVAILABLE", "The request arrived without a live attacker character.";
    end;

    if p83._tool.Parent ~= v85 or GetPlayerFromTool(p83._tool) ~= p84 then
        return false, "REQUEST_TOOL_NOT_EQUIPPED", "The server rejected the request because this Bat was not equipped and owned by the attacker.";
    end;

    if Ragdoll.IsRagdolled(v85) then
        return false, "REQUEST_ATTACKER_RAGDOLLED", "The server rejected the request because the attacker was ragdolled.";
    end;

    if p83._processing then
        return false, "REQUEST_ALREADY_PROCESSING", "The previous Bat request is still being processed.";
    end;

    if workspace:GetServerTimeNow() < p83._cooldownLockedUntil then
        return false, "REQUEST_COOLDOWN_ACTIVE", "The request arrived before the server Bat cooldown ended.";
    end;

    return true, "REQUEST_ACCEPTED", "The request passed equip, ownership, ragdoll, processing, and cooldown guards.";
end;

function u1._runActivation(p86, p87, p88) -- Line: 470
    local v89, v90, v91 = p86:_canProcessRequest(p87);

    if not v89 then
        return false, v90, v91;
    end;

    p86._processing = true;
    local v92 = p88(p86, p87);
    p86._processing = false;

    if v92 then
        p86._cooldownLockedUntil = workspace:GetServerTimeNow() + v92;
        p86:_setCooldownAttributes(v92);
    end;

    return true, "REQUEST_PROCESSED", "The server completed the Bat activation callback.";
end;

function u1._handleActivation(p93, p94, u95, u96) -- Line: 490
    -- upvalues: Asserts (copy), Player (copy)
    Asserts.Player(p94);
    Asserts.optional.Player(u95);
    Asserts.string(u96);
    local u97 = workspace:GetServerTimeNow();
    local v100, v101, v102 = p93:_runActivation(p94, function(p98, p99) -- Line: 502
        -- upvalues: u95 (copy), u97 (copy), u96 (copy)
        return p98:_activate(p99, u95, u97, u96);
    end);

    if not v100 then
        p93:_logDecisionTrace(p94, u96, u97, Player.Optional.HumanoidRootPart(p94), u95, nil, v101, v102, "NO_ACTION");
    end;
end;

function u1.Destroy(p103) -- Line: 525
    -- upvalues: u2 (copy)
    p103:_stopIdle();
    p103._trove:Destroy();
    u2:AtDebug():Log("Bat server controller destroyed");
end;

function u1._init(u104) -- Line: 535
    -- upvalues: Network (copy), Bat (copy), GetPlayerFromTool (copy)
    local _tool = u104._tool;
    _tool:SetAttribute("CooldownEndTime", 0);
    _tool:SetAttribute("CooldownDuration", 0);
    _tool:SetAttribute("CooldownActive", false);
    u104._trove:Connect(Network.Fired(Bat.ACTIVATE), function(p105, p106, p107) -- Line: 541
        -- upvalues: u104 (copy)
        u104:_handleActivation(p105, p106, p107);
    end);
    u104._trove:Connect(_tool.Equipped, function() -- Line: 544
        -- upvalues: GetPlayerFromTool (ref), _tool (copy), u104 (copy)
        local v108 = GetPlayerFromTool(_tool);

        if v108 then
            u104:_playIdle(v108);
        end;
    end);
    u104._trove:Connect(_tool.Unequipped, function() -- Line: 550
        -- upvalues: u104 (copy)
        u104:_stopIdle();
    end);
    u104._trove:Connect(_tool.Destroying, function() -- Line: 553
        -- upvalues: u104 (copy)
        u104:Destroy();
    end);
end;

return u1;