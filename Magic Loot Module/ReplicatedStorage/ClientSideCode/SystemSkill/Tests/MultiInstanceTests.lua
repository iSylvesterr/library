-- Decompiled with Potassium's decompiler.

local SkillStateRuntime = require(script.Parent.Parent.BaseSkill.SkillStateRuntime);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local MockRuntime = require(script.Parent.MockRuntime);
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

local function createInstance(p2, p3) -- Line: 28
    -- upvalues: u1 (copy), SkillStateRuntime (copy)
    return {
        skillName = "TestSkill",
        skillModule = u1,
        skillCastId = p2 or "cast_1",
        nowTime = p3 or 0,
        skillRunData = {
            State = SkillStateRuntime.createStateData(u1)
        }
    };
end;

local u12 = {
    {
        name = "TwoInstances_IndependentState",

        fn = function() -- Line: 43, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v4 = createInstance("cast_1", 0.6);
            local v5 = createInstance("cast_2", 0);
            SkillStateRuntime.tryTransition(v4, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 47, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 48, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 49, Name: onTerminalReached
                end
            });
            TestRunner.assertEqual(v4.skillRunData.State.current, "Recovery");
            TestRunner.assertEqual(v5.skillRunData.State.current, "Startup");
        end
    },
    {
        name = "TwoRuntimes_IndependentDeriveRequest",

        fn = function() -- Line: 58, Name: fn
            -- upvalues: MockRuntime (copy), TestRunner (copy)
            local v6 = MockRuntime.new({
                skillCastId = "cast_1",
                nowTime = 0.5,
                deriveRequestByIndex = {
                    [2] = 0.4
                }
            });
            local v7 = MockRuntime.new({
                skillCastId = "cast_2",
                nowTime = 0.5,
                deriveRequestByIndex = {}
            });
            TestRunner.assert(v6:CheckDeriveRequest(2, 0.25));
            TestRunner.assert(not v7:CheckDeriveRequest(2, 0.25));
        end
    },
    {
        name = "TwoInstances_OneReachesFinished_OtherNotAffected",

        fn = function() -- Line: 75, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v8 = createInstance("cast_1", 0);
            v8.skillRunData.State.current = "Recovery";
            v8.skillRunData.State.enteredAt = 0;
            v8.nowTime = 0.3;
            local v9 = createInstance("cast_2", 0);
            v9.skillRunData.State.current = "Startup";
            SkillStateRuntime.tryTransition(v8, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 83, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 84, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 85, Name: onTerminalReached
                end
            });
            TestRunner.assertEqual(v8.skillRunData.State.current, "Finished");
            TestRunner.assertEqual(v9.skillRunData.State.current, "Startup");
        end
    },
    {
        name = "InstanceA_RemovedFromRegistry_InstanceB_RunDataUnchanged",

        fn = function() -- Line: 94, Name: fn
            -- upvalues: createInstance (copy), TestRunner (copy)
            local v10 = {
                cast_1 = createInstance("cast_1", 0)
            };
            v10.cast_1.skillRunData.State.current = "Recovery";
            v10.cast_2 = createInstance("cast_2", 0);
            v10.cast_2.skillRunData.State.current = "Startup";
            local cast_2 = v10.cast_2;
            v10.cast_1 = nil;
            TestRunner.assertEqual(cast_2.skillRunData.State.current, "Startup");
            TestRunner.assertEqual(cast_2.skillRunData.State.version, 0);
        end
    },
    {
        name = "OldGenerationCallback_DoesNotAffectNewState",

        fn = function() -- Line: 108, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), TestRunner (copy)
            local v11 = createInstance("cast_1", 0);
            v11.skillRunData.State.current = "Startup";
            v11.skillRunData.State.version = 1;
            SkillStateRuntime.tryTransition(v11, SkillEventConst.StateTimeout, nil, {
                callEnterHandler = function() -- Line: 114, Name: callEnterHandler
                end,

                callExitHandler = function() -- Line: 115, Name: callExitHandler
                end,

                onTerminalReached = function() -- Line: 116, Name: onTerminalReached
                end
            });
            TestRunner.assert(not SkillStateRuntime.isVersionValid(v11, 1));
            TestRunner.assertEqual(v11.skillRunData.State.current, "Recovery");
        end
    }
};

return {
    run = function() -- Line: 126, Name: run
        -- upvalues: TestRunner (copy), u12 (copy)
        return TestRunner.run("MultiInstance", u12);
    end
};