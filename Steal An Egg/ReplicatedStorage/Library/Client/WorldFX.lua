-- Decompiled with Potassium's decompiler.

local v1 = {
    Confetti = require(script:WaitForChild("Confetti")),
    Crater = require(script:WaitForChild("Crater")),
    Damage = require(script:WaitForChild("Damage")),
    RewardBillboard = require(script:WaitForChild("RewardBillboard")),
    RewardItem = require(script:WaitForChild("RewardItem")),
    Selection = require(script:WaitForChild("Selection")),
    PlayerTeleport = require(script:WaitForChild("PlayerTeleport")),
    Poof = require(script:WaitForChild("Poof")),
    SmallPuff = require(script:WaitForChild("SmallPuff")),
    Pads = require(script:WaitForChild("Pads")),
    Sparkles = require(script:WaitForChild("Sparkles")),
    ArrowPointer3D = require(script:WaitForChild("ArrowPointer3D")),
    OfflineGeneratedMoney = require(script.OfflineGeneratedMoney),
    OfflineMoneyClaimVisual = require(script.OfflineMoneyClaimVisual)
};
require(game.ReplicatedStorage:WaitForChild("ModuleLoader"))(script, v1, {
    warn = function(...) -- Line: 21
        warn(...);
    end
});

return v1;