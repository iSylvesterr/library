-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _setSunRaysParams(p2, p3) -- Line: 32
    p2.Instance.Intensity = p3.Intensity;
    p2.Instance.Spread = p3.Spread;
end;

function u1.new() -- Line: 37
    -- upvalues: u1 (copy), InsMgr (copy), Lighting (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("SunRays", "SunRaysEffect", Lighting);
    v4.Intensity = 0;
    v4.Spread = 0;
    v4.TransitionTween = nil;

    return v4;
end;

function u1.setSunRaysParams(p5, p6, p7) -- Line: 46
    -- upvalues: TweenService (copy)
    p5.Intensity = p6.Intensity;
    p5.Spread = p6.Spread;

    if p7 > 0 then
        if p5.TransitionTween then
            p5.TransitionTween:Pause();
            p5.TransitionTween:Destroy();
            p5.TransitionTween = nil;
        end;

        p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(p7), {
            Intensity = p5.Intensity,
            Spread = p5.Spread
        });
        p5.TransitionTween:Play();
    else
        p5.Instance.Intensity = p6.Intensity;
        p5.Instance.Spread = p6.Spread;
    end;

    if p6.Enabled then
        p5:show();

        return;
    end;

    p5:hide();
end;

function u1.hide(p8) -- Line: 72
    if p8.TransitionTween then
        p8.TransitionTween:Pause();
        p8.TransitionTween:Destroy();
        p8.TransitionTween = nil;
    end;

    p8.Instance.Enabled = false;
end;

function u1.show(p9) -- Line: 81
    p9.Instance.Enabled = true;
end;

function u1.destroy(p10) -- Line: 85
    p10:hide();
end;

return u1;