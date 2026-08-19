-- Decompiled with Potassium's decompiler.

local u1 = {};
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HttpService = game:GetService("HttpService");
local RunService = game:GetService("RunService");
local Workspace = game:GetService("Workspace");
require(script:WaitForChild("Types"));
local RemoveFromArray = require(ReplicatedStorage.Database.Components.Common.RemoveFromArray);
local u2 = require(ReplicatedStorage.Packages.Signal).new();
u1.OnCasesUpdated = u2;
local u3 = RunService:IsStudio();
local u4 = {};
local u5 = 0;

local function ParseUnixTimestamp(p6) -- Line: 37
    if p6 == nil then
        return nil;
    end;

    if typeof(p6) == "number" then
        if p6 > 10000000000 then
            return math.floor(p6 / 1000);
        end;

        return math.floor(p6);
    end;

    local v7 = tonumber(p6);

    if not v7 then
        return DateTime.fromIsoDate(p6).UnixTimestamp;
    end;

    if v7 > 10000000000 then
        return math.floor(v7 / 1000);
    end;

    return math.floor(v7);
end;

local function GetCurrentUnixTimestamp() -- Line: 63
    -- upvalues: Workspace (copy)
    local v8 = Workspace:GetServerTimeNow();

    return math.floor(v8);
end;

local function GetNextCaseBoundaryTimestamp() -- Line: 69
    -- upvalues: Workspace (copy), u4 (ref), ParseUnixTimestamp (copy)
    local v9 = Workspace:GetServerTimeNow();
    local v10 = math.floor(v9);
    local v11 = nil;

    for _, v in ipairs(u4) do
        local v12 = ParseUnixTimestamp(v.releaseDate);

        if not v12 or (v10 >= v12 or v11 ~= nil and v12 >= v11) then
            v12 = v11;
        end;

        v11 = ParseUnixTimestamp(v.discontinueDate);

        if not v11 or (v10 >= v11 or v12 ~= nil and v11 >= v12) then
            v11 = v12;
        end;
    end;

    return v11;
end;

local function ScheduleCasesUpdateAtNextBoundary() -- Line: 94
    -- upvalues: u3 (copy), u5 (ref), Workspace (copy), GetNextCaseBoundaryTimestamp (copy), u2 (copy), u4 (ref), ScheduleCasesUpdateAtNextBoundary (copy)
    if u3 then
        return;
    end;

    u5 = u5 + 1;
    local u13 = u5;
    local v14 = Workspace:GetServerTimeNow();
    local v15 = math.floor(v14);
    local v16 = GetNextCaseBoundaryTimestamp();

    if not v16 then
        return;
    end;

    local v17 = math.max(v16 - v15, 0);
    task.delay(v17, function() -- Line: 108
        -- upvalues: u13 (copy), u5 (ref), u2 (ref), u4 (ref), ScheduleCasesUpdateAtNextBoundary (ref)
        if u13 ~= u5 then
            return;
        end;

        if #u2:GetConnections() > 0 then
            u2:Fire(u4);
        end;

        ScheduleCasesUpdateAtNextBoundary();
    end);
end;

local function IsCaseEnabled(p18, p19) -- Line: 123
    -- upvalues: Workspace (copy), u3 (copy), ParseUnixTimestamp (copy)
    local v20 = Workspace:GetServerTimeNow();
    local v21 = math.floor(v20);

    if u3 and not p19 then
        return true;
    end;

    if p18.status == "inactive" or (p18.status == "discontinued" or not p18.isEnabled) then
        return false;
    end;

    if not (p18.releaseDate or p18.discontinueDate) then
        return true;
    end;

    if p18.releaseDate then
        local v22 = ParseUnixTimestamp(p18.releaseDate);

        if v22 and v21 < v22 then
            return false;
        end;
    end;

    if p18.discontinueDate then
        local v23 = ParseUnixTimestamp(p18.discontinueDate);

        if v23 and v23 <= v21 then
            return false;
        end;
    end;

    return true;
end;

local function UpdateAvailableCases(p24) -- Line: 157
    -- upvalues: u4 (ref), HttpService (copy), ScheduleCasesUpdateAtNextBoundary (copy), u2 (copy)
    u4 = HttpService:JSONDecode(p24);
    ScheduleCasesUpdateAtNextBoundary();

    if #u2:GetConnections() <= 0 then
        return;
    end;

    u2:Fire(u4);
end;

function u1.IsCaseEnabled(p25) -- Line: 170
    -- upvalues: u1 (copy), IsCaseEnabled (copy)
    local v26 = u1.GetCase(p25);

    if v26 then
        return IsCaseEnabled(v26);
    end;

    return false;
end;

function u1.IsCaseForSale(p27) -- Line: 182
    -- upvalues: u1 (copy), IsCaseEnabled (copy)
    local v28 = u1.GetCase(p27);

    if v28 then
        return IsCaseEnabled(v28, true);
    end;

    return false;
end;

function u1.GetCaseByName(p29) -- Line: 192
    -- upvalues: u4 (ref)
    if not u4 then
        return nil;
    end;

    for _, v in ipairs(u4) do
        if v.name == p29 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetCase(p30) -- Line: 206
    -- upvalues: u4 (ref)
    if not u4 then
        return nil;
    end;

    for _, v in ipairs(u4) do
        if v.caseId == p30 then
            return v;
        end;
    end;

    return nil;
end;

function u1.GetFeaturedCases(u31) -- Line: 220
    -- upvalues: u4 (ref), IsCaseEnabled (copy), RemoveFromArray (copy)
    local v32 = {};

    for _, v in ipairs(u4) do
        if v.isFeatured and IsCaseEnabled(v) then
            table.insert(v32, v);
        end;
    end;

    table.sort(v32, function(p33, p34) -- Line: 229
        return p33.displayOrder < p34.displayOrder;
    end);
    RemoveFromArray(v32, function(p35, p36) -- Line: 233
        -- upvalues: u31 (copy)
        return u31 < p35;
    end);

    return v32;
end;

function u1.GetCases() -- Line: 242
    -- upvalues: u4 (ref), IsCaseEnabled (copy)
    local v37 = {};

    for _, v in ipairs(u4) do
        if IsCaseEnabled(v) then
            table.insert(v37, v);
        end;
    end;

    table.sort(v37, function(p38, p39) -- Line: 251
        return p38.displayOrder < p39.displayOrder;
    end);

    return v37;
end;

function u1.ObserveAvailableCases(p40) -- Line: 260
    -- upvalues: u2 (copy), u4 (ref)
    local u41 = u2:Connect(p40);

    if u4 then
        p40(u4);
    end;

    return function() -- Line: 267
        -- upvalues: u41 (copy)
        u41:Disconnect();
    end;
end;

if ReplicatedStorage:GetAttribute("AvaiableCases") then
    u4 = HttpService:JSONDecode((ReplicatedStorage:GetAttribute("AvaiableCases")));
    ScheduleCasesUpdateAtNextBoundary();

    if #u2:GetConnections() > 0 then
        u2:Fire(u4);
    end;
end;

ReplicatedStorage:GetAttributeChangedSignal("AvaiableCases"):Connect(function() -- Line: 283
    -- upvalues: ReplicatedStorage (copy), u4 (ref), HttpService (copy), ScheduleCasesUpdateAtNextBoundary (copy), u2 (copy)
    local v42 = ReplicatedStorage:GetAttribute("AvaiableCases");

    if not v42 then
        return;
    end;

    u4 = HttpService:JSONDecode(v42);
    ScheduleCasesUpdateAtNextBoundary();

    if #u2:GetConnections() <= 0 then
        return;
    end;

    u2:Fire(u4);
end);

return u1;