-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local SoundService = game:GetService("SoundService");
local TweenService = game:GetService("TweenService");
local Workspace = game:GetService("Workspace");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Audio = require(ReplicatedStorage.Library.Audio);
local CameraShaker = require(ReplicatedStorage.Library.Modules.Packages.CameraShaker);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local PreloadSounds = require(ReplicatedStorage.Library.Functions.PreloadSounds);
local Schema = require(script.Types.Schema);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
require(script.Types.Interface);
local u1 = Log.new():LimitUnderLevel("Warning");
local u2 = { 113113198465358 };
local CurrentCamera = Workspace.CurrentCamera;
local u3 = nil;
local u4 = false;
local u5 = 1;
local u6 = { 1.263728562240505, 1.24413976577313, 0.8219686932003283, 1.074269037328637, 0.7502054419233101, 0.9848709870519721, 0.9218227914770963, 0.743954381007657, 0.92724827099563, 1.008364557765791, 1.09791681826094, 0.8170620855252841, 0.7976348321317698, 0.8978551805156156, 1.252554092631066, 0.7582926685664537, 1.290053567694925, 0.9533136158162119, 0.8246673227008587, 0.8527744096010031 };
local u7 = nil;
local u8 = false;
local u9 = false;
local u10 = 0;
local u11 = {};

local function requireResources() -- Line: 81
    -- upvalues: u3 (ref), Players (copy), SoundService (copy), TweenService (copy), CameraShaker (copy), CurrentCamera (ref), u8 (ref), u4 (ref), PreloadSounds (copy)
    local v12 = u3;

    if v12 ~= nil then
        return v12;
    end;

    local LocalPlayer = Players.LocalPlayer;
    assert(LocalPlayer ~= nil, "Expected LocalPlayer");
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
    local v13 = PlayerGui:IsA("PlayerGui");
    assert(v13, "Expected PlayerGui");
    local Vignette = PlayerGui:WaitForChild("Vignette");
    local v14 = Vignette:IsA("ScreenGui");
    assert(v14, "Expected Vignette ScreenGui");
    local Vignette2 = Vignette.Vignette;
    local v15 = Vignette2:IsA("GuiObject");
    assert(v15, "Expected Vignette frame");
    local UIScale = Vignette2.UIScale;
    local v16 = UIScale:IsA("UIScale");
    assert(v16, "Expected Vignette.UIScale");
    local FilmGrain = Vignette.FilmGrain;
    local v17 = FilmGrain:IsA("ImageLabel");
    assert(v17, "Expected Vignette.FilmGrain");
    local Ambience = Vignette.Ambience;
    local v18 = Ambience:IsA("Sound");
    assert(v18, "Expected Vignette.Ambience sound");
    local StealChase = SoundService.StealChase;
    local v19 = StealChase:IsA("Sound");
    assert(v19, "Expected SoundService.StealChase sound");
    local Volume = StealChase.Volume;
    local v20 = TweenService:Create(StealChase, TweenInfo.new(0.2), {
        Volume = Volume
    });
    local v21 = TweenService:Create(StealChase, TweenInfo.new(3), {
        Volume = 0
    });
    local v24 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(p22) -- Line: 111
        -- upvalues: CurrentCamera (ref)
        local v23 = CurrentCamera;

        if v23 and v23.CameraType ~= Enum.CameraType.Scriptable then
            v23.CFrame = v23.CFrame * p22;
        end;
    end);
    local v25 = CameraShaker.CameraShakeInstance.new(2, 10, 0, 0);
    v25.PositionInfluence = Vector3.new(1, 1, 1);
    v25.RotationInfluence = Vector3.new(0.2, 0.2, 0.2);
    v24:ShakeSustain(v25);
    local v26 = {
        vignetteGui = Vignette,
        vignetteScale = UIScale,
        filmGrainEffect = FilmGrain,
        ambienceSound = Ambience,
        chaseSound = StealChase,
        chaseSoundBaseVolume = Volume,
        chaseFadeInTween = v20,
        chaseFadeOutTween = v21,
        cameraShake = v24,
        cameraShakeProperties = v25
    };
    u3 = v26;
    Vignette.Enabled = true;
    v21.Completed:Connect(function(p27) -- Line: 137
        -- upvalues: u8 (ref), StealChase (copy)
        if u8 then
            return;
        end;

        if p27 == Enum.PlaybackState.Completed then
            StealChase:Stop();
            StealChase.Volume = 0;
        end;
    end);

    if not u4 then
        u4 = true;
        task.spawn(PreloadSounds, 128463138903874);
    end;

    return v26;
end;

local function getFieldOfViewMultiplier(p28) -- Line: 156
    local v29 = p28:GetAttribute("FovMult");

    return (typeof(v29) ~= "number" or v29 <= 0) and 1 or v29;
end;

local function normalizeToUnitRange(p30, p31, p32) -- Line: 165
    return math.clamp((p30 - p31) / (p32 - p31), 0, 1);
end;

local function resolvePart(p33, p34) -- Line: 169
    -- upvalues: Asserts (copy)
    if p34 then
        p33 = p34();
    end;

    if p33 == nil then
        return nil;
    end;

    Asserts.BasePart(p33);

    if p33.Parent == nil then
        return nil;
    end;

    return p33;
end;

local function stopChaseSound(p35) -- Line: 183
    -- upvalues: u3 (ref), u8 (ref)
    local v36 = u3;

    if v36 == nil then
        u8 = false;

        return;
    end;

    if not (u8 or p35) then
        return;
    end;

    if u8 then
        u8 = false;
    end;

    v36.chaseFadeInTween:Cancel();

    if not p35 then
        v36.chaseFadeOutTween:Play();

        return;
    end;

    v36.chaseFadeOutTween:Cancel();
    v36.chaseSound:Stop();
    v36.chaseSound.Volume = 0;
end;

local function startChaseSound() -- Line: 210
    -- upvalues: requireResources (copy), u8 (ref)
    local v37 = requireResources();
    v37.chaseSound.Looped = true;
    v37.chaseFadeOutTween:Cancel();

    if u8 and (v37.chaseSound.IsPlaying and v37.chaseSound.Volume > 0) then
        return;
    end;

    u8 = true;
    v37.chaseSound.Volume = 0;

    if not v37.chaseSound.IsPlaying then
        v37.chaseSound:Play();
    end;

    v37.chaseFadeInTween:Cancel();
    v37.chaseFadeInTween:Play();
end;

local function resetVisualEffects(p38) -- Line: 228
    -- upvalues: u3 (ref), CurrentCamera (ref)
    local v39 = u3;

    if v39 ~= nil then
        v39.vignetteScale.Scale = 2.2;
        v39.filmGrainEffect.Visible = false;
        v39.filmGrainEffect.ImageTransparency = 1;

        if v39.ambienceSound.IsPlaying then
            v39.ambienceSound:Stop();
        end;

        v39.cameraShake:Stop();
    end;

    local v40 = CurrentCamera;

    if v40 == nil then
        return;
    end;

    local v41 = v40:GetAttribute("FovMult");
    v40.FieldOfView = (p38 or 75) * ((typeof(v41) ~= "number" or v41 <= 0) and 1 or v41);
end;

local function captureBaseFieldOfView(p42) -- Line: 251
    -- upvalues: CurrentCamera (ref)
    if p42.baseFieldOfView ~= nil then
        return p42.baseFieldOfView;
    end;

    local v43 = CurrentCamera;

    if v43 == nil then
        return 75;
    end;

    local FieldOfView = v43.FieldOfView;
    local v44 = v43:GetAttribute("FovMult");

    return FieldOfView / ((typeof(v44) ~= "number" or v44 <= 0) and 1 or v44);
end;

local function updateProximityStinger(p45, p46, p47) -- Line: 264
    -- upvalues: u9 (ref), u10 (ref), Audio (copy), CurrentCamera (ref), SoundService (copy)
    if p45 == nil then
        u9 = false;

        return;
    end;

    local v48 = os.clock();

    if p45 > p46 or (u9 or u10 > v48) then
        if p46 < p45 then
            u9 = false;
        end;

        return;
    end;

    u9 = true;
    u10 = v48 + 3;
    Audio.Play(128463138903874, CurrentCamera or (p47 or SoundService), 1, 1);
end;

local function updateProximityAudio(p49, p50, p51) -- Line: 280
    -- upvalues: stopChaseSound (copy), u9 (ref), updateProximityStinger (copy), startChaseSound (copy)
    local v52 = p50.proximitySoundDistance or 145;
    local v53 = p50.chaseSoundDistance or 146;

    if p49 == nil then
        stopChaseSound();
        u9 = false;

        return;
    end;

    updateProximityStinger(p49, v52, p51);

    if p49 <= v53 then
        startChaseSound();

        return;
    end;

    stopChaseSound();
end;

local function applyVisualEffects(p54, p55, p56) -- Line: 299
    -- upvalues: requireResources (copy), CurrentCamera (ref), u5 (ref), u6 (copy)
    local v57 = requireResources();
    v57.vignetteScale.Scale = 2.2 - math.pow(p54, 0.5) * 1.2;
    local v58 = CurrentCamera;

    if v58 then
        if p54 > 0.7 then
            p56 = p56 - (p54 - 0.7) * 10;
        end;

        local v59 = v58:GetAttribute("FovMult");
        v58.FieldOfView = p56 * ((typeof(v59) ~= "number" or v59 <= 0) and 1 or v59);
    end;

    if p54 <= 0.75 then
        v57.filmGrainEffect.Visible = false;

        if v57.ambienceSound.IsPlaying then
            v57.ambienceSound:Stop();
        end;

        v57.cameraShake:Stop();

        return;
    end;

    u5 = u5 + p55 * 60;

    if u5 >= #u6 then
        u5 = 1;
    end;

    local v60 = u6[math.floor(u5)];
    v57.filmGrainEffect.ImageTransparency = 1 - (p54 - 0.75) * 4;
    v57.filmGrainEffect.TileSize = UDim2.new(0.1 * v60, math.floor(v60 * 10), 0.2 * v60, (math.floor(v60 * 12)));
    v57.filmGrainEffect.Visible = true;
    v57.cameraShakeProperties.Magnitude = (p54 - 0.75) * 1.2;
    v57.cameraShakeProperties.Roughness = (p54 - 0.75) * 100;

    if not v57.ambienceSound.IsPlaying then
        v57.ambienceSound:Play();
        v57.cameraShake:Start();
    end;

    v57.ambienceSound.Volume = (p54 - 0.75) * 2;
end;

local function renderStep(p61) -- Line: 341
    -- upvalues: u7 (ref), Asserts (copy), stopChaseSound (copy), u9 (ref), resetVisualEffects (copy), updateProximityStinger (copy), startChaseSound (copy), applyVisualEffects (copy)
    local v62 = u7;

    if v62 == nil then
        return;
    end;

    local trackedPart = v62.config.trackedPart;
    local trackedPartResolver = v62.config.trackedPartResolver;

    if trackedPartResolver then
        trackedPart = trackedPartResolver();
    end;

    if trackedPart == nil then
        trackedPart = nil;
    else
        Asserts.BasePart(trackedPart);

        if trackedPart.Parent == nil then
            trackedPart = nil;
        end;
    end;

    local targetPart = v62.config.targetPart;
    local targetPartResolver = v62.config.targetPartResolver;

    if targetPartResolver then
        targetPart = targetPartResolver();
    end;

    if targetPart == nil then
        targetPart = nil;
    else
        Asserts.BasePart(targetPart);

        if targetPart.Parent == nil then
            targetPart = nil;
        end;
    end;

    if trackedPart == nil or targetPart == nil then
        local config = v62.config;
        local _ = config.proximitySoundDistance or 145;
        local _ = config.chaseSoundDistance or 146;
        stopChaseSound();
        u9 = false;
        resetVisualEffects(v62.baseFieldOfView);

        return;
    end;

    if os.clock() < v62.effectReadyAt then
        local config = v62.config;
        local _ = config.proximitySoundDistance or 145;
        local _ = config.chaseSoundDistance or 146;
        stopChaseSound();
        u9 = false;
        resetVisualEffects(v62.baseFieldOfView);

        return;
    end;

    local Magnitude = (targetPart.Position - trackedPart.Position).Magnitude;
    local config = v62.config;
    local v63 = config.proximitySoundDistance or 145;
    local v64 = config.chaseSoundDistance or 146;

    if Magnitude == nil then
        stopChaseSound();
        u9 = false;
    else
        updateProximityStinger(Magnitude, v63, trackedPart);

        if Magnitude <= v64 then
            startChaseSound();
        else
            stopChaseSound();
        end;
    end;

    local v65 = v62.config.proximityMinDistance or 10;
    applyVisualEffects(1 - math.clamp((Magnitude - v65) / ((v62.config.proximitySoundDistance or 145) - v65), 0, 1), p61, v62.baseFieldOfView);
end;

local function validateStartConfig(p66) -- Line: 370
    -- upvalues: Asserts (copy), Schema (copy)
    Asserts.table(p66);
    local v67 = Schema.StartConfig(p66);
    assert(v67, "Invalid ScaryEffectController config");
    assert(p66.trackedPart ~= nil and true or p66.trackedPartResolver ~= nil, "ScaryEffectController requires trackedPart or trackedPartResolver");
    assert(p66.targetPart ~= nil and true or p66.targetPartResolver ~= nil, "ScaryEffectController requires targetPart or targetPartResolver");

    if p66.proximitySoundDistance ~= nil then
        Asserts.finiteNonNegative(p66.proximitySoundDistance);
        assert(p66.proximitySoundDistance > 0, "proximitySoundDistance must be positive");
    end;

    if p66.chaseSoundDistance ~= nil then
        Asserts.finiteNonNegative(p66.chaseSoundDistance);
        assert(p66.chaseSoundDistance > 0, "chaseSoundDistance must be positive");
    end;

    if p66.proximityMinDistance ~= nil then
        Asserts.finiteNonNegative(p66.proximityMinDistance);
    end;

    if p66.baseFieldOfView ~= nil then
        Asserts.finiteNonNegative(p66.baseFieldOfView);
        assert(p66.baseFieldOfView > 0, "baseFieldOfView must be positive");
    end;

    local v68 = p66.proximitySoundDistance or 145;
    local v69 = p66.chaseSoundDistance or 146;
    assert((p66.proximityMinDistance or 10) < v68, "proximityMinDistance must be lower than proximitySoundDistance");
    assert(v68 <= v69, "proximitySoundDistance must be lower than or equal to chaseSoundDistance");

    return p66;
end;

local function connectRuntime(u70) -- Line: 414
    -- upvalues: RunService (copy), renderStep (copy), stopChaseSound (copy), resetVisualEffects (copy)
    u70.trove:Connect(RunService.RenderStepped, renderStep);
    u70.trove:Add(function() -- Line: 416
        -- upvalues: stopChaseSound (ref), resetVisualEffects (ref), u70 (copy)
        stopChaseSound();
        resetVisualEffects(u70.baseFieldOfView);
    end);
end;

local function playEffectIntroSounds() -- Line: 422
    -- upvalues: u2 (copy), Audio (copy), SoundService (copy)
    for _, v in ipairs(u2) do
        Audio.Play(v, SoundService, 1, 1);
    end;
end;

function u11.Start(p71) -- Line: 431
    -- upvalues: validateStartConfig (copy), requireResources (copy), u7 (ref), CurrentCamera (ref), Trove (copy), RunService (copy), renderStep (copy), stopChaseSound (copy), resetVisualEffects (copy), playEffectIntroSounds (copy), u1 (copy)
    local v72 = validateStartConfig(p71);
    requireResources();
    local v73 = u7;

    if v73 == nil then
        local u74 = {
            config = v72
        };
        local v75;

        if v72.baseFieldOfView == nil then
            local v76 = CurrentCamera;

            if v76 == nil then
                v75 = 75;
            else
                local FieldOfView = v76.FieldOfView;
                local v77 = v76:GetAttribute("FovMult");
                v75 = FieldOfView / ((typeof(v77) ~= "number" or v77 <= 0) and 1 or v77);
            end;
        else
            v75 = v72.baseFieldOfView;
        end;

        u74.baseFieldOfView = v75;
        u74.effectReadyAt = os.clock() + 1.98;
        u74.trove = Trove.new();
        u7 = u74;
        u74.trove:Connect(RunService.RenderStepped, renderStep);
        u74.trove:Add(function() -- Line: 416
            -- upvalues: stopChaseSound (ref), resetVisualEffects (ref), u74 (copy)
            stopChaseSound();
            resetVisualEffects(u74.baseFieldOfView);
        end);
        playEffectIntroSounds();
    else
        v73.config = v72;
        local v78;

        if v72.baseFieldOfView == nil then
            local v79 = CurrentCamera;

            if v79 == nil then
                v78 = 75;
            else
                local FieldOfView = v79.FieldOfView;
                local v80 = v79:GetAttribute("FovMult");
                v78 = FieldOfView / ((typeof(v80) ~= "number" or v80 <= 0) and 1 or v80);
            end;
        else
            v78 = v72.baseFieldOfView;
        end;

        v73.baseFieldOfView = v78;
    end;

    u1:AtDebug():Log("ScaryEffectController started");
    renderStep(0);
end;

function u11.Configure(p81) -- Line: 456
    -- upvalues: validateStartConfig (copy), u7 (ref), u11 (copy), u1 (copy), renderStep (copy)
    local v82 = validateStartConfig(p81);
    local v83 = u7;

    if v83 == nil then
        u11.Start(v82);

        return;
    end;

    v83.config = v82;

    if v82.baseFieldOfView ~= nil then
        v83.baseFieldOfView = v82.baseFieldOfView;
    end;

    u1:AtDebug():Log("ScaryEffectController reconfigured");
    renderStep(0);
end;

function u11.Stop(p84) -- Line: 473
    -- upvalues: u7 (ref), stopChaseSound (copy), resetVisualEffects (copy), u9 (ref), u1 (copy)
    local v85 = u7;

    if v85 == nil then
        stopChaseSound(p84);
        resetVisualEffects(nil);
        u9 = false;

        return;
    end;

    u7 = nil;
    u9 = false;
    v85.trove:Destroy();
    stopChaseSound(p84);
    resetVisualEffects(v85.baseFieldOfView);
    u1:AtDebug():Log("ScaryEffectController stopped");
end;

function u11.IsActive() -- Line: 490
    -- upvalues: u7 (ref)
    return u7 ~= nil;
end;

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function() -- Line: 497
    -- upvalues: CurrentCamera (ref), Workspace (copy)
    CurrentCamera = Workspace.CurrentCamera;
end);

return u11;