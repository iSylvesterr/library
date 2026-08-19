-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local sharedState = require(Parent.Dependencies.sharedState);
local initialisedStack = sharedState.initialisedStack;

return function(p1) -- Line: 16, Name: initDependency
    -- upvalues: sharedState (copy), initialisedStack (copy)
    local initialisedStackSize = sharedState.initialisedStackSize;

    for i, v in ipairs(initialisedStack) do
        if initialisedStackSize < i then
            return;
        end;

        v[p1] = true;
    end;
end;