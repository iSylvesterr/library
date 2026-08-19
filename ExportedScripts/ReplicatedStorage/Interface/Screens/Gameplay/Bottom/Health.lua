-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
local LocalPlayer = Players.LocalPlayer;
local DataController = require(ReplicatedStorage.Controllers.DataController);
local SpectateController = require(ReplicatedStorage.Controllers.SpectateController);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local GetPreferenceColor = require(ReplicatedStorage.Components.Common.GetPreferenceColor);
local u2 = require(ReplicatedStorage.Shared.Janitor).new();
local u3 = nil;
local u4 = nil;
local u5 = nil;

function u1.animateFrame() -- Line: 46
    -- upvalues: u5 (ref), TweenService (copy), Debris (copy)
    local v6 = u5.Amount:Clone();
    v6.TextColor3 = Color3.fromRGB(255, 0, 4);
    v6.ZIndex = u5.ZIndex - 1;
    v6.Parent = u5;
    TweenService:Create(u5.Amount.UIScale, TweenInfo.new(0.07), {
        Scale = 1.1
    }):Play();
    task.wait(0.07);
    TweenService:Create(u5.Amount.UIScale, TweenInfo.new(0.07, Enum.EasingStyle.Elastic), {
        Scale = 1
    }):Play();
    TweenService:Create(v6, TweenInfo.new(0.5), {
        Position = v6.Position + UDim2.fromScale(0, 0.25)
    }):Play();
    TweenService:Create(v6, TweenInfo.new(0.5), {
        TextTransparency = 1
    }):Play();
    Debris:AddItem(v6, 0.5);
end;

function u1.updateFrame(p7, p8) -- Line: 64
    -- upvalues: u5 (ref), GetPreferenceColor (copy), TweenService (copy), u3 (ref), u1 (copy)
    local v9 = p7 / p8;
    local Amount = u5.Amount;
    local v10 = math.ceil(p7);
    Amount.Text = tostring(v10);
    u5.Frame.Bar.BackgroundColor3 = GetPreferenceColor();
    u5.Amount.TextColor3 = GetPreferenceColor();
    u5.Glow.ImageTransparency = 1;
    TweenService:Create(u5.Frame.Bar, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.fromScale(p7 / p8, 1)
    }):Play();

    if v9 <= 0.5 then
        u5.Glow.ImageTransparency = math.max((0.5 - v9) * 2, 0.3);
    end;

    if p7 < u3 then
        task.spawn(u1.animateFrame);
    end;

    u3 = p7;
end;

local function verifyAndRepairHealth(p11) -- Line: 91
    -- upvalues: u5 (ref), u1 (copy)
    if not (p11 and u5) then
        return;
    end;

    local v12 = math.max(p11.Health, 0);
    local MaxHealth = p11.MaxHealth;
    local v13 = tonumber(u5.Amount.Text) or 0;
    local v14 = math.round(u5.Frame.Bar.Size.X.Scale * MaxHealth);

    if math.abs(v12 - v13) > 1 or math.abs(v12 - v14) > 1 then
        u1.updateFrame(v12, MaxHealth);
    end;
end;

function u1.characterAdded(p15, p16) -- Line: 117
    -- upvalues: u2 (copy), u4 (ref), u3 (ref), u1 (copy), LocalPlayer (copy), verifyAndRepairHealth (copy)
    u2:Cleanup();
    u4 = nil;
    local u17 = p15:FindFirstChildOfClass("Humanoid");

    if not u17 then
        local v18 = tick();

        repeat
            task.wait(0.1);
            u17 = p15:FindFirstChildOfClass("Humanoid");
        until u17 or tick() - v18 > 5;
    end;

    if not u17 then
        return;
    end;

    u3 = u17.MaxHealth;
    u4 = u17;
    u1.updateFrame(math.max(u17.Health, 0), u17.MaxHealth);

    if p16 == LocalPlayer then
        task.wait(0.1);
        verifyAndRepairHealth(u17);
        task.delay(3, function() -- Line: 145
            -- upvalues: u17 (ref), verifyAndRepairHealth (ref)
            if u17 and (u17.Parent and u17.Parent:IsDescendantOf(workspace)) then
                verifyAndRepairHealth(u17);
            end;
        end);
    end;

    u2:Add(u17:GetPropertyChangedSignal("Health"):Connect(function() -- Line: 153
        -- upvalues: u1 (ref), u17 (ref)
        u1.updateFrame(math.max(u17.Health, 0), u17.MaxHealth);
    end));
end;

function u1.Initialize(p19, p20) -- Line: 161
    -- upvalues: u5 (ref), LocalPlayer (copy), u2 (copy), u4 (ref), DataController (copy), u1 (copy)
    u5 = p20;

    if u5.Active then
        u5.Active = false;
    end;

    for _, descendant in ipairs(u5:GetDescendants()) do
        if descendant:IsA("GuiObject") then
            descendant.Active = false;
        end;
    end;

    LocalPlayer.CharacterRemoving:Connect(function() -- Line: 177
        -- upvalues: u2 (ref), u4 (ref)
        u2:Cleanup();
        u4 = nil;
    end);
    DataController.CreateListener(LocalPlayer, "Settings.Game.HUD.Color", function() -- Line: 183
        -- upvalues: u4 (ref), u1 (ref)
        if u4 then
            u1.updateFrame(math.max(u4.Health, 0), u4.MaxHealth);
        end;
    end);
end;

function u1.Start() -- Line: 190
    -- upvalues: u2 (copy), u4 (ref), u1 (copy), LocalPlayer (copy), SpectateController (copy), GameState (copy)
    local u21 = nil;

    local function TrackPlayer(u22) -- Line: 194
        -- upvalues: u21 (ref), u2 (ref), u4 (ref), u1 (ref), LocalPlayer (ref)
        u21 = u22;
        u2:Cleanup();
        u4 = nil;
        local Character = u22.Character;

        if Character and Character:IsDescendantOf(workspace) then
            u1.characterAdded(Character, u22);

            return;
        end;

        if u22 ~= LocalPlayer then
            local u23 = nil;
            u23 = u22.CharacterAdded:Connect(function(p24) -- Line: 206
                -- upvalues: u21 (ref), u22 (copy), u1 (ref), u23 (ref)
                if u21 == u22 and p24:IsDescendantOf(workspace) then
                    u1.characterAdded(p24, u22);
                    u23:Disconnect();
                end;
            end);
            u2:Add(u23);
        end;
    end;

    LocalPlayer.CharacterAdded:Connect(function() -- Line: 219
        -- upvalues: TrackPlayer (copy), LocalPlayer (ref)
        TrackPlayer(LocalPlayer);
    end);
    SpectateController.ListenToSpectate:Connect(function(p25) -- Line: 225
        -- upvalues: TrackPlayer (copy), LocalPlayer (ref)
        if p25 then
            TrackPlayer(p25);

            return;
        end;

        if LocalPlayer:GetAttribute("IsSpectating") then
            return;
        end;

        local Character = LocalPlayer.Character;

        if not (Character and Character:IsDescendantOf(workspace)) then
            return;
        end;

        local v26 = Character:FindFirstChildWhichIsA("Humanoid", true);

        if not v26 or v26.Health <= 0 then
            return;
        end;

        TrackPlayer(LocalPlayer);
    end);
    LocalPlayer:GetAttributeChangedSignal("IsSpectating"):Connect(function() -- Line: 248
        -- upvalues: LocalPlayer (ref), TrackPlayer (copy), SpectateController (ref)
        if not LocalPlayer:GetAttribute("IsSpectating") then
            TrackPlayer(LocalPlayer);

            return;
        end;

        local v27 = SpectateController.GetPlayer();

        if not v27 then
            return;
        end;

        TrackPlayer(v27);
    end);

    if LocalPlayer:GetAttribute("IsSpectating") then
        local v28 = SpectateController.GetPlayer();

        if v28 then
            TrackPlayer(v28);
        end;
    else
        TrackPlayer(LocalPlayer);
    end;

    GameState.ListenToState(function(p29, p30) -- Line: 272
        -- upvalues: TrackPlayer (copy), LocalPlayer (ref)
        if p30 ~= "Buy Period" and p30 ~= "Round In Progress" then
            return;
        end;

        TrackPlayer(LocalPlayer);
    end);
end;

return u1;