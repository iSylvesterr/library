-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ActiveAssets = require(ReplicatedStorage.Library.Types.ActiveAssets);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local BBFromModelVisibleOnly = require(ReplicatedStorage.Library.Functions.BBFromModelVisibleOnly);
local Bezier = require(ReplicatedStorage.Library.Functions.Bezier);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local EggRenderer = require(ReplicatedStorage.Library.Client.Eggs.EggRenderer);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Player = require(ReplicatedStorage.Library.Player);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Transparency = require(ReplicatedStorage.Library.Functions.Transparency);
local AssetMovementBatch = require(script.Parent.AssetMovementBatch);
local EggCapturePresentation = require(ReplicatedStorage.Library.Client.Eggs.EggCapturePresentation);
local Config = require(script.Config);
local EggThrowLand = require(script.EggThrowLand);
local OrbAbsorption = require(script.OrbAbsorption);
local u1 = {};
u1.__index = u1;
u1.__class = "AssetDnaStealAnimation";
local ActiveAssets2 = Network.NET_MAP.ActiveAssets;
local u2 = Log.new();
local __DEBRIS = workspace.__DEBRIS;
local v3 = __DEBRIS:IsA("Folder");
assert(v3, "Workspace.__DEBRIS must be a Folder");

function u1.new(p4, p5, p6, p7) -- Line: 61
    -- upvalues: Asserts (copy), ActiveAssets (copy), u1 (copy)
    Asserts.Model(p5);
    local v8 = ActiveAssets.DnaStealAnimationPayload(p6);
    assert(v8, "Invalid DNA steal animation payload");
    local u9 = setmetatable({}, u1);
    u9._movementBatch = p4;
    u9._sourceModel = p5;
    u9._payload = p6;
    u9._setFrozen = p7;
    u9._destroyed = false;
    u9._presentationFrozen = false;
    u9._eggModel = nil;
    u9._sourceHighlight = nil;
    u9._eggHighlight = nil;
    u9._sourceClone = nil;
    u9._sourceShake = nil;
    u9._sourceShakeFadeStartedAt = nil;
    u9._eggCaptureActive = false;
    task.spawn(function() -- Line: 83
        -- upvalues: u9 (copy)
        u9:_play();
    end);

    return u9;
end;

local function autoControlPoint(p10, p11) -- Line: 93
    local v12 = (p10 + p11) * 0.5;
    local Magnitude = ((p10 - p11) * Vector3.new(1, 0, 1)).Magnitude;
    local X = v12.X;
    local v13 = math.max(p10.Y, p11.Y) + Magnitude * 0.5;

    return Vector3.new(X, v13, v12.Z);
end;

function u1._createHighlight(p14, p15, p16) -- Line: 99
    -- upvalues: Config (copy)
    local Highlight = Instance.new("Highlight");
    Highlight.Name = p15;
    Highlight.Adornee = p16;
    Highlight.FillColor = Config.HighlightDark;
    Highlight.FillTransparency = Config.HighlightFillTransparency;
    Highlight.OutlineTransparency = 1;
    Highlight.Parent = p16;

    return Highlight;
end;

local function anchorClone(p17) -- Line: 110
    for _, descendant in p17:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
            descendant.CanCollide = false;
            descendant.CanQuery = false;
            descendant.CanTouch = false;
        elseif descendant:IsA("ProximityPrompt") or (descendant:IsA("BillboardGui") or descendant:IsA("SurfaceGui")) then
            descendant:Destroy();
        elseif descendant:IsA("Sound") then
            descendant:Stop();
        end;
    end;
end;

local function getBodyCFrame() -- Line: 125
    -- upvalues: Player (copy), Players (copy)
    return Player.PrimaryPart(Players.LocalPlayer):GetPivot();
end;

local function getHighlightColor(p18) -- Line: 129
    -- upvalues: Config (copy)
    local v19 = (math.sin(p18 * 3.141592653589793 * 2 * Config.HighlightPulseHz) + 1) * 0.5;

    return Config.HighlightDark:Lerp(Config.HighlightNearWhite, v19);
end;

function u1._isActive(p20) -- Line: 134
    return not p20._destroyed and p20._sourceModel.Parent ~= nil;
end;

function u1._setPresentationFrozen(p21, p22) -- Line: 138
    if p21._presentationFrozen == p22 then
        return;
    end;

    p21._presentationFrozen = p22;
    p21._setFrozen(p22);
end;

function u1._shakeSource(u23) -- Line: 146
    -- upvalues: RenderStepped (copy), Config (copy), Easing (copy)
    local u24 = u23:_createHighlight("DnaStealSourceHighlight", u23._sourceModel);
    u23._sourceHighlight = u24;
    u23:_setPresentationFrozen(true);
    u23._sourceShake = RenderStepped(function(p25, p26) -- Line: 151
        -- upvalues: u23 (copy), Config (ref), Easing (ref), u24 (copy)
        if not u23:_isActive() then
            return true;
        end;

        local _sourceShakeFadeStartedAt = u23._sourceShakeFadeStartedAt;
        local v27;

        if _sourceShakeFadeStartedAt == nil then
            v27 = 1;
        else
            local v28 = (os.clock() - _sourceShakeFadeStartedAt) / Config.ShakeFadeSeconds;
            v27 = 1 - Easing(math.clamp(v28, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        end;

        local v29 = math.sin(p26 * 3.141592653589793 * 2 * Config.PetShakeXHz) * Config.PetShakeStuds * v27;
        local v30 = math.cos(p26 * 3.141592653589793 * 2 * Config.PetShakeZHz) * Config.PetShakeStuds * v27;
        local v31 = Vector3.new(v29, 0, v30);
        u23._movementBatch:SetPresentationOffset(u23._sourceModel, CFrame.new(v31));
        local v32 = (math.sin(p26 * 3.141592653589793 * 2 * Config.HighlightPulseHz) + 1) * 0.5;
        u24.FillColor = Config.HighlightDark:Lerp(Config.HighlightNearWhite, v32);

        return nil;
    end);
    task.wait(Config.PetShakeSeconds);
end;

function u1._prepareSourceClone(p33) -- Line: 173
    -- upvalues: anchorClone (copy)
    local v34 = p33._sourceModel:Clone();
    anchorClone(v34);
    p33._sourceClone = v34;
end;

function u1._beginEggCapture(p35, p36) -- Line: 179
    -- upvalues: EggCapturePresentation (copy), Config (copy)
    p35._eggHighlight = p35:_createHighlight("DnaStealEggHighlight", p36);
    EggCapturePresentation.BeginEgg(p36, Config.HighlightDark);
    p35._eggCaptureActive = true;
end;

function u1._renderEgg(p37) -- Line: 186
    -- upvalues: EggRenderer (copy), Players (copy), __DEBRIS (copy), Asserts (copy), BBFromModelVisibleOnly (copy)
    local _payload = p37._payload;
    local Model = EggRenderer.RenderVisual({
        OwnerUserId = Players.LocalPlayer.UserId,
        UID = _payload.EggUID,
        ModelName = `{Players.LocalPlayer.UserId}_{_payload.EggUID}`,
        Record = _payload.EggRecord
    }, __DEBRIS).Model;
    local v38 = Model:GetScale();
    local v39 = EggRenderer.GetAuthoredScale(_payload.EggRecord);
    Model:ScaleTo(v39);
    local PrimaryPart = Model.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    PrimaryPart.PivotOffset = CFrame.new(0, -PrimaryPart.Size.Y * 0.5, 0);
    local v40 = BBFromModelVisibleOnly(p37._sourceModel);
    Model:PivotTo(CFrame.new(v40.Position) * p37._sourceModel:GetPivot().Rotation);
    local v41 = BBFromModelVisibleOnly(Model);
    Model:PivotTo(Model:GetPivot() + (v40.Position - v41.Position));
    p37._eggModel = Model;

    return Model, v39, v38;
end;

function u1._landingCFrame(p42, p43) -- Line: 210
    -- upvalues: BBFromModelVisibleOnly (copy), Player (copy), Players (copy), Config (copy), AssetMovementBatch (copy)
    local Position = BBFromModelVisibleOnly(p42._sourceModel).Position;
    local v44 = Player.PrimaryPart(Players.LocalPlayer):GetPivot();
    local Position2 = v44.Position;
    local v45 = Vector3.new(Position2.X - Position.X, 0, Position2.Z - Position.Z);
    local v46;

    if v45.Magnitude > 0.001 then
        v46 = v45.Unit;
    else
        local v47 = v44.LookVector * Vector3.new(1, 0, 1);

        if v47.Magnitude <= 0.001 then
            v47 = v44.RightVector * Vector3.new(1, 0, 1);
        end;

        assert(v47.Magnitude > 0.001, "Player body must provide a horizontal landing direction");
        v46 = v47.Unit;
    end;

    local v48 = Position + v46 * (v45.Magnitude + Config.LandingBeyondPlayerStuds);
    local v49 = CFrame.lookAt(v48, v48 - v46);

    return AssetMovementBatch.ResolveGroundedCFrame(p43, v49);
end;

function u1._absorb(u50, u51, u52, u53) -- Line: 231
    -- upvalues: EggCapturePresentation (copy), Config (copy), __DEBRIS (copy), RenderStepped (copy), Easing (copy), OrbAbsorption (copy)
    local v54 = assert(u50._sourceClone, "Clean source clone must be prepared before animation presentation");
    EggCapturePresentation.ApplySourceClone(v54, Config.OrbColor);
    v54.Parent = __DEBRIS;
    local u55 = assert(u50._eggHighlight, "Egg capture highlight must exist before the throw begins");
    assert(u50._eggCaptureActive, "Egg capture presentation must exist before absorption begins");
    local u56 = u51:GetPivot();
    local v66 = RenderStepped(function(p57, p58) -- Line: 244
        -- upvalues: u50 (copy), u51 (copy), Config (ref), Easing (ref), u55 (copy), EggCapturePresentation (ref), u52 (copy), u53 (copy), u56 (copy)
        if u50._destroyed or u51.Parent == nil then
            return true;
        end;

        local v59 = p58 * Config.AbsorptionSeconds;
        local v60 = 1 - Easing(math.clamp((v59 - (Config.AbsorptionSeconds - Config.ShakeFadeSeconds)) / Config.ShakeFadeSeconds, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v61 = (math.sin(v59 * 3.141592653589793 * 2 * Config.HighlightPulseHz) + 1) * 0.5;
        local v62 = Config.HighlightDark:Lerp(Config.HighlightNearWhite, v61);
        u55.FillColor = v62;
        EggCapturePresentation.UpdateEgg(u51, v62);
        local v63 = math.rad(Config.EggShakePitchDegrees) * math.sin(v59 * 3.141592653589793 * 2 * Config.EggShakePitchHz) * v60;
        local v64 = math.rad(Config.EggShakeRollDegrees) * math.cos(v59 * 3.141592653589793 * 2 * Config.EggShakeRollHz) * v60;
        local v65 = Easing(p58, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        u51:ScaleTo((math.lerp(u52, u53, v65)));
        u51:PivotTo(u56 * CFrame.Angles(v63, 0, v64));

        return nil;
    end, Config.AbsorptionSeconds, true);
    OrbAbsorption.Play(v54, u51);
    u50._sourceClone = nil;
    v66:Wait();

    if not u50._destroyed and u51.Parent ~= nil then
        u51:ScaleTo(u53);
        u51:PivotTo(u56);
        EggCapturePresentation.FadeAndRestoreEgg(u51, Config.EggRestoreSeconds, u53, Config.EggRestorePopMultiplier, Config.EggRestorePopRatio);
        u50._eggCaptureActive = false;
    end;
end;

function u1._claimEgg(u67, u68) -- Line: 284
    -- upvalues: Transparency (copy), RenderStepped (copy), Player (copy), Players (copy), Bezier (copy), Easing (copy), Config (copy)
    u67._sourceShakeFadeStartedAt = os.clock();
    local u69 = u68:GetScale();
    local u70 = u68:GetPivot();
    local u71 = Transparency();
    RenderStepped(function(p72, p73) -- Line: 291
        -- upvalues: u67 (copy), u68 (copy), Player (ref), Players (ref), Bezier (ref), u70 (copy), Easing (ref), Config (ref), u71 (copy), u69 (copy)
        if u67._destroyed or u68.Parent == nil then
            return true;
        end;

        local Position = Player.PrimaryPart(Players.LocalPlayer):GetPivot().Position;
        local Position2 = u70.Position;
        local Position3 = u70.Position;
        local v74 = (Position3 + Position) * 0.5;
        local Magnitude = ((Position3 - Position) * Vector3.new(1, 0, 1)).Magnitude;
        local X = v74.X;
        local v75 = math.max(Position3.Y, Position.Y) + Magnitude * 0.5;
        local v76 = Bezier(Position2, Vector3.new(X, v75, v74.Z), Position);
        local v77 = CFrame.new(v76(p73)) * u70.Rotation;
        local v78 = Vector3.new(Position.X, v77.Y, Position.Z);

        if (v77.Position - v78).Magnitude >= 0.001 then
            v77 = CFrame.lookAt(v77.Position, v78);
        end;

        u68:PivotTo(v77);
        local v79 = Easing(math.clamp((p73 - 0.6) / 0.4, 0, 1), Enum.EasingStyle.Exponential, Enum.EasingDirection.In);
        local _sourceHighlight = u67._sourceHighlight;

        if _sourceHighlight ~= nil then
            _sourceHighlight.FillTransparency = math.lerp(Config.HighlightFillTransparency, 1, p73);
        end;

        local _eggHighlight = u67._eggHighlight;

        if _eggHighlight ~= nil then
            _eggHighlight.FillTransparency = math.lerp(Config.HighlightFillTransparency, 1, p73);
        end;

        u71(u68, 1, v79);
        u68:ScaleTo((math.max(Config.MinScale, u69 * (1 - v79))));

        return nil;
    end, Config.ClaimFlightSeconds, true):Wait();
end;

function u1._play(p80) -- Line: 320
    -- upvalues: Config (copy), EggThrowLand (copy), Network (copy), ActiveAssets2 (copy), u2 (copy)
    task.wait(Config.InitialDelaySeconds);

    if not p80:_isActive() then
        p80:Destroy();

        return;
    end;

    p80:_prepareSourceClone();
    p80:_shakeSource();

    if not p80:_isActive() then
        p80:Destroy();

        return;
    end;

    local v81, v82, v83 = p80:_renderEgg();
    p80:_beginEggCapture(v81);
    local v84 = v81:GetPivot();
    local v85 = p80:_landingCFrame(v81);
    EggThrowLand.Play(v81, v84, v85, v82);

    if p80._destroyed then
        p80:Destroy();

        return;
    end;

    p80:_absorb(v81, v82, v83);

    if p80._destroyed or v81.Parent == nil then
        p80:Destroy();

        return;
    end;

    p80:_claimEgg(v81);

    if not p80._destroyed and v81:IsDescendantOf(game) then
        local _payload = p80._payload;
        local v86, v87 = Network.Invoke(ActiveAssets2.REQUEST_DNA_STEAL_ANIMATION_COMPLETE, {
            OwnerUserId = _payload.OwnerUserId,
            UID = _payload.UID,
            EggUID = _payload.EggUID
        });

        if not v86 then
            u2:AtWarning():Log((`DNA steal animation completed for egg {_payload.EggUID}, but the server rejected completion: {v87 or "unknown error"}`));
        end;
    end;

    p80:Destroy();
end;

function u1.Destroy(p88) -- Line: 374
    -- upvalues: EggCapturePresentation (copy)
    if p88._destroyed then
        return;
    end;

    p88._destroyed = true;
    local _sourceShake = p88._sourceShake;

    if _sourceShake ~= nil then
        _sourceShake:Disconnect();
        p88._sourceShake = nil;
    end;

    if p88._presentationFrozen and p88._sourceModel.Parent ~= nil then
        p88._movementBatch:SetPresentationOffset(p88._sourceModel, CFrame.identity);
        p88:_setPresentationFrozen(false);
    end;

    local _sourceHighlight = p88._sourceHighlight;

    if _sourceHighlight ~= nil then
        _sourceHighlight:Destroy();
    end;

    local _eggHighlight = p88._eggHighlight;

    if _eggHighlight ~= nil then
        _eggHighlight:Destroy();
    end;

    local _sourceClone = p88._sourceClone;

    if _sourceClone ~= nil then
        _sourceClone:Destroy();
    end;

    local _eggModel = p88._eggModel;

    if p88._eggCaptureActive and _eggModel ~= nil then
        EggCapturePresentation.RestoreEggImmediate(_eggModel);
        p88._eggCaptureActive = false;
    end;

    if _eggModel ~= nil then
        _eggModel:Destroy();
    end;
end;

return u1;