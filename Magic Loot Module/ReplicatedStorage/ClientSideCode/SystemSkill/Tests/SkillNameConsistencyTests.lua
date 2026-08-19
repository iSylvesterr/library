-- Decompiled with Potassium's decompiler.

local SkillModuleValidator = require(script.Parent.Parent.BaseSkill.SkillModuleValidator);
local TestRunner = require(script.Parent.TestRunner);

local function createMinimalGroupSkill(p1) -- Line: 9
    return {
        Data = {
            skillCooldown = 1,
            skillName = p1
        },
        Skill = { {
                baseSkillName = "MagicMissile1"
            } }
    };
end;

local u18 = {
    {
        name = "Data_skillName_matches_moduleScriptName_passes",

        fn = function() -- Line: 19, Name: fn
            -- upvalues: createMinimalGroupSkill (copy), SkillModuleValidator (copy), TestRunner (copy)
            local v2 = createMinimalGroupSkill("Tornado");
            local v3, v4 = SkillModuleValidator.validateGroupSkillStrict(v2, {
                skillName = "Tornado",
                moduleScriptName = "Tornado",
                env = "production",

                resolveBaseSkill = function() -- Line: 24, Name: resolveBaseSkill
                    return nil;
                end
            });
            TestRunner.assert(v3, "一致时应通过");
            TestRunner.assert(not v4 or #v4 == 0, "无错误");
        end
    },
    {
        name = "Data_skillName_mismatch_fails",

        fn = function() -- Line: 33, Name: fn
            -- upvalues: createMinimalGroupSkill (copy), SkillModuleValidator (copy), TestRunner (copy)
            local v5 = createMinimalGroupSkill("Voidrend");
            local v6, v7 = SkillModuleValidator.validateGroupSkillStrict(v5, {
                skillName = "Tornado",
                moduleScriptName = "Tornado",
                env = "production",

                resolveBaseSkill = function() -- Line: 38, Name: resolveBaseSkill
                    return nil;
                end
            });
            TestRunner.assert(not v6, "不一致时应失败");
            local v8;

            if v7 then
                v8 = #v7 > 0;
            else
                v8 = v7;
            end;

            TestRunner.assert(v8, "应有错误");
            local v9 = false;

            for _, v in ipairs(v7) do
                if type(v) == "string" and v:find("与模块名不一致") then
                    v9 = true;
                    break;
                end;
            end;

            TestRunner.assert(v9, "应包含「与模块名不一致」错误");
        end
    },
    {
        name = "Data_skillName_missing_fails",

        fn = function() -- Line: 55, Name: fn
            -- upvalues: SkillModuleValidator (copy), TestRunner (copy)
            local v10, v11 = SkillModuleValidator.validateGroupSkillStrict({
                Data = {
                    skillCooldown = 1
                },
                Skill = { {
                        baseSkillName = "MagicMissile1"
                    } }
            }, {
                skillName = "Tornado",
                moduleScriptName = "Tornado",
                env = "production",

                resolveBaseSkill = function() -- Line: 63, Name: resolveBaseSkill
                    return nil;
                end
            });
            TestRunner.assert(not v10, "Data.skillName 缺失时应失败");
            local v12;

            if v11 then
                v12 = #v11 > 0;
            else
                v12 = v11;
            end;

            TestRunner.assert(v12, "应有错误");
            local v13 = false;

            for _, v in ipairs(v11) do
                if type(v) == "string" and v:find("Data.skillName 缺失") then
                    v13 = true;
                    break;
                end;
            end;

            TestRunner.assert(v13, "应包含「Data.skillName 缺失」错误");
        end
    },
    {
        name = "Data_skillName_empty_fails",

        fn = function() -- Line: 80, Name: fn
            -- upvalues: SkillModuleValidator (copy), TestRunner (copy)
            local v14, v15 = SkillModuleValidator.validateGroupSkillStrict({
                Data = {
                    skillName = "",
                    skillCooldown = 1
                },
                Skill = { {
                        baseSkillName = "MagicMissile1"
                    } }
            }, {
                skillName = "Tornado",
                moduleScriptName = "Tornado",
                env = "production",

                resolveBaseSkill = function() -- Line: 88, Name: resolveBaseSkill
                    return nil;
                end
            });
            TestRunner.assert(not v14, "Data.skillName 为空时应失败");

            if v15 then
                v15 = #v15 > 0;
            end;

            TestRunner.assert(v15, "应有错误");
        end
    },
    {
        name = "no_moduleScriptName_skips_consistency_check",

        fn = function() -- Line: 97, Name: fn
            -- upvalues: createMinimalGroupSkill (copy), SkillModuleValidator (copy), TestRunner (copy)
            local v16 = createMinimalGroupSkill("Voidrend");
            local v17 = SkillModuleValidator.validateGroupSkill(v16, {
                skillName = "Tornado",

                resolveBaseSkill = function() -- Line: 101, Name: resolveBaseSkill
                    return nil;
                end
            });
            TestRunner.assert(v17, "未传 moduleScriptName 时不校验一致性，其他校验通过即过");
        end
    }
};

return {
    name = "SkillNameConsistencyTests",

    run = function() -- Line: 108, Name: run
        -- upvalues: TestRunner (copy), u18 (copy)
        return TestRunner.run("SkillNameConsistencyTests", u18);
    end
};