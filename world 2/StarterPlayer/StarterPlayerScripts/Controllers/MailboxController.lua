-- Decompiled with Potassium's decompiler.

local u1 = {
    StartOrder = 5
};
local Players = game:GetService("Players");
local ProximityPromptService = game:GetService("ProximityPromptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local TweenService = game:GetService("TweenService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PlayerStateClient = require(ReplicatedStorage.ClientModules.PlayerStateClient);
local AnimatedGradient = require(ReplicatedStorage.SharedModules.AnimatedGradient);
local PetTypes = require(ReplicatedStorage.SharedData.PetTypes);
local MailboxFlags = require(ReplicatedStorage.SharedModules.Flags.MailboxFlags);
local MagicMailFlags = require(ReplicatedStorage.SharedModules.Flags.MagicMailFlags);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local DupeProtection = require(ReplicatedStorage.SharedModules.DupeProtection);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local MailboxItemCatalog = require(script.MailboxItemCatalog);
local u2 = Color3.fromRGB(120, 120, 120);
local u3 = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u4 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out);
local u5 = nil;
local u6 = false;
local u7 = {};
local u8 = {};
local u9 = {};
local u10 = {};
local u11 = {};
local u12 = {};
local u13 = nil;
local u14 = nil;
local u15 = true;
local u16 = nil;
local u17 = nil;
local u18 = {};
local u19 = nil;
local u20 = nil;
local u21 = nil;
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
local u33 = false;
local u34 = (-1 / 0);
local u35 = {};
local u36 = {};
local u37 = nil;
local u38 = 0;
local u39 = 0;
local u40 = {};
local u41 = 0;
local u42 = nil;
local u43 = nil;
local u44 = nil;
local u45 = nil;
local u46 = nil;
local u47 = nil;
local u48 = nil;
local u49 = nil;
local u50 = "Send";
local u51 = 0;
local u52 = nil;
local u53 = nil;
local u54 = nil;
local u55 = nil;

local function streakDayLengthSeconds() -- Line: 158
    -- upvalues: ReplicatedStorage (copy)
    local v56 = ReplicatedStorage:GetAttribute("StreakDayLengthSeconds");

    return (typeof(v56) ~= "number" or v56 <= 0) and 86400 or v56;
end;

local u57 = {};
local u58 = {};
local u59 = false;
local u60 = 0;
local u61 = {};
local u62 = {};
local u63 = {};
local u64 = {};
local u65 = {};
local u66 = nil;
local u67 = nil;
local u68 = false;
local u69 = {};

local function trackSession(p70) -- Line: 209
    -- upvalues: u7 (copy)
    table.insert(u7, p70);

    return p70;
end;

local function trackPersistent(p71) -- Line: 214
    -- upvalues: u8 (copy)
    table.insert(u8, p71);

    return p71;
end;

local function clearSession() -- Line: 219
    -- upvalues: u7 (copy)
    for _, v in u7 do
        pcall(function() -- Line: 221
            -- upvalues: v (copy)
            v:Disconnect();
        end);
    end;

    table.clear(u7);
end;

local function setFlagTransparency(p72, p73) -- Line: 230
    if not p72 then
        return;
    end;

    for _, descendant in p72:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Transparency = p73;
        end;
    end;
end;

local function applyMailboxVisuals(p74) -- Line: 239
    -- upvalues: u68 (ref), setFlagTransparency (copy)
    local Notification = p74:FindFirstChild("Notification");

    if Notification then
        Notification = Notification:FindFirstChildWhichIsA("BillboardGui");
    end;

    if Notification then
        Notification.Enabled = u68;
    end;

    local FlagUp = p74:FindFirstChild("FlagUp");
    local FlagDown = p74:FindFirstChild("FlagDown");
    setFlagTransparency(FlagUp, u68 and 0 or 1);
    setFlagTransparency(FlagDown, u68 and 1 or 0);
end;

local function applyAllMailboxVisuals() -- Line: 252
    -- upvalues: u69 (copy), applyMailboxVisuals (copy)
    for i in u69 do
        if i.Parent then
            applyMailboxVisuals(i);
        else
            u69[i] = nil;
        end;
    end;
end;

local function trackMailbox(u75) -- Line: 262
    -- upvalues: u69 (copy), applyMailboxVisuals (copy), u8 (copy)
    if u69[u75] then
        return;
    end;

    u69[u75] = true;
    applyMailboxVisuals(u75);
    local v76 = u75.DescendantAdded:Connect(function() -- Line: 267
        -- upvalues: applyMailboxVisuals (ref), u75 (copy)
        applyMailboxVisuals(u75);
    end);
    table.insert(u8, v76);
    local v79 = u75.AncestryChanged:Connect(function(p77, p78) -- Line: 270
        -- upvalues: u69 (ref), u75 (copy)
        if p78 == nil then
            u69[u75] = nil;
        end;
    end);
    table.insert(u8, v79);
end;

local function findLocalPlot() -- Line: 277
    -- upvalues: LocalPlayer (copy)
    local Gardens = workspace:FindFirstChild("Gardens");

    if not Gardens then
        return nil;
    end;

    local v80 = LocalPlayer:GetAttribute("PlotId");
    local v81 = v80 ~= nil and Gardens:FindFirstChild("Plot" .. tostring(v80));

    if v81 then
        return v81;
    end;

    for _, child in Gardens:GetChildren() do
        if child:GetAttribute("OwnerUserId") == LocalPlayer.UserId then
            return child;
        end;
    end;

    return nil;
end;

local function discoverLocalMailboxes() -- Line: 293
    -- upvalues: findLocalPlot (copy), trackMailbox (copy), u8 (copy)
    local v82 = findLocalPlot();

    if not v82 then
        return;
    end;

    for _, descendant in v82:GetDescendants() do
        if descendant:IsA("Model") and descendant.Name == "GreyMailBox" then
            trackMailbox(descendant);
        end;
    end;

    local v84 = v82.DescendantAdded:Connect(function(p83) -- Line: 302
        -- upvalues: trackMailbox (ref)
        if p83:IsA("Model") and p83.Name == "GreyMailBox" then
            trackMailbox(p83);
        end;
    end);
    table.insert(u8, v84);
end;

local function applyHeaderNotificationVisuals() -- Line: 309
    -- upvalues: u42 (ref), u68 (ref)
    if u42 then
        u42.Visible = u68;
    end;
end;

local function setHasMail(p85) -- Line: 315
    -- upvalues: u68 (ref), u69 (copy), applyMailboxVisuals (copy), u42 (ref)
    if u68 == p85 then
        return;
    end;

    u68 = p85;

    for i in u69 do
        if i.Parent then
            applyMailboxVisuals(i);
        else
            u69[i] = nil;
        end;
    end;

    if u42 then
        u42.Visible = u68;
    end;
end;

local u86 = nil;
local u87 = UDim2.new(0.515, 0, 0.237, 0);
local u88 = UDim2.new(0.118, 0, 0.532, 0);
local u89 = nil;
local u90 = nil;

local function updateCapacityLabel() -- Line: 328
    -- upvalues: u86 (ref), u9 (ref), MailboxFlags (copy)
    if not u86 then
        return;
    end;

    local v91 = 0;

    if type(u9) == "table" then
        for _, v in u9 do
            if type(v) == "table" and v.Kind ~= "GuildReward" then
                local v92 = tonumber(v.From);

                if v92 and v92 > 0 then
                    v91 = v91 + 1;
                end;
            end;
        end;
    end;

    u86.Text = v91 .. "/" .. MailboxFlags.Capacity:Get();
end;

local function GiftHasItems(p93) -- Line: 345
    if type(p93) ~= "table" then
        return false;
    end;

    local Items = p93.Items;

    if type(Items) == "table" then
        return #Items > 0;
    end;

    local v94;

    if type(p93.Category) == "string" then
        v94 = type(p93.ItemName) == "string";
    else
        v94 = false;
    end;

    return v94;
end;

local function CountClaimableGifts() -- Line: 357
    -- upvalues: u9 (ref)
    local v95 = 0;

    for _, v in u9 do
        local v96;

        if type(v) == "table" then
            local Items = v.Items;

            if type(Items) == "table" then
                v96 = #Items > 0;
            elseif type(v.Category) == "string" then
                v96 = type(v.ItemName) == "string";
            else
                v96 = false;
            end;
        else
            v96 = false;
        end;

        if v96 then
            v95 = v95 + 1;
        end;
    end;

    return v95;
end;

local function ClaimAllCooldownRemaining() -- Line: 368
    -- upvalues: u34 (ref)
    local v97 = 30 - (os.clock() - u34);

    return v97 < 0 and 0 or v97;
end;

local function UpdateClaimAllProgressToast() -- Line: 377
    -- upvalues: u37 (ref), u38 (ref), u39 (ref)
    if not u37 then
        return;
    end;

    u37:SetText((`Claiming your mail... {u38}/{u39}`));
end;

local function UpdateAcceptAllButton() -- Line: 385
    -- upvalues: u50 (ref), u9 (ref), u32 (ref), u33 (ref), u34 (ref), u86 (ref), u89 (ref), u90 (ref), u87 (copy), u88 (copy)
    local v98;

    if u50 == "Receive" then
        local v99 = 0;

        for _, v in u9 do
            local v100;

            if type(v) == "table" then
                local Items = v.Items;

                if type(Items) == "table" then
                    v100 = #Items > 0;
                elseif type(v.Category) == "string" then
                    v100 = type(v.ItemName) == "string";
                else
                    v100 = false;
                end;
            else
                v100 = false;
            end;

            if v100 then
                v99 = v99 + 1;
            end;
        end;

        v98 = v99 > 1;
    else
        v98 = false;
    end;

    if u32 then
        u32.Visible = v98;
        u32.Active = v98;
        local v101 = not u33;

        if v101 then
            local v102 = 30 - (os.clock() - u34);
            v101 = (v102 < 0 and 0 or v102) <= 0;
        end;

        if u32:IsA("TextButton") or u32:IsA("ImageButton") then
            u32.AutoButtonColor = v101;
        end;
    else
        v98 = false;
    end;

    if u86 and (u89 and u90) then
        local v103;

        if v98 then
            v103 = u89;
        else
            v103 = u87;
        end;

        u86.Position = v103;
        local v104;

        if v98 then
            v104 = u90;
        else
            v104 = u88;
        end;

        u86.Size = v104;
    end;
end;

local function recomputeHasMail() -- Line: 404
    -- upvalues: u9 (ref), u10 (ref), Worlds (copy), u11 (ref), u68 (ref), u69 (copy), applyMailboxVisuals (copy), u42 (ref), updateCapacityLabel (copy), UpdateAcceptAllButton (copy)
    local v105 = false;

    for _ in u9 do
        v105 = true;
        break;
    end;

    if not v105 then
        for _ in u10 do
            v105 = true;
            break;
        end;
    end;

    if not v105 and Worlds.Current.Features.MagicMailClaim then
        for _ in u11 do
            v105 = true;
            break;
        end;
    end;

    if u68 ~= v105 then
        u68 = v105;

        for i in u69 do
            if i.Parent then
                applyMailboxVisuals(i);
            else
                u69[i] = nil;
            end;
        end;

        if u42 then
            u42.Visible = u68;
        end;
    end;

    updateCapacityLabel();
    UpdateAcceptAllButton();
end;

local function clearChildrenExcept(p106, p107) -- Line: 434
    for _, child in p106:GetChildren() do
        if not (p107[child] or (child:IsA("UIGridLayout") or (child:IsA("UIListLayout") or (child:IsA("UIPadding") or (child:IsA("UISizeConstraint") or child:IsA("UIAspectRatioConstraint")))))) then
            child:Destroy();
        end;
    end;
end;

local function setAllTextLabels(p108, p109) -- Line: 448
    -- upvalues: setAllTextLabels (copy)
    if p108:IsA("TextLabel") or (p108:IsA("TextButton") or p108:IsA("TextBox")) then
        p108.Text = p109;
    end;

    for _, child in p108:GetChildren() do
        if child:IsA("TextLabel") or (child:IsA("TextButton") or child:IsA("TextBox")) then
            child.Text = p109;
        end;

        setAllTextLabels(child, p109);
    end;
end;

local function setLabelChain(p110, p111, p112) -- Line: 460
    if p110:IsA("TextLabel") or p110:IsA("TextButton") then
        if p112 ~= nil then
            p110.RichText = p112;
        end;

        p110.Text = p111;
    end;

    for _, descendant in p110:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            if p112 ~= nil then
                descendant.RichText = p112;
            end;

            descendant.Text = p111;
        end;
    end;
end;

local function escapeRich(p113) -- Line: 477
    local v114 = string.gsub(p113, "&", "&amp;");
    local v115 = string.gsub(v114, "<", "&lt;");

    return string.gsub(v115, ">", "&gt;");
end;

local function setFromLineWithStreak(p116, u117, u118) -- Line: 489
    local function apply(p119) -- Line: 490
        -- upvalues: u117 (copy), u118 (copy)
        if not (p119:IsA("TextLabel") or p119:IsA("TextButton")) then
            return;
        end;

        p119.RichText = true;
        local TextColor3 = p119.TextColor3;

        if TextColor3.R + TextColor3.G + TextColor3.B < 0.25 then
            p119.Text = u117;

            return;
        end;

        p119.Text = u117 .. `  <font color="#FFFFFF">{u118}</font>`;
    end;

    apply(p116);

    for _, descendant in p116:GetDescendants() do
        apply(descendant);
    end;
end;

local function placeReplyInClaimSlot(p120, p121) -- Line: 509
    p121.Position = p120.Position;
    p121.Size = p120.Size;
    p121.AnchorPoint = p120.AnchorPoint;
    p121.LayoutOrder = p120.LayoutOrder;
    p121.ZIndex = p120.ZIndex;
end;

local function streakDisplay(p122) -- Line: 522
    -- upvalues: MailboxFlags (copy), u57 (ref), ReplicatedStorage (copy)
    if not MailboxFlags.StreaksEnabled:Get() then
        return 0, false;
    end;

    local v123 = u57[p122];

    if not v123 or v123.Count <= 0 then
        return 0, false;
    end;

    local v124 = os.time();
    local v125 = ReplicatedStorage:GetAttribute("StreakDayLengthSeconds");
    local v126 = (typeof(v125) ~= "number" or v125 <= 0) and 86400 or v125;
    local v127 = v124 // v126;
    local v128 = v127 - v123.LastDay;

    if v128 < 0 or v128 > 1 then
        return 0, false;
    end;

    local v129;

    if v123.LastDay == v127 - 1 then
        v129 = v126 - v124 % v126 <= MailboxFlags.StreakAtRiskWindowSeconds:Get();
    else
        v129 = false;
    end;

    return v123.Count, v129;
end;

local function applyStreakToRow(p130, p131) -- Line: 544
    -- upvalues: streakDisplay (copy), setLabelChain (copy)
    local Button = p130:FindFirstChild("Button");

    if not Button then
        return;
    end;

    local Streak = Button:FindFirstChild("Streak");

    if not (Streak and Streak:IsA("GuiObject")) then
        return;
    end;

    local v132, v133 = streakDisplay(p131);

    if v132 <= 0 then
        Streak.Visible = false;
        p130.LayoutOrder = 0;

        return;
    end;

    setLabelChain(Streak, (v133 and "⏳ " or "🔥 ") .. tostring(v132));
    Streak.Visible = true;
    p130.LayoutOrder = -v132;
end;

local function updateInfoLabel() -- Line: 562
    -- upvalues: u49 (ref), u50 (ref), MagicMailFlags (copy), u11 (ref), u9 (ref), u10 (ref), u63 (copy), u65 (copy), setLabelChain (copy), u52 (ref), u51 (ref), u58 (copy)
    if not u49 then
        return;
    end;

    if u50 ~= "Receive" then
        if u50 ~= "Send" or (u52 == nil or (u51 ~= 0 or next(u58) ~= nil)) then
            u49.Visible = false;

            return;
        end;

        u49.Visible = true;
        setLabelChain(u49, "You dont have anything to send");

        return;
    end;

    local v134 = MagicMailFlags.Enabled:Get() and next(u11) ~= nil;

    if next(u9) ~= nil or (next(u10) ~= nil or (next(u63) ~= nil or (next(u65) ~= nil or v134))) then
        u49.Visible = false;

        return;
    end;

    u49.Visible = true;
    setLabelChain(u49, "You dont have any mail");
end;

local function applyHeadshot(u135, p136, u137) -- Line: 602
    -- upvalues: MailboxItemCatalog (copy)
    local u138 = tonumber(p136) or 0;

    if u138 <= 0 then
        return;
    end;

    local v139 = MailboxItemCatalog.GetCachedHeadshot(u138);

    if v139 and v139 ~= "" then
        u135.Image = v139;

        return;
    end;

    u135.Image = "";
    task.spawn(function() -- Line: 613
        -- upvalues: MailboxItemCatalog (ref), u138 (copy), u137 (copy), u135 (copy)
        local v140 = MailboxItemCatalog.GetHeadshot(u138);

        if v140 ~= "" and (u137.Parent and u135.Parent) then
            u135.Image = v140;
        end;
    end);
end;

local function isReceiveTile(p141) -- Line: 623
    return (string.sub(p141, 1, 5) == "Gift_" or string.sub(p141, 1, 7) == "Invite_") and true or string.sub(p141, 1, 10) == "MagicMail_";
end;

local function bindReceiveCanvasSize(u142) -- Line: 646
    -- upvalues: u16 (ref), u8 (copy)
    local u143 = u142:FindFirstChildOfClass("UIListLayout");
    local GiftTemplate = u142:FindFirstChild("GiftTemplate");

    if not (u143 and (GiftTemplate and GiftTemplate:IsA("GuiObject"))) then
        return;
    end;

    local Scale = GiftTemplate.Size.Y.Scale;
    local Scale2 = u143.Padding.Scale;

    if Scale <= 0 then
        return;
    end;

    local function v145() -- Line: 655
        -- upvalues: u142 (copy), Scale (copy), u143 (copy), Scale2 (copy), GiftTemplate (copy)
        local Y = u142.AbsoluteWindowSize.Y;

        if Y <= 0 then
            return;
        end;

        local v144 = math.floor(Scale * Y + 0.5);
        u143.Padding = UDim.new(0, (math.floor(Scale2 * Y + 0.5)));

        for _, child in u142:GetChildren() do
            if child:IsA("GuiObject") then
                local Name = child.Name;

                if (string.sub(Name, 1, 5) == "Gift_" or string.sub(Name, 1, 7) == "Invite_") and true or string.sub(Name, 1, 10) == "MagicMail_" or child == GiftTemplate then
                    child.Size = UDim2.new(child.Size.X.Scale, child.Size.X.Offset, 0, v144);
                end;
            end;
        end;
    end;

    u16 = v145;
    v145();
    local v146 = u142:GetPropertyChangedSignal("AbsoluteSize"):Connect(v145);
    table.insert(u8, v146);
end;

local function pruneExpiredReplyPending() -- Line: 675
    -- upvalues: MailboxFlags (copy), u63 (copy), u64 (copy)
    local v147 = MailboxFlags.ReplyWindowSeconds:Get();
    local v148 = workspace:GetServerTimeNow();
    local v149 = false;

    for i, v in u63 do
        if v147 <= v148 - v.ClaimedAt then
            u63[i] = nil;
            local v150 = u64[i];

            if v150 then
                task.cancel(v150);
                u64[i] = nil;
            end;

            v149 = true;
        end;
    end;

    return v149;
end;

local function setDisabledClaimLabel(p151, u152) -- Line: 698
    -- upvalues: u2 (copy)
    local function _(p153) -- Line: 699
        -- upvalues: u152 (copy)
        if not (p153:IsA("TextLabel") or p153:IsA("TextButton")) then
            return;
        end;

        local TextColor3 = p153.TextColor3;

        if TextColor3.R + TextColor3.G + TextColor3.B < 0.25 then
            p153.Text = "";

            return;
        end;

        p153.Text = u152;
    end;

    if p151:IsA("TextLabel") or p151:IsA("TextButton") then
        local TextColor3 = p151.TextColor3;

        if TextColor3.R + TextColor3.G + TextColor3.B < 0.25 then
            p151.Text = "";
        else
            p151.Text = u152;
        end;
    end;

    for _, descendant in p151:GetDescendants() do
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
            local TextColor3 = descendant.TextColor3;

            if TextColor3.R + TextColor3.G + TextColor3.B < 0.25 then
                descendant.Text = "";
            else
                descendant.Text = u152;
            end;
        end;
    end;

    if p151:IsA("TextButton") or p151:IsA("ImageButton") then
        p151.AutoButtonColor = false;
    end;

    p151.BackgroundColor3 = u2;
end;

local function giftOriginWorldId(p154) -- Line: 720
    -- upvalues: Worlds (copy)
    local v155;

    if typeof(p154) == "table" then
        v155 = p154.FromWorld;
    else
        v155 = nil;
    end;

    return (typeof(v155) ~= "string" or Worlds.Worlds[v155] == nil) and "Main" or v155;
end;

local function buildGiftClone(u156, u157, p158) -- Line: 731
    -- upvalues: u13 (ref), u14 (ref), MailboxItemCatalog (copy), u1 (copy), streakDisplay (copy), setFromLineWithStreak (copy), setLabelChain (copy), applyHeadshot (copy), u62 (copy), Worlds (copy), setDisabledClaimLabel (copy), NotificationController (copy), DupeProtection (copy), u7 (copy)
    if not (u13 and u14) then
        return nil;
    end;

    local v159 = p158 == "replyOnly";
    local v160 = p158 == "claimed";
    local v161 = typeof(u157) == "table" and u157.Kind == "GuildReward" and MailboxItemCatalog.BuildGuildRewardVisual(u14, u156, u157, function() -- Line: 748
        -- upvalues: u1 (ref), u156 (copy), u157 (copy)
        u1:_claimGift(u156, u157, nil);
    end);

    if v161 then
        return v161;
    end;

    local v162 = u13:Clone();
    v162.Name = "Gift_" .. u156;
    v162.Visible = true;
    v162.Interactable = true;
    local Interior = v162:FindFirstChild("Interior");

    if not Interior then
        return nil;
    end;

    local TopFrame = Interior:FindFirstChild("TopFrame");
    local v163, v164 = streakDisplay(tonumber(u157.From) or 0);
    local v165 = (v164 and "⏳ " or "🔥 ") .. tostring(v163);
    local v166;

    if TopFrame then
        v166 = TopFrame:FindFirstChild("Streak", true);
    else
        v166 = nil;
    end;

    local v167;

    if v166 == nil then
        v167 = false;
    else
        v167 = v166:IsA("GuiObject");
    end;

    local v168;

    if v163 > 0 then
        v168 = not v167;
    else
        v168 = false;
    end;

    local v169 = tostring(u157.FromName or "?");

    if TopFrame then
        local SentPlayerNameTextLabel1 = TopFrame:FindFirstChild("SentPlayerNameTextLabel1");
        local SubjectLine1 = TopFrame:FindFirstChild("SubjectLine1");

        if v168 then
            local format = string.format;
            local v170 = string.gsub(v169, "&", "&amp;");
            local v171 = string.gsub(v170, "<", "&lt;");
            local v172 = format("From @%s!", (string.gsub(v171, ">", "&gt;")));

            if SentPlayerNameTextLabel1 then
                setFromLineWithStreak(SentPlayerNameTextLabel1, v172, v165);
            end;

            if SubjectLine1 then
                setFromLineWithStreak(SubjectLine1, v172, v165);
            end;
        else
            local v173 = string.format("From @%s!", v169);

            if SentPlayerNameTextLabel1 then
                setLabelChain(SentPlayerNameTextLabel1, v173, false);
            end;

            if SubjectLine1 then
                setLabelChain(SubjectLine1, v173, false);
            end;
        end;

        local SentPlayerImageLabel = TopFrame:FindFirstChild("SentPlayerImageLabel");

        if SentPlayerImageLabel and SentPlayerImageLabel:IsA("ImageLabel") then
            applyHeadshot(SentPlayerImageLabel, u157.From or 0, v162);
        end;

        if v166 and v166:IsA("GuiObject") then
            if v163 > 0 then
                setLabelChain(v166, v165);

                if v166:IsA("TextLabel") or v166:IsA("TextButton") then
                    v166.TextColor3 = Color3.new(1, 1, 1);
                end;

                v166.Visible = true;
            else
                v166.Visible = false;
            end;
        end;
    end;

    local Note = u157.Note;
    local v174 = (typeof(Note) ~= "string" or Note == "") and (u157.Kind == "GuildGift" and "A guildmate answered your gifting request!" or "Here is a gift!") or Note;
    local NoteTextlabel = Interior:FindFirstChild("NoteTextlabel");

    if NoteTextlabel then
        setLabelChain(NoteTextlabel, v174);
    end;

    local Claim = Interior:FindFirstChild("Claim", true);
    local Reply = Interior:FindFirstChild("Reply", true);
    local Delete = Interior:FindFirstChild("Delete", true);
    local v175;

    if tonumber(u157.From) == nil then
        v175 = false;
    else
        v175 = tonumber(u157.From) > 0;
    end;

    local v176 = u62[u156] == true;

    if Claim and Claim:IsA("GuiButton") then
        if v159 then
            Claim.Visible = false;
        elseif v160 then
            if Reply and Reply:IsA("GuiButton") then
                Reply.Position = Claim.Position;
                Reply.Size = Claim.Size;
                Reply.AnchorPoint = Claim.AnchorPoint;
                Reply.LayoutOrder = Claim.LayoutOrder;
                Reply.ZIndex = Claim.ZIndex;
            end;

            Claim.Visible = false;
        else
            Claim.Visible = true;
            local v177;

            if typeof(u157) == "table" then
                v177 = u157.FromWorld;
            else
                v177 = nil;
            end;

            local u178 = (typeof(v177) ~= "string" or Worlds.Worlds[v177] == nil) and "Main" or v177;

            if v176 then
                setDisabledClaimLabel(Claim, "Blocked");
                local u179;

                if Delete == nil then
                    u179 = false;
                else
                    u179 = Delete:IsA("GuiButton");
                end;

                local v180 = Claim.Activated:Connect(function() -- Line: 862
                    -- upvalues: u179 (copy), NotificationController (ref), DupeProtection (ref), u1 (ref), u156 (copy)
                    if u179 then
                        NotificationController:CreateNotification(DupeProtection.TransferBlockedMessage);

                        return;
                    end;

                    u1:_declineGift(u156);
                end);
                table.insert(u7, v180);
            elseif u178 == Worlds.CurrentId then
                local v181 = Claim.Activated:Connect(function() -- Line: 879
                    -- upvalues: u1 (ref), u156 (copy), u157 (copy), Claim (copy)
                    u1:_claimGift(u156, u157, Claim);
                end);
                table.insert(u7, v181);
            else
                local v182 = Worlds.Worlds[u178];

                if v182 then
                    u178 = v182.DisplayName;
                end;

                setDisabledClaimLabel(Claim, (`Claim in {u178}!`));
                local v183 = Claim.Activated:Connect(function() -- Line: 875
                    -- upvalues: NotificationController (ref), u178 (copy)
                    NotificationController:CreateNotification((`This gift was sent in {u178} - claim it there!`));
                end);
                table.insert(u7, v183);
            end;
        end;
    end;

    if Reply and Reply:IsA("GuiButton") then
        if v175 then
            local v184 = Reply.Activated:Connect(function() -- Line: 888
                -- upvalues: u1 (ref), u157 (copy), u156 (copy)
                u1:_startReply(u157.From, u157.FromName, u156);
            end);
            table.insert(u7, v184);
            Reply.Visible = v159 or v160;
            Reply.Active = true;
        else
            Reply.Visible = false;
        end;
    end;

    if Delete and Delete:IsA("GuiButton") then
        Delete.Visible = v159 or v176;

        if v159 then
            local v185 = Delete.Activated:Connect(function() -- Line: 908
                -- upvalues: u1 (ref), u156 (copy)
                u1:_deleteReply(u156);
            end);
            table.insert(u7, v185);
        elseif v176 then
            setLabelChain(Delete, "Discard");
            local v186 = Delete.Activated:Connect(function() -- Line: 913
                -- upvalues: u1 (ref), u156 (copy)
                u1:_declineGift(u156);
            end);
            table.insert(u7, v186);
        end;
    end;

    if v159 then
        v162.LayoutOrder = 1;
    end;

    v162.Parent = u14;

    return v162;
end;

local function buildInviteClone(u187, p188) -- Line: 930
    -- upvalues: u17 (ref), u13 (ref), u14 (ref), MailboxItemCatalog (copy), u1 (copy)
    local v189 = u17 or u13;

    if v189 and u14 then
        return MailboxItemCatalog.BuildInviteVisual(v189, u14, u187, p188, function() -- Line: 942
            -- upvalues: u1 (ref), u187 (copy)
            u1:_respondInvite(u187, true);
        end, function() -- Line: 943
            -- upvalues: u1 (ref), u187 (copy)
            u1:_respondInvite(u187, false);
        end);
    end;

    return nil;
end;

local u190 = `#{Worlds.Worlds.FallHarvest.Color:ToHex()}`;

local function magicMailBadgeText() -- Line: 959
    -- upvalues: u190 (copy)
    return `<font color="{u190}">⸙ From Fall Harvest</font>`;
end;

local function buildMagicMailClone(u191, u192) -- Line: 968
    -- upvalues: u13 (ref), u14 (ref), Worlds (copy), u190 (copy), MailboxItemCatalog (copy), setLabelChain (copy), u1 (copy), u7 (copy), setDisabledClaimLabel (copy), NotificationController (copy)
    if not (u13 and u14) then
        return nil;
    end;

    local Item = u192.Item;

    if typeof(Item) ~= "table" then
        return nil;
    end;

    local v193 = u13:Clone();
    v193.Name = "MagicMail_" .. u191;
    v193.Visible = true;
    v193.Interactable = true;
    local Interior = v193:FindFirstChild("Interior");

    if not Interior then
        v193:Destroy();

        return nil;
    end;

    local MagicMailClaim = Worlds.Current.Features.MagicMailClaim;
    local TopFrame = Interior:FindFirstChild("TopFrame");

    if TopFrame then
        local SentPlayerNameTextLabel1 = TopFrame:FindFirstChild("SentPlayerNameTextLabel1");
        local SubjectLine1 = TopFrame:FindFirstChild("SubjectLine1");
        local u194 = `<font color="{u190}">⸙ From Fall Harvest</font>`;

        local function applyBadge(p195) -- Line: 991
            -- upvalues: u194 (copy)
            local function _(p196) -- Line: 995
                -- upvalues: u194 (ref)
                if not (p196:IsA("TextLabel") or p196:IsA("TextButton")) then
                    return;
                end;

                local TextColor3 = p196.TextColor3;

                if TextColor3.R + TextColor3.G + TextColor3.B < 0.25 then
                    p196.RichText = false;
                    p196.Text = "⸙ From Fall Harvest";

                    return;
                end;

                p196.RichText = true;
                p196.Text = u194;
            end;

            if p195:IsA("TextLabel") or p195:IsA("TextButton") then
                local TextColor3 = p195.TextColor3;

                if TextColor3.R + TextColor3.G + TextColor3.B < 0.25 then
                    p195.RichText = false;
                    p195.Text = "⸙ From Fall Harvest";
                else
                    p195.RichText = true;
                    p195.Text = u194;
                end;
            end;

            for _, descendant in p195:GetDescendants() do
                if descendant:IsA("TextLabel") or descendant:IsA("TextButton") then
                    local TextColor3 = descendant.TextColor3;

                    if TextColor3.R + TextColor3.G + TextColor3.B < 0.25 then
                        descendant.RichText = false;
                        descendant.Text = "⸙ From Fall Harvest";
                    else
                        descendant.RichText = true;
                        descendant.Text = u194;
                    end;
                end;
            end;
        end;

        if SentPlayerNameTextLabel1 then
            applyBadge(SentPlayerNameTextLabel1);
        end;

        if SubjectLine1 then
            applyBadge(SubjectLine1);
        end;

        local SentPlayerImageLabel = TopFrame:FindFirstChild("SentPlayerImageLabel");

        if SentPlayerImageLabel and SentPlayerImageLabel:IsA("ImageLabel") then
            local _, v197 = MailboxItemCatalog.Resolve(Item.Category, Item.ItemName, Item.Pet or Item.Fruit);

            if v197 ~= "" then
                SentPlayerImageLabel.Image = v197;
            end;
        end;
    end;

    local v198 = MailboxItemCatalog.Resolve(Item.Category, Item.ItemName, Item.Pet or Item.Fruit);
    local v199 = Item.Count or 1;
    local NoteTextlabel = Interior:FindFirstChild("NoteTextlabel");

    if NoteTextlabel then
        if v199 > 1 then
            v198 = `{v198} x{v199}`;
        end;

        setLabelChain(NoteTextlabel, (`Your {v198} arrived by Magic Mail!`));
    end;

    local Claim = Interior:FindFirstChild("Claim", true);
    local Reply = Interior:FindFirstChild("Reply", true);
    local Delete = Interior:FindFirstChild("Delete", true);

    if Reply and Reply:IsA("GuiButton") then
        Reply.Visible = false;
    end;

    if Delete and Delete:IsA("GuiButton") then
        Delete.Visible = false;
    end;

    if Claim and Claim:IsA("GuiButton") then
        Claim.Visible = true;

        if MagicMailClaim then
            local v200 = Claim.Activated:Connect(function() -- Line: 1043
                -- upvalues: u1 (ref), u191 (copy), u192 (copy), Claim (copy)
                u1:_claimMagicMail(u191, u192, Claim);
            end);
            table.insert(u7, v200);
        else
            setDisabledClaimLabel(Claim, "Claim in Garden Valley!");
            local v201 = Claim.Activated:Connect(function() -- Line: 1049
                -- upvalues: NotificationController (ref)
                NotificationController:CreateNotification("Claim your Magic Mail in Garden Valley!");
            end);
            table.insert(u7, v201);
        end;
    end;

    v193.Parent = u14;

    return v193;
end;

function u1._claimMagicMail(p202, u203, u204, u205) -- Line: 1059
    -- upvalues: u12 (copy), Networking (copy), NotificationController (copy), MailboxItemCatalog (copy), u11 (ref), u14 (ref), recomputeHasMail (copy)
    if u12[u203] then
        return;
    end;

    u12[u203] = true;

    if u205 then
        if u205:IsA("TextButton") or u205:IsA("ImageButton") then
            u205.AutoButtonColor = false;
        end;

        u205.Active = false;
    end;

    task.spawn(function() -- Line: 1069
        -- upvalues: Networking (ref), u203 (copy), u12 (ref), u205 (copy), NotificationController (ref), u204 (copy), MailboxItemCatalog (ref), u11 (ref), u14 (ref), recomputeHasMail (ref)
        local v206, v207, v208 = pcall(function() -- Line: 1070
            -- upvalues: Networking (ref), u203 (ref)
            return Networking.MagicMail.Claim:Fire(u203);
        end);
        u12[u203] = nil;

        if not v206 then
            if u205 then
                u205.Active = true;
            end;

            NotificationController:CreateNotification("Try again");

            return;
        end;

        if not v207 then
            if u205 then
                u205.Active = true;
            end;

            if v208 and v208 ~= "" then
                NotificationController:CreateNotification(v208);
            end;

            return;
        end;

        local Item = u204.Item;

        if typeof(Item) == "table" then
            local v209, v210 = MailboxItemCatalog.Resolve(Item.Category, Item.ItemName, Item.Pet or Item.Fruit);
            NotificationController:CreateItemClaimNotification(v210, Item.Count or 1, v209, nil);
        end;

        u11[u203] = nil;
        local v211 = u14 and u14:FindFirstChild("MagicMail_" .. u203);

        if v211 then
            v211:Destroy();
        end;

        recomputeHasMail();
    end);
end;

local function rebuildReceive() -- Line: 1110
    -- upvalues: pruneExpiredReplyPending (copy), recomputeHasMail (copy), u14 (ref), u13 (ref), u15 (ref), u9 (ref), u10 (ref), MagicMailFlags (copy), u11 (ref), u65 (copy), buildInviteClone (copy), buildGiftClone (copy), buildMagicMailClone (copy), u63 (copy), u16 (ref), updateInfoLabel (copy)
    pruneExpiredReplyPending();
    recomputeHasMail();

    if not (u14 and u13) then
        return;
    end;

    local u212 = nil;
    local u213 = 0;

    if u15 then
        u15 = false;
        u14.CanvasPosition = Vector2.zero;
    elseif u14.CanvasPosition.Y > 0 then
        local Y = u14.AbsolutePosition.Y;
        local v214 = (1 / 0);

        for _, child in u14:GetChildren() do
            if child:IsA("GuiObject") and child.Visible then
                local Name = child.Name;

                if (string.sub(Name, 1, 5) == "Gift_" or string.sub(Name, 1, 7) == "Invite_") and true or string.sub(Name, 1, 10) == "MagicMail_" then
                    local v215 = child.AbsolutePosition.Y - Y;

                    if -child.AbsoluteSize.Y * 0.5 <= v215 and v215 < v214 then
                        u212 = child.Name;
                        u213 = v215;
                        v214 = u213;
                        local v216 = u213;
                        u213 = v214;
                        v216 = v214;
                    end;
                end;
            end;
        end;
    end;

    for _, child in u14:GetChildren() do
        local Name = child.Name;

        if (string.sub(Name, 1, 5) == "Gift_" or string.sub(Name, 1, 7) == "Invite_") and true or string.sub(Name, 1, 10) == "MagicMail_" then
            child:Destroy();
        end;
    end;

    local v217 = {};

    for i, v in u9 do
        local v218 = {
            kind = "Gift",
            id = i,
            sortAt = tonumber(v.SentAt) or 0,
            payload = v
        };
        table.insert(v217, v218);
    end;

    for i, v in u10 do
        local v219 = {
            kind = "Invite",
            id = i,
            sortAt = tonumber(v.ReceivedAt or v.ExpiresAt) or 0,
            payload = v
        };
        table.insert(v217, v219);
    end;

    if MagicMailFlags.Enabled:Get() then
        for i, v in u11 do
            if typeof(v) == "table" and typeof(v.Item) == "table" then
                local v220 = {
                    kind = "MagicMail",
                    id = i,
                    sortAt = tonumber(v.SentAt) or 0,
                    payload = v
                };
                table.insert(v217, v220);
            end;
        end;
    end;

    for i, v in u65 do
        if u9[i] == nil then
            table.insert(v217, {
                kind = "Claimed",
                id = i,
                sortAt = v.SentAt,
                payload = {
                    From = v.From,
                    FromName = v.FromName,
                    Note = v.Note,
                    SentAt = v.SentAt
                }
            });
        end;
    end;

    table.sort(v217, function(p221, p222) -- Line: 1217
        return p221.sortAt > p222.sortAt;
    end);

    for _, v in v217 do
        if v.kind == "Invite" then
            buildInviteClone(v.id, v.payload);
        elseif v.kind == "Claimed" then
            buildGiftClone(v.id, v.payload, "claimed");
        elseif v.kind == "MagicMail" then
            buildMagicMailClone(v.id, v.payload);
        else
            buildGiftClone(v.id, v.payload);
        end;
    end;

    local v223 = {};

    for i, v in u63 do
        if u9[i] == nil and u65[i] == nil then
            table.insert(v223, {
                id = i,
                claimedAt = v.ClaimedAt,
                payload = {
                    From = v.From,
                    FromName = v.FromName,
                    Note = v.Note
                }
            });
        end;
    end;

    table.sort(v223, function(p224, p225) -- Line: 1251
        return p224.claimedAt > p225.claimedAt;
    end);

    for _, v in v223 do
        buildGiftClone(v.id, v.payload, "replyOnly");
    end;

    if u16 then
        u16();
    end;

    if u212 then
        local u226 = u14;
        task.defer(function() -- Line: 1269
            -- upvalues: u226 (copy), u212 (ref), u213 (ref)
            if not (u226 and u226.Parent) then
                return;
            end;

            local v227 = u226:FindFirstChild(u212);

            if not (v227 and v227:IsA("GuiObject")) then
                return;
            end;

            local v228 = v227.AbsolutePosition.Y - u226.AbsolutePosition.Y - u213;

            if math.abs(v228) < 0.5 then
                return;
            end;

            u226.CanvasPosition = Vector2.new(u226.CanvasPosition.X, (math.max(0, u226.CanvasPosition.Y + v228)));
        end);
    end;

    updateInfoLabel();
end;

function u1._respondInvite(p229, u230, u231) -- Line: 1285
    -- upvalues: u18 (copy), u14 (ref), u10 (ref), recomputeHasMail (copy), Networking (copy), NotificationController (copy)
    if u18[u230] then
        return;
    end;

    u18[u230] = true;
    local v232 = u14 and u14:FindFirstChild("Invite_" .. u230);

    if v232 then
        v232:Destroy();
    end;

    u10[u230] = nil;
    recomputeHasMail();
    task.spawn(function() -- Line: 1298
        -- upvalues: Networking (ref), u230 (copy), u231 (copy), u18 (ref), NotificationController (ref)
        local v233, v234, v235 = pcall(function() -- Line: 1299
            -- upvalues: Networking (ref), u230 (ref), u231 (ref)
            return Networking.Guild.RespondInvite:Fire(u230, u231);
        end);
        u18[u230] = nil;

        if not v233 then
            NotificationController:CreateNotification("Try again");

            return;
        end;

        if v234 then
            if u231 then
                NotificationController:CreateNotification("Joined guild!");
            end;

            return;
        end;

        if v235 and v235 ~= "" then
            NotificationController:CreateNotification(v235);
        end;
    end);
end;

local function scheduleReplyExpiry(u236) -- Line: 1321
    -- upvalues: u64 (copy), u63 (copy), MailboxFlags (copy), u14 (ref)
    local v237 = u64[u236];

    if v237 then
        task.cancel(v237);
        u64[u236] = nil;
    end;

    local v238 = u63[u236];

    if not v238 then
        return;
    end;

    local v239 = MailboxFlags.ReplyWindowSeconds:Get() - (workspace:GetServerTimeNow() - v238.ClaimedAt);
    u64[u236] = task.delay(v239 < 0 and 0 or v239, function() -- Line: 1335
        -- upvalues: u64 (ref), u236 (copy), u63 (ref), u14 (ref)
        u64[u236] = nil;
        u63[u236] = nil;
        local v240 = u14 and u14:FindFirstChild("Gift_" .. u236);

        if v240 then
            v240:Destroy();
        end;
    end);
end;

local function applyServerReplyable(p241, p242) -- Line: 1345
    -- upvalues: u64 (copy), u63 (copy), pruneExpiredReplyPending (copy), scheduleReplyExpiry (copy), rebuildReceive (copy)
    if typeof(p241) ~= "table" then
        return;
    end;

    for i, v in u64 do
        task.cancel(v);
        u64[i] = nil;
    end;

    table.clear(u63);

    for i, v in p241 do
        if typeof(i) == "string" and typeof(v) == "table" then
            local v243 = tonumber(v.From);
            local v244 = tonumber(v.ClaimedAt);

            if v243 and (v243 > 0 and v244) then
                local v245 = {
                    From = v243,
                    FromName = typeof(v.FromName) ~= "string" and "" or v.FromName
                };
                local v246;

                if typeof(v.Note) == "string" then
                    v246 = v.Note;
                else
                    v246 = nil;
                end;

                v245.Note = v246;
                v245.ClaimedAt = v244;
                u63[i] = v245;
            end;
        end;
    end;

    pruneExpiredReplyPending();

    for i in u63 do
        scheduleReplyExpiry(i);
    end;

    if not p242 then
        rebuildReceive();
    end;
end;

local function swapClaimToReplyInPlace(p247, p248) -- Line: 1382
    -- upvalues: u14 (ref), u2 (copy), setLabelChain (copy)
    local v249 = u14 and u14:FindFirstChild("Gift_" .. p247);

    if v249 then
        v249 = v249:FindFirstChild("Interior");
    end;

    if not v249 then
        return;
    end;

    local v250;

    if p248 and p248.Parent then
        v250 = p248;
    else
        v250 = v249:FindFirstChild("Claim", true);

        if v250 then
            if not v250:IsA("GuiButton") then
                v250 = p248;
            end;
        else
            v250 = p248;
        end;
    end;

    if not (v250 and v250:IsA("GuiButton")) then
        return;
    end;

    local Reply = v249:FindFirstChild("Reply", true);

    if not (Reply and Reply:IsA("GuiButton")) then
        v250.Active = false;
        v250.AutoButtonColor = false;
        v250.BackgroundColor3 = u2;

        if v250:IsA("ImageButton") then
            v250.ImageColor3 = u2;
        end;

        setLabelChain(v250, "Claimed");

        return;
    end;

    Reply.Position = v250.Position;
    Reply.Size = v250.Size;
    Reply.AnchorPoint = v250.AnchorPoint;
    Reply.LayoutOrder = v250.LayoutOrder;
    Reply.ZIndex = v250.ZIndex;
    v250.Visible = false;
    Reply.Active = true;
    Reply.Visible = true;
end;

local function applyClaimSuccess(p251, p252, p253) -- Line: 1416
    -- upvalues: MailboxItemCatalog (copy), LocalPlayer (copy), streakDisplay (copy), NotificationController (copy), u9 (ref), u65 (copy), recomputeHasMail (copy), swapClaimToReplyInPlace (copy), updateInfoLabel (copy), u14 (ref)
    if p252.Kind == "GuildReward" then
        MailboxItemCatalog.PlayGuildRewardClaimSFX();
    end;

    local v254 = nil;
    local v255 = tonumber(p252.From);

    if p252.Kind == nil and (v255 and (v255 > 0 and v255 ~= LocalPlayer.UserId)) then
        local v256, v257 = streakDisplay(v255);

        if v256 > 0 then
            v254 = (v257 and "⏳ " or "🔥 ") .. tostring(v256);
        end;
    end;

    local Items = p252.Items;

    if typeof(Items) == "table" and #Items > 0 then
        for i, v in ipairs(Items) do
            local v258, v259 = MailboxItemCatalog.Resolve(v.Category, v.ItemName, v.Pet or v.Fruit);
            local v260;

            if i == 1 then
                v260 = v254;
            else
                v260 = nil;
            end;

            NotificationController:CreateItemClaimNotification(v259, v.Count or 1, v258, v260);
        end;
    else
        local v261, v262 = MailboxItemCatalog.Resolve(p252.Category, p252.ItemName, p252.Payload);
        NotificationController:CreateItemClaimNotification(v262, 1, v261, v254);
    end;

    u9[p251] = nil;
    local v263 = tonumber(p252.From);

    if p252.Kind ~= nil or (not v263 or (v263 <= 0 or v263 == LocalPlayer.UserId)) then
        local v264 = u14 and u14:FindFirstChild("Gift_" .. p251);

        if v264 then
            v264:Destroy();
        end;

        recomputeHasMail();

        return;
    end;

    local v265 = {
        From = v263,
        FromName = typeof(p252.FromName) ~= "string" and "" or p252.FromName
    };
    local v266;

    if typeof(p252.Note) == "string" then
        v266 = p252.Note;
    else
        v266 = nil;
    end;

    v265.Note = v266;
    v265.SentAt = tonumber(p252.SentAt) or workspace:GetServerTimeNow();
    u65[p251] = v265;
    recomputeHasMail();
    swapClaimToReplyInPlace(p251, p253);
    updateInfoLabel();
end;

function u1._claimGift(p267, u268, u269, u270) -- Line: 1469
    -- upvalues: u61 (copy), Networking (copy), NotificationController (copy), DupeProtection (copy), u62 (copy), rebuildReceive (copy), applyClaimSuccess (copy)
    if u61[u268] then
        return;
    end;

    u61[u268] = true;

    if u270 then
        if u270:IsA("TextButton") or u270:IsA("ImageButton") then
            u270.AutoButtonColor = false;
        end;

        u270.Active = false;
    end;

    task.spawn(function() -- Line: 1483
        -- upvalues: Networking (ref), u268 (copy), u61 (ref), u270 (copy), NotificationController (ref), DupeProtection (ref), u62 (ref), rebuildReceive (ref), applyClaimSuccess (ref), u269 (copy)
        local v271, v272, v273 = pcall(function() -- Line: 1484
            -- upvalues: Networking (ref), u268 (ref)
            return Networking.Mailbox.Claim:Fire(u268);
        end);
        u61[u268] = nil;

        if not v271 then
            if u270 then
                u270.Active = true;
            end;

            NotificationController:CreateNotification("Try again");

            return;
        end;

        if v272 then
            applyClaimSuccess(u268, u269, u270);

            return;
        end;

        if u270 then
            u270.Active = true;
        end;

        if v273 and v273 ~= "" then
            NotificationController:CreateNotification(v273);
        end;

        if DupeProtection.IsTransferBlockedMessage(v273) and not u62[u268] then
            u62[u268] = true;
            rebuildReceive();
        end;
    end);
end;

function u1._declineGift(p274, u275) -- Line: 1518
    -- upvalues: u62 (copy), u9 (ref), u14 (ref), recomputeHasMail (copy), updateInfoLabel (copy), UpdateAcceptAllButton (copy), Networking (copy), NotificationController (copy)
    u62[u275] = nil;
    u9[u275] = nil;
    local v276 = u14 and u14:FindFirstChild("Gift_" .. u275);

    if v276 then
        v276:Destroy();
    end;

    recomputeHasMail();
    updateInfoLabel();
    UpdateAcceptAllButton();
    task.spawn(function() -- Line: 1526
        -- upvalues: Networking (ref), u275 (copy)
        pcall(function() -- Line: 1527
            -- upvalues: Networking (ref), u275 (ref)
            Networking.Mailbox.Decline:Fire(u275);
        end);
    end);
    NotificationController:CreateNotification("Gift discarded.");
end;

local function FinishClaimAllPass(p277) -- Line: 1536
    -- upvalues: u33 (ref), u34 (ref), UpdateAcceptAllButton (copy), u40 (copy), u61 (copy), u37 (ref), u35 (copy), u36 (copy), u38 (ref), applyClaimSuccess (copy), u39 (ref), NotificationController (copy)
    if not u33 then
        return;
    end;

    u33 = false;

    if type(p277) ~= "table" or p277.Ran ~= false then
        u34 = os.clock();
        task.delay(30, UpdateAcceptAllButton);
    end;

    for i in u40 do
        u61[i] = nil;
    end;

    table.clear(u40);

    if u37 then
        u37:Dismiss();
        u37 = nil;
    end;

    if type(p277) == "table" and type(p277.Claimed) == "table" then
        for _, v in p277.Claimed do
            local v278 = u35[v];

            if v278 and not u36[v] then
                u36[v] = true;
                u38 = u38 + 1;
                applyClaimSuccess(v, v278, nil);
            end;
        end;
    end;

    local v279 = u38;
    table.clear(u35);
    table.clear(u36);
    u38 = 0;
    u39 = 0;
    UpdateAcceptAllButton();

    if v279 > 0 then
        NotificationController:CreateNotification((`Claimed {v279} gift{v279 == 1 and "" or "s"}!`));
    end;

    local v280;

    if type(p277) == "table" then
        v280 = type(p277.Reason) ~= "string" and "" or p277.Reason;

        if v280 == "" and type(p277.Failed) == "table" then
            for _, v in p277.Failed do
                if type(v) == "table" and (type(v.Reason) == "string" and v.Reason ~= "") then
                    v280 = v.Reason;
                    break;
                end;
            end;
        end;
    else
        v280 = "";
    end;

    if v280 == "" then
        if v279 == 0 then
            NotificationController:CreateNotification("Try again");
        end;

        return;
    end;

    NotificationController:CreateNotification(v280);
end;

function u1._claimAllGifts(p281) -- Line: 1608
    -- upvalues: u33 (ref), NotificationController (copy), u34 (ref), u9 (ref), u61 (copy), u39 (ref), u38 (ref), u41 (ref), u35 (copy), u36 (copy), u40 (copy), UpdateAcceptAllButton (copy), u37 (ref), Networking (copy), FinishClaimAllPass (copy)
    if u33 then
        NotificationController:CreateNotification("Still claiming your mail...");

        return;
    end;

    local v282 = 30 - (os.clock() - u34);
    local v283 = v282 < 0 and 0 or v282;

    if v283 > 0 then
        NotificationController:CreateNotification((`Wait {math.ceil(v283)}s before claiming all again`));

        return;
    end;

    local v284 = {};

    for i, v in u9 do
        local v285;

        if type(v) == "table" then
            local Items = v.Items;

            if type(Items) == "table" then
                v285 = #Items > 0;
            elseif type(v.Category) == "string" then
                v285 = type(v.ItemName) == "string";
            else
                v285 = false;
            end;
        else
            v285 = false;
        end;

        if v285 and not u61[i] then
            table.insert(v284, {
                Id = i,
                Gift = v
            });
        end;
    end;

    if #v284 < 2 then
        NotificationController:CreateNotification("Nothing to claim");

        return;
    end;

    u33 = true;
    u39 = #v284;
    u38 = 0;
    u41 = u41 + 1;
    local u286 = u41;
    table.clear(u35);
    table.clear(u36);
    table.clear(u40);

    for _, v in v284 do
        u61[v.Id] = true;
        u40[v.Id] = true;
        u35[v.Id] = v.Gift;
    end;

    UpdateAcceptAllButton();
    u37 = NotificationController:CreateStickyNotification((`Claiming your mail... 0/{u39}`));

    if pcall(function() -- Line: 1658
        -- upvalues: Networking (ref)
        Networking.Mailbox.ClaimAll:Fire();
    end) then
        task.delay(300, function() -- Line: 1668
            -- upvalues: u33 (ref), u41 (ref), u286 (copy), FinishClaimAllPass (ref)
            if u33 and u41 == u286 then
                FinishClaimAllPass(nil);
            end;
        end);

        return;
    end;

    FinishClaimAllPass({
        Reason = "Try again",
        Ran = false,
        Claimed = {},
        Failed = {}
    });
end;

local function showTab(p287) -- Line: 1679
    -- upvalues: u50 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (copy), u1 (copy), updateInfoLabel (copy)
    u50 = p287;

    if u29 then
        u29.Visible = p287 == "Receive";
    end;

    if u26 then
        u26.Visible = p287 == "Send";
    end;

    if u30 then
        u30.Visible = p287 == "Send";
    end;

    if u31 then
        u31.Visible = p287 == "Receive";
    end;

    if u86 then
        u86.Visible = p287 == "Receive";
    end;

    UpdateAcceptAllButton();

    if p287 == "Send" then
        u1:_resetToPlayerList();
    end;

    updateInfoLabel();
end;

local u288 = {};

local function buildSendTemplate(u289, u290, p291, p292) -- Line: 1706
    -- upvalues: u19 (ref), u20 (ref), u288 (copy), setLabelChain (copy), applyHeadshot (copy), u7 (copy), u1 (copy), applyStreakToRow (copy)
    if not (u19 and u20) then
        return nil;
    end;

    if u288[u289] and u288[u289].Parent then
        return u288[u289];
    end;

    local v293 = u19:Clone();
    v293.Name = p292 .. "_" .. tostring(u289);
    v293.Visible = true;
    local Button = v293:FindFirstChild("Button");

    if not (Button and Button:IsA("GuiButton")) then
        v293:Destroy();

        return nil;
    end;

    local HoverFrame = Button:FindFirstChild("HoverFrame");

    if HoverFrame and HoverFrame:IsA("GuiObject") then
        HoverFrame.Visible = false;
    end;

    local PlayerDisplayName1 = Button:FindFirstChild("PlayerDisplayName1");

    if PlayerDisplayName1 then
        setLabelChain(PlayerDisplayName1, u290);
    end;

    local PlayerUsername = Button:FindFirstChild("PlayerUsername");

    if PlayerUsername and (PlayerUsername:IsA("TextLabel") or PlayerUsername:IsA("TextButton")) then
        PlayerUsername.Text = "@" .. p291;
    end;

    local PlayerDisplay = Button:FindFirstChild("PlayerDisplay");

    if PlayerDisplay then
        local PlayerImage = PlayerDisplay:FindFirstChild("PlayerImage");

        if PlayerImage and PlayerImage:IsA("ImageLabel") then
            applyHeadshot(PlayerImage, u289, v293);
        end;
    end;

    local v294 = Button.MouseEnter:Connect(function() -- Line: 1746
        -- upvalues: HoverFrame (copy)
        if HoverFrame and HoverFrame:IsA("GuiObject") then
            HoverFrame.Visible = true;
        end;
    end);
    table.insert(u7, v294);
    local v295 = Button.MouseLeave:Connect(function() -- Line: 1751
        -- upvalues: HoverFrame (copy)
        if HoverFrame and HoverFrame:IsA("GuiObject") then
            HoverFrame.Visible = false;
        end;
    end);
    table.insert(u7, v295);
    local v296 = Button.Activated:Connect(function() -- Line: 1756
        -- upvalues: u1 (ref), u289 (copy), u290 (copy)
        u1:_pickRecipient(u289, u290);
    end);
    table.insert(u7, v296);
    applyStreakToRow(v293, u289);
    v293.Parent = u20;
    u288[u289] = v293;

    return v293;
end;

local function clearPlayerList() -- Line: 1767
    -- upvalues: u20 (ref), u19 (ref), clearChildrenExcept (copy), u288 (copy), u54 (ref)
    if not (u20 and u19) then
        return;
    end;

    clearChildrenExcept(u20, {
        [u19] = true
    });
    table.clear(u288);
    u54 = nil;
end;

local function injectStreakPartners() -- Line: 1776
    -- upvalues: MailboxFlags (copy), u57 (ref), LocalPlayer (copy), u288 (copy), buildSendTemplate (copy)
    if not MailboxFlags.StreaksEnabled:Get() then
        return;
    end;

    for i, v in u57 do
        if v.Count > 0 and (i ~= LocalPlayer.UserId and not u288[i]) then
            local v297;

            if v.Name == "" then
                v297 = "User" .. tostring(i);
            else
                v297 = v.Name;
            end;

            buildSendTemplate(i, v297, v297, "Streak");
        end;
    end;
end;

local function populatePlayerList() -- Line: 1786
    -- upvalues: u20 (ref), u19 (ref), clearChildrenExcept (copy), u288 (copy), u54 (ref), Players (copy), LocalPlayer (copy), buildSendTemplate (copy), injectStreakPartners (copy), u5 (ref)
    if u20 and u19 then
        clearChildrenExcept(u20, {
            [u19] = true
        });
        table.clear(u288);
        u54 = nil;
    end;

    for _, v in Players:GetPlayers() do
        if v ~= LocalPlayer then
            buildSendTemplate(v.UserId, v.DisplayName, v.Name, "Server");
        end;
    end;

    injectStreakPartners();
    task.spawn(function() -- Line: 1798
        -- upvalues: Players (ref), LocalPlayer (ref), u5 (ref), u288 (ref), buildSendTemplate (ref)
        local success, result = pcall(function() -- Line: 1799
            -- upvalues: Players (ref), LocalPlayer (ref)
            return Players:GetFriendsAsync(LocalPlayer.UserId);
        end);

        if not (success and result) then
            return;
        end;

        local v298 = 0;

        while v298 < 30 do
            for _, v in result:GetCurrentPage() do
                if not (u5 and u5.Enabled) then
                    return;
                end;

                if v298 >= 30 then
                    break;
                end;

                local Id = v.Id;

                if Id and (Id ~= LocalPlayer.UserId and not u288[Id]) then
                    buildSendTemplate(Id, v.DisplayName or v.Username, v.Username, "Friend");
                    v298 = v298 + 1;
                end;
            end;

            if result.IsFinished or not pcall(function() -- Line: 1818
                -- upvalues: result (copy)
                result:AdvanceToNextPageAsync();
            end) then
                break;
            end;
        end;
    end);
end;

local function refreshStreakRows() -- Line: 1827
    -- upvalues: u288 (copy), u54 (ref), applyStreakToRow (copy), injectStreakPartners (copy)
    for i, v in u288 do
        if v.Parent and v ~= u54 then
            applyStreakToRow(v, i);
        end;
    end;

    injectStreakPartners();
end;

local function fetchStreaks() -- Line: 1837
    -- upvalues: MailboxFlags (copy), Networking (copy), u57 (ref), u5 (ref), u50 (ref), u52 (ref), refreshStreakRows (copy), rebuildReceive (copy)
    if not MailboxFlags.StreaksEnabled:Get() then
        return;
    end;

    task.spawn(function() -- Line: 1839
        -- upvalues: Networking (ref), u57 (ref), u5 (ref), u50 (ref), u52 (ref), refreshStreakRows (ref), rebuildReceive (ref)
        local success, result = pcall(function() -- Line: 1840
            -- upvalues: Networking (ref)
            return Networking.Mailbox.GetStreaks:Fire();
        end);

        if not success or type(result) ~= "table" then
            return;
        end;

        local v299 = {};

        for _, v in result do
            if type(v) == "table" and type(v.UserId) == "number" then
                v299[v.UserId] = {
                    Count = type(v.Count) ~= "number" and 0 or v.Count,
                    Name = type(v.Name) ~= "string" and "" or v.Name,
                    LastDay = type(v.LastDay) ~= "number" and 0 or v.LastDay
                };
            end;
        end;

        u57 = v299;

        if u5 and u5.Enabled then
            if u50 == "Send" and not u52 then
                refreshStreakRows();
            end;

            rebuildReceive();
        end;
    end);
end;

local function isValidUsernameLocal(p300) -- Line: 1870
    if #p300 < 3 or #p300 > 20 then
        return false;
    end;

    return string.match(p300, "^[%w_]+$") ~= nil;
end;

local function onSearchFocusLost(p301) -- Line: 1875
    -- upvalues: u21 (ref), Networking (copy), u5 (ref), u52 (ref), u54 (ref), buildSendTemplate (copy)
    if not u21 then
        return;
    end;

    local u302 = string.gsub(u21.Text or "", "^%s*@?(.-)%s*$", "%1");

    if u302 == "" then
        return;
    end;

    local v303;

    if #u302 < 3 or #u302 > 20 then
        v303 = false;
    else
        v303 = string.match(u302, "^[%w_]+$") ~= nil;
    end;

    if not v303 then
        return;
    end;

    task.spawn(function() -- Line: 1882
        -- upvalues: Networking (ref), u302 (copy), u5 (ref), u52 (ref), u54 (ref), buildSendTemplate (ref)
        local v304, v305, v306 = pcall(function() -- Line: 1883
            -- upvalues: Networking (ref), u302 (ref)
            return Networking.Mailbox.LookupPlayer:Fire(u302);
        end);

        if not v304 or (typeof(v305) ~= "number" or v305 <= 0) then
            return;
        end;

        if not (u5 and u5.Enabled) then
            return;
        end;

        if u52 then
            return;
        end;

        if u54 then
            u54:Destroy();
            u54 = nil;
        end;

        if v306 == "" or not v306 then
            v306 = u302;
        end;

        local v307 = buildSendTemplate(v305, v306, u302, "Search");

        if v307 then
            u54 = v307;
            v307.LayoutOrder = -1000000;
        end;
    end);
end;

local function onSearchTextChanged() -- Line: 1906
    -- upvalues: u54 (ref)
    if u54 then
        u54:Destroy();
        u54 = nil;
    end;
end;

local function totalSelected() -- Line: 1917
    -- upvalues: u58 (copy)
    local v308 = 0;

    for _, v in u58 do
        v308 = v308 + v.Selected;
    end;

    return v308;
end;

local function updateCanSendFrame() -- Line: 1925
    -- upvalues: u45 (ref), u58 (copy)
    if not u45 then
        return;
    end;

    local v309 = 0;

    for _, v in u58 do
        v309 = v309 + v.Selected;
    end;

    u45.Visible = v309 == 0;
end;

local u310 = {};

local function isGiftableInventoryEntry(p311, p312, p313) -- Line: 1932
    -- upvalues: MailboxItemCatalog (copy), u310 (copy)
    if not MailboxItemCatalog.IsGiftable(p311) then
        return false;
    end;

    if p311 == "HarvestedFruits" then
        local v314;

        if typeof(p313) == "table" then
            v314 = p313.Id ~= nil;
        else
            v314 = false;
        end;

        return v314;
    end;

    if p311 ~= "Pets" then
        local v315;

        if typeof(p313) == "number" then
            v315 = p313 > 0;
        else
            v315 = false;
        end;

        return v315;
    end;

    if typeof(p313) ~= "table" or p313.Id == nil then
        return false;
    end;

    if u310[p312] then
        return false;
    end;

    return p313.Equipped ~= true;
end;

local function getClickableButtons(p316) -- Line: 1950
    local v317 = { p316 };

    for _, descendant in p316:GetDescendants() do
        if descendant:IsA("GuiButton") then
            table.insert(v317, descendant);
        end;
    end;

    return v317;
end;

local function applyPetVisualStyle(p318, p319, p320) -- Line: 1967
    -- upvalues: PetTypes (copy), AnimatedGradient (copy)
    if not p318 then
        return;
    end;

    local v321;

    if p319 == "Pets" and typeof(p320) == "table" then
        v321 = p320.Type == PetTypes.Rainbow;
    else
        v321 = false;
    end;

    if v321 then
        AnimatedGradient:AddRainbowColor(p318, "ImageColor3");

        return;
    end;

    AnimatedGradient:Remove(p318);
    p318.ImageColor3 = Color3.new(1, 1, 1);
end;

local function formatTileAmount(p322, p323, p324) -- Line: 1983
    return p322 == "Pets" and "" or "x" .. tostring(p323);
end;

local function bindInventoryTile(p325, u326, u327, u328, p329, p330, p331, u332) -- Line: 1990
    -- upvalues: applyPetVisualStyle (copy), setLabelChain (copy), getClickableButtons (copy), TweenService (copy), u4 (copy), u1 (copy), u7 (copy), u3 (copy)
    p325.Visible = true;
    local Frame = p325:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    local Button = Frame:FindFirstChild("Button");

    if not (Button and Button:IsA("GuiButton")) then
        return;
    end;

    local ItemImage = Button:FindFirstChild("ItemImage");

    if ItemImage and ItemImage:IsA("ImageLabel") then
        ItemImage.Image = p330;
        applyPetVisualStyle(ItemImage, u327, u332);
    end;

    local AmountTextLabel1 = Button:FindFirstChild("AmountTextLabel1");

    if AmountTextLabel1 then
        setLabelChain(AmountTextLabel1, u327 == "Pets" and "" or "x" .. tostring(p331));
    end;

    local SendFlash = Button:FindFirstChild("SendFlash");

    if SendFlash and SendFlash:IsA("Frame") then
        SendFlash.BackgroundTransparency = 1;
    end;

    local function onClick(p333) -- Line: 2019
        -- upvalues: SendFlash (copy), TweenService (ref), u4 (ref), u1 (ref), u326 (copy), u327 (copy), u328 (copy), u332 (copy)
        if SendFlash then
            SendFlash.BackgroundTransparency = 0.25;
            TweenService:Create(SendFlash, u4, {
                BackgroundTransparency = 0.75
            }):Play();
        end;

        u1:_addToSend(u326, u327, u328, u332);
    end;

    for _, v in getClickableButtons(Button) do
        local v334 = v.Activated:Connect(function() -- Line: 2028
            -- upvalues: onClick (copy), v (copy)
            onClick(v);
        end);
        table.insert(u7, v334);

        if SendFlash then
            local v335 = v.MouseEnter:Connect(function() -- Line: 2032
                -- upvalues: TweenService (ref), SendFlash (copy), u3 (ref)
                TweenService:Create(SendFlash, u3, {
                    BackgroundTransparency = 0.75
                }):Play();
            end);
            table.insert(u7, v335);
            local v336 = v.MouseLeave:Connect(function() -- Line: 2035
                -- upvalues: TweenService (ref), SendFlash (copy), u3 (ref)
                TweenService:Create(SendFlash, u3, {
                    BackgroundTransparency = 1
                }):Play();
            end);
            table.insert(u7, v336);
        end;
    end;
end;

local function rebuildInventory() -- Line: 2042
    -- upvalues: u23 (ref), u22 (ref), u51 (ref), updateInfoLabel (copy), clearChildrenExcept (copy), PlayerStateClient (copy), MailboxItemCatalog (copy), isGiftableInventoryEntry (copy), u58 (copy), bindInventoryTile (copy)
    if not (u23 and u22) then
        u51 = 0;
        updateInfoLabel();

        return;
    end;

    clearChildrenExcept(u23, {
        [u22] = true
    });
    local v337 = 0;
    local v338 = PlayerStateClient:GetLocalReplica();

    if not v338 then
        u51 = v337;
        updateInfoLabel();

        return;
    end;

    local v339 = v338.Data and v338.Data.Inventory;

    if typeof(v339) ~= "table" then
        u51 = v337;
        updateInfoLabel();

        return;
    end;

    for _, v in MailboxItemCatalog.Categories do
        local v340 = v339[v];

        if typeof(v340) == "table" then
            if v == "HarvestedFruits" or v == "Pets" then
                for i, v2 in v340 do
                    if isGiftableInventoryEntry(v, i, v2) then
                        local v341 = v .. ":" .. i;
                        local v342 = 1 - (u58[v341] and (u58[v341].Selected or 0) or 0);

                        if v342 > 0 then
                            local v343, v344 = MailboxItemCatalog.Resolve(v, i, v2);
                            local v345 = u22:Clone();
                            v345.Name = "Inv_" .. v341;
                            v345.Parent = u23;
                            bindInventoryTile(v345, v341, v, i, v343, v344, v342, v2);
                            v337 = v337 + 1;
                        end;
                    end;
                end;
            else
                for i, v2 in v340 do
                    if isGiftableInventoryEntry(v, i, v2) then
                        local v346 = v .. ":" .. i;
                        local v347 = v2 - (u58[v346] and (u58[v346].Selected or 0) or 0);

                        if v347 > 0 then
                            local v348, v349 = MailboxItemCatalog.Resolve(v, i, nil);
                            local v350 = u22:Clone();
                            v350.Name = "Inv_" .. v346;
                            v350.Parent = u23;
                            bindInventoryTile(v350, v346, v, i, v348, v349, v347, nil);
                            v337 = v337 + 1;
                        end;
                    end;
                end;
            end;
        end;
    end;

    u51 = v337;
    updateInfoLabel();
end;

local function bindSendingTile(p351, u352, p353, p354, p355, p356, p357) -- Line: 2112
    -- upvalues: applyPetVisualStyle (copy), setLabelChain (copy), u7 (copy), u1 (copy)
    p351.Visible = true;
    local Frame = p351:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    local Button = Frame:FindFirstChild("Button");

    if not (Button and Button:IsA("GuiButton")) then
        return;
    end;

    local ItemImage = Button:FindFirstChild("ItemImage");

    if ItemImage and ItemImage:IsA("ImageLabel") then
        ItemImage.Image = p354;
        applyPetVisualStyle(ItemImage, p356, p357);
    end;

    local AmountTextLabel1 = Button:FindFirstChild("AmountTextLabel1");

    if AmountTextLabel1 then
        setLabelChain(AmountTextLabel1, p356 == "Pets" and "" or "x" .. tostring(p355));
    end;

    local RemoveHoverFrame = Button:FindFirstChild("RemoveHoverFrame");

    if RemoveHoverFrame and RemoveHoverFrame:IsA("GuiObject") then
        RemoveHoverFrame.Visible = false;
        local v358 = Button.MouseEnter:Connect(function() -- Line: 2133
            -- upvalues: RemoveHoverFrame (copy)
            RemoveHoverFrame.Visible = true;
        end);
        table.insert(u7, v358);
        local v359 = Button.MouseLeave:Connect(function() -- Line: 2136
            -- upvalues: RemoveHoverFrame (copy)
            RemoveHoverFrame.Visible = false;
        end);
        table.insert(u7, v359);
    end;

    local v360 = Button.Activated:Connect(function() -- Line: 2141
        -- upvalues: u1 (ref), u352 (copy)
        u1:_removeFromSend(u352);
    end);
    table.insert(u7, v360);
end;

local function rebuildSending() -- Line: 2146
    -- upvalues: u25 (ref), u24 (ref), clearChildrenExcept (copy), u58 (copy), MailboxItemCatalog (copy), bindSendingTile (copy), u45 (ref)
    if not (u25 and u24) then
        return;
    end;

    clearChildrenExcept(u25, {
        [u24] = true
    });

    for i, v in u58 do
        if v.Selected > 0 then
            local v361, v362 = MailboxItemCatalog.Resolve(v.Category, v.ItemKey, v.EntryValue);
            local v363 = u24:Clone();
            v363.Name = "Send_" .. i;
            v363.Parent = u25;
            bindSendingTile(v363, i, v361, v362, v.Selected, v.Category, v.EntryValue);
        end;
    end;

    if not u45 then
        return;
    end;

    local v364 = 0;

    for _, v in u58 do
        v364 = v364 + v.Selected;
    end;

    u45.Visible = v364 == 0;
end;

function u1._addToSend(p365, p366, p367, p368, p369) -- Line: 2162
    -- upvalues: u58 (copy), NotificationController (copy), rebuildInventory (copy), rebuildSending (copy)
    local v370 = 0;

    for _, v in u58 do
        v370 = v370 + v.Selected;
    end;

    if v370 >= 20 then
        NotificationController:CreateNotification(string.format("Up to %d items per gift", 20));

        return;
    end;

    local v371 = u58[p366];

    if not v371 then
        v371 = {
            Selected = 0,
            Category = p367,
            ItemKey = p368,
            EntryValue = p369
        };
        u58[p366] = v371;
    end;

    v371.Selected = v371.Selected + 1;
    rebuildInventory();
    rebuildSending();
end;

function u1._removeFromSend(p372, p373) -- Line: 2179
    -- upvalues: u58 (copy), rebuildInventory (copy), rebuildSending (copy)
    local v374 = u58[p373];

    if not v374 then
        return;
    end;

    v374.Selected = v374.Selected - 1;

    if v374.Selected <= 0 then
        u58[p373] = nil;
    end;

    rebuildInventory();
    rebuildSending();
end;

local function clearSelected() -- Line: 2190
    -- upvalues: u58 (copy), rebuildSending (copy), rebuildInventory (copy)
    table.clear(u58);
    rebuildSending();
    rebuildInventory();
end;

function u1._resetToPlayerList(p375) -- Line: 2200
    -- upvalues: u52 (ref), u66 (ref), u67 (ref), u27 (ref), u28 (ref), u58 (copy), rebuildSending (copy), rebuildInventory (copy), u46 (ref), u21 (ref), populatePlayerList (copy), updateInfoLabel (copy)
    u52 = nil;
    u66 = nil;
    u67 = nil;

    if u27 then
        u27.Visible = false;
    end;

    if u28 then
        u28.Visible = true;
    end;

    table.clear(u58);
    rebuildSending();
    rebuildInventory();

    if u46 then
        u46.Text = "";
    end;

    if u21 then
        u21.Text = "";
    end;

    populatePlayerList();
    updateInfoLabel();
end;

function u1._pickRecipient(p376, u377, p378) -- Line: 2213
    -- upvalues: u66 (ref), u67 (ref), u52 (ref), u28 (ref), u27 (ref), u48 (ref), setLabelChain (copy), u47 (ref), MailboxItemCatalog (copy), u5 (ref), u58 (copy), rebuildSending (copy), rebuildInventory (copy), u46 (ref), updateInfoLabel (copy)
    u66 = nil;
    u67 = nil;
    u52 = {
        userId = u377,
        displayName = p378
    };

    if u28 then
        u28.Visible = false;
    end;

    if u27 then
        u27.Visible = true;
    end;

    if u48 then
        setLabelChain(u48, "Send to " .. p378);
    end;

    if u47 then
        local v379 = MailboxItemCatalog.GetCachedHeadshot(u377);

        if v379 and v379 ~= "" then
            u47.Image = v379;
        else
            task.spawn(function() -- Line: 2231
                -- upvalues: MailboxItemCatalog (ref), u377 (copy), u5 (ref), u47 (ref)
                local v380 = MailboxItemCatalog.GetHeadshot(u377);

                if v380 ~= "" and (u5 and u5.Enabled) then
                    u47.Image = v380;
                end;
            end);
        end;
    end;

    table.clear(u58);
    rebuildSending();
    rebuildInventory();

    if u46 then
        u46.Text = "";
    end;

    rebuildInventory();
    rebuildSending();
    updateInfoLabel();
end;

function u1._startReply(p381, p382, p383, p384) -- Line: 2248
    -- upvalues: u50 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (copy), u1 (copy), updateInfoLabel (copy), u66 (ref), u67 (ref)
    local v385 = tonumber(p382);

    if not v385 or v385 <= 0 then
        return;
    end;

    u50 = "Send";

    if u29 then
        u29.Visible = false;
    end;

    if u26 then
        u26.Visible = true;
    end;

    if u30 then
        u30.Visible = true;
    end;

    if u31 then
        u31.Visible = false;
    end;

    if u86 then
        u86.Visible = false;
    end;

    UpdateAcceptAllButton();
    u1:_resetToPlayerList();
    updateInfoLabel();
    u1:_pickRecipient(v385, (typeof(p383) ~= "string" or p383 == "") and "Player" or p383);
    u66 = p384;
    u67 = v385;
end;

function u1.OpenComposeFor(p386, p387, p388) -- Line: 2263
    -- upvalues: MailboxFlags (copy), NotificationController (copy), u53 (ref), GuiController (copy), u50 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (copy), u1 (copy), updateInfoLabel (copy)
    if typeof(p387) ~= "number" or p387 <= 0 then
        return;
    end;

    if not MailboxFlags.OpenEnabled:Get() then
        NotificationController:CreateNotification("The mailbox is currently unavailable.");

        return;
    end;

    local v389 = (typeof(p388) ~= "string" or p388 == "") and "Player" or p388;
    u53 = {
        userId = p387,
        displayName = v389
    };

    if not GuiController:IsOpen("MailboxUI") then
        GuiController:Open("MailboxUI", nil, { "HUD", "TeleportButtons" });

        return;
    end;

    u50 = "Send";

    if u29 then
        u29.Visible = false;
    end;

    if u26 then
        u26.Visible = true;
    end;

    if u30 then
        u30.Visible = true;
    end;

    if u31 then
        u31.Visible = false;
    end;

    if u86 then
        u86.Visible = false;
    end;

    UpdateAcceptAllButton();
    u1:_resetToPlayerList();
    updateInfoLabel();
    u1:_pickRecipient(p387, v389);
    u53 = nil;
end;

local function removeClaimedReply(u390) -- Line: 2282
    -- upvalues: u65 (copy), u63 (copy), u64 (copy), u14 (ref), recomputeHasMail (copy), updateInfoLabel (copy), Networking (copy)
    u65[u390] = nil;
    u63[u390] = nil;
    local v391 = u64[u390];

    if v391 then
        task.cancel(v391);
        u64[u390] = nil;
    end;

    local v392 = u14 and u14:FindFirstChild("Gift_" .. u390);

    if v392 then
        v392:Destroy();
    end;

    recomputeHasMail();
    updateInfoLabel();
    task.spawn(function() -- Line: 2294
        -- upvalues: Networking (ref), u390 (copy)
        pcall(function() -- Line: 2295
            -- upvalues: Networking (ref), u390 (ref)
            Networking.Mailbox.DeleteReplyable:Fire(u390);
        end);
    end);
end;

function u1._deleteReply(p393, p394) -- Line: 2303
    -- upvalues: removeClaimedReply (copy)
    removeClaimedReply(p394);
end;

local function sendBatch() -- Line: 2307
    -- upvalues: u59 (ref), u52 (ref), u58 (copy), u60 (ref), u46 (ref), u66 (ref), u67 (ref), u43 (ref), Networking (copy), NotificationController (copy), u1 (copy), removeClaimedReply (copy), rebuildReceive (copy), u50 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (copy), updateInfoLabel (copy)
    if u59 then
        return;
    end;

    if not u52 then
        return;
    end;

    local v395 = 0;

    for _, v in u58 do
        v395 = v395 + v.Selected;
    end;

    if v395 == 0 then
        return;
    end;

    local v396 = os.clock();

    if v396 - u60 < 1.5 then
        return;
    end;

    u60 = v396;
    local u397 = {};

    for _, v in u58 do
        if v.Selected > 0 then
            table.insert(u397, {
                Category = v.Category,
                ItemKey = v.ItemKey,
                Count = v.Selected
            });
        end;
    end;

    if #u397 == 0 then
        return;
    end;

    local u398 = u46 and u46.Text or "";
    local userId = u52.userId;
    local u399;

    if u66 and u67 == userId then
        u399 = u66;
    else
        u399 = nil;
    end;

    u59 = true;

    if u43 then
        u43.Active = false;
    end;

    task.spawn(function() -- Line: 2336
        -- upvalues: Networking (ref), userId (copy), u397 (copy), u398 (copy), u59 (ref), u43 (ref), NotificationController (ref), u1 (ref), u399 (copy), removeClaimedReply (ref), rebuildReceive (ref), u50 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (ref), updateInfoLabel (ref)
        local v400, v401, v402 = pcall(function() -- Line: 2337
            -- upvalues: Networking (ref), userId (ref), u397 (ref), u398 (ref)
            return Networking.Mailbox.SendBatch:Fire(userId, u397, u398);
        end);
        u59 = false;

        if u43 then
            u43.Active = true;
        end;

        if v400 then
            if v401 then
                NotificationController:CreateNotification((v402 == "" or not v402) and "Gift sent!" or v402);
                u1:_resetToPlayerList();

                if u399 then
                    removeClaimedReply(u399);
                    rebuildReceive();
                    u50 = "Receive";

                    if u29 then
                        u29.Visible = true;
                    end;

                    if u26 then
                        u26.Visible = false;
                    end;

                    if u30 then
                        u30.Visible = false;
                    end;

                    if u31 then
                        u31.Visible = true;
                    end;

                    if u86 then
                        u86.Visible = true;
                    end;

                    UpdateAcceptAllButton();
                    updateInfoLabel();

                    return;
                end;
            else
                NotificationController:CreateNotification((v402 == "" or not v402) and "Could not send gift" or v402);
            end;

            return;
        end;

        NotificationController:CreateNotification("Try again");
    end);
end;

local function clampNoteText() -- Line: 2370
    -- upvalues: u46 (ref)
    if not u46 then
        return;
    end;

    local Text = u46.Text;

    if not utf8.len(Text) or utf8.len(Text) <= 100 then
        if #Text > 400 then
            u46.Text = string.sub(Text, 1, 100);
        end;

        return;
    end;

    utf8.offset(Text, 101);
    local v403 = utf8.offset(Text, 101);

    if v403 then
        u46.Text = string.sub(Text, 1, v403 - 1);

        return;
    end;

    u46.Text = string.sub(Text, 1, 100);
end;

local function bindNoteTextBox() -- Line: 2388
    -- upvalues: u46 (ref), clampNoteText (copy), u8 (copy)
    if not u46 then
        return;
    end;

    u46.PlaceholderText = "Add a note (optional)";
    u46.ClearTextOnFocus = false;
    local v404 = u46:GetPropertyChangedSignal("Text"):Connect(clampNoteText);
    table.insert(u8, v404);
end;

local function findExitButton(p405) -- Line: 2399
    local ExitButton = p405:FindFirstChild("ExitButton", true);

    if ExitButton and ExitButton:IsA("GuiButton") then
        return ExitButton;
    end;

    return nil;
end;

local function bindExitButton(p406) -- Line: 2407
    -- upvalues: GuiController (copy), u8 (copy)
    local u407 = {};

    local function tryBind(p408) -- Line: 2410
        -- upvalues: u407 (copy), GuiController (ref)
        if u407[p408] then
            return;
        end;

        u407[p408] = p408.Activated:Connect(function() -- Line: 2412
            -- upvalues: GuiController (ref)
            if GuiController:IsOpen("MailboxUI") then
                GuiController:Close();
            end;
        end);
    end;

    local ExitButton = p406:FindFirstChild("ExitButton", true);

    if not (ExitButton and ExitButton:IsA("GuiButton")) then
        ExitButton = nil;
    end;

    if ExitButton and not u407[ExitButton] then
        u407[ExitButton] = ExitButton.Activated:Connect(function() -- Line: 2412
            -- upvalues: GuiController (ref)
            if GuiController:IsOpen("MailboxUI") then
                GuiController:Close();
            end;
        end);
    end;

    local v410 = p406.DescendantAdded:Connect(function(p409) -- Line: 2424
        -- upvalues: u407 (copy), GuiController (ref)
        if p409.Name == "ExitButton" and p409:IsA("GuiButton") then
            if u407[p409] then
                return;
            end;

            u407[p409] = p409.Activated:Connect(function() -- Line: 2412
                -- upvalues: GuiController (ref)
                if GuiController:IsOpen("MailboxUI") then
                    GuiController:Close();
                end;
            end);
        end;
    end);
    table.insert(u8, v410);
end;

local function resolveRefs(p411) -- Line: 2431
    -- upvalues: u49 (ref), u30 (ref), u31 (ref), u86 (ref), u89 (ref), u90 (ref), updateCapacityLabel (copy), u42 (ref), u68 (ref), u32 (ref), u1 (copy), u8 (copy), UpdateAcceptAllButton (copy), u29 (ref), u13 (ref), u14 (ref), bindReceiveCanvasSize (copy), u17 (ref), u26 (ref), u27 (ref), u48 (ref), u47 (ref), u46 (ref), u43 (ref), u44 (ref), u45 (ref), u23 (ref), u22 (ref), u25 (ref), u24 (ref), u28 (ref), u20 (ref), u19 (ref), u21 (ref)
    local Frame = p411:WaitForChild("Frame", 10);

    if not Frame then
        return;
    end;

    local Info = Frame:FindFirstChild("Info");

    if Info and Info:IsA("TextLabel") then
        u49 = Info;
    end;

    local Header = Frame:WaitForChild("Header", 5);

    if Header then
        u30 = Header:FindFirstChild("ToggleButtonSend");
        u31 = Header:FindFirstChild("ToggleButtonRecieve");
        u86 = Header:FindFirstChild("Capacity");

        if u86 then
            u89 = u86.Position;
            u90 = u86.Size;
        end;

        updateCapacityLabel();

        if u30 then
            local Text = u30:FindFirstChild("Text");

            if Text then
                Text = Text:FindFirstChild("Notification");
            end;

            if Text and Text:IsA("Frame") then
                u42 = Text;
            end;
        end;

        if u42 then
            u42.Visible = u68;
        end;
    end;

    local AcceptAll = Frame:FindFirstChild("AcceptAll", true);

    if AcceptAll and AcceptAll:IsA("GuiButton") then
        u32 = AcceptAll;
        AcceptAll.Visible = false;
        local v412 = AcceptAll.Activated:Connect(function() -- Line: 2470
            -- upvalues: u1 (ref)
            u1:_claimAllGifts();
        end);
        table.insert(u8, v412);
    end;

    UpdateAcceptAllButton();
    u29 = Frame:FindFirstChild("RecieveFrame");

    if u29 then
        u13 = u29:FindFirstChild("GiftTemplate");
        u14 = u29;

        if u13 then
            u13.Visible = false;
        end;

        bindReceiveCanvasSize(u29);
        u17 = u29:FindFirstChild("GuildInviteTemplate");

        if u17 then
            u17.Visible = false;
        end;
    end;

    u26 = Frame:FindFirstChild("SendingFrame");

    if not u26 then
        return;
    end;

    u27 = u26:FindFirstChild("ItemSendFrame");

    if u27 then
        u48 = u27:FindFirstChild("Sending");
        u47 = u27:FindFirstChild("PlayerImage");
        u46 = u27:FindFirstChild("NoteTextBox");
        u43 = u27:FindFirstChild("SendButton");
        u44 = u27:FindFirstChild("CancelButton");

        if u43 then
            u45 = u43:FindFirstChild("CanSendFrame");
        end;

        local ScrollingFrames = u27:FindFirstChild("ScrollingFrames");

        if ScrollingFrames then
            u23 = ScrollingFrames:FindFirstChild("InventoryFrame");
            u22 = u23 and u23:FindFirstChild("ItemFrameTemplate");

            if u22 then
                u22.Visible = false;
            end;

            u25 = ScrollingFrames:FindFirstChild("SendingFrame");
            u24 = u25 and u25:FindFirstChild("ItemFrameTemplate");

            if u24 then
                u24.Visible = false;
            end;
        end;
    end;

    u28 = u26:FindFirstChild("SelectPlayerFrame");

    if u28 then
        u20 = u28:FindFirstChild("PlayerList");

        if u20 then
            local v413 = u20:FindFirstChildWhichIsA("UIListLayout") or u20:FindFirstChildWhichIsA("UIGridLayout");

            if v413 then
                v413.SortOrder = Enum.SortOrder.LayoutOrder;
            end;

            u19 = u20:FindFirstChild("SendTemplate");

            if u19 then
                u19.Visible = false;
            end;
        end;

        local Topbar = u28:FindFirstChild("Topbar");

        if Topbar then
            u21 = Topbar:FindFirstChild("SearchBox");
        end;
    end;
end;

local function bindChrome(p414) -- Line: 2542
    -- upvalues: u6 (ref), resolveRefs (copy), bindExitButton (copy), u46 (ref), clampNoteText (copy), u8 (copy), updateInfoLabel (copy), u30 (ref), u50 (ref), u29 (ref), u26 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (copy), u1 (copy), u44 (ref), u43 (ref), sendBatch (copy), u21 (ref), onSearchFocusLost (copy), onSearchTextChanged (copy)
    if u6 then
        return;
    end;

    u6 = true;
    resolveRefs(p414);
    bindExitButton(p414);

    if u46 then
        u46.PlaceholderText = "Add a note (optional)";
        u46.ClearTextOnFocus = false;
        local v415 = u46:GetPropertyChangedSignal("Text"):Connect(clampNoteText);
        table.insert(u8, v415);
    end;

    updateInfoLabel();

    if u30 then
        local v416 = u30.Activated:Connect(function() -- Line: 2554
            -- upvalues: u50 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (ref), updateInfoLabel (ref)
            u50 = "Receive";

            if u29 then
                u29.Visible = true;
            end;

            if u26 then
                u26.Visible = false;
            end;

            if u30 then
                u30.Visible = false;
            end;

            if u31 then
                u31.Visible = true;
            end;

            if u86 then
                u86.Visible = true;
            end;

            UpdateAcceptAllButton();
            updateInfoLabel();
        end);
        table.insert(u8, v416);
    end;

    if u31 then
        local v417 = u31.Activated:Connect(function() -- Line: 2557
            -- upvalues: u50 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (ref), u1 (ref), updateInfoLabel (ref)
            u50 = "Send";

            if u29 then
                u29.Visible = false;
            end;

            if u26 then
                u26.Visible = true;
            end;

            if u30 then
                u30.Visible = true;
            end;

            if u31 then
                u31.Visible = false;
            end;

            if u86 then
                u86.Visible = false;
            end;

            UpdateAcceptAllButton();
            u1:_resetToPlayerList();
            updateInfoLabel();
        end);
        table.insert(u8, v417);
    end;

    if u44 then
        local v418 = u44.Activated:Connect(function() -- Line: 2561
            -- upvalues: u1 (ref)
            u1:_resetToPlayerList();
        end);
        table.insert(u8, v418);
    end;

    if u43 then
        local v419 = u43.Activated:Connect(sendBatch);
        table.insert(u8, v419);
    end;

    if u21 then
        local v420 = u21.FocusLost:Connect(onSearchFocusLost);
        table.insert(u8, v420);
        local v421 = u21:GetPropertyChangedSignal("Text"):Connect(onSearchTextChanged);
        table.insert(u8, v421);
    end;

    u50 = "Send";

    if u29 then
        u29.Visible = false;
    end;

    if u26 then
        u26.Visible = true;
    end;

    if u30 then
        u30.Visible = true;
    end;

    if u31 then
        u31.Visible = false;
    end;

    if u86 then
        u86.Visible = false;
    end;

    UpdateAcceptAllButton();
    u1:_resetToPlayerList();
    updateInfoLabel();
end;

local function attachReplicaListener() -- Line: 2579
    -- upvalues: u55 (ref), PlayerStateClient (copy), attachReplicaListener (copy), u5 (ref), u27 (ref), rebuildInventory (copy)
    if u55 then
        return;
    end;

    local v422 = PlayerStateClient:GetLocalReplica();

    if v422 then
        u55 = v422:OnChange(function(p423, p424) -- Line: 2588
            -- upvalues: u5 (ref), u27 (ref), rebuildInventory (ref)
            if not (u5 and u5.Enabled) then
                return;
            end;

            if not (u27 and u27.Visible) then
                return;
            end;

            if typeof(p424) == "table" and p424[1] == "Inventory" then
                rebuildInventory();
            end;
        end);

        return;
    end;

    PlayerStateClient:OnLocalReplica(function() -- Line: 2583
        -- upvalues: attachReplicaListener (ref)
        attachReplicaListener();
    end);
end;

local function fetchInbox() -- Line: 2597
    -- upvalues: Networking (copy), u9 (ref), rebuildReceive (copy)
    local success, result = pcall(function() -- Line: 2598
        -- upvalues: Networking (ref)
        return Networking.Mailbox.OpenInbox:Fire();
    end);

    if success and typeof(result) == "table" then
        u9 = result;
        rebuildReceive();
    end;
end;

local u425 = nil;
local u426 = 0;

local function startInboxPoll() -- Line: 2618
    -- upvalues: u425 (ref), u426 (ref), Networking (copy), u68 (ref), u69 (copy), applyMailboxVisuals (copy), u42 (ref), u9 (ref), rebuildReceive (copy)
    if u425 then
        return;
    end;

    u426 = u426 + 1;
    local u427 = u426;
    local u428 = 30;
    local u429 = 0;
    local u430 = nil;
    u425 = task.spawn(function() -- Line: 2625
        -- upvalues: u426 (ref), u427 (copy), u428 (ref), Networking (ref), u430 (ref), u429 (ref), u68 (ref), u69 (ref), applyMailboxVisuals (ref), u42 (ref), u9 (ref), rebuildReceive (ref)
        while u426 == u427 do
            task.wait(u428);

            if u426 ~= u427 then
                break;
            end;

            local success, result = pcall(function() -- Line: 2629
                -- upvalues: Networking (ref)
                return Networking.Mailbox.IndexProbe:Fire();
            end);

            if success then
                local v431 = tonumber(result) or 0;

                if u430 == nil or v431 ~= u430 then
                    u429 = 0;
                    u428 = 30;
                    u430 = v431;
                    local v432 = v431 > 0;

                    if u68 ~= v432 then
                        u68 = v432;

                        for i in u69 do
                            if i.Parent then
                                applyMailboxVisuals(i);
                            else
                                u69[i] = nil;
                            end;
                        end;

                        if u42 then
                            u42.Visible = u68;
                        end;
                    end;

                    local success2, result2 = pcall(function() -- Line: 2598
                        -- upvalues: Networking (ref)
                        return Networking.Mailbox.OpenInbox:Fire();
                    end);

                    if success2 and typeof(result2) == "table" then
                        u9 = result2;
                        rebuildReceive();
                    end;
                else
                    u429 = u429 + 1;

                    if u429 >= 5 then
                        u428 = math.min(u428 * 2, 120);
                    end;
                end;
            end;
        end;
    end);
end;

local function stopInboxPoll() -- Line: 2652
    -- upvalues: u426 (ref), u425 (ref)
    u426 = u426 + 1;
    u425 = nil;
end;

local function onMailboxOpened() -- Line: 2657
    -- upvalues: attachReplicaListener (copy), u15 (ref), pruneExpiredReplyPending (copy), rebuildReceive (copy), fetchInbox (copy), Networking (copy), u11 (ref), applyServerReplyable (copy), MailboxFlags (copy), u57 (ref), u5 (ref), u50 (ref), u52 (ref), refreshStreakRows (copy), u425 (ref), u426 (ref), u68 (ref), u69 (copy), applyMailboxVisuals (copy), u42 (ref), u9 (ref), u29 (ref), u26 (ref), u30 (ref), u31 (ref), u86 (ref), UpdateAcceptAllButton (copy), u1 (copy), updateInfoLabel (copy), u53 (ref)
    attachReplicaListener();
    u15 = true;

    if pruneExpiredReplyPending() then
        rebuildReceive();
    end;

    task.spawn(fetchInbox);
    task.spawn(function() -- Line: 2669
        -- upvalues: Networking (ref), u11 (ref), rebuildReceive (ref)
        local success, result = pcall(function() -- Line: 2670
            -- upvalues: Networking (ref)
            return Networking.MagicMail.List:Fire();
        end);

        if success and typeof(result) == "table" then
            u11 = result;
            rebuildReceive();
        end;
    end);
    task.spawn(function() -- Line: 2679
        -- upvalues: Networking (ref), applyServerReplyable (ref)
        local success, result = pcall(function() -- Line: 2680
            -- upvalues: Networking (ref)
            return Networking.Mailbox.GetReplyable:Fire();
        end);

        if success then
            applyServerReplyable(result);
        end;
    end);

    if MailboxFlags.StreaksEnabled:Get() then
        task.spawn(function() -- Line: 1839
            -- upvalues: Networking (ref), u57 (ref), u5 (ref), u50 (ref), u52 (ref), refreshStreakRows (ref), rebuildReceive (ref)
            local success, result = pcall(function() -- Line: 1840
                -- upvalues: Networking (ref)
                return Networking.Mailbox.GetStreaks:Fire();
            end);

            if not success or type(result) ~= "table" then
                return;
            end;

            local v433 = {};

            for _, v in result do
                if type(v) == "table" and type(v.UserId) == "number" then
                    v433[v.UserId] = {
                        Count = type(v.Count) ~= "number" and 0 or v.Count,
                        Name = type(v.Name) ~= "string" and "" or v.Name,
                        LastDay = type(v.LastDay) ~= "number" and 0 or v.LastDay
                    };
                end;
            end;

            u57 = v433;

            if u5 and u5.Enabled then
                if u50 == "Send" and not u52 then
                    refreshStreakRows();
                end;

                rebuildReceive();
            end;
        end);
    end;

    if not u425 then
        u426 = u426 + 1;
        local u434 = u426;
        local u435 = 30;
        local u436 = 0;
        local u437 = nil;
        u425 = task.spawn(function() -- Line: 2625
            -- upvalues: u426 (ref), u434 (copy), u435 (ref), Networking (ref), u437 (ref), u436 (ref), u68 (ref), u69 (ref), applyMailboxVisuals (ref), u42 (ref), u9 (ref), rebuildReceive (ref)
            while u426 == u434 do
                task.wait(u435);

                if u426 ~= u434 then
                    break;
                end;

                local success, result = pcall(function() -- Line: 2629
                    -- upvalues: Networking (ref)
                    return Networking.Mailbox.IndexProbe:Fire();
                end);

                if success then
                    local v438 = tonumber(result) or 0;

                    if u437 == nil or v438 ~= u437 then
                        u436 = 0;
                        u435 = 30;
                        u437 = v438;
                        local v439 = v438 > 0;

                        if u68 ~= v439 then
                            u68 = v439;

                            for i in u69 do
                                if i.Parent then
                                    applyMailboxVisuals(i);
                                else
                                    u69[i] = nil;
                                end;
                            end;

                            if u42 then
                                u42.Visible = u68;
                            end;
                        end;

                        local success2, result2 = pcall(function() -- Line: 2598
                            -- upvalues: Networking (ref)
                            return Networking.Mailbox.OpenInbox:Fire();
                        end);

                        if success2 and typeof(result2) == "table" then
                            u9 = result2;
                            rebuildReceive();
                        end;
                    else
                        u436 = u436 + 1;

                        if u436 >= 5 then
                            u435 = math.min(u435 * 2, 120);
                        end;
                    end;
                end;
            end;
        end);
    end;

    u50 = "Send";

    if u29 then
        u29.Visible = false;
    end;

    if u26 then
        u26.Visible = true;
    end;

    if u30 then
        u30.Visible = true;
    end;

    if u31 then
        u31.Visible = false;
    end;

    if u86 then
        u86.Visible = false;
    end;

    UpdateAcceptAllButton();
    u1:_resetToPlayerList();
    updateInfoLabel();

    if u53 then
        u1:_pickRecipient(u53.userId, u53.displayName);
        u53 = nil;
    end;
end;

local function onMailboxClosed() -- Line: 2701
    -- upvalues: clearSession (copy), u426 (ref), u425 (ref), u52 (ref), u53 (ref), u54 (ref), u66 (ref), u67 (ref), u65 (copy), u63 (copy), u64 (copy), Networking (copy), u288 (copy), u58 (copy), rebuildSending (copy), rebuildInventory (copy), u46 (ref), u21 (ref)
    clearSession();
    u426 = u426 + 1;
    u425 = nil;
    u52 = nil;
    u53 = nil;
    u54 = nil;
    u66 = nil;
    u67 = nil;
    local u440 = {};

    for i in u65 do
        table.insert(u440, i);
    end;

    for i in u63 do
        table.insert(u440, i);
    end;

    for i, v in u64 do
        task.cancel(v);
        u64[i] = nil;
    end;

    table.clear(u65);
    table.clear(u63);

    if #u440 > 0 then
        task.spawn(function() -- Line: 2727
            -- upvalues: u440 (copy), Networking (ref)
            for _, v in u440 do
                pcall(function() -- Line: 2729
                    -- upvalues: Networking (ref), v (copy)
                    Networking.Mailbox.DeleteReplyable:Fire(v);
                end);
            end;
        end);
    end;

    table.clear(u288);
    table.clear(u58);
    rebuildSending();
    rebuildInventory();

    if u46 then
        u46.Text = "";
    end;

    if u21 then
        u21.Text = "";
    end;
end;

function u1.Init(p441) -- Line: 2742
end;

function u1.Start(p442) -- Line: 2745
    -- upvalues: Networking (copy), u33 (ref), u36 (copy), u35 (copy), u38 (ref), applyClaimSuccess (copy), u37 (ref), u39 (ref), u8 (copy), FinishClaimAllPass (copy), u310 (copy), ProximityPromptService (copy), LocalPlayer (copy), MailboxFlags (copy), NotificationController (copy), GuiController (copy), PlayerGui (copy), u5 (ref), bindChrome (copy), onMailboxOpened (copy), onMailboxClosed (copy), u11 (ref), rebuildReceive (copy), recomputeHasMail (copy), u9 (ref), u10 (ref), applyServerReplyable (copy), u68 (ref), u69 (copy), applyMailboxVisuals (copy), u42 (ref), discoverLocalMailboxes (copy)
    local v445 = Networking.Mailbox.ClaimAllProgress.OnClientEvent:Connect(function(p443) -- Line: 2746
        -- upvalues: u33 (ref), u36 (ref), u35 (ref), u38 (ref), applyClaimSuccess (ref), u37 (ref), u39 (ref)
        if typeof(p443) ~= "string" then
            return;
        end;

        if not u33 or u36[p443] then
            return;
        end;

        local v444 = u35[p443];

        if not v444 then
            return;
        end;

        u36[p443] = true;
        u38 = u38 + 1;
        applyClaimSuccess(p443, v444, nil);

        if not u37 then
            return;
        end;

        u37:SetText((`Claiming your mail... {u38}/{u39}`));
    end);
    table.insert(u8, v445);
    local v447 = Networking.Mailbox.ClaimAllFinished.OnClientEvent:Connect(function(p446) -- Line: 2764
        -- upvalues: FinishClaimAllPass (ref)
        FinishClaimAllPass(p446);
    end);
    table.insert(u8, v447);
    local v449 = Networking.Pets.PetEquipped.OnClientEvent:Connect(function(p448) -- Line: 2768
        -- upvalues: u310 (ref)
        if typeof(p448) ~= "string" then
            return;
        end;

        u310[p448] = true;
    end);
    table.insert(u8, v449);
    local v451 = Networking.Pets.PetUnequipped.OnClientEvent:Connect(function(p450) -- Line: 2772
        -- upvalues: u310 (ref)
        if typeof(p450) ~= "string" then
            return;
        end;

        u310[p450] = nil;
    end);
    table.insert(u8, v451);
    task.spawn(function() -- Line: 2776
        -- upvalues: Networking (ref), u310 (ref)
        local success, result = pcall(function() -- Line: 2777
            -- upvalues: Networking (ref)
            return Networking.Pets.GetEquippedPets:Fire();
        end);

        if success and typeof(result) == "table" then
            for _, v in result do
                if typeof(v) == "table" and typeof(v.Id) == "string" then
                    u310[v.Id] = true;
                end;
            end;
        end;
    end);
    local v454 = ProximityPromptService.PromptTriggered:Connect(function(p452, p453) -- Line: 2789
        -- upvalues: LocalPlayer (ref), MailboxFlags (ref), NotificationController (ref), GuiController (ref)
        if p453 ~= LocalPlayer then
            return;
        end;

        if p452.Name ~= "MailboxPrompt" then
            return;
        end;

        if MailboxFlags.OpenEnabled:Get() then
            if not GuiController:IsOpen("MailboxUI") then
                GuiController:Open("MailboxUI", nil, { "HUD", "TeleportButtons" });
            end;

            return;
        end;

        NotificationController:CreateNotification("The mailbox is currently unavailable.");
    end);
    table.insert(u8, v454);
    MailboxFlags.OpenEnabled.Changed:Connect(function(p455) -- Line: 2812
        -- upvalues: GuiController (ref)
        if p455 then
            return;
        end;

        if GuiController:IsOpen("MailboxUI") then
            GuiController:Close();
        end;
    end);
    task.spawn(function() -- Line: 2819
        -- upvalues: PlayerGui (ref), u5 (ref), bindChrome (ref)
        local MailboxUI = PlayerGui:WaitForChild("MailboxUI");

        if not MailboxUI:IsA("ScreenGui") then
            return;
        end;

        u5 = MailboxUI;
        bindChrome(MailboxUI);
    end);
    local v457 = GuiController.GuiFocusedSignal:Connect(function(p456) -- Line: 2826
        -- upvalues: onMailboxOpened (ref)
        if p456 and p456.Name == "MailboxUI" then
            onMailboxOpened();
        end;
    end);
    table.insert(u8, v457);
    local v459 = GuiController.GuiUnfocusedSignal:Connect(function(p458) -- Line: 2832
        -- upvalues: onMailboxClosed (ref)
        if p458 and p458.Name == "MailboxUI" then
            onMailboxClosed();
        end;
    end);
    table.insert(u8, v459);
    local v461 = Networking.MagicMail.Updated.OnClientEvent:Connect(function(p460) -- Line: 2839
        -- upvalues: u11 (ref), u5 (ref), rebuildReceive (ref), recomputeHasMail (ref)
        if typeof(p460) ~= "table" then
            return;
        end;

        u11 = p460;

        if u5 and u5.Enabled then
            rebuildReceive();

            return;
        end;

        recomputeHasMail();
    end);
    table.insert(u8, v461);
    local v468 = Networking.Mailbox.Updated.OnClientEvent:Connect(function(p462) -- Line: 2849
        -- upvalues: u9 (ref), u10 (ref), rebuildReceive (ref), applyServerReplyable (ref), u68 (ref), u69 (ref), applyMailboxVisuals (ref), u42 (ref)
        if typeof(p462) ~= "table" then
            u9 = {};
            u10 = {};
            rebuildReceive();

            return;
        end;

        local v463 = typeof(p462.PendingInvites) == "table";
        local v464 = typeof(p462.Mailbox) == "table";
        local v465 = typeof(p462.Badge) == "number";
        local v466 = typeof(p462.Replyable) == "table";

        if v463 then
            u10 = p462.PendingInvites;
        end;

        if v466 then
            applyServerReplyable(p462.Replyable, true);
        end;

        if v464 then
            u9 = p462.Mailbox;
            rebuildReceive();

            return;
        end;

        if v465 then
            local v467 = p462.Badge > 0 and true or next(u10) ~= nil;

            if u68 ~= v467 then
                u68 = v467;

                for i in u69 do
                    if i.Parent then
                        applyMailboxVisuals(i);
                    else
                        u69[i] = nil;
                    end;
                end;

                if u42 then
                    u42.Visible = u68;
                end;
            end;

            if v463 then
                rebuildReceive();
            end;

            return;
        end;

        if v463 then
            rebuildReceive();

            return;
        end;

        if v466 then
            rebuildReceive();

            return;
        end;

        u9 = p462;
        rebuildReceive();
    end);
    table.insert(u8, v468);
    local v472 = Networking.Guild.InvitePrompt.OnClientEvent:Connect(function(p469, p470) -- Line: 2918
        -- upvalues: u10 (ref), rebuildReceive (ref), NotificationController (ref)
        if typeof(p469) ~= "string" or typeof(p470) ~= "table" then
            return;
        end;

        u10[p469] = {
            GuildId = tostring(p470.GuildId or ""),
            GuildName = tostring(p470.GuildName or ""),
            GuildTag = tostring(p470.GuildTag or ""),
            FromUserId = tonumber(p470.FromUserId) or 0,
            FromName = tostring(p470.FromName or ""),
            ExpiresAt = tonumber(p470.ExpiresAt) or 0,
            ReceivedAt = tonumber(p470.ReceivedAt) or os.time(),
            MemberCount = tonumber(p470.MemberCount),
            MaxSlots = tonumber(p470.MaxSlots)
        };
        rebuildReceive();
        local v471 = tostring(p470.FromName or "Someone");
        NotificationController:CreateNotification(string.format("%s has invited you to their guild!", v471));
    end);
    table.insert(u8, v472);
    task.spawn(function() -- Line: 2944
        -- upvalues: Networking (ref), u9 (ref), rebuildReceive (ref)
        task.wait(2);
        local success, result = pcall(function() -- Line: 2598
            -- upvalues: Networking (ref)
            return Networking.Mailbox.OpenInbox:Fire();
        end);

        if success and typeof(result) == "table" then
            u9 = result;
            rebuildReceive();
        end;
    end);
    task.spawn(function() -- Line: 2950
        -- upvalues: discoverLocalMailboxes (ref)
        discoverLocalMailboxes();
    end);
    local v473 = LocalPlayer:GetAttributeChangedSignal("PlotId"):Connect(function() -- Line: 2953
        -- upvalues: discoverLocalMailboxes (ref)
        discoverLocalMailboxes();
    end);
    table.insert(u8, v473);
end;

return u1;