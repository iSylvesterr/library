-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local TweenService = UtilsSystem.TweenService;
local Terrain = workspace:WaitForChild("Terrain", (1 / 0));
local u1 = {};
u1.__index = u1;

local function _setCloudParams(p2, p3) -- Line: 45
    p2.Instance.Cover = p3.Cover;
    p2.Instance.Density = p3.Density;
    p2.Instance.Color = p3.Color;
end;

function u1.new() -- Line: 51
    -- upvalues: u1 (copy), InsMgr (copy), Terrain (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("Cloud", "Clouds", Terrain);
    v4.Cover = 0;
    v4.Density = 0;
    v4.Color = Color3.new(1, 1, 1);
    v4.TransitionTween = nil;
    v4.MicroMotionTween = nil;
    v4.IsMicroMotion = false;
    v4.MicroMotionRange = 0.1;
    v4.MicroMotionTime = 10;

    return v4;
end;

function u1.setCloudParams(p5, p6, p7) -- Line: 65
    -- upvalues: TweenService (copy)
    local v8 = p7 or 0;
    p5.Cover = p6.Cover;
    p5.Density = p6.Density;
    p5.Color = p6.Color;

    if p5.TransitionTween then
        p5.TransitionTween:Pause();
        p5.TransitionTween:Destroy();
        p5.TransitionTween = nil;
    end;

    if v8 > 0 then
        p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(v8), {
            Cover = p5.Cover,
            Density = p5.Density,
            Color = p5.Color
        });
        p5.TransitionTween:Play();
    else
        p5.Instance.Cover = p6.Cover;
        p5.Instance.Density = p6.Density;
        p5.Instance.Color = p6.Color;
    end;

    if p6.Enabled then
        p5:show();
        p5:startMicroMotion();

        return;
    end;

    p5:hide();
    p5:stopMicroMotion();
end;

function u1.setMicroMotionRange(p9, p10, p11) -- Line: 100
    p9.MicroMotionRange = p10;
    p9.MicroMotionTime = p11;
end;

function u1.startMicroMotion(p12, p13, p14) -- Line: 105
    -- upvalues: TweenService (copy)
    if p12.IsMicroMotion then
        p12:stopMicroMotion();
    end;

    p12.IsMicroMotion = true;

    if p13 then
        p12.MicroMotionRange = p13;
    end;

    if p14 then
        p12.MicroMotionTime = p14;
    end;

    local v15 = math.clamp(p12.Cover - p12.MicroMotionRange, 0, 1);
    local v16 = math.clamp(p12.Density - p12.MicroMotionRange, 0, 1);
    p12.MicroMotionTween = TweenService:Create(p12.Instance, TweenInfo.new(p12.MicroMotionTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true), {
        Cover = v15,
        Density = v16
    });
    p12.MicroMotionTween:Play();
end;

function u1.stopMicroMotion(p17) -- Line: 132
    if not p17.IsMicroMotion then
        return;
    end;

    p17.IsMicroMotion = false;

    if p17.MicroMotionTween then
        p17.MicroMotionTween:Pause();
        p17.MicroMotionTween:Destroy();
        p17.MicroMotionTween = nil;
    end;
end;

function u1.hide(p18) -- Line: 145
    if p18.TransitionTween then
        p18.TransitionTween:Pause();
        p18.TransitionTween:Destroy();
        p18.TransitionTween = nil;
    end;

    if p18.MicroMotionTween then
        p18.MicroMotionTween:Pause();
        p18.MicroMotionTween:Destroy();
        p18.MicroMotionTween = nil;
    end;

    p18.Instance.Enabled = false;
end;

function u1.show(p19) -- Line: 159
    p19.Instance.Enabled = true;
end;

function u1.destroy(p20) -- Line: 163
    p20:stopMicroMotion();
    p20:hide();
end;

return u1;