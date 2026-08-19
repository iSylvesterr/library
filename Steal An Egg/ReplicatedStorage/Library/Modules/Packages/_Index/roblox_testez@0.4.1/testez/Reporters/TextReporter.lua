-- Decompiled with Potassium's decompiler.

local TestService = game:GetService("TestService");
local TestEnum = require(script.Parent.Parent.TestEnum);
local u1 = (" "):rep(3);
local u2 = {
    [TestEnum.TestStatus.Success] = "+",
    [TestEnum.TestStatus.Failure] = "-",
    [TestEnum.TestStatus.Skipped] = "~"
};
local v3 = {};

local function compareNodes(p4, p5) -- Line: 20
    return p4.planNode.phrase:lower() < p5.planNode.phrase:lower();
end;

local function reportNode(p6, p7, p8) -- Line: 24
    -- upvalues: TestEnum (copy), u2 (copy), u1 (copy), compareNodes (copy), reportNode (copy)
    local v9 = p7 or {};
    local v10 = p8 or 0;

    if p6.status == TestEnum.TestStatus.Skipped then
        return v9;
    end;

    local v11;

    if p6.status then
        local v12 = u2[p6.status] or "?";
        v11 = ("%s[%s] %s"):format(u1:rep(v10), v12, p6.planNode.phrase);
    else
        v11 = ("%s%s"):format(u1:rep(v10), p6.planNode.phrase);
    end;

    table.insert(v9, v11);
    table.sort(p6.children, compareNodes);

    for _, v in ipairs(p6.children) do
        reportNode(v, v9, v10 + 1);
    end;

    return v9;
end;

local function reportRoot(p13) -- Line: 52
    -- upvalues: compareNodes (copy), reportNode (copy)
    table.sort(p13.children, compareNodes);
    local v14 = {};

    for _, v in ipairs(p13.children) do
        reportNode(v, v14, 0);
    end;

    return v14;
end;

local function report(p15) -- Line: 63
    -- upvalues: reportRoot (copy)
    local v16 = reportRoot(p15);

    return table.concat(v16, "\n");
end;

function v3.report(p17) -- Line: 69
    -- upvalues: reportRoot (copy), TestService (copy)
    local v18 = {};
    local v19 = reportRoot(p17);
    v18[1], v18[2], v18[3] = "Test results:", table.concat(v19, "\n"), ("%d passed, %d failed, %d skipped"):format(p17.successCount, p17.failureCount, p17.skippedCount);
    print(table.concat(v18, "\n"));

    if p17.failureCount > 0 then
        print(("%d test nodes reported failures."):format(p17.failureCount));
    end;

    if #p17.errors > 0 then
        print("Errors reported by tests:");
        print("");

        for _, v in ipairs(p17.errors) do
            TestService:Error(v);
            print("");
        end;
    end;
end;

return v3;