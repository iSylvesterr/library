-- Decompiled with Potassium's decompiler.

local BaseSkillClient = require(script.Parent.Parent.BaseSkill.BaseSkillClient);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);
local u1 = {
    skillName = "DestroyTestSkill",
    skillModule = {
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
    }
};

local function createMockContext() -- Line: 30
    local v2 = {
        Parent = game
    };

    return {
        characterId = 0,
        characterType = "NPC",
        skillPower = 1,
        skillPurity = 1,
        skillCastId = "destroy_test",
        baseSkillInstanceId = "destroy_test_B1",
        activeBaseSkillIndex = 1,
        releaseCF = nil,
        targetCF = nil,
        moveDirectionStr = nil,
        combatSeed = 123,
        character = v2,
        skillInputData = {
            characterId = 0,
            characterType = "NPC",
            releaseCF = nil,
            targetCF = nil,
            moveDirectionStr = nil,
            skillCastId = "destroy_test",
            baseSkillInstanceId = "destroy_test_B1",
            activeBaseSkillIndex = 1,
            character = v2
        }
    };
end;

local u14 = {
    {
        name = "destroy_RunningSkill_ReachesTerminalState",

        fn = function() -- Line: 62, Name: fn
            -- upvalues: BaseSkillClient (copy), u1 (copy), createMockContext (copy), TestRunner (copy)
            local v3 = BaseSkillClient.newWithDefinition(u1, (createMockContext()));
            v3:skillStart();
            TestRunner.assert(v3:isRunningFlow(), "skillStart 后应处于运行状态");
            v3:destroy("Interrupted", true);
            TestRunner.assertEqual(v3.flowState, "Interrupted", "destroy 后应落终态 Interrupted");
            TestRunner.assert(v3:isTerminal(), "destroy 后 isTerminal 应为 true");
        end
    },
    {
        name = "destroy_ExitState_CalledDuringTransition",

        fn = function() -- Line: 76, Name: fn
            -- upvalues: BaseSkillClient (copy), u1 (copy), createMockContext (copy), TestRunner (copy)
            local u4 = false;
            local v5 = BaseSkillClient.newWithDefinition(u1, (createMockContext()));
            local ExitState = v5.ExitState;

            function v5.ExitState(p6, p7, p8) -- Line: 81
                -- upvalues: u4 (ref), ExitState (copy)
                u4 = true;

                return ExitState(p6, p7, p8);
            end;

            v5:skillStart();
            v5:destroy("Interrupted", true);
            TestRunner.assert(u4, "destroy 时 ExitState 应至少执行一次（Startup->Interrupted 需退出 Startup）");
        end
    },
    {
        name = "destroy_markFinished_SemanticsPreserved",

        fn = function() -- Line: 94, Name: fn
            -- upvalues: BaseSkillClient (copy), u1 (copy), createMockContext (copy), TestRunner (copy)
            local u9 = false;
            local v10 = BaseSkillClient.newWithDefinition(u1, (createMockContext()));
            local markFinished = v10.markFinished;

            function v10.markFinished(p11, p12, p13) -- Line: 99
                -- upvalues: u9 (ref), markFinished (copy)
                u9 = true;

                return markFinished(p11, p12, p13);
            end;

            v10:skillStart();
            v10:destroy("Interrupted", true);
            TestRunner.assert(u9, "destroy 时 markFinished 应被调用（TryTransition 成功 -> onTerminalReached）");
        end
    }
};

return {
    name = "DestroyCallsSkillEndCleanupTests",

    run = function() -- Line: 114, Name: run
        -- upvalues: TestRunner (copy), u14 (copy)
        return TestRunner.run("DestroyCallsSkillEndCleanup", u14);
    end
};