-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
game:GetService("RunService");
local Networking = require(ReplicatedStorage.SharedModules.Networking);
require(ReplicatedStorage.SharedModules.Environment);
local ReleaseChangelogController = require(script.Parent.ReleaseChangelogController);
local ReleaseCountdownController = require(script.Parent.ReleaseCountdownController);
local SfxController = require(script.Parent.SfxController);
local u1 = Color3.fromRGB(255, 255, 255);
local u2 = Color3.fromRGB(156, 156, 156);

local function dbg(...) -- Line: 65
end;

local v3 = {};
local u4 = nil;
local u5 = nil;
local u6 = nil;
local u7 = nil;
local u8 = nil;
local u9 = nil;
local u10 = {};
local u11 = nil;
local u12 = nil;
local u13 = nil;
local u14 = nil;
local u15 = nil;
local u16 = {};

local function assetUrl(p17) -- Line: 95
    if p17 and p17 > 0 then
        return string.format("rbxassetid://%d", p17);
    end;

    return nil;
end;

local function formatAgo(p18) -- Line: 104
    -- upvalues: ReleaseCountdownController (copy)
    if typeof(p18) ~= "number" or p18 <= 0 then
        return "";
    end;

    local v19 = ReleaseCountdownController:NowUnix() - p18;
    local v20 = math.floor(v19);
    local v21 = math.max(0, v20);

    if v21 < 1 then
        return "just now";
    end;

    local v22 = {
        { v21 // 604800, "w" },
        { v21 % 604800 // 86400, "d" },
        { v21 % 86400 // 3600, "h" },
        { v21 % 3600 // 60, "m" },
        { v21 % 60, "s" }
    };

    for i, v in v22 do
        if v[1] > 0 then
            local v23 = string.format("%d%s", v[1], v[2]);
            local v24 = v22[i + 1];

            if v24 and v24[1] > 0 then
                v23 = v23 .. string.format(" %d%s", v24[1], v24[2]);
            end;

            return v23 .. " ago";
        end;
    end;

    return "just now";
end;

local function imageForEntry(p25) -- Line: 138
    -- upvalues: ReleaseCountdownController (copy)
    local reveal_asset_id = p25.reveal_asset_id;
    local v26;

    if reveal_asset_id and reveal_asset_id > 0 then
        v26 = string.format("rbxassetid://%d", reveal_asset_id);
    else
        v26 = nil;
    end;

    if not v26 then
        local silhouette_asset_id = p25.silhouette_asset_id;

        if silhouette_asset_id and silhouette_asset_id > 0 then
            v26 = string.format("rbxassetid://%d", silhouette_asset_id);
        else
            v26 = nil;
        end;
    end;

    if v26 then
        return v26;
    end;

    for _, v in ReleaseCountdownController:GetAssets() do
        if v.id == p25.id then
            local reveal_asset_id2 = v.reveal_asset_id;
            local v27;

            if reveal_asset_id2 and reveal_asset_id2 > 0 then
                v27 = string.format("rbxassetid://%d", reveal_asset_id2);
            else
                v27 = nil;
            end;

            if not v27 then
                local silhouette_asset_id = v.silhouette_asset_id;

                if silhouette_asset_id and silhouette_asset_id > 0 then
                    return string.format("rbxassetid://%d", silhouette_asset_id);
                end;

                v27 = nil;
            end;

            return v27;
        end;
    end;

    return nil;
end;

local function setTwinText(p28, p29) -- Line: 153
    if not p28 then
        return;
    end;

    p28.Text = p29;
    local TextLabel = p28:FindFirstChild("TextLabel");

    if TextLabel and TextLabel:IsA("TextLabel") then
        TextLabel.Text = p29;
    end;
end;

local function updateInformation(p30) -- Line: 164
    -- upvalues: u6 (ref), u7 (ref), formatAgo (copy), u8 (ref), imageForEntry (copy), u9 (ref)
    if u6 then
        u6.Text = p30.description;
    end;

    if u7 then
        u7.Text = formatAgo(p30.released_at_unix);
    end;

    local v31 = u8;
    local name = p30.name;

    if v31 then
        v31.Text = name;
        local TextLabel = v31:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = name;
        end;
    end;

    local v32 = imageForEntry(p30);

    if u9 and v32 then
        u9.Image = v32;
    end;
end;

local function selectEntry(p33) -- Line: 178
    -- upvalues: u11 (ref), u12 (ref), dbg (copy), u10 (copy), u1 (copy), u2 (copy), u6 (ref), u7 (ref), formatAgo (copy), u8 (ref), imageForEntry (copy), u9 (ref)
    u11 = p33.entry.id;
    u12 = p33;
    dbg("selectEntry:", p33.entry.name, "id=", p33.entry.id, "(", #u10, "cards to recolor)");

    for _, v in u10 do
        local v34;

        if v == p33 then
            v34 = u1;
        else
            v34 = u2;
        end;

        v.card.BackgroundColor3 = v34;
    end;

    local entry = p33.entry;

    if u6 then
        u6.Text = entry.description;
    end;

    if u7 then
        u7.Text = formatAgo(entry.released_at_unix);
    end;

    local v35 = u8;
    local name = entry.name;

    if v35 then
        v35.Text = name;
        local TextLabel = v35:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = name;
        end;
    end;

    local v36 = imageForEntry(entry);

    if u9 and v36 then
        u9.Image = v36;
    end;
end;

local function anyUnseen() -- Line: 189
    -- upvalues: ReleaseChangelogController (copy), u16 (copy)
    for _, v in ReleaseChangelogController:GetChangelog() do
        if v.name ~= "" and not u16[v.name] then
            return true;
        end;
    end;

    return false;
end;

local function updateNewsIconNotification() -- Line: 200
    -- upvalues: u15 (ref), anyUnseen (copy)
    if u15 then
        u15.Visible = anyUnseen();
    end;
end;

local function updateNewsIconVisibility() -- Line: 208
    -- upvalues: u14 (ref), ReleaseChangelogController (copy)
    if u14 then
        u14.Visible = #ReleaseChangelogController:GetChangelog() >= 1;
    end;
end;

local function markDropSeen(p37) -- Line: 216
    -- upvalues: u16 (copy), dbg (copy), Networking (copy), u15 (ref), anyUnseen (copy)
    local Notification = p37.card:FindFirstChild("Notification");

    if Notification and Notification:IsA("GuiObject") then
        Notification.Visible = false;
    end;

    local name = p37.entry.name;

    if name == "" or u16[name] then
        return;
    end;

    u16[name] = true;
    dbg("mark seen:", name);
    pcall(function() -- Line: 227
        -- upvalues: Networking (ref), name (copy)
        Networking.Release.MarkSeen:Fire(name);
    end);

    if u15 then
        u15.Visible = anyUnseen();
    end;
end;

local function markSelectedSeen() -- Line: 236
    -- upvalues: u13 (ref), u12 (ref), markDropSeen (copy)
    if u13 and (u13.Enabled and u12) then
        markDropSeen(u12);
    end;
end;

local Click = game.SoundService.SFX.Click;

local function buildCard(u38, p39) -- Line: 244
    -- upvalues: u5 (ref), u4 (ref), u2 (copy), formatAgo (copy), imageForEntry (copy), u16 (copy), dbg (copy), SfxController (copy), markDropSeen (copy), selectEntry (copy), Click (copy)
    local v40 = u5;
    local v41 = u4;

    if not (v40 and v41) then
        return nil;
    end;

    local v42 = v40:Clone();
    v42.Name = "Card";
    v42.Visible = true;
    v42.LayoutOrder = p39;
    v42.BackgroundColor3 = u2;
    local UpdateName = v42:FindFirstChild("UpdateName");
    local name = u38.name;

    if UpdateName then
        UpdateName.Text = name;
        local TextLabel = UpdateName:FindFirstChild("TextLabel");

        if TextLabel and TextLabel:IsA("TextLabel") then
            TextLabel.Text = name;
        end;
    end;

    local Description = v42:FindFirstChild("Description");

    if Description and Description:IsA("TextLabel") then
        Description.Text = formatAgo(u38.released_at_unix);
    end;

    local ImageLabel = v42:FindFirstChild("ImageLabel");
    local v43 = imageForEntry(u38);

    if ImageLabel and (ImageLabel:IsA("ImageLabel") and v43) then
        ImageLabel.Image = v43;
    end;

    local Notification = v42:FindFirstChild("Notification");

    if Notification and Notification:IsA("GuiObject") then
        Notification.Visible = not u16[u38.name];
    end;

    local u44 = {
        card = v42,
        entry = u38
    };
    v42.Activated:Connect(function() -- Line: 277
        -- upvalues: dbg (ref), u38 (copy), SfxController (ref), markDropSeen (ref), u44 (copy), selectEntry (ref)
        dbg("Card.Activated fired:", u38.name);
        pcall(function() -- Line: 279
            -- upvalues: SfxController (ref)
            SfxController:PlayClickSound();
        end);
        markDropSeen(u44);
        selectEntry(u44);
    end);
    v42.MouseButton1Click:Connect(function() -- Line: 287
        -- upvalues: Click (ref), dbg (ref), u38 (copy), markDropSeen (ref), u44 (copy), selectEntry (ref)
        Click.TimePosition = 0;
        Click.PlaybackSpeed = 1 + math.random(-15, 15) / 100;
        Click.Playing = true;
        dbg("Card.MouseButton1Click fired:", u38.name);
        markDropSeen(u44);
        selectEntry(u44);
    end);
    v42.Parent = v41;
    dbg("built card", p39, u38.name, "LayoutOrder=", v42.LayoutOrder);

    return u44;
end;

local function ComputeCardHeight(p45) -- Line: 302
    local X = p45.AbsoluteCanvasSize.X;
    local v46 = p45:FindFirstChildOfClass("UIPadding");

    return math.max(0, X - (not v46 and 0 or (v46.PaddingLeft.Scale + v46.PaddingRight.Scale) * X + v46.PaddingLeft.Offset + v46.PaddingRight.Offset)) * 0.96 / 4.5;
end;

local function RefreshCanvas() -- Line: 315
    -- upvalues: u4 (ref)
    local v47 = u4;

    if not v47 then
        return;
    end;

    local v48 = v47:FindFirstChildOfClass("UIListLayout");

    if not v48 then
        return;
    end;

    local v49 = v47:FindFirstChildOfClass("UIPadding");
    v47.CanvasSize = UDim2.new(0, 0, 0, v48.AbsoluteContentSize.Y + (not v49 and 0 or v49.PaddingTop.Offset) + 5);
end;

local function RefreshLayout() -- Line: 333
    -- upvalues: u4 (ref), u5 (ref), u10 (copy), RefreshCanvas (copy)
    local v50 = u4;

    if not v50 then
        return;
    end;

    local Y = v50.AbsoluteSize.Y;

    if Y <= 0 then
        return;
    end;

    local v51 = v50:FindFirstChildOfClass("UIListLayout");

    if v51 then
        v51.Padding = UDim.new(0, Y * 0.024);
    end;

    local v52 = v50:FindFirstChildOfClass("UIPadding");

    if v52 then
        v52.PaddingTop = UDim.new(0, Y * 0.004);
    end;

    local new = UDim2.new;
    local X = v50.AbsoluteCanvasSize.X;
    local v53 = v50:FindFirstChildOfClass("UIPadding");
    local v54 = new(0.96, 0, 0, math.max(0, X - (not v53 and 0 or (v53.PaddingLeft.Scale + v53.PaddingRight.Scale) * X + v53.PaddingLeft.Offset + v53.PaddingRight.Offset)) * 0.96 / 4.5 + 1);

    if u5 then
        u5.Size = v54;
    end;

    for _, v in u10 do
        v.card.Size = v54;
    end;

    RefreshCanvas();
end;

local function rebuild() -- Line: 365
    -- upvalues: u4 (ref), u5 (ref), u10 (copy), ReleaseChangelogController (copy), dbg (copy), buildCard (copy), u15 (ref), anyUnseen (copy), u14 (ref), u11 (ref), selectEntry (copy), u13 (ref), u12 (ref), markDropSeen (copy), RefreshLayout (copy)
    local v55 = u4;
    local v56 = u5;

    if not (v55 and v56) then
        return;
    end;

    for _, child in v55:GetChildren() do
        if child:IsA("TextButton") and child ~= v56 then
            child:Destroy();
        end;
    end;

    table.clear(u10);
    local v57 = ReleaseChangelogController:GetChangelog();
    dbg("rebuild:", #v57, "changelog entries");

    for i, v in v57 do
        local v58 = buildCard(v, i);

        if v58 then
            table.insert(u10, v58);
        end;
    end;

    if u15 then
        u15.Visible = anyUnseen();
    end;

    if u14 then
        u14.Visible = #ReleaseChangelogController:GetChangelog() >= 1;
    end;

    if #u10 == 0 then
        dbg("rebuild: no entries -> no cards (changelog empty / DataStore not loaded)");

        return;
    end;

    local v59 = u10[1];

    if u11 then
        for _, v in u10 do
            if v.entry.id == u11 then
                v59 = v;
                break;
            end;
        end;
    end;

    selectEntry(v59);

    if u13 and (u13.Enabled and u12) then
        markDropSeen(u12);
    end;

    RefreshLayout();
end;

local function refreshAgoTexts() -- Line: 417
    -- upvalues: u10 (copy), formatAgo (copy), u7 (ref), u12 (ref)
    for _, v in u10 do
        local Description = v.card:FindFirstChild("Description");

        if Description and Description:IsA("TextLabel") then
            Description.Text = formatAgo(v.entry.released_at_unix);
        end;
    end;

    if u7 and u12 then
        u7.Text = formatAgo(u12.entry.released_at_unix);
    end;
end;

local function setup() -- Line: 431
    -- upvalues: Players (copy), u13 (ref), u4 (ref), u5 (ref), RefreshLayout (copy), RefreshCanvas (copy), u6 (ref), u7 (ref), u8 (ref), u9 (ref), SfxController (copy), Networking (copy), u16 (copy), dbg (copy), u14 (ref), ReleaseChangelogController (copy), u15 (ref), anyUnseen (copy), rebuild (copy), ReleaseCountdownController (copy), u12 (ref), markDropSeen (copy), refreshAgoTexts (copy)
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
    local SecretDropLog = PlayerGui:WaitForChild("SecretDropLog");
    u13 = SecretDropLog;
    local Frame = SecretDropLog:WaitForChild("Frame");
    local Content = Frame:WaitForChild("Content");
    local ScrollingFrame = Content:WaitForChild("ScrollingFrame");
    local Card = ScrollingFrame:WaitForChild("Card");
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None;
    ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y;
    local v60 = ScrollingFrame:FindFirstChildOfClass("UIListLayout");

    if v60 then
        v60.SortOrder = Enum.SortOrder.LayoutOrder;
    end;

    Card.Visible = false;
    local ScrollingFrame2 = Content:WaitForChild("Information"):WaitForChild("ScrollingFrame");
    u4 = ScrollingFrame;
    u5 = Card;
    RefreshLayout();
    ScrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(RefreshLayout);

    if v60 then
        v60:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RefreshCanvas);
    end;

    u6 = ScrollingFrame2:WaitForChild("Message");
    u7 = ScrollingFrame2:WaitForChild("Date");
    u8 = ScrollingFrame2:WaitForChild("UpdateName");
    u9 = ScrollingFrame2:WaitForChild("ImageDisplay"):WaitForChild("Vector");
    local Header = Frame:FindFirstChild("Header");

    if Header then
        Header = Header:FindFirstChild("ExitButton");
    end;

    if Header and Header:IsA("GuiButton") then
        Header.Activated:Connect(function() -- Line: 474
            -- upvalues: SfxController (ref), SecretDropLog (copy)
            pcall(function() -- Line: 475
                -- upvalues: SfxController (ref)
                SfxController:PlayClickSound();
            end);
            SecretDropLog.Enabled = false;
        end);
    end;

    local success, result = pcall(function() -- Line: 484
        -- upvalues: Networking (ref)
        return Networking.Release.SeenRequest:Fire();
    end);

    if success and typeof(result) == "table" then
        for i, v in result do
            if typeof(i) == "string" and v then
                u16[i] = true;
            end;
        end;
    end;

    local v61 = 0;

    for _ in u16 do
        v61 = v61 + 1;
    end;

    dbg("setup complete; seen count:", v61, "refs:", "message=", u6 ~= nil, "date=", u7 ~= nil, "name=", u8 ~= nil, "vector=", u9 ~= nil, "exit=", Header ~= nil);
    task.spawn(function() -- Line: 504
        -- upvalues: PlayerGui (copy), u14 (ref), ReleaseChangelogController (ref), u15 (ref), anyUnseen (ref), dbg (ref)
        local TopbarStandard = PlayerGui:WaitForChild("TopbarStandard", 60);

        if TopbarStandard then
            TopbarStandard = TopbarStandard:WaitForChild("Holders", 30);
        end;

        if TopbarStandard then
            TopbarStandard = TopbarStandard:WaitForChild("Right", 30);
        end;

        if TopbarStandard then
            TopbarStandard = TopbarStandard:WaitForChild("NewsIcon", 60);
        end;

        u14 = TopbarStandard and TopbarStandard:IsA("GuiObject") and TopbarStandard;

        if u14 then
            u14.Visible = #ReleaseChangelogController:GetChangelog() >= 1;
        end;

        if TopbarStandard then
            TopbarStandard = TopbarStandard:WaitForChild("Notification", 30);
        end;

        if not (TopbarStandard and TopbarStandard:IsA("GuiObject")) then
            dbg("NewsIcon.Notification not found");

            return;
        end;

        u15 = TopbarStandard;

        if u15 then
            u15.Visible = anyUnseen();
        end;

        dbg("NewsIcon.Notification resolved; unseen =", (anyUnseen()));
    end);
    rebuild();
    ReleaseChangelogController.Changed:Connect(rebuild);
    ReleaseCountdownController.Changed:Connect(rebuild);
    SecretDropLog:GetPropertyChangedSignal("Enabled"):Connect(function() -- Line: 531
        -- upvalues: SecretDropLog (copy), dbg (ref), u13 (ref), u12 (ref), markDropSeen (ref), refreshAgoTexts (ref), RefreshLayout (ref)
        if SecretDropLog.Enabled then
            dbg("log opened -> marking displayed card seen");

            if u13 and (u13.Enabled and u12) then
                markDropSeen(u12);
            end;

            refreshAgoTexts();
            RefreshLayout();
        end;
    end);

    if u13 and (u13.Enabled and u12) then
        markDropSeen(u12);
    end;

    task.spawn(function() -- Line: 543
        -- upvalues: SecretDropLog (copy), refreshAgoTexts (ref)
        while true do
            repeat
                task.wait(1);
            until SecretDropLog.Enabled;

            refreshAgoTexts();
        end;
    end);
end;

function v3.Init(p62) -- Line: 555
end;

function v3.Start(p63) -- Line: 557
    -- upvalues: setup (copy)
    task.spawn(setup);
end;

return v3;