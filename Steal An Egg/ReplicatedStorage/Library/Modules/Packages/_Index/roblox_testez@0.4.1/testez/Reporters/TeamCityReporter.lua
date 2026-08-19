-- Decompiled with Potassium's decompiler.

local TestService = game:GetService("TestService");
local TestEnum = require(script.Parent.Parent.TestEnum);
local v1 = {};

local function teamCityEscape(p2) -- Line: 7
    local v3 = string.gsub(p2, "([]|\'[])", "|%1");
    local v4 = string.gsub(v3, "\r", "|r");

    return string.gsub(v4, "\n", "|n");
end;

local function teamCityEnterSuite(p5) -- Line: 14
    local format = string.format;
    local v6 = string.gsub(p5, "([]|\'[])", "|%1");
    local v7 = string.gsub(v6, "\r", "|r");

    return format("##teamcity[testSuiteStarted name=\'%s\']", (string.gsub(v7, "\n", "|n")));
end;

local function teamCityLeaveSuite(p8) -- Line: 18
    local format = string.format;
    local v9 = string.gsub(p8, "([]|\'[])", "|%1");
    local v10 = string.gsub(v9, "\r", "|r");

    return format("##teamcity[testSuiteFinished name=\'%s\']", (string.gsub(v10, "\n", "|n")));
end;

local function teamCityEnterCase(p11) -- Line: 22
    local format = string.format;
    local v12 = string.gsub(p11, "([]|\'[])", "|%1");
    local v13 = string.gsub(v12, "\r", "|r");

    return format("##teamcity[testStarted name=\'%s\']", (string.gsub(v13, "\n", "|n")));
end;

local function teamCityLeaveCase(p14) -- Line: 26
    local format = string.format;
    local v15 = string.gsub(p14, "([]|\'[])", "|%1");
    local v16 = string.gsub(v15, "\r", "|r");

    return format("##teamcity[testFinished name=\'%s\']", (string.gsub(v16, "\n", "|n")));
end;

local function teamCityFailCase(p17, p18) -- Line: 30
    local format = string.format;
    local v19 = string.gsub(p17, "([]|\'[])", "|%1");
    local v20 = string.gsub(v19, "\r", "|r");
    local v21 = string.gsub(v20, "\n", "|n");
    local v22 = string.gsub(p18, "([]|\'[])", "|%1");
    local v23 = string.gsub(v22, "\r", "|r");

    return format("##teamcity[testFailed name=\'%s\' message=\'%s\']", v21, (string.gsub(v23, "\n", "|n")));
end;

local function reportNode(p24, p25, p26) -- Line: 38
    -- upvalues: TestEnum (copy), teamCityEnterSuite (copy), reportNode (copy), teamCityLeaveSuite (copy), teamCityEnterCase (copy), teamCityFailCase (copy), teamCityLeaveCase (copy)
    local v27 = p25 or {};
    local v28 = p26 or 0;

    if p24.status == TestEnum.TestStatus.Skipped then
        return v27;
    end;

    if p24.planNode.type == TestEnum.NodeType.Describe then
        table.insert(v27, teamCityEnterSuite(p24.planNode.phrase));

        for _, v in ipairs(p24.children) do
            reportNode(v, v27, v28 + 1);
        end;

        table.insert(v27, teamCityLeaveSuite(p24.planNode.phrase));

        return;
    end;

    table.insert(v27, teamCityEnterCase(p24.planNode.phrase));

    if p24.status == TestEnum.TestStatus.Failure then
        table.insert(v27, teamCityFailCase(p24.planNode.phrase, table.concat(p24.errors, "\n")));
    end;

    table.insert(v27, teamCityLeaveCase(p24.planNode.phrase));
end;

local function reportRoot(p29) -- Line: 59
    -- upvalues: reportNode (copy)
    local v30 = {};

    for _, v in ipairs(p29.children) do
        reportNode(v, v30, 0);
    end;

    return v30;
end;

local function report(p31) -- Line: 69
    -- upvalues: reportRoot (copy)
    local v32 = reportRoot(p31);

    return table.concat(v32, "\n");
end;

function v1.report(p33) -- Line: 75
    -- upvalues: reportRoot (copy), TestService (copy)
    local v34 = {};
    local v35 = reportRoot(p33);
    v34[1], v34[2], v34[3] = "Test results:", table.concat(v35, "\n"), ("%d passed, %d failed, %d skipped"):format(p33.successCount, p33.failureCount, p33.skippedCount);
    print(table.concat(v34, "\n"));

    if p33.failureCount > 0 then
        print(("%d test nodes reported failures."):format(p33.failureCount));
    end;

    if #p33.errors > 0 then
        print("Errors reported by tests:");
        print("");

        for _, v in ipairs(p33.errors) do
            TestService:Error(v);
            print("");
        end;
    end;
end;

return v1;