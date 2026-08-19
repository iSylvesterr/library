-- Decompiled with Potassium's decompiler.

local TestEnum = require(script.Parent.TestEnum);
local Expectation = require(script.Parent.Expectation);

local function newEnvironment(u1, p2) -- Line: 11
    -- upvalues: TestEnum (copy), Expectation (copy)
    local v3 = {};

    if p2 then
        if type(p2) ~= "table" then
            error(("Bad argument #2 to newEnvironment. Expected table, got %s"):format((typeof(p2))), 2);
        end;

        for i, v in pairs(p2) do
            v3[i] = v;
        end;
    end;

    local function addChild(p4, p5, p6, p7) -- Line: 24
        -- upvalues: u1 (copy), TestEnum (ref)
        local v8 = u1:addChild(p4, p6, p7);
        v8.callback = p5;

        if p6 == TestEnum.NodeType.Describe then
            v8:expand();
        end;

        return v8;
    end;

    function v3.describeFOCUS(p9, p10) -- Line: 33
        -- upvalues: addChild (copy), TestEnum (ref)
        addChild(p9, p10, TestEnum.NodeType.Describe, TestEnum.NodeModifier.Focus);
    end;

    function v3.describeSKIP(p11, p12) -- Line: 37
        -- upvalues: addChild (copy), TestEnum (ref)
        addChild(p11, p12, TestEnum.NodeType.Describe, TestEnum.NodeModifier.Skip);
    end;

    function v3.describe(p13, p14, p15) -- Line: 41
        -- upvalues: addChild (copy), TestEnum (ref)
        addChild(p13, p14, TestEnum.NodeType.Describe, TestEnum.NodeModifier.None);
    end;

    function v3.itFOCUS(p16, p17) -- Line: 45
        -- upvalues: addChild (copy), TestEnum (ref)
        addChild(p16, p17, TestEnum.NodeType.It, TestEnum.NodeModifier.Focus);
    end;

    function v3.itSKIP(p18, p19) -- Line: 49
        -- upvalues: addChild (copy), TestEnum (ref)
        addChild(p18, p19, TestEnum.NodeType.It, TestEnum.NodeModifier.Skip);
    end;

    function v3.itFIXME(p20, p21) -- Line: 53
        -- upvalues: addChild (copy), TestEnum (ref)
        local v22 = addChild(p20, p21, TestEnum.NodeType.It, TestEnum.NodeModifier.Skip);
        warn("FIXME: broken test", v22:getFullName());
    end;

    function v3.it(p23, p24, p25) -- Line: 58
        -- upvalues: addChild (copy), TestEnum (ref)
        addChild(p23, p24, TestEnum.NodeType.It, TestEnum.NodeModifier.None);
    end;

    local u26 = 0;

    for i, v in pairs({
        [TestEnum.NodeType.BeforeAll] = "beforeAll",
        [TestEnum.NodeType.AfterAll] = "afterAll",
        [TestEnum.NodeType.BeforeEach] = "beforeEach",
        [TestEnum.NodeType.AfterEach] = "afterEach"
    }) do
        v3[v] = function(p27) -- Line: 73
            -- upvalues: addChild (copy), v (copy), u26 (ref), i (copy), TestEnum (ref)
            addChild(v .. "_" .. tostring(u26), p27, i, TestEnum.NodeModifier.None);
            u26 = u26 + 1;
        end;
    end;

    function v3.FIXME(p28) -- Line: 79
        -- upvalues: u1 (copy), TestEnum (ref)
        warn("FIXME: broken test", u1:getFullName(), p28 or "");
        u1.modifier = TestEnum.NodeModifier.Skip;
    end;

    function v3.FOCUS() -- Line: 85
        -- upvalues: u1 (copy), TestEnum (ref)
        u1.modifier = TestEnum.NodeModifier.Focus;
    end;

    function v3.SKIP() -- Line: 89
        -- upvalues: u1 (copy), TestEnum (ref)
        u1.modifier = TestEnum.NodeModifier.Skip;
    end;

    function v3.HACK_NO_XPCALL() -- Line: 97
        warn("HACK_NO_XPCALL is deprecated. It is now safe to yield in an xpcall, so this is no longer necessary. It can be safely deleted.");
    end;

    v3.fit = v3.itFOCUS;
    v3.xit = v3.itSKIP;
    v3.fdescribe = v3.describeFOCUS;
    v3.xdescribe = v3.describeSKIP;
    v3.expect = setmetatable({
        extend = function(...) -- Line: 110, Name: extend
            error("Cannot call \"expect.extend\" from within a \"describe\" node.");
        end
    }, {
        __call = function(p29, ...) -- Line: 114, Name: __call
            -- upvalues: Expectation (ref)
            return Expectation.new(...);
        end
    });

    return v3;
end;

local u30 = {};
u30.__index = u30;

function u30.new(p31, p32, p33, p34) -- Line: 130
    -- upvalues: TestEnum (copy), newEnvironment (copy), u30 (copy)
    local v35 = {
        callback = nil,
        parent = nil,
        plan = p31,
        phrase = p32,
        type = p33,
        modifier = p34 or TestEnum.NodeModifier.None,
        children = {}
    };
    v35.environment = newEnvironment(v35, p31.extraEnvironment);

    return setmetatable(v35, u30);
end;

local function getModifier(p36, p37, p38) -- Line: 147
    -- upvalues: TestEnum (copy)
    if not p37 or p38 ~= nil and p38 ~= TestEnum.NodeModifier.None then
        return p38;
    end;

    if p36:match(p37) then
        return TestEnum.NodeModifier.Focus;
    end;

    return TestEnum.NodeModifier.Skip;
end;

function u30.addChild(p39, p40, p41, p42) -- Line: 158
    -- upvalues: TestEnum (copy), getModifier (copy), u30 (copy)
    if p41 == TestEnum.NodeType.It then
        for _, v in pairs(p39.children) do
            if v.phrase == p40 then
                error("Duplicate it block found: " .. v:getFullName());
            end;
        end;
    end;

    local v43 = getModifier(p39:getFullName() .. " " .. p40, p39.plan.testNamePattern, p42);
    local v44 = u30.new(p39.plan, p40, p41, v43);
    v44.parent = p39;
    table.insert(p39.children, v44);

    return v44;
end;

function u30.getFullName(p45) -- Line: 178
    local v46 = p45.parent and p45.parent:getFullName();

    if v46 then
        return v46 .. " " .. p45.phrase;
    end;

    return p45.phrase;
end;

function u30.expand(p47) -- Line: 192
    local v48 = getfenv(p47.callback);
    local v49 = setmetatable({}, {
        __index = v48
    });

    for i, v in pairs(p47.environment) do
        v49[i] = v;
    end;

    v49.script = v48.script;
    setfenv(p47.callback, v49);
    local v51, v52 = xpcall(p47.callback, function(p50) -- Line: 203
        return debug.traceback(tostring(p50), 2);
    end);

    if not v51 then
        p47.loadError = v52;
    end;
end;

local u53 = {};
u53.__index = u53;

function u53.new(p54, p55) -- Line: 218
    -- upvalues: u53 (copy)
    return setmetatable({
        children = {},
        testNamePattern = p54,
        extraEnvironment = p55
    }, u53);
end;

function u53.addChild(p56, p57, p58, p59) -- Line: 231
    -- upvalues: getModifier (copy), u30 (copy)
    local v60 = getModifier(p57, p56.testNamePattern, p59);
    local v61 = u30.new(p56, p57, p58, v60);
    table.insert(p56.children, v61);

    return v61;
end;

function u53.addRoot(p62, p63, p64) -- Line: 242
    -- upvalues: TestEnum (copy)
    for i = #p63, 1, -1 do
        local v65 = nil;

        for _, v in ipairs(p62.children) do
            if v.phrase == p63[i] then
                v65 = v;
                break;
            end;
        end;

        if v65 == nil then
            p62 = p62:addChild(p63[i], TestEnum.NodeType.Describe);
        else
            p62 = v65;
        end;
    end;

    p62.callback = p64;
    p62:expand();
end;

function u53.visitAllNodes(p66, p67, p68, p69) -- Line: 268
    local v70 = p69 or 0;

    for _, v in ipairs((p68 or p66).children) do
        p67(v, v70);
        p66:visitAllNodes(p67, v, v70 + 1);
    end;
end;

function u53.visualize(p71) -- Line: 283
    local u72 = {};
    p71:visitAllNodes(function(p73, p74) -- Line: 285
        -- upvalues: u72 (copy)
        local v75 = (" "):rep(3 * p74) .. p73.phrase;
        table.insert(u72, v75);
    end);

    return table.concat(u72, "\n");
end;

function u53.findNodes(p76, u77) -- Line: 295
    local u78 = {};
    p76:visitAllNodes(function(p79) -- Line: 297
        -- upvalues: u77 (copy), u78 (copy)
        if u77(p79) then
            table.insert(u78, p79);
        end;
    end);

    return u78;
end;

return u53;