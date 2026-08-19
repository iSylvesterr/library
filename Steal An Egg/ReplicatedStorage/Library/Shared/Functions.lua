-- Decompiled with Potassium's decompiler.

local v1 = {
    PromptPurchase = require(script:WaitForChild("PromptPurchase")),
    ApplyRarityColor = require(script:WaitForChild("ApplyRarityColor")),
    GetProductByID = require(script:WaitForChild("GetProductByID")),
    GetGamepassByID = require(script:WaitForChild("GetGamepassByID"))
};
require(game.ReplicatedStorage:WaitForChild("ModuleLoader"))(script, v1, {
    warn = function(...) -- Line: 8, Name: warn
        warn(...);
    end
});

return v1;