-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _setDepthOfFieldParams(p2, p3) -- Line: 34
    p2.Instance.FocusDistance = p3.FocusDistance;
    p2.Instance.FarIntensity = p3.FarIntensity;
    p2.Instance.NearIntensity = p3.NearIntensity;
    p2.Instance.InFocusRadius = p3.InFocusRadius;
end;

function u1.new() -- Line: 41
    -- upvalues: u1 (copy), InsMgr (copy), Lighting (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("DepthOfField", "DepthOfFieldEffect", Lighting);
    v4.FocusDistance = 0;
    v4.FarIntensity = 0;
    v4.NearIntensity = 0;
    v4.InFocusRadius = 0;
    v4.TransitionTween = nil;

    return v4;
end;

function u1.setDepthOfFieldParams(p5, p6, p7) -- Line: 52
    -- upvalues: TweenService (copy)
    p5.FocusDistance = p6.FocusDistance;
    p5.FarIntensity = p6.FarIntensity;
    p5.NearIntensity = p6.NearIntensity;
    p5.InFocusRadius = p6.InFocusRadius;

    if p5.TransitionTween then
        p5.TransitionTween:Pause();
        p5.TransitionTween:Destroy();
        p5.TransitionTween = nil;
    end;

    if p7 > 0 then
        p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(p7), {
            FocusDistance = p5.FocusDistance,
            FarIntensity = p5.FarIntensity,
            NearIntensity = p5.NearIntensity,
            InFocusRadius = p5.InFocusRadius
        });
        p5.TransitionTween:Play();
    else
        p5.Instance.FocusDistance = p6.FocusDistance;
        p5.Instance.FarIntensity = p6.FarIntensity;
        p5.Instance.NearIntensity = p6.NearIntensity;
        p5.Instance.InFocusRadius = p6.InFocusRadius;
    end;

    if p6.Enabled then
        p5:show();

        return;
    end;

    p5:hide();
end;

function u1.hide(p8) -- Line: 87
    if p8.TransitionTween then
        p8.TransitionTween:Pause();
        p8.TransitionTween:Destroy();
        p8.TransitionTween = nil;
    end;

    p8.Instance.Enabled = false;
end;

function u1.show(p9) -- Line: 96
    p9.Instance.Enabled = true;
end;

function u1.destroy(p10) -- Line: 100
    p10:hide();
end;

return u1;