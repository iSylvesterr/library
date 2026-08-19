-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local GuildCompetition = require(ReplicatedStorage.SharedModules.GuildCompetition);
local Asserts = require(ReplicatedStorage.SharedModules.Guild.Asserts);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local DevProductController = require(LocalPlayer.PlayerScripts.Controllers.DevProductController);
local LeaveGuildController = require(LocalPlayer.PlayerScripts.Controllers.LeaveGuildController);
local u1 = { {
        From = 20,
        To = 25,
        Key = "Guild:Guild Slots:25",
        FallbackPrice = 37
    }, {
        From = 25,
        To = 30,
        Key = "Guild:Guild Slots:30",
        FallbackPrice = 79
    }, {
        From = 30,
        To = 35,
        Key = "Guild:Guild Slots:35",
        FallbackPrice = 189
    }, {
        From = 35,
        To = 40,
        Key = "Guild:Guild Slots:40",
        FallbackPrice = 279
    }, {
        From = 40,
        To = 45,
        Key = "Guild:Guild Slots:45",
        FallbackPrice = 399
    }, {
        From = 45,
        To = 50,
        Key = "Guild:Guild Slots:50",
        FallbackPrice = 499
    } };

local function getSlotTierForCurrent(p2) -- Line: 70
    -- upvalues: u1 (copy)
    for _, v in u1 do
        if v.From <= p2 and p2 < v.To then
            return v;
        end;
    end;

    return nil;
end;

local v3 = {
    StartOrder = 8
};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = nil;
local u17 = nil;
local u18 = nil;
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
local u29 = {};
local u30 = nil;
local u31 = {};
local u32 = nil;
local u33 = {};
local u34 = {};
local u35 = nil;
local u36 = nil;
local u37 = {};
local u38 = {};
local u39 = false;
local u40 = false;
local u41 = 0;
local u42 = {};
local u43 = {};
local u44 = nil;
local u45 = nil;
local u46 = 0;
local u47 = nil;
local u48 = 0;
local u49 = Color3.fromRGB(70, 255, 0);
local u50 = Color3.fromRGB(220, 60, 60);
local u51 = nil;
local u52 = false;

local function currentScoreFormat() -- Line: 215
    -- upvalues: u44 (ref)
    local v53 = u44;

    if typeof(v53) ~= "table" then
        return nil;
    end;

    local v54;

    if typeof(v53.config) == "table" then
        v54 = v53.config;
    else
        v54 = v53.lastConfig;
    end;

    if typeof(v54) == "table" and typeof(v54.scoreFormat) == "string" then
        return v54.scoreFormat;
    end;

    return nil;
end;

local function getPreferredNextReset(p55) -- Line: 229
    -- upvalues: u45 (ref)
    if u45 and p55 < u45 then
        return u45;
    end;

    return nil;
end;

local u56 = nil;

local function fetchCompetition() -- Line: 246
    -- upvalues: u46 (ref), Networking (copy), u44 (ref), u45 (ref), u56 (ref)
    local v57 = os.clock();

    if v57 - u46 < 15 then
        return;
    end;

    u46 = v57;
    task.spawn(function() -- Line: 250
        -- upvalues: Networking (ref), u44 (ref), u45 (ref), u56 (ref)
        local success, result = pcall(function() -- Line: 251
            -- upvalues: Networking (ref)
            return Networking.Guild.GetCompetition:Fire();
        end);

        if not success or typeof(result) ~= "table" then
            return;
        end;

        local v58 = u44;
        local v59;

        if typeof(v58) == "table" then
            local v60;

            if typeof(v58.config) == "table" then
                v60 = v58.config;
            else
                v60 = v58.lastConfig;
            end;

            if typeof(v60) == "table" and typeof(v60.scoreFormat) == "string" then
                v59 = v60.scoreFormat;
            else
                v59 = nil;
            end;
        else
            v59 = nil;
        end;

        u44 = result;

        if result.phase == "running" and typeof(result.endsAt) == "number" then
            u45 = result.endsAt;
        elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
            u45 = result.startsAt;
        else
            u45 = nil;
        end;

        local v61 = u44;
        local v62;

        if typeof(v61) == "table" then
            local v63;

            if typeof(v61.config) == "table" then
                v63 = v61.config;
            else
                v63 = v61.lastConfig;
            end;

            if typeof(v63) == "table" and typeof(v63.scoreFormat) == "string" then
                v62 = v63.scoreFormat;
            else
                v62 = nil;
            end;
        else
            v62 = nil;
        end;

        local v64 = v62 ~= v59 and u56;

        if v64 then
            v64();
        end;
    end);
end;

local function getPreferredWeekProgress(p65, p66) -- Line: 273
    return math.clamp((p65 - (p66 - 604800)) / 604800, 0, 1);
end;

local function formatTimeRemaining(p67) -- Line: 279
    -- upvalues: u44 (ref)
    local v68 = u44 and u44.phase == "pending" and "Starts in" or "Rewards in";
    local v69 = math.floor((p67 < 0 and 0 or p67) + 0.5);

    if v69 < 3600 then
        local v70 = v69 // 60;

        return string.format("%s %dm %ds", v68, v70, v69 - v70 * 60);
    end;

    if v69 < 86400 then
        local v71 = v69 // 3600;

        return string.format("%s %dh %dm", v68, v71, (v69 - v71 * 3600) // 60);
    end;

    local v72 = v69 // 86400;

    return string.format("%s %dd %dh", v68, v72, (v69 - v72 * 86400) // 3600);
end;

local function color3ToHex(p73) -- Line: 301
    local format = string.format;
    local v74 = math.floor(p73.R * 255 + 0.5);
    local v75 = math.clamp(v74, 0, 255);
    local v76 = math.floor(p73.G * 255 + 0.5);
    local v77 = math.clamp(v76, 0, 255);
    local v78 = math.floor(p73.B * 255 + 0.5);

    return format("#%02X%02X%02X", v75, v77, (math.clamp(v78, 0, 255)));
end;

local function hexFromMaybe(p79) -- Line: 310
    if typeof(p79) ~= "string" or p79 == "" then
        return "#FFFFFF";
    end;

    if p79:sub(1, 1) == "#" then
        return p79;
    end;

    return "#" .. p79;
end;

local function buildRainbowChars(p80, p81) -- Line: 318
    local v82 = utf8.len(p80) or 1;

    if v82 <= 0 then
        return p80;
    end;

    local v83 = 0;
    local v84 = {};

    for _, v in utf8.codes(p80) do
        v83 = v83 + 1;
        local v85 = Color3.fromHSV((p81 * 1.2 + (v83 - 1) / v82 * 0.6) % 1, 1, 1);
        local format = string.format;
        local v86 = math.floor(v85.R * 255 + 0.5);
        local v87 = math.clamp(v86, 0, 255);
        local v88 = math.floor(v85.G * 255 + 0.5);
        local v89 = math.clamp(v88, 0, 255);
        local v90 = math.floor(v85.B * 255 + 0.5);
        local v91 = format("#%02X%02X%02X", v87, v89, (math.clamp(v90, 0, 255)));
        table.insert(v84, string.format("<font color=\"%s\">%s</font>", v91, utf8.char(v)));
    end;

    return table.concat(v84);
end;

local function getOnlineName(p92) -- Line: 334
    -- upvalues: Players (copy)
    local v93 = Players:GetPlayerByUserId(p92);

    if v93 then
        return v93.Name;
    end;

    return nil;
end;

local function getCachedName(p94) -- Line: 340
    -- upvalues: Players (copy), u37 (copy)
    local v95 = Players:GetPlayerByUserId(p94);
    local v96;

    if v95 then
        v96 = v95.Name;
    else
        v96 = nil;
    end;

    if v96 then
        u37[p94] = v96;

        return v96;
    end;

    if u37[p94] then
        return u37[p94];
    end;

    return tostring(p94);
end;

local function fetchName(u97, u98) -- Line: 347
    -- upvalues: Players (copy), u37 (copy)
    local v99 = Players:GetPlayerByUserId(u97);
    local v100;

    if v99 then
        v100 = v99.Name;
    else
        v100 = nil;
    end;

    if v100 then
        u37[u97] = v100;
        u98(v100);

        return;
    end;

    if u37[u97] then
        u98(u37[u97]);

        return;
    end;

    task.spawn(function() -- Line: 355
        -- upvalues: Players (ref), u97 (copy), u37 (ref), u98 (copy)
        local success, result = pcall(function() -- Line: 356
            -- upvalues: Players (ref), u97 (ref)
            return Players:GetNameFromUserIdAsync(u97);
        end);

        if not success or typeof(result) ~= "string" then
            result = tostring(u97);
        end;

        u37[u97] = result;
        u98(result);
    end);
end;

local function fetchHeadshot(u101, u102) -- Line: 365
    -- upvalues: u38 (copy), Players (copy)
    if u38[u101] then
        u102(u38[u101]);

        return;
    end;

    task.spawn(function() -- Line: 367
        -- upvalues: Players (ref), u101 (copy), u38 (ref), u102 (copy)
        local success, result = pcall(function() -- Line: 368
            -- upvalues: Players (ref), u101 (ref)
            return Players:GetUserThumbnailAsync(u101, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
        end);

        if success and typeof(result) == "string" then
            u38[u101] = result;
            u102(result);
        end;
    end);
end;

local function setLabelChain(p103, p104) -- Line: 379
    if not p103 then
        return;
    end;

    p103.RichText = true;
    p103.Text = p104;
    local TextLabel = p103:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.RichText = true;
        TextLabel.Text = p104;
    end;
end;

local function setPlainLabel(p105, p106, p107) -- Line: 393
    if not p105 then
        return;
    end;

    p105.RichText = false;
    p105.Text = p106;
    local v108 = nil;
    local v109;

    if p107 then
        local v110;
        v110, v109 = pcall(Color3.fromHex, p107);

        if not v110 then
            v109 = v108;
        end;
    else
        v109 = v108;
    end;

    if v109 then
        p105.TextColor3 = v109;
    end;

    local TextLabel = p105:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.RichText = false;
        TextLabel.Text = p106;

        if v109 then
            TextLabel.TextColor3 = v109;
        end;
    end;
end;

local function stripRichTextTags(p111) -- Line: 414
    return p111:gsub("<.->", "");
end;

local function setTitleLabels(p112) -- Line: 424
    -- upvalues: u15 (ref)
    if u15 then
        u15.RichText = false;
        u15.TextColor3 = Color3.new(0, 0, 0);
        u15.Text = p112:gsub("<.->", "");
    end;

    local v113 = u15 and u15:FindFirstChild("TextLabel");

    if v113 and v113:IsA("TextLabel") then
        v113.RichText = true;
        v113.Text = p112;
    end;
end;

local function getRankColor(p114) -- Line: 437
    return p114 == 2 and "#FFBE18" or (p114 == 3 and "#AAAAAA" or "#956D4C");
end;

local function findGlobalRank(p115) -- Line: 452
    -- upvalues: LocalPlayer (copy), u29 (ref)
    if typeof(p115) ~= "string" or p115 == "" then
        p115 = LocalPlayer:GetAttribute("GuildId");

        if typeof(p115) ~= "string" then
            return nil;
        end;
    end;

    for i, v in u29 do
        if (v.guildId or v.GuildId) == p115 then
            return tonumber(v.rank or v.Rank) or i;
        end;
    end;

    return nil;
end;

local function findGuildLeaderboardScore(p116) -- Line: 474
    -- upvalues: u30 (ref), u29 (ref)
    if u30 ~= "weekly" then
        return nil;
    end;

    if typeof(p116) ~= "string" or p116 == "" then
        return nil;
    end;

    for _, v in u29 do
        if (v.guildId or v.GuildId) == p116 then
            return tonumber(v.shekels or (v.Shekels or v.score));
        end;
    end;

    return nil;
end;

local function contribsUserIds(p117) -- Line: 488
    local v118 = {};

    for _, v in p117 do
        local v119 = tonumber(v.userId or v.UserId);

        if v119 then
            v118[v119] = true;
        end;
    end;

    return v118;
end;

local function rosterShrank(p120, p121) -- Line: 499
    -- upvalues: contribsUserIds (copy)
    local v122 = contribsUserIds(p121);

    for i in contribsUserIds(p120) do
        if not v122[i] then
            return true;
        end;
    end;

    return false;
end;

local function sumContribs(p123) -- Line: 508
    local v124 = 0;

    for _, v in p123 do
        v124 = v124 + (tonumber(v.shekels or v.Shekels) or 0);
    end;

    return v124;
end;

local function reconcileLeaderboardAfterLeave(p125, p126) -- Line: 523
    -- upvalues: u29 (ref)
    local v127 = 0;

    for _, v in p126 do
        v127 = v127 + (tonumber(v.shekels or v.Shekels) or 0);
    end;

    for _, v in u29 do
        if (v.guildId or v.GuildId) == p125 then
            local v128 = tonumber(v.shekels or (v.Shekels or v.score));

            if v128 and v127 < v128 then
                v.shekels = v127;
            end;

            return;
        end;
    end;
end;

local function stopRainbowTitle() -- Line: 537
    -- upvalues: u36 (ref)
    if u36 then
        task.cancel(u36);
        u36 = nil;
    end;
end;

local function startRainbowTitle(u129, u130) -- Line: 544
    -- upvalues: u36 (ref), u39 (ref), buildRainbowChars (copy), setTitleLabels (copy)
    if u36 then
        task.cancel(u36);
        u36 = nil;
    end;

    u36 = task.spawn(function() -- Line: 546
        -- upvalues: u39 (ref), u129 (copy), buildRainbowChars (ref), u130 (copy), setTitleLabels (ref)
        local v131 = 0;

        while u39 do
            setTitleLabels(u129 .. " " .. buildRainbowChars(u130, v131));
            v131 = v131 + task.wait(0.04);
        end;
    end);
end;

local function applyGuildIconImage(p132) -- Line: 556
    -- upvalues: u21 (ref), Asserts (copy)
    if not u21 then
        return;
    end;

    if typeof(p132) ~= "number" then
        p132 = nil;
    end;

    u21.Image = Asserts.IconAssetString(p132);
end;

local function applyGuildTitle(p133) -- Line: 562
    -- upvalues: u30 (ref), findGlobalRank (copy), u36 (ref), u39 (ref), buildRainbowChars (copy), setTitleLabels (copy)
    if not p133 then
        return;
    end;

    local v134 = tostring(p133.Tag or "");
    local v135 = tostring(p133.Name or "");
    local Color = p133.Color;

    if typeof(Color) == "string" and Color ~= "" then
        if Color:sub(1, 1) ~= "#" then
            Color = "#" .. Color;
        end;
    else
        Color = "#FFFFFF";
    end;

    local v136 = p133.TagColor or p133.Color;

    if typeof(v136) == "string" and v136 ~= "" then
        if v136:sub(1, 1) ~= "#" then
            v136 = "#" .. v136;
        end;
    else
        v136 = "#FFFFFF";
    end;

    local u137 = string.format("<font color=\"%s\">[%s]</font> <font color=\"%s\">%s</font>", v136, v134, Color, v135);
    local v138;

    if typeof(p133.GuildId) == "string" then
        v138 = p133.GuildId;
    else
        v138 = nil;
    end;

    local v139;

    if u30 == "weekly" then
        v139 = findGlobalRank(v138);
    else
        v139 = nil;
    end;

    if v139 == 1 then
        if u36 then
            task.cancel(u36);
            u36 = nil;
        end;

        local u140 = "(#1)";
        u36 = task.spawn(function() -- Line: 546
            -- upvalues: u39 (ref), u137 (copy), buildRainbowChars (ref), u140 (copy), setTitleLabels (ref)
            local v141 = 0;

            while u39 do
                setTitleLabels(u137 .. " " .. buildRainbowChars(u140, v141));
                v141 = v141 + task.wait(0.04);
            end;
        end);

        return;
    end;

    if v139 and v139 <= 200 then
        if u36 then
            task.cancel(u36);
            u36 = nil;
        end;

        setTitleLabels(u137 .. string.format(" <font color=\"%s\">(#%d)</font>", v139 == 2 and "#FFBE18" or (v139 == 3 and "#AAAAAA" or "#956D4C"), v139));

        return;
    end;

    if u36 then
        task.cancel(u36);
        u36 = nil;
    end;

    setTitleLabels(u137);
end;

local function clearRows() -- Line: 598
    -- upvalues: u34 (copy), u33 (copy)
    for _, v in u34 do
        pcall(function() -- Line: 600
            -- upvalues: v (copy)
            v:Disconnect();
        end);
    end;

    table.clear(u34);

    for _, v in u33 do
        if v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(u33);
end;

local function trackRowConn(p142) -- Line: 609
    -- upvalues: u34 (copy)
    table.insert(u34, p142);
end;

local function buildSortedMembers(p143, p144) -- Line: 613
    -- upvalues: u37 (copy)
    local v145 = {};

    if p143 and typeof(p143.Members) == "table" then
        for i, v in p143.Members do
            local v146 = tonumber(i);

            if v146 then
                v145[v146] = {
                    weeklyShekels = 0,
                    displayName = nil,
                    userId = v146,
                    role = tostring(v.Role or "Member"),
                    lifetimeShekels = tonumber(v.LifetimeContribution) or 0
                };
            end;
        end;
    end;

    if typeof(p144) == "table" then
        for _, v in p144 do
            local v147 = tonumber(v.userId or v.UserId);

            if v147 and v145[v147] then
                v145[v147].weeklyShekels = tonumber(v.shekels or v.Shekels) or 0;

                if typeof(v.name) == "string" then
                    v145[v147].displayName = v.name;
                    u37[v147] = v.name;
                end;
            end;
        end;
    end;

    local v148 = {};

    for _, v in v145 do
        table.insert(v148, v);
    end;

    table.sort(v148, function(p149, p150) -- Line: 649
        if p149.weeklyShekels ~= p150.weeklyShekels then
            return p149.weeklyShekels > p150.weeklyShekels;
        end;

        if p149.lifetimeShekels == p150.lifetimeShekels then
            return p149.userId < p150.userId;
        end;

        return p149.lifetimeShekels > p150.lifetimeShekels;
    end);

    return v148;
end;

local u151 = nil;

local function renderMemberRow(p152, p153, p154, u155, u156, p157) -- Line: 669
    -- upvalues: u33 (copy), LocalPlayer (copy), Players (copy), u37 (copy), fetchName (copy), GuildCompetition (copy), u44 (ref), u38 (copy), u42 (copy), u49 (copy), u50 (copy), u23 (ref), u24 (ref), Networking (copy), NotificationController (copy), u151 (ref), u34 (copy), LeaveGuildController (copy)
    local u158 = p152:Clone();
    u158.Name = `Member_{u155.userId}`;
    u158.LayoutOrder = p154;
    u158.Visible = true;
    u158.Parent = p153;
    table.insert(u33, u158);
    local ContainerFrame = u158:FindFirstChild("ContainerFrame");

    if not ContainerFrame then
        return;
    end;

    local u159;

    if u155.role == "Owner" or u155.role == "Leader" then
        u159 = true;
    elseif typeof(u156) == "table" then
        u159 = u156.LeaderUserId == u155.userId;
    else
        u159 = false;
    end;

    local v160 = u155.role == "Elder";
    local v161 = u155.userId == LocalPlayer.UserId;
    local v162 = p157 == "Owner";
    local Username = ContainerFrame:FindFirstChild("Username");

    if Username and Username:IsA("TextLabel") then
        local userId = u155.userId;
        local v163 = Players:GetPlayerByUserId(userId);
        local v164;

        if v163 then
            v164 = v163.Name;
        else
            v164 = nil;
        end;

        if v164 then
            u37[userId] = v164;
        elseif u37[userId] then
            v164 = u37[userId];
        else
            v164 = tostring(userId);
        end;

        if Username then
            Username.RichText = true;
            Username.Text = v164;
            local TextLabel = Username:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = v164;
            end;
        end;

        fetchName(u155.userId, function(p165) -- Line: 701
            -- upvalues: Username (copy)
            if Username.Parent then
                local v166 = Username;

                if not v166 then
                    return;
                end;

                v166.RichText = true;
                v166.Text = p165;
                local TextLabel = v166:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = true;
                    TextLabel.Text = p165;
                end;
            end;
        end);
    end;

    local Role_Rank = ContainerFrame:FindFirstChild("Role_Rank");

    if Role_Rank and Role_Rank:IsA("TextLabel") then
        Role_Rank.RichText = true;
        Role_Rank.Text = string.format("%s | #%d", u155.role, p154);
    end;

    local Contributions = ContainerFrame:FindFirstChild("Contributions");

    if Contributions then
        Contributions = Contributions:FindFirstChild("Weekly");
    end;

    if Contributions then
        Contributions = Contributions:FindFirstChild("TextLabel");
    end;

    if Contributions and Contributions:IsA("TextLabel") then
        Contributions.RichText = true;
        local format = string.format;
        local FormatScore = GuildCompetition.FormatScore;
        local v167 = tonumber(u155.weeklyShekels);
        local v168 = u44;
        local v169;

        if typeof(v168) == "table" then
            local v170;

            if typeof(v168.config) == "table" then
                v170 = v168.config;
            else
                v170 = v168.lastConfig;
            end;

            if typeof(v170) == "table" and typeof(v170.scoreFormat) == "string" then
                v169 = v170.scoreFormat;
            else
                v169 = nil;
            end;
        else
            v169 = nil;
        end;

        Contributions.Text = format("<font color=\"#F9D100\">%s</font>", FormatScore(v167, v169));
    end;

    local PlayerDisplay = ContainerFrame:FindFirstChild("PlayerDisplay");
    local u171;

    if PlayerDisplay then
        u171 = PlayerDisplay:FindFirstChild("MemberImage");
    else
        u171 = PlayerDisplay;
    end;

    if u171 and u171:IsA("ImageLabel") then
        local userId = u155.userId;

        local function u173(p172) -- Line: 730
            -- upvalues: u171 (copy)
            if u171.Parent then
                u171.Image = p172;
            end;
        end;

        if u38[userId] then
            local v174 = u38[userId];

            if u171.Parent then
                u171.Image = v174;
            end;
        else
            task.spawn(function() -- Line: 367
                -- upvalues: Players (ref), userId (copy), u38 (ref), u173 (copy)
                local success, result = pcall(function() -- Line: 368
                    -- upvalues: Players (ref), userId (ref)
                    return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
                end);

                if success and typeof(result) == "string" then
                    u38[userId] = result;
                    u173(result);
                end;
            end);
        end;
    end;

    local v175;

    if PlayerDisplay then
        v175 = PlayerDisplay:FindFirstChild("GuildOwnerIcon");
    else
        v175 = PlayerDisplay;
    end;

    if v175 and v175:IsA("ImageLabel") then
        v175.Visible = u159;
    end;

    if PlayerDisplay then
        PlayerDisplay = PlayerDisplay:FindFirstChild("Status");
    end;

    if PlayerDisplay and PlayerDisplay:IsA("Frame") then
        local v176 = u42[typeof(u156) == "table" and (tostring(u156.GuildId or "") or "") or ""];
        local v177 = u155.userId == LocalPlayer.UserId;
        local v178 = Players:GetPlayerByUserId(u155.userId) ~= nil;
        local v179;

        if v176 == nil then
            v179 = false;
        else
            v179 = v176[u155.userId] == true;
        end;

        local v180;

        if v177 or (v178 or v179) then
            v180 = u49;
        else
            v180 = u50;
        end;

        PlayerDisplay.BackgroundColor3 = v180;
    end;

    local KickButton = ContainerFrame:FindFirstChild("KickButton");

    if KickButton and KickButton:IsA("GuiButton") then
        local v181;

        if v162 then
            v181 = not v161;
        else
            v181 = v162;
        end;

        KickButton.Visible = v181;

        if v181 then
            local v191 = KickButton.MouseButton1Click:Connect(function() -- Line: 770
                -- upvalues: u158 (copy), u23 (ref), u156 (copy), u33 (ref), u24 (ref), Networking (ref), u155 (copy), NotificationController (ref), u151 (ref), Players (ref), u37 (ref)
                if not u158.Parent then
                    return;
                end;

                u158:Destroy();

                if u23 and typeof(u156) == "table" then
                    local v182 = 0;

                    for _, v in u33 do
                        if v.Parent then
                            v182 = v182 + 1;
                        end;
                    end;

                    local v183 = tonumber(u156.MaxSlots) or 0;
                    local v184 = string.format("%d/%d", v182, v183);
                    local v185 = u23;

                    if v185 then
                        v185.RichText = true;
                        v185.Text = v184;
                        local TextLabel = v185:FindFirstChild("TextLabel");

                        if TextLabel and TextLabel:IsA("TextLabel") then
                            TextLabel.RichText = true;
                            TextLabel.Text = v184;
                        end;
                    end;

                    if u24 then
                        u24.RichText = true;
                        u24.Text = v184;
                    end;
                end;

                task.spawn(function() -- Line: 798
                    -- upvalues: Networking (ref), u155 (ref), NotificationController (ref), u151 (ref), Players (ref), u37 (ref)
                    local v186, v187, v188 = pcall(function() -- Line: 799
                        -- upvalues: Networking (ref), u155 (ref)
                        return Networking.Guild.Kick:Fire(u155.userId);
                    end);

                    if not (v186 and v187) then
                        NotificationController:CreateNotification((typeof(v188) ~= "string" or (v188 == "" or not v188)) and "Could not kick that member" or v188);
                        u151();

                        return;
                    end;

                    local format = string.format;
                    local userId = u155.userId;
                    local v189 = Players:GetPlayerByUserId(userId);
                    local v190;

                    if v189 then
                        v190 = v189.Name;
                    else
                        v190 = nil;
                    end;

                    if v190 then
                        u37[userId] = v190;
                    elseif u37[userId] then
                        v190 = u37[userId];
                    else
                        v190 = tostring(userId);
                    end;

                    NotificationController:CreateNotification(format("Kicked %s", v190));
                    u151();
                end);
            end);
            table.insert(u34, v191);
        end;
    end;

    local function countElders() -- Line: 829
        -- upvalues: u156 (copy)
        local v192 = 0;

        if typeof(u156) == "table" and typeof(u156.Members) == "table" then
            for _, v in u156.Members do
                if v.Role == "Elder" then
                    v192 = v192 + 1;
                end;
            end;
        end;

        return v192;
    end;

    local RankButton = ContainerFrame:FindFirstChild("RankButton");

    if RankButton and RankButton:IsA("GuiButton") then
        local v193 = v162 and not v161 and (not u159 and not v160);
        RankButton.Visible = v193;

        if v193 then
            local v200 = RankButton.MouseButton1Click:Connect(function() -- Line: 850
                -- upvalues: u156 (copy), NotificationController (ref), Networking (ref), u155 (copy), u151 (ref)
                local v194 = 0;

                if typeof(u156) == "table" and typeof(u156.Members) == "table" then
                    for _, v in u156.Members do
                        if v.Role == "Elder" then
                            v194 = v194 + 1;
                        end;
                    end;
                end;

                if v194 >= 5 then
                    NotificationController:CreateNotification(string.format("You already have %d/%d elders ranked!", 5, 5));

                    return;
                end;

                local u195 = 0;

                if typeof(u156) == "table" and typeof(u156.Members) == "table" then
                    for _, v in u156.Members do
                        if v.Role == "Elder" then
                            u195 = u195 + 1;
                        end;
                    end;
                end;

                task.spawn(function() -- Line: 867
                    -- upvalues: Networking (ref), u155 (ref), NotificationController (ref), u195 (copy), u151 (ref)
                    local v196, v197, v198 = pcall(function() -- Line: 868
                        -- upvalues: Networking (ref), u155 (ref)
                        return Networking.Guild.Promote:Fire(u155.userId);
                    end);

                    if not (v196 and v197) then
                        if typeof(v198) == "string" and v198 == "elder_limit_reached" then
                            NotificationController:CreateNotification(string.format("You already have %d/%d elders ranked!", 5, 5));

                            return;
                        end;

                        NotificationController:CreateNotification((typeof(v198) ~= "string" or (v198 == "" or not v198)) and "Could not rank that member" or v198);

                        return;
                    end;

                    local v199 = math.min(u195 + 1, 5);
                    NotificationController:CreateNotification(string.format("You ranked %d/%d elders!", v199, 5));
                    u151();
                end);
            end);
            table.insert(u34, v200);
        end;
    end;

    local UnRankButton = ContainerFrame:FindFirstChild("UnRankButton");

    if UnRankButton and UnRankButton:IsA("GuiButton") then
        if v162 then
            local v201 = not v161;

            if not v201 then
                v160 = v201;
            end;
        else
            v160 = v162;
        end;

        UnRankButton.Visible = v160;

        if v160 then
            local v207 = UnRankButton.MouseButton1Click:Connect(function() -- Line: 904
                -- upvalues: Networking (ref), u155 (copy), NotificationController (ref), Players (ref), u37 (ref), u151 (ref)
                task.spawn(function() -- Line: 905
                    -- upvalues: Networking (ref), u155 (ref), NotificationController (ref), Players (ref), u37 (ref), u151 (ref)
                    local v202, v203, v204 = pcall(function() -- Line: 906
                        -- upvalues: Networking (ref), u155 (ref)
                        return Networking.Guild.Demote:Fire(u155.userId);
                    end);

                    if not (v202 and v203) then
                        NotificationController:CreateNotification((typeof(v204) ~= "string" or (v204 == "" or not v204)) and "Could not unrank that member" or v204);

                        return;
                    end;

                    local format = string.format;
                    local userId = u155.userId;
                    local v205 = Players:GetPlayerByUserId(userId);
                    local v206;

                    if v205 then
                        v206 = v205.Name;
                    else
                        v206 = nil;
                    end;

                    if v206 then
                        u37[userId] = v206;
                    elseif u37[userId] then
                        v206 = u37[userId];
                    else
                        v206 = tostring(userId);
                    end;

                    NotificationController:CreateNotification(format("Unranked %s from Elder", v206));
                    u151();
                end);
            end);
            table.insert(u34, v207);
        end;
    end;

    local LeaveButton = ContainerFrame:FindFirstChild("LeaveButton");

    if LeaveButton and LeaveButton:IsA("GuiButton") then
        LeaveButton.Visible = v161;

        if v161 then
            local v208 = u159 and "Disband" or "Leave";
            local TextLabel = LeaveButton:FindFirstChild("TextLabel");

            if TextLabel and (TextLabel:IsA("TextLabel") and TextLabel) then
                TextLabel.RichText = true;
                TextLabel.Text = v208;
                local TextLabel2 = TextLabel:FindFirstChild("TextLabel");

                if TextLabel2 and TextLabel2:IsA("TextLabel") then
                    TextLabel2.RichText = true;
                    TextLabel2.Text = v208;
                end;
            end;

            local v213 = LeaveButton.MouseButton1Click:Connect(function() -- Line: 936
                -- upvalues: u156 (copy), u159 (copy), LeaveGuildController (ref)
                local v209;

                if typeof(u156) == "table" then
                    v209 = {};
                    local v210;

                    if typeof(u156.Name) == "string" then
                        v210 = u156.Name;
                    else
                        v210 = nil;
                    end;

                    v209.Name = v210;
                    local v211;

                    if typeof(u156.Tag) == "string" then
                        v211 = u156.Tag;
                    else
                        v211 = nil;
                    end;

                    v209.Tag = v211;
                    local v212;

                    if typeof(u156.Color) == "string" then
                        v212 = u156.Color;
                    else
                        v212 = nil;
                    end;

                    v209.Color = v212;
                    v209.IsOwner = u159;
                else
                    v209 = nil;
                end;

                LeaveGuildController:Open(v209);
            end);
            table.insert(u34, v213);
        end;
    end;

    local MailButton = ContainerFrame:FindFirstChild("MailButton");

    if MailButton and MailButton:IsA("GuiButton") then
        local v214;

        if p157 == "Visitor" then
            v214 = not v161;
        else
            v214 = false;
        end;

        MailButton.Visible = v214;

        if v214 then
            local v216 = MailButton.MouseButton1Click:Connect(function() -- Line: 958
                -- upvalues: LocalPlayer (ref), u155 (copy), Players (ref), u37 (ref)
                local MailboxController = require(LocalPlayer.PlayerScripts.Controllers.MailboxController);
                local displayName = u155.displayName;

                if not displayName then
                    local userId = u155.userId;
                    local v215 = Players:GetPlayerByUserId(userId);

                    if v215 then
                        displayName = v215.Name;
                    else
                        displayName = nil;
                    end;

                    if displayName then
                        u37[userId] = displayName;
                    elseif u37[userId] then
                        displayName = u37[userId];
                    else
                        displayName = tostring(userId);
                    end;
                end;

                MailboxController:OpenComposeFor(u155.userId, displayName);
            end);
            table.insert(u34, v216);
        end;
    end;
end;

local function getCachedSlotsPriceText(p217) -- Line: 969
    -- upvalues: u1 (copy), DevProductController (copy)
    for _, v in u1 do
        if v.From <= p217 and p217 < v.To then
            break;
        end;
    end;

    if not v then
        return "MAX";
    end;

    local v218 = DevProductController:GetPreloadedProductInfo(v.Key);
    local v219 = v218 and tonumber(v218.PriceInRobux) or v.FallbackPrice;

    return string.format("%d R$", v219);
end;

local function renderAddSlotsFrame(p220, p221, p222) -- Line: 979
    -- upvalues: u27 (ref), u28 (ref), u1 (copy), DevProductController (copy)
    if not u27 then
        return;
    end;

    local v223 = p221 and tonumber(p221.MaxSlots) or 0;
    local v224 = v223 >= 50;
    local v225 = p222 == "Owner";

    if v225 then
        v225 = not v224;
    end;

    u27.Visible = v225;
    u27.LayoutOrder = 1000000;
    local ContainerFrame = u27:FindFirstChild("ContainerFrame");

    if ContainerFrame then
        ContainerFrame = ContainerFrame:FindFirstChild("Contributions");
    end;

    if ContainerFrame then
        local AddMemberSlotsTextLabel = ContainerFrame:FindFirstChild("AddMemberSlotsTextLabel");

        if AddMemberSlotsTextLabel and AddMemberSlotsTextLabel:IsA("TextLabel") then
            AddMemberSlotsTextLabel.Text = string.format("+%d MEMBER SLOTS", 5);
        end;
    end;

    if u28 then
        local TextLabel = u28:FindFirstChild("TextLabel");

        if not (TextLabel and TextLabel:IsA("TextLabel")) then
        end;

        for _, v in u1 do
            if v.From <= v223 and v223 < v.To then
                break;
            end;
        end;

        local v226;

        if v then
            local v227 = DevProductController:GetPreloadedProductInfo(v.Key);
            local v228 = v227 and tonumber(v227.PriceInRobux) or v.FallbackPrice;
            v226 = string.format("%d R$", v228);
        else
            v226 = "MAX";
        end;

        if not TextLabel then
            return;
        end;

        TextLabel.RichText = true;
        TextLabel.Text = v226;
        local TextLabel2 = TextLabel:FindFirstChild("TextLabel");

        if TextLabel2 and TextLabel2:IsA("TextLabel") then
            TextLabel2.RichText = true;
            TextLabel2.Text = v226;
        end;
    end;
end;

local function applyPresenceToRows(p229) -- Line: 1011
    -- upvalues: u39 (ref), u42 (copy), u33 (copy), LocalPlayer (copy), Players (copy), u49 (copy), u50 (copy)
    if not u39 then
        return;
    end;

    local v230 = u42[p229];

    for _, v in u33 do
        if v.Parent then
            local ContainerFrame = v:FindFirstChild("ContainerFrame");

            if ContainerFrame then
                ContainerFrame = ContainerFrame:FindFirstChild("PlayerDisplay");
            end;

            if ContainerFrame then
                ContainerFrame = ContainerFrame:FindFirstChild("Status");
            end;

            if ContainerFrame and ContainerFrame:IsA("Frame") then
                local v231 = string.match(v.Name, "^Member_(%d+)$");

                if v231 then
                    v231 = tonumber(v231);
                end;

                if v231 then
                    local v232 = v231 == LocalPlayer.UserId;
                    local v233 = Players:GetPlayerByUserId(v231) ~= nil;
                    local v234;

                    if v230 == nil then
                        v234 = false;
                    else
                        v234 = v230[v231] == true;
                    end;

                    local v235;

                    if v232 or (v233 or v234) then
                        v235 = u49;
                    else
                        v235 = u50;
                    end;

                    ContainerFrame.BackgroundColor3 = v235;
                end;
            end;
        end;
    end;
end;

local function computeOnlineMemberCount(p236, p237) -- Line: 1041
    -- upvalues: u42 (copy), LocalPlayer (copy), Players (copy)
    local v238 = u42[p236];
    local v239 = {};
    local v240 = 0;

    if typeof(p237) == "table" then
        for i in p237 do
            local v241 = tonumber(i);

            if v241 and not v239[v241] then
                local v242 = v241 == LocalPlayer.UserId;
                local v243 = Players:GetPlayerByUserId(v241) ~= nil;
                local v244;

                if v238 == nil then
                    v244 = false;
                else
                    v244 = v238[v241] == true;
                end;

                if v242 or (v243 or v244) then
                    v239[v241] = true;
                    v240 = v240 + 1;
                end;
            end;
        end;
    end;

    if v238 then
        for i in v238 do
            if not v239[i] then
                v240 = v240 + 1;
            end;
        end;
    end;

    return v240;
end;

local function updateOnlineCount(p245, p246) -- Line: 1070
    -- upvalues: u22 (ref), computeOnlineMemberCount (copy)
    if not (u22 and u22.Parent) then
        return;
    end;

    local v247 = computeOnlineMemberCount(p245, p246);
    local v248 = u22;
    local v249 = string.format("Members (%d online)", v247);

    if not v248 then
        return;
    end;

    v248.RichText = true;
    v248.Text = v249;
    local TextLabel = v248:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.RichText = true;
        TextLabel.Text = v249;
    end;
end;

local function fetchOnlineMembersFor(u250) -- Line: 1080
    -- upvalues: u43 (copy), Networking (copy), u42 (copy), applyPresenceToRows (copy), u32 (ref), u22 (ref), computeOnlineMemberCount (copy)
    if u250 == "" then
        return;
    end;

    if u43[u250] then
        return;
    end;

    u43[u250] = true;
    task.spawn(function() -- Line: 1088
        -- upvalues: Networking (ref), u250 (copy), u43 (ref), u42 (ref), applyPresenceToRows (ref), u32 (ref), u22 (ref), computeOnlineMemberCount (ref)
        local success, result = pcall(function() -- Line: 1089
            -- upvalues: Networking (ref), u250 (ref)
            return Networking.Guild.GetOnlineMembers:Fire(u250);
        end);
        u43[u250] = nil;

        if not success or typeof(result) ~= "table" then
            return;
        end;

        local v251 = {};

        for _, v in result do
            local v252 = tonumber(v);

            if v252 then
                v251[v252] = true;
            end;
        end;

        u42[u250] = v251;
        applyPresenceToRows(u250);

        if u32 and (u32.Guild and tostring(u32.Guild.GuildId or "") == u250) then
            local v253 = u250;
            local Members = u32.Guild.Members;

            if u22 then
                if not u22.Parent then
                    return;
                end;

                local v254 = computeOnlineMemberCount(v253, Members);
                local v255 = u22;
                local v256 = string.format("Members (%d online)", v254);

                if not v255 then
                    return;
                end;

                v255.RichText = true;
                v255.Text = v256;
                local TextLabel = v255:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = true;
                    TextLabel.Text = v256;
                end;
            end;
        end;
    end);
end;

local function applyCompetitionHeader() -- Line: 1124
    -- upvalues: u9 (ref), u44 (ref), u10 (ref)
    if not u9 then
        return;
    end;

    local v257 = u44;
    local v258;

    if typeof(v257) == "table" then
        v258 = v257.phase;
    else
        v258 = nil;
    end;

    if v258 == "running" and (typeof(v257.config) == "table" and (typeof(v257.config.displayName) == "string" and v257.config.displayName ~= "")) then
        local v259 = u9;
        local displayName = v257.config.displayName;

        if v259 then
            v259.RichText = true;
            v259.Text = displayName;
            local TextLabel = v259:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = displayName;
            end;
        end;
    elseif v258 == "pending" then
        local v260 = u9;

        if v260 then
            v260.RichText = true;
            v260.Text = "Previous Competition";
            local TextLabel = v260:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = "Previous Competition";
            end;
        end;
    else
        local v261 = u9;
        local v262 = v257 == nil and "Loading..." or "No Active Competition";

        if v261 then
            v261.RichText = true;
            v261.Text = v262;
            local TextLabel = v261:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = v262;
            end;
        end;
    end;

    if u10 then
        if v258 == "running" and (typeof(v257.config) == "table" and typeof(v257.config.description) == "table") then
            local v263 = {};

            for _, v in v257.config.description do
                if typeof(v) == "string" then
                    table.insert(v263, v);
                end;
            end;

            local v264 = u10;
            local v265 = table.concat(v263, "\n");

            if not v264 then
                return;
            end;

            v264.RichText = true;
            v264.Text = v265;
            local TextLabel = v264:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = v265;
            end;
        else
            local v266 = u10;

            if not v266 then
                return;
            end;

            v266.RichText = true;
            v266.Text = "";
            local TextLabel = v266:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = "";
            end;
        end;
    end;
end;

local function formatPlacement(p267) -- Line: 1157
    return ("%d"):format(p267):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function renderScoreLine() -- Line: 1168
    -- upvalues: u17 (ref), u47 (ref), u48 (ref), findGuildLeaderboardScore (copy), GuildCompetition (copy), u44 (ref), findGlobalRank (copy), LocalPlayer (copy)
    if not u17 then
        return;
    end;

    local v268 = u47;

    if typeof(v268) ~= "string" or v268 == "" then
        local v269 = u17;

        if not v269 then
            return;
        end;

        v269.RichText = true;
        v269.Text = "Score: 0";
        local TextLabel = v269:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.RichText = true;
            TextLabel.Text = "Score: 0";
        end;

        return;
    end;

    local v270 = u48;
    local v271 = findGuildLeaderboardScore(v268);

    if v271 then
        if v270 >= v271 then
            v271 = v270;
        end;
    else
        v271 = v270;
    end;

    local FormatScore = GuildCompetition.FormatScore;
    local v272 = u44;
    local v273;

    if typeof(v272) == "table" then
        local v274;

        if typeof(v272.config) == "table" then
            v274 = v272.config;
        else
            v274 = v272.lastConfig;
        end;

        if typeof(v274) == "table" and typeof(v274.scoreFormat) == "string" then
            v273 = v274.scoreFormat;
        else
            v273 = nil;
        end;
    else
        v273 = nil;
    end;

    local v275 = FormatScore(v271, v273);
    local v276 = findGlobalRank(v268);

    if v276 then
        local v277 = u17;
        local v278 = ("Score: %s  •  Rank #%d"):format(v275, v276);

        if not v277 then
            return;
        end;

        v277.RichText = true;
        v277.Text = v278;
        local TextLabel = v277:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.RichText = true;
            TextLabel.Text = v278;
        end;

        return;
    end;

    local v279 = LocalPlayer:GetAttribute("GuildId");

    if typeof(v279) == "string" and v279 == v268 then
        local v280 = LocalPlayer:GetAttribute("GuildRank");

        if typeof(v280) == "number" and v280 > 0 then
            local v281 = u17;
            local v282 = ("Score: %s  •  Rank #%s"):format(v275, (("%d"):format(v280):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")));

            if not v281 then
                return;
            end;

            v281.RichText = true;
            v281.Text = v282;
            local TextLabel = v281:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = v282;
            end;

            return;
        end;
    end;

    local v283 = u17;
    local v284 = "Score: " .. v275;

    if not v283 then
        return;
    end;

    v283.RichText = true;
    v283.Text = v284;
    local TextLabel = v283:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.RichText = true;
        TextLabel.Text = v284;
    end;
end;

local function refreshHeader() -- Line: 1209
    -- upvalues: u6 (ref), u51 (ref), u46 (ref), Networking (copy), u44 (ref), u45 (ref), u56 (ref), ServerClock (copy), u7 (ref), u13 (ref), u14 (ref), u8 (ref), formatTimeRemaining (copy), u11 (ref), applyCompetitionHeader (copy)
    if u6 then
        local v285 = u6;
        local v286 = u51 and "Viewing Guild" or "My Guild";

        if v285 then
            v285.RichText = true;
            v285.Text = v286;
            local TextLabel = v285:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = v286;
            end;
        end;
    end;

    local v287 = os.clock();

    if v287 - u46 >= 15 then
        u46 = v287;
        task.spawn(function() -- Line: 250
            -- upvalues: Networking (ref), u44 (ref), u45 (ref), u56 (ref)
            local success, result = pcall(function() -- Line: 251
                -- upvalues: Networking (ref)
                return Networking.Guild.GetCompetition:Fire();
            end);

            if not success or typeof(result) ~= "table" then
                return;
            end;

            local v288 = u44;
            local v289;

            if typeof(v288) == "table" then
                local v290;

                if typeof(v288.config) == "table" then
                    v290 = v288.config;
                else
                    v290 = v288.lastConfig;
                end;

                if typeof(v290) == "table" and typeof(v290.scoreFormat) == "string" then
                    v289 = v290.scoreFormat;
                else
                    v289 = nil;
                end;
            else
                v289 = nil;
            end;

            u44 = result;

            if result.phase == "running" and typeof(result.endsAt) == "number" then
                u45 = result.endsAt;
            elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
                u45 = result.startsAt;
            else
                u45 = nil;
            end;

            local v291 = u44;
            local v292;

            if typeof(v291) == "table" then
                local v293;

                if typeof(v291.config) == "table" then
                    v293 = v291.config;
                else
                    v293 = v291.lastConfig;
                end;

                if typeof(v293) == "table" and typeof(v293.scoreFormat) == "string" then
                    v292 = v293.scoreFormat;
                else
                    v292 = nil;
                end;
            else
                v292 = nil;
            end;

            local v294 = v292 ~= v289 and u56;

            if v294 then
                v294();
            end;
        end);
    end;

    local v295 = ServerClock.Now();
    local v296;

    if u45 and v295 < u45 then
        v296 = u45;
    else
        v296 = nil;
    end;

    if u7 then
        u7.Visible = v296 ~= nil;
    end;

    if u13 and u14 then
        local v297 = u14;

        if v296 == nil then
            v297 = UDim2.new(0.86, v297.X.Offset, v297.Y.Scale, v297.Y.Offset);
        end;

        u13.Position = v297;
    end;

    if v296 then
        if u8 then
            local v298 = u8;
            local v299 = formatTimeRemaining(v296 - v295);

            if v298 then
                v298.RichText = true;
                v298.Text = v299;
                local TextLabel = v298:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = true;
                    TextLabel.Text = v299;
                end;
            end;
        end;

        if u11 then
            local v300 = math.clamp((v295 - (v296 - 604800)) / 604800, 0, 1);
            u11.Offset = Vector2.new(v300 + -0.5, 0);
        end;
    end;

    applyCompetitionHeader();
end;

local function applyGuildSnapshot(p301) -- Line: 1251
    -- upvalues: u32 (ref), clearRows (copy), setTitleLabels (copy), u16 (ref), u47 (ref), u48 (ref), renderScoreLine (copy), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u21 (ref), Asserts (copy), applyGuildTitle (copy), setPlainLabel (copy), u31 (copy), computeOnlineMemberCount (copy), u18 (ref), u19 (ref), u20 (ref), u25 (ref), u26 (ref), buildSortedMembers (copy), renderMemberRow (copy), renderAddSlotsFrame (copy), u43 (copy), Networking (copy), u42 (copy), applyPresenceToRows (copy)
    u32 = p301;

    if not p301 or typeof(p301) ~= "table" then
        clearRows();
        setTitleLabels("");
        local v302 = u16;

        if v302 then
            v302.RichText = false;
            v302.Text = "";
            local v303 = nil;

            if v303 then
                v302.TextColor3 = v303;
            end;

            local TextLabel = v302:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = false;
                TextLabel.Text = "";

                if v303 then
                    TextLabel.TextColor3 = v303;
                end;
            end;
        end;

        u47 = nil;
        u48 = 0;
        renderScoreLine();
        local v304 = u22;

        if v304 then
            v304.RichText = true;
            v304.Text = "Members (SOON)";
            local TextLabel = v304:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = "Members (SOON)";
            end;
        end;

        local v305 = u23;

        if v305 then
            v305.RichText = true;
            v305.Text = "0/0";
            local TextLabel = v305:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = "0/0";
            end;
        end;

        if u24 then
            u24.RichText = true;
            u24.Text = "0/0";
        end;

        if u27 then
            u27.Visible = false;
        end;

        if not u21 then
            return;
        end;

        u21.Image = Asserts.IconAssetString(nil);

        return;
    end;

    local Guild = p301.Guild;
    local Role = p301.Role;
    applyGuildTitle(Guild);
    local IconId = Guild.IconId;

    if u21 then
        if typeof(IconId) ~= "number" then
            IconId = nil;
        end;

        u21.Image = Asserts.IconAssetString(IconId);
    end;

    local v306 = tostring(Guild.Description or "");
    local v307 = Guild.DescriptionColor or Guild.Color;

    if typeof(v307) == "string" and v307 ~= "" then
        if v307:sub(1, 1) ~= "#" then
            v307 = "#" .. v307;
        end;
    else
        v307 = "#FFFFFF";
    end;

    setPlainLabel(u16, v306, v307);
    local u308 = tostring(Guild.GuildId or "");
    local v309 = u31[u308];
    local v310 = 0;

    if typeof(v309) == "table" then
        for _, v in v309 do
            v310 = v310 + (tonumber(v.shekels or v.Shekels) or 0);
        end;
    end;

    u47 = u308;
    u48 = v310;
    renderScoreLine();
    local v311 = 0;

    if typeof(Guild.Members) == "table" then
        for _ in Guild.Members do
            v311 = v311 + 1;
        end;
    end;

    local v312 = tonumber(Guild.MaxSlots) or 0;
    local v313 = string.format("%d/%d", v311, v312);
    local v314 = u23;

    if v314 then
        v314.RichText = true;
        v314.Text = v313;
        local TextLabel = v314:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.RichText = true;
            TextLabel.Text = v313;
        end;
    end;

    if u24 then
        u24.RichText = true;
        u24.Text = v313;
    end;

    local Members = Guild.Members;

    if u22 and u22.Parent then
        local v315 = computeOnlineMemberCount(u308, Members);
        local v316 = u22;
        local v317 = string.format("Members (%d online)", v315);

        if v316 then
            v316.RichText = true;
            v316.Text = v317;
            local TextLabel = v316:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = v317;
            end;
        end;
    end;

    if u18 then
        u18.Visible = Role == "Owner";
    end;

    if u19 then
        u19.Visible = Role == "Owner" and true or Role == "Elder";
    end;

    if u20 then
        u20.Visible = Role == "Owner";
    end;

    clearRows();

    if u25 and u26 then
        for i, v in buildSortedMembers(Guild, v309) do
            renderMemberRow(u26, u25, i, v, Guild, Role);
        end;
    end;

    if u25 then
        renderAddSlotsFrame(u25, Guild, Role);
    end;

    if u308 == "" then
        return;
    end;

    if u43[u308] then
        return;
    end;

    u43[u308] = true;
    task.spawn(function() -- Line: 1088
        -- upvalues: Networking (ref), u308 (copy), u43 (ref), u42 (ref), applyPresenceToRows (ref), u32 (ref), u22 (ref), computeOnlineMemberCount (ref)
        local success, result = pcall(function() -- Line: 1089
            -- upvalues: Networking (ref), u308 (ref)
            return Networking.Guild.GetOnlineMembers:Fire(u308);
        end);
        u43[u308] = nil;

        if not success or typeof(result) ~= "table" then
            return;
        end;

        local v318 = {};

        for _, v in result do
            local v319 = tonumber(v);

            if v319 then
                v318[v319] = true;
            end;
        end;

        u42[u308] = v318;
        applyPresenceToRows(u308);

        if u32 and (u32.Guild and tostring(u32.Guild.GuildId or "") == u308) then
            local v320 = u308;
            local Members2 = u32.Guild.Members;

            if u22 then
                if not u22.Parent then
                    return;
                end;

                local v321 = computeOnlineMemberCount(v320, Members2);
                local v322 = u22;
                local v323 = string.format("Members (%d online)", v321);

                if not v322 then
                    return;
                end;

                v322.RichText = true;
                v322.Text = v323;
                local TextLabel = v322:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = true;
                    TextLabel.Text = v323;
                end;
            end;
        end;
    end);
end;

local function applyExternalGuildSummary(p324) -- Line: 1349
    -- upvalues: u32 (ref), clearRows (copy), setTitleLabels (copy), u16 (ref), u47 (ref), u48 (ref), renderScoreLine (copy), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u21 (ref), Asserts (copy), applyGuildTitle (copy), setPlainLabel (copy), u29 (ref), computeOnlineMemberCount (copy), u18 (ref), u19 (ref), u20 (ref), u25 (ref), u26 (ref), buildSortedMembers (copy), renderMemberRow (copy), u43 (copy), Networking (copy), u42 (copy), applyPresenceToRows (copy)
    if not p324 or typeof(p324) ~= "table" then
        u32 = nil;
        clearRows();
        setTitleLabels("");
        local v325 = u16;

        if v325 then
            v325.RichText = false;
            v325.Text = "";
            local v326 = nil;

            if v326 then
                v325.TextColor3 = v326;
            end;

            local TextLabel = v325:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = false;
                TextLabel.Text = "";

                if v326 then
                    TextLabel.TextColor3 = v326;
                end;
            end;
        end;

        u47 = nil;
        u48 = 0;
        renderScoreLine();
        local v327 = u22;

        if v327 then
            v327.RichText = true;
            v327.Text = "Members (SOON)";
            local TextLabel = v327:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = "Members (SOON)";
            end;
        end;

        local v328 = u23;

        if v328 then
            v328.RichText = true;
            v328.Text = "0/0";
            local TextLabel = v328:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = "0/0";
            end;
        end;

        if u24 then
            u24.RichText = true;
            u24.Text = "0/0";
        end;

        if u27 then
            u27.Visible = false;
        end;

        if not u21 then
            return;
        end;

        u21.Image = Asserts.IconAssetString(nil);

        return;
    end;

    u32 = {
        Role = "Visitor",
        Guild = p324
    };
    applyGuildTitle(p324);
    local IconId = p324.IconId;

    if u21 then
        if typeof(IconId) ~= "number" then
            IconId = nil;
        end;

        u21.Image = Asserts.IconAssetString(IconId);
    end;

    local v329 = tostring(p324.Description or "");
    local v330 = p324.DescriptionColor or p324.Color;

    if typeof(v330) == "string" and v330 ~= "" then
        if v330:sub(1, 1) ~= "#" then
            v330 = "#" .. v330;
        end;
    else
        v330 = "#FFFFFF";
    end;

    setPlainLabel(u16, v329, v330);
    local u331 = tostring(p324.GuildId or "");
    local v332 = tonumber(p324.WeeklyShekels) or 0;

    if v332 == 0 then
        for _, v in u29 do
            if (v.guildId or v.GuildId) == u331 then
                v332 = tonumber(v.shekels or v.Shekels) or 0;
                break;
            end;
        end;
    end;

    u47 = u331;
    u48 = v332;
    renderScoreLine();
    local v333 = tonumber(p324.MemberCount) or 0;
    local v334 = tonumber(p324.MaxSlots) or 0;
    local v335 = string.format("%d/%d", v333, v334);
    local v336 = u23;

    if v336 then
        v336.RichText = true;
        v336.Text = v335;
        local TextLabel = v336:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.RichText = true;
            TextLabel.Text = v335;
        end;
    end;

    if u24 then
        u24.RichText = true;
        u24.Text = v335;
    end;

    local Members = p324.Members;

    if u22 and u22.Parent then
        local v337 = computeOnlineMemberCount(u331, Members);
        local v338 = u22;
        local v339 = string.format("Members (%d online)", v337);

        if v338 then
            v338.RichText = true;
            v338.Text = v339;
            local TextLabel = v338:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.RichText = true;
                TextLabel.Text = v339;
            end;
        end;
    end;

    if u18 then
        u18.Visible = false;
    end;

    if u19 then
        u19.Visible = false;
    end;

    if u20 then
        u20.Visible = false;
    end;

    if u27 then
        u27.Visible = false;
    end;

    clearRows();

    if u25 and (u26 and typeof(p324.Members) == "table") then
        local v340 = {
            GuildId = p324.GuildId,
            LeaderUserId = p324.LeaderUserId,
            Members = p324.Members
        };
        local v341 = {};

        for i, v in p324.Members do
            local v342 = tonumber(i);

            if v342 then
                local v343 = {
                    userId = v342,
                    shekels = tonumber(v.WeeklyContribution) or 0
                };
                local v344;

                if typeof(v.Name) == "string" then
                    v344 = v.Name;
                else
                    v344 = nil;
                end;

                v343.name = v344;
                table.insert(v341, v343);
            end;
        end;

        for i, v in buildSortedMembers(v340, v341) do
            renderMemberRow(u26, u25, i, v, v340, "Visitor");
        end;
    end;

    if u331 == "" then
        return;
    end;

    if u43[u331] then
        return;
    end;

    u43[u331] = true;
    task.spawn(function() -- Line: 1088
        -- upvalues: Networking (ref), u331 (copy), u43 (ref), u42 (ref), applyPresenceToRows (ref), u32 (ref), u22 (ref), computeOnlineMemberCount (ref)
        local success, result = pcall(function() -- Line: 1089
            -- upvalues: Networking (ref), u331 (ref)
            return Networking.Guild.GetOnlineMembers:Fire(u331);
        end);
        u43[u331] = nil;

        if not success or typeof(result) ~= "table" then
            return;
        end;

        local v345 = {};

        for _, v in result do
            local v346 = tonumber(v);

            if v346 then
                v345[v346] = true;
            end;
        end;

        u42[u331] = v345;
        applyPresenceToRows(u331);

        if u32 and (u32.Guild and tostring(u32.Guild.GuildId or "") == u331) then
            local v347 = u331;
            local Members2 = u32.Guild.Members;

            if u22 then
                if not u22.Parent then
                    return;
                end;

                local v348 = computeOnlineMemberCount(v347, Members2);
                local v349 = u22;
                local v350 = string.format("Members (%d online)", v348);

                if not v349 then
                    return;
                end;

                v349.RichText = true;
                v349.Text = v350;
                local TextLabel = v349:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = true;
                    TextLabel.Text = v350;
                end;
            end;
        end;
    end);
end;

u56 = function() -- Line: 1441
    -- upvalues: u39 (ref), u32 (ref), u51 (ref), applyExternalGuildSummary (copy), applyGuildSnapshot (copy), renderScoreLine (copy)
    if not u39 then
        return;
    end;

    local v351 = u32;

    if u51 then
        if typeof(v351) == "table" and v351.Guild then
            applyExternalGuildSummary(v351.Guild);
        end;
    else
        if v351 ~= nil then
            applyGuildSnapshot(v351);

            return;
        end;

        renderScoreLine();
    end;
end;

local function fetchLeaderboard() -- Line: 1455
    -- upvalues: Networking (copy), u29 (ref), u30 (ref), u39 (ref), u32 (ref), applyGuildTitle (copy), renderScoreLine (copy)
    task.spawn(function() -- Line: 1460
        -- upvalues: Networking (ref), u29 (ref), u30 (ref), u39 (ref), u32 (ref), applyGuildTitle (ref), renderScoreLine (ref)
        local success, result = pcall(function() -- Line: 1461
            -- upvalues: Networking (ref)
            return Networking.Guild.GetLeaderboard:Fire("weekly");
        end);

        if success and (typeof(result) == "table" and #result > 0) then
            u29 = result;
            u30 = "weekly";
        end;

        if u39 and (u32 and u32.Guild) then
            applyGuildTitle(u32.Guild);
            renderScoreLine();
        end;
    end);
end;

u151 = function() -- Line: 1475, Name: fetchAndRender
    -- upvalues: u51 (ref), Networking (copy), u39 (ref), applyExternalGuildSummary (copy), u32 (ref), clearRows (copy), setTitleLabels (copy), u16 (ref), u47 (ref), u48 (ref), renderScoreLine (copy), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u21 (ref), Asserts (copy), u29 (ref), u30 (ref), applyGuildTitle (copy), u31 (copy), applyGuildSnapshot (copy)
    local u352 = u51;
    task.spawn(function() -- Line: 1477
        -- upvalues: u352 (copy), Networking (ref), u39 (ref), applyExternalGuildSummary (ref), u32 (ref), clearRows (ref), setTitleLabels (ref), u16 (ref), u47 (ref), u48 (ref), renderScoreLine (ref), u22 (ref), u23 (ref), u24 (ref), u27 (ref), u21 (ref), Asserts (ref), u29 (ref), u30 (ref), applyGuildTitle (ref), u31 (ref), applyGuildSnapshot (ref)
        if u352 then
            local success, result = pcall(function() -- Line: 1479
                -- upvalues: Networking (ref), u352 (ref)
                return Networking.Guild.GetGuildById:Fire(u352);
            end);

            if not u39 then
                return;
            end;

            if success and result then
                applyExternalGuildSummary(result);
            else
                u32 = nil;
                clearRows();
                setTitleLabels("");
                local v353 = u16;

                if v353 then
                    v353.RichText = false;
                    v353.Text = "";
                    local v354 = nil;

                    if v354 then
                        v353.TextColor3 = v354;
                    end;

                    local TextLabel = v353:FindFirstChild("TextLabel");

                    if TextLabel and TextLabel:IsA("TextLabel") then
                        TextLabel.RichText = false;
                        TextLabel.Text = "";

                        if v354 then
                            TextLabel.TextColor3 = v354;
                        end;
                    end;
                end;

                u47 = nil;
                u48 = 0;
                renderScoreLine();
                local v355 = u22;

                if v355 then
                    v355.RichText = true;
                    v355.Text = "Members (SOON)";
                    local TextLabel = v355:FindFirstChild("TextLabel");

                    if TextLabel and TextLabel:IsA("TextLabel") then
                        TextLabel.RichText = true;
                        TextLabel.Text = "Members (SOON)";
                    end;
                end;

                local v356 = u23;

                if v356 then
                    v356.RichText = true;
                    v356.Text = "0/0";
                    local TextLabel = v356:FindFirstChild("TextLabel");

                    if TextLabel and TextLabel:IsA("TextLabel") then
                        TextLabel.RichText = true;
                        TextLabel.Text = "0/0";
                    end;
                end;

                if u24 then
                    u24.RichText = true;
                    u24.Text = "0/0";
                end;

                if u27 then
                    u27.Visible = false;
                end;

                if u21 then
                    u21.Image = Asserts.IconAssetString(nil);
                end;
            end;

            task.spawn(function() -- Line: 1460
                -- upvalues: Networking (ref), u29 (ref), u30 (ref), u39 (ref), u32 (ref), applyGuildTitle (ref), renderScoreLine (ref)
                local success2, result2 = pcall(function() -- Line: 1461
                    -- upvalues: Networking (ref)
                    return Networking.Guild.GetLeaderboard:Fire("weekly");
                end);

                if success2 and (typeof(result2) == "table" and #result2 > 0) then
                    u29 = result2;
                    u30 = "weekly";
                end;

                if u39 and (u32 and u32.Guild) then
                    applyGuildTitle(u32.Guild);
                    renderScoreLine();
                end;
            end);

            return;
        end;

        local success, result = pcall(function() -- Line: 1492
            -- upvalues: Networking (ref)
            return Networking.Guild.GetMyGuild:Fire();
        end);

        if not u39 then
            return;
        end;

        if success then
            if result and (typeof(result) == "table" and (typeof(result.GuildmateContribs) == "table" and (result.Guild and typeof(result.Guild.GuildId) == "string"))) then
                u31[result.Guild.GuildId] = result.GuildmateContribs;
            end;

            applyGuildSnapshot(result);
        else
            u32 = nil;
            clearRows();
            setTitleLabels("");
            local v357 = u16;

            if v357 then
                v357.RichText = false;
                v357.Text = "";
                local v358 = nil;

                if v358 then
                    v357.TextColor3 = v358;
                end;

                local TextLabel = v357:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = false;
                    TextLabel.Text = "";

                    if v358 then
                        TextLabel.TextColor3 = v358;
                    end;
                end;
            end;

            u47 = nil;
            u48 = 0;
            renderScoreLine();
            local v359 = u22;

            if v359 then
                v359.RichText = true;
                v359.Text = "Members (SOON)";
                local TextLabel = v359:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = true;
                    TextLabel.Text = "Members (SOON)";
                end;
            end;

            local v360 = u23;

            if v360 then
                v360.RichText = true;
                v360.Text = "0/0";
                local TextLabel = v360:FindFirstChild("TextLabel");

                if TextLabel and TextLabel:IsA("TextLabel") then
                    TextLabel.RichText = true;
                    TextLabel.Text = "0/0";
                end;
            end;

            if u24 then
                u24.RichText = true;
                u24.Text = "0/0";
            end;

            if u27 then
                u27.Visible = false;
            end;

            if u21 then
                u21.Image = Asserts.IconAssetString(nil);
            end;
        end;

        task.spawn(function() -- Line: 1460
            -- upvalues: Networking (ref), u29 (ref), u30 (ref), u39 (ref), u32 (ref), applyGuildTitle (ref), renderScoreLine (ref)
            local success2, result2 = pcall(function() -- Line: 1461
                -- upvalues: Networking (ref)
                return Networking.Guild.GetLeaderboard:Fire("weekly");
            end);

            if success2 and (typeof(result2) == "table" and #result2 > 0) then
                u29 = result2;
                u30 = "weekly";
            end;

            if u39 and (u32 and u32.Guild) then
                applyGuildTitle(u32.Guild);
                renderScoreLine();
            end;
        end);
    end);
end;

local function startTimerLoop() -- Line: 1521
    -- upvalues: u35 (ref), u39 (ref), refreshHeader (copy)
    if u35 then
        return;
    end;

    u35 = task.spawn(function() -- Line: 1523
        -- upvalues: u39 (ref), refreshHeader (ref)
        while u39 do
            refreshHeader();
            task.wait(1);
        end;
    end);
end;

local function stopTimerLoop() -- Line: 1531
    -- upvalues: u35 (ref)
    if u35 then
        task.cancel(u35);
        u35 = nil;
    end;
end;

local function promptBuySlots() -- Line: 1539
    -- upvalues: u41 (ref), NotificationController (copy), u40 (ref), u32 (ref), Networking (copy), applyGuildSnapshot (copy), u39 (ref), u1 (copy), DevProductController (copy)
    local v361 = u41 - os.clock();

    if v361 > 0 then
        NotificationController:CreateNotification((`Purchase available in {math.ceil(v361)}s`));

        return;
    end;

    if u40 then
        return;
    end;

    if not u32 then
        NotificationController:CreateNotification("Only the guild owner can buy member slots");

        return;
    end;

    if u32.Role ~= "Owner" then
        NotificationController:CreateNotification("Only the guild owner can buy member slots");

        return;
    end;

    u40 = true;
    local success, result = pcall(function() -- Line: 1571
        -- upvalues: Networking (ref)
        return Networking.Guild.GetMyGuild:Fire();
    end);

    if success and (result and result.Guild) then
        applyGuildSnapshot(result);
    elseif not success then
        u40 = false;
        NotificationController:CreateNotification("Couldn\'t reach the guild service — try again");

        return;
    end;

    if not u39 then
        u40 = false;

        return;
    end;

    local u362 = tonumber(u32 and u32.Guild and u32.Guild.MaxSlots) or 0;

    if u362 >= 50 then
        u40 = false;
        NotificationController:CreateNotification("Member slots are already at the maximum");

        return;
    end;

    for _, v in u1 do
        if v.From <= u362 and u362 < v.To then
            break;
        end;
    end;

    if not v then
        u40 = false;
        NotificationController:CreateNotification("No matching slot tier");

        return;
    end;

    local Key = v.Key;
    local u363 = nil;
    local u364 = nil;
    local u365 = nil;
    u363 = DevProductController.PurchaseComplete:Connect(function(p366) -- Line: 1612
        -- upvalues: Key (copy), u40 (ref), u363 (ref), u364 (ref), u365 (ref), u41 (ref), u362 (copy), u39 (ref), Networking (ref), applyGuildSnapshot (ref)
        if p366 ~= Key then
            return;
        end;

        u40 = false;

        if u363 then
            u363:Disconnect();
        end;

        if u364 then
            u364:Disconnect();
        end;

        if u365 then
            u365:Disconnect();
        end;

        u41 = os.clock() + 9;
        task.spawn(function() -- Line: 1625
            -- upvalues: u362 (ref), u39 (ref), u41 (ref), Networking (ref), applyGuildSnapshot (ref)
            local v367 = u362;

            for _ = 1, 6 do
                task.wait(1.5);

                if not u39 then
                    u41 = 0;

                    return;
                end;

                local success2, result2 = pcall(function() -- Line: 1636
                    -- upvalues: Networking (ref)
                    return Networking.Guild.GetMyGuild:Fire();
                end);

                if success2 and (result2 and result2.Guild) then
                    applyGuildSnapshot(result2);

                    if v367 < (tonumber(result2.Guild.MaxSlots) or 0) then
                        u41 = 0;

                        return;
                    end;
                end;
            end;

            u41 = 0;
        end);
    end);
    u364 = DevProductController.PurchaseFailed:Connect(function(p368) -- Line: 1653
        -- upvalues: Key (copy), u40 (ref), u363 (ref), u364 (ref), u365 (ref)
        if p368 ~= Key then
            return;
        end;

        u40 = false;

        if u363 then
            u363:Disconnect();
        end;

        if u364 then
            u364:Disconnect();
        end;

        if u365 then
            u365:Disconnect();
        end;
    end);
    u365 = DevProductController.PurchaseCancelled:Connect(function(p369) -- Line: 1661
        -- upvalues: Key (copy), u40 (ref), u363 (ref), u364 (ref), u365 (ref)
        if p369 ~= Key then
            return;
        end;

        u40 = false;

        if u363 then
            u363:Disconnect();
        end;

        if u364 then
            u364:Disconnect();
        end;

        if u365 then
            u365:Disconnect();
        end;
    end);
    local v370, v371 = DevProductController:PromptPurchase(Key);

    if not v370 and v371 ~= "Prompted Robux" then
        u40 = false;

        if u363 then
            u363:Disconnect();
        end;

        if u364 then
            u364:Disconnect();
        end;

        if u365 then
            u365:Disconnect();
        end;
    end;
end;

local function ResolveRefs(p372) -- Line: 1679
    -- upvalues: u5 (ref), u6 (ref), u7 (ref), u8 (ref), u11 (ref), u13 (ref), u14 (ref), u12 (ref), u9 (ref), u10 (ref), u15 (ref), u16 (ref), u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u22 (ref), u23 (ref), u24 (ref), u25 (ref), u26 (ref), u27 (ref), u28 (ref)
    local MainPage = p372:FindFirstChild("MainPage");

    if not MainPage then
        return;
    end;

    local Header = MainPage:FindFirstChild("Header");

    if Header then
        local ExitButton = Header:FindFirstChild("ExitButton");

        if ExitButton and ExitButton:IsA("GuiButton") then
            u5 = ExitButton;
        end;

        local TextLabel = Header:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            u6 = TextLabel;
        end;

        local WeeklyRefreshIn = Header:FindFirstChild("WeeklyRefreshIn");

        if WeeklyRefreshIn then
            if WeeklyRefreshIn:IsA("GuiObject") then
                u7 = WeeklyRefreshIn;
            end;

            local WeeklyTimer = WeeklyRefreshIn:FindFirstChild("WeeklyTimer");

            if WeeklyTimer and WeeklyTimer:IsA("TextLabel") then
                u8 = WeeklyTimer;
            end;

            local UIGradient = WeeklyRefreshIn:FindFirstChild("UIGradient");

            if UIGradient and UIGradient:IsA("UIGradient") then
                u11 = UIGradient;
            end;
        end;

        local ExtraFrame = Header:FindFirstChild("ExtraFrame");

        if ExtraFrame and ExtraFrame:IsA("GuiObject") then
            u13 = ExtraFrame;
            u14 = ExtraFrame.Position;
            local ViewPlacementButton = ExtraFrame:FindFirstChild("ViewPlacementButton");

            if ViewPlacementButton and ViewPlacementButton:IsA("GuiButton") then
                u12 = ViewPlacementButton;
            end;
        end;
    end;

    local Content = MainPage:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local WeeklyContributionsTitle = Content:FindFirstChild("WeeklyContributionsTitle");

    if WeeklyContributionsTitle and WeeklyContributionsTitle:IsA("TextLabel") then
        u9 = WeeklyContributionsTitle;
    end;

    local CompetitionDescription = Content:FindFirstChild("CompetitionDescription");

    if CompetitionDescription and CompetitionDescription:IsA("TextLabel") then
        u10 = CompetitionDescription;
    end;

    local GuildInfo = Content:FindFirstChild("GuildInfo");

    if GuildInfo then
        local GuildName_Rank = GuildInfo:FindFirstChild("GuildName_Rank");

        if GuildName_Rank and GuildName_Rank:IsA("TextLabel") then
            u15 = GuildName_Rank;
        end;

        local Description = GuildInfo:FindFirstChild("Description");

        if Description and Description:IsA("TextLabel") then
            u16 = Description;
        end;

        local TotalContribution = GuildInfo:FindFirstChild("TotalContribution");

        if TotalContribution and TotalContribution:IsA("TextLabel") then
            u17 = TotalContribution;
        end;

        local EditButton = GuildInfo:FindFirstChild("EditButton");

        if EditButton and EditButton:IsA("GuiButton") then
            u18 = EditButton;
        end;

        local InviteButton = GuildInfo:FindFirstChild("InviteButton");

        if InviteButton and InviteButton:IsA("GuiButton") then
            u19 = InviteButton;
        end;

        local TransferButton = GuildInfo:FindFirstChild("TransferButton");

        if TransferButton and TransferButton:IsA("GuiButton") then
            u20 = TransferButton;
        end;

        local BeanstalkDisplay = GuildInfo:FindFirstChild("BeanstalkDisplay");

        if BeanstalkDisplay then
            local BeanstalkSkinImage = BeanstalkDisplay:FindFirstChild("BeanstalkSkinImage");

            if BeanstalkSkinImage and BeanstalkSkinImage:IsA("ImageLabel") then
                u21 = BeanstalkSkinImage;
            end;
        end;
    end;

    local OnlineCount = Content:FindFirstChild("OnlineCount");

    if OnlineCount and OnlineCount:IsA("TextLabel") then
        u22 = OnlineCount;
    end;

    local MemberCountTextLabel1 = Content:FindFirstChild("MemberCountTextLabel1");

    if MemberCountTextLabel1 and MemberCountTextLabel1:IsA("TextLabel") then
        u23 = MemberCountTextLabel1;
        local MemberCountTextLabel2 = MemberCountTextLabel1:FindFirstChild("MemberCountTextLabel2");

        if MemberCountTextLabel2 and MemberCountTextLabel2:IsA("TextLabel") then
            u24 = MemberCountTextLabel2;
        end;
    end;

    local ScrollingFrame = Content:FindFirstChild("ScrollingFrame");

    if ScrollingFrame and ScrollingFrame:IsA("ScrollingFrame") then
        u25 = ScrollingFrame;
        local PlayerListTemplate = ScrollingFrame:FindFirstChild("PlayerListTemplate");

        if PlayerListTemplate and PlayerListTemplate:IsA("Frame") then
            u26 = PlayerListTemplate;
            PlayerListTemplate.Visible = false;
        end;

        local AddMaxMembersFrame = ScrollingFrame:FindFirstChild("AddMaxMembersFrame");

        if AddMaxMembersFrame and AddMaxMembersFrame:IsA("Frame") then
            u27 = AddMaxMembersFrame;
            AddMaxMembersFrame.LayoutOrder = 1000000;
            AddMaxMembersFrame.Visible = false;
            local ContainerFrame = AddMaxMembersFrame:FindFirstChild("ContainerFrame");

            if ContainerFrame then
                ContainerFrame = ContainerFrame:FindFirstChild("Contributions");
            end;

            if ContainerFrame then
                ContainerFrame = ContainerFrame:FindFirstChild("BuyMemberSlotsButton");
            end;

            if ContainerFrame and ContainerFrame:IsA("GuiButton") then
                u28 = ContainerFrame;
            end;
        end;
    end;
end;

local function BindButtons() -- Line: 1787
    -- upvalues: u5 (ref), GuiController (copy), u52 (ref), u18 (ref), LocalPlayer (copy), u51 (ref), u19 (ref), u20 (ref), u28 (ref), promptBuySlots (copy), u12 (ref)
    if u5 then
        u5.MouseButton1Click:Connect(function() -- Line: 1789
            -- upvalues: GuiController (ref), u52 (ref)
            if not GuiController:IsOpen("ViewGuildPage") then
                return;
            end;

            local v373 = u52;
            u52 = false;

            if v373 then
                GuiController:Open("ViewGuildLeaderboard", nil, { "HUD" });

                if GuiController:IsOpen("ViewGuildPage") then
                    GuiController:Close();
                end;
            else
                GuiController:Close();
            end;
        end);
    end;

    if u18 then
        u18.MouseButton1Click:Connect(function() -- Line: 1816
            -- upvalues: LocalPlayer (ref), u51 (ref), u52 (ref), GuiController (ref)
            if LocalPlayer:GetAttribute("GuildRole") ~= "Owner" then
                return;
            end;

            if u51 then
                return;
            end;

            GuiController:Open("EditGuild", nil, { "HUD" });
            u52 = u52;
        end);
    end;

    if u19 then
        u19.MouseButton1Click:Connect(function() -- Line: 1836
            -- upvalues: LocalPlayer (ref), u51 (ref), GuiController (ref)
            local v374 = LocalPlayer:GetAttribute("GuildRole");

            if v374 ~= "Owner" and v374 ~= "Elder" then
                return;
            end;

            if u51 then
                return;
            end;

            GuiController:Open("GuildInvite", nil, { "HUD" });
        end);
    end;

    if u20 then
        u20.MouseButton1Click:Connect(function() -- Line: 1848
            -- upvalues: LocalPlayer (ref), u51 (ref), GuiController (ref)
            if LocalPlayer:GetAttribute("GuildRole") ~= "Owner" then
                return;
            end;

            if u51 then
                return;
            end;

            GuiController:Open("GuildTransfer", nil, { "HUD" });
        end);
    end;

    if u28 then
        u28.MouseButton1Click:Connect(promptBuySlots);
    end;

    if u12 then
        u12.MouseButton1Click:Connect(function() -- Line: 1876
            -- upvalues: u51 (ref), u52 (ref), LocalPlayer (ref), GuiController (ref)
            local ViewGuildProgressController = require(LocalPlayer.PlayerScripts.Controllers.ViewGuildProgressController);

            if typeof(ViewGuildProgressController.SetTargetGuildId) == "function" then
                ViewGuildProgressController:SetTargetGuildId(u51 or LocalPlayer:GetAttribute("GuildId"));
            end;

            GuiController:Open("ViewGuildProgress", nil, { "HUD" });
            u51 = u51;
            u52 = u52;
        end);
    end;
end;

function v3.OpenForGuildId(p375, p376) -- Line: 1895
    -- upvalues: LocalPlayer (copy), u51 (ref), u52 (ref), GuiController (copy), u151 (ref)
    if typeof(p376) ~= "string" or p376 == "" then
        return;
    end;

    if p376 == LocalPlayer:GetAttribute("GuildId") then
        u51 = nil;
    else
        u51 = p376;
    end;

    u52 = false;

    if GuiController:IsOpen("ViewGuildPage") then
        u151();

        return;
    end;

    GuiController:Open("ViewGuildPage", nil, { "HUD" });
end;

function v3.OpenForGuildIdFromLeaderboard(p377, p378) -- Line: 1920
    -- upvalues: LocalPlayer (copy), u51 (ref), u52 (ref), GuiController (copy), u151 (ref)
    if typeof(p378) ~= "string" or p378 == "" then
        return;
    end;

    if p378 == LocalPlayer:GetAttribute("GuildId") then
        u51 = nil;
    else
        u51 = p378;
    end;

    u52 = true;

    if GuiController:IsOpen("ViewGuildPage") then
        u151();

        return;
    end;

    GuiController:Open("ViewGuildPage", nil, { "HUD" });
end;

function v3.Init(p379) -- Line: 1939
end;

function v3.Start(p380) -- Line: 1941
    -- upvalues: PlayerGui (copy), u4 (ref), ResolveRefs (copy), BindButtons (copy), LocalPlayer (copy), u39 (ref), u51 (ref), GuiController (copy), u151 (ref), renderScoreLine (copy), Networking (copy), u29 (ref), u30 (ref), u32 (ref), applyGuildTitle (copy), u31 (copy), contribsUserIds (copy), reconcileLeaderboardAfterLeave (copy), applyGuildSnapshot (copy), u42 (copy), applyPresenceToRows (copy), u22 (ref), refreshHeader (copy), u35 (ref), u36 (ref), u52 (ref)
    task.spawn(function() -- Line: 1942
        -- upvalues: PlayerGui (ref), u4 (ref), ResolveRefs (ref), BindButtons (ref), LocalPlayer (ref), u39 (ref), u51 (ref), GuiController (ref), u151 (ref), renderScoreLine (ref), Networking (ref), u29 (ref), u30 (ref), u32 (ref), applyGuildTitle (ref), u31 (ref), contribsUserIds (ref), reconcileLeaderboardAfterLeave (ref), applyGuildSnapshot (ref), u42 (ref), applyPresenceToRows (ref), u22 (ref), refreshHeader (ref), u35 (ref), u36 (ref), u52 (ref)
        local ViewGuildPage = PlayerGui:WaitForChild("ViewGuildPage", 30);

        if not (ViewGuildPage and ViewGuildPage:IsA("ScreenGui")) then
            return;
        end;

        u4 = ViewGuildPage;
        ViewGuildPage.Enabled = false;
        ResolveRefs(ViewGuildPage);
        BindButtons();
        LocalPlayer:GetAttributeChangedSignal("GuildId"):Connect(function() -- Line: 1953
            -- upvalues: u39 (ref), u51 (ref), LocalPlayer (ref), GuiController (ref), u151 (ref)
            if not u39 then
                return;
            end;

            if u51 then
                return;
            end;

            if LocalPlayer:GetAttribute("GuildId") == nil then
                if GuiController:IsOpen("ViewGuildPage") then
                    GuiController:Close();
                end;
            else
                u151();
            end;
        end);
        LocalPlayer:GetAttributeChangedSignal("GuildRank"):Connect(function() -- Line: 1969
            -- upvalues: u39 (ref), u51 (ref), renderScoreLine (ref)
            if not u39 then
                return;
            end;

            if u51 then
                return;
            end;

            renderScoreLine();
        end);
        Networking.Guild.TickUpdate.OnClientEvent:Connect(function(p381) -- Line: 1977
            -- upvalues: u29 (ref), u30 (ref), u39 (ref), u32 (ref), applyGuildTitle (ref), renderScoreLine (ref), u31 (ref), contribsUserIds (ref), reconcileLeaderboardAfterLeave (ref), u51 (ref), applyGuildSnapshot (ref), u42 (ref), applyPresenceToRows (ref), u22 (ref)
            if typeof(p381) ~= "table" then
                return;
            end;

            if p381.Kind == "Leaderboard" then
                local v382;

                if typeof(p381.Source) == "string" then
                    v382 = p381.Source;
                else
                    v382 = nil;
                end;

                if v382 == "weekly" then
                    u29 = p381.TopGuilds or {};
                    u30 = "weekly";
                else
                    u29 = {};
                    u30 = v382;
                end;

                if u39 and u32 then
                    applyGuildTitle(u32.Guild);
                    renderScoreLine();
                end;
            elseif p381.Kind == "GuildmateContribs" then
                local v383 = tostring(p381.GuildId or "");

                if v383 ~= "" and typeof(p381.Members) == "table" then
                    local v384 = u31[v383];
                    u31[v383] = p381.Members;

                    if typeof(v384) == "table" then
                        local v385 = contribsUserIds(p381.Members);
                        local v386 = false;

                        for i in contribsUserIds(v384) do
                            if not v385[i] then
                                v386 = true;
                                break;
                            end;
                        end;

                        if v386 then
                            reconcileLeaderboardAfterLeave(v383, p381.Members);
                        end;
                    end;
                end;

                if u39 and (u32 and not u51) then
                    applyGuildSnapshot(u32);
                end;
            elseif p381.Kind == "GuildPresence" then
                local v387 = tostring(p381.GuildId or "");
                local UserIds = p381.UserIds;

                if v387 ~= "" and typeof(UserIds) == "table" then
                    local v388 = {};

                    for _, v in UserIds do
                        local v389 = tonumber(v);

                        if v389 then
                            v388[v389] = true;
                        end;
                    end;

                    u42[v387] = v388;
                    local v390 = 0;

                    for _ in v388 do
                        v390 = v390 + 1;
                    end;

                    if u39 and (u32 and (u32.Guild and tostring(u32.Guild.GuildId or "") == v387)) then
                        applyPresenceToRows(v387);

                        if u22 and u22.Parent then
                            local v391 = u22;
                            local v392 = string.format("Members (%d online)", v390);

                            if not v391 then
                                return;
                            end;

                            v391.RichText = true;
                            v391.Text = v392;
                            local TextLabel = v391:FindFirstChild("TextLabel");

                            if TextLabel and TextLabel:IsA("TextLabel") then
                                TextLabel.RichText = true;
                                TextLabel.Text = v392;
                            end;
                        end;
                    end;
                end;
            end;
        end);
        GuiController.GuiFocusedSignal:Connect(function(p393) -- Line: 2045
            -- upvalues: ViewGuildPage (copy), u39 (ref), refreshHeader (ref), u35 (ref), u151 (ref)
            if p393 == ViewGuildPage then
                u39 = true;
                refreshHeader();

                if not u35 then
                    u35 = task.spawn(function() -- Line: 1523
                        -- upvalues: u39 (ref), refreshHeader (ref)
                        while u39 do
                            refreshHeader();
                            task.wait(1);
                        end;
                    end);
                end;

                u151();
            end;
        end);
        GuiController.GuiUnfocusedSignal:Connect(function(p394) -- Line: 2053
            -- upvalues: ViewGuildPage (copy), u39 (ref), u35 (ref), u36 (ref), u51 (ref), u52 (ref)
            if p394 == ViewGuildPage then
                u39 = false;

                if u35 then
                    task.cancel(u35);
                    u35 = nil;
                end;

                if u36 then
                    task.cancel(u36);
                    u36 = nil;
                end;

                u51 = nil;
                u52 = false;
            end;
        end);
    end);
end;

return v3;