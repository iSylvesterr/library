-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _setBloomParams(p2, p3) -- Line: 40
    p2.Instance.Intensity = p3.Intensity;
    p2.Instance.Threshold = p3.Threshold;
    p2.Instance.Size = p3.Size;
end;

function u1.new() -- Line: 51
    -- upvalues: u1 (copy), InsMgr (copy), Lighting (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("Bloom", "BloomEffect", Lighting);
    v4.Intensity = 0;
    v4.Threshold = 0;
    v4.Size = 0;
    v4.TransitionTween = nil;

    return v4;
end;

function u1.setBloomParams(p5, p6, p7) -- Line: 68
    -- upvalues: TweenService (copy)
    p5.Intensity = p6.Intensity;
    p5.Threshold = p6.Threshold;
    p5.Size = p6.Size;

    if p5.TransitionTween then
        p5.TransitionTween:Pause();
        p5.TransitionTween:Destroy();
        p5.TransitionTween = nil;
    end;

    if p7 > 0 then
        p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(p7), {
            Intensity = p5.Intensity,
            Threshold = p5.Threshold,
            Size = p5.Size
        });
        p5.TransitionTween:Play();
    else
        p5.Instance.Intensity = p6.Intensity;
        p5.Instance.Threshold = p6.Threshold;
        p5.Instance.Size = p6.Size;
    end;

    if p6.Enabled then
        p5:show();

        return;
    end;

    p5:hide();
end;

function u1.hide(p8) -- Line: 102
    if p8.TransitionTween then
        p8.TransitionTween:Pause();
        p8.TransitionTween:Destroy();
        p8.TransitionTween = nil;
    end;

    p8.Instance.Enabled = false;
end;

function u1.show(p9) -- Line: 116
    p9.Instance.Enabled = true;
end;

function u1.destroy(p10) -- Line: 125
    p10:hide();
end;

return u1;