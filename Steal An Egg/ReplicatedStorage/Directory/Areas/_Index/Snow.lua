-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Guards = require(ReplicatedStorage.Directory.Guards);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;

return {
    Emoji = "😟",
    Icon = "rbxassetid://94742267172174",
    IndexBatGearId = "Snow Bat",
    DisplayName = script.Name,
    DropTable = { { "Penguin", 29.444067 }, { "Walrus", 21.570745 }, { "Polar Bear", 18.335133 }, { "Sabertooth Tiger", 14.020984 }, { "Mammoth", 11.86391 }, { "Colossal Mammoth", 4.171033 }, { "Yeti", 0.371904 }, { "Ice Dragon", 0.222224 } },
    GuardId = Guards.Directory.Snow._id,
    Rarity = Rarities.Legendary
};