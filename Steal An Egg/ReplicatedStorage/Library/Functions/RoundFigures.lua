-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local NiceExp10 = require(ReplicatedStorage.Library.Functions.NiceExp10);

function RoundFigures(p1, p2, p3, p4)
    -- upvalues: NiceExp10 (copy)
    local v5 = p3 or 1;
    local v6 = p4 or math.round;
    local v7 = math.sign(p1);

    if v7 == 0 then
        return 0;
    end;

    local v8 = p1 * v7;
    local v9 = math.log10(v8);
    local v10 = math.floor(v9) - (p2 or 3) + 1;

    if v5 ~= 1 then
        v8 = v8 / v5;
    end;

    return NiceExp10(v6((NiceExp10(v8, -v10))) * v5, v10) * v7;
end;

return RoundFigures;