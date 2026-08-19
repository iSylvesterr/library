-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local u3 = {
    Validate = function(p1) -- Line: 4, Name: Validate
        return p1 ~= nil;
    end,

    Parse = function(p2) -- Line: 8, Name: Parse
        return tostring(p2);
    end
};
local u7 = {
    Transform = function(p4) -- Line: 14, Name: Transform
        return tonumber(p4);
    end,

    Validate = function(p5) -- Line: 18, Name: Validate
        return p5 ~= nil;
    end,

    Parse = function(p6) -- Line: 22, Name: Parse
        return p6;
    end
};
local u12 = {
    Transform = function(p8) -- Line: 28, Name: Transform
        return tonumber(p8);
    end,

    Validate = function(p9) -- Line: 32, Name: Validate
        local v10;

        if p9 == nil then
            v10 = false;
        else
            v10 = p9 == math.floor(p9);
        end;

        return v10, "Only whole numbers are valid.";
    end,

    Parse = function(p11) -- Line: 36, Name: Parse
        return p11;
    end
};
local u17 = {
    Transform = function(p13) -- Line: 42, Name: Transform
        return tonumber(p13);
    end,

    Validate = function(p14) -- Line: 46, Name: Validate
        local v15;

        if p14 == nil or p14 ~= math.floor(p14) then
            v15 = false;
        else
            v15 = p14 > 0;
        end;

        return v15, "Only positive whole numbers are valid.";
    end,

    Parse = function(p16) -- Line: 50, Name: Parse
        return p16;
    end
};
local u22 = {
    Transform = function(p18) -- Line: 56, Name: Transform
        return tonumber(p18);
    end,

    Validate = function(p19) -- Line: 60, Name: Validate
        local v20;

        if p19 == nil or p19 ~= math.floor(p19) then
            v20 = false;
        else
            v20 = p19 >= 0;
        end;

        return v20, "Only non-negative whole numbers are valid.";
    end,

    Parse = function(p21) -- Line: 64, Name: Parse
        return p21;
    end
};
local u27 = {
    Transform = function(p23) -- Line: 70, Name: Transform
        return tonumber(p23);
    end,

    Validate = function(p24) -- Line: 74, Name: Validate
        local v25;

        if p24 == nil or (p24 ~= math.floor(p24) or p24 < 0) then
            v25 = false;
        else
            v25 = p24 <= 255;
        end;

        return v25, "Only bytes are valid.";
    end,

    Parse = function(p26) -- Line: 78, Name: Parse
        return p26;
    end
};
local u32 = {
    Transform = function(p28) -- Line: 84, Name: Transform
        return tonumber(p28);
    end,

    Validate = function(p29) -- Line: 88, Name: Validate
        local v30;

        if p29 == nil or (p29 ~= math.floor(p29) or p29 < 0) then
            v30 = false;
        else
            v30 = p29 <= 9;
        end;

        return v30, "Only digits are valid.";
    end,

    Parse = function(p31) -- Line: 92, Name: Parse
        return p31;
    end
};
local u33 = Util.MakeDictionary({ "true", "t", "yes", "y", "on", "enable", "enabled", "1", "+" });
local u34 = Util.MakeDictionary({ "false", "f", "no", "n", "off", "disable", "disabled", "0", "-" });
local u38 = {
    Transform = function(p35) -- Line: 102, Name: Transform
        return p35:lower();
    end,

    Validate = function(p36) -- Line: 106, Name: Validate
        -- upvalues: u33 (copy), u34 (copy)
        return u33[p36] ~= nil and true or u34[p36] ~= nil, "Please use true/yes/on or false/no/off.";
    end,

    Parse = function(p37) -- Line: 110, Name: Parse
        -- upvalues: u33 (copy), u34 (copy)
        if u33[p37] then
            return true;
        end;

        if u34[p37] then
            return false;
        end;

        return nil;
    end
};

return function(p39) -- Line: 122
    -- upvalues: u3 (copy), u7 (copy), u12 (copy), u17 (copy), u22 (copy), u27 (copy), u32 (copy), u38 (ref), Util (copy)
    p39:RegisterType("string", u3);
    p39:RegisterType("number", u7);
    p39:RegisterType("integer", u12);
    p39:RegisterType("positiveInteger", u17);
    p39:RegisterType("nonNegativeInteger", u22);
    p39:RegisterType("byte", u27);
    p39:RegisterType("digit", u32);
    p39:RegisterType("boolean", u38);
    p39:RegisterType("strings", Util.MakeListableType(u3));
    p39:RegisterType("numbers", Util.MakeListableType(u7));
    p39:RegisterType("integers", Util.MakeListableType(u12));
    p39:RegisterType("positiveIntegers", Util.MakeListableType(u17));
    p39:RegisterType("nonNegativeIntegers", Util.MakeListableType(u22));
    p39:RegisterType("bytes", Util.MakeListableType(u27));
    p39:RegisterType("digits", Util.MakeListableType(u32));
    p39:RegisterType("booleans", Util.MakeListableType(u38));
end;