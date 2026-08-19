-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local EggData = require(ReplicatedStorage.SharedModules.EggData);
local GuildFeedData = require(ReplicatedStorage.SharedModules.GuildFeedData);
local NumberUtils = require(ReplicatedStorage.SharedModules.NumberUtils);
local PetData = require(ReplicatedStorage.SharedData.PetData);
local SeedData = require(ReplicatedStorage.SharedModules.SeedData);
local GiftRequestCatalog = require(ReplicatedStorage.ClientModules.GiftRequestCatalog);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local RarityVisuals = require(ReplicatedStorage.SharedModules.RarityVisuals);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local u1 = nil;

local function GetPlayerStateClient() -- Line: 25
    -- upvalues: u1 (ref), ReplicatedStorage (copy)
    if not u1 then
        local success, result = pcall(function() -- Line: 27
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.ClientModules.PlayerStateClient);
        end);

        if success then
            u1 = result;
        end;
    end;

    return u1;
end;

local LocalPlayer = Players.LocalPlayer;
local GuildCardTemplates = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("GuildCardTemplates");
local u2 = Color3.fromRGB(70, 112, 70);
local u3 = {
    Feed = nil,
    OnReact = nil,
    OnJoin = nil,
    OnDonate = nil,
    OnBlockedDonate = nil
};
local u4 = {};
local u5 = 0;
local u6 = {};
local u7 = {};

local function GetHeadshot(p8) -- Line: 80
    return "rbxthumb://type=AvatarHeadShot&id=" .. p8 .. "&w=150&h=150";
end;

local function RelativeTime(p9) -- Line: 85
    -- upvalues: ServerClock (copy)
    local v10 = ServerClock.Now();
    local v11 = v10 - (tonumber(p9) or v10);
    local v12 = v11 < 0 and 0 or v11;

    if v12 < 60 then
        return "just now";
    end;

    local v13 = math.floor(v12 / 60);

    if v13 < 60 then
        return v13 .. "m ago";
    end;

    local v14 = math.floor(v12 / 3600);

    if v14 < 24 then
        return v14 .. "h ago";
    end;

    local v15 = math.floor(v12 / 86400);

    if v15 < 7 then
        return v15 .. "d ago";
    end;

    return math.floor(v12 / 604800) .. "w ago";
end;

local function AttachTimestamp(p16, p17, p18) -- Line: 116
    -- upvalues: RelativeTime (copy)
    local v19 = p16:FindFirstChild("Box") or p16;
    local Timestamp = v19:FindFirstChild("Timestamp");

    if Timestamp then
        Timestamp.Text = RelativeTime(p17);
        Timestamp:SetAttribute("At", p17);

        return Timestamp;
    end;

    local TextLabel = Instance.new("TextLabel");
    TextLabel.Name = "Timestamp";
    TextLabel.BackgroundTransparency = 1;
    TextLabel.AnchorPoint = Vector2.new(1, 0);
    TextLabel.Position = UDim2.new(1, -10, 0, 2 + (p18 or 0));
    TextLabel.Size = UDim2.new(0, 90, 0, 14);
    TextLabel.ZIndex = 20;
    TextLabel.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal);
    TextLabel.Text = RelativeTime(p17);
    TextLabel.TextSize = 15;
    TextLabel.TextColor3 = Color3.fromRGB(150, 156, 150);
    TextLabel.TextXAlignment = Enum.TextXAlignment.Right;
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center;
    TextLabel:SetAttribute("At", p17);
    TextLabel.Parent = v19;

    return TextLabel;
end;

local function NextOrder() -- Line: 150
    -- upvalues: u5 (ref)
    u5 = u5 + 1;

    return u5;
end;

local function IsNearBottom(p20) -- Line: 158
    if p20 then
        return p20.AbsoluteCanvasSize.Y - p20.AbsoluteWindowSize.Y - p20.CanvasPosition.Y < 40;
    end;

    return false;
end;

local function FetchName(u21, u22) -- Line: 165
    -- upvalues: u6 (copy), Players (copy)
    local v23 = u6[u21];

    if v23 then
        u22(v23);

        return;
    end;

    local v24 = Players:GetPlayerByUserId(u21);

    if not v24 then
        task.spawn(function() -- Line: 182
            -- upvalues: Players (ref), u21 (copy), u6 (ref), u22 (copy)
            local success, result = pcall(function() -- Line: 183
                -- upvalues: Players (ref), u21 (ref)
                return Players:GetNameFromUserIdAsync(u21);
            end);
            local v25 = success and result and result or "User " .. u21;
            u6[u21] = v25;
            u22(v25);
        end);

        return;
    end;

    u6[u21] = v24.DisplayName;
    u22(v24.DisplayName);
end;

local function GetItemImage(u26) -- Line: 195
    -- upvalues: u7 (copy), SeedData (copy), PetData (copy), EggData (copy), ReplicatedStorage (copy)
    if not u26 or u26 == "" then
        return nil;
    end;

    local v27 = u7[u26];

    if v27 then
        return v27;
    end;

    for _, v in pairs(SeedData) do
        if v.SeedName == u26 then
            local v28 = v.FruitImage and v.FruitImage.Value;

            if typeof(v28) == "string" and v28 ~= "" then
                u7[u26] = v28;

                return v28;
            end;

            break;
        end;
    end;

    local v29 = PetData[u26];

    if typeof(v29) ~= "table" then
        v29 = PetData[string.gsub(u26, "%s+", "")];
    end;

    if typeof(v29) ~= "table" then
        for _, v in pairs(PetData) do
            if typeof(v) == "table" and v.DisplayName == u26 then
                v29 = v;
                break;
            end;
        end;
    end;

    if typeof(v29) == "table" then
        local Image = v29.Image;

        if typeof(Image) == "string" and Image ~= "" then
            u7[u26] = Image;

            return Image;
        end;
    end;

    local success, result = pcall(function() -- Line: 242
        -- upvalues: EggData (ref), u26 (copy)
        return EggData.GetData(u26);
    end);

    if success and (typeof(result) == "table" and (typeof(result.IMG) == "string" and result.IMG ~= "")) then
        u7[u26] = result.IMG;

        return result.IMG;
    end;

    local GearImages = ReplicatedStorage.SharedModules:FindFirstChild("GearImages");

    if GearImages then
        GearImages = GearImages:FindFirstChild(u26);
    end;

    if not GearImages or (not GearImages:IsA("StringValue") or GearImages.Value == "") then
        return nil;
    end;

    u7[u26] = GearImages.Value;

    return GearImages.Value;
end;

function u3.GetItemImage(p30, u31, p32, u33) -- Line: 269
    -- upvalues: SeedData (copy), PetData (copy), GetItemImage (copy)
    if not u31 or u31 == "" then
        return nil;
    end;

    if p32 == "Seeds" then
        for _, v in pairs(SeedData) do
            if v.SeedName == u31 then
                local v34 = v.SeedImage and v.SeedImage.Value;

                if typeof(v34) == "string" and v34 ~= "" then
                    return v34;
                end;

                break;
            end;
        end;
    elseif p32 == "Pets" and (u33 and u33 ~= "") then
        local success, result = pcall(function() -- Line: 284
            -- upvalues: PetData (ref), u31 (copy), u33 (copy)
            return PetData.GetImage(u31, u33);
        end);

        if success and (typeof(result) == "string" and result ~= "") then
            return result;
        end;
    end;

    return GetItemImage(u31);
end;

local function BuildActionText(u35) -- Line: 296
    -- upvalues: GuildFeedData (copy), NumberUtils (copy), Worlds (copy), PetData (copy), RarityVisuals (copy)
    local u36, v37 = GuildFeedData.GetKindById(u35.Kind);

    if not v37 then
        return "";
    end;

    local Detail = u35.Detail;
    local u38;

    if u36 == "BigSale" and typeof(Detail) == "number" then
        u38 = NumberUtils.Abbreviate(Detail, 2) .. Worlds.Current.CurrencySuffix;
    elseif typeof(Detail) == "number" then
        local v39 = math.floor(Detail * 100 + 0.5) / 100;
        u38 = tostring(v39);
    else
        u38 = tostring(Detail or "");
    end;

    local v40 = string.gsub(v37.Text, "{Detail}", function() -- Line: 318
        -- upvalues: u38 (ref)
        return u38;
    end);
    local v44 = string.gsub(v40, "{Item}", function() -- Line: 321
        -- upvalues: u35 (copy), u36 (copy), PetData (ref), RarityVisuals (ref)
        local v41 = tostring(u35.ItemKey or "");
        local v42 = u36 == "FoundPet" and PetData[v41];

        if not v42 then
            return v41;
        end;

        local v43 = v42.DisplayName or v41;
        local Rarity = v42.Rarity;

        if Rarity then
            return RarityVisuals.RichText(v43, Rarity);
        end;

        return v43;
    end);

    return string.gsub(v44, "{a}(.*)$", function(p45) -- Line: 348
        local v46 = string.gsub(p45, "<.->", "");
        local v47 = string.lower(string.match(v46, "%a[%a\']*") or "");
        local v48 = string.lower(string.match(v46, "%a") or "");

        return (string.find("aeiou", v48, 1, true) and not ({
            unicorn = true
        })[v47] and "an" or "a") .. p45;
    end);
end;

local function GetReactionKey(p49, p50) -- Line: 374
    return "React_" .. p49 .. "_" .. p50;
end;

local function AddReactorRow(p51, p52, p53) -- Line: 379
    -- upvalues: GuildCardTemplates (copy), FetchName (copy)
    local v54 = "React_" .. p52 .. "_" .. p53;

    if p51:FindFirstChild(v54) then
        return;
    end;

    local u55 = GuildCardTemplates.ReactorRow:Clone();
    u55.Name = v54;
    u55.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. p52 .. "&w=150&h=150";
    u55.Emoji.Text = p53;
    u55.PlayerName.Text = "";
    u55.Parent = p51;
    FetchName(p52, function(p56) -- Line: 393
        -- upvalues: u55 (copy)
        if u55.Parent then
            u55.PlayerName.Text = p56;
        end;
    end);
end;

local function RemoveReactorRow(p57, p58, p59) -- Line: 401
    local v60 = p57:FindFirstChild("React_" .. p58 .. "_" .. p59);

    if v60 then
        v60:Destroy();
    end;
end;

local function ApplyMask(p61, p62, p63) -- Line: 409
    -- upvalues: GuildFeedData (copy), AddReactorRow (copy)
    for i, v in ipairs(GuildFeedData.Reactions.Emojis) do
        local v64 = bit32.lshift(1, i - 1);

        if bit32.band(p63, v64) == 0 then
            local v65 = p61:FindFirstChild("React_" .. p62 .. "_" .. v);

            if v65 then
                v65:Destroy();
            end;
        else
            AddReactorRow(p61, p62, v);
        end;
    end;
end;

local u66 = false;

local function StartTimestampRefresh() -- Line: 422
    -- upvalues: u66 (ref), u3 (copy), RelativeTime (copy)
    if u66 then
        return;
    end;

    u66 = true;
    task.spawn(function() -- Line: 427
        -- upvalues: u3 (ref), RelativeTime (ref)
        while true do
            local v67;

            repeat
                task.wait(30);
                v67 = u3.Feed;
            until v67;

            for _, child in pairs(v67:GetChildren()) do
                if child:IsA("GuiObject") then
                    local Timestamp = child:FindFirstChild("Timestamp");

                    if Timestamp then
                        local v68 = Timestamp:GetAttribute("At");

                        if v68 then
                            Timestamp.Text = RelativeTime(v68);
                        end;
                    end;
                end;
            end;
        end;
    end);
end;

local function ReorderCards() -- Line: 451
    -- upvalues: u3 (copy)
    local Feed = u3.Feed;

    if not Feed then
        return;
    end;

    local v69 = {};

    for _, child in pairs(Feed:GetChildren()) do
        if child:IsA("GuiObject") then
            local v70 = child:GetAttribute("Seq");

            if v70 then
                table.insert(v69, {
                    Card = child,
                    Seq = v70
                });
            end;
        end;
    end;

    table.sort(v69, function(p71, p72) -- Line: 463
        return p71.Seq < p72.Seq;
    end);

    for i, v in ipairs(v69) do
        v.Card.LayoutOrder = i;
    end;
end;

function u3.MountFeed(p73, p74) -- Line: 470
    -- upvalues: u66 (ref), u3 (copy), RelativeTime (copy)
    local ScrollingFrame = Instance.new("ScrollingFrame");
    ScrollingFrame.Name = "Feed";
    ScrollingFrame.BackgroundTransparency = 1;
    ScrollingFrame.BorderSizePixel = 0;
    ScrollingFrame.Size = UDim2.new(1, 0, 1, -45);
    ScrollingFrame.ScrollBarThickness = 4;
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
    ScrollingFrame.Parent = p74;
    local UIPadding = Instance.new("UIPadding");
    UIPadding.PaddingTop = UDim.new(0, 10);
    UIPadding.PaddingBottom = UDim.new(0, 10);
    UIPadding.PaddingLeft = UDim.new(0, 10);
    UIPadding.PaddingRight = UDim.new(0, 10);
    UIPadding.Parent = ScrollingFrame;
    local UIListLayout = Instance.new("UIListLayout");
    UIListLayout.FillDirection = Enum.FillDirection.Vertical;
    UIListLayout.Padding = UDim.new(0, 10);
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder;
    UIListLayout.Parent = ScrollingFrame;
    p73.Feed = ScrollingFrame;

    if u66 then
        return ScrollingFrame;
    end;

    u66 = true;
    task.spawn(function() -- Line: 427
        -- upvalues: u3 (ref), RelativeTime (ref)
        while true do
            local v75;

            repeat
                task.wait(30);
                v75 = u3.Feed;
            until v75;

            for _, child in pairs(v75:GetChildren()) do
                if child:IsA("GuiObject") then
                    local Timestamp = child:FindFirstChild("Timestamp");

                    if Timestamp then
                        local v76 = Timestamp:GetAttribute("At");

                        if v76 then
                            Timestamp.Text = RelativeTime(v76);
                        end;
                    end;
                end;
            end;
        end;
    end);

    return ScrollingFrame;
end;

function u3.ScrollToBottom(p77) -- Line: 503
    -- upvalues: TweenService (copy)
    if not p77.Feed then
        return;
    end;

    local Feed = p77.Feed;
    task.spawn(function() -- Line: 509
        -- upvalues: Feed (copy), TweenService (ref)
        if not (Feed and Feed.Parent) then
            return;
        end;

        game:GetService("RunService").Heartbeat:Wait();

        if not (Feed and Feed.Parent) then
            return;
        end;

        local v78 = math.max(0, Feed.AbsoluteCanvasSize.Y - Feed.AbsoluteWindowSize.Y);
        TweenService:Create(Feed, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            CanvasPosition = Vector2.new(0, v78 - 2)
        }):Play();
    end);
end;

function u3.Clear(p79) -- Line: 522
    -- upvalues: u4 (copy), u5 (ref)
    if not p79.Feed then
        return;
    end;

    for _, child in pairs(p79.Feed:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy();
        end;
    end;

    table.clear(u4);
    u5 = 0;
end;

function u3.RemovePost(p80, p81) -- Line: 536
    -- upvalues: u4 (copy)
    local v82 = u4[p81];

    if not v82 then
        return;
    end;

    if v82.Instance then
        v82.Instance:Destroy();
    end;

    u4[p81] = nil;
end;

local function IsGiftCancelled(p83, p84, p85) -- Line: 549
    local v86;

    if p83 == true and p85 > 0 then
        v86 = p84 < p85;
    else
        v86 = false;
    end;

    return v86;
end;

local function OwnedCount(u87, u88) -- Line: 555
    -- upvalues: u1 (ref), ReplicatedStorage (copy)
    if not (u87 and u88) then
        return 0;
    end;

    if not u1 then
        local success, result = pcall(function() -- Line: 27
            -- upvalues: ReplicatedStorage (ref)
            return require(ReplicatedStorage.ClientModules.PlayerStateClient);
        end);

        if success then
            u1 = result;
        end;
    end;

    local u89 = u1;

    if not u89 then
        return 0;
    end;

    local success, result = pcall(function() -- Line: 559
        -- upvalues: u89 (copy), u87 (copy), u88 (copy)
        local v90 = u89:GetLocalReplica();
        local v91 = v90 and v90.Data and v90.Data.Inventory;

        if v91 then
            v91 = v91[u87];
        end;

        if v91 then
            v91 = v91[u88];
        end;

        return v91;
    end);

    return success and tonumber(result) or 0;
end;

local function AddGiftCard(p92, u93) -- Line: 570
    -- upvalues: GuildFeedData (copy), ServerClock (copy), GuildCardTemplates (copy), u5 (ref), Worlds (copy), FetchName (copy), GiftRequestCatalog (copy), GetItemImage (copy), RarityVisuals (copy), LocalPlayer (copy), u1 (ref), ReplicatedStorage (copy), u3 (copy), AttachTimestamp (copy), u4 (copy), ReorderCards (copy)
    local Gift = u93.Gift;

    if typeof(Gift) ~= "table" then
        return;
    end;

    local u94 = tonumber(Gift.Goal) or 0;

    if Gift.Done == true then
        return;
    end;

    local RequestTtlSeconds = GuildFeedData.Gifting.RequestTtlSeconds;

    if RequestTtlSeconds and (u93.At and RequestTtlSeconds <= ServerClock.Now() - u93.At) then
        return;
    end;

    local Feed = p92.Feed;
    local v95;

    if Feed then
        v95 = Feed.AbsoluteCanvasSize.Y - Feed.AbsoluteWindowSize.Y - Feed.CanvasPosition.Y < 40;
    else
        v95 = false;
    end;

    local u96 = GuildCardTemplates.GiftingCard:Clone();
    u96.Name = "Post_" .. u93.Seq;
    u96:SetAttribute("Seq", u93.Seq);
    u5 = u5 + 1;
    u96.LayoutOrder = u5;
    local Box = u96.Box;
    Box.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. u93.UserId .. "&w=150&h=150";
    Box.PlayerName.Text = "";
    local u97 = "";
    local v98;

    if typeof(Gift.WorldId) == "string" then
        v98 = Gift.WorldId;
    else
        v98 = nil;
    end;

    if v98 then
        local v99 = Worlds.Worlds[v98];
        local v100;

        if v99 then
            v100 = v99.DisplayName;
        else
            v100 = v98;
        end;

        u97 = ` (in {v100})`;
    end;

    FetchName(u93.UserId, function(p101) -- Line: 612
        -- upvalues: u96 (copy), Box (copy), u97 (ref)
        if not u96.Parent then
            return;
        end;

        local PlayerName = Box:FindFirstChild("PlayerName");

        if not PlayerName then
            return;
        end;

        PlayerName.Text = p101 .. u97;
    end);
    local v102 = Gift.ItemKey or u93.ItemKey;
    local v103 = GiftRequestCatalog.GetImageForKey(Gift.Category, v102) or GetItemImage(v102);

    if v103 then
        Box.ItemIcon.Image = v103;
        Box.ItemIcon.Visible = true;
    else
        Box.ItemIcon.Visible = false;
    end;

    Box.GoalAmount.Text = "x" .. u94;
    local v104 = Gift.ItemKey or (u93.ItemKey or "");

    if Box.Wants then
        Box.Wants.RichText = true;
        local v105 = GiftRequestCatalog.GetRarityForKey(Gift.Category, v104);
        local v106;

        if v105 then
            v106 = RarityVisuals.RichText(v104, v105);
        else
            v106 = "<font color=\"#5CE65C\">" .. v104 .. "</font>";
        end;

        Box.Wants.Text = "is requesting " .. v106;
    end;

    local u107 = 1;
    local DefaultPerPersonCap = GuildFeedData.Gifting.DefaultPerPersonCap;
    local u108 = u93.UserId == LocalPlayer.UserId;
    local u109 = v98 == nil and true or v98 == Worlds.CurrentId;
    local u110 = Gift.Done == true;

    local function MyDonated() -- Line: 661
        -- upvalues: Gift (copy), LocalPlayer (ref)
        local By = Gift.By;

        if typeof(By) ~= "table" then
            return 0;
        end;

        local v111 = By[tostring(LocalPlayer.UserId)];

        return tonumber(v111) or 0;
    end;

    local function IsMaxedOut() -- Line: 668
        -- upvalues: Gift (copy), LocalPlayer (ref), GuildFeedData (ref)
        local By = Gift.By;
        local v112;

        if typeof(By) == "table" then
            local v113 = By[tostring(LocalPlayer.UserId)];
            v112 = tonumber(v113) or 0;
        else
            v112 = 0;
        end;

        return GuildFeedData.Gifting.DefaultPerPersonCap <= v112;
    end;

    local function BlockReason() -- Line: 673
        -- upvalues: u110 (ref), u108 (copy), u109 (copy), Gift (copy), u1 (ref), ReplicatedStorage (ref)
        if u110 then
            return "Done";
        end;

        if u108 then
            return nil;
        end;

        if not u109 then
            return "OtherWorld";
        end;

        local Category = Gift.Category;
        local ItemKey = Gift.ItemKey;
        local v114;

        if Category and ItemKey then
            if not u1 then
                local success, result = pcall(function() -- Line: 27
                    -- upvalues: ReplicatedStorage (ref)
                    return require(ReplicatedStorage.ClientModules.PlayerStateClient);
                end);

                if success then
                    u1 = result;
                end;
            end;

            local u115 = u1;

            if u115 then
                local success, result = pcall(function() -- Line: 559
                    -- upvalues: u115 (copy), Category (copy), ItemKey (copy)
                    local v116 = u115:GetLocalReplica();
                    local v117 = v116 and v116.Data and v116.Data.Inventory;

                    if v117 then
                        v117 = v117[Category];
                    end;

                    if v117 then
                        v117 = v117[ItemKey];
                    end;

                    return v117;
                end);
                v114 = success and tonumber(result) or 0;
            else
                v114 = 0;
            end;
        else
            v114 = 0;
        end;

        return v114 <= 0 and "NoItems" or nil;
    end;

    local BackgroundColor3 = Box.Send.BackgroundColor3;
    local u118 = Color3.fromRGB(88, 94, 88);

    local function RefreshInteractive(p119) -- Line: 688
        -- upvalues: Gift (copy), u1 (ref), ReplicatedStorage (ref), u108 (copy), u109 (copy), Box (copy), BackgroundColor3 (copy), u118 (copy)
        local Category = Gift.Category;
        local ItemKey = Gift.ItemKey;
        local v120;

        if Category and ItemKey then
            if not u1 then
                local success, result = pcall(function() -- Line: 27
                    -- upvalues: ReplicatedStorage (ref)
                    return require(ReplicatedStorage.ClientModules.PlayerStateClient);
                end);

                if success then
                    u1 = result;
                end;
            end;

            local u121 = u1;

            if u121 then
                local success, result = pcall(function() -- Line: 559
                    -- upvalues: u121 (copy), Category (copy), ItemKey (copy)
                    local v122 = u121:GetLocalReplica();
                    local v123 = v122 and v122.Data and v122.Data.Inventory;

                    if v123 then
                        v123 = v123[Category];
                    end;

                    if v123 then
                        v123 = v123[ItemKey];
                    end;

                    return v123;
                end);
                v120 = success and tonumber(result) or 0;
            else
                v120 = 0;
            end;
        else
            v120 = 0;
        end;

        local v124 = not p119 and (not u108 and u109) and v120 > 0;

        for _, v in { Box.Minus, Box.Plus, Box.Send } do
            if v then
                v.AutoButtonColor = v124;
            end;
        end;

        local v125 = v124 and 0 or 0.6;
        Box.Minus.BackgroundTransparency = v125;
        Box.Plus.BackgroundTransparency = v125;
        Box.Minus.TextTransparency = v125;
        Box.Plus.TextTransparency = v125;
        Box.Send.BackgroundTransparency = v125;
        local v126;

        if v124 then
            v126 = BackgroundColor3;
        else
            v126 = u118;
        end;

        Box.Send.BackgroundColor3 = v126;
        local Studs = Box.Send:FindFirstChild("Studs");

        if Studs then
            Studs.ImageTransparency = v124 and 0.8 or 0.95;
        end;

        local Content = Box.Send:FindFirstChild("Content");
        local v127;

        if Content then
            v127 = Content:FindFirstChild("SendLabel");
        else
            v127 = Content;
        end;

        if v127 then
            v127.TextTransparency = v125;
            local v128 = v127:FindFirstChildOfClass("UIStroke");

            if v128 then
                v128.Transparency = v125;
            end;
        end;

        if Content then
            Content = Content:FindFirstChild("Icon");
        end;

        if Content then
            Content.ImageTransparency = v125;
        end;

        return v124;
    end;

    local function DrawAmount() -- Line: 732
        -- upvalues: Box (copy), u107 (ref), Gift (copy), LocalPlayer (ref), GuildFeedData (ref)
        Box.Amount.Text = tostring(u107);
        local SendLabel = Box.Send.Content:FindFirstChild("SendLabel");

        if SendLabel then
            local By = Gift.By;
            local v129;

            if typeof(By) == "table" then
                local v130 = By[tostring(LocalPlayer.UserId)];
                v129 = tonumber(v130) or 0;
            else
                v129 = 0;
            end;

            if GuildFeedData.Gifting.DefaultPerPersonCap <= v129 then
                SendLabel.Text = "Maxed";

                return;
            end;

            SendLabel.Text = "Send " .. u107;
        end;
    end;

    local function DrawProgress(p131, p132) -- Line: 746
        -- upvalues: u110 (ref), u94 (copy), Box (copy), u108 (copy), RefreshInteractive (copy), u107 (ref), Gift (copy), LocalPlayer (ref), GuildFeedData (ref)
        u110 = p132;
        local v133 = math.max(u94, 1);
        local v134 = math.clamp(p131, 0, v133);
        Box.Bar.Fill.Size = UDim2.new(u94 <= 0 and 0 or v134 / u94, 0, 1, 0);
        Box.Bar.Progress.Text = v134 .. " / " .. u94;
        Box.Send.Visible = not p132 and not u108;
        RefreshInteractive(p132);
        Box.Amount.Text = tostring(u107);
        local SendLabel = Box.Send.Content:FindFirstChild("SendLabel");

        if SendLabel then
            local By = Gift.By;
            local v135;

            if typeof(By) == "table" then
                local v136 = By[tostring(LocalPlayer.UserId)];
                v135 = tonumber(v136) or 0;
            else
                v135 = 0;
            end;

            if GuildFeedData.Gifting.DefaultPerPersonCap <= v135 then
                SendLabel.Text = "Maxed";

                return;
            end;

            SendLabel.Text = "Send " .. u107;
        end;
    end;

    DrawProgress(tonumber(Gift.Progress) or 0, u110);

    if u108 then
        Box.Minus.Visible = false;
        Box.Plus.Visible = false;
        Box.Amount.Visible = false;
        local Donors = Box:FindFirstChild("Donors");

        if Donors then
            Donors.Position = UDim2.new(0, 0, 0, 112);
            Donors.Size = UDim2.new(1, 0, 0, 72);
        end;
    end;

    Box.Minus.MouseButton1Click:Connect(function() -- Line: 772
        -- upvalues: RefreshInteractive (copy), u110 (ref), u107 (ref), Box (copy), Gift (copy), LocalPlayer (ref), GuildFeedData (ref)
        if not RefreshInteractive(u110) then
            return;
        end;

        u107 = math.max(1, u107 - 1);
        Box.Amount.Text = tostring(u107);
        local SendLabel = Box.Send.Content:FindFirstChild("SendLabel");

        if SendLabel then
            local By = Gift.By;
            local v137;

            if typeof(By) == "table" then
                local v138 = By[tostring(LocalPlayer.UserId)];
                v137 = tonumber(v138) or 0;
            else
                v137 = 0;
            end;

            if GuildFeedData.Gifting.DefaultPerPersonCap <= v137 then
                SendLabel.Text = "Maxed";

                return;
            end;

            SendLabel.Text = "Send " .. u107;
        end;
    end);
    Box.Plus.MouseButton1Click:Connect(function() -- Line: 777
        -- upvalues: RefreshInteractive (copy), u110 (ref), DefaultPerPersonCap (copy), Gift (copy), u1 (ref), ReplicatedStorage (ref), u107 (ref), Box (copy), LocalPlayer (ref), GuildFeedData (ref)
        if not RefreshInteractive(u110) then
            return;
        end;

        local Category = Gift.Category;
        local ItemKey = Gift.ItemKey;
        local v139;

        if Category and ItemKey then
            if not u1 then
                local success, result = pcall(function() -- Line: 27
                    -- upvalues: ReplicatedStorage (ref)
                    return require(ReplicatedStorage.ClientModules.PlayerStateClient);
                end);

                if success then
                    u1 = result;
                end;
            end;

            local u140 = u1;

            if u140 then
                local success, result = pcall(function() -- Line: 559
                    -- upvalues: u140 (copy), Category (copy), ItemKey (copy)
                    local v141 = u140:GetLocalReplica();
                    local v142 = v141 and v141.Data and v141.Data.Inventory;

                    if v142 then
                        v142 = v142[Category];
                    end;

                    if v142 then
                        v142 = v142[ItemKey];
                    end;

                    return v142;
                end);
                v139 = success and tonumber(result) or 0;
            else
                v139 = 0;
            end;
        else
            v139 = 0;
        end;

        local v143 = math.min(DefaultPerPersonCap, v139);
        local v144 = math.max(v143, 1);
        u107 = math.min(v144, u107 + 1);
        Box.Amount.Text = tostring(u107);
        local SendLabel = Box.Send.Content:FindFirstChild("SendLabel");

        if SendLabel then
            local By = Gift.By;
            local v145;

            if typeof(By) == "table" then
                local v146 = By[tostring(LocalPlayer.UserId)];
                v145 = tonumber(v146) or 0;
            else
                v145 = 0;
            end;

            if GuildFeedData.Gifting.DefaultPerPersonCap <= v145 then
                SendLabel.Text = "Maxed";

                return;
            end;

            SendLabel.Text = "Send " .. u107;
        end;
    end);
    Box.Amount.Text = tostring(u107);
    local SendLabel = Box.Send.Content:FindFirstChild("SendLabel");

    if SendLabel then
        local By = Gift.By;
        local v147;

        if typeof(By) == "table" then
            local v148 = By[tostring(LocalPlayer.UserId)];
            v147 = tonumber(v148) or 0;
        else
            v147 = 0;
        end;

        if GuildFeedData.Gifting.DefaultPerPersonCap <= v147 then
            SendLabel.Text = "Maxed";
        else
            SendLabel.Text = "Send " .. u107;
        end;
    end;

    Box.Send.MouseButton1Click:Connect(function() -- Line: 788
        -- upvalues: RefreshInteractive (copy), u110 (ref), u108 (copy), u109 (copy), Gift (copy), u1 (ref), ReplicatedStorage (ref), u3 (ref), u93 (copy), u107 (ref)
        if RefreshInteractive(u110) then
            if u3.OnDonate then
                u3.OnDonate(u93.Seq, u107);
            end;

            return;
        end;

        local v149;

        if u110 then
            v149 = "Done";
        elseif u108 then
            v149 = nil;
        elseif u109 then
            local Category = Gift.Category;
            local ItemKey = Gift.ItemKey;
            local v150;

            if Category and ItemKey then
                if not u1 then
                    local success, result = pcall(function() -- Line: 27
                        -- upvalues: ReplicatedStorage (ref)
                        return require(ReplicatedStorage.ClientModules.PlayerStateClient);
                    end);

                    if success then
                        u1 = result;
                    end;
                end;

                local u151 = u1;

                if u151 then
                    local success, result = pcall(function() -- Line: 559
                        -- upvalues: u151 (copy), Category (copy), ItemKey (copy)
                        local v152 = u151:GetLocalReplica();
                        local v153 = v152 and v152.Data and v152.Data.Inventory;

                        if v153 then
                            v153 = v153[Category];
                        end;

                        if v153 then
                            v153 = v153[ItemKey];
                        end;

                        return v153;
                    end);
                    v150 = success and tonumber(result) or 0;
                else
                    v150 = 0;
                end;
            else
                v150 = 0;
            end;

            v149 = v150 <= 0 and "NoItems" or nil;
        else
            v149 = "OtherWorld";
        end;

        if v149 and u3.OnBlockedDonate then
            u3.OnBlockedDonate(v149, Gift.ItemKey, Gift.Category);
        end;
    end);

    local function DrawDonors(p154) -- Line: 802
        -- upvalues: Box (copy), GuildCardTemplates (ref), u108 (copy)
        local Donors = Box:FindFirstChild("Donors");

        if not Donors then
            return;
        end;

        for _, child in pairs(Donors:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy();
            end;
        end;

        if typeof(p154) ~= "table" then
            return;
        end;

        local v155 = {};

        for i, v in pairs(p154) do
            local v156 = tonumber(i);
            local v157 = tonumber(v);

            if v156 and (v157 and v157 > 0) then
                table.insert(v155, {
                    UserId = v156,
                    Count = v157
                });
            end;
        end;

        table.sort(v155, function(p158, p159) -- Line: 825
            return p158.Count > p159.Count;
        end);

        for i, v in ipairs(v155) do
            local v160 = GuildCardTemplates.DonorChip:Clone();
            v160.LayoutOrder = i;
            v160.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. v.UserId .. "&w=150&h=150";
            v160.Amount.Text = `{v.Count}x`;

            if u108 then
                v160.Size = UDim2.new(0, 96, 0, 60);
                local Avatar = v160:FindFirstChild("Avatar");

                if Avatar then
                    Avatar.Size = UDim2.new(0, 48, 0, 48);
                    Avatar.Position = UDim2.new(0, 6, 0.5, 0);
                end;

                local Amount = v160:FindFirstChild("Amount");

                if Amount then
                    Amount.Position = UDim2.new(0, 58, 0, 0);
                    Amount.Size = UDim2.new(1, -58, 1, 0);
                    Amount.TextSize = 18;
                end;
            end;

            v160.Parent = Donors;
        end;
    end;

    DrawDonors(Gift.By);
    u96.Parent = p92.Feed;
    AttachTimestamp(u96, u93.At);
    u4[u93.Seq] = {
        IsGift = true,
        Instance = u96,
        Box = Box,
        DrawProgress = DrawProgress,
        DrawDonors = DrawDonors,
        Goal = u94,
        UserId = u93.UserId
    };
    ReorderCards();

    if v95 then
        p92:ScrollToBottom();
    end;
end;

function u3.ApplyGiftProgress(p161, p162, p163, p164, p165) -- Line: 863
    -- upvalues: u4 (copy)
    local v166 = u4[p162];

    if not (v166 and v166.DrawProgress) then
        return;
    end;

    if p164 == true then
        p161:RemovePost(p162);

        return;
    end;

    v166.DrawProgress(tonumber(p163) or 0, p164 == true);

    if p165 ~= nil and v166.DrawDonors then
        v166.DrawDonors(p165);
    end;
end;

function u3.AddPost(p167, u168) -- Line: 886
    -- upvalues: u4 (copy), GuildFeedData (copy), AddGiftCard (copy), GuildCardTemplates (copy), u5 (ref), BuildActionText (copy), FetchName (copy), GetItemImage (copy), LocalPlayer (copy), u3 (copy), u2 (copy), AddReactorRow (copy), ApplyMask (copy), AttachTimestamp (copy), ReorderCards (copy)
    if not p167.Feed then
        return;
    end;

    if typeof(u168) ~= "table" or not u168.Seq then
        return;
    end;

    if u4[u168.Seq] then
        return;
    end;

    if GuildFeedData.GetKindById(u168.Kind) == "GiftRequest" then
        AddGiftCard(p167, u168);

        return;
    end;

    local Feed = p167.Feed;
    local v169;

    if Feed then
        v169 = Feed.AbsoluteCanvasSize.Y - Feed.AbsoluteWindowSize.Y - Feed.CanvasPosition.Y < 40;
    else
        v169 = false;
    end;

    local u170 = GuildCardTemplates.AccomplishmentCard:Clone();
    u170.Name = "Post_" .. u168.Seq;
    u170:SetAttribute("Seq", u168.Seq);
    u5 = u5 + 1;
    u170.LayoutOrder = u5;
    local Box = u170.Box;
    local Reactions = u170.Reactions;
    Box.Avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. u168.UserId .. "&w=150&h=150";
    local u171 = BuildActionText(u168);
    Box.Info.Text = "<font color=\"" .. "#BEC6BE" .. "\">" .. u171 .. "</font>";
    FetchName(u168.UserId, function(p172) -- Line: 916
        -- upvalues: u170 (copy), Box (copy), u171 (copy)
        if not u170.Parent then
            return;
        end;

        local Info = Box:FindFirstChild("Info");

        if not Info then
            return;
        end;

        Info.Text = "<b>" .. p172 .. "</b> <font color=\"" .. "#BEC6BE" .. "\">" .. u171 .. "</font>";
    end);
    local v173 = GetItemImage(u168.ItemKey);

    if v173 then
        Box.Subject.Image = v173;
        Box.Subject.Visible = true;
    else
        Box.Subject.Visible = false;
    end;

    local Join = Box:FindFirstChild("Join");

    if Join and Join:IsA("TextButton") then
        Join.Visible = u168.UserId ~= LocalPlayer.UserId;
        Join.MouseButton1Click:Connect(function() -- Line: 944
            -- upvalues: u3 (ref), u168 (copy)
            if u3.OnJoin then
                u3.OnJoin(u168.UserId);
            end;
        end);
    end;

    for _, child in pairs(Box.ReactionRow:GetChildren()) do
        if child:IsA("TextButton") then
            local Text = child.Text;
            local BackgroundColor3 = child.BackgroundColor3;
            child:SetAttribute("Reacted", false);
            child.MouseButton1Click:Connect(function() -- Line: 959
                -- upvalues: child (copy), u2 (ref), BackgroundColor3 (copy), u3 (ref), AddReactorRow (ref), Reactions (copy), LocalPlayer (ref), Text (copy), u168 (copy)
                local v174 = not child:GetAttribute("Reacted");
                child:SetAttribute("Reacted", v174);
                child.BackgroundColor3 = v174 and u2 or BackgroundColor3;
                local Feed2 = u3.Feed;
                local v175;

                if Feed2 then
                    v175 = Feed2.AbsoluteCanvasSize.Y - Feed2.AbsoluteWindowSize.Y - Feed2.CanvasPosition.Y < 40;
                else
                    v175 = false;
                end;

                if v174 then
                    AddReactorRow(Reactions, LocalPlayer.UserId, Text);
                else
                    local v176 = Reactions:FindFirstChild("React_" .. LocalPlayer.UserId .. "_" .. Text);

                    if v176 then
                        v176:Destroy();
                    end;
                end;

                if v175 and v174 then
                    u3:ScrollToBottom();
                end;

                if u3.OnReact then
                    u3.OnReact(u168.Seq, Text, v174);
                end;
            end);
        end;
    end;

    for i, v in ipairs(u168.R and (u168.R.U or {}) or {}) do
        local v177 = u168.R.M[i] or 0;
        ApplyMask(Reactions, v, v177);

        if v == LocalPlayer.UserId then
            for i2, v2 in ipairs(GuildFeedData.Reactions.Emojis) do
                local v178 = bit32.lshift(1, i2 - 1);

                if bit32.band(v177, v178) ~= 0 then
                    local v179 = Box.ReactionRow:FindFirstChild("Pill_" .. v2);

                    if v179 then
                        v179:SetAttribute("Reacted", true);
                        v179.BackgroundColor3 = u2;
                    end;
                end;
            end;
        end;
    end;

    u170.Parent = p167.Feed;
    AttachTimestamp(u170, u168.At, -4);
    u4[u168.Seq] = {
        Instance = u170,
        Reactions = Reactions,
        Box = Box
    };
    ReorderCards();

    if v169 then
        p167:ScrollToBottom();
    end;
end;

function u3.ApplyReaction(p180, p181, p182, p183) -- Line: 1014
    -- upvalues: u4 (copy), LocalPlayer (copy), ApplyMask (copy)
    local v184 = u4[p181];

    if not (v184 and v184.Reactions) then
        return;
    end;

    if p182 == LocalPlayer.UserId then
        return;
    end;

    local Feed = p180.Feed;
    local v185;

    if Feed then
        v185 = Feed.AbsoluteCanvasSize.Y - Feed.AbsoluteWindowSize.Y - Feed.CanvasPosition.Y < 40;
    else
        v185 = false;
    end;

    ApplyMask(v184.Reactions, p182, p183);

    if v185 then
        p180:ScrollToBottom();
    end;
end;

function u3.RenderFeed(p186, p187) -- Line: 1033
    p186:Clear();

    if typeof(p187) ~= "table" or typeof(p187.Posts) ~= "table" then
        return;
    end;

    local v188 = table.clone(p187.Posts);
    table.sort(v188, function(p189, p190) -- Line: 1041
        return (p189.Seq or 0) < (p190.Seq or 0);
    end);

    for _, v in pairs(v188) do
        p186:AddPost(v);
    end;

    p186:ScrollToBottom();
end;

function u3.HasOwnRequest(p191) -- Line: 1055
    -- upvalues: u4 (copy), LocalPlayer (copy)
    for _, v in pairs(u4) do
        if v.IsGift and v.UserId == LocalPlayer.UserId then
            return true;
        end;
    end;

    return false;
end;

return u3;