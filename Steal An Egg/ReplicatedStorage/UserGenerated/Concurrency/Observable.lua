-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local DeepEquals = require(ReplicatedStorage.UserGenerated.Collections.DeepEquals);
local Bindable = require(ReplicatedStorage.UserGenerated.Concurrency.Bindable);
local v4 = table.freeze({
    Get = function(p1) -- Line: 45, Name: Get
        return p1.Value;
    end,

    Set = function(p2, p3) -- Line: 60, Name: Set
        -- upvalues: DeepEquals (copy)
        if p2.Assertion then
            p3 = p2.Assertion(p3);
        end;

        local Value = p2.Value;
        p2.Value = p3;

        if not DeepEquals(p3, Value) then
            p2.Changed:Fire(p3, Value);
        end;

        return Value;
    end
});
local u5 = table.freeze({
    __index = v4
});

return table.freeze({
    new = function(p6, p7) -- Line: 79, Name: new
        -- upvalues: Bindable (copy), u5 (copy)
        local v8 = type(p6) == "function";
        assert(v8);
        local v9 = p6(p7);
        local v10 = {
            Changed = Bindable.new(),
            Assertion = p6,
            Value = v9
        };
        v10.Readonly = v10;

        return setmetatable(v10, u5);
    end,

    Unasserted = function(p11) -- Line: 92, Name: Unasserted
        -- upvalues: Bindable (copy), u5 (copy)
        local v12 = {
            Changed = Bindable.new(),
            Value = p11
        };
        v12.Readonly = v12;

        return setmetatable(v12, u5);
    end
});