-- Decompiled with Potassium's decompiler.

local u1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local Baseplate = game.Workspace.Baseplate;

local function getGrass() -- Line: 20
    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Middle");
    end;

    if Map then
        Map = Map:FindFirstChild("Grass");
    end;

    return Map;
end;

local u2 = {};
PhysicalProperties.new(0.919, 0.01, 0.15, 100, 1);
local u3 = Color3.fromRGB(255, 255, 255);
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local Snowfall = ReplicatedStorage.Assets:WaitForChild("Snowfall");
local u4 = {
    Brightness = 2,
    EnvironmentDiffuseScale = 1,
    ClockTime = 0,
    Ambient = Color3.fromRGB(57, 121, 131),
    ColorShift_Bottom = Color3.fromRGB(35, 135, 171),
    ColorShift_Top = Color3.fromRGB(59, 158, 250),
    OutdoorAmbient = Color3.fromRGB(74, 139, 180)
};
local u5 = Color3.fromRGB(100, 200, 255);
local u6 = Color3.fromRGB(60, 150, 220);
local LaserBeam = SoundService:WaitForChild("SFX"):WaitForChild("LaserBeam");
local u7 = Color3.fromRGB(120, 210, 255);
local u8 = {
    Color3.fromRGB(100, 200, 255),
    Color3.fromRGB(150, 220, 255),
    Color3.fromRGB(60, 170, 240),
    Color3.fromRGB(180, 230, 255),
    Color3.fromRGB(40, 140, 220),
    Color3.fromRGB(200, 240, 255)
};
local Snowfall2 = SoundService:WaitForChild("MusicTracks"):WaitForChild("Snowfall");
local u9 = false;
local u10 = {};
local u11 = nil;
local u12 = nil;
local u13 = 0;
local u14 = 0;
local u15 = 0;
local u16 = 0;
local u17 = {};
local _ = workspace.CurrentCamera;
local u18 = Random.new();
local Folder = Instance.new("Folder");
Folder.Name = "BlizzardBeams";
Folder.Parent = workspace;

local function getStartPart() -- Line: 168
    -- upvalues: u11 (ref)
    if u11 then
        return u11:FindFirstChild("START_PART");
    end;

    return nil;
end;

local function getHitPointsPart() -- Line: 173
    -- upvalues: u11 (ref)
    if u11 then
        return u11:FindFirstChild("HIT_POINTS");
    end;

    return nil;
end;

local function getRandomHitOnPart(p19) -- Line: 178
    -- upvalues: u18 (copy)
    local Size = p19.Size;
    local CFrame2 = p19.CFrame;
    local v20 = u18:NextNumber(-Size.X / 2, Size.X / 2);
    local v21 = u18:NextNumber(-Size.Y / 2, Size.Y / 2);

    return CFrame2:PointToWorldSpace((Vector3.new(v20, v21, u18:NextNumber(-Size.Z / 2, Size.Z / 2))));
end;

local function getMaxLoudness() -- Line: 188
    -- upvalues: Snowfall2 (copy)
    local v22 = 0;

    for _, child in Snowfall2:GetChildren() do
        if child:IsA("Sound") and (child.IsPlaying and v22 < child.PlaybackLoudness) then
            v22 = child.PlaybackLoudness;
        end;
    end;

    return v22;
end;

local function getBeamRate(p23) -- Line: 200
    if p23 >= 170 then
        return 0.04;
    end;

    if p23 >= 130 then
        return (p23 - 130) / 40 * -0.07999999999999999 + 0.12;
    end;

    if p23 >= 80 then
        return (p23 - 80) / 50 * -0.28 + 0.4;
    end;

    return p23 < 40 and 1.5 or (p23 - 40) / 40 * -1.1 + 1.5;
end;

local function randomExplosionColor() -- Line: 217
    -- upvalues: u8 (copy), u18 (copy)
    return u8[u18:NextInteger(1, #u8)];
end;

local function lerpVector(p24, p25, p26) -- Line: 221
    return p24 + (p25 - p24) * p26;
end;

local function applyBlizzardToBaseplate() -- Line: 229
    -- upvalues: u2 (copy), u3 (copy), RunService (copy), Baseplate (copy)
    local u27 = os.clock();
    local u28 = 0;

    local function recolor(p29) -- Line: 236
        -- upvalues: u2 (ref), u3 (ref), u28 (ref), u27 (ref), RunService (ref)
        if p29:IsA("BasePart") then
            u2[p29] = {
                Color = p29.Color
            };
            p29.Color = u3;
            u28 = u28 + 1;

            if u28 >= 50 and os.clock() - u27 >= 0.004 then
                RunService.Heartbeat:Wait();
                u27 = os.clock();
                u28 = 0;
            end;
        end;
    end;

    for _, child in Baseplate:GetChildren() do
        recolor(child);
    end;

    local Map = workspace:FindFirstChild("Map");

    if Map then
        Map = Map:FindFirstChild("Middle");
    end;

    if Map then
        Map = Map:FindFirstChild("Grass");
    end;

    if Map then
        for _, descendant in Map:GetDescendants() do
            recolor(descendant);
        end;
    end;
end;

local function restoreBaseplate() -- Line: 262
    -- upvalues: u2 (copy)
    for i, v in u2 do
        if i and i.Parent then
            i.Color = v.Color;
        end;
    end;

    table.clear(u2);
end;

local u30 = nil;
local u31 = false;

local function saveLighting() -- Line: 278
    -- upvalues: u31 (ref), u10 (copy), Lighting (copy)
    if u31 then
        return;
    end;

    u31 = true;
    u10.Ambient = Lighting.Ambient;
    u10.Brightness = Lighting.Brightness;
    u10.ColorShift_Bottom = Lighting.ColorShift_Bottom;
    u10.ColorShift_Top = Lighting.ColorShift_Top;
    u10.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale;
    u10.OutdoorAmbient = Lighting.OutdoorAmbient;
    u10.ClockTime = Lighting.ClockTime;
    u10.ExposureCompensation = Lighting.ExposureCompensation;
end;

local function applyBlizzardLighting() -- Line: 292
    -- upvalues: u30 (ref), TweenService (copy), Lighting (copy), u4 (copy)
    if u30 then
        u30:Cancel();
    end;

    u30 = TweenService:Create(Lighting, TweenInfo.new(3, Enum.EasingStyle.Sine), {
        Ambient = u4.Ambient,
        Brightness = u4.Brightness,
        ColorShift_Bottom = u4.ColorShift_Bottom,
        ColorShift_Top = u4.ColorShift_Top,
        EnvironmentDiffuseScale = u4.EnvironmentDiffuseScale,
        OutdoorAmbient = u4.OutdoorAmbient,
        ClockTime = u4.ClockTime
    });
    u30:Play();
end;

local function restoreLighting() -- Line: 307
    -- upvalues: u31 (ref), u30 (ref), TweenService (copy), Lighting (copy), u10 (copy)
    if not u31 then
        return;
    end;

    if u30 then
        u30:Cancel();
    end;

    u30 = TweenService:Create(Lighting, TweenInfo.new(3, Enum.EasingStyle.Sine), {
        Ambient = u10.Ambient,
        Brightness = u10.Brightness,
        ColorShift_Bottom = u10.ColorShift_Bottom,
        ColorShift_Top = u10.ColorShift_Top,
        EnvironmentDiffuseScale = u10.EnvironmentDiffuseScale,
        OutdoorAmbient = u10.OutdoorAmbient,
        ClockTime = u10.ClockTime
    });
    u30:Play();
    u31 = false;
end;

local function screenFlash() -- Line: 328
    -- upvalues: TweenService (copy)
    local v32 = os.clock();

    if v32 - lastFlashTime < 0.3 then
        return;
    end;

    lastFlashTime = v32;
    colorCorrection.Brightness = FLASH_BRIGHTNESS;
    colorCorrection.Saturation = -0.5;
    colorCorrection.TintColor = Color3.fromRGB(180, 220, 255);
    local v33 = TweenInfo.new(FLASH_FADE_TIME, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out);
    TweenService:Create(colorCorrection, v33, {
        Brightness = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
end;

local function spawnBlizzardModel() -- Line: 349
    -- upvalues: u11 (ref), Snowfall (copy), TweenService (copy)
    if u11 then
        return;
    end;

    u11 = Snowfall:Clone();
    u11.Name = "ActiveBlizzard";
    local v34 = {};

    for _, descendant in u11:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("OGTransparency") == nil then
                descendant:SetAttribute("OGTransparency", descendant.Transparency);
            end;

            descendant.Transparency = 1;
            table.insert(v34, descendant);
        end;
    end;

    u11.Parent = workspace;
    local u35 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

    for i, v in v34 do
        task.delay(i * 0.05, function() -- Line: 370
            -- upvalues: v (copy), TweenService (ref), u35 (copy)
            if v and v.Parent then
                TweenService:Create(v, u35, {
                    Transparency = v:GetAttribute("OGTransparency")
                }):Play();
            end;
        end);
    end;
end;

local function removeBlizzardModel() -- Line: 378
    -- upvalues: u11 (ref), TweenService (copy)
    if not u11 then
        return;
    end;

    local v36 = {};

    for _, descendant in u11:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v36, descendant);
        end;
    end;

    local v37 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In);

    for _, v in v36 do
        TweenService:Create(v, v37, {
            Transparency = 1
        }):Play();
    end;

    local u38 = u11;
    u11 = nil;
    task.delay(2.1, function() -- Line: 395
        -- upvalues: u38 (copy)
        if u38 and u38.Parent then
            u38:Destroy();
        end;
    end);
end;

local function spawnExplosion(p39) -- Line: 406
    -- upvalues: u8 (copy), u18 (copy), Folder (copy), TweenService (copy)
    for i = 1, 16 do
        local v40 = i / 16 * 3.141592653589793 * 2;
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(5, 0.8, 5);
        Part.CFrame = CFrame.new(p39) * CFrame.Angles(0, v40, 0);
        Part.Anchored = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = u8[u18:NextInteger(1, #u8)];
        Part.Transparency = 0;
        Part.Parent = Folder;
        local v41 = 120 * (0.8 + u18:NextNumber() * 0.4);
        local v42 = u18:NextNumber(10, 25);
        local v43 = math.cos(v40) * v41;
        local v44 = math.sin(v40) * v41;
        Part.AssemblyLinearVelocity = Vector3.new(v43, v42, v44);
        local v45 = u18:NextNumber(-10, 10);
        local v46 = u18:NextNumber(-10, 10);
        Part.AssemblyAngularVelocity = Vector3.new(v45, v46, u18:NextNumber(-10, 10));
        TweenService:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1,
            Size = Vector3.new(0.3, 0.1, 0.3)
        }):Play();
        task.delay(1.1, function() -- Line: 442
            -- upvalues: Part (copy)
            Part:Destroy();
        end);
    end;

    for _ = 1, 10 do
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(2, 2, 2) + Vector3.new(3, 3, 3) * u18:NextNumber(0, 1);
        local v47 = u18:NextNumber(-2, 2);
        local v48 = u18:NextNumber(0, 3);
        Part.Position = p39 + Vector3.new(v47, v48, u18:NextNumber(-2, 2));
        Part.Anchored = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = u8[u18:NextInteger(1, #u8)];
        Part.Transparency = 0;
        Part.Parent = Folder;
        local v49 = u18:NextNumber(0, 6.283185307179586);
        local v50 = 80 * (0.5 + u18:NextNumber() * 0.5);
        local v51 = math.cos(v49) * v50;
        local v52 = 80 * (0.6 + u18:NextNumber() * 0.8);
        local v53 = math.sin(v49) * v50;
        Part.AssemblyLinearVelocity = Vector3.new(v51, v52, v53);
        local v54 = u18:NextNumber(-15, 15);
        local v55 = u18:NextNumber(-15, 15);
        Part.AssemblyAngularVelocity = Vector3.new(v54, v55, u18:NextNumber(-15, 15));
        TweenService:Create(Part, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2)
        }):Play();
        task.delay(1.3, function() -- Line: 486
            -- upvalues: Part (copy)
            Part:Destroy();
        end);
    end;

    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Ball;
    Part.Size = Vector3.new(17, 17, 17);
    Part.Position = p39;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.fromRGB(150, 220, 255);
    Part.Transparency = 0;
    Part.Parent = Folder;
    TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(100, 100, 100),
        Transparency = 1
    }):Play();
    task.delay(0.35, function() -- Line: 512
        -- upvalues: Part (copy)
        Part:Destroy();
    end);
end;

local function positionBeamSegment(p56, p57, p58, p59) -- Line: 521
    local Magnitude = (p58 - p57).Magnitude;
    p56.Size = Vector3.new(p59, p59, Magnitude);
    p56.CFrame = CFrame.lookAt(p57, p58) * CFrame.new(0, 0, -Magnitude / 2);
end;

local function createBeamPart(p60, p61) -- Line: 527
    -- upvalues: Folder (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = p61;
    Part.Transparency = 1;
    Part.Parent = Folder;

    return Part;
end;

local function fireBeam(u62) -- Line: 541
    -- upvalues: u11 (ref), u5 (copy), Folder (copy), u6 (copy), u7 (copy), u18 (copy), u17 (ref), LaserBeam (copy), TweenService (copy), spawnExplosion (copy), LocalPlayer (copy)
    local v63;

    if u11 then
        v63 = u11:FindFirstChild("START_PART");
    else
        v63 = nil;
    end;

    if not v63 then
        return;
    end;

    local Position = v63.Position;
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = u5;
    Part.Transparency = 1;
    Part.Parent = Folder;
    local Part2 = Instance.new("Part");
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CanQuery = false;
    Part2.CanTouch = false;
    Part2.CastShadow = false;
    Part2.Material = Enum.Material.Neon;
    Part2.Color = u6;
    Part2.Transparency = 1;
    Part2.Parent = Folder;
    local v64 = u62 + Vector3.new(0, -15, 0);
    local Magnitude = (v64 - Position).Magnitude;
    Part.Size = Vector3.new(30, 30, Magnitude);
    Part.CFrame = CFrame.lookAt(Position, v64) * CFrame.new(0, 0, -Magnitude / 2);
    local Magnitude2 = (v64 - Position).Magnitude;
    Part2.Size = Vector3.new(45, 45, Magnitude2);
    Part2.CFrame = CFrame.lookAt(Position, v64) * CFrame.new(0, 0, -Magnitude2 / 2);
    local Part3 = Instance.new("Part");
    Part3.Shape = Enum.PartType.Ball;
    Part3.Size = Vector3.new(3, 3, 3);
    Part3.Position = u62;
    Part3.Anchored = true;
    Part3.CanCollide = false;
    Part3.CanQuery = false;
    Part3.CanTouch = false;
    Part3.CastShadow = false;
    Part3.Material = Enum.Material.Neon;
    Part3.Color = u7;
    Part3.Transparency = 1;
    Part3.Parent = Folder;
    local u65 = {
        alive = true,
        beam = Part,
        glow = Part2,
        startPos = Position,
        hitPos = u62,
        birthTime = os.clock(),
        seedX = u18:NextNumber(0, 100),
        seedZ = u18:NextNumber(0, 100)
    };
    table.insert(u17, u65);
    local u66 = LaserBeam:Clone();
    u66.Volume = 8;
    u66.RollOffMaxDistance = 300;
    u66.RollOffMinDistance = 20;
    u66.Parent = v63;
    u66:Play();
    u66.Ended:Once(function() -- Line: 590
        -- upvalues: u66 (copy)
        u66:Destroy();
    end);
    local Part4 = Instance.new("Part");
    Part4.Size = Vector3.new(1, 1, 1);
    Part4.Position = u62;
    Part4.Anchored = true;
    Part4.CanCollide = false;
    Part4.CanQuery = false;
    Part4.CanTouch = false;
    Part4.Transparency = 1;
    Part4.Parent = Folder;
    local v67 = LaserBeam:Clone();
    v67.Volume = 7;
    v67.PlaybackSpeed = 0.6 + u18:NextNumber() * 0.5;
    v67.RollOffMaxDistance = 200;
    v67.RollOffMinDistance = 15;
    v67.Parent = Part4;
    v67:Play();
    v67.Ended:Once(function() -- Line: 612
        -- upvalues: Part4 (copy)
        Part4:Destroy();
    end);
    local v68 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    TweenService:Create(Part, v68, {
        Transparency = 0
    }):Play();
    TweenService:Create(Part2, v68, {
        Transparency = 0.5
    }):Play();
    TweenService:Create(Part3, v68, {
        Transparency = 0.1
    }):Play();
    task.delay(0.06, function() -- Line: 623
        -- upvalues: TweenService (ref), Part3 (copy), spawnExplosion (ref), u62 (copy)
        TweenService:Create(Part3, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = Vector3.new(12, 12, 12),
            Transparency = 0.5
        }):Play();
        spawnExplosion(u62);
    end);
    task.delay(0.31, function() -- Line: 634
        -- upvalues: TweenService (ref), Part (copy), Part2 (copy), Part3 (copy), u65 (copy), u17 (ref)
        local v69 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        TweenService:Create(Part, v69, {
            Transparency = 1
        }):Play();
        TweenService:Create(Part2, v69, {
            Transparency = 1
        }):Play();
        TweenService:Create(Part3, v69, {
            Transparency = 1
        }):Play();
        task.delay(0.4, function() -- Line: 640
            -- upvalues: u65 (ref)
            u65.alive = false;
        end);
        task.delay(0.9, function() -- Line: 644
            -- upvalues: Part (ref), Part2 (ref), Part3 (ref), u17 (ref), u65 (ref)
            Part:Destroy();
            Part2:Destroy();
            Part3:Destroy();

            for i = #u17, 1, -1 do
                if u17[i] == u65 then
                    table.remove(u17, i);

                    return;
                end;
            end;
        end);
    end);
    local Character = LocalPlayer.Character;
    local v70 = Character and Character:FindFirstChild("HumanoidRootPart");

    if v70 then
        local Magnitude3 = (v70.Position - u62).Magnitude;

        if Magnitude3 <= 25 then
            local v71 = 1 - Magnitude3 / 25;
            local v72 = 120 * v71 * v71;
            local v73 = v70.Position - u62;
            local v74 = Vector3.new(v73.X, 0, v73.Z);
            local v75;

            if v74.Magnitude > 0.1 then
                v75 = v74.Unit;
            else
                local v76 = u18:NextNumber(-1, 1);
                v75 = Vector3.new(v76, 0, u18:NextNumber(-1, 1)).Unit;
            end;

            v70.AssemblyLinearVelocity = Vector3.new(v75.X * v72 * 0.5, v72, v75.Z * v72 * 0.5);
        end;
    end;
end;

local function updateBeamWiggles(p77) -- Line: 690
    -- upvalues: u17 (ref)
    for _, v in u17 do
        if v.alive and (v.beam.Parent and v.glow.Parent) then
            local v78 = (p77 - v.birthTime) * 12;
            local v79 = math.sin(v78 + v.seedX) * 8;
            local v80 = math.cos(v78 * 0.7 + v.seedZ) * 8;
            local v81 = math.sin(v78 * 1.3 + v.seedX + 2) * 2;
            local v82 = math.cos(v78 * 0.9 + v.seedZ + 2) * 2;
            local v83 = v.startPos + Vector3.new(v81, 0, v82);
            local v84 = v.hitPos + Vector3.new(v79, -15, v80);
            local beam = v.beam;
            local Magnitude = (v84 - v83).Magnitude;
            beam.Size = Vector3.new(30, 30, Magnitude);
            beam.CFrame = CFrame.lookAt(v83, v84) * CFrame.new(0, 0, -Magnitude / 2);
            local glow = v.glow;
            local Magnitude2 = (v84 - v83).Magnitude;
            glow.Size = Vector3.new(45, 45, Magnitude2);
            glow.CFrame = CFrame.lookAt(v83, v84) * CFrame.new(0, 0, -Magnitude2 / 2);
        end;
    end;
end;

local function startUpdateLoop() -- Line: 716
    -- upvalues: u12 (ref), u15 (ref), u16 (ref), RunService (copy), u14 (ref), getMaxLoudness (copy), u11 (ref), getRandomHitOnPart (copy), fireBeam (copy), updateBeamWiggles (copy)
    if u12 then
        return;
    end;

    u15 = os.clock();
    u16 = os.clock();
    lastFlashTime = 0;
    u12 = RunService.RenderStepped:Connect(function(p85) -- Line: 724
        -- upvalues: u14 (ref), getMaxLoudness (ref), u16 (ref), u15 (ref), u11 (ref), getRandomHitOnPart (ref), fireBeam (ref), updateBeamWiggles (ref)
        debug.profilebegin("Controllers/WeatherController/Snowfall/RenderStepped");
        local v86 = os.clock();
        u14 = getMaxLoudness();

        if v86 - u16 >= 0.5 then
            u16 = v86;

            if u14 < 170 and (u14 < 130 and u14 < 80) then
                local _ = u14 >= 40;
            end;
        end;

        local v87 = u14;
        local v88;

        if v87 >= 170 then
            v88 = 0.04;
        elseif v87 >= 130 then
            v88 = (v87 - 130) / 40 * -0.07999999999999999 + 0.12;
        elseif v87 >= 80 then
            v88 = (v87 - 80) / 50 * -0.28 + 0.4;
        else
            v88 = v87 < 40 and 1.5 or (v87 - 40) / 40 * -1.1 + 1.5;
        end;

        if v88 <= v86 - u15 then
            u15 = v86;
            local v89;

            if u11 then
                v89 = u11:FindFirstChild("HIT_POINTS");
            else
                v89 = nil;
            end;

            if v89 then
                fireBeam((getRandomHitOnPart(v89)));
            end;
        end;

        local _ = math.clamp((u14 - 40) / 130, 0, 1) * 15;
        updateBeamWiggles(v86);
        debug.profileend();
    end);
end;

local function stopUpdateLoop() -- Line: 769
    -- upvalues: u12 (ref), u13 (ref), u17 (ref)
    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    u13 = 0;
    u17 = {};
end;

function u1.StartWeather() -- Line: 782
    -- upvalues: u9 (ref), NotificationController (copy), u31 (ref), u10 (copy), Lighting (copy), applyBlizzardLighting (copy), applyBlizzardToBaseplate (copy), spawnBlizzardModel (copy), u12 (ref), u15 (ref), u16 (ref), RunService (copy), u14 (ref), getMaxLoudness (copy), u11 (ref), getRandomHitOnPart (copy), fireBeam (copy), updateBeamWiggles (copy)
    if u9 then
        return;
    end;

    u9 = true;
    NotificationController:CreateNotification("A blizzard is approaching... ❄️");

    if not u31 then
        u31 = true;
        u10.Ambient = Lighting.Ambient;
        u10.Brightness = Lighting.Brightness;
        u10.ColorShift_Bottom = Lighting.ColorShift_Bottom;
        u10.ColorShift_Top = Lighting.ColorShift_Top;
        u10.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale;
        u10.OutdoorAmbient = Lighting.OutdoorAmbient;
        u10.ClockTime = Lighting.ClockTime;
        u10.ExposureCompensation = Lighting.ExposureCompensation;
    end;

    applyBlizzardLighting();
    applyBlizzardToBaseplate();
    spawnBlizzardModel();

    if u12 then
        return;
    end;

    u15 = os.clock();
    u16 = os.clock();
    lastFlashTime = 0;
    u12 = RunService.RenderStepped:Connect(function(p90) -- Line: 724
        -- upvalues: u14 (ref), getMaxLoudness (ref), u16 (ref), u15 (ref), u11 (ref), getRandomHitOnPart (ref), fireBeam (ref), updateBeamWiggles (ref)
        debug.profilebegin("Controllers/WeatherController/Snowfall/RenderStepped");
        local v91 = os.clock();
        u14 = getMaxLoudness();

        if v91 - u16 >= 0.5 then
            u16 = v91;

            if u14 < 170 and (u14 < 130 and u14 < 80) then
                local _ = u14 >= 40;
            end;
        end;

        local v92 = u14;
        local v93;

        if v92 >= 170 then
            v93 = 0.04;
        elseif v92 >= 130 then
            v93 = (v92 - 130) / 40 * -0.07999999999999999 + 0.12;
        elseif v92 >= 80 then
            v93 = (v92 - 80) / 50 * -0.28 + 0.4;
        else
            v93 = v92 < 40 and 1.5 or (v92 - 40) / 40 * -1.1 + 1.5;
        end;

        if v93 <= v91 - u15 then
            u15 = v91;
            local v94;

            if u11 then
                v94 = u11:FindFirstChild("HIT_POINTS");
            else
                v94 = nil;
            end;

            if v94 then
                fireBeam((getRandomHitOnPart(v94)));
            end;
        end;

        local _ = math.clamp((u14 - 40) / 130, 0, 1) * 15;
        updateBeamWiggles(v91);
        debug.profileend();
    end);
end;

function u1.EndWeather() -- Line: 794
    -- upvalues: u9 (ref), restoreLighting (copy), u2 (copy), removeBlizzardModel (copy), u12 (ref), u13 (ref), u17 (ref), Folder (copy)
    if not u9 then
        return;
    end;

    u9 = false;
    restoreLighting();

    for i, v in u2 do
        if i and i.Parent then
            i.Color = v.Color;
        end;
    end;

    table.clear(u2);
    removeBlizzardModel();

    if u12 then
        u12:Disconnect();
        u12 = nil;
    end;

    u13 = 0;
    u17 = {};
    task.delay(1.3, function() -- Line: 803
        -- upvalues: Folder (ref)
        for _, child in Folder:GetChildren() do
            child:Destroy();
        end;
    end);
end;

Networking.WeatherEffects.BlizzardStart.OnClientEvent:Connect(function() -- Line: 814
    -- upvalues: u1 (copy)
    u1.StartWeather();
end);
Networking.WeatherEffects.BlizzardEnd.OnClientEvent:Connect(function() -- Line: 818
    -- upvalues: u1 (copy)
    u1.EndWeather();
end);
Networking.WeatherEffects.BlizzardBeam.OnClientEvent:Connect(function(p95) -- Line: 823
    -- upvalues: u9 (ref), fireBeam (copy)
    if u9 then
        fireBeam(p95);
    end;
end);

return u1;