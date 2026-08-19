-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
game:GetService("Players");
assert(RunService:IsClient());
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable);
local SharedFastFlags = require(ReplicatedStorage.UserGenerated.FastFlags.SharedFastFlags);
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts);
local DeepEqualsPureUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepEqualsPureUnsafe);
local DeepCopyPureUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepCopyPureUnsafe);
local DeepFreezeUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepFreezeUnsafe);
local ObjectPaths = require(ReplicatedStorage.UserGenerated.Strings.ObjectPaths);
local v1 = {};
local u2 = table.freeze({
    __index = v1
});

function v1.Get(p3) -- Line: 48
    return p3.Value;
end;

function v1.GetAsync(p4) -- Line: 51
    if p4.ValueLoaded then
        return p4.Value;
    end;

    local u5 = coroutine.running();
    local v6 = p4.Loaded:Connect(function() -- Line: 56
        -- upvalues: u5 (copy)
        task.spawn(u5);
    end);
    coroutine.yield();
    v6:Disconnect();

    return p4.Value;
end;

function v1.IsLoaded(p7) -- Line: 63
    return p7.ValueLoaded;
end;

table.freeze(v1);
local NullValue = SharedFastFlags.NullValue;
local UpdateRemote = SharedFastFlags.UpdateRemote;
local u8 = {};
local u9 = false;
local u10 = {};
local u11 = Bindable.new();

local function DecodeValue(p12) -- Line: 89
    -- upvalues: NullValue (copy)
    if p12 == NullValue then
        return nil;
    end;

    return p12;
end;

local function Create(p13, p14, p15) -- Line: 141
    -- upvalues: Asserts (copy), DeepCopyPureUnsafe (copy), DeepFreezeUnsafe (copy), u8 (copy), ObjectPaths (copy), u10 (ref), NullValue (copy), u9 (ref), Bindable (copy), u2 (copy)
    Asserts.String(p13);
    Asserts.Function(p14);
    p14(p15);
    Asserts.Storable(p15);
    local v16 = DeepCopyPureUnsafe(p15);
    DeepFreezeUnsafe(v16);
    local v17 = not u8[p13];
    local v18 = `ConflictingKeys: {p13}, {p13}`;
    assert(v17, v18);

    for i, _ in pairs(u8) do
        if ObjectPaths.HasHierarchicalOverlap(p13, i) then
            error((`ConflictingKeys: {p13}, {i}`));
        end;
    end;

    local v19 = u10[p13];
    local v20;

    if v19 == nil then
        v19 = v16;
        v20 = false;
    else
        if v19 == NullValue then
            v19 = nil;
        end;

        v20 = u9;
    end;

    local v21 = {
        Replicated = true,
        Changed = Bindable.new(),
        Loaded = Bindable.new(),
        Key = p13,
        DefaultValue = v16,
        Assertion = p14,
        ValueLoaded = v20,
        Value = v19
    };
    local v22 = setmetatable(v21, u2);
    u8[p13] = v22;

    return v22;
end;

local v35 = {
    Loaded = u11,

    IsA = function(p23) -- Line: 67, Name: IsA
        -- upvalues: u2 (copy)
        local v24;

        if type(p23) == "table" then
            v24 = getmetatable(p23) == u2;
        else
            v24 = false;
        end;

        return v24;
    end,

    Assert = function(p25) -- Line: 71, Name: Assert
        -- upvalues: u2 (copy)
        local v26;

        if type(p25) == "table" then
            v26 = getmetatable(p25) == u2;
        else
            v26 = false;
        end;

        if not v26 then
            error("FastFlag", 2);
        end;

        return p25;
    end,

    Replicated = function(p27, p28, p29) -- Line: 197, Name: Replicated
        -- upvalues: Create (copy)
        return Create(p27, p28, p29);
    end,

    Private = function(p30, p31, p32) -- Line: 205, Name: Private
        error("ServerOnly");
    end,

    Get = function(p33) -- Line: 213, Name: Get
        -- upvalues: u8 (copy), Asserts (copy)
        local v34 = u8[p33];

        if v34 then
            return v34;
        end;

        Asserts.String(p33);
        error((`UnknownKey: '{p33}'`));
    end,

    IsLoaded = function() -- Line: 224, Name: IsLoaded
        -- upvalues: u9 (ref)
        return u9;
    end
};
UpdateRemote.OnClientEvent:Connect(function(p36, p37) -- Line: 93, Name: SetContent
    -- upvalues: DeepFreezeUnsafe (copy), u10 (ref), u8 (copy), NullValue (copy), DeepEqualsPureUnsafe (copy), u9 (ref), u11 (copy)
    DeepFreezeUnsafe(p36);
    u10 = p36;
    local v38 = {};
    local v39 = {};

    for i, v in pairs(p36) do
        local v40 = u8[i];

        if v40 then
            if v == NullValue then
                local v = nil;
            end;

            local Value = v40.Value;

            if not DeepEqualsPureUnsafe(v, Value) then
                v40.Value = v;
                table.insert(v38, {
                    instance = v40,
                    value = v,
                    prevValue = Value
                });
            end;

            if p37 and not v40.ValueLoaded then
                v40.ValueLoaded = true;
                table.insert(v39, v40);
            end;
        end;
    end;

    if p37 then
        p37 = not u9;
    end;

    if p37 then
        u9 = true;
    end;

    for _, v in ipairs(v39) do
        v.Loaded:Fire();
    end;

    if p37 then
        u11:Fire();
    end;

    for _, v in ipairs(v38) do
        v.instance.Changed:Fire(v.value, v.prevValue);
    end;
end);
table.freeze(v35);

return v35;