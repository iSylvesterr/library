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
local StarfallSkybox = game.ReplicatedStorage.Assets.Skybox.StarfallSkybox;
local Networking = require(ReplicatedStorage.SharedModules.Networking);
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
    -- upvalues: TweenService (copy), Lighting (copy), ColorCorrectionEffect (copy), Skybox (copy), StarfallSkybox (copy)
    workspace:SetAttribute("TimeFrozen", true);
    TweenService:Create(Lighting, TweenInfo.new(2), {
        ClockTime = 27
    }):Play();
    task.wait(2);
    local v10 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v10, {
        Brightness = 1,
        ExposureCompensation = 0.7,
        EnvironmentDiffuseScale = 1,
        EnvironmentSpecularScale = 1,
        ClockTime = 9.5,
        Ambient = Color3.fromRGB(143, 137, 211),
        OutdoorAmbient = Color3.fromRGB(220, 170, 255)
    }):Play();
    TweenService:Create(game.Workspace.Terrain.Clouds, v10, {
        Cover = 0.56,
        Density = 1,
        Color = Color3.fromRGB(89, 89, 255)
    }):Play();
    local ActiveNightAtmosphere = game.Lighting:FindFirstChild("ActiveNightAtmosphere");

    if not ActiveNightAtmosphere then
        ActiveNightAtmosphere = game.ReplicatedStorage.Assets.NightAtmosphere:Clone();
        ActiveNightAtmosphere.Parent = game.Lighting;
        ActiveNightAtmosphere.Name = "StarSphere";
    end;

    TweenService:Create(ActiveNightAtmosphere, TweenInfo.new(3), {
        Density = 0.3,
        Haze = 1,
        Color = Color3.fromRGB(0, 179, 199)
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v10, {
        Brightness = 0.05,
        Contrast = 0.1,
        Saturation = 0.1,
        TintColor = Color3.fromRGB(199, 214, 255)
    }):Play();
    Skybox.SetOrder(StarfallSkybox, 3);
end;

local function restoreLighting() -- Line: 150
    -- upvalues: TweenService (copy), Lighting (copy), u3 (copy), ColorCorrectionEffect (copy), Skybox (copy), StarfallSkybox (copy)
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

    Skybox.SetOrder(StarfallSkybox, 0);
end;

local function startUpdateLoop() -- Line: 182
    -- upvalues: u4 (ref)
    if u4 then
    end;
end;

local function stopUpdateLoop() -- Line: 188
    -- upvalues: u4 (ref)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;
end;

local function fadeInFrame() -- Line: 199
    -- upvalues: Frame (copy), u4 (ref)
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;

    if u4 then
    end;
end;

local function fadeOutFrame() -- Line: 206
    -- upvalues: u4 (ref), TweenService (copy), Frame (copy)
    if u4 then
        u4:Disconnect();
        u4 = nil;
    end;

    TweenService:Create(Frame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play();
end;

Networking.WeatherEffects.ShootingStar.OnClientEvent:Connect(function(p12) -- Line: 216
    -- upvalues: ReplicatedStorage (copy)
    local v13 = ReplicatedStorage.Assets.ShootingStarMeteor:Clone();
    local v14 = CFrame.new(p12) * CFrame.new(0, 200, 250);
    v13.CFrame = v14;
    v13.Parent = workspace;
    v13.Travel:Play();
    local v15 = 0;

    while v15 < 4 do
        v15 = v15 + task.wait();
        local v16 = game.TweenService:GetValue(v15 / 4, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        v13:PivotTo(v14:Lerp(CFrame.new(p12), v16));
        v13.Attachment.BillboardGui.ImageLabel.Rotation = tick() * 90;
    end;

    v13.Poof:Play();
    v13.Attachment.BillboardGui.Enabled = false;

    for _, child in v13.Attachment.Attachment:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Emit(child:GetAttribute("EmitCount") or 5);
        elseif child:IsA("PointLight") then
            game.TweenService:Create(child, TweenInfo.new(3), {
                Range = 0
            }):Play();
        end;
    end;

    game.Debris:AddItem(v13, 4);
end);
local u17 = game.ReplicatedStorage.Assets.StarfallModel:Clone();

function u1.StartWeather() -- Line: 259
    -- upvalues: u2 (ref), u17 (copy), u3 (copy), Lighting (copy), applyLighting (copy), Frame (copy), u4 (ref)
    if u2 then
        return;
    end;

    u2 = true;

    for _, descendant in u17:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        end;
    end;

    u17.Parent = workspace;
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

function u1.EndWeather() -- Line: 275
    -- upvalues: u2 (ref), u17 (copy), restoreLighting (copy), fadeOutFrame (copy)
    if not u2 then
        return;
    end;

    u2 = false;

    for _, descendant in u17:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
            descendant:Clear();
        end;
    end;

    u17.Parent = script;
    restoreLighting();
    fadeOutFrame();
end;

workspace:GetAttributeChangedSignal("ShootingStarEvent"):Connect(function() -- Line: 291
    -- upvalues: u1 (copy)
    if workspace:GetAttribute("ShootingStarEvent") then
        u1.StartWeather();

        return;
    end;

    u1.EndWeather();
end);

return u1;