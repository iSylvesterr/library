-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local GetSkinDisplayName = require(ReplicatedStorage.Components.Common.GetSkinDisplayName);
local GetBadgeIcon = require(ReplicatedStorage.Components.Common.GetBadgeIcon);
local GetBadgeName = require(ReplicatedStorage.Components.Common.GetBadgeName);
local Skins = require(ReplicatedStorage.Database.Components.Libraries.Skins);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Debris = workspace:WaitForChild("Debris");
local CurrentCamera = workspace.CurrentCamera;
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = nil;
local u4 = nil;

local function GetWeaponIcon(p5, p6) -- Line: 43
    -- upvalues: Skins (copy)
    return Skins.GetWearImageForFloat(p5, p6) or p5.imageAssetId or "";
end;

local function GetCharacterHumanoid() -- Line: 49
    -- upvalues: Debris (copy), LocalPlayer (copy)
    for _, child in Debris:GetChildren() do
        if child:HasTag("Ragdoll") and child.Name == LocalPlayer.Name then
            local v7 = child:FindFirstChildOfClass("Humanoid");

            if v7 then
                return v7;
            end;
        end;
    end;

    return nil;
end;

function u1.updateFrame(p8) -- Line: 64
    -- upvalues: Players (copy), Skins (copy), GetSkinDisplayName (copy), u4 (ref), GetBadgeName (copy), GetBadgeIcon (copy)
    local v9 = Players:GetPlayerByUserId((tonumber(p8.Killer)));

    if not (v9 and v9:IsDescendantOf(Players)) then
        return;
    end;

    local v10 = Skins.GetSkinInformation(p8.Weapon, p8.Skin);
    local v11 = GetSkinDisplayName(p8.Skin);
    u4.Killed.Text = `<font color="rgb(255,34,16)">Killed you with their</font> <b>{p8.Weapon} | {v11}</b>`;
    u4.BadgeFrame.TextLabel.Text = GetBadgeName(v9, (v9:GetAttribute("Team")));
    u4.BadgeIcon.Image = GetBadgeIcon(v9, (v9:GetAttribute("Team")));
    u4.Profile.Avatar.Image = `rbxthumb://type=AvatarHeadShot&id={v9.UserId}&w=150&h=150`;
    u4.Username.Text = v9.DisplayName;

    if v10 then
        u4.ViewportFrame.Icon.Image = Skins.GetWearImageForFloat(v10, p8.Float or 0.9999) or (v10.imageAssetId or "");

        return;
    end;

    u4.ViewportFrame.Icon.Image = "";
end;

function u1.openFrame() -- Line: 90
    -- upvalues: GetCharacterHumanoid (copy), CurrentCamera (copy), CameraController (copy), u2 (ref), u4 (ref), u3 (ref), TweenService (copy), u1 (copy)
    CurrentCamera.CameraSubject = GetCharacterHumanoid();
    CurrentCamera.CameraType = Enum.CameraType.Follow;
    CameraController.setPerspective(false, false);
    task.wait(0.15);
    u2.ImageLabel.ImageTransparency = 1;
    u2.BackgroundTransparency = 1;
    u2.Visible = true;
    u4.Position = UDim2.fromScale(0.5, -u4.Size.Y.Scale);
    u4.Visible = true;
    u3.BackgroundTransparency = 1;
    u3.Visible = true;
    TweenService:Create(u2, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.75
    }):Play();
    TweenService:Create(u2.ImageLabel, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0
    }):Play();
    task.wait(0.25);
    TweenService:Create(u4, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.fromScale(0.5, 0.7)
    }):Play();
    task.wait(0.35);
    TweenService:Create(u3, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play();
    TweenService:Create(u2, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    }):Play();
    TweenService:Create(u2.ImageLabel, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 1
    }):Play();

    if workspace:GetAttribute("Gamemode") ~= "Deathmatch" then
        task.delay(2, function() -- Line: 135
            -- upvalues: u1 (ref)
            u1.closeFrame();
        end);
    end;
end;

function u1.closeFrame() -- Line: 141
    -- upvalues: u2 (ref), u4 (ref), TweenService (copy), u3 (ref)
    u2.ImageLabel.ImageTransparency = 1;
    u2.BackgroundTransparency = 1;
    u2.Visible = false;
    u4.Position = UDim2.fromScale(0.5, -u4.Size.Y.Scale);
    u4.Visible = false;
    local v12 = TweenService:Create(u3, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 1
    });
    v12:Play();
    v12.Completed:Connect(function() -- Line: 152
        -- upvalues: u3 (ref)
        u3.BackgroundTransparency = 1;
        u3.Visible = false;
    end);
end;

function u1.Initialize(p13, p14) -- Line: 161
    -- upvalues: u2 (ref), u3 (ref), u4 (ref), LocalPlayer (copy), u1 (copy)
    u2 = p13.Gameplay.Middle.BloodScreen;
    u3 = p13.Gameplay.Middle.Transition;
    u4 = p14;
    LocalPlayer.CharacterAdded:Connect(function() -- Line: 166
        -- upvalues: u4 (ref), u1 (ref)
        if u4.Visible then
            u1.closeFrame();
        end;
    end);
end;

function u1.Start() -- Line: 173
    -- upvalues: Remotes (copy), LocalPlayer (copy), u1 (copy)
    Remotes.UI.UIPlayerKilled.Listen(function(p15) -- Line: 175
        -- upvalues: LocalPlayer (ref), u1 (ref)
        if LocalPlayer.UserId ~= tonumber(p15.Victim) then
            return;
        end;

        u1.updateFrame(p15);
        u1.openFrame();
    end);
    Remotes.UI.ShowDeathCard.Listen(function(p16) -- Line: 183
        -- upvalues: LocalPlayer (ref), u1 (ref)
        if LocalPlayer.UserId ~= tonumber(p16.Victim) then
            return;
        end;

        u1.updateFrame(p16);
    end);
end;

return u1;