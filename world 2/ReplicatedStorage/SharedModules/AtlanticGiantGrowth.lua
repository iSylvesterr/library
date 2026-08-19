-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AtlanticGiantGrowthFlags = require(ReplicatedStorage.SharedModules.Flags.AtlanticGiantGrowthFlags);
local log = math.log;

return function(p1) -- Line: 21
    -- upvalues: AtlanticGiantGrowthFlags (copy), log (copy)
    if p1 <= 0 then
        return 1;
    end;

    if not AtlanticGiantGrowthFlags.Enabled:Get() then
        return 1;
    end;

    local v2 = AtlanticGiantGrowthFlags.Coefficient:Get();
    local v3 = AtlanticGiantGrowthFlags.Timescale:Get();
    local v4 = AtlanticGiantGrowthFlags.Exponent:Get();
    local v5 = 1 + v2 * log(1 + p1 / v3) ^ v4;
    local v6 = AtlanticGiantGrowthFlags.MaxMultiplier:Get();
    local v7 = math.max(v6, 1);

    return math.min(v5, v7);
end;