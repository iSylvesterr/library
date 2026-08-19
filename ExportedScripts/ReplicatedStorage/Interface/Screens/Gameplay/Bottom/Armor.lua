-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(ReplicatedStorage.Database.Custom.Types);
local LocalPlayer = Players.LocalPlayer;
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = nil;
local u3 = Janitor.new();

local function ParseArmorAttribute(u4) -- Line: 42
    -- upvalues: HttpService (copy)
    if typeof(u4) ~= "string" or u4 == "" then
        return nil;
    end;

    local success, result = pcall(function() -- Line: 47
        -- upvalues: HttpService (ref), u4 (copy)
        return HttpService:JSONDecode(u4);
    end);

    return success and typeof(result) == "table" and {
        Type = tostring(result.Type or ""),
        Health = tonumber(result.Health) or 0
    } or nil;
end;

local function UpdateArmorUIFromAttribute(p5) -- Line: 62
    -- upvalues: ParseArmorAttribute (copy), u2 (ref), u1 (copy)
    local v6 = ParseArmorAttribute(p5);
    local v7;

    if v6 == nil then
        v7 = false;
    else
        v7 = v6.Health > 0;
    end;

    u2.Visible = v7;

    if v7 and v6 then
        u1.updateFrame(v6);
    end;
end;

function u1.updateFrame(p8) -- Line: 72
    -- upvalues: GetPreferenceColor (copy), u2 (ref)
    local v9 = GetPreferenceColor();
    u2.Helmet.Visible = p8.Type == "Kevlar + Helmet";
    local Amount = u2.Amount;
    local v10 = math.round(p8.Health);
    Amount.Text = tostring(v10);
    u2.Helmet.ImageColor3 = v9;
    u2.Amount.TextColor3 = v9;
    u2.Armor.ImageColor3 = v9;
end;

local function updateArmorFromPlayer(p11) -- Line: 84
    -- upvalues: u3 (copy), Observers (copy), ParseArmorAttribute (copy), u2 (ref), u1 (copy)
    u3:Cleanup();
    u3:Add(Observers.observeAttribute(p11, "Armor", function(p12) -- Line: 88
        -- upvalues: ParseArmorAttribute (ref), u2 (ref), u1 (ref)
        local v13 = ParseArmorAttribute(p12);
        local v14;

        if v13 == nil then
            v14 = false;
        else
            v14 = v13.Health > 0;
        end;

        u2.Visible = v14;

        if v14 and v13 then
            u1.updateFrame(v13);
        end;
    end));
    local v15 = ParseArmorAttribute((p11:GetAttribute("Armor")));
    local v16;

    if v15 == nil then
        v16 = false;
    else
        v16 = v15.Health > 0;
    end;

    u2.Visible = v16;

    if v16 and v15 then
        u1.updateFrame(v15);
    end;
end;

function u1.Initialize(p17, p18) -- Line: 97
    -- upvalues: u2 (ref), LocalPlayer (copy), updateArmorFromPlayer (copy), DataController (copy), ParseArmorAttribute (copy), u1 (copy)
    u2 = p18;

    if u2.Active then
        u2.Active = false;
    end;

    for _, descendant in ipairs(u2:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.Active = false;
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(function() -- Line: 113
        -- upvalues: updateArmorFromPlayer (ref), LocalPlayer (ref)
        updateArmorFromPlayer(LocalPlayer);
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 118
        -- upvalues: LocalPlayer (ref), ParseArmorAttribute (ref), u1 (ref)
        local v19 = ParseArmorAttribute((LocalPlayer:GetAttribute("Armor")));

        if v19 and v19.Health > 0 then
            u1.updateFrame(v19);
        end;
    end);
end;

function u1.Start() -- Line: 127
    -- upvalues: u3 (copy), updateArmorFromPlayer (copy), LocalPlayer (copy), SpectateController (copy), GameState (copy)
    local function TrackPlayer(p20) -- Line: 128
        -- upvalues: u3 (ref), updateArmorFromPlayer (ref)
        u3:Cleanup();
        updateArmorFromPlayer(p20);
    end;

    LocalPlayer.CharacterAdded:Connect(function() -- Line: 133
        -- upvalues: LocalPlayer (ref), u3 (ref), updateArmorFromPlayer (ref)
        u3:Cleanup();
        updateArmorFromPlayer(LocalPlayer);
    end);
    SpectateController.ListenToSpectate:Connect(function(p21) -- Line: 138
        -- upvalues: u3 (ref), updateArmorFromPlayer (ref), LocalPlayer (ref)
        if not p21 then
            if not LocalPlayer:GetAttribute("IsSpectating") then
                u3:Cleanup();
                updateArmorFromPlayer(LocalPlayer);
            end;

            return;
        end;

        u3:Cleanup();
        updateArmorFromPlayer(p21);
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 149
        -- upvalues: LocalPlayer (ref), u3 (ref), updateArmorFromPlayer (ref), SpectateController (ref)
        if LocalPlayer:GetAttribute("IsSpectating") then
            local v22 = SpectateController.GetPlayer();

            if v22 then
                u3:Cleanup();
                updateArmorFromPlayer(v22);
            end;

            return;
        end;

        u3:Cleanup();
        updateArmorFromPlayer(LocalPlayer);
    end);

    if LocalPlayer:GetAttribute("IsSpectating") then
        local v23 = SpectateController.GetPlayer();

        if v23 then
            u3:Cleanup();
            updateArmorFromPlayer(v23);
        end;
    else
        u3:Cleanup();
        updateArmorFromPlayer(LocalPlayer);
    end;

    GameState.ListenToState(function(p24, p25) -- Line: 172
        -- upvalues: LocalPlayer (ref), u3 (ref), updateArmorFromPlayer (ref)
        if p25 == "Buy Period" or p25 == "Round In Progress" then
            u3:Cleanup();
            updateArmorFromPlayer(LocalPlayer);
        end;
    end);
end;

return u1;