-- Decompiled with Potassium's decompiler.

local u1 = {
    foo = function() -- Line: 15, Name: foo
        return "test foo";
    end
};

function u1.new() -- Line: 19
    -- upvalues: u1 (copy)
    return setmetatable({
        _privateTest = "private test"
    }, {
        __index = u1
    });
end;

local v2 = u1.new();

function v2.eatRocks(p3) -- Line: 41
    return "";
end;

function v2.die(p4) -- Line: 45
    return true;
end;

return v2;