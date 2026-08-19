-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local ArrowPointer3D = require(ReplicatedStorage.Library.Client.WorldFX.ArrowPointer3D);
require(ReplicatedStorage.Library.Client.WorldFX.ArrowPointer3D.Types.Interface);
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local TutorialBeam = require(ReplicatedStorage.Library.Client.WorldFX.TutorialBeam);
local TutorialHighlightOverlay = require(script.TutorialHighlightOverlay);
local TutorialMessageAnimator = require(ReplicatedStorage.Library.Client.UI.TutorialMessageAnimator);
local Tween = require(ReplicatedStorage.Library.Functions.Tween);
local TutorialTapIndicator = require(script.TutorialTapIndicator);
local u1 = Log.new();
local u2 = {};
u2.__index = u2;
u2.__class = "GuardTutorialPresentationComponent";

function u2.new() -- Line: 86
    -- upvalues: u2 (copy)
    local v3 = setmetatable({}, u2);
    v3._arrow = nil;
    v3._beamHandle = nil;
    v3._billboardClick = nil;
    v3._billboardClickTween = nil;
    v3._createdReadyLabelScale = false;
    v3._defaultMessageFramePosition = nil;
    v3._defaultMessageStrokeTransparency = nil;
    v3._defaultMessageTransparency = nil;
    v3._highlightCleanup = nil;
    v3._messageAnimator = nil;
    v3._messageFrame = nil;
    v3._messageGradient = nil;
    v3._messageGui = nil;
    v3._messageLabel = nil;
    v3._messageLabelStroke = nil;
    v3._messageTransitionId = 0;
    v3._progressionFill = nil;
    v3._progressionFillTween = nil;
    v3._progressionFrame = nil;
    v3._readyLabel = nil;
    v3._readyLabelScale = nil;
    v3._readyLabelScaleTween = nil;
    v3._readyLabelWhite = nil;
    v3._readyLabelWhiteTween = nil;
    v3._tapCleanup = nil;
    v3._screenClickGui = nil;
    v3._screenClickTween = nil;

    return v3;
end;

local function assertPresentationTarget(p4) -- Line: 124
    local v5;

    if typeof(p4) == "Vector3" then
        v5 = true;
    elseif typeof(p4) == "Instance" then
        v5 = p4:IsA("BasePart");
    else
        v5 = false;
    end;

    assert(v5, "Tutorial presentation target must be a BasePart or Vector3");
end;

function u2._getMessageAnimator(p6) -- Line: 129
    -- upvalues: GUI (copy), TutorialMessageAnimator (copy)
    if p6._messageGui ~= nil and (p6._messageFrame ~= nil and (p6._messageLabel ~= nil and (p6._messageGradient ~= nil and (p6._messageAnimator ~= nil and p6._messageLabelStroke ~= nil)))) then
        return p6._messageGui, p6._messageFrame, p6._messageLabel, p6._messageGradient, p6._messageAnimator, p6._messageLabelStroke;
    end;

    local v7 = GUI.TutorialInstructions();
    local v8 = v7:IsA("ScreenGui");
    assert(v8, "TutorialInstructions must be a ScreenGui");
    local Frame = v7.Frame;
    local v9 = Frame:IsA("Frame");
    assert(v9, "TutorialInstructions.Frame must be a Frame");
    local TextLabel = Frame.TextLabel;
    local v10 = TextLabel:IsA("TextLabel");
    assert(v10, "TutorialInstructions.Frame.TextLabel must be a TextLabel");
    local UIStroke = Frame.TextLabel.UIStroke;
    local v11 = UIStroke:IsA("UIStroke");
    assert(v11, "TutorialInstructions.Frame.TextLabel.UIStroke must be a UIStroke");
    local UIGradient = TextLabel.UIGradient;
    local v12 = UIGradient:IsA("UIGradient");
    assert(v12, "TutorialInstructions.Frame.TextLabel.UIGradient must be a UIGradient");
    local v13 = TutorialMessageAnimator.new(TextLabel);
    p6._messageGui = v7;
    p6._messageFrame = Frame;
    p6._messageGradient = UIGradient;
    p6._messageLabel = TextLabel;
    p6._messageAnimator = v13;
    p6._messageLabelStroke = UIStroke;

    if p6._defaultMessageFramePosition == nil then
        p6._defaultMessageFramePosition = Frame.Position;
    end;

    if p6._defaultMessageTransparency == nil then
        p6._defaultMessageTransparency = TextLabel.TextTransparency;
    end;

    if p6._defaultMessageStrokeTransparency == nil then
        p6._defaultMessageStrokeTransparency = TextLabel.TextStrokeTransparency;
    end;

    return v7, Frame, TextLabel, UIGradient, v13, UIStroke;
end;

function u2._getProgressionElements(p14) -- Line: 187
    if p14._progressionFrame ~= nil and (p14._progressionFill ~= nil and (p14._readyLabel ~= nil and (p14._readyLabelScale ~= nil and p14._readyLabelWhite ~= nil))) then
        return p14._progressionFrame, p14._progressionFill, p14._readyLabel, p14._readyLabelScale, p14._readyLabelWhite;
    end;

    local _, v15 = p14:_getMessageAnimator();
    local Progression = v15.Progression;
    local v16 = Progression:IsA("GuiObject");
    assert(v16, "TutorialInstructions.Frame.Progression must be a GuiObject");
    local Fill = Progression.Fill;
    local v17 = Fill:IsA("GuiObject");
    assert(v17, "TutorialInstructions.Frame.Progression.Fill must be a GuiObject");
    local ReadyLabel = Progression.ReadyLabel;
    local v18 = ReadyLabel:IsA("GuiObject");
    assert(v18, "TutorialInstructions.Frame.Progression.ReadyLabel must be a GuiObject");
    local ReadyLabelWhite = ReadyLabel.ReadyLabelWhite;
    local v19 = ReadyLabelWhite:IsA("TextLabel");
    assert(v19, "TutorialInstructions.Frame.Progression.ReadyLabel.ReadyLabelWhite must be a TextLabel");
    local v20 = ReadyLabel:FindFirstChildOfClass("UIScale");

    if v20 == nil then
        v20 = Instance.new("UIScale");
        v20.Parent = ReadyLabel;
        p14._createdReadyLabelScale = true;
    end;

    p14._progressionFrame = Progression;
    p14._progressionFill = Fill;
    p14._readyLabel = ReadyLabel;
    p14._readyLabelScale = v20;
    p14._readyLabelWhite = ReadyLabelWhite;

    return Progression, Fill, ReadyLabel, v20, ReadyLabelWhite;
end;

function u2._setMessageGradientEnabled(p21, p22) -- Line: 245
    if p21._messageGradient == nil then
        return;
    end;

    p21._messageGradient.Enabled = p22;
end;

function u2._resetMessageFramePosition(p23) -- Line: 256
    if p23._messageFrame == nil or p23._defaultMessageFramePosition == nil then
        return;
    end;

    p23._messageFrame.Position = p23._defaultMessageFramePosition;
end;

function u2._resetMessageTransparency(p24) -- Line: 264
    if p24._messageLabel == nil or p24._messageLabelStroke == nil then
        return;
    end;

    p24._messageLabel.TextTransparency = p24._defaultMessageTransparency or 0;
    p24._messageLabelStroke.Transparency = 0;
    p24._messageLabel.TextStrokeTransparency = p24._defaultMessageStrokeTransparency or 1;
end;

function u2._clearTap(p25) -- Line: 274
    if p25._tapCleanup == nil then
        return;
    end;

    local _tapCleanup = p25._tapCleanup;
    p25._tapCleanup = nil;
    _tapCleanup();
end;

function u2._clearHighlight(p26) -- Line: 284
    if p26._highlightCleanup == nil then
        return;
    end;

    local _highlightCleanup = p26._highlightCleanup;
    p26._highlightCleanup = nil;
    _highlightCleanup();
end;

function u2._clearArrow(p27) -- Line: 294
    if p27._arrow == nil then
        return;
    end;

    local _arrow = p27._arrow;
    p27._arrow = nil;
    _arrow:Destroy();
end;

function u2._clearBeam(p28) -- Line: 304
    -- upvalues: TutorialBeam (copy)
    if p28._beamHandle == nil then
        return;
    end;

    local _beamHandle = p28._beamHandle;
    p28._beamHandle = nil;
    TutorialBeam.Destroy(_beamHandle);
end;

function u2._clearBillboardClick(p29) -- Line: 314
    if p29._billboardClickTween ~= nil then
        p29._billboardClickTween:Cancel();
        p29._billboardClickTween = nil;
    end;

    if p29._billboardClick ~= nil then
        p29._billboardClick:Destroy();
        p29._billboardClick = nil;
    end;
end;

function u2._clearScreenClick(p30) -- Line: 326
    if p30._screenClickTween ~= nil then
        p30._screenClickTween:Cancel();
        p30._screenClickTween = nil;
    end;

    if p30._screenClickGui ~= nil then
        p30._screenClickGui.Enabled = false;
    end;
end;

local function playClickPulse(p31) -- Line: 337
    -- upvalues: TweenService (copy)
    p31.Scale = 1;
    local v32 = TweenService:Create(p31, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {
        Scale = 1.3
    });
    v32:Play();

    return v32;
end;

function u2._clearProgressionTweens(p33) -- Line: 348
    if p33._progressionFillTween ~= nil then
        p33._progressionFillTween:Cancel();
        p33._progressionFillTween = nil;
    end;

    if p33._readyLabelScaleTween ~= nil then
        p33._readyLabelScaleTween:Cancel();
        p33._readyLabelScaleTween = nil;
    end;

    if p33._readyLabelWhiteTween ~= nil then
        p33._readyLabelWhiteTween:Cancel();
        p33._readyLabelWhiteTween = nil;
    end;
end;

function u2._setReadyProgressionVisible(p34, p35, p36, p37, p38) -- Line: 365
    -- upvalues: TweenService (copy)
    if not p38 then
        if p34._readyLabelScaleTween ~= nil then
            p34._readyLabelScaleTween:Cancel();
            p34._readyLabelScaleTween = nil;
        end;

        if p34._readyLabelWhiteTween ~= nil then
            p34._readyLabelWhiteTween:Cancel();
            p34._readyLabelWhiteTween = nil;
        end;

        p35.Visible = false;
        p36.Scale = 1;
        p37.TextTransparency = 1;

        return;
    end;

    if p34._readyLabelScaleTween ~= nil and p34._readyLabelWhiteTween ~= nil then
        return;
    end;

    p35.Visible = true;
    p36.Scale = 1;
    p37.TextTransparency = 1;
    local v39 = TweenService:Create(p36, TweenInfo.new(0.45, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out, -1, true), {
        Scale = 1.2
    });
    local v40 = TweenService:Create(p37, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1, true), {
        TextTransparency = 0
    });
    p34._readyLabelScaleTween = v39;
    p34._readyLabelWhiteTween = v40;
    v39:Play();
    v40:Play();
end;

function u2.ShowAnimatedMessage(p41, p42, p43) -- Line: 421
    -- upvalues: Asserts (copy)
    Asserts.string(p42);
    Asserts.Color3(p43);
    local v44, _, _, _, v45 = p41:_getMessageAnimator();
    p41._messageTransitionId = p41._messageTransitionId + 1;
    p41:_resetMessageTransparency();
    v44.Enabled = true;
    v45:SetAnimated(p42, p43);
end;

function u2.ShowInstantMessage(p46, p47, p48) -- Line: 436
    -- upvalues: Asserts (copy)
    Asserts.string(p47);
    Asserts.Color3(p48);
    local v49, _, _, _, v50 = p46:_getMessageAnimator();
    p46._messageTransitionId = p46._messageTransitionId + 1;
    p46:_resetMessageTransparency();
    v49.Enabled = true;
    v50:SetInstant(p47, p48);
end;

function u2.TransitionMessage(u51, u52, u53) -- Line: 451
    -- upvalues: Asserts (copy), Tween (copy), TweenService (copy)
    Asserts.string(u52);
    Asserts.Color3(u53);
    local v54, _, u55, _, v56, u57 = u51:_getMessageAnimator();
    u51._messageTransitionId = u51._messageTransitionId + 1;
    local _messageTransitionId = u51._messageTransitionId;
    v54.Enabled = true;
    v56:Stop();

    local function v58() -- Line: 466
        -- upvalues: _messageTransitionId (copy), u51 (copy), u55 (copy), u52 (copy), u53 (copy), u57 (copy), Tween (ref), TweenService (ref)
        if _messageTransitionId ~= u51._messageTransitionId then
            return;
        end;

        u55.RichText = true;
        u55.Text = u52;
        u55.TextColor3 = u53;
        u55.MaxVisibleGraphemes = -1;
        u55.TextTransparency = 1;
        u55.TextStrokeTransparency = 1;
        u57.Transparency = 1;
        Tween(u57, {
            Transparency = 0
        }, { 0.02 });
        TweenService:Create(u55, TweenInfo.new(0.02), {
            TextTransparency = u51._defaultMessageTransparency or 0,
            TextStrokeTransparency = u51._defaultMessageStrokeTransparency or 1
        }):Play();
    end;

    if u55.Text == "" then
        v58();

        return;
    end;

    local v59 = TweenService:Create(u55, TweenInfo.new(0.02), {
        TextTransparency = 1,
        TextStrokeTransparency = 1
    });
    Tween(u57, {
        Transparency = 1
    }, { 0.02 });
    v59.Completed:Connect(v58);
    v59:Play();
end;

function u2.SetMessageGradientEnabled(p60, p61) -- Line: 502
    -- upvalues: Asserts (copy)
    Asserts.boolean(p61);
    local _, _, _, _ = p60:_getMessageAnimator();
    p60:_setMessageGradientEnabled(p61);
end;

function u2.SetMessageFrameYScale(p62, p63) -- Line: 511
    -- upvalues: Asserts (copy)
    Asserts.optional.number(p63);
    local _, v64 = p62:_getMessageAnimator();
    local v65 = p62._defaultMessageFramePosition or v64.Position;

    if p63 == nil then
        v64.Position = v65;

        return;
    end;

    v64.Position = UDim2.new(v65.X.Scale, v65.X.Offset, p63, v65.Y.Offset);
end;

function u2.ClearMessage(p66) -- Line: 527
    p66._messageTransitionId = p66._messageTransitionId + 1;

    if p66._messageAnimator ~= nil then
        p66._messageAnimator:Clear();
    end;

    if p66._messageLabel ~= nil then
        p66._messageLabel.Text = "";
        p66:_resetMessageTransparency();
    end;

    p66:_resetMessageFramePosition();
    p66:_setMessageGradientEnabled(false);

    if p66._messageGui ~= nil then
        p66._messageGui.Enabled = false;
    end;
end;

function u2.ShowSpeedProgression(p67, p68, p69) -- Line: 546
    -- upvalues: Asserts (copy), TweenService (copy)
    Asserts.number(p68);
    Asserts.boolean(p69);
    local v70, v71, v72, v73, v74 = p67:_getProgressionElements();
    local v75 = math.clamp(p68, 0, 1);
    v70.Visible = true;

    if p67._progressionFillTween ~= nil then
        p67._progressionFillTween:Cancel();
    end;

    local Size = v71.Size;
    local v76 = UDim2.new(v75, 0, Size.Y.Scale, Size.Y.Offset);
    local v77 = TweenService:Create(v71, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = v76
    });
    p67._progressionFillTween = v77;
    v77:Play();
    p67:_setReadyProgressionVisible(v72, v73, v74, p69);
end;

function u2.ClearSpeedProgression(p78) -- Line: 576
    p78:_clearProgressionTweens();
    local _progressionFrame = p78._progressionFrame;
    local _progressionFill = p78._progressionFill;
    local _readyLabel = p78._readyLabel;
    local _readyLabelScale = p78._readyLabelScale;
    local _readyLabelWhite = p78._readyLabelWhite;

    if _progressionFrame == nil or (_progressionFill == nil or (_readyLabel == nil or (_readyLabelScale == nil or _readyLabelWhite == nil))) then
        return;
    end;

    local Size = _progressionFill.Size;
    _progressionFill.Size = UDim2.new(0, 0, Size.Y.Scale, Size.Y.Offset);
    _readyLabel.Visible = false;
    _readyLabelScale.Scale = 1;
    _readyLabelWhite.TextTransparency = 1;
    _progressionFrame.Visible = false;
end;

function u2.ShowBeam(p79, p80) -- Line: 602
    -- upvalues: TutorialBeam (copy)
    local v81;

    if typeof(p80) == "Vector3" then
        v81 = true;
    elseif typeof(p80) == "Instance" then
        v81 = p80:IsA("BasePart");
    else
        v81 = false;
    end;

    assert(v81, "Tutorial presentation target must be a BasePart or Vector3");

    if p79._beamHandle == nil then
        p79._beamHandle = TutorialBeam.Create(p80);

        return;
    end;

    TutorialBeam.UpdateTarget(p79._beamHandle, p80);
end;

function u2.UpdateBeamTarget(p82, p83) -- Line: 616
    -- upvalues: TutorialBeam (copy)
    local v84;

    if typeof(p83) == "Vector3" then
        v84 = true;
    elseif typeof(p83) == "Instance" then
        v84 = p83:IsA("BasePart");
    else
        v84 = false;
    end;

    assert(v84, "Tutorial presentation target must be a BasePart or Vector3");

    if p82._beamHandle == nil then
        p82._beamHandle = TutorialBeam.Create(p83);

        return;
    end;

    TutorialBeam.UpdateTarget(p82._beamHandle, p83);
end;

function u2.ClearBeam(p85) -- Line: 630
    p85:_clearBeam();
end;

function u2.ShowTap(p86, p87, p88, p89, p90) -- Line: 634
    -- upvalues: Asserts (copy), TutorialTapIndicator (copy)
    Asserts.GuiButton(p87);
    Asserts.optional.boolean(p88);
    Asserts.optional.UDim(p89);
    Asserts.optional.UDim2(p90);
    p86:_clearTap();
    p86._tapCleanup = TutorialTapIndicator.Create(p87, p88, p89, p90);
end;

function u2.ShowTapOnSurfaceGuiButton(p91, p92, p93, p94, p95, p96) -- Line: 650
    -- upvalues: Asserts (copy), TutorialTapIndicator (copy)
    Asserts.BasePart(p92);
    Asserts.string(p93);
    Asserts.optional.boolean(p94);
    Asserts.optional.UDim(p95);
    Asserts.optional.UDim2(p96);
    local v97 = nil;

    for _, child in ipairs(p92:GetChildren()) do
        if child:IsA("SurfaceGui") then
            local v98 = child:FindFirstChild(p93);

            if v98 ~= nil and v98:IsA("GuiButton") then
                v97 = v98;
                break;
            end;
        end;
    end;

    if v97 == nil then
        p91:_clearTap();

        return false;
    end;

    p91:_clearTap();
    p91._tapCleanup = TutorialTapIndicator.Create(v97, p94, p95, p96);

    return true;
end;

function u2.ClearTap(p99) -- Line: 687
    p99:_clearTap();
end;

function u2.ShowBillboardClick(p100, p101) -- Line: 691
    -- upvalues: Asserts (copy), ReplicatedStorage (copy), playClickPulse (copy)
    Asserts.CFrame(p101);

    if p100._billboardClick ~= nil then
        p100._billboardClick.CFrame = p101;

        return;
    end;

    local BillboardTutorialClick = ReplicatedStorage.Assets.Billboards.BillboardTutorialClick;
    local v102 = BillboardTutorialClick:IsA("BasePart");
    assert(v102, "ReplicatedStorage.Assets.Billboards.BillboardTutorialClick must be a BasePart");
    local v103 = BillboardTutorialClick:Clone();
    v103.CFrame = p101;
    v103.Parent = workspace;
    local BillboardGui = v103.BillboardGui;
    local v104 = BillboardGui:IsA("BillboardGui");
    assert(v104, "BillboardTutorialClick.BillboardGui must be a BillboardGui");
    local Image = BillboardGui.Image;
    local v105 = Image:IsA("ImageLabel");
    assert(v105, "BillboardTutorialClick.BillboardGui.Image must be an ImageLabel");
    local UIScale = Image.UIScale;
    local v106 = UIScale:IsA("UIScale");
    assert(v106, "BillboardTutorialClick.BillboardGui.Image.UIScale must be a UIScale");
    p100._billboardClick = v103;
    p100._billboardClickTween = playClickPulse(UIScale);
end;

function u2.ClearBillboardClick(p107) -- Line: 719
    p107:_clearBillboardClick();
end;

function u2.SetScreenClickVisible(p108, p109) -- Line: 723
    -- upvalues: Asserts (copy), Players (copy), playClickPulse (copy)
    Asserts.boolean(p109);
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local v110 = PlayerGui:IsA("PlayerGui");
    assert(v110, "LocalPlayer.PlayerGui must be a PlayerGui");
    local TutorialClick = PlayerGui:WaitForChild("TutorialClick");
    local v111 = TutorialClick:IsA("ScreenGui");
    assert(v111, "PlayerGui.TutorialClick must be a ScreenGui");
    local Image = TutorialClick.Image;
    local v112 = Image:IsA("ImageLabel");
    assert(v112, "TutorialClick.Image must be an ImageLabel");
    local UIScale = Image.UIScale;
    local v113 = UIScale:IsA("UIScale");
    assert(v113, "TutorialClick.Image.UIScale must be a UIScale");
    p108._screenClickGui = TutorialClick;

    if not p109 then
        p108:_clearScreenClick();

        return;
    end;

    TutorialClick.Enabled = true;

    if p108._screenClickTween == nil then
        p108._screenClickTween = playClickPulse(UIScale);
    end;
end;

function u2.ClearScreenClick(p114) -- Line: 750
    p114:_clearScreenClick();
end;

function u2.ShowHighlight(p115, p116) -- Line: 754
    -- upvalues: Asserts (copy), TutorialHighlightOverlay (copy)
    Asserts.GuiObject(p116);
    p115:_clearHighlight();
    p115._highlightCleanup = TutorialHighlightOverlay.Create(p116);
end;

function u2.ClearHighlight(p117) -- Line: 761
    p117:_clearHighlight();
end;

function u2.ShowArrow(p118, p119, p120, p121) -- Line: 765
    -- upvalues: ArrowPointer3D (copy)
    local v122;

    if typeof(p119) == "Vector3" then
        v122 = true;
    elseif typeof(p119) == "Instance" then
        v122 = p119:IsA("BasePart");
    else
        v122 = false;
    end;

    assert(v122, "Tutorial presentation target must be a BasePart or Vector3");
    local v123;

    if typeof(p120) == "Vector3" then
        v123 = true;
    elseif typeof(p120) == "Instance" then
        v123 = p120:IsA("BasePart");
    else
        v123 = false;
    end;

    assert(v123, "Tutorial presentation target must be a BasePart or Vector3");
    assert(ArrowPointer3D.__types.OptionalConfig(p121));
    p118:_clearArrow();
    local v124 = ArrowPointer3D.new(p119, p120, p121);
    v124:Start();
    p118._arrow = v124;
end;

function u2.UpdateArrowTarget(p125, p126) -- Line: 781
    local v127;

    if typeof(p126) == "Vector3" then
        v127 = true;
    elseif typeof(p126) == "Instance" then
        v127 = p126:IsA("BasePart");
    else
        v127 = false;
    end;

    assert(v127, "Tutorial presentation target must be a BasePart or Vector3");
    assert(p125._arrow ~= nil, "Cannot update tutorial arrow target before showing an arrow");
    p125._arrow:ChangeTarget(p126);
end;

function u2.UpdateArrowOrigin(p128, p129) -- Line: 790
    local v130;

    if typeof(p129) == "Vector3" then
        v130 = true;
    elseif typeof(p129) == "Instance" then
        v130 = p129:IsA("BasePart");
    else
        v130 = false;
    end;

    assert(v130, "Tutorial presentation target must be a BasePart or Vector3");
    assert(p128._arrow ~= nil, "Cannot update tutorial arrow origin before showing an arrow");
    p128._arrow:ChangeOrigin(p129);
end;

function u2.ClearArrow(p131) -- Line: 799
    p131:_clearArrow();
end;

function u2.ClearAll(p132) -- Line: 803
    p132:_clearArrow();
    p132:_clearBeam();
    p132:_clearBillboardClick();
    p132:_clearHighlight();
    p132:_clearTap();
    p132:_clearScreenClick();
    p132:ClearSpeedProgression();
    p132:ClearMessage();
end;

function u2.Destroy(p133) -- Line: 814
    -- upvalues: u1 (copy)
    u1:AtTrace():Log("[GuardTutorialPresentationComponent] Destroying tutorial presentation layer");
    p133:ClearAll();

    if p133._createdReadyLabelScale and p133._readyLabelScale ~= nil then
        p133._readyLabelScale:Destroy();
        p133._readyLabelScale = nil;
    end;
end;

return u2;