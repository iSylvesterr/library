-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Types = Library:WaitForChild("Types");
local Items = Library:WaitForChild("Items");
local Client = Library:WaitForChild("Client");
local Modules = Library:WaitForChild("Modules");
local Asserts = require(Library.Asserts);
local Functions = require(Library.Functions);
local CurrencyCmds = require(Library.Client.CurrencyCmds);
local Trading = require(Types.Trading);
local Types2 = require(Items.Types);
local Event = require(Modules.Event);
local Network = require(Client.Network);
local Save = require(Client.Save);
local FFlags = require(Client.FFlags);
local TradeState = require(script.TradeState);
local Trading2 = Network.NET_MAP.Trading;
local u1 = {};
local u2 = {};
local u3 = 0;

local function Requests(p4) -- Line: 24
    -- upvalues: u1 (copy)
    local v5 = u1[p4];

    if not v5 then
        v5 = {};
        u1[p4] = v5;
    end;

    return v5;
end;

local function getTradingUnlockMessage() -- Line: 33
    -- upvalues: Trading (copy)
    return ("You need to reach <font color=\"rgb(255, 225, 0)\">REBIRTH %d</font> to unlock trading!"):format(Trading.RequiredRebirth);
end;

local u8 = {
    TradeRequested = Event.new(),
    TradeRejected = Event.new(),
    TradeRequestsUpdated = Event.new(),
    TradeCreated = TradeState.TradeCreated,
    TradeSetReady = TradeState.TradeSetReady,
    TradeSetConfirmed = TradeState.TradeSetConfirmed,
    TradeSetItem = TradeState.TradeSetItem,
    TradeMessage = TradeState.TradeMessage,
    TradeExecuting = TradeState.TradeExecuting,
    TradeDestroyed = TradeState.TradeDestroyed,

    GetState = function(p6) -- Line: 124, Name: GetState
        -- upvalues: u2 (copy), u3 (ref)
        return u2[p6 or u3];
    end,

    GetAllRequests = function() -- Line: 128, Name: GetAllRequests
        -- upvalues: u1 (copy)
        return u1;
    end,

    GetRequestFromPlayer = function(p7) -- Line: 132, Name: GetRequestFromPlayer
        -- upvalues: u1 (copy)
        return u1[p7];
    end
};

function u8.HasRequestFromPlayer(p9) -- Line: 136
    -- upvalues: u8 (copy), Players (copy)
    local v10 = u8.GetRequestFromPlayer(p9);
    local v11;

    if v10 == nil then
        v11 = false;
    else
        v11 = v10[Players.LocalPlayer] ~= nil;
    end;

    return v11;
end;

function u8.GetOutgoingRequestToPlayer(p12) -- Line: 145
    -- upvalues: u1 (copy), Players (copy)
    local v13 = u1[Players.LocalPlayer];

    if v13 then
        return v13[p12];
    end;

    return nil;
end;

function u8.HasOutgoingRequestToPlayer(p14) -- Line: 154
    -- upvalues: u8 (copy)
    return u8.GetOutgoingRequestToPlayer(p14) ~= nil;
end;

function u8.HasTradingUnlocked(p15) -- Line: 158
    -- upvalues: Save (copy), Trading (copy), getTradingUnlockMessage (copy)
    local v16 = Save.Get(p15);

    if not v16 then
        return false, "Player is still Loading!";
    end;

    local v17 = typeof(v16.Rebirth) ~= "number" and 0 or v16.Rebirth;

    if Trading.HasRequiredRebirth(v17) then
        return true;
    end;

    return false, getTradingUnlockMessage();
end;

function u8.Request(p18) -- Line: 172
    -- upvalues: Players (copy), Asserts (copy), FFlags (copy), u8 (copy), Save (copy), Network (copy), Trading2 (copy)
    local LocalPlayer = Players.LocalPlayer;
    Asserts.Player(p18);
    assert(LocalPlayer ~= p18, "You cannot request a trade with yourself!");

    if not (FFlags.Get(FFlags.Keys.Trading) or FFlags.CanBypass()) then
        return false, "Sorry! This is disabled right now, try again soon!";
    end;

    local v19, v20 = u8.HasTradingUnlocked();

    if not v19 then
        return false, v20;
    end;

    if not Save.Get(p18) then
        return false, "Player is still loading!";
    end;

    if u8.HasTradingUnlocked(p18) then
        return Network.Invoke(Trading2.REQUEST, p18);
    end;

    return false, p18.Name .. " has not unlocked trading yet!";
end;

function u8.Reject(p21) -- Line: 198
    -- upvalues: Players (copy), Asserts (copy), Network (copy), Trading2 (copy)
    local LocalPlayer = Players.LocalPlayer;
    Asserts.Player(p21);
    assert(LocalPlayer ~= p21, "You cannot reject your own trade!");

    return Network.Invoke(Trading2.REJECT, p21);
end;

function u8.Decline() -- Line: 206
    -- upvalues: u8 (copy), Network (copy), Trading2 (copy)
    local v22 = u8.GetState();

    if v22 then
        return Network.Invoke(Trading2.DECLINE, v22._id);
    end;

    return false, "Trade not found!";
end;

function u8.SetReady(p23) -- Line: 215
    -- upvalues: u8 (copy), FFlags (copy), Network (copy), Trading2 (copy)
    local v24 = u8.GetState();

    if not v24 then
        return false, "Trade not found!";
    end;

    if FFlags.Get(FFlags.Keys.Trading) or FFlags.CanBypass() then
        return Network.Invoke(Trading2.SET_READY, v24._id, p23, v24._counter);
    end;

    return false, "Sorry! This is disabled right now, try again soon!";
end;

function u8.SetConfirmed(p25) -- Line: 226
    -- upvalues: u8 (copy), FFlags (copy), Network (copy), Trading2 (copy)
    local v26 = u8.GetState();

    if not v26 then
        return false, "Trade not found!";
    end;

    if FFlags.Get(FFlags.Keys.Trading) or FFlags.CanBypass() then
        return Network.Invoke(Trading2.SET_CONFIRMED, v26._id, p25, v26._counter);
    end;

    return false, "Sorry! This is disabled right now, try again soon!";
end;

function u8.SetItem(p27, p28, p29) -- Line: 237
    -- upvalues: u8 (copy), Trading (copy), FFlags (copy), Network (copy), Trading2 (copy)
    local v30 = u8.GetState();

    if not v30 then
        return false, "Trade not found!";
    end;

    if not Trading.IsTradableItemType(p27) then
        return false, "That trade item type is disabled.";
    end;

    if FFlags.Get(FFlags.Keys.Trading) or FFlags.CanBypass() then
        return Network.Invoke(Trading2.SET_ITEM, v30._id, p27, p28, p29);
    end;

    return false, "Sorry! This is disabled right now, try again soon!";
end;

function u8.Message(p31) -- Line: 250
    -- upvalues: Trading (copy), u8 (copy), Network (copy), Trading2 (copy)
    local v32 = type(p31) == "string";
    assert(v32, "Expected message to be a string!");

    if #p31 == 0 then
        return false, "Cannot send an empty message!";
    end;

    if Trading.MessageLimit < #p31 then
        return false, "Message is too long! Please keep it under " .. tostring(Trading.MessageLimit) .. " characters!";
    end;

    local v33 = u8.GetState();

    if v33 then
        return Network.Invoke(Trading2.MESSAGE, v33._id, p31);
    end;

    return false, "Trade not found!";
end;

function u8.SetCurrency(p34, p35) -- Line: 267
    -- upvalues: Trading (copy), CurrencyCmds (copy), FFlags (copy), u8 (copy)
    if not Trading.IsTradableItemType("Currency") then
        return false, "Currency trading is disabled.";
    end;

    local v36 = CurrencyCmds.GetItem(p34);

    if not v36 then
        return false, "You don\'t have any " .. p34 .. "!";
    end;

    if FFlags.Get(FFlags.Keys.Trading) or FFlags.CanBypass() then
        return u8.SetItem("Currency", v36:GetId(), p35);
    end;

    return false, "Sorry! This is disabled right now, try again soon!";
end;

function u8.GetTradeSettings(p37) -- Line: 282
    -- upvalues: Asserts (copy), Save (copy)
    Asserts.Player(p37);
    local v38 = Save.Get(p37);

    if v38 and (v38.Settings and v38.Settings.Trading) then
        return true, v38.Settings.Trading;
    end;

    return false;
end;

function u8.CanTrade(p39) -- Line: 292
    -- upvalues: FFlags (copy)
    if not (FFlags.Get(FFlags.Keys.Trading) or FFlags.CanBypass()) then
        return false, "Sorry! This is disabled right now, try again soon!";
    end;

    if p39:IsLocked() then
        return false, "Item is locked!";
    end;

    if p39:IsTradable() then
        return true;
    end;

    return false, "Item is not tradable!";
end;

function u8.DecodeItems(p40) -- Line: 304
    -- upvalues: Types2 (copy), Functions (copy)
    local v41 = {};

    for i, v in pairs(p40) do
        local v42 = Types2.TypeUnchecked(i);

        if v42 then
            for i2, v2 in pairs(v) do
                local v43 = v42:From(Functions.DeepCopyUnsafe(v2));
                v43:SetUID(i2);
                table.insert(v41, v43);
            end;
        end;
    end;

    return v41;
end;

Network.Fired(Trading2.SETTINGS_UPDATED):Connect(function(p44, p45) -- Line: 319
    -- upvalues: Asserts (copy), Save (copy)
    Asserts.nonNegativeInteger(p45);
    local v46;

    if p45 >= 1 then
        v46 = p45 <= 3;
    else
        v46 = false;
    end;

    local v47 = "Settings value must be between 1 and 3, got " .. tostring(p45);
    assert(v46, v47);
    local v48 = Save.Get(p44);

    if v48 and (v48.Settings and v48.Settings.Trading) then
        v48.Settings.Trading = p45;
    end;
end);
Network.Fired(Trading2.REQUESTED):Connect(function(p49, p50, p51) -- Line: 333
    -- upvalues: u1 (copy), u8 (copy)
    local v52 = u1[p49];

    if not v52 then
        v52 = {};
        u1[p49] = v52;
    end;

    v52[p50] = p51;
    u8.TradeRequested:FireAsync(p49, p50, p51);
end);
Network.Fired(Trading2.REJECTED):Connect(function(p53, p54, p55) -- Line: 338
    -- upvalues: u1 (copy), u8 (copy)
    local v56 = u1[p53];

    if not v56 then
        v56 = {};
        u1[p53] = v56;
    end;

    v56[p54] = nil;
    u8.TradeRejected:FireAsync(p53, p54, p55);
end);
Network.Fired(Trading2.CREATED):Connect(function(u57, p58, p59, p60) -- Line: 344
    -- upvalues: u2 (copy), u1 (copy), u8 (copy), TradeState (copy), u3 (ref)
    local v61 = not u2[u57];
    local v62 = "Trade with ID " .. tostring(u57) .. " already exists!";
    assert(v61, v62);
    local v63 = u1[p58];

    if v63 and v63[p59] then
        v63[p59] = nil;
    end;

    local v64 = u1[p59];

    if v64 and v64[p58] then
        v64[p58] = nil;
    end;

    u8.TradeRequestsUpdated:FireAsync();
    local v65 = TradeState.new(u57, p58, p59, p60, function() -- Line: 358
        -- upvalues: u2 (ref), u57 (copy), u3 (ref)
        u2[u57] = nil;

        if u3 == u57 then
            u3 = 0;
        end;
    end);
    u2[u57] = v65;
    u3 = u57;
    v65:Created();
end);
Network.Fired(Trading2.SET_READY_EVENT):Connect(function(p66, p67, p68, p69) -- Line: 371
    -- upvalues: u2 (copy)
    local v70 = u2[p66];

    if v70 then
        v70:SetReady(p67, p68, p69);
    end;
end);
Network.Fired(Trading2.SET_CONFIRMED_EVENT):Connect(function(p71, p72, p73, p74) -- Line: 379
    -- upvalues: u2 (copy)
    local v75 = u2[p71];

    if v75 then
        v75:SetConfirmed(p72, p73, p74);
    end;
end);
Network.Fired(Trading2.SET_ITEM_EVENT):Connect(function(p76, p77, p78, p79, p80, p81, p82) -- Line: 387
    -- upvalues: u2 (copy)
    local v83 = u2[p76];

    if v83 then
        v83:SetItem(p77, p78, p79, p80, p81, p82);
    end;
end);
Network.Fired(Trading2.MESSAGE_EVENT):Connect(function(p84, p85, p86) -- Line: 403
    -- upvalues: u2 (copy)
    local v87 = u2[p84];

    if v87 then
        v87:Message(p85, p86);
    end;
end);
Network.Fired(Trading2.EXECUTING):Connect(function(p88) -- Line: 410
    -- upvalues: u2 (copy)
    local v89 = u2[p88];

    if v89 then
        v89:Execute();
    end;
end);
Network.Fired(Trading2.DESTROYED):Connect(function(p90, p91) -- Line: 417
    -- upvalues: u2 (copy)
    local v92 = u2[p90];

    if v92 then
        u2[p90] = nil;
        v92:Destroy(p91);
    end;
end);
Network.Fired(Trading2.ADD_HISTORY):Connect(function(p93) -- Line: 425
    -- upvalues: Save (copy), Functions (copy), Trading (copy)
    local v94 = Save.Get();

    if v94 then
        Functions.InsertWithLimit(v94.TradeHistory, p93, Trading.HistoryLimit);
    end;
end);
Players.PlayerRemoving:Connect(function(p95) -- Line: 432
    -- upvalues: u1 (copy), u8 (copy)
    u1[p95] = nil;

    for _, v in pairs(u1) do
        v[p95] = nil;
    end;

    u8.TradeRequestsUpdated:FireAsync();
end);

return u8;