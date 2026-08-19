-- Decompiled with Potassium's decompiler.

local TestPlanner = require(script.Parent.TestPlanner);
local TestRunner = require(script.Parent.TestRunner);
local TextReporter = require(script.Parent.Reporters.TextReporter);
local v1 = {};

local function stripSpecSuffix(p2) -- Line: 11
    return p2:gsub("%.spec$", "");
end;

local function isSpecScript(p3) -- Line: 14
    local v4 = p3:IsA("ModuleScript") and p3.Name:match("%.spec$");

    return v4;
end;

local function getPath(p5, p6) -- Line: 18
    local v7 = p6 or game;
    local v8 = {};

    if p5.Name == "init.spec" then
        p5 = p5.Parent;
    end;

    while p5 ~= nil and p5 ~= v7 do
        local v9 = p5.Name:gsub("%.spec$", "");
        table.insert(v8, v9);
        p5 = p5.Parent;
    end;

    local v10 = v7.Name:gsub("%.spec$", "");
    table.insert(v8, v10);

    return v8;
end;

local function toStringPath(p11) -- Line: 38
    local v12 = true;
    local v13 = "";

    for _, v in ipairs(p11) do
        if v12 then
            v13 = v;
            v12 = false;
        else
            v13 = v .. " " .. v13;
        end;
    end;

    return v13;
end;

function v1.getModulesImpl(p14, p15, p16, p17) -- Line: 52
    -- upvalues: getPath (copy)
    local v18 = p16 or {};
    local v19 = p17 or p15;
    local v20 = v19:IsA("ModuleScript") and v19.Name:match("%.spec$");

    if v20 then
        local v21 = require(v19);
        local v22 = getPath(v19, p15);
        local v23 = true;
        local v24 = "";

        for _, v in ipairs(v22) do
            if v23 then
                v24 = v;
                v23 = false;
            else
                v24 = v .. " " .. v24;
            end;
        end;

        local v25 = {
            method = v21,
            path = v22,
            pathStringForSorting = v24:lower()
        };
        table.insert(v18, v25);
    end;
end;

function v1.getModules(p26, p27) -- Line: 72
    local v28 = {};
    p26:getModulesImpl(p27, v28);

    for _, descendant in ipairs(p27:GetDescendants()) do
        p26:getModulesImpl(p27, v28, descendant);
    end;

    return v28;
end;

function v1.run(p29, p30, p31, p32) -- Line: 99
    -- upvalues: TextReporter (copy), TestPlanner (copy), TestRunner (copy)
    local v33 = p32 or {};
    local v34 = v33.showTimingInfo or false;
    local testNamePattern = v33.testNamePattern;
    local v35 = v33.extraEnvironment or {};

    if type(p30) ~= "table" then
        error(("Bad argument #1 to TestBootstrap:run. Expected table, got %s"):format((typeof(p30))), 2);
    end;

    local v36 = tick();
    local v37 = {};

    for _, v in ipairs(p30) do
        local v38 = p29:getModules(v);

        for _, v2 in ipairs(v38) do
            table.insert(v37, v2);
        end;
    end;

    local v39 = tick();
    local v40 = TestPlanner.createPlan(v37, testNamePattern, v35);
    local v41 = tick();
    local v42 = TestRunner.runPlan(v40);
    local v43 = tick();
    (p31 or TextReporter).report(v42);
    local v44 = tick();

    if v34 then
        local v45 = {
            ("Took %f seconds to locate test modules"):format(v39 - v36),
            ("Took %f seconds to create test plan"):format(v41 - v39),
            ("Took %f seconds to run tests"):format(v43 - v41),
            ("Took %f seconds to report tests"):format(v44 - v43)
        };
        print(table.concat(v45, "\n"));
    end;

    return v42;
end;

return v1;