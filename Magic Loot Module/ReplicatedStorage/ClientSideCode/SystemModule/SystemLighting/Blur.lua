-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _setBlurParams(p2, p3) -- Line: 38
    p2.Instance.Size = p3.Size;
end;

function u1.new() -- Line: 47
    -- upvalues: u1 (copy), InsMgr (copy), Lighting (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("Blur", "BlurEffect", Lighting);
    v4.Size = 0;
    v4.TransitionTween = nil;

    return v4;
end;

function u1.setBlurParams(p5, p6, p7) -- Line: 62
    -- upvalues: TweenService (copy)
    p5.Size = p6.Size;

    if p5.TransitionTween then
        p5.TransitionTween:Pause();
        p5.TransitionTween:Destroy();
        p5.TransitionTween = nil;
    end;

    if p7 > 0 then
        p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(p7), {
            Size = p5.Size
        });
        p5.TransitionTween:Play();
    else
        p5.Instance.Size = p6.Size;
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