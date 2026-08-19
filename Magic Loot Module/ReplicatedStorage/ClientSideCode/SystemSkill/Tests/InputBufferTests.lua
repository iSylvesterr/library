-- Decompiled with Potassium's decompiler.

local MockRuntime = require(script.Parent.MockRuntime);
local ChainConditionContext = require(script.Parent.Parent.GroupSkill.ChainConditionContext);
local TestRunner = require(script.Parent.TestRunner);

local function createMockBaseSkill(u1, p2, p3) -- Line: 10
    return {
        skillModule = {
            StateOrder = {}
        },
        skillRunData = {
            State = {
                current = u1,
                enteredAt = p2 or 0
            }
        },
        nowTime = p3 or 0,

        getControlState = function() -- Line: 15, Name: getControlState
            return "ChainOpen";
        end,

        isRunningFlow = function() -- Line: 16, Name: isRunningFlow
            -- upvalues: u1 (copy)
            local v4;

            if u1 == "Finished" then
                v4 = false;
            else
                v4 = u1 ~= "Interrupted";
            end;

            return v4;
        end
    };
end;

local u13 = {
    {
        name = "CheckDeriveRequest_WithinBuffer_ReturnsTrue",

        fn = function() -- Line: 23, Name: fn
            -- upvalues: MockRuntime (copy), createMockBaseSkill (copy), ChainConditionContext (copy), TestRunner (copy)
            local v5 = MockRuntime.new({
                nowTime = 0.5,
                deriveRequestByIndex = {
                    [2] = 0.3
                },
                baseSkills = { createMockBaseSkill("Recovery", 0, 0.5) }
            });
            v5.owner = {};
            local v6 = ChainConditionContext.createChainConditionContext(v5);
            TestRunner.assert(v6.CheckChainInput(2, 0.25));
        end
    },
    {
        name = "CheckDeriveRequest_Expired_ReturnsFalse",

        fn = function() -- Line: 36, Name: fn
            -- upvalues: MockRuntime (copy), createMockBaseSkill (copy), ChainConditionContext (copy), TestRunner (copy)
            local v7 = MockRuntime.new({
                nowTime = 0.6,
                deriveRequestByIndex = {
                    [2] = 0.3
                },
                baseSkills = { createMockBaseSkill("Recovery", 0, 0.6) }
            });
            v7.owner = {};
            local v8 = ChainConditionContext.createChainConditionContext(v7);
            TestRunner.assert(not v8.CheckChainInput(2, 0.25));
        end
    },
    {
        name = "CheckInputBuffered_WithinDuration_ReturnsTrue",

        fn = function() -- Line: 49, Name: fn
            -- upvalues: MockRuntime (copy), createMockBaseSkill (copy), ChainConditionContext (copy), TestRunner (copy)
            local v9 = MockRuntime.new({
                nowTime = 0.5,
                inputBuffer = {
                    buttonDown = 0.4
                },
                baseSkills = { createMockBaseSkill("Recovery", 0, 0.5) }
            });
            v9.owner = {};
            local v10 = ChainConditionContext.createChainConditionContext(v9);
            TestRunner.assert(v10.CheckInputBuffered("buttonDown", 0.2));
        end
    },
    {
        name = "CheckInputBuffered_Expired_ReturnsFalse",

        fn = function() -- Line: 62, Name: fn
            -- upvalues: MockRuntime (copy), createMockBaseSkill (copy), ChainConditionContext (copy), TestRunner (copy)
            local v11 = MockRuntime.new({
                nowTime = 0.5,
                inputBuffer = {
                    buttonDown = 0.2
                },
                baseSkills = { createMockBaseSkill("Recovery", 0, 0.5) }
            });
            v11.owner = {};
            local v12 = ChainConditionContext.createChainConditionContext(v11);
            TestRunner.assert(not v12.CheckInputBuffered("buttonDown", 0.2));
        end
    }
};

return {
    run = function() -- Line: 76, Name: run
        -- upvalues: TestRunner (copy), u13 (copy)
        return TestRunner.run("InputBuffer", u13);
    end
};