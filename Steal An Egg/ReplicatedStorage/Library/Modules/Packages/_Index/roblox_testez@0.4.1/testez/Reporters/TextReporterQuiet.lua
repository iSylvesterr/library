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

local function reportNode(p4, p5, p6) -- Line: 22
    -- upvalues: TestEnum (copy), u2 (copy), u1 (copy), reportNode (copy)
    local v7 = p5 or {};
    local v8 = p6 or 0;

    if p4.status == TestEnum.TestStatus.Skipped then
        return v7;
    end;

    local v9;

    if p4.status == TestEnum.TestStatus.Success then
        v9 = nil;
    else
        local v10 = u2[p4.status] or "?";
        v9 = ("%s[%s] %s"):format(u1:rep(v8), v10, p4.planNode.phrase);
    end;

    table.insert(v7, v9);

    for _, v in ipairs(p4.children) do
        reportNode(v, v7, v8 + 1);
    end;

    return v7;
end;

local function reportRoot(p11) -- Line: 47
    -- upvalues: reportNode (copy)
    local v12 = {};

    for _, v in ipairs(p11.children) do
        reportNode(v, v12, 0);
    end;

    return v12;
end;

local function report(p13) -- Line: 57
    -- upvalues: reportRoot (copy)
    local v14 = reportRoot(p13);

    return table.concat(v14, "\n");
end;

function v3.report(p15) -- Line: 63
    -- upvalues: reportRoot (copy), TestService (copy)
    local v16 = {};
    local v17 = reportRoot(p15);
    v16[1], v16[2], v16[3] = "Test results:", table.concat(v17, "\n"), ("%d passed, %d failed, %d skipped"):format(p15.successCount, p15.failureCount, p15.skippedCount);
    print(table.concat(v16, "\n"));

    if p15.failureCount > 0 then
        print(("%d test nodes reported failures."):format(p15.failureCount));
    end;

    if #p15.errors > 0 then
        print("Errors reported by tests:");
        print("");

        for _, v in ipairs(p15.errors) do
            TestService:Error(v);
            print("");
        end;
    end;
end;

return v3;