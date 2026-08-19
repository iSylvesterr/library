-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Workspace = game:GetService("Workspace");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local Colors = require(ReplicatedStorage.Database.Custom.GameStats.Settings.Colors);
local u2 = nil;
local u3 = nil;
local u4 = Janitor.new();

local function updateADRDisplay(p5, p6) -- Line: 39
    -- upvalues: Colors (copy), u2 (ref)
    local v7 = p5:GetAttribute("Team");

    if not v7 then
        return;
    end;

    local v8 = Colors["Team Color"][v7];
    local v9 = p6 or (p5:GetAttribute("ADR") or 0);
    local v10 = math.floor(v9 * 10) / 10;
    local v11 = math.floor(v8.R * 255);
    local v12 = math.floor(v8.G * 255);
    local v13 = math.floor(v8.B * 255);
    u2.ADR.Text = `<font color="rgb({v11}, {v12}, {v13})">ADR:</font> {v10}`;
end;

local function isRoundBasedGamemode() -- Line: 56
    local v14 = workspace:GetAttribute("Gamemode");
    local v15;

    if v14 == nil then
        v15 = false;
    else
        v15 = v14 ~= "Deathmatch";
    end;

    return v15;
end;

local function updateRespawnNextVisibility() -- Line: 61
    -- upvalues: u2 (ref), LocalPlayer (copy)
    if not u2 then
        return;
    end;

    local v16 = LocalPlayer:GetAttribute("Team");
    local v17 = v16 == "Counter-Terrorists" and true or v16 == "Terrorists";
    local RespawnNext = u2.RespawnNext;

    if v17 then
        local v18 = workspace:GetAttribute("Gamemode");

        if v18 == nil then
            v17 = false;
        else
            v17 = v18 ~= "Deathmatch";
        end;
    end;

    RespawnNext.Visible = v17;
end;

function u1.UpdateFrame(u19) -- Line: 73
    -- upvalues: SpectateController (copy), u2 (ref), Colors (copy), GetBadgeIcon (copy), u4 (copy), Observers (copy), updateADRDisplay (copy), GetSkinDisplayName (copy)
    local v20 = SpectateController.GetCurrentSpectateInstance();
    u2.Player.Player.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={u19.UserId}&w=150&h=150`;
    u2.Username.Text = u19.Name;
    local v21 = u19:GetAttribute("Team");

    if v21 then
        local v22 = Colors["Team Color"][v21];
        u2.Username.TextColor3 = v22;
        u2.Badge.Image = GetBadgeIcon(u19, v21);
        u2.Frame1.BackgroundColor3 = v22;
        u2.Frame2.BackgroundColor3 = v22;
        u2.Player.Outline.ImageColor3 = v22;
    end;

    u4:Cleanup();
    u4:Add(Observers.observeAttribute(u19, "ADR", function(p23) -- Line: 95
        -- upvalues: updateADRDisplay (ref), u19 (copy)
        if typeof(p23) ~= "number" then
            return;
        end;

        updateADRDisplay(u19, p23);
    end));
    updateADRDisplay(u19);

    if v20 and v20.CurrentEquipped then
        local CurrentEquipped = v20.CurrentEquipped;
        u2.Skin.Text = GetSkinDisplayName(CurrentEquipped.Skin);
        u2.Weapon.Text = CurrentEquipped.Name;
    end;

    if not v20 then
        return;
    end;

    u4:Add(v20.CurrentEquippedChanged:Connect(function(p24) -- Line: 118
        -- upvalues: u2 (ref), GetSkinDisplayName (ref)
        if not p24 then
            return;
        end;

        u2.Skin.Text = GetSkinDisplayName(p24.Skin or "");
        u2.Weapon.Text = p24.Name;
    end));
end;

function u1.OpenFrame() -- Line: 129
    -- upvalues: u3 (ref), u2 (ref), LocalPlayer (copy)
    u3.Gameplay.Bottom.Middle.Team.Visible = false;
    u2.Visible = true;

    if not u2 then
        return;
    end;

    local v25 = LocalPlayer:GetAttribute("Team");
    local v26 = v25 == "Counter-Terrorists" and true or v25 == "Terrorists";
    local RespawnNext = u2.RespawnNext;

    if v26 then
        local v27 = workspace:GetAttribute("Gamemode");

        if v27 == nil then
            v26 = false;
        else
            v26 = v27 ~= "Deathmatch";
        end;
    end;

    RespawnNext.Visible = v26;
end;

function u1.CloseFrame() -- Line: 137
    -- upvalues: u2 (ref), u4 (copy), LocalPlayer (copy), Workspace (copy), ReplicatedStorage (copy)
    u2.Visible = false;
    u4:Cleanup();
    local Character = LocalPlayer.Character;
    local v28 = LocalPlayer:GetAttribute("Team");

    if Character and (Character:IsDescendantOf(Workspace) and (v28 and v28 ~= "Spectators")) then
        require(ReplicatedStorage.Interface.Screens.Gameplay.Bottom.Middle.Team).OpenFrame();
    end;
end;

function u1.Initialize(p29, p30) -- Line: 153
    -- upvalues: u3 (ref), u2 (ref)
    u3 = p29;
    u2 = p30;
end;

function u1.Start() -- Line: 159
    -- upvalues: SpectateController (copy), u1 (copy), LocalPlayer (copy), updateRespawnNextVisibility (copy)
    SpectateController.ListenToSpectate:Connect(function(p31) -- Line: 161
        -- upvalues: u1 (ref)
        if not p31 then
            u1.CloseFrame();

            return;
        end;

        u1.UpdateFrame(p31);
        u1.OpenFrame();
    end);
    LocalPlayer:GetAttributeChangedSignal("Team"):Connect(updateRespawnNextVisibility);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(updateRespawnNextVisibility);
end;

return u1;