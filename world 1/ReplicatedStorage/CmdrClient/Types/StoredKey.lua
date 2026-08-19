-- Decompiled with Potassium's decompiler.

local Util = require(script.Parent.Parent.Shared.Util);
local u1 = { "^%a[%w_]*$", "^%$%a[%w_]*$", "^%.%a[%w_]*$", "^%$%.%a[%w_]*$" };

return function(u2) -- Line: 10
    -- upvalues: u1 (copy), Util (copy)
    local v6 = {
        Autocomplete = function(p3) -- Line: 12, Name: Autocomplete
            -- upvalues: u2 (copy)
            return u2.Cmdr.Util.MakeFuzzyFinder(u2.Cmdr.Util.DictionaryKeys(u2:GetStore("vars_used") or {}))(p3);
        end,

        Validate = function(p4) -- Line: 18, Name: Validate
            -- upvalues: u1 (ref)
            for _, v in ipairs(u1) do
                if p4:match(v) then
                    return true;
                end;
            end;

            return false, "Key names must start with an optional modifier: . $ or $. and must begin with a letter.";
        end,

        Parse = function(p5) -- Line: 28, Name: Parse
            return p5;
        end
    };
    u2:RegisterType("storedKey", v6);
    u2:RegisterType("storedKeys", Util.MakeListableType(v6));
end;