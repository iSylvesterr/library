-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local parseError = require(Parent.Logging.parseError);
local sharedState = require(Parent.Dependencies.sharedState);
local initialisedStack = sharedState.initialisedStack;
local u1 = 0;

return function(p2, p3, ...) -- Line: 25, Name: captureDependencies
    -- upvalues: sharedState (copy), u1 (ref), initialisedStack (copy), parseError (copy)
    local dependencySet = sharedState.dependencySet;
    sharedState.dependencySet = p2;
    local v4 = sharedState;
    v4.initialisedStackSize = v4.initialisedStackSize + 1;
    local initialisedStackSize = sharedState.initialisedStackSize;

    if u1 < initialisedStackSize then
        initialisedStack[initialisedStackSize] = {};
        u1 = initialisedStackSize;
    else
        table.clear(initialisedStack[initialisedStackSize]);
    end;

    local v5 = table.pack(xpcall(p3, parseError, ...));
    sharedState.dependencySet = dependencySet;
    local v6 = sharedState;
    v6.initialisedStackSize = v6.initialisedStackSize - 1;

    return table.unpack(v5, 1, v5.n);
end;