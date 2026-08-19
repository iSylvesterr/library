-- Decompiled with Potassium's decompiler.

local u1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local EffectLoadManager = require(ReplicatedStorage:WaitForChild("SharedModules"):WaitForChild("EffectLoadManager"));
local Frame = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RainbowEffect"):WaitForChild("Frame");
local Rainbow = SoundService:WaitForChild("MusicTracks"):WaitForChild("Rainbow");
local u2 = {
    Color3.fromRGB(255, 80, 80),
    Color3.fromRGB(255, 160, 50),
    Color3.fromRGB(255, 240, 60),
    Color3.fromRGB(80, 220, 80),
    Color3.fromRGB(60, 160, 255),
    Color3.fromRGB(100, 60, 220),
    Color3.fromRGB(180, 80, 220)
};
local u3 = false;
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = 1;
local u8 = 0;
local u9 = 1;
local u10 = 0;
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
ColorCorrectionEffect.Name = "RainbowEffect";
ColorCorrectionEffect.Brightness = 0;
ColorCorrectionEffect.Saturation = 0;
ColorCorrectionEffect.Parent = Lighting;
Frame.BackgroundTransparency = 1;

local function lerpColor(p11, p12, p13) -- Line: 75
    return Color3.new(p11.R + (p12.R - p11.R) * p13, p11.G + (p12.G - p11.G) * p13, p11.B + (p12.B - p11.B) * p13);
end;

local u14 = {};

local function refreshSoundCache() -- Line: 88
    -- upvalues: u14 (copy), Rainbow (copy)
    table.clear(u14);

    for _, child in Rainbow:GetChildren() do
        if child:IsA("Sound") then
            table.insert(u14, child);
        end;
    end;
end;

Rainbow.ChildAdded:Connect(refreshSoundCache);
Rainbow.ChildRemoved:Connect(refreshSoundCache);
refreshSoundCache();

local function getMaxLoudness() -- Line: 101
    -- upvalues: u14 (copy)
    local v15 = 0;

    for _, v in u14 do
        if v.IsPlaying then
            local v16 = v.PlaybackLoudness / 1000;

            if v15 < v16 then
                v15 = v16;
            end;
        end;
    end;

    return v15;
end;

local function saveLighting() -- Line: 118
    -- upvalues: u4 (copy), Lighting (copy)
    u4.Brightness = Lighting.Brightness;
    u4.Ambient = Lighting.Ambient;
    u4.OutdoorAmbient = Lighting.OutdoorAmbient;
    u4.ExposureCompensation = Lighting.ExposureCompensation;
end;

local function applyRainbowLighting() -- Line: 125
    -- upvalues: TweenService (copy), Lighting (copy), u4 (copy), ColorCorrectionEffect (copy)
    local v17 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v17, {
        Brightness = u4.Brightness + 0.3,
        ExposureCompensation = u4.ExposureCompensation + 0.15
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v17, {
        Brightness = 0.12,
        Saturation = 0.15
    }):Play();
end;

local function restoreLighting() -- Line: 137
    -- upvalues: TweenService (copy), Lighting (copy), u4 (copy), ColorCorrectionEffect (copy)
    local v18 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v18, {
        Brightness = u4.Brightness,
        ExposureCompensation = u4.ExposureCompensation
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v18, {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
    }):Play();
end;

local function spawnRainbowModel() -- Line: 154
    -- upvalues: ReplicatedStorage (copy), u5 (ref), TweenService (copy)
    local Rainbow2 = ReplicatedStorage.Assets:FindFirstChild("Rainbow");

    if not Rainbow2 then
        warn("[Rainbow] Rainbow model not found in ReplicatedStorage.Assets");

        return;
    end;

    u5 = Rainbow2:Clone();
    u5.Name = "ActiveRainbow";
    u5.Parent = workspace;
    local v19 = {};

    for _, descendant in u5:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("OGTransparency") == nil then
                descendant:SetAttribute("OGTransparency", descendant.Transparency);
            end;

            descendant.Transparency = 1;
            table.insert(v19, descendant);
        end;
    end;

    local u20 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

    for i, v in v19 do
        task.delay(i * 0.05, function() -- Line: 178
            -- upvalues: TweenService (ref), v (copy), u20 (copy)
            TweenService:Create(v, u20, {
                Transparency = v:GetAttribute("OGTransparency")
            }):Play();
        end);
    end;
end;

local function removeRainbowModel() -- Line: 184
    -- upvalues: u5 (ref), TweenService (copy)
    if not u5 then
        return;
    end;

    local v21 = {};

    for _, descendant in u5:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v21, descendant);
        end;
    end;

    local v22 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In);

    for _, v in v21 do
        TweenService:Create(v, v22, {
            Transparency = 1
        }):Play();
    end;

    local u23 = u5;
    task.delay(2.1, function() -- Line: 200
        -- upvalues: u23 (copy)
        if u23 and u23.Parent then
            u23:Destroy();
        end;
    end);
    u5 = nil;
end;

local function tickRainbow(p24) -- Line: 214
    -- upvalues: u8 (ref), u2 (copy), u7 (ref), Frame (copy), u14 (copy), u9 (ref)
    u8 = u8 + p24;
    local v25 = math.clamp(u8 / 2, 0, 1);
    local v26 = u2[u7];
    local v27 = u7 % #u2 + 1;
    local v28 = u2[v27];
    Frame.BackgroundColor3 = Color3.new(v26.R + (v28.R - v26.R) * v25, v26.G + (v28.G - v26.G) * v25, v26.B + (v28.B - v26.B) * v25);

    if v25 >= 1 then
        u7 = v27;
        u8 = 0;
    end;

    local v29 = 0;

    for _, v in u14 do
        if v.IsPlaying then
            local v30 = v.PlaybackLoudness / 1000;

            if v29 < v30 then
                v29 = v30;
            end;
        end;
    end;

    if v29 >= 0.12 then
        u9 = math.clamp((v29 - 0.12) / 0.88, 0, 1) * -0.7 + 0.95;
    else
        u9 = 0.95;
    end;

    local BackgroundTransparency = Frame.BackgroundTransparency;
    Frame.BackgroundTransparency = BackgroundTransparency + (u9 - BackgroundTransparency) * math.min(1, p24 * 8);
end;

local function startUpdateLoop() -- Line: 244
    -- upvalues: u6 (ref), u7 (ref), u8 (ref), u10 (ref), u9 (ref), RunService (copy), EffectLoadManager (copy), tickRainbow (copy)
    if u6 then
        return;
    end;

    u7 = 1;
    u8 = 0;
    u10 = 0;
    u9 = 0.95;
    u6 = RunService.RenderStepped:Connect(function(p31) -- Line: 252
        -- upvalues: u10 (ref), EffectLoadManager (ref), tickRainbow (ref)
        u10 = u10 + p31;

        if u10 < EffectLoadManager.GetTickInterval() then
            return;
        end;

        debug.profilebegin("Controllers/WeatherController/Rainbow/Tick");
        tickRainbow(u10);
        u10 = 0;
        debug.profileend();
    end);
end;

local function stopUpdateLoop() -- Line: 267
    -- upvalues: u6 (ref)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;
end;

local function fadeInFrame() -- Line: 278
    -- upvalues: Frame (copy), u6 (ref), u7 (ref), u8 (ref), u10 (ref), u9 (ref), RunService (copy), EffectLoadManager (copy), tickRainbow (copy)
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;

    if u6 then
        return;
    end;

    u7 = 1;
    u8 = 0;
    u10 = 0;
    u9 = 0.95;
    u6 = RunService.RenderStepped:Connect(function(p32) -- Line: 252
        -- upvalues: u10 (ref), EffectLoadManager (ref), tickRainbow (ref)
        u10 = u10 + p32;

        if u10 < EffectLoadManager.GetTickInterval() then
            return;
        end;

        debug.profilebegin("Controllers/WeatherController/Rainbow/Tick");
        tickRainbow(u10);
        u10 = 0;
        debug.profileend();
    end);
end;

local function fadeOutFrame() -- Line: 285
    -- upvalues: u6 (ref), TweenService (copy), Frame (copy)
    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    TweenService:Create(Frame, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    }):Play();
end;

function u1.StartWeather() -- Line: 295
    -- upvalues: u3 (ref), EffectLoadManager (copy), NotificationController (copy), u4 (copy), Lighting (copy), applyRainbowLighting (copy), spawnRainbowModel (copy), Frame (copy), u6 (ref), u7 (ref), u8 (ref), u10 (ref), u9 (ref), RunService (copy), tickRainbow (copy)
    if u3 then
        return;
    end;

    u3 = true;
    EffectLoadManager.Register();
    NotificationController:CreateNotification("You received a rainbow magic carpet!🌈");
    u4.Brightness = Lighting.Brightness;
    u4.Ambient = Lighting.Ambient;
    u4.OutdoorAmbient = Lighting.OutdoorAmbient;
    u4.ExposureCompensation = Lighting.ExposureCompensation;
    applyRainbowLighting();
    spawnRainbowModel();
    Frame.BackgroundTransparency = 1;
    Frame.Visible = true;

    if u6 then
        return;
    end;

    u7 = 1;
    u8 = 0;
    u10 = 0;
    u9 = 0.95;
    u6 = RunService.RenderStepped:Connect(function(p33) -- Line: 252
        -- upvalues: u10 (ref), EffectLoadManager (ref), tickRainbow (ref)
        u10 = u10 + p33;

        if u10 < EffectLoadManager.GetTickInterval() then
            return;
        end;

        debug.profilebegin("Controllers/WeatherController/Rainbow/Tick");
        tickRainbow(u10);
        u10 = 0;
        debug.profileend();
    end);
end;

function u1.EndWeather() -- Line: 306
    -- upvalues: u3 (ref), EffectLoadManager (copy), restoreLighting (copy), removeRainbowModel (copy), fadeOutFrame (copy)
    if not u3 then
        return;
    end;

    u3 = false;
    EffectLoadManager.Unregister();
    restoreLighting();
    removeRainbowModel();
    fadeOutFrame();
end;

Networking.WeatherEffects.RainbowStart.OnClientEvent:Connect(function() -- Line: 320
    -- upvalues: u1 (copy)
    u1.StartWeather();
end);
Networking.WeatherEffects.RainbowEnd.OnClientEvent:Connect(function() -- Line: 324
    -- upvalues: u1 (copy)
    u1.EndWeather();
end);

return u1;