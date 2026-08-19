-- Decompiled with Potassium's decompiler.

local v1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local SoundService = game:GetService("SoundService");
local Debris = game:GetService("Debris");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local Bloodmoon = ReplicatedStorage.Assets:WaitForChild("Bloodmoon");
local u2 = {
    Brightness = 3,
    EnvironmentDiffuseScale = 1,
    ClockTime = 3.1,
    Ambient = Color3.fromRGB(115, 45, 45),
    ColorShift_Bottom = Color3.fromRGB(171, 34, 34),
    ColorShift_Top = Color3.fromRGB(250, 19, 19),
    OutdoorAmbient = Color3.fromRGB(180, 54, 54)
};
local u3 = Color3.fromRGB(255, 20, 20);
local u4 = Color3.fromRGB(200, 40, 40);
local LaserBeam = SoundService:WaitForChild("SFX"):WaitForChild("LaserBeam");
local u5 = Color3.fromRGB(255, 30, 30);
local u6 = {
    Color3.fromRGB(255, 10, 10),
    Color3.fromRGB(220, 0, 0),
    Color3.fromRGB(180, 10, 10),
    Color3.fromRGB(255, 30, 20),
    Color3.fromRGB(150, 0, 0),
    Color3.fromRGB(255, 50, 30)
};
local Bloodmoon2 = SoundService:WaitForChild("MusicTracks"):WaitForChild("Bloodmoon");
local u7 = false;
local u8 = nil;
local u9 = nil;
local u10 = 0;
local u11 = 0;
local u12 = 0;
local u13 = 0;
local u14 = 0;
local u15 = 0;
local u16 = {};
local CurrentCamera = workspace.CurrentCamera;
local u17 = Random.new();
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
ColorCorrectionEffect.Name = "BloodmoonFlash";
ColorCorrectionEffect.Brightness = 0;
ColorCorrectionEffect.Parent = Lighting;
local Folder = Instance.new("Folder");
Folder.Name = "BloodmoonBeams";
Folder.Parent = workspace;

local function getStartPart() -- Line: 140
    -- upvalues: u8 (ref)
    if u8 then
        return u8:FindFirstChild("START_PART");
    end;

    return nil;
end;

local function getHitPointsPart() -- Line: 145
    -- upvalues: u8 (ref)
    if u8 then
        return u8:FindFirstChild("HIT_POINTS");
    end;

    return nil;
end;

local function getRandomHitOnPart(p18) -- Line: 150
    -- upvalues: u17 (copy)
    local Size = p18.Size;
    local CFrame2 = p18.CFrame;
    local v19 = u17:NextNumber(-Size.X / 2, Size.X / 2);
    local v20 = u17:NextNumber(-Size.Y / 2, Size.Y / 2);

    return CFrame2:PointToWorldSpace((Vector3.new(v19, v20, u17:NextNumber(-Size.Z / 2, Size.Z / 2))));
end;

local function getMaxLoudness() -- Line: 160
    -- upvalues: Bloodmoon2 (copy)
    local v21 = 0;

    for _, child in Bloodmoon2:GetChildren() do
        if child:IsA("Sound") and (child.IsPlaying and v21 < child.PlaybackLoudness) then
            v21 = child.PlaybackLoudness;
        end;
    end;

    return v21;
end;

local function getBeamRate(p22) -- Line: 172
    if p22 >= 170 then
        return 0.04;
    end;

    if p22 >= 130 then
        return (p22 - 130) / 40 * -0.07999999999999999 + 0.12;
    end;

    if p22 >= 80 then
        return (p22 - 80) / 50 * -0.28 + 0.4;
    end;

    return p22 < 40 and 1.5 or (p22 - 40) / 40 * -1.1 + 1.5;
end;

local function randomExplosionColor() -- Line: 189
    -- upvalues: u6 (copy), u17 (copy)
    return u6[u17:NextInteger(1, #u6)];
end;

local function lerpVector(p23, p24, p25) -- Line: 193
    return p23 + (p24 - p23) * p25;
end;

local function screenFlash() -- Line: 203
    -- upvalues: u15 (ref), ColorCorrectionEffect (copy), TweenService (copy)
    local v26 = os.clock();

    if v26 - u15 < 0.6 then
        return;
    end;

    u15 = v26;
    ColorCorrectionEffect.Brightness = 0.5;
    ColorCorrectionEffect.Saturation = -0.3;
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Brightness = 0,
        Saturation = 0
    }):Play();
end;

local function spawnBloodmoonModel() -- Line: 224
    -- upvalues: u8 (ref), Bloodmoon (copy), TweenService (copy)
    if u8 then
        return;
    end;

    u8 = Bloodmoon:Clone();
    u8.Name = "ActiveBloodmoon";
    local v27 = {};

    for _, descendant in u8:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant:GetAttribute("OGTransparency") == nil then
                descendant:SetAttribute("OGTransparency", descendant.Transparency);
            end;

            descendant.Transparency = 1;
            table.insert(v27, descendant);
        end;
    end;

    u8.Parent = workspace;
    local u28 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

    for i, v in v27 do
        task.delay(i * 0.05, function() -- Line: 245
            -- upvalues: v (copy), TweenService (ref), u28 (copy)
            if v and v.Parent then
                TweenService:Create(v, u28, {
                    Transparency = v:GetAttribute("OGTransparency")
                }):Play();
            end;
        end);
    end;
end;

local function removeBloodmoonModel() -- Line: 253
    -- upvalues: u8 (ref), TweenService (copy)
    if not u8 then
        return;
    end;

    local v29 = {};

    for _, descendant in u8:GetDescendants() do
        if descendant:IsA("BasePart") then
            table.insert(v29, descendant);
        end;
    end;

    local v30 = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.In);

    for _, v in v29 do
        TweenService:Create(v, v30, {
            Transparency = 1
        }):Play();
    end;

    local u31 = u8;
    u8 = nil;
    task.delay(2.1, function() -- Line: 270
        -- upvalues: u31 (copy)
        if u31 and u31.Parent then
            u31:Destroy();
        end;
    end);
end;

local function spawnExplosion(p32) -- Line: 281
    -- upvalues: u6 (copy), u17 (copy), Folder (copy), TweenService (copy)
    for i = 1, 16 do
        local v33 = i / 16 * 3.141592653589793 * 2;
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(5, 0.8, 5);
        Part.CFrame = CFrame.new(p32) * CFrame.Angles(0, v33, 0);
        Part.Anchored = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = u6[u17:NextInteger(1, #u6)];
        Part.Transparency = 0;
        Part.Parent = Folder;
        local v34 = 120 * (0.8 + u17:NextNumber() * 0.4);
        local v35 = u17:NextNumber(10, 25);
        local v36 = math.cos(v33) * v34;
        local v37 = math.sin(v33) * v34;
        Part.AssemblyLinearVelocity = Vector3.new(v36, v35, v37);
        local v38 = u17:NextNumber(-10, 10);
        local v39 = u17:NextNumber(-10, 10);
        Part.AssemblyAngularVelocity = Vector3.new(v38, v39, u17:NextNumber(-10, 10));
        TweenService:Create(Part, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1,
            Size = Vector3.new(0.3, 0.1, 0.3)
        }):Play();
        task.delay(1.1, function() -- Line: 316
            -- upvalues: Part (copy)
            Part:Destroy();
        end);
    end;

    for _ = 1, 10 do
        local Part = Instance.new("Part");
        Part.Size = Vector3.new(2, 2, 2) + Vector3.new(3, 3, 3) * u17:NextNumber(0, 1);
        local v40 = u17:NextNumber(-2, 2);
        local v41 = u17:NextNumber(0, 3);
        Part.Position = p32 + Vector3.new(v40, v41, u17:NextNumber(-2, 2));
        Part.Anchored = false;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = u6[u17:NextInteger(1, #u6)];
        Part.Transparency = 0;
        Part.Parent = Folder;
        local v42 = u17:NextNumber(0, 6.283185307179586);
        local v43 = 80 * (0.5 + u17:NextNumber() * 0.5);
        local v44 = math.cos(v42) * v43;
        local v45 = 80 * (0.6 + u17:NextNumber() * 0.8);
        local v46 = math.sin(v42) * v43;
        Part.AssemblyLinearVelocity = Vector3.new(v44, v45, v46);
        local v47 = u17:NextNumber(-15, 15);
        local v48 = u17:NextNumber(-15, 15);
        Part.AssemblyAngularVelocity = Vector3.new(v47, v48, u17:NextNumber(-15, 15));
        TweenService:Create(Part, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1,
            Size = Vector3.new(0.2, 0.2, 0.2)
        }):Play();
        task.delay(1.3, function() -- Line: 359
            -- upvalues: Part (copy)
            Part:Destroy();
        end);
    end;

    local Part = Instance.new("Part");
    Part.Shape = Enum.PartType.Ball;
    Part.Size = Vector3.new(17, 17, 17);
    Part.Position = p32;
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.fromRGB(255, 0, 0);
    Part.Transparency = 0;
    Part.Parent = Folder;
    TweenService:Create(Part, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(100, 100, 100),
        Transparency = 1
    }):Play();
    task.delay(0.35, function() -- Line: 384
        -- upvalues: Part (copy)
        Part:Destroy();
    end);
end;

local function positionBeamSegment(p49, p50, p51, p52) -- Line: 393
    local Magnitude = (p51 - p50).Magnitude;
    p49.Size = Vector3.new(p52, p52, Magnitude);
    p49.CFrame = CFrame.lookAt(p50, p51) * CFrame.new(0, 0, -Magnitude / 2);
end;

local function createBeamPart(p53, p54) -- Line: 399
    -- upvalues: Folder (copy)
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = p54;
    Part.Transparency = 1;
    Part.Parent = Folder;

    return Part;
end;

local function fireBeam(u55) -- Line: 413
    -- upvalues: u8 (ref), u3 (copy), Folder (copy), u4 (copy), u5 (copy), u17 (copy), u16 (ref), LaserBeam (copy), TweenService (copy), Debris (copy), spawnExplosion (copy), u12 (ref), CurrentCamera (copy), u11 (ref), u10 (ref), LocalPlayer (copy), screenFlash (copy)
    local v56;

    if u8 then
        v56 = u8:FindFirstChild("START_PART");
    else
        v56 = nil;
    end;

    if not v56 then
        return;
    end;

    local Position = v56.Position;
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = u3;
    Part.Transparency = 1;
    Part.Parent = Folder;
    local Part2 = Instance.new("Part");
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CanQuery = false;
    Part2.CanTouch = false;
    Part2.CastShadow = false;
    Part2.Material = Enum.Material.Neon;
    Part2.Color = u4;
    Part2.Transparency = 1;
    Part2.Parent = Folder;
    local v57 = u55 + Vector3.new(0, -15, 0);
    local Magnitude = (v57 - Position).Magnitude;
    Part.Size = Vector3.new(30, 30, Magnitude);
    Part.CFrame = CFrame.lookAt(Position, v57) * CFrame.new(0, 0, -Magnitude / 2);
    local Magnitude2 = (v57 - Position).Magnitude;
    Part2.Size = Vector3.new(45, 45, Magnitude2);
    Part2.CFrame = CFrame.lookAt(Position, v57) * CFrame.new(0, 0, -Magnitude2 / 2);
    local Part3 = Instance.new("Part");
    Part3.Shape = Enum.PartType.Ball;
    Part3.Size = Vector3.new(3, 3, 3);
    Part3.Position = u55;
    Part3.Anchored = true;
    Part3.CanCollide = false;
    Part3.CanQuery = false;
    Part3.CanTouch = false;
    Part3.CastShadow = false;
    Part3.Material = Enum.Material.Neon;
    Part3.Color = u5;
    Part3.Transparency = 1;
    Part3.Parent = Folder;
    local u58 = {
        alive = true,
        beam = Part,
        glow = Part2,
        startPos = Position,
        hitPos = u55,
        birthTime = os.clock(),
        seedX = u17:NextNumber(0, 100),
        seedZ = u17:NextNumber(0, 100)
    };
    table.insert(u16, u58);
    local u59 = LaserBeam:Clone();
    u59.Volume = 8;
    u59.RollOffMaxDistance = 300;
    u59.RollOffMinDistance = 20;
    u59.Parent = v56;
    u59:Play();
    u59.Ended:Once(function() -- Line: 458
        -- upvalues: u59 (copy)
        u59:Destroy();
    end);
    local Part4 = Instance.new("Part");
    Part4.Size = Vector3.new(1, 1, 1);
    Part4.Position = u55;
    Part4.Anchored = true;
    Part4.CanCollide = false;
    Part4.CanQuery = false;
    Part4.CanTouch = false;
    Part4.Transparency = 1;
    Part4.Parent = Folder;
    local v60 = LaserBeam:Clone();
    v60.Volume = 7;
    v60.PlaybackSpeed = 0.6 + u17:NextNumber() * 0.5;
    v60.RollOffMaxDistance = 200;
    v60.RollOffMinDistance = 15;
    v60.Parent = Part4;
    v60:Play();
    v60.Ended:Once(function() -- Line: 479
        -- upvalues: Part4 (copy)
        Part4:Destroy();
    end);
    local v61 = TweenInfo.new(0.06, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v62 = TweenService:Create(Part, v61, {
        Transparency = 0
    });
    v62:Play();
    Debris:AddItem(v62, v61.Time);
    local v63 = TweenService:Create(Part2, v61, {
        Transparency = 0.5
    });
    v63:Play();
    Debris:AddItem(v63, v61.Time);
    local v64 = TweenService:Create(Part3, v61, {
        Transparency = 0.1
    });
    v64:Play();
    Debris:AddItem(v64, v61.Time);
    task.delay(0.06, function() -- Line: 495
        -- upvalues: TweenService (ref), Part3 (copy), Debris (ref), spawnExplosion (ref), u55 (copy)
        local v65 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
        local v66 = TweenService:Create(Part3, v65, {
            Size = Vector3.new(12, 12, 12),
            Transparency = 0.5
        });
        v66:Play();
        Debris:AddItem(v66, v65.Time);
        spawnExplosion(u55);
    end);
    task.delay(0.31, function() -- Line: 506
        -- upvalues: TweenService (ref), Part (copy), Debris (ref), Part2 (copy), Part3 (copy), u58 (copy), u16 (ref)
        local v67 = TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.In);
        local v68 = TweenService:Create(Part, v67, {
            Transparency = 1
        });
        v68:Play();
        Debris:AddItem(v68, v67.Time);
        local v69 = TweenService:Create(Part2, v67, {
            Transparency = 1
        });
        v69:Play();
        Debris:AddItem(v69, v67.Time);
        local v70 = TweenService:Create(Part3, v67, {
            Transparency = 1
        });
        v70:Play();
        Debris:AddItem(v70, v67.Time);
        task.delay(0.4, function() -- Line: 518
            -- upvalues: u58 (ref)
            u58.alive = false;
        end);
        task.delay(0.9, function() -- Line: 522
            -- upvalues: Part (ref), Part2 (ref), Part3 (ref), u16 (ref), u58 (ref)
            Part:Destroy();
            Part2:Destroy();
            Part3:Destroy();

            for i = #u16, 1, -1 do
                if u16[i] == u58 then
                    table.remove(u16, i);

                    return;
                end;
            end;
        end);
    end);
    local v71 = math.clamp(u12 / 170, 0, 1) * 2.2 + 0.8;
    local Magnitude3 = (CurrentCamera.CFrame.Position - u55).Magnitude;

    if Magnitude3 <= 60 then
        local v72 = 1 - Magnitude3 / 60;
        u11 = math.max(u11, v71 * v72 * v72);
        u10 = os.clock() + 0.3;
    end;

    local Character = LocalPlayer.Character;

    if Character then
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart");

        if HumanoidRootPart and (HumanoidRootPart.Position - u55).Magnitude <= 50 then
            screenFlash();
        end;
    end;
end;

local function updateBeamWiggles(p73) -- Line: 562
    -- upvalues: u16 (ref)
    for _, v in u16 do
        if v.alive and (v.beam.Parent and v.glow.Parent) then
            local v74 = (p73 - v.birthTime) * 12;
            local v75 = math.sin(v74 + v.seedX) * 8;
            local v76 = math.cos(v74 * 0.7 + v.seedZ) * 8;
            local v77 = math.sin(v74 * 1.3 + v.seedX + 2) * 2;
            local v78 = math.cos(v74 * 0.9 + v.seedZ + 2) * 2;
            local v79 = v.startPos + Vector3.new(v77, 0, v78);
            local v80 = v.hitPos + Vector3.new(v75, -15, v76);
            local beam = v.beam;
            local Magnitude = (v80 - v79).Magnitude;
            beam.Size = Vector3.new(30, 30, Magnitude);
            beam.CFrame = CFrame.lookAt(v79, v80) * CFrame.new(0, 0, -Magnitude / 2);
            local glow = v.glow;
            local Magnitude2 = (v80 - v79).Magnitude;
            glow.Size = Vector3.new(45, 45, Magnitude2);
            glow.CFrame = CFrame.lookAt(v79, v80) * CFrame.new(0, 0, -Magnitude2 / 2);
        end;
    end;
end;

local function startUpdateLoop() -- Line: 588
    -- upvalues: u9 (ref), u13 (ref), u14 (ref), u15 (ref), RunService (copy), u12 (ref), getMaxLoudness (copy), FieldOfViewController (copy), updateBeamWiggles (copy), u10 (ref), u11 (ref), CurrentCamera (copy)
    if u9 then
        return;
    end;

    u13 = os.clock();
    u14 = os.clock();
    u15 = 0;
    u9 = RunService.RenderStepped:Connect(function(p81) -- Line: 595
        -- upvalues: u12 (ref), getMaxLoudness (ref), FieldOfViewController (ref), updateBeamWiggles (ref), u10 (ref), u11 (ref), CurrentCamera (ref)
        local v82 = os.clock();
        u12 = getMaxLoudness();
        FieldOfViewController:SetAdjuster(math.clamp((u12 - 40) / 130, 0, 1) * 15);
        updateBeamWiggles(v82);

        if v82 < u10 and u11 > 0 then
            local v83 = u11 * ((u10 - v82) / 0.3);
            local v84 = math.sin(v82 * 30 * 6.28) * v83;
            local v85 = math.cos(v82 * 30 * 4.17) * v83;
            local v86 = math.sin(v82 * 30 * 5.23 + 1) * v83 * 0.5;
            CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(v84, v85, v86);
        end;
    end);
end;

local function stopUpdateLoop() -- Line: 630
    -- upvalues: u9 (ref), u11 (ref), u16 (ref), FieldOfViewController (copy)
    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u11 = 0;
    u16 = {};
    FieldOfViewController:ClearAdjuster();
end;

function v1.Start(p87, p88, p89) -- Line: 644
    -- upvalues: u7 (ref), NotificationController (copy), LightingController (copy), u2 (copy), spawnBloodmoonModel (copy), u9 (ref), u13 (ref), u14 (ref), u15 (ref), RunService (copy), u12 (ref), getMaxLoudness (copy), FieldOfViewController (copy), updateBeamWiggles (copy), u10 (ref), u11 (ref), CurrentCamera (copy)
    if u7 then
        return;
    end;

    u7 = true;
    NotificationController:CreateNotification("A blood moon is rising...");
    LightingController:TransitionTo(u2);
    spawnBloodmoonModel();

    if u9 then
        return;
    end;

    u13 = os.clock();
    u14 = os.clock();
    u15 = 0;
    u9 = RunService.RenderStepped:Connect(function(p90) -- Line: 595
        -- upvalues: u12 (ref), getMaxLoudness (ref), FieldOfViewController (ref), updateBeamWiggles (ref), u10 (ref), u11 (ref), CurrentCamera (ref)
        local v91 = os.clock();
        u12 = getMaxLoudness();
        FieldOfViewController:SetAdjuster(math.clamp((u12 - 40) / 130, 0, 1) * 15);
        updateBeamWiggles(v91);

        if v91 < u10 and u11 > 0 then
            local v92 = u11 * ((u10 - v91) / 0.3);
            local v93 = math.sin(v91 * 30 * 6.28) * v92;
            local v94 = math.cos(v91 * 30 * 4.17) * v92;
            local v95 = math.sin(v91 * 30 * 5.23 + 1) * v92 * 0.5;
            CurrentCamera.CFrame = CurrentCamera.CFrame * CFrame.new(v93, v94, v95);
        end;
    end);
end;

function v1.End(p96) -- Line: 654
    -- upvalues: u7 (ref), TweenService (copy), ColorCorrectionEffect (copy), removeBloodmoonModel (copy), u9 (ref), u11 (ref), u16 (ref), FieldOfViewController (copy), Folder (copy)
    if not u7 then
        return;
    end;

    u7 = false;
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1, Enum.EasingStyle.Sine), {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
    }):Play();
    removeBloodmoonModel();

    if u9 then
        u9:Disconnect();
        u9 = nil;
    end;

    u11 = 0;
    u16 = {};
    FieldOfViewController:ClearAdjuster();
    task.delay(1.3, function() -- Line: 668
        -- upvalues: Folder (ref)
        for _, child in Folder:GetChildren() do
            child:Destroy();
        end;
    end);
end;

Networking.WeatherEffects.BloodmoonBeam.OnClientEvent:Connect(function(p97) -- Line: 679
    -- upvalues: u7 (ref), fireBeam (copy)
    if u7 then
        fireBeam(p97);
    end;
end);

return v1;