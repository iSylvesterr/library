-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Log = require(ReplicatedStorage.Library.Modules.Packages.Log);
require(script.Types.Interface);
local u1 = {};
u1.__index = u1;
u1.__class = "RenderBudget";
local u2 = Log.new();

function u1.new(p3) -- Line: 47
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.optional.table(p3);
    local v4 = not (p3 and p3.MaxJobsPerStep) and 4 or p3.MaxJobsPerStep;
    local v5 = not (p3 and p3.MaxStepTime) and 0.004166666666666667 or p3.MaxStepTime;
    local v6 = not (p3 and p3.StepInterval) and 0.016666666666666666 or p3.StepInterval;
    local v7;

    if p3 then
        v7 = p3.TargetSpreadSeconds;
    else
        v7 = nil;
    end;

    local v8 = not (p3 and p3.SpreadMinJobs) and 2 or p3.SpreadMinJobs;
    local v9 = not (p3 and p3.Name) and "RenderBudget" or p3.Name;
    Asserts.string(v9);
    Asserts.positiveInteger(v4);
    Asserts.number(v5);
    Asserts.number(v6);
    Asserts.positiveInteger(v8);
    Asserts.optional.number(v7);
    assert(v5 > 0, "RenderBudget MaxStepTime must be greater than 0");
    assert(v6 > 0, "RenderBudget StepInterval must be greater than 0");
    assert(v7 == nil and true or v7 > 0, "RenderBudget TargetSpreadSeconds must be greater than 0");
    local v10 = setmetatable({}, u1);
    v10._name = v9;
    v10._maxJobsPerStep = v4;
    v10._maxStepTime = v5;
    v10._stepInterval = v6;
    v10._targetSpreadSeconds = v7;
    v10._spreadMinJobs = v8;
    v10._activeSpreadInterval = nil;
    v10._pendingJobs = {};
    v10._pendingByKey = {};
    v10._nextPendingIndex = 1;
    v10._workerRunning = false;
    v10._destroyed = false;

    return v10;
end;

function u1._hasPendingWork(p11) -- Line: 93
    return p11._nextPendingIndex <= #p11._pendingJobs;
end;

function u1._getPendingCount(p12) -- Line: 97
    return math.max(0, #p12._pendingJobs - p12._nextPendingIndex + 1);
end;

function u1._refreshSpreadInterval(p13) -- Line: 101
    if p13._targetSpreadSeconds == nil then
        return;
    end;

    local v14 = p13:_getPendingCount();

    if v14 < p13._spreadMinJobs then
        return;
    end;

    local v15 = math.ceil(v14 / p13._maxJobsPerStep);
    local v16 = math.max(1, v15);
    local v17 = p13._targetSpreadSeconds / v16;

    if p13._activeSpreadInterval == nil or v17 < p13._activeSpreadInterval then
        p13._activeSpreadInterval = v17;
    end;
end;

function u1._compactPending(p18) -- Line: 118
    if p18._nextPendingIndex <= #p18._pendingJobs then
        return;
    end;

    table.clear(p18._pendingJobs);
    p18._nextPendingIndex = 1;
end;

function u1._runJob(p19, p20) -- Line: 127
    -- upvalues: u2 (copy)
    if p20.Cancelled or p19._pendingByKey[p20.Key] ~= p20 then
        return;
    end;

    p19._pendingByKey[p20.Key] = nil;
    local v21 = { pcall(p20.Callback) };

    if not v21[1] then
        local v22 = v21[2];
        u2:AtError():Log((`{p19._name} job failed for {p20.Key}: {v22}`));
    end;
end;

function u1._processPending(p23) -- Line: 141
    local v24 = os.clock();
    local v25 = 0;

    while p23._nextPendingIndex <= #p23._pendingJobs and (v25 < p23._maxJobsPerStep and os.clock() - v24 < p23._maxStepTime) do
        local v26 = p23._pendingJobs[p23._nextPendingIndex];
        p23._pendingJobs[p23._nextPendingIndex] = nil;
        p23._nextPendingIndex = p23._nextPendingIndex + 1;
        p23:_runJob(v26);
        v25 = v25 + 1;
    end;

    p23:_compactPending();
end;

function u1._ensureWorker(u27) -- Line: 161
    if u27._workerRunning or u27._destroyed then
        return;
    end;

    u27._workerRunning = true;
    task.defer(function() -- Line: 167
        -- upvalues: u27 (copy)
        local v28 = 0;

        while not u27._destroyed and u27:_hasPendingWork() do
            u27:_refreshSpreadInterval();
            local v29 = v28 - os.clock();

            if v29 > 0 then
                task.wait(v29);
            end;

            u27:_processPending();
            v28 = os.clock() + (u27._activeSpreadInterval or u27._stepInterval);
        end;

        u27._activeSpreadInterval = nil;
        u27._workerRunning = false;

        if not u27._destroyed and u27:_hasPendingWork() then
            u27:_ensureWorker();
        end;
    end);
end;

function u1.Queue(p30, p31, p32) -- Line: 194
    -- upvalues: Asserts (copy)
    Asserts.string(p31);
    Asserts.func(p32);
    assert(p31 ~= "", "RenderBudget key must be non-empty");
    assert(not p30._destroyed, "Cannot queue into destroyed RenderBudget");
    local v33 = p30._pendingByKey[p31];

    if v33 ~= nil then
        v33.Cancelled = true;
    end;

    local v34 = {
        Cancelled = false,
        Key = p31,
        Callback = p32
    };
    p30._pendingByKey[p31] = v34;
    table.insert(p30._pendingJobs, v34);
    p30:_ensureWorker();
end;

function u1.Cancel(p35, p36) -- Line: 215
    -- upvalues: Asserts (copy)
    Asserts.string(p36);
    local v37 = p35._pendingByKey[p36];

    if v37 == nil then
        return;
    end;

    v37.Cancelled = true;
    p35._pendingByKey[p36] = nil;
end;

function u1.CancelAll(p38) -- Line: 227
    for i, v in pairs(p38._pendingByKey) do
        v.Cancelled = true;
        p38._pendingByKey[i] = nil;
    end;
end;

function u1.Flush(p39) -- Line: 234
    while p39:_hasPendingWork() do
        p39:_processPending();
    end;
end;

function u1.Destroy(p40) -- Line: 240
    if p40._destroyed then
        return;
    end;

    p40:CancelAll();
    p40._destroyed = true;
    p40._workerRunning = false;
    table.clear(p40._pendingJobs);
    p40._nextPendingIndex = 1;
end;

return u1;