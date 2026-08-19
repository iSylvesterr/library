-- Decompiled with Potassium's decompiler.

local u1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
require(game.ReplicatedStorage.ClientModules.Skybox);
local _ = game.ReplicatedStorage.Assets.Skybox.StarfallSkybox;
require(ReplicatedStorage.SharedModules.Networking);
local Frame = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RainbowEffect"):WaitForChild("Frame");
local Rainbow = SoundService:WaitForChild("MusicTracks"):WaitForChild("Rainbow");
local _ = {
    Color3.fromRGB(255, 80, 80),
    Color3.fromRGB(255, 160, 50),
    Color3.fromRGB(255, 240, 60),
    Color3.fromRGB(80, 220, 80),
    Color3.fromRGB(60, 160, 255),
    Color3.fromRGB(100, 60, 220),
    Color3.fromRGB(180, 80, 220)
};
local u2 = false;
local u3 = {};
local u4 = nil;
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
ColorCorrectionEffect.Name = "StarEffect";
ColorCorrectionEffect.Brightness = 0;
ColorCorrectionEffect.Saturation = 0;
ColorCorrectionEffect.Parent = Lighting;
Frame.BackgroundTransparency = 1;

local function lerpColor(p5, p6, p7) -- Line: 73
    return Color3.new(p5.R + (p6.R - p5.R) * p7, p5.G + (p6.G - p5.G) * p7, p5.B + (p6.B - p5.B) * p7);
end;

local function getMaxLoudness() -- Line: 81
    -- upvalues: Rainbow (copy)
    local v8 = 0;

    for _, child in Rainbow:GetChildren() do
        if child:IsA("Sound") and child.IsPlaying then
            local v9 = child.PlaybackLoudness / 1000;

            if v8 < v9 then
                v8 = v9;
            end;
        end;
    end;

    return v8;
end;

local function saveLighting() -- Line: 98
    -- upvalues: u3 (copy), Lighting (copy)
    u3.Brightness = Lighting.Brightness;
    u3.Ambient = Lighting.Ambient;
    u3.OutdoorAmbient = Lighting.OutdoorAmbient;
    u3.ExposureCompensation = Lighting.ExposureCompensation;
    u3.ClockTime = Lighting.ClockTime;
end;

local function applyLighting() -- Line: 106
    workspace:SetAttribute("TimeFrozen", true);
end;

local function restoreLighting() -- Line: 113
    -- upvalues: TweenService (copy), Lighting (copy), u3 (copy), ColorCorrectionEffect (copy)
    workspace:SetAttribute("TimeFrozen", nil);
    local v10 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v10, {
        Brightness = u3.Brightness,
        ExposureCompensation = u3.ExposureCompensation,
        Ambient = u3.Ambient,
        OutdoorAmbient = u3.OutdoorAmbient,
        ClockTime = u3.ClockTime
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v10, {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    TweenService:Create(game.Workspace.Terrain.Clouds, v10, {
        Cover = 0.5,
        Density = 0,
        Color = Color3.fromRGB(255, 255, 255)
    }):Play();
end;

local function startUpdateLoop() -- Line: 144
    -- upvalues: u4 (ref)
    if u4 then
    end;
end;

local function stopUpdateLoop() -- Line: 150
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function fadeInFrame() -- Line: 161
    -- upvalues: Frame (copy), u4 (ref)
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;

    if u4 then
    end;
end;

local function fadeOutFrame() -- Line: 168
    -- upvalues: u4 (ref), TweenService (copy), Frame (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    TweenService:Create(Frame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play();
end;

local Effects = require(script.Effects);
local SunburstModel = game.ReplicatedStorage.Assets.SunburstModel;
local u11 = nil;

function u1.StartWeather() -- Line: 183
    -- upvalues: u2 (ref), u11 (ref), SunburstModel (copy), Effects (copy), u3 (copy), Lighting (copy), Frame (copy), u4 (ref)
    if u2 then
        return;
    end;

    u2 = true;
    u11 = SunburstModel:Clone();
    u11.Parent = workspace;
    Effects.Start(u11);
    u3.Brightness = Lighting.Brightness;
    u3.Ambient = Lighting.Ambient;
    u3.OutdoorAmbient = Lighting.OutdoorAmbient;
    u3.ExposureCompensation = Lighting.ExposureCompensation;
    u3.ClockTime = Lighting.ClockTime;
    workspace:SetAttribute("TimeFrozen", true);
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;

    if u4 then
    end;
end;

function u1.EndWeather() -- Line: 197
    -- upvalues: u2 (ref), Effects (copy), u11 (ref), restoreLighting (copy), fadeOutFrame (copy)
    if not u2 then
        return;
    end;

    u2 = false;
    Effects.End();
    u11 = nil;
    restoreLighting();
    fadeOutFrame();
end;

workspace:GetAttributeChangedSignal("SunburstEvent"):Connect(function() -- Line: 210
    -- upvalues: u1 (copy)
    if workspace:GetAttribute("SunburstEvent") then
        u1.StartWeather();

        return;
    end;

    u1.EndWeather();
end);
task.spawn(function() -- Line: 220
    -- upvalues: u1 (copy)
    if workspace:GetAttribute("SunburstEvent") then
        u1.StartWeather();

        return;
    end;

    u1.EndWeather();
end);

return u1;