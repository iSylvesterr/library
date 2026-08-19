-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _setAtmosphereParams(p2, p3) -- Line: 36
    p2.Instance.Density = p3.Density;
    p2.Instance.Offset = p3.Offset;
    p2.Instance.Color = p3.Color;
    p2.Instance.Decay = p3.Decay;
    p2.Instance.Glare = p3.Glare;
    p2.Instance.Haze = p3.Haze;
end;

function u1.new() -- Line: 45
    -- upvalues: u1 (copy), InsMgr (copy), Lighting (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("Atmosphere", "Atmosphere", Lighting);
    v4.Density = 0;
    v4.Offset = 0;
    v4.Color = Color3.new(1, 1, 1);
    v4.Decay = Color3.new(1, 1, 1);
    v4.Glare = 0;
    v4.Haze = 0;
    v4.TransitionTween = nil;

    return v4;
end;

function u1.setAtmosphereParams(p5, p6, p7) -- Line: 58
    -- upvalues: TweenService (copy)
    p5.Density = p6.Density;
    p5.Offset = p6.Offset;
    p5.Color = p6.Color;
    p5.Decay = p6.Decay;
    p5.Glare = p6.Glare;
    p5.Haze = p6.Haze;

    if p5.TransitionTween then
        p5.TransitionTween:Pause();
        p5.TransitionTween:Destroy();
        p5.TransitionTween = nil;
    end;

    if p7 > 0 then
        p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(p7), {
            Density = p5.Density,
            Offset = p5.Offset,
            Color = p5.Color,
            Decay = p5.Decay,
            Glare = p5.Glare,
            Haze = p5.Haze
        });
        p5.TransitionTween:Play();

        return;
    end;

    p5.Instance.Density = p6.Density;
    p5.Instance.Offset = p6.Offset;
    p5.Instance.Color = p6.Color;
    p5.Instance.Decay = p6.Decay;
    p5.Instance.Glare = p6.Glare;
    p5.Instance.Haze = p6.Haze;
end;

function u1.hide(p8) -- Line: 87
    if p8.TransitionTween then
        p8.TransitionTween:Pause();
        p8.TransitionTween:Destroy();
        p8.TransitionTween = nil;
    end;

    p8.Instance.Parent = nil;
end;

function u1.show(p9) -- Line: 96
    -- upvalues: Lighting (copy)
    p9.Instance.Parent = Lighting;
end;

function u1.destroy(p10) -- Line: 100
    p10:hide();
end;

return u1;