-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.Types);
local useDependency = require(Parent.Dependencies.useDependency);
local initDependency = require(Parent.Dependencies.initDependency);
local updateAll = require(Parent.Dependencies.updateAll);
local isSimilar = require(Parent.Utility.isSimilar);
local v1 = {};
local u2 = {
    __index = v1
};
local u3 = {
    __mode = "k"
};

function v1.get(p4, p5) -- Line: 25
    -- upvalues: useDependency (copy)
    if p5 ~= false then
        useDependency(p4);
    end;

    return p4._value;
end;

function v1.set(p6, p7, p8) -- Line: 39
    -- upvalues: isSimilar (copy), updateAll (copy)
    if p8 or not isSimilar(p6._value, p7) then
        p6._value = p7;
        updateAll(p6);
    end;
end;

return function(p9) -- Line: 47, Name: Value
    -- upvalues: u3 (copy), u2 (copy), initDependency (copy)
    local v10 = {
        type = "State",
        kind = "Value",
        dependentSet = setmetatable({}, u3),
        _value = p9
    };
    local v11 = setmetatable(v10, u2);
    initDependency(v11);

    return v11;
end;