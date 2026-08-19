-- Decompiled with Potassium's decompiler.

local SystemGameConfig = require(game.ReplicatedFirst.AllSideCode.UtilsSystem).SystemGameConfig;

return {
    FootLand = function(p1, p2) -- Line: 21, Name: FootLand
        -- upvalues: SystemGameConfig (copy)
        if SystemGameConfig.GetValue({ "FootStep", "启用" }) == false then
        end;
    end
};