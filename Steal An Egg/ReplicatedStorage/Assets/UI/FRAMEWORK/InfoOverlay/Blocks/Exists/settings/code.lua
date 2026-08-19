-- Decompiled with Potassium's decompiler.

local Functions = require(game:GetService("ReplicatedStorage").Library.Functions);

return function(p1, p2, p3) -- Line: 3, Name: updateTitle
    -- upvalues: Functions (copy)
    p1.title.Text = `{Functions.NumberShorten(p3)} Exist{p3 == 1 and "s" or ""}`;
end;