-- Decompiled with Potassium's decompiler.

local Default = require(script.Parent.BaseConfigs.Default);
require(script.Parent.Parent.Rarity);
require(script.Parent.Types.Interface);

return function(p1) -- Line: 19
    -- upvalues: Default (copy)
    return setmetatable(p1, {
        __index = Default
    });
end;