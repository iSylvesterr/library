-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
require(script:WaitForChild("Types"));
local LocalPlayer = Players.LocalPlayer;
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local u2 = nil;
local u3 = nil;

local function applyPreferenceColorToCard(p4, p5) -- Line: 30
    p4.Amount.TextColor3 = p5;
    p4.ImageColor3 = p5;

    for _, v in p4:QueryDescendants("UIStroke, ImageLabel") do
        if v:IsA("UIStroke") then
            v.Color = p5;
        else
            v.ImageColor3 = p5;
        end;
    end;
end;

function u1.createAnimationFrame(p6) -- Line: 47
    -- upvalues: LocalPlayer (copy), u2 (ref), ReplicatedStorage (copy), applyPreferenceColorToCard (copy), GetPreferenceColor (copy), TweenService (copy)
    local v7 = LocalPlayer:GetAttribute("Team");

    if not v7 or v7 == "Spectators" then
        return;
    end;

    local v8 = #u2.Cards:GetChildren() + 1;

    if v8 > 5 then
        return;
    end;

    local v9 = v7 == "Counter-Terrorists" and ReplicatedStorage.Assets.UI.Team.CTCard;

    if not v9 then
        if v7 == "Terrorists" then
            v9 = ReplicatedStorage.Assets.UI.Team.TCard;
        else
            v9 = false;
        end;
    end;

    local u10 = v9:Clone();
    u10.Amount.Text = tostring(v8);
    u10.Position = UDim2.fromScale(0.5, 1);
    u10.Name = tostring(v8);
    u10.Animation.ImageTransparency = 1;
    u10.Animation.Visible = false;
    u10.Parent = u2.Cards;
    u10.Rotation = -10;
    u10.Visible = true;
    applyPreferenceColorToCard(u10, GetPreferenceColor());

    for _, child in u2.Cards:GetChildren() do
        local v11 = tonumber(child.Name) - math.floor((v8 + 1) / 2);
        local v12 = v8 == 1 and 0 or (v11 * 0.2617993877991494 or 0);
        local v13 = v8 >= 3 and (child.Name == "1" and 0.75 or (child.Name == "2" and 0.75 or 0.85)) or 0.85;
        local v14 = v8 >= 3 and (child.Name == "1" and 0.25 or (child.Name == "2" and 0.125 or 0.05)) or 0.05;
        TweenService:Create(child, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(math.sin(v12) * v13 + 0.5, math.cos(v12) * v14 + 0.45),
            Rotation = math.deg(v12)
        }):Play();
    end;

    TweenService:Create(u10.Animation, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageTransparency = 0.2
    }):Play();
    TweenService:Create(u2.Team.Team, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        ImageColor3 = Color3.fromRGB(135, 155, 177)
    }):Play();
    task.delay(0.5, function() -- Line: 111
        -- upvalues: u10 (copy), TweenService (ref), u2 (ref)
        if not (u10 and u10:FindFirstChild("Animation")) then
            return;
        end;

        TweenService:Create(u10.Animation, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageTransparency = 1
        }):Play();
        TweenService:Create(u2.Team.Team, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            ImageColor3 = Color3.fromRGB(36, 41, 47)
        }):Play();
    end);
end;

function u1.OpenFrame() -- Line: 133
    -- upvalues: GetPreferenceColor (copy), u3 (ref), u2 (ref), LocalPlayer (copy)
    local v15 = GetPreferenceColor();
    u3.Gameplay.Bottom.Middle.Spectate.Visible = false;
    u2.Team.Outline.ImageColor3 = v15;
    u2.Line1.ImageColor3 = v15;
    u2.Line2.ImageColor3 = v15;
    u2.Cards.Visible = true;
    u2.Visible = true;
    local v16 = LocalPlayer:GetAttribute("Team");
    u2.Team.Team.CT.Visible = v16 == "Counter-Terrorists";
    u2.Team.Team.T.Visible = v16 == "Terrorists";
    u2.Team.Team.ImageColor3 = v16 == "Terrorists" and Color3.fromRGB(89, 79, 50) or Color3.fromRGB(36, 41, 47);
end;

function u1.CloseFrame() -- Line: 151
    -- upvalues: u2 (ref)
    u2.Cards:ClearAllChildren();
    u2.Cards.Visible = false;
    u2.Visible = false;
end;

function u1.Initialize(p17, p18) -- Line: 160
    -- upvalues: u3 (ref), u2 (ref), DataController (copy), LocalPlayer (copy), GetPreferenceColor (copy), applyPreferenceColorToCard (copy)
    u3 = p17;
    u2 = p18;
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 164
        -- upvalues: u2 (ref), GetPreferenceColor (ref), applyPreferenceColorToCard (ref)
        if u2.Visible then
            local v19 = GetPreferenceColor();
            u2.Team.Outline.ImageColor3 = v19;
            u2.Line1.ImageColor3 = v19;
            u2.Line2.ImageColor3 = v19;

            for _, child in u2.Cards:GetChildren() do
                if child:IsA("ImageLabel") and (child:FindFirstChild("Amount") and (child:FindFirstChild("Skull1") and (child:FindFirstChild("Skull2") and child:FindFirstChild("Animation")))) then
                    applyPreferenceColorToCard(child, v19);
                end;
            end;
        end;
    end);
end;

function u1.Start() -- Line: 188
    -- upvalues: LocalPlayer (copy), u1 (copy), Remotes (copy), u2 (ref)
    LocalPlayer.CharacterAdded:Connect(function(p20) -- Line: 190
        -- upvalues: u1 (ref)
        u1.OpenFrame();
    end);
    LocalPlayer.CharacterRemoving:Connect(function(p21) -- Line: 195
        -- upvalues: u1 (ref)
        u1.CloseFrame();
    end);
    Remotes.UI.UIPlayerKilled.Listen(function(p22) -- Line: 200
        -- upvalues: u2 (ref), LocalPlayer (ref), u1 (ref)
        if not u2.Visible or LocalPlayer.UserId ~= tonumber(p22.Killer) then
            return;
        end;

        u1.createAnimationFrame(p22);
    end);
end;

return u1;