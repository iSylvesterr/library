-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Players = game:GetService("Players");
local Library = ReplicatedStorage:WaitForChild("Library");
local Items = Library:WaitForChild("Items");
local Client = Library:WaitForChild("Client");
local Asserts = require(Library.Asserts);
local Signal = require(Library.Signal);
local AbstractItem = require(Items.AbstractItem);
local InventoryProjection = require(Items.InventoryProjection);
local Save = require(Client.Save);
local Network = require(Client.Network);
local DevRAPCmds = require(Client.DevRAPCmds);
local ClientPlayerState = require(script.ClientPlayerState);
local v1 = {
    PlayerState = ClientPlayerState
};
local u2 = {};

local function State(p3) -- Line: 43
    -- upvalues: Asserts (copy), Players (copy), u2 (copy), Save (copy), ClientPlayerState (copy)
    if p3 == nil then
        p3 = Players.LocalPlayer;
    else
        Asserts.Player(p3);

        if p3 ~= Players.LocalPlayer then
            return nil;
        end;
    end;

    assert(p3, "luau");
    local v4 = u2[p3.UserId];

    if v4 then
        return v4;
    end;

    local v5 = Save.Get(p3);

    if not v5 then
        return nil;
    end;

    local v6 = ClientPlayerState.new(p3, v5);

    if u2[p3.UserId] then
        return u2[p3.UserId];
    end;

    u2[p3.UserId] = v6;

    return v6;
end;

local function DestroyState(p7, p8) -- Line: 84
    -- upvalues: u2 (copy)
    local v9 = u2[p7];

    if v9 and (not p8 or v9.player == p8) then
        u2[p7] = nil;
        v9:Destroy();
    end;
end;

local function applyInventoryPatchPacket(p10, p11) -- Line: 92
    -- upvalues: InventoryProjection (copy), State (copy)
    if typeof(p11) ~= "table" or p11.__patch ~= true then
        return;
    end;

    local v12 = InventoryProjection.BuildInventoryPatchPacket(p11.Set, p11.Remove);

    if not v12 then
        return;
    end;

    local v13 = State(p10);

    if not v13 then
        return;
    end;

    v13.container:ApplyPacket(v12);
end;

v1.State = State;

function v1.Container(p14) -- Line: 118
    -- upvalues: State (copy)
    local v15 = State(p14);

    if v15 then
        v15 = v15.container;
    end;

    return v15;
end;

function AbstractItem.Prototype.CollectExact(p16, p17) -- Line: 131
    -- upvalues: State (copy)
    local v18 = State(p17);

    if v18 then
        v18 = v18.container:CollectExact(p16);
    end;

    return v18;
end;

function AbstractItem.Prototype.CollectAny(p19, p20) -- Line: 142
    -- upvalues: State (copy)
    local v21 = State(p20);

    if v21 then
        v21 = v21.container:CollectAny(p19);
    end;

    return v21;
end;

function AbstractItem.Prototype.HasExact(p22, p23) -- Line: 153
    -- upvalues: State (copy)
    local v24 = State(p23);

    if v24 then
        v24 = v24.container:HasExact(p22);
    end;

    return v24;
end;

function AbstractItem.Prototype.HasAny(p25, p26) -- Line: 164
    -- upvalues: State (copy)
    local v27 = State(p26);

    if v27 then
        v27 = v27.container:HasAny(p25);
    end;

    return v27;
end;

function AbstractItem.Prototype.CountExact(p28, p29) -- Line: 175
    -- upvalues: State (copy)
    local v30 = State(p29);

    return v30 and v30.container:CountExact(p28) or 0;
end;

function AbstractItem.Prototype.CountAny(p31, p32) -- Line: 186
    -- upvalues: State (copy)
    local v33 = State(p32);

    return v33 and v33.container:CountAny(p31) or 0;
end;

function AbstractItem.Prototype.FindExact(p34, p35) -- Line: 197
    -- upvalues: State (copy)
    local v36 = State(p35);

    return v36 and v36.container:FindExact(p34) or {};
end;

function AbstractItem.Prototype.FindAny(p37, p38) -- Line: 208
    -- upvalues: State (copy)
    local v39 = State(p38);

    return v39 and v39.container:FindAny(p37) or {};
end;

function AbstractItem.Prototype.GetRAP(p40) -- Line: 218
    return 1;
end;

function AbstractItem.Prototype.GetDevRAP(p41) -- Line: 227
    -- upvalues: DevRAPCmds (copy)
    return DevRAPCmds.Get(p41);
end;

function AbstractItem.Globals.Find(p42, p43) -- Line: 239
    -- upvalues: u2 (copy)
    for _, v in pairs(u2) do
        local v44 = v.container:Get(p43, p42);

        if v44 then
            return v44, v.player;
        end;
    end;

    return nil, nil;
end;

function AbstractItem.Globals.Get(p45, p46, p47) -- Line: 256
    -- upvalues: State (copy)
    local v48 = State(p47);

    if v48 then
        v48 = v48.container:Get(p46, p45);
    end;

    return v48;
end;

function AbstractItem.Globals.All(p49, p50) -- Line: 267
    -- upvalues: State (copy)
    local v51 = State(p50);

    return v51 and v51.container:All(p49) or {};
end;

function AbstractItem.Globals.Each(p52, p53, p54, ...) -- Line: 280
    -- upvalues: State (copy)
    local v55 = State(p54);

    if v55 then
        return v55.container:Each(p52, p53, ...);
    end;
end;

Signal.Fired("Loaded Stats"):Connect(function(p56) -- Line: 289
    -- upvalues: State (copy)
    State(p56);
end);
Signal.Fired("Loaded Other Stats"):Connect(function(p57) -- Line: 293
    -- upvalues: State (copy)
    State(p57);
end);
Signal.Fired("Stats Removed"):Connect(function(p58, p59) -- Line: 297
    -- upvalues: u2 (copy)
    local v60 = u2[p59];

    if v60 and (not p58 or v60.player == p58) then
        u2[p59] = nil;
        v60:Destroy();
    end;
end);
Network.Fired("Items: Update"):Connect(function(p61, p62, p63) -- Line: 302
    -- upvalues: State (copy)
    local v64 = State(p61);

    if not v64 then
        return;
    end;

    v64.container:ApplyPacket(p62);
end);
Save.GetStatChangedSignal("Inventory"):Connect(function(p65, p66, p67) -- Line: 315
    -- upvalues: Players (copy), InventoryProjection (copy), State (copy)
    local LocalPlayer = Players.LocalPlayer;

    if typeof(p67) == "table" then
        if p67.__patch ~= true then
            return;
        end;

        local v68 = InventoryProjection.BuildInventoryPatchPacket(p67.Set, p67.Remove);

        if not v68 then
            return;
        end;

        local v69 = State(LocalPlayer);

        if not v69 then
            return;
        end;

        v69.container:ApplyPacket(v68);
    end;
end);

return v1;