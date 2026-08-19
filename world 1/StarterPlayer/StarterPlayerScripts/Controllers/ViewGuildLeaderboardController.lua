-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local ServerClock = require(ReplicatedStorage.ClientModules.ServerClock);
local GuildCompetition = require(ReplicatedStorage.SharedModules.GuildCompetition);
local Asserts = require(ReplicatedStorage.SharedModules.Guild.Asserts);
local GuildContestFlags = require(ReplicatedStorage.SharedModules.Flags.GuildContestFlags);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local ViewGuildController = require(LocalPlayer.PlayerScripts.Controllers.ViewGuildController);
local ViewGuildProgressController = require(LocalPlayer.PlayerScripts.Controllers.ViewGuildProgressController);
local u1 = { "RainbowGradient", "GoldGradient", "SilverGradient", "BronzeGradient" };
local v2 = {
    StartOrder = 9
};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = nil;
local u11 = nil;
local u12 = nil;
local u13 = false;
local u14 = nil;
local u15 = 0;
local u16 = "global";
local u17 = nil;
local u18 = nil;
local u19 = nil;
local u20 = nil;
local u21 = nil;
local u22 = nil;
local u23 = nil;
local u24 = nil;
local u25 = false;
local u26 = nil;
local u27 = {};
local u28 = nil;
local u29 = nil;
local u30 = nil;
local u31 = false;
local u32 = {};
local u33 = {};
local u34 = {};
local u35 = {};
local u36 = nil;
local u37 = nil;
local u38 = (-1 / 0);
local u39 = nil;
local u40 = nil;
local u41 = nil;
local u42 = nil;
local u43 = nil;
local u44 = nil;

local function currentScoreFormat() -- Line: 153
    -- upvalues: u36 (ref)
    local v45 = u36;

    if typeof(v45) ~= "table" then
        return nil;
    end;

    local v46;

    if typeof(v45.config) == "table" then
        v46 = v45.config;
    else
        v46 = v45.lastConfig;
    end;

    if typeof(v46) == "table" and typeof(v46.scoreFormat) == "string" then
        return v46.scoreFormat;
    end;

    return nil;
end;

local function fetchCompetition(p47) -- Line: 168
    -- upvalues: u38 (ref), Networking (copy), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref)
    local v48 = os.clock();

    if not p47 and v48 - u38 < 15 then
        return;
    end;

    u38 = v48;
    task.spawn(function() -- Line: 172
        -- upvalues: Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref)
        local success, result = pcall(function() -- Line: 173
            -- upvalues: Networking (ref)
            return Networking.Guild.GetCompetition:Fire();
        end);

        if not success or typeof(result) ~= "table" then
            return;
        end;

        local v49 = u36;
        local v50;

        if typeof(v49) == "table" then
            local v51;

            if typeof(v49.config) == "table" then
                v51 = v49.config;
            else
                v51 = v49.lastConfig;
            end;

            if typeof(v51) == "table" and typeof(v51.scoreFormat) == "string" then
                v50 = v51.scoreFormat;
            else
                v50 = nil;
            end;
        else
            v50 = nil;
        end;

        u36 = result;

        if result.phase == "running" and typeof(result.endsAt) == "number" then
            u37 = result.endsAt;
        elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
            u37 = result.startsAt;
        else
            u37 = nil;
        end;

        local v52 = u36;
        local v53;

        if typeof(v52) == "table" then
            local v54;

            if typeof(v52.config) == "table" then
                v54 = v52.config;
            else
                v54 = v52.lastConfig;
            end;

            if typeof(v54) == "table" and typeof(v54.scoreFormat) == "string" then
                v53 = v54.scoreFormat;
            else
                v53 = nil;
            end;
        else
            v53 = nil;
        end;

        local v55 = v53 ~= v50 and u40;

        if v55 then
            v55();
        end;

        local v56 = u41;

        if v56 then
            v56();
        end;

        local v57 = u42;

        if v57 then
            v57();
        end;
    end);
end;

local function getPreferredNextReset(p58) -- Line: 201
    -- upvalues: u37 (ref)
    if u37 and p58 < u37 then
        return u37;
    end;

    return nil;
end;

local function formatTimeRemaining(p59) -- Line: 208
    -- upvalues: u36 (ref)
    local v60 = u36 and u36.phase == "pending" and "Starts in" or "Ends in";
    local v61 = math.floor((p59 < 0 and 0 or p59) + 0.5);

    if v61 < 3600 then
        local v62 = v61 // 60;

        return string.format("%s %dm %ds", v60, v62, v61 - v62 * 60);
    end;

    if v61 < 86400 then
        local v63 = v61 // 3600;

        return string.format("%s %dh %dm", v60, v63, (v61 - v63 * 3600) // 60);
    end;

    local v64 = v61 // 86400;

    return string.format("%s %dd %dh", v60, v64, (v61 - v64 * 86400) // 3600);
end;

local function parseIso(p65) -- Line: 233
    if typeof(p65) ~= "string" or p65 == "" then
        return nil;
    end;

    local success, result = pcall(DateTime.fromIsoDate, p65);

    if success and result then
        return result.UnixTimestamp;
    end;

    return nil;
end;

local function extractMailbox(p66) -- Line: 242
    if typeof(p66) ~= "table" then
        return nil;
    end;

    if typeof(p66.Mailbox) == "table" then
        return p66.Mailbox;
    end;

    return p66;
end;

local function placementInRewards(p67, p68) -- Line: 253
    if typeof(p68) ~= "table" then
        return false;
    end;

    for i in p68 do
        if typeof(i) == "string" then
            local v69 = string.find(i, "-", 1, true);
            local v70, v71;

            if v69 then
                local v72 = string.sub(i, 1, v69 - 1);
                v70 = tonumber(v72);
                local v73 = string.sub(i, v69 + 1);

                if v73 == "" then
                    v71 = (1 / 0);
                else
                    v71 = tonumber(v73);
                end;
            else
                v70 = tonumber(i);
                v71 = v70;
            end;

            if v70 and (v71 and (v70 <= p67 and p67 <= v71)) then
                return true;
            end;
        end;
    end;

    return false;
end;

local function guildRankInStandings(p74) -- Line: 277
    -- upvalues: u39 (ref), u43 (ref)
    local v75 = u39 or u43;

    if typeof(v75) ~= "table" then
        return nil;
    end;

    for _, v in v75 do
        if typeof(v) == "table" and (v.guildId or v.GuildId) == p74 then
            return tonumber(v.rank or v.Rank);
        end;
    end;

    return nil;
end;

local function markSeenGuildRewards() -- Line: 295
    -- upvalues: u26 (ref), u27 (copy)
    if typeof(u26) ~= "table" then
        return;
    end;

    for _, v in u26 do
        if typeof(v) == "table" and v.Kind == "GuildReward" then
            local CompetitionId = v.CompetitionId;

            if typeof(CompetitionId) == "string" and CompetitionId ~= "" then
                u27[CompetitionId] = true;
            end;
        end;
    end;
end;

local function rewardDelivered(p76) -- Line: 311
    -- upvalues: u27 (copy), u26 (ref)
    if u27[p76] then
        return true;
    end;

    if typeof(u26) ~= "table" then
        return false;
    end;

    for _, v in u26 do
        if typeof(v) == "table" and (v.Kind == "GuildReward" and tostring(v.CompetitionId) == p76) then
            return true;
        end;
    end;

    return false;
end;

local function hexToRgbToken(p77) -- Line: 328
    local v78 = typeof(p77) ~= "string" and "" or p77;

    if #v78 > 0 and v78:sub(1, 1) == "#" then
        v78 = v78:sub(2);
    end;

    if #v78 ~= 6 then
        return "rgb(255,255,255)";
    end;

    local v79 = v78:sub(1, 2);
    local v80 = tonumber(v79, 16);
    local v81 = v78:sub(3, 4);
    local v82 = tonumber(v81, 16);
    local v83 = v78:sub(5, 6);
    local v84 = tonumber(v83, 16);

    return not (v80 and (v82 and v84)) and "rgb(255,255,255)" or string.format("rgb(%d,%d,%d)", v80, v82, v84);
end;

local function escapeRichText(p85) -- Line: 339
    return p85:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;");
end;

local function trackCardConn(p86) -- Line: 349
    -- upvalues: u33 (copy)
    table.insert(u33, p86);
end;

local function clearScrolling() -- Line: 353
    -- upvalues: u33 (copy), u32 (copy), u39 (ref), u44 (ref)
    for _, v in u33 do
        pcall(function() -- Line: 355
            -- upvalues: v (copy)
            v:Disconnect();
        end);
    end;

    table.clear(u33);

    for _, v in u32 do
        if v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(u32);
    u39 = nil;
    u44 = nil;
end;

local function buildNameRich(p87, p88, p89) -- Line: 375
    return string.format("<font color=\"%s\">%s</font> <font color=\"%s\">[%s]</font>", p89, p87:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"), p89, (p88:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")));
end;

local function setNameLabel(p90, p91, p92, p93) -- Line: 382
    -- upvalues: hexToRgbToken (copy)
    local v94 = hexToRgbToken(p93);
    p90.RichText = true;
    p90.Text = string.format("<font color=\"%s\">%s</font> <font color=\"%s\">[%s]</font>", "rgb(0,0,0)", p91:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"), "rgb(0,0,0)", (p92:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")));
    local GuildTextLabelName2 = p90:FindFirstChild("GuildTextLabelName2");

    if GuildTextLabelName2 and GuildTextLabelName2:IsA("TextLabel") then
        GuildTextLabelName2.RichText = true;
        GuildTextLabelName2.Text = string.format("<font color=\"%s\">%s</font> <font color=\"%s\">[%s]</font>", v94, p91:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"), v94, (p92:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;")));
    end;
end;

local function setRankText(p95, p96) -- Line: 394
    p95.RichText = false;
    p95.Text = p96;
    local RankTextLabel2 = p95:FindFirstChild("RankTextLabel2");

    if RankTextLabel2 and RankTextLabel2:IsA("TextLabel") then
        RankTextLabel2.RichText = false;
        RankTextLabel2.Text = p96;
    end;
end;

local function gradientNameForRank(p97) -- Line: 404
    return p97 == 1 and "RainbowGradient" or (p97 == 2 and "GoldGradient" or (p97 == 3 and "SilverGradient" or "BronzeGradient"));
end;

local function applyGradient(p98, p99) -- Line: 419
    -- upvalues: u1 (copy)
    if not p98 then
        return;
    end;

    local v100 = p99 == 1 and "RainbowGradient" or (p99 == 2 and "GoldGradient" or (p99 == 3 and "SilverGradient" or "BronzeGradient"));

    for _, v in u1 do
        local v101 = p98:FindFirstChild(v);

        if v101 and v101:IsA("UIGradient") then
            if v == v100 then
                v101.Enabled = true;
            else
                v101:Destroy();
            end;
        end;
    end;
end;

local function applyIconImage(p102, p103) -- Line: 436
    -- upvalues: Asserts (copy)
    local GuildImage = p102:FindFirstChild("GuildImage");

    if not GuildImage then
        return;
    end;

    local GuildSkinImage = GuildImage:FindFirstChild("GuildSkinImage");

    if not (GuildSkinImage and GuildSkinImage:IsA("ImageLabel")) then
        return;
    end;

    if typeof(p103) ~= "number" then
        p103 = nil;
    end;

    GuildSkinImage.Image = Asserts.IconAssetString(p103);
end;

local function applySummaryToCard(p104, p105) -- Line: 445
    -- upvalues: setNameLabel (copy), applyIconImage (copy)
    if typeof(p105) ~= "table" then
        return;
    end;

    local GuildTextLabelName1 = p104:FindFirstChild("GuildTextLabelName1");

    if GuildTextLabelName1 and GuildTextLabelName1:IsA("TextLabel") then
        setNameLabel(GuildTextLabelName1, tostring(p105.Name or ""), tostring(p105.Tag or ""), p105.Color);
    end;

    applyIconImage(p104, p105.IconId);
end;

local function fetchSummaryAndApply(u106, u107) -- Line: 457
    -- upvalues: u34 (copy), applySummaryToCard (copy), u35 (copy), Networking (copy)
    local v108 = u34[u107];

    if v108 then
        applySummaryToCard(u106, v108);

        return;
    end;

    if u35[u107] then
        return;
    end;

    u35[u107] = true;
    task.spawn(function() -- Line: 465
        -- upvalues: Networking (ref), u107 (copy), u35 (ref), u34 (ref), u106 (copy), applySummaryToCard (ref)
        local success, result = pcall(function() -- Line: 466
            -- upvalues: Networking (ref), u107 (ref)
            return Networking.Guild.GetGuildById:Fire(u107);
        end);
        u35[u107] = nil;

        if success and typeof(result) == "table" then
            u34[u107] = result;

            if u106.Parent then
                applySummaryToCard(u106, result);
            end;
        end;
    end);
end;

local function buildCard(p109, p110, p111, p112, p113) -- Line: 486
    -- upvalues: u5 (ref), u4 (ref), u32 (copy), applyGradient (copy), GuildCompetition (copy), u36 (ref), setNameLabel (copy), applyIconImage (copy), u34 (copy), applySummaryToCard (copy), u35 (copy), Networking (copy), ViewGuildController (copy), u33 (copy)
    if not (u5 and u4) then
        return;
    end;

    local u114 = u5:Clone();
    u114.Name = string.format("PlayerCard_Rank%d", p109);
    u114.Visible = true;
    u114.LayoutOrder = p111 or p109;
    u114.Parent = u4;
    table.insert(u32, u114);
    local RankTextLabel1 = u114:FindFirstChild("RankTextLabel1");

    if RankTextLabel1 and RankTextLabel1:IsA("TextLabel") then
        local v115 = p112 or "#" .. tostring(p109);
        RankTextLabel1.RichText = false;
        RankTextLabel1.Text = v115;
        local RankTextLabel2 = RankTextLabel1:FindFirstChild("RankTextLabel2");

        if RankTextLabel2 and RankTextLabel2:IsA("TextLabel") then
            RankTextLabel2.RichText = false;
            RankTextLabel2.Text = v115;
        end;

        applyGradient(RankTextLabel1:FindFirstChild("RankTextLabel2"), p109 <= 0 and 99 or p109);
    end;

    local v116 = p113 and u114:FindFirstChildWhichIsA("UIStroke");

    if v116 then
        v116.Color = Color3.fromRGB(255, 200, 60);
        v116.Thickness = math.max(v116.Thickness, 0.05);
    end;

    local TotalContribution = u114:FindFirstChild("TotalContribution");

    if TotalContribution and TotalContribution:IsA("TextLabel") then
        local v117 = tonumber(p110.shekels or (p110.Shekels or p110.score));
        TotalContribution.RichText = false;
        local FormatScore = GuildCompetition.FormatScore;
        local v118 = u36;
        local v119;

        if typeof(v118) == "table" then
            local v120;

            if typeof(v118.config) == "table" then
                v120 = v118.config;
            else
                v120 = v118.lastConfig;
            end;

            if typeof(v120) == "table" and typeof(v120.scoreFormat) == "string" then
                v119 = v120.scoreFormat;
            else
                v119 = nil;
            end;
        else
            v119 = nil;
        end;

        TotalContribution.Text = "Score: " .. FormatScore(v117, v119);
    end;

    local SheckleImage = u114:FindFirstChild("SheckleImage");

    if SheckleImage and SheckleImage:IsA("GuiObject") then
        SheckleImage.Visible = false;
    end;

    local v121 = p110.name or p110.Name;
    local GuildTextLabelName1 = u114:FindFirstChild("GuildTextLabelName1");

    if GuildTextLabelName1 and GuildTextLabelName1:IsA("TextLabel") then
        setNameLabel(GuildTextLabelName1, tostring(v121 or "?"), tostring(p110.tag or (p110.Tag or "?")), p110.color or p110.Color);
    end;

    applyIconImage(u114, p110.iconId or p110.IconId);
    local u122 = p110.guildId or p110.GuildId;
    local v123;

    if typeof(v121) == "string" then
        v123 = v121 ~= "";
    else
        v123 = false;
    end;

    if typeof(u122) == "string" and (u122 ~= "" and not v123) then
        local v124 = u34[u122];

        if v124 then
            applySummaryToCard(u114, v124);
        elseif not u35[u122] then
            u35[u122] = true;
            task.spawn(function() -- Line: 465
                -- upvalues: Networking (ref), u122 (copy), u35 (ref), u34 (ref), u114 (copy), applySummaryToCard (ref)
                local success, result = pcall(function() -- Line: 466
                    -- upvalues: Networking (ref), u122 (ref)
                    return Networking.Guild.GetGuildById:Fire(u122);
                end);
                u35[u122] = nil;

                if success and typeof(result) == "table" then
                    u34[u122] = result;

                    if u114.Parent then
                        applySummaryToCard(u114, result);
                    end;
                end;
            end);
        end;
    end;

    local ViewButton = u114:FindFirstChild("ViewButton");

    if ViewButton and ViewButton:IsA("GuiButton") then
        local v125 = ViewButton.MouseButton1Click:Connect(function() -- Line: 561
            -- upvalues: u122 (copy), ViewGuildController (ref)
            if typeof(u122) ~= "string" or u122 == "" then
                return;
            end;

            ViewGuildController:OpenForGuildIdFromLeaderboard(u122);
        end);
        table.insert(u33, v125);
    end;
end;

local function setStatus(p126) -- Line: 573
    -- upvalues: u9 (ref)
    if not u9 then
        return;
    end;

    u9.Text = p126;
    u9.Visible = p126 ~= "";
end;

local function computeSignature(p127) -- Line: 582
    -- upvalues: u36 (ref)
    local v128 = {};
    local v129 = u36;
    local v130;

    if typeof(v129) == "table" then
        local v131;

        if typeof(v129.config) == "table" then
            v131 = v129.config;
        else
            v131 = v129.lastConfig;
        end;

        if typeof(v131) == "table" and typeof(v131.scoreFormat) == "string" then
            v130 = v131.scoreFormat;
        else
            v130 = nil;
        end;
    else
        v130 = nil;
    end;

    v128[1] = tostring(v130);

    for _, v in p127 do
        if typeof(v) == "table" then
            v128[#v128 + 1] = string.format("%s:%s:%s:%s:%s:%s:%s", tostring(v.guildId or (v.GuildId or "")), tostring(v.rank or (v.Rank or "")), tostring(v.shekels or v.Shekels or (v.score or "")), tostring(v.name or (v.Name or "")), tostring(v.tag or (v.Tag or "")), tostring(v.color or (v.Color or "")), (tostring(v.iconId or (v.IconId or ""))));
        end;
    end;

    return table.concat(v128, "|");
end;

local function rebuildBoard(p132) -- Line: 598
    -- upvalues: computeSignature (copy), u44 (ref), u32 (copy), u39 (ref), u9 (ref), clearScrolling (copy), buildCard (copy)
    local v133 = computeSignature(p132);

    if v133 == u44 and #u32 > 0 then
        u39 = p132;

        if u9 then
            u9.Text = "";
            u9.Visible = false;
        end;

        return #u32;
    end;

    clearScrolling();
    u39 = p132;
    u44 = v133;
    local v134 = 0;

    if p132 then
        for i = 1, math.min(#p132, 200) do
            local v135 = p132[i];

            if typeof(v135) == "table" and (tonumber(v135.shekels or v135.Shekels) or 0) > 0 then
                buildCard(tonumber(v135.rank or v135.Rank) or i, v135);
                v134 = v134 + 1;
            end;
        end;
    end;

    if v134 > 0 then
        if not u9 then
            return v134;
        end;

        u9.Text = "";
        u9.Visible = false;
    end;

    return v134;
end;

local function localSnapshotState() -- Line: 647
    -- upvalues: GuildContestFlags (copy), u36 (ref), LocalPlayer (copy)
    if not GuildContestFlags.LocalContestsEnabled:Get() then
        return "off", nil, nil;
    end;

    local v136 = u36;

    if typeof(v136) ~= "table" or v136.phase ~= "running" then
        return "off", nil, nil;
    end;

    local config = v136.config;
    local v137;

    if typeof(config) == "table" then
        v137 = config["local"];
    else
        v137 = nil;
    end;

    if typeof(v137) ~= "table" or v137.enabled == false then
        return "off", nil, nil;
    end;

    local v138 = LocalPlayer:GetAttribute("GuildId");

    if typeof(v138) ~= "string" or v138 == "" then
        return "no_guild", nil, v137;
    end;

    local localBracket = v136.localBracket;

    if typeof(localBracket) ~= "table" then
        return "pending", nil, v137;
    end;

    if localBracket.status == "assigned" and typeof(localBracket.standings) == "table" then
        return "assigned", localBracket.standings, localBracket;
    end;

    if localBracket.status == "excluded_top" then
        return "excluded_top", nil, v137;
    end;

    if localBracket.status == "unranked" then
        return "unranked", nil, v137;
    end;

    return "pending", nil, v137;
end;

local function rebuildLocalBoard(p139) -- Line: 673
    -- upvalues: computeSignature (copy), u44 (ref), u32 (copy), u9 (ref), clearScrolling (copy), LocalPlayer (copy), buildCard (copy)
    local v140 = "local|" .. computeSignature(p139);

    if v140 == u44 and #u32 > 0 then
        if u9 then
            u9.Text = "";
            u9.Visible = false;
        end;

        return #u32;
    end;

    clearScrolling();
    u44 = v140;
    local v141 = LocalPlayer:GetAttribute("GuildId");
    local v142 = 0;

    for i, v in p139 do
        if typeof(v) == "table" then
            local v143 = tonumber(v.rank) or 0;
            buildCard(v143, v, i, v143 <= 0 and "-" or "#" .. tostring(v143), v.guildId == v141);
            v142 = v142 + 1;
        end;
    end;

    if v142 > 0 then
        if not u9 then
            return v142;
        end;

        u9.Text = "";
        u9.Visible = false;
    end;

    return v142;
end;

local function applyHeaderTitle(p144) -- Line: 704
    -- upvalues: u20 (ref), u16 (ref), u21 (ref)
    if not u20 then
        return;
    end;

    local v145;

    if u16 == "local" then
        v145 = (not p144 or p144 == "") and "Local Bracket" or "Local Bracket " .. p144;
    else
        v145 = u21 or "Top Guilds";
    end;

    u20.Text = v145;
    local TextLabel = u20:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = v145;
    end;
end;

local function renderLocalBoard() -- Line: 718
    -- upvalues: localSnapshotState (copy), u20 (ref), u16 (ref), u21 (ref), rebuildLocalBoard (copy), clearScrolling (copy), u9 (ref)
    local v146, v147, v148 = localSnapshotState();

    if v146 == "assigned" and v147 then
        local v149;

        if typeof(v148) == "table" then
            v149 = tostring(v148.label or "");
        else
            v149 = nil;
        end;

        if u20 then
            local v150;

            if u16 == "local" then
                v150 = (not v149 or v149 == "") and "Local Bracket" or "Local Bracket " .. v149;
            else
                v150 = u21 or "Top Guilds";
            end;

            u20.Text = v150;
            local TextLabel = u20:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = v150;
            end;
        end;

        if rebuildLocalBoard(v147) > 0 then
            return;
        end;
    end;

    if u20 then
        local v151 = u16 == "local" and "Local Bracket" or (u21 or "Top Guilds");
        u20.Text = v151;
        local TextLabel = u20:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = v151;
        end;
    end;

    clearScrolling();

    if v146 == "no_guild" then
        if not u9 then
            return;
        end;

        u9.Text = "Join a guild to enter local contests!";
        u9.Visible = true;

        return;
    end;

    if v146 == "excluded_top" then
        local v152;

        if typeof(v148) == "table" then
            v152 = tonumber(v148.excludeTopN);
        else
            v152 = nil;
        end;

        local v153 = v152 and v152 == 1 and "Your guild finished #1 globally last week -- no local bracket, you\'re up against the best!" or ((not v152 or v152 <= 0) and "Your guild is competing in the global league -- no local bracket!" or string.format("Your guild finished in the global top %d last week -- no local bracket, you\'re up against the best!", v152));

        if not u9 then
            return;
        end;

        u9.Text = v153;
        u9.Visible = v153 ~= "";

        return;
    end;

    if v146 == "unranked" then
        if not u9 then
            return;
        end;

        u9.Text = "Your guild wasn\'t ranked last week.\nScore this week to enter a local bracket next week!";
        u9.Visible = true;

        return;
    end;

    if v146 == "off" then
        if not u9 then
            return;
        end;

        u9.Text = "No local contests this week.";
        u9.Visible = true;

        return;
    end;

    if not u9 then
        return;
    end;

    u9.Text = "Local brackets are being set up -- check back soon!";
    u9.Visible = true;
end;

local u154 = nil;
local u155 = nil;

local function updateTabBar() -- Line: 754
    -- upvalues: u17 (ref), localSnapshotState (copy), u154 (ref), u155 (ref), u16 (ref), u22 (ref)
    if not u17 then
        return;
    end;

    local v156 = localSnapshotState() ~= "off";

    if u17.Visible ~= v156 then
        u17.Visible = v156;
        local v157 = u154;

        if v157 then
            v157();
        end;

        local v158 = u155;

        if v158 then
            v158();
        end;
    end;

    local v159 = not v156 and (u16 == "local" and u22);

    if v159 then
        v159("global");
    end;
end;

u42 = function() -- Line: 773
    -- upvalues: u13 (ref), u17 (ref), localSnapshotState (copy), u154 (ref), u155 (ref), u16 (ref), u22 (ref), renderLocalBoard (copy)
    if not u13 then
        return;
    end;

    if u17 then
        local v160 = localSnapshotState() ~= "off";

        if u17.Visible ~= v160 then
            u17.Visible = v160;
            local v161 = u154;

            if v161 then
                v161();
            end;

            local v162 = u155;

            if v162 then
                v162();
            end;
        end;

        local v163 = not v160 and (u16 == "local" and u22);

        if v163 then
            v163("global");
        end;
    end;

    if u16 == "local" then
        renderLocalBoard();
    end;
end;

u40 = function() -- Line: 784
    -- upvalues: u13 (ref), u16 (ref), renderLocalBoard (copy), u39 (ref), rebuildBoard (copy)
    if not u13 then
        return;
    end;

    if u16 == "local" then
        renderLocalBoard();

        return;
    end;

    local v164 = u39;

    if v164 then
        rebuildBoard(v164);
    end;
end;

local function fetchLeaderboard() -- Line: 807
    -- upvalues: u15 (ref), u13 (ref), Networking (copy), u43 (ref), rebuildBoard (copy), u32 (copy), u9 (ref)
    u15 = u15 + 1;
    local u165 = u15;
    task.spawn(function() -- Line: 810
        -- upvalues: u13 (ref), u165 (copy), u15 (ref), Networking (ref), u43 (ref), rebuildBoard (ref), u32 (ref), u9 (ref)
        for _ = 1, 12 do
            if not u13 or u165 ~= u15 then
                return;
            end;

            local success, result = pcall(function() -- Line: 815
                -- upvalues: Networking (ref)
                return Networking.Guild.GetLeaderboard:Fire("weekly");
            end);

            if not u13 or u165 ~= u15 then
                return;
            end;

            local v166 = (not success or typeof(result) ~= "table") and {} or result;

            if #v166 > 0 then
                u43 = v166;

                if rebuildBoard(v166) > 0 then
                    return;
                end;
            elseif #u32 > 0 then
                return;
            end;

            if u9 then
                u9.Text = "Loading...";
                u9.Visible = true;
            end;

            task.wait(2);
        end;

        if u13 and u165 == u15 then
            if not u9 then
                return;
            end;

            u9.Text = "No guilds have scored yet";
            u9.Visible = true;
        end;
    end);
end;

local function setRewardNoticeShown(p167) -- Line: 860
    -- upvalues: u25 (ref), u23 (ref), u4 (ref), u24 (ref), u31 (ref), u17 (ref)
    if p167 == u25 then
        return;
    end;

    u25 = p167;

    if u23 then
        u23.Visible = p167;
    end;

    if u4 then
        if not u24 then
            return;
        end;

        local v168 = 0;

        if u25 then
            v168 = v168 + 0.24;
        end;

        if u31 then
            v168 = v168 + 0.24;
        end;

        if u17 and u17.Visible then
            v168 = v168 + 0.15;
        end;

        local v169 = u24;
        u4.Size = UDim2.new(v169.X.Scale, v169.X.Offset, v169.Y.Scale - v168, v169.Y.Offset);
    end;
end;

local function setStatusBannerShown(p170) -- Line: 867
    -- upvalues: u31 (ref), u28 (ref), u4 (ref), u24 (ref), u25 (ref), u17 (ref)
    if p170 == u31 then
        return;
    end;

    u31 = p170;

    if u28 then
        u28.Visible = p170;
    end;

    if u4 then
        if not u24 then
            return;
        end;

        local v171 = 0;

        if u25 then
            v171 = v171 + 0.24;
        end;

        if u31 then
            v171 = v171 + 0.24;
        end;

        if u17 and u17.Visible then
            v171 = v171 + 0.15;
        end;

        local v172 = u24;
        u4.Size = UDim2.new(v172.X.Scale, v172.X.Offset, v172.Y.Scale - v171, v172.Y.Offset);
    end;
end;

u154 = function() -- Line: 850, Name: updateScrollInsets
    -- upvalues: u4 (ref), u24 (ref), u25 (ref), u31 (ref), u17 (ref)
    if not (u4 and u24) then
        return;
    end;

    local v173 = 0;

    if u25 then
        v173 = v173 + 0.24;
    end;

    if u31 then
        v173 = v173 + 0.24;
    end;

    if u17 and u17.Visible then
        v173 = v173 + 0.15;
    end;

    local v174 = u24;
    u4.Size = UDim2.new(v174.X.Scale, v174.X.Offset, v174.Y.Scale - v173, v174.Y.Offset);
end;

local function updateRewardNotice() -- Line: 881
    -- upvalues: u23 (ref), u13 (ref), u25 (ref), u4 (ref), u24 (ref), u31 (ref), u17 (ref), u16 (ref), u36 (ref), LocalPlayer (copy), guildRankInStandings (copy), placementInRewards (copy), rewardDelivered (copy)
    if not (u23 and u13) then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v175 = 0;

            if u25 then
                v175 = v175 + 0.24;
            end;

            if u31 then
                v175 = v175 + 0.24;
            end;

            if u17 and u17.Visible then
                v175 = v175 + 0.15;
            end;

            local v176 = u24;
            u4.Size = UDim2.new(v176.X.Scale, v176.X.Offset, v176.Y.Scale - v175, v176.Y.Offset);
        end;

        return;
    end;

    if u16 ~= "global" then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v177 = 0;

            if u25 then
                v177 = v177 + 0.24;
            end;

            if u31 then
                v177 = v177 + 0.24;
            end;

            if u17 and u17.Visible then
                v177 = v177 + 0.15;
            end;

            local v178 = u24;
            u4.Size = UDim2.new(v178.X.Scale, v178.X.Offset, v178.Y.Scale - v177, v178.Y.Offset);
        end;

        return;
    end;

    local v179 = u36;

    if typeof(v179) ~= "table" or v179.phase == "running" then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v180 = 0;

            if u25 then
                v180 = v180 + 0.24;
            end;

            if u31 then
                v180 = v180 + 0.24;
            end;

            if u17 and u17.Visible then
                v180 = v180 + 0.15;
            end;

            local v181 = u24;
            u4.Size = UDim2.new(v181.X.Scale, v181.X.Offset, v181.Y.Scale - v180, v181.Y.Offset);
        end;

        return;
    end;

    if v179.rewardClaimed == true then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v182 = 0;

            if u25 then
                v182 = v182 + 0.24;
            end;

            if u31 then
                v182 = v182 + 0.24;
            end;

            if u17 and u17.Visible then
                v182 = v182 + 0.15;
            end;

            local v183 = u24;
            u4.Size = UDim2.new(v183.X.Scale, v183.X.Offset, v183.Y.Scale - v182, v183.Y.Offset);
        end;

        return;
    end;

    local lastConfig = v179.lastConfig;

    if typeof(lastConfig) ~= "table" then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v184 = 0;

            if u25 then
                v184 = v184 + 0.24;
            end;

            if u31 then
                v184 = v184 + 0.24;
            end;

            if u17 and u17.Visible then
                v184 = v184 + 0.15;
            end;

            local v185 = u24;
            u4.Size = UDim2.new(v185.X.Scale, v185.X.Offset, v185.Y.Scale - v184, v185.Y.Offset);
        end;

        return;
    end;

    local id = lastConfig.id;

    if typeof(id) ~= "string" or id == "" then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v186 = 0;

            if u25 then
                v186 = v186 + 0.24;
            end;

            if u31 then
                v186 = v186 + 0.24;
            end;

            if u17 and u17.Visible then
                v186 = v186 + 0.15;
            end;

            local v187 = u24;
            u4.Size = UDim2.new(v187.X.Scale, v187.X.Offset, v187.Y.Scale - v186, v187.Y.Offset);
        end;

        return;
    end;

    local endAt = lastConfig.endAt;
    local v188;

    if typeof(endAt) == "string" and endAt ~= "" then
        local success, result = pcall(DateTime.fromIsoDate, endAt);

        if success and result then
            v188 = result.UnixTimestamp;
        else
            v188 = nil;
        end;
    else
        v188 = nil;
    end;

    if not v188 or workspace:GetServerTimeNow() - v188 > 3600 then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v189 = 0;

            if u25 then
                v189 = v189 + 0.24;
            end;

            if u31 then
                v189 = v189 + 0.24;
            end;

            if u17 and u17.Visible then
                v189 = v189 + 0.15;
            end;

            local v190 = u24;
            u4.Size = UDim2.new(v190.X.Scale, v190.X.Offset, v190.Y.Scale - v189, v190.Y.Offset);
        end;

        return;
    end;

    local v191 = LocalPlayer:GetAttribute("GuildId");

    if typeof(v191) ~= "string" or v191 == "" then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v192 = 0;

            if u25 then
                v192 = v192 + 0.24;
            end;

            if u31 then
                v192 = v192 + 0.24;
            end;

            if u17 and u17.Visible then
                v192 = v192 + 0.15;
            end;

            local v193 = u24;
            u4.Size = UDim2.new(v193.X.Scale, v193.X.Offset, v193.Y.Scale - v192, v193.Y.Offset);
        end;

        return;
    end;

    local v194 = guildRankInStandings(v191);

    if not v194 then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v195 = 0;

            if u25 then
                v195 = v195 + 0.24;
            end;

            if u31 then
                v195 = v195 + 0.24;
            end;

            if u17 and u17.Visible then
                v195 = v195 + 0.15;
            end;

            local v196 = u24;
            u4.Size = UDim2.new(v196.X.Scale, v196.X.Offset, v196.Y.Scale - v195, v196.Y.Offset);
        end;

        return;
    end;

    if typeof(lastConfig.rewards) == "table" and not placementInRewards(v194, lastConfig.rewards) then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v197 = 0;

            if u25 then
                v197 = v197 + 0.24;
            end;

            if u31 then
                v197 = v197 + 0.24;
            end;

            if u17 and u17.Visible then
                v197 = v197 + 0.15;
            end;

            local v198 = u24;
            u4.Size = UDim2.new(v198.X.Scale, v198.X.Offset, v198.Y.Scale - v197, v198.Y.Offset);
        end;

        return;
    end;

    if rewardDelivered(id) then
        if u25 == false then
            return;
        end;

        u25 = false;

        if u23 then
            u23.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v199 = 0;

            if u25 then
                v199 = v199 + 0.24;
            end;

            if u31 then
                v199 = v199 + 0.24;
            end;

            if u17 and u17.Visible then
                v199 = v199 + 0.15;
            end;

            local v200 = u24;
            u4.Size = UDim2.new(v200.X.Scale, v200.X.Offset, v200.Y.Scale - v199, v200.Y.Offset);
        end;

        return;
    end;

    if u25 == true then
        return;
    end;

    u25 = true;

    if u23 then
        u23.Visible = true;
    end;

    if u4 then
        if not u24 then
            return;
        end;

        local v201 = 0;

        if u25 then
            v201 = v201 + 0.24;
        end;

        if u31 then
            v201 = v201 + 0.24;
        end;

        if u17 and u17.Visible then
            v201 = v201 + 0.15;
        end;

        local v202 = u24;
        u4.Size = UDim2.new(v202.X.Scale, v202.X.Offset, v202.Y.Scale - v201, v202.Y.Offset);
    end;
end;

local function setBannerHeader(p203) -- Line: 948
    -- upvalues: u29 (ref)
    if not u29 then
        return;
    end;

    u29.Text = p203;
    local TextLabel = u29:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p203;
    end;
end;

local function competitionName(p204) -- Line: 960
    if typeof(p204) == "table" and (typeof(p204.displayName) == "string" and p204.displayName ~= "") then
        return p204.displayName;
    end;

    return nil;
end;

local function updateStatusBanner() -- Line: 971
    -- upvalues: u28 (ref), u13 (ref), u31 (ref), u4 (ref), u24 (ref), u25 (ref), u17 (ref), u16 (ref), u36 (ref), u29 (ref), u30 (ref)
    if not (u28 and u13) then
        if u31 == false then
            return;
        end;

        u31 = false;

        if u28 then
            u28.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v205 = 0;

            if u25 then
                v205 = v205 + 0.24;
            end;

            if u31 then
                v205 = v205 + 0.24;
            end;

            if u17 and u17.Visible then
                v205 = v205 + 0.15;
            end;

            local v206 = u24;
            u4.Size = UDim2.new(v206.X.Scale, v206.X.Offset, v206.Y.Scale - v205, v206.Y.Offset);
        end;

        return;
    end;

    if u16 ~= "global" then
        if u31 == false then
            return;
        end;

        u31 = false;

        if u28 then
            u28.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v207 = 0;

            if u25 then
                v207 = v207 + 0.24;
            end;

            if u31 then
                v207 = v207 + 0.24;
            end;

            if u17 and u17.Visible then
                v207 = v207 + 0.15;
            end;

            local v208 = u24;
            u4.Size = UDim2.new(v208.X.Scale, v208.X.Offset, v208.Y.Scale - v207, v208.Y.Offset);
        end;

        return;
    end;

    if u25 or u17 and u17.Visible then
        if u31 == false then
            return;
        end;

        u31 = false;

        if u28 then
            u28.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v209 = 0;

            if u25 then
                v209 = v209 + 0.24;
            end;

            if u31 then
                v209 = v209 + 0.24;
            end;

            if u17 and u17.Visible then
                v209 = v209 + 0.15;
            end;

            local v210 = u24;
            u4.Size = UDim2.new(v210.X.Scale, v210.X.Offset, v210.Y.Scale - v209, v210.Y.Offset);
        end;

        return;
    end;

    local v211 = u36;

    if typeof(v211) ~= "table" then
        if u31 == false then
            return;
        end;

        u31 = false;

        if u28 then
            u28.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v212 = 0;

            if u25 then
                v212 = v212 + 0.24;
            end;

            if u31 then
                v212 = v212 + 0.24;
            end;

            if u17 and u17.Visible then
                v212 = v212 + 0.15;
            end;

            local v213 = u24;
            u4.Size = UDim2.new(v213.X.Scale, v213.X.Offset, v213.Y.Scale - v212, v213.Y.Offset);
        end;

        return;
    end;

    if v211.phase == "running" then
        local config = v211.config;
        local v214;

        if typeof(config) == "table" and (typeof(config.displayName) == "string" and config.displayName ~= "") then
            v214 = config.displayName;
        else
            v214 = nil;
        end;

        if u29 then
            u29.Text = "Live Standings";
            local TextLabel = u29:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = "Live Standings";
            end;
        end;

        if u30 then
            u30.Text = not v214 and "This competition is live! These standings update as guilds compete." or string.format("%s is live! These standings update as guilds compete.", v214);
        end;

        if u31 == true then
            return;
        end;

        u31 = true;

        if u28 then
            u28.Visible = true;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v215 = 0;

            if u25 then
                v215 = v215 + 0.24;
            end;

            if u31 then
                v215 = v215 + 0.24;
            end;

            if u17 and u17.Visible then
                v215 = v215 + 0.15;
            end;

            local v216 = u24;
            u4.Size = UDim2.new(v216.X.Scale, v216.X.Offset, v216.Y.Scale - v215, v216.Y.Offset);
        end;

        return;
    end;

    local lastConfig = v211.lastConfig;

    if typeof(lastConfig) ~= "table" then
        if u31 == false then
            return;
        end;

        u31 = false;

        if u28 then
            u28.Visible = false;
        end;

        if u4 then
            if not u24 then
                return;
            end;

            local v217 = 0;

            if u25 then
                v217 = v217 + 0.24;
            end;

            if u31 then
                v217 = v217 + 0.24;
            end;

            if u17 and u17.Visible then
                v217 = v217 + 0.15;
            end;

            local v218 = u24;
            u4.Size = UDim2.new(v218.X.Scale, v218.X.Offset, v218.Y.Scale - v217, v218.Y.Offset);
        end;

        return;
    end;

    local v219;

    if typeof(lastConfig) == "table" and (typeof(lastConfig.displayName) == "string" and lastConfig.displayName ~= "") then
        v219 = lastConfig.displayName;
    else
        v219 = nil;
    end;

    if u29 then
        u29.Text = "Final Standings";
        local TextLabel = u29:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = "Final Standings";
        end;
    end;

    if u30 then
        local v220 = not v219 and "Last week\'s competition has ended -- these are the final standings!" or string.format("%s has ended -- these are the final standings!", v219);

        if v211.phase == "pending" then
            v220 = v220 .. " The next competition starts soon.";
        end;

        u30.Text = v220;
    end;

    if u31 == true then
        return;
    end;

    u31 = true;

    if u28 then
        u28.Visible = true;
    end;

    if u4 then
        if not u24 then
            return;
        end;

        local v221 = 0;

        if u25 then
            v221 = v221 + 0.24;
        end;

        if u31 then
            v221 = v221 + 0.24;
        end;

        if u17 and u17.Visible then
            v221 = v221 + 0.15;
        end;

        local v222 = u24;
        u4.Size = UDim2.new(v222.X.Scale, v222.X.Offset, v222.Y.Scale - v221, v222.Y.Offset);
    end;
end;

u155 = updateStatusBanner;

u41 = function() -- Line: 1025, Name: updateBanners
    -- upvalues: updateRewardNotice (copy), updateStatusBanner (copy)
    updateRewardNotice();
    updateStatusBanner();
end;

local function styleTabButtons() -- Line: 1035
    -- upvalues: u18 (ref), u16 (ref), u19 (ref)
    local function style(p223, p224) -- Line: 1036
        if not p223 then
            return;
        end;

        p223.BackgroundTransparency = p224 and 0 or 0.45;

        if p223:IsA("TextButton") then
            p223.TextTransparency = p224 and 0 or 0.35;
        end;
    end;

    local v225 = u18;
    local v226 = u16 == "global";

    if v225 then
        v225.BackgroundTransparency = v226 and 0 or 0.45;

        if v225:IsA("TextButton") then
            v225.TextTransparency = v226 and 0 or 0.35;
        end;
    end;

    local v227 = u19;
    local v228 = u16 == "local";

    if not v227 then
        return;
    end;

    v227.BackgroundTransparency = v228 and 0 or 0.45;

    if v227:IsA("TextButton") then
        v227.TextTransparency = v228 and 0 or 0.35;
    end;
end;

u22 = function(p229) -- Line: 1047
    -- upvalues: u16 (ref), u18 (ref), u19 (ref), clearScrolling (copy), u15 (ref), u9 (ref), renderLocalBoard (copy), u38 (ref), Networking (copy), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref), u20 (ref), u21 (ref), u43 (ref), rebuildBoard (copy), u13 (ref), u32 (copy), updateRewardNotice (copy), updateStatusBanner (copy)
    if p229 == u16 then
        return;
    end;

    u16 = p229;

    local function _(p230, p231) -- Line: 1036
        if not p230 then
            return;
        end;

        p230.BackgroundTransparency = p231 and 0 or 0.45;

        if p230:IsA("TextButton") then
            p230.TextTransparency = p231 and 0 or 0.35;
        end;
    end;

    local v232 = u18;
    local v233 = u16 == "global";

    if v232 then
        v232.BackgroundTransparency = v233 and 0 or 0.45;

        if v232:IsA("TextButton") then
            v232.TextTransparency = v233 and 0 or 0.35;
        end;
    end;

    local v234 = u19;
    local v235 = u16 == "local";

    if v234 then
        v234.BackgroundTransparency = v235 and 0 or 0.45;

        if v234:IsA("TextButton") then
            v234.TextTransparency = v235 and 0 or 0.35;
        end;
    end;

    clearScrolling();

    if p229 == "local" then
        u15 = u15 + 1;

        if u9 then
            u9.Text = "Loading...";
            u9.Visible = true;
        end;

        renderLocalBoard();
        u38 = os.clock();
        task.spawn(function() -- Line: 172
            -- upvalues: Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref)
            local success, result = pcall(function() -- Line: 173
                -- upvalues: Networking (ref)
                return Networking.Guild.GetCompetition:Fire();
            end);

            if not success or typeof(result) ~= "table" then
                return;
            end;

            local v236 = u36;
            local v237;

            if typeof(v236) == "table" then
                local v238;

                if typeof(v236.config) == "table" then
                    v238 = v236.config;
                else
                    v238 = v236.lastConfig;
                end;

                if typeof(v238) == "table" and typeof(v238.scoreFormat) == "string" then
                    v237 = v238.scoreFormat;
                else
                    v237 = nil;
                end;
            else
                v237 = nil;
            end;

            u36 = result;

            if result.phase == "running" and typeof(result.endsAt) == "number" then
                u37 = result.endsAt;
            elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
                u37 = result.startsAt;
            else
                u37 = nil;
            end;

            local v239 = u36;
            local v240;

            if typeof(v239) == "table" then
                local v241;

                if typeof(v239.config) == "table" then
                    v241 = v239.config;
                else
                    v241 = v239.lastConfig;
                end;

                if typeof(v241) == "table" and typeof(v241.scoreFormat) == "string" then
                    v240 = v241.scoreFormat;
                else
                    v240 = nil;
                end;
            else
                v240 = nil;
            end;

            local v242 = v240 ~= v237 and u40;

            if v242 then
                v242();
            end;

            local v243 = u41;

            if v243 then
                v243();
            end;

            local v244 = u42;

            if v244 then
                v244();
            end;
        end);
    else
        if u20 then
            local v245 = u16 == "local" and "Local Bracket" or (u21 or "Top Guilds");
            u20.Text = v245;
            local TextLabel = u20:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = v245;
            end;
        end;

        local v246 = u43;

        if (not v246 or rebuildBoard(v246) <= 0) and u9 then
            u9.Text = "Loading...";
            u9.Visible = true;
        end;

        u15 = u15 + 1;
        local u247 = u15;
        task.spawn(function() -- Line: 810
            -- upvalues: u13 (ref), u247 (copy), u15 (ref), Networking (ref), u43 (ref), rebuildBoard (ref), u32 (ref), u9 (ref)
            for _ = 1, 12 do
                if not u13 or u247 ~= u15 then
                    return;
                end;

                local success, result = pcall(function() -- Line: 815
                    -- upvalues: Networking (ref)
                    return Networking.Guild.GetLeaderboard:Fire("weekly");
                end);

                if not u13 or u247 ~= u15 then
                    return;
                end;

                local v248 = (not success or typeof(result) ~= "table") and {} or result;

                if #v248 > 0 then
                    u43 = v248;

                    if rebuildBoard(v248) > 0 then
                        return;
                    end;
                elseif #u32 > 0 then
                    return;
                end;

                if u9 then
                    u9.Text = "Loading...";
                    u9.Visible = true;
                end;

                task.wait(2);
            end;

            if u13 and u247 == u15 then
                if not u9 then
                    return;
                end;

                u9.Text = "No guilds have scored yet";
                u9.Visible = true;
            end;
        end);
    end;

    updateRewardNotice();
    updateStatusBanner();
end;

local function refreshTimer() -- Line: 1072
    -- upvalues: u8 (ref), u38 (ref), Networking (copy), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref), ServerClock (copy), u7 (ref), u11 (ref), u12 (ref), formatTimeRemaining (copy), updateRewardNotice (copy), updateStatusBanner (copy)
    if not u8 then
        return;
    end;

    local v249 = os.clock();

    if v249 - u38 >= 15 then
        u38 = v249;
        task.spawn(function() -- Line: 172
            -- upvalues: Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref)
            local success, result = pcall(function() -- Line: 173
                -- upvalues: Networking (ref)
                return Networking.Guild.GetCompetition:Fire();
            end);

            if not success or typeof(result) ~= "table" then
                return;
            end;

            local v250 = u36;
            local v251;

            if typeof(v250) == "table" then
                local v252;

                if typeof(v250.config) == "table" then
                    v252 = v250.config;
                else
                    v252 = v250.lastConfig;
                end;

                if typeof(v252) == "table" and typeof(v252.scoreFormat) == "string" then
                    v251 = v252.scoreFormat;
                else
                    v251 = nil;
                end;
            else
                v251 = nil;
            end;

            u36 = result;

            if result.phase == "running" and typeof(result.endsAt) == "number" then
                u37 = result.endsAt;
            elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
                u37 = result.startsAt;
            else
                u37 = nil;
            end;

            local v253 = u36;
            local v254;

            if typeof(v253) == "table" then
                local v255;

                if typeof(v253.config) == "table" then
                    v255 = v253.config;
                else
                    v255 = v253.lastConfig;
                end;

                if typeof(v255) == "table" and typeof(v255.scoreFormat) == "string" then
                    v254 = v255.scoreFormat;
                else
                    v254 = nil;
                end;
            else
                v254 = nil;
            end;

            local v256 = v254 ~= v251 and u40;

            if v256 then
                v256();
            end;

            local v257 = u41;

            if v257 then
                v257();
            end;

            local v258 = u42;

            if v258 then
                v258();
            end;
        end);
    end;

    local v259 = ServerClock.Now();
    local v260;

    if u37 and v259 < u37 then
        v260 = u37;
    else
        v260 = nil;
    end;

    if u7 then
        u7.Visible = v260 ~= nil;
    end;

    if u11 and u12 then
        local v261 = u12;

        if v260 == nil then
            v261 = UDim2.new(0.86, v261.X.Offset, v261.Y.Scale, v261.Y.Offset);
        end;

        u11.Position = v261;
    end;

    u8.Text = not v260 and "" or formatTimeRemaining(v260 - v259);
    updateRewardNotice();
    updateStatusBanner();
end;

local function startTimerLoop() -- Line: 1099
    -- upvalues: u14 (ref), u13 (ref), refreshTimer (copy)
    if u14 then
        return;
    end;

    u14 = task.spawn(function() -- Line: 1101
        -- upvalues: u13 (ref), refreshTimer (ref)
        while u13 do
            refreshTimer();
            task.wait(1);
        end;
    end);
end;

local function stopTimerLoop() -- Line: 1109
    -- upvalues: u14 (ref)
    if u14 then
        task.cancel(u14);
        u14 = nil;
    end;
end;

local function resolveRefs(p262) -- Line: 1118
    -- upvalues: u17 (ref), u18 (ref), u19 (ref), u20 (ref), u21 (ref), u6 (ref), u7 (ref), u8 (ref), u11 (ref), u12 (ref), u10 (ref), u9 (ref), u4 (ref), u24 (ref), u23 (ref), u28 (ref), u29 (ref), u30 (ref), u5 (ref)
    local ContributionLeaderboard = p262:FindFirstChild("ContributionLeaderboard");

    if not ContributionLeaderboard then
        return;
    end;

    local TabBar = ContributionLeaderboard:FindFirstChild("TabBar");

    if TabBar and TabBar:IsA("GuiObject") then
        u17 = TabBar;
        TabBar.Visible = false;
        local GlobalTab = TabBar:FindFirstChild("GlobalTab");

        if GlobalTab and GlobalTab:IsA("GuiButton") then
            u18 = GlobalTab;
        end;

        local LocalTab = TabBar:FindFirstChild("LocalTab");

        if LocalTab and LocalTab:IsA("GuiButton") then
            u19 = LocalTab;
        end;
    end;

    local Header = ContributionLeaderboard:FindFirstChild("Header");

    if Header then
        local TextLabel = Header:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            u20 = TextLabel;
            u21 = TextLabel.Text;
        end;

        local ExitButton = Header:FindFirstChild("ExitButton");

        if ExitButton and ExitButton:IsA("GuiButton") then
            u6 = ExitButton;
        end;

        local RefreshIn = Header:FindFirstChild("RefreshIn");

        if RefreshIn then
            if RefreshIn:IsA("GuiObject") then
                u7 = RefreshIn;
            end;

            local Timer = RefreshIn:FindFirstChild("Timer");

            if Timer and Timer:IsA("TextLabel") then
                u8 = Timer;
            end;
        end;

        local ExtraFrame = Header:FindFirstChild("ExtraFrame");

        if ExtraFrame and ExtraFrame:IsA("GuiObject") then
            u11 = ExtraFrame;
            u12 = ExtraFrame.Position;
            local ViewPlacementButton = ExtraFrame:FindFirstChild("ViewPlacementButton");

            if ViewPlacementButton and ViewPlacementButton:IsA("GuiButton") then
                u10 = ViewPlacementButton;
            end;
        end;
    end;

    local Content = ContributionLeaderboard:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local StatusLabel = Content:FindFirstChild("StatusLabel");

    if StatusLabel and StatusLabel:IsA("TextLabel") then
        u9 = StatusLabel;
    end;

    local ScrollingFrame = Content:FindFirstChild("ScrollingFrame");

    if not ScrollingFrame then
        return;
    end;

    if not ScrollingFrame:IsA("ScrollingFrame") then
        return;
    end;

    u4 = ScrollingFrame;
    u24 = ScrollingFrame.Size;
    local RewardNotice = Content:FindFirstChild("RewardNotice");

    if RewardNotice and RewardNotice:IsA("GuiObject") then
        u23 = RewardNotice;
        RewardNotice.Visible = false;
    end;

    local StatusBanner = Content:FindFirstChild("StatusBanner");

    if StatusBanner and StatusBanner:IsA("GuiObject") then
        u28 = StatusBanner;
        StatusBanner.Visible = false;
        local Header2 = StatusBanner:FindFirstChild("Header");

        if Header2 and Header2:IsA("TextLabel") then
            u29 = Header2;
        end;

        local Description = StatusBanner:FindFirstChild("Description");

        if Description and Description:IsA("TextLabel") then
            u30 = Description;
        end;
    end;

    local PlayerCard_Template_Rank1 = ScrollingFrame:FindFirstChild("PlayerCard_Template_Rank1");

    if not PlayerCard_Template_Rank1 then
        return;
    end;

    if not PlayerCard_Template_Rank1:IsA("ImageButton") then
        return;
    end;

    u5 = PlayerCard_Template_Rank1;
    PlayerCard_Template_Rank1.Visible = false;
end;

local function bindButtons() -- Line: 1211
    -- upvalues: u6 (ref), GuiController (copy), u10 (ref), ViewGuildProgressController (copy), u18 (ref), u22 (ref), u19 (ref), u16 (ref)
    if u6 then
        u6.MouseButton1Click:Connect(function() -- Line: 1213
            -- upvalues: GuiController (ref)
            if GuiController:IsOpen("ViewGuildLeaderboard") then
                GuiController:Close();
            end;
        end);
    end;

    if u10 then
        u10.MouseButton1Click:Connect(function() -- Line: 1220
            -- upvalues: ViewGuildProgressController (ref), GuiController (ref)
            ViewGuildProgressController:SetReturnGui("ViewGuildLeaderboard");
            GuiController:Open("ViewGuildProgress", nil, { "HUD" });
        end);
    end;

    if u18 then
        u18.MouseButton1Click:Connect(function() -- Line: 1228
            -- upvalues: u22 (ref)
            local v263 = u22;

            if v263 then
                v263("global");
            end;
        end);
    end;

    if u19 then
        u19.MouseButton1Click:Connect(function() -- Line: 1234
            -- upvalues: u22 (ref)
            local v264 = u22;

            if v264 then
                v264("local");
            end;
        end);
    end;

    local function _(p265, p266) -- Line: 1036
        if not p265 then
            return;
        end;

        p265.BackgroundTransparency = p266 and 0 or 0.45;

        if p265:IsA("TextButton") then
            p265.TextTransparency = p266 and 0 or 0.35;
        end;
    end;

    local v267 = u18;
    local v268 = u16 == "global";

    if v267 then
        v267.BackgroundTransparency = v268 and 0 or 0.45;

        if v267:IsA("TextButton") then
            v267.TextTransparency = v268 and 0 or 0.35;
        end;
    end;

    local v269 = u19;
    local v270 = u16 == "local";

    if not v269 then
        return;
    end;

    v269.BackgroundTransparency = v270 and 0 or 0.45;

    if v269:IsA("TextButton") then
        v269.TextTransparency = v270 and 0 or 0.35;
    end;
end;

function v2.Init(p271) -- Line: 1244
end;

function v2.Start(p272) -- Line: 1246
    -- upvalues: u38 (ref), Networking (copy), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref), u43 (ref), PlayerGui (copy), u3 (ref), resolveRefs (copy), bindButtons (copy), u13 (ref), u16 (ref), rebuildBoard (copy), u15 (ref), u26 (ref), markSeenGuildRewards (copy), updateRewardNotice (copy), updateStatusBanner (copy), GuiController (copy), refreshTimer (copy), u14 (ref), u17 (ref), localSnapshotState (copy), u154 (ref), u155 (ref), u22 (ref), renderLocalBoard (copy), clearScrolling (copy), u9 (ref), u32 (copy)
    task.spawn(function() -- Line: 1247
        -- upvalues: u38 (ref), Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref), u43 (ref), PlayerGui (ref), u3 (ref), resolveRefs (ref), bindButtons (ref), u13 (ref), u16 (ref), rebuildBoard (ref), u15 (ref), u26 (ref), markSeenGuildRewards (ref), updateRewardNotice (ref), updateStatusBanner (ref), GuiController (ref), refreshTimer (ref), u14 (ref), u17 (ref), localSnapshotState (ref), u154 (ref), u155 (ref), u22 (ref), renderLocalBoard (ref), clearScrolling (ref), u9 (ref), u32 (ref)
        local v273 = os.clock();

        if v273 - u38 >= 15 then
            u38 = v273;
            task.spawn(function() -- Line: 172
                -- upvalues: Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref)
                local success, result = pcall(function() -- Line: 173
                    -- upvalues: Networking (ref)
                    return Networking.Guild.GetCompetition:Fire();
                end);

                if not success or typeof(result) ~= "table" then
                    return;
                end;

                local v274 = u36;
                local v275;

                if typeof(v274) == "table" then
                    local v276;

                    if typeof(v274.config) == "table" then
                        v276 = v274.config;
                    else
                        v276 = v274.lastConfig;
                    end;

                    if typeof(v276) == "table" and typeof(v276.scoreFormat) == "string" then
                        v275 = v276.scoreFormat;
                    else
                        v275 = nil;
                    end;
                else
                    v275 = nil;
                end;

                u36 = result;

                if result.phase == "running" and typeof(result.endsAt) == "number" then
                    u37 = result.endsAt;
                elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
                    u37 = result.startsAt;
                else
                    u37 = nil;
                end;

                local v277 = u36;
                local v278;

                if typeof(v277) == "table" then
                    local v279;

                    if typeof(v277.config) == "table" then
                        v279 = v277.config;
                    else
                        v279 = v277.lastConfig;
                    end;

                    if typeof(v279) == "table" and typeof(v279.scoreFormat) == "string" then
                        v278 = v279.scoreFormat;
                    else
                        v278 = nil;
                    end;
                else
                    v278 = nil;
                end;

                local v280 = v278 ~= v275 and u40;

                if v280 then
                    v280();
                end;

                local v281 = u41;

                if v281 then
                    v281();
                end;

                local v282 = u42;

                if v282 then
                    v282();
                end;
            end);
        end;

        task.spawn(function() -- Line: 1254
            -- upvalues: Networking (ref), u43 (ref)
            local success, result = pcall(function() -- Line: 1255
                -- upvalues: Networking (ref)
                return Networking.Guild.GetLeaderboard:Fire("weekly");
            end);

            if success and (typeof(result) == "table" and (#result > 0 and not u43)) then
                u43 = result;
            end;
        end);
        local ViewGuildLeaderboard = PlayerGui:WaitForChild("ViewGuildLeaderboard", 30);

        if not (ViewGuildLeaderboard and ViewGuildLeaderboard:IsA("ScreenGui")) then
            return;
        end;

        u3 = ViewGuildLeaderboard;
        ViewGuildLeaderboard.Enabled = false;
        resolveRefs(ViewGuildLeaderboard);
        bindButtons();
        Networking.Guild.TickUpdate.OnClientEvent:Connect(function(p283) -- Line: 1275
            -- upvalues: u43 (ref), u13 (ref), u16 (ref), rebuildBoard (ref), u15 (ref)
            if typeof(p283) ~= "table" then
                return;
            end;

            if p283.Kind ~= "Leaderboard" then
                return;
            end;

            local TopGuilds = p283.TopGuilds;

            if typeof(TopGuilds) == "table" and #TopGuilds > 0 then
                u43 = TopGuilds;
            end;

            if not u13 or u16 ~= "global" then
                return;
            end;

            if typeof(TopGuilds) == "table" and rebuildBoard(TopGuilds) > 0 then
                u15 = u15 + 1;
            end;
        end);
        Networking.Mailbox.Updated.OnClientEvent:Connect(function(p284) -- Line: 1303
            -- upvalues: u26 (ref), markSeenGuildRewards (ref), u38 (ref), Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref), updateRewardNotice (ref), updateStatusBanner (ref)
            if typeof(p284) == "table" then
                if typeof(p284.Mailbox) == "table" then
                    p284 = p284.Mailbox;
                end;
            else
                p284 = nil;
            end;

            u26 = p284;
            markSeenGuildRewards();
            u38 = os.clock();
            task.spawn(function() -- Line: 172
                -- upvalues: Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref)
                local success, result = pcall(function() -- Line: 173
                    -- upvalues: Networking (ref)
                    return Networking.Guild.GetCompetition:Fire();
                end);

                if not success or typeof(result) ~= "table" then
                    return;
                end;

                local v285 = u36;
                local v286;

                if typeof(v285) == "table" then
                    local v287;

                    if typeof(v285.config) == "table" then
                        v287 = v285.config;
                    else
                        v287 = v285.lastConfig;
                    end;

                    if typeof(v287) == "table" and typeof(v287.scoreFormat) == "string" then
                        v286 = v287.scoreFormat;
                    else
                        v286 = nil;
                    end;
                else
                    v286 = nil;
                end;

                u36 = result;

                if result.phase == "running" and typeof(result.endsAt) == "number" then
                    u37 = result.endsAt;
                elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
                    u37 = result.startsAt;
                else
                    u37 = nil;
                end;

                local v288 = u36;
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

                local v291 = v289 ~= v286 and u40;

                if v291 then
                    v291();
                end;

                local v292 = u41;

                if v292 then
                    v292();
                end;

                local v293 = u42;

                if v293 then
                    v293();
                end;
            end);
            updateRewardNotice();
            updateStatusBanner();
        end);
        task.spawn(function() -- Line: 1312
            -- upvalues: Networking (ref), u26 (ref), markSeenGuildRewards (ref), updateRewardNotice (ref), updateStatusBanner (ref)
            local success, result = pcall(function() -- Line: 1313
                -- upvalues: Networking (ref)
                return Networking.Mailbox.OpenInbox:Fire();
            end);

            if success then
                if typeof(result) == "table" then
                    if typeof(result.Mailbox) == "table" then
                        result = result.Mailbox;
                    end;
                else
                    result = nil;
                end;

                u26 = result;
                markSeenGuildRewards();
                updateRewardNotice();
                updateStatusBanner();
            end;
        end);
        GuiController.GuiFocusedSignal:Connect(function(p294) -- Line: 1323
            -- upvalues: ViewGuildLeaderboard (copy), u13 (ref), u38 (ref), Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref), u26 (ref), markSeenGuildRewards (ref), updateRewardNotice (ref), updateStatusBanner (ref), refreshTimer (ref), u14 (ref), u17 (ref), localSnapshotState (ref), u154 (ref), u155 (ref), u16 (ref), u22 (ref), renderLocalBoard (ref), u43 (ref), rebuildBoard (ref), clearScrolling (ref), u9 (ref), u15 (ref), u32 (ref)
            if p294 == ViewGuildLeaderboard then
                u13 = true;
                u38 = os.clock();
                task.spawn(function() -- Line: 172
                    -- upvalues: Networking (ref), u36 (ref), u37 (ref), u40 (ref), u41 (ref), u42 (ref)
                    local success, result = pcall(function() -- Line: 173
                        -- upvalues: Networking (ref)
                        return Networking.Guild.GetCompetition:Fire();
                    end);

                    if not success or typeof(result) ~= "table" then
                        return;
                    end;

                    local v295 = u36;
                    local v296;

                    if typeof(v295) == "table" then
                        local v297;

                        if typeof(v295.config) == "table" then
                            v297 = v295.config;
                        else
                            v297 = v295.lastConfig;
                        end;

                        if typeof(v297) == "table" and typeof(v297.scoreFormat) == "string" then
                            v296 = v297.scoreFormat;
                        else
                            v296 = nil;
                        end;
                    else
                        v296 = nil;
                    end;

                    u36 = result;

                    if result.phase == "running" and typeof(result.endsAt) == "number" then
                        u37 = result.endsAt;
                    elseif result.phase == "pending" and typeof(result.startsAt) == "number" then
                        u37 = result.startsAt;
                    else
                        u37 = nil;
                    end;

                    local v298 = u36;
                    local v299;

                    if typeof(v298) == "table" then
                        local v300;

                        if typeof(v298.config) == "table" then
                            v300 = v298.config;
                        else
                            v300 = v298.lastConfig;
                        end;

                        if typeof(v300) == "table" and typeof(v300.scoreFormat) == "string" then
                            v299 = v300.scoreFormat;
                        else
                            v299 = nil;
                        end;
                    else
                        v299 = nil;
                    end;

                    local v301 = v299 ~= v296 and u40;

                    if v301 then
                        v301();
                    end;

                    local v302 = u41;

                    if v302 then
                        v302();
                    end;

                    local v303 = u42;

                    if v303 then
                        v303();
                    end;
                end);
                task.spawn(function() -- Line: 1331
                    -- upvalues: Networking (ref), u26 (ref), markSeenGuildRewards (ref), updateRewardNotice (ref), updateStatusBanner (ref)
                    local success, result = pcall(function() -- Line: 1332
                        -- upvalues: Networking (ref)
                        return Networking.Mailbox.OpenInbox:Fire();
                    end);

                    if success then
                        if typeof(result) == "table" then
                            if typeof(result.Mailbox) == "table" then
                                result = result.Mailbox;
                            end;
                        else
                            result = nil;
                        end;

                        u26 = result;
                        markSeenGuildRewards();
                        updateRewardNotice();
                        updateStatusBanner();
                    end;
                end);
                refreshTimer();

                if not u14 then
                    u14 = task.spawn(function() -- Line: 1101
                        -- upvalues: u13 (ref), refreshTimer (ref)
                        while u13 do
                            refreshTimer();
                            task.wait(1);
                        end;
                    end);
                end;

                if u17 then
                    local v304 = localSnapshotState() ~= "off";

                    if u17.Visible ~= v304 then
                        u17.Visible = v304;
                        local v305 = u154;

                        if v305 then
                            v305();
                        end;

                        local v306 = u155;

                        if v306 then
                            v306();
                        end;
                    end;

                    local v307 = not v304 and (u16 == "local" and u22);

                    if v307 then
                        v307("global");
                    end;
                end;

                if u16 == "local" then
                    renderLocalBoard();

                    return;
                end;

                local v308 = u43;

                if not v308 or rebuildBoard(v308) <= 0 then
                    clearScrolling();

                    if u9 then
                        u9.Text = "Loading...";
                        u9.Visible = true;
                    end;
                end;

                u15 = u15 + 1;
                local u309 = u15;
                task.spawn(function() -- Line: 810
                    -- upvalues: u13 (ref), u309 (copy), u15 (ref), Networking (ref), u43 (ref), rebuildBoard (ref), u32 (ref), u9 (ref)
                    for _ = 1, 12 do
                        if not u13 or u309 ~= u15 then
                            return;
                        end;

                        local success, result = pcall(function() -- Line: 815
                            -- upvalues: Networking (ref)
                            return Networking.Guild.GetLeaderboard:Fire("weekly");
                        end);

                        if not u13 or u309 ~= u15 then
                            return;
                        end;

                        local v310 = (not success or typeof(result) ~= "table") and {} or result;

                        if #v310 > 0 then
                            u43 = v310;

                            if rebuildBoard(v310) > 0 then
                                return;
                            end;
                        elseif #u32 > 0 then
                            return;
                        end;

                        if u9 then
                            u9.Text = "Loading...";
                            u9.Visible = true;
                        end;

                        task.wait(2);
                    end;

                    if u13 and u309 == u15 then
                        if not u9 then
                            return;
                        end;

                        u9.Text = "No guilds have scored yet";
                        u9.Visible = true;
                    end;
                end);
            end;
        end);
        GuiController.GuiUnfocusedSignal:Connect(function(p311) -- Line: 1363
            -- upvalues: ViewGuildLeaderboard (copy), u13 (ref), u14 (ref), updateRewardNotice (ref), updateStatusBanner (ref)
            if p311 == ViewGuildLeaderboard then
                u13 = false;

                if u14 then
                    task.cancel(u14);
                    u14 = nil;
                end;

                updateRewardNotice();
                updateStatusBanner();
            end;
        end);
    end);
end;

return v2;