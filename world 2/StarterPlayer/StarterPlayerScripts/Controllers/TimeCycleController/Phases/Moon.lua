-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Debris = game:GetService("Debris");
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local WerewolfNightData = require(ReplicatedStorage.SharedModules.WerewolfNightData);
local LocalPlayer = game.Players.LocalPlayer;
local u2 = {
    Brightness = 3,
    ClockTime = 3.1,
    Ambient = Color3.new(0.823529, 0.823529, 0.823529),
    ColorShift_Bottom = Color3.new(0.160784, 0.196078, 0.670588),
    ColorShift_Top = Color3.new(0.603922, 0.8, 0.980392),
    OutdoorAmbient = Color3.new(0.34902, 0.419608, 0.4)
};
local u3 = nil;
local u4 = false;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = game.SoundService.SFX["Werewolf Howl"];

local function getTargetDensity() -- Line: 37
    -- upvalues: LocalPlayer (copy)
    local v12 = LocalPlayer:GetAttribute("IsInOwnGarden") and 0.4 or 0.56;
    local FogDensityClear = LocalPlayer:FindFirstChild("FogDensityClear");
    local v13 = FogDensityClear and FogDensityClear.Value or 0;
    local OwlNightVisionMult = LocalPlayer:FindFirstChild("OwlNightVisionMult");
    local v14 = OwlNightVisionMult and OwlNightVisionMult.Value or 1;

    return math.clamp((v12 - v13) / (v14 <= 0 and 1 or v14), 0, 1);
end;

local function tweenAtmosphereDensity(p15, p16, u17) -- Line: 56
    -- upvalues: u5 (ref), u10 (ref), TweenService (copy)
    if not u5 then
        return;
    end;

    if u10 then
        u10:Cancel();
        u10:Destroy();
        u10 = nil;
    end;

    local u18 = TweenService:Create(u5, TweenInfo.new(p16, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Density = p15
    });
    u10 = u18;

    if u17 then
        u18.Completed:Once(function(p19) -- Line: 71
            -- upvalues: u10 (ref), u18 (copy), u17 (copy)
            if u10 == u18 then
                u10 = nil;
            end;

            u18:Destroy();
            u17();
        end);
    else
        u18.Completed:Once(function() -- Line: 79
            -- upvalues: u10 (ref), u18 (copy)
            if u10 == u18 then
                u10 = nil;
            end;

            u18:Destroy();
        end);
    end;

    u18:Play();
end;

local function isCutscenePlaying() -- Line: 90
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true;
end;

local function refreshDensity() -- Line: 94
    -- upvalues: u4 (ref), u5 (ref), LocalPlayer (copy), tweenAtmosphereDensity (copy), getTargetDensity (copy)
    if not u4 then
        return;
    end;

    if not u5 then
        return;
    end;

    if LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true then
        tweenAtmosphereDensity(0, 0.5);

        return;
    end;

    tweenAtmosphereDensity(getTargetDensity(), 1.5);
end;

local function applyAtmosphere() -- Line: 107
    -- upvalues: ReplicatedStorage (copy), u5 (ref), Lighting (copy), LocalPlayer (copy), tweenAtmosphereDensity (copy), getTargetDensity (copy)
    local NightAtmosphere = ReplicatedStorage.Assets:FindFirstChild("NightAtmosphere");

    if not NightAtmosphere then
        return;
    end;

    if not u5 then
        u5 = NightAtmosphere:Clone();
        u5.Name = "ActiveNightAtmosphere";
        u5.Density = 0;
        u5.Parent = Lighting;
    end;

    if LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true then
        tweenAtmosphereDensity(0, 0.5);

        return;
    end;

    tweenAtmosphereDensity(getTargetDensity(), 1.5);
end;

local function removeAtmosphere() -- Line: 131
    -- upvalues: u5 (ref), tweenAtmosphereDensity (copy)
    if not u5 then
        return;
    end;

    tweenAtmosphereDensity(0, 2, function() -- Line: 133
        -- upvalues: u5 (ref)
        if u5 then
            u5:Destroy();
            u5 = nil;
        end;
    end);
end;

TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);

local function spawnNightModel() -- Line: 143
    -- upvalues: ReplicatedStorage (copy), u3 (ref), TweenService (copy), Debris (copy)
    local Night = ReplicatedStorage.Assets:FindFirstChild("Night");

    if not Night then
        return;
    end;

    u3 = Night:Clone();
    u3.Name = "ActiveNight";
    u3.Parent = workspace;
    local v20 = {};

    for _, descendant in u3:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("OGTransparency") == nil then
                descendant:SetAttribute("OGTransparency", descendant.Transparency);
            end;

            descendant.Transparency = 1;
            table.insert(v20, descendant);
        end;
    end;

    local u21 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

    for i, v in v20 do
        task.delay(i * 0.05, function() -- Line: 166
            -- upvalues: TweenService (ref), v (copy), u21 (copy), Debris (ref)
            local v22 = TweenService:Create(v, u21, {
                Transparency = v:GetAttribute("OGTransparency")
            });
            v22:Play();
            Debris:AddItem(v22, u21.Time);
        end);
    end;
end;

local function removeNightModel() -- Line: 175
    -- upvalues: u3 (ref), TweenService (copy), Debris (copy)
    if not u3 then
        return;
    end;

    local v23 = {};

    for _, descendant in u3:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v23, descendant);
        end;
    end;

    local v24 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In);

    for _, v in v23 do
        local v25 = TweenService:Create(v, v24, {
            Transparency = 1
        });
        v25:Play();
        Debris:AddItem(v25, v24.Time);
    end;

    local u26 = u3;
    task.delay(2.1, function() -- Line: 194
        -- upvalues: u26 (copy)
        if u26 and u26.Parent then
            u26:Destroy();
        end;
    end);
    u3 = nil;
end;

function v1.Start(p27, p28, p29) -- Line: 202
    -- upvalues: u4 (ref), WerewolfNightData (copy), u11 (copy), LightingController (copy), u2 (copy), spawnNightModel (copy), applyAtmosphere (copy), u6 (ref), LocalPlayer (copy), refreshDensity (copy), u7 (ref), u8 (ref), u9 (ref)
    u4 = true;

    if not WerewolfNightData.IsEnabled() then
        u11.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        u11.Playing = true;
        u11.TimePosition = 0;
    end;

    LightingController:TransitionTo(u2);
    spawnNightModel();
    applyAtmosphere();
    u6 = LocalPlayer:GetAttributeChangedSignal("IsInOwnGarden"):Connect(refreshDensity);
    local FogDensityClear = LocalPlayer:FindFirstChild("FogDensityClear");

    if FogDensityClear then
        u7 = FogDensityClear.Changed:Connect(refreshDensity);
    end;

    local OwlNightVisionMult = LocalPlayer:FindFirstChild("OwlNightVisionMult");

    if OwlNightVisionMult then
        u8 = OwlNightVisionMult.Changed:Connect(refreshDensity);
    end;

    u9 = LocalPlayer:GetAttributeChangedSignal("OfflineCutscenePlaying"):Connect(refreshDensity);
end;

function v1.End(p30) -- Line: 238
    -- upvalues: u4 (ref), u6 (ref), u7 (ref), u8 (ref), u9 (ref), removeNightModel (copy), u5 (ref), tweenAtmosphereDensity (copy)
    u4 = false;

    if u6 then
        u6:Disconnect();
        u6 = nil;
    end;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    if u8 then
        u8:Disconnect();
        u8 = nil;
    end;

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    removeNightModel();

    if not u5 then
        return;
    end;

    tweenAtmosphereDensity(0, 2, function() -- Line: 133
        -- upvalues: u5 (ref)
        if u5 then
            u5:Destroy();
            u5 = nil;
        end;
    end);
end;

return v1;