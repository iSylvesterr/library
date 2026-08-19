-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Lighting = UtilsSystem.Lighting;
local TweenService = UtilsSystem.TweenService;
local u1 = {};
u1.__index = u1;

local function _applyLightingParams(p2) -- Line: 44
    -- upvalues: Lighting (copy)
    Lighting.Ambient = p2.Ambient;
    Lighting.Brightness = p2.Brightness;
    Lighting.EnvironmentDiffuseScale = p2.EnvironmentDiffuseScale;
    Lighting.EnvironmentSpecularScale = p2.EnvironmentSpecularScale;
    Lighting.ExposureCompensation = p2.ExposureCompensation;
    Lighting.ShadowSoftness = p2.ShadowSoftness;
    Lighting.OutdoorAmbient = p2.OutdoorAmbient;
    Lighting.GeographicLatitude = p2.GeographicLatitude;
end;

function u1.new() -- Line: 60
    -- upvalues: u1 (copy), Lighting (copy)
    local v3 = setmetatable({}, u1);
    v3.Ambient = Lighting.Ambient;
    v3.Brightness = Lighting.Brightness;
    v3.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale;
    v3.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale;
    v3.ExposureCompensation = Lighting.ExposureCompensation;
    v3.ShadowSoftness = Lighting.ShadowSoftness;
    v3.OutdoorAmbient = Lighting.OutdoorAmbient;
    v3.GeographicLatitude = Lighting.GeographicLatitude;
    v3.ClockTime = Lighting.ClockTime;
    v3.TransitionTween = nil;
    v3.ClockTransitionTween = nil;

    return v3;
end;

function u1.setLightingParams(p4, p5, p6) -- Line: 85
    -- upvalues: TweenService (copy), Lighting (copy)
    p4.Ambient = p5:GetAttribute("Ambient");
    p4.Brightness = p5:GetAttribute("Brightness");
    p4.EnvironmentDiffuseScale = p5:GetAttribute("EnvironmentDiffuseScale");
    p4.EnvironmentSpecularScale = p5:GetAttribute("EnvironmentSpecularScale");
    p4.ExposureCompensation = p5:GetAttribute("ExposureCompensation");
    p4.ShadowSoftness = p5:GetAttribute("ShadowSoftness");
    p4.OutdoorAmbient = p5:GetAttribute("OutdoorAmbient");
    p4.GeographicLatitude = p5:GetAttribute("GeographicLatitude");

    if p6 > 0 then
        if p4.TransitionTween then
            p4.TransitionTween:Pause();
            p4.TransitionTween:Destroy();
            p4.TransitionTween = nil;
        end;

        p4.TransitionTween = TweenService:Create(Lighting, TweenInfo.new(p6), {
            Ambient = p4.Ambient,
            Brightness = p4.Brightness,
            EnvironmentDiffuseScale = p4.EnvironmentDiffuseScale,
            EnvironmentSpecularScale = p4.EnvironmentSpecularScale,
            ExposureCompensation = p4.ExposureCompensation,
            ShadowSoftness = p4.ShadowSoftness,
            OutdoorAmbient = p4.OutdoorAmbient,
            GeographicLatitude = p4.GeographicLatitude
        });
        p4.TransitionTween:Play();

        return;
    end;

    Lighting.Ambient = p4.Ambient;
    Lighting.Brightness = p4.Brightness;
    Lighting.EnvironmentDiffuseScale = p4.EnvironmentDiffuseScale;
    Lighting.EnvironmentSpecularScale = p4.EnvironmentSpecularScale;
    Lighting.ExposureCompensation = p4.ExposureCompensation;
    Lighting.ShadowSoftness = p4.ShadowSoftness;
    Lighting.OutdoorAmbient = p4.OutdoorAmbient;
    Lighting.GeographicLatitude = p4.GeographicLatitude;
end;

function u1.setClockTime(p7, p8, p9) -- Line: 125
    -- upvalues: TweenService (copy), Lighting (copy)
    local v10 = p9 or 0;

    if v10 <= 0 then
        p7.ClockTime = p8;
        Lighting.ClockTime = p7.ClockTime;

        return;
    end;

    p7.ClockTime = p8;

    if p7.ClockTransitionTween then
        p7.ClockTransitionTween:Pause();
        p7.ClockTransitionTween:Destroy();
        p7.ClockTransitionTween = nil;
    end;

    p7.ClockTransitionTween = TweenService:Create(Lighting, TweenInfo.new(v10), {
        ClockTime = p7.ClockTime
    });
    p7.ClockTransitionTween:Play();
end;

function u1.destroy(p11) -- Line: 152
    if p11.TransitionTween then
        p11.TransitionTween:Pause();
        p11.TransitionTween:Destroy();
        p11.TransitionTween = nil;
    end;

    if p11.ClockTransitionTween then
        p11.ClockTransitionTween:Pause();
        p11.ClockTransitionTween:Destroy();
        p11.ClockTransitionTween = nil;
    end;
end;

return u1;