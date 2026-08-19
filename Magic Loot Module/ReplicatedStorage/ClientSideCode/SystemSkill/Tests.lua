-- Decompiled with Potassium's decompiler.

local StateFlowTests = require(script.StateFlowTests);
local TerminalStateTests = require(script.TerminalStateTests);
local DeriveWindowTests = require(script.DeriveWindowTests);
local InputBufferTests = require(script.InputBufferTests);
local InterruptTests = require(script.InterruptTests);
local ProjectileImpactTests = require(script.ProjectileImpactTests);
local MultiInstanceTests = require(script.MultiInstanceTests);
local BaseSkillFacadeTest = require(script.BaseSkillFacadeTest);
local TransitionRollbackTests = require(script.TransitionRollbackTests);
local SyncOrderingTests = require(script.SyncOrderingTests);
local FlowConsistencyValidationTest = require(script.Parent.BaseSkill.FlowConsistencyValidationTest);
local SemanticValidationTest = require(script.Parent.BaseSkill.SemanticValidationTest);
local u1 = {
    StateFlowTests,
    TerminalStateTests,
    BaseSkillFacadeTest,
    DeriveWindowTests,
    InputBufferTests,
    InterruptTests,
    ProjectileImpactTests,
    MultiInstanceTests,
    TransitionRollbackTests,
    SyncOrderingTests,
    require(script.SkillNameConsistencyTests),
    require(script.SyncRadiusPolicyTests),
    require(script.ProductionRiskIntegrationTests),
    require(script.DestroyCallsSkillEndCleanupTests),
    require(script.ReleasePlayerOnlyActionTests),
    require(script.AnimationPlaySideActionTests),
    (require(script.AudienceCleanupTests))
};

return {
    runAll = function() -- Line: 52, Name: runAll
        -- upvalues: u1 (copy), FlowConsistencyValidationTest (copy), SemanticValidationTest (copy)
        print("========== 技能框架自动化测试 ==========");
        local v2 = 0;
        local v3 = {};
        local v4 = 0;

        for _, v in ipairs(u1) do
            local success, result = pcall(function() -- Line: 59
                -- upvalues: v (copy)
                return v.run();
            end);

            if success and (type(result) == "table" and result.passed ~= nil) then
                v4 = v4 + result.passed;
                v2 = v2 + (result.failed or 0);
                table.insert(v3, {
                    name = result.name or "?",
                    passed = result.passed,
                    failed = result.failed or 0
                });
            else
                v2 = v2 + 1;
                warn("[Tests] Suite error:", (tostring(result)));
                table.insert(v3, {
                    passed = 0,
                    failed = 1,
                    name = v and v.name or "?"
                });
            end;
        end;

        print("---------- 流程一致性校验 ----------");
        local v5, v6, v7 = pcall(function() -- Line: 76
            -- upvalues: FlowConsistencyValidationTest (ref)
            return FlowConsistencyValidationTest.runAll();
        end);
        local v8;

        if v5 and type(v6) == "number" then
            v4 = v4 + v6;
            v8 = v2 + (v7 or 0);
            table.insert(v3, {
                name = "FlowConsistencyValidationTest",
                passed = v6,
                failed = v7 or 0
            });
        else
            v8 = v2 + 1;
            warn("[Tests] FlowConsistencyValidationTest error:", (tostring(v6)));
            table.insert(v3, {
                name = "FlowConsistencyValidationTest",
                passed = 0,
                failed = 1
            });
        end;

        print("---------- 语义型校验 ----------");
        local v9, v10, v11 = pcall(function() -- Line: 93
            -- upvalues: SemanticValidationTest (ref)
            return SemanticValidationTest.runAll();
        end);
        local v12;

        if v9 and type(v10) == "number" then
            v4 = v4 + v10;
            v12 = v8 + (v11 or 0);
            table.insert(v3, {
                name = "SemanticValidationTest",
                passed = v10,
                failed = v11 or 0
            });
        else
            v12 = v8 + 1;
            warn("[Tests] SemanticValidationTest error:", (tostring(v10)));
            table.insert(v3, {
                name = "SemanticValidationTest",
                passed = 0,
                failed = 1
            });
        end;

        print("========================================");
        print(("总计: %d 通过, %d 失败"):format(v4, v12));
        print("========================================");

        return {
            passed = v4,
            failed = v12,
            suites = v3
        };
    end
};