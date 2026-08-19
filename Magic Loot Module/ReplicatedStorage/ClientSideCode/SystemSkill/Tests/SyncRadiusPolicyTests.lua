-- Decompiled with Potassium's decompiler.

local BaseSkillServer = require(script.Parent.Parent.BaseSkill.BaseSkillServer);
local SkillEventConst = require(script.Parent.Parent.BaseSkill.SkillEventConst);
local TestRunner = require(script.Parent.TestRunner);
local u1 = {
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
    skillInputData = {}
};

local function createServerWithSkillModule(p2) -- Line: 27
    -- upvalues: BaseSkillServer (copy), u1 (copy)
    return BaseSkillServer.newWithDefinition({
        skillName = "TestSkill",
        skillModule = p2
    }, u1);
end;

local u7 = {
    {
        name = "no_Data_returns_default_120",

        fn = function() -- Line: 38, Name: fn
            -- upvalues: SkillEventConst (copy), BaseSkillServer (copy), u1 (copy), TestRunner (copy)
            local v3 = BaseSkillServer.newWithDefinition({
                skillName = "TestSkill",
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
            }, u1);
            TestRunner.assertEqual(v3:getSyncRadius(), 120);
            TestRunner.assertEqual(v3:getSyncRadius("ProjectileHitConfirmed"), 120);
            TestRunner.assertEqual(v3:getSyncRadius("StopSkill"), 120);
            TestRunner.assertEqual(v3:getSyncRadius("DamageTip"), 60);
        end
    },
    {
        name = "syncRadius_used_when_no_phase_specific",

        fn = function() -- Line: 53, Name: fn
            -- upvalues: SkillEventConst (copy), BaseSkillServer (copy), u1 (copy), TestRunner (copy)
            local v4 = BaseSkillServer.newWithDefinition({
                skillName = "TestSkill",
                skillModule = {
                    InitialState = "Startup",
                    Data = {
                        syncRadius = 150
                    },
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
            }, u1);
            TestRunner.assertEqual(v4:getSyncRadius(), 150);
            TestRunner.assertEqual(v4:getSyncRadius("ProjectileHitConfirmed"), 150);
            TestRunner.assertEqual(v4:getSyncRadius("StopSkill"), 150);
            TestRunner.assertEqual(v4:getSyncRadius("DamageTip"), 60);
        end
    },
    {
        name = "phase_specific_overrides_syncRadius",

        fn = function() -- Line: 69, Name: fn
            -- upvalues: SkillEventConst (copy), BaseSkillServer (copy), u1 (copy), TestRunner (copy)
            local v5 = BaseSkillServer.newWithDefinition({
                skillName = "TestSkill",
                skillModule = {
                    InitialState = "Startup",
                    Data = {
                        syncRadius = 120,
                        hitConfirmRadius = 100,
                        stopSyncRadius = 130,
                        damageTipRadius = 60
                    },
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
            }, u1);
            TestRunner.assertEqual(v5:getSyncRadius(), 120);
            TestRunner.assertEqual(v5:getSyncRadius("ProjectileHitConfirmed"), 100);
            TestRunner.assertEqual(v5:getSyncRadius("StopSkill"), 130);
            TestRunner.assertEqual(v5:getSyncRadius("DamageTip"), 60);
        end
    },
    {
        name = "partial_phase_overrides_fallback_to_syncRadius",

        fn = function() -- Line: 90, Name: fn
            -- upvalues: SkillEventConst (copy), BaseSkillServer (copy), u1 (copy), TestRunner (copy)
            local v6 = BaseSkillServer.newWithDefinition({
                skillName = "TestSkill",
                skillModule = {
                    InitialState = "Startup",
                    Data = {
                        syncRadius = 80,
                        damageTipRadius = 50
                    },
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
            }, u1);
            TestRunner.assertEqual(v6:getSyncRadius("DamageTip"), 50);
            TestRunner.assertEqual(v6:getSyncRadius("ProjectileHitConfirmed"), 80);
            TestRunner.assertEqual(v6:getSyncRadius("StopSkill"), 80);
        end
    }
};

return {
    name = "SyncRadiusPolicyTests",

    run = function() -- Line: 108, Name: run
        -- upvalues: TestRunner (copy), u7 (copy)
        return TestRunner.run("SyncRadiusPolicyTests", u7);
    end
};