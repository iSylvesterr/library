-- Decompiled with Potassium's decompiler.

return table.freeze((setmetatable({}, {
    __index = function(p1, p2) -- Line: 2, Name: __index
        error(`Unknown Module '{p2}'`);
    end
})));