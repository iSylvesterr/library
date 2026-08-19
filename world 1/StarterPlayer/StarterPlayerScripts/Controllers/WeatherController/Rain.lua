-- Decompiled with Potassium's decompiler.

local v1 = {};
local Lighting = game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local RunService = game:GetService("RunService");
local _ = math.rad;
local _ = math.tan;
local _ = math.min;
local clock = os.clock;
local CurrentCamera = workspace.CurrentCamera;

local function profileBegin(p2) -- Line: 27
    debug.profilebegin("Controllers/WeatherController/Rain/" .. p2);
end;

local function profileEnd() -- Line: 31
    debug.profileend();
end;

local u3 = {};
local u4 = 0;
local u5 = false;
local u6 = nil;
local u7 = nil;
local u8 = Random.new();
local u9 = RaycastParams.new();
u9.FilterDescendantsInstances = { workspace.Terrain, workspace };
u9.FilterType = Enum.RaycastFilterType.Include;
game:GetService("TweenService");
TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0);
local Rain = game.SoundService.WeatherSFX.Rain;
Rain.Looped = true;
local u10 = {};
local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
ColorCorrectionEffect.Name = "RainEffect";
ColorCorrectionEffect.Parent = Lighting;
local Folder = Instance.new("Folder");
Folder.Name = "RainDrops";
Folder.Parent = workspace;
local Folder2 = Instance.new("Folder");
Folder2.Name = "RainSplashes";
Folder2.Parent = workspace;

local function createDropTemplate() -- Line: 79
    local Part = Instance.new("Part");
    Part.Name = "RainDrop";
    Part.Size = Vector3.new(0.16, 2.4, 0.16);
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
Part.Size = Vector3.new(0.16, 2.4, 0.16);
Part.Material = Enum.Material.Neon;
Part.Color = Color3.fromRGB(100, 150, 255);
Part.Anchored = true;
Part.CanCollide = false;
Part.CastShadow = false;
Part.Transparency = 0.2;
local u11 = (function() -- Line: 93, Name: createSplashTemplate
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

local function getDrop() -- Line: 114
    -- upvalues: u13 (ref), u12 (copy), Part (copy)
    if u13 <= 0 then
        return Part:Clone();
    end;

    local v14 = u12[u13];
    u12[u13] = nil;
    u13 = u13 - 1;

    return v14;
end;

local function returnDrop(p15) -- Line: 124
    -- upvalues: u13 (ref), u12 (copy)
    p15.Parent = nil;
    u13 = u13 + 1;
    u12[u13] = p15;
end;

local u16 = {};
local u17 = 0;

local function getSplash() -- Line: 134
    -- upvalues: u17 (ref), u16 (copy), u11 (copy)
    if u17 <= 0 then
        return u11:Clone();
    end;

    local v18 = u16[u17];
    u16[u17] = nil;
    u17 = u17 - 1;

    return v18;
end;

local function returnSplash(p19) -- Line: 144
    -- upvalues: u17 (ref), u16 (copy)
    p19.Parent = nil;
    p19.Anchored = true;
    u17 = u17 + 1;
    u16[u17] = p19;
end;

local function createSplash(p20) -- Line: 152
    -- upvalues: u17 (ref), u16 (copy), u11 (copy), Folder2 (copy), u8 (copy), TweenService (copy)
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
        u21.Parent = Folder2;
        local v22 = u8:NextNumber(0, 6.283185307179586);
        local v23 = u8:NextNumber(7.5, 15);
        local v24 = u8:NextNumber(4.5, 9);
        local v25 = math.cos(v22) * v23;
        local v26 = math.sin(v22) * v23;
        u21.AssemblyLinearVelocity = Vector3.new(v25, v24, v26);
        task.delay(0.3, function() -- Line: 173
            -- upvalues: TweenService (ref), u21 (copy), u17 (ref), u16 (ref)
            local v27 = TweenService:Create(u21, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                Transparency = 1
            });
            v27:Play();
            v27.Completed:Once(function() -- Line: 177
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

local function getSpawnPosition() -- Line: 188
    -- upvalues: CurrentCamera (copy), u8 (copy)
    local Position = CurrentCamera.CFrame.Position;
    local v29 = u8:NextNumber(0, 6.283185307179586);
    local v30 = u8:NextNumber(5, 120);
    local v31 = Position.X + math.cos(v29) * v30;
    local v32 = Position.Z + math.sin(v29) * v30;

    return v31, Position.Y + u8:NextNumber(40, 80), v32;
end;

local function spawnDrop() -- Line: 202
    -- upvalues: u4 (ref), getSpawnPosition (copy), u9 (copy), u13 (ref), u12 (copy), Part (copy), Folder (copy), u3 (copy)
    if u4 >= 100 then
        return;
    end;

    local v33, v34, v35 = getSpawnPosition();
    local v36 = Vector3.new(v33, v34, v35);

    if workspace:Raycast(v36, Vector3.new(0, 100, 0), u9) then
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
    v37.Parent = Folder;
    u4 = u4 + 1;
    u3[u4] = {
        part = v37,
        x = v33,
        y = v34,
        z = v35,
        startY = v34
    };
end;

local function spawnBatch() -- Line: 226
    -- upvalues: spawnDrop (copy)
    debug.profilebegin("Controllers/WeatherController/Rain/spawnBatch");
    spawnDrop();
    spawnDrop();
    spawnDrop();
    spawnDrop();
    spawnDrop();
    spawnDrop();
    spawnDrop();
    debug.profileend();
end;

local function renderLoop(p38) -- Line: 237
    -- upvalues: u4 (ref), CurrentCamera (copy), u3 (copy), u13 (ref), u12 (copy), clock (copy), u9 (copy)
    debug.profilebegin("Controllers/WeatherController/Rain/renderLoop");

    if u4 == 0 then
        debug.profileend();

        return;
    end;

    local v39 = 70 * p38;
    local Y = CurrentCamera.CFrame.Position.Y;
    debug.profilebegin("Controllers/WeatherController/Rain/renderLoop/iterateDrops");
    local v40 = 1;
    local v41 = {};
    local v42 = {};
    local v43 = 0;

    while true do
        local v44, v45;

        while true do
            while true do
                if v40 > u4 then
                    debug.profileend();

                    if v43 > 0 then
                        debug.profilebegin("Controllers/WeatherController/Rain/renderLoop/BulkMoveTo");
                        workspace:BulkMoveTo(v41, v42, Enum.BulkMoveMode.FireCFrameChanged);
                        debug.profileend();
                    end;

                    debug.profileend();

                    return;
                end;

                v44 = u3[v40];
                v45 = v44.y - v39;
                v44.y = v45;

                if v44.startY - v45 <= 200 and v45 >= Y - 50 then
                    break;
                end;

                local part = v44.part;
                part.Parent = nil;
                u13 = u13 + 1;
                u12[u13] = part;
                u3[v40] = u3[u4];
                u3[u4] = nil;
                u4 = u4 - 1;
            end;

            local v46 = clock() * 60;

            if (v40 + math.floor(v46)) % 3 ~= 0 then
                break;
            end;

            debug.profilebegin("Controllers/WeatherController/Rain/renderLoop/raycastGround");
            local v47 = Vector3.new(v44.x, v45, v44.z);

            if not workspace:Raycast(v47, Vector3.new(0, -2, 0), u9) then
                debug.profileend();
                break;
            end;

            local part = v44.part;
            part.Parent = nil;
            u13 = u13 + 1;
            u12[u13] = part;
            u3[v40] = u3[u4];
            u3[u4] = nil;
            u4 = u4 - 1;
            debug.profileend();
        end;

        v43 = v43 + 1;
        v41[v43] = v44.part;
        v42[v43] = CFrame.new(v44.x, v45, v44.z);
        v40 = v40 + 1;
    end;
end;

local function saveLighting() -- Line: 310
    -- upvalues: u10 (copy), Lighting (copy)
    u10.Brightness = Lighting.Brightness;
    u10.Ambient = Lighting.Ambient;
    u10.OutdoorAmbient = Lighting.OutdoorAmbient;
    u10.FogEnd = Lighting.FogEnd;
    u10.FogColor = Lighting.FogColor;
    u10.ExposureCompensation = Lighting.ExposureCompensation;
end;

local function applyRainLighting() -- Line: 319
    -- upvalues: TweenService (copy), Lighting (copy), u10 (copy), ColorCorrectionEffect (copy)
    local v48 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v48, {
        FogEnd = 350,
        ExposureCompensation = 0.3,
        Brightness = u10.Brightness * 0.7,
        Ambient = Color3.fromRGB(180, 190, 210),
        OutdoorAmbient = Color3.fromRGB(70, 75, 85),
        FogColor = Color3.fromRGB(140, 145, 155)
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v48, {
        Brightness = 0.05,
        TintColor = Color3.fromRGB(210, 220, 240)
    }):Play();
    local Clouds = workspace.Terrain:FindFirstChild("Clouds");

    if Clouds == nil then
        Clouds = Instance.new("Clouds", game.Workspace.Terrain);
        Clouds.Density = 0;
        Clouds.Cover = 0;
    end;

    Clouds.Enabled = true;
    TweenService:Create(Clouds, v48, {
        Cover = 0.85,
        Density = 0.15
    }):Play();
end;

local function restoreLighting() -- Line: 346
    -- upvalues: TweenService (copy), Lighting (copy), u10 (copy), ColorCorrectionEffect (copy)
    local v49 = TweenInfo.new(3, Enum.EasingStyle.Sine);
    TweenService:Create(Lighting, v49, {
        Brightness = u10.Brightness,
        Ambient = u10.Ambient,
        OutdoorAmbient = u10.OutdoorAmbient,
        FogEnd = u10.FogEnd,
        FogColor = u10.FogColor,
        ExposureCompensation = u10.ExposureCompensation
    }):Play();
    TweenService:Create(ColorCorrectionEffect, v49, {
        Brightness = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    }):Play();
    local Clouds = workspace.Terrain.Clouds;
    TweenService:Create(Clouds, v49, {
        Cover = 0,
        Density = 0
    }):Play();
    task.delay(3, function() -- Line: 365
        -- upvalues: Clouds (copy)
        Clouds.Enabled = false;
    end);
end;

local function fadeInSFX() -- Line: 373
    -- upvalues: Rain (copy), TweenService (copy)
    Rain.Volume = 0;
    Rain:Play();
    TweenService:Create(Rain, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Volume = 0.5
    }):Play();
end;

local function fadeOutSFX() -- Line: 381
    -- upvalues: TweenService (copy), Rain (copy)
    local v50 = TweenService:Create(Rain, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Volume = 0
    });
    v50:Play();
    v50.Completed:Once(function(p51) -- Line: 385
        -- upvalues: Rain (ref)
        if p51 ~= Enum.PlaybackState.Completed then
            return;
        end;

        Rain:Stop();
    end);
end;

function v1.StartWeather() -- Line: 397
    -- upvalues: u5 (ref), u10 (copy), Lighting (copy), applyRainLighting (copy), fadeInSFX (copy), u6 (ref), RunService (copy), renderLoop (copy), u7 (ref), spawnBatch (copy)
    if u5 then
        return;
    end;

    u5 = true;
    u10.Brightness = Lighting.Brightness;
    u10.Ambient = Lighting.Ambient;
    u10.OutdoorAmbient = Lighting.OutdoorAmbient;
    u10.FogEnd = Lighting.FogEnd;
    u10.FogColor = Lighting.FogColor;
    u10.ExposureCompensation = Lighting.ExposureCompensation;
    applyRainLighting();
    fadeInSFX();
    u6 = RunService.RenderStepped:Connect(renderLoop);
    u7 = task.spawn(function() -- Line: 409
        -- upvalues: u5 (ref), spawnBatch (ref)
        while u5 do
            spawnBatch();
            task.wait(0.01);
        end;
    end);
end;

function v1.EndWeather() -- Line: 417
    -- upvalues: u5 (ref), restoreLighting (copy), fadeOutSFX (copy), u6 (ref), u4 (ref), u3 (copy), u13 (ref), u12 (copy)
    if not u5 then
        return;
    end;

    u5 = false;
    restoreLighting();
    fadeOutSFX();
    task.delay(4, function() -- Line: 425
        -- upvalues: u5 (ref), u6 (ref), u4 (ref), u3 (ref), u13 (ref), u12 (ref)
        if u5 then
            return;
        end;

        if u6 then
            u6:Disconnect();
            u6 = nil;
        end;

        for i = 1, u4 do
            if u3[i] then
                local part = u3[i].part;
                part.Parent = nil;
                u13 = u13 + 1;
                u12[u13] = part;
                u3[i] = nil;
            end;
        end;

        u4 = 0;
    end);
end;

return v1;