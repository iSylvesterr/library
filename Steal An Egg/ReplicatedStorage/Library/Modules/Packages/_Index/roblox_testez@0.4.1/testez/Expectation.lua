-- Decompiled with Potassium's decompiler.

local u1 = {};
local u2 = {
    to = true,
    be = true,
    been = true,
    have = true,
    was = true,
    at = true
};
local u3 = {
    never = true
};

local function assertLevel(p4, p5, p6) -- Line: 42
    local v7 = p5 or "Assertion failed!";
    local v8 = p6 or 1;

    if not p4 then
        error(v7, v8 + 1);
    end;
end;

local function bindSelf(u9, u10) -- Line: 54
    return function(p11, ...) -- Line: 55
        -- upvalues: u9 (copy), u10 (copy)
        if p11 == u9 then
            return u10(u9, ...);
        end;

        return u10(u9, p11, ...);
    end;
end;

local function formatMessage(p12, p13, p14) -- Line: 64
    if p12 then
        return p13;
    end;

    return p14;
end;

function u1.new(p15) -- Line: 75
    -- upvalues: u1 (copy)
    local u16 = {
        successCondition = true,
        condition = false,
        value = p15,
        matchers = {},
        _boundMatchers = {}
    };
    setmetatable(u16, u1);
    local a = u16.a;

    function u16.a(p17, ...) -- Line: 55
        -- upvalues: u16 (copy), a (copy)
        if p17 == u16 then
            return a(u16, ...);
        end;

        return a(u16, p17, ...);
    end;

    u16.an = u16.a;
    local ok = u16.ok;

    function u16.ok(p18, ...) -- Line: 55
        -- upvalues: u16 (copy), ok (copy)
        if p18 == u16 then
            return ok(u16, ...);
        end;

        return ok(u16, p18, ...);
    end;

    local equal = u16.equal;

    function u16.equal(p19, ...) -- Line: 55
        -- upvalues: u16 (copy), equal (copy)
        if p19 == u16 then
            return equal(u16, ...);
        end;

        return equal(u16, p19, ...);
    end;

    local throw = u16.throw;

    function u16.throw(p20, ...) -- Line: 55
        -- upvalues: u16 (copy), throw (copy)
        if p20 == u16 then
            return throw(u16, ...);
        end;

        return throw(u16, p20, ...);
    end;

    local near = u16.near;

    function u16.near(p21, ...) -- Line: 55
        -- upvalues: u16 (copy), near (copy)
        if p21 == u16 then
            return near(u16, ...);
        end;

        return near(u16, p21, ...);
    end;

    return u16;
end;

function u1.checkMatcherNameCollisions(p22) -- Line: 96
    -- upvalues: u2 (copy), u3 (copy), u1 (copy)
    return not (u2[p22] or (u3[p22] or u1[p22]));
end;

function u1.extend(u23, p24) -- Line: 104
    u23.matchers = p24 or {};

    for i, v in pairs(u23.matchers) do
        local function u29(p25, ...) -- Line: 108
            -- upvalues: v (copy), u23 (copy)
            local v26 = v(u23.value, ...);
            local v27 = v26.message or "Assertion failed!";
            local v28 = 3 or 1;

            if not (v26.pass == u23.successCondition) then
                error(v27, v28 + 1);
            end;

            u23:_resetModifiers();

            return u23;
        end;

        u23._boundMatchers[i] = function(p30, ...) -- Line: 55
            -- upvalues: u23 (copy), u29 (copy)
            if p30 == u23 then
                return u29(u23, ...);
            end;

            return u29(u23, p30, ...);
        end;
    end;

    return u23;
end;

function u1.__index(p31, p32) -- Line: 121
    -- upvalues: u2 (copy), u3 (copy), u1 (copy)
    if u2[p32] then
        return p31;
    end;

    if not u3[p32] then
        if p31._boundMatchers[p32] then
            return p31._boundMatchers[p32];
        end;

        return u1[p32];
    end;

    local v33 = u1.new(p31.value):extend(p31.matchers);
    v33.successCondition = not p31.successCondition;

    return v33;
end;

function u1._resetModifiers(p34) -- Line: 154
    p34.successCondition = true;
end;

function u1.a(p35, p36) -- Line: 163
    local v37 = type(p35.value) == p36 == p35.successCondition;
    local successCondition = p35.successCondition;
    local v38 = ("Expected value of type %q, got value %q of type %s"):format(p36, tostring(p35.value), (type(p35.value)));
    local v39 = ("Expected value not of type %q, got value %q of type %s"):format(p36, tostring(p35.value), (type(p35.value)));

    if successCondition then
        v39 = v38;
    end;

    local v40 = v39 or "Assertion failed!";
    local v41 = 3 or 1;

    if not v37 then
        error(v40, v41 + 1);
    end;

    p35:_resetModifiers();

    return p35;
end;

u1.an = u1.a;

function u1.ok(p42) -- Line: 188
    local v43 = p42.value ~= nil == p42.successCondition;
    local successCondition = p42.successCondition;
    local v44 = ("Expected value %q to be non-nil"):format((tostring(p42.value)));
    local v45 = ("Expected value %q to be nil"):format((tostring(p42.value)));

    if successCondition then
        v45 = v44;
    end;

    local v46 = v45 or "Assertion failed!";
    local v47 = 3 or 1;

    if not v43 then
        error(v46, v47 + 1);
    end;

    p42:_resetModifiers();

    return p42;
end;

function u1.equal(p48, p49) -- Line: 206
    local v50 = p48.value == p49 == p48.successCondition;
    local successCondition = p48.successCondition;
    local v51 = ("Expected value %q (%s), got %q (%s) instead"):format(tostring(p49), type(p49), tostring(p48.value), (type(p48.value)));
    local v52 = ("Expected anything but value %q (%s)"):format(tostring(p49), (type(p49)));

    if successCondition then
        v52 = v51;
    end;

    local v53 = v52 or "Assertion failed!";
    local v54 = 3 or 1;

    if not v50 then
        error(v53, v54 + 1);
    end;

    p48:_resetModifiers();

    return p48;
end;

function u1.near(p55, p56, p57) -- Line: 230
    local v58 = type(p55.value) == "number";
    assert(v58, "Expectation value must be a number to use \'near\'");
    local v59 = type(p56) == "number";
    assert(v59, "otherValue must be a number");
    local v60 = type(p57) == "number" and true or p57 == nil;
    assert(v60, "limit must be a number or nil");
    local v61 = p57 or 1e-7;
    local v62 = math.abs(p55.value - p56) <= v61 == p55.successCondition;
    local successCondition = p55.successCondition;
    local v63 = ("Expected value to be near %f (within %f) but got %f instead"):format(p56, v61, p55.value);
    local v64 = ("Expected value to not be near %f (within %f) but got %f instead"):format(p56, v61, p55.value);

    if successCondition then
        v64 = v63;
    end;

    local v65 = v64 or "Assertion failed!";
    local v66 = 3 or 1;

    if not v62 then
        error(v65, v66 + 1);
    end;

    p55:_resetModifiers();

    return p55;
end;

function u1.throw(p67, p68) -- Line: 256
    local success, result = pcall(p67.value);
    local v69 = success ~= p67.successCondition;

    if p68 and not success then
        if p67.successCondition then
            v69 = result:find(p68, 1, true) ~= nil;
        else
            v69 = result:find(p68, 1, true) == nil;
        end;
    end;

    local v70;

    if p68 then
        local successCondition = p67.successCondition;
        v70 = ("Expected function to throw an error containing %q, but it %s"):format(p68, result and (("threw: %s"):format(result) or "did not throw.") or "did not throw.");
        local v71 = ("Expected function to never throw an error containing %q, but it threw: %s"):format(p68, (tostring(result)));

        if not successCondition then
            v70 = v71;
        end;
    else
        v70 = p67.successCondition and "Expected function to throw an error, but it did not throw." or ("Expected function to succeed, but it threw an error: %s"):format((tostring(result)));
    end;

    local v72 = v70 or "Assertion failed!";
    local v73 = 3 or 1;

    if not v69 then
        error(v72, v73 + 1);
    end;

    p67:_resetModifiers();

    return p67;
end;

return u1;