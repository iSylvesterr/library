-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local InputController = require(ReplicatedStorage.Controllers.InputController);
local DataController = require(ReplicatedStorage.Controllers.DataController);
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local Router = require(ReplicatedStorage.Database.Security.Router);
local LocalPlayer = Players.LocalPlayer;
local u2 = UDim2.fromScale(0.9, 0.2);
local u3 = UDim2.fromScale(0.9, 0.12);
local u4 = {
    Invulnerable = ReplicatedStorage.Assets.UI.Notification.Invulnerable,
    Default = ReplicatedStorage.Assets.UI.Notification.Default
};
local u5 = nil;

local function cleanupNotificationTemplate(p6) -- Line: 44
    -- upvalues: TweenService (copy), Debris (copy)
    TweenService:Create(p6, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.fromScale(0, 0.12)
    }):Play();
    Debris:AddItem(p6, 0.35);
end;

local function onCleanup(p7, p8) -- Line: 56
    -- upvalues: cleanupNotificationTemplate (copy)
    if p8 > tick() - p7:GetAttribute("Timestamp") then
        return;
    end;

    cleanupNotificationTemplate(p7);
end;

function u1.createNotification(p9, p10, p11, p12) -- Line: 68
    -- upvalues: u5 (ref), LocalPlayer (copy), u2 (copy), u3 (copy), u4 (copy), TweenService (copy), GetPreferenceColor (copy), InputController (copy)
    local v13 = u5:FindFirstChild(p10);

    if LocalPlayer:GetAttribute("Team") then
        if not v13 then
            local v14 = p9 == "Invulnerable" and u2 or u3;
            v13 = u4[p9]:Clone();
            v13.Size = UDim2.fromScale(0, v14.Y.Scale);
            v13.LayoutOrder = -(p12 or 1);
            v13.Parent = u5;
            v13.Name = p10;
            TweenService:Create(v13, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = v14
            }):Play();
        end;

        v13:SetAttribute("Timestamp", tick());
        v13.Right.BackgroundColor3 = GetPreferenceColor();
        v13.Left.BackgroundColor3 = GetPreferenceColor();

        if v13:FindFirstChild("TextLabel") then
            v13.TextLabel.Text = p11;
        end;

        if p9 == "Invulnerable" then
            local v15 = InputController.GetActionKeybind("Buy Menu") or "B";
            v13.Container.Context.Text = `[{v15}] Open the Buy Menu`;
            v13.Container.Header.TextColor3 = GetPreferenceColor();
        end;

        return v13;
    end;
end;

function u1.Initialize(p16, p17) -- Line: 119
    -- upvalues: u5 (ref), LocalPlayer (copy), u1 (copy), cleanupNotificationTemplate (copy), GameState (copy), DataController (copy), GetPreferenceColor (copy)
    u5 = p17;
    LocalPlayer:GetAttributeChangedSignal("BuyMenu"):Connect(function() -- Line: 123
        -- upvalues: LocalPlayer (ref), u1 (ref), cleanupNotificationTemplate (ref)
        local v18 = workspace:GetAttribute("Gamemode");

        if not LocalPlayer:GetAttribute("BuyMenu") and v18 == "Deathmatch" then
            local u19 = u1.createNotification("Default", "Your buy period has expired", "Your buy period has expired", 2);
            task.delay(2, function() -- Line: 129
                -- upvalues: u19 (copy), cleanupNotificationTemplate (ref)
                if not (u19 and u19.Parent) then
                    return;
                end;

                cleanupNotificationTemplate(u19);
            end);
        end;
    end);
    LocalPlayer.CharacterAdded:Connect(function(u20) -- Line: 139
        -- upvalues: u5 (ref), u1 (ref)
        local v21 = workspace:GetAttribute("GameState");

        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            if u20:GetAttribute("Invincible") then
                local GameState2 = u5:FindFirstChild("GameState");
                u1.createNotification("Invulnerable", "Deathmatch Invincibility", "", 0);

                if GameState2 then
                    GameState2:Destroy();
                end;
            end;

            u20:GetAttributeChangedSignal("Invincible"):Connect(function() -- Line: 154
                -- upvalues: u20 (copy), u5 (ref), u1 (ref)
                if u20:GetAttribute("Invincible") then
                    local GameState2 = u5:FindFirstChild("GameState");
                    u1.createNotification("Invulnerable", "Deathmatch Invincibility", "", 0);

                    if GameState2 then
                        GameState2:Destroy();
                    end;
                else
                    local v22 = u5:FindFirstChild("Deathmatch Invincibility");
                    local v23 = workspace:GetAttribute("GameState");

                    if v22 then
                        v22:Destroy();
                    end;

                    if v23 == "Warmup" then
                        u1.createNotification("Default", "GameState", "Warmup", 1);
                    end;
                end;
            end);

            return;
        end;

        local v24 = u5:FindFirstChild("Deathmatch Invincibility");

        if v24 then
            v24:Destroy();
        end;

        if v21 == "Warmup" then
            u1.createNotification("Default", "GameState", "Warmup", 1);

            return;
        end;

        local GameState2 = u5:FindFirstChild("GameState");

        if GameState2 then
            GameState2:Destroy();
        end;
    end);
    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 195
        -- upvalues: u5 (ref)
        local v25 = u5:FindFirstChild("Deathmatch Invincibility");

        if not v25 then
            return;
        end;

        v25:Destroy();
    end);
    GameState.ListenToState(function(p26, p27) -- Line: 205
        -- upvalues: u5 (ref)
        local v28 = p26 == "Warmup" and u5:FindFirstChild("GameState");

        if v28 then
            v28:Destroy();
        end;
    end);
    workspace:GetAttributeChangedSignal("Gamemode"):Connect(function() -- Line: 215
        -- upvalues: u5 (ref)
        local v29 = workspace:GetAttribute("Gamemode") ~= "Deathmatch" and u5:FindFirstChild("Deathmatch Invincibility");

        if not v29 then
            return;
        end;

        v29:Destroy();
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 229
        -- upvalues: u5 (ref), GetPreferenceColor (ref)
        for _, child in ipairs(u5:GetChildren()) do
            if child:IsA("Frame") then
                child.Right.BackgroundColor3 = GetPreferenceColor();
                child.Left.BackgroundColor3 = GetPreferenceColor();
            end;
        end;
    end);
end;

function u1.Start() -- Line: 241
    -- upvalues: Remotes (copy), u1 (copy), cleanupNotificationTemplate (copy), Router (copy)
    Remotes.UI.ShowNotification.Listen(function(u30, p31) -- Line: 243
        -- upvalues: u1 (ref), cleanupNotificationTemplate (ref)
        local u32 = u1.createNotification("Default", u30.header, u30.message, 2);
        task.delay(u30.timeLength, function() -- Line: 245
            -- upvalues: u32 (copy), u30 (copy), cleanupNotificationTemplate (ref)
            if u32 and u32.Parent then
                local v33 = u32;

                if u30.timeLength <= tick() - v33:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v33);
                end;
            end;
        end);
    end);
    Router.observerRouter("CreateNotification", function(p34, p35, u36) -- Line: 253
        -- upvalues: u1 (ref), cleanupNotificationTemplate (ref)
        local u37 = u1.createNotification("Default", p34, p35, 2);
        task.delay(u36, function() -- Line: 255
            -- upvalues: u37 (copy), u36 (copy), cleanupNotificationTemplate (ref)
            if u37 and u37.Parent then
                local v38 = u37;

                if u36 <= tick() - v38:GetAttribute("Timestamp") then
                    cleanupNotificationTemplate(v38);
                end;
            end;
        end);
    end);
end;

return u1;