-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local HapticsController = require(ReplicatedStorage.Controllers.HapticsController);
local CameraController = require(ReplicatedStorage.Controllers.CameraController);
local RunServiceController = require(ReplicatedStorage.Controllers.RunServiceController);
local Sound = require(ReplicatedStorage.Classes.Sound);
local Router = require(ReplicatedStorage.Database.Security.Router);
local Janitor = require(ReplicatedStorage.Shared.Janitor);
local CurrentCamera = workspace.CurrentCamera;

local function computeInterval(p2, p3, p4) -- Line: 39
    local v5 = p2 / p3 * 0.9 + 0.1;

    if v5 <= p4 then
        v5 = p4;
    end;

    return v5;
end;

function u1.updateHeartbeat(p6, p7) -- Line: 50
    -- upvalues: CurrentCamera (copy)
    if p6.Model:GetAttribute("IsGettingDefused") then
        p6.Model:SetAttribute("CanDefuse", false);

        return;
    end;

    if not (p7.PrimaryPart and p6.Model.PrimaryPart) then
        return;
    end;

    if (p7.PrimaryPart.Position - p6.Model.PrimaryPart.Position).Magnitude > 5 then
        p6.Model:SetAttribute("CanDefuse", false);

        return;
    end;

    local v8 = p6.Model.PrimaryPart.Position - CurrentCamera.CFrame.Position;
    local Magnitude = v8.Magnitude;

    if Magnitude <= 0 then
        p6.Model:SetAttribute("CanDefuse", false);

        return;
    end;

    if CurrentCamera.CFrame.LookVector:Dot(v8 / Magnitude) >= 0.966 then
        p6.Model:SetAttribute("CanDefuse", true);

        return;
    end;

    p6.Model:SetAttribute("CanDefuse", false);
end;

function u1.new(p9) -- Line: 104
    -- upvalues: u1 (copy), Janitor (copy), Sound (copy), HttpService (copy), RunServiceController (copy), Router (copy), ReplicatedStorage (copy), LocalPlayer (copy), CameraController (copy), HapticsController (copy)
    local u10 = setmetatable({}, u1);
    u10.Janitor = Janitor.new();
    u10.Sound = Sound.new("C4");
    u10.Janitor:Add(function() -- Line: 113
        -- upvalues: u10 (copy)
        u10.Sound:destroy();
    end);
    u10.Model = p9;
    u10.Data = HttpService:JSONDecode(p9:GetAttribute("BombPlanted"));
    local v11 = typeof(u10.Data.Time) == "number" and u10.Data.Time or workspace:GetServerTimeNow();
    local v12 = typeof(u10.Data.TimeUntilExplode) == "number" and (u10.Data.TimeUntilExplode or 40) or 40;
    u10.TimeUntilExplode = math.max(v12, 0.1);
    u10.ExplodeAt = v11 + u10.TimeUntilExplode;
    u10.MinimumInterval = 0.15;
    u10.NextBeepAt = workspace:GetServerTimeNow();
    local v13 = workspace:GetServerTimeNow() - v11;
    u10.Elapsed = math.max(v13, 0);
    u10.IsDefused = false;
    local v14 = RunServiceController.CreateBindingName("Observers.Game.BombPlanted");
    Router.broadcastRouter("CreateNotification", "Bomb", "The bomb has been planted.", 2.5);

    for _, descendant in ipairs(u10.Model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            descendant.CanQuery = true;
        end;
    end;

    u10.Janitor:Add(u10.Model:GetAttributeChangedSignal("Defused"):Connect(function() -- Line: 147
        -- upvalues: Router (ref), u10 (copy)
        Router.broadcastRouter("Cancel Defuse Bomb");
        Router.broadcastRouter("CreateNotification", "Bomb", "The bomb has been defused.", 2.5);
        u10.IsDefused = true;
    end));
    u10.Janitor:Add(u10.Model:GetAttributeChangedSignal("Exploding"):Connect(function() -- Line: 155
        -- upvalues: Router (ref), ReplicatedStorage (ref)
        Router.broadcastRouter("Cancel Defuse Bomb");
        local DefuseBomb = require(ReplicatedStorage.Interface.Screens.Gameplay.Middle.DefuseBomb);

        if DefuseBomb and DefuseBomb.SetDefuseBlockedUntil then
            local v15 = workspace:GetServerTimeNow();
            DefuseBomb.SetDefuseBlockedUntil(v15 + 5);
        end;
    end));
    u10.Janitor:Add(u10.Model:GetAttributeChangedSignal("Exploded"):Connect(function() -- Line: 168
        -- upvalues: LocalPlayer (ref), CameraController (ref), u10 (copy), HapticsController (ref)
        local Character = LocalPlayer.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid");

            if Humanoid and Humanoid.Health > 0 then
                CameraController.BombExploded((u10.Model.PrimaryPart.Position - Character.PrimaryPart.Position).Magnitude);
                HapticsController.vibrate(Enum.VibrationMotor.Large, 1.5, 0.25);
            end;
        end;
    end));
    u10.Janitor:Add(RunServiceController.BindToHeartbeat(`{v14}.DefuseCheck`, function(p16) -- Line: 180
        -- upvalues: LocalPlayer (ref), u10 (copy)
        local Character = LocalPlayer.Character;

        if Character and Character:IsDescendantOf(workspace) then
            local Humanoid = Character:FindFirstChild("Humanoid");

            if Humanoid and (Humanoid.Health > 0 and LocalPlayer:GetAttribute("Team") == "Counter-Terrorists") then
                u10:updateHeartbeat(Character);
            end;
        end;
    end));
    u10.Janitor:Add(RunServiceController.BindToHeartbeat(`{v14}.Beep`, function(p17) -- Line: 194
        -- upvalues: u10 (copy)
        local v18 = workspace:GetServerTimeNow();
        local v19 = math.max(u10.ExplodeAt - v18, 0);
        u10.Elapsed = math.max(u10.TimeUntilExplode - v19, 0);
        local v20 = u10.Model:FindFirstChild("Weapon") and u10.Model.Weapon:FindFirstChild("FlashingLight");

        if u10.IsDefused or v19 <= 0 then
            if v20 and (v20:FindFirstChild("Attachment") and v20.Attachment:FindFirstChild("PointLight")) then
                v20.Attachment.PointLight.Enabled = not v20.Attachment.PointLight.Enabled;
            end;

            return;
        end;

        if u10.NextBeepAt <= v18 then
            local MinimumInterval = u10.MinimumInterval;
            local v21 = v19 / u10.TimeUntilExplode * 0.9 + 0.1;

            if v21 > MinimumInterval then
                MinimumInterval = v21;
            end;

            u10.NextBeepAt = v18 + MinimumInterval;

            if v20 and (v20:FindFirstChild("Attachment") and v20.Attachment:FindFirstChild("PointLight")) then
                v20.Attachment.PointLight.Enabled = not v20.Attachment.PointLight.Enabled;
            end;

            local v22 = u10.Model and u10.Model.PrimaryPart;

            if not v22 then
                return;
            end;

            u10.Sound:play({
                Name = "Beep",
                Parent = v22
            });
        end;
    end));

    return u10;
end;

function u1.destroy(p23) -- Line: 239
    p23.Janitor:Destroy();
end;

return u1;