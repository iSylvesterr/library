-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Trove = require(ReplicatedStorage.Library.Modules.Packages.Trove);
local t = require(ReplicatedStorage.Library.Modules.Packages.t);
local u1 = t.interface({
    removeFrom = t.table,
    object = t.table
});

local function verifyTrove(p2) -- Line: 36
    if typeof(p2) ~= "table" or typeof(p2.Add) ~= "function" then
        error("Bad trove configuration inside removed object. If no trove intended then opt for creating one via config.");
    end;

    return p2;
end;

return function(u3) -- Line: 47, Name: InjectAutoRemovalBehavior
    -- upvalues: u1 (copy), Trove (copy)
    assert(u1(u3));
    local object = u3.object;
    local removeFrom = u3.removeFrom;

    if u3.createTroveIfNotExists then
        u3.object._trove = Trove.new();
    end;

    local v4 = u3.overrideObjectTrove or object._trove;

    if typeof(v4) ~= "table" or typeof(v4.Add) ~= "function" then
        error("Bad trove configuration inside removed object. If no trove intended then opt for creating one via config.");
    end;

    if u3.indexOverride then
        removeFrom[u3.indexOverride] = object;
        v4:Add(function() -- Line: 62
            -- upvalues: removeFrom (copy), u3 (copy)
            removeFrom[u3.indexOverride] = nil;
        end);

        return object;
    end;

    table.insert(removeFrom, object);
    v4:Add(function() -- Line: 67
        -- upvalues: removeFrom (copy), object (copy)
        table.remove(removeFrom, table.find(removeFrom, object));
    end);

    return object;
end;