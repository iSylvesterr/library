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
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local FieldOfViewController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.FieldOfViewController);
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local Goldmoon = ReplicatedStorage.Assets:WaitForChild("Goldmoon");
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
local Goldmoon2 = game.ReplicatedStorage.Assets.Skybox.Goldmoon;

local function lerp(p2, p3, p4) -- Line: 31
    return p2 + (p3 - p2) * p4;
end;

local u5 = {
    Brightness = 4,
    EnvironmentDiffuseScale = 1,
    ClockTime = 21,
    Ambient = Color3.fromRGB(241, 175, 7),
    ColorShift_Bottom = Color3.fromRGB(35, 135, 171),
    ColorShift_Top = Color3.fromRGB(250, 218, 34),
    OutdoorAmbient = Color3.fromRGB(74, 139, 180)
};

local function ScaleModelTo(p6, p7, p8, p9, p10) -- Line: 45
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

local function newCharacter(p17) -- Line: 73
    -- upvalues: ReplicatedStorage (copy), Players (copy), u16 (ref), LocalPlayer (copy), FieldOfViewController (copy), NotificationController (copy)
    if p17:GetAttribute("Gold") then
        return;
    end;

    p17:SetAttribute("Gold", true);

    for _, child in ReplicatedStorage.Assets.GoldEffect:GetChildren() do
        local v18 = child:Clone();

        if v18:IsA("Highlight") then
            v18.Parent = p17;
        else
            v18.Parent = p17:WaitForChild("Torso");
        end;

        v18:AddTag("ClearUpGold");
    end;

    if p17 == Players.LocalPlayer.Character and not u16 then
        u16 = ReplicatedStorage.Assets.Vignette:Clone();
        u16.ImageLabel.ImageTransparency = 0.7;
        u16.ImageLabel.UIScale.Scale = 1;
        u16.ImageLabel.ImageColor3 = Color3.fromRGB(255, 234, 128);
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
            TintColor = Color3.fromRGB(255, 223, 94)
        }):Play();
        game.TweenService:Create(game.Workspace.CurrentCamera, TweenInfo.new(0.4), {
            FieldOfView = 90
        }):Play();
        task.delay(0.4, function() -- Line: 111
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

        local function Color(p19, p20) -- Line: 120
            return "<font color=\"#" .. p20:ToHex() .. "\">" .. p19 .. "</font>";
        end;

        NotificationController:CreateNotification("You are " .. ("<font color=\"#" .. Color3.fromRGB(255, 204, 0):ToHex() .. "\">MIDAS!</font>") .. " Steal QUICK to get a " .. "<font color=\"#" .. Color3.fromRGB(255, 204, 0):ToHex() .. "\">GOLD CROP!</font>", nil, 7);
    end;
end;

local function clearupCharacter(p21) -- Line: 133
    -- upvalues: ReplicatedStorage (copy), LocalPlayer (copy), u16 (ref), FieldOfViewController (copy)
    local v22 = ReplicatedStorage.Assets.GoldDisperse:Clone();
    v22.Parent = p21.HumanoidRootPart;

    for _, child in v22:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child:Emit(child:GetAttribute("EmitCount") or 3);
        elseif child:IsA("Sound") then
            child:Play();
        end;
    end;

    if p21 == LocalPlayer.Character and u16 then
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

    game.Debris:AddItem(v22, 3);
    p21:SetAttribute("Gold", nil);

    for _, descendant in p21:GetDescendants() do
        if descendant:HasTag("ClearUpGold") then
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

for _, v in game.CollectionService:GetTagged("GoldHighlight") do
    newCharacter(v);
end;

game.CollectionService:GetInstanceAddedSignal("GoldHighlight"):Connect(newCharacter);
game.CollectionService:GetInstanceRemovedSignal("GoldHighlight"):Connect(clearupCharacter);
Networking.WeatherEffects.GoldMoonStrike.OnClientEvent:Connect(function(p23) -- Line: 184
    -- upvalues: ReplicatedStorage (copy)
    local v24 = ReplicatedStorage.Assets.GoldMeteor:Clone();
    local v25 = CFrame.new(p23) * CFrame.new(0, 200, 250);
    v24.CFrame = v25;
    v24.Parent = workspace;
    v24.Travel:Play();
    local v26 = 0;

    while v26 < 2 do
        v26 = v26 + task.wait(0.025);
        local v27 = game.TweenService:GetValue(v26 / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.In);
        v24:PivotTo(v25:Lerp(CFrame.new(p23), v27));
        v24.Attachment.BillboardGui.ImageLabel.Rotation = tick() * 720 % 360;
    end;

    v24.Poof:Play();
    v24.Attachment.BillboardGui.Enabled = false;

    for _, child in v24.Attachment.Attachment:GetChildren() do
        child:Emit(child:GetAttribute("EmitCount") or 5);
    end;

    game.Debris:AddItem(v24, 4);
end);

local function startUpdateLoop() -- Line: 221
    -- upvalues: Goldmoon (copy), Skybox (copy), Goldmoon2 (copy), ScaleModelTo (copy)
    task.delay(2, function() -- Line: 224
        -- upvalues: Goldmoon (ref), Skybox (ref), Goldmoon2 (ref), ScaleModelTo (ref)
        Goldmoon.MoonModel:ScaleTo(0.01);
        Skybox.SetOrder(Goldmoon2, 2);
        ScaleModelTo(Goldmoon.MoonModel, 1, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
    end);
end;

local function stopUpdateLoop() -- Line: 231
    -- upvalues: Goldmoon (copy), ReplicatedStorage (copy), Skybox (copy), Goldmoon2 (copy)
    Goldmoon.Parent = ReplicatedStorage.Assets;
    Skybox.SetOrder(Goldmoon2, 0);
end;

function v1.Start(p28, p29, p30) -- Line: 240
    -- upvalues: NotificationController (copy), LightingController (copy), u5 (copy), Goldmoon (copy), Skybox (copy), Goldmoon2 (copy), ScaleModelTo (copy)
    if isActive then
        return;
    end;

    isActive = true;
    NotificationController:CreateNotification("May midas grace you...");
    LightingController:TransitionTo(u5, 3);
    Goldmoon.Parent = workspace;
    task.delay(2, function() -- Line: 224
        -- upvalues: Goldmoon (ref), Skybox (ref), Goldmoon2 (ref), ScaleModelTo (ref)
        Goldmoon.MoonModel:ScaleTo(0.01);
        Skybox.SetOrder(Goldmoon2, 2);
        ScaleModelTo(Goldmoon.MoonModel, 1, 1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
    end);
end;

function v1.End(p31) -- Line: 251
    -- upvalues: Goldmoon (copy), ReplicatedStorage (copy), Skybox (copy), Goldmoon2 (copy)
    if not isActive then
        return;
    end;

    isActive = false;
    Goldmoon.Parent = ReplicatedStorage.Assets;
    Skybox.SetOrder(Goldmoon2, 0);
end;

return v1;