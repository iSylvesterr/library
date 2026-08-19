-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Players = game:GetService("Players");
local Debris = game:GetService("Debris");
require(script:WaitForChild("Types"));
local Remotes = require(ReplicatedStorage.Database.Security.Remotes);
local GameState = require(ReplicatedStorage.Database.Components.GameState);
local LocalPlayer = Players.LocalPlayer;
local u2 = nil;
local u3 = {};
local u4 = {
    [2] = "got a Multi Kill",
    [3] = "is on a Killing Spree",
    [4] = "is on a Rampage",
    [5] = "is Dominating",
    [6] = "got a M-M-Monster Kill",
    [7] = "is going Ludicrus",
    [8] = "is Unstoppable",
    [9] = "is Godlike"
};

local function convertTextLabel(p5, p6, p7) -- Line: 35
    -- upvalues: Players (copy), LocalPlayer (copy)
    if p7 then
        local v8 = Players:GetPlayerByUserId(p7);

        if not (v8 and v8:IsDescendantOf(Players)) then
            p6.Visible = false;

            return;
        end;

        local v9 = v8:GetAttribute("Team");
        p6.Text = v8.DisplayName;
        p6.Visible = true;

        if LocalPlayer.UserId == p7 then
            p5.UIStroke.Color = Color3.fromRGB(255, 0, 0);
        end;

        if v9 == "Counter-Terrorists" then
            p6.TextColor3 = Color3.fromRGB(165, 183, 212);

            return;
        end;

        if v9 == "Terrorists" then
            p6.TextColor3 = Color3.fromRGB(219, 199, 126);
        end;
    end;
end;

local function createStreakTemplate(p10, p11) -- Line: 61
    -- upvalues: ReplicatedStorage (copy), u2 (ref), Players (copy), LocalPlayer (copy), Debris (copy), TweenService (copy)
    local u12 = ReplicatedStorage.Assets.UI.KillFeed.Kill:Clone();
    u12.Parent = u2;
    local Contents = u12.Contents;
    Contents.Weapon.Visible = false;
    Contents.Headshot.Visible = false;
    Contents.NoScope.Visible = false;
    Contents.Smoke.Visible = false;
    Contents.Wallbang.Visible = false;
    Contents.Blind.Visible = false;
    Contents.Jump.Visible = false;
    Contents.FlashAssist.Visible = false;
    Contents.Addition.Visible = false;
    Contents.Assistor.Visible = false;
    Contents.Enemy.Visible = false;
    local UIPadding = Contents:FindFirstChild("UIPadding");

    if not UIPadding then
        UIPadding = Instance.new("UIPadding");
        UIPadding.Parent = Contents;
    end;

    UIPadding.PaddingLeft = UDim.new(0, 5);
    UIPadding.PaddingRight = UDim.new(0, 5);
    local Player = Contents.Player;
    local v13 = Players:GetPlayerByUserId(p10);

    if not (v13 and v13:IsDescendantOf(Players)) then
        Debris:AddItem(u12, 0);

        return;
    end;

    Player.Text = v13.DisplayName;
    Player.Visible = true;

    if p10 == LocalPlayer.UserId then
        u12.UIStroke.Color = Color3.fromRGB(255, 0, 0);
    end;

    local v14 = v13:GetAttribute("Team");

    if v14 == "Counter-Terrorists" then
        Player.TextColor3 = Color3.fromRGB(165, 183, 212);
    elseif v14 == "Terrorists" then
        Player.TextColor3 = Color3.fromRGB(219, 199, 126);
    end;

    local Enemy = Contents.Enemy;
    Enemy.Text = p11;
    Enemy.TextColor3 = Color3.fromRGB(255, 255, 255);
    Enemy.Visible = true;
    Player.LayoutOrder = 0;
    Enemy.LayoutOrder = 1;
    u12.Visible = true;
    task.delay(5, function() -- Line: 123
        -- upvalues: TweenService (ref), u12 (copy), Debris (ref)
        TweenService:Create(u12, TweenInfo.new(1), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u12.UIStroke, TweenInfo.new(1), {
            Transparency = 1
        }):Play();
        Debris:AddItem(u12, 1);
    end);
end;

function u1.createTemplate(p15) -- Line: 137
    -- upvalues: ReplicatedStorage (copy), u2 (ref), convertTextLabel (copy), TweenService (copy), Debris (copy)
    local v16 = require(ReplicatedStorage.Database.Custom.Weapons[p15.Weapon]);
    u2.Visible = true;
    local u17 = ReplicatedStorage.Assets.UI.KillFeed.Kill:Clone();
    u17.Parent = u2;
    local UIPadding = u17.Contents:FindFirstChild("UIPadding");

    if not UIPadding then
        UIPadding = Instance.new("UIPadding");
        UIPadding.Parent = u17.Contents;
    end;

    UIPadding.PaddingLeft = UDim.new(0, 5);
    UIPadding.PaddingRight = UDim.new(0, 5);
    convertTextLabel(u17, u17.Contents.Player, (tonumber(p15.Killer)));
    convertTextLabel(u17, u17.Contents.Enemy, (tonumber(p15.Victim)));

    if p15.Assistor then
        convertTextLabel(u17, u17.Contents.Assistor, (tonumber(p15.Assistor)));
        u17.Contents.Addition.Visible = true;
        u17.Contents.FlashAssist.Visible = p15.FlashAssist == true;
    else
        u17.Contents.Assistor.Visible = false;
        u17.Contents.Addition.Visible = false;
        u17.Contents.FlashAssist.Visible = false;
    end;

    u17.Contents.Weapon.Image = v16.ReverseIcon;
    u17.Contents.Headshot.Visible = p15.Headshot;
    u17.Contents.NoScope.Visible = p15.NoScope == true;
    u17.Contents.Smoke.Visible = p15.Smoke == true;
    u17.Contents.Blind.Visible = p15.Blind == true;
    u17.Contents.Wallbang.Visible = p15.Wallbang == true;
    u17.Contents.Jump.Visible = p15.Jump == true;

    local function updateIconSizes() -- Line: 178
        -- upvalues: u17 (copy)
        local Player = u17.Contents.Player;

        if Player and Player.AbsoluteSize.Y > 0 then
            local v18 = Player.AbsoluteSize.Y * 0.84 * 1.67;
            u17.Contents.Headshot.Size = UDim2.new(0, v18, 0, v18);
            u17.Contents.NoScope.Size = UDim2.new(0, v18 * 0.8333333333333334, 0, v18 * 0.8333333333333334);
            u17.Contents.Smoke.Size = UDim2.new(0, v18 * 1.1111111111111112, 0, v18 * 0.7777777777777778);
            u17.Contents.Wallbang.Size = UDim2.new(0, v18 * 1.1111111111111112, 0, v18 * 1.1111111111111112);
            u17.Contents.Blind.Size = UDim2.new(0, v18 * 0.8333333333333334, 0, v18 * 0.8333333333333334);
            u17.Contents.Jump.Size = UDim2.new(0, v18, 0, v18);
            u17.Contents.FlashAssist.Size = UDim2.new(0, v18, 0, v18);
        end;
    end;

    updateIconSizes();
    u17.Contents:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateIconSizes);
    local v19 = 0;

    if p15.Blind == true then
        u17.Contents.Blind.LayoutOrder = v19;
        v19 = v19 + 1;
    end;

    u17.Contents.Player.LayoutOrder = v19;
    local v20 = v19 + 1;

    if p15.Assistor then
        u17.Contents.Addition.LayoutOrder = v20;
        local v21 = v20 + 1;

        if p15.FlashAssist == true then
            u17.Contents.FlashAssist.LayoutOrder = v21;
            v21 = v21 + 1;
        end;

        u17.Contents.Assistor.LayoutOrder = v21;
        v20 = v21 + 1;
    end;

    if p15.Jump == true then
        u17.Contents.Jump.LayoutOrder = v20;
        v20 = v20 + 1;
    end;

    u17.Contents.Weapon.LayoutOrder = v20;
    local v22 = v20 + 1;

    if p15.NoScope == true then
        u17.Contents.NoScope.LayoutOrder = v22;
        v22 = v22 + 1;
    end;

    if p15.Smoke == true then
        u17.Contents.Smoke.LayoutOrder = v22;
        v22 = v22 + 1;
    end;

    if p15.Wallbang == true then
        u17.Contents.Wallbang.LayoutOrder = v22;
        v22 = v22 + 1;
    end;

    if p15.Headshot == true then
        u17.Contents.Headshot.LayoutOrder = v22;
        v22 = v22 + 1;
    end;

    u17.Contents.Enemy.LayoutOrder = v22;
    u17.Visible = true;
    task.delay(5, function() -- Line: 265
        -- upvalues: TweenService (ref), u17 (copy), Debris (ref)
        TweenService:Create(u17, TweenInfo.new(1), {
            GroupTransparency = 1
        }):Play();
        TweenService:Create(u17.UIStroke, TweenInfo.new(1), {
            Transparency = 1
        }):Play();
        Debris:AddItem(u17, 1);
    end);
end;

function u1.Initialize(p23, p24) -- Line: 279
    -- upvalues: u2 (ref), Remotes (copy), u1 (copy), u3 (copy), u4 (copy), createStreakTemplate (copy), GameState (copy)
    u2 = p24;
    Remotes.UI.UIPlayerKilled.Listen(function(p25) -- Line: 281
        -- upvalues: u1 (ref), u3 (ref), u4 (ref), createStreakTemplate (ref)
        u1.createTemplate(p25);

        if workspace:GetAttribute("Gamemode") == "Deathmatch" then
            local Killer = p25.Killer;
            u3[p25.Victim] = 0;
            local v26 = (u3[Killer] or 0) + 1;
            u3[Killer] = v26;
            local v27 = u4[math.min(v26, 9)];

            if v27 then
                createStreakTemplate(tonumber(Killer), v27);
            end;
        end;
    end);
    GameState.ListenToState(function() -- Line: 301
        -- upvalues: u3 (ref)
        table.clear(u3);
    end);
end;

return u1;