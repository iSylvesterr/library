-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
local WorldRelease = require(ReplicatedStorage.SharedModules.WorldRelease);
local Worlds = require(ReplicatedStorage.SharedModules.Worlds);
local LocalPlayer = Players.LocalPlayer;
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui");
local GuiController = require(LocalPlayer.PlayerScripts.Controllers.GuiController);
local NotificationController = require(LocalPlayer.PlayerScripts.Controllers.NotificationController);
local u1 = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(57, 179, 0)), ColorSequenceKeypoint.new(0.146805, Color3.fromRGB(57, 179, 0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(85, 255, 0)) });
local u2 = Color3.fromRGB(20, 48, 0);
local u3 = Color3.fromRGB(209, 255, 208);
local u4 = { {
        Id = "Main",
        Label = "Garden Valley",
        ShortName = "Garden Valley",
        Image = "rbxassetid://75563576781416"
    }, {
        Id = "FallHarvest",
        Label = "Fall Harvest World",
        ShortName = "Fall Harvest",
        Image = "rbxassetid://90486179229210"
    } };
local v5 = {
    StartOrder = 4
};
local u6 = nil;
local u7 = nil;
local u8 = {};
local u9 = nil;

local function setLayeredText(p10, p11) -- Line: 99
    p10.Text = p11;
    local TextLabel = p10:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p11;
    end;
end;

local function closeMenu() -- Line: 107
    -- upvalues: GuiController (copy), u6 (ref)
    GuiController:Close();
    local v12 = u6;
    u6 = nil;

    if v12 then
        v12();
    end;
end;

local function handleTeleport(p13) -- Line: 116
    -- upvalues: Worlds (copy), NotificationController (copy), Networking (copy), GuiController (copy), u6 (ref)
    if p13.Id == Worlds.CurrentId then
        NotificationController:CreateNotification((`You're already in {p13.ShortName}!`));

        return;
    end;

    Networking.Worlds.RequestTravel:Fire(p13.Id);
    GuiController:Close();
    local v14 = u6;
    u6 = nil;

    if v14 then
        v14();
    end;
end;

local function markAsHere(p15) -- Line: 135
    -- upvalues: u1 (copy), u2 (copy), u3 (copy)
    local v16 = p15:FindFirstChildOfClass("UIGradient");

    if v16 then
        v16.Color = u1;
    end;

    for _, descendant in p15:GetDescendants() do
        if descendant:IsA("UIStroke") then
            descendant.Color = u2;
        end;
    end;

    local TextLabel = p15:FindFirstChild("TextLabel");

    if not (TextLabel and TextLabel:IsA("TextLabel")) then
        return;
    end;

    TextLabel.Text = "You\'re Here!";
    local TextLabel2 = TextLabel:FindFirstChild("TextLabel");

    if not (TextLabel2 and TextLabel2:IsA("TextLabel")) then
        return;
    end;

    TextLabel2.Text = "You\'re Here!";
    local v17 = TextLabel2:FindFirstChildOfClass("UIGradient");

    if v17 then
        v17.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(0.418, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, u3) });
    end;
end;

local function formatClosing(p18) -- Line: 175
    local v19 = math.floor(p18);
    local v20 = math.max(0, v19);
    local v21 = v20 // 86400;
    local v22 = v20 % 86400 // 3600;
    local v23 = v20 % 3600 // 60;

    if v21 > 0 then
        return string.format("%dd %dh", v21, v22);
    end;

    if v22 > 0 then
        return string.format("%dh %02dm", v22, v23);
    end;

    if v23 > 0 then
        return string.format("%dm %02ds", v23, v20 % 60);
    end;

    return string.format("%ds", v20);
end;

local function closingText(p24) -- Line: 196
    -- upvalues: WorldRelease (copy), formatClosing (copy)
    local v25 = WorldRelease.SecondsUntilWorldCloses(p24);

    if v25 == nil then
        return nil;
    end;

    return math.floor(v25) <= 0 and "Ending soon!" or "Ends in " .. formatClosing(v25);
end;

local function addClosingCountdown(p26, p27, p28, p29) -- Line: 213
    -- upvalues: WorldRelease (copy), formatClosing (copy), u8 (copy)
    local Scale = p26.Size.Y.Scale;
    local v30 = Scale + 0.17;
    p26.Size = UDim2.new(p26.Size.X.Scale, 0, v30, 0);
    p26.Position = UDim2.new(p26.Position.X.Scale, 0, p26.Position.Y.Scale + 0.17, 0);
    local v31 = Scale / v30;

    for _, v in { p26:FindFirstChild("ImageLabel"), p27, p28 } do
        if v and v:IsA("GuiObject") then
            v.Position = UDim2.new(v.Position.X.Scale, 0, v.Position.Y.Scale * v31, 0);
            v.Size = UDim2.new(v.Size.X.Scale, 0, v.Size.Y.Scale * v31, 0);
        end;
    end;

    local v32 = p27:Clone();
    v32.Name = "ClosingCountdown";
    v32.Size = UDim2.fromScale(0.9, 0.155);
    v32.Position = UDim2.fromScale(0.5, 0.955);
    local v33 = WorldRelease.SecondsUntilWorldCloses(p29);
    local v34;

    if v33 == nil then
        v34 = nil;
    else
        v34 = math.floor(v33) <= 0 and "Ending soon!" or "Ends in " .. formatClosing(v33);
    end;

    local v35 = v34 or "";
    v32.Text = v35;
    local TextLabel = v32:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = v35;
    end;

    v32.Parent = p26;
    table.insert(u8, {
        WorldId = p29,
        Label = v32
    });
end;

local function refreshCountdowns() -- Line: 247
    -- upvalues: u8 (copy), WorldRelease (copy), formatClosing (copy)
    for _, v in u8 do
        local v36 = WorldRelease.SecondsUntilWorldCloses(v.WorldId);
        local v37;

        if v36 == nil then
            v37 = nil;
        else
            v37 = math.floor(v36) <= 0 and "Ending soon!" or "Ends in " .. formatClosing(v36);
        end;

        if v37 then
            local Label = v.Label;
            Label.Text = v37;
            local TextLabel = Label:FindFirstChild("TextLabel");

            if TextLabel and TextLabel:IsA("TextLabel") then
                TextLabel.Text = v37;
            end;
        end;
    end;
end;

local function stopCountdownTicker() -- Line: 259
    -- upvalues: u9 (ref)
    local v38 = u9;
    u9 = nil;

    if v38 then
        task.cancel(v38);
    end;
end;

local function startCountdownTicker() -- Line: 267
    -- upvalues: u9 (ref), u8 (copy), refreshCountdowns (copy)
    if u9 ~= nil or #u8 == 0 then
        return;
    end;

    u9 = task.spawn(function() -- Line: 271
        -- upvalues: refreshCountdowns (ref)
        while true do
            refreshCountdowns();
            task.wait(1);
        end;
    end);
end;

local function populateWorldFrame(p39, u40) -- Line: 279
    -- upvalues: Worlds (copy), markAsHere (copy), NotificationController (copy), Networking (copy), GuiController (copy), u6 (ref), WorldRelease (copy), formatClosing (copy), addClosingCountdown (copy)
    local Main_Frame = p39:FindFirstChild("Main_Frame");

    if not (Main_Frame and Main_Frame:IsA("GuiObject")) then
        return;
    end;

    local Name = Main_Frame:FindFirstChild("Name");

    if not (Name and Name:IsA("TextLabel")) then
        Name = nil;
    end;

    if Name then
        local Label = u40.Label;
        Name.Text = Label;
        local TextLabel = Name:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = Label;
        end;
    end;

    local ImageLabel = Main_Frame:FindFirstChild("ImageLabel");

    if ImageLabel and ImageLabel:IsA("ImageLabel") then
        ImageLabel.Image = u40.Image;
    end;

    local TeleportButton = Main_Frame:FindFirstChild("TeleportButton");

    if TeleportButton and TeleportButton:IsA("GuiButton") then
        if u40.Id == Worlds.CurrentId then
            markAsHere(TeleportButton);
        end;

        TeleportButton.Activated:Connect(function() -- Line: 303
            -- upvalues: u40 (copy), Worlds (ref), NotificationController (ref), Networking (ref), GuiController (ref), u6 (ref)
            local v41 = u40;

            if v41.Id == Worlds.CurrentId then
                NotificationController:CreateNotification((`You're already in {v41.ShortName}!`));

                return;
            end;

            Networking.Worlds.RequestTravel:Fire(v41.Id);
            GuiController:Close();
            local v42 = u6;
            u6 = nil;

            if v42 then
                v42();
            end;
        end);

        if Name then
            local v43 = WorldRelease.SecondsUntilWorldCloses(u40.Id);
            local v44;

            if v43 == nil then
                v44 = nil;
            else
                v44 = math.floor(v43) <= 0 and "Ending soon!" or "Ends in " .. formatClosing(v43);
            end;

            if v44 ~= nil then
                addClosingCountdown(Main_Frame, Name, TeleportButton, u40.Id);
            end;
        end;
    end;
end;

local function buildRows(p45, p46, p47) -- Line: 315
    -- upvalues: u4 (copy), WorldRelease (copy), formatClosing (copy), populateWorldFrame (copy)
    local v48 = false;

    for _, v in u4 do
        local v49 = WorldRelease.SecondsUntilWorldCloses(v.Id);
        local v50;

        if v49 == nil then
            v50 = nil;
        else
            v50 = math.floor(v49) <= 0 and "Ending soon!" or "Ends in " .. formatClosing(v49);
        end;

        if v50 ~= nil then
            v48 = true;
            break;
        end;
    end;

    for i, v in u4 do
        if i > 1 then
            local v51 = p47:Clone();

            if v51:IsA("GuiObject") then
                v51.LayoutOrder = i * 2 - 1;

                if v48 then
                    local Y = v51.Size.Y;
                    v51.Size = UDim2.new(0.416, 0, Y.Scale, Y.Offset);
                end;

                v51.Parent = p45;
            end;
        end;

        local v52 = p46:Clone();

        if v52:IsA("GuiObject") then
            v52.LayoutOrder = i * 2;
            populateWorldFrame(v52, v);
            v52.Parent = p45;
        end;
    end;
end;

local function refreshScrollability(p53) -- Line: 358
    -- upvalues: u4 (copy)
    local v54 = p53:FindFirstChildOfClass("UIListLayout");

    if not v54 then
        return;
    end;

    local v55 = 0;

    for _, child in p53:GetChildren() do
        if child:IsA("GuiObject") and child.Name ~= "Padding" then
            v55 = v55 + child.AbsoluteSize.Y;
        end;
    end;

    if v55 > 0 then
        v55 = v55 + (v54.Padding.Scale * p53.AbsoluteSize.Y + v54.Padding.Offset * math.max(0, #u4 - 1));
    end;

    local v56 = v55 <= p53.AbsoluteSize.Y + 8;
    p53.ScrollingEnabled = not v56;
    p53.ScrollBarThickness = v56 and 0 or 4;

    if v56 then
        p53.CanvasPosition = Vector2.zero;
    end;
end;

function v5.Init(p57) -- Line: 385
end;

function v5.Start(p58) -- Line: 387
    -- upvalues: PlayerGui (copy), buildRows (copy), u7 (ref), refreshScrollability (copy), refreshCountdowns (copy), u9 (ref), u8 (copy), closeMenu (copy)
    local EventWorldsTeleporter = PlayerGui:WaitForChild("EventWorldsTeleporter");
    EventWorldsTeleporter.Enabled = false;
    local Frame = EventWorldsTeleporter:WaitForChild("Frame");
    local ScrollingFrame = Frame:WaitForChild("ScrollingFrame");
    local WorldFrame = ScrollingFrame:FindFirstChild("WorldFrame");
    local Connector = ScrollingFrame:FindFirstChild("Connector");

    if not (WorldFrame and Connector) then
        warn("[EventWorldsTeleporterController] EventWorldsTeleporter is missing its WorldFrame/Connector template");

        return;
    end;

    local v59 = WorldFrame:Clone();
    local v60 = Connector:Clone();

    for _, child in ScrollingFrame:GetChildren() do
        if child.Name == "WorldFrame" or child.Name == "Connector" then
            child:Destroy();
        end;
    end;

    buildRows(ScrollingFrame, v59, v60);

    if ScrollingFrame:IsA("ScrollingFrame") then
        u7 = ScrollingFrame;
        ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() -- Line: 419
            -- upvalues: refreshScrollability (ref), ScrollingFrame (copy)
            refreshScrollability(ScrollingFrame);
        end);
        local v61 = ScrollingFrame:FindFirstChildOfClass("UIListLayout");

        if v61 then
            v61:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() -- Line: 424
                -- upvalues: refreshScrollability (ref), ScrollingFrame (copy)
                refreshScrollability(ScrollingFrame);
            end);
        end;

        refreshScrollability(ScrollingFrame);
    end;

    EventWorldsTeleporter:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 431
        -- upvalues: EventWorldsTeleporter (copy), refreshCountdowns (ref), u9 (ref), u8 (ref)
        if EventWorldsTeleporter.Enabled then
            refreshCountdowns();

            if u9 == nil then
                if #u8 == 0 then
                    return;
                end;

                u9 = task.spawn(function() -- Line: 271
                    -- upvalues: refreshCountdowns (ref)
                    while true do
                        refreshCountdowns();
                        task.wait(1);
                    end;
                end);
            end;
        else
            local v62 = u9;
            u9 = nil;

            if v62 then
                task.cancel(v62);
            end;
        end;
    end);
    local ExitButton = Frame:WaitForChild("Header"):WaitForChild("ExitButton");

    if ExitButton:IsA("GuiButton") then
        ExitButton.Activated:Connect(closeMenu);
    end;
end;

function v5.Open(p63, p64) -- Line: 448
    -- upvalues: u6 (ref), GuiController (copy), u7 (ref), refreshScrollability (copy)
    u6 = p64;
    GuiController:Open("EventWorldsTeleporter");
    local u65 = u7;

    if u65 then
        task.defer(function() -- Line: 457
            -- upvalues: u65 (copy), refreshScrollability (ref)
            if u65.Parent then
                refreshScrollability(u65);
            end;
        end);
    end;
end;

return v5;