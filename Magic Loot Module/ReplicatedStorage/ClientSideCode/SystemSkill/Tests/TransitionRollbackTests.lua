-- Decompiled with Potassium's decompiler.

local SkillStateRuntime = require(script.Parent.Parent.BaseSkill.SkillStateRuntime);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);
local u1 = {
    InitialState = "Startup",
    States = {
        Startup = {
            Duration = 0.5
        },
        Recovery = {
            Duration = 0.2
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
            To = "Recovery",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Recovery",
            To = "Finished",
            Event = SkillEventConst.StateTimeout
        },
        {
            From = "Startup",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        },
        {
            From = "Recovery",
            To = "Interrupted",
            Event = SkillEventConst.Interrupt
        }
    }
};

local function createInstance(p2) -- Line: 27
    -- upvalues: u1 (copy), SkillStateRuntime (copy)
    return {
        skillName = "RollbackTest",
        nowTime = 1,
        skillModule = u1,
        skillRunData = {
            State = SkillStateRuntime.createStateData(u1)
        }
    };
end;

local u22 = {
    {
        name = "ExitHandler_Throws_TransitionFails_StateUnchanged",

        fn = function() -- Line: 41, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v3 = createInstance("Startup");
            v3.skillRunData.State.current = "Startup";
            v3.skillRunData.State.enteredAt = 0;
            local u4 = nil;
            local v7 = SkillStateRuntime.tryTransition(v3, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 47, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 48, Name: callExitHandler
                    error("ExitHandler intentional error");
                end,

                onTerminalReached = function() -- Line: 51, Name: onTerminalReached
                end,

                onFatalError = function(p5, p6) -- Line: 52, Name: onFatalError
                    -- upvalues: u4 (ref)
                    u4 = p6;
                end
            });
            TestRunner.assert(not v7);
            TestRunner.assertEqual(v3.skillRunData.State.current, "Startup");
            TestRunner.assert(not v3.skillRunData.State.transitionLocked);
            TestRunner.assertEqual(u4, "ExitFailed");
        end
    },
    {
        name = "EnterHandler_Throws_Rollback_StateReverted",

        fn = function() -- Line: 62, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v8 = createInstance("Startup");
            v8.skillRunData.State.current = "Startup";
            v8.skillRunData.State.enteredAt = 0.1;
            v8.skillRunData.State.version = 5;
            local u9 = nil;
            local v12 = SkillStateRuntime.tryTransition(v8, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 69, Name: callEnterHandler
                    error("EnterHandler intentional error");
                end,

                callExitHandler = function() -- Line: 72, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 73, Name: onTerminalReached
                end,

                onFatalError = function(p10, p11) -- Line: 74, Name: onFatalError
                    -- upvalues: u9 (ref)
                    u9 = p11;
                end
            });
            TestRunner.assert(not v12);
            TestRunner.assertEqual(v8.skillRunData.State.current, "Startup");
            TestRunner.assertEqual(v8.skillRunData.State.enteredAt, 0.1);
            TestRunner.assertEqual(v8.skillRunData.State.version, 5);
            TestRunner.assert(not v8.skillRunData.State.transitionLocked);
            TestRunner.assertEqual(u9, "EnterFailed");
        end
    },
    {
        name = "onTerminalReached_Throws_StateStillFinished_NoCrash",

        fn = function() -- Line: 86, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v13 = createInstance("Recovery");
            v13.skillRunData.State.current = "Recovery";
            v13.skillRunData.State.enteredAt = 0;
            v13.nowTime = 0.3;
            local u14 = nil;
            local v17 = SkillStateRuntime.tryTransition(v13, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 93, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 94, Name: callExitHandler
                end,

                onTerminalReached = function(p15, p16) -- Line: 95, Name: onTerminalReached
                    -- upvalues: u14 (ref)
                    u14 = p16;
                    error("onTerminalReached intentional error");
                end
            });
            TestRunner.assert(v17);
            TestRunner.assertEqual(v13.skillRunData.State.current, "Finished");
            TestRunner.assertEqual(u14, "Finished");
        end
    },
    {
        name = "transitionLocked_Reentrancy_SecondCallReturnsFalse",

        fn = function() -- Line: 108, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v18 = createInstance("Startup");
            v18.skillRunData.State.current = "Startup";
            v18.skillRunData.State.enteredAt = 0;
            v18.skillRunData.State.transitionLocked = true;
            local v19 = SkillStateRuntime.tryTransition(v18, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 114, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 115, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 116, Name: onTerminalReached
                end
            });
            TestRunner.assert(not v19);
            TestRunner.assertEqual(v18.skillRunData.State.current, "Startup");
        end
    },
    {
        name = "transitionLocked_NormalFlow_ReleasedAfterSuccess",

        fn = function() -- Line: 124, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v20 = createInstance("Startup");
            v20.skillRunData.State.current = "Startup";
            v20.skillRunData.State.enteredAt = 0;
            SkillStateRuntime.tryTransition(v20, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 129, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 130, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 131, Name: onTerminalReached
                end
            });
            TestRunner.assert(not v20.skillRunData.State.transitionLocked);
        end
    },
    {
        name = "isVersionValid_AfterTransition_OldVersionInvalid",

        fn = function() -- Line: 138, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v21 = createInstance("Startup");
            v21.skillRunData.State.current = "Startup";
            v21.skillRunData.State.version = 1;
            SkillStateRuntime.tryTransition(v21, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 144, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 145, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 146, Name: onTerminalReached
                end
            });
            TestRunner.assert(not SkillStateRuntime.isVersionValid(v21, 1));
            TestRunner.assert(SkillStateRuntime.isVersionValid(v21, 2));
        end
    }
};

return {
    run = function() -- Line: 155, Name: run
        -- upvalues: TestRunner (copy), u22 (copy)
        return TestRunner.run("TransitionRollback", u22);
    end
};