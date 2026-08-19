-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local sharedState = require(Parent.Dependencies.sharedState);
local initialisedStack = sharedState.initialisedStack;

return function(p1) -- Line: 14, Name: useDependency
    -- upvalues: sharedState (copy), initialisedStack (copy)
    local dependencySet = sharedState.dependencySet;

    if dependencySet ~= nil then
        local initialisedStackSize = sharedState.initialisedStackSize;

        if initialisedStackSize > 0 and initialisedStack[initialisedStackSize][p1] ~= nil then
            return;
        end;

        dependencySet[p1] = true;
    end;
end;