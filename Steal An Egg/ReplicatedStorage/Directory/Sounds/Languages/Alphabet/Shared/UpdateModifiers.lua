-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local Interface = require(script.Parent.Parent.Types.Interface);
local Parent = require(script.Parent.Parent);

return function(p1, p2) -- Line: 10
    -- upvalues: Interface (copy), Parent (copy), Asserts (copy)
    assert(Interface.UpdateModifiers(p1, p2));

    if typeof(p1) == "string" then
        p1 = Parent[p1];
    end;

    Asserts.table(p1);

    for i, v in p2 do
        local v3 = p1[i];
        local v4 = `Letter "{i}" does not exist in the alphabet container`;
        local v5 = assert(v3, v4);

        for _, v2 in v5.Modifiers do
            v2.Parent = nil;
        end;

        for _, v2 in v do
            v2.Parent = v5.Sound;
        end;
    end;

    return p1;
end;