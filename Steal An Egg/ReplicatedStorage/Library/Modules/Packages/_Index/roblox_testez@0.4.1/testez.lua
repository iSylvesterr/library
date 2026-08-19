-- Decompiled with Potassium's decompiler.

local Expectation = require(script.Expectation);
local TestBootstrap = require(script.TestBootstrap);
local TestEnum = require(script.TestEnum);
local TestPlan = require(script.TestPlan);
local TestPlanner = require(script.TestPlanner);
local TestResults = require(script.TestResults);
local TestRunner = require(script.TestRunner);

return {
    run = function(p1, p2) -- Line: 13, Name: run
        -- upvalues: TestBootstrap (copy), TestPlanner (copy), TestRunner (copy)
        local v3 = TestBootstrap:getModules(p1);
        local v4 = TestPlanner.createPlan(v3);
        p2((TestRunner.runPlan(v4)));
    end,

    Expectation = Expectation,
    TestBootstrap = TestBootstrap,
    TestEnum = TestEnum,
    TestPlan = TestPlan,
    TestPlanner = TestPlanner,
    TestResults = TestResults,
    TestRunner = TestRunner,
    TestSession = require(script.TestSession),
    Reporters = {
        TextReporter = require(script.Reporters.TextReporter),
        TextReporterQuiet = require(script.Reporters.TextReporterQuiet),
        TeamCityReporter = require(script.Reporters.TeamCityReporter)
    }
};