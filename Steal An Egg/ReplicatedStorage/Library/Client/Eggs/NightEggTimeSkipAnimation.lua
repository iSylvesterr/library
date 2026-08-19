-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local AreaEggResetTimeUtil = require(ReplicatedStorage.Library.Util.AreaEggResetTimeUtil);
local Assets = require(ReplicatedStorage.Directory.Assets);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local EggActionMovement = require(script.Parent.EggActionMovement);
local EggItemUtil = require(ReplicatedStorage.Library.Util.EggItemUtil);
local Eggs = require(ReplicatedStorage.Library.Types.Eggs);
local FormatDurationSymbol = require(ReplicatedStorage.Library.Functions.FormatDurationSymbol);
local GradientSwap = require(ReplicatedStorage.Library.Functions.GradientSwap);
local PlacedEggGrowthPresentationPolicy = require(script.Parent.PlacedEggGrowthPresentationPolicy);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local Transparency = require(ReplicatedStorage.Library.Functions.Transparency);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local u1 = {};
u1.__index = u1;
u1.__class = "NightEggTimeSkipAnimation";
local u2 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u3 = TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
local u4 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local NightEggTimeSkip = ReplicatedStorage.Assets.Billboards.NightEggTimeSkip;
local v5 = NightEggTimeSkip:IsA("BillboardGui");
assert(v5, "ReplicatedStorage.Assets.Billboards.NightEggTimeSkip must be a BillboardGui");

function u1.new(p6, p7, p8, p9, p10, p11, p12, p13) -- Line: 112
    -- upvalues: Asserts (copy), Eggs (copy), Assets (copy), AreaEggResetTimeUtil (copy), EggItemUtil (copy), u1 (copy), Transparency (copy), Trove (copy)
    Asserts.Model(p6);
    Asserts.string(p7);
    local v14 = Eggs.SchemaValidation.RuntimeEggRecord(p8);
    assert(v14, "Invalid runtime egg record");
    Asserts.CFrame(p9);
    Asserts.finite(p10);
    Asserts.finite(p11);
    Asserts.finite(p12);
    Asserts.finite(p13);
    local v15;

    if p10 > 0 then
        v15 = p11 > 0;
    else
        v15 = false;
    end;

    assert(v15, "Egg time skip scales must be positive");
    assert(p12 < p13, "Egg time skip day start must follow night start");
    assert(p8.Placement, "Night egg time skip requires a placed egg");
    local v16 = Assets.Directory[p8.AssetCategory];
    local v17 = `Missing asset config for category {p8.AssetCategory}`;
    assert(v16 ~= nil, v17);
    local GrowthSpeedMultiplier = p8.GrowthSpeedMultiplier;
    local v18 = AreaEggResetTimeUtil.GetPeriodIndex(p13);
    local v19 = EggItemUtil.GetCommittedNightGrowthCreditSeconds(p8, v18);
    local v20 = EggItemUtil.GetRemainingGrowthSeconds(p8, p12, GrowthSpeedMultiplier) + v19;
    local v21 = math.min(AreaEggResetTimeUtil.NightGrowthSkipSeconds, v20);
    local v22 = setmetatable({}, u1);
    v22._model = p6;
    v22._uid = p7;
    v22._record = p8;
    v22._basePivot = p9;
    v22._startScale = p10;
    v22._targetScale = p11;
    v22._growthSpeedMultiplier = GrowthSpeedMultiplier;
    v22._nightStartsAt = p12;
    v22._dayStartsAt = p13;
    v22._nightPeriodIndex = v18;
    v22._nightTargetCreditSeconds = v21;
    v22._committedNightCreditSeconds = v19;
    v22._skipSeconds = math.max(0, v21 - v19);
    v22._remainingAtNightfall = v20;
    v22._nightScaleStart = p10;
    v22._nightScaleEnd = p11;
    v22._snappedGrowthScale = nil;
    assert(v22._skipSeconds > 0, "Night egg time skip requires remaining growth time");
    v22._appliedSeconds = Instance.new("NumberValue");
    v22._billboardTransparency = Transparency();
    v22._lifecycleTrove = Trove.new();
    v22._visualTrove = Trove.new();
    v22._animation = nil;
    v22._visualFinishing = false;
    v22._visualFinished = false;
    v22._billboardFadeFinished = false;
    v22._pendingCommit = true;
    v22._destroyed = false;
    v22._lastTimerSecond = -1;
    v22._lastShakeElapsed = 0;
    v22._lastShakeAlpha = 0;
    v22._lastShakePitch = 0;
    v22._lastShakeRoll = 0;
    v22._billboard = nil;
    v22._timerLabel = nil;
    v22._textScale = nil;
    v22._originalTextColor = nil;
    v22._rarityGradient = v16.Rarity.Gradient;
    v22:_refreshNightScaleRange();
    v22._lifecycleTrove:Add(v22._appliedSeconds);
    v22:_init();

    return v22;
end;

function u1._getAppliedSecondsAt(p23, p24) -- Line: 192
    -- upvalues: EggItemUtil (copy)
    return EggItemUtil.GetNightGrowthCreditSecondsAt(p23._record, p24, p23._growthSpeedMultiplier, p23._nightStartsAt, p23._nightPeriodIndex);
end;

function u1._getGrowthScaleAt(p25, p26) -- Line: 202
    -- upvalues: EggItemUtil (copy)
    local v27 = EggItemUtil.GetGrowthAlpha(p25._record, p26, p25._growthSpeedMultiplier, p25:_getAppliedSecondsAt(p26));

    return math.lerp(p25._startScale, p25._targetScale, v27);
end;

function u1._refreshNightScaleRange(p28) -- Line: 208
    local v29 = p28:_getGrowthScaleAt(p28._nightStartsAt);
    local v30 = p28:_getGrowthScaleAt(p28._dayStartsAt);
    local v31 = math.abs(p28._nightScaleStart - v29) > 0.001 and true or math.abs(p28._nightScaleEnd - v30) > 0.001;
    p28._nightScaleStart = v29;
    p28._nightScaleEnd = v30;

    if v31 then
        p28._snappedGrowthScale = nil;
    end;
end;

function u1._createPresentation(p32) -- Line: 220
    -- upvalues: Asserts (copy), NightEggTimeSkip (copy), GradientSwap (copy), FormatDurationSymbol (copy), AreaEggResetTimeUtil (copy)
    local PrimaryPart = p32._model.PrimaryPart;
    Asserts.BasePart(PrimaryPart);
    local v33 = math.max(0.1, (PrimaryPart.Size.X / 6.388999938964844 * (PrimaryPart.Size.Y / 7.507999897003174) * (PrimaryPart.Size.Z / 6.367000102996826)) ^ 0.3333333333333333 * 0.9);
    local v34 = math.min(5, v33);
    local Attachment = Instance.new("Attachment");
    Attachment.Name = "NightEggTimeSkipAttachment";
    Attachment.Parent = PrimaryPart;
    p32._visualTrove:Add(Attachment);
    local u35 = NightEggTimeSkip:Clone();
    local Main = u35.Main;
    local v36 = Main:IsA("Frame");
    assert(v36, "NightEggTimeSkip.Main must be a Frame");
    local v37 = nil;

    for _, child in Main:GetChildren() do
        if child:IsA("Frame") then
            assert(v37 == nil, "NightEggTimeSkip.Main must contain exactly one content Frame");
            v37 = child;
        end;
    end;

    local v38 = assert(v37, "NightEggTimeSkip.Main must contain a content Frame");
    local Timer = v38.Timer;
    local v39 = Timer:IsA("Frame");
    assert(v39, "NightEggTimeSkip.Main.Frame.Timer must be a Frame");
    local Timer2 = Timer.Timer;
    local v40 = Timer2:IsA("TextLabel");
    assert(v40, "NightEggTimeSkip.Main.Frame.Timer.Timer must be a TextLabel");
    local Multiplier = Timer.Multiplier;
    local v41 = Multiplier:IsA("TextLabel");
    assert(v41, "NightEggTimeSkip.Main.Frame.Timer.Multiplier must be a TextLabel");
    local DisplayName = v38.DisplayName;
    local v42 = DisplayName:IsA("TextLabel");
    assert(v42, "NightEggTimeSkip.Main.Frame.DisplayName must be a TextLabel");
    DisplayName.Text = "Egg";
    GradientSwap(DisplayName, p32._rarityGradient);
    local Size = u35.Size;
    u35.Size = UDim2.new(Size.X.Scale * v34, Size.X.Offset * v34, Size.Y.Scale * v34, Size.Y.Offset * v34);
    u35.StudsOffsetWorldSpace = Vector3.new(0, -2, 0);
    u35.Adornee = Attachment;
    u35.Parent = Attachment;
    p32._billboard = u35;
    p32._timerLabel = Timer2;
    p32._originalTextColor = Timer2.TextColor3;
    p32._visualTrove:Add(u35);
    local UIScale = Instance.new("UIScale");
    UIScale.Name = "NightEggTimeSkipScale";
    UIScale.Scale = 1;
    UIScale.Parent = Timer2;
    p32._textScale = UIScale;
    local _billboardTransparency = p32._billboardTransparency;
    p32._visualTrove:Add(function() -- Line: 282
        -- upvalues: _billboardTransparency (copy), u35 (copy)
        _billboardTransparency(u35, 1, 0);
    end);
    _billboardTransparency(u35, 1, 1);
    local v43 = math.floor(p32._remainingAtNightfall - p32._committedNightCreditSeconds + 0.5);
    local v44 = math.max(0, v43);
    Timer2.Text = v44 == 0 and "READY!" or FormatDurationSymbol(v44);
    local v45 = AreaEggResetTimeUtil.GetNightGrowthBonusRate() * 10;
    Multiplier.Text = `(x{math.round(v45) / 10})`;
end;

function u1._setAppliedSeconds(p46, p47) -- Line: 292
    -- upvalues: FormatDurationSymbol (copy)
    local v48 = math.clamp(p47, 0, p46._skipSeconds);
    p46._appliedSeconds.Value = v48;
    local v49 = math.floor(p46._remainingAtNightfall - p46._committedNightCreditSeconds - v48 + 0.5);
    local v50 = math.max(0, v49);

    if v50 == p46._lastTimerSecond then
        return;
    end;

    p46._lastTimerSecond = v50;
    local _timerLabel = p46._timerLabel;

    if _timerLabel ~= nil then
        _timerLabel.Text = v50 == 0 and "READY!" or FormatDurationSymbol(v50);
    end;
end;

function u1._applyShake(p51, p52, p53) -- Line: 308
    -- upvalues: EggActionMovement (copy)
    local v54 = math.sin(p52 * 3.141592653589793 * 2 * 1.75) * 0.039269908169872414 * p53;
    local v55 = math.cos(p52 * 3.141592653589793 * 2 * 2.25) * 0.05672320068981571 * p53;
    p51._lastShakeElapsed = p52;
    p51._lastShakeAlpha = p53;
    p51._lastShakePitch = v54;
    p51._lastShakeRoll = v55;
    EggActionMovement.SetPivot(p51._model, p51._basePivot * CFrame.Angles(v54, 0, v55));
end;

function u1._updateModel(p56, p57) -- Line: 318
    -- upvalues: PlacedEggGrowthPresentationPolicy (copy), Easing (copy)
    local _model = p56._model;
    p56:_setAppliedSeconds((p56:_getAppliedSecondsAt(p57)));
    local v58 = PlacedEggGrowthPresentationPolicy.GetGrowthScaleDeltaSkipReason(p56._nightScaleStart, p56._nightScaleEnd);

    if v58 == nil then
        p56._snappedGrowthScale = nil;
        _model:ScaleTo(p56:_getGrowthScaleAt(p57));
    elseif p56._snappedGrowthScale ~= p56._nightScaleEnd then
        _model:ScaleTo(p56._nightScaleEnd);
        p56._snappedGrowthScale = p56._nightScaleEnd;
        PlacedEggGrowthPresentationPolicy.LogSkipped(p56._uid, "night growth scale channel", v58);
    end;

    local v59 = math.max(0, p57 - p56._nightStartsAt);
    p56:_applyShake(v59, (Easing(math.clamp(v59 / 5, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)));
    local _billboard = p56._billboard;

    if _billboard == nil then
        p56._billboardFadeFinished = true;

        return;
    end;

    local v60 = Easing(math.clamp(v59 / 1, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    _billboard.StudsOffsetWorldSpace = (Vector3.new(0, -2, 0)):Lerp(Vector3.new(0, 0, 0), v60);
    p56._billboardTransparency(_billboard, 1, 1 - v60);
end;

function u1._fadeVisuals(u61) -- Line: 351
    -- upvalues: RenderStepped (copy), Easing (copy)
    local _billboard = u61._billboard;

    if _billboard == nil then
        u61._billboardFadeFinished = true;

        return;
    end;

    local _billboardTransparency = u61._billboardTransparency;
    local _lastShakeElapsed = u61._lastShakeElapsed;
    local _lastShakeAlpha = u61._lastShakeAlpha;
    local v68 = RenderStepped(function(p62, p63) -- Line: 360
        -- upvalues: u61 (copy), Easing (ref), _billboardTransparency (copy), _billboard (copy), _lastShakeElapsed (copy), _lastShakeAlpha (copy)
        if u61._destroyed then
            return true;
        end;

        local v64 = p63 * 5;
        local v65 = math.clamp(v64 / 1, 0, 1);
        local v66 = Easing(v65, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v67 = Easing(p63, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        _billboardTransparency(_billboard, 1, v66);

        if v65 >= 1 then
            u61._billboardFadeFinished = true;
        end;

        u61:_applyShake(_lastShakeElapsed + v64, _lastShakeAlpha * (1 - v67));

        return nil;
    end, 5, true);
    u61._animation = v68;
    v68:Wait();

    if u61._animation == v68 then
        u61._animation = nil;
    end;
end;

function u1._playTextFinish(p69) -- Line: 382
    -- upvalues: TweenService (copy), u2 (copy), u4 (copy), u3 (copy)
    local _timerLabel = p69._timerLabel;
    local _textScale = p69._textScale;
    local _originalTextColor = p69._originalTextColor;

    if _timerLabel == nil or (_textScale == nil or _originalTextColor == nil) then
        return;
    end;

    local v70 = TweenService:Create(_textScale, u2, {
        Scale = 1.5
    });
    local v71 = TweenService:Create(_timerLabel, u4, {
        TextColor3 = Color3.new(1, 1, 1)
    });
    p69._visualTrove:Add(v70);
    p69._visualTrove:Add(v71);
    v70:Play();
    v71:Play();
    v70.Completed:Wait();

    if p69._destroyed then
        return;
    end;

    local v72 = TweenService:Create(_textScale, u3, {
        Scale = 1
    });
    local v73 = TweenService:Create(_timerLabel, u4, {
        TextColor3 = _originalTextColor
    });
    p69._visualTrove:Add(v72);
    p69._visualTrove:Add(v73);
    v72:Play();
    v73:Play();
    v72.Completed:Wait();

    if not p69._destroyed then
        _timerLabel.TextColor3 = _originalTextColor;
    end;
end;

function u1._finishVisuals(u74, p75) -- Line: 413
    -- upvalues: Workspace (copy), RenderStepped (copy), EggActionMovement (copy)
    if u74._visualFinishing or (u74._visualFinished or u74._destroyed) then
        return;
    end;

    u74._visualFinishing = true;
    local _animation = u74._animation;

    if _animation ~= nil then
        _animation:Disconnect();
        u74._animation = nil;
    end;

    local v76;

    if p75 then
        v76 = u74._skipSeconds;
    else
        v76 = u74:_getAppliedSecondsAt(Workspace:GetServerTimeNow());
    end;

    u74:_setAppliedSeconds(v76);

    if p75 then
        local _lastShakeElapsed = u74._lastShakeElapsed;
        local _lastShakeAlpha = u74._lastShakeAlpha;
        local v79 = RenderStepped(function(p77, p78) -- Line: 430
            -- upvalues: u74 (copy), _lastShakeElapsed (copy), _lastShakeAlpha (copy)
            if u74._destroyed then
                return true;
            end;

            u74:_applyShake(_lastShakeElapsed + p78, _lastShakeAlpha);

            return nil;
        end);
        u74._animation = v79;
        u74:_playTextFinish();
        v79:Disconnect();

        if u74._animation == v79 then
            u74._animation = nil;
        end;
    end;

    if not u74._destroyed then
        u74:_fadeVisuals();
    end;

    if u74._destroyed then
        return;
    end;

    u74._lastShakeAlpha = 0;
    u74._lastShakePitch = 0;
    u74._lastShakeRoll = 0;
    EggActionMovement.SetPivot(u74._model, u74._basePivot);
    u74._visualTrove:Clean();
    u74._billboard = nil;
    u74._timerLabel = nil;
    u74._textScale = nil;
    u74._visualFinishing = false;
    u74._visualFinished = true;
end;

function u1._start(u80) -- Line: 463
    -- upvalues: RenderStepped (copy), Workspace (copy), EggItemUtil (copy)
    u80:_createPresentation();
    u80._animation = RenderStepped(function(p81, p82) -- Line: 465
        -- upvalues: u80 (copy), Workspace (ref), EggItemUtil (ref)
        if u80._destroyed or u80._model.Parent == nil then
            return true;
        end;

        local v83 = Workspace:GetServerTimeNow();
        u80:_updateModel(v83);

        if EggItemUtil.GetRemainingGrowthSeconds(u80._record, v83, u80._growthSpeedMultiplier, u80._appliedSeconds.Value) <= 0 and v83 < u80._dayStartsAt then
            task.spawn(u80._finishVisuals, u80, false);

            return true;
        end;

        if u80._dayStartsAt > v83 then
            return nil;
        end;

        task.spawn(u80._finishVisuals, u80, true);

        return true;
    end);
end;

function u1._init(p84) -- Line: 490
    p84:_start();
end;

function u1.GetAppliedSecondsValue(p85) -- Line: 498
    return p85._appliedSeconds;
end;

function u1.IsComplete(p86) -- Line: 502
    return p86._visualFinished and not p86._pendingCommit;
end;

function u1.IsBillboardFadeFinished(p87) -- Line: 506
    return p87._billboardFadeFinished;
end;

function u1.SetTransform(p88, p89, p90, p91) -- Line: 510
    -- upvalues: Asserts (copy)
    Asserts.CFrame(p89);
    Asserts.finite(p90);
    Asserts.finite(p91);
    p88._basePivot = p89;
    p88._startScale = p90;
    p88._targetScale = p91;
    p88:_refreshNightScaleRange();
end;

function u1.AcknowledgeRecord(p92, p93) -- Line: 525
    -- upvalues: Eggs (copy), EggItemUtil (copy), AreaEggResetTimeUtil (copy), Workspace (copy)
    local v94 = Eggs.SchemaValidation.RuntimeEggRecord(p93);
    assert(v94, "Invalid runtime egg record");
    p92._record = p93;
    p92._growthSpeedMultiplier = p93.GrowthSpeedMultiplier;
    local Placement = p93.Placement;

    if Placement == nil or Placement.ReadyAt ~= nil then
        p92:_setAppliedSeconds(0);
        p92._pendingCommit = false;

        return;
    end;

    local v95 = EggItemUtil.GetCommittedNightGrowthCreditSeconds(p93, p92._nightPeriodIndex);
    p92._committedNightCreditSeconds = v95;
    local v96 = EggItemUtil.GetRemainingGrowthSeconds(p93, p92._nightStartsAt, p92._growthSpeedMultiplier) + v95;
    p92._remainingAtNightfall = v96;
    p92._nightTargetCreditSeconds = math.min(AreaEggResetTimeUtil.NightGrowthSkipSeconds, v96);
    p92._skipSeconds = math.max(0, p92._nightTargetCreditSeconds - v95);
    p92:_refreshNightScaleRange();
    p92:_setAppliedSeconds(p92:_getAppliedSecondsAt(Workspace:GetServerTimeNow()));

    if p92._nightTargetCreditSeconds - 0.05 <= v95 then
        p92._pendingCommit = false;
    end;
end;

function u1.CancelVisual(p97) -- Line: 553
    if p97._visualFinished or p97._visualFinishing then
        return;
    end;

    task.spawn(p97._finishVisuals, p97, false);
end;

function u1.Destroy(p98) -- Line: 560
    -- upvalues: EggActionMovement (copy)
    if p98._destroyed then
        return;
    end;

    p98._destroyed = true;
    local _animation = p98._animation;

    if _animation ~= nil then
        _animation:Disconnect();
        p98._animation = nil;
    end;

    p98._visualTrove:Destroy();
    p98._lifecycleTrove:Destroy();

    if p98._model.Parent ~= nil then
        EggActionMovement.SetPivot(p98._model, p98._basePivot);
    end;
end;

return u1;