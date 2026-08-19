-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local OvertimeGrowthFlags = require(ReplicatedStorage.SharedModules.Flags.OvertimeGrowthFlags);
local u1 = { { 0, 1 }, { 3, 1.5 }, { 12, 2 }, { 24, 2.5 }, { 74, 3 }, { 200, 3.5 }, { 500, 4 }, { 1000, 4.5 }, { 2000, 5 } };

return function(p2) -- Line: 10
    -- upvalues: OvertimeGrowthFlags (copy), u1 (copy)
    if not OvertimeGrowthFlags.Enabled:Get() then
        return 1;
    end;

    if p2 <= 0 then
        return 1;
    end;

    local v3 = p2 / 3600;

    if v3 >= 2000 then
        return math.log(v3 / 2000) * 0.5 / 0.6931471805599453 + 5;
    end;

    for i = 2, #u1 do
        if v3 <= u1[i][1] then
            local v4 = u1[i - 1][1];
            local v5 = u1[i - 1][2];

            return v5 + (u1[i][2] - v5) * (v3 - v4) / (u1[i][1] - v4);
        end;
    end;

    return 5;
end;