-- Decompiled with Potassium's decompiler.

local v1 = {
    NoMusic = true
};
game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Players = game:GetService("Players");
game:GetService("SoundService");
require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local MusicController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.MusicController);
require(game.ReplicatedStorage.ClientModules.Reticule);
local ChainedMoon = ReplicatedStorage.Assets:WaitForChild("ChainedMoon");
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
local EnchainedMoon = game.ReplicatedStorage.Assets.Skybox.EnchainedMoon;
local ButtonMash = require(game.ReplicatedStorage.ClientModules.ButtonMash);
local RagdollModule = require(game.ReplicatedStorage.ClientModules.RagdollModule);
local Networking = require(game.ReplicatedStorage.SharedModules.Networking);

local function lerp(p2, p3, p4) -- Line: 45
    return p2 + (p3 - p2) * p4;
end;

local u5 = {
    ClockTime = 23
};
local u6 = {
    Brightness = 4,
    EnvironmentDiffuseScale = 1,
    ClockTime = 23,
    Ambient = Color3.fromRGB(197, 36, 241),
    ColorShift_Bottom = Color3.fromRGB(163, 70, 199),
    ColorShift_Top = Color3.fromRGB(125, 63, 250),
    OutdoorAmbient = Color3.fromRGB(74, 139, 180)
};

local function ScaleModelTo(p7, p8, p9, p10, p11) -- Line: 65
    -- upvalues: TweenService (copy)
    local v12 = p7:GetScale();
    local v13 = p10 or Enum.EasingStyle.Linear;
    local v14 = p11 or Enum.EasingDirection.InOut;
    local v15 = 0;

    while v15 < p9 do
        v15 = v15 + task.wait(0);
        local v16 = TweenService:GetValue(math.clamp(v15 / p9, 0.01, 1), v13, v14);
        p7:ScaleTo(v12 + (p8 - v12) * v16);
    end;
end;

local u17 = nil;
local u18 = nil;
local u19 = game.SoundService.SFX.ShakeLoop:Clone();

local function startUpdateLoop() -- Line: 95
    -- upvalues: Skybox (copy), EnchainedMoon (copy), MusicController (copy), ReplicatedStorage (copy), LocalPlayer (copy), FieldOfViewController (copy), CamShake (copy), LightingController (copy), u6 (copy), u17 (ref), TweenService (copy), ChainedMoon (copy), u19 (copy)
    game.TweenService:Create(workspace.Terrain.Clouds, TweenInfo.new(1), {
        Cover = 0
    }):Play();
    task.delay(1, function() -- Line: 99
        -- upvalues: Skybox (ref), EnchainedMoon (ref)
        Skybox.SetOrder(EnchainedMoon, 2);
    end);
    MusicController:SetActiveWeather("Chained Moon");
    local u20 = false;
    local u21 = true;

    local function Chain(u22, u23) -- Line: 109
        -- upvalues: u21 (ref), u20 (ref), ReplicatedStorage (ref), LocalPlayer (ref), FieldOfViewController (ref), CamShake (ref)
        local u24 = game.ReplicatedStorage.Assets.ChainEffect:Clone();
        u24.Parent = workspace.CurrentCamera;
        task.spawn(function() -- Line: 113
            -- upvalues: u21 (ref), u20 (ref), u24 (copy), u23 (copy), u22 (copy), ReplicatedStorage (ref), LocalPlayer (ref), FieldOfViewController (ref), CamShake (ref)
            task.wait(0.4);
            game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainMove);
            local v25 = game.SoundService.SFX.Gear:Clone();
            v25.Parent = game.SoundService;
            v25.PlayOnRemove = true;
            v25:Destroy();
            local v26 = 0;
            local v27 = false;

            while u21 do
                v26 = v26 + game:GetService("RunService").Heartbeat:Wait();
                local v28 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
                local v29 = math.tan(v28) * 8;
                local v30 = v29 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
                local v31 = 0.5 * (workspace.CurrentCamera.FieldOfView / 70);

                if u20 then
                    u24.Attachment1.Beam.TextureSpeed = 10 * v31;
                end;

                u24.Attachment1.Beam.Width0 = v31;
                u24.Attachment1.Beam.Width1 = v31;
                u24.Attachment1.Beam.TextureLength = v31;
                local v32 = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -u23);
                local v33 = v32 * CFrame.new(u22 * (v30 / 4), v29 / 4, 0);
                local v34 = v32 * CFrame.new(-u22 * (v30 / 4), -v29 / 4, 0);
                local LookVector = CFrame.new(v33.p, v34.p).LookVector;
                local v35 = game.TweenService:GetValue(math.min(v26, 0.7) / 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

                if v35 == 1 and not v27 then
                    v27 = true;

                    for _, child in u24.Attachment2:GetChildren() do
                        child:Emit(child:GetAttribute("EmitCount") or 15);
                        child.Enabled = false;
                    end;

                    local v36 = ReplicatedStorage.Assets.Vignette:Clone();
                    v36.ImageLabel.ImageTransparency = 0.7;
                    v36.ImageLabel.UIScale.Scale = 1;
                    v36.ImageLabel.ImageColor3 = Color3.fromRGB(255, 108, 253);
                    game.SoundService:PlayLocalSound(game.SoundService.SFX.Forge);
                    game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainImpact);
                    game.TweenService:Create(v36.ImageLabel.UIScale, TweenInfo.new(1), {
                        Scale = 1.1
                    }):Play();
                    game.TweenService:Create(v36.ImageLabel, TweenInfo.new(1), {
                        ImageTransparency = 1
                    }):Play();
                    v36.Parent = LocalPlayer.PlayerGui;
                    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
                    ColorCorrectionEffect.Parent = game.Lighting;
                    game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.3), {
                        Brightness = 0.4,
                        TintColor = Color3.fromRGB(210, 119, 255)
                    }):Play();
                    game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
                        FieldOfView = 90
                    }):Play();
                    task.delay(0.4, function() -- Line: 183
                        -- upvalues: ColorCorrectionEffect (copy), FieldOfViewController (ref)
                        game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
                            Brightness = 0,
                            TintColor = Color3.fromRGB(255, 255, 255)
                        }):Play();
                        game.Debris:AddItem(ColorCorrectionEffect, 0.8);
                        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
                            FieldOfView = 80
                        }):Play();
                        FieldOfViewController:SetBaseFOV(80);
                    end);
                    game.Debris:AddItem(v36, 1);
                    CamShake:Shake(CamShake.Presets.SideExplosion);
                    local u37 = game.ReplicatedStorage.Assets.ChainGlow:Clone();
                    u37.Parent = u24;

                    for _, child in u37:GetChildren() do
                        child:Emit(child:GetAttribute("EmitCount") or 15);
                    end;

                    task.spawn(function() -- Line: 203
                        -- upvalues: u21 (ref), u37 (copy), u22 (ref)
                        while u21 do
                            local v38 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
                            local v39 = math.tan(v38) * 8;
                            local v40 = v39 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
                            u37.Size = Vector3.new(v40 / 2, 0.1, 0.1);
                            u37.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(-u22 * v40 / 4, -v39 / 2, -4);
                            game:GetService("RunService").RenderStepped:Wait();
                        end;

                        u37:Destroy();
                    end);
                end;

                local v41 = v33:Lerp(v34, v35);
                u24.Attachment2.WorldCFrame = CFrame.new(v41.Position, v41.Position + LookVector);
                u24.Attachment1.WorldCFrame = v33;
            end;

            u24:Destroy();
        end);
    end;

    local u42 = game.SoundService.SFX.Gear:Clone();
    u42.Parent = game.SoundService;
    local u43 = game.SoundService.SFX.ChainMove:Clone();
    u43.Parent = game.SoundService;
    local u44 = game.ReplicatedStorage.Assets.ChainEffect:Clone();
    u44.Parent = workspace.CurrentCamera;
    local u45 = 2;
    local u46 = -1;
    task.spawn(function() -- Line: 113
        -- upvalues: u21 (ref), u20 (ref), u44 (copy), u45 (copy), u46 (copy), ReplicatedStorage (ref), LocalPlayer (ref), FieldOfViewController (ref), CamShake (ref)
        task.wait(0.4);
        game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainMove);
        local v47 = game.SoundService.SFX.Gear:Clone();
        v47.Parent = game.SoundService;
        v47.PlayOnRemove = true;
        v47:Destroy();
        local v48 = 0;
        local v49 = false;

        while u21 do
            v48 = v48 + game:GetService("RunService").Heartbeat:Wait();
            local v50 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
            local v51 = math.tan(v50) * 8;
            local v52 = v51 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
            local v53 = 0.5 * (workspace.CurrentCamera.FieldOfView / 70);

            if u20 then
                u44.Attachment1.Beam.TextureSpeed = 10 * v53;
            end;

            u44.Attachment1.Beam.Width0 = v53;
            u44.Attachment1.Beam.Width1 = v53;
            u44.Attachment1.Beam.TextureLength = v53;
            local v54 = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -u45);
            local v55 = v54 * CFrame.new(u46 * (v52 / 4), v51 / 4, 0);
            local v56 = v54 * CFrame.new(-u46 * (v52 / 4), -v51 / 4, 0);
            local LookVector = CFrame.new(v55.p, v56.p).LookVector;
            local v57 = game.TweenService:GetValue(math.min(v48, 0.7) / 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

            if v57 == 1 and not v49 then
                v49 = true;

                for _, child in u44.Attachment2:GetChildren() do
                    child:Emit(child:GetAttribute("EmitCount") or 15);
                    child.Enabled = false;
                end;

                local v58 = ReplicatedStorage.Assets.Vignette:Clone();
                v58.ImageLabel.ImageTransparency = 0.7;
                v58.ImageLabel.UIScale.Scale = 1;
                v58.ImageLabel.ImageColor3 = Color3.fromRGB(255, 108, 253);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Forge);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainImpact);
                game.TweenService:Create(v58.ImageLabel.UIScale, TweenInfo.new(1), {
                    Scale = 1.1
                }):Play();
                game.TweenService:Create(v58.ImageLabel, TweenInfo.new(1), {
                    ImageTransparency = 1
                }):Play();
                v58.Parent = LocalPlayer.PlayerGui;
                local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
                ColorCorrectionEffect.Parent = game.Lighting;
                game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.3), {
                    Brightness = 0.4,
                    TintColor = Color3.fromRGB(210, 119, 255)
                }):Play();
                game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
                    FieldOfView = 90
                }):Play();
                task.delay(0.4, function() -- Line: 183
                    -- upvalues: ColorCorrectionEffect (copy), FieldOfViewController (ref)
                    game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
                        Brightness = 0,
                        TintColor = Color3.fromRGB(255, 255, 255)
                    }):Play();
                    game.Debris:AddItem(ColorCorrectionEffect, 0.8);
                    game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
                        FieldOfView = 80
                    }):Play();
                    FieldOfViewController:SetBaseFOV(80);
                end);
                game.Debris:AddItem(v58, 1);
                CamShake:Shake(CamShake.Presets.SideExplosion);
                local u59 = game.ReplicatedStorage.Assets.ChainGlow:Clone();
                u59.Parent = u44;

                for _, child in u59:GetChildren() do
                    child:Emit(child:GetAttribute("EmitCount") or 15);
                end;

                task.spawn(function() -- Line: 203
                    -- upvalues: u21 (ref), u59 (copy), u46 (ref)
                    while u21 do
                        local v60 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
                        local v61 = math.tan(v60) * 8;
                        local v62 = v61 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
                        u59.Size = Vector3.new(v62 / 2, 0.1, 0.1);
                        u59.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(-u46 * v62 / 4, -v61 / 2, -4);
                        game:GetService("RunService").RenderStepped:Wait();
                    end;

                    u59:Destroy();
                end);
            end;

            local v63 = v55:Lerp(v56, v57);
            u44.Attachment2.WorldCFrame = CFrame.new(v63.Position, v63.Position + LookVector);
            u44.Attachment1.WorldCFrame = v55;
        end;

        u44:Destroy();
    end);
    task.wait(0.7);
    task.delay(0.3, function() -- Line: 243
        -- upvalues: LightingController (ref), u6 (ref)
        LightingController:TransitionTo(u6, 0.4);
    end);
    task.wait(1);
    local u64 = game.ReplicatedStorage.Assets.ChainEffect:Clone();
    u64.Parent = workspace.CurrentCamera;
    local u65 = 2.1;
    local u66 = 1;
    task.spawn(function() -- Line: 113
        -- upvalues: u21 (ref), u20 (ref), u64 (copy), u65 (copy), u66 (copy), ReplicatedStorage (ref), LocalPlayer (ref), FieldOfViewController (ref), CamShake (ref)
        task.wait(0.4);
        game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainMove);
        local v67 = game.SoundService.SFX.Gear:Clone();
        v67.Parent = game.SoundService;
        v67.PlayOnRemove = true;
        v67:Destroy();
        local v68 = 0;
        local v69 = false;

        while u21 do
            v68 = v68 + game:GetService("RunService").Heartbeat:Wait();
            local v70 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
            local v71 = math.tan(v70) * 8;
            local v72 = v71 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
            local v73 = 0.5 * (workspace.CurrentCamera.FieldOfView / 70);

            if u20 then
                u64.Attachment1.Beam.TextureSpeed = 10 * v73;
            end;

            u64.Attachment1.Beam.Width0 = v73;
            u64.Attachment1.Beam.Width1 = v73;
            u64.Attachment1.Beam.TextureLength = v73;
            local v74 = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -u65);
            local v75 = v74 * CFrame.new(u66 * (v72 / 4), v71 / 4, 0);
            local v76 = v74 * CFrame.new(-u66 * (v72 / 4), -v71 / 4, 0);
            local LookVector = CFrame.new(v75.p, v76.p).LookVector;
            local v77 = game.TweenService:GetValue(math.min(v68, 0.7) / 0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);

            if v77 == 1 and not v69 then
                v69 = true;

                for _, child in u64.Attachment2:GetChildren() do
                    child:Emit(child:GetAttribute("EmitCount") or 15);
                    child.Enabled = false;
                end;

                local v78 = ReplicatedStorage.Assets.Vignette:Clone();
                v78.ImageLabel.ImageTransparency = 0.7;
                v78.ImageLabel.UIScale.Scale = 1;
                v78.ImageLabel.ImageColor3 = Color3.fromRGB(255, 108, 253);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.Forge);
                game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainImpact);
                game.TweenService:Create(v78.ImageLabel.UIScale, TweenInfo.new(1), {
                    Scale = 1.1
                }):Play();
                game.TweenService:Create(v78.ImageLabel, TweenInfo.new(1), {
                    ImageTransparency = 1
                }):Play();
                v78.Parent = LocalPlayer.PlayerGui;
                local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
                ColorCorrectionEffect.Parent = game.Lighting;
                game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.3), {
                    Brightness = 0.4,
                    TintColor = Color3.fromRGB(210, 119, 255)
                }):Play();
                game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
                    FieldOfView = 90
                }):Play();
                task.delay(0.4, function() -- Line: 183
                    -- upvalues: ColorCorrectionEffect (copy), FieldOfViewController (ref)
                    game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
                        Brightness = 0,
                        TintColor = Color3.fromRGB(255, 255, 255)
                    }):Play();
                    game.Debris:AddItem(ColorCorrectionEffect, 0.8);
                    game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
                        FieldOfView = 80
                    }):Play();
                    FieldOfViewController:SetBaseFOV(80);
                end);
                game.Debris:AddItem(v78, 1);
                CamShake:Shake(CamShake.Presets.SideExplosion);
                local u79 = game.ReplicatedStorage.Assets.ChainGlow:Clone();
                u79.Parent = u64;

                for _, child in u79:GetChildren() do
                    child:Emit(child:GetAttribute("EmitCount") or 15);
                end;

                task.spawn(function() -- Line: 203
                    -- upvalues: u21 (ref), u79 (copy), u66 (ref)
                    while u21 do
                        local v80 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
                        local v81 = math.tan(v80) * 8;
                        local v82 = v81 * (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
                        u79.Size = Vector3.new(v82 / 2, 0.1, 0.1);
                        u79.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(-u66 * v82 / 4, -v81 / 2, -4);
                        game:GetService("RunService").RenderStepped:Wait();
                    end;

                    u79:Destroy();
                end);
            end;

            local v83 = v75:Lerp(v76, v77);
            u64.Attachment2.WorldCFrame = CFrame.new(v83.Position, v83.Position + LookVector);
            u64.Attachment1.WorldCFrame = v75;
        end;

        u64:Destroy();
    end);
    task.wait(1.1);
    u17 = ReplicatedStorage.Assets.Vignette:Clone();
    u17.ImageLabel.ImageTransparency = 0.7;
    u17.ImageLabel.UIScale.Scale = 1;
    u17.ImageLabel.ImageColor3 = Color3.fromRGB(255, 108, 253);
    game.TweenService:Create(u17.ImageLabel.UIScale, TweenInfo.new(1), {
        Scale = 1.04
    }):Play();
    game.TweenService:Create(u17.ImageLabel, TweenInfo.new(1), {
        ImageTransparency = 0.8
    }):Play();
    u17.Parent = LocalPlayer.PlayerGui;
    CamShake:ShakeSustain(CamShake.Presets.Earthquake, 0);
    task.delay(0.5, function() -- Line: 262
        -- upvalues: u20 (ref), u42 (copy), u43 (copy)
        u20 = true;
        u42.Looped = true;
        u43:Play();
        u42:Play();
    end);
    task.delay(1, function() -- Line: 274
        -- upvalues: TweenService (ref), CamShake (ref), u21 (ref), u43 (copy), u42 (copy), ChainedMoon (ref), u19 (ref)
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Parent = game.Lighting;
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {
            FieldOfView = 95
        }):Play();
        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.3), {
            Brightness = 1.5,
            Contrast = 0.2,
            Saturation = 0.5,
            TintColor = Color3.fromRGB(243, 153, 255)
        }):Play();
        CamShake:Shake(CamShake.Presets.Explosion);
        task.wait(0.38);
        ColorCorrectionEffect.Brightness = 131;
        ColorCorrectionEffect.Contrast = 0;
        ColorCorrectionEffect.Saturation = 155;
        task.wait(0.08);
        ColorCorrectionEffect.Brightness = -4;
        ColorCorrectionEffect.Contrast = 10;
        ColorCorrectionEffect.Saturation = -1;
        workspace.CurrentCamera.FieldOfView = 90;
        task.wait(0.08);
        ColorCorrectionEffect.Brightness = 1.5;
        ColorCorrectionEffect.Contrast = 0.1;
        ColorCorrectionEffect.Saturation = -0.2;
        u21 = false;
        u43:Stop();
        u42:Stop();
        game.Debris:AddItem(u42, 1);
        game.Debris:AddItem(u43, 1);
        game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainBreak);
        game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainImpact2);
        game.TweenService:Create(game.SoundService.Master.GameMusic, TweenInfo.new(3), {
            Volume = 1
        }):Play();
        game.Workspace.CurrentCamera.FieldOfView = 110;
        CamShake:Shake(CamShake.Presets.Explosion);
        local u84 = ChainedMoon.Moon:GetPivot();
        ChainedMoon.Moon:PivotTo(u84 * CFrame.new(0, -600, 0));
        ChainedMoon.Parent = workspace;
        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2), {
            Brightness = 0.1,
            Contrast = 0.2,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 172, 241)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(3), {
            FieldOfView = 70
        }):Play();
        local u85 = game.ReplicatedStorage.Assets.ChainBreak:Clone();
        local u86 = true;
        u85.Parent = workspace.CurrentCamera;
        task.spawn(function() -- Line: 330
            -- upvalues: u86 (ref), u85 (copy)
            while u86 do
                game:GetService("RunService").RenderStepped:Wait();
                local v87 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
                local v88 = math.tan(v87) * 4 / (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
                u85.Size = Vector3.new(v88, 0.1, 2.2);
                u85.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -2);
            end;
        end);

        for _, child in u85:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
        end;

        task.delay(8, function() -- Line: 349
            -- upvalues: u85 (copy), u86 (ref)
            u85:Destroy();
            u86 = false;
        end);
        task.spawn(function() -- Line: 354
            -- upvalues: ChainedMoon (ref), u19 (ref), TweenService (ref), u84 (copy), ColorCorrectionEffect (copy), CamShake (ref)
            local v89 = 0;

            for _, child in ChainedMoon.Debris:GetChildren() do
                game.TweenService:Create(child, TweenInfo.new(1.5), {
                    TimeScale = 1
                }):Play();
            end;

            u19.Parent = workspace;
            u19:Play();
            TweenService:Create(u19, TweenInfo.new(1), {
                Volume = 0.3
            }):Play();

            while v89 < 4 do
                v89 = v89 + task.wait(0.025);
                local v90 = (u84 * CFrame.new(0, -600, 0)):Lerp(u84, (TweenService:GetValue(v89 / 4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut))) * CFrame.new(Random.new():NextUnitVector() * 1);
                ChainedMoon.Moon:PivotTo(v90);
            end;

            task.spawn(function() -- Line: 383
                -- upvalues: ChainedMoon (ref), u84 (ref), TweenService (ref), ColorCorrectionEffect (ref)
                local v91 = {};
                local v92 = {};

                for _, child in ChainedMoon.Rocks:GetChildren() do
                    v91[child] = child:GetPivot();
                    v92[child] = Random.new():NextInteger(0, 10000);
                end;

                while isActive do
                    ChainedMoon.Moon:PivotTo(u84 * CFrame.new(Random.new():NextUnitVector() * 1));

                    for _, child in ChainedMoon.Rocks:GetChildren() do
                        local new = CFrame.new;
                        local v93 = tick() * 90 + v92[child];
                        local v94 = math.rad(v93);
                        child:PivotTo(new(0, math.sin(v94) * 10, 0) * v91[child]);
                    end;

                    task.wait(0.025);
                end;

                for i, v in v91 do
                    i:PivotTo(v);
                end;

                TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2), {
                    Brightness = 0,
                    Contrast = 0,
                    Saturation = 0,
                    TintColor = Color3.fromRGB(255, 255, 255)
                }):Play();
                game.Debris:AddItem(ColorCorrectionEffect, 5);
            end);
            CamShake:StopSustained(2);
            CamShake:ShakeSustain(CamShake.Presets.SoftEarthquake);
        end);
    end);
end;

local function stopUpdateLoop() -- Line: 422
    -- upvalues: TweenService (copy), CamShake (copy), u17 (ref), u19 (copy), ChainedMoon (copy), ReplicatedStorage (copy), Skybox (copy), EnchainedMoon (copy)
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
        TintColor = Color3.fromRGB(243, 153, 255)
    }):Play();
    CamShake:Shake(CamShake.Presets.Explosion);

    if u17 then
        u17:Destroy();
        u17 = nil;
    end;

    u19:Stop();
    u19.Volume = 0;
    CamShake:StopSustained(3);
    game.SoundService:PlayLocalSound(game.SoundService.SFX.Snap);
    task.delay(0.4, function() -- Line: 441
        -- upvalues: TweenService (ref), ColorCorrectionEffect (copy)
        TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2), {
            Brightness = 0,
            Contrast = 0,
            Saturation = 0,
            TintColor = Color3.fromRGB(255, 255, 255)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(2), {
            FieldOfView = 70
        }):Play();
    end);
    game.TweenService:Create(workspace.Terrain.Clouds, TweenInfo.new(1), {
        Cover = 0.5
    }):Play();
    ChainedMoon.Parent = ReplicatedStorage.Assets;
    Skybox.SetOrder(EnchainedMoon, 0);
end;

function v1.Start(p95, p96, p97) -- Line: 453
    -- upvalues: LightingController (copy), u5 (copy), startUpdateLoop (copy)
    if isActive then
        return;
    end;

    isActive = true;
    game.TweenService:Create(game.SoundService.Master.GameMusic, TweenInfo.new(3), {
        Volume = 0
    }):Play();
    LightingController:TransitionTo(u5, 3);
    task.wait(3);
    startUpdateLoop();
end;

function v1.End(p98) -- Line: 466
    -- upvalues: stopUpdateLoop (copy)
    if not isActive then
        return;
    end;

    isActive = false;
    stopUpdateLoop();
end;

local function newCharacter(p99) -- Line: 475
    -- upvalues: ReplicatedStorage (copy), Players (copy), u18 (ref), LocalPlayer (copy), FieldOfViewController (copy), NotificationController (copy)
    if p99:GetAttribute("Enchained") then
        return;
    end;

    p99:SetAttribute("Enchained", true);

    for _, child in ReplicatedStorage.Assets.EnchainedEffect:GetChildren() do
        local v100 = child:Clone();

        if v100:IsA("Highlight") then
            v100.Parent = p99;
        else
            v100.Parent = p99:WaitForChild("Torso");
        end;

        v100:AddTag("EnchainedClearup");
    end;

    if p99 == Players.LocalPlayer.Character and not u18 then
        u18 = ReplicatedStorage.Assets.Vignette:Clone();
        u18.ImageLabel.ImageTransparency = 0.7;
        u18.ImageLabel.UIScale.Scale = 1;
        game.TweenService:Create(u18.ImageLabel.UIScale, TweenInfo.new(1), {
            Scale = 1.04
        }):Play();
        game.TweenService:Create(u18.ImageLabel, TweenInfo.new(1), {
            ImageTransparency = 0.8
        }):Play();
        u18.Parent = LocalPlayer.PlayerGui;
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Parent = game.Lighting;
        game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
            Brightness = 0.4,
            TintColor = Color3.fromRGB(235, 175, 255)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
            FieldOfView = 90
        }):Play();
        task.delay(0.4, function() -- Line: 515
            -- upvalues: ColorCorrectionEffect (copy), FieldOfViewController (ref)
            game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.8), {
                Brightness = 0,
                TintColor = Color3.fromRGB(255, 255, 255)
            }):Play();
            game.Debris:AddItem(ColorCorrectionEffect, 0.8);
            game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.6), {
                FieldOfView = 80
            }):Play();
            FieldOfViewController:SetBaseFOV(80);
        end);

        local function Color(p101, p102) -- Line: 524
            return "<font color=\"#" .. p102:ToHex() .. "\">" .. p101 .. "</font>";
        end;

        NotificationController:CreateNotification("You\'ve been " .. ("<font color=\"#" .. Color3.fromRGB(239, 116, 255):ToHex() .. "\">ENCHAINED!</font>") .. " Button mash to ESCAPE!", nil, 7);
    end;
end;

local function clearupCharacter(p103) -- Line: 538
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), u18 (ref), u17 (ref), FieldOfViewController (copy)
    local v104 = ReplicatedStorage.Assets.EnchainedDisperse:Clone();
    v104.Parent = p103.HumanoidRootPart;

    for _, child in v104:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Emit(child:GetAttribute("EmitCount") or 3);
        elseif child:IsA("Sound") then
            child:Play();
        end;
    end;

    if p103 == LocalPlayer.Character and u18 then
        game.TweenService:Create(u17.ImageLabel.UIScale, TweenInfo.new(1), {
            Scale = 1.14
        }):Play();
        u18.ImageLabel.ImageColor3 = Color3.fromRGB(255, 114, 217);
        game.TweenService:Create(u18.ImageLabel, TweenInfo.new(1), {
            ImageTransparency = 1
        }):Play();
        FieldOfViewController:SetBaseFOV(70);
        game.Debris:AddItem(u18, 1);
        u18 = nil;
    end;

    game.Debris:AddItem(v104, 3);
    p103:SetAttribute("Enchained", nil);

    for _, descendant in p103:GetDescendants() do
        if descendant:HasTag("EnchainedClearup") then
            if descendant:IsA("Highlight") then
                game.TweenService:Create(descendant, TweenInfo.new(0.5), {
                    FillTransparency = 1,
                    OutlineTransparency = 1
                }):Play();
            elseif descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
                descendant.Enabled = false;
            end;

            game.Debris:AddItem(descendant, 1);
        end;
    end;
end;

for _, v in game.CollectionService:GetTagged("EnchainedHighlight") do
    newCharacter(v);
end;

game.CollectionService:GetInstanceAddedSignal("EnchainedHighlight"):Connect(newCharacter);
game.CollectionService:GetInstanceRemovedSignal("EnchainedHighlight"):Connect(clearupCharacter);
local PlantVisualizerController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.PlantVisualizerController);
Networking.WeatherEffects.ChainPull.OnClientEvent:Connect(function() -- Line: 594
    -- upvalues: PlantVisualizerController (copy), Networking (copy), LocalPlayer (copy), RagdollModule (copy), ButtonMash (copy), ChainedMoon (copy)
    if PlantVisualizerController:GetOfflineCutsceneState() then
        task.wait(0.3);
        Networking.WeatherEffects.ChainPull:Fire(false);

        return;
    end;

    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics);
    RagdollModule:Ragdoll(LocalPlayer.Character);
    local v105 = tick();
    local u106 = nil;
    task.spawn(function() -- Line: 609
        -- upvalues: u106 (ref), ButtonMash (ref)
        u106 = ButtonMash.Start(0.1, 0.4);
    end);
    local u107 = nil;
    u107 = ChainedMoon.FloorCheck.Touched:Connect(function(p108) -- Line: 613
        -- upvalues: LocalPlayer (ref), u107 (ref)
        if LocalPlayer.Character and p108:IsDescendantOf(LocalPlayer.Character) then
            u107:Disconnect();
            u107 = nil;
        end;
    end);

    repeat
        task.wait(0);
    until u106 or (tick() - v105 > 15 or u107 == nil);

    if u107 then
        u107:Disconnect();
        u107 = nil;
    end;

    ButtonMash.Disable();
    LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp);
    RagdollModule:Unragdoll(LocalPlayer.Character);
    game.SoundService:PlayLocalSound(game.SoundService.SFX.ChainAttacks.Chain);
    Networking.WeatherEffects.ChainPull:Fire(u106);
end);

return v1;