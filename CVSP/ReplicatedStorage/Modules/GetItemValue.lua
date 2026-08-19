-- Decompiled with Potassium's decompiler.

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules");
local TowerData = require(Modules.TowerData);
local PlantData = require(Modules.PlantData);
local GameRules = require(Modules.GameRules);

return function(p1) -- Line: 10
    -- upvalues: GameRules (copy), TowerData (copy), PlantData (copy)
    local v2 = GameRules.sizeScalingMultiplier(p1.SizeScaling);
    local itemName = p1.itemName;
    local v3 = TowerData.getData(itemName) or PlantData.getData(itemName);

    return not (v3 and (v2 and itemName)) and 1 or v3.BaseValue.Value * v2;
end;