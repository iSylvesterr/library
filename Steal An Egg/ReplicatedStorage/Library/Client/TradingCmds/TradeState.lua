-- Decompiled with Potassium's decompiler.

local Library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Modules = Library:WaitForChild("Modules");
local Asserts = require(Library.Asserts);
local Types = require(Items.Types);
local Event = require(Modules.Event);
local u1 = {};
u1.__index = u1;
u1.TradeCreated = Event.new();
u1.TradeSetReady = Event.new();
u1.TradeSetConfirmed = Event.new();
u1.TradeSetItem = Event.new();
u1.TradeMessage = Event.new();
u1.TradeExecuting = Event.new();
u1.TradeDestroyed = Event.new();

function u1.new(p2, p3, p4, p5, p6) -- Line: 43
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.Player(p3);
    Asserts.Player(p4);

    return setmetatable({
        _destroyed = false,
        _executing = false,
        _counter = 1,
        _destroyCallback = p6,
        _id = p2,
        _players = { p3, p4 },
        _ready = { false, false },
        _confirmed = { false, false },
        _items = { {}, {} },
        _lastModified = p5
    }, u1);
end;

function u1.Created(p7) -- Line: 70
    -- upvalues: u1 (copy)
    u1.TradeCreated:FireAsync(p7._id, p7:Player1(1), p7:Player1(2), p7._lastModified);
end;

function u1.PlayerIndex(p8, p9) -- Line: 74
    return table.find(p8._players, p9);
end;

function u1.Index1(p10, p11) -- Line: 78
    return p11;
end;

function u1.Index2(p12, p13) -- Line: 82
    return 3 - p13;
end;

function u1.Player1(p14, p15) -- Line: 86
    return p14._players[p15];
end;

function u1.Player2(p16, p17) -- Line: 90
    return p16._players[3 - p17];
end;

function u1.SetReady(p18, p19, p20, p21) -- Line: 94
    -- upvalues: u1 (copy)
    if p18._destroyed then
        return;
    end;

    p18._ready[p19] = p20;
    p18._readyTimer = p21;
    u1.TradeSetReady:FireAsync(p18._id, p19, p20);
end;

function u1.SetConfirmed(p22, p23, p24, p25) -- Line: 105
    -- upvalues: u1 (copy)
    if p22._destroyed then
        return;
    end;

    p22._confirmed[p23] = p24;
    p22._confirmedTimer = p25;
    u1.TradeSetConfirmed:FireAsync(p22._id, p23, p24);
end;

function u1.SetItem(p26, p27, p28, p29, p30, p31, p32) -- Line: 122
    -- upvalues: Types (copy), u1 (copy)
    local v33 = p26._items[p27];
    local v34 = v33[p28];

    if not v34 then
        v34 = {};
        v33[p28] = v34;
    end;

    local v35;

    if p30 then
        v35 = Types.From(p28, p30):Clone();

        if p30._uid then
            v35:SetUID(p30._uid);
        end;

        v35:Freeze();
    else
        v35 = nil;
    end;

    v34[p29] = v35;
    p26._counter = p31;
    p26._lastModified = p32;
    u1.TradeSetItem:FireAsync(p26._id, p27, p28, p29, v35, p31, p32);
end;

function u1.Message(p36, p37, p38) -- Line: 157
    -- upvalues: u1 (copy)
    u1.TradeMessage:FireAsync(p36._id, p37, p38);
end;

function u1.Execute(p39) -- Line: 162
    -- upvalues: u1 (copy)
    if p39._destroyed then
        return;
    end;

    if p39._executing then
        return;
    end;

    p39._executing = true;
    u1.TradeExecuting:FireAsync(p39._id);
end;

function u1.IsEveryoneReady(p40) -- Line: 174
    for _, v in ipairs(p40._ready) do
        if not v then
            return false;
        end;
    end;

    return true;
end;

function u1.Destroy(p41, p42) -- Line: 183
    -- upvalues: u1 (copy)
    if p41._destroyed then
        return false;
    end;

    p41._destroyed = true;
    u1.TradeDestroyed:FireAsync(p41._id, p42);
    p41._destroyCallback();

    return true;
end;

return u1;