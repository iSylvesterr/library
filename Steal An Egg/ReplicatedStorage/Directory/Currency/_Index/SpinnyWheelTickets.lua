-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local Rarity = require(ReplicatedStorage.Directory.Rarity);

return setmetatable({
    Icon = "rbxassetid://120222769031450",
    DisplayName = script.Name,
    Rarity = Rarity.Rarities.SuperRare
}, {
    __index = Default
});