-- Decompiled with Potassium's decompiler.

local v1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local NotificationController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.NotificationController);
local LightingController = require(game.StarterPlayer.StarterPlayerScripts.Controllers.LightingController);
local Skybox = require(game.ReplicatedStorage.ClientModules.Skybox);
local u2 = {
    Brightness = 3,
    ClockTime = 2.6,
    Ambient = Color3.fromRGB(112, 71, 40),
    ColorShift_Bottom = Color3.fromRGB(122, 71, 33),
    ColorShift_Top = Color3.fromRGB(240, 168, 84),
    OutdoorAmbient = Color3.fromRGB(96, 71, 58)
};
local u3 = false;
local u4 = nil;

local function lerp(p5, p6, p7) -- Line: 46
    return p5 + (p6 - p5) * p7;
end;

local function scaleModelTo(p8, p9, p10) -- Line: 50
    -- upvalues: TweenService (copy)
    local v11 = p8:GetScale();
    local v12 = 0;

    while v12 < p10 do
        v12 = v12 + task.wait(0);
        local v13 = TweenService:GetValue(math.clamp(v12 / p10, 0.01, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.InOut);
        p8:ScaleTo(v11 + (p9 - v11) * v13);
    end;
end;

local function getSkybox() -- Line: 62
    -- upvalues: ReplicatedStorage (copy)
    local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

    if Skybox2 then
        Skybox2 = Skybox2:FindFirstChild("HarvestMoon");
    end;

    if Skybox2 and Skybox2:IsA("Sky") then
        return Skybox2;
    end;

    return nil;
end;

local function showVfx() -- Line: 71
    -- upvalues: ReplicatedStorage (copy), u4 (ref), Skybox (copy), u3 (ref), scaleModelTo (copy)
    local HarvestMoon = ReplicatedStorage.Assets:FindFirstChild("HarvestMoon");

    if not HarvestMoon then
        return;
    end;

    u4 = HarvestMoon;
    HarvestMoon.Parent = workspace;
    local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

    if Skybox2 then
        Skybox2 = Skybox2:FindFirstChild("HarvestMoon");
    end;

    if not (Skybox2 and Skybox2:IsA("Sky")) then
        Skybox2 = nil;
    end;

    if Skybox2 then
        Skybox.SetOrder(Skybox2, 2);
    end;

    local MoonModel = HarvestMoon:FindFirstChild("MoonModel");

    if MoonModel and MoonModel:IsA("Model") then
        task.delay(2, function() -- Line: 87
            -- upvalues: u3 (ref), MoonModel (copy), scaleModelTo (ref)
            if not u3 then
                return;
            end;

            MoonModel:ScaleTo(0.01);
            scaleModelTo(MoonModel, 1, 1);
        end);
    end;
end;

local function hideVfx() -- Line: 95
    -- upvalues: u4 (ref), ReplicatedStorage (copy), Skybox (copy)
    local v14 = u4;
    u4 = nil;

    if v14 then
        v14.Parent = ReplicatedStorage.Assets;
    end;

    local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

    if Skybox2 then
        Skybox2 = Skybox2:FindFirstChild("HarvestMoon");
    end;

    if not (Skybox2 and Skybox2:IsA("Sky")) then
        Skybox2 = nil;
    end;

    if Skybox2 then
        Skybox.SetOrder(Skybox2, 0);
    end;
end;

local function color(p15, p16) -- Line: 108
    return "<font color=\"#" .. p16:ToHex() .. "\">" .. p15 .. "</font>";
end;

local function announceFeatured() -- Line: 115
    -- upvalues: u3 (ref), NotificationController (copy)
    task.spawn(function() -- Line: 116
        -- upvalues: u3 (ref), NotificationController (ref)
        local v17 = workspace:GetServerTimeNow() + 3;
        local v18 = workspace:GetAttribute("HarvestMoonFeaturedFruit");

        while type(v18) ~= "string" and (u3 and workspace:GetServerTimeNow() < v17) do
            task.wait(0.1);
            v18 = workspace:GetAttribute("HarvestMoonFeaturedFruit");
        end;

        if not u3 or type(v18) ~= "string" then
            return;
        end;

        NotificationController:CreateNotification("Steve is paying a fortune for " .. ("<font color=\"#" .. Color3.fromRGB(255, 179, 71):ToHex() .. "\">" .. v18 .. "</font>") .. " tonight!", nil, 7);
    end);
end;

function v1.Start(p19, p20, p21) -- Line: 134
    -- upvalues: u3 (ref), NotificationController (copy), LightingController (copy), u2 (copy), showVfx (copy)
    if u3 then
        return;
    end;

    u3 = true;
    NotificationController:CreateNotification("The Harvest Moon rises... everything grows FAST!");
    LightingController:TransitionTo(u2, 3);
    showVfx();
    task.spawn(function() -- Line: 116
        -- upvalues: u3 (ref), NotificationController (ref)
        local v22 = workspace:GetServerTimeNow() + 3;
        local v23 = workspace:GetAttribute("HarvestMoonFeaturedFruit");

        while type(v23) ~= "string" and (u3 and workspace:GetServerTimeNow() < v22) do
            task.wait(0.1);
            v23 = workspace:GetAttribute("HarvestMoonFeaturedFruit");
        end;

        if not u3 or type(v23) ~= "string" then
            return;
        end;

        NotificationController:CreateNotification("Steve is paying a fortune for " .. ("<font color=\"#" .. Color3.fromRGB(255, 179, 71):ToHex() .. "\">" .. v23 .. "</font>") .. " tonight!", nil, 7);
    end);
end;

function v1.End(p24) -- Line: 145
    -- upvalues: u3 (ref), u4 (ref), ReplicatedStorage (copy), Skybox (copy)
    if not u3 then
        return;
    end;

    u3 = false;
    local v25 = u4;
    u4 = nil;

    if v25 then
        v25.Parent = ReplicatedStorage.Assets;
    end;

    local Skybox2 = ReplicatedStorage.Assets:FindFirstChild("Skybox");

    if Skybox2 then
        Skybox2 = Skybox2:FindFirstChild("HarvestMoon");
    end;

    if not (Skybox2 and Skybox2:IsA("Sky")) then
        Skybox2 = nil;
    end;

    if Skybox2 then
        Skybox.SetOrder(Skybox2, 0);
    end;
end;

return v1;