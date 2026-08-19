-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local InventoryController = require(ReplicatedStorage.Controllers.InventoryController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local GetWeaponProperties = require(ReplicatedStorage.Components.Common.GetWeaponProperties);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local Observers = require(ReplicatedStorage.Packages.Observers);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local HttpService = game:GetService("HttpService");
local u6 = Janitor.new();

local function shouldShowAmmoFrame(p7) -- Line: 50
    local v8;

    if p7 == nil or p7.Class ~= "Weapon" then
        v8 = false;
    else
        v8 = p7.MuzzleType ~= "Zeus x27";
    end;

    return v8;
end;

function u1.tweenAnimation(p9) -- Line: 56
    -- upvalues: u2 (ref), u4 (ref), u3 (ref)
    if u2 ~= p9.Identifier then
        u2 = p9.Identifier;
        u4.Size = UDim2.new(u4.Size.X.Scale, -25, u4.Size.Y.Scale, -25);

        if u3 then
            u3:Play();
        end;
    end;
end;

function u1.updateFrame(p10) -- Line: 72
    -- upvalues: u4 (ref), u1 (copy), GetPreferenceColor (copy), u3 (ref), u5 (ref)
    local Properties = p10.Properties;
    local v11;

    if Properties == nil or Properties.Class ~= "Weapon" then
        v11 = false;
    else
        v11 = Properties.MuzzleType ~= "Zeus x27";
    end;

    u4.Visible = v11;

    if u4.Visible then
        u1.tweenAnimation(p10);
        local Rounds = p10.Rounds;
        u4.Capacity.Amount.Text = tostring(p10.Capacity);
        u4.Rounds.Amount.Text = tostring(Rounds);
        local v12 = GetPreferenceColor();
        u4.Capacity.Amount.TextColor3 = v12;
        u4.Rounds.Amount.TextColor3 = v12;
        u4.Divider.BackgroundColor3 = v12;
        u4.SemiAuto.ImageColor3 = v12;
        u4.Auto.ImageColor3 = v12;
        local v13 = Rounds / Properties.Rounds;
        u4.Rounds.Glow.ImageTransparency = 1;

        if v13 <= 0.2 then
            u4.Rounds.Glow.ImageTransparency = math.max(v13, 0.3);
        end;

        if Properties.ShootingOptions == "Default" then
            u4.SemiAuto.Visible = not Properties.Automatic;
            u4.Auto.Visible = Properties.Automatic;
        elseif Properties.ShootingOptions == "Burst" then
            u4.SemiAuto.Visible = p10.AlternativeShootingOption == "Default";
            u4.Auto.Visible = p10.AlternativeShootingOption == "Burst";
        elseif Properties.ShootingOptions == "Revolver" then
            u4.SemiAuto.Visible = false;
            u4.Auto.Visible = false;
        end;
    elseif u3 then
        u3:Cancel();
    end;

    u4.Visible = u4.Visible and not u5.Gameplay.Middle.BuyMenu.Visible;
end;

local function verifyAndRepairAmmo() -- Line: 125
    -- upvalues: InventoryController (copy), u4 (ref), u1 (copy)
    local v14 = InventoryController.getCurrentEquipped();

    if not v14 then
        return;
    end;

    local Rounds = v14.Rounds;
    local Capacity = v14.Capacity;
    local v15 = tonumber(u4.Rounds.Amount.Text) or 0;
    local v16 = tonumber(u4.Capacity.Amount.Text) or 0;

    if Rounds ~= v15 or Capacity ~= v16 then
        u1.updateFrame(v14);
    end;
end;

function u1.characterAdded(p17, p18) -- Line: 146
    -- upvalues: u6 (copy), LocalPlayer (copy), RunServiceController (copy), InventoryController (copy), u1 (copy), verifyAndRepairAmmo (copy), Observers (copy), HttpService (copy), GetWeaponProperties (copy), u4 (ref)
    u6:Cleanup();

    if p18 == LocalPlayer then
        u6:Add(RunServiceController.BindToStepped("UI.Ammo.LocalPlayerUpdate", function(p19, p20) -- Line: 151
            -- upvalues: InventoryController (ref), u1 (ref)
            local v21 = InventoryController.getCurrentEquipped();

            if v21 then
                u1.updateFrame(v21);
            end;
        end));
        task.wait(0.1);
        verifyAndRepairAmmo();
        task.delay(3, function() -- Line: 163
            -- upvalues: LocalPlayer (ref), verifyAndRepairAmmo (ref)
            if LocalPlayer.Character and LocalPlayer.Character:IsDescendantOf(workspace) then
                verifyAndRepairAmmo();
            end;
        end);

        return;
    end;

    u6:Add(Observers.observeAttribute(p18, "CurrentEquipped", function(p22) -- Line: 170
        -- upvalues: HttpService (ref), GetWeaponProperties (ref), u1 (ref), u4 (ref)
        if not p22 then
            u4.Visible = false;

            return;
        end;

        local v23 = HttpService:JSONDecode(p22);

        if not (v23 and v23.Name) then
            u4.Visible = false;

            return;
        end;

        local v24 = {
            AlternativeShootingOption = "Default",
            Properties = GetWeaponProperties(v23.Name),
            Identifier = v23.Identifier or "",
            Rounds = v23.Rounds or 0,
            Capacity = v23.Capacity or 0
        };
        local Properties = v24.Properties;
        local v25;

        if Properties == nil or Properties.Class ~= "Weapon" then
            v25 = false;
        else
            v25 = Properties.MuzzleType ~= "Zeus x27";
        end;

        if v25 then
            u1.updateFrame(v24);

            return;
        end;

        u4.Visible = false;
    end));
    local v26 = p18:GetAttribute("CurrentEquipped");

    if not v26 then
        u4.Visible = false;

        return;
    end;

    local v27 = HttpService:JSONDecode(v26);

    if not (v27 and v27.Name) then
        u4.Visible = false;

        return;
    end;

    local v28 = {
        AlternativeShootingOption = "Default",
        Properties = GetWeaponProperties(v27.Name),
        Identifier = v27.Identifier or "",
        Rounds = v27.Rounds or 0,
        Capacity = v27.Capacity or 0
    };
    local Properties = v28.Properties;
    local v29;

    if Properties == nil or Properties.Class ~= "Weapon" then
        v29 = false;
    else
        v29 = Properties.MuzzleType ~= "Zeus x27";
    end;

    if v29 then
        u1.updateFrame(v28);

        return;
    end;

    u4.Visible = false;
end;

function u1.Initialize(p30, p31) -- Line: 222
    -- upvalues: u5 (ref), u4 (ref), u3 (ref), TweenService (copy), LocalPlayer (copy), u6 (copy), Observers (copy), DataController (copy), InventoryController (copy), u1 (copy)
    u5 = p30;
    u4 = p31;

    if u4.Active then
        u4.Active = false;
    end;

    for _, descendant in ipairs(u4:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.Active = false;
        end;
    end;

    u3 = TweenService:Create(u4, TweenInfo.new(0.25), {
        Size = UDim2.fromScale(u4.Size.X.Scale, u4.Size.Y.Scale)
    });
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 242
        -- upvalues: u6 (ref)
        u6:Cleanup();
    end);
    Observers.observeProperty(u4.Rounds.Amount, "Text", function(p32) -- Line: 247
        -- upvalues: TweenService (ref), u4 (ref)
        local v33 = TweenService:Create(u4.Rounds.Amount.UIScale, TweenInfo.new(0.05), {
            Scale = 1.2
        });
        v33:Play();
        v33.Completed:Once(function() -- Line: 251
            -- upvalues: TweenService (ref), u4 (ref)
            TweenService:Create(u4.Rounds.Amount.UIScale, TweenInfo.new(0.05, Enum.EasingStyle.Elastic), {
                Scale = 1
            }):Play();
        end);
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 259
        -- upvalues: InventoryController (ref), u1 (ref)
        local v34 = InventoryController.getCurrentEquipped();

        if v34 then
            u1.updateFrame(v34);
        end;
    end);
end;

function u1.Start() -- Line: 267
    -- upvalues: u6 (copy), u1 (copy), LocalPlayer (copy), SpectateController (copy), GameState (copy)
    local u35 = nil;

    local function TrackPlayer(u36) -- Line: 270
        -- upvalues: u6 (ref), u35 (ref), u1 (ref), LocalPlayer (ref)
        u6:Cleanup();
        u35 = u36;
        local Character = u36.Character;

        if Character and Character:IsDescendantOf(workspace) then
            u1.characterAdded(Character, u36);

            return;
        end;

        if u36 ~= LocalPlayer then
            local u37 = nil;
            u37 = u36.CharacterAdded:Connect(function(p38) -- Line: 282
                -- upvalues: u35 (ref), u36 (copy), u1 (ref), u37 (ref)
                if u35 == u36 and p38:IsDescendantOf(workspace) then
                    u1.characterAdded(p38, u36);
                    u37:Disconnect();
                end;
            end);
            u6:Add(u37);
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(function() -- Line: 293
        -- upvalues: TrackPlayer (copy), LocalPlayer (ref)
        TrackPlayer(LocalPlayer);
    end);
    SpectateController.ListenToSpectate:Connect(function(p39) -- Line: 298
        -- upvalues: TrackPlayer (copy), LocalPlayer (ref)
        if p39 then
            TrackPlayer(p39);

            return;
        end;

        if not LocalPlayer:GetAttribute("IsSpectating") then
            TrackPlayer(LocalPlayer);
        end;
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 309
        -- upvalues: LocalPlayer (ref), TrackPlayer (copy), SpectateController (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            TrackPlayer(LocalPlayer);

            return;
        end;

        local v40 = SpectateController.GetPlayer();

        if v40 then
            TrackPlayer(v40);
        end;
    end);

    if LocalPlayer:GetAttribute("IsSpectating") then
        local v41 = SpectateController.GetPlayer();

        if v41 then
            TrackPlayer(v41);
        end;
    else
        TrackPlayer(LocalPlayer);
    end;

    GameState.ListenToState(function(p42, p43) -- Line: 332
        -- upvalues: TrackPlayer (copy), LocalPlayer (ref)
        if p43 == "Buy Period" or p43 == "Round In Progress" then
            TrackPlayer(LocalPlayer);
        end;
    end);
end;

return u1;