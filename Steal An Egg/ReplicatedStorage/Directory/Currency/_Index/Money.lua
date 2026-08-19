-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
local Rarity = require(ReplicatedStorage.Directory.Rarity);
require(script.Parent.Parent.Types.Interface);
local Default = require(script.Parent.Parent.BaseConfigs.Default);
local InstanceCache = require(ReplicatedStorage.Library.Modules.Packages.InstanceCache);
local Constants = require(ReplicatedStorage.Library.Globals.Constants);
local Money = ReplicatedStorage.Assets.Models.Orbs.Money;
local v1 = {
    Icon = "rbxassetid://112678965246772",
    DisplayName = script.Name,
    Instance = Constants.IS_SERVER and Money and Money or InstanceCache.new(Money, 1):SetExpandAmount(1),
    Rarity = Rarity.Rarities.Uncommon
};

return setmetatable(v1, {
    __index = Default
});