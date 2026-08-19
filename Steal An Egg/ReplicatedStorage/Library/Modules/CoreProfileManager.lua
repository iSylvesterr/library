-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Promise = require(ReplicatedStorage.Library.Modules.Packages.Promise);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local GenerateUID = require(ReplicatedStorage.Library.Functions.GenerateUID);
local u2 = {};
u2.__index = u2;
u2.ProfileRemoving = Signal.new();
u2.ProfileAdded = Signal.new();

function u2.is(p3) -- Line: 43
    -- upvalues: u2 (copy)
    local v4;

    if typeof(p3) == "table" then
        v4 = getmetatable(p3) == u2;
    else
        v4 = false;
    end;

    return v4;
end;

function u2.new(p5, p6) -- Line: 47
    -- upvalues: Asserts (copy), u2 (copy), GenerateUID (copy)
    Asserts.optional.func(p6);
    Asserts.optional.table(p5);
    local v7 = setmetatable({}, u2);
    v7._uuid = GenerateUID();
    v7._profileContainer = p5 or {};
    v7._keyParser = p6 or function(p8) -- Line: 56
        -- upvalues: Asserts (ref)
        Asserts.Player(p8);

        return p8.UserId;
    end;

    return v7;
end;

function u2._getValueAndKey(p9, p10) -- Line: 69
    local v11 = p9._keyParser(p10);
    local v12 = assert(v11, "Failed to parse key for player");

    return p9._profileContainer[v12], v12;
end;

function u2._safeChainForLoadEvent(u13, p14) -- Line: 76
    -- upvalues: Promise (copy), u2 (copy)
    local u15 = select(2, u13:_getValueAndKey(p14));

    local function matchKey(p16, p17, p18) -- Line: 83
        -- upvalues: u13 (copy), u15 (copy)
        local v19;

        if p16 == u13._uuid then
            v19 = p17 == u15;
        else
            v19 = false;
        end;

        return v19;
    end;

    return Promise.race({ Promise.fromEvent(u2.ProfileAdded, matchKey):andThen(function(p20, p21, p22) -- Line: 88
            return p22;
        end), Promise.fromEvent(u2.ProfileRemoving, matchKey):andThen(function() -- Line: 91
            -- upvalues: Promise (ref), u15 (copy)
            return Promise.reject((`Player: "{u15}", left before the profile was added.`));
        end) });
end;

function u2.Get(p23, p24) -- Line: 98
    -- upvalues: Promise (copy)
    local v25 = p23:_getValueAndKey(p24);

    if v25 == nil then
        return Promise.reject("Could not find the requested profile. Invalid lookup or get function"), false;
    end;

    return Promise.resolve(v25), true;
end;

function u2.GetAll(p26) -- Line: 108
    return table.clone(p26._profileContainer);
end;

function u2.GetAssert(p27, p28) -- Line: 112
    return p27:Get(p28):expect();
end;

function u2.GetAsync(p29, p30) -- Line: 116
    return p29:_getValueAndKey(p30) or p29:_safeChainForLoadEvent(p30):expect();
end;

function u2.IsProfileRegistered(p31, p32) -- Line: 125
    return p31:_getValueAndKey(p32) and true or false;
end;

function u2.Remove(p33, p34) -- Line: 129
    -- upvalues: u1 (copy), u2 (copy)
    local v35, v36 = p33:_getValueAndKey(p34);

    if v35 == nil then
        return false, u1:AtWarning():Log((`Attempt to remove an unloaded player from the profile stack: {v36}`));
    end;

    u2.ProfileRemoving:Fire(p33._uuid, v36, v35);
    p33._profileContainer[v36] = nil;

    return true;
end;

function u2.Set(p37, p38, ...) -- Line: 142
    -- upvalues: u2 (copy)
    local v39, v40 = p37:_getValueAndKey(p38);
    p37._profileContainer[v40] = ...;

    if v39 then
        return;
    end;

    u2.ProfileAdded:Fire(p37._uuid, v40, ...);
end;

return u2;