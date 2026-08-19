-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Lighting = game:GetService("Lighting");
local Players = game:GetService("Players");
local Maps = ReplicatedStorage.Database.Custom.GameStats.Maps;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local LocalPlayer = Players.LocalPlayer;
local u1 = nil;
local u2 = nil;
local u3 = nil;
local u4 = nil;

local function applyGlobalShadowsSetting() -- Line: 33
    -- upvalues: DataController (copy), LocalPlayer (copy), Lighting (copy), u4 (ref)
    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u4 ~= nil then
            Lighting.GlobalShadows = u4;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function applyMapLighting(p5) -- Line: 47
    -- upvalues: Maps (copy), u4 (ref), Lighting (copy), DataController (copy), LocalPlayer (copy)
    local v6 = Maps:FindFirstChild(p5);

    if not (v6 and v6:IsA("ModuleScript")) then
        warn((`[MapLighting]: Map "{p5}" not found in database`));

        return;
    end;

    local v7 = require(v6);

    if not v7.Lighting then
        warn((`[MapLighting]: Map "{p5}" has no lighting configuration`));

        return;
    end;

    local Properties = v7.Lighting.Properties;

    if Properties then
        u4 = Properties.GlobalShadows;
        Lighting.Ambient = Properties.Ambient;
        Lighting.Brightness = Properties.Brightness;
        Lighting.ColorShift_Bottom = Properties.ColorShift_Bottom;
        Lighting.ColorShift_Top = Properties.ColorShift_Top;
        Lighting.EnvironmentDiffuseScale = Properties.EnvironmentDiffuseScale;
        Lighting.EnvironmentSpecularScale = Properties.EnvironmentSpecularScale;
        Lighting.GlobalShadows = Properties.GlobalShadows;
        Lighting.OutdoorAmbient = Properties.OutdoorAmbient;
        Lighting.ShadowSoftness = Properties.ShadowSoftness;
        Lighting.ClockTime = Properties.ClockTime;
        Lighting.GeographicLatitude = Properties.GeographicLatitude;
        Lighting.ExposureCompensation = Properties.ExposureCompensation;
    end;

    for _, child in ipairs(Lighting:GetChildren()) do
        if child.Name ~= "Menu" then
            child:Destroy();
        end;
    end;

    local Assets = v7.Lighting.Assets;

    if Assets then
        for _, child in ipairs(Assets:GetChildren()) do
            child:Clone().Parent = Lighting;
        end;
    end;

    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u4 ~= nil then
            Lighting.GlobalShadows = u4;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end;

local function getMapNameFromInstance(p8) -- Line: 101
    local v9 = p8:GetAttribute("MapName");

    if v9 and typeof(v9) == "string" then
        return v9;
    end;

    return nil;
end;

local function shouldApplyMapLighting() -- Line: 112
    -- upvalues: u1 (ref), ReplicatedStorage (copy), u2 (ref), u3 (ref)
    if not u1 then
        u1 = require(ReplicatedStorage.Controllers.MenuSceneController);
    end;

    if not u2 then
        u2 = require(ReplicatedStorage.Controllers.CaseSceneController);
    end;

    if not u3 then
        u3 = require(ReplicatedStorage.Controllers.InspectController);
    end;

    local v10 = not (u1.IsActive() or u2.IsActive()) and not u3.IsActive();

    return v10;
end;

local function handleMapLoaded(u11) -- Line: 128
    -- upvalues: shouldApplyMapLighting (copy), applyMapLighting (copy)
    if not shouldApplyMapLighting() then
        return;
    end;

    local v12 = u11:GetAttribute("MapName");

    if not v12 or typeof(v12) ~= "string" then
        v12 = nil;
    end;

    if v12 then
        applyMapLighting(v12);

        return;
    end;

    local u13 = nil;
    u13 = u11:GetAttributeChangedSignal("MapName"):Connect(function() -- Line: 140
        -- upvalues: shouldApplyMapLighting (ref), u13 (ref), u11 (copy), applyMapLighting (ref)
        if not shouldApplyMapLighting() then
            u13:Disconnect();

            return;
        end;

        local v14 = u11:GetAttribute("MapName");

        if not v14 or typeof(v14) ~= "string" then
            v14 = nil;
        end;

        if v14 then
            u13:Disconnect();
            applyMapLighting(v14);
        end;
    end);
end;

DataController.CreateListener(LocalPlayer, "Settings.Video.Presets.Global Shadows", function() -- Line: 160
    -- upvalues: DataController (copy), LocalPlayer (copy), Lighting (copy), u4 (ref)
    if DataController.Get(LocalPlayer, "Settings.Video.Presets.Global Shadows") ~= false then
        if u4 ~= nil then
            Lighting.GlobalShadows = u4;
        end;

        return;
    end;

    Lighting.GlobalShadows = false;
end);
workspace.ChildAdded:Connect(function(u15) -- Line: 165
    -- upvalues: handleMapLoaded (copy)
    if u15.Name == "Map" then
        task.defer(function() -- Line: 167
            -- upvalues: handleMapLoaded (ref), u15 (copy)
            handleMapLoaded(u15);
        end);
    end;
end);
local Map = workspace:FindFirstChild("Map");

if Map then
    task.defer(function() -- Line: 177
        -- upvalues: handleMapLoaded (copy), Map (copy)
        handleMapLoaded(Map);
    end);
end;

return nil;