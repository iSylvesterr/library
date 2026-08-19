-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local RoundFigures = require(ReplicatedStorage.Library.Functions.RoundFigures);

function FloorFigures(p1, p2, p3)
    -- upvalues: RoundFigures (copy)
    return RoundFigures(p1, p2, p3, math.floor);
end;

return FloorFigures;