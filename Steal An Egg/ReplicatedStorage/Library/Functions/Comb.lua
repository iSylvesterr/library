-- Decompiled with Potassium's decompiler.

local Factorial = require(script.Parent.Factorial);

return function(p1, p2) -- Line: 3, Name: Comb
    -- upvalues: Factorial (copy)
    return Factorial(p1) / (Factorial(p2) * Factorial(p1 - p2));
end;