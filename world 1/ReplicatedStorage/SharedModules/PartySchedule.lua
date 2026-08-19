-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RunService = game:GetService("RunService");
local PartyFlags = require(ReplicatedStorage.SharedModules.Flags.PartyFlags);
local WorldEvents = require(ReplicatedStorage.SharedModules.WorldEvents);
local u1 = {
    StartAtAttribute = "AdminPartyStartsAt",
    MaxCountdownSeconds = 86400
};
local u2 = nil;

function u1.Now() -- Line: 42
    -- upvalues: RunService (copy), u2 (ref), ReplicatedStorage (copy)
    if RunService:IsServer() then
        return os.time();
    end;

    if u2 == nil then
        u2 = require(ReplicatedStorage.ClientModules.ServerClock);
    end;

    return u2.Now();
end;

local function overrideAt() -- Line: 53
    local v3 = workspace:GetAttribute("AdminPartyStartsAt");

    if type(v3) == "number" and v3 > 0 then
        return v3;
    end;

    return nil;
end;

function u1.StartsAt() -- Line: 63
    -- upvalues: WorldEvents (copy), PartyFlags (copy)
    if not WorldEvents.EnabledHere() then
        return nil;
    end;

    local v4 = workspace:GetAttribute("AdminPartyStartsAt");

    if type(v4) ~= "number" or v4 <= 0 then
        v4 = nil;
    end;

    if v4 then
        return v4;
    end;

    local v5 = PartyFlags.StartAtUnix:Get();

    if type(v5) == "number" and v5 > 0 then
        return v5;
    end;

    return nil;
end;

function u1.SecondsUntilStart() -- Line: 86
    -- upvalues: u1 (copy)
    local v6 = u1.StartsAt();

    if not v6 then
        return 0;
    end;

    local v7 = v6 - u1.Now();

    return math.max(0, v7);
end;

function u1.ShouldShowBanner() -- Line: 95
    -- upvalues: u1 (copy)
    local v8 = u1.SecondsUntilStart();
    local v9;

    if v8 > 0 then
        v9 = v8 <= 86400;
    else
        v9 = false;
    end;

    return v9;
end;

return u1;