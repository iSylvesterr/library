-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local MessagePrompt = require(ReplicatedStorage.ClientModules.MessagePrompt);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local u1 = {
    not_owner = "Only the guild owner can transfer ownership",
    not_in_guild = "You\'re not in a guild",
    not_a_member = "They\'re no longer in your guild",
    bad_target = "Pick a valid member",
    cannot_transfer_self = "You can\'t transfer to yourself",
    guild_not_found = "Guild not found -- try again",
    transfer_failed = "Could not transfer ownership -- try again"
};
local v2 = {
    StartOrder = 9
};
local u3 = nil;
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = false;
local u9 = {};
local u10 = {};
local u11 = {};

local function trackRowConn(p12) -- Line: 48
    -- upvalues: u9 (copy)
    table.insert(u9, p12);
end;

local function clearRows() -- Line: 52
    -- upvalues: u9 (copy), u10 (copy)
    for _, v in u9 do
        pcall(function() -- Line: 54
            -- upvalues: v (copy)
            v:Disconnect();
        end);
    end;

    table.clear(u9);

    for _, v in u10 do
        if v.Parent then
            v:Destroy();
        end;
    end;

    table.clear(u10);
end;

local function setNameChain(p13, p14) -- Line: 65
    p13.Text = p14;
    local GuildTextLabelName2 = p13:FindFirstChild("GuildTextLabelName2");

    if GuildTextLabelName2 and GuildTextLabelName2:IsA("TextLabel") then
        GuildTextLabelName2.Text = p14;
    end;
end;

local function applyHeadshot(u15, u16) -- Line: 73
    -- upvalues: Players (copy)
    task.spawn(function() -- Line: 74
        -- upvalues: Players (ref), u16 (copy), u15 (copy)
        local success, result = pcall(function() -- Line: 75
            -- upvalues: Players (ref), u16 (ref)
            return Players:GetUserThumbnailAsync(u16, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
        end);

        if success and (typeof(result) == "string" and u15.Parent) then
            u15.Image = result;
        end;
    end);
end;

local function fetchName(u17, u18) -- Line: 92
    -- upvalues: u11 (copy), Players (copy)
    local v19 = u11[u17];

    if v19 then
        u18(v19);

        return;
    end;

    local v20 = Players:GetPlayerByUserId(u17);

    if v20 then
        u11[u17] = v20.Name;
        u18(v20.Name);

        return;
    end;

    u18("...");
    task.spawn(function() -- Line: 105
        -- upvalues: Players (ref), u17 (copy), u11 (ref), u18 (copy)
        local success, result = pcall(function() -- Line: 106
            -- upvalues: Players (ref), u17 (ref)
            return Players:GetNameFromUserIdAsync(u17);
        end);

        if success and (typeof(result) == "string" and result ~= "") then
            u11[u17] = result;
            u18(result);
        end;
    end);
end;

local function returnToGuildPage() -- Line: 119
    -- upvalues: GuiController (copy)
    if not GuiController:IsOpen("GuildTransfer") then
        return;
    end;

    GuiController:Open("ViewGuildPage", nil, { "HUD" });

    if GuiController:IsOpen("GuildTransfer") then
        GuiController:Close();
    end;
end;

local function makeOwner(u21, u22) -- Line: 127
    -- upvalues: u11 (copy), MessagePrompt (copy), Networking (copy), NotificationController (copy), returnToGuildPage (copy), u1 (copy)
    local u23 = u11[u21] or "this member";
    task.spawn(function() -- Line: 129
        -- upvalues: MessagePrompt (ref), u23 (copy), u22 (copy), Networking (ref), u21 (copy), NotificationController (ref), returnToGuildPage (ref), u1 (ref)
        if not MessagePrompt.Prompt({
            titleOverride = "Transfer Ownership?",
            yield = true,
            dontRestoreOnSuccess = true,
            message = string.format("Hand <b>%s</b> the crown?\nYou\'ll drop to a regular Member and this <b>can\'t be undone</b>.", u23),
            options = MessagePrompt.Choices.YesNo
        }) then
            return;
        end;

        u22.Active = false;
        local v24, v25, v26 = pcall(function() -- Line: 150
            -- upvalues: Networking (ref), u21 (ref)
            return Networking.Guild.TransferOwnership:Fire(u21);
        end);

        if not v24 then
            NotificationController:CreateNotification("Try again");
            u22.Active = true;

            return;
        end;

        if v25 then
            NotificationController:CreateNotification(string.format("Transferred guild ownership to %s", u23));
            returnToGuildPage();

            return;
        end;

        local v27 = tostring(v26 or "");
        NotificationController:CreateNotification(u1[v27] or ((v27 == "" or not v27) and "Could not transfer ownership" or v27));
        u22.Active = true;
    end);
end;

local function renderRow(p28, p29, u30) -- Line: 173
    -- upvalues: u10 (copy), fetchName (copy), Players (copy), u11 (copy), MessagePrompt (copy), Networking (copy), NotificationController (copy), returnToGuildPage (copy), u1 (copy), u9 (copy)
    local v31 = p28:Clone();
    v31.Name = `Member_{u30}`;
    v31.LayoutOrder = #u10 + 1;
    v31.Visible = true;
    v31.Parent = p29;
    table.insert(u10, v31);
    local PlayerName = v31:FindFirstChild("PlayerName");

    if PlayerName and PlayerName:IsA("TextLabel") then
        fetchName(u30, function(p32) -- Line: 183
            -- upvalues: PlayerName (copy)
            if PlayerName.Parent then
                local v33 = PlayerName;
                v33.Text = p32;
                local GuildTextLabelName2 = v33:FindFirstChild("GuildTextLabelName2");

                if GuildTextLabelName2 and GuildTextLabelName2:IsA("TextLabel") then
                    GuildTextLabelName2.Text = p32;
                end;
            end;
        end);
    end;

    local PlayerImage = v31:FindFirstChild("PlayerImage");

    if PlayerImage then
        PlayerImage = PlayerImage:FindFirstChild("Icon");
    end;

    if PlayerImage and PlayerImage:IsA("ImageLabel") then
        task.spawn(function() -- Line: 74
            -- upvalues: Players (ref), u30 (copy), PlayerImage (copy)
            local success, result = pcall(function() -- Line: 75
                -- upvalues: Players (ref), u30 (ref)
                return Players:GetUserThumbnailAsync(u30, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420);
            end);

            if success and (typeof(result) == "string" and PlayerImage.Parent) then
                PlayerImage.Image = result;
            end;
        end);
    end;

    local InviteButton = v31:FindFirstChild("InviteButton");

    if InviteButton and InviteButton:IsA("GuiButton") then
        local v41 = InviteButton.MouseButton1Click:Connect(function() -- Line: 198
            -- upvalues: u30 (copy), InviteButton (copy), u11 (ref), MessagePrompt (ref), Networking (ref), NotificationController (ref), returnToGuildPage (ref), u1 (ref)
            local u34 = u30;
            local u35 = InviteButton;
            local u36 = u11[u34] or "this member";
            task.spawn(function() -- Line: 129
                -- upvalues: MessagePrompt (ref), u36 (copy), u35 (copy), Networking (ref), u34 (copy), NotificationController (ref), returnToGuildPage (ref), u1 (ref)
                if not MessagePrompt.Prompt({
                    titleOverride = "Transfer Ownership?",
                    yield = true,
                    dontRestoreOnSuccess = true,
                    message = string.format("Hand <b>%s</b> the crown?\nYou\'ll drop to a regular Member and this <b>can\'t be undone</b>.", u36),
                    options = MessagePrompt.Choices.YesNo
                }) then
                    return;
                end;

                u35.Active = false;
                local v37, v38, v39 = pcall(function() -- Line: 150
                    -- upvalues: Networking (ref), u34 (ref)
                    return Networking.Guild.TransferOwnership:Fire(u34);
                end);

                if not v37 then
                    NotificationController:CreateNotification("Try again");
                    u35.Active = true;

                    return;
                end;

                if v38 then
                    NotificationController:CreateNotification(string.format("Transferred guild ownership to %s", u36));
                    returnToGuildPage();

                    return;
                end;

                local v40 = tostring(v39 or "");
                NotificationController:CreateNotification(u1[v40] or ((v40 == "" or not v40) and "Could not transfer ownership" or v40));
                u35.Active = true;
            end);
        end);
        table.insert(u9, v41);
    end;
end;

local function populate() -- Line: 204
    -- upvalues: u8 (ref), u4 (ref), u5 (ref), clearRows (copy), LocalPlayer (copy), u6 (ref), Networking (copy), renderRow (copy)
    if not u8 then
        return;
    end;

    if not (u4 and u5) then
        return;
    end;

    local v42 = u4;
    local v43 = u5;
    clearRows();

    if LocalPlayer:GetAttribute("GuildRole") ~= "Owner" then
        if u6 then
            u6.Visible = true;
        end;

        v42.Visible = false;

        return;
    end;

    local success, result = pcall(function() -- Line: 220
        -- upvalues: Networking (ref)
        return Networking.Guild.GetMyGuild:Fire();
    end);

    if not u8 then
        return;
    end;

    local v44;

    if success and (typeof(result) == "table" and (typeof(result.Guild) == "table" and typeof(result.Guild.Members) == "table")) then
        v44 = result.Guild.Members;
    else
        v44 = nil;
    end;

    local v45 = 0;

    if v44 then
        for i in v44 do
            local v46 = tonumber(i);

            if v46 and v46 ~= LocalPlayer.UserId then
                renderRow(v43, v42, v46);
                v45 = v45 + 1;
            end;
        end;
    end;

    if u6 then
        u6.Visible = v45 == 0;
    end;

    v42.Visible = v45 > 0;
end;

local function ResolveRefs(p47) -- Line: 249
    -- upvalues: u7 (ref), u6 (ref), u4 (ref), u5 (ref)
    local Frame = p47:FindFirstChild("Frame");

    if not Frame then
        return;
    end;

    local Header = Frame:FindFirstChild("Header");

    if Header then
        local ExitButton = Header:FindFirstChild("ExitButton");

        if ExitButton and ExitButton:IsA("GuiButton") then
            u7 = ExitButton;
        end;
    end;

    local Content = Frame:FindFirstChild("Content");

    if not Content then
        return;
    end;

    local StatusLabel = Content:FindFirstChild("StatusLabel");

    if StatusLabel and StatusLabel:IsA("TextLabel") then
        u6 = StatusLabel;
    end;

    local ScrollingFrame = Content:FindFirstChild("ScrollingFrame");

    if ScrollingFrame and ScrollingFrame:IsA("ScrollingFrame") then
        u4 = ScrollingFrame;
        local PlayerTemplate = ScrollingFrame:FindFirstChild("PlayerTemplate");

        if PlayerTemplate and PlayerTemplate:IsA("GuiObject") then
            u5 = PlayerTemplate;
            PlayerTemplate.Visible = false;
        end;
    end;
end;

local function BindButtons() -- Line: 276
    -- upvalues: u7 (ref), returnToGuildPage (copy)
    if u7 then
        u7.MouseButton1Click:Connect(function() -- Line: 278
            -- upvalues: returnToGuildPage (ref)
            returnToGuildPage();
        end);
    end;
end;

function v2.Init(p48) -- Line: 285
end;

function v2.Start(p49) -- Line: 287
    -- upvalues: PlayerGui (copy), u3 (ref), ResolveRefs (copy), u7 (ref), returnToGuildPage (copy), GuiController (copy), u8 (ref), populate (copy), clearRows (copy)
    task.spawn(function() -- Line: 288
        -- upvalues: PlayerGui (ref), u3 (ref), ResolveRefs (ref), u7 (ref), returnToGuildPage (ref), GuiController (ref), u8 (ref), populate (ref), clearRows (ref)
        local GuildTransfer = PlayerGui:WaitForChild("GuildTransfer", 30);

        if not (GuildTransfer and GuildTransfer:IsA("ScreenGui")) then
            return;
        end;

        u3 = GuildTransfer;
        GuildTransfer.Enabled = false;
        ResolveRefs(GuildTransfer);

        if u7 then
            u7.MouseButton1Click:Connect(function() -- Line: 278
                -- upvalues: returnToGuildPage (ref)
                returnToGuildPage();
            end);
        end;

        GuiController.GuiFocusedSignal:Connect(function(p50) -- Line: 298
            -- upvalues: GuildTransfer (copy), u8 (ref), populate (ref)
            if p50 == GuildTransfer then
                u8 = true;
                populate();
            end;
        end);
        GuiController.GuiUnfocusedSignal:Connect(function(p51) -- Line: 304
            -- upvalues: GuildTransfer (copy), u8 (ref), clearRows (ref)
            if p51 == GuildTransfer then
                u8 = false;
                clearRows();
            end;
        end);
    end);
end;

return v2;