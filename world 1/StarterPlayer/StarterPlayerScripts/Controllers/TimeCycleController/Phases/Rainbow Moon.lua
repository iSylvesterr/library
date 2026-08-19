-- Decompiled with Potassium's decompiler.

local v1 = {};
game:GetService("Lighting");
local TweenService = game:GetService("TweenService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Players = game:GetService("Players");
game:GetService("SoundService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local LocalPlayer = Players.LocalPlayer;
local CamShake = require(ReplicatedStorage.ClientModules.CamShake);
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local RainbowMoon = ReplicatedStorage.Assets:WaitForChild("RainbowMoon");
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
local RainbowMoon2 = game.ReplicatedStorage.Assets.Skybox.RainbowMoon;

local function lerp(p2, p3, p4) -- Line: 32
    return p2 + (p3 - p2) * p4;
end;

local u5 = {
    Brightness = 4,
    EnvironmentDiffuseScale = 1,
    ClockTime = 23,
    Ambient = Color3.fromRGB(197, 36, 241),
    ColorShift_Bottom = Color3.fromRGB(74, 171, 110),
    ColorShift_Top = Color3.fromRGB(125, 63, 250),
    OutdoorAmbient = Color3.fromRGB(74, 139, 180)
};

local function ScaleModelTo(p6, p7, p8, p9, p10) -- Line: 46
    -- upvalues: TweenService (copy)
    local v11 = p6:GetScale();
    local v12 = p9 or Enum.EasingStyle.Linear;
    local v13 = p10 or Enum.EasingDirection.InOut;
    local v14 = 0;

    while v14 < p8 do
        v14 = v14 + task.wait(0);
        local v15 = TweenService:GetValue(math.clamp(v14 / p8, 0.01, 1), v12, v13);
        p6:ScaleTo(v11 + (p7 - v11) * v15);
    end;
end;

local u16 = nil;
task.spawn(function() -- Line: 74
    while true do
        task.wait(0.025);
        local v17 = tick() / 2 % 1;
        local v18 = Color3.fromHSV(v17, 1, 1);

        for _, v in game.CollectionService:GetTagged("RainbowTween") do
            if v:IsA("Highlight") then
                local v19 = v:HasTag("Multiplier") and 1.5 or 1;
                v.FillColor = Color3.fromHSV(v17 * v19, 1 * v19, 1 * v19);
            elseif v:IsA("ImageLabel") then
                v.ImageColor3 = v18;
            else
                v.Color = v18;
            end;
        end;
    end;
end);

local function newCharacter(p20) -- Line: 101
    -- upvalues: ReplicatedStorage (copy), Players (copy), u16 (ref), LocalPlayer (copy), FieldOfViewController (copy), NotificationController (copy)
    if p20:GetAttribute("Rainbow") then
        return;
    end;

    p20:SetAttribute("Rainbow", true);

    for _, child in ReplicatedStorage.Assets.RainbowEffect:GetChildren() do
        local v21 = child:Clone();

        if v21:IsA("Highlight") then
            v21.Parent = p20;
            v21:AddTag("Multiplier");
            v21:AddTag("RainbowTween");
        else
            v21.Parent = p20:WaitForChild("Torso");
        end;

        v21:AddTag("ClearUpRainbow");
    end;

    if p20 == Players.LocalPlayer.Character and not u16 then
        u16 = ReplicatedStorage.Assets.Vignette:Clone();
        u16.ImageLabel.ImageTransparency = 0.7;
        u16.ImageLabel.UIScale.Scale = 1;
        u16.ImageLabel:AddTag("RainbowTween");
        game.TweenService:Create(u16.ImageLabel.UIScale, TweenInfo.new(1), {
            Scale = 1.04
        }):Play();
        game.TweenService:Create(u16.ImageLabel, TweenInfo.new(1), {
            ImageTransparency = 0.8
        }):Play();
        u16.Parent = LocalPlayer.PlayerGui;
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Parent = game.Lighting;
        game.TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.4), {
            Brightness = 0.4,
            TintColor = Color3.fromRGB(235, 175, 255)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
            FieldOfView = 90
        }):Play();
        task.delay(0.4, function() -- Line: 141
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

        local function Color(p22, p23) -- Line: 150
            return "<font color=\"#" .. p23:ToHex() .. "\">" .. p22 .. "</font>";
        end;

        local function EvaluateColorSequence(p24, p25) -- Line: 155
            local Keypoints = p24.Keypoints;

            if p25 <= Keypoints[1].Time then
                return Keypoints[1].Value;
            end;

            if Keypoints[#Keypoints].Time <= p25 then
                return Keypoints[#Keypoints].Value;
            end;

            for i = 1, #Keypoints - 1 do
                local v26 = Keypoints[i];
                local v27 = Keypoints[i + 1];

                if v26.Time <= p25 and p25 <= v27.Time then
                    return v26.Value:lerp(v27.Value, (p25 - v26.Time) / (v27.Time - v26.Time));
                end;
            end;

            return Keypoints[#Keypoints].Value;
        end;

        NotificationController:CreateNotification("You are " .. ("<font color=\"#" .. Color3.fromRGB(255, 204, 0):ToHex() .. "\">STAR-POWERED!</font>") .. " Steal QUICK to get a " .. (function(p28, p29) -- Line: 177, Name: Gradient
            -- upvalues: EvaluateColorSequence (copy)
            local Color2 = p28.Color;
            local v30 = #p29;
            local v31 = {};

            for i = 1, v30 do
                local v32 = EvaluateColorSequence(Color2, (i - 1) / math.max(v30 - 1, 1));
                local v33 = string.sub(p29, i, i);
                local format = string.format;
                local v34 = v32:ToHex();
                table.insert(v31, format("<font color=\"#%s\">%s</font>", v34, v33));
            end;

            return table.concat(v31);
        end)(game.ReplicatedStorage.Assets.RainbowGradient, "RAINBOW") .. " plant!", nil, 7);
    end;
end;

local function clearupCharacter(p35) -- Line: 208
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), u16 (ref), FieldOfViewController (copy)
    local v36 = ReplicatedStorage.Assets.RainbowDisperse:Clone();
    v36.Parent = p35.HumanoidRootPart;

    for _, child in v36:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Emit(child:GetAttribute("EmitCount") or 3);
        elseif child:IsA("Sound") then
            child:Play();
        end;
    end;

    if p35 == LocalPlayer.Character and u16 then
        game.TweenService:Create(u16.ImageLabel.UIScale, TweenInfo.new(1), {
            Scale = 1.14
        }):Play();
        game.TweenService:Create(u16.ImageLabel, TweenInfo.new(1), {
            ImageTransparency = 1
        }):Play();
        FieldOfViewController:SetBaseFOV(70);
        game.Debris:AddItem(u16, 1);
        u16 = nil;
    end;

    game.Debris:AddItem(v36, 3);
    p35:SetAttribute("Rainbow", nil);

    for _, descendant in p35:GetDescendants() do
        if descendant:HasTag("ClearUpRainbow") then
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

for _, v in game.CollectionService:GetTagged("RainbowHighlight") do
    newCharacter(v);
end;

game.CollectionService:GetInstanceAddedSignal("RainbowHighlight"):Connect(newCharacter);
game.CollectionService:GetInstanceRemovedSignal("RainbowHighlight"):Connect(clearupCharacter);
Networking.WeatherEffects.RainbowMoonStrike.OnClientEvent:Connect(function(p37) -- Line: 259
    -- upvalues: ReplicatedStorage (copy)
    local v38 = ReplicatedStorage.Assets.RainbowMeteor:Clone();
    local v39 = CFrame.new(p37) * CFrame.new(0, 200, 250);
    v38.CFrame = v39;
    v38.Parent = workspace;
    v38.Travel:Play();
    local v40 = 0;

    while v40 < 2 do
        v40 = v40 + task.wait(0.025);
        local v41 = game.TweenService:GetValue(v40 / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        v38:PivotTo(v39:Lerp(CFrame.new(p37), v41));
        v38.Attachment.BillboardGui.ImageLabel.Rotation = tick() * 720 % 360;
        v38.Attachment.BillboardGui.ImageLabel.ImageColor3 = Color3.fromHSV(tick() % 1, 1, 1);
    end;

    v38.Poof:Play();
    v38.Attachment.BillboardGui.Enabled = false;

    for _, child in v38.Attachment.Attachment:GetChildren() do
        child:Emit(child:GetAttribute("EmitCount") or 5);
    end;

    game.Debris:AddItem(v38, 4);
end);

local function startUpdateLoop() -- Line: 295
    -- upvalues: Skybox (copy), RainbowMoon2 (copy), TweenService (copy), CamShake (copy), RainbowMoon (copy), ScaleModelTo (copy)
    game.TweenService:Create(workspace.Terrain.Clouds, TweenInfo.new(1), {
        Cover = 0
    }):Play();
    task.delay(1, function() -- Line: 299
        -- upvalues: Skybox (ref), RainbowMoon2 (ref)
        Skybox.SetOrder(RainbowMoon2, 2);
    end);
    task.delay(3, function() -- Line: 303
        -- upvalues: TweenService (ref), CamShake (ref), RainbowMoon (ref), ScaleModelTo (ref)
        local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
        ColorCorrectionEffect.Parent = game.Lighting;
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
        local u42 = game.ReplicatedStorage.Assets.RainbowScreenEffect:Clone();
        local u43 = true;
        u42.Parent = workspace.Camera;
        task.spawn(function() -- Line: 320
            -- upvalues: u43 (ref), u42 (copy)
            while u43 do
                local v44 = math.rad(workspace.CurrentCamera.FieldOfView / 2);
                local v45 = math.tan(v44) * 8 / (workspace.CurrentCamera.ViewportSize.X / workspace.CurrentCamera.ViewportSize.Y);
                u42.Size = Vector3.new(v45, 0.1, 2.2);
                u42.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0, 0, -4);
                game:GetService("RunService").RenderStepped:Wait();
            end;
        end);

        for _, child in u42:GetChildren() do
            child:Emit(child:GetAttribute("EmitCount"));
        end;

        game.SoundService:PlayLocalSound(game.SoundService.SFX.RainbowPoof);
        task.delay(8, function() -- Line: 339
            -- upvalues: u43 (ref)
            u43 = false;
        end);
        game.Debris:AddItem(u42, 8);
        task.delay(0.4, function() -- Line: 346
            -- upvalues: RainbowMoon (ref), TweenService (ref), ColorCorrectionEffect (copy), ScaleModelTo (ref)
            local CFrame2 = RainbowMoon.beams.CFrame;
            RainbowMoon.beams.CFrame = CFrame.new(0, -5, 0) * CFrame2;
            RainbowMoon.Parent = workspace;
            TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2), {
                Brightness = 0,
                Contrast = 0,
                Saturation = 0,
                TintColor = Color3.fromRGB(255, 255, 255)
            }):Play();
            game.TweenService:Create(RainbowMoon.beams, TweenInfo.new(0.4), {
                CFrame = CFrame2
            }):Play();
            game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(2), {
                FieldOfView = 70
            }):Play();
            task.wait(2);
            game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.2), {
                FieldOfView = 70
            }):Play();
            TweenService:Create(ColorCorrectionEffect, TweenInfo.new(0.2), {
                Brightness = 0.6,
                Contrast = 0,
                Saturation = 0.2,
                TintColor = Color3.fromRGB(243, 153, 255)
            }):Play();
            task.delay(0.3, function() -- Line: 362
                -- upvalues: TweenService (ref), ColorCorrectionEffect (ref)
                game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(2), {
                    FieldOfView = 70
                }):Play();
                TweenService:Create(ColorCorrectionEffect, TweenInfo.new(2), {
                    Brightness = 0,
                    Contrast = 0,
                    Saturation = 0,
                    TintColor = Color3.fromRGB(255, 255, 255)
                }):Play();
            end);
            ScaleModelTo(RainbowMoon.MoonModel, 1, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
        end);
    end);
end;

local function stopUpdateLoop() -- Line: 373
    -- upvalues: TweenService (copy), CamShake (copy), RainbowMoon (copy), ReplicatedStorage (copy), Skybox (copy), RainbowMoon2 (copy)
    local ColorCorrectionEffect = Instance.new("ColorCorrectionEffect");
    ColorCorrectionEffect.Parent = game.Lighting;
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
    game.SoundService:PlayLocalSound(game.SoundService.SFX.Snap);
    task.delay(0.4, function() -- Line: 383
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
    RainbowMoon.Parent = ReplicatedStorage.Assets;
    Skybox.SetOrder(RainbowMoon2, 0);
end;

function v1.Start(p46, p47, p48) -- Line: 395
    -- upvalues: LightingController (copy), u5 (copy), startUpdateLoop (copy)
    if isActive then
        return;
    end;

    isActive = true;
    LightingController:TransitionTo(u5, 3);
    startUpdateLoop();
end;

function v1.End(p49) -- Line: 404
    -- upvalues: stopUpdateLoop (copy)
    if not isActive then
        return;
    end;

    isActive = false;
    stopUpdateLoop();
end;

return v1;