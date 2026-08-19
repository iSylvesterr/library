-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.Types);
local captureDependencies = require(Parent.Dependencies.captureDependencies);
local initDependency = require(Parent.Dependencies.initDependency);
local useDependency = require(Parent.Dependencies.useDependency);
local logErrorNonFatal = require(Parent.Logging.logErrorNonFatal);
local logWarn = require(Parent.Logging.logWarn);
local isSimilar = require(Parent.Utility.isSimilar);
local needsDestruction = require(Parent.Utility.needsDestruction);
local v1 = {};
local u2 = {
    __index = v1
};
local u3 = {
    __mode = "k"
};

function v1.get(p4, p5) -- Line: 28
    -- upvalues: useDependency (copy)
    if p5 ~= false then
        useDependency(p4);
    end;

    return p4._value;
end;

function v1.update(p6) -- Line: 39
    -- upvalues: captureDependencies (copy), needsDestruction (copy), logWarn (copy), isSimilar (copy), logErrorNonFatal (copy)
    for i in pairs(p6.dependencySet) do
        i.dependentSet[p6] = nil;
    end;

    local _oldDependencySet = p6._oldDependencySet;
    p6._oldDependencySet = p6.dependencySet;
    p6.dependencySet = _oldDependencySet;
    table.clear(p6.dependencySet);
    local v7, v8, v9 = captureDependencies(p6.dependencySet, p6._processor);

    if not v7 then
        logErrorNonFatal("computedCallbackError", v8);
        local _oldDependencySet2 = p6._oldDependencySet;
        p6._oldDependencySet = p6.dependencySet;
        p6.dependencySet = _oldDependencySet2;

        for i in pairs(p6.dependencySet) do
            i.dependentSet[p6] = true;
        end;

        return false;
    end;

    if p6._destructor == nil and needsDestruction(v8) then
        logWarn("destructorNeededComputed");
    end;

    if v9 ~= nil then
        logWarn("multiReturnComputed");
    end;

    local _value = p6._value;
    local v10 = isSimilar(_value, v8);

    if p6._destructor ~= nil then
        p6._destructor(_value);
    end;

    p6._value = v8;

    for i in pairs(p6.dependencySet) do
        i.dependentSet[p6] = true;
    end;

    return not v10;
end;

return function(p11, p12) -- Line: 93, Name: Computed
    -- upvalues: u3 (copy), u2 (copy), initDependency (copy)
    local v13 = {
        type = "State",
        kind = "Computed",
        _value = nil,
        dependencySet = {},
        dependentSet = setmetatable({}, u3),
        _oldDependencySet = {},
        _processor = p11,
        _destructor = p12
    };
    local v14 = setmetatable(v13, u2);
    initDependency(v14);
    v14:update();

    return v14;
end;