-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
game:GetService("ReplicatedStorage");

local function getCurrencyNames() -- Line: 4
    return { "IronBars", "Yen" };
end;

local u5 = {
    Transform = function(p1) -- Line: 9, Name: Transform
        -- upvalues: Util (copy)
        return Util.MakeFuzzyFinder({ "IronBars", "Yen" })(p1);
    end,

    Validate = function(p2) -- Line: 15, Name: Validate
        return #p2 > 0, "No currency with that name could be found.";
    end,

    Autocomplete = function(p3) -- Line: 19, Name: Autocomplete
        return p3;
    end,

    Parse = function(p4) -- Line: 23, Name: Parse
        return p4[1];
    end
};

return function(p6) -- Line: 28
    -- upvalues: u5 (copy)
    p6:RegisterType("currencyName", u5);
end;