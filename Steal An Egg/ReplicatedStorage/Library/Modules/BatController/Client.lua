-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Config = require(script.Parent.Config);
require(script.Parent.Types.Interface);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Debounce = require(ReplicatedStorage.Library.Functions.Debounce);
local Interface = require(ReplicatedStorage.Directory.Gears.Types.Interface);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Player = require(ReplicatedStorage.Library.Player);
local Ragdoll = require(ReplicatedStorage.Library.Modules.Ragdoll);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local ToolGameplayGuard = require(ReplicatedStorage.Library.Client.ToolGameplayGuard);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local u1 = {};
u1.__index = u1;
u1.__class = "BatClientController";
local u2 = Config.MaximumTargetViewAge + 0.1;
local u3 = Color3.fromRGB(255, 0, 0);
local u4 = Color3.fromRGB(107, 0, 0);
local Bat = Constants.NETWORK_MAP.Bat;
local u5 = Log.new();
local LocalPlayer = Players.LocalPlayer;

function u1.new(p6, p7) -- Line: 62
    -- upvalues: Asserts (copy), Interface (copy), u1 (copy), Config (copy), Debounce (copy), Trove (copy)
    Asserts.Tool(p6);
    local v8, v9 = Interface.BatControllerData(p7);
    assert(v8, v9);
    local v10 = setmetatable({}, u1);
    v10._tool = p6;
    v10._highlightAttackerHistory = {};
    v10._targetRange = Config.Range + Config.HitTolerance + p7.RangeBonus;
    v10._targetStates = {};
    v10._isEquipped = false;
    v10._traceSequence = 0;
    v10._tryActivate = Debounce();
    v10._trove = Trove.new();
    v10:_init();

    return v10;
end;

function u1._cancelTween(p11, p12) -- Line: 84
    local Tween2 = p12.Tween;

    if Tween2 then
        p12.Tween = nil;
        Tween2:Cancel();
    end;
end;

function u1._destroyHighlight(p13, p14) -- Line: 92
    p13:_cancelTween(p14);
    local Highlight = p14.Highlight;

    if Highlight then
        Highlight:Destroy();
    end;

    p14.Highlight = nil;
    p14.Character = nil;
    p14.Visible = false;
end;

function u1._showHighlight(p15, p16, p17) -- Line: 103
    -- upvalues: u3 (copy), u4 (copy), Tween (copy)
    if p16.Character ~= p17 then
        p15:_destroyHighlight(p16);
    end;

    if p16.Visible then
        return;
    end;

    p16.TransitionVersion = p16.TransitionVersion + 1;
    p15:_cancelTween(p16);
    local Highlight = p16.Highlight;

    if not Highlight then
        Highlight = Instance.new("Highlight");
        Highlight.Name = "BatTargetHighlight";
        Highlight.Adornee = p17;
        Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
        Highlight.FillColor = u3;
        Highlight.OutlineColor = u4;
        Highlight.FillTransparency = 1;
        Highlight.OutlineTransparency = 1;
        Highlight.Parent = p17;
        p16.Highlight = Highlight;
    end;

    p16.Character = p17;
    p16.Visible = true;
    p16.Tween = Tween(assert(Highlight, "Bat target Highlight must exist before fade-in"), {
        FillTransparency = 0.5,
        OutlineTransparency = 0.15
    }, { 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out });
end;

function u1._hideHighlight(p18, p19) -- Line: 141
    if not p19.Highlight then
        return;
    end;

    p18:_destroyHighlight(p19);
end;

function u1._trackPlayer(p20, p21) -- Line: 149
    -- upvalues: LocalPlayer (copy)
    if p21 == LocalPlayer or p20._targetStates[p21] then
        return;
    end;

    p20._targetStates[p21] = {
        Character = nil,
        Highlight = nil,
        Tween = nil,
        TransitionVersion = 0,
        Visible = false
    };
end;

function u1._untrackPlayer(p22, p23) -- Line: 163
    local v24 = p22._targetStates[p23];

    if not v24 then
        return;
    end;

    p22:_destroyHighlight(v24);
    p22._targetStates[p23] = nil;
end;

function u1._isTargetEligible(p25, p26, p27, p28) -- Line: 173
    -- upvalues: Player (copy), Ragdoll (copy)
    local v29 = Player.Optional.Character(p26);
    local v30 = Player.Optional.HumanoidRootPart(p26);
    local v31 = Player.Optional.Humanoid(p26);

    if not v29 or (not v30 or (not v30:IsA("BasePart") or (not v31 or v31.Health <= 0))) then
        return false, (1 / 0);
    end;

    if Ragdoll.IsRagdolled(v29) then
        return false, (1 / 0);
    end;

    local Magnitude = (v30.Position - p27.Position).Magnitude;

    return Magnitude <= p28, Magnitude;
end;

function u1._recordHighlightAttackerSample(p32, p33, p34) -- Line: 193
    -- upvalues: u2 (copy)
    local _highlightAttackerHistory = p32._highlightAttackerHistory;
    _highlightAttackerHistory[#_highlightAttackerHistory + 1] = {
        Position = p34,
        Timestamp = p33
    };

    while #_highlightAttackerHistory > 2 and _highlightAttackerHistory[2].Timestamp < p33 - u2 do
        table.remove(_highlightAttackerHistory, 1);
    end;
end;

function u1._getHighlightAttackerPositionAt(p35, p36) -- Line: 210
    local _highlightAttackerHistory = p35._highlightAttackerHistory;
    local v37 = _highlightAttackerHistory[1];
    local v38 = _highlightAttackerHistory[#_highlightAttackerHistory];

    if not v37 or (not v38 or (p36 < v37.Timestamp or v38.Timestamp < p36)) then
        return nil;
    end;

    for i = 2, #_highlightAttackerHistory do
        local v39 = _highlightAttackerHistory[i];

        if p36 <= v39.Timestamp then
            local v40 = _highlightAttackerHistory[i - 1];
            local v41 = v39.Timestamp - v40.Timestamp;

            if v41 <= 0 then
                return v39.Position;
            end;

            local v42 = math.clamp((p36 - v40.Timestamp) / v41, 0, 1);

            return v40.Position:Lerp(v39.Position, v42);
        end;
    end;

    return nil;
end;

function u1._predictServerAcceptsHighlightTarget(p43, p44, p45, p46) -- Line: 235
    -- upvalues: Player (copy), LocalPlayer (copy), Config (copy)
    if not p43:_isTargetEligible(p44, p45, p43._targetRange) then
        return false;
    end;

    local v47 = Player.Optional.HumanoidRootPart(p44);

    if not (v47 and v47:IsA("BasePart")) then
        return false;
    end;

    local v48 = LocalPlayer:GetNetworkPing();
    local v49 = p43:_getHighlightAttackerPositionAt(p46 - math.clamp(0.14 + v48, 0.14, Config.MaximumTargetViewAge));

    if not v49 then
        return false;
    end;

    local v50 = math.clamp(v48 + Config.TargetViewSamplePadding, Config.TargetViewSamplePadding, Config.MaximumTargetViewAge);
    local Position = v47.Position;

    return (Position - v49).Magnitude <= p43._targetRange and true or (Position + v47.AssemblyLinearVelocity * v50 - v49).Magnitude <= p43._targetRange;
end;

function u1._updateHighlights(p51) -- Line: 276
    -- upvalues: Player (copy), LocalPlayer (copy), Ragdoll (copy)
    local v52 = Player.Optional.Character(LocalPlayer);
    local v53 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local _isEquipped = p51._isEquipped;

    if _isEquipped then
        if v52 == nil or v53 == nil then
            _isEquipped = false;
        else
            _isEquipped = v53:IsA("BasePart") and not Ragdoll.IsRagdolled(v52);
        end;
    end;

    local v54 = nil;
    local v55;

    if _isEquipped then
        local v56 = workspace:GetServerTimeNow();
        p51:_recordHighlightAttackerSample(v56, v53.Position);
        v55 = p51:_selectClosestTarget();

        if v55 then
            if not p51:_predictServerAcceptsHighlightTarget(v55, v53, v56) then
                v55 = v54;
            end;
        else
            v55 = v54;
        end;
    else
        table.clear(p51._highlightAttackerHistory);
        v55 = v54;
    end;

    for i, v in p51._targetStates do
        local v57;

        if i == v55 then
            v57 = Player.Optional.Character(i);
        else
            v57 = nil;
        end;

        if v57 then
            p51:_showHighlight(v, v57);
        else
            p51:_hideHighlight(v);
        end;
    end;
end;

function u1._selectClosestTarget(p58) -- Line: 308
    -- upvalues: Player (copy), LocalPlayer (copy), Ragdoll (copy)
    local v59 = Player.Optional.Character(LocalPlayer);
    local v60 = Player.Optional.HumanoidRootPart(LocalPlayer);

    if not v59 or (not v60 or (not v60:IsA("BasePart") or Ragdoll.IsRagdolled(v59))) then
        return nil;
    end;

    local v61 = (1 / 0);
    local v62 = nil;

    for i in p58._targetStates do
        local v63, v64 = p58:_isTargetEligible(i, v60, p58._targetRange);

        if v63 and v64 < v61 then
            v62 = i;
            v61 = v64;
        end;
    end;

    return v62;
end;

function u1._logActivationTrace(p65, p66, p67, p68) -- Line: 327
    -- upvalues: Constants (copy), Player (copy), LocalPlayer (copy), u5 (copy)
    if not Constants.IS_STUDIO then
        return;
    end;

    local v69 = Player.Optional.Humanoid(LocalPlayer);
    local v70;

    if p67 then
        v70 = Player.Optional.HumanoidRootPart(p67);
    else
        v70 = nil;
    end;

    if not (v70 and v70:IsA("BasePart")) then
        v70 = nil;
    end;

    local v71 = not v70 and Vector3.new(0, 0, 0) or v70.AssemblyLinearVelocity;
    local AssemblyLinearVelocity = p68.AssemblyLinearVelocity;
    local v72 = not v70 and -1 or (v70.Position - p68.Position).Magnitude;
    local v73 = u5:AtInfo();
    local v74 = {
        Stage = "CLIENT_SWING",
        TraceId = p66,
        Interpretation = p67 == nil and "CLIENT_NO_TARGET: your PC did not nominate an eligible player inside ClientSelectionRange at the swing moment." or (v70 == nil and "CLIENT_TARGET_ROOT_MISSING: the nominated player\'s rendered root disappeared before the swing was sent." or "CLIENT_TARGET_NOMINATED: this is the player and distance your PC rendered at the swing moment."),
        ClientServerTime = workspace:GetServerTimeNow(),
        AttackerName = LocalPlayer.Name,
        AttackerUserId = LocalPlayer.UserId,
        TargetName = not p67 and "None" or p67.Name,
        TargetUserId = not p67 and 0 or p67.UserId,
        TargetNominated = p67 ~= nil,
        ClientSelectionRange = p65._targetRange,
        ClientVisibleDistance = v72,
        AttackerPosition = p68.Position,
        TargetPosition = not v70 and Vector3.new(0, 0, 0) or v70.Position,
        AttackerWalkSpeed = not v69 and -1 or v69.WalkSpeed,
        AttackerHorizontalSpeed = Vector3.new(AssemblyLinearVelocity.X, 0, AssemblyLinearVelocity.Z).Magnitude,
        TargetHorizontalSpeed = Vector3.new(v71.X, 0, v71.Z).Magnitude
    };
    local v75;

    if v70 == nil then
        v75 = false;
    else
        v75 = Vector3.new(v71.X, 0, v71.Z).Magnitude <= 1;
    end;

    v74.TargetAppearsStationary = v75;
    v73:Log("Bat hit validation trace", v74);
end;

function u1._logLocalRejection(p76, p77, p78, p79) -- Line: 372
    -- upvalues: Constants (copy), Player (copy), LocalPlayer (copy), u5 (copy)
    if not Constants.IS_STUDIO then
        return;
    end;

    local v80 = Player.Optional.HumanoidRootPart(LocalPlayer);
    local v81 = Player.Optional.Humanoid(LocalPlayer);
    local v82 = not (v80 and v80:IsA("BasePart")) and Vector3.new(0, 0, 0) or v80.AssemblyLinearVelocity;
    u5:AtInfo():Log("Bat hit validation trace", {
        Stage = "CLIENT_LOCAL_REJECTED",
        ClientCooldownSeconds = 0.6,
        TraceId = p77,
        Decision = p78,
        Explanation = p79,
        ClientServerTime = workspace:GetServerTimeNow(),
        AttackerName = LocalPlayer.Name,
        AttackerUserId = LocalPlayer.UserId,
        AttackerPosition = not (v80 and v80:IsA("BasePart")) and Vector3.new(0, 0, 0) or v80.Position,
        AttackerWalkSpeed = not v81 and -1 or v81.WalkSpeed,
        AttackerHorizontalSpeed = Vector3.new(v82.X, 0, v82.Z).Magnitude
    });
end;

function u1._onActivated(u83) -- Line: 400
    -- upvalues: LocalPlayer (copy), ToolGameplayGuard (copy), Player (copy), Ragdoll (copy), Network (copy), Bat (copy)
    u83._traceSequence = u83._traceSequence + 1;
    local UserId = LocalPlayer.UserId;
    local _traceSequence = u83._traceSequence;
    local v84 = workspace:GetServerTimeNow() * 1000;
    local u85 = `{UserId}:{_traceSequence}:{math.floor(v84)}`;

    if not u83._isEquipped then
        u83:_logLocalRejection(u85, "CLIENT_TOOL_NOT_EQUIPPED", "The Bat Activated signal fired while this client controller did not consider the tool equipped.");

        return;
    end;

    if ToolGameplayGuard.CanActivateLocal(u83._tool) then
        if not u83._tryActivate(0.6, function() -- Line: 420
            -- upvalues: Player (ref), LocalPlayer (ref), Ragdoll (ref), u83 (copy), u85 (copy), Network (ref), Bat (ref)
            local v86 = Player.Optional.Character(LocalPlayer);
            local v87 = Player.Optional.HumanoidRootPart(LocalPlayer);

            if not v86 or (not v87 or (not v87:IsA("BasePart") or Ragdoll.IsRagdolled(v86))) then
                u83:_logLocalRejection(u85, "CLIENT_CHARACTER_STATE_REJECTED", "The client had no usable character/root or was ragdolled when the debounced swing executed.");

                return;
            end;

            local v88 = u83:_selectClosestTarget();
            u83:_logActivationTrace(u85, v88, v87);
            Network.Fire(Bat.ACTIVATE, v88, u85);
        end) then
            u83:_logLocalRejection(u85, "CLIENT_COOLDOWN_ACTIVE", "The client Bat cooldown rejected this click, so no server request was sent.");
        end;

        return;
    end;

    u83:_logLocalRejection(u85, "CLIENT_GAMEPLAY_GUARD_REJECTED", "The local gameplay-area guard rejected the swing before any server request was sent.");
end;

function u1._onEquipped(p89) -- Line: 445
    p89._isEquipped = true;
end;

function u1.Destroy(p90) -- Line: 453
    -- upvalues: u5 (copy)
    p90._trove:Destroy();

    for i in p90._targetStates do
        p90:_untrackPlayer(i);
    end;

    u5:AtDebug():Log("Bat client controller destroyed");
end;

function u1._init(u91) -- Line: 465
    -- upvalues: Players (copy), Constants (copy), RenderStepped (copy), Player (copy), LocalPlayer (copy)
    for _, v in ipairs(Players:GetPlayers()) do
        task.defer(function() -- Line: 467
            -- upvalues: u91 (copy), v (copy)
            u91:_trackPlayer(v);
        end);
    end;

    u91._trove:Connect(Players.PlayerAdded, function(p92) -- Line: 472
        -- upvalues: u91 (copy)
        u91:_trackPlayer(p92);
    end);
    u91._trove:Connect(Players.PlayerRemoving, function(p93) -- Line: 475
        -- upvalues: u91 (copy)
        u91:_untrackPlayer(p93);
    end);
    u91._trove:Connect(u91._tool.Equipped, function() -- Line: 478
        -- upvalues: u91 (copy)
        u91:_onEquipped();
    end);
    u91._trove:Connect(u91._tool.Unequipped, function() -- Line: 481
        -- upvalues: u91 (copy)
        u91._isEquipped = false;
        u91:_updateHighlights();
    end);
    u91._trove:Connect(u91._tool.Activated, function() -- Line: 485
        -- upvalues: u91 (copy)
        u91:_onActivated();
    end);

    if Constants.IS_MOBILE then
        local u94 = RenderStepped(function() -- Line: 489
            -- upvalues: u91 (copy)
            u91:_updateHighlights();

            return false;
        end);
        u91._trove:Add(function() -- Line: 493
            -- upvalues: u94 (copy)
            u94:Destroy();
        end);
    end;

    u91._trove:Connect(u91._tool.Destroying, function() -- Line: 497
        -- upvalues: u91 (copy)
        u91:Destroy();
    end);
    local v95 = Player.Optional.Character(LocalPlayer);

    if v95 and u91._tool.Parent == v95 then
        u91:_onEquipped();
    end;
end;

return u1;