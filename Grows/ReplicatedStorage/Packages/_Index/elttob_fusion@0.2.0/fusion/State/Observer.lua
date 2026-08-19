-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
require(Parent.Types);
local initDependency = require(Parent.Dependencies.initDependency);
local v1 = {};
local u2 = {
    __index = v1
};
local u3 = {};

function v1.update(p4) -- Line: 26
    for _, v in pairs(p4._changeListeners) do
        task.spawn(v);
    end;

    return false;
end;

function v1.onChange(u5, p6) -- Line: 41
    -- upvalues: u3 (copy)
    local u7 = {};
    u5._numChangeListeners = u5._numChangeListeners + 1;
    u5._changeListeners[u7] = p6;
    u3[u5] = true;
    local u8 = false;

    return function() -- Line: 51
        -- upvalues: u8 (ref), u5 (copy), u7 (copy), u3 (ref)
        if u8 then
            return;
        end;

        u8 = true;
        u5._changeListeners[u7] = nil;
        local v9 = u5;
        v9._numChangeListeners = v9._numChangeListeners - 1;

        if u5._numChangeListeners == 0 then
            u3[u5] = nil;
        end;
    end;
end;

return function(p10) -- Line: 66, Name: Observer
    -- upvalues: u2 (copy), initDependency (copy)
    local v11 = setmetatable({
        type = "State",
        kind = "Observer",
        _numChangeListeners = 0,
        dependencySet = {
            [p10] = true
        },
        dependentSet = {},
        _changeListeners = {}
    }, u2);
    initDependency(v11);
    p10.dependentSet[v11] = true;

    return v11;
end;