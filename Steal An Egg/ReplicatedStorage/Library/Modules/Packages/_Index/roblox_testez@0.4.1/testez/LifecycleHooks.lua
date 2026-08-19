-- Decompiled with Potassium's decompiler.

local TestEnum = require(script.Parent.TestEnum);
local u1 = {};
u1.__index = u1;

function u1.new() -- Line: 6
    -- upvalues: u1 (copy)
    return setmetatable({
        _stack = {}
    }, u1);
end;

function u1.getBeforeEachHooks(p2) -- Line: 16
    -- upvalues: TestEnum (copy)
    local BeforeEach = TestEnum.NodeType.BeforeEach;
    local v3 = {};

    for _, v in ipairs(p2._stack) do
        for _, v2 in ipairs(v[BeforeEach]) do
            table.insert(v3, v2);
        end;
    end;

    return v3;
end;

function u1.getAfterEachHooks(p4) -- Line: 32
    -- upvalues: TestEnum (copy)
    local AfterEach = TestEnum.NodeType.AfterEach;
    local v5 = {};

    for _, v in ipairs(p4._stack) do
        for _, v2 in ipairs(v[AfterEach]) do
            table.insert(v5, 1, v2);
        end;
    end;

    return v5;
end;

function u1.popHooks(p6) -- Line: 48
    table.remove(p6._stack, #p6._stack);
end;

function u1.pushHooksFrom(p7, p8) -- Line: 52
    -- upvalues: TestEnum (copy)
    assert(p8 ~= nil);
    local _stack = p7._stack;
    local v9 = {
        [TestEnum.NodeType.BeforeAll] = p7:_getHooksOfType(p8.children, TestEnum.NodeType.BeforeAll),
        [TestEnum.NodeType.AfterAll] = p7:_getHooksOfType(p8.children, TestEnum.NodeType.AfterAll),
        [TestEnum.NodeType.BeforeEach] = p7:_getHooksOfType(p8.children, TestEnum.NodeType.BeforeEach),
        [TestEnum.NodeType.AfterEach] = p7:_getHooksOfType(p8.children, TestEnum.NodeType.AfterEach)
    };
    table.insert(_stack, v9);
end;

function u1.getBeforeAllHooks(p10) -- Line: 66
    -- upvalues: TestEnum (copy)
    return p10._stack[#p10._stack][TestEnum.NodeType.BeforeAll];
end;

function u1.getAfterAllHooks(p11) -- Line: 73
    -- upvalues: TestEnum (copy)
    return p11._stack[#p11._stack][TestEnum.NodeType.AfterAll];
end;

function u1._getHooksOfType(p12, p13, p14) -- Line: 77
    local v15 = {};

    for _, v in ipairs(p13) do
        if v.type == p14 then
            table.insert(v15, v.callback);
        end;
    end;

    return v15;
end;

return u1;