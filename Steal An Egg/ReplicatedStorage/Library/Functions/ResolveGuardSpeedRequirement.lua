-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Asserts = require(ReplicatedStorage.Library.Asserts);
local GuardEscapePrediction = require(ReplicatedStorage.Library.Modules.GuardAreas.GuardEscapePrediction);
require(ReplicatedStorage.Library.Modules.GuardAreas.Types.Interface);
local TreadmillUtil = require(ReplicatedStorage.Library.Util.TreadmillUtil);

return function(p1) -- Line: 16
    -- upvalues: Asserts (copy), GuardEscapePrediction (copy), TreadmillUtil (copy)
    Asserts.table(p1);
    local v2 = GuardEscapePrediction.ResolvePlayerWalkSpeedRequirement(p1, 0.9);
    local v3 = TreadmillUtil.WalkSpeedToSpeedPower(v2);

    return TreadmillUtil.RoundSpeedPowerRequirement(v3 * 1.05);
end;