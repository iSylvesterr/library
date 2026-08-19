-- Decompiled with Potassium's decompiler.

require(script.Parent.Parent.Memory.Scope);
local Symbol = require(script.Parent.Parent.Parent.Modules.Symbol);

return function(u1) -- Line: 10, Name: Component
    -- upvalues: Symbol (copy)
    if not u1.Init then
        error("Component requires an Init() method");
    end;

    if not u1.Construct then
        error("Component requires a Construct() method");
    end;

    u1.__index = u1;
    local Component = Symbol.new("Component");

    return setmetatable({}, {
        __call = function(p2, p3, p4) -- Line: 28, Name: __call
            -- upvalues: u1 (copy)
            local v5 = setmetatable({}, u1);
            v5:Init(p3, p4);

            return v5:Construct(p3, p4);
        end,

        __index = function(p6, p7) -- Line: 36, Name: __index
            -- upvalues: Component (copy), u1 (copy)
            if p7 == "__SEAM_COMPONENT" then
                return Component;
            end;

            return u1[p7];
        end,

        __newindex = function(p8, p9, p10) -- Line: 44, Name: __newindex
            -- upvalues: u1 (copy)
            u1[p9] = p10;
        end
    });
end;