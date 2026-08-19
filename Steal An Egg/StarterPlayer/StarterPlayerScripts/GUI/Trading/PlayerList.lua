-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local RunService = game:GetService("RunService");
local Assets = game:GetService("ReplicatedStorage"):WaitForChild("Assets");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Save = require(ReplicatedStorage.Library.Client.Save);
local Message = require(ReplicatedStorage.Library.Client.Message);
local Functions = require(ReplicatedStorage.Library.Functions);
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local TradingCmds = require(ReplicatedStorage.Library.Client.TradingCmds);
local Tooltip = require(ReplicatedStorage.Library.Client.GUIFX.Tooltip);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local LocalPlayer = Players.LocalPlayer;
local Button = GUI.SideButtonTools().Trading.Button;
local u2 = GUI.TradePlayerList();
local Frame = u2:WaitForChild("Frame");
local Players2 = Frame.Players;
local Input = Frame.BottomBar.Search.Main.Input;
local Friends = Frame.BottomBar.Container.Main.Friends;
local u3 = Functions.Lock();
local GreenGradient = Assets.UI.Gradients.GreenGradient;
local GreyGradient = Assets.UI.Gradients.GreyGradient;
local u4 = {};
u4.__index = u4;
u4.__class = "TradingPlayerList";

function u4._build() -- Line: 49
    -- upvalues: u4 (copy)
    local v5 = setmetatable({}, u4);
    v5._friendsToggle = false;
    v5._cancelButtonCallbacks = {};
    v5:_init();

    return v5;
end;

function u4._updateGradient(p6, p7, p8, p9) -- Line: 63
    -- upvalues: Functions (copy)
    p7.ImageColor3 = p9 or Color3.new(1, 1, 1);

    if not p7:FindFirstChild(p8.Name) then
        Functions.GradientSwap(p7, p8);
    end;
end;

function u4._cancelButtonFx(p10, p11) -- Line: 70
    if p10._cancelButtonCallbacks[p11.UserId] then
        p10._cancelButtonCallbacks[p11.UserId]();
    end;

    p10._cancelButtonCallbacks[p11.UserId] = nil;
end;

function u4._listScrolling(p12) -- Line: 77
    -- upvalues: Players2 (copy)
    local v13 = Players2:FindFirstChildOfClass("UIListLayout");
    local v14 = Players2:FindFirstChildOfClass("UIPadding");
    Players2.CanvasSize = UDim2.new(0, 0, 0, v13.AbsoluteContentSize.Y + v14.PaddingTop.Offset + v14.PaddingBottom.Offset);
end;

function u4._update(p15) -- Line: 88
    -- upvalues: Functions (copy), Input (copy), Players (copy), LocalPlayer (copy), Save (copy), TradingCmds (copy), Players2 (copy), Assets (copy), u3 (copy), u1 (copy), Message (copy), GreyGradient (copy), ButtonFX (copy), GreenGradient (copy), Frame (copy)
    local v16 = Functions.RegexEscape(string.lower((tostring(Input.Text))));
    local v17;

    if v16 == nil then
        v17 = false;
    else
        v17 = v16 ~= "";
    end;

    local v18 = {};

    for _, v in pairs(Players:GetPlayers()) do
        local success, result = pcall(function() -- Line: 96
            -- upvalues: LocalPlayer (ref), v (copy)
            return LocalPlayer:IsFriendsWith(v.UserId);
        end);
        table.insert(v18, {
            Player = v,
            IsFriend = success and result
        });
    end;

    table.sort(v18, function(p19, p20) -- Line: 102
        if p19.IsFriend and not p20.IsFriend then
            return true;
        end;

        if p19.IsFriend or not p20.IsFriend then
            return p19.Player.DisplayName < p20.Player.DisplayName;
        end;

        return false;
    end);

    for i, v in ipairs(v18) do
        local Player = v.Player;
        local u21 = Save.Get(Player, true);

        if u21 then
            assert(u21, "luau");

            if Player ~= LocalPlayer then
                local IsFriend = v.IsFriend;
                local u22 = false;
                local u23 = u21.Settings.Trading ~= false;
                local u24 = TradingCmds.HasRequestFromPlayer(Player);
                local v25 = TradingCmds.HasOutgoingRequestToPlayer(Player);
                local u26 = Players2:FindFirstChild(Player.Name);

                if not u26 then
                    local v27 = Player:GetAttribute("Partner") and Player.DisplayName .. " (🔥 Partner)" or Player.DisplayName;
                    u26 = Assets.UI.Trading.PlayerList.Player:Clone();
                    u26.NameHolder.Username.Text = Player.Name;
                    u26.NameHolder.Display.Text = v27;
                    u26.Name = Player.Name;
                    u26:SetAttribute("Trader", true);
                    task.spawn(function() -- Line: 138
                        -- upvalues: u26 (copy), Functions (ref), Player (copy)
                        u26.Icon.Image = "";
                        u26.Icon.Image = Functions.GetThumbnailFromUserIdAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48) or "";
                    end);
                    u26.ButtonHolder.Trade.Activated:Connect(function() -- Line: 147
                        -- upvalues: u3 (ref), u23 (ref), u21 (copy), u22 (ref), u24 (ref), TradingCmds (ref), Player (copy), LocalPlayer (ref), u1 (ref), Message (ref)
                        u3(function() -- Line: 148
                            -- upvalues: u23 (ref), u21 (ref), u22 (ref), u24 (ref), TradingCmds (ref), Player (ref), LocalPlayer (ref), u1 (ref), Message (ref)
                            u23 = u21.Settings.Trading ~= false;
                            u22 = false;
                            u24 = TradingCmds.HasRequestFromPlayer(Player);

                            if u23 then
                                local success, result = pcall(function() -- Line: 154
                                    -- upvalues: LocalPlayer (ref), Player (ref)
                                    return LocalPlayer:IsFriendsWith(Player.UserId);
                                end);

                                if u22 and (success and not result) then
                                    return;
                                end;

                                local v28, v29 = TradingCmds.Request(Player);
                                u1:AtTrace():Log((`Trade request sent to {Player.Name}, success: {v28}, message: {v29}`));

                                if v28 and not u24 then
                                    Message.New("📩 Trade request sent!", {
                                        sound = "rbxassetid://93248914376991"
                                    });

                                    return;
                                end;

                                if not v28 then
                                    Message.New(v29 or "Failed to send trade request!");
                                end;
                            end;
                        end);
                    end);
                    u26.Parent = Players2;
                end;

                if u23 then
                    if u22 and not IsFriend then
                        p15:_cancelButtonFX(Player);
                        p15:_updateGradient(u26.ButtonHolder.Trade, GreyGradient);
                        u26.ButtonHolder.Trade.TextLabel.Text = "Friends Only";
                        u26.LayoutOrder = 998;
                    else
                        if not p15._cancelButtonCallbacks[Player.UserId] then
                            p15._cancelButtonCallbacks[Player.UserId] = ButtonFX(u26.ButtonHolder.Trade);
                        end;

                        if u24 then
                            p15:_updateGradient(u26.ButtonHolder.Trade, GreenGradient);
                            u26.ButtonHolder.Trade.TextLabel.Text = "Accept!";
                            u26.LayoutOrder = 1;
                        elseif v25 then
                            p15:_updateGradient(u26.ButtonHolder.Trade, GreenGradient, Color3.new(0.5, 0.5, 0.5));
                            u26.ButtonHolder.Trade.TextLabel.Text = "Pending";
                            u26.LayoutOrder = 2;
                        else
                            p15:_updateGradient(u26.ButtonHolder.Trade, GreenGradient);
                            u26.ButtonHolder.Trade.TextLabel.Text = "Trade!";
                            u26.LayoutOrder = i + 10;
                        end;
                    end;
                else
                    p15:_cancelButtonFX(Player);
                    p15:_updateGradient(u26.ButtonHolder.Trade, GreyGradient);
                    u26.ButtonHolder.Trade.TextLabel.Text = "Disabled";
                    u26.LayoutOrder = 999;
                end;

                u26.Icon.Friend.Visible = IsFriend;

                if v17 then
                    u26.Visible = string.find(string.lower(Player.Name), v16) ~= nil and true or string.find(string.lower(Player.DisplayName), v16) ~= nil;
                else
                    u26.Visible = true;
                end;

                if p15._friendsToggle and not IsFriend then
                    u26.Visible = false;
                end;
            end;
        end;
    end;

    Frame.NoneAvailable.Visible = #Players:GetPlayers() <= 1;

    for _, child in pairs(Players2:GetChildren()) do
        if child:GetAttribute("Trader") and not Players:FindFirstChild(child.Name) then
            child:Destroy();
        end;
    end;

    p15:_listScrolling();
end;

function u4._init(u30) -- Line: 243
    -- upvalues: Players2 (copy), ButtonFX (copy), Friends (copy), Tooltip (copy), Button (copy), TradingCmds (copy), Message (copy), TabController (copy), Players (copy), u2 (copy), RunService (copy)
    for _, child in pairs(Players2:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy();
        end;
    end;

    ButtonFX(Friends);
    Tooltip(Friends, "View Friends");
    ButtonFX(Button, nil, function() -- Line: 253
        -- upvalues: TradingCmds (ref), Message (ref), TabController (ref)
        local v31, v32 = TradingCmds.HasTradingUnlocked();

        if v31 then
            TabController.ToggleTab("TradePlayerList");

            return;
        end;

        Message.New(v32 or "Trading is locked.");
    end);
    Friends.Activated:Connect(function() -- Line: 263
        -- upvalues: u30 (copy)
        u30._friendsToggle = not u30._friendsToggle;
    end);
    TabController.AddOpenListener(function(p33, p34) -- Line: 267
        -- upvalues: u30 (copy)
        if p33 == "TradePlayerList" then
            u30:_update();
        end;
    end);
    Players.PlayerRemoving:Connect(function(p35) -- Line: 273
        -- upvalues: u30 (copy)
        u30._cancelButtonCallbacks[p35.UserId] = nil;
    end);
    task.spawn(function() -- Line: 277
        -- upvalues: u2 (ref), u30 (copy), RunService (ref)
        while true do
            if u2.Enabled then
                u30:_update();
            end;

            RunService.Heartbeat:Wait();
        end;
    end);
end;

return u4._build();