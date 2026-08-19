-- Decompiled with Potassium's decompiler.

local function switch_switch(p1, p2, ...) -- Line: 6
    if p2 ~= p1._state then
        p1._state = p2;
        p1._fn(p2, ...);
    end;
end;

local function switch_get(p3) -- Line: 13
    return p3._state;
end;

return {
    new = function(p4, p5) -- Line: 18, Name: switch_new
        -- upvalues: switch_switch (copy), switch_get (copy)
        assert(p4 ~= nil, "A default state must be provided");

        return {
            _fn = p5,
            _state = p4,
            Switch = switch_switch,
            Get = switch_get
        };
    end
};