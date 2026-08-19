-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Debris = game:GetService("Debris");
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ContentProvider = game:GetService("ContentProvider");
local SoundService = game:GetService("SoundService");
local Knit = require(ReplicatedStorage.Packages.Knit);
local MutationConfig = require(ReplicatedStorage.Shared.Info.MutationConfig);
local WeatherConfig = require(ReplicatedStorage.Shared.Info.WeatherConfig);
local v1 = Knit.CreateController({
    Name = "WeatherController"
});
local u2 = nil;
local u3 = {};
local u4 = false;
local u5 = {
    Sandstorm = "SandstormLoop",
    Blizzard = "BlizzardLoop"
};
local u6 = nil;

local function setAmbience(p7) -- Line: 39
    -- upvalues: u6 (ref), u5 (copy), Players (copy), SoundService (copy)
    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    local v8 = p7 and u5[p7] or nil;
    local CalmRain = Players.LocalPlayer:FindFirstChild("CalmRain");

    if CalmRain and CalmRain:IsA("Sound") then
        CalmRain.Playing = v8 == nil;
    end;

    if not v8 then
        return;
    end;

    local v9 = SoundService:FindFirstChild(v8, true);

    if not v9 then
        return;
    end;

    local v10 = v9:Clone();
    v10.Looped = true;
    v10.Parent = Players.LocalPlayer;
    v10:Play();
    u6 = v10;
end;

local function bigFieldVFX() -- Line: 60
    local BigField = workspace:FindFirstChild("BigField");

    if BigField then
        BigField = BigField:FindFirstChild("VFX");
    end;

    return BigField;
end;

local function vfx(p11) -- Line: 65
    local BigField = workspace:FindFirstChild("BigField");

    if BigField then
        BigField = BigField:FindFirstChild("VFX");
    end;

    if BigField then
        BigField = BigField:FindFirstChild(p11);
    end;

    return BigField;
end;

local u12 = {};
local u13 = nil;

local function tintPart(p14, p15) -- Line: 75
    -- upvalues: u12 (copy)
    if u12[p14] == nil then
        u12[p14] = p14.Color;
    end;

    p14.Color = p15 or u12[p14];
end;

local function tintParts(p16) -- Line: 80
    -- upvalues: u13 (ref), WeatherConfig (copy), u12 (copy)
    u13 = p16;
    local BigField = workspace:FindFirstChild("BigField");

    if not BigField then
        return;
    end;

    for _, v in WeatherConfig.TintTargets do
        local v17 = BigField;

        for _, v2 in v do
            if BigField then
                BigField = BigField:FindFirstChild(v2);
            end;
        end;

        if BigField then
            if BigField:IsA("BasePart") then
                if u12[BigField] == nil then
                    u12[BigField] = BigField.Color;
                end;

                BigField.Color = p16 or u12[BigField];
            end;

            for _, descendant in BigField:GetDescendants() do
                if descendant:IsA("BasePart") then
                    if u12[descendant] == nil then
                        u12[descendant] = descendant.Color;
                    end;

                    descendant.Color = p16 or u12[descendant];
                end;
            end;

            BigField = v17;
        else
            BigField = v17;
        end;
    end;
end;

local function setEmittersEnabled(p18, p19) -- Line: 99
    if not p18 then
        return;
    end;

    for _, descendant in p18:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or (descendant:IsA("Beam") or descendant:IsA("Trail")) then
            descendant.Enabled = p19;
        end;
    end;

    if p18:IsA("ParticleEmitter") or (p18:IsA("Beam") or p18:IsA("Trail")) then
        p18.Enabled = p19;
    end;
end;

local function copyColorCorrection(p20) -- Line: 111
    -- upvalues: Lighting (copy)
    local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

    if not (ColorCorrection and p20) then
        return;
    end;

    ColorCorrection.Brightness = p20.Brightness;
    ColorCorrection.Contrast = p20.Contrast;
    ColorCorrection.Saturation = p20.Saturation;
    ColorCorrection.TintColor = p20.TintColor;
end;

local function captureDefaults() -- Line: 124
    -- upvalues: Lighting (copy), u3 (copy)
    local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

    if ColorCorrection then
        u3.cc = {
            Brightness = ColorCorrection.Brightness,
            Contrast = ColorCorrection.Contrast,
            Saturation = ColorCorrection.Saturation,
            TintColor = ColorCorrection.TintColor
        };
    end;

    local Atmosphere = Lighting:FindFirstChild("Atmosphere");

    if Atmosphere then
        u3.atmosphere = {
            Density = Atmosphere.Density,
            Haze = Atmosphere.Haze
        };
    end;

    u3.clockTime = Lighting.ClockTime;
    local Clouds = workspace.Terrain:FindFirstChild("Clouds");
    u3.cloudsEnabled = Clouds and (Clouds.Enabled or true) or true;

    if Clouds then
        u3.cloudsColor = Clouds.Color;
        u3.cloudsDensity = Clouds.Density;
    end;

    u3.sky = Lighting:FindFirstChild("Sky");
end;

local u21 = TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

local function tweenClouds(p22, p23) -- Line: 153
    -- upvalues: TweenService (copy), u21 (copy)
    local Clouds = workspace.Terrain:FindFirstChild("Clouds");

    if not Clouds then
        return;
    end;

    local v24 = {};

    if p22 then
        v24.Color = p22;
    end;

    if p23 then
        v24.Density = p23;
    end;

    TweenService:Create(Clouds, u21, v24):Play();
end;

local function restoreColorCorrection() -- Line: 162
    -- upvalues: Lighting (copy), u3 (copy)
    local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

    if ColorCorrection and u3.cc then
        ColorCorrection.Brightness = u3.cc.Brightness;
        ColorCorrection.Contrast = u3.cc.Contrast;
        ColorCorrection.Saturation = u3.cc.Saturation;
        ColorCorrection.TintColor = u3.cc.TintColor;
    end;
end;

local function restoreAtmosphere() -- Line: 172
    -- upvalues: Lighting (copy), u3 (copy)
    local Atmosphere = Lighting:FindFirstChild("Atmosphere");

    if Atmosphere and u3.atmosphere then
        Atmosphere.Density = u3.atmosphere.Density;
        Atmosphere.Haze = u3.atmosphere.Haze;
    end;
end;

local function restoreSky() -- Line: 180
    -- upvalues: Lighting (copy), u3 (copy)
    for _, child in Lighting:GetChildren() do
        if child:IsA("Sky") and child ~= u3.sky then
            child:Destroy();
        end;
    end;

    if u3.sky and u3.sky.Parent ~= Lighting then
        u3.sky.Parent = Lighting;
    end;
end;

local function baseline() -- Line: 194
    -- upvalues: setEmittersEnabled (copy), u6 (ref), Players (copy), tintParts (copy), u4 (ref), u3 (copy), tweenClouds (copy), Lighting (copy), restoreSky (copy)
    local BigField = workspace:FindFirstChild("BigField");

    if BigField then
        BigField = BigField:FindFirstChild("VFX");
    end;

    if BigField then
        BigField = BigField:FindFirstChild("NormalRain");
    end;

    setEmittersEnabled(BigField, true);
    local BigField2 = workspace:FindFirstChild("BigField");

    if BigField2 then
        BigField2 = BigField2:FindFirstChild("VFX");
    end;

    if BigField2 then
        BigField2 = BigField2:FindFirstChild("Rain Floor");
    end;

    setEmittersEnabled(BigField2, true);
    local BigField3 = workspace:FindFirstChild("BigField");

    if BigField3 then
        BigField3 = BigField3:FindFirstChild("VFX");
    end;

    if BigField3 then
        BigField3 = BigField3:FindFirstChild("LightningRain");
    end;

    setEmittersEnabled(BigField3, false);
    local BigField4 = workspace:FindFirstChild("BigField");

    if BigField4 then
        BigField4 = BigField4:FindFirstChild("VFX");
    end;

    if BigField4 then
        BigField4 = BigField4:FindFirstChild("AcidRain");
    end;

    setEmittersEnabled(BigField4, false);
    local BigField5 = workspace:FindFirstChild("BigField");

    if BigField5 then
        BigField5 = BigField5:FindFirstChild("VFX");
    end;

    if BigField5 then
        BigField5 = BigField5:FindFirstChild("Acid Rain Floor");
    end;

    setEmittersEnabled(BigField5, false);
    local BigField6 = workspace:FindFirstChild("BigField");

    if BigField6 then
        BigField6 = BigField6:FindFirstChild("VFX");
    end;

    if BigField6 then
        BigField6 = BigField6:FindFirstChild("Misty");
    end;

    setEmittersEnabled(BigField6, false);
    local BigField7 = workspace:FindFirstChild("BigField");

    if BigField7 then
        BigField7 = BigField7:FindFirstChild("VFX");
    end;

    if BigField7 then
        BigField7 = BigField7:FindFirstChild("Rainbow");
    end;

    setEmittersEnabled(BigField7, false);
    local BigField8 = workspace:FindFirstChild("BigField");

    if BigField8 then
        BigField8 = BigField8:FindFirstChild("VFX");
    end;

    if BigField8 then
        BigField8 = BigField8:FindFirstChild("Sandstorm");
    end;

    setEmittersEnabled(BigField8, false);
    local BigField9 = workspace:FindFirstChild("BigField");

    if BigField9 then
        BigField9 = BigField9:FindFirstChild("VFX");
    end;

    if BigField9 then
        BigField9 = BigField9:FindFirstChild("Blizzard");
    end;

    setEmittersEnabled(BigField9, false);

    if u6 then
        u6:Destroy();
        u6 = nil;
    end;

    local CalmRain = Players.LocalPlayer:FindFirstChild("CalmRain");

    if CalmRain and CalmRain:IsA("Sound") then
        CalmRain.Playing = true;
    end;

    tintParts(nil);
    u4 = false;
    local Clouds = workspace.Terrain:FindFirstChild("Clouds");

    if Clouds then
        Clouds.Enabled = u3.cloudsEnabled;
    end;

    tweenClouds(u3.cloudsColor, u3.cloudsDensity);
    Lighting.ClockTime = u3.clockTime;
    local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

    if ColorCorrection and u3.cc then
        ColorCorrection.Brightness = u3.cc.Brightness;
        ColorCorrection.Contrast = u3.cc.Contrast;
        ColorCorrection.Saturation = u3.cc.Saturation;
        ColorCorrection.TintColor = u3.cc.TintColor;
    end;

    local Atmosphere = Lighting:FindFirstChild("Atmosphere");

    if Atmosphere and u3.atmosphere then
        Atmosphere.Density = u3.atmosphere.Density;
        Atmosphere.Haze = u3.atmosphere.Haze;
    end;

    restoreSky();
end;

local function meteorTemplate() -- Line: 271
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("MeteorTrail");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("MeteorTrail");
    end;

    return Assets;
end;

local function spawnMeteor() -- Line: 278
    -- upvalues: ReplicatedStorage (copy), TweenService (copy), Debris (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("MeteorTrail");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("MeteorTrail");
    end;

    local CurrentCamera = workspace.CurrentCamera;

    if not (Assets and CurrentCamera) then
        return;
    end;

    local Position = CurrentCamera.CFrame.Position;
    local v25 = math.random(-1000, 1000);
    local v26 = math.random(380, 520);
    local v27 = Position + Vector3.new(v25, v26, math.random(-1000, 1000));
    local v28 = math.random(-100, 100);
    local v29 = Vector3.new(v28, 0, math.random(-100, 100));
    local Unit = ((v29.Magnitude < 1 and Vector3.new(100, 0, 0) or v29).Unit + Vector3.new(0, -0.22, 0)).Unit;
    local v30 = v27 + Unit * math.random(600, 900);
    local v31 = Assets:Clone();
    v31.Anchored = true;

    for _, descendant in v31:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true;
        end;
    end;

    v31.CFrame = CFrame.lookAt(v27, v30);
    v31.Parent = workspace;
    TweenService:Create(v31, TweenInfo.new(1.6, Enum.EasingStyle.Linear), {
        CFrame = CFrame.lookAt(v30, v30 + Unit)
    }):Play();
    Debris:AddItem(v31, 2.6);
end;

local function startMeteorLoop() -- Line: 306
    -- upvalues: u4 (ref), spawnMeteor (copy)
    if u4 then
        return;
    end;

    u4 = true;
    task.spawn(function() -- Line: 309
        -- upvalues: u4 (ref), spawnMeteor (ref)
        while u4 do
            spawnMeteor();
            task.wait(math.random(20, 45) / 30);
        end;
    end);
end;

local u34 = {
    Misty = function() -- Line: 224, Name: applyMisty
        -- upvalues: setEmittersEnabled (copy), Lighting (copy)
        local BigField = workspace:FindFirstChild("BigField");

        if BigField then
            BigField = BigField:FindFirstChild("VFX");
        end;

        if BigField then
            BigField = BigField:FindFirstChild("Misty");
        end;

        setEmittersEnabled(BigField, true);
        local Atmosphere = Lighting:FindFirstChild("Atmosphere");

        if Atmosphere then
            Atmosphere.Density = math.max(Atmosphere.Density, 0.45);
            Atmosphere.Haze = math.max(Atmosphere.Haze, 2.5);
        end;
    end,

    Sandstorm = function() -- Line: 250, Name: applySandstorm
        -- upvalues: setEmittersEnabled (copy), setAmbience (copy), tintParts (copy), WeatherConfig (copy)
        local BigField = workspace:FindFirstChild("BigField");

        if BigField then
            BigField = BigField:FindFirstChild("VFX");
        end;

        if BigField then
            BigField = BigField:FindFirstChild("NormalRain");
        end;

        setEmittersEnabled(BigField, false);
        local BigField2 = workspace:FindFirstChild("BigField");

        if BigField2 then
            BigField2 = BigField2:FindFirstChild("VFX");
        end;

        if BigField2 then
            BigField2 = BigField2:FindFirstChild("Rain Floor");
        end;

        setEmittersEnabled(BigField2, false);
        local BigField3 = workspace:FindFirstChild("BigField");

        if BigField3 then
            BigField3 = BigField3:FindFirstChild("VFX");
        end;

        if BigField3 then
            BigField3 = BigField3:FindFirstChild("Sandstorm");
        end;

        setEmittersEnabled(BigField3, true);
        setAmbience("Sandstorm");
        tintParts(WeatherConfig.Weathers.Sandstorm.tintColor);
    end,

    Blizzard = function() -- Line: 258, Name: applyBlizzard
        -- upvalues: setEmittersEnabled (copy), setAmbience (copy), tintParts (copy), WeatherConfig (copy)
        local BigField = workspace:FindFirstChild("BigField");

        if BigField then
            BigField = BigField:FindFirstChild("VFX");
        end;

        if BigField then
            BigField = BigField:FindFirstChild("NormalRain");
        end;

        setEmittersEnabled(BigField, false);
        local BigField2 = workspace:FindFirstChild("BigField");

        if BigField2 then
            BigField2 = BigField2:FindFirstChild("VFX");
        end;

        if BigField2 then
            BigField2 = BigField2:FindFirstChild("Rain Floor");
        end;

        setEmittersEnabled(BigField2, false);
        local BigField3 = workspace:FindFirstChild("BigField");

        if BigField3 then
            BigField3 = BigField3:FindFirstChild("VFX");
        end;

        if BigField3 then
            BigField3 = BigField3:FindFirstChild("Blizzard");
        end;

        setEmittersEnabled(BigField3, true);
        setAmbience("Blizzard");
        tintParts(WeatherConfig.Weathers.Blizzard.tintColor);
    end,

    AcidRain = function() -- Line: 233, Name: applyAcidRain
        -- upvalues: setEmittersEnabled (copy), Lighting (copy)
        local BigField = workspace:FindFirstChild("BigField");

        if BigField then
            BigField = BigField:FindFirstChild("VFX");
        end;

        if BigField then
            BigField = BigField:FindFirstChild("NormalRain");
        end;

        setEmittersEnabled(BigField, false);
        local BigField2 = workspace:FindFirstChild("BigField");

        if BigField2 then
            BigField2 = BigField2:FindFirstChild("VFX");
        end;

        if BigField2 then
            BigField2 = BigField2:FindFirstChild("Rain Floor");
        end;

        setEmittersEnabled(BigField2, false);
        local BigField3 = workspace:FindFirstChild("BigField");

        if BigField3 then
            BigField3 = BigField3:FindFirstChild("VFX");
        end;

        if BigField3 then
            BigField3 = BigField3:FindFirstChild("AcidRain");
        end;

        setEmittersEnabled(BigField3, true);
        local BigField4 = workspace:FindFirstChild("BigField");

        if BigField4 then
            BigField4 = BigField4:FindFirstChild("VFX");
        end;

        if BigField4 then
            BigField4 = BigField4:FindFirstChild("Acid Rain Floor");
        end;

        setEmittersEnabled(BigField4, true);
        local Events = Lighting:FindFirstChild("Events");

        if Events then
            Events = Events:FindFirstChild("Radioactive");
        end;

        if Events then
            Events = Events:FindFirstChild("ColorCorrection");
        end;

        local ColorCorrection = Lighting:FindFirstChild("ColorCorrection");

        if ColorCorrection then
            if not Events then
                return;
            end;

            ColorCorrection.Brightness = Events.Brightness;
            ColorCorrection.Contrast = Events.Contrast;
            ColorCorrection.Saturation = Events.Saturation;
            ColorCorrection.TintColor = Events.TintColor;
        end;
    end,

    Rainbow = function() -- Line: 244, Name: applyRainbow
        -- upvalues: setEmittersEnabled (copy), tweenClouds (copy)
        local BigField = workspace:FindFirstChild("BigField");

        if BigField then
            BigField = BigField:FindFirstChild("VFX");
        end;

        if BigField then
            BigField = BigField:FindFirstChild("Rainbow");
        end;

        setEmittersEnabled(BigField, true);
        tweenClouds(Color3.new(0.9, 0.9, 0.9), 0.35);
    end,

    MeteorShower = function() -- Line: 317, Name: applyMeteorShower
        -- upvalues: Lighting (copy), TweenService (copy), ContentProvider (copy), u2 (ref), u3 (copy), u4 (ref), spawnMeteor (copy)
        local Clouds = workspace.Terrain:FindFirstChild("Clouds");

        if Clouds then
            Clouds.Enabled = false;
        end;

        local Atmosphere = Lighting:FindFirstChild("Atmosphere");

        if Atmosphere then
            Atmosphere.Haze = 0;
        end;

        TweenService:Create(Lighting, TweenInfo.new(1), {
            ClockTime = 14
        }):Play();
        local Events = Lighting:FindFirstChild("Events");

        if Events then
            Events = Events:FindFirstChild("MeteorShower");
        end;

        if Events then
            local ColorCorrection = Events:FindFirstChild("ColorCorrection");
            local ColorCorrection2 = Lighting:FindFirstChild("ColorCorrection");

            if ColorCorrection2 and ColorCorrection then
                ColorCorrection2.Brightness = ColorCorrection.Brightness;
                ColorCorrection2.Contrast = ColorCorrection.Contrast;
                ColorCorrection2.Saturation = ColorCorrection.Saturation;
                ColorCorrection2.TintColor = ColorCorrection.TintColor;
            end;

            local v32 = Events:FindFirstChild("CelestialSky") or Events:FindFirstChildWhichIsA("Sky");

            if v32 and v32:IsA("Sky") then
                local u33 = v32:Clone();
                task.spawn(function() -- Line: 339
                    -- upvalues: ContentProvider (ref), u33 (copy), u2 (ref), u3 (ref), Lighting (ref)
                    pcall(function() -- Line: 340
                        -- upvalues: ContentProvider (ref), u33 (ref)
                        ContentProvider:PreloadAsync({ u33 });
                    end);

                    if u2 ~= "MeteorShower" then
                        u33:Destroy();

                        return;
                    end;

                    if u3.sky and u3.sky.Parent == Lighting then
                        u3.sky.Parent = nil;
                    end;

                    u33.Parent = Lighting;
                end);
            end;
        end;

        if u4 then
            return;
        end;

        u4 = true;
        task.spawn(function() -- Line: 309
            -- upvalues: u4 (ref), spawnMeteor (ref)
            while u4 do
                spawnMeteor();
                task.wait(math.random(20, 45) / 30);
            end;
        end);
    end
};

function v1.GetCurrent(p35) -- Line: 367
    -- upvalues: u2 (ref)
    return u2;
end;

function v1.ApplyWeather(p36, p37) -- Line: 371
    -- upvalues: u2 (ref), baseline (copy), u34 (copy)
    if p37 == "" then
        p37 = nil;
    end;

    if p37 == u2 then
        return;
    end;

    u2 = p37;
    baseline();

    if p37 and u34[p37] then
        u34[p37]();
    end;
end;

function v1.PlayBurst(p38, p39, p40) -- Line: 383
    -- upvalues: MutationConfig (copy), ReplicatedStorage (copy), Debris (copy)
    local v41 = MutationConfig.Get(p39);

    if not (v41 and v41.burstFX) then
        return;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("Greedy");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("velcrawl vfx");
    end;

    if Assets then
        Assets = Assets:FindFirstChild(v41.burstFX);
    end;

    if not Assets then
        return;
    end;

    local v42 = Assets:Clone();
    v42.Anchored = true;
    v42.CanCollide = false;
    v42.CFrame = CFrame.new(p40);
    v42.Parent = workspace;

    for _, descendant in v42:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant:Emit(descendant:GetAttribute("EmitCount") or 20);
        end;
    end;

    Debris:AddItem(v42, 2.5);
end;

function v1.KnitStart(u43) -- Line: 410
    -- upvalues: captureDefaults (copy), Lighting (copy), ContentProvider (copy), Knit (copy), baseline (copy), ReplicatedStorage (copy)
    captureDefaults();
    task.spawn(function() -- Line: 415
        -- upvalues: Lighting (ref), ContentProvider (ref)
        local Events = Lighting:FindFirstChild("Events");

        if Events then
            Events = Events:FindFirstChild("MeteorShower");
        end;

        if Events then
            Events = Events:FindFirstChild("CelestialSky") or Events:FindFirstChildWhichIsA("Sky");
        end;

        if Events then
            pcall(function() -- Line: 420
                -- upvalues: ContentProvider (ref), Events (copy)
                ContentProvider:PreloadAsync({ Events });
            end);
        end;
    end);
    Knit.GetService("WeatherService").WeatherChanged:Connect(function(p44) -- Line: 426
        -- upvalues: u43 (copy)
        u43:ApplyWeather(p44);
    end);
    baseline();
    local v45 = ReplicatedStorage:FindFirstChild("CurrentWeather") or ReplicatedStorage:WaitForChild("CurrentWeather", 10);

    if v45 and v45.Value ~= "" then
        u43:ApplyWeather(v45.Value);
    end;
end;

function v1.KnitInit(p46) -- Line: 444
end;

return v1;