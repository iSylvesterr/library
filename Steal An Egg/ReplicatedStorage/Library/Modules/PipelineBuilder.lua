-- Decompiled with Potassium's decompiler.

local ContentProvider = game:GetService("ContentProvider");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Resources = script.Resources;
local Library = ReplicatedStorage.Library;
local Packages = Library.Modules.Packages;
local Promise = require(Packages.Promise);
local Signal = require(Packages.Signal);
local Log = require(Packages.Log);
local Asserts = require(Library.Asserts);
local Flags = require(Library.Modules.Flags);
local Constants = require(script.Private.Constants);
local u1 = Log.new():LimitUnderLevel("Debug");
local Types = require(script.Private.Types);
local TableUtil = require(Library.Modules.Packages.TableUtil);
local States = require(script.Private.States);
local u2 = {};
u2.__index = u2;

function u2._optionCallModifier(p3, p4, ...) -- Line: 50
    -- upvalues: Asserts (copy)
    Asserts.string(p4);
    local v5 = p3.Modifiers[p4];

    if typeof(v5) == "function" then
        return v5(p3, ...);
    end;
end;

function u2._processBatchQueue(p6) -- Line: 67
    -- upvalues: u1 (copy), States (copy), ContentProvider (copy), Promise (copy)
    local v7 = 0;

    while #p6.BatchQueue ~= 0 do
        local v8 = 0;
        local v9 = os.clock();
        v7 = v7 + 1;
        u1:AtTrace():Log((`Processing batch queue: counter: {v7}, smear counter: {v8}`));
        local v10 = {};
        local u11 = {};
        local u12 = false;

        for i = math.min(p6.CONSTANTS.BATCH_THRESHOLD, #p6.BatchQueue), 1, -1 do
            local v13 = table.remove(p6.BatchQueue, i);
            v8 = v8 + 1;
            u1:AtTrace():Log("processing batch queu packet. Found cache packet in batch quue:", v13);

            if v13 and not v13._resolvedAndFlushed then
                v13._flags:Add(States.LOADING);
                table.insert(v10, v13);
                table.insert(u11, v13._trackedInstance);

                if v8 >= p6.CONSTANTS.INNER_SMEAR_THRESHOLD then
                    task.wait();
                    v8 = 0;
                end;
            end;
        end;

        u1:AtTrace():Log(`finalized first batch operation, smear counter is at: {v8}`, "(preload queue):", u11, "(resovleQueue):", v10);
        local v14 = p6.CONSTANTS.PRELOAD_TIMEOUT + #u11 * p6.CONSTANTS.AVERAGE_TIME_PER_ITEM;
        local u15 = nil;

        local function tryPreload(p16) -- Line: 110
            -- upvalues: ContentProvider (ref), u11 (copy), u15 (ref)
            ContentProvider:PreloadAsync(u11, function(p17, p18) -- Line: 111
                -- upvalues: u15 (ref)
                u15 = p18;
            end);
            p16();
        end;

        Promise.retryWithDelay(function() -- Line: 117
            -- upvalues: Promise (ref), tryPreload (copy)
            return Promise.new(tryPreload);
        end, p6.CONSTANTS.RETRY_THRESHOLD, p6.CONSTANTS.RETRY_DELAY):timeout(v14, (`Retry timeout for preload work. (timeoutValue): {v14}, numItems: {#u11}`)):catch(function(p19) -- Line: 121
            -- upvalues: u12 (ref), u1 (ref), u15 (ref)
            u12 = p19;
            u1:AtError():Log((`Failed to batch process even after many trials, last fetch status: {u15}, err: {p19}`));
        end):await();

        for _, v in v10 do
            v._flags:Add(States.LOADED);

            if u12 then
                v._flags:Add(States.FAILED);
                v._deferredStack.reject(v._trackedInstance, "Failed to preload the instance with error:", u12);
                u1:AtError():Log(`Couldn't preload the animations even after preload: counter: {v7}, smear: {v8}`, "the cache that was processed:", v);
                p6:_optionCallModifier("OnPreloadFail", v, v7, v8);
            else
                v._deferredStack.resolve(v._trackedInstance);
                p6:_optionCallModifier("OnPreloadSuccess", v, v7, v8);

                if not v._preserveOnFailure then
                    v._resolvedAndFlushed = true;
                    v._loadingPromise = nil;
                    v._preserveOnFailure = nil;
                    local v20;

                    if v._preserveStateFlags then
                        v20 = v._flags or nil;
                    else
                        v20 = nil;
                    end;

                    v._flags = v20;
                    v._deferredStack = nil;
                end;
            end;
        end;

        u1:AtTrace():Log(`Completed animation preload cycle in {(os.clock() - v9) * 1000}ms, for:`, u11);

        if v7 >= p6.CONSTANTS.GLOBAL_COUNTER_THRESHOLD then
            task.wait();
            v7 = 0;
        end;
    end;

    p6.BatchScheduled = false;
end;

function u2._enqueue(p21, p22, p23, p24) -- Line: 176
    -- upvalues: Asserts (copy), u1 (copy), States (copy)
    Asserts.optional.number(p24);
    p21.InstanceCache[p23] = p22;
    table.insert(p21.BatchQueue, p22);

    if #p21.BatchQueue < p21.CONSTANTS.BATCH_THRESHOLD or p21.BatchScheduled then
        if not p21.BatchScheduled then
            u1:AtTrace():Log("Batch quue is emtpy so instantly scheduling work while waiting for the queu to fill up more to catch more nodes:", p21.BatchQueue);
            p21.BatchScheduled = true;
            p22._flags:Add(States.WAITING_FOR_BATCH);
            task.delay(p24 or p21.CONSTANTS.BATCH_DELAY, p21._processBatchQueue, p21);
        end;

        return;
    end;

    u1:AtTrace():Log("Batch queu already filled the threashold, spawning hte process instnaly and not waiting for the the delay:", p21.BatchQueue);
    p21.BatchScheduled = true;
    task.spawn(p21._processBatchQueue, p21);
end;

function u2._selectResults(p25, p26, p27) -- Line: 204
    -- upvalues: u1 (copy)
    if p25 == "Promise" then
        return p26;
    end;

    if p25 == "CachePacket" then
        return p27;
    end;

    if p25 == "TrackedInstance" then
        if p27 then
            p27 = p27._trackedInstance;
        end;

        return p27;
    end;

    if p26 and p27 then
        return { p26, p27 };
    end;

    u1:AtWarning():Log("PipelineBuilder cannot successful guess teh selected result, invalid parameters/");
end;

function u2.GetPromisePacketFromId(p28, p29, p30, p31) -- Line: 227
    -- upvalues: Asserts (copy), u1 (copy), Signal (copy), Promise (copy), States (copy), Flags (copy)
    Asserts.string(p29);
    local v32 = p28.InstanceCache[p29];
    u1:AtTrace():Log("(GetPromisePacketFromId): cache:", v32);

    if v32 then
        if Signal.Is(v32) then
            u1:AtTrace():Log("cache is already acquired, waiting for tthe hanlder to releases it");
            v32 = v32:Wait();
            u1:AtTrace():Log("cache found after signal yield, meanign that many systems were getting the same asset id:", v32);

            if not v32 or Promise.is(v32) then
                return v32;
            end;
        elseif v32._flags and v32._flags:Has(States.LOADED) or v32._resolvedAndFlushed then
            u1:AtTrace():Log("cache already loaded, isntnaly resolving with the cache instate:", v32);

            return Promise.resolve(v32._trackedInstance), v32;
        end;

        u1:AtTrace():Log("cache foudn but not in a special state meanign that alreayd processing so waiting for process to complete:", v32);

        return v32._loadingPromise, v32;
    end;

    local u33 = Signal.new();
    p28.InstanceCache[p29] = u33;
    local v34 = p28.Modifiers.PrepareInstance(p28, p29);

    if typeof(v34) ~= "Instance" then
        local v35 = Promise.reject("Invalid instance class returned by the prepare function");
        u33:Fire(v35);

        return v35;
    end;

    local u36 = {
        _resolvedAndFlushed = false,
        _trackedInstance = v34,
        _assetId = p29,
        _flags = Flags.new(),
        _deferredStack = {},
        _preserveStateFlags = p30,
        _preserveOnFailure = p31
    };
    u36._loadingPromise = Promise.new(function(p37, p38, p39) -- Line: 280
        -- upvalues: u36 (copy)
        u36._deferredStack.resolve = p37;
        u36._deferredStack.reject = p38;
        u36._deferredStack.onCancel = p39;
    end):catch(function(p40) -- Line: 284
        -- upvalues: u1 (ref)
        u1:AtWarning("Loading promise errored, couldn\'t successfully resolve the deferred stack with:", p40);
    end);
    u1:AtTrace():Log("Creating brand new cache structure with its related animation:", v32);
    u36._flags:Add(States.INITIALIZED);
    p28:_enqueue(u36, p29);
    u33:Fire(u36);
    task.delay(4, function() -- Line: 296
        -- upvalues: u33 (copy), u1 (ref)
        if not u33 then
            return;
        end;

        u33:Destroy();
        u1:AtTrace():Log("lock marker resolved and destroyed, it will be GCed");
    end);

    return u36._loadingPromise, u36;
end;

function u2.CollectRawResults(p41, p42, p43) -- Line: 311
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.string(p43);

    if typeof(p42) ~= "table" then
        return p41._selectResults(p43, p41:GetPromisePacketFromId(p42)) or u1:AtError():Log((`Failed to get one of the results guided by {p43}`));
    end;

    local v44 = {};

    for _, v in p42 do
        local v45 = p41:CollectRawResults(v, p43);

        if v45 then
            table.insert(v44, v45);
        end;
    end;

    return v44, "Batched";
end;

function u2.RushGetTrackedInstance(p46, p47) -- Line: 341
    return assert(p46:CollectRawResults(p47, "TrackedInstance"));
end;

function u2.RushGetTrackedPromises(p48, p49) -- Line: 352
    return p48:CollectRawResults(p49, "Promise");
end;

function u2.GetPackageAfterPreload(p50, p51) -- Line: 363
    -- upvalues: Promise (copy)
    local v52, v53 = p50:CollectRawResults(p51, "Promise");
    local v54 = v53 == "Batched" and v52 and v52 or { v52 };

    if typeof(v54) == "table" then
        return Promise.some(v54, #v54);
    end;

    return Promise.reject("Failed to retrieve the promise list from cache");
end;

function u2.GetTrackedAfterPreloadAwait(p55, p56) -- Line: 378
    return p55:GetPackageAfterPreload(p56):await();
end;

function u2.GetTrackedAfterPreloadAsync(p57, p58) -- Line: 389
    return p57:GetPackageAfterPreload(p58):expect();
end;

function u2.create(p59) -- Line: 397
    -- upvalues: Types (copy), Resources (copy), TableUtil (copy), Constants (copy), States (copy), u2 (copy)
    assert(Types.Create(p59));
    local v60 = {
        BatchScheduled = false,
        Modifiers = p59.Modifiers or {},
        Resources = p59.Resources or Resources,
        CONSTANTS = TableUtil.Reconcile(p59.Constants or {}, Constants),
        States = p59.States or States,
        InstanceCache = {},
        BatchQueue = {}
    };

    return setmetatable(v60, {
        __index = u2
    });
end;

return u2;