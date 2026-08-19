-- Decompiled with Potassium's decompiler.

local u1 = {
    __mode = "k"
};

local function isCallable(p2) -- Line: 10
    if type(p2) == "function" then
        return true;
    end;

    local v3 = type(p2) == "table" and getmetatable(p2);

    if v3 then
        local v4 = rawget(v3, "__call");

        if type(v4) == "function" then
            return true;
        end;
    end;

    return false;
end;

local function makeEnum(u5, p6) -- Line: 28
    local v7 = {};

    for _, v in ipairs(p6) do
        v7[v] = v;
    end;

    return setmetatable(v7, {
        __index = function(p8, p9) -- Line: 36, Name: __index
            -- upvalues: u5 (copy)
            error(string.format("%s is not in %s!", p9, u5), 2);
        end,

        __newindex = function() -- Line: 39, Name: __newindex
            -- upvalues: u5 (copy)
            error(string.format("Creating new members in %s is not allowed!", u5), 2);
        end
    });
end;

local u10 = {
    Kind = makeEnum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" })
};
u10.__index = u10;

function u10.new(p11, p12) -- Line: 64
    -- upvalues: u10 (ref)
    local v13 = p11 or {};
    local v14 = {
        error = tostring(v13.error) or "[This error has no error text.]",
        trace = v13.trace,
        context = v13.context,
        kind = v13.kind,
        parent = p12,
        createdTick = os.clock(),
        createdTrace = debug.traceback()
    };

    return setmetatable(v14, u10);
end;

function u10.is(p15) -- Line: 77
    if type(p15) == "table" then
        local v16 = getmetatable(p15);

        if type(v16) == "table" then
            local v17;

            if rawget(p15, "error") == nil then
                v17 = false;
            else
                local v18 = rawget(v16, "extend");
                v17 = type(v18) == "function";
            end;

            return v17;
        end;
    end;

    return false;
end;

function u10.isKind(p19, p20) -- Line: 89
    -- upvalues: u10 (ref)
    assert(p20 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil");
    local v21 = u10.is(p19) and p19.kind == p20;

    return v21;
end;

function u10.extend(p22, p23) -- Line: 95
    -- upvalues: u10 (ref)
    local v24 = p23 or {};
    v24.kind = v24.kind or p22.kind;

    return u10.new(v24, p22);
end;

function u10.getErrorChain(p25) -- Line: 103
    local v26 = { p25 };

    while v26[#v26].parent do
        table.insert(v26, v26[#v26].parent);
    end;

    return v26;
end;

function u10.__tostring(p27) -- Line: 113
    local v28 = { string.format("-- Promise.Error(%s) --", p27.kind or "?") };

    for _, v in ipairs(p27:getErrorChain()) do
        table.insert(v28, table.concat({ v.trace or v.error, v.context }, "\n"));
    end;

    return table.concat(v28, "\n");
end;

local function pack(...) -- Line: 137
    return select("#", ...), { ... };
end;

local function packResult(p29, ...) -- Line: 144
    return p29, select("#", ...), { ... };
end;

local function makeErrorHandler(u30) -- Line: 148
    -- upvalues: u10 (ref)
    assert(u30 ~= nil, "traceback is nil");

    return function(p31) -- Line: 151
        -- upvalues: u10 (ref), u30 (copy)
        if type(p31) == "table" then
            return p31;
        end;

        return u10.new({
            error = p31,
            kind = u10.Kind.ExecutionError,
            trace = debug.traceback(tostring(p31), 2),
            context = "Promise created at:\n\n" .. u30
        });
    end;
end;

local function runExecutor(u32, p33, ...) -- Line: 171
    -- upvalues: packResult (copy), u10 (ref)
    local v34 = xpcall;
    assert(u32 ~= nil, "traceback is nil");

    return packResult(v34(p33, function(p35) -- Line: 151
        -- upvalues: u10 (ref), u32 (copy)
        if type(p35) == "table" then
            return p35;
        end;

        return u10.new({
            error = p35,
            kind = u10.Kind.ExecutionError,
            trace = debug.traceback(tostring(p35), 2),
            context = "Promise created at:\n\n" .. u32
        });
    end, ...));
end;

local function createAdvancer(u36, u37, u38, u39) -- Line: 179
    -- upvalues: runExecutor (copy)
    return function(...) -- Line: 180
        -- upvalues: runExecutor (ref), u36 (copy), u37 (copy), u38 (copy), u39 (copy)
        local v40, v41, v42 = runExecutor(u36, u37, ...);

        if v40 then
            u38(unpack(v42, 1, v41));

            return;
        end;

        u39(v42[1]);
    end;
end;

local function isEmpty(p43) -- Line: 191
    return next(p43) == nil;
end;

local u44 = {
    Error = u10,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    _unhandledRejectionCallbacks = {},
    prototype = {}
};
u44.__index = u44.prototype;

function u44._new(p45, u46, p47) -- Line: 230
    -- upvalues: u44 (copy), u1 (copy), runExecutor (copy)
    if p47 ~= nil and not u44.is(p47) then
        error("Argument #2 to Promise.new must be a promise or nil", 2);
    end;

    local u48 = {
        _thread = nil,
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p45,
        _status = u44.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p47,
        _consumers = setmetatable({}, u1)
    };

    if p47 and p47._status == u44.Status.Started then
        p47._consumers[u48] = true;
    end;

    setmetatable(u48, u44);

    local function resolve(...) -- Line: 278
        -- upvalues: u48 (copy)
        u48:_resolve(...);
    end;

    local function reject(...) -- Line: 282
        -- upvalues: u48 (copy)
        u48:_reject(...);
    end;

    local function onCancel(p49) -- Line: 286
        -- upvalues: u48 (copy), u44 (ref)
        if p49 then
            if u48._status == u44.Status.Cancelled then
                p49();
            else
                u48._cancellationHook = p49;
            end;
        end;

        return u48._status == u44.Status.Cancelled;
    end;

    u48._thread = coroutine.create(function() -- Line: 298
        -- upvalues: runExecutor (ref), u48 (copy), u46 (copy), resolve (copy), reject (copy), onCancel (copy)
        local v50, _, v51 = runExecutor(u48._source, u46, resolve, reject, onCancel);

        if not v50 then
            reject(v51[1]);
        end;
    end);
    task.spawn(u48._thread);

    return u48;
end;

function u44.new(p52) -- Line: 349
    -- upvalues: u44 (copy)
    return u44._new(debug.traceback(nil, 2), p52);
end;

function u44.__tostring(p53) -- Line: 353
    return string.format("Promise(%s)", p53._status);
end;

function u44.defer(u54) -- Line: 375
    -- upvalues: u44 (copy), runExecutor (copy)
    local u55 = debug.traceback(nil, 2);

    return u44._new(u55, function(u56, u57, u58) -- Line: 378
        -- upvalues: u44 (ref), runExecutor (ref), u55 (copy), u54 (copy)
        local u59 = nil;
        u59 = u44._timeEvent:Connect(function() -- Line: 380
            -- upvalues: u59 (ref), runExecutor (ref), u55 (ref), u54 (ref), u56 (copy), u57 (copy), u58 (copy)
            u59:Disconnect();
            local v60, _, v61 = runExecutor(u55, u54, u56, u57, u58);

            if not v60 then
                u57(v61[1]);
            end;
        end);
    end);
end;

u44.async = u44.defer;

function u44.resolve(...) -- Line: 418
    -- upvalues: pack (copy), u44 (copy)
    local u62, u63 = pack(...);

    return u44._new(debug.traceback(nil, 2), function(p64) -- Line: 420
        -- upvalues: u63 (copy), u62 (copy)
        p64(unpack(u63, 1, u62));
    end);
end;

function u44.reject(...) -- Line: 435
    -- upvalues: pack (copy), u44 (copy)
    local u65, u66 = pack(...);

    return u44._new(debug.traceback(nil, 2), function(p67, p68) -- Line: 437
        -- upvalues: u66 (copy), u65 (copy)
        p68(unpack(u66, 1, u65));
    end);
end;

function u44._try(p69, u70, ...) -- Line: 446
    -- upvalues: pack (copy), u44 (copy)
    local u71, u72 = pack(...);

    return u44._new(p69, function(p73) -- Line: 449
        -- upvalues: u70 (copy), u72 (copy), u71 (copy)
        p73(u70(unpack(u72, 1, u71)));
    end);
end;

function u44.try(p74, ...) -- Line: 477
    -- upvalues: u44 (copy)
    return u44._try(debug.traceback(nil, 2), p74, ...);
end;

function u44._all(p75, u76, u77) -- Line: 486
    -- upvalues: u44 (copy)
    if type(u76) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
    end;

    for i, v in pairs(u76) do
        if not u44.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(i))), 3);
        end;
    end;

    if #u76 == 0 or u77 == 0 then
        return u44.resolve({});
    end;

    return u44._new(p75, function(u78, u79, p80) -- Line: 504
        -- upvalues: u77 (copy), u76 (copy)
        local u81 = {};
        local u82 = {};
        local u83 = 0;
        local u84 = 0;
        local u85 = false;

        local function resolveOne(p86, ...) -- Line: 522
            -- upvalues: u85 (ref), u83 (ref), u77 (ref), u81 (copy), u76 (ref), u78 (copy), u82 (copy)
            if u85 then
                return;
            end;

            u83 = u83 + 1;

            if u77 == nil then
                u81[p86] = ...;
            else
                u81[u83] = ...;
            end;

            if u83 >= (u77 or #u76) then
                u85 = true;
                u78(u81);

                for _, v in ipairs(u82) do
                    v:cancel();
                end;
            end;
        end;

        p80(function() -- Line: 515, Name: cancel
            -- upvalues: u82 (copy)
            for _, v in ipairs(u82) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u76) do
            u82[i] = v:andThen(function(...) -- Line: 547
                -- upvalues: resolveOne (copy), i (copy)
                resolveOne(i, ...);
            end, function(...) -- Line: 549
                -- upvalues: u84 (ref), u77 (ref), u76 (ref), u82 (copy), u85 (ref), u79 (copy)
                u84 = u84 + 1;

                if u77 == nil or #u76 - u84 < u77 then
                    for _, v2 in ipairs(u82) do
                        v2:cancel();
                    end;

                    u85 = true;
                    u79(...);
                end;
            end);
        end;

        if u85 then
            for _, v in ipairs(u82) do
                v:cancel();
            end;
        end;
    end);
end;

function u44.all(p87) -- Line: 591
    -- upvalues: u44 (copy)
    return u44._all(debug.traceback(nil, 2), p87);
end;

function u44.fold(p88, u89, p90) -- Line: 620
    -- upvalues: u44 (copy)
    local v91 = type(p88) == "table";
    assert(v91, "Bad argument #1 to Promise.fold: must be a table");
    local v92;

    if type(u89) == "function" then
        v92 = true;
    elseif type(u89) == "table" then
        local v93 = getmetatable(u89);

        if v93 then
            local v94 = rawget(v93, "__call");
            v92 = type(v94) == "function";
        else
            v92 = false;
        end;
    else
        v92 = false;
    end;

    assert(v92, "Bad argument #2 to Promise.fold: must be a function");
    local u95 = u44.resolve(p90);

    return u44.each(p88, function(u96, u97) -- Line: 625
        -- upvalues: u95 (ref), u89 (copy)
        u95 = u95:andThen(function(p98) -- Line: 626
            -- upvalues: u89 (ref), u96 (copy), u97 (copy)
            return u89(p98, u96, u97);
        end);
    end):andThen(function() -- Line: 629
        -- upvalues: u95 (ref)
        return u95;
    end);
end;

function u44.some(p99, p100) -- Line: 653
    -- upvalues: u44 (copy)
    local v101 = type(p100) == "number";
    assert(v101, "Bad argument #2 to Promise.some: must be a number");

    return u44._all(debug.traceback(nil, 2), p99, p100);
end;

function u44.any(p102) -- Line: 677
    -- upvalues: u44 (copy)
    return u44._all(debug.traceback(nil, 2), p102, 1):andThen(function(p103) -- Line: 678
        return p103[1];
    end);
end;

function u44.allSettled(u104) -- Line: 699
    -- upvalues: u44 (copy)
    if type(u104) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
    end;

    for i, v in pairs(u104) do
        if not u44.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(i))), 2);
        end;
    end;

    if #u104 == 0 then
        return u44.resolve({});
    end;

    return u44._new(debug.traceback(nil, 2), function(u105, p106, p107) -- Line: 717
        -- upvalues: u104 (copy)
        local u108 = {};
        local u109 = {};
        local u110 = 0;

        local function u112(p111, ...) -- Line: 727
            -- upvalues: u110 (ref), u108 (copy), u104 (ref), u105 (copy)
            u110 = u110 + 1;
            u108[p111] = ...;

            if u110 >= #u104 then
                u105(u108);
            end;
        end;

        p107(function() -- Line: 737
            -- upvalues: u109 (copy)
            for _, v in ipairs(u109) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u104) do
            u109[i] = v:finally(function(...) -- Line: 746
                -- upvalues: u112 (copy), i (copy)
                u112(i, ...);
            end);
        end;
    end);
end;

function u44.race(u113) -- Line: 777
    -- upvalues: u44 (copy)
    local v114 = type(u113) == "table";
    assert(v114, string.format("Please pass a list of promises to %s", "Promise.race"));

    for i, v in pairs(u113) do
        local v115 = u44.is(v);
        local format = string.format;
        local v116 = tostring(i);
        assert(v115, format("Non-promise value passed into %s at index %s", "Promise.race", v116));
    end;

    return u44._new(debug.traceback(nil, 2), function(u117, u118, p119) -- Line: 784
        -- upvalues: u113 (copy)
        local u120 = {};
        local u121 = false;

        local function cancel() -- Line: 788
            -- upvalues: u120 (copy)
            for _, v in ipairs(u120) do
                v:cancel();
            end;
        end;

        local function finalize(u122) -- Line: 794
            -- upvalues: u120 (copy), u121 (ref)
            return function(...) -- Line: 795
                -- upvalues: u120 (ref), u121 (ref), u122 (copy)
                for _, v in ipairs(u120) do
                    v:cancel();
                end;

                u121 = true;

                return u122(...);
            end;
        end;

        if p119(function(...) -- Line: 795
            -- upvalues: u120 (copy), u121 (ref), u118 (copy)
            for _, v in ipairs(u120) do
                v:cancel();
            end;

            u121 = true;

            return u118(...);
        end) then
            return;
        end;

        for i, v in ipairs(u113) do
            u120[i] = v:andThen(function(...) -- Line: 795
                -- upvalues: u120 (copy), u121 (ref), u117 (copy)
                for _, v2 in ipairs(u120) do
                    v2:cancel();
                end;

                u121 = true;

                return u117(...);
            end, function(...) -- Line: 795
                -- upvalues: u120 (copy), u121 (ref), u118 (copy)
                for _, v2 in ipairs(u120) do
                    v2:cancel();
                end;

                u121 = true;

                return u118(...);
            end);
        end;

        if u121 then
            for _, v in ipairs(u120) do
                v:cancel();
            end;
        end;
    end);
end;

function u44.each(u123, u124) -- Line: 872
    -- upvalues: u44 (copy), u10 (ref)
    local v125 = type(u123) == "table";
    assert(v125, string.format("Please pass a list of promises to %s", "Promise.each"));
    local v126;

    if type(u124) == "function" then
        v126 = true;
    elseif type(u124) == "table" then
        local v127 = getmetatable(u124);

        if v127 then
            local v128 = rawget(v127, "__call");
            v126 = type(v128) == "function";
        else
            v126 = false;
        end;
    else
        v126 = false;
    end;

    assert(v126, string.format("Please pass a handler function to %s!", "Promise.each"));

    return u44._new(debug.traceback(nil, 2), function(p129, p130, p131) -- Line: 876
        -- upvalues: u123 (copy), u44 (ref), u10 (ref), u124 (copy)
        local v132 = {};
        local u133 = {};
        local u134 = false;

        local function _() -- Line: 882
            -- upvalues: u133 (copy)
            for _, v in ipairs(u133) do
                v:cancel();
            end;
        end;

        p131(function() -- Line: 888
            -- upvalues: u134 (ref), u133 (copy)
            u134 = true;

            for _, v in ipairs(u133) do
                v:cancel();
            end;
        end);
        local v135 = {};

        for i, v in ipairs(u123) do
            if u44.is(v) then
                if v:getStatus() == u44.Status.Cancelled then
                    for _, v2 in ipairs(u133) do
                        v2:cancel();
                    end;

                    return p130(u10.new({
                        error = "Promise is cancelled",
                        kind = u10.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
                    }));
                end;

                if v:getStatus() == u44.Status.Rejected then
                    for _, v2 in ipairs(u133) do
                        v2:cancel();
                    end;

                    return p130(select(2, v:await()));
                end;

                local v136 = v:andThen(function(...) -- Line: 921
                    return ...;
                end);
                table.insert(u133, v136);
                v135[i] = v136;
            else
                v135[i] = v;
            end;
        end;

        for i, v in ipairs(v135) do
            if u44.is(v) then
                local v137, v = v:await();

                if not v137 then
                    for _, v2 in ipairs(u133) do
                        v2:cancel();
                    end;

                    return p130(v);
                end;
            end;

            if u134 then
                return;
            end;

            local v138 = u44.resolve(u124(v, i));
            table.insert(u133, v138);
            local v139, v140 = v138:await();

            if not v139 then
                for _, v2 in ipairs(u133) do
                    v2:cancel();
                end;

                return p130(v140);
            end;

            v132[i] = v140;
        end;

        p129(v132);
    end);
end;

function u44.is(p141) -- Line: 971
    -- upvalues: u44 (copy)
    if type(p141) ~= "table" then
        return false;
    end;

    local v142 = getmetatable(p141);

    if v142 == u44 then
        return true;
    end;

    if v142 ~= nil then
        if type(v142) == "table" then
            local v143 = rawget(v142, "__index");

            if type(v143) == "table" then
                local v144 = rawget(v142, "__index");
                local v145 = rawget(v144, "andThen");
                local v146;

                if type(v145) == "function" then
                    v146 = true;
                else
                    local v147 = type(v145) == "table" and getmetatable(v145);

                    if v147 then
                        local v148 = rawget(v147, "__call");
                        v146 = type(v148) == "function";
                    else
                        v146 = false;
                    end;
                end;

                if v146 then
                    return true;
                end;
            end;
        end;

        return false;
    end;

    local andThen = p141.andThen;

    if type(andThen) == "function" then
        return true;
    end;

    local v149 = type(andThen) == "table" and getmetatable(andThen);

    if v149 then
        local v150 = rawget(v149, "__call");

        if type(v150) == "function" then
            return true;
        end;
    end;

    return false;
end;

function u44.promisify(u151) -- Line: 1020
    -- upvalues: u44 (copy)
    return function(...) -- Line: 1021
        -- upvalues: u44 (ref), u151 (copy)
        return u44._try(debug.traceback(nil, 2), u151, ...);
    end;
end;

local u152 = nil;
local u153 = nil;

function u44.delay(p154) -- Line: 1051
    -- upvalues: u44 (copy), u153 (ref), u152 (ref)
    local v155 = type(p154) == "number";
    assert(v155, "Bad argument #1 to Promise.delay, must be a number.");
    local u156 = (p154 < 0.016666666666666666 or p154 == (1 / 0)) and 0.016666666666666666 or p154;

    return u44._new(debug.traceback(nil, 2), function(p157, p158, p159) -- Line: 1059
        -- upvalues: u44 (ref), u156 (ref), u153 (ref), u152 (ref)
        local v160 = u44._getTime();
        local v161 = v160 + u156;
        local u162 = {
            resolve = p157,
            startTime = v160,
            endTime = v161
        };

        if u153 == nil then
            u152 = u162;
            u153 = u44._timeEvent:Connect(function() -- Line: 1071
                -- upvalues: u44 (ref), u152 (ref), u153 (ref)
                local v163 = u44._getTime();

                while u152 ~= nil and u152.endTime < v163 do
                    local v164 = u152;
                    u152 = v164.next;

                    if u152 == nil then
                        u153:Disconnect();
                        u153 = nil;
                    else
                        u152.previous = nil;
                    end;

                    v164.resolve(u44._getTime() - v164.startTime);
                end;
            end);
        elseif u152.endTime < v161 then
            local v165 = u152;
            local next2 = v165.next;

            while next2 ~= nil and next2.endTime < v161 do
                v165 = next2;
                next2 = next2.next;
            end;

            v165.next = u162;
            u162.previous = v165;

            if next2 ~= nil then
                u162.next = next2;
                next2.previous = u162;
            end;
        else
            u162.next = u152;
            u152.previous = u162;
            u152 = u162;
        end;

        p159(function() -- Line: 1116
            -- upvalues: u162 (copy), u152 (ref), u153 (ref)
            local next2 = u162.next;

            if u152 == u162 then
                if next2 == nil then
                    u153:Disconnect();
                    u153 = nil;
                else
                    next2.previous = nil;
                end;

                u152 = next2;

                return;
            end;

            local previous = u162.previous;
            previous.next = next2;

            if next2 ~= nil then
                next2.previous = previous;
            end;
        end);
    end);
end;

function u44.prototype.timeout(p166, u167, u168) -- Line: 1180
    -- upvalues: u44 (copy), u10 (ref)
    local u169 = debug.traceback(nil, 2);

    return u44.race({ u44.delay(u167):andThen(function() -- Line: 1184
            -- upvalues: u44 (ref), u168 (copy), u10 (ref), u167 (copy), u169 (copy)
            return u44.reject(u168 == nil and u10.new({
                error = "Timed out",
                kind = u10.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", u167, u169)
            }) or u168);
        end), p166 });
end;

function u44.prototype.getStatus(p170) -- Line: 1204
    return p170._status;
end;

function u44.prototype._andThen(u171, u172, u173, u174) -- Line: 1213
    -- upvalues: u44 (copy), runExecutor (copy)
    u171._unhandledRejection = false;

    if u171._status ~= u44.Status.Cancelled then
        return u44._new(u172, function(u175, u176, p177) -- Line: 1225
            -- upvalues: u173 (copy), u172 (copy), runExecutor (ref), u174 (copy), u171 (copy), u44 (ref)
            local u178;

            if u173 then
                local u179 = u172;
                local u180 = u173;

                u178 = function(...) -- Line: 180
                    -- upvalues: runExecutor (ref), u179 (copy), u180 (copy), u175 (copy), u176 (copy)
                    local v181, v182, v183 = runExecutor(u179, u180, ...);

                    if v181 then
                        u175(unpack(v183, 1, v182));

                        return;
                    end;

                    u176(v183[1]);
                end;
            else
                u178 = u175;
            end;

            if u174 then
                local u184 = u172;
                local u185 = u174;

                u176 = function(...) -- Line: 180
                    -- upvalues: runExecutor (ref), u184 (copy), u185 (copy), u175 (copy), u176 (copy)
                    local v186, v187, v188 = runExecutor(u184, u185, ...);

                    if v186 then
                        u175(unpack(v188, 1, v187));

                        return;
                    end;

                    u176(v188[1]);
                end;
            end;

            if u171._status == u44.Status.Started then
                table.insert(u171._queuedResolve, u178);
                table.insert(u171._queuedReject, u176);
                p177(function() -- Line: 1244
                    -- upvalues: u171 (ref), u44 (ref), u178 (ref), u176 (ref)
                    if u171._status == u44.Status.Started then
                        table.remove(u171._queuedResolve, table.find(u171._queuedResolve, u178));
                        table.remove(u171._queuedReject, table.find(u171._queuedReject, u176));
                    end;
                end);
            elseif u171._status == u44.Status.Resolved then
                u178(unpack(u171._values, 1, u171._valuesLength));
            elseif u171._status == u44.Status.Rejected then
                u176(unpack(u171._values, 1, u171._valuesLength));
            end;
        end, u171);
    end;

    local v189 = u44.new(function() -- Line: 1218
    end);
    v189:cancel();

    return v189;
end;

function u44.prototype.andThen(p190, p191, p192) -- Line: 1283
    local v193;

    if p191 == nil or type(p191) == "function" then
        v193 = true;
    elseif type(p191) == "table" then
        local v194 = getmetatable(p191);

        if v194 then
            local v195 = rawget(v194, "__call");
            v193 = type(v195) == "function";
        else
            v193 = false;
        end;
    else
        v193 = false;
    end;

    assert(v193, string.format("Please pass a handler function to %s!", "Promise:andThen"));
    local v196;

    if p192 == nil or type(p192) == "function" then
        v196 = true;
    elseif type(p192) == "table" then
        local v197 = getmetatable(p192);

        if v197 then
            local v198 = rawget(v197, "__call");
            v196 = type(v198) == "function";
        else
            v196 = false;
        end;
    else
        v196 = false;
    end;

    assert(v196, string.format("Please pass a handler function to %s!", "Promise:andThen"));

    return p190:_andThen(debug.traceback(nil, 2), p191, p192);
end;

function u44.prototype.catch(p199, p200) -- Line: 1310
    local v201;

    if p200 == nil or type(p200) == "function" then
        v201 = true;
    elseif type(p200) == "table" then
        local v202 = getmetatable(p200);

        if v202 then
            local v203 = rawget(v202, "__call");
            v201 = type(v203) == "function";
        else
            v201 = false;
        end;
    else
        v201 = false;
    end;

    assert(v201, string.format("Please pass a handler function to %s!", "Promise:catch"));

    return p199:_andThen(debug.traceback(nil, 2), nil, p200);
end;

function u44.prototype.tap(p204, u205) -- Line: 1331
    -- upvalues: u44 (copy), pack (copy)
    local v206;

    if type(u205) == "function" then
        v206 = true;
    elseif type(u205) == "table" then
        local v207 = getmetatable(u205);

        if v207 then
            local v208 = rawget(v207, "__call");
            v206 = type(v208) == "function";
        else
            v206 = false;
        end;
    else
        v206 = false;
    end;

    assert(v206, string.format("Please pass a handler function to %s!", "Promise:tap"));

    return p204:_andThen(debug.traceback(nil, 2), function(...) -- Line: 1333
        -- upvalues: u205 (copy), u44 (ref), pack (ref)
        local v209 = u205(...);

        if not u44.is(v209) then
            return ...;
        end;

        local u210, u211 = pack(...);

        return v209:andThen(function() -- Line: 1338
            -- upvalues: u211 (copy), u210 (copy)
            return unpack(u211, 1, u210);
        end);
    end);
end;

function u44.prototype.andThenCall(p212, u213, ...) -- Line: 1366
    -- upvalues: pack (copy)
    local v214;

    if type(u213) == "function" then
        v214 = true;
    elseif type(u213) == "table" then
        local v215 = getmetatable(u213);

        if v215 then
            local v216 = rawget(v215, "__call");
            v214 = type(v216) == "function";
        else
            v214 = false;
        end;
    else
        v214 = false;
    end;

    assert(v214, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
    local u217, u218 = pack(...);

    return p212:_andThen(debug.traceback(nil, 2), function() -- Line: 1369
        -- upvalues: u213 (copy), u218 (copy), u217 (copy)
        return u213(unpack(u218, 1, u217));
    end);
end;

function u44.prototype.andThenReturn(p219, ...) -- Line: 1396
    -- upvalues: pack (copy)
    local u220, u221 = pack(...);

    return p219:_andThen(debug.traceback(nil, 2), function() -- Line: 1398
        -- upvalues: u221 (copy), u220 (copy)
        return unpack(u221, 1, u220);
    end);
end;

function u44.prototype.cancel(p222) -- Line: 1414
    -- upvalues: u44 (copy)
    if p222._status ~= u44.Status.Started then
        return;
    end;

    p222._status = u44.Status.Cancelled;

    if p222._cancellationHook then
        p222._cancellationHook();
    end;

    coroutine.close(p222._thread);

    if p222._parent then
        p222._parent:_consumerCancelled(p222);
    end;

    for i in pairs(p222._consumers) do
        i:cancel();
    end;

    p222:_finalize();
end;

function u44.prototype._consumerCancelled(p223, p224) -- Line: 1442
    -- upvalues: u44 (copy)
    if p223._status ~= u44.Status.Started then
        return;
    end;

    p223._consumers[p224] = nil;

    if next(p223._consumers) == nil then
        p223:cancel();
    end;
end;

function u44.prototype._finally(u225, p226, u227) -- Line: 1458
    -- upvalues: u44 (copy)
    u225._unhandledRejection = false;

    return u44._new(p226, function(u228, u229, p230) -- Line: 1461
        -- upvalues: u225 (copy), u227 (copy), u44 (ref)
        local u231 = nil;
        p230(function() -- Line: 1464
            -- upvalues: u225 (ref), u231 (ref)
            u225:_consumerCancelled(u225);

            if u231 then
                u231:cancel();
            end;
        end);
        local v234 = u227 and function(...) -- Line: 1477
            -- upvalues: u227 (ref), u44 (ref), u231 (ref), u228 (copy), u225 (ref), u229 (copy)
            local v232 = u227(...);

            if not u44.is(v232) then
                u228(u225);

                return;
            end;

            u231 = v232;
            v232:finally(function(p233) -- Line: 1484
                -- upvalues: u44 (ref), u228 (ref), u225 (ref)
                if p233 ~= u44.Status.Rejected then
                    u228(u225);
                end;
            end):catch(function(...) -- Line: 1489
                -- upvalues: u229 (ref)
                u229(...);
            end);
        end or u228;

        if u225._status == u44.Status.Started then
            table.insert(u225._queuedFinally, v234);
        else
            v234(u225._status);
        end;
    end);
end;

function u44.prototype.finally(p235, p236) -- Line: 1559
    local v237;

    if p236 == nil or type(p236) == "function" then
        v237 = true;
    elseif type(p236) == "table" then
        local v238 = getmetatable(p236);

        if v238 then
            local v239 = rawget(v238, "__call");
            v237 = type(v239) == "function";
        else
            v237 = false;
        end;
    else
        v237 = false;
    end;

    assert(v237, string.format("Please pass a handler function to %s!", "Promise:finally"));

    return p235:_finally(debug.traceback(nil, 2), p236);
end;

function u44.prototype.finallyCall(p240, u241, ...) -- Line: 1573
    -- upvalues: pack (copy)
    local v242;

    if type(u241) == "function" then
        v242 = true;
    elseif type(u241) == "table" then
        local v243 = getmetatable(u241);

        if v243 then
            local v244 = rawget(v243, "__call");
            v242 = type(v244) == "function";
        else
            v242 = false;
        end;
    else
        v242 = false;
    end;

    assert(v242, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
    local u245, u246 = pack(...);

    return p240:_finally(debug.traceback(nil, 2), function() -- Line: 1576
        -- upvalues: u241 (copy), u246 (copy), u245 (copy)
        return u241(unpack(u246, 1, u245));
    end);
end;

function u44.prototype.finallyReturn(p247, ...) -- Line: 1599
    -- upvalues: pack (copy)
    local u248, u249 = pack(...);

    return p247:_finally(debug.traceback(nil, 2), function() -- Line: 1601
        -- upvalues: u249 (copy), u248 (copy)
        return unpack(u249, 1, u248);
    end);
end;

function u44.prototype.awaitStatus(p250) -- Line: 1613
    -- upvalues: u44 (copy)
    p250._unhandledRejection = false;

    if p250._status == u44.Status.Started then
        local u251 = coroutine.running();
        p250:finally(function() -- Line: 1620
            -- upvalues: u251 (copy)
            task.spawn(u251);
        end):catch(function() -- Line: 1626
        end);
        coroutine.yield();
    end;

    if p250._status == u44.Status.Resolved then
        return p250._status, unpack(p250._values, 1, p250._valuesLength);
    end;

    if p250._status == u44.Status.Rejected then
        return p250._status, unpack(p250._values, 1, p250._valuesLength);
    end;

    return p250._status;
end;

local function awaitHelper(p252, ...) -- Line: 1641
    -- upvalues: u44 (copy)
    return p252 == u44.Status.Resolved, ...;
end;

function u44.prototype.await(p253) -- Line: 1666
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p253:awaitStatus());
end;

local function expectHelper(p254, ...) -- Line: 1670
    -- upvalues: u44 (copy)
    if p254 ~= u44.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3);
    end;

    return ...;
end;

function u44.prototype.expect(p255) -- Line: 1703
    -- upvalues: expectHelper (copy)
    return expectHelper(p255:awaitStatus());
end;

u44.prototype.awaitValue = u44.prototype.expect;

function u44.prototype._unwrap(p256) -- Line: 1717
    -- upvalues: u44 (copy)
    if p256._status == u44.Status.Started then
        error("Promise has not resolved or rejected.", 2);
    end;

    return p256._status == u44.Status.Resolved, unpack(p256._values, 1, p256._valuesLength);
end;

function u44.prototype._resolve(u257, ...) -- Line: 1727
    -- upvalues: u44 (copy), u10 (ref), pack (copy)
    if u257._status ~= u44.Status.Started then
        if u44.is((...)) then
            (...):_consumerCancelled(u257);
        end;

        return;
    end;

    if u44.is((...)) then
        if select("#", ...) > 1 then
            local v258 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", u257._source);
            warn(v258);
        end;

        local u259 = ...;
        local v261 = u259:andThen(function(...) -- Line: 1748
            -- upvalues: u257 (copy)
            u257:_resolve(...);
        end, function(...) -- Line: 1750
            -- upvalues: u259 (copy), u10 (ref), u257 (copy)
            local v260 = u259._values[1];

            if u259._error then
                v260 = u10.new({
                    context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    error = u259._error,
                    kind = u10.Kind.ExecutionError
                });
            end;

            if u10.isKind(v260, u10.Kind.ExecutionError) then
                return u257:_reject(v260:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", u257._source)
                }));
            end;

            u257:_reject(...);
        end);

        if v261._status == u44.Status.Cancelled then
            u257:cancel();

            return;
        end;

        if v261._status == u44.Status.Started then
            u257._parent = v261;
            v261._consumers[u257] = true;
        end;

        return;
    end;

    u257._status = u44.Status.Resolved;
    local v262, v263 = pack(...);
    u257._valuesLength = v262;
    u257._values = v263;

    for _, v in ipairs(u257._queuedResolve) do
        coroutine.wrap(v)(...);
    end;

    u257:_finalize();
end;

function u44.prototype._reject(u264, ...) -- Line: 1798
    -- upvalues: u44 (copy), pack (copy)
    if u264._status ~= u44.Status.Started then
        return;
    end;

    u264._status = u44.Status.Rejected;
    local v265, v266 = pack(...);
    u264._valuesLength = v265;
    u264._values = v266;

    if next(u264._queuedReject) == nil then
        local u267 = tostring((...));
        coroutine.wrap(function() -- Line: 1820
            -- upvalues: u44 (ref), u264 (copy), u267 (copy)
            u44._timeEvent:Wait();

            if not u264._unhandledRejection then
                return;
            end;

            local v268 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u267, u264._source);

            for _, v in ipairs(u44._unhandledRejectionCallbacks) do
                task.spawn(v, u264, unpack(u264._values, 1, u264._valuesLength));
            end;

            if u44.TEST then
                return;
            end;

            warn(v268);
        end)();
    else
        for _, v in ipairs(u264._queuedReject) do
            coroutine.wrap(v)(...);
        end;
    end;

    u264:_finalize();
end;

function u44.prototype._finalize(p269) -- Line: 1852
    -- upvalues: u44 (copy)
    for _, v in ipairs(p269._queuedFinally) do
        coroutine.wrap(v)(p269._status);
    end;

    p269._queuedFinally = nil;
    p269._queuedReject = nil;
    p269._queuedResolve = nil;

    if not u44.TEST then
        p269._parent = nil;
        p269._consumers = nil;
    end;

    task.defer(coroutine.close, p269._thread);
end;

function u44.prototype.now(p270, p271) -- Line: 1889
    -- upvalues: u44 (copy), u10 (ref)
    local v272 = debug.traceback(nil, 2);

    if p270._status == u44.Status.Resolved then
        return p270:_andThen(v272, function(...) -- Line: 1892
            return ...;
        end);
    end;

    local reject = u44.reject;

    if p271 == nil then
        p271 = u10.new({
            error = "This Promise was not resolved in time for :now()",
            kind = u10.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. v272
        }) or p271;
    end;

    return reject(p271);
end;

function u44.retry(u273, u274, ...) -- Line: 1934
    -- upvalues: u44 (copy)
    local v275;

    if type(u273) == "function" then
        v275 = true;
    elseif type(u273) == "table" then
        local v276 = getmetatable(u273);

        if v276 then
            local v277 = rawget(v276, "__call");
            v275 = type(v277) == "function";
        else
            v275 = false;
        end;
    else
        v275 = false;
    end;

    assert(v275, "Parameter #1 to Promise.retry must be a function");
    local v278 = type(u274) == "number";
    assert(v278, "Parameter #2 to Promise.retry must be a number");
    local u279 = { ... };
    local u280 = select("#", ...);

    return u44.resolve(u273(...)):catch(function(...) -- Line: 1940
        -- upvalues: u274 (copy), u44 (ref), u273 (copy), u279 (copy), u280 (copy)
        if u274 > 0 then
            return u44.retry(u273, u274 - 1, unpack(u279, 1, u280));
        end;

        return u44.reject(...);
    end);
end;

function u44.retryWithDelay(u281, u282, u283, ...) -- Line: 1962
    -- upvalues: u44 (copy)
    local v284;

    if type(u281) == "function" then
        v284 = true;
    elseif type(u281) == "table" then
        local v285 = getmetatable(u281);

        if v285 then
            local v286 = rawget(v285, "__call");
            v284 = type(v286) == "function";
        else
            v284 = false;
        end;
    else
        v284 = false;
    end;

    assert(v284, "Parameter #1 to Promise.retry must be a function");
    local v287 = type(u282) == "number";
    assert(v287, "Parameter #2 (times) to Promise.retry must be a number");
    local v288 = type(u283) == "number";
    assert(v288, "Parameter #3 (seconds) to Promise.retry must be a number");
    local u289 = { ... };
    local u290 = select("#", ...);

    return u44.resolve(u281(...)):catch(function(...) -- Line: 1969
        -- upvalues: u282 (copy), u44 (ref), u283 (copy), u281 (copy), u289 (copy), u290 (copy)
        if u282 <= 0 then
            return u44.reject(...);
        end;

        u44.delay(u283):await();

        return u44.retryWithDelay(u281, u282 - 1, u283, unpack(u289, 1, u290));
    end);
end;

function u44.fromEvent(u291, p292) -- Line: 2004
    -- upvalues: u44 (copy)
    local u293 = p292 or function() -- Line: 2005
        return true;
    end;

    return u44._new(debug.traceback(nil, 2), function(u294, p295, p296) -- Line: 2009
        -- upvalues: u291 (copy), u293 (ref)
        local u297 = nil;
        local u298 = false;

        local function disconnect() -- Line: 2013
            -- upvalues: u297 (ref)
            u297:Disconnect();
            u297 = nil;
        end;

        u297 = u291:Connect(function(...) -- Line: 2022
            -- upvalues: u293 (ref), u294 (copy), u297 (ref), u298 (ref)
            local v299 = u293(...);

            if v299 ~= true then
                if type(v299) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean");
                end;

                return;
            end;

            u294(...);

            if not u297 then
                u298 = true;

                return;
            end;

            u297:Disconnect();
            u297 = nil;
        end);

        if u298 and u297 then
            return disconnect();
        end;

        p296(disconnect);
    end);
end;

function u44.onUnhandledRejection(u300) -- Line: 2056
    -- upvalues: u44 (copy)
    table.insert(u44._unhandledRejectionCallbacks, u300);

    return function() -- Line: 2059
        -- upvalues: u44 (ref), u300 (copy)
        local v301 = table.find(u44._unhandledRejectionCallbacks, u300);

        if v301 then
            table.remove(u44._unhandledRejectionCallbacks, v301);
        end;
    end;
end;

return u44;