-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local u1 = require(ReplicatedStorage.Library.Modules.Packages.Log).new();

return function(p2, p3) -- Line: 10
    -- upvalues: Asserts (copy), u1 (copy)
    Asserts.table(p2);

    for i, v in pairs(p2) do
        if typeof(v) == "table" then
            if not table.isfrozen(v) then
                v._id = i;
            end;

            if p3 and not table.isfrozen(v) then
                table.freeze(v);
            end;
        else
            u1:AtWarning():Log((`Invalid value for '{i}' when loading dir`));
        end;
    end;

    return p2;
end;