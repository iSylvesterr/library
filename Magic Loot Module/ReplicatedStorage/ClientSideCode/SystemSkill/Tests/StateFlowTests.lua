-- Decompiled with Potassium's decompiler.

local SkillStateMachine = require(script.Parent.Parent.BaseSkill.SkillStateMachine);
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

local function createSkillInstance(p2) -- Line: 28
    -- upvalues: u1 (copy), SkillStateRuntime (copy)
    return {
        skillName = "TestSkill",
        skillModule = u1,
        nowTime = p2 or 0,
        skillRunData = {
            State = SkillStateRuntime.createStateData(u1)
        }
    };
end;

local u26 = {
    {
        name = "findTransition_StateTimeout_StartupToRecovery",

        fn = function() -- Line: 42, Name: fn
            -- upvalues: SkillStateMachine (copy), u1 (copy), SkillEventConst (copy), TestRunner (copy)
            local v3 = SkillStateMachine.findTransition(u1.Transitions, "Startup", SkillEventConst.StateTimeout, nil, nil);
            TestRunner.assert(v3 ~= nil, "rule should exist");
            TestRunner.assertEqual(v3.To, "Recovery");
        end
    },
    {
        name = "findTransition_Interrupt_StartupToInterrupted",

        fn = function() -- Line: 50, Name: fn
            -- upvalues: SkillStateMachine (copy), u1 (copy), SkillEventConst (copy), TestRunner (copy)
            local v4 = SkillStateMachine.findTransition(u1.Transitions, "Startup", SkillEventConst.Interrupt, nil, nil);
            TestRunner.assert(v4 ~= nil);
            TestRunner.assertEqual(v4.To, "Interrupted");
        end
    },
    {
        name = "findTransition_NoMatch_ReturnsNil",

        fn = function() -- Line: 58, Name: fn
            -- upvalues: SkillStateMachine (copy), u1 (copy), TestRunner (copy)
            local v5 = SkillStateMachine.findTransition(u1.Transitions, "Startup", "UnknownEvent", nil, nil);
            TestRunner.assert(v5 == nil);
        end
    },
    {
        name = "shouldStateTimeout_NotYet_ReturnsFalse",

        fn = function() -- Line: 65, Name: fn
            -- upvalues: u1 (copy), TestRunner (copy), SkillStateMachine (copy)
            TestRunner.assert(not SkillStateMachine.shouldStateTimeout(u1.States.Startup, 0, 0.2));
        end
    },
    {
        name = "shouldStateTimeout_Elapsed_ReturnsTrue",

        fn = function() -- Line: 72, Name: fn
            -- upvalues: u1 (copy), TestRunner (copy), SkillStateMachine (copy)
            TestRunner.assert(SkillStateMachine.shouldStateTimeout(u1.States.Startup, 0, 0.6));
        end
    },
    {
        name = "tryTransition_StartupToRecovery_Succeeds",

        fn = function() -- Line: 79, Name: fn
            -- upvalues: createSkillInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v6 = createSkillInstance(0.6);
            local u7 = nil;
            local v14 = SkillStateRuntime.tryTransition(v6, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function(p8, p9) -- Line: 83, Name: callEnterHandler
                end,

                callExitHandler = function(p10, p11) -- Line: 84, Name: callExitHandler
                end,

                onTerminalReached = function(p12, p13) -- Line: 85, Name: onTerminalReached
                    -- upvalues: u7 (ref)
                    u7 = p13;
                end
            });
            TestRunner.assert(v14);
            TestRunner.assertEqual(v6.skillRunData.State.current, "Recovery");
            TestRunner.assert(u7 == nil);
        end
    },
    {
        name = "tryTransition_RecoveryToFinished_SucceedsAndCallsTerminal",

        fn = function() -- Line: 94, Name: fn
            -- upvalues: createSkillInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v15 = createSkillInstance(0);
            v15.skillRunData.State.current = "Recovery";
            v15.skillRunData.State.enteredAt = 0;
            v15.nowTime = 0.3;
            local u16 = nil;
            local v23 = SkillStateRuntime.tryTransition(v15, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function(p17, p18) -- Line: 101, Name: callEnterHandler
                end,

                callExitHandler = function(p19, p20) -- Line: 102, Name: callExitHandler
                end,

                onTerminalReached = function(p21, p22) -- Line: 103, Name: onTerminalReached
                    -- upvalues: u16 (ref)
                    u16 = p22;
                end
            });
            TestRunner.assert(v23);
            TestRunner.assertEqual(v15.skillRunData.State.current, "Finished");
            TestRunner.assertEqual(u16, "Finished");
        end
    },
    {
        name = "tryTransition_FromTerminal_RejectsEvent",

        fn = function() -- Line: 112, Name: fn
            -- upvalues: createSkillInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v24 = createSkillInstance(0);
            v24.skillRunData.State.current = "Finished";
            local v25 = SkillStateRuntime.tryTransition(v24, SkillEventConst.Interrupt, nil, {
                callEnterHandler = function() -- Line: 116, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 117, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 118, Name: onTerminalReached
                end
            });
            TestRunner.assert(not v25);
            TestRunner.assertEqual(v24.skillRunData.State.current, "Finished");
        end
    }
};

return {
    run = function() -- Line: 127, Name: run
        -- upvalues: TestRunner (copy), u26 (copy)
        return TestRunner.run("StateFlow", u26);
    end
};