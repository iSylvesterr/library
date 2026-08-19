-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local Promise = require(ReplicatedStorage.Library.Modules.Packages.Promise);
local Signal = require(ReplicatedStorage.Library.Modules.Packages.Signal);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local u1 = t.tuple(t.optional(t.numberPositive));
local u2 = t.tuple(t.callback);
local u3 = {};
u3.__index = u3;

function u3.new(p4) -- Line: 43
    -- upvalues: u1 (copy), u3 (copy), Trove (copy), Signal (copy)
    assert(u1(p4));
    local u5 = setmetatable({}, u3);
    u5._trove = Trove.new();
    u5._queue = {};
    u5._processTimeout = p4 or 60;
    u5._processNextEvent = u5._trove:Add(Signal.new());
    u5._destroyed = false;
    task.spawn(function() -- Line: 54
        -- upvalues: u5 (copy), u3 (ref)
        local u6 = false;
        u5._processNextEvent:Connect(function() -- Line: 56
            -- upvalues: u6 (ref)
            u6 = true;
        end);

        while not u5._destroyed do
            if not u6 then
                u5._processNextEvent:Wait();
            end;

            u6 = false;
            task.spawn(u3.ProcessNext, u5);
        end;
    end);

    return u5;
end;

function u3.ProcessNext(u7) -- Line: 76
    -- upvalues: Constants (copy)
    if u7.Processing then
        return;
    end;

    local u8 = u7._queue[1];

    if not u8 then
        return;
    end;

    u7.Processing = true;
    local u9 = false;
    local u10 = false;
    task.spawn(function() -- Line: 90
        -- upvalues: u8 (copy), Constants (ref), u10 (ref), u9 (ref), u7 (copy)
        local v11 = { pcall(function() -- Line: 91
                -- upvalues: u8 (ref)
                return u8.Callback(table.unpack(u8.Args));
            end) };

        if v11[1] then
            table.remove(v11, 1);
            u8.ResolvePromise(table.unpack(v11));
        else
            local v12 = `CallbackQueue: {tostring(v11[2])}\n{u8.Traceback}`;

            if Constants.IS_STUDIO then
                error(v12);
            else
                warn(v12);
            end;
        end;

        u10 = true;

        if not u9 then
            u9 = true;
            table.remove(u7._queue, 1);
            u7.Processing = false;
            u7._processNextEvent:Fire();
        end;
    end);
    local v13 = os.clock();

    while not u10 and os.clock() - v13 < u7._processTimeout do
        task.wait();
    end;

    if not u9 then
        u9 = true;
        table.remove(u7._queue, 1);
        u7.Processing = false;
        u7._processNextEvent:Fire();
    end;
end;

function u3.Add(p14, p15, ...) -- Line: 130
    -- upvalues: u2 (copy), Promise (copy)
    assert(u2(p15));
    assert(not p14._destroyed, "Attempted to add to a destroyed CallbackQueue!");
    local u16 = {
        Callback = p15,
        Args = { ... },
        Traceback = debug.traceback()
    };
    local v18 = Promise.new(function(p17) -- Line: 140
        -- upvalues: u16 (copy)
        u16.ResolvePromise = p17;
    end):catch(warn);
    table.insert(p14._queue, u16);
    p14._processNextEvent:Fire();

    return v18;
end;

function u3.AddAsync(p19, p20, ...) -- Line: 150
    local v21 = { p19:Add(p20, ...):await() };
    table.remove(v21, 1);

    return table.unpack(v21);
end;

function u3.Destroy(p22) -- Line: 156
    p22._destroyed = true;
    p22._trove:Destroy();
end;

return u3;