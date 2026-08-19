-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local SharedABTests = require(ReplicatedStorage.UserGenerated.ABTests.SharedABTests);
local DeepFreezeUnsafe = require(ReplicatedStorage.UserGenerated.Collections.DeepFreezeUnsafe);
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable);
local LocalPlayer = Players.LocalPlayer;
local u1 = false;
local u2 = Bindable.new();

local function IsLoaded() -- Line: 31
    -- upvalues: u1 (ref)
    return u1;
end;

local u3 = nil;

local function GetAssignmentsAsync(p4, p5) -- Line: 36
    -- upvalues: LocalPlayer (copy), u3 (ref)
    local v6;

    if typeof(p4) == "Instance" then
        v6 = p4:IsA("Player");
    else
        v6 = false;
    end;

    assert(v6);
    local v7 = type(p5) == "boolean";
    assert(v7);

    if p4 ~= LocalPlayer then
        return nil;
    end;

    local v8;

    while true do
        v8 = u3;

        if v8 then
            break;
        end;

        if not p5 then
            return nil;
        end;

        if not p4.Parent then
            return nil;
        end;

        task.wait();
    end;

    return v8;
end;

local u9 = nil;

local function GetAttributes(p10) -- Line: 58
    -- upvalues: LocalPlayer (copy), u9 (ref)
    if p10 == LocalPlayer then
        return u9;
    end;

    local v11;

    if typeof(p10) == "Instance" then
        v11 = p10:IsA("Player");
    else
        v11 = false;
    end;

    assert(v11);

    return nil;
end;

local function GetAttribute(p12, p13, p14) -- Line: 65
    -- upvalues: LocalPlayer (copy), u9 (ref)
    local v15 = type(p13) == "string";
    assert(v15);
    local v16;

    if p12 == LocalPlayer then
        v16 = u9;
    else
        local v17;

        if typeof(p12) == "Instance" then
            v17 = p12:IsA("Player");
        else
            v17 = false;
        end;

        assert(v17);
        v16 = nil;
    end;

    if v16 then
        v16 = v16[p13];
    end;

    if v16 == nil then
        return p14, false;
    end;

    return v16, true;
end;

local function GetAttributeAsync(p18, p19, p20) -- Line: 74
    -- upvalues: GetAssignmentsAsync (copy), GetAttribute (copy)
    local v21 = type(p19) == "string";
    assert(v21);

    if GetAssignmentsAsync(p18, true) then
        return GetAttribute(p18, p19, p20);
    end;

    return p20, false;
end;

local function GetJobAttributes() -- Line: 82
    -- upvalues: LocalPlayer (copy), u9 (ref)
    local v22 = LocalPlayer;

    if v22 == LocalPlayer then
        return u9;
    end;

    local v23;

    if typeof(v22) == "Instance" then
        v23 = v22:IsA("Player");
    else
        v23 = false;
    end;

    assert(v23);

    return nil;
end;

local function GetJobAssignments() -- Line: 91
    -- upvalues: u3 (ref)
    return u3;
end;

local u24 = Bindable.new();
local u25 = Bindable.new();
SharedABTests.UpdateRemote.OnClientEvent:Connect(function(p26, p27) -- Line: 102
    -- upvalues: DeepFreezeUnsafe (copy), u9 (ref), u3 (ref), u1 (ref), u2 (copy), u24 (copy), LocalPlayer (copy), u25 (copy)
    DeepFreezeUnsafe(p26);
    DeepFreezeUnsafe(p27);
    u9 = p26;
    u3 = p27;
    u1 = true;
    u2:Fire();
    u24:Fire(LocalPlayer);
    u25:Fire();
end);

return table.freeze({
    GetAttributes = GetAttributes,
    GetAttribute = GetAttribute,
    GetAttributeAsync = GetAttributeAsync,
    GetAssignmentsAsync = GetAssignmentsAsync,
    GetJobAttributes = GetJobAttributes,

    GetJobAttribute = function(p28, p29) -- Line: 85, Name: GetJobAttribute
        -- upvalues: GetAttribute (copy), LocalPlayer (copy)
        return GetAttribute(LocalPlayer, p28, p29);
    end,

    GetJobAttributeAsync = function(p30, p31) -- Line: 88, Name: GetJobAttributeAsync
        -- upvalues: GetAttributeAsync (copy), LocalPlayer (copy)
        return GetAttributeAsync(LocalPlayer, p30, p31);
    end,

    GetJobAssignments = GetJobAssignments,

    GetJobAssignmentsAsync = function(p32) -- Line: 94, Name: GetJobAssignmentsAsync
        -- upvalues: GetAssignmentsAsync (copy), LocalPlayer (copy)
        return GetAssignmentsAsync(LocalPlayer, p32);
    end,

    IsLoaded = IsLoaded,
    Loaded = u2,
    PlayerUpdated = u24,
    JobUpdated = u25
});