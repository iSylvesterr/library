-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local DevAllowedIDs = require(ReplicatedStorage.SharedModules.DevAllowedIDs);
local Environment = require(ReplicatedStorage.SharedModules.Environment);
local ExplorerFlags = require(ReplicatedStorage.SharedModules.Flags.ExplorerFlags);
local u1 = {
    WorldId = "FallHarvest",
    ReleaseAtAttribute = "WorldReleaseAt",
    MenuFlagAttribute = "WorldReleaseMenuFlag",
    CloseAtAttribute = "WorldCloseAt"
};
local u2 = nil;

local function now() -- Line: 52
    -- upvalues: RunService (copy), u2 (ref), ReplicatedStorage (copy)
    if RunService:IsServer() then
        return os.time();
    end;

    if u2 == nil then
        u2 = require(ReplicatedStorage.ClientModules.ServerClock);
    end;

    return u2.Now();
end;

local function devTimestamp(p3) -- Line: 64
    -- upvalues: Environment (copy)
    if Environment.env ~= "Dev" then
        return nil;
    end;

    local v4 = workspace:GetAttribute(p3);

    if type(v4) == "number" and v4 > 0 then
        return v4;
    end;

    return nil;
end;

local function devOverrideAt() -- Line: 75
    -- upvalues: Environment (copy)
    if Environment.env ~= "Dev" then
        return nil;
    end;

    local v5 = workspace:GetAttribute("WorldReleaseAt");

    if type(v5) == "number" and v5 > 0 then
        return v5;
    end;

    return nil;
end;

function u1.IsGateActive() -- Line: 81
    -- upvalues: Environment (copy)
    if Environment.env == "Live" then
        return true;
    end;

    local v6;

    if Environment.env == "Dev" then
        v6 = workspace:GetAttribute("WorldReleaseAt");

        if type(v6) ~= "number" or v6 <= 0 then
            v6 = nil;
        end;
    else
        v6 = nil;
    end;

    return v6 ~= nil;
end;

function u1.ReleaseAt() -- Line: 89
    -- upvalues: Environment (copy), ExplorerFlags (copy)
    local v7;

    if Environment.env == "Dev" then
        v7 = workspace:GetAttribute("WorldReleaseAt");

        if type(v7) ~= "number" or v7 <= 0 then
            v7 = nil;
        end;
    else
        v7 = nil;
    end;

    return v7 or ExplorerFlags.ReleaseAtUnix:Get();
end;

function u1.IsOpen() -- Line: 94
    -- upvalues: u1 (copy), RunService (copy), u2 (ref), ReplicatedStorage (copy)
    if not u1.IsGateActive() then
        return true;
    end;

    local v8;

    if RunService:IsServer() then
        v8 = os.time();
    else
        if u2 == nil then
            u2 = require(ReplicatedStorage.ClientModules.ServerClock);
        end;

        v8 = u2.Now();
    end;

    return u1.ReleaseAt() <= v8;
end;

function u1.SecondsUntilOpen() -- Line: 102
    -- upvalues: u1 (copy), RunService (copy), u2 (ref), ReplicatedStorage (copy)
    if not u1.IsGateActive() then
        return 0;
    end;

    local v9 = u1.ReleaseAt();
    local v10;

    if RunService:IsServer() then
        v10 = os.time();
    else
        if u2 == nil then
            u2 = require(ReplicatedStorage.ClientModules.ServerClock);
        end;

        v10 = u2.Now();
    end;

    return math.max(0, v9 - v10);
end;

function u1.IsWorldOpen(p11) -- Line: 111
    -- upvalues: u1 (copy)
    return p11 ~= "FallHarvest" and true or u1.IsOpen();
end;

function u1.CloseAt() -- Line: 120
    -- upvalues: Environment (copy), u1 (copy), ExplorerFlags (copy)
    local v12;

    if Environment.env == "Dev" then
        v12 = workspace:GetAttribute("WorldCloseAt");

        if type(v12) ~= "number" or v12 <= 0 then
            v12 = nil;
        end;
    else
        v12 = nil;
    end;

    return v12 or u1.ReleaseAt() + ExplorerFlags.CloseAfterSeconds:Get();
end;

function u1.SecondsUntilClose() -- Line: 130
    -- upvalues: u1 (copy), RunService (copy), u2 (ref), ReplicatedStorage (copy)
    local v13 = u1.CloseAt();
    local v14;

    if RunService:IsServer() then
        v14 = os.time();
    else
        if u2 == nil then
            u2 = require(ReplicatedStorage.ClientModules.ServerClock);
        end;

        v14 = u2.Now();
    end;

    return math.max(0, v13 - v14);
end;

function u1.SecondsUntilWorldCloses(p15) -- Line: 140
    -- upvalues: u1 (copy)
    if p15 == "FallHarvest" then
        return u1.SecondsUntilClose();
    end;

    return nil;
end;

function u1.MenuFlagOn() -- Line: 151
    -- upvalues: Environment (copy), ExplorerFlags (copy)
    local v16;

    if Environment.env == "Dev" then
        v16 = workspace:GetAttribute("WorldReleaseAt");

        if type(v16) ~= "number" or v16 <= 0 then
            v16 = nil;
        end;
    else
        v16 = nil;
    end;

    if v16 == nil then
        return ExplorerFlags.TravelMenuEnabled:Get();
    end;

    local v17 = workspace:GetAttribute("WorldReleaseMenuFlag");

    return type(v17) ~= "boolean" and true or v17;
end;

function u1.IsEarlyAccess(p18) -- Line: 165
    -- upvalues: Environment (copy), DevAllowedIDs (copy)
    local v19;

    if Environment.env == "Live" then
        v19 = DevAllowedIDs.IsAllowed(p18);
    else
        v19 = false;
    end;

    return v19;
end;

function u1.MenuUnlocked(p20) -- Line: 174
    -- upvalues: u1 (copy)
    if not u1.IsGateActive() then
        return true;
    end;

    if p20 ~= nil and u1.IsEarlyAccess(p20) then
        return true;
    end;

    local v21 = u1.MenuFlagOn() and u1.IsOpen();

    return v21;
end;

return u1;