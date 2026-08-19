-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local cleanup = require(Parent.Utility.cleanup);
local xtypeof = require(Parent.Utility.xtypeof);
local logError = require(Parent.Logging.logError);
local Observer = require(Parent.State.Observer);

local function setProperty_unsafe(p1, p2, p3) -- Line: 23
    p1[p2] = p3;
end;

local function testPropertyAssignable(p4, p5) -- Line: 27
    p4[p5] = p4[p5];
end;

local function setProperty(p6, p7, p8) -- Line: 31
    -- upvalues: setProperty_unsafe (copy), testPropertyAssignable (copy), logError (copy)
    if not pcall(setProperty_unsafe, p6, p7, p8) then
        if not pcall(testPropertyAssignable, p6, p7) then
            if p6 == nil then
                logError("setPropertyNilRef", nil, p7, (tostring(p8)));

                return;
            end;

            logError("cannotAssignProperty", nil, p6.ClassName, p7);

            return;
        end;

        local v9 = typeof(p8);
        local v10 = typeof(p6[p7]);
        logError("invalidPropertyType", nil, p6.ClassName, p7, v10, v9);
    end;
end;

local function bindProperty(u11, u12, u13, p14) -- Line: 51
    -- upvalues: xtypeof (copy), setProperty (copy), Observer (copy)
    if xtypeof(u13) ~= "State" then
        setProperty(u11, u12, u13);

        return;
    end;

    local u15 = false;

    local function updateLater() -- Line: 55
        -- upvalues: u15 (ref), setProperty (ref), u11 (copy), u12 (copy), u13 (copy)
        if not u15 then
            u15 = true;
            task.defer(function() -- Line: 58
                -- upvalues: u15 (ref), setProperty (ref), u11 (ref), u12 (ref), u13 (ref)
                u15 = false;
                setProperty(u11, u12, u13:get(false));
            end);
        end;
    end;

    setProperty(u11, u12, u13:get(false));
    local v16 = Observer(u13);
    table.insert(p14, v16:onChange(updateLater));
end;

return function(p17, p18) -- Line: 73, Name: applyInstanceProps
    -- upvalues: xtypeof (copy), bindProperty (copy), logError (copy), cleanup (copy)
    local v19 = {
        self = {},
        descendants = {},
        ancestor = {},
        observer = {}
    };
    local u20 = {};

    for i, v in pairs(p17) do
        local v21 = xtypeof(i);

        if v21 == "string" then
            if i ~= "Parent" then
                bindProperty(p18, i, v, u20);
            end;
        elseif v21 == "SpecialKey" then
            local stage = i.stage;
            local v22 = v19[stage];

            if v22 == nil then
                logError("unrecognisedPropertyStage", nil, stage);
            else
                v22[i] = v;
            end;
        else
            logError("unrecognisedPropertyKey", nil, xtypeof(i));
        end;
    end;

    for i, v in pairs(v19.self) do
        i:apply(v, p18, u20);
    end;

    for i, v in pairs(v19.descendants) do
        i:apply(v, p18, u20);
    end;

    if p17.Parent ~= nil then
        bindProperty(p18, "Parent", p17.Parent, u20);
    end;

    for i, v in pairs(v19.ancestor) do
        i:apply(v, p18, u20);
    end;

    for i, v in pairs(v19.observer) do
        i:apply(v, p18, u20);
    end;

    p18.Destroying:Connect(function() -- Line: 121
        -- upvalues: cleanup (ref), u20 (copy)
        cleanup(u20);
    end);
end;