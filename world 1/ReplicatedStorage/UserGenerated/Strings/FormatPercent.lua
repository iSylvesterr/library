-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FormatFigures = require(ReplicatedStorage.UserGenerated.Strings.FormatFigures);

return function(p1) -- Line: 24, Name: FormatPercent
    -- upvalues: FormatFigures (copy)
    return FormatFigures(p1 * 100, 4, 5) .. "%";
end;