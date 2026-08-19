-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(script.Types);
local LocalPlayer = Players.LocalPlayer;
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Class = require(script.Class);
local u1 = {};

local function GetSpectatedTeam() -- Line: 30
    -- upvalues: SpectateController (copy), LocalPlayer (copy)
    local v2 = SpectateController.GetPlayer();

    if v2 and v2 ~= LocalPlayer then
        return v2:GetAttribute("Team");
    end;

    return nil;
end;

local function CreatePositionPing(p3, u4) -- Line: 38
    -- upvalues: Class (copy), SpectateController (copy), LocalPlayer (copy), u1 (copy)
    local new = Class.new;
    local v5 = SpectateController.GetPlayer();
    local v6;

    if v5 and v5 ~= LocalPlayer then
        v6 = v5:GetAttribute("Team");
    else
        v6 = nil;
    end;

    local u7 = new(p3, u4, v6);
    u1[u4] = u7;

    return function() -- Line: 42
        -- upvalues: u1 (ref), u4 (copy), u7 (copy)
        u1[u4] = nil;
        u7:Destroy();
    end;
end;

LocalPlayer.CharacterAdded:Connect(function(p8) -- Line: 53
    -- upvalues: u1 (copy)
    for _, v in pairs(u1) do
        v:UpdateVisibility(nil);
    end;
end);
SpectateController.ListenToSpectate:Connect(function(p9) -- Line: 61
    -- upvalues: u1 (copy)
    if p9 then
        p9 = p9:GetAttribute("Team");
    end;

    for _, v in pairs(u1) do
        v:UpdateVisibility(p9);
    end;
end);

return Observers.observeTag("PlayerPositionMarker", function(p10) -- Line: 73
    -- upvalues: DataController (copy), LocalPlayer (copy), HttpService (copy), Class (copy), SpectateController (copy), u1 (copy)
    if DataController.Get(LocalPlayer, "Settings.Game.HUD.Player Pings") == "Disabled" then
        return nil;
    end;

    if not p10:IsDescendantOf(workspace) then
        return nil;
    end;

    local u11 = HttpService:GenerateGUID(false);
    local new = Class.new;
    local v12 = SpectateController.GetPlayer();
    local v13;

    if v12 and v12 ~= LocalPlayer then
        v13 = v12:GetAttribute("Team");
    else
        v13 = nil;
    end;

    local u14 = new(p10, u11, v13);
    u1[u11] = u14;

    return function() -- Line: 42
        -- upvalues: u1 (ref), u11 (copy), u14 (copy)
        u1[u11] = nil;
        u14:Destroy();
    end;
end);