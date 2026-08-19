-- Decompiled with Potassium's decompiler.

local UtilsSystem = require(game.ReplicatedFirst.AllSideCode.UtilsSystem);
local Log = UtilsSystem.Log;
local SystemPaidPotionDisplay = UtilsSystem.SystemPaidPotionDisplay;
task.spawn(function() -- Line: 21
    -- upvalues: SystemPaidPotionDisplay (copy), Log (copy)
    if not SystemPaidPotionDisplay.Init() then
        Log.warn("[PaidPotionDisplay] Init failed");
    end;
end);