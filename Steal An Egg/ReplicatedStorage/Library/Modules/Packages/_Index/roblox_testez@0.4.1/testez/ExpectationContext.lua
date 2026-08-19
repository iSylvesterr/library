-- Decompiled with Potassium's decompiler.

local Expectation = require(script.Parent.Expectation);
local checkMatcherNameCollisions = Expectation.checkMatcherNameCollisions;

local function copy(p1) -- Line: 4
    local v2 = {};

    for i, v in pairs(p1) do
        v2[i] = v;
    end;

    return v2;
end;

local u3 = {};
u3.__index = u3;

function u3.new(p4) -- Line: 17
    -- upvalues: u3 (copy)
    local v5 = {};
    local v6;

    if p4 then
        v6 = {};

        for i, v in pairs(p4._extensions) do
            v6[i] = v;
        end;

        if not v6 then
            v6 = {};
        end;
    else
        v6 = {};
    end;

    v5._extensions = v6;

    return setmetatable(v5, u3);
end;

function u3.startExpectationChain(p7, ...) -- Line: 25
    -- upvalues: Expectation (copy)
    return Expectation.new(...):extend(p7._extensions);
end;

function u3.extend(p8, p9) -- Line: 29
    -- upvalues: checkMatcherNameCollisions (copy)
    for i, v in pairs(p9) do
        assert(p8._extensions[i] == nil, string.format("Cannot reassign %q in expect.extend", i));
        local v10 = checkMatcherNameCollisions(i);
        assert(v10, string.format("Cannot overwrite matcher %q; it already exists", i));
        p8._extensions[i] = v;
    end;
end;

return u3;