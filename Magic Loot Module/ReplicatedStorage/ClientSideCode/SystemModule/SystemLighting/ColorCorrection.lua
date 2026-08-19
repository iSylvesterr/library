-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _setColorCorrectionParams(p2, p3) -- Line: 34
    p2.Instance.Brightness = p3.Brightness;
    p2.Instance.Contrast = p3.Contrast;
    p2.Instance.TintColor = p3.TintColor;
    p2.Instance.Saturation = p3.Saturation;
end;

function u1.new() -- Line: 41
    -- upvalues: u1 (copy), InsMgr (copy), Lighting (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("ColorCorrection", "ColorCorrectionEffect", Lighting);
    v4.Brightness = 0;
    v4.Contrast = 0;
    v4.TintColor = Color3.new(1, 1, 1);
    v4.Saturation = 0;
    v4.TransitionTween = nil;

    return v4;
end;

function u1.setColorCorrectionParams(p5, p6, p7) -- Line: 52
    -- upvalues: TweenService (copy)
    p5.Brightness = p6.Brightness;
    p5.Contrast = p6.Contrast;
    p5.TintColor = p6.TintColor;
    p5.Saturation = p6.Saturation;

    if p5.TransitionTween then
        p5.TransitionTween:Pause();
        p5.TransitionTween:Destroy();
        p5.TransitionTween = nil;
    end;

    if p7 > 0 then
        p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(p7), {
            Brightness = p5.Brightness,
            Contrast = p5.Contrast,
            TintColor = p5.TintColor,
            Saturation = p5.Saturation
        });
        p5.TransitionTween:Play();
    else
        p5.Instance.Brightness = p6.Brightness;
        p5.Instance.Contrast = p6.Contrast;
        p5.Instance.TintColor = p6.TintColor;
        p5.Instance.Saturation = p6.Saturation;
    end;

    if p6.Enabled then
        p5:show();

        return;
    end;

    p5:hide();
end;

function u1.hide(p8) -- Line: 87
    p8.Instance.Enabled = false;
end;

function u1.show(p9) -- Line: 91
    p9.Instance.Enabled = true;
end;

function u1.destroy(p10) -- Line: 95
    if p10.TransitionTween then
        p10.TransitionTween:Pause();
        p10.TransitionTween:Destroy();
        p10.TransitionTween = nil;
    end;

    p10:hide();
end;

return u1;