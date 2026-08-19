-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local FormatAbbreviated = require(ReplicatedStorage.UserGenerated.Strings.FormatAbbreviated);

return function(p1) -- Line: 24, Name: FormatOdds
    -- upvalues: FormatAbbreviated (copy)
    local v2 = type(p1) == "number";
    assert(v2);

    return p1 == 0 and "0" or (p1 == (1 / 0) and "Infinity" or (p1 == (-1 / 0) and "-Infinity" or (p1 ~= p1 and "NaN" or "1/" .. FormatAbbreviated(1 / p1))));
end;