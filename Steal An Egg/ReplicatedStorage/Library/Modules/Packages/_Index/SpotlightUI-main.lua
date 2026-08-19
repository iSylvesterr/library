-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
require(script.Types);
local GoodSignal = require(script.Packages.GoodSignal);
local Janitor = require(script.Packages.Janitor);
local u1 = {
    OVERLAY_ALPHA = 0.6,
    HINT_OFFSET = 20,
    HINT_PADDING = 10,
    WORLD_RADIUS_PADDING = 1.5,
    TWEEN_DURATION = 0.5,
    FADE_DURATION = 0.25,
    PULSE_DURATION = 1.2,
    SHAPE_TWEEN_DURATION = 0.4,
    HINT_CORNER_RADIUS = 8,
    HINT_TEXT_SIZE = 18,
    OVERLAY_ZINDEX = 5,
    HINT_ENABLED = false,
    HINT_ZINDEX = 11,
    DEFAULT_SPOTLIGHT_SIZE = Vector2.new(160, 160),
    HINT_SIZE = Vector2.new(300, 60),
    MOVE_EASING_STYLE = Enum.EasingStyle.Quint,
    MOVE_EASING_DIRECTION = Enum.EasingDirection.Out,
    FADE_EASING_STYLE = Enum.EasingStyle.Quad,
    FADE_EASING_DIRECTION = Enum.EasingDirection.Out,
    PULSE_EASING_STYLE = Enum.EasingStyle.Sine,
    SHAPE_EASING_STYLE = Enum.EasingStyle.Quint,
    SHAPE_EASING_DIRECTION = Enum.EasingDirection.Out,
    OVERLAY_COLOR = Color3.new(0, 0, 0),
    HINT_BACKGROUND_COLOR = Color3.fromRGB(20, 20, 20),
    HINT_TEXT_COLOR = Color3.new(1, 1, 1),
    CIRCLE_CORNER_RADIUS = UDim.new(1, 0),
    SQUARE_CORNER_RADIUS = UDim.new(0, 8),
    HINT_FONT = Enum.Font.GothamBold
};
local u7 = {
    ClampToScreen = function(p2, p3, p4) -- Line: 116, Name: ClampToScreen
        -- upvalues: u1 (copy)
        local v5 = math.clamp(p2.X, p3.X / 2, p4.X - p3.X / 2);
        local v6 = math.clamp(p2.Y, 0, p4.Y - p3.Y - u1.HINT_PADDING);

        return Vector2.new(v5, v6);
    end
};

function u7.GetHintPosition(p8, p9, p10, p11) -- Line: 122
    -- upvalues: u1 (copy), u7 (copy)
    return u7.ClampToScreen(Vector2.new(p8.X + p9.X / 2, p8.Y + p9.Y + u1.HINT_OFFSET), p10, p11);
end;

local _ = {
    CreateMoveTween = function(p12, p13) -- Line: 134, Name: CreateMoveTween
        -- upvalues: u1 (copy), TweenService (copy)
        return TweenService:Create(p12, TweenInfo.new(u1.TWEEN_DURATION, u1.MOVE_EASING_STYLE, u1.MOVE_EASING_DIRECTION), p13);
    end,

    CreateFadeTween = function(p14, p15) -- Line: 139, Name: CreateFadeTween
        -- upvalues: u1 (copy), TweenService (copy)
        return TweenService:Create(p14, TweenInfo.new(u1.FADE_DURATION, u1.FADE_EASING_STYLE, u1.FADE_EASING_DIRECTION), p15);
    end,

    CreatePulseTween = function(p16, p17) -- Line: 144, Name: CreatePulseTween
        -- upvalues: u1 (copy), TweenService (copy)
        return TweenService:Create(p16, TweenInfo.new(u1.PULSE_DURATION, u1.PULSE_EASING_STYLE), p17);
    end,

    CreateShapeTween = function(p18, p19) -- Line: 148, Name: CreateShapeTween
        -- upvalues: u1 (copy), TweenService (copy)
        return TweenService:Create(p18, TweenInfo.new(u1.SHAPE_TWEEN_DURATION, u1.SHAPE_EASING_STYLE, u1.SHAPE_EASING_DIRECTION), p19);
    end
};
local u24 = {
    CreateFrame = function(p20, p21) -- Line: 159, Name: CreateFrame
        -- upvalues: u1 (copy)
        local Frame = Instance.new("Frame");
        Frame.BackgroundColor3 = u1.OVERLAY_COLOR;
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        Frame.Parent = p20;

        if p21 then
            for i, v in p21 do
                Frame[i] = v;
            end;
        end;

        return Frame;
    end,

    CreateHintLabel = function(p22) -- Line: 174, Name: CreateHintLabel
        -- upvalues: u1 (copy)
        local TextLabel = Instance.new("TextLabel");
        TextLabel.Size = UDim2.fromOffset(u1.HINT_SIZE.X, u1.HINT_SIZE.Y);
        TextLabel.BackgroundColor3 = u1.HINT_BACKGROUND_COLOR;
        TextLabel.BackgroundTransparency = 1;
        TextLabel.TextColor3 = u1.HINT_TEXT_COLOR;
        TextLabel.Font = u1.HINT_FONT;
        TextLabel.TextSize = u1.HINT_TEXT_SIZE;
        TextLabel.TextWrapped = true;
        TextLabel.BorderSizePixel = 0;
        TextLabel.AnchorPoint = Vector2.new(0.5, 0);
        TextLabel.Text = "";
        TextLabel.ZIndex = u1.HINT_ZINDEX;
        TextLabel.Parent = p22;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, u1.HINT_CORNER_RADIUS);
        UICorner.Parent = TextLabel;

        return TextLabel;
    end,

    CreateTriangle = function(p23) -- Line: 195, Name: CreateTriangle
        -- upvalues: u1 (copy)
        local Frame = Instance.new("Frame");
        Frame.BackgroundTransparency = 1;
        Frame.BorderSizePixel = 0;
        Frame.Visible = false;
        Frame.ZIndex = u1.OVERLAY_ZINDEX;
        Frame.Parent = p23;
        local Frame2 = Instance.new("Frame");
        Frame2.Size = UDim2.fromScale(1.414, 1.414);
        Frame2.Position = UDim2.fromScale(0.5, 0.7);
        Frame2.AnchorPoint = Vector2.new(0.5, 0.5);
        Frame2.BackgroundTransparency = 1;
        Frame2.Rotation = 45;
        Frame2.BorderSizePixel = 0;
        Frame2.Parent = Frame;
        local UICorner = Instance.new("UICorner");
        UICorner.CornerRadius = UDim.new(0, 8);
        UICorner.Parent = Frame2;
        local UIStroke = Instance.new("UIStroke");
        UIStroke.Color = u1.OVERLAY_COLOR;
        UIStroke.Thickness = 10000;
        UIStroke.Transparency = 1;
        UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        UIStroke.Parent = Frame2;
        local Frame3 = Instance.new("Frame");
        Frame3.Size = UDim2.fromScale(1, 0.5);
        Frame3.Position = UDim2.fromScale(0, 0);
        Frame3.BackgroundTransparency = 1;
        Frame3.BorderSizePixel = 0;
        Frame3.ClipsDescendants = true;
        Frame3.Parent = Frame;
        Frame2.Parent = Frame3;

        return Frame, UIStroke;
    end
};
local LocalPlayer = Players.LocalPlayer;
local u25 = {};
u25.__index = u25;

function u25.new() -- Line: 242
    -- upvalues: Janitor (copy), GoodSignal (copy), u1 (copy), u25 (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local v26 = Janitor.new();
    local v27 = GoodSignal.new();
    local v28 = GoodSignal.new();
    local v29 = setmetatable({
        _gui = nil,
        _container = nil,
        _circleMask = nil,
        _circleStroke = nil,
        _circleCorner = nil,
        _triangle = nil,
        _triangleStroke = nil,
        _hint = nil,
        _hintCorner = nil,
        _active = false,
        _pulseEnabled = false,
        _currentShape = "Circle",
        _stepIndex = 0,
        _positionDriver = nil,
        _sizeDriver = nil,
        _pulseDriver = nil,
        _spotlightPos = Vector2.zero,
        _spotlightSize = u1.DEFAULT_SPOTLIGHT_SIZE,
        _steps = {},
        _camera = CurrentCamera,
        janitor = v26,
        stepCompleted = v27,
        sequenceCompleted = v28
    }, u25);
    v29:_buildUI();
    v29:_setupDrivers();
    v29:_startUpdateLoop();

    return v29;
end;

function u25._buildUI(p30) -- Line: 285
    -- upvalues: LocalPlayer (copy), u1 (copy), u24 (copy)
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = "SpotlightGui";
    ScreenGui.IgnoreGuiInset = true;
    ScreenGui.ResetOnSpawn = false;
    ScreenGui.Enabled = false;
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui");
    p30._gui = ScreenGui;
    p30.janitor:Add(ScreenGui, "Destroy");
    local v31 = {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    };
    local Frame = Instance.new("Frame");
    Frame.BackgroundColor3 = u1.OVERLAY_COLOR;
    Frame.BackgroundTransparency = 1;
    Frame.BorderSizePixel = 0;
    Frame.Parent = ScreenGui;

    if v31 then
        for i, v in v31 do
            Frame[i] = v;
        end;
    end;

    p30._container = Frame;
    local v32 = {
        Name = "CircleMask",
        BackgroundTransparency = 1,
        ZIndex = u1.OVERLAY_ZINDEX
    };
    local Frame2 = Instance.new("Frame");
    Frame2.BackgroundColor3 = u1.OVERLAY_COLOR;
    Frame2.BackgroundTransparency = 1;
    Frame2.BorderSizePixel = 0;
    Frame2.Parent = Frame;

    if v32 then
        for i, v in v32 do
            Frame2[i] = v;
        end;
    end;

    p30._circleMask = Frame2;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 1;
    UIAspectRatioConstraint.Parent = Frame2;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = u1.CIRCLE_CORNER_RADIUS;
    UICorner.Parent = Frame2;
    p30._circleCorner = UICorner;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = u1.OVERLAY_COLOR;
    UIStroke.Thickness = 10000;
    UIStroke.Transparency = 1;
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke.Parent = Frame2;
    p30._circleStroke = UIStroke;
    local Frame3 = Instance.new("Frame");
    Frame3.BackgroundTransparency = 1;
    Frame3.BorderSizePixel = 0;
    Frame3.Visible = false;
    Frame3.ZIndex = u1.OVERLAY_ZINDEX;
    Frame3.Parent = Frame;
    p30._triangle = Frame3;
    local Frame4 = Instance.new("Frame");
    Frame4.Size = UDim2.fromScale(1.414, 1.414);
    Frame4.Position = UDim2.fromScale(0.5, 0.65);
    Frame4.AnchorPoint = Vector2.new(0.5, 0.5);
    Frame4.BackgroundTransparency = 1;
    Frame4.Rotation = 45;
    Frame4.BorderSizePixel = 0;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 8);
    UICorner2.Parent = Frame4;
    local UIStroke2 = Instance.new("UIStroke");
    UIStroke2.Color = u1.OVERLAY_COLOR;
    UIStroke2.Thickness = 10000;
    UIStroke2.Transparency = 1;
    UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
    UIStroke2.Parent = Frame4;
    p30._triangleStroke = UIStroke2;
    local Frame5 = Instance.new("Frame");
    Frame5.Size = UDim2.fromScale(1, 0.55);
    Frame5.Position = UDim2.fromScale(0, 0);
    Frame5.BackgroundTransparency = 1;
    Frame5.BorderSizePixel = 0;
    Frame5.ClipsDescendants = true;
    Frame5.Parent = Frame3;
    Frame4.Parent = Frame5;
    local v33 = u24.CreateHintLabel(Frame);
    v33.Visible = u1.HINT_ENABLED;
    p30._hint = v33;
    p30._hintCorner = v33:FindFirstChildOfClass("UICorner");
end;

function u25._setupDrivers(p34) -- Line: 370
    local Vector3Value = Instance.new("Vector3Value");
    Vector3Value.Value = Vector3.new(p34._spotlightPos.X, p34._spotlightPos.Y, 0);
    p34._positionDriver = Vector3Value;
    local Vector3Value2 = Instance.new("Vector3Value");
    Vector3Value2.Value = Vector3.new(p34._spotlightSize.X, p34._spotlightSize.Y, 0);
    p34._sizeDriver = Vector3Value2;
    local NumberValue = Instance.new("NumberValue");
    NumberValue.Value = 0;
    p34._pulseDriver = NumberValue;
end;

function u25._startUpdateLoop(u35) -- Line: 384
    -- upvalues: RunService (copy)
    u35.janitor:Add(RunService.RenderStepped:Connect(function() -- Line: 386
        -- upvalues: u35 (copy)
        if not u35._active then
            return;
        end;

        local Value = u35._positionDriver.Value;
        u35._spotlightPos = Vector2.new(Value.X, Value.Y);
        local Value2 = u35._sizeDriver.Value;
        local Value3 = u35._pulseDriver.Value;
        u35._spotlightSize = Vector2.new(Value2.X + Value3, Value2.Y + Value3);
        u35:_updateSpotlightLayout();
        u35:_updateHintPosition();
    end), "Disconnect");
end;

function u25._updateSpotlightLayout(p36) -- Line: 406
    local X = p36._spotlightPos.X;
    local Y = p36._spotlightPos.Y;
    local X2 = p36._spotlightSize.X;
    local Y2 = p36._spotlightSize.Y;

    if p36._currentShape == "Triangle" then
        p36._circleMask.Visible = false;
        p36._triangle.Visible = true;
        p36._triangle.Position = UDim2.fromOffset(X, Y);
        local v37 = math.max(X2, Y2);
        p36._triangle.Size = UDim2.fromOffset(v37, v37);

        return;
    end;

    p36._circleMask.Visible = true;
    p36._triangle.Visible = false;
    local v38 = math.max(X2, Y2);
    p36._circleMask.Position = UDim2.fromOffset(X - (v38 - X2) / 2, Y - (v38 - Y2) / 2);
    p36._circleMask.Size = UDim2.fromOffset(v38, v38);
end;

function u25._updateHintPosition(p39) -- Line: 429
    -- upvalues: u7 (copy)
    local v40 = u7.GetHintPosition(p39._spotlightPos, p39._spotlightSize, p39._hint.AbsoluteSize, p39._container.AbsoluteSize);
    p39._hint.Position = UDim2.fromOffset(v40.X, v40.Y);
end;

function u25._fadeOverlay(p41, p42) -- Line: 438
    -- upvalues: u1 (copy), TweenService (copy)
    local v43 = p42 and 1 - u1.OVERLAY_ALPHA or 1;
    TweenService:Create(p41._circleStroke, TweenInfo.new(u1.FADE_DURATION, u1.FADE_EASING_STYLE, u1.FADE_EASING_DIRECTION), {
        Transparency = v43
    }):Play();
    TweenService:Create(p41._triangleStroke, TweenInfo.new(u1.FADE_DURATION, u1.FADE_EASING_STYLE, u1.FADE_EASING_DIRECTION), {
        Transparency = v43
    }):Play();
    TweenService:Create(p41._hint, TweenInfo.new(u1.FADE_DURATION, u1.FADE_EASING_STYLE, u1.FADE_EASING_DIRECTION), {
        BackgroundTransparency = p42 and 0.15 or 1,
        TextTransparency = p42 and 0 or 1
    }):Play();
end;

function u25._disconnectFollow(p44) -- Line: 455
    p44.janitor:Remove("FollowConnection");
end;

function u25._worldRadiusToPixels(p45, p46, p47) -- Line: 459
    local _camera = p45._camera;
    local v48, v49 = _camera:WorldToViewportPoint(p46);

    if not v49 or v48.Z <= 0 then
        return 0;
    end;

    local Z = v48.Z;
    local v50 = math.rad(_camera.FieldOfView);

    return p47 * (_camera.ViewportSize.Y / 2 / (math.tan(v50 / 2) * Z));
end;

function u25._getWorldRadiusFromInstance(p51, p52) -- Line: 473
    -- upvalues: u1 (copy)
    local v53 = nil;

    if p52:IsA("BasePart") then
        v53 = math.max(p52.Size.X, p52.Size.Y, p52.Size.Z) / 2;
    elseif p52:IsA("Model") then
        local _, v54 = p52:GetBoundingBox();
        v53 = math.max(v54.X, v54.Y, v54.Z) / 2;
    else
        error("Unsupported instance type for spotlight sizing");
    end;

    return v53 * u1.WORLD_RADIUS_PADDING;
end;

function u25.Show(p55) -- Line: 488
    p55._gui.Enabled = true;
    p55._active = true;
    p55:_fadeOverlay(true);

    return p55;
end;

function u25.Hide(u56) -- Line: 495
    -- upvalues: u1 (copy)
    u56._active = false;
    u56:_disconnectFollow();
    u56:DisablePulse();
    u56:_fadeOverlay(false);
    task.delay(u1.FADE_DURATION, function() -- Line: 501
        -- upvalues: u56 (copy)
        if u56._gui then
            u56._gui.Enabled = false;
        end;
    end);

    return u56;
end;

function u25.SetShape(p57, p58) -- Line: 509
    -- upvalues: u1 (copy), TweenService (copy)
    local v59 = p58 or "Circle";
    p57._currentShape = v59;

    if v59 ~= "Circle" then
        if v59 == "Square" then
            local v60 = {
                CornerRadius = u1.SQUARE_CORNER_RADIUS
            };
            TweenService:Create(p57._circleCorner, TweenInfo.new(u1.SHAPE_TWEEN_DURATION, u1.SHAPE_EASING_STYLE, u1.SHAPE_EASING_DIRECTION), v60):Play();
        end;

        return p57;
    end;

    local v61 = {
        CornerRadius = u1.CIRCLE_CORNER_RADIUS
    };
    TweenService:Create(p57._circleCorner, TweenInfo.new(u1.SHAPE_TWEEN_DURATION, u1.SHAPE_EASING_STYLE, u1.SHAPE_EASING_DIRECTION), v61):Play();

    return p57;
end;

function u25.EnablePulse(u62, u63) -- Line: 526
    -- upvalues: u1 (copy), TweenService (copy)
    if u62._pulseEnabled then
        return u62;
    end;

    u62._pulseEnabled = true;
    local u65 = task.spawn(function() -- Line: 532
        -- upvalues: u62 (copy), u63 (copy), u1 (ref), TweenService (ref)
        while u62._active and u62._pulseEnabled do
            local v64 = {
                Value = u63
            };
            TweenService:Create(u62._pulseDriver, TweenInfo.new(u1.PULSE_DURATION, u1.PULSE_EASING_STYLE), v64):Play();
            task.wait(u1.PULSE_DURATION);

            if not u62._pulseEnabled then
                break;
            end;

            TweenService:Create(u62._pulseDriver, TweenInfo.new(u1.PULSE_DURATION, u1.PULSE_EASING_STYLE), {
                Value = 0
            }):Play();
            task.wait(u1.PULSE_DURATION);
        end;
    end);
    u62.janitor:Add(function() -- Line: 551
        -- upvalues: u62 (copy), u65 (copy)
        u62._pulseEnabled = false;
        task.cancel(u65);
    end, true, "PulseThread");

    return u62;
end;

function u25.DisablePulse(p66) -- Line: 558
    p66._pulseEnabled = false;
    p66.janitor:Remove("PulseThread");
    p66._pulseDriver.Value = 0;

    return p66;
end;

function u25.FocusUI(p67, p68, p69, p70) -- Line: 565
    -- upvalues: u1 (copy), TweenService (copy)
    p67:_disconnectFollow();
    local AbsolutePosition = p68.AbsolutePosition;
    local AbsoluteSize = p68.AbsoluteSize;
    local v71 = p69 or 0;
    local v72 = Vector2.new(AbsolutePosition.X - v71, AbsolutePosition.Y - v71);
    local v73 = Vector2.new(AbsoluteSize.X + v71 * 2, AbsoluteSize.Y + v71 * 2);
    local _positionDriver = p67._positionDriver;
    local v74 = {
        Value = Vector3.new(v72.X, v72.Y, 0)
    };
    TweenService:Create(_positionDriver, TweenInfo.new(u1.TWEEN_DURATION, u1.MOVE_EASING_STYLE, u1.MOVE_EASING_DIRECTION), v74):Play();
    local _sizeDriver = p67._sizeDriver;
    local v75 = {
        Value = Vector3.new(v73.X, v73.Y, 0)
    };
    TweenService:Create(_sizeDriver, TweenInfo.new(u1.TWEEN_DURATION, u1.MOVE_EASING_STYLE, u1.MOVE_EASING_DIRECTION), v75):Play();
    p67._hint.Text = p70 or "";

    return p67;
end;

function u25.FocusWorld(p76, p77, p78, p79) -- Line: 587
    local v80, v81 = p76._camera:WorldToViewportPoint(p77);

    if not v81 or v80.Z <= 0 then
        p76._container.Visible = false;

        return p76;
    end;

    p76._container.Visible = true;
    local v82 = p76:_worldRadiusToPixels(p77, p78);
    local v83 = v82 * 2;
    p76._positionDriver.Value = Vector3.new(v80.X - v82, v80.Y - v82, 0);
    p76._sizeDriver.Value = Vector3.new(v83, v83, 0);
    p76._hint.Text = p79 or "";

    return p76;
end;

function u25.FollowPart(u84, u85, u86) -- Line: 606
    -- upvalues: RunService (copy)
    u84:_disconnectFollow();
    u84._container.Visible = true;
    u84.janitor:Add(RunService.RenderStepped:Connect(function() -- Line: 611
        -- upvalues: u84 (copy), u85 (copy), u86 (copy)
        if not (u84._active and (u85 and u85.Parent)) then
            return;
        end;

        local v87 = u84:_getWorldRadiusFromInstance(u85);
        u84:FocusWorld(u85.Position, v87, u86);
    end), "Disconnect", "FollowConnection");

    return u84;
end;

function u25.SetSteps(p88, p89) -- Line: 625
    p88._steps = p89;
    p88._stepIndex = 0;

    return p88;
end;

function u25.Next(p90) -- Line: 631
    p90._stepIndex = p90._stepIndex + 1;
    local v91 = p90._steps[p90._stepIndex];

    if not v91 then
        p90:Hide();
        p90.sequenceCompleted:Fire();

        return p90;
    end;

    if v91.Shape then
        p90:SetShape(v91.Shape);
    end;

    if v91.UI then
        p90:FocusUI(v91.UI, v91.Padding or 15, v91.Text);
    elseif v91.World then
        p90:FocusWorld(v91.World, v91.Radius or 80, v91.Text);
    elseif v91.Part then
        p90:FollowPart(v91.Part, v91.Text);
    end;

    if v91.Pulse then
        p90:EnablePulse(v91.Pulse);
    else
        p90:DisablePulse();
    end;

    p90.stepCompleted:Fire(p90._stepIndex);

    return p90;
end;

function u25.Start(p92) -- Line: 663
    p92:Show();
    p92:Next();

    return p92;
end;

function u25.Skip(p93) -- Line: 669
    p93:Hide();

    return p93;
end;

function u25.Destroy(p94) -- Line: 674
    p94.stepCompleted:DisconnectAll();
    p94.sequenceCompleted:DisconnectAll();
    p94.janitor:Destroy();
end;

print("🔎 Running SpotLightUI by @Vvshenok & Interactive Studios");

return u25;