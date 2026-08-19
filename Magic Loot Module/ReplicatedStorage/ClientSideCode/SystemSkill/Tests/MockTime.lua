-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 9
    -- upvalues: u1 (copy)
    local v3 = setmetatable({}, u1);
    v3._now = p2 or 0;

    return v3;
end;

function u1.advance(p4, p5) -- Line: 15
    p4._now = p4._now + (p5 or 0);

    return p4._now;
end;

function u1.set(p6, p7) -- Line: 20
    p6._now = p7;

    return p6._now;
end;

function u1.now(p8) -- Line: 25
    return p8._now;
end;

return u1;