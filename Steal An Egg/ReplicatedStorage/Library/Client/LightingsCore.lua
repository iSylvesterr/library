-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Functions = ReplicatedStorage:WaitForChild("Library"):WaitForChild("Functions");
local Stringify = require(Functions.Stringify);
local DeepEqualsUnsafe = require(Functions.DeepEqualsUnsafe);
require(ReplicatedStorage.Directory.Lightings.Types.Interface);
local u1 = {
    Density = 0,
    Offset = 0,
    Glare = 0,
    Haze = 0,
    Color = Color3.new(0, 0, 0),
    Decay = Color3.new(0, 0, 0)
};
local u2 = {
    CelestialBodiesShown = false,
    MoonAngularSize = 0,
    MoonTextureId = "",
    SkyboxBk = "",
    SkyboxDn = "",
    SkyboxFt = "",
    SkyboxLf = "",
    SkyboxRt = "",
    SkyboxUp = "",
    StarCount = 0,
    SunAngularSize = 0,
    SunTextureId = ""
};
local u3 = {
    Enabled = true,
    Intensity = 0,
    Size = 0,
    Threshold = 4
};
local u4 = {
    Brightness = 0,
    Contrast = 0,
    Enabled = true,
    Saturation = 0,
    TintColor = Color3.new(1, 1, 1)
};
local u5 = {
    Enabled = true,
    Intensity = 0,
    Spread = 0
};
local u6 = {
    Enabled = true,
    FarIntensity = 0,
    FocusDistance = 0,
    InFocusRadius = 50,
    NearIntensity = 0
};
local u7 = {
    Enabled = true,
    Size = 0
};
local u8 = {
    Cover = 0,
    Density = 0,
    Enabled = true,
    Color = Color3.new(1, 1, 1)
};
local v9 = Stringify.CompileOrder({
    "Ambient",
    "Brightness",
    "ColorShift_Bottom",
    "ColorShift_Top",
    "EnvironmentDiffuseScale",
    "EnvironmentSpecularScale",
    "OutdoorAmbient",
    "ShadowSoftness",
    "ClockTime",
    "GeographicLatitude",
    "ExposureCompensation",
    "FogColor",
    "FogEnd",
    "FogStart",
    {
        Key = "Atmosphere",
        Value = { "Density", "Offset", "Color", "Decay", "Glare", "Haze" }
    },
    {
        Key = "Sky",
        Value = { "CelestialBodiesShown", "MoonAngularSize", "MoonTextureId", "SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "StarCount", "SunAngularSize", "SunTextureId" }
    },
    {
        Key = "Bloom",
        Value = { "Enabled", "Intensity", "Size", "Threshold" }
    },
    {
        Key = "ColorCorrection",
        Value = { "Brightness", "Contrast", "Enabled", "Saturation", "TintColor" }
    },
    {
        Key = "SunRays",
        Value = { "Enabled", "Intensity", "Spread" }
    },
    {
        Key = "DepthOfField",
        Value = { "Enabled", "FarIntensity", "FocusDistance", "InFocusRadius", "NearIntensity" }
    },
    {
        Key = "Blur",
        Value = { "Enabled", "Size" }
    },
    {
        Key = "Clouds",
        Value = { "Cover", "Density", "Color", "Enabled" }
    }
});

local function Lerp(p10, p11, p12) -- Line: 156
    return (p11 - p10) * p12 + p10;
end;

local function LerpOther(p13, p14, p15) -- Line: 160
    if p15 >= 0.5 then
        return p14;
    end;

    return p13;
end;

local function LerpOptionalInstance(p16, p17, p18, p19, p20, p21) -- Line: 168
    if p21 == 0 then
        return p19;
    end;

    if p21 == 1 then
        return p20;
    end;

    if p19 and (p17 and not p17(p19)) then
        p19 = nil;
    end;

    if p20 and (p17 and not p17(p20)) then
        p20 = nil;
    end;

    if p19 or p20 then
        return p16(p19 or p18, p20 or p18, p21);
    end;

    return nil;
end;

local function WrapNorm(p22, p23) -- Line: 195
    if p22 < 0 then
        p22 = p22 + math.ceil(-p22 / p23) * p23;
    end;

    return p22 % p23;
end;

local function WrapDeltaUnsafe(p24, p25, p26) -- Line: 202
    local v27 = p24 - p25;

    if p26 / 2 < v27 then
        return v27 - p26;
    end;

    if v27 < -p26 / 2 then
        return v27 + p26;
    end;

    return v27;
end;

local function WrapDelta(p28, p29, p30) -- Line: 213
    if p28 < 0 then
        p28 = p28 + math.ceil(-p28 / p30) * p30;
    end;

    if p29 < 0 then
        p29 = p29 + math.ceil(-p29 / p30) * p30;
    end;

    local v31 = p28 % p30 - p29 % p30;

    if p30 / 2 < v31 then
        return v31 - p30;
    end;

    if v31 < -p30 / 2 then
        return v31 + p30;
    end;

    return v31;
end;

local function WrapLerp(p32, p33, p34, p35) -- Line: 217
    if p33 < 0 then
        p33 = p33 + math.ceil(-p33 / p34) * p34;
    end;

    local v36;

    if p32 < 0 then
        v36 = p32 + math.ceil(-p32 / p34) * p34;
    else
        v36 = p32;
    end;

    local v37 = p33 % p34 - v36 % p34;

    if p34 / 2 < v37 then
        v37 = v37 - p34;
    elseif v37 < -p34 / 2 then
        v37 = v37 + p34;
    end;

    return p32 + v37 * p35;
end;

local function ApplyOptionalInstance(p38, p39, p40, p41, p42) -- Line: 221
    local v43 = p40 or p41;
    local v44 = p39:FindFirstChild(v43);

    if v44 and not v44:IsA(p41) then
        v44 = nil;
    end;

    if not p42 then
        if v44 then
            v44:Destroy();
        end;

        return;
    end;

    if not v44 then
        local v45 = Instance.new(p41);
        v45.Name = v43;
        p38(v45, p42);
        v45.Parent = p39;

        return v45;
    end;

    p38(v44, p42);
end;

local function SerializeOptionalInstance(p46, p47, p48, p49) -- Line: 250
    local v50 = p47:FindFirstChild(p48 or p49);

    if v50 and not v50:IsA(p49) then
        v50 = nil;
    end;

    if v50 then
        return p46(v50);
    end;

    return nil;
end;

local function GetAttribute(p51, p52, p53, p54) -- Line: 267
    local v55 = p51:GetAttribute(p52);

    if v55 ~= nil then
        local v56 = typeof(v55) == p53;
        local format = string.format;
        local v57 = typeof(v55);
        assert(v56, format("%* was %* but should have been %*", p52, v57, p53));

        if p54 ~= nil then
            local v58 = v55.EnumType == p54;
            local v59 = `{p52} was {v55.EnumType} but should have been {p54}`;
            assert(v58, v59);
        end;
    end;

    return v55;
end;

local function SetDifferentialAttribute(p60, p61, p62, p63, p64) -- Line: 281
    if p64 or p62 ~= p63 then
        p60:SetAttribute(p61, p62);
    end;
end;

local u65 = {
    COMPILED_ORDER = v9,
    STRINGIFY_PRETTY = {
        Pretty = true,
        IndentChar = "\t",
        IndentSize = 1,
        Order = v9
    }
};

function u65.Stringify(p66) -- Line: 291
    -- upvalues: Stringify (copy), u65 (copy)
    return Stringify.Pretty(p66, u65.STRINGIFY_PRETTY);
end;

function u65.LerpAtmosphere(p67, p68, p69) -- Line: 295
    local v70 = {};
    local Density = p67.Density;
    v70.Density = (p68.Density - Density) * p69 + Density;
    local Offset = p67.Offset;
    v70.Offset = (p68.Offset - Offset) * p69 + Offset;
    v70.Color = p67.Color:Lerp(p68.Color, p69);
    v70.Decay = p67.Decay:Lerp(p68.Decay, p69);
    local Glare = p67.Glare;
    v70.Glare = (p68.Glare - Glare) * p69 + Glare;
    local Haze = p67.Haze;
    v70.Haze = (p68.Haze - Haze) * p69 + Haze;

    return v70;
end;

function u65.LerpSky(p71, p72, p73) -- Line: 310
    local v74 = {};
    local CelestialBodiesShown = p71.CelestialBodiesShown;
    local CelestialBodiesShown2 = p72.CelestialBodiesShown;

    if p73 < 0.5 then
        CelestialBodiesShown2 = CelestialBodiesShown;
    end;

    v74.CelestialBodiesShown = CelestialBodiesShown2;
    local MoonAngularSize = p71.MoonAngularSize;
    v74.MoonAngularSize = (p72.MoonAngularSize - MoonAngularSize) * p73 + MoonAngularSize;
    local MoonTextureId = p71.MoonTextureId;
    local MoonTextureId2 = p72.MoonTextureId;

    if p73 >= 0.5 then
        MoonTextureId = MoonTextureId2;
    end;

    v74.MoonTextureId = MoonTextureId;
    local SkyboxBk = p71.SkyboxBk;
    local SkyboxBk2 = p72.SkyboxBk;

    if p73 >= 0.5 then
        SkyboxBk = SkyboxBk2;
    end;

    v74.SkyboxBk = SkyboxBk;
    local SkyboxDn = p71.SkyboxDn;
    local SkyboxDn2 = p72.SkyboxDn;

    if p73 >= 0.5 then
        SkyboxDn = SkyboxDn2;
    end;

    v74.SkyboxDn = SkyboxDn;
    local SkyboxFt = p71.SkyboxFt;
    local SkyboxFt2 = p72.SkyboxFt;

    if p73 >= 0.5 then
        SkyboxFt = SkyboxFt2;
    end;

    v74.SkyboxFt = SkyboxFt;
    local SkyboxLf = p71.SkyboxLf;
    local SkyboxLf2 = p72.SkyboxLf;

    if p73 >= 0.5 then
        SkyboxLf = SkyboxLf2;
    end;

    v74.SkyboxLf = SkyboxLf;
    local SkyboxRt = p71.SkyboxRt;
    local SkyboxRt2 = p72.SkyboxRt;

    if p73 >= 0.5 then
        SkyboxRt = SkyboxRt2;
    end;

    v74.SkyboxRt = SkyboxRt;
    local SkyboxUp = p71.SkyboxUp;
    local SkyboxUp2 = p72.SkyboxUp;

    if p73 >= 0.5 then
        SkyboxUp = SkyboxUp2;
    end;

    v74.SkyboxUp = SkyboxUp;
    local StarCount = p71.StarCount;
    v74.StarCount = math.round((p72.StarCount - StarCount) * p73 + StarCount);
    local SunAngularSize = p71.SunAngularSize;
    v74.SunAngularSize = (p72.SunAngularSize - SunAngularSize) * p73 + SunAngularSize;
    local SunTextureId = p71.SunTextureId;
    local SunTextureId2 = p72.SunTextureId;

    if p73 >= 0.5 then
        SunTextureId = SunTextureId2;
    end;

    v74.SunTextureId = SunTextureId;

    return v74;
end;

function u65.LerpBloomEffect(p75, p76, p77) -- Line: 327
    local v78 = {};
    local Enabled = p75.Enabled;
    local Enabled2 = p76.Enabled;

    if p77 < 0.5 then
        Enabled2 = Enabled;
    end;

    v78.Enabled = Enabled2;
    local Intensity = p75.Intensity;
    v78.Intensity = (p76.Intensity - Intensity) * p77 + Intensity;
    local Size = p75.Size;
    v78.Size = (p76.Size - Size) * p77 + Size;
    local Threshold = p75.Threshold;
    v78.Threshold = (p76.Threshold - Threshold) * p77 + Threshold;

    return v78;
end;

function u65.LerpColorCorrectionEffect(p79, p80, p81) -- Line: 336
    local v82 = {};
    local Brightness = p79.Brightness;
    v82.Brightness = (p80.Brightness - Brightness) * p81 + Brightness;
    local Contrast = p79.Contrast;
    v82.Contrast = (p80.Contrast - Contrast) * p81 + Contrast;
    local Enabled = p79.Enabled;
    local Enabled2 = p80.Enabled;

    if p81 < 0.5 then
        Enabled2 = Enabled;
    end;

    v82.Enabled = Enabled2;
    local Saturation = p79.Saturation;
    v82.Saturation = (p80.Saturation - Saturation) * p81 + Saturation;
    v82.TintColor = p79.TintColor:Lerp(p80.TintColor, p81);

    return v82;
end;

function u65.LerpSunRaysEffect(p83, p84, p85) -- Line: 350
    local v86 = {};
    local Enabled = p83.Enabled;
    local Enabled2 = p84.Enabled;

    if p85 < 0.5 then
        Enabled2 = Enabled;
    end;

    v86.Enabled = Enabled2;
    local Intensity = p83.Intensity;
    v86.Intensity = (p84.Intensity - Intensity) * p85 + Intensity;
    local Spread = p83.Spread;
    v86.Spread = (p84.Spread - Spread) * p85 + Spread;

    return v86;
end;

function u65.LerpDepthOfFieldEffect(p87, p88, p89) -- Line: 358
    local v90 = {};
    local Enabled = p87.Enabled;
    local Enabled2 = p88.Enabled;

    if p89 < 0.5 then
        Enabled2 = Enabled;
    end;

    v90.Enabled = Enabled2;
    local FarIntensity = p87.FarIntensity;
    v90.FarIntensity = (p88.FarIntensity - FarIntensity) * p89 + FarIntensity;
    local FocusDistance = p87.FocusDistance;
    v90.FocusDistance = (p88.FocusDistance - FocusDistance) * p89 + FocusDistance;
    local InFocusRadius = p87.InFocusRadius;
    v90.InFocusRadius = (p88.InFocusRadius - InFocusRadius) * p89 + InFocusRadius;
    local NearIntensity = p87.NearIntensity;
    v90.NearIntensity = (p88.NearIntensity - NearIntensity) * p89 + NearIntensity;

    return v90;
end;

function u65.LerpBlurEffect(p91, p92, p93) -- Line: 372
    local v94 = {};
    local Enabled = p91.Enabled;
    local Enabled2 = p92.Enabled;

    if p93 < 0.5 then
        Enabled2 = Enabled;
    end;

    v94.Enabled = Enabled2;
    local Size = p91.Size;
    v94.Size = (p92.Size - Size) * p93 + Size;

    return v94;
end;

function u65.LerpClouds(p95, p96, p97) -- Line: 379
    local v98 = {};
    local Cover = p95.Cover;
    v98.Cover = (p96.Cover - Cover) * p97 + Cover;
    local Density = p95.Density;
    v98.Density = (p96.Density - Density) * p97 + Density;
    v98.Color = p95.Color:Lerp(p96.Color, p97);
    local Enabled = p95.Enabled;
    local Enabled2 = p96.Enabled;

    if p97 < 0.5 then
        Enabled2 = Enabled;
    end;

    v98.Enabled = Enabled2;

    return v98;
end;

function u65.Lerp(p99, p100, p101) -- Line: 388
    -- upvalues: LerpOptionalInstance (copy), u65 (copy), u1 (copy), u2 (copy), u3 (copy), u4 (copy), u5 (copy), u6 (copy), u7 (copy), u8 (copy)
    local v102 = {
        Ambient = p99.Ambient:Lerp(p100.Ambient, p101)
    };
    local Brightness = p99.Brightness;
    v102.Brightness = (p100.Brightness - Brightness) * p101 + Brightness;
    v102.ColorShift_Bottom = p99.ColorShift_Bottom:Lerp(p100.ColorShift_Bottom, p101);
    v102.ColorShift_Top = p99.ColorShift_Top:Lerp(p100.ColorShift_Top, p101);
    local EnvironmentDiffuseScale = p99.EnvironmentDiffuseScale;
    v102.EnvironmentDiffuseScale = (p100.EnvironmentDiffuseScale - EnvironmentDiffuseScale) * p101 + EnvironmentDiffuseScale;
    local EnvironmentSpecularScale = p99.EnvironmentSpecularScale;
    v102.EnvironmentSpecularScale = (p100.EnvironmentSpecularScale - EnvironmentSpecularScale) * p101 + EnvironmentSpecularScale;
    v102.OutdoorAmbient = p99.OutdoorAmbient:Lerp(p100.OutdoorAmbient, p101);
    local ShadowSoftness = p99.ShadowSoftness;
    v102.ShadowSoftness = (p100.ShadowSoftness - ShadowSoftness) * p101 + ShadowSoftness;
    local ClockTime = p99.ClockTime;
    local ClockTime2 = p100.ClockTime;

    if ClockTime2 < 0 then
        ClockTime2 = ClockTime2 + math.ceil(-ClockTime2 / 24) * 24;
    end;

    local v103;

    if ClockTime < 0 then
        v103 = ClockTime + math.ceil(-ClockTime / 24) * 24;
    else
        v103 = ClockTime;
    end;

    local v104 = ClockTime2 % 24 - v103 % 24;

    if v104 > 12 then
        v104 = v104 - 24;
    elseif v104 < -12 then
        v104 = v104 + 24;
    end;

    v102.ClockTime = ClockTime + v104 * p101;
    local GeographicLatitude = p99.GeographicLatitude;
    local GeographicLatitude2 = p100.GeographicLatitude;

    if GeographicLatitude2 < 0 then
        GeographicLatitude2 = GeographicLatitude2 + math.ceil(-GeographicLatitude2 / 360) * 360;
    end;

    local v105;

    if GeographicLatitude < 0 then
        v105 = GeographicLatitude + math.ceil(-GeographicLatitude / 360) * 360;
    else
        v105 = GeographicLatitude;
    end;

    local v106 = GeographicLatitude2 % 360 - v105 % 360;

    if v106 > 180 then
        v106 = v106 - 360;
    elseif v106 < -180 then
        v106 = v106 + 360;
    end;

    v102.GeographicLatitude = GeographicLatitude + v106 * p101;
    local ExposureCompensation = p99.ExposureCompensation;
    v102.ExposureCompensation = (p100.ExposureCompensation - ExposureCompensation) * p101 + ExposureCompensation;
    v102.FogColor = p99.FogColor:Lerp(p100.FogColor, p101);
    local FogEnd = p99.FogEnd;
    v102.FogEnd = (p100.FogEnd - FogEnd) * p101 + FogEnd;
    local FogStart = p99.FogStart;
    v102.FogStart = (p100.FogStart - FogStart) * p101 + FogStart;
    v102.Atmosphere = LerpOptionalInstance(u65.LerpAtmosphere, nil, u1, p99.Atmosphere, p100.Atmosphere, p101);
    v102.Sky = LerpOptionalInstance(u65.LerpSky, nil, u2, p99.Sky, p100.Sky, p101);
    v102.Bloom = LerpOptionalInstance(u65.LerpBloomEffect, function(p107) -- Line: 413
        return p107.Enabled;
    end, u3, p99.Bloom, p100.Bloom, p101);
    v102.ColorCorrection = LerpOptionalInstance(u65.LerpColorCorrectionEffect, function(p108) -- Line: 416
        return p108.Enabled;
    end, u4, p99.ColorCorrection, p100.ColorCorrection, p101);
    v102.SunRays = LerpOptionalInstance(u65.LerpSunRaysEffect, function(p109) -- Line: 419
        return p109.Enabled;
    end, u5, p99.SunRays, p100.SunRays, p101);
    v102.DepthOfField = LerpOptionalInstance(u65.LerpDepthOfFieldEffect, function(p110) -- Line: 422
        return p110.Enabled;
    end, u6, p99.DepthOfField, p100.DepthOfField, p101);
    v102.Blur = LerpOptionalInstance(u65.LerpBlurEffect, function(p111) -- Line: 425
        return p111.Enabled;
    end, u7, p99.Blur, p100.Blur, p101);
    v102.Clouds = LerpOptionalInstance(u65.LerpClouds, function(p112) -- Line: 428
        return p112.Enabled;
    end, u8, p99.Clouds, p100.Clouds, p101);

    return v102;
end;

function u65.SerializeAtmosphere(p113) -- Line: 434
    return {
        Density = p113.Density,
        Offset = p113.Offset,
        Color = p113.Color,
        Decay = p113.Decay,
        Glare = p113.Glare,
        Haze = p113.Haze
    };
end;

function u65.SerializeSky(p114) -- Line: 445
    return {
        CelestialBodiesShown = p114.CelestialBodiesShown,
        MoonAngularSize = p114.MoonAngularSize,
        MoonTextureId = p114.MoonTextureId,
        SkyboxBk = p114.SkyboxBk,
        SkyboxDn = p114.SkyboxDn,
        SkyboxFt = p114.SkyboxFt,
        SkyboxLf = p114.SkyboxLf,
        SkyboxRt = p114.SkyboxRt,
        SkyboxUp = p114.SkyboxUp,
        StarCount = p114.StarCount,
        SunAngularSize = p114.SunAngularSize,
        SunTextureId = p114.SunTextureId
    };
end;

function u65.SerializeBloomEffect(p115) -- Line: 462
    return {
        Enabled = p115.Enabled,
        Intensity = p115.Intensity,
        Size = p115.Size,
        Threshold = p115.Threshold
    };
end;

function u65.SerializeColorCorrectionEffect(p116) -- Line: 471
    return {
        Brightness = p116.Brightness,
        Contrast = p116.Contrast,
        Enabled = p116.Enabled,
        Saturation = p116.Saturation,
        TintColor = p116.TintColor
    };
end;

function u65.SerializeSunRaysEffect(p117) -- Line: 481
    return {
        Enabled = p117.Enabled,
        Intensity = p117.Intensity,
        Spread = p117.Spread
    };
end;

function u65.SerializeDepthOfFieldEffect(p118) -- Line: 489
    return {
        Enabled = p118.Enabled,
        FarIntensity = p118.FarIntensity,
        FocusDistance = p118.FocusDistance,
        InFocusRadius = p118.InFocusRadius,
        NearIntensity = p118.NearIntensity
    };
end;

function u65.SerializeBlurEffect(p119) -- Line: 499
    return {
        Enabled = p119.Enabled,
        Size = p119.Size
    };
end;

function u65.SerializeClouds(p120) -- Line: 506
    return {
        Cover = p120.Cover,
        Density = p120.Density,
        Color = p120.Color,
        Enabled = p120.Enabled
    };
end;

function u65.Serialize(p121) -- Line: 515
    -- upvalues: u65 (copy)
    local v122 = {
        Ambient = p121.Ambient,
        Brightness = p121.Brightness,
        ColorShift_Bottom = p121.ColorShift_Bottom,
        ColorShift_Top = p121.ColorShift_Top,
        EnvironmentDiffuseScale = p121.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = p121.EnvironmentSpecularScale,
        OutdoorAmbient = p121.OutdoorAmbient,
        ShadowSoftness = p121.ShadowSoftness,
        ClockTime = p121.ClockTime,
        GeographicLatitude = p121.GeographicLatitude,
        ExposureCompensation = p121.ExposureCompensation,
        FogColor = p121.FogColor,
        FogEnd = p121.FogEnd,
        FogStart = p121.FogStart
    };
    local SerializeAtmosphere = u65.SerializeAtmosphere;
    local Atmosphere = p121:FindFirstChild("Atmosphere");

    if Atmosphere and not Atmosphere:IsA("Atmosphere") then
        Atmosphere = nil;
    end;

    local v123;

    if Atmosphere then
        v123 = SerializeAtmosphere(Atmosphere);
    else
        v123 = nil;
    end;

    v122.Atmosphere = v123;
    local SerializeSky = u65.SerializeSky;
    local Sky = p121:FindFirstChild("Sky");

    if Sky and not Sky:IsA("Sky") then
        Sky = nil;
    end;

    local v124;

    if Sky then
        v124 = SerializeSky(Sky);
    else
        v124 = nil;
    end;

    v122.Sky = v124;
    local SerializeBloomEffect = u65.SerializeBloomEffect;
    local Bloom = p121:FindFirstChild("Bloom");

    if Bloom and not Bloom:IsA("BloomEffect") then
        Bloom = nil;
    end;

    local v125;

    if Bloom then
        v125 = SerializeBloomEffect(Bloom);
    else
        v125 = nil;
    end;

    v122.Bloom = v125;
    local SerializeColorCorrectionEffect = u65.SerializeColorCorrectionEffect;
    local ColorCorrection = p121:FindFirstChild("ColorCorrection");

    if ColorCorrection and not ColorCorrection:IsA("ColorCorrectionEffect") then
        ColorCorrection = nil;
    end;

    local v126;

    if ColorCorrection then
        v126 = SerializeColorCorrectionEffect(ColorCorrection);
    else
        v126 = nil;
    end;

    v122.ColorCorrection = v126;
    local SerializeSunRaysEffect = u65.SerializeSunRaysEffect;
    local SunRays = p121:FindFirstChild("SunRays");

    if SunRays and not SunRays:IsA("SunRaysEffect") then
        SunRays = nil;
    end;

    local v127;

    if SunRays then
        v127 = SerializeSunRaysEffect(SunRays);
    else
        v127 = nil;
    end;

    v122.SunRays = v127;
    local SerializeDepthOfFieldEffect = u65.SerializeDepthOfFieldEffect;
    local DepthOfField = p121:FindFirstChild("DepthOfField");

    if DepthOfField and not DepthOfField:IsA("DepthOfFieldEffect") then
        DepthOfField = nil;
    end;

    local v128;

    if DepthOfField then
        v128 = SerializeDepthOfFieldEffect(DepthOfField);
    else
        v128 = nil;
    end;

    v122.DepthOfField = v128;
    local SerializeBlurEffect = u65.SerializeBlurEffect;
    local Blur = p121:FindFirstChild("Blur");

    if Blur and not Blur:IsA("BlurEffect") then
        Blur = nil;
    end;

    local v129;

    if Blur then
        v129 = SerializeBlurEffect(Blur);
    else
        v129 = nil;
    end;

    v122.Blur = v129;
    local SerializeClouds = u65.SerializeClouds;
    local Clouds = p121:FindFirstChild("Clouds");

    if Clouds and not Clouds:IsA("Clouds") then
        Clouds = nil;
    end;

    local v130;

    if Clouds then
        v130 = SerializeClouds(Clouds);
    else
        v130 = nil;
    end;

    v122.Clouds = v130;

    return v122;
end;

function u65.FromConfig(p131, p132) -- Line: 552
    -- upvalues: u65 (copy)
    local v133 = {};
    local v134 = p131:GetAttribute("Ambient");

    if v134 ~= nil then
        local v135 = typeof(v134) == "Color3";
        local format = string.format;
        local v136 = typeof(v134);
        assert(v135, format("%* was %* but should have been %*", "Ambient", v136, "Color3"));
    end;

    v133.Ambient = v134 or p132.Ambient;
    local v137 = p131:GetAttribute("Brightness");

    if v137 ~= nil then
        local v138 = typeof(v137) == "number";
        local format = string.format;
        local v139 = typeof(v137);
        assert(v138, format("%* was %* but should have been %*", "Brightness", v139, "number"));
    end;

    v133.Brightness = v137 or p132.Brightness;
    local v140 = p131:GetAttribute("ColorShift_Bottom");

    if v140 ~= nil then
        local v141 = typeof(v140) == "Color3";
        local format = string.format;
        local v142 = typeof(v140);
        assert(v141, format("%* was %* but should have been %*", "ColorShift_Bottom", v142, "Color3"));
    end;

    v133.ColorShift_Bottom = v140 or p132.ColorShift_Bottom;
    local v143 = p131:GetAttribute("ColorShift_Top");

    if v143 ~= nil then
        local v144 = typeof(v143) == "Color3";
        local format = string.format;
        local v145 = typeof(v143);
        assert(v144, format("%* was %* but should have been %*", "ColorShift_Top", v145, "Color3"));
    end;

    v133.ColorShift_Top = v143 or p132.ColorShift_Top;
    local v146 = p131:GetAttribute("EnvironmentDiffuseScale");

    if v146 ~= nil then
        local v147 = typeof(v146) == "number";
        local format = string.format;
        local v148 = typeof(v146);
        assert(v147, format("%* was %* but should have been %*", "EnvironmentDiffuseScale", v148, "number"));
    end;

    v133.EnvironmentDiffuseScale = v146 or p132.EnvironmentDiffuseScale;
    local v149 = p131:GetAttribute("EnvironmentSpecularScale");

    if v149 ~= nil then
        local v150 = typeof(v149) == "number";
        local format = string.format;
        local v151 = typeof(v149);
        assert(v150, format("%* was %* but should have been %*", "EnvironmentSpecularScale", v151, "number"));
    end;

    v133.EnvironmentSpecularScale = v149 or p132.EnvironmentSpecularScale;
    local v152 = p131:GetAttribute("OutdoorAmbient");

    if v152 ~= nil then
        local v153 = typeof(v152) == "Color3";
        local format = string.format;
        local v154 = typeof(v152);
        assert(v153, format("%* was %* but should have been %*", "OutdoorAmbient", v154, "Color3"));
    end;

    v133.OutdoorAmbient = v152 or p132.OutdoorAmbient;
    local v155 = p131:GetAttribute("ShadowSoftness");

    if v155 ~= nil then
        local v156 = typeof(v155) == "number";
        local format = string.format;
        local v157 = typeof(v155);
        assert(v156, format("%* was %* but should have been %*", "ShadowSoftness", v157, "number"));
    end;

    v133.ShadowSoftness = v155 or p132.ShadowSoftness;
    local v158 = p131:GetAttribute("ClockTime");

    if v158 ~= nil then
        local v159 = typeof(v158) == "number";
        local format = string.format;
        local v160 = typeof(v158);
        assert(v159, format("%* was %* but should have been %*", "ClockTime", v160, "number"));
    end;

    v133.ClockTime = v158 or p132.ClockTime;
    local v161 = p131:GetAttribute("GeographicLatitude");

    if v161 ~= nil then
        local v162 = typeof(v161) == "number";
        local format = string.format;
        local v163 = typeof(v161);
        assert(v162, format("%* was %* but should have been %*", "GeographicLatitude", v163, "number"));
    end;

    v133.GeographicLatitude = v161 or p132.GeographicLatitude;
    local v164 = p131:GetAttribute("ExposureCompensation");

    if v164 ~= nil then
        local v165 = typeof(v164) == "number";
        local format = string.format;
        local v166 = typeof(v164);
        assert(v165, format("%* was %* but should have been %*", "ExposureCompensation", v166, "number"));
    end;

    v133.ExposureCompensation = v164 or p132.ExposureCompensation;
    local v167 = p131:GetAttribute("FogColor");

    if v167 ~= nil then
        local v168 = typeof(v167) == "Color3";
        local format = string.format;
        local v169 = typeof(v167);
        assert(v168, format("%* was %* but should have been %*", "FogColor", v169, "Color3"));
    end;

    v133.FogColor = v167 or p132.FogColor;
    local v170 = p131:GetAttribute("FogEnd");

    if v170 ~= nil then
        local v171 = typeof(v170) == "number";
        local format = string.format;
        local v172 = typeof(v170);
        assert(v171, format("%* was %* but should have been %*", "FogEnd", v172, "number"));
    end;

    v133.FogEnd = v170 or p132.FogEnd;
    local v173 = p131:GetAttribute("FogStart");

    if v173 ~= nil then
        local v174 = typeof(v173) == "number";
        local format = string.format;
        local v175 = typeof(v173);
        assert(v174, format("%* was %* but should have been %*", "FogStart", v175, "number"));
    end;

    v133.FogStart = v173 or p132.FogStart;
    local SerializeAtmosphere = u65.SerializeAtmosphere;
    local Atmosphere = p131:FindFirstChild("Atmosphere");

    if Atmosphere and not Atmosphere:IsA("Atmosphere") then
        Atmosphere = nil;
    end;

    local v176;

    if Atmosphere then
        v176 = SerializeAtmosphere(Atmosphere);
    else
        v176 = nil;
    end;

    v133.Atmosphere = v176 or p132.Atmosphere;
    local SerializeSky = u65.SerializeSky;
    local Sky = p131:FindFirstChild("Sky");

    if Sky and not Sky:IsA("Sky") then
        Sky = nil;
    end;

    local v177;

    if Sky then
        v177 = SerializeSky(Sky);
    else
        v177 = nil;
    end;

    v133.Sky = v177 or p132.Sky;
    local SerializeBloomEffect = u65.SerializeBloomEffect;
    local Bloom = p131:FindFirstChild("Bloom");

    if Bloom and not Bloom:IsA("BloomEffect") then
        Bloom = nil;
    end;

    local v178;

    if Bloom then
        v178 = SerializeBloomEffect(Bloom);
    else
        v178 = nil;
    end;

    v133.Bloom = v178 or p132.Bloom;
    local SerializeColorCorrectionEffect = u65.SerializeColorCorrectionEffect;
    local ColorCorrection = p131:FindFirstChild("ColorCorrection");

    if ColorCorrection and not ColorCorrection:IsA("ColorCorrectionEffect") then
        ColorCorrection = nil;
    end;

    local v179;

    if ColorCorrection then
        v179 = SerializeColorCorrectionEffect(ColorCorrection);
    else
        v179 = nil;
    end;

    v133.ColorCorrection = v179 or p132.ColorCorrection;
    local SerializeSunRaysEffect = u65.SerializeSunRaysEffect;
    local SunRays = p131:FindFirstChild("SunRays");

    if SunRays and not SunRays:IsA("SunRaysEffect") then
        SunRays = nil;
    end;

    local v180;

    if SunRays then
        v180 = SerializeSunRaysEffect(SunRays);
    else
        v180 = nil;
    end;

    v133.SunRays = v180 or p132.SunRays;
    local SerializeDepthOfFieldEffect = u65.SerializeDepthOfFieldEffect;
    local DepthOfField = p131:FindFirstChild("DepthOfField");

    if DepthOfField and not DepthOfField:IsA("DepthOfFieldEffect") then
        DepthOfField = nil;
    end;

    local v181;

    if DepthOfField then
        v181 = SerializeDepthOfFieldEffect(DepthOfField);
    else
        v181 = nil;
    end;

    v133.DepthOfField = v181 or p132.DepthOfField;
    local SerializeBlurEffect = u65.SerializeBlurEffect;
    local Blur = p131:FindFirstChild("Blur");

    if Blur and not Blur:IsA("BlurEffect") then
        Blur = nil;
    end;

    local v182;

    if Blur then
        v182 = SerializeBlurEffect(Blur);
    else
        v182 = nil;
    end;

    v133.Blur = v182 or p132.Blur;
    local SerializeClouds = u65.SerializeClouds;
    local Clouds = p131:FindFirstChild("Clouds");

    if Clouds and not Clouds:IsA("Clouds") then
        Clouds = nil;
    end;

    local v183;

    if Clouds then
        v183 = SerializeClouds(Clouds);
    else
        v183 = nil;
    end;

    v133.Clouds = v183 or p132.Clouds;

    return v133;
end;

function u65.ApplyAtmosphere(p184, p185) -- Line: 597
    p184.Density = p185.Density;
    p184.Offset = p185.Offset;
    p184.Color = p185.Color;
    p184.Decay = p185.Decay;
    p184.Glare = p185.Glare;
    p184.Haze = p185.Haze;
end;

function u65.ApplySky(p186, p187) -- Line: 606
    p186.CelestialBodiesShown = p187.CelestialBodiesShown;
    p186.MoonAngularSize = p187.MoonAngularSize;
    p186.MoonTextureId = p187.MoonTextureId;
    p186.SkyboxBk = p187.SkyboxBk;
    p186.SkyboxDn = p187.SkyboxDn;
    p186.SkyboxFt = p187.SkyboxFt;
    p186.SkyboxLf = p187.SkyboxLf;
    p186.SkyboxRt = p187.SkyboxRt;
    p186.SkyboxUp = p187.SkyboxUp;
    p186.StarCount = p187.StarCount;
    p186.SunAngularSize = p187.SunAngularSize;
    p186.SunTextureId = p187.SunTextureId;
end;

function u65.ApplyBloomEffect(p188, p189) -- Line: 621
    p188.Enabled = p189.Enabled;
    p188.Intensity = p189.Intensity;
    p188.Size = p189.Size;
    p188.Threshold = p189.Threshold;
end;

function u65.ApplyColorCorrectionEffect(p190, p191) -- Line: 628
    p190.Brightness = p191.Brightness;
    p190.Contrast = p191.Contrast;
    p190.Enabled = p191.Enabled;
    p190.Saturation = p191.Saturation;
    p190.TintColor = p191.TintColor;
end;

function u65.ApplySunRaysEffect(p192, p193) -- Line: 639
    p192.Enabled = p193.Enabled;
    p192.Intensity = p193.Intensity;
    p192.Spread = p193.Spread;
end;

function u65.ApplyDepthOfFieldEffect(p194, p195) -- Line: 645
    p194.Enabled = p195.Enabled;
    p194.FarIntensity = p195.FarIntensity;
    p194.FocusDistance = p195.FocusDistance;
    p194.InFocusRadius = p195.InFocusRadius;
    p194.NearIntensity = p195.NearIntensity;
end;

function u65.ApplyBlurEffect(p196, p197) -- Line: 653
    p196.Enabled = p197.Enabled;
    p196.Size = p197.Size;
end;

function u65.ApplyClouds(p198, p199) -- Line: 658
    p198.Cover = p199.Cover;
    p198.Density = p199.Density;
    p198.Color = p199.Color;
    p198.Enabled = p199.Enabled;
end;

function u65.Apply(p200, p201) -- Line: 665
    -- upvalues: ApplyOptionalInstance (copy), u65 (copy)
    p200.Ambient = p201.Ambient;
    p200.Brightness = p201.Brightness;
    p200.ColorShift_Bottom = p201.ColorShift_Bottom;
    p200.ColorShift_Top = p201.ColorShift_Top;
    p200.EnvironmentDiffuseScale = p201.EnvironmentDiffuseScale;
    p200.EnvironmentSpecularScale = p201.EnvironmentSpecularScale;
    p200.OutdoorAmbient = p201.OutdoorAmbient;
    p200.ShadowSoftness = p201.ShadowSoftness;
    p200.ClockTime = p201.ClockTime;
    p200.GeographicLatitude = p201.GeographicLatitude;
    p200.ExposureCompensation = p201.ExposureCompensation;
    p200.FogColor = p201.FogColor;
    p200.FogEnd = p201.FogEnd;
    p200.FogStart = p201.FogStart;
    ApplyOptionalInstance(u65.ApplyAtmosphere, p200, nil, "Atmosphere", p201.Atmosphere);
    ApplyOptionalInstance(u65.ApplySky, p200, nil, "Sky", p201.Sky);
    ApplyOptionalInstance(u65.ApplyBloomEffect, p200, "Bloom", "BloomEffect", p201.Bloom);
    ApplyOptionalInstance(u65.ApplyColorCorrectionEffect, p200, "ColorCorrection", "ColorCorrectionEffect", p201.ColorCorrection);
    ApplyOptionalInstance(u65.ApplySunRaysEffect, p200, "SunRays", "SunRaysEffect", p201.SunRays);
    ApplyOptionalInstance(u65.ApplyDepthOfFieldEffect, p200, "DepthOfField", "DepthOfFieldEffect", p201.DepthOfField);
    ApplyOptionalInstance(u65.ApplyBlurEffect, p200, "Blur", "BlurEffect", p201.Blur);
    ApplyOptionalInstance(u65.ApplyClouds, p200, "Clouds", "Clouds", p201.Clouds);
end;

function u65.ToConfig(p202, p203, p204) -- Line: 702
    -- upvalues: DeepEqualsUnsafe (copy), ApplyOptionalInstance (copy), u65 (copy)
    local Folder = Instance.new("Folder");
    local Ambient = p202.Ambient;

    if p204 or Ambient ~= p203.Ambient then
        Folder:SetAttribute("Ambient", Ambient);
    end;

    local Brightness = p202.Brightness;

    if p204 or Brightness ~= p203.Brightness then
        Folder:SetAttribute("Brightness", Brightness);
    end;

    local ColorShift_Bottom = p202.ColorShift_Bottom;

    if p204 or ColorShift_Bottom ~= p203.ColorShift_Bottom then
        Folder:SetAttribute("ColorShift_Bottom", ColorShift_Bottom);
    end;

    local ColorShift_Top = p202.ColorShift_Top;

    if p204 or ColorShift_Top ~= p203.ColorShift_Top then
        Folder:SetAttribute("ColorShift_Top", ColorShift_Top);
    end;

    local EnvironmentDiffuseScale = p202.EnvironmentDiffuseScale;

    if p204 or EnvironmentDiffuseScale ~= p203.EnvironmentDiffuseScale then
        Folder:SetAttribute("EnvironmentDiffuseScale", EnvironmentDiffuseScale);
    end;

    local EnvironmentSpecularScale = p202.EnvironmentSpecularScale;

    if p204 or EnvironmentSpecularScale ~= p203.EnvironmentSpecularScale then
        Folder:SetAttribute("EnvironmentSpecularScale", EnvironmentSpecularScale);
    end;

    local OutdoorAmbient = p202.OutdoorAmbient;

    if p204 or OutdoorAmbient ~= p203.OutdoorAmbient then
        Folder:SetAttribute("OutdoorAmbient", OutdoorAmbient);
    end;

    local ShadowSoftness = p202.ShadowSoftness;

    if p204 or ShadowSoftness ~= p203.ShadowSoftness then
        Folder:SetAttribute("ShadowSoftness", ShadowSoftness);
    end;

    local ClockTime = p202.ClockTime;

    if p204 or ClockTime ~= p203.ClockTime then
        Folder:SetAttribute("ClockTime", ClockTime);
    end;

    local GeographicLatitude = p202.GeographicLatitude;

    if p204 or GeographicLatitude ~= p203.GeographicLatitude then
        Folder:SetAttribute("GeographicLatitude", GeographicLatitude);
    end;

    local ExposureCompensation = p202.ExposureCompensation;

    if p204 or ExposureCompensation ~= p203.ExposureCompensation then
        Folder:SetAttribute("ExposureCompensation", ExposureCompensation);
    end;

    local FogColor = p202.FogColor;

    if p204 or FogColor ~= p203.FogColor then
        Folder:SetAttribute("FogColor", FogColor);
    end;

    local FogEnd = p202.FogEnd;

    if p204 or FogEnd ~= p203.FogEnd then
        Folder:SetAttribute("FogEnd", FogEnd);
    end;

    local FogStart = p202.FogStart;

    if p204 or FogStart ~= p203.FogStart then
        Folder:SetAttribute("FogStart", FogStart);
    end;

    if p204 or not DeepEqualsUnsafe(p202.Atmosphere, p203.Atmosphere) then
        ApplyOptionalInstance(u65.ApplyAtmosphere, Folder, nil, "Atmosphere", p202.Atmosphere);
    end;

    if p204 or not DeepEqualsUnsafe(p202.Sky, p203.Sky) then
        ApplyOptionalInstance(u65.ApplySky, Folder, nil, "Sky", p202.Sky);
    end;

    if p204 or not DeepEqualsUnsafe(p202.Bloom, p203.Bloom) then
        ApplyOptionalInstance(u65.ApplyBloomEffect, Folder, "Bloom", "BloomEffect", p202.Bloom);
    end;

    if p204 or not DeepEqualsUnsafe(p202.ColorCorrection, p203.ColorCorrection) then
        ApplyOptionalInstance(u65.ApplyColorCorrectionEffect, Folder, "ColorCorrection", "ColorCorrectionEffect", p202.ColorCorrection);
    end;

    if p204 or not DeepEqualsUnsafe(p202.SunRays, p203.SunRays) then
        ApplyOptionalInstance(u65.ApplySunRaysEffect, Folder, "SunRays", "SunRaysEffect", p202.SunRays);
    end;

    if p204 or not DeepEqualsUnsafe(p202.DepthOfField, p203.DepthOfField) then
        ApplyOptionalInstance(u65.ApplyDepthOfFieldEffect, Folder, "DepthOfField", "DepthOfFieldEffect", p202.DepthOfField);
    end;

    if p204 or not DeepEqualsUnsafe(p202.Blur, p203.Blur) then
        ApplyOptionalInstance(u65.ApplyBlurEffect, Folder, "Blur", "BlurEffect", p202.Blur);
    end;

    if p204 or not DeepEqualsUnsafe(p202.Clouds, p203.Clouds) then
        ApplyOptionalInstance(u65.ApplyClouds, Folder, "Clouds", "Clouds", p202.Clouds);
    end;

    return Folder;
end;

return u65;