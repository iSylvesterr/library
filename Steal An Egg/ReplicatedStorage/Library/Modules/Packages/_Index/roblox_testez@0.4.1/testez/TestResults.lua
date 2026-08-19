-- Decompiled with Potassium's decompiler.

local TestEnum = require(script.Parent.TestEnum);
local u1 = {
    [TestEnum.TestStatus.Success] = "+",
    [TestEnum.TestStatus.Failure] = "-",
    [TestEnum.TestStatus.Skipped] = "~"
};
local u2 = {};
u2.__index = u2;

function u2.new(p3) -- Line: 25
    -- upvalues: u2 (copy)
    local v4 = {
        successCount = 0,
        failureCount = 0,
        skippedCount = 0,
        planNode = p3,
        children = {},
        errors = {}
    };
    setmetatable(v4, u2);

    return v4;
end;

function u2.createNode(p5) -- Line: 43
    return {
        status = nil,
        planNode = p5,
        children = {},
        errors = {}
    };
end;

function u2.visitAllNodes(p6, p7, p8) -- Line: 57
    for _, v in ipairs((p8 or p6).children) do
        p7(v);
        p6:visitAllNodes(p7, v);
    end;
end;

function u2.visualize(p9, p10, p11) -- Line: 70
    -- upvalues: TestEnum (copy), u1 (copy)
    local v12 = p11 or 0;
    local v13 = {};

    for _, v in ipairs((p10 or p9).children) do
        if v.planNode.type == TestEnum.NodeType.It then
            local v14 = u1[v.status] or "?";
            local v15 = ("%s[%s] %s"):format((" "):rep(3 * v12), v14, v.planNode.phrase);

            if v.messages and #v.messages > 0 then
                v15 = v15 .. "\n " .. (" "):rep(3 * v12) .. table.concat(v.messages, "\n " .. (" "):rep(3 * v12));
            end;

            table.insert(v13, v15);
        else
            local v16 = ("%s%s"):format((" "):rep(3 * v12), v.planNode.phrase or "");

            if v.status then
                v16 = v16 .. (" (%s)"):format(v.status);
            end;

            table.insert(v13, v16);

            if #v.children > 0 then
                local v17 = p9:visualize(v, v12 + 1);
                table.insert(v13, v17);
            end;
        end;
    end;

    return table.concat(v13, "\n");
end;

return u2;