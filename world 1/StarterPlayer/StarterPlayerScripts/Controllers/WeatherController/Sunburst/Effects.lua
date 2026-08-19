-- Decompiled with Potassium's decompiler.

local v1 = {};
local CamShake = require(game.ReplicatedStorage.ClientModules.CamShake);
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
require(game.ReplicatedStorage.SharedModules.Networking);
local SunSky = game.ReplicatedStorage.Assets.Skybox.SunSky;
local u2 = false;
local u3 = Color3.fromRGB(255, 130, 0);
local u4 = Color3.fromRGB(255, 85, 0);
local SunfireFireTrail = game.ReplicatedStorage.Assets:WaitForChild("SunfireFireTrail");
local u5 = RaycastParams.new();
u5.FilterType = Enum.RaycastFilterType.Exclude;

local function Raycast(p6, p7) -- Line: 25
    -- upvalues: u5 (copy)
    local v8 = {};
    local v9 = 10;

    while true do
        u5.FilterDescendantsInstances = v8;
        local v10 = workspace:Raycast(p6.Origin, p6.Direction * 40, u5);

        if not v10 then
            break;
        end;

        local Instance2 = v10.Instance;

        if Instance2.Transparency < 1 and Instance2.CanQuery then
            return {
                Position = v10.Position,
                Instance = Instance2,
                Normal = v10.Normal
            };
        end;

        table.insert(v8, Instance2);
        v9 = v9 - 1;

        if v9 == 0 then
            return nil;
        end;
    end;

    return nil;
end;

local function positionBeamSegment(p11, p12, p13, p14) -- Line: 60
    local Magnitude = (p13 - p12).Magnitude;
    p11.Size = Vector3.new(p14, p14, Magnitude);
    p11.CFrame = CFrame.lookAt(p12, p13) * CFrame.new(0, 0, -Magnitude / 2);
end;

local function createBeamPart(p15, p16) -- Line: 66
    local Part = Instance.new("Part");
    Part.Anchored = true;
    Part.CanCollide = false;
    Part.CanQuery = false;
    Part.CanTouch = false;
    Part.CastShadow = false;
    Part.Material = Enum.Material.Neon;
    Part.Color = p16;
    Part.Parent = workspace.Terrain;

    return Part;
end;

local function scaleParticleSize(p17, p18) -- Line: 79
    local v19 = {};

    for _, v in p17.Size.Keypoints do
        table.insert(v19, NumberSequenceKeypoint.new(v.Time, v.Value * p18, v.Envelope * p18));
    end;

    p17.Size = NumberSequence.new(v19);
end;

local function dropTrailSegment(p20, p21) -- Line: 87
    -- upvalues: SunfireFireTrail (copy)
    local u22 = SunfireFireTrail:Clone();
    u22.Anchored = true;
    u22.CanCollide = false;
    u22.CanQuery = false;
    u22.CanTouch = false;
    local v23 = p20 + Vector3.new(0, 1, 0);
    u22.CFrame = CFrame.lookAt(v23, v23 + p21, Vector3.new(0, 1, 0));
    u22.Parent = workspace.Terrain;
    task.delay(3, function() -- Line: 97
        -- upvalues: u22 (copy)
        for _, descendant in u22:GetDescendants() do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false;
            end;
        end;

        task.delay(1, function() -- Line: 103
            -- upvalues: u22 (ref)
            u22:Destroy();
        end);
    end);
end;

local function updateTrail(p24, p25) -- Line: 111
    -- upvalues: dropTrailSegment (copy)
    if not p25 then
        return p24;
    end;

    local v26 = p24 - p25;
    local v27 = Vector3.new(v26.X, 0, v26.Z);
    local Magnitude = v27.Magnitude;

    if Magnitude < 8 then
        return p25;
    end;

    local Unit = v27.Unit;
    local v28 = p25;

    for i = 1, math.floor(Magnitude / 8) do
        local v29 = p25 + Unit * (i * 8);
        v28 = Vector3.new(v29.X, p24.Y, v29.Z);
        dropTrailSegment(v28, Unit);
    end;

    return v28;
end;

local u30 = tick();
local u31 = nil;
local FlameEffect = script.FlameEffect;
FlameEffect.Parent = game.Lighting;
FlameEffect.Enabled = false;

local function handleDamage() -- Line: 143
    -- upvalues: u30 (ref), u31 (ref), FlameEffect (copy)
    if tick() - u30 < 0.5 then
        return;
    end;

    u30 = tick();
    local v32 = game.ReplicatedStorage.Assets.Vignette:Clone();
    v32.ImageLabel.ImageColor3 = Color3.fromRGB(255, 35, 35);
    v32.Parent = game.Players.LocalPlayer.PlayerGui;
    v32.ImageLabel.ImageTransparency = 0.6;

    if u31 then
        u31:Cancel();
    end;

    FlameEffect.Brightness = 0.1;
    FlameEffect.Saturation = 0.1;
    FlameEffect.TintColor = Color3.fromRGB(255, 181, 97);
    u31 = game.TweenService:Create(FlameEffect, TweenInfo.new(0.5), {
        Brightness = 0,
        Saturation = 0,
        TintColor = Color3.fromRGB(255, 255, 255)
    });
    FlameEffect.Enabled = true;
    u31:Play();
    game.TweenService:Create(v32.ImageLabel.UIScale, TweenInfo.new(0.5), {
        Scale = 1.06
    }):Play();
    game.TweenService:Create(v32.ImageLabel, TweenInfo.new(0.5), {
        ImageTransparency = 1
    }):Play();
    task.delay(0.5, function() -- Line: 172
        -- upvalues: FlameEffect (ref)
        FlameEffect.Enabled = false;
    end);
    game.Debris:AddItem(v32, 0.5);
end;

function v1.End() -- Line: 182
    -- upvalues: u2 (ref)
    u2 = false;
end;

function v1.Start(u33) -- Line: 185
    -- upvalues: CamShake (copy), Skybox (copy), SunSky (copy), u2 (ref), u3 (copy), u4 (copy), scaleParticleSize (copy), Raycast (copy), updateTrail (copy), handleDamage (copy)
    local Sun = u33.Sun;
    local v34 = script.FirePoof:Clone();
    v34.Parent = workspace;
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Parent = game.Lighting;
    game.Debris:AddItem(ColorCorrectionEffect, 5);
    game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
        FieldOfView = 95
    }):Play();
    game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
        Brightness = 0.3,
        Contrast = 0.2,
        Saturation = 0.3,
        TintColor = Color3.fromRGB(255, 227, 125)
    }):Play();
    CamShake:Shake(CamShake.Presets.SideExplosion);
    task.delay(0.4, function() -- Line: 205
        -- upvalues: Skybox (ref), SunSky (ref), ColorCorrectionEffect (copy)
        Skybox.SetOrder(SunSky, 0);
        game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(1), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(2), {
            FieldOfView = 70
        }):Play();
    end);
    v34:Play();
    game.Debris:AddItem(v34, 5);
    Sun.Sun.Lava:Play();
    Sun.Sun.Burning:Play();
    game.TweenService:Create(Sun.Sun.Burning, TweenInfo.new(2), {
        Volume = 0.5
    }):Play();
    u2 = true;

    local function lerp(p35, p36, p37) -- Line: 231
        return p35 + (p36 - p35) * p37;
    end;

    for _, child in u33.Debris:GetChildren() do
        game.TweenService:Create(child, TweenInfo.new(3), {
            TimeScale = 1
        }):Play();
    end;

    local v38 = Sun:GetPivot();
    game.TweenService:Create(Sun.Sun.SurfaceAppearance, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
        EmissiveStrength = 7
    }):Play();
    local v39 = 0;

    while v39 < 3 and u2 do
        v39 = v39 + game:GetService("RunService").Heartbeat:Wait();
        local v40 = game.TweenService:GetValue(v39 / 3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
        Sun:ScaleTo(0.01 + 1.49 * v40);
        Sun:PivotTo(v38:Lerp(v38 * CFrame.new(0, 50, 0), v40));
    end;

    task.spawn(function() -- Line: 263
        -- upvalues: u2 (ref), Sun (copy)
        while u2 and Sun.Parent do
            local v41 = game:GetService("RunService").Heartbeat:Wait();

            if not u2 or Sun.Parent == nil then
                break;
            end;

            Sun:PivotTo(Sun:GetPivot() * CFrame.Angles(0, 0.3141592653589793 * v41, 0));
        end;
    end);
    local ColorCorrectionEffect2 = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect2.Parent = game.Lighting;
    game.Debris:AddItem(ColorCorrectionEffect2, 5);
    game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
        FieldOfView = 95
    }):Play();
    game.TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(0.4), {
        Brightness = 1.5,
        Contrast = 0.2,
        Saturation = 0.5,
        TintColor = Color3.fromRGB(255, 227, 125)
    }):Play();
    CamShake:Shake(CamShake.Presets.SideExplosion);
    game.SoundService:PlayLocalSound(game.SoundService.SFX.Snap);
    task.delay(0.4, function() -- Line: 284
        -- upvalues: Skybox (ref), SunSky (ref), ColorCorrectionEffect2 (copy)
        Skybox.SetOrder(SunSky, 2);
        workspace.Terrain.Clouds.Cover = 0.8;
        workspace.Terrain.Clouds.Density = 0.3;
        workspace.Terrain.Clouds.Color = Color3.fromRGB(255, 30, 0);
        game.TweenService:Create(ColorCorrectionEffect2, TweenInfo.new(1), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(1), {
            FieldOfView = 70
        }):Play();
    end);
    tick();
    task.spawn(function() -- Line: 299
        -- upvalues: Sun (copy), u3 (ref), u4 (ref), scaleParticleSize (ref), u2 (ref), Raycast (ref), updateTrail (ref), handleDamage (ref)
        local SunLocation = workspace:WaitForChild("SunLocation");
        Sun.Sun.End.WorldCFrame = CFrame.new(SunLocation.Value);
        local v42 = RaycastParams.new();
        v42.FilterType = Enum.RaycastFilterType.Include;
        local v43 = CFrame.new(SunLocation.Value);
        local v44 = nil;

        for _, child in Sun.Sun.Folder:GetChildren() do
            if child:IsA("Beam") then
                child.Enabled = false;
            end;
        end;

        local Part = Instance.new("Part");
        Part.Anchored = true;
        Part.CanCollide = false;
        Part.CanQuery = false;
        Part.CanTouch = false;
        Part.CastShadow = false;
        Part.Material = Enum.Material.Neon;
        Part.Color = u3;
        Part.Parent = workspace.Terrain;
        local Part2 = Instance.new("Part");
        Part2.Anchored = true;
        Part2.CanCollide = false;
        Part2.CanQuery = false;
        Part2.CanTouch = false;
        Part2.CastShadow = false;
        Part2.Material = Enum.Material.Neon;
        Part2.Color = u4;
        Part2.Parent = workspace.Terrain;
        Part2.Transparency = 0.55;

        for _, child in Sun.Sun.End:GetChildren() do
            if child:IsA("ParticleEmitter") then
                scaleParticleSize(child, 4);
            end;
        end;

        Sun.Sun.End.Burn:Play();
        Sun.Sun.End.loop:Play();

        while SunLocation and u2 do
            local v45 = game:GetService("RunService").Heartbeat:Wait();

            if not u2 or (Sun.Parent == nil or SunLocation.Parent == nil) then
                break;
            end;

            v43 = v43:Lerp(CFrame.new(SunLocation.Value), (math.clamp(v45 * 3, 0, 1)));
            local v46 = CFrame.new(Sun.Sun.Position, v43.Position) * CFrame.new(0, 0, Sun.Sun.Size.X / 2);
            Sun.Sun.Emitter.WorldCFrame = v46;
            v42.FilterDescendantsInstances = { workspace.Gardens, workspace.Baseplate };
            local v47 = Raycast(Ray.new(v46.Position, v46.LookVector * 400));

            if v47 and v47 ~= nil then
                if v47 and v47.Position then
                    Sun.Sun.End.WorldCFrame = CFrame.new(v47.Position);
                    v44 = updateTrail(v47.Position, v44);
                    local Position = v46.Position;
                    local Position2 = v47.Position;
                    local Magnitude = (Position2 - Position).Magnitude;
                    Part.Size = Vector3.new(3, 3, Magnitude);
                    Part.CFrame = CFrame.lookAt(Position, Position2) * CFrame.new(0, 0, -Magnitude / 2);
                    local Position3 = v46.Position;
                    local Position4 = v47.Position;
                    local Magnitude2 = (Position4 - Position3).Magnitude;
                    Part2.Size = Vector3.new(6, 6, Magnitude2);
                    Part2.CFrame = CFrame.lookAt(Position3, Position4) * CFrame.new(0, 0, -Magnitude2 / 2);

                    if v47.Instance:IsDescendantOf(game.Players.LocalPlayer.Character) then
                        handleDamage();
                    end;
                end;
            else
                Sun.Sun.End.WorldCFrame = CFrame.new(SunLocation.Value);
                local Position = v46.Position;
                local Value = SunLocation.Value;
                local Magnitude = (Value - Position).Magnitude;
                Part.Size = Vector3.new(3, 3, Magnitude);
                Part.CFrame = CFrame.lookAt(Position, Value) * CFrame.new(0, 0, -Magnitude / 2);
                local Position2 = v46.Position;
                local Value2 = SunLocation.Value;
                local Magnitude2 = (Value2 - Position2).Magnitude;
                Part2.Size = Vector3.new(6, 6, Magnitude2);
                Part2.CFrame = CFrame.lookAt(Position2, Value2) * CFrame.new(0, 0, -Magnitude2 / 2);
                v44 = nil;
            end;
        end;

        Part:Destroy();
        Part2:Destroy();
    end);
    task.spawn(function() -- Line: 395
        -- upvalues: u2 (ref), CamShake (ref), u33 (copy), Skybox (ref), SunSky (ref)
        repeat
            task.wait();
        until u2 == false;

        local ColorCorrectionEffect3 = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect3.Parent = game.Lighting;
        game.Debris:AddItem(ColorCorrectionEffect3, 5);
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
            FieldOfView = 95
        }):Play();
        game.TweenService:Create(ColorCorrectionEffect3, TweenInfo.new(0.4), {
            Brightness = 1.5,
            Contrast = 0.2,
            Saturation = 0.5,
            TintColor = Color3.fromRGB(255, 227, 125)
        }):Play();
        CamShake:Shake(CamShake.Presets.SideExplosion);
        task.delay(0.4, function() -- Line: 411
            -- upvalues: u33 (ref), Skybox (ref), SunSky (ref), ColorCorrectionEffect3 (copy)
            workspace.Terrain.Clouds.Cover = 0.5;
            workspace.Terrain.Clouds.Density = 0;
            workspace.Terrain.Clouds.Color = Color3.fromRGB(255, 255, 255);
            u33:Destroy();
            Skybox.SetOrder(SunSky, 0);
            game.TweenService:Create(ColorCorrectionEffect3, TweenInfo.new(1), {
                Brightness = 0,
                Contrast = 0,
                Saturation = 0,
                TintColor = Color3.fromRGB(255, 255, 255)
            }):Play();
            game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(1), {
                FieldOfView = 70
            }):Play();
        end);
    end);
end;

return v1;