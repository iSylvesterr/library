-- Decompiled with Potassium's decompiler.

local TestEnum = require(script.Parent.TestEnum);
local TestResults = require(script.Parent.TestResults);
local Context = require(script.Parent.Context);
local ExpectationContext = require(script.Parent.ExpectationContext);
local u1 = {};
u1.__index = u1;

function u1.new(p2) -- Line: 24
    -- upvalues: TestResults (copy), u1 (copy)
    local v3 = {
        hasFocusNodes = false,
        results = TestResults.new(p2),
        nodeStack = {},
        contextStack = {},
        expectationContextStack = {}
    };
    setmetatable(v3, u1);

    return v3;
end;

function u1.calculateTotals(p4) -- Line: 42
    -- upvalues: TestEnum (copy)
    local results = p4.results;
    results.successCount = 0;
    results.failureCount = 0;
    results.skippedCount = 0;
    results:visitAllNodes(function(p5) -- Line: 49
        -- upvalues: TestEnum (ref), results (copy)
        local status = p5.status;

        if p5.planNode.type == TestEnum.NodeType.It then
            if status == TestEnum.TestStatus.Success then
                results.successCount = results.successCount + 1;

                return;
            end;

            if status == TestEnum.TestStatus.Failure then
                results.failureCount = results.failureCount + 1;

                return;
            end;

            if status == TestEnum.TestStatus.Skipped then
                results.skippedCount = results.skippedCount + 1;
            end;
        end;
    end);
end;

function u1.gatherErrors(p6) -- Line: 68
    local results = p6.results;
    results.errors = {};
    results:visitAllNodes(function(p7) -- Line: 73
        -- upvalues: results (copy)
        if #p7.errors > 0 then
            for _, v in ipairs(p7.errors) do
                table.insert(results.errors, v);
            end;
        end;
    end);
end;

function u1.finalize(p8) -- Line: 85
    if #p8.nodeStack ~= 0 then
        error("Cannot finalize TestResults with nodes still on the stack!", 2);
    end;

    p8:calculateTotals();
    p8:gatherErrors();

    return p8.results;
end;

function u1.pushNode(p9, p10) -- Line: 99
    -- upvalues: TestResults (copy), Context (copy), ExpectationContext (copy)
    local v11 = TestResults.createNode(p10);
    table.insert((p9.nodeStack[#p9.nodeStack] or p9.results).children, v11);
    table.insert(p9.nodeStack, v11);
    local v12 = Context.new(p9.contextStack[#p9.contextStack]);
    table.insert(p9.contextStack, v12);
    local v13 = ExpectationContext.new(p9.expectationContextStack[#p9.expectationContextStack]);
    table.insert(p9.expectationContextStack, v13);
end;

function u1.popNode(p14) -- Line: 117
    assert(#p14.nodeStack > 0, "Tried to pop from an empty node stack!");
    table.remove(p14.nodeStack, #p14.nodeStack);
    table.remove(p14.contextStack, #p14.contextStack);
    table.remove(p14.expectationContextStack, #p14.expectationContextStack);
end;

function u1.getContext(p15) -- Line: 127
    assert(#p15.contextStack > 0, "Tried to get context from an empty stack!");

    return p15.contextStack[#p15.contextStack];
end;

function u1.getExpectationContext(p16) -- Line: 132
    assert(#p16.expectationContextStack > 0, "Tried to get expectationContext from an empty stack!");

    return p16.expectationContextStack[#p16.expectationContextStack];
end;

function u1.shouldSkip(p17) -- Line: 140
    -- upvalues: TestEnum (copy)
    if p17.hasFocusNodes then
        for i = #p17.nodeStack, 1, -1 do
            local v18 = p17.nodeStack[i];

            if v18.planNode.modifier == TestEnum.NodeModifier.Skip then
                return true;
            end;

            if v18.planNode.modifier == TestEnum.NodeModifier.Focus then
                return false;
            end;
        end;

        return true;
    end;

    for i = #p17.nodeStack, 1, -1 do
        if p17.nodeStack[i].planNode.modifier == TestEnum.NodeModifier.Skip then
            return true;
        end;
    end;

    return false;
end;

function u1.setSuccess(p19) -- Line: 174
    -- upvalues: TestEnum (copy)
    assert(#p19.nodeStack > 0, "Attempting to set success status on empty stack");
    p19.nodeStack[#p19.nodeStack].status = TestEnum.TestStatus.Success;
end;

function u1.setSkipped(p20) -- Line: 182
    -- upvalues: TestEnum (copy)
    assert(#p20.nodeStack > 0, "Attempting to set skipped status on empty stack");
    p20.nodeStack[#p20.nodeStack].status = TestEnum.TestStatus.Skipped;
end;

function u1.setError(p21, p22) -- Line: 191
    -- upvalues: TestEnum (copy)
    assert(#p21.nodeStack > 0, "Attempting to set error status on empty stack");
    local v23 = p21.nodeStack[#p21.nodeStack];
    v23.status = TestEnum.TestStatus.Failure;
    table.insert(v23.errors, p22);
end;

function u1.addDummyError(p24, p25, p26) -- Line: 203
    -- upvalues: TestEnum (copy)
    p24:pushNode({
        type = TestEnum.NodeType.It,
        phrase = p25
    });
    p24:setError(p26);
    p24:popNode();
    p24.nodeStack[#p24.nodeStack].status = TestEnum.TestStatus.Failure;
end;

function u1.setStatusFromChildren(p27) -- Line: 215
    -- upvalues: TestEnum (copy)
    assert(#p27.nodeStack > 0, "Attempting to set status from children on empty stack");
    local v28 = p27.nodeStack[#p27.nodeStack];
    local Success = TestEnum.TestStatus.Success;
    local v29 = true;

    for _, v in ipairs(v28.children) do
        if v.status ~= TestEnum.TestStatus.Skipped then
            v29 = false;

            if v.status == TestEnum.TestStatus.Failure then
                Success = TestEnum.TestStatus.Failure;
            end;
        end;
    end;

    if v29 then
        Success = TestEnum.TestStatus.Skipped;
    end;

    v28.status = Success;
end;

return u1;