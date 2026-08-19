-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Workspace = game:GetService("Workspace");
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local FormatDurationSymbol = require(ReplicatedStorage.Library.Functions.FormatDurationSymbol);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local InfoOverlay = require(ReplicatedStorage.Library.Client.InfoOverlay);
local Network = require(ReplicatedStorage.Library.Client.Network);
local ServerLuck = require(ReplicatedStorage.Library.Types.ServerLuck);
local Signal = require(ReplicatedStorage.Library.Signal);
local Variables = require(ReplicatedStorage.Library.Variables);
local ServerLuck2 = Constants.NETWORK_MAP.ServerLuck;
local u1 = { "RecoveryEvent", "Countdown", "DragonEggEvent" };
local u2 = GUI.BottomUI();
local BottomFrame = u2.BottomFrame;
local Holder = BottomFrame.Holder;
local List = Holder.List;
local Luck = List.Luck;
local Button = Luck.Button;
local TextLabel = Button.Content.Value.TextLabel;
local x2Luck = List.x2Luck;
local Timer = x2Luck.Timer;
local x2Growth = List.x2Growth;
local Timer2 = x2Growth.Timer;
local u3 = {
    Countdown = {
        Frame = List:FindFirstChild("Countdown"),
        Tooltip = { { "Title", "SOMETHING BIG COMING SOON!" } }
    },
    DemonicEvent = {
        Frame = List:FindFirstChild("DemonicEvent"),
        Tooltip = { { "Title", "A DEMONIC EGG HAS SPAWNED" } }
    }
};
local AnchorPoint = BottomFrame.AnchorPoint;
local Position = BottomFrame.Position;
local AnchorPoint2 = Holder.AnchorPoint;
local Position2 = Holder.Position;
local AnchorPoint3 = List.AnchorPoint;
local Position3 = List.Position;
local Size = List.Size;
local u4 = {
    Multiplier = 1
};
local u5 = {};

local function escapeRichText(p6) -- Line: 68
    return p6:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;");
end;

local function getMultiplierText() -- Line: 72
    -- upvalues: u4 (ref)
    local v7 = math.floor(u4.Multiplier);

    return `x{math.max(1, v7)}`;
end;

local function getBoosterText() -- Line: 76
    -- upvalues: u4 (ref)
    local BoostedByDisplayName = u4.BoostedByDisplayName;

    return (BoostedByDisplayName == nil or BoostedByDisplayName == "") and "<font color=\"#38E839\">@Server</font>" or `<font color="#38E839">@{BoostedByDisplayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")}</font>`;
end;

local function getRemainingSeconds(p8, p9) -- Line: 93
    -- upvalues: u5 (ref)
    local v10 = u5[p8];

    if v10 == nil then
        return 0;
    end;

    local v11 = math.ceil(v10 - p9);

    return math.max(0, v11);
end;

local function getBuffRemainingSeconds(p12) -- Line: 102
    -- upvalues: u1 (copy), u5 (ref)
    local v13 = 0;

    for _, v in u1 do
        local v14 = u5[v];
        local v15;

        if v14 == nil then
            v15 = 0;
        else
            local v16 = math.ceil(v14 - p12);
            v15 = math.max(0, v16);
        end;

        v13 = math.max(v13, v15);
    end;

    return v13;
end;

local function render(p17) -- Line: 111
    -- upvalues: Workspace (copy), u4 (ref), u1 (copy), u5 (ref), FormatDurationSymbol (copy), Luck (copy), TextLabel (copy), x2Luck (copy), Timer (copy), x2Growth (copy), Timer2 (copy), u3 (copy), u2 (copy)
    local v18 = p17 or Workspace:GetServerTimeNow();
    local v19 = u4.Multiplier > 1;
    local v20 = 0;

    for _, v in u1 do
        local v21 = u5[v];
        local v22;

        if v21 == nil then
            v22 = 0;
        else
            local v23 = math.ceil(v21 - v18);
            v22 = math.max(0, v23);
        end;

        v20 = math.max(v20, v22);
    end;

    local v24 = v20 > 0;
    local v25 = FormatDurationSymbol(v20);
    Luck.Visible = v19;
    local v26 = math.floor(u4.Multiplier);
    TextLabel.Text = `x{math.max(1, v26)}`;
    local v27 = u4.ExpiresAt and v18 < u4.ExpiresAt and Luck:FindFirstChild("Timer");

    if v27 then
        v27.Text = FormatDurationSymbol(u4.ExpiresAt - v18);
    end;

    x2Luck.Visible = v24;
    Timer.Text = v25;
    x2Growth.Visible = v24;
    Timer2.Text = v25;
    local v28 = v19 or v24;

    for i, v in u3 do
        if v.Frame then
            local v29 = u5[i];
            local v30;

            if v29 == nil then
                v30 = 0;
            else
                local v31 = math.ceil(v29 - v18);
                v30 = math.max(0, v31);
            end;

            if v30 > 0 then
                v.Frame.Timer.Text = FormatDurationSymbol(v30);
                v.Frame.Visible = true;
                v28 = true;
            else
                v.Frame.Visible = false;
            end;
        end;
    end;

    u2.Enabled = v28;
end;

local function applyState(p32) -- Line: 169
    -- upvalues: u4 (ref), render (copy)
    u4 = p32;
    render();
end;

InfoOverlay.DynamicHook(Button, function() -- Line: 85, Name: getOverlayBlocks
    -- upvalues: u4 (ref)
    local v33 = {};
    local v34 = {};
    local v35 = math.floor(u4.Multiplier);
    v34[1], v34[2] = "Title", `<font color="#38E839">{`x{math.max(1, v35)}`}</font> Server Luck!`;
    local v36 = {};
    local BoostedByDisplayName = u4.BoostedByDisplayName;
    v36[1], v36[2] = "Title", `Boosted by {(BoostedByDisplayName == nil or BoostedByDisplayName == "") and "<font color=\"#38E839\">@Server</font>" or `<font color="#38E839">@{BoostedByDisplayName:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")}</font>`}!`;
    v33[1], v33[2], v33[3] = v34, { "Div" }, v36;

    return v33;
end);
InfoOverlay.Hook(x2Luck.Icon, { { "Title", "X2 LUCK" } });
InfoOverlay.Hook(x2Growth.Icon, { { "Title", "X2 EGG GROWTH SPEED" } });

local function renderPlatform(p37) -- Line: 148
    -- upvalues: Variables (copy), BottomFrame (copy), Holder (copy), List (copy), AnchorPoint (copy), Position (copy), AnchorPoint2 (copy), Position2 (copy), AnchorPoint3 (copy), Position3 (copy), Size (copy)
    if Variables.Mobile then
        BottomFrame.AnchorPoint = Vector2.new(1, 0);
        BottomFrame.Position = UDim2.fromScale(0.98, 0.07);
        Holder.AnchorPoint = Vector2.new(1, 0);
        Holder.Position = UDim2.fromScale(1, 0);
        List.AnchorPoint = Vector2.new(0.5, 0);
        List.Position = UDim2.fromScale(0.5, 0);
        List.Size = UDim2.fromScale(0.975, 0.5);

        return;
    end;

    BottomFrame.AnchorPoint = AnchorPoint;
    BottomFrame.Position = Position;
    Holder.AnchorPoint = AnchorPoint2;
    Holder.Position = Position2;
    List.AnchorPoint = AnchorPoint3;
    List.Position = Position3;
    List.Size = Size;
end;

for _, v in u3 do
    if v.Frame then
        InfoOverlay.Hook(v.Frame.Icon, v.Tooltip);
    end;
end;

render();
renderPlatform();
Signal.Fired("Changed Platform"):Connect(renderPlatform);
Network.Fired(ServerLuck2.STATE_UPDATED):Connect(function(p38) -- Line: 192
    -- upvalues: ServerLuck (copy), u4 (ref), render (copy)
    if ServerLuck.State(p38) then
        u4 = p38;
        render();
    end;
end);
local v39 = Network.Invoke(ServerLuck2.GET_STATE);

if ServerLuck.State(v39) then
    u4 = v39;
    render();
end;

Network.Fired(Network.NET_MAP.AdminAbuse.EVENT_STARTED):Connect(function(p40, p41, p42) -- Line: 203
    -- upvalues: u5 (ref), Workspace (copy), render (copy)
    u5[p40] = Workspace:GetServerTimeNow() + p41;
    render();
end);
Network.Fired(Network.NET_MAP.AdminAbuse.EVENT_STOPPED):Connect(function(p43) -- Line: 208
    -- upvalues: u5 (ref), render (copy)
    u5[p43] = nil;
    render();
end);
u5 = Network.Invoke(Network.NET_MAP.AdminAbuse.GET_ACTIVE_EVENTS);
task.spawn(function() -- Line: 215
    -- upvalues: render (copy)
    while true do
        task.wait(1);
        render();
    end;
end);