-- Decompiled with Potassium's decompiler.

local Cloud = require(script.Cloud);
local Atmosphere = require(script.Atmosphere);
local Bloom = require(script.Bloom);
local Blur = require(script.Blur);
local ColorCorrection = require(script.ColorCorrection);
local Sky = require(script.Sky);
local DepthOfField = require(script.DepthOfField);
local SunRays = require(script.SunRays);
local Lighting = require(script.Lighting);
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 59
    -- upvalues: u1 (copy), Lighting (copy), Cloud (copy), Atmosphere (copy), Sky (copy), ColorCorrection (copy), Bloom (copy), DepthOfField (copy), Blur (copy), SunRays (copy)
    local v2 = setmetatable({}, u1);
    v2.Lighting = Lighting.new();
    v2.Cloud = Cloud.new();
    v2.Atmosphere = Atmosphere.new();
    v2.Sky = Sky.new();
    v2.ColorCorrection = ColorCorrection.new();
    v2.Bloom = Bloom.new();
    v2.DepthOfField = DepthOfField.new();
    v2.Blur = Blur.new();
    v2.SunRays = SunRays.new();

    return v2;
end;

function u1.changeNewLighting(p3, p4, p5) -- Line: 80
    p3.Lighting:setLightingParams(p4, p5);
    local v6 = p4:FindFirstChildOfClass("Clouds");

    if v6 then
        p3.Cloud:show();
        p3.Cloud:setCloudParams(v6, p5);
    else
        p3.Cloud:hide();
    end;

    local v7 = p4:FindFirstChildOfClass("Atmosphere");

    if v7 then
        p3.Atmosphere:show();
        p3.Atmosphere:setAtmosphereParams(v7, p5);
    else
        p3.Atmosphere:hide();
    end;

    local v8 = p4:FindFirstChildOfClass("Sky");

    if v8 then
        p3.Sky:show();
        p3.Sky:setSkyParams(v8, p5);
    else
        p3.Sky:hide();
    end;

    local v9 = p4:FindFirstChildOfClass("ColorCorrectionEffect");

    if v9 then
        p3.ColorCorrection:show();
        p3.ColorCorrection:setColorCorrectionParams(v9, p5);
    else
        p3.ColorCorrection:hide();
    end;

    local v10 = p4:FindFirstChildOfClass("BloomEffect");

    if v10 then
        p3.Bloom:show();
        p3.Bloom:setBloomParams(v10, p5);
    else
        p3.Bloom:hide();
    end;

    local v11 = p4:FindFirstChildOfClass("BlurEffect");

    if v11 then
        p3.Blur:show();
        p3.Blur:setBlurParams(v11, p5);
    else
        p3.Blur:hide();
    end;

    local v12 = p4:FindFirstChildOfClass("SunRaysEffect");

    if v12 then
        p3.SunRays:show();
        p3.SunRays:setSunRaysParams(v12, p5);
    else
        p3.SunRays:hide();
    end;

    local v13 = p4:FindFirstChildOfClass("DepthOfFieldEffect");

    if not v13 then
        p3.DepthOfField:hide();

        return;
    end;

    p3.DepthOfField:show();
    p3.DepthOfField:setDepthOfFieldParams(v13, p5);
end;

function u1.setClockTime(p14, p15, p16) -- Line: 155
    p14.Lighting:setClockTime(p15, p16);
end;

local u41 = {
    ColorCorrectionEffect = function(p17, p18, p19) -- Line: 162, Name: ColorCorrectionEffect
        p17.ColorCorrection:show();
        p17.ColorCorrection:setColorCorrectionParams(p18, p19);
    end,

    BloomEffect = function(p20, p21, p22) -- Line: 166, Name: BloomEffect
        p20.Bloom:show();
        p20.Bloom:setBloomParams(p21, p22);
    end,

    BlurEffect = function(p23, p24, p25) -- Line: 170, Name: BlurEffect
        p23.Blur:show();
        p23.Blur:setBlurParams(p24, p25);
    end,

    SunRaysEffect = function(p26, p27, p28) -- Line: 174, Name: SunRaysEffect
        p26.SunRays:show();
        p26.SunRays:setSunRaysParams(p27, p28);
    end,

    DepthOfFieldEffect = function(p29, p30, p31) -- Line: 178, Name: DepthOfFieldEffect
        p29.DepthOfField:show();
        p29.DepthOfField:setDepthOfFieldParams(p30, p31);
    end,

    Clouds = function(p32, p33, p34) -- Line: 182, Name: Clouds
        p32.Cloud:show();
        p32.Cloud:setCloudParams(p33, p34);
    end,

    Atmosphere = function(p35, p36, p37) -- Line: 186, Name: Atmosphere
        p35.Atmosphere:show();
        p35.Atmosphere:setAtmosphereParams(p36, p37);
    end,

    Sky = function(p38, p39, p40) -- Line: 190, Name: Sky
        p38.Sky:show();
        p38.Sky:setSkyParams(p39, p40);
    end
};

function u1.applyEffectFromInstance(p42, p43, p44) -- Line: 203
    -- upvalues: u41 (copy)
    if not p43 then
        return;
    end;

    local v45 = u41[p43.ClassName];

    if v45 then
        v45(p42, p43, p44);
    end;
end;

function u1.destroy(p46) -- Line: 219
    p46.Lighting:destroy();
    p46.Cloud:destroy();
    p46.Atmosphere:destroy();
    p46.Sky:destroy();
    p46.ColorCorrection:destroy();
    p46.Bloom:destroy();
    p46.DepthOfField:destroy();
    p46.Blur:destroy();
    p46.SunRays:destroy();
end;

return u1;