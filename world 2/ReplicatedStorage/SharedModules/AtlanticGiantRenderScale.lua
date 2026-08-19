-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local AtlanticGiantGrowth = require(ReplicatedStorage.SharedModules.AtlanticGiantGrowth);
local AtlanticGiantGrowthFlags = require(ReplicatedStorage.SharedModules.Flags.AtlanticGiantGrowthFlags);

return function(p1) -- Line: 37
    -- upvalues: AtlanticGiantGrowth (copy), AtlanticGiantGrowthFlags (copy)
    return AtlanticGiantGrowth(p1) ^ AtlanticGiantGrowthFlags.VisualExponent:Get();
end;