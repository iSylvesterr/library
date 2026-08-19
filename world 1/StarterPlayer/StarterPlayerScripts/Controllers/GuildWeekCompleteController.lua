-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local v1 = {
    StartOrder = 10
};
local u2 = nil;
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = false;

local function setLabelChain(p7, p8) -- Line: 26
    if not p7 then
        return;
    end;

    p7.RichText = true;
    p7.Text = p8;
    local TextLabel = p7:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.RichText = true;
        TextLabel.Text = p8;
    end;
end;

local function commaSeparate(p9) -- Line: 37
    local v10 = math.floor(p9);

    return tostring(v10):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
end;

local function hidePopup() -- Line: 43
    -- upvalues: u2 (ref)
    if u2 then
        u2.Enabled = false;
    end;
end;

local function findMostRecentGuildRewards(p11) -- Line: 51
    local v12 = (-1 / 0);
    local v13 = (-1 / 0);
    local v14 = nil;
    local v15 = nil;

    for _, v in p11 do
        if typeof(v) == "table" and v.Kind == "GuildReward" then
            local v16 = tonumber(v.SentAt) or 0;

            if v.Local == true then
                if v13 < v16 then
                    v15 = v;
                    v13 = v16;
                end;
            elseif v12 < v16 then
                v14 = v;
                v12 = v16;
            end;
        end;
    end;

    return v14, v15;
end;

local function showPopupIfNeeded(p17) -- Line: 73
    -- upvalues: u6 (ref), u2 (ref), u3 (ref), findMostRecentGuildRewards (copy)
    if u6 then
        return;
    end;

    if typeof(p17) ~= "table" then
        return;
    end;

    if not (u2 and u3) then
        return;
    end;

    local v18, v19 = findMostRecentGuildRewards(p17);

    if not (v18 or v19) then
        return;
    end;

    if v19 and (v18 and v19.CompetitionId ~= v18.CompetitionId) then
        v19 = nil;
    end;

    local v20;

    if v18 then
        v20 = tonumber(v18.Placement);
    else
        v20 = nil;
    end;

    local v21;

    if v19 then
        v21 = tonumber(v19.Placement);
    else
        v21 = nil;
    end;

    local v22;

    if v20 and (v20 > 0 and (v21 and v21 > 0)) then
        local format = string.format;
        local v23 = math.floor(v20);
        local v24 = tostring(v23):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "");
        local v25 = math.floor(v21);
        v22 = format("Your guild placed #%s globally and #%s in its local bracket!", v24, (tostring(v25):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")));
    elseif v21 and (v21 > 0 and not v18) then
        local format = string.format;
        local v26 = math.floor(v21);
        v22 = format("Your guild placed #%s in its local bracket!", (tostring(v26):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")));
    elseif v20 and v20 > 0 then
        local format = string.format;
        local v27 = math.floor(v20);
        v22 = format("Your guild placed #%s", (tostring(v27):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")));
    else
        v22 = "Your guild placed in the contest!";
    end;

    local v28 = u3;

    if v28 then
        v28.RichText = true;
        v28.Text = v22;
        local TextLabel = v28:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.RichText = true;
            TextLabel.Text = v22;
        end;
    end;

    u2.Enabled = true;
    u6 = true;
end;

local function extractMailbox(p29) -- Line: 104
    if typeof(p29) ~= "table" then
        return nil;
    end;

    if typeof(p29.Mailbox) == "table" then
        return p29.Mailbox;
    end;

    return p29;
end;

local function resolveRefs(p30) -- Line: 111
    -- upvalues: u3 (ref), u4 (ref), u5 (ref)
    local GuildWeekComplete = p30:FindFirstChild("GuildWeekComplete");

    if not GuildWeekComplete then
        return;
    end;

    local Content = GuildWeekComplete:FindFirstChild("Content");
    local v31 = Content and Content:FindFirstChild("Info");

    if v31 then
        local Placement = v31:FindFirstChild("Placement");

        if Placement and Placement:IsA("TextLabel") then
            u3 = Placement;
        end;
    end;

    local Header = GuildWeekComplete:FindFirstChild("Header");

    if Header then
        local ExitButton = Header:FindFirstChild("ExitButton");

        if ExitButton and ExitButton:IsA("GuiButton") then
            u4 = ExitButton;
        end;
    end;

    local ContinueButton = GuildWeekComplete:FindFirstChild("ContinueButton");

    if ContinueButton and ContinueButton:IsA("GuiButton") then
        u5 = ContinueButton;
    end;
end;

local function bindButtons() -- Line: 134
    -- upvalues: u4 (ref), hidePopup (copy), u5 (ref)
    if u4 then
        u4.MouseButton1Click:Connect(hidePopup);
    end;

    if u5 then
        u5.MouseButton1Click:Connect(hidePopup);
    end;
end;

function v1.Init(p32) -- Line: 140
end;

function v1.Start(p33) -- Line: 142
    -- upvalues: PlayerGui (copy), u2 (ref), resolveRefs (copy), u4 (ref), hidePopup (copy), u5 (ref), Networking (copy), showPopupIfNeeded (copy)
    task.spawn(function() -- Line: 143
        -- upvalues: PlayerGui (ref), u2 (ref), resolveRefs (ref), u4 (ref), hidePopup (ref), u5 (ref), Networking (ref), showPopupIfNeeded (ref)
        local GuildWeekComplete = PlayerGui:WaitForChild("GuildWeekComplete", 30);

        if not (GuildWeekComplete and GuildWeekComplete:IsA("ScreenGui")) then
            return;
        end;

        u2 = GuildWeekComplete;
        GuildWeekComplete.Enabled = false;
        resolveRefs(GuildWeekComplete);

        if u4 then
            u4.MouseButton1Click:Connect(hidePopup);
        end;

        if u5 then
            u5.MouseButton1Click:Connect(hidePopup);
        end;

        Networking.Mailbox.Updated.OnClientEvent:Connect(function(p34) -- Line: 151
            -- upvalues: showPopupIfNeeded (ref)
            if typeof(p34) == "table" then
                if typeof(p34.Mailbox) == "table" then
                    p34 = p34.Mailbox;
                end;
            else
                p34 = nil;
            end;

            showPopupIfNeeded(p34);
        end);
        task.spawn(function() -- Line: 155
            -- upvalues: Networking (ref), showPopupIfNeeded (ref)
            local success, result = pcall(function() -- Line: 156
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

                showPopupIfNeeded(result);
            end;
        end);
    end);
end;

return v1;