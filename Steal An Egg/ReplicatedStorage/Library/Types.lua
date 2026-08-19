-- Decompiled with Potassium's decompiler.

local v1 = {};
setmetatable(v1, {
    __index = function(p2, p3) -- Line: 3
        error((`Unknown Type '{p3}'`));
    end
});
table.freeze(v1);

return v1;