-- Decompiled with Potassium's decompiler.

local u1 = nil;

local function AcquireRunnerThreadAndCallEventHandler(p2, ...) -- Line: 43
    -- upvalues: u1 (ref)
    local v3 = u1;
    u1 = nil;
    p2(...);
    u1 = v3;
end;

local function RunEventHandlerInFreeThread(...) -- Line: 51
    -- upvalues: AcquireRunnerThreadAndCallEventHandler (copy)
    AcquireRunnerThreadAndCallEventHandler(...);

    while true do
        AcquireRunnerThreadAndCallEventHandler(coroutine.yield());
    end;
end;

local function Cleanup(p4, ...) -- Line: 58
    local v5 = typeof(p4);

    if v5 == "function" then
        p4(...);

        return;
    end;

    if v5 == "RBXScriptConnection" then
        p4:Disconnect();

        return;
    end;

    if v5 == "Instance" then
        p4:Destroy();

        return;
    end;

    if v5 == "table" then
        if type(p4.Destroy) == "function" then
            p4:Destroy();

            return;
        end;

        if type(p4.Disconnect) == "function" then
            p4:Disconnect();
        end;
    end;
end;

local function CleanupInThread(...) -- Line: 78
    -- upvalues: u1 (ref), RunEventHandlerInFreeThread (copy), Cleanup (copy)
    if not u1 then
        u1 = coroutine.create(RunEventHandlerInFreeThread);
    end;

    task.spawn(assert(u1), Cleanup, ...);
end;

local u6 = {};
u6.__index = u6;

function u6.New(p7, p8) -- Line: 103
    -- upvalues: u6 (copy)
    local v9 = {
        maid = p7,
        object = p8
    };
    setmetatable(v9, u6);

    return v9;
end;

function u6.Destroy(p10) -- Line: 116
    p10.maid.tokens[p10] = nil;
end;

function u6.Cleanup(p11, ...) -- Line: 120
    -- upvalues: CleanupInThread (copy)
    if p11.object == nil then
        return;
    end;

    p11.maid.tokens[p11] = nil;
    CleanupInThread(p11.object, ...);
    p11.object = nil;
end;

local u12 = {};
u12.__index = u12;

function u12.New(p13) -- Line: 135
    -- upvalues: u12 (copy)
    local v14 = {
        is_cleaned = false,
        tokens = {},
        key = p13
    };
    setmetatable(v14, u12);

    return v14;
end;

function u12.IsActive(p15) -- Line: 149
    return not p15.is_cleaned;
end;

function u12.Add(p16, p17) -- Line: 153
    -- upvalues: CleanupInThread (copy), u6 (copy)
    if p16.is_cleaned == true then
        CleanupInThread(p17);
    end;

    local v18 = typeof(p17);

    if v18 == "table" then
        if type(p17.Destroy) ~= "function" and type(p17.Disconnect) ~= "function" then
            error((`[{script.Name}]: Received table as cleanup object, but couldn't detect a :Destroy() or :Disconnect() method`));
        end;
    elseif v18 ~= "function" and (v18 ~= "RBXScriptConnection" and v18 ~= "Instance") then
        error((`[{script.Name}]: Cleanup of type "{v18}" not supported`));
    end;

    local v19 = u6.New(p16, p17);
    p16.tokens[v19] = true;

    return v19;
end;

function u12.Cleanup(p20, ...) -- Line: 176
    if p20.key ~= nil then
        error((`[{script.Name}]: "Cleanup()" is locked for this Maid`));
    end;

    p20.is_cleaned = true;

    for i in pairs(p20.tokens) do
        i:Cleanup(...);
    end;
end;

function u12.Unlock(p21, p22) -- Line: 190
    if p21.key ~= nil and p21.key ~= p22 then
        error((`[{script.Name}]: Invalid lock key`));
    end;

    p21.key = nil;
end;

return u12;