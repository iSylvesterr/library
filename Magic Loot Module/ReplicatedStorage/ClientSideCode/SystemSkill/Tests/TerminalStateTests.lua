-- Decompiled with Potassium's decompiler.

local SkillModuleValidator = require(script.Parent.Parent.BaseSkill.SkillModuleValidator);
local SkillStateRuntime = require(script.Parent.Parent.BaseSkill.SkillStateRuntime);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);
local u1 = {
    InitialState = "Startup",
    States = {
        Startup = {
            Duration = 0.5
        },
        Finished = {
            Duration = 0,
            IsTerminal = true
        },
        Interrupted = {
            Duration = 0,
            IsTerminal = true
        }
    },
    Transitions = {
        {
            From = "Startup",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Startup",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        }
    }
};

local function createInstance(p2) -- Line: 25
    -- upvalues: u1 (copy)
    return {
        skillName = "TerminalTest",
        nowTime = 1,
        skillModule = u1,
        skillRunData = {
            State = {
                enteredAt = 0,
                transitionLocked = false,
                version = 1,
                current = p2
            }
        }
    };
end;

local u13 = {
    {
        name = "tryTransition_FromFinished_RejectsAnyEvent",

        fn = function() -- Line: 45, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v3 = createInstance("Finished");
            local v4 = SkillStateRuntime.tryTransition(v3, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 48, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 49, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 50, Name: onTerminalReached
                end
            });
            TestRunner.assert(not v4);
            TestRunner.assertEqual(v3.skillRunData.State.current, "Finished");
        end
    },
    {
        name = "tryTransition_FromInterrupted_RejectsAnyEvent",

        fn = function() -- Line: 58, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v5 = createInstance("Interrupted");
            local v6 = SkillStateRuntime.tryTransition(v5, SkillEventConst.Interrupt, nil, {
                callEnterHandler = function() -- Line: 61, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 62, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 63, Name: onTerminalReached
                end
            });
            TestRunner.assert(not v6);
            TestRunner.assertEqual(v5.skillRunData.State.current, "Interrupted");
        end
    },
    {
        name = "validateBaseSkill_TerminalHasOutgoing_Fails",

        fn = function() -- Line: 71, Name: fn
            -- upvalues: SkillEventConst (copy), SkillModuleValidator (copy), TestRunner (copy)
            local v7 = SkillModuleValidator.validateBaseSkill({
                InitialState = "Startup",
                States = {
                    Startup = {
                        Duration = 0.5
                    },
                    Finished = {
                        Duration = 0,
                        IsTerminal = true
                    }
                },
                Transitions = {
                    {
                        From = "Startup",
                        To = "Finished",
                        Event = SkillEventConst.StateTimeout
                    },
                    {
                        From = "Finished",
                        To = "Startup",
                        Event = "Resurrect"
                    }
                }
            }, {
                skillName = "BadTerminal"
            });
            TestRunner.assert(not v7);
        end
    },
    {
        name = "tryTransition_ToTerminal_OnTerminalReachedCalled",

        fn = function() -- Line: 89, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v8 = createInstance("Startup");
            local u9 = nil;
            local v12 = SkillStateRuntime.tryTransition(v8, SkillEventConst.Interrupt, nil, {
                callEnterHandler = function() -- Line: 93, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 94, Name: callExitHandler
                end,

                onTerminalReached = function(p10, p11) -- Line: 95, Name: onTerminalReached
                    -- upvalues: u9 (ref)
                    u9 = p11;
                end
            });
            TestRunner.assert(v12);
            TestRunner.assertEqual(u9, "Interrupted");
        end
    }
};

return {
    run = function() -- Line: 104, Name: run
        -- upvalues: TestRunner (copy), u13 (copy)
        return TestRunner.run("TerminalState", u13);
    end
};