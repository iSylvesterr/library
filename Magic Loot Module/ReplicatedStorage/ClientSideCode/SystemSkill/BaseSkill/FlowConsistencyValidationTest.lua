-- Decompiled with Potassium's decompiler.

local SkillModuleValidator = require(script.Parent.SkillModuleValidator);
local SkillEventConst = require(script.Parent.SkillEventConst);
local u1 = { {
        name = "1. 不可达状态"
    }, {
        name = "2. 非终态无出口"
    }, {
        name = "3. 顺序倒挂"
    }, {
        name = "4. 终态有出边"
    }, {
        name = "5a. Duration 无 StateTimeout 出边"
    }, {
        name = "5b. window 标记到终态"
    }, {
        name = "6. open > close 开闭倒挂"
    }, {
        name = "7. profile 引用缺失"
    }, {
        name = "8. condition 永真吞噬 warning",
        kind = "warning-expected"
    } };

return {
    runAll = function() -- Line: 24, Name: runAll
        -- upvalues: SkillEventConst (copy), SkillModuleValidator (copy), u1 (copy)
        local v2 = 0;
        local v3 = 0;

        if SkillModuleValidator.validateBaseSkill({
            InitialState = "Startup",
            States = {
                Startup = {
                    Duration = 0.5
                },
                Orphan = {
                    Duration = 0
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
        }, {
            skillName = "UnreachableState"
        }) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出 Orphan）"):format(u1[1].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[1].name));
        end;

        if SkillModuleValidator.validateBaseSkill({
            InitialState = "Startup",
            States = {
                Startup = {
                    Duration = 0.5
                },
                Stuck = {
                    Duration = -1
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
                    To = "Stuck",
                    Event = SkillEventConst.StateTimeout
                },
                {
                    From = "Startup",
                    To = "Interrupted",
                    Event = SkillEventConst.Interrupt
                }
            }
        }, {
            skillName = "NoExitState"
        }) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出 Stuck）"):format(u1[2].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[2].name));
        end;

        if SkillModuleValidator.validateBaseSkill({
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
            StateOrder = {
                Startup = 1,
                Recovery = 2,
                Finished = 1,
                Interrupted = 4
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
                }
            }
        }, {
            skillName = "OrderInversion"
        }) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出 order[Finished]=1 < order[Recovery]=2）"):format(u1[3].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[3].name));
        end;

        if SkillModuleValidator.validateBaseSkill({
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
                    From = "Finished",
                    To = "Startup",
                    Event = "Resurrect"
                },
                {
                    From = "Startup",
                    To = "Interrupted",
                    Event = SkillEventConst.Interrupt
                }
            }
        }, {
            skillName = "TerminalHasOutgoing"
        }) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出）"):format(u1[4].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[4].name));
        end;

        if SkillModuleValidator.validateBaseSkill({
            InitialState = "Startup",
            States = {
                Startup = {
                    Duration = 0.5
                },
                Waiting = {
                    Duration = 1
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
                    To = "Waiting",
                    Event = "Manual"
                },
                {
                    From = "Waiting",
                    To = "Finished",
                    Event = "Manual"
                },
                {
                    From = "Startup",
                    To = "Interrupted",
                    Event = SkillEventConst.Interrupt
                }
            }
        }, {
            skillName = "DurationNoStateTimeout"
        }) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出）"):format(u1[5].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[5].name));
        end;

        local u4 = {
            States = {
                Startup = {
                    Duration = 0.5
                },
                ProjectileFlying = {
                    Duration = -1
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
            StateOrder = {
                Startup = 1,
                ProjectileFlying = 2,
                Recovery = 3,
                Finished = 4,
                Interrupted = 5
            }
        };
        local v5, v6 = SkillModuleValidator.validateGroupSkill({
            Skill = { {
                    baseSkillName = "MagicMissile1"
                } },
            ChainWindows = {
                BadWindow = {
                    open = {
                        state = "ProjectileFlying",
                        elapsed = 0
                    },
                    close = {
                        state = "Finished",
                        elapsed = 0
                    }
                }
            }
        }, {
            resolveBaseSkill = function() -- Line: 175, Name: resolveBaseSkill
                -- upvalues: u4 (copy)
                return u4;
            end
        });

        if v5 or (not v6 or #v6 <= 0) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出 close.state=Finished）"):format(u1[6].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[6].name));
        end;

        local u7 = {
            States = {
                Startup = {
                    Duration = 0.5
                },
                ProjectileFlying = {
                    Duration = -1
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
            StateOrder = {
                Startup = 1,
                ProjectileFlying = 2,
                Recovery = 3,
                Finished = 4,
                Interrupted = 5
            }
        };

        if SkillModuleValidator.validateGroupSkill({
            Skill = { {
                    baseSkillName = "TestSkill"
                } },
            ChainWindows = {
                BadOrder = {
                    open = {
                        state = "Recovery",
                        elapsed = 0
                    },
                    close = {
                        state = "ProjectileFlying",
                        elapsed = 0
                    }
                }
            }
        }, {
            resolveBaseSkill = function() -- Line: 208, Name: resolveBaseSkill
                -- upvalues: u7 (copy)
                return u7;
            end
        }) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出）"):format(u1[7].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[7].name));
        end;

        if SkillModuleValidator.validateBaseSkill(
            {
                hitboxConfig = { {
                        HitboxIndex = 1,
                        damageProfileId = "MissingProfile"
                    } },
                DamageProfiles = {
                    ValidOnly = {}
                }
            },
            {
                skillName = "ProfileRefMissing"
            }
        ) then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未抓出）"):format(u1[8].name));
        else
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已抓出）"):format(u1[8].name));
        end;

        local v8 = {};
        local v9 = SkillModuleValidator.validateGroupSkill({
            Skill = { {
                    baseSkillName = "Skill1",
                    condition = {
                        type = "literal",
                        value = true
                    }
                }, {
                    baseSkillName = "Skill2",
                    condition = {
                        type = "literal",
                        value = false
                    }
                } }
        }, {
            skillName = "AlwaysTrue",
            warnings = v8
        });

        if v9 and #v8 > 0 then
            v2 = v2 + 1;
            print(("[FlowConsistencyValidationTest] %s: 通过（已产生）"):format(u1[9].name));
        elseif v9 then
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（未产生 warning）"):format(u1[9].name));
        else
            v3 = v3 + 1;
            warn(("[FlowConsistencyValidationTest] %s: 失败（校验报错）"):format(u1[9].name));
        end;

        print(("[FlowConsistencyValidationTest] 完成: %d 通过, %d 失败"):format(v2, v3));

        return v2, v3;
    end
};