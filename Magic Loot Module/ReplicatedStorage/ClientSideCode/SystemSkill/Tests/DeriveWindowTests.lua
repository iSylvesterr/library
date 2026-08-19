-- Decompiled with Potassium's decompiler.

local ChainConditionContext = require(script.Parent.Parent.GroupSkill.ChainConditionContext);
local DeclarativeCondition = require(script.Parent.Parent.GroupSkill.DeclarativeCondition);
local MockRuntime = require(script.Parent.MockRuntime);
local TestRunner = require(script.Parent.TestRunner);

local function createMockBaseSkill(u1, p2, p3) -- Line: 11
    return {
        skillModule = {
            StateOrder = {
                Startup = 1,
                ProjectileFlying = 2,
                Recovery = 3,
                Finished = 4,
                Interrupted = 5
            }
        },
        skillRunData = {
            State = {
                current = u1,
                enteredAt = p2 or 0
            }
        },
        nowTime = p3 or 0,

        getControlState = function() -- Line: 20, Name: getControlState
            return "ChainOpen";
        end,

        isRunningFlow = function() -- Line: 21, Name: isRunningFlow
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

local u16 = {
    {
        name = "DeclarativeCondition_chain_input_True",

        fn = function() -- Line: 28, Name: fn
            -- upvalues: TestRunner (copy), DeclarativeCondition (copy)
            TestRunner.assert(DeclarativeCondition.evaluate({
                type = "chain_input",
                index = 2,
                buffer = 0.25
            }, {
                CheckChainInput = function(p5) -- Line: 30, Name: CheckChainInput
                    return p5 == 2;
                end,

                InWindow = function() -- Line: 31, Name: InWindow
                    return true;
                end,

                StateBefore = function() -- Line: 32, Name: StateBefore
                    return false;
                end,

                StatePassed = function() -- Line: 33, Name: StatePassed
                    return false;
                end
            }));
        end
    },
    {
        name = "DeclarativeCondition_all_Combines",

        fn = function() -- Line: 41, Name: fn
            -- upvalues: TestRunner (copy), DeclarativeCondition (copy)
            TestRunner.assert(DeclarativeCondition.evaluate({
                all = { {
                        type = "chain_input",
                        index = 2
                    }, {
                        type = "window",
                        name = "Combo2"
                    } }
            }, {
                CheckChainInput = function(p6) -- Line: 43, Name: CheckChainInput
                    return p6 == 2;
                end,

                InWindow = function() -- Line: 44, Name: InWindow
                    return true;
                end,

                StateBefore = function() -- Line: 45, Name: StateBefore
                    return false;
                end,

                StatePassed = function() -- Line: 46, Name: StatePassed
                    return false;
                end
            }));
        end
    },
    {
        name = "DeclarativeCondition_all_OneFalse_Fails",

        fn = function() -- Line: 59, Name: fn
            -- upvalues: TestRunner (copy), DeclarativeCondition (copy)
            TestRunner.assert(not DeclarativeCondition.evaluate({
                all = { {
                        type = "chain_input",
                        index = 2
                    }, {
                        type = "window",
                        name = "Combo2"
                    } }
            }, {
                CheckChainInput = function() -- Line: 61, Name: CheckChainInput
                    return false;
                end,

                InWindow = function() -- Line: 62, Name: InWindow
                    return true;
                end,

                StateBefore = function() -- Line: 63, Name: StateBefore
                    return false;
                end,

                StatePassed = function() -- Line: 64, Name: StatePassed
                    return false;
                end
            }));
        end
    },
    {
        name = "DeclarativeCondition_not_Inverts",

        fn = function() -- Line: 77, Name: fn
            -- upvalues: TestRunner (copy), DeclarativeCondition (copy)
            TestRunner.assert(DeclarativeCondition.evaluate({
                ["not"] = {
                    type = "literal",
                    value = false
                }
            }, {
                CheckChainInput = function() -- Line: 79, Name: CheckChainInput
                    return false;
                end,

                InWindow = function() -- Line: 80, Name: InWindow
                    return false;
                end,

                StateBefore = function() -- Line: 81, Name: StateBefore
                    return true;
                end,

                StatePassed = function() -- Line: 82, Name: StatePassed
                    return false;
                end
            }));
        end
    },
    {
        name = "DeclarativeCondition_literal_Value",

        fn = function() -- Line: 90, Name: fn
            -- upvalues: TestRunner (copy), DeclarativeCondition (copy)
            local v7 = {};
            TestRunner.assert(DeclarativeCondition.evaluate({
                type = "literal",
                value = true
            }, v7));
            TestRunner.assert(not DeclarativeCondition.evaluate({
                type = "literal",
                value = false
            }, v7));
        end
    },
    {
        name = "ChainContext_InWindow_ProjectileFlyingToRecovery",

        fn = function() -- Line: 98, Name: fn
            -- upvalues: createMockBaseSkill (copy), MockRuntime (copy), ChainConditionContext (copy), TestRunner (copy)
            local v8 = createMockBaseSkill("ProjectileFlying", 0.2, 0.5);
            local v9 = {
                ChainWindows = {
                    Combo2 = {
                        open = {
                            state = "ProjectileFlying",
                            elapsed = 0.1
                        },
                        close = {
                            state = "Recovery",
                            elapsed = 0.1
                        }
                    }
                }
            };
            local v10 = MockRuntime.new({
                activeBaseSkillIndex = 1,
                nowTime = 0.5,
                baseSkills = { v8 },
                groupSkillModule = v9,
                owner = {
                    groupSkillModule = v9
                }
            });
            local v11 = ChainConditionContext.createChainConditionContext(v10);
            TestRunner.assert(v11.InWindow("Combo2"));
        end
    },
    {
        name = "ChainContext_InWindow_BeforeOpen_ReturnsFalse",

        fn = function() -- Line: 121, Name: fn
            -- upvalues: createMockBaseSkill (copy), MockRuntime (copy), ChainConditionContext (copy), TestRunner (copy)
            local v12 = createMockBaseSkill("Startup", 0, 0.5);
            local v13 = {
                ChainWindows = {
                    Combo2 = {
                        open = {
                            state = "ProjectileFlying",
                            elapsed = 0.1
                        },
                        close = {
                            state = "Recovery",
                            elapsed = 0.1
                        }
                    }
                }
            };
            local v14 = MockRuntime.new({
                activeBaseSkillIndex = 1,
                nowTime = 0.5,
                baseSkills = { v12 },
                groupSkillModule = v13,
                owner = {
                    groupSkillModule = v13
                }
            });
            local v15 = ChainConditionContext.createChainConditionContext(v14);
            TestRunner.assert(not v15.InWindow("Combo2"));
        end
    }
};

return {
    run = function() -- Line: 145, Name: run
        -- upvalues: TestRunner (copy), u16 (copy)
        return TestRunner.run("DeriveWindow", u16);
    end
};