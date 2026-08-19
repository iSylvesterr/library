-- Decompiled with Potassium's decompiler.

local v1 = {};
local Constant = require(script.Constant);
local Serializer = require(script.Serializer);
v1.NULL = Constant.NULL;

function v1.stringify(p2, p3, p4, p5) -- Line: 8
    -- upvalues: Serializer (copy)
    local v6 = p4 or 2;
    local v7 = Serializer.new(nil, p5);
    v7:json(p2, p3, v6, v6);

    return v7:toString();
end;

return v1;