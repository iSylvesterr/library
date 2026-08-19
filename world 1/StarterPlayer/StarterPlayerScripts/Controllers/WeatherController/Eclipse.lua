-- Decompiled with Potassium's decompiler.

local u1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local Skybox = require(ReplicatedStorage.ClientModules.Skybox);
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local u2 = {
    Brightness = 4,
    ClockTime = 0.578,
    ExposureCompensation = 0,
    Ambient = Color3.fromRGB(70, 16, 145),
    OutdoorAmbient = Color3.fromRGB(59, 47, 231),
    ColorShift_Top = Color3.fromRGB(7, 72, 250),
    ColorShift_Bottom = Color3.fromRGB(57, 24, 222)
};
local u3 = {
    Intensity = 1,
    Size = 24,
    Threshold = 2
};
local u4 = {
    Intensity = 0.01,
    Spread = 0.1
};
local u5 = false;
local u6 = {};
local u7 = {};
local u8 = {};
local u9 = nil;
local u10 = nil;
local u11 = {};

local function getBloom() -- Line: 74
    -- upvalues: Lighting (copy)
    return Lighting:FindFirstChildOfClass("BloomEffect");
end;

local function getSunRays() -- Line: 78
    -- upvalues: Lighting (copy)
    return Lighting:FindFirstChildOfClass("SunRaysEffect");
end;

local function saveLighting() -- Line: 82
    -- upvalues: u6 (copy), Lighting (copy), u7 (copy), u8 (copy)
    u6.Brightness = Lighting.Brightness;
    u6.ClockTime = Lighting.ClockTime;
    u6.ExposureCompensation = Lighting.ExposureCompensation;
    u6.Ambient = Lighting.Ambient;
    u6.OutdoorAmbient = Lighting.OutdoorAmbient;
    u6.ColorShift_Top = Lighting.ColorShift_Top;
    u6.ColorShift_Bottom = Lighting.ColorShift_Bottom;
    local v12 = Lighting:FindFirstChildOfClass("BloomEffect");

    if v12 then
        u7.Intensity = v12.Intensity;
        u7.Size = v12.Size;
        u7.Threshold = v12.Threshold;
    end;

    local v13 = Lighting:FindFirstChildOfClass("SunRaysEffect");

    if v13 then
        u8.Intensity = v13.Intensity;
        u8.Spread = v13.Spread;
    end;
end;

local function applyLighting() -- Line: 105
    -- upvalues: TweenService (copy), Lighting (copy), u2 (copy), u3 (copy), u4 (copy)
    workspace:SetAttribute("TimeFrozen", true);
    local v14 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v14, u2):Play();
    local v15 = Lighting:FindFirstChildOfClass("BloomEffect");

    if v15 then
        TweenService:Create(v15, v14, u3):Play();
    end;

    local v16 = Lighting:FindFirstChildOfClass("SunRaysEffect");

    if v16 then
        TweenService:Create(v16, v14, u4):Play();
    end;
end;

local function restoreLighting() -- Line: 123
    -- upvalues: TweenService (copy), Lighting (copy), u6 (copy), u7 (copy), u8 (copy)
    workspace:SetAttribute("TimeFrozen", nil);
    local v17 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v17, u6):Play();
    local v18 = Lighting:FindFirstChildOfClass("BloomEffect");

    if v18 and u7.Intensity ~= nil then
        TweenService:Create(v18, v17, u7):Play();
    end;

    local v19 = Lighting:FindFirstChildOfClass("SunRaysEffect");

    if v19 and u8.Intensity ~= nil then
        TweenService:Create(v19, v17, u8):Play();
    end;
end;

local u20 = nil;

local function getSkybox() -- Line: 148
    -- upvalues: u20 (ref), ReplicatedStorage (copy)
    if u20 then
        return u20;
    end;

    local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

    if not Skybox2 then
        return nil;
    end;

    local Eclipse = Skybox2:FindFirstChild("Eclipse");

    if Eclipse and Eclipse:IsA("Sky") then
        u20 = Eclipse;
    end;

    return u20;
end;

local function applySkybox() -- Line: 159
    -- upvalues: u20 (ref), ReplicatedStorage (copy), Skybox (copy)
    local v21;

    if u20 then
        v21 = u20;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            local Eclipse = Skybox2:FindFirstChild("Eclipse");

            if Eclipse and Eclipse:IsA("Sky") then
                u20 = Eclipse;
            end;

            v21 = u20;
        else
            v21 = nil;
        end;
    end;

    if v21 then
        Skybox.SetOrder(v21, 3);

        return;
    end;

    warn("[Eclipse] Skybox \'Eclipse\' not found in ReplicatedStorage.Assets.Skybox");
end;

local function clearSkybox() -- Line: 168
    -- upvalues: u20 (ref), ReplicatedStorage (copy), Skybox (copy)
    local v22;

    if u20 then
        v22 = u20;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            local Eclipse = Skybox2:FindFirstChild("Eclipse");

            if Eclipse and Eclipse:IsA("Sky") then
                u20 = Eclipse;
            end;

            v22 = u20;
        else
            v22 = nil;
        end;
    end;

    if v22 then
        Skybox.SetOrder(v22, 0);
    end;
end;

local function applyAtmosphere() -- Line: 175
    -- upvalues: Lighting (copy), u10 (ref)
    local Atmosphere = script:FindFirstChild("Atmosphere");

    if not Atmosphere then
        return;
    end;

    local v23 = Atmosphere:Clone();
    v23.Parent = Lighting;
    u10 = v23;
end;

local function removeAtmosphere() -- Line: 183
    -- upvalues: u10 (ref)
    if u10 then
        u10:Destroy();
        u10 = nil;
    end;
end;

local function spawnModel() -- Line: 194
    -- upvalues: ReplicatedStorage (copy), u9 (ref)
    local Weather = ReplicatedStorage.Assets:WaitForChild("Weather", 10);

    if Weather then
        Weather = Weather:WaitForChild("Eclipse", 10);
    end;

    if not Weather then
        warn("[Eclipse] VFX model not found at ReplicatedStorage.Assets.Weather.Eclipse");

        return;
    end;

    local v24 = Weather:Clone();
    v24.Name = "ActiveEclipse";

    for _, descendant in v24:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = true;
        elseif descendant:IsA("Beam") then
            descendant.Enabled = true;
        end;
    end;

    v24.Parent = workspace;
    u9 = v24;
end;

local function removeModel() -- Line: 221
    -- upvalues: u9 (ref)
    if not u9 then
        return;
    end;

    for _, descendant in u9:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
            descendant:Clear();
        elseif descendant:IsA("Beam") then
            descendant.Enabled = false;
        end;
    end;

    u9:Destroy();
    u9 = nil;
end;

local function getBeamStartPos() -- Line: 241
    -- upvalues: ReplicatedStorage (copy)
    local Weather = ReplicatedStorage.Assets:FindFirstChild("Weather");

    if Weather then
        Weather = Weather:FindFirstChild("Eclipse");
    end;

    if Weather then
        Weather = Weather:FindFirstChild("EclipseBeamStart");
    end;

    if Weather and Weather:IsA("BasePart") then
        return Weather.Position;
    end;

    return nil;
end;

local function setEffectsEnabled(p25, p26) -- Line: 251
    for _, descendant in p25:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") then
            descendant.Enabled = p26;
        end;
    end;
end;

local function playBeamSound() -- Line: 263
    -- upvalues: SoundService (copy)
    local EclipseBeam = SoundService:FindFirstChild("EclipseBeam", true);

    if not (EclipseBeam and EclipseBeam:IsA("Sound")) then
        warn("[Eclipse] EclipseBeam sound not found under SoundService");

        return;
    end;

    local v27 = EclipseBeam:Clone();
    v27.Parent = SoundService;
    v27.PlayOnRemove = true;
    v27:Destroy();
end;

local function destroyBeam(p28) -- Line: 276
    -- upvalues: u11 (copy)
    if not u11[p28] then
        return;
    end;

    u11[p28] = nil;

    if p28.connection then
        p28.connection:Disconnect();
        p28.connection = nil;
    end;

    p28.model:Destroy();
end;

local function playBeam(u29, u30) -- Line: 286
    -- upvalues: ReplicatedStorage (copy), setEffectsEnabled (copy), u11 (copy), playBeamSound (copy), CamShake (copy), RunService (copy)
    local Weather = ReplicatedStorage.Assets:FindFirstChild("Weather");

    if Weather then
        Weather = Weather:FindFirstChild("Eclipse");
    end;

    if Weather then
        Weather = Weather:FindFirstChild("EclipseBeamStart");
    end;

    local u31;

    if Weather and Weather:IsA("BasePart") then
        u31 = Weather.Position;
    else
        u31 = nil;
    end;

    if not u31 then
        warn("[Eclipse] EclipseBeamStart not found in ReplicatedStorage.Assets.Weather.Eclipse");

        return;
    end;

    local Weather2 = ReplicatedStorage.Assets:FindFirstChild("Weather");

    if Weather2 then
        Weather2 = Weather2:FindFirstChild("EclipseBeam");
    end;

    if not Weather2 then
        warn("[Eclipse] EclipseBeam model not found at ReplicatedStorage.Assets.Weather.EclipseBeam");

        return;
    end;

    local v32 = Weather2:Clone();
    local Beam = v32:FindFirstChild("Beam");
    local Target = v32:FindFirstChild("Target");

    if not (Beam and (Beam:IsA("BasePart") and (Target and Target:IsA("BasePart")))) then
        warn("[Eclipse] EclipseBeam is missing \'Beam\'/\'Target\' BaseParts");
        v32:Destroy();

        return;
    end;

    Beam.Anchored = true;
    Beam.CanCollide = false;
    Target.Anchored = true;
    Target.CanCollide = false;
    setEffectsEnabled(Beam, true);
    setEffectsEnabled(Target, false);
    local u33 = {
        model = v32
    };
    u11[u33] = true;
    v32.Parent = workspace;
    playBeamSound();
    local Size = Beam.Size;
    local v34 = u29 - u31;
    local Magnitude = v34.Magnitude;
    local u35 = Magnitude <= 0.001 and Vector3.new(0, 0, 1) or v34 / Magnitude;
    local v36 = u35:Dot(Vector3.new(0, 1, 0));
    local v37 = math.abs(v36) > 0.999 and Vector3.new(1, 0, 0) or Vector3.new(0, 1, 0);
    local Unit = (v37 - u35 * u35:Dot(v37)).Unit;
    local u38 = {};

    for _, descendant in Beam:GetDescendants() do
        if descendant:IsA("Attachment") then
            table.insert(u38, {
                att = descendant,
                base = descendant.Position
            });
        end;
    end;

    local u39 = Size.X <= 0.001 and 1 or Size.X;

    local function setBeamLength(p40) -- Line: 350
        -- upvalues: Beam (copy), Size (copy), u31 (copy), u35 (copy), Unit (copy), u39 (copy), u38 (copy)
        local v41 = math.max(p40, 0.001);
        Beam.Size = Vector3.new(v41, Size.Y, Size.Z);
        Beam.CFrame = CFrame.fromMatrix(u31 + u35 * (v41 / 2), u35, Unit);
        local v42 = v41 / u39;

        for _, v in u38 do
            local base = v.base;
            v.att.Position = Vector3.new(base.X * v42, base.Y, base.Z);
        end;
    end;

    setBeamLength(0);
    local u43 = false;

    local function onLand() -- Line: 365
        -- upvalues: u43 (ref), u33 (copy), setBeamLength (copy), Magnitude (copy), Target (copy), u29 (copy), setEffectsEnabled (ref), CamShake (ref), u11 (ref), Beam (copy)
        if u43 then
            return;
        end;

        u43 = true;

        if u33.connection then
            u33.connection:Disconnect();
            u33.connection = nil;
        end;

        setBeamLength(Magnitude);
        Target:PivotTo(CFrame.new(u29));
        setEffectsEnabled(Target, true);
        CamShake:ShakeOnce(4, 10, 0, 2.5);
        task.delay(2, function() -- Line: 383
            -- upvalues: u11 (ref), u33 (ref), setEffectsEnabled (ref), Beam (ref), Target (ref)
            if not u11[u33] then
                return;
            end;

            setEffectsEnabled(Beam, false);
            setEffectsEnabled(Target, false);
            Beam.Transparency = 1;
            Target.Transparency = 1;
            task.delay(3, function() -- Line: 389
                -- upvalues: u33 (ref), u11 (ref)
                local v44 = u33;

                if not u11[v44] then
                    return;
                end;

                u11[v44] = nil;

                if v44.connection then
                    v44.connection:Disconnect();
                    v44.connection = nil;
                end;

                v44.model:Destroy();
            end);
        end);
    end;

    if u30 <= 0 then
        onLand();

        return;
    end;

    local u45 = workspace:GetServerTimeNow();
    u33.connection = RunService.Heartbeat:Connect(function() -- Line: 401
        -- upvalues: u45 (copy), u30 (copy), setBeamLength (copy), Magnitude (copy), onLand (copy)
        local v46 = (workspace:GetServerTimeNow() - u45) / u30;
        local v47 = math.clamp(v46, 0, 1);
        setBeamLength(Magnitude * v47);

        if v47 >= 1 then
            onLand();
        end;
    end);
end;

function u1.StartWeather() -- Line: 414
    -- upvalues: u5 (ref), saveLighting (copy), applyLighting (copy), u20 (ref), ReplicatedStorage (copy), Skybox (copy), Lighting (copy), u10 (ref), spawnModel (copy)
    if u5 then
        return;
    end;

    u5 = true;
    saveLighting();
    applyLighting();
    local v48;

    if u20 then
        v48 = u20;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            local Eclipse = Skybox2:FindFirstChild("Eclipse");

            if Eclipse and Eclipse:IsA("Sky") then
                u20 = Eclipse;
            end;

            v48 = u20;
        else
            v48 = nil;
        end;
    end;

    if v48 then
        Skybox.SetOrder(v48, 3);
    else
        warn("[Eclipse] Skybox \'Eclipse\' not found in ReplicatedStorage.Assets.Skybox");
    end;

    local Atmosphere = script:FindFirstChild("Atmosphere");

    if Atmosphere then
        local v49 = Atmosphere:Clone();
        v49.Parent = Lighting;
        u10 = v49;
    end;

    spawnModel();
end;

function u1.EndWeather() -- Line: 425
    -- upvalues: u5 (ref), restoreLighting (copy), u20 (ref), ReplicatedStorage (copy), Skybox (copy), u10 (ref), removeModel (copy), u11 (copy)
    if not u5 then
        return;
    end;

    u5 = false;
    restoreLighting();
    local v50;

    if u20 then
        v50 = u20;
    else
        local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

        if Skybox2 then
            local Eclipse = Skybox2:FindFirstChild("Eclipse");

            if Eclipse and Eclipse:IsA("Sky") then
                u20 = Eclipse;
            end;

            v50 = u20;
        else
            v50 = nil;
        end;
    end;

    if v50 then
        Skybox.SetOrder(v50, 0);
    end;

    if u10 then
        u10:Destroy();
        u10 = nil;
    end;

    removeModel();

    for i in u11 do
        if u11[i] then
            u11[i] = nil;

            if i.connection then
                i.connection:Disconnect();
                i.connection = nil;
            end;

            i.model:Destroy();
        end;
    end;
end;

Networking.WeatherEffects.EclipseStart.OnClientEvent:Connect(function() -- Line: 443
    -- upvalues: u1 (copy)
    u1.StartWeather();
end);
Networking.WeatherEffects.EclipseEnd.OnClientEvent:Connect(function() -- Line: 447
    -- upvalues: u1 (copy)
    u1.EndWeather();
end);
Networking.WeatherEffects.EclipseBeam.OnClientEvent:Connect(function(p51, p52) -- Line: 451
    -- upvalues: u5 (ref), playBeam (copy)
    if u5 then
        playBeam(p51, p52);
    end;
end);

return u1;