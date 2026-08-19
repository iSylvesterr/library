-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local logError = require(Parent.Logging.logError);
local xtypeof = require(Parent.Utility.xtypeof);

return {
    type = "SpecialKey",
    kind = "Ref",
    stage = "observer",

    apply = function(p1, u2, p3, p4) -- Line: 18, Name: apply
        -- upvalues: xtypeof (copy), logError (copy)
        if xtypeof(u2) ~= "State" or u2.kind ~= "Value" then
            logError("invalidRefType");

            return;
        end;

        u2:set(p3);
        table.insert(p4, function() -- Line: 23
            -- upvalues: u2 (copy)
            u2:set(nil);
        end);
    end
};