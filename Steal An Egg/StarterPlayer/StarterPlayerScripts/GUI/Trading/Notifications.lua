-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local GUI = require(ReplicatedStorage.Library.Client.GUI);
local Functions = require(ReplicatedStorage.Library.Functions);
local Variables = require(ReplicatedStorage.Library.Variables);
local Signal = require(ReplicatedStorage.Library.Signal);
local TabController = require(ReplicatedStorage.Library.Client.TabController);
local TradingCmds = require(ReplicatedStorage.Library.Client.TradingCmds);
local FFlags = require(ReplicatedStorage.Library.Client.FFlags);
local Message = require(ReplicatedStorage.Library.Client.Message);
local ButtonFX = require(ReplicatedStorage.Library.Client.GUIFX.ButtonFX);
local Audio = require(ReplicatedStorage.Library.Audio);
local FuncWrapper = require(ReplicatedStorage.Library.Modules.FuncWrapper);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local LocalPlayer = game.Players.LocalPlayer;
local u2 = GUI.TradeMessage();
local Frame = u2:WaitForChild("Frame");
local Title = Frame.Message.Title;
local Buttons = Frame.Buttons;
local Yes = Buttons.Yes;
local No = Buttons.No;
local u3 = UDim2.new(0.5, 0, -0.2, 5);
local u4 = {};
u4.__index = u4;
u4.__class = "TradingNotifs";

function u4._build() -- Line: 57
    -- upvalues: u4 (copy), FuncWrapper (copy)
    local v5 = setmetatable({}, u4);
    v5._tradeQueue = {};
    v5._activeTrade = nil;
    v5._tradeResumeTime = nil;
    v5._funcWrapper = FuncWrapper.CreateWrapper(v5);
    v5:_init();

    return v5;
end;

function u4._getQueue(p6, p7) -- Line: 73
    for _, v in ipairs(p6._tradeQueue) do
        if v.player == p7 then
            return v;
        end;
    end;

    return nil;
end;

function u4.Remove(u8) -- Line: 82
    -- upvalues: u3 (copy), Functions (copy), Frame (copy), u2 (copy)
    if u8._activeTrade then
        u8._activeTrade.removing = true;
        Functions.Tween(Frame, {
            Position = u3
        }, { 0.35, "Quad", "Out" }).Completed:Connect(function() -- Line: 88
            -- upvalues: u2 (ref), u8 (copy)
            u2.Enabled = false;
            u8._activeTrade = nil;
        end);
    end;
end;

function u4.HasTradeNotif(p9) -- Line: 99
    return p9._activeTrade ~= nil and true or #p9._tradeQueue > 0;
end;

function u4._onTradeRequested(p10, p11, p12) -- Line: 104
    -- upvalues: LocalPlayer (copy), u1 (copy)
    local v13 = LocalPlayer;
    local v14;

    if p11 == v13 then
        v14 = p12 or p11;
    else
        v14 = p11;
    end;

    u1:AtTrace():Log(`Trade requested from {v14.Name} by {v13.Name}, self:`, p10);

    if p11 ~= v13 then
        if p10:_getQueue(v14) then
            return;
        end;

        table.insert(p10._tradeQueue, {
            duration = 10,
            created = nil,
            player = v14
        });
    end;
end;

function u4._onTradeAccepted(p15) -- Line: 124
    -- upvalues: u1 (copy), TradingCmds (copy), Variables (copy), TabController (copy), FFlags (copy), Message (copy)
    local v16 = u1:AtTrace();
    local v17 = p15._activeTrade and TradingCmds.HasRequestFromPlayer(p15._activeTrade.player);
    v16:Log(`Trade accept button pressed, HasRequestFromPlayer: {v17}, self:`, p15);

    if p15._activeTrade then
        if Variables.Console and TabController.Get() ~= nil then
            return;
        end;

        if TradingCmds.HasRequestFromPlayer(p15._activeTrade.player) then
            if FFlags.Get(FFlags.Keys.Trading) or FFlags.CanBypass() then
                local v18, v19 = TradingCmds.Request(p15._activeTrade.player);
                u1:AtTrace():Log((`Trade request sent to {p15._activeTrade.player.Name}, success: {v18}, errorMsg: {v19}`));

                if not v18 and v19 then
                    Message.New(v19, {
                        err = true
                    });
                end;

                p15:Remove();
            end;
        else
            Message.New("You no longer have a trade request from " .. p15._activeTrade.player.Name, {
                err = true
            });
            p15:Remove();
        end;
    end;
end;

function u4._onTradeRejected(p20) -- Line: 146
    -- upvalues: u1 (copy), TradingCmds (copy)
    local v21 = u1:AtTrace();
    local v22 = p20._activeTrade and TradingCmds.HasRequestFromPlayer(p20._activeTrade.player);
    v21:Log(`Trade reject button pressed, HasRequestFromPlayer: {v22}, self:`, p20);

    if p20._activeTrade then
        TradingCmds.Reject(p20._activeTrade.player);
        p20:Remove();
    end;
end;

function u4._update(u23) -- Line: 154
    -- upvalues: Signal (copy), Variables (copy), TradingCmds (copy), Frame (copy), u3 (copy), u2 (copy), Title (copy), Audio (copy), Functions (copy)
    if #u23._tradeQueue == 0 or (u23._activeTrade ~= nil or (Signal.Invoke("Notifications: Has Queue") or Variables.Trading)) then
        return;
    end;

    if u23._tradeResumeTime then
        local v24 = u23._tradeResumeTime - workspace:GetServerTimeNow();

        if math.abs(v24) < 0.5 then
            return;
        end;
    end;

    local player = u23._tradeQueue[1].player;

    if not TradingCmds.HasRequestFromPlayer(player) then
        table.remove(u23._tradeQueue, 1);

        return;
    end;

    u23._tradeResumeTime = workspace:GetServerTimeNow();
    Variables.HideProgressUI = true;
    local u25 = assert(u23._tradeQueue[1], "Trade queue is empty");
    u23._activeTrade = u25;
    table.remove(u23._tradeQueue, 1);
    u25.created = tick();
    Frame.Position = u3;
    u2.Enabled = true;
    Title.Text = "Trade from @" .. (player:GetAttribute("Partner") and u25.player.Name .. " (🔥 Partner)" or u25.player.Name);
    Audio.Play("rbxassetid://133842042346471", script, nil, 2);
    Functions.Tween(Frame, {
        Position = UDim2.new(0.5, 0, 0.05, 5)
    }, { 0.65, "Back", "Out" });
    task.delay(u25.duration, function() -- Line: 190
        -- upvalues: u25 (copy), u23 (copy)
        if not u25.removing then
            u23:Remove();
        end;
    end);
end;

function u4._init(p26) -- Line: 201
    -- upvalues: RunService (copy), GUI (copy), Yes (copy), No (copy), Signal (copy), TradingCmds (copy), ButtonFX (copy)
    RunService.RenderStepped:Connect(p26._funcWrapper(p26._update));
    GUI.ButtonActivated(Yes, p26._funcWrapper(p26._onTradeAccepted));
    GUI.ButtonActivated(No, p26._funcWrapper(p26._onTradeRejected));
    Signal.Invoked(Signal.MAP.Client.TradingNotifications.HAS_TRADE_NOTIF).OnInvoke = p26._funcWrapper(p26.HasTradeNotif);
    Signal.Fired(Signal.MAP.Client.TradingNotifications.FORCE_CLOSE_NOTIF):Connect(p26._funcWrapper(p26.Remove));
    TradingCmds.TradeRequested:Connect(p26._funcWrapper(p26._onTradeRequested));
    ButtonFX(Yes);
    ButtonFX(No);
end;

return u4._build();