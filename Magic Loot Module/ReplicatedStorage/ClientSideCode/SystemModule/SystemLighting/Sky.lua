-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local InsMgr = UtilsSystem.InsMgr;
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _setSkyEffectParams(p2, p3) -- Line: 30
    p2.Instance.MoonAngularSize = p3.MoonAngularSize;
    p2.Instance.MoonTextureId = p3.MoonTextureId;
    p2.Instance.SkyboxBk = p3.SkyboxBk;
    p2.Instance.SkyboxDn = p3.SkyboxDn;
    p2.Instance.SkyboxFt = p3.SkyboxFt;
    p2.Instance.SkyboxLf = p3.SkyboxLf;
    p2.Instance.SkyboxRt = p3.SkyboxRt;
    p2.Instance.SkyboxUp = p3.SkyboxUp;
    p2.Instance.SunTextureId = p3.SunTextureId;
    p2.Instance.SkyboxOrientation = p3.SkyboxOrientation;
    p2.Instance.StarCount = p3.StarCount;
    p2.Instance.SunAngularSize = p3.SunAngularSize;
    p2.Instance.CelestialBodiesShown = p3.CelestialBodiesShown;
end;

function u1.new() -- Line: 46
    -- upvalues: u1 (copy), InsMgr (copy), Lighting (copy)
    local v4 = setmetatable({}, u1);
    v4.Instance = InsMgr.GetIns("Sky", "Sky", Lighting);
    v4.TransitionTween = nil;

    return v4;
end;

function u1.setSkyParams(p5, p6, p7) -- Line: 53
    -- upvalues: TweenService (copy), _setSkyEffectParams (copy)
    if p7 <= 0 then
        _setSkyEffectParams(p5, p6);

        return;
    end;

    p5.MoonAngularSize = p6.MoonAngularSize;
    p5.SkyboxOrientation = p6.SkyboxOrientation;
    p5.StarCount = p6.StarCount;
    p5.SunAngularSize = p6.SunAngularSize;
    p5.MoonTextureId = p6.MoonTextureId;
    p5.Instance.MoonTextureId = p5.MoonTextureId;
    p5.SkyboxBk = p6.SkyboxBk;
    p5.Instance.SkyboxBk = p5.SkyboxBk;
    p5.SkyboxDn = p6.SkyboxDn;
    p5.Instance.SkyboxDn = p5.SkyboxDn;
    p5.SkyboxFt = p6.SkyboxFt;
    p5.Instance.SkyboxFt = p5.SkyboxFt;
    p5.SkyboxLf = p6.SkyboxLf;
    p5.Instance.SkyboxLf = p5.SkyboxLf;
    p5.SkyboxRt = p6.SkyboxRt;
    p5.Instance.SkyboxRt = p5.SkyboxRt;
    p5.SkyboxUp = p6.SkyboxUp;
    p5.Instance.SkyboxUp = p5.SkyboxUp;
    p5.SunTextureId = p6.SunTextureId;
    p5.Instance.SunTextureId = p5.SunTextureId;
    p5.CelestialBodiesShown = p6.CelestialBodiesShown;
    p5.Instance.CelestialBodiesShown = p5.CelestialBodiesShown;

    if p5.TransitionTween then
        p5.TransitionTween:Pause();
        p5.TransitionTween:Destroy();
        p5.TransitionTween = nil;
    end;

    p5.TransitionTween = TweenService:Create(p5.Instance, TweenInfo.new(p7), {
        MoonAngularSize = p5.MoonAngularSize,
        SunAngularSize = p5.SunAngularSize,
        StarCount = p5.StarCount,
        SkyboxOrientation = p5.SkyboxOrientation
    });
    p5.TransitionTween:Play();
end;

function u1.hide(p8) -- Line: 97
    if p8.TransitionTween then
        p8.TransitionTween:Pause();
        p8.TransitionTween:Destroy();
        p8.TransitionTween = nil;
    end;

    p8.Instance.Parent = nil;
end;

function u1.show(p9) -- Line: 106
    -- upvalues: Lighting (copy)
    p9.Instance.Parent = Lighting;
end;

function u1.destroy(p10) -- Line: 110
    p10:hide();
end;

return u1;