-- Decompiled with Potassium's decompiler.

local v1 = {
    StartOrder = 8
};
local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TextChatService = game:GetService("TextChatService");
local TextService = game:GetService("TextService");
local TweenService = game:GetService("TweenService");
game:GetService("UserInputService");
local StarterGui = game:GetService("StarterGui");
local ContextActionService = game:GetService("ContextActionService");
local GuildFeedData = require(ReplicatedStorage.SharedModules.GuildFeedData);
local GuildFeedFlags = require(ReplicatedStorage.SharedModules.Flags.GuildFeedFlags);
local ItemShowcasePackets = require(ReplicatedStorage.SharedModules.ItemShowcasePackets);
local MutationData = require(ReplicatedStorage.SharedModules.MutationData);
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local WeightFormat = require(ReplicatedStorage.SharedModules.WeightFormat);
local GuildCardUI = require(ReplicatedStorage.ClientModules.GuildCardUI);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local topbarplus = require(ReplicatedStorage.ClientModules.topbarplus);
local DevProductController = require(script.Parent:FindFirstChild("DevProductController"));
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local ChatWindowConfiguration = TextChatService.ChatWindowConfiguration;
local ChatInputBarConfiguration = TextChatService.ChatInputBarConfiguration;
local u2 = Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal);
local u3 = Color3.fromRGB(120, 200, 120);
local u4 = Color3.fromRGB(150, 158, 150);
local u5 = Color3.fromRGB(255, 255, 255);
local u6 = Color3.fromRGB(178, 178, 178);
local u7 = utf8.char(57344);
local u8 = { "Hello!", "Welcome!", "Thanks!", "Nice garden!", "Trade at my plot?", "Check the guild feed!", "gg", "brb" };
local u9 = false;
local u10 = true;
local u11 = false;
local u12 = false;
local u13 = 0;
local u14 = nil;
local u15 = {};
local u16 = 0;
local u17 = {};
local u18 = {};
local u19 = {};
local u20 = false;
local u21 = false;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = nil;
local u26 = nil;
local u27 = nil;
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = nil;
local u32 = nil;
local u33 = nil;
local u34 = nil;
local u35 = nil;
local u36 = nil;
local u37 = nil;
local u38 = nil;
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = {};
local u47 = "Here";
local u48 = false;

local function AddCorner(p49, p50) -- Line: 115
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, p50);
    UICorner.Parent = p49;

    return UICorner;
end;

local function ApplyConfig() -- Line: 123
    -- upvalues: u23 (ref), ChatWindowConfiguration (copy), u29 (ref), ChatInputBarConfiguration (copy), u30 (ref)
    u23.BackgroundColor3 = ChatWindowConfiguration.BackgroundColor3;
    u23.BackgroundTransparency = ChatWindowConfiguration.BackgroundTransparency;
    u29.BackgroundColor3 = ChatInputBarConfiguration.BackgroundColor3;
    u29.BackgroundTransparency = ChatInputBarConfiguration.BackgroundTransparency;
    u30.FontFace = ChatInputBarConfiguration.FontFace;
    u30.TextSize = ChatInputBarConfiguration.TextSize;
    u30.TextColor3 = ChatInputBarConfiguration.TextColor3;
    u30.PlaceholderColor3 = ChatInputBarConfiguration.PlaceholderColor3;
end;

local function SetWindowOpen(p51) -- Line: 135
    -- upvalues: u23 (ref)
    u23.Visible = p51;
end;

local function UpdateButtonLook() -- Line: 140
    -- upvalues: u45 (ref), u10 (ref)
    if not u45 then
        return;
    end;

    if u10 and not u45.isSelected then
        u45:select("GuildChat", u45);

        return;
    end;

    if not u10 and u45.isSelected then
        u45:deselect("GuildChat", u45);
    end;
end;

local function IsViewingChat() -- Line: 150
    -- upvalues: u10 (ref), u47 (ref)
    local v52;

    if u10 == true then
        v52 = u47 == "Here";
    else
        v52 = false;
    end;

    return v52;
end;

local function ClearMissedBadge() -- Line: 155
    -- upvalues: u45 (ref)
    if u45 then
        u45:clearNotices();
    end;
end;

local function IsActive() -- Line: 162
    -- upvalues: u11 (ref), u12 (ref)
    return u11 or u12;
end;

local function TweenChrome(p53) -- Line: 167
    -- upvalues: ChatWindowConfiguration (copy), ChatInputBarConfiguration (copy), TweenService (copy), u23 (ref), u29 (ref), u30 (ref), u32 (ref), u33 (ref), u38 (ref), u37 (ref), u40 (ref), u42 (ref), u41 (ref), u43 (ref), u44 (ref)
    local v54 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
    local v55 = p53 and ChatInputBarConfiguration.BackgroundTransparency or 1;
    local v56 = p53 and 0 or 1;
    TweenService:Create(u23, v54, {
        BackgroundTransparency = p53 and ChatWindowConfiguration.BackgroundTransparency or 1
    }):Play();
    TweenService:Create(u29, v54, {
        BackgroundTransparency = v55
    }):Play();
    TweenService:Create(u30, v54, {
        TextTransparency = v56
    }):Play();
    TweenService:Create(u32, v54, {
        TextTransparency = v56
    }):Play();
    local v57 = u33 and u33:FindFirstChild("QuickChatIcon");

    if v57 then
        TweenService:Create(v57, v54, {
            TextTransparency = v56
        }):Play();
    end;

    if u38 then
        local v58 = p53 and 0 or 1;
        TweenService:Create(u38, v54, {
            BackgroundTransparency = 1
        }):Play();

        if u37 then
            TweenService:Create(u37, v54, {
                BackgroundTransparency = v58,
                TextTransparency = v56
            }):Play();
            local v59 = u37:FindFirstChildOfClass("UIStroke");

            if v59 then
                TweenService:Create(v59, v54, {
                    Transparency = v58
                }):Play();
            end;
        end;

        local CooldownTimer = u38:FindFirstChild("CooldownTimer");

        if CooldownTimer then
            TweenService:Create(CooldownTimer, v54, {
                TextTransparency = v56
            }):Play();
        end;
    end;

    TweenService:Create(u40, v54, {
        TextTransparency = v56
    }):Play();
    TweenService:Create(u42, v54, {
        TextTransparency = v56
    }):Play();
    TweenService:Create(u41, v54, {
        BackgroundTransparency = v56
    }):Play();
    TweenService:Create(u43, v54, {
        BackgroundTransparency = v56
    }):Play();
    TweenService:Create(u44, v54, {
        BackgroundTransparency = p53 and 0.3 or 1
    }):Play();
end;

local function TweenContent(p60) -- Line: 213
    -- upvalues: TweenService (copy), u24 (ref)
    TweenService:Create(u24, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        GroupTransparency = p60 and 0 or 1
    }):Play();
end;

local function ShowAll() -- Line: 219
    -- upvalues: TweenChrome (copy), TweenContent (copy)
    TweenChrome(true);
    TweenContent(true);
end;

local function StartIdleTimers() -- Line: 225
    -- upvalues: u13 (ref), u11 (ref), u12 (ref), TweenChrome (copy), TweenContent (copy)
    u13 = u13 + 1;
    local u61 = u13;
    task.delay(4, function() -- Line: 230
        -- upvalues: u61 (copy), u13 (ref), u11 (ref), u12 (ref), TweenChrome (ref)
        if u61 == u13 and not (u11 or u12) then
            TweenChrome(false);
        end;
    end);
    task.delay(15, function() -- Line: 237
        -- upvalues: u61 (copy), u13 (ref), u11 (ref), u12 (ref), TweenContent (ref)
        if u61 == u13 and not (u11 or u12) then
            TweenContent(false);
        end;
    end);
end;

local function Wake() -- Line: 245
    -- upvalues: u13 (ref), TweenChrome (copy), TweenContent (copy), StartIdleTimers (copy)
    u13 = u13 + 1;
    TweenChrome(true);
    TweenContent(true);
    StartIdleTimers();
end;

local function FeedAvailable() -- Line: 252
    -- upvalues: GuildFeedFlags (copy)
    return GuildFeedFlags.GuildFeedEnabled:Get();
end;

local function GiftCooldownEndsAt() -- Line: 257
    -- upvalues: LocalPlayer (copy)
    return tonumber(LocalPlayer:GetAttribute("GiftRequestReadyAt")) or 0;
end;

local function IsOnGiftCooldown() -- Line: 262
    -- upvalues: LocalPlayer (copy), ServerClock (copy)
    return (tonumber(LocalPlayer:GetAttribute("GiftRequestReadyAt")) or 0) - ServerClock.Now() > 0;
end;

local function FormatCooldown(p62) -- Line: 269
    local v63 = math.floor(p62);
    local v64 = math.max(0, v63);
    local v65 = math.floor(v64 / 3600);
    local v66 = math.floor(v64 % 3600 / 60);
    local v67 = v64 % 60;
    local v68 = {};

    if v65 > 0 then
        table.insert(v68, v65 .. "h");
    end;

    if v66 > 0 then
        table.insert(v68, v66 .. "m");
    end;

    if v67 > 0 then
        table.insert(v68, v67 .. "s");
    end;

    return #v68 == 0 and "0s" or table.concat(v68, " ");
end;

local function PromptGiftCooldownReset() -- Line: 286
    -- upvalues: DevProductController (copy)
    if not DevProductController then
        return;
    end;

    local v69, v70 = DevProductController:PromptPurchase("Guild:Gift Cooldown Reset:1");

    if not v69 then
        warn("Gift cooldown reset prompt failed: " .. tostring(v70));
    end;
end;

local function RefreshRequestButton() -- Line: 299
    -- upvalues: u37 (ref), LocalPlayer (copy), u36 (ref), u48 (ref), u38 (ref), u39 (ref), ServerClock (copy), GuildCardUI (copy), FormatCooldown (copy)
    if not u37 then
        return;
    end;

    local v71 = LocalPlayer:GetAttribute("GuildId") ~= nil;
    local v72;

    if u36 == nil then
        v72 = false;
    else
        v72 = u36.Visible;
    end;

    local v73 = v71 and (v72 and u48) and LocalPlayer:GetAttribute("GiftRequestReadyAt") ~= nil;
    u38.Visible = v73;

    if u39 then
        u39.Visible = not v71 and v72;
    end;

    if not v73 then
        return;
    end;

    u38.BackgroundTransparency = 1;
    local v74 = (tonumber(LocalPlayer:GetAttribute("GiftRequestReadyAt")) or 0) - ServerClock.Now() > 0;
    local v75 = GuildCardUI:HasOwnRequest();
    local v76 = v74 or v75;
    local v77;

    if v76 then
        v77 = Color3.fromRGB(255, 152, 48);
    else
        v77 = Color3.fromRGB(66, 163, 61);
    end;

    u37.BackgroundColor3 = v77;
    local v78 = u37:FindFirstChildOfClass("UIStroke");

    if v78 then
        local v79;

        if v76 then
            v79 = Color3.fromRGB(122, 72, 23);
        else
            v79 = Color3.fromRGB(40, 90, 38);
        end;

        v78.Color = v79;
    end;

    local CooldownTimer = u38:FindFirstChild("CooldownTimer");

    if CooldownTimer then
        if v74 then
            CooldownTimer.Visible = true;
            CooldownTimer.Text = "Can request a gift in " .. FormatCooldown((tonumber(LocalPlayer:GetAttribute("GiftRequestReadyAt")) or 0) - ServerClock.Now());
        else
            CooldownTimer.Visible = false;
        end;
    end;

    if v74 then
        u37.Text = "Reset";

        return;
    end;

    if v75 then
        u37.Text = "Requested";

        return;
    end;

    u37.Text = "Request";
end;

local function SelectTab(p80) -- Line: 353
    -- upvalues: GuildFeedFlags (copy), u47 (ref), u10 (ref), u45 (ref), u27 (ref), u36 (ref), u40 (ref), u5 (copy), u4 (copy), u42 (ref), u41 (ref), u43 (ref), RefreshRequestButton (copy)
    local v81 = p80 == "Guild" and not GuildFeedFlags.GuildFeedEnabled:Get() and "Here" or p80;
    u47 = v81;
    local v82 = v81 == "Here";

    if v82 and (u10 and u45) then
        u45:clearNotices();
    end;

    u27.Visible = v82;
    u36.Visible = not v82;
    u40.TextColor3 = v82 and u5 or u4;
    u42.TextColor3 = v82 and u4 or u5;
    u41.Visible = v82;
    u43.Visible = not v82;
    RefreshRequestButton();
end;

local function UpdateTabBar() -- Line: 379
    -- upvalues: GuildFeedFlags (copy), u42 (ref), u44 (ref), u40 (ref), u47 (ref), SelectTab (copy)
    local v83 = GuildFeedFlags.GuildFeedEnabled:Get();
    u42.Visible = v83;
    u44.Visible = v83;

    if v83 then
        u40.Size = UDim2.new(0.5, 0, 1, 0);

        return;
    end;

    u40.Size = UDim2.new(1, 0, 1, 0);

    if u47 == "Guild" then
        SelectTab("Here");
    end;
end;

local function BuildPrefix(p84, p85) -- Line: 396
    -- upvalues: u7 (copy)
    local v86 = p84.PrefixText or "";

    if p85 and p85.HasVerifiedBadge then
        local v87, v88 = v86:gsub(":</font>", u7 .. ":</font>");

        if v88 > 0 then
            return v87;
        end;

        v86 = v86 .. u7;
    end;

    return v86;
end;

local function BuildLineText(p89, p90) -- Line: 413
    -- upvalues: u7 (copy), TextChatService (copy)
    local v91 = p89.PrefixText or "";
    local v92;

    if p90 and p90.HasVerifiedBadge then
        local v93;
        v92, v93 = v91:gsub(":</font>", u7 .. ":</font>");

        if v93 <= 0 then
            v92 = v91 .. u7;
        end;
    else
        v92 = v91;
    end;

    local Text = p89.Text;

    if TextChatService.ChatTranslationEnabled and (p89.Translation and p89.Translation ~= "") then
        Text = p89.Translation;
    end;

    return v92 .. (p89.PrefixText and p89.PrefixText ~= "" and " " or "") .. Text;
end;

local function PruneLines() -- Line: 427
    -- upvalues: u18 (copy), u17 (copy)
    while #u18 > 100 do
        local v94 = table.remove(u18, 1);

        if v94 then
            local v95 = v94:GetAttribute("MessageId");

            if v95 then
                u17[v95] = nil;
            end;

            v94:Destroy();
        end;
    end;
end;

local function IsNearBottom() -- Line: 442
    -- upvalues: u28 (ref)
    return u28.AbsoluteCanvasSize.Y - u28.AbsoluteWindowSize.Y - u28.CanvasPosition.Y < 40;
end;

local function ScrollToLatest() -- Line: 448
    -- upvalues: u28 (ref)
    task.defer(function() -- Line: 449
        -- upvalues: u28 (ref)
        if u28 and u28.Parent then
            u28.CanvasPosition = Vector2.new(0, (math.max(0, u28.AbsoluteCanvasSize.Y - u28.AbsoluteWindowSize.Y)));
        end;
    end);
end;

local function AddHereLine(p96) -- Line: 458
    -- upvalues: Players (copy), u28 (ref), u17 (copy), u7 (copy), TextChatService (copy), u16 (ref), u18 (copy), ChatWindowConfiguration (copy), LocalPlayer (copy), u14 (ref), TextService (copy), PruneLines (copy)
    local TextSource = p96.TextSource;

    if TextSource then
        TextSource = Players:GetPlayerByUserId(TextSource.UserId);
    end;

    local v97 = u28.AbsoluteCanvasSize.Y - u28.AbsoluteWindowSize.Y - u28.CanvasPosition.Y < 40;
    local MessageId = p96.MessageId;
    local v98;

    if MessageId then
        v98 = u17[MessageId];
    else
        v98 = MessageId;
    end;

    if v98 then
        local Text = v98:FindFirstChild("Text");

        if Text then
            local v99 = p96.PrefixText or "";
            local v100;

            if TextSource and TextSource.HasVerifiedBadge then
                local v101;
                v100, v101 = v99:gsub(":</font>", u7 .. ":</font>");

                if v101 <= 0 then
                    v100 = v99 .. u7;
                end;
            else
                v100 = v99;
            end;

            local Text2 = p96.Text;

            if TextChatService.ChatTranslationEnabled and (p96.Translation and p96.Translation ~= "") then
                Text2 = p96.Translation;
            end;

            Text.Text = v100 .. (p96.PrefixText and p96.PrefixText ~= "" and " " or "") .. Text2;
        end;

        return;
    end;

    u16 = u16 + 1;
    local Frame = Instance.new("Frame");
    Frame.Name = "Line";
    Frame.BackgroundTransparency = 1;
    Frame.Size = UDim2.new(1, 0, 0, 0);
    Frame.AutomaticSize = Enum.AutomaticSize.Y;
    Frame.LayoutOrder = u16;
    Frame.Parent = u28;

    if MessageId then
        Frame:SetAttribute("MessageId", MessageId);
        u17[MessageId] = Frame;
    end;

    table.insert(u18, Frame);
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Text";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(1, 0, 0, 0);
    TextLabel.AutomaticSize = Enum.AutomaticSize.Y;
    TextLabel.RichText = true;
    TextLabel.TextWrapped = true;
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top;
    TextLabel.FontFace = ChatWindowConfiguration.FontFace;
    TextLabel.TextSize = ChatWindowConfiguration.TextSize;
    TextLabel.TextColor3 = ChatWindowConfiguration.TextColor3;
    TextLabel.TextStrokeColor3 = ChatWindowConfiguration.TextStrokeColor3;
    TextLabel.TextStrokeTransparency = ChatWindowConfiguration.TextStrokeTransparency;
    local v102 = p96.PrefixText or "";
    local v103;

    if TextSource and TextSource.HasVerifiedBadge then
        local v104;
        v103, v104 = v102:gsub(":</font>", u7 .. ":</font>");

        if v104 <= 0 then
            v103 = v102 .. u7;
        end;
    else
        v103 = v102;
    end;

    local Text = p96.Text;

    if TextChatService.ChatTranslationEnabled and (p96.Translation and p96.Translation ~= "") then
        Text = p96.Translation;
    end;

    TextLabel.Text = v103 .. (p96.PrefixText and p96.PrefixText ~= "" and " " or "") .. Text;
    TextLabel.Parent = Frame;

    if TextSource and TextSource ~= LocalPlayer then
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "NameHit";
        TextButton.BackgroundTransparency = 1;
        TextButton.Text = "";
        TextButton.Position = UDim2.new(0, 0, 0, 0);
        TextButton.Size = UDim2.new(0, 40, 0, ChatWindowConfiguration.TextSize + 4);
        TextButton.Parent = Frame;
        TextButton.MouseButton1Click:Connect(function() -- Line: 525
            -- upvalues: u14 (ref), TextSource (copy)
            if u14 then
                u14(TextSource.DisplayName);
            end;
        end);
        task.spawn(function() -- Line: 532
            -- upvalues: TextSource (copy), ChatWindowConfiguration (ref), TextService (ref), TextButton (copy)
            local GetTextBoundsParams = Instance.new("GetTextBoundsParams");
            GetTextBoundsParams.Text = TextSource.DisplayName .. ":";
            GetTextBoundsParams.Font = ChatWindowConfiguration.FontFace;
            GetTextBoundsParams.Size = ChatWindowConfiguration.TextSize;
            GetTextBoundsParams.Width = (1 / 0);
            local success, result = pcall(function() -- Line: 538
                -- upvalues: TextService (ref), GetTextBoundsParams (copy)
                return TextService:GetTextBoundsAsync(GetTextBoundsParams);
            end);

            if success and (result and TextButton.Parent) then
                TextButton.Size = UDim2.new(0, result.X + 4, 0, result.Y + 2);
            end;
        end);
    end;

    PruneLines();

    if v97 then
        task.defer(function() -- Line: 449
            -- upvalues: u28 (ref)
            if u28 and u28.Parent then
                u28.CanvasPosition = Vector2.new(0, (math.max(0, u28.AbsoluteCanvasSize.Y - u28.AbsoluteWindowSize.Y)));
            end;
        end);
    end;
end;

local function StyledMutation(p105) -- Line: 557
    -- upvalues: MutationData (copy)
    local v106 = MutationData.GetMutation(p105);

    if v106 then
        v106 = v106.Gradient;
    end;

    if not (v106 and v106:IsA("UIGradient")) then
        return p105;
    end;

    local Keypoints = v106.Color.Keypoints;
    local v107 = math.ceil(#Keypoints / 2);
    local Value = Keypoints[math.max(1, v107)].Value;

    return "<font color=\"" .. string.format("#%02X%02X%02X", math.floor(Value.R * 255 + 0.5), math.floor(Value.G * 255 + 0.5), (math.floor(Value.B * 255 + 0.5))) .. "\">" .. p105 .. "</font>";
end;

local function BuildShowcaseSubtitle(p108) -- Line: 579
    -- upvalues: WeightFormat (copy), StyledMutation (copy)
    local v109 = {};
    local v110 = p108.Category == "HarvestedFruits" and tonumber(p108.Weight);

    if v110 then
        table.insert(v109, WeightFormat.FormatGrams(v110));
    end;

    if typeof(p108.Mutation) == "string" and p108.Mutation ~= "" then
        local v111 = StyledMutation(p108.Mutation);
        table.insert(v109, v111);
    end;

    local v112 = tonumber(p108.Count);

    if v112 and v112 > 1 then
        table.insert(v109, "x" .. v112);
    end;

    return table.concat(v109, " - ");
end;

local function AddShowcaseLine(u113) -- Line: 608
    -- upvalues: u28 (ref), ReplicatedStorage (copy), u16 (ref), Players (copy), GuildCardUI (copy), BuildShowcaseSubtitle (copy), u18 (copy), PruneLines (copy)
    if not (u28 and u28.Parent) then
        return false;
    end;

    if typeof(u113.Text) ~= "string" or u113.Text == "" then
        return false;
    end;

    local u114 = tonumber(u113.UserId);

    if not u114 then
        return false;
    end;

    local Assets = ReplicatedStorage:FindFirstChild("Assets");

    if Assets then
        Assets = Assets:FindFirstChild("GuildCardTemplates");
    end;

    if Assets then
        Assets = Assets:FindFirstChild("AccomplishmentCard");
    end;

    if not Assets then
        return false;
    end;

    local v115 = u28.AbsoluteCanvasSize.Y - u28.AbsoluteWindowSize.Y - u28.CanvasPosition.Y < 40;
    local v116 = Assets:Clone();
    v116.Name = "Showcase";
    u16 = u16 + 1;
    v116.LayoutOrder = u16;
    local Box = v116.Box;
    local Reactions = v116:FindFirstChild("Reactions");

    if Reactions then
        Reactions:Destroy();
    end;

    local ReactionRow = Box:FindFirstChild("ReactionRow");

    if ReactionRow then
        ReactionRow:Destroy();
    end;

    local Join = Box:FindFirstChild("Join");

    if Join then
        Join:Destroy();
    end;

    Box.Size = UDim2.new(1, 0, 0, 84);
    Box.Subject.Size = UDim2.new(0, 64, 0, 64);
    Box.Subject.Position = UDim2.new(1, 0, 0.5, 0);
    Box.Info.Size = UDim2.new(1, -142, 0, 52);
    Box.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. u114 .. "&w=150&h=150";
    Box.Info.Text = "<font color=\"" .. "#BEC6BE" .. "\">" .. u113.Text .. "</font>";
    local v117 = Players:GetPlayerByUserId(u114);

    if v117 then
        Box.Info.Text = "<b>" .. v117.DisplayName .. "</b> <font color=\"" .. "#BEC6BE" .. "\">" .. u113.Text .. "</font>";
    else
        task.spawn(function() -- Line: 664
            -- upvalues: Players (ref), u114 (copy), Box (copy), u113 (copy)
            local success, result = pcall(function() -- Line: 665
                -- upvalues: Players (ref), u114 (ref)
                return Players:GetNameFromUserIdAsync(u114);
            end);

            if success and (result and (Box.Info and Box.Info.Parent)) then
                Box.Info.Text = "<b>" .. result .. "</b> <font color=\"" .. "#BEC6BE" .. "\">" .. u113.Text .. "</font>";
            end;
        end);
    end;

    local v118 = GuildCardUI:GetItemImage(u113.ItemKey, u113.Category, u113.Size);

    if v118 then
        Box.Subject.Image = v118;
        Box.Subject.Visible = true;
        local v119;

        if typeof(u113.DisplayName) == "string" and u113.DisplayName ~= "" then
            v119 = u113.DisplayName;
        else
            v119 = tostring(u113.ItemKey or "");
        end;

        Box.Subject:SetAttribute("ItemToolTip", v119);
        Box.Subject:SetAttribute("ItemToolTipImage", v118);
        Box.Subject:SetAttribute("ItemToolTipRarity", typeof(u113.Rarity) ~= "string" and "" or u113.Rarity);
        Box.Subject:SetAttribute("ItemToolTipSubtitle", BuildShowcaseSubtitle(u113));
    else
        Box.Subject.Visible = false;
    end;

    v116.Parent = u28;
    table.insert(u18, v116);
    PruneLines();

    if v115 then
        task.defer(function() -- Line: 449
            -- upvalues: u28 (ref)
            if u28 and u28.Parent then
                u28.CanvasPosition = Vector2.new(0, (math.max(0, u28.AbsoluteCanvasSize.Y - u28.AbsoluteWindowSize.Y)));
            end;
        end);
    end;

    return true;
end;

local function ClearDropdown() -- Line: 708
    -- upvalues: u35 (ref)
    for _, child in pairs(u35:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy();
        end;
    end;
end;

local function AddDropdownRow(p120, p121, p122) -- Line: 717
    -- upvalues: ChatWindowConfiguration (copy), u35 (ref)
    local TextButton = Instance.new("TextButton");
    TextButton.BackgroundColor3 = Color3.fromRGB(52, 58, 54);
    TextButton.BackgroundTransparency = 1;
    TextButton.Size = UDim2.new(1, 0, 0, 30);
    TextButton.AutoButtonColor = false;
    TextButton.FontFace = ChatWindowConfiguration.FontFace;
    TextButton.TextSize = 15;
    TextButton.TextColor3 = Color3.fromRGB(236, 238, 236);
    TextButton.TextXAlignment = Enum.TextXAlignment.Left;
    TextButton.LayoutOrder = p121;
    TextButton.Text = p120;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 6);
    UICorner.Parent = TextButton;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingLeft = UDim.new(0, 10);
    UIPadding.PaddingRight = UDim.new(0, 10);
    UIPadding.Parent = TextButton;
    TextButton.Parent = u35;
    TextButton.MouseEnter:Connect(function() -- Line: 739
        -- upvalues: TextButton (copy)
        TextButton.BackgroundTransparency = 0.2;
    end);
    TextButton.MouseLeave:Connect(function() -- Line: 742
        -- upvalues: TextButton (copy)
        TextButton.BackgroundTransparency = 1;
    end);
    TextButton.MouseButton1Click:Connect(p122);

    return TextButton;
end;

local function ShowWhisperTargets() -- Line: 751
    -- upvalues: ClearDropdown (copy), Players (copy), LocalPlayer (copy), AddDropdownRow (copy), u14 (ref), u34 (ref)
    ClearDropdown();
    local v123 = 0;

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            v123 = v123 + 1;
            AddDropdownRow(v.DisplayName, v123, function() -- Line: 760
                -- upvalues: u14 (ref), v (copy)
                if u14 then
                    u14(v.DisplayName);
                end;
            end);
        end;
    end;

    u34.Visible = v123 > 0;
end;

local function ShowCommands(p124) -- Line: 770
    -- upvalues: ClearDropdown (copy), u46 (copy), AddDropdownRow (copy), u30 (ref), u34 (ref)
    ClearDropdown();
    local v125 = 0;

    for _, v in pairs(u46) do
        local v126 = string.sub(v.Primary, 1, #p124) == p124;
        local v127;

        if v.Secondary == "" then
            v127 = false;
        else
            v127 = string.sub(v.Secondary, 1, #p124) == p124;
        end;

        if v126 or v127 then
            v125 = v125 + 1;
            AddDropdownRow(v.Primary, v125, function() -- Line: 779
                -- upvalues: u30 (ref), v (copy)
                u30.Text = v.Primary .. " ";
                u30:CaptureFocus();
                u30.CursorPosition = #u30.Text + 1;
            end);
        end;
    end;

    u34.Visible = v125 > 0;
end;

local function SendMessage() -- Line: 790
    -- upvalues: u30 (ref), u34 (ref), TextChatService (copy)
    local Text = u30.Text;

    if Text == "" then
        return;
    end;

    u30.Text = "";
    u34.Visible = false;
    task.spawn(function() -- Line: 798
        -- upvalues: TextChatService (ref), Text (copy)
        local TextChannels = TextChatService:FindFirstChild("TextChannels");

        if TextChannels then
            TextChannels = TextChannels:FindFirstChild("RBXGeneral");
        end;

        if TextChannels then
            TextChannels:SendAsync(Text);
        end;
    end);
end;

local function ShowQuickChat() -- Line: 808
    -- upvalues: ClearDropdown (copy), u8 (copy), AddDropdownRow (copy), u34 (ref), u30 (ref), TextChatService (copy)
    ClearDropdown();

    for i, v in ipairs(u8) do
        AddDropdownRow(v, i, function() -- Line: 811
            -- upvalues: u34 (ref), u30 (ref), v (copy), TextChatService (ref)
            u34.Visible = false;
            u30.Text = v;
            local Text = u30.Text;

            if Text == "" then
                return;
            end;

            u30.Text = "";
            u34.Visible = false;
            task.spawn(function() -- Line: 798
                -- upvalues: TextChatService (ref), Text (copy)
                local TextChannels = TextChatService:FindFirstChild("TextChannels");

                if TextChannels then
                    TextChannels = TextChannels:FindFirstChild("RBXGeneral");
                end;

                if TextChannels then
                    TextChannels:SendAsync(Text);
                end;
            end);
        end);
    end;

    u34.Visible = true;
end;

local function FlushReactions() -- Line: 821
    -- upvalues: u20 (ref), u19 (ref), Networking (copy)
    u20 = false;

    if #u19 == 0 then
        return;
    end;

    local v128 = u19;
    u19 = {};
    Networking.GuildFeed.React:Fire(v128);
end;

local function LoadFeed() -- Line: 833
    -- upvalues: GuildFeedFlags (copy), Networking (copy), GuildCardUI (copy), u48 (ref), RefreshRequestButton (copy)
    if not GuildFeedFlags.GuildFeedEnabled:Get() then
        return;
    end;

    task.spawn(function() -- Line: 837
        -- upvalues: Networking (ref), GuildCardUI (ref), u48 (ref), RefreshRequestButton (ref)
        local success, result = pcall(function() -- Line: 838
            -- upvalues: Networking (ref)
            return Networking.GuildFeed.GetFeed:Fire();
        end);

        if success and result then
            GuildCardUI:RenderFeed(result);
            u48 = true;
            RefreshRequestButton();
        end;
    end);
end;

local function ShouldShowMessage(p129) -- Line: 850
    local TextChannel = p129.TextChannel;

    if not TextChannel then
        return false;
    end;

    local Name = TextChannel.Name;

    return Name == "RBXGeneral" or (Name == "RBXSystem" or (string.find(Name, "Whisper", 1, true) ~= nil or string.find(Name, "Team", 1, true) ~= nil));
end;

local function OnMessageReceived(p130) -- Line: 864
    -- upvalues: ShouldShowMessage (copy), u10 (ref), u47 (ref), u45 (ref), u9 (ref), u15 (ref), AddHereLine (copy), u13 (ref), TweenChrome (copy), TweenContent (copy), StartIdleTimers (copy)
    if not ShouldShowMessage(p130) then
        return;
    end;

    local v131;

    if u10 == true then
        v131 = u47 == "Here";
    else
        v131 = false;
    end;

    if not v131 and u45 then
        u45:notify();
    end;

    if not u9 then
        table.insert(u15, p130);

        if #u15 > 50 then
            table.remove(u15, 1);
        end;

        return;
    end;

    AddHereLine(p130);
    u13 = u13 + 1;
    TweenChrome(true);
    TweenContent(true);
    StartIdleTimers();
end;

local function BuildWindow() -- Line: 887
    -- upvalues: ChatWindowConfiguration (copy), ChatInputBarConfiguration (copy), StarterGui (copy), LocalPlayer (copy), u22 (ref), PlayerGui (copy), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u27 (ref), u28 (ref), u29 (ref), u33 (ref), u2 (copy), u6 (copy), u30 (ref), u31 (ref), u32 (ref), u34 (ref), u35 (ref), u36 (ref), GuildCardUI (copy), ReplicatedStorage (copy), u38 (ref), u37 (ref), ServerClock (copy), DevProductController (copy), u39 (ref), u4 (copy), u3 (copy), u40 (ref), u41 (ref), u42 (ref), u43 (ref), u44 (ref), u45 (ref), topbarplus (copy)
    ChatWindowConfiguration.Enabled = false;
    ChatInputBarConfiguration.Enabled = false;
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
    LocalPlayer:SetAttribute("CustomChatActive", true);
    u22 = Instance.new("ScreenGui");
    u22.Name = "GuildChat";
    u22.ResetOnSpawn = false;
    u22.IgnoreGuiInset = false;
    u22.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
    u22.Parent = PlayerGui;
    u23 = Instance.new("Frame");
    u23.Name = "Window";
    u23.BackgroundColor3 = ChatWindowConfiguration.BackgroundColor3;
    u23.BackgroundTransparency = ChatWindowConfiguration.BackgroundTransparency;
    u23.Size = UDim2.new(0.4, 0, 0.3, 0);
    u23.Position = UDim2.new(0, 8, 0, 4);
    u23.BorderSizePixel = 0;
    local UICorner = Instance.new("UICorner");
    UICorner.CornerRadius = UDim.new(0, 8);
    UICorner.Parent = u23;
    u23.Parent = u22;
    local UISizeConstraint = Instance.new("UISizeConstraint");
    UISizeConstraint.MinSize = Vector2.new(200, 150);
    UISizeConstraint.MaxSize = Vector2.new(475, 360);
    UISizeConstraint.Parent = u23;
    u24 = Instance.new("CanvasGroup");
    u24.Name = "ContentGroup";
    u24.BackgroundTransparency = 1;
    u24.Size = UDim2.new(1, 0, 1, 0);
    u24.BorderSizePixel = 0;
    u24.GroupTransparency = 0;
    u24.Parent = u23;
    u25 = Instance.new("Frame");
    u25.Name = "TabBar";
    u25.BackgroundTransparency = 1;
    u25.Size = UDim2.new(1, 0, 0, 40);
    u25.Parent = u24;
    u26 = Instance.new("Frame");
    u26.Name = "Content";
    u26.BackgroundTransparency = 1;
    u26.Position = UDim2.new(0, 0, 0, 40);
    u26.Size = UDim2.new(1, 0, 1, -40);
    u26.Parent = u24;
    u27 = Instance.new("Frame");
    u27.Name = "HerePanel";
    u27.BackgroundTransparency = 1;
    u27.Size = UDim2.new(1, 0, 1, 0);
    u27.Parent = u26;
    u28 = Instance.new("ScrollingFrame");
    u28.Name = "Messages";
    u28.BackgroundTransparency = 1;
    u28.BorderSizePixel = 0;
    u28.Position = UDim2.new(0, 10, 0, 4);
    u28.Size = UDim2.new(1, -20, 1, -52);
    u28.ScrollBarThickness = 4;
    u28.CanvasSize = UDim2.new(0, 0, 0, 0);
    u28.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    u28.Parent = u27;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.Padding = UDim.new(0, 2);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = u28;
    u29 = Instance.new("Frame");
    u29.Name = "InputBar";
    u29.BackgroundColor3 = ChatInputBarConfiguration.BackgroundColor3;
    u29.BackgroundTransparency = ChatInputBarConfiguration.BackgroundTransparency;
    u29.AnchorPoint = Vector2.new(0.5, 1);
    u29.Position = UDim2.new(0.5, 0, 1, -8);
    u29.Size = UDim2.new(1, -20, 0, 38);
    u29.BorderSizePixel = 0;
    local UICorner2 = Instance.new("UICorner");
    UICorner2.CornerRadius = UDim.new(0, 8);
    UICorner2.Parent = u29;
    u29.Parent = u27;
    u33 = Instance.new("TextButton");
    u33.Name = "QuickChatButton";
    u33.BackgroundTransparency = 1;
    u33.AnchorPoint = Vector2.new(0, 0.5);
    u33.Position = UDim2.new(0, 4, 0.5, 0);
    u33.Size = UDim2.new(0, 30, 0, 30);
    u33.Text = "";
    u33.AutoButtonColor = false;
    u33.Parent = u29;
    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "QuickChatIcon";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.Size = UDim2.new(1, 0, 1, 0);
    TextLabel.FontFace = u2;
    TextLabel.Text = "speech-bubble-text";
    TextLabel.TextSize = 22;
    TextLabel.TextColor3 = u6;
    TextLabel.Parent = u33;
    u30 = Instance.new("TextBox");
    u30.Name = "TextBox";
    u30.BackgroundTransparency = 1;
    u30.Position = UDim2.new(0, 38, 0, 0);
    u30.Size = UDim2.new(1, -76, 1, 0);
    u30.FontFace = ChatInputBarConfiguration.FontFace;
    u30.TextSize = ChatInputBarConfiguration.TextSize;
    u30.TextColor3 = ChatInputBarConfiguration.TextColor3;
    u30.PlaceholderText = "Type a message...";
    u30.PlaceholderColor3 = ChatInputBarConfiguration.PlaceholderColor3;
    u30.Text = "";
    u30.ClearTextOnFocus = false;
    u30.TextXAlignment = Enum.TextXAlignment.Left;
    u30.Parent = u29;
    u31 = Instance.new("TextButton");
    u31.Name = "SendButton";
    u31.BackgroundTransparency = 1;
    u31.AnchorPoint = Vector2.new(1, 0.5);
    u31.Position = UDim2.new(1, -6, 0.5, 0);
    u31.Size = UDim2.new(0, 30, 0, 30);
    u31.Text = "";
    u31.AutoButtonColor = false;
    u31.Parent = u29;
    u32 = Instance.new("TextLabel");
    u32.Name = "SendIcon";
    u32.BackgroundTransparency = 1;
    u32.Size = UDim2.new(1, 0, 1, 0);
    u32.FontFace = u2;
    u32.Text = "paper-airplane";
    u32.TextSize = 24;
    u32.TextColor3 = u6;
    u32.Parent = u31;
    u34 = Instance.new("Frame");
    u34.Name = "Dropdown";
    u34.BackgroundColor3 = Color3.fromRGB(28, 31, 34);
    u34.AnchorPoint = Vector2.new(0.5, 1);
    u34.Position = UDim2.new(0.5, 0, 1, -48);
    u34.Size = UDim2.new(1, -20, 0, 0);
    u34.Visible = false;
    u34.BorderSizePixel = 0;
    local UICorner3 = Instance.new("UICorner");
    UICorner3.CornerRadius = UDim.new(0, 10);
    UICorner3.Parent = u34;
    u34.Parent = u27;
    local UIStroke = Instance.new("UIStroke");
    UIStroke.Color = Color3.fromRGB(64, 70, 66);
    UIStroke.Thickness = 1;
    UIStroke.Transparency = 0.3;
    UIStroke.Parent = u34;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingTop = UDim.new(0, 5);
    UIPadding.PaddingBottom = UDim.new(0, 5);
    UIPadding.PaddingLeft = UDim.new(0, 5);
    UIPadding.PaddingRight = UDim.new(0, 5);
    UIPadding.Parent = u34;
    u35 = Instance.new("ScrollingFrame");
    u35.Name = "Scroll";
    u35.BackgroundTransparency = 1;
    u35.BorderSizePixel = 0;
    u35.Size = UDim2.new(1, 0, 1, 0);
    u35.CanvasSize = UDim2.new(0, 0, 0, 0);
    u35.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    u35.ScrollBarThickness = 3;
    u35.Parent = u34;
    local UIListLayout2 = Instance.new("UIListLayout");
    UIListLayout2.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout2.Padding = UDim.new(0, 2);
    UIListLayout2.Parent = u35;
    UIListLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 1090
        -- upvalues: UIListLayout2 (copy), u34 (ref)
        local v132 = math.min(UIListLayout2.AbsoluteContentSize.Y, 126);
        u34.Size = UDim2.new(1, -20, 0, v132 + 10);
    end);
    u36 = Instance.new("Frame");
    u36.Name = "GuildPanel";
    u36.BackgroundTransparency = 1;
    u36.Size = UDim2.new(1, 0, 1, 0);
    u36.Visible = false;
    u36.Parent = u26;
    GuildCardUI:MountFeed(u36);
    local RequestBar = ReplicatedStorage.Assets.GuildCardTemplates:FindFirstChild("RequestBar");

    if RequestBar then
        u38 = RequestBar:Clone();
        u38.Visible = false;
        u38.Parent = u36;
        u37 = u38:FindFirstChild("RequestButton");

        if u37 then
            u37.MouseButton1Click:Connect(function() -- Line: 1125
                -- upvalues: LocalPlayer (ref), ServerClock (ref), DevProductController (ref), GuildCardUI (ref), PlayerGui (ref)
                if LocalPlayer:GetAttribute("GuildId") == nil then
                    return;
                end;

                if (tonumber(LocalPlayer:GetAttribute("GiftRequestReadyAt")) or 0) - ServerClock.Now() > 0 then
                    if not DevProductController then
                        return;
                    end;

                    local v133, v134 = DevProductController:PromptPurchase("Guild:Gift Cooldown Reset:1");

                    if not v133 then
                        warn("Gift cooldown reset prompt failed: " .. tostring(v134));
                    end;

                    return;
                end;

                if GuildCardUI:HasOwnRequest() then
                    return;
                end;

                local CreateGiftRequest = PlayerGui:FindFirstChild("CreateGiftRequest");

                if CreateGiftRequest then
                    CreateGiftRequest.Enabled = true;
                end;
            end);
        end;
    end;

    u39 = Instance.new("TextLabel");
    u39.Name = "EmptyState";
    u39.BackgroundTransparency = 1;
    u39.AnchorPoint = Vector2.new(0.5, 0.5);
    u39.Position = UDim2.new(0.5, 0, 0.5, 0);
    u39.Size = UDim2.new(1, -60, 0, 100);
    u39.FontFace = ChatWindowConfiguration.FontFace;
    u39.Text = "Join a guild to request seeds, share achievements with friends, and compete globally for ultra rare prizes!";
    u39.TextSize = 16;
    u39.TextColor3 = u4;
    u39.TextWrapped = true;
    u39.Visible = false;
    u39.Parent = u36;

    local function CreateTab(p135, p136) -- Line: 1163
        -- upvalues: ChatWindowConfiguration (ref), u4 (ref), u25 (ref), u3 (ref)
        local TextButton = Instance.new("TextButton");
        TextButton.Name = "Tab_" .. p135;
        TextButton.BackgroundTransparency = 1;
        TextButton.Size = UDim2.new(0.5, 0, 1, 0);
        TextButton.Position = UDim2.new(0.5 * (p136 - 1), 0, 0, 0);
        TextButton.FontFace = ChatWindowConfiguration.FontFace;
        TextButton.TextSize = 18;
        TextButton.TextColor3 = u4;
        TextButton.Text = p135;
        TextButton.AutoButtonColor = false;
        TextButton.Parent = u25;
        local Frame = Instance.new("Frame");
        Frame.Name = "Underline";
        Frame.BackgroundColor3 = u3;
        Frame.AnchorPoint = Vector2.new(0.5, 1);
        Frame.Position = UDim2.new(0.5, 0, 1, 0);
        Frame.Size = UDim2.new(0.7, 0, 0, 3);
        Frame.BorderSizePixel = 0;
        Frame.Visible = false;
        Frame.Parent = TextButton;

        return TextButton, Frame;
    end;

    local v137, v138 = CreateTab("Here", 1);
    u40 = v137;
    u41 = v138;
    local v139, v140 = CreateTab("Guild", 2);
    u42 = v139;
    u43 = v140;
    u44 = Instance.new("Frame");
    u44.Name = "Divider";
    u44.AnchorPoint = Vector2.new(0.5, 0.5);
    u44.Position = UDim2.new(0.5, 0, 0.5, 0);
    u44.Size = UDim2.new(0, 1, 0, 20);
    u44.BackgroundColor3 = Color3.fromRGB(90, 98, 90);
    u44.BackgroundTransparency = 0.3;
    u44.BorderSizePixel = 0;
    u44.Parent = u25;
    u45 = topbarplus.new();
    u45:setImage("rbxasset://textures/ui/TopBar/chatOff.png", "deselected");
    u45:setImage("rbxasset://textures/ui/TopBar/chatOn.png", "selected");
    u45:setName("GuildChatIcon");
    u45:setImageScale(0.55);
    u45:setOrder(-1);
    u45:setCaption("Open the chat.");
    u45:setEnabled(true);
    u45.deselectWhenOtherIconSelected = false;
    u23.BackgroundColor3 = ChatWindowConfiguration.BackgroundColor3;
    u23.BackgroundTransparency = ChatWindowConfiguration.BackgroundTransparency;
    u29.BackgroundColor3 = ChatInputBarConfiguration.BackgroundColor3;
    u29.BackgroundTransparency = ChatInputBarConfiguration.BackgroundTransparency;
    u30.FontFace = ChatInputBarConfiguration.FontFace;
    u30.TextSize = ChatInputBarConfiguration.TextSize;
    u30.TextColor3 = ChatInputBarConfiguration.TextColor3;
    u30.PlaceholderColor3 = ChatInputBarConfiguration.PlaceholderColor3;
end;

local function WireWindow() -- Line: 1227
    -- upvalues: ChatWindowConfiguration (copy), ApplyConfig (copy), ChatInputBarConfiguration (copy), u40 (ref), SelectTab (copy), u42 (ref), GuildFeedFlags (copy), Networking (copy), GuildCardUI (copy), u48 (ref), RefreshRequestButton (copy), UpdateTabBar (copy), LocalPlayer (copy), u38 (ref), ServerClock (copy), u23 (ref), u11 (ref), u13 (ref), TweenChrome (copy), TweenContent (copy), StartIdleTimers (copy), u30 (ref), u12 (ref), u34 (ref), TextChatService (copy), u31 (ref), u33 (ref), ShowQuickChat (copy), u46 (copy), u21 (ref), ShowWhisperTargets (copy), ShowCommands (copy), u14 (ref), u10 (ref), u45 (ref), u47 (ref), ContextActionService (copy), u19 (ref), GuildFeedData (copy), u20 (ref), FlushReactions (copy)
    for _, v in pairs({ "BackgroundColor3", "BackgroundTransparency", "FontFace", "TextColor3", "TextSize" }) do
        ChatWindowConfiguration:GetPropertyChangedSignal(v):Connect(ApplyConfig);
        ChatInputBarConfiguration:GetPropertyChangedSignal(v):Connect(ApplyConfig);
    end;

    u40.MouseButton1Click:Connect(function() -- Line: 1235
        -- upvalues: SelectTab (ref)
        SelectTab("Here");
    end);
    u42.MouseButton1Click:Connect(function() -- Line: 1238
        -- upvalues: SelectTab (ref), GuildFeedFlags (ref), Networking (ref), GuildCardUI (ref), u48 (ref), RefreshRequestButton (ref)
        SelectTab("Guild");

        if not GuildFeedFlags.GuildFeedEnabled:Get() then
            return;
        end;

        task.spawn(function() -- Line: 837
            -- upvalues: Networking (ref), GuildCardUI (ref), u48 (ref), RefreshRequestButton (ref)
            local success, result = pcall(function() -- Line: 838
                -- upvalues: Networking (ref)
                return Networking.GuildFeed.GetFeed:Fire();
            end);

            if success and result then
                GuildCardUI:RenderFeed(result);
                u48 = true;
                RefreshRequestButton();
            end;
        end);
    end);
    UpdateTabBar();
    GuildFeedFlags.GuildFeedEnabled.Changed:Connect(function() -- Line: 1248
        -- upvalues: UpdateTabBar (ref)
        UpdateTabBar();
    end);
    task.spawn(function() -- Line: 1251
        -- upvalues: GuildFeedFlags (ref), UpdateTabBar (ref)
        GuildFeedFlags.GuildFeedEnabled:GetAsync();
        UpdateTabBar();
    end);
    LocalPlayer:GetAttributeChangedSignal("GuildId"):Connect(function() -- Line: 1258
        -- upvalues: GuildCardUI (ref), u48 (ref), LocalPlayer (ref), GuildFeedFlags (ref), Networking (ref), RefreshRequestButton (ref)
        GuildCardUI:Clear();
        u48 = false;

        if LocalPlayer:GetAttribute("GuildId") ~= nil and GuildFeedFlags.GuildFeedEnabled:Get() then
            task.spawn(function() -- Line: 837
                -- upvalues: Networking (ref), GuildCardUI (ref), u48 (ref), RefreshRequestButton (ref)
                local success, result = pcall(function() -- Line: 838
                    -- upvalues: Networking (ref)
                    return Networking.GuildFeed.GetFeed:Fire();
                end);

                if success and result then
                    GuildCardUI:RenderFeed(result);
                    u48 = true;
                    RefreshRequestButton();
                end;
            end);
        end;

        RefreshRequestButton();
    end);
    LocalPlayer:GetAttributeChangedSignal("GiftRequestReadyAt"):Connect(function() -- Line: 1273
        -- upvalues: RefreshRequestButton (ref)
        RefreshRequestButton();
    end);
    task.spawn(function() -- Line: 1278
        -- upvalues: u38 (ref), LocalPlayer (ref), ServerClock (ref), RefreshRequestButton (ref)
        local v141 = false;

        while true do
            task.wait(1);
            local v142;

            if u38 and u38.Visible then
                v142 = (tonumber(LocalPlayer:GetAttribute("GiftRequestReadyAt")) or 0) - ServerClock.Now() > 0;

                if v142 or v141 then
                    RefreshRequestButton();
                end;
            else
                v142 = v141;
            end;

            v141 = v142;
        end;
    end);
    u23.MouseEnter:Connect(function() -- Line: 1293
        -- upvalues: u11 (ref), u13 (ref), TweenChrome (ref), TweenContent (ref)
        u11 = true;
        u13 = u13 + 1;
        TweenChrome(true);
        TweenContent(true);
    end);
    u23.MouseLeave:Connect(function() -- Line: 1298
        -- upvalues: u11 (ref), StartIdleTimers (ref)
        u11 = false;
        StartIdleTimers();
    end);
    u30.Focused:Connect(function() -- Line: 1302
        -- upvalues: u12 (ref), u13 (ref), TweenChrome (ref), TweenContent (ref)
        u12 = true;
        u13 = u13 + 1;
        TweenChrome(true);
        TweenContent(true);
    end);
    u30.FocusLost:Connect(function(p143) -- Line: 1309
        -- upvalues: u12 (ref), StartIdleTimers (ref), u30 (ref), u34 (ref), TextChatService (ref)
        u12 = false;
        StartIdleTimers();

        if p143 then
            local Text = u30.Text;

            if Text == "" then
                return;
            end;

            u30.Text = "";
            u34.Visible = false;
            task.spawn(function() -- Line: 798
                -- upvalues: TextChatService (ref), Text (copy)
                local TextChannels = TextChatService:FindFirstChild("TextChannels");

                if TextChannels then
                    TextChannels = TextChannels:FindFirstChild("RBXGeneral");
                end;

                if TextChannels then
                    TextChannels:SendAsync(Text);
                end;
            end);
        end;
    end);
    u31.MouseButton1Click:Connect(function() -- Line: 1316
        -- upvalues: u30 (ref), u34 (ref), TextChatService (ref)
        local Text = u30.Text;

        if Text == "" then
            return;
        end;

        u30.Text = "";
        u34.Visible = false;
        task.spawn(function() -- Line: 798
            -- upvalues: TextChatService (ref), Text (copy)
            local TextChannels = TextChatService:FindFirstChild("TextChannels");

            if TextChannels then
                TextChannels = TextChannels:FindFirstChild("RBXGeneral");
            end;

            if TextChannels then
                TextChannels:SendAsync(Text);
            end;
        end);
    end);
    u33.MouseButton1Click:Connect(function() -- Line: 1321
        -- upvalues: u34 (ref), ShowQuickChat (ref)
        if u34.Visible then
            u34.Visible = false;

            return;
        end;

        ShowQuickChat();
    end);

    for _, descendant in pairs(TextChatService:GetDescendants()) do
        if descendant:IsA("TextChatCommand") and descendant.Enabled then
            table.insert(u46, {
                Primary = descendant.PrimaryAlias,
                Secondary = descendant.SecondaryAlias
            });
        end;
    end;

    u30:GetPropertyChangedSignal("Text"):Connect(function() -- Line: 1337
        -- upvalues: u21 (ref), u30 (ref), ShowWhisperTargets (ref), ShowCommands (ref), u34 (ref)
        if u21 then
            u21 = false;

            if u30.Text == "/" then
                u30.Text = "";

                return;
            end;
        end;

        local Text = u30.Text;

        if Text == "/w " or Text == "/whisper " then
            ShowWhisperTargets();

            return;
        end;

        if string.sub(Text, 1, 1) == "/" and not string.find(Text, " ", 1, true) then
            ShowCommands(Text);

            return;
        end;

        u34.Visible = false;
    end);

    u14 = function(p144) -- Line: 1364
        -- upvalues: u10 (ref), u23 (ref), SelectTab (ref), u45 (ref), u34 (ref), u30 (ref)
        u10 = true;
        u23.Visible = true;
        SelectTab("Here");

        if u45 then
            if u10 and not u45.isSelected then
                u45:select("GuildChat", u45);
            elseif not u10 and u45.isSelected then
                u45:deselect("GuildChat", u45);
            end;
        end;

        u34.Visible = false;
        u30.Text = "/w " .. p144 .. " ";
        u30:CaptureFocus();
        u30.CursorPosition = #u30.Text + 1;
    end;

    u45.selected:Connect(function() -- Line: 1379
        -- upvalues: u10 (ref), u23 (ref), u47 (ref), u45 (ref), u13 (ref), TweenChrome (ref), TweenContent (ref), StartIdleTimers (ref)
        if u10 then
            return;
        end;

        u10 = true;
        u23.Visible = true;

        if u47 == "Here" and u45 then
            u45:clearNotices();
        end;

        u13 = u13 + 1;
        TweenChrome(true);
        TweenContent(true);
        StartIdleTimers();
    end);
    u45.deselected:Connect(function() -- Line: 1391
        -- upvalues: u10 (ref), u23 (ref)
        if not u10 then
            return;
        end;

        u10 = false;
        u23.Visible = false;
    end);
    ContextActionService:BindActionAtPriority("GuildChatSlash", function(p145, p146) -- Line: 1417, Name: OnSlash
        -- upvalues: u30 (ref), u10 (ref), u23 (ref), SelectTab (ref), u45 (ref), u13 (ref), TweenChrome (ref), TweenContent (ref), StartIdleTimers (ref), u21 (ref)
        if p146 ~= Enum.UserInputState.Begin then
            return Enum.ContextActionResult.Pass;
        end;

        if u30:IsFocused() then
            return Enum.ContextActionResult.Pass;
        end;

        u10 = true;
        u23.Visible = true;
        SelectTab("Here");

        if u45 then
            if u10 and not u45.isSelected then
                u45:select("GuildChat", u45);
            elseif not u10 and u45.isSelected then
                u45:deselect("GuildChat", u45);
            end;
        end;

        u13 = u13 + 1;
        TweenChrome(true);
        TweenContent(true);
        StartIdleTimers();
        u30.Text = "";
        u21 = true;
        task.defer(function() -- Line: 1438
            -- upvalues: u30 (ref)
            u30:CaptureFocus();
        end);

        return Enum.ContextActionResult.Sink;
    end, false, Enum.ContextActionPriority.High.Value, Enum.KeyCode.Slash);

    function GuildCardUI.OnReact(p147, p148, p149) -- Line: 1454
        -- upvalues: u19 (ref), GuildFeedData (ref), u20 (ref), Networking (ref), FlushReactions (ref)
        table.insert(u19, {
            Seq = p147,
            Emoji = p148,
            Added = p149
        });

        if GuildFeedData.Batching.Enabled then
            if u20 then
                return;
            end;

            u20 = true;
            task.delay(GuildFeedData.Batching.ReactionFlushSeconds, FlushReactions);

            return;
        end;

        u20 = false;

        if #u19 == 0 then
            return;
        end;

        local v150 = u19;
        u19 = {};
        Networking.GuildFeed.React:Fire(v150);
    end;

    function GuildCardUI.OnJoin(u151) -- Line: 1471
        -- upvalues: Networking (ref)
        task.spawn(function() -- Line: 1472
            -- upvalues: Networking (ref), u151 (copy)
            local v152, v153, v154 = pcall(function() -- Line: 1473
                -- upvalues: Networking (ref), u151 (ref)
                return Networking.GuildFeed.TeleportTo:Fire(u151);
            end);

            if v152 and v153 then
                return;
            end;

            local v155 = v152 and v154 and v154 or "Failed";
            local v156 = v155 == "Offline" and "They changed servers - try again in a moment!" or (v155 == "SameServer" and "They\'re already on your server!" or (v155 == "InHunt" and "They\'re on a Pet Hunt - can\'t join mid-hunt!" or (v155 == "OtherWorld" and "They\'re in another world - travel there first!" or (v155 == "Cooldown" and "Hold on a moment before joining again." or "Couldn\'t join their server - try again!"))));
            local success, result = pcall(function() -- Line: 1493
                return require(script.Parent.NotificationController);
            end);

            if success and result then
                result:CreateNotification(v156);
            end;
        end);
    end;

    function GuildCardUI.OnBlockedDonate(p157, p158) -- Line: 1503
        local v159;

        if p157 == "NoItems" then
            v159 = "You don\'t have any " .. tostring(p158 or "of that") .. " to send!";
        elseif p157 == "OtherWorld" then
            v159 = "This request is from another world - donate there!";
        else
            if p157 ~= "Done" then
                return;
            end;

            v159 = "This request has already been filled!";
        end;

        local success, result = pcall(function() -- Line: 1514
            return require(script.Parent.NotificationController);
        end);

        if success and result then
            result:CreateNotification(v159);
        end;
    end;

    function GuildCardUI.OnDonate(u160, u161) -- Line: 1523
        -- upvalues: Networking (ref)
        task.spawn(function() -- Line: 1524
            -- upvalues: Networking (ref), u160 (copy), u161 (copy)
            local v162, v163, v164 = pcall(function() -- Line: 1525
                -- upvalues: Networking (ref), u160 (ref), u161 (ref)
                return Networking.GuildFeed.Donate:Fire(tostring(u160), u161);
            end);

            if v162 and v163 then
                return;
            end;

            local v165 = v162 and v164 and v164 or "Failed";
            local v166 = v165 == "Locked" and "Gifting isn\'t available right now." or (v165 == "PersonalCap" and "You\'ve already given as much as you can to this request!" or (v165 == "WrongWorld" and "This request is from another world - donate there!" or ((v165 == "Done" or (v165 == "Expired" or v165 == "NoRequest")) and "This request has already been filled!" or (v165 == "Cooldown" and "Hold on a moment between donations." or ((typeof(v165) ~= "string" or #v165 <= 12) and "Couldn\'t send that - try again!" or v165)))));
            local success, result = pcall(function() -- Line: 1545
                return require(script.Parent.NotificationController);
            end);

            if success and result then
                result:CreateNotification(v166);
            end;
        end);
    end;

    Networking.GuildFeed.Update.OnClientEvent:Connect(function(p167) -- Line: 1555
        -- upvalues: GuildCardUI (ref), RefreshRequestButton (ref)
        if typeof(p167) ~= "table" then
            return;
        end;

        if p167.Kind ~= "Snapshot" then
            if p167.Kind == "Delta" and typeof(p167.Changes) == "table" then
                for _, v in pairs(p167.Changes) do
                    if v.Kind == "Post" then
                        GuildCardUI:AddPost(v.Post);
                        RefreshRequestButton();
                    elseif v.Kind == "Reaction" then
                        GuildCardUI:ApplyReaction(v.Seq, v.UserId, v.Mask or 0);
                    elseif v.Kind == "GiftProgress" then
                        GuildCardUI:ApplyGiftProgress(v.Seq, v.Progress or 0, v.Done == true, v.By);
                    end;
                end;
            end;

            return;
        end;

        GuildCardUI:RenderFeed(p167.Row);
        RefreshRequestButton();
    end);
    SelectTab("Here");
    u23.Visible = u10;

    if u45 then
        if u10 and not u45.isSelected then
            u45:select("GuildChat", u45);
        elseif not u10 and u45.isSelected then
            u45:deselect("GuildChat", u45);
        end;
    end;

    u13 = u13 + 1;
    TweenChrome(true);
    TweenContent(true);
    StartIdleTimers();
end;

local function Activate() -- Line: 1589
    -- upvalues: u9 (ref), BuildWindow (copy), WireWindow (copy), u15 (ref), AddHereLine (copy), StarterGui (copy)
    if u9 then
        return;
    end;

    u9 = true;
    BuildWindow();
    WireWindow();
    local v168 = u15;
    u15 = {};

    for _, v in ipairs(v168) do
        AddHereLine(v);
    end;

    task.spawn(function() -- Line: 1607
        -- upvalues: StarterGui (ref)
        while true do
            pcall(function() -- Line: 1609
                -- upvalues: StarterGui (ref)
                if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
                    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false);
                end;
            end);
            task.wait(0.5);
        end;
    end);
end;

function v1.Init(p169) -- Line: 1621
end;

function v1.Start(p170) -- Line: 1624
    -- upvalues: TextChatService (copy), OnMessageReceived (copy), ItemShowcasePackets (copy), u9 (ref), AddShowcaseLine (copy), u10 (ref), u47 (ref), u45 (ref), u13 (ref), TweenChrome (copy), TweenContent (copy), StartIdleTimers (copy), Players (copy), GuildFeedFlags (copy), Activate (copy)
    TextChatService.MessageReceived:Connect(OnMessageReceived);
    ItemShowcasePackets.Showcase.OnClientEvent:Connect(function(p171) -- Line: 1631
        -- upvalues: u9 (ref), AddShowcaseLine (ref), u10 (ref), u47 (ref), u45 (ref), u13 (ref), TweenChrome (ref), TweenContent (ref), StartIdleTimers (ref), Players (ref), TextChatService (ref)
        if typeof(p171) ~= "table" then
            return;
        end;

        if u9 and AddShowcaseLine(p171) then
            local v172;

            if u10 == true then
                v172 = u47 == "Here";
            else
                v172 = false;
            end;

            if not v172 and u45 then
                u45:notify();
            end;

            u13 = u13 + 1;
            TweenChrome(true);
            TweenContent(true);
            StartIdleTimers();

            return;
        end;

        local Text = p171.Text;

        if typeof(Text) ~= "string" or Text == "" then
            return;
        end;

        local v173 = tonumber(p171.UserId);

        if not v173 then
            return;
        end;

        local v174 = Players:GetPlayerByUserId(v173);
        local v175 = v174 and v174.DisplayName or "User " .. v173;
        local TextChannels = TextChatService:FindFirstChild("TextChannels");

        if TextChannels then
            TextChannels = TextChannels:FindFirstChild("RBXGeneral");
        end;

        if TextChannels then
            TextChannels:DisplaySystemMessage("<b>" .. v175 .. "</b> " .. Text);
        end;
    end);

    if GuildFeedFlags.ChatEnabled:Get() then
        Activate();

        return;
    end;

    GuildFeedFlags.ChatEnabled.Changed:Connect(function(p176) -- Line: 1669
        -- upvalues: Activate (ref)
        if p176 then
            Activate();
        end;
    end);
    task.spawn(function() -- Line: 1676
        -- upvalues: GuildFeedFlags (ref), Activate (ref)
        if GuildFeedFlags.ChatEnabled:GetAsync() then
            Activate();
        end;
    end);
end;

return v1;