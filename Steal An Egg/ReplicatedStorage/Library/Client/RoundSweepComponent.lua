-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Audio = require(ReplicatedStorage.Library.Audio);
local Easing = require(ReplicatedStorage.Library.Functions.Easing);
local WhiteOutlineOnTop = Workspace:WaitForChild("__OBJECTS"):WaitForChild("Highlights"):WaitForChild("WhiteOutlineOnTop");
local v1 = {};

local function autoControlPoint(p2, p3) -- Line: 54
    local v4 = (p2 + p3) * 0.5;
    local Magnitude = ((p2 - p3) * Vector3.new(1, 0, 1)).Magnitude;
    local v5 = math.max(p2.Y, p3.Y) + Magnitude * 0.5;

    return Vector3.new(v4.X, v5, v4.Z);
end;

local function computeFadeAlpha(p6) -- Line: 61
    -- upvalues: Easing (copy)
    return Easing(math.clamp((p6 - 0.9) / 0.09999999999999998, 0, 1), Enum.EasingStyle.Exponential, Enum.EasingDirection.In);
end;

local function computeScaleAlpha(p7) -- Line: 66
    -- upvalues: Easing (copy)
    return Easing(math.clamp((p7 - 0.8) / 0.19999999999999996, 0, 1), Enum.EasingStyle.Exponential, Enum.EasingDirection.In);
end;

local function applyFadeAndScale(p8, p9, p10) -- Line: 71
    for i, v in p8.partTransparencyByPart do
        i.LocalTransparencyModifier = v + (1 - v) * p9;
    end;

    for i, v in p8.decalTransparencyByDecal do
        i.Transparency = v + (1 - v) * p9;
    end;

    for i, v in p8.textureTransparencyByTexture do
        i.Transparency = v + (1 - v) * p9;
    end;

    p8.model:ScaleTo((math.max(p8.initialScale * (1 - p10), 0.001)));
end;

local function playStartSound(p11) -- Line: 87
end;

function v1.Create(p12, p13, p14, p15) -- Line: 90
    -- upvalues: WhiteOutlineOnTop (copy)
    local model = p12.model;

    if not (model and model.Parent) then
        return nil;
    end;

    local v16 = {};
    local v17 = {};
    local v18 = {};

    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanCollide = false;
            descendant.CanTouch = false;
            descendant.CanQuery = false;
            descendant.Massless = true;
            descendant.Anchored = false;
            v16[descendant] = descendant.Transparency;
        elseif descendant:IsA("Decal") then
            v17[descendant] = descendant.Transparency;
        elseif descendant:IsA("Texture") then
            v18[descendant] = descendant.Transparency;
        end;

        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false;
        end;

        if descendant:IsA("Trail") then
            descendant.Enabled = false;
        end;

        if descendant:IsA("Beam") then
            descendant.Enabled = false;
        end;

        if descendant:IsA("Smoke") then
            descendant.Enabled = false;
        end;

        if descendant:IsA("Fire") then
            descendant.Enabled = false;
        end;

        if descendant:IsA("Sparkles") then
            descendant.Enabled = false;
        end;
    end;

    local v19 = model.PrimaryPart or (model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("CENTER"));

    if not (v19 and v19:IsA("BasePart")) then
        return nil;
    end;

    model.PrimaryPart = v19;
    v19.Anchored = true;
    model.Parent = WhiteOutlineOnTop;
    model:PivotTo(model:GetPivot());
    local CFrame2 = v19.CFrame;
    local Position = CFrame2.Position;
    local v20 = {
        elapsed = 0,
        started = false,
        completed = false,
        arrivalSoundPlayed = false,
        spawnId = p12.spawnId,
        root = v19,
        model = model,
        rotation = CFrame2.Rotation,
        startPosition = Position
    };
    local v21 = Position + p14 + Vector3.new(0, 1.5, 0);
    local v22 = (Position + v21) * 0.5;
    local Magnitude = ((Position - v21) * Vector3.new(1, 0, 1)).Magnitude;
    local v23 = math.max(Position.Y, v21.Y) + Magnitude * 0.5;
    v20.controlPoint = Vector3.new(v22.X, v23, v22.Z);
    v20.targetOffset = p14 + Vector3.new(0, 1.5, 0);
    v20.delay = math.max(0, p13);
    v20.duration = math.min(1.8, p13 * 0.035 + 1.5);
    v20.startSoundPlaybackSpeed = p15;
    v20.initialScale = model:GetScale();
    v20.partTransparencyByPart = v16;
    v20.decalTransparencyByDecal = v17;
    v20.textureTransparencyByTexture = v18;

    return v20;
end;

function v1.Step(p24, p25, p26) -- Line: 177
    -- upvalues: Audio (copy), applyFadeAndScale (copy), Easing (copy), computeScaleAlpha (copy)
    if p24.completed then
        return nil;
    end;

    p24.elapsed = p24.elapsed + p25;

    if p24.elapsed < p24.delay then
        return nil;
    end;

    if not p24.started then
        p24.started = true;
    end;

    local v27 = math.clamp((p24.elapsed - p24.delay) / p24.duration, 0, 1);
    local v28 = p26 + p24.targetOffset;
    local startPosition = p24.startPosition;
    local v29 = (startPosition + v28) * 0.5;
    local Magnitude = ((startPosition - v28) * Vector3.new(1, 0, 1)).Magnitude;
    local v30 = math.max(startPosition.Y, v28.Y) + Magnitude * 0.5;
    p24.controlPoint = Vector3.new(v29.X, v30, v29.Z);
    local v31 = 1 - v27;
    local v32 = p24.startPosition * (v31 * v31) + p24.controlPoint * (v31 * 2 * v27) + v28 * (v27 * v27);

    if v27 >= 1 then
        if not p24.arrivalSoundPlayed then
            p24.arrivalSoundPlayed = true;
            Audio.Play("rbxassetid://123886967003409", p26, 1, 1, 300);
        end;

        p24.completed = true;
    end;

    applyFadeAndScale(p24, Easing(math.clamp((v27 - 0.9) / 0.09999999999999998, 0, 1), Enum.EasingStyle.Exponential, Enum.EasingDirection.In), computeScaleAlpha(v27));

    return CFrame.new(v32) * p24.rotation;
end;

function v1.Destroy(p33) -- Line: 215
    -- upvalues: applyFadeAndScale (copy)
    applyFadeAndScale(p33, 1, 1);
    p33.completed = true;
end;

return v1;