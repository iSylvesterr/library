-- Decompiled with Potassium's decompiler.

local Parent = script.Parent.Parent;
require(Parent.PubTypes);
local applyInstanceProps = require(Parent.Instances.applyInstanceProps);

return function(u1) -- Line: 12, Name: Hydrate
    -- upvalues: applyInstanceProps (copy)
    return function(p2) -- Line: 13
        -- upvalues: applyInstanceProps (ref), u1 (copy)
        applyInstanceProps(p2, u1);

        return u1;
    end;
end;