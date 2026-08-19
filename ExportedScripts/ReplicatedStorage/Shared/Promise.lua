-- Decompiled with Potassium's decompiler.

local u1 = {
    __mode = "k"
};

local function makeEnum(u2, p3) -- Line: 13
    local v4 = {};

    for _, v in ipairs(p3) do
        v4[v] = v;
    end;

    return setmetatable(v4, {
        __index = function(p5, p6) -- Line: 21, Name: __index
            -- upvalues: u2 (copy)
            error(string.format("%s is not in %s!", p6, u2), 2);
        end,

        __newindex = function() -- Line: 24, Name: __newindex
            -- upvalues: u2 (copy)
            error(string.format("Creating new members in %s is not allowed!", u2), 2);
        end
    });
end;

local u7 = {
    Kind = makeEnum("Promise.Error.Kind", { "ExecutionError", "AlreadyCancelled", "NotResolvedInTime", "TimedOut" })
};
u7.__index = u7;

function u7.new(p8, p9) -- Line: 46
    -- upvalues: u7 (ref)
    local v10 = p8 or {};
    local v11 = {
        error = tostring(v10.error) or "[This error has no error text.]",
        trace = v10.trace,
        context = v10.context,
        kind = v10.kind,
        parent = p9,
        createdTick = os.clock(),
        createdTrace = debug.traceback()
    };

    return setmetatable(v11, u7);
end;

function u7.is(p12) -- Line: 59
    if type(p12) == "table" then
        local v13 = getmetatable(p12);

        if type(v13) == "table" then
            local v14;

            if rawget(p12, "error") == nil then
                v14 = false;
            else
                local v15 = rawget(v13, "extend");
                v14 = type(v15) == "function";
            end;

            return v14;
        end;
    end;

    return false;
end;

function u7.isKind(p16, p17) -- Line: 71
    -- upvalues: u7 (ref)
    assert(p17 ~= nil, "Argument #2 to Promise.Error.isKind must not be nil");
    local v18 = u7.is(p16) and p16.kind == p17;

    return v18;
end;

function u7.extend(p19, p20) -- Line: 77
    -- upvalues: u7 (ref)
    local v21 = p20 or {};
    v21.kind = v21.kind or p19.kind;

    return u7.new(v21, p19);
end;

function u7.getErrorChain(p22) -- Line: 85
    local v23 = { p22 };

    while v23[#v23].parent do
        table.insert(v23, v23[#v23].parent);
    end;

    return v23;
end;

function u7.__tostring(p24) -- Line: 95
    local v25 = { string.format("-- Promise.Error(%s) --", p24.kind or "?") };

    for _, v in ipairs(p24:getErrorChain()) do
        table.insert(v25, table.concat({ v.trace or v.error, v.context }, "\n"));
    end;

    return table.concat(v25, "\n");
end;

local function pack(...) -- Line: 116
    return select("#", ...), { ... };
end;

local function packResult(p26, ...) -- Line: 123
    return p26, select("#", ...), { ... };
end;

local function makeErrorHandler(u27) -- Line: 128
    -- upvalues: u7 (ref)
    assert(u27 ~= nil);

    return function(p28) -- Line: 131
        -- upvalues: u7 (ref), u27 (copy)
        if type(p28) == "table" then
            return p28;
        end;

        return u7.new({
            error = p28,
            kind = u7.Kind.ExecutionError,
            trace = debug.traceback(tostring(p28), 2),
            context = "Promise created at:\n\n" .. u27
        });
    end;
end;

local function runExecutor(u29, p30, ...) -- Line: 151
    -- upvalues: packResult (copy), u7 (ref)
    local v31 = xpcall;
    assert(u29 ~= nil);

    return packResult(v31(p30, function(p32) -- Line: 131
        -- upvalues: u7 (ref), u29 (copy)
        if type(p32) == "table" then
            return p32;
        end;

        return u7.new({
            error = p32,
            kind = u7.Kind.ExecutionError,
            trace = debug.traceback(tostring(p32), 2),
            context = "Promise created at:\n\n" .. u29
        });
    end, ...));
end;

local function createAdvancer(u33, u34, u35, u36) -- Line: 159
    -- upvalues: runExecutor (copy)
    return function(...) -- Line: 160
        -- upvalues: runExecutor (ref), u33 (copy), u34 (copy), u35 (copy), u36 (copy)
        local v37, v38, v39 = runExecutor(u33, u34, ...);

        if v37 then
            u35(unpack(v39, 1, v38));

            return;
        end;

        u36(v39[1]);
    end;
end;

local function isEmpty(p40) -- Line: 171
    return next(p40) == nil;
end;

local u41 = {
    Error = u7,
    Status = makeEnum("Promise.Status", { "Started", "Resolved", "Rejected", "Cancelled" }),
    _getTime = os.clock,
    _timeEvent = game:GetService("RunService").Heartbeat,
    prototype = {}
};
u41.__index = u41.prototype;

function u41._new(p42, u43, p44) -- Line: 196
    -- upvalues: u41 (copy), u1 (copy), runExecutor (copy)
    if p44 ~= nil and not u41.is(p44) then
        error("Argument #2 to Promise.new must be a promise or nil", 2);
    end;

    local u45 = {
        _values = nil,
        _valuesLength = -1,
        _unhandledRejection = true,
        _cancellationHook = nil,
        _source = p42,
        _status = u41.Status.Started,
        _queuedResolve = {},
        _queuedReject = {},
        _queuedFinally = {},
        _parent = p44,
        _consumers = setmetatable({}, u1)
    };

    if p44 and p44._status == u41.Status.Started then
        p44._consumers[u45] = true;
    end;

    setmetatable(u45, u41);

    local function resolve(...) -- Line: 241
        -- upvalues: u45 (copy)
        u45:_resolve(...);
    end;

    local function reject(...) -- Line: 245
        -- upvalues: u45 (copy)
        u45:_reject(...);
    end;

    local function onCancel(p46) -- Line: 249
        -- upvalues: u45 (copy), u41 (ref)
        if p46 then
            if u45._status == u41.Status.Cancelled then
                p46();
            else
                u45._cancellationHook = p46;
            end;
        end;

        return u45._status == u41.Status.Cancelled;
    end;

    coroutine.wrap(function() -- Line: 261
        -- upvalues: runExecutor (ref), u45 (copy), u43 (copy), resolve (copy), reject (copy), onCancel (copy)
        local v47, _, v48 = runExecutor(u45._source, u43, resolve, reject, onCancel);

        if not v47 then
            reject(v48[1]);
        end;
    end)();

    return u45;
end;

function u41.new(p49) -- Line: 278
    -- upvalues: u41 (copy)
    return u41._new(debug.traceback(nil, 2), p49);
end;

function u41.__tostring(p50) -- Line: 282
    return string.format("Promise(%s)", p50:getStatus());
end;

function u41.defer(u51) -- Line: 289
    -- upvalues: u41 (copy), runExecutor (copy)
    local u52 = debug.traceback(nil, 2);

    return u41._new(u52, function(u53, u54, u55) -- Line: 292
        -- upvalues: u41 (ref), runExecutor (ref), u52 (copy), u51 (copy)
        local u56 = nil;
        u56 = u41._timeEvent:Connect(function() -- Line: 294
            -- upvalues: u56 (ref), runExecutor (ref), u52 (ref), u51 (ref), u53 (copy), u54 (copy), u55 (copy)
            u56:Disconnect();
            local v57, _, v58 = runExecutor(u52, u51, u53, u54, u55);

            if not v57 then
                u54(v58[1]);
            end;
        end);
    end);
end;

u41.async = u41.defer;

function u41.resolve(...) -- Line: 313
    -- upvalues: pack (copy), u41 (copy)
    local u59, u60 = pack(...);

    return u41._new(debug.traceback(nil, 2), function(p61) -- Line: 315
        -- upvalues: u60 (copy), u59 (copy)
        p61(unpack(u60, 1, u59));
    end);
end;

function u41.reject(...) -- Line: 323
    -- upvalues: pack (copy), u41 (copy)
    local u62, u63 = pack(...);

    return u41._new(debug.traceback(nil, 2), function(p64, p65) -- Line: 325
        -- upvalues: u63 (copy), u62 (copy)
        p65(unpack(u63, 1, u62));
    end);
end;

function u41._try(p66, u67, ...) -- Line: 334
    -- upvalues: pack (copy), u41 (copy)
    local u68, u69 = pack(...);

    return u41._new(p66, function(p70) -- Line: 337
        -- upvalues: u67 (copy), u69 (copy), u68 (copy)
        p70(u67(unpack(u69, 1, u68)));
    end);
end;

function u41.try(...) -- Line: 345
    -- upvalues: u41 (copy)
    return u41._try(debug.traceback(nil, 2), ...);
end;

function u41._all(p71, u72, u73) -- Line: 354
    -- upvalues: u41 (copy)
    if type(u72) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.all"), 3);
    end;

    for i, v in pairs(u72) do
        if not u41.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.all", (tostring(i))), 3);
        end;
    end;

    if #u72 == 0 or u73 == 0 then
        return u41.resolve({});
    end;

    return u41._new(p71, function(u74, u75, p76) -- Line: 372
        -- upvalues: u73 (copy), u72 (copy)
        local u77 = {};
        local u78 = {};
        local u79 = 0;
        local u80 = 0;
        local u81 = false;

        local function resolveOne(p82, ...) -- Line: 390
            -- upvalues: u81 (ref), u79 (ref), u73 (ref), u77 (copy), u72 (ref), u74 (copy), u78 (copy)
            if u81 then
                return;
            end;

            u79 = u79 + 1;

            if u73 == nil then
                u77[p82] = ...;
            else
                u77[u79] = ...;
            end;

            if u79 >= (u73 or #u72) then
                u81 = true;
                u74(u77);

                for _, v in ipairs(u78) do
                    v:cancel();
                end;
            end;
        end;

        p76(function() -- Line: 383, Name: cancel
            -- upvalues: u78 (copy)
            for _, v in ipairs(u78) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u72) do
            u78[i] = v:andThen(function(...) -- Line: 416
                -- upvalues: resolveOne (copy), i (copy)
                resolveOne(i, ...);
            end, function(...) -- Line: 419
                -- upvalues: u80 (ref), u73 (ref), u72 (ref), u78 (copy), u81 (ref), u75 (copy)
                u80 = u80 + 1;

                if u73 == nil or #u72 - u80 < u73 then
                    for _, v2 in ipairs(u78) do
                        v2:cancel();
                    end;

                    u81 = true;
                    u75(...);
                end;
            end);
        end;

        if u81 then
            for _, v in ipairs(u78) do
                v:cancel();
            end;
        end;
    end);
end;

function u41.all(p83) -- Line: 438
    -- upvalues: u41 (copy)
    return u41._all(debug.traceback(nil, 2), p83);
end;

function u41.some(p84, p85) -- Line: 442
    -- upvalues: u41 (copy)
    local v86 = type(p85) == "number";
    assert(v86, "Bad argument #2 to Promise.some: must be a number");

    return u41._all(debug.traceback(nil, 2), p84, p85);
end;

function u41.any(p87) -- Line: 448
    -- upvalues: u41 (copy)
    return u41._all(debug.traceback(nil, 2), p87, 1):andThen(function(p88) -- Line: 449
        return p88[1];
    end);
end;

function u41.allSettled(u89) -- Line: 454
    -- upvalues: u41 (copy)
    if type(u89) ~= "table" then
        error(string.format("Please pass a list of promises to %s", "Promise.allSettled"), 2);
    end;

    for i, v in pairs(u89) do
        if not u41.is(v) then
            error(string.format("Non-promise value passed into %s at index %s", "Promise.allSettled", (tostring(i))), 2);
        end;
    end;

    if #u89 == 0 then
        return u41.resolve({});
    end;

    return u41._new(debug.traceback(nil, 2), function(u90, p91, p92) -- Line: 472
        -- upvalues: u89 (copy)
        local u93 = {};
        local u94 = {};
        local u95 = 0;

        local function u97(p96, ...) -- Line: 482
            -- upvalues: u95 (ref), u93 (copy), u89 (ref), u90 (copy)
            u95 = u95 + 1;
            u93[p96] = ...;

            if u95 >= #u89 then
                u90(u93);
            end;
        end;

        p92(function() -- Line: 492
            -- upvalues: u94 (copy)
            for _, v in ipairs(u94) do
                v:cancel();
            end;
        end);

        for i, v in ipairs(u89) do
            u94[i] = v:finally(function(...) -- Line: 502
                -- upvalues: u97 (copy), i (copy)
                u97(i, ...);
            end);
        end;
    end);
end;

function u41.race(u98) -- Line: 514
    -- upvalues: u41 (copy)
    local v99 = type(u98) == "table";
    assert(v99, string.format("Please pass a list of promises to %s", "Promise.race"));

    for i, v in pairs(u98) do
        local v100 = u41.is(v);
        local format = string.format;
        local v101 = tostring(i);
        assert(v100, format("Non-promise value passed into %s at index %s", "Promise.race", v101));
    end;

    return u41._new(debug.traceback(nil, 2), function(u102, u103, p104) -- Line: 521
        -- upvalues: u98 (copy)
        local u105 = {};
        local u106 = false;

        local function cancel() -- Line: 525
            -- upvalues: u105 (copy)
            for _, v in ipairs(u105) do
                v:cancel();
            end;
        end;

        local function finalize(u107) -- Line: 531
            -- upvalues: u105 (copy), u106 (ref)
            return function(...) -- Line: 532
                -- upvalues: u105 (ref), u106 (ref), u107 (copy)
                for _, v in ipairs(u105) do
                    v:cancel();
                end;

                u106 = true;

                return u107(...);
            end;
        end;

        if p104(function(...) -- Line: 532
            -- upvalues: u105 (copy), u106 (ref), u103 (copy)
            for _, v in ipairs(u105) do
                v:cancel();
            end;

            u106 = true;

            return u103(...);
        end) then
            return;
        end;

        for i, v in ipairs(u98) do
            u105[i] = v:andThen(function(...) -- Line: 532
                -- upvalues: u105 (copy), u106 (ref), u102 (copy)
                for _, v2 in ipairs(u105) do
                    v2:cancel();
                end;

                u106 = true;

                return u102(...);
            end, function(...) -- Line: 532
                -- upvalues: u105 (copy), u106 (ref), u103 (copy)
                for _, v2 in ipairs(u105) do
                    v2:cancel();
                end;

                u106 = true;

                return u103(...);
            end);
        end;

        if u106 then
            for _, v in ipairs(u105) do
                v:cancel();
            end;
        end;
    end);
end;

function u41.each(u108, u109) -- Line: 561
    -- upvalues: u41 (copy), u7 (ref)
    local v110 = type(u108) == "table";
    assert(v110, string.format("Please pass a list of promises to %s", "Promise.each"));
    local v111 = type(u109) == "function";
    assert(v111, string.format("Please pass a handler function to %s!", "Promise.each"));

    return u41._new(debug.traceback(nil, 2), function(p112, p113, p114) -- Line: 565
        -- upvalues: u108 (copy), u41 (ref), u7 (ref), u109 (copy)
        local v115 = {};
        local u116 = {};
        local u117 = false;

        local function _() -- Line: 571
            -- upvalues: u116 (copy)
            for _, v in ipairs(u116) do
                v:cancel();
            end;
        end;

        p114(function() -- Line: 577
            -- upvalues: u117 (ref), u116 (copy)
            u117 = true;

            for _, v in ipairs(u116) do
                v:cancel();
            end;
        end);
        local v118 = {};

        for i, v in ipairs(u108) do
            if u41.is(v) then
                if v:getStatus() == u41.Status.Cancelled then
                    for _, v2 in ipairs(u116) do
                        v2:cancel();
                    end;

                    return p113(u7.new({
                        error = "Promise is cancelled",
                        kind = u7.Kind.AlreadyCancelled,
                        context = string.format("The Promise that was part of the array at index %d passed into Promise.each was already cancelled when Promise.each began.\n\nThat Promise was created at:\n\n%s", i, v._source)
                    }));
                end;

                if v:getStatus() == u41.Status.Rejected then
                    for _, v2 in ipairs(u116) do
                        v2:cancel();
                    end;

                    return p113(select(2, v:await()));
                end;

                local v119 = v:andThen(function(...) -- Line: 610
                    return ...;
                end);
                table.insert(u116, v119);
                v118[i] = v119;
            else
                v118[i] = v;
            end;
        end;

        for i, v in ipairs(v118) do
            if u41.is(v) then
                local v120, v = v:await();

                if not v120 then
                    for _, v2 in ipairs(u116) do
                        v2:cancel();
                    end;

                    return p113(v);
                end;
            end;

            if u117 then
                return;
            end;

            local v121 = u41.resolve(u109(v, i));
            table.insert(u116, v121);
            local v122, v123 = v121:await();

            if not v122 then
                for _, v2 in ipairs(u116) do
                    v2:cancel();
                end;

                return p113(v123);
            end;

            v115[i] = v123;
        end;

        p112(v115);
    end);
end;

function u41.is(p124) -- Line: 657
    -- upvalues: u41 (copy)
    if type(p124) ~= "table" then
        return false;
    end;

    local v125 = getmetatable(p124);

    if v125 == u41 then
        return true;
    end;

    if v125 == nil then
        return type(p124.andThen) == "function";
    end;

    if type(v125) == "table" then
        local v126 = rawget(v125, "__index");

        if type(v126) == "table" then
            local v127 = rawget(v125, "__index");
            local v128 = rawget(v127, "andThen");

            if type(v128) == "function" then
                return true;
            end;
        end;
    end;

    return false;
end;

function u41.promisify(u129) -- Line: 685
    -- upvalues: u41 (copy)
    return function(...) -- Line: 686
        -- upvalues: u41 (ref), u129 (copy)
        return u41._try(debug.traceback(nil, 2), u129, ...);
    end;
end;

local u130 = nil;
local u131 = nil;

function u41.delay(p132) -- Line: 701
    -- upvalues: u41 (copy), u131 (ref), u130 (ref)
    local v133 = type(p132) == "number";
    assert(v133, "Bad argument #1 to Promise.delay, must be a number.");
    local u134 = (p132 < 0.016666666666666666 or p132 == (1 / 0)) and 0.016666666666666666 or p132;

    return u41._new(debug.traceback(nil, 2), function(p135, p136, p137) -- Line: 709
        -- upvalues: u41 (ref), u134 (ref), u131 (ref), u130 (ref)
        local v138 = u41._getTime();
        local v139 = v138 + u134;
        local u140 = {
            resolve = p135,
            startTime = v138,
            endTime = v139
        };

        if u131 == nil then
            u130 = u140;
            u131 = u41._timeEvent:Connect(function() -- Line: 721
                -- upvalues: u41 (ref), u130 (ref), u131 (ref)
                local v141 = u41._getTime();

                while u130 ~= nil and u130.endTime < v141 do
                    local v142 = u130;
                    u130 = v142.next;

                    if u130 == nil then
                        u131:Disconnect();
                        u131 = nil;
                    else
                        u130.previous = nil;
                    end;

                    v142.resolve(u41._getTime() - v142.startTime);
                end;
            end);
        elseif u130.endTime < v139 then
            local v143 = u130;
            local next2 = v143.next;

            while next2 ~= nil and next2.endTime < v139 do
                v143 = next2;
                next2 = next2.next;
            end;

            v143.next = u140;
            u140.previous = v143;

            if next2 ~= nil then
                u140.next = next2;
                next2.previous = u140;
            end;
        else
            u140.next = u130;
            u130.previous = u140;
            u130 = u140;
        end;

        p137(function() -- Line: 766
            -- upvalues: u140 (copy), u130 (ref), u131 (ref)
            local next2 = u140.next;

            if u130 == u140 then
                if next2 == nil then
                    u131:Disconnect();
                    u131 = nil;
                else
                    next2.previous = nil;
                end;

                u130 = next2;

                return;
            end;

            local previous = u140.previous;
            previous.next = next2;

            if next2 ~= nil then
                next2.previous = previous;
            end;
        end);
    end);
end;

function u41.prototype.timeout(p144, u145, u146) -- Line: 795
    -- upvalues: u41 (copy), u7 (ref)
    local u147 = debug.traceback(nil, 2);

    return u41.race({ u41.delay(u145):andThen(function() -- Line: 799
            -- upvalues: u41 (ref), u146 (copy), u7 (ref), u145 (copy), u147 (copy)
            return u41.reject(u146 == nil and u7.new({
                error = "Timed out",
                kind = u7.Kind.TimedOut,
                context = string.format("Timeout of %d seconds exceeded.\n:timeout() called at:\n\n%s", u145, u147)
            }) or u146);
        end), p144 });
end;

function u41.prototype.getStatus(p148) -- Line: 814
    return p148._status;
end;

function u41.prototype._andThen(u149, u150, u151, u152) -- Line: 823
    -- upvalues: u41 (copy), runExecutor (copy), u7 (ref)
    u149._unhandledRejection = false;

    return u41._new(u150, function(u153, u154) -- Line: 827
        -- upvalues: u151 (copy), u150 (copy), runExecutor (ref), u152 (copy), u149 (copy), u41 (ref), u7 (ref)
        local v155;

        if u151 then
            local u156 = u150;
            local u157 = u151;

            v155 = function(...) -- Line: 160
                -- upvalues: runExecutor (ref), u156 (copy), u157 (copy), u153 (copy), u154 (copy)
                local v158, v159, v160 = runExecutor(u156, u157, ...);

                if v158 then
                    u153(unpack(v160, 1, v159));

                    return;
                end;

                u154(v160[1]);
            end;
        else
            v155 = u153;
        end;

        local v161;

        if u152 then
            local u162 = u150;
            local u163 = u152;

            v161 = function(...) -- Line: 160
                -- upvalues: runExecutor (ref), u162 (copy), u163 (copy), u153 (copy), u154 (copy)
                local v164, v165, v166 = runExecutor(u162, u163, ...);

                if v164 then
                    u153(unpack(v166, 1, v165));

                    return;
                end;

                u154(v166[1]);
            end;
        else
            v161 = u154;
        end;

        if u149._status == u41.Status.Started then
            table.insert(u149._queuedResolve, v155);
            table.insert(u149._queuedReject, v161);

            return;
        end;

        if u149._status == u41.Status.Resolved then
            v155(unpack(u149._values, 1, u149._valuesLength));

            return;
        end;

        if u149._status == u41.Status.Rejected then
            v161(unpack(u149._values, 1, u149._valuesLength));

            return;
        end;

        if u149._status == u41.Status.Cancelled then
            u154(u7.new({
                error = "Promise is cancelled",
                kind = u7.Kind.AlreadyCancelled,
                context = "Promise created at\n\n" .. u150
            }));
        end;
    end, u149);
end;

function u41.prototype.andThen(p167, p168, p169) -- Line: 873
    local v170 = p168 == nil and true or type(p168) == "function";
    assert(v170, string.format("Please pass a handler function to %s!", "Promise:andThen"));
    local v171 = p169 == nil and true or type(p169) == "function";
    assert(v171, string.format("Please pass a handler function to %s!", "Promise:andThen"));

    return p167:_andThen(debug.traceback(nil, 2), p168, p169);
end;

function u41.prototype.catch(p172, p173) -- Line: 889
    local v174 = p173 == nil and true or type(p173) == "function";
    assert(v174, string.format("Please pass a handler function to %s!", "Promise:catch"));

    return p172:_andThen(debug.traceback(nil, 2), nil, p173);
end;

function u41.prototype.tap(p175, u176) -- Line: 901
    -- upvalues: u41 (copy), pack (copy)
    local v177 = type(u176) == "function";
    assert(v177, string.format("Please pass a handler function to %s!", "Promise:tap"));

    return p175:_andThen(debug.traceback(nil, 2), function(...) -- Line: 903
        -- upvalues: u176 (copy), u41 (ref), pack (ref)
        local v178 = u176(...);

        if not u41.is(v178) then
            return ...;
        end;

        local u179, u180 = pack(...);

        return v178:andThen(function() -- Line: 908
            -- upvalues: u180 (copy), u179 (copy)
            return unpack(u180, 1, u179);
        end);
    end);
end;

function u41.prototype.andThenCall(p181, u182, ...) -- Line: 920
    -- upvalues: pack (copy)
    local v183 = type(u182) == "function";
    assert(v183, string.format("Please pass a handler function to %s!", "Promise:andThenCall"));
    local u184, u185 = pack(...);

    return p181:_andThen(debug.traceback(nil, 2), function() -- Line: 923
        -- upvalues: u182 (copy), u185 (copy), u184 (copy)
        return u182(unpack(u185, 1, u184));
    end);
end;

function u41.prototype.andThenReturn(p186, ...) -- Line: 931
    -- upvalues: pack (copy)
    local u187, u188 = pack(...);

    return p186:_andThen(debug.traceback(nil, 2), function() -- Line: 933
        -- upvalues: u188 (copy), u187 (copy)
        return unpack(u188, 1, u187);
    end);
end;

function u41.prototype.cancel(p189) -- Line: 942
    -- upvalues: u41 (copy)
    if p189._status ~= u41.Status.Started then
        return;
    end;

    p189._status = u41.Status.Cancelled;

    if p189._cancellationHook then
        p189._cancellationHook();
    end;

    if p189._parent then
        p189._parent:_consumerCancelled(p189);
    end;

    for i in pairs(p189._consumers) do
        i:cancel();
    end;

    p189:_finalize();
end;

function u41.prototype._consumerCancelled(p190, p191) -- Line: 968
    -- upvalues: u41 (copy)
    if p190._status ~= u41.Status.Started then
        return;
    end;

    p190._consumers[p191] = nil;

    if next(p190._consumers) == nil then
        p190:cancel();
    end;
end;

function u41.prototype._finally(u192, u193, u194, u195) -- Line: 984
    -- upvalues: u41 (copy), runExecutor (copy)
    if not u195 then
        u192._unhandledRejection = false;
    end;

    return u41._new(u193, function(u196, u197) -- Line: 990
        -- upvalues: u194 (copy), u193 (copy), runExecutor (ref), u195 (copy), u192 (copy), u41 (ref)
        local u198;

        if u194 then
            local u199 = u193;
            local u200 = u194;

            u198 = function(...) -- Line: 160
                -- upvalues: runExecutor (ref), u199 (copy), u200 (copy), u196 (copy), u197 (copy)
                local v201, v202, v203 = runExecutor(u199, u200, ...);

                if v201 then
                    u196(unpack(v203, 1, v202));

                    return;
                end;

                u197(v203[1]);
            end;
        else
            u198 = u196;
        end;

        local v204 = u195 and function(...) -- Line: 1003
            -- upvalues: u192 (ref), u41 (ref), u196 (copy), u198 (copy)
            if u192._status == u41.Status.Rejected then
                return u196(u192);
            end;

            return u198(...);
        end or u198;

        if u192._status == u41.Status.Started then
            table.insert(u192._queuedFinally, v204);

            return;
        end;

        v204(u192._status);
    end, u192);
end;

function u41.prototype.finally(p205, p206) -- Line: 1022
    local v207 = p206 == nil and true or type(p206) == "function";
    assert(v207, string.format("Please pass a handler function to %s!", "Promise:finally"));

    return p205:_finally(debug.traceback(nil, 2), p206);
end;

function u41.prototype.finallyCall(p208, u209, ...) -- Line: 1033
    -- upvalues: pack (copy)
    local v210 = type(u209) == "function";
    assert(v210, string.format("Please pass a handler function to %s!", "Promise:finallyCall"));
    local u211, u212 = pack(...);

    return p208:_finally(debug.traceback(nil, 2), function() -- Line: 1036
        -- upvalues: u209 (copy), u212 (copy), u211 (copy)
        return u209(unpack(u212, 1, u211));
    end);
end;

function u41.prototype.finallyReturn(p213, ...) -- Line: 1044
    -- upvalues: pack (copy)
    local u214, u215 = pack(...);

    return p213:_finally(debug.traceback(nil, 2), function() -- Line: 1046
        -- upvalues: u215 (copy), u214 (copy)
        return unpack(u215, 1, u214);
    end);
end;

function u41.prototype.done(p216, p217) -- Line: 1054
    local v218 = p217 == nil and true or type(p217) == "function";
    assert(v218, string.format("Please pass a handler function to %s!", "Promise:done"));

    return p216:_finally(debug.traceback(nil, 2), p217, true);
end;

function u41.prototype.doneCall(p219, u220, ...) -- Line: 1065
    -- upvalues: pack (copy)
    local v221 = type(u220) == "function";
    assert(v221, string.format("Please pass a handler function to %s!", "Promise:doneCall"));
    local u222, u223 = pack(...);

    return p219:_finally(debug.traceback(nil, 2), function() -- Line: 1068
        -- upvalues: u220 (copy), u223 (copy), u222 (copy)
        return u220(unpack(u223, 1, u222));
    end, true);
end;

function u41.prototype.doneReturn(p224, ...) -- Line: 1076
    -- upvalues: pack (copy)
    local u225, u226 = pack(...);

    return p224:_finally(debug.traceback(nil, 2), function() -- Line: 1078
        -- upvalues: u226 (copy), u225 (copy)
        return unpack(u226, 1, u225);
    end, true);
end;

function u41.prototype.awaitStatus(p227) -- Line: 1088
    -- upvalues: u41 (copy)
    p227._unhandledRejection = false;

    if p227._status == u41.Status.Started then
        local BindableEvent = Instance.new("BindableEvent");
        p227:finally(function() -- Line: 1094
            -- upvalues: BindableEvent (copy)
            BindableEvent:Fire();
        end);
        BindableEvent.Event:Wait();
        BindableEvent:Destroy();
    end;

    if p227._status == u41.Status.Resolved then
        return p227._status, unpack(p227._values, 1, p227._valuesLength);
    end;

    if p227._status == u41.Status.Rejected then
        return p227._status, unpack(p227._values, 1, p227._valuesLength);
    end;

    return p227._status;
end;

local function awaitHelper(p228, ...) -- Line: 1111
    -- upvalues: u41 (copy)
    return p228 == u41.Status.Resolved, ...;
end;

function u41.prototype.await(p229) -- Line: 1118
    -- upvalues: awaitHelper (copy)
    return awaitHelper(p229:awaitStatus());
end;

local function expectHelper(p230, ...) -- Line: 1122
    -- upvalues: u41 (copy)
    if p230 ~= u41.Status.Resolved then
        error(... == nil and "Expected Promise rejected with no value." or ..., 3);
    end;

    return ...;
end;

function u41.prototype.expect(p231) -- Line: 1134
    -- upvalues: expectHelper (copy)
    return expectHelper(p231:awaitStatus());
end;

u41.prototype.awaitValue = u41.prototype.expect;

function u41.prototype._unwrap(p232) -- Line: 1148
    -- upvalues: u41 (copy)
    if p232._status == u41.Status.Started then
        error("Promise has not resolved or rejected.", 2);
    end;

    return p232._status == u41.Status.Resolved, unpack(p232._values, 1, p232._valuesLength);
end;

function u41.prototype._resolve(u233, ...) -- Line: 1158
    -- upvalues: u41 (copy), u7 (ref), pack (copy)
    if u233._status ~= u41.Status.Started then
        if u41.is((...)) then
            (...):_consumerCancelled(u233);
        end;

        return;
    end;

    if u41.is((...)) then
        if select("#", ...) > 1 then
            local v234 = string.format("When returning a Promise from andThen, extra arguments are discarded! See:\n\n%s", u233._source);
            warn(v234);
        end;

        local u235 = ...;
        local v237 = u235:andThen(function(...) -- Line: 1181
            -- upvalues: u233 (copy)
            u233:_resolve(...);
        end, function(...) -- Line: 1184
            -- upvalues: u235 (copy), u7 (ref), u233 (copy)
            local v236 = u235._values[1];

            if u235._error then
                v236 = u7.new({
                    context = "[No stack trace available as this Promise originated from an older version of the Promise library (< v2)]",
                    error = u235._error,
                    kind = u7.Kind.ExecutionError
                });
            end;

            if u7.isKind(v236, u7.Kind.ExecutionError) then
                return u233:_reject(v236:extend({
                    error = "This Promise was chained to a Promise that errored.",
                    trace = "",
                    context = string.format("The Promise at:\n\n%s\n...Rejected because it was chained to the following Promise, which encountered an error:\n", u233._source)
                }));
            end;

            u233:_reject(...);
        end);

        if v237._status == u41.Status.Cancelled then
            u233:cancel();

            return;
        end;

        if v237._status == u41.Status.Started then
            u233._parent = v237;
            v237._consumers[u233] = true;
        end;

        return;
    end;

    u233._status = u41.Status.Resolved;
    local v238, v239 = pack(...);
    u233._valuesLength = v238;
    u233._values = v239;

    for _, v in ipairs(u233._queuedResolve) do
        coroutine.wrap(v)(...);
    end;

    u233:_finalize();
end;

function u41.prototype._reject(u240, ...) -- Line: 1233
    -- upvalues: u41 (copy), pack (copy)
    if u240._status ~= u41.Status.Started then
        return;
    end;

    u240._status = u41.Status.Rejected;
    local v241, v242 = pack(...);
    u240._valuesLength = v241;
    u240._values = v242;

    if next(u240._queuedReject) == nil then
        local u243 = tostring((...));
        coroutine.wrap(function() -- Line: 1255
            -- upvalues: u41 (ref), u240 (copy), u243 (copy)
            u41._timeEvent:Wait();

            if not u240._unhandledRejection then
                return;
            end;

            local v244 = string.format("Unhandled Promise rejection:\n\n%s\n\n%s", u243, u240._source);

            if u41.TEST then
                return;
            end;

            warn(v244);
        end)();
    else
        for _, v in ipairs(u240._queuedReject) do
            coroutine.wrap(v)(...);
        end;
    end;

    u240:_finalize();
end;

function u41.prototype._finalize(p245) -- Line: 1287
    -- upvalues: u41 (copy)
    for _, v in ipairs(p245._queuedFinally) do
        coroutine.wrap(v)(p245._status);
    end;

    p245._queuedFinally = nil;
    p245._queuedReject = nil;
    p245._queuedResolve = nil;

    if not u41.TEST then
        p245._parent = nil;
        p245._consumers = nil;
    end;
end;

function u41.prototype.now(p246, p247) -- Line: 1310
    -- upvalues: u41 (copy), u7 (ref)
    local v248 = debug.traceback(nil, 2);

    if p246:getStatus() == u41.Status.Resolved then
        return p246:_andThen(v248, function(...) -- Line: 1313
            return ...;
        end);
    end;

    local reject = u41.reject;

    if p247 == nil then
        p247 = u7.new({
            error = "This Promise was not resolved in time for :now()",
            kind = u7.Kind.NotResolvedInTime,
            context = ":now() was called at:\n\n" .. v248
        }) or p247;
    end;

    return reject(p247);
end;

function u41.retry(u249, u250, ...) -- Line: 1328
    -- upvalues: u41 (copy)
    local v251 = type(u249) == "function";
    assert(v251, "Parameter #1 to Promise.retry must be a function");
    local v252 = type(u250) == "number";
    assert(v252, "Parameter #2 to Promise.retry must be a number");
    local u253 = { ... };
    local u254 = select("#", ...);

    return u41.resolve(u249(...)):catch(function(...) -- Line: 1334
        -- upvalues: u250 (copy), u41 (ref), u249 (copy), u253 (copy), u254 (copy)
        if u250 > 0 then
            return u41.retry(u249, u250 - 1, unpack(u253, 1, u254));
        end;

        return u41.reject(...);
    end);
end;

function u41.fromEvent(u255, p256) -- Line: 1347
    -- upvalues: u41 (copy)
    local u257 = p256 or function() -- Line: 1348
        return true;
    end;

    return u41._new(debug.traceback(nil, 2), function(u258, p259, p260) -- Line: 1352
        -- upvalues: u255 (copy), u257 (ref)
        local u261 = nil;
        local u262 = false;

        local function disconnect() -- Line: 1356
            -- upvalues: u261 (ref)
            u261:Disconnect();
            u261 = nil;
        end;

        u261 = u255:Connect(function(...) -- Line: 1365
            -- upvalues: u257 (ref), u258 (copy), u261 (ref), u262 (ref)
            local v263 = u257(...);

            if v263 ~= true then
                if type(v263) ~= "boolean" then
                    error("Promise.fromEvent predicate should always return a boolean");
                end;

                return;
            end;

            u258(...);

            if not u261 then
                u262 = true;

                return;
            end;

            u261:Disconnect();
            u261 = nil;
        end);

        if u262 and u261 then
            return disconnect();
        end;

        p260(function() -- Line: 1385
            -- upvalues: u261 (ref)
            u261:Disconnect();
            u261 = nil;
        end);
    end);
end;

return u41;