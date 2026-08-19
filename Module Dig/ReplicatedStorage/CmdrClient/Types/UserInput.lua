-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local u1 = Enum.UserInputType:GetEnumItems();

for _, v in pairs(Enum.KeyCode:GetEnumItems()) do
    u1[#u1 + 1] = v;
end;

local u6 = {
    Transform = function(p2) -- Line: 10, Name: Transform
        -- upvalues: Util (copy), u1 (copy)
        return Util.MakeFuzzyFinder(u1)(p2);
    end,

    Validate = function(p3) -- Line: 16, Name: Validate
        return #p3 > 0;
    end,

    Autocomplete = function(p4) -- Line: 20, Name: Autocomplete
        -- upvalues: Util (copy)
        return Util.GetNames(p4);
    end,

    Parse = function(p5) -- Line: 24, Name: Parse
        return p5[1];
    end
};

return function(p7) -- Line: 29
    -- upvalues: u6 (copy), Util (copy)
    p7:RegisterType("userInput", u6);
    p7:RegisterType("userInputs", Util.MakeListableType(u6));
end;