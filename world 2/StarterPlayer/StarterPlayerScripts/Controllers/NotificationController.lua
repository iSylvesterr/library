-- Decompiled with Potassium's decompiler.

local u1 = {};
local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local TweenService = game:GetService("TweenService");
local TextService = game:GetService("TextService");
local UserInputService = game:GetService("UserInputService");
local Debris = game:GetService("Debris");
local SoundService = game:GetService("SoundService");
local SocialService = game:GetService("SocialService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(ReplicatedStorage.ClientModules.Chalk);
local NotificationCondenser = require(script.NotificationCondenser);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local NumberUtils = require(ReplicatedStorage.SharedModules.NumberUtils);
local Worlds = require(game.ReplicatedStorage.SharedModules.Worlds);
local GuildCompetition = require(ReplicatedStorage.SharedModules.GuildCompetition);
local Purchase = game.SoundService.SFX.Purchase;
local Accept = game.SoundService.SFX.BargainSFX.Accept;
local Tick = game.SoundService.SFX.Tick;
local Sound = Instance.new("Sound");
Sound.SoundId = "rbxassetid://114731118678981";
Sound.Parent = SoundService;

local function FormatCoins(p2) -- Line: 28
    -- upvalues: NumberUtils (copy), Worlds (copy)
    return "<font color=\"#00FF00\">" .. NumberUtils.Abbreviate(p2) .. Worlds.Current.CurrencySuffix .. "</font>";
end;

local LocalPlayer = Players.LocalPlayer;
local DevProductController = require(LocalPlayer.PlayerScripts.Controllers.DevProductController);

local function PromptFriendInvite() -- Line: 36
    -- upvalues: SocialService (copy), LocalPlayer (copy)
    local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions");
    ExperienceInviteOptions.PromptMessage = "Invite a friend to use the Wheelbarrow!";
    pcall(function() -- Line: 39
        -- upvalues: SocialService (ref), LocalPlayer (ref), ExperienceInviteOptions (copy)
        SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions);
    end);
end;

local function PromptFriendRequest(u3) -- Line: 47
    pcall(function() -- Line: 48
        -- upvalues: u3 (copy)
        game.StarterGui:SetCore("PromptSendFriendRequest", u3);
    end);
end;

local function GetBackpackSpaceUpgradesPurchased() -- Line: 58
    -- upvalues: LocalPlayer (copy)
    return tonumber(LocalPlayer:GetAttribute("BackpackSpaceUpgradesPurchased")) or 0;
end;

local function IsAtMaxBackpackSpace() -- Line: 62
    -- upvalues: LocalPlayer (copy)
    return (tonumber(LocalPlayer:GetAttribute("BackpackSpaceUpgradesPurchased")) or 0) >= 37;
end;

local function GetInventoryUpgradeProductKey() -- Line: 66
    -- upvalues: LocalPlayer (copy)
    local v4 = (tonumber(LocalPlayer:GetAttribute("BackpackSpaceUpgradesPurchased")) or 0) + 1;

    return `SkillUpgrade:Backpack Space:{math.min(v4, 37)}`;
end;

local function GetPropSpaceUpgradesPurchased() -- Line: 77
    -- upvalues: LocalPlayer (copy)
    return tonumber(LocalPlayer:GetAttribute("PropSpaceUpgradesPurchased")) or 0;
end;

local function IsAtMaxPropSpace() -- Line: 81
    -- upvalues: LocalPlayer (copy)
    return (tonumber(LocalPlayer:GetAttribute("PropSpaceUpgradesPurchased")) or 0) >= 37;
end;

local function GetPropSpaceUpgradeProductKey() -- Line: 85
    -- upvalues: LocalPlayer (copy)
    local v5 = (tonumber(LocalPlayer:GetAttribute("PropSpaceUpgradesPurchased")) or 0) + 1;

    return `SkillUpgrade:Prop Space:{math.min(v5, 37)}`;
end;

local Frame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("TopNotification"):WaitForChild("Frame");
local Notification = SoundService.SFX.Notification;
local Notification_UI_Mobile = ReplicatedStorage.Assets.NotificationUI.Notification_UI_Mobile;
local Notification_UI = ReplicatedStorage.Assets.NotificationUI.Notification_UI;

local function IsMobileScreen() -- Line: 105
    -- upvalues: UserInputService (copy)
    local CurrentCamera = workspace.CurrentCamera;

    if not CurrentCamera then
        return UserInputService.TouchEnabled;
    end;

    local ViewportSize = CurrentCamera.ViewportSize;

    return math.min(ViewportSize.X, ViewportSize.Y) <= 600;
end;

local function GetOdometerDuration(p6) -- Line: 123
    return p6 <= 1 and 0 or math.min(p6 * 0.05, 5);
end;

local u7 = {
    ["Common Seed Pack"] = {
        Color = Color3.fromRGB(180, 180, 180)
    },
    ["Uncommon Seed Pack"] = {
        Color = Color3.fromRGB(85, 220, 85)
    },
    ["Rare Seed Pack"] = {
        Color = Color3.fromRGB(85, 140, 255)
    },
    ["Epic Seed Pack"] = {
        Color = Color3.fromRGB(180, 90, 255)
    },
    ["Legendary Seed Pack"] = {
        Color = Color3.fromRGB(255, 220, 70)
    },
    ["Mythic Seed Pack"] = {
        Color = Color3.fromRGB(255, 70, 70)
    },
    ["Super Seed Pack"] = {
        Gradient = "rainbow"
    },
    ["Secret Seed Pack"] = {
        Gradient = "bw"
    },
    ["Common Fall Seed Pack"] = {
        Color = Color3.fromRGB(180, 180, 180)
    },
    ["Uncommon Fall Seed Pack"] = {
        Color = Color3.fromRGB(85, 220, 85)
    },
    ["Rare Fall Seed Pack"] = {
        Color = Color3.fromRGB(85, 140, 255)
    },
    ["Legendary Fall Seed Pack"] = {
        Color = Color3.fromRGB(255, 220, 70)
    },
    ["Mythic Fall Seed Pack"] = {
        Color = Color3.fromRGB(255, 70, 70)
    },
    ["Super Fall Seed Pack"] = {
        Gradient = "rainbow"
    },
    ["Secret Fall Seed Pack"] = {
        Gradient = "bw"
    },
    ["Gold Seed"] = {
        Gradient = "gold"
    },
    ["Rainbow Seed"] = {
        Gradient = "rainbow"
    },
    ["Mega Seed"] = {
        Color = Color3.fromRGB(89, 195, 255)
    }
};
local u8 = {
    Common = {
        Color = Color3.fromRGB(180, 180, 180)
    },
    Uncommon = {
        Color = Color3.fromRGB(85, 220, 85)
    },
    Rare = {
        Color = Color3.fromRGB(85, 140, 255)
    },
    Epic = {
        Color = Color3.fromRGB(180, 90, 255)
    },
    Legendary = {
        Color = Color3.fromRGB(255, 220, 70)
    },
    Mythic = {
        Color = Color3.fromRGB(255, 70, 70)
    },
    Super = {
        Gradient = "rainbow"
    },
    Secret = {
        Gradient = "bw"
    }
};
local u9 = { {
        threshold = 5,
        color = "#aaaaaa"
    }, {
        threshold = 10,
        color = "#55ff7f"
    }, {
        threshold = 15,
        color = "#ffe066"
    }, {
        threshold = 20,
        color = "#55aaff"
    }, {
        threshold = 40,
        color = "#ff5555"
    } };

local function GetRecordColor(p10) -- Line: 179
    -- upvalues: u9 (copy)
    for _, v in u9 do
        if p10 < v.threshold then
            return v.color;
        end;
    end;

    return nil;
end;

local u11 = {};
local u12 = {};

local function FadeSingleButton(p13, p14, p15) -- Line: 191
    -- upvalues: TweenService (copy)
    if not (p13 and p13.Visible) then
        return;
    end;

    TweenService:Create(p13, p15, {
        BackgroundTransparency = p14
    }):Play();
    local v16 = p13:FindFirstChildWhichIsA("UIStroke");

    if v16 then
        TweenService:Create(v16, p15, {
            Transparency = p14
        }):Play();
    end;

    for _, descendant in p13:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            TweenService:Create(descendant, p15, {
                TextTransparency = p14,
                TextStrokeTransparency = p14
            }):Play();
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            TweenService:Create(descendant, p15, {
                ImageTransparency = p14
            }):Play();
        elseif descendant:IsA("UIStroke") then
            TweenService:Create(descendant, p15, {
                Transparency = p14
            }):Play();
        end;
    end;
end;

local function FadeDevProductButton(p17, p18, p19) -- Line: 215
    -- upvalues: FadeSingleButton (copy)
    FadeSingleButton(p17.Content:FindFirstChild("DevProductInventory"), p18, p19);
end;

local function ActivateNotificationFrame(p20) -- Line: 219
    -- upvalues: TweenService (copy), FadeSingleButton (copy), Notification (copy)
    local v21 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v22 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    TweenService:Create(p20.Content.TextLabel, v22, {
        Position = p20.Content.TextLabel.Position
    }):Play();
    TweenService:Create(p20.ImageLabel, v21, {
        ImageTransparency = 0.5
    }):Play();
    TweenService:Create(p20.Content.TextLabel, v21, {
        TextTransparency = 0
    }):Play();
    TweenService:Create(p20.Content.TextLabel, v21, {
        TextStrokeTransparency = 0
    }):Play();
    local ItemIcon = p20.Content:FindFirstChild("ItemIcon");

    if ItemIcon and (ItemIcon:IsA("ImageLabel") and ItemIcon.Visible) then
        TweenService:Create(ItemIcon, v21, {
            ImageTransparency = 0
        }):Play();
    end;

    FadeSingleButton(p20.Content:FindFirstChild("DevProductInventory"), 0, v21);
    Notification.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
    Notification.Playing = true;
    Notification.TimePosition = 0;
end;

local function DeactivateNotificationFrame(p23) -- Line: 241
    -- upvalues: TweenService (copy), FadeSingleButton (copy), Debris (copy)
    local v24 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v25 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    TweenService:Create(p23.Content.TextLabel, v25, {
        Position = p23.Content.TextLabel.Position + UDim2.new(0, 0, 0.2, 0)
    }):Play();
    TweenService:Create(p23.ImageLabel, v24, {
        ImageTransparency = 1
    }):Play();
    TweenService:Create(p23.Content.TextLabel, v24, {
        TextTransparency = 1
    }):Play();
    TweenService:Create(p23.Content.TextLabel, v24, {
        TextStrokeTransparency = 1
    }):Play();
    local ItemIcon = p23.Content:FindFirstChild("ItemIcon");

    if ItemIcon and (ItemIcon:IsA("ImageLabel") and ItemIcon.Visible) then
        TweenService:Create(ItemIcon, v24, {
            ImageTransparency = 1
        }):Play();
    end;

    FadeSingleButton(p23.Content:FindFirstChild("DevProductInventory"), 1, v24);
    Debris:AddItem(p23, v24.Time);
end;

local function InitButtonHidden(p26) -- Line: 264
    p26.Visible = true;
    p26.BackgroundTransparency = 1;
    local v27 = p26:FindFirstChildWhichIsA("UIStroke");

    if v27 then
        v27.Transparency = 1;
    end;

    for _, descendant in p26:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            descendant.TextTransparency = 1;
            descendant.TextStrokeTransparency = 1;
        elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            descendant.ImageTransparency = 1;
        end;
    end;
end;

local function GetOrCreateItemIcon(p28) -- Line: 286
    local ItemIcon = p28:FindFirstChild("ItemIcon");

    if ItemIcon and ItemIcon:IsA("ImageLabel") then
        return ItemIcon;
    end;

    local ImageLabel = Instance.new("ImageLabel");
    ImageLabel.Name = "ItemIcon";
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5);
    ImageLabel.BackgroundTransparency = 1;
    ImageLabel.BorderSizePixel = 0;
    ImageLabel.ScaleType = Enum.ScaleType.Fit;
    ImageLabel.Size = UDim2.new(1, 0, 0.8, 0);
    ImageLabel.LayoutOrder = 2;
    ImageLabel.ZIndex = 3;
    ImageLabel.ImageTransparency = 1;
    ImageLabel.Visible = false;
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
    UIAspectRatioConstraint.AspectRatio = 1;
    UIAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize;
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width;
    UIAspectRatioConstraint.Parent = ImageLabel;
    ImageLabel.Parent = p28;

    return ImageLabel;
end;

local function CreateNotificationFrame(p29, p30, p31, p32, p33) -- Line: 314
    -- upvalues: GetOrCreateItemIcon (copy), LocalPlayer (copy), InitButtonHidden (copy), DevProductController (copy), SocialService (copy), Players (copy), Frame (copy)
    local u34 = p29:Clone();
    u34.Content.TextLabel.RichText = string.find(p30, "<%a") ~= nil;
    u34.Content.TextLabel.Text = p30;
    u34:SetAttribute("OG", p30);
    u34:SetAttribute("NotificationTimer", p31);

    if p32 then
        u34:SetAttribute("HelperUserId", p32);
    end;

    local IntValue = Instance.new("IntValue");
    IntValue.Name = "VAL_OBJ";
    IntValue.Value = 1;
    IntValue.Parent = u34;
    u34.ImageLabel.ImageTransparency = 1;
    u34.Content.TextLabel.TextTransparency = 1;
    u34.Content.TextLabel.TextStrokeTransparency = 1;

    if p33 and p33 ~= "" then
        local v35 = GetOrCreateItemIcon(u34.Content);
        v35.Image = p33;
        v35.ImageTransparency = 1;
        v35.Visible = true;
    else
        local ItemIcon = u34.Content:FindFirstChild("ItemIcon");

        if ItemIcon and ItemIcon:IsA("ImageLabel") then
            ItemIcon.Visible = false;
        end;
    end;

    if p30 == "Your inventory is full" then
        local v36 = (tonumber(LocalPlayer:GetAttribute("BackpackSpaceUpgradesPurchased")) or 0) >= 37;
        local DevProductInventory = u34.Content:FindFirstChild("DevProductInventory");

        if DevProductInventory then
            if v36 then
                DevProductInventory.Visible = false;
            else
                InitButtonHidden(DevProductInventory);
                DevProductInventory.Activated:Connect(function() -- Line: 358
                    -- upvalues: DevProductController (ref), LocalPlayer (ref)
                    local v37 = (tonumber(LocalPlayer:GetAttribute("BackpackSpaceUpgradesPurchased")) or 0) + 1;
                    DevProductController:PromptPurchase((`SkillUpgrade:Backpack Space:{math.min(v37, 37)}`));
                end);
            end;
        end;
    elseif p30 == "Friend in Server Required!" then
        local DevProductInventory = u34.Content:FindFirstChild("DevProductInventory");

        if DevProductInventory then
            InitButtonHidden(DevProductInventory);
            DevProductInventory.Activated:Connect(function() -- Line: 367
                -- upvalues: SocialService (ref), LocalPlayer (ref)
                local ExperienceInviteOptions = Instance.new("ExperienceInviteOptions");
                ExperienceInviteOptions.PromptMessage = "Invite a friend to use the Wheelbarrow!";
                pcall(function() -- Line: 39
                    -- upvalues: SocialService (ref), LocalPlayer (ref), ExperienceInviteOptions (copy)
                    SocialService:PromptGameInvite(LocalPlayer, ExperienceInviteOptions);
                end);
            end);
        end;
    else
        local v38 = u34:GetAttribute("HelperUserId") and u34.Content:FindFirstChild("DevProductInventory");

        if v38 then
            InitButtonHidden(v38);
            v38.Activated:Connect(function() -- Line: 379
                -- upvalues: u34 (copy), Players (ref)
                local v39 = u34:GetAttribute("HelperUserId");

                if type(v39) ~= "number" then
                    return;
                end;

                local u40 = Players:GetPlayerByUserId(v39);

                if u40 then
                    pcall(function() -- Line: 48
                        -- upvalues: u40 (copy)
                        game.StarterGui:SetCore("PromptSendFriendRequest", u40);
                    end);
                end;
            end);
        end;
    end;

    u34.Parent = Frame;

    return u34;
end;

local function CreateOdometerNotification(p41, u42, u43, u44, p45, p46, p47, u48, p49, p50, p51) -- Line: 399
    -- upvalues: Notification_UI_Mobile (copy), Notification_UI (copy), Frame (copy), CreateNotificationFrame (copy), ActivateNotificationFrame (copy), RunService (copy), Tick (copy), Accept (copy)
    local u52 = p46 or tostring;
    local u53 = p47 or (u43 <= 1 and 0 or math.min(u43 * 0.05, 5));
    local v54 = (p45 or 3.5) + math.ceil(u53);

    if p50 then
        for _, child in ipairs(Frame:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("OG") == p50 then
                local VAL_OBJ = child:FindFirstChild("VAL_OBJ");

                if VAL_OBJ then
                    VAL_OBJ.Value = VAL_OBJ.Value + (p51 or 1);
                    local v55 = " [X" .. VAL_OBJ.Value .. "]";
                    child:SetAttribute("StackSuffix", v55);
                    local v56 = child:GetAttribute("BaseText") or child.Content.TextLabel.Text;
                    child.Content.TextLabel.Text = v56 .. v55;
                end;

                child:SetAttribute("NotificationTimer", v54);

                return child;
            end;
        end;
    end;

    local v57 = u53 > 0 and 1 or u43;
    local v58 = u42 .. u52(v57) .. u44;
    local u59 = CreateNotificationFrame(p41 and Notification_UI_Mobile or Notification_UI, v58, v54, nil, p49);
    u59:SetAttribute("BaseText", v58);
    u59:SetAttribute("OG", p50 or `__odometer_{u42}{u43}_{os.clock()}`);
    local v60 = p50 and (p51 or 1) > 1 and u59:FindFirstChild("VAL_OBJ");

    if v60 then
        v60.Value = p51;
        local v61 = " [X" .. v60.Value .. "]";
        u59:SetAttribute("StackSuffix", v61);
        u59.Content.TextLabel.Text = v58 .. v61;
    end;

    ActivateNotificationFrame(u59);

    if u53 <= 0 then
        if u48 then
            u48(u59);
        end;

        return u59;
    end;

    local TextLabel = u59.Content.TextLabel;
    local u62 = os.clock();
    local u63 = v57;
    local u64 = 0;
    local u65 = nil;
    u65 = RunService.Heartbeat:Connect(function() -- Line: 454
        -- upvalues: u59 (copy), TextLabel (copy), u65 (ref), u62 (copy), u53 (copy), u43 (copy), u63 (ref), u42 (copy), u52 (copy), u44 (copy), u64 (ref), Tick (ref), Accept (ref), u48 (copy)
        if not (u59.Parent and TextLabel.Parent) then
            if u65 then
                u65:Disconnect();
                u65 = nil;
            end;

            return;
        end;

        local v66 = (os.clock() - u62) / u53;
        local v67 = math.min(v66, 1);
        local v68 = 1 - (1 - v67) ^ 2;
        local v69;

        if v67 >= 1 then
            v69 = u43;
        else
            local v70 = math.floor((u43 - 1) * v68 + 1 + 0.5);
            v69 = math.clamp(v70, 1, u43);
        end;

        if v69 ~= u63 then
            u63 = v69;
            local v71 = u42 .. u52(v69) .. u44;
            u59:SetAttribute("BaseText", v71);
            TextLabel.Text = v71 .. (u59:GetAttribute("StackSuffix") or "");
            local v72 = os.clock();

            if u64 <= v72 then
                local v73 = v68 + 1;
                Tick.PlaybackSpeed = v73;
                Tick.TimePosition = 0;
                Tick.Playing = true;
                u64 = v72 + 0.079 / v73;
            end;
        end;

        if v67 >= 1 and u65 then
            u65:Disconnect();
            u65 = nil;
            Accept.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
            Accept.TimePosition = 0;
            Accept.Playing = true;

            if u48 then
                u48(u59);
            end;
        end;
    end);
    u59.AncestryChanged:Connect(function(p74, p75) -- Line: 500
        -- upvalues: u65 (ref)
        if not p75 and u65 then
            u65:Disconnect();
            u65 = nil;
        end;
    end);

    return u59;
end;

local function CreateNotification(p76, p77, p78, p79) -- Line: 510
    -- upvalues: Purchase (copy), LocalPlayer (copy), CreateOdometerNotification (copy), FormatCoins (copy), u8 (copy), u1 (copy), Sound (copy), Notification_UI_Mobile (copy), Notification_UI (copy), NotificationCondenser (copy), Frame (copy), u12 (copy), u11 (copy), CreateNotificationFrame (copy), ActivateNotificationFrame (copy)
    local v80 = p79 or 3.5;
    local v81 = string.match(p77, "^You stole (%d+) fruits!$");

    if v81 then
        Purchase.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Purchase.Playing = true;
        Purchase.TimePosition = 0;
        local v82 = tonumber(LocalPlayer:GetAttribute("StolenCarryValue")) or 0;
        local v83 = math.floor(v82);

        if v83 > 0 then
            CreateOdometerNotification(p76, "You <font color=\"#FF4444\">stole</font> ", v83, " worth of fruit!", v80, FormatCoins, 2);

            return;
        end;

        CreateOdometerNotification(p76, "You stole ", tonumber(v81), " fruits!", v80);

        return;
    end;

    local v84, v85 = string.match(p77, "^(An?) (%a+) pet has spawned!$");

    if v84 and (v85 and u8[v85]) then
        u1:CreateRarityWordNotification(v84 .. " ", v85, " pet has spawned!", v85);

        return;
    end;

    local v86, v87 = string.match(p77, "^Guild Competition Record: ([%d%.]+)|(%a*)$");

    if v86 and tonumber(v86) then
        u1:CreateGuildRecordNotification(p76, tonumber(v86), v87, v80);

        return;
    end;

    if string.match(p77, "^New sell price record!") then
        Sound.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Sound.TimePosition = 0;
        Sound.Playing = true;
    end;

    local v88 = NotificationCondenser:GetCondenseKey(p77);
    local v89 = nil;

    if v88 then
        for _, child in ipairs(Frame:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("CondenseKey") == v88.Rule.Key then
                v89 = child;
                break;
            end;
        end;

        if v89 then
            if p76 then
                local v90 = u11[v88.Rule.Key] or {};
                table.insert(v90, {
                    Text = p77,
                    Duration = v80,
                    IsMobile = p76
                });
                u11[v88.Rule.Key] = v90;

                return;
            end;

            local v91 = u12[v89] or {};
            local v92 = {};

            for _, v in ipairs(v91) do
                v92[v.Plain] = true;
            end;

            if not v92[v88.Variant.Plain] then
                table.insert(v91, v88.Variant);
            end;

            u12[v89] = v91;

            if #v91 >= 2 then
                v89.Content.TextLabel.RichText = true;
                v89.Content.TextLabel.Text = NotificationCondenser:BuildCondensedText(v91, v88.Rule.Suffix, v88.Rule.PluralSuffix);
            end;

            v89:SetAttribute("NotificationTimer", v80);

            return;
        end;
    elseif not p78 then
        for _, child in ipairs(Frame:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("OG") == p77 then
                v89 = child;
                break;
            end;
        end;

        if v89 then
            local VAL_OBJ = v89:FindFirstChild("VAL_OBJ");

            if VAL_OBJ then
                VAL_OBJ.Value = VAL_OBJ.Value + 1;
                v89.Content.TextLabel.Text = p77 .. " [X" .. VAL_OBJ.Value .. "]";
            end;

            v89:SetAttribute("NotificationTimer", v80);

            return;
        end;
    end;

    local v93 = CreateNotificationFrame(p76 and Notification_UI_Mobile or Notification_UI, p77, v80);

    if v88 then
        v93:SetAttribute("CondenseKey", v88.Rule.Key);
        u12[v93] = { v88.Variant };
    end;

    ActivateNotificationFrame(v93);
end;

local function CreateHelperRequestNotification(p94) -- Line: 652
    -- upvalues: UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), Frame (copy), CreateNotificationFrame (copy), ActivateNotificationFrame (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local v95;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v95 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v95 = UserInputService.TouchEnabled;
    end;

    local v96 = `{p94.Name} is helping your garden! Friend?`;

    for _, child in Frame:GetChildren() do
        if child:IsA("Frame") and child:GetAttribute("HelperUserId") == p94.UserId then
            child:SetAttribute("NotificationTimer", 7);

            return;
        end;
    end;

    ActivateNotificationFrame((CreateNotificationFrame(v95 and Notification_UI_Mobile or Notification_UI, v96, 7, p94.UserId)));
end;

function u1.CreatePropLimitNotification(p97, p98, p99) -- Line: 678
    -- upvalues: Frame (copy), UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), CreateNotificationFrame (copy), LocalPlayer (copy), InitButtonHidden (copy), DevProductController (copy), ActivateNotificationFrame (copy)
    local v100 = `You have {p98}/{p99} props already placed in your garden!`;

    for _, child in Frame:GetChildren() do
        if child:IsA("Frame") and child:GetAttribute("OG") == "__prop_limit__" then
            child.Content.TextLabel.Text = v100;
            child:SetAttribute("NotificationTimer", 3.5);

            return;
        end;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local v101;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v101 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v101 = UserInputService.TouchEnabled;
    end;

    local v102 = CreateNotificationFrame(v101 and Notification_UI_Mobile or Notification_UI, v100, 3.5);
    v102:SetAttribute("OG", "__prop_limit__");
    local DevProductInventory = v102.Content:FindFirstChild("DevProductInventory");

    if DevProductInventory then
        if (tonumber(LocalPlayer:GetAttribute("PropSpaceUpgradesPurchased")) or 0) >= 37 then
            DevProductInventory.Visible = false;
        else
            InitButtonHidden(DevProductInventory);
            DevProductInventory.Activated:Connect(function() -- Line: 701
                -- upvalues: DevProductController (ref), LocalPlayer (ref)
                local v103 = (tonumber(LocalPlayer:GetAttribute("PropSpaceUpgradesPurchased")) or 0) + 1;
                DevProductController:PromptPurchase((`SkillUpgrade:Prop Space:{math.min(v103, 37)}`));
            end);
        end;
    end;

    ActivateNotificationFrame(v102);
end;

local u104 = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold);

local function MeasurePriceAspect(p105) -- Line: 739
    -- upvalues: u104 (copy), TextService (copy)
    local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
    GetTextBoundsParams.Text = p105;
    GetTextBoundsParams.Font = u104;
    GetTextBoundsParams.Size = 100;
    GetTextBoundsParams.Width = (1 / 0);
    local success, result = pcall(function() -- Line: 746
        -- upvalues: TextService (ref), GetTextBoundsParams (copy)
        return TextService:GetTextBoundsAsync(GetTextBoundsParams);
    end);

    return (not success or (not result or result.Y <= 0)) and 2.3 or result.X / result.Y;
end;

local function ApplyPriceToButton(p106, p107, p108) -- Line: 762
    local TextLabel = p106:FindFirstChild("TextLabel");
    local v109;

    if TextLabel then
        v109 = TextLabel:FindFirstChild("TextLabel");
    else
        v109 = TextLabel;
    end;

    if not (TextLabel and v109) then
        return;
    end;

    TextLabel.Text = p107;
    v109.Text = p107;
    local v110 = p106:FindFirstChildOfClass("UIAspectRatioConstraint");

    if not v110 then
        return;
    end;

    local v111 = (0.5 - v109.Position.Y.Scale) * TextLabel.Size.Y.Scale;
    v110.AspectRatio = p108 * 0.6 / 0.84;
    TextLabel.Size = UDim2.fromScale(0.84, 0.6);
    TextLabel.Position = UDim2.fromScale(0.5, 0.5);
    v109.Position = UDim2.fromScale(0.5, 0.5 - v111 / 0.6);
end;

local function StackButtonUnderMessage(p112, p113) -- Line: 791
    local v114 = p112.Content:FindFirstChildOfClass("UIListLayout");
    local TextLabel = p112.Content:FindFirstChild("TextLabel");

    if not (v114 and TextLabel) then
        return;
    end;

    p112.Size = UDim2.fromScale(p112.Size.X.Scale, p112.Size.Y.Scale * 2.2800000000000002);
    v114.FillDirection = Enum.FillDirection.Vertical;
    v114.Padding = UDim.new(0.07894736842105261, 0);
    TextLabel.Size = UDim2.fromScale(0, 0.43859649122807015);
    p113.Size = UDim2.fromScale(p113.Size.X.Scale, 0.4824561403508772);
end;

function u1.CreateStarterPackNotification(p115, p116, p117, u118) -- Line: 807
    -- upvalues: MeasurePriceAspect (copy), Frame (copy), UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), CreateNotificationFrame (copy), InitButtonHidden (copy), ApplyPriceToButton (copy), StackButtonUnderMessage (copy), DeactivateNotificationFrame (copy), ActivateNotificationFrame (copy)
    local v119;

    if p117 then
        v119 = `{p117}`;
    else
        v119 = nil;
    end;

    local v120 = not v119 and 0 or MeasurePriceAspect(v119);

    for _, child in Frame:GetChildren() do
        if child:IsA("Frame") and child:GetAttribute("OG") == "__starter_pack_offer__" then
            child:SetAttribute("NotificationTimer", 14);

            return;
        end;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local v121;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v121 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v121 = UserInputService.TouchEnabled;
    end;

    local u122 = CreateNotificationFrame(v121 and Notification_UI_Mobile or Notification_UI, `{p116} unlocked - one-time offer!`, 14);
    u122:SetAttribute("OG", "__starter_pack_offer__");
    local DevProductInventory = u122.Content:FindFirstChild("DevProductInventory");

    if DevProductInventory then
        InitButtonHidden(DevProductInventory);

        if v119 then
            ApplyPriceToButton(DevProductInventory, v119, v120);
        end;

        StackButtonUnderMessage(u122, DevProductInventory);
        local u123 = false;
        DevProductInventory.Activated:Connect(function() -- Line: 837
            -- upvalues: u123 (ref), u122 (copy), DeactivateNotificationFrame (ref), u118 (copy)
            if u123 then
                return;
            end;

            u123 = true;
            u122:SetAttribute("NotificationTimer", nil);
            DeactivateNotificationFrame(u122);
            u118();
        end);
    end;

    ActivateNotificationFrame(u122);
end;

local function FormatStaticSeedPackText(p124, p125) -- Line: 852
    return `A <font color="rgb({math.floor(p125.R * 255)},{math.floor(p125.G * 255)},{math.floor(p125.B * 255)})">{p124}</font> Spawned!`;
end;

local function FormatStaticSeedPackClaimedText(p126, p127, p128) -- Line: 859
    return `{p126} found a <font color="rgb({math.floor(p128.R * 255)},{math.floor(p128.G * 255)},{math.floor(p128.B * 255)})">{p127}</font>!`;
end;

local function BuildAnimatedPackName(p129, p130, p131) -- Line: 909
    local v132 = 0;
    local v133 = {};

    for i, v in utf8.graphemes(p129) do
        v132 = v132 + 1;
        local v134 = string.sub(p129, i, v);
        local v135, v136, v137;

        if p131 == "rainbow" then
            local v138 = Color3.fromHSV((p130 * 0.6 + (v132 - 1) * 0.02) % 1, 1, 1);
            v135 = math.floor(v138.R * 255);
            v136 = math.floor(v138.G * 255);
            v137 = math.floor(v138.B * 255);
        elseif p131 == "gold" then
            local v139 = math.sin(p130 * 5 + v132 * 0.55) * 0.5 + 0.5;
            v136 = math.floor(v139 * 60 + 180);
            v137 = math.floor(v139 * 40 + 20);
            v135 = 255;
        else
            local v140 = (math.sin(p130 * 4 + v132 * 0.45) * 0.5 + 0.5) * 255;
            v135 = math.floor(v140);
            v137 = v135;
            v136 = v137;
            local v141 = v137;
            v137 = v136;
            v141 = v136;
        end;

        if v134 == " " then
            v133[v132] = " ";
        else
            v133[v132] = `<font color="rgb({v135},{v136},{v137})">{v134}</font>`;
        end;
    end;

    return table.concat(v133);
end;

local function FormatAnimatedSeedPackText(p142, p143, p144) -- Line: 945
    -- upvalues: BuildAnimatedPackName (copy)
    return `A {BuildAnimatedPackName(p142, p143, p144)} Spawned!`;
end;

local function FormatAnimatedSeedPackClaimedText(p145, p146, p147, p148) -- Line: 949
    -- upvalues: BuildAnimatedPackName (copy)
    return `{p145} found a {BuildAnimatedPackName(p146, p147, p148)}!`;
end;

function u1.CreateSeedPackSpawnNotification(p149, u150) -- Line: 953
    -- upvalues: u7 (copy), UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), BuildAnimatedPackName (copy), Frame (copy), ActivateNotificationFrame (copy), RunService (copy)
    local v151 = u7[u150];

    if not v151 then
        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local v152;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v152 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v152 = UserInputService.TouchEnabled;
    end;

    local v153;

    if v151.Gradient then
        v153 = `A {BuildAnimatedPackName(u150, 0, v151.Gradient)} Spawned!`;
    else
        local v154 = v151.Color or Color3.new(1, 1, 1);
        v153 = `A <font color="rgb({math.floor(v154.R * 255)},{math.floor(v154.G * 255)},{math.floor(v154.B * 255)})">{u150}</font> Spawned!`;
    end;

    local u155 = (v152 and Notification_UI_Mobile or Notification_UI):Clone();
    u155:SetAttribute("OG", (`__seedpack_{u150}_{os.clock()}`));
    u155:SetAttribute("NotificationTimer", 6);
    u155.Content.TextLabel.RichText = true;
    u155.Content.TextLabel.Text = v153;
    local IntValue = Instance.new("IntValue");
    IntValue.Name = "VAL_OBJ";
    IntValue.Value = 1;
    IntValue.Parent = u155;
    u155.ImageLabel.ImageTransparency = 1;
    u155.Content.TextLabel.TextTransparency = 1;
    u155.Content.TextLabel.TextStrokeTransparency = 1;
    u155.Parent = Frame;
    ActivateNotificationFrame(u155);

    if v151.Gradient then
        local TextLabel = u155.Content.TextLabel;
        local Gradient = v151.Gradient;
        local u156 = os.clock();
        local u157 = nil;
        u157 = RunService.Heartbeat:Connect(function() -- Line: 992
            -- upvalues: u155 (copy), TextLabel (copy), u157 (ref), u150 (copy), u156 (copy), Gradient (copy), BuildAnimatedPackName (ref)
            if u155.Parent and TextLabel.Parent then
                TextLabel.Text = `A {BuildAnimatedPackName(u150, os.clock() - u156, Gradient)} Spawned!`;

                return;
            end;

            u157:Disconnect();
        end);
        u155.AncestryChanged:Connect(function(p158, p159) -- Line: 999
            -- upvalues: u157 (ref)
            if not p159 and u157 then
                u157:Disconnect();
                u157 = nil;
            end;
        end);
    end;
end;

local function FormatStaticBirdSeedText(p160, p161, p162) -- Line: 1008
    return `Your {p162} dropped a <font color="rgb({math.floor(p161.R * 255)},{math.floor(p161.G * 255)},{math.floor(p161.B * 255)})">{p160} Seed</font>!`;
end;

local function FormatAnimatedBirdSeedText(p163, p164, p165, p166) -- Line: 1015
    -- upvalues: BuildAnimatedPackName (copy)
    return `Your {p166} dropped a {BuildAnimatedPackName(p163 .. " Seed", p164, p165)}!`;
end;

local function FormatStaticRarityWordText(p167, p168, p169, p170) -- Line: 1019
    return `{p167}<font color="rgb({math.floor(p170.R * 255)},{math.floor(p170.G * 255)},{math.floor(p170.B * 255)})">{p168}</font>{p169}`;
end;

local function FormatAnimatedRarityWordText(p171, p172, p173, p174, p175) -- Line: 1026
    -- upvalues: BuildAnimatedPackName (copy)
    return `{p171}{BuildAnimatedPackName(p172, p174, p175)}{p173}`;
end;

function u1.CreateRarityWordNotification(p176, u177, u178, u179, p180) -- Line: 1030
    -- upvalues: u8 (copy), UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), BuildAnimatedPackName (copy), Frame (copy), ActivateNotificationFrame (copy), RunService (copy)
    local v181 = u8[p180] or u8.Common;
    local CurrentCamera = workspace.CurrentCamera;
    local v182;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v182 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v182 = UserInputService.TouchEnabled;
    end;

    local v183;

    if v181.Gradient then
        v183 = `{u177}{BuildAnimatedPackName(u178, 0, v181.Gradient)}{u179}`;
    else
        local v184 = v181.Color or Color3.new(1, 1, 1);
        v183 = `{u177}<font color="rgb({math.floor(v184.R * 255)},{math.floor(v184.G * 255)},{math.floor(v184.B * 255)})">{u178}</font>{u179}`;
    end;

    local u185 = (v182 and Notification_UI_Mobile or Notification_UI):Clone();
    u185:SetAttribute("OG", (`__rarity_word_{u178}_{p180}_{os.clock()}`));
    u185:SetAttribute("NotificationTimer", 6);
    u185.Content.TextLabel.RichText = true;
    u185.Content.TextLabel.Text = v183;
    local IntValue = Instance.new("IntValue");
    IntValue.Name = "VAL_OBJ";
    IntValue.Value = 1;
    IntValue.Parent = u185;
    u185.ImageLabel.ImageTransparency = 1;
    u185.Content.TextLabel.TextTransparency = 1;
    u185.Content.TextLabel.TextStrokeTransparency = 1;
    u185.Parent = Frame;
    ActivateNotificationFrame(u185);

    if v181.Gradient then
        local TextLabel = u185.Content.TextLabel;
        local Gradient = v181.Gradient;
        local u186 = os.clock();
        local u187 = nil;
        u187 = RunService.Heartbeat:Connect(function() -- Line: 1066
            -- upvalues: u185 (copy), TextLabel (copy), u187 (ref), u177 (copy), u178 (copy), u179 (copy), u186 (copy), Gradient (copy), BuildAnimatedPackName (ref)
            if not (u185.Parent and TextLabel.Parent) then
                u187:Disconnect();

                return;
            end;

            TextLabel.Text = `{u177}{BuildAnimatedPackName(u178, os.clock() - u186, Gradient)}{u179}`;
        end);
        u185.AncestryChanged:Connect(function(p188, p189) -- Line: 1073
            -- upvalues: u187 (ref)
            if not p189 and u187 then
                u187:Disconnect();
                u187 = nil;
            end;
        end);
    end;
end;

function u1.CreateGuildRecordNotification(p190, p191, u192, u193, p194) -- Line: 1087
    -- upvalues: u9 (copy), GuildCompetition (copy), CreateOdometerNotification (copy), RunService (copy), BuildAnimatedPackName (copy)
    local u195 = nil;

    for _, v in u9 do
        if u192 < v.threshold then
            u195 = v.color;
            break;
        end;
    end;

    CreateOdometerNotification(p191, not u195 and "Guild Competition Record: " or `Guild Competition Record: <font color="{u195}">`, u192, u195 and "</font>!" or "!", p194, function(p196) -- Line: 1096, Name: formatScore
        -- upvalues: GuildCompetition (ref), u193 (copy)
        return GuildCompetition.FormatScore(p196, u193);
    end, nil, function(u197) -- Line: 1100
        -- upvalues: u195 (copy), u192 (copy), GuildCompetition (ref), u193 (copy), RunService (ref), BuildAnimatedPackName (ref)
        if u195 then
            return;
        end;

        local u198 = u197.Content and u197.Content:FindFirstChild("TextLabel");

        if not u198 then
            return;
        end;

        u198.RichText = true;
        local u199 = GuildCompetition.FormatScore(u192, u193);
        local u200 = os.clock();
        local u201 = nil;
        u201 = RunService.Heartbeat:Connect(function() -- Line: 1110
            -- upvalues: u197 (copy), u198 (copy), u201 (ref), u199 (copy), u200 (copy), BuildAnimatedPackName (ref)
            if u197.Parent and u198.Parent then
                u198.Text = `Guild Competition Record: {BuildAnimatedPackName(u199, os.clock() - u200, "rainbow")}!`;

                return;
            end;

            if u201 then
                u201:Disconnect();
                u201 = nil;
            end;
        end);
        u197.AncestryChanged:Connect(function(p202, p203) -- Line: 1117
            -- upvalues: u201 (ref)
            if not p203 and u201 then
                u201:Disconnect();
                u201 = nil;
            end;
        end);
    end);
end;

function u1.CreatePartyPointsNotification(p204, p205, p206) -- Line: 1128
    -- upvalues: UserInputService (copy), CreateOdometerNotification (copy)
    if type(p205) ~= "number" or (p205 ~= p205 or p205 <= 0) then
        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local v207;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v207 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v207 = UserInputService.TouchEnabled;
    end;

    CreateOdometerNotification(v207, "<font color=\"#FFEE00\">+", math.floor(p205), "</font> Party Points!", p206);
end;

function u1.CreateBirdSeedDropNotification(p208, u209, p210, u211) -- Line: 1139
    -- upvalues: u8 (copy), UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), BuildAnimatedPackName (copy), Frame (copy), ActivateNotificationFrame (copy), RunService (copy)
    local v212 = u8[p210] or u8.Common;
    local CurrentCamera = workspace.CurrentCamera;
    local v213;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v213 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v213 = UserInputService.TouchEnabled;
    end;

    local v214;

    if v212.Gradient then
        v214 = `Your {u211} dropped a {BuildAnimatedPackName(u209 .. " Seed", 0, v212.Gradient)}!`;
    else
        local v215 = v212.Color or Color3.new(1, 1, 1);
        v214 = `Your {u211} dropped a <font color="rgb({math.floor(v215.R * 255)},{math.floor(v215.G * 255)},{math.floor(v215.B * 255)})">{u209} Seed</font>!`;
    end;

    local u216 = (v213 and Notification_UI_Mobile or Notification_UI):Clone();
    u216:SetAttribute("OG", (`__bird_seed_{u209}_{os.clock()}`));
    u216:SetAttribute("NotificationTimer", 6);
    u216.Content.TextLabel.RichText = true;
    u216.Content.TextLabel.Text = v214;
    local IntValue = Instance.new("IntValue");
    IntValue.Name = "VAL_OBJ";
    IntValue.Value = 1;
    IntValue.Parent = u216;
    u216.ImageLabel.ImageTransparency = 1;
    u216.Content.TextLabel.TextTransparency = 1;
    u216.Content.TextLabel.TextStrokeTransparency = 1;
    u216.Parent = Frame;
    ActivateNotificationFrame(u216);

    if v212.Gradient then
        local TextLabel = u216.Content.TextLabel;
        local Gradient = v212.Gradient;
        local u217 = os.clock();
        local u218 = nil;
        u218 = RunService.Heartbeat:Connect(function() -- Line: 1175
            -- upvalues: u216 (copy), TextLabel (copy), u218 (ref), u209 (copy), u217 (copy), Gradient (copy), u211 (copy), BuildAnimatedPackName (ref)
            if not (u216.Parent and TextLabel.Parent) then
                u218:Disconnect();

                return;
            end;

            local v219 = os.clock() - u217;
            TextLabel.Text = `Your {u211} dropped a {BuildAnimatedPackName(u209 .. " Seed", v219, Gradient)}!`;
        end);
        u216.AncestryChanged:Connect(function(p220, p221) -- Line: 1182
            -- upvalues: u218 (ref)
            if not p221 and u218 then
                u218:Disconnect();
                u218 = nil;
            end;
        end);
    end;
end;

function u1.CreateSeedPackClaimedNotification(p222, u223, u224) -- Line: 1191
    -- upvalues: u7 (copy), UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), BuildAnimatedPackName (copy), Frame (copy), ActivateNotificationFrame (copy), RunService (copy)
    local v225 = u7[u224];

    if not v225 then
        return;
    end;

    local CurrentCamera = workspace.CurrentCamera;
    local v226;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v226 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v226 = UserInputService.TouchEnabled;
    end;

    local v227;

    if v225.Gradient then
        v227 = `{u223} found a {BuildAnimatedPackName(u224, 0, v225.Gradient)}!`;
    else
        local v228 = v225.Color or Color3.new(1, 1, 1);
        v227 = `{u223} found a <font color="rgb({math.floor(v228.R * 255)},{math.floor(v228.G * 255)},{math.floor(v228.B * 255)})">{u224}</font>!`;
    end;

    local u229 = (v226 and Notification_UI_Mobile or Notification_UI):Clone();
    u229:SetAttribute("OG", (`__seedpack_claimed_{u223}_{u224}_{os.clock()}`));
    u229:SetAttribute("NotificationTimer", 6);
    u229.Content.TextLabel.RichText = true;
    u229.Content.TextLabel.Text = v227;
    local IntValue = Instance.new("IntValue");
    IntValue.Name = "VAL_OBJ";
    IntValue.Value = 1;
    IntValue.Parent = u229;
    u229.ImageLabel.ImageTransparency = 1;
    u229.Content.TextLabel.TextTransparency = 1;
    u229.Content.TextLabel.TextStrokeTransparency = 1;
    u229.Parent = Frame;
    ActivateNotificationFrame(u229);

    if v225.Gradient then
        local TextLabel = u229.Content.TextLabel;
        local Gradient = v225.Gradient;
        local u230 = os.clock();
        local u231 = nil;
        u231 = RunService.Heartbeat:Connect(function() -- Line: 1230
            -- upvalues: u229 (copy), TextLabel (copy), u231 (ref), u223 (copy), u224 (copy), u230 (copy), Gradient (copy), BuildAnimatedPackName (ref)
            if u229.Parent and TextLabel.Parent then
                TextLabel.Text = `{u223} found a {BuildAnimatedPackName(u224, os.clock() - u230, Gradient)}!`;

                return;
            end;

            u231:Disconnect();
        end);
        u229.AncestryChanged:Connect(function(p232, p233) -- Line: 1237
            -- upvalues: u231 (ref)
            if not p233 and u231 then
                u231:Disconnect();
                u231 = nil;
            end;
        end);
    end;
end;

function u1.Init(p234) -- Line: 1246
end;

function u1.Start(u235) -- Line: 1249
    -- upvalues: Frame (copy), DeactivateNotificationFrame (copy), u11 (copy), Notification_UI_Mobile (copy), Notification_UI (copy), CreateNotificationFrame (copy), ActivateNotificationFrame (copy), Networking (copy), CreateNotification (copy), UserInputService (copy), Players (copy), CreateHelperRequestNotification (copy), LocalPlayer (copy)
    task.spawn(function() -- Line: 1250
        -- upvalues: Frame (ref), DeactivateNotificationFrame (ref), u11 (ref), Notification_UI_Mobile (ref), Notification_UI (ref), CreateNotificationFrame (ref), ActivateNotificationFrame (ref)
        while true do
            for _, child in Frame:GetChildren() do
                if child:IsA("Frame") and (child.Name == "Notification_UI" or child.Name == "Notification_UI_Mobile") then
                    local v236 = child:GetAttribute("NotificationTimer");

                    if v236 and type(v236) == "number" then
                        local v237 = v236 - 1;

                        if v237 <= 0 then
                            child:SetAttribute("NotificationTimer", nil);
                            local v238 = child:GetAttribute("CondenseKey");
                            DeactivateNotificationFrame(child);

                            if v238 then
                                local v239 = u11[v238] or {};

                                if #v239 >= 1 then
                                    local v240 = v239[1];
                                    table.remove(v239, 1);
                                    local u241 = CreateNotificationFrame(v240.IsMobile and Notification_UI_Mobile or Notification_UI, v240.Text, v240.Duration);
                                    u241:SetAttribute("CondenseKey", v238);
                                    task.spawn(function() -- Line: 1275
                                        -- upvalues: ActivateNotificationFrame (ref), u241 (copy)
                                        task.wait(0.4);
                                        ActivateNotificationFrame(u241);
                                    end);
                                end;
                            end;
                        else
                            child:SetAttribute("NotificationTimer", v237);
                        end;
                    end;
                end;
            end;

            task.wait(1);
        end;
    end);
    Networking.Notification.OnClientEvent:Connect(function(...) -- Line: 1292
        -- upvalues: CreateNotification (ref), UserInputService (ref)
        local CurrentCamera = workspace.CurrentCamera;
        local v242;

        if CurrentCamera then
            local ViewportSize = CurrentCamera.ViewportSize;
            v242 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
        else
            v242 = UserInputService.TouchEnabled;
        end;

        CreateNotification(v242, ...);
    end);
    game.ReplicatedStorage.Notify.Event:Connect(function(...) -- Line: 1295
        -- upvalues: CreateNotification (ref), UserInputService (ref)
        local CurrentCamera = workspace.CurrentCamera;
        local v243;

        if CurrentCamera then
            local ViewportSize = CurrentCamera.ViewportSize;
            v243 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
        else
            v243 = UserInputService.TouchEnabled;
        end;

        CreateNotification(v243, ...);
    end);
    Networking.HelperRequest.OnClientEvent:Connect(function(p244) -- Line: 1299
        -- upvalues: Players (ref), CreateHelperRequestNotification (ref)
        if type(p244) ~= "number" then
            return;
        end;

        local v245 = Players:GetPlayerByUserId(p244);

        if not v245 then
            return;
        end;

        CreateHelperRequestNotification(v245);
    end);
    Networking.Prop.PropLimitReached.OnClientEvent:Connect(function(p246, p247) -- Line: 1306
        -- upvalues: u235 (copy)
        if type(p246) ~= "number" or type(p247) ~= "number" then
            return;
        end;

        u235:CreatePropLimitNotification(p246, p247);
    end);
    Networking.DevProducts.GamepassGiftReceived.OnClientEvent:Connect(function(u248, u249) -- Line: 1314
        -- upvalues: LocalPlayer (ref), CreateNotification (ref), UserInputService (ref)
        if type(u248) ~= "string" or u248 == "" then
            return;
        end;

        if type(u249) ~= "string" or u249 == "" then
            return;
        end;

        task.spawn(function() -- Line: 1317
            -- upvalues: LocalPlayer (ref), CreateNotification (ref), UserInputService (ref), u249 (copy), u248 (copy)
            local v250 = os.clock() + 60;

            while LocalPlayer:GetAttribute("LoadingScreenActive") ~= false and os.clock() < v250 do
                task.wait(0.25);
            end;

            local CurrentCamera = workspace.CurrentCamera;
            local v251;

            if CurrentCamera then
                local ViewportSize = CurrentCamera.ViewportSize;
                v251 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
            else
                v251 = UserInputService.TouchEnabled;
            end;

            CreateNotification(v251, (`<font color="#5B9CF5">@{u249}</font> gifted you <font color="#5B9CF5">{u248}</font>!`));
        end);
    end);
    Networking.SeedPackSpawn.Claimed.OnClientEvent:Connect(function(p252, p253) -- Line: 1332
        -- upvalues: u235 (copy)
        if type(p252) ~= "string" or type(p253) ~= "string" then
            return;
        end;

        u235:CreateSeedPackClaimedNotification(p252, p253);
    end);
    Networking.Bird.SeedDropped.OnClientEvent:Connect(function(p254, p255, p256) -- Line: 1337
        -- upvalues: u235 (copy)
        if type(p254) ~= "string" or type(p255) ~= "string" then
            return;
        end;

        u235:CreateBirdSeedDropNotification(p254, p255, (type(p256) ~= "string" or p256 == "") and "bird" or p256);
    end);
end;

function u1.CreateNotification(p257, p258, p259, p260) -- Line: 1343
    -- upvalues: UserInputService (copy), CreateNotification (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local v261;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v261 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v261 = UserInputService.TouchEnabled;
    end;

    CreateNotification(v261, p258, p259, p260);
end;

function u1.CreateItemClaimNotification(p262, p263, p264, p265, p266) -- Line: 1351
    -- upvalues: UserInputService (copy), CreateOdometerNotification (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local v267;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v267 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v267 = UserInputService.TouchEnabled;
    end;

    local v268 = " " .. p265;

    if p266 and p266 ~= "" then
        v268 = v268 .. "   " .. p266;
    end;

    if p264 > 1 then
        math.clamp(p264 * 0.05, 1, 5);
    end;

    CreateOdometerNotification(v267, "x", 1, v268, nil, nil, 0, nil, p263, `__itemclaim_{p265}_{p263 or ""}`, p264);
end;

function u1.CreateStickyNotification(p269, p270) -- Line: 1374
    -- upvalues: UserInputService (copy), Notification_UI_Mobile (copy), Notification_UI (copy), Frame (copy), ActivateNotificationFrame (copy), DeactivateNotificationFrame (copy)
    local CurrentCamera = workspace.CurrentCamera;
    local v271;

    if CurrentCamera then
        local ViewportSize = CurrentCamera.ViewportSize;
        v271 = math.min(ViewportSize.X, ViewportSize.Y) <= 600;
    else
        v271 = UserInputService.TouchEnabled;
    end;

    local u272 = (v271 and Notification_UI_Mobile or Notification_UI):Clone();
    u272:SetAttribute("NotificationTimer", nil);
    u272.Content.TextLabel.RichText = true;
    u272.Content.TextLabel.Text = p270;
    u272:SetAttribute("OG", "__sticky__");
    u272.ImageLabel.ImageTransparency = 1;
    u272.Content.TextLabel.TextTransparency = 1;
    u272.Content.TextLabel.TextStrokeTransparency = 1;
    u272.Parent = Frame;
    ActivateNotificationFrame(u272);
    local v273 = {};
    local u274 = false;

    function v273.SetText(p275, p276) -- Line: 1399
        -- upvalues: u274 (ref), u272 (copy)
        if u274 or not u272.Parent then
            return;
        end;

        u272.Content.TextLabel.RichText = true;
        u272.Content.TextLabel.Text = p276;
    end;

    function v273.Dismiss(p277) -- Line: 1405
        -- upvalues: u274 (ref), u272 (copy), DeactivateNotificationFrame (ref)
        if u274 then
            return;
        end;

        u274 = true;

        if u272.Parent then
            DeactivateNotificationFrame(u272);
        end;
    end;

    return v273;
end;

return u1;