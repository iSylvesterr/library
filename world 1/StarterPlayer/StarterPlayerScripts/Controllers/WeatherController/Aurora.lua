-- Decompiled with Potassium's decompiler.

local u1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
local Aurora = game.ReplicatedStorage.Assets.Skybox.Aurora;
require(ReplicatedStorage.SharedModules.Networking);
local Frame = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RainbowEffect"):WaitForChild("Frame");
local Aurora2 = SoundService:WaitForChild("MusicTracks"):WaitForChild("Aurora");
local u2 = false;
local u3 = {};
local u4 = nil;
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
ColorCorrectionEffect.Name = "StarEffect";
ColorCorrectionEffect.Brightness = 0;
ColorCorrectionEffect.Saturation = 0;
ColorCorrectionEffect.Parent = Lighting;
Frame.BackgroundTransparency = 1;

local function lerpColor(p5, p6, p7) -- Line: 64
    return Color3.new(p5.R + (p6.R - p5.R) * p7, p5.G + (p6.G - p5.G) * p7, p5.B + (p6.B - p5.B) * p7);
end;

local function getMaxLoudness() -- Line: 72
    -- upvalues: Aurora2 (copy)
    local v8 = 0;

    for _, child in Aurora2:GetChildren() do
        if child:IsA("Sound") and child.IsPlaying then
            local v9 = child.PlaybackLoudness / 1000;

            if v8 < v9 then
                v8 = v9;
            end;
        end;
    end;

    return v8;
end;

local function saveLighting() -- Line: 94
    -- upvalues: u3 (copy), Lighting (copy)
    u3.Brightness = Lighting.Brightness;
    u3.Ambient = Lighting.Ambient;
    u3.OutdoorAmbient = Lighting.OutdoorAmbient;
    u3.ExposureCompensation = Lighting.ExposureCompensation;
    u3.ClockTime = Lighting.ClockTime;
end;

local function applyLighting() -- Line: 102
    -- upvalues: TweenService (copy), Lighting (copy), ColorCorrectionEffect (copy), Skybox (copy), Aurora (copy)
    workspace:SetAttribute("TimeFrozen", true);
    TweenService:Create(Lighting, TweenInfo.new(2), {
        ClockTime = 27
    }):Play();
    task.wait(2);
    local v10 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v10, {
        Brightness = 2,
        ExposureCompensation = -1,
        EnvironmentDiffuseScale = 1,
        EnvironmentSpecularScale = 1,
        ClockTime = 9.5,
        Ambient = Color3.fromRGB(125, 149, 215),
        OutdoorAmbient = Color3.fromRGB(251, 196, 247)
    }):Play();
    TweenService:Create(game.Workspace.Terrain.Clouds, v10, {
        Cover = 0.6,
        Density = 0.1,
        Color = Color3.fromRGB(37, 246, 247)
    }):Play();
    local ActiveNightAtmosphere = game.Lighting:FindFirstChild("ActiveNightAtmosphere");

    if not ActiveNightAtmosphere then
        ActiveNightAtmosphere = game.ReplicatedStorage.Assets.NightAtmosphere:Clone();
        ActiveNightAtmosphere.Parent = game.Lighting;
        ActiveNightAtmosphere.Name = "StarSphere";
    end;

    TweenService:Create(ActiveNightAtmosphere, TweenInfo.new(3), {
        Density = 0.3,
        Offset = 0.25,
        Haze = 0,
        Color = Color3.fromRGB(199, 199, 199),
        Decay = Color3.fromRGB(106, 112, 125)
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v10, {
        Brightness = 0.05,
        Contrast = 0.1,
        Saturation = 0.1,
        TintColor = Color3.fromRGB(199, 214, 255)
    }):Play();
    Skybox.SetOrder(Aurora, 3);
end;

local function restoreLighting() -- Line: 145
    -- upvalues: TweenService (copy), Lighting (copy), u3 (copy), ColorCorrectionEffect (copy), Skybox (copy), Aurora (copy)
    workspace:SetAttribute("TimeFrozen", nil);
    local v11 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v11, {
        EnvironmentDiffuseScale = 0,
        EnvironmentSpecularScale = 0,
        Brightness = u3.Brightness,
        ExposureCompensation = u3.ExposureCompensation,
        Ambient = u3.Ambient,
        OutdoorAmbient = u3.OutdoorAmbient,
        ClockTime = u3.ClockTime
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v11, {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    TweenService:Create(game.Workspace.Terrain.Clouds, v11, {
        Cover = 0,
        Density = 0,
        Color = Color3.fromRGB(255, 255, 255)
    }):Play();

    if game.Lighting:FindFirstChild("StarSphere") then
        game.Lighting:FindFirstChild("StarSphere"):Destroy();
    end;

    Skybox.SetOrder(Aurora, 0);
end;

local function startUpdateLoop() -- Line: 176
    -- upvalues: u4 (ref)
    if u4 then
    end;
end;

local function stopUpdateLoop() -- Line: 182
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function fadeInFrame() -- Line: 193
    -- upvalues: Frame (copy), u4 (ref)
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;

    if u4 then
    end;
end;

local function fadeOutFrame() -- Line: 200
    -- upvalues: u4 (ref), TweenService (copy), Frame (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    TweenService:Create(Frame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play();
end;

local u12 = game.ReplicatedStorage.Assets.AuroraEffects:Clone();

function u1.StartWeather() -- Line: 213
    -- upvalues: u2 (ref), u12 (copy), u3 (copy), Lighting (copy), applyLighting (copy), Frame (copy), u4 (ref)
    if u2 then
        return;
    end;

    u2 = true;

    for _, descendant in u12:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        end;
    end;

    u12.Parent = workspace;
    u3.Brightness = Lighting.Brightness;
    u3.Ambient = Lighting.Ambient;
    u3.OutdoorAmbient = Lighting.OutdoorAmbient;
    u3.ExposureCompensation = Lighting.ExposureCompensation;
    u3.ClockTime = Lighting.ClockTime;
    applyLighting();
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;

    if u4 then
    end;
end;

function u1.EndWeather() -- Line: 229
    -- upvalues: u2 (ref), u12 (copy), restoreLighting (copy), fadeOutFrame (copy)
    if not u2 then
        return;
    end;

    u2 = false;

    for _, descendant in u12:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
            descendant:Clear();
        end;
    end;

    u12.Parent = script;
    restoreLighting();
    fadeOutFrame();
end;

workspace:GetAttributeChangedSignal("Aurora"):Connect(function() -- Line: 245
    -- upvalues: u1 (copy)
    print("Did i load?");

    if workspace:GetAttribute("Aurora") then
        u1.StartWeather();

        return;
    end;

    u1.EndWeather();
end);

return u1;