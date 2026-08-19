-- Decompiled with Potassium's decompiler.

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

local function createInstance(p2) -- Line: 27
    -- upvalues: u1 (copy), SkillStateRuntime (copy)
    local v3 = {
        skillName = "SyncTest",
        nowTime = 1,
        skillModule = u1,
        skillRunData = {
            State = SkillStateRuntime.createStateData(u1)
        }
    };

    if p2 then
        v3.skillRunData.State.current = p2;
    end;

    return v3;
end;

local function defaultHandlers(p4) -- Line: 42
    local v5 = {
        callEnterHandler = function() -- Line: 44, Name: callEnterHandler
        end,

        callExitHandler = function() -- Line: 45, Name: callExitHandler
        end,

        onTerminalReached = function() -- Line: 46, Name: onTerminalReached
        end
    };

    if p4 then
        for i, v in pairs(p4) do
            v5[i] = v;
        end;
    end;

    return v5;
end;

local u21 = {
    {
        name = "DuplicateInterrupt_SecondRejected_StateStaysInterrupted",

        fn = function() -- Line: 59, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), defaultHandlers (copy), TestRunner (copy)
            local v6 = createInstance("Startup");
            local v7 = SkillStateRuntime.tryTransition(v6, SkillEventConst.Interrupt, nil, (defaultHandlers()));
            TestRunner.assert(v7);
            TestRunner.assertEqual(v6.skillRunData.State.current, "Interrupted");
            local v8 = SkillStateRuntime.tryTransition(v6, SkillEventConst.Interrupt, nil, (defaultHandlers()));
            TestRunner.assert(not v8);
            TestRunner.assertEqual(v6.skillRunData.State.current, "Interrupted");
        end
    },
    {
        name = "DuplicateForceFinish_SecondRejected",

        fn = function() -- Line: 71, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), defaultHandlers (copy), TestRunner (copy)
            local v9 = createInstance("Recovery");
            v9.skillRunData.State.current = "Recovery";
            v9.skillRunData.State.enteredAt = 0;
            v9.nowTime = 0.3;
            local v10 = SkillStateRuntime.tryTransition(v9, SkillEventConst.StateTimeout, nil, (defaultHandlers()));
            TestRunner.assert(v10);
            TestRunner.assertEqual(v9.skillRunData.State.current, "Finished");
            local v11 = SkillStateRuntime.tryTransition(v9, SkillEventConst.StateTimeout, nil, (defaultHandlers()));
            TestRunner.assert(not v11);
            TestRunner.assertEqual(v9.skillRunData.State.current, "Finished");
        end
    },
    {
        name = "StoppedBeforeDerived_ApplyDerivedToRemovedInstance_NoCrash",

        fn = function() -- Line: 86, Name: fn
            -- upvalues: TestRunner (copy)
            local u12 = {};

            local function removeInstance(p13) -- Line: 88
                -- upvalues: u12 (copy)
                u12[p13] = nil;
            end;

            u12.cast_1 = {
                applyDerived = function() -- Line: 98, Name: applyDerived
                    error("should not be called");
                end
            };
            u12.cast_1 = nil;
            local success, result = pcall(function(p14, p15) -- Line: 91, Name: applyDerivedToInstance
                -- upvalues: u12 (copy)
                local v16 = u12[p14];

                if v16 and v16.applyDerived then
                    v16:applyDerived(p15);
                end;
            end, "cast_1", {
                fromBaseSkillIndex = 1,
                toBaseSkillIndex = 2
            });
            TestRunner.assert(success, "applyDerivedToInstance should not crash when instance removed: " .. tostring(result));
        end
    },
    {
        name = "OldGenerationCallback_IsVersionValid_ReturnsFalse",

        fn = function() -- Line: 106, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), defaultHandlers (copy), TestRunner (copy)
            local v17 = createInstance("Startup");
            v17.skillRunData.State.current = "Startup";
            v17.skillRunData.State.version = 1;
            local version = v17.skillRunData.State.version;
            SkillStateRuntime.tryTransition(v17, SkillEventConst.StateTimeout, nil, (defaultHandlers()));
            TestRunner.assert(not SkillStateRuntime.isVersionValid(v17, version));
            TestRunner.assert(SkillStateRuntime.isVersionValid(v17, 2));
        end
    },
    {
        name = "RapidInterruptThenTimeout_OnlyFirstSucceeds",

        fn = function() -- Line: 119, Name: fn
            -- upvalues: createInstance (copy), SkillStateRuntime (copy), SkillEventConst (copy), defaultHandlers (copy), TestRunner (copy)
            local v18 = createInstance("Startup");
            local v19 = SkillStateRuntime.tryTransition(v18, SkillEventConst.Interrupt, nil, (defaultHandlers()));
            local v20 = SkillStateRuntime.tryTransition(v18, SkillEventConst.StateTimeout, nil, (defaultHandlers()));
            TestRunner.assert(v19);
            TestRunner.assert(not v20);
            TestRunner.assertEqual(v18.skillRunData.State.current, "Interrupted");
        end
    }
};

return {
    run = function() -- Line: 131, Name: run
        -- upvalues: TestRunner (copy), u21 (copy)
        return TestRunner.run("SyncOrdering", u21);
    end
};