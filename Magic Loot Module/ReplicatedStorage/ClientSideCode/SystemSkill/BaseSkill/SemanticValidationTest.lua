-- Decompiled with Potassium's decompiler.

local SkillModuleValidator = require(script.Parent.SkillModuleValidator);
local SkillEventConst = require(script.Parent.SkillEventConst);

return {
    runAll = function() -- Line: 12, Name: runAll
        -- upvalues: SkillEventConst (copy), SkillModuleValidator (copy)
        local v1 = 0;
        local v2 = 0;

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
            skillName = "NoStateTimeout"
        }) then
            v2 = v2 + 1;
            warn("[SemanticValidationTest] A. Duration 无 StateTimeout 出边: 失败（未抓出 Startup/Waiting）");
        else
            v1 = v1 + 1;
            print("[SemanticValidationTest] A. Duration 无 StateTimeout 出边: 通过（已抓出）");
        end;

        local v3 = {};
        local v4 = SkillModuleValidator.validateGroupSkill({
            Skill = {
                {
                    baseSkillName = "MagicMissile1",

                    condition = function() -- Line: 47, Name: condition
                        return true;
                    end
                }
            }
        }, {
            skillName = "FuncCondition",
            warnings = v3
        });

        if v4 and #v3 > 0 then
            v1 = v1 + 1;
            print("[SemanticValidationTest] B. function condition warning: 通过（已产生 warning）");
        elseif v4 then
            v2 = v2 + 1;
            warn("[SemanticValidationTest] B. function condition warning: 失败（未产生 warning）");
        else
            v2 = v2 + 1;
            warn("[SemanticValidationTest] B. function condition: 失败（校验报错）");
        end;

        local u5 = {
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
            resolveBaseSkill = function() -- Line: 85, Name: resolveBaseSkill
                -- upvalues: u5 (copy)
                return u5;
            end
        }) then
            v2 = v2 + 1;
            warn("[SemanticValidationTest] C. Window 开闭顺序倒挂: 失败（未抓出）");
        else
            v1 = v1 + 1;
            print("[SemanticValidationTest] C. Window 开闭顺序倒挂: 通过（已抓出）");
        end;

        local u6 = {
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
                BadElapsed = {
                    open = {
                        state = "ProjectileFlying",
                        elapsed = 0.5
                    },
                    close = {
                        state = "ProjectileFlying",
                        elapsed = 0.2
                    }
                }
            }
        }, {
            resolveBaseSkill = function() -- Line: 118, Name: resolveBaseSkill
                -- upvalues: u6 (copy)
                return u6;
            end
        }) then
            v2 = v2 + 1;
            warn("[SemanticValidationTest] C2. Window 同状态 elapsed 倒挂: 失败（未抓出）");
        else
            v1 = v1 + 1;
            print("[SemanticValidationTest] C2. Window 同状态 elapsed 倒挂: 通过（已抓出）");
        end;

        if SkillModuleValidator.validateBaseSkill(
            {
                hitboxConfig = { {
                        HitboxIndex = 1,
                        damageProfileId = "NonExistentProfile"
                    } },
                DamageProfiles = {
                    ValidProfile = {}
                }
            },
            {
                skillName = "BadDamageProfileRef"
            }
        ) then
            v2 = v2 + 1;
            warn("[SemanticValidationTest] D. damageProfileId 引用缺失: 失败（未抓出）");
        else
            v1 = v1 + 1;
            print("[SemanticValidationTest] D. damageProfileId 引用缺失: 通过（已抓出）");
        end;

        print(("[SemanticValidationTest] 完成: %d 通过, %d 失败"):format(v1, v2));

        return v1, v2;
    end
};