-- Decompiled with Potassium's decompiler.

local SkillStateMachine = require(script.Parent.Parent.BaseSkill.SkillStateMachine);
local SkillStateRuntime = require(script.Parent.Parent.BaseSkill.SkillStateRuntime);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);
local u1 = {
    InitialState = "Startup",
    States = {
        Startup = {
            Duration = 1
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

local function createInstance(p2) -- Line: 28
    -- upvalues: u1 (copy)
    return {
        skillName = "InterruptTest",
        nowTime = 0.5,
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

local u14 = {
    {
        name = "tryTransition_Interrupt_FromStartup_ToInterrupted",

        fn = function() -- Line: 47, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v3 = createInstance("Startup");
            local u4 = nil;
            local v7 = SkillStateRuntime.tryTransition(v3, SkillEventConst.Interrupt, nil, {
                callEnterHandler = function() -- Line: 51, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 52, Name: callExitHandler
                end,

                onTerminalReached = function(p5, p6) -- Line: 53, Name: onTerminalReached
                    -- upvalues: u4 (ref)
                    u4 = p6;
                end
            });
            TestRunner.assert(v7);
            TestRunner.assertEqual(v3.skillRunData.State.current, "Interrupted");
            TestRunner.assertEqual(u4, "Interrupted");
        end
    },
    {
        name = "tryTransition_Interrupt_FromRecovery_ToInterrupted",

        fn = function() -- Line: 62, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v8 = createInstance("Recovery");
            local u9 = nil;
            local v12 = SkillStateRuntime.tryTransition(v8, SkillEventConst.Interrupt, nil, {
                callEnterHandler = function() -- Line: 66, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 67, Name: callExitHandler
                end,

                onTerminalReached = function(p10, p11) -- Line: 68, Name: onTerminalReached
                    -- upvalues: u9 (ref)
                    u9 = p11;
                end
            });
            TestRunner.assert(v12);
            TestRunner.assertEqual(v8.skillRunData.State.current, "Interrupted");
            TestRunner.assertEqual(u9, "Interrupted");
        end
    },
    {
        name = "findTransition_Interrupt_Exists",

        fn = function() -- Line: 77, Name: fn
            -- upvalues: SkillStateMachine (copy), u1 (copy), SkillEventConst (copy), TestRunner (copy)
            local v13 = SkillStateMachine.findTransition(u1.Transitions, "Startup", SkillEventConst.Interrupt, nil, nil);
            TestRunner.assert(v13 ~= nil);
            TestRunner.assertEqual(v13.To, "Interrupted");
        end
    }
};

return {
    run = function() -- Line: 86, Name: run
        -- upvalues: TestRunner (copy), u14 (copy)
        return TestRunner.run("Interrupt", u14);
    end
};