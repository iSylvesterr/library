-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local EggActionMovement = require(script.Parent.EggActionMovement);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local u1 = {};
u1.__index = u1;
u1.__class = "PlacedEggReadyPulse";

function u1.new(p2, p3, p4) -- Line: 42
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Model(p2);
    Asserts.CFrame(p3);
    Asserts.number(p4);
    local v5 = setmetatable({}, u1);
    v5._model = p2;
    v5._highlight = nil;
    v5._basePivot = p3;
    v5._baseScale = p4;
    v5._animation = nil;
    v5._destroyed = false;

    return v5;
end;

function u1._createHighlight(p6) -- Line: 62
    local Highlight = Instance.new("Highlight");
    Highlight.Name = "ReadyEggPulseHighlight";
    Highlight.Adornee = p6._model;
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded;
    Highlight.FillColor = Color3.new(1, 1, 1);
    Highlight.FillTransparency = 1;
    Highlight.OutlineTransparency = 1;
    Highlight.Parent = p6._model;
    p6._highlight = Highlight;

    return Highlight;
end;

function u1._destroyHighlight(p7) -- Line: 76
    local _highlight = p7._highlight;

    if _highlight == nil then
        return;
    end;

    p7._highlight = nil;
    _highlight:Destroy();
end;

function u1._resetVisual(p8) -- Line: 86
    -- upvalues: EggActionMovement (copy)
    local _model = p8._model;

    if _model:IsDescendantOf(game) then
        _model:ScaleTo(p8._baseScale);
        EggActionMovement.SetPivot(_model, p8._basePivot);
    end;

    p8:_destroyHighlight();
end;

function u1.SetTransform(p9, p10, p11) -- Line: 100
    -- upvalues: Asserts (copy)
    Asserts.CFrame(p10);
    Asserts.number(p11);
    p9._basePivot = p10;
    p9._baseScale = p11;
end;

function u1.IsPlaying(p12) -- Line: 108
    local _animation = p12._animation;
    local v13;

    if _animation == nil then
        v13 = false;
    else
        v13 = _animation:IsConnected();
    end;

    return v13;
end;

function u1.Play(u14) -- Line: 113
    -- upvalues: RenderStepped (copy), Easing (copy), EggActionMovement (copy)
    if u14._destroyed or (u14:IsPlaying() or not u14._model:IsDescendantOf(game)) then
        return false;
    end;

    u14:_resetVisual();
    local u25 = RenderStepped(function(p15, p16) -- Line: 120
        -- upvalues: u14 (copy), Easing (ref), EggActionMovement (ref)
        if u14._destroyed or not u14._model:IsDescendantOf(game) then
            return true;
        end;

        local v17 = math.clamp(p16, 0, 1) * 1.05;
        local _model = u14._model;
        local _basePivot = u14._basePivot;
        local _baseScale = u14._baseScale;

        if v17 < 0.25 then
            local v18 = v17 / 0.25;
            local v19 = 1 - Easing(v18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
            local v20 = math.sin(v18 * 3.141592653589793 * 2 * 3) * 0.05235987755982989 * v19;
            _model:ScaleTo(_baseScale);
            EggActionMovement.SetPivot(_model, _basePivot * CFrame.Angles(0, 0, v20));

            return false;
        end;

        local v21 = v17 - 0.25;

        if v21 >= 0.6 then
            u14:_destroyHighlight();
            _model:ScaleTo(_baseScale * (1.2 + -0.19999999999999996 * Easing(math.clamp((v21 - 0.6) / 0.2, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)));
            EggActionMovement.SetPivot(_model, _basePivot);

            return p16 >= 1;
        end;

        local v22 = v21 / 0.6;
        local v23 = Easing(v22, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out);
        local v24 = math.sin(v22 * 3.141592653589793);
        (u14._highlight or u14:_createHighlight()).FillTransparency = 1 - v24 * 0.9;
        _model:ScaleTo(_baseScale * (1 + 0.19999999999999996 * v23));
        EggActionMovement.SetPivot(_model, _basePivot);

        return false;
    end, 1.05, true);
    u14._animation = u25;
    u25:Then(function() -- Line: 165
        -- upvalues: u14 (copy), u25 (copy)
        if u14._animation ~= u25 then
            return;
        end;

        u14._animation = nil;

        if not u14._destroyed then
            u14:_resetVisual();
        end;
    end);

    return true;
end;

function u1.Cancel(p26) -- Line: 179
    local _animation = p26._animation;

    if _animation == nil then
        return;
    end;

    p26._animation = nil;
    _animation:Disconnect();

    if not p26._destroyed then
        p26:_resetVisual();
    end;
end;

function u1.Destroy(p27) -- Line: 192
    if p27._destroyed then
        return;
    end;

    p27:Cancel();
    p27._destroyed = true;
    p27:_destroyHighlight();
end;

return u1;