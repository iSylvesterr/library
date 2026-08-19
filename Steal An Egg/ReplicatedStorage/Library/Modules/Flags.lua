-- Decompiled with Potassium's decompiler.

local u1 = {};
u1.__index = u1;
u1.__type = "BitmaskFlag";

function u1.new(...) -- Line: 9
    -- upvalues: u1 (copy)
    local v2 = {
        Value = bit32.bor(...)
    };

    return setmetatable(v2, u1);
end;

function u1.__call(p3) -- Line: 14
    return p3.Value;
end;

function u1.Get(p4) -- Line: 18
    return p4.Value;
end;

function u1.Set(p5, ...) -- Line: 22
    p5.Value = bit32.bor(...);
end;

function u1.Copy(p6, p7) -- Line: 26
    p6.Value = p7.Value;
end;

function u1.Add(p8, ...) -- Line: 30
    p8.Value = bit32.bor(p8.Value, ...);
end;

function u1.Has(p9, ...) -- Line: 34
    local v10 = bit32.bor(...);

    return bit32.btest(p9.Value, v10);
end;

function u1.Remove(p11, ...) -- Line: 39
    local v12 = bit32.bor(...);
    local v13 = bit32.bnot(v12);
    p11.Value = bit32.band(p11.Value, v13);
end;

function u1.Band(p14, ...) -- Line: 45
    p14.Value = bit32.band(p14.Value, ...);
end;

function u1.Clear(p15) -- Line: 49
    p15.Value = 0;
end;

return u1;