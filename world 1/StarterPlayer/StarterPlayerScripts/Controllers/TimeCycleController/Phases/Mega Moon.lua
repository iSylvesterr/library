-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Lighting = game:GetService("Lighting");
local Debris = game:GetService("Debris");
local RunService = game:GetService("RunService");
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local LocalPlayer = game.Players.LocalPlayer;
local u2 = {
    Brightness = 3,
    ClockTime = 3.1,
    Ambient = Color3.new(0.823529, 0.823529, 0.823529),
    ColorShift_Bottom = Color3.new(0.160784, 0.196078, 0.670588),
    ColorShift_Top = Color3.new(0.603922, 0.8, 0.980392),
    OutdoorAmbient = Color3.new(0.34902, 0.419608, 0.4)
};
local u3 = {
    Brightness = 3,
    ClockTime = 3.1,
    ExposureCompensation = 0.5,
    Ambient = Color3.fromRGB(210, 189, 209),
    ColorShift_Bottom = Color3.new(0.176471, 0.392157, 0.670588),
    ColorShift_Top = Color3.new(0.568627, 0.945098, 0.980392),
    OutdoorAmbient = Color3.new(0.34902, 0.419608, 0.4)
};
local u4 = nil;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = game.SoundService.SFX["Werewolf Howl"];

local function getTargetDensity() -- Line: 44
    -- upvalues: LocalPlayer (copy)
    local v10 = LocalPlayer:GetAttribute("IsInOwnGarden") and 0.4 or 0.56;
    local FogDensityClear = LocalPlayer:FindFirstChild("FogDensityClear");
    local v11 = FogDensityClear and FogDensityClear.Value or 0;
    local OwlNightVisionMult = LocalPlayer:FindFirstChild("OwlNightVisionMult");
    local v12 = OwlNightVisionMult and OwlNightVisionMult.Value or 1;

    return math.clamp((v10 - v11) / (v12 <= 0 and 1 or v12), 0, 1);
end;

local function tweenAtmosphereDensity(p13, p14, u15) -- Line: 63
    -- upvalues: u6 (ref), u8 (ref), TweenService (copy)
    if not u6 then
        return;
    end;

    if u8 then
        u8:Cancel();
        u8:Destroy();
        u8 = nil;
    end;

    local u16 = TweenService:Create(u6, TweenInfo.new(p14, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Density = p13
    });
    u8 = u16;

    if u15 then
        u16.Completed:Once(function(p17) -- Line: 78
            -- upvalues: u8 (ref), u16 (copy), u15 (copy)
            if u8 == u16 then
                u8 = nil;
            end;

            u16:Destroy();
            u15();
        end);
    else
        u16.Completed:Once(function() -- Line: 86
            -- upvalues: u8 (ref), u16 (copy)
            if u8 == u16 then
                u8 = nil;
            end;

            u16:Destroy();
        end);
    end;

    u16:Play();
end;

local function isCutscenePlaying() -- Line: 97
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true;
end;

local function refreshDensity() -- Line: 101
    -- upvalues: u5 (ref), u6 (ref), LocalPlayer (copy), tweenAtmosphereDensity (copy), getTargetDensity (copy)
    if not u5 then
        return;
    end;

    if not u6 then
        return;
    end;

    if LocalPlayer:GetAttribute("OfflineCutscenePlaying") == true then
        tweenAtmosphereDensity(0, 0.5);

        return;
    end;

    tweenAtmosphereDensity(getTargetDensity(), 1.5);
end;

local function applyAtmosphere() -- Line: 114
    -- upvalues: ReplicatedStorage (copy), u6 (ref), Lighting (copy)
    local NightAtmosphere = ReplicatedStorage.Assets:FindFirstChild("NightAtmosphere");

    if not NightAtmosphere then
        return;
    end;

    if not u6 then
        u6 = NightAtmosphere:Clone();
        u6.Name = "ActiveNightAtmosphere";
        u6.Density = 0;
        u6.Parent = Lighting;
    end;
end;

local function removeAtmosphere() -- Line: 138
    -- upvalues: u6 (ref), tweenAtmosphereDensity (copy)
    if not u6 then
        return;
    end;

    tweenAtmosphereDensity(0, 2, function() -- Line: 140
        -- upvalues: u6 (ref)
        if u6 then
            u6:Destroy();
            u6 = nil;
        end;
    end);
end;

local function spawnNightModel() -- Line: 148
    -- upvalues: ReplicatedStorage (copy), u4 (ref), TweenService (copy), Debris (copy)
    local MegaMoon = ReplicatedStorage.Assets:FindFirstChild("MegaMoon");

    if not MegaMoon then
        return;
    end;

    u4 = MegaMoon:Clone();
    u4.Name = "ActiveNight";
    u4.Parent = workspace;
    local v18 = {};

    for _, descendant in u4:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("OGTransparency") == nil then
                descendant:SetAttribute("OGTransparency", descendant.Transparency);
            end;

            descendant.Transparency = 1;
            table.insert(v18, descendant);
        end;
    end;

    local u19 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

    for i, v in v18 do
        task.delay(i * 0.05, function() -- Line: 171
            -- upvalues: TweenService (ref), v (copy), u19 (copy), Debris (ref)
            local v20 = TweenService:Create(v, u19, {
                Transparency = v:GetAttribute("OGTransparency")
            });
            v20:Play();
            Debris:AddItem(v20, u19.Time);
        end);
    end;
end;

local function removeNightModel() -- Line: 180
    -- upvalues: u4 (ref), TweenService (copy), Debris (copy)
    if not u4 then
        return;
    end;

    local v21 = {};

    for _, descendant in u4:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v21, descendant);
        end;
    end;

    local v22 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In);

    for _, v in v21 do
        local v23 = TweenService:Create(v, v22, {
            Transparency = 1
        });
        v23:Play();
        Debris:AddItem(v23, v22.Time);
    end;

    local u24 = u4;
    task.delay(2.1, function() -- Line: 199
        -- upvalues: u24 (copy)
        if u24 and u24.Parent then
            u24:Destroy();
        end;
    end);
    u4 = nil;
end;

function v1.Start(p25, p26, p27) -- Line: 207
    -- upvalues: u5 (ref), u9 (copy), LightingController (copy), u2 (copy), spawnNightModel (copy), ReplicatedStorage (copy), u6 (ref), Lighting (copy), tweenAtmosphereDensity (copy), TweenService (copy), CamShake (copy), u4 (ref), RunService (copy), u3 (copy), LocalPlayer (copy), u7 (ref), refreshDensity (copy)
    u5 = true;
    u9.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    u9.Playing = true;
    u9.TimePosition = 0;
    LightingController:TransitionTo(u2);
    spawnNightModel();
    local NightAtmosphere = ReplicatedStorage.Assets:FindFirstChild("NightAtmosphere");

    if NightAtmosphere and not u6 then
        u6 = NightAtmosphere:Clone();
        u6.Name = "ActiveNightAtmosphere";
        u6.Density = 0;
        u6.Parent = Lighting;
    end;

    game.TweenService:Create(game.SoundService.Master.GameMusic.ClientMusic, TweenInfo.new(1), {
        Volume = 0
    }):Play();
    tweenAtmosphereDensity(0.56, 1);
    task.wait(3);
    tweenAtmosphereDensity(0.2, 0.4);
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Parent = game.Lighting;
    game.Debris:AddItem(ColorCorrectionEffect, 5);
    game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {
        FieldOfView = 95
    }):Play();
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
        Brightness = 1.5,
        Contrast = 0.2,
        Saturation = 0.5,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    CamShake:Shake(CamShake.Presets.SideExplosion);
    game.SoundService:PlayLocalSound(game.SoundService.SFX.Snap);
    task.delay(0.4, function() -- Line: 236
        -- upvalues: TweenService (ref), ColorCorrectionEffect (copy)
        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(1), {
            FieldOfView = 70
        }):Play();
    end);
    local u28 = true;
    local u29 = false;
    local u30;

    if u4 then
        u30 = u4:FindFirstChild("Moon");
    else
        u30 = nil;
    end;

    if u30 and u30:IsA("Model") then
        local u31 = u30:GetPivot();
        local u32 = Random.new();
        local u33 = 0;
        local u34 = 0;
        task.spawn(function() -- Line: 253
            -- upvalues: u28 (ref), RunService (ref), u33 (ref), u29 (ref), u34 (ref), TweenService (ref), u30 (copy), u31 (copy), u32 (copy)
            task.wait(1);

            while u28 do
                local v35 = RunService.Heartbeat:Wait();
                u33 = u33 + v35;
                local v36 = math.clamp(u33 / 2, 0, 1) * 5;

                if u29 then
                    u34 = u34 + v35;
                    local v37 = TweenService:GetValue(math.clamp(u34 / 3, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.In);
                    u30:ScaleTo((math.lerp(1, 2.75, v37)));
                end;

                u30:PivotTo(u31 * CFrame.new(u32:NextUnitVector() * v36));
            end;
        end);
    end;

    task.wait(3);
    LightingController:TransitionTo(u3, 3);
    local Earthquake = game.SoundService.SFX:FindFirstChild("Earthquake");

    if Earthquake then
        Earthquake = Earthquake:Clone();
    end;

    if Earthquake then
        Earthquake.Parent = workspace;
        Earthquake:Play();
        TweenService:Create(Earthquake, TweenInfo.new(1), {
            Volume = 0.8
        }):Play();
    end;

    CamShake:ShakeSustain(CamShake.Presets.Earthquake);
    game.TweenService:Create(game.SoundService.Master.GameMusic.ClientMusic, TweenInfo.new(1), {
        Volume = 1
    }):Play();
    u29 = true;

    if u4 then
        local Stars = u4:FindFirstChild("Stars");

        if Stars then
            for _, child in Stars:GetChildren() do
                child.Enabled = true;
            end;
        end;

        local Debris2 = u4:FindFirstChild("Debris");

        if Debris2 then
            for _, child in Debris2:GetChildren() do
                TweenService:Create(child, TweenInfo.new(1), {
                    TimeScale = 1
                }):Play();
            end;
        end;
    end;

    task.delay(2, function() -- Line: 305
        -- upvalues: TweenService (ref), Earthquake (copy), CamShake (ref), u29 (ref), u28 (ref)
        local ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect2.Parent = game.Lighting;
        game.Debris:AddItem(ColorCorrectionEffect2, 3.5);
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(2), {
            FieldOfView = 95
        }):Play();
        TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(2), {
            Brightness = 0.5,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        task.delay(0.4, function() -- Line: 315
            -- upvalues: TweenService (ref), ColorCorrectionEffect2 (copy)
            TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(1), {
                Brightness = 0,
                Contrast = 0,
                Saturation = 0,
                TintColor = Color3.fromRGB(255, 255, 255)
            }):Play();
            game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(1), {
                FieldOfView = 70
            }):Play();
        end);

        if Earthquake then
            TweenService:Create(Earthquake, TweenInfo.new(1), {
                Volume = 0
            }):Play();
        end;

        CamShake:StopSustained(3);
        task.delay(1, function() -- Line: 326
            -- upvalues: u29 (ref), u28 (ref), Earthquake (ref)
            u29 = false;
            u28 = false;

            if Earthquake then
                Earthquake:Destroy();
            end;
        end);
    end);
    local FogDensityClear = LocalPlayer:FindFirstChild("FogDensityClear");

    if FogDensityClear then
        u7 = FogDensityClear.Changed:Connect(refreshDensity);
    end;
end;

function v1.End(p38) -- Line: 343
    -- upvalues: u5 (ref), u7 (ref), removeNightModel (copy), u6 (ref), tweenAtmosphereDensity (copy)
    u5 = false;

    if u7 then
        u7:Disconnect();
        u7 = nil;
    end;

    removeNightModel();

    if not u6 then
        return;
    end;

    tweenAtmosphereDensity(0, 2, function() -- Line: 140
        -- upvalues: u6 (ref)
        if u6 then
            u6:Destroy();
            u6 = nil;
        end;
    end);
end;

return v1;