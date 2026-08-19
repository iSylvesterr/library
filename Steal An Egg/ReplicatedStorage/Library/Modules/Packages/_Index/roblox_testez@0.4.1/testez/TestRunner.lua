-- Decompiled with Potassium's decompiler.

local TestEnum = require(script.Parent.TestEnum);
local TestSession = require(script.Parent.TestSession);
local LifecycleHooks = require(script.Parent.LifecycleHooks);
local u1 = {
    environment = {}
};

local function wrapExpectContextWithPublicApi(u2) -- Line: 19
    return setmetatable({
        extend = function(...) -- Line: 21, Name: extend
            -- upvalues: u2 (copy)
            u2:extend(...);
        end
    }, {
        __call = function(p3, ...) -- Line: 25, Name: __call
            -- upvalues: u2 (copy)
            return u2:startExpectationChain(...);
        end
    });
end;

function u1.runPlan(p4) -- Line: 35
    -- upvalues: TestSession (copy), LifecycleHooks (copy), TestEnum (copy), u1 (copy)
    local v5 = TestSession.new(p4);
    local v6 = LifecycleHooks.new();
    v5.hasFocusNodes = #p4:findNodes(function(p7) -- Line: 39
        -- upvalues: TestEnum (ref)
        return p7.modifier == TestEnum.NodeModifier.Focus;
    end) > 0;
    u1.runPlanNode(v5, p4, v6);

    return v5:finalize();
end;

function u1.runPlanNode(u8, p9, u10) -- Line: 54
    -- upvalues: u1 (copy), wrapExpectContextWithPublicApi (copy), TestEnum (copy)
    local function runCallback(u11, p12) -- Line: 55
        -- upvalues: u1 (ref), wrapExpectContextWithPublicApi (ref), u8 (copy)
        _G.__TESTEZ_RUNNING_TEST__ = true;
        local v13 = getfenv(u11);
        local u14 = true;
        local u15 = nil;
        local u16 = p12 or "";

        for i, v in pairs(u1.environment) do
            v13[i] = v;
        end;

        function v13.fail(p17) -- Line: 71
            -- upvalues: u14 (ref), u15 (ref), u16 (ref)
            u14 = false;
            u15 = u16 .. debug.traceback(tostring(p17 == nil and "fail() was called." or p17), 2);
        end;

        v13.expect = wrapExpectContextWithPublicApi(u8:getExpectationContext());
        local u18 = u8:getContext();
        local v20, v21 = xpcall(function() -- Line: 84
            -- upvalues: u11 (copy), u18 (copy)
            u11(u18);
        end, function(p19) -- Line: 86
            -- upvalues: u16 (ref)
            return u16 .. debug.traceback(tostring(p19), 2);
        end);

        if not v20 then
            u14 = false;
            u15 = v21;
        end;

        _G.__TESTEZ_RUNNING_TEST__ = nil;

        return u14, u15;
    end;

    u10:pushHooksFrom(p9);
    local v22 = false;

    local function runNode(p23) -- Line: 102
        -- upvalues: u10 (copy), runCallback (copy)
        for _, v in ipairs(u10:getBeforeEachHooks()) do
            local v24, v25 = runCallback(v, "beforeEach hook: ");

            if not v24 then
                return false, v25;
            end;
        end;

        local v26, v27 = runCallback(p23.callback);

        for _, v in ipairs(u10:getAfterEachHooks()) do
            local v28, v29 = runCallback(v, "afterEach hook: ");

            if not v28 then
                if v26 then
                    return false, v29;
                end;

                return false, v27 .. "\nWhile cleaning up the failed test another error was found:\n" .. v29;
            end;
        end;

        if v26 then
            return true, nil;
        end;

        return false, v27;
    end;

    for _, v in ipairs(u10:getBeforeAllHooks()) do
        local v30, v31 = runCallback(v, "beforeAll hook: ");

        if not v30 then
            u8:addDummyError("beforeAll", v31);
            v22 = true;
        end;
    end;

    if not v22 then
        for _, v in ipairs(p9.children) do
            if v.type == TestEnum.NodeType.It then
                u8:pushNode(v);

                if u8:shouldSkip() then
                    u8:setSkipped();
                else
                    local v32, v33 = runNode(v);

                    if v32 then
                        u8:setSuccess();
                    else
                        u8:setError(v33);
                    end;
                end;

                u8:popNode();
            elseif v.type == TestEnum.NodeType.Describe then
                u8:pushNode(v);
                u1.runPlanNode(u8, v, u10);

                if v.loadError then
                    u8:setError("Error during planning: " .. v.loadError);
                else
                    u8:setStatusFromChildren();
                end;

                u8:popNode();
            end;
        end;
    end;

    for _, v in ipairs(u10:getAfterAllHooks()) do
        local v34, v35 = runCallback(v, "afterAll hook: ");

        if not v34 then
            u8:addDummyError("afterAll", v35);
        end;
    end;

    u10:popHooks();
end;

return u1;