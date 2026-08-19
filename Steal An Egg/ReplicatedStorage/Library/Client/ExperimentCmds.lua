-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Network = require(ReplicatedStorage.Library.Client.Network);
local Definitions = require(ReplicatedStorage.Library.Experiments.Definitions);
require(ReplicatedStorage.Library.Experiments.Types);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Experiments = Network.NET_MAP.Experiments;
local u1 = { 0.5, 1, 2, 4 };
local u2 = Log.new();
local u3 = Signal.new();
local u4 = {
    Revision = 0,
    Assignments = {}
};
local u5 = "Unresolved";
local u6 = nil;
local u7 = 0;
local u8 = nil;
local u9 = {};

local function decodeSource(p10) -- Line: 47
    if p10 == "ConfigService" or (p10 == "Fallback" or p10 == "TestingOverride") then
        return p10;
    end;

    return nil;
end;

local function decodeAssignments(p11) -- Line: 55
    -- upvalues: Definitions (copy)
    if typeof(p11) ~= "table" then
        return {};
    end;

    local v12 = {};

    for i, v in pairs(p11) do
        if typeof(i) == "string" then
            local v13 = Definitions.Directory[i];

            if v13 ~= nil and typeof(v) == "table" then
                local Variant = v.Variant;
                local Source = v.Source;

                if Source ~= "ConfigService" and (Source ~= "Fallback" and Source ~= "TestingOverride") then
                    Source = nil;
                end;

                if typeof(Variant) == "string" and (Source ~= nil and v13.PayloadByVariant[Variant] ~= nil) then
                    v12[i] = {
                        Variant = Variant,
                        Source = Source
                    };
                end;
            end;
        end;
    end;

    return v12;
end;

local function updateState(p14, p15, p16) -- Line: 92
    -- upvalues: u4 (ref), u5 (ref), u6 (ref), u3 (copy)
    local v17 = (u4.Revision ~= p14.Revision or u5 ~= p15) and true or u6 ~= p16;
    u4 = p14;
    u5 = p15;
    u6 = p16;

    if v17 then
        u3:Fire();
    end;
end;

local function applyState(p18) -- Line: 106
    -- upvalues: u2 (copy), u4 (ref), decodeAssignments (copy), u5 (ref), u6 (ref), u3 (copy)
    if typeof(p18) ~= "table" then
        u2:AtWarning():Log("[ExperimentCmds] Invalid experiment state payload", {
            PayloadType = typeof(p18)
        });

        return false;
    end;

    local Revision = p18.Revision;

    if typeof(Revision) ~= "number" then
        u2:AtWarning():Log("[ExperimentCmds] Missing experiment state revision", p18);

        return false;
    end;

    if Revision < u4.Revision then
        return true;
    end;

    local v19 = {
        Revision = Revision,
        Assignments = decodeAssignments(p18.Assignments)
    };
    local v20 = (u4.Revision ~= v19.Revision or u5 ~= "Resolved") and true or u6 ~= nil;
    u4 = v19;
    u5 = "Resolved";
    u6 = nil;

    if v20 then
        u3:Fire();
    end;

    return true;
end;

local function getDefinition(p21) -- Line: 132
    -- upvalues: Definitions (copy)
    return Definitions.GetDefinition(p21);
end;

local function hasResolvedState() -- Line: 136
    -- upvalues: u5 (ref)
    return u5 == "Resolved";
end;

local function scheduleRetryAfterFailure(u22) -- Line: 140
    -- upvalues: u7 (ref), u5 (ref), u2 (copy), u6 (ref), u8 (ref)
    task.delay(10, function() -- Line: 141
        -- upvalues: u22 (copy), u7 (ref), u5 (ref), u2 (ref), u6 (ref), u8 (ref)
        if u22 ~= u7 then
            return;
        end;

        if u5 ~= "ResolveFailed" or u5 == "Resolved" then
            return;
        end;

        u2:AtInfo():Log("[ExperimentCmds] Retrying experiment resolve after failure", {
            ResolveRequestId = u22,
            LastResolveError = u6
        });
        u8();
    end);
end;

local function cloneAssignments(p23) -- Line: 158
    local v24 = {};

    for i, v in pairs(p23) do
        v24[i] = {
            Variant = v.Variant,
            Source = v.Source
        };
    end;

    return v24;
end;

local function requestInitialState(u25) -- Line: 169
    -- upvalues: u1 (copy), u7 (ref), u5 (ref), u4 (ref), u6 (ref), u3 (copy), Network (copy), Experiments (copy), applyState (copy), u2 (copy), u8 (ref)
    local v26 = nil;

    for i, v in ipairs(u1) do
        if u25 ~= u7 or u5 == "Resolved" then
            return;
        end;

        local v27 = u4;
        local v28 = (u4.Revision ~= v27.Revision or u5 ~= "Resolving") and true or u6 ~= v26;
        u4 = v27;
        u5 = "Resolving";
        u6 = v26;

        if v28 then
            u3:Fire();
        end;

        local success, result = pcall(function() -- Line: 179
            -- upvalues: Network (ref), Experiments (ref)
            return Network.Invoke(Experiments.GET);
        end);

        if u25 ~= u7 or u5 == "Resolved" then
            return;
        end;

        if success and applyState(result) then
            return;
        end;

        v26 = success and "Invalid experiment state payload" or tostring(result);
        u2:AtWarning():Log("[ExperimentCmds] Failed to fetch initial experiment state", {
            Attempt = i,
            Error = v26
        });

        if i < #u1 then
            task.wait(v);
        end;
    end;

    if u25 ~= u7 or u5 == "Resolved" then
        return;
    end;

    local v29 = u4;
    local v30 = (u4.Revision ~= v29.Revision or u5 ~= "ResolveFailed") and true or u6 ~= v26;
    u4 = v29;
    u5 = "ResolveFailed";
    u6 = v26;

    if v30 then
        u3:Fire();
    end;

    task.delay(10, function() -- Line: 141
        -- upvalues: u25 (copy), u7 (ref), u5 (ref), u2 (ref), u6 (ref), u8 (ref)
        if u25 ~= u7 then
            return;
        end;

        if u5 ~= "ResolveFailed" or u5 == "Resolved" then
            return;
        end;

        u2:AtInfo():Log("[ExperimentCmds] Retrying experiment resolve after failure", {
            ResolveRequestId = u25,
            LastResolveError = u6
        });
        u8();
    end);
end;

u8 = function() -- Line: 210
    -- upvalues: u7 (ref), requestInitialState (copy)
    u7 = u7 + 1;
    local u31 = u7;
    task.spawn(function() -- Line: 213
        -- upvalues: requestInitialState (ref), u31 (copy)
        requestInitialState(u31);
    end);
end;

Network.Fired(Experiments.UPDATE):Connect(function(p32) -- Line: 218
    -- upvalues: applyState (copy)
    applyState(p32);
end);
u8();
u9.Changed = u3;

function u9.HasResolved() -- Line: 226
    -- upvalues: u5 (ref)
    return u5 == "Resolved";
end;

function u9.GetStatus() -- Line: 230
    -- upvalues: u5 (ref)
    return u5;
end;

function u9.GetLastResolveError() -- Line: 234
    -- upvalues: u6 (ref)
    return u6;
end;

function u9.RetryResolve() -- Line: 238
    -- upvalues: u8 (ref)
    u8();
end;

function u9.TryGetVariant(p33) -- Line: 242
    -- upvalues: Asserts (copy), u4 (ref), u5 (ref), Definitions (copy)
    Asserts.string(p33);
    local v34 = u4.Assignments[p33];

    return v34 == nil and (u5 == "Resolved" and {
        Status = "Resolved",
        Source = "Fallback",
        Variant = Definitions.GetDefinition(p33).DefaultVariant
    } or {
        Variant = nil,
        Source = nil,
        Status = u5
    }) or {
        Status = "Resolved",
        Variant = v34.Variant,
        Source = v34.Source
    };
end;

function u9.GetVariant(p35) -- Line: 269
    -- upvalues: u9 (copy)
    local v36 = u9.TryGetVariant(p35);

    if v36.Status == "Resolved" then
        return v36.Variant;
    end;

    return nil;
end;

function u9.IsVariant(p37, p38) -- Line: 278
    -- upvalues: Asserts (copy), u9 (copy)
    Asserts.string(p37);
    Asserts.string(p38);
    local v39 = u9.TryGetVariant(p37);
    local v40;

    if v39.Status == "Resolved" then
        v40 = v39.Variant == p38;
    else
        v40 = false;
    end;

    return v40;
end;

function u9.GetPayload(p41) -- Line: 286
    -- upvalues: Asserts (copy), u9 (copy), Definitions (copy)
    Asserts.string(p41);
    local v42 = u9.TryGetVariant(p41);

    if v42.Status ~= "Resolved" or v42.Variant == nil then
        return nil;
    end;

    local v43 = Definitions.GetDefinition(p41);

    return table.clone(v43.PayloadByVariant[v42.Variant]);
end;

function u9.GetDebugAssignments() -- Line: 298
    -- upvalues: cloneAssignments (copy), u4 (ref)
    return cloneAssignments(u4.Assignments);
end;

function u9.ShouldShowFakeTutorialUI() -- Line: 302
    -- upvalues: u9 (copy), Definitions (copy)
    local v44 = u9.GetPayload(Definitions.Ids.FakeTutorialMatchOnboarding);

    if v44 == nil then
        return nil;
    end;

    return v44.RouteToFakeTutorial == true;
end;

return u9;