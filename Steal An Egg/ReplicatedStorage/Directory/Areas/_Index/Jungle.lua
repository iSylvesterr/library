-- Decompiled with Potassium's decompiler.

local ReplicatedStorage = game:GetService("ReplicatedStorage");
require(script.Parent.Parent.Types.Interface);
local Guards = require(ReplicatedStorage.Directory.Guards);
local Rarities = require(ReplicatedStorage.Directory.Rarity).Rarities;

return {
    Emoji = "😬",
    Icon = "rbxassetid://114796463507768",
    IndexBatGearId = "Jungle Bat",
    DisplayName = script.Name,
    DropTable = { { "Chimpanzee", 26.006779 }, { "Toucan", 20.005214 }, { "Crocodile", 17.004432 }, { "Gorilla", 13.003389 }, { "Orangutini Ananassini", 11.002868 }, { "Spider", 7.852047 }, { "Tiger", 5.001304 }, { "Warden", 0.123968 } },
    GuardId = Guards.Directory.Jungle._id,
    Rarity = Rarities.Epic
};