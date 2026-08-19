-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();
local u2 = {};
u2.__index = u2;

local function isQueued(p3, p4) -- Line: 52
    return p3._pendingKinds[p4] ~= nil;
end;

local function queueInstance(p5, p6, p7) -- Line: 56
    if p5._destroyed then
        return;
    end;

    local _filter = p5._filter;

    if _filter and not _filter(p6) then
        return;
    end;

    if p5._pendingKinds[p6] == nil then
        p5._pendingInstances[#p5._pendingInstances + 1] = p6;
    end;

    p5._pendingKinds[p6] = p7;
end;

local function compactPending(p8) -- Line: 73
    if p8._nextPendingIndex <= #p8._pendingInstances then
        return;
    end;

    table.clear(p8._pendingInstances);
    p8._nextPendingIndex = 1;
end;

local function hasPendingWork(p9) -- Line: 82
    return p9._nextPendingIndex <= #p9._pendingInstances and true or #p9._pendingTraversals > 0;
end;

local function queueTraversal(p10, p11, p12) -- Line: 86
    p10._pendingTraversals[#p10._pendingTraversals + 1] = {
        kind = p12,
        stack = p11:GetChildren()
    };
end;

local function processTraversals(p13, p14) -- Line: 93
    local v15 = 0;

    while #p13._pendingTraversals > 0 and (v15 < p13._maxInstancesPerStep and os.clock() - p14 < p13._maxStepTime) do
        local v16 = p13._pendingTraversals[#p13._pendingTraversals];
        local stack = v16.stack;
        local v17 = stack[#stack];
        stack[#stack] = nil;

        if v17 then
            local kind = v16.kind;

            if not p13._destroyed then
                local _filter = p13._filter;

                if not _filter or _filter(v17) then
                    if p13._pendingKinds[v17] == nil then
                        p13._pendingInstances[#p13._pendingInstances + 1] = v17;
                    end;

                    p13._pendingKinds[v17] = kind;
                end;
            end;

            local v18 = v17:GetChildren();

            for i = 1, #v18 do
                stack[#stack + 1] = v18[i];
            end;

            v15 = v15 + 1;
        else
            p13._pendingTraversals[#p13._pendingTraversals] = nil;
        end;
    end;

    return v15;
end;

local function processPending(p19) -- Line: 124
    -- upvalues: processTraversals (copy), u1 (copy)
    local v20 = os.clock();
    local v21 = processTraversals(p19, v20);

    while p19._nextPendingIndex <= #p19._pendingInstances and (v21 < p19._maxInstancesPerStep and os.clock() - v20 < p19._maxStepTime) do
        local v22 = p19._pendingInstances[p19._nextPendingIndex];
        p19._pendingInstances[p19._nextPendingIndex] = nil;
        p19._nextPendingIndex = p19._nextPendingIndex + 1;

        if v22 then
            local v23 = p19._pendingKinds[v22];
            p19._pendingKinds[v22] = nil;

            if v23 == "Added" then
                local _onAdded = p19._onAdded;

                if _onAdded then
                    local v24 = { pcall(_onAdded, v22) };

                    if not v24[1] then
                        u1:AtError():Log("InstanceChangeQueue OnAdded failed", {
                            Error = tostring(v24[2]),
                            Instance = v22:GetFullName()
                        });
                    end;
                end;
            else
                local v25 = v23 == "Removed" and p19._onRemoved;

                if v25 then
                    local v26 = { pcall(v25, v22) };

                    if not v26[1] then
                        u1:AtError():Log("InstanceChangeQueue OnRemoved failed", {
                            Error = tostring(v26[2]),
                            Instance = v22:GetFullName()
                        });
                    end;
                end;
            end;
        end;

        v21 = v21 + 1;
    end;

    if p19._nextPendingIndex <= #p19._pendingInstances then
        return;
    end;

    table.clear(p19._pendingInstances);
    p19._nextPendingIndex = 1;
end;

local function ensureWorker(u27) -- Line: 174
    -- upvalues: processPending (copy), u1 (copy), ensureWorker (copy)
    if u27._workerRunning or u27._destroyed then
        return;
    end;

    u27._workerRunning = true;
    task.spawn(function() -- Line: 181
        -- upvalues: u27 (copy), processPending (ref), u1 (ref), ensureWorker (ref)
        local v28 = 0;

        while not u27._destroyed do
            local v29 = u27;

            if v29._nextPendingIndex > #v29._pendingInstances and #v29._pendingTraversals <= 0 then
                break;
            end;

            local v30 = v28 - os.clock();

            if v30 > 0 then
                task.wait(v30);
            end;

            local v31 = { pcall(processPending, u27) };

            if not v31[1] then
                u1:AtError():Log("InstanceChangeQueue worker failed", {
                    Error = tostring(v31[2])
                });
            end;

            v28 = os.clock() + u27._stepInterval;
        end;

        u27._workerRunning = false;

        if not u27._destroyed then
            local v32 = u27;

            if v32._nextPendingIndex <= #v32._pendingInstances and true or #v32._pendingTraversals > 0 then
                ensureWorker(u27);
            end;
        end;
    end);
end;

function u2.new(p33) -- Line: 209
    -- upvalues: u2 (copy)
    local v34 = not (p33 and p33.MaxInstancesPerStep) and 70 or p33.MaxInstancesPerStep;
    local v35 = not (p33 and p33.MaxStepTime) and 0.004166666666666667 or p33.MaxStepTime;
    local v36 = not (p33 and p33.StepInterval) and 0.016666666666666666 or p33.StepInterval;
    local v37;

    if typeof(v34) == "number" then
        v37 = v34 >= 1;
    else
        v37 = false;
    end;

    assert(v37, "MaxInstancesPerStep must be >= 1");
    local v38;

    if typeof(v35) == "number" then
        v38 = v35 > 0;
    else
        v38 = false;
    end;

    assert(v38, "MaxStepTime must be > 0");
    local v39;

    if typeof(v36) == "number" then
        v39 = v36 > 0;
    else
        v39 = false;
    end;

    assert(v39, "StepInterval must be > 0");
    local v40 = {
        _nextPendingIndex = 1,
        _workerRunning = false,
        _destroyed = false
    };
    local v41;

    if p33 then
        v41 = p33.Filter;
    else
        v41 = nil;
    end;

    v40._filter = v41;
    local v42;

    if p33 then
        v42 = p33.OnAdded;
    else
        v42 = nil;
    end;

    v40._onAdded = v42;
    local v43;

    if p33 then
        v43 = p33.OnRemoved;
    else
        v43 = nil;
    end;

    v40._onRemoved = v43;
    v40._maxInstancesPerStep = math.floor(v34);
    v40._maxStepTime = v35;
    v40._stepInterval = v36;
    v40._pendingInstances = {};
    v40._pendingKinds = {};
    v40._pendingTraversals = {};

    return setmetatable(v40, u2);
end;

function u2.QueueAdded(u44, p45) -- Line: 238
    -- upvalues: processPending (copy), u1 (copy), ensureWorker (copy)
    if not u44._destroyed then
        local _filter = u44._filter;

        if not _filter or _filter(p45) then
            if u44._pendingKinds[p45] == nil then
                u44._pendingInstances[#u44._pendingInstances + 1] = p45;
            end;

            u44._pendingKinds[p45] = "Added";
        end;
    end;

    if not u44._workerRunning then
        if u44._destroyed then
            return;
        end;

        u44._workerRunning = true;
        task.spawn(function() -- Line: 181
            -- upvalues: u44 (copy), processPending (ref), u1 (ref), ensureWorker (ref)
            local v46 = 0;

            while not u44._destroyed do
                local v47 = u44;

                if v47._nextPendingIndex > #v47._pendingInstances and #v47._pendingTraversals <= 0 then
                    break;
                end;

                local v48 = v46 - os.clock();

                if v48 > 0 then
                    task.wait(v48);
                end;

                local v49 = { pcall(processPending, u44) };

                if not v49[1] then
                    u1:AtError():Log("InstanceChangeQueue worker failed", {
                        Error = tostring(v49[2])
                    });
                end;

                v46 = os.clock() + u44._stepInterval;
            end;

            u44._workerRunning = false;

            if not u44._destroyed then
                local v50 = u44;

                if v50._nextPendingIndex <= #v50._pendingInstances and true or #v50._pendingTraversals > 0 then
                    ensureWorker(u44);
                end;
            end;
        end);
    end;
end;

function u2.QueueRemoved(u51, p52) -- Line: 243
    -- upvalues: processPending (copy), u1 (copy), ensureWorker (copy)
    if not u51._destroyed then
        local _filter = u51._filter;

        if not _filter or _filter(p52) then
            if u51._pendingKinds[p52] == nil then
                u51._pendingInstances[#u51._pendingInstances + 1] = p52;
            end;

            u51._pendingKinds[p52] = "Removed";
        end;
    end;

    if not u51._workerRunning then
        if u51._destroyed then
            return;
        end;

        u51._workerRunning = true;
        task.spawn(function() -- Line: 181
            -- upvalues: u51 (copy), processPending (ref), u1 (ref), ensureWorker (ref)
            local v53 = 0;

            while not u51._destroyed do
                local v54 = u51;

                if v54._nextPendingIndex > #v54._pendingInstances and #v54._pendingTraversals <= 0 then
                    break;
                end;

                local v55 = v53 - os.clock();

                if v55 > 0 then
                    task.wait(v55);
                end;

                local v56 = { pcall(processPending, u51) };

                if not v56[1] then
                    u1:AtError():Log("InstanceChangeQueue worker failed", {
                        Error = tostring(v56[2])
                    });
                end;

                v53 = os.clock() + u51._stepInterval;
            end;

            u51._workerRunning = false;

            if not u51._destroyed then
                local v57 = u51;

                if v57._nextPendingIndex <= #v57._pendingInstances and true or #v57._pendingTraversals > 0 then
                    ensureWorker(u51);
                end;
            end;
        end);
    end;
end;

function u2.QueueDescendantsAdded(u58, p59, p60) -- Line: 248
    -- upvalues: processPending (copy), u1 (copy), ensureWorker (copy)
    if p60 ~= false and not u58._destroyed then
        local _filter = u58._filter;

        if not _filter or _filter(p59) then
            if u58._pendingKinds[p59] == nil then
                u58._pendingInstances[#u58._pendingInstances + 1] = p59;
            end;

            u58._pendingKinds[p59] = "Added";
        end;
    end;

    u58._pendingTraversals[#u58._pendingTraversals + 1] = {
        kind = "Added",
        stack = p59:GetChildren()
    };

    if not u58._workerRunning then
        if u58._destroyed then
            return;
        end;

        u58._workerRunning = true;
        task.spawn(function() -- Line: 181
            -- upvalues: u58 (copy), processPending (ref), u1 (ref), ensureWorker (ref)
            local v61 = 0;

            while not u58._destroyed do
                local v62 = u58;

                if v62._nextPendingIndex > #v62._pendingInstances and #v62._pendingTraversals <= 0 then
                    break;
                end;

                local v63 = v61 - os.clock();

                if v63 > 0 then
                    task.wait(v63);
                end;

                local v64 = { pcall(processPending, u58) };

                if not v64[1] then
                    u1:AtError():Log("InstanceChangeQueue worker failed", {
                        Error = tostring(v64[2])
                    });
                end;

                v61 = os.clock() + u58._stepInterval;
            end;

            u58._workerRunning = false;

            if not u58._destroyed then
                local v65 = u58;

                if v65._nextPendingIndex <= #v65._pendingInstances and true or #v65._pendingTraversals > 0 then
                    ensureWorker(u58);
                end;
            end;
        end);
    end;
end;

function u2.QueueDescendantsRemoved(u66, p67, p68) -- Line: 258
    -- upvalues: processPending (copy), u1 (copy), ensureWorker (copy)
    if p68 ~= false and not u66._destroyed then
        local _filter = u66._filter;

        if not _filter or _filter(p67) then
            if u66._pendingKinds[p67] == nil then
                u66._pendingInstances[#u66._pendingInstances + 1] = p67;
            end;

            u66._pendingKinds[p67] = "Removed";
        end;
    end;

    u66._pendingTraversals[#u66._pendingTraversals + 1] = {
        kind = "Removed",
        stack = p67:GetChildren()
    };

    if not u66._workerRunning then
        if u66._destroyed then
            return;
        end;

        u66._workerRunning = true;
        task.spawn(function() -- Line: 181
            -- upvalues: u66 (copy), processPending (ref), u1 (ref), ensureWorker (ref)
            local v69 = 0;

            while not u66._destroyed do
                local v70 = u66;

                if v70._nextPendingIndex > #v70._pendingInstances and #v70._pendingTraversals <= 0 then
                    break;
                end;

                local v71 = v69 - os.clock();

                if v71 > 0 then
                    task.wait(v71);
                end;

                local v72 = { pcall(processPending, u66) };

                if not v72[1] then
                    u1:AtError():Log("InstanceChangeQueue worker failed", {
                        Error = tostring(v72[2])
                    });
                end;

                v69 = os.clock() + u66._stepInterval;
            end;

            u66._workerRunning = false;

            if not u66._destroyed then
                local v73 = u66;

                if v73._nextPendingIndex <= #v73._pendingInstances and true or #v73._pendingTraversals > 0 then
                    ensureWorker(u66);
                end;
            end;
        end);
    end;
end;

function u2.Flush(p74) -- Line: 268
    -- upvalues: processPending (copy)
    while p74._nextPendingIndex <= #p74._pendingInstances and true or #p74._pendingTraversals > 0 do
        processPending(p74);
    end;
end;

function u2.IsIdle(p75) -- Line: 274
    local v76 = not p75._workerRunning;

    if v76 then
        v76 = not (p75._nextPendingIndex <= #p75._pendingInstances and true or #p75._pendingTraversals > 0);
    end;

    return v76;
end;

function u2.Destroy(p77) -- Line: 278
    if p77._destroyed then
        return;
    end;

    p77._destroyed = true;
    p77._workerRunning = false;
    table.clear(p77._pendingInstances);
    table.clear(p77._pendingKinds);
    table.clear(p77._pendingTraversals);
    p77._nextPendingIndex = 1;
end;

return u2;