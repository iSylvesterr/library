-- Decompiled with Potassium's decompiler.

local u1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);

local function profileBegin(p2) -- Line: 28
    debug.profilebegin("Controllers/WeatherController/Lightning/" .. p2);
end;

local function profileEnd() -- Line: 32
    debug.profileend();
end;

local u3 = false;
local u4 = {};
local u5 = nil;
local u6 = nil;
local u7 = {};
local u8 = 0;
local CurrentCamera = workspace.CurrentCamera;
local u9 = Random.new();
local Rain = game.SoundService.WeatherSFX.Rain;
Rain.Looped = true;
local Lightning = game.SoundService.WeatherSFX.Lightning;
local u10 = RaycastParams.new();
u10.FilterDescendantsInstances = { workspace.Terrain, workspace };
u10.FilterType = Enum.RaycastFilterType.Include;
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
ColorCorrectionEffect.Name = "LightningEffect";
ColorCorrectionEffect.Parent = Lighting;
local Folder = Instance.new("Folder");
Folder.Name = "LightningEffects";
Folder.Parent = workspace;
local Folder2 = Instance.new("Folder");
Folder2.Name = "StormRainDrops";
Folder2.Parent = workspace;
local Folder3 = Instance.new("Folder");
Folder3.Name = "StormSplashes";
Folder3.Parent = workspace;

local function createDropTemplate() -- Line: 84
    local Part = Instance.new("Part");
    Part.Name = "RainDrop";
    Part.Size = Vector3.new(0.12, 2.8, 0.12);
    Part.Material = Enum.Material.Neon;
    Part.Color = Color3.fromRGB(100, 150, 255);
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CastShadow = false;
    Part.Transparency = 0.2;

    return Part;
end;

local Part = Instance.new("Part");
Part.Name = "RainDrop";
Part.Size = Vector3.new(0.12, 2.8, 0.12);
Part.Material = Enum.Material.Neon;
Part.Color = Color3.fromRGB(100, 150, 255);
Part.Anchored = true;
Part.CanCollide = false;
Part.CastShadow = false;
Part.Transparency = 0.2;
local u11 = (function() -- Line: 97, Name: createSplashTemplate
    local Part2 = Instance.new("Part");
    Part2.Name = "Splash";
    Part2.Size = Vector3.new(0.1, 0.1, 0.1);
    Part2.Material = Enum.Material.Neon;
    Part2.Color = Color3.fromRGB(120, 170, 255);
    Part2.Anchored = false;
    Part2.CanCollide = false;
    Part2.CastShadow = false;
    Part2.Transparency = 0.3;
    Part2.Shape = Enum.PartType.Ball;

    return Part2;
end)();
local u12 = {};
local u13 = 0;

local function getDrop() -- Line: 118
    -- upvalues: u13 (ref), u12 (copy), Part (copy)
    if u13 <= 0 then
        return Part:Clone();
    end;

    local v14 = u12[u13];
    u12[u13] = nil;
    u13 = u13 - 1;

    return v14;
end;

local function returnDrop(p15) -- Line: 128
    -- upvalues: u13 (ref), u12 (copy)
    p15.Parent = nil;
    u13 = u13 + 1;
    u12[u13] = p15;
end;

local u16 = {};
local u17 = 0;

local function getSplash() -- Line: 138
    -- upvalues: u17 (ref), u16 (copy), u11 (copy)
    if u17 <= 0 then
        return u11:Clone();
    end;

    local v18 = u16[u17];
    u16[u17] = nil;
    u17 = u17 - 1;

    return v18;
end;

local function returnSplash(p19) -- Line: 148
    -- upvalues: u17 (ref), u16 (copy)
    p19.Parent = nil;
    p19.Anchored = true;
    u17 = u17 + 1;
    u16[u17] = p19;
end;

local function createSplash(p20) -- Line: 156
    -- upvalues: u17 (ref), u16 (copy), u11 (copy), Folder3 (copy), u9 (copy), TweenService (copy)
    for _ = 1, 3 do
        local u21;

        if u17 > 0 then
            u21 = u16[u17];
            u16[u17] = nil;
            u17 = u17 - 1;
        else
            u21 = u11:Clone();
        end;

        u21.CFrame = CFrame.new(p20);
        u21.Anchored = false;
        u21.Parent = Folder3;
        local v22 = u9:NextNumber(0, 6.283185307179586);
        local v23 = u9:NextNumber(7.5, 15);
        local v24 = u9:NextNumber(4.5, 9);
        local v25 = math.cos(v22) * v23;
        local v26 = math.sin(v22) * v23;
        u21.AssemblyLinearVelocity = Vector3.new(v25, v24, v26);
        task.delay(0.3, function() -- Line: 177
            -- upvalues: TweenService (ref), u21 (copy), u17 (ref), u16 (ref)
            local v27 = TweenService:Create(u21, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Transparency = 1
            });
            v27:Play();
            v27.Completed:Once(function() -- Line: 181
                -- upvalues: u21 (ref), u17 (ref), u16 (ref)
                u21.Transparency = 0.3;
                local v28 = u21;
                v28.Parent = nil;
                v28.Anchored = true;
                u17 = u17 + 1;
                u16[u17] = v28;
            end);
        end);
    end;
end;

local function getSpawnPosition() -- Line: 189
    -- upvalues: CurrentCamera (copy), u9 (copy)
    local Position = CurrentCamera.CFrame.Position;
    local v29 = u9:NextNumber(0, 6.283185307179586);
    local v30 = u9:NextNumber(5, 130);
    local v31 = Position.X + math.cos(v29) * v30;
    local v32 = Position.Z + math.sin(v29) * v30;

    return v31, Position.Y + u9:NextNumber(50, 90), v32;
end;

local function spawnDrop() -- Line: 201
    -- upvalues: u8 (ref), getSpawnPosition (copy), u10 (copy), u13 (ref), u12 (copy), Part (copy), Folder2 (copy), u7 (copy)
    if u8 >= 100 then
        return;
    end;

    local v33, v34, v35 = getSpawnPosition();
    local v36 = Vector3.new(v33, v34, v35);

    if workspace:Raycast(v36, Vector3.new(0, 100, 0), u10) then
        return;
    end;

    local v37;

    if u13 > 0 then
        v37 = u12[u13];
        u12[u13] = nil;
        u13 = u13 - 1;
    else
        v37 = Part:Clone();
    end;

    v37.CFrame = CFrame.new(v33, v34, v35);
    v37.Parent = Folder2;
    u8 = u8 + 1;
    u7[u8] = {
        part = v37,
        x = v33,
        y = v34,
        z = v35,
        startY = v34
    };
end;

local function spawnBatch() -- Line: 223
    -- upvalues: spawnDrop (copy)
    debug.profilebegin("Controllers/WeatherController/Lightning/spawnBatch");
    spawnDrop();
    spawnDrop();
    spawnDrop();
    spawnDrop();
    spawnDrop();
    spawnDrop();
    debug.profileend();
end;

local function renderLoop(p38) -- Line: 231
    -- upvalues: u8 (ref), CurrentCamera (copy), u7 (copy), u13 (ref), u12 (copy), u10 (copy)
    debug.profilebegin("Controllers/WeatherController/Lightning/renderLoop");

    if u8 == 0 then
        debug.profileend();

        return;
    end;

    local v39 = 90 * p38;
    local Y = CurrentCamera.CFrame.Position.Y;
    debug.profilebegin("Controllers/WeatherController/Lightning/renderLoop/iterateDrops");
    local v40 = 1;
    local v41 = {};
    local v42 = {};
    local v43 = 0;

    while true do
        local v44, v45;

        while true do
            while true do
                if v40 > u8 then
                    debug.profileend();

                    if v43 > 0 then
                        debug.profilebegin("Controllers/WeatherController/Lightning/renderLoop/BulkMoveTo");
                        workspace:BulkMoveTo(v41, v42, Enum.BulkMoveMode.FireCFrameChanged);
                        debug.profileend();
                    end;

                    debug.profileend();

                    return;
                end;

                v44 = u7[v40];
                v45 = v44.y - v39;
                v44.y = v45;

                if v44.startY - v45 <= 200 and v45 >= Y - 50 then
                    break;
                end;

                local part = v44.part;
                part.Parent = nil;
                u13 = u13 + 1;
                u12[u13] = part;
                u7[v40] = u7[u8];
                u7[u8] = nil;
                u8 = u8 - 1;
            end;

            local v46 = os.clock() * 60;

            if (v40 + math.floor(v46)) % 3 ~= 0 then
                break;
            end;

            debug.profilebegin("Controllers/WeatherController/Lightning/renderLoop/raycastGround");
            local v47 = Vector3.new(v44.x, v45, v44.z);

            if not workspace:Raycast(v47, Vector3.new(0, -2, 0), u10) then
                debug.profileend();
                break;
            end;

            local part = v44.part;
            part.Parent = nil;
            u13 = u13 + 1;
            u12[u13] = part;
            u7[v40] = u7[u8];
            u7[u8] = nil;
            u8 = u8 - 1;
            debug.profileend();
        end;

        v43 = v43 + 1;
        v41[v43] = v44.part;
        v42[v43] = CFrame.new(v44.x, v45, v44.z);
        v40 = v40 + 1;
    end;
end;

local function playLightningStrikeSFX(p48) -- Line: 298
    -- upvalues: Lightning (copy), u9 (copy), Folder (copy)
    local v49 = Lightning:GetChildren();

    if #v49 == 0 then
        return;
    end;

    local v50 = v49[u9:NextInteger(1, #v49)];

    if not v50:IsA("Sound") then
        return;
    end;

    local Part2 = Instance.new("Part");
    Part2.Name = "LightningSFXPart";
    Part2.Size = Vector3.new(1, 1, 1);
    Part2.Position = p48;
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.Transparency = 1;
    Part2.Parent = Folder;
    local v51 = v50:Clone();
    v51.Volume = 2;
    v51.RollOffMaxDistance = 7000;
    v51.RollOffMinDistance = 10;
    v51.Parent = Part2;
    v51:Play();
    v51.Ended:Once(function() -- Line: 325
        -- upvalues: Part2 (copy)
        Part2:Destroy();
    end);
    task.delay(v51.TimeLength + 1, function() -- Line: 330
        -- upvalues: Part2 (copy)
        if Part2.Parent then
            Part2:Destroy();
        end;
    end);
end;

local function createBoltSegment(p52, p53, p54) -- Line: 339
    -- upvalues: Folder (copy)
    local Part2 = Instance.new("Part");
    Part2.Name = "LightningBolt";
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CastShadow = false;
    Part2.Material = Enum.Material.Neon;
    Part2.Color = Color3.fromRGB(235, 245, 255);
    Part2.Transparency = 1;
    local Magnitude = (p53 - p52).Magnitude;
    Part2.Size = Vector3.new(p54, p54, Magnitude);
    Part2.CFrame = CFrame.lookAt(p52, p53) * CFrame.new(0, 0, -Magnitude / 2);
    Part2.Parent = Folder;

    return Part2;
end;

local function createBoltGlow(p55, p56, p57) -- Line: 358
    -- upvalues: Folder (copy)
    local Part2 = Instance.new("Part");
    Part2.Name = "LightningGlow";
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CastShadow = false;
    Part2.Material = Enum.Material.Neon;
    Part2.Color = Color3.fromRGB(180, 200, 255);
    Part2.Transparency = 1;
    local Magnitude = (p56 - p55).Magnitude;
    Part2.Size = Vector3.new(p57 * 3, p57 * 3, Magnitude);
    Part2.CFrame = CFrame.lookAt(p55, p56) * CFrame.new(0, 0, -Magnitude / 2);
    Part2.Parent = Folder;

    return Part2;
end;

local function createLightningBolt(p58) -- Line: 376
    -- upvalues: u9 (copy), createBoltSegment (copy), createBoltGlow (copy), Folder (copy)
    local v59 = p58 + Vector3.new(0, 150, 0);
    local v60 = {};

    for i = 1, 10 do
        local v61 = i / 10;
        local v62 = p58.Y + (1 - v61) * 150;
        local v63 = (1 - v61) * 0.7;
        local v64 = u9:NextNumber(-10, 10) * v63;
        local v65 = u9:NextNumber(-10, 10) * v63;
        local v66;

        if i == 10 then
            v66 = p58;
        else
            v66 = Vector3.new(p58.X + v64, v62, p58.Z + v65);
        end;

        local v67 = 2.5 - v61 * 1;
        local v68 = createBoltSegment(v59, v66, v67);
        table.insert(v60, v68);
        local v69 = createBoltGlow(v59, v66, v67);
        table.insert(v60, v69);

        if i > 2 and (i < 8 and u9:NextNumber() > 0.65) then
            local v70 = u9:NextNumber(-18, 18);
            local v71 = u9:NextNumber(-30, -10);
            local v72 = v66 + Vector3.new(v70, v71, u9:NextNumber(-18, 18));
            local v73 = createBoltSegment(v66, v72, 0.8);
            local v74 = createBoltGlow(v66, v72, 0.8);
            table.insert(v60, v73);
            table.insert(v60, v74);
            v59 = v66;
        else
            v59 = v66;
        end;
    end;

    local Part2 = Instance.new("Part");
    Part2.Name = "StrikeGlow";
    Part2.Shape = Enum.PartType.Ball;
    Part2.Size = Vector3.new(3, 3, 3);
    Part2.Position = p58;
    Part2.Anchored = true;
    Part2.CanCollide = false;
    Part2.CastShadow = false;
    Part2.Material = Enum.Material.Neon;
    Part2.Color = Color3.fromRGB(235, 245, 255);
    Part2.Transparency = 1;
    Part2.Parent = Folder;
    table.insert(v60, Part2);
    local Part3 = Instance.new("Part");
    Part3.Name = "OuterStrikeGlow";
    Part3.Shape = Enum.PartType.Ball;
    Part3.Size = Vector3.new(6, 6, 6);
    Part3.Position = p58;
    Part3.Anchored = true;
    Part3.CanCollide = false;
    Part3.CastShadow = false;
    Part3.Material = Enum.Material.Neon;
    Part3.Color = Color3.fromRGB(180, 200, 255);
    Part3.Transparency = 1;
    Part3.Parent = Folder;
    table.insert(v60, Part3);

    return v60;
end;

local function screenFlash() -- Line: 460
    -- upvalues: ColorCorrectionEffect (copy), TweenService (copy)
    ColorCorrectionEffect.Brightness = 2.5;
    ColorCorrectionEffect.Contrast = 0.15;
    ColorCorrectionEffect.Saturation = -0.3;
    TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
    }):Play();
end;

local function onLightningStrike(p75) -- Line: 475
    -- upvalues: createLightningBolt (copy), playLightningStrikeSFX (copy), TweenService (copy), u3 (ref), screenFlash (copy), ColorCorrectionEffect (copy)
    local u76 = createLightningBolt(p75);
    playLightningStrikeSFX(p75);
    local v77 = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

    for _, v in u76 do
        if v.Name == "LightningBolt" then
            TweenService:Create(v, v77, {
                Transparency = 0
            }):Play();
        elseif v.Name == "LightningGlow" then
            TweenService:Create(v, v77, {
                Transparency = 0.6
            }):Play();
        elseif v.Name == "StrikeGlow" then
            TweenService:Create(v, v77, {
                Transparency = 0
            }):Play();
        elseif v.Name == "OuterStrikeGlow" then
            TweenService:Create(v, v77, {
                Transparency = 0.4
            }):Play();
        end;
    end;

    task.delay(0.03, function() -- Line: 496
        -- upvalues: u3 (ref), screenFlash (ref)
        if not u3 then
            return;
        end;

        screenFlash();
    end);
    task.delay(0.1, function() -- Line: 502
        -- upvalues: u76 (copy), TweenService (ref)
        for _, v in u76 do
            if v.Name == "StrikeGlow" then
                TweenService:Create(v, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(15, 15, 15),
                    Transparency = 0.6
                }):Play();
            elseif v.Name == "OuterStrikeGlow" then
                TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(25, 25, 25),
                    Transparency = 0.8
                }):Play();
            end;
        end;
    end);
    task.delay(0.3, function() -- Line: 521
        -- upvalues: u76 (copy), TweenService (ref)
        local v78 = TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out);

        for _, v in u76 do
            TweenService:Create(v, v78, {
                Transparency = 1
            }):Play();
        end;

        task.delay(0.65, function() -- Line: 527
            -- upvalues: u76 (ref)
            for _, v in u76 do
                v:Destroy();
            end;
        end);
    end);
    task.delay(0.5, function() -- Line: 535
        -- upvalues: u3 (ref), ColorCorrectionEffect (ref), TweenService (ref)
        if not u3 then
            return;
        end;

        ColorCorrectionEffect.Brightness = 0.4;
        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Brightness = 0
        }):Play();
    end);
end;

local function getOrCreateClouds() -- Line: 545
    local v79 = workspace.Terrain:FindFirstChildOfClass("Clouds");

    if not v79 then
        v79 = Instance.new("Clouds");
        v79.Cover = 0;
        v79.Density = 0;
        v79.Color = Color3.fromRGB(255, 255, 255);
        v79.Enabled = false;
        v79.Parent = workspace.Terrain;
    end;

    return v79;
end;

local function saveLighting() -- Line: 558
    -- upvalues: u4 (copy), Lighting (copy)
    u4.Brightness = Lighting.Brightness;
    u4.Ambient = Lighting.Ambient;
    u4.OutdoorAmbient = Lighting.OutdoorAmbient;
    u4.FogEnd = Lighting.FogEnd;
    u4.FogColor = Lighting.FogColor;
    u4.ExposureCompensation = Lighting.ExposureCompensation;
end;

local function applyStormLighting() -- Line: 567
    -- upvalues: TweenService (copy), Lighting (copy), u4 (copy), getOrCreateClouds (copy)
    local v80 = TweenInfo.new(4, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v80, {
        FogEnd = 300,
        ExposureCompensation = 0.2,
        Brightness = u4.Brightness * 0.4,
        Ambient = Color3.fromRGB(90, 95, 115),
        OutdoorAmbient = Color3.fromRGB(40, 45, 60),
        FogColor = Color3.fromRGB(70, 75, 90)
    }):Play();
    local v81 = getOrCreateClouds();
    v81.Enabled = true;
    TweenService:Create(v81, v80, {
        Cover = 1,
        Density = 0.35
    }):Play();
end;

local function restoreLighting() -- Line: 584
    -- upvalues: TweenService (copy), Lighting (copy), u4 (copy), ColorCorrectionEffect (copy), getOrCreateClouds (copy), u3 (ref)
    local v82 = TweenInfo.new(4, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v82, {
        Brightness = u4.Brightness,
        Ambient = u4.Ambient,
        OutdoorAmbient = u4.OutdoorAmbient,
        FogEnd = u4.FogEnd,
        FogColor = u4.FogColor,
        ExposureCompensation = u4.ExposureCompensation
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v82, {
        Brightness = 0,
        Contrast = 0,
        Saturation = 0
    }):Play();
    local u83 = getOrCreateClouds();
    TweenService:Create(u83, v82, {
        Cover = 0,
        Density = 0
    }):Play();
    task.delay(4, function() -- Line: 604
        -- upvalues: u3 (ref), u83 (copy)
        if not u3 then
            u83.Enabled = false;
        end;
    end);
end;

local function fadeInAmbience() -- Line: 613
    -- upvalues: Rain (copy), TweenService (copy)
    Rain.Volume = 0;
    Rain:Play();
    TweenService:Create(Rain, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = 0.5
    }):Play();
end;

local function fadeOutAmbience() -- Line: 621
    -- upvalues: TweenService (copy), Rain (copy)
    local v84 = TweenService:Create(Rain, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Volume = 0
    });
    v84:Play();
    v84.Completed:Once(function(p85) -- Line: 625
        -- upvalues: Rain (ref)
        if p85 ~= Enum.PlaybackState.Completed then
            return;
        end;

        Rain:Stop();
    end);
end;

function u1.StartWeather() -- Line: 636
    -- upvalues: u3 (ref), u4 (copy), Lighting (copy), applyStormLighting (copy), fadeInAmbience (copy), u5 (ref), RunService (copy), renderLoop (copy), u6 (ref), spawnBatch (copy)
    if u3 then
        return;
    end;

    u3 = true;
    u4.Brightness = Lighting.Brightness;
    u4.Ambient = Lighting.Ambient;
    u4.OutdoorAmbient = Lighting.OutdoorAmbient;
    u4.FogEnd = Lighting.FogEnd;
    u4.FogColor = Lighting.FogColor;
    u4.ExposureCompensation = Lighting.ExposureCompensation;
    applyStormLighting();
    fadeInAmbience();
    u5 = RunService.RenderStepped:Connect(renderLoop);
    u6 = task.spawn(function() -- Line: 646
        -- upvalues: u3 (ref), spawnBatch (ref)
        while u3 do
            spawnBatch();
            task.wait(0.015);
        end;
    end);
end;

function u1.EndWeather() -- Line: 654
    -- upvalues: u3 (ref), ColorCorrectionEffect (copy), restoreLighting (copy), fadeOutAmbience (copy), u5 (ref), u8 (ref), u7 (copy), u13 (ref), u12 (copy), Folder (copy)
    if not u3 then
        return;
    end;

    u3 = false;
    ColorCorrectionEffect.Brightness = 0;
    ColorCorrectionEffect.Contrast = 0;
    ColorCorrectionEffect.Saturation = 0;
    restoreLighting();
    fadeOutAmbience();
    task.delay(4, function() -- Line: 665
        -- upvalues: u3 (ref), u5 (ref), u8 (ref), u7 (ref), u13 (ref), u12 (ref), Folder (ref)
        if u3 then
            return;
        end;

        if u5 then
            u5:Disconnect();
            u5 = nil;
        end;

        for i = 1, u8 do
            if u7[i] then
                local part = u7[i].part;
                part.Parent = nil;
                u13 = u13 + 1;
                u12[u13] = part;
                u7[i] = nil;
            end;
        end;

        u8 = 0;

        for _, child in Folder:GetChildren() do
            child:Destroy();
        end;
    end);
end;

Networking.WeatherEffects.LightningStart.OnClientEvent:Connect(function() -- Line: 690
    -- upvalues: u1 (copy)
    u1.StartWeather();
end);
Networking.WeatherEffects.LightningEnd.OnClientEvent:Connect(function() -- Line: 694
    -- upvalues: u1 (copy)
    u1.EndWeather();
end);
Networking.WeatherEffects.LightningStrike.OnClientEvent:Connect(function(p86) -- Line: 698
    -- upvalues: u3 (ref), onLightningStrike (copy)
    if u3 then
        onLightningStrike(p86);
    end;
end);

return u1;