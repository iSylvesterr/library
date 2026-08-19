-- Decompiled with Potassium's decompiler.

local BaseSkillClient = require(script.Parent.Parent.BaseSkill.BaseSkillClient);
local BaseSkillServer = require(script.Parent.Parent.BaseSkill.BaseSkillServer);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);
local u1 = {
    skillName = "MockSkill",
    skillModule = {
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
    }
};
local u2 = {
    characterId = 0,
    characterType = "NPC",
    skillPower = 1,
    skillPurity = 1,
    skillCastId = nil,
    baseSkillInstanceId = nil,
    activeBaseSkillIndex = nil,
    releaseCF = nil,
    targetCF = nil,
    moveDirectionStr = nil,
    combatSeed = nil,
    character = nil,
    skillInputData = {
        characterId = 0,
        characterType = "NPC",
        releaseCF = nil,
        targetCF = nil,
        moveDirectionStr = nil,
        character = nil,
        skillCastId = nil,
        baseSkillInstanceId = nil,
        activeBaseSkillIndex = nil
    }
};
local u5 = {
    {
        name = "newWithDefinition_Client_AcceptsMockDefinitionAndContext",

        fn = function() -- Line: 57, Name: fn
            -- upvalues: BaseSkillClient (copy), u1 (copy), u2 (copy), TestRunner (copy)
            local v3 = BaseSkillClient.newWithDefinition(u1, u2);
            TestRunner.assert(v3 ~= nil);
            TestRunner.assertEqual(v3.skillName, "MockSkill");
            TestRunner.assertEqual(v3.skillModule, u1.skillModule);
            TestRunner.assertEqual(v3.characterId, 0);
            TestRunner.assertEqual(v3.characterType, "NPC");
            TestRunner.assert(v3.controlRuntime ~= nil);
        end
    },
    {
        name = "newWithDefinition_Server_AcceptsMockDefinitionAndContext",

        fn = function() -- Line: 69, Name: fn
            -- upvalues: BaseSkillServer (copy), u1 (copy), u2 (copy), TestRunner (copy)
            local v4 = BaseSkillServer.newWithDefinition(u1, u2);
            TestRunner.assert(v4 ~= nil);
            TestRunner.assertEqual(v4.skillName, "MockSkill");
            TestRunner.assertEqual(v4.skillModule, u1.skillModule);
            TestRunner.assertEqual(v4.characterId, 0);
            TestRunner.assertEqual(v4.characterType, "NPC");
            TestRunner.assert(v4.controlRuntime ~= nil);
        end
    }
};

return {
    run = function() -- Line: 82, Name: run
        -- upvalues: TestRunner (copy), u5 (copy)
        return TestRunner.run("BaseSkillFacade", u5);
    end
};