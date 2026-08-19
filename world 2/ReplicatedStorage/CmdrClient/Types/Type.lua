-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);

return function(u1) -- Line: 3
    -- upvalues: Util (copy)
    local v6 = {
        Transform = function(p2) -- Line: 5, Name: Transform
            -- upvalues: Util (ref), u1 (copy)
            return Util.MakeFuzzyFinder(u1:GetTypeNames())(p2);
        end,

        Validate = function(p3) -- Line: 11, Name: Validate
            return #p3 > 0, "No type with that name could be found.";
        end,

        Autocomplete = function(p4) -- Line: 15, Name: Autocomplete
            return p4;
        end,

        Parse = function(p5) -- Line: 19, Name: Parse
            return p5[1];
        end
    };
    u1:RegisterType("type", v6);
    u1:RegisterType("types", Util.MakeListableType(v6));
end;