-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local u3 = {
    Validate = function(p1) -- Line: 4, Name: Validate
        if p1:match("^https?://.+$") then
            return true;
        end;

        return false, "URLs must begin with http:// or https://";
    end,

    Parse = function(p2) -- Line: 12, Name: Parse
        return p2;
    end
};

return function(p4) -- Line: 17
    -- upvalues: u3 (copy), Util (copy)
    p4:RegisterType("url", u3);
    p4:RegisterType("urls", Util.MakeListableType(u3));
end;