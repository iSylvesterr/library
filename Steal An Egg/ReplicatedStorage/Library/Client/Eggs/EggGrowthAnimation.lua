-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local EggActionMovement = require(script.Parent.EggActionMovement);
local RenderStepped = require(ReplicatedStorage.Library.Functions.RenderStepped);
local u1 = {};
u1.__index = u1;
u1.__class = "EggGrowthAnimation";

function u1.new(p2, p3, p4) -- Line: 37
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Model(p2);
    Asserts.CFrame(p3);
    Asserts.number(p4);
    assert(p4 > 0, "Jump height multiplier must be positive");
    local v5 = setmetatable({}, u1);
    v5._model = p2;
    v5._basePivot = p3;
    v5._jumpHeightMultiplier = p4;
    v5._animation = nil;
    v5._destroyed = false;

    return v5;
end;

function u1._resetVisual(p6) -- Line: 57
    -- upvalues: EggActionMovement (copy)
    local _model = p6._model;

    if _model:IsDescendantOf(game) then
        EggActionMovement.SetPivot(_model, p6._basePivot);
    end;
end;

function u1.SetBasePivot(p7, p8) -- Line: 68
    -- upvalues: Asserts (copy)
    Asserts.CFrame(p8);
    p7._basePivot = p8;

    if not p7:IsPlaying() then
        p7:_resetVisual();
    end;
end;

function u1.IsPlaying(p9) -- Line: 77
    local _animation = p9._animation;
    local v10;

    if _animation == nil then
        v10 = false;
    else
        v10 = _animation:IsConnected();
    end;

    return v10;
end;

function u1.Play(u11) -- Line: 82
    -- upvalues: RenderStepped (copy), Easing (copy), EggActionMovement (copy)
    if u11._destroyed or (u11:IsPlaying() or not u11._model:IsDescendantOf(game)) then
        return false;
    end;

    local u18 = RenderStepped(function(p12, p13) -- Line: 87
        -- upvalues: u11 (copy), Easing (ref), EggActionMovement (ref)
        if u11._destroyed or not u11._model:IsDescendantOf(game) then
            return true;
        end;

        local v14 = math.clamp(p13, 0, 1);
        local v15;

        if v14 < 0.5 then
            v15 = Easing(v14 * 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        else
            v15 = 1 - Easing((v14 - 0.5) * 2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out);
        end;

        local v16 = 1 - Easing(v14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v17 = math.sin(v14 * 3.141592653589793 * 2 * 4) * 0.06981317007977318 * v16;
        EggActionMovement.SetPivot(u11._model, u11._basePivot * CFrame.new(0, 0.85 * u11._jumpHeightMultiplier * v15, 0) * CFrame.Angles(0, 0, v17));

        return p13 >= 1;
    end, 0.55, true);
    u11._animation = u18;
    u18:Then(function() -- Line: 108
        -- upvalues: u11 (copy), u18 (copy)
        if u11._animation ~= u18 then
            return;
        end;

        u11._animation = nil;

        if not u11._destroyed then
            u11:_resetVisual();
        end;
    end);

    return true;
end;

function u1.Cancel(p19) -- Line: 122
    local _animation = p19._animation;

    if _animation == nil then
        return;
    end;

    p19._animation = nil;
    _animation:Disconnect();

    if not p19._destroyed then
        p19:_resetVisual();
    end;
end;

function u1.Destroy(p20) -- Line: 135
    if p20._destroyed then
        return;
    end;

    p20:Cancel();
    p20._destroyed = true;
end;

return u1;